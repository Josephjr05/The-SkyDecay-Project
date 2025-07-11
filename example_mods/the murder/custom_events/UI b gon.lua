function onEvent(name, value1, value2)
	if name == 'UI b gon' then
		type = tonumber(value1)
		duration = tonumber(value2);
		if duration < 0 then
			duration = 0;
		end

		-- FADE IN 1
		if type == 1 and duration == 0 then
			for i = 0, 4, 1 do
				setPropertyFromGroup('playerStrums', i, 'alpha', tonumber(1))
			end
			for i = 0, 4, 1 do
				setPropertyFromGroup('opponentStrums', i, 'alpha', tonumber(1))
			end

	setProperty('healthBar.alpha',  tonumber(1))
	setProperty('iconP1.alpha',  tonumber(1))
	setProperty('iconP2.alpha',  tonumber(1))
	setProperty('scoreTxt.alpha',  tonumber(1))
	setProperty('timeBar.alpha', tonumber(1))
	setProperty('timeTxt.alpha', tonumber(1))
	setProperty('botplayTxt.alpha', tonumber(1))

		elseif type == 1 and duration > 0 then
			noteTweenAlpha("noteGoneOpp1", 0, 1, duration, "quartInOut");
			noteTweenAlpha("noteGoneOpp2", 1, 1, duration, "quartInOut");
			noteTweenAlpha("noteGoneOpp3", 2, 1, duration, "quartInOut");
			noteTweenAlpha("noteGoneOpp4", 3, 1, duration, "quartInOut");
			noteTweenAlpha("noteGone5", 4, 1, duration, "quartInOut");
			noteTweenAlpha("noteGone6", 5, 1, duration, "quartInOut");
			noteTweenAlpha("noteGone7", 6, 1, duration, "quartInOut");
			noteTweenAlpha("noteGone8", 7, 1, duration, "quartInOut");
			doTweenAlpha('hp', 'healthBar', 1, duration, 'quartInOut')
			doTweenAlpha('hpicon1', 'iconP1', 1, duration, 'quartInOut')
			doTweenAlpha('hpicon2', 'iconP2', 1, duration, 'quartInOut')
			doTweenAlpha('score', 'scoreTxt', 1, duration, 'quartInOut')
			doTweenAlpha('timeBar', 'timeBar', 1, duration, 'quartInOut')
			doTweenAlpha('timeBarTxt', 'timeTxt', 1, duration, 'quartInOut')
			doTweenAlpha('botplytxt', 'botplayTxt', 1, duration, 'quartInOut')
		end

		-- FADE OUT 0
		if type == 0 and duration == 0 then
			for i = 0, 4, 1 do
				setPropertyFromGroup('playerStrums', i, 'alpha',tonumber(1))
			end
			for i = 0, 4, 1 do
				setPropertyFromGroup('opponentStrums', i, 'alpha', tonumber(1))
			end

	setProperty('healthBar.alpha',  tonumber(0))
	setProperty('iconP1.alpha',  tonumber(0))
	setProperty('iconP2.alpha',  tonumber(0))
	setProperty('scoreTxt.alpha',  tonumber(0))
	setProperty('timeBar.alpha', tonumber(0))
	setProperty('timeTxt.alpha', tonumber(0))
	setProperty('botplayTxt.alpha', tonumber(0))

		elseif type == 0 and duration > 0 then
			noteTweenAlpha("noteGoneOpp1", 0, 1, duration, "quartInOut");
			noteTweenAlpha("noteGoneOpp2", 1, 1, duration, "quartInOut");
			noteTweenAlpha("noteGoneOpp3", 2, 1, duration, "quartInOut");
			noteTweenAlpha("noteGoneOpp4", 3, 1, duration, "quartInOut");
			noteTweenAlpha("noteGone5", 4, 1, duration, "quartInOut");
			noteTweenAlpha("noteGone6", 5, 1, duration, "quartInOut");
			noteTweenAlpha("noteGone7", 6, 1, duration, "quartInOut");
			noteTweenAlpha("noteGone8", 7, 1, duration, "quartInOut");
			doTweenAlpha('hp', 'healthBar', 0, duration, 'quartInOut')
			doTweenAlpha('hpicon1', 'iconP1', 0, duration, 'quartInOut')
			doTweenAlpha('hpicon2', 'iconP2', 0, duration, 'quartInOut')
			doTweenAlpha('score', 'scoreTxt', 0, duration, 'quartInOut')
			doTweenAlpha('timeBar', 'timeBar', 0, duration, 'quartInOut')
			doTweenAlpha('timeBarTxt', 'timeTxt', 0, duration, 'quartInOut')
			doTweenAlpha('botplytxt', 'botplayTxt', 0, duration, 'quartInOut')
		end
	end
end

--ORIGINAL CODE NOT MADE BY ME! The original script is called Fade UI (i dont know by who, sorry) and I only modified it!
-- Modified by HavenMari, credits appreciated but not necessary! <3