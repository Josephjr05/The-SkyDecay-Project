local stopEnd = true
function onEndSong()
	if stopEnd then
        setProperty('camGame.visible', false)
        startVideo("TPWG_endcutscene")
		stopEnd = false;
		return Function_Stop;        
	end    
	return Function_Continue;
end