package states.stages;

import states.PlayState;
import states.stages.objects.*;

class CamelliaConcert extends BaseStage
{
	public static var curStage:String = '';
	//camellia concert crowds
	var frontCrowd:FlxSprite;
	var backCrowd:FlxSprite;
	var zooming:Bool = false;
	//other concert shit
	var sky:FlxSprite;
	var farbuildings:FlxSprite;
	var buildings:FlxSprite;
	var stage:FlxSprite;
	//the speakers
	var speakerLeft:FlxSprite;
	var speakerRight:FlxSprite;
	var speakerLeft2:FlxSprite;
	var speakerRight2:FlxSprite;
	//Light stuff
	var light:FlxSprite;
	var citycycle:Int = 1;
	var lightcycle:String = ClientPrefs.data.lightcycle;

	//Star Stuff
	var star:FlxSprite;
	var spin:Bool = false;
	var kuraCool:Bool = false;
	var kurama:Bool = false;
	override function create()
	{
		sky = new FlxSprite(60, 40).loadGraphic(Paths.image('stages/camellia/concert/sky'));
		sky.scale.set(1.75, 1.75);
		sky.antialiasing = ClientPrefs.data.antialiasing;
		add(sky);

		farbuildings = new FlxSprite(60, 40).loadGraphic(Paths.image('stages/camellia/concert/farbuildings'));
		farbuildings.scale.set(1.75, 1.75);
		farbuildings.antialiasing = ClientPrefs.data.antialiasing;
		add(farbuildings);

		buildings = new FlxSprite(60, 40).loadGraphic(Paths.image('stages/camellia/concert/buildings'));
		buildings.scale.set(1.75, 1.75);
		buildings.antialiasing = ClientPrefs.data.antialiasing;
		add(buildings);

		light = new FlxSprite(60, 40).loadGraphic(Paths.image('stages/camellia/concert/light'));
		light.scale.set(1.75, 1.75);
		light.antialiasing = ClientPrefs.data.antialiasing;
		add(light);

		backCrowd = new FlxSprite(60, 590).loadGraphic(Paths.image('stages/camellia/concert/backcrowd'));
		backCrowd.scale.set(1.75, 1.75);
		backCrowd.antialiasing = ClientPrefs.data.antialiasing;
		add(backCrowd);
		
		star = new FlxSprite(900, 2270).loadGraphic(Paths.image('stages/camellia/concert/ninestars'));
		star.scale.set(2.5, 2.5);
		star.antialiasing = ClientPrefs.data.antialiasing;
		add(star);

		stage = new FlxSprite(-950, -505).loadGraphic(Paths.image('stages/camellia/concert/stage'));
		stage.scale.set(0.85, 0.85);
		stage.antialiasing = ClientPrefs.data.antialiasing;
		add(stage);

		speakerLeft = new FlxSprite(-150, 150);
		speakerLeft.frames = Paths.getSparrowAtlas('stages/camellia/concert/speaker_left');
		speakerLeft.animation.addByPrefix('bop', 'speaker', 24, false);
		speakerLeft.scale.set(0.75, 0.75);
		speakerLeft.antialiasing = ClientPrefs.data.antialiasing;
		add(speakerLeft);

		speakerRight = new FlxSprite(1530, 150);
		speakerRight.frames = Paths.getSparrowAtlas('stages/camellia/concert/speaker_left');
		speakerRight.animation.addByPrefix('bop', 'speaker', 24, false);
		speakerRight.flipX = true;
		speakerRight.scale.set(0.75, 0.75);
		speakerRight.antialiasing = ClientPrefs.data.antialiasing;
		add(speakerRight);

		speakerLeft2 = new FlxSprite(140, 250);
		speakerLeft2.frames = Paths.getSparrowAtlas('stages/camellia/concert/speaker_left');
		speakerLeft2.animation.addByPrefix('bop', 'speaker', 24, false);
		speakerLeft2.scale.set(0.5, 0.5);
		speakerLeft2.antialiasing = ClientPrefs.data.antialiasing;
		add(speakerLeft2);

		speakerRight2 = new FlxSprite(1260, 250);
		speakerRight2.frames = Paths.getSparrowAtlas('stages/camellia/concert/speaker_left');
		speakerRight2.animation.addByPrefix('bop', 'speaker', 24, false);
		speakerRight2.flipX = true;
		speakerRight2.scale.set(0.5, 0.5);
		speakerRight2.antialiasing = ClientPrefs.data.antialiasing;
		add(speakerRight2);

	}
	
