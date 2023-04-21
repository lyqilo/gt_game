-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion
local g_swlzbNum = "Module52/SESX/";

require(g_swlzbNum .. "SESX_Network")
require(g_swlzbNum .. "SESX_Roll")
require(g_swlzbNum .. "SESX_DataConfig")
require(g_swlzbNum .. "SESX_Caijin")
require(g_swlzbNum .. "SESX_Line")
require(g_swlzbNum .. "SESX_Result")
require(g_swlzbNum .. "SESX_Rule")
require(g_swlzbNum .. "SESX_Audio")
require(g_swlzbNum .. "SESX_SmallGame")

SESXEntry = {};
local self = SESXEntry;
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
self.isDouble = false;
self.menuTweener = nil;

self.currentFreeCount = 0;

self.currentAutoCount = 0;--剩余自动次数
self.freeCount = 0;--剩余免费次数
self.totalFreeCount = 0;
self.CurrentMoveLongIndex = 0;

self.myGold = 0;--显示的自身金币
self.ScatterList = {};

self.SceneData = {
    freeNumber = 0, --免费次数
    bet = 0, --当前下注
    nGainPeilv = 0,
    chipNum = 0, --用户金币
    chipList = {}, --下注列表
    m_bIsDouleWild = 0
};
self.ResultData = {
    ImgTable = {}, --图标
    LineTypeTable = {}, --连线类型
    m_nWinPeiLv = 0, --当前倍率
    m_nCurrGold = 0, --自身金币
    WinScore = 0, --赢得总分
    FreeCount = 0, --免费次数
    m_nPrizePoolGold = 0,
    m_nPrizePoolWildGold = 0,
    m_bIsDoubleLong = false, --是否是双龙
}
function SESXEntry:Awake(obj)
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
    SESX_Roll.Init(self.RollContent);
    SESX_Audio.Init();
    SESX_Caijin.Init();
    SESX_Audio.PlayBGM();
    SESX_Network.AddMessage();--添加消息监听
    SESX_Network.LoginGame();--开始登录游戏
    GameSetsPanel.CreateHideObj(self.MainContent, false);
end
--
function SESXEntry.OnDestroy()
    SESX_Line.Close();
    SESX_Network.UnMessage();
end

function SESXEntry:Update()
    SESX_Roll.Update();
    SESX_Caijin.Update();
    SESX_Line.Update();
end
function SESXEntry.ResetRoll()
    self.FreeContent.gameObject:SetActive(false);
    self.startState.gameObject:SetActive(true);
    self.stopState.gameObject:SetActive(false);
    SESXEntry.startBtn.interactable = true;
    self.openChipBtn.interactable = true;
end
function SESXEntry.DelayCall(timer)
    return Util.RunWinScore(0, 1, timer, nil):SetEase(DG.Tweening.Ease.Linear);
