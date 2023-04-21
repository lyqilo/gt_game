Procedure_MainGameSence_RestUserInfo = {}
local self = Procedure_MainGameSence_RestUserInfo

self.ProcedureName = "Procedure_MainGameSence_RestUserInfo"
self.NextProcedureName = ""

function Procedure_MainGameSence_RestUserInfo:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_MainGameSence_RestUserInfo:OnAwake()
end

function Procedure_MainGameSence_RestUserInfo:OnDestroy()
end

function Procedure_MainGameSence_RestUserInfo:OnRuning()
    local sence = SenceMgr.FindSence(MainGameSence.SenceName);
    sence.SenceHost.transform:Find("DownInfo/SelfGold"):GetComponent('Text').text = GameManager.Formatnumberthousands(LogicDataSpace.UserGold);
    sence.SenceHost.transform:Find("DownInfo/SelfNIck"):GetComponent('Text').text = LogicDataSpace.UserNick;
    if SCPlayerInfo._02bySex == enum_Sex.E_SEX_WOMAN then
        sence.SenceHost.transform:Find("DownInfo/SelfIcon"):GetComponent('Image').sprite = HallScenPanel.nvSprtie;
    else
        sence.SenceHost.transform:Find("DownInfo/SelfIcon"):GetComponent('Image').sprite = HallScenPanel.nanSprtie;
    end
    sence.SenceHost.transform:Find("DownInfo/SelfIcon"):GetComponent('Image').sprite = HallScenPanel.GetHeadIcon();
end