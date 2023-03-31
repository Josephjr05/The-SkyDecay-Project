function onCreate()
	if not lowQuality then 
	makeLuaSprite('bg', 'camellia/Week1/BG_CITY', -750, -450);
	scaleObject('bg', 1.55, 1.55);	
	setScrollFactor('bg', .5, .5);	
	addLuaSprite('bg', false);

	makeLuaSprite('wall', 'camellia/Week1/BG_WALL', -750, -450);
	scaleObject('wall', 1.55, 1.55);	
	setScrollFactor('wall', 1, 1);	
	addLuaSprite('wall', false);
	doTweenColor('sff2','wall','fe00af',0.01, 'quadInOut');
	

	makeLuaSprite('stage', 'camellia/Week1/FG_Floor', -750, -450);
	scaleObject('stage', 1.55, 1.55);	
	setScrollFactor('stage', 0.9, 0.9);	
	addLuaSprite('stage', false);
    doTweenColor('sff','stage','ac35b3',0.01, 'quadInOut');
	end
end

function onCreatePost()
	triggerEvent('Camera Follow Pos', 750,390)
end