package states.freeplay;

import backend.Highscore;
import backend.Song;
import backend.WeekData;
import flixel.input.keyboard.FlxKey;
import haxe.Json;
import lime.utils.Assets;
import metadata.STMetaFile.MetadataFile;
import objects.Character;
import objects.HealthIcon;
import openfl.utils.Assets as OpenFlAssets;
import options.GameplayChangersSubstate;
import states.editors.ChartingState;
import states.freeplay.osu.DifficultySelectorSubState;
import states.freeplay.osu.SongBox;
import substates.ResetScoreSubState;
import sys.FileSystem;
import sys.io.File;

class OsuFreeplayState extends MusicBeatState
{
	public static var instance:OsuFreeplayState;
	
	var back:FlxSprite;
	var backHitbox:FlxSprite;
	var fakeLogo:FlxSprite;

	var searchTypeText:FlxText;
	var searchTypeTextHitbox:FlxSprite;
	var albumPhoto:FlxSprite;

	var isTyping:Bool = false;

	var allowedKeys:String = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789';

	var background:FlxSprite;

	private var songBox:FlxTypedGroup<SongBox>;
	private var iconGrp:FlxTypedGroup<HealthIcon>;
	private var textGrp:FlxTypedGroup<FlxText>;

	private static var curSelected:Int = 0;
	private static var maxSelected:Int = 0;

	var inSub:Bool = false;

	var staleBg:FlxSprite;

	var visual:AudioDisplay;
	var vocalvisual:AudioDisplay = null;
	var oppvisual:AudioDisplay = null;

	// Replaces fpManager: local song list constructed from WeekData
	var songs:Array<SongMetadata> = [];
	public static var metadata:MetadataFile = null;


	override function create()
	{
		#if windows
		backend.window.CppAPI.resetAffixes();
		backend.window.CppAPI.resetTitle();
		#end

		instance = this;

		Highscore.reloadModifiers();
		Paths.clearStoredWithoutStickers();

		Cursor.cursorMode = Default;

		persistentUpdate = true;
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

		FlxG.mouse.visible = true;

		// Build songs list from weeks (similar to FreeplayState)
		populateSongsFromWeeks();

		//if (ClientPrefs.data.allowVis) {
			if (FlxG.sound.music != null && FlxG.sound.music.playing) {
				visual = new AudioDisplay(FlxG.sound.music, 0, FlxG.height, FlxG.width, Std.int(FlxG.height / 2), 100, 4, FlxColor.WHITE);
				visual.scrollFactor.set(0, 0);
				add(visual);
				visual.alpha = ClientPrefs.data.visOpacity;

				vocalvisual = new AudioDisplay(FlxG.sound.music, 0, 0, FlxG.width, Std.int(FlxG.height / 2), 100, 4, FlxColor.WHITE);
				vocalvisual.scrollFactor.set(0, 0);
				vocalvisual.flipY = true;
				add(vocalvisual);
				vocalvisual.alpha = ClientPrefs.data.visOpacity;

				oppvisual = new AudioDisplay(FlxG.sound.music, 0, 0, FlxG.width, Std.int(FlxG.height / 2), 100, 4, FlxColor.WHITE);
				oppvisual.scrollFactor.set(0, 0);
				oppvisual.flipY = true;
				add(oppvisual);
				oppvisual.alpha = ClientPrefs.data.visOpacity;
			}
		//}

		switchVisualizer();

		staleBg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xff646464);
		add(staleBg);

		songBox = new FlxTypedGroup<SongBox>();
		add(songBox);

		textGrp = new FlxTypedGroup<FlxText>();
		add(textGrp);

		iconGrp = new FlxTypedGroup<HealthIcon>();
		add(iconGrp);

		// if no weeks, show error
		if(WeekData.weeksList.length < 1)
		{
			FlxTransitionableState.skipNextTransIn = true;
			persistentUpdate = false;
			MusicBeatState.switchState(new states.ErrorState("NO WEEKS ADDED FOR FREEPLAY\n\nPress ACCEPT to go to the Week Editor Menu.\nPress BACK to return to Main Menu.",
				function() MusicBeatState.switchState(new states.editors.WeekEditorState()),
				function() MusicBeatState.switchState(new states.MainMenuState())));
			return;
		}

