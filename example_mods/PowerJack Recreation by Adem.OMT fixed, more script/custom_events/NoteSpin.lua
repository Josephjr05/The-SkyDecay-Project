function onEvent(name, value1, value2)
	if name == 'NoteSpin' then
		noteTweenAngle('A', 0, 360, 0.2, 'circInOut')
		noteTweenAngle('B', 1, 360, 0.2, 'circInOut')
		noteTweenAngle('C', 2, 360, 0.2, 'circInOut')
		noteTweenAngle('D', 3, 360, 0.2, 'circInOut')
		noteTweenAngle('E', 4, 360, 0.2, 'circInOut')
		noteTweenAngle('F', 5, 360, 0.2, 'circInOut')
		noteTweenAngle('G', 6, 360, 0.2, 'circInOut')
		noteTweenAngle('H', 7, 360, 0.2, 'circInOut')
		noteTweenAngle('I', 8, 360, 0.2, 'circInOut')
		noteTweenAngle('J', 9, 360, 0.2, 'circInOut')
	end
end

function onTweenCompleted(tag)
	if tag == 'A' then
		setPropertyFromGroup('opponentStrums', 0, 'angle', 0)
		setPropertyFromGroup('opponentStrums', 1, 'angle', 0)
		setPropertyFromGroup('opponentStrums', 2, 'angle', 0)
		setPropertyFromGroup('opponentStrums', 3, 'angle', 0)
		setPropertyFromGroup('opponentStrums', 4, 'angle', 0)

		setPropertyFromGroup('playerStrums', 0, 'angle', 0)
		setPropertyFromGroup('playerStrums', 1, 'angle', 0)
		setPropertyFromGroup('playerStrums', 2, 'angle', 0)
		setPropertyFromGroup('playerStrums', 3, 'angle', 0)
		setPropertyFromGroup('playerStrums', 4, 'angle', 0)
	end
end