function onCreate()
    setProperty('healthBar.visible', false)
    setProperty('healthBarBG.visible', false)
    setProperty('scoreTxt.visible', false)
    setProperty('ratingTxt.visible', false)
    setProperty('missTxt.visible', false)

    makeAnimatedLuaSprite('powerjackBar', 'Powerjackhealthbar', 0, 0)
    addAnimationByPrefix('powerjackBar', 'hp0', 'Powerjackhealthbar0000', 24, false)
    addAnimationByPrefix('powerjackBar', 'hp1', 'Powerjackhealthbar0001', 24, false)
    addAnimationByPrefix('powerjackBar', 'hp2', 'Powerjackhealthbar0002', 24, false)
    addAnimationByPrefix('powerjackBar', 'hp3', 'Powerjackhealthbar0003', 24, false)
    addAnimationByPrefix('powerjackBar', 'hp4', 'Powerjackhealthbar0004', 24, false)
    addAnimationByPrefix('powerjackBar', 'hp5', 'Powerjackhealthbar0005', 24, false)
    addAnimationByPrefix('powerjackBar', 'hp6', 'Powerjackhealthbar0006', 24, false)
    addAnimationByPrefix('powerjackBar', 'hp7', 'Powerjackhealthbar0007', 24, false)

    setObjectCamera('powerjackBar', 'hud')
    scaleObject('powerjackBar', 0.5, 0.5)
    updateHitbox('powerjackBar')

    local offsetY = 112
    setProperty('powerjackBar.x', 40)
    setProperty('powerjackBar.y', screenHeight - getProperty('powerjackBar.height') * 0.6 - offsetY)
    addLuaSprite('powerjackBar', false)

    local posX = 50
    local posY = screenHeight / 2 - 50

    makeLuaText('scoreHUD', 'Score: 0', 400, posX, posY)
    setTextSize('scoreHUD', 22)
    setTextBorder('scoreHUD', 2, '000000')
    setTextAlignment('scoreHUD', 'left')
    setObjectCamera('scoreHUD', 'hud')
    addLuaText('scoreHUD')

    makeLuaText('missHUD', 'Misses: 0', 400, posX, posY + 30)
    setTextSize('missHUD', 22)
    setTextBorder('missHUD', 2, '000000')
    setTextAlignment('missHUD', 'left')
    setObjectCamera('missHUD', 'hud')
    addLuaText('missHUD')

    makeLuaText('accHUD', 'Accuracy: 0%', 400, posX, posY + 60)
    setTextSize('accHUD', 22)
    setTextBorder('accHUD', 2, '000000')
    setTextAlignment('accHUD', 'left')
    setObjectCamera('accHUD', 'hud')
    addLuaText('accHUD')

    makeLuaText('comboHUD', 'Combo: 0', 400, posX, posY + 90)
    setTextSize('comboHUD', 22)
    setTextBorder('comboHUD', 2, '000000')
    setTextAlignment('comboHUD', 'left')
    setObjectCamera('comboHUD', 'hud')
    addLuaText('comboHUD')
end

function onUpdate()
    local hp = getProperty('health')
    local percent = (hp / 2) * 100
    local anim = 'hp0'

    if percent >= 95 then
        anim = 'hp4'
    elseif percent >= 80 then
        anim = 'hp3'
    elseif percent >= 60 then
        anim = 'hp2'
    elseif percent >= 50 then
        anim = 'hp1'
    elseif percent >= 31 then
        anim = 'hp5'
    elseif percent >= 11 then
        anim = 'hp6'
    elseif percent >= 1 then
        anim = 'hp7'
    else
        anim = 'hp0'
    end

    if getProperty('powerjackBar.animation.curAnim.name') ~= anim then
        playAnim('powerjackBar', anim, true)
    end

    local score = getProperty('songScore')
    local misses = getProperty('songMisses')
    local combo = getProperty('combo')
    local acc = 0
    if getProperty('ratingPercent') ~= nil then
        acc = math.floor(getProperty('ratingPercent') * 10000) / 100
    end

    setTextString('scoreHUD', 'Score: ' .. score)
    setTextString('missHUD', 'Misses: ' .. misses)
    setTextString('accHUD', 'Accuracy: ' .. acc .. '%')
    setTextString('comboHUD', 'Combo: ' .. combo)
end

function onStepHit()
    if curStep == 1041 then
        setProperty('powerjackBar.visible', false)
        setProperty('scoreHUD.visible', false)
        setProperty('missHUD.visible', false)
        setProperty('accHUD.visible', false)
        setProperty('comboHUD.visible', false)
    elseif curStep == 1408 then
        setProperty('powerjackBar.visible', true)
        setProperty('scoreHUD.visible', true)
        setProperty('missHUD.visible', true)
        setProperty('accHUD.visible', true)
        setProperty('comboHUD.visible', true)
    end
end

function onUpdatePost()
    local hiddenList = {'healthBar', 'healthBarBG', 'scoreTxt', 'ratingTxt', 'missTxt'}
    for i = 1, #hiddenList do
        setProperty(hiddenList[i]..'.visible', false)
        setProperty(hiddenList[i]..'.alpha', 0)
    end

    setProperty('iconP1.x', 90)
    setProperty('iconP2.x', 20)
    setProperty('iconP1.y', screenHeight - 195)
    setProperty('iconP2.y', screenHeight - 185)
end

--- this made by fatirxain , and need 1 days for this script