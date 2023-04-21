-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion
local g_sWSZSModuleNum = "Module49/wszs/";

require(g_sWSZSModuleNum .. "WSZS_Network")
require(g_sWSZSModuleNum .. "WSZS_Roll")
require(g_sWSZSModuleNum .. "WSZS_DataConfig")
require(g_sWSZSModuleNum .. "WSZS_Caijin")
require(g_sWSZSModuleNum .. "WSZS_Line")
require(g_sWSZSModuleNum .. "WSZS_Result")
require(g_sWSZSModuleNum .. "WSZS_Rule")
require(g_sWSZSModuleNum .. "WSZS_Audio")
require(g_sWSZSModuleNum .. "WSZS_Free")

WSZSEntry = {};
local self = WSZSEntry;
self.transform = nil;
self.gameObject = nil;

self.luaBehaviour = nil;
self.CurrentChip = 0;
self.CurrentChipIndex = 0;
self.isAutoGame = false;
self.isFreeGame = false;
self.isRoll = false;
self.menuTweener = nil;

self.currentFreeCount = 0;

self.clickStartTimer = -1;
self.currentAutoCount = 0;--剩余自动次数
self.freeCount = 0;--剩余免费次数

self.myGold = 0;--显示的自身金币

self.SceneData = {
    bet = 0, --当前下注
    chipCount = 0, --用户金币
    chipList = {}, --下注列表
    freeNumber = 0, --免费次数
    mianjuCount = {}--面具个数
};
self.ResultData = {
    ImgTable = {}, --图标
    LineTypeTable = {}, --连线类型
    WinScore = 0, --赢得总分
    ShiGold = 0, --斩杀得分
    FreeCount = 0, --免费次数
    mianjuCount = {}, --面具个数
}
function WSZSEntry:Awake(obj)
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
    WSZS_Roll.Init(self.RollContent);
    WSZS_Audio.Init();
    WSZS_Rule.Init();
    WSZS_Network.AddMessage();--添加消息监听
    WSZS_Network.LoginGame();--开始登录游戏
    GameSetsPanel.CreateHideObj(self.MainContent, false);
    WSZS_Audio.PlayBGM();
end
function WSZSEntry.OnDestroy()
    WSZS_Line.Close();
    WSZS_Network.UnMessage();
end
function WSZSEntry:Update()
    WSZS_Roll.Update();
    --WSZS_Caijin.Update();
    self.CanShowAuto();
    WSZS_Line.Update();
    WSZS_Result.Update();
end

function WSZSEntry.CanShowAuto()
    if self.clickStartTimer >= 0 and not self.isAutoGame then
        self.clickStartTimer = self.clickStartTimer + Time.deltaTime;
        if self.clickStartTimer >= 0.5 and not self.isPlayAudio and self.clickStartTimer < 2 then
            self.isPlayAudio = true;
            self.autoEffect.gameObject:SetActive(true);
            WSZS_Audio.PlaySound(WSZS_Audio.SoundList.LongPress);
        end
        if self.clickStartTimer >= 2.5 then
            self.clickStartTimer = -1;
            self.isPlayAudio = false;
            --WSZS_Audio.ClearAuido(WSZS_Audio.SoundList.LongPress);
            self.autoEffect.gameObject:SetActive(false);
            self.OnClickAutoCall();
        end
    end
