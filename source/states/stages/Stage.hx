package states.stages;

import states.stages.objects.*;
import objects.Character;

class Stage extends BaseStage
{
	var dadbattleBlack:BGSprite;
	var dadbattleLight:BGSprite;
	var dadbattleFog:DadBattleFog;
	var stageBack:FlxSprite;
	var stageFront:FlxSprite;
	var stageLight:FlxSprite;
	var stageCurtains:FlxSprite;
	override function create()
	{
		stageBack = new FlxSprite(-1000, -900).loadGraphic(Paths.image('stages/stage/stageback'));
		stageBack.scale.set(1.3, 1.3);
		stageBack.updateHitbox();
		stageBack.antialiasing = ClientPrefs.data.antialiasing;
		add(stageBack);

		stageFront = new FlxSprite(-1400, -900).loadGraphic(Paths.image('stages/stage/stagefront'));
		stageFront.scale.set(1.6, 1.6);
		stageFront.updateHitbox();
		stageFront.antialiasing = ClientPrefs.data.antialiasing;
		add(stageFront);

		stageLight = new FlxSprite(-425, -800).loadGraphic(Paths.image('stages/stage/stage_light'));
		stageLight.scrollFactor.set(1.9, 1.9);
		stageLight.scale.set(1.9, 1.9);
		stageLight.updateHitbox();
		stageLight.antialiasing = ClientPrefs.data.antialiasing;
		add(stageLight);

		stageLight = new FlxSprite(1525, -800).loadGraphic(Paths.image('stages/stage/stage_light'));
		stageLight.scrollFactor.set(1.9, 1.9);
		stageLight.scale.set(2.1, 2.1);
		stageLight.updateHitbox();
		stageLight.flipX = true;
		stageLight.antialiasing = ClientPrefs.data.antialiasing;
		add(stageLight);

		stageCurtains = new FlxSprite(-1400, -900).loadGraphic(Paths.image('stages/stage/stagecurtains'));
		stageCurtains.scrollFactor.set(1.3, 1.3);
		stageCurtains.scale.set(1.7, 1.7);
		stageCurtains.updateHitbox();
		stageCurtains.antialiasing = ClientPrefs.data.antialiasing;
		add(stageCurtains);
	}
	override function eventPushed(event:objects.Note.EventNote)
	{
		switch(event.event)
		{
			case "Dadbattle Spotlight":
				dadbattleBlack = new BGSprite(null, -800, -400, 0, 0);
				dadbattleBlack.makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
				dadbattleBlack.alpha = 0.25;
				dadbattleBlack.visible = false;
				add(dadbattleBlack);

				dadbattleLight = new BGSprite('spotlight', 400, -400);
				dadbattleLight.alpha = 0.375;
				dadbattleLight.blend = ADD;
				dadbattleLight.visible = false;
				add(dadbattleLight);

				dadbattleFog = new DadBattleFog();
				dadbattleFog.visible = false;
				add(dadbattleFog);
		}
	}

	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float)
	{
		switch(eventName)
		{
			case "Dadbattle Spotlight":
				if(flValue1 == null) flValue1 = 0;
				var val:Int = Math.round(flValue1);

				switch(val)
				{
					case 1, 2, 3: //enable and target dad
						if(val == 1) //enable
						{
							dadbattleBlack.visible = true;
							dadbattleLight.visible = true;
							dadbattleFog.visible = true;
							defaultCamZoom += 0.12;
						}

						var who:Character = dad;
						if(val > 2) who = boyfriend;
						//2 only targets dad
						dadbattleLight.alpha = 0;
						new FlxTimer().start(0.12, function(tmr:FlxTimer) {
							dadbattleLight.alpha = 0.375;
						});
						dadbattleLight.setPosition(who.getGraphicMidpoint().x - dadbattleLight.width / 2, who.y + who.height - dadbattleLight.height + 50);
						FlxTween.tween(dadbattleFog, {alpha: 0.7}, 1.5, {ease: FlxEase.quadInOut});

					default:
						dadbattleBlack.visible = false;
						dadbattleLight.visible = false;
						defaultCamZoom -= 0.12;
						FlxTween.tween(dadbattleFog, {alpha: 0}, 0.7, {onComplete: function(twn:FlxTween) dadbattleFog.visible = false});
				}
		}
	}
}