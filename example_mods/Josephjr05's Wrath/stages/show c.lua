function onCreate()
	-- background shit

	makeLuaSprite('blackout', 'blackout', -154, -52);
	setScrollFactor('blackout', 1, 1);
	scaleObject('blackout', 1, 1);

	makeLuaSprite('eff1', 'eff1', -154, -52);
	setScrollFactor('eff1', 1, 1);
	scaleObject('eff1', 0.1, 0.1);

	makeLuaSprite('eff2', 'eff2', -154, -52);
	setScrollFactor('eff2', 1, 1);
	scaleObject('eff2', 0.1, 0.1);

	makeLuaSprite('eff3', 'eff3', -154, -52);
	setScrollFactor('eff3', 1, 1);
	scaleObject('eff3', 0.1, 0.1);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then

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

	makeAnimatedLuaSprite('stage2/speaker_left', 'stage2/speaker_left', 199, 650)addAnimationByPrefix('stage2/speaker_left', 'stage2/speaker_left', 'speaker 200', 20, true);
	setScrollFactor('speaker_left', 1, 1);
	scaleObject('stage2/speaker_left', 0.8, 0.8);

	makeAnimatedLuaSprite('stage2/speaker_right', 'stage2/speaker_right', 2300, 650)addAnimationByPrefix('stage2/speaker_right', 'stage2/speaker_right', 'speaker 100', 20, true);
	setScrollFactor('speaker_right', 1, 1);
	scaleObject('stage2/speaker_right', 0.8, 0.8);

	makeAnimatedLuaSprite('stage2/speakerleft', 'stage2/speakerleft', 499, 850)addAnimationByPrefix('stage2/speakerleft', 'stage2/speakerleft', 'speaker00', 20, true);
	setScrollFactor('speakerleft', 1, 1);
	scaleObject('stage2/speakerleft', 0.5, 0.5);

	makeAnimatedLuaSprite('stage2/speakerright', 'stage2/speakerright', 2150, 900)addAnimationByPrefix('stage2/speakerright', 'stage2/speakerright', 'speakerr 100', 20, true);
	setScrollFactor('speakerright', 1, 1);
	scaleObject('stage2/speakerright', 0.5, 0.5);

	makeLuaSprite('stage2/frontcrowd', 'stage2/frontcrowd', -479, 689);
	setScrollFactor('stage2/frontcrowd', 1, 2);
	scaleObject('stage2/frontcrowd', 1, 1);

	makeLuaSprite('stage2/backcrowd', 'stage2/backcrowd', -479, -189);
	setScrollFactor('backcrowd', 0.1, 0.1);
	scaleObject('backcrowd', 1, 1);
end

	addLuaSprite('eff1', false);
	addLuaSprite('eff2', false);
	addLuaSprite('eff3', false);
	addLuaSprite('blackout', false);
	addLuaSprite('stage2/sky', false);
	addLuaSprite('stage2/farbuildings', false);
	addLuaSprite('stage2/buildings', false);
	addLuaSprite('stage2/lights', false);
	addLuaSprite('stage2/backcrowd', false);
	addLuaSprite('stage2/stage', false);
	addLuaSprite('stage2/speaker_left', false);
	addLuaSprite('stage2/speaker_right', false);
	addLuaSprite('stage2/speakerright', false);
	addLuaSprite('stage2/speakerleft', false);
	addLuaSprite('stage2/frontcrowd', true);

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end