end
function WSZSEntry.FindComponent()
    self.MainContent = self.transform:Find("MainPanel");

    self.normalBackground = self.MainContent:Find("Content/Background/RollBackground").gameObject;

    self.RollContent = self.normalBackground.transform:Find("RollContent");--转动区域
    self.IconContainer = self.MainContent.transform:Find("Content/Background/IconContainer");
    self.ScoreContainer = self.MainContent.transform:Find("Content/Background/ScoreContainer");
    self.userInfo = self.MainContent:Find("Content/Bottom/UserInfo");
    self.userName = self.userInfo:Find("UserName"):GetComponent("Text");
    self.userHead = self.userInfo:Find("Mask/Head"):GetComponent("Image");
    self.selfGold = self.MainContent:Find("Content/Bottom/Gold/Num"):GetComponent("TextMeshProUGUI");--自身金币
    self.openChipBtn = self.MainContent:Find("Content/Bottom/Chip/OpenChip"):GetComponent("Button");
    self.chiplistBtn = self.MainContent:Find("Content/Bottom/Chip/Mask"):GetComponent("Button");
    self.ChipNum = self.MainContent:Find("Content/Bottom/Chip/Num"):GetComponent("TextMeshProUGUI");--下注金额
    self.WinDesc = self.MainContent:Find("Content/Bottom/Win/WinDesc"):GetComponent("TextMeshProUGUI");--本次获得金币
    self.WinNum = self.MainContent:Find("Content/Bottom/Win/Num"):GetComponent("TextMeshProUGUI");--本次获得金币
    self.showRuleBtn = self.MainContent:Find("Content/RuleBtn"):GetComponent("Button");--规则
    self.WinDesc.text = "Start to win rewards";

    --self.reduceChipBtn = self.MainContent:Find("Content/Bottom/Chip/Reduce"):GetComponent("Button");--减注
    --self.addChipBtn = self.MainContent:Find("Content/Bottom/Chip/Add"):GetComponent("Button");--加注

    self.btnGroup = self.MainContent:Find("Content/ButtonGroup");
    self.startBtn = self.btnGroup:Find("StartBtn"):GetComponent("Button");--开始按钮
    self.startState = self.startBtn.transform:Find("Start")
    self.FreeContent = self.startBtn.transform:Find("Free");--免费状态
    self.freeText = self.FreeContent.transform:Find("Num"):GetComponent("TextMeshProUGUI");--免费次数

    self.autoEffect = self.startBtn.transform:Find("AutoEffect");
    self.AutoContent = self.startBtn.transform:Find("AutoState");
    self.autoText = self.AutoContent.transform:Find("AutoNum"):GetComponent("TextMeshProUGUI");--自动次数
    self.autoInfinite = self.AutoContent.transform:Find("Infinite")--无限次数
    self.stopState = self.startBtn.transform:Find("Stop");

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
    self.backgroundBtn = self.menulist:Find("CloseMenu"):GetComponent("Button");
    self.closeGame = self.menulist:Find("Content/Back"):GetComponent("Button");
    self.settingBtn = self.menulist:Find("Content/Setting"):GetComponent("Button");
    self.musicSet = self.settingPanel:Find("Content/Music"):GetComponent("Slider");
    self.soundSet = self.settingPanel:Find("Content/Sound"):GetComponent("Slider");
    self.closeSet = self.settingPanel:Find("bg"):GetComponent("Button");

    self.resultEffect = self.MainContent:Find("Content/Result");--中奖后特效
    self.NormalWinEffect = self.resultEffect:Find("NormalWin");
    self.normalWinNum = self.NormalWinEffect:Find("Num"):GetComponent("TextMeshProUGUI");
    self.normalWinGoldContent = self.NormalWinEffect:Find("Gold");
    self.bigWinEffect = self.resultEffect:Find("BigWin");
    self.bigWinProgress = self.bigWinEffect:Find("center/Slider"):GetComponent("Image");
    self.bigWinImg = self.bigWinEffect:Find("center/Big").gameObject;
    self.superWinImg = self.bigWinEffect:Find("center/Super").gameObject;
    self.megaWinImg = self.bigWinEffect:Find("center/Mega").gameObject;
    self.bigWinNum = self.bigWinEffect:Find("Num"):GetComponent("TextMeshProUGUI");
    self.EnterFreeEffect = self.resultEffect:Find("EnterFree");
    self.FreeWinResultEffect = self.resultEffect:Find("Victory");
    self.FreeWinResultNum = self.FreeWinResultEffect:Find("Num"):GetComponent("TextMeshProUGUI");
    self.FreeLoseResultEffect = self.resultEffect:Find("Failure");
    self.FreeLoseResultNum = self.FreeLoseResultEffect:Find("Num"):GetComponent("TextMeshProUGUI");
    self.StartKilEffect = self.resultEffect:Find("Kill");
    self.CollectGoldEffect = self.resultEffect:Find("CollectGold");

    self.icons = self.MainContent:Find("Content/Icons");--图标库
    self.effectList = self.MainContent:Find("Content/EffectList");--动画库
    self.effectPool = self.MainContent:Find("Content/EffectPool");--动画缓存库
    self.CSGroup = self.normalBackground.transform:Find("CSContent");--显示财神


    for i = 1, WSZSEntry.CSGroup.childCount do
        local yw = WSZSEntry.CSGroup:GetChild(i - 1):Find("YW");
        if yw ~= nil then
            yw.gameObject:SetActive(false);
        end
        local add = WSZSEntry.CSGroup:GetChild(i - 1):Find("AddSpeed");
        if add ~= nil then
            add.gameObject:SetActive(false);
        end
    end

    self.soundList = self.MainContent:Find("Content/SoundList");--声音库

    self.tipPanel = self.MainContent:Find("Content/TipsPool"):GetComponent("CanvasGroup");
    self.tipPanel.alpha = 0;
    self.quitPanel = self.MainContent:Find("Content/QuitPanel");
    --if not AllSetGameInfo._5IsPlayAudio then
    --    self.musicSet.value = 0;
    --else
    --    if PlayerPrefs.HasKey("MusicValue") then
    --        local musicVol = PlayerPrefs.GetString("MusicValue");
    --        self.musicSet.value = tonumber(musicVol);
    --    else
    --        self.musicSet.value = 1;
    --    end
    --end
    --if not AllSetGameInfo._6IsPlayEffect then
    --    self.soundSet.value = 0;
    --else
    --    if PlayerPrefs.HasKey("SoundValue") then
    --        local soundVol = PlayerPrefs.GetString("SoundValue");
    --        self.soundSet.value = tonumber(soundVol);
    --    else
    --        self.soundSet.value = 1;
    --    end
    --end
    self.musicSet.value = MusicManager:GetMusicVolume();
    self.soundSet.value = MusicManager:GetSoundVolume();
