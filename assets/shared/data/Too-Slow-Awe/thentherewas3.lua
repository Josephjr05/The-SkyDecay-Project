

function onStepHit()
    if curStep == 640 then
        doTweenAlpha('tails', 'exeHill/greenhill/tails', 1, 0.05, 'circInOut');
        runTimer('bop', 0.1, 1)
    end
    if curStep == 694 then
        doTweenAlpha('knuckles', 'exeHill/greenhill/knuckles', 1, 0.05, 'circInOut');
        runTimer('beep', 0.1, 1)
    end
    if curStep == 740 then
        doTweenAlpha('eggman', 'exeHill/greenhill/eggman', 1, 0.05, 'circInOut');
        runTimer('boop', 0.1, 1)
    end
    if curStep == 827 then
        doTweenAlpha('all', 'exeHill/greenhill/all', 1, 0.05, 'circInOut');
        runTimer('baap', 0.1, 1)
    end
end

function onTimerCompleted(tag, loop, loopsLeft)
    if tag == 'bop' then
        doTweenAlpha('tails', 'exeHill/greenhill/tails', 0, 4, 'circInOut');
    end
    if tag == 'beep' then
        doTweenAlpha('knuckles', 'exeHill/greenhill/knuckles', 0, 4, 'circInOut');
    end
    if tag == 'boop' then
        doTweenAlpha('eggman', 'exeHill/greenhill/eggman', 0, 4, 'circInOut');
    end
    if tag == 'baap' then
        doTweenAlpha('all', 'exeHill/greenhill/all', 0, 4, 'circInOut');
    end
end