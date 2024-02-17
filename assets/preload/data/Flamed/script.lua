function onCreatePost()	
	setProperty('camGame.zoom', 0.1)
	triggerEvent("Camera Follow Pos", getProperty('camFollowPos.x'), getProperty('camFollowPos.y'))
	setProperty('camGame.alpha', 0)
	setProperty('camHUD.alpha', 0)
	
	makeLuaSprite('tint', nil, getProperty('stage front1.x'), getProperty('sky.y'))
	makeGraphic('tint', 2561 * 3, 1644 * 2.5, '48581D')
	setObjectCamera('tint', 'other')
	setBlendMode('tint', 'multiply')
	addLuaSprite('tint', true)
	
	addHaxeLibrary('Paths')
	addHaxeLibrary('WiggleShader')
	addHaxeLibrary('WiggleEffect')
	addHaxeLibrary('WiggleEffectType', 'WiggleEffect')
	addHaxeLibrary('FlxShader', 'flixel.system.FlxAssets')
	addHaxeLibrary('ColorSwap')
	addHaxeLibrary('FlxTweenType')
	addHaxeLibrary('OverlayShader')
	
	runHaxeCode([[
	
	coolors = new ColorSwap();
	
	
	
	wiggleShit = new WiggleEffect();
	wiggleShit.waveAmplitude = 0.1;
	wiggleShit.waveFrequency = 0;
	wiggleShit.waveSpeed = 0.000005;
	wiggleShit.waveFrequency += 555 * 5;
	
	wiggleBit = new WiggleEffect();
	wiggleBit.waveAmplitude = 0;
	wiggleBit.waveFrequency = 75;
	wiggleBit.waveSpeed = 0.1;
	
	color = 0xFFFFFFFF;
		
	game.boyfriend.alpha = 0;
	game.dad.alpha = 0;
	game.gf.alpha = 0;
	if (ClientPrefs.lowQuality) {
	game.boyfriend.shader = coolors.shader;
	game.dad.shader = coolors.shader;
	game.gf.shader = coolors.shader;
	game.iconP1.shader = coolors.shader;
	game.iconP2.shader = coolors.shader;
	game.healthBar.shader = coolors.shader;
	}
	
				]])
	setProperty('scoreTxt.x', getProperty('healthBar.x') * 0.6)
end

function onCountdownTick(t)

	if t == 1 then setObjectCamera('countdownReady', 'other') end
	if t == 2 then setObjectCamera('countdownSet', 'other') end
	if t == 3 then setObjectCamera('countdownGo', 'other') end
	
end

function onRecalculateRating()
	setProperty('scoreTxt.text', 'Score:'..getProperty('songScore'))
end

function onSongStart()
	setProperty('camGame.alpha', 1)
	doTweenZoom('smoooooth', 'camGame', 0.6, ((stepCrochet / 1000) * 16) * 8 * 2, 'quadInOut')
	runHaxeCode([[
		
		FlxTween.tween(wiggleShit, {waveFrequency: 0, waveAmplitude: 0, waveSpeed: 0}, ((Conductor.stepCrochet / 1000) * 16) * 8.3, {ease: FlxEase.quadInOut});
		
					]])
end

local funnysteps = {248, 252, 316}
function onStepHit()
	for i = 0, #funnysteps do
		if curStep == funnysteps[i] then
			-- would've added a hey anim every step but nene has none :(
		end
	end
end

local woot = false
local bump = false
function onBeatHit()
	if curBeat == 18 then
		doTweenColor('tinteehee', 'tint', 'FFEF00', ((stepCrochet / 1000) * 16) * 1.3, 'quadOut')
	elseif curBeat == 20 then
		for i,chars in pairs({'boyfriend', 'dad', 'gf', 'camHUD'}) do
			doTweenAlpha(chars, chars, 1, ((stepCrochet / 1000) * 16) * 5, 'bounceOut')
		end
		doTweenAlpha('tinted', 'tint', 0, ((stepCrochet / 1000) * 16) * 3.3, 'quadIn')
	elseif curBeat == 32 then
		cancelTween('smoooooth')
		cancelTween('dad')
		setProperty('defaultCamZoom', 0.7)
		triggerEvent("Camera Follow Pos")
		for i,sprs in pairs({'stage front1', 'sky', 'bgcity', 'bridge', 'traffic signpost', 'carback', 'carback2', 'traffic lights', 'lightpost', 'fog1', 'fog2', 'lightpost lightcast'}) do
		runHaxeCode([[
		
		wiggleShit.waveAmplitude = 0;
		wiggleShit.waveFrequency = 0;
		wiggleShit.waveSpeed = 0;
		
		if (!ClientPrefs.lowQuality)
			game.getLuaObject(']]..sprs..[[').shader = coolors.shader;
					]])
		end
		bump = true
		setProperty('dad.alpha', 1)
		setProperty('gf.alpha', 1)
		setProperty('boyfriend.alpha', 1)
		setProperty('camHUD.alpha', 1)
	elseif curBeat == 272 then
		doTweenAlpha('tinted', 'tint', 1, ((stepCrochet / 1000) * 16) * 5.5, 'quadIn')
	elseif curBeat == 288 then
		setProperty('camHUD.visible', false)
		setProperty('camGame.visible', false)
	end
	if curBeat % 2 == 0 and bump then
		if woot then
		runHaxeCode([[
			
		if (ClientPrefs.lowQuality) coolors.saturation -= 0.1; else coolors.saturation += 0.15 * FlxG.random.float(0.8, 1.3);
		FlxTween.tween(coolors, {saturation: 0}, (Conductor.crochet / 1000) * 0.5);
		
					]])
		end
		woot = not woot
	end
