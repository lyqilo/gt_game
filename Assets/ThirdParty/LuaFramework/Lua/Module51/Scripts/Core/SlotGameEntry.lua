require("module51/Scripts/Config/GameConfig")
require("module51/Scripts/LogicData/LogicDataSpace")
require("module51/Scripts/Core/SenceMgr")
require("module51/Scripts/Core/ProcedureMgr")
require("module51/Scripts/Core/ResoureceMgr")
require("module51/Scripts/Sence/FreeResultSence/Sence/FreeResultSence")
require("module51/Scripts/Sence/MainGameSence/Sence/MainGameSence")
require("module51/Scripts/Sence/RuleSence/Sence/RuleSence")
require("module51/Scripts/Sence/SamllGame/Sence/SamllGameSence")
require("module51/Scripts/Sence/SamllGameStarSence/Sence/SamllGameStarSence")
require("module51/Scripts/Sence/SamllGameResultSence/Sence/SamllGameResultSence")
require("module51/Scripts/Sence/SettingSence/Sence/SettingSence")
require("module51/Scripts/Sence/AutoStarSence/Sence/AutoStar")
require("module51/Scripts/Sence/Line/Sence/LineSence")
require("module51/Scripts/Sence/BetPaworSence/Sence/BetPaworSence")
require("module51/Scripts/Sence/RollIcon/Sence/RollIconSence")
require("module51/Scripts/RPC/SpureSlotGameNet")
require("module51/Scripts/Core/Element")
require("module51/Scripts/Core/RollElement")
require("module51/Scripts/Core/SlideObject")

SlotGameEntry = {}
local self = SlotGameEntry
self.luaScripts = nil
self.isStarAutoCheck = false
self.DorpTime = 0
self.isOpenAutoSelete = false
self.localTime = 0
self.dTable = {}
self.RewardLine = {
    { 6, 7, 8, 9, 10 },
    { 1, 2, 3, 4, 5 },
    { 11, 12, 13, 14, 15 },
    { 1, 7, 13, 9, 5 },
    { 11, 7, 3, 9, 15 },
    { 1, 2, 8, 14, 15 },
    { 11, 12, 8, 4, 5 },
    { 6, 12, 8, 4, 10 },
    { 6, 2, 8, 14, 10 },
}

function SlotGameEntry.UpdateLevelGold(data)
    logError("小玛丽等级金币: " .. data)
    LogicDataSpace.UserGold = LogicDataSpace.UserGold + data
end

function SlotGameEntry.Reconnect()
    coroutine.stop(SlotGameEntry.luabhv);
    SceneManager.UnloadSceneAsync(LaunchModule.currentSceneName);
    local apt = SceneManager.LoadSceneAsync(LaunchModule.currentSceneName, LoadSceneMode.Additive)
    SlotGameEntry.luabhv = coroutine.start(function()
        coroutine.wait(0.1);
        if apt.isDone and tostring(SlotGameEntry.transform) == "null" then
            Util.AddComponent("LuaBehaviour", find("SlotGameEntry"));
            self.CloseResultInfo();
            SenceMgr.FindSence(LineSence.SenceName).ProMgr:RunProcedure(Procedure_LineSence_CloseSence.ProcedureName);
            self.showResult = false;
            self.ShowLineAndEffect();
            self.isStart = true;
            self.SetRollShowDefault();
        end
    end);
    --SlotGameEntry.CleanScene();
    --GameObject.DestroyImmediate(SlotGameEntry.transform.gameObject);
    --SlotGameEntry.transform = GameObject.Instantiate(self.defaultRoot.gameObject,self.defaultRoot.transform,false).transform;
    --SlotGameEntry.transform:SetParent(nil);
    --SlotGameEntry.transform.gameObject.name =  "SlotGameEntry";
    --SlotGameEntry.transform.gameObject:SetActive(true);
end

