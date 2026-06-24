package backend;

import openfl.Lib;

import StringTools;

import backend.StageData;
import backend.PsychCamera;
import backend.ScriptRunner;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

import objects.Character;
import objects.StrumNote;

import psychlua.LuaUtils;

import states.PlayState;
import states.editors.ChartingState;

@:access(states.PlayState)
class VisualEventRunner
{
	public static function runBuiltIn(?play:PlayState, ?chart:ChartingState, eventName:String, value1:String, value2:String, value3:String,
		strumTime:Float, flValue1:Null<Float>, flValue2:Null<Float>, flValue3:Null<Float>):Void
	{
		var isChart:Bool = chart != null;
		if (!isChart && play == null)
			return;

		var camGame = isChart ? chart.camGame : play.camGame;
		var camHUD = isChart ? chart.camOther : play.camHUD;
		var camOther = isChart ? chart.camOther : play.camOther;
		var camFollow = isChart ? chart.camFollow : play.camFollow;
		var boyfriend = isChart ? chart.boyfriend : play.boyfriend;
		var dad = isChart ? chart.dad : play.dad;
		var gf = isChart ? chart.gf : play.gf;
		var defaultCamZoom = isChart ? chart.defaultCamZoom : play.defaultCamZoom;

		switch (eventName)
		{
			case 'Change Stage':
				if (isChart)
				{
					if (value1 != null && value1.length > 0 && PlayState.SONG != null && chart.visualPreview != null)
					{
						PlayState.SONG.stage = value1;
						chart.visualPreview.reloadStage(PlayState.SONG);
						ScriptRunner.setOnScripts(chart, 'curStage', value1);
					}
				}
				else
				{
					play.removeStage();
					PlayState.curStage = value1;
					play.stageData = StageData.getStageFile(PlayState.curStage);
					play.addStage();
					play.setOnScripts('curStage', PlayState.curStage);
					if (play.camFollow != null && play.camGame != null)
					{
						play.camGame.zoom = play.defaultCamZoom;
						play.moveCameraSection();
						play.camGame.snapToTarget();
					}
				}

			case 'Set GF Speed':
				if (flValue1 == null || flValue1 < 1) flValue1 = 1;
				if (isChart)
				{
					if (chart.gf != null)
						chart.gf.danceEveryNumBeats = Math.round(flValue1);
				}
				else
					play.gfSpeed = Math.round(flValue1);

			case 'Add Camera Zoom':
				if (ClientPrefs.data.camZooms && camGame != null && camGame.zoom < 1.35)
				{
					if (flValue1 == null) flValue1 = 0.015;
					if (flValue2 == null) flValue2 = 0.03;
					camGame.zoom += flValue1;
					if (isChart) chart.defaultCamZoom = camGame.zoom;
					else play.defaultCamZoom = camGame.zoom;
					if (ClientPrefs.data.camHUDOption && camHUD != null)
						camHUD.zoom += flValue2;
				}

			case 'Set Camera Zoom':
				if (ClientPrefs.data.camZooms && !ClientPrefs.data.lowQuality && camGame != null)
				{
					var zoom:Float = Std.parseFloat(value1);
					var duration:Float = Std.parseFloat(value2);
					zoom = Math.isNaN(zoom) ? defaultCamZoom : zoom;
					duration = Math.isNaN(duration) ? 0.5 : duration;
					if (duration <= 0)
					{
						camGame.zoom = zoom;
						if (isChart) chart.defaultCamZoom = zoom;
						else play.defaultCamZoom = zoom;
					}
					else
					{
						if (isChart) chart.camZooming = true;
						else play.camZooming = true;
						FlxTween.tween(camGame, {zoom: zoom}, duration, {
							ease: FlxEase.quadInOut,
							onComplete: function(_)
							{
								if (isChart)
								{
									chart.defaultCamZoom = zoom;
									chart.camZooming = false;
								}
								else
								{
									play.defaultCamZoom = zoom;
									play.camZooming = false;
								}
							}
						});
					}
				}

			case 'Enable Camera Bop':
				if (isChart) chart.camZooming = true;
				else play.camZooming = true;

			case 'Disable Camera Bop':
				if (isChart)
				{
					chart.camZooming = false;
					if (chart.camGame != null)
						chart.camGame.zoom = chart.defaultCamZoom;
					if (ClientPrefs.data.camHUDOption && chart.camOther != null)
						chart.camOther.zoom = 1;
				}
				else
				{
					play.camZooming = false;
					if (play.camGame != null)
						play.camGame.zoom = play.defaultCamZoom;
					if (ClientPrefs.data.camHUDOption && play.camHUD != null)
						play.camHUD.zoom = 1;
				}

			case 'Play Animation':
				var char:Character = dad;
				switch ((value2 != null ? value2 : '').toLowerCase().trim())
				{
					case 'bf' | 'boyfriend': char = boyfriend;
					case 'gf' | 'girlfriend': char = gf;
					default:
						if (flValue2 == null) flValue2 = 0;
						switch (Math.round(flValue2))
						{
							case 1: char = boyfriend;
							case 2: char = gf;
						}
				}
				if (char != null)
				{
					char.playAnim(value1, true);
					char.specialAnim = true;
				}

			case 'Camera Follow Pos':
				if (camFollow != null)
				{
					if (isChart) chart.isCameraOnForcedPos = false;
					else play.isCameraOnForcedPos = false;
					if (flValue1 != null || flValue2 != null)
					{
						if (isChart) chart.isCameraOnForcedPos = true;
						else play.isCameraOnForcedPos = true;
						camFollow.x = flValue1 != null ? flValue1 : 0;
						camFollow.y = flValue2 != null ? flValue2 : 0;
					}
					else if (isChart)
						GameplayVisualPreview.moveCameraSection(chart, chart.curSec);
					else
						play.moveCameraSection();
				}

			case 'Alt Idle Animation':
				var char:Character = dad;
				switch ((value1 != null ? value1 : '').toLowerCase().trim())
				{
					case 'gf' | 'girlfriend': char = gf;
					case 'boyfriend' | 'bf': char = boyfriend;
					default:
						var val:Int = Std.parseInt(value1);
						if (Math.isNaN(val)) val = 0;
						switch (val)
						{
							case 1: char = boyfriend;
							case 2: char = gf;
						}
				}
				if (char != null)
				{
					char.idleSuffix = value2;
					char.recalculateDanceIdle();
				}

			case 'Screen Shake':
				if (camGame != null)
				{
					var split:Array<String> = value1.split(',');
					var duration:Float = split.length > 0 ? Std.parseFloat(StringTools.trim(split[0])) : 0;
					var intensity:Float = split.length > 1 ? Std.parseFloat(StringTools.trim(split[1])) : 0;
					if (Math.isNaN(duration)) duration = 0;
					if (Math.isNaN(intensity)) intensity = 0;
					if (duration > 0 && intensity != 0)
						camGame.shake(intensity, duration);
				}

			case 'Change Character':
				if (isChart)
				{
					if (chart.visualPreview != null && value2 != null && value2.length > 0)
						chart.visualPreview.runCharacterChangeEvent(value1, value2);
				}
				else
					runPlayChangeCharacter(play, value1, value2);

			case 'Change Scroll Speed':
				if (!isChart && play.songSpeedType != "constant")
				{
					if (flValue1 == null) flValue1 = 1;
					if (flValue2 == null) flValue2 = 0;
					var newValue:Float = PlayState.SONG.speed * ClientPrefs.getGameplaySetting('scrollspeed') * flValue1;
					if (flValue2 <= 0)
						play.songSpeed = newValue;
					else
						play.songSpeedTween = FlxTween.tween(play, {songSpeed: newValue}, flValue2 / play.playbackRate, {
							ease: FlxEase.linear,
							onComplete: function(_) play.songSpeedTween = null
						});
				}

			case 'Set Property':
				try
				{
					var trueValue:Dynamic = value2 != null ? value2.trim() : '';
					if (trueValue == 'true' || trueValue == 'false') trueValue = trueValue == 'true';
					else if (flValue2 != null) trueValue = flValue2;
					var split:Array<String> = value1.split('.');
					var target:Dynamic = isChart ? cast chart : play;
					if (split.length > 1)
						LuaUtils.setVarInArray(LuaUtils.getPropertyLoop(split), split[split.length - 1], trueValue);
					else
						LuaUtils.setVarInArray(target, value1, trueValue);
				}
				catch (e:Dynamic)
				{
					trace('Set Property event failed: $e');
				}

			case 'Play Sound':
				if (value1 != null && value1.length > 0)
				{
					var vol:Float = flValue2 != null ? flValue2 : 1;
					FlxG.sound.play(Paths.sound(value1), vol);
				}

			case 'Bad Apple':
				runBadApple(isChart, chart, play, boyfriend, dad);

			case 'Note Spin':
				var strums = isChart ? chart.strumLineNotes : play.strumLineNotes;
				if (strums != null)
					strums.forEach(function(tospin:FlxSprite)
						FlxTween.angle(tospin, 0, 360, 0.8, {ease: FlxEase.quintOut}));

			case 'Boom Cam':
				if (isChart)
				{
					chart.previewZaBoom = !chart.previewZaBoom;
					if (chart.previewZaBoom)
					{
						chart.previewBoomHud = Std.parseFloat(value1);
						chart.previewBoomCam = Std.parseFloat(value2);
					}
					else
					{
						chart.previewBoomHud = 0;
						chart.previewBoomCam = 0;
					}
				}
				else
				{
					play.zaBoom = !play.zaBoom;
					if (play.zaBoom)
					{
						play.boomHud = Std.parseFloat(value1);
						play.boomCam = Std.parseFloat(value2);
					}
					else
					{
						play.boomHud = 0;
						play.boomCam = 0;
					}
				}

			case 'Cinema Bars':
				runCinemaBars(isChart, chart, play, value1);

			case 'UI Fade':
				if (camHUD != null)
					FlxTween.tween(camHUD, {alpha: Std.parseFloat(value1)}, Std.parseFloat(value2), {ease: FlxEase.quartInOut});

			case 'Flash Camera':
				if (camGame != null)
					camGame.flash(FlxColor.WHITE, Std.parseFloat(value1));

			case 'BLACKOUT':
				runBlackout(isChart, chart, play, camOther, value1, value2);

			case 'Hide Health':
				if (!isChart)
					runHideHealth(play, value1, value2);

			case 'KM Toggle':
				if (!isChart)
				{
					play.kmMode = !play.kmMode;
					play.maxMisses = Std.parseInt(value1);
				}

			case 'RotScreenCam':
				if (camGame != null)
				{
					var val:Null<Float> = Std.parseFloat(value1);
					if (val == null) val = 0;
					FlxTween.tween(camGame, {angle: val}, Std.parseFloat(value2), {ease: FlxEase.circOut});
				}

			case 'Fade BF':
				if (boyfriend != null)
				{
					var duration:Null<Float> = Std.parseFloat(value1);
					if (duration == null) duration = 0.01;
					FlxTween.tween(boyfriend, {alpha: Std.parseFloat(value2)}, duration, {ease: FlxEase.linear});
				}

			case 'Switch Cam':
				if (camHUD != null && camGame != null)
				{
					var val:String = value2 != null ? value2 : 'off';
					var dur:Float = Std.parseFloat(value1);
					if (val == 'on')
					{
						FlxTween.tween(camHUD, {alpha: 1}, dur, {ease: FlxEase.linear});
						FlxTween.tween(camGame, {alpha: 1}, dur, {ease: FlxEase.linear});
					}
					else if (val == 'off')
					{
						FlxTween.tween(camHUD, {alpha: 0}, dur, {ease: FlxEase.linear});
						FlxTween.tween(camGame, {alpha: 0}, dur, {ease: FlxEase.linear});
					}
				}

			case 'Window Alert':
				if (!isChart)
					Lib.application.window.alert('${value1}', '${value2}');

			case 'UI Flip':
				if (camHUD != null)
				{
					if (camHUD.angle != 180)
						FlxTween.tween(camHUD, {angle: 180}, 0.1, {ease: FlxEase.linear});
					else
						FlxTween.tween(camHUD, {angle: 0}, 0.1, {ease: FlxEase.linear});
				}

			case 'NoteDie':
				if (isChart)
					runChartStrumShift(chart, -275, -1000, false);
				else
					runPlayStrumShift(play, -275, -1000, false);

			case 'NoteLive':
				if (isChart)
					runChartStrumShift(chart, 275, 1000, true);
				else
					runPlayStrumShift(play, 275, 1000, true);

			default:
				trace('Unknown event: $eventName');
		}
	}

