require("module51/Scripts/Sence/RollIcon/Procedure/Procedure_RollIconSence_CloseSence")
require("module51/Scripts/Sence/RollIcon/Procedure/Procedure_RollIconSence_Default")
require("module51/Scripts/Sence/RollIcon/Procedure/Procedure_RollIconSence_OpenSence")
require("module51/Scripts/Sence/RollIcon/Procedure/Procedure_RollIconSence_StarRoll")
require("module51/Scripts/Sence/RollIcon/Procedure/Procedure_RollIconSence_StopRoll")

RollIconSence = {}
local self = RollIconSence
self.SenceHost = nil
self.SenceName = "RollIconSence";
self.ProMgr = nil;

function RollIconSence.new(args)
    local o = args or {}
    setmetatable(o, {__index = self})
    return self
end

function RollIconSence.OnAwake()
    self.SenceHost = SlotGameEntry.transform:Find("Canvas/RollMgr").gameObject;
    self.ProMgr = ProcedureMgr:new();
    self.ProMgr.proMap = {}
    self.ProMgr:LoadProcedure(Procedure_RollIconSence_CloseSence:new())
    self.ProMgr:LoadProcedure(Procedure_RollIconSence_Default:new())
    self.ProMgr:LoadProcedure(Procedure_RollIconSence_OpenSence:new())
    self.ProMgr:LoadProcedure(Procedure_RollIconSence_StarRoll:new())
    self.ProMgr:LoadProcedure(Procedure_RollIconSence_StopRoll:new())
    self.ProMgr:RunProcedure(Procedure_RollIconSence_Default.ProcedureName);
end

function RollIconSence.OnDisable()
    self.SenceHost:SetActive(false)
end

function RollIconSence.OnEnable()
    self.SenceHost:SetActive(true)
end
function RollIconSence.OnDestroy()
    destroy(self.SenceHost)
end
