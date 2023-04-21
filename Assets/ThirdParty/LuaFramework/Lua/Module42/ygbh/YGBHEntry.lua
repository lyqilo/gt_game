-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion
local g_sYGBHModuleNum = "Module42/ygbh/";

require(g_sYGBHModuleNum .. "YGBH_Network")
require(g_sYGBHModuleNum .. "YGBH_Roll")
require(g_sYGBHModuleNum .. "YGBH_DataConfig")
require(g_sYGBHModuleNum .. "YGBH_Caijin")
require(g_sYGBHModuleNum .. "YGBH_Line")
require(g_sYGBHModuleNum .. "YGBH_Result")
require(g_sYGBHModuleNum .. "YGBH_Rule")
require(g_sYGBHModuleNum .. "YGBH_Audio")

YGBHEntry = {};
local self = YGBHEntry;
self.transform = nil;
self.gameObject = nil;

self.CurrentChip = 0;
self.CurrentChipIndex = 0;
self.isAutoGame = false;
self.isFreeGame = false;
self.isSmallGame = false;
self.isRoll = false;
self.menuTweener = nil;

self.currentAutoCount = 0;--剩余自动次数
self.freeCount = 0;--剩余免费次数

self.myGold = 0;--显示的自身金币
self.clickStartTimer = -1;
self.scatterList = {};
self.bjjList = {};
self.bjjImgList = {};

self.isshowFree = false;
self.showFreeTimer = 0;
self.hasNewSP = false;

self.FullSP = false;--碎片集满了
self.isRollSmall = false;
self.smallRollTimer = 0;
self.currentSmallRollIndex = 0;
self.currentSmallCycleCount = 0;
self.smallTempRollTimer = 0;
self.isLastCycle = false;
self.smallSPCount = 0;
self.smallSPRealCount = 0;
self.ispress = false;

self.SmallGameData = {
    --小游戏结果  
    nIndex = 0,
    nGold = 0,
};
self.SceneData = {
    bet = 0, --当前下注
    freeNumber = 0, --免费次数
    nGainPeilv = 0, --已获赔率
    nBetonCount = 0, --下注列表个数
    chipList = {}, --下注列表
    nFreeIcon_lie = {}, --紫霞免费icon（1代表整列是紫霞）
    nFreeType = 0, --免费游戏类型
    smallGameTrack = {}, --小游戏类型
};
self.ResultData = {
    ImgTable = {}, --图标
    LineTypeTable = {}, --连线类型
    m_nWinPeiLv = 0, --赢得倍数
    m_szCurrGold = 0, --当前金币
    FreeCount = 0, --免费次数
    m_nPrizePoolGold = 0, --奖金池金币
    WinScore = 0, --赢得总分
    m_nTotalWinGold = 0, --总的赢取分数
    m_nSmallGame = 0, --0-没有小游戏，1-有小游戏
    m_nMultiple = 0, --追加单线倍率
    m_nPrizePoolPercentMax = 0, --最大奖励
    m_nPrizePoolWildGold = 0,
    m_nTotalFreeTimes = 0, --免费游戏剩余次数
    m_nSmallNnm = 0, --小游戏次数
    m_FreeType = 0, --免费类型/13/14
    m_nIconLie = {}, --整列百搭 1为百搭 0不是
}
function YGBHEntry:Awake(obj)
    self.transform = obj.transform;
    self.gameObject = obj.gameObject;
    --self.GetGameConfig();
    self.FindComponent();
    self.AddListener();
    GameSetsPanel.CreateHideObj(self.MainContent, false);
    YGBH_Roll.Init(self.RollContent);
    YGBH_Audio.Init();
    YGBH_Rule.Init();
    YGBH_Network.AddMessage();--添加消息监听
    YGBH_Network.LoginGame();--开始登录游戏
    self.userHead.sprite = HallScenPanel.GetHeadIcon();
    self.userName.text = SCPlayerInfo._05wNickName;
    --YGBH_Audio.PlayBGM();
end
function YGBHEntry.OnDestroy()
    YGBH_Line.Close();
    YGBH_Network.UnMessage();
end
function YGBHEntry:Update()
    self.CanShowAuto();
    YGBH_Roll.Update();
    --YGBH_Caijin.Update();
    YGBH_Line.Update();
    YGBH_Result.Update();
    self.AutoSelectFree();
end
function YGBHEntry.StartRollSmallGame()
    --转动小游戏
    self.stopIndex = YGBHEntry.smallWinIndex;
    self.needMove = self.stopIndex + 8 * 2;
    local currentPos = 0;
    for i = 1, self.needMove do
        currentPos = currentPos + 1;
        if currentPos > 8 then
            currentPos = currentPos - 8;
        end

        self.gbObj.transform:SetParent(self.maskGroup:GetChild(currentPos - 1));
        self.gbObj.transform.localPosition = Vector3.New(YGBH_DataConfig.smallLighIconPos[1], YGBH_DataConfig.smallLighIconPos[2], YGBH_DataConfig.smallLighIconPos[3]);
        self.gbObj.transform.localRotation = Quaternion.Euler(0, 0, YGBH_DataConfig.smallLighIconAngle);

        YGBH_Audio.PlaySound(YGBH_Audio.SoundList.RS);
        if self.needMove - i > 6 then
            coroutine.wait(YGBH_DataConfig.smallMoveSpeed);
        elseif self.needMove - i > 4 then
            coroutine.wait(YGBH_DataConfig.smallMoveSpeed * 2);
        elseif self.needMove - i > 2 then
            coroutine.wait(YGBH_DataConfig.smallMoveSpeed * 4);
        else
            coroutine.wait(YGBH_DataConfig.smallMoveSpeed * 8);
        end
    end
    --TODO 显示结算
    YGBH_Result.ShowCSJLResultEffect();
