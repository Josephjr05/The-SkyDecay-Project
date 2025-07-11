function onCreatePost()
    startVideo('TPV2Intro', false, true, false, false)
end

function onStepHit()
    if curStep == 1 then
        callMethod('videoCutscene.play')
	setProperty('videoCutscene.alpha', 0)
    end

    if curStep == 350 then -- change this to whatever step you want the video to appear
	startVideo('TPV2Intro', true, true, false, false)
        callMethod('videoCutscene.play')
        setProperty('videoCutscene.alpha', 1)
    end
end

function onPause()
    callMethod('videoCutscene.pause')
end

function onResume()
    callMethod('videoCutscene.resume')
end