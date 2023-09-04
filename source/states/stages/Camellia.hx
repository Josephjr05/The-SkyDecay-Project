package states.stages;

import states.stages.objects.*;

class Camellia extends BaseStage
{
	var city:FlxSprite;
	var wall:FlxSprite;
	var floor:FlxSprite;
	override function create()
	{
		city = new FlxSprite(-750, -450).loadGraphic(Paths.image('stages/camellia/Week1/BG_CITY'));
		city.scale.set(1.55, 1.55);
		city.antialiasing = ClientPrefs.data.antialiasing;
		add(city);

		wall = new FlxSprite(-750, -450).loadGraphic(Paths.image('stages/camellia/Week1/BG_WALL'));
		wall.scale.set(1.55, 1.55);
		wall.antialiasing = ClientPrefs.data.antialiasing;
		add(wall);

		floor = new FlxSprite(-750, -450).loadGraphic(Paths.image('stages/camellia/Week1/FG_Floor'));
		floor.scale.set(1.55, 1.55);
		floor.antialiasing = ClientPrefs.data.antialiasing;
		add(floor);
	}
}