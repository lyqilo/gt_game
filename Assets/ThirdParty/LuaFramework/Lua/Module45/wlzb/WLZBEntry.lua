-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion
local g_swlzbNum = "Module45/wlzb/";

require(g_swlzbNum .. "WLZB_Network")
require(g_swlzbNum .. "WLZB_Roll")
require(g_swlzbNum .. "WLZB_DataConfig")
--require(g_swlzbNum .. "WLZB_Caijin")
require(g_swlzbNum .. "WLZB_Line")
require(g_swlzbNum .. "WLZB_Result")
require(g_swlzbNum .. "WLZB_Rule")
require(g_swlzbNum .. "WLZB_Audio")

WLZBEntry = {};
local self = WLZBEntry;
self.transform = nil;
self.gameObject = nil;

self.CurrentFreeIndex = 0;
self.CurrentChip = 0;
self.CurrentChipIndex = 0;
self.isAutoGame = false;
self.isFreeGame = false;
self.isRoll = false;
self.menuTweener = nil;

self.currentFreeCount = 0;

self.currentAutoCount = 0;--剩余自动次数
self.freeCount = 0;--剩余免费次数

self.myGold = 0;--显示的自身金币
self.ScatterList = {};

self.SceneData = {
    freeNumber = 0, --免费次数
    bet = 0, --当前下注
    chipNum = 0, --用户金币
    chipList = {}, --下注列表
    nFreeGameIndex = 0, --免费游戏次数下标
    nFreeGameGold = 0, --免费游戏获得金币
    bFreeGame = false--断线选择免费游戏档次
};
self.FreeData = {
    nUserChoseIndex = 0, --用户选择下标
    nFreeCount = 0, --免费次数
    nFreeOddIndex = 0, --免费的倍率下标
}
self.ResultData = {
    ImgTable = {}, --图标
    LineTypeTable = {}, --连线类型
    m_nWinPeiLv = 0, --当前倍率
    m_nCurrGold = 0, --自身金币
    WinScore = 0, --赢得总分
    TotalWinScore = 0, --赢得总分
    FreeCount = 0, --免费次数
    m_nMultiple = 0, --当前押注
    m_bFreeGame = false, --免费选择
    m_nFreeGamePeiLvLevel = 0
}
function WLZBEntry:Awake(obj)
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
    WLZB_Roll.Init(self.RollContent);
    WLZB_Audio.Init();
    WLZB_Network.AddMessage();--添加消息监听
    WLZB_Network.LoginGame();--开始登录游戏
    GameSetsPanel.CreateHideObj(self.MainContent, false);
    WLZB_Audio.PlayBGM();
end
function WLZBEntry.OnDestroy()
    WLZB_Line.Close();
    WLZB_Network.UnMessage();
end
function WLZBEntry:Update()
    WLZB_Roll.Update();
    --WLZB_Caijin.Update();
    WLZB_Line.Update();
    WLZB_Result.Update();
