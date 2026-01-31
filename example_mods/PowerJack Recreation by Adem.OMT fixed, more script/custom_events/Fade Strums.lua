-- Event notes hooks
function onEvent(name, value1, value2)
	if name == "Fade Strums" then
		noteTweenAlpha('oppAlpha1', 0, value2, value1, 'quadInOut');
		noteTweenAlpha('oppAlpha2', 1, value2, value1, 'quadInOut');
		noteTweenAlpha('oppAlpha3', 2, value2, value1, 'quadInOut');
		noteTweenAlpha('oppAlpha4', 3, value2, value1, 'quadInOut');
		noteTweenAlpha('plrAlpha1', 4, value2, value1, 'quadInOut');
		noteTweenAlpha('plrAlpha2', 5, value2, value1, 'quadInOut');
		noteTweenAlpha('plrAlpha3', 6, value2, value1, 'quadInOut');
		noteTweenAlpha('plrAlpha4', 7, value2, value1, 'quadInOut');
	end
end