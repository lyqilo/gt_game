local _l_value = nil;

local _CKeyEvent = class("KeyEvent");

function _CKeyEvent.NewLib()
    if _l_value==nil then
        _l_value = _CKeyEvent.New();
    end
end

function _CKeyEvent.DeleteLib()
    _l_value = nil;
end


function _CKeyEvent:ctor()
    self._valuesMap     = map:new();
end

--键值对
function _CKeyEvent.GetKeyValue(_key,...)
    if not _key then
        return nil;
    end
    local handler = _l_value._valuesMap:value(_key);
    if handler==nil then
        return nil;
    end
    return handler(...);
end

function _CKeyEvent.SetKeyHandler(_key,_handler)
    if not _key then
        return nil;
    end
    if _handler then
        _l_value._valuesMap:assign(_key,_handler);
    else
        _CKeyEvent.RemoveKeyHandler(_key);
    end
end

function _CKeyEvent.RemoveKeyHandler(_key)
    _l_value._valuesMap:erase(_key);
end

return _CKeyEvent;