end
function WLZBEntry.FindComponent()
    self.MainContent = self.transform:Find("MainPanel");

    self.normalBackground = self.MainContent:Find("Content/MainBackground").gameObject;
    self.freeBackground = self.MainContent:Find("Content/FreeBackground").gameObject;
    self.freeWinNum = self.MainContent:Find("Content/FreeWin/Num"):GetComponent("TextMeshProUGUI");

    self.RollContent = self.MainContent:Find("Content/RollContent");--转动区域
    self.selfGold = self.MainContent:Find("Content/Bottom/Gold/Num"):GetComponent("TextMeshProUGUI");--自身金币
    self.ChipNum = self.MainContent:Find("Content/Bottom/Chip/Num"):GetComponent("TextMeshProUGUI");--下注金额
    self.WinNum = self.MainContent:Find("Content/Bottom/Win/Num"):GetComponent("TextMeshProUGUI");--本次获得金币

    self.reduceChipBtn = self.MainContent:Find("Content/Bottom/Chip/Reduce"):GetComponent("Button");--减注
    self.addChipBtn = self.MainContent:Find("Content/Bottom/Chip/Add"):GetComponent("Button");--加注

    self.btnGroup = self.MainContent:Find("Content/ButtonGroup");
    self.startBtn = self.btnGroup:Find("StartBtn"):GetComponent("SkeletonGraphic");--开始按钮
    self.FreeContent = self.startBtn.transform:Find("Free");--免费状态
    self.freeText = self.FreeContent.transform:Find("Num"):GetComponent("TextMeshProUGUI");--免费次数
    self.AutoContent = self.startBtn.transform:Find("AutoState");
    self.autoText = self.AutoContent.transform:Find("AutoNum"):GetComponent("TextMeshProUGUI");--自动次数
    self.autoInfinite = self.AutoContent.transform:Find("Infinite")--无限次数
    self.startBtn.AnimationState:SetAnimation(0, "idle", true);--播放闲置动画

    self.MaxChipBtn = self.btnGroup:Find("MaxChip"):GetComponent("Button");--最大下注
    self.AutoStartBtn = self.btnGroup:Find("AutoStart"):GetComponent("Button");--打开自动开始界面
    self.closeAutoMenu = self.btnGroup:Find("CloseAutoMenu"):GetComponent("Button");--关闭自动开始界面
    self.autoSelectList = self.closeAutoMenu.transform:Find("AutoSelect");--自动开始次数选择
    self.closeAutoMenu.gameObject:SetActive(false);
    self.AutoStartBtn.transform:Find("On").gameObject:SetActive(true);
    self.AutoStartBtn.transform:Find("Off").gameObject:SetActive(false);

    self.rulePanel = self.MainContent:Find("Content/Rule");--规则界面
    self.ruleList = self.rulePanel:Find("Content/RuleList"):GetComponent("ScrollRect");--规则子界面
    self.leftShowBtn = self.rulePanel:Find("Content/LeftBtn"):GetComponent("Button");
    self.rightShowBtn = self.rulePanel:Find("Content/RightBtn"):GetComponent("Button");
    self.closeRuleBtn = self.rulePanel:Find("Content/BackBtn"):GetComponent("Button");

    self.menuBtn = self.MainContent:Find("Content/Menu"):GetComponent("Button");--菜单按钮
    self.menulist = self.MainContent:Find("Content/MenuList");--菜单按钮详情
    self.backgroundBtn = self.MainContent:Find("Content/CloseMenu"):GetComponent("Button");
    self.musicBtn = self.menulist:Find("Content/Music"):GetComponent("Button");
    self.musicOn = self.musicBtn.transform:Find("On").gameObject;
    self.musicOff = self.musicBtn.transform:Find("Off").gameObject;
    self.closeGame = self.menulist:Find("Content/Back"):GetComponent("Button");
    self.soundBtn = self.menulist:Find("Content/Sound"):GetComponent("Button");
    self.soundOn = self.soundBtn.transform:Find("On").gameObject;
    self.soundOff = self.soundBtn.transform:Find("Off").gameObject;
    self.showRuleBtn = self.menulist:Find("Content/Rule"):GetComponent("Button");
    self.menulist:Find("Content").localPosition = Vector3.New(0, 1000, 0);
    self.backgroundBtn.gameObject:SetActive(false);

    self.musicOn:SetActive(AllSetGameInfo._5IsPlayAudio);
    self.musicOff:SetActive(not AllSetGameInfo._5IsPlayAudio);
    self.soundOn:SetActive(AllSetGameInfo._6IsPlayEffect);
    self.soundOff:SetActive(not AllSetGameInfo._6IsPlayEffect);

    self.resultEffect = self.MainContent:Find("Content/Result");--中奖后特效
    self.resultEffect:GetComponent("Image").enabled = false;
    self.normalWinEffect = self.resultEffect:Find("Reward");
    self.normalWinNum = self.normalWinEffect:Find("RewardNum"):GetComponent("TextMeshProUGUI");
    self.bigWinEffect = self.resultEffect:Find("BigWin");
    self.bigWinNum = self.bigWinEffect:Find("Num"):GetComponent("TextMeshProUGUI");
    self.superWinEffect = self.resultEffect:Find("SuperWin");
    self.superWinNum = self.superWinEffect:Find("Num"):GetComponent("TextMeshProUGUI");
    self.megaWinEffect = self.resultEffect:Find("MegeWin");
    self.megaWinNum = self.megaWinEffect:Find("Num"):GetComponent("TextMeshProUGUI");
    self.EnterFreeEffect = self.resultEffect:Find("EnterFree");
    self.FreeResultEffect = self.resultEffect:Find("FreeResult");
    self.FreeResultNum = self.FreeResultEffect:Find("Num"):GetComponent("TextMeshProUGUI");
    self.resultEffect.gameObject:SetActive(false);

    self.SelectFreeEffect = self.resultEffect:Find("SelectFree");
    self.selectBtnGroup = self.SelectFreeEffect:Find("Content/BtnGroup");
    self.selectResult = self.SelectFreeEffect:Find("ResultContent");
    self.selectCount = self.selectResult:Find("Count"):GetComponent("TextMeshProUGUI");
    self.selectRate = self.selectResult:Find("Rate"):GetComponent("TextMeshProUGUI");

    self.userInfo = self.MainContent:Find("Content/UserInfo");
    self.headIcon = self.userInfo:Find("Mask/Head"):GetComponent("Image");
    self.nickName = self.userInfo:Find("NickName"):GetComponent("Text");
    self.userInfo.gameObject:SetActive(false);

    self.icons = self.MainContent:Find("Content/Icons");--图标库
    self.effectList = self.MainContent:Find("Content/EffectList");--动画库
    self.effectPool = self.MainContent:Find("Content/EffectPool");--动画缓存库
    self.CSGroup = self.MainContent:Find("Content/CSContent");--显示财神
    self.soundList = self.MainContent:Find("Content/SoundList");--声音库

    self.headIcon.sprite = HallScenPanel.GetHeadIcon();
    self.nickName.text = SCPlayerInfo._05wNickName;
