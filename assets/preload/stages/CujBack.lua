function onCreate()
	-- background shit
	makeLuaSprite('cujbg', 'cujbg', 200, 100);
	setScrollFactor('cujbg', 0.9, 0.9);
	
	makeLuaSprite('cujback', 'cujback', 200, 330);
	setScrollFactor('pixelbgfront', 0.9, 0.9);

	addLuaSprite('cujbg', false);
	addLuaSprite('cujback', false);

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end