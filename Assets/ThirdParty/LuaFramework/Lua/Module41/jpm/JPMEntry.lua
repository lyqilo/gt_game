-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion
local JPM_SlotModuleNum = "Module41/jpm/";

require(JPM_SlotModuleNum .. "JPM_Network")
require(JPM_SlotModuleNum .. "JPM_Roll")
require(JPM_SlotModuleNum .. "JPM_DataConfig")
require(JPM_SlotModuleNum .. "JPM_Caijin")
require(JPM_SlotModuleNum .. "JPM_Line")
require(JPM_SlotModuleNum .. "JPM_Result")
require(JPM_SlotModuleNum .. "JPM_Rule")
require(JPM_SlotModuleNum .. "JPM_Audio")
require(JPM_SlotModuleNum .. "JPM_SmallGame")


 JPMEntry = {};
 local self = JPMEntry;
 self.transform = nil;
 self.gameObject = nil;
 self.clickStartTimer=-1
self.CurrentChip = 0;
self.CurrentChipIndex = 0;
self.isAutoGame = false;
self.isFreeGame = false;
self.isSmallGame = false;

self.isRoll = false;
self.menuTweener = nil;
self.ispress = false;

self.currentFreeCount = 0;

self.currentAutoCount = 0;--剩余自动次数
self.freeCount = 0;--剩余免费次数

self.myGold = 0;--显示的自身金币

local selectTimeing=0
local isLongClick=false

self.SceneData = {
    chipList = {}, --下注列表
    bet = 0, --当前下注
    freeNumber = 0, --免费次数
    cbBouns = 0, --小游戏轮数
    nBounsNo = 0,--小游戏底图
    SmallAllGold = 0--小游戏总金币
};
self.ResultData = {
    ImgTable = {}, --图标
    LineTypeTable = {}, --连线类型
    WinScore = 0, --赢得总分
    FreeCount = 0, --免费次数
    caiJin = 0, --彩金
    cbChangeLine = 0, --彩金
    isSmallGame=0,
}
 function JPMEntry:Awake(obj)
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
    JPM_Roll.Init(self.RollContent);
    JPM_Audio.Init();
    JPM_Network.AddMessage();--添加消息监听
    JPM_Network.LoginGame();--开始登录游戏
    GameSetsPanel.CreateHideObj(self.MainContent, false);
    JPM_Audio.PlayBGM();
 end
function JPMEntry.OnDestroy()
    JPM_Line.Close();
    JPM_Network.UnMessage();
end
function JPMEntry:Update()
    JPM_Roll.Update();
    --JPM_Caijin.Update();
    JPM_Line.Update();
    JPM_Result.Update();
    JPMEntry.CanShowAuto()
end

function JPMEntry.CanShowAuto()
    if self.ispress then
        if self.clickStartTimer >= 0 then
            self.clickStartTimer = self.clickStartTimer + Time.deltaTime;
            if self.clickStartTimer >= 0.5 then
                self.clickStartTimer = -1;
                self.OnClickAutoCall();
            end
        end
    end
