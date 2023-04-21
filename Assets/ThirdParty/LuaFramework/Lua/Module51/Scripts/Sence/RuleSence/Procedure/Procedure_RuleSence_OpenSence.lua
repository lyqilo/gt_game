Procedure_RuleSence_OpenSence = {}
local self = Procedure_RuleSence_OpenSence
self.ProcedureName = "Procedure_RuleSence_OpenSence"
self.NextProcedureName = "Procedure_RuleSence_CloseSence"

function Procedure_RuleSence_OpenSence:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_RuleSence_OpenSence:OnAwake()
end

function Procedure_RuleSence_OpenSence:OnDestroy()
end

function Procedure_RuleSence_OpenSence:OnRuning()
    SenceMgr.FindSence(RuleSence.SenceName).SenceHost.gameObject:SetActive(true);
end