end
function WSZSEntry.AddListener()
    --添加监听事件
    self.startBtn.onClick:RemoveAllListeners();
    self.startBtn.onClick:AddListener(self.StartGameCall);

    local et = self.startBtn.gameObject:AddComponent(typeof(LuaFramework.EventTriggerListener));
    et.onDown = self.OnDownStartBtnCall;
    et.onUp = self.OnUpStartBtnCall;

    self.closeGame.onClick:RemoveAllListeners();
    self.closeGame.onClick:AddListener(self.CloseGameCall);

    self.openChipBtn.onClick:RemoveAllListeners();
    self.openChipBtn.onClick:AddListener(function()
        WSZS_Audio.PlaySound(WSZS_Audio.SoundList.BTN);
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
        WSZS_Audio.PlaySound(WSZS_Audio.SoundList.BTN);
        self.chiplistBtn.gameObject:SetActive(false);
    end);
    self.settingBtn.onClick:RemoveAllListeners();
    self.settingBtn.onClick:AddListener(self.OpenSettingPanel);
    self.showRuleBtn.onClick:RemoveAllListeners();--显示规则
    self.showRuleBtn.onClick:AddListener(self.ShowRultPanel);

    self.backgroundBtn.onClick:RemoveAllListeners();
    self.backgroundBtn.onClick:AddListener(self.CloseMenuCall);

    self.menuBtn.onClick:RemoveAllListeners();
    self.menuBtn.onClick:AddListener(self.ClickMenuCall);

    self.closeSet.onClick:RemoveAllListeners();
    self.closeSet.onClick:AddListener(function()
        WSZS_Audio.PlaySound(WSZS_Audio.SoundList.BTN);
        self.settingPanel.gameObject:SetActive(false);
    end);
    self.closeAutoMenu.onClick:RemoveAllListeners();--关闭自动
    self.closeAutoMenu.onClick:AddListener(function()
        self.closeAutoMenu.gameObject:SetActive(false);
    end)
    self.MaxChipBtn.onClick:RemoveAllListeners();
    self.MaxChipBtn.onClick:AddListener(self.SetMaxChipCall);

    for i = 1, #WSZS_DataConfig.autoList do
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
        if WSZS_DataConfig.autoList[i] > 1000 then
            child:Find("Infinite").gameObject:SetActive(true);
            child:Find("Num").gameObject:SetActive(false);
        else
            child:Find("Infinite").gameObject:SetActive(false);
            child:Find("Num").gameObject:SetActive(true);
            child:Find("Num"):GetComponent("TextMeshProUGUI").text = tostring(WSZS_DataConfig.autoList[i]);
        end
        child.gameObject.name = tostring(WSZS_DataConfig.autoList[i]);
        child:GetComponent("Button").onClick:RemoveAllListeners();
        child:GetComponent("Button").onClick:AddListener(function()
            self.currentAutoCount = WSZS_DataConfig.autoList[i];
            self.OnClickAutoItemCall();
        end)
        child.gameObject:SetActive(true);
    end
