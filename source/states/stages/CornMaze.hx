package states.stages;

import states.stages.objects.*;

class CornMaze extends BaseStage
{
    var corn:FlxSprite;
    override function create()
    {
        corn = new FlxSprite(-600, -200).loadGraphic(Paths.image('stages/bambi/corn'));
        corn.scale.set(1, 1);
        corn.antialiasing = ClientPrefs.data.antialiasing;
        add(corn);
    }
}