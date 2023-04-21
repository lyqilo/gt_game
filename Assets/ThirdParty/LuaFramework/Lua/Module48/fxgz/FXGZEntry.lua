-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion
local g_swlzbNum = "Module48/fxgz/";

require(g_swlzbNum .. "FXGZ_Network")
require(g_swlzbNum .. "FXGZ_Roll")
require(g_swlzbNum .. "FXGZ_DataConfig")
require(g_swlzbNum .. "FXGZ_Caijin")
require(g_swlzbNum .. "FXGZ_Line")
require(g_swlzbNum .. "FXGZ_Result")
require(g_swlzbNum .. "FXGZ_Rule")
require(g_swlzbNum .. "FXGZ_Audio")
require(g_swlzbNum .. "FXGZ_SmallGame")

FXGZEntry = {};
local self = FXGZEntry;
self.transform = nil;
self.gameObject = nil;
self.luaBehaviour = nil;

self.CurrentFreeIndex = 0;
self.CurrentChip = 0;
self.CurrentChipIndex = 0;
self.isAutoGame = false;
self.isFreeGame = false;
self.isReRollGame = false;
self.isSmallGame = false;
self.isRoll = false;
self.menuTweener = nil;
self.currentSelectBonus = 0;

self.currentFreeCount = 0;

self.currentAutoCount = 0;--剩余自动次数
self.freeCount = 0;--剩余免费次数
self.totalFreeCount = 0;

self.smallGameCount = 0;

self.myGold = 0;--显示的自身金币
self.ScatterList = {};

self.clickStartTimer = -1;
self.betRollList = {};
self.betProgresslist = {};
self.isPlayAudio = false;

self.SceneData = {
    freeNumber = 0, --免费次数
    bet = 0, --当前下注
    chipNum = 0, --用户金币
    chipList = {}, --下注列表
    cbFreeType = 0, --游戏类型
    cbCurMul = 0, --当前倍数
    cbFreeGameIndex = {}, --已经点击下标
    cbFreeGameIconCount = {}, -- 图标个数
};
self.ResultData = {
    ImgTable = {}, --图标
    LineTypeTable = {}, --连线类型
    WinScore = 0, --赢得总分
    FreeCount = 0, --免费次数
    FreeType = 0, --免费类型
    m_nWinPeiLv = 0, --当前倍率
    cbHitBouns = 0, --中小游戏
}
self.SmallResultData = {
    cbResCode = 0, --//失败0，1，2，3，4
    nFreeCount = 0--免费次数
}
function FXGZEntry:Awake(obj)
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
    self.AddListener();
    FXGZ_Roll.Init(self.RollContent);
    FXGZ_Audio.Init();
    FXGZ_Rule.Init();
    FXGZ_SmallGame.Init(self.SmallGamePanel);
    FXGZ_Caijin.currentCaijin = 0;
    --FXGZ_SmallGame.Init(self.SmallGamePanel);
    FXGZ_Network.AddMessage();--添加消息监听
    FXGZ_Network.LoginGame();--开始登录游戏
    GameSetsPanel.CreateHideObj(self.MainContent, false);
    FXGZ_Audio.PlayBGM();
end
--
function FXGZEntry.OnDestroy()
    FXGZ_Line.Close();
    FXGZ_Network.UnMessage();
end

function FXGZEntry:Update()
    self.CanShowAuto();
    FXGZ_Roll.Update();
    FXGZ_Caijin.Update();
    FXGZ_Line.Update();
end
function FXGZEntry.ResetRoll()
    self.AutoContent.gameObject:SetActive(false);
    self.FreeContent.gameObject:SetActive(false);
    self.startState.gameObject:SetActive(true);
    self.stopState.gameObject:SetActive(false);
    self.ReRollContent.gameObject:SetActive(false);
    FXGZEntry.MaxChipBtn.interactable = true;
    self.openChipBtn.interactable = true;
    self.startState.interactable = true;
end
function FXGZEntry.CanShowAuto()
    if self.clickStartTimer >= 0 and not self.isAutoGame then
        self.clickStartTimer = self.clickStartTimer + Time.deltaTime;
        if self.clickStartTimer >= 0.5 and not self.isPlayAudio and self.clickStartTimer < 2 then
            self.isPlayAudio = true;
            self.autoEffect.gameObject:SetActive(true);
            FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.LongPress);
        end
        if self.clickStartTimer >= 2 then
            self.clickStartTimer = -1;
            self.isPlayAudio = false;
            --WSZS_Audio.ClearAuido(WSZS_Audio.SoundList.LongPress);
            self.autoEffect.gameObject:SetActive(false);
            self.OnClickAutoCall();
        end
    end
end

