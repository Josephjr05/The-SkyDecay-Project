function onCreatePost()
	for i,v in ipairs({412, 524, 636, 748}) do
		if not middlescroll then
			noteTweenX("bfCinNote" .. i, i + 3, v, 0.01, "quadOut")
		end
	end
	for i = 0, 3 do
		setProperty('opponentStrums.members['..i..'].visible', false)
	end
	for i = 0, getProperty('unspawnNotes.length')-1 do
        if not getProperty('unspawnNotes['..i..'].mustPress') then
            setProperty('unspawnNotes['..i..'].visible', false)
        end
    end
	makeLuaSprite('startblack', '', 0, 0)
	makeGraphic('startblack', 1, 1, '000000')
	scaleObject('startblack', screenWidth+10, screenHeight+10)
	addLuaSprite('startblack', false);
	setObjectCamera('startblack', 'hud')

	makeLuaSprite('startblackTheSecond', '', 0, 0)
	makeGraphic('startblackTheSecond', 1, 1, '000000')
	scaleObject('startblackTheSecond', screenWidth+10, screenHeight+10)
	addLuaSprite('startblackTheSecond', true);
	setObjectCamera('startblackTheSecond', 'other')

	for _, uigroupstuff in ipairs({ 'healthBarBG', 'healthBar','scoreTxt','iconP1', 'iconP2','FC','timeBar','timeTxt'}) do
		setProperty(uigroupstuff..'.alpha',0)
		setProperty(uigroupstuff..'.visible',false)
    end
	if timeBarType == 'Disabled' then
        callMethod('uiGroup.remove', {instanceArg('timeBar'), true})
		callMethod('uiGroup.remove', {instanceArg('timeTxt'), true})
    end

end
function onCountdownTick(counter)
	if counter == 1 then 
		doTweenAlpha('noteReveal', 'startblackTheSecond', 0, 0.4, 'linear')
	end
end

function onStepHit()
	if curStep == 1 then
		doTweenAlpha('fadeinGame', 'startblack', 0, 10, 'linear')
	end
	if curStep == 2 then
		for _, uigroupstuff in ipairs({ 'healthBarBG', 'healthBar','scoreTxt','iconP1', 'iconP2','FC','timeBar','timeTxt'}) do
			setProperty(uigroupstuff..'.alpha',0)
			doTweenAlpha('hudStart'..uigroupstuff,uigroupstuff, 1, 3, 'linear')
			setProperty(uigroupstuff..'.visible',true)
		end
	end

	if curStep == 384 then
		doTweenAlpha('fadeoutGame', 'startblack', 1, 5, 'linear')
		removeLuaSprite('startblackTheSecond',true)
	end
	if curStep == 448 then
		setProperty('startblack.alpha',1)
		setProperty('boyfriend.singDuration', 0)
		setProperty('cameraSpeed', 0.05)
		setProperty('fakeDarnell.alpha', 1);
		setProperty('dad.alpha', 0);
		callMethod('boyfriend.animation.curAnim.finish', {''})
        characterDance('boyfriend')
	end
	if curStep == 453 then
		doTweenAlpha('fadeinGame', 'startblack', 0, 4, 'linear')
		setProperty('dad.singDuration', 999)
		setProperty('boyfriend.singDuration', 999)
		runHaxeCode('FlxTween.tween(game, {defaultCamZoom: 0.9}, 8, {ease: FlxEase.sineInOut});')
	end
	if curStep == 560 then
		setProperty('fakeDarnell.alpha', 0);
		setProperty('dad.alpha', 1);
	end
end