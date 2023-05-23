function onCreate()
	-- background shit
	makeLuaSprite('stagebackkapiold', 'stagebackkapiold', -600, -300);
	setScrollFactor('stagebackkapiold', 0.9, 0.9);
	
	makeLuaSprite('stagefrontkapiold', 'stagefrontkapiold', -650, 600);
	setScrollFactor('stagefrontkapiold', 0.9, 0.9);
	scaleObject('stagefrontkapiold', 1.1, 1.1);
	


	
	makeAnimatedLuaSprite('lightBlink','lights',-600,-300)addAnimationByPrefix('lightBlink','dance','lightblink',3,true)
    objectPlayAnimation('lightBlink','dance',false)
    setScrollFactor('lightBlink', 0.9, 0.9);

	addLuaSprite('stagebackkapiold', false);
	addLuaSprite('stagefrontkapiold', false);
	addLuaSprite('lightBlink', false);

	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end