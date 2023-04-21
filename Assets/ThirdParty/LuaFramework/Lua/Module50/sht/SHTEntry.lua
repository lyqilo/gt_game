-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion
local g_sYGBHModuleNum = "Module50/sht/";

require(g_sYGBHModuleNum .. "SHT_Network")
require(g_sYGBHModuleNum .. "SHT_Roll")
require(g_sYGBHModuleNum .. "SHT_DataConfig")
require(g_sYGBHModuleNum .. "SHT_Caijin")
require(g_sYGBHModuleNum .. "SHT_Line")
require(g_sYGBHModuleNum .. "SHT_Result")
require(g_sYGBHModuleNum .. "SHT_Rule")
require(g_sYGBHModuleNum .. "SHT_Audio")

SHTEntry = {};
local self = SHTEntry;
self.transform = nil;
self.gameObject = nil;

self.CurrentChip = 0;
self.CurrentChipIndex = 0;
self.isAutoGame = false;
self.isFreeGame = false;
self.isSmallGame = false;
self.isRoll = false;
self.menuTweener = nil;

self.currentAutoCount = 0;--剩余自动次数
self.freeCount = 0;--剩余免费次数

self.myGold = 0;--显示的自身金币
self.clickStartTimer = -1;
self.scatterList = {};
self.FreeList = {};

self.bjjList = {};
self.bjjImgList = {};

self.isshowFree = false;
self.showFreeTimer = 0;
self.hasNewSP = false;

self.betRollList = {};
self.betProgresslist = {};

self.FullSP = false;--碎片集满了
self.isRollSmall = false;
self.smallRollTimer = 0;
self.currentSmallRollIndex = 0;
self.currentSmallCycleCount = 0;
self.smallTempRollTimer = 0;
self.isLastCycle = false;
self.smallSPCount = 0;
self.smallSPRealCount = 0;
self.ispress = false;

local isClickBet=false
local isClickBetTime=0;
self.SmallGameData = {
    --小游戏结果  
    nIndex = 0,
    nGold = 0,
};
self.SceneData = {
    bet = 0, --当前下注
    freeNumber = 0, --免费次数
    nBetonCount = 0, --下注列表个数
    chipList = {}, --下注列表
    Jackpot={},
    BS={},
};
self.ResultData = {
    ImgTable = {}, --图标
    LineTypeTable = {}, --连线类型
    m_nWinPeiLv = 0, --赢得倍数
    FreeCount = 0, --免费次数
    m_nPrizePoolGold = 0, --奖金池金币
    WinScore = 0, --赢得总分
    JACKPOT={},
}
function SHTEntry:Awake(obj)
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
    GameSetsPanel.CreateHideObj(self.MainContent, false);
    SHT_Roll.Init(self.RollContent);
    SHT_Audio.Init();
    SHT_Rule.Init();
    SHT_Network.AddMessage();--添加消息监听
    SHT_Network.LoginGame();--开始登录游戏
    self.userHead.sprite = HallScenPanel.GetHeadIcon();
    self.userName.text = SCPlayerInfo._05wNickName;
    --SHT_Audio.PlayBGM();
end
function SHTEntry.OnDestroy()
    SHT_Line.Close();
    SHT_Network.UnMessage();
end
function SHTEntry:Update()
    self.CanShowAuto();
    SHT_Roll.Update();
    --SHT_Caijin.Update();
    SHT_Line.Update();
    SHT_Result.Update();
    self.AutoSelectFree();
    self.ChipSlider();
end
function SHTEntry.StartRollSmallGame()

end
function SHTEntry.AutoSelectFree()

end

function SHTEntry.ChipSlider()
    if isClickBet then
        isClickBetTime=isClickBetTime+Time.deltaTime
        if isClickBetTime >= 2 then
            isClickBetTime=0
            isClickBet=false
            self.chipBet:DOLocalMove(Vector3.New(0,-100, 0), 0.5);
        end
    end
end

function SHTEntry.CanShowAuto()
    if self.ispress then
        if self.clickStartTimer >= 0 then
            if not self.startBtn.transform:Find("anniu").gameObject.activeSelf then
                self.startBtn.transform:Find("anniu").gameObject:SetActive(true)  
            end
            self.clickStartTimer = self.clickStartTimer + Time.deltaTime;
            if self.clickStartTimer >= 1.5 then
                self.clickStartTimer = -1;
                self.OnClickAutoCall();
            end
        end
    end