	static function runPlayChangeCharacter(play:PlayState, value1:String, value2:String):Void
	{
		var charType:Int = 0;
		switch (value1.toLowerCase().trim())
		{
			case 'gf' | 'girlfriend': charType = 2;
			case 'dad' | 'opponent': charType = 1;
			default:
				charType = Std.parseInt(value1);
				if (Math.isNaN(charType)) charType = 0;
		}
		switch (charType)
		{
			case 0:
				if (play.boyfriend.curCharacter != value2)
				{
					if (!play.boyfriendMap.exists(value2))
						play.addCharacterToList(value2, charType);
					var lastAlpha:Float = play.boyfriend.alpha;
					play.boyfriend.alpha = 0.00001;
					play.boyfriend = play.boyfriendMap.get(value2);
					play.boyfriend.alpha = lastAlpha;
					play.iconP1.changeIcon(play.boyfriend.healthIcon);
				}
				play.setOnScripts('boyfriendName', play.boyfriend.curCharacter);
			case 1:
				if (play.dad.curCharacter != value2)
				{
					if (!play.dadMap.exists(value2))
						play.addCharacterToList(value2, charType);
					var wasGf:Bool = play.dad.curCharacter.startsWith('gf-') || play.dad.curCharacter == 'gf';
					var lastAlpha:Float = play.dad.alpha;
					play.dad.alpha = 0.00001;
					play.dad = play.dadMap.get(value2);
					if (!play.dad.curCharacter.startsWith('gf-') && play.dad.curCharacter != 'gf')
					{
						if (wasGf && play.gf != null)
							play.gf.visible = true;
					}
					else if (play.gf != null)
						play.gf.visible = false;
					play.dad.alpha = lastAlpha;
					play.iconP2.changeIcon(play.dad.healthIcon);
				}
				play.setOnScripts('dadName', play.dad.curCharacter);
			case 2:
				if (play.gf != null && play.gf.curCharacter != value2)
				{
					if (!play.gfMap.exists(value2))
						play.addCharacterToList(value2, charType);
					var lastAlpha:Float = play.gf.alpha;
					play.gf.alpha = 0.00001;
					play.gf = play.gfMap.get(value2);
					play.gf.alpha = lastAlpha;
					play.setOnScripts('gfName', play.gf.curCharacter);
				}
		}
		play.reloadHealthBarColors();
	}

