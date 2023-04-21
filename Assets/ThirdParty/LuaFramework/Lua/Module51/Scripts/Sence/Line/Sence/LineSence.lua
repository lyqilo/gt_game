require("module51/Scripts/Sence/Line/Procedure/Procedure_LineSence_CloseSence")
require("module51/Scripts/Sence/Line/Procedure/Procedure_LineSence_Default")
require("module51/Scripts/Sence/Line/Procedure/Procedure_LineSence_OpenSence")

LineSence = {}
local self = LineSence
self.SenceHost = nil
self.SenceName = "LineSence";
self.ProMgr = nil;

function LineSence.new(args)
    local o = args or {}
    setmetatable(o, {__index = self})
    return self
end

function LineSence.OnAwake()
    self.SenceHost = SlotGameEntry.transform:Find("Canvas/Line").gameObject;
    self.ProMgr = ProcedureMgr:new();
    self.ProMgr.proMap = {}
    self.ProMgr:LoadProcedure(Procedure_LineSence_CloseSence:new())
    self.ProMgr:LoadProcedure(Procedure_LineSence_OpenSence:new())
    self.ProMgr:LoadProcedure(Procedure_LineSence_Default:new())
    self.ProMgr:RunProcedure(Procedure_LineSence_Default.ProcedureName);
end

function LineSence.OnDisable()
    self.SenceHost:SetActive(false)
end

function LineSence.OnEnable()
    self.SenceHost:SetActive(true)
end
function LineSence.OnDestroy()
    destroy(self.SenceHost)
end
