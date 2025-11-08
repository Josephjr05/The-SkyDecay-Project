package states.editors;

import flixel.FlxSubState;
import flixel.util.FlxSave;
import flixel.util.FlxSort;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxStringUtil;
import flixel.util.FlxDestroyUtil;
import flixel.input.keyboard.FlxKey;

import openfl.events.KeyboardEvent;

import lime.utils.Assets;
import lime.media.AudioBuffer;

import flash.media.Sound;
import flash.geom.Rectangle;

import haxe.Json;
import haxe.Exception;
import haxe.io.Bytes;

import states.editors.content.MetaNote;
import states.editors.content.VSlice;
import states.editors.content.Prompt;
import states.editors.content.*;

import backend.Song;
import backend.StageData;
import backend.Highscore;
import backend.Difficulty;

import objects.Character;
import objects.HealthIcon;
import objects.Note;
import objects.StrumNote;

import tjson.TJSON;
import sys.io.File;
import openfl.net.FileReference; // for Base Game

// Because import.hx isn't importing these for some reason
import moonchart.formats.OsuMania;
import moonchart.formats.StepMania;
import moonchart.formats.fnf.legacy.FNFLegacy;
import moonchart.formats.fnf.FNFVSlice;
import moonchart.formats.BasicFormat;

using DateTools;

typedef UndoStruct = {
	var action:UndoAction;
	var data:Dynamic;
}

enum abstract UndoAction(String)
{
	var ADD_NOTE = 'Add Note';
	var DELETE_NOTE = 'Delete Note';
	var MOVE_NOTE = 'Move Note';
	var SELECT_NOTE = 'Select Note';
}

enum abstract ChartingTheme(String)
{
	var SKYDECAY = 'skydecay';
	var LIGHT = 'light';
	var DARK = 'dark';
	var DEFAULT = 'default';
	var VSLICE = 'vslice';
	var CUSTOM = 'custom';
}

enum abstract WaveformTarget(String)
{
	var INST = 'inst';
	var PLAYER = 'voc';
	var OPPONENT = 'opp';
	var EVERYTHING = 'all';
}

class ChartingState extends MusicBeatState implements PsychUIEventHandler.PsychUIEvent
{
	public static final defaultEvents:Array<Array<String>> =
	[
		['', "Nothing. Yep, that's right."], //Always leave this one empty pls
		['Dadbattle Spotlight', "Used in Dad Battle,\nValue 1: 0/1 = ON/OFF,\n2 = Target Dad\n3 = Target BF"],
		['Hey!', "Plays the \"Hey!\" animation from Bopeebo,\nValue 1: BF = Only Boyfriend, GF = Only Girlfriend,\nSomething else = Both.\nValue 2: Custom animation duration,\nleave it blank for 0.6s"],
		['Set GF Speed', "Sets GF head bopping speed,\nValue 1: 1 = Normal speed,\n2 = 1/2 speed, 4 = 1/4 speed etc.\nUsed on Fresh during the beatbox parts.\n\nWarning: Value must be integer!"],
		['Philly Glow', "Exclusive to Week 3\nValue 1: 0/1/2 = OFF/ON/Reset Gradient\n \nNo, i won't add it to other weeks."],
		['Kill Henchmen', "For Mom's songs, don't use this please, i love them :("],
		['Add Camera Zoom', "Used on MILF on that one \"hard\" part\nValue 1: Camera zoom add (Default: 0.015)\nValue 2: UI zoom add (Default: 0.03)\nLeave the values blank if you want to use Default."],
		['BG Freaks Expression', "Should be used only in \"school\" Stage!"],
		['Trigger BG Ghouls', "Should be used only in \"schoolEvil\" Stage!"],
		['Play Animation', "Plays an animation on a Character,\nonce the animation is completed,\nthe animation changes to Idle\n\nValue 1: Animation to play.\nValue 2: Character (Dad, BF, GF)"],
		['Camera Follow Pos', "Value 1: X\nValue 2: Y\n\nThe camera won't change the follow point\nafter using this, for getting it back\nto normal, leave both values blank."],
		['Alt Idle Animation', "Sets a specified postfix after the idle animation name.\nYou can use this to trigger 'idle-alt' if you set\nValue 2 to -alt\n\nValue 1: Character to set (Dad, BF or GF)\nValue 2: New postfix (Leave it blank to disable)"],
		['Screen Shake', "Value 1: Camera shake\nValue 2: HUD shake\n\nEvery value works as the following example: \"1, 0.05\".\nThe first number (1) is the duration.\nThe second number (0.05) is the intensity."],
		['Change Character', "Value 1: Character to change (Dad, BF, GF)\nValue 2: New character's name"],
		['Change Scroll Speed', "Value 1: Scroll Speed Multiplier (1 is default)\nValue 2: Time it takes to change fully in seconds."],
		['Set Property', "Value 1: Variable name\nValue 2: New value"],
		['Play Sound', "Value 1: Sound file name\nValue 2: Volume (Default: 1), ranges from 0 to 1"]
	];
	
	public static var keysArray:Array<FlxKey> = [ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT]; //Used for Vortex Editor
	public static var SHOW_EVENT_COLUMN = true;
	public static var GRID_COLUMNS_PER_PLAYER = 4;
	public static var GRID_PLAYERS = 2;
	public static var GRID_SIZE = 40;
	final BACKUP_EXT = '.bkp';

	public var quantizations:Array<Int> = [
		4,
		8,
		12,
		16,
		20,
		24,
		32,
		48,
		64,
		96,
		192
	];
	public var quantColors:Array<FlxColor> = [
		0xFFDF0000,
		0xFF4040CF,
		0xFFAF00AF,
		0xFFFFAF00,
		0xFFFFFFFF,
		0xFFFFA0FF,
		0xFFFF6030,
		0xFF00CFCF,
		0xFF00CF00,
		0xFF9F9F9F,
		0xFF3F3F3F,
	];
	var curQuant(default, set):Int = 16;
	function set_curQuant(v:Int)
	{
		curQuant = v;
		updateVortexColor();
		return curQuant;
	}
	function updateVortexColor()
		vortexIndicator.color = quantColors[Std.int(FlxMath.bound(quantizations.indexOf(curQuant), 0, quantColors.length - 1))];

	var sectionFirstNoteID:Int = 0;
	var sectionFirstEventID:Int = 0;
	var curSec:Int = 0;

	var chartEditorSave:FlxSave;
	var mainBox:PsychUIBox;
	var mainBoxPosition:FlxPoint = FlxPoint.get(920, 40);
	var infoBox:PsychUIBox;
	var infoBoxPosition:FlxPoint = FlxPoint.get(1000, 360);
	var upperBox:PsychUIBox;
	
	var camUI:FlxCamera;

	var prevGridBg:ChartingGridSprite;
	var gridBg:ChartingGridSprite;
	var nextGridBg:ChartingGridSprite;
	var waveformSprite:FlxSprite;
	var scrollY:Float = 0;
	
	var zoomList:Array<Float> = [
		0.25,
		0.5,
		1,
		2,
		3,
		4,
		6,
		8,
		12,
		16,
		24
	];
	var curZoom:Float = 1;

	var mustHitIndicator:FlxSprite;
	var eventIcon:FlxSprite;
	var icons:Array<HealthIcon> = [];

	var events:Array<EventMetaNote> = [];
	var notes:Array<MetaNote> = [];

	var behindRenderedNotes:FlxTypedGroup<MetaNote> = new FlxTypedGroup<MetaNote>();
	var curRenderedNotes:FlxTypedGroup<MetaNote> = new FlxTypedGroup<MetaNote>();
	var movingNotes:FlxTypedGroup<MetaNote> = new FlxTypedGroup<MetaNote>();
	var eventLockOverlay:FlxSprite;
	var vortexIndicator:FlxSprite;
	var strumLineNotes:FlxTypedGroup<StrumNote> = new FlxTypedGroup<StrumNote>();
	var dummyArrow:FlxSprite;
	var isMovingNotes:Bool = false;
	var movingNotesLastData:Int = 0;
	var movingNotesLastY:Float = 0;
	
	var vocals:FlxSound = new FlxSound();
	var opponentVocals:FlxSound = new FlxSound();

	var timeLine:FlxSprite;
	var infoText:FlxText;

	var autoSaveIcon:FlxSprite;
	var outputTxt:FlxText;

	var selectionStart:FlxPoint = FlxPoint.get();
	var selectionBox:FlxSprite;

	var _shouldReset:Bool = true;
	public function new(?shouldReset:Bool = true)
	{
		this._shouldReset = shouldReset;
		super();
	}

	var bg:FlxSprite;
	var theme:ChartingTheme = DEFAULT;

	var copiedNotes:Array<Dynamic> = [];
	var copiedEvents:Array<Dynamic> = [];
	
	var _keysPressedBuffer:Array<Bool> = [];
	var _heldNotes:Array<MetaNote> = [];

	var tipBg:FlxSprite;
	var fullTipText:FlxText;

	var vortexMoved:Bool = true;
	var allowInput:Bool = false;
	var vortexInput:Bool = false;
	var vortexEnabled:Bool = false;
	var waveformEnabled:Bool = false;
	var waveformTarget:WaveformTarget = INST;
	
