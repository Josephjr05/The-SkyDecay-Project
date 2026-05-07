package backend;

import openfl.utils.AssetType;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.utils.Assets;
import flixel.FlxG;
import flixel.system.ui.FlxSoundTray;
import haxe.Log;
#if sys
import sys.io.File;
import sys.FileSystem;
#end

class FunkinSoundTray extends FlxSoundTray
{
    var graphicScale:Float = 0.30;
    var lerpYPos:Float = 0;
    var alphaTarget:Float = 0;

    var volumeMaxSound:String;

    public function new()
    {
        super();

        removeChildren();

        var bg:Bitmap = new Bitmap(getPathImage('soundtray/volumebox'));
        bg.scaleX = graphicScale;
        bg.scaleY = graphicScale;
        addChild(bg);

        y = -height;
        screenCenter();

        var backingBar:Bitmap = new Bitmap(getPathImage('soundtray/bars_10'));
        backingBar.x = 9;
        backingBar.y = 5;
        backingBar.scaleX = graphicScale;
        backingBar.scaleY = graphicScale;
        backingBar.alpha = 0.4;
        addChild(backingBar);

        _bars = [];

        for (i in 1...11)
        {
            var bar:Bitmap = new Bitmap(getPathImage('soundtray/bars_$i'), false);
            bar.x = 9;
            bar.y = 5;
            bar.scaleX = graphicScale;
            bar.scaleY = graphicScale;
            addChild(bar);
            _bars.push(bar);
        }

        y = -height;
        screenCenter();

        volumeUpSound = 'Volup';
        volumeDownSound = 'Voldown';
        volumeMaxSound = 'VolMAX';
    }

    function getPathImage(path:String):BitmapData
    {
        final filename = 'images/$path.png';
        final assetPath = Paths.getPath(filename, AssetType.IMAGE);

        #if MODS_ALLOWED
        return BitmapData.fromFile(assetPath);
        #end
        return Assets.getBitmapData(assetPath);
    }

    function getTraySound(soundName:String):Dynamic
    {
        if (soundName == null || soundName == '') return null;

        #if MODS_ALLOWED
        return Paths.returnSound('sounds/soundtray/$soundName');
        #else
        final fullpath = 'sounds/soundtray/$soundName.mp3';
        final assetPath = Paths.getPath(fullpath, AssetType.SOUND);
        return Assets.getSound(assetPath);
        #end
    }

    function playSoundByName(name:String):Void
    {
        var sound = getTraySound(name);
        if (sound != null)
            FlxG.sound.load(sound).play();
    }

    override public function update(MS:Float):Void
    {
        y = CoolUtil.coolLerp(y, lerpYPos, 0.1);
        alpha = CoolUtil.coolLerp(alpha, alphaTarget, 0.25);

        if (_timer > 0)
        {
            _timer -= (MS / 1000);
            alphaTarget = 1;
        }
        else if (y >= -height)
        {
            lerpYPos = -height - 10;
            alphaTarget = 0;
        }

        if (y <= -height)
        {
            visible = false;
            active = false;

            #if FLX_SAVE
            if (FlxG.save.isBound)
            {
                FlxG.save.data.mute = FlxG.sound.muted;
                FlxG.save.data.volume = FlxG.sound.volume;
                FlxG.save.flush();
            }
            #end
        }
    }

    override public function showAnim(volume:Float, ?sound:Dynamic, duration:Float = 1.0, label:String = 'VOLUME'):Void
    {
        _timer = duration;
        lerpYPos = 10;
        alphaTarget = 1;
        visible = true;
        active = true;

        var globalVolume:Int = Math.round(volume * 10);
        if (globalVolume < 0) globalVolume = 0;
        if (globalVolume > 10) globalVolume = 10;

        if (!silent)
        {
            var requestedSound:String = sound != null ? Std.string(sound) : '';
            if (globalVolume == 10)
                playSoundByName(volumeMaxSound);
            else if (requestedSound == Std.string(volumeUpSound))
                playSoundByName(Std.string(volumeUpSound));
            else if (requestedSound == Std.string(volumeDownSound))
                playSoundByName(Std.string(volumeDownSound));
            else if (requestedSound != '')
                playSoundByName(requestedSound);
        }

		for (i in 0..._bars.length)
		{
            _bars[i].visible = (i < globalVolume);
		}
	}
}