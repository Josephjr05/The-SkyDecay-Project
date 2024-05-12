package backend;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.Lib;
import flixel.FlxG;

import flash.system.Capabilities;

#if sys
import sys.io.File;
import sys.FileSystem;
#end

using StringTools;

class WindowAttributes
{
    public static function AppTween(x:Float, y:Float, duration:Float)
    {
        FlxTween.tween(Lib.application.window, {width: x, height: y}, duration, {onComplete: function(twn:FlxTween){ trace('im done'); }, onUpdate: function(twn:FlxTween)
        { 
            FlxG.resizeGame(Lib.application.window.width, Lib.application.window.height); 
            Lib.application.window.x = Std.int((Capabilities.screenResolutionX / 2) - (Lib.application.window.width / 2));
            Lib.application.window.y = Std.int((Capabilities.screenResolutionY / 2) - (Lib.application.window.height / 2));
        }});
    }
}