	static function runBadApple(isChart:Bool, chart:ChartingState, play:PlayState, boyfriend:Character, dad:Character):Void
	{
		var apple:FlxSprite;
		var badApple:Bool;
		var dadGroup = isChart ? chart.dadGroup : play.dadGroup;
		if (isChart)
		{
			apple = new FlxSprite();
			apple.makeGraphic(10000, 10000, FlxColor.WHITE);
			badApple = chart.previewBadApple;
		}
		else
		{
			play.appleScreen = new FlxSprite();
			play.appleScreen.makeGraphic(10000, 10000, FlxColor.WHITE);
			apple = play.appleScreen;
			badApple = play.badApple;
		}
		if (dadGroup != null)
		{
			apple.x = dadGroup.x - 800;
			apple.y = dadGroup.y - 800;
		}
		apple.alpha = 0;
		apple.cameras = isChart ? [chart.camGame] : [play.camGame];
		if (badApple)
		{
			if (boyfriend != null) boyfriend.color = 0xFFFFFF;
			if (dad != null) dad.color = 0xFFFFFF;
			apple.destroy();
		}
		else
		{
			apple.alpha = 1;
			if (boyfriend != null) boyfriend.color = 0x000000;
			if (dad != null) dad.color = 0x000000;
			if (isChart) chart.previewGroup.add(apple);
			else play.add(apple);
		}
		if (isChart) chart.previewBadApple = !badApple;
		else play.badApple = !badApple;
	}

