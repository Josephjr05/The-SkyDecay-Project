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

import options.Option;
import options.OptionsState;

import language.Language;

class BoolRect extends FlxSpriteGroup {
    var touchFix:Rect;
    var bg:FlxSprite;
    var display:Rect;

    var follow:Option;

    public function new(X:Float, Y:Float, width:Float, height:Float, point:Option = null)
    {
        super(X, Y);

        this.follow = point;

        bg = new FlxSprite();
        bg.pixels = drawRect(50, 20);
        bg.antialiasing = ClientPrefs.data.antialiasing;
        bg.x += width - bg.width - 60;
        bg.y += height / 2 - bg.height / 2;
        add(bg);

        display = new Rect(width - bg.width - 60 - 15, height / 2 - bg.height / 2, 80, 20, 20, 20);
        display.color = 0x53b7ff;
        resetUpdate();
        add(display);
    }

    function drawRect(width:Float, height:Float):BitmapData {
        var shape:Shape = new Shape();

        shape.graphics.beginFill(0x53b7ff); 
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

        if (OptionsState.instance.avgSpeed > 2) return;

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

        follow.setValue(state);
        follow.change();
    }

    public function resetUpdate() {
        if (follow.defaultValue == true) 
        {
            display.alpha = 1;
            state = true;
        } else {
            display.alpha = 0;
            state = false;
        }
    }
}

class FloatRect extends FlxSpriteGroup {
    var bg:FlxSprite;
    var display:FlxSprite;

    var rect:Rect;
    var addButton:FlxSprite;
    var deleteButton:FlxSprite;

    var follow:Option;

    var max:Float;
    var min:Float;

    public function new(X:Float, Y:Float, minData:Float, maxData:Float, point:Option = null)
    {
        super(X, Y);

        this.follow = point;
        this.max = maxData;
        this.min = minData;

        bg = new FlxSprite(50);
        bg.pixels = drawRect(850, 10);
        bg.antialiasing = ClientPrefs.data.antialiasing;
        bg.color = 0x24232C;
        add(bg);

        display = new FlxSprite(50);
        display.pixels = drawRect(850, 10);
        display.antialiasing = ClientPrefs.data.antialiasing;
        display.color = 0x0095ff;
        add(display);

        rect = new Rect(0, 0, 80, 20, 20, 20);
        rect.color = 0x53b7ff;
        add(rect);
        rect.y += bg.height / 2 - rect.height / 2;

        addButton = new FlxSprite(920);
        addButton.pixels = drawButton(30, true);
        addButton.antialiasing = ClientPrefs.data.antialiasing;
        addButton.y += bg.height / 2 - addButton.height / 2;
        add(addButton);

        deleteButton = new FlxSprite();
        deleteButton.pixels = drawButton(30, false);
        deleteButton.antialiasing = ClientPrefs.data.antialiasing;
        deleteButton.y += bg.height / 2 - deleteButton.height / 2;
        add(deleteButton);

        resetUpdate();
    }

    function drawRect(width:Float, height:Float):BitmapData {
        var shape:Shape = new Shape();

        shape.graphics.beginFill(0xffffff); 
        shape.graphics.drawRoundRect(0, 0, width, height, height, height);
        shape.graphics.endFill();

        var bitmap:BitmapData = new BitmapData(Std.int(width), Std.int(height), true, 0);
        bitmap.draw(shape);
        return bitmap;
    }

    function drawButton(size:Int, isAdd:Bool) {
        var shape:Shape = new Shape();

        shape.graphics.beginFill(0); 
        shape.graphics.lineStyle(4, 0xFFFFFF, 1);
        shape.graphics.drawCircle(size / 2, size / 2, size - 4);
        shape.graphics.endFill();

        var p1:Point = new Point(size / 2 - size / 5, size / 2);
        var p2:Point = new Point(size / 2 + size / 5, size / 2);
        var p3:Point = new Point(size / 2, size / 2 - size / 5);
        var p4:Point = new Point(size / 2, size / 2 + size / 5);

        shape.graphics.beginFill(0xFFFFFF); 
        shape.graphics.lineStyle(4, 0xFFFFFF, 1);
        shape.graphics.moveTo(p1.x, p1.y);
        shape.graphics.lineTo(p2.x, p2.y);
        shape.graphics.endFill();

        if (isAdd)
        {
            shape.graphics.beginFill(0xFFFFFF); 
            shape.graphics.lineStyle(4, 0xFFFFFF, 1);
            shape.graphics.moveTo(p3.x, p3.y);
            shape.graphics.lineTo(p4.x, p4.y);
            shape.graphics.endFill();
        }

        var bitmap:BitmapData = new BitmapData(Std.int(size), Std.int(size), true, 0);
        bitmap.draw(shape);
        return bitmap;
    }

