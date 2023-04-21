map = {}
map.__index = map

--����һ��map
function map:new()
	local object = {}
	
	setmetatable(object, self)
	--object.__index = self
	
	--��һ��table������key
	object.__keyList = {}
	
	return object
end


--����Ԫ��[����Ѵ��ڸ�key,�����Ķ�����STLһ��]
function map:insert(key, value)
	if(self[key] == nil) then
		self[key] = value
		table.insert(self.__keyList, key)
	end
	return self
end


--����Ԫ��[����Ѵ��ڸ�key,�����µ�value����ԭ�е�value����STL�ġ�[key] = value ���ơ�]
function map:assign(key, value)
	if(self[key] == nil) then
		self[key] = value
		table.insert(self.__keyList, key)
	else
		self[key] = nil
		self[key] = value
	end
	return self
end


--����map��Ԫ�صĸ���
function map:size()
	return table.getn(self.__keyList)
end


--���mapΪ���򷵻�true
function map:empty()
	if(map:size() == 0) then
		return true
	else
		return false
	end
end


--ɾ��һ��Ԫ��,����keyɾ��value��ֻʵ��stl������һ�����ء�
function map:erase(key)
    local val=nil;
	if(self[key] == nil) then
		return val
	else
		for i = 1, table.getn(self.__keyList) do
			if(self.__keyList[i] == key) then
				table.remove(self.__keyList, i)
				break;
			end
		end
        val = self[key];
		self[key] = nil
	end
    return val;
end


--ɾ������Ԫ��
function map:clear()
	for i = 1, self:size() do
		self[self.__keyList[1] ] = nil
		table.remove(self.__keyList, 1)
	end
	
end


--����key���ض�Ӧ��value[lua���У�stl�޴˹���]
function map:value(key)
	return self[key]
end


--���ص���������[lua���У�stl�޴˹���]
function map:iter()
	local i = 0
	local n = self:size()
	return function()
		i = i + 1
		if(i <= n) then
			return self.__keyList[i]
		else
			return nil
		end
	end
end


--����key������key���ڵĵ�������[lua���У�stl�޴˹���]
function map:find(key)
	local idx = 0
	local n = self:size()
	for i = 1, n do
		if(self.__keyList[i] == key) then
			idx = i - 1
			break
		end
	end
	return function()
		idx = idx + 1
		if(idx <= n) then
			return self.__keyList[idx]
		else
			return nil
		end
	end
end



local function _ID_Creator(v)
    if v==nil then
        v=1;
    end
    local beginValue=v-1;
    return function (resetValue)
        if resetValue~=nil then
            if type(resetValue)=="number" then
                beginValue=math.floor(resetValue)-1;
            end
        end
        beginValue = beginValue + 1;
        return beginValue;
    end
end

ID_Creator = _ID_Creator;


function handler(obj,func)
    return function (...)
        return func(obj,...);
    end
end



vector = {}
vector.__index = vector
--����һ��map
function vector:new()
	local object = {}
	setmetatable(object, self)
	return object
end


--�������
function vector:push_back(_value)
	table.insert(self, _value)
	return self
end

--ǰ�����
function vector:push_front(_value)
	local count = #self
	for i=count,1,-1 do
		self[i+1]=self[i]
	end
	self[1]=_value
	return self
end

--��ȡֵ
function vector:get(index)
	return self[index]
end

--�����ƶ�����Ԫ��
function vector:pop(index)
    if index==nil then
        index = #self
    end
	local _value=self[index]
	table.remove(self,index)
	return _value
end

--������ǰ��
function vector:pop_front()
	local _value=self[1]
	table.remove(self,1)
	return _value
end


--����vector��Ԫ�صĸ���
function vector:size()
	return table.getn(self)
end


--���vectorΪ���򷵻�true
function vector:empty()
	if(vector:size() == 0) then
		return true
	else
		return false
	end
end


--ɾ������Ԫ��
function vector:erase(index)
	--[[
	local count = #self
	for i=count,1,-1 do
		self[i+1]=self[i]
	end--]]
	table.remove(self,index)
end


--ɾ������Ԫ��
function vector:clear()
    local count = #self
	for i=count,1,-1 do
		self[i]=nil
	end
end


--���ص���������[lua���У�stl�޴˹���]
function vector:iter()
	local i = 0
	local n = self:size()
	return function()
		i = i + 1
		if(i <= n) then
			return self:get(i)
		else
			return nil
		end
	end
end


--��ѯԪ������һ��λ��
function vector:find(_value)
	local idx = 0
	local n = self:size()
	for i = 1, n do
		if(self[i] == _value) then
			return i
		end
	end
	return -1
end


local EventItem=class("EventItem");
function EventItem:ctor(_obj,_handler)
    self._obj=_obj;
    self._handler=_handler;
    self._isInvalid=false;
end

function EventItem:Done(...)
    if not self._isInvalid and self._obj and self._handler then
        self._handler(self._obj,...);
    end
end

function EventItem:Invalid()
    self._isInvalid=true;
end

local ExternalLibs = {};

local EventSystem=class("EventSystem");

ExternalLibs.EventSystem = EventSystem;

function EventSystem:ctor()
    self._eventMap=map:new();
    self._eventObjMap=map:new();
end

--ע���¼�
function EventSystem:RegEvent(_eventId,_obj,_handler)
    local vec=self._eventMap:value(_eventId);
    if vec==nil then
        vec=vector:new();
        self._eventMap:insert(_eventId,vec);
    end
    local eventItem = EventItem.New(_obj,_handler);
    vec:push_back(eventItem);
    vec = self._eventObjMap:value(_obj);
    if vec==nil then
        vec=vector:new();
        self._eventObjMap:insert(vec);
    end
    vec:push_back(eventItem);
end

--ȥ���¼�
function EventSystem:RemoveEvent(_obj)
    local vec = self._eventObjMap:value(_obj);
    if vec then
        local it=vec:iter();
        local val =it();
        while(val) do
            val:Invalid();
            val=it();
        end
    end
    self._eventObjMap:erase(_obj);
end

--����¼�
function EventSystem:Clear()
    self._eventMap:clear();
    self._eventObjMap:clear();
end

--�ַ��¼�
function EventSystem:DispatchEvent(_eventId,_eventData)
    local vec = self._eventMap:value(_eventId);
    if vec~=nil then
        local it=vec:iter();
        local val =it();
        while(val) do
            val:Done(_eventId,_eventData);
            val=it();
        end
    end
end


return ExternalLibs;