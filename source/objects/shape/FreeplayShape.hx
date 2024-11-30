package objects.shape;

import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import flash.geom.Point;
import flash.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.display.Shape;
import objects.shape.ShapeEX;

import flixel.util.FlxSpriteUtil;
import flixel.util.FlxStringUtil; 

import states.FreeplayState;

class SpecRect extends FlxSprite //freeplay bg rect
{
    var mask:FlxSprite;
    var sprite:FlxSprite;

	public function new(X:Float, Y:Float, Path:String)
    {
        super(X, Y);
        
        sprite = new FlxSprite(X, Y).loadGraphic(Paths.image(Path));

        updateRect(sprite.pixels);
	}

	function drawRect():BitmapData {
        var shape:Shape = new Shape();
    
        var p1:Point = new Point(0, 0);
        var p2:Point = new Point(FlxG.width * 0.492, 0);
        var p3:Point = new Point(FlxG.width * 0.45, FlxG.height * 0.4);
        var p4:Point = new Point(0, FlxG.height * 0.4);

        shape.graphics.beginFill(0xFFFFFF); 
        shape.graphics.lineStyle(1, 0xFFFFFF, 1);
        shape.graphics.moveTo(p1.x, p1.y);
        shape.graphics.lineTo(p2.x, p2.y);
        shape.graphics.lineTo(p3.x, p3.y);
        shape.graphics.lineTo(p4.x, p4.y);
        shape.graphics.lineTo(p1.x, p1.y);
        shape.graphics.endFill();

        var bitmap:BitmapData = new BitmapData(Std.int(p2.x + 5), Std.int(p3.y), true, 0);
        bitmap.draw(shape);
        return bitmap;
    }

    function drawLine():BitmapData {
        var shape:Shape = new Shape();
    
        var p1:Point = new Point(0, 0);
        var p2:Point = new Point(FlxG.width * 0.492, 0);
        var p3:Point = new Point(FlxG.width * 0.45, FlxG.height * 0.4);
        var p4:Point = new Point(0, FlxG.height * 0.4);

        shape.graphics.beginFill(0xFFFFFF); 
        shape.graphics.lineStyle(2, 0xFFFFFF, 1);
        shape.graphics.moveTo(p1.x, p1.y);
        shape.graphics.lineTo(p2.x, p2.y);
        shape.graphics.endFill();

        shape.graphics.beginFill(0xFFFFFF);
        shape.graphics.lineStyle(2, 0xFFFFFF, 1, true, NONE, NONE, ROUND, 1);
        shape.graphics.moveTo(p2.x, p2.y);
        shape.graphics.lineTo(p3.x, p3.y);
        shape.graphics.endFill();

        shape.graphics.beginFill(0xFFFFFF);
        shape.graphics.lineStyle(2, 0xFFFFFF, 1);
        shape.graphics.moveTo(p3.x, p3.y);
        shape.graphics.lineTo(p4.x, p4.y);
        shape.graphics.endFill();

        shape.graphics.beginFill(0xFFFFFF);
        shape.graphics.lineStyle(2, 0xFFFFFF, 1);
        shape.graphics.moveTo(p4.x, p4.y);
        shape.graphics.lineTo(p1.x, p1.y);
        shape.graphics.endFill();

        var bitmap:BitmapData = new BitmapData(Std.int(p2.x + 5), Std.int(p3.y), true, 0);
        bitmap.draw(shape);
        return bitmap;
    }

    public function updateRect(sprite:BitmapData) {
        mask = new FlxSprite(0, 0).loadGraphic(drawRect());
        var matrix:Matrix = new Matrix();
        var data:Float = mask.width / sprite.width;
        if (mask.height / sprite.height > data) data = mask.height / sprite.height;
        matrix.scale(data, data);
        matrix.translate(-(sprite.width * data - mask.width) / 2, -(sprite.height * data - mask.height) / 2);

		var bitmap:BitmapData = sprite;

        var resizedBitmapData:BitmapData = new BitmapData(Std.int(mask.width), Std.int(mask.height), true, 0x00000000);
        resizedBitmapData.draw(bitmap, matrix);
		resizedBitmapData.copyChannel(mask.pixels, new Rectangle(0, 0, mask.width, mask.height), new Point(), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);

        var lineBitmap:BitmapData = drawLine();
        resizedBitmapData.draw(lineBitmap);

        pixels = resizedBitmapData;
        antialiasing = ClientPrefs.data.antialiasing;
    }
}

class SpecRectBG extends FlxSprite //freeplay bg rect
{
	public function new(X:Float, Y:Float)
    {
        super(X, Y);
		
        loadGraphic(drawRect());
        antialiasing = ClientPrefs.data.antialiasing;
	}

	function drawRect():BitmapData {
        var shape:Shape = new Shape();
    
        var p1:Point = new Point(0, 0);
        var p2:Point = new Point(FlxG.width * 0.55, 0);
        var p3:Point = new Point(FlxG.width * 0.5, FlxG.height * 0.5);
        var p4:Point = new Point(0, FlxG.height * 0.5);

        var p5:Point = new Point(0, FlxG.height * 0.5);
        var p6:Point = new Point(FlxG.width * 0.5, FlxG.height * 0.5);
        var p7:Point = new Point(FlxG.width * 0.55, FlxG.height * 1);
        var p8:Point = new Point(0, FlxG.height * 1);

        shape.graphics.beginFill(0x000000); 
        shape.graphics.lineStyle(1, 0x000000, 1);
        shape.graphics.moveTo(p1.x, p1.y);
        shape.graphics.lineTo(p2.x, p2.y);
        shape.graphics.lineTo(p3.x, p3.y);
        shape.graphics.lineTo(p4.x, p4.y);
        shape.graphics.lineTo(p1.x, p1.y);
        shape.graphics.endFill();

        shape.graphics.beginFill(0x000000); 
        shape.graphics.lineStyle(1, 0x000000, 1);
        shape.graphics.moveTo(p5.x, p5.y);
        shape.graphics.lineTo(p6.x, p6.y);
        shape.graphics.lineTo(p7.x, p7.y);
        shape.graphics.lineTo(p8.x, p8.y);
        shape.graphics.lineTo(p5.x, p5.y);
        shape.graphics.endFill();

        var bitmap:BitmapData = new BitmapData(Std.int(p2.x), Std.int(p8.y), true, 0);
        bitmap.draw(shape);
        return bitmap;
    }
}

