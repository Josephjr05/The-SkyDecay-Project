local showDebugInfo = false

local RexDefaultFPS = nil
local FPS18Anims = {'attack', 'hey', 'taunt-alt', 'scared', 'hurt', 'dodge', 'dodgealt', 'shoot'}
local singAnims = {'singLEFT', 'singDOWN', 'singUP', 'singRIGHT', 'singLEFT-alt', 'singDOWN-alt', 'singUP-alt', 'singRIGHT-alt'}
local sustain = false
local isAltAnim = nil

function onCreate()
    if showDebugInfo then
        makeLuaText('debugInfoRex', '', 0, 600, 200)
        addLuaText('debugInfoRex')
        makeLuaText('debugInfoRex2', '', 0, 600, 180)
        addLuaText('debugInfoRex2')
    end
    RexDefaultFPS = getProperty('dad.animation.curAnim.frameRate')
end

function onCreatePost()
    --Gameover Stuff
    setPropertyFromClass('GameOverSubstate', 'characterName', 'RexDXPX')
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
    for sodir, soname in ipairs(singAnims) do
        if isSustainNote then
            if not isAltAnim then
                if direction == sodir -1 and getProperty('dad.animation.name') == soname then
                    sustain = true
                    setProperty('dad.animation.curAnim.frameRate', 4)
                end
            else
                if direction == sodir -5 and getProperty('dad.animation.name') == soname then
                    sustain = true
                    setProperty('dad.animation.curAnim.frameRate', 4)
                end
            end
        else
            sustain = false
            setProperty('dad.animation.curAnim.frameRate', RexDefaultFPS) -- Restore original frame rate
        end
    end
end

function onUpdatePost()
    for o, animas in ipairs(FPS18Anims) do
	    if getProperty('dad.animation.name') == animas then
	        setProperty('dad.animation.curAnim.frameRate', 18)
	    end
    end
    for dx, psinganimas in ipairs(singAnims) do
        if getProperty('dad.animation.name') == psinganimas and not sustain then
	        setProperty('dad.animation.curAnim.frameRate', RexDefaultFPS) -- Restore original frame rate
	    end
	end

    if showDebugInfo then
        screenCenter('debugInfoRex', 'x')
        screenCenter('debugInfoRex2', 'x')
        if sustain then
            setTextString('debugInfoRex', 'Rex FPS: '.. getProperty('dad.animation.curAnim.frameRate') ..'\nAnim: '.. getProperty('dad.animation.curAnim.name') .. '\nSustain: true')
        else
            setTextString('debugInfoRex', 'Rex FPS: '.. getProperty('dad.animation.curAnim.frameRate') ..'\nAnim: '.. getProperty('dad.animation.curAnim.name') .. '\nSustain: false')
        end
        if isAltAnim then
            setTextString('debugInfoRex2', 'AltAnim = true')
        else
            setTextString('debugInfoRex2', 'AltAnim = false')
        end
    end
    
    if stringEndsWith(getProperty('dad.animation.name'), '-alt') then
        isAltAnim = true
    else
        isAltAnim = false
    end
    
end

function onGameOverStart()
    if not playsAsBF() then
        characterPlayAnim('dad', 'firstDeath', true)
        setProperty('camFollow.x', getProperty('dad.x'))
        setProperty('camFollow.y', getProperty('dad.y'))
        setProperty('isCameraOnForcedPos', true)
        callMethod('camGame.snapToTarget', {''})
    end
end