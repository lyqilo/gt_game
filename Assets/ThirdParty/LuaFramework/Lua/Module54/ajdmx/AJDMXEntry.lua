-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion
local g_sYGBHModuleNum = "Module54/ajdmx/";

require(g_sYGBHModuleNum .. "AJDMX_Network")
require(g_sYGBHModuleNum .. "AJDMX_Roll")
require(g_sYGBHModuleNum .. "AJDMX_DataConfig")
require(g_sYGBHModuleNum .. "AJDMX_Caijin")
require(g_sYGBHModuleNum .. "AJDMX_Line")
require(g_sYGBHModuleNum .. "AJDMX_Result")
require(g_sYGBHModuleNum .. "AJDMX_Rule")
require(g_sYGBHModuleNum .. "AJDMX_Audio")
require(g_sYGBHModuleNum .. "AJDMX_SmallGame")


AJDMXEntry = {};
local self = AJDMXEntry;
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

self.maxFreeGameCount=0

local isClickBet=false
local isClickBetTime=0;
local isTipshow=false
local isTipShowTime=0
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
    cbIsSmallGame=0,
    cbIndex=0,

    nMaxGameCount=0,
    nMaxGameType={},
    nMaxGameIndex={},

};
self.ResultData = {
    ImgTable = {}, --图标
    LineTypeTable = {}, --连线类型
    m_nWinPeiLv = 0, --赢得倍数
    FreeCount = 0, --免费次数
    m_nPrizePoolGold = 0, --奖金池金币
    WinScore = 0, --赢得总分
    JACKPOT={},
    cbHitBouns=0,
    cbIndex=0,
}
self.smallGameData = {
	cbResCode=  0,--	// 0:失败 1：成功
	cbPoint=    0,--	// 点数
	cbType=     0,--	// 0:正常 1：最大机会 2：再来一次
	cbFreeTime= 0,--	// 免费次数
    nWinGold=   0,--	// 小游戏得分
    
}
self.MaxGameData = {
    cbResCode=0,
    cbFreeTime=0,
    nWinGold=0,
}
function AJDMXEntry:Awake(obj)
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
    AJDMX_Roll.Init(self.RollContent);
    AJDMX_Audio.Init();
    AJDMX_Rule.Init();
    AJDMX_Network.AddMessage();--添加消息监听
    AJDMX_Network.LoginGame();--开始登录游戏
    self.userHead.sprite = HallScenPanel.GetHeadIcon();
    self.userName.text = SCPlayerInfo._05wNickName;
    AJDMX_Audio.PlayBGM();
end
function AJDMXEntry.OnDestroy()
    AJDMX_Line.Close();
    AJDMX_Network.UnMessage();
end
function AJDMXEntry:Update()
    self.CanShowAuto();
    AJDMX_Roll.Update();
    --AJDMX_Caijin.Update();
    AJDMX_Line.Update();
    AJDMX_Result.Update();
    self.AutoSelectFree();
    self.ChipSlider();
end
function AJDMXEntry.StartRollSmallGame()

end
function AJDMXEntry.AutoSelectFree()

end

function AJDMXEntry.ChipSlider()
    if isClickBet then
        isClickBetTime=isClickBetTime+Time.deltaTime
        if isClickBetTime >= 2 then
            isClickBetTime=0
            isClickBet=false
            self.chipBet:DOLocalMove(Vector3.New(0,-120, 0), 0.5);
        end
    end
    if isTipshow then
        isTipShowTime=isTipShowTime+Time.deltaTime
        if isTipShowTime>1.5 then
            isTipshow=false
            isTipShowTime=0
            self.tipPanel.gameObject:SetActive(false)
        end
    end
end

