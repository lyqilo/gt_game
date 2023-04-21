-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion
local MCDZZ_SlotModuleNum = "Module46/MCDZZ/";

require(MCDZZ_SlotModuleNum .. "MCDZZ_Network")
require(MCDZZ_SlotModuleNum .. "MCDZZ_Roll")
require(MCDZZ_SlotModuleNum .. "MCDZZ_DataConfig")
require(MCDZZ_SlotModuleNum .. "MCDZZ_Caijin")
require(MCDZZ_SlotModuleNum .. "MCDZZ_Line")
require(MCDZZ_SlotModuleNum .. "MCDZZ_Result")
require(MCDZZ_SlotModuleNum .. "MCDZZ_Rule")
require(MCDZZ_SlotModuleNum .. "MCDZZ_Audio")
--require(MCDZZ_SlotModuleNum .. "MCDZZ_SmallGame")


 MCDZZEntry = {};
 local self = MCDZZEntry;
 self.transform = nil;
 self.gameObject = nil;

self.CurrentChip = 0;
self.CurrentChipIndex = 0;
self.isAutoGame = false;
self.isFreeGame = false;
self.isSmallGame = false;

self.isRoll = false;
self.menuTweener = nil;

self.currentFreeCount = 0;
self.clickStartTimer = -1;

self.currentAutoCount = 0;--剩余自动次数
self.freeCount = 0;--剩余免费次数

self.myGold = 0;--显示的自身金币
self.betRollList = {};
self.betProgresslist = {};
local selectTimeing=0
local isLongClick=false
self.scatterList = {};
self.isOpenMenu=false

local isClickBet=false
local isClickBetTime=0;

self.SceneData = {
    chipCount=0,
    chipList = {}, --下注列表
    bet = 0, --当前下注
    freeNumber = 0, --免费次数
    --cbBouns = 0, --小游戏轮数
    --nBounsNo = 0,--小游戏底图
    --SmallAllGold = 0--小游戏总金币
    StopIcon={}
};
self.ResultData = {
    ImgTable = {}, --图标
    FreeImgTable = {}, --图标

    LineTypeTable = {}, --连线类型
    WinScore = 0, --赢得总分
    FreeCount = 0, --免费次数
    caiJin = 0, --彩金
    cbChangeLine = 0, --彩金
    isSmallGameCount=0,
}

self.ZJTABLE={
    [1]=0,
    [2]=0,
    [3]=0,
    [4]=0,
    [5]=0,
}

 function MCDZZEntry:Awake(obj)
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
    MCDZZ_Roll.Init(self.RollContent);
    MCDZZ_Audio.Init();
    MCDZZ_Rule.Init()
    MCDZZ_Network.AddMessage();--添加消息监听
    MCDZZ_Network.LoginGame();--开始登录游戏
    GameSetsPanel.CreateHideObj(self.MainContent, false);
    MCDZZ_Audio.PlayBGM();
 end
function MCDZZEntry.OnDestroy()
    MCDZZ_Line.Close();
    MCDZZ_Network.UnMessage();
end
function MCDZZEntry:Update()
    MCDZZ_Roll.Update();
    --MCDZZ_Caijin.Update();
    MCDZZ_Line.Update();
    MCDZZ_Result.Update();
    MCDZZEntry.ChipSlider();

    if self.clickStartTimer >= 0 then
        self.clickStartTimer = self.clickStartTimer + Time.deltaTime;
        if self.clickStartTimer >= 0.5 then
            self.clickStartTimer = -1;
            self.OnClickAutoCall();
        end
    end
end

function MCDZZEntry.ChipSlider()
    if isClickBet then
        isClickBetTime=isClickBetTime+Time.deltaTime
        if isClickBetTime >= 2 then
            isClickBetTime=0
            isClickBet=false
            self.chipBet:DOLocalMove(Vector3.New(0,-100, 0), 0.5);
        end
    end