end
function WLZBEntry.AddListener()
    --添加监听事件
    self.reduceChipBtn.onClick:RemoveAllListeners();
    self.reduceChipBtn.onClick:AddListener(self.ReduceChipCall);
    self.addChipBtn.onClick:RemoveAllListeners();
    self.addChipBtn.onClick:AddListener(self.AddChipCall);
    self.startBtn.transform:GetComponent("Button").onClick:RemoveAllListeners();
    self.startBtn.transform:GetComponent("Button").onClick:AddListener(self.StartGameCall);

    self.menuBtn.onClick:RemoveAllListeners();
    self.menuBtn.onClick:AddListener(self.ClickMenuCall);
    self.backgroundBtn.onClick:RemoveAllListeners();
    self.backgroundBtn.onClick:AddListener(self.CloseMenuCall);
    --self.closeMenu.onClick:RemoveAllListeners();
    --self.closeMenu.onClick:AddListener(self.CloseMenuCall);
    self.closeGame.onClick:RemoveAllListeners();
    self.closeGame.onClick:AddListener(self.CloseGameCall);
    self.soundBtn.onClick:RemoveAllListeners();
    self.soundBtn.onClick:AddListener(self.SetSoundCall);
    self.musicBtn.onClick:RemoveAllListeners();
    self.musicBtn.onClick:AddListener(self.SetMusicCall);
    self.showRuleBtn.onClick:RemoveAllListeners();--显示规则
    self.showRuleBtn.onClick:AddListener(self.ShowRultPanel);

    self.AutoStartBtn.onClick:RemoveAllListeners();
    self.AutoStartBtn.onClick:AddListener(self.OnClickAutoStartCall);

    self.MaxChipBtn.onClick:RemoveAllListeners();
    self.MaxChipBtn.onClick:AddListener(self.SetMaxChipCall);
    self.closeAutoMenu.onClick:RemoveAllListeners();--关闭自动
    self.closeAutoMenu.onClick:AddListener(function()
        self.closeAutoMenu.gameObject:SetActive(false);
    end)
    for i = 1, #WLZB_DataConfig.autoList do
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
        if WLZB_DataConfig.autoList[i] > 1000 then
            child:Find("Infinite").gameObject:SetActive(true);
            child:Find("Num").gameObject:SetActive(false);
        else
            child:Find("Infinite").gameObject:SetActive(false);
            child:Find("Num").gameObject:SetActive(true);
            child:Find("Num"):GetComponent("TextMeshProUGUI").text = ShowRichText(WLZB_DataConfig.autoList[i]);
        end
        child.gameObject.name = tostring(WLZB_DataConfig.autoList[i]);
        child:GetComponent("Button").onClick:RemoveAllListeners();
        child:GetComponent("Button").onClick:AddListener(function()
            self.currentAutoCount = WLZB_DataConfig.autoList[i];
            self.OnClickAutoItemCall();
        end)
        child.gameObject:SetActive(true);
    end
    for i = 1, self.selectBtnGroup.childCount do
        local btn = self.selectBtnGroup:GetChild(i - 1):GetComponent("Button");
        btn.onClick:RemoveAllListeners();
        btn.onClick:AddListener(function()
            self.CurrentFreeIndex = tonumber(btn.gameObject.name);
            WLZB_Network.StartFreeGame();
        end);
    end
