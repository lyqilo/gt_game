-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion
local Module13Num = "Module13/gfxm/";

require(Module13Num .. "Module13_Network")
require(Module13Num .. "Module13_Roll")
require(Module13Num .. "Module13_DataConfig")
--require(Module13Num .. "Module13_Caijin")
require(Module13Num .. "Module13_Line")
require(Module13Num .. "Module13_Result")
require(Module13Num .. "Module13_Rule")
require(Module13Num .. "Module13_Audio")
require(Module13Num .. "Module13_SmallGamePanel")


Module13Entry = {};
local self = Module13Entry;
self.transform = nil;
self.gameObject = nil;

self.CurrentChip = 0;
self.CurrentChipIndex = 0;
self.isAutoGame = false;
self.isFreeGame = false;
self.isRoll = false;
self.menuTweener = nil;

self.currentAutoCount = 0;--剩余自动次数
self.freeCount = 0;--剩余免费次数

self.myGold = 0;--显示的自身金币

self.isPlayFreeGame=false

self.isFireMode=false

local musicValue=1
local soundValue=1

self.SceneData = {
    bet = 0, --当前下注
    freeNumber = 0, --免费次数
    GoldResult =0, 
    chipList = {}, --下注列表
    bFireMode=false,--是否是烈焰模式
};
self.ResultData = {
    ImgTable = {}, --图标
    LineTypeTable = {}, --连线类型
    FreeCount = 0, --免费次数
    GameType = 0, --游戏类型
    WinScore = 0, --赢得总分
    --isSmallGame=0,--是否小游戏
}
self.SmallGameReult = {
    WinScore = 0, --赢得总分
}

function Module13Entry:Awake(obj)
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
    Module13_Roll.Init(self.RollContent);
    Module13_Audio.Init();
    Module13_Network.AddMessage();--添加消息监听
    Module13_Network.LoginGame();--开始登录游戏
    GameSetsPanel.CreateHideObj(self.transform,false);
    --Module13_Audio.PlayBGM();
end
function Module13Entry.OnDestroy()
    Module13_Line.Close();
    Module13_Network.UnMessage();
end
function Module13Entry:Update()
    Module13_Roll.Update();
    --Module13_Caijin.Update();
    Module13_Line.Update();
    Module13_Result.Update();
    Module13_SmallGamePanel.Update()
