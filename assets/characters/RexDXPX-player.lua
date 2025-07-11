local showDebugInfo = false

local RexPlayerDefaultFPS = nil
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
    RexPlayerDefaultFPS = getProperty('boyfriend.animation.curAnim.frameRate')
end
function onCreatePost()
    --Gameover Stuff
    setPropertyFromClass('substates.GameOverSubstate', 'characterName', 'RexDXPX-player')
end

function goodNoteHit(id, direction, noteType, isSustainNote)
    for sdir, sname in ipairs(singAnims) do
        if isSustainNote then
            if not isAltAnim then
                if direction == sdir -1 and getProperty('boyfriend.animation.name') == sname then
                    sustain = true
                    setProperty('boyfriend.animation.curAnim.frameRate', 4)
                end
            else
                if direction == sdir -5 and getProperty('boyfriend.animation.name') == sname then
                    sustain = true
                    setProperty('boyfriend.animation.curAnim.frameRate', 4)
                end
            end
        else
            sustain = false
            setProperty('boyfriend.animation.curAnim.frameRate', RexPlayerDefaultFPS) -- Restore original frame rate
        end
    end
end

function onUpdatePost()
    for i, anims in ipairs(FPS18Anims) do
	    if getProperty('boyfriend.animation.name') == anims then
	        setProperty('boyfriend.animation.curAnim.frameRate', 18)
        end
    end
    for xdx, singanimas in ipairs(singAnims) do
        if getProperty('boyfriend.animation.name') == singanimas and not sustain then
            setProperty('boyfriend.animation.curAnim.frameRate', RexPlayerDefaultFPS) -- Restore original frame rate
        end
    end

    if showDebugInfo then
        screenCenter('debugInfoRex', 'x')
        screenCenter('debugInfoRex2', 'x')
        if sustain then
            setTextString('debugInfoRex', 'Rex FPS: '.. getProperty('boyfriend.animation.curAnim.frameRate') ..'\nAnim: '.. getProperty('boyfriend.animation.curAnim.name') .. '\nSustain: true')
        else
            setTextString('debugInfoRex', 'Rex FPS: '.. getProperty('boyfriend.animation.curAnim.frameRate') ..'\nAnim: '.. getProperty('boyfriend.animation.curAnim.name') .. '\nSustain: false')
        end
        if isAltAnim then
            setTextString('debugInfoRex2', 'AltAnim = true')
        else
            setTextString('debugInfoRex2', 'AltAnim = false')
        end
    end
    
    if stringEndsWith(getProperty('boyfriend.animation.name'), '-alt') then
        isAltAnim = true
    else
        isAltAnim = false
    end
    
end

function onGameOverStart()
    if playsAsBF() then
        characterPlayAnim('boyfriend', 'firstDeath', true)
        cameraSetTarget('boyfriend')
    end
end