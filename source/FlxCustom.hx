package;

import flixel.ui.*;
import flixel.util.*;
import flixel.addons.ui.*;
import flixel.addons.ui.interfaces.*;

import openfl.Lib;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.math.FlxPoint;
import openfl.display.Shader;
import flixel.system.FlxSound;
import flixel.util.FlxArrayUtil;
import flixel.util.FlxStringUtil;
import flixel.util.FlxDestroyUtil;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxSpriteGroup;
import openfl.display.GraphicsShader;
import flixel.addons.text.FlxTypeText;
import flixel.addons.ui.FlxUI.NamedFloat;
import flixel.system.FlxAssets.FlxShader;

using StringTools;

class FlxCustomFlxTypeText extends FlxTypeText {
    public var isTyping:Bool = false;

    public function new(x:Float = 0, y:Float = 0, fieldWidth:Int = 0){
		super(x, y, fieldWidth, "");

        completeCallback = function(){isTyping = false;};
	}

    public function startText(text:String, delay:Float){
        isTyping = true;
		resetText(text);
		start(delay, true);
    }

    public function startData(data:Dynamic):Void {
        if(data == null){return;}

        var final_text:String = "";
        var total_formats:Array<FlxTextFormatMarkerPair> = [];

        var delay:Float = 0.04;

        for(i in 0...data.length){
            var cur_data:Dynamic = data[i];      

            if(cur_data.time != null){delay = cur_data.time;}
            // if(cur_data.sound != null && Paths.exists(Paths.sound(cur_data.sound))){sounds = [FlxG.sound.load(Paths.sound(cur_data.sound))];}
            if(cur_data.scale != null){size = cur_data.scale;}

            total_formats.push(new FlxTextFormatMarkerPair(new FlxTextFormat(cur_data.color, cur_data.bold, false, null), '<id_${i}>'));
            final_text += '<id_${i}>${cur_data.text}<id_${i}>';
        }
        
		resetText(final_text);
        applyMarkup(final_text, total_formats);
		start(delay, true);
        
        isTyping = true;
    }
}

class FlxUICustomList extends FlxUIGroup implements IFlxUIWidget implements IFlxUIClickable implements IHasParams {
    private var _OnChange:Void->Void = null;
	
	private var _btnBack:FlxUIButton;
    private var _lblCuItem:FlxUIText;
    private var _btnFront:FlxUIButton;

    private var list:Array<String>;
    private var prefix:String = "";
    private var suffix:String = "";

    private var index:Int = 0;

    public var list_length(get, never):Int;
    public function get_list_length():Int{return list.length;}

    public static inline var CLICK_BACK:String = "click_back_list";
    public static inline var CLICK_FRONT:String = "click_front_list";
    public static inline var CHANGE_EVENT:String = "change_list";

    public var params(default, set):Array<Dynamic>;
	private function set_params(p:Array<Dynamic>):Array<Dynamic>{return params = p;}

    public var skipButtonUpdate(default, set):Bool;
    private function set_skipButtonUpdate(b:Bool):Bool{
        skipButtonUpdate = b;
        return b;
    }

    public function new(X:Float = 0, Y:Float = 0, Width:Int = 100, ?DataList:Array<String>, ?OnChange:Void->Void, ?text:FlxUIText, ?DefaultValue:Dynamic){
        this._OnChange = OnChange;
        super(X, Y);

        this.antialiasing = false;

        list = [];
        if(DataList != null){list = DataList;}

        _btnBack = new FlxUIButton(0, 0, "<", function(){c_Index(-1);});
        _btnBack.setSize(Std.int(20), Std.int(_btnBack.height));
        _btnBack.setGraphicSize(Std.int(20), Std.int(_btnBack.height));
        _btnBack.centerOffsets();
        _btnBack.label.fieldWidth = _btnBack.width;

		if(text != null){
			_lblCuItem = text;
			_lblCuItem.setPosition(_btnBack.x + _btnBack.width, _btnBack.y + 3);
		}else{
			_lblCuItem = new FlxUIText(_btnBack.x + _btnBack.width, _btnBack.y + 3, Width - 40, "|None|", 8);
			_lblCuItem.color = FlxColor.WHITE;
			_lblCuItem.alignment = CENTER;
		}

        _btnFront = new FlxUIButton(_lblCuItem.x + _lblCuItem.width, _lblCuItem.y - 3, ">", function(){c_Index(1);});
        _btnFront.setSize(Std.int(20), Std.int(_btnFront.height));
        _btnFront.setGraphicSize(Std.int(20), Std.int(_btnFront.height));
        _btnFront.centerOffsets();
        _btnFront.label.fieldWidth = _btnFront.width;

        add(_btnBack);
        add(_lblCuItem);
        add(_btnFront);

        calcBounds();

        if((DefaultValue is Int)){index = DefaultValue;}
        if((DefaultValue is String)){for(i in 0...list.length){if(list[i] == DefaultValue){index = i;}}}

        updateText();
    }