end

 function MCDZZEntry.FindComponent()
    self.MainContent = self.transform:Find("MainPanel");
    self.normalBackground = self.MainContent:Find("Content/MainBackground").gameObject;
    self.freeBackground = self.MainContent:Find("Content/FreeBackground").gameObject;
    --self.freeShowCount = self.freeBackground.transform:Find("Count"):GetComponent("TextMeshProUGUI");

    self.RollContent = self.MainContent:Find("Content/RollContent");--转动区域

    self.selfGold = self.MainContent:Find("Content/Bottom/MyInfo/Gold/Num"):GetComponent("TextMeshProUGUI");--自身金币
    self.myHeadImg=self.MainContent:Find("Content/Bottom/MyInfo/Head/Image/HeadImg"):GetComponent("Image")--自己头像
    self.myHeadImg.sprite=HallScenPanel.GetHeadIcon()

    self.myNikeName=self.MainContent:Find("Content/Bottom/MyInfo/nameText"):GetComponent("Text");--昵称
    self.myNikeName.text=SCPlayerInfo._05wNickName

    self.ChipNum = self.MainContent:Find("Content/Bottom/Chip/Num"):GetComponent("TextMeshProUGUI");--下注金额
    self.WinNum = self.MainContent:Find("Content/Bottom/Win/Num"):GetComponent("TextMeshProUGUI");--本次获得金币
    self.TipText=self.MainContent:Find("Content/Bottom/Win/TipText"):GetComponent("Text");--本次中将提示
    self.showRuleBtn = self.MainContent:Find("Content/RuleBtn"):GetComponent("Button");--规则
    self.normalBot = self.MainContent:Find("Content/Bottom/MainBottom").gameObject;
    self.freeBot = self.MainContent:Find("Content/Bottom/FreeBottom").gameObject;
    self.reduceChipBtn = self.MainContent:Find("Content/Bottom/Chip/Reduce"):GetComponent("Button");--减注
    self.addChipBtn = self.MainContent:Find("Content/Bottom/Chip/Add"):GetComponent("Button");--加注

    self.BigBtn=self.MainContent:Find("Content/Bottom/Chip/BigBtbn"):GetComponent("Button");--最大
    self.chipProgress = self.MainContent:Find("Content/Bottom/Chip/Mask/Bet/Progress"):GetComponent("Image");
    self.chipPoint = self.MainContent:Find("Content/Bottom/Chip/Mask/Bet/Point");
    self.chipPan = self.MainContent:Find("Content/Bottom/Chip/Mask/Bet/Pan");
    self.chipBet = self.MainContent:Find("Content/Bottom/Chip/Mask/Bet");

    self.btnGroup = self.MainContent:Find("Content/ButtonGroup");
    self.startBtn = self.btnGroup:Find("StartBtn"):GetComponent("Button");--开始按钮
    self.startBtn.transform:Find("On").gameObject:SetActive(true);
    self.startBtn.transform:Find("Off").gameObject:SetActive(false);
    local eventTrigger = Util.AddComponent("EventTriggerListener", self.startBtn.gameObject);
    eventTrigger.onDown = self.OnDownStartBtnClick
    eventTrigger.onUp = self.OnUpStartBtnClick

    self.settingPanel=self.MainContent:Find("Content/Setting");
    self.musicSet = self.settingPanel:Find("Body/Music"):GetComponent("Slider");
    self.soundSet = self.settingPanel:Find("Body/Sound"):GetComponent("Slider");
    self.closeSet = self.settingPanel:Find("Body/Close"):GetComponent("Button");
    self.settingPanel.gameObject:SetActive(false)

    self.selectPanel=self.btnGroup:Find("SelectBtn")
    self.selectPanel.gameObject:SetActive(false)
    self.selectBtn_Close=self.selectPanel:Find("Image"):GetComponent("Button")

    self.freePanel=self.btnGroup.transform:Find("Free")
    self.freeText = self.btnGroup.transform:Find("Free/FreeCount"):GetComponent("TextMeshProUGUI");--免费次数

    self.AutoStartBtn = self.btnGroup:Find("AutoStart"):GetComponent("Button");--打开自动开始界面
    self.AutoStartBtn.transform:Find("On").gameObject:SetActive(true);
    --self.AutoStartBtn.transform:Find("Text").gameObject:SetActive(false);
    self.AutoStartBtn.gameObject:SetActive(false)
    self.AutoStartBtn.transform:Find("WX").gameObject:SetActive(false)

   --规则
    self.rulePanel = self.MainContent:Find("Content/Rule");--规则界面
    self.rulePanel.gameObject:SetActive(false)

    self.ruleChildPanel = self.rulePanel:Find("Content/RuleImage")--规则子界面

    self.closeRuleBtn = self.rulePanel:Find("Content/BackBtn"):GetComponent("Button");
    self.ruleUpBtn = self.rulePanel:Find("Content/UpBtn"):GetComponent("Button"); --上一页
    self.ruleDownBtn = self.rulePanel:Find("Content/DownBtn"):GetComponent("Button");--下一页
    self.ruleChild1Image=self.ruleChildPanel:GetChild(0)
    self.ruleChild2Image=self.ruleChildPanel:GetChild(1)
    self.ruleChild3Image=self.ruleChildPanel:GetChild(2)
   --
    self.WinGold=self.MainContent:Find("Content/WinGold") --界面显示金币
    self.WinGoldText=self.WinGold:Find("Text"):GetComponent("TextMeshProUGUI")
    self.WinGold.gameObject:SetActive(false)

    self.icons = self.MainContent:Find("Content/Icons");--图标库

   -- self.icons:Find("SCATTER"):GetComponent("Animator").enabled=false

    self.effectList = self.MainContent:Find("Content/EffectList");--动画库
    self.effectPool = self.MainContent:Find("Content/EffectPool");--动画缓存库
    self.CSGroup = self.MainContent:Find("Content/CSContent");--显示财神
    self.soundList = self.MainContent:Find("Content/SoundList");--声音库
    self.LineGroup = self.MainContent:Find("Content/LineGroup");--连线

   --特效
   self.resultEffect = self.MainContent:Find("Content/Result");--中奖后特效

   self.winNormalEffect = self.resultEffect:Find("Reward");
   self.winNormalNum = self.winNormalEffect:Find("Image/RewardNum"):GetComponent("TextMeshProUGUI");
   self.winLZPos=self.resultEffect:Find("pos")
   self.winLZPos_SHT_shoujinbi=self.winLZPos:Find("SHT_shoujinbi")
   self.winclie=self.winNormalEffect:Find("jb")

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
   self.bigProgress = self.bigEffect:Find("Content/Slider"):GetComponent("Slider");
   self.bigDJJY = self.bigEffect:Find("Content/DJJY").gameObject;
   self.bigFJYF = self.bigEffect:Find("Content/FJYF").gameObject;
   self.bigTXWS = self.bigEffect:Find("Content/TXWS").gameObject;

   self.bigRJDJ = self.bigEffect:Find("Content/RJDJ").gameObject;
   self.bigYCWG = self.bigEffect:Find("Content/YCWG").gameObject;

   self.bigImages = self.bigEffect:Find("Images").gameObject;

   self.BangEffect = self.resultEffect:Find("Bang");
   self.winBangNum = self.BangEffect:Find("Content/Num"):GetComponent("TextMeshProUGUI");
   self.closeBangBtn = self.BangEffect:Find("Close"):GetComponent("Button");
   self.BangProgress = self.BangEffect:Find("Content/Slider"):GetComponent("Slider");
   self.BangDJJY = self.BangEffect:Find("Content/DJJY").gameObject;
   self.BangFJYF = self.BangEffect:Find("Content/FJYF").gameObject;
   self.BangTXWS = self.BangEffect:Find("Content/TXWS").gameObject;
   self.BangImages=self.BangEffect:Find("Images")

   self.smallEffect = self.resultEffect:Find("SmallReward");
   self.winSmallEffectNum = self.smallEffect:Find("Num"):GetComponent("TextMeshProUGUI");
   self.freeOverTime = self.smallEffect:Find("FreeWin_CountDown"):GetComponent("TextMeshProUGUI");
   self.free2OverBtn = self.smallEffect:Find("FreeWin_Continue"):GetComponent("Button");
  --
  self.EnterFreeEffect = self.MainContent:Find("Content/FreeEnterPanel");
  self.EnterFreeEffect.gameObject:SetActive(false);
  self.freedownTime = self.EnterFreeEffect:Find("FreeEnter_CountDown"):GetComponent("TextMeshProUGUI");
  self.FreeCountText = self.EnterFreeEffect:Find("FreeEnter_FreeCount"):GetComponent("TextMeshProUGUI");
  self.freeOverBtn = self.EnterFreeEffect:Find("FreeEnter_Continue"):GetComponent("Button");

    self.menuBtn = self.MainContent:Find("Content/Menu"):GetComponent("Button");--菜单按钮
    self.menulist = self.MainContent:Find("Content/MenuList");--菜单按钮详情
    self.backgroundBtn = self.MainContent:Find("Content/CloseMenu"):GetComponent("Button");
    self.closeGame = self.menulist:Find("Content/Back"):GetComponent("Button");
    self.settingBtn = self.menulist:Find("Content/Setting"):GetComponent("Button");
    self.closeGame.transform:SetAsLastSibling();
    self.menulist:Find("Content").transform.localPosition=Vector3.New(18,500,0)
    self.backgroundBtn.gameObject:SetActive(false);

    self.exitPanel=self.MainContent:Find("Content/ExitPanel")
    ---self.exitPanelQX=self.exitPanel:Find("Content/Exit_No"):GetComponent("Button")
    self.exitPanelClose=self.exitPanel:Find("Content/BackBtn"):GetComponent("Button")
    self.exitPanelSure=self.exitPanel:Find("Content/SureBtn"):GetComponent("Button")
    self.exitPanel.gameObject:SetActive(false);

    self.rollLight=self.MainContent:Find("Content/RollLight");--转动区域

    for i=1,self.rollLight.childCount do
        self.rollLight:GetChild(i-1):Find("Light").gameObject:SetActive(false)
    end
    for i=1,self.CSGroup.childCount do
        for j=1,self.CSGroup:GetChild(i-1).childCount do
            self.CSGroup:GetChild(i-1):GetChild(j-1).gameObject:SetActive(false)
        end
    end

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
    --logYellow("soundSet=="..self.soundSet.value)

     self.musicSet.value = MusicManager:GetMusicVolume();
     self.soundSet.value = MusicManager:GetSoundVolume();
 end
