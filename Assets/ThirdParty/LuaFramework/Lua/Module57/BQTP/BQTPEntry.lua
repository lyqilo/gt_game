-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion
local g_swlzbNum = "Module57/BQTP/";

require(g_swlzbNum .. "BQTP_Network")
require(g_swlzbNum .. "BQTP_Roll")
require(g_swlzbNum .. "BQTP_DataConfig")
require(g_swlzbNum .. "BQTP_Line")
require(g_swlzbNum .. "BQTP_Result")
require(g_swlzbNum .. "BQTP_Rule")
require(g_swlzbNum .. "BQTP_Audio")

BQTPEntry = {};
local self = BQTPEntry;
self.transform = nil;
self.gameObject = nil;
self.luaBehaviour = nil;

self.CurrentFreeIndex = 0;
self.CurrentChip = 0;
self.CurrentChipIndex = 0;
self.isAutoGame = false;
self.isFreeGame = false;
self.isSmallGame = false;
self.isRoll = false;
self.menuTweener = nil;

self.currentFreeCount = 0;

self.currentAutoCount = 0;--剩余自动次数
self.freeCount = 0;--剩余免费次数
self.totalFreeCount = 0;

self.smallGameCount = 0;

self.myGold = 0;--显示的自身金币
self.ScatterList = {};

self.isReRoll = false;
self.ReRollCount = 0;
self.isScene = false;

self.SceneData = {
    freeNumber = 0, --免费次数
    bet = 0, --当前下注
    chipNum = 0, --用户金币
    chipList = {}, --下注列表
    cbRerun = 0, --重转次数
};
self.ResultData = {
    ImgTable = {}, --图标
    LineTypeTable = {}, --击中的图标
    WinScore = 0, --赢得总分
    FreeCount = 0, --免费次数
    cbRerun = 0, --下一次是重转第几次
    cbSpecialWild = 0, -- 第几列中全wild
}
function BQTPEntry:Awake(obj)
    Screen.orientation = UnityEngine.ScreenOrientation.Landscape;
    Screen.autorotateToLandscapeLeft = true;
    Screen.autorotateToLandscapeRight = true;
    Screen.autorotateToPortrait = false;
    Screen.autorotateToPortraitUpsideDown = false;
    self.transform = obj.transform;
    self.gameObject = obj.gameObject;
    self.luaBehaviour = self.transform:GetComponent("LuaBehaviour");
    --self.GetGameConfig();
    self.FindComponent();
    BQTP_Roll.Init(self.RollContent);
    BQTP_Audio.Init();
    BQTP_Line.Init();
    BQTP_Result.Init();
    BQTP_Network.AddMessage();--添加消息监听
    BQTP_Network.LoginGame();--开始登录游戏
    GameSetsPanel.CreateHideObj(self.MainContent, false);
    BQTP_Audio.PlayBGM();
end
--
function BQTPEntry.OnDestroy()
    BQTP_Line.Close();
    BQTP_Network.UnMessage();
end

function BQTPEntry:Update()
    BQTP_Roll.Update();
end

