-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion
local ModuleNum = "Module28/fulinmen/";

require(ModuleNum .. "FLM_Network")
require(ModuleNum .. "FLM_Roll")
require(ModuleNum .. "FLM_DataConfig")
require(ModuleNum .. "FLM_Line")
require(ModuleNum .. "FLM_Caijin")
require(ModuleNum .. "FLM_Result")
require(ModuleNum .. "FLM_Rule")
require(ModuleNum .. "FLM_Audio")

FLMEntry = {};
local self = FLMEntry;
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

self.SceneData = {
    bet = 0, --当前下注
    chipList = {}, --下注列表
    fuTimes = {}, --大福小福的倍数
    ImgTable = {}, --图标
    LineTypeTable = {}, --连线类型
    fuType = {}, --大幅 幅满 小幅
    GoldNum = {}, --开奖的时候 如果是金币图标上面要显示数字和文字
    WinScore = 0,
    FreeCount = 0, --免费次数
    GoldModeNum = 0, --堆金积玉的次数
    allOpenRate = 0,
};
self.ResultData = {
    ImgTable = {}, --图标
    LineTypeTable = {}, --连线类型
    fuType = {},
    GoldNum = {},
    WinScore = 0,
    FreeCount = 0, --免费次数
    GoldModeNum = 0, --金币模式次数
    allOpenRate = 0,
}
function FLMEntry:Awake(obj)
    Screen.orientation = UnityEngine.ScreenOrientation.Landscape;
    Screen.autorotateToLandscapeLeft = true;
    Screen.autorotateToLandscapeRight = true;
    Screen.autorotateToPortrait = false;
    Screen.autorotateToPortraitUpsideDown = false;
    self.transform = obj.transform;
    self.gameObject = obj.gameObject;
    self.GetGameConfig();
    self.FindComponent();
    self.AddListener();
    FLM_Roll.Init(self.RollContent);
    FLM_Audio.Init();
    FLM_Network.AddMessage();--添加消息监听
    FLM_Network.LoginGame();--开始登录游戏
    GameSetsPanel.CreateHideObj(self.transform, false);
    FLM_Audio.PlayBGM();
end
function FLMEntry.OnDestroy()
    FLM_Line.Close();
    FLM_Network.UnMessage();
end
function FLMEntry:Update()
    FLM_Roll.Update();
    FLM_Caijin.Update();
    FLM_Line.Update();
    FLM_Result.Update();
