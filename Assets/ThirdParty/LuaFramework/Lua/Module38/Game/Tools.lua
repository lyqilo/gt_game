Tools = {};

local luaScript = {};
Tools.LuaScript = luaScript;

function luaScript.AddClick(go,handler,isCheck)
    if isCheck then
        local eventTrigger = go:GetComponent("EventTriggerListener");
        if eventTrigger then
            eventTrigger.onClick  = handler;
            return eventTrigger;
        end
    end
    local eventTrigger = UTIL_ADDCOMPONENT("EventTriggerListener",go);
    eventTrigger.onClick = handler;
    return eventTrigger;
end

function luaScript.AddClickByTransform(transform,handler,isCheck)
    return luaScript.AddClick(transform.gameObject,handler,isCheck)
end

function luaScript.RemoveClick(go,isCheck)
    local eventTrigger = go:GetComponent("EventTriggerListener");
    if eventTrigger then
        eventTrigger.onClick = nil;
    end
    return eventTrigger;
end

function luaScript.RemoveClickByTransform(transform,isCheck)
    return luaScript.RemoveClick(transform.gameObject,isCheck);
end

function luaScript.AddDrag(go,handler1,handler2,isCheck)
    if isCheck then
        local eventTrigger = go:GetComponent("EventTriggerListener");
        if eventTrigger then
            eventTrigger.onBeginDrag = handler1;
            eventTrigger.onEndDrag  = handler2;
            return eventTrigger;
        end
    end
    local eventTrigger=UTIL_ADDCOMPONENT("EventTriggerListener",go);
    eventTrigger.onBeginDrag = handler1;
    eventTrigger.onEndDrag  = handler2;
    return eventTrigger;
end

function luaScript.AddDragByTransform(transform,handler1,handler2,isCheck)
    return luaScript.AddDrag(transform.gameObject,handler1,handler2,isCheck);
end

function luaScript.RemoveDrag(go,isCheck)
    if isCheck then
        local eventTrigger = go:GetComponent("EventTriggerListener");
        if eventTrigger then
            eventTrigger.onBeginDrag = nil;
            eventTrigger.onEndDrag  = nil;
            return eventTrigger;
        end
    end
    local eventTrigger=UTIL_ADDCOMPONENT("EventTriggerListener",go);
    eventTrigger.onBeginDrag = nil;
    eventTrigger.onEndDrag  = nil;
    return eventTrigger;
end

function luaScript.RemoveDragByTransform(transform,isCheck)
    return luaScript.RemoveDrag(transform.gameObject,isCheck);
end



function luaScript.AddPressAndRelease(go,pressHandler,releaseHandler,isCheck)
    if isCheck then
        local eventTrigger = go:GetComponent("EventTriggerListener");
        if eventTrigger then
            eventTrigger.onDown = pressHandler;
            eventTrigger.onUp  = releaseHandler;
            return eventTrigger;
        end
    end
    local eventTrigger=UTIL_ADDCOMPONENT("EventTriggerListener",go);
    eventTrigger.onDown = pressHandler;
    eventTrigger.onUp  = releaseHandler;
    return eventTrigger;
end

function luaScript.AddPressAndReleaseByTransform(transform,pressHandler,releaseHandler,isCheck)
    return luaScript.AddPressAndRelease(transform.gameObject,pressHandler,releaseHandler,isCheck);
end


function luaScript.RemovePressAndRelease(go,isCheck)
    if isCheck then
        local eventTrigger = go:GetComponent("EventTriggerListener");
        if eventTrigger then
            eventTrigger.onDown = nil;
            eventTrigger.onUp  = nil;
            return eventTrigger;
        end
    end
    local eventTrigger=UTIL_ADDCOMPONENT("EventTriggerListener",go);
    eventTrigger.onDown = nil;
    eventTrigger.onUp  = nil;
    return eventTrigger;
end

function luaScript.RemovePressAndReleaseByTransform(transform,isCheck)
    return luaScript.RemovePressAndRelease(transform.gameObject,isCheck);
end

local handler = {};

Tools.Handler = handler;

function handler.Create(obj,handler,...)
    local table = {...};
    if #table==0 then
        return function(...)
            return handler(obj,...);
        end 
    else
        return function(...)
            return handler(obj,unpack(table),...);
        end 
    end
end