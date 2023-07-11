local allowCountdown = false
local incs = false
local cx = 0
local cy = 0
local squish= 80

function onCreate()

	    makeLuaSprite('black', '', 0, 0)
	    setScrollFactor('black', 0, 0)
	    makeGraphic('black', 3840, 2160, '000000')
	    addLuaSprite('black', false)
	    setProperty('black.alpha', 1)
	    screenCenter('black', 'xy')
		setObjectCamera('black','camOther')

		makeAnimatedLuaSprite('bfRun', 'loading/bf running', 40, 460);
		addAnimationByPrefix('bfRun', 'anim', 'bf running', 24, true);
		setLuaSpriteScrollFactor('bfRun',0,0)
		objectPlayAnimation('bfRun','anim',true)
		addLuaSprite('bfRun', false)
		setProperty('bfRun.antialiasing',true)
		scaleObject('bfRun', 0.3, 0.3)
		setObjectCamera('bfRun','camOther')
		runTimer('l',0.02,1)

	    precacheSound(assets[i])
	    precacheImage('characters');
	    precacheImage('images');
	    precacheSound('songs')
	    precacheSound('sounds')
	    precacheImage('characters');
	    precacheImage('hud');
	    precacheImage('assets');
	    precacheImage('shared');
		addCharacterToList('dadog, dad')
		addCharacterToList('dad, dad')
		addCharacterToList('monster, dad')
		addCharacterToList('pico, dad')
		addCharacterToList('tankman, dad')
		addCharacterToList('updike alt, dad')
		addCharacterToList('updike luggage, dad')
		addCharacterToList('updike sad, dad')
		addCharacterToList('updike, dad')
		addCharacterToList('bf eyes, boyfriend')
		addCharacterToList('bf scared, boyfriend')
		addCharacterToList('BF UPDIKE ALT, boyfriend')
		addCharacterToList('BF UPDIKE boyfriend')
		addCharacterToList('bf, boyfriend')
		addCharacterToList('bf-christmas, boyfriend')
		addCharacterToList('bf eyes, boyfriend')
		addCharacterToList('bf scared, boyfriend')

	    precacheImage('images/stage/behindTrain');
	    precacheImage('images/stage/doors');
	    precacheImage('images/stage/evilBG');
	    precacheImage('images/stage/city');
	    precacheImage('images/stage/evilBGoverlay');
	    precacheImage('images/stage/evilSnow');
	    precacheImage('images/stage/evilTree');
	    precacheImage('images/stage/hall ALTY');
	    precacheImage('images/stage/hall');
	    precacheImage('images/stage/hands');
	    precacheImage('images/stage/intercom alt');
	    precacheImage('images/stage/intercom');
	    precacheImage('images/stage/lightt');
	    precacheImage('images/stage/lightzY ALT');
	    precacheImage('images/stage/lightzY weird');
	    precacheImage('images/stage/lightzY');
	    precacheImage('images/stage/luggage alt');
	    precacheImage('images/stage/luggage');
	    precacheImage('images/stage/sky');
	    precacheImage('images/stage/stagecurtains new');
	    precacheImage('images/stage/stagefront new');
	    precacheImage('images/stage/street');
	    precacheImage('images/stage/tank0');
	    precacheImage('images/stage/tank1');
	    precacheImage('images/stage/tank2');
	    precacheImage('images/stage/tank3');
	    precacheImage('images/stage/tank4');
	    precacheImage('images/stage/tankBuildings');
	    precacheImage('images/stage/tankClouds');
	    precacheImage('images/stage/tankGround');
	    precacheImage('images/stage/tankmanbackground');
	    precacheImage('images/stage/tankMountains');
	    precacheImage('images/stage/tankRuins');
	    precacheImage('images/stage/tankSky');
	    precacheImage('images/stage/tankWatchtower');
	    precacheImage('images/stage/weirdbg');
	    precacheImage('images/stage/white box');
	    precacheImage('images/stage/window');
	    preCacheShit()

end

function onCreatePost()
		setProperty('camGame.alpha', 1)

end

function onStartCountdown()
	if not allowCountdown and not seenCutscene then
		setPropertyFromClass('flixel.FlxG', 'mouse.visible', false);
		runTimer('l', 3)
		return Function_Stop
	end
	return Function_Continue
end


local pause = false
local esc = false
local MR = false

function onSongStart()
	pause = true
	setProperty('boyfriend.stunned', false)
end

