-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion
g_sSlotModuleNum = "Module40/tgg/";

require(g_sSlotModuleNum .. "TGG_Network")
require(g_sSlotModuleNum .. "TGG_Roll")
require(g_sSlotModuleNum .. "TGG_DataConfig")
require(g_sSlotModuleNum .. "TGG_Caijin")
require(g_sSlotModuleNum .. "TGG_Line")
require(g_sSlotModuleNum .. "TGG_Result")
require(g_sSlotModuleNum .. "TGG_Rule")
require(g_sSlotModuleNum .. "TGG_Audio")

TGGEntry = {};
local self = TGGEntry;
self.transform = nil;
self.gameObject = nil;

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

self.SceneData = {
    bet = 0, --当前下注
    userGold = 0, --用户金币
    chipList = {}, --下注列表
    freeNumber = 0, --免费次数
    caiJin = 0--彩金
};
self.ResultData = {
    ImgTable = {}, --图标
    LineTypeTable = {}, --连线类型
    WinScore = 0, --赢得总分
    FreeCount = 0, --免费次数
    caiJin = 0, --彩金
    cbChangeLine = 0 --彩金
}
function TGGEntry:Awake(obj)
    Screen.autorotateToLandscapeLeft = true;
    Screen.autorotateToLandscapeRight = true;
    Screen.autorotateToPortrait = false;
    Screen.autorotateToPortraitUpsideDown = false;
    self.transform = obj.transform;
    self.gameObject = obj.gameObject;
    --self.GetGameConfig();
    self.FindComponent();
    self.AddListener();
    TGG_Roll.Init(self.RollContent);
    TGG_Audio.Init();
    TGG_Network.AddMessage();--添加消息监听
    TGG_Network.LoginGame();--开始登录游戏
    GameSetsPanel.CreateHideObj(self.MainContent, false);
    TGG_Audio.PlayBGM();
end
function TGGEntry.OnDestroy()
    TGG_Line.Close();
    TGG_Network.UnMessage();
end
function TGGEntry:Update()
    TGG_Roll.Update();
    --TGG_Caijin.Update();
    TGG_Line.Update();
    TGG_Result.Update();
end
function TGGEntry.FindComponent()
    self.MainContent = self.transform:Find("MainPanel");

    self.normalBackground = self.MainContent:Find("Content/MainBackground").gameObject;
    self.freeBackground = self.MainContent:Find("Content/FreeBackground").gameObject;
    self.freeShowCount = self.freeBackground.transform:Find("Count"):GetComponent("TextMeshProUGUI");

    self.RollContent = self.MainContent:Find("Content/RollContent");--转动区域
    self.selfGold = self.MainContent:Find("Content/Bottom/Gold/Num"):GetComponent("TextMeshProUGUI");--自身金币
    self.ChipNum = self.MainContent:Find("Content/Bottom/Chip/Num"):GetComponent("TextMeshProUGUI");--下注金额
    self.WinNum = self.MainContent:Find("Content/Bottom/Win/Num"):GetComponent("TextMeshProUGUI");--本次获得金币
    self.showRuleBtn = self.MainContent:Find("Content/Bottom/RuleBtn"):GetComponent("Button");--规则
    self.normalBot = self.MainContent:Find("Content/Bottom/MainBottom").gameObject;
    self.freeBot = self.MainContent:Find("Content/Bottom/FreeBottom").gameObject;
    self.normalBot:GetComponent("Image").enabled=true
    self.reduceChipBtn = self.MainContent:Find("Content/Bottom/Chip/Reduce"):GetComponent("Button");--减注
    self.addChipBtn = self.MainContent:Find("Content/Bottom/Chip/Add"):GetComponent("Button");--加注

    self.btnGroup = self.MainContent:Find("Content/ButtonGroup");
    self.startBtn = self.btnGroup:Find("StartBtn"):GetComponent("Button");--开始按钮
    self.startBtn.transform:Find("On").gameObject:SetActive(true);
    self.startBtn.transform:Find("Off").gameObject:SetActive(false);
    self.freeText = self.btnGroup.transform:Find("FreeCount"):GetComponent("TextMeshProUGUI");--免费次数

    self.AutoStartBtn = self.btnGroup:Find("AutoStart"):GetComponent("Button");--打开自动开始界面
    self.AutoStartBtn.transform:Find("On").gameObject:SetActive(true);
    self.AutoStartBtn.transform:Find("Off").gameObject:SetActive(false);

    self.rulePanel = self.MainContent:Find("Content/Rule");--规则界面
    self.rulePanel.gameObject:SetActive(false)
    self.ruleList = self.rulePanel:Find("Content/RuleList"):GetComponent("ScrollRect");--规则子界面
    self.closeRuleBtn = self.rulePanel:Find("Content/BackBtn"):GetComponent("Button");

    self.closeGame = self.MainContent:Find("Content/BackBtn"):GetComponent("Button");
    self.soundBtn = self.MainContent:Find("Content/SoundBtn"):GetComponent("Button");
    self.soundOn = self.soundBtn.transform:Find("On").gameObject;
    self.soundOff = self.soundBtn.transform:Find("Off").gameObject;

    self.soundOn:SetActive(AllSetGameInfo._5IsPlayAudio);
    self.soundOff:SetActive(not AllSetGameInfo._5IsPlayAudio);
    
    self.resultEffect = self.MainContent:Find("Content/Result");--中奖后特效
    self.normalWinEffect = self.resultEffect:Find("NormalReward");
    self.normalWinNum = self.normalWinEffect:Find("win/Num"):GetComponent("TextMeshProUGUI");
    self.bigWinEffect = self.resultEffect:Find("BigWin");
    self.bigWinNum = self.bigWinEffect:Find("win/Num"):GetComponent("TextMeshProUGUI");
    self.superWinEffect = self.resultEffect:Find("SuperWin");
    self.superWinNum = self.superWinEffect:Find("win/Num"):GetComponent("TextMeshProUGUI");
    self.megaWinEffect = self.resultEffect:Find("MegaWin");
    self.megaWinNum = self.megaWinEffect:Find("win/Num"):GetComponent("TextMeshProUGUI");
    self.EnterFreeEffect = self.resultEffect:Find("EnterFree");
    self.EnterFreeCount = self.EnterFreeEffect:Find("Content/FreeCount"):GetComponent("TextMeshProUGUI");
    self.FreeResultEffect = self.resultEffect:Find("FreeResult");
    self.FreeResultNum = self.FreeResultEffect:Find("Num"):GetComponent("TextMeshProUGUI");

    self.icons = self.MainContent:Find("Content/Icons");--图标库
    self.effectList = self.MainContent:Find("Content/EffectList");--动画库
    self.effectPool = self.MainContent:Find("Content/EffectPool");--动画缓存库
    self.CSGroup = self.MainContent:Find("Content/CSContent");--显示财神
    self.soundList = self.MainContent:Find("Content/SoundList");--声音库