function BQTPEntry.FindComponent()
    self.MainContent = self.transform:Find("MainPanel");

    self.normalBg = self.MainContent:Find("Content/Background/Normal");
    self.freeBg = self.MainContent:Find("Content/Background/Free");
    self.enterFreeEffect = self.MainContent:Find("Content/Background/GamePanel/Bing"):GetComponent("UnityArmatureComponent");
    self.exitFreeEffect = self.MainContent:Find("Content/Background/GamePanel/BingSui"):GetComponent("UnityArmatureComponent");
    self.freeText = self.freeBg:Find("Num"):GetComponent("TextMeshProUGUI");
    self.freeBLGroup = self.freeBg:Find("Group");

    self.RollContent = self.MainContent:Find("Content/RollContent");--转动区域
    self.ChipNum = self.MainContent:Find("Content/Bottom/Chip/Num"):GetComponent("TextMeshProUGUI");--下注金额

    self.normalWin = self.MainContent:Find("Content/Bottom/WinNormal");
    self.normalWinNum = self.normalWin:Find("Num"):GetComponent("TextMeshProUGUI");--本次获得金币
    self.bigWin = self.MainContent:Find("Content/Bottom/WinBig");
    self.bigWinNum = self.bigWin:Find("Num"):GetComponent("TextMeshProUGUI");--本次获得金币

    self.reduceChipBtn = self.MainContent:Find("Content/Bottom/Chip/Reduce"):GetComponent("Button");--减注
    self.addChipBtn = self.MainContent:Find("Content/Bottom/Chip/Add"):GetComponent("Button");--加注

    self.btnGroup = self.MainContent:Find("Content/ButtonGroup");
    self.startBtn = self.btnGroup:Find("StartBtn");--开始按钮
    self.startState = self.startBtn.transform:Find("Start"):GetComponent("Button");
    self.stopState = self.startBtn.transform:Find("Stop");

    self.MaxChipBtn = self.btnGroup:Find("MaxChip"):GetComponent("Button");--最大下注
    self.AutoBtn = self.btnGroup:Find("AutoBtn"):GetComponent("Toggle");--最大下注

    self.rulePanel = self.MainContent:Find("Content/Rule");--规则界面
    self.ruleList = self.rulePanel:Find("Content/RuleList"):GetComponent("ScrollRect");--规则子界面
    self.leftShowBtn = self.rulePanel:Find("Content/LeftBtn"):GetComponent("Button");
    self.rightShowBtn = self.rulePanel:Find("Content/RightBtn"):GetComponent("Button");
    self.closeRuleBtn = self.rulePanel:Find("Content/BackBtn"):GetComponent("Button");

    self.closeGame = self.MainContent:Find("Content/QuitGameBtn"):GetComponent("Button");
    self.showRuleBtn = self.MainContent:Find("Content/RuleBtn"):GetComponent("Button");
    self.soundBtn = self.MainContent:Find("Content/SoundBtn"):GetComponent("Toggle");

    if MusicManager:GetMusicVolume()<=0 or not MusicManager:GetIsPlayMV() then
        self.soundBtn.isOn = false;
    else
        self.soundBtn.isOn = true;
    end

    self.userInfo = self.MainContent:Find("Content/Bottom/UserInfo");
    self.selfGold = self.userInfo:Find("GoldNum"):GetComponent("TextMeshProUGUI");--自身金币

    self.icons = self.MainContent:Find("Content/Icons");--图标库
    self.effectList = self.MainContent:Find("Content/EffectList");--动画库
    self.effectPool = self.MainContent:Find("Content/EffectPool");--动画缓存库
    self.CSGroup = self.MainContent:Find("Content/CSContent");--显示特別效果
    self.soundList = self.MainContent:Find("Content/SoundList");--声音库

    self.quitPanel = self.MainContent:Find("Content/QuitPanel");

end

function BQTPEntry.AddListener()
    --添加监听事件
    self.reduceChipBtn.onClick:RemoveAllListeners();
    self.reduceChipBtn.onClick:AddListener(self.ReduceChipCall);
    self.addChipBtn.onClick:RemoveAllListeners();
    self.addChipBtn.onClick:AddListener(self.AddChipCall);

    self.startState.onClick:RemoveAllListeners();
    self.startState.onClick:AddListener(self.StartGameCall);

    self.closeGame.onClick:RemoveAllListeners();
    self.closeGame.onClick:AddListener(self.CloseGameCall);
    self.showRuleBtn.onClick:RemoveAllListeners();--显示规则
    self.showRuleBtn.onClick:AddListener(self.ShowRulePanel);

    self.MaxChipBtn.onClick:RemoveAllListeners();
    self.MaxChipBtn.onClick:AddListener(self.SetMaxChipCall);
    self.AutoBtn.onValueChanged:RemoveAllListeners();
    self.AutoBtn.onValueChanged:AddListener(self.OnClickAutoCall);

    self.soundBtn.onValueChanged:RemoveAllListeners();
    self.soundBtn.onValueChanged:AddListener(self.OnClickSoundChangeCall);