end
function WLZBEntry.GetGameConfig()
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
        WLZB_DataConfig.rollTime = data.rollTime;
        WLZB_DataConfig.rollReboundRate = data.rollReboundRate;
        WLZB_DataConfig.rollInterval = data.rollInterval;
        WLZB_DataConfig.rollSpeed = data.rollSpeed;
        WLZB_DataConfig.caijinGoldChangeRate = data.caijinGoldChangeRate;
        WLZB_DataConfig.winGoldChangeRate = data.winGoldChangeRate;
        WLZB_DataConfig.selfGoldChangeRate = data.selfGoldChangeRate;
        WLZB_DataConfig.freeLoadingShowTime = data.freeLoadingShowTime;
        WLZB_DataConfig.smallGameLoadingShowTime = data.smallGameLoadingShowTime;
        WLZB_DataConfig.rollDistance = data.rollDistance;
        WLZB_DataConfig.REQCaiJinTime = data.REQCaiJinTime;
        WLZB_DataConfig.lineAllShowTime = data.lineAllShowTime;
        WLZB_DataConfig.cyclePlayLineTime = data.cyclePlayLineTime;
        WLZB_DataConfig.waitShowLineTime = data.waitShowLineTime;
        WLZB_DataConfig.autoRewardInterval = data.autoRewardInterval;
        WLZB_DataConfig.autoNoRewardInterval = data.autoNoRewardInterval;
    end);
