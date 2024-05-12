package backend;

import backend.GPUBitmap;

import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;

class Cache {

    public static var cache:Map<String, FlxGraphic> = new Map<String, FlxGraphic>();

    public static function add(path:String):Void{
        
        var data:FlxGraphic = FlxGraphic.fromBitmapData(GPUBitmap.create(path));
        data.persist = true;
        data.destroyOnNoUse = false;

        if(data == null)
            trace('cant find it :(');

        cache.set(path, data);
    }

    public static function get(path:String):FlxGraphic{
        return cache.get(path);
    }

    public static function exists(path:String){
        return cache.exists(path);
    }

}