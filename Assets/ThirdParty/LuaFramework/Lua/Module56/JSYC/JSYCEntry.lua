-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion
g_sSlotModuleNum = "Module56/JSYC/";

require(g_sSlotModuleNum .. "JSYC_Network")
require(g_sSlotModuleNum .. "JSYC_Roll")
require(g_sSlotModuleNum .. "JSYC_DataConfig")
require(g_sSlotModuleNum .. "JSYC_Caijin")
require(g_sSlotModuleNum .. "JSYC_Line")
require(g_sSlotModuleNum .. "JSYC_Result")
require(g_sSlotModuleNum .. "JSYC_Rule")
require(g_sSlotModuleNum .. "JSYC_Audio")

JSYCEntry = {};
local self = JSYCEntry;
self.transform = nil;
self.gameObject = nil;

self.CurrentChip = 0;
self.CurrentChipIndex = 0;
self.isAutoGame = false;
self.isFreeGame = false;
self.isRoll = false;
self.menuTweener = nil;
self.scatterList = {};
self.FreeList = {};

self.currentFreeCount = 0;

self.ispress = false;
self.clickStartTimer = -1;


self.currentAutoCount = 0;--剩余自动次数
self.freeCount = 0;--剩余免费次数

self.myGold = 0;--显示的自身金币

self.GetFreeCount=0

self.SceneData = {
    bet = 0, --当前下注
    userGold = 0, --用户金币
    chipList = {}, --下注列表
    freeNumber = 0, --免费次数
    caiJin = 0--彩金
};
self.ResultData = {
    ImgTable = {}, --图标
    LineTypeTable = {}, --连线类型
    WinScore = 0, --赢得总分
    FreeCount = 0, --免费次数
    caiJin = 0, --彩金
    cbChangeLine = 0 --彩金
}
function JSYCEntry:Awake(obj)
    Screen.orientation = UnityEngine.ScreenOrientation.Landscape;
    Screen.autorotateToLandscapeLeft = true;
    Screen.autorotateToLandscapeRight = true;
    Screen.autorotateToPortrait = false;
    Screen.autorotateToPortraitUpsideDown = false;
    self.transform = obj.transform;
    self.gameObject = obj.gameObject;
    --self.GetGameConfig();
    self.FindComponent();
    self.AddListener();
    JSYC_Roll.Init(self.RollContent);
    JSYC_Audio.Init();
    JSYC_Network.AddMessage();--添加消息监听
    JSYC_Network.LoginGame();--开始登录游戏
    GameSetsPanel.CreateHideObj(self.MainContent, false);
    JSYC_Audio.PlayBGM();
end
function JSYCEntry.OnDestroy()
    JSYC_Line.Close();
    JSYC_Network.UnMessage();
end
function JSYCEntry:Update()
    self.CanShowAuto();
    JSYC_Roll.Update();
    --JSYC_Caijin.Update();
    JSYC_Line.Update();
    JSYC_Result.Update();
end

function JSYCEntry.CanShowAuto()
    if self.ispress then
        if self.clickStartTimer >= 0 then
            self.clickStartTimer = self.clickStartTimer + Time.deltaTime;
            if self.clickStartTimer >= 1.5 then
                self.clickStartTimer = -1;
                self.OnClickAutoCall();
            end
        end
    end
end

