-- The first event mabe by me(Scarlet Eye) --
function onEvent(name, value1, value2)
	if name == 'RedVG' then
		if value1 then -- begining
		makeLuaSprite('Red', 'RedVG', 0, 0)
	    setObjectCamera('Red', 'camGame')
	    addLuaSprite('Red', true)
	    doTweenAlpha('Red', 'Red', 1, value1, 'quadInOut');
	end
	    if value2 then -- end
	    makeLuaSprite('Red', 'RedVG', 0, 0)
	    setObjectCamera('Red', 'camGame')
	    addLuaSprite('Red', true)
		doTweenAlpha('Red', 'Red', 0, value2, 'quadInOut');
	    end
	end
end