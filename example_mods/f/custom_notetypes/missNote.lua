function onCreate()
	for i = 0, getProperty('unspawnNotes.length') - 1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'missNote' then
			setPropertyFromGroup('unspawnNotes', i, 'blockHit', true);
			setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true)
		end
	end
end