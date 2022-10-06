local turnvalue = 20

function onBeatHit()
	
	scaleObject('iconP1', 1.2, 1.2)
	scaleObject('iconP2', 1.2, 1.2)
	
    setProperty('iconP2.angle',-turnvalue)
    setProperty('iconP1.angle',-turnvalue)

    if curBeat % 2 == 0 then

       setProperty('iconP2.angle',turnvalue)
       setProperty('iconP1.angle',turnvalue)
       
   end
   
   doTweenAngle('iconauohsdohjas5', 'iconP2', 0, 0.2, 'Linear')
   doTweenAngle('iconauohsdohjas6', 'iconP1', 0, 0.2, 'Linear')
 -- Timers 
   
   runTimer('iconBeat', 1)
 
end

function onTimerCompleted(tag, loops, loopsLeft)

    loop()

       if tag == 'iconBeat' then

    doTweenX('iconauohsdohjas', 'iconP1.scale', 1, crochet/1000, 'Linear')
	doTweenY('iconauohsdohjas2', 'iconP1.scale', 1, crochet/1000, 'Linear')
	
	doTweenX('iconauohsdohjas3', 'iconP2.scale', 1, crochet/1000, 'Linear')
	doTweenY('iconauohsdohjas4', 'iconP2.scale', 1, crochet/1000, 'Linear')
   
   end
   
end