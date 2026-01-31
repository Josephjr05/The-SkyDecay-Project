
local startCheck = false
function onStartCountdown()
  if not startCheck then
  runTimer('startVid', 0.1)
  return Function_Stop;
  end
end
function onTimerCompleted(tag)
  if tag == 'startVid' then
    startCheck = true
    startVideo('2hotIntro',false)
  end
end
function onCreate()
  setProperty('skipCountdown', true)
  makeLuaSprite('IntroVoid', '', -1000, -1000)
	makeGraphic('IntroVoid', 1, 1, '000202')
	scaleObject('IntroVoid', screenWidth+10000, screenHeight+10000)
  addLuaSprite('IntroVoid', true);
  setObjectCamera('IntroVoid', 'other')
end
function onStepHit()
  if curStep == 1 then
    doTweenAlpha('IntroVoid', 'IntroVoid', 0, 1.2, 'linear')
    callMethod('startVideo', {'2hotBFCut1', true, false, false, false})
    callMethod('startVideo', {'2hotBFCut2', true, false, false, false})
  end
end
function onTweenCompleted(tag)
  if tag == 'IntroVoid' then
removeLuaSprite('IntroVoid',true)
  end
end