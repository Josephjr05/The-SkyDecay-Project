local left = 'singLEFT'
local down = 'singDOWN'
local up = 'singUP'
local right = 'singRIGHT'

function onUpdate()
    function onEvent(name, v1, v2)
        if name == 'alt-sing Only' then
            if v1 == 'on' then
                left = 'singLEFT-alt'
                down = 'singDOWN-alt'
                up = 'singUP-alt'
                right = 'singRIGHT-alt'
            elseif v1 == 'off' then
                left = 'singLEFT'
                down = 'singDOWN'
                up = 'singUP'
                right = 'singRIGHT'
            end
        end
    end
function goodNoteHit(id, noteData, noteType, isSustainNote)
    if not noteType == 'Alt Animation' then
    if noteData == 0 then
        triggerEvent('Play Animation', left, 'BF')
    elseif noteData == 1 then
        triggerEvent('Play Animation', down, 'BF')
    elseif noteData == 2 then
        triggerEvent('Play Animation', up, 'BF')
    elseif noteData == 3 then
        triggerEvent('Play Animation', right, 'BF')
    end
    end
end
end