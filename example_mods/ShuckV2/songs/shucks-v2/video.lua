function onCreatePost()
    startVideo('cinematica', false, true, false, false)
    setObjectCamera('videoCutscene', 'hud')
    setObjectOrder('videoCutscene', 0)
end

function onStepHit()
    if curStep == 2381 then
        callMethod('videoCutscene.play')
    end
end 

function onPause()
  callMethod('videoCutscene.pause')
end

function onResume()
  callMethod('videoCutscene.resume')
end