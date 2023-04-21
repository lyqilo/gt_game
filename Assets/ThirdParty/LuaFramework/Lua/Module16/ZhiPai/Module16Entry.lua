-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion
local Module16Num = "Module16/ZhiPai/";

require(Module16Num .. "Module16_Network")
require(Module16Num .. "Module16_Roll")
require(Module16Num .. "Module16_DataConfig")
require(Module16Num .. "Module16_Caijin")
require(Module16Num .. "Module16_Line")
require(Module16Num .. "Module16_Result")
require(Module16Num .. "Module16_Rule")
require(Module16Num .. "Module16_Audio")
require(Module16Num .. "Module16_SmallGamePanel")


Module16Entry = {};
local self = Module16Entry;
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

self.SceneData = {
    bet = 0, --当前下注
    freeNumber = 0, --免费次数
    GoldResult =0, 
    chipList = {}, --下注列表
    InsideGameResult={},
    InsideGameChoose={},
};
self.ResultData = {
    ImgTable = {}, --图标
    LineTypeTable = {}, --连线类型
    FreeCount = 0, --免费次数
    GameType = 0, --游戏类型
    WinScore = 0, --赢得总分
    isSmallGame=0,--是否小游戏
}
self.SmallGameReult = {
    WinScore = 0, --赢得总分
}

function Module16Entry:Awake(obj)
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
    Module16_Roll.Init(self.RollContent);
    Module16_Audio.Init();
    Module16_Network.AddMessage();--添加消息监听
    Module16_Network.LoginGame();--开始登录游戏
    GameSetsPanel.CreateHideObj(self.transform,false);
    Module16_Audio.PlayBGM();
end
function Module16Entry.OnDestroy()
    Module16_Line.Close();
    Module16_Network.UnMessage();
end
function Module16Entry:Update()
    Module16_Roll.Update();
    Module16_Caijin.Update();
    Module16_Line.Update();
    Module16_Result.Update();
    Module16_SmallGamePanel.Update()
end
function Module16Entry.FindComponent()
    self.MosaicNum = self.transform:Find("Content/Mosaic/MosaicNum"):GetComponent("TextMeshProUGUI");--彩金
    self.FreeRewardList = self.transform:Find("Content/FreeRewardList");--免费奖励表
    self.RollContent = self.transform:Find("Content/RollContent");--转动区域
    self.selfGold = self.transform:Find("Content/Bottom/Gold/Num"):GetComponent("TextMeshProUGUI");--自身金币
    self.ChipNum = self.transform:Find("Content/Bottom/Chip/Num"):GetComponent("TextMeshProUGUI");--下注金额
    self.WinNum = self.transform:Find("Content/Bottom/Win/Num"):GetComponent("TextMeshProUGUI");--本次获得金币

    self.reduceChipBtn = self.transform:Find("Content/Bottom/Chip/Reduce"):GetComponent("Button");--减注
    self.addChipBtn = self.transform:Find("Content/Bottom/Chip/Add"):GetComponent("Button");--加注

    self.btnGroup = self.transform:Find("Content/ButtonGroup");
    self.startBtn = self.btnGroup:Find("StartBtn")--:GetComponent("SkeletonGraphic");--开始按钮
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


    self.musicBtn = self.menulist:Find("Content/Sound"):GetComponent("Button");
    self.musicOn = self.musicBtn.transform:Find("On").gameObject;
    self.musicOff = self.musicBtn.transform:Find("Off").gameObject;
    self.musicOn:SetActive(MusicManager:GetIsPlayMV());
    self.musicOff:SetActive(not MusicManager:GetIsPlayMV());

    self.soundBtn = self.menulist:Find("Content/Music"):GetComponent("Button");
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
    self.WinGoldText.transform.localScale= Vector3.New(1.5,1.5,1.5);
    self.WinGold.gameObject:SetActive(false)

    self.smallGamePanel = self.transform:Find("SmallGamePanel") 
    Module16_SmallGamePanel.Init(self.smallGamePanel)

    self.TipPanel=self.transform:Find("Content/TipPanel")
    self.TipPanel.gameObject:SetActive(true)
    for i=1,self.TipPanel.childCount do
        self.TipPanel:GetChild(i-1).gameObject:SetActive(false)
    end
    self.EnterFreeEffect = self.TipPanel:Find("FreeGameTip/tip"):GetComponent("SkeletonGraphic");

