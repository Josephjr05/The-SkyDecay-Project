function onCreate()
	-- background shit

	makeLuaSprite('optimized', 'optimized', -54, -22);
	setScrollFactor('optimized', 1, 1);
	scaleObject('optimized', 1.3, 1.3);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then

		makeLuaSprite('stage1/BG_WALL', 'stage1/BG_WALL', -152, -171);
		setScrollFactor('BG_WALL', 1.1, 1.1);
		scaleObject('BG_WALL', 2.3, 2.3);

		makeLuaSprite('stage1/BG_CITY', 'stage1/BG_CITY', -109, -109);
		setScrollFactor('stage1/BG_CITY', 1.3, 1);
		scaleObject('BG_CITY', 2.4, 2.4);

		makeLuaSprite('stage1/FG_Floor', 'stage1/FG_Floor', -154, -52);
		setScrollFactor('FG_Floor', 1, 1);
		scaleObject('FG_Floor', 2.3, 2.3);


	end

	addLuaSprite('optimized', false);
	addLuaSprite('stage1/BG_CITY', false);
	addLuaSprite('stage1/BG_WALL', false);
	addLuaSprite('stage1/FG_Floor', false);
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end