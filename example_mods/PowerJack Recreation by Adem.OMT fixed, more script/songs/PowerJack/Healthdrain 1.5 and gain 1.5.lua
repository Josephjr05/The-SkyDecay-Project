local basePlayerGain = 0.023
local baseOpponentDrain = 0.047
local playerGain = basePlayerGain * 1.5
local opponentDrain = baseOpponentDrain * 1.5
local minDrainHealth = 0.1

function onUpdate()
    if getProperty('health') <= 0 then
        setProperty('health', 0)
        setProperty('boyfriend.stunned', true)
        triggerEvent('Game Over', '', '')
    end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
    local cur = getProperty('health')
    if cur < 2 then
        setProperty('health', math.min(2, cur + playerGain))
    end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
    local cur = getProperty('health')
    if cur > 0 then
        setProperty('health', math.max(minDrainHealth, cur - opponentDrain))
    end
end

function noteMiss(id, direction, noteType, isSustainNote)
    local missPenalty = 0.05 * 1.5
    local cur = getProperty('health')
    setProperty('health', math.max(0, cur - missPenalty))
end

-- made by Fatir