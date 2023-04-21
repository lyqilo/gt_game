-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion
local g_swlzbNum = "Module59/XMZZ/";

require(g_swlzbNum .. "XMZZ_Network")
require(g_swlzbNum .. "XMZZ_Roll")
require(g_swlzbNum .. "XMZZ_DataConfig")
require(g_swlzbNum .. "XMZZ_Line")
require(g_swlzbNum .. "XMZZ_Result")
require(g_swlzbNum .. "XMZZ_Rule")
require(g_swlzbNum .. "XMZZ_Audio")
require(g_swlzbNum .. "XMZZ_Caijin")

XMZZEntry = {};
local self = XMZZEntry;
self.transform = nil;
self.gameObject = nil;
self.luaBehaviour = nil;

self.CurrentMoveLongIndex = 0;
self.CurrentFreeIndex = 0;
self.CurrentChip = 0;
self.CurrentChipIndex = 0;
self.isAutoGame = false;
self.isFreeGame = false;
self.isSmallGame = false;
self.isRoll = false;
self.menuTweener = nil;
self.freeType = 0;
self.freeWildCount = 0;

self.currentFreeCount = 0;

self.currentAutoCount = 0;--剩余自动次数
self.freeCount = 0;--剩余免费次数
self.totalFreeCount = 0;

self.smallGameCount = 0;

self.myGold = 0;--显示的自身金币
self.ScatterList = {};

self.ReRollCount = 0;
self.isScene = false;
self.clickStartTimer = -1;

self.SceneData = {
    freeNumber = 0, --免费次数
    bet = 0, --当前下注
    chipNum = 0, --用户金币
    chipList = {}, --下注列表
    cbColWild = {},
    freeType = 0,
};
self.ResultData = {
    ImgTable = {}, --图标
    LineTypeTable = {}, --击中的图标
    WinScore = 0, --赢得总分
    FreeCount = 0, --免费次数
    nFreeType = 0--wild出现在第几列
}
function XMZZEntry:Awake(obj)
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
    XMZZ_Roll.Init(self.RollContent);
    XMZZ_Audio.Init();
    XMZZ_Line.Init();
    XMZZ_Result.Init();
    XMZZ_Network.AddMessage();--添加消息监听
    XMZZ_Network.LoginGame();--开始登录游戏
    GameSetsPanel.CreateHideObj(self.MainContent, false);
    XMZZ_Audio.PlayBGM();
end
--
function XMZZEntry.OnDestroy()
    XMZZ_Line.Close();
    XMZZ_Network.UnMessage();
end

function XMZZEntry:Update()
    self.CanShowAuto();
    XMZZ_Caijin.Update();
    XMZZ_Roll.Update();
end

function XMZZEntry.CanShowAuto()
    if self.clickStartTimer >= 0 then
        self.clickStartTimer = self.clickStartTimer + Time.deltaTime;
        if self.clickStartTimer >= 0.5 and not self.isPlayAudio and self.clickStartTimer < 1 then
            self.isPlayAudio = true;
        end
        if self.clickStartTimer >= 1 then
            self.clickStartTimer = -1;
            self.isPlayAudio = false;
            self.OnClickAutoCall();
        end
    end
