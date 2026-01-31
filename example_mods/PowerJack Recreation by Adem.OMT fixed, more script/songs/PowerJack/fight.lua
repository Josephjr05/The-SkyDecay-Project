function onCreate()
    setObjectOrder('dadGroup', getObjectOrder('boyfriendGroup') - 1)
    allowFront = false
end

function onStepHit()
    if curStep == 1041 then
        allowFront = true
    elseif curStep == 1408 then
        allowFront = false
        setObjectOrder('dadGroup', getObjectOrder('boyfriendGroup') - 1)
        setObjectOrder('boyfriendGroup', getObjectOrder('dadGroup') + 1)
    end
end

function onEvent(name, value1, value2)
    if name == 'Play Animation' and allowFront then
        if (value1 == 'BLOCK' or value1 == 'DODGE') and value2 == 'BF' then
            setObjectOrder('dadGroup', getObjectOrder('boyfriendGroup') + 1)
        elseif (value1 == 'BLOCK' or value1 == 'DODGE') and value2 == 'Dad' then
            setObjectOrder('boyfriendGroup', getObjectOrder('dadGroup') + 1)
        end
    end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
    if not allowFront then return end

    if noteType == 'No Animation' then
        setObjectOrder('dadGroup', getObjectOrder('boyfriendGroup') - 1)
    elseif noteType ~= 'Alt Animation' then
        setObjectOrder('dadGroup', getObjectOrder('boyfriendGroup') + 1)
    end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
    if not allowFront then return end

    if noteType == 'No Animation' then
        setObjectOrder('boyfriendGroup', getObjectOrder('dadGroup') - 1)
    elseif noteType ~= 'Alt Animation' then
        setObjectOrder('boyfriendGroup', getObjectOrder('dadGroup') + 1)
    end
end

function onUpdate(elapsed)
    if allowFront then
        if getProperty('dad.animation.curAnim.finished') then
            setObjectOrder('dadGroup', getObjectOrder('boyfriendGroup') - 1)
        end
        if getProperty('boyfriend.animation.curAnim.finished') then
            setObjectOrder('boyfriendGroup', getObjectOrder('dadGroup') + 1)
        end
    end
end