function FXGZEntry.FindComponent()
    self.MainContent = self.transform:Find("MainPanel");

    self.RollContent = self.MainContent:Find("Content/RollContent");--转动区域
    self.chipGroup = self.MainContent:Find("Content/Bottom/Chip");
    self.openChipBtn = self.MainContent:Find("Content/Bottom/Chip/OpenChip"):GetComponent("Button");
    self.chiplistBtn = self.MainContent:Find("Content/Bottom/Chip/Mask"):GetComponent("Button");
    self.ChipNum = self.MainContent:Find("Content/Bottom/Chip/Num"):GetComponent("TextMeshProUGUI");--下注金额
    self.WinNum = self.MainContent:Find("Content/Bottom/Win/Num"):GetComponent("TextMeshProUGUI");--本次获得金币
    self.WinDesc = self.MainContent:Find("Content/Bottom/Win/WinDesc"):GetComponent("TextMeshProUGUI");--本次获得金币
    self.WinDesc.text = "恭喜旋转，赢取奖励";

    self.baseChipGroup = self.MainContent:Find("Content/Bottom/BaseScore");
    self.baseChipNum = self.baseChipGroup:Find("Num"):GetComponent("TextMeshProUGUI");

    self.addBei = self.MainContent:Find("Content/Bottom/AddBei");
    self.addBeiNum = self.addBei:Find("Num"):GetComponent("TextMeshProUGUI");

    self.MosaicNum = self.MainContent:Find("Content/Mosaic/MosaicNum"):GetComponent("TextMeshProUGUI");--彩金

    self.btnGroup = self.MainContent:Find("Content/ButtonGroup");
    self.startBtn = self.btnGroup:Find("StartBtn");--开始按钮
    self.startState = self.startBtn.transform:Find("Start"):GetComponent("Button");
    self.stopState = self.startBtn.transform:Find("Stop"):GetComponent("Button");
    self.ReRollContent = self.startBtn.transform:Find("ReRoll");--重转状态
    self.ReRollNum = self.ReRollContent.transform:Find("Num"):GetComponent("TextMeshProUGUI");--重转状态
    self.FreeContent = self.startBtn.transform:Find("Free");--免费状态
    self.freeText = self.FreeContent.transform:Find("Num"):GetComponent("TextMeshProUGUI");--免费次数
    self.AutoContent = self.startBtn.transform:Find("AutoState"):GetComponent("Button");
    self.CancelAutobtn = self.startBtn.transform:Find("CancelAuto"):GetComponent("Button");
    self.autoText = self.AutoContent.transform:Find("AutoNum"):GetComponent("TextMeshProUGUI");--自动次数
    self.autoInfinite = self.AutoContent.transform:Find("Infinite")--无限次数
    self.autoEffect = self.startBtn.transform:Find("AutoEffect");
    self.autoEffect.gameObject:SetActive(false);

    self.MaxChipBtn = self.btnGroup:Find("MaxChip"):GetComponent("Button");--最大下注
    self.closeAutoMenu = self.btnGroup:Find("CloseAutoMenu"):GetComponent("Button");--关闭自动开始界面
    self.autoSelectList = self.closeAutoMenu.transform:Find("AutoSelect");--自动开始次数选择
    self.closeAutoMenu.gameObject:SetActive(false);

    self.rulePanel = self.MainContent:Find("Content/Rule");--规则界面
    self.ruleList = self.rulePanel:Find("Content/RuleList"):GetComponent("ScrollRect");--规则子界面
    self.leftShowBtn = self.rulePanel:Find("Content/LeftBtn"):GetComponent("Button");
    self.rightShowBtn = self.rulePanel:Find("Content/RightBtn"):GetComponent("Button");
    self.closeRuleBtn = self.rulePanel:Find("Content/BackBtn"):GetComponent("Button");
    self.ruleProgress = self.rulePanel:Find("Content/Progress");

    self.settingPanel = self.MainContent:Find("Content/Setting");
    self.menuBtn = self.MainContent:Find("Content/Menu"):GetComponent("Button");--菜单按钮
    self.menulist = self.MainContent:Find("Content/MenuList");--菜单按钮详情
    self.menulist.gameObject:SetActive(false);
    self.backgroundBtn = self.MainContent:Find("Content/CloseMenu"):GetComponent("Button");
    self.closeGame = self.menulist:Find("Back"):GetComponent("Button");
    self.settingBtn = self.menulist:Find("Setting"):GetComponent("Button");
    self.musicSet = self.settingPanel:Find("Setting/Music"):GetComponent("Slider");
    self.soundSet = self.settingPanel:Find("Setting/Sound"):GetComponent("Slider");
    self.closeSet = self.settingPanel:Find("Setting/Close"):GetComponent("Button");

    self.menuBtn = self.MainContent:Find("Content/Menu"):GetComponent("Button");--菜单按钮
    self.showRuleBtn = self.MainContent:Find("Content/RuleBtn"):GetComponent("Button");

    self.resultEffect = self.MainContent:Find("Content/Result");--中奖后特效
    self.normalWinEffect = self.resultEffect:Find("NormalWin");
    self.normalWinEffect.gameObject:SetActive(false);
    self.normalWinNum = self.normalWinEffect:Find("Num"):GetComponent("TextMeshProUGUI");
    self.skipNormal = self.normalWinEffect:Find("SkipBtn"):GetComponent("Button");
    self.midWinEffect = self.resultEffect:Find("BigWin");
    self.midWinEffect.gameObject:SetActive(false);
    self.midWinProgress = self.midWinEffect:Find("BigWin_Anim/BigWin_Slide"):GetComponent("Image");
    self.midWinTitle = self.midWinEffect:Find("BigWin_Anim/BigWin_Titles");
    self.midWinNum = self.midWinEffect:Find("Num"):GetComponent("TextMeshProUGUI");
    self.skipMiddle = self.midWinEffect:Find("SkipBtn"):GetComponent("Button");
    self.bigWinEffect = self.resultEffect:Find("MegaWin");
    self.bigWinEffect.gameObject:SetActive(false);
    self.bigWinProgress = self.bigWinEffect:Find("MegaWin_Anim/MegaWin_Slide"):GetComponent("Image");
    self.bigWinTitle = self.bigWinEffect:Find("MegaWin_Anim/MegaWin_Titles");
    self.bigWinNum = self.bigWinEffect:Find("Num"):GetComponent("TextMeshProUGUI");
    self.skipBig = self.bigWinEffect:Find("SkipBtn"):GetComponent("Button");
    self.EnterFreeEffect = self.resultEffect:Find("EnterFree");
    self.EnterFreeEffect.gameObject:SetActive(false);
    self.EnterFreeNum = self.EnterFreeEffect:Find("Content/Num"):GetComponent("TextMeshProUGUI");
    self.EnterBonusEffect = self.resultEffect:Find("EnterBonus");
    self.EnterBonusEffect.gameObject:SetActive(false);
    self.EnterReRollEffect = self.resultEffect:Find("EnterReRoll");
    self.EnterReRollEffect.gameObject:SetActive(false);
    self.EnterReRollNum = self.EnterReRollEffect:Find("Content/Num"):GetComponent("TextMeshProUGUI");
    self.FreeResultEffect = self.resultEffect:Find("FreeResult");
    self.FreeResultEffect.gameObject:SetActive(false);
    self.FreeResultNum = self.FreeResultEffect:Find("Num"):GetComponent("TextMeshProUGUI");
    self.MosaicResultEffect = self.resultEffect:Find("MosaicResult");
    self.MosaicResultEffect.gameObject:SetActive(false);
    self.MosaicResultNum = self.MosaicResultEffect:Find("Num"):GetComponent("TextMeshProUGUI");
    self.ReRollResultEffect = self.resultEffect:Find("ReRollResult");
    self.ReRollResultEffect.gameObject:SetActive(false);
    self.ReRollResultNum = self.ReRollResultEffect:Find("Num"):GetComponent("TextMeshProUGUI");

    self.addBeiTip = self.resultEffect:Find("ZengBeiTip");
    self.addBeiTip.gameObject:SetActive(false);
    self.addBeiTipNum = self.addBeiTip:Find("Content/Num"):GetComponent("TextMeshProUGUI");
    self.wtTip = self.resultEffect:Find("WuTiaoTip");

    self.userInfo = self.MainContent:Find("Content/Bottom/UserInfo");
    self.headIcon = self.userInfo:Find("Head"):GetComponent("Image");
    self.nickName = self.userInfo:Find("NickName"):GetComponent("Text");
    self.selfGold = self.userInfo:Find("Gold/Num"):GetComponent("TextMeshProUGUI");--自身金币
    self.goldEffect = self.userInfo:Find("GoldImg/FXGZ_jibi04").gameObject;
    self.goldEffect:SetActive(false);

    self.icons = self.MainContent:Find("Content/Icons");--图标库
    self.effectList = self.MainContent:Find("Content/EffectList");--动画库
    self.effectPool = self.MainContent:Find("Content/EffectPool");--动画缓存库
    self.CSGroup = self.MainContent:Find("Content/CSContent");--显示财神
    self.LineGroup = self.MainContent:Find("Content/LineGroup");--连线
    self.soundList = self.MainContent:Find("Content/SoundList");--声音库
    self.SmallGamePanel = self.MainContent:Find("Content/SmallGamePanel");--小游戏
    self.settingPanel = self.MainContent:Find("Content/Setting");--设置界面

    self.quitPanel = self.MainContent:Find("Content/QuitPanel");

    self.headIcon.sprite = HallScenPanel.GetHeadIcon();
    self.nickName.text = SCPlayerInfo._05wNickName;
