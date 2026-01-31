function onEvent(name, value1, value2)
	if name == 'greenhill' then
		setProperty('sky.alpha',0);
        setProperty('clouds.alpha',0);
        setProperty('forest.alpha',0);
        setProperty('Tre.alpha',0);
        setProperty('city.alpha',0);
        setProperty('sirens.alpha',0);
        setProperty('bridge.alpha',0);
		setProperty('CBG.alpha',0);

        setProperty('PixelBG.alpha',1);
        setProperty('PixelLAND.alpha',1);
        isPixelStage = true;
	end
end
