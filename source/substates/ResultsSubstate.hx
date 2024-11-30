package substates;

import flixel.addons.transition.FlxTransitionableState;
import states.StoryMenuState;
import states.FreeplayState;
import states.PlayState;
import backend.Highscore;
import backend.WeekData;
import backend.Song;
import backend.Rating;
import flixel.util.FlxTimer;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.effects.FlxFlicker;
import objects.Bar;
import flixel.ui.FlxBar;
import flixel.math.FlxMath;

class ResultsSubstate extends MusicBeatSubstate
{
    public var camHUD:FlxCamera;

    var resultsW:FlxSprite;
    var resultsG:FlxSprite;

    var scoreTxt:FlxText;
    var missTxt:FlxText;
    var accTxt:FlxText;
    var perfectTxt:FlxText;
    var greatTxt:FlxText;
    var goodTxt:FlxText;
    var okTxt:FlxText;
    var mehTxt:FlxText;
    var songTxt:FlxText;
    var highTxt:FlxText;

    public var perfects:Int = 0;
	public var greats:Int = 0;
	public var goods:Int = 0;
	public var oks:Int = 0;
	public var mehs:Int = 0;

    public static var campaignPercent:Float = 0;
	public static var campaignPerfects:Int = 0;
	public static var campaignGreats:Int = 0;
	public static var campaignGoods:Int = 0;
	public static var campaignOks:Int = 0;
	public static var campaignMehs:Int = 0;

    public var progressBar:FlxBar;
    public var barTween:FlxTween = null;
    var can_leave = false;

    var lerpScore:Int = 0;
    var intendedScore:Int = 0;
    var lerpMisses:Int = 0;
    var intendedMisses:Int = 0;
    var lerpRating:Float = 0;
    var intendedRating:Float = 0;
    var lerpPerfect:Int = 0;
    var intendedPerfect:Int = 0;
    var lerpGreat:Int = 0;
    var intendedGreat:Int = 0;
    var lerpGood:Int = 0;
    var intendedGood:Int = 0;
    var lerpOk:Int = 0;
    var intendedOk:Int = 0;
    var lerpMeh:Int = 0;
    var intendedMeh:Int = 0;

    var showScore = false;
    var showMisses = false;
    var showAccuracy = false;
    var showPerfect = false;
    var showGreat = false;
    var showGood = false;
    var showOk = false;
    var showMeh = false;
    var showRank = false;

