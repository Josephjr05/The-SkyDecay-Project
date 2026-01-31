local crack = false;
local tea = 0;
function onCreate()
    makeLuaSprite('VGvrmaiu', 'RedVG', 0, 0);
    setObjectCamera('VGvrmaiu', 'hud')
    addLuaSprite('VGvrmaiu', true);
    setObjectOrder('VGvrmaiu', getObjectOrder('healthBar') + 10)
    setProperty('VGvrmaiu.alpha', 0)
	setBlendMode('VGvrmaiu', 'add')
end

function onEvent(nome, valor1)
    if nome == 'VGvrmaiu' then
        if valor1 ~= false and valor1 ~= 'False' and valor1 ~= 'false' then
            tea = -1
            crack = true
        else
            crack = false
            tea = -1
        end
    end
end

function onUpdate()
    if tea == 1 then
        doTweenAlpha('DooDooFart', 'VGvrmaiu', 1, 0.75, 'linear')
        tea = 2
    elseif tea == -1 then
        doTweenAlpha('DooDooFart', 'VGvrmaiu', 0, 0.75, 'linear')
        tea = -2
    end
end

function onBeatHit()
    if curBeat % 2 == 0 then
        if tea < 0 and crack then
            tea = 1
        elseif tea > 0 and crack then
            tea = -1
        end
    end
end