end
function WLZBEntry.ToCharArray(num)
    --拆解字符串
    local str = tostring(num);
    local list1 = {}
    for i = 1, string.len(str) do
        table.insert(list1, #list1 + 1, string.sub(str, i, i));
    end
    return list1;
end
function WLZBEntry.FormatNumberThousands(num)
    return num;
    ----对数字做千分位操作
    --local function checknumber(value)
    --    return tonumber(value) or 0
    --end
    --local formatted = tostring(checknumber(num))
    --local k
    --while true do
    --    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    --    print(formatted, k)
    --    if k == 0 then
    --        break
    --    end
    --
    --end
    --return formatted
end
function WLZBEntry.SetSelfGold(str)
    self.selfGold.text = self.ShowText(str);
end
function WLZBEntry.ShowText(str,short)
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
function WLZBEntry.ReduceChipCall()
    --减注
    WLZB_Audio.PlaySound(WLZB_Audio.SoundList.BTN);
    if self.SceneData.chipList == nil or #self.SceneData.chipList <= 0 then
        return ;
    end
    self.CurrentChipIndex = self.CurrentChipIndex - 1;
    if self.CurrentChipIndex <= 0 then
        self.CurrentChipIndex = #self.SceneData.chipList;
    end
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.CurrentChip * WLZB_DataConfig.ALLLINECOUNT);
end
function WLZBEntry.AddChipCall()
    --加注
    WLZB_Audio.PlaySound(WLZB_Audio.SoundList.BTN);
    if self.SceneData.chipList == nil or #self.SceneData.chipList <= 0 then
        return ;
    end
    self.CurrentChipIndex = self.CurrentChipIndex + 1;
    if self.CurrentChipIndex > #self.SceneData.chipList then
        self.CurrentChipIndex = 1;
    end
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.CurrentChip * WLZB_DataConfig.ALLLINECOUNT);
end
function WLZBEntry.StartGameCall()
    --开始游戏
    if self.isFreeGame or self.isAutoGame then
        return ;
    end
    if self.isRoll then
        --TODO 急停
        WLZB_Roll.StopRoll();
        return ;
    end
    WLZB_Audio.PlaySound(WLZB_Audio.SoundList.BTN);
    if self.myGold < self.CurrentChip * WLZB_DataConfig.ALLLINECOUNT then
        MessageBox.CreatGeneralTipsPanel("Insufficient gold coins!")
        return ;
    end
    self.startBtn.AnimationState:SetAnimation(0, "click", false);--点击
    self.startBtn.AnimationState:AddAnimation(0, "idle", true, 0);--播放闲置动画
    --TODO 发送开始消息,等待结果开始转动
    WLZB_Network.StartGame();
end
function WLZBEntry.ClickMenuCall()
    --点击显示菜单
    WLZB_Audio.PlaySound(WLZB_Audio.SoundList.BTN);
    if self.menuTweener ~= nil then
        self.menuTweener:Kill();
    end
    self.backgroundBtn.gameObject:SetActive(true);
    self.backgroundBtn.interactable = false;
    self.menuTweener = self.menulist:Find("Content"):DOLocalMove(Vector3.New(0, 224, 0), 0.5):OnComplete(function()
        self.backgroundBtn.interactable = true;
        if self.menuTweener ~= nil then
            self.menuTweener = nil;
        end
    end);
    if self.menuTweener ~= nil then
        self.menuTweener:SetAutoKill();
    end
