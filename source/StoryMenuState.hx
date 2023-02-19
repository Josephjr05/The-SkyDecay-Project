package;

#if desktop
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
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import flixel.graphics.FlxGraphic;
import WeekData;

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var backdrop:FlxSprite;

	override function create()
	{
		backdrop = new FlxSprite().loadGraphic(Paths.image('storymenu/purple back'));
		backdrop.setGraphicSize(FlxG.width, FlxG.height);
		backdrop.screenCenter();
		add(backdrop);
	}

	override function update(elapsed:Float)
	{
		if (controls.BACK)
		{
			MusicBeatState.switchState(new MainMenuState());
		}
	}

	function selectWeek()
	{
		
	}

	function changeDifficulty(change:Int = 0):Void
	{
		
	}

	function changeWeek(change:Int = 0):Void
	{
		
	}

	function updateText()
	{
	
	}
}