end
function WSZSEntry.GetGameConfig()
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
        WSZS_DataConfig.rollTime = data.rollTime;
        WSZS_DataConfig.rollReboundRate = data.rollReboundRate;
        WSZS_DataConfig.rollInterval = data.rollInterval;
        WSZS_DataConfig.rollSpeed = data.rollSpeed;
        WSZS_DataConfig.caijinGoldChangeRate = data.caijinGoldChangeRate;
        WSZS_DataConfig.winGoldChangeRate = data.winGoldChangeRate;
        WSZS_DataConfig.selfGoldChangeRate = data.selfGoldChangeRate;
        WSZS_DataConfig.freeLoadingShowTime = data.freeLoadingShowTime;
        WSZS_DataConfig.smallGameLoadingShowTime = data.smallGameLoadingShowTime;
        WSZS_DataConfig.rollDistance = data.rollDistance;
        WSZS_DataConfig.REQCaiJinTime = data.REQCaiJinTime;
        WSZS_DataConfig.lineAllShowTime = data.lineAllShowTime;
        WSZS_DataConfig.cyclePlayLineTime = data.cyclePlayLineTime;
        WSZS_DataConfig.waitShowLineTime = data.waitShowLineTime;
        WSZS_DataConfig.autoRewardInterval = data.autoRewardInterval;
        WSZS_DataConfig.autoNoRewardInterval = data.autoNoRewardInterval;
    end);
end
function WSZSEntry.ToCharArray(num)
    --拆解字符串
    local str = tostring(num);
    local list1 = {}
    for i = 1, string.len(str) do
        table.insert(list1, #list1 + 1, string.sub(str, i, i));
    end
    return list1;
end
function WSZSEntry.FormatNumberThousands(num)
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
function WSZSEntry.SetSelfGold(str)
    self.selfGold.text = ShortNumber(str);
end
function WSZSEntry.ShowText(str)
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
function WSZSEntry.ReduceChipCall()
    --减注
    WSZS_Audio.PlaySound(WSZS_Audio.SoundList.REDUCEBET);
    if self.SceneData.chipList == nil or #self.SceneData.chipList <= 0 then
        return ;
    end
    self.CurrentChipIndex = self.CurrentChipIndex - 1;
    if self.CurrentChipIndex <= 0 then
        self.CurrentChipIndex = #self.SceneData.chipList;
    end
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.CurrentChip * WSZS_DataConfig.ALLLINECOUNT);
end
function WSZSEntry.AddChipCall()
    --加注
    WSZS_Audio.PlaySound(WSZS_Audio.SoundList.ADDBET);
    if self.SceneData.chipList == nil or #self.SceneData.chipList <= 0 then
        return ;
    end
    self.CurrentChipIndex = self.CurrentChipIndex + 1;
    if self.CurrentChipIndex > #self.SceneData.chipList then
        self.CurrentChipIndex = 1;
    end
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.CurrentChip * WSZS_DataConfig.ALLLINECOUNT);
end

