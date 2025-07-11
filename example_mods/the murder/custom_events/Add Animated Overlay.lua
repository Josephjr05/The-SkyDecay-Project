-- Event by JoltGanda
function onEvent(name, value1, value2)
	if name == 'Add Animated Overlay' then
		if value2 == 'delete' then
			removeLuaSprite(value1, true)
		else
			makeAnimatedLuaSprite(value1, value1, 0, 0)
			addAnimationByPrefix(value1, 'idle', 'idle', 24, true);
			setScrollFactor(value1, value2);
			setObjectCamera(value1, 'hud');
			addLuaSprite(value1, true)
		end
	end
end