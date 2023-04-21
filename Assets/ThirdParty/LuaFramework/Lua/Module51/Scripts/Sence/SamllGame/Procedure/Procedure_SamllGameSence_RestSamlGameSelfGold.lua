Procedure_SamllGameSence_RestSamlGameSelfGold = {}
local self = Procedure_SamllGameSence_RestSamlGameSelfGold

self.ProcedureName = "Procedure_SamllGameSence_RestSamlGameSelfGold"
self.NextProcedureName = ""

function Procedure_SamllGameSence_RestSamlGameSelfGold:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_SamllGameSence_RestSamlGameSelfGold:OnAwake()
end

function Procedure_SamllGameSence_RestSamlGameSelfGold:OnDestroy()
end

function Procedure_SamllGameSence_RestSamlGameSelfGold:OnRuning()
    local sence = SenceMgr.FindSence(SamllGameSence.SenceName);
    sence.SenceHost.transform:Find("SelfGold"):GetComponent('Text').text = GameManager.Formatnumberthousands(LogicDataSpace.UserGold);
end