self.jackpotText = nil;
self.currentJackport = 0;
self.jackpotCha = 0;
function SlotGameEntry:Awake(obj)
    if obj == nil or tostring(obj) == "null" then
        obj = find("SlotGameEntry");
    end
    log("===============================1" .. tostring(obj))
    Event.AddListener(HallScenPanel.ReconnectEvent, SlotGameEntry.Reconnect);
    log("===============================1")
    --log(obj.name .. " sence entry")
    --if not self.defaultRoot then
    --    obj.gameObject:SetActive(false);
    --    self.defaultRoot = GameObject.Instantiate(obj.gameObject,obj.transform,false);
    --    self.defaultRoot.transform:SetParent(nil);
    --    obj.gameObject:SetActive(true);
    --end
    SlotGameEntry.transform = obj.transform
    self.luaScripts = SlotGameEntry.transform:GetComponent("LuaBehaviour")
    ResoureceMgr.OnInit();
    GameConfig.new()
    SenceMgr.new()
    LogicDataSpace.new()
    GameConfig.OnInitConfiger()
    LogicDataSpace.OnAwake()
    SenceMgr.RegisterSence(AutoStar.new())
    SenceMgr.RegisterSence(BetPaworSence.new())
    SenceMgr.RegisterSence(MainGameSence.new())
    SenceMgr.RegisterSence(FreeResultSence.new())
    SenceMgr.RegisterSence(RuleSence.new())
    SenceMgr.RegisterSence(SamllGameStarSence.new())
    SenceMgr.RegisterSence(SamllGameResultSence.new())
    SenceMgr.RegisterSence(SettingSence.new())
    SenceMgr.RegisterSence(LineSence.new())
    SenceMgr.RegisterSence(RollIconSence.new())
    SenceMgr.RegisterSence(SamllGameSence.new())

    SpureSlotGameNet.addEventMessage()
    GameManager.PanelRister(obj);
    GameManager.PanelInitSucceed(obj);
    GameManager.GameScenIntEnd();
    --GameSetsBtnInfo.SetPlaySuonaPos(0, 190, 0);
    SpureSlotGameNet.playerLogon()
    self.CloseResultInfo();
    MainGameSence.PlayBgMusic();
    GameSetsPanel:CreateNew(SlotGameEntry.transform:Find("Canvas"));
    LogicDataSpace.LastWinGold = 0
    self.currentJackport = 0;
    SlotGameEntry.transform:GetComponent("CanvasScaler").referenceResolution = Vector2.New(1334, 750);
    SetCanvasScalersMatch(SlotGameEntry.transform:GetComponent("CanvasScaler"), 1)
    SlotGameEntry.transform:Find("Canvas").localRotation = Vector3.New(0, 0, 0);
    Event.AddListener(PanelListModeEven._020LevelUpChangeGoldTicket, self.UpdateLevelGold);

    local go = GameObject.Find("GameManager")
    if (go:GetComponent("AudioSource").clip == nil) then
        local clipName = "snd_bg";
        local clip = ResoureceMgr.FindAudio(clipName);
        go:GetComponent("AudioSource").clip = clip.clip
        go:GetComponent("AudioSource").enabled = false
        go:GetComponent("AudioSource").enabled = true
        go:SetActive(true);

        --[[
        if not (Util.HasKey("MusicValue"))then
            Util.SetString("MusicValue", "1");
        end
         local mv = Util.GetString("MusicValue", 0);
        if not (Util.HasKey("SoundValue"))then
            Util.SetString("SoundValue", "1");
        end
        local sv = Util.GetString("SoundValue", 0);
        GameManager.SetSoundValue(sv, mv)
        ]]
    end
    self.jackpotText = SenceMgr.FindSence(MainGameSence.SenceName).SenceHost.transform:Find("DownInfo/Jackpot"):GetComponent('Text');
    self.jackpotText.text = tostring(LogicDataSpace.JackpotPool);
end
function SlotGameEntry.AddCallBack(dTime, event)
    local unit = {
        attTime = self.localTime,
        time = dTime,
        call = event
    }
    table.insert(self.dTable, unit)