end
function Module13Entry.FindComponent()
    self.MosaicNum = self.transform:Find("Content/Mosaic/MosaicNum"):GetComponent("TextMeshProUGUI");--彩金
    self.FreeRewardList = self.transform:Find("Content/FreeRewardList");--免费奖励表
    self.RollContent = self.transform:Find("Content/RollContent");--转动区域
    self.selfGold = self.transform:Find("Content/Bottom/Gold/Num"):GetComponent("TextMeshProUGUI");--自身金币
    self.ChipNum = self.transform:Find("Content/Bottom/Chip/Num"):GetComponent("TextMeshProUGUI");--下注金额
    self.WinNum = self.transform:Find("Content/Bottom/Win/Num"):GetComponent("TextMeshProUGUI");--本次获得金币

    self.reduceChipBtn = self.transform:Find("Content/Bottom/Chip/Reduce"):GetComponent("Button");--减注
    self.addChipBtn = self.transform:Find("Content/Bottom/Chip/Add"):GetComponent("Button");--加注

    self.btnGroup = self.transform:Find("Content/ButtonGroup");
    self.startBtn = self.btnGroup:Find("StartBtn"):GetComponent("SkeletonGraphic");--开始按钮
    self.FreeContent = self.startBtn.transform:Find("Free");--免费状态
    self.freeText = self.FreeContent.transform:Find("Num"):GetComponent("TextMeshProUGUI");--免费次数
    self.AutoContent = self.startBtn.transform:Find("AutoState");
    self.autoText = self.AutoContent.transform:Find("AutoNum"):GetComponent("TextMeshProUGUI");--自动次数
    self.autoInfinite = self.AutoContent.transform:Find("Infinite")--无限次数
    --self.startBtn.AnimationState:SetAnimation(0, "idle", true);--播放闲置动画

    self.MaxChipBtn = self.btnGroup:Find("MaxChip"):GetComponent("Button");--最大下注
    self.AutoStartBtn = self.btnGroup:Find("AutoStart"):GetComponent("Button");--打开自动开始界面
    self.closeAutoMenu = self.btnGroup:Find("CloseAutoMenu"):GetComponent("Button");--关闭自动开始界面
    self.autoSelectList = self.closeAutoMenu.transform:Find("AutoSelect");--自动开始次数选择
    self.closeAutoMenu.gameObject:SetActive(false);
    self.AutoStartBtn.transform:Find("On").gameObject:SetActive(false);
    self.AutoStartBtn.transform:Find("Off").gameObject:SetActive(true);

    self.rulePanel = self.transform:Find("Content/Rule");--规则界面
    self.ruleList = self.rulePanel:Find("Content/RuleList");--规则子界面

    self.ruleImage1 = self.rulePanel:Find("Content/Image1");
    self.ruleImage2 = self.rulePanel:Find("Content/Image2");
    self.closeRuleBtn = self.rulePanel:Find("Content/BackBtn"):GetComponent("Button");

    self.menuBtn = self.transform:Find("Content/Menu"):GetComponent("Button");--菜单按钮
    self.menulist = self.transform:Find("Content/MenuList");--菜单按钮详情
    self.backgroundBtn = self.transform:Find("Content/CloseMenu"):GetComponent("Button");
    self.closeMenu = self.menulist:Find("Close"):GetComponent("Button");
    self.closeGame = self.menulist:Find("Content/Back"):GetComponent("Button");


    self.musicBtn = self.menulist:Find("Content/Music"):GetComponent("Button");
    self.musicOn = self.musicBtn.transform:Find("On").gameObject;
    self.musicOff = self.musicBtn.transform:Find("Off").gameObject;
    self.musicOn:SetActive(MusicManager:GetIsPlayMV());
    self.musicOff:SetActive(not MusicManager:GetIsPlayMV());

    self.soundBtn = self.menulist:Find("Content/Sound"):GetComponent("Button");
    self.soundOn = self.soundBtn.transform:Find("On").gameObject;
    self.soundOff = self.soundBtn.transform:Find("Off").gameObject;
    self.soundOn:SetActive(MusicManager:GetIsPlaySV());
    self.soundOff:SetActive(not MusicManager:GetIsPlaySV());

    self.showRuleBtn = self.menulist:Find("Content/Rule"):GetComponent("Button");
    self.menulist:Find("Content").localPosition = Vector3.New(0, 500, 0);
    self.backgroundBtn.gameObject:SetActive(false);

    self.resultEffect = self.transform:Find("Content/Result");--中奖后特效
    self.winNormalEffect = self.resultEffect:Find("Reward"):GetComponent("SkeletonGraphic");
    self.winNormalNum = self.winNormalEffect.transform:Find("RewardNum"):GetComponent("TextMeshProUGUI");
    self.CSJLEffect = self.resultEffect:Find("CSJL"):GetComponent("SkeletonGraphic");
    self.CYGGEffect = self.resultEffect:Find("CYGG"):GetComponent("SkeletonGraphic");
    self.JYMTEffect = self.resultEffect:Find("JYMT"):GetComponent("SkeletonGraphic");
    --self.EnterFreeEffect = self.resultEffect:Find("EnterFree"):GetComponent("SkeletonGraphic");
    self.CSJLResult = self.resultEffect:Find("CSJLWin"):GetComponent("SkeletonGraphic");
    self.CSJLResultWin = self.CSJLResult.transform:Find("WinNum"):GetComponent("TextMeshProUGUI");

    self.icons = self.transform:Find("Content/Icons");--图标库
    self.effectList = self.transform:Find("Content/EffectList");--动画库
    self.effectPool = self.transform:Find("Content/EffectPool");--动画缓存库
    self.LineGroup = self.transform:Find("Content/LineGroup");--连线
    self.CSGroup = self.transform:Find("Content/CSContent");--显示财神
    self.soundList = self.transform:Find("Content/SoundList");--声音库

    self.WinGold=self.transform:Find("Content/WinGold") --界面显示金币
    self.WinGoldText=self.WinGold:Find("Text"):GetComponent("TextMeshProUGUI")
    self.WinGold.gameObject:SetActive(false)

    --self.smallGamePanel = self.transform:Find("SmallGamePanel") 
    --Module13_SmallGamePanel.Init(self.smallGamePanel)
    self.startBtn.AnimationState:SetAnimation(0, "idle", true);

    self.TipPanel=self.transform:Find("Content/TipPanel")
    self.TipPanel.gameObject:SetActive(false)
    for i=1,self.TipPanel.childCount do
        self.TipPanel:GetChild(i-1).gameObject:SetActive(false)
    end