end
function TGGEntry.AddListener()
    --添加监听事件
    self.reduceChipBtn.onClick:RemoveAllListeners();
    self.reduceChipBtn.onClick:AddListener(self.ReduceChipCall);
    self.addChipBtn.onClick:RemoveAllListeners();
    self.addChipBtn.onClick:AddListener(self.AddChipCall);
    self.startBtn.onClick:RemoveAllListeners();
    self.startBtn.onClick:AddListener(self.StartGameCall);

    self.closeGame.onClick:RemoveAllListeners();
    self.closeGame.onClick:AddListener(self.CloseGameCall);
    self.soundBtn.onClick:RemoveAllListeners();
    self.soundBtn.onClick:AddListener(self.SetSoundCall);

    self.AutoStartBtn.onClick:RemoveAllListeners();
    self.AutoStartBtn.onClick:AddListener(self.OnClickAutoStartCall);

    self.showRuleBtn.onClick:RemoveAllListeners();--显示规则
    self.showRuleBtn.onClick:AddListener(self.ShowRultPanel);


end
function TGGEntry.GetGameConfig()
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
        TGG_DataConfig.rollTime = data.rollTime;
        TGG_DataConfig.rollReboundRate = data.rollReboundRate;
        TGG_DataConfig.rollInterval = data.rollInterval;
        TGG_DataConfig.rollSpeed = data.rollSpeed;
        TGG_DataConfig.caijinGoldChangeRate = data.caijinGoldChangeRate;
        TGG_DataConfig.winGoldChangeRate = data.winGoldChangeRate;
        TGG_DataConfig.selfGoldChangeRate = data.selfGoldChangeRate;
        TGG_DataConfig.freeLoadingShowTime = data.freeLoadingShowTime;
        TGG_DataConfig.smallGameLoadingShowTime = data.smallGameLoadingShowTime;
        TGG_DataConfig.rollDistance = data.rollDistance;
        TGG_DataConfig.REQCaiJinTime = data.REQCaiJinTime;
        TGG_DataConfig.lineAllShowTime = data.lineAllShowTime;
        TGG_DataConfig.cyclePlayLineTime = data.cyclePlayLineTime;
        TGG_DataConfig.waitShowLineTime = data.waitShowLineTime;
        TGG_DataConfig.autoRewardInterval = data.autoRewardInterval;
        TGG_DataConfig.autoNoRewardInterval = data.autoNoRewardInterval;
    end);
