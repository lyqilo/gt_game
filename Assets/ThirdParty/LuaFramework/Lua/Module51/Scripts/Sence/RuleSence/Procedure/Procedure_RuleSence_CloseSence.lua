Procedure_RuleSence_CloseSence = {}
local self = Procedure_RuleSence_CloseSence

self.ProcedureName = "Procedure_RuleSence_CloseSence"
self.NextProcedureName = "Procedure_RuleSence_OpenSence"

function Procedure_RuleSence_CloseSence:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_RuleSence_CloseSence:OnAwake()
end

function Procedure_RuleSence_CloseSence:OnDestroy()
end

function Procedure_RuleSence_CloseSence:OnRuning()
    SenceMgr.FindSence(RuleSence.SenceName).SenceHost.gameObject:SetActive(false);
end
