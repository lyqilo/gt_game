-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion
local XYSGJ_SlotModuleNum = "Module47/XYSGJ/";

require(XYSGJ_SlotModuleNum .. "XYSGJ_Network")
require(XYSGJ_SlotModuleNum .. "XYSGJ_Roll")
require(XYSGJ_SlotModuleNum .. "XYSGJ_DataConfig")
require(XYSGJ_SlotModuleNum .. "XYSGJ_Caijin")
require(XYSGJ_SlotModuleNum .. "XYSGJ_Line")
require(XYSGJ_SlotModuleNum .. "XYSGJ_Result")
require(XYSGJ_SlotModuleNum .. "XYSGJ_Rule")
require(XYSGJ_SlotModuleNum .. "XYSGJ_Audio")
require(XYSGJ_SlotModuleNum .. "XYSGJ_SmallGame")

XYSGJEntry = {};
local self = XYSGJEntry;
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

self.currentAutoCount = 0;--剩余自动次数
self.freeCount = 0;--剩余免费次数

self.myGold = 0;--显示的自身金币
self.ispress = false;
local selectTimeing = 0
local isLongClick = false
self.clickStartTimer = -1;
self.zpPostable={}

self.SceneData = {
    chipList = {}, --下注列表
    bet = 0, --当前下注
    freeNumber = 0, --免费次数
    cbBouns = 0, --小游戏轮数
    nBounsNo = 0, --小游戏底图
    SmallAllGold = 0, --小游戏总金币
    FreeCount = 0, --免费次数
};

self.SmallGameData = {
    nGameType = 0, --奖励类型 1倍数 2.免费
    nGameCount = 0, --第二旋转的次数
    nGameinfo = {}, --有值就累计起来
    nFreeTimes = 0, --免费次数
    nOdd = 0, --筹码奖励 总倍数
}

self.ResultData = {
    ImgTable = {}, --图标
    LineTypeTable = {}, --连线类型
    WinScore = 0, --赢得总分
    FreeCount = 0, --免费次数
    caiJin = 0, --彩金
    cbChangeLine = 0, --彩金
    isSmallGame = 0,
}
function XYSGJEntry:Awake(obj)
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
    XYSGJ_Roll.Init(self.RollContent);
    XYSGJ_Audio.Init();
    XYSGJ_Network.AddMessage();--添加消息监听
    XYSGJ_Network.LoginGame();--开始登录游戏
    GameSetsPanel.CreateHideObj(self.MainContent, false);
    XYSGJ_Audio.PlayBGM();
end
function XYSGJEntry.OnDestroy()
    XYSGJ_Line.Close();
    XYSGJ_Network.UnMessage();
end
function XYSGJEntry:Update()
    XYSGJEntry.CanShowAuto()
    XYSGJ_Roll.Update();
    XYSGJ_Caijin.Update();
    XYSGJ_Line.Update();
    XYSGJ_Result.Update();
end

function XYSGJEntry.CanShowAuto()
    if self.clickStartTimer >= 0 and not self.isAutoGame then
        self.clickStartTimer = self.clickStartTimer + Time.deltaTime;
        if self.clickStartTimer >= 0.5 and not self.isPlayAudio and self.clickStartTimer < 2 then
            self.isPlayAudio = true;
            self.startBtn.transform:Find("anniu").gameObject:SetActive(true)
            XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.yx_longClick);
        end
        if self.clickStartTimer >= 2.5 then
            self.clickStartTimer = -1;
            self.isPlayAudio = false;
            self.OnClickAutoCall();
        end
    end
end

