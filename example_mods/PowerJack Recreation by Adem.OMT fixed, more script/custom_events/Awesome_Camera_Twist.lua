--event by Zeus404, credit me or you will be set on fire

local type = 0
local angle = 0

function onEvent(name, value1, value2)
	if name == 'Awesome_Camera_Twist' then
		type = value1
		angle = value2
	end
end

function onBeatHit()
	if type == '1' then
		if curBeat % 2 == 0 then
			setProperty('camGame.angle', -angle)
			setProperty('camHUD.angle', -angle)
			doTweenAngle('turn', 'camGame', 0, crochet / 1000, 'sineOut')
			doTweenAngle('turn2', 'camHUD', 0, crochet / 1000, 'sineOut')
		end
		if ( curBeat - 1 ) % 2 == 0 then
			setProperty('camGame.angle', angle)
			setProperty('camHUD.angle', angle)
			doTweenAngle('turn', 'camGame', 0, crochet / 1000, 'sineOut')
			doTweenAngle('turn2', 'camHUD', 0, crochet / 1000, 'sineOut')
		end
	end
	if type == '2' then
		if curBeat % 4 == 0 then
			setProperty('camGame.angle', -angle)
			setProperty('camHUD.angle', -angle)
			doTweenAngle('turn', 'camGame', 0, crochet / 1000, 'sineOut')
			doTweenAngle('turn2', 'camHUD', 0, crochet / 1000, 'sineOut')
		end
		if ( curBeat - 2 ) % 4 == 0 then
			setProperty('camGame.angle', angle)
			setProperty('camHUD.angle', angle)
			doTweenAngle('turn', 'camGame', 0, crochet / 1000, 'sineOut')
			doTweenAngle('turn2', 'camHUD', 0, crochet / 1000, 'sineOut')
		end
	end
	if type == '3' then
		if curBeat % 24 == 0 or ( curBeat - 6 ) % 24 == 0 or ( curBeat - 12 ) % 24 == 0 or ( curBeat - 18 ) % 24 == 0 then
			setProperty('camGame.angle', -angle)
			setProperty('camHUD.angle', -angle)
			doTweenAngle('turn', 'camGame', 0, crochet / 1000, 'sineOut')
			doTweenAngle('turn2', 'camHUD', 0, crochet / 1000, 'sineOut')
		end
		if ( curBeat - 3 ) % 24 == 0 or ( curBeat - 9 ) % 24 == 0 or ( curBeat - 15 ) % 24 == 0 or ( curBeat - 18 ) % 24 == 0 or ( curBeat - 21 ) % 24 == 0 then
			setProperty('camGame.angle', angle)
			setProperty('camHUD.angle', angle)
			doTweenAngle('turn', 'camGame', 0, crochet / 1000, 'sineOut')
			doTweenAngle('turn2', 'camHUD', 0, crochet / 1000, 'sineOut')
		end
	end
	if type == '4' then
		if curBeat % 8 == 0 then
			setProperty('camGame.angle', -angle)
			setProperty('camHUD.angle', -angle)
			doTweenAngle('turn', 'camGame', 0, crochet / 1000, 'sineOut')
			doTweenAngle('turn2', 'camHUD', 0, crochet / 1000, 'sineOut')
		end
		if ( curBeat - 4 ) % 8 == 0 then
			setProperty('camGame.angle', angle)
			setProperty('camHUD.angle', angle)
			doTweenAngle('turn', 'camGame', 0, crochet / 1000, 'sineOut')
			doTweenAngle('turn2', 'camHUD', 0, crochet / 1000, 'sineOut')
		end
	end
	if type == '5' then
		if curBeat % 4 == 0 then
			setProperty('camGame.angle', -angle)
			setProperty('camHUD.angle', -angle)
			doTweenAngle('turn', 'camGame', 0, crochet / 1000, 'sineOut')
			doTweenAngle('turn2', 'camHUD', 0, crochet / 1000, 'sineOut')
		end
		if ( curBeat - 1 ) % 4 == 0 or ( curBeat - 3 ) % 4 == 0 then
			setProperty('camGame.angle', angle)
			setProperty('camHUD.angle', angle)
			doTweenAngle('turn', 'camGame', 0, crochet / 1000, 'sineOut')
			doTweenAngle('turn2', 'camHUD', 0, crochet / 1000, 'sineOut')
		end
	end
	if type == '6' then
		if ( curBeat - 2 ) % 8 == 0 then
			setProperty('camGame.angle', -angle)
			setProperty('camHUD.angle', -angle)
			doTweenAngle('turn', 'camGame', 0, crochet / 1000, 'sineOut')
			doTweenAngle('turn2', 'camHUD', 0, crochet / 1000, 'sineOut')
		end
		if ( curBeat - 6 ) % 8 == 0 then
			setProperty('camGame.angle', angle)
			setProperty('camHUD.angle', angle)
			doTweenAngle('turn', 'camGame', 0, crochet / 1000, 'sineOut')
			doTweenAngle('turn2', 'camHUD', 0, crochet / 1000, 'sineOut')
		end
	end
	if type == '7' then
		if curBeat % 8 == 0 or ( curBeat - 5 ) % 8 == 0 then
			setProperty('camGame.angle', -angle)
			setProperty('camHUD.angle', -angle)
			doTweenAngle('turn', 'camGame', 0, crochet / 1000, 'sineOut')
			doTweenAngle('turn2', 'camHUD', 0, crochet / 1000, 'sineOut')
		end
		if ( curBeat - 2 ) % 8 == 0 or ( curBeat - 6 ) % 8 == 0 then
			setProperty('camGame.angle', angle)
			setProperty('camHUD.angle', angle)
			doTweenAngle('turn', 'camGame', 0, crochet / 1000, 'sineOut')
			doTweenAngle('turn2', 'camHUD', 0, crochet / 1000, 'sineOut')
		end
	end
	if type == '8' then
		if ( curBeat - 1 ) % 4 == 0 then
			setProperty('camGame.angle', -angle)
			setProperty('camHUD.angle', -angle)
			doTweenAngle('turn', 'camGame', 0, crochet / 1000, 'sineOut')
			doTweenAngle('turn2', 'camHUD', 0, crochet / 1000, 'sineOut')
		end
		if ( curBeat - 3 ) % 4 == 0 then
			setProperty('camGame.angle', angle)
			setProperty('camHUD.angle', angle)
			doTweenAngle('turn', 'camGame', 0, crochet / 1000, 'sineOut')
			doTweenAngle('turn2', 'camHUD', 0, crochet / 1000, 'sineOut')
		end
	end
end

function onStepHit()
	if type == '5' then
		if ( curStep - 10 ) % 16 == 0 then
			setProperty('camGame.angle', -angle)
			setProperty('camHUD.angle', -angle)
			doTweenAngle('turn', 'camGame', 0, crochet / 1000, 'sineOut')
			doTweenAngle('turn2', 'camHUD', 0, crochet / 1000, 'sineOut')
		end
	end
end