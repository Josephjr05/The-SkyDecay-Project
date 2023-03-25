package;

#if cpp
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import WeekData;

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var backdrop:FlxSprite;

	private static var curDifficulty:Int = 1;

	private static var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var difficultySelectors:FlxGroup;
	var sprDifficultyGroup:FlxTypedGroup<FlxSprite>;
	var chaptersGroup:FlxTypedGroup<FlxSprite>;

	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var leftArrow2:FlxSprite;
	var rightArrow2:FlxSprite;

	var songArray = [];

	var randomArray:Array<String> = [
		'.', 
		'.', 
		'.'
	];

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		/* switch(curWeek)
		{
			case 0:
				songArray = [];
			case 1:
				songArray = [];
			case 2:
				songArray = [];
			case 3:
				songArray = [];
			case 4:
				songArray = [];
			case 5:
				songArray = [];
			case 6:
				songArray = [];
			case 7:
				songArray = [];
			case 8:
				songArray = [];
			case 9:
				songArray = [];
			case 10:
				songArray = [];
			case 11:
				songArray = [];
			case 12:
				songArray = [];
			case 13:
				songArray = [];
			case 14:
				songArray = [];
		} */

		backdrop = new FlxSprite().loadGraphic(Paths.image('storymenu/purple back'));
		backdrop.setGraphicSize(FlxG.width, FlxG.height);
		backdrop.screenCenter();
		add(backdrop);

		chaptersGroup = new FlxTypedGroup<FlxSprite>();

		for (i in 0...randomArray.length)
		{
			var chapters:FlxSprite = new FlxSprite(920, 315 + (i * 230));
			chapters.loadGraphic(Paths.image('storymenu/chapter${i}'));
			chapters.ID = i;
			chaptersGroup.add(chapters);
			/* if (chapters.ID == 0 || chapters.ID == 1)
				trace(chapters.y); */
		}

		add(chaptersGroup);
	}

	var cooldown:Bool = false;

	override function update(elapsed:Float)
	{
		if(!cooldown)
		{
			if (controls.UI_UP)
			{
				changeWeek(-1);
			}
			if (controls.UI_DOWN)
			{
				changeWeek(1);
			}
		}
	}

	function changeWeek(change:Int = 0)
	{
		if (change == -1 && curWeek != 0 || change == 1 && curWeek != 14)
		{
			curWeek += change;
			cooldown = true;
		}

		chaptersGroup.forEach(function(spr:FlxSprite)
		{
			if (change == -1 && curWeek != 0)
			{
				if (spr.ID == curWeek - 1 || spr.ID == curWeek || spr.ID == curWeek + 1)
					FlxTween.tween(spr, {y: spr.y + 230}, 0.5, {ease: FlxEase.cubeOut});
				if (spr.ID == curWeek)
					FlxTween.tween(spr, {alpha: 1}, 0.5, {ease: FlxEase.cubeOut, onComplete: function (twn:FlxTween)
					{
						if (spr.ID < curWeek)
							spr.y = 315 - 230;
						if (spr.ID > curWeek + 1)
							spr.y = 545 + 230;

						cooldown = false;
					}
				});
			}

			if (change == 1 && curWeek != 14)
			{
				if (spr.ID == curWeek - 1 || spr.ID == curWeek || spr.ID == curWeek + 1)
					FlxTween.tween(spr, {y: spr.y - 230}, 0.5, {ease: FlxEase.cubeOut});
				if (spr.ID == curWeek - 1)
					FlxTween.tween(spr, {alpha: 0}, 0.5, {ease: FlxEase.cubeOut, onComplete: function (twn:FlxTween)
					{
						if (spr.ID < curWeek)
							spr.y = 315 - 230;
						if (spr.ID > curWeek + 1)
							spr.y = 545 + 230;

						cooldown = false;
					}
				});
			}
		});
			

		trace(curWeek);
	}

	function updateText()
	{
	
	}
}