end
function Module13Entry.AddListener()
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
    self.closeMenu.onClick:RemoveAllListeners();
    self.closeMenu.onClick:AddListener(self.CloseMenuCall);
    self.closeGame.onClick:RemoveAllListeners();
    self.closeGame.onClick:AddListener(self.CloseGameCall);

    self.musicBtn.onClick:RemoveAllListeners();
    self.musicBtn.onClick:AddListener(self.SetMusicCall);

    self.soundBtn.onClick:RemoveAllListeners();
    self.soundBtn.onClick:AddListener(self.SetSoundCall);

    self.AutoStartBtn.onClick:RemoveAllListeners();
    self.AutoStartBtn.onClick:AddListener(self.OnClickAutoCall);
    for i = 1, #Module13_DataConfig.autoList do
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
        if Module13_DataConfig.autoList[i] > 1000 then
            child:Find("Infinite").gameObject:SetActive(true);
            child:Find("Num").gameObject:SetActive(false);
        else
            child:Find("Infinite").gameObject:SetActive(false);
            --child:Find("Num").gameObject:SetActive(false);
            child:Find("Num"):GetComponent("TextMeshProUGUI").text = self.ShowText(Module13_DataConfig.autoList[i]);
        end
        child.gameObject.name = tostring(Module13_DataConfig.autoList[i]);
        child:GetComponent("Button").onClick:RemoveAllListeners();
        child:GetComponent("Button").onClick:AddListener(function()
            self.currentAutoCount = Module13_DataConfig.autoList[i];
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

end
function Module13Entry.GetGameConfig()
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
        Module13_DataConfig.rollTime = data.rollTime;
        Module13_DataConfig.rollReboundRate = data.rollReboundRate;
        Module13_DataConfig.rollInterval = data.rollInterval;
        Module13_DataConfig.rollSpeed = data.rollSpeed;
        Module13_DataConfig.caijinGoldChangeRate = data.caijinGoldChangeRate;
        Module13_DataConfig.winGoldChangeRate = data.winGoldChangeRate;
        Module13_DataConfig.selfGoldChangeRate = data.selfGoldChangeRate;
        Module13_DataConfig.freeLoadingShowTime = data.freeLoadingShowTime;
        Module13_DataConfig.smallGameLoadingShowTime = data.smallGameLoadingShowTime;
        Module13_DataConfig.rollDistance = data.rollDistance;
        Module13_DataConfig.REQCaiJinTime = data.REQCaiJinTime;
        Module13_DataConfig.lineAllShowTime = data.lineAllShowTime;
        Module13_DataConfig.cyclePlayLineTime = data.cyclePlayLineTime;
        Module13_DataConfig.waitShowLineTime = data.waitShowLineTime;
        Module13_DataConfig.autoRewardInterval = data.autoRewardInterval;
        Module13_DataConfig.autoNoRewardInterval = data.autoNoRewardInterval;
    end);
