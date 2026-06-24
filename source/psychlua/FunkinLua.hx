#if LUA_ALLOWED
package psychlua;

import backend.WeekData;

import backend.Highscore;
import backend.Controls;
import backend.Song;
import backend.ScriptRunner;
import backend.WeekData;
import cutscenes.DialogueBoxPsych;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxState;
import haxe.Json;
import objects.Character;
import objects.Note;
import objects.NoteSplash;
import objects.StrumNote;
import openfl.Lib;
import openfl.display.BitmapData;
import openfl.utils.Assets;
import psychlua.DebugLuaText;
import psychlua.LuaUtils.LuaTweenOptions;
import psychlua.LuaUtils;
import psychlua.ModchartSprite;
import states.MainMenuState;
import states.StoryMenuState;
import states.FreeplayState;
import substates.GameOverSubstate;
import substates.PauseSubState;
#if (!flash && sys)
import flixel.addons.display.FlxRuntimeShader;
#end

#if HSCRIPT_ALLOWED
import psychlua.HScript;
#end

import flixel.input.keyboard.FlxKey;
import flixel.input.gamepad.FlxGamepadInputID;

import flixel.util.FlxSave;

class FunkinLua {
	public var lua:State = null;
	public var camTarget:FlxCamera;
	public var scriptName:String = '';
	public var modFolder:String = null;
	public var closed:Bool = false;

	#if HSCRIPT_ALLOWED
	public var hscript:HScript = null;
	#end

	public var legacyHScript:LegacyFunkinLua.HScriptLegacy = null;

	public var callbacks:Map<String, Dynamic> = new Map<String, Dynamic>();
	public static var customFunctions:Map<String, Dynamic> = new Map<String, Dynamic>();

	inline static function getScriptControls():Controls
		return PlayState.instance != null ? PlayState.instance.controls : Controls.instance;

	static function getScriptControl(key:String):Bool
	{
		if (PlayState.instance != null) return PlayState.instance.getControl(key);
		var chart:states.editors.ChartingState = states.editors.ChartingState.instance;
		if (chart != null && Std.isOfType(FlxG.state, states.editors.ChartingState)) return chart.getControl(key);
		return Reflect.getProperty(Controls.instance, key) == true;
	}

	public function onCreatePost():Void {
		// 0.6.3 compat: expose PlayState / Chart Editor characters/groups
    	if (PlayState.instance != null) {
    	    if (PlayState.instance.boyfriendGroup != null) set('boyfriend', PlayState.instance.boyfriend);
    	    if (PlayState.instance.dadGroup != null) set('dad', PlayState.instance.dad);
    	    if (PlayState.instance.gfGroup != null) set('gf', PlayState.instance.gf);

    	    if (PlayState.instance.boyfriendGroup != null) set("boyfriendGroup", PlayState.instance.boyfriendGroup);
    	    if (PlayState.instance.dadGroup != null) set("dadGroup", PlayState.instance.dadGroup);
    	    if (PlayState.instance.gfGroup != null) set("gfGroup", PlayState.instance.gfGroup);
    	}
		else if (states.editors.ChartingState.instance != null) {
			var chart = states.editors.ChartingState.instance;
			if (chart.boyfriend != null) set('boyfriend', chart.boyfriend);
			if (chart.dad != null) set('dad', chart.dad);
			if (chart.gf != null) set('gf', chart.gf);
			if (chart.boyfriendGroup != null) set('boyfriendGroup', chart.boyfriendGroup);
			if (chart.dadGroup != null) set('dadGroup', chart.dadGroup);
			if (chart.gfGroup != null) set('gfGroup', chart.gfGroup);
		}
	}

