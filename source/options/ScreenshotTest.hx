package options;

import flash.text.TextField;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import backend.Controls;
import openfl.Lib;

using StringTools;

class ScreenshotTest extends BaseOptionsMenu
{
    public function new()
    {
        title ='Screenshot Test';
        rpcTitle = 'Screenshot Settings'; // discord rich presence nigga

		var option:Option = new Option('Screenshot TEST',
			'If checked, screenshots will save as PNGs.',
			'lossless',
			'bool');
		addOption(option);

		var option:Option = new Option('Garbage Collection Rate',
			"After how many seconds rendered should a garbage collection be performed?\nIf it's set to 0, the game will not garbage collect at all.",
			'renderGCRate',
			'float');
		// addOption(option);

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length-1]];
		
		super();
    }
}