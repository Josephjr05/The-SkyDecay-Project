package backend;

#if LUA_ALLOWED
import psychlua.FunkinLua;
import psychlua.LuaUtils;
#end
#if HSCRIPT_ALLOWED
import psychlua.HScript;
import crowplexus.iris.Iris;
import crowplexus.hscript.Expr.Error as IrisError;
import crowplexus.hscript.Printer;
import psychlua.HScript.HScriptInfos;
#end

import states.editors.ChartingState;

import backend.Song.SwagSong;

import openfl.utils.Assets;
import openfl.utils.Assets as OpenFlAssets;
#if MODS_ALLOWED
import sys.FileSystem;
#end

class ScriptRunner
{
	public static function getChartHost():Null<ChartingState>
	{
		if (ChartingState.instance != null && Std.isOfType(FlxG.state, ChartingState))
			return ChartingState.instance;
		return null;
	}

	inline static function shouldLoadChartPreviewScript(fileName:String):Bool
	{
		var lower:String = fileName.toLowerCase();
		// Credits/end-card scripts aren't gameplay visuals and often crash in editor preview.
		return lower != 'credits.lua';
	}

	#if LUA_ALLOWED
	public static function startLuasNamed(host:ChartingState, luaFile:String):Bool
	{
		#if MODS_ALLOWED
		var luaToLoad:String = Paths.modFolders(luaFile);
		if (!FileSystem.exists(luaToLoad))
			luaToLoad = Paths.getSharedPath(luaFile);

		if (FileSystem.exists(luaToLoad))
		#elseif sys
		var luaToLoad:String = Paths.getSharedPath(luaFile);
		if (OpenFlAssets.exists(luaToLoad))
		#end
		{
			for (script in host.luaArray)
				if (script.scriptName == luaToLoad)
					return false;

			new FunkinLua(luaToLoad);
			host.updateScriptFlags();
			return true;
		}
		return false;
	}

	public static function stopLuasNamed(host:ChartingState, luaFile:String):Bool
	{
		#if MODS_ALLOWED
		var luaToLoad:String = Paths.modFolders(luaFile);
		if (!FileSystem.exists(luaToLoad))
			luaToLoad = Paths.getSharedPath(luaFile);

		if (FileSystem.exists(luaToLoad))
		#elseif sys
		var luaToLoad:String = Paths.getSharedPath(luaFile);
		if (OpenFlAssets.exists(luaToLoad))
		#end
		{
			for (script in host.luaArray)
			{
				if (script.scriptName == luaToLoad)
				{
					script.call("onDestroy", []);
					host.luaArray.remove(script);
					host.updateScriptFlags();
					return true;
				}
			}
		}
		return false;
	}
	#end

	#if HSCRIPT_ALLOWED
	public static function startHScriptsNamed(host:ChartingState, scriptFile:String):Bool
	{
		#if MODS_ALLOWED
		var scriptToLoad:String = Paths.modFolders(scriptFile);
		if (!FileSystem.exists(scriptToLoad))
			scriptToLoad = Paths.getSharedPath(scriptFile);
		#else
		var scriptToLoad:String = Paths.getSharedPath(scriptFile);
		#end

		if (FileSystem.exists(scriptToLoad))
		{
			if (Iris.instances.exists(scriptToLoad))
				return false;

			initHScript(host, scriptToLoad);
			return true;
		}
		return false;
	}

	public static function stopHScriptsNamed(host:ChartingState, scriptFile:String):Bool
	{
		#if MODS_ALLOWED
		var scriptToLoad:String = Paths.modFolders(scriptFile);
		if (!FileSystem.exists(scriptToLoad))
			scriptToLoad = Paths.getSharedPath(scriptFile);
		#else
		var scriptToLoad:String = Paths.getSharedPath(scriptFile);
		#end

		if (FileSystem.exists(scriptToLoad))
		{
			var script:HScript = cast Iris.instances.get(scriptToLoad);
			if (script != null)
			{
				script.destroy();
				host.hscriptArray.remove(script);
				host.updateScriptFlags();
				return true;
			}
		}
		return false;
	}