function MCDZZEntry.AddListener()
    --添加监听事件
    self.reduceChipBtn.onClick:RemoveAllListeners();
    self.reduceChipBtn.onClick:AddListener(self.ReduceChipCall);

    self.addChipBtn.onClick:RemoveAllListeners();
    self.addChipBtn.onClick:AddListener(self.AddChipCall);

    self.startBtn.onClick:RemoveAllListeners();
    self.startBtn.onClick:AddListener(self.StartGameCall);

    self.BigBtn.onClick:RemoveAllListeners();
    self.BigBtn.onClick:AddListener(self.BigChipCall);

    self.closeGame.onClick:RemoveAllListeners();
    self.closeGame.onClick:AddListener(function()
        self.CloseMenuCall()
        self.exitPanel.gameObject:SetActive(true)
    end);

    -- self.soundBtn.onClick:RemoveAllListeners();
    -- self.soundBtn.onClick:AddListener(self.SetSoundCall);

    self.AutoStartBtn.onClick:RemoveAllListeners();
    self.AutoStartBtn.onClick:AddListener(self.OnClickAutoStartCall);

    self.showRuleBtn.onClick:RemoveAllListeners();--显示规则
    self.showRuleBtn.onClick:AddListener(self.ShowRultPanel);

    self.selectBtn_Close.onClick:RemoveAllListeners();--显示规则
    self.selectBtn_Close.onClick:AddListener(self.CloseSelectPanel);

    self.musicSet.onValueChanged:RemoveAllListeners();
    self.musicSet.onValueChanged:AddListener(self.SetMusicVolumn);
    self.soundSet.onValueChanged:RemoveAllListeners();
    self.soundSet.onValueChanged:AddListener(self.SetSoundVolumn);


    self.settingBtn.onClick:RemoveAllListeners();
    self.settingBtn.onClick:AddListener(self.OpenSettingPanel);

    self.menuBtn.onClick:RemoveAllListeners();
    self.menuBtn.onClick:AddListener(self.ClickMenuCall);

    self.closeSet.onClick:RemoveAllListeners();
    self.closeSet.onClick:AddListener(function()
        self.settingPanel.gameObject:SetActive(false);
    end);

    self.exitPanelClose.onClick:RemoveAllListeners();
    self.exitPanelClose.onClick:AddListener(function()
        --SHT_Audio.PlaySound(SHT_Audio.SoundList.CloseClick);
        self.exitPanel.gameObject:SetActive(false)
    end);

    self.exitPanelSure.onClick:RemoveAllListeners();
    self.exitPanelSure.onClick:AddListener(self.CloseGameCall);

    self.freeOverBtn.onClick:RemoveAllListeners();
    self.freeOverBtn.onClick:AddListener(self.FreeOverBtnCall);

    self.free2OverBtn.onClick:RemoveAllListeners();
    self.free2OverBtn.onClick:AddListener(self.FreeOverBtnCall);

    local go1=self.selectPanel:Find("GameObject"):GetChild(0):GetComponent("Button")
    go1.onClick:RemoveAllListeners();
    go1.onClick:AddListener(self.SelectAutoNum1);

    local go2=self.selectPanel:Find("GameObject"):GetChild(1):GetComponent("Button")
    go2.onClick:RemoveAllListeners();
    go2.onClick:AddListener(self.SelectAutoNum2);

    local go3=self.selectPanel:Find("GameObject"):GetChild(2):GetComponent("Button")
    go3.onClick:RemoveAllListeners();
    go3.onClick:AddListener(self.SelectAutoNum3);

    local go4=self.selectPanel:Find("GameObject"):GetChild(3):GetComponent("Button")
    go4.onClick:RemoveAllListeners();
    go4.onClick:AddListener(self.SelectAutoNum4);
