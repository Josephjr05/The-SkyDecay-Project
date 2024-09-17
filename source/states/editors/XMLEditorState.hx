package states.editors;

import flixel.graphics.frames.FlxFramesCollection.FlxFrameCollectionType;
import flixel.graphics.frames.FlxAtlasFrames.TexturePackerObject;
import flixel.system.FlxAssets.FlxTexturePackerSource;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.graphics.tile.FlxGraphicsShader;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUITabMenu;
import openfl.events.IOErrorEvent;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import openfl.net.FileReference;
import flixel.addons.ui.FlxUI;
import flash.geom.Rectangle;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import openfl.events.Event;
import flixel.ui.FlxButton;
import flixel.math.FlxRect;
import lime.ui.FileDialog;
import haxe.DynamicAccess;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxState;
import haxe.xml.Access;
import openfl.Assets;
import flixel.FlxG;
import haxe.Json;

import FlxCustom.FlxUICustomList;
import FlxCustom.FlxCustomButton;
import FlxCustom.FlxUICustomButton;
import FlxCustom.FlxUIValueChanger;
import FlxCustom.FlxUICustomNumericStepper;

import openfl.Lib; // fuck you
import objects.Character;

#if desktop
import sys.FileSystem;
import sys.io.File;
#end

import backend.Paths;
using StringTools;

class XMLEditorState extends MusicBeatState {
    private static var _XML:Access;
    private static var _IMG:FlxGraphic;

    public var camHUD:FlxCamera;
    public var camGame:FlxCamera;
    public var camFGame:FlxCamera;
    public var camOther:FlxCamera;

    public var canControlle:Bool = false; // huh

    private var blockPressWhileTypingOn:Array<FlxUIInputText> = [];
	private var blockPressWhileTypingOnStepper:Array<FlxUINumericStepper> = [];
	private var blockPressWhileScrolling:Array<FlxUIDropDownMenu> = []; // for escape key

    var tabFILE:FlxUITabMenu;
    var tabGHOST:FlxUITabMenu;
    var tabSPRITE:FlxUITabMenu;
    
    var point:FlxSprite;
    var camPoint:FlxSprite;
    var sizePoint:FlxSprite;

    var imgIcon:FlxSprite;
    var bSprite:FlxSprite;
    var eSprite:FlxSprite;
    
    var arrayFocus:Array<FlxUIInputText> = [];

    var camFollow:FlxObject;

    override function create(){
        FlxG.sound.playMusic(Paths.music('break_song'));

        #if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("XML Editor (NEW!)", null, true);
		Lib.application.window.title = 'The SkyDecay Project: In The XML Editor (NEW!)';
		#end


        // dumbass psych camera
        camGame = initPsychCamera();
		camFGame = new FlxCamera(); // cam FUCK Game nigga - Joseph
		camHUD = new FlxCamera();
		camOther = new FlxCamera();

        var bgGrid:FlxSprite = FlxGridOverlay.create(10, 10, FlxG.width, FlxG.height, true, 0xff4d4d4d, 0xff333333);
        bgGrid.cameras = [camGame];
        add(bgGrid);

        //SPRITES
        bSprite = new FlxSprite();
        bSprite.color = FlxColor.GRAY;
        bSprite.cameras = [camFGame];
        bSprite.antialiasing = false;
        bSprite.alpha = 0.3;
        
        eSprite = new FlxSprite();
        eSprite.cameras = [camFGame];
        eSprite.antialiasing = false;

        imgIcon = new FlxSprite(5, 55);
        imgIcon.cameras = [camHUD];

        add(eSprite);
        add(bSprite);

        add(imgIcon);

        point = new FlxSprite(100, 50).makeGraphic(5, 5, FlxColor.WHITE);
        point.cameras = [camFGame];
        add(point);
        
        camPoint = new FlxSprite(0, 0).makeGraphic(5, 5, FlxColor.WHITE);
        camPoint.cameras = [camFGame];
        add(camPoint);

        sizePoint = new FlxSprite(0, 0).makeGraphic(5, 5, FlxColor.WHITE);
        sizePoint.cameras = [camFGame];
        add(sizePoint);

        var UI_box:FlxUITabMenu;

        var tabs = [
            {name: "Files", label: 'Files'},
            {name: "Ghost", label: 'Ghost'},
            {name: "General", label: 'General'},
        ];

        tabFILE = new FlxUITabMenu(null, tabs, true);
        tabFILE.resize(250, 130);
		tabFILE.x = FlxG.width - tabFILE.width;
        tabFILE.camera = camHUD;
        addFILETABS();
        
        tabGHOST = new FlxUITabMenu(null, tabs, true);
        tabGHOST.resize(250, 100);
		tabGHOST.y = tabFILE.height;
		tabGHOST.x = tabFILE.x;
        tabGHOST.camera = camHUD;
        addGHOSTTABS();

        tabSPRITE = new FlxUITabMenu(null, tabs, true);
        tabSPRITE.resize(250, FlxG.height - tabFILE.height - tabGHOST.height);
        tabSPRITE.y = tabGHOST.y + tabGHOST.height;
		tabSPRITE.x = tabFILE.x;
        tabSPRITE.camera = camHUD;
        addFRAMESTABS();

        add(tabFILE);
        add(tabGHOST);
        add(tabSPRITE);
        
		camFollow = new FlxObject(0, 0, 1, 1);
        camFollow.screenCenter();
        camFGame.follow(camFollow, LOCKON);
		add(camFollow); 

        super.create();
        
        FlxG.mouse.visible = true;
    }