class InfoText extends FlxSpriteGroup //freeplay info
{
    public var data(default, set):Float = -9999;
    public var maxData:Float = 0;
    
    var BlackBG:Rect;
    var WhiteBG:Rect;
    var dataText:FlxText;

    public function new(X:Float, Y:Float, texts:String, maxData:Float)
    {
        super(X, Y);
        
        this.maxData = maxData;

        var text:FlxText = new FlxText(0, 0, 0, texts, 18);
		text.font = Paths.font('montserrat.ttf');	    		
        add(text);
        
        BlackBG = new Rect(130, text.height / 2 - 3, FlxG.width * 0.26, 5, 5, 5, FlxColor.WHITE, 0.6);
        add(BlackBG);

        WhiteBG = new Rect(130, text.height / 2 - 3, FlxG.width * 0.26, 5, 5, 5);
        add(WhiteBG);    

        dataText = new FlxText(490, 0, 0, Std.string(data), 18);
		dataText.font = Paths.font('montserrat.ttf');	    		
        add(dataText);

        data = 0;
        antialiasing = ClientPrefs.data.antialiasing;
    }

    private function set_data(value:Float):Float
    {
        if (data == value) return data;
        data = value;
        dataText.text = Std.string(data);
        return value;
    }

    override function update(elapsed:Float)
    {
        if (FreeplayState.instance.ignoreCheck) return;
        
        if (Math.abs((WhiteBG._frame.frame.width / WhiteBG.width) - (data / maxData)) > 0.01)
        {
            if (Math.abs((WhiteBG._frame.frame.width / WhiteBG.width) - (data / maxData)) < 0.005) WhiteBG._frame.frame.width = Std.int(WhiteBG.width * (data / maxData));
            else WhiteBG._frame.frame.width = Std.int(WhiteBG.width * FlxMath.lerp((data / maxData), (WhiteBG._frame.frame.width / WhiteBG.width), Math.exp(-elapsed * 15)));
            WhiteBG.updateHitbox();
        }
        if (WhiteBG._frame.frame.width >= WhiteBG.width)
        {
            WhiteBG._frame.frame.width = WhiteBG.width;
        }
        super.update(elapsed);
    }
}

class ExtraAudio extends FlxSpriteGroup
{
    var leftLine:FlxSprite;
    var downLine:FlxSprite;
    public var audioDis:AudioDisplay;

	public function new(X:Float, Y:Float, width:Float = 0, height:Float = 0, snd:FlxSound = null)
    {
        super(X, Y);
		
        leftLine = new FlxSprite().makeGraphic(3, Std.int(height - 3));
        add(leftLine);

        downLine = new FlxSprite(0, Std.int(height) - 3).makeGraphic(Std.int(width), 3);
        add(downLine);

        audioDis = new AudioDisplay(snd, 5, height - 5, Std.int(width - 5), Std.int(height - 5), 40, 2, FlxColor.WHITE);
        add(audioDis);
	}
}

class MusicLine extends FlxSpriteGroup
{
    var blackLine:FlxSprite;
    var whiteLine:FlxSprite;

    var timeDis:FlxText;
    var timeMaxDis:FlxText;
    public var playRate:FlxText;

    var timeAddRect:MusicRect;
    var timeReduceRect:MusicRect;

    var rateAddRect:MusicRect;
    var rateReduceRect:MusicRect;

	public function new(X:Float, Y:Float, width:Float = 0)
    {
        super(X, Y);
		
        blackLine = new FlxSprite().makeGraphic(Std.int(width), 5);
        blackLine.color = 0xffffff;
        blackLine.alpha = 0.5;
        add(blackLine);

        whiteLine = new FlxSprite().makeGraphic(1, 5);
        add(whiteLine);

        timeDis = new FlxText(0, 20, 0, '0', 18);
		timeDis.font = Paths.font('montserrat.ttf');	
        timeDis.alignment = LEFT;  	    		
        timeDis.antialiasing = ClientPrefs.data.antialiasing;
        add(timeDis);

        timeAddRect = new MusicRect(410, 23, '+1S');
        add(timeAddRect);
        timeReduceRect = new MusicRect(70, 23, '-1S');
        add(timeReduceRect);

        rateAddRect = new MusicRect(320, 23, '+5%');
        add(rateAddRect);
        rateReduceRect = new MusicRect(160, 23, '-5%');
        add(rateReduceRect);

        timeMaxDis = new FlxText(0, 20, 0, '0', 18);
		timeMaxDis.font = Paths.font('montserrat.ttf');	  
        timeMaxDis.alignment = RIGHT;  	
        timeMaxDis.antialiasing = ClientPrefs.data.antialiasing;	
        add(timeMaxDis);

        playRate = new FlxText(0, 20, 0, '1', 18);
		playRate.font = Paths.font('montserrat.ttf');	
        timeDis.alignment = CENTER;    		
        playRate.antialiasing = ClientPrefs.data.antialiasing;
        add(playRate);
        playRate.x += width / 2 - playRate.width / 2;

        new FlxTimer().start(0.2, function(tmr:FlxTimer){
			timeMaxDis.text = Std.string(FlxStringUtil.formatTime(FlxMath.roundDecimal(FlxG.sound.music.length / 1000, 2)));
            timeMaxDis.x = X + width - timeMaxDis.width;

            timeDis.text = Std.string(FlxStringUtil.formatTime(FlxMath.roundDecimal(FlxG.sound.music.time / 1000, 2)));

            playRate.text = Std.string(FlxG.sound.music.pitch);
            playRate.x = X + width / 2 - playRate.width / 2;
		}, 0);
	}