function XYSGJEntry.FindComponent()
    self.MainContent = self.transform:Find("MainPanel");

    self.normalBackground = self.MainContent:Find("Content/MainBackground").gameObject;
    --self.freeBackground = self.MainContent:Find("Content/FreeBackground").gameObject;
    --self.freeShowCount = self.freeBackground.transform:Find("Count"):GetComponent("TextMeshProUGUI");

    self.RollContent = self.MainContent:Find("Content/RollContent");--转动区域

    self.selfGold = self.MainContent:Find("Content/Bottom/MyInfo/Gold/Num"):GetComponent("TextMeshProUGUI");--自身金币

    self.myHeadImg = self.MainContent:Find("Content/Bottom/MyInfo/Head/Image/HeadImg"):GetComponent("Image")--自己头像
    self.myHeadImg.sprite = HallScenPanel.GetHeadIcon()

    self.myNikeName = self.MainContent:Find("Content/Bottom/MyInfo/nameText"):GetComponent("Text");--昵称
    self.myNikeName.text = SCPlayerInfo._05wNickName

    self.ChipNum = self.MainContent:Find("Content/Bottom/Chip/Num"):GetComponent("TextMeshProUGUI");--下注金额
    self.WinNum = self.MainContent:Find("Content/Bottom/Win/Num"):GetComponent("TextMeshProUGUI");--本次获得金币
    self.TipText = self.MainContent:Find("Content/Bottom/Win/TipText"):GetComponent("TextMeshProUGUI");--本次中将提示
    self.showRuleBtn = self.MainContent:Find("Content/RuleBtn"):GetComponent("Button");--规则

    self.btnGroup = self.MainContent:Find("Content/ButtonGroup");
    self.startBtn = self.btnGroup:Find("StartBtn"):GetComponent("Button");--开始按钮
    self.startBtn.transform:Find("On").gameObject:SetActive(true);
    self.startBtn.transform:Find("Off").gameObject:SetActive(false);

    self.selectPanel = self.btnGroup:Find("SelectBtn")
    self.selectPanel.gameObject:SetActive(false)
    self.selectBtn_Close = self.selectPanel:Find("Image"):GetComponent("Button")

    self.freePanel = self.btnGroup.transform:Find("Free")
    self.freeText = self.btnGroup.transform:Find("Free/FreeCount"):GetComponent("TextMeshProUGUI");--免费次数
    self.freePanel.gameObject:SetActive(false)

    self.AutoStartBtn = self.btnGroup:Find("AutoStart"):GetComponent("Button");--打开自动开始界面
    self.AutoStartBtn.transform:Find("On").gameObject:SetActive(true);
    --self.AutoStartBtn.transform:Find("Text").gameObject:SetActive(false);
    self.AutoStartBtn.gameObject:SetActive(false)
    --规则
    self.rulePanel = self.MainContent:Find("Content/Rule");--规则界面
    self.rulePanel.gameObject:SetActive(false)
    self.ruleChildPanel = self.rulePanel:Find("Content/RuleImage")--规则子界面
    self.closeRuleBtn = self.rulePanel:Find("Content/BackBtn"):GetComponent("Button");
    self.ruleUpBtn = self.rulePanel:Find("Content/UpBtn"):GetComponent("Button"); --上一页
    self.ruleDownBtn = self.rulePanel:Find("Content/DownBtn"):GetComponent("Button");--下一页
    self.ruleChild1Image = self.ruleChildPanel:GetChild(0)
    self.ruleChild2Image = self.ruleChildPanel:GetChild(1)
    self.ruleChild3Image = self.ruleChildPanel:GetChild(2)
    --
    self.closeGame = self.MainContent:Find("Content/BackBtn"):GetComponent("Button");
    self.soundBtn = self.MainContent:Find("Content/SoundBtn"):GetComponent("Button");
    self.soundOn = self.soundBtn.transform:Find("On").gameObject;
    self.soundOff = self.soundBtn.transform:Find("Off").gameObject;

    self.WinGold = self.MainContent:Find("Content/WinGold") --界面显示金币
    self.WinGoldText = self.WinGold:Find("Text"):GetComponent("TextMeshProUGUI")
    self.WinGold.gameObject:SetActive(false)

    self.soundOn:SetActive(AllSetGameInfo._5IsPlayAudio);
    self.soundOff:SetActive(not AllSetGameInfo._5IsPlayAudio);

    self.resultEffect = self.MainContent:Find("Content/Result");--中奖后特效

    self.winEffect = self.resultEffect:Find("Win");
    self.winEffectNum = self.winEffect:Find("Num"):GetComponent("TextMeshProUGUI");

    self.bigWinEffect = self.resultEffect:Find("BigWin");
    self.bigWinNum = self.bigWinEffect:Find("Num"):GetComponent("TextMeshProUGUI");
    self.bigWinClose=self.bigWinEffect:Find("CloseBtn"):GetComponent("Button")

    self.megaWinEffect = self.resultEffect:Find("MegaWin");
    self.megaWinNum = self.megaWinEffect:Find("win/Num"):GetComponent("TextMeshProUGUI");

    self.superWinEffect = self.resultEffect:Find("SuperWin");
    self.superWinNum = self.superWinEffect:Find("win/Num"):GetComponent("TextMeshProUGUI");

    self.ultraWinEffect = self.resultEffect:Find("UltraWin");
    self.ultraWintag = self.ultraWinEffect:Find("Tag");
    self.ultraWinNum = self.ultraWinEffect:Find("Num"):GetComponent("TextMeshProUGUI");
    self.ultraWinClose=self.ultraWinEffect:Find("CloseBtn"):GetComponent("Button")


    self.FreeResultEffect = self.resultEffect:Find("FreeResult");
    self.FreeResult_gxhd = self.FreeResultEffect:Find("ParticleSystem/gxhd")
    self.FreeResult_mfhd = self.FreeResultEffect:Find("ParticleSystem/mianfei")
    self.FreeResultNum = self.FreeResultEffect:Find("Num"):GetComponent("TextMeshProUGUI");

    self.SmallResultEffect = self.resultEffect:Find("SmallResult");
    -- self.FreeResult_gxhd = self.SmallResultEffect:Find("ParticleSystem/gxhd")
    -- self.FreeResult_mfhd = self.SmallResultEffect:Find("ParticleSystem/mianfei")
    self.SmallResultNum = self.SmallResultEffect:Find("Num"):GetComponent("TextMeshProUGUI");


    self.icons = self.MainContent:Find("Content/Icons");--图标库
    self.effectList = self.MainContent:Find("Content/EffectList");--动画库
    self.effectPool = self.MainContent:Find("Content/EffectPool");--动画缓存库
    self.CSGroup = self.MainContent:Find("Content/CSContent");--显示财神
    self.soundList = self.MainContent:Find("Content/SoundList");--声音库
    self.LineGroup = self.MainContent:Find("Content/LineGroup");--连线


    self.caiJinPanel = self.MainContent:Find("Content/MainBackground/Image/BG6")

    self.caiJinPanel_1 = self.caiJinPanel:Find("PText_2"):GetComponent("TextMeshProUGUI")
    self.caiJinPanel_2 = self.caiJinPanel:Find("PText_3"):GetComponent("TextMeshProUGUI")
    self.caiJinPanel_3 = self.caiJinPanel:Find("PText_4"):GetComponent("TextMeshProUGUI")
    self.caiJinPanel_4 = self.caiJinPanel:Find("PText_5"):GetComponent("TextMeshProUGUI")

    self.caiJinPanel.gameObject:SetActive(false)

    self.tipPanel = self.MainContent:Find("Content/TipPanel")
    self.tipJBBZ = self.tipPanel:Find("Tips1")
    self.tipJBBZ.gameObject:SetActive(false)

    self.tipSmallGame = self.tipPanel:Find("Tips2")
    self.tipSmallGame.gameObject:SetActive(false)

    self.EnterFreeEffect = self.tipPanel:Find("Tips3")
    self.EnterFreeCount = self.EnterFreeEffect:Find("Tips3Text"):GetComponent("TextMeshProUGUI");
    self.EnterFreeEffect.gameObject:SetActive(false)

    self.exitPanel = self.MainContent:Find("Content/ExitPanel")
    self.exitPanelQX = self.exitPanel:Find("ExitQuXiaoButton"):GetComponent("Button")
    self.exitPanelClose = self.exitPanel:Find("ExitCloseButton"):GetComponent("Button")
    self.exitPanelSure = self.exitPanel:Find("ExitGoDaTingButton"):GetComponent("Button")
    self.exitPanel.gameObject:SetActive(false);

    self.openChipListBtn = self.MainContent:Find("Content/Bottom/Chip/YZBtn"):GetComponent("Button");--下注金额
    self.YZPanel = self.MainContent:Find("Content/Bottom/Chip/YZPanel")
    self.closeYZPanelBtn = self.YZPanel:Find("CloseYZBtn"):GetComponent("Button")
    self.YZmainPanel = self.YZPanel:Find("YZmainPanel")
    self.YZPanel.gameObject:SetActive(false);

    self.iconZJ = self.MainContent:Find("Content/MainBackground/Image/IconZJ")

    self.JACKPOTNum = self.iconZJ:Find("JACKPOT"):GetComponent("TextMeshProUGUI")

    self.ZPPanel = self.MainContent:Find("ZhuanPanPanel").gameObject

    XYSGJ_SmallGame:Init(self.ZPPanel)

    -- if not AllSetGameInfo._5IsPlayAudio then
    --     self.musicSet.value = 0;
    -- else
    --     if PlayerPrefs.HasKey("MusicValue") then
    --         local musicVol = PlayerPrefs.GetString("MusicValue");
    --         self.musicSet.value = tonumber(musicVol);
    --     else
    --         self.musicSet.value = 1;
    --     end
    -- end
    -- if not AllSetGameInfo._6IsPlayEffect then
    --     self.soundSet.value = 0;
    -- else
    --     if PlayerPrefs.HasKey("SoundValue") then
    --         local soundVol = PlayerPrefs.GetString("SoundValue");
    --         self.soundSet.value = tonumber(soundVol);
    --     else
    --         self.soundSet.value = 1;
    --     end
    -- end

