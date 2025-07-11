function onEvent(name, value1, value2)
	if name == 'makeoverlayvisible' then
		if value2 == 'delete' then
			removeLuaSprite(value1, true)
		else
			objectPlayAnimation(value1,'idle', true);
			setProperty(value2,true);
                  
		end
	end
end