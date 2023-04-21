local ExternalLibs  = require "Common.ExternalLibs";
local EventSystem = ExternalLibs.EventSystem;


local _CEventSystem = class("EventSystem");

local _l_value = nil;

function _CEventSystem:ctor()
    self._eventSystem   = EventSystem.New();
end

--注册事件
function _CEventSystem.RegEvent(_eventId,_obj,_handler)
    _l_value._eventSystem:RegEvent(_eventId,_obj,_handler);
end
--去掉事件
function _CEventSystem.RemoveEvent(_obj)
    _l_value._eventSystem:RemoveEvent(_obj);
end

--分发事件
function _CEventSystem.DispatchEvent(_eventId,_eventData)
    _l_value._eventSystem:DispatchEvent(_eventId,_eventData);
end

function _CEventSystem.NewLib()
    _l_value = _CEventSystem.New();
    return _l_value;
end

function _CEventSystem.DeleteLib()
    _l_value = nil;
end

return _CEventSystem;