end
function Module16Entry.AddListener()
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
    for i = 1, #Module16_DataConfig.autoList do
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
        if Module16_DataConfig.autoList[i] > 1000 then
            child:Find("Infinite").gameObject:SetActive(true);
            child:Find("Num").gameObject:SetActive(false);
        else
            child:Find("Infinite").gameObject:SetActive(false);
            child:Find("Num").gameObject:SetActive(false);
            child:Find("Num"):GetComponent("TextMeshProUGUI").text = ShowRichText(Module16_DataConfig.autoList[i]);
        end
        child.gameObject.name = tostring(Module16_DataConfig.autoList[i]);
        child:GetComponent("Button").onClick:RemoveAllListeners();
        child:GetComponent("Button").onClick:AddListener(function()
            self.currentAutoCount = Module16_DataConfig.autoList[i];
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
function Module16Entry.GetGameConfig()
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
        Module16_DataConfig.rollTime = data.rollTime;
        Module16_DataConfig.rollReboundRate = data.rollReboundRate;
        Module16_DataConfig.rollInterval = data.rollInterval;
        Module16_DataConfig.rollSpeed = data.rollSpeed;
        Module16_DataConfig.caijinGoldChangeRate = data.caijinGoldChangeRate;
        Module16_DataConfig.winGoldChangeRate = data.winGoldChangeRate;
        Module16_DataConfig.selfGoldChangeRate = data.selfGoldChangeRate;
        Module16_DataConfig.freeLoadingShowTime = data.freeLoadingShowTime;
        Module16_DataConfig.smallGameLoadingShowTime = data.smallGameLoadingShowTime;
        Module16_DataConfig.rollDistance = data.rollDistance;
        Module16_DataConfig.REQCaiJinTime = data.REQCaiJinTime;
        Module16_DataConfig.lineAllShowTime = data.lineAllShowTime;
        Module16_DataConfig.cyclePlayLineTime = data.cyclePlayLineTime;
        Module16_DataConfig.waitShowLineTime = data.waitShowLineTime;
        Module16_DataConfig.autoRewardInterval = data.autoRewardInterval;
        Module16_DataConfig.autoNoRewardInterval = data.autoNoRewardInterval;
    end);
end
function Module16Entry.ToCharArray(num)
    --拆解字符串
    local str = tostring(num);
    local list1 = {}
    for i = 1, string.len(str) do
        table.insert(list1, #list1 + 1, string.sub(str, i, i));
    end
    return list1;
end
function Module16Entry.FormatNumberThousands(num)
    return num;
    --对数字做千分位操作
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
function Module16Entry.ShowText(str)
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
function Module16Entry.ReduceChipCall()
    --减注
    Module16_Audio.PlaySound(Module16_Audio.SoundList.BTN);
    if self.SceneData.chipList == nil or #self.SceneData.chipList <= 0 then
        return ;
    end
    self.CurrentChipIndex = self.CurrentChipIndex - 1;
    if self.CurrentChipIndex <= 0 then
        self.CurrentChipIndex = #self.SceneData.chipList;
    end
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.FormatNumberThousands(self.CurrentChip*Module16_DataConfig.ALLLINECOUNT));
end
function Module16Entry.AddChipCall()
    --加注
    Module16_Audio.PlaySound(Module16_Audio.SoundList.BTN);
    if self.SceneData.chipList == nil or #self.SceneData.chipList <= 0 then
        return ;
    end
    self.CurrentChipIndex = self.CurrentChipIndex + 1;
    if self.CurrentChipIndex > #self.SceneData.chipList then
        self.CurrentChipIndex = 1;
    end
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.FormatNumberThousands(self.CurrentChip*Module16_DataConfig.ALLLINECOUNT));
end
function Module16Entry.StartGameCall()
    --开始游戏
    Module16_Audio.PlaySound(Module16_Audio.SoundList.BTN);
    if self.isFreeGame or self.isAutoGame then
        return ;
    end
    self.AutoStartBtn:GetComponent("Button").interactable = false        
    if self.isRoll then
        --TODO 急停
        Module16_Roll.StopRoll();
        self.startBtn:GetComponent("Button").interactable = false;
        return ;
    end
    -- self.startBtn.AnimationState:SetAnimation(0, "click", false);--点击
    -- self.startBtn.AnimationState:AddAnimation(0, "idle", true, 0);--播放闲置动画
    --TODO 发送开始消息,等待结果开始转动
    Module16_Network.StartGame();