		var topBar:FlxSprite = new FlxSprite(0, -87).loadGraphic(Paths.image('freeplay/OSUState/barTop'));
		topBar.setGraphicSize(1280, 152);
		topBar.screenCenter(X);
		add(topBar);

		var botBar:FlxSprite = new FlxSprite(0, 537).loadGraphic(Paths.image('freeplay/OSUState/barbot'));
		botBar.setGraphicSize(1280, 119);
		botBar.screenCenter(X);
		add(botBar);

		var logo:FlxSprite = new FlxSprite(0, 460).loadGraphic(Paths.image('logobutsmaller'));
		logo.setGraphicSize(200, 100);
		logo.screenCenter(X);
		add(logo);

		fakeLogo = new FlxSprite(0, 460).loadGraphic(Paths.image('logobutsmaller'));
		fakeLogo.setGraphicSize(200, 100);
		fakeLogo.screenCenter(X);
		fakeLogo.alpha = 0;
		add(fakeLogo);

		var black:FlxSprite = new FlxSprite(0, 670).makeGraphic(70, 40, 0xff000000);
		add(black);

		back = new FlxSprite(-350, 565).loadGraphic(Paths.image('freeplay/OSUState/back'));
		back.setGraphicSize(300, 89);
		add(back);

		backHitbox = new FlxSprite(30, 670).makeGraphic(100, 29, 0xffffffff);
		backHitbox.alpha = 0.0001;
		add(backHitbox);

		var yelSearch:FlxSprite = new FlxSprite(450, 45).loadGraphic(Paths.image('freeplay/OSUState/search'));
		yelSearch.setGraphicSize(70, 16);
		add(yelSearch);

		searchTypeText = new FlxText(550, 48, FlxG.width * 10, 'Type Here To Search!', 20);
		searchTypeText.font = Paths.font('vcr.ttf');
		add(searchTypeText);

		searchTypeTextHitbox = new FlxSprite(550, 51).makeGraphic(290, 18, 0xffffffff);
		searchTypeTextHitbox.alpha = 0.0001;
		add(searchTypeTextHitbox);

		albumPhoto = new FlxSprite(130, 0).loadGraphic(Paths.image('albums/NoCover'));
		albumPhoto.setGraphicSize(Std.int(albumPhoto.width * 1.6));
		albumPhoto.screenCenter(Y);
		albumPhoto.y += 20;
		add(albumPhoto);

		WeekData.setDirectoryFromWeek();

		// Populate UI lists from songs array
		loadSongArray(true);

		// if no songs (edge-case) -> early exit
		if (songs.length == 0) {
			FlxTransitionableState.skipNextTransIn = true;
			persistentUpdate = false;
			MusicBeatState.switchState(new states.ErrorState("NO SONGS FOUND FOR FREEPLAY\n\nPress ACCEPT to go to the Week Editor Menu.\nPress BACK to return to Main Menu.",
				function() MusicBeatState.switchState(new states.editors.WeekEditorState()),
				function() MusicBeatState.switchState(new states.MainMenuState())));
			return;
		}

		super.create();

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the OSU! Freeplay", null);
		#end

