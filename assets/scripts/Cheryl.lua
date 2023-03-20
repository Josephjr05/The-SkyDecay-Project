local function getModDir() local dir = debug.getinfo(1,"S").source:match([[^@?(.*[\/])[^\/]-$]]):match("/[^/]*/") if (dir ~= '/scripts/' and dir ~= '/data/') then return dir else return '/' end end
local Cheryl = {
    currentText = 'NONE',
    tutorialFinished = true,
    stepDialogue = {},
    flip = false,
    tutorialSteps = 0,
    x = 1000
}
local ToolBox = dofile('mods'..getModDir()..'scripts/Stage-Editor/ToolBox-Sublime.lua')
local dataBase = dofile('mods'..getModDir()..'scripts/dataBase.lua')
function Cheryl.Spawn(x, flip)
    x = x or 1000
    flip = flip or false
    Cheryl.flip = flip
    Cheryl.x = x
    if not dataBase.storageExists('Cheryl') then dataBase.newStorage('Cheryl') end
    Cheryl.tutorialSteps = 0
    Cheryl.tutorialFinished = false
    makeLuaSprite('sttst:Cheryl', 'stageEditor-Assets/Cheryl', x, 0)
    setObjectCamera('sttst:Cheryl', 'other')
    addLuaSprite('sttst:Cheryl')
    setProperty('sttst:Cheryl.y', screenHeight-getProperty('sttst:Cheryl.height'))
    setProperty('sttst:Cheryl.flipX', flip)
end

function Cheryl.Talk(text, color, colors)
    setProperty('sttst:Cheryl.x', Cheryl.x)
    if Cheryl.currentText ~= 'NONE' then
        doTweenAlpha('jimmyco', 'Cheryl_TalkText', 0, 0.2, 'smoothStepInOut')
        runHaxeCode('game.remove(Gradient_Talk_Text_Holder); game.remove(Gradient_Talk_Text_Holder_tempMask);')
    end
    ToolBox.Functions['Make_Quick'].Text('Cheryl_TalkText', text, getProperty('sttst:Cheryl.x'), getProperty('sttst:Cheryl.y'), ToolBox.Variables.preferences.font, color, 20, 'game.camOther', false)
    ToolBox.Functions.multiSet('Cheryl_TalkText', {
        x = Cheryl.x+(Cheryl.flip and getProperty('Cheryl_TalkText.width')/2 or -getProperty('Cheryl_TalkText.width')),
        alpha = 0
    })
    ToolBox.Functions.Gradient('Gradient_Talk_Text_Holder', getProperty('Cheryl_TalkText.x')+getProperty('Cheryl_TalkText.width')/2-(getProperty('Cheryl_TalkText.width')+50)/2, getProperty('Cheryl_TalkText.y')+getProperty('Cheryl_TalkText.height')/2-(getProperty('Cheryl_TalkText.height')+15)/2, getProperty('Cheryl_TalkText.width')+50, getProperty('Cheryl_TalkText.height')+15, colors, 'game.camOther')
    addLuaText('Cheryl_TalkText')
    setProperty('Cheryl_TalkText.antialiasing', true)
    setProperty('sttst:Cheryl.flipX', Cheryl.flip)
    setTextAlignment('Cheryl_TalkText', 'center')
    doTweenAlpha('jimmypo', 'Cheryl_TalkText', 1, 0.2, 'smoothStepInOut')
    Cheryl.currentText = text
    setObjectCamera('Cheryl_TalkText', 'other')
    setObjectOrder('Cheryl_TalkText', 80)
end

function Cheryl.switchStep(step, color, colors)
    Cheryl.tutorialSteps = Cheryl.tutorialSteps + step
    Cheryl.Talk(Cheryl.stepDialogue[Cheryl.tutorialSteps], color, colors)
    dataBase.saveData('Cheryl', 'tutorialSteps', Cheryl.tutorialSteps)
end

function Cheryl.Blah(step)
    if Cheryl.tutorialSteps >= step or Cheryl.tutorialFinished then return true else return false end
end

function Cheryl.Despawn()
    removeLuaSprite('sttst:Cheryl')
    removeLuaText('Cheryl_TalkText')
    runHaxeCode('game.remove(Gradient_Talk_Text_Holder);')
end

return Cheryl