end

 function JPMEntry.FindComponent()
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

    self.JDImg=self.MainContent:Find("Content/Bottom/Chip/JDImg");--jindu
    self.JDImg.gameObject:SetActive(false)
    self.BigBtn=self.MainContent:Find("Content/Bottom/Chip/BigBtbn"):GetComponent("Button");--最大

    self.btnGroup = self.MainContent:Find("Content/ButtonGroup");
    self.startBtn = self.btnGroup:Find("StartBtn"):GetComponent("Button");--开始按钮
    self.startBtn.transform:Find("On").gameObject:SetActive(true);
    self.startBtn.transform:Find("Off").gameObject:SetActive(false);


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
    self.closeGame = self.MainContent:Find("Content/BackBtn"):GetComponent("Button");
    self.soundBtn = self.MainContent:Find("Content/SoundBtn"):GetComponent("Button");
    self.soundOn = self.soundBtn.transform:Find("On").gameObject;
    self.soundOff = self.soundBtn.transform:Find("Off").gameObject;

    self.WinGold=self.MainContent:Find("Content/WinGold") --界面显示金币
    self.WinGoldText=self.WinGold:Find("Text"):GetComponent("TextMeshProUGUI");
     self.WinGoldText.transform.localScale= Vector3.New(1.25,1.25,1.25);
    self.WinGold.gameObject:SetActive(false)

    self.SmallGmaePanel=self.MainContent:Find("SmallGamePanel").gameObject
    self.SmallGmaePanel:SetActive(false);
    JPM_SmallGame:Init(self.SmallGmaePanel)

    self.soundOn:SetActive(AllSetGameInfo._5IsPlayAudio);
    self.soundOff:SetActive(not AllSetGameInfo._5IsPlayAudio);
    
    self.resultEffect = self.MainContent:Find("Content/Result");--中奖后特效
    self.bigWinEffect = self.resultEffect:Find("BigWin");
    self.bigWinNum = self.bigWinEffect:Find("win/Num"):GetComponent("TextMeshProUGUI");
    local pos= self.bigWinNum.transform.localPosition;
     self.bigWinNum.transform.localPosition=Vector3.New(pos.x,pos.y-50,pos.z);
     self.bigWinNum.transform.localScale=Vector3.New(2,2,2);
    self.EnterFreeEffect = self.resultEffect:Find("EnterFree");
    self.EnterFreeCount = self.EnterFreeEffect:Find("Content/FreeCount"):GetComponent("Text");
    self.FreeResultEffect = self.resultEffect:Find("FreeResult");
    self.FreeResultNum = self.FreeResultEffect:Find("Num"):GetComponent("Text");

    self.icons = self.MainContent:Find("Content/Icons");--图标库
    self.effectList = self.MainContent:Find("Content/EffectList");--动画库
    self.effectPool = self.MainContent:Find("Content/EffectPool");--动画缓存库
    self.CSGroup = self.MainContent:Find("Content/CSContent");--显示财神
    self.soundList = self.MainContent:Find("Content/SoundList");--声音库
    self.LineGroup = self.MainContent:Find("Content/LineGroup");--连线

     self.musicSet.value = MusicManager:GetMusicVolume();
    --if not AllSetGameInfo._5IsPlayAudio then
    --    self.musicSet.value = 0;
    --else
        --if Util.Read("MusicValue") then
        --    local musicVol = PlayerPrefs.GetString("MusicValue");
        --    self.musicSet.value = tonumber(musicVol);
        --else
        --    self.musicSet.value = 1;
        --end
    --end
     self.soundSet.value = MusicManager:GetSoundVolume();
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

 end
function JPMEntry.AddListener()
    --添加监听事件
    self.reduceChipBtn.onClick:RemoveAllListeners();
    self.reduceChipBtn.onClick:AddListener(self.ReduceChipCall);

    self.addChipBtn.onClick:RemoveAllListeners();
    self.addChipBtn.onClick:AddListener(self.AddChipCall);

    self.startBtn:GetComponent("Button").onClick:RemoveAllListeners();
    self.startBtn:GetComponent("Button").onClick:AddListener(self.StartGameCall);
    local et = self.startBtn.gameObject:AddComponent(typeof(LuaFramework.EventTriggerListener));
    et.onDown = self.OnDownStartBtnClick;
    et.onUp = self.OnUpStartBtnClick;


    self.BigBtn.onClick:RemoveAllListeners();
    self.BigBtn.onClick:AddListener(self.BigChipCall);

    self.closeGame.onClick:RemoveAllListeners();
    self.closeGame.onClick:AddListener(self.CloseGameCall);

    self.soundBtn.onClick:RemoveAllListeners();
    self.soundBtn.onClick:AddListener(self.SetSoundCall);

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

    self.closeSet.onClick:RemoveAllListeners();
    self.closeSet.onClick:AddListener(function()
        self.settingPanel.gameObject:SetActive(false);
    end);

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
function JPMEntry.GetGameConfig()
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
        JPM_DataConfig.rollTime = data.rollTime;
        JPM_DataConfig.rollReboundRate = data.rollReboundRate;
        JPM_DataConfig.rollInterval = data.rollInterval;
        JPM_DataConfig.rollSpeed = data.rollSpeed;
        JPM_DataConfig.caijinGoldChangeRate = data.caijinGoldChangeRate;
        JPM_DataConfig.winGoldChangeRate = data.winGoldChangeRate;
        JPM_DataConfig.selfGoldChangeRate = data.selfGoldChangeRate;
        JPM_DataConfig.freeLoadingShowTime = data.freeLoadingShowTime;
        JPM_DataConfig.smallGameLoadingShowTime = data.smallGameLoadingShowTime;
        JPM_DataConfig.rollDistance = data.rollDistance;
        JPM_DataConfig.REQCaiJinTime = data.REQCaiJinTime;
        JPM_DataConfig.lineAllShowTime = data.lineAllShowTime;
        JPM_DataConfig.cyclePlayLineTime = data.cyclePlayLineTime;
        JPM_DataConfig.waitShowLineTime = data.waitShowLineTime;
        JPM_DataConfig.autoRewardInterval = data.autoRewardInterval;
        JPM_DataConfig.autoNoRewardInterval = data.autoNoRewardInterval;
    end);