function AJDMXEntry.CanShowAuto()
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
function AJDMXEntry.FindComponent()
    self.MainContent = self.transform:Find("MainPanel/Content");
    self.RollContent = self.MainContent:Find("RollContent");--转动区域
    self.BonusPanel=self.MainContent:Find("BG/BonusPanel");--Bonus界面

    self.FreePanel=self.MainContent:Find("BG/FreePanel");--FreePanel
    self.NormalPanel=self.MainContent:Find("BG/NormalPanel");--NormalPanel界面

    self.selfGold = self.MainContent:Find("Bottom/Gold/Num"):GetComponent("TextMeshProUGUI");--自身金币
    self.userName = self.MainContent:Find("Bottom/Gold/UserName"):GetComponent("Text");--用户名
    self.userHead = self.MainContent:Find("Bottom/Gold/Head/Mask/Icon"):GetComponent("Image");--用户头像
    self.ChipNum = self.MainContent:Find("Bottom/Chip/Num"):GetComponent("TextMeshProUGUI");--下注金额
    self.WinNum = self.MainContent:Find("Bottom/Win/Num"):GetComponent("TextMeshProUGUI");--本次获得金币
    self.WinDesc = self.MainContent:Find("Bottom/Win/Desc"):GetComponent("TextMeshProUGUI");--本次获得金币
    self.reduceChipBtn = self.MainContent:Find("Bottom/Chip/Reduce"):GetComponent("Button");--减注
    self.addChipBtn = self.MainContent:Find("Bottom/Chip/Add"):GetComponent("Button");--加注
    self.chipProgress = self.MainContent:Find("Bottom/Chip/Mask/Bet/Progress"):GetComponent("Image");
    self.chipPoint = self.MainContent:Find("Bottom/Chip/Mask/Bet/Point/Point");
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

    self.rulePanel = self.MainContent:Find("Rule");--规则界面
    self.ruleChildPanel = self.rulePanel:Find("Content/RuleList"):GetComponent("ScrollRect");--规则子界面
    self.ruleUpBtn = self.rulePanel:Find("Content/LeftBtn"):GetComponent("Button");
    self.ruleDownBtn = self.rulePanel:Find("Content/RightBtn"):GetComponent("Button");
    self.closeRuleBtn = self.rulePanel:Find("Content/BackBtn"):GetComponent("Button");

    self.menulist = self.MainContent:Find("MenuList");--菜单按钮详情
    self.backgroundBtn = self.MainContent:Find("CloseMenu"):GetComponent("Button");
    self.closeGame = self.MainContent:Find("Back"):GetComponent("Button");
    self.settingBtn = self.MainContent:Find("Setting"):GetComponent("Button");

    self.closeGame.transform:SetAsLastSibling();
    self.menulist.localScale = Vector3.New(0, 0, 0);
    self.backgroundBtn.gameObject:SetActive(false);
    self.showRuleBtn = self.MainContent:Find("RuleBtn"):GetComponent("Button");

    self.exitPanel=self.MainContent:Find("Exit_Tip")
    self.exitPanelQX=self.exitPanel:Find("Exit_0/Exit_No"):GetComponent("Button")
    self.exitPanelClose=self.exitPanel:Find("Exit_0/Exit_Close"):GetComponent("Button")
    self.exitPanelSure=self.exitPanel:Find("Exit_0/Exit_Yes"):GetComponent("Button")
    self.exitPanel.gameObject:SetActive(false);

    self.settingPanel = self.MainContent:Find("SettingPanel");
    self.musicSet = self.settingPanel:Find("Content/Music"):GetComponent("Slider");
    self.soundSet = self.settingPanel:Find("Content/Sound"):GetComponent("Slider");
    self.closeSet = self.settingPanel:Find("Content/Close"):GetComponent("Button");

    self.SmallGamePanel=self.MainContent:Find("SmallGamePanel").gameObject
    AJDMX_SmallGame:Init(self.SmallGamePanel)
   --特效
    self.resultEffect = self.MainContent:Find("Result");--中奖后特效

    self.winNormalEffect = self.resultEffect:Find("Reward");
    
    self.winLZPos=self.winNormalEffect:Find("pos")
    self.winLZPos_AJDMX_shoujinbi=self.winLZPos:Find("AJDMX_shoujinbi")

    self.closeNormalEffectBtn = self.winNormalEffect:Find("Close"):GetComponent("Button");

    self.winLZPos_AJDMX_shoujinbi.gameObject:SetActive(false)

    -- self.greatEffect = self.resultEffect:Find("Great");
    -- self.greatProgress = self.greatEffect:Find("Slider"):GetComponent("Slider");
    -- self.closeGreatBtn = self.greatEffect:Find("Close"):GetComponent("Button");
    -- self.winGreatNum = self.greatEffect:Find("Num"):GetComponent("TextMeshProUGUI");

    -- self.goodEffect = self.resultEffect:Find("Good");
    -- self.goodProgress = self.goodEffect:Find("Slider"):GetComponent("Slider");
    -- self.closegoodBtn = self.goodEffect:Find("Close"):GetComponent("Button");
    -- self.winGoodNum = self.goodEffect:Find("Num"):GetComponent("TextMeshProUGUI");

    -- self.perfectEffect = self.resultEffect:Find("Perfect");
    -- self.prefectProgress = self.perfectEffect:Find("Slider"):GetComponent("Slider");
    -- self.closeperfectBtn = self.perfectEffect:Find("Close"):GetComponent("Button");
    -- self.winPerfectNum = self.perfectEffect:Find("Num"):GetComponent("TextMeshProUGUI");

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
    self.AJDMX_bingwin01=self.BangEffect:Find("Content/AJDMX_bingwin01")
    self.AJDMX_bingwin01.gameObject:SetActive(false)

    self.smallEffect = self.resultEffect:Find("SmallReward");
    self.winSmallEffectNum = self.smallEffect:Find("Num"):GetComponent("TextMeshProUGUI");
    
    self.tipPanel=self.MainContent:Find("Tips/Tips1")
    self.tipPanel.gameObject:SetActive(false)

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
    --if PlayerPrefs.HasKey("SoundValue") then
    --    local soundVole = PlayerPrefs.GetString("SoundValue");
    --    if tonumber(soundVole) > 0 then
    --        AllSetGameInfo._6IsPlayEffect=true
    --    else
    --        AllSetGameInfo._6IsPlayEffect=false
    --    end
    --end
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
function AJDMXEntry.AddListener()
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
        AJDMX_Audio.PlaySound(AJDMX_Audio.SoundList.BtnClick);
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
            AJDMX_Audio.PlaySound(AJDMX_Audio.SoundList.BtnClick);
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

    self.exitPanelQX.onClick:RemoveAllListeners();
    self.exitPanelQX.onClick:AddListener(function()
        AJDMX_Audio.PlaySound(AJDMX_Audio.SoundList.BtnClick);
        self.exitPanel.gameObject:SetActive(false)
    end);
    
    self.exitPanelClose.onClick:RemoveAllListeners();
    self.exitPanelClose.onClick:AddListener(function()
        AJDMX_Audio.PlaySound(AJDMX_Audio.SoundList.BtnClick);
        self.exitPanel.gameObject:SetActive(false)
    end);

    self.exitPanelSure.onClick:RemoveAllListeners();
    self.exitPanelSure.onClick:AddListener(self.CloseGameCall);
