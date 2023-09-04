package states.stages;

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
	//var lightcycle:String = ClientPrefs.lightcycle;

	//Star Stuff
	var star:FlxSprite;
	var spin:Bool = false;
	var kuraCool:Bool = false;
	var kurama:Bool = false;
	override function create()
	{
		sky = new FlxSprite(60, 40).loadGraphic(Paths.image('stages/camellia/Week2/sky'));
		sky.scale.set(1.75, 1.75);
		sky.antialiasing = ClientPrefs.data.antialiasing;
		add(sky);

		farbuildings = new FlxSprite(60, 40).loadGraphic(Paths.image('stages/camellia/Week2/farbuildings'));
		farbuildings.scale.set(1.75, 1.75);
		farbuildings.antialiasing = ClientPrefs.data.antialiasing;
		add(farbuildings);

		buildings = new FlxSprite(60, 40).loadGraphic(Paths.image('stages/camellia/Week2/buildings'));
		buildings.scale.set(1.75, 1.75);
		buildings.antialiasing = ClientPrefs.data.antialiasing;
		add(buildings);

		light = new FlxSprite(60, 40).loadGraphic(Paths.image('stages/camellia/Week2/light'));
		light.scale.set(1.75, 1.75);
		light.antialiasing = ClientPrefs.data.antialiasing;
		add(light);

		backCrowd = new FlxSprite(60, 590).loadGraphic(Paths.image('stages/camellia/Week2/backcrowd'));
		backCrowd.scale.set(1.75, 1.75);
		backCrowd.antialiasing = ClientPrefs.data.antialiasing;
		add(backCrowd);
		
		star = new FlxSprite(900, 2270).loadGraphic(Paths.image('stages/camellia/Week2/ninestars'));
		star.scale.set(2.5, 2.5);
		star.antialiasing = ClientPrefs.data.antialiasing;
		add(star);

		stage = new FlxSprite(-950, -505).loadGraphic(Paths.image('stages/camellia/Week2/stage'));
		stage.scale.set(0.85, 0.85);
		stage.antialiasing = ClientPrefs.data.antialiasing;
		add(stage);

		speakerLeft = new FlxSprite(-150, 150);
		speakerLeft.frames = Paths.getSparrowAtlas('stages/camellia/Week2/speaker_left');
		speakerLeft.animation.addByPrefix('bop', 'speaker', 24, false);
		speakerLeft.scale.set(0.75, 0.75);
		speakerLeft.antialiasing = ClientPrefs.data.antialiasing;
		add(speakerLeft);

		speakerRight = new FlxSprite(1530, 150);
		speakerRight.frames = Paths.getSparrowAtlas('stages/camellia/Week2/speaker_left');
		speakerRight.animation.addByPrefix('bop', 'speaker', 24, false);
		speakerRight.flipX = true;
		speakerRight.scale.set(0.75, 0.75);
		speakerRight.antialiasing = ClientPrefs.data.antialiasing;
		add(speakerRight);

		speakerLeft2 = new FlxSprite(140, 250);
		speakerLeft2.frames = Paths.getSparrowAtlas('stages/camellia/Week2/speaker_left');
		speakerLeft2.animation.addByPrefix('bop', 'speaker', 24, false);
		speakerLeft2.scale.set(0.5, 0.5);
		speakerLeft2.antialiasing = ClientPrefs.data.antialiasing;
		add(speakerLeft2);

		speakerRight2 = new FlxSprite(1260, 250);
		speakerRight2.frames = Paths.getSparrowAtlas('stages/camellia/Week2/speaker_left');
		speakerRight2.animation.addByPrefix('bop', 'speaker', 24, false);
		speakerRight2.flipX = true;
		speakerRight2.scale.set(0.5, 0.5);
		speakerRight2.antialiasing = ClientPrefs.data.antialiasing;
		add(speakerRight2);

	}
	
	override function createPost()
	{
		frontCrowd = new FlxSprite(60, 1000).loadGraphic(Paths.image('stages/camellia/Week2/frontcrowd'));
		frontCrowd.alpha = 0;
		frontCrowd.scale.set(1.75, 1.75);
		frontCrowd.antialiasing = ClientPrefs.data.antialiasing;
		add(frontCrowd);
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

	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float)
	{
		switch(eventName)
		{
			case 'Nine Star Mode':
				if(curStage == 'concert' && !kuraCool) {
					kcmMode(Std.parseInt(value1));
				}

			case 'Camellia Zoom':
				if(curStage == 'concert') {
					var val1:Int = Std.parseInt(value1);
					var val2:Null<Float> = Std.parseFloat(value2);

					if(val2 == null)
						val2 = 0.5;

					if (ClientPrefs.data.camZooms) {
						if (val1 == 1) {
							zooming = true;
							FlxTween.tween(frontCrowd, {y: 760, alpha: 1}, val2, {ease: FlxEase.sineIn});
							FlxTween.tween(camGame, {zoom: 0.41}, val2, {ease: FlxEase.sineIn, onComplete: function(twn:FlxTween)
							{
								defaultCamZoom = camGame.zoom;
							}});
							FlxTween.tween(camHUD, {zoom: 0.8}, val2, {ease: FlxEase.sineIn, onComplete: function(twn:FlxTween)
							{
								FlxTween.tween(camHUD, {zoom: 0.8}, 0.00001, {ease: FlxEase.sineIn});
							}});
						}
						if (val1 == 2) {
							FlxTween.tween(frontCrowd, {y: 1100, alpha: 0}, val2, {ease: FlxEase.sineOut});
							FlxTween.tween(camGame, {zoom: 0.59}, val2, {ease: FlxEase.sineOut, onComplete: function(twn:FlxTween)
							{
								defaultCamZoom = camGame.zoom;
								zooming = false;
							}});
							FlxTween.tween(camHUD, {zoom: 1}, val2, {ease: FlxEase.sineOut});
						}
						if (val1 == 3) {
							zooming = true;
							FlxTween.tween(frontCrowd, {y: 760, alpha: 1}, val2, {ease: FlxEase.sineIn});
							FlxTween.tween(camGame, {zoom: 0.47}, val2, {ease: FlxEase.sineIn});
							FlxTween.tween(camHUD, {zoom: 0.9}, val2, {ease: FlxEase.sineIn, onComplete: function(twn:FlxTween)
							{
								FlxTween.tween(camHUD, {zoom: 0.9}, 0.00001, {ease: FlxEase.sineIn});
								zooming = true;
							}});
						}
					}
				}
		}
	}
}