function JSYCEntry.FindComponent()
    self.MainContent = self.transform:Find("MainPanel");

    self.normalBackground = self.MainContent:Find("Content/MainBackground").gameObject;
    self.freeBackground = self.MainContent:Find("Content/FreeBackground").gameObject;
    --self.freeShowCount = self.freeBackground.transform:Find("Count"):GetComponent("TextMeshProUGUI");
    --self.Fang2 = self.MainContent:Find("Content/Front/Fang2").gameObject;
    
    self.Fang2 = self.MainContent:Find("Content/Front/Fang2").gameObject;


    self.RollContent = self.MainContent:Find("Content/RollContent");--转动区域
    self.selfGold = self.MainContent:Find("Content/Bottom/Gold/Num"):GetComponent("TextMeshProUGUI");--自身金币
    self.ChipNum = self.MainContent:Find("Content/Bottom/Chip/Num"):GetComponent("TextMeshProUGUI");--下注金额
    self.WinNum = self.MainContent:Find("Content/Bottom/Win/Num"):GetComponent("TextMeshProUGUI");--本次获得金币
    self.showRuleBtn = self.MainContent:Find("Content/RuleBtn"):GetComponent("Button");--规则
    self.normalBot = self.MainContent:Find("Content/Bottom/MainBottom").gameObject;
    self.freeBot = self.MainContent:Find("Content/Bottom/FreeBottom").gameObject;
    
    self.reduceChipBtn = self.MainContent:Find("Content/ButtonGroup/Reduce"):GetComponent("Button");--减注
    self.addChipBtn = self.MainContent:Find("Content/ButtonGroup/Add"):GetComponent("Button");--加注

    self.maxChipBtn = self.MainContent:Find("Content/ButtonGroup/maxChip"):GetComponent("Button");--加注
    self.closeAutoMenu = self.MainContent:Find("Content/ButtonGroup/CloseAutoMenu"):GetComponent("Button");--关闭自动开始界面
    self.autoSelectList = self.closeAutoMenu.transform:Find("AutoSelect");--自动开始次数选择
    self.closeAutoMenu.gameObject:SetActive(false);

    self.btnGroup = self.MainContent:Find("Content/ButtonGroup");
    self.startBtn = self.btnGroup:Find("StartBtn"):GetComponent("Button");--开始按钮
    self.startBtn.transform:Find("On").gameObject:SetActive(true);
    self.startBtn.transform:Find("Off").gameObject:SetActive(false);
    self.AutoStopCount=self.btnGroup.transform:Find("AutoStopCount")

    self.autoText = self.btnGroup.transform:Find("AutoStopCount/AutoCountText"):GetComponent("TextMeshProUGUI");--免费次数

    self.FreeTitle = self.MainContent.transform:Find("Content/FreeTitle")--免费次数
    self.FreeMultiple = self.MainContent.transform:Find("Content/FreeTitle/Times"):GetComponent("TextMeshProUGUI");--免费次数

    self.bg1=self.MainContent.transform:Find("Content/bg")
    self.bg2=self.MainContent.transform:Find("Content/freeBg")

    
    self.FreeTitle2 = self.MainContent.transform:Find("Content/ButtonGroup/FreeTitle")--免费次数

    self.freeText = self.MainContent.transform:Find("Content/ButtonGroup/FreeTitle/FreeCount"):GetComponent("TextMeshProUGUI");--免费次数


    self.AutoStartBtn = self.btnGroup:Find("AutoStart"):GetComponent("Button");--打开自动开始界面
    self.AutoStartBtn.transform:Find("On").gameObject:SetActive(true);
    self.AutoStartBtn.transform:Find("Off").gameObject:SetActive(false);

    self.rulePanel = self.MainContent:Find("Content/Rule");--规则界面
    self.ruleList = self.rulePanel:Find("Content/RuleList"):GetComponent("ScrollRect");--规则子界面
    self.closeRuleBtn = self.rulePanel:Find("Content/BackBtn"):GetComponent("Button");

    self.closeGame = self.MainContent:Find("Content/BackBtn"):GetComponent("Button");
    self.soundBtn = self.MainContent:Find("Content/SoundBtn"):GetComponent("Button");
    self.soundOn = self.soundBtn.transform:Find("On").gameObject;
    self.soundOff = self.soundBtn.transform:Find("Off").gameObject;

    local isOn = MusicManager:GetMusicVolume()> 0 and MusicManager:GetIsPlayMV()
    self.soundOn:SetActive(isOn);
    self.soundOff:SetActive(not isOn);
    
    self.resultEffect = self.MainContent:Find("Content/Result");--中奖后特效


    self.WinEffect = self.resultEffect:Find("NormalReward");
    self.WinEffectNum = self.WinEffect:Find("BigWin/win_dh/WinTxt"):GetComponent("TextMeshProUGUI");

    self.bigWinEffect = self.resultEffect:Find("BigWin");
    self.bigWinNum = self.bigWinEffect:Find("BigWin/win_dh/WinTxt"):GetComponent("TextMeshProUGUI");

    -- self.superWinEffect = self.resultEffect:Find("SuperWin");
    -- self.superWinNum = self.superWinEffect:Find("BigWin/win_dh/WinTxt"):GetComponent("TextMeshProUGUI");

    self.megaWinEffect = self.resultEffect:Find("MegaWin");
    self.megaWinNum = self.megaWinEffect:Find("BigWin/win_dh/WinTxt"):GetComponent("TextMeshProUGUI");

    self.EnterFreeEffect = self.resultEffect:Find("EnterFree");
    self.EnterFreeCount = self.EnterFreeEffect:Find("Content/FreeCount"):GetComponent("TextMeshProUGUI");

    self.FreeResultEffect = self.resultEffect:Find("FreeResult");
    self.FreeResulCount = self.FreeResultEffect:Find("BG/CountTxt"):GetComponent("TextMeshProUGUI");
    self.FreeResultNum = self.FreeResultEffect:Find("BG/WinTxt"):GetComponent("TextMeshProUGUI");

    self.icons = self.MainContent:Find("Content/Icons");--图标库
    self.effectList = self.MainContent:Find("Content/EffectList");--动画库
    self.effectPool = self.MainContent:Find("Content/EffectPool");--动画缓存库
    self.CSGroup = self.MainContent:Find("Content/CSContent");--显示财神
    self.soundList = self.MainContent:Find("Content/SoundList");--声音库

    self.exitPanel=self.MainContent:Find("Content/ExitPanel")
    self.exitPanelQX=self.exitPanel:Find("BG/Cancel"):GetComponent("Button")
    --self.exitPanelClose=self.exitPanel:Find("BG/Exit_Close"):GetComponent("Button")
    self.exitPanelSure=self.exitPanel:Find("BG/Sure"):GetComponent("Button")
    self.exitPanel.gameObject:SetActive(false);



