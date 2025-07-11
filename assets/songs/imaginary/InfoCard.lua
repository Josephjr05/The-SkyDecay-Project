function onCreate()
    local toughness = checkDifficulty()
 
-- when you see "makeLuaSprite('bgThing', 'SongTest', -700, 230)", change the "BlackBar" to whatever your bar name is to show a image for it

	makeLuaSprite('bgThing', 'SongCard', -700, 240)
    scaleObject('bgThing', 0.35, 0.35)
	setObjectCamera('bgThing', 'hud')
    addLuaSprite('bgThing', true)
    setScrollFactor('bgThing', 0, 0)
    setProperty('bgThing.alpha', tonumber(1.7))


    makeLuaText('songText', "".. songName.. " by sixty".. toughness, 400, getProperty('bgThing.x') + 50, 335)
    setObjectCamera("songText", 'hud');
    setTextColor('songText', '0xffffff')
    setTextSize('songText', 22);
    addLuaText("songText");
    setTextFont('songText', "anormalfont.ttf")
    setTextAlignment('songText', 'left')
    

    makeLuaText('beforeSongText', "Now Playing: ", 300, getProperty('bgThing.x') + 100 - 40, 264)
    setObjectCamera("beforeSongText", 'hud');
    setTextColor('beforeSongText', '0xffffff')
    setTextSize('beforeSongText', 25);
    addLuaText("beforeSongText");
    setTextFont('beforeSongText', "anormalfont.ttf")
    setTextAlignment('beforeSongText', 'left')


    setObjectOrder('beforeSongText', 3)
    setObjectOrder('songText', 3)
    setObjectOrder('bgThing', 2)
end

function onCreatePost()
    doTweenX('bgThingMoveIn', 'bgThing', 1, 0.6, 'circInOut')
    doTweenX('bgThingText', 'songText', 130, 0.6, 'circInOut')  -- might need to mess with these for longer names
    doTweenX('bgThingTextBleb', 'beforeSongText', 120, 0.6, 'circInOut')  -- might need to mess with these for longer names
    runTimer('circInOut', 3.7, 1)
end

function onUpdate()

end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'circInOut' then
        doTweenX('bgThingLeave', 'bgThing', -700, 0.6, 'circInOut')
        doTweenX('bgThingLeaveText', 'songText', -500, 0.6, 'circInOut')  -- might need to mess with these for longer names
        doTweenX('bgThingLeavePreText', 'beforeSongText', -400, 0.6, 'circInOut') -- might need to mess with these for longer names
    end
end

function onTweenCompleted(tag)
    if tag == 'bgThingLeave' then
        removeLuaSprite('bgThing', true)
        removeLuaText('songText', true)
        removeLuaText('beforeSongText', true)
    end
end

function checkDifficulty()
    -- not needed really, but cool
    if difficulty == 2 then
        return '';
    elseif difficulty == 1 then
        return '';
    else
        return '';
    end

end