	public function new(scriptName:String) {
		lua = LuaL.newstate();
		LuaL.openlibs(lua);

		//trace('Lua version: ' + Lua.version());
		//trace("LuaJIT version: " + Lua.versionJIT());

		//LuaL.dostring(lua, CLENSE);

		this.scriptName = scriptName.trim();
		var playState:PlayState = PlayState.instance;
		var chartHost:states.editors.ChartingState = states.editors.ChartingState.instance;
		var inChartEditor:Bool = chartHost != null && playState == null && Std.isOfType(FlxG.state, states.editors.ChartingState);
		var game:Dynamic = inChartEditor ? chartHost : playState;

		if(playState != null) {
			playState.luaArray.push(this);
			@:privateAccess
			playState.updateScriptFlags();
		}
		else if (chartHost != null) {
			chartHost.luaArray.push(this);
			chartHost.updateScriptFlags();
		}

		#if LUA_ALLOWED
		var activeLuaArray:Array<FunkinLua> = inChartEditor ? chartHost.luaArray : playState.luaArray;
		#end
		#if HSCRIPT_ALLOWED
		var activeHscriptArray:Array<HScript> = inChartEditor ? chartHost.hscriptArray : playState.hscriptArray;
		#end

		function callHostOnScripts(funcToCall:String, ?args:Array<Dynamic> = null, ?ignoreStops:Bool = false, ?excludeScripts:Array<String> = null, ?excludeValues:Array<Dynamic> = null):Dynamic
		{
			if (inChartEditor && chartHost != null)
				return chartHost.callOnScripts(funcToCall, args, ignoreStops, excludeScripts, excludeValues);
			if (playState != null)
				return playState.callOnScripts(funcToCall, args, ignoreStops, excludeScripts, excludeValues);
			return LuaUtils.Function_Continue;
		}
		#if LUA_ALLOWED
		function callHostOnLuas(funcToCall:String, ?args:Array<Dynamic> = null, ?ignoreStops:Bool = false, ?excludeScripts:Array<String> = null, ?excludeValues:Array<Dynamic> = null):Dynamic
		{
			if (inChartEditor && chartHost != null)
				return chartHost.callOnLuas(funcToCall, args, ignoreStops, excludeScripts, excludeValues);
			if (playState != null)
				return playState.callOnLuas(funcToCall, args, ignoreStops, excludeScripts, excludeValues);
			return LuaUtils.Function_Continue;
		}
		#end
		#if HSCRIPT_ALLOWED
		function callHostOnHScript(funcToCall:String, ?args:Array<Dynamic> = null, ?ignoreStops:Bool = false, ?excludeScripts:Array<String> = null, ?excludeValues:Array<Dynamic> = null):Dynamic
		{
			if (inChartEditor && chartHost != null)
				return chartHost.callOnHScript(funcToCall, args, ignoreStops, excludeScripts, excludeValues);
			if (playState != null)
				return playState.callOnHScript(funcToCall, args, ignoreStops, excludeScripts, excludeValues);
			return LuaUtils.Function_Continue;
		}
		#end
		function setHostOnScripts(variable:String, arg:Dynamic, ?exclusions:Array<String> = null):Void
		{
			if (inChartEditor && chartHost != null)
				chartHost.setOnScripts(variable, arg, exclusions);
			else if (playState != null)
				playState.setOnScripts(variable, arg, exclusions);
		}
		#if LUA_ALLOWED
		function setHostOnLuas(variable:String, arg:Dynamic, ?exclusions:Array<String> = null):Void
		{
			if (inChartEditor && chartHost != null)
				chartHost.setOnLuas(variable, arg, exclusions);
			else if (playState != null)
				playState.setOnLuas(variable, arg, exclusions);
		}
		#end
		#if HSCRIPT_ALLOWED
		function setHostOnHScript(variable:String, arg:Dynamic, ?exclusions:Array<String> = null):Void
		{
			if (inChartEditor && chartHost != null)
				chartHost.setOnHScript(variable, arg, exclusions);
			else if (playState != null)
				playState.setOnHScript(variable, arg, exclusions);
		}
		#end

		var myFolder:Array<String> = this.scriptName.split('/');
		#if MODS_ALLOWED
		if(myFolder[0] + '/' == Paths.mods() && (Mods.currentModDirectory == myFolder[1] || Mods.getGlobalMods().contains(myFolder[1]))) //is inside mods folder
			this.modFolder = myFolder[1];
		#end

		// Lua shit
		set('Function_StopLua', LuaUtils.Function_StopLua);
		set('Function_StopHScript', LuaUtils.Function_StopHScript);
		set('Function_StopAll', LuaUtils.Function_StopAll);
		set('Function_Stop', LuaUtils.Function_Stop);
		set('Function_Continue', LuaUtils.Function_Continue);
		set('luaDebugMode', false);
		set('luaDeprecatedWarnings', true);
		set('version', MainMenuState.psychEngineVersion.trim());
		set('modFolder', this.modFolder);

		// Song/Week shit
		set('curBpm', Conductor.bpm);
		set('bpm', PlayState.SONG.bpm);
		set('scrollSpeed', PlayState.SONG.speed);
		set('crochet', Conductor.crochet);
		set('stepCrochet', Conductor.stepCrochet);
		set('songLength', FlxG.sound.music.length);
		set('songName', PlayState.SONG.song);
		set('songPath', Paths.formatToSongPath(PlayState.SONG.song));
		set('loadedSongName', Song.loadedSongName);
		set('loadedSongPath', Paths.formatToSongPath(Song.loadedSongName));
		set('chartPath', Song.chartPath);
		set('startedCountdown', false);
		set('curStage', PlayState.SONG.stage);

		set('isStoryMode', PlayState.isStoryMode);
		set('difficulty', PlayState.storyDifficulty);

		set('difficultyName', Difficulty.getString(false));
		set('difficultyPath', Difficulty.getFilePath());
		set('difficultyNameTranslation', Difficulty.getString(true));
		set('weekRaw', PlayState.storyWeek);
		set('week', WeekData.weeksList[PlayState.storyWeek]);
		set('seenCutscene', PlayState.seenCutscene);
		set('hasVocals', PlayState.SONG.needsVoices);

		// Camera poo
		set('cameraX', 0);
		set('cameraY', 0);

		// Screen stuff
		set('screenWidth', FlxG.width);
		set('screenHeight', FlxG.height);


		set('inChartEditor', inChartEditor);
		PlayState.chartingMode = inChartEditor;

		// PlayState / Chart Editor variables
		if(playState != null)
		@:privateAccess
		{
			var curSection:SwagSection = PlayState.SONG.notes[playState.curSection];
			set('curSection', playState.curSection);
			set('curBeat', playState.curBeat);
			set('curStep', playState.curStep);
			set('curDecBeat', playState.curDecBeat);
			set('curDecStep', playState.curDecStep);
	
			set('score', playState.songScore);
			set('misses', playState.songMisses);
			set('hits', playState.songHits);
			set('combo', playState.combo);
			set('deaths', PlayState.deathCounter);
	
			set('rating', playState.ratingPercent);
			set('ratingName', playState.ratingName);
			set('ratingFC', playState.ratingFC);
			set('totalPlayed', playState.totalPlayed);
			set('totalNotesHit', playState.totalNotesHit);

			set('songScore', playState.songScore);
			set('songMisses', playState.songMisses);
			set('ratingPercent', playState.ratingPercent);

			set('inGameOver', GameOverSubstate.instance != null);
			set('mustHitSection', curSection != null ? (curSection.mustHitSection == true) : false);
			set('altAnim', curSection != null ? (curSection.altAnim == true) : false);
			set('gfSection', curSection != null ? (curSection.gfSection == true) : false);

			set('healthGainMult', playState.healthGain);
			set('healthLossMult', playState.healthLoss);
	
			#if FLX_PITCH
			set('playbackRate', playState.playbackRate);
			#else
			set('playbackRate', 1);
			#end
	
			set('guitarHeroSustains', playState.guitarHeroSustains);
			set('instakillOnMiss', playState.instakillOnMiss);
			set('botPlay', playState.cpuControlled);
			set('practice', playState.practiceMode);
	
			for (i in 0...4) {
				set('defaultPlayerStrumX' + i, 0);
				set('defaultPlayerStrumY' + i, 0);
				set('defaultOpponentStrumX' + i, 0);
				set('defaultOpponentStrumY' + i, 0);
			}
	
			set('defaultBoyfriendX', playState.BF_X);
			set('defaultBoyfriendY', playState.BF_Y);
			set('defaultOpponentX', playState.DAD_X);
			set('defaultOpponentY', playState.DAD_Y);
			set('defaultGirlfriendX', playState.GF_X);
			set('defaultGirlfriendY', playState.GF_Y);

			set('boyfriendName', playState.boyfriend != null ? playState.boyfriend.curCharacter : PlayState.SONG.player1);
			set('dadName', playState.dad != null ? playState.dad.curCharacter : PlayState.SONG.player2);
			set('gfName', playState.gf != null ? playState.gf.curCharacter : PlayState.SONG.gfVersion);
		}
		else if (chartHost != null)
		{
			var sec:Int = chartHost.curSec;
			var curSection:SwagSection = (PlayState.SONG != null && PlayState.SONG.notes[sec] != null) ? PlayState.SONG.notes[sec] : null;
			set('curSection', sec);
			set('curBeat', Std.int(Conductor.getBeat(Conductor.songPosition)));
			set('curStep', Std.int(Conductor.getStep(Conductor.songPosition)));
			set('curDecBeat', Conductor.getBeat(Conductor.songPosition));
			set('curDecStep', Conductor.getStep(Conductor.songPosition));

			set('score', 0);
			set('misses', 0);
			set('hits', 0);
			set('combo', 0);
			set('deaths', 0);
			set('rating', 0);
			set('ratingName', '');
			set('ratingFC', '');
			set('totalPlayed', 0);
			set('totalNotesHit', 0);
			set('songScore', 0);
			set('songMisses', 0);
			set('ratingPercent', 0);

			set('inGameOver', false);
			set('mustHitSection', curSection != null ? (curSection.mustHitSection == true) : false);
			set('altAnim', curSection != null ? (curSection.altAnim == true) : false);
			set('gfSection', curSection != null ? (curSection.gfSection == true) : false);

			set('healthGainMult', 1);
			set('healthLossMult', 1);
			set('playbackRate', 1);
			set('guitarHeroSustains', false);
			set('instakillOnMiss', false);
			set('botPlay', false);
			set('practice', false);

			for (i in 0...4) {
				set('defaultPlayerStrumX' + i, 0);
				set('defaultPlayerStrumY' + i, 0);
				set('defaultOpponentStrumX' + i, 0);
				set('defaultOpponentStrumY' + i, 0);
			}

			set('defaultBoyfriendX', chartHost.BF_X);
			set('defaultBoyfriendY', chartHost.BF_Y);
			set('defaultOpponentX', chartHost.DAD_X);
			set('defaultOpponentY', chartHost.DAD_Y);
			set('defaultGirlfriendX', chartHost.GF_X);
			set('defaultGirlfriendY', chartHost.GF_Y);

			set('boyfriendName', chartHost.boyfriend != null ? chartHost.boyfriend.curCharacter : PlayState.SONG.player1);
			set('dadName', chartHost.dad != null ? chartHost.dad.curCharacter : PlayState.SONG.player2);
			set('gfName', chartHost.gf != null ? chartHost.gf.curCharacter : PlayState.SONG.gfVersion);
		}

		// Other settings
		set('downscroll', ClientPrefs.data.downScroll);
		set('middlescroll', ClientPrefs.data.middleScroll);
		set('framerate', ClientPrefs.data.framerateSetting);
		set('ghostTapping', ClientPrefs.data.ghostTapping);
		set('hideHud', ClientPrefs.data.hideHud);
		set('timeBarType', ClientPrefs.data.timeBarType);
		set('scoreZoom', ClientPrefs.data.scoreZoom);
		set('cameraZoomOnBeat', ClientPrefs.data.camZooms);
		set('flashingLights', ClientPrefs.data.flashing);
		set('noteOffset', ClientPrefs.data.noteOffset);
		set('healthBarAlpha', ClientPrefs.data.healthBarAlpha);
		set('noResetButton', ClientPrefs.data.noReset);
		set('lowQuality', ClientPrefs.data.lowQuality);
		set('shadersEnabled', ClientPrefs.data.shaders);
		// set('modcharts', ClientPrefs.data.modcharts);
		set('scriptName', scriptName);
		set('currentModDirectory', Mods.currentModDirectory);

		// Noteskin/Splash
		set('noteSkin', ClientPrefs.data.noteSkin);
		set('noteSkinPostfix', Note.getNoteSkinPostfix());
		set('splashSkin', ClientPrefs.data.splashSkin);
		set('splashSkinPostfix', NoteSplash.getSplashSkinPostfix());
		set('splashAlpha', ClientPrefs.data.splashAlpha);

		// build target (windows, mac, linux, etc.)
		set('buildTarget', LuaUtils.getBuildTarget());

		// if (PlayState.instance != null && PlayState.instance.noteCache != null) {
    	// 	var nc = PlayState.instance.noteCache;
		// 	set("noteCache", nc);
    	// 	set("noteCacher_respawnNote", nc.respawnNote);
    	// 	set("noteCacher_respawnNoteAtTime", nc.respawnNoteAtTime);
    	// 	set("noteCacher_respawnNotesInRange", nc.respawnNotesInRange);
    	// 	set("noteCacher_clearNotesInRange", nc.clearNotesInRange);
    	// 	set("noteCacher_getTotalNoteCount", nc.getTotalNoteCount);
    	// 	set("noteCacher_getNoteAtTime", nc.getNoteAtTime);
    	// 	set("noteCacher_getNotesInRange", nc.getNotesInRange);
    	// 	set("noteCacher_getNotesByColumn", nc.getNotesByColumn);
    	// 	set("noteCacher_getNotesByType", nc.getNotesByType);
    	// 	set("noteCacher_getCachedNoteData", nc.getCachedNoteData);
    	// 	set("noteCacher_findNoteDataByTime", nc.findNoteDataByTime);
    	// 	set("noteCacher_printNoteInfo", nc.dbg);
		// }

		// set('mania', PlayState.mania);
		// set('trueMania', Note.ammo[PlayState.mania]);

		Lua_helper.add_callback(lua, "runInLegacyMode", function() {
			this.closed = true;
			PlayState.instance.luaArray.remove(this);
			new LegacyFunkinLua(scriptName);
			trace('A script has been converted to Legacy mode: ' + scriptName);
		});

		Lua_helper.add_callback(lua, "runLegacyHScript", function(code:String) {
			var retVal:Dynamic = null;

			#if HScriptLegacy
			if (this.legacyHScript == null) {
				this.legacyHScript = new LegacyFunkinLua.HScriptLegacy();
			}

			var hscript:LegacyFunkinLua.HScriptLegacy = this.legacyHScript;
			var codeToRun:String = code;
			try {
				retVal = hscript.execute(codeToRun);
			}
			catch (e:Dynamic) {
				luaTrace("Legacy HScript Error: " + scriptName + ":" + lastCalledFunction + " - " + e, false, false, FlxColor.RED);
			}
			#else
			luaTrace("RunLegacyHScript: Legacy HScript isn't supported on this platform!", false, false, FlxColor.RED);
			#end

			if(retVal != null && !LegacyFunkinLua.isOfTypes(retVal, [Bool, Int, Float, String, Array])) retVal = null;
			if(retVal == null) Lua.pushnil(lua);
			return retVal;
		});

		Lua_helper.add_callback(lua, "getStageData", function(stage:String) {
		    #if (!MODS_ALLOWED)
		    return null;
		    #else
		    try {
		        return backend.StageData.getStageFile(stage);
		    } catch (e) {
		        trace('StageData not supported in this version.');
		        return null;
		    }
		    #end
		});

		// Original legacy stuff that actually still damn works lmfao why are these deprecated?
		Lua_helper.add_callback(lua, "addAnimationByIndicesLoop", function(obj:String, name:String, prefix:String, indices:String, framerate:Int = 24) {
			FunkinLua.luaTrace("addAnimationByIndicesLoop is deprecated! Use addAnimationByIndices instead", false, true);
			return LuaUtils.addAnimByIndices(obj, name, prefix, indices, framerate, true);
		});

		Lua_helper.add_callback(lua, "objectPlayAnimation", function(obj:String, name:String, forced:Bool = false, ?startFrame:Int = 0) {
			FunkinLua.luaTrace("objectPlayAnimation is deprecated! Use playAnim instead", false, true);
			var spr:FlxSprite = LuaUtils.getScriptLuaObject(obj);
			if(spr != null && spr.animation != null) {
				spr.animation.play(name, forced, false, startFrame);
				return true;
			}

			var host:Dynamic = LuaUtils.getTargetInstance();
			if(host != null) {
				spr = Reflect.getProperty(host, obj);
				if(spr != null && spr.animation != null) {
					spr.animation.play(name, forced, false, startFrame);
					return true;
				}
			}
			return false;
		});
		Lua_helper.add_callback(lua, "characterPlayAnim", function(character:String, anim:String, ?forced:Bool = false) {
			FunkinLua.luaTrace("characterPlayAnim is deprecated! Use playAnim instead", false, true);
			var host:Dynamic = game;
			if(host == null) return;

			switch(character.toLowerCase()) {
				case 'dad':
					if(host.dad != null && host.dad.hasAnimation(anim))
						host.dad.playAnim(anim, forced);
				case 'gf' | 'girlfriend':
					if(host.gf != null && host.gf.hasAnimation(anim))
						host.gf.playAnim(anim, forced);
				default:
					if(host.boyfriend != null && host.boyfriend.hasAnimation(anim))
						host.boyfriend.playAnim(anim, forced);
			}
		});
		Lua_helper.add_callback(lua, "luaSpriteMakeGraphic", function(tag:String, width:Int, height:Int, color:String) {
			FunkinLua.luaTrace("luaSpriteMakeGraphic is deprecated! Use makeGraphic instead", false, true);
			if(MusicBeatState.getVariables().exists(tag))
				MusicBeatState.getVariables().get(tag).makeGraphic(width, height, CoolUtil.colorFromString(color));
		});
		Lua_helper.add_callback(lua, "luaSpriteAddAnimationByPrefix", function(tag:String, name:String, prefix:String, framerate:Int = 24, loop:Bool = true) {
			FunkinLua.luaTrace("luaSpriteAddAnimationByPrefix is deprecated! Use addAnimationByPrefix instead", false, true);
			if(MusicBeatState.getVariables().exists(tag)) {
				var cock:ModchartSprite = MusicBeatState.getVariables().get(tag);
				cock.animation.addByPrefix(name, prefix, framerate, loop);
				if(cock.animation.curAnim == null) {
					cock.animation.play(name, true);
				}
			}
		});
		Lua_helper.add_callback(lua, "luaSpriteAddAnimationByIndices", function(tag:String, name:String, prefix:String, indices:String, framerate:Int = 24) {
			FunkinLua.luaTrace("luaSpriteAddAnimationByIndices is deprecated! Use addAnimationByIndices instead", false, true);
			if(MusicBeatState.getVariables().exists(tag)) {
				var strIndices:Array<String> = indices.trim().split(',');
				var die:Array<Int> = [];
				for (i in 0...strIndices.length) {
					die.push(Std.parseInt(strIndices[i]));
				}
				var pussy:ModchartSprite = MusicBeatState.getVariables().get(tag);
				pussy.animation.addByIndices(name, prefix, die, '', framerate, false);
				if(pussy.animation.curAnim == null) {
					pussy.animation.play(name, true);
				}
			}
		});
		Lua_helper.add_callback(lua, "luaSpritePlayAnimation", function(tag:String, name:String, forced:Bool = false) {
			FunkinLua.luaTrace("luaSpritePlayAnimation is deprecated! Use playAnim instead", false, true);
			if(MusicBeatState.getVariables().exists(tag)) {
				MusicBeatState.getVariables().get(tag).animation.play(name, forced);
			}
		});
		Lua_helper.add_callback(lua, "setLuaSpriteCamera", function(tag:String, camera:String = '') {
			FunkinLua.luaTrace("setLuaSpriteCamera is deprecated! Use setObjectCamera instead", false, true);
			if(MusicBeatState.getVariables().exists(tag)) {
				MusicBeatState.getVariables().get(tag).cameras = [LuaUtils.cameraFromString(camera)];
				return true;
			}
			FunkinLua.luaTrace("Lua sprite with tag: " + tag + " doesn't exist!");
			return false;
		});
		Lua_helper.add_callback(lua, "setLuaSpriteScrollFactor", function(tag:String, scrollX:Float, scrollY:Float) {
			FunkinLua.luaTrace("setLuaSpriteScrollFactor is deprecated! Use setScrollFactor instead", false, true);
			if(MusicBeatState.getVariables().exists(tag)) {
				MusicBeatState.getVariables().get(tag).scrollFactor.set(scrollX, scrollY);
				return true;
			}
			return false;
		});
		Lua_helper.add_callback(lua, "scaleLuaSprite", function(tag:String, x:Float, y:Float) {
			FunkinLua.luaTrace("scaleLuaSprite is deprecated! Use scaleObject instead", false, true);
			if(MusicBeatState.getVariables().exists(tag)) {
				var shit:ModchartSprite = MusicBeatState.getVariables().get(tag);
				shit.scale.set(x, y);
				shit.updateHitbox();
				return true;
			}
			return false;
		});
		Lua_helper.add_callback(lua, "getPropertyLuaSprite", function(tag:String, variable:String) {
			FunkinLua.luaTrace("getPropertyLuaSprite is deprecated! Use getProperty instead", false, true);
			if(MusicBeatState.getVariables().exists(tag)) {
				var killMe:Array<String> = variable.split('.');
				if(killMe.length > 1) {
					var coverMeInPiss:Dynamic = Reflect.getProperty(MusicBeatState.getVariables().get(tag), killMe[0]);
					for (i in 1...killMe.length-1) {
						coverMeInPiss = Reflect.getProperty(coverMeInPiss, killMe[i]);
					}
					return Reflect.getProperty(coverMeInPiss, killMe[killMe.length-1]);
				}
				return Reflect.getProperty(MusicBeatState.getVariables().get(tag), variable);
			}
			return null;
		});
		Lua_helper.add_callback(lua, "setPropertyLuaSprite", function(tag:String, variable:String, value:Dynamic) {
			FunkinLua.luaTrace("setPropertyLuaSprite is deprecated! Use setProperty instead", false, true);
			if(MusicBeatState.getVariables().exists(tag)) {
				var killMe:Array<String> = variable.split('.');
				if(killMe.length > 1) {
					var coverMeInPiss:Dynamic = Reflect.getProperty(MusicBeatState.getVariables().get(tag), killMe[0]);
					for (i in 1...killMe.length-1) {
						coverMeInPiss = Reflect.getProperty(coverMeInPiss, killMe[i]);
					}
					Reflect.setProperty(coverMeInPiss, killMe[killMe.length-1], value);
					return true;
				}
				Reflect.setProperty(MusicBeatState.getVariables().get(tag), variable, value);
				return true;
			}
			FunkinLua.luaTrace("setPropertyLuaSprite: Lua sprite with tag: " + tag + " doesn't exist!");
			return false;
		});
		Lua_helper.add_callback(lua, "musicFadeIn", function(duration:Float, fromValue:Float = 0, toValue:Float = 1) {
			FlxG.sound.music.fadeIn(duration, fromValue, toValue);
			FunkinLua.luaTrace('musicFadeIn is deprecated! Use soundFadeIn instead.', false, true);

		});
		Lua_helper.add_callback(lua, "musicFadeOut", function(duration:Float, toValue:Float = 0) {
			FlxG.sound.music.fadeOut(duration, toValue);
			FunkinLua.luaTrace('musicFadeOut is deprecated! Use soundFadeOut instead.', false, true);
		});
		Lua_helper.add_callback(lua, "updateHitboxFromGroup", function(group:String, index:Int) {
			if(Std.isOfType(Reflect.getProperty(LuaUtils.getTargetInstance(), group), FlxTypedGroup)) {
				Reflect.getProperty(LuaUtils.getTargetInstance(), group).members[index].updateHitbox();
				return;
			}
			Reflect.getProperty(LuaUtils.getTargetInstance(), group)[index].updateHitbox();
			FunkinLua.luaTrace('updateHitboxFromGroup is deprecated! Use updateHitbox instead.', false, true);
		});

		// Keyboard & Gamepads
		Lua_helper.add_callback(lua, "keyboardJustPressed", function(name:String) return Reflect.getProperty(FlxG.keys.justPressed, name));
		Lua_helper.add_callback(lua, "keyboardPressed", function(name:String) return Reflect.getProperty(FlxG.keys.pressed, name));
		Lua_helper.add_callback(lua, "keyboardReleased", function(name:String) return Reflect.getProperty(FlxG.keys.justReleased, name));

		Lua_helper.add_callback(lua, "anyGamepadJustPressed", function(name:String) return FlxG.gamepads.anyJustPressed(name));
		Lua_helper.add_callback(lua, "anyGamepadPressed", function(name:String) FlxG.gamepads.anyPressed(name));
		Lua_helper.add_callback(lua, "anyGamepadReleased", function(name:String) return FlxG.gamepads.anyJustReleased(name));

		Lua_helper.add_callback(lua, "gamepadAnalogX", function(id:Int, ?leftStick:Bool = true)
		{
			var controller = FlxG.gamepads.getByID(id);
			if (controller == null) return 0.0;

			return controller.getXAxis(leftStick ? LEFT_ANALOG_STICK : RIGHT_ANALOG_STICK);
		});
		Lua_helper.add_callback(lua, "gamepadAnalogY", function(id:Int, ?leftStick:Bool = true)
		{
			var controller = FlxG.gamepads.getByID(id);
			if (controller == null) return 0.0;

			return controller.getYAxis(leftStick ? LEFT_ANALOG_STICK : RIGHT_ANALOG_STICK);
		});
		Lua_helper.add_callback(lua, "gamepadJustPressed", function(id:Int, name:String)
		{
			var controller = FlxG.gamepads.getByID(id);
			if (controller == null) return false;

			return Reflect.getProperty(controller.justPressed, name) == true;
		});
		Lua_helper.add_callback(lua, "gamepadPressed", function(id:Int, name:String)
		{
			var controller = FlxG.gamepads.getByID(id);
			if (controller == null) return false;

			return Reflect.getProperty(controller.pressed, name) == true;
		});
		Lua_helper.add_callback(lua, "gamepadReleased", function(id:Int, name:String)
		{
			var controller = FlxG.gamepads.getByID(id);
			if (controller == null) return false;

			return Reflect.getProperty(controller.justReleased, name) == true;
		});

		Lua_helper.add_callback(lua, "keyJustPressed", function(name:String = '') {
			name = name.toLowerCase().trim();
			var controls:Controls = getScriptControls();
			var key:Bool = false;
			switch(name) {
				case 'left': key = controls.NOTE_LEFT_P;
				case 'down': key = controls.NOTE_DOWN_P;
				case 'up': key = controls.NOTE_UP_P;
				case 'right': key = controls.NOTE_RIGHT_P;
				// legacy keys
				case 'accept': key = getScriptControl('ACCEPT');
				case 'back': key = getScriptControl('BACK');
				case 'pause': key = getScriptControl('PAUSE');
				case 'reset': key = getScriptControl('RESET');
				case 'space': key = FlxG.keys.justPressed.SPACE;//an extra key for convinience
				default: return controls.justPressed(name);
			}
			return key;
		});
		Lua_helper.add_callback(lua, "keyPressed", function(name:String = '') {
			name = name.toLowerCase().trim();
			var controls:Controls = getScriptControls();
			var key:Bool = false;
			switch(name) {
				case 'left': key = controls.NOTE_LEFT;
				case 'down': key = controls.NOTE_DOWN;
				case 'up': key = controls.NOTE_UP;
				case 'right': key = controls.NOTE_RIGHT;
				// legacy keys
				case 'space': key = FlxG.keys.pressed.SPACE;//an extra key for convinience
				default: return controls.pressed(name);
			}
			return key;
		});
		Lua_helper.add_callback(lua, "keyReleased", function(name:String = '') {
			name = name.toLowerCase().trim();
			var controls:Controls = getScriptControls();
			var key:Bool = false;
			switch(name) {
				case 'left': key = controls.NOTE_LEFT_R;
				case 'down': key = controls.NOTE_DOWN_R;
				case 'up': key = controls.NOTE_UP_R;
				case 'right': key = controls.NOTE_RIGHT_R;
				// legacy keys
				case 'space': key = FlxG.keys.pressed.SPACE;//an extra key for convinience
				default: return controls.justReleased(name);
			}
			return key;
		});

		// Save data management
		Lua_helper.add_callback(lua, "initSaveData", function(name:String, ?folder:String = 'psychenginemods') {
			var variables = MusicBeatState.getVariables();
			if(!variables.exists('save_$name'))
			{
				var save:FlxSave = new FlxSave();
				// folder goes unused for flixel 5 users. @BeastlyGhost
				save.bind(name, CoolUtil.getSavePath() + '/' + folder);
				variables.set('save_$name', save);
				return;
			}
			FunkinLua.luaTrace('initSaveData: Save file already initialized: ' + name);
		});
		Lua_helper.add_callback(lua, "flushSaveData", function(name:String) {
			var variables = MusicBeatState.getVariables();
			if(variables.exists('save_$name'))
			{
				variables.get('save_$name').flush();
				return;
			}
			FunkinLua.luaTrace('flushSaveData: Save file not initialized: ' + name, false, false, FlxColor.RED);
		});
		Lua_helper.add_callback(lua, "getDataFromSave", function(name:String, field:String, ?defaultValue:Dynamic = null) {
			var variables = MusicBeatState.getVariables();
			if(variables.exists('save_$name'))
			{
				var saveData = variables.get('save_$name').data;
				if(Reflect.hasField(saveData, field))
					return Reflect.field(saveData, field);
				else
					return defaultValue;
			}
			FunkinLua.luaTrace('getDataFromSave: Save file not initialized: ' + name, false, false, FlxColor.RED);
			return defaultValue;
		});
		Lua_helper.add_callback(lua, "setDataFromSave", function(name:String, field:String, value:Dynamic) {
			var variables = MusicBeatState.getVariables();
			if(variables.exists('save_$name'))
			{
				Reflect.setField(variables.get('save_$name').data, field, value);
				return;
			}
			FunkinLua.luaTrace('setDataFromSave: Save file not initialized: ' + name, false, false, FlxColor.RED);
		});
		Lua_helper.add_callback(lua, "eraseSaveData", function(name:String)
		{
			var variables = MusicBeatState.getVariables();
			if (variables.exists('save_$name'))
			{
				variables.get('save_$name').erase();
				return;
			}
			FunkinLua.luaTrace('eraseSaveData: Save file not initialized: ' + name, false, false, FlxColor.RED);
		});

		// File management
		Lua_helper.add_callback(lua, "checkFileExists", function(filename:String, ?absolute:Bool = false) {
			#if MODS_ALLOWED
			if(absolute) return FileSystem.exists(filename);

			return FileSystem.exists(Paths.getPath(filename, TEXT));

			#else
			if(absolute) return Assets.exists(filename, TEXT);

			return Assets.exists(Paths.getPath(filename, TEXT));
			#end
		});
		Lua_helper.add_callback(lua, "saveFile", function(path:String, content:String, ?absolute:Bool = false)
		{
			try {
				#if MODS_ALLOWED
				if(!absolute)
					File.saveContent(Paths.mods(path), content);
				else
				#end
					File.saveContent(path, content);

				return true;
			} catch (e:Dynamic) {
				FunkinLua.luaTrace("saveFile: Error trying to save " + path + ": " + e, false, false, FlxColor.RED);
			}
			return false;
		});
		Lua_helper.add_callback(lua, "deleteFile", function(path:String, ?ignoreModFolders:Bool = false, ?absolute:Bool = false)
		{
			try {
				var lePath:String = path;
				if(!absolute) lePath = Paths.getPath(path, TEXT, !ignoreModFolders);
				if(FileSystem.exists(lePath))
				{
					FileSystem.deleteFile(lePath);
					return true;
				}
			} catch (e:Dynamic) {
				FunkinLua.luaTrace("deleteFile: Error trying to delete " + path + ": " + e, false, false, FlxColor.RED);
			}
			return false;
		});
		Lua_helper.add_callback(lua, "getTextFromFile", function(path:String, ?ignoreModFolders:Bool = false) {
			return Paths.getTextFromFile(path, ignoreModFolders);
		});
		Lua_helper.add_callback(lua, "directoryFileList", function(folder:String) {
			var list:Array<String> = [];
			#if sys
			if(FileSystem.exists(folder)) {
				for (folder in FileSystem.readDirectory(folder)) {
					if (!list.contains(folder)) {
						list.push(folder);
					}
				}
			}
			#end
			return list;
		});

		// String tools
		Lua_helper.add_callback(lua, "stringStartsWith", function(str:String, start:String) {
			return str.startsWith(start);
		});
		Lua_helper.add_callback(lua, "stringEndsWith", function(str:String, end:String) {
			return str.endsWith(end);
		});
		Lua_helper.add_callback(lua, "stringSplit", function(str:String, split:String) {
			return str.split(split);
		});
		Lua_helper.add_callback(lua, "stringTrim", function(str:String) {
			return str.trim();
		});

		// Randomization
		Lua_helper.add_callback(lua, "getRandomInt", function(min:Int, max:Int = FlxMath.MAX_VALUE_INT, exclude:String = '') {
			var excludeArray:Array<String> = exclude.split(',');
			var toExclude:Array<Int> = [];
			for (i in 0...excludeArray.length)
			{
				if (exclude == '') break;
				toExclude.push(Std.parseInt(excludeArray[i].trim()));
			}
			return FlxG.random.int(min, max, toExclude);
		});
		Lua_helper.add_callback(lua, "getRandomFloat", function(min:Float, max:Float = 1, exclude:String = '') {
			var excludeArray:Array<String> = exclude.split(',');
			var toExclude:Array<Float> = [];
			for (i in 0...excludeArray.length)
			{
				if (exclude == '') break;
				toExclude.push(Std.parseFloat(excludeArray[i].trim()));
			}
			return FlxG.random.float(min, max, toExclude);
		});
		Lua_helper.add_callback(lua, "getRandomBool", function(chance:Float = 50) {
			return FlxG.random.bool(chance);
		});

		//
		Lua_helper.add_callback(lua, "getRunningScripts", function() {
			var runningScripts:Array<String> = [];
			for (script in activeLuaArray)
				runningScripts.push(script.scriptName);

			return runningScripts;
		});

		addLocalCallback("setOnScripts", function(varName:String, arg:Dynamic, ?ignoreSelf:Bool = false, ?exclusions:Array<String> = null) {
			if(exclusions == null) exclusions = [];
			if(ignoreSelf && !exclusions.contains(scriptName)) exclusions.push(scriptName);
			setHostOnScripts(varName, arg, exclusions);
		});
		addLocalCallback("setOnHScript", function(varName:String, arg:Dynamic, ?ignoreSelf:Bool = false, ?exclusions:Array<String> = null) {
			if(exclusions == null) exclusions = [];
			if(ignoreSelf && !exclusions.contains(scriptName)) exclusions.push(scriptName);
			setHostOnHScript(varName, arg, exclusions);
		});
		addLocalCallback("setOnLuas", function(varName:String, arg:Dynamic, ?ignoreSelf:Bool = false, ?exclusions:Array<String> = null) {
			if(exclusions == null) exclusions = [];
			if(ignoreSelf && !exclusions.contains(scriptName)) exclusions.push(scriptName);
			setHostOnLuas(varName, arg, exclusions);
		});

		addLocalCallback("callOnScripts", function(funcName:String, ?args:Array<Dynamic> = null, ?ignoreStops=false, ?ignoreSelf:Bool = true, ?excludeScripts:Array<String> = null, ?excludeValues:Array<Dynamic> = null) {
			if(excludeScripts == null) excludeScripts = [];
			if(ignoreSelf && !excludeScripts.contains(scriptName)) excludeScripts.push(scriptName);
			return callHostOnScripts(funcName, args, ignoreStops, excludeScripts, excludeValues);
		});
		addLocalCallback("callOnLuas", function(funcName:String, ?args:Array<Dynamic> = null, ?ignoreStops=false, ?ignoreSelf:Bool = true, ?excludeScripts:Array<String> = null, ?excludeValues:Array<Dynamic> = null) {
			if(excludeScripts == null) excludeScripts = [];
			if(ignoreSelf && !excludeScripts.contains(scriptName)) excludeScripts.push(scriptName);
			return callHostOnLuas(funcName, args, ignoreStops, excludeScripts, excludeValues);
		});
		addLocalCallback("callOnHScript", function(funcName:String, ?args:Array<Dynamic> = null, ?ignoreStops=false, ?ignoreSelf:Bool = true, ?excludeScripts:Array<String> = null, ?excludeValues:Array<Dynamic> = null) {
			if(excludeScripts == null) excludeScripts = [];
			if(ignoreSelf && !excludeScripts.contains(scriptName)) excludeScripts.push(scriptName);
			return callHostOnHScript(funcName, args, ignoreStops, excludeScripts, excludeValues);
		});

		Lua_helper.add_callback(lua, "callScript", function(luaFile:String, funcName:String, ?args:Array<Dynamic> = null) {
			if(args == null){
				args = [];
			}

			var luaPath:String = findScript(luaFile);
			if(luaPath != null)
				for (luaInstance in activeLuaArray)
					if(luaInstance.scriptName == luaPath)
						return luaInstance.call(funcName, args);

			return null;
		});
		Lua_helper.add_callback(lua, "isRunning", function(scriptFile:String) {
			var luaPath:String = findScript(scriptFile);
			if(luaPath != null)
			{
				for (luaInstance in activeLuaArray)
					if(luaInstance.scriptName == luaPath)
						return true;
			}

			#if HSCRIPT_ALLOWED
			var hscriptPath:String = findScript(scriptFile, '.hx');
			if(hscriptPath != null)
			{
				for (hscriptInstance in activeHscriptArray)
					if(hscriptInstance.origin == hscriptPath)
						return true;
			}
			#end
			return false;
		});

		Lua_helper.add_callback(lua, "setVar", function(varName:String, value:Dynamic) {
			MusicBeatState.getVariables().set(varName, ReflectionFunctions.parseSingleInstance(value));
			return value;
		});
		Lua_helper.add_callback(lua, "getVar", function(varName:String) {
			return MusicBeatState.getVariables().get(varName);
		});

		Lua_helper.add_callback(lua, "addLuaScript", function(luaFile:String, ?ignoreAlreadyRunning:Bool = false) {
			var luaPath:String = findScript(luaFile);
			if(luaPath != null)
			{
				if(!ignoreAlreadyRunning)
					for (luaInstance in activeLuaArray)
						if(luaInstance.scriptName == luaPath)
						{
							luaTrace('addLuaScript: The script "' + luaPath + '" is already running!');
							return;
						}

				new FunkinLua(luaPath);
				return;
			}
			luaTrace("addLuaScript: Script doesn't exist!", false, false, FlxColor.RED);
		});
		Lua_helper.add_callback(lua, "addHScript", function(scriptFile:String, ?ignoreAlreadyRunning:Bool = false) {
			#if HSCRIPT_ALLOWED
			var scriptPath:String = findScript(scriptFile, '.hx');
			if(scriptPath != null)
			{
				if(!ignoreAlreadyRunning)
					for (script in activeHscriptArray)
						if(script.origin == scriptPath)
						{
							luaTrace('addHScript: The script "' + scriptPath + '" is already running!');
							return;
						}

				if (inChartEditor && chartHost != null)
					ScriptRunner.initHScript(chartHost, scriptPath);
				else if (playState != null)
					playState.initHScript(scriptPath);
				return;
			}
			luaTrace("addHScript: Script doesn't exist!", false, false, FlxColor.RED);
			#else
			luaTrace("addHScript: HScript is not supported on this platform!", false, false, FlxColor.RED);
			#end
		});
		Lua_helper.add_callback(lua, "removeLuaScript", function(luaFile:String) {
			var luaPath:String = findScript(luaFile);
			if(luaPath != null)
			{
				var foundAny:Bool = false;
				for (luaInstance in activeLuaArray)
				{
					if(luaInstance.scriptName == luaPath)
					{
						trace('Closing lua script $luaPath');
						luaInstance.stop();
						foundAny = true;
					}
				}
				if(foundAny) return true;
			}

			luaTrace('removeLuaScript: Script $luaFile isn\'t running!', false, false, FlxColor.RED);
			return false;
		});
		Lua_helper.add_callback(lua, "removeHScript", function(scriptFile:String) {
			#if HSCRIPT_ALLOWED
			var scriptPath:String = findScript(scriptFile, '.hx');
			if(scriptPath != null)
			{
				var foundAny:Bool = false;
				for (script in activeHscriptArray)
				{
					if(script.origin == scriptPath)
					{
						trace('Closing hscript $scriptPath');
						script.destroy();
						foundAny = true;
					}
				}
				if(foundAny) return true;
			}

			luaTrace('removeHScript: Script $scriptFile isn\'t running!', false, false, FlxColor.RED);
			return false;
			#else
			luaTrace("removeHScript: HScript is not supported on this platform!", false, false, FlxColor.RED);
			#end
		});

		Lua_helper.add_callback(lua, "loadSong", function(?name:String = null, ?difficultyNum:Int = -1) {
			if(name == null || name.length < 1)
				name = Song.loadedSongName;
			if (difficultyNum == -1)
				difficultyNum = PlayState.storyDifficulty;

			var poop = Highscore.formatSong(name, difficultyNum);
			Song.loadFromJson(poop, name);
			PlayState.storyDifficulty = difficultyNum;
			FlxG.state.persistentUpdate = false;
			LoadingState.loadAndSwitchState(new PlayState());

			FlxG.sound.music.pause();
			FlxG.sound.music.volume = 0;
			if(game != null && game.vocals != null)
			{
				game.vocals.pause();
				game.vocals.volume = 0;
			}
			FlxG.camera.followLerp = 0;
		});

		Lua_helper.add_callback(lua, "loadGraphic", function(variable:String, image:String, ?gridX:Int = 0, ?gridY:Int = 0) {
			var split:Array<String> = variable.split('.');
			var spr:FlxSprite = LuaUtils.getObjectDirectly(split[0]);
			var animated = gridX != 0 || gridY != 0;

			if(split.length > 1) {
				spr = LuaUtils.getVarInArray(LuaUtils.getPropertyLoop(split), split[split.length-1]);
			}

			if(spr != null && image != null && image.length > 0)
			{
				spr.loadGraphic(Paths.image(image), animated, gridX, gridY);
			}
		});
		Lua_helper.add_callback(lua, "loadFrames", function(variable:String, image:String, spriteType:String = 'auto') {
			var split:Array<String> = variable.split('.');
			var spr:FlxSprite = LuaUtils.getObjectDirectly(split[0]);
			if(split.length > 1) {
				spr = LuaUtils.getVarInArray(LuaUtils.getPropertyLoop(split), split[split.length-1]);
			}

			if(spr != null && image != null && image.length > 0)
			{
				LuaUtils.loadFrames(spr, image, spriteType);
			}
		});
		Lua_helper.add_callback(lua, "loadMultipleFrames", function(variable:String, images:Array<String>) {
			var split:Array<String> = variable.split('.');
			var spr:FlxSprite = LuaUtils.getObjectDirectly(split[0]);
			if(split.length > 1) {
				spr = LuaUtils.getVarInArray(LuaUtils.getPropertyLoop(split), split[split.length-1]);
			}

			if(spr != null && images != null && images.length > 0)
			{
				spr.frames = Paths.getMultiAtlas(images);
			}
		});

		//shitass stuff for epic coders like me B)  *image of obama giving himself a medal*
		Lua_helper.add_callback(lua, "getObjectOrder", function(obj:String, ?group:String = null) {
			var leObj:FlxBasic = LuaUtils.getObjectDirectly(obj);
			if(leObj != null)
			{
				if(group != null)
				{
					var groupOrArray:Dynamic = Reflect.getProperty(LuaUtils.getTargetInstance(), group);
					if(groupOrArray != null)
					{
						switch(Type.typeof(groupOrArray))
						{
							case TClass(Array): //Is Array
								return groupOrArray.indexOf(leObj);
							default: //Is Group
								return Reflect.getProperty(groupOrArray, 'members').indexOf(leObj); //Has to use a Reflect here because of FlxTypedSpriteGroup
						}
					}
					else
					{
						luaTrace('getObjectOrder: Group $group doesn\'t exist!', false, false, FlxColor.RED);
						return -1;
					}
				}
				var groupOrArray:Dynamic = CustomSubstate.instance != null ? CustomSubstate.instance : LuaUtils.getTargetInstance();
				return groupOrArray.members.indexOf(leObj);
			}
			luaTrace('getObjectOrder: Object $obj doesn\'t exist!', false, false, FlxColor.RED);
			return -1;
		});
		Lua_helper.add_callback(lua, "setObjectOrder", function(obj:String, position:Int, ?group:String = null) {
			var leObj:FlxBasic = LuaUtils.getObjectDirectly(obj);
			if(leObj != null)
			{
				if(group != null)
				{
					var groupOrArray:Dynamic = Reflect.getProperty(LuaUtils.getTargetInstance(), group);
					if(groupOrArray != null)
					{
						switch(Type.typeof(groupOrArray))
						{
							case TClass(Array): //Is Array
								groupOrArray.remove(leObj);
								groupOrArray.insert(position, leObj);
							default: //Is Group
								groupOrArray.remove(leObj, true);
								groupOrArray.insert(position, leObj);
						}
					}
					else luaTrace('setObjectOrder: Group $group doesn\'t exist!', false, false, FlxColor.RED);
				}
				else
				{
					var groupOrArray:Dynamic = CustomSubstate.instance != null ? CustomSubstate.instance : LuaUtils.getTargetInstance();
					groupOrArray.remove(leObj, true);
					groupOrArray.insert(position, leObj);
				}
				return;
			}
			luaTrace('setObjectOrder: Object $obj doesn\'t exist!', false, false, FlxColor.RED);
		});

		// gay ass tweens
		Lua_helper.add_callback(lua, "startTween", function(tag:String, vars:String, values:Any = null, duration:Float, ?options:Any = null) {
			var penisExam:Dynamic = LuaUtils.tweenPrepare(tag, vars);
			if(penisExam != null)
			{
				if(values != null)
				{
					var myOptions:LuaTweenOptions = LuaUtils.getLuaTween(options);
					if(tag != null)
					{
						var variables = MusicBeatState.getVariables();
						var originalTag:String = 'tween_' + LuaUtils.formatVariable(tag);
						variables.set(tag, FlxTween.tween(penisExam, values, duration, myOptions != null ? {
							type: myOptions.type,
							ease: myOptions.ease,
							startDelay: myOptions.startDelay,
							loopDelay: myOptions.loopDelay,
	
							onUpdate: function(twn:FlxTween) {
								if(myOptions.onUpdate != null) callHostOnLuas(myOptions.onUpdate, [originalTag, vars]);
							},
							onStart: function(twn:FlxTween) {
								if(myOptions.onStart != null) callHostOnLuas(myOptions.onStart, [originalTag, vars]);
							},
							onComplete: function(twn:FlxTween) {
								if(twn.type == FlxTweenType.ONESHOT || twn.type == FlxTweenType.BACKWARD) variables.remove(tag);
								if(myOptions.onComplete != null) callHostOnLuas(myOptions.onComplete, [originalTag, vars]);
							}
						} : null));
						return tag;
					}
					else FlxTween.tween(penisExam, values, duration, myOptions != null ? {
						type: myOptions.type,
						ease: myOptions.ease,
						startDelay: myOptions.startDelay,
						loopDelay: myOptions.loopDelay,

						onUpdate: function(twn:FlxTween) {
							if(myOptions.onUpdate != null) callHostOnLuas(myOptions.onUpdate, [null, vars]);
						},
						onStart: function(twn:FlxTween) {
							if(myOptions.onStart != null) callHostOnLuas(myOptions.onStart, [null, vars]);
						},
						onComplete: function(twn:FlxTween) {
							if(myOptions.onComplete != null) callHostOnLuas(myOptions.onComplete, [null, vars]);
						}
					} : null);
				}
				else luaTrace('startTween: No values on 2nd argument!', false, false, FlxColor.RED);
			}
			else luaTrace('startTween: Couldnt find object: ' + vars, false, false, FlxColor.RED);
			return null;
		});

		Lua_helper.add_callback(lua, "doTweenX", function(tag:String, vars:String, value:Dynamic, duration:Float, ?ease:String = 'linear') {
			return oldTweenFunction(tag, vars, {x: value}, duration, ease, 'doTweenX');
		});
		Lua_helper.add_callback(lua, "doTweenY", function(tag:String, vars:String, value:Dynamic, duration:Float, ?ease:String = 'linear') {
			return oldTweenFunction(tag, vars, {y: value}, duration, ease, 'doTweenY');
		});
		Lua_helper.add_callback(lua, "doTweenAngle", function(tag:String, vars:String, value:Dynamic, duration:Float, ?ease:String = 'linear') {
			return oldTweenFunction(tag, vars, {angle: value}, duration, ease, 'doTweenAngle');
		});
		Lua_helper.add_callback(lua, "doTweenAlpha", function(tag:String, vars:String, value:Dynamic, duration:Float, ?ease:String = 'linear') {
			return oldTweenFunction(tag, vars, {alpha: value}, duration, ease, 'doTweenAlpha');
		});
		Lua_helper.add_callback(lua, "doTweenZoom", function(tag:String, camera:String, value:Dynamic, duration:Float, ?ease:String = 'linear') {
			switch(camera.toLowerCase()) {
				case 'camgame' | 'game': camera = 'camGame';
				case 'camhud' | 'hud': camera = 'camHUD';
				case 'camother' | 'other': camera = 'camOther';
				default:
					var cam:FlxCamera = MusicBeatState.getVariables().get(camera);
					if (cam == null || !Std.isOfType(cam, FlxCamera)) camera = 'camGame';
			}
			return oldTweenFunction(tag, camera, {zoom: value}, duration, ease, 'doTweenZoom');
		});
		Lua_helper.add_callback(lua, "doTweenColor", function(tag:String, vars:String, targetColor:String, duration:Float, ?ease:String = 'linear') {
			var penisExam:Dynamic = LuaUtils.tweenPrepare(tag, vars);
			if(penisExam != null) {
				var curColor:FlxColor = penisExam.color;
				curColor.alphaFloat = penisExam.alpha;
				
				if(tag != null)
				{
					var originalTag:String = tag;
					tag = LuaUtils.formatVariable('tween_$tag');
					var variables = MusicBeatState.getVariables();
					variables.set(tag, FlxTween.color(penisExam, duration, curColor, CoolUtil.colorFromString(targetColor), {ease: LuaUtils.getTweenEaseByString(ease),
						onComplete: function(twn:FlxTween)
						{
							variables.remove(tag);
							if (game != null) callHostOnLuas('onTweenCompleted', [originalTag, vars]);
						}
					}));
					return tag;
				}
				else FlxTween.color(penisExam, duration, curColor, CoolUtil.colorFromString(targetColor), {ease: LuaUtils.getTweenEaseByString(ease)});
			}
			else luaTrace('doTweenColor: Couldnt find object: ' + vars, false, false, FlxColor.RED);
			return null;
		});

		//Tween shit, but for strums
		Lua_helper.add_callback(lua, "noteTweenX", function(tag:String, note:Int, value:Dynamic, duration:Float, ?ease:String = 'linear') {
			return noteTweenFunction(tag, note, {x: value}, duration, ease);
		});
		Lua_helper.add_callback(lua, "noteTweenY", function(tag:String, note:Int, value:Dynamic, duration:Float, ?ease:String = 'linear') {
			return noteTweenFunction(tag, note, {y: value}, duration, ease);
		});
		Lua_helper.add_callback(lua, "noteTweenAngle", function(tag:String, note:Int, value:Dynamic, duration:Float, ?ease:String = 'linear') {
			return noteTweenFunction(tag, note, {angle: value}, duration, ease);
		});
		Lua_helper.add_callback(lua, "noteTweenAlpha", function(tag:String, note:Int, value:Dynamic, duration:Float, ?ease:String = 'linear') {
			return noteTweenFunction(tag, note, {alpha: value}, duration, ease);
		});
		Lua_helper.add_callback(lua, "noteTweenDirection", function(tag:String, note:Int, value:Dynamic, duration:Float, ?ease:String = 'linear') {
			return noteTweenFunction(tag, note, {direction: value}, duration, ease);
		});
		Lua_helper.add_callback(lua, "mouseClicked", function(?button:String = 'left') {
			var click:Bool = FlxG.mouse.justPressed;
			switch(button.trim().toLowerCase())
			{
				case 'middle':
					click = FlxG.mouse.justPressedMiddle;
				case 'right':
					click = FlxG.mouse.justPressedRight;
			}
			return click;
		});
		Lua_helper.add_callback(lua, "mousePressed", function(?button:String = 'left') {
			var press:Bool = FlxG.mouse.pressed;
			switch(button.trim().toLowerCase())
			{
				case 'middle':
					press = FlxG.mouse.pressedMiddle;
				case 'right':
					press = FlxG.mouse.pressedRight;
			}
			return press;
		});
		Lua_helper.add_callback(lua, "mouseReleased", function(?button:String = 'left') {
			var released:Bool = FlxG.mouse.justReleased;
			switch(button.trim().toLowerCase())
			{
				case 'middle':
					released = FlxG.mouse.justReleasedMiddle;
				case 'right':
					released = FlxG.mouse.justReleasedRight;
			}
			return released;
		});

		Lua_helper.add_callback(lua, "cancelTween", function(tag:String) LuaUtils.cancelTween(tag));

		Lua_helper.add_callback(lua, "runTimer", function(tag:String, time:Float = 1, loops:Int = 1) {
			LuaUtils.cancelTimer(tag);
			var variables = MusicBeatState.getVariables();
			
			var originalTag:String = tag;
			tag = LuaUtils.formatVariable('timer_$tag');
			variables.set(tag, new FlxTimer().start(time, function(tmr:FlxTimer)
			{
				if(tmr.finished) variables.remove(tag);
				callHostOnLuas('onTimerCompleted', [originalTag, tmr.loops, tmr.loopsLeft]);
				//trace('Timer Completed: ' + tag);
			}, loops));
			return tag;
		});
		Lua_helper.add_callback(lua, "cancelTimer", function(tag:String) LuaUtils.cancelTimer(tag));

		//stupid bietch ass functions
		Lua_helper.add_callback(lua, "addScore", function(value:Int = 0) {
			game.songScore += value;
			game.RecalculateRating();
		});
		Lua_helper.add_callback(lua, "addMisses", function(value:Int = 0) {
			game.songMisses += value;
			game.RecalculateRating();
		});
		Lua_helper.add_callback(lua, "addHits", function(value:Int = 0) {
			game.songHits += value;
			game.RecalculateRating();
		});
		Lua_helper.add_callback(lua, "setScore", function(value:Int = 0) {
			game.songScore = value;
			game.RecalculateRating();
		});
		Lua_helper.add_callback(lua, "setMisses", function(value:Int = 0) {
			game.songMisses = value;
			game.RecalculateRating();
		});
		Lua_helper.add_callback(lua, "setHits", function(value:Int = 0) {
			game.songHits = value;
			game.RecalculateRating();
		});
		Lua_helper.add_callback(lua, "setHealth", function(value:Float = 1) game.health = value);
		Lua_helper.add_callback(lua, "addHealth", function(value:Float = 0) game.health += value);
		Lua_helper.add_callback(lua, "getHealth", function() return game.health);

		Lua_helper.add_callback(lua, "getScore", function() {
			return game.songScore;
		});
		Lua_helper.add_callback(lua, "getMisses", function() {
			return game.songMisses;
		});
		Lua_helper.add_callback(lua, "getHits", function() {
			return game.songHits;
		});

		//Identical functions
		Lua_helper.add_callback(lua, "FlxColor", function(color:String) return FlxColor.fromString(color));
		Lua_helper.add_callback(lua, "getColorFromName", function(color:String) return FlxColor.fromString(color));
		Lua_helper.add_callback(lua, "getColorFromString", function(color:String) return FlxColor.fromString(color));
		Lua_helper.add_callback(lua, "getColorFromHex", function(color:String) return FlxColor.fromString('#$color'));

		// precaching
		Lua_helper.add_callback(lua, "addCharacterToList", function(name:String, type:String) {
			var charType:Int = 0;
			switch(type.toLowerCase()) {
				case 'dad': charType = 1;
				case 'gf' | 'girlfriend': charType = 2;
			}
			game.addCharacterToList(name, charType);
		});
		Lua_helper.add_callback(lua, "precacheImage", function(name:String, ?allowGPU:Bool = true) {
			Paths.image(name, allowGPU);
		});
		Lua_helper.add_callback(lua, "precacheSound", function(name:String) {
			Paths.sound(name);
		});
		Lua_helper.add_callback(lua, "precacheMusic", function(name:String) {
			Paths.music(name);
		});

		// others
		Lua_helper.add_callback(lua, "triggerEvent", function(name:String, ?value1:String = '', ?value2:String = '') {
			if (game != null && Reflect.hasField(game, 'triggerEvent'))
				Reflect.callMethod(game, Reflect.field(game, 'triggerEvent'), [name, value1, value2, '', Conductor.songPosition]);
			return true;
		});

		Lua_helper.add_callback(lua, "startCountdown", function() {
			game.startCountdown();
			return true;
		});
		Lua_helper.add_callback(lua, "endSong", function() {
			game.KillNotes();
			game.endSong();
			return true;
		});
		Lua_helper.add_callback(lua, "restartSong", function(?skipTransition:Bool = false) {
			if (playState == null) return false;
			playState.persistentUpdate = false;
			FlxG.camera.followLerp = 0;
			PauseSubState.restartSong(skipTransition);
			return true;
		});
		Lua_helper.add_callback(lua, "exitSong", function(?skipTransition:Bool = false) {
			if(skipTransition)
			{
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
			}

			if(PlayState.isStoryMode)
				MusicBeatState.switchState(new StoryMenuState());
			else
				MusicBeatState.switchState(new FreeplayState());

			#if DISCORD_ALLOWED DiscordClient.resetClientID(); #end

			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			PlayState.changedDifficulty = false;
			PlayState.chartingMode = false;
			if (playState != null) playState.transitioning = true;
			FlxG.camera.followLerp = 0;
			Mods.loadTopMod();
			return true;
		});
		Lua_helper.add_callback(lua, "getSongPosition", function() {
			return Conductor.songPosition;
		});

		Lua_helper.add_callback(lua, "getCharacterX", function(type:String) {
			switch(type.toLowerCase()) {
				case 'dad' | 'opponent':
					return game.dadGroup.x;
				case 'gf' | 'girlfriend':
					return game.gfGroup.x;
				default:
					return game.boyfriendGroup.x;
			}
		});
		Lua_helper.add_callback(lua, "setCharacterX", function(type:String, value:Float) {
			switch(type.toLowerCase()) {
				case 'dad' | 'opponent':
					game.dadGroup.x = value;
				case 'gf' | 'girlfriend':
					game.gfGroup.x = value;
				default:
					game.boyfriendGroup.x = value;
			}
		});
		Lua_helper.add_callback(lua, "getCharacterY", function(type:String) {
			switch(type.toLowerCase()) {
				case 'dad' | 'opponent':
					return game.dadGroup.y;
				case 'gf' | 'girlfriend':
					return game.gfGroup.y;
				default:
					return game.boyfriendGroup.y;
			}
		});
		Lua_helper.add_callback(lua, "setCharacterY", function(type:String, value:Float) {
			switch(type.toLowerCase()) {
				case 'dad' | 'opponent':
					game.dadGroup.y = value;
				case 'gf' | 'girlfriend':
					game.gfGroup.y = value;
				default:
					game.boyfriendGroup.y = value;
			}
		});
		Lua_helper.add_callback(lua, "cameraSetTarget", function(target:String) {
			switch(target.trim().toLowerCase())
			{
				case 'gf', 'girlfriend':
					game.moveCameraToGirlfriend();
				case 'dad', 'opponent':
					game.moveCamera(true);
				default:
					game.moveCamera(false);
			}
		});

		Lua_helper.add_callback(lua, "setCameraScroll", function(x:Float, y:Float) FlxG.camera.scroll.set(x - FlxG.width/2, y - FlxG.height/2));
		Lua_helper.add_callback(lua, "setCameraFollowPoint", function(x:Float, y:Float) game.camFollow.setPosition(x, y));
		Lua_helper.add_callback(lua, "addCameraScroll", function(?x:Float = 0, ?y:Float = 0) FlxG.camera.scroll.add(x, y));
		Lua_helper.add_callback(lua, "addCameraFollowPoint", function(?x:Float = 0, ?y:Float = 0) {
			game.camFollow.x += x;
			game.camFollow.y += y;
		});
		Lua_helper.add_callback(lua, "getCameraScrollX", () -> FlxG.camera.scroll.x + FlxG.width/2);
		Lua_helper.add_callback(lua, "getCameraScrollY", () -> FlxG.camera.scroll.y + FlxG.height/2);
		Lua_helper.add_callback(lua, "getCameraFollowX", () -> game != null && game.camFollow != null ? game.camFollow.x : 0);
		Lua_helper.add_callback(lua, "getCameraFollowY", () -> game != null && game.camFollow != null ? game.camFollow.y : 0);

		Lua_helper.add_callback(lua, "cameraShake", function(camera:String, intensity:Float, duration:Float) {
			LuaUtils.cameraFromString(camera).shake(intensity, duration);
		});

		Lua_helper.add_callback(lua, "cameraFlash", function(camera:String, color:String, duration:Float,forced:Bool) {
			LuaUtils.cameraFromString(camera).flash(CoolUtil.colorFromString(color), duration, null, forced);
		});
		Lua_helper.add_callback(lua, "cameraFade", function(camera:String, color:String, duration:Float, forced:Bool, ?fadeOut:Bool = false) {
			LuaUtils.cameraFromString(camera).fade(CoolUtil.colorFromString(color), duration, fadeOut, null, forced);
		});
		Lua_helper.add_callback(lua, "setRatingPercent", function(value:Float) {
			game.ratingPercent = value;
			setHostOnScripts('rating', game.ratingPercent);
		});
		Lua_helper.add_callback(lua, "setRatingName", function(value:String) {
			game.ratingName = value;
			setHostOnScripts('ratingName', game.ratingName);
		});
		Lua_helper.add_callback(lua, "setRatingFC", function(value:String) {
			game.ratingFC = value;
			setHostOnScripts('ratingFC', game.ratingFC);
		});
		Lua_helper.add_callback(lua, "updateScoreText", function() game.updateScoreText());
		Lua_helper.add_callback(lua, "getMouseX", function(?camera:String = 'game') {
			var cam:FlxCamera = LuaUtils.cameraFromString(camera);
			return FlxG.mouse.getScreenPosition(cam).x;
		});
		Lua_helper.add_callback(lua, "getMouseY", function(?camera:String = 'game') {
			var cam:FlxCamera = LuaUtils.cameraFromString(camera);
			return FlxG.mouse.getScreenPosition(cam).y;
		});

		Lua_helper.add_callback(lua, "getMidpointX", function(variable:String) {
			var split:Array<String> = variable.split('.');
			var obj:FlxObject = LuaUtils.getObjectDirectly(split[0]);
			if(split.length > 1) {
				obj = LuaUtils.getVarInArray(LuaUtils.getPropertyLoop(split), split[split.length-1]);
			}
			if(obj != null) return obj.getMidpoint().x;

			return 0;
		});
		Lua_helper.add_callback(lua, "getMidpointY", function(variable:String) {
			var split:Array<String> = variable.split('.');
			var obj:FlxObject = LuaUtils.getObjectDirectly(split[0]);
			if(split.length > 1) {
				obj = LuaUtils.getVarInArray(LuaUtils.getPropertyLoop(split), split[split.length-1]);
			}
			if(obj != null) return obj.getMidpoint().y;

			return 0;
		});
		Lua_helper.add_callback(lua, "getGraphicMidpointX", function(variable:String) {
			var split:Array<String> = variable.split('.');
			var obj:FlxSprite = LuaUtils.getObjectDirectly(split[0]);
			if(split.length > 1) {
				obj = LuaUtils.getVarInArray(LuaUtils.getPropertyLoop(split), split[split.length-1]);
			}
			if(obj != null) return obj.getGraphicMidpoint().x;

			return 0;
		});
		Lua_helper.add_callback(lua, "getGraphicMidpointY", function(variable:String) {
			var split:Array<String> = variable.split('.');
			var obj:FlxSprite = LuaUtils.getObjectDirectly(split[0]);
			if(split.length > 1) {
				obj = LuaUtils.getVarInArray(LuaUtils.getPropertyLoop(split), split[split.length-1]);
			}
			if(obj != null) return obj.getGraphicMidpoint().y;

			return 0;
		});
		Lua_helper.add_callback(lua, "getScreenPositionX", function(variable:String, ?camera:String = 'game') {
			var split:Array<String> = variable.split('.');
			var obj:FlxObject = LuaUtils.getObjectDirectly(split[0]);
			if(split.length > 1) {
				obj = LuaUtils.getVarInArray(LuaUtils.getPropertyLoop(split), split[split.length-1]);
			}
			if(obj != null) return obj.getScreenPosition(LuaUtils.cameraFromString(camera)).x;

			return 0;
		});
		Lua_helper.add_callback(lua, "getScreenPositionY", function(variable:String, ?camera:String = 'game') {
			var split:Array<String> = variable.split('.');
			var obj:FlxObject = LuaUtils.getObjectDirectly(split[0]);
			if(split.length > 1) {
				obj = LuaUtils.getVarInArray(LuaUtils.getPropertyLoop(split), split[split.length-1]);
			}
			if(obj != null) return obj.getScreenPosition(LuaUtils.cameraFromString(camera)).y;

			return 0;
		});
		Lua_helper.add_callback(lua, "characterDance", function(character:String) {
			switch(character.toLowerCase()) {
				case 'dad': game.dad.dance();
				case 'gf' | 'girlfriend': if(game.gf != null) game.gf.dance();
				default: game.boyfriend.dance();
			}
		});

		Lua_helper.add_callback(lua, "makeLuaSprite", function(tag:String, ?image:String = null, ?x:Float = 0, ?y:Float = 0) {
			tag = tag.replace('.', '');
			LuaUtils.destroyObject(tag);
			var leSprite:ModchartSprite = new ModchartSprite(x, y);
			if(image != null && image.length > 0)
			{
				leSprite.loadGraphic(Paths.image(image));
			}
			MusicBeatState.getVariables().set(tag, leSprite);
			leSprite.active = true;
		});
		Lua_helper.add_callback(lua, "makeAnimatedLuaSprite", function(tag:String, ?image:String = null, ?x:Float = 0, ?y:Float = 0, ?spriteType:String = 'auto') {
			tag = tag.replace('.', '');
			LuaUtils.destroyObject(tag);
			var leSprite:ModchartSprite = new ModchartSprite(x, y);

			if(image != null && image.length > 0)
			{
				LuaUtils.loadFrames(leSprite, image, spriteType);
			}
			MusicBeatState.getVariables().set(tag, leSprite);
		});

		Lua_helper.add_callback(lua, "makeGraphic", function(obj:String, width:Int = 256, height:Int = 256, color:String = 'FFFFFF') {
			var spr:FlxSprite = LuaUtils.getObjectDirectly(obj);
			if(spr != null) spr.makeGraphic(width, height, CoolUtil.colorFromString(color));
		});
		Lua_helper.add_callback(lua, "addAnimationByPrefix", function(obj:String, name:String, prefix:String, framerate:Float = 24, loop:Bool = true) {
			var obj:FlxSprite = cast LuaUtils.getObjectDirectly(obj);
			if(obj != null && obj.animation != null)
			{
				obj.animation.addByPrefix(name, prefix, framerate, loop);
				if(obj.animation.curAnim == null)
				{
					var dyn:Dynamic = cast obj;
					if(dyn.playAnim != null) dyn.playAnim(name, true);
					else dyn.animation.play(name, true);
				}
				return true;
			}
			return false;
		});

		Lua_helper.add_callback(lua, "addAnimation", function(obj:String, name:String, frames:Any, framerate:Float = 24, loop:Bool = true) {
			return LuaUtils.addAnimByIndices(obj, name, null, frames, framerate, loop);
		});

		Lua_helper.add_callback(lua, "addAnimationByIndices", function(obj:String, name:String, prefix:String, indices:Any, framerate:Float = 24, loop:Bool = false) {
			return LuaUtils.addAnimByIndices(obj, name, prefix, indices, framerate, loop);
		});

		Lua_helper.add_callback(lua, "playAnim", function(obj:String, name:String, ?forced:Bool = false, ?reverse:Bool = false, ?startFrame:Int = 0)
		{
			var obj:Dynamic = LuaUtils.getObjectDirectly(obj);
			if(obj.playAnim != null)
			{
				obj.playAnim(name, forced, reverse, startFrame);
				return true;
			}
			else
			{
				if(obj.anim != null) obj.anim.play(name, forced, reverse, startFrame); //FlxAnimate
				else obj.animation.play(name, forced, reverse, startFrame);
				return true;
			}
			return false;
		});
		Lua_helper.add_callback(lua, "addOffset", function(obj:String, anim:String, x:Float, y:Float) {
			var obj:Dynamic = LuaUtils.getObjectDirectly(obj);
			if(obj != null && obj.addOffset != null)
			{
				obj.addOffset(anim, x, y);
				return true;
			}
			return false;
		});

		Lua_helper.add_callback(lua, "setScrollFactor", function(obj:String, scrollX:Float, scrollY:Float) {
			if(LuaUtils.getScriptLuaObject(obj) != null) {
				LuaUtils.getScriptLuaObject(obj).scrollFactor.set(scrollX, scrollY);
				return;
			}

			var object:FlxObject = Reflect.getProperty(LuaUtils.getTargetInstance(), obj);
			if(object != null) {
				object.scrollFactor.set(scrollX, scrollY);
			}
		});
		Lua_helper.add_callback(lua, "addLuaSprite", function(tag:String, ?inFront:Bool = false) {
			var mySprite:FlxSprite = MusicBeatState.getVariables().get(tag);
			if(mySprite == null) return;

			if (inChartEditor && chartHost != null)
			{
				if (inFront)
					chartHost.previewGroup.add(mySprite);
				else
				{
					var insertAt:Int = chartHost.previewGroup.members.indexOf(LuaUtils.getLowestCharacterGroup());
					if (insertAt < 0) insertAt = 0;
					chartHost.previewGroup.insert(insertAt, mySprite);
				}
				return;
			}

			var instance = LuaUtils.getTargetInstance();
			if(inFront)
				instance.add(mySprite);
			else
			{
				if(PlayState.instance == null || !PlayState.instance.isDead)
					instance.insert(instance.members.indexOf(LuaUtils.getLowestCharacterGroup()), mySprite);
				else
					GameOverSubstate.instance.insert(GameOverSubstate.instance.members.indexOf(GameOverSubstate.instance.boyfriend), mySprite);
			}
		});
		Lua_helper.add_callback(lua, "setGraphicSize", function(obj:String, x:Float, y:Float = 0, updateHitbox:Bool = true) {
			if(LuaUtils.getScriptLuaObject(obj)!=null) {
				var shit:FlxSprite = LuaUtils.getScriptLuaObject(obj);
				shit.setGraphicSize(x, y);
				if(updateHitbox) shit.updateHitbox();
				return;
			}

			var split:Array<String> = obj.split('.');
			var poop:FlxSprite = LuaUtils.getObjectDirectly(split[0]);
			if(split.length > 1) {
				poop = LuaUtils.getVarInArray(LuaUtils.getPropertyLoop(split), split[split.length-1]);
			}

			if(poop != null) {
				poop.setGraphicSize(x, y);
				if(updateHitbox) poop.updateHitbox();
				return;
			}
			luaTrace('setGraphicSize: Couldnt find object: ' + obj, false, false, FlxColor.RED);
		});
		Lua_helper.add_callback(lua, "scaleObject", function(obj:String, x:Float, y:Float, updateHitbox:Bool = true) {
			if(LuaUtils.getScriptLuaObject(obj)!=null) {
				var shit:FlxSprite = LuaUtils.getScriptLuaObject(obj);
				shit.scale.set(x, y);
				if(updateHitbox) shit.updateHitbox();
				return;
			}

			var split:Array<String> = obj.split('.');
			var poop:FlxSprite = LuaUtils.getObjectDirectly(split[0]);
			if(split.length > 1) {
				poop = LuaUtils.getVarInArray(LuaUtils.getPropertyLoop(split), split[split.length-1]);
			}

			if(poop != null) {
				poop.scale.set(x, y);
				if(updateHitbox) poop.updateHitbox();
				return;
			}
			luaTrace('scaleObject: Couldnt find object: ' + obj, false, false, FlxColor.RED);
		});
		Lua_helper.add_callback(lua, "updateHitbox", function(obj:String) {
			if(LuaUtils.getScriptLuaObject(obj)!=null) {
				var shit:FlxSprite = LuaUtils.getScriptLuaObject(obj);
				shit.updateHitbox();
				return;
			}

			var split:Array<String> = obj.split('.');
			var poop:FlxSprite = LuaUtils.getObjectDirectly(split[0]);
			if(split.length > 1) {
				poop = LuaUtils.getVarInArray(LuaUtils.getPropertyLoop(split), split[split.length-1]);
			}

			if(poop != null) {
				poop.updateHitbox();
				return;
			}
			luaTrace('updateHitbox: Couldnt find object: ' + obj, false, false, FlxColor.RED);
		});

		Lua_helper.add_callback(lua, "removeLuaSprite", function(tag:String, destroy:Bool = true, ?group:String = null) {
			var obj:FlxSprite = LuaUtils.getObjectDirectly(tag);
			if(obj == null || obj.destroy == null)
				return;
			
			var groupObj:Dynamic = null;
			if(group == null) groupObj = LuaUtils.getTargetInstance();
			else groupObj = LuaUtils.getObjectDirectly(group);

			groupObj.remove(obj, true);
			if(destroy)
			{
				MusicBeatState.getVariables().remove(tag);
				obj.destroy();
			}
		});

		Lua_helper.add_callback(lua, "luaSpriteExists", function(tag:String) {
			var obj:FlxSprite = MusicBeatState.getVariables().get(tag);
			return (obj != null && (Std.isOfType(obj, ModchartSprite) || Std.isOfType(obj, ModchartAnimateSprite)));
		});
		Lua_helper.add_callback(lua, "luaTextExists", function(tag:String) {
			var obj:FlxText = MusicBeatState.getVariables().get(tag);
			return (obj != null && Std.isOfType(obj, FlxText));
		});
		Lua_helper.add_callback(lua, "luaSoundExists", function(tag:String) {
			var obj:FlxSound = MusicBeatState.getVariables().get('sound_$tag');
			return (obj != null && Std.isOfType(obj, FlxSound));
		});

		Lua_helper.add_callback(lua, "setHealthBarColors", function(left:String, right:String) {
			if (playState == null || playState.healthBar == null) return;
			var left_color:Null<FlxColor> = null;
			var right_color:Null<FlxColor> = null;
			if (left != null && left != '')
				left_color = CoolUtil.colorFromString(left);
			if (right != null && right != '')
				right_color = CoolUtil.colorFromString(right);
			playState.healthBar.setColors(left_color, right_color);
		});
		Lua_helper.add_callback(lua, "setTimeBarColors", function(left:String, right:String) {
			if (playState == null || playState.timeBar == null) return;
			var left_color:Null<FlxColor> = null;
			var right_color:Null<FlxColor> = null;
			if (left != null && left != '')
				left_color = CoolUtil.colorFromString(left);
			if (right != null && right != '')
				right_color = CoolUtil.colorFromString(right);
			playState.timeBar.setColors(left_color, right_color);
		});

		Lua_helper.add_callback(lua, "setObjectCamera", function(obj:String, camera:String = 'game') {
			var real:FlxBasic = LuaUtils.getScriptLuaObject(obj);
			if(real != null) {
				real.cameras = [LuaUtils.cameraFromString(camera)];
				return true;
			}

			var split:Array<String> = obj.split('.');
			var object:FlxBasic = LuaUtils.getObjectDirectly(split[0]);
			if(split.length > 1) {
				object = LuaUtils.getVarInArray(LuaUtils.getPropertyLoop(split), split[split.length-1]);
			}

			if(object != null) {
				object.cameras = [LuaUtils.cameraFromString(camera)];
				return true;
			}
			luaTrace("setObjectCamera: Object " + obj + " doesn't exist!", false, false, FlxColor.RED);
			return false;
		});
		Lua_helper.add_callback(lua, "setBlendMode", function(obj:String, blend:String = '') {
			var real:FlxSprite = LuaUtils.getScriptLuaObject(obj);
			if(real != null) {
				real.blend = LuaUtils.blendModeFromString(blend);
				return true;
			}

			var split:Array<String> = obj.split('.');
			var spr:FlxSprite = LuaUtils.getObjectDirectly(split[0]);
			if(split.length > 1) {
				spr = LuaUtils.getVarInArray(LuaUtils.getPropertyLoop(split), split[split.length-1]);
			}

			if(spr != null) {
				spr.blend = LuaUtils.blendModeFromString(blend);
				return true;
			}
			luaTrace("setBlendMode: Object " + obj + " doesn't exist!", false, false, FlxColor.RED);
			return false;
		});
		Lua_helper.add_callback(lua, "screenCenter", function(obj:String, pos:String = 'xy') {
			var spr:FlxObject = LuaUtils.getScriptLuaObject(obj);

			if(spr==null){
				var split:Array<String> = obj.split('.');
				spr = LuaUtils.getObjectDirectly(split[0]);
				if(split.length > 1) {
					spr = LuaUtils.getVarInArray(LuaUtils.getPropertyLoop(split), split[split.length-1]);
				}
			}

			if(spr != null)
			{
				switch(pos.trim().toLowerCase())
				{
					case 'x':
						spr.screenCenter(X);
						return;
					case 'y':
						spr.screenCenter(Y);
						return;
					default:
						spr.screenCenter(XY);
						return;
				}
			}
			luaTrace("screenCenter: Object " + obj + " doesn't exist!", false, false, FlxColor.RED);
		});
		Lua_helper.add_callback(lua, "objectsOverlap", function(obj1:String, obj2:String) {
			var namesArray:Array<String> = [obj1, obj2];
			var objectsArray:Array<FlxBasic> = [];
			for (i in 0...namesArray.length)
			{
				var real:FlxBasic = LuaUtils.getScriptLuaObject(namesArray[i]);
				if(real != null)
					objectsArray.push(real);
				else
					objectsArray.push(Reflect.getProperty(LuaUtils.getTargetInstance(), namesArray[i]));
			}
			return (!objectsArray.contains(null) && FlxG.overlap(objectsArray[0], objectsArray[1]));
		});
		Lua_helper.add_callback(lua, "getPixelColor", function(obj:String, x:Int, y:Int) {
			var split:Array<String> = obj.split('.');
			var spr:FlxSprite = LuaUtils.getObjectDirectly(split[0]);
			if(split.length > 1) {
				spr = LuaUtils.getVarInArray(LuaUtils.getPropertyLoop(split), split[split.length-1]);
			}

			if(spr != null) return spr.pixels.getPixel32(x, y);
			return FlxColor.BLACK;
		});
		Lua_helper.add_callback(lua, "startDialogue", function(dialogueFile:String, ?music:String = null) {
			var path:String;
			var songPath:String = Paths.formatToSongPath(Song.loadedSongName);
			#if TRANSLATIONS_ALLOWED
			path = Paths.getPath('songs/$songPath/${dialogueFile}_${ClientPrefs.data.language}.json', TEXT);
			#if MODS_ALLOWED
			if(!FileSystem.exists(path))
			#else
			if(!Assets.exists(path, TEXT))
			#end
			#end
				path = Paths.getPath('songs/$songPath/$dialogueFile.json', TEXT);
				//Is it that hard? Why are we trying to make it harder when THIS SINGLE FUCKING LINE FIXES EVERYTHING??
				//Anyways for backwards compatibility the path line under here fixes it. Unless you wanna go modern, do the one above this line as it depends on the script.
				//I believe it's harder because of translations which is understandable. But again this was a simple fix.
				//Basically ShadowMario made it so you use startDialogue under startCountdown which is 100x easier. But with older mods it was different maybe..? Idk but do wtv
				//Oh and btw, this won't put 2 dialogues. It'll always spawn 1 dialogue file only. So no worries about that.
				path = Paths.json(Paths.formatToSongPath(PlayState.SONG.song) + '/' + dialogueFile);

			luaTrace('startDialogue: Trying to load dialogue: ' + path);

			#if MODS_ALLOWED
			if(FileSystem.exists(path))
			#else
			if(Assets.exists(path, TEXT))
			#end
			{
				var shit:DialogueFile = DialogueBoxPsych.parseDialogue(path);
				if(shit.dialogue.length > 0)
				{
					game.startDialogue(shit, music);
					luaTrace('startDialogue: Successfully loaded dialogue', false, false, FlxColor.GREEN);
					return true;
				}
				else luaTrace('startDialogue: Your dialogue file is badly formatted!', false, false, FlxColor.RED);
			}
			else
			{
				luaTrace('startDialogue: Dialogue file not found', false, false, FlxColor.RED);
				if(game.endingSong)
					game.endSong();
				else
					game.startCountdown();
			}
			return false;
		});
		Lua_helper.add_callback(lua, "startVideo", function(videoFile:String, ?canSkip:Bool = true, ?forMidSong:Bool = false, ?shouldLoop:Bool = false, ?playOnLoad:Bool = true) {
			#if VIDEOS_ALLOWED
			if(FileSystem.exists(Paths.video(videoFile)))
			{
				if(game.videoCutscene != null)
				{
					game.remove(game.videoCutscene);
					game.videoCutscene.destroy();
				}
				game.videoCutscene = game.startVideo(videoFile, forMidSong, canSkip, shouldLoop, playOnLoad);
				return true;
			}
			else
			{
				luaTrace('startVideo: Video file not found: ' + videoFile, false, false, FlxColor.RED);
			}
			return false;

			#else
			PlayState.instance.inCutscene = true;
			new FlxTimer().start(0.1, function(tmr:FlxTimer)
			{
				PlayState.instance.inCutscene = false;
				if(game.endingSong)
					game.endSong();
				else
					game.startCountdown();
			});
			return true;
			#end
		});

		Lua_helper.add_callback(lua, "playMusic", function(sound:String, ?volume:Float = 1, ?loop:Bool = false) {
			FlxG.sound.playMusic(Paths.music(sound), volume, loop);
		});
		Lua_helper.add_callback(lua, "playSound", function(sound:String, ?volume:Float = 1, ?tag:String = null, ?loop:Bool = false) {
			if(tag != null && tag.length > 0)
			{
				var originalTag:String = tag;
				tag = LuaUtils.formatVariable('sound_$tag');
				var variables = MusicBeatState.getVariables();
				var oldSnd = variables.get(tag);
				if(oldSnd != null)
				{
					oldSnd.stop();
					oldSnd.destroy();
				}

				variables.set(tag, FlxG.sound.play(Paths.sound(sound), volume, loop, null, true, function()
				{
					if(!loop) variables.remove(tag);
					if(game != null) callHostOnLuas('onSoundFinished', [originalTag]);
				}));
				return tag;
			}
			FlxG.sound.play(Paths.sound(sound), volume);
			return null;
		});
		Lua_helper.add_callback(lua, "stopSound", function(tag:String) {
			if(tag == null || tag.length < 1)
			{
				if(FlxG.sound.music != null)
					FlxG.sound.music.stop();
			}
			else
			{
				tag = LuaUtils.formatVariable('sound_$tag');
				var variables = MusicBeatState.getVariables();
				var snd:FlxSound = variables.get(tag);
				if(snd != null)
				{
					snd.stop();
					variables.remove(tag);
				}
			}
		});
		Lua_helper.add_callback(lua, "pauseSound", function(tag:String) {
			if(tag == null || tag.length < 1)
			{
				if(FlxG.sound.music != null)
					FlxG.sound.music.pause();
			}
			else
			{
				tag = LuaUtils.formatVariable('sound_$tag');
				var snd:FlxSound = MusicBeatState.getVariables().get(tag);
				if(snd != null) snd.pause();
			}
		});
		Lua_helper.add_callback(lua, "resumeSound", function(tag:String) {
			if(tag == null || tag.length < 1)
			{
				if(FlxG.sound.music != null)
					FlxG.sound.music.play();
			}
			else
			{
				tag = LuaUtils.formatVariable('sound_$tag');
				var snd:FlxSound = MusicBeatState.getVariables().get(tag);
				if(snd != null) snd.play();
			}
		});
		Lua_helper.add_callback(lua, "soundFadeIn", function(tag:String, duration:Float, fromValue:Float = 0, toValue:Float = 1) {
			if(tag == null || tag.length < 1)
			{
				if(FlxG.sound.music != null)
					FlxG.sound.music.fadeIn(duration, fromValue, toValue);
			}
			else
			{
				tag = LuaUtils.formatVariable('sound_$tag');
				var snd:FlxSound = MusicBeatState.getVariables().get(tag);
				if(snd != null)
					snd.fadeIn(duration, fromValue, toValue);
			}
		});
		Lua_helper.add_callback(lua, "soundFadeOut", function(tag:String, duration:Float, toValue:Float = 0) {
			if(tag == null || tag.length < 1)
			{
				if(FlxG.sound.music != null)
					FlxG.sound.music.fadeOut(duration, toValue);
			}
			else
			{
				tag = LuaUtils.formatVariable('sound_$tag');
				var snd:FlxSound = MusicBeatState.getVariables().get(tag);
				if(snd != null)
					snd.fadeOut(duration, toValue);
			}
		});
		Lua_helper.add_callback(lua, "soundFadeCancel", function(tag:String) {
			if(tag == null || tag.length < 1)
			{
				if(FlxG.sound.music != null && FlxG.sound.music.fadeTween != null)
					FlxG.sound.music.fadeTween.cancel();
			}
			else
			{
				tag = LuaUtils.formatVariable('sound_$tag');
				var snd:FlxSound = MusicBeatState.getVariables().get(tag);
				if(snd != null && snd.fadeTween != null)
					snd.fadeTween.cancel();
			}
		});
		Lua_helper.add_callback(lua, "getSoundVolume", function(tag:String) {
			if(tag == null || tag.length < 1)
			{
				if(FlxG.sound.music != null)
					return FlxG.sound.music.volume;
			}
			else
			{
				tag = LuaUtils.formatVariable('sound_$tag');
				var snd:FlxSound = MusicBeatState.getVariables().get(tag);
				if(snd != null) return snd.volume;
			}
			return 0;
		});
		Lua_helper.add_callback(lua, "setSoundVolume", function(tag:String, value:Float) {
			if(tag == null || tag.length < 1)
			{
				tag = LuaUtils.formatVariable('sound_$tag');
				if(FlxG.sound.music != null)
				{
					FlxG.sound.music.volume = value;
					return;
				}
			}
			else
			{
				tag = LuaUtils.formatVariable('sound_$tag');
				var snd:FlxSound = MusicBeatState.getVariables().get(tag);
				if(snd != null) snd.volume = value;
			}
		});
		Lua_helper.add_callback(lua, "getSoundTime", function(tag:String) {
			if(tag == null || tag.length < 1)
			{
				return FlxG.sound.music != null ? FlxG.sound.music.time : 0;
			}
			tag = LuaUtils.formatVariable('sound_$tag');
			var snd:FlxSound = MusicBeatState.getVariables().get(tag);
			return snd != null ? snd.time : 0;
		});
		Lua_helper.add_callback(lua, "setSoundTime", function(tag:String, value:Float) {
			if(tag == null || tag.length < 1)
			{
				if(FlxG.sound.music != null)
				{
					FlxG.sound.music.time = value;
					return;
				}
			}
			else
			{
				tag = LuaUtils.formatVariable('sound_$tag');
				var snd:FlxSound = MusicBeatState.getVariables().get(tag);
				if(snd != null) snd.time = value;
			}
		});
		Lua_helper.add_callback(lua, "getSoundPitch", function(tag:String) {
			#if FLX_PITCH
			tag = LuaUtils.formatVariable('sound_$tag');
			var snd:FlxSound = MusicBeatState.getVariables().get(tag);
			return snd != null ? snd.pitch : 1;
			#else
			luaTrace("getSoundPitch: Sound Pitch is not supported on this platform!", false, false, FlxColor.RED);
			return 1;
			#end
		});
		Lua_helper.add_callback(lua, "setSoundPitch", function(tag:String, value:Float, ?doPause:Bool = false) {
			#if FLX_PITCH
			tag = LuaUtils.formatVariable('sound_$tag');
			var snd:FlxSound = MusicBeatState.getVariables().get(tag);
			if(snd != null)
			{
				var wasResumed:Bool = snd.playing;
				if (doPause) snd.pause();
				snd.pitch = value;
				if (doPause && wasResumed) snd.play();
			}
			
			if(tag == null || tag.length < 1)
			{
				if(FlxG.sound.music != null)
				{
					var wasResumed:Bool = FlxG.sound.music.playing;
					if (doPause) FlxG.sound.music.pause();
					FlxG.sound.music.pitch = value;
					if (doPause && wasResumed) FlxG.sound.music.play();
					return;
				}
			}
			else
			{
				var snd:FlxSound = MusicBeatState.getVariables().get(tag);
				if(snd != null)
				{
					var wasResumed:Bool = snd.playing;
					if (doPause) snd.pause();
					snd.pitch = value;
					if (doPause && wasResumed) snd.play();
				}
			}
			#else
			luaTrace("setSoundPitch: Sound Pitch is not supported on this platform!", false, false, FlxColor.RED);
			#end
		});

		// mod settings
		addLocalCallback("getModSetting", function(saveTag:String, ?modName:String = null) {
			#if MODS_ALLOWED
			if(modName == null)
			{
				if(this.modFolder == null)
				{
					FunkinLua.luaTrace('getModSetting: Argument #2 is null and script is not inside a packed Mod folder!', false, false, FlxColor.RED);
					return null;
				}
				modName = this.modFolder;
			}
			return LuaUtils.getModSetting(saveTag, modName);
			#else
			luaTrace("getModSetting: Mods are disabled in this build!", false, false, FlxColor.RED);
			#end
		});
		//

		Lua_helper.add_callback(lua, "debugPrint", function(text:Dynamic = '', color:String = 'WHITE') {
			if (PlayState.instance != null)
				PlayState.instance.addTextToDebug(text, CoolUtil.colorFromString(color));
			else
				trace('[Lua debugPrint] $text');
		});

		addLocalCallback("close", function() {
			closed = true;
			trace('Closing script $scriptName');
			return closed;
		});

		// Turns out, there IS a reason this block of code exists
		#if DISCORD_ALLOWED DiscordClient.implement(lua); #end
		#if ACHIEVEMENTS_ALLOWED Achievements.addLuaCallbacks(lua); #end
		#if TRANSLATIONS_ALLOWED Language.addLuaCallbacks(lua); #end
		#if flxanimate FlxAnimateFunctions.implement(this); #end
		yutautil.ExtendedDate.addLuaCallbacks(lua);
		HScript.implement(this);
		ReflectionFunctions.implement(this);
		TextFunctions.implement(this);
		// ExtraFunctions.implement(this);
		CustomSubstate.implement(this);
		ShaderFunctions.implement(this);
		// DeprecatedFunctions.implement(this);
		// CursorFunctions.implement(this);
		// VideoFunctions.implement(this);
		// stages.VSliceLoader.implement(this);
		// WindowFunctions.implement(this);

		for (name => func in customFunctions)
		{
			if(func != null)
				Lua_helper.add_callback(lua, name, func);
		}

		try{
			var isString:Bool = !FileSystem.exists(scriptName);
			var result:Dynamic = null;
			if(!isString)
				result = LuaL.dofile(lua, scriptName);
			else
				result = LuaL.dostring(lua, scriptName);

			var resultStr:String = Lua.tostring(lua, result);
			if(resultStr != null && result != 0) {
				trace(resultStr);
				#if windows
				lime.app.Application.current.window.alert(resultStr, 'Error on lua script!');
				#else
				luaTrace('$scriptName\n$resultStr', true, false, FlxColor.RED);
				#end
				lua = null;
				return;
			}
			if(isString) scriptName = 'unknown';
		} catch(e:Dynamic) {
			trace(e);
			return;
		}
		trace('lua file loaded succesfully:' + scriptName);

		call('onCreate', []);
	}