end
function Module13Entry.ToCharArray(num)
    --拆解字符串
    local str = tostring(num);
    local list1 = {}
    for i = 1, string.len(str) do
        table.insert(list1, #list1 + 1, string.sub(str, i, i));
    end
    return list1;
end
function Module13Entry.FormatNumberThousands(num)
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
function Module13Entry.ShowText(str)
    --展示tmp字体
    local arr = self.ToCharArray(str);
    local _str = "";
    for i = 1, #arr do
        _str = _str .. string.format("<sprite name=\"%s\">", arr[i]);
    end
    return _str;
end
function Module13Entry.ReduceChipCall()
    --减注
    Module13_Audio.PlaySound(Module13_Audio.SoundList.BTN);
    if self.SceneData.chipList == nil or #self.SceneData.chipList <= 0 then
        return ;
    end
    self.CurrentChipIndex = self.CurrentChipIndex - 1;
    if self.CurrentChipIndex <= 0 then
        self.CurrentChipIndex = #self.SceneData.chipList;
    end
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.FormatNumberThousands(self.CurrentChip));
end
function Module13Entry.AddChipCall()
    --加注
    Module13_Audio.PlaySound(Module13_Audio.SoundList.BTN);
    if self.SceneData.chipList == nil or #self.SceneData.chipList <= 0 then
        return ;
    end
    self.CurrentChipIndex = self.CurrentChipIndex + 1;
    if self.CurrentChipIndex > #self.SceneData.chipList then
        self.CurrentChipIndex = 1;
    end
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.FormatNumberThousands(self.CurrentChip));
end
function Module13Entry.StartGameCall()
    --开始游戏
        if self.isFreeGame or self.isAutoGame or self.isFireMode  then
        return ;
    end
    if self.isRoll then
        --TODO 急停
        Module13_Roll.StopRoll();
        return ;
    end
    Module13_Audio.PlaySound(Module13_Audio.SoundList.BTN);
     self.startBtn.AnimationState:SetAnimation(0, "click", false);--点击
     self.startBtn.AnimationState:AddAnimation(0, "idle", true, 0);--播放闲置动画
    --TODO 发送开始消息,等待结果开始转动
    Module13_Network.StartGame();
end
function Module13Entry.ClickMenuCall()
    --点击显示菜单
    Module13_Audio.PlaySound(Module13_Audio.SoundList.BTN);
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
function Module13Entry.CloseMenuCall()
    --关闭菜单
    Module13_Audio.PlaySound(Module13_Audio.SoundList.BTN);
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
function Module13Entry.CloseGameCall()

    if self.isFireMode or self.isFreeGame then
        MessageBox.CreatGeneralTipsPanel("Unable to quit the game in special games")
        return
    end
    self.isFireMode=false
    self.isFreeGame=false
    self.isAutoGame=false
    Event.Brocast(MH.Game_LEAVE);
end
function Module13Entry.SetSelfGold(str)
    self.selfGold.text = self.ShowText(self.FormatNumberThousands(str));
end
function Module13Entry.SetSoundCall()
    if MusicManager:GetIsPlaySV() then
        --HallScenPanel.PlayeBtnMusic();
        SetInfoSystem.MuteSound();
        self.soundOn:SetActive(false);
        self.soundOff:SetActive(true);
    else
        SetInfoSystem.PlaySound();
        self.soundOn:SetActive(true);
        self.soundOff:SetActive(false);
    end
end

function Module13Entry.SetMusicCall()
    if MusicManager:GetIsPlayMV() then
        SetInfoSystem.MuteMusic();
        self.musicOn:SetActive(false);
        self.musicOff:SetActive(true);
    else
        SetInfoSystem.PlayMusic();
        self.musicOn:SetActive(true);
        self.musicOff:SetActive(false);
    end
    Module13_Audio.pool.mute = not MusicManager:GetIsPlayMV();
end
function Module13Entry.OnClickAutoCall()
    --点击自动开始
    Module13_Audio.PlaySound(Module13_Audio.SoundList.BTN);
    if self.isAutoGame then
        self.StopAutoGame();
        return ;
    end
    self.closeAutoMenu.gameObject:SetActive(true);
