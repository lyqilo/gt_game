--[[
--֧�ֶ෽����һ���¼�
]]

local EventLib = require "eventlib"

local Event = { }
local events = { }

function Event.AddListener(event, handler)
    if not event or type(event) ~= "string" then
        --error("event key not string")
        return;
    end
    if not handler or type(handler) ~= "function" then
        --error("event value  not  function")
        return;
    end

    local mod = tostring(handler)
    mod = string.format("%d", string.gsub(mod, "function: ", ""))

    if not events[event] then
        events[event] = { }
    else
        --warn("event key repeat��");
    end
    events[event][mod] = EventLib:new(event)
    events[event][mod]:connect(handler)
end


function Event.Brocast(event, ...)
    --if not events[event] then log("event " .. event .. " not find ,brocast event fiall") return end
    if not events[event] then return nil end
    local t = { };
    table.foreach(
    events[event],
    function(k, v)
        table.insert(t, v)
    end
    )
    local a1,a2=nil;
    for i = 1, #t do
        if t[i] ~= nil then a1,a2=t[i]:fire(...) end
    end
    --if(not(a1)) then error("event "..event.."call error"); end
    return a2;
end

function Event.RemoveListener(event, handler)
    if not events[event] then  return end
    if handler == nil then
        table.foreach(
        events[event],
        function(k, v)
            v:disconnect(handler)
            events[event][k] = nil
        end
        );
    else
        local mod = tostring(handler)
        mod = string.format("%d", string.gsub(mod, "function: ", ""))
        events[event][mod]:disconnect(handler)
        events[event][mod] = nil
    end
end

function Event.Exist(event)
    local bl = false;
    table.foreach(events, function(k, v)
        if k == event then
            bl = true;
            return bl;
        end
    end )
    return bl;
end

return Event