    var holdTime:Float = 0;
    var canHold:Bool = false;
    override function update(e:Float) {
        super.update(e);

        whiteLine.scale.x = FlxG.sound.music.time / FlxG.sound.music.length * blackLine.width;

        whiteLine.x = blackLine.x + whiteLine.scale.x / 2;

        if (this.visible == false) return; //奇葩bug

        if (FreeplayState.instance.ignoreCheck) return;

        if (FlxG.mouse.justReleased) 
        {
            holdTime = 0;
            canHold = false;
        }

        if (FlxG.mouse.overlaps(timeAddRect) || FlxG.mouse.overlaps(timeReduceRect) || FlxG.mouse.overlaps(rateAddRect) || FlxG.mouse.overlaps(rateReduceRect)) {
            if (FlxG.mouse.justPressed) {
                canHold = true;
                if (FlxG.mouse.overlaps(timeAddRect)) FreeplayState.instance.updateMusicTime(1, false);
                else if (FlxG.mouse.overlaps(timeReduceRect)) FreeplayState.instance.updateMusicTime(-1, false);
                else if (FlxG.mouse.overlaps(rateAddRect)) FreeplayState.instance.updateMusicRate(1);
                else if (FlxG.mouse.overlaps(rateReduceRect)) FreeplayState.instance.updateMusicRate(-1);
            }

            if (FlxG.mouse.pressed){
                holdTime += e;
            }

            if (holdTime > 0.5 && canHold) {
                holdTime -= 0.1;
                if (FlxG.mouse.overlaps(timeAddRect)) FreeplayState.instance.updateMusicTime(1, true);
                else if (FlxG.mouse.overlaps(timeReduceRect)) FreeplayState.instance.updateMusicTime(-1, true);
                else if (FlxG.mouse.overlaps(rateAddRect)) FreeplayState.instance.updateMusicRate(1);
                else if (FlxG.mouse.overlaps(rateReduceRect)) FreeplayState.instance.updateMusicRate(-1);
            }
        }
    }
}


class MusicRect extends FlxSpriteGroup
{
    var bg:Rect;
    var display:FlxText;

	public function new(X:Float, Y:Float, text:String)
    {
        super(X, Y);

		bg = new Rect(0, 0, 60, 20, 20, 20, FlxColor.WHITE, 0.3);
        add(bg);

        display = new FlxText(0, 0, 0, text, 15);
		display.font = Paths.font('montserrat.ttf');		    		
        display.antialiasing = ClientPrefs.data.antialiasing;
        add(display);
        display.x += bg.width / 2 - display.width / 2;
        display.y += bg.height / 2 - display.height / 2;
	}

    var fouced:Bool = false;
    override function update(elapsed:Float) {
        super.update(elapsed);
        if (FreeplayState.instance.ignoreCheck) return;
        
        if (FlxG.mouse.overlaps(bg))
        {
            if (!fouced)
            {
                fouced = true;
                bg.alpha = 1;
                display.color = 0x000000;
            }          
        } else {
            if (fouced)
            {
                fouced = false;
                bg.alpha = 0.3;
                display.color = 0xffffff;
            }    
        }
    }
}

class ExtraTopRect extends FlxSpriteGroup
{
    var background:FlxSprite;
    var text:FlxText;

    var saveColor:FlxColor;

    public var onClick:Void->Void = null;

	public function new(X:Float, Y:Float, width:Float = 0, height:Float = 0, roundSize:Float = 0, roundLeft:Bool = true, texts:String = '', textOffset:Float = 0, color:FlxColor = FlxColor.WHITE, onClick:Void->Void = null)
    {
        super(X, Y);
		
        text = new FlxText(textOffset, 0, 0, texts, 17);
		text.font = Paths.font('montserrat.ttf'); 	
        text.antialiasing = ClientPrefs.data.antialiasing;	

        background = new FlxSprite(0, 0);
        background.pixels = drawRect(width, height, roundSize, roundLeft);
        background.alpha = 0.4;
        background.color = color;
        background.antialiasing = ClientPrefs.data.antialiasing;
        add(background);
        add(text);

        text.x += background.width / 2 - text.width / 2;
        text.y += background.height / 2 - text.height / 2;

        this.onClick = onClick;
        this.saveColor = color;
	}

    function drawRect(width:Float, height:Float, roundSize:Float, roundLeft:Bool):BitmapData {
        var shape:Shape = new Shape();

        shape.graphics.beginFill(0xFFFFFFFF); 
        shape.graphics.lineStyle(1, 0xFFFFFFFF, 1);
        if (roundLeft) shape.graphics.drawRoundRectComplex(0, 0, width, height, roundSize, 0, 0, 0);
        else shape.graphics.drawRoundRectComplex(0, 0, width, height, 0, roundSize, 0, 0);
        shape.graphics.endFill();

        var bitmap:BitmapData = new BitmapData(Std.int(width), Std.int(height), true, 0);
        bitmap.draw(shape);
        return bitmap;
    }

	public var onFocus:Bool = false;
	public var ignoreCheck:Bool = false;
	var needFocusCheck:Bool = false;
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        if (FreeplayState.instance.ignoreCheck) return;

        if(!ignoreCheck)
            onFocus = FlxG.mouse.overlaps(this);

        if(onFocus && onClick != null && FlxG.mouse.justReleased)
            onClick();

        if (onFocus)
        {
            text.color = FlxColor.BLACK;     
            background.color = FlxColor.WHITE;
            background.alpha = 0.4;
            needFocusCheck = true;
        } else {
            if (needFocusCheck)
            {
                text.color = FlxColor.WHITE;
                background.alpha = 0.4;
                background.color = saveColor;
                needFocusCheck = false;
            }
        }
    }
}

class ResultRect extends FlxSpriteGroup
{
    var background:FlxSprite;
    
    var colorArrayAlpha:Array<FlxColor> = [
    		0x7FFFFF00, //perfect
    		0x7F00FFFF, //great
    	    0x7F00FF00, //good
    	    0x7FFF7F00, //ok
    	    0x7FFF5858, //shit
    	    0x7FFF0000 //miss
    		];
    var ColorArray:Array<FlxColor> = [
    		0xFFFFFF00, //perfect
    		0xFF00FFFF, //great
    	    0xFF00FF00, //good
    	    0xFFFF7F00, //ok
    	    0xFFFF5858, //shit
    	    0xFFFF0000 //miss
    		];
    var safeZoneOffset:Float = (ClientPrefs.data.safeFrames / 60) * 1000;
    