end

function SlotGameEntry.Runing()
    self.localTime = self.localTime + Time.deltaTime
    for i = 1, #self.dTable do
        if (self.dTable[i] ~= nil and self.localTime - self.dTable[i].attTime > self.dTable[i].time) then
            local a = table.remove(self.dTable, i);
            a.call()
        end
    end
end
function SlotGameEntry:Update()
    if self.currentJackport < LogicDataSpace.JackpotPool and LogicDataSpace.JackpotPool > 0 then
        self.currentJackport = self.currentJackport + Time.deltaTime * self.jackpotCha;
        self.jackpotText.text = GameManager.Formatnumberthousands(math.ceil(self.currentJackport));
    end
    self.Runing();
    if (self.isStarAutoCheck == true) then
        if (Util.TickCount - self.DorpTime > 1) then
            self.isStarAutoCheck = false
            --TODO 这里打开选择自动次数
            self.isOpenAutoSelete = true
            SenceMgr.FindSence(AutoStar.SenceName).ProMgr:RunProcedure("Procedure_AutoStarSence_OpenSence")
        end
    end
    for i = 1, #LogicDataSpace.samlGameCenterRoll do
        LogicDataSpace.samlGameCenterRoll[i]:Update();
    end

    for i = 1, #LogicDataSpace.samlGameRollIcon do
        LogicDataSpace.samlGameRollIcon[i]:Update();
    end
    if (#LogicDataSpace.RollElementList <= 0) then
        return
    end
    for i = 1, #LogicDataSpace.RollElementList do
        LogicDataSpace.RollElementList[i]:Update()
    end
end
self.showResult = false;
function SlotGameEntry.ShowResultInfo()
    local wingold = LogicDataSpace.LastWinGold;
    self.transform:Find("Canvas/Result").gameObject:SetActive(true);
    MainGameSence.PlaySound(MainGameSence.AudioEnum.Reward);
    error("中奖：" .. LogicDataSpace.LastWinGold .. "=============总押注:" .. LogicDataSpace.currentchip * 9);
    if LogicDataSpace.LastWinGold >= LogicDataSpace.currentchip * 9 * 10 then
        -- self.transform:Find("Canvas/Result/WinEffect"):GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0, "megawin", false);
        self.transform:Find("Canvas/Result/BigReward").gameObject:SetActive(true);
        self.transform:Find("Canvas/Result/MidReward").gameObject:SetActive(false);
        self.transform:Find("Canvas/Result/NormalReward").gameObject:SetActive(false);
        self.PlayGoldSound();
        self.AddCallBack(0.4, self.PlayGoldSound);
        self.AddCallBack(0.8, self.PlayGoldSound);
    elseif LogicDataSpace.LastWinGold >= LogicDataSpace.currentchip * 9 * 5 and LogicDataSpace.LastWinGold < LogicDataSpace.currentchip * 9 * 10 then
        -- self.transform:Find("Canvas/Result/WinEffect"):GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0, "bigwin", false);
        self.transform:Find("Canvas/Result/MidReward").gameObject:SetActive(true);
        self.transform:Find("Canvas/Result/BigReward").gameObject:SetActive(false);
        self.transform:Find("Canvas/Result/NormalReward").gameObject:SetActive(false);
        self.PlayGoldSound();
        self.AddCallBack(0.4, self.PlayGoldSound);
    elseif LogicDataSpace.LastWinGold > 0 and LogicDataSpace.LastWinGold < LogicDataSpace.currentchip * 9 * 5 then
        local ran = Mathf.Random(1, 3);
        -- self.transform:Find("Canvas/Result/WinEffect"):GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0, "win" .. ran, false);
        self.transform:Find("Canvas/Result/NormalReward").gameObject:SetActive(true);
        self.transform:Find("Canvas/Result/MidReward").gameObject:SetActive(false);
        self.transform:Find("Canvas/Result/BigReward").gameObject:SetActive(false);
        self.PlayGoldSound();
    end
    self.transform:Find("Canvas/Result/SamllGameWinGold").localScale = Vector3.New(1.5, 1.5, 1.5);
    self.transform:Find("Canvas/Result/SamllGameWinGold"):GetComponent("Text").text = "+" .. tostring(wingold);
    log("得分---" .. wingold);
    self.AddCallBack(3, self.CloseResultInfo);
    self.showResult = true;
    self.isStart = false;
    SlotGameEntry.AddCallBack(0.5, self.ShowLineAndEffect);
