--use this variable to define in which curstep the script starts

StartOn = 512

--use this variable to define which curstep the script ends at

EndOn = 1024

--                                END                               --




--Don't touch anything here (unless you know what you're doing)
enabled = true

function onStepHit()
	if curStep == StartOn then
	
		doTweenAngle('turn', 'camHUD', -2.5, crochet/300, 'sineInOut')
		
	end
	
	if curStep == EndOn then
		enabled = false
	end
end

function onTweenCompleted(t)
	if enabled then
		if t == 'turn' then
			doTweenAngle('turn1', 'camHUD', 2.5, crochet/300, 'sineInOut')
		end
		if t == 'turn1' then
			doTweenAngle('turn', 'camHUD', -2.5, crochet/300, 'sineInOut')
		end
	else
		doTweenAngle('turn4', 'camHUD', 0, crochet/300, 'sineInOut')
	end
end