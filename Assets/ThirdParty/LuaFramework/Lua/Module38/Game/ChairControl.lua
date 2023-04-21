local GameDefine = GameRequire__("GameDefine")

local _C_Chair = class("Chair");

function _C_Chair:ctor()


end




local _C_Chair_Manager = class("ChairManager");

function _C_Chair_Manager:ctor()
    self._chairs = {};
end


function _C_Chair_Manager:init()
    local pCount = GameDefine.PlayerCount();
    for i=1,pCount do
        self._chairs[i] = _C_Chair.New();
    end
end

function _C_Chair_Manager:OnUserEnter()

end


return _C_Chair_Manager;