end
function SESXEntry.FindComponent()
    self.MainContent = self.transform:Find("MainPanel");

    self.RollContent = self.MainContent:Find("Content/RollContent");--转动区域
    self.ChipNum = self.MainContent:Find("Content/Bottom/Chip/Num"):GetComponent("TextMeshProUGUI");--下注金额
    self.closeChipBtn = self.MainContent:Find("Content/Bottom/Mask"):GetComponent("Button");
    self.openChipBtn = self.ChipNum.transform:GetComponent("Button");
    self.chipGroup = self.closeChipBtn.transform:Find("Group");
    self.WinNum = self.MainContent:Find("Content/Bottom/Win/Num"):GetComponent("TextMeshProUGUI");--本次获得金币

    self.MosaicNum = self.MainContent:Find("Content/Mosaic/MosaicNum"):GetComponent("TextMeshProUGUI");--彩金

    self.btnGroup = self.MainContent:Find("Content/ButtonGroup");
    self.startBtn = self.btnGroup:Find("StartBtn"):GetComponent("Button");--开始按钮
    self.startAnim = self.startBtn.transform:Find("Anim"):GetComponent("SkeletonGraphic");--开始按钮
    self.startState = self.startBtn.transform:Find("Start");
    self.stopState = self.startBtn.transform:Find("Stop");
    self.FreeContent = self.startBtn.transform:Find("Free");--免费状态
    self.freeText = self.FreeContent.transform:Find("Num"):GetComponent("TextMeshProUGUI");--免费次数
    self.AutoBtn = self.btnGroup.transform:Find("AutoBtn");
    self.AutoOn = self.AutoBtn.transform:Find("On").gameObject;
    self.AutoOff = self.AutoBtn.transform:Find("Off").gameObject;
    self.AutoOn:SetActive(true);
    self.AutoOff:SetActive(false);

    self.rulePanel = self.MainContent:Find("Content/Rule");--规则界面
    self.ruleList = self.rulePanel:Find("Content/RuleList"):GetComponent("ScrollRect");--规则子界面
    self.leftShowBtn = self.rulePanel:Find("Content/LeftBtn"):GetComponent("Button");
    self.rightShowBtn = self.rulePanel:Find("Content/RightBtn"):GetComponent("Button");
    self.closeRuleBtn = self.rulePanel:Find("Content/Close"):GetComponent("Button");

    self.menuBtn = self.MainContent:Find("Content/Menu"):GetComponent("Button");--菜单按钮
    self.closeGame = self.MainContent:Find("Content/QuitGameBtn"):GetComponent("Button");
    self.showRuleBtn = self.MainContent:Find("Content/RuleBtn"):GetComponent("Button");

    self.resultEffect = self.MainContent:Find("Content/Result");--中奖后特效
    self.scoreEffect = self.resultEffect:Find("ScoreEffect"):GetComponent("SkeletonGraphic");
    self.winLightEffect = self.resultEffect:Find("Light"):GetComponent("SkeletonGraphic");

    self.jackpotWinEffect = self.resultEffect:Find("NormalReward");
    self.jackpotWinAnim = self.jackpotWinEffect:Find("Anim"):GetComponent("SkeletonGraphic");
    self.jackpotWinNum = self.jackpotWinEffect:Find("Num"):GetComponent("TextMeshProUGUI");
    self.normalWinEffect = self.resultEffect:Find("NormalReward");
    self.normalWinAnim = self.normalWinEffect:Find("Anim"):GetComponent("SkeletonGraphic");
    self.normalWinNum = self.normalWinEffect:Find("Num"):GetComponent("TextMeshProUGUI");
    self.bigWinEffect = self.resultEffect:Find("BigReward");
    self.bigWinAnim = self.bigWinEffect:Find("Anim"):GetComponent("SkeletonGraphic");
    self.bigWinNum = self.bigWinEffect:Find("Num"):GetComponent("TextMeshProUGUI");
    self.epicWinEffect = self.resultEffect:Find("EpicReward");
    self.epicWinAnim = self.epicWinEffect:Find("Anim"):GetComponent("SkeletonGraphic");
    self.epicWinNum = self.epicWinEffect:Find("Num"):GetComponent("TextMeshProUGUI");
    self.megaWinEffect = self.resultEffect:Find("MegaReward");
    self.megaWinAnim = self.megaWinEffect:Find("Anim"):GetComponent("SkeletonGraphic");
    self.megaWinNum = self.megaWinEffect:Find("Num"):GetComponent("TextMeshProUGUI");
    self.superWinEffect = self.resultEffect:Find("SuperReward");
    self.superWinAnim = self.superWinEffect:Find("Anim"):GetComponent("SkeletonGraphic");
    self.superWinNum = self.superWinEffect:Find("Num"):GetComponent("TextMeshProUGUI");
    self.EnterFreeEffect = self.MainContent:Find("Content/EnterFree");
    self.EnterFreeEffectAnim = self.EnterFreeEffect:Find("Anim"):GetComponent("SkeletonGraphic");

    self.userInfo = self.MainContent:Find("Content/Bottom/UserInfo");
    self.selfGold = self.userInfo:Find("GoldNum"):GetComponent("TextMeshProUGUI");--自身金币

    self.AddSpeedObj = self.MainContent:Find("Content/AddSpeed").gameObject;
    self.icons = self.MainContent:Find("Content/Icons");--图标库
    self.effectList = self.MainContent:Find("Content/EffectList");--动画库
    self.effectPool = self.MainContent:Find("Content/EffectPool");--动画缓存库
    self.CSGroup = self.MainContent:Find("Content/CSContent");--显示财神

    for i = 1, SESXEntry.CSGroup.childCount do
        SESXEntry.CSGroup:GetChild(i - 1):GetComponent("CanvasGroup").alpha = 0;
    end
    self.LineGroup = self.MainContent:Find("Content/LineGroup");--连线
    self.soundList = self.MainContent:Find("Content/SoundList");--声音库
    self.settingPanel = self.MainContent:Find("Content/Setting");--设置界面

