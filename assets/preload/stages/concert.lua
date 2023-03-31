local citycycle = 1
local ofs = 200
local jumpscare = math.random(0,4)

local autolights = true
local slowlights = false
local playerlights = false

--defaultzoom0.59
function onCreate()
	if not lowQuality then 
	makeLuaSprite('sky', 'camellia/Week2/sky', -950, -500);
	scaleObject('sky', 1.75, 1.75);	
	setScrollFactor('sky', 1, 1);	
	addLuaSprite('sky', false);

	makeLuaSprite('light', 'camellia/Week2/light', -950, -500);
	scaleObject('light', 1.75, 1.75);	
	setScrollFactor('light', 1, 1);	
	addLuaSprite('light', false);


if jumpscare >= 4 then
	makeLuaSprite('camellia_jumpscare', 'camellia/Week2/camelliaJumpscare', -950, -520);
	scaleObject('camellia_jumpscare', 0.85, 0.85);	
	setScrollFactor('camellia_jumpscare', 1, 1);	
	addLuaSprite('camellia_jumpscare', false);
end

	makeLuaSprite('crowd_back', 'camellia/Week2/backcrowd', -950, 190);
	scaleObject('crowd_back', 1.75, 1.75);	
	setScrollFactor('crowd_back', 1, 1);	
	addLuaSprite('crowd_back', false);

	makeLuaSprite('stage', 'camellia/Week2/stage', -950, -505);
	scaleObject('stage', 0.85, 0.85);	
	setScrollFactor('stage', 1, 1);	
	addLuaSprite('stage', false);

	makeAnimatedLuaSprite('speaker_left', 'camellia/Week2/speaker_left', -350, 110);
	addAnimationByPrefix('speaker_left','bop','speaker',24, false)
	scaleObject('speaker_left', 0.75, 0.75);	
	setScrollFactor('speaker_left', 1, 1);	
	addLuaSprite('speaker_left', false);

	makeAnimatedLuaSprite('speaker_right', 'camellia/Week2/speaker_left', 1330, 110);
	addAnimationByPrefix('speaker_right','bop','speaker',24, false)
	setProperty('speaker_right.flipX', true)
	scaleObject('speaker_right', 0.75, 0.75);	
	setScrollFactor('speaker_right', 1, 1);	
	addLuaSprite('speaker_right', false);

	makeAnimatedLuaSprite('speaker_left2', 'camellia/Week2/speaker_left', -60, 320);
	addAnimationByPrefix('speaker_left2','bop','speaker',24, false)
	scaleObject('speaker_left2', 0.5, 0.5);	
	setScrollFactor('speaker_left2', 1, 1);	
	addLuaSprite('speaker_left2', false);

	makeAnimatedLuaSprite('speaker_right2', 'camellia/Week2/speaker_left', 1160, 320);
	addAnimationByPrefix('speaker_right2','bop','speaker',24, false)
	setProperty('speaker_right2.flipX', true)
	scaleObject('speaker_right2', 0.5, 0.5);
	setScrollFactor('speaker_right2', 1, 1);	
	addLuaSprite('speaker_right2', false);

	makeLuaSprite('crowd_front', 'camellia//Week2/frontcrowd', -950, 1000);
	setProperty('crowd_front.alpha', 0)
	scaleObject('crowd_front', 1.75, 1.75);	
	setScrollFactor('crowd_front', 1, 1);	
	addLuaSprite('crowd_front', true);
end
end


function onCreatePost()
	triggerEvent('Camera Follow Pos', 750,390)
end