end
function XMZZEntry.FindComponent()
    self.MainContent = self.transform:Find("MainPanel");

    self.normalBg = self.MainContent:Find("Content/Background/Normal");
    self.JackpotNum = self.normalBg:Find("Num"):GetComponent("TextMeshProUGUI");
    self.freeBg = self.MainContent:Find("Content/Background/Free");
    self.freeText = self.freeBg:Find("Num"):GetComponent("TextMeshProUGUI");

    self.RollContent = self.MainContent:Find("Content/RollContent");--转动区域
    self.ChipNum = self.MainContent:Find("Content/Bottom/Chip/Num"):GetComponent("TextMeshProUGUI");--下注金额

    self.winNum = self.MainContent:Find("Content/Bottom/Win/Num"):GetComponent("TextMeshProUGUI");

    self.reduceChipBtn = self.MainContent:Find("Content/Bottom/Chip/Reduce"):GetComponent("Button");--减注
    self.addChipBtn = self.MainContent:Find("Content/Bottom/Chip/Add"):GetComponent("Button");--加注

    self.btnGroup = self.MainContent:Find("Content/ButtonGroup");
    self.startBtn = self.btnGroup:Find("StartBtn");--开始按钮
    self.startState = self.startBtn.transform:Find("Start"):GetComponent("Button");
    self.stopState = self.startBtn.transform:Find("Stop"):GetComponent("Button");

    self.MaxChipBtn = self.btnGroup:Find("MaxChip"):GetComponent("Button");--最大下注
    self.AutoBtn = self.btnGroup:Find("AutoBtn"):GetComponent("Button");--最大下注

    self.rulePanel = self.MainContent:Find("Content/Rule");--规则界面
    self.ruleList = self.rulePanel:Find("Content/RuleList"):GetComponent("ScrollRect");--规则子界面
    self.leftShowBtn = self.rulePanel:Find("Content/LeftBtn"):GetComponent("Button");
    self.rightShowBtn = self.rulePanel:Find("Content/RightBtn"):GetComponent("Button");
    self.closeRuleBtn = self.rulePanel:Find("Content/BackBtn"):GetComponent("Button");

    self.closeGame = self.MainContent:Find("Content/QuitGameBtn"):GetComponent("Button");
    self.showRuleBtn = self.MainContent:Find("Content/RuleBtn"):GetComponent("Button");

    self.userInfo = self.MainContent:Find("Content/Bottom/UserInfo");
    self.headImg = self.userInfo:Find("Head"):GetComponent("Image");--自身金币
    self.nickName = self.userInfo:Find("NickName"):GetComponent("Text");--自身金币
    self.selfGold = self.userInfo:Find("GoldNum"):GetComponent("TextMeshProUGUI");--自身金币

    self.resultEffect = self.MainContent:Find("Content/Result");
    self.normalEffect = self.resultEffect:Find("NormalWin");
    self.normalEffectClose = self.normalEffect:Find("Close"):GetComponent("Button");--本次获得金币
    self.normalEffectNum = self.normalEffect:Find("Num"):GetComponent("TextMeshProUGUI");--本次获得金币
    self.middleEffect = self.resultEffect:Find("MiddleWin");
    self.middleEffectClose = self.middleEffect:Find("Close"):GetComponent("Button");--本次获得金币
    self.middleEffectNum = self.middleEffect:Find("Num"):GetComponent("TextMeshProUGUI");--本次获得金币
    self.bigEffect = self.resultEffect:Find("BigWin");
    self.bigEffectClose = self.bigEffect:Find("Close"):GetComponent("Button");--本次获得金币
    self.bigEffectNum = self.bigEffect:Find("Num"):GetComponent("TextMeshProUGUI");--本次获得金币

    self.icons = self.MainContent:Find("Content/Icons");--图标库
    self.effectList = self.MainContent:Find("Content/EffectList");--动画库
    self.effectPool = self.MainContent:Find("Content/EffectPool");--动画缓存库
    self.CSGroup = self.MainContent:Find("Content/CSContent");--显示特別效果
    self.LineGroup = self.MainContent:Find("Content/LineGroup");--显示特別效果
    self.soundList = self.MainContent:Find("Content/SoundList");--声音库

    self.quitPanel = self.MainContent:Find("Content/QuitPanel");

end
self.isAddListener=false;
function XMZZEntry.AddListener()
    --添加监听事件
    if(self.isAddListener) then
        return;
    end
    self.reduceChipBtn.onClick:RemoveAllListeners();
    self.reduceChipBtn.onClick:AddListener(self.ReduceChipCall);
    self.addChipBtn.onClick:RemoveAllListeners();
    self.addChipBtn.onClick:AddListener(self.AddChipCall);

    local et = self.startState.gameObject:AddComponent(typeof(LuaFramework.EventTriggerListener));
    et.onDown = self.OnDownStartBtnCall;
    et.onUp = self.OnUpStartBtnCall;

    self.stopState.onClick:RemoveAllListeners();
    self.stopState.onClick:AddListener(self.StopGame);

    self.closeGame.onClick:RemoveAllListeners();
    self.closeGame.onClick:AddListener(self.CloseGameCall);
    self.showRuleBtn.onClick:RemoveAllListeners();--显示规则
    self.showRuleBtn.onClick:AddListener(self.ShowRulePanel);

    self.MaxChipBtn.onClick:RemoveAllListeners();
    self.MaxChipBtn.onClick:AddListener(self.SetMaxChipCall);
    self.AutoBtn.onClick:RemoveAllListeners();
    self.AutoBtn.onClick:AddListener(self.StopAutoGame);
    self.isAddListener = true;
