
function onCreate()
	makeLuaSprite('bartop','',0,-100);
	makeGraphic('bartop',1400, 100,'000000');
	addLuaSprite('bartop',false);
	makeLuaSprite('barbot','',0,720);
	makeGraphic('barbot',1400,100,'000000');
	addLuaSprite('barbot',false);
	setObjectCamera('bartop',v2);
	setObjectCamera('barbot',v2);
    setProperty('barbot.visible',false)
    setProperty('bartop.visible',false)
end

function onEvent(n,v1,v2)


	if n == 'hbo max' then
    setProperty('barbot.visible',true)
    setProperty('bartop.visible',true)
        if v1 == 'on' then

            doTweenY('bartop', 'bartop', 0, 0.5, 'quartOut')

            doTweenY('barbot', 'barbot', 620, 0.5, 'quartOut')
        end
    end
    if v1 == 'off' then

        doTweenY('bartop', 'bartop', -100, 0.5, 'quartOut')

        doTweenY('barbot', 'barbot', 720, 0.5, 'quartOut')
    end
    if v2 == 'hud' then
        setObjectCamera('bartop','hud');
        setObjectCamera('barbot','hud');
    end
    if v2 == 'other' then
        setObjectCamera('bartop','other');
        setObjectCamera('barbot','other');
    end
end