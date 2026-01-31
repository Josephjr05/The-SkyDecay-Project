function onCreatePost()
    luaDebugMode = true
end
function togglePixelNotes()
    local texture = 'NOTE_assets'
    local strumTexture = 'NOTE_assets'
    if getPropertyFromClass('PlayState', 'isPixelStage') then
        setPropertyFromClass('PlayState', 'isPixelStage', false)
        for i = 0,getProperty('strumLineNotes.length')-1 do
            strumTexture = getPropertyFromGroup('strumLineNotes', i, 'texture')
            if strumTexture == nil then
                strumTexture = 'NOTE_assets'
            end
            runHaxeCode("game.strumLineNotes.members["..i.."].reloadNote('', '"..strumTexture.."', '')")
        end
        for i = 0,getProperty('notes.length')-1 do
            texture = getPropertyFromGroup('notes', i, 'texture')
            if getPropertyFromGroup('notes', i, 'noteType') == 'Hurt Note' then
                texture = 'HURTNOTE_assets'
            end
            if texture == nil then
                texture = 'NOTE_assets'
            end
            runHaxeCode('game.notes.members['..i..'].reloadNote(\'\', \''..texture..'\', \'\');')
            local isSustainNote = getPropertyFromGroup('notes', i, 'isSustainNote')
            local membersIndex = i
            local noteData = getPropertyFromGroup('notes', i, 'noteData')
            if isSustainNote then
                if string.find(getPropertyFromGroup('notes', membersIndex, 'animation.curAnim.name'), 'holdend') then
                    setPropertyFromGroup('notes', membersIndex, 'scale.y', 1)
                    updateHitboxFromGroup('notes', membersIndex)
                    setPropertyFromGroup('notes', membersIndex, 'offsetX', 36.2322580645161)
                else
                    setPropertyFromGroup('notes', membersIndex, 'scale.y', (stepCrochet/100*1.05)*(getProperty('songSpeed')))
                    setPropertyFromGroup('notes', membersIndex, 'offsetX', 36.2322580645161)
                end
                setPropertyFromGroup('notes', membersIndex, 'offsetX', 36.2322580645161)
            end
        end
    else
        setPropertyFromClass('PlayState', 'isPixelStage', true)
        for i = 0,getProperty('strumLineNotes.length')-1 do
            strumTexture = getPropertyFromGroup('strumLineNotes', i, 'texture')
            if strumTexture == nil then
                strumTexture = 'NOTE_assets'
            end
            runHaxeCode("game.strumLineNotes.members["..i.."].reloadNote('', '"..strumTexture.."', '')")
        end
        for i = 0,getProperty('notes.length')-1 do
            texture = getPropertyFromGroup('notes', i, 'texture')
            if getPropertyFromGroup('notes', i, 'noteType') == 'Hurt Note' then
                texture = 'HURTNOTE_assets'
            end
            if texture == nil then
                texture = 'NOTE_assets'
            end
            runHaxeCode('game.notes.members['..i..'].reloadNote(\'\', \''..texture..'\', \'\');')
            local isSustainNote = getPropertyFromGroup('notes', i, 'isSustainNote')
            local membersIndex = i
            local noteData = getPropertyFromGroup('notes', i, 'noteData')
            if isSustainNote then
                if string.find(getPropertyFromGroup('notes', membersIndex, 'animation.curAnim.name'), 'holdend') then
                    setPropertyFromGroup('notes', membersIndex, 'scale.y', getPropertyFromClass('PlayState', 'daPixelZoom'))
                    updateHitboxFromGroup('notes', membersIndex)
                    setPropertyFromGroup('notes', membersIndex, 'offsetX', 30)
                else
                    setPropertyFromGroup('notes', membersIndex, 'scale.y', (getPropertyFromGroup('notes', membersIndex, 'scale.y'))*(stepCrochet/100*1.05)*(getProperty('songSpeed'))*(1.19)*((6/getPropertyFromGroup('notes', membersIndex, 'height')))*(getPropertyFromClass('PlayState', 'daPixelZoom')))
                    setPropertyFromGroup('notes', membersIndex, 'offsetX', 30)
                end
                setPropertyFromGroup('notes', membersIndex, 'offsetX', 30)
            end
        end
    end
end
function onEvent(eventName, value1, value2)
    if eventName == 'Toggle Pixel Notes' then
        togglePixelNotes()
    end
end
function onSpawnNote(membersIndex, noteData, noteType, isSustainNote)
    local texture = getPropertyFromGroup('notes', membersIndex, 'texture')
    if getPropertyFromClass('PlayState', 'isPixelStage') then
        texture = getPropertyFromGroup('notes', membersIndex, 'texture')
        if getPropertyFromGroup('notes', membersIndex, 'noteType') == 'Hurt Note' then
            texture = 'HURTNOTE_assets'
        end
        if texture == nil then
            texture = 'NOTE_assets'
        end
        runHaxeCode('game.notes.members['..membersIndex..'].reloadNote(\'\', \''..texture..'\', \'\');')
        if isSustainNote then
            if string.find(getPropertyFromGroup('notes', membersIndex, 'animation.curAnim.name'), 'holdend') then
                setPropertyFromGroup('notes', membersIndex, 'scale.y', getPropertyFromClass('PlayState', 'daPixelZoom'))
                updateHitboxFromGroup('notes', membersIndex)
            else
                setPropertyFromGroup('notes', membersIndex, 'scale.y', (getPropertyFromGroup('notes', membersIndex, 'scale.y'))*(stepCrochet/100*1.05)*(getProperty('songSpeed'))*(1.19)*((6/getPropertyFromGroup('notes', membersIndex, 'height')))*(getPropertyFromClass('PlayState', 'daPixelZoom')))
            end
            setPropertyFromGroup('notes', membersIndex, 'offsetX', 30)
        end
    else
        texture = getPropertyFromGroup('notes', membersIndex, 'texture')
        if getPropertyFromGroup('notes', membersIndex, 'noteType') == 'Hurt Note' then
            texture = 'HURTNOTE_assets'
        end
        if texture == nil then
            texture = 'NOTE_assets'
        end
        runHaxeCode('game.notes.members['..membersIndex..'].reloadNote(\'\', \''..texture..'\', \'\');')
        if isSustainNote then
            if string.find(getPropertyFromGroup('notes', membersIndex, 'animation.curAnim.name'), 'holdend') then
                setPropertyFromGroup('notes', membersIndex, 'scale.y', 1)
                updateHitboxFromGroup('notes', membersIndex)
            else
                setPropertyFromGroup('notes', membersIndex, 'scale.y', (stepCrochet/100*1.05)*(getProperty('songSpeed')))
            end
            setPropertyFromGroup('notes', membersIndex, 'offsetX', 36.2322580645161)
        end 
    end
end