end
function MCDZZEntry.GetGameConfig()
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
        MCDZZ_DataConfig.rollTime = data.rollTime;
        MCDZZ_DataConfig.rollReboundRate = data.rollReboundRate;
        MCDZZ_DataConfig.rollInterval = data.rollInterval;
        MCDZZ_DataConfig.rollSpeed = data.rollSpeed;
        MCDZZ_DataConfig.caijinGoldChangeRate = data.caijinGoldChangeRate;
        MCDZZ_DataConfig.winGoldChangeRate = data.winGoldChangeRate;
        MCDZZ_DataConfig.selfGoldChangeRate = data.selfGoldChangeRate;
        MCDZZ_DataConfig.freeLoadingShowTime = data.freeLoadingShowTime;
        MCDZZ_DataConfig.smallGameLoadingShowTime = data.smallGameLoadingShowTime;
        MCDZZ_DataConfig.rollDistance = data.rollDistance;
        MCDZZ_DataConfig.REQCaiJinTime = data.REQCaiJinTime;
        MCDZZ_DataConfig.lineAllShowTime = data.lineAllShowTime;
        MCDZZ_DataConfig.cyclePlayLineTime = data.cyclePlayLineTime;
        MCDZZ_DataConfig.waitShowLineTime = data.waitShowLineTime;
        MCDZZ_DataConfig.autoRewardInterval = data.autoRewardInterval;
        MCDZZ_DataConfig.autoNoRewardInterval = data.autoNoRewardInterval;
    end);
