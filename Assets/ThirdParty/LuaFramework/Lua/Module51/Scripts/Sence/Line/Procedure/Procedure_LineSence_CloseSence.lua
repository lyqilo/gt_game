--[[    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2019-08-20 20:05:18
]]
Procedure_LineSence_CloseSence = {}
local self = Procedure_LineSence_CloseSence

self.ProcedureName = "Procedure_LineSence_CloseSence"
self.NextProcedureName = "Procedure_LineSence_OpenSence"

function Procedure_LineSence_CloseSence:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_LineSence_CloseSence:OnAwake()
end

function Procedure_LineSence_CloseSence:OnDestroy()
end

function Procedure_LineSence_CloseSence:OnRuning()
    -- LogicDataSpace.isRoll = false;
    -- LogicDataSpace.isResult = false
    -- SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestStarButtonState.ProcedureName);
    -- SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestUserInfo.ProcedureName);
    -- SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestWinGold.ProcedureName);
    local sence = SenceMgr.FindSence(LineSence.SenceName);
    sence.SenceHost.gameObject:SetActive(false);
    for i = 1, LogicDataSpace.MAX_LINES do
        sence.SenceHost.transform:Find("Line_" .. i).gameObject:SetActive(false);
    end
    local freeEndCall = function()
        LogicDataSpace.lastFreeCount = 0;
        LogicDataSpace.lastFreeWinGold = 0;
        SenceMgr.FindSence(FreeResultSence.SenceName).SenceHost.gameObject:SetActive(false);
        Procedure_MainGameSence_RsqGameStar.isEnterFree = false;
        SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RsqGameStar.ProcedureName);
        local pao = SlotGameEntry.transform:Find("Canvas/FreePaoMa").gameObject;
        pao:SetActive(false);
    end
    if (not LogicDataSpace.freeEnd and LogicDataSpace.lastFreeCount == 0 and LogicDataSpace.FreeGameCount == 0) then
        error("==========免费结束")
        LogicDataSpace.freeEnd = true;
        freeEndCall();
        --SenceMgr.FindSence(FreeResultSence.SenceName).ProMgr:RunProcedure(Procedure_FreeResult_OpenSence.ProcedureName);
        return ;
    end
    if (LogicDataSpace.FreeGameCount <= 0) then
        LogicDataSpace.lastFreeCount = 0;
    end
end