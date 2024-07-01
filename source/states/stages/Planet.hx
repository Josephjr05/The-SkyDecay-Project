package states.stages;

import states.stages.objects.*;

class Planet extends BaseStage
{
	var background:FlxSprite;
	var foreground:FlxSprite;
	var stage:FlxSprite;
	override function create()
	{
		background = new FlxSprite(-750, -500).loadGraphic(Paths.image('stages/camellia/planet/background'));
		background.scale.set(2.5, 3);
		background.antialiasing = ClientPrefs.data.antialiasing;
		add(background);

		foreground = new FlxSprite(-750, -450).loadGraphic(Paths.image('stages/camellia/planet/foreground'));
		foreground.scale.set(2.5, 3);
		foreground.antialiasing = ClientPrefs.data.antialiasing;
		add(foreground);

		stage = new FlxSprite(-750, -450).loadGraphic(Paths.image('stages/camellia/planet/stage'));
		stage.scale.set(2.5, 3);
		stage.antialiasing = ClientPrefs.data.antialiasing;
		add(stage);
	}

	override function update(elapsed:Float)
		{
			game.camFollow.x = 600;
			game.camFollow.y = 410;
		}
}