end
function JSYCEntry.AddListener()
    --添加监听事件
    self.reduceChipBtn.onClick:RemoveAllListeners();
    self.reduceChipBtn.onClick:AddListener(self.ReduceChipCall);
    self.addChipBtn.onClick:RemoveAllListeners();
    self.addChipBtn.onClick:AddListener(self.AddChipCall);

    self.maxChipBtn.onClick:RemoveAllListeners();
    self.maxChipBtn.onClick:AddListener(self.BigChipCall);

    self.startBtn.onClick:RemoveAllListeners();
    self.startBtn.onClick:AddListener(self.StartGameCall);
    
    local et = self.startBtn.gameObject:AddComponent(typeof(LuaFramework.EventTriggerListener));
    et.onDown = self.OnDownStartBtnCall;
    et.onUp = self.OnUpStartBtnCall;

    self.closeGame.onClick:RemoveAllListeners();
    self.closeGame.onClick:AddListener(function()
        self.exitPanel.gameObject:SetActive(true)
    end);

    self.exitPanelSure.onClick:RemoveAllListeners();
    self.exitPanelSure.onClick:AddListener(self.CloseGameCall);

    self.exitPanelQX.onClick:RemoveAllListeners();
    self.exitPanelQX.onClick:AddListener(function()
        JSYC_Audio.PlaySound(JSYC_Audio.SoundList.BTN);
        self.exitPanel.gameObject:SetActive(false)
    end);

    self.soundBtn.onClick:RemoveAllListeners();
    self.soundBtn.onClick:AddListener(self.SetSoundCall);

    self.AutoStartBtn.onClick:RemoveAllListeners();
    self.AutoStartBtn.onClick:AddListener(self.OnClickAutoStartCall);

    for i = 1, self.autoSelectList.childCount do
        --自动次数选择
        local child = self.autoSelectList:GetChild(i - 1);
        child:GetComponent("Button").onClick:RemoveAllListeners();
        child:GetComponent("Button").onClick:AddListener(function()
            self.currentAutoCount = tonumber(child.name);
            JSYC_Audio.PlaySound(JSYC_Audio.SoundList.BTN);
            self.AutoStartCall();
        end)
        child.gameObject:SetActive(true);
    end

    self.showRuleBtn.onClick:RemoveAllListeners();--显示规则
    self.showRuleBtn.onClick:AddListener(self.ShowRultPanel);


    self.closeAutoMenu.onClick:RemoveAllListeners();--关闭自动
    self.closeAutoMenu.onClick:AddListener(function()
        self.closeAutoMenu.gameObject:SetActive(false);
    end)

