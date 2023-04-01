songended = false

function onUpdatePost()
    if songended == false then
    setPropertyFromClass('lime.app.Application', 'current.window.title', 'The SkyDecay Project'..' | Playing: '..getProperty('curSong'))
    end
end
function onDestroy()
    songended = true
    setPropertyFromClass('lime.app.Application', 'current.window.title', 'The SkyDecay Project')
end

function onGameOver()
    songended = true
    setPropertyFromClass('lime.app.Application', 'current.window.title', 'The SkyDecay Project'..' | LOL, YOU DIED')
    return Function_Continue
end