function onCreate() 
	makeLuaSprite('sky', 'stages/powerjack/6', 0, 0)
	scaleObject('sky', 1, 1);
    setScrollFactor('sky', 1, 1);
	setProperty('sky.antialiasing', true)
	addLuaSprite('sky', false);

	makeLuaSprite('mainBG_layer2', 'stages/powerjack/4', 0, 0)
	scaleObject('mainBG_layer2', 1, 1);
    setScrollFactor('mainBG_layer2', 1, 1);
	setProperty('mainBG_layer2.antialiasing', true)
	addLuaSprite('mainBG_layer2', false);

	makeLuaSprite('mainBG_layer1', 'stages/powerjack/3', 0, 0)
	scaleObject('mainBG_layer1', 1, 1);
    setScrollFactor('mainBG_layer1', 1, 1);
	setProperty('mainBG_layer1.antialiasing', true)
	addLuaSprite('mainBG_layer1', false);

	makeLuaSprite('mainBG', 'stages/powerjack/2', 0, 0)
	scaleObject('mainBG', 1, 1);
    setScrollFactor('mainBG', 1, 1);
	setProperty('mainBG.antialiasing', true)
	addLuaSprite('mainBG', false);
    
	makeLuaSprite('grrggrrxkl-2', 'stages/powerjack/grrggrrxkl-2', 0, 0)
	scaleObject('grrggrrxkl-2', 1, 1);
    setScrollFactor('grrggrrxkl-2', 1, 1);
	setProperty('grrggrrxkl-2.antialiasing', true)
	addLuaSprite('grrggrrxkl-2', true);

    makeLuaSprite('foreground', 'stages/powerjack/1-1', 0, 0)
	scaleObject('foreground', 1, 1);
    setScrollFactor('foreground', 1, 1);
	setProperty('foreground.antialiasing', true)
	addLuaSprite('foreground', true);

    makeLuaSprite('grrggrgrtdsf-1', 'stages/powerjack/grrggrgrtdsf-1', 0, 0)
	scaleObject('grrggrgrtdsf-1', 1, 1);
    setScrollFactor('grrggrgrtdsf-1', 1, 1);
	setProperty('grrggrgrtdsf-1.visible', false)
	setProperty('grrggrgrtdsf-1.antialiasing', true)
	addLuaSprite('grrggrgrtdsf-1', false);
	
    makeLuaSprite('grrggrrxkl-1', 'stages/powerjack/grrggrrxkl-1', 0, 0)
	scaleObject('grrggrrxkl-1', 1, 1);
    setScrollFactor('grrggrrxkl-1', 1, 1);
	setProperty('grrggrrxkl-1.visible', false)
	setProperty('grrggrrxkl-1.antialiasing', true)
	addLuaSprite('grrggrrxkl-1', true);
end

function onEvent(eventName, value1, value2, strumTime)
	if (eventName == 'changeBG') then
		setProperty('mainBG_layer2.visible', false)
		setProperty('mainBG_layer1.visible', false)
		setProperty('mainBG.visible', false)
		setProperty('grrggrrxkl-2.visible', false)
		setProperty('foreground.visible', false)	
		setProperty('grrggrgrtdsf-1.visible', true)		
		setProperty('grrggrrxkl-1.visible', true)		
	end

	if (eventName == 'changeBACK') then
		setProperty('mainBG_layer2.visible', true)
		setProperty('mainBG_layer1.visible', true)
		setProperty('mainBG.visible', true)
		setProperty('grrggrrxkl-2.visible', true)
		setProperty('foreground.visible', true)	
		setProperty('grrggrgrtdsf-1.visible', false)		
		setProperty('grrggrrxkl-1.visible', false)
	end
end