end

function SESXEntry.AddListener()
    --添加监听事件
    self.startBtn.onClick:RemoveAllListeners();
    self.startBtn.onClick:AddListener(self.StartGameCall);

    self.AutoBtn:GetComponent("Button").onClick:RemoveAllListeners();
    self.AutoBtn:GetComponent("Button").onClick:AddListener(self.OnClickAutoCall);

    self.menuBtn.onClick:RemoveAllListeners();
    self.menuBtn.onClick:AddListener(self.ClickMenuCall);
    self.closeGame.onClick:RemoveAllListeners();
    self.closeGame.onClick:AddListener(self.CloseGameCall);
    self.showRuleBtn.onClick:RemoveAllListeners();--显示规则
    self.showRuleBtn.onClick:AddListener(self.ShowRultPanel);

    self.closeChipBtn.onClick:RemoveAllListeners();
    self.closeChipBtn.onClick:AddListener(function()
        self.closeChipBtn.gameObject:SetActive(false);
    end);

    self.openChipBtn.onClick:RemoveAllListeners();
    self.openChipBtn.onClick:AddListener(function()
        self.closeChipBtn.gameObject:SetActive(true);
    end);

end

function SESXEntry.GetGameConfig()
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
        SESX_DataConfig.rollTime = data.rollTime;
        SESX_DataConfig.rollReboundRate = data.rollReboundRate;
        SESX_DataConfig.rollInterval = data.rollInterval;
        SESX_DataConfig.rollSpeed = data.rollSpeed;
        SESX_DataConfig.caijinGoldChangeRate = data.caijinGoldChangeRate;
        SESX_DataConfig.winGoldChangeRate = data.winGoldChangeRate;
        SESX_DataConfig.selfGoldChangeRate = data.selfGoldChangeRate;
        SESX_DataConfig.freeLoadingShowTime = data.freeLoadingShowTime;
        SESX_DataConfig.smallGameLoadingShowTime = data.smallGameLoadingShowTime;
        SESX_DataConfig.rollDistance = data.rollDistance;
        SESX_DataConfig.REQCaiJinTime = data.REQCaiJinTime;
        SESX_DataConfig.lineAllShowTime = data.lineAllShowTime;
        SESX_DataConfig.cyclePlayLineTime = data.cyclePlayLineTime;
        SESX_DataConfig.waitShowLineTime = data.waitShowLineTime;
        SESX_DataConfig.autoRewardInterval = data.autoRewardInterval;
        SESX_DataConfig.autoNoRewardInterval = data.autoNoRewardInterval;
    end);
end