end

function FXGZEntry.AddListener()
    --添加监听事件
    self.startState.onClick:RemoveAllListeners();
    self.startState.onClick:AddListener(self.StartGameCall);
    local et = self.startState.gameObject:AddComponent(typeof(LuaFramework.EventTriggerListener));
    et.onDown = self.OnDownStartBtnCall;
    et.onUp = self.OnUpStartBtnCall;

    self.stopState.onClick:RemoveAllListeners();
    self.stopState.onClick:AddListener(self.StartGameCall);
    self.AutoContent.onClick:RemoveAllListeners();
    self.AutoContent.onClick:AddListener(self.StopAutoGame);

    self.menuBtn.onClick:RemoveAllListeners();
    self.menuBtn.onClick:AddListener(self.ClickMenuCall);
    self.closeGame.onClick:RemoveAllListeners();
    self.closeGame.onClick:AddListener(self.CloseGameCall);

    self.openChipBtn.onClick:RemoveAllListeners();
    self.openChipBtn.onClick:AddListener(function()
        FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.BTN);
        local Group = self.chiplistBtn.transform:Find("Group");
        for i = 1, Group.childCount do
            local tog = Group:GetChild(i - 1):GetComponent("Toggle");
            if tog.gameObject.name ~= tostring(self.CurrentChip) then
                tog.isOn = false;
            else
                tog.isOn = true;
            end
        end
        self.chiplistBtn.gameObject:SetActive(true);
    end);
    self.chiplistBtn.onClick:RemoveAllListeners();
    self.chiplistBtn.onClick:AddListener(function()
        FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.BTN);
        self.chiplistBtn.gameObject:SetActive(false);
    end);

    self.settingBtn.onClick:RemoveAllListeners();
    self.settingBtn.onClick:AddListener(self.OpenSettingPanel);
    self.showRuleBtn.onClick:RemoveAllListeners();--显示规则
    self.showRuleBtn.onClick:AddListener(self.ShowRultPanel);

    self.backgroundBtn.onClick:RemoveAllListeners();
    self.backgroundBtn.onClick:AddListener(self.CloseMenuCall);

    self.closeSet.onClick:RemoveAllListeners();
    self.closeSet.onClick:AddListener(function()
        FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.BTN);
        self.settingPanel.gameObject:SetActive(false);
    end);

    self.MaxChipBtn.onClick:RemoveAllListeners();
    self.MaxChipBtn.onClick:AddListener(self.SetMaxChipCall);
    self.closeAutoMenu.onClick:RemoveAllListeners();--关闭自动
    self.closeAutoMenu.onClick:AddListener(function()
        self.startState.gameObject:SetActive(true);
        self.CancelAutobtn.gameObject:SetActive(false);
        self.closeAutoMenu.gameObject:SetActive(false);
    end)
    for i = 1, #FXGZ_DataConfig.autoList do
        --自动次数选择
        local child = nil;
        if i > self.autoSelectList.childCount then
            child = newObject(self.autoSelectList:GetChild(0)).transform;
            child:SetParent(self.autoSelectList);
            child.localPosition = Vector3.New(0, 0, 0);
            child.localRotation = Quaternion.identity;
            child.localScale = Vector3.New(1, 1, 1);
        else
            child = self.autoSelectList:GetChild(i - 1);
        end
        if FXGZ_DataConfig.autoList[i] > 1000 then
            child:Find("Infinite").gameObject:SetActive(true);
            child:Find("Num").gameObject:SetActive(false);
        else
            child:Find("Infinite").gameObject:SetActive(false);
            child:Find("Num").gameObject:SetActive(true);
            child:Find("Num"):GetComponent("TextMeshProUGUI").text = tostring(FXGZ_DataConfig.autoList[i]);
        end
        child.gameObject.name = tostring(FXGZ_DataConfig.autoList[i]);
        child:GetComponent("Button").onClick:RemoveAllListeners();
        child:GetComponent("Button").onClick:AddListener(function()
            self.currentAutoCount = FXGZ_DataConfig.autoList[i];
            self.OnClickAutoItemCall();
        end)
        child.gameObject:SetActive(true);
    end