	public function getText(){return _lblCuItem;}
    public function contains(x:String):Bool{return list.contains(x);}

    private function c_Index(change:Int = 0, force:Bool = false, func:Bool = true):Void {
        index += change;
        if(force){index = change;}
        
        if(index >= list.length){index = 0;}
        if(index < 0){index = list.length - 1;}

        if(index < 0 || index >= list.length){updateText(); return;}

		if(_OnChange != null && func){_OnChange();}

        updateText();

        if(!force){
            if(change > 0){_doCallback(CLICK_BACK);}
            if(change < 0){_doCallback(CLICK_FRONT);}
        }
        _doCallback(CHANGE_EVENT);
    }

    public function updateIndex():Void {c_Index();}
    public function setIndex(i:Int = 0, shadow:Bool = false){c_Index(i, true, !shadow);}
    public function setLabel(s:String, shadow:Bool = false, exists:Bool = false){
        for(i in 0...list.length){if(list[i] == s){c_Index(i, true, !shadow); return;}}
        c_Index(0, true, !shadow);
    }
    
    public function updateText():Void {
        _lblCuItem.text = prefix + "NONE" + suffix;
        if(list[index] != null){_lblCuItem.text = prefix + list[index] + suffix;}
    }

    public function setData(DataList:Array<String>):Void{list = DataList; if(index >= list.length){setIndex(list.length - 1, true);} updateText();}
	public function addToData(data:String):Void{list.push(data);}

    public function setWidth(Width:Float) {
        Width -= Std.int(_btnBack.width + _btnFront.width);
        if(Width < (_btnBack.width + _btnFront.width)){Width = (_btnBack.width + _btnFront.width);}
        
        super.setSize(Width, this.height);

        _lblCuItem.width = Width - 40;
        _lblCuItem.fieldWidth = Width - 40;

        _btnFront.x = _lblCuItem.x + _lblCuItem.width;

        calcBounds();
    }

    public function getSelectedLabel():String{return list[index];}
	public function getSelectedIndex():Int{return index;}

    public function setPrefix(p:String){prefix = p; updateText();}
    public function setSuffix(s:String){suffix = s; updateText();}

    private function _doCallback(event_name:String):Void{
        if(broadcastToFlxUI){
            FlxUI.event(event_name, this, getSelectedIndex(), params);
        }
    }
}

class FlxUIValueChanger extends FlxUIGroup implements IFlxUIWidget implements IFlxUIClickable implements IHasParams {
    private var _OnChange:Float->Void = null;
	
	private var _btnMinus:FlxUIButton;
    private var _lblCuItem:FlxUIInputText;
    private var _btnPlus:FlxUIButton;

    public static inline var CLICK_MINUS:String = "value_changer_minus";
    public static inline var CLICK_PLUS:String = "value_changer_plus";
    public static inline var CHANGE_EVENT:String = "value_changer_change";

    public var params(default, set):Array<Dynamic>;
	private function set_params(p:Array<Dynamic>):Array<Dynamic>{return params = p;}

    public var skipButtonUpdate(default, set):Bool;
    private function set_skipButtonUpdate(b:Bool):Bool{
        skipButtonUpdate = b;
        return b;
    }
    
    public var value(get, never):Float;
	inline function get_value():Float {return Std.parseFloat(_lblCuItem.text);}