	//main
	public var lastCalledFunction:String = '';
	public static var lastCalledScript:FunkinLua = null;
	public function call(func:String, args:Array<Dynamic>):Dynamic {
		if(closed) return LuaUtils.Function_Continue;

		lastCalledFunction = func;
		lastCalledScript = this;
		try {
			if(lua == null) return LuaUtils.Function_Continue;

			Lua.getglobal(lua, func);
			var type:Int = Lua.type(lua, -1);

			if (type != Lua.LUA_TFUNCTION) {
				if (type > Lua.LUA_TNIL)
					luaTrace("ERROR (" + func + "): attempt to call a " + LuaUtils.typeToString(type) + " value", false, false, FlxColor.RED);

				Lua.pop(lua, 1);
				return LuaUtils.Function_Continue;
			}

			for (arg in args) Convert.toLua(lua, arg);
			var status:Int = Lua.pcall(lua, args.length, 1, 0);

			// Checks if it's not successful, then show a error.
			if (status != Lua.LUA_OK) {
				var error:String = getErrorMessage(status);
				luaTrace("ERROR (" + func + "): " + error, false, false, FlxColor.RED);
				return LuaUtils.Function_Continue;
			}

			// If successful, pass and then return the result.
			var result:Dynamic = cast Convert.fromLua(lua, -1);
			if (result == null) result = LuaUtils.Function_Continue;

			Lua.pop(lua, 1);
			if(closed) stop();
			return result;
		}
		catch (e:Dynamic) {
			trace(e);
		}
		return LuaUtils.Function_Continue;
	}