    var _width:Float;
    var _height:Float;
    
    public function new(X:Float, Y:Float, width:Float = 0, height:Float = 0)
    {
        super();
        background = new FlxSprite();
        background.alpha = 0;
        add(background);
        updateRect();
        
        this._width = width;
        this._height = height;
    }
    
    public function updateRect(?msGroup:Array<Float>, ?timeGroup:Array<Float>)
    {
        var shape:Shape = new Shape();

        if (msGroup != null && timeGroup != null && msGroup.length > 0){
            for (i in 0...msGroup.length){
                var color:FlxColor;
                if (Math.abs(msGroup[i]) <= ClientPrefs.data.perfectWindow && ClientPrefs.data.perfectRating) color = ColorArray[0];
    		    else if (Math.abs(msGroup[i]) <= ClientPrefs.data.greatWindow) color = ColorArray[1];
    		    else if (Math.abs(msGroup[i]) <= ClientPrefs.data.goodWindow) color = ColorArray[2];
    		    else if (Math.abs(msGroup[i]) <= ClientPrefs.data.okWindow) color = ColorArray[3];
    		    else if (Math.abs(msGroup[i]) <= safeZoneOffset) color = ColorArray[4];
    		    else color = ColorArray[5];	
    		    
    		    var data = msGroup[i];
    		    if (Math.abs(msGroup[i]) > safeZoneOffset) data = safeZoneOffset; 	
    		    
    		    shape.graphics.beginFill(color);     		    
                shape.graphics.drawCircle(_width * (timeGroup[i] / timeGroup[timeGroup.length - 1]), _height / 2 + _height / 2 * (data / safeZoneOffset), 1.8);
                shape.graphics.endFill();	
            }
        }
        
        shape.graphics.beginFill(0x7FFFFFFF); 
        shape.graphics.drawRect(0, _height / 2 - 1, _width, 1);
        shape.graphics.endFill();
        
        shape.graphics.beginFill(colorArrayAlpha[0]); 
        shape.graphics.drawRect(0, _height / 2 - (ClientPrefs.data.perfectWindow / safeZoneOffset) * _height / 2 - 1, _width, 1);
        shape.graphics.drawRect(0, _height / 2 + (ClientPrefs.data.perfectWindow / safeZoneOffset) * _height / 2 - 1, _width, 1);
        shape.graphics.endFill();
        
        shape.graphics.beginFill(colorArrayAlpha[1]); 
        shape.graphics.drawRect(0, _height / 2 - (ClientPrefs.data.greatWindow / safeZoneOffset) * _height / 2 - 1, _width, 1);
        shape.graphics.drawRect(0, _height / 2 + (ClientPrefs.data.greatWindow / safeZoneOffset) * _height / 2 - 1, _width, 1);
        shape.graphics.endFill();
        
        shape.graphics.beginFill(colorArrayAlpha[2]); 
        shape.graphics.drawRect(0, _height / 2 - (ClientPrefs.data.goodWindow / safeZoneOffset) * _height / 2 - 1, _width, 1);
        shape.graphics.drawRect(0, _height / 2 + (ClientPrefs.data.goodWindow / safeZoneOffset) * _height / 2 - 1, _width, 1);
        shape.graphics.endFill();
        
        shape.graphics.beginFill(colorArrayAlpha[3]); 
        shape.graphics.drawRect(0, _height / 2 - (ClientPrefs.data.okWindow / safeZoneOffset) * _height / 2 - 1, _width, 1);
        shape.graphics.drawRect(0, _height / 2 + (ClientPrefs.data.okWindow / safeZoneOffset) * _height / 2 - 1, _width, 1);
        shape.graphics.endFill();

        shape.graphics.beginFill(colorArrayAlpha[4]); 
        shape.graphics.drawRect(1, _height / 2 - (safeZoneOffset / safeZoneOffset) * _height / 2 - 1, _width, 1);
        shape.graphics.drawRect(0, _height / 2 + (safeZoneOffset / safeZoneOffset) * _height / 2 - 1, _width, 1);
        shape.graphics.endFill();
        
        var bitmap:BitmapData = new BitmapData(Std.int(_width), Std.int(_height + 5), true, 0);
        bitmap.draw(shape);
        
        background.pixels = bitmap;
        background.alpha = 1;
    }
}

class EventRect extends FlxSpriteGroup //freeplay bottom bg rect
{
    public var background:FlxSprite;
    var text:FlxText;

    public var onClick:Void->Void = null;
    var _y:Float = 0;

	public function new(X:Float, Y:Float, texts:String, color:FlxColor, onClick:Void->Void = null)
    {
        super(X, Y);
		
        text = new FlxText(0, 0, 0, texts, 18);
		text.font = Paths.font('montserrat.ttf'); 	
        text.antialiasing = ClientPrefs.data.antialiasing;	

        background = new FlxSprite().loadGraphic(drawRect(text.width + 60));
        background.color = color;
        background.alpha = 0.5;
        background.antialiasing = ClientPrefs.data.antialiasing;
        add(background);
        add(text);

        var touchFix:Rect = new Rect(0, 0, (text.width + 60), FlxG.height * 0.1, 0, 0, FlxColor.WHITE, 0);
        add(touchFix);

        text.x += background.width / 2 - text.width / 2;
        text.y += FlxG.height * 0.1 / 2 - text.height / 2;

        _y = Y;
        this.onClick = onClick;
	}

    function drawRect(width:Float):BitmapData {
        var shape:Shape = new Shape();

        var p1:Point = new Point(2, 0);
        var p2:Point = new Point(width + 2, 0);
        var p3:Point = new Point(width, 5);
        var p4:Point = new Point(0, 5);

        shape.graphics.beginFill(0xFFFFFFFF); 
        shape.graphics.lineStyle(1, 0xFFFFFFFF, 1);
        shape.graphics.moveTo(p1.x, p1.y);
        shape.graphics.lineTo(p2.x, p2.y);
        shape.graphics.lineTo(p3.x, p3.y);
        shape.graphics.lineTo(p4.x, p4.y);
        shape.graphics.lineTo(p1.x, p1.y);
        shape.graphics.endFill();

        var bitmap:BitmapData = new BitmapData(Std.int(p2.x), 5, true, 0);
        bitmap.draw(shape);
        return bitmap;
    }