		Mods.loadTopMod();
	}

	function switchVisualizer(?hasVocals:Bool = false, ?vocalSND:FlxSound = null, ?oppSND:FlxSound = null) {
		// if (ClientPrefs.data.allowVis) {
			if (FlxG.sound.music != null && FlxG.sound.music.playing) {
				if (visual != null) remove(visual);
				visual = new AudioDisplay(FlxG.sound.music, 0, FlxG.height, FlxG.width, Std.int(FlxG.height / 2), 100, 4, FlxColor.WHITE);
				visual.scrollFactor.set(0, 0);
				add(visual);
				visual.alpha = 0.7;

				if (hasVocals) {
					if (vocalSND != null) {
						if (vocalvisual != null) remove(vocalvisual);
						var color:Array<Int> = Character.grabCharInfo(PlayState.SONG.player1).get("Health Colors");
						vocalvisual = new AudioDisplay(vocalSND, 0, 0, FlxG.width, Std.int(FlxG.height / 2), 100, 4, color != null ? FlxColor.fromRGB(color[0], color[1], color[2]) : FlxColor.WHITE);
						vocalvisual.scrollFactor.set(0, 0);
						vocalvisual.flipY = true;
						add(vocalvisual);
						vocalvisual.alpha = 0.7;
					}

					if (oppSND != null) {
						if (oppvisual != null) remove(oppvisual);
						var color:Array<Int> = Character.grabCharInfo(PlayState.SONG.player2).get("Health Colors");
						oppvisual = new AudioDisplay(oppSND, 0, 0, FlxG.width, Std.int(FlxG.height / 2), 100, 4, FlxColor.fromRGB(color[0], color[1], color[2]));
						oppvisual.scrollFactor.set(0, 0);
						oppvisual.flipY = true;
						add(oppvisual);
						oppvisual.alpha = 0.7;
					}
				} else {
					if (vocalvisual != null) remove(vocalvisual);
					if (oppvisual != null) remove(oppvisual);
				}
			}
		//}
	}

	var holdTime:Float = 0;
	var victoryColor:FlxColor;
	var e:Int = 0;
	override public function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume = Math.min(FlxG.sound.music.volume + 0.5 * elapsed, 0.8);

		if(WeekData.weeksList.length < 1)
		{
			FlxTransitionableState.skipNextTransIn = true;
			persistentUpdate = false;
			MusicBeatState.switchState(new states.ErrorState("NO WEEKS ADDED FOR FREEPLAY\n\nPress ACCEPT to go to the Week Editor Menu.\nPress BACK to return to Main Menu.",
				function() MusicBeatState.switchState(new states.editors.WeekEditorState()),
				function() MusicBeatState.switchState(new states.MainMenuState())));
			return;
		}

		e++;
		FlxG.watch.addQuick('Search Text', searchTypeText.text);
		for(item in songBox)
		{
			var coolEffect:Int = 0;

			if(item.ID < curSelected)
				coolEffect = ((item.ID - curSelected) * 30);
			else if (item.ID > curSelected)
				coolEffect = -((item.ID - curSelected) * 30);

			item.x = FlxMath.lerp(item.ID == curSelected? 280 : 320 - coolEffect, item.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		}

		persistentUpdate = true;
		PlayState.isStoryMode = false;

		for(icon in iconGrp)
		{
			var theY:Float = 0;
			var theX:Float = 0;
			for(item in songBox)
				if(item.ID == icon.ID) {
					theY = item.y;
					theX = item.x;
				}

			icon.y = theY + 25;
			icon.x = theX + 360;
		}

		for(text in textGrp)
		{
			var theY:Float = 0;
			var theX:Float = 0;
			for(item in songBox)
				if(item.ID == text.ID) {
					theY = item.y;
					theX = item.x;
				}

			text.y = theY + 70;
			text.x = theX + 480;
		}

		if(!isTyping && !inSub)
		{
			var shiftMult:Int = 1;
			if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

			if(FlxG.mouse.overlaps(backHitbox))
				back.setColorTransform(-1, -1, -1, 1, 246, 190, 0);
			if(!FlxG.mouse.overlaps(backHitbox))
				back.setColorTransform(1, 1, 1, 1, 1, 1, 1, 0);

			if(controls.BACK || FlxG.mouse.overlaps(backHitbox) && FlxG.mouse.justPressed)
				MusicBeatState.switchState(new CategoryState());

			if(FlxG.mouse.overlaps(searchTypeTextHitbox))
			{
				if(FlxG.mouse.justPressed)
				{
					isTyping = true;

					if(searchTypeText.text == 'Type Here To Search!')
						searchTypeText.text = '';
				}
			}

			if(FlxG.mouse.wheel != 0)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
				changeSong(-shiftMult * FlxG.mouse.wheel, false);
			}

			if (controls.UI_UP_P)
			{
				changeSong(-shiftMult);
				holdTime = 0;
			}
			if (controls.UI_DOWN_P)
			{
				changeSong(shiftMult);
				holdTime = 0;
			}

			if(controls.UI_UP || controls.UI_DOWN) {
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

				if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					changeSong((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
			}
			else if(FlxG.keys.justPressed.HOME)
			{
				curSelected = 0;
				holdTime = 0;
				changeSong();
			}
			else if(FlxG.keys.justPressed.END)
			{
				curSelected = maxSelected - 1;
				holdTime = 0;
				changeSong();
			}
			else if(FlxG.keys.justPressed.PAGEUP || FlxG.keys.justPressed.PAGEDOWN)
				changeSong(FlxG.keys.justPressed.PAGEUP? -6 : 6);

			if(controls.ACCEPT)
			{
				inSub = true;
				persistentUpdate = false;
				openSubState(new DifficultySelectorSubState(songs[curSelected]));
			}

			if(FlxG.keys.justPressed.TAB || FlxG.keys.justPressed.CONTROL) //adding control for consistancy sake
			{
				inSub = true;
				persistentUpdate = false;
				openSubState(new GameplayChangersSubstate());
			}
		}

		if(isTyping)
		{
			if(!FlxG.mouse.overlaps(searchTypeTextHitbox) && FlxG.mouse.justPressed)
			{
				isTyping = false;
				if(searchTypeText.text == '')
					searchTypeText.text = 'Type Here To Search!';
			}

			if (FlxG.keys.firstJustPressed() != FlxKey.NONE)
			{
				var keyPressed:FlxKey = FlxG.keys.firstJustPressed();
				var keyName:String = Std.string(keyPressed);
				if(allowedKeys.contains(keyName)) {
					if(FlxG.keys.pressed.SHIFT)
						searchTypeText.text += keyName.toUpperCase();
					else
						searchTypeText.text += keyName.toLowerCase();
				}
			}

			if(FlxG.keys.pressed.BACKSPACE)
				searchTypeText.text = searchTypeText.text.substring(0, searchTypeText.text.length - 1);
			if(FlxG.keys.justPressed.SPACE)
				searchTypeText.text += ' ';
			if(FlxG.keys.justPressed.ENTER)
			{
				isTyping = false;
				if(searchTypeText.text == '') {
					searchTypeText.text = 'Type Here To Search!';
					loadSongArray(true);
					trace("Regular Refresh");
				}
				else
					loadSongArray(false, true, searchTypeText.text);
			}
		}

		super.update(elapsed);
	}

	override function closeSubState() {
		inSub = false;
		persistentUpdate = true;
		if (FreeplayState.doChange)
		{
			changeSong(0, false);
			FreeplayState.doChange = false;
			Highscore.reloadModifiers();
		}
		super.closeSubState();
	}

	function logoTween()
	{
		fakeLogo.alpha = 1;

		FlxTween.tween(fakeLogo, {alpha: 0}, 0.6);
		FlxTween.tween(fakeLogo.scale, {x: 0.33, y: 0.33}, 0.6);
	}

	// changeSong now uses songs[]
	function changeSong(change:Int = 0, playSound:Bool = true)
	{
		curSelected += change;

		if(curSelected > maxSelected - 1)
			curSelected = 0;
		if(curSelected < 0)
			curSelected = maxSelected - 1;

		var i:Int = 0;
		for(item in songBox)
			item.posY = i++ - curSelected;

		if (songs[curSelected] != null)
		{
			WeekData.setDirectoryFromWeek();
			Mods.currentModDirectory = songs[curSelected].folder;
			PlayState.storyWeek = songs[curSelected].week;
			try {
				switch (songs[curSelected].songName)
				{
					case 'Small Argument' | 'Beat Battle 2':
						Difficulty.list = ['Hard'];
					case "Beat Battle":
						Difficulty.list = ["Normal", "Reasonable", "Unreasonable", "Semi-Impossible", "Impossible"];
					default:
						Difficulty.loadFromWeek();
				}
			} catch(e:Dynamic) {}
			// metadata handling: currently defaulting to null if not available
			try {metadata = null;} catch(e) {metadata = null;}

			if (metadata != null && metadata.freeplay != null) {
				if (metadata.freeplay.bg != null && metadata.freeplay.bg != '') {
					staleBg.loadGraphic(Paths.image(metadata.freeplay.bg));
					staleBg.screenCenter();
				} else {
					staleBg.makeGraphic(FlxG.width, FlxG.height, 0xff646464);
					staleBg.screenCenter();
				}

				if (albumPhoto != null) {
					if (metadata.freeplay.album != null && metadata.freeplay.album != '') {
						albumPhoto.loadGraphic(Paths.image('albums/${Std.string(metadata.freeplay.album)}'));
						albumPhoto.setGraphicSize(Std.int(albumPhoto.width * 1.6));
						albumPhoto.screenCenter(Y);
						albumPhoto.x = 130;
						albumPhoto.y += 20;
					} else {
						albumPhoto.loadGraphic(Paths.image('albums/NoCover'));
						albumPhoto.setGraphicSize(Std.int(albumPhoto.width * 1.6));
						albumPhoto.screenCenter(Y);
						albumPhoto.x = 130;
						albumPhoto.y += 20;
					}
				}
			} else { // Return to default
				staleBg.makeGraphic(FlxG.width, FlxG.height, 0xff646464);
				staleBg.screenCenter();

				if (albumPhoto != null) {
					albumPhoto.loadGraphic(Paths.image('albums/NoCover'));
					albumPhoto.setGraphicSize(Std.int(albumPhoto.width * 1.6));
					albumPhoto.screenCenter(Y);
					albumPhoto.x = 130;
					albumPhoto.y += 20;
				}
			}
		}
		if(playSound)
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
	}

	public static var vocals:FlxSound = null;

	public static function destroyFreeplayVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}

	override function destroy() {
		super.destroy();
		FlxG.mouse.visible = false;
		instance = null;
	}

	function loadDiffs(song:Dynamic) {
		var week:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[songs[curSelected].week]);
		Difficulty.loadFromWeek(week);

		var diffInt:Int = 0;
		for (j in 0...Difficulty.list.length)
		{
			var songBox:SongBox = new SongBox(320, 100);
			songBox.loadGraphic(Paths.image('freeplay/OSUState/bars/background2'));
			songBox.setGraphicSize(650, 50);
			songBox.setColorTransform(-1, -1, -1, 1, songs[curSelected].colorR, songs[curSelected].colorG, songs[curSelected].colorB, 1);
			songBox.ID = song.ID + diffInt;
			this.songBox.add(songBox);

			var text:FlxText = new FlxText(0, 0, 500, '', 20);
			text.text = Difficulty.list[j];
			text.alignment = 'left';
			text.ID = song.ID + diffInt;
			this.textGrp.add(text);
		}
	}

	// loadSongArray and reloadSongArray now use songs[]
	function loadSongArray(reset:Bool, searching:Bool = false, searchQuery:String = '')
	{
		if(reset)
			curSelected = 0;

		songBox.clear();
		iconGrp.clear();
		textGrp.clear();

		for (i in 0...songs.length)
		{
			Mods.currentModDirectory = songs[i].folder;

			var songBox:SongBox = new SongBox(320, 100);
			songBox.loadGraphic(Paths.image('freeplay/OSUState/bars/background2'));
			songBox.setGraphicSize(650, 100);
			songBox.setColorTransform(-1, -1, -1, 1, songs[i].colorR, songs[i].colorG, songs[i].colorB, 1);
			songBox.ID = i;
			this.songBox.add(songBox);

			var iconName = songs[i].songCharacter;
			var icon:HealthIcon = new HealthIcon(iconName, false);
			icon.setPosition(320, 100);
			icon.ID = i;
			icon.setGraphicSize(Std.int(icon.width / 1.7), Std.int(icon.height / 1.7));
			iconGrp.add(icon);

			var text:FlxText = new FlxText(0, 0, 500, '', 20);
			var displayName = songs[i].songName;
			var displayArtist = "Unknown";

			text.text = displayName + '\nBy ${displayArtist}';
			text.alignment = 'left';
			text.ID = i;
			textGrp.add(text);
		}

		maxSelected = songBox.length;

		changeSong();
	}

	var trueInt:Int = 0;
	function reloadSongArray()
	{
		songBox.clear();
		iconGrp.clear();
		textGrp.clear();

		trueInt = 0;

		for (i in 0...songs.length)
		{
			Mods.currentModDirectory = songs[i].folder;

			var songBox:SongBox = new SongBox(320, 100);
			songBox.loadGraphic(Paths.image('freeplay/OSUState/bars/background2'));
			songBox.setGraphicSize(650, 100);
			songBox.setColorTransform(-1, -1, -1, 1, songs[i].colorR, songs[i].colorG, songs[i].colorB, 1);
			songBox.ID = i + trueInt;
			this.songBox.add(songBox);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter, false);
			icon.setPosition(320, 100);
			icon.ID = i + trueInt;
			icon.setGraphicSize(Std.int(icon.width / 1.7), Std.int(icon.height / 1.7));
			iconGrp.add(icon);

			var text:FlxText = new FlxText(0, 0, 500, '', 20);
			var displayName = songs[i].songName;
			var displayArtist = "Unknown";

			text.text = displayName + '\nBy ${displayArtist}';
			text.alignment = 'left';
			text.ID = i + trueInt;
			textGrp.add(text);

			var week:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[songs[i].week]);
			Difficulty.loadFromWeek(week);

			if (songs[i].songName == songs[curSelected].songName) {
				trueInt = i+1;
				for (j in 0...Difficulty.list.length)
				{
					var songBox:SongBox = new SongBox(320, 100);
					songBox.loadGraphic(Paths.image('freeplay/OSUState/bars/background2'));
					songBox.setGraphicSize(650, 100);
					songBox.setColorTransform(-1, -1, -1, 1, songs[i].colorR, songs[i].colorG, songs[i].colorB, 1);
					songBox.ID = trueInt;
					this.songBox.add(songBox);

					var icon:HealthIcon = new HealthIcon(songs[i].songCharacter, false);
					icon.setPosition(320, 100);
					icon.ID = trueInt;
					icon.setGraphicSize(Std.int(icon.width / 1.7), Std.int(icon.height / 1.7));
					this.iconGrp.add(icon);

					var text:FlxText = new FlxText(0, 0, 500, '', 20);
					var displayName = songs[i].songName;
					text.text = displayName + '\n' + Difficulty.list[j];
					text.alignment = 'left';
					text.ID = trueInt;
					this.textGrp.add(text);

					trueInt++;
				}
			}
		}

		maxSelected = songBox.length;

		changeSong();
	}

	// Build songs[] from WeekData (mirrors FreeplayState.addSong behavior)
	function populateSongsFromWeeks()
	{
		songs = [];
		for (i in 0...WeekData.weeksList.length)
		{
			// optionally skip locked weeks (same logic as FreeplayState.weekIsLocked)
			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			if (weekIsLocked(WeekData.weeksList[i])) continue;

			for (j in 0...leWeek.songs.length)
			{
				var song = leWeek.songs[j];
				var colors:Array<Int> = song[2];
				if(colors == null || colors.length < 3)
				{
					colors = [146, 113, 253];
				}
				WeekData.setDirectoryFromWeek(leWeek);
				Mods.currentModDirectory = Mods.currentModDirectory == null ? "" : Mods.currentModDirectory;
				addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]));
			}
		}
	}

	function weekIsLocked(name:String):Bool
	{
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore)));
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int)
	{
		var sm = new SongMetadata(songName, weekNum, songCharacter, color);
		songs.push(sm);
	}

	}

	class SongMetadata { public var songName:String = ""; public var week:Int = 0; public var songCharacter:String = ""; public var color:Int = -7179779; public var folder:String = ""; public var lastDifficulty:String = null;

	// helpful split color components for easy ColorTransform usage
	public var colorR:Int;
	public var colorG:Int;
	public var colorB:Int;

	public function new(song:String, week:Int, songCharacter:String, color:Int)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.folder = Mods.currentModDirectory;
		if(this.folder == null) this.folder = '';
		// split color int into RGB components
		this.colorR = (color >> 16) & 0xFF;
		this.colorG = (color >> 8) & 0xFF;
		this.colorB = color & 0xFF;
	}
}