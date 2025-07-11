function onCreate() --Sets the colors at the start
	doTweenColor('TeraWall','wall','00F99F',0.01, 'quadInOut');
    doTweenColor('TeraStage','stage','32D6BF',0.01, 'quadInOut');
end
function onStepHit()
    if curStep == 672 or curStep == 688 or curStep == 698 or curStep == 700 or curStep == 704 or curStep == 719
    or curStep == 726 or curStep == 736 or curStep == 751 or curStep == 761 or curStep == 765 or curStep == 768 
    or curStep == 782 or curStep == 2880 or curStep == 2896 or curStep == 2905 or curStep == 2908
    or curStep == 2912 or curStep == 2928 or curStep == 2934 or curStep == 2944 or curStep == 2960
    or curStep == 2969 or curStep == 2973 or curStep == 2976 or curStep == 2990 or curStep == 2993 or curStep == 2998 then
        stageFlash()
    end
end
function stageFlash()
    doTweenColor('stageFlashStart','stage','00ffff',0.001, 'quadInOut');
    doTweenColor('stageFlashStart2','wall','00ffff',0.001, 'quadInOut');
end
function onTweenCompleted(name)
    if name == 'stageFlashStart' then
doTweenColor('stageFlashEnd','stage','32D6BF',.5, 'quadInOut');
doTweenColor('stageFlashEnd2','wall','00F99F',.5, 'quadInOut');
    end
end