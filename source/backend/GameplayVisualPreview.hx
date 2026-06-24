package backend;

import backend.Song;
import backend.Song.SwagSong;
import backend.Song.SwagSection;
import backend.StageData.StageFile;

import StringTools;

import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import objects.Character;
import objects.Note.EventNote;

import states.PlayState;
import states.editors.ChartingState;
import states.editors.content.MetaNote;
import states.stages.*;
import states.stages.objects.*;

import psychlua.LuaUtils;

class GameplayVisualPreview
{
	public static var visualOnly:Bool = false;

	var host:ChartingState;
	var altAnim:String = '';
	var lastVisualEventTime:Float = -1;
	var processedEvents:Map<String, Bool> = new Map();
	var isSeeking:Bool = false;
	var scrubReplayPending:Float = -1;
	var scrubReplayTimer:Float = 0;
	static inline var SCRUB_REPLAY_DELAY:Float = 0.35;

	var previewEvents:Array<EventNote> = [];
	var previewEventIndex:Int = 0;

	var snapPlayer1:String = '';
	var snapPlayer2:String = '';
	var snapGf:String = '';
	var snapStage:String = 'stage';

	public function new(chart:ChartingState)
	{
		host = chart;
	}

	public function build(song:SwagSong)
	{
		if (song == null || host == null)
			return;

		destroy(false);
		StageData.addedObjects.clear();

		visualOnly = true;
		PlayState.chartingMode = true;

		StageData.loadDirectory(song);
		captureSongSnapshot(song);
		host.curStage = song.stage != null && song.stage.length > 0 ? song.stage : 'stage';
		PlayState.curStage = host.curStage;
		host.stageData = StageData.getStageFile(host.curStage);
		setStageDetails(host, host.stageData);

		host.boyfriendGroup = new FlxSpriteGroup(host.BF_X, host.BF_Y);
		host.dadGroup = new FlxSpriteGroup(host.DAD_X, host.DAD_Y);
		host.gfGroup = new FlxSpriteGroup(host.GF_X, host.GF_Y);

		if (!host.stageData.hide_girlfriend)
		{
			if (song.gfVersion == null || song.gfVersion.length < 1)
				song.gfVersion = 'gf';
			host.gf = new Character(0, 0, song.gfVersion, host.stageData.has_reflections);
			startCharacterPos(host, host.gf);
			host.gfGroup.scrollFactor.set(0.95, 0.95);
			host.gfGroup.add(host.gf);
		}

		host.dad = new Character(0, 0, song.player2, host.stageData.has_reflections);
		startCharacterPos(host, host.dad, true);
		host.dadGroup.add(host.dad);

		host.boyfriend = new Character(0, 0, song.player1, host.stageData.has_reflections, true);
		startCharacterPos(host, host.boyfriend);
		host.boyfriendGroup.add(host.boyfriend);

		if (host.dad != null && host.dad.curCharacter.startsWith('gf'))
		{
			host.dad.setPosition(host.GF_X, host.GF_Y);
			if (host.gf != null)
				host.gf.visible = false;
		}

		host.previewGroup.cameras = [host.camGame];

		addStageClasses(host, true);
		addObjects(host, host.stageData);

		host.previewGroup.add(host.gfGroup);
		host.previewGroup.add(host.dadGroup);
		host.previewGroup.add(host.boyfriendGroup);

		setupCamera(host);

		host.stagesFunc(function(stage:BaseStage) stage.createPost());
		ScriptRunner.startVisualScripts(host, song);
		try
		{
			ScriptRunner.callOnScripts(host, 'onCreatePost');
			#if LUA_ALLOWED
			for (script in host.luaArray)
			{
				if (script != null && !script.closed)
					script.onCreatePost();
			}
			#end
		}
		catch (e:Dynamic)
		{
			trace('GameplayVisualPreview: onCreatePost failed: $e');
		}

		moveCameraSection(host, host.curSec);
		resetVisualEventState();
		rebuildPreviewEvents(host.getEditorEvents());
		scrubReplayPending = -1;
		scrubReplayTimer = 0;
	}

