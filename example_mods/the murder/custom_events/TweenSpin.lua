function onEvent(n,v1,v2)
	if n == "TweenSpin" then
		runTimer('tweenstop',0.35);
		-- bf notespin
		noteTweenAngle('A',4 , 360 , 0.25, quintOut)
		noteTweenAngle('B',5 , 360 , 0.25, quintOut)
		noteTweenAngle('C',6 , 360 , 0.25, quintOut)
		noteTweenAngle('D',7 , 360 , 0.25, quintOut)

		-- oppt notespin
		noteTweenAngle('E',0 , 360 , 0.25, quintOut)
		noteTweenAngle('F',1 , 360 , 0.25, quintOut)
		noteTweenAngle('G',2 , 360 , 0.25, quintOut)
		noteTweenAngle('H',3 , 360 , 0.25, quintOut)
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'tweenstop' then
		noteTweenAngle('A',4 , 0 , 0.01, linear)
		noteTweenAngle('B',5 , 0 , 0.01, linear)
		noteTweenAngle('C',6 , 0 , 0.01, linear)
		noteTweenAngle('D',7 , 0 , 0.01, linear)

		-- oppt notespin
		noteTweenAngle('E',0 , 0 , 0.01, linear)
		noteTweenAngle('F',1 , 0 , 0.01, linear)
		noteTweenAngle('G',2 , 0 , 0.01, linear)
		noteTweenAngle('H',3 , 0 , 0.01, linear)
    end
end