end
function XYSGJEntry.AddListener()
    --添加监听事件
    self.startBtn.onClick:RemoveAllListeners();
    self.startBtn.onClick:AddListener(self.StartGameCall);
    local et = self.startBtn.gameObject:AddComponent(typeof(LuaFramework.EventTriggerListener));
    et.onDown = self.OnDownStartBtnCall;
    et.onUp = self.OnUpStartBtnCall;

    self.closeGame.onClick:RemoveAllListeners();
    self.closeGame.onClick:AddListener(function()
        XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.BTN);
        self.exitPanel.gameObject:SetActive(true)
    end);

    self.soundBtn.onClick:RemoveAllListeners();
    self.soundBtn.onClick:AddListener(self.SetSoundCall);

    self.AutoStartBtn.onClick:RemoveAllListeners();
    self.AutoStartBtn.onClick:AddListener(self.OnClickAutoStartCall);

    self.showRuleBtn.onClick:RemoveAllListeners();--显示规则
    self.showRuleBtn.onClick:AddListener(self.ShowRultPanel);

    self.selectBtn_Close.onClick:RemoveAllListeners();--显示规则
    self.selectBtn_Close.onClick:AddListener(self.CloseSelectPanel);

    -- self.musicSet.onValueChanged:RemoveAllListeners();
    -- self.musicSet.onValueChanged:AddListener(self.SetMusicVolumn);
    -- self.soundSet.onValueChanged:RemoveAllListeners();
    -- self.soundSet.onValueChanged:AddListener(self.SetSoundVolumn);

    -- self.closeSet.onClick:RemoveAllListeners();
    -- self.closeSet.onClick:AddListener(function()
    --     self.settingPanel.gameObject:SetActive(false);
    -- end);

    self.exitPanelQX.onClick:RemoveAllListeners();
    self.exitPanelQX.onClick:AddListener(function()
        XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.BTN);
        self.exitPanel.gameObject:SetActive(false)
    end);

    self.exitPanelClose.onClick:RemoveAllListeners();
    self.exitPanelClose.onClick:AddListener(function()
        XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.BTN);
        self.exitPanel.gameObject:SetActive(false)
    end);

    self.exitPanelSure.onClick:RemoveAllListeners();
    self.exitPanelSure.onClick:AddListener(self.CloseGameCall);

    self.openChipListBtn.onClick:RemoveAllListeners();
    self.openChipListBtn.onClick:AddListener(function()
        XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.BTN);
        self.YZPanel.gameObject:SetActive(true);
    end);

    self.closeYZPanelBtn.onClick:RemoveAllListeners();
    self.closeYZPanelBtn.onClick:AddListener(function()
        XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.BTN);
        self.YZPanel.gameObject:SetActive(false);
    end);

    local go1 = self.selectPanel:Find("GameObject"):GetChild(0):GetComponent("Button")
    go1.onClick:RemoveAllListeners();
    go1.onClick:AddListener(self.SelectAutoNum1);

    local go2 = self.selectPanel:Find("GameObject"):GetChild(1):GetComponent("Button")
    go2.onClick:RemoveAllListeners();
    go2.onClick:AddListener(self.SelectAutoNum2);

    local go3 = self.selectPanel:Find("GameObject"):GetChild(2):GetComponent("Button")
    go3.onClick:RemoveAllListeners();
    go3.onClick:AddListener(self.SelectAutoNum3);

    local go4 = self.selectPanel:Find("GameObject"):GetChild(3):GetComponent("Button")
    go4.onClick:RemoveAllListeners();
    go4.onClick:AddListener(self.SelectAutoNum4);

    for i = 1, self.YZmainPanel.childCount do
        self.YZmainPanel:GetChild(i - 1):GetComponent("Button").onClick:RemoveAllListeners();
        self.YZmainPanel:GetChild(i - 1):GetComponent("Button").onClick:AddListener(function()
            self.SelectChipCall(self.YZmainPanel:GetChild(i - 1):GetChild(0))
        end);
    end
