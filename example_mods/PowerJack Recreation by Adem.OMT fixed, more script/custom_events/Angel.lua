function onEvent(name, value1, value2)
	if name == 'Angel' then
		setProperty('PixelLAND.alpha',0);
        setProperty('PixelBG.alpha',0);

        setProperty('AngelBG.alpha',1);
        setProperty('AngelLAND.alpha',1);
        isPixelStage = true;
	end
end