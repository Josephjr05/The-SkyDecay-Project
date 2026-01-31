function onEvent(name, value1, value2)
	if name == 'Camera Zoom' then
		zoomamount = value1;
        setProperty('defaultCamZoom',zoomamount)
	end
end