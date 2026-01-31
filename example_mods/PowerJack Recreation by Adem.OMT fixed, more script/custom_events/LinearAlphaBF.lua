function onEvent(name, value1, value2)
	-- bf notesFade
	if name == 'LinearAlphaBF' then
	noteTweenAlpha('AF',4 , value2 , value1 + 0.01, 'linear');
	noteTweenAlpha('BF',5 , value2 , value1 + 0.01, 'linear');
	noteTweenAlpha('CF',6 , value2 , value1 + 0.01, 'linear');
	noteTweenAlpha('DF',7 , value2 , value1 + 0.01, 'linear');
	

	
end
end