
function onCreate()
	for _, LoadChairs in ipairs({ 'bf-2hot','darnell-2hot','gf-2hot'}) do
        addCharacterToList(LoadChairs)
    end
	for _, LoadImages in ipairs({ 'deadOrAlive','imLazy','imLazyUnblur', 'mistBack','mistFront','mistMid','phillyConstruction','phillyConstructionUnBlur','phillyForeground','phillyForegroundCity','phillyForegroundCityUnBlur','phillyHighway','phillyHighwayUnBlur','phillyHighwayLights','phillyHighwayLightsUnBlur','phillySkybox','phillySkyline','SpraycanPile'}) do
        precacheImage('phillyStreets/2hot/'..LoadImages)
    end
precacheImage('characters/BOYFRIEND_DEAD')
precacheImage('phillyStreets/spraypaintExplosionEZ')
precacheImage('phillyStreets/fakeCan')
precacheImage('spraycanErectAtlas')


makeLuaSprite('doa', '', 0, 210)
makeGraphic('doa', 1, 1, '000000')
scaleObject('doa', screenWidth, screenHeight)
setObjectCamera('doa', 'hud')
addLuaSprite('doa', false);

makeLuaSprite('doa2', '', 750, 0)
makeGraphic('doa2', 1, 1, '000000')
scaleObject('doa2', screenWidth, screenHeight)
setObjectCamera('doa2', 'hud')
addLuaSprite('doa2', false);

makeLuaSprite('doa3', '', 0, 400)
makeGraphic('doa3', 1, 1, '000000')
scaleObject('doa3', 270, 400)
setObjectCamera('doa3', 'hud')
addLuaSprite('doa3', false);

makeLuaSprite('deadOrAlive','phillyStreets/2hot/deadOrAlive',0,0)
setObjectCamera('deadOrAlive', 'hud')
addLuaSprite('deadOrAlive', false);

setProperty('doa.visible', false)
setProperty('doa2.visible', false)
setProperty('doa3.visible', false)
setProperty('deadOrAlive.visible', false)

end
function onCreatePost()
    makeLuaSprite('boomdark', '', -1000, -1000)
	makeGraphic('boomdark', 1, 1, '000000')
	scaleObject('boomdark', screenWidth+10000, screenHeight+10000)
    addLuaSprite('boomdark', false);
    setProperty('boomdark.alpha', 0)

    makeLuaSprite('darkness', '', -1000, -1000)
	makeGraphic('darkness', 1, 1, '000000')
	scaleObject('darkness', screenWidth+10000, screenHeight+10000)
    addLuaSprite('darkness', true);
    setObjectOrder('darkness', 66)
    setProperty('darkness.alpha', 0)

    makeAnimatedLuaSprite('fakeDeath','characters/BOYFRIEND_DEAD',getProperty('boyfriend.x')-20,getProperty('boyfriend.y'))
    addAnimationByPrefix('fakeDeath','BF dies','BF dies',24,false)
    addAnimationByPrefix('fakeDeath','BF Dead confirm','BF Dead confirm',24,false)
    addAnimationByPrefix('fakeDeath','BF Dead Loop','BF Dead Loop',24,true)
    objectPlayAnimation('fakeDeath','BF dies',false)

    makeAnimatedLuaSprite('fakeExp','phillyStreets/spraypaintExplosionEZ',getProperty('boyfriend.x')-400,getProperty('boyfriend.y')-300)
    addAnimationByPrefix('fakeExp','BOOM','explosion round 1 short',24,false)
    objectPlayAnimation('fakeExp','BOOM',false)
    setProperty('fakeExp.alpha', 0)
    addLuaSprite('fakeExp', true);
    if shadersEnabled == true then
    makeLuaSprite('colorShit')
    setSpriteShader('colorShit','colorShit')
    end
    if timeBarType == 'Disabled' then
        callMethod('uiGroup.remove', {instanceArg('timeBar'), true})
		callMethod('uiGroup.remove', {instanceArg('timeTxt'), true})
    end
end


function goodNoteHit(i, d, n, s)
	if n == 'weekend-1-firegun' then
        runTimer('darkTimer',0.042)

    end
end

function onTimerCompleted(t)
    if t == 'darkTimer' then
        setProperty('boomdark.alpha', 0.9)
        doTweenAlpha('boomdark', 'boomdark', 0, 1.4, 'linear')
    end
end

