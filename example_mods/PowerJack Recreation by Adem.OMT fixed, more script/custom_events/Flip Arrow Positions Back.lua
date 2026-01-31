function onEvent(name, value1, value2)
    if name == 'Flip Arrow Positions Back' then
        --Moves BF Notes to back to his side.
        noteTweenX('dadTween1', 0, 90, 0.01, 'linear');
        noteTweenX('dadTween2', 1, 205, 0.01, 'linear');
        noteTweenX('dadTween3', 2, 315, 0.01, 'linear');
        noteTweenX('dadTween4', 3, 425, 0.01, 'linear');
        --Moves Opponent Notes to there side.
        noteTweenX('bfTween1', 4, 730, 0.01, 'linear');
        noteTweenX('bfTween2', 5, 845, 0.01, 'linear');
        noteTweenX('bfTween3', 6, 955, 0.01, 'linear');
        noteTweenX('bfTween4', 7, 1065, 0.01, 'linear');
    end     
end