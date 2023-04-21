local _CEventObject = GameRequire__("EventObject");

local _CFollower = class("_CFollower",_CEventObject);

function _CFollower:ctor(...)
    _CFollower.super.ctor(self,...)
    self.gameObject = GAMEOBJECT_NEW();
    self.transform  = self.gameObject.transform;
    self.component  = nil;
    self:initComponent();
end

function _CFollower:Init(transform,BeFollower,offset)
    self.transform:SetParent(transform);
    self.transform.localScale = BeFollower.localScale;
    self.transform.localPosition = BeFollower.localPosition + offset;
    self.transform.rotation = BeFollower.rotation;
    self.beFollower = BeFollower;
    self.beComponent= self:getComponent(BeFollower);
    self.component.sprite   = self.beComponent.sprite;
    self.offsetPos  = offset;
end

function _CFollower:Update(dt)
    self.transform.localScale = self.beFollower.localScale;
    self.transform.localPosition = self.beFollower.localPosition + self.offset;
    self.transform.rotation = self.beFollower.rotation;
    self.component.sprite   = self.beComponent.sprite;
end

function _CFollower:getComponent(transform)
    
end


function _CFollower:initComponent()

end

--消失
function _CFollower:Disappear()

end


local _CImageFollower = class("_CImageFollower",_CFollower);

function _CImageFollower:initComponent()
    self.gameObject:AddComponent(ImageClassType);
end

function _CImageFollower:getComponent(transform)
    return transform:GetComponent(ImageClassType);
end


local _CFollowerControl = class("_CFollowerControl");

function _CFollowerControl:ctor()
    self.followers = {};
    self.imgFollowers = {};
    self.spriteFollowers = {};
end

function _CFollowerControl:CreateImageFollower(transform,beFollower,offset)
    local size = #self.imgFollowers;
    local imgFollower;
    if size>0 then
    else
        imgFollower = _CImageFollower.New();
    end
end

function _CFollowerControl:CreateSpriteRendererFollower(transform,beFollower,offset)

end

function _CFollowerControl:OnEventImageFollower(_eventID,_eventObj)

end

function _CFollowerControl:OnEventSpriteFollower(_eventID,_eventObj)

end

return _CFollowerControl;