end
function SHTEntry.FindComponent()
    self.MainContent = self.transform:Find("MainPanel/Content");
    self.RollContent = self.MainContent:Find("RollContent");--转动区域
    self.BonusPanel=self.MainContent:Find("BG/BonusPanel");--Bonus界面
    self.FreePanel=self.MainContent:Find("BG/FreePanel");--FreePanel
    self.NormalPanel=self.MainContent:Find("BG/NormalPanel");--NormalPanel界面
    self.TopFreeGameGoood=self.FreePanel:Find("FreeReward_FreeScore"):GetComponent("TextMeshProUGUI")
    self.TopFreeCountText=self.FreePanel:Find("FreeReward_FreeCount"):GetComponent("TextMeshProUGUI")
    self.selfGold = self.MainContent:Find("Bottom/Gold/Num"):GetComponent("TextMeshProUGUI");--自身金币
    self.userName = self.MainContent:Find("Bottom/Gold/UserName"):GetComponent("Text");--用户名
    self.userHead = self.MainContent:Find("Bottom/Gold/Head/Mask/Icon"):GetComponent("Image");--用户头像
    self.ChipNum = self.MainContent:Find("Bottom/Chip/Num"):GetComponent("TextMeshProUGUI");--下注金额
    self.WinNum = self.MainContent:Find("Bottom/Win/Num"):GetComponent("TextMeshProUGUI");--本次获得金币
    self.WinDesc = self.MainContent:Find("Bottom/Win/Desc"):GetComponent("TextMeshProUGUI");--本次获得金币
    self.reduceChipBtn = self.MainContent:Find("Bottom/Chip/Reduce"):GetComponent("Button");--减注
    self.addChipBtn = self.MainContent:Find("Bottom/Chip/Add"):GetComponent("Button");--加注
    self.chipProgress = self.MainContent:Find("Bottom/Chip/Mask/Bet/Progress"):GetComponent("Image");
    self.chipPoint = self.MainContent:Find("Bottom/Chip/Mask/Bet/Point");
    self.chipPan = self.MainContent:Find("Bottom/Chip/Mask/Bet/Pan");
    self.chipBet = self.MainContent:Find("Bottom/Chip/Mask/Bet");
    self.btnGroup = self.MainContent:Find("Bottom/ButtonGroup");
    self.startBtn = self.btnGroup:Find("StartBtn");--开始按钮
    self.stopBtn = self.btnGroup:Find("StopBtn"):GetComponent("Button");--停止按钮
    self.stopBtn.gameObject:SetActive(false);
    self.FreeContent = self.btnGroup:Find("Free");--免费状态
    self.FreeContent.gameObject:SetActive(false);
    self.freeText = self.FreeContent.transform:Find("Num"):GetComponent("TextMeshProUGUI");--免费次数
    self.AutoStartBtn = self.btnGroup:Find("AutoState"):GetComponent("Button");--打开自动开始界面
    self.AutoStartBtn.gameObject:SetActive(false);
    self.autoText = self.AutoStartBtn.transform:Find("AutoNum"):GetComponent("TextMeshProUGUI");--自动次数
    self.autoImage = self.AutoStartBtn.transform:Find("Image")

    self.MaxChipBtn = self.btnGroup:Find("MaxChip"):GetComponent("Button");--最大下注
    self.closeAutoMenu = self.btnGroup:Find("CloseAutoMenu"):GetComponent("Button");--关闭自动开始界面
    self.autoSelectList = self.closeAutoMenu.transform:Find("AutoSelect");--自动开始次数选择
    self.closeAutoMenu.gameObject:SetActive(false);

    self.EnterFreeEffect = self.MainContent:Find("FreeEnterPanel");
    self.EnterFreeEffect.gameObject:SetActive(false);
    self.freedownTime = self.EnterFreeEffect:Find("FreeEnter_CountDown"):GetComponent("TextMeshProUGUI");
    self.FreeCountText = self.EnterFreeEffect:Find("FreeEnter_FreeCount"):GetComponent("TextMeshProUGUI");
    self.freeOverBtn = self.EnterFreeEffect:Find("FreeEnter_Continue"):GetComponent("Button");
    
    self.rulePanel = self.MainContent:Find("Rule");--规则界面
    self.ruleChildPanel = self.rulePanel:Find("Content/RuleList"):GetComponent("ScrollRect");--规则子界面
    self.ruleUpBtn = self.rulePanel:Find("Content/LeftBtn"):GetComponent("Button");
    self.ruleDownBtn = self.rulePanel:Find("Content/RightBtn"):GetComponent("Button");
    self.closeRuleBtn = self.rulePanel:Find("Content/BackBtn"):GetComponent("Button");
    self.menuBtn = self.MainContent:Find("Menu"):GetComponent("Button");--菜单按钮
    self.menulist = self.MainContent:Find("MenuList");--菜单按钮详情
    self.backgroundBtn = self.MainContent:Find("CloseMenu"):GetComponent("Button");
    self.closeGame = self.menulist:Find("Content/Back"):GetComponent("Button");
    self.settingBtn = self.menulist:Find("Content/Setting"):GetComponent("Button");
    self.closeGame.transform:SetAsLastSibling();
    self.menulist.localScale = Vector3.New(0, 0, 0);
    self.backgroundBtn.gameObject:SetActive(false);
    self.showRuleBtn = self.MainContent:Find("RuleBtn"):GetComponent("Button");

    self.exitPanel=self.MainContent:Find("Exit_Tip")
    self.exitPanelQX=self.exitPanel:Find("Exit_0/Exit_No"):GetComponent("Button")
    self.exitPanelClose=self.exitPanel:Find("Exit_0/Exit_Close"):GetComponent("Button")
    self.exitPanelSure=self.exitPanel:Find("Exit_0/Exit_Yes"):GetComponent("Button")
    self.exitPanel.gameObject:SetActive(false);

    self.settingPanel = self.MainContent:Find("Setting");
    self.musicSet = self.settingPanel:Find("Content/Music"):GetComponent("Slider");
    self.soundSet = self.settingPanel:Find("Content/Sound"):GetComponent("Slider");
    self.closeSet = self.settingPanel:Find("Content/Close"):GetComponent("Button");

   --特效
    self.resultEffect = self.MainContent:Find("Result");--中奖后特效

    self.winNormalEffect = self.resultEffect:Find("Reward");
    self.winNormalNum = self.winNormalEffect:Find("Image/RewardNum"):GetComponent("TextMeshProUGUI");
    self.winLZPos=self.resultEffect:Find("pos")
    self.winLZPos_SHT_shoujinbi=self.winLZPos:Find("SHT_shoujinbi")
    self.winclie=self.winNormalEffect:Find("jb")
    
    self.winLZPos_SHT_shoujinbi.gameObject:SetActive(false)



    self.greatEffect = self.resultEffect:Find("Great");
    self.greatProgress = self.greatEffect:Find("Slider"):GetComponent("Slider");
    self.closeGreatBtn = self.greatEffect:Find("Close"):GetComponent("Button");
    self.winGreatNum = self.greatEffect:Find("Num"):GetComponent("TextMeshProUGUI");

    self.goodEffect = self.resultEffect:Find("Good");
    self.goodProgress = self.goodEffect:Find("Slider"):GetComponent("Slider");
    self.closegoodBtn = self.goodEffect:Find("Close"):GetComponent("Button");
    self.winGoodNum = self.goodEffect:Find("Num"):GetComponent("TextMeshProUGUI");

    self.perfectEffect = self.resultEffect:Find("Perfect");
    self.prefectProgress = self.perfectEffect:Find("Slider"):GetComponent("Slider");
    self.closeperfectBtn = self.perfectEffect:Find("Close"):GetComponent("Button");
    self.winPerfectNum = self.perfectEffect:Find("Num"):GetComponent("TextMeshProUGUI");

    self.bigEffect = self.resultEffect:Find("Big");
    self.winBigNum = self.bigEffect:Find("Content/Num"):GetComponent("TextMeshProUGUI");
    self.closebigBtn = self.bigEffect:Find("Close"):GetComponent("Button");
    self.bigProgress = self.bigEffect:Find("Content/Image/Image"):GetComponent("Image");
    self.bigWinTitle = self.bigEffect:Find("Content/Titles")

    self.BangEffect = self.resultEffect:Find("Bang");
    self.winBangNum = self.BangEffect:Find("Content/Num"):GetComponent("TextMeshProUGUI");
    self.BangProgress = self.BangEffect:Find("Content/Image/Image"):GetComponent("Image");
    self.BangWinTitle = self.BangEffect:Find("Content/Titles")
    self.closeBangBtn = self.BangEffect:Find("Close"):GetComponent("Button");

    SHT_Caijin.Init(self.NormalPanel.gameObject)

    
    self.smallEffect = self.resultEffect:Find("SmallReward");
    self.winSmallEffectNum = self.smallEffect:Find("Num"):GetComponent("TextMeshProUGUI");
    self.freeOverTime = self.smallEffect:Find("FreeWin_CountDown"):GetComponent("TextMeshProUGUI");
    self.free2OverBtn = self.smallEffect:Find("FreeWin_Continue"):GetComponent("Button");

   --

    self.icons = self.MainContent:Find("Icons");--图标库
    self.effectList = self.MainContent:Find("EffectList");--动画库
    self.effectPool = self.MainContent:Find("EffectPool");--动画缓存库
    self.LineGroup = self.MainContent:Find("LineGroup");--连线
    self.CSGroup = self.MainContent:Find("CSContent");--显示财神
    self.soundList = self.MainContent:Find("SoundList");--声音库

    --if not AllSetGameInfo._5IsPlayAudio then
    --    self.musicSet.value = 0;
    --else
    --    if PlayerPrefs.HasKey("MusicValue") then
    --        local musicVole = PlayerPrefs.GetString("MusicValue");
    --        self.musicSet.value = tonumber(musicVole);
    --    else
    --        self.musicSet.value = 1;
    --    end
    --end
    --
    --if PlayerPrefs.HasKey("SoundValue") then
    --    local soundVole = PlayerPrefs.GetString("SoundValue");
    --    if tonumber(soundVole) > 0 then
    --        AllSetGameInfo._6IsPlayEffect=true
    --    else
    --        AllSetGameInfo._6IsPlayEffect=false
    --    end
    --end
    --logYellow("AllSetGameInfo._6IsPlayEffect=="..tostring(AllSetGameInfo._6IsPlayEffect))
    --if not AllSetGameInfo._6IsPlayEffect then
    --    self.soundSet.value = 0;
    --else
    --    if PlayerPrefs.HasKey("SoundValue") then
    --        local soundVole = PlayerPrefs.GetString("SoundValue");
    --        self.soundSet.value = tonumber(soundVole);
    --    else
    --        self.soundSet.value = 1;
    --    end
    --end
    self.musicSet.value = MusicManager:GetMusicVolume();
    self.soundSet.value = MusicManager:GetSoundVolume();