end
function Module13Entry.OnClickAutoItemCall()
    --点击选择自动次数
    Module13_Audio.PlaySound(Module13_Audio.SoundList.BTN);
    self.isAutoGame = true;
    self.AutoStartBtn.transform:Find("On").gameObject:SetActive(true);
    self.AutoStartBtn.transform:Find("Off").gameObject:SetActive(false);
    self.closeAutoMenu.gameObject:SetActive(false);
    if not self.isFreeGame or not self.isFireMode then
         self.startBtn.AnimationState:SetAnimation(0, "automatic", true);
         self.startBtn.transform:Find("AutoState").gameObject:SetActive(true);
         self.startBtn.transform:Find("Image").gameObject:SetActive(false);
    end
    local autonum = self.startBtn.transform:Find("AutoState/AutoNum");
    local infinite = self.startBtn.transform:Find("AutoState/Infinite");
    if self.currentAutoCount > 1000 then
        autonum.gameObject:SetActive(false);
        infinite.gameObject:SetActive(true);
    else
        autonum.gameObject:SetActive(true);
        infinite.gameObject:SetActive(false);
        autonum:GetComponent("TextMeshProUGUI").text = self.ShowText(self.currentAutoCount);
    end
    if not self.isRoll and not self.isFreeGame and not self.isFireMode then
        --没有转动的状态开始自动旋转
        Module13_Network.StartGame();
    end
end
function Module13Entry.ShowRultPanel()
    --显示规则
    Module13_Audio.PlaySound(Module13_Audio.SoundList.BTN);
    Module13_Rule.ShowRule();
end
function Module13Entry.SetMaxChipCall()
    --设置最大下注
    Module13_Audio.PlaySound(Module13_Audio.SoundList.BTN);
    self.CurrentChipIndex = #self.SceneData.chipList;
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.FormatNumberThousands(self.CurrentChip));
end

function Module13Entry.CSJLRoll()
    Module13_Network.StartGame();
end
function Module13Entry.StopAutoGame()
    --停止自动旋转
    self.isAutoGame = false;
    self.currentAutoCount = 0;
    self.startBtn.transform:Find("AutoState").gameObject:SetActive(false);
    self.startBtn.transform:Find("Image").gameObject:SetActive(false);

    self.startBtn.AnimationState:SetAnimation(0, "idle", true);
    self.AutoStartBtn.transform:Find("On").gameObject:SetActive(false);
    self.AutoStartBtn.transform:Find("Off").gameObject:SetActive(true);
end
function Module13Entry.FreeGame()
    --免费游戏
    self.isFreeGame = true;
    self.startBtn.transform:Find("AutoState").gameObject:SetActive(false);
    self.startBtn.transform:Find("Free").gameObject:SetActive(true);
    self.startBtn.transform:Find("Free/Num"):GetComponent("TextMeshProUGUI").text = self.ShowText(self.freeCount);
    self.startBtn.AnimationState:SetAnimation(0, "freetimes", true);
    Module13_Network.StartGame();
end

function Module13Entry.FireMode()
    logYellow("========烈焰模式==========")
    self.startBtn.transform:Find("AutoState").gameObject:SetActive(false);
    self.startBtn.transform:Find("Image").gameObject:SetActive(true);
    self.startBtn.transform:Find("Free").gameObject:SetActive(false);
    self.startBtn.AnimationState:SetAnimation(0, "freetimes", true);
    Module13_Network.StartGame();
end

function Module13Entry.Roll()
    --开始转动    
   -- Module13_Audio.PlaySound(Module13_Audio.SoundList.GO);
    if not self.isFreeGame and not Module13_Result.isWinCSJL and not self.isFireMode then
        self.myGold = self.myGold - self.CurrentChip * Module13_DataConfig.ALLLINECOUNT;
        self.selfGold.text = self.ShowText(self.FormatNumberThousands(self.myGold));
    end
    logYellow("isFireMode=="..tostring(self.isFireMode))
    if self.isFireMode and Module13_Result.IsFireMode then
        Module13Entry.CSGroup.gameObject:SetActive(true);
        for i=1,Module13Entry.CSGroup.childCount do
            Module13Entry.CSGroup:GetChild(i-1):Find("lizi").gameObject:SetActive(true)
        end
    else
        Module13Entry.CSGroup.gameObject:SetActive(false);
    end

    self.WinNum.text = self.ShowText(0);
    self.WinGoldText.text=self.ShowText(0)

    Module13_Result.HideResult();
    Module13_Line.Close();
    Module13_Roll.StartRoll();
