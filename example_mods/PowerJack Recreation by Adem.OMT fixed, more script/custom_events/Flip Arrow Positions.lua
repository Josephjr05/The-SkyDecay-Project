function onEvent(name, value1, value2)
    if name == 'Flip Arrow Positions' then
        --Moves BF Notes to Opponent side.
        noteTweenX('bfTween1', 4, 90, 0.01, 'linear');
        noteTweenX('bfTween2', 5, 205, 0.01, 'linear');
        noteTweenX('bfTween3', 6, 315, 0.01, 'linear');
        noteTweenX('bfTween4', 7, 425, 0.01, 'linear');
        --Moves Opponent Notes to BF side.
        noteTweenX('dadTween1', 0, 730, 0.01, 'linear');
        noteTweenX('dadTween2', 1, 845, 0.01, 'linear');
        noteTweenX('dadTween3', 2, 955, 0.01, 'linear');
        noteTweenX('dadTween4', 3, 1065, 0.01, 'linear');
    end     
end