end
function XYSGJEntry.GetGameConfig()
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
        XYSGJ_DataConfig.rollTime = data.rollTime;
        XYSGJ_DataConfig.rollReboundRate = data.rollReboundRate;
        XYSGJ_DataConfig.rollInterval = data.rollInterval;
        XYSGJ_DataConfig.rollSpeed = data.rollSpeed;
        XYSGJ_DataConfig.caijinGoldChangeRate = data.caijinGoldChangeRate;
        XYSGJ_DataConfig.winGoldChangeRate = data.winGoldChangeRate;
        XYSGJ_DataConfig.selfGoldChangeRate = data.selfGoldChangeRate;
        XYSGJ_DataConfig.freeLoadingShowTime = data.freeLoadingShowTime;
        XYSGJ_DataConfig.smallGameLoadingShowTime = data.smallGameLoadingShowTime;
        XYSGJ_DataConfig.rollDistance = data.rollDistance;
        XYSGJ_DataConfig.REQCaiJinTime = data.REQCaiJinTime;
        XYSGJ_DataConfig.lineAllShowTime = data.lineAllShowTime;
        XYSGJ_DataConfig.cyclePlayLineTime = data.cyclePlayLineTime;
        XYSGJ_DataConfig.waitShowLineTime = data.waitShowLineTime;
        XYSGJ_DataConfig.autoRewardInterval = data.autoRewardInterval;
        XYSGJ_DataConfig.autoNoRewardInterval = data.autoNoRewardInterval;
    end);