end
function JSYCEntry.GetGameConfig()
    --获取远程端配置
    local formdata = FormData.New();
    formdata:AddField("v", os.time());
    local url = string.gsub(AppConst.WebUrl, "/android", "");
    url = string.gsub(url, "/iOS", "");
    url = string.gsub(url, "/ios", "");
    url = string.gsub(url, "/win32", "");
    url = string.gsub(url, "/win", "");
    UnityWebRequestManager.Instance:GetText(url .. "Config/module27.json", 4, formdata, function(state, result)
        log(result);
        local data = json.decode(result);
        JSYC_DataConfig.rollTime = data.rollTime;
        JSYC_DataConfig.rollReboundRate = data.rollReboundRate;
        JSYC_DataConfig.rollInterval = data.rollInterval;
        JSYC_DataConfig.rollSpeed = data.rollSpeed;
        JSYC_DataConfig.caijinGoldChangeRate = data.caijinGoldChangeRate;
        JSYC_DataConfig.winGoldChangeRate = data.winGoldChangeRate;
        JSYC_DataConfig.selfGoldChangeRate = data.selfGoldChangeRate;
        JSYC_DataConfig.freeLoadingShowTime = data.freeLoadingShowTime;
        JSYC_DataConfig.smallGameLoadingShowTime = data.smallGameLoadingShowTime;
        JSYC_DataConfig.rollDistance = data.rollDistance;
        JSYC_DataConfig.REQCaiJinTime = data.REQCaiJinTime;
        JSYC_DataConfig.lineAllShowTime = data.lineAllShowTime;
        JSYC_DataConfig.cyclePlayLineTime = data.cyclePlayLineTime;
        JSYC_DataConfig.waitShowLineTime = data.waitShowLineTime;
        JSYC_DataConfig.autoRewardInterval = data.autoRewardInterval;
        JSYC_DataConfig.autoNoRewardInterval = data.autoNoRewardInterval;
    end);
end
function JSYCEntry.ToCharArray(num)
    --拆解字符串
    local str = tostring(num);
    local list1 = {}
    for i = 1, string.len(str) do
        table.insert(list1, #list1 + 1, string.sub(str, i, i));
    end
    return list1;
end


function JSYCEntry.FormatNumberThousands(num)
    --对数字做千分位操作
    local function checknumber(value)
        return tonumber(value) or 0
    end
    local formatted = tostring(checknumber(num))
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        print(formatted, k)
        if k == 0 then
            break
        end

    end
    return formatted
end
function JSYCEntry.SetSelfGold(str)
    self.selfGold.text = self.ShowText(str);
end

function JSYCEntry.ShowText(str)
    return ShowRichText(ShortNumber(str));
    --str = ShortNumber(str);
    ----展示tmp字体
    --local arr = self.ToCharArray(str);
    --local _str = "";
    --for i = 1, #arr do
    --    _str = _str .. string.format("<sprite name=\"%s\">", arr[i]);
    --end
    --return _str;
end
function JSYCEntry.ReduceChipCall()
    --减注
    JSYC_Audio.PlaySound(JSYC_Audio.SoundList.BTN);
    if self.SceneData.chipList == nil or #self.SceneData.chipList <= 0 then
        return ;
    end
    self.CurrentChipIndex = self.CurrentChipIndex - 1;
    if self.CurrentChipIndex <= 0 then
        self.CurrentChipIndex = #self.SceneData.chipList;
    end
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.CurrentChip * JSYC_DataConfig.ALLLINECOUNT);
end
function JSYCEntry.AddChipCall()
    --加注
    JSYC_Audio.PlaySound(JSYC_Audio.SoundList.BTN);
    if self.SceneData.chipList == nil or #self.SceneData.chipList <= 0 then
        return ;
    end
    self.CurrentChipIndex = self.CurrentChipIndex + 1;
    if self.CurrentChipIndex > #self.SceneData.chipList then
        self.CurrentChipIndex = 1;
    end
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.CurrentChip * JSYC_DataConfig.ALLLINECOUNT);
end

function JSYCEntry.BigChipCall()
    JSYC_Audio.PlaySound(JSYC_Audio.SoundList.BTN);
    if self.SceneData.chipList == nil or #self.SceneData.chipList <= 0 then
        return ;
    end
    self.CurrentChipIndex = 5
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.CurrentChip * JSYC_DataConfig.ALLLINECOUNT);
end


