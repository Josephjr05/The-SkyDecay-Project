function onCreate()
    addCharacterToList("bfdance", "boyfriend")
	addCharacterToList("gfdance", "gf")
    makeLuaSprite('wallnormal', 'TrashAlley/M4N4G3R5/wall-Normal', -500, -200)
    addLuaSprite('wallnormal', false)

    makeLuaSprite('overlaynormal', 'TrashAlley/M4N4G3R5/overlay-Normal', 0, 0)
    addLuaSprite('overlaynormal', false)
    setObjectCamera("overlaynormal", 'hud')
    setBlendMode("overlaynormal", 'add')

	makeLuaSprite('lightFocus', 'TrashAlley/lightFocus', 120, -550)
    addLuaSprite('lightFocus', false)
	setProperty("lightFocus.alpha", 0)

	makeLuaSprite("BLACK", nil, -500, -500)
	addLuaSprite("BLACK", false)
	makeGraphic("BLACK", 5000, 5000, '000000')
	setProperty("BLACK.alpha", 0)

	makeLuaSprite("RED", nil, 0, -500)
	addLuaSprite("RED", false)
	makeGraphic("RED", 2000, 2000, 'FF0000')
	setProperty("RED.alpha", 0)

	makeLuaSprite("WHITE", nil, 0, 0)
	addLuaSprite("WHITE", true)
	setObjectCamera("WHITE", 'other')
	makeGraphic("WHITE", screenWidth, screenHeight, 'FFFFFF')
	setProperty("WHITE.alpha", 0)

	makeLuaSprite('overlaynormalOTHER', 'TrashAlley/M4N4G3R5/overlay-Normal', 0, 0)
    addLuaSprite('overlaynormalOTHER', false)
    setObjectCamera("overlaynormalOTHER", 'other')
	setProperty("overlaynormalOTHER.alpha", 0)
    setBlendMode("overlaynormalOTHER", 'add')

    makeAnimatedLuaSprite('gfspeaker', 'characters/speaker_assets', 600, 300)
    addAnimationByPrefix('gfspeaker', 'bumpBox', 'bumpBox', 24, false)
    addLuaSprite('gfspeaker', false)

    makeLuaSprite('tvnormal', 'TrashAlley/M4N4G3R5/tvFront-Normal', -150, 650)
    addLuaSprite('tvnormal', true)
end
function onBeatHit()
    playAnim("gfspeaker", "bumpBox", true)
end