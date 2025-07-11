function onEvent(name, value1, value2)
    if name == 'HUD Switch' and value2 == 'on' then
        noteTweenAlpha('mySpriteTween0', 0, 1, value1, 'linear')
        noteTweenAlpha('mySpriteTween1', 1, 1, value1, 'linear')
        noteTweenAlpha('mySpriteTween2', 2, 1, value1, 'linear')
        noteTweenAlpha('mySpriteTween3', 3, 1, value1, 'linear')
        noteTweenAlpha('mySpriteTween4', 4, 1, value1, 'linear')
        noteTweenAlpha('mySpriteTween5', 5, 1, value1, 'linear')
        noteTweenAlpha('mySpriteTween6', 6, 1, value1, 'linear')
        noteTweenAlpha('mySpriteTween7', 7, 1, value1, 'linear')
    end

    if name == 'HUD Switch' and value2 == 'off' then
        noteTweenAlpha('mySpriteTween0', 0, 0, value1, 'linear')
        noteTweenAlpha('mySpriteTween1', 1, 0, value1, 'linear')
        noteTweenAlpha('mySpriteTween2', 2, 0, value1, 'linear')
        noteTweenAlpha('mySpriteTween3', 3, 0, value1, 'linear')
        noteTweenAlpha('mySpriteTween4', 4, 0, value1, 'linear')
        noteTweenAlpha('mySpriteTween5', 5, 0, value1, 'linear')
        noteTweenAlpha('mySpriteTween6', 6, 0, value1, 'linear')
        noteTweenAlpha('mySpriteTween7', 7, 0, value1, 'linear')
    end
end