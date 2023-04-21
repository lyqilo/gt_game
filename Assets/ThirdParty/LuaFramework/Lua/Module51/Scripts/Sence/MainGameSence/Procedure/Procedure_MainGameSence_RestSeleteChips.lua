Procedure_MainGameSence_RestSeleteChips = {}
local self = Procedure_MainGameSence_RestSeleteChips

self.ProcedureName = "Procedure_MainGameSence_RestSeleteChips"
self.NextProcedureName = ""

function Procedure_MainGameSence_RestSeleteChips:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_MainGameSence_RestSeleteChips:OnAwake()
end

function Procedure_MainGameSence_RestSeleteChips:OnDestroy()
end

function Procedure_MainGameSence_RestSeleteChips:OnRuning()
    local chips = LogicDataSpace.ChipsLable[LogicDataSpace.CurrSeleteChipsIndex] * 9;
    local sence = SenceMgr.FindSence(MainGameSence.SenceName);
    sence.SenceHost.transform:Find("DownInfo/PutBetInfo/AllBet"):GetComponent("Text").text = GameManager.Formatnumberthousands(chips) .. ""
end