	override function createPost()
	{
		frontCrowd = new FlxSprite(60, 1000).loadGraphic(Paths.image('stages/camellia/concert/frontcrowd'));
		frontCrowd.alpha = 0;
		frontCrowd.scale.set(1.75, 1.75);
		frontCrowd.antialiasing = ClientPrefs.data.antialiasing;
		add(frontCrowd);
	}

	override function update(elapsed:Float)
	{
		if(kurama) {
			boyfriend.color = 0xff474747;
			dad.color = 0xff474747;
			gf.color = 0xff474747;
		}
		if (zooming) {
			game.camZooming = false;
		}

	}

	override function stepHit()
	{
		if (curStep % 1 == 0 && spin) {
			spin = false;
			FlxTween.tween(star, {angle: 360}, 5, {ease: FlxEase.backInOut, onComplete: function(twn:FlxTween)
			{
				FlxTween.tween(star, {angle: 0}, 0.01, {ease: FlxEase.linear, onComplete: function(twn:FlxTween)
				{
					spin = true;
				}});
			}});
		}

		if (FlxG.keys.justPressed.LEFT && lightcycle == 'Player Lights') {
			light.color = 0x00b1ff;
		} else if (FlxG.keys.justPressed.UP && lightcycle == 'Player Lights') {
			light.color = 0xff432c;
		} else if (FlxG.keys.justPressed.DOWN && lightcycle == 'Player Lights') {
			light.color = 0xff30fa;
		} else if (FlxG.keys.justPressed.RIGHT && lightcycle == 'Player Lights') {
			light.color = 0x00fd86;
		}
	}
	
