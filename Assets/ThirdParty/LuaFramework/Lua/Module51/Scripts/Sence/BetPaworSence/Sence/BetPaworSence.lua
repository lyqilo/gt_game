require("module51/Scripts/Sence/BetPaworSence/Procedure/Procedure_BetPaworSence_CloseSence")
require("module51/Scripts/Sence/BetPaworSence/Procedure/Procedure_BetPaworSence_Default")
require("module51/Scripts/Sence/BetPaworSence/Procedure/Procedure_BetPaworSence_OpenSence")

BetPaworSence = {}
local self = BetPaworSence
self.SenceHost = nil
self.SenceName = "BetPaworSence";
self.ProMgr = nil;

function BetPaworSence.new(args)
    local o = args or {}
    setmetatable(o, { __index = self })
    return self
end

function BetPaworSence.OnAwake()
    self.SenceHost = SlotGameEntry.transform:Find("Canvas/GameMainSence/BetPowar").gameObject;
    self.ProMgr = ProcedureMgr:new();
    self.ProMgr.proMap = {}
    self.ProMgr:LoadProcedure(Procedure_BetPaworSence_CloseSence:new())
    self.ProMgr:LoadProcedure(Procedure_BetPaworSence_Default:new())
    self.ProMgr:LoadProcedure(Procedure_BetPaworSence_OpenSence:new())
    self.ProMgr:RunProcedure(Procedure_BetPaworSence_Default.ProcedureName);
end

function BetPaworSence.OnDisable()
    self.SenceHost:SetActive(false)
end

function BetPaworSence.OnEnable()
    self.SenceHost:SetActive(true)
end
function BetPaworSence.OnDestroy()
    destroy(self.SenceHost)
end