	var singAnimations:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];

	// SDY
	var sd:FlxSprite;

	//Credits Info
	var	songArtists:String;
	var artists:String;
	var charters:String;
	var vfx:String;
	var scripters:String;

	// FPS Plus
	var lilStage:FlxSprite;
	var lilBf:FlxSprite;
	var lilOpp:FlxSprite;
	var lilBuddiesOn:Bool = false;

	// Actual characters
	var lilPlayer:Character;
	var lilOpponent:Character;
	//var playerGhost:Character;
	//var opponentGhost:Character;
	var lilGf:Character;
	var gfSpeed:Int = 1;
	var currentPlayer1Chosen = null;

	// Important
	var odStepper:PsychUINumericStepper;
	var hpStepper:PsychUINumericStepper;
	var downScroll:Bool = false;

	var luaType:Bool = false;

	override function create() {
		if(Difficulty.list.length < 1) Difficulty.resetList();
		_keysPressedBuffer.resize(keysArray.length);
		_heldNotes.resize(keysArray.length);

		if(_shouldReset) Conductor.songPosition = 0;
		persistentUpdate = false;
		FlxG.mouse.visible = true;
		FlxG.sound.list.add(vocals);
		FlxG.sound.list.add(opponentVocals);

		vocals.autoDestroy = false;
		vocals.looped = true;
		opponentVocals.autoDestroy = false;
		opponentVocals.looped = true;

		initPsychCamera();
		camUI = new FlxCamera();
		camUI.bgColor.alpha = 0;
		FlxG.cameras.add(camUI, false);

		chartEditorSave = new FlxSave();
		chartEditorSave.bind('chart_editor_data', CoolUtil.getSavePath());

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.scrollFactor.set();
		add(bg);

		sd = new FlxSprite().loadGraphic(Paths.image('chartSD'));
		sd.antialiasing = ClientPrefs.data.antialiasing;
		sd.scrollFactor.set();
		add(sd);
		
		//lil buddies from fps plus
		lilStage = new FlxSprite(32, 332).loadGraphic(Paths.image("editors/lilStage"));
		lilStage.scrollFactor.set();
		lilStage.antialiasing = true;
		add(lilStage);

		lilBf = new FlxSprite(32, 332).loadGraphic(Paths.image("editors/lilBf"), true, 300, 256);
		lilBf.animation.add("idle", [0, 1], 12, true);
		lilBf.animation.add("0", [3, 4, 5], 12, false);
		lilBf.animation.add("1", [6, 7, 8], 12, false);
		lilBf.animation.add("2", [9, 10, 11], 12, false);
		lilBf.animation.add("3", [12, 13, 14], 12, false);
		lilBf.animation.add("yeah", [17, 20, 23], 12, false);
		lilBf.animation.play("idle");
		lilBf.animation.finishCallback = function(name:String){
			lilBf.animation.play(name, true, false, lilBf.animation.getByName(name).numFrames - 2);
		}
		lilBf.scrollFactor.set();
		lilBf.antialiasing = true;
		add(lilBf);

		lilOpp = new FlxSprite(32, 332).loadGraphic(Paths.image("editors/lilOpp"), true, 300, 256);
		lilOpp.animation.add("idle", [0, 1], 12, true);
		lilOpp.animation.add("0", [3, 4, 5], 12, false);
		lilOpp.animation.add("1", [6, 7, 8], 12, false);
		lilOpp.animation.add("2", [9, 10, 11], 12, false);
		lilOpp.animation.add("3", [12, 13, 14], 12, false);
		lilOpp.animation.play("idle");
		lilOpp.animation.finishCallback = function(name:String){
			lilOpp.animation.play(name, true, false, lilOpp.animation.getByName(name).numFrames - 2);
		}
		lilOpp.scrollFactor.set();
		lilOpp.antialiasing = true;
		add(lilOpp);

		//remember to add the new function
		// also used to layer them
		createLilGirlfriend(); // gf is behind BF
		createLilPlayer();
		createLilOpponent();
		//createPlayerGhost();
		//createOpponentGhost();

		if(chartEditorSave.data.autoSave != null) autoSaveCap = chartEditorSave.data.autoSave;
		if(chartEditorSave.data.backupLimit != null) backupLimit = chartEditorSave.data.backupLimit;
		if(chartEditorSave.data.downScroll != null) downScroll = chartEditorSave.data.downScroll;
		if(chartEditorSave.data.vortex != null) vortexEnabled = chartEditorSave.data.vortex;

		if(chartEditorSave.data.customBgColor == null) chartEditorSave.data.customBgColor = '303030';
		if(chartEditorSave.data.customGridColors == null || chartEditorSave.data.customGridColors.length < 2)
			chartEditorSave.data.customGridColors = ['DFDFDF', 'BFBFBF'];
		if(chartEditorSave.data.customNextGridColors == null || chartEditorSave.data.customNextGridColors.length < 2)
			chartEditorSave.data.customNextGridColors = ['5F5F5F', '4A4A4A'];
		
		changeTheme(chartEditorSave.data.theme != null ? chartEditorSave.data.theme : DEFAULT, false);
		refreshSustains(chartEditorSave.data.texturedSustains ?? true);
		
		// preCreate();
		createGrids();

		waveformSprite = new FlxSprite(gridBg.x + (SHOW_EVENT_COLUMN ? GRID_SIZE : 0), 0).makeGraphic(1, 1, 0x00FFFFFF);
		waveformSprite.scrollFactor.x = 0;
		waveformSprite.visible = false;
		add(waveformSprite);

		dummyArrow = new FlxSprite().makeGraphic(1, 1, FlxColor.WHITE);
		dummyArrow.setGraphicSize(GRID_SIZE, GRID_SIZE);
		dummyArrow.updateHitbox();
		dummyArrow.scrollFactor.x = 0;
		add(dummyArrow);

		vortexIndicator = new FlxSprite(gridBg.x - GRID_SIZE, (FlxG.height - GRID_SIZE)/2).loadGraphic(Paths.image('editors/vortex_indicator'));
		vortexIndicator.antialiasing = ClientPrefs.data.antialiasing;
		vortexIndicator.setGraphicSize(GRID_SIZE);
		vortexIndicator.updateHitbox();
		vortexIndicator.scrollFactor.set();
		vortexIndicator.active = false;
		updateVortexColor();
		add(vortexIndicator);
		add(strumLineNotes);

		add(behindRenderedNotes);
		add(curRenderedNotes);
		add(movingNotes);

		eventLockOverlay = new FlxSprite(gridBg.x, 0).makeGraphic(1, 1, FlxColor.BLACK);
		eventLockOverlay.alpha = 0.6;
		eventLockOverlay.visible = false;
		eventLockOverlay.scrollFactor.x = 0;
		eventLockOverlay.scale.x = GRID_SIZE;
		eventLockOverlay.updateHitbox();
		add(eventLockOverlay);

		timeLine = new FlxSprite(gridBg.x, 0).makeGraphic(1, 1, FlxColor.WHITE);
		timeLine.setGraphicSize(Std.int(gridBg.width), 4);
		timeLine.updateHitbox();
		timeLine.scrollFactor.set();
		add(timeLine);
		
		var startX:Float = gridBg.x;
		var startY:Float = (FlxG.height - GRID_SIZE)/2;
		vortexIndicator.visible = strumLineNotes.visible = strumLineNotes.active = vortexEnabled;
		if(SHOW_EVENT_COLUMN) startX += GRID_SIZE;

		for (i in 0...Std.int(GRID_PLAYERS * GRID_COLUMNS_PER_PLAYER))
		{
			var note:StrumNote = new StrumNote(startX + (GRID_SIZE * i), startY, i % GRID_COLUMNS_PER_PLAYER, 0);
			note.scrollFactor.set();
			note.playAnim('static');
			note.alpha = 0.4;
			note.updateHitbox();
			if(note.width > note.height)
				note.setGraphicSize(GRID_SIZE);
			else
				note.setGraphicSize(0, GRID_SIZE);
	
			note.updateHitbox();
			note.x += GRID_SIZE/2 - note.width/2;
			note.y += GRID_SIZE/2 - note.height/2;
			strumLineNotes.add(note);
		}

		var columns:Int = 0;
		var iconX:Float = gridBg.x;
		var iconY:Float = 50;
		if(SHOW_EVENT_COLUMN)
		{
			eventIcon = new FlxSprite(0, iconY).loadGraphic(Paths.image('editors/events/icons/default'));
			eventIcon.antialiasing = ClientPrefs.data.antialiasing;
			eventIcon.alpha = 0.6;
			eventIcon.setGraphicSize(30, 30);
			eventIcon.updateHitbox();
			eventIcon.scrollFactor.set();
			add(eventIcon);
			eventIcon.x = iconX + (GRID_SIZE * 0.5) - eventIcon.width/2;
			iconX += GRID_SIZE;

			columns++;
		}

		mustHitIndicator = FlxSpriteUtil.drawTriangle(new FlxSprite(0, iconY - 20).makeGraphic(16, 16, FlxColor.TRANSPARENT), 0, 0, 16);
		mustHitIndicator.scrollFactor.set();
		mustHitIndicator.flipY = true;
		mustHitIndicator.offset.x += mustHitIndicator.width/2;
		add(mustHitIndicator);

		var gridStripes:Array<Int> = [];
		for (i in 0...GRID_PLAYERS)
		{
			if(columns > 0) gridStripes.push(columns);
			columns += GRID_COLUMNS_PER_PLAYER;

			var icon:HealthIcon = new HealthIcon();
			icon.autoAdjustOffset = false;
			icon.y = iconY;
			icon.alpha = 0.6;
			icon.scrollFactor.set();
			icon.scale.set(0.3, 0.3);
			icon.updateHitbox();
			icon.ID = i+1;
			add(icon);
			icons.push(icon);
			
			icon.x = iconX + GRID_SIZE * (GRID_COLUMNS_PER_PLAYER/2) - icon.width/2;
			iconX += GRID_SIZE * GRID_COLUMNS_PER_PLAYER;
		}
		prevGridBg.stripes = nextGridBg.stripes = gridBg.stripes = gridStripes;
		
		selectionBox = new FlxSprite().makeGraphic(1, 1, FlxColor.CYAN);
		selectionBox.alpha = 0.4;
		selectionBox.blend = ADD;
		selectionBox.scrollFactor.set();
		selectionBox.visible = false;
		add(selectionBox);

		infoBox = new PsychUIBox(infoBoxPosition.x, infoBoxPosition.y, 220, 220, ['Information']);
		infoBox.scrollFactor.set();
		infoBox.cameras = [camUI];
		infoText = new FlxText(15, 15, 230, '', 16);
		infoText.scrollFactor.set();
		infoBox.getTab('Information').menu.add(infoText);
		add(infoBox);

		mainBox = new PsychUIBox(mainBoxPosition.x, mainBoxPosition.y, 300, 280, ['Misc', 'Data', 'Events', 'Note', 'Section', 'Song', 'Credits']);
		mainBox.selectedName = 'Song';
		mainBox.scrollFactor.set();
		mainBox.cameras = [camUI];
		add(mainBox);

		autoSaveIcon = new FlxSprite(50).loadGraphic(Paths.image('editors/autosave'));
		autoSaveIcon.screenCenter(Y);
		autoSaveIcon.scale.set(0.6, 0.6);
		autoSaveIcon.antialiasing = ClientPrefs.data.antialiasing;
		autoSaveIcon.scrollFactor.set();
		autoSaveIcon.alpha = 0;
		add(autoSaveIcon);

		// save data positions for the UI boxes
		if(chartEditorSave.data.mainBoxPosition != null && chartEditorSave.data.mainBoxPosition.length > 1)
			mainBox.setPosition(chartEditorSave.data.mainBoxPosition[0], chartEditorSave.data.mainBoxPosition[1]);
		if(chartEditorSave.data.infoBoxPosition != null && chartEditorSave.data.infoBoxPosition.length > 1)
			infoBox.setPosition(chartEditorSave.data.infoBoxPosition[0], chartEditorSave.data.infoBoxPosition[1]);

		upperBox = new PsychUIBox(40, 40, 330, 300, ['File', 'Edit', 'View']);
		upperBox.scrollFactor.set();
		upperBox.isMinimized = true;
		upperBox.minimizeOnFocusLost = true;
		upperBox.canMove = false;
		upperBox.cameras = [camUI];
		upperBox.bg.visible = false;
		add(upperBox);

		outputTxt = new FlxText(25, FlxG.height - 50, FlxG.width - 50, '', 20);
		outputTxt.borderSize = 2;
		outputTxt.borderStyle = OUTLINE_FAST;
		outputTxt.scrollFactor.set();
		outputTxt.cameras = [camUI];
		outputTxt.alpha = 0;
		add(outputTxt);

		if(PlayState.SONG == null) //Atleast try to avoid crashes
		{
			openNewChart();
		}

		updateJsonData();
		
		// TABS
		////// for main box
		addMiscTab();
		addDataTab();
		addEventsTab();
		addNoteTab();
		addSectionTab();
		addSongTab();
		addCreditsTab();
		
		////// for upper box
		addFileTab();
		addEditTab();
		addViewTab();
		//

		loadMusic();
		reloadNotesDropdowns();
		if(!_shouldReset)
		{
			vocals.time = opponentVocals.time = FlxG.sound.music.time = Conductor.songPosition - Conductor.offset;
			if(FlxG.sound.music.time >= vocals.length)
				vocals.pause();
			if(FlxG.sound.music.time >= opponentVocals.length)
				opponentVocals.pause();
		}

		reloadNotes();
		updateGridVisibility();

		// CHARACTERS FOR THE DROP DOWNS
		var gameOverCharacters:Array<String> = loadFileList('characters/', 'characterList.txt');
		var characterList:Array<String> = gameOverCharacters.filter((name:String) -> (!name.endsWith('-dead') && !name.endsWith('-death')));
		playerDropDown.list = characterList;
		opponentDropDown.list = characterList;
		girlfriendDropDown.list = characterList;

		gameOverCharacters.insert(0, '');
		gameOverCharacters.sort(function(a:String, b:String)
		{
			if((a == '' || a.endsWith('-dead') || a.endsWith('-death')) && !(b == '' || b.endsWith('-dead') || b.endsWith('-death'))) return -1; //Prioritize "-dead" or "-death" characters
			return 0;
		});
		gameOverCharDropDown.list = gameOverCharacters;
		
		stageDropDown.list = loadFileList('stages/', 'stageList.txt');
		onChartLoaded();

		var tipText:FlxText = new FlxText(FlxG.width - 210, FlxG.height - 30, 200, 'Press F1 for Help', 20);
		tipText.cameras = [camUI];
		tipText.setFormat(null, 16, FlxColor.WHITE, RIGHT);
		tipText.borderColor = FlxColor.BLACK;
		tipText.scrollFactor.set();
		tipText.borderSize = 1;
		tipText.active = false;
		add(tipText);

		tipBg = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		tipBg.cameras = [camUI];
		tipBg.scale.set(FlxG.width, FlxG.height);
		tipBg.updateHitbox();
		tipBg.scrollFactor.set();
		tipBg.visible = tipBg.active = false;
		tipBg.alpha = 0.6;
		add(tipBg);
		
		fullTipText = new FlxText(0, 0); //shadowMario, FlxText automatically sets the height. So just edit size instead please.
		fullTipText.setFormat(Paths.font('vcr.ttf'), 24, FlxColor.WHITE, CENTER);
		fullTipText.size = 14;
		fullTipText.cameras = [camUI];
		fullTipText.scrollFactor.set();
		fullTipText.visible = fullTipText.active = false;
		fullTipText.text = [
			"W/S/Mouse Wheel - Move Conductor's Time",
			"A/D - Change Sections",
			"Q/E/CTRL + Mouse Wheel Decrease/Increase Long Note",
			"Hold Shift / Alt to Increase / Decrease move by 4x",
			"",
			"F5 - Preview Chart", // changed it because screenshot bind is F12
			"Enter/Return - Playtest Chart",
			"Space - Stop/Resume song",
			"",
			"Alt + Click - Select Note(s)",
			"Shift + Click - Select/Unselect Note(s)",
			"Right Click - Selection Box",
			"",
			"R - Reset Section",
			"Home / Shift + R - Jump to the Start of the Song",
			"End - Jump to the End of the Song",
			"Z/X - Zoom in/out",
			"Left/Right - Change Snap (in Vortex Mode)",
			"Page/Arrows Up/Down - Scroll (in Vortex Mode)",
			#if FLX_PITCH
			"Left Bracket / Right Bracket - Change Song Playback Rate",
			"ALT + Left Bracket / Right Bracket - Reset Song Playback Rate",
			#end
			"",
			"Ctrl + Z - Undo",
			"Ctrl + Y - Redo",
			"Ctrl + X - Cut Selected Notes",
			"Ctrl + C - Copy Selected Notes",
			"Ctrl + V - Paste Copied Notes",
			"Ctrl + A - Select all in current Section",
			"Ctrl + S - Quicksave",
			"Ctrl + O - Open Chart",
			"",
			"You can use Reverse Scroll on SkyDecay Engine!\nAs well as chart like it is Arrow Vortex!",
			"",
			"Tips for Charting:",
			"------------------",
			"Follow Sounds and Pitches",
			"Do NOT place long notes half beat step. Unless it's really necessary",
			"Use offsets if notes aren't timed",
			"Time BPM changes correctly using Beats Per Section (can go 0 - 4 [or 16 but don't go above 4!])",
			"Snap Divisors can be used by just zooming in. Snap divisors normally is questionable.",
			"For more info on charting, go to assets folder and there's photos showing patterns and more."
		].join('\n');
		fullTipText.screenCenter();
		add(fullTipText);
		
		super.create();
		
		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
	}
	
	var texturedSustains:Bool;
	var gridColors:Array<FlxColor>;
	var gridColorsOther:Array<FlxColor>;
	function refreshSustains(useTextured:Bool):Bool {
		for (note in notes)
			note.useBlandSustains = !useTextured;
		return texturedSustains = useTextured;
	}
	function changeTheme(changeTo:ChartingTheme, ?doSave:Bool = true)
	{
		var oldTheme:ChartingTheme = theme;
		theme = changeTo;
		chartEditorSave.data.theme = changeTo;
		if(doSave) chartEditorSave.flush();
		var gridBgWidth = gridBg == null ? null : gridBg.width;
		var prevGridBgWidth = prevGridBg == null ? null : prevGridBg.width;
		var nextGridBgWidth = nextGridBg == null ? null : nextGridBg.width;

		switch(theme)
		{
			case SKYDECAY:
				bg.visible = false;
				sd.visible = true;
				gridColors = [0xFF04A0FA, 0xFF178BEB];
				gridColorsOther = [0xFF0D4381, 0xFF103780]; // gotta find out how to switch sections (or just use the event i added)
			case LIGHT:
				sd.visible = false;
				bg.visible = true;
				bg.color = 0xFFA0A0A0;
				gridColors = [0xFFDFDFDF, 0xFFBFBFBF];
				gridColorsOther = [0xFF5F5F5F, 0xFF4A4A4A];
			case DARK:
				sd.visible = false;
				bg.visible = true;
				bg.color = 0xFF222222;
				gridColors = [0xFF3F3F3F, 0xFF2F2F2F];
				gridColorsOther = [0xFF1F1F1F, 0xFF111111];
			case VSLICE:
				sd.visible = false;
				bg.visible = true;
				bg.color = 0xFF673AB7;
				gridColors = [0xFFD0D0D0, 0xFFAFAFAF];
				gridColorsOther = [0xFF595959, 0xFF464646];
			case CUSTOM:
				sd.visible = false;
				bg.visible = true;
				bg.color = CoolUtil.colorFromString(chartEditorSave.data.customBgColor);
				gridColors = [CoolUtil.colorFromString(chartEditorSave.data.customGridColors[0]), CoolUtil.colorFromString(chartEditorSave.data.customGridColors[1])];
				gridColorsOther = [CoolUtil.colorFromString(chartEditorSave.data.customNextGridColors[0]), CoolUtil.colorFromString(chartEditorSave.data.customNextGridColors[1])];
			default:
				sd.visible = false;
				bg.visible = true;
				bg.color = 0xFF303030;
				gridColors = [0xFFDFDFDF, 0xFFBFBFBF];
				gridColorsOther = [0xFF5F5F5F, 0xFF4A4A4A];
		}

		if(theme != oldTheme || theme == CUSTOM)
		{
			if(gridBg != null)
			{
				gridBg.loadGrid(gridColors[0], gridColors[1]);
				gridBg.vortexLineEnabled = vortexEnabled;
				gridBg.vortexLineSpace = GRID_SIZE * 4 * curZoom;
			}
			if(prevGridBg != null)
			{
				prevGridBg.loadGrid(gridColorsOther[0], gridColorsOther[1]);
				prevGridBg.vortexLineEnabled = vortexEnabled;
				prevGridBg.vortexLineSpace = GRID_SIZE * 4 * curZoom;
			}
			if(nextGridBg != null)
			{
				nextGridBg.loadGrid(gridColorsOther[0], gridColorsOther[1]);
				nextGridBg.vortexLineEnabled = vortexEnabled;
				nextGridBg.vortexLineSpace = GRID_SIZE * 4 * curZoom;
			}
		}
	}

	function createLilPlayer(name:String = 'bf')
	{
		//customFunctions
		//shows actual characters (From Moon's Modded Psych Engine)
		if(name != null)
		lilPlayer = new Character(0, 0, name, false);
		lilPlayer.scrollFactor.set();
		lilPlayer.screenCenter();
		lilPlayer.setGraphicSize(Std.int(lilPlayer.width * 0.4));
		add(lilPlayer);
		lilPlayer.flipX = !lilPlayer.flipX;
		for (key in lilPlayer.animOffsets.keys()) {
			lilPlayer.animOffsets[key][0] *= lilPlayer.scale.x;
			lilPlayer.animOffsets[key][1] *= lilPlayer.scale.y;
		}
	}

	function createLilOpponent(name:String = 'bf-opponent')
	{
		if(name != null)
		lilOpponent = new Character(0, 0, name, false);
		lilOpponent.scrollFactor.set();
		lilOpponent.screenCenter();		lilOpponent.setGraphicSize(Std.int(lilOpponent.width * 0.4));
		add(lilOpponent);
		for (keyt in lilOpponent.animOffsets.keys()) {
			lilOpponent.animOffsets[keyt][0] *= lilOpponent.scale.x;
			lilOpponent.animOffsets[keyt][1] *= lilOpponent.scale.y;
		}
	}

	function createLilGirlfriend(name:String = 'gf')
	{
		if (name != null)
		lilGf = new Character(0, 0, name, false); //50, 335
		lilGf.scrollFactor.set();
		lilGf.screenCenter();
		lilGf.setGraphicSize(Std.int(lilGf.width * 0.4));
		add(lilGf);
		for (keyt in lilGf.animOffsets.keys()) {
			lilGf.animOffsets[keyt][0] *= lilGf.scale.x;
			lilGf.animOffsets[keyt][1] *= lilGf.scale.y;
		}
	}

	/*
	function createPlayerGhost(name:String = 'bf')
		{
			//customFunctions
			//shows actual characters (From Moon's Modded Psych Engine)
			if(name != null)
			playerGhost = new Character(0, 0, name, false);
			playerGhost.scrollFactor.set();
			playerGhost.screenCenter();
			playerGhost.setGraphicSize(Std.int(playerGhost.width * 0.4));
			playerGhost.alpha = 0.5;
			add(playerGhost);
			playerGhost.flipX = !playerGhost.flipX;
			for (key in playerGhost.animOffsets.keys()) {
				playerGhost.animOffsets[key][0] *= playerGhost.scale.x;
				playerGhost.animOffsets[key][1] *= playerGhost.scale.y;
			}
		}

	function createOpponentGhost(name:String = 'bf-opponent')
		{
			if(name != null)
			opponentGhost = new Character(0, 0, name, false);
			opponentGhost.scrollFactor.set();
			opponentGhost.screenCenter();
			opponentGhost.setGraphicSize(Std.int(opponentGhost.width * 0.4));
			opponentGhost.alpha = 0.5;
			add(opponentGhost);
			for (keyt in opponentGhost.animOffsets.keys()) {
				opponentGhost.animOffsets[keyt][0] *= opponentGhost.scale.x;
				opponentGhost.animOffsets[keyt][1] *= opponentGhost.scale.y;
			}
		}
	*/

	function reloadLilBuddies(id:Int = 4) //id 1 is for the player, id 2 is for the opponent, id 3 is for Girlfriend (or middle), id 4 is for all
	{
		var character1 = PlayState.SONG.player1;
		var character2 = PlayState.SONG.player2;
		var character3 = PlayState.SONG.gfVersion;

    	if(id == 1 || id == 4) { //Reload The Player
    	    if (lilPlayer != null) {
    	        remove(lilPlayer); // Remove from display list
    	        lilPlayer.destroy(); // Destroy the object
    	        lilPlayer = null; // Nullify reference
    	    }
    	    createLilPlayer(character1);
    	}
    	if(id == 2 || id == 4) { //Reload The Opponent
    	    if (lilOpponent != null) {
    	        remove(lilOpponent);
    	        lilOpponent.destroy();
    	        lilOpponent = null;
    	    }
    	    createLilOpponent(character2);
    	}
    	if(id == 3 || id == 4) { //Reload The Girlfriend
    	    if (lilGf != null) {
    	        remove(lilGf);
    	        lilGf.destroy();
    	        lilGf = null;
    	    }
    	    createLilGirlfriend(character3);
    	}
	}

	function openNewChart()
	{
		var song:SwagSong = {
			song: '',
			songArtists: '',
			artists: '',
			charters: '',
			vfx: '',
			scripters: '',

			player1: 'bf',
			player2: 'bf-opponent',
			gfVersion: 'gf',
			stage: 'stage',
			format: 'skydecay_beta',
			needsVoices: true,
			
			overallDifficulty: 5, // default overall difficulty
			hpDrainRate: 5, // default hp drain rate
			speed: 2.8, // recommended scroll speeds is 2.6-3.4
			luaType: false,
			bpm: 0,
			offset: 0,
			
			events: [],
			
			notes: [],
		};
		Song.chartPath = null;
		loadChart(song);
	}

	function prepareReload()
	{
		updateJsonData();
		loadMusic();
		reloadNotes();
		onChartLoaded();
		updateHeads(true);
		
		autoSaveTime = 0;
		Conductor.songPosition = 0;
		if(FlxG.sound.music != null) FlxG.sound.music.time = 0;
		curSec = 0;
		loadSection();
		forceDataUpdate = true;
	}

	function onChartLoaded()
	{
		if(PlayState.SONG == null) return;

		// SONG TAB
		songNameInputText.text = PlayState.SONG.song;
		allowVocalsCheckBox.checked = (PlayState.SONG.needsVoices != false); //If the song for some reason does not have this value, it will be set to true

		bpmStepper.value = PlayState.SONG.bpm;
		odStepper.value = PlayState.SONG.overallDifficulty != null ? PlayState.SONG.overallDifficulty : 5; // default overall difficulty
		hpStepper.value = PlayState.SONG.hpDrainRate != null ? PlayState.SONG.hpDrainRate : 5; // default hp drain rate	
		scrollSpeedStepper.value = PlayState.SONG.speed;
		audioOffsetStepper.value = Reflect.hasField(PlayState.SONG, 'offset') ? PlayState.SONG.offset : 0;
		Conductor.offset = audioOffsetStepper.value;

		playerDropDown.selectedLabel = PlayState.SONG.player1;
		opponentDropDown.selectedLabel = PlayState.SONG.player2;
		girlfriendDropDown.selectedLabel = PlayState.SONG.gfVersion;
		stageDropDown.selectedLabel = PlayState.SONG.stage;
		StageData.loadDirectory(PlayState.SONG);

		// DATA TAB
		gameOverCharDropDown.selectedLabel = PlayState.SONG.gameOverChar;
		gameOverSndInputText.text = PlayState.SONG.gameOverSound;
		gameOverLoopInputText.text = PlayState.SONG.gameOverLoop;
		gameOverRetryInputText.text = PlayState.SONG.gameOverEnd;

		songArtistInputText.text = PlayState.SONG.songArtists;
		artistsInputText.text = PlayState.SONG.artists;
		chartersInputText.text = PlayState.SONG.charters;
		vfxInputText.text = PlayState.SONG.vfx;
		scriptersInputText.text = PlayState.SONG.scripters;

		luaTypeCheckBox.checked = PlayState.SONG.luaType; //Default to false for modern, checked for legacy

		noRGBCheckBox.checked = (PlayState.SONG.disableNoteRGB == true);

		noteTextureInputText.text = PlayState.SONG.arrowSkin;
		noteSplashesInputText.text = PlayState.SONG.splashSkin;
		reloadLilBuddies();
	}
	
	var noteSelectionSine:Float = 0;
	var selectedNotes:Array<MetaNote> = [];
	var ignoreClickForThisFrame:Bool = false;
	var outputAlpha:Float = 0;
	var songFinished:Bool = false;

	var fileDialog:FileDialogHandler = new FileDialogHandler();
	var lastFocus:PsychUIInputText;

	var autoSaveTime:Float = 0;
	var autoSaveCap:Int = 2; //in minutes
	var backupLimit:Int = 10;

	var lilBfResetAnim:Float = 0;
	var lilOppResetAnim:Float = 0;

	var lilPlayerDP:Array<Float> = [750, 5];
	var lilOpponentDP:Array<Float> = [100, 40];
	var lilGfDP:Array<Float> = [700, 100]; //Feels offensive that you didn't capitalize the word gf || did it just for you Rexy poo (kill me)

	private var playerHoldTime:Float = 0;
	private var opponentHoldTime:Float = 0;
	private var gfHoldTime:Float = 0;

	var lastBeatHit:Int = 0;
	var lastSongTime:Float = 0;
	
	override function update(elapsed:Float)
	{	
		vortexInput = false;
		if(!fileDialog.completed)
		{
			lastFocus = PsychUIInputText.focusOn;
			return;
		}

		if(lilPlayer.chartArray != null)
			lilPlayer.setPosition(lilPlayerDP[0] + lilPlayer.chartArray[0], lilPlayerDP[1] + lilPlayer.chartArray[1]);
		else
			lilPlayer.setPosition(lilPlayerDP[0] + lilPlayer.positionArray[0], lilPlayerDP[1] + lilPlayer.positionArray[1]);

		if(lilOpponent.chartArray != null)
			lilOpponent.setPosition(lilOpponentDP[0] + lilOpponent.chartArray[0], lilOpponentDP[1] + lilOpponent.chartArray[1]);
		else
			lilOpponent.setPosition(lilOpponentDP[0] + lilOpponent.positionArray[0], lilOpponentDP[1] + lilOpponent.positionArray[1]);

		if(lilGf.chartArray != null)
			lilGf.setPosition(lilGfDP[0] + lilGf.chartArray[0], lilGfDP[1] + lilGf.chartArray[1]);
		else
			lilGf.setPosition(lilGfDP[0] + lilGf.positionArray[0], lilGfDP[1] + lilGf.positionArray[1]);

		/*
		playerGhost.setPosition(lilPlayerDP[0] + playerGhost.positionArray[0], lilPlayerDP[1] + playerGhost.positionArray[1]);
		opponentGhost.setPosition(lilOpponentDP[0] + opponentGhost.positionArray[0], lilOpponentDP[1] + opponentGhost.positionArray[1]);
		 if (currentPlayer1Chosen == null)
		{
			currentPlayer1Chosen = 'bf';
		}
		
		var player1CurrentcharacterPath:String = 'characters/$currentPlayer1Chosen.json';
		var player1CurrentPath:String = Paths.getPath(player1CurrentcharacterPath, TEXT, null, true);
		if (FileSystem.exists(player1CurrentPath))
		{	
			var player1CurrentFile = sys.io.File.getContent(player1CurrentPath);
			var player1CurrentJsonData = TJSON.parse(player1CurrentFile+".json");
			var player1Data:Dynamic = player1CurrentJsonData;

			//trace('player1 = ' + player1CurrentJsonData);
			trace('player1Image = ' + player1Data.image);
		}*/
		
		var charterFocus:Bool = focusedOnEditor();
		if(autoSaveCap > 0)
		{
			autoSaveTime += elapsed / 60.0;
			//trace(autoSaveTime);
			//#if debug if(FlxG.keys.justPressed.J) autoSaveTime += 20/60.0; #end
			if(autoSaveTime >= autoSaveCap #if debug || FlxG.keys.justPressed.NUMPADMULTIPLY #end)
			{
				FlxTween.cancelTweensOf(autoSaveIcon);
				autoSaveTime = 0;
				autoSaveIcon.alpha = 0;
				updateChartData();
				var chartName:String = 'unknown';
				if(Song.chartPath != null)
				{
					chartName = Song.chartPath.replace('\\', '/');
					chartName = chartName.substring(chartName.lastIndexOf('/')+1, chartName.lastIndexOf('.'));
				}
				chartName += DateTools.format(Date.now(), '_%Y-%m-%d_%H-%M-%S');
				var songCopy:SwagSong = Reflect.copy(PlayState.SONG);
				Reflect.setField(songCopy, '__original_path', Song.chartPath);
				var dataToSave:String = haxe.Json.stringify(songCopy);
				//trace(chartName, dataToSave);
				if(!FileSystem.isDirectory('backups')) FileSystem.createDirectory('backups');
				File.saveContent('backups/$chartName.$BACKUP_EXT', dataToSave);

				if(backupLimit > 0)
				{
					var files:Array<String> = FileSystem.readDirectory('backups/').filter((file:String) -> file.endsWith('.$BACKUP_EXT'));
					if(files.length > backupLimit)
					{
						var incorrect:Array<String> = [];
						var map:Map<String, Float> = [];
						for(file in files)
						{
							var split:Array<String> = file.split('_');
							if(split.length > 2) //is properly formatted
							{
								try
								{
									var timeStr:String = split[split.length-1].replace('-', ':');
									timeStr = timeStr.substr(0, timeStr.indexOf('.'));

									var fileJoin:String = split[split.length-2] + ' ' + timeStr;
									var date:Date = Date.fromString(fileJoin);
									//trace(fileJoin, date.getTime());
									map.set(file, date.getTime());
								}
								catch(e:Exception)
								{
									incorrect.push(file);
								}
							}
							else incorrect.push(file);
						}

						if(incorrect.length > 0) files = files.filter((file:String) -> !incorrect.contains(file));
						files.sort(function(a:String, b:String) return map.get(a) > map.get(b) ? 1 : -1);

						while(files.length > backupLimit)
						{
							var file = files.shift();
							//trace('removed $file');
							try
							{
								FileSystem.deleteFile('backups/$file');
							}
							catch(e:Exception) {}
						}
					}
				}

				FlxTween.tween(autoSaveIcon, {alpha: 1}, 0.5, {onComplete: function(_)
					FlxTween.tween(autoSaveIcon, {alpha: 0}, 0.5, {startDelay: 2})
				});
			}
		}

		ClientPrefs.toggleVolumeKeys(charterFocus);
		
		outputAlpha = Math.max(0, outputAlpha - elapsed);
		var holdingAlt:Bool = FlxG.keys.pressed.ALT;
		if(FlxG.sound.music != null)
		{
			if(charterFocus) //If not typing anything
			{
				if(FlxG.keys.justPressed.F5)
				{
					super.update(elapsed);
					openEditorPlayState();
					lastFocus = PsychUIInputText.focusOn;
					return;
				}
				else if(FlxG.keys.justPressed.F1)
				{
					var vis:Bool = !fullTipText.visible;
					tipBg.visible = tipBg.active = fullTipText.visible = fullTipText.active = vis;
				}

				if(FlxG.keys.justPressed.ESCAPE) // why isn't this a keybind to begin with?
				{
					goToMasterMenu();
				}

				var goingBack:Bool = false;
				if(FlxG.keys.pressed.RBRACKET || (FlxG.keys.pressed.LBRACKET && (goingBack = true)))
				{
					if(holdingAlt)
					{
						if(playbackRate != 1)
						{
							playbackRate = 1;
							setPitch();
						}
					}
					else
					{
						playbackRate = FlxMath.bound(playbackRate + elapsed * (!goingBack ? 1 : -1), playbackSlider.min, playbackSlider.max);
						setPitch();
					}
					playbackSlider.value = playbackRate;
				}
				
				if(FlxG.keys.justPressed.HOME)
				{
					setSongPlaying(false);
					resetBuddies();
					Conductor.songPosition = FlxG.sound.music.time = 0;
					loadSection(0);
				}
				else if(FlxG.keys.justPressed.END)
				{
					setSongPlaying(false);
					resetBuddies();
					Conductor.songPosition = FlxG.sound.music.time = FlxG.sound.music.length - 1;
					loadSection(PlayState.SONG.notes.length - 1);
				}
				else if(FlxG.keys.justPressed.R)
				{
					var timeToGoBack:Float = 0;
					if(!FlxG.keys.pressed.SHIFT) timeToGoBack = cachedSectionTimes[curSec] + (curSec > 0 ? 0.000001 : 0);
					else loadSection(0);
					Conductor.songPosition = FlxG.sound.music.time = vocals.time = opponentVocals.time = timeToGoBack;
				}
				else if (FlxG.keys.justPressed.HOME)
				{
					loadSection(0);
					Conductor.songPosition = FlxG.sound.music.time = vocals.time = opponentVocals.time = 0;
				}
				else if (FlxG.keys.justPressed.END)
				{
					loadSection(cachedSectionTimes.length - 1);
					Conductor.songPosition = FlxG.sound.music.time = vocals.time = opponentVocals.time = FlxG.sound.music.length;
				}
				else if(FlxG.keys.pressed.W != FlxG.keys.pressed.S || FlxG.mouse.wheel != 0)
				{
					if(FlxG.sound.music.playing)
						setSongPlaying(false);
						resetBuddies();
					
					var downScrollMult:Int = (downScroll ? -1 : 1);
					if(mouseSnapCheckBox.checked && FlxG.mouse.wheel != 0)
					{
						var snap:Float = Conductor.stepCrochet / (curQuant/16) / curZoom;
						var timeAdd:Float = (FlxG.keys.pressed.SHIFT ? 4 : 1) / (holdingAlt ? 4 : 1) * FlxG.mouse.wheel * downScrollMult * snap;
						var time:Float = Math.round((FlxG.sound.music.time - timeAdd) / snap) * snap;
						if(time > 0) time += 0.000001; //goes at the start of a section more properly
						FlxG.sound.music.time = time;
					}
					else
					{
						var speedMult:Float = (FlxG.keys.pressed.SHIFT ? 4 : 1) * (FlxG.mouse.wheel != 0 ? 4 : 1) / (holdingAlt ? 4 : 1) * downScrollMult;
						if(FlxG.keys.pressed.W || FlxG.mouse.wheel > 0)
							FlxG.sound.music.time -= Conductor.crochet * speedMult * 1.5 * elapsed / curZoom;
						else if(FlxG.keys.pressed.S || FlxG.mouse.wheel < 0)
							FlxG.sound.music.time += Conductor.crochet * speedMult * 1.5 * elapsed / curZoom;
					}

					FlxG.sound.music.time = FlxMath.bound(FlxG.sound.music.time, 0, FlxG.sound.music.length - 1);
					if(FlxG.sound.music.playing) setSongPlaying(!FlxG.sound.music.playing);
				}
				if(FlxG.keys.justPressed.SPACE)
				{
					setSongPlaying(!FlxG.sound.music.playing);
					resetBuddies();
				}
			}

			if(!songFinished) Conductor.songPosition = FlxMath.bound(FlxG.sound.music.time + Conductor.offset, 0, FlxG.sound.music.length - 1);
			updateScrollY();
		}

		if(lilOppResetAnim > 0) {
			lilOppResetAnim -= elapsed;
			if(lilOppResetAnim <= 0) {
				lilOpp.animation.play('idle');
				lilOpp.color = FlxColor.WHITE;
				lilOppResetAnim = 0;
			}
		}
		
		if(lilBfResetAnim > 0) {
			lilBfResetAnim -= elapsed;
			if(lilBfResetAnim <= 0) {
				lilBf.animation.play('idle');
				lilBf.color = FlxColor.WHITE;
				lilBfResetAnim = 0;
			}
		}

		super.update(elapsed);

		if(playerHoldTime > 0) {
			playerHoldTime -= elapsed;
			lilPlayer.holdTimer = 0;
			
			if(playerHoldTime <= 0) {
				playerHoldTime = 0;
			}
		}
		
		if(opponentHoldTime > 0) {
			opponentHoldTime -= elapsed;
			lilOpponent.holdTimer = 0;
			
			if(opponentHoldTime <= 0) {
				opponentHoldTime = 0;
			}
		}
		
		if(gfHoldTime > 0) {
			gfHoldTime -= elapsed;
			lilGf.holdTimer = 0;
			
			if(gfHoldTime <= 0) {
				gfHoldTime = 0;
			}
		}
		
		if(songFinished)
		{
			onSongComplete();
			lastSongTime = FlxG.sound.music.time;
			songFinished = false;
		}
		else if(FlxG.sound.music != null)
		{
			if(FlxG.sound.music.time >= vocals.length)
				vocals.pause();
			if(FlxG.sound.music.time >= opponentVocals.length)
				opponentVocals.pause();

			while(curSec > 0 && Conductor.songPosition < cachedSectionTimes[curSec] - 1)
				loadSection(curSec - 1);
			while(curSec < cachedSectionTimes.length - 1 && Conductor.songPosition >= cachedSectionTimes[curSec + 1])
				loadSection(curSec + 1);
		}
		
		if(charterFocus)
		{
			var doCut:Bool = false;
			var canContinue:Bool = true;
			if(FlxG.keys.justPressed.ENTER)
			{
				goToPlayState();
				return;
			}
			else if(FlxG.keys.pressed.CONTROL && !isMovingNotes && (FlxG.keys.justPressed.Z || FlxG.keys.justPressed.Y || FlxG.keys.justPressed.X ||
				FlxG.keys.justPressed.C || FlxG.keys.justPressed.V || FlxG.keys.justPressed.A || FlxG.keys.justPressed.S))
			{
				canContinue = false;
				if(FlxG.keys.justPressed.Z)
					undo();
				else if(FlxG.keys.justPressed.Y)
					redo();
				else if((doCut = FlxG.keys.justPressed.X) || FlxG.keys.justPressed.C) // Cut (Ctrl + X) and Copy (Ctrl + C)
				{
					if(selectedNotes.length > 0)
					{
						copiedNotes = [];
						copiedEvents = [];
						var pushedNotes:Array<Array<Dynamic>> = [];

						for (note in selectedNotes)
						{
							if(note == null) continue;

							var copied:Array<Dynamic> = makeNoteDataCopy(note.songData, note.isEvent);
							
							pushedNotes.push(copied);
							if (note.isEvent) { copiedEvents.push(copied); }
							else { copiedNotes.push(copied); }
						}
						pushedNotes.sort((a:Array<Dynamic>, b:Array<Dynamic>) -> FlxSort.byValues(FlxSort.ASCENDING, a[0], b[0]));
						
						var minTime:Float = Conductor.getStep(pushedNotes[0][0]);
						for (note in pushedNotes)
							note[0] = Conductor.getStep(note[0]);
					}
				}
				else if(FlxG.keys.justPressed.V) // Paste (Ctrl + V)
				{
					if(copiedNotes.length > 0 || copiedEvents.length > 0)
					{
						selectionBox.visible = false;
						stopMovingNotes();
						resetSelectedNotes();
						selectedNotes = pasteCopiedNotesToSection();
						selectedNotes.sort(PlayState.sortByTime);
						
						var minNoteData:Null<Int> = null;
						for (note in selectedNotes)
						{
							if(note == null || note.isEvent) continue;

							if(minNoteData == null || minNoteData > note.songData[1]) minNoteData = note.songData[1];
						}
						minNoteData ??= 0;
						
						var pushedNotes:Array<MetaNote> = [];
						var pushedEvents:Array<EventMetaNote> = [];
						for (note in selectedNotes)
						{
							if(note == null) continue;

							if(!note.isEvent)
							{
								note.changeNoteData(Std.int(note.songData[1] - minNoteData));
								pushedNotes.push(note);
							}
							else pushedEvents.push(cast (note, EventMetaNote));
						}
						
						addUndoAction(ADD_NOTE, {notes: pushedNotes, events: pushedEvents});
						if (selectedNotes.length > 0) moveSelectedNotes(minNoteData, selectedNotes[0].y);
					}
				}
				else if(FlxG.keys.justPressed.A) // Select All (Ctrl + A)
				{
					var sel = selectedNotes;
					selectedNotes = curRenderedNotes.members.copy();
					addUndoAction(SELECT_NOTE, {old: sel, current: selectedNotes.copy()});
					FlxG.sound.play(Paths.sound('fav'), 0.5);
					onSelectNote();
					trace('Notes selected: ' + selectedNotes.length);
				}
				else if(FlxG.keys.justPressed.S) // Save (Ctrl + S)
					saveChart();
					FlxG.sound.play(Paths.sound('noteComboSound'), 0.5);
			}
			
			vortexInput = (allowInput && canContinue && vortexEnabled);
			allowInput = true;
			if (vortexInput && FlxG.sound.music != null && FlxG.sound.music.playing) {
				updateVortexHolds();
				vortexMoved = true;
			}
			if(doCut || FlxG.keys.justPressed.DELETE || FlxG.keys.justPressed.BACKSPACE || (isMovingNotes && (FlxG.mouse.justPressedRight || FlxG.keys.justPressed.ESCAPE))) // Delete button
			{
				if(selectedNotes.length > 0)
				{
					var removedNotes:Array<MetaNote> = [];
					var removedEvents:Array<EventMetaNote> = [];
					while(selectedNotes.length > 0)
					{
						var note:MetaNote = selectedNotes[0];
						selectedNotes.shift();
						if(note == null) continue;
		
						var kind:String = !note.isEvent ? 'note' : 'event';
						FlxG.sound.play(Paths.sound('chartingSounds/noteErase'), 0.5);
						trace('Removed $kind at time: ${note.strumTime} | Downscroll: $downScroll | Note data:' + note.noteData + '| Event data: ' + (note.isEvent ? cast(note, EventMetaNote).eventName : 'N/A'));
						if(!note.isEvent)
						{
							notes.remove(note);
							removedNotes.push(note);
						}
						else
						{
							var ev:EventMetaNote = cast (note, EventMetaNote);
							events.remove(ev);
							removedEvents.push(ev);
						}
					}
					movingNotes.clear();
					isMovingNotes = false;
					selectedNotes = [];
					onSelectNote();
					softReloadNotes();
					addUndoAction(DELETE_NOTE, {notes: removedNotes, events: removedEvents});
				}
			}
		}

		if (selectionBox.visible) {
			if (FlxG.mouse.releasedRight) {
				var sel = selectedNotes.copy();
				updateSelectionBox();
				if(!FlxG.keys.pressed.SHIFT && !holdingAlt)
					resetSelectedNotes();

				var selectionBounds = selectionBox.getScreenBounds(null, camUI);
				selectionBounds.setPosition(selectionBounds.x + GRID_SIZE * .5, selectionBounds.y + GRID_SIZE * .5);
				selectionBounds.setSize(selectionBounds.width - GRID_SIZE, selectionBounds.height - GRID_SIZE);
				for (note in curRenderedNotes)
				{
					if(note == null) continue;

					if(!selectedNotes.contains(note) || holdingAlt /*&& FlxG.overlap(selectionBox, note)*/) //overlap doesnt work here
					{
						var noteBounds = note.getScreenBounds(null, camUI);
						noteBounds.top -= scrollY;
						noteBounds.bottom -= scrollY;

						if(selectionBounds.overlaps(noteBounds))
						{
							if(holdingAlt && selectedNotes.contains(note))
							{
								selectedNotes.remove(note);
								note.colorTransform.redMultiplier = note.colorTransform.greenMultiplier = note.colorTransform.blueMultiplier = 1;
								if(note.animation.curAnim != null) note.animation.curAnim.curFrame = 0;
							}
							else selectedNotes.push(note);
							onSelectNote();
						}
					}
				}
				selectionBox.visible = false;
				addUndoAction(SELECT_NOTE, {old: sel, current: selectedNotes.copy()});
			} else if (FlxG.mouse.justMoved)
				updateSelectionBox();
		}
		else if(FlxG.mouse.pressedRight && (FlxG.mouse.deltaScreenX != 0 || FlxG.mouse.deltaScreenY != 0))
		{
			selectionBox.setPosition(FlxG.mouse.screenX, FlxG.mouse.screenY);
			selectionStart.set(FlxG.mouse.screenX, FlxG.mouse.screenY);
			selectionBox.visible = true;
			updateSelectionBox();
		}
		
		for (note in curRenderedNotes) {
			if (note.isEvent) {
				if (cast(note, EventMetaNote).gui.hovering) {
					ignoreClickForThisFrame = true;
					break;
				}
			}
		}
		if(FlxG.mouse.justPressed && (FlxG.mouse.overlaps(mainBox.bg, camUI) || FlxG.mouse.overlaps(infoBox.bg, camUI)))
			ignoreClickForThisFrame = true;

		var minX:Float = gridBg.x;
		if(SHOW_EVENT_COLUMN && lockedEvents) minX += GRID_SIZE;

		if(isMovingNotes && FlxG.mouse.justReleased)
			stopMovingNotes();

		if(FlxG.mouse.x >= minX && FlxG.mouse.x < gridBg.x + gridBg.width)
		{
			var diffX:Float = FlxG.mouse.x - gridBg.x;
			var diffY:Float = FlxG.mouse.y - gridBg.y;
			if(!FlxG.keys.pressed.SHIFT)
				diffY -= diffY % (GRID_SIZE / (curQuant / 16));
			
			var topBg:ChartingGridSprite = (downScroll ? nextGridBg : prevGridBg);
			var bottomBg:ChartingGridSprite = (downScroll ? prevGridBg : nextGridBg);
			
			if (topBg.visible) diffY = Math.max(diffY, -topBg.height);
			else diffY = Math.max(diffY, 0);
			if (bottomBg.visible) diffY = Math.min(diffY, gridBg.height + bottomBg.height - GRID_SIZE);
			else diffY = Math.min(diffY, gridBg.height - GRID_SIZE);
			
			var noteDiffY:Float = diffY;
			if (downScroll)
				noteDiffY = gridBg.height - diffY - GRID_SIZE;

			var noteData:Int = Math.floor(diffX / GRID_SIZE);
			dummyArrow.visible = !selectionBox.visible;
			dummyArrow.x = gridBg.x + noteData * GRID_SIZE;
			if(SHOW_EVENT_COLUMN)
				noteData--;

			if(FlxG.keys.pressed.SHIFT || FlxG.mouse.y >= gridBg.y || !prevGridBg.visible)
				dummyArrow.y = gridBg.y + diffY;
			else
			{
				var t:Float = (diffY - (GRID_SIZE / (curQuant/16)));
				if(FlxG.mouse.y >= gridBg.y) t *= curZoom;
				dummyArrow.y = gridBg.y + t;
			}

			if(isMovingNotes)
			{
				// Move note data
				var nData:Int = Std.int(Math.max(0, noteData));
				if(movingNotesLastData != nData)
				{
					var isFirst:Bool = true;
					var movingNotesMinData:Int = 0;
					var movingNotesMaxData:Int = 0;
					for (note in selectedNotes) //Find boundaries first
					{
						if(note == null || note.isEvent) continue;
	
						var data:Int = note.songData[1];
						if(isFirst || data < movingNotesMinData) movingNotesMinData = data;
						if(data > movingNotesMaxData) movingNotesMaxData = data;
						isFirst = false;
					}

					var diff:Int = nData - movingNotesLastData;
					var maxn:Int = (GRID_PLAYERS * GRID_COLUMNS_PER_PLAYER) - 1;
					movingNotesMinData += diff;
					movingNotesMaxData += diff;
					if(movingNotesMinData < 0)
						diff -= movingNotesMinData;
					else if(movingNotesMaxData > maxn)
						diff -= movingNotesMaxData - maxn;

					for (note in movingNotes)
					{
						if(note == null || note.isEvent) continue; //Events shouldn't change note data as they don't have one

						note.changeNoteData(note.songData[1] + diff);
						positionNoteXByData(note);
					}
				}
				movingNotesLastData = nData;

				// Move note strum time
				if(dummyArrow.y != movingNotesLastY)
				{
					var diff:Float = dummyArrow.y - movingNotesLastY;
					var curSecRow:Int = 0;
					for (note in movingNotes) //Try to figure out new strum time for the notes, DEFINITELY INACCURATE WITH BPM CHANGING, ALTHOUGH UNTESTED
					{
						if(note == null) continue;

						note.chartY += diff;
						var row:Float = (note.chartY / GRID_SIZE) * curZoom;
						while(curSecRow + 1 < cachedSectionRow.length && cachedSectionRow[curSecRow] <= row)
							curSecRow++;

						note.setStrumTime(Math.max(-5000, note.strumTime + (diff * cachedSectionCrochets[curSecRow] / 4) / GRID_SIZE * curZoom));
						positionNoteYOnTime(note);
						if(note.isEvent) cast (note, EventMetaNote).updateEventInfo();
					}
					movingNotesLastY = dummyArrow.y;
				}
			}
			else if (!ignoreClickForThisFrame && FlxG.mouse.justPressed)
			{
				if(FlxG.keys.pressed.CONTROL && FlxG.mouse.justPressed)
				{
					if(selectedNotes.length > 0)
						moveSelectedNotes(noteData, dummyArrow.y);
					else
						showOutput('You must select notes to move them!', true);
				}
				else if(FlxG.mouse.x >= gridBg.x && FlxG.mouse.x < gridBg.x + gridBg.width)
				{
					var closeNotes:Array<MetaNote> = curRenderedNotes.members.filter(function(note:MetaNote)
					{
						var chartY:Float = FlxG.mouse.y - calculateY(note);
						return ((note.isEvent && noteData < 0) || (!note.isEvent && note.songData[1] == noteData)) && chartY >= 0 && chartY < GRID_SIZE;
					});
					closeNotes.sort(function(a:MetaNote, b:MetaNote) return Math.abs(a.strumTime - FlxG.mouse.y) < Math.abs(b.strumTime - FlxG.mouse.y) ? 1 : -1);

					var closest = closeNotes[0];
					if(closest != null && (!closest.isEvent || !lockedEvents))
					{
						if(FlxG.keys.pressed.SHIFT || holdingAlt) // Select Note/Event
						{
							var sel = selectedNotes.copy();
							if(!selectedNotes.contains(closest))
							{
								selectedNotes.push(closest);
								addUndoAction(SELECT_NOTE, {old: sel, current: selectedNotes.copy()});
							}
							else if(!holdingAlt)
							{
								resetSelectedNotes();
								selectedNotes.remove(closest);
								addUndoAction(SELECT_NOTE, {old: sel, current: selectedNotes.copy()});
							}
							trace('Notes selected: ' + selectedNotes.length);
						}
						else if(!FlxG.keys.pressed.CONTROL) // Remove Note/Event
						{
							var kind:String = !closest.isEvent ? 'note' : 'event';
							FlxG.sound.play(Paths.sound('chartingSounds/noteErase'), 0.5);
							trace('Removed $kind at time: ${closest.strumTime} | Downscroll: $downScroll | Note data: $noteData');
							if(!closest.isEvent)
								notes.remove(closest);
							else
								events.remove(cast (closest, EventMetaNote));

							selectedNotes.remove(closest);
							curRenderedNotes.remove(closest, true);
							addUndoAction(DELETE_NOTE, !closest.isEvent ? {notes: [closest]} : {events: [closest]});
						}
						if(selectedNotes.length == 1) onSelectNote();
						forceDataUpdate = true;
					}
					else if(!holdingAlt && FlxG.mouse.y >= gridBg.y && FlxG.mouse.y < gridBg.y + gridBg.height) // Add note
					{
						var strumTime:Float = (noteDiffY / GRID_SIZE * Conductor.stepCrochet / curZoom) + cachedSectionTimes[curSec];
						if(noteData >= 0)
						{
							trace('Added note at time: $strumTime | Downscroll: $downScroll | Note data: $noteData');
							FlxG.sound.play(Paths.sound('chartingSounds/noteLay'), 0.5);
							var didAdd:Bool = false;

							var noteSetupData:Array<Dynamic> = [strumTime, noteData, 0];
							var typeSelected:String = noteTypes[noteTypeDropDown.selectedIndex];
							if(typeSelected != null && typeSelected.length > 0)
								noteSetupData.push(typeSelected);

							var noteAdded:MetaNote = createNote(noteSetupData, curSec);
							for (num in sectionFirstNoteID...notes.length)
							{
								var note = notes[num];
								if(note.strumTime >= strumTime)
								{
									notes.insert(num, noteAdded);
									didAdd = true;
									break;
								}
							}
							if(!didAdd) notes.push(noteAdded);

							if(!holdingAlt)
								resetSelectedNotes();

							selectedNotes.push(noteAdded);
							addUndoAction(ADD_NOTE, {notes: [noteAdded]});
						}
						else if(!lockedEvents)
						{
							trace('Added event at time: $strumTime | Downscroll: $downScroll | Note data: $noteData | Event data (${eventsList[Std.int(Math.max(eventDropDown.selectedIndex, 0))][0]})');
							FlxG.sound.play(Paths.sound('chartingSounds/noteLay'), 0.5);
							var didAdd:Bool = false;

							var eventAdded:EventMetaNote = createEvent([strumTime, [[eventsList[Std.int(Math.max(eventDropDown.selectedIndex, 0))][0], value1InputText.text, value2InputText.text]]]);
							for (num in sectionFirstEventID...events.length)
							{
								var event = events[num];
								if(event.strumTime >= strumTime)
								{
									events.insert(num, eventAdded);
									didAdd = true;
									break;
								}
							}
							if(!didAdd) events.push(eventAdded);

							if(!holdingAlt)
								resetSelectedNotes();

							selectedNotes.push(eventAdded);
							addUndoAction(ADD_NOTE, {events: [eventAdded]});
						}
						onSelectNote();
						softReloadNotes();
					}
				}
			}
		}
		else if(!ignoreClickForThisFrame)
		{
			if(FlxG.mouse.justPressed)
				resetSelectedNotes();

			dummyArrow.visible = false;
		}
		ignoreClickForThisFrame = false;

		if (Conductor.songPosition != lastSongTime || forceDataUpdate)
		{
			var curTime:String = FlxStringUtil.formatTime(Conductor.songPosition / 1000, true);
			var songLength:String = (FlxG.sound.music != null) ? FlxStringUtil.formatTime(FlxG.sound.music.length / 1000, true) : '???';
			var str:String =  '$curTime / $songLength' +
							  '\n\nSection: $curSec' +
							  '\nBeat: $curBeat' +
							  '\nStep: $curStep' +
							  '\n\nBeat Snap: ${curQuant} / 16' +
							  '\nSelected: ${selectedNotes.length}';

			if(str != infoText.text)
			{
				infoText.text = str;
				if(infoText.autoSize) infoText.autoSize = false;
			}
			
			for (note in curRenderedNotes)
			{
				if (note == null) continue;
				
				var offsetTime:Float = note.strumTime + 1;
				var hitAlpha:Float = (FlxG.sound.music.playing ? .4 : .6);
				note.alpha = (offsetTime > Conductor.songPosition) ? 1 : hitAlpha;
				if (!note.isEvent && Conductor.songPosition > offsetTime && lastSongTime <= offsetTime)
					hitNote(note);
			}
			forceDataUpdate = false;

			// moved from beatHit()
			if(lastBeatHit != curBeat) {
				if(metronomeStepper.value > 0 && lastBeatHit != curBeat) FlxG.sound.play(Paths.sound('Metronome_Tick'), metronomeStepper.value);
				callBeatHit(curBeat); // for lil players
			}
	
			lastBeatHit = curBeat;
		}
		
		lastSongTime = Conductor.songPosition;

		if(selectedNotes.length > 0)
		{
			noteSelectionSine += elapsed;
			var sineValue:Float = 0.75 + Math.cos(Math.PI * noteSelectionSine * (isMovingNotes ? 8 : 2)) / 4;
			//trace(sineValue);

			var qPress = FlxG.keys.justPressed.Q;
			var ePress = FlxG.keys.justPressed.E;
			var addSus = (FlxG.keys.pressed.SHIFT ? 4 : 1);
			if(qPress) addSus *= -1;

			var noteSec:Int = 0;
			for (note in selectedNotes)
			{
				if(note == null || !note.exists) continue;

				if(!note.isEvent)
				{
					if(charterFocus && qPress != ePress)
					{
						while(cachedSectionTimes.length > noteSec + 1 && cachedSectionTimes[noteSec + 1] <= note.strumTime)
							noteSec++;
						
						note.setSustainLength(Conductor.stepToSeconds(Math.round(Conductor.getStep(note.strumTime + note.sustainLength) * 2 + addSus) / 2) - note.strumTime, curZoom);
						if (selectedNotes.length == 1)
							susLengthStepper.value = note.sustainLength;
					}
					note.animation.update(elapsed); //let selected notes be animated for better visibility
				}
				note.colorTransform.redMultiplier = note.colorTransform.greenMultiplier = note.colorTransform.blueMultiplier = sineValue;
			}
		}
		else noteSelectionSine = 0;

		outputTxt.alpha = outputAlpha;
		outputTxt.visible = (outputAlpha > 0);
		FlxG.camera.scroll.y = scrollY;
		lastFocus = PsychUIInputText.focusOn;
	}

	function callBeatHit(curBeat) 
	{
		if (curBeat % lilPlayer.danceEveryNumBeats == 0 && !lilPlayer.getAnimationName().startsWith('sing')) {
			lilPlayer.dance();
		}
 
		if (curBeat % lilOpponent.danceEveryNumBeats == 0 && !lilOpponent.getAnimationName().startsWith('sing')) {
			lilOpponent.dance();
		}
 
		if (curBeat % Math.round(gfSpeed * lilGf.danceEveryNumBeats) == 0 && !lilGf.getAnimationName().startsWith('sing')) {
			lilGf.dance();
		}
	}
	
	function hitNote(note:MetaNote) {
		if (note.ignoreNote) return;
		
		var songPlaying:Bool = (FlxG.sound.music != null && FlxG.sound.music.playing);
		var canPlayHitSound:Bool = (songPlaying && note.hitsoundChartEditor);
		var hitSoundPlayer:Bool = (hitsoundPlayerStepper.value > 0);
		var hitSoundOpp:Bool = (hitsoundOpponentStepper.value > 0);

		var lilBuddiesSing:Bool = (lilBuddiesOn && FlxG.sound.music != null && FlxG.sound.music.playing);
		var data:Int = note.noteData % 4; // this isn't used but keep it just incase (lilBuddies)

		var gfShouldSing:Bool = false; // this will only define if gf has to sing, if you want to avoid the other characters singing you should make another variable replicating this one
		var playerShouldSing:Bool = false;
		var opponentShouldSing:Bool = false;
		var sec = getCurChartSection(); //this is to detect the sections
		if(sec != null) sec.gfSection = gfSectionCheckBox.checked;

		if(note.gfNote) { // literally if it's GF notes use them
			gfShouldSing = true;
		} 
		else if(sec != null && sec.gfSection) { // if you're using GF section, this allows it to work on GF SECTION ONLY!!
			var isGfSide = false;

			if(sec.mustHitSection) { // determine which side belongs to GF in this section.
				isGfSide = note.mustPress;
			} else { // or other section.
				isGfSide = !note.mustPress;
			}

			if(isGfSide) { // simple enough
				gfShouldSing = true;
			} else {
				if(sec.mustHitSection) {
					opponentShouldSing = !note.mustPress;
				} else {
					playerShouldSing = note.mustPress;
				}
			}
		}
		else {
			// if it's regular notes then use them
			if(note.mustPress) {
				playerShouldSing = true;
			} else {
				opponentShouldSing = true;
			}
		} //  how in the actual fuck do i get this to work :broken heart: | lemme try nigga	| i did it bitch

	
		if(playerShouldSing) {
			lilPlayer.playAnim(singAnimations[note.noteData], true);
			// lilPlayer.holdTimer = 0;
			playerHoldTime = ((Conductor.stepCrochet * 1.25) + note.sustainLength) / 1000 / playbackRate; // now it holds on long notes yay
		} else if(opponentShouldSing) {
			lilOpponent.playAnim(singAnimations[note.noteData], true);
			// lilOpponent.holdTimer = 0;
			opponentHoldTime = ((Conductor.stepCrochet * 1.25) + note.sustainLength) / 1000 / playbackRate;
		}
	
		if(gfShouldSing) {
			lilGf.playAnim(singAnimations[note.noteData], true);
			// lilGf.holdTimer = 0;
			gfHoldTime = ((Conductor.stepCrochet * 1.25) + note.sustainLength) / 1000 / playbackRate;
		}
		
		if (canPlayHitSound) {
			if(hitSoundPlayer && note.mustPress) {
				FlxG.sound.play(Paths.sound('hitsound'), hitsoundPlayerStepper.value);
				hitSoundPlayer = false;
			} else if(hitSoundOpp && !note.mustPress) {
				FlxG.sound.play(Paths.sound('hitsound'), hitsoundOpponentStepper.value);
				hitSoundOpp = false;
			}
		}

		if(lilBuddiesSing) // yesssss i'm cumming
		{
			data += 4;
			if (!note.noAnimation) {
				if (note.mustPress)
				{
					lilBf.animation.play("" + (note.noteData % 4), true);
					lilBf.color = note.rgbShader.r;
					lilBfResetAnim = ((Conductor.stepCrochet * 3) + note.sustainLength) / 1000 / playbackRate; // for lil buddies to reset after hitting notes. It doesn't stop at sections anymore.
				}
				else
				{
					lilOpp.animation.play("" + (note.noteData % 4), true);
					lilOpp.color = note.rgbShader.r;
					lilOppResetAnim = ((Conductor.stepCrochet * 3) + note.sustainLength) / 1000 / playbackRate;
				}
			}		
		}

		if (songPlaying) {
			if (vortexEnabled) {
				var strumNote:StrumNote = strumLineNotes.members[note.songData[1]];
				if (strumNote != null) {
					strumNote.playAnim('confirm', true);
					strumNote.resetAnim = Math.max(Conductor.stepCrochet * 1.25, note.sustainLength) / 1000 / playbackRate;
				}
			}
			
			if (!note.noAnimation) {
				var section:SwagSection = PlayState.SONG.notes[curSec];
				note.gfNote = (note.gfNote || (section != null && section.gfSection && note.mustPress == section.mustHitSection));
			}
		}
	}

	function resetBuddies() // lil buddies
	{
		lilBf.animation.play("idle");
		lilOpp.animation.play("idle");
		lilBf.color = lilOpp.color = FlxColor.WHITE;
	}

	function moveSelectedNotes(noteData:Int = 0, lastY:Float) //This turns selected notes into moving notes
	{
		var originalNotes:Array<MetaNote> = [];
		var originalEvents:Array<EventMetaNote> = [];
		var movedNotes:Array<MetaNote> = [];
		var movedEvents:Array<EventMetaNote> = [];
		for (note in selectedNotes)
		{
			if(note == null) continue;

			if(!note.isEvent)
			{
				notes.remove(note);
				var secNum:Int = 0;
				for (time in cachedSectionTimes)
				{
					if(time > note.strumTime) break;
					secNum++;
				}
				originalNotes.push(note);
				var mov:MetaNote = createNote(note.songData, secNum);
				movingNotes.add(mov);
				movedNotes.push(mov);
			}
			else
			{
				events.remove(cast (note, EventMetaNote));
				originalEvents.push(cast (note, EventMetaNote));
				var mov:EventMetaNote = createEvent(note.songData);
				movingNotes.add(mov);
				movedEvents.push(mov);
			}
		}
		selectedNotes = movingNotes.members.copy();
		isMovingNotes = true;
		movingNotesLastY = lastY;
		movingNotesLastData = noteData;
		movingNotes.sort(cast PlayState.sortByTime);
		addUndoAction(MOVE_NOTE, {originalNotes: originalNotes, originalEvents: originalEvents, movedNotes: movedNotes, movedEvents: movedEvents});
		softReloadNotes();
	}

	function stopMovingNotes() //This turns moving notes into saved notes
	{
		var pushedNotes:Array<MetaNote> = [];
		var pushedEvents:Array<EventMetaNote> = [];
		movingNotes.forEachAlive(function(note:MetaNote)
		{
			if(!note.isEvent)
			{
				notes.push(note);
				pushedNotes.push(note);
			}
			else
			{
				events.push(cast (note, EventMetaNote));
				pushedEvents.push(cast (note, EventMetaNote));
			}
		});
		notes.sort(PlayState.sortByTime);
		events.sort(PlayState.sortByTime);
		movingNotes.clear();
		isMovingNotes = false;
		softReloadNotes();
	}

	function makeNoteDataCopy(originalData:Array<Dynamic>, isEvent:Bool)
	{
		var dataCopy:Array<Dynamic> = originalData.copy();
		if(isEvent)
		{
			var eventGrp:Array<Array<Dynamic>> = cast dataCopy[1].copy();
			for (num => subEvent in eventGrp)
				eventGrp[num] = subEvent.copy();

			dataCopy[1] = eventGrp;
		}
		return dataCopy;
	}

	function updateScrollY()
	{
		var secStartTime:Null<Float> = cast cachedSectionTimes[curSec];
		var secCrochet:Null<Float> = cast cachedSectionCrochets[curSec];
		var secRows:Null<Float> = cast cachedSectionRow[curSec];
		if(secStartTime == null || secCrochet == null || secRows == null) return;
		
		if (downScroll) {
			scrollY = (((secStartTime - Conductor.songPosition) / secCrochet * GRID_SIZE * 4) - (secRows * GRID_SIZE)) * curZoom - (FlxG.height + GRID_SIZE)/2;
		} else {
			scrollY = (((Conductor.songPosition - secStartTime) / secCrochet * GRID_SIZE * 4) + (secRows * GRID_SIZE)) * curZoom - (FlxG.height - GRID_SIZE)/2;
		}
	}

	function updateSelectionBox()
	{
		var diffX:Float = FlxG.mouse.screenX - selectionStart.x;
		var diffY:Float = FlxG.mouse.screenY - selectionStart.y;
		selectionBox.setPosition(selectionStart.x, selectionStart.y);

		if(diffX < 0) //Fixes negative X scale
		{
			diffX = Math.abs(diffX);
			selectionBox.x -= diffX;
		}
		if(diffY < 0) //Fixes negative Y scale
		{
			diffY = Math.abs(diffY);
			selectionBox.y -= diffY;
		}
		selectionBox.scale.set(diffX, diffY);
		selectionBox.updateHitbox();
	}

	function showOutput(message:String, isError:Bool = false)
	{
		trace(message);
		outputTxt.text = message;
		outputTxt.y = FlxG.height - outputTxt.height - 30;
		outputAlpha = 4;
		if(isError)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'), 0.6);
			outputTxt.color = FlxColor.RED;
		}
		else
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
			outputTxt.color = FlxColor.WHITE;
		}
	}

	function resetSelectedNotes()
	{
		for (note in selectedNotes)
		{
			if(note == null || !note.exists) continue;

			note.colorTransform.redMultiplier = note.colorTransform.greenMultiplier = note.colorTransform.blueMultiplier = 1;
			if(note.animation.curAnim != null) note.animation.curAnim.curFrame = 0;
		}
		selectedNotes.resize(0);
		onSelectNote();
		forceDataUpdate = true;
	}

	function onSelectNote()
	{
		if(selectedNotes.length == 1) //Only one note selected
		{
			var note:MetaNote = selectedNotes[0];
			strumTimeStepper.value = note.strumTime;
			if(!note.isEvent) //Normal note
			{
				if(!note.isEvent)
				{
					susLengthLastVal = susLengthStepper.value = note.sustainLength;
					noteTypeDropDown.selectedIndex = Std.int(Math.max(0, noteTypes.indexOf(note.noteType)));
				}
				else
				{
					susLengthLastVal = susLengthStepper.value = 0;
					noteTypeDropDown.selectedLabel = '';
				}
			}
			else //Event note
			{
				var eventNote:EventMetaNote = cast (selectedNotes[0], EventMetaNote);
				updateSelectedEventText();
			}
		}
		else if(selectedNotes.length > 1)
		{
			susLengthStepper.min = -susLengthStepper.max;
			susLengthLastVal = susLengthStepper.value = 0;
			strumTimeStepper.value = selectedNotes[0].strumTime;
			noteTypeDropDown.selectedLabel = '';
			eventDropDown.selectedLabel = '';
			value1InputText.text = '';
			value2InputText.text = '';
		}
		forceDataUpdate = true;
	}

	function updateSelectedEventText()
	{
		if(selectedNotes.length == 1 && selectedNotes[0].isEvent)
		{
			var eventNote:EventMetaNote = cast (selectedNotes[0], EventMetaNote);
			curEventSelected = Std.int(FlxMath.bound(curEventSelected, 0, eventNote.events.length - 1));
			selectedEventText.text = 'Selected Event: ${curEventSelected + 1} / ${eventNote.events.length}';
			selectedEventText.visible = true;
			
			var myEvent:Array<String> = eventNote.events[curEventSelected];
			if(myEvent != null)
			{
				var eventName:String = (myEvent[0] != null) ? myEvent[0] : '';
				for (num => event in eventsList)
				{
					if(event[0] == eventName)
					{
						eventDropDown.selectedIndex = num;
						break;
					}
				}
				value1InputText.text = (myEvent[1] != null) ? myEvent[1] : '';
				value2InputText.text = (myEvent[2] != null) ? myEvent[2] : '';
			}
		}
		else selectedEventText.visible = false;
	}

	function createGrids()
	{
		var destroyed:Bool = false;
		var stripes:Array<Int> = null;
		if(prevGridBg != null)
		{
			stripes = prevGridBg.stripes;
			remove(prevGridBg);
			remove(gridBg);
			remove(nextGridBg);
			prevGridBg = FlxDestroyUtil.destroy(prevGridBg);
			gridBg = FlxDestroyUtil.destroy(gridBg);
			nextGridBg = FlxDestroyUtil.destroy(nextGridBg);
			destroyed = true;
		}

		var columnCount:Int = (GRID_COLUMNS_PER_PLAYER * GRID_PLAYERS) + (SHOW_EVENT_COLUMN ? 1 : 0);
		gridBg = new ChartingGridSprite(columnCount, gridColors[0], gridColors[1]);
		gridBg.screenCenter(X);

		prevGridBg = new ChartingGridSprite(columnCount, gridColorsOther[0], gridColorsOther[1]);
		nextGridBg = new ChartingGridSprite(columnCount, gridColorsOther[0], gridColorsOther[1]);
		prevGridBg.x = nextGridBg.x = gridBg.x;
		prevGridBg.stripes = nextGridBg.stripes = gridBg.stripes = stripes;
		
		if(destroyed)
		{
			insert(getFirstNull(), prevGridBg);
			insert(getFirstNull(), nextGridBg);
			insert(getFirstNull(), gridBg);
			loadSection();
		}
		else
		{
			add(prevGridBg);
			add(nextGridBg);
			add(gridBg);
		}
	}

	var cachedSectionRow:Array<Int>;
	var cachedSectionTimes:Array<Float>;
	var cachedSectionCrochets:Array<Float>;
	var cachedSectionBPMs:Array<Float>;
	function loadChart(song:SwagSong)
	{
		PlayState.SONG = song;
		StageData.loadDirectory(PlayState.SONG);
		Conductor.bpm = PlayState.SONG.bpm;
	}

	function loadMusic(?killAudio:Bool = false)
	{
		setSongPlaying(false);
		var time:Float = Conductor.songPosition;

		if(killAudio)
		{
			var sndsToKill:Array<String> = [];
			for (key => snd in Paths.currentTrackedSounds)
			{
				//trace(key, snd);
				if(key.contains('/songs/${Paths.formatToSongPath(PlayState.SONG.song)}/') && snd != null)
				{
					sndsToKill.push(key);
					snd.close();
				}
			}

			for (key in sndsToKill)
			{
				Assets.cache.clear(key);
				Paths.currentTrackedSounds.remove(key);
				Paths.localTrackedAssets.remove(key);
			}
		}

		try
		{
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0);
			FlxG.sound.music.pause();
			FlxG.sound.music.time = time;
			FlxG.sound.music.onComplete = (function() songFinished = true);
		}
		catch(e:Exception)
		{
			FlxG.log.error('Error loading song: $e');
			return;
		}

		@:privateAccess vocals.cleanup(true);
		@:privateAccess opponentVocals.cleanup(true);
		if (PlayState.SONG.needsVoices)
		{
			try
			{
				var playerVocals:Sound = Paths.voices(PlayState.SONG.song, (characterData.vocalsP1 == null || characterData.vocalsP1.length < 1) ? 'Player' : characterData.vocalsP1);
				vocals.loadEmbedded(playerVocals != null ? playerVocals : Paths.voices(PlayState.SONG.song));
				vocals.volume = 0;
				vocals.play();
				vocals.pause();
				vocals.time = time;
				
				var oppVocals:Sound = Paths.voices(PlayState.SONG.song, (characterData.vocalsP2 == null || characterData.vocalsP2.length < 1) ? 'Opponent' : characterData.vocalsP2);
				if(oppVocals != null && oppVocals.length > 0)
				{
					opponentVocals.loadEmbedded(oppVocals);
					opponentVocals.volume = 0;
					opponentVocals.play();
					opponentVocals.pause();
					opponentVocals.time = time;
				}
			}
			catch (e:Dynamic) {}
		}
		
		updatePresence();
		updateAudioVolume();
		updateWaveform();
		setPitch();
		_cacheSections();
	}
	
	function updatePresence() {
		#if DISCORD_ALLOWED
		var songName:String = (PlayState.SONG != null && PlayState.SONG.song != null) ? PlayState.SONG.song : 'Unknown';

		var noteCount:Int = 0;
		var sustainCount:Int = 0;
		var eventsCount:Int = 0;

		if (PlayState.SONG != null)
		{
			// Count notes and sustains from sections (modern psych format)
			if (PlayState.SONG.notes != null)
			{
				for (section in PlayState.SONG.notes)
				{
					if (section == null || section.sectionNotes == null) continue;
					for (noteArr in section.sectionNotes)
					{
						if (noteArr == null) continue;
						// If a sustain length exists (noteArr[2]) and is > 0, count it as a sustain
						var sustainVal:Float = 0;
						if (noteArr.length > 2 && noteArr[2] != null) {
							// cast might be Int or Float, cast to Float for safe comparison
							sustainVal = cast(noteArr[2], Float);
						}
						if (sustainVal > 0) sustainCount++;
						else noteCount++;
					}
				}
			}

			// Count events if present
			if (PlayState.SONG.events != null) eventsCount = PlayState.SONG.events.length;
		}

		var total:Int = noteCount + sustainCount; // events are intentionally not included
		var detail:String = 'Song: ' + songName + '  —  Notes: ' + Std.string(noteCount) + '  Sustains: ' + Std.string(sustainCount) + '  Events: ' + Std.string(eventsCount) + '  Total: ' + Std.string(total);

		DiscordClient.changePresence('Chart Editor', detail);
		#end
	}

	function onSongComplete()
	{
		trace('song completed');
		setSongPlaying(false);
		Conductor.songPosition = FlxG.sound.music.time = vocals.time = opponentVocals.time = FlxG.sound.music.length - 1;
		curSec = PlayState.SONG.notes.length - 1;
		forceDataUpdate = true;
	}

	function updateAudioVolume()
	{
		FlxG.sound.music.volume = instVolumeStepper.value;
		vocals.volume = playerVolumeStepper.value;
		opponentVocals.volume = opponentVolumeStepper.value;
		if(instMuteCheckBox.checked) FlxG.sound.music.volume = 0;
		if(playerMuteCheckBox.checked) vocals.volume = 0;
		if(opponentMuteCheckBox.checked) opponentVocals.volume = 0;
	}

	var playbackRate:Float = 1;
	function setPitch(?value:Null<Float>)
	{
		#if FLX_PITCH
		if(value == null) value = playbackRate;
		FlxG.sound.music.pitch = value;
		vocals.pitch = value;
		opponentVocals.pitch = value;
		#end
	}

	function setSongPlaying(doPlay:Bool)
	{
		if(FlxG.sound.music == null) return;
		
		forceDataUpdate = true;
		vocals.time = FlxG.sound.music.time;
		opponentVocals.time = FlxG.sound.music.time;

		if(doPlay)
		{
			FlxG.sound.music.play();
			if(FlxG.sound.music.time < vocals.length) vocals.play(true, FlxG.sound.music.time);
			if(FlxG.sound.music.time < opponentVocals.length) opponentVocals.play(true, FlxG.sound.music.time);
			updateAudioVolume();
		}
		else
		{
			FlxG.sound.music.pause();
			vocals.pause();
			opponentVocals.pause();
			resetBuddies(); // makes lil buddies stand up straight FUCGGGGGGGGGGGHKKKKKKED!!!!!!!!
		}

		for (note in strumLineNotes)
		{
			note.alpha = doPlay ? 1 : 0.4;
			if(!doPlay)
			{
				note.playAnim('static');
				note.resetAnim = 0;
			}
		}
	}

	function reloadNotes()
	{
		selectedNotes = [];
		for (note in notes) if(note != null) note.destroy();
		for (event in events) if(event != null) event.destroy();
		notes = [];
		events = [];
		undoActions = [];

		for (secNum => section in PlayState.SONG.notes)
			for (note in section.sectionNotes)
				if(note != null)
					notes.push(createNote(note, secNum));

		for (eventNum => event in PlayState.SONG.events)
			if(event != null && (cachedSectionTimes.length < 1 || event[0] < cachedSectionTimes[cachedSectionTimes.length-1])) //dont spawn events over the time limit
				events.push(createEvent(event));

		notes.sort(PlayState.sortByTime);
		events.sort(PlayState.sortByTime);

		trace('Note count: ${notes.length}');
		trace('Events count: ${events.length}');
		scrollDirectionUpdated();
	}

	function createNote(note:Dynamic, ?secNum:Null<Int> = null)
	{
		if(secNum == null) secNum = curSec;
		var section = PlayState.SONG.notes[secNum];

		var daStrumTime:Float = note[0];
		var daNoteData:Int = Std.int(note[1] % GRID_COLUMNS_PER_PLAYER);
		var gottaHitNote:Bool = (note[1] < GRID_COLUMNS_PER_PLAYER);

		var swagNote:MetaNote = new MetaNote(daStrumTime, daNoteData, note, this);
		// if (secNum != null) swagNote.section = secNum;
		swagNote.mustPress = gottaHitNote;
		swagNote.setSustainLength(note[2], curZoom);
		swagNote.useBlandSustains = !texturedSustains;
		swagNote.noteType = note[3];
		swagNote.scrollFactor.x = 0;

		swagNote.updateHitbox();
		if(swagNote.width > swagNote.height)
			swagNote.setGraphicSize(GRID_SIZE);
		else
			swagNote.setGraphicSize(0, GRID_SIZE);

		swagNote.updateHitbox();
		swagNote.active = false;
		positionNoteXByData(swagNote);
		positionNoteYOnTime(swagNote);
		return swagNote;
	}

	function createEvent(event:Dynamic)
	{
		var daStrumTime:Float = event[0];
		var swagEvent:EventMetaNote = new EventMetaNote(daStrumTime, event, this);
		swagEvent.scrollFactor.x = 0;
		swagEvent.x = gridBg.x;
		
		positionNoteYOnTime(swagEvent);
		return swagEvent;
	}

	function _cacheSections()
	{
		var time:Float = 0;
		var row:Int = 0;
		cachedSectionRow = [];
		cachedSectionTimes = [];
		cachedSectionCrochets = [];
		cachedSectionBPMs = [];
		Conductor.mapBPMChanges(PlayState.SONG);

		if(PlayState.SONG == null)
		{
			cachedSectionRow.push(0);
			cachedSectionTimes.push(0);
			cachedSectionCrochets.push(0);
			cachedSectionBPMs.push(0);
			return;
		}

		var bpm:Float = PlayState.SONG.bpm;
		var reachedLimit:Bool = false;
		for (secNum => section in PlayState.SONG.notes)
		{
			var secs:Null<Float> = cast section.sectionBeats;
			if(secs == null || Math.isNaN(secs) || secs <= 0) section.sectionBeats = 4;
	
			if(section.changeBPM) bpm = section.bpm;
			var beat:Float = Conductor.calculateCrochet(bpm);
			//trace(secBPM, beat);
			
			cachedSectionRow.push(row);
			cachedSectionTimes.push(time);
			cachedSectionCrochets.push(beat);
			cachedSectionBPMs.push(bpm);

			var lastTime:Float = time;
			var rowRound:Int = Math.round(4 * section.sectionBeats);
			row += rowRound;
			time += beat * (rowRound / 4);

			for (note in section.sectionNotes)
			{
				if(secNum > 0 && note[0] < lastTime) note[0] = lastTime;
				else if(secNum < PlayState.SONG.notes.length && note[0] >= time - 0.000001) note[0] = time - 0.000001;
			}

			if(FlxG.sound.music != null && time >= FlxG.sound.music.length)
			{
				var lastSectionNum:Int = PlayState.SONG.notes.length - 1;
				if(secNum < lastSectionNum) //Delete extra sections
				{
					while(PlayState.SONG.notes.length - 1 > secNum)
					{
						PlayState.SONG.notes.pop();
					}
	
					trace('breaking at section $secNum');
					reachedLimit = true;
					break;
				}
				else if(secNum == lastSectionNum)
				{
					trace('reached limit at section $secNum');
					reachedLimit = true;
				}
			}
		}

		if(FlxG.sound.music != null && !reachedLimit) //Created sections to fill blank space
		{
			var lastSection = PlayState.SONG.notes[PlayState.SONG.notes.length-1];
			var beat:Float = Conductor.calculateCrochet(bpm);
			var sectionBeats:Float = lastSection != null ? lastSection.sectionBeats : 4;
			var lengthInSteps:Int = 16; // legacy chart support
			var rowRound:Int = Math.round(4 * sectionBeats);
			var timeAdd:Float = beat * (rowRound / 4);
			var mustHitSec:Bool = lastSection != null ? lastSection.mustHitSection : true;
			var changeBpmSec:Bool = lastSection != null ? lastSection.changeBPM : false;
			var altAnimSec:Bool = lastSection != null ? lastSection.altAnim : false;
			var gfSec:Bool = lastSection != null ? lastSection.gfSection : false;

			while(!reachedLimit)
			{
				PlayState.SONG.notes.push({
					sectionNotes: [],
					sectionBeats: sectionBeats,
					// lengthInSteps: lengthInSteps,
					mustHitSection: mustHitSec,
					bpm: bpm,
					changeBPM: changeBpmSec,
					altAnim: altAnimSec,
					gfSection: gfSec
				});

				cachedSectionRow.push(row);
				cachedSectionTimes.push(time);
				cachedSectionCrochets.push(beat);
				cachedSectionBPMs.push(bpm);

				row += rowRound;
				time += timeAdd;

				if(time >= FlxG.sound.music.length)
				{
					trace('created sections until ${PlayState.SONG.notes.length-1}');
					reachedLimit = true;
				}
			}
		}
		cachedSectionRow.push(row);
		cachedSectionTimes.push(time);
	}

	var showPreviousSection:Bool = true;
	var showNextSection:Bool = true;
	var showNoteTypeLabels:Bool = true;
	var forceDataUpdate:Bool = true;
	function scrollDirectionUpdated() {
		timeLine.y = (FlxG.height + (downScroll ? GRID_SIZE : -GRID_SIZE) - timeLine.height) * .5;
		gridBg.flipY = prevGridBg.flipY = nextGridBg.flipY = waveformSprite.flipY = downScroll;
		
		loadSection();
	}
	function loadSection(?sec:Null<Int> = null)
	{
		if(sec != null) curSec = sec;
		curSec = Std.int(FlxMath.bound(curSec, 0, PlayState.SONG.notes.length-1));
		Conductor.bpm = cachedSectionBPMs[curSec];
		
		var downScrollMult:Int = (downScroll ? -1 : 1);
		if(curSec > 0)
		{
			prevGridBg.y = cachedSectionRow[curSec-1] * GRID_SIZE * curZoom * downScrollMult;
			prevGridBg.rows = 4 * PlayState.SONG.notes[curSec-1].sectionBeats * curZoom;
			prevGridBg.visible = showPreviousSection;
		}
		else prevGridBg.visible = false;

		if(curSec < PlayState.SONG.notes.length - 1)
		{
			nextGridBg.y = cachedSectionRow[curSec+1] * GRID_SIZE * curZoom * downScrollMult;
			nextGridBg.rows = 4 * PlayState.SONG.notes[curSec+1].sectionBeats * curZoom;
			nextGridBg.visible = showNextSection;
		}
		else nextGridBg.visible = false;
		
		gridBg.y = cachedSectionRow[curSec] * GRID_SIZE * curZoom * downScrollMult;
		gridBg.rows = 4 * PlayState.SONG.notes[curSec].sectionBeats * curZoom;
		eventLockOverlay.y = gridBg.y;
		
		var hei:Float = 0;
		for (grid in [prevGridBg, nextGridBg, gridBg]) {
			if (downScroll)
				grid.y -= grid.height;
			
			grid.updateStripes();
			
			if (grid.visible) {
				hei += grid.height;
				eventLockOverlay.y = Math.min(eventLockOverlay.y, grid.y);
			}
		}
		
		eventLockOverlay.scale.y = hei;
		eventLockOverlay.updateHitbox();

		softReloadNotes();
		updateHeads();
		
		forEachRenderedNote((note:MetaNote) -> refreshNotePosition(note));

		var sec = getCurChartSection();
		if(sec != null)
		{
			mustHitCheckBox.checked = sec.mustHitSection;
			gfSectionCheckBox.checked = sec.gfSection;
			// altAnimSectionCheckBox.checked = sec.altAnim;
			changeBpmCheckBox.checked = sec.changeBPM;
			changeBpmStepper.value = Conductor.bpm;
			beatsPerSecStepper.value = sec.sectionBeats;

			strumTimeStepper.step = Conductor.stepCrochet;
			susLengthStepper.step = cachedSectionCrochets[curSec] / 4 / 2;
			susLengthStepper.max = susLengthStepper.step * 128;
			if(selectedNotes.length > 1) susLengthStepper.min = -susLengthStepper.max;
			else susLengthStepper.min = 0;
		}
		prevGridBg.vortexLineEnabled = gridBg.vortexLineEnabled = nextGridBg.vortexLineEnabled = vortexEnabled;
		prevGridBg.vortexLineSpace = gridBg.vortexLineSpace = nextGridBg.vortexLineSpace = GRID_SIZE * 4 * curZoom;
		updateWaveform();
		updateScrollY();
	}

	function softReloadNotes(onlyCurrent:Bool = false)
	{
		if(!onlyCurrent) behindRenderedNotes.clear();
		curRenderedNotes.clear();

		var minTime:Float = getMinNoteTime(curSec);
		var maxTime:Float = getMaxNoteTime(curSec);
		function curSecFilter(note:MetaNote)
		{
			var timeAdjusted:Float = (note.strumTime + 3);
			return (timeAdjusted >= minTime && timeAdjusted < maxTime);
		}

		var firstNote:Bool = false;
		var firstEvent:Bool = false;
		sectionFirstNoteID = 0;
		sectionFirstEventID = 0;
		for (num => note in notes)
		{
			if(note != null && curSecFilter(note))
			{
				if(!firstNote) sectionFirstNoteID = num;
				curRenderedNotes.add(note);
				note.noteType = note.noteType;
				note.alpha = (Conductor.songPosition - 1 > note.strumTime) ? .6 : 1;
				if(note.hasSustain) note.updateSustainToZoom(curZoom);
			}
		}

		if(SHOW_EVENT_COLUMN)
		{
			for (num => event in events)
			{
				if(event != null && curSecFilter(event))
				{
					if(!firstEvent) sectionFirstEventID = num;
					curRenderedNotes.add(event);
					event.alpha = (Conductor.songPosition - 1 > event.strumTime) ? .6 : 1;
				}
			}
		}

		if(!onlyCurrent)
		{
			if(showPreviousSection || showNextSection)
			{
				var prevMinTime:Float = getMinNoteTime(curSec-1);
				var prevMaxTime:Float = getMaxNoteTime(curSec-1);
				var nextMinTime:Float = getMinNoteTime(curSec+1);
				var nextMaxTime:Float = getMaxNoteTime(curSec+1);
				function otherSecFilter(note:MetaNote)
				{
					var timeAdjusted:Float = (note.strumTime + 3);
					return (prevGridBg.visible && (timeAdjusted >= prevMinTime && timeAdjusted < prevMaxTime)) ||
						(nextGridBg.visible && (timeAdjusted >= nextMinTime && timeAdjusted < nextMaxTime));
				}
	
				for(note in notes.filter(otherSecFilter))
				{
					behindRenderedNotes.add(note);
					note.alpha = 0.4;
					if(note.hasSustain) note.updateSustainToZoom(curZoom);
				}

				if(SHOW_EVENT_COLUMN)
				{
					for(event in events.filter(otherSecFilter))
					{
						behindRenderedNotes.add(event);
						event.alpha = 0.4;
					}
				}
			}
		}
	}

	function getMinNoteTime(sec:Int)
	{
		var minTime:Float = Math.NEGATIVE_INFINITY;
		if(sec > 0)
			minTime = cachedSectionTimes[sec];
		return minTime;
	}

	function getMaxNoteTime(sec:Int)
	{
		var maxTime:Float = Math.POSITIVE_INFINITY;
		if(sec < cachedSectionTimes.length)
			maxTime = cachedSectionTimes[sec + 1];
		return maxTime;
	}

	function positionNoteXByData(note:MetaNote, ?data:Null<Int> = null)
	{
		if(data == null) data = note.songData[1];

		var noteX:Float = gridBg.x + (GRID_SIZE - note.width) / 2;
		if(SHOW_EVENT_COLUMN) noteX += GRID_SIZE;

		noteX += GRID_SIZE * data;
		note.x = noteX;
		//trace(gridBg.x, noteX);
	}
	
	function forEachRenderedNote(func:MetaNote -> Void) {
		for (grp in [curRenderedNotes, behindRenderedNotes]) {
			for (note in grp)
				func(note);
		}
	}
	function positionNoteYOnTime(note:MetaNote) {
		var noteY:Float = Conductor.getStep(note.strumTime);
		noteY = Math.max(noteY, -150);
		note.chartY = noteY;
		refreshNotePosition(note);
	}
	function refreshNotePosition(note:MetaNote) {
		note.y = calculateY(note);
		note.downScroll = downScroll;
	}
	function calculateY(note:MetaNote) {
		var y:Float = note.chartY * GRID_SIZE * curZoom * (downScroll ? -1 : 1) + (GRID_SIZE / 2 - note.height / 2);
		if (downScroll)
			y -= GRID_SIZE;
		return y;
	}

	var characterData:Dynamic = {};
	function updateJsonData():Void
	{
		for (i in 1...GRID_PLAYERS+1)
		{
			//trace('adding iconP$i');
			var data:CharacterFile = loadCharacterFile(Reflect.field(PlayState.SONG, 'player$i'));
			Reflect.setField(characterData, 'iconP$i', data != null && data.healthicon != null ? data.healthicon : 'face');
			Reflect.setField(characterData, 'vocalsP$i', data != null && data.vocals_file != null ? data.vocals_file : '');
		}
	}
	
	var _lastSec:Int = -1;
	var _lastGfSection:Null<Bool> = null;
	function updateHeads(ignoreCheck:Bool = false):Void
	{
		var curSecData:SwagSection = PlayState.SONG.notes[curSec];
		var isGfSection:Bool = (curSecData != null && curSecData.gfSection == true);
		if(_lastGfSection == isGfSection && _lastSec == curSec && !ignoreCheck) return; //optimization

		for (i in 0...GRID_PLAYERS)
		{
			var icon:HealthIcon = icons[i];
			//trace('changing iconP${icon.ID}');
			var iconName:String = Reflect.field(characterData, 'iconP${icon.ID}');
			icon.changeIcon(iconName);
		}

		if(icons.length > 1)
		{
			var iconP1:HealthIcon = icons[0];
			var iconP2:HealthIcon = icons[1];
			var mustHitSection:Bool = (curSecData != null && curSecData.mustHitSection == true);
			if (isGfSection)
			{
				if (mustHitSection)
					iconP1.changeIcon('gf');
				else
					iconP2.changeIcon('gf');
			}

			if(mustHitSection)
				mustHitIndicator.x = iconP1.x + iconP1.width/2;
			else
				mustHitIndicator.x = iconP2.x + iconP2.width/2;
		}
		_lastGfSection = isGfSection;
		_lastSec = curSec;
	}

	var playbackSlider:PsychUISlider;

	var mouseSnapCheckBox:PsychUICheckBox;
	var ignoreProgressCheckBox:PsychUICheckBox;
	var hitsoundPlayerStepper:PsychUINumericStepper;
	var hitsoundOpponentStepper:PsychUINumericStepper;
	var metronomeStepper:PsychUINumericStepper;

	var instVolumeStepper:PsychUINumericStepper;
	var instMuteCheckBox:PsychUICheckBox;
	var playerVolumeStepper:PsychUINumericStepper;
	var playerMuteCheckBox:PsychUICheckBox;
	var opponentVolumeStepper:PsychUINumericStepper;
	var opponentMuteCheckBox:PsychUICheckBox;
	
	var vortexEditorCheckBox:PsychUICheckBox;

	var luaTypeCheckBox:PsychUICheckBox;
	function addMiscTab()
	{
		var tab_group = mainBox.getTab('Misc').menu;
		var objX = 10;
		var objY = 10;

		var txt = new FlxText(objX, objY, 280, "Any options here won't actually affect gameplay!");
		txt.alignment = CENTER;
		tab_group.add(txt);

		objY += 25;
		playbackSlider = new PsychUISlider(50, objY, function(v:Float) setPitch(playbackRate = v), 1, 0.1, 5.0, 200);
		playbackSlider.label = 'Playback Rate';
		
		objY += 60;
		mouseSnapCheckBox = new PsychUICheckBox(objX, objY, 'Mouse Scroll Snap', 100, function() chartEditorSave.data.mouseScrollSnap = mouseSnapCheckBox.checked);
		mouseSnapCheckBox.checked = chartEditorSave.data.mouseScrollSnap;

		ignoreProgressCheckBox = new PsychUICheckBox(objX + 150, objY, 'Ignore Progress Warnings', 100, function() chartEditorSave.data.ignoreProgressWarns = ignoreProgressCheckBox.checked);
		ignoreProgressCheckBox.checked = chartEditorSave.data.ignoreProgressWarns;

		objY += 45;
		metronomeStepper = new PsychUINumericStepper(objX, objY, 0.2, 0, 0, 1, 1);
		hitsoundPlayerStepper = new PsychUINumericStepper(objX + 100, objY, 0.2, 0, 0, 1, 1);
		hitsoundOpponentStepper = new PsychUINumericStepper(objX + 200, objY, 0.2, 0, 0, 1, 1);

		objY += 35;
		instVolumeStepper = new PsychUINumericStepper(objX, objY, 0.1, 1, 0, 1, 1);
		instVolumeStepper.onValueChange = updateAudioVolume;
		playerVolumeStepper = new PsychUINumericStepper(objX + 100, objY, 0.1, 1, 0, 1, 1);
		playerVolumeStepper.onValueChange = updateAudioVolume;
		opponentVolumeStepper = new PsychUINumericStepper(objX + 200, objY, 0.1, 1, 0, 1, 1);
		opponentVolumeStepper.onValueChange = updateAudioVolume;

		objY += 25;
		instMuteCheckBox = new PsychUICheckBox(objX, objY, 'Mute', 60, updateAudioVolume);
		playerMuteCheckBox = new PsychUICheckBox(objX + 100, objY, 'Mute', 60, updateAudioVolume);
		opponentMuteCheckBox = new PsychUICheckBox(objX + 200, objY, 'Mute', 60, updateAudioVolume);

		tab_group.add(playbackSlider);
		tab_group.add(mouseSnapCheckBox);
		tab_group.add(ignoreProgressCheckBox);

		tab_group.add(new FlxText(hitsoundPlayerStepper.x, hitsoundPlayerStepper.y - 13, 100, 'Player Hitsound:'));
		tab_group.add(new FlxText(hitsoundOpponentStepper.x, hitsoundOpponentStepper.y - 13, 100, 'Opp. Hitsound:'));
		tab_group.add(new FlxText(metronomeStepper.x, metronomeStepper.y - 13, 100, 'Metronome:'));
		tab_group.add(hitsoundPlayerStepper);
		tab_group.add(hitsoundOpponentStepper);
		tab_group.add(metronomeStepper);
		
		tab_group.add(new FlxText(instVolumeStepper.x, instVolumeStepper.y - 13, 100, 'Instrumental:'));
		tab_group.add(new FlxText(playerVolumeStepper.x, playerVolumeStepper.y - 13, 100, 'Player Vocals:'));
		tab_group.add(new FlxText(opponentVolumeStepper.x, opponentVolumeStepper.y - 13, 100, 'Opp. Vocals:'));
		tab_group.add(instVolumeStepper);
		tab_group.add(instMuteCheckBox);
		tab_group.add(playerVolumeStepper);
		tab_group.add(playerMuteCheckBox);
		tab_group.add(opponentVolumeStepper);
		tab_group.add(opponentMuteCheckBox);
		
		objY += 32;

		vortexEditorCheckBox = new PsychUICheckBox(objX, objY, 'Vortex Editor', 100, function() {
			vortexEnabled = vortexEditorCheckBox.checked;
			vortexIndicator.visible = strumLineNotes.visible = strumLineNotes.active = vortexEnabled;
			chartEditorSave.data.vortex = vortexEnabled;

			for (note in strumLineNotes) {
				note.playAnim('static');
				note.resetAnim = 0;
			}
			prevGridBg.vortexLineEnabled = gridBg.vortexLineEnabled = nextGridBg.vortexLineEnabled = vortexEnabled;
		});
		vortexEditorCheckBox.checked = vortexEnabled;
		tab_group.add(vortexEditorCheckBox);

		luaTypeCheckBox = new PsychUICheckBox(objX + 150, objY, 'Lua Legacy?', 100, function() {
			luaType = luaTypeCheckBox.checked;
			chartEditorSave.data.luaType = luaType;
			PlayState.SONG.luaType = luaType;
		});
		luaTypeCheckBox.checked = luaType;
		tab_group.add(luaTypeCheckBox);
	}

	var gameOverCharDropDown:PsychUIDropDownMenu;
	var gameOverSndInputText:PsychUIInputText;
	var gameOverLoopInputText:PsychUIInputText;
	var gameOverRetryInputText:PsychUIInputText;
	var noRGBCheckBox:PsychUICheckBox;
	var noteTextureInputText:PsychUIInputText;
	var noteSplashesInputText:PsychUIInputText;
	function addDataTab()
	{
		var tab_group = mainBox.getTab('Data').menu;
		var objX = 10;
		var objY = 25;
		gameOverCharDropDown = new PsychUIDropDownMenu(objX, objY, [''], function(id:Int, character:String)
		{
			PlayState.SONG.gameOverChar = character;
			if(character.length < 1) Reflect.deleteField(PlayState.SONG, 'gameOverChar');
			trace('selected $character');
		});

		objY += 40;
		gameOverSndInputText = new PsychUIInputText(objX, objY, 120, '', 8);
		gameOverSndInputText.onChange = function(old:String, cur:String)
		{
			PlayState.SONG.gameOverSound = cur;
			if(cur.trim().length < 1) Reflect.deleteField(PlayState.SONG, 'gameOverSound');
		}
		objY += 40;
		gameOverLoopInputText = new PsychUIInputText(objX, objY, 120, '', 8);
		gameOverLoopInputText.onChange = function(old:String, cur:String)
		{
			PlayState.SONG.gameOverLoop = cur;
			if(cur.trim().length < 1) Reflect.deleteField(PlayState.SONG, 'gameOverLoop');
		}
		objY += 40;
		gameOverRetryInputText = new PsychUIInputText(objX, objY, 120, '', 8);
		gameOverRetryInputText.onChange = function(old:String, cur:String)
		{
			PlayState.SONG.gameOverEnd = cur;
			if(cur.trim().length < 1) Reflect.deleteField(PlayState.SONG, 'gameOverEnd');
		}

		objY += 35;
		noRGBCheckBox = new PsychUICheckBox(objX, objY, 'Disable Note RGB', 100, updateNotesRGB);
		
		objY += 40;
		noteTextureInputText = new PsychUIInputText(objX, objY, 120, '');
		noteTextureInputText.unfocus = function()
		{
			var changed:Bool = false;
			if(PlayState.SONG.arrowSkin != noteTextureInputText.text) changed = true;
			PlayState.SONG.arrowSkin = noteTextureInputText.text.trim();
			if(PlayState.SONG.arrowSkin.trim().length < 1) PlayState.SONG.arrowSkin = null;

			if(changed)
			{
				var textureLoad:String = noteTextureInputText.text;
				var changedTexture:Bool = false;
				
				for (note in notes) {
					if (note == null) continue;
					
					var oldTexture:String = note.graphic?.key;
					note.texture = textureLoad;
					if (note.graphic?.key == oldTexture) {
						break;
					} else {
						changedTexture = true;
					}
					
					if (note.width > note.height) {
						note.setGraphicSize(GRID_SIZE);
					} else {
						note.setGraphicSize(0, GRID_SIZE);
					}
					
					note.updateHitbox();
					positionNoteXByData(note);
				}
				
				if (changedTexture) {	
					var startX:Float = gridBg.x;
					var startY:Float = (FlxG.height - GRID_SIZE) / 2;
					
					for (i => strum in strumLineNotes.members) {
						if (strum == null) continue;
						var tex:String = noteTextureInputText.text;
						if (tex.trim() == '') { // ok
							tex = Note.defaultNoteSkin;
							var customSkin:String = tex + Note.getNoteSkinPostfix();
							if (Paths.fileExists('images/$customSkin.png', IMAGE)) tex = customSkin;
						}
						strum.texture = tex;
						
						if(strum.width > strum.height)
							strum.setGraphicSize(GRID_SIZE);
						else
							strum.setGraphicSize(0, GRID_SIZE);
						
						strum.playAnim('static');
						strum.updateHitbox();
						
						strum.x = startX + (i * GRID_SIZE) + (GRID_SIZE - strum.width) / 2;
						strum.y = startY + (GRID_SIZE - strum.height) / 2;
						if (SHOW_EVENT_COLUMN) strum.x += GRID_SIZE;
					}
					if(noteTextureInputText.text.trim().length > 0) showOutput('Reloaded notes to: "$textureLoad"');
					else showOutput('Reloaded notes to default texture');
					
				}
				else showOutput('ERROR: "$textureLoad" not found.', true);
			}
		};

		noteSplashesInputText = new PsychUIInputText(objX + 140, objY, 120, '');
		noteSplashesInputText.onChange = function(old:String, cur:String)
		{
			PlayState.SONG.splashSkin = cur;
			if(cur.trim().length < 1) PlayState.SONG.splashSkin = null;
		}
	
		tab_group.add(new FlxText(gameOverCharDropDown.x, gameOverCharDropDown.y - 15, 120, 'Game Over Character:'));
		tab_group.add(new FlxText(gameOverSndInputText.x, gameOverSndInputText.y - 15, 180, 'Game Over Death Sound (sounds/):'));
		tab_group.add(new FlxText(gameOverLoopInputText.x, gameOverLoopInputText.y - 15, 180, 'Game Over Loop Music (music/):'));
		tab_group.add(new FlxText(gameOverRetryInputText.x, gameOverRetryInputText.y - 15, 180, 'Game Over Retry Music (music/):'));
		tab_group.add(gameOverSndInputText);
		tab_group.add(gameOverLoopInputText);
		tab_group.add(gameOverRetryInputText);
		tab_group.add(noRGBCheckBox);

		tab_group.add(new FlxText(noteTextureInputText.x, noteTextureInputText.y - 15, 100, 'Note Texture:'));
		tab_group.add(new FlxText(noteSplashesInputText.x, noteSplashesInputText.y - 15, 120, 'Note Splashes Texture:'));
		tab_group.add(noteTextureInputText);
		tab_group.add(noteSplashesInputText);

		tab_group.add(gameOverCharDropDown); //lowest priority to display properly
	}

	var eventDropDown:PsychUIDropDownMenu;
	var value1InputText:PsychUIInputText;
	var value2InputText:PsychUIInputText;
	var selectedEventText:FlxText;
	var eventDescriptionText:FlxText;

	var eventsList:Array<Array<String>>;
	var curEventSelected:Int = 0;
	function addEventsTab()
	{
		var tab_group = mainBox.getTab('Events').menu;
		var objX = 10;
		var objY = 25;

		eventDropDown = new PsychUIDropDownMenu(objX, objY, [], function(id:Int, character:String)
		{
			var eventSelected:Array<String> = eventsList[id];
			var eventName:String = eventSelected[0];
			var description:String = eventSelected[1];
			eventDescriptionText.text = description;
			if(selectedNotes.length > 1)
			{
				for (note in selectedNotes)
				{
					if(note == null || !note.isEvent) continue;

					var event:EventMetaNote = cast (note, EventMetaNote);
					event.events[event.events.length - 1][0] = eventName;
					event.updateEventInfo();
				}
			}
			else if(selectedNotes.length == 1 && selectedNotes[0].isEvent)
			{
				var event:EventMetaNote = cast (selectedNotes[0], EventMetaNote);
				event.events[Std.int(FlxMath.bound(curEventSelected, 0, event.events.length - 1))][0] = eventName;
				event.updateEventInfo();
			}
		});

		function genericEventButton(func:EventMetaNote->Void)
		{
			if(selectedNotes.length == 1)
			{
				if(selectedNotes[0].isEvent)
				{
					var event:EventMetaNote = cast (selectedNotes[0], EventMetaNote);
					func(event);
					updateSelectedEventText(); // ironically, with the rebuild by Inky, this wasn't even here. Screw you inky i'm better mwahahha!!!
				}
				else showOutput('Note selected must be an Event!', true);
			}
			else showOutput('You must select a single event to press this button.', true);
		}

		var objX2 = 140;
		var removeButton:PsychUIButton = new PsychUIButton(objX2, objY, '-', function()
		{
			genericEventButton(function(event:EventMetaNote)
			{
				if(event.events.length > 1)
				{
					var selectedEvent = event.events[curEventSelected];
					if(selectedEvent != null)
					{
						event.events.remove(selectedEvent);
						event.updateEventInfo();
						curEventSelected--;
					}
					else showOutput('No event is selected when you deleted it?? Weird.', true);
				}
				else
				{
					selectedNotes.remove(event);
					events.remove(event);
					curRenderedNotes.remove(event, true);
					addUndoAction(DELETE_NOTE, {events: [event]});
				}
			});
		}, 20);
		var addButton:PsychUIButton = new PsychUIButton(objX2 + 30, objY, '+', function()
		{
			genericEventButton(function(event:EventMetaNote)
			{
				event.events.push([eventsList[Std.int(Math.max(eventDropDown.selectedIndex, 0))][0], value1InputText.text, value2InputText.text]);
				event.updateEventInfo();
				curEventSelected++;
			});
		}, 20);
		var leftButton:PsychUIButton = new PsychUIButton(objX2 + 80, objY, '<', function()
		{
			genericEventButton(function(event:EventMetaNote) curEventSelected = FlxMath.wrap(curEventSelected - 1, 0, event.events.length - 1));
		}, 20);
		var rightButton:PsychUIButton = new PsychUIButton(objX2 + 110, objY, '>', function()
		{
			genericEventButton(function(event:EventMetaNote) curEventSelected = FlxMath.wrap(curEventSelected + 1, 0, event.events.length - 1));
		}, 20);
		removeButton.normalStyle.bgColor = FlxColor.RED;
		removeButton.normalStyle.textColor = FlxColor.WHITE;
		addButton.normalStyle.bgColor = FlxColor.GREEN;
		addButton.normalStyle.textColor = FlxColor.WHITE;

		selectedEventText = new FlxText(150, objY + 30, 150, '');
		selectedEventText.visible = false;

		function changeEventsValue(str:String, n:Int)
		{
			if(selectedNotes.length > 1)
			{
				for (note in selectedNotes)
				{
					if(note == null || !note.isEvent) continue;

					var event:EventMetaNote = cast (note, EventMetaNote);
					event.events[event.events.length - 1][n] = str;
					event.updateEventInfo();
				}
			}
			else if(selectedNotes.length == 1 && selectedNotes[0].isEvent)
			{
				var event:EventMetaNote = cast (selectedNotes[0], EventMetaNote);
				event.events[Std.int(FlxMath.bound(curEventSelected, 0, event.events.length - 1))][n] = str;
				event.updateEventInfo();
			}
		}

		objY += 70;
		value1InputText = new PsychUIInputText(objX, objY, 120, '', 8);
		value1InputText.onChange = function(old:String, cur:String) changeEventsValue(cur, 1);
		value2InputText = new PsychUIInputText(objX + 150, objY, 120, '', 8);
		value2InputText.onChange = function(old:String, cur:String) changeEventsValue(cur, 2);

		objY += 40;
		eventDescriptionText = new FlxText(objX, objY, 280, defaultEvents[0][1]);

		tab_group.add(new FlxText(eventDropDown.x, eventDropDown.y - 15, 80, 'Event:'));
		tab_group.add(new FlxText(value1InputText.x, value1InputText.y - 15, 80, 'Value 1:'));
		tab_group.add(new FlxText(value2InputText.x, value2InputText.y - 15, 80, 'Value 2:'));

		tab_group.add(removeButton);
		tab_group.add(addButton);
		tab_group.add(leftButton);
		tab_group.add(rightButton);
		tab_group.add(selectedEventText);

		tab_group.add(value1InputText);
		tab_group.add(value2InputText);
		tab_group.add(eventDescriptionText);
		
		tab_group.add(eventDropDown); //lowest priority to display properly
	}

	var susLengthLastVal:Float = 0; //used for multiple notes selected
	var susLengthStepper:PsychUINumericStepper;
	var strumTimeStepper:PsychUINumericStepper;
	var noteTypeDropDown:PsychUIDropDownMenu;
	public var noteTypes:Array<String>; // just incase someone wants to do something with chart editor notetypes outside of the chart editor, using it from the chart editor.
	function addNoteTab()
	{
		var tab_group = mainBox.getTab('Note').menu;
		var objX = 10;
		var objY = 25;

		susLengthStepper = new PsychUINumericStepper(objX, objY, Conductor.stepCrochet / 2, 0, 0, Conductor.stepCrochet * 128, 1, 80);
		susLengthStepper.onValueChange = function()
		{
			var halfStep:Float = (Conductor.stepCrochet / 2);
			trace(halfStep, susLengthStepper.value);
			var val:Float = Math.round(susLengthStepper.value / halfStep) * halfStep;
			susLengthStepper.value = val;
			if(susLengthLastVal != susLengthStepper.value)
			{
				if(selectedNotes.length > 1)
				{
					for (note in selectedNotes)
					{
						if(note == null && !note.isEvent) continue;
						note.setSustainLength(note.sustainLength + (susLengthStepper.value - susLengthLastVal), curZoom);
					}
				}
				else if(selectedNotes.length == 1) selectedNotes[0].setSustainLength(susLengthStepper.value, curZoom);
				susLengthLastVal = susLengthStepper.value;
			}
		};

		objY += 40;
		strumTimeStepper = new PsychUINumericStepper(objX, objY, Conductor.stepCrochet, 0, -5000, Math.POSITIVE_INFINITY, 3, 120);
		strumTimeStepper.onValueChange = function()
		{
			if(selectedNotes.length < 1) return;

			var firstTime:Float = selectedNotes[0].strumTime;
			for (note in selectedNotes)
			{
				if(note == null) continue;

				note.setStrumTime(Math.max(-5000, strumTimeStepper.value + (note.strumTime - firstTime)));
				positionNoteYOnTime(note);

				if(note.isEvent)
				{
					cast (note, EventMetaNote).updateEventInfo();
				}
			}
			softReloadNotes();
		};
		
		objY += 40;
		noteTypeDropDown = new PsychUIDropDownMenu(objX, objY, [], function(id:Int, changeToType:String)
		{
			var newSelected:Array<MetaNote> = [];
			var typeSelected:String = noteTypes[id].trim();
			for (note in selectedNotes)
			{
				if(note == null || note.isEvent) continue;

				if(typeSelected != null && typeSelected.length > 0) {
					note.noteType = typeSelected;
				} else {
					note.songData.remove(note.songData[3]);
				}
				
				var id:Int = notes.indexOf(note);
				if (id > -1) {
					notes[id] = createNote(note.songData, curSec);
					actionReplaceNotes(note, notes[id]);
					newSelected.push(notes[id]);
					note.destroy();
				}
			}
			selectedNotes = newSelected;
			softReloadNotes();
		}, 150);
		
		tab_group.add(new FlxText(susLengthStepper.x, susLengthStepper.y - 15, 80, 'Sustain length:'));
		tab_group.add(new FlxText(strumTimeStepper.x, strumTimeStepper.y - 15, 100, 'Note Hit time (ms):'));
		tab_group.add(new FlxText(noteTypeDropDown.x, noteTypeDropDown.y - 15, 80, 'Note Type:'));
		tab_group.add(susLengthStepper);
		tab_group.add(strumTimeStepper);
		tab_group.add(noteTypeDropDown);
	}

	var mustHitCheckBox:PsychUICheckBox;
	var gfSectionCheckBox:PsychUICheckBox;
	// var altAnimSectionCheckBox:PsychUICheckBox;

	var changeBpmCheckBox:PsychUICheckBox;
	var changeBpmStepper:PsychUINumericStepper;
	var beatsPerSecStepper:PsychUINumericStepper;

	function addSectionTab()
	{
		var affectNotes:PsychUICheckBox = null;
		var affectEvents:PsychUICheckBox = null;
		var copyLastSecStepper:PsychUINumericStepper = null;
		var tab_group = mainBox.getTab('Section').menu;
		var objX = 10;
		var objY = 10;
		function copyNotesOnSection(?secOff:Int = 0, ?showMessage:Bool = true) //Used on "Copy Section" and "Copy Last Section" buttons
		{
			var curSectionTime:Null<Float> = cachedSectionTimes[curSec - secOff];
			if (curSectionTime == null) {
				//showOutput('ERROR: Unknown section??', true);
				return;
			}
			
			var nextSectionTime:Null<Float> = cachedSectionTimes[curSec - secOff + 1];
			if (nextSectionTime == null) Math.POSITIVE_INFINITY;
			
			var sectionStep:Float = Conductor.getStep(curSectionTime);
			var notesCopyNum:Int = 0;
			if(affectNotes.checked)
			{
				copiedNotes = [];
				for (note in notes)
				{
					if(note.strumTime >= curSectionTime && note.strumTime < nextSectionTime)
					{
						var dataCopy:Array<Dynamic> = makeNoteDataCopy(note.songData, false);
						
						var noteStep:Float = Conductor.getStep(note.strumTime);
						dataCopy[2] = Conductor.getStep(note.strumTime + note.sustainLength) - noteStep;
						dataCopy[0] = noteStep - sectionStep;
						
						copiedNotes.push(dataCopy);
						notesCopyNum++;
					}
				}
			}

			var eventsCopyNum:Int = 0;
			if(affectEvents.checked)
			{
				copiedEvents = [];
				for (event in events)
				{
					if(event.strumTime >= curSectionTime && event.strumTime < nextSectionTime)
					{
						var dataCopy:Array<Dynamic> = makeNoteDataCopy(event.songData, true);
						dataCopy[0] = Conductor.getStep(event.strumTime) - sectionStep;
						copiedEvents.push(dataCopy);
						eventsCopyNum++;
					}
				}
			}

			if(showMessage)
			{
				if(notesCopyNum == 0 && eventsCopyNum == 0)
				{
					showOutput('Nothing to copy!', true);
					return;
				}

				var str:String = '';
				if(notesCopyNum > 0) str += 'Notes Copied: $notesCopyNum';
				if(eventsCopyNum > 0)
				{
					if(str.length > 0) str += '\n';
					str += 'Events Copied: $eventsCopyNum';
				}
	
				if(str.length > 0) showOutput(str);
			}
		}

		mustHitCheckBox = new PsychUICheckBox(objX, objY, 'Focus on Player', 100, function()
		{
			var sec = getCurChartSection();
			if(sec != null) sec.mustHitSection = mustHitCheckBox.checked;
			updateHeads(true);
		});
		objY += 20;
		gfSectionCheckBox = new PsychUICheckBox(objX, objY, 'Girlfriend Sings', 100, function()
		{
			var sec = getCurChartSection();
			if(sec != null) sec.gfSection = gfSectionCheckBox.checked;
			updateHeads(true);
		});
		/*altAnimSectionCheckBox = new PsychUICheckBox(objX + 200, objY, 'Alt Anim.', 80, function()
		{
			var sec = getCurChartSection();
			if(sec != null) sec.altAnim = altAnimSectionCheckBox.checked;
		});*/

		objY += 40;
		changeBpmStepper = new PsychUINumericStepper(objX + 40, objY, 1, 0, 1, 400, 3);
		changeBpmStepper.onValueChange = function() {
			var sec = getCurChartSection();
			if (sec != null) {
				var oldBPMMap:Array<BPMChangeEvent> = Conductor.copyBPMChanges();
				sec.changeBPM = true;
				sec.bpm = changeBpmStepper.value;
				changeBpmCheckBox.checked = true;
				adaptNotes(oldBPMMap);
			}
		};
		
		changeBpmCheckBox = new PsychUICheckBox(changeBpmStepper.x + 72, objY, 'Change?', 80, function() {
			var sec = getCurChartSection();
			if(sec != null) {
				var oldBPMMap:Array<BPMChangeEvent> = Conductor.copyBPMChanges();
				sec.changeBPM = changeBpmCheckBox.checked;
				if(!Reflect.hasField(sec, 'bpm')) sec.bpm = changeBpmStepper.value;
				adaptNotes(oldBPMMap);
			}
		});

		objY += 20;
		beatsPerSecStepper = new PsychUINumericStepper(changeBpmStepper.x, objY, 1, 4, 0, 16, 2); // 16 beats for what exactly? god kms.
		beatsPerSecStepper.onValueChange = function() {
			beatsPerSecStepper.value = Math.round(beatsPerSecStepper.value * 4) / 4;
			var sec = getCurChartSection();
			if (sec != null) {
				var oldBPMMap:Array<BPMChangeEvent> = Conductor.copyBPMChanges();
				sec.sectionBeats = beatsPerSecStepper.value;
				adaptNotes(oldBPMMap);
			}
		};

		objY += 40;
		var copyButton:PsychUIButton = new PsychUIButton(objX, objY, 'Copy Section', copyNotesOnSection.bind(), 74);
		
		affectNotes = new PsychUICheckBox(objX + 82, objY + 2, 'Notes', 60);
		affectNotes.checked = true;
		
		objY += 25;
		var pasteButton:PsychUIButton = new PsychUIButton(objX, objY, 'Paste Section', function() {
			pasteCopiedNotesToSection(affectNotes.checked, affectEvents.checked);
		}, 74);
		
		affectEvents = new PsychUICheckBox(objX + 82, objY + 2, 'Events', 60);

		objY += 25;
		var copyLastSecButton:PsychUIButton = new PsychUIButton(objX, objY, 'Clone Section', function()
		{
			var lastCopiedNotes = copiedNotes;
			var lastCopiedEvents = copiedEvents;
			copyNotesOnSection(Std.int(copyLastSecStepper.value), false);
			pasteCopiedNotesToSection(affectNotes.checked, affectEvents.checked);
			copiedNotes = lastCopiedNotes;
			copiedEvents = lastCopiedEvents;
		}, 74);
		
		var copyLastSecTooltip:FlxText = new FlxText(objX + 144, objY + 3, 100, 'sections before');
		copyLastSecStepper = new PsychUINumericStepper(objX + 82, objY + 2, 1, 1, -999, 999, 0, 52);
		copyLastSecStepper.onValueChange = function() {
			if (copyLastSecStepper.value == 0) {
				if (copyLastSecStepper.buttonPlus.animation.name == 'pressed') { // genius
					copyLastSecStepper.value = 1;
					copyLastSecTooltip.text = 'sections before';
				} else {
					copyLastSecStepper.value = -1;
					copyLastSecTooltip.text = 'sections later';
				}
			}
		}
		
		objY += 45;
		var swapSectionButton:PsychUIButton = new PsychUIButton(objX, objY, 'Swap Notes', function()
		{
			var maxData:Int = GRID_COLUMNS_PER_PLAYER * GRID_PLAYERS;
			for (note in curRenderedNotes)
			{
				if(note != null && !note.isEvent)
				{
					var data:Int = note.songData[1] + GRID_COLUMNS_PER_PLAYER;
					if(data >= maxData) data -= maxData;
					note.changeNoteData(data);
					positionNoteXByData(note);
				}
			}
			softReloadNotes(true);
		}, 74);
		var mirrorNotesButton:PsychUIButton = new PsychUIButton(swapSectionButton.x + 74 + 8, objY, 'Mirror Notes', function()
		{
			var maxData:Int = GRID_COLUMNS_PER_PLAYER * GRID_PLAYERS;
			for (note in curRenderedNotes)
			{
				if(note == null || note.isEvent) continue;

				var data:Int = Std.int(note.songData[1]);
				note.changeNoteData((Math.floor(data / GRID_COLUMNS_PER_PLAYER) * GRID_COLUMNS_PER_PLAYER) + GRID_COLUMNS_PER_PLAYER - note.noteData - 1);
				positionNoteXByData(note);
			}
			softReloadNotes(true);
		}, 74);
		var duetSectionButton:PsychUIButton = new PsychUIButton(mirrorNotesButton.x + 74 + 8, objY, 'Duet Section', function()
		{
			var side:Int = -1;
			for (note in curRenderedNotes.members)
			{
				if(note == null || note.isEvent) continue;

				//First figure out if there are notes on more than one player's sides to cancel operation early
				if(side > -1)
				{
					if(Math.floor(note.songData[1] / GRID_COLUMNS_PER_PLAYER) != side)
					{
						showOutput('You cannot press this button with notes on more than one side.');
						return;
					}
				}
				else side = Math.floor(note.songData[1] / GRID_COLUMNS_PER_PLAYER);
			}

			var pushedNotes:Array<MetaNote> = [];
			for (note in curRenderedNotes.members)
			{
				if(note == null || note.isEvent) continue;

				for (i in 0...GRID_PLAYERS)
				{
					if(i == side) continue;

					var songDataCopy:Array<Dynamic> = note.songData.copy();
					songDataCopy[1] = note.noteData + i * GRID_COLUMNS_PER_PLAYER;
					var newNote = createNote(songDataCopy);
					notes.push(newNote);
					pushedNotes.push(newNote);
				}
			}
			notes.sort(PlayState.sortByTime);
			softReloadNotes(true);
			
			addUndoAction(ADD_NOTE, {notes: pushedNotes});
		}, 74);
		
		for (button in [swapSectionButton, mirrorNotesButton, duetSectionButton])
			button.normalStyle.bgColor = 0xff5cb1a9;
		
		var clearButton:PsychUIButton = new PsychUIButton(300 - 34 - 10, objY, 'Wipe', function() {
			for (note in curRenderedNotes) {
				if(note == null) continue;

				if(!note.isEvent && affectNotes.checked)
					notes.remove(note);
				if(note.isEvent && affectEvents.checked)
					events.remove(cast (note, EventMetaNote));

				selectedNotes.remove(note);
			}
			softReloadNotes(true);
			FlxG.sound.play(Paths.sound('tried'), 0.5);
		}, 34);
		clearButton.normalStyle.bgColor = FlxColor.RED;
		clearButton.normalStyle.textColor = FlxColor.WHITE;

		objY += 52;
		var clearLeftSectionButton:PsychUIButton = new PsychUIButton(objX, objY, 'Clear Left Side', function() {
			clearNotesBySide(true);
		});
		clearLeftSectionButton.normalStyle.bgColor = FlxColor.RED;
		clearLeftSectionButton.normalStyle.textColor = FlxColor.WHITE;
		clearLeftSectionButton.text.alignment = CENTER;

		var clearRightSectionButton:PsychUIButton = new PsychUIButton(objX + 100, objY, 'Clear Right Side', function() {
			clearNotesBySide(false);
		});
		clearRightSectionButton.normalStyle.bgColor = FlxColor.RED;
		clearRightSectionButton.normalStyle.textColor = FlxColor.WHITE;
		clearRightSectionButton.text.alignment = CENTER;

		tab_group.add(mustHitCheckBox);
		tab_group.add(gfSectionCheckBox);
		// tab_group.add(altAnimSectionCheckBox);

		tab_group.add(new FlxText(changeBpmStepper.x - 40, changeBpmStepper.y + 1, 100, 'BPM:'));
		tab_group.add(new FlxText(beatsPerSecStepper.x - 40, beatsPerSecStepper.y + 1, 100, 'Beats:'));
		tab_group.add(changeBpmCheckBox);
		tab_group.add(changeBpmStepper);
		tab_group.add(beatsPerSecStepper);
		
		tab_group.add(copyButton);
		tab_group.add(pasteButton);
		tab_group.add(clearButton);
		tab_group.add(affectNotes);
		tab_group.add(affectEvents);

		tab_group.add(copyLastSecButton);
		tab_group.add(copyLastSecStepper);
		tab_group.add(copyLastSecTooltip);

		tab_group.add(swapSectionButton);
		tab_group.add(duetSectionButton);
		tab_group.add(mirrorNotesButton);

		tab_group.add(clearLeftSectionButton);
		tab_group.add(clearRightSectionButton);
	}

	private function clearNotesBySide(isLeftSide:Bool) {
		if (PlayState.SONG.notes[curSec] == null) {
			showOutput("ERROR: Current section data is missing.", true);
			return;
		}

		var removedNotes:Array<MetaNote> = [];
		// Iterate over notes currently rendered in the editor (which belong to the current section)
		for (note in curRenderedNotes) {
			if (note == null || note.isEvent) continue; // Skip nulls and events

			// Use note.songData[1] which holds the original global note index (0-7)
			var globalNoteIndex:Int = Std.int(note.songData[1]);

			if (isLeftSide) {
				// Check if the note belongs to the left side (player 1's notes, typically 0-3)
				if (globalNoteIndex < GRID_COLUMNS_PER_PLAYER) { // GRID_COLUMNS_PER_PLAYER is 4
					removedNotes.push(note);
				}
			} else {
				// Check if the note belongs to the right side (player 2's notes, typically 4-7)
				if (globalNoteIndex >= GRID_COLUMNS_PER_PLAYER) { // GRID_COLUMNS_PER_PLAYER is 4
					removedNotes.push(note);
				}
			}
		}

		if (removedNotes.length > 0) {
			// Save the action for undo/redo. We pass a copy of removedNotes.
			addUndoAction(DELETE_NOTE, {notes: removedNotes.copy(), events: []});

			// Remove the notes from the main 'notes' array
			for (noteToRemove in removedNotes) {
				notes.remove(noteToRemove);
				// Also remove from selectedNotes if it was selected
				selectedNotes.remove(noteToRemove);
			}
			
			// Refresh the displayed notes in the current section
			softReloadNotes(true);
			// Update the UI elements that depend on note selection (e.g., selected count)
			onSelectNote();
			// Play a sound effect
			FlxG.sound.play(Paths.sound('tried'), 0.5);
			showOutput("Cleared " + removedNotes.length + " notes from " + (isLeftSide ? "left" : "right") + " side.");
		} else {
			showOutput("No notes found on the " + (isLeftSide ? "left" : "right") + " side to clear in this section.", true);
		}
	}

	function reloadNotesDropdowns()
	{
		// Event drop down
		if(eventDropDown != null)
		{
			eventsList = [];
			var eventFiles:Array<String> = loadFileList('custom_events/', ['.txt']);
			for (file in eventFiles)
			{
				var desc:String = Paths.getTextFromFile('custom_events/$file.txt');
				eventsList.push([file, desc]);
			}

			for (id => event in defaultEvents)
				if(!eventsList.contains(event))
					eventsList.insert(id, event);
			
			var displayEventsList:Array<String> = [];
			for (id => data in eventsList)
			{
				if(id > 0)
					displayEventsList[id] = '$id. ${data[0]}';
				else
					displayEventsList.push('');
			}

			var lastSelected:String = eventDropDown.selectedLabel;
			eventDropDown.list = displayEventsList;
			eventDropDown.selectedLabel = lastSelected;
		}

		// Note type drop down
		if(noteTypeDropDown != null)
		{
			var exts:Array<String> = ['.txt'];
			#if LUA_ALLOWED exts.push('.lua'); #end
			#if HSCRIPT_ALLOWED exts.push('.hx'); #end
			noteTypes = loadFileList('custom_notetypes/', exts);
			for (id => noteType in Note.defaultNoteTypes)
				if(!noteTypes.contains(noteType))
					noteTypes.insert(id, noteType);

			if(Song.chartPath != null && Song.chartPath.length > 0)
			{
				var parentFolder:String = Song.chartPath.replace('\\', '/');
				parentFolder = parentFolder.substr(0, Song.chartPath.lastIndexOf('/')+1);
				var notetypeFile:Array<String> = CoolUtil.coolTextFile(parentFolder + 'notetypes.txt');
				if(notetypeFile.length > 0)
				{
					for (ntTyp in notetypeFile)
					{
						var name:String = ntTyp.trim();
						if(!noteTypes.contains(name))
							noteTypes.push(name);
					}
				}
			}
			
			var displayNoteTypes:Array<String> = noteTypes.copy();
			for (id => key in displayNoteTypes)
			{
				if(id == 0) continue;
				displayNoteTypes[id] = '$id. $key';
			}
			
			var lastSelected:String = noteTypeDropDown.selectedLabel;
			noteTypeDropDown.list = displayNoteTypes;
			noteTypeDropDown.selectedLabel = lastSelected;
		}
	}

	function pasteCopiedNotesToSection(?canCopyNotes:Bool = true, ?canCopyEvents:Bool = true, ?showMessage:Bool = true) //Used on "Paste Section" and "Copy Last Section" buttons
	{
		var curSectionTime:Null<Float> = cachedSectionTimes[curSec];
		if(curSectionTime == null)
		{
			showOutput('ERROR: Unknown section??', true);
			return [];
		}
		
		var nextSectionTime:Null<Float> = cachedSectionTimes[curSec + 1];
		if (nextSectionTime == null) nextSectionTime = Math.POSITIVE_INFINITY;
		
		var sectionStep:Float = Conductor.getStep(curSectionTime);
		
		var pushedNotes:Array<MetaNote> = [];
		var nts:Array<MetaNote> = [];
		var evs:Array<EventMetaNote> = [];
		if(canCopyNotes && copiedNotes.length > 0)
		{
			for (note in copiedNotes)
			{
				if(note == null) continue;
				var dataCopy:Array<Dynamic> = makeNoteDataCopy(note, false);
				
				var noteStep:Float = dataCopy[0] + sectionStep;
				var strumTime:Float = Conductor.stepToSeconds(noteStep);
				
				if (strumTime < nextSectionTime) {
					dataCopy[0] = strumTime;
					dataCopy[2] = Conductor.stepToSeconds(noteStep + dataCopy[2]) - strumTime;
					
					var createdNote = createNote(dataCopy, curSec);
					notes.push(createdNote);
					pushedNotes.push(createdNote);
					nts.push(createdNote);
				}
			}
			notes.sort(PlayState.sortByTime);
		}

		if(canCopyEvents && copiedEvents.length > 0)
		{
			for (event in copiedEvents)
			{
				if(event == null) continue;
				var dataCopy:Array<Dynamic> = makeNoteDataCopy(event, true);
				dataCopy[0] += sectionStep;
				
				var strumTime:Float = Conductor.stepToSeconds(dataCopy[0]);

				if (strumTime < nextSectionTime) {
					dataCopy[0] = strumTime;
					
					var createdEvent = createEvent(dataCopy);
					events.push(createdEvent);
					pushedNotes.push(createdEvent);
					evs.push(createdEvent);
				}
			}
			events.sort(PlayState.sortByTime);
		}
		loadSection();
		
		if(showMessage)
		{
			if(nts.length == 0 && evs.length == 0)
			{
				showOutput('Nothing to paste!', true);
				return [];
			}

			var str:String = '';
			if(nts.length > 0) str += 'Notes Added: ${nts.length}';
			if(evs.length > 0)
			{
				if(str.length > 0) str += '\n';
				str += 'Events Added: ${evs.length}';
			}

			if(str.length > 0) showOutput(str);
		}
		addUndoAction(ADD_NOTE, {notes: nts, events: evs});
		return pushedNotes;
	}

	var songNameInputText:PsychUIInputText;
	var allowVocalsCheckBox:PsychUICheckBox;

	var bpmStepper:PsychUINumericStepper;
	var scrollSpeedStepper:PsychUINumericStepper;
	var audioOffsetStepper:PsychUINumericStepper;

	var stageDropDown:PsychUIDropDownMenu;
	var playerDropDown:PsychUIDropDownMenu;
	var opponentDropDown:PsychUIDropDownMenu;
	var girlfriendDropDown:PsychUIDropDownMenu;
	
	function addSongTab()
	{
		var tab_group = mainBox.getTab('Song').menu;
		var objX = 10;
		var objY = 25;

		songNameInputText = new PsychUIInputText(objX, objY, 100, 'None', 8);
		songNameInputText.onChange = function(old:String, cur:String) PlayState.SONG.song = cur;

		allowVocalsCheckBox = new PsychUICheckBox(objX, objY + 20, 'Allow Vocals', 80, function()
		{
			PlayState.SONG.needsVoices = allowVocalsCheckBox.checked;
			loadMusic();
		});
		var reloadAudioButton:PsychUIButton = new PsychUIButton(objX + 120, objY, 'Reload Audio', function() loadMusic(true), 80);

		#if mac
		var reloadJsonButton:PsychUIButton = new PsychUIButton(objX + 205, objY, 'Reload JSON', function()
		{
			var cur = Paths.formatToSongPath(songNameInputText.text);
			var curdiff = Highscore.formatSong(cur, PlayState.storyDifficulty);
			var diff = false;
			var loadedChart:SwagSong = try {
				diff = true;
				Song.getChart(curdiff, cur);
			} catch (e) {
				diff = false;
				Song.getChart(cur, cur);
			}
			if(loadedChart == null || !Reflect.hasField(loadedChart, 'song')) //Check if chart is ACTUALLY a chart and valid
			{
				showOutput('Error: File loaded is not a Psych(SkyDecay) Engine/FNF 0.2.x.x chart.', true);
				return;
			}

			var func:Void->Void = function()
			{
				loadChart(loadedChart);
				Song.chartPath = diff ? curdiff : cur;
				reloadNotesDropdowns();
				prepareReload();
				showOutput('Opened chart "${diff ? curdiff : cur}" successfully!');
			}
					
			if(!ignoreProgressCheckBox.checked) openSubState(new Prompt('Warning: Any unsaved progress\nwill be lost.', func));
			else func();
		}, 80);
		#end

		objY += 65;
		//(x:Float = 0, y:Float = 0, step:Float = 1, defValue:Float = 0, min:Float = -999, max:Float = 999, decimals:Int = 0, ?wid:Int = 60, ?isPercent:Bool = false)
		bpmStepper = new PsychUINumericStepper(objX, objY, 1, 1, 1, 999999999, 3); // so you can set bpm to whatever you want
		bpmStepper.onValueChange = function()
		{
			var oldBPMMap:Array<BPMChangeEvent> = Conductor.copyBPMChanges();
			PlayState.SONG.bpm = bpmStepper.value;
			adaptNotes(oldBPMMap);
		};

		scrollSpeedStepper = new PsychUINumericStepper(objX + 90, objY, 0.1, 1, 0.1, 10, 2);
		scrollSpeedStepper.onValueChange = function() PlayState.SONG.speed = scrollSpeedStepper.value;

		audioOffsetStepper = new PsychUINumericStepper(objX + 180, objY, 1, 0, -9999999999, 9999999999, 0); //So you can set offset to whatever you want
		audioOffsetStepper.onValueChange = function()
		{
			PlayState.SONG.offset = audioOffsetStepper.value;
			Conductor.offset = audioOffsetStepper.value;
			updateWaveform();
		};

		objY += 40;
		odStepper = new PsychUINumericStepper(objX, objY, 0.1, 5, 0, 10, 1); // OD 0-10, default 5
		odStepper.onValueChange = function() {
			if (PlayState.SONG != null) PlayState.SONG.overallDifficulty = odStepper.value;
		};
	
		hpStepper = new PsychUINumericStepper(objX + 150, objY, 0.1, 5, 0, 10, 1); // HP 0-10, default 5
		hpStepper.onValueChange = function() {
			if (PlayState.SONG != null) PlayState.SONG.hpDrainRate = hpStepper.value;
		};

		tab_group.add(new FlxText(odStepper.x, odStepper.y - 15, 100, 'Overall Difficulty:'));
		tab_group.add(new FlxText(hpStepper.x, hpStepper.y - 15, 100, 'HP Drain Rate:'));
		tab_group.add(odStepper);
		tab_group.add(hpStepper);

		tab_group.add(new FlxText(songNameInputText.x, songNameInputText.y - 15, 80, 'Song Name:'));
		tab_group.add(songNameInputText);
		tab_group.add(allowVocalsCheckBox);
		tab_group.add(reloadAudioButton);
		#if mac
		tab_group.add(reloadJsonButton);
		#end

		// Find characters
		var characters:Array<String> = [];
		//
		
		objY += 40;
		playerDropDown = new PsychUIDropDownMenu(objX, objY, [''], function(id:Int, character:String)
		{
			PlayState.SONG.player1 = character;
			updateJsonData();
			updateHeads(true);
			remove(lilPlayer);
			createLilPlayer(character);
			//createPlayerGhost();
			//remove(playerGhost);
			loadMusic();
			trace('selected $character');
		});
		stageDropDown = new PsychUIDropDownMenu(objX + 140, objY, [''], function(id:Int, stage:String)
		{
			PlayState.SONG.stage = stage;
			StageData.loadDirectory(PlayState.SONG);
			trace('selected $stage');
		});
		
		opponentDropDown = new PsychUIDropDownMenu(objX, objY + 40, [''], function(id:Int, character:String)
		{
			PlayState.SONG.player2 = character;
			updateJsonData();
			updateHeads(true);
			remove(lilOpponent);
			createLilOpponent(character);
			//createOpponentGhost();
			//remove(opponentGhost);
			loadMusic();
			trace('selected $character');
		});
		
		girlfriendDropDown = new PsychUIDropDownMenu(objX, objY + 80, [''], function(id:Int, character:String)
		{
			PlayState.SONG.gfVersion = character;
			remove(lilGf);
			createLilGirlfriend(character);
			trace('selected $character');
		});
		
		tab_group.add(new FlxText(bpmStepper.x, bpmStepper.y - 15, 50, 'BPM:'));
		tab_group.add(new FlxText(scrollSpeedStepper.x, scrollSpeedStepper.y - 15, 80, 'Scroll Speed:'));
		tab_group.add(new FlxText(audioOffsetStepper.x, audioOffsetStepper.y - 15, 100, 'Audio Offset (ms):'));
		tab_group.add(bpmStepper);
		tab_group.add(scrollSpeedStepper);
		tab_group.add(audioOffsetStepper);

		//dropdowns
		tab_group.add(new FlxText(stageDropDown.x, stageDropDown.y - 15, 80, 'Stage:'));
		tab_group.add(new FlxText(playerDropDown.x, playerDropDown.y - 15, 80, 'Player:'));
		tab_group.add(new FlxText(opponentDropDown.x, opponentDropDown.y - 15, 80, 'Opponent:'));
		tab_group.add(new FlxText(girlfriendDropDown.x, girlfriendDropDown.y - 15, 80, 'Girlfriend:'));
		tab_group.add(stageDropDown);
		tab_group.add(girlfriendDropDown);
		tab_group.add(opponentDropDown);
		tab_group.add(playerDropDown);
	}

	var songArtistInputText:PsychUIInputText; // credits
	var artistsInputText:PsychUIInputText;
	var chartersInputText:PsychUIInputText;
	var vfxInputText:PsychUIInputText;
	var scriptersInputText:PsychUIInputText;
	function addCreditsTab()
	{
		var tab_group = mainBox.getTab('Credits').menu;
		var objX = 10;
		var objY = 25;

		objY += 40;
		songArtistInputText = new PsychUIInputText(objX, objY, 120, '', 8);
		songArtistInputText.onChange = function(old:String, cur:String) PlayState.SONG.songArtists = cur;

		objY += 40;
		artistsInputText = new PsychUIInputText(objX, objY, 120, '', 8);
		artistsInputText.onChange = function(old:String, cur:String) PlayState.SONG.artists = cur;

		objY += 40;
		chartersInputText = new PsychUIInputText(objX, objY, 120, '', 8);
		chartersInputText.onChange = function(old:String, cur:String) PlayState.SONG.charters = cur;

		objY += 40;
		vfxInputText = new PsychUIInputText(objX, objY, 120, '', 8);
		vfxInputText.onChange = function(old:String, cur:String) PlayState.SONG.vfx = cur;

		objY += 40;
		scriptersInputText = new PsychUIInputText(objX, objY, 120, '', 8);
		scriptersInputText.onChange = function(old:String, cur:String) PlayState.SONG.scripters = cur;

		tab_group.add(new FlxText(songArtistInputText.x, songArtistInputText.y - 15, 180, 'Music Artist:'));
		tab_group.add(new FlxText(artistsInputText.x, artistsInputText.y - 15, 180, 'Artists:'));
		tab_group.add(new FlxText(chartersInputText.x, chartersInputText.y - 15, 180, 'Charters:'));
		tab_group.add(new FlxText(vfxInputText.x, vfxInputText.y - 15, 180, 'VFX:'));
		tab_group.add(new FlxText(scriptersInputText.x, scriptersInputText.y - 15, 180, 'Scripters:'));
		tab_group.add(songArtistInputText);
		tab_group.add(artistsInputText);
		tab_group.add(chartersInputText);
		tab_group.add(vfxInputText);
		tab_group.add(scriptersInputText);
	}

	/**
	 * Converts the current chart data to a legacy Psych Engine format (0.2.x.x)
	 * and separates events into a distinct object.
	 * @return A dynamic object containing 'chart' and 'events' data for saving.
	 */
	private function convertToLegacyFormat():{chart:Dynamic, events:Dynamic} {
		var convertedSong:SwagSong = cast haxe.Json.parse(haxe.Json.stringify(PlayState.SONG));
		for (section in convertedSong.notes) {
			if (section.sectionNotes != null && section.sectionNotes.length != 0) {
				for (noteDataArr in section.sectionNotes) { // noteDataArr is like [strumTime, noteData, sustainLength, ?noteType]
					// If it's an opponent section (!mustHitSection)
					if (!section.mustHitSection) {
						// If the note is originally for the opponent (global index 4-7)
						// In modern Psych, opponent notes are 4-7. In legacy, they are 0-3 in opponent sections.
						if (noteDataArr[1] >= GRID_COLUMNS_PER_PLAYER) { // GRID_COLUMNS_PER_PLAYER is 4
							noteDataArr[1] = noteDataArr[1] % GRID_COLUMNS_PER_PLAYER; // Convert 4-7 to 0-3
						}
						// If the note is originally for the player (global index 0-3)
						// In modern Psych, player notes are 0-3. In legacy, they are 4-7 in opponent sections.
						else {
							noteDataArr[1] += GRID_COLUMNS_PER_PLAYER; // Convert 0-3 to 4-7
						}
					}
				}
			}
		}

		convertedSong.format = 'psych_legacy_convert';

		var legacyEvents:Dynamic = {
			events: convertedSong.events,
			format: 'psych_legacy_convert' // Events also need a format property in legacy
		};
		convertedSong.events = [];

		var finalChartData:Dynamic = {
			song: convertedSong
		};

		return {chart: finalChartData, events: legacyEvents};
	}

	function addFileTab()
	{
		var tab = upperBox.getTab('File');
		var tab_group = tab.menu;
		var btnX = tab.x - upperBox.x;
		var btnY = 1;
		var btnWid = Std.int(tab.width);

		var btn:PsychUIButton = new PsychUIButton(btnX, btnY, '  New', function()
		{
			var func:Void->Void = function()
			{
				openNewChart();
				reloadNotesDropdowns();
				prepareReload();
			}

			if(!ignoreProgressCheckBox.checked) openSubState(new Prompt('Are you sure you want to start over?', func));
			else func();
		}, btnWid);
		btn.text.alignment = LEFT;
		tab_group.add(btn);

		btnY++;
		btnY += 20;
		var btn:PsychUIButton = new PsychUIButton(btnX, btnY, '  Open Chart...', function()
		{
			if(!fileDialog.completed) return;
			upperBox.isMinimized = true;
			upperBox.bg.visible = false;
			FlxG.sound.play(Paths.sound('noteComboSound'), 0.5);

			fileDialog.open(function()
			{
				try
				{
					var filePath:String = fileDialog.path.replace('\\', '/');
					var loadedChart:SwagSong = Song.parseJSON(fileDialog.data, filePath.substr(filePath.lastIndexOf('/')));
					if(loadedChart == null || !Reflect.hasField(loadedChart, 'song')) //Check if chart is ACTUALLY a chart and valid
					{
						showOutput('Error: File loaded is not a Psych Engine/FNF 0.2.x.x chart.', true);
						return;
					}

					var func:Void->Void = function()
					{
						loadChart(loadedChart);
						Song.chartPath = fileDialog.path;
						reloadNotesDropdowns();
						prepareReload();
						showOutput('Opened chart "${Song.chartPath}" successfully!');
					}
					
					if(!ignoreProgressCheckBox.checked) openSubState(new Prompt('Warning: Any unsaved progress\nwill be lost.', func));
					else func();
				}
				catch(e:Exception)
				{
					showOutput('Error: ${e.message}', true);
					trace(e.stack);
				}
			});
		}, btnWid);
		btn.text.alignment = LEFT;
		tab_group.add(btn);

		btnY += 20;
		var btn:PsychUIButton = new PsychUIButton(btnX, btnY, '  Open Autosave...', function()
		{
			if(!fileDialog.completed) return;
			upperBox.isMinimized = true;
			upperBox.bg.visible = false;

			if(!FileSystem.exists('backups/'))
			{
				showOutput('The "backups" folder does not exist.', true);
				return;
			}
			
			var fileList:Array<String> = FileSystem.readDirectory('backups/').filter((file:String) -> file.endsWith('.$BACKUP_EXT'));
			if(fileList.length < 1)
			{
				showOutput('No autosave files found.', true);
				return;
			}

			fileList.sort((a:String, b:String) -> (a.toUpperCase() < b.toUpperCase()) ? 1 : -1); //Sort alphabetically descending
			var maxItems:Int = Std.int(Math.min(5, fileList.length));
			var radioGrp:PsychUIRadioGroup = new PsychUIRadioGroup(0, 0, fileList, 25, maxItems, false, 240);
			radioGrp.checked = 0;

			var hei:Float = radioGrp.height + 160;
			openSubState(new BasePrompt(420, hei, 'Choose an Autosave',
				function(state:BasePrompt) {
					upperBox.isMinimized = true;
					upperBox.bg.visible = false;

					var btn:PsychUIButton = new PsychUIButton(state.bg.x + state.bg.width - 40, state.bg.y, 'X', state.close, 40);
					btn.cameras = state.cameras;
					state.add(btn);

					radioGrp.screenCenter(X);
					radioGrp.y = state.bg.y + 80;
					radioGrp.cameras = state.cameras;
					state.add(radioGrp);

					var btn:PsychUIButton = new PsychUIButton(0, radioGrp.y + radioGrp.height + 20, 'Load', function()
					{
						var autosaveName:String = fileList[radioGrp.checked];
						var path:String = 'backups/$autosaveName';
						state.close();

						if(FileSystem.exists(path))
						{
							try
							{
								var loadedChart:SwagSong = Song.parseJSON(File.getContent(path), autosaveName, null);
								if(loadedChart == null || !Reflect.hasField(loadedChart, '__original_path'))
								{
									showOutput('Error: File loaded is not a valid Psych Engine autosave.', true);
									return;
	
								}
	
								var originalPath:String = Reflect.field(loadedChart, '__original_path');
								Reflect.deleteField(loadedChart, '__original_path');
	
								var func:Void->Void = function()
								{
									Song.chartPath = FileSystem.exists(originalPath) ? originalPath : null;
									loadChart(loadedChart);
									reloadNotesDropdowns();
									prepareReload();
	
									showOutput('Opened autosave "$autosaveName" successfully!');
								}
								
								if(!ignoreProgressCheckBox.checked) openSubState(new Prompt('Warning: Any unsaved progress\nwill be lost.', func));
								else func();
							}
							catch(e:Exception)
							{
								showOutput('Error on loading autosave: ${e.message}', true);
							}
						}
						else showOutput('Error! Autosave file selected could not be found, huh??', true);
					});
					btn.cameras = state.cameras;
					btn.screenCenter(X);
					state.add(btn);
				}
			));
		}, btnWid);
		btn.text.alignment = LEFT;
		tab_group.add(btn);

		if(SHOW_EVENT_COLUMN)
		{
			btnY += 20;
			var btn:PsychUIButton = new PsychUIButton(btnX, btnY, '  Open Events...', function()
			{
				if(!fileDialog.completed) return;
				upperBox.isMinimized = true;
				upperBox.bg.visible = false;
	
				fileDialog.open(function()
				{
					try
					{
						var filePath:String = fileDialog.path.replace('\\', '/');
						var eventsFile:SwagSong = Song.parseJSON(fileDialog.data, filePath.substr(filePath.lastIndexOf('/')));
						if(eventsFile == null || Reflect.hasField(eventsFile, 'scrollSpeed') || eventsFile.events == null)
						{
							showOutput('Error: File loaded is not a Psych Engine chart/events file.', true);
							return;
						}
	
						var loadedEvents:Array<Dynamic> = eventsFile.events;
						if(loadedEvents.length < 1)
						{
							showOutput('Events file loaded is empty.', true);
							return;
						}
	
						openSubState(new BasePrompt('Events Found! Choose an action.',
							function(state:BasePrompt)
							{
								var btnY = 390;
								var btn:PsychUIButton = new PsychUIButton(0, btnY, 'Replace All', function()
								{
									for (event in events)
									{
										if(event != null)
										{
											event.destroy();
											selectedNotes.remove(event);
										}
									}
									undoActions = [];
									events = [];
	
									for (event in loadedEvents)
										events.push(createEvent(event));
	
									softReloadNotes();
									state.close();
									showOutput('Events loaded successfully!');
								});
								btn.normalStyle.bgColor = FlxColor.RED;
								btn.normalStyle.textColor = FlxColor.WHITE;
								btn.screenCenter(X);
								btn.x -= 125;
								btn.cameras = state.cameras;
								state.add(btn);
								
								var btn:PsychUIButton = new PsychUIButton(0, btnY, 'Add', function()
								{
									for (event in loadedEvents)
										events.push(createEvent(event));
	
									softReloadNotes();
									state.close();
									showOutput('Events added successfully!');
								});
								btn.screenCenter(X);
								btn.cameras = state.cameras;
								state.add(btn);
						
								var btn:PsychUIButton = new PsychUIButton(0, btnY, 'Cancel', state.close);
								btn.screenCenter(X);
								btn.x += 125;
								btn.cameras = state.cameras;
								state.add(btn);
							}
						));
					}
					catch(e:Exception)
					{
						showOutput('Error: ${e.message}', true);
						trace(e.stack);
					}
				});
			}, btnWid);
			btn.text.alignment = LEFT;
			tab_group.add(btn);
		}

		btnY++;
		btnY += 20;
		var btn:PsychUIButton = new PsychUIButton(btnX, btnY, '  Save', function()
		{
			if(!fileDialog.completed) return;
			upperBox.isMinimized = true;
			upperBox.bg.visible = false;

			saveChart();
		}, btnWid);
		btn.text.alignment = LEFT;
		tab_group.add(btn);

		btnY += 20;
		var btn:PsychUIButton = new PsychUIButton(btnX, btnY, '  Save as...', function()
		{
			if(!fileDialog.completed) return;
			upperBox.isMinimized = true;
			upperBox.bg.visible = false;
			FlxG.sound.play(Paths.sound('loading_open_alpha'), 0.5);

			saveChart(false);
		},btnWid);
		btn.text.alignment = LEFT;
		tab_group.add(btn);

		if(SHOW_EVENT_COLUMN)
		{
			btnY += 20;
			var btn:PsychUIButton = new PsychUIButton(btnX, btnY, '  Save Events...', function()
			{
				if(!fileDialog.completed) return;
				upperBox.isMinimized = true;
	
				updateChartData();
				FlxG.sound.play(Paths.sound('Limu/heal'), 0.5);
				fileDialog.save('events.json', PsychJsonPrinter.print({events: PlayState.SONG.events, format: 'psych_v1'}, ['events']),
					function() showOutput('Events saved successfully to: ${fileDialog.path}'), null,
					function() showOutput('Error on saving events!', true));
			}, btnWid);
			btn.text.alignment = LEFT;
			tab_group.add(btn);
		}

		btnY += 20;
		var btn:PsychUIButton = new PsychUIButton(btnX, btnY, '  Save as Legacy...', function()
		{
			if(!fileDialog.completed) return;
			upperBox.isMinimized = true;
			upperBox.bg.visible = false;
			FlxG.sound.play(Paths.sound('loading_open_alpha'), 0.5);

			updateChartData();
			var legacyData = convertToLegacyFormat();

			var chartNameBase:String = Paths.formatToSongPath(PlayState.SONG.song);
			var chartFileName:String = chartNameBase + '.json';
			var eventsFileName:String = chartNameBase + '-events.json';

			fileDialog.openDirectory('Save Legacy Chart/Events JSONs', function()
			{
				var path:String = fileDialog.path.replace('\\', '/');
				if(!path.endsWith('/')) path += '/';

				overwriteSavedSomething = false;

				overwriteCheck(path + chartFileName, chartFileName, PsychJsonPrinter.print(legacyData.chart, ['song']), function()
				{
					overwriteCheck(path + eventsFileName, eventsFileName, PsychJsonPrinter.print(legacyData.events, ['events']), function()
					{
						if(overwriteSavedSomething)
							showOutput('Legacy chart and events saved successfully to: $path!');
						else
							showOutput('Legacy chart and events save cancelled or no changes made.', true);
					});
				});
			});
		}, btnWid);
		btn.text.alignment = LEFT;
		tab_group.add(btn);

		btnY++;
		btnY += 20;
		var btn:PsychUIButton = new PsychUIButton(btnX, btnY, '  Reload Chart', function()
		{
			var func:Void->Void = function()
			{
				if(Song.chartPath == null)
				{
					showOutput('You must save/load a Chart first to Reload it!', true);
					return;
				}
	
				if(FileSystem.exists(Song.chartPath))
				{
					try
					{
						var reloadedChart:SwagSong = Song.parseJSON(File.getContent(Song.chartPath));
						loadChart(reloadedChart);
						reloadNotesDropdowns();
						prepareReload();
						showOutput('Chart reloaded successfully!');
					}
					catch(e:Exception)
					{
						showOutput('Error: ${e.message}', true);
						trace(e.stack);
					}
				}
				else showOutput('You must save/load a Chart first to Reload it!', true);
			}

			if(!ignoreProgressCheckBox.checked) openSubState(new Prompt('Warning: Any unsaved progress will be lost', func));
			else func();
		}, btnWid);
		btn.text.alignment = LEFT;
		tab_group.add(btn);
		
		btnY++;
		btnY += 20;
		var btn:PsychUIButton = new PsychUIButton(btnX, btnY, '  Save (V-Slice)...', function()
		{
			if(!fileDialog.completed) return;
			upperBox.isMinimized = true;
			upperBox.bg.visible = false;

			fileDialog.openDirectory('Save V-Slice Chart/Metadata JSONs', function()
			{
				try
				{
					var path:String = fileDialog.path.replace('\\', '/');

					var chartName:String = Paths.formatToSongPath(PlayState.SONG.song) + '.json';
					chartName = chartName.substring(chartName.lastIndexOf('/')+1, chartName.lastIndexOf('.'));

					var chartFile:String = '$path/$chartName-chart.json';
					var metadataFile:String = '$path/$chartName-metadata.json';

					updateChartData();
					var pack:VSlicePackage = VSlice.export(PlayState.SONG);

					ClientPrefs.toggleVolumeKeys(false);
					openSubState(new BasePrompt('Metadata',
						function(state:BasePrompt)
						{
							var btnX = 640;
							var btnY = 400;
							var btn:PsychUIButton = new PsychUIButton(btnX, btnY, 'Save', function()
							{
								overwriteSavedSomething = false;
								overwriteCheck(chartFile, '$chartName-chart.json', PsychJsonPrinter.print(pack.chart, ['events', 'notes', 'scrollSpeed']), function()
								{
									overwriteCheck(metadataFile, '$chartName-metadata.json', PsychJsonPrinter.print(pack.metadata, ['characters', 'difficulties', 'timeChanges']), function()
									{
										if(overwriteSavedSomething)
											showOutput('Files saved successfully to: $path!');
									});
								});
								state.close();
							});
							btn.normalStyle.bgColor = FlxColor.GREEN;
							btn.normalStyle.textColor = FlxColor.WHITE;
							btn.cameras = state.cameras;
							state.add(btn);
							
							var btn:PsychUIButton = new PsychUIButton(btnX + 100, btnY, 'Cancel', state.close);
							btn.cameras = state.cameras;
							state.add(btn);
							
							var textX = FlxG.width/2 - 155;
							var textY = 360;
							var artistInput:PsychUIInputText = new PsychUIInputText(textX, textY, 120, pack.metadata.artist, 8);
							artistInput.cameras = state.cameras;
							artistInput.onChange = function(old:String, cur:String) pack.metadata.artist = cur;

							var charterInput:PsychUIInputText = new PsychUIInputText(textX + 190, textY, 120, pack.metadata.charter, 8);
							charterInput.cameras = state.cameras;
							charterInput.onChange = function(old:String, cur:String) pack.metadata.charter = cur;
							
							var artistTxt:FlxText = new FlxText(artistInput.x, artistInput.y - 15, 100, 'Artist/Composer:');
							artistTxt.cameras = state.cameras;
							var charterTxt:FlxText = new FlxText(charterInput.x, charterInput.y - 15, 100, 'Charter:');
							charterTxt.cameras = state.cameras;
							state.add(artistTxt);
							state.add(charterTxt);
							state.add(artistInput);
							state.add(charterInput);
						}
					));

					//trace(pack.chart);
					//trace(pack.metadata);
					//trace(chartName, chartFile, metadataFile);
				}
				catch(e:Exception)
				{
					showOutput('Error: ${e.message}', true);
					trace(e.stack);
				}
			});
		},btnWid);
		btn.text.alignment = LEFT;
		tab_group.add(btn);

		btnY += 20;
		var btn:PsychUIButton = new PsychUIButton(btnX, btnY, '  Psych to V-Slice...', function()
		{
			if(!fileDialog.completed) return;
			upperBox.isMinimized = true;
			upperBox.bg.visible = false;

			fileDialog.open('song.json', 'Open a Psych Engine Chart JSON', function()
			{
				var filePath:String = fileDialog.path.replace('\\', '/');
				var loadedChart:SwagSong = Song.parseJSON(fileDialog.data, filePath.substr(filePath.lastIndexOf('/')));
				if(loadedChart == null || !Reflect.hasField(loadedChart, 'song')) //Check if chart is ACTUALLY a chart and valid
				{
					showOutput('Error: File loaded is not a Psych Engine 0.x.x/FNF 0.2.x.x chart.', true);
					return;
				}

				var pack:VSlicePackage = VSlice.export(loadedChart);
				if(pack.chart == null || pack.metadata == null)
				{
					showOutput('Error: Chart loaded is invalid.', true);
					return;
				}

				ClientPrefs.toggleVolumeKeys(false);
				openSubState(new BasePrompt('Metadata',
					function(state:BasePrompt)
					{
						var songName:String = Paths.formatToSongPath(pack.metadata.songName);
						var parentFolder:String = filePath.substring(0, filePath.lastIndexOf('/')+1);
						var artistInput, charterInput, difficultiesInput:PsychUIInputText = null;

						var btnX = 640;
						var btnY = 400;
						var btn:PsychUIButton = new PsychUIButton(btnX, btnY, 'Save', function()
						{
							try
							{
								var diffs:Array<String> = pack.metadata.playData.difficulties;
								if(diffs != null && diffs.length > 0)
								{
									var diffsFound:Array<String> = [];
									var defaultDiff:String = Paths.formatToSongPath(Difficulty.getDefault());
									for (diff in diffs)
									{
										var diffPostfix:String = (diff != defaultDiff) ? '-$diff' : '';
										var chartToFind:String = parentFolder + songName + diffPostfix + '.json';
										if(FileSystem.exists(chartToFind))
										{
											var diffChart:SwagSong = Song.parseJSON(File.getContent(chartToFind), songName + diffPostfix);
											if(diffChart != null)
											{
												var subpack:VSlicePackage = VSlice.export(diffChart);
												var	diffSpeed:Null<Float> = subpack.chart.scrollSpeed.get(diff);
												var diffNotes:Array<VSliceNote> = subpack.chart.notes.get(diff);
												if(diffSpeed != null && diffNotes != null)
												{
													pack.chart.scrollSpeed.set(diff, diffSpeed);
													pack.chart.notes.set(diff, diffNotes);
												}
												//trace(diff, diffSpeed, diffNotes.length);
											}
										}
										else trace('File not found: $chartToFind');
									}
									
									var chartToFind:String = parentFolder + 'events.json';
									if(FileSystem.exists(chartToFind))
									{
										var eventsChart:SwagSong = Song.parseJSON(File.getContent(chartToFind), 'events');
										if(eventsChart != null)
										{
											var subpack:VSlicePackage = VSlice.export(eventsChart);
											if(subpack.chart.events != null && subpack.chart.events.length > 0)
											{
												for (event in subpack.chart.events)
												{
													if(event == null) continue;
													pack.chart.events.push(event);
												}
											}
											@:privateAccess pack.chart.events.sort(VSlice.sortByTime);
										}
									}

									fileDialog.openDirectory('Save V-Slice Chart/Metadata JSONs', function()
									{
										overwriteSavedSomething = false;
										var path:String = fileDialog.path.replace('\\', '/');
										if(path.endsWith('/')) path = path.substr(0, path.length-1);
										overwriteCheck('$path/$songName-chart.json', '$songName-chart.json', PsychJsonPrinter.print(pack.chart, ['events', 'notes', 'scrollSpeed']), function()
										{
											overwriteCheck('$path/$songName-metadata.json', '$songName-metadata.json', PsychJsonPrinter.print(pack.metadata, ['characters', 'difficulties', 'timeChanges']), function()
											{
												if(overwriteSavedSomething)
													showOutput('Files saved successfully to: $path!');
											});
										});
									});
								}
								else showOutput('Error: You need atleast one difficulty to export.', true);
							}
							catch(e:Exception)
							{
								showOutput('Error: ${e.message}', true);
								trace(e.stack);
							}
							state.close();
						});
						btn.normalStyle.bgColor = FlxColor.GREEN;
						btn.normalStyle.textColor = FlxColor.WHITE;
						btn.cameras = state.cameras;
						state.add(btn);
						
						var btn:PsychUIButton = new PsychUIButton(btnX + 100, btnY, 'Cancel', state.close);
						btn.cameras = state.cameras;
						state.add(btn);
						
						var textX = FlxG.width/2 - 180;
						var textY = 360;
						artistInput = new PsychUIInputText(textX, textY, 120, pack.metadata.artist, 8);
						artistInput.cameras = state.cameras;
						artistInput.onChange = function(old:String, cur:String) pack.metadata.artist = cur;
	
						charterInput = new PsychUIInputText(textX + 150, textY, 120, pack.metadata.charter, 8);
						charterInput.cameras = state.cameras;
						charterInput.onChange = function(old:String, cur:String) pack.metadata.charter = cur;

						var diffs:Array<String> = pack.metadata.playData.difficulties;
						if(diffs == null || diffs.length < 0) pack.metadata.playData.difficulties = diffs = ['easy', 'normal', 'hard'];
						difficultiesInput = new PsychUIInputText(textX, textY + 42, 160, diffs.join(', '), 8);
						difficultiesInput.cameras = state.cameras;
						difficultiesInput.forceCase = LOWER_CASE;
						difficultiesInput.onChange = function(old:String, cur:String)
						{
							pack.metadata.playData.difficulties = cur.split(',');

							var diffs:Array<String> = pack.metadata.playData.difficulties;
							for (num => diff in diffs)
								diffs[num] = Paths.formatToSongPath(diff);

							while(diffs.contains('')) //Clear invalids cuz people might be stupid
								diffs.remove('');
						}
						
						var artistTxt:FlxText = new FlxText(artistInput.x, artistInput.y - 15, 100, 'Artist/Composer:');
						artistTxt.cameras = state.cameras;
						var charterTxt:FlxText = new FlxText(charterInput.x, charterInput.y - 15, 100, 'Charter:');
						charterTxt.cameras = state.cameras;
						var difficultiesTxt:FlxText = new FlxText(difficultiesInput.x, difficultiesInput.y - 15, 100, 'Difficulties:');
						difficultiesTxt.cameras = state.cameras;
						state.add(artistTxt);
						state.add(charterTxt);
						state.add(difficultiesTxt);
						state.add(artistInput);
						state.add(charterInput);
						state.add(difficultiesInput);
					}
				));
			});
		},btnWid);
		btn.text.alignment = LEFT;
		tab_group.add(btn);

		btnY += 20;
		var btn:PsychUIButton = new PsychUIButton(btnX, btnY, '  V-Slice to Psych...', function()
		{
			if(!fileDialog.completed) return;
			upperBox.isMinimized = true;
			upperBox.bg.visible = false;

			fileDialog.open('chart.json', 'Open a V-Slice Chart file', function()
			{
				var chart:VSliceChart = cast Json.parse(fileDialog.data);
				if(chart == null || chart.version == null || chart.notes == null || chart.scrollSpeed == null)
				{
					showOutput('Error: File loaded is not a valid FNF V-Slice chart.', true);
					return;
				}

				fileDialog.open('metadata.json', 'Open a V-Slice Metadata file', function()
				{
					var metadata:VSliceMetadata = cast Json.parse(fileDialog.data);
					if(metadata == null || metadata.version == null || metadata.playData == null || metadata.songName == null ||
						metadata.playData.difficulties == null || metadata.timeChanges == null || metadata.timeChanges.length < 1)
					{
						showOutput('Error: File loaded is not a valid FNF V-Slice metadata.', true);
						return;
					}

					try
					{
						var pack:PsychPackage = VSlice.convertToPsych(chart, metadata);
						if(pack.difficulties != null)
						{
							fileDialog.openDirectory('Save Converted Psych JSONs', function()
							{
								var path:String = fileDialog.path.replace('\\', '/');
								if(!path.endsWith('/')) path += '/';

								var diffs:Array<String> = metadata.playData.difficulties.copy();
								var defaultDiff:String = Paths.formatToSongPath(Difficulty.getDefault());
								function nextChart()
								{
									while(diffs.length > 0)
									{
										var diffName:String = diffs[0];
										diffs.remove(diffName);
										if(!pack.difficulties.exists(diffName)) continue;
		
										var diffPostfix:String = (diffName != defaultDiff) ? '-$diffName' : '';
										var chartData:SwagSong = pack.difficulties.get(diffName);
										var chartName:String = Paths.formatToSongPath(chartData.song) + diffPostfix + '.json';
										overwriteCheck(path + chartName, chartName, PsychJsonPrinter.print(chartData, ['sectionNotes', 'events']), nextChart, true);
										return;
									}
	
									if(pack.events != null)
									{
										overwriteCheck(path + 'events.json', 'events.json', PsychJsonPrinter.print(pack.events, ['events']), function()
										{
											if(overwriteSavedSomething)
												showOutput('Files saved successfully to: ${fileDialog.path}!');
										}, true);
									}
									else if(overwriteSavedSomething)
										showOutput('Files saved successfully to: ${fileDialog.path}!');
								}
								
								overwriteSavedSomething = false;
								nextChart();
							});
						}
						else showOutput('Error: No difficulties found.');
					}
					catch(e:Exception)
					{
						showOutput('Error: ${e.message}', true);
						trace(e.stack);
					}
				});
			});
		},btnWid);
		btn.text.alignment = LEFT;
		tab_group.add(btn);
		
		btnY += 20;
		var btn:PsychUIButton = new PsychUIButton(btnX, btnY, '  Update (Legacy)...', function()
		{
			if(!fileDialog.completed) return;
			upperBox.isMinimized = true;
			upperBox.bg.visible = false;

			fileDialog.open(function()
			{
				var oldSong = PlayState.SONG;
				try
				{
					var filePath:String = fileDialog.path.replace('\\', '/');
					filePath = filePath.substring(filePath.lastIndexOf('/')+1, filePath.lastIndexOf('.'));

					var loadedChart:SwagSong = Song.parseJSON(fileDialog.data, filePath, '');
					if(loadedChart == null || !Reflect.hasField(loadedChart, 'song')) //Check if chart is ACTUALLY a chart and valid
					{
						showOutput('Error: File loaded is not a Psych Engine 0.x.x/FNF 0.2.x.x chart.', true);
						return;
					}

					var fmt:String = loadedChart.format;
					if(fmt == null || fmt.length < 1)
						fmt = loadedChart.format = 'unknown';

					if(!fmt.startsWith('psych_v1'))
					{
						loadedChart.format = 'psych_v1_convert';
						Song.convert(loadedChart);
						File.saveContent(fileDialog.path, PsychJsonPrinter.print(loadedChart, ['sectionNotes', 'events']));
						showOutput('Updated "$filePath" from format "$fmt" to "psych_v1" successfully!');
					}
					else showOutput('Chart is already up-to-date! Format: "$fmt"', true);
				}
				catch(e:Exception)
				{
					showOutput('Error: ${e.message}', true);
					trace(e.stack);
				}
			});
		}, btnWid);
		btn.text.alignment = LEFT;
		tab_group.add(btn);

		//Only reason why i'm using VSlice because i WANT to use VSlice for its BPM and placement. Which i could just use Osu to Psych but it will NEVER work. Unless a song has no bpm changes. So VSlice, Codename, or Kade are the choices.
		btnY++;
		btnY += 20;
		var btn:PsychUIButton = new PsychUIButton(btnX, btnY, '  O!M to Psych...', function()
		{
			if(!fileDialog.completed) return;
			upperBox.isMinimized = true;
			upperBox.bg.visible = false;

			fileDialog.open('*.osu*', 'Open an Osu!Mania chart file', function()
			{
				try
				{
					// Subdivision: number of subdivisions per beat.
					// 16 => sixteenth notes (1/16), 4 => quarter-beat quantization (existing behavior)
					final SUBDIV:Int = 16;
					final MAX_BEATS_PER_SECTION:Int = 4;
					final MAX_ROWS_PER_SECTION:Int = MAX_BEATS_PER_SECTION * SUBDIV;
				
					// Parse osu chart
					var osuChart = new OsuMania().fromOsu(fileDialog.data);
					if(osuChart == null)
					{
						showOutput('Error: Invalid Osu!Mania chart format.', true);
						return;
					}
				
					var diffName = osuChart.diffs[0];
					showOutput('Converting difficulty: ${diffName}...');
				
					var chartMeta = osuChart.getChartMeta();
					var osuNotes = osuChart.getNotes(diffName);
				
					// lane mapping -> 4k psych lanes
					var laneCount = chartMeta.extraData.get(LANES_LENGTH) ?? 4;
					showOutput('Detected ${laneCount}K chart');
				
					var notesArray = [];
					for (note in osuNotes) {
						var lane = note.lane;
					
						if (laneCount == 4) {
							lane = note.lane;
						} else if (laneCount == 6) {
							if (note.lane < 2) lane = 0;
							else if (note.lane >= 4) lane = 3;
							else lane = note.lane - 1;
						} else if (laneCount == 8) {
							lane = Math.floor(note.lane / 2);
						} else {
							lane = Math.floor(note.lane * 4 / laneCount);
						}
					
						notesArray.push({
							t: note.time,
							d: lane,
							l: note.length,
							k: note.type == "" ? "normal" : note.type
						});
					}
				
					showOutput('Processed ${notesArray.length} notes');
				
					// Collect BPM changes from osu metadata
					var bpmChanges = chartMeta.bpmChanges.copy();
					bpmChanges.sort((a, b) -> Std.int(a.time - b.time));
				
					// Ensure there's a BPM change at time 0
					if (bpmChanges.length == 0 || bpmChanges[0].time > 0) {
						bpmChanges.unshift({
							time: 0,
							bpm: bpmChanges.length > 0 ? bpmChanges[0].bpm : 100,
							beatsPerMeasure: 4,
							stepsPerBeat: 4
						});
					}
				
					showOutput('Found ${bpmChanges.length} BPM changes (including initial BPM)');
				
					// Build temporary V-Slice chart + metadata JSON (so we can reuse VSlice.convertToPsych)
					var chartJson = '{
						"version": "${FNFVSlice.VSLICE_CHART_VERSION}",
						"generatedBy": "OsuConverterTool",
						"scrollSpeed": {
							"${diffName}": ${chartMeta.scrollSpeeds.get(diffName) ?? 1.0}
						},
						"notes": {
							"${diffName}": ${haxe.Json.stringify(notesArray)}
						},
						"events": []
					}';
				
					var metadataJson = '{
						"version": "${FNFVSlice.VSLICE_META_VERSION}",
						"timeFormat": "ms",
						"artist": "${StringTools.replace(chartMeta.extraData.get(SONG_ARTIST) ?? "Unknown Artist", '"', '\\"')}",
						"charter": "${StringTools.replace(chartMeta.extraData.get(SONG_CHARTER) ?? "Unknown Charter", '"', '\\"')}",
						"generatedBy": "OsuConverterTool",
						"playData": {
							"characters": {
								"player": "${chartMeta.extraData.get(PLAYER_1) ?? "bf"}",
								"opponent": "${chartMeta.extraData.get(PLAYER_2) ?? "dad"}",
								"girlfriend": "${chartMeta.extraData.get(PLAYER_3) ?? "gf"}"
							},
							"difficulties": ["${diffName}"],
							"songVariations": [],
							"noteStyle": "funkin",
							"stage": "${chartMeta.extraData.get(STAGE) ?? "stage"}"
						},
						"songName": "${StringTools.replace(chartMeta.title, '"', '\\"')}",
						"offsets": {
							"vocals": {},
							"instrumental": ${chartMeta.offset},
							"altInstrumentals": {},
							"altVocals": {}
						},
						"timeChanges": ${haxe.Json.stringify(bpmChanges)}
					}';
				
					var chart:VSliceChart = cast Json.parse(chartJson);
					var metadata:VSliceMetadata = cast Json.parse(metadataJson);
				
					// Convert via VSlice to Psych
					var pack:PsychPackage = VSlice.convertToPsych(chart, metadata);
					if(pack == null || pack.difficulties == null || !pack.difficulties.keys().hasNext())
					{
						showOutput('Error: Conversion failed - no difficulties created.', true);
						return;
					}
				
					// Helper: crochet (ms per beat)
					function crochetMs(bpm:Float):Float {
						return 60000.0 / bpm;
					}
				
					// For each generated difficulty, convert BPM map into sections (max 4 beats each, quantized to SUBDIV)
					var diffs:Array<String> = [for(k in pack.difficulties.keys()) k];
					for (diffKey in diffs) {
						var psychChart:SwagSong = cast(pack.difficulties.get(diffKey));
						if (psychChart == null) continue;
					
						psychChart.format = "skydecay_beta";
					
						// Set base BPM
						psychChart.bpm = bpmChanges[0].bpm;
					
						// Build flatNotes from psychChart (if any already present)
						var flatNotes:Array<Dynamic> = [];
						if (psychChart.notes != null) {
							for (sec in psychChart.notes) {
								if (sec == null || sec.sectionNotes == null) continue;
								for (n in sec.sectionNotes) if (n != null) flatNotes.push(n);
							}
						} else {
							var maybeSectionNotes = Reflect.field(cast psychChart, 'sectionNotes');
							if (maybeSectionNotes != null) {
								if (Std.is(maybeSectionNotes, Array)) {
									for (n in cast (maybeSectionNotes, Array<Dynamic>)) if (n != null) flatNotes.push(n);
								} else {
									for (key in Reflect.fields(maybeSectionNotes)) {
										var v = Reflect.field(maybeSectionNotes, key);
										if (v != null) flatNotes.push(v);
									}
								}
							}
						}
					
						// Determine last note time
						var lastNoteTime:Float = 0;
						for (n in flatNotes) {
							if (n == null) continue;
							var ttmp:Float = cast(n[0], Float);
							if (ttmp > lastNoteTime) lastNoteTime = ttmp;
						}
					
						// Build sections from bpmChanges, splitting any interval > 4 beats into multiple <= 4-beat sections.
						var newSections:Array<SwagSection> = [];
						for (i in 0...bpmChanges.length) {
							var startTime:Float = bpmChanges[i].time;
							var bpm:Float = bpmChanges[i].bpm;
							var nextTime:Float = (i + 1 < bpmChanges.length) ? bpmChanges[i+1].time : (Math.max(lastNoteTime, startTime) + crochetMs(bpm) * MAX_BEATS_PER_SECTION);
							if (nextTime <= startTime) nextTime = startTime + crochetMs(bpm) * MAX_BEATS_PER_SECTION;
						
							var rawBeats:Float = (nextTime - startTime) / crochetMs(bpm);
							// total rows in SUBDIV units
							var rowsTotal:Int = Std.int(Math.max(1, Math.round(rawBeats * SUBDIV)));
						
							// split into chunks where each chunk <= MAX_ROWS_PER_SECTION
							while (rowsTotal > 0) {
								var rowsThis:Int = Std.int(Math.min(rowsTotal, MAX_ROWS_PER_SECTION));
								var sectionBeats:Float = (rowsThis / SUBDIV);
							
								newSections.push({
									sectionNotes: [],
									sectionBeats: sectionBeats,
									mustHitSection: true,
									bpm: bpm,
									changeBPM: true,
									altAnim: false,
									gfSection: false
								});
							
								rowsTotal -= rowsThis;
							}
						}
					
						// fallback single section if none
						if (newSections.length == 0) {
							newSections.push({
								sectionNotes: [],
								sectionBeats: 4.0,
								mustHitSection: true,
								bpm: psychChart.bpm,
								changeBPM: false,
								altAnim: false,
								gfSection: false
							});
						}
					
						// Assign existing flat notes into sections by time
						for (n in flatNotes) {
							if (n == null) continue;
							var t:Float = cast(n[0], Float);
							var secStart:Float = (bpmChanges.length > 0) ? bpmChanges[0].time : 0;
							var assigned:Bool = false;
						
							for (s in 0...newSections.length) {
								var sec = newSections[s];
								var secBpm:Float = sec.bpm;
								var secCrochet:Float = crochetMs(secBpm);
								var secDuration:Float = sec.sectionBeats * secCrochet;
								var secEnd:Float = secStart + secDuration;
							
								if (t >= secStart - 0.000001 && t < secEnd - 0.000001) {
									sec.sectionNotes.push(n);
									assigned = true;
									break;
								}
								secStart = secEnd;
							}
						
							if (!assigned && newSections.length > 0) {
								// rounding drift: put in last section
								newSections[newSections.length - 1].sectionNotes.push(n);
							}
						}
					
						// Recompute last section to cover lastNoteTime (adjust in SUBDIV granularity)
						if (flatNotes.length > 0 && newSections.length > 0) {
							var totalStart:Float = (bpmChanges.length > 0) ? bpmChanges[0].time : 0;
							var accum:Float = totalStart;
							for (s in 0...newSections.length - 1) {
								var ssec = newSections[s];
								accum += ssec.sectionBeats * crochetMs(ssec.bpm);
							}
							var lastSec = newSections[newSections.length - 1];
							var lastBpm:Float = lastSec.bpm;
							var desiredEnd:Float = Math.max(lastNoteTime + crochetMs(lastBpm), accum + lastSec.sectionBeats * crochetMs(lastBpm));
							var remainingMs:Float = desiredEnd - accum;
							if (remainingMs > 0) {
								var rowsNeeded:Int = Std.int(Math.max(1, Math.round((remainingMs / crochetMs(lastBpm)) * SUBDIV)));
								lastSec.sectionBeats = (rowsNeeded / SUBDIV);
							}
						}
					
						// Replace psychChart sections and clear BPM-change events
						psychChart.notes = newSections;
					
						if (psychChart.events != null) {
							var filteredEvents:Array<Dynamic> = [];
							for (ev in psychChart.events) {
								if (ev == null) continue;
								var eName:String = '';
								if (ev.length > 1 && ev[1] != null && ev[1].length > 0 && ev[1][0] != null && ev[1][0][0] != null) {
									eName = ev[1][0][0];
								}
								if (eName == "BPM Change") {
									// skip
								} else filteredEvents.push(ev);
							}
							psychChart.events = filteredEvents;
						}
					
						// Fill other chart fields from metadata
						psychChart.song = chartMeta.title;
						psychChart.player1 = chartMeta.extraData.get(PLAYER_1) ?? "bf";
						psychChart.player2 = chartMeta.extraData.get(PLAYER_2) ?? "dad";
						psychChart.gfVersion = chartMeta.extraData.get(PLAYER_3) ?? "gf";
						psychChart.stage = chartMeta.extraData.get(STAGE) ?? "stage";
						psychChart.speed = chartMeta.scrollSpeeds.get(diffName) ?? 2.5;
						psychChart.offset = chartMeta.offset;
						psychChart.needsVoices = true;
					
						// Add artist/charter as informational events at time 0
						if (chartMeta.extraData.exists(SONG_ARTIST)) {
							if (psychChart.events == null) psychChart.events = [];
							psychChart.events.push([0, [["Song Credit", "Artist: " + chartMeta.extraData.get(SONG_ARTIST)]]]);
						}
						if (chartMeta.extraData.exists(SONG_CHARTER)) {
							if (psychChart.events == null) psychChart.events = [];
							psychChart.events.push([0, [["Song Credit", "Charter: " + chartMeta.extraData.get(SONG_CHARTER)]]]);
						}
					}
				
					// Save converted charts to directory
					fileDialog.openDirectory('Save Converted Psych JSONs', function()
					{
						var path:String = fileDialog.path.replace('\\', '/');
						if(!path.endsWith('/')) path += '/';
					
						var diffsToSave:Array<String> = metadata.playData.difficulties.copy();
						var defaultDiff:String = Paths.formatToSongPath(Difficulty.getDefault());
					
						function nextChart()
						{
							while(diffsToSave.length > 0)
							{
								var diffNameToSave:String = diffsToSave[0];
								diffsToSave.remove(diffNameToSave);
								if(!pack.difficulties.exists(diffNameToSave)) continue;
							
								var diffPostfix:String = (diffNameToSave != defaultDiff) ? '-$diffNameToSave' : '';
								var chartData:SwagSong = pack.difficulties.get(diffNameToSave);
								var chartName:String = Paths.formatToSongPath(chartData.song) + diffPostfix + '.json';
							
								// Create folder for song
								var songDir = path + Paths.formatToSongPath(chartData.song) + '/';
								if(!FileSystem.exists(songDir)) FileSystem.createDirectory(songDir);
							
								showOutput('Saving chart: ${chartName}');
								overwriteCheck(songDir + chartName, chartName, PsychJsonPrinter.print(chartData, ['sectionNotes', 'events']), nextChart, true);
								return;
							}
						
							if(overwriteSavedSomething)
								showOutput('Files saved successfully to: ${fileDialog.path}!');
						}
					
						overwriteSavedSomething = false;
						nextChart();
					});
				}
				catch(e:Exception)
				{
					showOutput('Error during conversion: ${e.message}', true);
					trace(e.stack);
				}
			});
		},btnWid);
		btn.text.alignment = LEFT;
		tab_group.add(btn);
		
		// StepMania (.sm) to Psych Button
		// btnY += 20;
		/* var btnSM:PsychUIButton = new PsychUIButton(btnX, btnY, '  SM to Psych...', function()
		{
		    if(!fileDialog.completed) return;
		    upperBox.isMinimized = true;
		    upperBox.bg.visible = false;
	
		    fileDialog.open('chart.sm', 'Open a StepMania chart file', function()
		    {
		        try
		        {
		            var fnf:FNFVSlice = new FNFVSlice();
		            var smChart = new StepMania().fromStepMania(fileDialog.data);
				
		            if(smChart == null)
		            {
		                showOutput('Error: Invalid StepMania chart format.', true);
		                return;
		            }
				
		            var convertedChart = fnf.fromFormat(smChart);
				
		            if(convertedChart == null || convertedChart.data == null || convertedChart.data.song == null)
		            {
		                showOutput('Error: Failed to convert StepMania chart.', true);
		                return;
		            }
				
		            // StepMania files often contain multiple difficulties
		            var difficulties:Map<String, SwagSong> = new Map();
		            var songName:String = "";
				
		            // Try to extract multiple difficulties
		            var psychChart:SwagSong = cast convertedChart.data.song;
		            psychChart.format = 'skydecay_beta';
		            Song.convert(psychChart);
		            songName = Paths.formatToSongPath(psychChart.song);
				
		            // Check if we have multiple difficulties in the NOTES map
		            if(smChart.data != null && smChart.data.NOTES != null)
		            {
		                for(diffName in smChart.data.NOTES.keys())
		                {
		                    // Try to get a specific difficulty by creating a new conversion
		                    var diffChart = new StepMania().fromStepMania(fileDialog.data, diffName);
		                    var diffConverted = fnf.fromFormat(diffChart);
						
		                    if(diffConverted != null && diffConverted.data != null && diffConverted.data.song != null)
		                    {
		                        var diffSong:SwagSong = cast diffConverted.data.song;
		                        diffSong.format = 'skydecay_beta';
		                        Song.convert(diffSong);
		                        difficulties.set(diffName, diffSong);
		                    }
		                }
		            }
				
		            // Default to using the first conversion if no specific difficulties were found
		            if(difficulties.keys().hasNext() == false)
		            {
		                difficulties.set("normal", psychChart);
		            }
				
		            fileDialog.openDirectory('Save Converted Psych JSONs', function()
		            {
		                var path:String = fileDialog.path.replace('\\', '/');
		                if(!path.endsWith('/')) path += '/';
					
		                // Make sure the directory exists
		                var songDir = path + songName + '/';
		                if(!FileSystem.exists(songDir))
		                    FileSystem.createDirectory(songDir);
					
		                var diffArray:Array<String> = [for(k in difficulties.keys()) k];
		                function nextChart()
		                {
		                    while(diffArray.length > 0)
		                    {
		                        var diffName:String = diffArray[0];
		                        diffArray.remove(diffName);
		                        if(!difficulties.exists(diffName)) continue;
	
		                        var diffPostfix:String = (diffName != "normal") ? '-$diffName' : '';
		                        var chartData:SwagSong = difficulties.get(diffName);
		                        var chartName:String = songName + diffPostfix + '.json';
		                        overwriteCheck(songDir + chartName, chartName, PsychJsonPrinter.print(chartData, ['sectionNotes', 'events']), nextChart, true);
		                        return;
		                    }
	
		                    if(overwriteSavedSomething)
		                        showOutput('Files saved successfully to: $songDir!');
		                }
					
		                overwriteSavedSomething = false;
		                nextChart();
		            });
		        }
		        catch(e:Exception)
		        {
		            showOutput('Error: ${e.message}', true);
		            trace(e.stack);
		        }
		    });
		},btnWid);
		btnSM.text.alignment = LEFT;
		tab_group.add(btnSM); */

		btnY++;
		btnY += 20;
		var btn:PsychUIButton = new PsychUIButton(btnX, btnY, '  Preview (F5)', openEditorPlayState, btnWid);
		btn.text.alignment = LEFT;
		tab_group.add(btn);
		
		btnY += 20;
		var btn:PsychUIButton = new PsychUIButton(btnX, btnY, '  Playtest (Enter)', goToPlayState, btnWid);
		btn.text.alignment = LEFT;
		tab_group.add(btn);

		btnY++;
		btnY += 20;
		var btn:PsychUIButton = new PsychUIButton(btnX, btnY, '  Exit', goToMasterMenu,btnWid);
		btn.text.alignment = LEFT;
		tab_group.add(btn);
	}

	var lockedEvents:Bool = false;
	function addEditTab()
	{
		var tab = upperBox.getTab('Edit');
		var tab_group = tab.menu;
		var btnX = tab.x - upperBox.x;
		var btnY = 1;
		var btnWid = Std.int(tab.width);

		var btn:PsychUIButton = new PsychUIButton(btnX, btnY, '  Undo', undo, btnWid);
		btn.text.alignment = LEFT;
		tab_group.add(btn);

		btnY += 20;
		var btn:PsychUIButton = new PsychUIButton(btnX, btnY, '  Redo', redo, btnWid);
		btn.text.alignment = LEFT;
		tab_group.add(btn);

		btnY++;
		btnY += 20;
		var btn:PsychUIButton = new PsychUIButton(btnX, btnY, '  Select All', function()
		{
			var sel = selectedNotes;
			selectedNotes = curRenderedNotes.members.copy();
			addUndoAction(SELECT_NOTE, {old: sel, current: selectedNotes.copy()});
			onSelectNote();
			trace('Notes selected: ' + selectedNotes.length);
		}, btnWid);
		btn.text.alignment = LEFT;
		tab_group.add(btn);

		if(SHOW_EVENT_COLUMN)
		{
			btnY++;
			btnY += 20;
			var btn:PsychUIButton = new PsychUIButton(btnX, btnY, '  Lock Events', btnWid);
			btn.onClick = function()
			{
				lockedEvents = !lockedEvents;
				if(lockedEvents) btn.text.text = '  Unlock Events';
				else btn.text.text = '  Lock Events';
				eventLockOverlay.visible = lockedEvents;
	
				if(selectedNotes.length >= 1)
				{
					var sel = selectedNotes;
					var onlyNotes = selectedNotes.filter((note:MetaNote) -> !note.isEvent);
					resetSelectedNotes();
					selectedNotes = onlyNotes;
					addUndoAction(SELECT_NOTE, {old: sel, current: selectedNotes.copy()});
					if(selectedNotes.length == 1) onSelectNote();
				}
				softReloadNotes();
			};
			btn.text.alignment = LEFT;
			tab_group.add(btn);
		}
		
		btnY++;
		btnY += 20;
		var btn:PsychUIButton = new PsychUIButton(btnX, btnY, '  Autosave Settings...', btnWid);
		btn.onClick = function()
		{
			upperBox.isMinimized = true;
			upperBox.bg.visible = false;
			openSubState(new BasePrompt(400, 160, 'Autosave Settings',
				function(state:BasePrompt)
				{
					var btn:PsychUIButton = new PsychUIButton(state.bg.x + state.bg.width - 40, state.bg.y, 'X', state.close, 40);
					btn.cameras = state.cameras;
					state.add(btn);

					var checkbox:PsychUICheckBox = null;
					var timeStepper:PsychUINumericStepper = null;

					timeStepper = new PsychUINumericStepper(state.bg.x + 50, state.bg.y + 90, 1, autoSaveCap, 1, 30, 0);
					timeStepper.onValueChange = function() {
						autoSaveTime = 0;
						checkbox.checked = true;
						autoSaveCap = chartEditorSave.data.autoSave = Std.int(timeStepper.value);
					};
					timeStepper.cameras = state.cameras;

					checkbox = new PsychUICheckBox(timeStepper.x + 80, timeStepper.y, 'Enabled', 60, function() {
						autoSaveTime = 0;
						autoSaveCap = chartEditorSave.data.autoSave = checkbox.checked ? Std.int(timeStepper.value) : 0;
					});
					checkbox.checked = (autoSaveCap > 0);
					checkbox.cameras = state.cameras;
					
					var maxFileStepper:PsychUINumericStepper = new PsychUINumericStepper(checkbox.x + 140, checkbox.y, 1, backupLimit, 0, 50, 0);
					maxFileStepper.onValueChange = function() {
						autoSaveTime = 0;
						checkbox.checked = true;
						chartEditorSave.data.backupLimit = backupLimit = Std.int(maxFileStepper.value);
					};
					maxFileStepper.cameras = state.cameras;

					var txt1:FlxText = new FlxText(timeStepper.x, timeStepper.y - 15, 100, 'Time (in minutes):');
					txt1.cameras = state.cameras;
					var txt2:FlxText = new FlxText(maxFileStepper.x, maxFileStepper.y - 15, 100, 'File Limit:');
					txt2.cameras = state.cameras;

					state.add(txt1);
					state.add(txt2);
					state.add(checkbox);
					state.add(timeStepper);
					state.add(maxFileStepper);
				}
			));

		};
		btn.text.alignment = LEFT;
		tab_group.add(btn);

		btnY++;
		btnY += 20;
		var btn:PsychUIButton = new PsychUIButton(btnX, btnY, '  Clear All Notes', function()
		{
			var func:Void->Void = function()
			{
				resetSelectedNotes();
				addUndoAction(DELETE_NOTE, {notes: notes.copy()});
				notes = [];
				loadSection();
			}

			if(!ignoreProgressCheckBox.checked) openSubState(new Prompt('Delete all Notes in the song?', func));
			else func();
		}, btnWid);
		btn.normalStyle.bgColor = FlxColor.RED;
		btn.normalStyle.textColor = FlxColor.WHITE;
		btn.text.alignment = LEFT;
		tab_group.add(btn);

		if(SHOW_EVENT_COLUMN)
		{
			btnY += 20;
			var btn:PsychUIButton = new PsychUIButton(btnX, btnY, '  Clear All Events', function()
			{
				var func:Void->Void = function()
				{
					resetSelectedNotes();
					addUndoAction(DELETE_NOTE, {events: events.copy()});
					events = [];
					loadSection();
				}
	
				if(!ignoreProgressCheckBox.checked) openSubState(new Prompt('Delete all Events in the song?', func));
				else func();
			}, btnWid);
			btn.normalStyle.bgColor = FlxColor.RED;
			btn.normalStyle.textColor = FlxColor.WHITE;
			btn.text.alignment = LEFT;
			tab_group.add(btn);
		}
	}

	var downScrollButton:PsychUIButton;
	var showLastGridButton:PsychUIButton;
	var showNextGridButton:PsychUIButton;
	var noteTypeLabelsButton:PsychUIButton;
	function addViewTab()
	{
		var tab = upperBox.getTab('View');
		var tab_group = tab.menu;
		var btnX = tab.x - upperBox.x;
		var btnY = 1;
		var btnWid = Std.int(tab.width);

		if(chartEditorSave.data.waveformEnabled != null)
			waveformEnabled = chartEditorSave.data.waveformEnabled;
		if(chartEditorSave.data.waveformTarget != null)
			waveformTarget = chartEditorSave.data.waveformTarget;
		if(chartEditorSave.data.waveformColor != null)
			waveformSprite.color = CoolUtil.colorFromString(chartEditorSave.data.waveformColor);
		if(chartEditorSave.data.waveformAlpha != null)
			waveformSprite.alpha = chartEditorSave.data.waveformAlpha;

		showLastGridButton = new PsychUIButton(btnX, btnY, '', function()
		{
			showPreviousSection = !showPreviousSection;
			updateGridVisibility();
		}, btnWid);
		showLastGridButton.text.alignment = LEFT;
		tab_group.add(showLastGridButton);

		btnY += 20;
		showNextGridButton = new PsychUIButton(btnX, btnY, '', function()
		{
			showNextSection = !showNextSection;
			updateGridVisibility();
		}, btnWid);
		showNextGridButton.text.alignment = LEFT;
		tab_group.add(showNextGridButton);

		btnY++;
		btnY += 20;
		noteTypeLabelsButton = new PsychUIButton(btnX, btnY, '', function()
		{
			showNoteTypeLabels = !showNoteTypeLabels;
			updateGridVisibility();
		}, btnWid);
		noteTypeLabelsButton.text.alignment = LEFT;
		tab_group.add(noteTypeLabelsButton);

		btnY++;
		btnY += 20;
		downScrollButton = new PsychUIButton(btnX, btnY, downScroll ? '  Downscroll ON' : '  Downscroll OFF', function()
		{
			downScroll = !downScroll;
			chartEditorSave.data.downScroll = downScroll;
			downScrollButton.text.text = downScroll ? '  Downscroll ON' : '  Downscroll OFF';
			trace('Downscroll: ' + (downScroll ? 'ON' : 'OFF'));
			scrollDirectionUpdated();
		}, btnWid);
		downScrollButton.text.alignment = LEFT;
		tab_group.add(downScrollButton);

		btnY++;
		btnY += 20;
		var btn:PsychUIButton = new PsychUIButton(btnX, btnY, '  Waveform...', function()
		{
			ClientPrefs.toggleVolumeKeys(false);
			openSubState(new BasePrompt(320, 215, 'Waveform Settings',
				function(state:BasePrompt) {
					upperBox.isMinimized = true;
					upperBox.bg.visible = false;

					var btn:PsychUIButton = new PsychUIButton(state.bg.x + state.bg.width - 40, state.bg.y, 'X', state.close, 40);
					btn.cameras = state.cameras;
					state.add(btn);

					var check:PsychUICheckBox = new PsychUICheckBox(state.bg.x + 40, state.bg.y + 80, 'Enabled', 60);
					check.onClick = function()
					{
						chartEditorSave.data.waveformEnabled = waveformEnabled = check.checked;
						updateWaveform();
					};
					check.cameras = state.cameras;
					check.checked = waveformEnabled;
					state.add(check);

					var waveformC:String = '0000FF';
					if(chartEditorSave.data.waveformColor != null)
						waveformC = chartEditorSave.data.waveformColor;

					var input:PsychUIInputText = new PsychUIInputText(check.x, check.y + 42, 60, waveformC, 10);
					input.onChange = function(old:String, cur:String)
					{
						chartEditorSave.data.waveformColor = cur;
						waveformSprite.color = CoolUtil.colorFromString(cur);
					}
					input.maxLength = 6;
					input.filterMode = ONLY_HEXADECIMAL;
					input.cameras = state.cameras;
					input.forceCase = UPPER_CASE;
					
					state.add(new FlxText(check.x, input.y + 25, 80, 'Opacity:'));
					var alphaStepper:PsychUINumericStepper = new PsychUINumericStepper(check.x, input.y + 40, 0.1, 1, 0, 1, 2, true);
					alphaStepper.onValueChange = function() {
						var alpha:Float = alphaStepper.value;
						chartEditorSave.data.waveformAlpha = alpha;
						waveformSprite.alpha = alpha;
					};
					alphaStepper.value = waveformSprite.alpha;
					alphaStepper.cameras = state.cameras;
					state.add(alphaStepper);

					var options:Array<WaveformTarget> = [INST, PLAYER, OPPONENT, EVERYTHING];
					var radioGrp:PsychUIRadioGroup = new PsychUIRadioGroup(check.x + 120, check.y, ['Instrumental', 'Main Vocals', 'Opponent Vocals', 'Every Track']);
					radioGrp.cameras = state.cameras;
					radioGrp.onClick = function()
					{
						waveformTarget = chartEditorSave.data.waveformTarget = options[radioGrp.checked];
						updateWaveform();
					};
					radioGrp.checked = options.indexOf(waveformTarget);
					state.add(radioGrp);

					var txt1:FlxText = new FlxText(input.x, input.y - 15, 80, 'Color (Hex):');
					txt1.cameras = state.cameras;
					state.add(txt1);
					state.add(input);
				}
			));
		}, btnWid);
		btn.text.alignment = LEFT;
		tab_group.add(btn);

		btnY += 20;
		var btn:PsychUIButton = new PsychUIButton(btnX, btnY, '  Go to...', function()
		{
			upperBox.isMinimized = true;
			upperBox.bg.visible = false;
			openSubState(new BasePrompt(420, 200, 'Go to Time/Section:',
				function(state:BasePrompt)
				{
					var curTime:Float = Conductor.songPosition;
					var currentSec:Int = curSec;

					var timeStepper:PsychUINumericStepper = new PsychUINumericStepper(state.bg.x + 100, state.bg.y + 90, 1, Math.floor(curTime)/1000, 0, FlxG.sound.music.length/1000 - 0.01, 2, 80);
					timeStepper.cameras = state.cameras;
					var sectionStepper:PsychUINumericStepper = new PsychUINumericStepper(timeStepper.x + 160, timeStepper.y, 1, currentSec, 0, PlayState.SONG.notes.length - 1, 0);
					sectionStepper.cameras = state.cameras;

					var txt1:FlxText = new FlxText(timeStepper.x, timeStepper.y - 15, 100, 'Time (in seconds):');
					var txt2:FlxText = new FlxText(sectionStepper.x, sectionStepper.y - 15, 100, 'Section:');
					txt1.cameras = state.cameras;
					txt2.cameras = state.cameras;
					state.add(txt1);
					state.add(txt2);
					state.add(timeStepper);
					state.add(sectionStepper);

					var timeTxt:FlxText = new FlxText(15, state.bg.y + state.bg.height - 75, 230, '', 16);
					timeTxt.alignment = CENTER;
					timeTxt.screenCenter(X);
					timeTxt.cameras = state.cameras;
					state.add(timeTxt);
					function updateTime()
					{
						var tm:String = FlxStringUtil.formatTime(curTime / 1000, true);
						var ln:String = FlxStringUtil.formatTime(FlxG.sound.music.length / 1000, true);
						timeTxt.text = '$tm / $ln';
					}
					updateTime();

					timeStepper.onValueChange = function()
					{
						curTime = timeStepper.value * 1000;
						for (i => time in cachedSectionTimes)
						{
							if(time <= curTime)
								currentSec = i;
							else break;
						}
						updateTime();
					};
					sectionStepper.onValueChange = function()
					{
						currentSec = Std.int(sectionStepper.value);
						curTime = cachedSectionTimes[currentSec] + 0.000001;
						updateTime();
					};

					var btn:PsychUIButton = new PsychUIButton(0, timeTxt.y + 30, 'Go To', function()
					{
						curSec = currentSec;
						FlxG.sound.music.time = FlxMath.bound(curTime, 0, FlxG.sound.music.length - 1);
						loadSection();
						state.close();
					});
					btn.cameras = state.cameras;
					btn.screenCenter(X);
					btn.x -= 60;
					state.add(btn);

					var btn:PsychUIButton = new PsychUIButton(0, btn.y, 'Cancel', state.close);
					btn.cameras = state.cameras;
					btn.screenCenter(X);
					btn.x += 60;
					state.add(btn);
				}
			));
		}, btnWid);
		btn.text.alignment = LEFT;
		tab_group.add(btn);

		btnY++;
		btnY += 20;
		var btn:PsychUIButton = new PsychUIButton(btnX, btnY, '  Theme...', function()
		{
			if(!fileDialog.completed) return;
			upperBox.isMinimized = true;
			upperBox.bg.visible = false;

			openSubState(new BasePrompt(500, 260, 'Chart Editor Theme',
				function(state:BasePrompt)
				{
					var btn:PsychUIButton = new PsychUIButton(state.bg.x + state.bg.width - 40, state.bg.y, 'X', state.close, 40);
					btn.cameras = state.cameras;
					state.add(btn);

					var btnY = 320;
					var btn:PsychUIButton = new PsychUIButton(0, btnY, 'Light', changeTheme.bind(LIGHT));
					btn.screenCenter(X);
					btn.x -= 180;
					btn.cameras = state.cameras;
					state.add(btn);
			
					var btn:PsychUIButton = new PsychUIButton(0, btnY, 'Dark', changeTheme.bind(DARK));
					btn.screenCenter(X);
					btn.x -= 60;
					btn.cameras = state.cameras;
					state.add(btn);
					
					var btn:PsychUIButton = new PsychUIButton(0, btnY, 'Default', changeTheme.bind(DEFAULT));
					btn.screenCenter(X);
					btn.cameras = state.cameras;
					btn.x += 60;
					state.add(btn);
			
					var btn:PsychUIButton = new PsychUIButton(0, btnY, 'V-Slice', changeTheme.bind(VSLICE));
					btn.screenCenter(X);
					btn.x += 180;
					btn.cameras = state.cameras;
					state.add(btn);

					btnY += 60;
					var btn:PsychUIButton = new PsychUIButton(0, btnY, 'Custom', changeTheme.bind(CUSTOM));
					btn.screenCenter(X);
					btn.x -= 180;
					btn.cameras = state.cameras;
					state.add(btn);

					var customBgC:String = '303030';
					if (chartEditorSave.data.customBgColor != null)
						customBgC = chartEditorSave.data.customBgColor;
					
					var checkbox:PsychUICheckBox = new PsychUICheckBox(btn.x, btnY + 60, 'Textured Hold Notes', 200);
					checkbox.onClick = function() {
						chartEditorSave.data.texturedSustains = checkbox.checked;
						refreshSustains(checkbox.checked);
					}
					checkbox.checked = chartEditorSave.data.texturedSustains ?? true;
					checkbox.cameras = state.cameras;
					state.add(checkbox);

					var input:PsychUIInputText = new PsychUIInputText(0, btnY, 80, customBgC, 10);
					input.maxLength = 6;
					input.filterMode = ONLY_HEXADECIMAL;
					input.forceCase = UPPER_CASE;
					input.screenCenter(X);
					input.x -= 60;
					input.cameras = state.cameras;
					input.onChange = function(old:String, cur:String)
					{
						chartEditorSave.data.customBgColor = cur;
						changeTheme(CUSTOM);
					}

					var txt:FlxText = new FlxText(input.x, input.y - 15, 120, 'BG Color:');
					txt.cameras = state.cameras;
					state.add(txt);
					state.add(input);

					var customGridC:Array<String> = ['DFDFDF', 'BFBFBF'];
					if(chartEditorSave.data.customGridColors != null && chartEditorSave.data.customGridColors.length > 1)
						customGridC = chartEditorSave.data.customGridColors;

					var input:PsychUIInputText = new PsychUIInputText(0, btnY, 80, customGridC[0], 10);
					input.maxLength = 6;
					input.filterMode = ONLY_HEXADECIMAL;
					input.forceCase = UPPER_CASE;
					input.screenCenter(X);
					input.x += 60;
					input.cameras = state.cameras;
					input.onChange = function(old:String, cur:String)
					{
						chartEditorSave.data.customGridColors[0] = cur;
						changeTheme(CUSTOM);
					}

					var txt:FlxText = new FlxText(input.x, input.y - 15, 120, 'Grid Colors:');
					txt.cameras = state.cameras;
					state.add(txt);
					state.add(input);

					var input:PsychUIInputText = new PsychUIInputText(0, btnY + 30, 80, customGridC[1], 10);
					input.maxLength = 6;
					input.filterMode = ONLY_HEXADECIMAL;
					input.forceCase = UPPER_CASE;
					input.screenCenter(X);
					input.x += 60;
					input.cameras = state.cameras;
					input.onChange = function(old:String, cur:String)
					{
						chartEditorSave.data.customGridColors[1] = cur;
						changeTheme(CUSTOM);
					}
					state.add(input);

					var customGridOtherC:Array<String> = ['5F5F5F', '4A4A4A'];
					if(chartEditorSave.data.customNextGridColors != null && chartEditorSave.data.customNextGridColors.length > 1)
						customGridOtherC = chartEditorSave.data.customNextGridColors;

					var input:PsychUIInputText = new PsychUIInputText(0, btnY, 80, customGridOtherC[0], 10);
					input.maxLength = 6;
					input.filterMode = ONLY_HEXADECIMAL;
					input.forceCase = UPPER_CASE;
					input.screenCenter(X);
					input.x += 180;
					input.cameras = state.cameras;
					input.onChange = function(old:String, cur:String)
					{
						chartEditorSave.data.customNextGridColors[0] = cur;
						changeTheme(CUSTOM);
					}

					var txt:FlxText = new FlxText(input.x, input.y - 15, 120, 'Next Grid Colors:');
					txt.cameras = state.cameras;
					state.add(txt);
					state.add(input);

					var input:PsychUIInputText = new PsychUIInputText(0, btnY + 30, 80, customGridOtherC[1], 10);
					input.maxLength = 6;
					input.filterMode = ONLY_HEXADECIMAL;
					input.forceCase = UPPER_CASE;
					input.screenCenter(X);
					input.x += 180;
					input.cameras = state.cameras;
					input.onChange = function(old:String, cur:String)
					{
						chartEditorSave.data.customNextGridColors[1] = cur;
						changeTheme(CUSTOM);
					}
					state.add(input);
				}
			));
		}, btnWid);
		btn.text.alignment = LEFT;
		tab_group.add(btn);

		btnY += 20;
		var btn:PsychUIButton = new PsychUIButton(btnX, btnY, '  Reset UI Boxes', function()
		{
			mainBox.setPosition(mainBoxPosition.x, mainBoxPosition.y);
			infoBox.setPosition(infoBoxPosition.x, infoBoxPosition.y);
			UIEvent(PsychUIBox.DROP_EVENT, btn); //to force a save
		}, btnWid);
		btn.text.alignment = LEFT;
		tab_group.add(btn);
	}

	function updateChartData()
	{
		for (secNum => section in PlayState.SONG.notes)
			PlayState.SONG.notes[secNum].sectionNotes = [];

		notes.sort(PlayState.sortByTime);
		var noteSec:Int = 0;
		var nextSectionTime:Float = cachedSectionTimes[noteSec + 1];
		var curSectionTime:Float = cachedSectionTimes[noteSec];

		for (num => note in notes)
		{
			if(note == null) continue;

			while(cachedSectionTimes[noteSec + 1] <= note.strumTime)
			{
				noteSec++;
				nextSectionTime = cachedSectionTimes[noteSec + 1];
				curSectionTime = cachedSectionTimes[noteSec];
			}

			var arr:Array<Dynamic> = PlayState.SONG.notes[noteSec].sectionNotes;
			//trace('Added note with time ${note.songData[0]} at section $noteSec');
			arr.push(note.songData);
		}

		events.sort(PlayState.sortByTime);
		PlayState.SONG.events = [];
		for (event in events)
			PlayState.SONG.events.push(event.songData);
	}

	function saveChart(canQuickSave:Bool = true)
	{
		updateChartData();
		var chartData:String = PsychJsonPrinter.print(PlayState.SONG, ['sectionNotes', 'events']);
		if(canQuickSave && Song.chartPath != null)
		{
			File.saveContent(Song.chartPath, chartData);
			showOutput('Chart saved successfully to: ${Song.chartPath}');
		}
		else
		{
			var chartName:String = Paths.formatToSongPath(PlayState.SONG.song) + '.json';
			if(Song.chartPath != null) chartName = Song.chartPath.substr(Song.chartPath.lastIndexOf('/')).trim();
			fileDialog.save(chartName, chartData,
				function()
				{
					var newPath:String = fileDialog.path;
					Song.chartPath = newPath.replace('\\', '/');
					reloadNotesDropdowns();
					showOutput('Chart saved successfully to: $newPath');

				}, null, function() showOutput('Error on saving chart!', true));
		}
	}
	
	inline function getCurChartSection()
	{
		return PlayState.SONG.notes != null ? PlayState.SONG.notes[curSec] : null;
	}

	function updateNotesRGB()
	{
		PlayState.SONG.disableNoteRGB = noRGBCheckBox.checked;

		for (note in notes)
		{
			if(note == null) continue;

			note.rgbShader.enabled = !noRGBCheckBox.checked;
			if(note.rgbShader.enabled)
			{
				var data = backend.NoteTypesConfig.loadNoteTypeData(note.noteType);
				if(data == null || data.length < 1) continue;

				for (line in data)
				{
					var prop:String = line.property.join('.');
					if(prop == 'rgbShader.enabled')
						note.rgbShader.enabled = line.value;
				}
			}
		}

		for (note in strumLineNotes)
			note.rgbShader.enabled = !noRGBCheckBox.checked;
	}

	function updateGridVisibility()
	{
		showLastGridButton.text.text = showPreviousSection	? '  Hide Last Section' :  '  Show Last Section';
		showNextGridButton.text.text = showNextSection		? '  Hide Next Section' :  '  Show Next Section';

		prevGridBg.visible = (curSec > 0 && showPreviousSection);
		nextGridBg.visible = (curSec < PlayState.SONG.notes.length - 1 && showNextSection);
		
		noteTypeLabelsButton.text.text = showNoteTypeLabels ? '  Hide Note Labels' : '  Show Note Labels';
		for (num => text in MetaNote.noteTypeTexts)
			text.visible = showNoteTypeLabels;
		softReloadNotes();
	}
	
	function adaptNotes(oldBPMMap:Array<BPMChangeEvent>)
	{
		undoActions = [];
		setSongPlaying(false);
		notes.sort(PlayState.sortByTime);
		_cacheSections();
		
		var oldStep:Float = Conductor.getStep(Conductor.songPosition, oldBPMMap);
		
		for (num => note in notes) {
			if(note == null || (note.strumTime <= 0 && note.sustainLength <= 0)) continue;
			
			var oldStep:Float = Conductor.getStep(note.strumTime, oldBPMMap);
			var oldStepEnd:Float = Conductor.getStep(note.strumTime + note.sustainLength, oldBPMMap);
			
			note.setStrumTime(Conductor.stepToSeconds(oldStep));
			note.setSustainLength(Conductor.stepToSeconds(oldStepEnd) - note.strumTime, curZoom);
		}
		
		forEachRenderedNote((note:MetaNote) -> positionNoteYOnTime(note));
		
		var time:Float = Math.min(FlxG.sound.music.length - 1, Conductor.stepToSeconds(oldStep));
		
		Conductor.songPosition = time;
		FlxG.sound.music.time = time;
		forceDataUpdate = true;
		loadSection();
	}

	public function UIEvent(id:String, sender:Dynamic)
	{
		//trace(id, sender);
		switch(id)
		{
			case PsychUIButton.CLICK_EVENT | PsychUIDropDownMenu.CLICK_EVENT | PsychUIDropDownMenu.REVEAL_EVENT:
				ignoreClickForThisFrame = true;

			case PsychUIBox.CLICK_EVENT:
				ignoreClickForThisFrame = true;
				if(sender == upperBox) updateUpperBoxBg();

			case PsychUIBox.MINIMIZE_EVENT:
				if(sender == upperBox)
				{
					upperBox.bg.visible = !upperBox.isMinimized;
					updateUpperBoxBg();
				}

			case PsychUIBox.DROP_EVENT:
				chartEditorSave.data.mainBoxPosition = [mainBox.x, mainBox.y];
				chartEditorSave.data.infoBoxPosition = [infoBox.x, infoBox.y];
		}
	}

	function updateUpperBoxBg()
	{
		if(upperBox.selectedTab != null)
		{
			var menu = upperBox.selectedTab.menu;
			upperBox.bg.x = upperBox.x + upperBox.selectedIndex * (upperBox.width/upperBox.tabs.length);
			upperBox.bg.setGraphicSize(menu.width, menu.height + 21);
			upperBox.bg.updateHitbox();
		}
	}

	function openEditorPlayState()
	{
		if(FlxG.sound.music == null)
		{
			showOutput('Load a valid song to preview!', true);
			return;
		}
		setSongPlaying(false);
		chartEditorSave.flush(); //just in case a random crash happens before loading

		openSubState(new EditorPlayState(cast notes, [vocals, opponentVocals])); //aparently it also added downscroll in the other engine??
		upperBox.isMinimized = true;
		upperBox.visible = mainBox.visible = infoBox.visible = false;
	}

	function goToPlayState()
	{
		persistentUpdate = false;
		FlxG.mouse.visible = false;
		chartEditorSave.flush();

		setSongPlaying(false);
		updateChartData();
		StageData.loadDirectory(PlayState.SONG);
		LoadingState.loadAndSwitchState(new PlayState());
		ClientPrefs.toggleVolumeKeys(true);
	}

	function goToMasterMenu() // cause i hate using File and then Exit. Just use the mf keybind.
	{
		PlayState.chartingMode = false;
		MusicBeatState.switchState(new states.editors.MasterEditorMenu());
		FlxG.sound.playMusic(Paths.music('freakyMenu'));
		FlxG.mouse.visible = false;
	}
	
	override function openSubState(SubState:FlxSubState)
	{
		if(!persistentUpdate) setSongPlaying(false);
		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		ClientPrefs.toggleVolumeKeys(true);
		super.closeSubState();
		upperBox.isMinimized = true;
		upperBox.visible = mainBox.visible = infoBox.visible = true;
		upperBox.bg.visible = false;
		updateAudioVolume();
	}

	override function destroy()
	{
		Note.globalRgbShaders = [];
		backend.NoteTypesConfig.clearNoteTypesData();

		for (num => text in MetaNote.noteTypeTexts)
			text.destroy();

		MetaNote.noteTypeTexts = [];
		fileDialog.destroy();
		super.destroy();
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
	}
	
	function keyDown(event:KeyboardEvent) {
		if (!focusedOnEditor()) return;
		
		var eventKey:FlxKey = event.keyCode;
		
		var num:Int = keysArray.indexOf(eventKey);
		if (vortexInput && num != -1 && FlxG.keys.checkStatus(eventKey, JUST_PRESSED)) { // note placement
			_keysPressedBuffer[num] = true;
			
			var typeSelected:String = noteTypes[noteTypeDropDown.selectedIndex];
			if(typeSelected != null)
			{
				typeSelected = typeSelected.trim();
				if(typeSelected.length < 1) typeSelected = null;
			}
			
			var sectionStart:Float = cachedSectionTimes[curSec];
			var snapCrochet:Float = Conductor.crochet * 4 / curQuant;
			var strumTime:Float = Math.round((Conductor.songPosition - sectionStart) / snapCrochet) * snapCrochet + sectionStart;
			
			var deletedNotes:Array<MetaNote> = [];
			var addedNotes:Array<MetaNote> = [];
			
			trace('Vortex editor press at time: $strumTime');

			// Try to find a note to delete first
			var didDelete:Bool = false;
			for (note in curRenderedNotes) {
				if(note == null || note.isEvent) continue;
				
				var roundTime:Float = Math.round((note.strumTime - sectionStart) / snapCrochet) * snapCrochet + sectionStart;
				if (note.songData[1] == num && strumTime == roundTime) {
					deletedNotes.push(note);
					didDelete = true;
					break;
				}
			}

			// If no notes were found, add a new in its place
			if (!didDelete) {
				var didAdd:Bool = false;
				var noteSetupData:Array<Dynamic> = [strumTime, num, 0];
				var typeSelected:String = noteTypes[noteTypeDropDown.selectedIndex];
				if (typeSelected != null) noteSetupData.push(typeSelected.trim());

				var noteAdded:MetaNote = createNote(noteSetupData);
				for (num in sectionFirstNoteID...notes.length)
				{
					var note = notes[num];
					if(note.strumTime >= strumTime)
					{
						notes.insert(num, noteAdded);
						didAdd = true;
						break;
					}
				}
				if(!didAdd) notes.push(noteAdded);
				addedNotes.push(noteAdded);
				_heldNotes[num] = noteAdded;
				
				if (Conductor.songPosition > noteAdded.strumTime + .001 && FlxG.sound.music != null && FlxG.sound.music.playing)
					hitNote(noteAdded);
			}

			if (deletedNotes.length > 0) {
				for (note in deletedNotes)
				{
					if(selectedNotes.contains(note))
						selectedNotes.remove(note);
					notes.remove(note);
				}
				addUndoAction(DELETE_NOTE, {notes: deletedNotes});
			}
			if (addedNotes.length > 0)
				addUndoAction(ADD_NOTE, {notes: addedNotes});
			
			if (vortexMoved)
				resetSelectedNotes();
			for (note in addedNotes)
				selectedNotes.push(note);

			softReloadNotes(true);
			forceDataUpdate = true;
			vortexMoved = false;
		}
		
		function noteShift(strumTime:Float) {
			var addedNotes:Array<MetaNote> = [];
			for (num => held in _keysPressedBuffer) {
				if (held && _heldNotes[num] == null) {
					var noteSetupData:Array<Dynamic> = [strumTime, num, 0];
					var typeSelected:String = noteTypes[noteTypeDropDown.selectedIndex];
					if (typeSelected != null) noteSetupData.push(typeSelected.trim());
					
					var didAdd:Bool = false;
					var noteAdded:MetaNote = createNote(noteSetupData);
					for (num in sectionFirstNoteID...notes.length) {
						var note = notes[num];
						if (note.strumTime >= strumTime) {
							notes.insert(num, noteAdded);
							didAdd = true;
							break;
						}
					}
					if (!didAdd) notes.push(noteAdded);
					_heldNotes[num] = noteAdded;
					addedNotes.push(noteAdded);
					softReloadNotes(true);
				}
			}
			if (addedNotes.length > 0) {
				if (vortexMoved)
					resetSelectedNotes();
				for (note in addedNotes)
					selectedNotes.push(note);
				addUndoAction(ADD_NOTE, {notes: addedNotes});
			}
		}
		
		var vortexShifted:Bool = false;
		
		if (!FlxG.keys.pressed.CONTROL) {
			switch (eventKey) {
				case FlxKey.LEFT | FlxKey.RIGHT: // quant shift
					if (!vortexInput) return;
					if (eventKey == FlxKey.LEFT) {
						curQuant = quantizations[Std.int(Math.max(quantizations.indexOf(curQuant) - 1, 0))];
					} else {
						curQuant = quantizations[Std.int(Math.min(quantizations.indexOf(curQuant) + 1, quantizations.length - 1))];
					}
					forceDataUpdate = true;
					
				case FlxKey.Z | FlxKey.X: // zooming
					if (eventKey == FlxKey.Z) {
						curZoom = zoomList[Std.int(Math.max(zoomList.indexOf(curZoom) - 1, 0))];
					} else {
						curZoom = zoomList[Std.int(Math.min(zoomList.indexOf(curZoom) + 1, zoomList.length - 1))];
					}

					notes.sort(PlayState.sortByTime);
					forEachRenderedNote((note:MetaNote) -> {
						positionNoteYOnTime(note);
						note.updateSustainToZoom(curZoom);
					});
					
					loadSection();
					showOutput('Zoom: ${Math.round(curZoom * 100)}%');
					updateScrollY();
					
				case FlxKey.A | FlxKey.D:
					var shiftAdd:Int = (FlxG.keys.pressed.SHIFT ? 4 : 1);
					
					if(FlxG.sound.music.playing)
						setSongPlaying(false);
					
					var secStartTime:Null<Float> = cast cachedSectionTimes[curSec];
					var secCrochet:Null<Float> = cast cachedSectionCrochets[curSec];
					if (secStartTime == null || secCrochet == null) return;
					
					var snap:Float = curQuant / 4;
					var snapCrochet:Float = secCrochet / snap;
					noteShift(Math.round((Conductor.songPosition - secStartTime) / snapCrochet) * snapCrochet + secStartTime);
					
					if (eventKey == FlxKey.A) {
						if (curSec - shiftAdd < 0) shiftAdd = curSec;

						if (shiftAdd > 0)
							loadSection(curSec - shiftAdd);
						
						Conductor.songPosition = FlxG.sound.music.time = cachedSectionTimes[curSec] - Conductor.offset + 0.0001;
					} else {
						if (curSec + shiftAdd >= PlayState.SONG.notes.length) shiftAdd = PlayState.SONG.notes.length - curSec - 1;
						
						if (shiftAdd > 0)
							loadSection(curSec + shiftAdd);
						
						Conductor.songPosition = FlxG.sound.music.time = Math.min(FlxG.sound.music.length - 1, cachedSectionTimes[curSec] - Conductor.offset + 0.0001);
					}
					
					vortexShifted = true;
					
				case FlxKey.UP | FlxKey.PAGEUP | FlxKey.DOWN | FlxKey.PAGEDOWN: // quant scrolling
					if (!vortexInput) return;
					var page:Bool = (eventKey == FlxKey.PAGEUP || eventKey == FlxKey.PAGEDOWN);
					var up:Bool = ((eventKey == FlxKey.UP || eventKey == FlxKey.PAGEUP) == !downScroll);
					
					if (FlxG.sound.music.playing) setSongPlaying(false);
					
					var secStartTime:Null<Float> = cast cachedSectionTimes[curSec];
					var secCrochet:Null<Float> = cast cachedSectionCrochets[curSec];
					if (secStartTime == null || secCrochet == null) return;
					
					var snap:Float = (page ? 1 : (curQuant / 4));
					var snapCrochet:Float = secCrochet / snap;
					noteShift(Math.round((Conductor.songPosition - secStartTime) / snapCrochet) * snapCrochet + secStartTime);
					
					var nextTime:Float = Conductor.songPosition - secStartTime;
					var snapLeniency:Float = .24;
					if (up) {
						nextTime = Math.ceil(nextTime / snapCrochet - .002 - 1 - snapLeniency);
					} else {
						nextTime = Math.floor(nextTime / snapCrochet + .002 + 1 + snapLeniency);
					}
					nextTime *= snapCrochet;
					if (nextTime < 0) {
						loadSection(curSec = Std.int(Math.max(curSec - 1, 0)));
						nextTime = secStartTime - cachedSectionCrochets[curSec] / snap;
					} else {
						nextTime += secStartTime;
					}
					Conductor.songPosition = FlxG.sound.music.time = Math.max(0, Math.min(nextTime + .0001, FlxG.sound.music.length)) - Conductor.offset + 0.0001;
					if (curSec < cachedSectionTimes.length - 1 && Conductor.songPosition >= cachedSectionTimes[curSec + 1])
						loadSection(curSec + 1);
					
					vortexShifted = true;
				
				default:
			}
		}
		
		if (vortexShifted) {
			updateScrollY();
			updateVortexHolds();
			vortexMoved = true;
			forceDataUpdate = true;
		}
	}
	
	function keyUp(event:KeyboardEvent) {
		if (!focusedOnEditor()) return;
		
		var eventKey:FlxKey = event.keyCode;
		
		var num:Int = keysArray.indexOf(eventKey);
		if (num != -1) {
			_keysPressedBuffer[num] = false;
			_heldNotes[num] = null;
		}
	}
	
	inline function focusedOnEditor():Bool {
		return (PsychUIInputText.focusOn == null && lastFocus == null && (persistentUpdate || subState == null));
	}
	
	function updateVortexHolds() {
		var snap:Float = (curQuant / 4);
		
		for (num => key in keysArray) {
			if (_heldNotes[num] != null) {
				var noteSec:Int = 0;
				var note:MetaNote = _heldNotes[num];
				while (cachedSectionTimes.length > noteSec + 1 && cachedSectionTimes[noteSec + 1] <= note.strumTime)
					noteSec++;
				
				var targetTime:Float = Conductor.getStep(Conductor.songPosition + Conductor.offset);
				targetTime = Math.floor(targetTime * snap) / snap;
				
				note.setSustainLength(Conductor.stepToSeconds(targetTime) - note.strumTime, curZoom);
			}
		}
	}

	function loadFileList(mainFolder:String, ?optionalList:String = null, ?fileTypes:Array<String> = null)
	{
		if(fileTypes == null) fileTypes = ['.json'];

		var fileList:Array<String> = [];
		if(optionalList != null)
		{
			for (file in Mods.mergeAllTextsNamed(optionalList))
			{
				file = file.trim();
				if(file.length > 0 && !fileList.contains(file))
					fileList.push(file);
			}
		}

		for (directory in Mods.directoriesWithFile(Paths.getSharedPath(), mainFolder))
		{
			for (file in FileSystem.readDirectory(directory))
			{
				var path = haxe.io.Path.join([directory, file.trim()]);
				if (!FileSystem.isDirectory(path) && !file.startsWith('readme.'))
				{
					for (fileType in fileTypes)
					{
						var fileToCheck:String = file.substr(0, file.length - fileType.length);
						if(fileToCheck.length > 0 && path.endsWith(fileType) && !fileList.contains(fileToCheck))
						{
							fileList.push(fileToCheck);
							break;
						}
					}
				}
			}
		}
		return fileList;
	}
	
	function loadCharacterFile(char:String):CharacterFile
	{
		if(char != null)
		{
			try
			{
				var path:String = Paths.getPath('characters/' + char + '.json', TEXT);
				#if MODS_ALLOWED
				var unparsedJson = File.getContent(path);
				#else
				var unparsedJson = Assets.getText(path);
				#end
				return cast Json.parse(unparsedJson);
			}
			catch (e:Dynamic) {}
		}
		return null;
	}
	
	var overwriteSavedSomething:Bool = false;
	function overwriteCheck(savePath:String, overwriteName:String, saveData:String, continueFunc:Void->Void = null, ?continueOnCancel:Bool = false)
	{
		if(FileSystem.exists(savePath))
		{
			openSubState(new Prompt('Overwrite: "$overwriteName"?', function()
			{
				overwriteSavedSomething = true;
				File.saveContent(savePath, saveData);
				if(continueFunc != null) continueFunc();
			},
			continueOnCancel ? (function() if(continueFunc != null) continueFunc()) : null));
		}
		else
		{
			overwriteSavedSomething = true;
			File.saveContent(savePath, saveData);
			if(continueFunc != null) continueFunc();
		}
	}

	// Undo/Redo stuff
	var undoActions:Array<UndoStruct> = [];
	var currentUndo:Int = 0;
	function addUndoAction(action:UndoAction, data:Dynamic)
	{
		function destroyFromArr(arr:Array<MetaNote>)
		{
			if(arr == null || arr.length < 1) return;

			for (note in arr)
				if(note != null)
					note.destroy();
		}

		//trace('pushed action: $action');
		if(currentUndo > 0) undoActions = undoActions.slice(currentUndo);
		currentUndo = 0;
		undoActions.insert(0, {action: action, data: data});
		while(undoActions.length > 200) // again, ShadowMario i swear to fucking god. Rhythm Games support more than this!! Fuck FNF at this point. I really fucking hate this. I'm struggling to fuckin select ALL notes when it only selects "all" in a section. Literally ShadowMario, WTF! Kade, Codename, Restructure Engines support Selecting every single note. Fuck you. Literally i fucking hate you.
		{
			var lastAction:UndoStruct = undoActions.pop();
			if(lastAction != null)
			{
				switch(lastAction.action)
				{
					case DELETE_NOTE:
						destroyFromArr(lastAction.data.notes);
						destroyFromArr(lastAction.data.events);
					case MOVE_NOTE:
						destroyFromArr(lastAction.data.originalNotes);
						destroyFromArr(lastAction.data.originalEvents);
					default:
				}
			}
		}
	}

	function undo()
	{
		if(isMovingNotes || currentUndo >= undoActions.length)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'), 0.4);
			return;
		}

		var action:UndoStruct = undoActions[currentUndo];
		switch(action.action)
		{
			case ADD_NOTE:
				actionRemoveNotes(action.data.notes, action.data.events);

			case DELETE_NOTE:
				actionPushNotes(action.data.notes, action.data.events);

			case MOVE_NOTE:
				actionRemoveNotes(action.data.movedNotes, action.data.movedEvents);
				actionPushNotes(action.data.originalNotes, action.data.originalEvents);
				onSelectNote();

			case SELECT_NOTE:
				resetSelectedNotes();
				selectedNotes = action.data.old;
				if(lockedEvents) selectedNotes = selectedNotes.filter((note:MetaNote) -> !note.isEvent);
				onSelectNote();
		}
		showOutput('Undo #${currentUndo+1}: ${action.action}');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		currentUndo++;
	}
	function redo()
	{
		if(isMovingNotes || currentUndo < 1)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'), 0.4);
			return;
		}

		currentUndo--;
		var action:UndoStruct = undoActions[currentUndo];
		switch(action.action)
		{
			case ADD_NOTE:
				actionPushNotes(action.data.notes, action.data.events);

			case DELETE_NOTE:
				actionRemoveNotes(action.data.notes, action.data.events);

			case MOVE_NOTE:
				actionRemoveNotes(action.data.originalNotes, action.data.originalEvents);
				actionPushNotes(action.data.movedNotes, action.data.movedEvents);
				onSelectNote();

			case SELECT_NOTE:
				resetSelectedNotes();
				selectedNotes = action.data.current;
				if(lockedEvents) selectedNotes = selectedNotes.filter((note:MetaNote) -> !note.isEvent);
				onSelectNote();
		}
		showOutput('Redo #${currentUndo+1}: ${action.action}');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
	}

	function actionPushNotes(dataNotes:Array<MetaNote>, dataEvents:Array<EventMetaNote>)
	{
		resetSelectedNotes();
		if(dataNotes != null && dataNotes.length > 0)
		{
			for (note in dataNotes)
			{
				if(note != null)
				{
					notes.push(note);
					selectedNotes.push(note);
					note.songData[0] = note.strumTime;
					note.songData[1] = note.chartNoteData;
				}
			}
			notes.sort(PlayState.sortByTime);
		}
		if(dataEvents != null && dataEvents.length > 0)
		{
			for (event in dataEvents)
			{
				if(event != null)
				{
					events.push(event);
					selectedNotes.push(event);
					event.songData[0] = event.strumTime;
				}
			}
			events.sort(PlayState.sortByTime);
		}
		softReloadNotes();
	}

	function actionRemoveNotes(dataNotes:Array<MetaNote>, dataEvents:Array<EventMetaNote>)
	{
		if(dataNotes != null && dataNotes.length > 0)
		{
			for (note in dataNotes)
			{
				if(note != null)
				{
					notes.remove(note);
					selectedNotes.remove(note);

					if(note.exists)
					{
						note.colorTransform.redMultiplier = note.colorTransform.greenMultiplier = note.colorTransform.blueMultiplier = 1;
						if(note.animation.curAnim != null) note.animation.curAnim.curFrame = 0;
					}
				}

			}
		}
		if(dataEvents != null && dataEvents.length > 0)
		{
			for (event in dataEvents)
			{
				if(event != null)
				{
					trace(events.remove(event));
					selectedNotes.remove(event);

					if(event.exists)
					{
						event.colorTransform.redMultiplier = event.colorTransform.greenMultiplier = event.colorTransform.blueMultiplier = 1;
						if(event.animation.curAnim != null) event.animation.curAnim.curFrame = 0;
					}
				}
			}
		}
		softReloadNotes();
	}

	function actionReplaceNotes(oldNote:MetaNote, newNote:MetaNote)
	{
		for (act in undoActions)
		{
			for (field in Reflect.fields(act.data))
			{
				var fld:Array<MetaNote> = cast Reflect.field(act.data, field);
				if(fld != null && fld.length > 0)
					for (num => actNote in fld)
						if(actNote == oldNote)
							fld[num] = newNote;
			}
		}
	}

	// Ported from the old chart editor
	var wavData:Array<Array<Array<Float>>> = [[[0], [0]], [[0], [0]]];
	function updateWaveform() {
		#if (lime_cffi && !macro)
		if(cachedSectionTimes == null || curSec < 0 || curSec >= cachedSectionTimes.length || !waveformEnabled)
		{
			waveformSprite.visible = false;
			return;
		}

		waveformSprite.visible = true;
		waveformSprite.y = gridBg.y;
		var width:Int = Std.int(GRID_SIZE * GRID_COLUMNS_PER_PLAYER * GRID_PLAYERS);
		var height:Int = Std.int(gridBg.height);
		if(Std.int(waveformSprite.height) != height && waveformSprite.pixels != null)
		{
			waveformSprite.pixels.dispose();
			waveformSprite.pixels.disposeImage();
			waveformSprite.makeGraphic(width, height, 0x00FFFFFF);
		}
		waveformSprite.pixels.fillRect(new Rectangle(0, 0, width, height), 0x00FFFFFF);

		drawOnWaveform(switch(waveformTarget) {
			case INST:
				FlxG.sound.music;
			case PLAYER:
				vocals;
			case OPPONENT:
				opponentVocals;
			default:
				null;
		}, width, height);
		
		if (waveformTarget == EVERYTHING) {
			drawOnWaveform(vocals, width, height, -.25, .75);
			if (opponentVocals.length <= 0) {
				drawOnWaveform(vocals, width, height, .25, .75);
			} else {
				drawOnWaveform(opponentVocals, width, height, .25, .75);
			}
			drawOnWaveform(FlxG.sound.music, width, height, 0, .5);
		}
		
		#else
		waveformSprite.visible = false;
		#end
	}
	
	#if (lime_cffi && !macro)
	function drawOnWaveform(sound:FlxSound, width:Int, height:Int, offset:Float = 0, amp:Float = 1) {
		@:privateAccess
		if (sound == null || sound._sound == null || sound._sound.__buffer == null) return;

		wavData[0][0].resize(0);
		wavData[0][1].resize(0);
		wavData[1][0].resize(0);
		wavData[1][1].resize(0);
		
		@:privateAccess {
		var bytes:Bytes = sound._sound.__buffer.data.toBytes();
		wavData = waveformData(sound._sound.__buffer, bytes, cachedSectionTimes[curSec] - Conductor.offset, cachedSectionTimes[curSec+1] - Conductor.offset, 1, wavData, height);
		}
		
		// Draws
		var gSize:Int = Std.int(GRID_SIZE * 8);
		var hSize:Int = Std.int(gSize / 2);
		var size:Float = 1;
		
		var leftLength:Int = (wavData[0][0].length > wavData[0][1].length ? wavData[0][0].length : wavData[0][1].length);
		var rightLength:Int = (wavData[1][0].length > wavData[1][1].length ? wavData[1][0].length : wavData[1][1].length);
		
		var length:Int = leftLength > rightLength ? leftLength : rightLength;
		
		for (index in 0...length)
		{
			var lmin:Float = FlxMath.bound(((index < wavData[0][0].length && index >= 0) ? wavData[0][0][index] : 0) * (gSize / 1.12), -hSize, hSize) / 2;
			var lmax:Float = FlxMath.bound(((index < wavData[0][1].length && index >= 0) ? wavData[0][1][index] : 0) * (gSize / 1.12), -hSize, hSize) / 2;
			
			var rmin:Float = FlxMath.bound(((index < wavData[1][0].length && index >= 0) ? wavData[1][0][index] : 0) * (gSize / 1.12), -hSize, hSize) / 2;
			var rmax:Float = FlxMath.bound(((index < wavData[1][1].length && index >= 0) ? wavData[1][1][index] : 0) * (gSize / 1.12), -hSize, hSize) / 2;
			
			var ww:Float = ((lmin + rmin) + (lmax + rmax)) * amp;
			var xx:Float = /*Math.max(0, Math.min(gSize - ww, */hSize - ww * .5 + (gSize * offset);//));
			waveformSprite.pixels.fillRect(new Rectangle(xx, index * size, ww, size), FlxColor.WHITE);
		}
	}
	#end

	function waveformData(buffer:AudioBuffer, bytes:Bytes, time:Float, endTime:Float, multiply:Float = 1, ?array:Array<Array<Array<Float>>>, ?steps:Float):Array<Array<Array<Float>>>
	{
		#if (lime_cffi && !macro)
		if (buffer == null || buffer.data == null) return [[[0], [0]], [[0], [0]]];

		var khz:Float = (buffer.sampleRate / 1000);
		var channels:Int = buffer.channels;

		var index:Int = Std.int(time * khz);

		var samples:Float = ((endTime - time) * khz);

		if (steps == null) steps = 1280;

		var samplesPerRow:Float = samples / steps;
		var samplesPerRowI:Int = Std.int(samplesPerRow);

		var gotIndex:Int = 0;

		var lmin:Float = 0;
		var lmax:Float = 0;

		var rmin:Float = 0;
		var rmax:Float = 0;

		var rows:Float = 0;

		var simpleSample:Bool = true;//samples > 17200;
		var v1:Bool = false;

		if (array == null) array = [[[0], [0]], [[0], [0]]];

		while (index < (bytes.length - 1)) {
			if (index >= 0) {
				var byte:Int = bytes.getUInt16(index * channels * 2);

				if (byte > 65535 / 2) byte -= 65535;

				var sample:Float = (byte / 65535);

				if (sample > 0)
					if (sample > lmax) lmax = sample;
				else if (sample < 0)
					if (sample < lmin) lmin = sample;

				if (channels >= 2) {
					byte = bytes.getUInt16((index * channels * 2) + 2);

					if (byte > 65535 / 2) byte -= 65535;

					sample = (byte / 65535);

					if (sample > 0) {
						if (sample > rmax) rmax = sample;
					} else if (sample < 0) {
						if (sample < rmin) rmin = sample;
					}
				}
			}

			v1 = samplesPerRowI > 0 ? (index % samplesPerRowI == 0) : false;
			while (simpleSample ? v1 : rows >= samplesPerRow) {
				v1 = false;
				rows -= samplesPerRow;

				gotIndex++;

				var lRMin:Float = Math.abs(lmin) * multiply;
				var lRMax:Float = lmax * multiply;

				var rRMin:Float = Math.abs(rmin) * multiply;
				var rRMax:Float = rmax * multiply;

				if (gotIndex > array[0][0].length) array[0][0].push(lRMin);
					else array[0][0][gotIndex - 1] = array[0][0][gotIndex - 1] + lRMin;

				if (gotIndex > array[0][1].length) array[0][1].push(lRMax);
					else array[0][1][gotIndex - 1] = array[0][1][gotIndex - 1] + lRMax;

				if (channels >= 2)
				{
					if (gotIndex > array[1][0].length) array[1][0].push(rRMin);
						else array[1][0][gotIndex - 1] = array[1][0][gotIndex - 1] + rRMin;

					if (gotIndex > array[1][1].length) array[1][1].push(rRMax);
						else array[1][1][gotIndex - 1] = array[1][1][gotIndex - 1] + rRMax;
				}
				else
				{
					if (gotIndex > array[1][0].length) array[1][0].push(lRMin);
						else array[1][0][gotIndex - 1] = array[1][0][gotIndex - 1] + lRMin;

					if (gotIndex > array[1][1].length) array[1][1].push(lRMax);
						else array[1][1][gotIndex - 1] = array[1][1][gotIndex - 1] + lRMax;
				}

				lmin = 0;
				lmax = 0;

				rmin = 0;
				rmax = 0;
			}

			index++;
			rows++;
			if(gotIndex > steps) break;
		}

		return array;
		#else
		return [[[0], [0]], [[0], [0]]];
		#end
	}
}