	public function destroy(?fullTeardown:Bool = true)
	{
		if (host == null)
			return;

		var oldStage:String = host.curStage;
		var oldStageData:StageFile = host.stageData;
		ScriptRunner.stopVisualScripts(host, oldStage);

		for (stage in host.stages.copy())
		{
			if (stage != null)
				stage.destroy();
		}
		host.stages = [];

		if (oldStageData != null)
			removeObjects(host, oldStageData);

		if (host.camFollow != null)
		{
			host.remove(host.camFollow);
			host.camFollow.destroy();
			host.camFollow = null;
		}

		clearPreviewGroup(host);

		host.boyfriend = null;
		host.dad = null;
		host.gf = null;
		host.boyfriendGroup = null;
		host.dadGroup = null;
		host.gfGroup = null;

		if (fullTeardown)
		{
			visualOnly = false;
			PlayState.chartingMode = false;
		}
	}

	static function clearPreviewGroup(host:ChartingState)
	{
		var members:Array<FlxBasic> = host.previewGroup.members.copy();
		for (member in members)
		{
			host.previewGroup.remove(member);
			if (member != null && member.exists)
				member.destroy();
		}
	}

	public function reloadStage(song:SwagSong)
	{
		if (song == null || host == null)
			return;

		try
		{
			build(song);
		}
		catch (e:Dynamic)
		{
			trace('GameplayVisualPreview.reloadStage failed for stage "${song.stage}": $e');
		}
	}

	public function reloadCharacters(song:SwagSong)
	{
		if (song == null || host == null)
			return;

		var gfName:String = song.gfVersion;
		var dadName:String = song.player2;
		var bfName:String = song.player1;

		#if LUA_ALLOWED
		if (host.gf != null)
			ScriptRunner.stopLuasNamed(host, 'characters/${host.gf.curCharacter}.lua');
		if (host.dad != null)
			ScriptRunner.stopLuasNamed(host, 'characters/${host.dad.curCharacter}.lua');
		if (host.boyfriend != null)
			ScriptRunner.stopLuasNamed(host, 'characters/${host.boyfriend.curCharacter}.lua');
		#end

		if (!host.stageData.hide_girlfriend)
		{
			if (gfName == null || gfName.length < 1)
				gfName = 'gf';
			replaceCharacter(host, true, false, gfName);
		}
		replaceCharacter(host, false, true, dadName);
		replaceCharacter(host, false, false, bfName);

		if (host.dad != null && host.dad.curCharacter.startsWith('gf'))
		{
			host.dad.setPosition(host.GF_X, host.GF_Y);
			if (host.gf != null)
				host.gf.visible = false;
		}

		ScriptRunner.startCharacterScripts(host, gfName);
		ScriptRunner.startCharacterScripts(host, dadName);
		ScriptRunner.startCharacterScripts(host, bfName);
		if (!isSeeking && !host.isCameraOnForcedPos)
			moveCameraSection(host, host.curSec);
	}

	function captureSongSnapshot(song:SwagSong)
	{
		if (song == null)
			return;
		snapPlayer1 = song.player1 != null ? song.player1 : 'bf';
		snapPlayer2 = song.player2 != null ? song.player2 : 'dad';
		snapGf = song.gfVersion != null ? song.gfVersion : 'gf';
		snapStage = song.stage != null && song.stage.length > 0 ? song.stage : 'stage';
	}

	function restoreSongSnapshot(?song:SwagSong)
	{
		if (song == null)
			song = PlayState.SONG;
		if (song == null)
			return;
		song.player1 = snapPlayer1;
		song.player2 = snapPlayer2;
		song.gfVersion = snapGf;
		song.stage = snapStage;
	}

	public static function syncSectionScriptVars(host:ChartingState, ?sec:Null<Int> = null)
	{
		if (sec == null)
			sec = host.curSec;
		if (PlayState.SONG == null || PlayState.SONG.notes[sec] == null)
			return;

		var secData:SwagSection = PlayState.SONG.notes[sec];
		if (secData.changeBPM)
		{
			Conductor.bpm = secData.bpm;
			ScriptRunner.setOnScripts(host, 'curBpm', Conductor.bpm);
			ScriptRunner.setOnScripts(host, 'crochet', Conductor.crochet);
			ScriptRunner.setOnScripts(host, 'stepCrochet', Conductor.stepCrochet);
		}
		ScriptRunner.setOnScripts(host, 'mustHitSection', secData.mustHitSection == true);
		ScriptRunner.setOnScripts(host, 'altAnim', secData.altAnim == true);
		ScriptRunner.setOnScripts(host, 'gfSection', secData.gfSection == true);
		ScriptRunner.setOnScripts(host, 'curSection', sec);
	}

