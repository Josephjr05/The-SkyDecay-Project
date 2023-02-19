function onEvent(name, value1, value2)
        healthSet = tonumber(value1);
        subStuff = getProperty('health');
                 if healthSet == null then
                 healthSet = 0.5;
                 end
	if name == 'healthlmao' then
                setProperty('health', subStuff- healthSet);
        end
        end