function JSYCEntry.StartGameCall()
    --开始游戏
    if self.isFreeGame or self.isAutoGame then
        return ;
    end
    if self.isRoll then
        --TODO 急停
        self.startBtn.transform:Find("On").gameObject:SetActive(true);
        self.startBtn.transform:Find("Off").gameObject:SetActive(false);
        self.startBtn.interactable = false;
        JSYC_Roll.StopRoll();
        return ;
    end
    JSYC_Audio.PlaySound(JSYC_Audio.SoundList.BTN);
    self.startBtn.transform:Find("On").gameObject:SetActive(false);
    self.startBtn.transform:Find("Off").gameObject:SetActive(true);
    --TODO 发送开始消息,等待结果开始转动
    JSYC_Network.StartGame();
end
function JSYCEntry.ClickMenuCall()
    --点击显示菜单
    JSYC_Audio.PlaySound(JSYC_Audio.SoundList.BTN);
    if self.menuTweener ~= nil then
        self.menuTweener:Kill();
    end
    self.backgroundBtn.gameObject:SetActive(true);
    self.backgroundBtn.interactable = false;
    self.menuTweener = self.menulist:Find("Content"):DOLocalMove(Vector3.New(0, 0, 0), 0.5):OnComplete(function()
        self.backgroundBtn.interactable = true;
        if self.menuTweener ~= nil then
            self.menuTweener = nil;
        end
    end);
    if self.menuTweener ~= nil then
        self.menuTweener:SetAutoKill();
    end
end
function JSYCEntry.CloseMenuCall()
    --关闭菜单
    JSYC_Audio.PlaySound(JSYC_Audio.SoundList.BTN);
    if self.menuTweener ~= nil then
        self.menuTweener:Kill();
    end
    self.backgroundBtn.interactable = false;
    self.menuTweener = self.menulist:Find("Content"):DOLocalMove(Vector3.New(0, 500, 0), 0.5):OnComplete(function()
        self.backgroundBtn.interactable = true;
        self.backgroundBtn.gameObject:SetActive(false);
        if self.menuTweener ~= nil then
            self.menuTweener = nil;
        end
    end);
    if self.menuTweener ~= nil then
        self.menuTweener:SetAutoKill();
    end
end
function JSYCEntry.CloseGameCall()
    if self.isFreeGame then
        MessageBox.CreatGeneralTipsPanel("Unable to quit the game in special games")
        return
    end
    Event.Brocast(MH.Game_LEAVE);
end
function JSYCEntry.SetSoundCall()
    if MusicManager:GetIsPlayMV() or MusicManager:GetIsPlaySV() then
        MusicManager:SetMusicMute(true);
        MusicManager:SetSoundMute(true);
        self.soundOn:SetActive(false);
        self.soundOff:SetActive(true);
    else
        MusicManager:SetValue(1,1);
        MusicManager:SetMusicMute(false);
        MusicManager:SetSoundMute(false);
        self.soundOn:SetActive(true);
        self.soundOff:SetActive(false);
    end
    JSYC_Audio.pool.mute = not MusicManager:GetIsPlayMV();
end

function JSYCEntry.OnDownStartBtnCall()
    self.clickStartTimer = 0;
    self.ispress = true;
end

function JSYCEntry.OnUpStartBtnCall()
    self.ispress = false;
    self.clickStartTimer = -1;
    --self.startBtn.transform:Find("anniu").gameObject:SetActive(false)
end

function JSYCEntry.OnClickAutoCall()
    --点击自动开始
    if self.isAutoGame then
        self.StopAutoGame();
        return ;
    end
    self.closeAutoMenu.gameObject:SetActive(true);
    --self.startBtn.transform:Find("anniu").gameObject:SetActive(false)  
end


function JSYCEntry.OnClickAutoStartCall()
    --点击选择自动次数
    if self.isAutoGame then
        self.StopAutoGame();
        return ;
    end
    self.AutoStartCall();
