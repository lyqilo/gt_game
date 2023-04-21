local GameObj = GameRequire("SI_GameObj");

local DisappearObj = class("DisappearObj",GameObj);

function DisappearObj:ctor(_type,_obj)
    DisappearObj.super.ctor(self,SI_OBJ_CLASS.Effect,_type,_obj);
    self._imageAnimate = _obj:GetComponent("ImageAnima");
end

--跳
function DisappearObj:Disappear(_handler)
    self._imageAnimate:StopAndRevert();
    self._imageAnimate:Play();
    self._imageAnimate:SetEndEvent(handler(self,self.PlayOver));
    self._handler = _handler;
end

function DisappearObj:PlayAlways()
    self._imageAnimate:StopAndRevert();
    self._imageAnimate:PlayAlways();
end

function DisappearObj:PlayOver()
    if self._handler then
        self._handler(self);
    end
    self._handler=nil;
end

function DisappearObj:StopAndRevert()
    self._imageAnimate:StopAndRevert();
end

return DisappearObj;