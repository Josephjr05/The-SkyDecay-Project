local val1 = 1
local val2 = 2.5
function onEvent(name,value1,value2)
	if name == 'bet' then
		setProperty('camHUD.y',(getProperty('camHUD.y')+10))
		setProperty('camGame.y',(getProperty('camGame.y')+10))
		setProperty('camHUD.angle',(getProperty('camHUD.angle')+val1))
		setProperty('camGame.angle',(getProperty('camGame.angle')-val2))
		doTweenY('camhudreturn','camHUD',0,0.1,'expo')
		doTweenY('camgamereturn','camGame',0,0.1,'expo')
		doTweenAngle('camhudreturn2','camHUD',0,0.1,'expo')
		doTweenAngle('camgamereturn2','camGame',0,0.1,'expo')
		triggerEvent('Screen Shake','0.1,0.002','0.1,0.001')
		val1 = -val1
		val2 = -val2
	end
end