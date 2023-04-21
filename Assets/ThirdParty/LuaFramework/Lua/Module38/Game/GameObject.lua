local CEventObject = GameRequire__("EventObject");

--local CShadowObject = GameRequire("Shadow");
Toward = {
   TowardLeft = 1,
   TowardRight= 2,
};

local _CGameObject = class("_CGameObject", CEventObject);

function _CGameObject:ctor(_objType,...)
    _CGameObject.super.ctor(self,...);
    self._autoScale = false;
    self._shadowObject = nil;
    self._posX = 0
    self._posY = 0;
    self._posZ = 0;
    self._baseScale = C_Vector3_One;
    self._localScale = C_Vector3_One;
    self._towardScale = 1;
    self._towardWrong = 1;
    self._objType  = _objType;
    self._zOrder=0;
    self._zLayer=0;
    self._baseZOrder = 0;
end


function _CGameObject:GetZOrder()
    return self._zOrder;
end

function _CGameObject:GetBaseZOrder()
    return self._baseZOrder;
end

function _CGameObject:SetZOrder(zOrder,isRenew)
    self._zOrder = zOrder;
    if isRenew then
        self:SetGamePosition(self._posX,self._posY,self._posZ);
    end
end

function _CGameObject:GetZLayer()
    return self._zLayer;
end

function _CGameObject:SetZLayer(zLayer,isRenew)
    self._zLayer = zLayer;
    if isRenew then
        self:SetGamePosition(self._posX,self._posY,self._posZ);
    end
end

--创建影子
function _CGameObject:createShadowObject()
--    self._shadowObject = CShadowObject.New(self);
--    self._shadowObject:SetGameParent(self);
--    return self._shadowObject; 
    self._shadowObject = G_GlobalGame:GetKeyValue(G_GlobalGame.Enum_KeyValue.GetShadowObject,self);
    return self._shadowObject;
end

function _CGameObject:SetGameParent(_parent)
    self:SetParent(self.transfrom);
end

function _CGameObject:SetBaseScale(_scale)
    if type(_scale) == "table" then
        if _scale.x and _scale.y and _scale.z then
            if self._baseScale.x == _scale.x and
                self._baseScale.y == _scale.y and 
                self._baseScale.z == _scale.z then
                return ;
            end
            self._baseScale = Vector3.New(_scale.x,_scale.y,_scale.z);
        else
            if self._baseScale.x == _scale[1] and
                self._baseScale.y == _scale[2] and 
                self._baseScale.z == _scale[3] then
                return ;
            end
            self._baseScale = Vector3.New(_scale[1],_scale[2],_scale[3]);
        end

    else
        if self._baseScale.x == _scale and
            self._baseScale.y == _scale and 
            self._baseScale.z == _scale then
                return ;
        else
            self._baseScale = Vector3.New(_scale,_scale,_scale);
        end
    end
    local rlocal = Vector3.New(self._localScale.x* self._baseScale.x*self._towardScale* self._towardWrong, self._localScale.y * self._baseScale.y
                        ,self._localScale.z* self._baseScale.z);
    self.transform.localScale = rlocal;
end

function _CGameObject:TowardWrong()
    self._towardWrong = -1;
end

function _CGameObject:ChangeXToward()
    self._towardScale = -self._towardScale;
    local rlocal = Vector3.New(self._localScale.x* self._baseScale.x*self._towardScale*self._towardWrong, self._localScale.y * self._baseScale.y
                        ,self._localScale.z* self._baseScale.z);
    self.transform.localScale = rlocal;
end

function _CGameObject:ChangeLeftToward()
    if self._towardScale>0 then
        return ;
    end
    self:ChangeXToward();
end

function _CGameObject:ChangeRightToward()
    if self._towardScale<0 then
        return ;
    end
    self:ChangeXToward();
end

function _CGameObject:GetToward()
    if self._towardScale>0 then
        return Toward.TowardLeft;
    end
    return Toward.TowardRight;
end

--
function _CGameObject:AutoScale()
    self._autoScale = true;
end

--游戏中位置
function _CGameObject:GamePosition()
    return self._posX,self._posY,self._posZ;
end 

function _CGameObject:SetGamePosition(x,y,z)
    self._posX = x;
    self._posY = y;
    self._posZ = z;
    local x1,y1,z1 = G_GlobalGame.FunctionsLib.FUNC_TransformToPosition(x,y,z,self:GetZLayer(),self:GetZOrder());
    self.transform.localPosition = Vector3.New(x1,y1,z1 + self._baseZOrder);
    local scale = G_GlobalGame.FunctionsLib.FUNC_GetFarestScale(0,z);
    if self._autoScale then
        --会进行缩放比例
        self:SetGameLocalScale(scale);
    end
    --影子
    if self._shadowObject then
        --影子跟着动
        self._shadowObject:SetGamePosition(x,0,z);
    end
end

--隐藏
function _CGameObject:Hide()
    _CGameObject.super.Hide(self);
    if self._shadowObject then
        --影子也消失
        self._shadowObject:Hide();
    end
end

--显示
function _CGameObject:Display()
    _CGameObject.super.Display(self);
    if self._shadowObject then
        --影子也显示
        self._shadowObject:Display();
    end
end

--移动位置
function _CGameObject:MovePos(mx,my,mz)
    self._posX = self._posX + mx;
    self._posY = self._posY + my;
    self._posZ = self._posZ + mz;
    self:SetGamePosition(self._posX,self._posY,self._posZ);
end

--设置缩放比例
function _CGameObject:SetGameLocalScale(_scale)
    if type(_scale) == "table" then
        if _scale.x and _scale.y and _scale.z then
            if self._localScale.x == _scale.x and
                self._localScale.y == _scale.y and 
                self._localScale.z == _scale.z then
                return ;
            end
            self._localScale = Vector3.New(_scale.x,_scale.y,_scale.z);
        else
            if self._localScale.x == _scale[1] and
                self._localScale.y == _scale[2] and 
                self._localScale.z == _scale[3] then
                return ;
            end
            self._localScale = Vector3.New(_scale[1],_scale[2],_scale[3]);
        end
        self._localScale = Vector3.New(_scale.x,_scale.y,_scale.z);
    else
        if self._localScale.x == _scale and
            self._localScale.y == _scale and 
            self._localScale.z == _scale then
                return ;
        else
            self._localScale = Vector3.New(_scale,_scale,_scale);
        end
    end
    local rlocal = Vector3.New(self._localScale.x* self._baseScale.x*self._towardScale*self._towardWrong, self._localScale.y * self._baseScale.y
                        ,self._localScale.z* self._baseScale.z);
    self.transform.localScale = rlocal;
end

--游戏缩放
function _CGameObject:GameLocalScale()
    return self._localScale;
end

return _CGameObject;