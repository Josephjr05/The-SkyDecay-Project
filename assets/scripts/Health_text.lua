--BUDYN--

function onCreate()
    makeLuaText('healthText', 'Health: ' .. math.floor(getProperty("health") * 50), 300, screenWidth / 2 - -350 / 2, screenHeight / 2 - 430 / 1.5)
    addLuaText('healthText')
    setTextSize('healthText', 30);
end

function onUpdate(elapsed)
	-- start of "update", some variables weren't updated yet
    setTextString('healthText', '' .. math.floor(getProperty("health") * 50))

if getPropertyFromClass('ClientPrefs', 'downScroll') == false then
        setProperty('healthText.y', 630)
    end
end


