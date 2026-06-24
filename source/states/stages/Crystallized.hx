package states.stages;

import openfl.filters.ShaderFilter;
import shaders.LOFInightSky;
import shaders.ColorSwap;
// import shaders.FNFRain;
import objects.Rain;

class Crystallized extends BaseStage {
    var bg:BGSprite;
    var shards:BGSprite;
    var floor:BGSprite;
    var sky = new LOFInightSky();
    var colorShader = new ColorSwap();
    var bump:Bool = true;
    //var rain = new FNFRain();
    override function create(){
        bg = new BGSprite('stages/camellia/crystallized/background', -200, -300, .5, .5);
        bg.setGraphicSize(Std.int(bg.width*1.5));
        bg.angle = 180;
        add(bg);

        shards = new BGSprite('stages/camellia/crystallized/shards', -200, -300);
        shards.setGraphicSize(Std.int(shards.width*1.5));
        add(shards);

        floor = new BGSprite('stages/camellia/crystallized/base', -225, -150, 0.9, 0.9);
        floor.setGraphicSize(Std.int(floor.width*1.5));
        add(floor);

        sky.intensity.value = [1.0];
        bg.shader = sky;
        shards.shader = colorShader.shader;
    }
    override function createPost(){
        for (i in 0...150){
            var r:Rain = new Rain();
            add(r);
        }
        // switch(formattedSong){
        //     case 'rain-of-amethyst':
        //         bump = false;
        //         shards.alpha = 0;
        //         for (i in [dad, boyfriend, gf, floor])
        //             i.color = 0xff000000;
        //         camHUD.alpha = 0;
        // }
    }
    override function update(elapsed:Float){
        sky.iTime.value = [Conductor.songPosition/1000];
        //rain.iTime.value = [-Conductor.songPosition/10000];
    }
    override function stepHit(){
        // switch(formattedSong){
        //     case 'rain-of-amethyst':
        //     switch(curStep){
        //         case 18:
        //             // PlayState.snailtrail.visible = true;
        //             // PlayState.snailtrail.active = true;
        //         case 128:
        //             FlxTween.color(dad, 1, dad.color, 0xff5C5C5C, {ease: FlxEase.quadInOut});
        //         case 264:
        //             FlxTween.color(boyfriend, 1, boyfriend.color, 0xff5C5C5C, {ease: FlxEase.quadInOut});
        //             FlxTween.color(floor, 1, floor.color, 0xff5C5C5C, {ease: FlxEase.quadInOut});
        //         case 384:
        //             // PlayState.boetrail.visible = true;
        //             // PlayState.boetrail.active = true;
        //         case 512:
        //             camGame.flash();
        //             for (i in [dad, boyfriend, gf, floor])
        //                 i.color = 0xffFFFFFF;
        //             camHUD.alpha = 1;
        //             shards.alpha = 1;
        //             // PlayState.snailtrail.visible = false;
        //             // PlayState.snailtrail.active = false;
        //             // PlayState.boetrail.visible = false;
        //             // PlayState.boetrail.active = false;
        //             bump = true;
        //         case 1660:
        //             camGame.flash();
        //             for (i in [dad, boyfriend, gf, floor])
        //                 i.color = 0xff5C5C5C;
        //             camHUD.alpha = 0;
        //             shards.alpha = 0;
        //             // PlayState.snailtrail.visible = true;
        //             // PlayState.snailtrail.active = true;
        //             // PlayState.boetrail.visible = true;
        //             // PlayState.boetrail.active = true;
        //             bump = false;
        //         case 1920:
        //             camGame.flash();
        //             for (i in [dad, boyfriend, gf, floor])
        //                 i.color = 0xffFFFFFF;
        //         case 2432:
        //             camGame.flash();
        //             camHUD.alpha = 1;
        //             shards.alpha = 1;
        //             // PlayState.snailtrail.visible = false;
        //             // PlayState.snailtrail.active = false;
        //             // PlayState.boetrail.visible = false;
        //             // PlayState.boetrail.active = false;
        //             bump = true;
        //         case 3456:
        //             camGame.flash();
        //             dad.color = 0xff5C5C5C;
        //             for (i in [boyfriend, gf, floor])
        //                 i.alpha = 0;
        //             camHUD.alpha = 0;
        //             shards.alpha = 0;
        //             // PlayState.snailtrail.visible = true;
        //             // PlayState.snailtrail.active = true;
        //             bump = false;
        //         case 3847:
        //             // PlayState.snailtrail.visible = false;
        //             // PlayState.snailtrail.active = false;
        //             FlxTween.color(dad, 1, dad.color, 0xff000000, {ease: FlxEase.quadInOut});
        //     }
        // }
    }
    override function beatHit(){
        if (bump){
        FlxTween.cancelTweensOf(colorShader);
        colorShader.brightness += 0.5;
        FlxTween.tween(colorShader, {brightness: 0}, 0.5, {ease: FlxEase.quadInOut});
        }
    }
}