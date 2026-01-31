function onEvent(name, value1, value2)
    local var string = (value1)
    local var color = (value2)
    if name == "Lyrics2" then

        makeLuaText('captio2000', 'arroteAGORA', 1000, 150, 520)
        setTextString('captio2000',  '' .. string)
        setTextFont('captio2000', 'sonic-hud-font.ttf')
        setTextColor('captio2000', 'ffffff')
        doTweenColor('123 palavrinhas', 'captio2000', color, 0.25, 'linear')
        setTextSize('captio2000', 50);
        setProperty('captio2000.antialiasing', false);
        addLuaText('captio2000')
	    setObjectCamera('captio2000', 'other');
        setTextAlignment('captio2000', 'center')
        setProperty('captio2000.y', getProperty('captio2000.y') + 50)
		setObjectOrder('captio2000', getObjectOrder('flash') + 40)
        --removeLuaText('captions', true)
        
    end
end