	public function scheduleScrubReplay(time:Float)
	{
		scrubReplayPending = time;
		scrubReplayTimer = SCRUB_REPLAY_DELAY;
	}

	public function cancelScrubReplay()
	{
		scrubReplayPending = -1;
		scrubReplayTimer = 0;
	}

	public function updatePreview(elapsed:Float, editorEvents:Array<MetaNote>)
	{
		if (scrubReplayPending < 0 || isSeeking || host == null)
			return;

		scrubReplayTimer -= elapsed;
		if (scrubReplayTimer <= 0)
		{
			var time:Float = scrubReplayPending;
			scrubReplayPending = -1;
			replayTimelineTo(time, editorEvents);
		}
	}

	/** Re-sync scripted visuals after a scrub without reloading every Lua file. */
	public function replayTimelineTo(time:Float, editorEvents:Array<MetaNote>)
	{
		if (host == null || isSeeking || PlayState.SONG == null || host.boyfriend == null)
			return;

		isSeeking = true;
		try
		{
			host.isCameraOnForcedPos = false;

			if (host.camFollow != null)
				FlxTween.cancelTweensOf(host.camFollow);
			if (host.camGame != null)
				FlxTween.cancelTweensOf(host.camGame);

			restoreSongSnapshot();
			var song:SwagSong = PlayState.SONG;
			if (host.curStage != song.stage)
				reloadStage(song);
			else
				reloadCharacters(song);

			rebuildPreviewEvents(editorEvents);
			resetPreviewEventsToTime(time);

			var targetSec:Int = getSectionAtTime(host, time);
			for (sec in 0...targetSec + 1)
			{
				host.curSec = sec;
				syncSectionScriptVars(host, sec);
				ScriptRunner.callOnScripts(host, 'onSectionHit');
			}

			var targetStep:Int = Std.int(Conductor.getStep(time));
			for (step in 0...targetStep + 1)
			{
				ScriptRunner.setOnScripts(host, 'curStep', step);
				ScriptRunner.callOnScripts(host, 'onStepHit');
				ScriptRunner.callOnScripts(host, 'onUpdate', [0]);
			}

			host.curSec = targetSec;
			syncSectionScriptVars(host, targetSec);
			ScriptRunner.setOnScripts(host, 'curBeat', Std.int(Conductor.getBeat(time)));
			ScriptRunner.setOnScripts(host, 'curStep', targetStep);
			ScriptRunner.setOnScripts(host, 'curDecBeat', Conductor.getBeat(time));
			ScriptRunner.setOnScripts(host, 'curDecStep', Conductor.getStep(time));

			lastVisualEventTime = time;
		}
		catch (e:Dynamic)
		{
			trace('GameplayVisualPreview.replayTimelineTo failed: $e');
		}
		isSeeking = false;
	}

	function collectSortedEvents(editorEvents:Array<MetaNote>):Array<MetaNote>
	{
		var sortedEvents:Array<MetaNote> = [];
		for (event in editorEvents)
			if (event != null && event.isEvent)
				sortedEvents.push(event);
		sortedEvents.sort(function(a:MetaNote, b:MetaNote) return a.strumTime < b.strumTime ? -1 : 1);
		return sortedEvents;
	}

	static function getSectionAtTime(host:ChartingState, time:Float):Int
	{
		if (host.cachedSectionTimes == null || host.cachedSectionTimes.length < 1)
			return 0;

		var sec:Int = 0;
		for (i in 0...host.cachedSectionTimes.length)
			if (time >= host.cachedSectionTimes[i] - 0.001)
				sec = i;
		return sec;
	}

	function clearScriptedDisplayObjects()
	{
		var vars = MusicBeatState.getVariables();
		for (key in vars.keys())
		{
			var obj:Dynamic = vars.get(key);
			if (obj != null && (obj is FlxBasic))
			{
				var basic:FlxBasic = cast obj;
				if (basic.exists)
					basic.destroy();
				vars.remove(key);
			}
		}
	}

