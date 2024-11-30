package backend;

@:cppInclude('windows.h')
class WallpaperUtil {
    /**
     * Changes wallpaper which is in `path`. Do a warning for players in your mod if you want use this function!!!!
     * @param path Path to image, if `old` then restore wallpapers
     * @param absolute If false, `path` => mods/images/`path`.png
     * @return Bool - If false, wallpaper wasnt changed / target isnt Windows
    */

    @:noCompletion
        public static var oldWallpaper(default, null):String;

    @:noCompletion
        public static function setOld():Void
        {
            oldWallpaper = _setOld();
        }

     @:functionCode('
        WCHAR buffer[1024] = {0};
        SystemParametersInfoW(SPI_GETDESKWALLPAPER, 256, &buffer, NULL);
        return String(buffer);
    ')
	@:noCompletion
	    private static function _setOld():String
		    return "";

    public static function changeWallpaper(path:String, ?absolute:Bool) {
        if(path != 'old') { 
            if (!absolute) path = Paths.modsImages(path);
        } else {
            if(oldWallpaper != null) path = oldWallpaper;
            else 
                return;
        }

        var process = new sys.io.Process('TASKKILL /F /IM wallpaper32.exe /T');

        return #if windows untyped __cpp__('SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, (void*){0}.c_str(), SPIF_UPDATEINIFILE)', sys.FileSystem.absolutePath(path)) #else false #end;
    }
}
