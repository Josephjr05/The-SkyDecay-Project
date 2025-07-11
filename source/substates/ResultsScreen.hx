package substates;

import flixel.addons.transition.FlxTransitionableState;

import states.PlayState;
import states.FreeplayState;
import states.OsuFreeplayState;
import states.MainMenuState;

import backend.Conductor;
import backend.Mods;
import backend.Highscore;
import backend.Song;
import backend.DiffCalc;

import flixel.math.FlxRect;
import flixel.util.FlxSpriteUtil;

import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.display.Bitmap;
import openfl.utils.Assets;
import openfl.Lib;

import openfl.filters.BlurFilter;
import flixel.graphics.frames.FlxFilterFrames;

#if sys
import sys.FileSystem; // to actually save the-
import sys.io.FileOutput; // results in a txt file.
#end

class ResultsScreen extends MusicBeatSubstate
{
	var background:FlxSprite;	
	var bgFilter:FlxFilterFrames;
	//BG
		    
    var modsBG:FlxSprite;
    var modsMenu:FlxSprite;
    var modsText:FlxText;
    // Results for what mod you played (SD ENGINE)
    
    var mesBG:FlxSprite;
    var mesTextNumber:FlxTypedGroup<FlxText>;
    // Results for song message
    
    var scBG:FlxSprite;
    var scTextNumber:FlxTypedGroup<FlxText>;
    // Results for score
    
    var opBG:FlxSprite;
    var opTextNumber:FlxTypedGroup<FlxText>;
    // Results for option
    
    var graphBG:FlxSprite;
    var graphNote:FlxSprite;
    // Results for note offset
    
    var percentBG:FlxSprite;
    var percentRectNumber:FlxTypedGroup<FlxSprite>;
    var percentRectBGNumber:FlxTypedGroup<FlxSprite>;
    var percentTextNumber:FlxTypedGroup<FlxText>;
    // Results for note rate percent
    
	var backText:FlxText;
    var backBG:FlxSprite;
	// back image
	
	var camOther:FlxCamera;        
    // camera
    
    var game = PlayState.instance;
	// game instance

	private var curSong:String = "";
	var composers:String = 'None';
	// uses curSong and composers
    
	// colors for each judgement (Osu Mania!)
    var ColorArray:Array<FlxColor> = [
    		0xFF00FFFF, //perfect
    		0xFFFFFF00, //great
    	    0xFF00FF00, //good
    	    0xFFFF7F00, //ok
    	    0xFFFF5858, //meh
    	    0xFFFF0000 //miss
    		];
    var ColorArrayAlpha:Array<FlxColor> = [
			0x7F00FFFF, //perfect 
    		0x7FFFFF00, //great
    	    0x7F00FF00, //good
    	    0x7FFF7F00, //ok
    	    0x7FFF5858, //meh
    	    0x7FFF0000 //miss
    		];
    				
    // var safeZoneOffset:Float = (ClientPrefs.data.safeFrames / 60) * 1000;
    		
	public function new(x:Float, y:Float)
	{
		super();

		#if DISCORD_ALLOWED
		DiscordClient.changePresence('In: ${PlayState.SONG.song} Results Screen', null);
		#end

		#if desktop
		Lib.application.window.title = 'The SkyDecay Project TestPhaseV2 | ${PlayState.SONG.song} Results Screen | Thank you for testing V2!';
		#end

		FlxG.sound.playMusic(Paths.music('girlfriendsRingtone'), 0.7);
	    
	    cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	    
	    camOther = new FlxCamera();
	    camOther.bgColor.alpha = 0;
	    FlxG.cameras.add(camOther, false);		
        
        background = new FlxSprite(0, 0).loadGraphic(Paths.image('the-kwell-end'));
		background.scale.x = 1;
		background.scale.y = 1;
		background.antialiasing = ClientPrefs.data.antialiasing;
		background.screenCenter();
		background.alpha = 0;
		add(background);
		
		//--------------------------
		
		modsBG = new FlxSprite(20, 20).loadGraphic(Paths.image('sdpjPROD'));		
		modsBG.alpha = 0;
		add(modsBG);		
					
		modsMenu = new FlxSprite(20, 20).loadGraphic(Paths.image('the-kwell-end'));		
		modsMenu.scale.x = 600 / modsMenu.width;
		modsMenu.scale.y = 338 / modsMenu.height;
		modsMenu.offset.x = 0;
		modsMenu.offset.y = 0;
		modsMenu.updateHitbox();		
		modsMenu.antialiasing = ClientPrefs.data.antialiasing;
		modsMenu.alpha = 0;
		// add(modsMenu);
		
		modsText = new FlxText(20, 20 + modsMenu.height, 0, 'The SkyDecay Project Test PhaseV2'); // This is included within in the window name
		modsText.size = 16;		
		modsText.font = Paths.font('Prototype.ttf');
		modsText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1, 1);		
		modsText.antialiasing = ClientPrefs.data.antialiasing;
	    modsText.alignment = CENTER;	
	    modsText.alpha = 0;
	    add(modsText);		
	    modsText.x += modsBG.width / 2 - modsText.width / 2;
	    if (modsText.width > 600) modsText.scale.x = 600 / modsText.width; 
	    modsText.offset.x = 0;
	    