end
function TGGEntry.ToCharArray(num)
    --拆解字符串
    local str = tostring(num);
    local list1 = {}
    for i = 1, string.len(str) do
        table.insert(list1, #list1 + 1, string.sub(str, i, i));
    end
    return list1;
end
function TGGEntry.FormatNumberThousands(num)
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
function TGGEntry.SetSelfGold(str)
    self.selfGold.text = self.ShowText(str);
end
function TGGEntry.ShowText(str)
    --展示tmp字体
    local arr = self.ToCharArray(str);
    local _str = "";
    for i = 1, #arr do
        _str = _str .. string.format("<sprite name=\"%s\">", arr[i]);
    end
    return _str;
end
function TGGEntry.ReduceChipCall()
    --减注
    TGG_Audio.PlaySound(TGG_Audio.SoundList.REDUCEBET);
    if self.SceneData.chipList == nil or #self.SceneData.chipList <= 0 then
        return ;
    end
    self.CurrentChipIndex = self.CurrentChipIndex - 1;
    if self.CurrentChipIndex <= 0 then
        self.CurrentChipIndex = #self.SceneData.chipList;
    end
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.CurrentChip * TGG_DataConfig.ALLLINECOUNT);
end
function TGGEntry.AddChipCall()
    --加注
    TGG_Audio.PlaySound(TGG_Audio.SoundList.ADDBET);
    if self.SceneData.chipList == nil or #self.SceneData.chipList <= 0 then
        return ;
    end
    self.CurrentChipIndex = self.CurrentChipIndex + 1;
    if self.CurrentChipIndex > #self.SceneData.chipList then
        self.CurrentChipIndex = 1;
    end
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.CurrentChip * TGG_DataConfig.ALLLINECOUNT);
end
function TGGEntry.StartGameCall()
    --开始游戏
    if self.isFreeGame or self.isAutoGame then
        return ;
    end
    if self.isRoll then
        --TODO 急停
        TGG_Roll.StopRoll();
        return ;
    end
    TGG_Audio.PlaySound(TGG_Audio.SoundList.BTN);

    if self.myGold < self.CurrentChip * TGG_DataConfig.ALLLINECOUNT then
        MessageBox.CreatGeneralTipsPanel("Not enough gold!")
        return;
    end
    self.startBtn.transform:Find("On").gameObject:SetActive(false);
    self.startBtn.transform:Find("Off").gameObject:SetActive(true);
    --TODO 发送开始消息,等待结果开始转动
    TGG_Network.StartGame();
end
function TGGEntry.ClickMenuCall()
    --点击显示菜单
    TGG_Audio.PlaySound(TGG_Audio.SoundList.BTN);
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
function TGGEntry.CloseMenuCall()
    --关闭菜单
    TGG_Audio.PlaySound(TGG_Audio.SoundList.BTN);
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
function TGGEntry.CloseGameCall()
    Event.Brocast(MH.Game_LEAVE);
end
function TGGEntry.SetSoundCall()
    if AllSetGameInfo._5IsPlayAudio or AllSetGameInfo._6IsPlayEffect then
        SetInfoSystem.GameMute();
        self.soundOn:SetActive(false);
        self.soundOff:SetActive(true);
    else
        SetInfoSystem.ResetMute();
        self.soundOn:SetActive(true);
        self.soundOff:SetActive(false);
    end
    TGG_Audio.pool.mute = not AllSetGameInfo._5IsPlayAudio;
end

function TGGEntry.OnClickAutoCall()
    --点击自动开始
    TGG_Audio.PlaySound(TGG_Audio.SoundList.BTN);
    if self.isAutoGame then
        self.StopAutoGame();
        return ;
    end
    self.closeAutoMenu.gameObject:SetActive(true);
end
function TGGEntry.OnClickAutoStartCall()
    --点击选择自动次数
    if self.isAutoGame then
        self.StopAutoGame();
        return ;
    end
    self.AutoStartCall();
end
function TGGEntry.AutoStartCall()
    TGG_Audio.PlaySound(TGG_Audio.SoundList.BTN);
    if self.myGold < self.CurrentChip * TGG_DataConfig.ALLLINECOUNT then
        MessageBox.CreatGeneralTipsPanel("Not enough gold!")
        return;
    end
    self.isAutoGame = true;
    self.AutoStartBtn.transform:Find("On").gameObject:SetActive(false);
    self.AutoStartBtn.transform:Find("Off").gameObject:SetActive(true);
    TGGEntry.addChipBtn.interactable = false;
    TGGEntry.reduceChipBtn.interactable = false;
    self.startBtn.interactable = false;
    self.currentAutoCount = 1000;
    if not self.isRoll and not self.isFreeGame then
        --没有转动的状态开始自动旋转
        TGG_Network.StartGame();
    end
end
function TGGEntry.ShowRultPanel()
    --显示规则
    TGG_Audio.PlaySound(TGG_Audio.SoundList.BTN);
    TGG_Rule.ShowRule();
