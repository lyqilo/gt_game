--对象基类
local _CObject= class("_CObject");
local idCreator = ID_Creator(1);

--初始化
function _CObject:ctor()
    self.transform  = nil;
    self.gameObject = nil;
    self.lid        = idCreator();
end

--取到ID
function _CObject:LID()
    return self.lid;
end

--缓存游戏对象到Pool
function _CObject:Cache()
    G_GlobalGame:CacheObject(self);
end

--------------------------------------------------------------设置这个对象的爹--------------------------------------------------
function _CObject:SetParent(_parent)
    local localPosition = self.transform.localPosition;
    local localScale    = self.transform.localScale;
    local localRotation = self.transform.localRotation;
    self.transform:SetParent(_parent);
    self.transform.localPosition    = localPosition;
    self.transform.localScale       = localScale;
    self.transform.localRotation    = localRotation;
end

function _CObject:SetParentBySame(_parent)
    self.transform:SetParent(_parent);
end
-------------------------------------------------------------------END-------------------------------------------------------------

--------------------------------------------------------------坐标旋转缩放---------------------------------------------------
function _CObject:Position()
    return self.transform.position;
end 

function _CObject:LocalPosition()
    return self.transform.localPosition;
end

function _CObject:SetPosition(position)
    self.transform.position = position;
end

function _CObject:SetLocalPosition(localPosition)
    self.transform.localPosition = localPosition;
end

function _CObject:Scale()
    return self.transform.scale;
end

function _CObject:LocalScale()
    return self.transform.localScale;
end

function _CObject:SetLocalScale(localScale)
    self.transform.localScale = localScale;
end

function _CObject:SetScale(scale)
    self.transform.scale = scale;
end


function _CObject:LocalRotation()
    return self.transform.localRotation;
end

function _CObject:Rotation()
    return self.transform.rotation;
end

function _CObject:SetLocalRotation(localRotation)
    self.transform.localRotation = localRotation;
end

function _CObject:SetRotation(rotation)
    self.transform.rotation = rotation;
end

function _CObject:EulerAngles()
    return self.transform.eulerAngles;
end

function _CObject:LocalEulerAngles()
    return self.transform.localEulerAngles;
end

function _CObject:SetEulerAngles(eulerAngles)
    self.transform.eulerAngles = eulerAngles;
end

function _CObject:SetLocalEulerAngles(localEulerAngles)
    self.transform.localEulerAngles = localEulerAngles;
end

-------------------------------------------------------------END--------------------------------------------------------------------------

------------------------------------------------------------隐藏，出现--------------------------------------------------------------------
function _CObject:Display()
    self.transform.gameObject:SetActive(true);
end

function _CObject:Hide()
    self.transform.gameObject:SetActive(false);
end

function _CObject:Destroy()
    if self.gameObject then
        destroy(self.gameObject);
    end
end
------------------------------------------------------------END----------------------------------------------------------------------------

function _CObject:Update(_dt)

end

return _CObject;