end
function JPMEntry.ToCharArray(num)
    --拆解字符串
    local str = tostring(num);
    local list1 = {}
    for i = 1, string.len(str) do
        table.insert(list1, #list1 + 1, string.sub(str, i, i));
    end
    return list1;
end
function JPMEntry.FormatNumberThousands(num)
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
function JPMEntry.SetSelfGold(str)
    self.selfGold.text = self.ShowText(str);
end
function JPMEntry.ShowText(str)
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

function JPMEntry.CloseSelectPanel()
    self.selectPanel.gameObject:SetActive(false)
end

function JPMEntry.OnDownStartBtnClick()
    self.clickStartTimer = 0;
    self.ispress = true;
end

function JPMEntry.OnUpStartBtnClick()
    self.ispress = false;
    self.clickStartTimer = -1;
end

function JPMEntry.SelectAutoNum1()
    self.currentAutoCount=20
    JPMEntry.SelectAutoNum()
end
function JPMEntry.SelectAutoNum2()
    self.currentAutoCount=50
    JPMEntry.SelectAutoNum()
end
function JPMEntry.SelectAutoNum3()
    self.currentAutoCount=100
    JPMEntry.SelectAutoNum()
end
function JPMEntry.SelectAutoNum4()
    self.currentAutoCount=1000000
    JPMEntry.SelectAutoNum()
end
function JPMEntry.SelectAutoNum()
    local str=""
    if self.currentAutoCount>100 then
        str="∞"
    else
        str=""..self.currentAutoCount
    end
    self.ispress = false;

    JPMEntry.addChipBtn.interactable = false;
    JPMEntry.reduceChipBtn.interactable = false;
    JPMEntry.BigBtn.interactable = false;
    self.isAutoGame=true
    self.SetState(3)
    JPMEntry.SetAutoNum(str)
    if not self.isRoll then
        JPM_Network.StartGame();
    end
    JPMEntry.CloseSelectPanel()
end

function JPMEntry.SetAutoNum(num)
    self.AutoStartBtn.transform:Find("Text"):GetComponent("Text").text=""..num
end

function JPMEntry.ReduceChipCall()
    --减注
    JPM_Audio.PlaySound(JPM_Audio.SoundList.BTN);
    if self.SceneData.chipList == nil or #self.SceneData.chipList <= 0 then
        return ;
    end
    self.CurrentChipIndex = self.CurrentChipIndex - 1;
    if self.CurrentChipIndex <= 0 then
        self.CurrentChipIndex = #self.SceneData.chipList;
    end
    
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.CurrentChip * JPM_DataConfig.ALLLINECOUNT);
end
function JPMEntry.AddChipCall()
    --加注
    JPM_Audio.PlaySound(JPM_Audio.SoundList.BTN);
    if self.SceneData.chipList == nil or #self.SceneData.chipList <= 0 then
        return ;
    end
    self.CurrentChipIndex = self.CurrentChipIndex + 1;
    if self.CurrentChipIndex > #self.SceneData.chipList then
        self.CurrentChipIndex = 1;
    end
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.CurrentChip * JPM_DataConfig.ALLLINECOUNT);
end

function JPMEntry.BigChipCall()
    JPM_Audio.PlaySound(JPM_Audio.SoundList.BTN);
    if self.SceneData.chipList == nil or #self.SceneData.chipList <= 0 then
        return ;
    end
    self.CurrentChipIndex = #self.SceneData.chipList
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.CurrentChip * JPM_DataConfig.ALLLINECOUNT);
end


