package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import Controls;

using StringTools;

class NotesSubState extends MusicBeatSubstate
{
	var camFollowPos:FlxObject;
	var skinSelected:Int = ClientPrefs.curSkin;
	var startPos:FlxObject;
	private static var curSelected:Int = 0;
	private static var typeSelected:Int = 0;
	private var grpNumbers:FlxTypedGroup<Alphabet>;
	private var skinText:Alphabet = new Alphabet(0, 0, 'Arrow', false, false);
	var dumbText:Alphabet = new Alphabet(0, 0, 'Note Skin:', true, false);
	var note:FlxSprite;
	var ln:FlxSprite;
	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;
	private var grpNotes:FlxTypedGroup<FlxSprite>;
	private var grpLN:FlxTypedGroup<FlxSprite>;
	private var shaderArray:Array<ColorSwap> = [];
	var curValue:Float = 0;
	var holdTime:Float = 0;
	var nextAccept:Int = 5;
	private var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));

	var blackBG:FlxSprite;
	var hsbText:Alphabet;

	var posX = 230;
	public function new() {
		super();
		skinSelected = ClientPrefs.curSkin;
		startPos = new FlxObject(650,350,1,1);
		add(startPos);
		camFollowPos = new FlxObject(575, 325, 1, 1);
		add(camFollowPos);
		FlxG.camera.follow(camFollowPos, null, 0.05);
		
		bg.color = 0xFFea71fd;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		
		blackBG = new FlxSprite(posX - 25).makeGraphic(870, 175, FlxColor.BLACK);
		blackBG.alpha = 0.4;
		add(blackBG);

		grpNotes = new FlxTypedGroup<FlxSprite>();
		add(grpNotes);
		grpLN = new FlxTypedGroup<FlxSprite>();
		add(grpLN);
		grpNumbers = new FlxTypedGroup<Alphabet>();
		add(grpNumbers);

		dumbText.x = 275;
		dumbText.y = 575;
		add(dumbText);
		selectorLeft = new Alphabet(750, 525, '<', false, false);
		add(selectorLeft);
		add(skinText);
		skinText.x = selectorLeft.x + 50;
		skinText.y = selectorLeft.y;
		selectorRight = new Alphabet(965, 525, '>', false, false);
		add(selectorRight);
		for (i in 0...ClientPrefs.arrowHSV.length) {
			var yPos:Float = (125 * i) + 35;
			for (j in 0...3) {
				var optionText:Alphabet = new Alphabet(0, yPos + 60, Std.string(ClientPrefs.arrowHSV[i][j]), true);
				optionText.x = posX + (225 * j) + 250;
				grpNumbers.add(optionText);
			}

			note = new FlxSprite(posX, yPos);
			note.frames = Paths.getSparrowAtlas('noteSkins/' + CoolUtil.skinTypes[skinSelected]);
			var animations:Array<String> = ['purple0', 'blue0', 'green0', 'red0'];
			note.animation.addByPrefix('idle', animations[i]);
			note.animation.play('idle');
			if(CoolUtil.skinTypes[skinSelected] != 'Pixel')
				note.antialiasing = ClientPrefs.globalAntialiasing;
			else
				note.antialiasing = false;
			grpNotes.add(note);
			
			ln = new FlxSprite(posX + 150, yPos + 50);
			ln.frames = Paths.getSparrowAtlas('noteSkins/' + CoolUtil.skinTypes[skinSelected]);
			var lnAnim:Array<String> = ['pruple end hold', 'blue hold end', 'green hold end', 'red hold end'];
			ln.animation.addByPrefix('idle', lnAnim[i]);
			ln.animation.play('idle');
			if(CoolUtil.skinTypes[skinSelected] != 'Pixel')
				ln.antialiasing = ClientPrefs.globalAntialiasing;
			else
				ln.antialiasing = false;
			grpLN.add(ln);

			var newShader:ColorSwap = new ColorSwap();
			note.shader = newShader.shader;
			ln.shader = newShader.shader;
			newShader.hue = ClientPrefs.arrowHSV[i][0] / 360;
			newShader.saturation = ClientPrefs.arrowHSV[i][1] / 100;
			newShader.brightness = ClientPrefs.arrowHSV[i][2] / 100;
			shaderArray.push(newShader);
		}

		hsbText = new Alphabet(0, 0, "Hue    Saturation  Brightness", false, false, 0, 0.65);
		hsbText.x = posX + 240;
		add(hsbText);

		changeSkin();
		changeSelection();
	}

	var changingNote:Bool = false;
	override function update(elapsed:Float) {
		if(changingNote) {
			if(holdTime < 0.5) {
				if(controls.UI_LEFT_P) {
					updateValue(-1);
					FlxG.sound.play(Paths.sound('scrollMenu'));
				} else if(controls.UI_RIGHT_P) {
					updateValue(1);
					FlxG.sound.play(Paths.sound('scrollMenu'));
				}
				else if (controls.RESET && curSelected != 4) {
					resetValue(curSelected, typeSelected);
					FlxG.sound.play(Paths.sound('scrollMenu'));
				}
				if(controls.UI_LEFT_R || controls.UI_RIGHT_R) {
					holdTime = 0;
				} else if(controls.UI_LEFT || controls.UI_RIGHT) {
					holdTime += elapsed;
				}
			} else {
				var add:Float = 90;
				switch(typeSelected) {
					case 1 | 2: add = 50;
				}
				if(controls.UI_LEFT) {
					updateValue(elapsed * -add);
				} else if(controls.UI_RIGHT) {
					updateValue(elapsed * add);
				}
				if(controls.UI_LEFT_R || controls.UI_RIGHT_R) {
					FlxG.sound.play(Paths.sound('scrollMenu'));
					holdTime = 0;
				}
			}
		} else {
			if (controls.UI_UP_P) {
				changeSelection(-1);
				FlxG.camera.follow(camFollowPos, null, 0.05);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			if (controls.UI_DOWN_P) {
				changeSelection(1);
				FlxG.camera.follow(camFollowPos, null, 0.05);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			if (controls.UI_LEFT_P) {
				if(curSelected != 4)
					changeType(-1);
				else
					changeSkin(-1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			if (controls.UI_RIGHT_P) {
				if(curSelected != 4)
					changeType(1);
				else
					changeSkin(1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			if (controls.RESET && curSelected != 4) {
				for (i in 0...3) {
					resetValue(curSelected, i);
				}
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			if (controls.ACCEPT && nextAccept <= 0 && curSelected != 4) {
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changingNote = true;
				holdTime = 0;
				for (i in 0...grpNumbers.length) {
					var item = grpNumbers.members[i];
					item.alpha = 0;
					if ((curSelected * 3) + typeSelected == i) {
						item.alpha = 1;
						item.scale.set(1, 1);
					}
				}
				for (i in 0...grpNotes.length) {
					var item = grpNotes.members[i];
					item.alpha = 0;
					grpLN.members[i].alpha = 0;
					if (curSelected == i) {
						item.alpha = 1;
						grpLN.members[i].alpha = 1;
					}
					skinText.alpha = 0;
					dumbText.alpha = 0;
				}
				super.update(elapsed);
				return;
			}
		}

		if (controls.BACK || (changingNote && controls.ACCEPT)) {
			if(!changingNote) {
				FlxG.camera.follow(startPos, null, 0.05);
				close();
			} else {
				changeSelection();
			}
			changingNote = false;
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}

		if(nextAccept > 0) {
			nextAccept -= 1;
		}
		super.update(elapsed);
	}
	function changeSkin(change:Int = 0)
	{
		skinSelected += change;
		if(skinSelected < 0)
			skinSelected = CoolUtil.skinTypes.length - 1;
		else if(skinSelected >= CoolUtil.skinTypes.length)
			skinSelected = 0;
		remove(skinText);
		skinText = new Alphabet(0, 0, CoolUtil.skinTypes[skinSelected], false, false);
		skinText.x = selectorLeft.x + 45;
		skinText.y = selectorLeft.y;
		add(skinText);
		if(CoolUtil.skinTypes[skinSelected] != 'Default')
		{
			remove(selectorRight);
			selectorRight = new Alphabet(965, 525, '>', false, false);
			add(selectorRight);
		}
		else
		{
			remove(selectorRight);
			selectorRight = new Alphabet(1015, 525, '>', false, false);
			add(selectorRight);
		}
		ClientPrefs.curSkin = skinSelected;

		for (i in 0...grpNotes.length)
		{
			var item = grpNotes.members;
			var animations:Array<String> = ['purple0', 'blue0', 'green0', 'red0'];
			var lnAnim:Array<String> = ['pruple end hold', 'blue hold end', 'green hold end', 'red hold end'];
			for (j in 0...animations.length)
			{
				item[j].frames = Paths.getSparrowAtlas('noteSkins/' + CoolUtil.skinTypes[skinSelected]);
				item[j].animation.addByPrefix('idle', animations[j]);
				item[j].animation.play('idle');
				grpLN.members[j].frames = Paths.getSparrowAtlas('noteSkins/' + CoolUtil.skinTypes[skinSelected]);
				grpLN.members[j].animation.addByPrefix('idle', lnAnim[j]);
				grpLN.members[j].animation.play('idle');
				if(CoolUtil.skinTypes[skinSelected] != 'Pixel')
					grpLN.members[j].antialiasing = ClientPrefs.globalAntialiasing;
				else
					grpLN.members[j].antialiasing = false;
				if(CoolUtil.skinTypes[skinSelected] != 'Pixel')
					item[j].antialiasing = ClientPrefs.globalAntialiasing;
				else
					item[j].antialiasing = false;
			}
		}
	}

	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = ClientPrefs.arrowHSV.length;
		if (curSelected >= ClientPrefs.arrowHSV.length + 1)
			curSelected = 0;
		if (curSelected != 4)
			curValue = ClientPrefs.arrowHSV[curSelected][typeSelected];
		updateValue();

		for (i in 0...grpNumbers.length) {
			var item = grpNumbers.members[i];
			item.alpha = 0.6;
			item.scale.set(0.75, 0.75);
			if ((curSelected * 3) + typeSelected == i) {
				item.alpha = 1;
				item.scale.set(1, 1);
			}
		}
		for (i in 0...grpNotes.length) {
			var item = grpNotes.members[i];
			item.alpha = 0.6;
			item.scale.set(0.5, 0.5);
			grpLN.members[i].alpha = 0.6;
			grpLN.members[i].scale.set(0.5, 0.5);
			if (curSelected == i && curSelected != 4) {
				item.alpha = 1;
				item.scale.set(0.75, 0.75);
				grpLN.members[i].alpha = 1;
				grpLN.members[i].scale.set(0.75, 0.75);
				hsbText.y = item.y - 70;
				blackBG.y = item.y - 10;
			}
			if(curSelected != 4)
			{
				selectorLeft.alpha = 0;
				selectorRight.alpha = 0;
				skinText.scale.set(0.75, 0.75);
				skinText.alpha = 0.6;
				dumbText.alpha = 0.6;
				dumbText.scale.set(0.75, 0.75);
				hsbText.visible = true;
				blackBG.visible = true;
			}
			else
			{
				selectorLeft.alpha = 1;
				selectorRight.alpha = 1;
				skinText.alpha = 1;
				item.alpha = 0.6;
				grpLN.members[i].alpha = 0.6;
				skinText.scale.set(1,1);
				dumbText.alpha = 1;
				dumbText.scale.set(1,1);
				hsbText.visible = false;
				blackBG.visible = false;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	function changeType(change:Int = 0) {
		typeSelected += change;
		if (typeSelected < 0)
			typeSelected = 2;
		if (typeSelected > 2)
			typeSelected = 0;
		if (curSelected != 4)
			curValue = ClientPrefs.arrowHSV[curSelected][typeSelected];
		updateValue();

		for (i in 0...grpNumbers.length) {
			var item = grpNumbers.members[i];
			item.alpha = 0.6;
			item.scale.set(0.75,0.75);
			if ((curSelected * 3) + typeSelected == i && curSelected != 4) {
				item.alpha = 1;
				item.scale.set(1, 1);
			}
			else if (curSelected == 4)
			{
				item.scale.set(0.75, 0.75);
				item.alpha = 0.6;
			}
		}
	}

	function resetValue(selected:Int, type:Int) {
		curValue = 0;
		ClientPrefs.arrowHSV[selected][type] = 0;
		switch(type) {
			case 0: shaderArray[selected].hue = 0;
			case 1: shaderArray[selected].saturation = 0;
			case 2: shaderArray[selected].brightness = 0;
		}

		var item = grpNumbers.members[(selected * 3) + type];
		item.changeText('0');
		item.offset.x = (40 * (item.lettersArray.length - 1)) / 2;
	}
	function updateValue(change:Float = 0) {
		curValue += change;
		var roundedValue:Int = Math.round(curValue);
		var max:Float = 180;
		switch(typeSelected) {
			case 1 | 2: max = 100;
		}

		if(roundedValue < -max) {
			curValue = -max;
		} else if(roundedValue > max) {
			curValue = max;
		}
		roundedValue = Math.round(curValue);
		if (curSelected != 4)
			ClientPrefs.arrowHSV[curSelected][typeSelected] = roundedValue;

		if (curSelected != 4)
		{
			switch(typeSelected) {
				case 0: shaderArray[curSelected].hue = roundedValue / 360;
				case 1: shaderArray[curSelected].saturation = roundedValue / 100;
				case 2: shaderArray[curSelected].brightness = roundedValue / 100;
			}
		}
		if (curSelected != 4)
		{
			var item = grpNumbers.members[(curSelected * 3) + typeSelected];
			item.changeText(Std.string(roundedValue));
			item.offset.x = (40 * (item.lettersArray.length - 1)) / 2;
			if(roundedValue < 0) item.offset.x += 10;
		}
	}
}