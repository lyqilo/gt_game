Procedure_MainGameSence_RsqGameStar = {}
local self = Procedure_MainGameSence_RsqGameStar

self.ProcedureName = "Procedure_MainGameSence_RsqGameStar"
self.NextProcedureName = ""
self.isEnterFree = false;
function Procedure_MainGameSence_RsqGameStar:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_MainGameSence_RsqGameStar:OnAwake()
end

function Procedure_MainGameSence_RsqGameStar:OnDestroy()
end

function Procedure_MainGameSence_RsqGameStar:OnRuning()
    local rest = function()
        SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestStarButtonState.ProcedureName);
        SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestUserInfo.ProcedureName);
        SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestWinGold.ProcedureName);
        SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_LineSence_CloseSence.ProcedureName);

    end
    if (LogicDataSpace.isRoll == true) then
        log("还在转")
        return
    end
    if LogicDataSpace.MiniGameCount > 0 then
        log("准备开始玛丽游戏")
        return ;
    end
    local rsqStar = function()
        --LogicDataSpace.LastWinGold = 0;
        SenceMgr.FindSence(BetPaworSence.SenceName).ProMgr:RunProcedure(Procedure_BetPaworSence_CloseSence.ProcedureName)
        if (#LogicDataSpace.ChipsLable <= 0) then
            return
        end
        logTable(LogicDataSpace.ChipsLable)
        if (LogicDataSpace.UserGold - LogicDataSpace.ChipsLable[LogicDataSpace.CurrSeleteChipsIndex] * 9 < 0) then
            LogicDataSpace.SeleteAutoNumber = 0;
            SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestStarButtonState.ProcedureName);
            MessageBox.CreatGeneralTipsPanel("Your gold coins are insufficient, please recharge", nil);
            return ;
        end
        if LogicDataSpace.FreeGameCount <= 0 then
            LogicDataSpace.UserGold = LogicDataSpace.UserGold - LogicDataSpace.ChipsLable[LogicDataSpace.CurrSeleteChipsIndex] * 9;
        end
        SlotGameEntry.ClickStarButton();
    end
    if (LogicDataSpace.FreeGameCount > 0) then
        local freeLoading = SlotGameEntry.transform:Find("Canvas/FreeGameLoading").gameObject;
        local pao = SlotGameEntry.transform:Find("Canvas/FreePaoMa").gameObject;
        local enterFree = function()
            freeLoading:SetActive(false);
            local waitStart = function()
                coroutine.wait(0.1);
                rest();
                rsqStar();
            end
            coroutine.stop(self.ReStart);
            coroutine.start(self.ReStart);
        end
        if not self.isEnterFree then
            self.isEnterFree = true;
            freeLoading:SetActive(true);
            pao:SetActive(false);
            SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestStarButtonState.ProcedureName);
            SlotGameEntry.AddCallBack(5, enterFree);
        else
            enterFree();
            error("==========免费转动")
        end
        return ;
    else
        if self.isEnterFree then
            return ;
        end
    end
    if (LogicDataSpace.SeleteAutoNumber > 0 or LogicDataSpace.SeleteAutoNumber < 0) then
        log("自动次数：" .. LogicDataSpace.SeleteAutoNumber)
        if (LogicDataSpace.SeleteAutoNumber > 0) then
            --判断是否是有次数的自动旋转
            LogicDataSpace.SeleteAutoNumber = LogicDataSpace.SeleteAutoNumber - 1; -- 如果有次数的自动旋转 则旋转数 -1
            if (LogicDataSpace.SeleteAutoNumber == 0) then
                --次数用完了
                rest();
                return ;
            end
            error("====================")
            local waitStart = function()
                coroutine.wait(0.1);
                rest();
                rsqStar();
            end
            coroutine.stop(self.ReStart);
            coroutine.start(self.ReStart);
            return ;
        end
        if (LogicDataSpace.SeleteAutoNumber < 0) then
            local waitStart = function()
                coroutine.wait(0.1);
                rest();
                rsqStar();
            end
            coroutine.stop(self.ReStart);
            coroutine.start(self.ReStart);
            return ;
        end
        return ;
    end
    if (LogicDataSpace.isClickStar == true) then
        self.rest();
        self.rsqStar();
    end
end
function Procedure_MainGameSence_RsqGameStar.ReStart()
    coroutine.wait(0.1);
    self.rest();
    self.rsqStar();
end
function Procedure_MainGameSence_RsqGameStar.rest()
    SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestStarButtonState.ProcedureName);
    SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestUserInfo.ProcedureName);
    SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestWinGold.ProcedureName);
    SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_LineSence_CloseSence.ProcedureName);
end
function Procedure_MainGameSence_RsqGameStar.rsqStar()
    SenceMgr.FindSence(BetPaworSence.SenceName).ProMgr:RunProcedure(Procedure_BetPaworSence_CloseSence.ProcedureName)
    if (#LogicDataSpace.ChipsLable <= 0) then
        return
    end
    logTable(LogicDataSpace.ChipsLable)
    if (LogicDataSpace.UserGold - LogicDataSpace.ChipsLable[LogicDataSpace.CurrSeleteChipsIndex] * 9 < 0) then
        LogicDataSpace.SeleteAutoNumber = 0;
        SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestStarButtonState.ProcedureName);
        MessageBox.CreatGeneralTipsPanel("Your gold coins are insufficient, please recharge", nil);
        return ;
    end
    if LogicDataSpace.FreeGameCount <= 0 then
        LogicDataSpace.UserGold = LogicDataSpace.UserGold - LogicDataSpace.ChipsLable[LogicDataSpace.CurrSeleteChipsIndex] * 9;
    end
    SlotGameEntry.ClickStarButton();
end