end

local tweened = false
function onEvent(n)
	if n == 'bump' then
		bump = not bump
		for i,sprs in pairs({'stage front1', 'sky', 'bgcity', 'bridge', 'traffic signpost', 'carback', 'carback2', 'traffic lights', 'lightpost', 'fog1', 'fog2', 'lightpost lightcast'}) do
			if not bump then
			runHaxeCode([[
			
			game.getLuaObject(']]..sprs..[[').shader = wiggleShit.shader;
			
			wiggleShit.waveAmplitude = 0.0025;
			wiggleShit.waveFrequency = 75;
			wiggleShit.waveSpeed = 0.1;
			
			FlxTween.tween(wiggleShit, {waveAmplitude: 0}, ((Conductor.crochet / 1000) * 4) * 2.55);
			
			
						]])
			else
			runHaxeCode([[
			
			if (!ClientPrefs.lowQuality) game.getLuaObject(']]..sprs..[[').shader = coolors.shader;	
			game.boyfriend.shader = coolors.shader;
			game.dad.shader = coolors.shader;
			game.gf.shader = coolors.shader;
			game.iconP1.shader = coolors.shader;
			game.iconP2.shader = coolors.shader;
			game.healthBar.shader = coolors.shader;
						]])
			end
		end
	elseif n == 'wave' then
		runHaxeCode([[
		
		FlxTween.cancelTweensOf(wiggleShit);
		
		wiggleShit.waveAmplitude = 0.0025 * FlxG.random.float(1.3, 1.5);
		
		FlxTween.tween(wiggleShit, {waveAmplitude: 0}, ((Conductor.crochet / 1000) * 4) * 2.55);
					]])
	elseif n == 'wavy' then
		bump = false;
		for i,sprs in pairs({'stage front1', 'sky', 'bgcity', 'bridge', 'traffic signpost', 'carback', 'carback2', 'traffic lights', 'lightpost', 'fog1', 'fog2', 'lightpost lightcast'}) do
			if not tweened then
			runHaxeCode([[
			
			wiggleShit.waveAmplitude = 0;
			wiggleShit.waveFrequency = 75;
			wiggleShit.waveSpeed = 0.1;
			
			
			
			game.getLuaObject(']]..sprs..[[').shader = wiggleShit.shader;
			game.gf.shader = wiggleBit.shader;
			game.iconP1.shader = wiggleShit.shader;
			game.iconP2.shader = wiggleShit.shader;
			game.healthBar.shader = wiggleShit.shader;
			
			FlxTween.tween(wiggleShit, {waveAmplitude: 0.0055}, ((Conductor.crochet / 1000) * 4) * 1.8);
			FlxTween.tween(wiggleBit, {waveAmplitude: 0.0055 / 2.5}, ((Conductor.crochet / 1000) * 4) * 1.8);
			
			
						]])
			else
			runHaxeCode([[
			
			FlxTween.cancelTweensOf(wiggleShit);
			FlxTween.cancelTweensOf(wiggleBit);
			
			wiggleShit.waveAmplitude = 0.0030 * FlxG.random.float(1.3, 1.5);
			wiggleBit.waveAmplitude = wiggleShit.waveAmplitude / 2.2;
			
			
			FlxTween.tween(wiggleShit, {waveAmplitude: 0}, ((Conductor.crochet / 1000) * 4) * 2.55);
			FlxTween.tween(wiggleBit, {waveAmplitude: 0}, ((Conductor.crochet / 1000) * 4) * 2.55);
						
						]])
			end
		end
		if not tweened then
		doTweenZoom('gnite', 'camGame', 0.1, ((stepCrochet / 1000) * 16) * 8 * 2, 'quadInOut') end
		tweened = true;
	end
end

function onMoveCamera(focus)
	if focus == 'gf' then
		bump = false
		triggerEvent("Camera Follow Pos", getProperty('camFollow.x') * 0.8, getProperty('camFollow.y'))
		triggerEvent("Set GF Speed", 1)
	end
end


function onUpdatePost(el)
	if curBeat >= 256 then setProperty('camZooming', false) end
	for i,sprs in pairs({'stage front1', 'sky', 'bgcity', 'bridge', 'traffic signpost', 'carback', 'carback2', 'traffic lights', 'lightpost', 'fog1', 'fog2', 'lightpost lightcast'}) do
	--setProperty(sprs..'.color', getColorFromHex('48581D'))
	runHaxeCode([[
	
	color = 0xFFFFFFFF;
	
	wiggleShit.update(15);
	wiggleBit.update(15);
	
	if (wiggleShit.waveFrequency <= 0) {
		wiggleShit.waveFrequency = 0;
		wiggleShit.waveAmplitude = 0;
		wiggleShit.waveSpeed = 0;
	}
	
	//game.getLuaObject(']]..sprs..[[').setColorTransform(1.0, 1.0, 1.0, 1.0, 72, 88, 29);
	
				]])
		if not bump or curBeat < 32 then
			runHaxeCode([[
			
			game.getLuaObject(']]..sprs..[[').shader = wiggleShit.shader;
			
						]])
		elseif bump and not lowQuality then
			runHaxeCode([[
			
			game.getLuaObject(']]..sprs..[[').shader = coolors.shader;
			
						]])
		end
	end
end