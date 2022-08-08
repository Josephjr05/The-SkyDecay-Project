function onCreate()
	-- background shit
	makeLuaSprite('stage2/sky', 'stage2/sky', -479, -189);
	setScrollFactor('sky', 0.1, 0.1);
	scaleObject('sky', 1, 1);

	makeLuaSprite('stage2/farbuildings', 'stage2/farbuildings', -479, -189);
	setScrollFactor('farbuildings', 1, 1);
	scaleObject('farbuildings', 1, 1);

	makeLuaSprite('stage2/buildings', 'stage2/buildings', -479, -189);
	setScrollFactor('buildings', 1, 1);
	scaleObject('buildings', 1, 1);
	
	makeAnimatedLuaSprite('stage2/lights', 'stage2/lights', -479, -189)addAnimationByPrefix('stage2/lights', 'stage2/lights', 'bglights idle', 2, true);
	setScrollFactor('lights', 0.8, 0.8);
	scaleObject('lights', 1.3, 1);

	makeLuaSprite('stage2/stage', 'stage2/stage', -479, -189);
	setScrollFactor('stage', 1, 1);
	scaleObject('stage', 1, 1);

	addLuaSprite('stage2/sky', false);
	addLuaSprite('stage2/farbuildings', false);
	addLuaSprite('stage2/buildings', false);
	addLuaSprite('stage2/lights', false);
	addLuaSprite('stage2/stage', false);
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end