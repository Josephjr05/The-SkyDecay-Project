-- Event notes hooks NOTE: THIS IS ONLY FOR LULLABY
function onEvent(name, value1, value2)
	if name == 'Note Fade' then
		character = tonumber(value1);
		transitionTime = tonumber(value2);

		if character == 1 then
			noteTweenAlpha("NoteAlpha2", 1, -1, transitionTime, linear)
			noteTweenAlpha("NoteAlpha4", 3, -1, transitionTime, linear)
			noteTweenAlpha("NoteAlpha3", 2, -1, transitionTime, linear)
			noteTweenAlpha("NoteAlpha1", 0, -1, transitionTime, linear)
		end

		if character == 1.5 then
			noteTweenAlpha("NoteAlpha2", 1, 1, transitionTime, linear)
			noteTweenAlpha("NoteAlpha4", 3, 1, transitionTime, linear)
			noteTweenAlpha("NoteAlpha3", 2, 1, transitionTime, linear)
			noteTweenAlpha("NoteAlpha1", 0, 1, transitionTime, linear)
		end

		if character == 2 then
			noteTweenAlpha("NoteAlpha5", 4, -1, transitionTime, linear)
			noteTweenAlpha("NoteAlpha6", 5, -1, transitionTime, linear)
			noteTweenAlpha("NoteAlpha7", 6, -1, transitionTime, linear)
			noteTweenAlpha("NoteAlpha8", 7, -1, transitionTime, linear)
		end

		if character == 2.5 then
			noteTweenAlpha("NoteAlpha5", 4, 0.4, transitionTime, linear)
			noteTweenAlpha("NoteAlpha6", 5, 0.4, transitionTime, linear)
			noteTweenAlpha("NoteAlpha7", 6, 0.4, transitionTime, linear)
			noteTweenAlpha("NoteAlpha8", 7, 0.4, transitionTime, linear)
		end
	end
end