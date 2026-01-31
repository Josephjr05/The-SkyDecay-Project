function onEvent(name, value1, value2)
    if name == 'Add Text' then
        text = value1;
        duration = tonumber(value2);
        runTimer('duration', duration);
        if duration == 0 then
        end

        if duration < 0 then
        end

        if duration > 0 then
            makeLuaText('le_text', text, 800, -500, 340)
            setTextSize('le_text', 50)
            setTextFont('le_text', 'sonic-1-hud-font.ttf')
            setTextAlignment('le_text', 'center')
            addLuaText('le_text');
            doTweenX('MoveInOne', 'le_text', 250, 1, 'circIn')
            runTimer('le_text_wait', duration, 1)
            setTextColor('FF0000')
        end
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'le_text_wait' then
        doTweenX('MoveOutOne', 'le_text', 1000, 1.5, 'circOut')
    end
end