	public function onBeat()
	{
		if (host == null)
			return;

		var sec:SwagSection = getSection(host, host.curSec);
		altAnim = (sec != null && sec.altAnim) ? '-alt' : '';

		if (host.gf != null && host.gf.animation.curAnim != null)
		{
			if (host.dad == null || !host.dad.curCharacter.startsWith('gf'))
				host.gf.dance();
		}

		danceChar(host.boyfriend);
		if (host.dad != null && !host.dad.curCharacter.startsWith('gf'))
			danceChar(host.dad);

		ScriptRunner.setOnScripts(host, 'curBeat', Std.int(Conductor.getBeat(Conductor.songPosition)));
		ScriptRunner.setOnScripts(host, 'curStep', Std.int(Conductor.getStep(Conductor.songPosition)));
		ScriptRunner.callOnScripts(host, 'onBeatHit');
	}

	public function rebuildPreviewEvents(editorEvents:Array<MetaNote>)
	{
		previewEvents = [];
		for (meta in editorEvents)
			pushPreviewEventsFromMeta(meta);

		// PlayState also loads events.json separately — mirror that for preview even when autoLoadEvents is off.
		if (PlayState.EVENTS != null && PlayState.EVENTS.events != null)
		{
			var seen:Map<String, Bool> = new Map();
			for (ev in previewEvents)
				seen.set(previewEventKey(ev), true);

			for (raw in PlayState.EVENTS.events)
				pushPreviewEventsFromRaw(raw, seen);
		}

		previewEvents.sort(PlayState.sortByTime);
		previewEventIndex = 0;
	}

	function previewEventKey(ev:EventNote):String
		return '${Math.round(ev.strumTime * 1000)}_${ev.event}_${ev.value1}_${ev.value2}_${ev.value3}';

	function pushPreviewEventsFromRaw(raw:Array<Dynamic>, ?seen:Map<String, Bool> = null)
	{
		if (raw == null || raw[1] == null)
			return;

		var eventList:Array<Dynamic> = raw[1];
		for (i in 0...eventList.length)
		{
			var parts:Array<Dynamic> = eventList[i];
			if (parts == null || parts.length < 1)
				continue;

			var note:EventNote = {
				strumTime: raw[0] + ClientPrefs.data.noteOffset,
				event: Std.string(parts[0]),
				value1: parts.length > 1 && parts[1] != null ? Std.string(parts[1]) : '',
				value2: parts.length > 2 && parts[2] != null ? Std.string(parts[2]) : '',
				value3: parts.length > 3 && parts[3] != null ? Std.string(parts[3]) : ''
			};
			note.strumTime -= host.eventEarlyTrigger(note);

			if (seen != null)
			{
				var key:String = previewEventKey(note);
				if (seen.exists(key))
					continue;
				seen.set(key, true);
			}
			previewEvents.push(note);
		}
	}

	function pushPreviewEventsFromMeta(meta:MetaNote)
	{
		if (meta == null || !meta.isEvent || meta.songData == null)
			return;

		var eventList:Array<Dynamic> = meta.songData[1];
		if (eventList == null)
			return;

		for (i in 0...eventList.length)
		{
			var parts:Array<Dynamic> = eventList[i];
			if (parts == null || parts.length < 1)
				continue;

			var note:EventNote = {
				strumTime: meta.strumTime + ClientPrefs.data.noteOffset,
				event: Std.string(parts[0]),
				value1: parts.length > 1 && parts[1] != null ? Std.string(parts[1]) : '',
				value2: parts.length > 2 && parts[2] != null ? Std.string(parts[2]) : '',
				value3: parts.length > 3 && parts[3] != null ? Std.string(parts[3]) : ''
			};
			note.strumTime -= host.eventEarlyTrigger(note);
			previewEvents.push(note);
		}
	}

	public function checkPreviewEvents()
	{
		if (host == null || isSeeking)
			return;
		while (previewEventIndex < previewEvents.length)
		{
			var ev:EventNote = previewEvents[previewEventIndex];
			if (Conductor.songPosition + 0.001 < ev.strumTime)
				break;
			VisualEventRunner.triggerChartEvent(host, ev.event, ev.value1, ev.value2, ev.value3, ev.strumTime);
			previewEventIndex++;
		}
	}

