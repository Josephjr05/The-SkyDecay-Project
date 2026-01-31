function onEvent(name, value1, value2)
	if name == 'Normal' then
		setProperty('sky.alpha',1);
        setProperty('clouds.alpha',1);
        setProperty('city.alpha',1);
        setProperty('forest.alpha',1);
        setProperty('Tre.alpha',1);
        setProperty('sirens.alpha',1);
        setProperty('bridge.alpha',1);
		setProperty('CBG.alpha',1);
		

        setProperty('MarbleBG.alpha',0);
        setProperty('PixelBG.alpha',0);
        setProperty('PixelLAND.alpha',0);
	end
end