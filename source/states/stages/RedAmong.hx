package states.stages;

var bgred:BGSprite;
var tables:BGSprite;

var chairback:FlxSprite;
var table:FlxSprite;
var chair:FlxSprite;
var back:FlxSprite;

class RedAmong extends BaseStage{
    override function create() { 
        var bgred:BGSprite = new BGSprite('stages/traped/red/bg-red', -1900, 0);
        bgred.scale.set(1, 1);
        bgred.antialiasing = ClientPrefs.data.antialiasing;
        add(bgred);

        var tables:BGSprite = new BGSprite('stages/traped/red/tables-red', -1200, 680);
        tables.scale.set(1, 1);
        tables.antialiasing = ClientPrefs.data.antialiasing;
        add(tables);
    }

    override function createPost()
    {
        chairback = new FlxSprite(-100, 870).loadGraphic(Paths.image('stages/traped/red/chairback-red'));
        chairback.scale.set(1, 1);
        chairback.antialiasing = ClientPrefs.data.antialiasing;
        add(chairback);

        table = new FlxSprite(0, 820).loadGraphic(Paths.image('stages/traped/red/table-red'));
        table.scale.set(1, 1);
        table.antialiasing = ClientPrefs.data.antialiasing;
        add(table);

        chair = new FlxSprite(-100, 1050).loadGraphic(Paths.image('stages/traped/red/chair-red'));
        chair.scale.set(1, 1);
        chair.antialiasing = ClientPrefs.data.antialiasing;
        add(chair);

        back = new FlxSprite(-600, 800);
        back.frames = Paths.getSparrowAtlas('stages/traped/red/back-red');
        back.animation.addByPrefix('Back', 'Back0', 24, true);
        back.animation.play('Back');
        back.scale.set(0.9, 0.9);
        back.antialiasing = ClientPrefs.data.antialiasing;
        add(back);
    }
}