function WSZSEntry.OnDownStartBtnCall()
    if self.isFreeGame then
        return ;
    end
    self.clickStartTimer = 0;
    self.isPlayAudio = false;
end

function WSZSEntry.OnUpStartBtnCall()
    if self.clickStartTimer < 2 and self.clickStartTimer ~= -1 then
        self.clickStartTimer = -1;
        self.isPlayAudio = false;
        self.autoEffect.gameObject:SetActive(false);
        WSZS_Audio.ClearAuido(WSZS_Audio.SoundList.LongPress);
    end
end
function WSZSEntry.StartGameCall()
    --开始游戏
    if self.isFreeGame then
        return ;
    end
    if self.isAutoGame then
        self.StopAutoGame();
        return ;
    end
    if self.isRoll then
        --TODO 急停
        if WSZS_Network.isGetResult then
            self.startState.gameObject:SetActive(true);
            self.stopState.gameObject:SetActive(false);
            WSZS_Roll.StopRoll();
        else
            --MessageBox.CreatGeneralTipsPanel("操作太频繁了!");
        end
        return ;
    end
    WSZS_Audio.PlaySound(WSZS_Audio.SoundList.BTN1);
    self.chiplistBtn.gameObject:SetActive(false);
    if self.myGold < self.CurrentChip * WSZS_DataConfig.ALLLINECOUNT then
        MessageBox.CreatGeneralTipsPanel("Not enough gold!")
        self.ResetState();
        --if self.CurrentChipIndex <= 1 then
        --    MessageBox.CreatGeneralTipsPanel("Not enough gold当前押注!")
        --    self.ResetState();
        --    return ;
        --else
        --    if self.myGold < self.SceneData.chipList[1] * WSZS_DataConfig.ALLLINECOUNT then
        --        MessageBox.CreatGeneralTipsPanel("金币不足当前押注!")
        --        self.ResetState();
        --        return ;
        --    end
        --    local current = self.CurrentChipIndex;
        --    local isfind = false;
        --    for i = current, 1, -1 do
        --        if self.myGold >= self.SceneData.chipList[i] * WSZS_DataConfig.ALLLINECOUNT then
        --            if not isfind then
        --                isfind = true;
        --                self.CurrentChipIndex = i;
        --                self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
        --                self.tipPanel.alpha = 0;
        --                self.tipPanel:DOFade(0, 1):SetDelay(1):SetEase(DG.Tweening.Ease.Linear);
        --            end
        --        end
        --    end
        --    self.ChipNum.text = self.ShowText(self.CurrentChip * WSZS_DataConfig.ALLLINECOUNT);
        --    return;
        --end
        return;
    end
    WSZSEntry.openChipBtn.interactable = false;
    WSZSEntry.MaxChipBtn.interactable = false;
    self.startState.gameObject:SetActive(false);
    self.stopState.gameObject:SetActive(true);
    --TODO 发送开始消息,等待结果开始转动
    WSZS_Network.isGetResult = false;
    WSZS_Network.StartGame();
end
function WSZSEntry.ClickMenuCall()
    --点击显示菜单
    WSZS_Audio.PlaySound(WSZS_Audio.SoundList.BTN);
    self.backgroundBtn.gameObject:SetActive(true);
    self.menulist.gameObject:SetActive(true);
end
function WSZSEntry.CloseMenuCall()
    --关闭菜单
    WSZS_Audio.PlaySound(WSZS_Audio.SoundList.BTN);
    self.backgroundBtn.gameObject:SetActive(false);
    self.menulist.gameObject:SetActive(false);
