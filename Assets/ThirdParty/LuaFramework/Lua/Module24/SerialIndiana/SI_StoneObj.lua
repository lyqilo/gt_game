local GameObj = GameRequire("SI_GameObj");

--石头对象
local StoneObj = class("StoneObj",GameObj);

function StoneObj:ctor(_type,_obj)
    StoneObj.super.ctor(self,SI_OBJ_CLASS.Stone,_type,_obj);
    self._throwPath = nil;
    self._imageAnimate = _obj:GetComponent("ImageAnima");
end

--跳
function StoneObj:Jump()

end

function StoneObj:PlayAlways()
    self._imageAnimate:StopAndRevert();
    self._imageAnimate:PlayAlways();
end


function StoneObj:StopAndRevert()
    self._imageAnimate:StopAndRevert();
end

return StoneObj;