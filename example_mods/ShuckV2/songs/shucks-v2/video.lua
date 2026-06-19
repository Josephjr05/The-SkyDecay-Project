-- Mid-song cutscene. Intro door video is in Josephscoolscript.lua.
-- startVideo() always destroys and re-creates videoCutscene, then add() puts it at the
-- END of the display list. setObjectOrder must run AFTER startVideo, and setObjectCamera
-- must run after startVideo too (new VideoSprite defaults to camOther, the topmost camera).

local cinematicPlaying = false

function placeCinematicBehindHud()
    -- camGame is drawn before camHUD, so notes/health/strums always stay on top.
    setObjectCamera('videoCutscene', 'hud')
    setObjectOrder('videoCutscene', getObjectOrder('uiGroup') - 1)
end

function onStepHit()
    if curStep == 2381 then
        startVideo('cinematica', false, true, false, false)
        placeCinematicBehindHud()
        cinematicPlaying = true
        callMethod('videoCutscene.play')
    end
end

-- startVideo can finish loading on the next frame; re-apply layer once if needed
function onUpdatePost()
    if cinematicPlaying and getProperty('videoCutscene.alpha') > 0 then
        if getObjectOrder('videoCutscene') > getObjectOrder('uiGroup') then
            placeCinematicBehindHud()
        end
    end
end

function onPause()
    callMethod('videoCutscene.pause')
end

function onResume()
    callMethod('videoCutscene.resume')
end
