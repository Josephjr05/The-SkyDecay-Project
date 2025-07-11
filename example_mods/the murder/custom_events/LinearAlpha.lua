function onEvent(name, value1, value2)
	-- bf notesFade
	if name == 'LinearAlpha' then

	-- oppt notefade
	for i = 0, 7 do 
	noteTweenAlpha('SSSF' .. i,i , value2 , value1 + 1, 'linear');
	
	
	end
end