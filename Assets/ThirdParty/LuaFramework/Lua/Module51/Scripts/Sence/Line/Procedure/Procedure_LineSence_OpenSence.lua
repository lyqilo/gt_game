--[[    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2019-08-20 20:04:27
]]
Procedure_LineSence_OpenSence = {}
local self = Procedure_LineSence_OpenSence

self.ProcedureName = "Procedure_LineSence_OpenSence"
self.NextProcedureName = "Procedure_LineSence_CloseSence"

function Procedure_LineSence_OpenSence:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_LineSence_OpenSence:OnAwake()
end

function Procedure_LineSence_OpenSence:OnDestroy()
end
function Procedure_LineSence_OpenSence.ShowResultInfo()
    coroutine.wait(0.1);
    SlotGameEntry.ShowResultInfo();
end
self.time = 0;
function Procedure_LineSence_OpenSence:OnRuning()
    log("停止转动")
    local sence = SenceMgr.FindSence(LineSence.SenceName);
    self.time = 0.2;
    LogicDataSpace.isResult = true;
    LogicDataSpace.lastHitLineNumber = 0;
    for i = 1, LogicDataSpace.MAX_LINES do
        if (LogicDataSpace.lastHitLine[i] > 0) then
            LogicDataSpace.lastHitLineNumber = LogicDataSpace.lastHitLineNumber + 1;
            sence.SenceHost.transform:Find("Line_" .. i).gameObject:SetActive(true);
        end
    end
    sence.SenceHost.gameObject:SetActive(true);
    LogicDataSpace.UserGold = TableUserInfo._7wGold
    -- LogicDataSpace.UserGold = LogicDataSpace.UserGold + LogicDataSpace.LastWinGold
    local showResult = function()
        SlotGameEntry.ShowResultInfo();
    end
    if (LogicDataSpace.LastWinGold > 0) then
        time = 0.02;
        coroutine.stop(self.ShowResultInfo);
        coroutine.start(self.ShowResultInfo);
        --SlotGameEntry.AddCallBack(0.1, showResult);
    end
    -- SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestStarButtonState.ProcedureName);
    SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestWinGold.ProcedureName);
    local closeLine = function()
        log("设置自动停止变量")
        LogicDataSpace.isRoll = false;
        LogicDataSpace.isResult = false
        SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestStarButtonState.ProcedureName);
        SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestUserInfo.ProcedureName);

        if (LogicDataSpace.MiniGameCount > 0) then
            --TODO 进入小游戏
            SenceMgr.FindSence(MainGameSence.SenceName).SenceHost.transform.parent:Find("SmallGameLoading").gameObject:SetActive(true);
            MainGameSence.PlaySound(MainGameSence.AudioEnum.FrameAppear);
            SlotGameEntry.AddCallBack(3.5, SlotGameEntry.WaitEnterSmallGame);
            return ;
        else
            coroutine.wait(0.1);
            SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RsqGameStar.ProcedureName);
        end
        -- SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestUserInfo.ProcedureName);
        -- SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestWinGold.ProcedureName);
        -- SenceMgr.FindSence(LineSence.SenceName).ProMgr:RunProcedure(Procedure_LineSence_CloseSence.ProcedureName);
        if (not LogicDataSpace.freeEnd and LogicDataSpace.lastFreeCount == 0 and LogicDataSpace.FreeGameCount == 0) then
            error("==========免费结束")
            LogicDataSpace.freeEnd = true;
            local showresult = function()
                coroutine.wait(0.1);
                local freeEndCall = function()
                    LogicDataSpace.lastFreeCount = 0;
                    LogicDataSpace.lastFreeWinGold = 0;
                    SenceMgr.FindSence(FreeResultSence.SenceName).SenceHost.gameObject:SetActive(false);
                    Procedure_MainGameSence_RsqGameStar.isEnterFree = false;
                    SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RsqGameStar.ProcedureName);
                    local pao = SlotGameEntry.transform:Find("Canvas/FreePaoMa").gameObject;
                    pao:SetActive(false);
                end
                freeEndCall();
                --SenceMgr.FindSence(FreeResultSence.SenceName).ProMgr:RunProcedure(Procedure_FreeResult_OpenSence.ProcedureName);
            end
            coroutine.start(self.ShowResult);
            return ;
        end
    end
    coroutine.stop(self.CloseLine);
    coroutine.start(self.CloseLine);
    --coroutine.start(function()
    --    coroutine.wait(time);
    --    closeLine();
    --end);
    --SlotGameEntry.AddCallBack(time, closeLine)
end
function Procedure_LineSence_OpenSence.CloseLine()
    coroutine.wait(self.time);
    log("设置自动停止变量")
    LogicDataSpace.isRoll = false;
    LogicDataSpace.isResult = false
    SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestStarButtonState.ProcedureName);
    SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestUserInfo.ProcedureName);

    if (LogicDataSpace.MiniGameCount > 0) then
        --TODO 进入小游戏
        SenceMgr.FindSence(MainGameSence.SenceName).SenceHost.transform.parent:Find("SmallGameLoading").gameObject:SetActive(true);
        MainGameSence.PlaySound(MainGameSence.AudioEnum.FrameAppear);
        SlotGameEntry.AddCallBack(3.5, SlotGameEntry.WaitEnterSmallGame);
        return ;
    else
        coroutine.wait(0.8);
        SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RsqGameStar.ProcedureName);
    end
    -- SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestUserInfo.ProcedureName);
    -- SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestWinGold.ProcedureName);
    -- SenceMgr.FindSence(LineSence.SenceName).ProMgr:RunProcedure(Procedure_LineSence_CloseSence.ProcedureName);
    if (not LogicDataSpace.freeEnd and LogicDataSpace.lastFreeCount == 0 and LogicDataSpace.FreeGameCount == 0) then
        error("==========免费结束")
        LogicDataSpace.freeEnd = true;
        local showresult = function()
            coroutine.wait(0.1);
            local freeEndCall = function()
                LogicDataSpace.lastFreeCount = 0;
                LogicDataSpace.lastFreeWinGold = 0;
                SenceMgr.FindSence(FreeResultSence.SenceName).SenceHost.gameObject:SetActive(false);
                Procedure_MainGameSence_RsqGameStar.isEnterFree = false;
                SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RsqGameStar.ProcedureName);
                local pao = SlotGameEntry.transform:Find("Canvas/FreePaoMa").gameObject;
                pao:SetActive(false);
            end
            freeEndCall();
            --SenceMgr.FindSence(FreeResultSence.SenceName).ProMgr:RunProcedure(Procedure_FreeResult_OpenSence.ProcedureName);
        end
        coroutine.stop(self.ShowResult);
        coroutine.start(self.ShowResult);
        return ;
    end
end
function Procedure_LineSence_OpenSence.ShowResult()
    coroutine.wait(0.1);
    LogicDataSpace.lastFreeCount = 0;
    LogicDataSpace.lastFreeWinGold = 0;
    SenceMgr.FindSence(FreeResultSence.SenceName).SenceHost.gameObject:SetActive(false);
    Procedure_MainGameSence_RsqGameStar.isEnterFree = false;
    SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RsqGameStar.ProcedureName);
    local pao = SlotGameEntry.transform:Find("Canvas/FreePaoMa").gameObject;
    pao:SetActive(false);
end