end
local showline = {};
local showIndex = 1;
self.isStart = false;
function SlotGameEntry.ShowLineAndEffect()
    showline = {};
    showIndex = 1;
    local roll = SenceMgr.FindSence(RollIconSence.SenceName);
    local rolllist = self.transform:Find("Canvas/RewardResult");
    rolllist.gameObject:SetActive(true);
    if self.showResult then
        --展示连线
        for i = 1, rolllist.childCount do
            rolllist:GetChild(i - 1).gameObject:SetActive(false);
        end
        for i = 1, roll.SenceHost.transform.childCount do
            for j = 1, roll.SenceHost.transform:GetChild(i - 1).childCount do
                roll.SenceHost.transform:GetChild(i - 1):GetChild(j - 1):GetComponent("Image").color = Color.gray;
            end
        end
        for i = 1, rolllist.childCount do
            local sprite = ResoureceMgr.FindSpriteRes("SGDZZ_ICON_" .. LogicDataSpace.resultElement[i]);
            rolllist:GetChild(i - 1):GetComponent("Image").sprite = sprite;
            rolllist:GetChild(i - 1).name = sprite.name;
        end
    else
        for i = 1, roll.SenceHost.transform.childCount do
            for j = 1, roll.SenceHost.transform:GetChild(i - 1).childCount do
                roll.SenceHost.transform:GetChild(i - 1):GetChild(j - 1):GetComponent("Image").color = Color.white;
            end
        end
        return ;
    end
    for i = 1, #LogicDataSpace.lastHitLine do
        if LogicDataSpace.lastHitLine[i] > 0 then
            table.insert(showline, #showline + 1, { index = i, data = LogicDataSpace.lastHitLine[i] });
        end
    end
    self.ShowLineResult();
end
function SlotGameEntry.ShowLineResult()
    local rolllist = self.transform:Find("Canvas/RewardResult");
    rolllist.gameObject:SetActive(true);
    for i = 1, rolllist.childCount do
        rolllist:GetChild(i - 1).gameObject:SetActive(false);
    end
    if self.isStart then
        return ;
    end
    local line = SenceMgr.FindSence(LineSence.SenceName);
    if line == nil then
        return
    end
    for i = 1, line.SenceHost.transform.childCount do
        --线
        if showline[showIndex] ~= nil and i == showline[showIndex].index then
            line.SenceHost.transform:GetChild(i - 1).gameObject:SetActive(true);
        else
            line.SenceHost.transform:GetChild(i - 1).gameObject:SetActive(false);
        end
    end
    if showline[showIndex] ~= nil then
        local rollitem = self.RewardLine[showline[showIndex].index];
        local count = 0;
        for i = 1, #rollitem do
            if count < showline[showIndex].data then
                rolllist:GetChild(rollitem[i] - 1).gameObject:SetActive(true);
            else
                rolllist:GetChild(rollitem[i] - 1).gameObject:SetActive(false);
            end
            count = count + 1;
        end
        showIndex = showIndex + 1;
        if showIndex > #showline then
            showIndex = 1;
        end
    end
    SlotGameEntry.AddCallBack(2, self.ShowLineResult);
end
function SlotGameEntry.CloseResultInfo()
    self.transform:Find("Canvas/Result").gameObject:SetActive(false);
    self.transform:Find("Canvas/Result/BigReward").gameObject:SetActive(false);
    self.transform:Find("Canvas/Result/BigReward").gameObject:SetActive(false);
    self.transform:Find("Canvas/Result/NormalReward").gameObject:SetActive(false);
end
function SlotGameEntry.PlayGoldSound()
    MainGameSence.PlaySound(MainGameSence.AudioEnum.BigWin);
end
---刷新场景
function SlotGameEntry.SenceRest(args)
end

---进入场景
function SlotGameEntry.JoinSence(args)
    logYellow("玩家进入场景")
    logTable(args)
    LogicDataSpace.FreeGameCount = args.cbCurFreeGameCount
    LogicDataSpace.lastFreeCount = LogicDataSpace.FreeGameCount;
    LogicDataSpace.MiniGameCount = args.nSmallCount
    LogicDataSpace.ChipsLable = args.nBetonGold
    LogicDataSpace.LastWinGold = args.nFreeGameGold
    LogicDataSpace.FreeTotalCount = args.nFreeGameCotTotal;
    -- LogicDataSpace.CurrSeleteChipsIndex = args.nBetonCount;
    LogicDataSpace.currentchip = args.nMultiple;
    if LogicDataSpace.currentchip == 0 then
        LogicDataSpace.currentchip = LogicDataSpace.ChipsLable[1] * 9;
    end
    SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestUserInfo.ProcedureName)
    SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestStarButtonState.ProcedureName)
    SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestSeleteChips.ProcedureName)
    SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestWinGold.ProcedureName)
    if (LogicDataSpace.MiniGameCount > 0) then
        log("======================================进入小游戏===========================================")
        self.transform:Find("Canvas/SmallGameLoading").gameObject:SetActive(true);
        MainGameSence.PlaySound(MainGameSence.AudioEnum.FrameAppear);
        SlotGameEntry.AddCallBack(3.5, self.WaitEnterSmallGame);
        return
    end
    if (LogicDataSpace.FreeGameCount > 0) then
        log("======================================进入免费===========================================")
        SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestStarButtonState.ProcedureName)
        SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RsqGameStar.ProcedureName)
        return
    end
    if LogicDataSpace.SeleteAutoNumber ~= 0 then
        log("======================================进入自动===========================================")
        SenceMgr.FindSence(AutoStar.SenceName).ProMgr:RunProcedure(Procedure_AutoStarSence_CloseSence.ProcedureName);
    end