    public var onFocus:Bool = false;
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (OptionsState.instance.avgSpeed > 2) return;

        if (FlxG.mouse.overlaps(rect) && FlxG.mouse.justPressed)
        {
            posX = FlxG.mouse.x - rect.x;
            onFocus = true;
        }

        if (FlxG.mouse.justReleased) 
        {
            onFocus = false;
            OptionsState.instance.ignoreCheck = false;
        }

        if(onFocus && FlxG.mouse.pressed) onHold();

        if ((FlxG.mouse.overlaps(addButton) || FlxG.mouse.overlaps(deleteButton)) && FlxG.mouse.justPressed)
        {
            var data:Bool = FlxG.mouse.overlaps(addButton);
            changeData(data);
        }
    }

    function changeData(isAdd:Bool) {
        var data:Float = follow.getValue();
        if (isAdd) data += Math.pow(0.1, follow.decimals);
        else data -= Math.pow(0.1, follow.decimals);

        if (data < min) data = min;
        if (data > max) data = max;

        data = FlxMath.roundDecimal(data, follow.decimals);
        persent = (data - min) / (max - min);

        rectUpdate();

        follow.setValue(data);
        follow.valueText.text = follow.getValue() + follow.display;
        follow.change();
    }

    function rectUpdate() {
        display._frame.frame.width = display.width * persent;
        if (display._frame.frame.width < 1) display._frame.frame.width = 1;
        rect.x = this.x + 50 + bg.width * persent - rect.width * persent;
    }

    var posX:Float;
    var persent:Float = 0;
    function onHold() {
        OptionsState.instance.ignoreCheck = true;
        rect.x = FlxG.mouse.x - posX;
        if (rect.x < bg.x) rect.x = bg.x;
        if (rect.x + rect.width > bg.x + bg.width) rect.x = bg.x + bg.width - rect.width;

        persent = (rect.x - bg.x) / (bg.width - rect.width);

        display._frame.frame.width = display.width * persent;
        if (display._frame.frame.width < 1) display._frame.frame.width = 1;
        
        follow.setValue(FlxMath.roundDecimal(min + (max - min) * persent, follow.decimals));
        follow.valueText.text = follow.getValue() + follow.display;
        follow.change();
    }

    public function resetUpdate() 
    {
        persent = (follow.defaultValue - min) / (max - min);
        rectUpdate();
        follow.valueText.text = follow.getValue() + follow.display;
        follow.change();
    }
}

class StringRect extends FlxSpriteGroup {
    var bg:Rect;
    var upRect:FlxSprite;
    var downRect:FlxSprite;
    var disText:FlxText;

    var strArray:Array<String> = [];

    var follow:Option;

    public function new(X:Float, Y:Float, point:Option = null)
    {
        super(X, Y);

        this.follow = point;
        strArray = point.options;

        bg = new Rect(0, 0, 950, 50, 15, 15);
        bg.antialiasing = ClientPrefs.data.antialiasing;
        bg.color = 0x24232C;
        add(bg);

        downRect = new FlxSprite();
        downRect.pixels = drawRect(false, 35);
        downRect.antialiasing = ClientPrefs.data.antialiasing;
        add(downRect);
        downRect.x += bg.width - downRect.width - 20;
        downRect.y += bg.height / 2 - downRect.height / 2;

        upRect = new FlxSprite();
        upRect.pixels = drawRect(true, 35);
        upRect.antialiasing = ClientPrefs.data.antialiasing;
        add(upRect);
        upRect.x +=  bg.width - downRect.width - 20 - upRect.width - 20;
        upRect.y += bg.height / 2 - upRect.height / 2;
        
        disText = new FlxText(20, 0, 0, point.options[point.curOption], 20);
		disText.font = Paths.font(Language.getStr('FontName') + '.ttf');	  
        disText.antialiasing = ClientPrefs.data.antialiasing;  		
        add(disText);
        disText.y += bg.height / 2 - disText.height / 2;
    }