	public function resetPreviewEventsToTime(time:Float)
	{
		previewEventIndex = 0;
		while (previewEventIndex < previewEvents.length && previewEvents[previewEventIndex].strumTime <= time + 0.001)
		{
			var ev:EventNote = previewEvents[previewEventIndex];
			VisualEventRunner.triggerChartEvent(host, ev.event, ev.value1, ev.value2, ev.value3, ev.strumTime);
			previewEventIndex++;
		}
	}

	public function updateVisualEvents(songPosition:Float, lastTime:Float, editorEvents:Array<MetaNote>, ?songPlaying:Bool = false)
	{
		if (host == null || editorEvents == null || isSeeking)
			return;

		if (previewEvents.length == 0)
			rebuildPreviewEvents(editorEvents);

		var jump:Float = Math.abs(songPosition - lastTime);
		if (!songPlaying && jump > Conductor.stepCrochet * 4)
			scheduleScrubReplay(songPosition);

		if (songPosition < lastTime - Conductor.stepCrochet * 0.5)
		{
			resetPreviewEventsToTime(songPosition);
			lastVisualEventTime = songPosition;
			return;
		}

		lastVisualEventTime = songPosition;
		checkPreviewEvents();
	}

	public function resetVisualEventState()
	{
		processedEvents = new Map();
		lastVisualEventTime = Conductor.songPosition;
	}

	function applyVisualEvent(event:MetaNote)
	{
		var data:Array<Dynamic> = event.songData;
		if (data == null || data.length < 2 || data[1] == null)
			return;

		var eventList:Array<Dynamic> = data[1];
		for (i in 0...eventList.length)
		{
			var eventParts:Array<Dynamic> = eventList[i];
			if (eventParts == null || eventParts.length < 1)
				continue;
			var eventName:String = Std.string(eventParts[0]);
			var value1:String = eventParts.length > 1 ? Std.string(eventParts[1]) : '';
			var value2:String = eventParts.length > 2 ? Std.string(eventParts[2]) : '';
			var value3:String = eventParts.length > 3 ? Std.string(eventParts[3]) : '';
			VisualEventRunner.triggerChartEvent(host, eventName, value1, value2, value3, event.strumTime);
		}
	}

	function changeCharacterEvent(target:String, newCharacter:String)
	{
		if (newCharacter == null || newCharacter.length < 1 || PlayState.SONG == null)
			return;

		switch (target.toLowerCase())
		{
			case 'gf' | 'girlfriend':
				PlayState.SONG.gfVersion = newCharacter;
			case 'dad' | 'opponent':
				PlayState.SONG.player2 = newCharacter;
			default:
				PlayState.SONG.player1 = newCharacter;
		}
		reloadCharacters(PlayState.SONG);
	}

	public function runCharacterChangeEvent(target:String, newCharacter:String)
		changeCharacterEvent(target, newCharacter);

	public static function setStageDetails(host:ChartingState, stageData:StageFile):StageFile
	{
		host.defaultCamZoom = stageData.defaultZoom;

		if (stageData.camera_speed != null)
			host.cameraSpeed = stageData.camera_speed;

		var dir:String = stageData.directory;
		if (dir != null)
			Paths.setCurrentLevel(dir);

		host.BF_X = stageData.boyfriend[0];
		host.BF_Y = stageData.boyfriend[1];
		host.GF_X = stageData.girlfriend[0];
		host.GF_Y = stageData.girlfriend[1];
		host.DAD_X = stageData.opponent[0];
		host.DAD_Y = stageData.opponent[1];

		host.boyfriendCameraOffset = stageData.camera_boyfriend;
		if (host.boyfriendCameraOffset == null)
			host.boyfriendCameraOffset = [0, 0];

		host.opponentCameraOffset = stageData.camera_opponent;
		if (host.opponentCameraOffset == null)
			host.opponentCameraOffset = [0, 0];

		host.girlfriendCameraOffset = stageData.camera_girlfriend;
		if (host.girlfriendCameraOffset == null)
			host.girlfriendCameraOffset = [0, 0];

		return stageData;
	}

	public static function startCharacterPos(host:ChartingState, char:Character, ?gfCheck:Bool = false)
	{
		if (gfCheck && char.curCharacter.startsWith('gf'))
		{
			char.setPosition(host.GF_X, host.GF_Y);
			char.scrollFactor.set(0.95, 0.95);
			char.danceEveryNumBeats = 2;
		}
		char.x += char.positionArray[0];
		char.y += char.positionArray[1];
	}

