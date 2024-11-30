package states.stages;

import cutscenes.DialogueBoxPsych; // to use dialogue json

import states.stages.objects.*;

class Planet extends BaseStage
{
	var background:FlxSprite;
	var planetshaper:FlxSprite;
	var foreground:FlxSprite;
	var stage:FlxSprite;
	override function create()
	{
		background = new FlxSprite(-1000, -730).loadGraphic(Paths.image('stages/camellia/planet/background'));
		background.scale.set(1.5, 1.5);
		background.updateHitbox();
		background.antialiasing = ClientPrefs.data.antialiasing;
		add(background);

		planetshaper = new FlxSprite(-270, -750).loadGraphic(Paths.image('stages/camellia/planet/planetshaper'));
		planetshaper.scale.set(1.9, 1.7);
		planetshaper.updateHitbox();
		planetshaper.antialiasing = ClientPrefs.data.antialiasing;
		add(planetshaper);

		stage = new FlxSprite(-1650, -1384).loadGraphic(Paths.image('stages/camellia/planet/stage'));
		stage.scale.set(1.85, 1.9);
		stage.updateHitbox();
		stage.antialiasing = ClientPrefs.data.antialiasing;
		add(stage);

		foreground = new FlxSprite(-3400, -2930).loadGraphic(Paths.image('stages/camellia/planet/foreground'));
		foreground.scale.set(2.5, 2.5);
		foreground.updateHitbox();
		foreground.antialiasing = ClientPrefs.data.antialiasing;
		add(foreground);

		if (!isStoryMode)
		{
			switch (songName)
			{
				case 'dreamless-wanderer': //FUCK YOU LUA WE'RE GOING SOURCE CODE!!
					if (!seenCutscene) {
						setStartCallback(function() {
							game.startDialogue(DialogueBoxPsych.parseDialogue(Paths.json(songName + '/dialogue')),'peacefulGalaxy');
						});
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		game.camFollow.x = 600;
		game.camFollow.y = 410;
	}
}