    function drawRect(isUp:Bool, size:Float):BitmapData {
        var shape:Shape = new Shape();

        shape.graphics.beginFill(0x24232C); 
        shape.graphics.lineStyle(3, 0x131217, 1);
        shape.graphics.drawRoundRect(1, 1, size * 3, size, size, size);
        shape.graphics.endFill();

        var p1:Point = new Point(size * 1.2, size * 0.35);
        var p2:Point = new Point(size * 1.5, size * 0.65);
        var p3:Point = new Point(size * 1.8, size * 0.35);

        if (isUp){
            p1.y = size * 0.65;
            p2.y = size * 0.35;
            p3.y = size * 0.65;
        }

        shape.graphics.beginFill(0xFFFFFF); 
        shape.graphics.lineStyle(3, 0xFFFFFF, 1);
        shape.graphics.moveTo(p1.x, p1.y);
        shape.graphics.lineTo(p2.x, p2.y);
        shape.graphics.endFill();

        shape.graphics.beginFill(0xFFFFFF); 
        shape.graphics.lineStyle(3, 0xFFFFFF, 1);
        shape.graphics.moveTo(p2.x, p2.y);
        shape.graphics.lineTo(p3.x, p3.y);
        shape.graphics.endFill();

        var bitmap:BitmapData = new BitmapData(Std.int(size * 3 + 3), Std.int(size + 3), true, 0);
        bitmap.draw(shape);
        return bitmap;
    }

    public var onFocus:Bool = false;
    var isOpened:Bool = false;
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (OptionsState.instance.avgSpeed > 2) return;

        onFocus = FlxG.mouse.overlaps(bg);

        if (FlxG.mouse.overlaps(upRect)) upRect.color = 0x53b7ff;
            else upRect.color = 0xffffff;
            
            if (FlxG.mouse.overlaps(downRect)) downRect.color = 0x53b7ff;
            else downRect.color = 0xffffff;

        if(onFocus && FlxG.mouse.justPressed) onClick();
    }

    function onClick() {
        if (FlxG.mouse.overlaps(upRect))
        {
            follow.curOption++;
            if (follow.curOption >= follow.options.length) follow.curOption = 0;
            follow.setValue(follow.options[follow.curOption]);
            disText.text = follow.options[follow.curOption];
            follow.change();
        }
        
        if (FlxG.mouse.overlaps(downRect))
        {
            follow.curOption--;
            if (follow.curOption < 0) follow.curOption = follow.options.length - 1;
            follow.setValue(follow.options[follow.curOption]);
            disText.text = follow.options[follow.curOption];
            follow.change();
        }
    }
    
    public function resetUpdate() {
        var num:Int = follow.options.indexOf(follow.getValue());
		if(num > -1) follow.curOption = num;
        else follow.curOption = 0;

        disText.text = follow.options[follow.curOption];
        follow.change();
    }
}

class StateRect extends FlxSpriteGroup {

    var rect:Rect;
    var follow:Option;
    public function new(x:Float, y:Float, point:Option)
    {
        super(x,y);

        this.follow = point;

        rect = new Rect(0, 0, 950, 50, 20, 20);
        rect.color = 0x24232C;
        add(rect);

        var text = new FlxText(0, 0, 0, follow.description, 20);
		text.font = Paths.font(Language.getStr('FontName') + '.ttf'); 	
        text.antialiasing = ClientPrefs.data.antialiasing;	
        text.y += rect.height / 2 - text.height / 2;
        text.x += rect.width / 2 - text.width / 2;
        add(text);
    }

    public var onFocus:Bool = false;
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (OptionsState.instance.avgSpeed > 2) return;
        
        onFocus = FlxG.mouse.overlaps(this);

