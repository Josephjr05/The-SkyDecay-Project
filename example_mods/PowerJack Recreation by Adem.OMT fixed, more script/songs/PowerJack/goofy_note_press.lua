squishMultiplier = 1
squishFramesPerSecond = 36 -- 36 is default
defy = 0.7
dirs = {
    'left',
    'down',
    'up',
    'right'
}
function goodNoteHit(id, direction, noteType, isSustainNote)
    cancelTimer('resetNoteP1' .. direction+4)
    cancelTimer('resetNoteP2' .. direction+4)
    cancelTimer('resetNoteP3' .. direction+4)
    cancelTimer('resetNoteP4' .. direction+4)
    cancelTimer('resetNoteP5' .. direction+4)
    setPropertyFromGroup('strumLineNotes', direction+4, 'scale.x', defy*1.1)
    setPropertyFromGroup('strumLineNotes', direction+4, 'scale.y', defy*0.9)
    runTimer('resetNoteP1' .. direction+4, squishDuration)
end
function opponentNoteHit(id, direction, noteType, isSustainNote)
    cancelTimer('resetNoteP1' .. direction)
    cancelTimer('resetNoteP2' .. direction)
    cancelTimer('resetNoteP3' .. direction)
    cancelTimer('resetNoteP4' .. direction)
    cancelTimer('resetNoteP5' .. direction)
    setPropertyFromGroup('strumLineNotes', direction, 'scale.x', defy*1.1)
    setPropertyFromGroup('strumLineNotes', direction, 'scale.y', defy*0.9)
    runTimer('resetNoteP1' .. direction, squishDuration)
end

function onTimerCompleted(tag)
    for i = 0,7 do
        if tag == 'resetNoteP1' .. i then
            setPropertyFromGroup('strumLineNotes', i, 'scale.x', (defy*1.2)*(squishMultiplier))
            setPropertyFromGroup('strumLineNotes', i, 'scale.y', (defy*0.8)/(squishMultiplier))
            runTimer('resetNoteP2' .. i, squishDuration)
        end
        if tag == 'resetNoteP2' .. i then
            setPropertyFromGroup('strumLineNotes', i, 'scale.x', (defy*1.05)*squishMultiplier)
            setPropertyFromGroup('strumLineNotes', i, 'scale.y', (defy*0.95)/squishMultiplier)
            runTimer('resetNoteP3' .. i, squishDuration)
        end
        if tag == 'resetNoteP3' .. i then
            setPropertyFromGroup('strumLineNotes', i, 'scale.x', defy)
            setPropertyFromGroup('strumLineNotes', i, 'scale.y', defy)
            runTimer('resetNoteP4' .. i, squishDuration)
        end
        if tag == 'resetNoteP4' .. i then
            setPropertyFromGroup('strumLineNotes', i, 'scale.x', (defy*0.95)/squishMultiplier)
            setPropertyFromGroup('strumLineNotes', i, 'scale.y', (defy*1.05)*squishMultiplier)
            runTimer('resetNoteP5' .. i, squishDuration)
        end
        if tag == 'resetNoteP5' .. i then
            setPropertyFromGroup('strumLineNotes', i, 'scale.x', defy)
            setPropertyFromGroup('strumLineNotes', i, 'scale.y', defy)
        end
    end
end
function onUpdate()
    
    squishDuration = squishFramesPerSecond*0.001  
    for i = 1,#dirs do
        if keyJustPressed(dirs[i]) then
            if getPropertyFromGroup('strumLineNotes', i+3, 'animation.name') == 'pressed' then
                cancelTimer('resetNoteP1' .. i+3)
                cancelTimer('resetNoteP2' .. i+3)
                cancelTimer('resetNoteP3' .. i+3)
                cancelTimer('resetNoteP4' .. i+3)
                cancelTimer('resetNoteP5' .. i+3)
                setPropertyFromGroup('strumLineNotes', i+3, 'scale.x', defy*1.1)
                setPropertyFromGroup('strumLineNotes', i+3, 'scale.y', defy*0.9)
                runTimer('resetNoteP1' .. i+3, squishDuration)
            end
        end
    end
end
function onUpdatePost()
    setProperty('camHUD.scale.x', 1.7)
end