function onEvent(name, value1, value2)
	if name == 'Marble' then
		setProperty('StarDustBG.alpha',0);
        setProperty('StarDustFG.alpha',0);

        setProperty('MarbleBG.alpha',1);
		isPixelStage = true;
	end
end