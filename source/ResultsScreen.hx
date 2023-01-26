package;

import haxe.Exception;
#if sys
import sys.FileSystem;
import sys.io.File;
#end
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import flixel.system.FlxSound;
import flixel.util.FlxAxes;
import flixel.FlxSubState;
import flixel.input.FlxInput;
import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.input.FlxKeyManager;

using StringTools;

class ResultsScreen extends FlxSubState
{
	public var background:FlxSprite;
	public var text:FlxText;

	public var anotherBackground:FlxSprite;
	public var graph:HitGraph;
	public var graphSprite:OFLSprite;

	public var comboText:FlxText;
	public var contText:FlxText;
	public var settingsText:FlxText;

	public var music:FlxSound;

	public var graphData:BitmapData;

	public var ranking:String;
	public var accuracy:String;

	override function create()
	{
		background = new FlxSprite(0, 0).loadGraphic(Paths.image('Hive1'));
		background.scrollFactor.set();
		background.antialiasing = FlxG.save.data.antialiasing;
		background.screenCenter();
		// add(background);

		background.alpha = 0;

		music = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		music.volume = 0;
		music.play(false, FlxG.random.int(0, Std.int(music.length / 2)));
		FlxG.sound.list.add(music);

		text = new FlxText(20, -55, 0, "");
		text.size = 34;
		text.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 4, 1);
		text.color = FlxColor.WHITE;
		text.scrollFactor.set();
		text.text = (PlayState.trackCrashed ? "TRACK CRASH" : "TRACK FINISH");
		if (ClientPrefs.sdvxClear == "EFFECTIVE")
		{
			text.text = (PlayState.instance.health < 1.4 ? "TRACK CRASH" : "TRACK FINISH");
		}
		add(text);

		var score = PlayState.instance.songScore;
		if (PlayState.isStoryMode)
		{
			score = PlayState.campaignScore;
			text.text = "Week Cleared!";
		}

		var sicks = PlayState.isStoryMode ? PlayState.campaignSicks : PlayState.sicks;
		var goods = PlayState.isStoryMode ? PlayState.campaignGoods : PlayState.goods;
		var bads = PlayState.isStoryMode ? PlayState.campaignBads : PlayState.bads;
		var shits = PlayState.isStoryMode ? PlayState.campaignShits : PlayState.shits;
		var acc = Highscore.floorDecimal(PlayState.instance.ratingPercent * 100, 2);

		comboText = new FlxText(20, -75, 0,
			'Judgements:\nSicks - ${sicks}\nGoods - ${goods}\nBads - ${bads}\n\nCombo Breaks: ${(PlayState.isStoryMode ? PlayState.campaignMisses : PlayState.instance.songMisses)}\nHighest Combo: ${PlayState.instance.maxCombo}\n\nScore: ${PlayState.instance.songScore}\nAccuracy: ${acc}%\n\n(${PlayState.instance.ratingFC}) ${PlayState.instance.ratingName}
        ');
		comboText.size = 28;
		comboText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 4, 1);
		comboText.color = FlxColor.WHITE;
		comboText.scrollFactor.set();
		add(comboText);

