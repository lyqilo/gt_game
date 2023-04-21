Procedure_SamllGameSence_ShowResult = {}
local self = Procedure_SamllGameSence_ShowResult

self.ProcedureName = "Procedure_SamllGameSence_ShowResult"
self.NextProcedureName = "Procedure_SamllGameSence_Node"

function Procedure_SamllGameSence_ShowResult:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_SamllGameSence_ShowResult:OnAwake()
end

function Procedure_SamllGameSence_ShowResult:OnDestroy()
end

function Procedure_SamllGameSence_ShowResult:OnRuning()
    
    local sence = SenceMgr.FindSence(SamllGameSence.SenceName);
    sence.ProMgr:RunProcedure(Procedure_SamllGameSence_RestSamlGameNum.ProcedureName);
    sence.ProMgr:RunProcedure(Procedure_SamllGameSence_RestSamlGameSelfGold.ProcedureName);
    sence.ProMgr:RunProcedure(Procedure_SamllGameSence_RestSamlGameChips.ProcedureName);
    sence.ProMgr:RunProcedure(Procedure_SamllGameSence_RestSamlGameWinGold.ProcedureName);
    if (LogicDataSpace.MiniGameCount > 0) then
        SenceMgr.FindSence(SamllGameSence.SenceName).ProMgr:RunProcedure(Procedure_SamllGameSence_StarGame.ProcedureName);
        return;
    end
    SenceMgr.FindSence(SamllGameSence.SenceName).ProMgr:RunProcedure(Procedure_SamllGameSence_CloseSence.ProcedureName);
    SenceMgr.FindSence(SamllGameResultSence.SenceName).ProMgr:RunProcedure(Procedure_SamllGameResult_OpenSence.ProcedureName);
end