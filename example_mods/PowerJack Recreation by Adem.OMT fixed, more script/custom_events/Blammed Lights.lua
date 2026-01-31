colors = {'0xFF31A2FD', '0xFF31FD8C', '0xFFF794F7', '0xFFF96D63', '0xFFFBA633'}


local curLightEvent = 0

function onCreatePost()

	--black bg
	makeLuaSprite('blammedLightsBlack', '', getPropertyFromClass('flixel.FlxG', 'width') * -0.5, getPropertyFromClass('flixel.FlxG', 'height') * -0.5)
	makeGraphic('blammedLightsBlack', getPropertyFromClass('flixel.FlxG', 'width') * 2, getPropertyFromClass('flixel.FlxG', 'height') * 2, '000000')
	
	setScrollFactor('blammedLightsBlack', 0)
	setProperty('blammedLightsBlack.scale.x', 5)
	setProperty('blammedLightsBlack.scale.y', 5)

	if getProperty('gf.visible') == true then
		setObjectOrder('blammedLightsBlack', getObjectOrder('gfGroup'))
	elseif getProperty('dad.visible') == true then
		setObjectOrder('blammedLightsBlack', getObjectOrder('dadGroup'))
	else
		setObjectOrder('blammedLightsBlack', getObjectOrder('boyfriendGroup'))
	end

	addLuaSprite('blammedLightsBlack', false)

	setProperty('blammedLightsBlack.alpha', 0)


	--city windows
	if getPropertyFromClass('PlayState', 'curStage') == 'philly' then

		makeLuaSprite('light', 'philly/window', -10, 0)

		setScrollFactor('light', 0.3, 0.3)

		if getProperty('gf.visible') == true then
			setObjectOrder('light', getObjectOrder('gfGroup'))
		elseif getProperty('dad.visible') == true then
			setObjectOrder('light', getObjectOrder('dadGroup'))
		else
			setObjectOrder('light', getObjectOrder('boyfriendGroup'))
		end

		scaleObject('light', 0.85, 0.85)

		addLuaSprite('light', false)

		setProperty('light.alpha', 0)

	end

end

function onEvent(name, value1)

	if name == 'Blammed Lights' then

		local lightId = tonumber(value1)
		if lightId == nil then lightId = 0 end

		if lightId > 0 then

			if lightId > #colors then
				lightId = getRandomInt(1, #colors, tostring(curLightEvent))
			end

			curLightEvent = lightId

			if getProperty('blammedLightsBlack.alpha') == 0 then

				doTweenAlpha('blammedLightsBlackTween', 'blammedLightsBlack', 1, 1, 'quadInOut')
				doTweenColor('boyfriendColorTween', 'boyfriend', colors[lightId], 1, 'quadInOut')
				doTweenColor('dadColorTween', 'dad', colors[lightId], 1, 'quadInOut')
				doTweenColor('gfColorTween', 'gf', colors[lightId], 1, 'quadInOut')

			else

				setProperty('blammedLightsBlack.alpha', 1)
				doTweenColor('boyfriendColorTween', 'boyfriend', colors[lightId], 0.00000001, 'quadInOut')
				doTweenColor('dadColorTween', 'dad', colors[lightId], 0.00000001, 'quadInOut')
				doTweenColor('gfColorTween', 'gf', colors[lightId], 0.00000001, 'quadInOut')

			end

			if getPropertyFromClass('PlayState', 'curStage') == 'philly' then
				doTweenColor('phillyCityLightsEventColor', 'light', colors[lightId], 0.00000001, 'quadInOut')
				doTweenAlpha('phillyCityLightsEventAlpha', 'light', 1, 1, 'quadInOut')
			end

		else

			doTweenAlpha('blammedLightsBlackTween', 'blammedLightsBlack', 0, 1, 'quadInOut')

			if getPropertyFromClass('PlayState', 'curStage') == 'philly' then
				doTweenAlpha('phillyCityLightsEventAlpha', 'light', 0, 1, 'quadInOut')
			end
			
			doTweenColor('boyfriendColorTween', 'boyfriend', '0xffffffff', 1, 'quadInOut')
			doTweenColor('dadColorTween', 'dad', '0xffffffff', 1, 'quadInOut')
			doTweenColor('gfColorTween', 'gf', '0xffffffff', 1, 'quadInOut')

			curLightEvent = 0

		end

	end

	--disable the event on philly glow because it bugs out
	if name == 'Philly Glow' or name == 'Philly Glow Recreation' then
	
		cancelTween('boyfriendColorTween')
		cancelTween('dadColorTween')
		cancelTween('gfColorTween')

		if not (getProperty('blammedLightsBlack.alpha') == 0) and not (curLightEvent == 0) then

			doTweenAlpha('blammedLightsBlackTween', 'blammedLightsBlack', 0, 0.00000001, 'quadInOut')

			if getPropertyFromClass('PlayState', 'curStage') == 'philly' then
				doTweenAlpha('phillyCityLightsEventAlpha', 'light', 0, 0.00000001, 'quadInOut')
			end
			
			doTweenColor('boyfriendColorTween', 'boyfriend', '0xffffffff', 0.00000001, 'quadInOut')
			doTweenColor('dadColorTween', 'dad', '0xffffffff', 0.00000001, 'quadInOut')
			doTweenColor('gfColorTween', 'gf', '0xffffffff', 0.00000001, 'quadInOut')

			curLightEvent = 0

		end

	end

end