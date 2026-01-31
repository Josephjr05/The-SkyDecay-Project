function onEvent(eventName, value1, value2)
    if eventName=='Cam lock' then
        if value1=='in' then
            if value2 == 'cu' then
                setProperty('camFollowPos.x',1060)
                setProperty('camFollowPos.y',575)
                setGlobalFromScript('data/'..songName..'/cameraMovement','ManualPos',{760, 275})
            end
            setGlobalFromScript('data/'..songName..'/cameraMovement','ForceCamPos',true)
            runTimer('freeze', 0.0001)
            followchars = false
            Intensity = 0
        elseif value1 == 'backNormal' then
            setGlobalFromScript('data/'..songName..'/cameraMovement','ForceCamPos',false)
            followchars = true
            setProperty('cameraSpeed', 9999);
            runTimer('backNormal', 0.01)
            Intensity = 15;
        elseif value1 == 'backNormal-pixel' then
            setGlobalFromScript('data/'..songName..'/cameraMovement','ForceCamPos',false)
            followchars = true
            setProperty('cameraSpeed', 9999);
            runTimer('backNormal-pixel', 0.01)
            Intensity = 15;
        end
    end
end

function onTimerCompleted(tag)
    if tag == 'freeze' then
        setProperty('cameraSpeed', 0.0001);
    end
    if tag == 'backNormal' then
        setProperty('cameraSpeed', 1);
    end
    if tag == 'backNormal-pixel' then
        setProperty('cameraSpeed', 1.5);
    end
end