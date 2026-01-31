function Split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch('(.-)'..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function onEvent(name, value1, value2)
	if name == 'Camera_Tween_Rotate' then
		tarAndDir = Split(tostring(value1), ', ');
		doTweenAngle('RotateEvent', 'camGame', tonumber(tarAndDir[1]), tonumber(tarAndDir[2]), tostring(value2));
	end
end