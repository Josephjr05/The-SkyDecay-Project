package states;

import hxcodec.flixel.FlxVideoSprite;
import backend.SkipPie;
import states.TitleState;

// Thank you notmagniill for helping me get the intro in! - Joseph

class VideoIntro extends MusicBeatState
{
    var epicIntro:FlxVideoSprite;
    var tip:FlxText;
    var pie:SkipPie;

    override function create()
    {
        FlxG.mouse.visible = false;
        FlxG.mouse.useSystemCursor = false;

        epicIntro = new FlxVideoSprite(1, 1);
        epicIntro.alpha = 0;
        add(epicIntro);

        tip = new FlxText(279.25, 631.6, FlxG.width, "Please Wait.");
        tip.setFormat("VCR OSD Mono", 68, FlxColor.WHITE);
        tip.alpha = 0;
        add(tip);

        pie = new SkipPie();
        add(pie);

        FlxTween.tween(tip, {alpha: 1}, 0.5, {ease: FlxEase.quadInOut});
        new FlxTimer().start(3, function (tmr:FlxTimer) {
            FlxTween.tween(tip, {alpha: 0}, 0.5, {ease: FlxEase.quadInOut});
            new FlxTimer().start(0.36667, function (tmr:FlxTimer) {
                epicIntro.play(Paths.video('TPV2Intro'), false);
                FlxTween.tween(epicIntro, {alpha: 1}, 0.5, {ease: FlxEase.quadInOut});
                new FlxTimer().start(6, function (tmr:FlxTimer) {
                    MusicBeatState.switchState(new TitleState());
                    TitleState.playedIntro = true;
                });
            });
        });

        super.create();
    }
}