function SESXEntry.ToCharArray(num)
    --拆解字符串
    local str = tostring(num);
    local list1 = {}
    for i = 1, string.len(str) do
        table.insert(list1, #list1 + 1, string.sub(str, i, i));
    end
    return list1;
end

function SESXEntry.FormatNumberThousands(num)
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

function SESXEntry.SetSelfGold(str)
    self.selfGold.text = self.ShowText(str);
end

function SESXEntry.ShowText(str)
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

function SESXEntry.StartGameCall()
    --开始游戏
    if self.isFreeGame or self.isAutoGame then
        return ;
    end
    if self.isRoll then
        --TODO 急停
        log("急停")
        self.FreeContent.gameObject:SetActive(false);
        self.startState.gameObject:SetActive(true);
        self.stopState.gameObject:SetActive(false);
        SESX_Roll.StopRoll();
        return ;
    end
    self.FreeContent.gameObject:SetActive(false);
    self.startState.gameObject:SetActive(false);
    self.stopState.gameObject:SetActive(true);
    --TODO 发送开始消息,等待结果开始转动
    SESX_Network.StartGame();
end
function SESXEntry.ClickMenuCall()
    --点击显示菜单
    SESX_Audio.PlaySound(SESX_Audio.SoundList.BTN);
    self.settingPanel.gameObject:SetActive(true);
    local settingCloseBtn = self.settingPanel:Find("Content/Close"):GetComponent("Button");
    settingCloseBtn.onClick:RemoveAllListeners();
    settingCloseBtn.onClick:AddListener(function()
        SESX_Audio.PlaySound(SESX_Audio.SoundList.BTN);
        self.settingPanel.gameObject:SetActive(false);
    end);
    local musicprogress = self.settingPanel:Find("Content/Music"):GetComponent("Slider");
    local soundprogress = self.settingPanel:Find("Content/Sound"):GetComponent("Slider");
    local musicDesc = musicprogress.transform:Find("Desc"):GetComponent("TextMeshProUGUI");
    local soundDesc = soundprogress.transform:Find("Desc"):GetComponent("TextMeshProUGUI");
    local musicBtn = self.settingPanel:Find("Content/MusicBtn"):GetComponent("Button");
    local soundBtn = self.settingPanel:Find("Content/SoundBtn"):GetComponent("Button");
    if AllSetGameInfo._5IsPlayAudio then
        musicprogress.value = 1;
        musicDesc.text = "开启";
        musicDesc.transform.localPosition = Vector3.New(-15, 0, 0);
    else
        musicprogress.value = 0;
        musicDesc.text = "关闭";
        musicDesc.transform.localPosition = Vector3.New(15, 0, 0);
    end
    if AllSetGameInfo._6IsPlayEffect then
        soundprogress.value = 1;
        soundDesc.text = "开启";
        soundDesc.transform.localPosition = Vector3.New(-15, 0, 0);
    else
        soundprogress.value = 0;
        soundDesc.text = "关闭";
        soundDesc.transform.localPosition = Vector3.New(15, 0, 0);
    end
    musicBtn.onClick:RemoveAllListeners();
    musicBtn.onClick:AddListener(function()
        if AllSetGameInfo._5IsPlayAudio then
            AllSetGameInfo._5IsPlayAudio = false;
            SESX_Audio.pool.mute = true;
            musicprogress.value = 0;
            musicDesc.text = "关闭";
            musicDesc.transform.localPosition = Vector3.New(15, 0, 0);
        else
            AllSetGameInfo._5IsPlayAudio = true;
            SESX_Audio.pool.mute = false;
            musicprogress.value = 1;
            musicDesc.text = "开启";
            musicDesc.transform.localPosition = Vector3.New(-15, 0, 0);
        end
        Util.Write("IsPlayAudio", tostring(AllSetGameInfo._5IsPlayAudio));
        PlayerPrefs.SetString("IsPlayAudio", tostring(AllSetGameInfo._5IsPlayAudio));
        GameManager.SetIsPlayMute(AllSetGameInfo._6IsPlayEffect, AllSetGameInfo._5IsPlayAudio);
    end);
    soundBtn.onClick:RemoveAllListeners();
    soundBtn.onClick:AddListener(function()
        if AllSetGameInfo._6IsPlayEffect then
            AllSetGameInfo._6IsPlayEffect = false;
            SESX_Audio.MuteSound();
            soundprogress.value = 0;
            soundDesc.text = "关闭";
            soundDesc.transform.localPosition = Vector3.New(15, 0, 0);
        else
            AllSetGameInfo._6IsPlayEffect = true;
            SESX_Audio.ResetSound();
            soundprogress.value = 1;
            soundDesc.text = "开启";
            soundDesc.transform.localPosition = Vector3.New(-15, 0, 0);
        end
        Util.Write("isCanPlaySound", tostring(AllSetGameInfo._6IsPlayEffect));
        PlayerPrefs.SetString("isCanPlaySound", tostring(AllSetGameInfo._5IsPlayAudio));
        GameManager.SetIsPlayMute(AllSetGameInfo._6IsPlayEffect, AllSetGameInfo._5IsPlayAudio);
    end);
end
function SESXEntry.ResetState()
    self.FreeContent.gameObject:SetActive(false);
    self.startState.gameObject:SetActive(true);
    self.stopState.gameObject:SetActive(false);
    SESXEntry.startBtn.interactable = true;
    SESXEntry.openChipBtn.interactable = true;
    SESXEntry.AutoOn.gameObject:SetActive(true);
    SESXEntry.AutoOff.gameObject:SetActive(false);
    self.isAutoGame = false;
end
function SESXEntry.CloseGameCall()
    if not self.isFreeGame and not self.isSmallGame then
        Event.Brocast(MH.Game_LEAVE);
    else
        MessageBox.CreatGeneralTipsPanel("Cannot leave the game in special mode");
    end
end
function SESXEntry.SetMusicCall()
    SESX_Audio.PlaySound(SESX_Audio.SoundList.BTN);
    if AllSetGameInfo._5IsPlayAudio then
        SetInfoSystem.MuteMusic();
        self.musicOn:SetActive(false);
        self.musicOff:SetActive(true);
    else
        SetInfoSystem.PlayMusic();
        self.musicOn:SetActive(true);
        self.musicOff:SetActive(false);
    end
    SESX_Audio.pool.mute = not AllSetGameInfo._5IsPlayAudio;
end
function SESXEntry.SetSoundCall()
    SESX_Audio.PlaySound(SESX_Audio.SoundList.BTN);
    if AllSetGameInfo._6IsPlayEffect then
        SetInfoSystem.MuteSound();
        self.soundOn:SetActive(false);
        self.soundOff:SetActive(true);
    else
        SetInfoSystem.PlaySound();
        self.soundOn:SetActive(true);
        self.soundOff:SetActive(false);
    end
end

function SESXEntry.OnClickAutoCall()
    --点击自动开始
    SESX_Audio.PlaySound(SESX_Audio.SoundList.BTN);
    if self.isAutoGame then
        self.StopAutoGame();
        if self.isFreeGame then
            return ;
        end
        self.FreeContent.gameObject:SetActive(false);
        self.startState.gameObject:SetActive(true);
        self.stopState.gameObject:SetActive(false);
        return ;
    end
    self.OnClickAutoItemCall();
end
function SESXEntry.OnClickAutoItemCall()
    --点击选择自动次数
    SESX_Audio.PlaySound(SESX_Audio.SoundList.BTN);
    self.isAutoGame = true;
    if not self.isFreeGame then
        self.FreeContent.gameObject:SetActive(false);
        self.startState.gameObject:SetActive(false);
        self.stopState.gameObject:SetActive(true);
    end
    self.AutoOff.gameObject:SetActive(true);
    self.AutoOn.gameObject:SetActive(false);
    self.currentAutoCount = 10000;
    if not self.isRoll and not self.isFreeGame then
        --没有转动的状态开始自动旋转
        SESXEntry.openChipBtn.interactable = false;
        SESX_Network.StartGame();
    end
end
function SESXEntry.ShowRultPanel()
    --显示规则
    SESX_Audio.PlaySound(SESX_Audio.SoundList.BTN);
    SESX_Rule.ShowRule();
end
function SESXEntry.SetMaxChipCall()
    --设置最大下注
    SESX_Audio.PlaySound(SESX_Audio.SoundList.BTN);
    self.CurrentChipIndex = #self.SceneData.chipList;
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.CurrentChip * SESX_DataConfig.ALLLINECOUNT);
end