	public var onFocus:Bool = false;
	public var ignoreCheck:Bool = false;
	private var _needACheck:Bool = false;
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        if (FreeplayState.instance.ignoreCheck) return;

        if(!ignoreCheck)
            onFocus = FlxG.mouse.overlaps(this);

        if(onFocus && onClick != null && FlxG.mouse.justReleased)
            onClick();

        if (onFocus)
        {
            background.alpha += elapsed * 8;
            if (background.scale.y < 2) background.scale.y += elapsed * 8;
        } else {
            if (background.alpha > 0.5) background.alpha -= elapsed * 8;
            if (background.scale.y > 1) background.scale.y -= elapsed * 8;
        }

        if (background.scale.y < 1) background.scale.y = 1;
        background.y = _y + (background.scale.y - 1) * 2.5;
    }
}

class SongRect extends FlxSpriteGroup //songs member for freeplay
{
    public var diffRectGroup:FlxSpriteGroup; //我只是懒的整图层了
    public var diffRectArray:Array<DiffRect> = []; //获取DiffRect，因为FlxSpriteGroup识别为flxSprite（粑粑haxe我服了）
    public var background:FlxSprite;
    var icon:HealthIcon;
    var songName:FlxText;
    var muscan:FlxText;

    public var member:Int;
    public var name:String;
    public var haveAdd:Bool = false;

	public function new(X:Float, Y:Float, songNameS:String, songChar:String, songColor:FlxColor)
    {
        super(X, Y);

        diffRectGroup = new FlxSpriteGroup(0, 0);
        add(diffRectGroup);

        var mask:Rect = new Rect(0, 0, 700, 90, 25, 25);

        var extraLoad:Bool = false;
        var filesLoad = 'songs/' + songNameS + '/background';
        if (FileSystem.exists(Paths.modFolders(filesLoad + '.png'))){
            extraLoad = true;
        } else {
            filesLoad = 'menuDesat';
            extraLoad = false;
        }			

        background = new FlxSprite(0, 0).loadGraphic(Paths.image(filesLoad, null, true));
        
        var matrix:Matrix = new Matrix();
        var data:Float = mask.width / background.width;
        if (mask.height / background.height > data) data = mask.height / background.height;
        matrix.scale(data, data);
        matrix.translate(-(background.width * data - mask.width) / 2, -(background.height * data - mask.height) / 2);

		var bitmap:BitmapData = background.pixels;

        var resizedBitmapData:BitmapData = new BitmapData(Std.int(mask.width), Std.int(mask.height), true, 0x00000000);
        resizedBitmapData.draw(bitmap, matrix);
		resizedBitmapData.copyChannel(mask.pixels, new Rectangle(0, 0, mask.width, mask.height), new Point(), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);

        background.pixels = resizedBitmapData;
        background.color = songColor;
        background.antialiasing = ClientPrefs.data.antialiasing;
        add(background);

        var lineBitmap:BitmapData = drawLine(resizedBitmapData.width, resizedBitmapData.height);
        var lineSprite = new FlxSprite();
        lineSprite.pixels = lineBitmap;
        add(lineSprite); //只能拆分不然会被着色

        icon = new HealthIcon(songChar);
        icon.setGraphicSize(Std.int(background.height * 0.8));
        icon.x += 60 - icon.width / 2;
        icon.y += background.height / 2 - icon.height / 2;
		icon.updateHitbox();
        add(icon);

        songName = new FlxText(100, 5, 0, songNameS, 25);
		songName.font = Paths.font('montserrat.ttf'); 	
        songName.antialiasing = ClientPrefs.data.antialiasing;	
        add(songName);

        this.name = songNameS;
	}

    function drawLine(width:Float, height:Float):BitmapData {
        var shape:Shape = new Shape();
        var lineSize:Int = 3;
        shape.graphics.beginFill(0xFFFFFF);
        shape.graphics.lineStyle(1, 0xFFFFFF, 1);
        shape.graphics.drawRoundRect(0, 0, width, height, 25, 25);
        shape.graphics.lineStyle(0, 0, 0);
        shape.graphics.drawRoundRect(lineSize, lineSize, width - lineSize * 2, height - lineSize * 2, 20, 20);
        shape.graphics.endFill();

        var bitmap:BitmapData = new BitmapData(Std.int(width), Std.int(height), true, 0);
        bitmap.draw(shape);
        return bitmap;
    }

    public var posX:Float = -70;
    public var lerpPosX:Float = 0;
    public var posY:Float = 0;
    public var lerpPosY:Float = 0;
    public var onFocus(default, set):Bool = true;
    public var ignoreCheck:Bool = false;
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        if (FreeplayState.instance.ignoreCheck) return;

        if (onFocus)
        {
            if (Math.abs(lerpPosX - posX) < 0.1) lerpPosX = posX;
            else lerpPosX = FlxMath.lerp(posX, lerpPosX, Math.exp(-elapsed * 15));
        } else {
            if (Math.abs(lerpPosX - 0) < 0.1) {
                lerpPosX = 0; 
                if (haveDiffDis) desDiff();
            }
            else lerpPosX = FlxMath.lerp(0, lerpPosX, Math.exp(-elapsed * 15));
        }

        if (member > FreeplayState.curSelected)
        {
            if (Math.abs(lerpPosY - posY) < 0.1) lerpPosY = posY;
            else lerpPosY = FlxMath.lerp(posY, lerpPosY, Math.exp(-elapsed * 15));
        } else {
            if (Math.abs(lerpPosY - 0) < 0.1) lerpPosY = 0;
            else lerpPosY = FlxMath.lerp(0, lerpPosY, Math.exp(-elapsed * 15));
        }

        if (FlxG.mouse.justReleased)
        {
            for (num in 0...diffRectArray.length)
            {
                if (FlxG.mouse.overlaps(diffRectArray[num]))
                {
                    diffRectArray[num].onFocus = true;
                    FreeplayState.curDifficulty = diffRectArray[num].member;
                    FreeplayState.instance.updateDiff();
                } 
            }
            for (num in 0...diffRectArray.length)
            {
                if (num != FreeplayState.curDifficulty) diffRectArray[num].onFocus = false;
            }
        }