	public function set(variable:String, data:Dynamic) {
		if(lua == null) {
			return;
		}

		Convert.toLua(lua, data);
		Lua.setglobal(lua, variable);
	}

	public function stop() {
		closed = true;

		if(lua == null) {
			return;
		}
		Lua.close(lua);
		lua = null;
		#if HSCRIPT_ALLOWED
		if(hscript != null)
		{
			hscript.destroy();
			hscript = null;
		}
		#end
	}

	function oldTweenFunction(tag:String, vars:String, tweenValue:Any, duration:Float, ease:String, funcName:String)
	{
		var target:Dynamic = LuaUtils.tweenPrepare(tag, vars);
		var variables = MusicBeatState.getVariables();
		if(target != null)
		{
			if(tag != null)
			{
				var originalTag:String = tag;
				tag = LuaUtils.formatVariable('tween_$tag');
				variables.set(tag, FlxTween.tween(target, tweenValue, duration, {ease: LuaUtils.getTweenEaseByString(ease),
					onComplete: function(twn:FlxTween)
					{
						variables.remove(tag);
						if(PlayState.instance != null) PlayState.instance.callOnLuas('onTweenCompleted', [originalTag, vars]);
					}
				}));
			}
			else FlxTween.tween(target, tweenValue, duration, {ease: LuaUtils.getTweenEaseByString(ease)});
			return tag;
		}
		else luaTrace('$funcName: Couldnt find object: $vars', false, false, FlxColor.RED);
		return null;
	}

