package backend;

import flixel.addons.display.FlxPieDial;
import states.TitleState;
import flixel.input.gamepad.FlxGamepad;

// Thank you notmagniill for helping me get the skip function in! - Joseph

class SkipPie extends FlxTypedSpriteGroup<FlxSprite>
{
    public var pieDial:FlxPieDial;
    var tex:FlxText;
    var fog:FlxSprite;
    var finished:Bool = false;

    public function new()
    {
        super();

        fog = new FlxSprite();
        fog.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        fog.alpha = 0;
        add(fog);

        pieDial = new FlxPieDial(FlxG.width - 120, FlxG.height - 120, 50, FlxColor.WHITE, 36, FlxPieDialShape.CIRCLE, true, 40);
        pieDial.amount = 0.0;
        pieDial.replaceColor(FlxColor.BLACK, FlxColor.TRANSPARENT);
        pieDial.antialiasing = ClientPrefs.data.antialiasing;
        add(pieDial);

        tex = new FlxText(pieDial.x + 30, pieDial.y + 35, 0, ">>");
        tex.setFormat("VCR OSD Mono", 35, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        tex.alpha = 0;
        add(tex);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

        if (FlxG.keys.pressed.ENTER)
        {
            tex.alpha = 1;
            pieDial.amount += elapsed * 2;
            pieDial.visible = true;
            if (!finished && pieDial.amount >= 1.0) {
                finished = true;

                MusicBeatState.switchState(new TitleState());
                TitleState.playedIntro = true;
            }
        }
        else
        {
            pieDial.amount -= elapsed * 6;
            tex.alpha -= elapsed;
        }
        if (pieDial.amount <= 0.03)
        {
            pieDial.visible = false;
        }

        fog.alpha = pieDial.amount;
    }
}