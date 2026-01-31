function noteMiss(id, direction, noteType, isSustainNote)
	--Damage increase when miss
        --doTweenColor('healthTween', 'boyfriend', '800080', 0.2, 'quintInOut');
        --noteTweenY('fallTween' .. direction, direction + 4, getProperty('note' .. '.y')+ 10, 0.5, 'bounceOut');
    --end
--end

    -- Miss Effects
        if direction == 0 then
            
                doTweenColor('missTween', 'boyfriend', '000000', 0.1, 'quintInOut'); -- Turns BF Black
                noteTweenAngle('broke0', direction + 4, -30, 0.3, 'bounceOut');-- Makes notes falter

                playSound('missleft', 1);-- Plays miss sound
            
                
        elseif direction == 1 then
                                                                       -- if a regular miss

                doTweenColor('missTween', 'boyfriend', '000000', 0.1, 'quintInOut'); -- Turns BF Black
                noteTweenAngle('broke1', direction + 4, -30, 0.3, 'bounceOut');-- Makes notes falter
            
            playSound('missdown', 1);
            
        elseif direction == 2 then
            
                doTweenColor('missTween', 'boyfriend', '000000', 0.1, 'quintInOut'); -- Turns BF Black
                noteTweenAngle('broke2', direction + 4, -30, 0.3, 'bounceOut');-- Makes notes falter
            
            playSound('missup', 1);
            
        elseif direction == 3 then
            
                doTweenColor('missTween', 'boyfriend', '000000', 0.1, 'quintInOut'); -- Turns BF Black
                noteTweenAngle('broke3', direction + 4, -30, 0.3, 'bounceOut');-- Makes notes falter
            
            playSound('missright', 1);
            
        end
end

function onTweenCompleted(tag) 
    if tag == 'missTween' then
        doTweenColor('normalbf', 'boyfriend', 'FFFFFF', 1, 'quintOut');
    end

    if (tag == 'broke0') or (tag == 'glitch0') then
        noteTweenAngle('fix0', 4, 0, 1, 'quadInOut');
    end
    if (tag == 'broke1') or (tag == 'glitch1')then
        noteTweenAngle('fix1', 5, 0, 1, 'quadInOut');
    end
    if (tag == 'broke2') or (tag == 'glitch2') then
        noteTweenAngle('fix2', 6, 0, 1, 'quadInOut');
    end
    if (tag == 'broke3') or (tag == 'glitch3') then
        noteTweenAngle('fix3', 7, 0, 1, 'quadInOut');
    end

    


end