    override function destroy() {
        FlxG.sound.music.stop();
        super.destroy();
    }

    var pos = [[], []];
    override function update(elapsed:Float){
        var pMouse = FlxG.mouse.getPositionInCameraView(camFGame);

        bSprite.setPosition(point.x, point.y);
        eSprite.setPosition(point.x, point.y);

        camPoint.setPosition(eSprite.getGraphicMidpoint().x, eSprite.getGraphicMidpoint().y);
        sizePoint.setPosition(eSprite.x + eSprite.width, eSprite.y + eSprite.height);

        var arrayControlle = true;
        for(item in arrayFocus){if(item.hasFocus){arrayControlle = false;}}

        if(canControlle && arrayControlle){    
            if(FlxG.mouse.justPressedRight){pos = [[camFollow.x, camFollow.y],[pMouse.x, pMouse.y]];}
            if(FlxG.mouse.pressedRight){camFollow.setPosition(pos[0][0] + ((pos[1][0] - pMouse.x) * 1.0), pos[0][1] + ((pos[1][1] - pMouse.y) * 1.0));}
            
            if(FlxG.keys.pressed.SHIFT){
                if(FlxG.mouse.wheel != 0){camFGame.zoom += (FlxG.mouse.wheel * 0.1);} 
                
                if(FlxG.keys.justPressed.W || (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.W)){vchCurFrameHeight.change(true);}
                if(FlxG.keys.justPressed.A || (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.A)){vchCurFrameWidth.change(true);}
                if(FlxG.keys.justPressed.S || (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.S)){vchCurFrameHeight.change();}
                if(FlxG.keys.justPressed.D || (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.D)){vchCurFrameWidth.change();}
                
                if(FlxG.keys.justPressed.I || (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.I)){vchCurHeight.change(true);}
                if(FlxG.keys.justPressed.J || (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.J)){vchCurWidth.change(true);}
                if(FlxG.keys.justPressed.K || (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.K)){vchCurHeight.change();}
                if(FlxG.keys.justPressed.L || (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.L)){vchCurWidth.change();}
            }else{
                if(FlxG.mouse.wheel != 0){camFGame.zoom += (FlxG.mouse.wheel * 0.01);}

                if(FlxG.keys.justPressed.W || (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.W)){vchCurFrameY.change(true);}
                if(FlxG.keys.justPressed.A || (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.A)){vchCurFrameX.change(true);}
                if(FlxG.keys.justPressed.S || (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.S)){vchCurFrameY.change();}
                if(FlxG.keys.justPressed.D || (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.D)){vchCurFrameX.change();}
                
                if(FlxG.keys.justPressed.I || (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.I)){vchCurY.change(true);}
                if(FlxG.keys.justPressed.J || (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.J)){vchCurX.change(true);}
                if(FlxG.keys.justPressed.K || (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.K)){vchCurY.change();}
                if(FlxG.keys.justPressed.L || (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.L)){vchCurX.change();}
            }

            if(FlxG.mouse.justPressedMiddle){camFollow.setPosition(eSprite.getGraphicMidpoint().x, eSprite.getGraphicMidpoint().y);}
        }

        var blockInput:Bool = false;
		for (inputText in blockPressWhileTypingOn) {
			if(inputText.hasFocus) {
				ClientPrefs.toggleVolumeKeys(false);
				blockInput = true;

				if(FlxG.keys.justPressed.ENTER) inputText.hasFocus = false;
				break;
			}
		}

        if (!blockInput)
        {
            if (FlxG.keys.justPressed.ESCAPE)
            {
                MusicBeatState.switchState(new MasterEditorMenu());
            }
        }
        
		super.update(elapsed);
    }