end
function JSYCEntry.AutoStartCall()
    JSYC_Audio.PlaySound(JSYC_Audio.SoundList.BTN);
    self.isAutoGame = true;
    self.AutoStartBtn.transform:Find("On").gameObject:SetActive(false);
    self.AutoStartBtn.transform:Find("Off").gameObject:SetActive(true);
    self.closeAutoMenu.gameObject:SetActive(false);
    self.AutoStopCount.gameObject:SetActive(true);
    self.SetState(3);
    JSYCEntry.addChipBtn.interactable = false;
    JSYCEntry.reduceChipBtn.interactable = false;
    JSYCEntry.maxChipBtn.interactable = false;

    
    self.startBtn.interactable = false;
    --self.currentAutoCount = 1000;
    if self.currentAutoCount > 1000 then
        self.autoText.text = ShowRichText("w");
    else
        self.autoText.text =ShowRichText(self.currentAutoCount) --tostring(self.currentAutoCount);
    end

    if not self.isRoll and not self.isFreeGame then
        --没有转动的状态开始自动旋转
        JSYC_Network.StartGame();
    end
end
function JSYCEntry.ShowRultPanel()
    --显示规则
    JSYC_Audio.PlaySound(JSYC_Audio.SoundList.BTN);
    JSYC_Rule.ShowRule();
end
function JSYCEntry.SetMaxChipCall()
    --设置最大下注
    JSYC_Audio.PlaySound(JSYC_Audio.SoundList.BTN);
    self.CurrentChipIndex = #self.SceneData.chipList;
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.CurrentChip);
end

function JSYCEntry.CSJLRoll()
    JSYC_Network.StartGame();
end
function JSYCEntry.StopAutoGame()
    --停止自动旋转
    self.isAutoGame = false;
    self.currentAutoCount = 0;
    self.AutoStartBtn.transform:Find("On").gameObject:SetActive(true);
    self.AutoStartBtn.transform:Find("Off").gameObject:SetActive(false);
    JSYCEntry.addChipBtn.interactable = true;
    JSYCEntry.reduceChipBtn.interactable = true;
    JSYCEntry.maxChipBtn.interactable = true;

    self.startBtn.interactable = true;
    self.closeAutoMenu.gameObject:SetActive(false);
    self.AutoStopCount.gameObject:SetActive(false);
    self.SetState(1);
end

function JSYCEntry.FreeGame()
    --免费游戏
    self.isFreeGame = true;
    --JSYCEntry.freeShowCount.text = JSYCEntry.ShowText("x" .. self.currentFreeCount);
    -- if self.currentFreeCount < 12 then
    --     JSYC_Audio.PlaySound("Freex" .. self.currentFreeCount);
    -- else
    --     JSYC_Audio.PlaySound("Freex12");
    -- end


    self.freeText.text = ShowRichText(self.freeCount);
    JSYC_Network.StartGame();
end

function JSYCEntry.AddMultiple()
    JSYC_Audio.PlaySound(JSYC_Audio.SoundList.Multiplier);
    local _count="x"..(self.currentFreeCount);
    self.FreeMultiple.text = ShowRichText(_count);
end

function JSYCEntry.Roll()
    --开始转动    
    if not self.isFreeGame and not JSYC_Result.isWinCSJL then
        self.myGold = self.myGold - self.CurrentChip * JSYC_DataConfig.ALLLINECOUNT;
        JSYCEntry.SetSelfGold(self.myGold);
    end
    self.WinNum.text = 0--self.ShowText(0);
    JSYC_Result.HideResult();
    JSYC_Line.Close();
    JSYC_Roll.StartRoll();
end
function JSYCEntry.OnStop()
    --停止转动
    log("停止")
    self.startBtn.transform:Find("On").gameObject:SetActive(true);
    self.startBtn.transform:Find("Off").gameObject:SetActive(false);
    JSYC_Result.ShowResult();
