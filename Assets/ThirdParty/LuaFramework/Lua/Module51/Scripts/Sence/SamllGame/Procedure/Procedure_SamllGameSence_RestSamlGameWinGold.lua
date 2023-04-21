Procedure_SamllGameSence_RestSamlGameWinGold = {}
local self = Procedure_SamllGameSence_RestSamlGameWinGold

self.ProcedureName = "Procedure_SamllGameSence_RestSamlGameWinGold"
self.NextProcedureName = ""

function Procedure_SamllGameSence_RestSamlGameWinGold:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_SamllGameSence_RestSamlGameWinGold:OnAwake()
end

function Procedure_SamllGameSence_RestSamlGameWinGold:OnDestroy()
end

function Procedure_SamllGameSence_RestSamlGameWinGold:OnRuning()
    local sence = SenceMgr.FindSence(SamllGameSence.SenceName);
    sence.SenceHost.transform:Find("WinGold"):GetComponent('Text').text = GameManager.Formatnumberthousands(LogicDataSpace.LastWinGold + LogicDataSpace.lastSamlGameWinGold);
end