end
function TGGEntry.SetMaxChipCall()
    --设置最大下注
    TGG_Audio.PlaySound(TGG_Audio.SoundList.BTN);
    self.CurrentChipIndex = #self.SceneData.chipList;
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.CurrentChip);
end

function TGGEntry.CSJLRoll()
    TGG_Network.StartGame();
end
function TGGEntry.StopAutoGame()
    --停止自动旋转
    self.isAutoGame = false;
    self.currentAutoCount = 0;
    self.AutoStartBtn.transform:Find("On").gameObject:SetActive(true);
    self.AutoStartBtn.transform:Find("Off").gameObject:SetActive(false);
    TGGEntry.addChipBtn.interactable = true;
    TGGEntry.reduceChipBtn.interactable = true;
    self.startBtn.interactable = true;
end
function TGGEntry.FreeGame()
    --免费游戏
    self.isFreeGame = true;
    TGGEntry.freeShowCount.text = TGGEntry.ShowText("x" .. self.currentFreeCount);
    if self.currentFreeCount < 12 then
        TGG_Audio.PlaySound("Freex" .. self.currentFreeCount);
    else
        TGG_Audio.PlaySound("Freex12");
    end
    self.freeText.text = self.ShowText(self.freeCount);
    TGG_Network.StartGame();
end
function TGGEntry.Roll()
    --开始转动    
    if not self.isFreeGame and not TGG_Result.isWinCSJL then
        self.myGold = self.myGold - self.CurrentChip * TGG_DataConfig.ALLLINECOUNT;
        TGGEntry.SetSelfGold(self.myGold);
    end
    self.WinNum.text = self.ShowText(0);
    TGG_Result.HideResult();
    TGG_Line.Close();
    TGG_Roll.StartRoll();
end
function TGGEntry.OnStop()
    --停止转动
    log("停止")
    self.startBtn.transform:Find("On").gameObject:SetActive(true);
    self.startBtn.transform:Find("Off").gameObject:SetActive(false);
    TGG_Result.ShowResult();

end
function TGGEntry.InitPanel()
    --场景消息初始化
    self.myGold = TableUserInfo._7wGold;
    TGGEntry.SetSelfGold(self.myGold);
    for i = 1, #self.SceneData.chipList do
        if self.SceneData.chipList[i] == self.SceneData.bet then
            self.CurrentChipIndex = i;
            self.CurrentChip = self.SceneData.bet;
            self.ChipNum.text = self.ShowText(self.CurrentChip * TGG_DataConfig.ALLLINECOUNT);
        end
    end
    self.WinNum.text = self.ShowText(0);
    --TGG_Caijin.isCanSend = true;
    self.isRoll = false;
    TGG_Line.Init();
    TGG_Result.Init();
    if self.SceneData.freeNumber > 0 then
        --如果免费
        self.freeCount = self.SceneData.freeNumber;
        self.isFreeGame = true;
        TGG_Result.ShowFreeEffect(true);
        self.SetState(2);
    else
        self.SetState(1);
    end
end
function TGGEntry.SetState(state)
    if state == 1 or state == 3 then
        --正常模式 or 自动模式
        self.normalBackground:SetActive(true);
        self.freeBackground:SetActive(false);
        self.normalBot:SetActive(true);
        self.freeBot:SetActive(false);
        self.startBtn.gameObject:SetActive(true);
        self.AutoStartBtn.gameObject:SetActive(true);
        self.freeText.gameObject:SetActive(false);
    elseif state == 2 then
        --免费模式
        self.normalBackground:SetActive(false);
        self.freeBackground:SetActive(true);
        self.normalBot:SetActive(false);
        self.freeBot:SetActive(true);
        self.startBtn.gameObject:SetActive(false);
        self.AutoStartBtn.gameObject:SetActive(false);
        self.freeText.gameObject:SetActive(true);
    end
end
function TGGEntry.FreeRoll()
    --判断是否为免费游戏
    TGG_Result.isShow = false;
    if self.isFreeGame then
        self.freeCount = self.freeCount - 1;
        self.currentFreeCount = self.currentFreeCount + 1;
        if self.freeCount < 0 then
            --免费结束
            if TGG_Result.showFreeTweener ~= nil then
                TGG_Result.showFreeTweener:Kill();
                TGG_Result.showFreeTweener = nil;
            end
            self.isFreeGame = false;
            TGGEntry.addChipBtn.interactable = true;
            TGGEntry.reduceChipBtn.interactable = true;
            TGG_Audio.PlayBGM();
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
function TGGEntry.AutoRoll()
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
            self.AutoStartCall();
        end
    else
        --不是自动游戏，直接待机
        self.StopAutoGame();
    end
end