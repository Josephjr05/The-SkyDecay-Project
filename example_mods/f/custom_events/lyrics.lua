function onCreatePost()
    makeLuaText('Lyrics', (value1), screenWidth, 0, 550)
    setTextAlignment('Lyrics', 'Center')
    addLuaText('Lyrics')
    setTextSize('Lyrics', 25)
    setTextBorder('Lyrics', 5, '000000')
    setTextFont('Lyrics', 'FridayNight.ttf')
end
function onEvent(name, value1, value2)
    if name == 'lyrics' then
        setProperty('Lyrics.scale.x',1.1)
        setProperty('Lyrics.scale.y',1.1)
        setTextString('Lyrics', (value1));
        doTweenX('Lyricss1', 'Lyrics.scale', 1, 0.2, 'QuartOut')
        doTweenY('Lyricss2', 'Lyrics.scale', 1, 0.2, 'QuartOut')
        if value2 == '' then
            --do nothing lol
        else
        setTextColor('Lyrics', (value2))
        end
    end
end