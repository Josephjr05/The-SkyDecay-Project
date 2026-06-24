package backend;

import haxe.Json;
import lime.utils.Assets;

import objects.Note;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import moonchart.formats.BasicFormat.BasicNoteType;
import moonchart.formats.OsuMania;
import moonchart.formats.StepMania;
import moonchart.formats.StepManiaShark;
import moonchart.formats.fnf.legacy.FNFLegacy;

//a full change of organization to match Osu's map files
typedef SwagSong =
{
	var song:String;
	var songArtists:String;
	var artists:String;
	var charters:String;
	var vfx:String;
	var scripters:String;

	var player1:String;
	var player2:String;
	var gfVersion:String;
	var stage:String;
	var format:String;
	var needsVoices:Bool;

	@:optional var overallDifficulty:Float; // Added OD
    @:optional var hpDrainRate:Float; // Added HP
	var speed:Float;
	var bpm:Float;
	var offset:Float;

	@:optional var gameOverChar:String;
	@:optional var gameOverSound:String;
	@:optional var gameOverLoop:String;
	@:optional var gameOverEnd:String;
	
	@:optional var disableNoteRGB:Bool;

	@:optional var arrowSkin:String;
	@:optional var splashSkin:String;

	var events:Array<Dynamic>;

	var notes:Array<SwagSection>;
}

typedef SwagSection =
{
	var sectionNotes:Array<Dynamic>;
	var sectionBeats:Float;
	var mustHitSection:Bool;
	@:optional var altAnim:Bool;
	@:optional var gfSection:Bool;
	@:optional var bpm:Float;
	@:optional var changeBPM:Bool;
	@:optional var lengthInSteps:Int;
}

#if sys
private class MoonchartFNFAdapter extends FNFLegacy
{
	public function new()
	{
		super();

		indexedTypes = false;
		bakedOffset = false;
		offsetHolds = false;

		noteTypeResolver.register('Hurt Note', BasicNoteType.MINE);
	}
}
#end

class Song
{
	public var song:String;
	public var songArtists:String;
	public var artists:String;
	public var charters:String;
	public var vfx:String;
	public var scripters:String;
	public var player1:String = 'bf';
	public var player2:String = 'bf-opponent';
	public var gfVersion:String = 'gf';
	public var stage:String;
	public var format:String = 'skydecay_beta';
	public var needsVoices:Bool = true;
	public var speed:Float = 2.8;
	public var bpm:Float;
	public var overallDifficulty:Float; // Added OD
    public var hpDrainRate:Float; // Added HP
	public var arrowSkin:String;
	public var splashSkin:String;
	public var gameOverChar:String;
	public var gameOverSound:String;
	public var gameOverLoop:String;
	public var gameOverEnd:String;
	public var disableNoteRGB:Bool = false;
	public var events:Array<Dynamic>;
	public var notes:Array<SwagSection>;
	#if sys
	static final MOONCHART_EXTENSIONS:Array<String> = ['sm', 'ssc', 'osu'];
	#end

	public static function convert(songJson:Dynamic) // Convert old charts to skydecay_beta (0.1) format
	{
		if(songJson.gfVersion == null)
		{
			songJson.gfVersion = songJson.player3;
			if(Reflect.hasField(songJson, 'player3')) Reflect.deleteField(songJson, 'player3');
		}

		if(songJson.events == null)
		{
			songJson.events = [];
			for (secNum in 0...songJson.notes.length)
			{
				var sec:SwagSection = songJson.notes[secNum];

				var i:Int = 0;
				var notes:Array<Dynamic> = sec.sectionNotes;
				var len:Int = notes.length;
				while(i < len)
				{
					var note:Array<Dynamic> = notes[i];
					if(note[1] < 0)
					{
						songJson.events.push([note[0], [[note[2], note[3], note[4]]]]);
						notes.remove(note);
						len = notes.length;
					}
					else i++;
				}
			}
		}

		var sectionsData:Array<SwagSection> = songJson.notes;
		if(sectionsData == null) return;

		for (section in sectionsData)
		{
			var beats:Null<Float> = cast section.sectionBeats;
			if (beats == null || Math.isNaN(beats))
			{
				section.sectionBeats = 4;
				if(Reflect.hasField(section, 'lengthInSteps')) Reflect.deleteField(section, 'lengthInSteps'); // for converting charts, it still keeps lengthInSteps so it'll get deleted if you save the chart again
			}

			for (note in section.sectionNotes)
			{
				var gottaHitNote:Bool = (note[1] < 4) ? section.mustHitSection : !section.mustHitSection;
				note[1] = (note[1] % 4) + (gottaHitNote ? 0 : 4);

				if(!Std.isOfType(note[3], String))
					note[3] = Note.defaultNoteTypes[note[3]]; //compatibility with Week 7 and 0.1-0.3 psych charts
			}
		}
	}

	public static var chartPath:String;
	public static var loadedSongName:String;
	public static function loadFromJson(jsonInput:String, ?folder:String):SwagSong
	{
		if(folder == null) folder = jsonInput;
		PlayState.SONG = getChart(jsonInput, folder);
		loadedSongName = folder;
		chartPath = _lastPath;
		#if windows
		// prevent any saving errors by fixing the path on Windows (being the only OS to ever use backslashes instead of forward slashes for paths)
		chartPath = chartPath.replace('/', '\\');
		#end
		StageData.loadDirectory(PlayState.SONG);
		return PlayState.SONG;
	}