end
function FLMEntry.FindComponent()
    self.MosaicNum = self.transform:Find("Content/Mosaic/MosaicNum"):GetComponent("TextMeshProUGUI");--彩金
    self.DFMosaicNum = self.transform:Find("Content/Mosaic/D"):GetComponent("TextMeshProUGUI");
    self.XFMosaicNum = self.transform:Find("Content/Mosaic/X"):GetComponent("TextMeshProUGUI");
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
    self.startBtn.AnimationState:SetAnimation(0, "idle", true);--播放闲置动画

    self.MaxChipBtn = self.btnGroup:Find("MaxChip"):GetComponent("Button");--最大下注
    self.AutoStartBtn = self.btnGroup:Find("AutoStart"):GetComponent("Button");--打开自动开始界面
    self.closeAutoMenu = self.btnGroup:Find("CloseAutoMenu"):GetComponent("Button");--关闭自动开始界面
    self.autoSelectList = self.closeAutoMenu.transform:Find("AutoSelect");--自动开始次数选择
    self.closeAutoMenu.gameObject:SetActive(false);
    self.AutoStartBtn.transform:Find("On").gameObject:SetActive(false);
    self.AutoStartBtn.transform:Find("Off").gameObject:SetActive(true);

    self.rulePanel = self.transform:Find("Content/Rule");--规则界面
    self.ruleList = self.rulePanel:Find("Content/RuleList"):GetComponent("ScrollRect");--规则子界面
    self.leftShowBtn = self.rulePanel:Find("Content/LeftBtn"):GetComponent("Button");
    self.rightShowBtn = self.rulePanel:Find("Content/RightBtn"):GetComponent("Button");
    self.closeRuleBtn = self.rulePanel:Find("Content/BackBtn"):GetComponent("Button");
    self.pageDesc = self.rulePanel:Find("Content/Page"):GetComponent("TextMeshProUGUI");--规则子界面

    self.menuBtn = self.transform:Find("Content/Menu"):GetComponent("Button");--菜单按钮
    self.menulist = self.transform:Find("Content/MenuList");--菜单按钮详情
    self.backgroundBtn = self.transform:Find("Content/CloseMenu"):GetComponent("Button");
    self.closeMenu = self.menulist:Find("Content/Close"):GetComponent("Button");
    self.closeGame = self.menulist:Find("Content/Back"):GetComponent("Button");
    self.soundBtn = self.menulist:Find("Content/Sound"):GetComponent("Button");
    self.soundOn = self.soundBtn.transform:Find("On").gameObject;
    self.soundOff = self.soundBtn.transform:Find("Off").gameObject;
    self.soundOn:SetActive(MusicManager:GetIsPlaySV() and MusicManager:GetIsPlayMV());
    self.soundOff:SetActive(not (MusicManager:GetIsPlaySV() and MusicManager:GetIsPlayMV()));
    self.showRuleBtn = self.menulist:Find("Content/Rule"):GetComponent("Button");
    self.menulist:Find("Content").localPosition = Vector3.New(0, 800, 0);
    self.backgroundBtn.gameObject:SetActive(false);

    self.resultEffect = self.transform:Find("Content/Result");--中奖后特效
    self.winNormalEffect = self.resultEffect:Find("Reward"):GetComponent("SkeletonGraphic");
    self.winNormalNum = self.winNormalEffect.transform:Find("RewardNum"):GetComponent("TextMeshProUGUI");
    self.DJJYEffect = self.resultEffect:Find("DJJY"):GetComponent("SkeletonGraphic");
    self.WFQQEffect = self.resultEffect:Find("WFQQ"):GetComponent("SkeletonGraphic");
    self.WFQQNum = self.WFQQEffect.transform:Find("Num"):GetComponent("TextMeshProUGUI");
    self.FXGZEffect = self.resultEffect:Find("FXGZ"):GetComponent("SkeletonGraphic");
    self.FXGZNum = self.FXGZEffect.transform:Find("Num"):GetComponent("TextMeshProUGUI");
    self.FMTEffect = self.resultEffect:Find("FMT"):GetComponent("SkeletonGraphic");
    self.FMTNum = self.FMTEffect.transform:Find("Num"):GetComponent("TextMeshProUGUI");
    self.FLSQEffect = self.resultEffect:Find("FLSQ"):GetComponent("SkeletonGraphic");
    self.FLSQNum = self.FLSQEffect.transform:Find("Num"):GetComponent("TextMeshProUGUI");
    self.BFJZEffect = self.resultEffect:Find("BFJZ"):GetComponent("SkeletonGraphic");
    self.BFJZNum = self.BFJZEffect.transform:Find("Num"):GetComponent("TextMeshProUGUI");
    self.EnterFreeEffect = self.resultEffect:Find("EnterFree"):GetComponent("SkeletonGraphic");
    self.FreeResultEffect = self.resultEffect:Find("FreeResult"):GetComponent("SkeletonGraphic");
    -- self.FreeResultNum = self.FreeResultEffect.transform:Find("Num"):GetComponent("TextMeshProUGUI");

    self.icons = self.transform:Find("Content/Icons");--图标库
    self.effectList = self.transform:Find("Content/EffectList");--动画库
    self.effectPool = self.transform:Find("Content/EffectPool");--动画缓存库
    self.LineGroup = self.transform:Find("Content/LineGroup");--连线
    self.CSGroup = self.transform:Find("Content/CSContent");--显示财神
    self.soundList = self.transform:Find("Content/SoundList");--声音库

end

function FLMEntry.SetSelfGold(str)
    self.selfGold.text = self.ShowText(self.FormatNumberThousands(str));
