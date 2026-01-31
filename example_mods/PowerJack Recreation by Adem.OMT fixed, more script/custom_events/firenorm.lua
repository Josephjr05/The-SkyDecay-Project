function onEvent(name, value1, value2)
	if name == 'firenorm' then
        setProperty('bg2.alpha',1);
        setProperty('sonic.alpha',1);
        setProperty('cahins.alpha',1);

        setProperty('fire.alpha',0);
        setProperty('bg.alpha',0);
	end
end