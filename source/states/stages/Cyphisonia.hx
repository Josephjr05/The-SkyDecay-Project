package states.stages;

import states.stages.objects.*;

class Cyphisonia extends BaseStage
{
    var bg:FlxSprite;
    var mountainC:FlxSprite;
    var mountainR:FlxSprite;
    var mountainL:FlxSprite;
    var fog1:FlxSprite;
    var fog2:FlxSprite;
    var light:FlxSprite;
    var backMountainR:FlxSprite;
    var monolith:FlxSprite;
    var flame1:FlxSprite;
    var flame2:FlxSprite;

    // copies
    var mountainCBG:FlxSprite;
    var mountainRBG:FlxSprite;

    override function create()
    {
        bg = new FlxSprite(-2050, -800).loadGraphic(Paths.image('stages/camellia/cyphisonia/bg'));
        bg.scrollFactor.set(1, 1);
        bg.scale.set(2, 2);
        bg.updateHitbox();
        bg.antialiasing = ClientPrefs.data.antialiasing;
        add(bg);

        mountainCBG = new FlxSprite(-2050, -150).loadGraphic(Paths.image('stages/camellia/cyphisonia/mountain_c'));
        mountainCBG.scrollFactor.set(1, 1);
        mountainCBG.scale.set(2, 2);
        mountainCBG.updateHitbox();
        mountainCBG.antialiasing = ClientPrefs.data.antialiasing;
        add(mountainCBG);

        mountainRBG = new FlxSprite(-1550, 200).loadGraphic(Paths.image('stages/camellia/cyphisonia/mountain_r'));
        mountainRBG.scrollFactor.set(1, 1);
        mountainRBG.scale.set(2, 2);
        mountainRBG.updateHitbox();
        mountainRBG.antialiasing = ClientPrefs.data.antialiasing;
        add(mountainRBG);

        light = new FlxSprite(-2050, -800).loadGraphic(Paths.image('stages/camellia/cyphisonia/light'));
        light.scrollFactor.set(1, 1);
        light.scale.set(2, 2);
        light.updateHitbox();
        light.antialiasing = ClientPrefs.data.antialiasing;
        add(light);

        backMountainR = new FlxSprite(950, -300).loadGraphic(Paths.image('stages/camellia/cyphisonia/back_mountain_r'));
        backMountainR.scrollFactor.set(1, 1);
        backMountainR.scale.set(2, 2);
        backMountainR.updateHitbox();
        backMountainR.antialiasing = ClientPrefs.data.antialiasing;
        add(backMountainR);

        fog1 = new FlxSprite(-2000, -500).loadGraphic(Paths.image('stages/camellia/cyphisonia/fog_1'));
        fog1.scrollFactor.set(1, 1);
        fog1.scale.set(2, 2);
        fog1.updateHitbox();
        fog1.antialiasing = ClientPrefs.data.antialiasing;
        add(fog1);

        fog2 = new FlxSprite(0, -450).loadGraphic(Paths.image('stages/camellia/cyphisonia/fog_1'));
        fog2.scrollFactor.set(1, 1);
        fog2.scale.set(2, 2);
        fog2.updateHitbox();
        fog2.antialiasing = ClientPrefs.data.antialiasing;
        add(fog2);

        monolith = new FlxSprite(-100, -500).loadGraphic(Paths.image('stages/camellia/cyphisonia/monolith'));
        monolith.scrollFactor.set(1, 1);
        monolith.scale.set(2, 2);
        monolith.updateHitbox();
        monolith.antialiasing = ClientPrefs.data.antialiasing;
        add(monolith);

        flame1 = new FlxSprite(-1650, -350).loadGraphic(Paths.image('stages/camellia/cyphisonia/flame_l'));
        flame1.scrollFactor.set(1, 1);
        flame1.scale.set(2, 2);
        flame1.updateHitbox();
        flame1.antialiasing = ClientPrefs.data.antialiasing;
        add(flame1);

        flame2 = new FlxSprite(950, 200).loadGraphic(Paths.image('stages/camellia/cyphisonia/flame_r'));
        flame2.scrollFactor.set(1, 1);
        flame2.scale.set(2, 2);
        flame2.updateHitbox();
        flame2.antialiasing = ClientPrefs.data.antialiasing;
        add(flame2);

        mountainC = new FlxSprite(-2050, 0).loadGraphic(Paths.image('stages/camellia/cyphisonia/mountain_c'));
        mountainC.scrollFactor.set(1, 1);
        mountainC.scale.set(2, 2);
        mountainC.updateHitbox();
        mountainC.antialiasing = ClientPrefs.data.antialiasing;
        add(mountainC);
    }

    override function createPost()
    {
        mountainL = new FlxSprite(-2050, 930).loadGraphic(Paths.image('stages/camellia/cyphisonia/mountain_l'));
        mountainL.scrollFactor.set(1, 1);
        mountainL.scale.set(2, 2);
        mountainL.updateHitbox();
        mountainL.antialiasing = ClientPrefs.data.antialiasing;
        add(mountainL);

        mountainR = new FlxSprite(700, 1070).loadGraphic(Paths.image('stages/camellia/cyphisonia/mountain_r'));
        mountainR.scrollFactor.set(1, 1);
        mountainR.scale.set(2, 2);
        mountainR.updateHitbox();
        mountainR.antialiasing = ClientPrefs.data.antialiasing;
        add(mountainR);
    }

    // override function update(elapsed:Float)
    // {
    //     game.camFollow.x = 100;
    //     game.camFollow.y = 400;
    // }
}