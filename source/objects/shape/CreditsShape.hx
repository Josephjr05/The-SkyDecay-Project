package objects.shape;

import objects.shape.ShapeEX;
import openfl.display.BitmapData;
import flixel.graphics.FlxGraphic;
import openfl.display.Shape;

class ModsButtonRect extends FlxSpriteGroup //play/back button
{
    var background:Rect;
    var text:FlxText;
    var box:FlxSprite;

    var saveColor:FlxColor;

    public var list:Array<Array<String>> = [];
    public var onClick:Void->Void = null;
    public var folder:String = 'unknownMod';

	public function new(X:Float, Y:Float, width:Float = 0, height:Float = 0, roundWidth:Float = 0, roundHeight:Float = 0, texts:String = '', ?specPath:Bool = false, textOffset:Float = 0, color:FlxColor = FlxColor.WHITE, onClick:Void->Void = null)
    {
        super(X, Y);

        box = new FlxSprite();

        this.folder = texts;

        var bmp:FlxGraphic;
        if (!specPath)
        {
            bmp = Paths.cacheBitmap(Paths.mods('$folder/pack.png'));
            if(bmp == null)
            {
                bmp = Paths.cacheBitmap(Paths.mods('$folder/pack-pixel.png'));
            }
        } else {
            bmp = Paths.cacheBitmap(Paths.getSharedPath('images/menuExtend/CreditsState/groupIcon/$folder.png'));
        }

        if(bmp != null)
        {
            box.loadGraphic(bmp, true, 150, 150);
        }
        else box.loadGraphic(Paths.image('unknownMod'), true, 150, 150);
        box.scale.set(0.5, 0.5);
        box.updateHitbox();
		
        text = new FlxText(0, 0, 0, texts, 22);
        text.color = FlxColor.WHITE;
        text.font = Paths.font('montserrat.ttf');
        text.antialiasing = ClientPrefs.data.antialiasing;
        if (text.width > width - box.width - 20) text.scale.x = (width - box.width - 20) / text.width;

        background = new Rect(0, 0, width, height, roundWidth, roundHeight, color);
        background.color = color;
        background.alpha = 0.6;
        background.antialiasing = ClientPrefs.data.antialiasing;
        add(background);
        add(text);
        add(box);

        text.x += box.width + 20;
        text.x += (width - box.width - 20) / 2 - text.width / 2;
        text.y += background.height / 2 - text.height / 2;

        box.x += background.width / 32 - box.width / 32;
        box.y += (background.height / 2 - box.height / 2) - 1;

        box.updateHitbox();
        text.updateHitbox();

        this.onClick = onClick;
        this.saveColor = color;
	}

    public var focusChangeCallback:Bool->Void = null;
	public var onFocus:Bool = false;
	public var ignoreCheck:Bool = false;
	var needFocusCheck:Bool = false;
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(!ignoreCheck && !Controls.instance.controllerMode)
            onFocus = FlxG.mouse.overlaps(this);

        if(onFocus && onClick != null && FlxG.mouse.justReleased)
            //click();

        if (onFocus)
        {
            background.alpha = 1;
            needFocusCheck = true;
        } else {
            if (needFocusCheck)
            {
                background.alpha = 0.6;
                needFocusCheck = false;
            }
        }
    }
}

class CreditsNote extends FlxSprite
{
    public var sprTracker:FlxSprite;
    var char:String = '';
    var link:String = '';

    public function new(char:String, link:String, ?allowGPU:Bool = true)
    {
        super();

        this.char = char;
        this.link = link;

        alpha = 0.8;

        changeIcon(char, allowGPU);
    }

	override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (CoolUtil.mouseOverlaps(this))
        {
            alpha = 1;
            if (FlxG.mouse.justReleased)
            {
                CoolUtil.browserLoad(link);
            }
        }
        else {
            alpha = 0.8;
        }
    }

    private var iconOffsets:Array<Float> = [0, 0];
	public function changeIcon(char:String, ?allowGPU:Bool = true) {
        var name:String = 'menuExtend/CreditsState/linkButton';
        
        var graphic = Paths.image(name, allowGPU);
        var delimiter:Int = 150;
        loadGraphic(graphic, true, delimiter, graphic.height);
        updateHitbox();

        animation.add(char, [for (i in 0...numFrames) i], 0, false);
        animation.play(char);
        animation.curAnim.curFrame = 0;

        if (char == "github") animation.curAnim.curFrame = 0;
        else if (char == "youtube") animation.curAnim.curFrame = 1;
        else if (char == "x.com" || char == "twitter") animation.curAnim.curFrame = 2;
        else if (char == "discord") animation.curAnim.curFrame = 3;
        else if (char == "bilibili" || char == "b23.tv") animation.curAnim.curFrame = 4;
        else if (char == "douyin") animation.curAnim.curFrame = 5;
        else if (char == "kuaishou") animation.curAnim.curFrame = 6;
        else animation.curAnim.curFrame = 7;
	}

	override function updateHitbox()
	{
		super.updateHitbox();
		offset.x = iconOffsets[0];
		offset.y = iconOffsets[1];
	}
}