end
function AJDMXEntry.GetGameConfig()
    --获取远程端配置
    local formdata = FormData.New();
    formdata:AddField("v", os.time());
    UnityWebRequestManager.Instance:GetText("http://127.0.0.1:80/module27.json", 4, formdata, function(state, result)
        log(result);
        local data = json.decode(result);
        AJDMX_DataConfig.rollTime = data.rollTime;
        AJDMX_DataConfig.rollReboundRate = data.rollReboundRate;
        AJDMX_DataConfig.rollInterval = data.rollInterval;
        AJDMX_DataConfig.rollSpeed = data.rollSpeed;
        AJDMX_DataConfig.caijinGoldChangeRate = data.caijinGoldChangeRate;
        AJDMX_DataConfig.winGoldChangeRate = data.winGoldChangeRate;
        AJDMX_DataConfig.selfGoldChangeRate = data.selfGoldChangeRate;
        AJDMX_DataConfig.freeLoadingShowTime = data.freeLoadingShowTime;
        AJDMX_DataConfig.smallGameLoadingShowTime = data.smallGameLoadingShowTime;
        AJDMX_DataConfig.rollDistance = data.rollDistance;
        AJDMX_DataConfig.REQCaiJinTime = data.REQCaiJinTime;
        AJDMX_DataConfig.lineAllShowTime = data.lineAllShowTime;
        AJDMX_DataConfig.cyclePlayLineTime = data.cyclePlayLineTime;
        AJDMX_DataConfig.waitShowLineTime = data.waitShowLineTime;
        AJDMX_DataConfig.autoRewardInterval = data.autoRewardInterval;
        AJDMX_DataConfig.autoNoRewardInterval = data.autoNoRewardInterval;
    end);