end
function WSZSEntry.CloseGameCall()
    self.quitPanel.gameObject:SetActive(true);
    self.menulist.gameObject:SetActive(false);
    local backHallBtn = self.quitPanel:Find("Content/QuitBtn"):GetComponent("Button");
    local closeBtn = self.quitPanel:Find("Content/CanceBtn"):GetComponent("Button");
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
end
function WSZSEntry.SetSoundCall()
    if AllSetGameInfo._5IsPlayAudio or AllSetGameInfo._6IsPlayEffect then
        SetInfoSystem.GameMute();
        self.soundOn:SetActive(false);
        self.soundOff:SetActive(true);
    else
        SetInfoSystem.ResetMute();
        self.soundOn:SetActive(true);
        self.soundOff:SetActive(false);
    end
    WSZS_Audio.pool.mute = not AllSetGameInfo._5IsPlayAudio;
end
function WSZSEntry.OpenSettingPanel()
    WSZS_Audio.PlaySound(WSZS_Audio.SoundList.BTN);
    self.menulist.gameObject:SetActive(false);
    self.settingPanel.gameObject:SetActive(true);
    local musicprogress = self.settingPanel:Find("Content/Music"):GetComponent("Slider");
    local soundprogress = self.settingPanel:Find("Content/Sound"):GetComponent("Slider");
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
        --WSZS_Audio.pool.volume = value;
        --WSZS_Audio.pool.mute = not AllSetGameInfo._5IsPlayAudio;
        --GameManager.SetIsPlayMute(AllSetGameInfo._6IsPlayEffect, AllSetGameInfo._5IsPlayAudio);
        MusicManager:SetValue(MusicManager:GetSoundVolume(),value);
        WSZS_Audio.pool.volume = value;
        MusicManager:SetMusicMute(value <= 0);
        WSZS_Audio.pool.mute = not MusicManager:GetIsPlayMV();
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
function WSZSEntry.OnClickAutoCall()
    --点击自动开始
    if self.isAutoGame then
        return ;
    end
    self.closeAutoMenu.gameObject:SetActive(true);
end
function WSZSEntry.OnClickAutoItemCall()
    --点击选择自动次数
    WSZS_Audio.PlaySound(WSZS_Audio.SoundList.BTN);
    self.isAutoGame = true;
    self.ispress = false;
    WSZSEntry.startState.gameObject:SetActive(false);
    WSZSEntry.stopState.gameObject:SetActive(false);
    self.chiplistBtn.gameObject:SetActive(false);
    self.closeAutoMenu.gameObject:SetActive(false);
    WSZSEntry.openChipBtn.interactable = false;
    WSZSEntry.MaxChipBtn.interactable = false;
    if self.isFreeGame then
        self.FreeContent.gameObject:SetActive(true);
        self.AutoContent.gameObject:SetActive(false);
    else
        if self.myGold < self.CurrentChip * WSZS_DataConfig.ALLLINECOUNT then
            MessageBox.CreatGeneralTipsPanel("Not enough gold!")
            self.ResetState();
            return ;
            --if self.CurrentChipIndex <= 1 then
            --    MessageBox.CreatGeneralTipsPanel("Not enough gold!")
            --    self.ResetState();
            --    return ;
            --else
            --    if self.myGold < self.SceneData.chipList[1] * WSZS_DataConfig.ALLLINECOUNT then
            --        MessageBox.CreatGeneralTipsPanel("Not enough gold!")
            --        self.ResetState();
            --        return ;
            --    end
            --    local current = self.CurrentChipIndex;
            --    local isfind = false;
            --    for i = current, 1, -1 do
            --        if self.myGold >= self.SceneData.chipList[i] * WSZS_DataConfig.ALLLINECOUNT then
            --            if not isfind then
            --                isfind = true;
            --                self.CurrentChipIndex = i;
            --                self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
            --                self.tipPanel.alpha = 0;
            --                self.tipPanel:DOFade(0, 1):SetDelay(1);
            --            end
            --        end
            --    end
            --    self.ChipNum.text = self.ShowText(self.CurrentChip * WSZS_DataConfig.ALLLINECOUNT);
            --    return
            --end
        end
        self.FreeContent.gameObject:SetActive(false);
        self.AutoContent.gameObject:SetActive(true);
    end
    if self.currentAutoCount > 1000 then
        self.autoText.text = "";
        self.autoInfinite.gameObject:SetActive(true);
    else
        self.autoText.text = tostring(self.currentAutoCount);
        self.autoInfinite.gameObject:SetActive(false);
    end
    if not self.isRoll and not self.isFreeGame then
        --没有转动的状态开始自动旋转
        log("开始自动游戏")
        WSZS_Network.StartGame();
    end