function onStepHit()
    if curStep == 1024 then
        setProperty('doa.visible', true)
        setProperty('doa2.visible', true)
        setProperty('doa3.visible', true)
        setProperty('deadOrAlive.visible', true)
        if shadersEnabled == true then
        runHaxeCode([[
            game.camGame.filters = [new ShaderFilter(game.getLuaObject('colorShit').shader)];
            return;
        ]])
    end
        for _, uigroupstuff in ipairs({ 'healthBarBG', 'healthBar','scoreTxt','iconP1', 'iconP2','FC','timeBar','timeTxt'}) do
            setProperty(uigroupstuff..'.visible', false)
        end
	elseif curStep == 1026 then
		setProperty('doa.y',380)
	elseif curStep == 1028 then
		setProperty('doa.x',270)
		setProperty('doa3.y',530)
	elseif curStep == 1030 then
		removeLuaSprite('doa2',true)
	elseif curStep == 1032 then
		removeLuaSprite('doa3',true)
	elseif curStep == 1034 then
		setProperty('doa.x',700)
        setProperty('boyfriend.cameraPosition',{getProperty('boyfriend.cameraPosition[0]')+150,getProperty('boyfriend.cameraPosition[1]')+0})
	elseif curStep == 1036 then
		removeLuaSprite('doa',true)
    elseif curStep == 1040 then
        doTweenX('deadOrAliveX', 'deadOrAlive.scale', 4, 0.1, 'linear')
        doTweenY('deadOrAliveY', 'deadOrAlive.scale', 4, 0.1, 'linear')
        doTweenAlpha('deadOrAliveA', 'deadOrAlive', 0, 0.1, 'linear')
        for _, uigroupstuff in ipairs({ 'healthBarBG', 'healthBar','scoreTxt','iconP1', 'iconP2','FC','timeBar','timeTxt'}) do
            setProperty(uigroupstuff..'.visible', true)
        end
    elseif curStep == 1050 then
        removeLuaSprite('deadOrAlive',true)   
	end
    if curStep == 847 then
    setProperty('boyfriend.cameraPosition',{getProperty('boyfriend.cameraPosition[0]')-150,getProperty('boyfriend.cameraPosition[1]')+0})
    end
if curStep == 400 then
    runHaxeCode('FlxTween.tween(game, {defaultCamZoom: 1}, 5, {ease: FlxEase.sineInOut});')
end
if curStep == 688 then
    runHaxeCode('FlxTween.tween(game, {defaultCamZoom: 1.1}, 5, {ease: FlxEase.sineInOut});')
end
    if curStep == 2224 then
        runHaxeCode('FlxTween.tween(game, {defaultCamZoom: 0.65}, 2.2, {ease: FlxEase.sineInOut});')
        doTweenAlpha('raintest', 'rainFilter', 1, 2.5, 'linear')
        doTweenAlpha('goodbye', 'darkness', 1, 2.5, 'linear')
        doTweenAlpha('notraptime', 'camHUD', 0, 4, 'linear')
        setObjectCamera('Lyrics', 'other')
        doTweenY('goDownLyrics', 'Lyrics', getProperty('Lyrics.y')+100, 0.1, 'QuadOut')
    elseif curStep == 2258 then
    preCutCombo = getProperty('combo')
    preCutScore = getProperty('score')
    preCutRatings = getProperty('ratingPercent')
    setProperty('showComboNum', false)
    setProperty('showRating', false)
    elseif curStep == 2385 then
        setProperty('showComboNum', true)
        setProperty('showRating', true)
        setProperty('combo', preCutCombo)
        setProperty('ratingPercent', preCutRatings)
        setProperty('score', preCutScore)

    elseif curStep == 2256 then
    setProperty('camGame.zoom',1)
    setProperty('defaultCamZoom',1)
    callMethod('startVideo', {'2hotBFCut1', true, false, false, false})
    setObjectCamera('videoCutscene', 'game')
    setObjectOrder('videoCutscene', 69)
    callMethod('videoCutscene.videoSprite.play', {'2hotBFCut1'})
    setProperty('canReset', false)
    setProperty('inCutscene', false)
    setProperty('canPause', false)
    elseif curStep == 2320 then
  doTweenAlpha('raptime', 'camHUD', 1, 5, 'linear')
  doTweenY('goUpLyrics', 'Lyrics', getProperty('Lyrics.y')-100, 5, 'QuadOut')
    elseif curStep == 2384 then
    setProperty('canPause', true)
    setProperty('canReset', true)
    setObjectCamera('Lyrics', 'hud')
    setProperty('darkness.alpha', 0)
    setProperty('videoCutscene.alpha',0)
    setProperty('boyfriend.cameraPosition',{getProperty('boyfriend.cameraPosition[0]')-90,getProperty('boyfriend.cameraPosition[1]')+0})
    elseif curStep == 2464 then
        doTweenAlpha('gfSpoopy', 'boomdark', 0.6, 0.7, 'linear')

    elseif curStep == 2472 then
        callMethod('gf.animation.curAnim.finish', {''})
        characterDance('gf')
        doTweenAlpha('notgfSpoopy', 'boomdark', 0, 0.3, 'linear')
    elseif curStep == 1584 then
        setProperty('canPause', false)
        setProperty('canReset', false)
        objectPlayAnimation('fakeExp','BOOM',false)
        setProperty('camHUD.alpha',0)
        addLuaSprite('fakeDeath', true);
        setProperty('darkness.alpha', 1)
        setProperty('fakeExp.alpha', 1)
        setObjectOrder('fakeDeath', 67)
        setObjectOrder('fakeExp', 68)
        setProperty('camZoomingMult', 0)
        setProperty('cameraSpeed', 0.1)
    elseif curStep == 1616 then
        objectPlayAnimation('fakeDeath','BF Dead Loop',true)
        setProperty('fakeDeath.y', getProperty('fakeDeath.y')+6)
        runHaxeCode('FlxTween.tween(game, {defaultCamZoom: 0.9}, 10, {ease: FlxEase.sineInOut});')
