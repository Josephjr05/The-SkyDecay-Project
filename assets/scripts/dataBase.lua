local function getModDir() local dir = debug.getinfo(1,"S").source:match([[^@?(.*[\/])[^\/]-$]]):match("/[^/]*/") if (dir ~= '/scripts/' and dir ~= '/data/') then return dir else return '/' end end
local i_ = {new = {}, get = {}}
local _dataBase = {}

function leUnpack(t, i) i = i or 1 return (t[i] ~= nil and t[i]..(i ~= #t and ', '..leUnpack(t, i+1) or leUnpack(t, i+1)) or "") end
function tableToFuncToStr(tbl, edible) return 'function('..(tbl.args ~= nil and leUnpack(tbl.args) or '')..')\n    '..(tbl.content ~= nil and tbl.content)..'\n'..edible..'end' end
function tableToStr(tbl, edible, optimize, bracket) -- leave the other 2 options empty if you dont know what you're doing
    edible, bracket = edible or '', bracket or false
    optimize = (optimize == nil and true or optimize)
    local collapse, deform, returnThis = {'[', ']'}, '"', '{\n'
    for _, v in pairs(tbl) do
        if type(_) == 'string' then if not string.find(_, ' ') and not bracket then collapse = {'', ''} deform = '' else collapse = {'[', ']'} deform = '"' end end
        if type(v) ~= 'table' then
            if type(v) == 'string' then v = string.gsub(('"'..v..'"'), '\n', '\\n') end
            returnThis = returnThis.. (optimize and (edible ..'  ') or '')..collapse[1]..(type(_) == 'number' and _ or deform.._..deform)..collapse[2]..' = '..tostring(v)..',\n'
        else
            local leok = ''
            if (v.args ~= nil) and v.content ~= nil and string.upper(v[1]) == 'FUNCTION' then leok = tableToFuncToStr(v, edible..'  ') else leok = tableToStr(v, optimize and (edible..'  ') or '', optimize, bracket) end
            returnThis = returnThis.. (optimize and (edible ..'  ') or '')..collapse[1]..(type(_) == 'number' and _ or deform.._..deform)..collapse[2]..' = '..leok..',\n'
        end
    end
    return (string.find(returnThis, ',', #returnThis - 2) and returnThis:sub(1, #returnThis - 2) or returnThis)..'\n'..(optimize and (edible) or '')..'}'
end

function i_.new:Data(scriptStorage, variableTag, value)
    local __script = dofile('mods'..getModDir()..'scripts/dataBase-STORAGE.lua')
    local __save, __currentStorage = __script, {}

    if __script[scriptStorage] ~= nil then
        __currentStorage = __script[scriptStorage]
    end

    if variableTag ~= nil then __currentStorage[variableTag] = value end
    __save[scriptStorage] = __currentStorage

    local __file = io.open('mods'..getModDir()..'scripts/dataBase-STORAGE.lua', 'wb')
    __file:write('local Table_Data = \n'..tableToStr(__save, '', true, true)..'\n\nreturn Table_Data')
    __file:close()
end

function i_.new:Storage(scriptStorage)
    local __script = dofile('mods'..getModDir()..'scripts/dataBase-STORAGE.lua')
    i_.new:Data(scriptStorage, '?__', nil)
end
    

function i_.checkStorageExists(scriptStorage)
    local __script = dofile('mods'..getModDir()..'scripts/dataBase-STORAGE.lua')
    if __script[scriptStorage] ~= nil then
        return true
    else
        return false
    end
end

function i_.get:Data(scriptStorage, variableTag, Raw)
    local __script = dofile('mods'..getModDir()..'scripts/dataBase-STORAGE.lua')
    if __script[scriptStorage] ~= nil then
        return __script[scriptStorage][variableTag] ~= nil and __script[scriptStorage][variableTag] or nil
    else
        if not Raw then error('Couldn\'t Find The Storage: '..scriptStorage) else return {} end
    end
end

function _dataBase.saveData(scriptname, variable, value)
    i_.new:Data(scriptname, variable, value)
end

function _dataBase.getData(scriptname, variable, raw)
    return i_.get:Data(scriptname, variable, raw)
end

function _dataBase.storageExists(scriptname)
    return i_.checkStorageExists(scriptname)
end

function _dataBase.newStorage(scriptname)
    if not _dataBase.storageExists(scriptname) then
        i_.new:Storage(scriptname)
    end
end

function _dataBase.changeVariable(scriptname, a, b, c, d, e, f, x)
    local __script = dofile('mods'..getModDir()..'scripts/dataBase-STORAGE.lua')
    if _dataBase.storageExists(scriptname) then
        if b ~= nil then
            if c ~= nil then
                if d ~= nil then
                    if e ~= nil then
                        if f ~= nil then
                            __script[scriptname][a][b][c][d][e][f] = x
                        else
                            __script[scriptname][a][b][c][d][e] = x
                        end
                    else
                        __script[scriptname][a][b][c][d] = x
                    end
                else
                    __script[scriptname][a][b][c] = x
                end
            else
                __script[scriptname][a][b] = x
            end
        else
            __script[scriptname][a] = x
        end
    end
    local __file = io.open('mods'..getModDir()..'scripts/dataBase-STORAGE.lua', 'wb')
    __file:write('local Table_Data = \n'..tableToStr(__script, '', true, true)..'\n\nreturn Table_Data')
    __file:close()
end

function _dataBase.deleteStorage(scriptname)
    local __script = dofile('mods'..getModDir()..'scripts/dataBase-STORAGE.lua')
    if _dataBase.storageExists(scriptname) then
        __script[scriptname] = nil
    else
        error('Error: '..scriptname..' Not Found For Function Argument "scriptname"')
    end
    local __file = io.open('mods'..getModDir()..'scripts/dataBase-STORAGE.lua', 'wb')
    __file:write('local Table_Data = \n'..tableToStr(__script, '', true, true)..'\n\nreturn Table_Data')
    __file:close()
end

function _dataBase.clearStorage(scriptname)
    _dataBase.deleteStorage(scriptname)
    _dataBase.newStorage(scriptname)
end

return _dataBase