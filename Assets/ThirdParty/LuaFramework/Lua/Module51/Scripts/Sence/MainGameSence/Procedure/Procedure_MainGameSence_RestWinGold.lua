Procedure_MainGameSence_RestWinGold = {}
local self = Procedure_MainGameSence_RestWinGold

self.ProcedureName = "Procedure_MainGameSence_RestWinGold"
self.NextProcedureName = ""

function Procedure_MainGameSence_RestWinGold:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_MainGameSence_RestWinGold:OnAwake()
    local sence = SenceMgr.FindSence(MainGameSence.SenceName);
    sence.SenceHost.transform:Find("DownInfo/Talk"):GetComponent('Text').text = "Good luck next time";
end

function Procedure_MainGameSence_RestWinGold:OnDestroy()
end

function Procedure_MainGameSence_RestWinGold:OnRuning()
    local sence = SenceMgr.FindSence(MainGameSence.SenceName);
    error(LogicDataSpace.LastWinGold);
    sence.SenceHost.transform:Find("DownInfo/WinGold"):GetComponent('Text').text = GameManager.Formatnumberthousands(LogicDataSpace.LastWinGold);
    if (LogicDataSpace.isRoll == true and LogicDataSpace.LastWinGold <= 0 and LogicDataSpace.isResult == true) then
        sence.SenceHost.transform:Find("DownInfo/Talk"):GetComponent('Text').text = "Sad, try again";
        return;
    end
    if (LogicDataSpace.LastWinGold > 0 and LogicDataSpace.isRoll == true and LogicDataSpace.isResult == true) then
        sence.SenceHost.transform:Find("DownInfo/Talk"):GetComponent('Text').text = "Great, <color=#F5D188FF>" .. LogicDataSpace.lastHitLineNumber .. " </color>lines";
        return
    end
    if (LogicDataSpace.isRoll == false and LogicDataSpace.LastWinGold <= 0 and LogicDataSpace.isResult == false) then
        sence.SenceHost.transform:Find("DownInfo/Talk"):GetComponent('Text').text = "Good luck next time";
    end
end