end
function WSZSEntry.ResetState()
    self.StopAutoGame();
    WSZSEntry.startBtn.interactable = true;
    WSZSEntry.startState.gameObject:SetActive(true);
    WSZSEntry.stopState.gameObject:SetActive(false);
end
function WSZSEntry.ShowRultPanel()
    --显示规则
    WSZS_Audio.PlaySound(WSZS_Audio.SoundList.BTN);
    WSZS_Rule.ShowRule();
end
function WSZSEntry.SetMaxChipCall()
    --设置最大下注
    WSZS_Audio.PlaySound(WSZS_Audio.SoundList.BTN);
    self.CurrentChipIndex = self.SceneData.chipCount;
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.CurrentChip * WSZS_DataConfig.ALLLINECOUNT);
end

function WSZSEntry.CSJLRoll()
    WSZS_Network.StartGame();
end
function WSZSEntry.StopAutoGame()
    --停止自动旋转
    self.isAutoGame = false;
    self.currentAutoCount = 0;
    WSZSEntry.FreeContent.gameObject:SetActive(false);
    WSZSEntry.AutoContent.gameObject:SetActive(false);
    WSZSEntry.startState.gameObject:SetActive(false);
    WSZSEntry.stopState.gameObject:SetActive(true);
    WSZSEntry.openChipBtn.interactable = not self.isRoll;
    WSZSEntry.MaxChipBtn.interactable = not self.isRoll;
end
function WSZSEntry.FreeGame()
    --免费游戏
    self.isFreeGame = true;
    log("当前免费次数:" .. self.currentFreeCount);
    self.freeText.text = ShowRichText(self.currentFreeCount);
    WSZS_Network.StartGame();