end

function XMZZEntry.ToCharArray(num)
    --拆解字符串
    local str = tostring(num);
    local list1 = {}
    for i = 1, string.len(str) do
        table.insert(list1, #list1 + 1, string.sub(str, i, i));
    end
    return list1;
end

function XMZZEntry.FormatNumberThousands(num)
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

function XMZZEntry.SetSelfGold(str)
    self.selfGold.text = self.ShowText(str);
end

function XMZZEntry.ShowText(str,short)
    if short ~= nil and not short then
        return ShowRichText(str);
    end
    return ShowRichText(ShortNumber(str))
    --str = ShortNumber(str);
    ----展示tmp字体
    --local arr = self.ToCharArray(str);
    --local _str = "";
    --for i = 1, #arr do
    --    _str = _str .. string.format("<sprite name=\"%s\" tint=1>", arr[i]);
    --end
    --return _str;
end

function XMZZEntry.ReduceChipCall()
    --减注
    XMZZ_Audio.PlaySound(XMZZ_Audio.SoundList.BTN);
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
    self.ChipNum.text = self.ShowText(self.CurrentChip * XMZZ_DataConfig.ALLLINECOUNT);
end

function XMZZEntry.AddChipCall()
    --加注
    XMZZ_Audio.PlaySound(XMZZ_Audio.SoundList.BTN);
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
    self.ChipNum.text = self.ShowText(self.CurrentChip * XMZZ_DataConfig.ALLLINECOUNT);
end

function XMZZEntry.OnDownStartBtnCall()
    if self.isRoll then
        return;
    end
    self.clickStartTimer = 0;
    self.isPlayAudio = false;
end

function XMZZEntry.OnUpStartBtnCall()
    if self.clickStartTimer < 1 and self.clickStartTimer ~= -1 then
        self.clickStartTimer = -1;
        self.isPlayAudio = false;
        self.StartGameCall();
    end
end
function XMZZEntry.StartGameCall()
    --开始游戏
    if self.isFreeGame then
        return ;
    end
    if self.isRoll then
        --TODO 急停
        return ;
    end
    XMZZ_Audio.PlaySound(XMZZ_Audio.SoundList.Panda_Spin);
    self.NormalRollState();
end
function XMZZEntry.StopGame()
    XMZZ_Audio.PlaySound(XMZZ_Audio.SoundList.BTN);
    self.startState.gameObject:SetActive(false);
    self.stopState.gameObject:SetActive(true);
    self.startState.interactable = false;
    self.stopState.interactable = false;
    XMZZ_Roll.StopRoll();
end
function XMZZEntry.CloseGameCall()
    XMZZ_Audio.PlaySound(XMZZ_Audio.SoundList.BTN);
    self.quitPanel.gameObject:SetActive(true);
    local backHallBtn = self.quitPanel:Find("Content/BackHall"):GetComponent("Button");
    local closeBtn = self.quitPanel:Find("Content/ContinueGame"):GetComponent("Button");
    local closebtn1 = self.quitPanel:Find("Content/Close"):GetComponent("Button");
    backHallBtn.onClick:RemoveAllListeners();
    backHallBtn.onClick:AddListener(function()
        XMZZ_Audio.PlaySound(XMZZ_Audio.SoundList.BTN);
        if not self.isFreeGame then
            Event.Brocast(MH.Game_LEAVE);
        else
            MessageBox.CreatGeneralTipsPanel("Cannot leave the game in special mode");
        end
    end);
    closeBtn.onClick:RemoveAllListeners();
    closeBtn.onClick:AddListener(function()
        XMZZ_Audio.PlaySound(XMZZ_Audio.SoundList.BTN);
        self.quitPanel.gameObject:SetActive(false);
    end);
    closebtn1.onClick:RemoveAllListeners();
    closebtn1.onClick:AddListener(function()
        XMZZ_Audio.PlaySound(XMZZ_Audio.SoundList.BTN);
        self.quitPanel.gameObject:SetActive(false);
    end);
end
function XMZZEntry.OnClickAutoCall()
    --点击自动开始
    XMZZ_Audio.PlaySound(XMZZ_Audio.SoundList.BTN);
    if not self.isAutoGame then
        self.AutoRollState();
    else
        self.StopAutoGame();
    end
    self.isAutoGame = true;
end
function XMZZEntry.ShowRulePanel()
    --显示规则
    XMZZ_Audio.PlaySound(XMZZ_Audio.SoundList.BTN);
    XMZZ_Rule.ShowRule();
end
function XMZZEntry.SetMaxChipCall()
    --设置最大下注
    XMZZ_Audio.PlaySound(XMZZ_Audio.SoundList.BTN);
    self.CurrentChipIndex = self.SceneData.chipNum;
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.CurrentChip * XMZZ_DataConfig.ALLLINECOUNT);
end

