package states.stages;

import backend.window.CppAPI;

class Desktop extends BaseStage
{
    var bg:FlxSprite;
    var wasFullscreen:Bool = false;
    var windowTitle = lime.app.Application.current.window.title;

    override function create()
    {
        wasFullscreen = FlxG.fullscreen;
        bg = new FlxSprite(0, 0, null);
        bg.makeGraphic(FlxG.width, FlxG.height, 0x00000000);
        add(bg);

        #if windows 
        CppAPI.setTransparency(windowTitle, 0x00000000);
        if (!FlxG.fullscreen)
        {
            FlxG.fullscreen = false;
        }

        // Set window to borderless
        lime.app.Application.current.window.borderless = true;
        
        // Optionally set the window size to match the display
        lime.app.Application.current.window.width = FlxG.width;
        lime.app.Application.current.window.height = FlxG.height;
        
        // Position window at top-left corner
        lime.app.Application.current.window.x = 0;
        lime.app.Application.current.window.y = 0;
        #end

        super.create();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }

    override function destroy()
    {
        #if windows
        CppAPI.setTransparency(windowTitle, 0x00000001);
        lime.app.Application.current.window.borderless = false;
        FlxG.fullscreen = wasFullscreen;
        #end
        super.destroy();
    }
}