end
function FLMEntry.AddListener()
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
    self.soundBtn.onClick:RemoveAllListeners();
    self.soundBtn.onClick:AddListener(self.SetSoundCall);

    self.AutoStartBtn.onClick:RemoveAllListeners();
    self.AutoStartBtn.onClick:AddListener(self.OnClickAutoCall);
    for i = 1, #FLM_DataConfig.autoList do
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
        if FLM_DataConfig.autoList[i] > 1000 then
            child:Find("Infinite").gameObject:SetActive(true);
            child:Find("Num").gameObject:SetActive(false);
        else
            child:Find("Infinite").gameObject:SetActive(false);
            child:Find("Num").gameObject:SetActive(true);
            child:Find("Num"):GetComponent("TextMeshProUGUI").text = self.ShowText(FLM_DataConfig.autoList[i]);
        end
        child.gameObject.name = tostring(FLM_DataConfig.autoList[i]);
        child:GetComponent("Button").onClick:RemoveAllListeners();
        child:GetComponent("Button").onClick:AddListener(function()
            self.currentAutoCount = FLM_DataConfig.autoList[i];
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
function FLMEntry.GetGameConfig()
    --获取远程端配置
    local formdata = FormData.New();
    formdata:AddField("v", os.time());
    local url = string.gsub(AppConst.WebUrl, "/android", "");
    url = string.gsub(url, "/iOS", "");
    url = string.gsub(url, "/ios", "");
    url = string.gsub(url, "/win32", "");
    url = string.gsub(url, "/win", "");
    UnityWebRequestManager.Instance:GetText(url .. "Config/module28.json", 4, formdata, function(state, result)
        log(result);
        if state == 200 then
            local data = json.decode(result);
            FLM_DataConfig.rollTime = data.rollTime;
            FLM_DataConfig.rollReboundRate = data.rollReboundRate;
            FLM_DataConfig.rollInterval = data.rollInterval;
            FLM_DataConfig.rollSpeed = data.rollSpeed;
            FLM_DataConfig.caijinGoldChangeRate = data.caijinGoldChangeRate;
            FLM_DataConfig.winGoldChangeRate = data.winGoldChangeRate;
            FLM_DataConfig.selfGoldChangeRate = data.selfGoldChangeRate;
            FLM_DataConfig.freeLoadingShowTime = data.freeLoadingShowTime;
            FLM_DataConfig.smallGameLoadingShowTime = data.smallGameLoadingShowTime;
            FLM_DataConfig.rollDistance = data.rollDistance;
            FLM_DataConfig.REQCaiJinTime = data.REQCaiJinTime;
            FLM_DataConfig.lineAllShowTime = data.lineAllShowTime;
            FLM_DataConfig.cyclePlayLineTime = data.cyclePlayLineTime;
            FLM_DataConfig.waitShowLineTime = data.waitShowLineTime;
            FLM_DataConfig.autoRewardInterval = data.autoRewardInterval;
            FLM_DataConfig.autoNoRewardInterval = data.autoNoRewardInterval;
        end
    end);
end
function FLMEntry.ToCharArray(num)
    --拆解字符串
    local str = tostring(num);
    local list1 = {}
    for i = 1, string.len(str) do
        table.insert(list1, #list1 + 1, string.sub(str, i, i));
    end
    return list1;
end
function FLMEntry.FormatNumberThousands(num)
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
function FLMEntry.ShowText(str)
    --展示tmp字体
    local arr = self.ToCharArray(str);
    local _str = "";
    for i = 1, #arr do
        _str = _str .. string.format("<sprite name=\"%s\">", arr[i]);
    end
    return _str;
end
function FLMEntry.ReduceChipCall()
    --减注
    FLM_Audio.PlaySound(FLM_Audio.SoundList.BTN);
    if self.SceneData.chipList == nil or #self.SceneData.chipList <= 0 then
        return ;
    end
    self.CurrentChipIndex = self.CurrentChipIndex - 1;
    if self.CurrentChipIndex <= 0 then
        self.CurrentChipIndex = #self.SceneData.chipList;
    end
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.FormatNumberThousands(self.CurrentChip * FLM_DataConfig.ALLLINECOUNT));
end
function FLMEntry.AddChipCall()
    --加注
    FLM_Audio.PlaySound(FLM_Audio.SoundList.BTN);
    if self.SceneData.chipList == nil or #self.SceneData.chipList <= 0 then
        return ;
    end
    self.CurrentChipIndex = self.CurrentChipIndex + 1;
    if self.CurrentChipIndex > #self.SceneData.chipList then
        self.CurrentChipIndex = 1;
    end
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.FormatNumberThousands(self.CurrentChip * FLM_DataConfig.ALLLINECOUNT));
end
function FLMEntry.StartGameCall()
    --开始游戏
    if self.isFreeGame or self.isAutoGame then
        return ;
    end
    if self.isRoll then
        --TODO 急停
        FLM_Roll.StopRoll();
        return ;
    end
    FLM_Audio.PlaySound(FLM_Audio.SoundList.BTN);
    self.startBtn.AnimationState:SetAnimation(0, "click", false);--点击
    self.startBtn.AnimationState:AddAnimation(0, "idle", true, 0);--播放闲置动画
    if self.myGold < self.CurrentChip * FLM_DataConfig.ALLLINECOUNT then
        MessageBox.CreatGeneralTipsPanel("Not enough gold!");
        return ;
    end
    --TODO 发送开始消息,等待结果开始转动
    FLM_Network.StartGame();