end
function SlotGameEntry.WaitEnterSmallGame()
    self.transform:Find("Canvas/SmallGameLoading").gameObject:SetActive(false);
    SenceMgr.FindSence(SamllGameStarSence.SenceName).ProMgr:RunProcedure(Procedure_SamllGameStarSence_OpenSence.ProcedureName);
    SenceMgr.FindSence(SamllGameSence.SenceName).ProMgr:RunProcedure(Procedure_SamllGameSence_OpenSence.ProcedureName);
end
---开始游戏返回
function SlotGameEntry.HandleGameStarResult(args)
    log("===================开始转动====================")
    logTable(args)
    LogicDataSpace.resultElement = args.m_icons
    LogicDataSpace.lastHitLine = args.m_line
    LogicDataSpace.LastWinGold = args.m_nWinGold + args.m_nJackPotValue;
    LogicDataSpace.FreeGameCount = args.m_nFreeTimes
    LogicDataSpace.MiniGameCount = args.m_bSmallGame
    --LogicDataSpace.JackpotPool = args.JackpotPool
    LogicDataSpace.winRate = args.m_nWinPeiLv;
    LogicDataSpace.currentchip = args.m_nMultiple;
    local sence = SenceMgr.FindSence(MainGameSence.SenceName);
    sence.SenceHost.transform:Find("DownInfo/Talk"):GetComponent('Text').text = "Good luck next time";
    sence.SenceHost.transform:Find("DownInfo/WinGold"):GetComponent('Text').text = "0";
    -- error("=========倍率:" .. LogicDataSpace.winRate);
    log("LogicDataSpace.FreeTotalCount:" .. LogicDataSpace.FreeTotalCount);
    if LogicDataSpace.FreeTotalCount == 0 and LogicDataSpace.FreeGameCount > 0 then
        LogicDataSpace.FreeTotalCount = LogicDataSpace.FreeGameCount;
    end
    if LogicDataSpace.FreeGameCount >= 0 then
        if (LogicDataSpace.lastFreeCount > 0) then
            LogicDataSpace.lastFreeWinGold = LogicDataSpace.lastFreeWinGold + LogicDataSpace.LastWinGold;
        end
        if LogicDataSpace.lastFreeCount > 0 then
            LogicDataSpace.freeEnd = false;
        end
        LogicDataSpace.lastFreeCount = LogicDataSpace.FreeGameCount;
    end
    log("LogicDataSpace.lastFreeWinGold:" .. LogicDataSpace.lastFreeWinGold);
    SenceMgr.FindSence(RollIconSence.SenceName).ProMgr:RunProcedure(Procedure_RollIconSence_StarRoll.ProcedureName);
    if LogicDataSpace.lastFreeCount <= 0 then
        SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestStarButtonState.ProcedureName);
    end
