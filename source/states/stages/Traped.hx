package states.stages;

import states.stages.objects.*;

class Traped extends BaseStage {
    var bg:FlxSprite;
    var beds:FlxSprite;
    override function create()
    {
        bg = new FlxSprite(-700, 0).loadGraphic(Paths.image('stages/traped/traped/bg-traped'));
        bg.scale.set(1, 1);
        bg.antialiasing = ClientPrefs.data.antialiasing;
        add(bg);
    
        beds = new FlxSprite(-800, 700).loadGraphic(Paths.image('stages/traped/traped/beds-traped'));
        beds.scale.set(1,1);
        beds.antialiasing = ClientPrefs.data.antialiasing;
        add(beds);
    }
}