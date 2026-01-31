function onEvent(name,value1,value2)

    if name == "Set Cam Zoom (linear)" then
        
    if value2 == '' then
      	setProperty("defaultCamZoom",value1)
	else
        doTweenZoom('camz','camGame',tonumber(value1),tonumber(value2),'linear')
	end
            
    end


end

function onTweenCompleted(name)

	if name == 'camz' then
    	setProperty("defaultCamZoom",getProperty('camGame.zoom'))

	end
end