end
function XYSGJEntry.ToCharArray(num)
    --拆解字符串
    local str = tostring(num);
    local list1 = {}
    for i = 1, string.len(str) do
        table.insert(list1, #list1 + 1, string.sub(str, i, i));
    end
    return list1;
end
function XYSGJEntry.FormatNumberThousands(num)
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
function XYSGJEntry.SetSelfGold(str)
    self.selfGold.text = self.ShowText(str);
end
function XYSGJEntry.ShowText(str)
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

function XYSGJEntry.CloseSelectPanel()
    self.selectPanel.gameObject:SetActive(false)
end

function XYSGJEntry.OnDownStartBtnCall()
    if self.isFreeGame then
        return ;
    end
    self.clickStartTimer = 0;
    self.isPlayAudio = false;
end
function XYSGJEntry.OnUpStartBtnCall()
    if self.clickStartTimer < 2 and self.clickStartTimer ~= -1 then
        self.clickStartTimer = -1;
        self.isPlayAudio = false;
        self.startBtn.transform:Find("anniu").gameObject:SetActive(false)
        XYSGJ_Audio.ClearAuido(XYSGJ_Audio.SoundList.yx_longClick);
    end
end

function XYSGJEntry.SelectAutoNum1()
    self.currentAutoCount = 20
    XYSGJEntry.SelectAutoNum()
end
function XYSGJEntry.SelectAutoNum2()
    self.currentAutoCount = 50
    XYSGJEntry.SelectAutoNum()
end
function XYSGJEntry.SelectAutoNum3()
    self.currentAutoCount = 100
    XYSGJEntry.SelectAutoNum()
end
function XYSGJEntry.SelectAutoNum4()
    self.currentAutoCount = 1000000
    XYSGJEntry.SelectAutoNum()
end
function XYSGJEntry.SelectAutoNum()
    local str = ""
    if self.currentAutoCount > 100 then
        str = "w"
    else
        str = "" .. self.currentAutoCount
    end
    self.YZPanel.gameObject:SetActive(false);
    XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.BTN);
    self.isAutoGame = true
    self.SetState(3)
    XYSGJEntry.SetAutoNum(str)
    self.openChipListBtn.interactable = false;

    if not self.isRoll then
        XYSGJ_Network.StartGame();
    end
    XYSGJEntry.CloseSelectPanel()
end

function XYSGJEntry.SetAutoNum(num)
    self.AutoStartBtn.transform:Find("Text"):GetComponent("TextMeshProUGUI").text = ShowRichText(num)
end

function XYSGJEntry.ReduceChipCall()
    --减注
    XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.BTN);
    if self.SceneData.chipList == nil or #self.SceneData.chipList <= 0 then
        return ;
    end
    self.CurrentChipIndex = self.CurrentChipIndex - 1;
    if self.CurrentChipIndex <= 0 then
        self.CurrentChipIndex = #self.SceneData.chipList;
    end

    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.CurrentChip * XYSGJ_DataConfig.ALLLINECOUNT);
end
function XYSGJEntry.AddChipCall()
    --加注
    XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.BTN);
    if self.SceneData.chipList == nil or #self.SceneData.chipList <= 0 then
        return ;
    end
    self.CurrentChipIndex = self.CurrentChipIndex + 1;
    if self.CurrentChipIndex > #self.SceneData.chipList then
        self.CurrentChipIndex = 1;
    end
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.CurrentChip * XYSGJ_DataConfig.ALLLINECOUNT);
end

function XYSGJEntry.BigChipCall()
    XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.BTN);
    if self.SceneData.chipList == nil or #self.SceneData.chipList <= 0 then
        return ;
    end
    self.CurrentChipIndex = 5
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.CurrentChip * XYSGJ_DataConfig.ALLLINECOUNT);
end

