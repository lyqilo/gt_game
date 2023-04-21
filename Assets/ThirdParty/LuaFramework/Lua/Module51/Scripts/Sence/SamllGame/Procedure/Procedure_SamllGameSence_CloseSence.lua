
Procedure_SamllGameSence_CloseSence = {}
local self = Procedure_SamllGameSence_CloseSence

self.ProcedureName = "Procedure_SamllGameSence_CloseSence"
self.NextProcedureName = "Procedure_SamllGameResult_OpenSence"

function Procedure_SamllGameSence_CloseSence:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_SamllGameSence_CloseSence:OnAwake()
end

function Procedure_SamllGameSence_CloseSence:OnDestroy()
end

function Procedure_SamllGameSence_CloseSence:OnRuning()
    LogicDataSpace.lastStopIndex = 1;
    LogicDataSpace.lastStarIndex = 1;
    local sence = SenceMgr.FindSence(SamllGameSence.SenceName);
    sence.SenceHost.gameObject:SetActive(false);
end
