package objects;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
// import flixel.system.FlxSound;
#if sys
import sys.io.File;
import sys.FileSystem;
#else
import openfl.utils.Assets;
#end

using StringTools;

class ExtendUtil
{
	public static function makeSolid(spr:FlxSprite, Width:Int, Height:Int, Color:FlxColor = FlxColor.WHITE, Unique:Bool = false, ?Key:String) {
		spr.makeGraphic(1, 1, Color, Unique, Key);
        spr.setGraphicSize(Width, Height);
        spr.updateHitbox();
        return spr;
	}
}