end
function Module13Entry.OnStop()
    --停止转动
    log("停止")
    Module13_Audio.StopPlaySound(Module13_Audio.SoundList.StarRoll)

    Module13Entry.CSGroup.gameObject:SetActive(false);

    for i=1,Module13Entry.CSGroup.childCount do
        Module13Entry.CSGroup:GetChild(i-1).gameObject:SetActive(true);
        Module13Entry.CSGroup:GetChild(i-1):Find("lizi").gameObject:SetActive(false)
    end

    Module13_Result.ShowResult();
end
function Module13Entry.InitPanel()
    --场景消息初始化
    self.myGold = TableUserInfo._7wGold;
    self.selfGold.text = self.ShowText(self.FormatNumberThousands(self.myGold));
    for i = 1, #self.SceneData.chipList do
        if self.SceneData.chipList[i] == self.SceneData.bet then
            self.CurrentChipIndex = i;
            self.CurrentChip = self.SceneData.bet;
            self.ChipNum.text = self.ShowText(self.FormatNumberThousands(self.CurrentChip));
        end
    end
    self.WinNum.text = self.ShowText(0);
    self.WinGoldText.text=self.ShowText(0)

    Module13_Caijin.isCanSend = true;
    self.isRoll = false;
    Module13_Line.Init();
    Module13_Result.Init();
    if Module13Entry.SceneData.bFireMode == 1 then
        self.isFireMode=true
        self.startBtn.AnimationState:SetAnimation(0, "freetimes", true);
        Module13_Result.ShowFireModeEffect(true)
        return
    end

    if self.SceneData.freeNumber > 0 then
        --如果免费
        self.freeCount = self.SceneData.freeNumber;
        self.isFreeGame = true;

        --Module13_Audio.PlayBGM(Module13_Audio.SoundList.BJ_Free);

        self.startBtn.AnimationState:SetAnimation(0, "freetimes", true);

        Module13_Result.ShowFreeEffect(true);
    end
end

function Module13Entry.FreeRoll()
    logYellow("=====判断是否为免费游戏===="..tostring(self.isFreeGame))
    --判断是否为免费游戏
    Module13_Result.isShow = false;
    if self.isFireMode then
        Module13Entry.FireMode()
        Module13_Audio.PlayBGM(Module13_Audio.SoundList.BJ_SGame)
        return
    else
        self.FreeContent.gameObject:SetActive(false);
        self.isFreeGame = false;
        Module13Entry.addChipBtn.interactable = true;
        Module13Entry.reduceChipBtn.interactable = true;
        Module13Entry.MaxChipBtn.interactable = true;
       -- Module13_Audio.PlayBGM();
    end

    if self.isFreeGame then
        self.freeCount = self.freeCount - 1;
        if self.freeCount < 0 then
            --免费结束
            if Module13_Result.showFreeTweener ~= nil then
                Module13_Result.showFreeTweener:Kill();
                Module13_Result.showFreeTweener = nil;
            end
            self.FreeContent.gameObject:SetActive(false);
            self.isFreeGame = false;
            Module13Entry.addChipBtn.interactable = true;
            Module13Entry.reduceChipBtn.interactable = true;
            Module13Entry.MaxChipBtn.interactable = true;
            --Module13_Audio.PlayBGM();
            self.AutoRoll();
        else
            --还有免费次数
            self.FreeGame();
            Module13_Audio.PlayBGM(Module13_Audio.SoundList.BJ_Free)

        end
    else
        self.AutoRoll();
    end
end
function Module13Entry.AutoRoll()
    --判断是否为自动游戏
    if self.isAutoGame then
        --如果是自动游戏
        if self.currentAutoCount < 1000 then
            self.currentAutoCount = self.currentAutoCount - 1;
        end
        if self.currentAutoCount < 0 then
            --自动次数使用完了，回到待机状态
            self.StopAutoGame();
        else
            --还有自动次数
            self.OnClickAutoItemCall();
        end
    else
        --不是自动游戏，直接待机
        self.StopAutoGame();
    end
end