    private function getFile(_file:FlxUIInputText):Void {
        var fDialog = new FileDialog();
        fDialog.onSelect.add(function(str){_file.text = str;});
        fDialog.browse();
	}
    
    private function loadArchives():Void {
        if(!txtIMAGE.text.contains(".png") || !txtXML.text.contains(".xml")){return;}
        
        _IMG = FlxGraphic.fromBitmapData(BitmapData.fromFile(txtIMAGE.text));
        _XML = new Access((Xml.parse(txtXML.text)));
        for(elm in _XML.elements){
            if(!elm.has.x){elm.att.x = "0";}
            if(!elm.has.y){elm.att.y = "0";}
            if(!elm.has.width){elm.att.width = "0";}
            if(!elm.has.height){elm.att.height = "0";}
            if(!elm.has.frameX){elm.att.frameX = "0";}
            if(!elm.has.frameY){elm.att.frameY = "0";}
            if(!elm.has.frameWidth){elm.att.frameWidth = "0";}
            if(!elm.has.frameHeight){elm.att.frameHeight = "0";}
        }
    }

    private function loadGhostSprites():Void {
        if(!txtIMAGE.text.contains(".png") || !txtXML.text.contains(".xml")){return;}

        // bSprite.frames = Paths.fromUncachedSparrow(getFile(txtIMAGE.text), txtXML.text.getText());

        var animArr = getNamesArray(new Access((Xml.parse(txtXML.text)).firstElement()).elements);
        for(anim in animArr){bSprite.animation.addByPrefix(anim, anim);}
        clGCurAnim.setData(animArr);

        stpGCurFrame.value = 0;

        return;
    }
    private function loadNormalSprites():Void {
        loadESprite();
        
        imgIcon.loadGraphic(_IMG);
        imgIcon.setGraphicSize(Std.int(15 * FlxG.height / 100), Std.int(15 * FlxG.height / 100));
        imgIcon.updateHitbox();
        
        clCurAnim.setData(getNamesArray(_XML.elements));

        stpCurFrame.value = 0;
        playAnim();
    }
    private function loadESprite():Void {
        var values:Array<Dynamic> = null;
        if(eSprite != null && eSprite.animation.curAnim != null){values = [eSprite.animation.curAnim.name, eSprite.animation.curAnim.curFrame];}
        if(_XML != null && _IMG != null){
            @:privateAccess _IMG.frameCollections.clear();
            eSprite.frames = Paths.fromUncachedSparrow(_IMG, _XML.x.toString());
            
            var animArr = getNamesArray(_XML.elements);
            for(anim in animArr){eSprite.animation.addByPrefix(anim, anim); eSprite.animation.play(anim); eSprite.animation.stop();}

            if(values != null){eSprite.animation.play(values[0], false, false, values[1]); eSprite.animation.stop();}
        }
    }