end

function BQTPEntry.ToCharArray(num)
    --拆解字符串
    local str = tostring(num);
    local list1 = {}
    for i = 1, string.len(str) do
        table.insert(list1, #list1 + 1, string.sub(str, i, i));
    end
    return list1;
end

function BQTPEntry.FormatNumberThousands(num)
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

function BQTPEntry.SetSelfGold(str)
    self.selfGold.text = tostring(str);
end

function BQTPEntry.ShowText(str)
    --展示tmp字体
    local arr = self.ToCharArray(str);
    local _str = "";
    for i = 1, #arr do
        _str = _str .. string.format("<sprite name=\"%s\" tint=1>", arr[i]);
    end
    return _str;
end

function BQTPEntry.ReduceChipCall()
    --减注
    BQTP_Audio.PlaySound(BQTP_Audio.SoundList.Normal_Reduce);
    if self.SceneData.chipList == nil or #self.SceneData.chipList <= 0 then
        return ;
    end
    self.CurrentChipIndex = self.CurrentChipIndex - 1;
    if self.CurrentChipIndex <= 0 then
        self.CurrentChipIndex = 1;
        MessageBox.CreatGeneralTipsPanel("Bets have reached the minimum");
        return ;
    end
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = tostring(self.CurrentChip * BQTP_DataConfig.ALLLINECOUNT);
end

function BQTPEntry.AddChipCall()
    --加注
    BQTP_Audio.PlaySound(BQTP_Audio.SoundList.Normal_Addbet);
    if self.SceneData.chipList == nil or #self.SceneData.chipList <= 0 then
        return ;
    end
    self.CurrentChipIndex = self.CurrentChipIndex + 1;
    if self.CurrentChipIndex > self.SceneData.chipNum then
        self.CurrentChipIndex = self.SceneData.chipNum;
        MessageBox.CreatGeneralTipsPanel("Bet max reached");
        return ;
    end
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = tostring(self.CurrentChip * BQTP_DataConfig.ALLLINECOUNT);
end

function BQTPEntry.StartGameCall()
    --开始游戏
    if self.isFreeGame then
        return ;
    end
    if self.isRoll then
        --TODO 急停
        return ;
    end
    BQTP_Audio.PlaySound(BQTP_Audio.SoundList.Normal_Spin);
    self.NormalRollState();
end
function BQTPEntry.CloseGameCall()
    BQTP_Audio.PlaySound(BQTP_Audio.SoundList.BTN);
    self.quitPanel.gameObject:SetActive(true);
    local backHallBtn = self.quitPanel:Find("Content/BackHall"):GetComponent("Button");
    local closeBtn = self.quitPanel:Find("Content/ContinueGame"):GetComponent("Button");
    local closebtn1 = self.quitPanel:Find("Content/Close"):GetComponent("Button");
    backHallBtn.onClick:RemoveAllListeners();
    backHallBtn.onClick:AddListener(function()
        if not self.isFreeGame then
            Event.Brocast(MH.Game_LEAVE);
        else
            MessageBox.CreatGeneralTipsPanel("Cannot leave the game in special mode");
        end
    end);
    closeBtn.onClick:RemoveAllListeners();
    closeBtn.onClick:AddListener(function()
        self.quitPanel.gameObject:SetActive(false);
    end);
    closebtn1.onClick:RemoveAllListeners();
    closebtn1.onClick:AddListener(function()
        self.quitPanel.gameObject:SetActive(false);
    end);
end
function BQTPEntry.OnClickSoundChangeCall(value)
    if value then
        MusicManager:SetValue(1,1);
        MusicManager:SetMusicMute(false);
        MusicManager:SetSoundMute(false);
        BQTP_Audio.ResetSound();
    else
        MusicManager:SetMusicMute(true);
        MusicManager:SetSoundMute(true);
        BQTP_Audio.MuteSound();
    end
end
function BQTPEntry.OnClickAutoCall(value)
    --点击自动开始
    BQTP_Audio.PlaySound(BQTP_Audio.SoundList.Normal_AutoSpin);
    if value then
        self.AutoRollState();
    else
        self.StopAutoGame();
    end
    self.isAutoGame = value;
end
function BQTPEntry.ShowRulePanel()
    --显示规则
    BQTP_Audio.PlaySound(BQTP_Audio.SoundList.BTN);
    BQTP_Rule.ShowRule();
end
function BQTPEntry.SetMaxChipCall()
    --设置最大下注
    BQTP_Audio.PlaySound(BQTP_Audio.SoundList.Normal_MaxBet);
    self.CurrentChipIndex = self.SceneData.chipNum;
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = tostring(self.CurrentChip * BQTP_DataConfig.ALLLINECOUNT);
end

function BQTPEntry.StopAutoGame()
    --停止自动旋转
    self.isAutoGame = false;
    self.currentAutoCount = 0;
end
function BQTPEntry.Roll()
    --开始转动    
    if not self.isFreeGame and not self.isReRoll then
        self.myGold = self.myGold - self.CurrentChip * BQTP_DataConfig.ALLLINECOUNT;
        BQTPEntry.SetSelfGold(self.myGold);
    end
    self.normalWinNum.text = "0";
    self.bigWinNum.text = self.ShowText(0);
    BQTP_Line.Close();
    BQTP_Roll.StartRoll();
end
function BQTPEntry.OnStop()
    --停止转动
    log("停止")
    BQTP_Audio.ClearAuido(BQTP_Audio.SoundList.Normal_ReelRun);
    BQTP_Result.ShowResult();
end
function BQTPEntry.InitPanel()
    --场景消息初始化
    self.myGold = TableUserInfo._7wGold;
    BQTPEntry.SetSelfGold(self.myGold);
    for i = 1, #self.SceneData.chipList do
        if self.SceneData.chipList[i] == self.SceneData.bet then
            self.CurrentChipIndex = i;
            self.CurrentChip = self.SceneData.bet;
            self.ChipNum.text = tostring(self.CurrentChip * BQTP_DataConfig.ALLLINECOUNT);
        end
    end
    self.normalWinNum.text = "0";
    self.bigWinNum.text = self.ShowText(0);
    self.isRoll = false;
    self.isFreeGame = false;
    self.isAutoGame = false;
    self.CheckState();
    self.AddListener();
end
function BQTPEntry.DelayCall(timer, callback)
    return Util.RunWinScore(0, 1, timer, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        if callback ~= nil then
            callback();
        end
    end);
end
function BQTPEntry.IdleState()
    self.normalWin.gameObject:SetActive(true);
    self.bigWin.gameObject:SetActive(false);
    self.startState.gameObject:SetActive(true);
    self.stopState.gameObject:SetActive(false);
    self.startState.interactable = true;
    self.MaxChipBtn.interactable = true;
    self.AutoBtn.interactable = true;
    self.AutoBtn.isOn = false;
    self.addChipBtn.interactable = true;
    self.reduceChipBtn.interactable = true;
    self.closeGame.interactable = true;
    self.isAutoGame = false;
    self.currentAutoCount = 0;
    self.isFreeGame = false;
    self.isRoll = false;
end

function BQTPEntry.ReRollState()
    BQTPEntry.isReRoll = true;
    for i = 1, self.freeBLGroup.childCount do
        self.freeBLGroup:GetChild(i - 1):GetComponent("Toggle").isOn = false;
    end
    for i = 1, self.ReRollCount do
        if i <= self.freeBLGroup.childCount then
            self.freeBLGroup:GetChild(i - 1):GetComponent("Toggle").isOn = true;
        end
    end
    BQTP_Network.StartGame();
end

function BQTPEntry.NormalRollState()
    self.startState.gameObject:SetActive(false);
    self.stopState.gameObject:SetActive(true);
    self.startState.interactable = false;
    self.MaxChipBtn.interactable = false;
    self.AutoBtn.interactable = false;
    self.addChipBtn.interactable = false;
    self.reduceChipBtn.interactable = false;
    self.closeGame.interactable = false;
    self.isRoll = true;
    BQTP_Network.StartGame();
end
function BQTPEntry.AutoRollState()
    self.startState.gameObject:SetActive(false);
    self.stopState.gameObject:SetActive(true);
    self.startState.interactable = false;
    self.MaxChipBtn.interactable = false;
    self.AutoBtn.interactable = true;
    self.addChipBtn.interactable = false;
    self.reduceChipBtn.interactable = false;
    self.closeGame.interactable = false;
    self.currentAutoCount = 10000;
    if not self.isRoll then
        self.isRoll = true;
        BQTP_Network.StartGame();
    end
end
function BQTPEntry.FreeRollState()
    self.startState.gameObject:SetActive(false);
    self.stopState.gameObject:SetActive(true);
    self.startState.interactable = false;
    self.MaxChipBtn.interactable = false;
    self.AutoBtn.interactable = false;
    self.addChipBtn.interactable = false;
    self.reduceChipBtn.interactable = false;
    self.closeGame.interactable = false;
    self.isRoll = true;
    for i = 1, self.freeBLGroup.childCount do
        self.freeBLGroup:GetChild(i - 1):GetComponent("Toggle").isOn = false;
    end
    BQTP_Network.StartGame();
end
function BQTPEntry.CheckState()
    self.startState.gameObject:SetActive(true);
    self.stopState.gameObject:SetActive(false);
    self.isRoll = false;
    self.normalWin.gameObject:SetActive(true);
    self.bigWin.gameObject:SetActive(false);
    if self.freeCount > 0 then
        self.freeText.text = self.ShowText(self.freeCount);
        if self.isFreeGame then
            self.FreeRollState();
        else
            self.enterFreeEffect.gameObject:SetActive(true);
            self.enterFreeEffect:AddDBEventListener(DragonBones.EventObject.COMPLETE, self.OnEnterFreeAnimationEventHandler)
            self.enterFreeEffect.dbAnimation:Play("Sprite", 1);
        end
    else
        if self.isFreeGame then
            self.enterFreeEffect.gameObject:SetActive(false);
            self.exitFreeEffect.gameObject:SetActive(true);
            self.exitFreeEffect:AddDBEventListener(DragonBones.EventObject.COMPLETE, self.OnExitFreeAnimationEventHandler)
            self.exitFreeEffect.dbAnimation:Play("Sprite", 1);
        elseif self.isAutoGame then
            self.AutoRollState();
        else
            if self.ReRollCount > 0 then
                BQTPEntry.isReRoll = true;
                self.NormalRollState();
            else
                self.IdleState();
            end
        end
    end
end
function BQTPEntry.OnEnterFreeAnimationEventHandler(type, eventobject)
    self.isFreeGame = true;
    self.enterFreeEffect:RemoveDBEventListener(DragonBones.EventObject.COMPLETE, self.OnEnterFreeAnimationEventHandler)
    self.freeText.text = self.ShowText(self.freeCount);
    self.normalBg.gameObject:SetActive(false);
    self.freeBg.gameObject:SetActive(true);
    BQTP_Audio.PlayBGM(BQTP_Audio.SoundList.FreeBGM);
    self.CheckState();
end
function BQTPEntry.OnExitFreeAnimationEventHandler(type, eventobject)
    self.isFreeGame = false;
    self.exitFreeEffect:RemoveDBEventListener(DragonBones.EventObject.COMPLETE, self.OnExitFreeAnimationEventHandler)
    self.exitFreeEffect.gameObject:SetActive(false);
    self.freeText.text = "";
    self.normalBg.gameObject:SetActive(true);
    self.freeBg.gameObject:SetActive(false);
    BQTP_Audio.PlaySound(BQTP_Audio.SoundList.FreeSpin_End);
    self.DelayCall(4, function()
        BQTP_Audio.ClearAuido(BQTP_Audio.SoundList.FreeSpin_End);
        BQTP_Audio.PlayBGM();
        self.CheckState();
    end);
end