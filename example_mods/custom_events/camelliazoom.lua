
local zooming = false
luaDebugMode = true

function onEvent(name, value1, value2)

	if value2 == '' then
		value2 = 0.5
	end
	if getPropertyFromClass('ClientPrefs', 'camZooms', true) then
	if name == 'camelliazoom' and value1 == '1' and not lowQuality then --furthest out
		zooming = true
		doTweenY('crowdGoingIn', 'crowd_front', 500, value2, 'sineIn')
		doTweenAlpha('crowd_front', 'crowd_front', 1, value2, 'sineIn')
		doTweenZoom('gameCameraOUT','camGame', 0.41, value2,'sineIn')
		doTweenZoom('hudCameraOUT','camHUD', 0.8, value2,'sineIn')

	elseif name == 'camelliazoom' and value1 == '2' and not lowQuality then --base zoom
		doTweenAlpha('crowd_front', 'crowd_front', 0, value2, 'sineOut')
		doTweenY('crowdGoingOut', 'crowd_front', 1000, value2, 'sineOut')
		doTweenZoom('gameCameraIN','camGame', 0.59, value2,'sineOut')
		doTweenZoom('hudCameraIN','camHUD', 1, value2,'sineOut')
		zooming = false

	elseif name == 'camelliazoom' and value1 == '3' and not lowQuality then --middle
		zooming = true
		doTweenY('crowdGoingIn', 'crowd_front', 500, value2, 'sineIn')
		doTweenAlpha('crowd_front', 'crowd_front', 1, value2, 'sineIn')
		doTweenZoom('gameCameraOUT','camGame', 0.47, value2,'sineIn')
		doTweenZoom('hudCameraOUTMID','camHUD', 0.9, value2,'sineIn')
	end
end
end

function onBeatHit()
	if curBeat % 2 == 0 and zooming then
		--Front Crowd bopping
		doTweenX('front1', 'crowd_front.scale', 1.85, 0.01, 'linear')
		doTweenX('front2', 'crowd_front.scale', 1.75, 0.5, 'quartOut')
		doTweenY('front3', 'crowd_front.scale', 1.85, 0.01, 'linear')
		doTweenY('front4', 'crowd_front.scale', 1.75, 0.5, 'quartOut')
		--Back Crowd Bopping
		doTweenX('back1', 'crowd_back.scale', 1.85, 0.01, 'linear')
		doTweenX('back2', 'crowd_back.scale', 1.75, 0.5, 'quartOut')
		doTweenY('back3', 'crowd_back.scale', 1.85, 0.01, 'linear')
		doTweenY('back4', 'crowd_back.scale', 1.75, 0.5, 'quartOut')
	end
end

function onTweenCompleted(tag)
	--When the tweens finish, this keeps them where they are.
	if tag == 'gameCameraOUT' then
	 	setProperty("defaultCamZoom",getProperty('camGame.zoom')) 
	elseif tag == 'gameCameraIN' then
	 	setProperty("defaultCamZoom",getProperty('camGame.zoom')) 
	elseif tag == 'hudCameraOUT' and zooming == true then
		doTweenZoom('hudCameraOUT','camHUD', 0.8, 0.00001,'sineIn')
	elseif tag == 'hudCameraOUTMID' and zooming == true then
		doTweenZoom('hudCameraOUTMID','camHUD', 0.9, 0.00001,'sineIn')
	end
end