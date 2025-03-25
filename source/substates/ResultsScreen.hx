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
    				
    var safeZoneOffset:Float = (ClientPrefs.data.safeFrames / 60) * 1000;
    		
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
		
		opTextAdd('HealthGain: X' + ClientPrefs.getGameplaySetting('healthgain'), 1);
		opTextAdd('HealthLoss: X' + ClientPrefs.getGameplaySetting('healthloss'), 2);
		
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
	
	    FlxSpriteUtil.beginDraw(0xFFFFFFFF);
	    
	    var noteSize = 2.3;
	    var MoveSize = 0.8;
	    var color:FlxColor;
	    
	    for (i in 0...game.NoteTime.length - 1){
		    if (Math.abs(game.NoteMs[i]) <= ClientPrefs.data.perfectWindow && ClientPrefs.data.perfectRating) color = ColorArray[0];
		    else if (Math.abs(game.NoteMs[i]) <= ClientPrefs.data.greatWindow) color = ColorArray[1];
		    else if (Math.abs(game.NoteMs[i]) <= ClientPrefs.data.goodWindow) color = ColorArray[2];
		    else if (Math.abs(game.NoteMs[i]) <= ClientPrefs.data.okWindow) color = ColorArray[3];
		    else if (Math.abs(game.NoteMs[i]) <= safeZoneOffset) color = ColorArray[4];
		    else color = ColorArray[5];		    		    		    
		    		    		    
		    if (Math.abs(game.NoteMs[i]) <= safeZoneOffset){
    		    FlxSpriteUtil.drawCircle(graphNote, graphNote.width * (game.NoteTime[i] / PlayState.instance.songLength), graphNote.height * 0.5 + graphNote.height * 0.5 * MoveSize * (game.NoteMs[i] / safeZoneOffset), noteSize, color);
    		}else{
    		    FlxSpriteUtil.drawCircle(graphNote, graphNote.width * (game.NoteTime[i] / PlayState.instance.songLength), graphNote.height * 0.5 + graphNote.height * 0.5 * 0.9, noteSize, color);		
    		}    				    
		}
		
		FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 - 1, graphNote.width, 2, 0x7FFFFFFF);
		
		if (ClientPrefs.data.perfectRating){
    		FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 + graphNote.height * 0.5 * MoveSize * (ClientPrefs.data.perfectWindow / safeZoneOffset) - 1, graphNote.width, 2, ColorArrayAlpha[0]);
    		FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 - graphNote.height * 0.5 * MoveSize * (ClientPrefs.data.perfectWindow / safeZoneOffset) - 1, graphNote.width, 2, ColorArrayAlpha[0]);
		} //perfect
		
		if (!(ClientPrefs.data.perfectWindow >= ClientPrefs.data.greatWindow && ClientPrefs.data.perfectRating)){
		    FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 + graphNote.height * 0.5 * MoveSize * (ClientPrefs.data.greatWindow / safeZoneOffset) - 1, graphNote.width, 2, ColorArrayAlpha[1]);
    		FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 - graphNote.height * 0.5 * MoveSize * (ClientPrefs.data.greatWindow / safeZoneOffset) - 1, graphNote.width, 2, ColorArrayAlpha[1]);		
		} //great
		
		if ((ClientPrefs.data.perfectWindow <= ClientPrefs.data.goodWindow && ClientPrefs.data.perfectRating) || ClientPrefs.data.greatWindow <= ClientPrefs.data.goodWindow){
		    FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 + graphNote.height * 0.5 * MoveSize * (ClientPrefs.data.goodWindow / safeZoneOffset) - 1, graphNote.width, 2, ColorArrayAlpha[2]);
    		FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 - graphNote.height * 0.5 * MoveSize * (ClientPrefs.data.goodWindow / safeZoneOffset) - 1, graphNote.width, 2, ColorArrayAlpha[2]);		
		} //good
		
		if ((ClientPrefs.data.perfectWindow <= ClientPrefs.data.okWindow && ClientPrefs.data.perfectRating) || ClientPrefs.data.greatWindow <= ClientPrefs.data.okWindow || ClientPrefs.data.goodWindow <= ClientPrefs.data.okWindow){
		    FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 + graphNote.height * 0.5 * MoveSize * (ClientPrefs.data.okWindow / safeZoneOffset) - 1, graphNote.width, 2, ColorArrayAlpha[3]);
    		FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 - graphNote.height * 0.5 * MoveSize * (ClientPrefs.data.okWindow / safeZoneOffset) - 1, graphNote.width, 2, ColorArrayAlpha[3]);				
		} //ok
		
		FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 + graphNote.height * 0.5 * MoveSize - 1, graphNote.width, 2, ColorArrayAlpha[4]); 
    	FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 - graphNote.height * 0.5 * MoveSize - 1, graphNote.width, 2, ColorArrayAlpha[4]); 
    	//meh
    	
    	FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 + graphNote.height * 0.5 * 0.9 - 1, graphNote.width, 2, ColorArrayAlpha[3]);
    	//miss
		
		graphNote.updateHitbox();			
	
	}
	
	function percentRateAdd(){
	
	    var numPerfects:Int = 0;
    	var numGreats:Int = 0;
    	var numGoods:Int = 0;
    	var numOks:Int = 0;
    	var numMehs:Int = 0;
	
	    for (i in 0...game.NoteTime.length - 1){
		    if (Math.abs(game.NoteMs[i]) <= ClientPrefs.data.perfectWindow && ClientPrefs.data.perfectRating) numPerfects++;
		    else if (Math.abs(game.NoteMs[i]) <= ClientPrefs.data.greatWindow) numGreats++;
		    else if (Math.abs(game.NoteMs[i]) <= ClientPrefs.data.goodWindow) numGoods++;
		    else if (Math.abs(game.NoteMs[i]) <= ClientPrefs.data.okWindow) numOks++;
		    else if (Math.abs(game.NoteMs[i]) <= safeZoneOffset) numMehs++;		    	    		    		 
	    }
	    
	    var height:Int = ClientPrefs.data.perfectRating ? Std.int(300 / 5) : Std.int(300 / 4);	    
	    if (ClientPrefs.data.perfectRating) addRate(height, 'perfect', Reflect.field(ClientPrefs.data, 'perfectWindow'), numPerfects, ColorArray[0]);
	    addRate(height, 'great', Reflect.field(ClientPrefs.data, 'greatWindow'), numGreats, ColorArray[1]);
	    addRate(height, 'Good', Reflect.field(ClientPrefs.data, 'goodWindow'), numGoods, ColorArray[2]);
	    addRate(height, 'ok', Reflect.field(ClientPrefs.data, 'okWindow'), numOks, ColorArray[3]);
	    addRate(height, 'meh', (ClientPrefs.data.safeFrames / 60) * 1000, numMehs, ColorArray[4]);		    	    	
	}
	
	function addRate(height:Int, RateName:String, ms:Float, number:Int, color:FlxColor){
	
	    var numberBG:FlxSprite = new FlxSprite(percentBG.x + 5, percentBG.y + 5 + percentRectBGNumber.length * height).loadGraphic(createGraphic(Std.int(percentBG.width - 10), 30, 20, 20));
	    numberBG.color = FlxColor.BLACK;
		numberBG.alpha = 0;
		numberBG.antialiasing = ClientPrefs.data.antialiasing;
		percentRectBGNumber.add(numberBG);		
		
		var numberRect:FlxSprite = new FlxSprite(percentBG.x + 5, percentBG.y + 5 + percentRectNumber.length * height).loadGraphic(createGraphic(Std.int((percentBG.width - 10) * (number / (game.NoteTime.length - 1))), 30, 20, 20));
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
	    
	    var numberText = new FlxText(percentBG.x + 5 + percentBG.width / 2, numberBG.y + numberBG.height, 0, number + '(' + Math.ceil(number / (game.NoteTime.length - 1) * 100 * 100) / 100 + '%)', 16);		    
		numberText.font = Paths.font('Prototype.ttf');
		numberText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1, 1);
		numberText.scrollFactor.set();
		numberText.antialiasing = ClientPrefs.data.antialiasing;
	    numberText.alignment = LEFT;			
	    numberText.alpha = 0;    	
	    numberText.color = color;    
	    numberText.x -= numberText.width * 0.5;
	    percentTextNumber.add(numberText);
	    
	    var numberText = new FlxText(percentBG.x - 5 + percentBG.width, numberBG.y + numberBG.height, 0, Math.ceil(ms * 100) / 100 + 'MS', 16);		    
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