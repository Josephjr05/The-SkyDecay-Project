function onCreate()
	-- background shit
	makeLuaSprite('stagesunset', 'stagesunset', -600, -300);
	setScrollFactor('stagesunset', 0.9, 0.9);
	
	makeLuaSprite('stagefrontkapiold', 'stagefrontkapiold', -650, 600);
	setScrollFactor('stagefrontkapiold', 0.9, 0.9);
	scaleObject('stagefrontkapiold', 1.1, 1.1);
	
	makeAnimatedLuaSprite('audienceBop','upperBop',-550,-250)addAnimationByPrefix('audienceBop','dance','Upper Crowd Bob',18,true)
    objectPlayAnimation('audienceBop','dance',false)
    setScrollFactor('audienceBop', 0.9, 0.9);
	
	makeAnimatedLuaSprite('spookyBop','littleguys',10,100)addAnimationByPrefix('spookyBop','dance','Bottom Level Boppers',25,true)
	objectPlayAnimation('spookyBop','dance',false)
    setScrollFactor('spookyBop', 0.9, 0.9);
	
	makeAnimatedLuaSprite('lightBlink','lights',-600,-300)addAnimationByPrefix('lightBlink','dance','lightblink',2,true)
    objectPlayAnimation('lightBlink','dance',false)
    setScrollFactor('lightBlink', 0.9, 0.9);

	addLuaSprite('stagesunset', false);
	addLuaSprite('stagefrontkapiold', false);
	addLuaSprite('spookyBop', false);
	addLuaSprite('lightBlink', false);
	addLuaSprite('audienceBop', true);
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end