--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local BRNN_Event = {}

local self = BRNN_Event

self.Data = {}

function BRNN_Event.AddGameEvent(key, Func)
    if(self.CheckExist(key))then
        logError("Add GameEvent fail, key is repeat")
    else
        self.Data[key] = Func
    end
end

function BRNN_Event.InvokeGameEvent(key)
    if(self.Data[key] ~= nil)then
        self.Data[key]()
    else
        logError("Invoke GameEvent fail, Func is nil")
    end
end

function BRNN_Event.CheckExist(key)
    for k, v in pairs(self.Data)do
        if(k == key and self.Data[k] ~= nil)then
            return true 
        end
    end
    return false
end

function BRNN_Event.RemoveGameEvent(key)
     for k, v in pairs(self.Data)do
        if(k == key)then
            self.Data[k] = nil
            return 
        end
    end
end

function BRNN_Event.RemoveAllGameEvent()
    self.Data = {}
end

return BRNN_Event


--endregion
