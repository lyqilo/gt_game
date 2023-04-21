Procedure_MainGameSence_RestJackpot = {}
local self = Procedure_MainGameSence_RestJackpot

self.ProcedureName = "Procedure_MainGameSence_RestJackpot"
self.NextProcedureName = ""

function Procedure_MainGameSence_RestJackpot:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_MainGameSence_RestJackpot:OnAwake()
end

function Procedure_MainGameSence_RestJackpot:OnDestroy()
end

function Procedure_MainGameSence_RestJackpot:OnRuning()
    local sence = SenceMgr.FindSence(MainGameSence.SenceName);
    sence.SenceHost.transform:Find("DownInfo/Jackpot"):GetComponent('Text').text = GameManager.Formatnumberthousands(LogicDataSpace.JackpotPool);
end