end
function WSZSEntry.Roll()
    --开始转动    
    if not self.isFreeGame then
        self.myGold = self.myGold - self.CurrentChip * WSZS_DataConfig.ALLLINECOUNT;
        WSZSEntry.SetSelfGold(self.myGold);
    end
    if self.isFreeGame then
        self.WinNum.text = self.ShowText(WSZS_Result.totalFreeGold);
    else
        self.WinNum.text = self.ShowText(0);
    end
    local index = math.random(1, #WSZS_DataConfig.WinConfig);
    WSZSEntry.WinDesc.text = WSZS_DataConfig.WinConfig[index];
    WSZS_Result.HideResult();
    WSZS_Line.Close();
    WSZS_Roll.StartRoll();
end
function WSZSEntry.OnStop()
    --停止转动
    log("停止")
    WSZS_Result.ShowResult();
end
function WSZSEntry.InitPanel()
    --场景消息初始化
    self.myGold = TableUserInfo._7wGold;
    WSZSEntry.SetSelfGold(self.myGold);
    WSZSEntry.userName.text = SCPlayerInfo._05wNickName;
    WSZSEntry.userHead.sprite = HallScenPanel.GetHeadIcon();
    local chipGroup = self.chiplistBtn.transform:Find("Group");
    for i = 1, chipGroup.childCount do
        chipGroup:GetChild(i - 1).gameObject:SetActive(false);
    end
    for i = 1, #self.SceneData.chipList do
        if self.SceneData.chipList[i] == self.SceneData.bet then
            self.CurrentChipIndex = i;
            self.CurrentChip = self.SceneData.bet;
        end
    end
    if self.SceneData.freeNumber <= 0 then
        self.CurrentChipIndex = CheckNear(self.myGold,self.SceneData.chipList)
    end
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.CurrentChip * WSZS_DataConfig.ALLLINECOUNT);
    for i = 1, self.SceneData.chipCount do
        local tog = chipGroup:GetChild(i - 1):GetComponent("Toggle");
        local num = tog.transform:Find("Num"):GetComponent("TextMeshProUGUI");
        num.text = self.ShowText(self.SceneData.chipList[i] * WSZS_DataConfig.ALLLINECOUNT);
        tog.gameObject.name = tostring(self.SceneData.chipList[i]);
        if self.SceneData.chipList[i] == self.CurrentChip then
            tog.isOn = true;
        else
            tog.isOn = false;
        end
        local index = i;
        tog.onValueChanged:RemoveAllListeners();
        tog.onValueChanged:AddListener(function(value)
            if value then
                WSZS_Audio.PlaySound(WSZS_Audio.SoundList.BTN);
                self.CurrentChip = tonumber(tog.gameObject.name);
                self.CurrentChipIndex = index;
                self.ChipNum.text = self.ShowText(self.CurrentChip * WSZS_DataConfig.ALLLINECOUNT);
            end
        end);
        tog.gameObject:SetActive(true);
    end
    self.WinNum.text = self.ShowText(0);
    --WSZS_Caijin.isCanSend = true;
    self.isRoll = false;
    WSZS_Line.Init();
    WSZS_Result.Init();
    if self.SceneData.freeNumber > 0 then
        --如果免费
        self.freeCount = self.SceneData.freeNumber;
        self.currentFreeCount = self.SceneData.freeNumber;
        self.isFreeGame = true;
        WSZS_Result.ShowFreeEffect(true);
    else
        WSZSEntry.FreeContent.gameObject:SetActive(false);
        WSZSEntry.AutoContent.gameObject:SetActive(false);
        WSZSEntry.startState.gameObject:SetActive(true);
        WSZSEntry.stopState.gameObject:SetActive(false);
    end
end
function WSZSEntry.FreeRoll()
    --判断是否为免费游戏
    WSZS_Result.isShow = false;
    if self.isFreeGame then
        self.currentFreeCount = self.currentFreeCount + 1;
        if self.freeCount < 0 then
            --免费结束
            if WSZS_Result.showFreeTweener ~= nil then
                WSZS_Result.showFreeTweener:Kill();
                WSZS_Result.showFreeTweener = nil;
            end
            self.isFreeGame = false;
            WSZSEntry.startBtn.interactable = true;
            self.AutoRoll();
        else
            --还有免费次数
            self.FreeGame();
        end
    else
        WSZSEntry.startBtn.interactable = true;
        self.AutoRoll();
    end
end
function WSZSEntry.AutoRoll()
    --判断是否为自动游戏
    if self.isAutoGame then
        --如果是自动游戏
        if self.currentAutoCount < 1000 then
            self.currentAutoCount = self.currentAutoCount - 1;
        end
        if self.currentAutoCount < 0 then
            --自动次数使用完了，回到待机状态
            self.StopAutoGame();
            WSZSEntry.startBtn.interactable = true;
            WSZSEntry.startState.gameObject:SetActive(true);
            WSZSEntry.stopState.gameObject:SetActive(false);
        else
            --还有自动次数
            self.OnClickAutoItemCall();
        end
    else
        --不是自动游戏，直接待机
        self.StopAutoGame();
        WSZSEntry.startBtn.interactable = true;
        WSZSEntry.startState.gameObject:SetActive(true);
        WSZSEntry.stopState.gameObject:SetActive(false);
    end
end