function XMZZEntry.StopAutoGame()
    --停止自动旋转
    self.isAutoGame = false;
    self.currentAutoCount = 0;
    self.startState.gameObject:SetActive(false);
    self.stopState.gameObject:SetActive(true);
    self.AutoBtn.gameObject:SetActive(false);
    self.startState.interactable = false;
    self.stopState.interactable = false;
end
function XMZZEntry.Roll()
    --开始转动    
    if not self.isFreeGame then
        self.myGold = self.myGold - self.CurrentChip * XMZZ_DataConfig.ALLLINECOUNT;
        XMZZEntry.SetSelfGold(self.myGold);
    end
    self.winNum.text = self.ShowText(0);
    XMZZ_Line.Close();
    XMZZ_Roll.StartRoll();
end
function XMZZEntry.OnStop()
    --停止转动
    log("停止")
    XMZZ_Result.ShowResult();
end
function XMZZEntry.InitPanel()
    --场景消息初始化
    self.myGold = TableUserInfo._7wGold;
    self.nickName.text = TableUserInfo._2szNickName;
    self.headImg.sprite = HallScenPanel.GetHeadIcon();
    XMZZEntry.SetSelfGold(self.myGold);
    for i = 1, #self.SceneData.chipList do
        if self.SceneData.chipList[i] == self.SceneData.bet then
            self.CurrentChipIndex = i;
            self.CurrentChip = self.SceneData.bet;
        end
    end

    if self.SceneData.freeNumber <= 0 then
        self.CurrentChipIndex = CheckNear(TableUserInfo._7wGold,self.SceneData.chipList);
    end 
    
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.CurrentChip * XMZZ_DataConfig.ALLLINECOUNT);
    if self.freeType == 2 then
        for i = 1, #self.SceneData.cbColWild do
            if self.SceneData.cbColWild[i] ~= 0 then
                self.freeWildCount = 6 - i;
                break ;
            end
        end
    else
        self.CurrentMoveLongIndex = self.freeCount;
    end
    self.winNum.text = self.ShowText("0");
    self.isRoll = false;
    self.isFreeGame = false;
    self.isAutoGame = false;
    self.isScene = true;
    self.CheckState();
    self.AddListener();
end
function XMZZEntry.DelayCall(timer, callback)
    return Util.RunWinScore(0, 1, timer, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        if callback ~= nil then
            callback();
        end
    end);
end
function XMZZEntry.IdleState()
    self.startState.gameObject:SetActive(true);
    self.stopState.gameObject:SetActive(false);
    self.AutoBtn.gameObject:SetActive(false);
    self.startState.interactable = true;
    self.stopState.interactable = true;
    self.MaxChipBtn.interactable = true;
    self.AutoBtn.gameObject:SetActive(false);
    self.AutoBtn.interactable = true;
    self.addChipBtn.interactable = true;
    self.reduceChipBtn.interactable = true;
    self.closeGame.interactable = true;
    self.isAutoGame = false;
    self.currentAutoCount = 0;
    self.isFreeGame = false;
    self.isRoll = false;
end

