function onCreate()
	

        -- sprites that only load if low Quality is turned off
        if not lowQuality then
	makeLuaSprite('highway', 'highway', -600, -300);
	setLuaSpriteScrollFactor('highway', 0.9, 0.9);
	end

	addLuaSprite('highway', false);

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end