	    //-------------------------		    		    
		
		mesBG = new FlxSprite(20, 20 + modsBG.height + 20).makeGraphic(600, 75, FlxColor.BLACK);
		mesBG.alpha = 0;
		add(mesBG);		
		
		mesTextNumber = new FlxTypedGroup<FlxText>();
		add(mesTextNumber);
	    
	    mesTextAdd('SongName: ' + PlayState.SONG.song + ' - ' + Difficulty.getString());
		mesTextAdd('Played Time: ' + Date.now().toString());
		
		//-------------------------
		
		scBG = new FlxSprite(20, 20 + modsBG.height + 20 + mesBG.height + 20).makeGraphic(600, 75, FlxColor.BLACK);	
		scBG.alpha = 0;
		add(scBG);		
		
		scTextNumber = new FlxTypedGroup<FlxText>();
		add(scTextNumber);
		
		scTextAdd('Score: ' + game.songScore, 1);
		scTextAdd('Highest Combo: ' + game.highestCombo, 2);
		scTextAdd('Accuracy: ' + Math.floor(game.ratingPercent * 10000) / 100 + '%', 1);
		if (game.ratingFC == '') scTextAdd('Rank: N/A', 2);
		else scTextAdd('Rank: ' + game.ratingName + ' - ' + game.ratingFC, 2);
		scTextAdd('Hits: ' + game.songHits, 1);
		scTextAdd('Misses: ' + game.songMisses, 2);
		
		//-------------------------
		
		opBG = new FlxSprite(20, 20 + modsBG.height + 20 + mesBG.height + 20 + scBG.height + 20).makeGraphic(600, 125, FlxColor.BLACK);	
		opBG.alpha = 0;
		add(opBG);		
		
		opTextNumber = new FlxTypedGroup<FlxText>();
		add(opTextNumber);
		
		opTextAdd('HealthGain: X' + CoolUtil.floorDecimal(game.healthGain, 2), 1); // Ensure healthGain is formatted correctly
		opTextAdd('HealthLoss: X' + CoolUtil.floorDecimal(game.healthGain, 2), 2); // HealthLoss should be formatted too
		
		var speed:String = ClientPrefs.getGameplaySetting('scrollspeed');
		if (ClientPrefs.getGameplaySetting('scrolltype') == 'multiplicative')
        speed = 'X' + speed;
        
		opTextAdd('SongSpeed: ' + speed, 1);
		opTextAdd('PlaybackRate: X' + ClientPrefs.getGameplaySetting('songspeed'), 2);
		
		var botplay:String = 'Disable';
		if (ClientPrefs.getGameplaySetting('botplay')) botplay = 'Enable';
		var practice:String = 'Disable';
		if (ClientPrefs.getGameplaySetting('practice')) practice = 'Enable';
		var instakill:String = 'Disable';
		if (ClientPrefs.getGameplaySetting('instakill')) instakill = 'Enable';		
		
		opTextAdd('PracticeMode: ' + practice, 1);
		opTextAdd('Instakill: ' + instakill, 2);		
		opTextAdd('Botplay: ' + botplay, 1);
		
		var opponentPlay:String = 'WIP';
		// if (ClientPrefs.data.opponentPlay) opponent = 'Enable';
		var mirror:String = 'WIP';
		// if (ClientPrefs.data.mirror) mirror = 'Enable';
		
		opTextAdd('OpponentPlay: ' + opponentPlay, 2);
		opTextAdd('Mirror: ' + mirror, 1); // Mirror Mod from Osu Mania
		
		//-------------------------
		
		graphBG = new FlxSprite(20 + 640, 20).makeGraphic(600, 300, FlxColor.BLACK);
		graphBG.alpha = 0;
		add(graphBG);
		