    public static function getNamesArray(arr:Iterator<Access>):Array<String>{
        var toReturn:Array<String> = [];

        for(chr in arr){
            var arr_name:Array<String> = chr.att.name.split(""); arr_name.resize(chr.att.name.length - 4);
            var char_anim:String = "";
            for(c in arr_name){char_anim = '${char_anim}${c}';}

            if(!toReturn.contains(char_anim)){toReturn.push(char_anim);}
        }

        return toReturn;
    }
    private function getAccess(?AnimName:String, ?Frame:Int, hasNull:Bool = false):Access{
        if(AnimName == null){AnimName = clCurAnim.getSelectedLabel();}
        if(Frame == null){Frame = Std.int(stpCurFrame.value);}

        var nFrames:String = Std.string(Frame);
        while(nFrames.length < 4){nFrames = "0" + nFrames;}

        var Name = AnimName + nFrames;

        var aElements:Access = _XML != null ? _XML : null;
        if(aElements != null && aElements.elements != null){
            for(i in aElements.elements){
                if(i.att.name == Name){
                    if(!i.has.x){i.att.x = "0";}
                    if(!i.has.y){i.att.y = "0";}
                    if(!i.has.width){i.att.width = "0";}
                    if(!i.has.height){i.att.height = "0";}
                    if(!i.has.frameX){i.att.frameX = "0";}
                    if(!i.has.frameY){i.att.frameY = "0";}
                    if(!i.has.frameWidth){i.att.frameWidth = "0";}
                    if(!i.has.frameHeight){i.att.frameHeight = "0";}
                    return i;
                }
            }
        }
        return hasNull ? null : new Access(Xml.parse('<SubTexture name="n0000" x="0" y="0" width="0" height="0" frameX="0" frameY="0" frameWidth="0" frameHeight="0"/>').firstElement());
    }

    private function editAttribute(attribute:String, value:Int, force:Bool = false):Void {
        if(eSprite == null || eSprite.animation.curAnim == null){return;}
        
        if(chkSetToAllSprite.checked){
            for(e in _XML.elements){
                var dnm:DynamicAccess<Dynamic> = cast e; var _elm:Map<String, String> = dnm.get("attributeMap");
                if(force){
                    _elm.set(attribute, Std.string(value));
                }else{
                    _elm.set(attribute, Std.string(Std.parseInt(_elm.get(attribute)) - value));
                }
            }
            loadESprite(); playAnim();
            return;
        }

        if(chkSetToAllFrames.checked){
            for(i in 0...eSprite.animation.curAnim.frames.length){
                var dnm:DynamicAccess<Dynamic> = cast getAccess(null, i); var _elm:Map<String, String> = dnm.get("attributeMap");
                if(force){_elm.set(attribute, Std.string(value));}else{_elm.set(attribute, Std.string(Std.parseInt(_elm.get(attribute)) - value));}
            }
            loadESprite(); playAnim();
            return;
        }
        
        var dnm:DynamicAccess<Dynamic> = cast getAccess(); var _elm:Map<String, String> = dnm.get("attributeMap");
        if(force){_elm.set(attribute, Std.string(value));}else{_elm.set(attribute, Std.string(Std.parseInt(_elm.get(attribute)) - value));}

        loadESprite(); playAnim();
    }

    public function playAnim(?AnimName:String, ?Frame:Int):Void{
        if(eSprite == null || eSprite.animation.curAnim == null){return;}
        
        if(AnimName == null){AnimName = eSprite.animation.curAnim.name;}
        if(Frame == null){Frame = eSprite.animation.curAnim.curFrame;}

        eSprite.animation.play(AnimName, true, false, Frame);
        eSprite.animation.stop();

        eSprite.updateHitbox();

        var sTexture:Access = getAccess(AnimName, Frame);
        lblCurX.text = 'X: [${sTexture.att.x}]';
        lblCurY.text = 'Y: [${sTexture.att.y}]';
        lblCurWidth.text = 'Width: [${sTexture.att.width}]';
        lblCurHeight.text = 'Height: [${sTexture.att.height}]';
        lblCurFrameX.text = 'FrameX: [${sTexture.att.frameX}]';
        lblCurFrameY.text = 'FrameY: [${sTexture.att.frameY}]';
        lblCurFrameWidth.text = 'FrameWidth: [${sTexture.att.frameWidth}]';
        lblCurFrameHeight.text = 'FrameHeight: [${sTexture.att.frameHeight}]';
    }
    public function playGhost(AnimName:String, Frame:Int):Void{
        bSprite.animation.play(AnimName, true, false, Frame);
        bSprite.animation.stop();
    }