function XMZZEntry.NormalRollState()
    self.startState.gameObject:SetActive(false);
    self.stopState.gameObject:SetActive(true);
    self.AutoBtn.gameObject:SetActive(false);
    self.startState.interactable = false;
    self.stopState.interactable = true;
    self.MaxChipBtn.interactable = false;
    self.AutoBtn.interactable = false;
    self.addChipBtn.interactable = false;
    self.reduceChipBtn.interactable = false;
    self.closeGame.interactable = false;
    self.isRoll = true;
    XMZZ_Network.StartGame();
end
function XMZZEntry.AutoRollState()
    self.startState.gameObject:SetActive(false);
    self.stopState.gameObject:SetActive(false);
    self.AutoBtn.gameObject:SetActive(true);
    self.startState.interactable = false;
    self.stopState.interactable = false;
    self.MaxChipBtn.interactable = false;
    self.AutoBtn.interactable = true;
    self.addChipBtn.interactable = false;
    self.reduceChipBtn.interactable = false;
    self.closeGame.interactable = false;
    self.currentAutoCount = 10000;
    if not self.isRoll then
        self.isRoll = true;
        XMZZ_Network.StartGame();
    end
end
function XMZZEntry.FreeRollState()
    self.startState.gameObject:SetActive(false);
    self.stopState.gameObject:SetActive(true);
    self.startState.interactable = false;
    self.stopState.interactable = false;
    self.MaxChipBtn.interactable = false;
    self.AutoBtn.interactable = false;
    self.addChipBtn.interactable = false;
    self.reduceChipBtn.interactable = false;
    self.closeGame.interactable = false;
    self.isRoll = true;
    XMZZ_Audio.PlaySound(XMZZ_Audio.SoundList.Panda_Spin);
    XMZZ_Network.StartGame();
end
function XMZZEntry.CheckState()
    self.isRoll = false;
    if self.freeCount > 0 then
        self.freeText.text = self.ShowText(self.freeCount,false);
        if self.isFreeGame then
            self.CheckFreeType();
        else
            self.isFreeGame = true;
            self.freeText.text = self.ShowText(self.freeCount,false);
            self.normalBg.gameObject:SetActive(false);
            self.freeBg.gameObject:SetActive(true);
            XMZZ_Audio.PlayBGM(XMZZ_Audio.SoundList.FreeBGM);
            if self.freeType == 1 then
                if not self.isScene then
                    self.CurrentMoveLongIndex = self.freeCount;
                end
            else
                self.CurrentMoveLongIndex = 5;
                if not self.isScene then
                    self.freeWildCount = 1;
                end
            end
            XMZZ_Result.ShowFreeEffect();
        end
    else
        self.normalBg.gameObject:SetActive(true);
        self.freeBg.gameObject:SetActive(false);
        if self.isFreeGame then
            self.isFreeGame = false;
            self.freeText.text = "";
            XMZZ_Audio.PlayBGM();
            for i = 1, self.RollContent.childCount do
                self.RollContent:GetChild(i - 1):GetComponent("CanvasGroup").alpha = 1;
                self.CSGroup:GetChild(i - 1):GetComponent("CanvasGroup").alpha = 0;
            end
            self.CheckState();
        elseif self.isAutoGame then
            self.AutoRollState();
        else
            self.IdleState();
        end
    end
end
function XMZZEntry.CheckFreeType()
    --是否移动龙
    if self.freeType == 1 then
        if self.freeCount == 5 then
            self.FreeRollState();
        else
            XMZZ_Result.MoveLong();
        end
    else
        if self.freeCount == 5 then
            self.FreeRollState();
        else
            --判断有没有出现整列wild
            local isfind = false;
            for i = 1, 5 - self.freeWildCount do
                local trans = self.CSGroup:GetChild(i - 1);
                local count = 0;
                for j = 1, trans.childCount do
                    if string.find(trans:GetChild(j - 1).gameObject.name, "10") ~= nil then
                        count = count + 1;
                    end
                end
                if count >= 3 then
                    isfind = true;
                    break ;
                end
            end
            if isfind then
                self.freeWildCount = self.freeWildCount + 1;
                self.CurrentMoveLongIndex = 6 - self.freeWildCount;
                XMZZ_Result.StartDownLong(self.freeWildCount, 1);
            else
                self.FreeRollState();
            end
        end
    end
end