end
function Module16Entry.ClickMenuCall()
    --点击显示菜单
    Module16_Audio.PlaySound(Module16_Audio.SoundList.BTN);
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
function Module16Entry.CloseMenuCall()
    --关闭菜单
    Module16_Audio.PlaySound(Module16_Audio.SoundList.BTN);
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
function Module16Entry.CloseGameCall()
    if self.isFreeGame or Module16Entry.ResultData.isSmallGame==1 then
        MessageBox.CreatGeneralTipsPanel("Unable to quit the game in special games")
        return
    end
    Event.Brocast(MH.Game_LEAVE);
end
function Module16Entry.SetSelfGold(str)
    self.selfGold.text = self.ShowText(self.FormatNumberThousands(str));
end
function Module16Entry.SetSoundCall()
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
    --PlayerPrefs.SetString("isCanPlaySound", tostring(AllSetGameInfo._6IsPlayEffect));
    --GameManager.SetIsPlayMute(AllSetGameInfo._6IsPlayEffect, AllSetGameInfo._5IsPlayAudio);

end

function Module16Entry.SetMusicCall()
    if MusicManager:GetIsPlayMV() then
        SetInfoSystem.MuteMusic();
        self.musicOn:SetActive(false);
        self.musicOff:SetActive(true);
    else
        SetInfoSystem.PlayMusic();
        self.musicOn:SetActive(true);
        self.musicOff:SetActive(false);
    end
    Module16_Audio.pool.mute = not MusicManager:GetIsPlayMV();
end
function Module16Entry.OnClickAutoCall()
    --点击自动开始
    Module16_Audio.PlaySound(Module16_Audio.SoundList.BTN);
    if self.isAutoGame then
        self.StopAutoGame();
        return ;
    end
    self.closeAutoMenu.gameObject:SetActive(true);
end
function Module16Entry.OnClickAutoItemCall()
    --点击选择自动次数
    Module16_Audio.PlaySound(Module16_Audio.SoundList.BTN);
    self.isAutoGame = true;
    self.AutoStartBtn.transform:Find("On").gameObject:SetActive(true);
    self.AutoStartBtn.transform:Find("Off").gameObject:SetActive(false);
    self.closeAutoMenu.gameObject:SetActive(false);

    if not self.isFreeGame then
        -- self.startBtn.AnimationState:SetAnimation(0, "automatic", true);
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
        autonum:GetComponent("TextMeshProUGUI").text = ShowRichText(self.currentAutoCount);
    end

    if not self.isRoll and not self.isFreeGame then
        --没有转动的状态开始自动旋转
        self.startBtn:GetComponent("Button").interactable = false;
        Module16_Network.StartGame();
    end
end
function Module16Entry.ShowRultPanel()
    --显示规则
    Module16_Audio.PlaySound(Module16_Audio.SoundList.BTN);
    Module16_Rule.ShowRule();
end
function Module16Entry.SetMaxChipCall()
    --设置最大下注
    Module16_Audio.PlaySound(Module16_Audio.SoundList.BTN);
    self.CurrentChipIndex = #self.SceneData.chipList;
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.FormatNumberThousands(self.CurrentChip)*Module16_DataConfig.ALLLINECOUNT);
end

function Module16Entry.CSJLRoll()
    Module16_Network.StartGame();
end
function Module16Entry.StopAutoGame()
    --停止自动旋转
    self.isAutoGame = false;
    self.currentAutoCount = 0;
    self.startBtn.transform:Find("AutoState").gameObject:SetActive(false);
    self.startBtn.transform:Find("Image").gameObject:SetActive(true);

    --self.startBtn.AnimationState:SetAnimation(0, "idle", true);
    self.AutoStartBtn.transform:Find("On").gameObject:SetActive(false);
    self.AutoStartBtn.transform:Find("Off").gameObject:SetActive(true);
end
function Module16Entry.FreeGame()
    --免费游戏
    logYellow("======免费游戏===========")
    self.isFreeGame = true;
    self.startBtn.transform:Find("AutoState").gameObject:SetActive(false);
    self.startBtn.transform:Find("Image").gameObject:SetActive(true);

    self.startBtn.transform:Find("Free").gameObject:SetActive(true);
    self.startBtn.transform:Find("Free/Num"):GetComponent("TextMeshProUGUI").text = ShowRichText(self.freeCount);
    --self.startBtn.AnimationState:SetAnimation(0, "freetimes", true);
    Module16_Network.StartGame();