	override function beatHit()
	{
		if (curBeat % 2 == 0) {
			speakerLeft.animation.play('bop');
			speakerRight.animation.play('bop');
			speakerLeft2.animation.play('bop');
			speakerRight2.animation.play('bop');
		} else if (curBeat % 3 == 0 && citycycle == 1 && lightcycle == 'Auto Lights') {
			light.color = 0xff00b1ff; citycycle = 2;
		} else if (curBeat % 3 == 0 && citycycle == 2 && lightcycle == 'Auto Lights') {
			light.color =0xff432c; citycycle = 3;
		} else if (curBeat % 3 == 0 && citycycle == 3 && lightcycle == 'Auto Lights') {
			light.color = 0xff30fa; citycycle = 4;
		} else if (curBeat % 3 == 0 && citycycle == 4 && lightcycle == 'Auto Lights') {
			light.color =0x00fd86; citycycle = 5;
		} else if (curBeat % 3 == 0 && citycycle == 5 && lightcycle == 'Auto Lights') {
			light.color = 0xffa71f; citycycle = 1;
		} 
		else if (curBeat % 3 == 0 && citycycle == 1 && lightcycle == 'Slow Lights') {
			FlxTween.color(light, 0.5, 0xffffa71f, 0xff00b1ff); citycycle = 2;
		} else if (curBeat % 3 == 0 && citycycle == 2 && lightcycle == 'Slow Lights') {
			FlxTween.color(light, 0.5, 0xff00b1ff, 0xffff432c); citycycle = 3;
		} else if (curBeat % 3 == 0 && citycycle == 3 && lightcycle == 'Slow Lights') {
			FlxTween.color(light, 0.5, 0xffff432c, 0xffff30fa); citycycle = 4;
		} else if (curBeat % 3 == 0 && citycycle == 4 && lightcycle == 'Slow Lights') {
			FlxTween.color(light, 0.5, 0xffff30fa, 0xff00fd86); citycycle = 5;
		} else if (curBeat % 3 == 0 && citycycle == 5 && lightcycle == 'Slow Lights') {
			FlxTween.color(light, 0.5, 0xff00fd86, 0xffffa71f); citycycle = 1;
		}
		if (curBeat % 2 == 0 && zooming) {
			//Backcrowd bopping
			FlxTween.tween(backCrowd.scale, {x: 1.85, y: 1.85}, 0.01, {ease: FlxEase.linear});
			FlxTween.tween(backCrowd.scale, {x: 1.75, y: 1.75}, 0.5, {ease: FlxEase.quartOut});
			//Frontcrowd bopping
			FlxTween.tween(frontCrowd.scale, {x: 1.85, y: 1.85}, 0.01, {ease: FlxEase.linear});
			FlxTween.tween(frontCrowd.scale, {x: 1.75, y: 1.75}, 0.5, {ease: FlxEase.quartOut});
		}
	}

	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float)
	{
		switch(eventName)
		{
			case 'Nine Star Mode':
				if(!kuraCool) {
					kcmMode(Std.parseInt(value1));
				}

				case 'Camellia Zoom':
					var val1:Int = Std.parseInt(value1);
					var val2:Null<Float> = Std.parseFloat(value2);

					if(val2 == null)
						val2 = 0.5;

					if (ClientPrefs.data.camZooms) { // took out camHUD IT'S UNNECESSARY!!
						if (val1 == 1) {
							zooming = true;
							FlxTween.tween(frontCrowd, {y: 760, alpha: 1}, val2, {ease: FlxEase.sineIn});
							FlxTween.tween(camGame, {zoom: 0.41}, val2, {ease: FlxEase.sineIn, onComplete: function(twn:FlxTween)
							{
								defaultCamZoom = camGame.zoom;
							}});
						}
						if (val1 == 2) {
							FlxTween.tween(frontCrowd, {y: 1100, alpha: 0}, val2, {ease: FlxEase.sineOut});
							FlxTween.tween(camGame, {zoom: 0.59}, val2, {ease: FlxEase.sineOut, onComplete: function(twn:FlxTween)
							{
								defaultCamZoom = camGame.zoom;
								zooming = false;
							}});
						}
						if (val1 == 3) {
							zooming = true;
							FlxTween.tween(frontCrowd, {y: 760, alpha: 1}, val2, {ease: FlxEase.sineIn});
							FlxTween.tween(camGame, {zoom: 0.47}, val2, {ease: FlxEase.sineIn});
							{
								zooming = true;
							}};
						}	
		}
	}

	function kcmMode(kuramaInt:Int)
	{
		trace(kuramaInt);
		kuraCool = true;
		if(kuramaInt == 1)
		{
			FlxTween.color(backCrowd, 1.3, FlxColor.WHITE, 0xff474747, {ease: FlxEase.linear});
			FlxTween.color(stage, 1.3, FlxColor.WHITE, 0xff474747, {ease: FlxEase.linear});
			FlxTween.color(speakerLeft, 1.3, FlxColor.WHITE, 0xff474747, {ease: FlxEase.linear});
			FlxTween.color(speakerRight, 1.3, FlxColor.WHITE, 0xff474747, {ease: FlxEase.linear});
			FlxTween.color(speakerLeft2, 1.3, FlxColor.WHITE, 0xff474747, {ease: FlxEase.linear});
			FlxTween.color(speakerRight2, 1.3, FlxColor.WHITE, 0xff474747, {ease: FlxEase.linear});
			FlxTween.color(frontCrowd, 1.3, FlxColor.WHITE, 0xff474747, {ease: FlxEase.linear});
			FlxTween.color(boyfriend, 1.3, FlxColor.WHITE, 0xff474747, {ease: FlxEase.linear});
			FlxTween.color(dad, 1.3, FlxColor.WHITE, 0xff474747, {ease: FlxEase.linear});
			FlxTween.color(gf, 1.3, FlxColor.WHITE, 0xff474747, {ease: FlxEase.linear});
			FlxTween.tween(star, {y: 90}, 2.3, {ease: FlxEase.backInOut, onComplete: function(twn:FlxTween)
			{
				spin = true;
				kuraCool = false;
				kurama = true;
			}});
		}
		if(kuramaInt == 2)
		{
			kurama = false;
			FlxTween.color(backCrowd, 1.3, 0xff474747, 0xFFFFFFFF, {ease: FlxEase.linear});
			FlxTween.color(stage, 1.3, 0xff474747, 0xFFFFFFFF, {ease: FlxEase.linear});
			FlxTween.color(speakerLeft, 1.3, 0xff474747, 0xFFFFFFFF, {ease: FlxEase.linear});
			FlxTween.color(speakerRight, 1.3, 0xff474747, 0xFFFFFFFF, {ease: FlxEase.linear});
			FlxTween.color(speakerLeft2, 1.3, 0xff474747, 0xFFFFFFFF, {ease: FlxEase.linear});
			FlxTween.color(speakerRight2, 1.3, 0xff474747, 0xFFFFFFFF, {ease: FlxEase.linear});
			FlxTween.color(frontCrowd, 1.3, 0xff474747, 0xFFFFFFFF, {ease: FlxEase.linear});
			FlxTween.color(boyfriend, 1.3, 0xff474747, 0xFFFFFFFF, {ease: FlxEase.linear});
			FlxTween.color(dad, 1.3, 0xff474747, 0xFFFFFFFF, {ease: FlxEase.linear});
			FlxTween.color(gf, 1.3, 0xff474747, 0xFFFFFFFF, {ease: FlxEase.linear});
			FlxTween.tween(star, {y: 2230}, 2.3, {ease: FlxEase.backInOut, onComplete: function(twn:FlxTween)
			{
				spin = false;
				kuraCool = false;
			}});
		}
	}
}