end
function SHTEntry.AddListener()
    --添加监听事件
    self.reduceChipBtn.onClick:RemoveAllListeners();
    self.reduceChipBtn.onClick:AddListener(self.ReduceChipCall);
    self.addChipBtn.onClick:RemoveAllListeners();
    self.addChipBtn.onClick:AddListener(self.AddChipCall);
    self.startBtn:GetComponent("Button").onClick:RemoveAllListeners();
    self.startBtn:GetComponent("Button").onClick:AddListener(self.StartGameCall);
    local et = self.startBtn.gameObject:AddComponent(typeof(LuaFramework.EventTriggerListener));
    et.onDown = self.OnDownStartBtnCall;
    et.onUp = self.OnUpStartBtnCall;
    self.stopBtn.onClick:RemoveAllListeners();
    self.stopBtn.onClick:AddListener(self.StartGameCall);

    self.menuBtn.onClick:RemoveAllListeners();
    self.menuBtn.onClick:AddListener(self.ClickMenuCall);
    self.backgroundBtn.onClick:RemoveAllListeners();
    self.backgroundBtn.onClick:AddListener(self.CloseMenuCall);

    self.closeGame.onClick:RemoveAllListeners();
    self.closeGame.onClick:AddListener(function()
        self.CloseMenuCall()
        self.exitPanel.gameObject:SetActive(true)
    end);

    self.settingBtn.onClick:RemoveAllListeners();
    self.settingBtn.onClick:AddListener(self.OpenSettingPanel);
    self.musicSet.onValueChanged:RemoveAllListeners();
    self.musicSet.onValueChanged:AddListener(self.SetMusicVolumn);
    self.soundSet.onValueChanged:RemoveAllListeners();
    self.soundSet.onValueChanged:AddListener(self.SetSoundVolumn);
    self.closeSet.onClick:RemoveAllListeners();
    self.closeSet.onClick:AddListener(function()
        SHT_Audio.PlaySound(SHT_Audio.SoundList.CloseClick);
        self.settingPanel.gameObject:SetActive(false);
    end);

    self.AutoStartBtn.onClick:RemoveAllListeners();
    self.AutoStartBtn.onClick:AddListener(self.OnClickAutoCall);

    for i = 1, self.autoSelectList.childCount do
        --自动次数选择
        local child = self.autoSelectList:GetChild(i - 1);
        child:GetComponent("Button").onClick:RemoveAllListeners();
        child:GetComponent("Button").onClick:AddListener(function()
            self.currentAutoCount = tonumber(child.name);
            SHT_Audio.PlaySound(SHT_Audio.SoundList.BtnClick);
            self.OnClickAutoItemCall();
        end)
        child.gameObject:SetActive(true);
    end
    self.closeAutoMenu.onClick:RemoveAllListeners();--关闭自动
    self.closeAutoMenu.onClick:AddListener(function()
        self.closeAutoMenu.gameObject:SetActive(false);
    end)
    self.showRuleBtn.onClick:RemoveAllListeners();--显示规则
    self.showRuleBtn.onClick:AddListener(self.ShowRultPanel);

    self.MaxChipBtn.onClick:RemoveAllListeners();
    self.MaxChipBtn.onClick:AddListener(self.SetMaxChipCall);

    self.closeGreatBtn.onClick:RemoveAllListeners();
    self.closeGreatBtn.onClick:AddListener(function()
        SHT_Result.QuickOver(1);
    end);
    self.closegoodBtn.onClick:RemoveAllListeners();
    self.closegoodBtn.onClick:AddListener(function()
        SHT_Result.QuickOver(2);
    end);
    self.closeperfectBtn.onClick:RemoveAllListeners();
    self.closeperfectBtn.onClick:AddListener(function()
        SHT_Result.QuickOver(3);
    end);
    -- self.closebigBtn.onClick:RemoveAllListeners();
    -- self.closebigBtn.onClick:AddListener(function()
    --     SHT_Result.QuickOver(4);
    -- end);

    -- self.closeBangBtn.onClick:RemoveAllListeners();
    -- self.closeBangBtn.onClick:AddListener(function()
    --     SHT_Result.QuickOver(5);
    -- end);

    self.freeOverBtn.onClick:RemoveAllListeners();
    self.freeOverBtn.onClick:AddListener(self.FreeOverBtnCall);

    self.free2OverBtn.onClick:RemoveAllListeners();
    self.free2OverBtn.onClick:AddListener(self.FreeOverBtnCall);

    self.exitPanelQX.onClick:RemoveAllListeners();
    self.exitPanelQX.onClick:AddListener(function()
        SHT_Audio.PlaySound(SHT_Audio.SoundList.CloseClick);
        self.exitPanel.gameObject:SetActive(false)
    end);
    
    self.exitPanelClose.onClick:RemoveAllListeners();
    self.exitPanelClose.onClick:AddListener(function()
        SHT_Audio.PlaySound(SHT_Audio.SoundList.CloseClick);
        self.exitPanel.gameObject:SetActive(false)
    end);

    self.exitPanelSure.onClick:RemoveAllListeners();
    self.exitPanelSure.onClick:AddListener(self.CloseGameCall);