end
function Module16Entry.Roll()
    --开始转动    
   -- Module16_Audio.PlaySound(Module16_Audio.SoundList.GO);
    if not self.isFreeGame and not Module16_Result.isWinCSJL then
        self.myGold = self.myGold - self.CurrentChip * Module16_DataConfig.ALLLINECOUNT;
        self.selfGold.text = self.ShowText(self.FormatNumberThousands(self.myGold));
    end
    self.WinNum.text = self.ShowText(0);
    self.WinGoldText.text=self.ShowText(0)

    Module16_Result.HideResult();
    Module16_Line.Close();
    Module16_Roll.StartRoll();
end
function Module16Entry.OnStop()
    --停止转动
    log("停止")
    Module16_Result.ShowResult();
end
function Module16Entry.InitPanel()
    --场景消息初始化
    self.myGold = TableUserInfo._7wGold;
    self.selfGold.text = self.ShowText(self.FormatNumberThousands(self.myGold));
    for i = 1, #self.SceneData.chipList do
        if self.SceneData.chipList[i] == self.SceneData.bet then
            self.CurrentChipIndex = i;
        end
    end
    if self.SceneData.freeNumber <= 0 then
        self.CurrentChipIndex = CheckNear(self.myGold,self.SceneData.chipList)
    end
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.FormatNumberThousands(self.CurrentChip*Module16_DataConfig.ALLLINECOUNT));
    self.WinNum.text = self.ShowText(0);
    self.WinGoldText.text=self.ShowText(0)

    Module16_Caijin.isCanSend = true;
    self.isRoll = false;
    Module16_Line.Init();
    Module16_Result.Init();
    if Module16Entry.ResultData.isSmallGame == 1 then
        Module16_SmallGamePanel.Run()
        return
    end
    if self.SceneData.freeNumber > 0 then
        --如果免费
        self.ResultData.FreeCount = self.SceneData.freeNumber;
        self.isFreeGame = true;
        Module16_Audio.PlayBGM(Module16_Audio.SoundList.BJ_Free);
        Module16_Result.ShowFreeEffect(true);
    end
end

function Module16Entry.FreeRoll()
    --判断是否为免费游戏
    Module16_Result.isShow = false;
    if Module16Entry.ResultData.isSmallGame == 1 then
        Module16_SmallGamePanel.Run()
        Module16_Audio.PlayBGM(Module16_Audio.SoundList.BJ_SGame)
        return
    end

    if self.isFreeGame then
        self.freeCount = self.freeCount - 1;
        if self.freeCount < 0 then
            --免费结束
            if Module16_Result.showFreeTweener ~= nil then
                Module16_Result.showFreeTweener:Kill();
                Module16_Result.showFreeTweener = nil;
            end
            self.FreeContent.gameObject:SetActive(false);
            self.isFreeGame = false;
            Module16Entry.addChipBtn.interactable = true;
            Module16Entry.reduceChipBtn.interactable = true;
            Module16Entry.MaxChipBtn.interactable = true;
            Module16_Audio.PlayBGM();

            self.AutoRoll();
        else
            --还有免费次数
            Module16Entry.AutoStartBtn.interactable = false;
            self.FreeGame();
            Module16_Audio.PlayBGM(Module16_Audio.SoundList.BJ_Free)

        end
    else
        self.AutoRoll();
    end
end
function Module16Entry.AutoRoll()
    --判断是否为自动游戏
    if self.isAutoGame then
        --如果是自动游戏
        self.AutoStartBtn:GetComponent("Button").interactable = true;

        if self.currentAutoCount < 1000 then
            self.currentAutoCount = self.currentAutoCount - 1;
        end
        if self.currentAutoCount < 0 then
            --自动次数使用完了，回到待机状态
            self.startBtn:GetComponent("Button").interactable = true;

            self.StopAutoGame();
        else
            --还有自动次数
            self.OnClickAutoItemCall();
        end
    else
        --不是自动游戏，直接待机
        self.startBtn:GetComponent("Button").interactable = true;
        self.AutoStartBtn:GetComponent("Button").interactable = true;
        self.StopAutoGame();
    end
end