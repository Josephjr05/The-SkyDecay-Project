local allowCountdown = false
local inSelection = true
local ofsx = -210
local ofsy = 0
local mult = 1.25
characterNames = {'bf', 'pico-player'} --character json name
characterDisplays = {'Boyfriend', 'Pico'} --display name for text
characterLimit = {3, 1} --how many variations does the character have
maxpage = 2 --amount of characters u have
variation = 1 -- 1 = original
local page = 1
local inSelection = true
local bfStartX
local bfStartY
function onCreatePost()
    bfStartX = getProperty('boyfriend.x')
    bfStartY = getProperty('boyfriend.y')
    setProperty('boyfriend.scale.x', 0.7)
    setProperty('boyfriend.scale.y', 0.7)
    setProperty('boyfriend.x', 550)
    setProperty('boyfriend.y', 320)
    setProperty('botplayTxt.visible', false)
end
function onCreate()
  if allowCountdown == false then
    makeLuaSprite('stage', 'stage', -100, 0)
    addLuaSprite('stage', false)
    scaleObject('stage', 0.7, 0.7)

    makeLuaSprite('left1', 'ArrowLeft_Idle', 250, 400)
    addLuaSprite('left1', false)

    makeLuaSprite('left2', 'ArrowLeft_Pressed', 250, 400)
    addLuaSprite('left2', false)
    setProperty('left2.alpha', 0)

    makeLuaSprite('right1', 'ArrowRight_Idle', 1050, 400)
    addLuaSprite('right1', false)

    makeLuaSprite('right2', 'ArrowRight_Pressed', 1050, 400)
    addLuaSprite('right2', false)
    setProperty('right2.alpha', 0)

    makeLuaSprite('Notes', 'Notes', 600, 200)
    addLuaSprite('Notes', false)
    scaleObject('Notes', 0.5, 0.5)

    makeLuaSprite('fader', '', -200, -200)
    makeGraphic('fader', 1920, 1080, '000000')
    addLuaSprite('fader', true)
    setScrollFactor('fader', 0, 0)
    setProperty('fader.alpha', 0)
    setObjectCamera('fader', 'other')

  	makeLuaSprite('1', 'run', -600, -300);
  	setScrollFactor('1', 0.9, 0.9);

  	addLuaSprite('1', false);
    makeLuaText('text1', characterDisplays[page], 600, 350, 50)
    setTextSize('text1', 50);--Sets text size
    setTextWidth('text1', 600);--Sets text width
    addLuaText('text1')
    setTextFont('text1', 'comic.ttf')
    setProperty('gf.visible', false)
    setProperty('dad.visible', false)
    playMusic('offsetSong')
  end
end
function onStartCountdown()
	-- Block the first countdown and start a timer of 0.8 seconds to play the dialogue
	if not allowCountdown and not isStoryMode and not seenCutscene then
		setProperty('inCutscene', true);
    setProperty('gf.visible', false)
    setProperty('dad.visible', false)
		allowCountdown = true;
		return Function_Stop;
	end
	return Function_Continue;