end
function SHTEntry.GetGameConfig()
    --获取远程端配置
    local formdata = FormData.New();
    formdata:AddField("v", os.time());
    UnityWebRequestManager.Instance:GetText("http://127.0.0.1:80/module27.json", 4, formdata, function(state, result)
        log(result);
        local data = json.decode(result);
        SHT_DataConfig.rollTime = data.rollTime;
        SHT_DataConfig.rollReboundRate = data.rollReboundRate;
        SHT_DataConfig.rollInterval = data.rollInterval;
        SHT_DataConfig.rollSpeed = data.rollSpeed;
        SHT_DataConfig.caijinGoldChangeRate = data.caijinGoldChangeRate;
        SHT_DataConfig.winGoldChangeRate = data.winGoldChangeRate;
        SHT_DataConfig.selfGoldChangeRate = data.selfGoldChangeRate;
        SHT_DataConfig.freeLoadingShowTime = data.freeLoadingShowTime;
        SHT_DataConfig.smallGameLoadingShowTime = data.smallGameLoadingShowTime;
        SHT_DataConfig.rollDistance = data.rollDistance;
        SHT_DataConfig.REQCaiJinTime = data.REQCaiJinTime;
        SHT_DataConfig.lineAllShowTime = data.lineAllShowTime;
        SHT_DataConfig.cyclePlayLineTime = data.cyclePlayLineTime;
        SHT_DataConfig.waitShowLineTime = data.waitShowLineTime;
        SHT_DataConfig.autoRewardInterval = data.autoRewardInterval;
        SHT_DataConfig.autoNoRewardInterval = data.autoNoRewardInterval;
    end);
