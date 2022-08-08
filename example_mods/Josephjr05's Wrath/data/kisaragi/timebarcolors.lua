function onBeatHit()

     if curBeat %1 == 0 then

        setProperty('timeBar.color', getColorFromHex('00E2FF'))-- put the hex code for the color here
     end

     if curBeat %2 == 0 then

        setProperty('timeBar.color', getColorFromHex('F8A041'))-- put the hex code for the color here

     end

     if curBeat %3 == 0 then

        setProperty('timeBar.color', getColorFromHex('FF0000'))-- put the hex code for the color here

     end

end