	public static function addStageClasses(host:ChartingState, isCreate:Bool)
	{
		switch (host.curStage.toLowerCase())
		{
			case 'stage': new Stage();
			case 'red': new RedAmong();
			case 'traped': new Traped();
			case 'philly': new Philly();
			case 'limo': new Limo();
			case 'camellia': new Studio();
			case 'crystallized': new Crystallized();
			case 'concert': new CamelliaConcert();
			case 'cyphisonia': new Cyphisonia();
			case 'planet': new Planet();
			case 'limuCastle': new LimuCastle();
			case 'cornMaze': new CornMaze();
			case 'phillyStreets': new PhillyStreets();
			case 'mangoPark': new MangoPark();
			case 'shipEntrance': new ShipEntrance();
			case 'desktop': new Desktop();
		}

		addObjects(host, host.stageData);

		host.boyfriendGroup.x = host.BF_X;
		host.boyfriendGroup.y = host.BF_Y;
		host.dadGroup.x = host.DAD_X;
		host.dadGroup.y = host.DAD_Y;
		if (!host.stageData.hide_girlfriend)
		{
			host.gfGroup.x = host.GF_X;
			host.gfGroup.y = host.GF_Y;
		}
	}

	public static function addObjects(host:ChartingState, stageData:StageFile)
	{
		if (stageData.objects != null && stageData.objects.length > 0)
		{
			var list:Map<String, FlxSprite> = StageData.addObjectsToState(
				stageData.objects,
				!stageData.hide_girlfriend ? host.gf : null,
				host.dad,
				host.boyfriend,
				host.previewGroup
			);
			for (key => spr in list)
				if (!StageData.reservedNames.contains(key))
					host.variables.set(key, spr);
		}
	}

	public static function removeObjects(host:ChartingState, stageData:StageFile)
	{
		if (stageData == null)
			return;

		if (stageData.objects != null && stageData.objects.length > 0)
		{
			var list:Map<String, FlxSprite> = StageData.removeObjectsFromState(
				stageData.objects,
				!stageData.hide_girlfriend ? host.gf : null,
				host.dad,
				host.boyfriend,
				host.previewGroup
			);
			for (key => spr in list)
			{
				if (!StageData.reservedNames.contains(key))
					host.variables.remove(key);
			}
		}
	}

	public static function updateCamera(host:ChartingState, elapsed:Float):Void
	{
		if (host.boyfriend == null || host.camGame == null)
			return;

		if (!host.inCutscene && !host.paused && !host.freezeCamera)
			host.camGame.followLerp = 0.04 * host.cameraSpeed * host.playbackRate;
		else
			host.camGame.followLerp = 0;

		if (host.camZooming)
		{
			host.camGame.zoom = FlxMath.lerp(host.defaultCamZoom, host.camGame.zoom, Math.exp(-elapsed * 3.125 * host.camZoomingDecay * host.playbackRate));
			if (ClientPrefs.data.camHUDOption && host.camHUD != null)
				host.camHUD.zoom = FlxMath.lerp(1, host.camHUD.zoom, Math.exp(-elapsed * 3.125 * host.camZoomingDecay * host.playbackRate));
		}
	}

	public static function setupCamera(host:ChartingState)
	{
		var camPos:FlxPoint = FlxPoint.get(host.girlfriendCameraOffset[0], host.girlfriendCameraOffset[1]);
		if (host.gf != null)
		{
			camPos.x += host.gf.getGraphicMidpoint().x + host.gf.cameraPosition[0];
			camPos.y += host.gf.getGraphicMidpoint().y + host.gf.cameraPosition[1];
		}
		else if (host.dad != null)
		{
			camPos.x = host.dad.getMidpoint().x + 150 + host.dad.cameraPosition[0] + host.opponentCameraOffset[0];
			camPos.y = host.dad.getMidpoint().y - 100 + host.dad.cameraPosition[1] + host.opponentCameraOffset[1];
		}

		host.camFollow = new FlxObject(camPos.x, camPos.y, 1, 1);
		camPos.put();
		host.camFollow.cameras = [host.camGame];
		host.add(host.camFollow);

		host.camGame.follow(host.camFollow, LOCKON, 0);
		host.camGame.zoom = host.defaultCamZoom;
	}

