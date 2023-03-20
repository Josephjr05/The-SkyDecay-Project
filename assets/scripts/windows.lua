function onCreate()

makeLuaSprite('Window', 'W', 100, 0)
setObjectCamera('Window', 'other')
addLuaSprite('Window', true)
setProperty("Window.scale.x", 0.8);
setProperty("Window.scale.y", 0.8);

makeLuaSprite('Window2', 'W', 700, 0)
setObjectCamera('Window2', 'other')
addLuaSprite('Window2', true)
setProperty("Window2.scale.x", 0.8);
setProperty("Window2.scale.y", 0.8);

makeLuaSprite('Window3', 'W', 300, 720)
setObjectCamera('Window3', 'other')
addLuaSprite('Window3', true)
setProperty("Window3.scale.x", 0.8);
setProperty("Window3.scale.y", 0.8);

makeLuaSprite('Window4', 'W', 500, 720)
setObjectCamera('Window4', 'other')
addLuaSprite('Window4', true)
setProperty("Window4.scale.x", 0.8);
setProperty("Window4.scale.y", 0.8);

makeLuaSprite('Window5', 'W', 0, 0)
setObjectCamera('Window5', 'other')
addLuaSprite('Window5', true)
setProperty("Window5.scale.x", 0.8);
setProperty("Window5.scale.y", 0.8);

makeLuaSprite('Window6', 'W', 1280, 0)
setObjectCamera('Window6', 'other')
addLuaSprite('Window6', true)
setProperty("Window6.scale.x", 0.8);
setProperty("Window6.scale.y", 0.8);

runTimer('E', 0.5)
runTimer('EE', 0.5)
runTimer('EEE', 0.5)
runTimer('EEEE', 0.5)
runTimer('EEEEE', 0.5)
runTimer('EEEEEE', 0.5)
end
function onTimerCompleted(t,l,ll)
if t == 'E' then


		setProperty('Window.y', -720)
        doTweenY('Window','Window', 720, 1.5,'lineal')
                runTimer('E',1.5)
end
if t == 'EE' then


		setProperty('Window2.y', -720)
        doTweenY('Window2','Window2', 720, 1.5,'lineal')
                runTimer('EE',2)
end
if t == 'EEE' then


		setProperty('Window3.y', 720)
        doTweenY('Window3','Window3', -720, 1.5,'lineal')
                runTimer('EEE',2.5)
end
if t == 'EEEE' then


		setProperty('Window4.y', 720)
        doTweenY('Window4','Window4', -720, 1.5,'lineal')
                runTimer('EEEE',3)
end
if t == 'EEEEE' then


		setProperty('Window5.x', -300)
        doTweenX('Window5','Window5', 1280, 2,'lineal')
                runTimer('EEEEE',2)
end
if t == 'EEEEEE' then


		setProperty('Window6.x', 1280)
        doTweenX('Window6','Window6', -300, 2,'lineal')
                runTimer('EEEEEE',2.5)
end
end
function onStartCountdown(elapsed)

	doTweenX('turn', 'Window', 150, crochet/900, 'sineInOut')
    doTweenX('turn2', 'Window2', 800, crochet/1300, 'sineInOut')
    doTweenX('turn4', 'Window3', 400, crochet/1300, 'sineInOut')
    doTweenX('turn6', 'Window4', 800, crochet/1300, 'sineInOut')
    doTweenY('turn8', 'Window5', 0, crochet/900, 'sineInOut')
    doTweenY('turn10', 'Window6', 650, crochet/900, 'sineInOut')

end

function onTweenCompleted(t)
	if t == 'turn' then
		doTweenX('turn1', 'Window', 0, crochet/900, 'sineInOut')
        doTweenX('turn2', 'Window2', 950, crochet/1300, 'sineInOut')
        doTweenX('turn4', 'Window3', 200, crochet/1300, 'sineInOut')
        doTweenX('turn6', 'Window4', 600, crochet/1300, 'sineInOut')
       doTweenY('turn8', 'Window5', 0, crochet/900, 'sineInOut')
       doTweenY('turn10', 'Window6', 650, crochet/900, 'sineInOut')

	end
	if t == 'turn1' then
		doTweenX('turn', 'Window', 150, crochet/900, 'sineInOut')
        doTweenX('turn3', 'Window2', 800, crochet/1300, 'sineInOut')
        doTweenX('turn5', 'Window3', 350, crochet/1300, 'sineInOut')
        doTweenX('turn7', 'Window4', 750, crochet/1300, 'sineInOut')
        doTweenY('turn9', 'Window5', 650, crochet/900, 'sineInOut')
        doTweenY('turn11', 'Window6', 0, crochet/900, 'sineInOut')
	end
end