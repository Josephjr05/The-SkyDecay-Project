function onCreatePost()
	makeLuaSprite('goddsmitanothersquare', nil, 0, 0)
	luaSpriteMakeGraphic('goddsmitanothersquare', 1, 1, '000000')
	setGraphicSize('goddsmitanothersquare', 3000,3000)
	setScrollFactor('goddsmitanothersquare', 0, 0);
	screenCenter('goddsmitanothersquare');
	addLuaSprite('goddsmitanothersquare', true)
	setProperty('goddsmitanothersquare.alpha', 1)
	setProperty('camHUD.alpha', 1)
	if shadersEnabled then 
		doTweenAlpha('dumbshid2','goddsmitanothersquare', 0 , 0.0001)
	end
end
function onCreate()
	setProperty('skipCountdown', true)
end

function onBeatHit()
	if not shadersEnabled then 
		if curBeat == 4 then 
			setProperty('goddsmitanothersquare.alpha', 0)
		elseif curBeat == 1532 then 
			doTweenAlpha('dumbshid2','goddsmitanothersquare', 1 , crochet*0.001*4)
		end
	end

end