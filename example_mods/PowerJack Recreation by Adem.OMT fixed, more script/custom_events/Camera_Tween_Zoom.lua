function Split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch('(.-)'..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function onEvent(name, value1, value2)
	if name == 'Camera_Tween_Zoom' then
		tarAndDir = Split(tostring(value1), ', ');
		doTweenZoom('ZoomEvent', 'camGame', tonumber(tarAndDir[1]), tonumber(tarAndDir[2]), tostring(value2));
		setProperty('defaultCamZoom', tonumber(tarAndDir[1]));
	end
end