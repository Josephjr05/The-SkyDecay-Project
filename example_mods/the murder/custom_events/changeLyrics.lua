function onEvent(name,value1,value2)
	if name == 'changeLyrics' then
	makeLuaText('bruhtxt', value1, 1250 , 0, 540)
	setTextSize('bruhtxt', 30)
	addLuaText('bruhtxt')
	setObjectCamera('bruhtxt', 'other')
	setTextString(value1)
		if value2 == '' then
		makeLuaSprite('iconpng','lyricicons//bf', 550, 420)
		else
		funniicon = 'lyricicons//' .. value2
		makeLuaSprite('iconpng',funniicon, 550, 420)
		end
	addLuaSprite('iconpng')
	setObjectCamera('iconpng', 'other')
	end
end
