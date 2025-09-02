function onCreatePost()
    startVideo('dx', false, true, false, false)
end

function onStepHit()
    if curStep == 2907 then
        callMethod('videoCutscene.play')
    end
end 

function onPause()
  callMethod('videoCutscene.pause')
end

function onResume()
  callMethod('videoCutscene.resume')
end