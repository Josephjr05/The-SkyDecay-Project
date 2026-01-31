local forceUpscroll = false

function onCreate()
	makeAnimatedLuaSprite('humo', 'humo', -230, 150)
	addAnimationByPrefix('humo', 'idle', 'humo idle', 12, true)
	addLuaSprite('humo', true)
	objectPlayAnimation('humo', 'idle', true)
end

function onStepHit()
	if curStep == 1041 then
		setProperty('humo.visible', false)
	end

	if curStep == 1408 then
		setProperty('humo.visible', true)
		objectPlayAnimation('humo', 'idle', true)

		forceUpscroll = true
		setPropertyFromClass('backend.ClientPrefs', 'data.downScroll', false)
		setPropertyFromClass('backend.ClientPrefs', 'data.middleScroll', false)
		setProperty('downScroll', false)

		resetStrumPositions()
	end
end

function resetStrumPositions()
	local oppX = {92, 204, 316, 428}
	local plrX = {732, 844, 956, 1068}
	local strumY = 50

	for i = 0,3 do
		setPropertyFromGroup('strumLineNotes', i, 'x', oppX[i+1])
		setPropertyFromGroup('strumLineNotes', i, 'y', strumY)
		setPropertyFromGroup('strumLineNotes', i, 'alpha', 1)
		setPropertyFromGroup('strumLineNotes', i, 'visible', true)
	end

	for i = 4,7 do
		setPropertyFromGroup('strumLineNotes', i, 'x', plrX[i-3])
		setPropertyFromGroup('strumLineNotes', i, 'y', strumY)
		setPropertyFromGroup('strumLineNotes', i, 'alpha', 1)
		setPropertyFromGroup('strumLineNotes', i, 'visible', true)
	end
end

function onUpdatePost()
	if forceUpscroll then
		setPropertyFromClass('backend.ClientPrefs', 'data.downScroll', false)
		setPropertyFromClass('backend.ClientPrefs', 'data.middleScroll', false)
		setProperty('downScroll', false)
		resetStrumPositions()
	end
end