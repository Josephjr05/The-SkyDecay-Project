local newObjects = {}
local charData = {
    dad = {x = 0, y = 0, camPos = {x = 0, y = 0}, extraProperties = {}},
    gf = {x = 0, y = 0, camPos = {x = 0, y = 0}, extraProperties = {}},
    boyfriend = {x = 0, y = 0, camPos = {x = 0, y = 0}, extraProperties = {}}
}
local json = dofile('mods/scripts/JSONLIB.lua')

local close, updateHitbox, setGraphicSize, makeLuaSprite, makeAnimatedLuaSprite, addAnimationByPrefix, makeGraphic, makeLuaText, addLuaText, addLuaSprite, setProperty, getProperty, scaleObject, setObjectCamera, setScrollFactor, setObjectOrder, getObjectOrder, setTextFont, setTextColor, setTextString, setTextSize

function close(...) return ... end
function updateHitbox(...) return ... end
function setGraphicSize(...) return ... end

function makeLuaSprite(tag, path, x, y)
    newObjects[tag] =  {
		path = path,
		camera = 'camGame',

		isAnimated = false,
        isGraphic = false,
		isText = false,

		extraProperties = {},
		x = x,
		y = y
	}
end

function makeAnimatedLuaSprite(tag, path, x, y)
    newObjects[tag] =  {
		path = path,
		camera = 'camGame',

		isAnimated = true,
        isGraphic = false,
		isText = false,

		extraProperties = {},
		animations = {},

		x = x,
		y = y
	}
end

function makeLuaText(tag, text, width, x, y)
    newObjects[tag] = {
		text = text,
		camera = 'camGame',

		isAnimated = false,
		isGraphic = false,
		isText = true,

		hex = 'ffffff',
		size = 8,
		font = 'vcr.ttf',

		extraProperties = {},
		
		x = x,
		y = y
	}
end

function makeGraphic(tag, width, height, hex)
    local pos = {x = 0, y = 0}
    if newObjects[tag] ~= nil then
        pos.x = newObjects[tag].x
        pos.y = newObjects[tag].y
    end
    newObjects[tag] = {
		path = '',
		camera = 'camGame',

		isAnimated = false,
		isGraphic = true,
		isText = false,

		width = width,
		height = height,
		hex = hex,

		extraProperties = {},
		animations = {},

		x = pos.x,
		y = pos.y
	}
end

function addLuaSprite(object, front)
    if newObjects[object] ~= nil then
        local theOrder = 0
        if front then
            for _, __ in pairs(newObjects) do
                theOrder = math.max(__ ~= nil and (__.order ~= nil and __.order or 0) or 0, theOrder)
                debugPrint(theOrder)
            end
            newObjects[object].order = theOrder+1
        else
            theOrder = getfenv().getObjectOrder('gfGroup')
            if getfenv().getObjectOrder('boyfriendGroup') < theOrder then
                theOrder = getfenv().getObjectOrder('boyfriendGroup')
            elseif getfenv().getObjectOrder('dadGroup') < theOrder then
                theOrder = getfenv().getObjectOrder('dadGroup')
            end
            newObjects[object].order = theOrder
        end
    end
end

addLuaText = addLuaSprite

function addAnimationByPrefix(object, animation, prefix, framerate, looped)
    if newObjects[object] ~= nil then
        if newObjects[object].isAnimated then
            newObjects[object].animations[animation] = {
                Prefix = prefix,
                FPS = framerate,
                Looped = looped
            }
        end
    end
end