    public function new(X:Float = 0, Y:Float = 0, Width:Int = 100, ?OnChange:Float->Void, ?text:FlxUIInputText){
        super(X, Y);
        
        this.antialiasing = false;

        _btnMinus = new FlxUICustomButton(0, 0, 20, null, "-", null, function(){c_Index(-1);});

		if(text != null){
			_lblCuItem = text;
			_lblCuItem.setPosition(_btnMinus.x + _btnMinus.width, _btnMinus.y + 1);
		}else{
			_lblCuItem = new FlxUIInputText(_btnMinus.x + _btnMinus.width, _btnMinus.y + 1, Width - 40, "0", 8);
			_lblCuItem.alignment = CENTER;
		}

        _btnMinus = new FlxUICustomButton(0, 0, 20, Std.int(_lblCuItem.height) + 2, "-", null, function(){c_Index(-1);});
        _btnPlus = new FlxUICustomButton(_lblCuItem.x + _lblCuItem.width, _lblCuItem.y - 1, 20, Std.int(_lblCuItem.height) + 2, "+", null, function(){c_Index(1);});

        add(_lblCuItem);
        add(_btnMinus);
        add(_btnPlus);

        calcBounds();
    }

	public function getText(){return _lblCuItem;}

    var isMinus:Bool = false;
    private function c_Index(change:Float = 0):Void{
		if(_OnChange != null){_OnChange(change);}
        if(change > 0){isMinus = true; _doCallback(CLICK_PLUS);}
        if(change < 0){isMinus = false; _doCallback(CLICK_MINUS);}
        _doCallback(CHANGE_EVENT);
    }
    public function change(minus:Bool = false){if(minus){c_Index(-1);}else{c_Index(1);}}

    public function setWidth(Width:Float) {
        Width -= Std.int(_btnMinus.width + _btnPlus.width);
        if(Width < (_btnMinus.width + _btnPlus.width)){Width = (_btnMinus.width + _btnPlus.width);}
        
        super.setSize(Width, this.height);

        _lblCuItem.width = Width - 40;
        _lblCuItem.fieldWidth = Width - 40;

        _btnPlus.x = _lblCuItem.x + _lblCuItem.width;

        calcBounds();
    }

    private function _doCallback(event_name:String):Void{
        if(broadcastToFlxUI){
            FlxUI.event(event_name, this, isMinus, params);
        }
    }
}

class FlxCustomButton extends FlxButton {
	public function new(X:Float = 0, Y:Float = 0, Width:Null<Int>, Height:Null<Int>, ?Text:String, ?GraphicArgs:Array<Dynamic>, ?Color:Null<FlxColor>, ?OnClick:() -> Void){
		super(X, Y, Text, OnClick);
        
        this.label.antialiasing = false;

		if(Width == null){Width = Std.int(this.width);}
		if(Height == null){Height = Std.int(this.height);}
		
        if(GraphicArgs != null){
            if(GraphicArgs.length <= 2){
                this.frames = GraphicArgs[0];
                for(i in (cast(GraphicArgs[1],Array<Dynamic>))){this.animation.addByPrefix(i[0], i[1], 30, false);}
            }else{Reflect.callMethod(null, this.loadGraphic, GraphicArgs);}
        }
		this.setSize(Width, Height);
		this.setGraphicSize(Width, Height);
		this.centerOffsets();
		this.label.fieldWidth = this.width;
		if(Color != null){this.color = Color;}
	}
}

class FlxUICustomButton extends FlxUIButton {
	public function new(X:Float = 0, Y:Float = 0, Width:Null<Int>, Height:Null<Int>, ?Text:String, ?GraphicPath:String, ?Color:Null<FlxColor>, ?OnClick:() -> Void){
		super(X, Y, Text, OnClick);
        
        this.label.antialiasing = false;

		if(Width == null){Width = Std.int(this.width);}
		if(Height == null){Height = Std.int(this.height);}

        if(GraphicPath != null){
            if(Paths.getAtlas(GraphicPath) != null){
                this.frames = Paths.getAtlas(GraphicPath);

                this.animation.addByPrefix('normal', 'Idle', 24, true);
                this.animation.addByPrefix('highlight', 'Over', 24, true);
                this.animation.addByPrefix('pressed', 'Hit', 24, true);
            }else{
                var _bitMap:FlxGraphic = Paths.getGraphic(GraphicPath);

                if(_bitMap != null){
                    this.loadGraphic(_bitMap, true, Math.floor(_bitMap.width / 3), Math.floor(_bitMap.height));

                    this.animation.add('normal', [0], 0, false);
                    this.animation.add('highlight', [1], 0, false);
                    this.animation.add('pressed', [2], 0, false);
                }
            }
        }

		this.setSize(Width, Height);
		this.setGraphicSize(Width, Height);
		this.updateHitbox(); this.centerOffsets();
		this.label.fieldWidth = this.width;
		if(Color != null){this.color = Color;}
	}

