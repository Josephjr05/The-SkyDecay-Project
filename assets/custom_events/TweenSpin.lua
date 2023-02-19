function onEvent(name, value1, value2)
	if name == 'TweenSpin' then
		noteTweenAngle('A', 0, 360, 0.3, 'linear')
		noteTweenAngle('B', 1, 360, 0.3, 'linear')
		noteTweenAngle('C', 2, 360, 0.3, 'linear')
		noteTweenAngle('D', 3, 360, 0.3, 'linear')

		noteTweenAngle('E', 4, 360, 0.3, 'linear')
		noteTweenAngle('F', 5, 360, 0.3, 'linear')
		noteTweenAngle('J', 6, 360, 0.3, 'linear')
		noteTweenAngle('H', 7, 360, 0.3, 'linear')
	end
end

function onTweenCompleted(tag)
	if tag == 'A' then
		setPropertyFromGroup('opponentStrums', 0, 'angle', 0)
		setPropertyFromGroup('opponentStrums', 1, 'angle', 0)
		setPropertyFromGroup('opponentStrums', 2, 'angle', 0)
		setPropertyFromGroup('opponentStrums', 3, 'angle', 0)

		setPropertyFromGroup('playerStrums', 0, 'angle', 0)
		setPropertyFromGroup('playerStrums', 1, 'angle', 0)
		setPropertyFromGroup('playerStrums', 2, 'angle', 0)
		setPropertyFromGroup('playerStrums', 3, 'angle', 0)
	end
end