end
function MCDZZEntry.ToCharArray(num)
    --拆解字符串
    local str = tostring(num);
    local list1 = {}
    for i = 1, string.len(str) do
        table.insert(list1, #list1 + 1, string.sub(str, i, i));
    end
    return list1;
end
function MCDZZEntry.FormatNumberThousands(num)
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
function MCDZZEntry.SetSelfGold(str)
    self.selfGold.text = ShortNumber(str)-- self.ShowText(str);
end
function MCDZZEntry.ChangeGold(str)
    self.selfGold.text = ShortNumber(str)-- self.ShowText(str);
end
function MCDZZEntry.ShowText(str)
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

function MCDZZEntry.CloseSelectPanel()
    self.selectPanel.gameObject:SetActive(false)
end

function MCDZZEntry.OnDownStartBtnClick()
    self.clickStartTimer = 0;

    if not self.isRoll then
        isLongClick=true    
    else
        isLongClick=false
    end
end
function MCDZZEntry.OnUpStartBtnClick()
    if self.clickStartTimer < 0.5 and self.clickStartTimer ~= -1 then
        self.clickStartTimer = -1;
        self.StartGameCall();
    end
end

function MCDZZEntry.SelectAutoNum1()
    self.currentAutoCount=20
    MCDZZEntry.SelectAutoNum()
end
function MCDZZEntry.SelectAutoNum2()
    self.currentAutoCount=50
    MCDZZEntry.SelectAutoNum()
end
function MCDZZEntry.SelectAutoNum3()
    self.currentAutoCount=100
    MCDZZEntry.SelectAutoNum()
end
function MCDZZEntry.SelectAutoNum4()
    self.currentAutoCount=10000
    MCDZZEntry.SelectAutoNum()
end
function MCDZZEntry.SelectAutoNum()
    self.AutoStartBtn.transform:Find("Text").gameObject:SetActive(true)

    local str=""
    if self.currentAutoCount>100 then
        str="无限"
    else
        str=""..self.currentAutoCount
    end
    MCDZZEntry.addChipBtn.interactable = false;
    MCDZZEntry.reduceChipBtn.interactable = false;
    MCDZZEntry.BigBtn.interactable = false;
    self.isAutoGame=true
    self.SetState(3)
    MCDZZEntry.SetAutoNum(str)
    if not self.isRoll then
        MCDZZ_Network.StartGame();
    end
    MCDZZEntry.CloseSelectPanel()
end

function MCDZZEntry.SetAutoNum(num)
    self.AutoStartBtn.transform:Find("Text"):GetComponent("Text").text=""..num
end

function MCDZZEntry.ReduceChipCall()
    --减注
    MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.BTN);
    if self.SceneData.chipList == nil or #self.SceneData.chipList <= 0 then
        return ;
    end
    MCDZZ_Rule.SetBeiShu()

    isClickBet=true
    isClickBetTime=0
    self.chipBet:DOLocalMove(Vector3.New(0, -28, 0), 0.5);

    MCDZZEntry.addChipBtn.interactable = true;
    MCDZZEntry.BigBtn.interactable = true;

    self.CurrentChipIndex = self.CurrentChipIndex - 1;

    if self.CurrentChipIndex <= 0 then
        self.CurrentChipIndex =1;
        MCDZZEntry.reduceChipBtn.interactable = false;
    end

    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = ShortNumber(self.CurrentChip * MCDZZ_DataConfig.ALLLINECOUNT) -- self.ShowText(self.CurrentChip * MCDZZ_DataConfig.ALLLINECOUNT);

    if self.chipprogressTween ~= nil then
        self.chipprogressTween:Kill();
    end
    self.chipprogressTween = self.chipProgress:DOFillAmount(self.betProgresslist[self.CurrentChipIndex], 0.1);
    self.chipPan:DOLocalRotate(Vector3.New(0, 0, self.betRollList[self.CurrentChipIndex]/4), 0.1);
    self.chipPoint:DOLocalRotate(Vector3.New(0, 0,self.betRollList[self.CurrentChipIndex]), 0.1);
end
function MCDZZEntry.AddChipCall()
    --加注
    MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.BTN);
    if self.SceneData.chipList == nil or #self.SceneData.chipList <= 0 then
        return ;
    end
    MCDZZ_Rule.SetBeiShu()
    isClickBet=true
    isClickBetTime=0
    self.chipBet:DOLocalMove(Vector3.New(0, -28, 0), 0.5);

    self.CurrentChipIndex = self.CurrentChipIndex + 1;
    
    MCDZZEntry.reduceChipBtn.interactable = true;
    if self.CurrentChipIndex == #self.SceneData.chipList then
        self.CurrentChipIndex = #self.SceneData.chipList;
        MCDZZEntry.addChipBtn.interactable = false;
        MCDZZEntry.BigBtn.interactable = false;
    end
    if self.CurrentChipIndex > #self.SceneData.chipList then
        self.CurrentChipIndex = #self.SceneData.chipList;
        MCDZZEntry.addChipBtn.interactable = false;
        MCDZZEntry.BigBtn.interactable = false;
        MessageBox.CreatGeneralTipsPanel("已是最大下注");
    end
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = ShortNumber(self.CurrentChip * MCDZZ_DataConfig.ALLLINECOUNT)-- self.ShowText(self.CurrentChip * MCDZZ_DataConfig.ALLLINECOUNT);
    if self.chipprogressTween ~= nil then
        self.chipprogressTween:Kill();
    end
    self.chipprogressTween = self.chipProgress:DOFillAmount(self.betProgresslist[self.CurrentChipIndex], 0.1);
    self.chipPan:DOLocalRotate(Vector3.New(0, 0, self.betRollList[self.CurrentChipIndex]/4), 0.1);
    self.chipPoint:DOLocalRotate(Vector3.New(0, 0,self.betRollList[self.CurrentChipIndex]), 0.1);
end

function MCDZZEntry.BigChipCall()
    if self.SceneData.chipList == nil or #self.SceneData.chipList <= 0 then
        return ;
    end
    MCDZZ_Rule.SetBeiShu()

    isClickBet=true
    isClickBetTime=0
    self.chipBet:DOLocalMove(Vector3.New(0, -28, 0), 0.5);
    MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.BTN);
    MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.moneyAdd,1);
    local upChipNum =self.SceneData.chipList[self.CurrentChipIndex]
    
    self.CurrentChipIndex = #self.SceneData.chipList

    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    if self.chipprogressTween ~= nil then
        self.chipprogressTween:Kill();
    end
    
    self.chipprogressTween = self.chipProgress:DOFillAmount(self.betProgresslist[self.CurrentChipIndex], 0.1);
    self.chipPan:DOLocalRotate(Vector3.New(0, 0, self.betRollList[self.CurrentChipIndex]/4), 0.1);
    self.chipPoint:DOLocalRotate(Vector3.New(0, 0,self.betRollList[self.CurrentChipIndex]), 0.1);
    MCDZZEntry.addChipBtn.interactable = false;
    MCDZZEntry.reduceChipBtn.interactable = true;
    MCDZZEntry.BigBtn.interactable = false;

    self.bigwinTweener = Util.RunWinScore(upChipNum*MCDZZ_DataConfig.ALLLINECOUNT,self.SceneData.chipList[self.CurrentChipIndex]*MCDZZ_DataConfig.ALLLINECOUNT, 0.8, function(value)
        self.ChipNum.text = ShortNumber(math.floor(value)) 
    end);
