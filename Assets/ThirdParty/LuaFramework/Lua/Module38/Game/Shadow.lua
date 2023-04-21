local _CGameObject = GameRequire__("GameObject");

local _CShadowObject = class("_CShadowObject", _CGameObject);


--单例
local G_Shadow_Instance = nil;

function _CShadowObject:ctor(_masterObject,...)
    _CShadowObject.super.ctor(self,G_GlobalGame.Enum_ObjType.Shadow,...);
    self:AutoScale();
    self._masterObject = _masterObject;
end

function _CShadowObject:_initStyle()
    self.gameObject = G_GlobalGame._goFactory:createShadow();
    self.transform  = self.gameObject.transform;
    self.spriteRender = self.gameObject:GetComponent(SpriteRendererClassType);
end

function _CShadowObject:SetMasterObject(_masterObject)
    self._masterObject = _masterObject;
end

function _CShadowObject:GetZLayer()
    return self._masterObject:GetZLayer();
end

function _CShadowObject:GetZOrder()
    return self._masterObject:GetZOrder();
end

function _CShadowObject:SetGamePosition(x,y,z)
    self._posX = x;
    self._posY = y;
    self._posZ = z;
    local x1,y1,z1 = G_GlobalGame.FunctionsLib.FUNC_TransformToPosition(x,y,z,self._masterObject:GetZLayer(),G_GlobalGame.Enum_ZOrder.Shadow);
    self.transform.localPosition = Vector3.New(x1,y1,z1+self._masterObject:GetBaseZOrder());
    local mx,my,mz = self._masterObject:GamePosition();
    local scale = G_GlobalGame.FunctionsLib.FUNC_GetFarestScale(my,z);
    --会进行缩放比例
    self:SetGameLocalScale(scale);

    local colorY = G_GlobalGame.FunctionsLib.FUNC_GetHightColor(my);
    self.spriteRender.color = COLORNEW(1,1,1,colorY);
end


--重新使用
function _CShadowObject:ReUse()
    G_Shadow_Instance:ReUse(self);
end

local _CShadowMgr = class("_CShadowMgr");

function _CShadowMgr:ctor()
    G_Shadow_Instance = self;

    --注册
    G_GlobalGame:SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetShadowObject,handler(self,self.CreateShadow));
end

function _CShadowMgr:Init(transform)
    self.transform = transform;
    self.gameObject = transform.gameObject;
end

function _CShadowMgr:ReUse(_shadowGO)
    _shadowGO:SetParent(self.transform);
end

function _CShadowMgr:CreateShadow(_masterObject)
    local obj = _CShadowObject.New(_masterObject);
    obj:_initStyle();
    obj:SetParent(self.transform);
    return obj;
end

function _CShadowMgr:Clear()
    G_Shadow_Instance = nil;
end

return _CShadowMgr;