	static var _lastPath:String;
	public static function getChart(jsonInput:String, ?folder:String):SwagSong
	{
		if(folder == null) folder = jsonInput;
		var rawData:String = null;
		var song:SwagSong = null;
		
		var formattedFolder:String = Paths.formatToSongPath(folder);
		var formattedSong:String = Paths.formatToSongPath(jsonInput);
		_lastPath = Paths.json('$formattedFolder/$formattedSong');

		#if MODS_ALLOWED
		try {
			if(FileSystem.exists(_lastPath))
				rawData = File.getContent(_lastPath);
		} catch(e:Dynamic) {
			trace('Error checking/reading mod chart file: $e');
		}
		#end
		
		if(rawData == null)
		{
			try
			{
				rawData = Assets.getText(_lastPath);
			}
			catch(e:Dynamic)
				rawData = null;
		}

		if(rawData != null)
		{
			song = parseJSON(rawData, jsonInput);
		}
		else
		{
			var moonPath:String = findMoonchartChart(formattedFolder, formattedSong);
			if(moonPath != null)
			{
				_lastPath = moonPath;
				song = loadMoonchartChart(moonPath, jsonInput);
			}
		}

		return song;
	}

	public static function parseJSON(rawData:String, ?nameForError:String = null, ?convertTo:String = 'psych_v1'):SwagSong
	{
		var songJson:SwagSong = cast Json.parse(rawData);
		if(Reflect.hasField(songJson, 'song'))
		{
			var subSong:SwagSong = Reflect.field(songJson, 'song');
			if(subSong != null && Type.typeof(subSong) == TObject)
				songJson = subSong;
		}

		return finalizeSong(songJson, nameForError, convertTo);
	}

	static function finalizeSong(songJson:SwagSong, ?nameForError:String = null, ?convertTo:String = 'psych_v1'):SwagSong
	{
		if(songJson == null) return null;

		if(songJson.events == null) songJson.events = [];
		if(songJson.notes == null) songJson.notes = [];

		if(convertTo != null && convertTo.length > 0)
		{
			var fmt:String = songJson.format;
			if(fmt == null) fmt = songJson.format = 'unknown';

			switch(convertTo)
			{
				case 'psych_v1':
					if(!fmt.startsWith('psych_v1'))
					{
						trace('converting chart $nameForError with format $fmt to skydecay_beta format...');
						songJson.format = 'psych_v1_convert';
						convert(songJson);
					}
			}
		}
		return songJson;
	}

	/**
	 * Merges embedded chart events and external events.json rows; drops rows that
	 * share the same time and event payload (duplicate in both sources).
	 */
	public static function mergeUniqueChartEvents(embedded:Null<Array<Dynamic>>, external:Null<Array<Dynamic>>):Array<Dynamic>
	{
		var out:Array<Dynamic> = [];
		var seen:Map<String, Bool> = new Map();

		function pushUnique(ev:Dynamic):Void
		{
			if (ev == null || ev[1] == null) return;
			var key:String = '${Math.round(ev[0] * 1000)}:' + Json.stringify(ev[1]);
			if (seen.exists(key)) return;
			seen.set(key, true);
			out.push(ev);
		}

		if (embedded != null)
			for (e in embedded)
				pushUnique(e);
		if (external != null)
			for (e in external)
				pushUnique(e);
		return out;
	}

	static function findMoonchartChart(formattedFolder:String, formattedSong:String):String
	{
		var names:Array<String> = [formattedSong];
		var dashIndex:Int = formattedSong.lastIndexOf('-');
		if(dashIndex > -1 && dashIndex < formattedSong.length - 1)
		{
			names.push(formattedSong.substr(dashIndex + 1));
		}

		for(name in names)
		{
			for(ext in MOONCHART_EXTENSIONS)
			{
				var relative:String = 'songs/$formattedFolder/$name.$ext';

				try {
					var modPath:String = Paths.mods(relative);
					if(modPath != null && modPath.length > 0 && FileSystem.exists(modPath)) return modPath;
				} catch(e:Dynamic) {
					trace('Error checking mod moonchart path: $e');
				}

				try {
					var preloadPath:String = Paths.getSharedPath(relative);
					if(preloadPath != null && preloadPath.length > 0 && FileSystem.exists(preloadPath)) return preloadPath;
				} catch(e:Dynamic) {
					trace('Error checking preload moonchart path: $e');
				}
			}
		}
		return null;
	}

	static function loadMoonchartChart(path:String, difficulty:String):SwagSong
	{
		var extension:String = Path.extension(path).toLowerCase();
		var adapter:MoonchartFNFAdapter = new MoonchartFNFAdapter();

		var source:Dynamic = switch(extension)
		{
			case 'sm': new StepMania().fromFile(path);
			case 'ssc': new StepManiaShark().fromFile(path);
			case 'osu': new OsuMania().fromFile(path);
			default: null;
		};

		if(source == null) return null;

		var result = adapter.fromFormat(source);
		if(result == null || result.data == null || result.data.song == null) return null;

		var swag:SwagSong = cast result.data.song;
		if(swag.format == null) swag.format = 'moonchart_$extension';

		return finalizeSong(swag, difficulty);
	}
}