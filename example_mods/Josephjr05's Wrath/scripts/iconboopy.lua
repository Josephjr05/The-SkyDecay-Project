local turnvalue = 20
function onBeatHit()

turnvalue = 20
if curBeat % 2 == 0 then
turnvalue = -20
end



setProperty('iconP2.angle',-turnvalue)
setProperty('iconP1.angle',turnvalue)

doTweenAngle('iconTween1','iconP1',0,crochet/1000,'circOut')
doTweenAngle('iconTween2','iconP2',0,crochet/1000,'circOut')



end

function onCreatePost()

setObjectOrder('iconP1',getObjectOrder('iconP2'))

end