end

function FXGZEntry.GetGameConfig()
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
        FXGZ_DataConfig.rollTime = data.rollTime;
        FXGZ_DataConfig.rollReboundRate = data.rollReboundRate;
        FXGZ_DataConfig.rollInterval = data.rollInterval;
        FXGZ_DataConfig.rollSpeed = data.rollSpeed;
        FXGZ_DataConfig.caijinGoldChangeRate = data.caijinGoldChangeRate;
        FXGZ_DataConfig.winGoldChangeRate = data.winGoldChangeRate;
        FXGZ_DataConfig.selfGoldChangeRate = data.selfGoldChangeRate;
        FXGZ_DataConfig.freeLoadingShowTime = data.freeLoadingShowTime;
        FXGZ_DataConfig.smallGameLoadingShowTime = data.smallGameLoadingShowTime;
        FXGZ_DataConfig.rollDistance = data.rollDistance;
        FXGZ_DataConfig.REQCaiJinTime = data.REQCaiJinTime;
        FXGZ_DataConfig.lineAllShowTime = data.lineAllShowTime;
        FXGZ_DataConfig.cyclePlayLineTime = data.cyclePlayLineTime;
        FXGZ_DataConfig.waitShowLineTime = data.waitShowLineTime;
        FXGZ_DataConfig.autoRewardInterval = data.autoRewardInterval;
        FXGZ_DataConfig.autoNoRewardInterval = data.autoNoRewardInterval;
    end);
