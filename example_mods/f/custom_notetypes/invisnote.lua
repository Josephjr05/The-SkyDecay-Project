function onCreate()
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'invisnote' then  --Checks if the note is the one in the script. Set this to the name of your file.
			setPropertyFromGroup('unspawnNotes', i, 'multAlpha', 0)
		end
	end
end