		graphNote = new FlxSprite(20 + 640, 20).makeGraphic(600, 300, FlxColor.TRANSPARENT);
		graphNote.alpha = 0;
		add(graphNote);
		
		graphNoteDraw();
		
		//-------------------------
		
		percentBG = new FlxSprite(20 + 640, 20 + 300 + 20).makeGraphic(600, 300, FlxColor.BLACK);
		percentBG.alpha = 0;
		add(percentBG);									
		
		percentRectBGNumber = new FlxTypedGroup<FlxSprite>();
		add(percentRectBGNumber);
		
		percentRectNumber = new FlxTypedGroup<FlxSprite>();
		add(percentRectNumber);
		
		percentTextNumber = new FlxTypedGroup<FlxText>();
		add(percentTextNumber);
		
		percentRateAdd();
		
		//-------------------------
		
		var backTextShow:String = 'Press Enter to continue';
		
		backText = new FlxText(FlxG.width, 0, backTextShow);
		backText.size = 28;
		backText.font = Paths.font('Prototype.ttf');
		backText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1, 1);
		backText.scrollFactor.set();
		backText.antialiasing = ClientPrefs.data.antialiasing;
	    backText.alignment = RIGHT;			    

		backBG = new FlxSprite(FlxG.width, FlxG.height).loadGraphic(Paths.image('menuExtend/ResultsScreen/backBG'));
		backBG.scrollFactor.set(0, 0);
		backBG.scale.x = 0.5;
		backBG.scale.y = 0.5;
		backBG.updateHitbox();
		backBG.antialiasing = ClientPrefs.data.antialiasing;
		backBG.y -= backBG.height + 10;		
		add(backBG);
		add(backText);		
		
		backBG.cameras = [camOther];
		backText.cameras = [camOther];
		
		backText.y = backBG.y + backBG.height / 2 - backText.height / 2;
							
		//-------------------------				
		
	    startTween();
	}

	var getReadyClose:Bool = false;    
	var closeCheck:Bool = false;
	override function update(elapsed:Float)
	{ 					
		if(!closeCheck && (FlxG.keys.justPressed.ENTER || ((FlxG.mouse.getScreenPosition(camOther).x > backBG.x && FlxG.mouse.getScreenPosition(camOther).x < backBG.x + backBG.width && FlxG.mouse.getScreenPosition(camOther).y > backBG.y && FlxG.mouse.getScreenPosition(camOther).y < backBG.y + backBG.height) && FlxG.mouse.justPressed) #if android || FlxG.android.justReleased.BACK #end))
		{
		    if (getReadyClose){
    		    NewCustomFadeTransition();
                // PlayState.cancelMusicFadeTween();
                closeCheck = true;
            }else{
                getReadyClose = true;
                FlxG.sound.play(Paths.sound('errorsfx'));
                
                backText.text = 'Press Again to continue';
                
                new FlxTimer().start(1, function(tmr:FlxTimer){    		        		                        		
		            var backTextShow:String = 'Press Enter to continue';		
            		backText.text = backTextShow;
            		
		            getReadyClose = false;
        		});
            }
		}		    
	}

	function saveScoreResults()
	{
		if (FlxG.keys.justPressed.F11) // will do something with this
		{
			if (FileSystem.exists('SDPJ-Saved-Scores'))
		  	FileSystem.createDirectory('SDPJ-Saved-Scores');
	
			var saveTxt:String = 'The SkyDecay Project
			
			Saved Score For: ${PlayState.SONG.song}
			By ${PlayState.instance.composers}
			At: ${Date.now().toString()}
			Difficulty: ${Difficulty.getString()}
			
			Statistics
			-----------
	
			Rank: ${game.ratingName + ' - ' + game.ratingFC}
			Score: ${game.songScore}
			Highest Combo: ${game.highestCombo}
			Accuracy: ${(Math.floor(game.ratingPercent * 10000) / 100 + '%')}
			Notes Hit: ${game.songHits}
			Misses: ${game.songMisses}
	
			Modifiers
			-----------
			
			HealthGain: ${ClientPrefs.getGameplaySetting('healthgain')}
			HealthLoss: ${ClientPrefs.getGameplaySetting('healthloss')}
	
			Scroll Speed: X ${ClientPrefs.getGameplaySetting('scrolltype') == 'multiplicative'}
			Playback Rate: ${ClientPrefs.getGameplaySetting('songspeed')}
	
			Opponent Play: WIP
			Mirror Mod: WIP
	
			Thank you for testing V2 of the Biggest, FNF Project, EVER!';
	
			// ('PracticeMode: ' + practice);
			// ('Instakill: ' + instakill);
			// ('Botplay: ' + botplay);

		File.saveContent('SDPJ-Saved-Scores/SkyDecay-Project-${curSong}.txt', saveTxt);
		}
	}

	function mesTextAdd(text:String = '', sameLine:Int = 0){
	    TextAdd(mesBG, mesTextNumber, text, sameLine);	
	}
	
	function scTextAdd(text:String = '', sameLine:Int = 0){
	    TextAdd(scBG, scTextNumber, text, sameLine);	
	}
	
	function opTextAdd(text:String = '', sameLine:Int = 0){
	    TextAdd(opBG, opTextNumber, text, sameLine);	
	}
	
	var textSize = 20;	
	function TextAdd(BG:Dynamic, type:Dynamic, text:String = '', sameLine:Int = 0){
	    var textWidth = 600;	    
	    var numberText = new FlxText(BG.x, BG.y, 0, text, textSize);	
	    if (sameLine > 0) numberText.y += Math.floor(type.length / 2) * 25;
	    else numberText.y += type.length * textSize;
	    if (sameLine > 0) numberText.x += (sameLine - 1) * 300;
		numberText.font = Paths.font('Prototype.ttf');
		numberText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1, 1);
		numberText.scrollFactor.set();
		numberText.antialiasing = ClientPrefs.data.antialiasing;
	    numberText.alignment = LEFT;			
	    numberText.alpha = 0;    	
	    if (sameLine > 0) textWidth = 300;
	    if (numberText.width > textWidth) numberText.scale.x = (textWidth - 1) / numberText.width; //fix width problem
	    numberText.offset.x = numberText.width * (1 - numberText.scale.x) / 2;
	    type.add(numberText);		
	}
	
    function graphNoteDraw(){
        // Use the dynamically calculated safeZoneOffset from Conductor
        var currentSafeZoneOffset = Conductor.safeZoneOffset * game.playbackRate; // Apply playbackRate if needed, like in PlayState
        if (currentSafeZoneOffset <= 0) currentSafeZoneOffset = 1; // Prevent division by zero

        // Get the actual hit windows from PlayState's ratingsData
        // Ensure ratingsData is not null and has enough elements
        if (game == null || game.ratingsData == null || game.ratingsData.length < 4) {
             trace("Error in graphNoteDraw: PlayState instance or ratingsData not ready.");
             return; // Cannot draw graph without rating data
        }
        var perfectWin = game.ratingsData[0].hitWindow; // sick
        var greatWin   = game.ratingsData[1].hitWindow; // good
        var goodWin    = game.ratingsData[2].hitWindow; // bad
        var okWin      = game.ratingsData[3].hitWindow; // shit

        FlxSpriteUtil.beginDraw(0xFFFFFFFF);

        var noteSize = 2.3;
        var MoveSize = 0.8;
        var color:FlxColor;

        for (i in 0...game.NoteTime.length - 1){
            var noteMs = game.NoteMs[i]; // Use the raw ms difference
            var absNoteMs = Math.abs(noteMs);

            // Determine color based on dynamic windows
            if (absNoteMs <= perfectWin) color = ColorArray[0];       // Perfect/Sick
            else if (absNoteMs <= greatWin) color = ColorArray[1];    // Great/Good
            else if (absNoteMs <= goodWin) color = ColorArray[2];     // Good/Bad
            else if (absNoteMs <= okWin) color = ColorArray[3];        // Ok/Shit
            else if (absNoteMs <= currentSafeZoneOffset) color = ColorArray[4]; // Meh
            else color = ColorArray[5];

            // Plotting the note
            if (absNoteMs <= currentSafeZoneOffset){
                FlxSpriteUtil.drawCircle(graphNote, graphNote.width * (game.NoteTime[i] / PlayState.instance.songLength), graphNote.height * 0.5 + graphNote.height * 0.5 * MoveSize * (noteMs / currentSafeZoneOffset), noteSize, color);
            }else{
                var missPos = (noteMs > 0) ? 0.9 : -0.9;
                FlxSpriteUtil.drawCircle(graphNote, graphNote.width * (game.NoteTime[i] / PlayState.instance.songLength), graphNote.height * 0.5 + graphNote.height * 0.5 * missPos, noteSize, color);
            }
        }

        FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 - 1, graphNote.width, 2, 0x7FFFFFFF);

        // Perfect/Sick
        FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 + graphNote.height * 0.5 * MoveSize * (perfectWin / currentSafeZoneOffset) - 1, graphNote.width, 2, ColorArrayAlpha[0]);
        FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 - graphNote.height * 0.5 * MoveSize * (perfectWin / currentSafeZoneOffset) - 1, graphNote.width, 2, ColorArrayAlpha[0]);
        // Great/Good
        FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 + graphNote.height * 0.5 * MoveSize * (greatWin / currentSafeZoneOffset) - 1, graphNote.width, 2, ColorArrayAlpha[1]);
        FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 - graphNote.height * 0.5 * MoveSize * (greatWin / currentSafeZoneOffset) - 1, graphNote.width, 2, ColorArrayAlpha[1]);
        // Good/Bad
        FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 + graphNote.height * 0.5 * MoveSize * (goodWin / currentSafeZoneOffset) - 1, graphNote.width, 2, ColorArrayAlpha[2]);
        FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 - graphNote.height * 0.5 * MoveSize * (goodWin / currentSafeZoneOffset) - 1, graphNote.width, 2, ColorArrayAlpha[2]);
        // Ok/Shit
        FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 + graphNote.height * 0.5 * MoveSize * (okWin / currentSafeZoneOffset) - 1, graphNote.width, 2, ColorArrayAlpha[3]);
        FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 - graphNote.height * 0.5 * MoveSize * (okWin / currentSafeZoneOffset) - 1, graphNote.width, 2, ColorArrayAlpha[3]);
        // Miss
        FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 + graphNote.height * 0.5 * MoveSize - 1, graphNote.width, 2, ColorArrayAlpha[4]); // Using Meh's color slot for boundary
        FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 - graphNote.height * 0.5 * MoveSize - 1, graphNote.width, 2, ColorArrayAlpha[4]); // Using Meh's color slot for boundary

        graphNote.updateHitbox();
	}
	
    function percentRateAdd()
	{
        // Use the dynamically calculated safeZoneOffset from Conductor
        var currentSafeZoneOffset = Conductor.safeZoneOffset * game.playbackRate; // Apply playbackRate if needed
        if (currentSafeZoneOffset <= 0) currentSafeZoneOffset = 1; // Prevent division by zero

        // Get the actual hit windows from PlayState's ratingsData
        if (game == null || game.ratingsData == null || game.ratingsData.length < 4) {
             trace("Error in percentRateAdd: PlayState instance or ratingsData not ready.");
             return; // Cannot process percentages without rating data
        }
        var perfectWin = game.ratingsData[0].hitWindow; // sick
        var greatWin   = game.ratingsData[1].hitWindow; // good
        var goodWin    = game.ratingsData[2].hitWindow; // bad
        var okWin      = game.ratingsData[3].hitWindow; // shit
		var mehWin 	= (game.ratingsData.length > 4) ? game.ratingsData[4].hitWindow : 0; // Only if you add a 5th rating back, otherwise 0

        var numPerfects:Int = 0;
        var numGreats:Int = 0;
        var numGoods:Int = 0;
        var numOks:Int = 0;
        var numMehs:Int = 0; // Only if you add a 5th rating back

        // Categorize hits based on dynamic windows
        for (i in 0...game.NoteTime.length - 1){ // Iterate up to length - 1 if NoteTime includes misses
             var absNoteMs = Math.abs(game.NoteMs[i]);
             if (absNoteMs <= perfectWin) numPerfects++;
             else if (absNoteMs <= greatWin) numGreats++;
             else if (absNoteMs <= goodWin) numGoods++;
             else if (absNoteMs <= okWin) numOks++;
             else if (absNoteMs <= currentSafeZoneOffset) numMehs++; // Only if you add a 5th rating
             // Misses are implicitly handled by not falling into these windows
        }

        // Calculate total hits recorded (excluding potential misses recorded in NoteMs)
        var totalJudgedHits = numPerfects + numGreats + numGoods + numOks; // + numMehs;
        // Calculate misses based on PlayState's count
        var numMisses = game.songMisses;
        // Calculate total attempts
        var totalAttempts = totalJudgedHits + numMisses;
        if (totalAttempts == 0) totalAttempts = 1; // Avoid division by zero

        // Determine height based on number of ratings to display
        var numRatingsToDisplay = 4 + (numMisses > 0 ? 1 : 0); // 4 base ratings + 1 for misses if any
        var height:Int = Std.int(300 / numRatingsToDisplay);

        // Add rates, passing the TOTAL window size (hitWindow * 2) for display
        addRate(height, game.ratingsData[0].name, perfectWin * 2, numPerfects, ColorArray[0], totalAttempts); // Perfect/Sick
        addRate(height, game.ratingsData[1].name, greatWin * 2,   numGreats,   ColorArray[1], totalAttempts); // Great/Good
        addRate(height, game.ratingsData[2].name, goodWin * 2,    numGoods,    ColorArray[2], totalAttempts); // Good/Bad
        addRate(height, game.ratingsData[3].name, okWin * 2,      numOks,      ColorArray[3], totalAttempts); // Ok/Shit
        addRate(height, 'meh', mehWin * 2, numMehs, ColorArray[4], totalAttempts); // If you add Meh back

        // Add Misses row if there were any
        if (numMisses > 0) {
            addRate(height, 'miss', currentSafeZoneOffset * 2, numMisses, ColorArray[5], totalAttempts); // Display miss threshold
        }
    }
	
    function addRate(height:Int, RateName:String, ms:Float, number:Int, color:FlxColor, totalAttempts:Int){

        var numberBG:FlxSprite = new FlxSprite(percentBG.x + 5, percentBG.y + 5 + percentRectBGNumber.length * height).loadGraphic(createGraphic(Std.int(percentBG.width - 10), 30, 20, 20));
        numberBG.color = FlxColor.BLACK;
        numberBG.alpha = 0;
        numberBG.antialiasing = ClientPrefs.data.antialiasing;
        percentRectBGNumber.add(numberBG);

        // Calculate percentage based on total attempts
        var percentage = (totalAttempts > 0) ? (number / totalAttempts) : 0;

        var numberRect:FlxSprite = new FlxSprite(percentBG.x + 5, percentBG.y + 5 + percentRectNumber.length * height).loadGraphic(createGraphic(Std.int((percentBG.width - 10) * percentage), 30, 20, 20));
        numberRect.color = color;
        numberRect.alpha = 0;
        numberRect.antialiasing = ClientPrefs.data.antialiasing;
        percentRectNumber.add(numberRect);

        var numberText = new FlxText(percentBG.x + 5, numberBG.y + numberBG.height, 0, RateName, 16);
        numberText.font = Paths.font('Prototype.ttf');
        numberText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1, 1);
        numberText.scrollFactor.set();
        numberText.antialiasing = ClientPrefs.data.antialiasing;
        numberText.alignment = LEFT;
        numberText.alpha = 0;
        numberText.color = color;
        percentTextNumber.add(numberText);

        // Display count and percentage
        var percentDisplay = Math.ceil(percentage * 100 * 100) / 100;
        var numberText = new FlxText(percentBG.x + 5 + percentBG.width / 2, numberBG.y + numberBG.height, 0, number + ' (' + percentDisplay + '%)', 16);
        numberText.font = Paths.font('Prototype.ttf');
        numberText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1, 1);
        numberText.scrollFactor.set();
        numberText.antialiasing = ClientPrefs.data.antialiasing;
        numberText.alignment = LEFT;
        numberText.alpha = 0;
        numberText.color = color;
        numberText.x -= numberText.width * 0.5;
        percentTextNumber.add(numberText);

        // Display the MS window (total width)
        var msText = (RateName != 'miss') ? (Math.ceil(ms * 100) / 100 + 'MS') : ('>' + Math.ceil(ms / 2 * 100) / 100 + 'MS'); // Show miss threshold differently
        var numberText = new FlxText(percentBG.x - 5 + percentBG.width, numberBG.y + numberBG.height, 0, msText, 16);
        numberText.font = Paths.font('Prototype.ttf');
        numberText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1, 1);
        numberText.scrollFactor.set();
        numberText.antialiasing = ClientPrefs.data.antialiasing;
        numberText.alignment = LEFT;
        numberText.alpha = 0;
        numberText.color = color;
        numberText.x -= numberText.width;
        percentTextNumber.add(numberText);
    }
	
	function createGraphic(Width:Int, Height:Int, ellipseWidth:Float, ellipseHeight:Float):BitmapData
	{
	    var shape:Shape = new Shape();	   
		shape.graphics.beginFill(0xFFFFFF);
		shape.graphics.drawRoundRect(0, 0, Width, Height, ellipseWidth, ellipseHeight);    		
		shape.graphics.endFill();    		
    	
    	var bitmap:BitmapData = new BitmapData(Width, Height, true, 0);
    		bitmap.draw(shape);
		return bitmap;		
	}
	
	function startTween(){
	
	    FlxTween.tween(background, {alpha: 1}, 1);	
	    
	    
	    new FlxTimer().start(1, function(tmr:FlxTimer){				    
								
    		FlxTween.tween(modsBG, {alpha: 0.5}, 0.5);		
    		FlxTween.tween(mesBG, {alpha: 0.5}, 0.5);		
    		FlxTween.tween(scBG, {alpha: 0.5}, 0.5);		
    		FlxTween.tween(opBG, {alpha: 0.5}, 0.5);		
    		
    		FlxTween.tween(graphBG, {alpha: 0.5}, 0.5);		
    		FlxTween.tween(percentBG, {alpha: 0.5}, 0.5);
		});			
		
		
		new FlxTimer().start(1.5, function(tmr:FlxTimer){
		  
		    FlxTween.tween(modsMenu, {alpha: 1}, 0.5);	           
            FlxTween.tween(modsText, {alpha: 1}, 0.5);	
		
		});						
		
		new FlxTimer().start(2, function(tmr:FlxTimer){
			for (i in 0...mesTextNumber.length){
			    var tweenTimer:FlxTimer = new FlxTimer();
                tweenTimer.start((0.5 - 0.1) / mesTextNumber.length * i, function(tmr:FlxTimer){
			        FlxTween.tween(mesTextNumber.members[i], {alpha: 1}, 0.1);
			    });
			}
			
			for (i in 0...scTextNumber.length){
			    var tweenTimer:FlxTimer = new FlxTimer();
                tweenTimer.start((0.5 - 0.1) / scTextNumber.length * i, function(tmr:FlxTimer){			
			        FlxTween.tween(scTextNumber.members[i], {alpha: 1}, 0.1);
			    });								
			}
			
			for (i in 0...opTextNumber.length){
			    var tweenTimer:FlxTimer = new FlxTimer();
                tweenTimer.start((0.5 - 0.1) / opTextNumber.length * i, function(tmr:FlxTimer){	
			        FlxTween.tween(opTextNumber.members[i], {alpha: 1}, 0.1);
			    });						
			}
		});
		
		new FlxTimer().start(2.5, function(tmr:FlxTimer){
		
		    FlxTween.tween(graphNote, {alpha: 1}, 0.5);
		
		    for (i in 0...percentRectBGNumber.length){		    
		        FlxTween.tween(percentRectBGNumber.members[i], {alpha: 1}, 0.3);
		    }
		
		    for (i in 0...percentRectNumber.length){		        
		        rectTween(percentRectNumber.members[i]);
		    }
		    
		    for (i in 0...percentRectNumber.length){		        
		        FlxTween.tween(percentRectNumber.members[i], {alpha: 1}, 0.3);
		    }
		    
		    for (i in 0...percentTextNumber.length){
		        FlxTween.tween(percentTextNumber.members[i], {alpha: 1}, 0.5);
		    }
		});
				
		new FlxTimer().start(3, function(tmr:FlxTimer){
			FlxTween.tween(backBG, {x:  1280 - backBG.width}, 1, {ease: FlxEase.cubeInOut});
			FlxTween.tween(backText, {x: 1280 - backBG.width / 2 - backText.width / 2}, 1.2, {ease: FlxEase.cubeInOut});
		});			
	}
	
    function rectTween(sprite:FlxSprite, tweenHeight:Bool = false, width:Int = 0, height:Int = 0){
        
        if (width == 0) width = Std.int(sprite.width);
        if (height == 0) height = Std.int(sprite.height);
        
        var swagRect:FlxRect;
	    
	    var time:Float = 0;
	    var maxTime:Float = 0.5;
	    
	    var timerTween:FlxTimer;
	    
	    timerTween = new FlxTimer().start(0.0001, function(tmr:FlxTimer) {
		    time += FlxG.elapsed;
    		if (time > maxTime) time = maxTime;
    		
    		if(swagRect == null) swagRect = new FlxRect(0, 0, 0, 0);
    		swagRect.x = 0;
	        swagRect.y = 0;
	        if (tweenHeight){
	            swagRect.width = width;
		        swagRect.height = height * (time / maxTime);    		
		    }else{
		        swagRect.width = width * (time / maxTime);
		        swagRect.height = height;    				    
		    }
		    sprite.clipRect = swagRect;
		    //sprite.alpha = 1;
		    
		    if (time == maxTime){
		        timerTween.cancel();		        		        
		    }
        }, 0);            
    }

	//NewCustomFadeTransition works for better close Substate (testing)

	var finishCallback:Void->Void;
	private var leTween:FlxTween = null;
	
	var isTransIn:Bool = false;
	
	var loadLeft:FlxSprite;
	var loadRight:FlxSprite;
	var loadAlpha:FlxSprite;
	var WaterMark:FlxText;
	var EventText:FlxText;
	
	var loadLeftTween:FlxTween;
	var loadRightTween:FlxTween;
	var loadAlphaTween:FlxTween;
	var EventTextTween:FlxTween;
	var loadTextTween:FlxTween;

	function NewCustomFadeTransition(duration:Float = 0.6, TransIn:Bool = false) {
		
		{
		isTransIn = TransIn;
				
    		loadRight = new FlxSprite(isTransIn ? 0 : 1280, 0).loadGraphic(Paths.image('menuExtend/CustomFadeTransition/loadingR'));
    		loadRight.scrollFactor.set();
    		loadRight.antialiasing = ClientPrefs.data.antialiasing;		
    		add(loadRight);
    		loadRight.cameras = [camOther];
    		loadRight.setGraphicSize(FlxG.width, FlxG.height);
    		loadRight.updateHitbox();
    		
    		loadLeft = new FlxSprite(isTransIn ? 0 : -1280, 0).loadGraphic(Paths.image('menuExtend/CustomFadeTransition/loadingL'));
    		loadLeft.scrollFactor.set();
    		loadLeft.antialiasing = ClientPrefs.data.antialiasing;
    		add(loadLeft);
    		loadLeft.cameras = [camOther];
    		loadLeft.setGraphicSize(FlxG.width, FlxG.height);
    		loadLeft.updateHitbox();
		
    		WaterMark = new FlxText(isTransIn ? 50 : -1230, 720 - 50 - 50 * 2, 0, 'SD ENGINE V' + MainMenuState.sdEngineVersion, 50);
    		WaterMark.scrollFactor.set();
    		WaterMark.setFormat(Assets.getFont("assets/fonts/Prototype.ttf").fontName, 50, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    		WaterMark.antialiasing = ClientPrefs.data.antialiasing;
    		add(WaterMark);
    		WaterMark.cameras = [camOther];
        
            EventText = new FlxText(isTransIn ? 50 : -1230, 720 - 50 - 50, 0, 'LOADING . . . . . . ', 50);
    		EventText.scrollFactor.set();
    		EventText.setFormat(Assets.getFont("assets/fonts/Prototype.ttf").fontName, 50, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    		EventText.antialiasing = ClientPrefs.data.antialiasing;
    		add(EventText);
    		EventText.cameras = [camOther];
		
			FlxG.sound.play(Paths.sound('loading_close_alpha'));

			loadLeftTween = FlxTween.tween(loadLeft, {x: 0}, duration, {
				onComplete: function(twn:FlxTween) {
				    FlxTransitionableState.skipNextTransIn = true;
				    Mods.loadTopMod();
					MusicBeatState.switchState(new FreeplayState());
				},
			ease: FlxEase.expoInOut});
			
			loadRightTween = FlxTween.tween(loadRight, {x: 0}, duration, {
				onComplete: function(twn:FlxTween) {
					if(finishCallback != null) {
						finishCallback();
					}
				},
			ease: FlxEase.expoInOut});
			
			loadTextTween = FlxTween.tween(WaterMark, {x: 50}, duration, {
				onComplete: function(twn:FlxTween) {
					if(finishCallback != null) {
						finishCallback();
					}
				},
			ease: FlxEase.expoInOut});
			
			EventTextTween = FlxTween.tween(EventText, {x: 50}, duration, {
				onComplete: function(twn:FlxTween) {
					if(finishCallback != null) {
						finishCallback();
					}
				},
			ease: FlxEase.expoInOut});	
		}
	}

	override function destroy() {
		if(leTween != null) {
			finishCallback();
			leTween.cancel();
			
			if (loadLeftTween != null) loadLeftTween.cancel();
			if (loadRightTween != null) loadRightTween.cancel();
			if (loadAlphaTween != null) loadAlphaTween.cancel();
			
			loadTextTween.cancel();
			EventTextTween.cancel();
		}
		super.destroy();
	}
}