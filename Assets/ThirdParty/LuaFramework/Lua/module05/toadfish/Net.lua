local CEventObject=GameRequire("EventObject");


local _CNet = class("_CNet",CEventObject);

function _CNet.Create(_bullet)
    local obj  = _CNet.New();
    local go = G_GlobalGame._goFactory:createNet(_bullet:NetType(),_bullet:IsOwner());
    go.name = "Net";
    obj:Init(go.transform);
    obj.type    = _bullet:NetType(); --对应的网的类型
    obj.isOwner = _bullet:IsOwner();
    return obj;
end

function _CNet:ctor()
    _CNet.super.ctor(self);
    self.type       = G_GlobalGame.Enum_NetType.Common;
    self.isOwner    = false;
end

function _CNet:Init(transform)
    self.transform = transform;
    self.animator  = transform:GetComponent("ImageAnima");
    self.animator.fSep = G_GlobalGame.GameConfig.SceneConfig.netAnimaInterval;
    self.image     = transform:GetComponent("Image");
    self.animator:SetEndEvent(handler(self,self._actionEnd));
end

function _CNet:Play(_pos,_isOwner)
    self.animator:Play();
    if _isOwner then
        --self.image.color =Color.New(226,249,11,255);
        --self.image.color =Color.New(7,9,246,255);
        --self.image.color =Color.New(255,255,234,255);
        self.image.color =Color.New(255,234,0,255);
    else
        self.image.color =Color.New(255,255,255,255);
    end
    self.transform.localPosition = _pos;
end

function _CNet:_actionEnd()
    --缓存自己
    --通知死亡事件
    self:SendEvent(G_GlobalGame.Enum_EventID.NetActionEnd);
    --删除事件列表
    self:ClearEvent();
end

return _CNet;