	public static function moveCameraSection(host:ChartingState, ?sec:Null<Int>):Void
	{
		if (sec == null)
			sec = host.curSec;
		if (sec < 0 || PlayState.SONG == null || PlayState.SONG.notes[sec] == null)
			return;

		if (host.gf != null && PlayState.SONG.notes[sec].gfSection)
		{
			moveCameraToGirlfriend(host);
			ScriptRunner.callOnScripts(host, 'onMoveCamera', ['gf']);
			return;
		}

		var isDad:Bool = PlayState.SONG.notes[sec].mustHitSection != true;
		moveCamera(host, isDad);
		ScriptRunner.callOnScripts(host, 'onMoveCamera', [isDad ? 'dad' : 'boyfriend']);
	}

	public static function moveCameraToGirlfriend(host:ChartingState)
	{
		if (host.gf == null || host.camFollow == null)
			return;

		host.camFollow.setPosition(host.gf.getMidpoint().x, host.gf.getMidpoint().y);
		host.camFollow.x += host.gf.cameraPosition[0] + host.girlfriendCameraOffset[0];
		host.camFollow.y += host.gf.cameraPosition[1] + host.girlfriendCameraOffset[1];
	}

	public static function moveCamera(host:ChartingState, isDad:Bool)
	{
		if (host.camFollow == null)
			return;

		var data:StageFile = host.stageData;
		if (isDad)
		{
			if (host.dad == null)
				return;

			var xAxis:Float = data.fixedCam_x != null ? data.fixedCam_x : (host.dad.getMidpoint().x + 150);
			var yAxis:Float = data.fixedCam_y != null ? data.fixedCam_y : (host.dad.getMidpoint().y - 100);
			host.camFollow.setPosition(xAxis, yAxis);

			if (data.fixedCam_x == null)
			{
				host.camFollow.x += host.dad.cameraPosition[0] + host.opponentCameraOffset[0];
				host.camFollow.y += host.dad.cameraPosition[1] + host.opponentCameraOffset[1];
			}
		}
		else
		{
			if (host.boyfriend == null)
				return;

			var xAxis:Float = data.fixedCam_x != null ? data.fixedCam_x : (host.boyfriend.getMidpoint().x - 100);
			var yAxis:Float = data.fixedCam_y != null ? data.fixedCam_y : (host.boyfriend.getMidpoint().y - 100);
			host.camFollow.setPosition(xAxis, yAxis);

			if (data.fixedCam_x == null)
			{
				host.camFollow.x -= host.boyfriend.cameraPosition[0] - host.boyfriendCameraOffset[0];
				host.camFollow.y += host.boyfriend.cameraPosition[1] + host.boyfriendCameraOffset[1];
			}
		}
	}

	static function replaceCharacter(host:ChartingState, isGf:Bool, isDad:Bool, name:String)
	{
		if (name == null || name.length < 1)
			return;

		if (isGf)
		{
			if (host.gf != null)
			{
				host.gfGroup.remove(host.gf);
				host.gf.destroy();
			}
			host.gf = new Character(0, 0, name, host.stageData.has_reflections);
			startCharacterPos(host, host.gf);
			host.gfGroup.add(host.gf);
		}
		else if (isDad)
		{
			if (host.dad != null)
			{
				host.dadGroup.remove(host.dad);
				host.dad.destroy();
			}
			host.dad = new Character(0, 0, name, host.stageData.has_reflections);
			startCharacterPos(host, host.dad, true);
			host.dadGroup.add(host.dad);
		}
		else
		{
			if (host.boyfriend != null)
			{
				host.boyfriendGroup.remove(host.boyfriend);
				host.boyfriend.destroy();
			}
			host.boyfriend = new Character(0, 0, name, host.stageData.has_reflections, true);
			startCharacterPos(host, host.boyfriend);
			host.boyfriendGroup.add(host.boyfriend);
		}
	}

	static function danceChar(char:Character)
	{
		if (char == null || char.animation.curAnim == null)
			return;
		if (!char.animation.curAnim.name.startsWith('sing'))
			char.dance();
	}

	static function getSection(host:ChartingState, sec:Int):Null<SwagSection>
	{
		if (PlayState.SONG == null || sec < 0 || sec >= PlayState.SONG.notes.length)
			return null;
		return PlayState.SONG.notes[sec];
	}
}