function JPMEntry.StartGameCall()
    if self.isFreeGame or self.isAutoGame or self.isSmallGame then
        return ;
    end
    if self.isRoll then
        --TODO 急停
        JPM_Roll.StopRoll();
        return ;
    end

    if self.myGold < self.CurrentChip * JPM_DataConfig.ALLLINECOUNT then
        MessageBox.CreatGeneralTipsPanel("gold not enough!")
        return ;
    end
    if not self.selectPanel.gameObject.activeSelf then
        JPM_Audio.PlaySound(JPM_Audio.SoundList.BTN);
        self.startBtn.transform:Find("On").gameObject:SetActive(false);
        self.startBtn.transform:Find("Off").gameObject:SetActive(true);
        JPMEntry.addChipBtn.interactable = false;
        JPMEntry.reduceChipBtn.interactable = false;
        JPMEntry.BigBtn.interactable = false;
        --TODO 发送开始消息,等待结果开始转动
        JPM_Network.StartGame();
    end
end

function JPMEntry.SetMusicVolumn(value)
    
    MusicManager:SetValue(MusicManager:GetSoundVolume(), value);
    JPM_Audio.pool.volume=value
    MusicManager:SetMusicMute(value <= 0);
    JPM_Audio.pool.mute = not MusicManager:GetIsPlayMV();

end
function JPMEntry.SetSoundVolumn(value)
    MusicManager:SetValue(value,MusicManager:GetMusicVolume());
    MusicManager:SetSoundMute(value <= 0);
end

function JPMEntry.ClickMenuCall()
    --点击显示菜单
    JPM_Audio.PlaySound(JPM_Audio.SoundList.BTN);
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
function JPMEntry.CloseMenuCall()
    --关闭菜单
    JPM_Audio.PlaySound(JPM_Audio.SoundList.BTN);
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
function JPMEntry.CloseGameCall()
    if self.isFreeGame or JPMEntry.ResultData.isSmallGame==1 then
        MessageBox.CreatGeneralTipsPanel("Unable to quit the game in special games")
        return
    end
    Event.Brocast(MH.Game_LEAVE);
end
function JPMEntry.SetSoundCall()
    self.settingPanel.gameObject:SetActive(true);
end

function JPMEntry.OnClickAutoCall()
    --点击自动开始
    --JPM_Audio.PlaySound(JPM_Audio.SoundList.BTN);
    if self.isAutoGame then
        self.StopAutoGame();
        return ;
    end
    self.selectPanel.gameObject:SetActive(true)
end
function JPMEntry.OnClickAutoStartCall()
    --点击选择自动次数
    if self.isAutoGame then
        self.StopAutoGame();
        return ;
    end
    --self.AutoStartCall();
end
function JPMEntry.AutoStartCall()
    if not self.isFreeGame then
        if self.myGold < self.CurrentChip * JPM_DataConfig.ALLLINECOUNT then
            MessageBox.CreatGeneralTipsPanel("gold not enough!")
            return ;
        end
    end
    JPM_Audio.PlaySound(JPM_Audio.SoundList.BTN);
    self.isAutoGame = true;
    self.AutoStartBtn.transform:Find("On").gameObject:SetActive(true);
    self.AutoStartBtn.transform:Find("Text").gameObject:SetActive(true);
    JPMEntry.addChipBtn.interactable = false;
    JPMEntry.reduceChipBtn.interactable = false;
    JPMEntry.BigBtn.interactable = false;
    self.startBtn.interactable = false;
    local str=""
    if self.currentAutoCount>100 then
        str="∞"
    else
        str=""..self.currentAutoCount
    end
    JPMEntry.SetAutoNum(str)

    if not self.isRoll and not self.isFreeGame or not self.isSmallGame then
        --没有转动的状态开始自动旋转
        JPM_Network.StartGame();
    end
end
function JPMEntry.ShowRultPanel()
    --显示规则
    JPM_Audio.PlaySound(JPM_Audio.SoundList.BTN);
    JPM_Rule.ShowRule();
end
function JPMEntry.SetMaxChipCall()
    --设置最大下注
    JPM_Audio.PlaySound(JPM_Audio.SoundList.BTN);
    self.CurrentChipIndex = #self.SceneData.chipList;
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.CurrentChip);
end

function JPMEntry.CSJLRoll()
    JPM_Network.StartGame();