	public static function initHScript(host:ChartingState, file:String)
	{
		try
		{
			var script:HScript = new HScript(null, file);
			if (script.exists('onCreate'))
				script.call('onCreate');
			if (script.exists('onLoad'))
				script.call('onLoad');
			host.hscriptArray.push(script);
		}
		catch (e:IrisError)
		{
			var pos:HScriptInfos = cast {fileName: file, showLine: false};
			Iris.error(Printer.errorToString(e, false), pos);
			var badScript:HScript = cast Iris.instances.get(file);
			if (badScript != null)
				badScript.destroy();
		}
		host.updateScriptFlags();
	}
	#end

	public static function startCharacterScripts(host:ChartingState, name:String)
	{
		#if LUA_ALLOWED
		var doPush:Bool = false;
		var luaFile:String = 'characters/$name.lua';
		#if MODS_ALLOWED
		var replacePath:String = Paths.modFolders(luaFile);
		if (FileSystem.exists(replacePath))
		{
			luaFile = replacePath;
			doPush = true;
		}
		else
		{
			luaFile = Paths.getSharedPath(luaFile);
			if (FileSystem.exists(luaFile))
				doPush = true;
		}
		#else
		luaFile = Paths.getSharedPath(luaFile);
		if (Assets.exists(luaFile))
			doPush = true;
		#end

		if (doPush)
		{
			for (script in host.luaArray)
			{
				if (script.scriptName == luaFile)
				{
					doPush = false;
					break;
				}
			}
			if (doPush)
				new FunkinLua(luaFile);
		}
		#end

		#if HSCRIPT_ALLOWED
		var doPushHx:Bool = false;
		var scriptFile:String = 'characters/' + name + '.hx';
		#if MODS_ALLOWED
		var replacePathHx:String = Paths.modFolders(scriptFile);
		if (FileSystem.exists(replacePathHx))
		{
			scriptFile = replacePathHx;
			doPushHx = true;
		}
		else
		{
			scriptFile = Paths.getSharedPath(scriptFile);
			if (FileSystem.exists(scriptFile))
				doPushHx = true;
		}
		#else
		scriptFile = Paths.getSharedPath(scriptFile);
		if (FileSystem.exists(scriptFile))
			doPushHx = true;
		#end

		if (doPushHx)
			initHScript(host, scriptFile);
		#end

		host.updateScriptFlags();
	}

	public static function startVisualScripts(host:ChartingState, song:SwagSong)
	{
		if (song == null)
			return;

		#if (LUA_ALLOWED || HSCRIPT_ALLOWED)
		var stageName:String = song.stage != null ? song.stage : 'stage';
		#if LUA_ALLOWED
		startLuasNamed(host, 'stages/$stageName.lua');
		#end
		#if HSCRIPT_ALLOWED
		startHScriptsNamed(host, 'stages/$stageName.hx');
		#end

		if (song.gfVersion != null && song.gfVersion.length > 0)
			startCharacterScripts(host, song.gfVersion);
		if (song.player2 != null && song.player2.length > 0)
			startCharacterScripts(host, song.player2);
		if (song.player1 != null && song.player1.length > 0)
			startCharacterScripts(host, song.player1);

		var songName:String = Paths.formatToSongPath(song.song);
		#if ((LUA_ALLOWED || HSCRIPT_ALLOWED) && MODS_ALLOWED)
		for (folder in Mods.directoriesWithFile(Paths.getSharedPath(), 'songs/$songName/'))
		{
			for (file in FileSystem.readDirectory(folder))
			{
				#if LUA_ALLOWED
				if (file.toLowerCase().endsWith('.lua') && shouldLoadChartPreviewScript(file))
					startLuasNamed(host, 'songs/$songName/$file');
				#end
				#if HSCRIPT_ALLOWED
				for (ext in Paths.HSCRIPT_EXTENSIONS)
					if (file.toLowerCase().endsWith('.$ext'))
						initHScript(host, folder + file);
				#end
			}
		}
		#end

		loadCustomEventScripts(host, song);
		host.updateScriptFlags();
		#end
	}

	public static function loadCustomEventScripts(host:ChartingState, song:SwagSong)
	{
		#if !LUA_ALLOWED
		return;
		#end
		var names:Array<String> = host != null ? host.getUniqueEventNames() : [];
		if (names.length < 1 && song != null && song.events != null)
		{
			for (ev in song.events)
			{
				if (ev == null || ev[1] == null)
					continue;
				var eventName:String = Std.string(ev[1][0]);
				if (eventName.length > 0 && !names.contains(eventName))
					names.push(eventName);
			}
		}
		for (name in names)
			startLuasNamed(host, 'custom_events/$name.lua');
	}

