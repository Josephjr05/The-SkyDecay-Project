function onEvent(name, value1, value2)
    local var string = (value1)
    local var color = (value2)
    if name == "LyricsShucks" then

        makeLuaText('captions', 'Lyrics go here', 1000, 150, 530)
        setTextString('captions',  '' .. string)
        setTextColor('captions', 'FF0000')
        setTextSize('captions', 100);
        addLuaText('captions')
        setTextFont('captions', 'who asks satan.ttf')
	    setObjectCamera('captions', 'other');
        setTextAlignment('captions', 'center')
        doTweenAlpha('InitBlackFadeOut2', 'captions', 0, 3, 'linear');
    end
    if value1 == ' ' then 
        --doTweenAlpha('InitBlackFadeOut2', 'captions', 0, 2, 'linear');
    end    
end