function setProperty(object, value)
    local leObj = {}
    for property in string.gmatch(object, "([^.]+)") do
        table.insert(leObj, property)
    end
    local fullProperty = object:sub(#leObj[1]+2)

    if newObjects[leObj[1]] ~= nil then
        if fullProperty == 'x' then
            newObjects[leObj[1]].x = value
        elseif fullProperty == 'y' then
            newObjects[leObj[1]].y = value
        else
            newObjects[leObj[1]].extraProperties[fullProperty] = value
        end
    else
        if charData[leObj[1]] ~= nil then
            if fullProperty == 'x' then
                charData[leObj[1]].x = value
            elseif fullProperty == 'y' then
                charData[leObj[1]].y = value
            else
                charData[leObj[1]].extraProperties[fullProperty] = value
            end
        end
    end
end

function getProperty(object)
    local leObj = {}
    for property in string.gmatch(object, "([^.]+)") do
        table.insert(leObj, property)
    end
    local fullProperty = object:sub(#leObj[1]+2)

    if newObjects[leObj[1]] ~= nil then
        if fullProperty == 'x' then
            return newObjects[leObj[1]].x
        elseif fullProperty == 'y' then
            return newObjects[leObj[1]].y
        else
            return newObjects[leObj[1]].extraProperties[fullProperty] ~= nil and newObjects[leObj[1]].extraProperties[fullProperty] or 0
        end
    elseif charData[leObj[1]] ~= nil then
        if fullProperty == 'x' then
            return charData[leObj[1]].x
        elseif fullProperty == 'y' then
            return charData[leObj[1]].y
        else
            return charData[leObj[1]].extraProperties[fullProperty] ~= nil and charData[leObj[1]].extraProperties[fullProperty] or 0
        end
    else
        return getfenv().getProperty(object)
    end
end

function setObjectCamera(object, camera)
    if newObjects[object] ~= nil then
        newObjects[object].camera = camera
    end
end

function setScrollFactor(object, scrollx, scrolly)
    if newObjects[object] ~= nil then
        newObjects[object].extraProperties['scrollFactor.x'] = scrollx
        newObjects[object].extraProperties['scrollFactor.y'] = scrolly
    elseif charData[object] ~= nil then
        charData[object].extraProperties['scrollFactor.x'] = scrollx
        charData[object].extraProperties['scrollFactor.y'] = scrolly
    end
end

function setObjectOrder(object, order)
    if newObjects[object] ~= nil then
        newObjects[object].order = order
    elseif charData[object] ~= nil then
        charData[object].order = order
    end
end

function getObjectOrder(object)
    if newObjects[object] ~= nil then
        return newObjects[object].order
    elseif charData[object] ~= nil then
        return charData[object].order
    else
        return getfenv().getObjectOrder(object)
    end
end

function setTextColor(object, color)
    if newObjects[object] ~= nil then
        if newObjects[object].isText then
            newObjects[object].hex = color
        end
    end
end

function setTextFont(object, font)
    if newObjects[object] ~= nil then
        if newObjects[object].isText then
            newObjects[object].font = font
        end
    end
end

function setTextSize(object, size)
    if newObjects[object] ~= nil then
        if newObjects[object].isText then
            newObjects[object].size = size
        end
    end
end

function setTextString(object, string)
    if newObjects[object] ~= nil then
        if newObjects[object].isText then
            newObjects[object].text = string
        end
    end
end

function scaleObject(object, scalex, scaley, ...)
    if newObjects[object] ~= nil then
        newObjects[object].extraProperties['scale.x'] = scalex
        newObjects[object].extraProperties['scale.y'] = scaley
    elseif charData[object] ~= nil then
        charData[object].extraProperties['scale.x'] = scalex
        charData[object].extraProperties['scale.y'] = scaley
    end
end

local function returnData(fileName)
    local jsonTable = json.parse(getTextFromFile('stages/'..fileName..'.json'))
    charData.dad.x = ((charData.dad.x == 0) and ((jsonTable.opponent ~= nil) and jsonTable.opponent[1] or 0) or charData.dad.x)
    charData.dad.y = ((charData.dad.y == 0) and ((jsonTable.opponent ~= nil) and jsonTable.opponent[2] or 0) or charData.dad.y)
    charData.dad.camPos = ({x = jsonTable.camera_opponent[1], y = jsonTable.camera_opponent[2]} or charData.dad.camPos)

    charData.gf.x = ((charData.gf.x == 0) and ((jsonTable.girlfriend ~= nil) and jsonTable.girlfriend[1] or 0) or charData.gf.x)
    charData.gf.y = ((charData.gf.y == 0) and ((jsonTable.girlfriend ~= nil) and jsonTable.girlfriend[2] or 0) or charData.gf.y)
    charData.gf.camPos = ({x = jsonTable.camera_girlfriend[1], y = jsonTable.camera_girlfriend[2]} or charData.gf.camPos)

    charData.boyfriend.x = ((charData.boyfriend.x == 0) and ((jsonTable.boyfriend ~= nil) and jsonTable.boyfriend[1] or 0) or charData.boyfriend.x)
    charData.boyfriend.y = ((charData.boyfriend.y == 0) and ((jsonTable.boyfriend ~= nil) and jsonTable.boyfriend[2] or 0) or charData.boyfrined.y)+350
    charData.boyfriend.camPos = ({x = jsonTable.camera_boyfriend[1], y = jsonTable.camera_boyfriend[2]} or charData.boyfriend.camPos)

    return {
        isPixelStage = jsonTable.isPixelStage or false,
        defaultZoom = jsonTable.defaultZoom or 1,
        charData = charData,
        newObjects = newObjects,
        onCreate = onCreate or nil,
        onCreatePost = onCreatPost or nil,
        onStartCountdown = onStartCountdown or nil
    }
end