end


function MCDZZEntry.StartGameCall()
    --开始游戏
    if self.isFreeGame or self.isAutoGame then
        return ;
    end
    self.startBtn.transform:Find("On"):GetComponent("Image").color = Color.gray;
    self.startBtn.interactable = false;

    if self.isRoll then
        --TODO 急停
        MCDZZ_Roll.StopRoll();
        return ;
    end
    if self.myGold < self.CurrentChip * MCDZZ_DataConfig.ALLLINECOUNT then
        MessageBox.CreatGeneralTipsPanel("Not enough gold!")
        MCDZZEntry.startBtn:GetComponent("Button").interactable = true;
        self.startBtn.transform:GetComponent("Image").color = Color.white;
        self.startBtn.transform:Find("On"):GetComponent("Image").color = Color.white;
        return ;
    end
    MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.BTN);
    self.startBtn.transform:Find("On").gameObject:SetActive(false);
    self.startBtn.transform:Find("Off").gameObject:SetActive(true);
    --TODO 发送开始消息,等待结果开始转动
    MCDZZ_Network.StartGame();
end

function MCDZZEntry.SetMusicVolumn(value)
    
    MusicManager:SetValue(MusicManager:GetSoundVolume(),value);
    MCDZZ_Audio.pool.volume = value;
    MusicManager:SetMusicMute(value <= 0);
    MCDZZ_Audio.pool.mute = not MusicManager:GetIsPlayMV();
end
function MCDZZEntry.SetSoundVolumn(value)

    MusicManager:SetValue(value,MusicManager:GetMusicVolume());
    MusicManager:SetSoundMute(value <= 0);
end

function MCDZZEntry.OpenSettingPanel()
    MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.BTN1);

    --self.CloseMenuCall();
    self.settingPanel.gameObject:SetActive(true);
end

function MCDZZEntry.ClickMenuCall()
    --点击显示菜单
    if self.isOpenMenu==true then
        MCDZZEntry.CloseMenuCall()
        return
    end
    self.isOpenMenu=true
    self.menuBtn.transform:GetChild(0).gameObject:SetActive(true);
    MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.BTN1);
    if self.menuTweener ~= nil then
        self.menuTweener:Kill();
    end

    self.backgroundBtn.gameObject:SetActive(true);
    self.backgroundBtn.interactable = false;
    --self.menulist.localScale = Vector3.New(1, 1, 1);

    self.menuTweener = self.menulist:Find("Content"):DOLocalMove(Vector3.New(0, -35, 0), 0.5):OnComplete(function()
        self.backgroundBtn.interactable = true;
        if self.menuTweener ~= nil then
            self.menuTweener = nil;
        end
    end);
    if self.menuTweener ~= nil then
        self.menuTweener:SetAutoKill();
    end
end

function MCDZZEntry.CloseMenuCall()
    --关闭菜单
    self.isOpenMenu=false
    self.menuBtn.transform:GetChild(0).gameObject:SetActive(false);
    MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.BTN1);
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
function MCDZZEntry.CloseGameCall()
    MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.BTN1);
    if not self.isFreeGame and not self.isSmallGame then
        Event.Brocast(MH.Game_LEAVE);
    else
        MessageBox.CreatGeneralTipsPanel("Cannot leave the game in special mode");
    end
end
function MCDZZEntry.SetSoundCall()
    self.settingPanel.gameObject:SetActive(true);
end

function MCDZZEntry.OnClickAutoCall()
    --点击自动开始
    MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.BTN);
    if self.isAutoGame then
        self.StopAutoGame();
        return ;
    end
    self.selectPanel.gameObject:SetActive(true)
end
function MCDZZEntry.OnClickAutoStartCall()
    --点击选择自动次数

    if self.isAutoGame then
        self.StopAutoGame();
        return ;
    end
    --self.SetState(3);
    self.AutoStartCall();
end
function MCDZZEntry.AutoStartCall()
    self.SetState(3);
    if not self.isFreeGame then
        if self.myGold < self.CurrentChip * MCDZZ_DataConfig.ALLLINECOUNT then
            MessageBox.CreatGeneralTipsPanel("Not enough gold!")
            return ;
        end
    end
    MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.BTN);
    self.isAutoGame = true;
    self.AutoStartBtn.transform:Find("On").gameObject:SetActive(true);
    self.AutoStartBtn.transform:Find("Text").gameObject:SetActive(true);
    MCDZZEntry.addChipBtn.interactable = false;
    MCDZZEntry.reduceChipBtn.interactable = false;
    MCDZZEntry.BigBtn.interactable = false;
    self.startBtn.interactable = false;
    local str=""
    if self.currentAutoCount>100 then
        str="无限"
    else
        str=""..self.currentAutoCount
    end
    MCDZZEntry.SetAutoNum(str)

    if not self.isRoll and not self.isFreeGame or not self.isSmallGame then
        --没有转动的状态开始自动旋转
        MCDZZ_Network.StartGame();
    end
end

function MCDZZEntry.ShowRultPanel()
    --显示规则
    logYellow("显示规则")
    --MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.BTN);
    MCDZZ_Rule.ShowRule();
end
function MCDZZEntry.SetMaxChipCall()
    --设置最大下注
    MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.BTN);
    self.chipBet:DOLocalMove(Vector3.New(0, -28, 0), 0.5);
    self.CurrentChipIndex = #self.SceneData.chipList;
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = ShortNumber(self.CurrentChip)-- self.ShowText(self.CurrentChip);
end