	function noteTweenFunction(tag:String, note:Int, data:Dynamic, duration:Float, ease:String)
	{
		var strumLineNotes:FlxTypedGroup<StrumNote> = null;
		if (PlayState.instance != null)
			strumLineNotes = PlayState.instance.strumLineNotes;
		else
		{
			var chart:states.editors.ChartingState = states.editors.ChartingState.instance;
			if (chart != null && Std.isOfType(FlxG.state, states.editors.ChartingState))
				strumLineNotes = chart.strumLineNotes;
		}
		if(strumLineNotes == null || strumLineNotes.length == 0) return null;

		var strumNote:StrumNote = strumLineNotes.members[note % strumLineNotes.length];
		if(strumNote == null) return null;

		if(tag != null)
		{
			var originalTag:String = tag;
			tag = LuaUtils.formatVariable('tween_$tag');
			LuaUtils.cancelTween(tag);

			var variables = MusicBeatState.getVariables();
			variables.set(tag, FlxTween.tween(strumNote, data, duration, {ease: LuaUtils.getTweenEaseByString(ease),
				onComplete: function(twn:FlxTween)
				{
					variables.remove(tag);
					if(PlayState.instance != null) PlayState.instance.callOnLuas('onTweenCompleted', [originalTag]);
					else if (states.editors.ChartingState.instance != null)
						states.editors.ChartingState.instance.callOnLuas('onTweenCompleted', [originalTag]);
				}
			}));
			return tag;
		}
		else FlxTween.tween(strumNote, data, duration, {ease: LuaUtils.getTweenEaseByString(ease)});
		return null;
	}