end

function FXGZEntry.ToCharArray(num)
    --拆解字符串
    local str = tostring(num);
    local list1 = {}
    for i = 1, string.len(str) do
        table.insert(list1, #list1 + 1, string.sub(str, i, i));
    end
    return list1;
end

function FXGZEntry.FormatNumberThousands(num)
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

function FXGZEntry.OnDownStartBtnCall()
    if self.isFreeGame then
        return ;
    end
    self.clickStartTimer = 0;
    self.isPlayAudio = false;
end

function FXGZEntry.OnUpStartBtnCall()
    if self.clickStartTimer < 2 and self.clickStartTimer ~= -1 then
        self.clickStartTimer = -1;
        self.isPlayAudio = false;
        self.autoEffect.gameObject:SetActive(false);
        FXGZ_Audio.ClearAuido(FXGZ_Audio.SoundList.LongPress);
    end
end

function FXGZEntry.SetSelfGold(str)
    self.selfGold.text = ShortNumber(str);
end

function FXGZEntry.ShowText(str)
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

function FXGZEntry.StartGameCall()
    --开始游戏
    if self.isFreeGame or self.isSmallGame then
        return ;
    end
    if self.isAutoGame then
        self.OnClickAutoCall();
        return ;
    end
    if self.isRoll then
        --TODO 急停
        self.AutoContent.gameObject:SetActive(false);
        self.FreeContent.gameObject:SetActive(false);
        self.startState.gameObject:SetActive(true);
        self.stopState.gameObject:SetActive(false);
        self.baseChipGroup.gameObject:SetActive(false);
        self.ReRollContent.gameObject:SetActive(false);
        self.addBei.gameObject:SetActive(false);
        self.chipGroup.gameObject:SetActive(true);
        FXGZ_Roll.StopRoll();
        return ;
    end
    FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.BTN);
    self.AutoContent.gameObject:SetActive(false);
    self.FreeContent.gameObject:SetActive(false);
    self.startState.gameObject:SetActive(false);
    self.addBei.gameObject:SetActive(false);
    self.chipGroup.gameObject:SetActive(true);
    self.startState.interactable = false;
    self.stopState.gameObject:SetActive(true);
    self.baseChipGroup.gameObject:SetActive(false);
    self.ReRollContent.gameObject:SetActive(false);
    FXGZEntry.MaxChipBtn.interactable = false;
    self.openChipBtn.interactable = false;
    --TODO 发送开始消息,等待结果开始转动
    FXGZ_Network.StartGame();
end
function FXGZEntry.ClickMenuCall()
    self.menulist.gameObject:SetActive(true);
