function onEvent(name, value1, value2)
	if name == 'StarDust' then
        setProperty('AngelBG.alpha',0);
        setProperty('AngelLAND.alpha',0);

        setProperty('StarDustBG.alpha',1);
	end
end