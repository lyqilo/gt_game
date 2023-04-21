Procedure_SamllGameSence_RestSamlGameNum = {}
local self = Procedure_SamllGameSence_RestSamlGameNum

self.ProcedureName = "Procedure_SamllGameSence_RestSamlGameNum"
self.NextProcedureName = ""

function Procedure_SamllGameSence_RestSamlGameNum:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_SamllGameSence_RestSamlGameNum:OnAwake()
end

function Procedure_SamllGameSence_RestSamlGameNum:OnDestroy()
end

function Procedure_SamllGameSence_RestSamlGameNum:OnRuning()
    local sence = SenceMgr.FindSence(SamllGameSence.SenceName);
    sence.SenceHost.transform:Find("RollNum"):GetComponent('Text').text = LogicDataSpace.MiniGameCount.."";
end