end
function WLZBEntry.CloseMenuCall()
    --关闭菜单
    WLZB_Audio.PlaySound(WLZB_Audio.SoundList.BTN);
    if self.menuTweener ~= nil then
        self.menuTweener:Kill();
    end
    self.backgroundBtn.interactable = false;
    self.menuTweener = self.menulist:Find("Content"):DOLocalMove(Vector3.New(0, 1000, 0), 0.5):OnComplete(function()
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
function WLZBEntry.CloseGameCall()
    Event.Brocast(MH.Game_LEAVE);
end
function WLZBEntry.SetMusicCall()
    WLZB_Audio.PlaySound(WLZB_Audio.SoundList.BTN);
    if AllSetGameInfo._5IsPlayAudio then
        SetInfoSystem.MuteMusic();
        self.musicOn:SetActive(false);
        self.musicOff:SetActive(true);
    else
        SetInfoSystem.PlayMusic();
        self.musicOn:SetActive(true);
        self.musicOff:SetActive(false);
    end
    WLZB_Audio.pool.mute = not AllSetGameInfo._5IsPlayAudio;
end
function WLZBEntry.SetSoundCall()
    WLZB_Audio.PlaySound(WLZB_Audio.SoundList.BTN);
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

function WLZBEntry.OnClickAutoCall()
    --点击自动开始
    WLZB_Audio.PlaySound(WLZB_Audio.SoundList.BTN);
    if self.isAutoGame then
        self.StopAutoGame();
        return ;
    end
    self.closeAutoMenu.gameObject:SetActive(true);
end
function WLZBEntry.OnClickAutoStartCall()
    --点击选择自动次数
    if self.isAutoGame then
        self.StopAutoGame();
        return ;
    end
    self.AutoStartCall();
end
function WLZBEntry.AutoStartCall()
    WLZB_Audio.PlaySound(WLZB_Audio.SoundList.BTN);
    if self.isAutoGame then
        self.StopAutoGame();
        return ;
    end
    self.closeAutoMenu.gameObject:SetActive(true);
end
function WLZBEntry.OnClickAutoItemCall()
    --点击选择自动次数
    WLZB_Audio.PlaySound(WLZB_Audio.SoundList.BTN);
    self.isAutoGame = true;
    self.AutoStartBtn.transform:Find("On").gameObject:SetActive(false);
    self.AutoStartBtn.transform:Find("Off").gameObject:SetActive(true);
    self.closeAutoMenu.gameObject:SetActive(false);
    if not self.isFreeGame then
        if self.myGold < self.CurrentChip * WLZB_DataConfig.ALLLINECOUNT then
            MessageBox.CreatGeneralTipsPanel("Insufficient gold coins!")
            return ;
        end
        self.startBtn.AnimationState:SetAnimation(0, "automatic", true);
        self.startBtn.transform:Find("AutoState").gameObject:SetActive(true);
    end
    local autonum = self.startBtn.transform:Find("AutoState/AutoNum");
    local infinite = self.startBtn.transform:Find("AutoState/Infinite");

    self.MaxChipBtn.interactable = false;
    self.addChipBtn.interactable = false;
    self.reduceChipBtn.interactable = false;
    if self.currentAutoCount > 1000 then
        autonum.gameObject:SetActive(false);
        infinite.gameObject:SetActive(true);
    else
        autonum.gameObject:SetActive(true);
        infinite.gameObject:SetActive(false);
        autonum:GetComponent("TextMeshProUGUI").text = ShowRichText(self.currentAutoCount);
    end
    if not self.isRoll and not self.isFreeGame then
        --没有转动的状态开始自动旋转
        WLZB_Network.StartGame();
    end
end
function WLZBEntry.ShowRultPanel()
    --显示规则
    WLZB_Audio.PlaySound(WLZB_Audio.SoundList.BTN);
    WLZB_Rule.ShowRule();
end
function WLZBEntry.SetMaxChipCall()
    --设置最大下注
    WLZB_Audio.PlaySound(WLZB_Audio.SoundList.BTN);
    self.CurrentChipIndex = #self.SceneData.chipList;
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.CurrentChip * WLZB_DataConfig.ALLLINECOUNT);
end

function WLZBEntry.CSJLRoll()
    WLZB_Network.StartGame();
end
function WLZBEntry.StopAutoGame()
    --停止自动旋转
    self.isAutoGame = false;
    self.currentAutoCount = 0;
    self.AutoStartBtn.transform:Find("On").gameObject:SetActive(true);
    self.AutoStartBtn.transform:Find("Off").gameObject:SetActive(false);
    self.AutoContent.gameObject:SetActive(false);
    if not WLZBEntry.isFreeGame then
        self.FreeContent.gameObject:SetActive(false);
        self.startBtn.AnimationState:SetAnimation(0, "idle", true);
        WLZBEntry.addChipBtn.interactable = true;
        WLZBEntry.reduceChipBtn.interactable = true;
        WLZBEntry.MaxChipBtn.interactable = true;
    end
end
function WLZBEntry.FreeGame()
    --免费游戏
    self.isFreeGame = true;
    self.freeText.text = ShowRichText(self.freeCount);
    WLZB_Network.StartGame();
end
function WLZBEntry.Roll()
    --开始转动    
    WLZB_Audio.ResetEffect();
    if not self.isFreeGame then
        self.myGold = self.myGold - self.CurrentChip * WLZB_DataConfig.ALLLINECOUNT;
        WLZBEntry.SetSelfGold(self.myGold);
    end
    self.WinNum.text = self.ShowText(0);
    WLZB_Result.HideResult();
    WLZB_Line.Close();
    WLZB_Roll.StartRoll();
end
function WLZBEntry.OnStop()
    --停止转动
    log("停止")
    WLZB_Result.ShowResult();