function XYSGJEntry.SelectChipCall(args)
    logYellow("点击的筹码为==" .. tostring(args.name))
    local chipNum = tonumber(args.name)
    for i = 1, #XYSGJEntry.SceneData.chipList do
        if chipNum == self.SceneData.chipList[i] * XYSGJ_DataConfig.ALLLINECOUNT then
            self.CurrentChipIndex = i
        end
    end
    self.ChipNum.text = self.ShowText(chipNum);

    self.CurrentChip = chipNum / XYSGJ_DataConfig.ALLLINECOUNT
    self.YZPanel.gameObject:SetActive(false);
end

function XYSGJEntry.StartGameCall()
    --开始游戏

    if self.isFreeGame or self.isAutoGame then
        return ;
    end

    if self.isRoll then
        --TODO 急停
        XYSGJ_Roll.StopRoll();
        self.startBtn.interactable = false;
        return ;
    end
    --isLongClick=true
    XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.BTN);
    if self.myGold < self.CurrentChip * XYSGJ_DataConfig.ALLLINECOUNT then
        MessageBox.CreatGeneralTipsPanel("Not enough gold!")
        self.startBtn.transform:Find("On").gameObject:SetActive(true);
        self.startBtn.transform:Find("Off").gameObject:SetActive(false);
        self.startBtn.interactable = true;
        self.openChipListBtn.interactable = true;
        return
    end

    self.startBtn.transform:Find("On").gameObject:SetActive(false);
    self.startBtn.transform:Find("Off").gameObject:SetActive(true);
    self.openChipListBtn.interactable = false;

    --TODO 发送开始消息,等待结果开始转动
    XYSGJ_Network.StartGame();
end

function XYSGJEntry.SetMusicVolumn(value)
    --log(value)
    --if value == 0 then
    --    AllSetGameInfo._5IsPlayAudio = false;
    --    XYSGJ_Audio.pool.mute = true;
    --else
    --    AllSetGameInfo._5IsPlayAudio = true;
    --    XYSGJ_Audio.pool.mute = false;
    --end
    MusicManager:SetValue(MusicManager:GetSoundVolume(),value);
    XYSGJ_Audio.pool.volume = value;
    MusicManager:SetMusicMute(value <= 0);
    XYSGJ_Audio.pool.mute = not MusicManager:GetIsPlayMV();
    --Util.Write("IsPlayAudio", tostring(AllSetGameInfo._5IsPlayAudio));
    --PlayerPrefs.SetString("IsPlayAudio", tostring(AllSetGameInfo._5IsPlayAudio));
    --PlayerPrefs.SetString("MusicValue", tostring(value));
    --GameManager.SetIsPlayMute(AllSetGameInfo._6IsPlayEffect, AllSetGameInfo._5IsPlayAudio);
end
function XYSGJEntry.SetSoundVolumn(value)
    --if value == 0 then
    --    AllSetGameInfo._6IsPlayEffect = false;
    --else
    --    AllSetGameInfo._6IsPlayEffect = true;
    --end
    --Util.Write("isCanPlaySound", tostring(AllSetGameInfo._6IsPlayEffect));
    --PlayerPrefs.SetString("isCanPlaySound", tostring(AllSetGameInfo._5IsPlayAudio));
    --PlayerPrefs.SetString("SoundValue", tostring(value));
    --GameManager.SetIsPlayMute(AllSetGameInfo._6IsPlayEffect, AllSetGameInfo._5IsPlayAudio);
    MusicManager:SetValue(value,MusicManager:GetMusicVolume());
    MusicManager:SetSoundMute(value <= 0);
end

function XYSGJEntry.ClickMenuCall()
    --点击显示菜单
    XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.BTN);
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
function XYSGJEntry.CloseMenuCall()
    --关闭菜单
    XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.BTN);
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
function XYSGJEntry.CloseGameCall()
    if not self.isFreeGame and not self.isSmallGame then
        Event.Brocast(MH.Game_LEAVE);
    else
        MessageBox.CreatGeneralTipsPanel("Cannot leave the game in special mode");
    end
end
function XYSGJEntry.SetSoundCall()
    --self.settingPanel.gameObject:SetActive(true);
end

function XYSGJEntry.OnClickAutoCall()
    --点击自动开始
    XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.BTN);
    if self.isAutoGame then
        self.StopAutoGame();
        return ;
    end
    self.selectPanel.gameObject:SetActive(true);
    self.startBtn.transform:Find("anniu").gameObject:SetActive(false)