	static function ensureCinemaBars(chart:ChartingState):Void
	{
		if (chart.previewTopBar != null)
			return;
		chart.previewTopBar = new FlxSprite(0, -170).makeGraphic(1280, 170, FlxColor.BLACK);
		chart.previewBottomBar = new FlxSprite(0, 720).makeGraphic(1280, 170, FlxColor.BLACK);
		chart.previewTopBar.cameras = [chart.camOther];
		chart.previewBottomBar.cameras = [chart.camOther];
	}

	static function runCinemaBars(isChart:Bool, chart:ChartingState, play:PlayState, value1:String):Void
	{
		function cinematicBars(appear:Bool)
		{
			if (isChart)
			{
				ensureCinemaBars(chart);
				if (appear)
				{
					chart.previewGroup.add(chart.previewTopBar);
					chart.previewGroup.add(chart.previewBottomBar);
					FlxTween.tween(chart.previewTopBar, {y: 0}, 0.5, {ease: FlxEase.quadOut});
					FlxTween.tween(chart.previewBottomBar, {y: 550}, 0.5, {ease: FlxEase.quadOut});
				}
				else
				{
					FlxTween.tween(chart.previewTopBar, {y: -170}, 0.5, {ease: FlxEase.quadOut});
					FlxTween.tween(chart.previewBottomBar, {y: 720}, 0.5, {
						ease: FlxEase.quadOut,
						onComplete: function(_)
						{
							chart.previewGroup.remove(chart.previewTopBar);
							chart.previewGroup.remove(chart.previewBottomBar);
						}
					});
				}
			}
			else
			{
				if (appear)
				{
					play.add(play.topBar);
					play.add(play.bottomBar);
					FlxTween.tween(play.topBar, {y: 0}, 0.5, {ease: FlxEase.quadOut});
					FlxTween.tween(play.bottomBar, {y: 550}, 0.5, {ease: FlxEase.quadOut});
				}
				else
				{
					FlxTween.tween(play.topBar, {y: -170}, 0.5, {ease: FlxEase.quadOut});
					FlxTween.tween(play.bottomBar, {y: 720}, 0.5, {
						ease: FlxEase.quadOut,
						onComplete: function(_)
						{
							play.remove(play.topBar);
							play.remove(play.bottomBar);
						}
					});
				}
			}
		}
		switch (Std.parseInt(value1))
		{
			case 1: cinematicBars(true);
			case 0: cinematicBars(false);
		}
	}