end
function JPMEntry.StopAutoGame()
    --停止自动旋转
    self.isAutoGame = false;
    self.currentAutoCount = 0;
    self.AutoStartBtn.transform:Find("On").gameObject:SetActive(true);
    JPMEntry.SetAutoNum(self.currentAutoCount)
    JPMEntry.addChipBtn.interactable = true;
    JPMEntry.reduceChipBtn.interactable = true;
    JPMEntry.BigBtn.interactable = true;
    self.startBtn.interactable = true;
    self.SetState(1)
end
function JPMEntry.FreeGame()
    --免费游戏
    self.isFreeGame = true;
    --JPMEntry.freeShowCount.text = JPMEntry.ShowText("x" .. self.currentFreeCount);
    -- if self.currentFreeCount < 12 then
    --     JPM_Audio.PlaySound("Freex" .. self.currentFreeCount);
    -- else
    --     JPM_Audio.PlaySound("Freex12");
    -- end
    self.freeText.text = ShowRichText(self.freeCount);
    JPM_Network.StartGame();
end
function JPMEntry.Roll()
    --开始转动    
    if not self.isFreeGame and not JPM_Result.isWinCSJL or self.isSmallGame then
        self.myGold = self.myGold - self.CurrentChip * JPM_DataConfig.ALLLINECOUNT;
        JPMEntry.SetSelfGold(self.myGold);
    end

    self.WinNum.text = self.ShowText(0);
    self.WinGoldText.text=self.ShowText(0)
    self.WinGold.gameObject:SetActive(false)
    self.TipText.text=""
    JPM_Result.HideResult();
    JPM_Line.Close();
    JPM_Roll.StartRoll();
end
function JPMEntry.OnStop()
    --停止转动
    log("停止")
    self.startBtn.transform:Find("On").gameObject:SetActive(true);
    self.startBtn.transform:Find("Off").gameObject:SetActive(false);
    JPM_Result.ShowResult();
end
function JPMEntry.InitPanel()
    --场景消息初始化
    self.myGold = TableUserInfo._7wGold;
    JPMEntry.SetSelfGold(self.myGold);
    for i = 1, #self.SceneData.chipList do
        if self.SceneData.chipList[i] == self.SceneData.bet then
            self.CurrentChipIndex = i;
        end
    end
    if self.SceneData.freeNumber <= 0 then
        self.CurrentChipIndex = CheckNear(self.myGold,self.SceneData.chipList)
    end
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = self.ShowText(self.CurrentChip * JPM_DataConfig.ALLLINECOUNT);
    self.WinNum.text = self.ShowText(0);
    self.WinGoldText.text=self.ShowText(0)
    self.WinGold.gameObject:SetActive(false)
    self.TipText.text=""
    --JPM_Caijin.isCanSend = true;
    self.isRoll = false;
    JPM_Line.Init();
    JPM_Result.Init();

    if self.SceneData.freeNumber > 0 then
        --如果免费
        self.freeCount = self.SceneData.freeNumber;
        self.isFreeGame = true;
        self.SetState(2);
        JPM_Result.ShowFreeEffect(true);
        if self.SceneData.cbBouns>0 then
            self.isSmallGame=true
            JPMEntry.ResultData.isSmallGame=1
            self.SetState(4);
        end
    elseif self.SceneData.cbBouns>0 then
        self.isSmallGame=true
        JPMEntry.ResultData.isSmallGame=1
        self.SetState(4);
    else
        self.SetState(1);
    end
end
function JPMEntry.SetState(state)
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
    elseif state==4 then
        JPM_SmallGame.Run()
    end
end
function JPMEntry.FreeRoll()
    --判断是否为免费游戏
    JPM_Result.isShow = false;
    if JPMEntry.ResultData.isSmallGame==1 then
        JPM_SmallGame.Run()
        return
    end
    logYellow("JPMEntry.ResultData.isSmallGame=="..JPMEntry.ResultData.isSmallGame)
    logYellow("isFreeGame=="..tostring(self.isFreeGame))

    if self.isFreeGame then
        self.freeCount = self.freeCount - 1;
        self.currentFreeCount = self.currentFreeCount + 1;
        if self.freeCount < 0 then
            --免费结束
            if JPM_Result.showFreeTweener ~= nil then
                JPM_Result.showFreeTweener:Kill();
                JPM_Result.showFreeTweener = nil;
            end
            self.isFreeGame = false;
            JPM_Audio.PlayBGM();
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
function JPMEntry.AutoRoll()
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
            self.SetState(3);
        end
    else
        --不是自动游戏，直接待机
        self.StopAutoGame();
    end
end