end
function FXGZEntry.OpenSettingPanel()
    --点击显示菜单
    FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.BTN);
    self.menulist.gameObject:SetActive(false);
    self.settingPanel.gameObject:SetActive(true);
    local settingCloseBtn = self.settingPanel:Find("Setting/Close"):GetComponent("Button");
    settingCloseBtn.onClick:RemoveAllListeners();
    settingCloseBtn.onClick:AddListener(function()
        FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.BTN);
        self.settingPanel.gameObject:SetActive(false);
    end);
    local musicprogress = self.settingPanel:Find("Setting/Music"):GetComponent("Slider");
    local soundprogress = self.settingPanel:Find("Setting/Sound"):GetComponent("Slider");
    --if not PlayerPrefs.HasKey("MusicValue") then
    --    PlayerPrefs.SetString("MusicValue", "1");
    --end
    --if not PlayerPrefs.HasKey("SoundValue") then
    --    PlayerPrefs.SetString("SoundValue", "1");
    --end
    --local musicvalue = tonumber(PlayerPrefs.GetString("MusicValue"));
    --local soundvalue = tonumber(PlayerPrefs.GetString("SoundValue"));
    --if AllSetGameInfo._5IsPlayAudio then
    --    musicprogress.value = musicvalue;
    --else
    --    musicprogress.value = 0;
    --end
    --
    --if AllSetGameInfo._6IsPlayEffect then
    --    soundprogress.value = soundvalue;
    --else
    --    soundprogress.value = 0;
    --end
    musicprogress.value = MusicManager:GetMusicVolume();
    soundprogress.value = MusicManager:GetSoundVolume();
    self.luaBehaviour:AddSliderEvent(musicprogress.gameObject, function(value)
        --PlayerPrefs.SetString("MusicValue", tostring(value));
        --if value <= 0 then
        --    AllSetGameInfo._5IsPlayAudio = false;
        --else
        --    AllSetGameInfo._5IsPlayAudio = true;
        --end
        --Util.Write("IsPlayAudio", tostring(AllSetGameInfo._5IsPlayAudio));
        --PlayerPrefs.SetString("IsPlayAudio", tostring(AllSetGameInfo._5IsPlayAudio));
        --FXGZ_Audio.pool.volume = value;
        --FXGZ_Audio.pool.mute = not AllSetGameInfo._5IsPlayAudio;
        --GameManager.SetIsPlayMute(AllSetGameInfo._6IsPlayEffect, AllSetGameInfo._5IsPlayAudio);

        MusicManager:SetValue(MusicManager:GetSoundVolume(),value);
        FXGZ_Audio.pool.volume = value;
        MusicManager:SetMusicMute(value <= 0);
        FXGZ_Audio.pool.mute = not MusicManager:GetIsPlayMV();
    end);
    self.luaBehaviour:AddSliderEvent(soundprogress.gameObject, function(value)
        --PlayerPrefs.SetString("SoundValue", tostring(value));
        --if value <= 0 then
        --    AllSetGameInfo._6IsPlayEffect = false;
        --else
        --    AllSetGameInfo._6IsPlayEffect = true;
        --end
        --Util.Write("isCanPlaySound", tostring(AllSetGameInfo._6IsPlayEffect));
        --PlayerPrefs.SetString("isCanPlaySound", tostring(AllSetGameInfo._6IsPlayEffect));
        --GameManager.SetIsPlayMute(AllSetGameInfo._6IsPlayEffect, AllSetGameInfo._5IsPlayAudio);
        MusicManager:SetValue(value,MusicManager:GetMusicVolume());
        MusicManager:SetSoundMute(value <= 0);
    end);
end
function FXGZEntry.ResetState()
    self.AutoContent.gameObject:SetActive(false);
    self.FreeContent.gameObject:SetActive(false);
    self.startState.gameObject:SetActive(true);
    self.stopState.gameObject:SetActive(false);
    self.addBei.gameObject:SetActive(false);
    self.chipGroup.gameObject:SetActive(true);
    self.ReRollContent.gameObject:SetActive(false);
    self.baseChipGroup.gameObject:SetActive(false);
    FXGZEntry.MaxChipBtn.interactable = true;
    self.openChipBtn.interactable = true;
    self.startState.interactable = true;
    self.isAutoGame = false;
end
function FXGZEntry.CloseMenuCall()
    --关闭菜单
    FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.BTN);
    self.menulist.gameObject:SetActive(false);
end
function FXGZEntry.CloseGameCall()
    self.menulist.gameObject:SetActive(false);
    self.quitPanel.gameObject:SetActive(true);
    local backHallBtn = self.quitPanel:Find("Content/QuitBtn"):GetComponent("Button");
    local closeBtn = self.quitPanel:Find("Content/CancelBtn"):GetComponent("Button");
    local closebtn1 = self.quitPanel:Find("Content/Close"):GetComponent("Button");
    backHallBtn.onClick:RemoveAllListeners();
    backHallBtn.onClick:AddListener(function()
        if not self.isFreeGame and not self.isSmallGame and not self.isReRollGame then
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

function FXGZEntry.OnClickAutoCall()
    --点击自动开始
    FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.BTN);
    if self.isAutoGame or self.isFreeGame then
        return ;
    end
    self.CancelAutobtn.gameObject:SetActive(true);
    self.startState.gameObject:SetActive(false);
    self.stopState.gameObject:SetActive(false);
    self.FreeContent.gameObject:SetActive(false);
    self.closeAutoMenu.gameObject:SetActive(true);
end
function FXGZEntry.OnClickAutoStartCall()
    --点击选择自动次数
    if self.isAutoGame then
        self.StopAutoGame();
        return ;
    end
    self.AutoStartCall();
end
function FXGZEntry.AutoStartCall()
    FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.BTN);
    if self.isAutoGame then
        self.StopAutoGame();
        return ;
    end
    self.closeAutoMenu.gameObject:SetActive(true);