end
function onUpdate()
  if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ENTER') then
    if inSelection == true and getProperty('inCutscene') == true then
      stopSound('offsetSong`')
      playMusic('gameOverEnd', 0.5)
      if page < 3 then
        objectPlayAnimation('boyfriend', 'hey', true);
        objectPlayAnimation('pico-player', 'singUP', true);
      else
        objectPlayAnimation('boyfriend', 'hey', false)
      end
      runTimer('startsong', 5)
      runTimer('fadein', 2.5)
      runTimer('selectingdone', 2.4)
      runTimer('fadedelay', 1.5)
      setProperty('seenCutscene', true)    
    end
  end
  if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.BACKSPACE') then
    endSong()
    runTimer('fadein', 0.2)
  end
  if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.RIGHT') then
    if page < maxpage and inSelection == true then
      variation = 1
      page = page+1
      --debugPrint(page, characterNames[page], characterDisplays[page], variation)
      setCharacter()
      selecting = true
      setProperty('right2.alpha', 1)
      setProperty('right1.alpha', 0)
      runTimer('right', 0.1)
    end
  elseif getPropertyFromClass('flixel.FlxG', 'keys.justPressed.LEFT') then
    if page > 0 and inSelection == true then
      variation = 1
      page = page-1
      --debugPrint(page, characterNames[page], characterDisplays[page], variation)
      setCharacter()
      selecting = true
      setProperty('left2.alpha', 1)
      setProperty('left1.alpha', 0)
      runTimer('left', 0.1)
    end
  end


  if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.UP') then
    if variation < characterLimit[page] and inSelection == true then
      variation = variation+1
      --debugPrint(page, characterNames[page], characterDisplays[page], variation)
      setCharacter()
    end
  elseif getPropertyFromClass('flixel.FlxG', 'keys.justPressed.DOWN') then
    if variation > -1 and inSelection == true then
      variation = variation-1
      --debugPrint(page, characterNames[page], characterDisplays[page], variation)
      setCharacter()
    end
  end
  --animation player
  if inSelection == true then
    if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.D') then
      objectPlayAnimation('boyfriend', 'singLEFT', true)
    elseif getPropertyFromClass('flixel.FlxG', 'keys.justPressed.J') then
      objectPlayAnimation('boyfriend', 'singUP', true)
    elseif getPropertyFromClass('flixel.FlxG', 'keys.justPressed.F') then
      objectPlayAnimation('boyfriend', 'singDOWN', true)
    elseif getPropertyFromClass('flixel.FlxG', 'keys.justPressed.K') then
      objectPlayAnimation('boyfriend', 'singRIGHT', true)
    elseif getPropertyFromClass('flixel.FlxG', 'keys.justPressed.G') then
      objectPlayAnimation('boyfriend', 'hey', true)
    elseif getPropertyFromClass('flixel.FlxG', 'keys.justPressed.H') then
      objectPlayAnimation('boyfriend', 'idle', true)
    end
  end
end
function onUpdatePost()
    if selecting then  
        setProperty('boyfriend.scale.x', 0.7)
        setProperty('boyfriend.scale.y', 0.7)
        setProperty('boyfriend.x', 550)
        setProperty('boyfriend.y', 320)
    end
end
function onTimerCompleted(tag)
  if tag == 'startsong' then
    startCountdown()
  end
  if tag == 'fadein' then
    inSelection = false
    setProperty('dad.visible', true)
    if page == 1 then
      setProperty('gf.visible', true)
    end
    removeLuaSprite('1', true)
    removeLuaSprite('2', true)
    removeLuaSprite('3', true)
    removeLuaSprite('4', true)
    removeLuaSprite('5', true)
    removeLuaSprite('stage', 'stage', 0, 0)
    removeLuaSprite('Notes', true)
    runTimer('fadeout', 2.5)
    scaleObject('bf', 1, 1)
    setProperty('boyfriend.x')
    setProperty('boyfriend.y')
    setProperty('boyfriend.scale.x', 1)
    setProperty('boyfriend.scale.y', 1)
    setProperty('boyfriend.x', bfStartX)
    setProperty('boyfriend.y', bfStartY)
    removeLuaSprite('left1', true)
    removeLuaSprite('leftt2', true)
    removeLuaSprite('right1', true)
    removeLuaSprite('right2', true)
    if botPlay then
        setProperty('botplayTxt.visible', true)
    end
  end
  if tag == 'fadedelay' then
    doTweenAlpha('faderfader', 'fader', 1, 0.9, 'linear')
  end
  if tag == 'left' then
      setProperty('left2.alpha', 0)
      setProperty('left1.alpha', 1)
  end
  if tag == 'right' then
      setProperty('right2.alpha', 0)
      setProperty('right1.alpha', 1)
  end
  if tag == 'selectingdone' then
    selecting = false
    removeLuaText('text1', true)
  end
end
function setCharacter()
  if page > 0 and page < maxpage+1 and inSelection == true then
    setVariation()
    setTextString('text1', characterDisplays[page]);
    --setProperty('boyfriend', 'x', defaultBoyfriendX+characterOfsX[page])
    --setProperty('boyfriend', 'y', defaultBoyfriendY+characterOfsY[page])
    triggerEvent('Change Character', 0, characterNames[page]);
    objectPlayAnimation('boyfriend', 'idle', true)
  end
end
function setVariation()
  if variation == 1 then
    characterNames = {'bf', 'Pico'} --character json name
    characterDisplays = {'Boyfriend', 'pico-player'} --display name for text
  end
end
function onTweenCompleted(tag)
  if tag == 'faderfader' then
    doTweenAlpha('faderfaderBYE', 'fader', 0, 1.4, 'linear')
  end
end