function SESXEntry.CSJLRoll()
    SESX_Network.StartGame();
end
function SESXEntry.StopAutoGame()
    --停止自动旋转
    self.isAutoGame = false;
    self.currentAutoCount = 0;
    SESXEntry.AutoOff.gameObject:SetActive(false);
    SESXEntry.AutoOn.gameObject:SetActive(true);
end
function SESXEntry.FreeGame()
    --免费游戏
    self.isFreeGame = true;
    self.freeText.text = ShowRichText(self.freeCount + 1);
    SESX_Network.StartGame();
end
function SESXEntry.Roll()
    --开始转动    
    SESX_Line.CloseScatter();
    SESXEntry.openChipBtn.interactable = false;
    if not self.isFreeGame then
        self.myGold = self.myGold - self.CurrentChip * SESX_DataConfig.ALLLINECOUNT;
        SESXEntry.SetSelfGold(self.myGold);
        for i = 1, SESXEntry.RollContent.childCount do
            SESXEntry.CSGroup:GetChild(i - 1):GetComponent("CanvasGroup").alpha = 0;
            SESXEntry.RollContent:GetChild(i - 1):GetComponent("CanvasGroup").alpha = 1;
        end
    end

    if self.isAutoGame or self.isFreeGame then
        SESX_Audio.PlaySound(SESX_Audio.SoundList.Shengxiao_Normal_Autospin);
        SESX_Result.HideResult();
        SESX_Line.Close();
        SESX_Roll.StartRoll();
    else
        SESX_Audio.PlaySound(SESX_Audio.SoundList.Shengxiao_Normal_Sp);
        SESXEntry.startAnim.gameObject:SetActive(true);
        SESXEntry.startAnim.AnimationState.Complete = SESXEntry.startAnim.AnimationState.Complete + self.ShowStartAnim;
        SESXEntry.startAnim.AnimationState:SetAnimation(0, "animation", false);
        self.DelayCall(0.5):OnComplete(function()
            SESX_Result.HideResult();
            SESX_Line.Close();
            SESX_Roll.StartRoll();
        end);
    end
    self.WinNum.text = self.ShowText(0);