end
function FXGZEntry.OnClickAutoItemCall()
    --点击选择自动次数
    FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.BTN);
    self.isAutoGame = true;
    self.closeAutoMenu.gameObject:SetActive(false);
    self.CancelAutobtn.gameObject:SetActive(false);
    if not self.isFreeGame then
        self.AutoContent.gameObject:SetActive(true);
        self.FreeContent.gameObject:SetActive(false);
        self.startState.gameObject:SetActive(false);
        self.startState.interactable = false;
        self.stopState.gameObject:SetActive(false);
        self.addBei.gameObject:SetActive(false);
        self.chipGroup.gameObject:SetActive(true);
        self.baseChipGroup.gameObject:SetActive(false);
        self.ReRollContent.gameObject:SetActive(false);
    end
    self.MaxChipBtn.interactable = false;
    self.openChipBtn.interactable = false;
    if self.currentAutoCount > 1000 then
        self.autoText.gameObject:SetActive(false);
        self.autoInfinite.gameObject:SetActive(true);
    else
        self.autoText.gameObject:SetActive(true);
        self.autoInfinite.gameObject:SetActive(false);
        self.autoText.text = tostring(self.currentAutoCount);
    end
    if not self.isRoll and not self.isFreeGame then
        --没有转动的状态开始自动旋转
        FXGZ_Network.StartGame();
    end
end
function FXGZEntry.ShowRultPanel()
    --显示规则
    FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.BTN);
    FXGZ_Rule.ShowRule();
end
function FXGZEntry.SetMaxChipCall()
    --设置最大下注
    FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.BTN);
    self.CurrentChipIndex = self.SceneData.chipNum;
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = ShortNumber(self.CurrentChip * FXGZ_DataConfig.ALLLINECOUNT);
end

function FXGZEntry.CSJLRoll()
    FXGZ_Network.StartGame();
end
function FXGZEntry.StopAutoGame()
    --停止自动旋转
    self.isAutoGame = false;
    self.currentAutoCount = 0;
    self.AutoContent.gameObject:SetActive(false);
    self.FreeContent.gameObject:SetActive(false);
    self.startState.gameObject:SetActive(true);
    self.stopState.gameObject:SetActive(false);
    self.addBei.gameObject:SetActive(false);
    self.chipGroup.gameObject:SetActive(true);
    self.baseChipGroup.gameObject:SetActive(false);
    self.ReRollContent.gameObject:SetActive(false);
end
function FXGZEntry.FreeGame()
    --免费游戏
    if self.isReRollGame then
        self.ReRollNum.text = tostring(self.freeCount);
    else
        self.freeText.text = tostring(self.freeCount);
    end
    FXGZ_Network.StartGame();
