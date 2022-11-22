function onEvent(name, value1, value2)
    if name == "GUI Opastity" then
	doTweenAlpha('GUItween', 'camHUD', value1, value2, 'linear');
    end
end