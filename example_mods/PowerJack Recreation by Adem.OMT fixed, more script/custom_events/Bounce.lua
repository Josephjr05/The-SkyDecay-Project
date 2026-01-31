-- Inspired by the "Kaboom" event from Madness Vandalization from BBPanzu!! Check it here --> (https://gamebanana.com/mods/327032)


--[[ I HATE CANCELING TWEENS >:( GOD I HATE TWEENS HOLY SHIT THEY SUCK ASS SO MUCH GRRRRRR    

PS: Don't blame me for the hideous amount of cancelTween functions, blame PSYCH ENGINE!!!!!!!! >:(   -SizzlingCorp ]]

function onEvent(n, v1, v2)
    if n == 'Bounce' then
        toggle = tonumber(v1)

        angle = tonumber(splitStr(v2, ',')[1])
        intensity = tonumber(splitStr(v2, ',')[2])

        triggerEvent("Add Camera Zoom", 0.02, 0.05);

        --[[This "Add Camera Zoom" event is here bc it triggers my OCD when it 
        doesnt zoom when the event is triggered right away]]

        if toggle == 0 then
            cancelTween('anglegame1');
            cancelTween('anglehud1');

            cancelTween('anglegame2');
            cancelTween('anglehud2');

            doTweenAngle('resetgame', 'camGame', 0, crochet / 750, 'cubeOut');
            doTweenAngle('resethud', 'camHUD', 0, crochet / 750, 'cubeOut');
        end
    end
end

function onBeatHit()
    if toggle == 1 then
        if curBeat % 2 == 0 then
            setProperty('camGame.angle', -angle);
            setProperty('camHUD.angle', angle);

            cancelTween('anglegame2');
            cancelTween('anglehud2');

            doTweenAngle('anglegame1', 'camGame', (-angle - 1.5 ), crochet / 750, 'linear');
            doTweenAngle('anglehud1', 'camHUD', (angle + 1.5), crochet / 750, 'linear');
        else
            setProperty('camGame.angle', angle);
            setProperty('camHUD.angle', -angle);

            cancelTween('anglegame1');
            cancelTween('anglehud1');

            doTweenAngle('anglegame2', 'camGame', (angle + 1.5), crochet / 750, 'linear');
            doTweenAngle('anglehud2', 'camHUD', (-angle - 1.5), crochet / 750, 'linear');
        end

        cancelTween('moveDownGame');
        cancelTween('moveDownHUD');

        doTweenY('moveUpGame', 'camGame', -intensity, crochet / 2000, 'sineOut');
        doTweenY('moveUpHUD', 'camHUD', -intensity, crochet / 2000, 'sineOut');

        triggerEvent("Add Camera Zoom", 0.02, 0.05);
    end
end

function onTweenCompleted(tag)
    if toggle == 1 then
        if tag == 'moveUpGame' then
            cancelTween('moveUpGame');

            doTweenY('moveDownGame', 'camGame', 0, crochet / 2000, 'sineIn');
        end

        if tag == 'moveUpHUD' then
            cancelTween('moveUpHUD');

            doTweenY('moveDownHUD', 'camHUD', 0, crochet / 2000, 'sineIn');
        end
    end
end

function splitStr(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end

    local t = {}

    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end

    return t
end