elseif curStep == 1728 then
    objectPlayAnimation('fakeDeath','BF Dead confirm',true)
    setProperty('fakeDeath.y', getProperty('fakeDeath.y')-64)
elseif curStep == 1738 then
    removeLuaSprite('fakeDeath',true)
    removeLuaSprite('fakeExp',true)
    setProperty('cameraSpeed', 0.15)
elseif curStep == 1744 then
    setProperty('camZoomingMult', 1)
    runHaxeCode('FlxTween.tween(game, {defaultCamZoom: 0.65}, 10, {ease: FlxEase.sineInOut});')
    doTweenAlpha('hello', 'darkness', 0, 10, 'linear')
    setProperty('canPause', true)
    setProperty('canReset', true)
elseif curStep == 1839 then
    doTweenAlpha('raptime', 'camHUD', 1, 1, 'linear')
elseif curStep == 1455 then
    setProperty('boyfriend.cameraPosition',{getProperty('boyfriend.cameraPosition[0]')-90,getProperty('boyfriend.cameraPosition[1]')+0})
elseif curStep == 1459 then
    runHaxeCode('FlxTween.tween(game, {defaultCamZoom: 1.1}, 9, {ease: FlxEase.sineInOut});')
elseif curStep == 1669 or curStep == 2512 then
    setProperty('boyfriend.cameraPosition',{getProperty('boyfriend.cameraPosition[0]')+90,getProperty('boyfriend.cameraPosition[1]')+0})
elseif curStep == 1196 then
    setProperty('dad.cameraPosition',{getProperty('dad.cameraPosition[0]')-200,getProperty('dad.cameraPosition[1]')+0})
elseif curStep == 1327 then
    setProperty('dad.cameraPosition',{getProperty('dad.cameraPosition[0]')+200,getProperty('dad.cameraPosition[1]')+0})
elseif curStep == 2736 then
    callMethod('startVideo', {'2hotBFCut2', true, false, false, false})
    setObjectCamera('videoCutscene', 'game')
    setObjectOrder('videoCutscene', 69)
    callMethod('videoCutscene.videoSprite.play', {'2hotBFCut2'})
    setProperty('videoCutscene.alpha',0)
    setProperty('inCutscene', false)
    setProperty('canPause', false)--SET TO FLASE
    setProperty('canReset', false)

elseif curStep == 2748 then
    setProperty('camGame.zoom',1)
    setProperty('defaultCamZoom',1)
    triggerEvent('Split Screen','','')
    setProperty('darkness.alpha', 1)
    setProperty('videoCutscene.alpha',1)
elseif curStep == 2832 then
    doTweenAlpha('notraptime', 'camHUD', 0, 0.6, 'linear')

elseif curStep == 2772 then
    for _, uigroupstuff in ipairs({ 'healthBarBG', 'healthBar','scoreTxt','iconP1', 'iconP2','FC','timeBar','timeTxt'}) do
        setProperty(uigroupstuff..'.visible', false)
    end
end
end

