local _CObject = GameRequire("Object");

local _CEventObject=class("_CEventObject",_CObject);

function _CEventObject:ctor()
    _CEventObject.super.ctor(self);
    self._eventmap = map:new();
    self._opList  = vector:new();
end

function _CEventObject:Cache()
    _CEventObject.super.Cache(self);
    self:ClearEvent();
end

function _CEventObject:RegEvent(obj,handler)  
    local data={
        obj     = obj,
        handler = handler,
        isAdd   = 1,
    };
    self._opList:push_back(data);
    --self._eventmap:insert(obj,handler);
end

function _CEventObject:RemoveEvent(obj)
    local data = {
        obj   = obj,
        isAdd = 0,   
    };
    self._opList:push_back(data);
end


function _CEventObject:SendEvent(_eventID)
    local it = self._opList:iter();
    local data =it();
    while(data) do
        if (data.isAdd==1) then
            self._eventmap:insert(data.obj,data.handler);
        elseif(data.isAdd==0) then
            self._eventmap:erase(data.obj);
        end
        data = it();
    end
    self._opList:clear();
    it = self._eventmap:iter();
    local key = it();
    local handler;
    while(key) do
        if(IsNil(key.transform)) then
            self._opList:push_back({obj=key,isAdd=0});
        else
            --事件通知
            handler = self._eventmap:value(key);
            handler(key,_eventID,self);
        end
        key = it();
    end
end

function _CEventObject:ClearEvent()
    self._opList:clear();
    self._eventmap:clear();
end

return _CEventObject;