end
function YGBHEntry.AutoSelectFree()
    if self.isshowFree then
        self.showFreeTimer = self.showFreeTimer - Time.deltaTime;
        if self.showFreeTimer < 6 and self.showFreeTimer > 0 then
            if self.freedownTime.text ~= self.ShowText(math.ceil(self.showFreeTimer)) then
                YGBH_Audio.PlaySound(YGBH_Audio.SoundList.TIMEDOWN);
            end
        end
        self.freedownTime.text = self.ShowText(math.ceil(self.showFreeTimer));
        if self.showFreeTimer <= 0 then
            --默认选择
            self.showFreeTimer = YGBH_DataConfig.freeWaitTime;
            self.freedownTime.gameObject:SetActive(false);
            self.OnSelectFreeTypeCall(self.freeSelectOne, self.freeSelectTwo, 1);
        end
    end
end
function YGBHEntry.CanShowAuto()
    if self.ispress then
        if self.clickStartTimer >= 0 then
            self.clickStartTimer = self.clickStartTimer + Time.deltaTime;
            if self.clickStartTimer >= 1.5 then
                self.clickStartTimer = -1;
                self.autoEffect.gameObject:SetActive(false);
                self.OnClickAutoCall();
            end
        end
    end
end
function YGBHEntry.FindComponent()
    --self.MosaicNum = self.transform:Find("Content/Mosaic/MosaicNum"):GetComponent("TextMeshProUGUI");--彩金
    --self.FreeRewardList = self.transform:Find("Content/FreeRewardList");--免费奖励表
    self.MainContent = self.transform:Find("MainPanel/Content");
    self.RollContent = self.MainContent:Find("RollContent");--转动区域
    self.selfGold = self.MainContent:Find("Bottom/Gold/Num"):GetComponent("TextMeshProUGUI");--自身金币
    self.userName = self.MainContent:Find("Bottom/Gold/UserName"):GetComponent("Text");--用户名
    self.userHead = self.MainContent:Find("Bottom/Gold/Head/Mask/Icon"):GetComponent("Image");--用户头像
    self.ChipNum = self.MainContent:Find("Bottom/Chip/Num"):GetComponent("TextMeshProUGUI");--下注金额
    self.WinNum = self.MainContent:Find("Bottom/Win/Num"):GetComponent("TextMeshProUGUI");--本次获得金币
    self.WinDesc = self.MainContent:Find("Bottom/Win/Desc"):GetComponent("TextMeshProUGUI");--本次获得金币

    self.reduceChipBtn = self.MainContent:Find("Bottom/Chip/Reduce"):GetComponent("Button");--减注
    self.addChipBtn = self.MainContent:Find("Bottom/Chip/Add"):GetComponent("Button");--加注

    self.btnGroup = self.MainContent:Find("Bottom/ButtonGroup");
    self.startBtn = self.btnGroup:Find("StartBtn");--开始按钮
    self.autoEffect = self.startBtn.transform:Find("AutoEffect");
    self.stopBtn = self.btnGroup:Find("StopBtn"):GetComponent("Button");--停止按钮
    self.stopBtn.gameObject:SetActive(false);
    self.FreeContent = self.btnGroup:Find("Free");--免费状态
    self.FreeContent.gameObject:SetActive(false);
    self.freeText = self.FreeContent.transform:Find("Num"):GetComponent("TextMeshProUGUI");--免费次数
    self.AutoStartBtn = self.btnGroup:Find("AutoState"):GetComponent("Button");--打开自动开始界面
    self.AutoStartBtn.gameObject:SetActive(false);
    self.autoText = self.AutoStartBtn.transform:Find("AutoNum"):GetComponent("TextMeshProUGUI");--自动次数

    self.MaxChipBtn = self.btnGroup:Find("MaxChip"):GetComponent("Button");--最大下注
    self.closeAutoMenu = self.btnGroup:Find("CloseAutoMenu"):GetComponent("Button");--关闭自动开始界面
    self.autoSelectList = self.closeAutoMenu.transform:Find("AutoSelect");--自动开始次数选择
    self.closeAutoMenu.gameObject:SetActive(false);

    self.freePanel = self.MainContent:Find("FreePanel");
    self.freePanel.gameObject:SetActive(false);
    self.freeSelectOne = self.freePanel:Find("Group/FreeSelect1"):GetComponent("SkeletonGraphic");
    self.freeSelectTwo = self.freePanel:Find("Group/FreeSelect2"):GetComponent("SkeletonGraphic");
    self.freedownTime = self.freePanel:Find("Timer"):GetComponent("TextMeshProUGUI");

    self.rulePanel = self.MainContent:Find("Rule");--规则界面
    self.ruleList = self.rulePanel:Find("Content/RuleList"):GetComponent("ScrollRect");--规则子界面
    self.leftShowBtn = self.rulePanel:Find("Content/LeftBtn"):GetComponent("Button");
    self.rightShowBtn = self.rulePanel:Find("Content/RightBtn"):GetComponent("Button");
    self.closeRuleBtn = self.rulePanel:Find("Content/BackBtn"):GetComponent("Button");

    self.menuBtn = self.MainContent:Find("Menu"):GetComponent("Button");--菜单按钮
    self.menulist = self.MainContent:Find("MenuList");--菜单按钮详情
    self.backgroundBtn = self.MainContent:Find("CloseMenu"):GetComponent("Button");
    self.closeGame = self.menulist:Find("Content/Back"):GetComponent("Button");
    self.settingBtn = self.menulist:Find("Content/Setting"):GetComponent("Button");
    self.closeGame.transform:SetAsLastSibling();
    self.menulist.localScale = Vector3.New(0, 0, 0);
    self.backgroundBtn.gameObject:SetActive(false);
    self.showRuleBtn = self.MainContent:Find("RuleBtn"):GetComponent("Button");

    self.settingPanel = self.MainContent:Find("Setting");
    self.musicSet = self.settingPanel:Find("Content/Music"):GetComponent("Slider");
    self.soundSet = self.settingPanel:Find("Content/Sound"):GetComponent("Slider");
    self.closeSet = self.settingPanel:Find("Content/Close"):GetComponent("Button");

    self.resultEffect = self.MainContent:Find("Result");--中奖后特效
    self.winNormalEffect = self.resultEffect:Find("Reward");
    self.winNormalNum = self.winNormalEffect:Find("RewardNum"):GetComponent("TextMeshProUGUI");
    self.greatEffect = self.resultEffect:Find("Great");
    self.greatProgress = self.greatEffect:Find("Slider"):GetComponent("Slider");
    self.closeGreatBtn = self.greatEffect:Find("Close"):GetComponent("Button");
    self.winGreatNum = self.greatEffect:Find("Num"):GetComponent("TextMeshProUGUI");
    self.goodEffect = self.resultEffect:Find("Good");
    self.goodProgress = self.goodEffect:Find("Slider"):GetComponent("Slider");
    self.closegoodBtn = self.goodEffect:Find("Close"):GetComponent("Button");
    self.winGoodNum = self.goodEffect:Find("Num"):GetComponent("TextMeshProUGUI");
    self.perfectEffect = self.resultEffect:Find("Perfect");
    self.prefectProgress = self.perfectEffect:Find("Slider"):GetComponent("Slider");
    self.closeperfectBtn = self.perfectEffect:Find("Close"):GetComponent("Button");
    self.winPerfectNum = self.perfectEffect:Find("Num"):GetComponent("TextMeshProUGUI");
    self.bigEffect = self.resultEffect:Find("Big");
    self.bigProgress = self.bigEffect:Find("Content/Slider"):GetComponent("Slider");
    self.bigDJJY = self.bigEffect:Find("Content/DJJY").gameObject;
    self.bigFJYF = self.bigEffect:Find("Content/FJYF").gameObject;
    self.bigTXWS = self.bigEffect:Find("Content/TXWS").gameObject;
    self.closebigBtn = self.bigEffect:Find("Close"):GetComponent("Button");
    self.winBigNum = self.bigEffect:Find("Content/Num"):GetComponent("TextMeshProUGUI");
    self.smallEffect = self.resultEffect:Find("SmallReward");
    self.winSmallEffectNum = self.smallEffect:Find("Num"):GetComponent("TextMeshProUGUI");

    self.icons = self.MainContent:Find("Icons");--图标库
    self.effectList = self.MainContent:Find("EffectList");--动画库
    self.effectPool = self.MainContent:Find("EffectPool");--动画缓存库
    self.LineGroup = self.MainContent:Find("LineGroup");--连线
    self.CSGroup = self.MainContent:Find("CSContent");--显示财神
    self.soundList = self.MainContent:Find("SoundList");--声音库

    self.bjjEffect = self.MainContent:Find("BJJ");
    self.bjjKuGroup = self.bjjEffect:Find("KuGroup");
    self.bjjLightGroup = self.bjjEffect:Find("Group");

    self.dlBtn = self.MainContent:Find("DL/Group"):GetComponent("Button");
    for i = 1, self.dlBtn.transform.childCount do
        self.dlBtn.transform:GetChild(i - 1).gameObject:SetActive(false);
    end
    self.dlLightGroup = self.MainContent:Find("DL/LightGroup");
    for i = 1, self.dlLightGroup.childCount do
        self.dlLightGroup:GetChild(i - 1).gameObject:SetActive(false);
    end

    self.zpPanel = self.MainContent:Find("ZPPanel/Content");
    self.zpProgress = self.zpPanel:Find("Background/Progress/Value"):GetComponent("TextMeshProUGUI");
    self.zpSPImg = self.zpPanel:Find("Background/Progress/Image").gameObject;
    self.closeZPBtn = self.zpPanel:Find("Close"):GetComponent("Button");
    self.startZPBtn = self.zpPanel:Find("Background/Start"):GetComponent("Button");
    self.gbObj = self.zpPanel:Find("GB").gameObject;
    self.gbObj:SetActive(false);
    self.maskGroup = self.zpPanel:Find("Background/Group");
    for i = 1, self.maskGroup.childCount do
        self.maskGroup:GetChild(i - 1):GetComponent("Image").enabled = false;
    end
    self.smallGoldGroup = self.zpPanel:Find("Background/RewardGroup");
    for i = 1, self.smallGoldGroup.childCount do
        self.smallGoldGroup:GetChild(i - 1).gameObject:SetActive(false);
    end
    if not MusicManager:GetIsPlayMV() then
        self.musicSet.value = 0;
    else
        self.musicSet.value=MusicManager:GetMusicVolume();
        --if MusicManager.ge then
        --    local musicVol = PlayerPrefs.GetString("MusicValue");
        --    self.musicSet.value = tonumber(musicVol);
        --else
        --    self.musicSet.value = 1;
        --end
    end
    if not MusicManager.GetIsPlaySV() then
        self.soundSet.value = 0;
    else
        self.soundSet.value = MusicManager:GetSoundVolume();
        --if PlayerPrefs.HasKey("SoundValue") then
        --    local soundVol = PlayerPrefs.GetString("SoundValue");
        --    self.soundSet.value = tonumber(soundVol);
        --else
        --    self.soundSet.value = 1;
        --end
    end

