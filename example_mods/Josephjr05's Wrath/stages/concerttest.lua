function onCreate()
	-- background shit
	makeLuaSprite('stage2/sky', 'stage2/sky', -1275, -625);
	setLuaSpriteScrollFactor('stage2/sky', 1, 1);
	scaleObject('stage2/sky', 0.85, 0.85);
	
	makeLuaSprite('stage2/farbuildings', 'stage2/farbuildings', -1275, -625);
	setLuaSpriteScrollFactor('stage2/farbuildings', 1, 1);
	scaleObject('stage2/farbuildings', 0.85, 0.85);

	makeLuaSprite('stage2/buildings', 'stage2/buildings', -1275, -625);
	setLuaSpriteScrollFactor('stage2/buildings', 1, 1);
	scaleObject('stage2/buildings', 0.85, 0.85);

	makeLuaSprite('stage2/stage', 'stage2/stage', -1275, -625);
	setLuaSpriteScrollFactor('stage2/stage', 1, 1);
	scaleObject('stage2/stage', 0.85, 0.85);

	makeAnimatedLuaSprite('stage2/speaker_left', 'stage2/speaker_left', -500, -50)
	addAnimationByPrefix('stage2/speaker_left', 'speaker 20', 'speaker 20', 24,true)
	addLuaSprite('stage2/speaker_left',false)
	objectPlayAnimation('stage2/speaker_left', 'speaker 20',false)

	addLuaSprite('stage2/speaker_left', false);
	addLuaSprite('stage2/sky', false);
	addLuaSprite('stage2/farbuildings', false);
	addLuaSprite('stage2/buildings', false);
	addLuaSprite('stage2/stage', false);
end