end

function SESXEntry.ShowStartAnim()
    SESXEntry.startAnim.AnimationState.Complete = SESXEntry.startAnim.AnimationState.Complete - self.ShowStartAnim;
    SESXEntry.startAnim.gameObject:SetActive(false);
end
function SESXEntry.OnStop()
    --停止转动
    log("停止")
    SESX_Audio.ClearAuido(SESX_Audio.SoundList.Rolling)
    SESX_Result.ShowResult();
end
function SESXEntry.InitPanel()
    --场景消息初始化
    self.myGold = TableUserInfo._7wGold;
    SESXEntry.SetSelfGold(self.myGold);
    --TODO 设置下注
    self.CurrentChip = self.SceneData.bet;
    for i = 1, self.SceneData.chipNum do
        if self.SceneData.chipList[i] ~= 0 then
            local child = nil;
            if i > self.chipGroup.childCount then
                child = newobject(self.chipGroup:GetChild(0).gameObject).transform;
                child:SetParent(self.chipGroup);
                child.localScale = Vector3.New(1, 1, 1);
                child.localPosition = Vector3.New(0, 0, 0);
            else
                child = self.chipGroup:GetChild(i - 1);
            end
            local num = child:Find("Num"):GetComponent("TextMeshProUGUI");
            num.text = ShortNumber(self.SceneData.chipList[i]);
            local tog = child:GetComponent("Toggle");
            if self.SceneData.chipList[i] == self.SceneData.bet then
                tog.isOn = true;
            else
                tog.isOn = false;
            end
            local bet = self.SceneData.chipList[i];
            tog.onValueChanged:RemoveAllListeners();
            tog.onValueChanged:AddListener(function(value)
                if value then
                    self.CurrentChip = bet;
                    self.ChipNum.text = self.ShowText(bet * SESX_DataConfig.ALLLINECOUNT);
                    self.closeChipBtn.gameObject:SetActive(false);
                end
            end);
        end
    end
    if self.SceneData.freeNumber <= 0 then
        self.CurrentChipIndex = CheckNear(TableUserInfo._7wGold,self.SceneData.chipList);
        self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    end

    self.ChipNum.text = self.ShowText(self.CurrentChip * SESX_DataConfig.ALLLINECOUNT);
    self.WinNum.text = self.ShowText(0);

    self.isRoll = false;
    self.isFreeGame = false;
    self.isAutoGame = false;
    SESX_Line.Init();
    SESX_Result.Init();
    if self.SceneData.freeNumber > 0 then
        self.isFreeGame = true;
        self.freeCount = self.SceneData.freeNumber;
        self.FreeContent.gameObject:SetActive(true);
        self.startState.gameObject:SetActive(false);
        self.stopState.gameObject:SetActive(false);
        SESXEntry.startBtn.interactable = false;
        SESXEntry.openChipBtn.interactable = false;
        if self.freeCount == 5 then
            SESX_Result.ShowFreeEffect(true);
        else
            SESX_Audio.PlayBGM(SESX_Audio.SoundList.FreeBGM);
            SESX_Result.EnterFreeEffect();
        end
    else
        self.FreeContent.gameObject:SetActive(false);
        self.startState.gameObject:SetActive(true);
        self.stopState.gameObject:SetActive(false);
        SESXEntry.startBtn.interactable = true;
        SESXEntry.openChipBtn.interactable = true;
    end
