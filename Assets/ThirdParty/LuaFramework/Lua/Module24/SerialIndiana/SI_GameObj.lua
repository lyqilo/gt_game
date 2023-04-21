local GameObj = class("GameObj");

--游戏体
function GameObj:ctor(_class,_type,_obj)
    self._class     = _class;
    self._type      = _type;
    self.transform  = _obj.transform;
    self.gameObject = _obj;
end

--消失
function GameObj:Disapear()

end

--每帧执行
function GameObj:Update(_dt)

end

function GameObj:Hide()
    self.gameObject:SetActive(false);
end

function GameObj:Show()
    self.gameObject:SetActive(true);
end

--游戏体
function GameObj:Obj()
    return self.gameObject;
end

--得到大类型
function GameObj:GetClass()
    return self._class;
end

--得到小类
function GameObj:GetType()
    return self._type;
end

--设置父节点
function GameObj:SetParent(transform)
    self.transform:SetParent(transform);
end

--获取局部坐标
function GameObj:GetLocalPosition()
    return self.transform.localPosition;
end

--获得全局坐标
function GameObj:GetPosition()
    return self.transform.position;
end

--设置局部坐标
function GameObj:SetLocalPosition(localPosition)
    self.transform.localPosition = localPosition;
end

--设置全局坐标
function GameObj:SetPosition(position)
    self.transform.position = position;
end

--设置局部缩放
function GameObj:SetLocalScale(localScale)
    self.transform.localScale = localScale;
end

function GameObj:SetLocalEuler(localEuler)
    self.transform.localEuler = localEuler;
end

function GameObj:SetLocalRotation(localRotation)
    self.transform.localRotation = localRotation;
end

return GameObj;