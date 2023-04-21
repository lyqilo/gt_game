--[[    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2019-08-20 20:01:21
]]
Procedure_SamllGameResult_OpenSence = {}
local self = Procedure_SamllGameResult_OpenSence

self.ProcedureName = "Procedure_SamllGameResult_OpenSence"
self.NextProcedureName = "Procedure_SamllGameResult_CloseSence"

function Procedure_SamllGameResult_OpenSence:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_SamllGameResult_OpenSence:OnAwake()
end

function Procedure_SamllGameResult_OpenSence:OnDestroy()
end

function Procedure_SamllGameResult_OpenSence:OnRuning()
    MainGameSence.PlaySound(MainGameSence.AudioEnum.Endmali);
    local sence = SenceMgr.FindSence(SamllGameResultSence.SenceName);
    sence.SenceHost.gameObject:SetActive(true);
    sence.SenceHost.transform:Find("GameWinGold"):GetComponent('Text').text = LogicDataSpace.LastWinGold .. "";
    sence.SenceHost.transform:Find("SamllGameWinGold"):GetComponent('Text').text =  LogicDataSpace.lastSamlGameWinGold .. "";
    LogicDataSpace.UserGold = LogicDataSpace.UserGold + LogicDataSpace.lastSamlGameWinGold;
    -- LogicDataSpace.UserGold = LogicDataSpace.UserGold + LogicDataSpace.LastWinGold;
    LogicDataSpace.lastSamlGameWinGold = 0;
    --LogicDataSpace.LastWinGold = 0;
    SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestSeleteChips.ProcedureName);
    SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestWinGold.ProcedureName);
    SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestStarButtonState.ProcedureName);
    SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestUserInfo.ProcedureName);
    local hide = function()
        coroutine.wait(20);
        if sence ~= nil and sence.SenceHost.gameObject.activeSelf then
            sence.ProMgr:RunProcedure(Procedure_SamllGameResult_CloseSence.ProcedureName);
        end
    end
    coroutine.start(hide);
end