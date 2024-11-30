package states.stages;

import states.stages.objects.*;

class LimuCastle extends BaseStage
{
    var bg:FlxSprite;
    var wall:FlxSprite;
    var thunder:FlxSprite;
    var thunderFrame:FlxSprite;
    var blackedge:FlxSprite;
    var veinLeft:FlxSprite;
    var veinRight:FlxSprite;
    var netLeft:FlxSprite;
    var netRight:FlxSprite;
    
    override function create()
    {
        // backgrounds from Lua (updateHitbox takes it and adds it to the center as if it's from Lua) - Joseph
        bg = new FlxSprite(-250, -100).loadGraphic(Paths.image('stages/Limu/1/1_bg'));
        bg.scrollFactor.set(1, 1);
        bg.scale.set(1, 1);
		bg.updateHitbox();
		bg.antialiasing = ClientPrefs.data.antialiasing;
        add(bg);

        wall = new FlxSprite(-250, -100).loadGraphic(Paths.image('stages/Limu/1/1_wall'));
        wall.scrollFactor.set(1, 1);
        wall.scale.set(1, 1);
        wall.updateHitbox();
		wall.antialiasing = ClientPrefs.data.antialiasing;
        add(wall);

        veinLeft = new FlxSprite(-125, 0).loadGraphic(Paths.image('stages/Limu/1/1_vein_left'));
        veinLeft.scrollFactor.set(.7, .7);
        veinLeft.scale.set(1, 1);
        veinLeft.updateHitbox();
        veinLeft.antialiasing = ClientPrefs.data.antialiasing;
        add(veinLeft);

        veinRight = new FlxSprite(-400, 0).loadGraphic(Paths.image('stages/Limu/1/1_vein_right'));
        veinRight.scrollFactor.set(.7, .7);
        veinRight.scale.set(1, 1);
        veinRight.updateHitbox();
        veinRight.antialiasing = ClientPrefs.data.antialiasing;
        add(veinRight);

        netLeft = new FlxSprite(-125, 0).loadGraphic(Paths.image('stages/Limu/1/1_net_left'));
        netLeft.scrollFactor.set(.6, .6);
        netLeft.scale.set(1, 1);
        netLeft.updateHitbox();
		netLeft.antialiasing = ClientPrefs.data.antialiasing;
        add(netLeft);

        netRight = new FlxSprite(-425, -175).loadGraphic(Paths.image('stages/Limu/1/1_net_right'));
        netRight.scrollFactor.set(.8, .8);
        netRight.scale.set(1, 1);
        netRight.updateHitbox();
        netRight.antialiasing = ClientPrefs.data.antialiasing;
        add(netRight);
    }
}