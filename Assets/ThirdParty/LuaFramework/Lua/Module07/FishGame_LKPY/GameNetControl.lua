local CNet = GameRequire("Net");
local _CGameNetControl = class("_CGameNetControl");

function _CGameNetControl:ctor()
    self._cacheSelfNetPool = vector:new();
    self._cacheOtherNetPool= vector:new();
    self._netMap           = map:new();
    self._deleteListVec    = vector:new();
end

--Net的Pool
function _CGameNetControl:Init(transform)
    self.transform = transform;
    self.gameObject= transform.gameObject;
end

function _CGameNetControl:CreateNet(_bullet)
    local net;
    local _type = _bullet:NetType();
    if _bullet.isOwner then
        local size = self._cacheSelfNetPool:size();
        for i=1,size do
            net = self._cacheSelfNetPool:get(i);
            if net.type == _type then
                self._cacheSelfNetPool:pop(i);
                break;
            end
            net = nil;
        end
        if net~=nil then 
        else
            net = CNet.Create(_bullet)
        end
    else
        local size = self._cacheOtherNetPool:size();
        for i=1,size do
            net = self._cacheOtherNetPool:get(i);
            if net.type == _type then
                self._cacheOtherNetPool:pop(i);
                break;
            end
            net = nil;
        end
        if net~=nil then 

        else
            net = CNet.Create(_bullet)
        end
    end
    net:SetParent(self.transform);
    net:RegEvent(self,self.OnEventNet);
    self._netMap:insert(net.lid,net);
    net:Play(_bullet.transform.localPosition,_bullet.isOwner);
    return net;
end

function _CGameNetControl:OnEventNet(_eventId,_net)
    if _eventId == G_GlobalGame.Enum_EventID.NetActionEnd then
        self._deleteListVec:push_back(_net.lid);
    end
end

function _CGameNetControl:Update(_dt)
    local it = self._deleteListVec:iter();
    local val =it();
    local net ;
    while(val) do
        net = self._netMap:erase(val);
        if net then
            net:Cache();
            if net.isOwner then
                self._cacheSelfNetPool:push_back(net);
            else
                self._cacheOtherNetPool:push_back(net);
            end
        end
        val = it();
    end
    self._deleteListVec:clear();
end

function _CGameNetControl:ClearAllNets()
    local it = self._netMap:iter();
    local val =it();
    local net ;
    while(val) do
        net = self._netMap:value(val);
        if net then
            net:Cache();
            if net.isOwner then
                self._cacheSelfNetPool:push_back(net);
            else
                self._cacheOtherNetPool:push_back(net);
            end
        end
        val = it();
    end
    self._netMap:clear();
    self._deleteListVec:clear();
end

return _CGameNetControl;