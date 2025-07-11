function onCreatePost()
    startVideo('shuck', false, true, false, false)
end

function onStepHit()
    if curStep == 3189 then
        callMethod('videoCutscene.play')
    end
end 

function onPause()
  callMethod('videoCutscene.pause')
end

function onResume()
  callMethod('videoCutscene.resume')
end