function MCDZZEntry.CSJLRoll()
    MCDZZ_Network.StartGame();
end
function MCDZZEntry.StopAutoGame()
    --停止自动旋转
    self.isAutoGame = false;
    self.currentAutoCount = 0;
    self.AutoStartBtn.transform:Find("On").gameObject:SetActive(true);
    MCDZZEntry.SetAutoNum(self.currentAutoCount)
    MCDZZEntry.addChipBtn.interactable = true;
    MCDZZEntry.reduceChipBtn.interactable = true;
    MCDZZEntry.BigBtn.interactable = true;
    self.startBtn.interactable = true;
    self.SetState(1)
end
function MCDZZEntry.FreeGame()
    --免费游戏
    self.isFreeGame = true;
    self.freeText.text =ShowRichText(self.freeCount-1);
    self.SetState(2)

    MCDZZ_Network.StartGame();
end
function MCDZZEntry.Roll()
    --开始转动    
    logYellow("==============开始转动====================")
    if not self.isFreeGame and not MCDZZ_Result.isWinCSJL or self.isSmallGame then
        self.myGold = self.myGold - self.CurrentChip * MCDZZ_DataConfig.ALLLINECOUNT;
        MCDZZEntry.ChangeGold(self.myGold);
    end

    if (MCDZZEntry.freeCount > 0 and MCDZZEntry.freeCount~=10  ) or self.isFreeGame or MCDZZ_Result.freeGold > 0 then
        MCDZZEntry.CSGroup.gameObject:SetActive(true)
    else
        MCDZZEntry.CSGroup.gameObject:SetActive(false)
        for i=1,MCDZZEntry.CSGroup.childCount do
            for j=1,MCDZZEntry.CSGroup:GetChild(i-1).childCount do
                MCDZZEntry.CSGroup:GetChild(i-1):GetChild(j-1).gameObject:SetActive(false)
            end
        end
    end

    MCDZZEntry.CSGroup:GetComponent("Image").enabled=true
    self.WinNum.text = self.ShowText(0);
    self.WinGoldText.text=self.ShowText(0)
    self.WinGold.gameObject:SetActive(false)
    self.TipText.text=""
    MCDZZ_Result.HideResult();
    MCDZZ_Line.Close();
    MCDZZ_Roll.StartRoll();
end
function MCDZZEntry.OnStop()
    --停止转动
    log("=====================停止=====================")
    self.startBtn.transform:Find("On").gameObject:SetActive(true);
    self.startBtn.transform:Find("Off").gameObject:SetActive(false);

    for i=1,MCDZZEntry.CSGroup.childCount do
        for j=1,MCDZZEntry.CSGroup:GetChild(i-1).childCount do
            MCDZZEntry.CSGroup:GetChild(i-1):GetChild(j-1).gameObject:SetActive(false)
        end
    end

    if (MCDZZEntry.freeCount > 0 and MCDZZEntry.freeCount~=10  ) or self.isFreeGame or MCDZZ_Result.freeGold > 0 then
        MCDZZEntry.CSGroup.gameObject:SetActive(true)
        for i=0,#MCDZZEntry.ResultData.FreeImgTable-1 do
            local elem = i;
            local column = math.floor(elem / 5);
            local raw = math.floor(elem % 5);
            if MCDZZEntry.ResultData.FreeImgTable[i+1]==1 then
                MCDZZEntry.CSGroup:GetChild(raw):GetChild(column).gameObject:SetActive(true)
            else
                MCDZZEntry.CSGroup:GetChild(raw):GetChild(column).gameObject:SetActive(false)
            end
        end
    else
        for i=1,MCDZZEntry.CSGroup.childCount do
            for j=1,MCDZZEntry.CSGroup:GetChild(i-1).childCount do
                MCDZZEntry.CSGroup:GetChild(i-1):GetChild(j-1).gameObject:SetActive(false)
            end
        end
    end

    MCDZZ_Result.ShowResult();
end
function MCDZZEntry.OnStop1()
    --停止转动
    log("停止")
    self.startBtn.transform:Find("On").gameObject:SetActive(true);
    self.startBtn.transform:Find("Off").gameObject:SetActive(false);
end

function MCDZZEntry.FreeOverBtnCall()
    MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.BTN1);
    if MCDZZ_Result.hideFreeTime>4.75 then
        MCDZZ_Result.hideFreeTime=0
    end
end