    public function setButtonFrames(GraphicPath:String):Void {
        if(Paths.getAtlas(GraphicPath) != null){
            this.frames = Paths.getAtlas(GraphicPath);

            this.animation.addByPrefix('normal', 'Idle', 24, true);
            this.animation.addByPrefix('highlight', 'Over', 24, true);
            this.animation.addByPrefix('pressed', 'Hit', 24, true);
        }else{
            var _bitMap:FlxGraphic = Paths.getGraphic(GraphicPath);

            if(_bitMap != null){
                this.loadGraphic(_bitMap, true, Math.floor(_bitMap.width / 3), Math.floor(_bitMap.height));

                this.animation.add('normal', [0], 0, false);
                this.animation.add('highlight', [1], 0, false);
                this.animation.add('pressed', [2], 0, false);
            }
        }
		
		this.updateHitbox(); this.centerOffsets();
		this.label.fieldWidth = this.width;
    }
}

class FlxUICustomNumericStepper extends FlxUINumericStepper {
    public function new(X:Float = 0, Y:Float = 0, Width:Int = 25, StepSize:Float = 1, DefaultValue:Float = 0, Min:Float = -999, Max:Float = 999, Decimals:Int = 0, Stack:Int = FlxUINumericStepper.STACK_HORIZONTAL, ?TextField:FlxText, ?ButtonPlus:FlxUITypedButton<FlxSprite>, ?ButtonMinus:FlxUITypedButton<FlxSprite>, IsPercent:Bool = false){
        if(TextField == null){
            TextField = new FlxUIInputText(0, 0, Width);
            TextField = new FlxUIInputText(0, 0, Std.int(Width - (TextField.height * 2) - 5));
        }
        super(X, Y, StepSize, DefaultValue, Min, Max, Decimals, Stack, TextField, ButtonPlus, ButtonMinus, IsPercent);
        
        this.antialiasing = false;
    }
}

#if FLX_DRAW_QUADS
class FlxCustomShader extends FlxShader {
    public static var shaders:Array<FlxCustomShader> = [];

    @:glFragmentHeader('
        #define iResolution openfl_TextureSize
        #define iChannel0 bitmap
        
        uniform float iTime;
        uniform vec4 iMouse;
        uniform float iFrame;
        uniform float iTimeDelta;
    ')
	@:glFragmentSource("
        #pragma header
    ")

    public function new(options:{?fragmentsrc:String, ?vertexsrc:String}){
        if(options.fragmentsrc != null){this.glFragmentSource += '${options.fragmentsrc}';}
        if(options.vertexsrc != null){this.glVertexSource += '${options.vertexsrc}';}
        this.glFragmentSource += '
            void main(){
                gl_FragColor = flixel_texture2D(bitmap, openfl_TextureCoordv);
                vec2 coord = openfl_TextureCoordv;
                vec2 fragCoord = (coord * openfl_TextureSize);
                mainImage(gl_FragColor, fragCoord);
            }
        ';
        super();
        
		iTime.value = [0.0];
		iTimeDelta.value = [0.0];
		iFrame.value = [FlxG.game.focusLostFramerate];
		iMouse.value = [0.0, 0.0, 0.0, 0.0];

        FlxCustomShader.shaders.push(this);
    }

    public function update(elapsed:Float):Void {
        iTime.value[0] += elapsed;
        iTimeDelta.value[0] = elapsed;

        iMouse.value[0] = FlxG.mouse.screenX;
        iMouse.value[1] = FlxG.mouse.screenY;
        iMouse.value[2] = FlxG.mouse.pressed ? FlxG.mouse.screenX : 0.0;
        iMouse.value[2] = FlxG.mouse.pressed ? FlxG.mouse.screenY : 0.0;
    }

    public function set_value(field:String, value:Dynamic):Void {
        if(!Reflect.hasField(this, field)){return;}
        Reflect.getProperty(this, field).value = [value];
    }
}
#end