    var _file:FileReference;
    private function save(){
		var data:String = _XML.x.toString();

		if((data != null) && (data.length > 0)){
			_file = new FileReference();
			_file.addEventListener(Event.COMPLETE, onSaveComplete);
			_file.addEventListener(Event.CANCEL, onSaveCancel);
			_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file.save(data.trim(), "SDPJnewNAME.xml");
		}
	}

	function onSaveComplete(_):Void{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.notice("Successfully saved XML DATA.");
	}

	/**
	 * Called when the save file dialog is cancelled.
	 */
	function onSaveCancel(_):Void{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
	}

	/**
	 * Called if there is an error while saving the gameplay recording.
	 */
	function onSaveError(_):Void{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.error("Problem saving XML data");
	}

    var txtIMAGE:FlxUIInputText;
    var txtXML:FlxUIInputText;
    function addFILETABS():Void{
        var uiFile = new FlxUI(null, tabFILE);
        uiFile.name = "Files";

        var lblIMAGE = new FlxText(5, 5, 0, "IMAGE (File):", 8); uiFile.add(lblIMAGE);
        txtIMAGE = new FlxUIInputText(lblIMAGE.x + lblIMAGE.width + 5, lblIMAGE.y, Std.int(tabFILE.width - lblIMAGE.width - 50), "", 8); uiFile.add(txtIMAGE);
        txtIMAGE.name = "FILE_IMAGE";
        var btnImage:FlxButton = new FlxCustomButton(txtIMAGE.x + txtIMAGE.width + 5, txtIMAGE.y - 3, 30, null, "GET", null, null, function(){getFile(txtIMAGE);}); uiFile.add(btnImage);

        var lblXML = new FlxText(lblIMAGE.x, lblIMAGE.y + txtIMAGE.height + 10, 0, "XML (File):", 8); uiFile.add(lblXML);
        txtXML = new FlxUIInputText(lblXML.x + lblXML.width + 5, lblXML.y, Std.int(tabFILE.width - lblXML.width - 50), "", 8); uiFile.add(txtXML);
        txtXML.name = "FILE_XML";        
        var btnXML:FlxButton = new FlxCustomButton(txtXML.x + txtXML.width + 5, txtXML.y - 3, 30, null, "GET", null, null, function(){getFile(txtXML);}); uiFile.add(btnXML);

        var btnImport:FlxButton = new FlxCustomButton(lblXML.x, btnXML.y + btnXML.height + 5, Std.int(tabFILE.width / 2) - 7, null, "IMPORT", null, null, function(){loadArchives(); loadNormalSprites();}); uiFile.add(btnImport);
        var btnGhostImport:FlxButton = new FlxCustomButton(btnImport.x + btnImport.width + 5, btnImport.y, Std.int(tabFILE.width / 2) - 7, null, "IMPORT GHOST", null, null, function(){loadGhostSprites();}); uiFile.add(btnGhostImport);

        var btnSave:FlxButton = new FlxCustomButton(5, btnGhostImport.y + btnGhostImport.height + 7, Std.int(tabFILE.width) - 10, null, "Save XML", null, null, function(){save();}); uiFile.add(btnSave);

        tabFILE.addGroup(uiFile);
        tabFILE.scrollFactor.set();
        tabFILE.showTabId("Files");
    }

    var clGCurAnim:FlxUICustomList;
    var stpGCurFrame:FlxUINumericStepper = new FlxUINumericStepper();
    var chkGFlipX:FlxUICheckBox;
    var chkGFlipY:FlxUICheckBox;
    function addGHOSTTABS():Void {
        var uiGhost = new FlxUI(null, tabGHOST);
        uiGhost.name = "Ghost";

        clGCurAnim = new FlxUICustomList(5, 5, Std.int(tabGHOST.width - 10), [], function(){
            stpGCurFrame.value = 0;
            playGhost(clGCurAnim.getSelectedLabel(), Std.int(stpGCurFrame.value));
        }); uiGhost.add(clGCurAnim);

        var lblbGCurFrame = new FlxText(clGCurAnim.x, clGCurAnim.y + clGCurAnim.height + 7, 0, "[Current Frame]: ", 8); uiGhost.add(lblbGCurFrame);
        stpGCurFrame = new FlxUICustomNumericStepper(lblbGCurFrame.x + lblbGCurFrame.width, lblbGCurFrame.y, Std.int(tabGHOST.width - lblbGCurFrame.width) - 10, 1, 0, 0, 999); uiGhost.add(stpGCurFrame);
        stpGCurFrame.name = "GHOST_INDEX";

        chkGFlipX = new FlxUICheckBox(5, lblbGCurFrame.y + lblbGCurFrame.height + 7, null, null, "FlipX Ghost Image"); uiGhost.add(chkGFlipX);
        chkGFlipY = new FlxUICheckBox(chkGFlipX.x + chkGFlipX.width + 5, chkGFlipX.y, null, null, "FlipY Ghost Image"); uiGhost.add(chkGFlipY);

        tabGHOST.addGroup(uiGhost);
        tabGHOST.scrollFactor.set();
        tabGHOST.showTabId("Ghost");
    }