end
function JSYCEntry.InitPanel()
    --场景消息初始化
    for i = 1,5 do
        local rect = self.RollContent.transform:GetChild(i - 1):GetComponent("ScrollRect");
        rect.content.transform:GetComponent("GridLayoutGroup").enabled=true
    end
    self.myGold = TableUserInfo._7wGold;
    JSYCEntry.SetSelfGold(self.myGold);
    JSYCEntry.FreeResultNum.text = JSYCEntry.ShowText(0);
    JSYCEntry.FreeResulCount.text = ShowRichText(0);

    for i = 1, #self.SceneData.chipList do
        if self.SceneData.chipList[i] == self.SceneData.bet then
            self.CurrentChipIndex = i;
        end
    end
    if self.SceneData.freeNumber <= 0 then
        self.CurrentChipIndex = CheckNear(TableUserInfo._7wGold,self.SceneData.chipList);
    end
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.CurrentChip * JSYC_DataConfig.ALLLINECOUNT);
    self.WinNum.text = 0--self.ShowText(0);
    --JSYC_Caijin.isCanSend = true;
    self.isRoll = false;
    JSYC_Line.Init();
    JSYC_Result.Init();
    if self.SceneData.freeNumber > 0 then
        --如果免费
        self.freeCount = self.SceneData.freeNumber;
        self.isFreeGame = true;
        JSYC_Result.ShowFreeEffect(true);
        self.SetState(2);
    else
        self.SetState(1);
    end
end
function JSYCEntry.SetState(state)
    if state == 1  then
        --正常模式 or 自动模式
        self.normalBackground:SetActive(true);
        self.freeBackground:SetActive(false);
        self.normalBot:SetActive(true);
        self.freeBot:SetActive(false);
        self.startBtn.gameObject:SetActive(true);
        self.AutoStartBtn.gameObject:SetActive(false);
        self.FreeTitle.gameObject:SetActive(false);
        self.FreeTitle2.gameObject:SetActive(false);

        self.bg1.gameObject:SetActive(true);
        self.bg2.gameObject:SetActive(false);

        self.freeText.gameObject:SetActive(false);
        self.Fang2.gameObject:SetActive(false);

    elseif state == 2 then
        --免费模式
        self.normalBackground:SetActive(false);
        self.freeBackground:SetActive(true);
        self.normalBot:SetActive(false);
        self.freeBot:SetActive(true);
        self.startBtn.gameObject:SetActive(false);
        
        self.FreeTitle.gameObject:SetActive(true);
        self.FreeTitle2.gameObject:SetActive(true);

        self.AutoStartBtn.gameObject:SetActive(false);
        self.freeText.gameObject:SetActive(true);
        self.Fang2.gameObject:SetActive(true);
        self.bg1.gameObject:SetActive(false);
        self.bg2.gameObject:SetActive(true);
    elseif state == 3 then
        self.normalBackground:SetActive(true);
        self.freeBackground:SetActive(false);
        self.normalBot:SetActive(true);
        self.freeBot:SetActive(false);
        self.startBtn.gameObject:SetActive(true);
        self.AutoStartBtn.gameObject:SetActive(true);
        self.FreeTitle.gameObject:SetActive(false);
        self.FreeTitle2.gameObject:SetActive(false);
        self.bg1.gameObject:SetActive(false);
        self.bg2.gameObject:SetActive(true);
        self.freeText.gameObject:SetActive(false);
        self.Fang2.gameObject:SetActive(false);
    end
end
function JSYCEntry.FreeRoll()
    --判断是否为免费游戏
    JSYC_Result.isShow = false;
    if self.isFreeGame then
        self.freeCount = self.freeCount - 1;
        self.currentFreeCount = self.currentFreeCount + 1;
        if self.freeCount < 0 then
            --免费结束
            if JSYC_Result.showFreeTweener ~= nil then
                JSYC_Result.showFreeTweener:Kill();
                JSYC_Result.showFreeTweener = nil;
            end
            self.isFreeGame = false;
            JSYCEntry.addChipBtn.interactable = true;
            JSYCEntry.reduceChipBtn.interactable = true;
            JSYCEntry.maxChipBtn.interactable = true;
            JSYC_Audio.PlayBGM();
            self.SetState(1);
            self.AutoRoll();
        else
            --还有免费次数
            self.FreeGame();
        end
    else
        self.AutoRoll();
    end
end
function JSYCEntry.AutoRoll()
    --判断是否为自动游戏
    if self.isAutoGame then
        --如果是自动游戏
        if self.currentAutoCount < 1000 then
            self.currentAutoCount = self.currentAutoCount - 1;
        end
        if self.currentAutoCount < 0 then
            --自动次数使用完了，回到待机状态
            self.StopAutoGame();
        else
            --还有自动次数
            self.AutoStartCall();
        end
    else
        --不是自动游戏，直接待机
        self.StopAutoGame();
    end
end