        if (ignoreCheck) {
            if (alpha - 0 < 0.05) alpha = 0;
            else alpha = FlxMath.lerp(0, alpha, Math.exp(-elapsed * 15));
        } else {
            var maxAlpha = onFocus ? 1 : 0.6;
            if (Math.abs(maxAlpha - alpha) < 0.05) alpha = maxAlpha;
            else alpha = FlxMath.lerp(1, alpha, Math.exp(-elapsed * 15));
        }
    }

    var tween:FlxTween;
    private function set_onFocus(value:Bool):Bool
    {
        if (onFocus == value) return onFocus;
        onFocus = value;
        if (onFocus) 
        {
            if (tween != null) tween.cancel();
                tween = FlxTween.tween(this, {alpha: 1}, 0.2);
        } else {
            if (tween != null) tween.cancel();
                tween = FlxTween.tween(this, {alpha: 0.6}, 0.2);
        }
        return value;
    }

    var haveDiffDis:Bool = false;
    public function createDiff(color:FlxColor, imme:Bool = false) 
    {
        desDiff();
        haveDiffDis = true;
        for (diff in 0...Difficulty.list.length)
        {
            var rect = new DiffRect(Difficulty.list[diff], color, this);
            diffRectGroup.add(rect);
            diffRectArray.push(rect);
            rect.member = diff;
            rect.posY = background.height + 10 + diff * 70;
            if (imme) rect.lerpPosY = rect.posY;
            if (diff == FreeplayState.curDifficulty) rect.onFocus = true;
            else rect.onFocus = false;
        }
    }

    public function desDiff() 
    {
        haveDiffDis = false;
        if (diffRectArray.length < 1) return;
        for (i in 0...diffRectGroup.length){
            diffRectArray.shift();    
        }

        for (member in diffRectGroup.members)
        {         
            if (member == null) return; //奇葩bug了属于
            diffRectGroup.remove(member);
		    member.destroy();
        }
    }
}

class DiffRect extends FlxSpriteGroup //songs member for freeplay
{
    var background:Rect;
    var triItems:FlxSpriteGroup;
    var bgLine:FlxSprite;

    var diffName:FlxText;
    var charterName:FlxText;

    var follow:SongRect;

    public var member:Int;

	public function new(name:String, color:FlxColor, point:SongRect)
    {
        super();

        background = new Rect(0, 0, 700, 60, 20, 20, color);
        add(background);

        for (i in 0...5)
        {
            var size:Float = FlxG.random.float(10, 25);
            var tri:Triangle = new Triangle(FlxG.random.float(100, background.width - 100), FlxG.random.float(background.height / 2 - 25, background.height / 2 - 10), size, 1);
            tri.alpha = FlxG.random.float(0.2, 0.8);
            tri.angle = FlxG.random.float(0, 60);
            add(tri);
        }

        diffName = new FlxText(15, 5, 0, name, 20);
		diffName.font = Paths.font('montserrat.ttf'); 	
        diffName.antialiasing = ClientPrefs.data.antialiasing;	
        add(diffName);

        bgLine = new FlxSprite();
        bgLine.pixels = drawLine(background.width, background.height);
        add(bgLine);

        this.follow = point;

        y = follow.y + lerpPosY;
        x = 660 + Math.abs(y + height / 2 - FlxG.height / 2) / FlxG.height / 2 * 250 + lerpPosX;
	}

    function drawLine(width:Float, height:Float):BitmapData {
        var shape:Shape = new Shape();
        var lineSize:Int = 1;
        shape.graphics.beginFill(0xFFFFFF);
        shape.graphics.drawRoundRect(0, 0, width, height, 20, 20);
        shape.graphics.drawRoundRect(lineSize, lineSize, width - lineSize * 2, height - lineSize * 2, 20, 20);
        shape.graphics.endFill();

        var bitmap:BitmapData = new BitmapData(Std.int(width), Std.int(height), true, 0);
        bitmap.draw(shape);
        return bitmap;
    }

    public var posX:Float = -50;
    public var lerpPosX:Float = 0;
    public var posY:Float = 0;
    public var lerpPosY:Float = 0;
    public var onFocus(default, set):Bool = true;
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        if (FreeplayState.instance.ignoreCheck) return;
        
        if (follow.onFocus)
        {
            if (Math.abs(lerpPosY - posY) < 0.1) lerpPosY = posY;
            else lerpPosY = FlxMath.lerp(posY, lerpPosY, Math.exp(-elapsed * 15));
        } else {
            onFocus = false;
            if (tween != null) tween.cancel();
            tween = FlxTween.tween(this, {alpha: 0}, 0.1);
            if (Math.abs(lerpPosY - 0) < 0.1) lerpPosY = 0;
            else lerpPosY = FlxMath.lerp(0, lerpPosY, Math.exp(-elapsed * 15));
        }

        if (onFocus)
        {
            if (Math.abs(lerpPosX - posX) < 0.1) lerpPosX = posX;
            else lerpPosX = FlxMath.lerp(posX, lerpPosX, Math.exp(-elapsed * 15));
        } else {
            if (Math.abs(lerpPosX - 0) < 0.1) lerpPosX = 0;
            else lerpPosX = FlxMath.lerp(0, lerpPosX, Math.exp(-elapsed * 15));
        }

        y = follow.y + lerpPosY;
        x = 660 + Math.abs(y + height / 2 - FlxG.height / 2) / FlxG.height / 2 * 250 + lerpPosX;
    }
    
    var tween:FlxTween;
    private function set_onFocus(value:Bool):Bool
    {
        if (onFocus == value) return onFocus;
        onFocus = value;
        if (onFocus) 
        {
            if (tween != null) tween.cancel();
                tween = FlxTween.tween(this, {alpha: 1}, 0.2);
        } else {
            if (tween != null) tween.cancel();
                tween = FlxTween.tween(this, {alpha: 0.5}, 0.2);
        }
        return value;
    }
}