    var clCurAnim:FlxUICustomList;
    var stpCurFrame:FlxUINumericStepper = new FlxUINumericStepper();
    var chkFlipX:FlxUICheckBox;
    var chkFlipY:FlxUICheckBox;

    var chkSetToAllFrames:FlxUICheckBox;
    var chkSetToAllSprite:FlxUICheckBox;

    var lblCurX:FlxText;
    var vchCurX:FlxUIValueChanger;
    var lblCurY:FlxText;
    var vchCurY:FlxUIValueChanger;
    var lblCurWidth:FlxText;
    var vchCurWidth:FlxUIValueChanger;
    var lblCurHeight:FlxText;
    var vchCurHeight:FlxUIValueChanger;
    var lblCurFrameX:FlxText;
    var vchCurFrameX:FlxUIValueChanger;
    var lblCurFrameY:FlxText;
    var vchCurFrameY:FlxUIValueChanger;
    var lblCurFrameWidth:FlxText;
    var vchCurFrameWidth:FlxUIValueChanger;
    var lblCurFrameHeight:FlxText;
    var vchCurFrameHeight:FlxUIValueChanger;
    private function addFRAMESTABS():Void{
        var uiBase = new FlxUI(null, tabSPRITE);
        uiBase.name = "General";

        clCurAnim = new FlxUICustomList(5, 5, Std.int(tabSPRITE.width - 10), [], function(){
            stpCurFrame.value = 0;
            playAnim(clCurAnim.getSelectedLabel(), Std.int(stpCurFrame.value));
        }); uiBase.add(clCurAnim);
        clCurAnim.name = "BASE_CHANGE";

        var lblbCurFrame = new FlxText(clCurAnim.x, clCurAnim.y + clCurAnim.height + 7, 0, "[Current Frame]: ", 8); uiBase.add(lblbCurFrame);
        stpCurFrame = new FlxUICustomNumericStepper(lblbCurFrame.x + lblbCurFrame.width, lblbCurFrame.y, Std.int(tabSPRITE.width - lblbCurFrame.width) - 10, 1, 0, 0, 999); uiBase.add(stpCurFrame);
        stpCurFrame.name = "FRAME_INDEX";

        chkFlipX = new FlxUICheckBox(5, lblbCurFrame.y + lblbCurFrame.height + 5, null, null, "FlipX Image"); uiBase.add(chkFlipX);
        chkFlipY = new FlxUICheckBox(chkFlipX.x + chkFlipX.width + 5, chkFlipX.y, null, null, "FlipY Image"); uiBase.add(chkFlipY);

        chkSetToAllFrames = new FlxUICheckBox(chkFlipX.x, chkFlipX.y + chkFlipX.height + 10, null, null, "Change on All Frames", Std.int(tabSPRITE.width) - 10); uiBase.add(chkSetToAllFrames);
        chkSetToAllSprite = new FlxUICheckBox(chkSetToAllFrames.x, chkSetToAllFrames.y + chkSetToAllFrames.height + 10, null, null, "Change on All Sprite", Std.int(tabSPRITE.width) - 10); uiBase.add(chkSetToAllSprite);

        lblCurX = new FlxText(chkSetToAllSprite.x, chkSetToAllSprite.y + chkSetToAllSprite.height + 7, 0, "X: [0]"); uiBase.add(lblCurX);
        vchCurX = new FlxUIValueChanger(tabSPRITE.width - 105, lblCurX.y - 1, 100, function(value:Float){}); uiBase.add(vchCurX); vchCurX.name = "SPRITE_X";
        lblCurY = new FlxText(lblCurX.x, lblCurX.y + lblCurX.height + 3, 0, "Y: [0]"); uiBase.add(lblCurY);
        vchCurY = new FlxUIValueChanger(tabSPRITE.width - 105, lblCurY.y - 1, 100, function(value:Float){}); uiBase.add(vchCurY); vchCurY.name = "SPRITE_Y";
        
        lblCurWidth = new FlxText(lblCurY.x, lblCurY.y + lblCurY.height + 7, 0, "Width: [0]"); uiBase.add(lblCurWidth);
        vchCurWidth = new FlxUIValueChanger(tabSPRITE.width - 105, lblCurWidth.y - 1, 100, function(value:Float){}); uiBase.add(vchCurWidth); vchCurWidth.name = "SPRITE_WIDTH";
        lblCurHeight = new FlxText(lblCurWidth.x, lblCurWidth.y + lblCurWidth.height + 3, 0, "Height: [0]"); uiBase.add(lblCurHeight);
        vchCurHeight = new FlxUIValueChanger(tabSPRITE.width - 105, lblCurHeight.y - 1, 100, function(value:Float){}); uiBase.add(vchCurHeight); vchCurHeight.name = "SPRITE_HEIGHT";
        
        lblCurFrameX = new FlxText(lblCurHeight.x, lblCurHeight.y + lblCurHeight.height + 7, 0, "FrameX: [0]"); uiBase.add(lblCurFrameX);
        vchCurFrameX = new FlxUIValueChanger(tabSPRITE.width - 105, lblCurFrameX.y - 1, 100, function(value:Float){}); uiBase.add(vchCurFrameX); vchCurFrameX.name = "SPRITE_FRAMEX";
        lblCurFrameY = new FlxText(lblCurFrameX.x, lblCurFrameX.y + lblCurFrameX.height + 3, 0, "FrameY: [0]"); uiBase.add(lblCurFrameY);
        vchCurFrameY = new FlxUIValueChanger(tabSPRITE.width - 105, lblCurFrameY.y - 1, 100, function(value:Float){}); uiBase.add(vchCurFrameY); vchCurFrameY.name = "SPRITE_FRAMEY";
        
        lblCurFrameWidth = new FlxText(lblCurFrameY.x, lblCurFrameY.y + lblCurFrameY.height + 7, 0, "FrameWidth: [0]"); uiBase.add(lblCurFrameWidth);
        vchCurFrameWidth = new FlxUIValueChanger(tabSPRITE.width - 105, lblCurFrameWidth.y - 1, 100, function(value:Float){}); uiBase.add(vchCurFrameWidth); vchCurFrameWidth.name = "SPRITE_FRAMEWIDTH";
        lblCurFrameHeight = new FlxText(lblCurFrameWidth.x, lblCurFrameWidth.y + lblCurFrameWidth.height + 3, 0, "FrameHeight: [0]"); uiBase.add(lblCurFrameHeight);
        vchCurFrameHeight = new FlxUIValueChanger(tabSPRITE.width - 105, lblCurFrameHeight.y - 1, 100, function(value:Float){}); uiBase.add(vchCurFrameHeight); vchCurFrameHeight.name = "SPRITE_FRAMEHEIGHT";

        var btnSetFrameSize0 = new FlxUICustomButton(5, lblCurFrameHeight.y + lblCurFrameHeight.height + 5, Std.int(tabSPRITE.width) - 10, null, "\nSet FrameSize to 0", null, null, function(){
            editAttribute("frameWidth", 0, true);
            editAttribute("frameHeight", 0, true);
        }); uiBase.add(btnSetFrameSize0);

        var btnSetFrameSize = new FlxUICustomButton(5, btnSetFrameSize0.y + btnSetFrameSize0.height + 5, Std.int(tabSPRITE.width) - 10, null, "Set FrameSize", null, null, function(){
            editAttribute("frameWidth", Std.parseInt(getAccess().att.width), true);
            editAttribute("frameHeight", Std.parseInt(getAccess().att.height), true);
        }); uiBase.add(btnSetFrameSize);


        tabSPRITE.addGroup(uiBase);
        tabSPRITE.scrollFactor.set();
        tabSPRITE.showTabId("General");
    }