end

---开始小游戏返回
function SlotGameEntry.HandleMiniGameStarResult(args)
    LogicDataSpace.IconType = args.nIconType;
    LogicDataSpace.lastStopIndex = SuperSlotMessageTemplete.IconPos[args.nIconType][args.nIconTypeConut];
    LogicDataSpace.MiniGameCount = args.nSmallGameConut;
    LogicDataSpace.lastSamlGameWinGold = args.nGameTatolGold;
    LogicDataSpace.samlCenterResult = args.nIconType4;
    log("开始小游戏 StopIndex :" .. LogicDataSpace.lastStopIndex .. "  Icon:" .. args.nIconType4[1] .. " " .. args.nIconType4[2] .. "  " .. args.nIconType4[3] .. "  " .. args.nIconType4[4]);
    SenceMgr.FindSence(SamllGameSence.SenceName).ProMgr:RunProcedure(Procedure_SamllGameSence_StarRoll.ProcedureName);
    logTable(args);
end

function SlotGameEntry.CleanScene()
    SenceMgr.OnClearSence();
    LogicDataSpace.OnDestroy();
    GameConfig.ExitGame();
    ResoureceMgr.OnQuitGame();
    MessgeEventRegister.Game_Messge_Un();
    Event.RemoveListener(PanelListModeEven._020LevelUpChangeGoldTicket, self.UpdateLevelGold);
    Event.RemoveListener(HallScenPanel.ReconnectEvent, SlotGameEntry.Reconnect);
end

function SlotGameEntry.QuitGame()
    SlotGameEntry.CleanScene();
    GameSetsBtnInfo.LuaGameQuit();
end
function SlotGameEntry.ClickStarButton()
    if (LogicDataSpace.isRoll == true) or not Util.NetAvailable or GameSetsBtnInfo.wait or not Network.IsConnected then
        return
    end
    LogicDataSpace.isRoll = true;
    local chips = LogicDataSpace.ChipsLable[LogicDataSpace.CurrSeleteChipsIndex]
    log("下注：" .. chips)
    SpureSlotGameNet.RsqGameStar(chips)
    self.CloseResultInfo();
    local timer = MainGameSence.PlaySound(MainGameSence.AudioEnum.WheelStart);
    SenceMgr.FindSence(LineSence.SenceName).ProMgr:RunProcedure(Procedure_LineSence_CloseSence.ProcedureName);
    self.showResult = false;
    self.ShowLineAndEffect();
    self.isStart = true;
    self.SetRollShowDefault();
    --LogicDataSpace.LastWinGold = 0
end
function SlotGameEntry.SetRollShowDefault()
    local rolllist = self.transform:Find("Canvas/RewardResult");
    rolllist.gameObject:SetActive(true);
    for i = 1, rolllist.childCount do
        rolllist:GetChild(i - 1).gameObject:SetActive(false);
    end
end