end
function SESXEntry.FreeRoll()
    --判断是否为免费游戏
    SESX_Result.isShow = false;
    if self.isFreeGame then
        self.freeCount = self.freeCount - 1;
        self.currentFreeCount = self.currentFreeCount + 1;
        if self.freeCount < 0 then
            --免费结束,展示免费结算界面
            --SESX_Result.ShowFreeResultEffect();
            self.isFreeGame = false;
            self.AutoRoll();
        else
            --还有免费次数
            log("继续免费")
            self.FreeGame();
        end
    else
        self.AutoRoll();
    end
end
function SESXEntry.AutoRoll()
    --判断是否为自动游戏
    if self.isAutoGame then
        --如果是自动游戏
        if self.currentAutoCount < 1000 then
            self.currentAutoCount = self.currentAutoCount - 1;
        end
        if self.currentAutoCount < 0 then
            --自动次数使用完了，回到待机状态
            self.FreeContent.gameObject:SetActive(false);
            self.startState.gameObject:SetActive(true);
            self.stopState.gameObject:SetActive(false);
            SESXEntry.startBtn.interactable = true;
            SESXEntry.openChipBtn.interactable = false;
            self.StopAutoGame();
        else
            --还有自动次数
            self.OnClickAutoItemCall();
        end
    else
        --不是自动游戏，直接待机
        self.FreeContent.gameObject:SetActive(false);
        self.startState.gameObject:SetActive(true);
        self.stopState.gameObject:SetActive(false);
        SESXEntry.startBtn.interactable = true;
        SESXEntry.openChipBtn.interactable = true;
        self.StopAutoGame();
    end
end