end
function FLMEntry.ClickMenuCall()
    --点击显示菜单
    FLM_Audio.PlaySound(FLM_Audio.SoundList.BTN);
    if self.menuTweener ~= nil then
        self.menuTweener:Kill();
    end
    self.backgroundBtn.gameObject:SetActive(true);
    self.backgroundBtn.interactable = false;
    local rect = self.menulist:GetComponent("RectTransform").sizeDelta;
    self.menuTweener = self.menulist:Find("Content"):DOLocalMove(Vector3.New(0, rect.y / 2, 0), 0.5):OnComplete(function()
        self.backgroundBtn.interactable = true;
        if self.menuTweener ~= nil then
            self.menuTweener = nil;
        end
    end);
    if self.menuTweener ~= nil then
        self.menuTweener:SetAutoKill();
    end
end
function FLMEntry.CloseMenuCall()
    --关闭菜单
    FLM_Audio.PlaySound(FLM_Audio.SoundList.BTN);
    if self.menuTweener ~= nil then
        self.menuTweener:Kill();
    end
    self.backgroundBtn.interactable = false;
    self.menuTweener = self.menulist:Find("Content"):DOLocalMove(Vector3.New(0, 800, 0), 0.5):OnComplete(function()
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
function FLMEntry.CloseGameCall()
    if self.isFreeGame or FLM_Result.isDJJY then
        MessageBox.CreatGeneralTipsPanel("Unable to quit the game in special games")
        return
    end
    Event.Brocast(MH.Game_LEAVE);
end
function FLMEntry.SetSoundCall()
    if MusicManager:GetIsPlayMV() then
        SetInfoSystem.GameMute();
        self.soundOn:SetActive(false);
        self.soundOff:SetActive(true);
    else
        SetInfoSystem.ResetMute();
        self.soundOn:SetActive(true);
        self.soundOff:SetActive(false);
    end
    FLM_Audio.pool.mute = not MusicManager:GetIsPlayMV();
end

function FLMEntry.OnClickAutoCall()
    --点击自动开始
    FLM_Audio.PlaySound(FLM_Audio.SoundList.BTN);
    if self.isAutoGame then
        self.StopAutoGame();
        return ;
    end
    self.closeAutoMenu.gameObject:SetActive(true);
end
function FLMEntry.OnClickAutoItemCall()
    --点击选择自动次数
    FLM_Audio.PlaySound(FLM_Audio.SoundList.BTN);
    self.isAutoGame = true;
    self.AutoStartBtn.transform:Find("On").gameObject:SetActive(true);
    self.AutoStartBtn.transform:Find("Off").gameObject:SetActive(false);
    self.closeAutoMenu.gameObject:SetActive(false);
    if not self.isFreeGame then
        if self.myGold < self.CurrentChip * FLM_DataConfig.ALLLINECOUNT then
            MessageBox.CreatGeneralTipsPanel("Not enough gold!");
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
        autonum:GetComponent("TextMeshProUGUI").text = self.ShowText(self.currentAutoCount);
    end
    if not self.isRoll and not self.isFreeGame then
        --没有转动的状态开始自动旋转
        FLM_Network.StartGame();
    end
end
function FLMEntry.ShowRultPanel()
    --显示规则
    FLM_Audio.PlaySound(FLM_Audio.SoundList.BTN);
    FLM_Rule.ShowRule();
end
function FLMEntry.SetMaxChipCall()
    --设置最大下注
    FLM_Audio.PlaySound(FLM_Audio.SoundList.BTN);
    self.CurrentChipIndex = #self.SceneData.chipList;
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.FormatNumberThousands(self.CurrentChip * FLM_DataConfig.ALLLINECOUNT));
end

function FLMEntry.DJJYRoll()
    self.MaxChipBtn.interactable = false;
    self.addChipBtn.interactable = false;
    self.reduceChipBtn.interactable = false;
    self.startBtn.AnimationState:SetAnimation(0, "automatic", true);
    self.startBtn.transform:Find("AutoState").gameObject:SetActive(true);
    self.startBtn.transform:Find("Free").gameObject:SetActive(false);
    local autonum = self.startBtn.transform:Find("AutoState/AutoNum");
    local infinite = self.startBtn.transform:Find("AutoState/Infinite");
    autonum.gameObject:SetActive(true);
    infinite.gameObject:SetActive(false);
    autonum:GetComponent("TextMeshProUGUI").text = self.ShowText(self.ResultData.GoldModeNum - 1);
    FLM_Network.StartGame();