end
function SHTEntry.ToCharArray(num)
    --拆解字符串
    local str = tostring(num);
    local list1 = {}
    for i = 1, string.len(str) do
        table.insert(list1, #list1 + 1, string.sub(str, i, i));
    end
    return list1;
end
function SHTEntry.FormatNumberThousands(num)
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
function SHTEntry.ShowText(str,short)
    if short ~= nil and not short then
        return ShowRichText(str);
    end
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
function SHTEntry.ReduceChipCall()
    --减注
    SHT_Audio.PlaySound(SHT_Audio.SoundList.BetClick);
    if self.SceneData.chipList == nil or self.SceneData.nBetonCount <= 0 then
        return ;
    end

    local upChipNum=self.SceneData.chipList[self.CurrentChipIndex]

    self.CurrentChipIndex = self.CurrentChipIndex - 1;
    if self.CurrentChipIndex <= 0 then
        self.CurrentChipIndex = 1;
    end

    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    SHT_Rule.SetBeiShu()
    isClickBet=true
    isClickBetTime=0
    self.chipBet:DOLocalMove(Vector3.New(0, -18.7, 0), 0.5);

    if self.chipprogressTween ~= nil then
        self.chipprogressTween:Kill();
    end
    self.chipprogressTween = self.chipProgress:DOFillAmount(self.betProgresslist[self.CurrentChipIndex], 0.1);
    self.chipPan:DOLocalRotate(Vector3.New(0, 0, self.betRollList[self.CurrentChipIndex]/4), 0.1);
    self.chipPoint:DOLocalRotate(Vector3.New(0, 0,self.betRollList[self.CurrentChipIndex]), 0.1);

    SHT_Caijin:SetCAIJIN(SHTEntry.SceneData.Jackpot[self.CurrentChipIndex])

    self.bigwinTweener = Util.RunWinScore(upChipNum*SHT_DataConfig.ALLLINECOUNT,self.SceneData.chipList[self.CurrentChipIndex]* SHT_DataConfig.ALLLINECOUNT, 0.5, function(value)
        self.ChipNum.text =self.ShowText(math.floor(value)) 
    end);
end
function SHTEntry.AddChipCall()
    --加注
    SHT_Audio.PlaySound(SHT_Audio.SoundList.BetClick);
    if self.SceneData.chipList == nil or self.SceneData.nBetonCount <= 0 then
        return ;
    end
    local upChipNum=self.SceneData.chipList[self.CurrentChipIndex]
    self.CurrentChipIndex = self.CurrentChipIndex + 1;
    self.chipBet:DOLocalMove(Vector3.New(0, -18.7, 0), 0.5);
    isClickBet=true
    isClickBetTime=0
    if self.CurrentChipIndex > self.SceneData.nBetonCount then
        self.CurrentChipIndex = self.SceneData.nBetonCount;
        MessageBox.CreatGeneralTipsPanel("已是最大下注!")
    end

    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    SHT_Rule.SetBeiShu()
    if self.chipprogressTween ~= nil then
        self.chipprogressTween:Kill();
    end
    self.chipprogressTween = self.chipProgress:DOFillAmount(self.betProgresslist[self.CurrentChipIndex], 0.1);
    self.chipPan:DOLocalRotate(Vector3.New(0, 0,self.betRollList[self.CurrentChipIndex]/4), 0.1);
    self.chipPoint:DOLocalRotate(Vector3.New(0, 0,self.betRollList[self.CurrentChipIndex]), 0.1);
    SHT_Caijin:SetCAIJIN(SHTEntry.SceneData.Jackpot[self.CurrentChipIndex])
    
    self.bigwinTweener = Util.RunWinScore(upChipNum*SHT_DataConfig.ALLLINECOUNT,self.SceneData.chipList[self.CurrentChipIndex]* SHT_DataConfig.ALLLINECOUNT, 0.5, function(value)
        self.ChipNum.text =self.ShowText(math.floor(value)) 
    end);
end

function SHTEntry.SetMaxChipCall()
    --设置最大下注
    SHT_Audio.PlaySound(SHT_Audio.SoundList.BetClick);
    local upChipNum=self.SceneData.chipList[self.CurrentChipIndex]
    self.CurrentChipIndex = self.SceneData.nBetonCount;
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    SHT_Rule.SetBeiShu()
    if self.chipprogressTween ~= nil then
        self.chipprogressTween:Kill();
    end

    isClickBet=true
    isClickBetTime=0
    self.chipBet:DOLocalMove(Vector3.New(0, -18.7, 0), 0.5);

    self.chipprogressTween = self.chipProgress:DOFillAmount(self.betProgresslist[self.CurrentChipIndex], 0.1);
    self.chipPan:DOLocalRotate(Vector3.New(0, 0,self.betRollList[self.CurrentChipIndex]/4), 0.1);
    self.chipPoint:DOLocalRotate(Vector3.New(0, 0,self.betRollList[self.CurrentChipIndex]), 0.1);
    SHT_Caijin:SetCAIJIN(SHTEntry.SceneData.Jackpot[self.CurrentChipIndex ])
    self.bigwinTweener = Util.RunWinScore(upChipNum*SHT_DataConfig.ALLLINECOUNT,self.SceneData.chipList[self.CurrentChipIndex]* SHT_DataConfig.ALLLINECOUNT, 0.5, function(value)
        self.ChipNum.text =self.ShowText(math.floor(value)) 
    end);
end



function SHTEntry.SetMusicVolumn(value)
    MusicManager:SetValue(MusicManager:GetSoundVolume(),value);
    SHT_Audio.pool.volume = value;
    MusicManager:SetMusicMute(value <= 0);
    SHT_Audio.pool.mute = not MusicManager:GetIsPlayMV();
end
function SHTEntry.SetSoundVolumn(value)
    MusicManager:SetValue(value,MusicManager:GetMusicVolume());
    MusicManager:SetSoundMute(value <= 0);
end
function SHTEntry.StartGameCall()
    --开始游戏
    logYellow("开始游戏")


    self.startBtn.transform:GetComponent("Image").color = Color.gray;
    self.startBtn:GetComponent("Button").interactable = false;
    if self.isFreeGame or self.isAutoGame then
        return ;
    end
    if self.isRoll then
        --TODO 急停
        self.startBtn.gameObject:SetActive(true);
        self.stopBtn.gameObject:SetActive(false);
        SHT_Roll.StopRoll();
        return ;
    end
    SHT_Audio.PlaySound(SHT_Audio.SoundList.BtnClick);

    if self.myGold < self.CurrentChip * SHT_DataConfig.ALLLINECOUNT then
        MessageBox.CreatGeneralTipsPanel("Not enough gold!")
        SHTEntry.startBtn.transform:GetComponent("Image").color = Color.white;
        SHTEntry.startBtn:GetComponent("Button").interactable = true;
        SHTEntry.addChipBtn.interactable = true;
        SHTEntry.reduceChipBtn.interactable = true;
        SHTEntry.MaxChipBtn.interactable = true;
        return ;
    end

    self.addChipBtn.interactable = false;
    self.reduceChipBtn.interactable = false;
    self.MaxChipBtn.interactable = false;

    self.startBtn.gameObject:SetActive(false);
    self.stopBtn.gameObject:SetActive(true);
    self.FreeContent.gameObject:SetActive(false);
    self.AutoStartBtn.gameObject:SetActive(false);
    
    --TODO 发送开始消息,等待结果开始转动
    SHT_Network.StartGame();
end
function SHTEntry.ClickMenuCall()
    --点击显示菜单
    SHT_Audio.PlaySound(SHT_Audio.SoundList.BtnClick);
    if self.menuTweener ~= nil then
        self.menuTweener:Kill();
    end
    self.backgroundBtn.gameObject:SetActive(true);
    self.backgroundBtn.interactable = false;
    self.menulist.gameObject:SetActive(true);
    self.menuBtn.interactable=false
    self.menuTweener = self.menulist:DOScale(Vector3.New(1, 1, 1), 0.2):OnComplete(function()
        self.backgroundBtn.interactable = true;
        if self.menuTweener ~= nil then
            self.menuTweener = nil;
        end
    end);
    if self.menuTweener ~= nil then
        self.menuTweener:SetAutoKill();
    end
end
function SHTEntry.CloseMenuCall()
    --关闭菜单
    SHT_Audio.PlaySound(SHT_Audio.SoundList.BtnClick);
    if self.menuTweener ~= nil then
        self.menuTweener:Kill();
    end
    self.backgroundBtn.interactable = false;
    self.menuBtn.interactable=true

    self.menuTweener = self.menulist:DOScale(Vector3.New(0, 0, 0), 0.2):OnComplete(function()
        self.backgroundBtn.interactable = true;
        self.menulist.gameObject:SetActive(false);
        self.backgroundBtn.gameObject:SetActive(false);
        if self.menuTweener ~= nil then
            self.menuTweener = nil;
        end
    end);
    if self.menuTweener ~= nil then
        self.menuTweener:SetAutoKill();
    end
end
function SHTEntry.CloseGameCall()
    if not self.isFreeGame and not self.isSmallGame then
        Event.Brocast(MH.Game_LEAVE);
    else
        MessageBox.CreatGeneralTipsPanel("Cannot leave the game in special mode");
    end
end
function SHTEntry.OpenSettingPanel()
    self.CloseMenuCall();
    self.settingPanel.gameObject:SetActive(true);
end
function SHTEntry.SetSoundCall()
    if AllSetGameInfo._5IsPlayAudio or AllSetGameInfo._6IsPlayEffect then
        SetInfoSystem.GameMute();
        self.soundOn:SetActive(false);
        self.soundOff:SetActive(true);
    else
        SetInfoSystem.ResetMute();
        self.soundOn:SetActive(true);
        self.soundOff:SetActive(false);
    end
    SHT_Audio.pool.mute = not AllSetGameInfo._5IsPlayAudio;
end
function SHTEntry.OnDownStartBtnCall()
    self.clickStartTimer = 0;
    self.ispress = true;
end
function SHTEntry.OnUpStartBtnCall()
    self.ispress = false;
    self.clickStartTimer = -1;
    self.startBtn.transform:Find("anniu").gameObject:SetActive(false)
end
function SHTEntry.OnClickAutoCall()
    --点击自动开始
    --SHT_Audio.PlaySound(SHT_Audio.SoundList.BTN);
    if self.isAutoGame then
        self.StopAutoGame();
        return ;
    end
    self.closeAutoMenu.gameObject:SetActive(true);
    self.startBtn.transform:Find("anniu").gameObject:SetActive(false)  

end
function SHTEntry.OnSelectFreeTypeCall(selectObj, unselectObj, index)
    --选择免费类型
    self.showFreeTimer = SHT_DataConfig.freeWaitTime;
    self.isshowFree = false;
    --SHT_Network.SelectFree();
    local pos = nil;
    if index == 1 then
        pos = Vector3.New(1334, -100, 0);
    else
        pos = Vector3.New(-1334, -100, 0);
    end
    local outEffect = function()
        coroutine.wait(0.8);
        self.freedownTime.text = "";
        local showDescFunc = function()
            local backImg = self.EnterFreeEffect:Find("Background");
            while backImg.gameObject.activeSelf do
                coroutine.wait(0.01);
            end
            self.EnterFreeEffect.gameObject:SetActive(false);
            --TODO 开始免费游戏
            self.FreeGame();
        end
        unselectObj.transform:DOLocalMove(pos, 0.5);
        unselectObj:DOFade(0, 0.5);
        unselectObj.transform:DOScale(Vector3.New(0.5, 0.5, 0.5), 0.5):OnComplete(function()
            unselectObj.gameObject:SetActive(false);
            unselectObj:DOFade(1, 0.01);
            unselectObj.transform:DOScale(Vector3.New(1, 1, 1), 0.01);
            coroutine.stop(showDescFunc);
            coroutine.start(showDescFunc);
        end);
        selectObj.transform:DOLocalMove(Vector3.New(0, 0, 0), 0.5);
    end
    coroutine.stop(outEffect);
    coroutine.start(outEffect);
end
function SHTEntry.OnClickAutoItemCall()
    --点击选择自动次数
    self.isAutoGame = true;
    self.ispress = false;
    self.stopBtn.gameObject:SetActive(false);
    self.startBtn.transform:GetComponent("Image").color = Color.gray;
    self.startBtn.gameObject:SetActive(false);
    self.FreeContent.gameObject:SetActive(false);
    self.AutoStartBtn.gameObject:SetActive(true);
    self.closeAutoMenu.gameObject:SetActive(false);
    SHTEntry.addChipBtn.interactable = false;
    SHTEntry.reduceChipBtn.interactable = false;
    SHTEntry.MaxChipBtn.interactable = false;
    if self.isFreeGame then
        self.FreeContent.gameObject:SetActive(true);
        self.AutoStartBtn.gameObject:SetActive(false);
    else
        if self.myGold < self.CurrentChip * SHT_DataConfig.ALLLINECOUNT then
            MessageBox.CreatGeneralTipsPanel("Not enough gold!")
            return ;
        end
    end
    if self.currentAutoCount > 1000 then
        self.autoText.text = "∞";
    else
        self.autoText.text = tostring(self.currentAutoCount);
    end
    if not self.isRoll and not self.isFreeGame then
        --没有转动的状态开始自动旋转
        log("开始自动游戏")
        SHT_Network.StartGame();
    end
end
function SHTEntry.ShowRultPanel()
    --显示规则
    SHT_Audio.PlaySound(SHT_Audio.SoundList.BtnClick);
    SHT_Rule.ShowRule();
end


function SHTEntry.FreeOverBtnCall()
    SHT_Audio.PlaySound(SHT_Audio.SoundList.BtnClick);
    if SHT_Result.hideFreeTime>4.75 then
        SHT_Result.hideFreeTime=0
    end
end

function SHTEntry.CSJLRoll()
    SHT_Network.StartGame();
end
function SHTEntry.StopAutoGame()
    --停止自动旋转
    self.isAutoGame = false;
    self.currentAutoCount = 0;
    self.stopBtn.gameObject:SetActive(false);
    self.startBtn.gameObject:SetActive(true);
    self.FreeContent.gameObject:SetActive(false);
    self.AutoStartBtn.gameObject:SetActive(false);
end
function SHTEntry.FreeGame()
    --免费游戏
    self.isFreeGame = true;
    self.startBtn.gameObject:SetActive(false);
    self.stopBtn.gameObject:SetActive(false);
    self.AutoStartBtn.gameObject:SetActive(false);
    self.FreeContent.gameObject:SetActive(true);
    self.FreeContent.transform:Find("Num"):GetComponent("TextMeshProUGUI").text = ShowRichText(self.freeCount);
    self.TopFreeCountText.text = ShowRichText(self.freeCount);
    logYellow("免费游戏")

    SHT_Network.StartGame();
end
function SHTEntry.ChangeGold(gold)
    self.selfGold.text =self.ShowText(gold)   --tostring(gold);
end
function SHTEntry.Roll()
    --开始转动    
    logYellow("开始转动")
    self.WinDesc.text = "恭喜发财";
    if not self.isFreeGame and not SHT_Result.isWinCSJL then
        self.myGold = self.myGold - self.CurrentChip * SHT_DataConfig.ALLLINECOUNT;
        SHTEntry.ChangeGold(self.myGold);
    end
    self.WinNum.text = self.ShowText("0");
    SHT_Result.HideResult();
    SHT_Line.Close();
    SHT_Roll.StartRoll();
    self.chipBet:DOLocalMove(Vector3.New(0, -100, 0), 0.5);
end
function SHTEntry.OnStop()
    --停止转动
    log("停止")
    SHT_Result.ShowResult();
end
function SHTEntry.InitPanel()
    --场景消息初始化
    self.myGold = TableUserInfo._7wGold;
    SHTEntry.ChangeGold(self.myGold);

    self.betRollList = {};
    self.betProgresslist = {};
    for i = 1, #self.SceneData.chipList do
        table.insert(self.betRollList, (-100/(#self.SceneData.chipList - 1)) * (i - 1));
        table.insert(self.betProgresslist, 0.18 + (0.64 / (#self.SceneData.chipList - 1)) * (i - 1));
    end

    for i = 1, self.SceneData.nBetonCount do
        if self.SceneData.chipList[i] == self.SceneData.bet then
            self.CurrentChipIndex = i;
            self.CurrentChip = self.SceneData.bet;
            if self.chipprogressTween ~= nil then
                self.chipprogressTween:Kill();
            end
            self.chipprogressTween = self.chipProgress:DOFillAmount(self.betProgresslist[self.CurrentChipIndex], 0.1);
            self.chipPan:DOLocalRotate(Vector3.New(0, 0,self.betRollList[self.CurrentChipIndex]/4), 0.1);
            self.chipPoint:DOLocalRotate(Vector3.New(0, 0,self.betRollList[self.CurrentChipIndex]), 0.1);
        end
    end

    if self.SceneData.freeNumber <= 0 then
        self.CurrentChipIndex = CheckNear(TableUserInfo._7wGold,self.SceneData.chipList);
    end
    self.ChipNum.text = self.ShowText(self.CurrentChip * SHT_DataConfig.ALLLINECOUNT);
    self.WinNum.text =self.ShowText("0");
    SHT_Caijin.isCanSend = true;
    self.isRoll = false;
    SHT_Line.Init();
    SHT_Result.Init();

    SHT_Caijin:SetCAIJIN(SHTEntry.SceneData.Jackpot[self.CurrentChipIndex])

    if self.SceneData.freeNumber > 0 then
        --如果免费
        self.freeCount = self.SceneData.freeNumber;
        self.ResultData.FreeCount = self.freeCount;
        self.isFreeGame = true;
        SHT_Result.isFreeGame = true;
        SHTEntry.SetState(2)
        if self.SceneData.freeNumber == 10 then
            SHT_Result.ShowFreeEffect(true);
        else
            SHTEntry.addChipBtn.interactable = false;
            SHTEntry.reduceChipBtn.interactable = false;
            SHTEntry.MaxChipBtn.interactable = false;
            SHT_Result.CheckFree();
        end
    else
        SHTEntry.SetState(1)
    end
end
function SHTEntry.OpenZP()

end
function SHTEntry.CloseZP()

end
function SHTEntry.RollZP()
    --转转盘
    self.currentSmallRollIndex = 0;
    self.currentSmallCycleCount = 0;
    self.smallRollTimer = 0;
    self.smallTempRollTimer = SHT_DataConfig.smallRollDurationTime;
    self.isLastCycle = false;
    self.StartRollSmallGame();
end

function SHTEntry.SetState(state)
    if state == 1 then
        --正常模式 or 自动模式
        self.BonusPanel.gameObject:SetActive(true)
        self.FreePanel.gameObject:SetActive(true)
        self.NormalPanel.gameObject:SetActive(true)

    elseif state == 2 then
        --免费模式
        self.BonusPanel.gameObject:SetActive(true)
        self.FreePanel.gameObject:SetActive(true)
        self.NormalPanel.gameObject:SetActive(false)

    elseif state == 3 then
        --zidong
        self.BonusPanel.gameObject:SetActive(true)
        self.FreePanel.gameObject:SetActive(false)
        self.NormalPanel.gameObject:SetActive(false)
    end
end


function SHTEntry.ShowFreeGame()
    --显示免费界面
    self.EnterFreeEffect.gameObject:SetActive(true);
    self.showFreeTimer = SHT_DataConfig.freeWaitTime;
    self.isshowFree = true;
end
function SHTEntry.FreeRoll()
    --判断是否为免费游戏
    SHT_Result.isShow = false;
    if self.isFreeGame then
        
        if self.freeCount <= 0 then
            --免费结束
            if SHT_Result.showFreeTweener ~= nil then
                SHT_Result.showFreeTweener:Kill();
                SHT_Result.showFreeTweener = nil;
            end
            self.FreeContent.gameObject:SetActive(false);
            self.isFreeGame = false;
            SHT_Result.isFreeGame = false;
            for i = 1, self.CSGroup.childCount do
                for j = 1, self.CSGroup:GetChild(i - 1).childCount do
                    self.CSGroup:GetChild(i - 1):GetChild(j - 1).gameObject:SetActive(false);
                end
            end
            SHT_Audio.PlayBGM();
            SHTEntry.SetState(1)
            self.AutoRoll();
        else
            --还有免费次数
            self.FreeGame();
        end
    else
        self.AutoRoll();
    end
end
function SHTEntry.AutoRoll()
    --判断是否为自动游戏
    if self.isAutoGame then
        --如果是自动游戏
        if self.currentAutoCount < 1000 then
            self.currentAutoCount = self.currentAutoCount - 1;
        end
        if self.currentAutoCount < 0 then
            --自动次数使用完了，回到待机状态
            self.StopAutoGame();
            SHTEntry.startBtn.transform:GetComponent("Image").color = Color.white;
            SHTEntry.startBtn:GetComponent("Button").interactable = true;
            SHTEntry.addChipBtn.interactable = true;
            SHTEntry.reduceChipBtn.interactable = true;
            SHTEntry.MaxChipBtn.interactable = true;
        else
            --还有自动次数
            self.OnClickAutoItemCall();
        end
    else
        --不是自动游戏，直接待机
        self.StopAutoGame();
        SHTEntry.startBtn.transform:GetComponent("Image").color = Color.white;
        SHTEntry.startBtn:GetComponent("Button").interactable = true;
        SHTEntry.addChipBtn.interactable = true;
        SHTEntry.reduceChipBtn.interactable = true;
        SHTEntry.MaxChipBtn.interactable = true;
    end
end