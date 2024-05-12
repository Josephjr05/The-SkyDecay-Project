package states;

import backend.Cache;

import openfl.display.BitmapData;
import backend.Highscore;

import flixel.input.keyboard.FlxKey;
import flixel.addons.transition.FlxTransitionableState;

class Loadup extends MusicBeatState
{

    //wanted to make a preload thing but nah
    var welcome:FlxSprite;

    public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

    override public function create():Void
    {
        Paths.clearStoredMemory();

		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];


        FlxG.save.bind('funkin', CoolUtil.getSavePath());

		ClientPrefs.loadPrefs();

        Highscore.load();
        
        if(FlxG.save.data != null && FlxG.save.data.fullscreen)
		{
			FlxG.fullscreen = FlxG.save.data.fullscreen;
			//trace('LOADED FULLSCREEN SETTING!!');
		}
		persistentUpdate = true;
		persistentDraw = true;

        if (FlxG.save.data.weekCompleted != null)
		{
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		}

        FlxG.mouse.visible = false;

        transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

        super.create();

        FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
        
        MusicBeatState.switchState(new FreeplayState());
        
        // preload("assets/");
        // load();
    }

    function load():Void
    {

    }

    function preload(directory:String = "") {
        if(sys.FileSystem.exists(directory)) {
            // trace("directory found: " + directory);
            for (file in sys.FileSystem.readDirectory(directory)) {
                var path = haxe.io.Path.join([directory, file]);
                if (!sys.FileSystem.isDirectory(path)) {

                    if (path.endsWith(".png") || path.endsWith(".jpg")) {
                        var bitmap = BitmapData.fromFile(path);

                        if(bitmap == null)
                            trace("bitmap not found: " + path);
                        else {
                            if(!path.contains("assets/week"))
                                Cache.add(path);
                            else {
                                //cannot cache
                            }
                        }

                    } else if (path.endsWith(".mp4")) {

                    } else if (path.endsWith(".ogg")) {

                    }
                    
                } else {
                    var directory = haxe.io.Path.addTrailingSlash(path);
                    // trace("directory found: " + directory);
                    preload(directory);
                }
            }
        } else {
            trace("directory not found: " + directory);
        }
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }
}