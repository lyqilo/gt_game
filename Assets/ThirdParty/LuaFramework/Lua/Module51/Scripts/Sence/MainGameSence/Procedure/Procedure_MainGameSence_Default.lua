Procedure_MainGameSence_Default = {}
local self = Procedure_MainGameSence_Default

self.ProcedureName = "Procedure_MainGameSence_Default"
self.NextProcedureName = "Procedure_MainGameSence_OpenSence"

function Procedure_MainGameSence_Default:new(args)
    local o = args or {}
    setmetatable(o, self)
    self.__index = self
    return self
end

function Procedure_MainGameSence_Default:OnAwake()
    local sence = SenceMgr.FindSence(MainGameSence.SenceName)
    sence.SenceHost.transform:Find("DownInfo/Talk"):GetComponent("Text").text = ""
    sence.SenceHost.transform:Find("DownInfo/WinGold"):GetComponent("Text").text = "0"
    sence.SenceHost.transform:Find("DownInfo/PutBetInfo/AllBet"):GetComponent("Text").text = "0"
    sence.SenceHost.transform:Find("DownInfo/Jackpot"):GetComponent("Text").text = GameManager.Formatnumberthousands(LogicDataSpace.JackpotPool)
    local recBet = function()
        if (LogicDataSpace.isRoll) then
            return ;
        end
        --TODO 显示能量表盘
        MainGameSence.PlaySound(MainGameSence.AudioEnum.BtnClick);
        LogicDataSpace.LastSelectChipsIndex = LogicDataSpace.CurrSeleteChipsIndex;
        LogicDataSpace.CurrSeleteChipsIndex = LogicDataSpace.CurrSeleteChipsIndex - 1
        if (LogicDataSpace.CurrSeleteChipsIndex < 1) then
            LogicDataSpace.CurrSeleteChipsIndex = #LogicDataSpace.ChipsLable
        end
        SenceMgr.FindSence(BetPaworSence.SenceName).ProMgr:RunProcedure(Procedure_BetPaworSence_OpenSence.ProcedureName)
        sence.ProMgr:RunProcedure(Procedure_MainGameSence_RestSeleteChips.ProcedureName);
    end
    SlotGameEntry.luaScripts:AddClick(sence.SenceHost.transform:Find("DownInfo/PutBetInfo/rec").gameObject, recBet)

    local addBet = function()
        if (LogicDataSpace.isRoll) then
            return ;
        end
        --TODO 显示能量表盘
        MainGameSence.PlaySound(MainGameSence.AudioEnum.BtnClick);
        LogicDataSpace.LastSelectChipsIndex = LogicDataSpace.CurrSeleteChipsIndex;
        LogicDataSpace.CurrSeleteChipsIndex = LogicDataSpace.CurrSeleteChipsIndex + 1
        if (LogicDataSpace.CurrSeleteChipsIndex > #LogicDataSpace.ChipsLable) then
            LogicDataSpace.CurrSeleteChipsIndex = 1
        end
        SenceMgr.FindSence(BetPaworSence.SenceName).ProMgr:RunProcedure(Procedure_BetPaworSence_OpenSence.ProcedureName)
        sence.ProMgr:RunProcedure(Procedure_MainGameSence_RestSeleteChips.ProcedureName);
    end
    SlotGameEntry.luaScripts:AddClick(sence.SenceHost.transform:Find("DownInfo/PutBetInfo/add").gameObject, addBet)

    local max = function()
        if (LogicDataSpace.isRoll) then
            return ;
        end
        MainGameSence.PlaySound(MainGameSence.AudioEnum.BtnClick);
        if LogicDataSpace.CurrSeleteChipsIndex == 5 then
            return ;
        end
        LogicDataSpace.LastSelectChipsIndex = LogicDataSpace.CurrSeleteChipsIndex;
        LogicDataSpace.CurrSeleteChipsIndex = #LogicDataSpace.ChipsLable
        SenceMgr.FindSence(BetPaworSence.SenceName).ProMgr:RunProcedure(Procedure_BetPaworSence_OpenSence.ProcedureName)
        sence.ProMgr:RunProcedure(Procedure_MainGameSence_RestSeleteChips.ProcedureName);
    end
    SlotGameEntry.luaScripts:AddClick(sence.SenceHost.transform:Find("DownInfo/MaxPushBet").gameObject, max)

    local comEveTri = Util.AddComponent("EventTriggerListener", sence.SenceHost.transform:Find("DownInfo/StarBtn").gameObject)
    local starDorp = function()
        if (LogicDataSpace.isRoll) then
            return ;
        end
        SlotGameEntry.DorpTime = Util.TickCount
        SlotGameEntry.isStarAutoCheck = true
    end
    local istouch = false;
    local starUp = function()
        if istouch then
            SlotGameEntry.isStarAutoCheck = false
            return
        end
        istouch = true;
        coroutine.start(function()
            coroutine.wait(0.5);
            istouch = false;
        end);
        if (SlotGameEntry.isStarAutoCheck == false and SlotGameEntry.isOpenAutoSelete == true) then
            return
        end
        if (LogicDataSpace.UserGold - LogicDataSpace.ChipsLable[LogicDataSpace.CurrSeleteChipsIndex] * 9 < 0) then
            SlotGameEntry.isStarAutoCheck = false
            MessageBox.CreatGeneralTipsPanel("Your gold coins are insufficient, please recharge", nil);
            return ;
        end
        if (LogicDataSpace.SeleteAutoNumber ~= 0) then
            LogicDataSpace.SeleteAutoNumber = 0;
            SlotGameEntry.isOpenAutoSelete = false
            SlotGameEntry.isStarAutoCheck = false
            sence.ProMgr:RunProcedure(Procedure_MainGameSence_RestStarButtonState.ProcedureName);
            return
        end
        if (LogicDataSpace.isRoll) then
            return ;
        end
        --TODO 只有两种情况 一是时间到了，二是单次点击
        SlotGameEntry.isStarAutoCheck = false
        SlotGameEntry.isOpenAutoSelete = false
        LogicDataSpace.isClickStar = true;
        SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RsqGameStar.ProcedureName);
        LogicDataSpace.isClickStar = false;
    end
    comEveTri.onDown = starDorp
    comEveTri.onUp = starUp

    local help = function()
        MainGameSence.PlaySound(MainGameSence.AudioEnum.BtnClick);
        SenceMgr.FindSence(RuleSence.SenceName).ProMgr:RunProcedure(Procedure_RuleSence_OpenSence.ProcedureName);
    end
    SlotGameEntry.luaScripts:AddClick(sence.SenceHost.transform:Find("DownInfo/RuleBtn").gameObject, help)

    local setting = function()
        MainGameSence.PlaySound(MainGameSence.AudioEnum.BtnClick);
        SenceMgr.FindSence(SettingSence.SenceName).ProMgr:RunProcedure(Procedure_SettingSence_OpenSence.ProcedureName);
    end
    SlotGameEntry.luaScripts:AddClick(sence.SenceHost.transform:Find("DownInfo/SettingBtn").gameObject, setting)

    local quitGame = function()
        MainGameSence.PlaySound(MainGameSence.AudioEnum.BtnClick);
        local tab = GeneralTipsSystem_ShowInfo
        tab._01_Title = "提示";
        tab._02_Content = "是否退出游戏";
        tab._03_ButtonNum = 2;
        tab._04_YesCallFunction = SlotGameEntry.QuitGame
        tab._05_NoCallFunction = nil
        tab.isBig = true;
        MessageBox.CreatGeneralTipsPanel(tab)
    end
    SlotGameEntry.luaScripts:AddClick(sence.SenceHost.transform:Find("DownInfo/ExitGameBtn").gameObject, quitGame)
end

function Procedure_MainGameSence_Default:OnDestroy()
end

function Procedure_MainGameSence_Default:OnRuning()
end