		contText = new FlxText(FlxG.width - 475, FlxG.height + 50, 0, 'Press ENTER to continue.');
		contText.size = 28;
		contText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 4, 1);
		contText.color = FlxColor.WHITE;
		contText.scrollFactor.set();
		add(contText);

		anotherBackground = new FlxSprite(FlxG.width - 500, 45).makeGraphic(450, 240, FlxColor.BLACK);
		anotherBackground.scrollFactor.set();
		anotherBackground.alpha = 0;
		add(anotherBackground);

		graph = new HitGraph(FlxG.width - 500, 45, 495, 240);
		graph.alpha = 0;

		graphSprite = new OFLSprite(FlxG.width - 510, 45, 460, 240, graph);

		graphSprite.scrollFactor.set();
		graphSprite.alpha = 0;

		add(graphSprite);

		var sicks = CoolUtil.truncateFloat(PlayState.sicks / PlayState.goods, 1);
		var goods = CoolUtil.truncateFloat(PlayState.goods / PlayState.bads, 1);

		if (sicks == Math.POSITIVE_INFINITY)
			sicks = 0;
		if (goods == Math.POSITIVE_INFINITY)
			goods = 0;

		var mean:Float = 0;

		for (i in 0...PlayState.notesHit.length)
		{
			// I HAVE TO MAKE A REPLAY SYSTEM FOR THIS FIRST - FIREABLE
			// nvm ignore above, im just gonna do the hackiest method ever :)

			// 0 = time
			// 1 = length
			// 2 = type
			// 3 = diff
			var obj = PlayState.notesHit[i];
			// judgement

			var obj3 = obj.strumTime;

			var diff = obj.diff;
			var judge = obj.resultRating;
			if (diff != (166 * Math.floor((ClientPrefs.safeFrames / 60) * 1000) / 166))
				mean += diff;
			if (obj.parentNote == null)
				graph.addToHistory(diff, judge, obj3);
		}

		if (sicks == Math.POSITIVE_INFINITY || sicks == Math.NaN)
			sicks = 0;
		if (goods == Math.POSITIVE_INFINITY || goods == Math.NaN)
			goods = 0;

		graph.update();

		mean = CoolUtil.truncateFloat(mean / PlayState.notesHit.length, 2);

		settingsText = new FlxText(20, FlxG.height + 50, 0,
			'Mean: ${mean}ms (SICK:${ClientPrefs.sickWindow}ms,GOOD:${ClientPrefs.goodWindow}ms,BAD:${ClientPrefs.badWindow}ms,SHIT:${ClientPrefs.shitWindow}ms)');
		settingsText.size = 16;
		settingsText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2, 1);
		settingsText.color = FlxColor.WHITE;
		settingsText.scrollFactor.set();
		add(settingsText);

		FlxTween.tween(background, {alpha: 0.5}, 0.5);
		FlxTween.tween(text, {y: 20}, 0.5, {ease: FlxEase.expoInOut});
		FlxTween.tween(comboText, {y: 145}, 0.5, {ease: FlxEase.expoInOut});
		FlxTween.tween(contText, {y: FlxG.height - 45}, 0.5, {ease: FlxEase.expoInOut});
		FlxTween.tween(settingsText, {y: FlxG.height - 35}, 0.5, {ease: FlxEase.expoInOut});
		FlxTween.tween(anotherBackground, {alpha: 0.6}, 0.5, {
			onUpdate: function(tween:FlxTween)
			{
				graph.alpha = FlxMath.lerp(0, 1, tween.percent);
				graphSprite.alpha = FlxMath.lerp(0, 1, tween.percent);
			}
		});

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		super.create();
	}

	var frames = 0;

	override function update(elapsed:Float)
	{
		if (music != null)
			if (music.volume < 0.5)
				music.volume += 0.01 * elapsed;

		// keybinds

		if (PlayerSettings.player1.controls.ACCEPT)
		{
			if (music != null)
				music.fadeOut(0.3);

			Highscore.saveScore(PlayState.SONG.song, PlayState.instance.songScore, PlayState.storyDifficulty);
			
			PlayState.campaignScore = 0;
			PlayState.campaignMisses = 0;
			PlayState.campaignSicks = 0;
			PlayState.campaignGoods = 0;
			PlayState.campaignBads = 0;
			PlayState.campaignShits = 0;

			PlayState.campaignScore = 0;
			PlayState.campaignMisses = 0;
			PlayState.campaignSicks = 0;
			PlayState.campaignGoods = 0;
			PlayState.campaignBads = 0;
			PlayState.campaignShits = 0;

			if (PlayState.isStoryMode)
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				Conductor.changeBPM(102);
				FlxG.switchState(new MainMenuState());
			}
			else
				FlxG.switchState(new FreeplayState());
		}

		if (FlxG.keys.justPressed.F1)
		{
			#if !switch
			Highscore.saveScore(PlayState.SONG.song, PlayState.instance.songScore, PlayState.storyDifficulty);
			#end

			if (music != null)
				music.fadeOut(0.3);

			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = PlayState.storyDifficulty;
			LoadingState.loadAndSwitchState(new PlayState());
		}

		super.update(elapsed);
	}
}