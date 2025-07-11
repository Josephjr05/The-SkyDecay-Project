function onEvent(name, value1, value2)
if name == 'LinearSpin' or name == 'TweenSpin' then
	-- whats the solution to jank? even more jank!
	noteTweenAngle('AJ',4 , 0 , 0.01, linear);
	noteTweenAngle('BJ',5 , 0 , 0.01, linear);
	noteTweenAngle('CJ',6 , 0 , 0.01, linear);
	noteTweenAngle('DJ',7 , 0 , 0.01, linear);
	
	noteTweenAngle('EJ',0 , 0 , 0.01, linear);
	noteTweenAngle('FJ',1 , 0 , 0.01, linear);
	noteTweenAngle('GJ',2 , 0 , 0.01, linear);
	noteTweenAngle('HJ',3 , 0 , 0.01, linear);

	
	-- bf notespin

	noteTweenAngle('A',4 , value2 , value1, linear);
	noteTweenAngle('B',5 , value2 , value1, linear);
	noteTweenAngle('C',6 , value2 , value1, linear);
	noteTweenAngle('D',7 , value2 , value1, linear);
	
	-- oppt notespin
	noteTweenAngle('E',0 , value2 , value1, linear);
	noteTweenAngle('F',1 , value2 , value1, linear);
	noteTweenAngle('G',2 , value2 , value1, linear);
	noteTweenAngle('H',3 , value2 , value1, linear);
	
	
	
end
end