end
function AJDMXEntry.ToCharArray(num)
    --拆解字符串
    local str = tostring(num);
    local list1 = {}
    for i = 1, string.len(str) do
        table.insert(list1, #list1 + 1, string.sub(str, i, i));
    end
    return list1;
end
function AJDMXEntry.FormatNumberThousands(num)
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
function AJDMXEntry.ShowText(str)
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
function AJDMXEntry.ReduceChipCall()
    --减注
    AJDMX_Audio.PlaySound(AJDMX_Audio.SoundList.BtnClick);
    if self.SceneData.chipList == nil or self.SceneData.nBetonCount <= 0 then
        return ;
    end

    local upChipNum=self.SceneData.chipList[self.CurrentChipIndex]

    self.CurrentChipIndex = self.CurrentChipIndex - 1;
    if self.CurrentChipIndex <= 0 then
        self.CurrentChipIndex = 1;
        self.tipPanel:Find("Tips1BG0/Tips1Text"):GetComponent("Text").text="Already a min bet"
        self.tipPanel.gameObject:SetActive(true)
        isTipshow=true
        isTipShowTime=0
    end

    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    AJDMX_Rule.SetBeiShu()
    isClickBet=true
    isClickBetTime=0
    self.chipBet:DOLocalMove(Vector3.New(0, -20, 0), 0.5);

    if self.chipprogressTween ~= nil then
        self.chipprogressTween:Kill();
    end
    self.chipprogressTween = self.chipProgress:DOFillAmount(self.betProgresslist[self.CurrentChipIndex], 0.1);
    self.chipPan:DOLocalRotate(Vector3.New(0, 0, self.betRollList[self.CurrentChipIndex]), 0.1);
    self.chipPoint:DOLocalRotate(Vector3.New(0, 0,self.betRollList[self.CurrentChipIndex]), 0.1);

    self.bigwinTweener = Util.RunWinScore(upChipNum*AJDMX_DataConfig.ALLLINECOUNT,self.SceneData.chipList[self.CurrentChipIndex]* AJDMX_DataConfig.ALLLINECOUNT, 0.5, function(value)
        self.ChipNum.text = ShortNumber(value)--self.ShowText() 
    end);
end
function AJDMXEntry.AddChipCall()
    --加注
    AJDMX_Audio.PlaySound(AJDMX_Audio.SoundList.BtnClick);
    if self.SceneData.chipList == nil or self.SceneData.nBetonCount <= 0 then
        return ;
    end
    local upChipNum=self.SceneData.chipList[self.CurrentChipIndex]
    self.CurrentChipIndex = self.CurrentChipIndex + 1;
    self.chipBet:DOLocalMove(Vector3.New(0, -20, 0), 0.5);
    isClickBet=true
    isClickBetTime=0
    if self.CurrentChipIndex > self.SceneData.nBetonCount then
        self.CurrentChipIndex = self.SceneData.nBetonCount;
        self.tipPanel:Find("Tips1BG0/Tips1Text"):GetComponent("Text").text="Already a max bet"
        self.tipPanel.gameObject:SetActive(true)
        isTipshow=true
        isTipShowTime=0
    end
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    AJDMX_Rule.SetBeiShu()
    if self.chipprogressTween ~= nil then
        self.chipprogressTween:Kill();
    end
    self.chipprogressTween = self.chipProgress:DOFillAmount(self.betProgresslist[self.CurrentChipIndex], 0.1);
    self.chipPan:DOLocalRotate(Vector3.New(0, 0,self.betRollList[self.CurrentChipIndex]), 0.1);
    self.chipPoint:DOLocalRotate(Vector3.New(0, 0,self.betRollList[self.CurrentChipIndex]), 0.1);

    
    self.bigwinTweener = Util.RunWinScore(upChipNum*AJDMX_DataConfig.ALLLINECOUNT,self.SceneData.chipList[self.CurrentChipIndex]* AJDMX_DataConfig.ALLLINECOUNT, 0.5, function(value)
        self.ChipNum.text = ShortNumber(value) --self.ShowText(math.floor(value)) 
    end);
end

function AJDMXEntry.SetMaxChipCall()
    --设置最大下注
    AJDMX_Audio.PlaySound(AJDMX_Audio.SoundList.BtnClick);
    local upChipNum=self.SceneData.chipList[self.CurrentChipIndex]
    self.CurrentChipIndex = self.SceneData.nBetonCount;
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    AJDMX_Rule.SetBeiShu()
    if self.chipprogressTween ~= nil then
        self.chipprogressTween:Kill();
    end
    isClickBet=true
    isClickBetTime=0
    self.chipBet:DOLocalMove(Vector3.New(0, -20, 0), 0.5);
    self.chipprogressTween = self.chipProgress:DOFillAmount(self.betProgresslist[self.CurrentChipIndex], 0.1);
    self.chipPan:DOLocalRotate(Vector3.New(0, 0,self.betRollList[self.CurrentChipIndex]/4), 0.1);
    self.chipPoint:DOLocalRotate(Vector3.New(0, 0,self.betRollList[self.CurrentChipIndex]), 0.1);
    self.bigwinTweener = Util.RunWinScore(upChipNum*AJDMX_DataConfig.ALLLINECOUNT,self.SceneData.chipList[self.CurrentChipIndex]* AJDMX_DataConfig.ALLLINECOUNT, 0.5, function(value)
        self.ChipNum.text = ShortNumber(value)--self.ShowText(math.floor(value)) 
    end);
end



function AJDMXEntry.SetMusicVolumn(value)
    MusicManager:SetValue(MusicManager:GetSoundVolume(),value);
    AJDMX_Audio.pool.volume = value;
    MusicManager:SetMusicMute(value <= 0);
    AJDMX_Audio.pool.mute = not MusicManager:GetIsPlayMV();
end
function AJDMXEntry.SetSoundVolumn(value)
    MusicManager:SetValue(value,MusicManager:GetMusicVolume());
    MusicManager:SetSoundMute(value <= 0);
end
function AJDMXEntry.StartGameCall()
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
        AJDMX_Roll.StopRoll();
        return ;
    end
    AJDMX_Audio.PlaySound(AJDMX_Audio.SoundList.BtnClick);

    if self.myGold < self.CurrentChip * AJDMX_DataConfig.ALLLINECOUNT then
        MessageBox.CreatGeneralTipsPanel("Insufficient gold coins!")
        AJDMXEntry.startBtn.transform:GetComponent("Image").color = Color.white;
        AJDMXEntry.startBtn:GetComponent("Button").interactable = true;
        AJDMXEntry.addChipBtn.interactable = true;
        AJDMXEntry.reduceChipBtn.interactable = true;
        AJDMXEntry.MaxChipBtn.interactable = true;
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
    AJDMX_Network.StartGame();
end
function AJDMXEntry.ClickMenuCall()
    --点击显示菜单
    AJDMX_Audio.PlaySound(AJDMX_Audio.SoundList.BtnClick);
    if self.menuTweener ~= nil then
        self.menuTweener:Kill();
    end
    self.backgroundBtn.gameObject:SetActive(true);
    self.backgroundBtn.interactable = false;
    self.menulist.gameObject:SetActive(true);
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
function AJDMXEntry.CloseMenuCall()
    --关闭菜单
    AJDMX_Audio.PlaySound(AJDMX_Audio.SoundList.BtnClick);
    if self.menuTweener ~= nil then
        self.menuTweener:Kill();
    end
    self.backgroundBtn.interactable = false;
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
function AJDMXEntry.CloseGameCall()
    if not self.isFreeGame and not self.isSmallGame then
        Event.Brocast(MH.Game_LEAVE);
    else
        MessageBox.CreatGeneralTipsPanel("Cannot leave the game in special mode");
    end
end
function AJDMXEntry.OpenSettingPanel()
    self.CloseMenuCall();
    self.settingPanel.gameObject:SetActive(true);
end
function AJDMXEntry.SetSoundCall()
    if AllSetGameInfo._5IsPlayAudio or AllSetGameInfo._6IsPlayEffect then
        SetInfoSystem.GameMute();
        self.soundOn:SetActive(false);
        self.soundOff:SetActive(true);
    else
        SetInfoSystem.ResetMute();
        self.soundOn:SetActive(true);
        self.soundOff:SetActive(false);
    end
    AJDMX_Audio.pool.mute = not AllSetGameInfo._5IsPlayAudio;
end
function AJDMXEntry.OnDownStartBtnCall()
    self.clickStartTimer = 0;
    self.ispress = true;
end
function AJDMXEntry.OnUpStartBtnCall()
    self.ispress = false;
    self.clickStartTimer = -1;
    self.startBtn.transform:Find("anniu").gameObject:SetActive(false)
end
function AJDMXEntry.OnClickAutoCall()
    --点击自动开始
    --AJDMX_Audio.PlaySound(AJDMX_Audio.SoundList.BTN);
    if self.isAutoGame then
        self.StopAutoGame();
        return ;
    end
    self.closeAutoMenu.gameObject:SetActive(true);
    self.startBtn.transform:Find("anniu").gameObject:SetActive(false)  

end

function AJDMXEntry.OnClickAutoItemCall()
    --点击选择自动次数
    self.isAutoGame = true;
    self.ispress = false;
    self.stopBtn.gameObject:SetActive(false);
    self.startBtn.transform:GetComponent("Image").color = Color.gray;
    self.startBtn.gameObject:SetActive(false);
    self.FreeContent.gameObject:SetActive(false);
    self.AutoStartBtn.gameObject:SetActive(true);
    self.closeAutoMenu.gameObject:SetActive(false);
    AJDMXEntry.addChipBtn.interactable = false;
    AJDMXEntry.reduceChipBtn.interactable = false;
    AJDMXEntry.MaxChipBtn.interactable = false;
    if self.isFreeGame then
        self.FreeContent.gameObject:SetActive(true);
        self.AutoStartBtn.gameObject:SetActive(false);
    else
        if self.myGold < self.CurrentChip * AJDMX_DataConfig.ALLLINECOUNT then
            MessageBox.CreatGeneralTipsPanel("Insufficient gold coins!")
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
        AJDMX_Network.StartGame();
    end
end
function AJDMXEntry.ShowRultPanel()
    --显示规则
    AJDMX_Audio.PlaySound(AJDMX_Audio.SoundList.BtnClick);
    AJDMX_Rule.ShowRule();
end


function AJDMXEntry.CSJLRoll()
    AJDMX_Network.StartGame();
end
function AJDMXEntry.StopAutoGame()
    --停止自动旋转
    self.isAutoGame = false;
    self.currentAutoCount = 0;
    self.stopBtn.gameObject:SetActive(false);
    self.startBtn.gameObject:SetActive(true);
    self.FreeContent.gameObject:SetActive(false);
    self.AutoStartBtn.gameObject:SetActive(false);
end
function AJDMXEntry.FreeGame()
    --免费游戏
    self.isFreeGame = true;
    self.startBtn.gameObject:SetActive(false);
    self.stopBtn.gameObject:SetActive(false);
    self.AutoStartBtn.gameObject:SetActive(false);
    self.FreeContent.gameObject:SetActive(true);
    self.FreeContent.transform:Find("Num"):GetComponent("TextMeshProUGUI").text = (self.freeCount-1).."/"..self.maxFreeGameCount--self.ShowText(self.freeCount);
    logYellow("免费游戏")

    AJDMX_Network.StartGame();
end
function AJDMXEntry.ChangeGold(gold)
    self.selfGold.text =ShortNumber(gold);--self.ShowText(gold)   --
end
function AJDMXEntry.Roll()
    --开始转动    
    logYellow("开始转动")
    self.WinDesc.text = "Hope you win the prize";
    if not self.isFreeGame and not AJDMX_Result.isWinCSJL then
        self.myGold = self.myGold - self.CurrentChip * AJDMX_DataConfig.ALLLINECOUNT;
        AJDMXEntry.ChangeGold(self.myGold);
    end
    self.WinNum.text = ShortNumber(0);--self.ShowText("0");

    AJDMX_Result.HideResult();
    AJDMX_Line.Close();
    AJDMX_Roll.StartRoll();
    self.chipBet:DOLocalMove(Vector3.New(0, -120, 0), 0.5);
end
function AJDMXEntry.OnStop()
    --停止转动
    log("停止")
    AJDMX_Audio.StopPlaySound(AJDMX_Audio.SoundList.rollBegin5)
    AJDMX_Result.ShowResult();
end
function AJDMXEntry.InitPanel()
    --场景消息初始化
    self.myGold = TableUserInfo._7wGold;
    AJDMXEntry.ChangeGold(self.myGold);

    self.betRollList = {};
    self.betProgresslist = {};
    for i = 1, #self.SceneData.chipList do
        table.insert(self.betRollList, (-170/(#self.SceneData.chipList - 1)) * (i - 1));
        table.insert(self.betProgresslist, (1 / (#self.SceneData.chipList - 1)) * (i - 1));
    end

    for i = 1, self.SceneData.nBetonCount do
        if self.SceneData.chipList[i] == self.SceneData.bet then
            self.CurrentChipIndex = i;
        end
    end
    if self.SceneData.freeNumber <= 0 then
        self.CurrentChipIndex = CheckNear(TableUserInfo._7wGold,self.SceneData.chipList);
    end
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = ShortNumber(self.CurrentChip * AJDMX_DataConfig.ALLLINECOUNT);
    
    if self.chipprogressTween ~= nil then
        self.chipprogressTween:Kill();
    end
    self.chipprogressTween = self.chipProgress:DOFillAmount(self.betProgresslist[self.CurrentChipIndex], 0.1);
    self.chipPan:DOLocalRotate(Vector3.New(0, 0,self.betRollList[self.CurrentChipIndex]/4), 0.1);
    self.chipPoint:DOLocalRotate(Vector3.New(0, 0,self.betRollList[self.CurrentChipIndex]), 0.1);
    
    self.WinNum.text = ShortNumber(0)--self.ShowText("0");
    AJDMX_Caijin.isCanSend = true;
    self.isRoll = false;
    AJDMX_Line.Init();
    AJDMX_Result.Init();

    --AJDMX_Caijin:SetCAIJIN(AJDMXEntry.SceneData.Jackpot[self.CurrentChipIndex])

    if self.SceneData.cbIsSmallGame>0 then
        AJDMX_SmallGame.Run()
    elseif self.SceneData.freeNumber > 0 then
        --如果免费
        self.freeCount = self.SceneData.freeNumber;
        self.ResultData.FreeCount = self.freeCount;
        self.isFreeGame = true;
        AJDMX_Result.isFreeGame = true;
        AJDMXEntry.SetState(2)
        if self.SceneData.freeNumber >= 10 then
            AJDMX_Result.ShowFreeEffect(true);
        else
            AJDMXEntry.maxFreeGameCount = self.SceneData.freeNumber
            AJDMXEntry.addChipBtn.interactable = false;
            AJDMXEntry.reduceChipBtn.interactable = false;
            AJDMXEntry.MaxChipBtn.interactable = false;
            AJDMX_Result.CheckFree();
        end
    else
        AJDMXEntry.SetState(1)
    end
end
function AJDMXEntry.OpenZP()

end
function AJDMXEntry.CloseZP()

end
function AJDMXEntry.RollZP()
    --转转盘
    self.currentSmallRollIndex = 0;
    self.currentSmallCycleCount = 0;
    self.smallRollTimer = 0;
    self.smallTempRollTimer = AJDMX_DataConfig.smallRollDurationTime;
    self.isLastCycle = false;
    self.StartRollSmallGame();
end

function AJDMXEntry.SetState(state)
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


function AJDMXEntry.ShowFreeGame()
    --显示免费界面
    self.EnterFreeEffect.gameObject:SetActive(true);
    self.showFreeTimer = AJDMX_DataConfig.freeWaitTime;
    self.isshowFree = true;
end
function AJDMXEntry.FreeRoll()
    --判断是否为免费游戏
    AJDMX_Result.isShow = false;
    if AJDMXEntry.ResultData.cbHitBouns > 0 then
        AJDMX_SmallGame.Run()
        return
    end
    if self.isFreeGame then
        --self.freeCount = self.freeCount - 1;
        if self.freeCount <= 0 then
            --免费结束
            if AJDMX_Result.showFreeTweener ~= nil then
                AJDMX_Result.showFreeTweener:Kill();
                AJDMX_Result.showFreeTweener = nil;
            end
            self.FreeContent.gameObject:SetActive(false);
            self.isFreeGame = false;
            AJDMX_Result.isFreeGame = false;
            for i = 1, self.CSGroup.childCount do
                for j = 1, self.CSGroup:GetChild(i - 1).childCount do
                    self.CSGroup:GetChild(i - 1):GetChild(j - 1).gameObject:SetActive(false);
                end
            end
            AJDMX_Audio.PlayBGM();
            AJDMXEntry.SetState(1)
            self.AutoRoll();
        else
            --还有免费次数
            self.FreeGame();
        end
    else
        self.AutoRoll();
    end
end
function AJDMXEntry.AutoRoll()
    --判断是否为自动游戏
    if self.isAutoGame then
        --如果是自动游戏
        if self.currentAutoCount < 1000 then
            self.currentAutoCount = self.currentAutoCount - 1;
        end
        if self.currentAutoCount < 0 then
            --自动次数使用完了，回到待机状态
            self.StopAutoGame();
            AJDMXEntry.startBtn.transform:GetComponent("Image").color = Color.white;
            AJDMXEntry.startBtn:GetComponent("Button").interactable = true;
            AJDMXEntry.addChipBtn.interactable = true;
            AJDMXEntry.reduceChipBtn.interactable = true;
            AJDMXEntry.MaxChipBtn.interactable = true;
        else
            --还有自动次数
            self.OnClickAutoItemCall();
        end
    else
        --不是自动游戏，直接待机
        self.StopAutoGame();
        AJDMXEntry.startBtn.transform:GetComponent("Image").color = Color.white;
        AJDMXEntry.startBtn:GetComponent("Button").interactable = true;
        AJDMXEntry.addChipBtn.interactable = true;
        AJDMXEntry.reduceChipBtn.interactable = true;
        AJDMXEntry.MaxChipBtn.interactable = true;
    end
end