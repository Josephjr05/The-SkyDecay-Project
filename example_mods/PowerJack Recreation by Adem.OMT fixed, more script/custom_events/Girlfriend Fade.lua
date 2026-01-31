-- Event notes hooks
function onEvent(name, value1, value2)
	if name == 'Girlfriend Fade' then
		duration = tonumber(value1);
		if duration < 0 then
			duration = 0;
		end

		targetAlpha = tonumber(value2);
		if duration == 0 then
			setProperty('gf.alpha', targetAlpha);
			setProperty('iconP3.alpha', targetAlpha);
		else
			doTweenAlpha('gfFadeEventTween', 'gf', targetAlpha, duration, 'linear');
			doTweenAlpha('iconGfFadeEventTween', 'iconP3', targetAlpha, duration, 'linear');
		end
		--debugPrint('Event triggered: ', name, duration, targetAlpha);
	end
end