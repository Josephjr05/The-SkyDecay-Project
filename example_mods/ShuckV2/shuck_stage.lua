function onCreate()
	-- background shit
	makeLuaSprite('shuckback', 'shuckback', -1250, -200);
	setLuaSpriteScrollFactor('shuckback', 0.9, 0.9);
	scaleObject('shuckback', 0.65, 0.65);
	
	makeLuaSprite('shuckfront', 'shuckfront', -1250, -200);
	setLuaSpriteScrollFactor('shuckfront', 0.9, 0.9);
	scaleObject('shuckfront', 0.65, 0.65);

	-- sprites that only load if Low Quality is turned off

	addLuaSprite('shuckback', false);
	addLuaSprite('shuckfront', true);
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end