    override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>){
        if((sender is FlxUICheckBox)){
            var check:FlxUICheckBox = cast sender;
            var label = check.getLabel().text;

            switch(id){
                case FlxUICheckBox.CLICK_EVENT:{
                    switch(label){
                        default:{trace("[FlxUICheckBox]: Works!");}
                        case "FlipX Ghost Image":{bSprite.flipX = check.checked;}
                        case "FlipY Ghost Image":{bSprite.flipY = check.checked;}
                        case "FlipX Image":{eSprite.flipX = check.checked;}
                        case "FlipY Image":{eSprite.flipY = check.checked;}
                    }
                }
            }
        }else if((sender is FlxUIInputText)){
            var input:FlxUIInputText = cast sender;
            var wname = input.name;

            switch(id){
                case FlxUIInputText.CHANGE_EVENT:{
                    switch(wname){
                        default:{trace("[FlxUIInputText]: Works!");}
                    }
                }
            }
        }else if((sender is FlxUIDropDownMenu)){
            var drop:FlxUIDropDownMenu = cast sender;
            var wname = drop.name;

            switch(id){
                case FlxUIDropDownMenu.CLICK_EVENT:{
                    switch(wname){
                        default:{trace("[FlxUIDropDownMenu]: Works!");}
                    }
                }
            }
        }else if((sender is FlxUINumericStepper)){
            var nums:FlxUINumericStepper = cast sender;
            var wname = nums.name;

            switch(id){
                case FlxUINumericStepper.CHANGE_EVENT:{
                    switch(wname){
                        default:{trace("[FlxUINumericStepper]: Works!");}
                        case "FRAME_INDEX":{
                            if(eSprite == null || eSprite.animation.curAnim == null){return;}

                            if(Std.int(nums.value) < 0){nums.value = eSprite.animation.curAnim.frames.length - 1;}
                            if(Std.int(nums.value) >= eSprite.animation.curAnim.frames.length){nums.value = 0;}

                            playAnim(clCurAnim.getSelectedLabel(), Std.int(nums.value));
                        }
                        case "GHOST_INDEX":{
                            if(bSprite == null || bSprite.animation.curAnim == null){return;}

                            if(Std.int(nums.value) < 0){nums.value = bSprite.animation.curAnim.frames.length - 1;}
                            if(Std.int(nums.value) >= bSprite.animation.curAnim.frames.length){nums.value = 0;}

                            playGhost(clGCurAnim.getSelectedLabel(), Std.int(nums.value));
                        }
                    }
                }
            }        
        }else if((sender is FlxUIValueChanger)){
            var nums:FlxUIValueChanger = cast sender;
            var wname = nums.name;

            var chValue:Int = Std.int(nums.value);
            if(data){chValue = -Std.int(nums.value);}
                
            switch(id){
                case FlxUIValueChanger.CHANGE_EVENT:{
                    switch(wname){
                        case "SPRITE_X":{editAttribute("x", chValue);}
                        case "SPRITE_Y":{editAttribute("y", chValue);}
                        case "SPRITE_WIDTH":{editAttribute("width", chValue);}
                        case "SPRITE_HEIGHT":{editAttribute("height", chValue);}
                        case "SPRITE_FRAMEX":{editAttribute("frameX", chValue);}
                        case "SPRITE_FRAMEY":{editAttribute("frameY", chValue);}
                        case "SPRITE_FRAMEWIDTH":{editAttribute("frameWidth", chValue);}
                        case "SPRITE_FRAMEHEIGHT":{editAttribute("frameHeight", chValue);}
                    }
                }
            }
        }else if((sender is FlxUICustomList)){
            var nums:FlxUICustomList = cast sender;
            var wname = nums.name;
            
            switch(id){
                case FlxUICustomList.CHANGE_EVENT:{
                    switch(wname){
                        default:{}
                    }
                }
            }
        }
    }
}