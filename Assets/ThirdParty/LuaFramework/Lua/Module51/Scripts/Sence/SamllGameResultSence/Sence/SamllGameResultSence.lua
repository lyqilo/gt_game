require("module51/Scripts/Sence/SamllGameResultSence/Procedure/Procedure_SamllGameResult_Default")
require("module51/Scripts/Sence/SamllGameResultSence/Procedure/Procedure_SamllGameResult_OpenSence")
require("module51/Scripts/Sence/SamllGameResultSence/Procedure/Procedure_SamllGameResult_CloseSence")
SamllGameResultSence = {}
local self = SamllGameResultSence
self.SenceHost = nil
self.SenceName = "SamllGameResultSence";
self.ProMgr = nil;

function SamllGameResultSence.new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function SamllGameResultSence.OnAwake()
    self.SenceHost = SlotGameEntry.transform:Find("Canvas/SamllGameResult").gameObject;
    self.ProMgr = ProcedureMgr:new();
    self.ProMgr.proMap = {};
    self.ProMgr:LoadProcedure(Procedure_SamllGameResult_Default:new())
    self.ProMgr:LoadProcedure(Procedure_SamllGameResult_OpenSence:new())
    self.ProMgr:LoadProcedure(Procedure_SamllGameResult_CloseSence:new())
    self.ProMgr:RunProcedure(Procedure_SamllGameResult_Default.ProcedureName);

end

function SamllGameResultSence.OnDisable()
    self.SenceHost:SetActive(false)
end

function SamllGameResultSence.OnEnable()
    self.SenceHost:SetActive(true)
end
function SamllGameResultSence.OnDestroy()
    destroy(self.SenceHost)
end