end
function FXGZEntry.Roll()
    --开始转动    
    if not self.isFreeGame then
        self.myGold = self.myGold - self.CurrentChip * FXGZ_DataConfig.ALLLINECOUNT;
        FXGZEntry.SetSelfGold(self.myGold);
    end
    if self.isFreeGame then
        self.WinNum.text = ShortNumber(FXGZ_Result.totalFreeGold);
    else
        self.WinNum.text = ShortNumber(0);
    end
    local index = math.random(1, #FXGZ_DataConfig.WinConfig);
    FXGZEntry.WinDesc.text = FXGZ_DataConfig.WinConfig[index];
    FXGZ_Result.HideResult();
    FXGZ_Line.Close();
    FXGZ_Roll.StartRoll();
end
function FXGZEntry.OnStop()
    --停止转动
    log("停止")
    FXGZ_Result.ShowResult();
end
function FXGZEntry.GetCustomK(num)
    local n = tonumber(num) / 1000;
    return tostring(n) .. "K";
end
function FXGZEntry.InitPanel()
    --场景消息初始化
    self.myGold = TableUserInfo._7wGold;
    FXGZEntry.SetSelfGold(self.myGold);
    self.freeCount = 0;
    local chipGroup = self.chiplistBtn.transform:Find("Group");
    for i = 1, chipGroup.childCount do
        chipGroup:GetChild(i - 1).gameObject:SetActive(false);
    end
    for i = 1, self.SceneData.chipNum do
        if self.SceneData.chipList[i] == self.SceneData.bet then
            self.CurrentChipIndex = i;
        end
    end
    if self.SceneData.freeNumber <= 0 then
        self.CurrentChipIndex = CheckNear(self.myGold,self.SceneData.chipList)
    end
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.CurrentChip * FXGZ_DataConfig.ALLLINECOUNT);
    for i = 1, self.SceneData.chipNum do
        local tog = chipGroup:GetChild(i - 1):GetComponent("Toggle");
        local num = tog.transform:Find("Num"):GetComponent("TextMeshProUGUI");
        num.text = ShortNumber(self.SceneData.chipList[i] * FXGZ_DataConfig.ALLLINECOUNT);
        tog.gameObject.name = tostring(self.SceneData.chipList[i]);
        if self.SceneData.chipList[i] == self.CurrentChip then
            tog.isOn = true;
        else
            tog.isOn = false;
        end
        tog.onValueChanged:RemoveAllListeners();
        tog.onValueChanged:AddListener(function(value)
            if value then
                FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.BTN);
                self.CurrentChip = tonumber(tog.gameObject.name);
                self.ChipNum.text = ShortNumber(self.CurrentChip * FXGZ_DataConfig.ALLLINECOUNT);
                self.chiplistBtn.gameObject:SetActive(false);
            end
        end);
        tog.gameObject:SetActive(true);
    end
    self.WinNum.text = ShortNumber(0);
    --FXGZ_Caijin.isCanSend = true;
    self.isRoll = false;
    self.isSmallGame = false;
    self.isFreeGame = false;
    self.isAutoGame = false;
    FXGZ_Line.Init();
    FXGZ_Result.Init();
    if self.SceneData.cbCurMul > 0 then
        if self.SceneData.freeNumber > 0 then
            self.isFreeGame = true;
            self.freeCount = self.SceneData.freeNumber;
            self.AutoContent.gameObject:SetActive(false);
            self.FreeContent.gameObject:SetActive(true);
            self.startState.gameObject:SetActive(false);
            self.stopState.gameObject:SetActive(false);
            self.ReRollContent.gameObject:SetActive(false);
            if self.SceneData.cbFreeType == 0 then
                --重转
                FXGZ_Result.ShowReRollEffect();
            else
                --免费;
                FXGZ_Result.ShowFreeEffect(true);
            end
            FXGZ_Result.totalFreeGold = 0
        else
            FXGZ_Result.ShowEnterSmallGameEffect(true);
        end
    else
        if self.SceneData.freeNumber > 0 then
            self.isFreeGame = true;
            self.freeCount = self.SceneData.freeNumber;
            self.AutoContent.gameObject:SetActive(false);
            self.FreeContent.gameObject:SetActive(true);
            self.startState.gameObject:SetActive(false);
            self.stopState.gameObject:SetActive(false);
            self.ReRollContent.gameObject:SetActive(false);
            if self.SceneData.cbFreeType == 0 then
                --重转
                FXGZ_Result.ShowReRollEffect();
            else
                --免费;
                FXGZ_Result.ShowFreeEffect(true);
            end
            FXGZ_Result.totalFreeGold = 0
        else
            self.AutoContent.gameObject:SetActive(false);
            self.FreeContent.gameObject:SetActive(false);
            self.startState.gameObject:SetActive(true);
            self.stopState.gameObject:SetActive(false);
            self.addBei.gameObject:SetActive(false);
            self.chipGroup.gameObject:SetActive(true);
            self.baseChipGroup.gameObject:SetActive(false);
            self.ReRollContent.gameObject:SetActive(false);
            FXGZEntry.startBtn.interactable = true;
        end
    end
end
function FXGZEntry.FreeRoll()
    --判断是否为免费游戏
    FXGZ_Result.isShow = false;
    if self.isFreeGame then
        self.freeCount = self.freeCount - 1;
        self.currentFreeCount = self.currentFreeCount + 1;
        --还有免费次数
        log("继续免费")
        self.FreeGame();
    else
        self.AutoRoll();
    end
end
function FXGZEntry.AutoRoll()
    --判断是否为自动游戏
    if self.isAutoGame then
        --如果是自动游戏
        if self.currentAutoCount < 1000 then
            self.currentAutoCount = self.currentAutoCount - 1;
        end
        if self.currentAutoCount < 0 then
            --自动次数使用完了，回到待机状态
            self.AutoContent.gameObject:SetActive(false);
            self.FreeContent.gameObject:SetActive(false);
            self.startState.gameObject:SetActive(true);
            self.stopState.gameObject:SetActive(false);
            self.addBei.gameObject:SetActive(false);
            self.chipGroup.gameObject:SetActive(true);
            self.baseChipGroup.gameObject:SetActive(false);
            self.ReRollContent.gameObject:SetActive(false);
            FXGZEntry.MaxChipBtn.interactable = true;
            self.openChipBtn.interactable = true;
            self.startState.interactable = true;
            self.StopAutoGame();
        else
            --还有自动次数
            self.OnClickAutoItemCall();
        end
    else
        --不是自动游戏，直接待机
        self.AutoContent.gameObject:SetActive(false);
        self.FreeContent.gameObject:SetActive(false);
        self.startState.gameObject:SetActive(true);
        self.stopState.gameObject:SetActive(false);
        self.addBei.gameObject:SetActive(false);
        self.chipGroup.gameObject:SetActive(true);
        self.baseChipGroup.gameObject:SetActive(false);
        self.ReRollContent.gameObject:SetActive(false);
        FXGZEntry.MaxChipBtn.interactable = true;
        self.openChipBtn.interactable = true;
        self.startState.interactable = true;
        self.StopAutoGame();
    end
end