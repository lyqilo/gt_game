require("module51/Scripts/Sence/SamllGameStarSence/Procedure/Procedure_SamllGameStarSence_Default")
require("module51/Scripts/Sence/SamllGameStarSence/Procedure/Procedure_SamllGameStarSence_OpenSence")
require("module51/Scripts/Sence/SamllGameStarSence/Procedure/Procedure_SamllGameStarSence_CloseSence")
SamllGameStarSence = {}
local self = SamllGameStarSence
self.SenceHost = nil
self.SenceName = "SamllGameStarSence";
self.ProMgr = nil;

function SamllGameStarSence.new(args)
    local o = args or {}
    setmetatable(o, {__index = self})
    return self
end

function SamllGameStarSence.OnAwake()
    self.SenceHost = SlotGameEntry.transform:Find("Canvas/SamllGameStar").gameObject;
    self.ProMgr = ProcedureMgr:new();
    self.ProMgr.proMap = {};
    self.ProMgr:LoadProcedure(Procedure_SamllGameStarSence_Default:new())
    self.ProMgr:LoadProcedure(Procedure_SamllGameStarSence_OpenSence:new())
    self.ProMgr:LoadProcedure(Procedure_SamllGameStarSence_CloseSence:new())
    self.ProMgr:RunProcedure(Procedure_SamllGameStarSence_Default.ProcedureName);
end

function SamllGameStarSence.OnDisable()
    self.SenceHost:SetActive(false)
end

function SamllGameStarSence.OnEnable()
    self.SenceHost:SetActive(true)
end
function SamllGameStarSence.OnDestroy()
    destroy(self.SenceHost)
end
