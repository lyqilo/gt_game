require("module51/Scripts/Sence/RuleSence/Procedure/Procedure_RuleSence_Default")
require("module51/Scripts/Sence/RuleSence/Procedure/Procedure_RuleSence_OpenSence")
require("module51/Scripts/Sence/RuleSence/Procedure/Procedure_RuleSence_CloseSence")
require("module51/Scripts/Sence/RuleSence/Procedure/Procedure_RuleSence_RestPageInfo")
RuleSence = {}
local self = RuleSence
self.SenceHost = nil
self.SenceName = "RuleSence";
self.ProMgr = nil;

function RuleSence.new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function RuleSence.OnAwake()
    self.SenceHost = SlotGameEntry.transform:Find("Canvas/Rule").gameObject;
    self.ProMgr = ProcedureMgr:new();
    self.ProMgr.proMap = {};
    self.ProMgr:LoadProcedure(Procedure_RuleSence_Default:new())
    self.ProMgr:LoadProcedure(Procedure_RuleSence_OpenSence:new())
    self.ProMgr:LoadProcedure(Procedure_RuleSence_CloseSence:new())
    self.ProMgr:LoadProcedure(Procedure_RuleSence_RestPageInfo:new())
    self.ProMgr:RunProcedure(Procedure_RuleSence_Default.ProcedureName);
end

function RuleSence.OnDisable()
    self.SenceHost:SetActive(false)
end

function RuleSence.OnEnable()
    self.SenceHost:SetActive(true)
end
function RuleSence.OnDestroy()
    destroy(self.SenceHost)
end