end
function YGBHEntry.AddListener()
    --添加监听事件
    self.reduceChipBtn.onClick:RemoveAllListeners();
    self.reduceChipBtn.onClick:AddListener(self.ReduceChipCall);
    self.addChipBtn.onClick:RemoveAllListeners();
    self.addChipBtn.onClick:AddListener(self.AddChipCall);
    self.startBtn:GetComponent("Button").onClick:RemoveAllListeners();
    self.startBtn:GetComponent("Button").onClick:AddListener(self.StartGameCall);
    local et = self.startBtn.gameObject:AddComponent(typeof(LuaFramework.EventTriggerListener));
    et.onDown = self.OnDownStartBtnCall;
    et.onUp = self.OnUpStartBtnCall;
    self.stopBtn.onClick:RemoveAllListeners();
    self.stopBtn.onClick:AddListener(self.StartGameCall);

    self.menuBtn.onClick:RemoveAllListeners();
    self.menuBtn.onClick:AddListener(self.ClickMenuCall);
    self.backgroundBtn.onClick:RemoveAllListeners();
    self.backgroundBtn.onClick:AddListener(self.CloseMenuCall);
    self.closeGame.onClick:RemoveAllListeners();
    self.closeGame.onClick:AddListener(self.CloseGameCall);
    self.settingBtn.onClick:RemoveAllListeners();
    self.settingBtn.onClick:AddListener(self.OpenSettingPanel);
    self.musicSet.onValueChanged:RemoveAllListeners();
    self.musicSet.onValueChanged:AddListener(self.SetMusicVolumn);
    self.soundSet.onValueChanged:RemoveAllListeners();
    self.soundSet.onValueChanged:AddListener(self.SetSoundVolumn);
    self.closeSet.onClick:RemoveAllListeners();
    self.closeSet.onClick:AddListener(function()
        self.settingPanel.gameObject:SetActive(false);
    end);

    self.AutoStartBtn.onClick:RemoveAllListeners();
    self.AutoStartBtn.onClick:AddListener(self.OnClickAutoCall);
    for i = 1, self.autoSelectList.childCount do
        --自动次数选择
        local child = self.autoSelectList:GetChild(i - 1);
        child:GetComponent("Button").onClick:RemoveAllListeners();
        child:GetComponent("Button").onClick:AddListener(function()
            self.currentAutoCount = tonumber(child.name);
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

    self.freeSelectOne.transform:GetComponent("Button").onClick:RemoveAllListeners();
    self.freeSelectOne.transform:GetComponent("Button").onClick:AddListener(function()
        self.OnSelectFreeTypeCall(self.freeSelectOne, self.freeSelectTwo, 1);
    end);
    self.freeSelectTwo.transform:GetComponent("Button").onClick:RemoveAllListeners();
    self.freeSelectTwo.transform:GetComponent("Button").onClick:AddListener(function()
        self.OnSelectFreeTypeCall(self.freeSelectTwo, self.freeSelectOne, 2);
    end);

    self.closeGreatBtn.onClick:RemoveAllListeners();
    self.closeGreatBtn.onClick:AddListener(function()
        YGBH_Result.QuickOver(1);
    end);
    self.closegoodBtn.onClick:RemoveAllListeners();
    self.closegoodBtn.onClick:AddListener(function()
        YGBH_Result.QuickOver(2);
    end);
    self.closeperfectBtn.onClick:RemoveAllListeners();
    self.closeperfectBtn.onClick:AddListener(function()
        YGBH_Result.QuickOver(3);
    end);
    self.closebigBtn.onClick:RemoveAllListeners();
    self.closebigBtn.onClick:AddListener(function()
        YGBH_Result.QuickOver(4);
    end);

    self.dlBtn.onClick:RemoveAllListeners();
    self.dlBtn.onClick:AddListener(self.OpenZP);

    self.closeZPBtn.onClick:RemoveAllListeners();
    self.closeZPBtn.onClick:AddListener(self.CloseZP);

    self.startZPBtn.onClick:RemoveAllListeners();
    self.startZPBtn.onClick:AddListener(function()
        self.startZPBtn.gameObject:SetActive(false);
        self.zpProgress.transform.parent.gameObject:SetActive(true);
        self.zpProgress.text = "0/6";
        YGBH_Network.StartSmallGame();
    end);
end
function YGBHEntry.GetGameConfig()
    --获取远程端配置
    local formdata = FormData.New();
    formdata:AddField("v", os.time());
    UnityWebRequestManager.Instance:GetText("http://127.0.0.1:80/module27.json", 4, formdata, function(state, result)
        log(result);
        local data = json.decode(result);
        YGBH_DataConfig.rollTime = data.rollTime;
        YGBH_DataConfig.rollReboundRate = data.rollReboundRate;
        YGBH_DataConfig.rollInterval = data.rollInterval;
        YGBH_DataConfig.rollSpeed = data.rollSpeed;
        YGBH_DataConfig.caijinGoldChangeRate = data.caijinGoldChangeRate;
        YGBH_DataConfig.winGoldChangeRate = data.winGoldChangeRate;
        YGBH_DataConfig.selfGoldChangeRate = data.selfGoldChangeRate;
        YGBH_DataConfig.freeLoadingShowTime = data.freeLoadingShowTime;
        YGBH_DataConfig.smallGameLoadingShowTime = data.smallGameLoadingShowTime;
        YGBH_DataConfig.rollDistance = data.rollDistance;
        YGBH_DataConfig.REQCaiJinTime = data.REQCaiJinTime;
        YGBH_DataConfig.lineAllShowTime = data.lineAllShowTime;
        YGBH_DataConfig.cyclePlayLineTime = data.cyclePlayLineTime;
        YGBH_DataConfig.waitShowLineTime = data.waitShowLineTime;
        YGBH_DataConfig.autoRewardInterval = data.autoRewardInterval;
        YGBH_DataConfig.autoNoRewardInterval = data.autoNoRewardInterval;
    end);
end
function YGBHEntry.ToCharArray(num)
    --拆解字符串
    local str = tostring(num);
    local list1 = {}
    for i = 1, string.len(str) do
        table.insert(list1, #list1 + 1, string.sub(str, i, i));
    end
    return list1;
end
function YGBHEntry.FormatNumberThousands(num)
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
function YGBHEntry.ShowText(str)
    --展示tmp字体
    local arr = self.ToCharArray(str);
    local _str = "";
    for i = 1, #arr do
        _str = _str .. string.format("<sprite name=\"%s\">", arr[i]);
    end
    return _str;
end
function YGBHEntry.ReduceChipCall()
    --减注
    YGBH_Audio.PlaySound(YGBH_Audio.SoundList.BTN);
    if self.SceneData.chipList == nil or self.SceneData.nBetonCount <= 0 then
        return ;
    end
    self.CurrentChipIndex = self.CurrentChipIndex - 1;
    if self.CurrentChipIndex <= 0 then
        self.CurrentChipIndex = self.SceneData.nBetonCount;
    end
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = tostring(self.CurrentChip * YGBH_DataConfig.ALLLINECOUNT);
end
function YGBHEntry.AddChipCall()
    --加注
    YGBH_Audio.PlaySound(YGBH_Audio.SoundList.BTN);
    if self.SceneData.chipList == nil or self.SceneData.nBetonCount <= 0 then
        return ;
    end
    self.CurrentChipIndex = self.CurrentChipIndex + 1;
    if self.CurrentChipIndex > self.SceneData.nBetonCount then
        self.CurrentChipIndex = 1;
    end
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = tostring(self.CurrentChip * YGBH_DataConfig.ALLLINECOUNT);
end
function YGBHEntry.SetMusicVolumn(value)
    log(value)
    if value == 0 then
        AllSetGameInfo._5IsPlayAudio = false;
        YGBH_Audio.pool.mute = true;
    else
        AllSetGameInfo._5IsPlayAudio = true;
        YGBH_Audio.pool.mute = false;
    end
    Util.Write("IsPlayAudio", tostring(AllSetGameInfo._5IsPlayAudio));
    PlayerPrefs.SetString("IsPlayAudio", tostring(AllSetGameInfo._5IsPlayAudio));
    PlayerPrefs.SetString("SoundValue", tostring(value));
    if not PlayerPrefs.HasKey("SoundValue") then
        PlayerPrefs.SetString("SoundValue", tostring(1));
    end
    local soundValue = tonumber(PlayerPrefs.GetString("SoundValue"));
    GameManager.SetIsPlayMute(AllSetGameInfo._6IsPlayEffect, AllSetGameInfo._5IsPlayAudio);
    MusicManager:SetValue(soundValue, value);
end
function YGBHEntry.SetSoundVolumn(value)
    if value == 0 then
        AllSetGameInfo._6IsPlayEffect = false;
    else
        AllSetGameInfo._6IsPlayEffect = true;
    end
    Util.Write("isCanPlaySound", tostring(AllSetGameInfo._6IsPlayEffect));
    PlayerPrefs.SetString("isCanPlaySound", tostring(AllSetGameInfo._5IsPlayAudio));
    PlayerPrefs.SetString("SoundValue", tostring(value));
    if not PlayerPrefs.HasKey("MusicValue") then
        PlayerPrefs.SetString("MusicValue", tostring(1));
    end
    local musicValue = tonumber(PlayerPrefs.GetString("MusicValue"));
    GameManager.SetIsPlayMute(AllSetGameInfo._6IsPlayEffect, AllSetGameInfo._5IsPlayAudio);
    MusicManager:SetValue(value, musicValue);
end
function YGBHEntry.StartGameCall()
    --开始游戏
    self.startBtn.transform:GetComponent("Image").color = Color.gray;
    self.startBtn:GetComponent("Button").interactable = false;
    if self.isFreeGame or self.isAutoGame then
        return ;
    end
    if self.isRoll then
        --TODO 急停
        self.startBtn.gameObject:SetActive(true);
        self.stopBtn.gameObject:SetActive(false);
        YGBH_Roll.StopRoll();
        return ;
    end

    if self.myGold < self.CurrentChip * YGBH_DataConfig.ALLLINECOUNT then
        MessageBox.CreatGeneralTipsPanel("Insufficient gold coins!")
        return ;
    end
    YGBH_Audio.PlaySound(YGBH_Audio.SoundList.BTN);
    self.addChipBtn.interactable = false;
    self.reduceChipBtn.interactable = false;
    self.MaxChipBtn.interactable = false;
    self.startBtn.gameObject:SetActive(false);
    self.stopBtn.gameObject:SetActive(true);
    self.FreeContent.gameObject:SetActive(false);
    self.AutoStartBtn.gameObject:SetActive(false);
    --TODO 发送开始消息,等待结果开始转动
    YGBH_Network.StartGame();
end
function YGBHEntry.ClickMenuCall()
    --点击显示菜单
    YGBH_Audio.PlaySound(YGBH_Audio.SoundList.BTN);
    if self.menuTweener ~= nil then
        self.menuTweener:Kill();
    end
    self.backgroundBtn.gameObject:SetActive(true);
    self.backgroundBtn.interactable = false;
    self.menulist.gameObject:SetActive(true);
    self.menuTweener = self.menulist:DOScale(Vector3.New(1, 1, 1), 0.2):OnComplete(function()
        self.backgroundBtn.interactable = true;
        if self.menuTweener ~= nil then
            self.menuTweener = nil;
        end
    end);
    if self.menuTweener ~= nil then
        self.menuTweener:SetAutoKill();
    end
end
function YGBHEntry.CloseMenuCall()
    --关闭菜单
    YGBH_Audio.PlaySound(YGBH_Audio.SoundList.BTN);
    if self.menuTweener ~= nil then
        self.menuTweener:Kill();
    end
    self.backgroundBtn.interactable = false;
    self.menuTweener = self.menulist:DOScale(Vector3.New(0, 0, 0), 0.2):OnComplete(function()
        self.backgroundBtn.interactable = true;
        self.menulist.gameObject:SetActive(false);
        self.backgroundBtn.gameObject:SetActive(false);
        if self.menuTweener ~= nil then
            self.menuTweener = nil;
        end
    end);
    if self.menuTweener ~= nil then
        self.menuTweener:SetAutoKill();
    end
end
function YGBHEntry.CloseGameCall()
    if self.isFreeGame or self.isSmallGame then
        MessageBox.CreatGeneralTipsPanel("Unable to quit the game in special games")
        return
    end
    Event.Brocast(MH.Game_LEAVE);
end
function YGBHEntry.OpenSettingPanel()
    self.CloseMenuCall();
    self.settingPanel.gameObject:SetActive(true);
end
function YGBHEntry.SetSoundCall()
    if AllSetGameInfo._5IsPlayAudio or AllSetGameInfo._6IsPlayEffect then
        SetInfoSystem.GameMute();
        self.soundOn:SetActive(false);
        self.soundOff:SetActive(true);
    else
        SetInfoSystem.ResetMute();
        self.soundOn:SetActive(true);
        self.soundOff:SetActive(false);
    end
    YGBH_Audio.pool.mute = not AllSetGameInfo._5IsPlayAudio;
end
function YGBHEntry.OnDownStartBtnCall()
    self.clickStartTimer = 0;
    self.autoEffect.gameObject:SetActive(true);
    self.ispress = true;
end
function YGBHEntry.OnUpStartBtnCall()
    self.ispress = false;
    self.autoEffect.gameObject:SetActive(false);
    self.clickStartTimer = -1;
end
function YGBHEntry.OnClickAutoCall()
    --点击自动开始
    YGBH_Audio.PlaySound(YGBH_Audio.SoundList.BTN);
    if self.isAutoGame then
        self.StopAutoGame();
        return ;
    end
    self.closeAutoMenu.gameObject:SetActive(true);
end
function YGBHEntry.OnSelectFreeTypeCall(selectObj, unselectObj, index)
    --选择免费类型
    YGBH_Audio.PlaySound(YGBH_Audio.SoundList.FREESELECT);
    self.showFreeTimer = YGBH_DataConfig.freeWaitTime;
    self.isshowFree = false;
    YGBH_Network.SelectFree();
    if self.ResultData.m_FreeType == 13 then
        selectObj.transform:GetChild(0).gameObject:SetActive(true);
        unselectObj.transform:GetChild(1).gameObject:SetActive(true);
        selectObj.AnimationState:SetAnimation(0, "zx_03", false);
        unselectObj.AnimationState:SetAnimation(0, "bjj_03", false);
    elseif self.ResultData.m_FreeType == 14 then
        selectObj.transform:GetChild(1).gameObject:SetActive(true);
        unselectObj.transform:GetChild(0).gameObject:SetActive(true);
        selectObj.AnimationState:SetAnimation(0, "bjj_03", false);
        unselectObj.AnimationState:SetAnimation(0, "zx_03", false);
    end
    local pos = nil;
    if index == 1 then
        pos = Vector3.New(1334, -100, 0);
    else
        pos = Vector3.New(-1334, -100, 0);
    end
    local outEffect = function()
        coroutine.wait(0.8);
        self.freedownTime.text = "";
        local showDescFunc = function()
            local backImg = self.freePanel:Find("Background");
            if self.ResultData.m_FreeType == 13 then
                self.freePanel:GetComponent("Animator"):SetTrigger("ZX");
            else
                self.freePanel:GetComponent("Animator"):SetTrigger("BJJ");
            end
            while backImg.gameObject.activeSelf do
                coroutine.wait(0.01);
            end
            self.freePanel.gameObject:SetActive(false);
            --TODO 开始免费游戏
            if self.ResultData.m_FreeType == 13 then
                --如果是紫霞模式
                for i = #self.ResultData.m_nIconLie, 1, -1 do
                    if self.ResultData.m_nIconLie[i] > 0 then
                        self.CSGroup:GetChild(i - 1):Find("Item").gameObject:SetActive(true);
                        coroutine.wait(0.1);
                    end
                end
                YGBH_Audio.PlayBGM(YGBH_Audio.SoundList.BGM_ZX);
            else
                YGBH_Audio.PlayBGM(YGBH_Audio.SoundList.BGM_BJJ);
            end
            self.FreeGame();
        end
        unselectObj.transform:DOLocalMove(pos, 0.5);
        unselectObj:DOFade(0, 0.5);
        unselectObj.transform:DOScale(Vector3.New(0.5, 0.5, 0.5), 0.5):OnComplete(function()
            unselectObj.gameObject:SetActive(false);
            unselectObj:DOFade(1, 0.01);
            unselectObj.transform:DOScale(Vector3.New(1, 1, 1), 0.01);
            coroutine.stop(showDescFunc);
            coroutine.start(showDescFunc);
        end);
        selectObj.transform:DOLocalMove(Vector3.New(0, 0, 0), 0.5);
    end
    coroutine.stop(outEffect);
    coroutine.start(outEffect);
end
function YGBHEntry.OnClickAutoItemCall()
    --点击选择自动次数
    YGBH_Audio.PlaySound(YGBH_Audio.SoundList.BTN);
    self.isAutoGame = true;
    self.ispress = false;
    self.stopBtn.gameObject:SetActive(false);
    self.startBtn.transform:GetComponent("Image").color = Color.gray;
    self.startBtn.gameObject:SetActive(false);
    self.FreeContent.gameObject:SetActive(false);
    self.AutoStartBtn.gameObject:SetActive(true);
    self.closeAutoMenu.gameObject:SetActive(false);
    YGBHEntry.addChipBtn.interactable = false;
    YGBHEntry.reduceChipBtn.interactable = false;
    YGBHEntry.MaxChipBtn.interactable = false;
    if self.isFreeGame then
        self.FreeContent.gameObject:SetActive(true);
        self.AutoStartBtn.gameObject:SetActive(false);
    else
        if self.myGold < self.CurrentChip * YGBH_DataConfig.ALLLINECOUNT then
            MessageBox.CreatGeneralTipsPanel("Insufficient gold coins!")
            return ;
        end
    end
    if self.currentAutoCount > 1000 then
        self.autoText.text = "∞";
    else
        self.autoText.text = tostring(self.currentAutoCount);
    end
    if not self.isRoll and not self.isFreeGame then
        --没有转动的状态开始自动旋转
        log("开始自动游戏")
        YGBH_Network.StartGame();
    end
end
function YGBHEntry.ShowRultPanel()
    --显示规则
    YGBH_Audio.PlaySound(YGBH_Audio.SoundList.BTN);
    YGBH_Rule.ShowRule();
end
function YGBHEntry.SetMaxChipCall()
    --设置最大下注
    YGBH_Audio.PlaySound(YGBH_Audio.SoundList.BTN);
    self.CurrentChipIndex = self.SceneData.nBetonCount;
    self.CurrentChip = self.SceneData.chipList[self.CurrentChipIndex];
    self.ChipNum.text = tostring(self.CurrentChip * YGBH_DataConfig.ALLLINECOUNT);
end

function YGBHEntry.CSJLRoll()
    YGBH_Network.StartGame();
end
function YGBHEntry.StopAutoGame()
    --停止自动旋转
    self.isAutoGame = false;
    self.currentAutoCount = 0;
    self.stopBtn.gameObject:SetActive(false);
    self.startBtn.gameObject:SetActive(true);
    self.FreeContent.gameObject:SetActive(false);
    self.AutoStartBtn.gameObject:SetActive(false);
end
function YGBHEntry.FreeGame()
    --免费游戏
    self.isFreeGame = true;
    self.startBtn.gameObject:SetActive(false);
    self.stopBtn.gameObject:SetActive(false);
    self.AutoStartBtn.gameObject:SetActive(false);
    self.FreeContent.gameObject:SetActive(true);
    self.FreeContent.transform:Find("Num"):GetComponent("TextMeshProUGUI").text = self.ShowText(self.freeCount);
    YGBH_Network.StartGame();
end
function YGBHEntry.ChangeGold(gold)
    self.selfGold.text = tostring(gold);
end
function YGBHEntry.Roll()
    --开始转动    
    self.WinDesc.text = "Great fortune";
    if not self.isFreeGame and not YGBH_Result.isWinCSJL then
        self.myGold = self.myGold - self.CurrentChip * YGBH_DataConfig.ALLLINECOUNT;
        YGBHEntry.ChangeGold(self.myGold);
    end
    self.WinNum.text = "0";
    YGBH_Result.HideResult();
    YGBH_Line.Close();
    YGBH_Roll.StartRoll();
end
function YGBHEntry.OnStop()
    --停止转动
    log("停止")
    YGBH_Result.ShowResult();
end
function YGBHEntry.InitPanel()
    --场景消息初始化
    self.myGold = TableUserInfo._7wGold;
    YGBHEntry.ChangeGold(self.myGold);
    for i = 1, self.SceneData.nBetonCount do
        if self.SceneData.chipList[i] == self.SceneData.bet then
            self.CurrentChipIndex = i;
            self.CurrentChip = self.SceneData.bet;
            self.ChipNum.text = tostring(self.CurrentChip * YGBH_DataConfig.ALLLINECOUNT);
        end
    end
    self.WinNum.text = "0";
    YGBH_Caijin.isCanSend = true;
    self.isRoll = false;
    YGBH_Line.Init();
    YGBH_Result.Init();
    if self.SceneData.freeNumber > 0 then
        --如果免费
        self.freeCount = self.SceneData.freeNumber;
        self.ResultData.FreeCount = self.freeCount;
        self.ResultData.m_FreeType = self.SceneData.nFreeType;
        self.isFreeGame = true;
        YGBH_Result.isFreeGame = true;
        if self.SceneData.freeNumber == 5 then
            YGBH_Result.ShowFreeEffect(true);
        else
            if self.SceneData.nFreeType == 13 then
                YGBH_Audio.PlayBGM(YGBH_Audio.SoundList.BGM_ZX);
                for i = #YGBHEntry.SceneData.nFreeIcon_lie, 1, -1 do
                    local item = YGBHEntry.CSGroup:GetChild(i - 1):Find("Item").gameObject;
                    if YGBHEntry.SceneData.nFreeIcon_lie[i] > 0 and not item.activeSelf then
                        item:SetActive(true);
                        coroutine.wait(0.1);
                    end
                end
            elseif self.SceneData.nFreeType == 14 then
                YGBH_Audio.PlayBGM(YGBH_Audio.SoundList.BGM_BJJ);
            end
            YGBHEntry.addChipBtn.interactable = false;
            YGBHEntry.reduceChipBtn.interactable = false;
            YGBHEntry.MaxChipBtn.interactable = false;
            YGBH_Result.CheckFree();
        end
    end
    --看碎片
    YGBHEntry.smallSPCount = 0;
    self.smallSPRealCount = 0;
    for i = 1, #self.SceneData.smallGameTrack do
        if self.SceneData.smallGameTrack[i] > 0 then
            if i <= #self.SceneData.smallGameTrack - 2 then
                self.smallSPRealCount = self.smallSPRealCount + 1;
            end
            YGBHEntry.smallSPCount = YGBHEntry.smallSPCount + 1;
        end
    end
    for i = 1, YGBHEntry.smallSPCount do
        self.dlBtn.transform:GetChild(i - 1).gameObject:SetActive(true);
    end
    if YGBHEntry.smallSPCount >= 8 then
        --碎片集满了，开启小游戏
        self.FullSP = true;
        YGBH_Result.CheckFree();
    end
end
function YGBHEntry.OpenZP()
    self.maskGroup.parent.localScale = Vector3.New(0, 0, 0);
    YGBHEntry.smallSPRealCount = 0;
    for i = 1, #self.SceneData.smallGameTrack do
        local index = YGBH_DataConfig.ZPList[i];
        if self.SceneData.smallGameTrack[i] > 0 then
            if i <= #self.SceneData.smallGameTrack - 2 then
                YGBHEntry.smallSPRealCount = YGBHEntry.smallSPRealCount + 1;
            end
            YGBHEntry.maskGroup:GetChild(index - 1):GetComponent("Image").enabled = false;
            self.smallGoldGroup:GetChild(index - 1):GetComponent("TextMeshProUGUI").text = tostring(self.SceneData.smallGameTrack[i]);
        else
            YGBHEntry.maskGroup:GetChild(index - 1):GetComponent("Image").enabled = true;
            self.smallGoldGroup:GetChild(index - 1):GetComponent("TextMeshProUGUI").text = "";
        end
        self.smallGoldGroup:GetChild(index - 1).gameObject:SetActive(true);
    end
    self.zpProgress.text = YGBHEntry.smallSPRealCount .. "/6";
    self.zpSPImg:SetActive(YGBHEntry.smallSPCount > 0);
    self.zpPanel.parent.gameObject:SetActive(true);
    self.zpPanel:Find("Mask/Image"):DOScale(Vector3.New(1, 1, 1), 0.3);
    self.maskGroup.parent:DOScale(Vector3.New(1, 1, 1), 0.3):SetEase(DG.Tweening.Ease.OutBack);
    self.closeZPBtn.gameObject:SetActive(not self.FullSP);
    if self.FullSP then
        self.startZPBtn.gameObject:SetActive(true);
        self.zpProgress.transform.parent.gameObject:SetActive(false);
    else
        self.startZPBtn.gameObject:SetActive(false);
        self.zpProgress.transform.parent.gameObject:SetActive(true);
    end
end
function YGBHEntry.CloseZP()
    self.zpPanel:Find("Mask/Image"):DOScale(Vector3.New(0, 0, 0), 0.3);
    self.maskGroup.parent:DOScale(Vector3.New(0, 0, 0), 0.3):OnComplete(function()
        self.zpPanel.parent.gameObject:SetActive(false);
    end)
end
function YGBHEntry.RollZP()
    --转转盘
    self.currentSmallRollIndex = 0;
    self.currentSmallCycleCount = 0;
    self.smallRollTimer = 0;
    self.smallTempRollTimer = YGBH_DataConfig.smallRollDurationTime;
    self.isLastCycle = false;
    self.gbObj.transform:SetParent(self.maskGroup:GetChild(self.currentSmallRollIndex));
    self.gbObj.transform.localPosition = Vector3.New(YGBH_DataConfig.smallLighIconPos[1], YGBH_DataConfig.smallLighIconPos[2], YGBH_DataConfig.smallLighIconPos[3]);
    self.gbObj.transform.localRotation = Quaternion.Euler(0, 0, YGBH_DataConfig.smallLighIconAngle);
    self.gbObj.gameObject:SetActive(true);
    self.StartRollSmallGame();
end
function YGBHEntry.ShowFreeGame()
    --显示免费界面
    self.freePanel.gameObject:SetActive(true);
    self.freeSelectOne.transform:DOLocalMove(Vector3.New(-230, 0, 0), 0.3);
    self.freeSelectTwo.transform:DOLocalMove(Vector3.New(230, 0, 0), 0.3);
    self.freedownTime.gameObject:SetActive(true);
    local parent = self.freeSelectOne.transform.parent;
    for i = 1, parent.childCount do
        parent:GetChild(i - 1).gameObject:SetActive(true);
        for j = 1, parent:GetChild(i - 1).childCount do
            parent:GetChild(i - 1):GetChild(j - 1).gameObject:SetActive(false);
        end
    end
    self.freeSelectOne.AnimationState:SetAnimation(0, "bjj_01", true);
    self.freeSelectTwo.AnimationState:SetAnimation(0, "zx_01", true);
    self.showFreeTimer = YGBH_DataConfig.freeWaitTime;
    self.isshowFree = true;
end
function YGBHEntry.FreeRoll()
    --判断是否为免费游戏
    YGBH_Result.isShow = false;
    if self.isFreeGame then
        if self.freeCount <= 0 then
            --免费结束
            if YGBH_Result.showFreeTweener ~= nil then
                YGBH_Result.showFreeTweener:Kill();
                YGBH_Result.showFreeTweener = nil;
            end
            self.FreeContent.gameObject:SetActive(false);
            self.isFreeGame = false;
            for i = 1, self.CSGroup.childCount do
                for j = 1, self.CSGroup:GetChild(i - 1).childCount do
                    self.CSGroup:GetChild(i - 1):GetChild(j - 1).gameObject:SetActive(false);
                end
            end

            YGBH_Audio.PlayBGM();
            self.AutoRoll();
        else
            --还有免费次数
            self.FreeGame();
        end
    else
        self.AutoRoll();
    end
end
function YGBHEntry.AutoRoll()
    --判断是否为自动游戏
    if self.isAutoGame then
        --如果是自动游戏
        if self.currentAutoCount < 1000 then
            self.currentAutoCount = self.currentAutoCount - 1;
        end
        if self.currentAutoCount < 0 then
            --自动次数使用完了，回到待机状态
            self.StopAutoGame();
            YGBHEntry.startBtn.transform:GetComponent("Image").color = Color.white;
            YGBHEntry.startBtn:GetComponent("Button").interactable = true;
            YGBHEntry.addChipBtn.interactable = true;
            YGBHEntry.reduceChipBtn.interactable = true;
            YGBHEntry.MaxChipBtn.interactable = true;
        else
            --还有自动次数
            self.OnClickAutoItemCall();
        end
    else
        --不是自动游戏，直接待机
        self.StopAutoGame();
        YGBHEntry.startBtn.transform:GetComponent("Image").color = Color.white;
        YGBHEntry.startBtn:GetComponent("Button").interactable = true;
        YGBHEntry.addChipBtn.interactable = true;
        YGBHEntry.reduceChipBtn.interactable = true;
        YGBHEntry.MaxChipBtn.interactable = true;
    end
end