	public static function stopVisualScripts(host:ChartingState, ?stageName:String)
	{
		#if LUA_ALLOWED
		if (stageName != null && stageName.length > 0)
			stopLuasNamed(host, 'stages/$stageName.lua');

		for (script in host.luaArray.copy())
		{
			if (script == null)
				continue;
			script.call("onDestroy", []);
			host.luaArray.remove(script);
		}
		#end

		#if HSCRIPT_ALLOWED
		if (stageName != null && stageName.length > 0)
			stopHScriptsNamed(host, 'stages/$stageName.hx');

		for (script in host.hscriptArray.copy())
		{
			if (script != null)
				script.destroy();
		}
		host.hscriptArray = [];
		#end

		host.updateScriptFlags();
	}

	public static function callOnScripts(host:ChartingState, funcToCall:String, ?args:Array<Dynamic>, ?ignoreStops:Bool = false):Dynamic
	{
		if (!host.hasLuaScripts && !host.hasHScripts)
			return LuaUtils.Function_Continue;

		if (args == null)
			args = [];

		#if LUA_ALLOWED
		var result:Dynamic = callOnLuas(host, funcToCall, args, ignoreStops);
		#if HSCRIPT_ALLOWED
		if (result == null || result == LuaUtils.Function_Continue)
			result = callOnHScript(host, funcToCall, args, ignoreStops);
		#end
		return result;
		#elseif HSCRIPT_ALLOWED
		return callOnHScript(host, funcToCall, args, ignoreStops);
		#else
		return LuaUtils.Function_Continue;
		#end
	}

	#if LUA_ALLOWED
	public static function callOnLuas(host:ChartingState, funcToCall:String, args:Array<Dynamic>, ignoreStops:Bool):Dynamic
	{
		var returnVal:Dynamic = LuaUtils.Function_Continue;
		var excludeValues:Array<Dynamic> = [LuaUtils.Function_Continue];
		var arr:Array<FunkinLua> = [];

		for (script in host.luaArray)
		{
			if (script.closed)
			{
				arr.push(script);
				continue;
			}

			var myValue:Dynamic = script.call(funcToCall, args);
			if ((myValue == LuaUtils.Function_StopLua || myValue == LuaUtils.Function_StopAll) && !excludeValues.contains(myValue) && !ignoreStops)
			{
				returnVal = myValue;
				break;
			}

			if (myValue != null && !excludeValues.contains(myValue))
				returnVal = myValue;

			if (script.closed)
				arr.push(script);
		}

		if (arr.length > 0)
			for (script in arr)
				host.luaArray.remove(script);

		return returnVal;
	}
	#end

	#if HSCRIPT_ALLOWED
	public static function callOnHScript(host:ChartingState, funcToCall:String, args:Array<Dynamic>, ignoreStops:Bool):Dynamic
	{
		var returnVal:Dynamic = LuaUtils.Function_Continue;
		var excludeValues:Array<Dynamic> = [LuaUtils.Function_Continue];

		if (host.hscriptArray.length < 1)
			return returnVal;

		for (script in host.hscriptArray)
		{
			@:privateAccess
			if (script == null || !script.exists(funcToCall))
				continue;

			var callValue = script.call(funcToCall, args);
			if (callValue != null)
			{
				var myValue:Dynamic = callValue.returnValue;
				if ((myValue == LuaUtils.Function_StopHScript || myValue == LuaUtils.Function_StopAll) && !excludeValues.contains(myValue) && !ignoreStops)
				{
					returnVal = myValue;
					break;
				}

				if (myValue != null && !excludeValues.contains(myValue))
					returnVal = myValue;
			}
		}
		return returnVal;
	}
	#end

	public static function setOnScripts(host:ChartingState, variable:String, arg:Dynamic)
	{
		#if LUA_ALLOWED
		for (script in host.luaArray)
			script.set(variable, arg);
		#end
		#if HSCRIPT_ALLOWED
		for (script in host.hscriptArray)
			script.set(variable, arg);
		#end
	}
}
