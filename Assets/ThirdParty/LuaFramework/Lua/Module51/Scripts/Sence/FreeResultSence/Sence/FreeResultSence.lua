require("module51/Scripts/Sence/FreeResultSence/Procedure/Procedure_FreeResult_Default")
require("module51/Scripts/Sence/FreeResultSence/Procedure/Procedure_FreeResult_OpenSence")
require("module51/Scripts/Sence/FreeResultSence/Procedure/Procedure_FreeResult_CloseSence")
FreeResultSence = {}
local self = FreeResultSence
self.SenceHost = nil
self.SenceName = "FreeResultSence";
self.ProMgr = nil;

function FreeResultSence.new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function FreeResultSence.OnAwake()
    self.SenceHost = SlotGameEntry.transform:Find("Canvas/FreeResult").gameObject;
    self.ProMgr = ProcedureMgr:new();
    self.ProMgr.proMap = {}
    self.ProMgr:LoadProcedure(Procedure_FreeResult_Default:new())
    self.ProMgr:LoadProcedure(Procedure_FreeResult_OpenSence:new())
    self.ProMgr:LoadProcedure(Procedure_FreeResult_CloseSence:new())
    self.ProMgr:RunProcedure(Procedure_FreeResult_Default.ProcedureName);
end

function FreeResultSence.OnDisable()
    self.SenceHost:SetActive(false)
end

function FreeResultSence.OnEnable()
    self.SenceHost:SetActive(true)
end
function FreeResultSence.OnDestroy()
    destroy(self.SenceHost)
end