class BackRect extends FlxSpriteGroup //back button
{
    var background:Rect;
    var bg2:FlxSprite;
    var button:FlxSprite; 
    var text:FlxText;

    public var onClick:Void->Void = null;

    var saveColor:FlxColor = 0;
    var saveColor2:FlxColor = 0;

	public function new(X:Float, Y:Float, width:Float = 0, height:Float = 0, texts:String = '', color:FlxColor = FlxColor.WHITE, onClick:Void->Void = null)
    {
        super(X, Y);

        bg2 = new FlxSprite(-60);
        bg2.pixels = drawRect(width, height);
        bg2.color = color;
        bg2.antialiasing = ClientPrefs.data.antialiasing;
        add(bg2);

        background = new Rect(0, 0, height, height);
        background.color = color;
        add(background); 

        var line = new Rect(background.width - 3, 0, 3, height, 0, 0, 0xFFFFFFFF);
        line.alpha = 0.75;
        add(line);

        button = new FlxSprite(0,0).loadGraphic(Paths.image('menuExtend/FreePlayState/playButton'));
        button.scale.set(0.4, 0.4);
        button.antialiasing = ClientPrefs.data.antialiasing;
        button.x += background.width / 2 - button.width / 2;
        button.y += background.height / 2 - button.height / 2;
        button.flipX = true;
        add(button);

        text = new FlxText(70, 0, 0, texts, 18);
		text.font = Paths.font('montserrat.ttf'); 	
        text.antialiasing = ClientPrefs.data.antialiasing;	
        add(text);

        text.x += background.width / 2 - text.width / 2;
        text.y += background.height / 2 - text.height / 2;

        this.onClick = onClick;
        this.saveColor = color;
        saveColor2 = color;
        saveColor2.lightness = 0.5;
	}

    function drawRect(width:Float, height:Float):BitmapData {
        var shape:Shape = new Shape();

        var p1:Point = new Point(10, 0);
        var p2:Point = new Point(width + 10, 0);
        var p3:Point = new Point(width, height);
        var p4:Point = new Point(0, height);

        shape.graphics.beginFill(0xFFFFFFFF); 
        shape.graphics.lineStyle(1, 0xFFFFFFFF, 1);
        shape.graphics.moveTo(p1.x, p1.y);
        shape.graphics.lineTo(p2.x, p2.y);
        shape.graphics.lineTo(p3.x, p3.y);
        shape.graphics.lineTo(p4.x, p4.y);
        shape.graphics.lineTo(p1.x, p1.y);
        shape.graphics.endFill();

        var bitmap:BitmapData = new BitmapData(Std.int(p2.x), Std.int(height), true, 0);
        bitmap.draw(shape);
        return bitmap;
    }

	public var onFocus:Bool = false;
    var bgTween:FlxTween;
    var textTween:FlxTween;
    var focused:Bool = false;
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        if (FreeplayState.instance.ignoreCheck) return;
        
        onFocus = FlxG.mouse.overlaps(this);

        if(onFocus && onClick != null && FlxG.mouse.justReleased)
            onClick();

        if (onFocus)
        {
            if (!focused){
                focused = true;
                if (bgTween != null) bgTween.cancel();
                bgTween = FlxTween.tween(bg2, {x: 0}, 0.3, {ease: FlxEase.backInOut});

                if (textTween != null) textTween.cancel();
                textTween = FlxTween.tween(text, {x: 105}, 0.3, {ease: FlxEase.backInOut});
          
                background.color = saveColor2;
            }
        } else {
            if (focused){
                focused = false;
                if (bgTween != null) bgTween.cancel();
                bgTween = FlxTween.tween(bg2, {x: -60}, 0.3, {ease: FlxEase.backInOut});

                if (textTween != null) textTween.cancel();
                textTween = FlxTween.tween(text, {x: 77}, 0.3, {ease: FlxEase.backInOut});
                
                background.color = saveColor;
            }
        }
    }
}

class PlayRect extends FlxSpriteGroup //back button
{
    var background:Rect;
    var bg2:FlxSprite;
    var button:FlxSprite; 
    var text:FlxText;

    public var onClick:Void->Void = null;

    var saveColor:FlxColor = 0;
    var saveColor2:FlxColor = 0;

	public function new(X:Float, Y:Float, width:Float = 0, height:Float = 0, texts:String = '', color:FlxColor = FlxColor.WHITE, onClick:Void->Void = null)
    {
        super(X - width, Y);

        var touchFix:Rect = new Rect(0, 0, width, height);
        touchFix.alpha = 0;
        add(touchFix);

        bg2 = new FlxSprite(50);
        bg2.pixels = drawRect(width, height);
        bg2.color = color;
        bg2.antialiasing = ClientPrefs.data.antialiasing;
        add(bg2);

        background = new Rect(width - height, 0, height, height);
        background.color = color;
        add(background); 

        var line = new Rect(width - height, 0, 3, height, 0, 0, 0xFFFFFFFF);
        line.alpha = 0.75;
        add(line);

        button = new FlxSprite(width - height,0).loadGraphic(Paths.image('menuExtend/FreePlayState/playButton'));
        button.scale.set(0.4, 0.4);
        button.antialiasing = ClientPrefs.data.antialiasing;
        button.x += background.width / 2 - button.width / 2;
        button.y += background.height / 2 - button.height / 2;
        add(button);

        text = new FlxText(60, 0, 0, texts, 18);
		text.font = Paths.font('montserrat.ttf'); 	
        text.antialiasing = ClientPrefs.data.antialiasing;	
        add(text);

        text.x += background.width / 2 - text.width / 2;
        text.y += background.height / 2 - text.height / 2;

        this.onClick = onClick;
        this.saveColor = color;
        saveColor2 = color;
        saveColor2.lightness = 0.5;
	}