function MCDZZEntry.InitPanel()
    --场景消息初始化
    logYellow("场景消息初始化")
    self.myGold = TableUserInfo._7wGold;
    MCDZZEntry.ChangeGold(self.myGold);

    self.betProgresslist = {};
    for i = 1, #self.SceneData.chipList do
        table.insert(self.betRollList, (-100/(#self.SceneData.chipList - 1)) * (i - 1));
        table.insert(self.betProgresslist, 0.18 + (0.64 / (#self.SceneData.chipList - 1)) * (i - 1));
    end
    for i = 1, #self.SceneData.chipList do
        if self.SceneData.chipList[i] == self.SceneData.bet then
            self.CurrentChipIndex = i;-- self.ShowText(self.CurrentChip * MCDZZ_DataConfig.ALLLINECOUNT);
            if i==1 then
                MCDZZEntry.addChipBtn.interactable = true;
                MCDZZEntry.reduceChipBtn.interactable = false;
                MCDZZEntry.BigBtn.interactable = true;
            elseif i==#self.SceneData.chipList then
                MCDZZEntry.addChipBtn.interactable = false;
                MCDZZEntry.reduceChipBtn.interactable = true;
                MCDZZEntry.BigBtn.interactable = false;
            else
                MCDZZEntry.addChipBtn.interactable = true;
                MCDZZEntry.reduceChipBtn.interactable = true;
                MCDZZEntry.BigBtn.interactable = true;
            end
        end

    end

    if self.SceneData.freeNumber <= 0 then
        self.CurrentChipIndex = CheckNear(self.myGold,self.SceneData.chipList)
    end
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = ShortNumber(self.CurrentChip * MCDZZ_DataConfig.ALLLINECOUNT)
    if self.chipprogressTween ~= nil then
        self.chipprogressTween:Kill();
    end
    self.chipprogressTween = self.chipProgress:DOFillAmount(self.betProgresslist[self.CurrentChipIndex], 0.1);
    self.chipPan:DOLocalRotate(Vector3.New(0, 0,self.betRollList[self.CurrentChipIndex]/4), 0.1);
    self.chipPoint:DOLocalRotate(Vector3.New(0, 0,self.betRollList[self.CurrentChipIndex]), 0.1);



    self.WinNum.text = self.ShowText(0);
    self.WinGoldText.text=self.ShowText(0)
    self.WinGold.gameObject:SetActive(false)
    self.TipText.text=""
    --MCDZZ_Caijin.isCanSend = true;
    self.isRoll = false;
    MCDZZ_Line.Init();
    MCDZZ_Result.Init();

    if self.SceneData.freeNumber > 0 then
        --如果免费
        self.freeCount = self.SceneData.freeNumber;
        self.isFreeGame = true;
        self.SetState(2);
        if self.SceneData.freeNumbe==10 then
            MCDZZ_Result.ShowFreeEffect(true);
        else
            MCDZZEntry.FreeRoll()
        end
    else
        self.SetState(1);
    end
end
function MCDZZEntry.SetState(state)
    if state == 1 then
        --正常模式 or 自动模式
        self.normalBackground:SetActive(true);
        self.freeBackground:SetActive(false);
        self.normalBot:SetActive(true);
        --self.freeBot:SetActive(true);
        self.startBtn.gameObject:SetActive(true);
        self.AutoStartBtn.gameObject:SetActive(false);
        self.freeText.gameObject:SetActive(false);
        self.freePanel.gameObject:SetActive(false)
    elseif state == 2 then
        --免费模式
        self.normalBackground:SetActive(false);
        self.freeBackground:SetActive(true);
        self.normalBot:SetActive(true);
        --self.freeBot:SetActive(true);
        self.startBtn.gameObject:SetActive(false);
        self.AutoStartBtn.gameObject:SetActive(false);
        self.freeText.gameObject:SetActive(true);
        self.freePanel.gameObject:SetActive(true)

    elseif state == 3 then
        --zidong
        self.normalBackground:SetActive(true);
        self.freeBackground:SetActive(false);
        self.normalBot:SetActive(true);
        --self.freeBot:SetActive(true);
        self.startBtn.gameObject:SetActive(false);
        self.AutoStartBtn.gameObject:SetActive(true);
        self.freeText.gameObject:SetActive(false);
        self.freePanel.gameObject:SetActive(false)
    -- elseif state==4 then
    --     MCDZZ_SmallGame.Run()
    end
end
function MCDZZEntry.FreeRoll()
    --判断是否为免费游戏
    MCDZZ_Result.isShow = false;
    logYellow("isFreeGame=="..tostring(self.isFreeGame))
    if self.isFreeGame then
        logYellow("freeCount3=="..self.freeCount)
        if self.freeCount <= 0 then
            --免费结束
            if MCDZZ_Result.showFreeTweener ~= nil then
                MCDZZ_Result.showFreeTweener:Kill();
                MCDZZ_Result.showFreeTweener = nil;
            end
            self.isFreeGame = false;
            MCDZZEntry.ResultData.FreeCount=0
            MCDZZ_Audio.PlayBGM();
            self.AutoRoll();
        else
            logYellow("freeCount=="..self.freeCount)
            --还有免费次数
            self.FreeGame();
        end
    else
        self.AutoRoll();
    end
end
function MCDZZEntry.AutoRoll()
    --判断是否为自动游戏
    if self.isAutoGame then
        --如果是自动游戏
        if self.currentAutoCount < 1000 then
            self.currentAutoCount = self.currentAutoCount - 1;
        end
        if self.currentAutoCount < 0 then
            --自动次数使用完了，回到待机状态
            MCDZZEntry.startBtn:GetComponent("Button").interactable = true;
            self.startBtn.transform:GetComponent("Image").color = Color.white;
            self.startBtn.transform:Find("On"):GetComponent("Image").color = Color.white;

            self.StopAutoGame();
        else
            --还有自动次数
            self.AutoStartCall();
        end
    else
        --不是自动游戏，直接待机
        self.StopAutoGame();

        MCDZZEntry.startBtn:GetComponent("Button").interactable = true;
        self.startBtn.transform:GetComponent("Image").color = Color.white;
        self.startBtn.transform:Find("On"):GetComponent("Image").color = Color.white;

        MCDZZEntry.addChipBtn.interactable = true;
        MCDZZEntry.reduceChipBtn.interactable = true;
        MCDZZEntry.BigBtn.interactable = true;
    end
end