    override function create()
    {
        camHUD = new FlxCamera();
        FlxG.cameras.add(camHUD, false);
        camHUD.bgColor.alpha = 0;

        var bg:FlxSprite = new FlxSprite().makeGraphic(1, 1, FlxColor.WHITE);
		bg.scale.set(FlxG.width, FlxG.height);
		bg.updateHitbox();
		bg.alpha = 0.4;
		bg.scrollFactor.set();
		add(bg);

        var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x33FFFFFF, 0x0));
		grid.velocity.set(40, 40);
		grid.alpha = 0;
		FlxTween.tween(grid, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
		add(grid);

        var resultsW:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('results/results-white'));
        resultsW.scrollFactor.set();
        resultsW.antialiasing = ClientPrefs.data.antialiasing;
        resultsW.updateHitbox();
        resultsW.setGraphicSize(Std.int(resultsW.width * 1.0));
        add(resultsW);
        resultsW.visible = true;

        var resultsG:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('results/results-gold'));
        resultsG.scrollFactor.set();
        resultsG.antialiasing = ClientPrefs.data.antialiasing;
        resultsG.updateHitbox();
        resultsG.setGraphicSize(Std.int(resultsG.width * 1.0));
        add(resultsG);
        resultsG.visible = false;

        var player = new FlxSprite(800, -400);
		player.frames = Paths.getSparrowAtlas('results/bf_victory');
		player.animation.addByPrefix('intro', 'intro', 24, false);
        player.animation.addByPrefix('loop', 'loop', 24, false);
        player.animation.addByPrefix('good', 'good', 24, false);
        player.animation.addByPrefix('bad', 'bad', 24, false);
		player.animation.play('intro');
		player.antialiasing = ClientPrefs.data.antialiasing;
		add(player);

        songTxt = new FlxText(420, 10, FlxG.width, PlayState.SONG.song + ' (' +  Difficulty.getString().toUpperCase() + ')', 40);
        songTxt.setFormat(Paths.font("PhantomMuff Full Letters 1.1.5.ttf"), 40, FlxColor.BLACK);
        songTxt.scrollFactor.set();
        songTxt.updateHitbox();
        add(songTxt);

        highTxt = new FlxText(300, 550, FlxG.width, "NEW HIGHSCORE!!!", 50);
        highTxt.setFormat(Paths.font("PhantomMuff Full Letters 1.1.5.ttf"), 50, FlxColor.BLACK);
        highTxt.scrollFactor.set();
        highTxt.updateHitbox();
        add(highTxt);
        highTxt.alpha = 0;

        perfectTxt = new FlxText(20, 150, FlxG.width, 'Perfects: ' + lerpPerfect, 50);
        perfectTxt.setFormat(Paths.font("PhantomMuff Full Letters 1.1.5.ttf"), 50, FlxColor.BLACK);
        perfectTxt.scrollFactor.set();
        perfectTxt.updateHitbox();
        add(perfectTxt);

        greatTxt = new FlxText(20, 175, FlxG.width, 'Greats: ' + lerpGreat, 50);
        greatTxt.setFormat(Paths.font("PhantomMuff Full Letters 1.1.5.ttf"), 50, FlxColor.BLACK);
        greatTxt.scrollFactor.set();
        greatTxt.updateHitbox();
        add(greatTxt);

        goodTxt = new FlxText(20, 260, FlxG.width, 'Goods: ' + lerpGood, 50);
        goodTxt.setFormat(Paths.font("PhantomMuff Full Letters 1.1.5.ttf"), 50, FlxColor.BLACK);
        goodTxt.scrollFactor.set();
        goodTxt.updateHitbox();
        add(goodTxt);

        okTxt = new FlxText(20, 345, FlxG.width, 'Oks: ' + lerpOk, 50);
        okTxt.setFormat(Paths.font("PhantomMuff Full Letters 1.1.5.ttf"), 50, FlxColor.BLACK);
        okTxt.scrollFactor.set();
        okTxt.updateHitbox();
        add(okTxt);

        mehTxt = new FlxText(20, 430, FlxG.width, 'Mehs: ' + lerpMeh, 50);
        mehTxt.setFormat(Paths.font("PhantomMuff Full Letters 1.1.5.ttf"), 50, FlxColor.BLACK);
        mehTxt.scrollFactor.set();
        mehTxt.updateHitbox();
        add(mehTxt);

        scoreTxt = new FlxText(20, 615, FlxG.width, 'Score: ' + lerpScore, 70);
        scoreTxt.setFormat(Paths.font("PhantomMuff Full Letters 1.1.5.ttf"), 70, FlxColor.BLACK);
        scoreTxt.scrollFactor.set();
        scoreTxt.updateHitbox();
        add(scoreTxt);

        missTxt = new FlxText(20, 515, FlxG.width, 'Misses: ' + lerpMisses, 50);
        missTxt.setFormat(Paths.font("PhantomMuff Full Letters 1.1.5.ttf"), 50, FlxColor.BLACK);
        missTxt.scrollFactor.set();
        missTxt.updateHitbox();
        add(missTxt);

        accTxt = new FlxText(300, 375, FlxG.width, 'Accuracy: ' + lerpRating + '%', 50);
        accTxt.setFormat(Paths.font("PhantomMuff Full Letters 1.1.5.ttf"), 50, FlxColor.BLACK);
        accTxt.scrollFactor.set();
        accTxt.updateHitbox();
        add(accTxt);

        //I FUCKING HATE STRAY PIXELS!!!
        progressBar = new FlxBar(287.8, 437, LEFT_TO_RIGHT, 413, 15);
        progressBar.createFilledBar(FlxColor.BLACK, FlxColor.WHITE);
        progressBar.scrollFactor.set();
        add(progressBar);

        var bar:FlxSprite = new FlxSprite(150, 430).loadGraphic(Paths.image('results/bar'));
        bar.scrollFactor.set();
        bar.antialiasing = ClientPrefs.data.antialiasing;
        bar.updateHitbox();
        bar.setGraphicSize(Std.int(bar.width * 0.7));
        add(bar);

        if (PlayState.isStoryMode)
        {
        intendedScore = PlayState.campaignScore;
        intendedMisses = PlayState.campaignMisses;
        intendedRating = PlayState.campaignPercent / PlayState.songsPlayed;
        intendedPerfect = PlayState.campaignPerfects;
        intendedGreat = PlayState.campaignGreats;
        intendedGood = PlayState.campaignGoods;
        intendedOk = PlayState.campaignOks;
        intendedMeh = PlayState.campaignMehs;
        songTxt.text = WeekData.getCurrentWeek().weekName + ' (' +  Difficulty.getString().toUpperCase() + ')';
        }
        else
        {
        intendedScore = PlayState.instance.songScore;
        intendedMisses = PlayState.instance.songMisses;
        intendedRating = CoolUtil.floorDecimal(PlayState.instance.ratingPercent * 100, 2);
        intendedPerfect = PlayState.instance.ratingsData[0].hits;
        intendedGreat = PlayState.instance.ratingsData[1].hits;
        intendedGood = PlayState.instance.ratingsData[2].hits;
        intendedOk = PlayState.instance.ratingsData[3].hits;
        intendedMeh = PlayState.instance.ratingsData[4].hits;
        }

        if (PlayState.isStoryMode)
        {
        if (PlayState.campaignScore > Highscore.getWeekScore(WeekData.getCurrentWeek().weekName, PlayState.storyDifficulty)) 
        {
        new FlxTimer().start(7, function(tmr:FlxTimer)
 	    {
        trace("new highscore!!!");
	 	highTxt.alpha = 1;
        });
        }
        }
        else
        {
        if (PlayState.instance.songScore > Highscore.getScore(PlayState.instance.songName, PlayState.storyDifficulty)) 
        {
        trace("new highscore!!!");
        new FlxTimer().start(7, function(tmr:FlxTimer)
 	    {
	 	highTxt.alpha = 1;
        });
        }
        }

        if (PlayState.isStoryMode)
        {
        if (intendedRating > 80)
        {
        FlxG.sound.play(Paths.sound(''), function() {
        FlxG.sound.play(Paths.sound('')); // from the mod itself
        });
        }
        else
        FlxG.sound.play(Paths.sound(''), function() {
        FlxG.sound.playMusic(Paths.music(''));
        });
        }
        else
        {
        if (PlayState.instance.ratingPercent > 0.8)
        {
        FlxG.sound.play(Paths.sound(''), function() {
        FlxG.sound.play(Paths.sound(''));
        });
        }
        else
        FlxG.sound.play(Paths.sound(''), function() {
        FlxG.sound.playMusic(Paths.music(''));
        });
        }

        new FlxTimer().start(1.5, function(tmr) {
        can_leave = true;
        showGreat = true;
        });

        new FlxTimer().start(2, function(tmr) {
        showGood = true;
        });

        new FlxTimer().start(2.5, function(tmr) {
        showOk = true;
        });

        new FlxTimer().start(3, function(tmr) {
        showMeh = true;
        });

        new FlxTimer().start(3.5, function(tmr) {
        showMisses = true;
        });

        new FlxTimer().start(1, function(tmr) {
        player.animation.play('loop');
        });

        new FlxTimer().start(4, function(tmr) {
        if (PlayState.isStoryMode)
        {
        if (PlayState.isStoryMode)
        {
            barTween = FlxTween.tween(progressBar, {percent: PlayState.campaignPercent / PlayState.songsPlayed}, 1, {
                ease: FlxEase.quadOut,
                onComplete: function(twn:FlxTween) progressBar.updateBar(),
                onUpdate: function(twn:FlxTween) progressBar.updateBar()
            });
        }
        }
        else
        {
        var val1:Float = CoolUtil.floorDecimal(PlayState.instance.ratingPercent * 100, 2);
        var val2:Float = 100;
        barTween = FlxTween.tween(progressBar, {percent: (val1 / val2) * 100}, 1, {
            ease: FlxEase.quadOut,
            onComplete: function(twn:FlxTween) progressBar.updateBar(),
            onUpdate: function(twn:FlxTween) progressBar.updateBar()
        });
        }
        showScore = true;
        showAccuracy = true;
        });
        
        new FlxTimer().start(6, function(tmr) {
        if (PlayState.isStoryMode)
        {
        if (intendedRating > 80)
        {
        player.animation.play('good');
        if (intendedRating == 100)
        {
        FlxG.sound.play(Paths.sound('good'));
        }
        else if(intendedRating > 90)
        {
        FlxG.sound.play(Paths.sound('good'));
        }
        else if(intendedRating > 80)
        {
        FlxG.sound.play(Paths.sound('boowomp'));
        }
        }
        else
        player.animation.play('bad');
        }
        else
        {
        if (PlayState.instance.ratingPercent > 0.8)
        {
        player.animation.play('good');
        if (PlayState.instance.ratingPercent == 1)
        {
        FlxG.sound.play(Paths.sound('good'));
        }
        else if(intendedRating > 90)
        {
        FlxG.sound.play(Paths.sound('good'));
        }
        else if(intendedRating > 80)
        {
        FlxG.sound.play(Paths.sound('boowomp'));
        }
        }
        else
        player.animation.play('bad');
        }
        });

        FlxFlicker.flicker(resultsG, 99999, 0.15, false);

        bg.cameras = [camHUD];
        grid.cameras = [camHUD];
        resultsW.cameras = [camHUD];
        resultsG.cameras = [camHUD];
        songTxt.cameras = [camHUD];
        perfectTxt.cameras = [camHUD];
        greatTxt.cameras = [camHUD];
        goodTxt.cameras = [camHUD];
        okTxt.cameras = [camHUD];
        mehTxt.cameras = [camHUD];
        scoreTxt.cameras = [camHUD];
        highTxt.cameras = [camHUD];
        missTxt.cameras = [camHUD];
        accTxt.cameras = [camHUD];
        progressBar.cameras = [camHUD];
        bar.cameras = [camHUD];
        player.cameras = [camHUD];

        super.create();
    }

    override function update(elapsed:Float)
    {
        if(showScore)
        {
        lerpScore = Math.floor(FlxMath.lerp(intendedScore, lerpScore, Math.exp(-elapsed * 14)));

        if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
        }

        if(showMisses)
        {
        lerpMisses = Math.floor(FlxMath.lerp(intendedMisses, lerpMisses, Math.exp(-elapsed * 16)));

        if (Math.abs(lerpMisses - intendedMisses) <= 10)
			lerpMisses = intendedMisses;
        }

        var ratingSplit:Array<String> = Std.string(CoolUtil.floorDecimal(lerpRating, 2)).split('.');

        if(showAccuracy)
        {
        lerpRating = FlxMath.lerp(intendedRating, lerpRating, Math.exp(-elapsed * 12));

        if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		if(ratingSplit.length < 2) { //No decimals, add an empty space
			ratingSplit.push('');
		}

        while(ratingSplit[1].length < 2) { //Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';
		}
        }

        if(showPerfect) // perfect ratings on sdpj
        {
        lerpPerfect = Math.floor(FlxMath.lerp(intendedPerfect, lerpPerfect, Math.exp(-elapsed * 16)));

        if (Math.abs(lerpPerfect - intendedPerfect) <= 10)
            lerpPerfect = intendedPerfect;
        }
        if(showGreat)
        {
        lerpGreat = Math.floor(FlxMath.lerp(intendedGreat, lerpGreat, Math.exp(-elapsed * 16)));

        if (Math.abs(lerpGreat - intendedGreat) <= 10)
			lerpGreat = intendedGreat;
        }
        if(showGood)
        {
        lerpGood = Math.floor(FlxMath.lerp(intendedGood, lerpGood, Math.exp(-elapsed * 16)));

        if (Math.abs(lerpGood - intendedGood) <= 10)
			lerpGood = intendedGood;
        }
        if(showOk)
        {
        lerpOk = Math.floor(FlxMath.lerp(intendedOk, lerpOk, Math.exp(-elapsed * 16)));

        if (Math.abs(lerpOk - intendedOk) <= 10)
			lerpOk = intendedOk;
        }
        if(showMeh)
        {
        lerpMeh = Math.floor(FlxMath.lerp(intendedMeh, lerpMeh, Math.exp(-elapsed * 16)));

        if (Math.abs(lerpMeh - intendedMeh) <= 10)
			lerpMeh = intendedMeh;
        }

        scoreTxt.text = 'Score: ' + lerpScore;
        missTxt.text = 'Misses: ' + lerpMisses;
        accTxt.text = 'Accuracy: ' + ' ' + ratingSplit.join('.') + '%';
        perfectTxt.text = 'Perfects: ' + lerpPerfect;
        greatTxt.text = 'Greats: ' + lerpGreat;
        goodTxt.text = 'Goods: ' + lerpGood;
        okTxt.text = 'Oks: ' + lerpOk;
        mehTxt.text = 'Mehs: ' + lerpMeh;

        super.update(elapsed);

        if (controls.ACCEPT && can_leave == true)
        {
            endthis();
        }
    }

    function endthis(){
        var percent:Float = PlayState.instance.ratingPercent;
		if(Math.isNaN(percent)) percent = 0;
        
        if(PlayState.isStoryMode)
        {
        Highscore.saveWeekScore(WeekData.getWeekFileName(), PlayState.campaignScore, PlayState.storyDifficulty);
        }
        else
        {
		// Highscore.saveScore(PlayState.SONG.song, PlayState.instance.songScore, PlayState.storyDifficulty, percent); // till further notice
        }

        PlayState.campaignPercent = PlayState.songsPlayed = 0;
        campaignPerfects += perfects;
        campaignGreats += greats;
        campaignGoods += goods;
        campaignOks += oks;
        campaignMehs += mehs;
        PlayState.campaignPerfects = 0;
        PlayState.campaignGreats = 0;
        PlayState.campaignGoods = 0;
        PlayState.campaignOks = 0;
        PlayState.campaignMehs = 0;
        
        if (PlayState.isStoryMode) 
        {
        MusicBeatState.switchState(new StoryMenuState());
        }
        else
        {
        MusicBeatState.switchState(new FreeplayState());
        }

        FlxG.sound.playMusic(Paths.music('freakyMenu'));
    }
}