    function drawRect(width:Float, height:Float):BitmapData {
        var shape:Shape = new Shape();

        var p1:Point = new Point(10, 0);
        var p2:Point = new Point(width + 10, 0);
        var p3:Point = new Point(width, height);
        var p4:Point = new Point(0, height);

        shape.graphics.beginFill(0xFFFFFFFF); 
        shape.graphics.lineStyle(1, 0xFFFFFFFF, 1);
        shape.graphics.moveTo(p1.x, p1.y);
        shape.graphics.lineTo(p2.x, p2.y);
        shape.graphics.lineTo(p3.x, p3.y);
        shape.graphics.lineTo(p4.x, p4.y);
        shape.graphics.lineTo(p1.x, p1.y);
        shape.graphics.endFill();

        var bitmap:BitmapData = new BitmapData(Std.int(p2.x), Std.int(height), true, 0);
        bitmap.draw(shape);
        return bitmap;
    }

	public var onFocus:Bool = false;
    var bgTween:FlxTween;
    var textTween:FlxTween;
    var focused:Bool = false;
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        if (FreeplayState.instance.ignoreCheck) return;
        
        onFocus = FlxG.mouse.overlaps(this);

        if(onFocus && onClick != null && FlxG.mouse.justReleased)
            onClick();

        if (onFocus)
        {
            if (!focused){
                focused = true;
                if (bgTween != null) bgTween.cancel();
                bgTween = FlxTween.tween(bg2, {x: FlxG.width - 190}, 0.3, {ease: FlxEase.backInOut});

                if (textTween != null) textTween.cancel();
                textTween = FlxTween.tween(text, {x: FlxG.width - 160}, 0.3, {ease: FlxEase.backInOut});
                var color = 
                background.color = saveColor2;
            }
        } else {
            if (focused){
                focused = false;
                if (bgTween != null) bgTween.cancel();
                bgTween = FlxTween.tween(bg2, {x: FlxG.width - 150}, 0.3, {ease: FlxEase.backInOut});

                if (textTween != null) textTween.cancel();
                textTween = FlxTween.tween(text, {x: FlxG.width - 130}, 0.3, {ease: FlxEase.backInOut});
                
                background.color = saveColor;
            }
        }
    }
}

class SearchButton extends FlxSpriteGroup
{
    var bg:Rect;
    var search:PsychUIInputText;
    var tapText:FlxText;
    var itemDis:FlxText;

    public function new(X:Float, Y:Float, width:Float = 0, height:Float = 0) 
    {
        super(X, Y);

        bg = new Rect(0, 0, width, height, 25, 25, 0x000000);
        add(bg);

        search = new PsychUIInputText(5, 5, Std.int(width - 10), '', 30);
        search.bg.visible = false;
        search.behindText.alpha = 0;
        search.textObj.font = Paths.font('montserrat.ttf');
        search.textObj.color = FlxColor.WHITE;
        search.caret.color = 0x727E7E7E;
        search.onChange = function(old:String, cur:String) {
            if (cur == '') tapText.visible = true;
            else tapText.visible = false;
            FreeplayState.instance.updateSearch(cur);
            itemDis.text = Std.string(FreeplayState.instance.songs.length) + ' maps has found';
        }
        add(search);
        
        tapText = new FlxText(5, 5, 0, 'Tap here to search', 30);
		tapText.font = Paths.font('montserrat.ttf'); 	
        tapText.antialiasing = ClientPrefs.data.antialiasing;	
        tapText.alpha = 0.6;
        add(tapText);

        itemDis = new FlxText(5, 5 + tapText.height, 0, Std.string(FreeplayState.instance.songs.length) + ' maps has found', 18);
        itemDis.color = 0xFF52F9;
		itemDis.font = Paths.font('montserrat.ttf'); 	
        itemDis.antialiasing = ClientPrefs.data.antialiasing;	
        add(itemDis);
    }

    override function update(e:Float) {
        super.update(e);
        // search.ignoreCheck = FreeplayState.instance.ignoreCheck;
        if (FreeplayState.instance.ignoreCheck) return;
    }
}

class OrderRect extends FlxSpriteGroup {
    var touchFix:Rect;
    var bg:FlxSprite;
    var display:Rect;

    var follow:Bool;

    public function new(X:Float, Y:Float, width:Float, height:Float, point:Bool)
    {
        super(X, Y);

        this.follow = point;

        bg = new FlxSprite();
        bg.pixels = drawRect(50, 20);
        bg.antialiasing = ClientPrefs.data.antialiasing;
        bg.x += width - bg.width - 15;
        bg.y += height / 2 - bg.height / 2;
        add(bg);

        display = new Rect(width - bg.width - 15 - 15, height / 2 - bg.height / 2, 80, 20, 20, 20);
        display.color = 0xFF52F9;
        resetUpdate();
        add(display);

        var text = new FlxText(0, 0, 0, 'Search results sorted alphabetically from a to z', 18);
		text.font = Paths.font('montserrat.ttf'); 	
        text.antialiasing = ClientPrefs.data.antialiasing;	
        add(text);

        text.y += height / 2 - text.height / 2;
    }

    function drawRect(width:Float, height:Float):BitmapData {
        var shape:Shape = new Shape();

        shape.graphics.beginFill(0xFF52F9); 
        shape.graphics.drawRoundRect(0, 0, width, height, height, height);
        shape.graphics.endFill();

        var line:Int = 2;

        shape.graphics.beginFill(0x24232C); 
        shape.graphics.drawRoundRect(line, line, width - line * 2, height - line * 2, height - line * 2, height - line * 2);
        shape.graphics.endFill();

        var bitmap:BitmapData = new BitmapData(Std.int(width), Std.int(height), true, 0);
        bitmap.draw(shape);
        return bitmap;
    }

    public var onFocus:Bool = false;
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        onFocus = FlxG.mouse.overlaps(display);

        if(onFocus && FlxG.mouse.justReleased)
            onClick();
    }

    var tween:FlxTween;
    var state:Bool = false;
    function onClick() {
        if (tween != null) tween.cancel();
        if (!state)
        {
            tween = FlxTween.tween(display, {alpha: 1}, 0.1);
        } else {
            tween = FlxTween.tween(display, {alpha: 0}, 0.1);
        }
        state = !state;
        FreeplayState.instance.useSort = state;
    }

    public function resetUpdate() {
        if (follow == true) 
        {
            display.alpha = 1;
            state = true;
        } else {
            display.alpha = 0;
            state = false;
        }
    }
}