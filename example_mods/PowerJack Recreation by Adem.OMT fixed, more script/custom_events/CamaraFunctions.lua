function mysplit (inputstr, sep)
    if sep == nil then
        sep = "%s";
    end
    local t={};
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str);
    end
    return t;
end

function onEvent(name, value1, value2)
local Val = mysplit(value2, ",");
if name == 'CamaraFunctions' then
if value1 == 'flash' then
cameraFlash(Val[1], '000000', Val[2])
end
if value1 == 'shake' then
cameraShake(Val[1], Val[2], Val[3])
end
if value1 == 'fade' then
doTweenAlpha('fade', Val[1], Val[2], Val[3], 'linear')
end
if value1 == 'zoom' then
if Val[2] == '' then
setProperty("defaultCamZoom", Val[1])
else
doTweenZoom('Zoom','camGame', Val[1], Val[2], 'linear')
end
end
if value1 == 'target' then
if value2 == 'bf' then 
cameraSetTarget('boyfriend')		
setProperty('isCameraOnForcedPos',true)
end
if value2 == 'dad' then
cameraSetTarget('dad')		
setProperty('isCameraOnForcedPos',true)
end
if value2 == 'gf' then
cameraSetTarget('gf')		
setProperty('isCameraOnForcedPos',true)
end
if value2 == 'off' then 
setProperty('isCameraOnForcedPos',false)
end
end
end
end

function onTweenCompleted(name)
if name == 'Zoom' then
setProperty("defaultCamZoom", getProperty('camGame.zoom')) 
end
end