function onCreatePost()
   makeLuaSprite('ready', 'ready', 100, 200)
   setObjectCamera('ready', 'hud')
   scaleObject('ready', 0.7, 0.7)
	setProperty('ready.angle',-10)


   makeLuaSprite('set', 'set', 700, 200)
   setObjectCamera('set', 'hud')
   scaleObject('set', 0.7, 0.7)
	setProperty('set.angle',10)


   makeLuaSprite('go', 'go', 215, 0)
   setObjectCamera('go', 'hud')
   scaleObject('go', 1.7, 1.7)

end



function onCountdownTick(counter)
   if counter == 1 then 
      addLuaSprite('ready', false)
      setProperty('countdownSet.visible', false)
      doTweenX('ready1','ready.scale', 0.8, 0.5,'elasticOut')
      doTweenY('ready2','ready.scale', 0.8, 0.5,'elasticOut')
      setProperty('countdownReady.visible', false)
   elseif counter == 2 then 
      addLuaSprite('set', false)
      setProperty('countdownSet.visible', false)
      doTweenX('set1','set.scale', 0.8, 0.5,'elasticOut')
      doTweenY('set2','set.scale', 0.8, 0.5,'elasticOut')
   elseif counter == 3 then -- Go!
      cancelTween('set1')
      cancelTween('set2')
      cancelTween('ready1')
      cancelTween('ready2')
      playAnim('gf', 'cheer', true)
      setProperty('gf.specialAnim', true)
      setProperty('countdownGo.visible', false)

      addLuaSprite('go', true)
      setProperty('countdownSet.visible', false)
      doTweenX('go1','go.scale', 2, 0.5,'elasticOut')
      doTweenY('go2','go.scale', 2, 0.5,'elasticOut')

      doTweenX('ready3', 'ready', 140, 0.3, 'elasticOut')
		doTweenY('ready4', 'ready', 100, 0.3, 'elasticOut')
      doTweenX('ready5','ready.scale', 0.3, 0.1,'linear')
      doTweenY('ready6','ready.scale', 0.3, 0.1,'linear')
      doTweenAngle('ready7','ready', -30, 0.5,'elasticOut')

      
      doTweenX('set3', 'set', 690, 0.3, 'elasticOut')
		doTweenY('set4', 'set', 470, 0.3, 'elasticOut')
      doTweenX('set5','set.scale', 0.3, 0.1,'linear')
      doTweenY('set6','set.scale', 0.3, 0.1,'linear')
      doTweenAngle('set7','set', -30, 0.5,'elasticOut')
      runTimer('startfinish',0.6)
   end
 end

 function onTimerCompleted(tag)
   if tag == 'startfinish' then
		doTweenAlpha('goend', 'go', 0, 0.2, 'linear')
		doTweenAlpha('setend', 'set', 0, 0.2, 'linear')
		doTweenAlpha('readyend', 'ready', 0, 0.2, 'linear')
   end
end