	public static function luaTrace(text:String, ignoreCheck:Bool = false, deprecated:Bool = false, color:FlxColor = FlxColor.WHITE) {
		if(ignoreCheck || getBool('luaDebugMode')) {
			if(deprecated && !getBool('luaDeprecatedWarnings')) {
				return;
			}
			PlayState.instance.addTextToDebug(text, color);
		}
	}

	public static function getBool(variable:String) {
		if(lastCalledScript == null) return false;

		var lua:State = lastCalledScript.lua;
		if(lua == null) return false;

		var result:String = null;
		Lua.getglobal(lua, variable);
		result = Convert.fromLua(lua, -1);
		Lua.pop(lua, 1);

		if(result == null) {
			return false;
		}
		return (result == 'true');
	}

	function findScript(scriptFile:String, ext:String = '.lua')
	{
		if(!scriptFile.endsWith(ext)) scriptFile += ext;
		var path:String = Paths.getPath(scriptFile, TEXT);
		#if MODS_ALLOWED
		if(FileSystem.exists(path))
		#else
		if(Assets.exists(path, TEXT))
		#end
		{
			return path;
		}
		#if MODS_ALLOWED
		else if(FileSystem.exists(scriptFile))
		#else
		else if(Assets.exists(scriptFile, TEXT))
		#end
		{
			return scriptFile;
		}
		return null;
	}

