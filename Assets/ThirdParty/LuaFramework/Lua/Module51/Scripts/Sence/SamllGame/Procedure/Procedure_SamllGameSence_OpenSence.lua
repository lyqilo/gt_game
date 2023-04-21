
Procedure_SamllGameSence_OpenSence = {}
local self = Procedure_SamllGameSence_OpenSence

self.ProcedureName = "Procedure_SamllGameSence_OpenSence"
self.NextProcedureName = "Procedure_SamllGameSence_CloseSence"

function Procedure_SamllGameSence_OpenSence:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_SamllGameSence_OpenSence:OnAwake()
end

function Procedure_SamllGameSence_OpenSence:OnDestroy()
end

function Procedure_SamllGameSence_OpenSence:OnRuning()
    local sence = SenceMgr.FindSence(SamllGameSence.SenceName);
    sence.ProMgr:RunProcedure(Procedure_SamllGameSence_RestSamlGameNum.ProcedureName);
    sence.ProMgr:RunProcedure(Procedure_SamllGameSence_RestSamlGameSelfGold.ProcedureName);
    sence.ProMgr:RunProcedure(Procedure_SamllGameSence_RestSamlGameChips.ProcedureName);
    sence.ProMgr:RunProcedure(Procedure_SamllGameSence_RestSamlGameWinGold.ProcedureName);
    sence.SenceHost.gameObject:SetActive(true);
end