        if(onFocus)
        {
            rect.color = 0x53b7ff;
            if (FlxG.mouse.justReleased) onClick();
        } else {
            rect.color = 0x24232C;
        }
    }

    function onClick() {
        var data:Int = 0;
        switch(follow.variable)
        {
            case 'NoteOffsetState':
                data = 1;
            case 'NotesSubState':
                data = 2;
            case 'ControlsSubState':
                data = 3;
            case 'MobileControlSelectSubState':
                data = 4;
            case 'MobileExtraControl':
                data = 5;
        }
        OptionsState.instance.moveState(data);
    }
}

class ResetRect extends FlxSpriteGroup {

    var rect:Rect;
    var follow:OptionBG;
    public function new(x:Float, y:Float, point:OptionBG)
    {
        super(x,y);

        rect = new Rect(0, 0, 550, 50, 20, 20);
        rect.color = 0x24232C;
        add(rect);

        var text = new FlxText(0, 0, 0, Language.getStr('Reset'), 25);
		text.font = Paths.font(Language.getStr('FontName') + '.ttf'); 	
        text.antialiasing = ClientPrefs.data.antialiasing;	
        text.y += rect.height / 2 - text.height / 2;
        text.x += rect.width / 2 - text.width / 2;
        add(text);

        this.follow = point;
    }

    public var onFocus:Bool = false;
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (OptionsState.instance.avgSpeed > 2) return;
        
        onFocus = FlxG.mouse.overlaps(this);

        if(onFocus)
        {
            rect.color = 0x53b7ff;
            if (FlxG.mouse.justReleased) onClick();
        } else {
            rect.color = 0x24232C;
        }
    }

    function onClick() {
        follow.resetData();
    }
}

class OptionCata extends FlxSpriteGroup
{
    var bg:Rect;
	var text:FlxText;
    var specRect:Rect;

	public function new(x:Float, y:Float, _title:String)
	{
		super(x, y);

        bg = new Rect(0, 0, 250, 80.625);
        bg.alpha = 0;
        add(bg);

		text = new FlxText(40, 0, 0, _title, 18);
		text.font = Paths.font(Language.getStr('FontName') + '.ttf'); 	
        text.antialiasing = ClientPrefs.data.antialiasing;	
        text.y += bg.height / 2 - text.height / 2;
        add(text);

        specRect = new Rect(20, 20, 5, 40, 5, 5, 0x53b7ff);
        specRect.alpha = 0;
        specRect.scale.y = 0;
        specRect.antialiasing = ClientPrefs.data.antialiasing;	
        add(specRect);
	}

    public var onFocus:Bool = false;
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        onFocus = FlxG.mouse.overlaps(this);

        if(onFocus && onClick != null && FlxG.mouse.justReleased)
            onClick();
    }

    var bgTween:FlxTween;
    var specAlphaTw:FlxTween;
    var specScaleTw:FlxTween;
    function onClick() 
    {
        bg.alpha = 0.6;
        if (bgTween != null) bgTween.cancel();
        bgTween = FlxTween.tween(bg, {alpha: 0}, 0.3); 

        if (specAlphaTw != null) specAlphaTw.cancel();
        if (specScaleTw != null) specScaleTw.cancel();

        forceUpdate();
    }

    public var focused:Bool = false;
    public function forceUpdate()
    {
        if (!focused)
        {
            focused = true;
            specAlphaTw = FlxTween.tween(specRect, {alpha: 1}, 0.15); 
            specScaleTw = FlxTween.tween(specRect.scale, {y: 1}, 0.15, {ease: FlxEase.expoInOut}); 
        } else {
            focused = false;
            specAlphaTw = FlxTween.tween(specRect, {alpha: 0}, 0.15); 
            specScaleTw = FlxTween.tween(specRect.scale, {y: 0}, 0.15, {ease: FlxEase.expoInOut}); 
        }
    }
}

class OptionBG extends FlxSpriteGroup
{
    var optionArray:Array<Option> = [];

    public var saveHeight:Int = 0;

	public function new(x:Float, y:Float)
	{
		super(x, y);
	}

    public var onFocus:Bool = false;
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        onFocus = FlxG.mouse.overlaps(this);
    }

    public function addOption(mem:Option)
    {
        add(mem);
        optionArray.push(mem);
        mem.y += saveHeight;
        saveHeight += mem.saveHeight;
    }

    public function resetData() {
        for (i in 0...optionArray.length)
            optionArray[i].resetData();
    }
}