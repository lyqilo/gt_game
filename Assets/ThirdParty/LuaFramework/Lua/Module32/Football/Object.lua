local _CObject= class("_CObject");
local idCreator = ID_Creator(1);


function _CObject:ctor()
    self.transform  = nil;
    self.gameObject = nil;
    self.lid        = idCreator();--1
end

function _CObject:LID()
    return self.lid;
end

function _CObject:NewLID()
    self.lid = idCreator();--2
end

function _CObject:Cache()
    G_GlobalGame:CacheObject(self);
end

--重新使用
function _CObject:ReUse()

end

function _CObject:SetParent(_parent,isNoDone)
    if isNoDone then
        self.transform:SetParent(_parent);
    else
        local localPosition = self.transform.localPosition;
        local localScale    = self.transform.localScale;
        local localRotation = self.transform.localRotation;
        self.transform:SetParent(_parent);
        self.transform.localPosition    = localPosition;
        self.transform.localScale       = localScale;
        self.transform.localRotation    = localRotation;
    end

    --[[
    self.__beforeIndex= self.__index;
    self.__index =function (table ,key)
        if key == "position" then
            if table.transform then
                return table.transform.position;
            end
        elseif key== "localPosition" then
            if table.transform then
                return table.transform.localPosition;
            end
        end
        return table.__beforeIndex(table,key);
    end
    --]]
end

function _CObject:SetParentBySame(_parent)
    local position = self.transform.position;
    local rotation = self.transform.rotation;
    self.transform:SetParent(_parent);
    self.transform.position = position;
    self.transform.rotation = rotation;
end

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

--设置本地大小
function _CObject:SetLocalScale(localScale)
    self.transform.localScale = localScale;
end

--
function _CObject:SetScale(scale)
    self.transform.scale = scale;
end
--
function _CObject:LocalRotation()
    return self.transform.localRotation;
end

--
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

function _CObject:Display()
    self.gameObject:SetActive(true);
end

function _CObject:Hide()
    self.gameObject:SetActive(false);
end

function _CObject:Destroy()
    if self.gameObject then
        destroy(self.gameObject);
    end
end

--每帧执行
function _CObject:Update(_dt)

end

return _CObject;