end
function XYSGJEntry.OnClickAutoStartCall()
    --点击选择自动次数
    if self.isAutoGame then
        self.StopAutoGame();
        return ;
    end
    --self.AutoStartCall();
end
function XYSGJEntry.AutoStartCall()

    if not self.isFreeGame then
        if self.myGold < self.CurrentChip * XYSGJ_DataConfig.ALLLINECOUNT then
            MessageBox.CreatGeneralTipsPanel("Not enough gold!")
            return
        end
    end

    XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.BTN);
    self.isAutoGame = true;
    self.AutoStartBtn.transform:Find("On").gameObject:SetActive(true);
    self.AutoStartBtn.transform:Find("Text").gameObject:SetActive(true);
    self.startBtn.interactable = false;
    local str = ""
    if self.currentAutoCount > 100 then
        str = "w"
    else
        str = "" .. self.currentAutoCount
    end
    XYSGJEntry.SetAutoNum(str)

    if not self.isRoll and not self.isFreeGame or not self.isSmallGame then
        --没有转动的状态开始自动旋转
        XYSGJ_Network.StartGame();
    end
end
function XYSGJEntry.ShowRultPanel()
    --显示规则
    XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.BTN);
    XYSGJ_Rule.ShowRule();
end
function XYSGJEntry.SetMaxChipCall()
    --设置最大下注
    XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.BTN);
    self.CurrentChipIndex = #self.SceneData.chipList;
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.CurrentChip);
end

function XYSGJEntry.CSJLRoll()
    XYSGJ_Network.StartGame();
end
function XYSGJEntry.StopAutoGame()
    --停止自动旋转
    self.isAutoGame = false;
    self.currentAutoCount = 0;
    self.AutoStartBtn.transform:Find("On").gameObject:SetActive(true);
    XYSGJEntry.SetAutoNum(self.currentAutoCount)

    self.startBtn.interactable = true;
    self.SetState(1)
end
function XYSGJEntry.FreeGame()
    --免费游戏
    self.isFreeGame = true;

    self.freeText.text = ShowRichText(self.freeCount);
    XYSGJ_Network.StartGame();
end
function XYSGJEntry.Roll()
    --开始转动    
    if not self.isFreeGame and not XYSGJ_Result.isWinCSJL or self.isSmallGame then

        self.myGold = self.myGold - self.CurrentChip * XYSGJ_DataConfig.ALLLINECOUNT;
        XYSGJEntry.SetSelfGold(self.myGold);
    end
    XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.yx_spin);
    if not XYSGJEntry.isFreeGame then
        self.WinNum.text = self.ShowText(0);
    end
    self.WinGoldText.text = self.ShowText(0)
    self.WinGold.gameObject:SetActive(false)
    self.TipText.text = ""
    XYSGJ_Result.HideResult();
    XYSGJ_Line.Close();

    XYSGJ_Roll.StartRoll();
end
function XYSGJEntry.OnStop()
    --停止转动
    log("停止")
    logYellow("停止")
    self.startBtn.transform:Find("On").gameObject:SetActive(true);
    self.startBtn.transform:Find("Off").gameObject:SetActive(false);
    self.startBtn.interactable = false;
    self.openChipListBtn.interactable = false;

    XYSGJ_Result.ShowResult();
end
function XYSGJEntry.OnStop1()
    --停止转动
    log("停止")
    self.startBtn.transform:Find("On").gameObject:SetActive(true);
    self.startBtn.transform:Find("Off").gameObject:SetActive(false);
    self.startBtn.interactable = false;
    self.openChipListBtn.interactable = false;

    --XYSGJ_Result.ShowResult();
end