function preCacheShit()
    for i = 1,#assets do
        precacheImage(assets[i])
    end
    precacheSound(assets[i])
	    precacheImage('characters');
	    precacheImage('images');
	    precacheSound('songs')
	    precacheSound('sounds')
	    precacheImage('characters');
	    precacheImage('hud');
	    precacheImage('assets');
	    precacheImage('shared');
		addCharacterToList('dadog, dad')
		addCharacterToList('dad, dad')
		addCharacterToList('monster, dad')
		addCharacterToList('pico, dad')
		addCharacterToList('tankman, dad')
		addCharacterToList('updike alt, dad')
		addCharacterToList('updike luggage, dad')
		addCharacterToList('updike sad, dad')
		addCharacterToList('updike, dad')
		addCharacterToList('bf eyes, boyfriend')
		addCharacterToList('bf scared, boyfriend')
		addCharacterToList('BF UPDIKE ALT, boyfriend')
		addCharacterToList('BF UPDIKE boyfriend')
		addCharacterToList('bf, boyfriend')
		addCharacterToList('bf-christmas, boyfriend')
		addCharacterToList('bf eyes, boyfriend')
		addCharacterToList('bf scared, boyfriend')

	    precacheImage('images/stage/behindTrain');
	    precacheImage('images/stage/doors');
	    precacheImage('images/stage/evilBG');
	    precacheImage('images/stage/city');
	    precacheImage('images/stage/evilBGoverlay');
	    precacheImage('images/stage/evilSnow');
	    precacheImage('images/stage/evilTree');
	    precacheImage('images/stage/hall ALTY');
	    precacheImage('images/stage/hall');
	    precacheImage('images/stage/hands');
	    precacheImage('images/stage/intercom alt');
	    precacheImage('images/stage/intercom');
	    precacheImage('images/stage/lightt');
	    precacheImage('images/stage/lightzY ALT');
	    precacheImage('images/stage/lightzY weird');
	    precacheImage('images/stage/lightzY');
	    precacheImage('images/stage/luggage alt');
	    precacheImage('images/stage/luggage');
	    precacheImage('images/stage/sky');
	    precacheImage('images/stage/stagecurtains new');
	    precacheImage('images/stage/stagefront new');
	    precacheImage('images/stage/street');
	    precacheImage('images/stage/tank0');
	    precacheImage('images/stage/tank1');
	    precacheImage('images/stage/tank2');
	    precacheImage('images/stage/tank3');
	    precacheImage('images/stage/tank4');
	    precacheImage('images/stage/tankBuildings');
	    precacheImage('images/stage/tankClouds');
	    precacheImage('images/stage/tankGround');
	    precacheImage('images/stage/tankmanbackground');
	    precacheImage('images/stage/tankMountains');
	    precacheImage('images/stage/tankRuins');
	    precacheImage('images/stage/tankSky');
	    precacheImage('images/stage/tankWatchtower');
	    precacheImage('images/stage/weirdbg');
	    precacheImage('images/stage/white box');
	    precacheImage('images/stage/window');
end

function onUpdate( elapsed )

	if not allowCountdown and (keyReleased('space') or getPropertyFromClass('flixel.FlxG', 'keys.justReleased.ENTER')) and not startedCountdown then

	--if not allowCountdown and not startedCountdown then
		allowCountdown = true
		startCountdown()
		--playSound('clickText')
		removeLuaSprite('bfRun', true)
		setPropertyFromClass('flixel.FlxG', 'mouse.visible', false);
		runTimer('ll', 0.1)
	end
	if getPropertyFromClass('flixel.FlxG', 'keys.justReleased.ESCAPE') and not esc and pause then
		esc = true
		pause = false
		endSong()
	end
	if getPropertyFromClass('flixel.FlxG', 'keys.justReleased.ESCAPE') and esc then
		pause = false
		endSong()
	end
end

function onTimerCompleted(t,l,ll)

	if t=='l' then

		allowCountdown = true
		startCountdown()
		--playSound('clickText')
		removeLuaSprite('bfRun', true)
		setPropertyFromClass('flixel.FlxG', 'mouse.visible', false);
		setPropertyFromClass('PlayState','seenCutscene',true)
    	doTweenAlpha('black', 'black', 0, 0.5, 'linear');
	end

	if t=='ll' then
		setPropertyFromClass('PlayState','seenCutscene',true)
    	doTweenAlpha('black', 'black', 0, 0.5, 'linear');

	end
end