end
function WLZBEntry.InitPanel()
    --场景消息初始化
    self.myGold = TableUserInfo._7wGold;
    WLZBEntry.SetSelfGold(self.myGold);
    for i = 1, #self.SceneData.chipList do
        if self.SceneData.chipList[i] == self.SceneData.bet then
            self.CurrentChipIndex = i;
        end
    end
    if self.SceneData.freeNumber <= 0 then
        self.CurrentChipIndex = CheckNear(self.myGold,self.SceneData.chipList)
    end
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.CurrentChip * WLZB_DataConfig.ALLLINECOUNT);
    self.WinNum.text = self.ShowText(0);
    --WLZB_Caijin.isCanSend = true;
    self.isRoll = false;
    WLZB_Line.Init();
    WLZB_Result.Init();
    if self.SceneData.bFreeGame then
        --如果免费
        self.normalBackground:SetActive(false);
        self.freeBackground:SetActive(true);
        self.AutoContent.gameObject:SetActive(false);
        self.FreeContent.gameObject:SetActive(true);
        self.startBtn.AnimationState:SetAnimation(0, "freetimes", true);
        self.freeCount = self.SceneData.freeNumber;
        self.isFreeGame = true;
        WLZB_Result.ShowFreeEffect(true);
    else
        if self.SceneData.freeNumber > 0 then
            self.isFreeGame = true;
            self.freeCount = self.SceneData.freeNumber;
            self.normalBackground:SetActive(false);
            self.freeBackground:SetActive(true);
            self.AutoContent.gameObject:SetActive(false);
            self.FreeContent.gameObject:SetActive(true);
            self.startBtn.AnimationState:SetAnimation(0, "freetimes", true);
            WLZB_Audio.PlayBGM(WLZB_Audio.SoundList.FreeBGM);
            WLZBEntry.freeWinNum.text = WLZBEntry.ShowText(WLZB_Result.totalFreeGold);
            self.FreeRoll();
        else
            self.normalBackground:SetActive(true);
            self.freeBackground:SetActive(false);
            self.AutoContent.gameObject:SetActive(false);
            self.FreeContent.gameObject:SetActive(false);
            self.startBtn.AnimationState:SetAnimation(0, "idle", true);
        end
    end
end
function WLZBEntry.FreeRoll()
    --判断是否为免费游戏
    WLZB_Result.isShow = false;
    if self.isFreeGame then
        self.freeCount = self.freeCount - 1;
        self.currentFreeCount = self.currentFreeCount + 1;
        if self.freeCount < 0 then
            --免费结束
            log("免费结束")
            if WLZB_Result.showFreeTweener ~= nil then
                WLZB_Result.showFreeTweener:Kill();
                WLZB_Result.showFreeTweener = nil;
            end
            self.isFreeGame = false;
            WLZBEntry.addChipBtn.interactable = true;
            WLZBEntry.reduceChipBtn.interactable = true;
            WLZB_Audio.PlayBGM();
            self.normalBackground:SetActive(true);
            self.freeBackground:SetActive(false);
            WLZBEntry.freeWinNum.text = "";
            WLZBEntry.FreeContent.gameObject:SetActive(false);
            WLZBEntry.AutoContent.gameObject:SetActive(true);
            WLZBEntry.startBtn.AnimationState:SetAnimation(0, "automatic", true);
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
function WLZBEntry.AutoRoll()
    --判断是否为自动游戏
    if self.isAutoGame then
        --如果是自动游戏
        if self.currentAutoCount < 1000 then
            self.currentAutoCount = self.currentAutoCount - 1;
        end
        if self.currentAutoCount < 0 then
            --自动次数使用完了，回到待机状态
            WLZBEntry.isRoll = false;
            self.StopAutoGame();
        else
            --还有自动次数
            WLZBEntry.isRoll = false;
            self.OnClickAutoItemCall();
        end
    else
        --不是自动游戏，直接待机
        self.StopAutoGame();
    end
end