	public function getErrorMessage(status:Int):String {
		var v:String = Lua.tostring(lua, -1);
		Lua.pop(lua, 1);

		if (v != null) v = v.trim();
		if (v == null || v == "") {
			switch(status) {
				case Lua.LUA_ERRRUN: return "Runtime Error";
				case Lua.LUA_ERRMEM: return "Memory Allocation Error";
				case Lua.LUA_ERRERR: return "Critical Error";
			}
			return "Unknown Error";
		}

		return v;
		return null;
	}

	public function addLocalCallback(name:String, myFunction:Dynamic)
	{
		callbacks.set(name, myFunction);
		Lua_helper.add_callback(lua, name, null); //just so that it gets called
	}

	#if (!flash && sys)
	public var runtimeShaders:Map<String, Array<String>> = new Map<String, Array<String>>();
	#end

	public function initLuaShader(name:String)
	{
		if(!ClientPrefs.data.shaders) return false;

		#if (!flash && sys)
		if(runtimeShaders.exists(name))
		{
			var shaderData:Array<String> = runtimeShaders.get(name);
			if(shaderData != null && (shaderData[0] != null || shaderData[1] != null))
			{
				luaTrace('Shader $name was already initialized!');
				return true;
			}
		}

		var foldersToCheck:Array<String> = [Paths.getSharedPath('shaders/')];
		#if MODS_ALLOWED
		foldersToCheck.push(Paths.mods('shaders/'));
		if(Mods.currentModDirectory != null && Mods.currentModDirectory.length > 0)
			foldersToCheck.insert(0, Paths.mods(Mods.currentModDirectory + '/shaders/'));

		for(mod in Mods.getGlobalMods())
			foldersToCheck.insert(0, Paths.mods(mod + '/shaders/'));
		#end

		for (folder in foldersToCheck)
		{
			if(FileSystem.exists(folder))
			{
				var frag:String = folder + name + '.frag';
				var vert:String = folder + name + '.vert';
				var found:Bool = false;
				if(FileSystem.exists(frag))
				{
					frag = File.getContent(frag);
					found = true;
				}
				else frag = null;

				if(FileSystem.exists(vert))
				{
					vert = File.getContent(vert);
					found = true;
				}
				else vert = null;

				if(found)
				{
					runtimeShaders.set(name, [frag, vert]);
					//trace('Found shader $name!');
					return true;
				}
			}
		}
		luaTrace('Missing shader $name .frag AND .vert files!', false, false, FlxColor.RED);
		#else
		luaTrace('This platform doesn\'t support Runtime Shaders!', false, false, FlxColor.RED);
		#end
		return false;
	}
}
#end