	static function runBlackout(isChart:Bool, chart:ChartingState, play:PlayState, camOther:PsychCamera, value1:String, value2:String):Void
	{
		var black:FlxSprite = isChart ? chart.previewBlackSprite : play.blackSprite;
		if (black == null)
		{
			black = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			black.cameras = [camOther];
			black.alpha = 0;
			if (isChart)
			{
				chart.previewBlackSprite = black;
				chart.previewGroup.add(black);
			}
			else
			{
				play.blackSprite = black;
				play.add(black);
			}
		}
		var startstop:Int = Std.parseInt(value1);
		var speed:Float = Std.parseFloat(value2);
		if (startstop == 1)
			FlxTween.tween(black, {alpha: 1}, speed, {ease: FlxEase.linear});
		else if (startstop == 2)
			FlxTween.tween(black, {alpha: 0}, speed, {
				ease: FlxEase.linear,
				onComplete: function(_)
				{
					if (isChart)
					{
						chart.previewGroup.remove(chart.previewBlackSprite);
						if (chart.previewBlackSprite != null)
						{
							chart.previewBlackSprite.destroy();
							chart.previewBlackSprite = null;
						}
					}
					else
					{
						play.remove(play.blackSprite);
						play.blackSprite = null;
					}
				}
			});
	}

