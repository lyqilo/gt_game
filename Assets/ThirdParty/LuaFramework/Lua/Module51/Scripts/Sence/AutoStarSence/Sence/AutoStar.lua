require("module51/Scripts/Sence/AutoStarSence/Procedure/Procedure_AutoStarSence_CloseSence")
require("module51/Scripts/Sence/AutoStarSence/Procedure/Procedure_AutoStarSence_Default")
require("module51/Scripts/Sence/AutoStarSence/Procedure/Procedure_AutoStarSence_OpenSence")

AutoStar = {}
local self = AutoStar
self.SenceHost = nil
self.SenceName = "AutoStar";
self.ProMgr = nil;

function AutoStar.new(args)
    local o = args or {}
    setmetatable(o, {__index = self})
    return self
end

function AutoStar.OnAwake()
    self.SenceHost = SlotGameEntry.transform:Find("Canvas/AutoStar").gameObject;
    self.ProMgr = ProcedureMgr:new();
    self.ProMgr.proMap = {}
    self.ProMgr:LoadProcedure(Procedure_AutoStarSence_OpenSence:new())
    self.ProMgr:LoadProcedure(Procedure_AutoStarSence_CloseSence:new())
    self.ProMgr:LoadProcedure(Procedure_AutoStarSence_Default:new())
    self.ProMgr:RunProcedure(Procedure_AutoStarSence_Default.ProcedureName);
end

function AutoStar.OnDisable()
    self.SenceHost:SetActive(false)
end

function AutoStar.OnEnable()
    self.SenceHost:SetActive(true)
end
function AutoStar.OnDestroy()
    destroy(self.SenceHost)
end
