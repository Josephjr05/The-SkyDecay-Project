local hudBopIntensity = 0;
local bopShit = false

--this is basically the shygee gamebreaker edit event its so crazy

function onEvent(eventName, value1, value2)
    if eventName == 'HUD Bounce' then
	
        if value1 == '' then
            bopShit = false
		else
            bopShit = true
        end
		
		if value2 == '' then
			hudBopIntensity = 1
		else
			hudBopIntensity = tonumber(value2)
		end
		
    end
end

function onBeatHit()
	if bopShit == true then

		if curBeat % 2 == 0 then
			setProperty('camHUD.angle', 2*hudBopIntensity)
			doTweenAngle('hudTween', 'camHUD', 0, 0.8, 'backOut')
			triggerEvent('Add Camera Zoom', '0', '0.03' * hudBopIntensity)
		end
		
		if curBeat % 2 == 1 then
			setProperty('camHUD.angle', 2*-hudBopIntensity)
			doTweenAngle('hudTween', 'camHUD', 0, 0.8, 'backOut')
            triggerEvent('Add Camera Zoom', '0', '0.01' * hudBopIntensity)
		end
		
	end
end