	static function runHideHealth(play:PlayState, value1:String, value2:String):Void
	{
		var dur:Float = Std.parseFloat(value2);
		switch (Std.parseInt(value1))
		{
			case 0:
				FlxTween.tween(play.healthBar, {alpha: 0}, dur, {ease: FlxEase.linear});
				FlxTween.tween(play.iconP1, {alpha: 0}, dur, {ease: FlxEase.linear});
				FlxTween.tween(play.iconP2, {alpha: 0}, dur, {ease: FlxEase.linear});
			case 1:
				FlxTween.tween(play.healthBar, {alpha: 1}, dur, {ease: FlxEase.linear});
				FlxTween.tween(play.iconP1, {alpha: 1}, dur, {ease: FlxEase.linear});
				FlxTween.tween(play.iconP2, {alpha: 1}, dur, {ease: FlxEase.linear});
		}
	}

	static function runChartStrumShift(chart:ChartingState, playerX:Float, oppX:Float, fadeIn:Bool):Void
	{
		if (chart.playerStrums != null)
			chart.playerStrums.forEach(function(spr:FlxSprite)
			{
				if (fadeIn)
				{
					FlxTween.tween(spr, {alpha: 1}, 0.4, {ease: FlxEase.circOut});
					if (!FlxG.save.data.midscroll)
						spr.x += playerX;
				}
				else if (!FlxG.save.data.midscroll)
					spr.x += playerX;
			});
		if (chart.opponentStrums != null)
			chart.opponentStrums.forEach(function(spr:FlxSprite) spr.x += oppX);
	}

	static function runPlayStrumShift(play:PlayState, playerX:Float, oppX:Float, fadeIn:Bool):Void
	{
		play.playerStrums.forEach(function(spr:FlxSprite)
		{
			if (fadeIn)
			{
				FlxTween.tween(spr, {alpha: 1}, 0.4, {ease: FlxEase.circOut});
				if (!FlxG.save.data.midscroll)
					spr.x += playerX;
			}
			else if (!FlxG.save.data.midscroll)
				spr.x += playerX;
		});
		play.opponentStrums.forEach(function(spr:FlxSprite) spr.x += oppX);
	}

	public static function triggerChartEvent(host:ChartingState, eventName:String, value1:String, value2:String, value3:String, strumTime:Float):Void
	{
		if (host == null)
			return;

		var flValue1:Null<Float> = Std.parseFloat(value1);
		var flValue2:Null<Float> = Std.parseFloat(value2);
		var flValue3:Null<Float> = Std.parseFloat(value3);
		if (flValue1 != null && Math.isNaN(flValue1)) flValue1 = null;
		if (flValue2 != null && Math.isNaN(flValue2)) flValue2 = null;
		if (flValue3 != null && Math.isNaN(flValue3)) flValue3 = null;

		VisualEventRunner.runBuiltIn(null, host, eventName, value1, value2, value3, strumTime, flValue1, flValue2, flValue3);
		host.stagesFunc(function(stage:BaseStage) stage.eventCalled(eventName, value1, value2, value3, flValue1, flValue2, strumTime));
		ScriptRunner.callOnScripts(host, 'onEvent', [eventName, value1, value2, strumTime]);
	}
}
