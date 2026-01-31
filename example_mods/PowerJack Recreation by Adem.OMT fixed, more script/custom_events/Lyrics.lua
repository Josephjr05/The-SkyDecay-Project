local lyricNumber = {0, 0, 0, 0}

function onEvent(name, value1, value2)
    if name == 'Lyrics' then
        local LyricX = 0
        local LyricY = 0
        
        lyricNumber[1] = lyricNumber[1] + 1
        lyricNumber[2] = lyricNumber[1] - 1
        lyricNumber[3] = lyricNumber[1] - 2
        lyricNumber[4] = lyricNumber[1] - 3

        makeLuaText(lyricNumber[1], '<Insert Lyrics Here>', 4000, LyricX, LyricY)
        if value1 ~= '/delete' then
            addLuaText(lyricNumber[1])
        end
        setTextString(lyricNumber[1], stringTrim(value1))
        setTextFont(lyricNumber[1], 'vcr.ttf')
        setTextColor(lyricNumber[1], stringTrim(value2) ~= '' and stringTrim(value2) or 'ffffff')
        setTextSize(lyricNumber[1], 36)
        setTextAlignment(lyricNumber[1], 'center')
        setObjectCamera(lyricNumber[1], 'other')
		screenCenter(lyricNumber[1], 'other')

        if value1 ~= '/delete' then
            doTweenY(lyricNumber[1], lyricNumber[1], 500, 0.3 / playbackRate, 'circOut')
            doTweenY(lyricNumber[2], lyricNumber[2], 450, 0.3 / playbackRate, 'circOut')
            doTweenY(lyricNumber[3], lyricNumber[3], 400, 0.3 / playbackRate, 'circOut')
        end

        setProperty(lyricNumber[2] .. '.alpha', 0.5)
        setProperty(lyricNumber[3] .. '.alpha', 0.25)
        setProperty(lyricNumber[4] .. '.alpha', 0)
        
        if value1 == '/delete' then
            doTweenAlpha('trans1', lyricNumber[1], 0, 0.5, linear)
            doTweenAlpha('trans2', lyricNumber[2], 0, 0.5, linear)
            doTweenAlpha('trans3', lyricNumber[3], 0, 0.5, linear)
            doTweenAlpha('trans4', lyricNumber[4], 0, 0.5, linear)
            runTimer('deletingProcess', 0.5, 1)
        end
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'deletingProcess' then
        removeLuaText(lyricNumber[1], true)
        removeLuaText(lyricNumber[2], true)
        removeLuaText(lyricNumber[3], true)
        removeLuaText(lyricNumber[4], true)
    end
end