end
function FLMEntry.StopAutoGame()
    --停止自动旋转
    self.isAutoGame = false;
    self.MaxChipBtn.interactable = true;
    self.addChipBtn.interactable = true;
    self.reduceChipBtn.interactable = true;
    self.currentAutoCount = 0;
    self.startBtn.transform:Find("AutoState").gameObject:SetActive(false);
    self.startBtn.AnimationState:SetAnimation(0, "idle", true);
    self.AutoStartBtn.transform:Find("On").gameObject:SetActive(false);
    self.AutoStartBtn.transform:Find("Off").gameObject:SetActive(true);
end
function FLMEntry.FreeGame()
    --免费游戏
    FLMEntry.isRoll = false;
    self.isFreeGame = true;
    self.MaxChipBtn.interactable = false;
    self.addChipBtn.interactable = false;
    self.reduceChipBtn.interactable = false;
    self.startBtn.transform:Find("AutoState").gameObject:SetActive(false);
    self.startBtn.transform:Find("Free").gameObject:SetActive(true);
    self.startBtn.transform:Find("Free/Num"):GetComponent("TextMeshProUGUI").text = self.ShowText(self.freeCount);
    self.startBtn.AnimationState:SetAnimation(0, "freetime", true);
    FLM_Network.StartGame();
end
function FLMEntry.Roll()
    --开始转动    
    FLM_Audio.PlaySound(FLM_Audio.SoundList.GO);
    if not self.isFreeGame and not FLM_Result.isDJJY then
        self.myGold = self.myGold - self.CurrentChip * FLM_DataConfig.ALLLINECOUNT;
        self.selfGold.text = self.ShowText(self.FormatNumberThousands(self.myGold));
    end
    self.WinNum.text = self.ShowText(0);
    FLM_Result.HideResult();
    FLM_Line.Close();
    FLM_Roll.StartRoll();
end
function FLMEntry.OnStop()
    --停止转动
    log("停止")
    FLM_Result.ShowResult();
end
function FLMEntry.InitPanel()
    --场景消息初始化
    self.myGold = TableUserInfo._7wGold;
    self.selfGold.text = self.ShowText(self.FormatNumberThousands(self.myGold));
    self.XFMosaicNum.text = self.ShowText(self.FormatNumberThousands(self.SceneData.fuTimes[1]));
    self.DFMosaicNum.text = self.ShowText(self.FormatNumberThousands(self.SceneData.fuTimes[2]));
    for i = 1, #self.SceneData.chipList do
        if self.SceneData.chipList[i] == self.SceneData.bet then
            self.CurrentChipIndex = i;
            self.CurrentChip = self.SceneData.bet;
            self.ChipNum.text = self.ShowText(self.FormatNumberThousands(self.CurrentChip * FLM_DataConfig.ALLLINECOUNT));
        end
    end
    self.WinNum.text = self.ShowText(0);
    FLM_Caijin.isCanSend = true;
    self.isRoll = false;
    FLM_Line.Init();
    FLM_Result.Init();

    if self.SceneData.GoldModeNum > 0 then
        self.isRoll = true;
        FLM_Result.ShowResult();
    elseif self.SceneData.FreeCount > 0 then
        --如果免费
        self.isRoll = true;
        self.freeCount = self.SceneData.FreeCount;
        FLM_Result.CheckFree(true);
    end
end

function FLMEntry.FreeRoll()
    --判断是否为免费游戏
    FLM_Result.isShow = false;
    if self.isFreeGame then
        self.freeCount = self.freeCount - 1;
        if self.freeCount < 0 then
            --免费结束
            --if FLM_Result.showFreeTweener ~= nil then
            --    FLM_Result.showFreeTweener:Kill();
            --    FLM_Result.showFreeTweener = nil;
            --end
            self.FreeContent.gameObject:SetActive(false);
            self.isFreeGame = false;
            FLM_Audio.PlayBGM();
            self.AutoRoll();
        else
            --还有免费次数
            self.FreeGame();
        end
    else
        self.AutoRoll();
    end
end
function FLMEntry.AutoRoll()
    --判断是否为自动游戏
    if self.isAutoGame then
        --如果是自动游戏
        if self.currentAutoCount < 1000 then
            self.currentAutoCount = self.currentAutoCount - 1;
        end
        if self.currentAutoCount < 0 then
            --自动次数使用完了，回到待机状态
            FLMEntry.isRoll = false;
            self.StopAutoGame();
        else
            --还有自动次数
            FLMEntry.isRoll = false;
            self.OnClickAutoItemCall();
        end
    else
        --不是自动游戏，直接待机
        FLMEntry.isRoll = false;
        self.StopAutoGame();
    end
end