function XYSGJEntry.InitPanel()
    --场景消息初始化
    self.myGold = TableUserInfo._7wGold;
    XYSGJEntry.SetSelfGold(self.myGold);
    for i = 1, #self.SceneData.chipList do
        self.YZmainPanel:GetChild(i - 1):GetChild(0):GetComponent("TextMeshProUGUI").text = ShortNumber(self.SceneData.chipList[i] * XYSGJ_DataConfig.ALLLINECOUNT)
        self.YZmainPanel:GetChild(i - 1):GetChild(0).name = "" .. self.SceneData.chipList[i] * XYSGJ_DataConfig.ALLLINECOUNT
        if XYSGJEntry.SceneData.bet == self.SceneData.chipList[i] then
            self.CurrentChipIndex = i
        end
    end

    if self.SceneData.freeNumber <= 0 then
        self.CurrentChipIndex = CheckNear(self.myGold,self.SceneData.chipList)
    end
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.CurrentChip * XYSGJ_DataConfig.ALLLINECOUNT)

    self.WinNum.text = self.ShowText(0);
    self.WinGoldText.text = self.ShowText(0)
    self.WinGold.gameObject:SetActive(false)
    self.TipText.text = ""
    --XYSGJ_Caijin.isCanSend = true;
    self.isRoll = false;
    XYSGJ_Line.Init();
    XYSGJ_Result.Init();

    if self.SceneData.freeNumber > 0 then
        --如果免费
        self.freeCount = self.SceneData.freeNumber;
        self.isFreeGame = true;
        self.SetState(2);
        self.openChipListBtn.interactable = false;
        XYSGJ_Result.ShowFreeEffect(true);
        if self.SceneData.cbBouns > 0 then
            self.isSmallGame = true
            XYSGJEntry.ResultData.isSmallGame = 1
            self.SetState(4);
        end
    elseif self.SceneData.cbBouns > 0 then
        self.isSmallGame = true
        XYSGJEntry.ResultData.isSmallGame = 1
        self.SetState(4);
    else
        self.SetState(1);
    end
end
function XYSGJEntry.SetState(state)
    if state == 1 then
        --正常模式 or 自动模式
        self.normalBackground:SetActive(true);
        self.startBtn.gameObject:SetActive(true);
        self.AutoStartBtn.gameObject:SetActive(false);
        self.freeText.gameObject:SetActive(false);
        self.freePanel.gameObject:SetActive(false)
        self.caiJinPanel.gameObject:SetActive(false)
        self.iconZJ.gameObject:SetActive(true)
    elseif state == 2 then
        --免费模式
        self.normalBackground:SetActive(true);
        self.caiJinPanel.gameObject:SetActive(true)
        self.startBtn.gameObject:SetActive(false);
        self.AutoStartBtn.gameObject:SetActive(false);
        self.freeText.gameObject:SetActive(true);
        self.freePanel.gameObject:SetActive(true)
        self.iconZJ.gameObject:SetActive(false)
    elseif state == 3 then
        --zidong
        self.normalBackground:SetActive(true);
        self.startBtn.gameObject:SetActive(false);
        self.AutoStartBtn.gameObject:SetActive(true);
        self.freeText.gameObject:SetActive(false);
        self.freePanel.gameObject:SetActive(false)
        self.caiJinPanel.gameObject:SetActive(false)
        self.iconZJ.gameObject:SetActive(true)
    elseif state == 4 then
        XYSGJ_SmallGame.Run()
    end
end
function XYSGJEntry.FreeRoll()

    logYellow("FreeRoll")
    --判断是否为免费游戏
    XYSGJ_Result.isShow = false;
    if XYSGJEntry.isSmallGame then
        XYSGJ_SmallGame.Run()
        return
    end
    if self.isFreeGame then
        self.freeCount = self.freeCount - 1;
        self.currentFreeCount = self.currentFreeCount + 1;
        if self.freeCount < 0 then
            --免费结束
            self.isFreeGame = false;
            XYSGJ_Audio.PlayBGM();
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
function XYSGJEntry.AutoRoll()
    --判断是否为自动游戏
    if self.isAutoGame then
        --如果是自动游戏
        if self.currentAutoCount < 1000 then
            self.currentAutoCount = self.currentAutoCount - 1;
        end
        if self.currentAutoCount < 0 then
            --自动次数使用完了，回到待机状态
            self.TipText.text = "点击旋转赢取奖励";
            self.startBtn.transform:Find("On").gameObject:SetActive(true);
            self.startBtn.transform:Find("Off").gameObject:SetActive(false);
            self.startBtn.interactable = true;
            self.openChipListBtn.interactable = true;
            self.StopAutoGame();
        else
            --还有自动次数
            self.AutoStartCall();
            self.SetState(3);
        end
    else
        --不是自动游戏，直接待机
        self.TipText.text = "点击旋转赢取奖励";
        self.startBtn.transform:Find("On").gameObject:SetActive(true);
        self.startBtn.transform:Find("Off").gameObject:SetActive(false);
        self.startBtn.interactable = true;
        self.openChipListBtn.interactable = true;

        self.StopAutoGame();
    end
end
function XYSGJEntry.SetKM(num)
    local Str = ""
    local numStr = ""
    local cStr = ""

    if tonumber(num) < 1000 then
        numStr = "" .. num
        cStr = ""
    elseif tonumber(num) >= 1000 and tonumber(num) < 10000000 then
        numStr = "" .. num / 1000
        cStr = "k"
    elseif tonumber(num) >= 10000000 then
        numStr = "" .. num / 1000000
        cStr = "m"
    end

    return numStr .. cStr
end