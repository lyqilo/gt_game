Procedure_SamllGameSence_RestSamlGameChips = {}
local self = Procedure_SamllGameSence_RestSamlGameChips

self.ProcedureName = "Procedure_SamllGameSence_RestSamlGameChips"
self.NextProcedureName = ""

function Procedure_SamllGameSence_RestSamlGameChips:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_SamllGameSence_RestSamlGameChips:OnAwake()
end

function Procedure_SamllGameSence_RestSamlGameChips:OnDestroy()
end

function Procedure_SamllGameSence_RestSamlGameChips:OnRuning()
    local sence = SenceMgr.FindSence(SamllGameSence.SenceName);
    sence.SenceHost.transform:Find("AllPutBet"):GetComponent('Text').text = GameManager.Formatnumberthousands(LogicDataSpace.currentchip * 9);
end