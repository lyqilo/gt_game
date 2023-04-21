require "Module55.niuniu.TBNNSCInfo"
require "Module55.niuniu.TBNNDataStruct"
require "Module55.niuniu.TBNNPlayer"



TBNNPanel = {};
local self = TBNNPanel;
local GameState = 0;
local transform;
local gameobject;
local NiuNiu
local niuniuluaBehaviour
local NiuNiu_PlayerInfoPanel
NiuNiuAllPlayerTable = {};
local NiuNiuChipValue = { 1, 2, 3, 4 };
local IsTest = false;
local ChoosePokerNum = 0;
local PlayerChoosePoker = {};
local MyselfPokerTab = {};

local isPlayPKPoker=true

local isClearnGame=true

local isAutoChip=true

local fun =nil
-- 判断用户是否是游戏中进入
NiuNiu_IsGameStartIn = true;

-- 判断玩家是否参与当局游戏
NiuNiu_IsPlayingGame = false;

-- 提示界面Obj
local NiuNiu_HintInfoPanel = nil;

local IsBankerTime = false;

-- 判断是否自己开牌
local IsMyselfOpen = true;

-- 是否继续倒计时计时
local IsSetTimeNum = false;

-- 1s30次倒计时计数
local timeNum = 0;
local TimeAllNum = 0;

-- 经过的时间
local timing = 0;

-- 储存删除的筹码信息;
-- 房间底注
local iBaseChipValue = 100;


--玩家中途退出各种信息存储
local sta1 = {};
local stanum1 = 1
local sta2 = {};
local stanum2 = 1
local sta3 = {}
local stanum3 = 1;
local sta4 = {}
local stanum4 = 1;

--玩家刚刚进入信息存储
local sta5 = {}
local stanum5 = 1;


delchiptable = {
    [1] = {};
    [2] = {};
    [3] = {};
    [4] = {};
    [5] = {};
    [6] = {};
    [7] = {};
}

-- 当前点击得牌位置
local ClickPoketNum = { 0, 0, 0 };


function TBNNPanel:New()
    local t = o or {};
    setmetatable(t, self);
    self.__index = self
    return t;
end

function TBNNPanel.CreatPanel()
end

local MHallgo;


function TBNNPanel:Start(obj)
    self.transform = obj.transform;
    self.transform:Find("EventSystem").gameObject:SetActive(false);

    --self.deskBg=self.transform:Find("Bg/desk/Left1")
    --self.deskBg:GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.height / Screen.width) * 750 + 20, 750 + 20);

    niuniuluaBehaviour = self.transform:GetComponent('LuaBehaviour');
    -- 加载游戏声音资源
    --LoadAssetAsync('module03/game_niuniu_musictwo', 'NiuNiu_Music', self.CreatMusic);
    self.CreatMusic(Module55Panel.Pool("NiuNiu_Music"));--加载音乐资源--初始化消息--发送准备事件
    self.LuaBehaviour = niuniuluaBehaviour;
    delchiptable = {
        [1] = {};
        [2] = {};
        [3] = {};
        [4] = {};
        [5] = {};
        [6] = {};
        [7] = {};
    }
    IsSetTimeNum = false;
    self.waitPanel=self.transform:Find("Bg/waitPanel")
    --self.waitPanel.gameObject:SetActive(false)
    -- 游戏开始先清理所有的消息、数据（防止非正常退出时问题）
    obj.name = "NiuNiu";
    obj.transform.localScale = Vector3.one;
    obj.transform.localPosition = Vector3.New(0, 0, 0);
    NiuNiu = obj
    self.ClearInfo()--清理数据
    self.FindComponent();--219  查找游戏中的对象
    self.AddPlayerLua();---绑定玩家lua脚本
    --GameManager.GameScenIntEnd();
    -- 自己的座位
    TBNNMH.MySelf_ChairID = 65535;
    -- 庄家座位号
    TBNNMH.Banker_ChairID = 65535;
    NiuNiu_IsGameStartIn = true;
    NiuNiu_IsPlayingGame = false;
    IsMyselfOpen = true;
    IsBankerTime = false;
    IsSetTimeNum = false;
    timeNum = 0;
    TimeAllNum = 0;
    timing = 0;
end

function TBNNPanel.CreatBg()

end

-- 加载帮助
function TBNNPanel.CreatHelp(prefeb)
    self.Help = prefeb
    self.Help.transform:SetParent(self.transform);
    self.Help.transform.localScale = Vector3.one;
    self.Help.transform.localPosition = Vector3.New(0, 0, 0);
    self.CloseHelp = self.Help.transform:Find("CloseBtn").gameObject;
    self.CloseHelp2 = self.Help.transform:Find("BG/Btn_InstructionQuit").gameObject;
    self.Btn_BaseCard = self.Help.transform:Find("BG/Btn_BaseCard").gameObject;  --paixing
    self.Btn_BigORSmall = self.Help.transform:Find("BG/Btn_Compare").gameObject;  --daxia
    self.HelpImage1 = self.Help.transform:Find("BG/Btn_BaseCard1").gameObject;  --daxia
    self.HelpImage2 = self.Help.transform:Find("BG/Btn_Compare1").gameObject;  --daxia
    self.Btn_BaseCard:GetComponent("Button").interactable=false
    self.Btn_BigORSmall:GetComponent("Button").interactable=true
    self.HelpImage1:SetActive(true)
    self.HelpImage2:SetActive(false)

    local a = function() 
        destroy(self.Help); 
        self.Help = nil; 
    end
    local b = function ()
        self.Btn_BaseCard:GetComponent("Button").interactable=false
        self.Btn_BigORSmall:GetComponent("Button").interactable=true
        self.HelpImage1:SetActive(true)
        self.HelpImage2:SetActive(false)
    end
    local c = function ()
        self.Btn_BaseCard:GetComponent("Button").interactable=true
        self.Btn_BigORSmall:GetComponent("Button").interactable=false
        self.HelpImage1:SetActive(false)
        self.HelpImage2:SetActive(true)
    end
    niuniuluaBehaviour:AddClick(self.Btn_BaseCard, b);
    niuniuluaBehaviour:AddClick(self.Btn_BigORSmall, c);
    niuniuluaBehaviour:AddClick(self.CloseHelp, a);
    niuniuluaBehaviour:AddClick(self.CloseHelp2, a);
end
-- 加载声音资源
function TBNNPanel.CreatMusic(prefeb)
    self.Musicprefeb = prefeb;
    self.Musicprefeb.transform:SetParent(self.transform);
    -- 添加背景音乐
    self.BtnMusic = self.Musicprefeb.transform:Find("Btn_Sure"):GetComponent('AudioSource').clip
    self.ChipBtnMusic = self.Musicprefeb.transform:Find("Btn_Chip"):GetComponent('AudioSource').clip
    self.CardBtnMusic = self.Musicprefeb.transform:Find("Card"):GetComponent('AudioSource').clip
    self.WinMusic = self.Musicprefeb.transform:Find("Win"):GetComponent('AudioSource').clip
    self.Win1Music = self.Musicprefeb.transform:Find("Win1"):GetComponent('AudioSource').clip
    self.Win2Music = self.Musicprefeb.transform:Find("Win2"):GetComponent('AudioSource').clip
    --self.LoseMusic = self.Musicprefeb.transform:Find("Lose"):GetComponent('AudioSource').clip
    self.GoldMusic = self.Musicprefeb.transform:Find("Gold"):GetComponent('AudioSource').clip
    self.HandMusic = self.Musicprefeb.transform:Find("Hand"):GetComponent('AudioSource').clip

    self.N0 = self.Musicprefeb.transform:Find("niu0"):GetComponent('AudioSource').clip
    self.N1 = self.Musicprefeb.transform:Find("niu1"):GetComponent('AudioSource').clip
    self.N2 = self.Musicprefeb.transform:Find("niu2"):GetComponent('AudioSource').clip
    self.N3 = self.Musicprefeb.transform:Find("niu3"):GetComponent('AudioSource').clip
    self.N4 = self.Musicprefeb.transform:Find("niu4"):GetComponent('AudioSource').clip
    self.N5 = self.Musicprefeb.transform:Find("niu5"):GetComponent('AudioSource').clip
    self.N6 = self.Musicprefeb.transform:Find("niu6"):GetComponent('AudioSource').clip
    self.N7 = self.Musicprefeb.transform:Find("niu7"):GetComponent('AudioSource').clip
    self.N8 = self.Musicprefeb.transform:Find("niu8"):GetComponent('AudioSource').clip
    self.N9 = self.Musicprefeb.transform:Find("niu9"):GetComponent('AudioSource').clip
    self.N10 = self.Musicprefeb.transform:Find("niu10"):GetComponent('AudioSource').clip
    self.N11 = self.Musicprefeb.transform:Find("niu11"):GetComponent('AudioSource').clip
    self.N12 = self.Musicprefeb.transform:Find("niu12"):GetComponent('AudioSource').clip
    self.N13 = self.Musicprefeb.transform:Find("niu13"):GetComponent('AudioSource').clip
    self.N14 = self.Musicprefeb.transform:Find("niu14"):GetComponent('AudioSource').clip

    --local chipRes = newobject(self.Musicprefeb.transform:Find("BGM"));
    local bgchip = self.Musicprefeb.transform:Find("BGM").transform:GetComponent('AudioSource');
    MusicManager:PlayBacksoundX(bgchip.clip, true);
    TBNNSCInfo.gamelogon();--初始化消息结构体
end

-- 创建场景
function TBNNPanel.CreatGamePanel(prefeb)
    local go = newobject(prefeb);
    go.transform:SetParent(self.transform);
end

-- 动态绑定玩家lua脚本
function TBNNPanel.AddPlayerLua()
    NiuNiuAllPlayerTable = {};
    NiuNiuUserInfoTable = {};

    for i = 1, 5 do
        local t = TBNNPlayer:New();
        local obj = self.AllPlayerFather.transform:GetChild(i - 1).gameObject;
        Util.AddComponent("LuaBehaviour", obj);-----玩家自己脚本
        local luaBehaviour = obj.transform:GetComponent("LuaBehaviour");
        luaBehaviour:SetLuaTab(t, "TBNNPlayer");
        table.insert(NiuNiuAllPlayerTable, t);
        table.insert(NiuNiuUserInfoTable, TBNNMH.Start_User_Data)
    end
    NiuNiu.transform:Find("Bg/AllPlayerInfo").gameObject:SetActive(true);
end

function TBNNPanel:FixedUpdate()

    if IsSetTimeNum then
        if timeNum >= 50 then
            timeNum = 0 timing = timing + 1;
            self.TimerMusic(timing)
        end
        timeNum = timeNum + 1;
    end
end

-- FindGameObject--玩家基本信息
function TBNNPanel.FindComponent()
    -- 玩家基础信息
    self.AllPlayerFather = NiuNiu.transform:Find("Bg/AllPlayerInfo").gameObject;
    self.AllPlayerFather:SetActive(false);
    self.AllPlayerFather.transform.localScale = Vector3.New(1, 1, 1)
    --下注数字
    self.ChipNum = NiuNiu.transform:Find("ChipNum").gameObject;
    self.ChipNum:SetActive(false);
    -- 牛牛点数
    self.NiuNum = NiuNiu.transform:Find("NiuNum").gameObject;
    self.NiuNum:SetActive(false);
    -- 牌
    self.NiuNiuPoker = NiuNiu.transform:Find("AllPoker").gameObject;
    self.NiuNiuPoker:SetActive(false);
    -- 分数
    self.WinLoseNum = NiuNiu.transform:Find("WinLoseNum").gameObject;
    self.WinLoseNum:SetActive(false);
    self.BtnArea = NiuNiu.transform:Find("Bg/BtnArea").gameObject;

    -- 筹码下注区域
    self.ChipArea = NiuNiu.transform:Find("Bg/ChipArea").gameObject;
    -- 隐藏的筹码保存区域
    self.delChipArea = newobject(self.ChipArea);
    self.delChipArea.transform:SetParent(NiuNiu.transform);

    -- 提示分牌
    self.HintBtn = NiuNiu.transform:Find("Bg/BtnArea/Btn/HintBtn").gameObject;
    -- 自己分牌
    self.SureBtn = NiuNiu.transform:Find("Bg/BtnArea/Btn/SureBtn").gameObject;
    -- 不叫庄
    self.NoCallBankerBtn = NiuNiu.transform:Find("Bg/BtnArea/Btn/NoCallBankerBtn").gameObject;
    -- 叫庄
    self.CallBankerBtn = NiuNiu.transform:Find("Bg/BtnArea/Btn/CallBankerBtn").gameObject;
    -- 准备
    self.ReadyBtn = NiuNiu.transform:Find("Bg/BtnArea/Btn/ReadyBtn").gameObject;
    -- 下注值father
    self.ChipsList = NiuNiu.transform:Find("Bg/BtnArea/ChipsList").gameObject;

    -- 玩家自己
    self.myselfpalyer = NiuNiu.transform:Find("Bg/AllPlayerInfo/Myself/ThinkingPoker").gameObject;

    -- 庄家图标
    self.BankerImg = NiuNiu.transform:Find("Bg/IsBanker").gameObject;

    -- 获取牌与筹码层数
    self.ChipAreaIndex = self.ChipArea.transform:GetSiblingIndex();
    self.AllPlayerFatherIndex = self.AllPlayerFather.transform:GetSiblingIndex();
    self.SureBtn.transform:GetComponent('Button').interactable = false;

    -- 默认位置虚拟框
    self.LeavePlayerImg = NiuNiu.transform:Find("Bg/NoPlayerInfo").gameObject;
    -- for i = 0, self.LeavePlayerImg.transform.childCount - 1 do
    --     self.LeavePlayerImg.transform:GetChild(i):GetChild(0).gameObject:SetActive(false);
    -- end
    self.LeavePlayerImg.transform.localScale = Vector3.New(1, 1, 1)

    -- 开始比牌
    self.PK_Poker = NiuNiu.transform:Find("PK_Poker").gameObject;
    self.PK_Poker:SetActive(false);
    self.PK_Poker.transform.localPosition = Vector3.New(-600, 0, 0)

    -- 玩家自己点击牌（牌桌上面显示）
    self.PokerNum = NiuNiu.transform:Find("Bg/Poket").gameObject;
    self.PokerNumBtn = self.PokerNum.transform:Find("Button").gameObject;
    self.PokerNumOne = self.PokerNum.transform:Find("one").gameObject;
    self.PokerNumTwo = self.PokerNum.transform:Find("two").gameObject;
    self.PokerNumThree = self.PokerNum.transform:Find("three").gameObject;
    self.PokerNumSum = self.PokerNum.transform:Find("sum").gameObject;
    self.PokerNum:SetActive(false);
    self.PokerNumTab = { self.PokerNumOne, self.PokerNumTwo, self.PokerNumThree };
    self.Menu=NiuNiu.transform:Find("Bg/Menu").gameObject;
    self.CloseCameBtn=self.Menu.transform:Find("CloseBtn"):GetComponent("Button");
    self.RuleBtn=self.Menu.transform:Find("RuleBtn"):GetComponent("Button");
    self.SetBtn=self.Menu.transform:Find("SetBtn"):GetComponent("Button");
    self.ExitPanel=NiuNiu.transform:Find("Bg/ExitPanel").gameObject;
    self.ExitPanel_SureBtn=self.ExitPanel.transform:Find("Btn_ExitGameComfirm"):GetComponent("Button")
    self.ExitPanel_CloseBtn=self.ExitPanel.transform:Find("Btn_ExitGameQuit"):GetComponent("Button")
    self.settingPanel=NiuNiu.transform:Find("Bg/SettingPanel").gameObject;
    self.musicSet = self.settingPanel.transform:Find("Content/Music"):GetComponent("Slider");
    self.soundSet = self.settingPanel.transform:Find("Content/Sound"):GetComponent("Slider");
    self.closeSet = self.settingPanel.transform:Find("Content/Close"):GetComponent("Button");

    self.ChipValueText=NiuNiu.transform:Find("Bg/ChipValue/Text"):GetComponent("Text")

    --if not AllSetGameInfo._5IsPlayAudio then
    --    self.musicSet.value = 0;
    --else
    --    if PlayerPrefs.HasKey("MusicValue") then
    --        local musicVole = PlayerPrefs.GetString("MusicValue");
    --        self.musicSet.value = tonumber(musicVole);
    --    else
    --        self.musicSet.value = 1;
    --    end
    --end
    --if PlayerPrefs.HasKey("SoundValue") then
    --    local soundVole = PlayerPrefs.GetString("SoundValue");
    --    if tonumber(soundVole) > 0 then
    --        AllSetGameInfo._6IsPlayEffect=true
    --    else
    --        AllSetGameInfo._6IsPlayEffect=false
    --    end
    --end
    --if not AllSetGameInfo._6IsPlayEffect then
    --    self.soundSet.value = 0;
    --else
    --    if PlayerPrefs.HasKey("SoundValue") then
    --        local soundVole = PlayerPrefs.GetString("SoundValue");
    --        self.soundSet.value = tonumber(soundVole);
    --    else
    --        self.soundSet.value = 1;
    --    end
    --end
    self.musicSet.value = MusicManager:GetMusicVolume();
    self.soundSet.value = MusicManager:GetSoundVolume();
    self:AddOnClick()-- 绑定按钮点击
    self.InitChipValue();
    -- 设置牛牛可以拖动选择
    -- self.InitPoker();
end

--绑定按钮点击
function TBNNPanel:AddOnClick()
    --准备
    local panleLuaBehaviour = self.transform:GetComponent('LuaBehaviour')
    panleLuaBehaviour:AddClick(self.ReadyBtn, self.IsReadyOnClick);
    --是否抢庄
    panleLuaBehaviour:AddClick(self.CallBankerBtn, self.IsCallBankerOnClick);
    panleLuaBehaviour:AddClick(self.NoCallBankerBtn, self.IsCallBankerOnClick);
    --自动 系统自动配置牌
    panleLuaBehaviour:AddClick(self.HintBtn, self.HintPokerOnClick);
    --自己手动配置牌
    panleLuaBehaviour:AddClick(self.SureBtn, self.PlayerPokerOnClick);
    panleLuaBehaviour:AddClick(self.PokerNumBtn, self.HintPokerOnClick);----*****
    --  panleLuaBehaviour:AddClick(self.ResultInfo, self.ResultInfo_CloseBtnOnClick);
    --下注
    for i = 1, self.ChipsList.transform.childCount do
        panleLuaBehaviour:AddClick(self.ChipsList.transform:GetChild(i - 1).gameObject, self.ChipValueOnClick);
    end
    --牌的提起与放下
    for i = 0, 4 do
        panleLuaBehaviour:AddClick(self.myselfpalyer.transform:GetChild(i).gameObject, self.ChoosePokerOnClick);
    end
    --用户信息面板
    for i = 0, self.AllPlayerFather.transform.childCount - 1 do
        panleLuaBehaviour:AddClick(self.AllPlayerFather.transform:GetChild(i):Find("Info").gameObject, self.OpenInfo);
    end

    self.CloseCameBtn.onClick:RemoveAllListeners();
    self.CloseCameBtn.onClick:AddListener(function ()
        self.ExitPanel.gameObject:SetActive(true)
    end);

    self.RuleBtn.onClick:RemoveAllListeners();
    self.RuleBtn.onClick:AddListener(function ()
        TBNNPanel.CreatHelp(Module55Panel.Pool("Help_NiuNiu"));
    end);

    self.SetBtn.onClick:RemoveAllListeners();
    self.SetBtn.onClick:AddListener(function ()
        self.settingPanel.gameObject:SetActive(true)
    end);

    self.musicSet.onValueChanged:RemoveAllListeners();
    self.musicSet.onValueChanged:AddListener(self.SetMusicVolumn);

    self.soundSet.onValueChanged:RemoveAllListeners();
    self.soundSet.onValueChanged:AddListener(self.SetSoundVolumn);
    self.closeSet.onClick:RemoveAllListeners();
    self.closeSet.onClick:AddListener(function()
        self.settingPanel.gameObject:SetActive(false);
    end);

    self.ExitPanel_SureBtn.onClick:RemoveAllListeners();
    self.ExitPanel_SureBtn.onClick:AddListener(self.CloseGameCall);

    self.ExitPanel_CloseBtn.onClick:RemoveAllListeners();
    self.ExitPanel_CloseBtn.onClick:AddListener(function()
        self.ExitPanel.gameObject:SetActive(false)
    end);
end

-- 隐藏结算信息
function TBNNPanel.ResultInfo_CloseBtnOnClick()
    --self.ResultInfo.transform.localPosition = Vector3.New(0, 1000, 0)
    --self.ResultInfo:SetActive(false);
end

-- 初始化界面之前隐藏所有信息
function TBNNPanel.SetActive()
    -- 隐藏所有玩家基础信息
    for i = 1, self.AllPlayerFather.transform.childCount - 1 do
        self.AllPlayerFather.transform:GetChild(i).gameObject:SetActive(false);
    end
end

-- 初始化下注界面
function TBNNPanel.InitChipValue()
    if NiuNiuChipValue[1] >= 15 and NiuNiuChipValue[1] <30 then
        self.ChipsList.transform:GetChild(0):GetComponent("Button").interactable=true
        self.ChipsList.transform:GetChild(1):GetComponent("Button").interactable=true
        self.ChipsList.transform:GetChild(2):GetComponent("Button").interactable=true
        self.ChipsList.transform:GetChild(3):GetComponent("Button").interactable=true
        self.ChipsList.transform:GetChild(4):GetComponent("Button").interactable=false
    elseif NiuNiuChipValue[1] >= 10 and NiuNiuChipValue[1] < 15 then
        self.ChipsList.transform:GetChild(0):GetComponent("Button").interactable=true
        self.ChipsList.transform:GetChild(1):GetComponent("Button").interactable=true
        self.ChipsList.transform:GetChild(2):GetComponent("Button").interactable=true
        self.ChipsList.transform:GetChild(3):GetComponent("Button").interactable=false
        self.ChipsList.transform:GetChild(4):GetComponent("Button").interactable=false
    elseif NiuNiuChipValue[1] >= 5 and NiuNiuChipValue[1] < 10 then
        self.ChipsList.transform:GetChild(0):GetComponent("Button").interactable=true
        self.ChipsList.transform:GetChild(1):GetComponent("Button").interactable=true
        self.ChipsList.transform:GetChild(2):GetComponent("Button").interactable=false
        self.ChipsList.transform:GetChild(3):GetComponent("Button").interactable=false
        self.ChipsList.transform:GetChild(4):GetComponent("Button").interactable=false
    elseif NiuNiuChipValue[1] >= 2 and NiuNiuChipValue[1] < 5 then
        self.ChipsList.transform:GetChild(0):GetComponent("Button").interactable=true
        self.ChipsList.transform:GetChild(1):GetComponent("Button").interactable=false
        self.ChipsList.transform:GetChild(2):GetComponent("Button").interactable=false
        self.ChipsList.transform:GetChild(3):GetComponent("Button").interactable=false
        self.ChipsList.transform:GetChild(4):GetComponent("Button").interactable=false
    elseif NiuNiuChipValue[1] >= 30 then
        self.ChipsList.transform:GetChild(0):GetComponent("Button").interactable=true
        self.ChipsList.transform:GetChild(1):GetComponent("Button").interactable=true
        self.ChipsList.transform:GetChild(2):GetComponent("Button").interactable=true
        self.ChipsList.transform:GetChild(3):GetComponent("Button").interactable=true
        self.ChipsList.transform:GetChild(4):GetComponent("Button").interactable=true
    else
        self.ChipsList.transform:GetChild(0):GetComponent("Button").interactable=false
        self.ChipsList.transform:GetChild(1):GetComponent("Button").interactable=false
        self.ChipsList.transform:GetChild(2):GetComponent("Button").interactable=false
        self.ChipsList.transform:GetChild(3):GetComponent("Button").interactable=false
        self.ChipsList.transform:GetChild(4):GetComponent("Button").interactable=false
    end
end

-- 初始化场景
function TBNNPanel.InitScen(data)--table
    --error("初始化场景"..GameNextScenName.."-------"..gameScenName.Game03)
    if (not Util.isPc) then
        GameSetsBtnInfo.SetPlaySuonaPos(0, 355, 0);
    end
    IsBankerTime = true;
    for i = 1, #NiuNiuAllPlayerTable do
        NiuNiuAllPlayerTable[i].StartAni = false;
        NiuNiuAllPlayerTable[i]:IsShowTimer(false, 0, 0);
    end
    -- 初始化界面
    self.ChipValueText.text="mixbet:"..tostring(TBNNMH.lowChip)

    local passtime = data[2];
    -- 庄家座位号
    TBNNMH.Banker_ChairID = data[3];
    -- 玩家数据
    TBNNMH.Playing_State = TBNNMH.Game_State;

    if TBNNMH.Game_State==TBNNMH.D_GAME_STATE_NULL or TBNNMH.Game_State==TBNNMH.D_GAME_STATE_ROB_BANKER then
        self.waitPanel.gameObject:SetActive(false)
    else
        self.waitPanel.transform:Find("Text"):GetComponent("Text").text="The match is not finished"
        self.waitPanel.gameObject:SetActive(true)
    end

    for i = 1, TBNNMH.GAME_PLAYER do
        local everyplayer = {};
        everyplayer = data[3 + i];

        if TBNNMH.Game_State == TBNNMH.D_GAME_STATE_NULL then
            --error("空状态==================")
            NiuNiu_IsGameStartIn = false;
        elseif TBNNMH.Game_State == TBNNMH.D_GAME_STATE_ROB_BANKER then
            -- 抢庄（所有人开始枪庄）
            --error("抢庄（所有人开始枪庄）==================")
            self.BankerImg.transform:SetParent(self.transform:Find("Bg"));
            self.BankerImg.transform.localPosition = Vector3.New(0, 0, 0);
            for i = 1, #NiuNiuAllPlayerTable do
                NiuNiuAllPlayerTable[i].IsPlayingGame = 1;--是否在游戏中
                NiuNiuAllPlayerTable[i]:IsShowTimer(true, TBNNMH.D_TIMER_ROB_BANKER, 0);--抢庄倒计时
            end
        elseif TBNNMH.Game_State == TBNNMH.D_GAME_STATE_CHIP then
            -- 下注
            if TBNNMH.MySelf_ChairID == everyplayer[1] then
                --原始为4  4为抢庄  改为5
                NiuNiuChipValue[1] = everyplayer[5];----?????? 五
                for i = 1, #NiuNiuChipValue do
                    NiuNiuChipValue[i] = NiuNiuChipValue[1] * i;
                end
                self.InitChipValue();
            end
        elseif TBNNMH.Game_State == TBNNMH.D_GAME_STATE_SEND_POKER then
            -- 发牌
        elseif TBNNMH.Game_State == TBNNMH.D_GAME_STATE_OPEN_POKER then
            -- 开牌
        elseif TBNNMH.Game_State == TBNNMH.D_GAME_STATE_GAME_RESULT then
            -- 游戏结算
        elseif TBNNMH.Game_State == TBNNMH.D_GAME_STATE_GAME_END then
        end

        if everyplayer[1] < TBNNMH.GAME_PLAYER then
            local posnum = (everyplayer[1] - TBNNMH.MySelf_ChairID);
            if posnum < 0 then posnum = posnum + TBNNMH.GAME_PLAYER end
            if i > 1 and everyplayer[1] == 0 then
                everyplayer[1] = -i;
                posnum = (i - 1 - TBNNMH.MySelf_ChairID);
            end
            posnum = posnum + 1;
            NiuNiuAllPlayerTable[posnum]:SetInitValue(everyplayer, passtime)
        end
    end
end

-- 游戏消息
function TBNNPanel.GameInfo(id, buffer)
    TBNNMH.IsOver=true;
    --0
    if id == TBNNMH.SUB_SC_ROB_BANKER then
        error("=============抢庄================");
        self.PK_Poker:SetActive(false);
        self.waitPanel.gameObject:SetActive(false)
        self.PK_Poker.transform.localPosition = Vector3.New(-600, 0, 0)
        TBNNMH.Playing_Time = 0;
        TBNNMH.Playing_State = id;
        TBNNMH.IsBankerLeave = false;
        self.ClearChip();
        IsBankerTime = true;
        self.BankerImg.transform:SetParent(self.transform:Find("Bg"));
        self.BankerImg.transform.localPosition = Vector3.New(0, 0, 0);
        IsSetTimeNum = false;
        for i = 1, #NiuNiuAllPlayerTable do
            NiuNiuAllPlayerTable[i].IsPlayingGame = 1;
            NiuNiuAllPlayerTable[i]:IsShowTimer(true, TBNNMH.D_TIMER_ROB_BANKER, 0);
            NiuNiuAllPlayerTable[i]:SetIsStartBank();
        end
        TBNNMH.Game_State = 1;
        self.SetShowBtn();
        --玩家抢庄--1
    elseif id == TBNNMH.SUB_SC_PLAYER_ROB_BANKER then
        TBNNMH.Playing_State = id;
        --error("=============玩家抢庄================");
        local data = GetS2CInfo(TBNNMH.CMD_SC_PLAYER_ROB_BANKER, buffer);
        local posnum = self.retnum(data[1], TBNNMH.MySelf_ChairID)
        if data[2] == 1 then
            TBNNMH.Banker_ChairID = data[1];
            NiuNiuAllPlayerTable[posnum]:SetBankerText(true);
        else
            NiuNiuAllPlayerTable[posnum]:SetBankerText(false);
        end
        NiuNiuAllPlayerTable[posnum]:IsShowTimer(false, 0, 0);
        --下注--2
    elseif id == TBNNMH.SUB_SC_CHIP then
        error("=============开始下注================");
        TBNNMH.IsOver=false;
        TBNNMH.Playing_Time = 0;
        TBNNMH.Playing_State = id;
        IsBankerTime = false;

        for i = 1, #NiuNiuAllPlayerTable do
            NiuNiuAllPlayerTable[i].IsPlayingGame = 1;
        end
        local data = GetS2CInfo(TBNNMH.CMD_SC_CHIP, buffer);
        local posnum = self.retnum(data[1], TBNNMH.MySelf_ChairID)
        TBNNMH.Banker_ChairID = data[1];
        --飞庄家图标动画
        local bankernum = (TBNNMH.Banker_ChairID - TBNNMH.MySelf_ChairID);
        if bankernum < 0 then bankernum = bankernum + TBNNMH.GAME_PLAYER end

        logTable(data)
        if isAutoChip then
            isAutoChip=false
            fun = coroutine.start(self.ChipTime)
        end

        error("初始化下注值==" .. data[2])
        NiuNiuChipValue[1] = data[2];
        self.InitChipValue();

        TBNNMH.Game_State = 2;
        self.SetShowBtn();

        for i = 1, #NiuNiuAllPlayerTable do
            NiuNiuAllPlayerTable[i]:StartChip();
        end
        --self.BankerAnimator(bankernum)

        --玩家下注
    elseif id == TBNNMH.SUB_SC_PLAYER_CHIP then
        error("=============玩家下注================");
        TBNNMH.IsOver=false;
        TBNNMH.Playing_State = id;
        local data = GetS2CInfo(TBNNMH.CMD_SC_PLAYER_CHIP, buffer);
        local posnum = self.retnum(data[1], TBNNMH.MySelf_ChairID)
        logTable(data)
        NiuNiuAllPlayerTable[posnum]:PlayingChipAnimator(data[2]);
    
        local num =NiuNiuAllPlayerTable[posnum].palyerinfo._7wGold-data[2]*TBNNMH.lowChip
        logYellow("num======="..num)
        NiuNiuAllPlayerTable[posnum]:PlayerScore(data[1],num) 

        if TBNNMH.MySelf_ChairID == data[1] then
            for i = 1, #NiuNiuAllPlayerTable do
                coroutine.start(NiuNiuAllPlayerTable[i].PlaySendPoker, NiuNiuAllPlayerTable[i]);
            end
        end
        --发牌
    elseif id == TBNNMH.SUB_SC_SEND_POKER then
        error("=============发牌================");
        if isClearnGame then
            isClearnGame=false
            TBNNPanel.ClearChip() 
        end
        self.waitPanel.gameObject:SetActive(false)
        
        TBNNMH.Playing_Time = 0;
        self.ChipArea.transform:SetSiblingIndex(self.AllPlayerFatherIndex - 1);
        TBNNMH.Playing_State = id;
        PlayerChoosePoker = {};
        ChoosePokerNum = 0;
        TBNNMH.Game_State = 65535;
        self.SetShowBtn();
        local myselfpoker = {};
        for i = 1, TBNNMH.D_PLAYER_POKER_COUNT do
            table.insert(myselfpoker, #myselfpoker + 1, buffer:ReadByte());
        end
        
        logTable(myselfpoker)

        if myselfpoker[1] ~= 0 then
            MyselfPokerTab = myselfpoker;
            for i = 1, self.myselfpalyer.transform.childCount do
                --error("=============发牌================");
                local pokernum = (string.split(Util.OutPutPokerValue(myselfpoker[i]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(myselfpoker[i]), ",")[2]);
                self.myselfpalyer.transform:GetChild(i - 1):GetComponent('Image').sprite = TBNNPanel.NiuNiuPoker.transform:GetChild(pokernum - 1):GetComponent('Image').sprite
                self.myselfpalyer.transform:GetChild(i - 1).gameObject.name = myselfpoker[i];
            end
        end
        for i = 1, #NiuNiuAllPlayerTable do
            coroutine.start(NiuNiuAllPlayerTable[i].SendPoker, NiuNiuAllPlayerTable[i]);
        end
        --开牌
    elseif id == TBNNMH.SUB_SC_OPEN_POKER then
        error("=============开牌================");
        if NiuNiuAllPlayerTable[1].IsPlayingGame == 1 then self.PokerNum:SetActive(true); end 

        for i = 1, #self.PokerNumTab do
            self.PokerNumTab[i].transform:GetComponent('Text').text = " ";
        end
        
        self.PokerNumSum:GetComponent('Text').text = " ";
        TBNNMH.Playing_State = id;
        IsMyselfOpen = false;
        if TBNNMH.Game_State == 3 then return end
        --如果有牌再显示
        if self.myselfpalyer.activeSelf then
            TBNNMH.Game_State = 3;
            self.SetShowBtn();
        else
            self.PokerNum:SetActive(false)
        end
        for i = 1, #NiuNiuAllPlayerTable do
            local posnum = self.retnum(i, TBNNMH.MySelf_ChairID)
            NiuNiuAllPlayerTable[posnum]:StartOpenPoker();
        end
        --玩家开牌
    elseif id == TBNNMH.SUB_SC_PLAYER_OPEN_POKER then
        error("=============玩家开牌================");
        TBNNMH.Playing_State = id;
        local playerchairid = buffer:ReadUInt16();
        local byniuniunum = buffer:ReadByte();
        local pokertab = {};
        for i = 1, TBNNMH.D_PLAYER_POKER_COUNT do
            table.insert(pokertab, #pokertab + 1, buffer:ReadByte());
        end
        local posnum = self.retnum(playerchairid, TBNNMH.MySelf_ChairID)

        NiuNiuAllPlayerTable[posnum].playerPoker = pokertab;
        NiuNiuAllPlayerTable[posnum].byNiuNiuPoint = byniuniunum;
        NiuNiuAllPlayerTable[posnum].Poker_Over:SetActive(true);

        if posnum == 1 then
            NiuNiuAllPlayerTable[posnum]:IsShowTimer(false, 0, 0)
            for i = 1, self.myselfpalyer.transform.childCount do
                self.myselfpalyer.transform:GetChild(i - 1):GetComponent('Image').sprite = self.NiuNiuPoker.transform:Find("Back"):GetComponent('Image').sprite
                self.myselfpalyer.transform:GetChild(i - 1).localPosition = Vector3.New(-110 + 95 * (i - 1), 0, 0)
            end
        end
        if TBNNMH.MySelf_ChairID == playerchairid then
            TBNNMH.Game_State = 65535;
            self.SetShowBtn();
            IsMyselfOpen = true;
        end
        --游戏结算
    elseif tonumber(id) == TBNNMH.SUB_SC_GAME_RESULT then
        error("============游戏结算===============")
        TBNNMH.Playing_State = id;
        TBNNMH.Game_State = 65535;
        self.SetShowBtn();
        ClickPoketNum = { 0, 0, 0 };
        local num = 0;
        for i = 1, self.AllPlayerFather.transform.childCount - 1 do
            if self.AllPlayerFather.transform:GetChild(i).gameObject.activeSelf then
                num = num + 1;
            end
        end
        IsMyselfOpen = true;--自己是否开牌
        NiuNiu_IsPlayingGame = false;
        IsBankerTime = false;
        TBNNMH.Game_State = 5;
        self.SetShowBtn();
        local winnum = 0;
        local wintable = {};
        local a = 0;
        for i = 1, TBNNMH.GAME_PLAYER do
            local value = tonumber(buffer:ReadInt64Str());
            table.insert(wintable, #wintable + 1, value)
            if NiuNiuUserInfoTable[i]._1dwUser_Id > 0 then
                if wintable[i] > 0 then
                    winnum = winnum + 1
                end;
            end
        end
        ---- 考虑庄家逃跑（删除桌面信息直接跳到加的金币数动画）
        if TBNNMH.IsBankerLeave == true then
            --error("============考虑庄家逃跑===============")
            self.ClearChip()
            for i = 1, #NiuNiuAllPlayerTable do
                local playerchairid = i - 1;
                local posnum = self.retnum(playerchairid, TBNNMH.MySelf_ChairID)
                if NiuNiuUserInfoTable[i]._1dwUser_Id > 0 then
                    NiuNiuAllPlayerTable[posnum]:BankerLeaveGameOverAnimator(wintable[i]);
                end
            end
            TBNNMH.IsBankerLeave = false;
            return;
        end
        -- if  所有玩家的牌没有显示则视为逃跑
        if TBNNMH.Playing_State <= TBNNMH.SUB_SC_SEND_POKER then
            --error("在发牌之前，游戏已经结束")
            self.ClearChip();
            return;
        end
        
        
        if  isPlayPKPoker  then
            logTable(wintable)
            isPlayPKPoker=false
            self.GameOverPlayAnimator(wintable, winnum);   
        end
        
        self.PokerNum:SetActive(false);
        
        local posnum1 =(TBNNMH.Banker_ChairID-TBNNMH.MySelf_ChairID);
        if posnum1 <0 then 
            posnum1 = posnum1 + TBNNMH.GAME_PLAYER 
        end
        posnum1=posnum1+1;
        NiuNiuAllPlayerTable[posnum1]:SetBankGold(TBNNMH.Banker_ChairID);--4
        --游戏结束
    elseif id == TBNNMH.SUB_SC_GAME_END then
        -- TBNNMH.Playing_State = id;
        self.PokerNum:SetActive(false);
        NiuNiu_IsGameStartIn = false;
        isPlayPKPoker=true
        isClearnGame=true
        isAutoChip=true
        fun=nil
        error("=============游戏结束================");
        self.waitPanel.transform:Find("Text"):GetComponent("Text").text="game start soon"
        self.waitPanel.gameObject:SetActive(true)
    end
end

function TBNNPanel.ChipTime()
    local index =0
    while index < 9 do
        index=index+1
        logYellow("自动下注计时=="..index)
        coroutine.wait(1)
    end
    
    local args={name="5"}
    TBNNPanel.ChipValueOnClick(args)
end

function TBNNPanel.CleranGame()
    self.PK_Poker:SetActive(false);
    self.waitPanel.gameObject:SetActive(false)
    self.PK_Poker.transform.localPosition = Vector3.New(-600, 0, 0)
    TBNNMH.Playing_Time = 0;
    TBNNMH.Playing_State = id;
    TBNNMH.IsBankerLeave = false;
    self.ClearChip();
    IsBankerTime = true;
    self.BankerImg.transform:SetParent(self.transform:Find("Bg"));
    self.BankerImg.transform.localPosition = Vector3.New(0, 0, 0);
    IsSetTimeNum = false;
end

-- 时间倒计时
function TBNNPanel.TimerMusic(nowendTime)
    timing = nowendTime;
    if nowendTime ~= 20 then TBNNMH.Playing_Time = timing; end
    if TBNNMH.MySelf_ChairID < 0 or TBNNMH.MySelf_ChairID > TBNNMH.GAME_PLAYER then return end
    local havetime = (TimeAllNum - nowendTime)
    if nowendTime == 0 then
        -- local chip = self.Musicprefeb.transform:Find("Timer_Begin"):GetComponent('AudioSource').clip
        -- MusicManager:PlayX(chip);
        return
    end
    if havetime < 0 then
        IsSetTimeNum = false; return
    end
    if havetime < 5 then
        local musicchip = self.Musicprefeb.transform:Find("Timer_Warning"):GetComponent('AudioSource').clip
        MusicManager:PlayX(musicchip);
    end
end
-- 主面板控制结算动画
function TBNNPanel.GameOverPlayAnimator(winlosetab, winnum)
    -- 庄家牌飞到中心点
    logYellow("庄家牌飞到中心点")
    self.ChipArea.transform:SetSiblingIndex(self.AllPlayerFatherIndex - 1);
    local posnum = self.retnum(TBNNMH.Banker_ChairID, TBNNMH.MySelf_ChairID)
    NiuNiuAllPlayerTable[posnum]:PkPoker(winlosetab)
    coroutine.start(self.FreeGold, winlosetab, winnum)
    --    local num = 0;
    --    if num > 1 then self.PK_Poker:SetActive(true); self.PK_Poker.transform:DOLocalMoveX(0,0.5,false) end
end

self.IsPlayNiuNiuPoint=false

function TBNNPanel.FreeGold(winlosetab, winnum)
    if not (self.myselfpalyer.activeSelf) then
        return;
    end
    -- 播放比牌效果
    for i = 1, self.AllPlayerFather.transform.childCount do
        if self.AllPlayerFather.transform:GetChild(i - 1).gameObject.activeSelf then
            NiuNiuAllPlayerTable[i]:OutPoker(NiuNiuAllPlayerTable[i].byNiuNiuPoint, NiuNiuAllPlayerTable[i].playerPoker);
            coroutine.wait(0.7);
        end
    end

    if TBNNMH.Game_State ~= 5 then return end;
    coroutine.wait(0.3);
    for i = 1, #winlosetab do
        local playerchairid = i - 1;
        local posnum = self.retnum(playerchairid, TBNNMH.MySelf_ChairID)
        if NiuNiuUserInfoTable[i]._1dwUser_Id > 0 then
            NiuNiuAllPlayerTable[posnum]:PlayingGameOverAnimator(winlosetab[i]);
        end
    end
    
    coroutine.wait(0.7);
    if TBNNMH.Game_State ~= 5 then return end;
    local posnum = self.retnum(TBNNMH.Banker_ChairID, TBNNMH.MySelf_ChairID)
    NiuNiuAllPlayerTable[posnum]:SetFirstPos()
    if TBNNMH.Game_State ~= 5 then return end;
    NiuNiu_IsPlayingGame = false;
    coroutine.wait(1.5);
    TBNNPanel.CleranGame()
    -- MusicManager:PlayX(self.HandMusic);
end

-- 游戏结束清除桌面上的筹码
function TBNNPanel.ClearChip()
    self.ReSetBankerPos()
    self.PK_Poker:SetActive(false);
    self.PK_Poker.transform.localPosition = Vector3.New(-600, 0, 0)

    -- for i = 0, self.LeavePlayerImg.transform.childCount - 1 do
    --     self.LeavePlayerImg.transform:GetChild(i):GetChild(0).gameObject:SetActive(false);
    -- end

    for i = 1, #NiuNiuAllPlayerTable do
        NiuNiuAllPlayerTable[i]:GameOver();
    end
    self.ChipArea.transform:SetSiblingIndex(self.AllPlayerFatherIndex - 1);
    if self.ChipArea.transform.childCount == 0 then return; end
    for i = 1, #(TBNNMH.NiuNiuChipObj) do
        local num = self.ChipArea.transform.childCount;
        if TBNNMH.NiuNiuChipObj[i] ~= nil then
            self.NotNiuNiuChip(TBNNMH.NiuNiuChipObj[i]);
        end
    end
    TBNNMH.NiuNiuChipObj = {};
end

-- 不删除筹码，保存下次利用
function TBNNPanel.NotNiuNiuChip(obj)
    if obj.name == "bai" then
        table.insert(delchiptable[5], #delchiptable[5] + 1, obj)
    elseif obj.name == "qian" then
        table.insert(delchiptable[4], #delchiptable[4] + 1, obj)
    elseif obj.name == "wan" then
        table.insert(delchiptable[3], #delchiptable[3] + 1, obj)
    elseif obj.name == "shiwan" then
        table.insert(delchiptable[2], #delchiptable[2] + 1, obj)
    elseif obj.name == "baiwan" then
        table.insert(delchiptable[1], #delchiptable[1] + 1, obj)
    else
        destroy(obj);
    end
    obj:SetActive(false)
    obj.transform:SetParent(self.delChipArea.transform);

end

-- 设置显示的按钮
function TBNNPanel.SetShowBtn()
    if NiuNiuAllPlayerTable[1].IsPlayingGame == 1 or TBNNMH.Game_State == 1 then
        if TBNNMH.Game_State == 0 then
            -- 准备/游戏结束
            NiuNiu_IsPlayingGame = false;
            IsSetTimeNum = true;
            timeNum = 0;
            TimeAllNum = 0;--TBNNMH.D_TIMER_READY / 1000;
            timing = 0;
            self.TimerMusic(0)
            self.ReadyBtn.transform.localPosition = Vector3.New(self.ReadyBtn.transform.localPosition.x, 10000, 0);
            self.CallBankerBtn.transform.localPosition = Vector3.New(self.CallBankerBtn.transform.localPosition.x, 10000, 0);
            self.NoCallBankerBtn.transform.localPosition = Vector3.New(self.NoCallBankerBtn.transform.localPosition.x, 10000, 0);
            self.SureBtn.transform.localPosition = Vector3.New(self.SureBtn.transform.localPosition.x, 10000, 0);
            self.HintBtn.transform.localPosition = Vector3.New(self.HintBtn.transform.localPosition.x, 10000, 0);
            self.ChipsList.transform.localPosition = Vector3.New(self.ChipsList.transform.localPosition.x, 10000, 0);
        elseif TBNNMH.Game_State == 1 then
            -- 叫庄
            IsSetTimeNum = true;
            timeNum = 0;
            TimeAllNum = TBNNMH.D_TIMER_ROB_BANKER / 1000;
            timing = 0;
            self.TimerMusic(0)
            self.ReadyBtn.transform.localPosition = Vector3.New(self.ReadyBtn.transform.localPosition.x, 10000, 0);
            self.CallBankerBtn.transform.localPosition = Vector3.New(self.CallBankerBtn.transform.localPosition.x, 15, 0);
            self.NoCallBankerBtn.transform.localPosition = Vector3.New(self.NoCallBankerBtn.transform.localPosition.x, 15, 0);
            self.SureBtn.transform.localPosition = Vector3.New(self.SureBtn.transform.localPosition.x, 10000, 0);
            self.HintBtn.transform.localPosition = Vector3.New(self.HintBtn.transform.localPosition.x, 10000, 0);
            self.ChipsList.transform.localPosition = Vector3.New(self.ChipsList.transform.localPosition.x, 10000, 0);
        elseif TBNNMH.Game_State == 2 then
            -- 下注
            IsSetTimeNum = true;
            timeNum = 0;
            TimeAllNum = TBNNMH.D_TIMER_CHIP / 1000;
            timing = 0;
            self.TimerMusic(0)
            self.ReadyBtn.transform.localPosition = Vector3.New(self.ReadyBtn.transform.localPosition.x, 10000, 0);
            self.CallBankerBtn.transform.localPosition = Vector3.New(self.CallBankerBtn.transform.localPosition.x, 10000, 0);
            self.NoCallBankerBtn.transform.localPosition = Vector3.New(self.NoCallBankerBtn.transform.localPosition.x, 10000, 0);
            self.SureBtn.transform.localPosition = Vector3.New(self.SureBtn.transform.localPosition.x, 10000, 0);
            self.HintBtn.transform.localPosition = Vector3.New(self.HintBtn.transform.localPosition.x, 10000, 0);

            --if TBNNMH.Banker_ChairID == TBNNMH.MySelf_ChairID then return end--如果自己是庄家--不显示下注按钮

            self.ChipsList.transform.localPosition = Vector3.New(self.ChipsList.transform.localPosition.x, 180, 0);
        elseif TBNNMH.Game_State == 3 then
            -- 发牌
            IsSetTimeNum = true;
            timeNum = 0;
            TimeAllNum = TBNNMH.D_TIMER_OPEN_POKER / 1000;
            timing = 0;
            self.TimerMusic(0)
            self.SureBtn.transform:GetComponent('Button').interactable = false;
            self.ReadyBtn.transform.localPosition = Vector3.New(self.ReadyBtn.transform.localPosition.x, 10000, 0);
            self.CallBankerBtn.transform.localPosition = Vector3.New(self.CallBankerBtn.transform.localPosition.x, 10000, 0);
            self.NoCallBankerBtn.transform.localPosition = Vector3.New(self.NoCallBankerBtn.transform.localPosition.x, 10000, 0);
            self.SureBtn.transform.localPosition = Vector3.New(self.SureBtn.transform.localPosition.x, 15, 0);
            self.HintBtn.transform.localPosition = Vector3.New(self.HintBtn.transform.localPosition.x, 100, 0);
            self.ChipsList.transform.localPosition = Vector3.New(self.ChipsList.transform.localPosition.x, 10000, 0);
        elseif TBNNMH.Game_State == 4 then
            -- 开牌
            self.SureBtn.transform:GetComponent('Button').interactable = false;
            self.ReadyBtn.transform.localPosition = Vector3.New(self.ReadyBtn.transform.localPosition.x, 10000, 0);
            self.CallBankerBtn.transform.localPosition = Vector3.New(self.CallBankerBtn.transform.localPosition.x, 10000, 0);
            self.NoCallBankerBtn.transform.localPosition = Vector3.New(self.NoCallBankerBtn.transform.localPosition.x, 10000, 0);
            self.SureBtn.transform.localPosition = Vector3.New(self.SureBtn.transform.localPosition.x, 10000, 0);
            self.HintBtn.transform.localPosition = Vector3.New(self.HintBtn.transform.localPosition.x, 10000, 0);
            self.ChipsList.transform.localPosition = Vector3.New(self.ChipsList.transform.localPosition.x, 10000, 0);
        elseif TBNNMH.Game_State == 5 then
            -- 游戏结算
            self.SureBtn.transform:GetComponent('Button').interactable = false;
            self.ReadyBtn.transform.localPosition = Vector3.New(self.ReadyBtn.transform.localPosition.x, 10000, 0);
            self.CallBankerBtn.transform.localPosition = Vector3.New(self.CallBankerBtn.transform.localPosition.x, 10000, 0);
            self.NoCallBankerBtn.transform.localPosition = Vector3.New(self.NoCallBankerBtn.transform.localPosition.x, 10000, 0);
            self.SureBtn.transform.localPosition = Vector3.New(self.SureBtn.transform.localPosition.x, 10000, 0);
            self.HintBtn.transform.localPosition = Vector3.New(self.HintBtn.transform.localPosition.x, 10000, 0);
            self.ChipsList.transform.localPosition = Vector3.New(self.ChipsList.transform.localPosition.x, 10000, 0);
        elseif TBNNMH.Game_State == 65535 then
            NiuNiuAllPlayerTable[1]:IsShowTimer(false, 0, 0);
            IsSetTimeNum = false;
            timeNum = 0;
            TimeAllNum = 0;
            timing = 0;
            self.TimerMusic(20)
            self.ReadyBtn.transform.localPosition = Vector3.New(self.ReadyBtn.transform.localPosition.x, 10000, 0);
            self.CallBankerBtn.transform.localPosition = Vector3.New(self.CallBankerBtn.transform.localPosition.x, 10000, 0);
            self.NoCallBankerBtn.transform.localPosition = Vector3.New(self.NoCallBankerBtn.transform.localPosition.x, 10000, 0);
            self.SureBtn.transform.localPosition = Vector3.New(self.SureBtn.transform.localPosition.x, 10000, 0);
            self.HintBtn.transform.localPosition = Vector3.New(self.HintBtn.transform.localPosition.x, 10000, 0);
            self.ChipsList.transform.localPosition = Vector3.New(self.ChipsList.transform.localPosition.x, 10000, 0);
        elseif TBNNMH.Game_State == 65534 then
            self.ReadyBtn.transform.localPosition = Vector3.New(self.ReadyBtn.transform.localPosition.x, 10000, 0);
            self.CallBankerBtn.transform.localPosition = Vector3.New(self.CallBankerBtn.transform.localPosition.x, 10000, 0);
            self.NoCallBankerBtn.transform.localPosition = Vector3.New(self.NoCallBankerBtn.transform.localPosition.x, 10000, 0);
            self.SureBtn.transform.localPosition = Vector3.New(self.SureBtn.transform.localPosition.x, 10000, 0);
            self.HintBtn.transform.localPosition = Vector3.New(self.HintBtn.transform.localPosition.x, 10000, 0);
            self.ChipsList.transform.localPosition = Vector3.New(self.ChipsList.transform.localPosition.x, 10000, 0);
        end
    end
end
-- 庄家确定动画
function TBNNPanel.BankerAnimator(chair)
    -- local jishu = 0;
    -- local scalenum = 0.5
    -- local fatherobj = self.AllPlayerFather.transform:GetChild(chair).gameObject
    -- if chair == 0 then fatherobj = fatherobj.transform:Find("Info" .. TBNNMH.MySelf_ChairID).gameObject; jishu = 10; scalenum = 0.5 end;
    -- local pos = fatherobj.transform.position;
    -- local vet2 = fatherobj.transform:GetComponent('RectTransform').sizeDelta
    -- local isTop = -60;
    -- local Isleft = 1;
    -- local movepos;

    -- if chair == 0 then
    --     movepos= Vector3.New(-50,60,0)
    -- elseif chair == 1 then
    --     movepos= Vector3.New(90,70,0)
    -- elseif chair == 2 then
    --     movepos= Vector3.New(40,60,0)
    -- elseif chair == 3 then
    --     movepos= Vector3.New(-40,60,0)
    -- elseif chair == 4 then
    --     movepos= Vector3.New(-90,60,0)
    -- end
    
    -- self.BankerImg.transform:SetParent(fatherobj.transform);
    -- local dotween = self.BankerImg.transform:DOLocalMove(movepos, 0.5, false)

end

-- 设置数字转化成Img显示
function TBNNPanel.NumChangeValue(prefeb, num)
    if prefeb.transform.childCount < string.len(num) then
        for i = prefeb.transform.childCount, string.len(num) do
            local go = newobject(prefeb.transform:GetChild(0).gameObject);
            go.transform:SetParent(prefeb.transform);
            go.transform.localScale = Vector3.one;
            go.transform.localPosition = Vector3.New(klx, 0, 0);
            go.name = prefebnum;
        end
    elseif prefeb.transform.childCount > string.len(num) then
        for i = string.len(num), prefeb.transform.childCount - 1 do
            if not (IsNil(prefeb.transform:GetChild(i).gameObject)) then
                destroy(prefeb.transform:GetChild(i).gameObject);
            end
        end
    end
    for j = 1, string.len(num) do
        local chiponevalue = tonumber(string.sub(num, j, j));
        --  prefeb.transform:GetChild(j - 1):GetComponent("Image").sprite = self.ChipNum.transform:GetChild(chiponevalue):GetComponent("Image").sprite
    end
end

-- 金币数字转换汉字显示
function TBNNPanel.GoldToText(obj, num, startstr)
    local numstr = " ";
    local endstr = " ";
    local neednum = toInt64(num);
    obj.transform:GetComponent('Text').text = " ";
    if neednum < toInt64(2100000000) then
        neednum = tonumber(tostring(neednum))
        if neednum < 10000 then
    logYellow("金币数字转换汉字显示2")
            obj.transform:GetComponent('Text').text = tostring(neednum);
            return;
        elseif neednum < 100000000 then
    logYellow("金币数字转换汉字显示3")

            numstr = tostring(neednum / 10000);
            endstr = "万";
        else
    logYellow("金币数字转换汉字显示4")

            numstr = tostring(neednum / 100000000);
            endstr = "亿";
        end

    else
        if neednum < toInt64(10000) then
            obj.transform:GetComponent('Text').text = tostring(neednum);
            return;
        elseif neednum < toInt64(100000000) then
            numstr = tostring(neednum / 10000);
            endstr = "万";
        else
            numstr = tostring(neednum / 100000000);
            endstr = "亿";
        end
    end
    if #numstr > 4 then numstr = string.sub(numstr, 1, 4); end
    if ("." == string.sub(numstr, 4, 4)) then numstr = string.sub(numstr, 1, (#numstr) - 1); end
    if startstr == nil then
        obj:GetComponent('Text').text = numstr .. endstr;
    else
        obj:GetComponent('Text').text = startstr .. numstr .. endstr;
    end
end

-- 金币数字转换图片显示
function TBNNPanel.GoldToImg(obj, num, imgf)
    local numstr = " ";
    local endstr = " ";
    local showstr = " ";
    local neednum = tonumber(tostring(num));
    if neednum < 10000 then
        numstr = tostring(neednum);
    elseif neednum < 100000000 then
        numstr = tostring(neednum / 10000);
        endstr = "w";
        if string.len(numstr) > 4 then numstr = string.sub(numstr, 1, 4); end
    elseif neednum < 1000000000 then
        numstr = tostring(neednum / 10000);
        endstr = "w";
        if string.len(numstr) > 4 then numstr = string.sub(numstr, 1, 5); end
    elseif neednum < 10000000000 then
        numstr = tostring(neednum / 10000);
        endstr = "w";
        if string.len(numstr) > 4 then numstr = string.sub(numstr, 1, 6); end
    end

    if ("." == string.sub(numstr, 4, 4)) then numstr = string.sub(numstr, 1, (string.len(numstr)) - 1); end
    showstr = numstr

    if endstr ~= " " then showstr = numstr .. endstr end
    if obj.transform.childCount > string.len(showstr) then
        for j = string.len(showstr), obj.transform.childCount - 1 do
            destroy(obj.transform:GetChild(j).gameObject);
        end
    end
    for i = 1, string.len(showstr) do
        local a = string.sub(showstr, i, i);
        if tonumber(a) == nil then
            if a == "w" then a = 10 end
            if a == "." then a = 11 end
            if a == " " then return end
        end
        if obj.transform.childCount < i then
            local go2 = newobject(imgf.transform:GetChild(a).gameObject);
            go2.transform:SetParent(obj.transform);
            go2.transform.localScale = Vector3.one;
            go2.transform.localPosition = Vector3.New(0, 0, 0);
            go2.name = a;
        else
            obj.transform:GetChild(i - 1).gameObject.name = a;
            obj.transform:GetChild(i - 1).gameObject:GetComponent('Image').sprite = imgf.transform:GetChild(a).gameObject:GetComponent('Image').sprite;
            obj.transform:GetChild(i - 1).gameObject:GetComponent('Image'):SetNativeSize();
        end
    end
end

function TBNNPanel.ReturnGoldToText(num)
    local numstr = " ";
    local endstr = " ";
    local neednum = toInt64(num);
    if neednum < toInt64(10000) then
        return neednum;
    elseif neednum < toInt64(100000000) then
        numstr = tostring(neednum / 10000);
        endstr = "万";
    else
        numstr = tostring(neednum / 100000000);
        endstr = "亿";
    end
    if #numstr > 4 then numstr = string.sub(numstr, 1, 4); end
    if ("." == string.sub(numstr, 4, 4)) then numstr = string.sub(numstr, 1, (#numstr) - 1); end
    local returnstr = numstr .. endstr;
    return returnstr;
end

-- 准备(游戏内未使用)
function TBNNPanel.IsReadyOnClick(args)
    --  error("=================用户发送准备===========");
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_USER_READY, buffer, gameSocketNumber.GameSocket);
    TBNNMH.Game_State = 65535;
    self.SetShowBtn()
    NiuNiu_IsGameStartIn = false;
    IsMyselfOpen = true;
end

-- 是否叫庄
function TBNNPanel.IsCallBankerOnClick(args)
    MusicManager:PlayX(self.BtnMusic);
    local bybanker = 0;
    if args.name == "NoCallBankerBtn" then
        --  error("玩家不叫庄");
        bybanker = 0;
    elseif args.name == "CallBankerBtn" then
        --  error("玩家叫庄");
        bybanker = 1;
    end
    local data = {
        [1] = bybanker,
    }
    local buffer = SetC2SInfo(TBNNMH.CMD_CS_PLAYER_ROB_BANKER, data)
    Network.Send(MH.MDM_GF_GAME, TBNNMH.SUB_CS_PLAYER_ROB_BANKER, buffer, gameSocketNumber.GameSocket);

    TBNNMH.Game_State = 65534;
    self.SetShowBtn()
    NiuNiu_IsPlayingGame = true;
end

-- 下注按钮
function TBNNPanel.ChipValueOnClick(args)
    MusicManager:PlayX(self.ChipBtnMusic)
    coroutine.stop(fun)
    local chipnum = tonumber(args.name);
    logYellow("chipnum=========="..chipnum)
    if toInt64(chipnum) > toInt64(NiuNiuUserInfoTable[TBNNMH.MySelf_ChairID + 1]._7wGold) then return end

    local b = ByteBuffer.New();
    b:WriteLong(chipnum);
    Network.Send(MH.MDM_GF_GAME, TBNNMH.SUB_CS_PLAYER_CHIP, b, gameSocketNumber.GameSocket);
    TBNNMH.Game_State = 65534;
    self.SetShowBtn()
end

-- 系统配牌
function TBNNPanel.HintPokerOnClick()
    MusicManager:PlayX(self.BtnMusic);
    local buffer = ByteBuffer.New();
    buffer:WriteUInt16(TBNNMH.MySelf_ChairID);
    Network.Send(MH.MDM_GF_GAME, TBNNMH.SUB_CS_PLAYER_OPEN_POKER_TIP, buffer, gameSocketNumber.GameSocket);
    TBNNMH.Game_State = 65534;
    self.SetShowBtn()
    self.PokerNum:SetActive(false);
end

-- 玩家自己配牌
function TBNNPanel.PlayerPokerOnClick(args)
    MusicManager:PlayX(self.BtnMusic);
    local poker1 = 0;
    local poker2 = 0;
    local choosenum = 0;
    --判断有几张牌是在提起的状态
    for i = 1, self.myselfpalyer.transform.childCount do
        if self.myselfpalyer.transform:GetChild(i - 1).localPosition.y > 0 then
            choosenum = choosenum + 1;
        end
    end
    local num = 0;
    local poslen = 0;
    if choosenum == 2 then
        poslen = 30;
    elseif choosenum == 3 then
        poslen = 0;
    else
        return;
    end
    for i = 1, self.myselfpalyer.transform.childCount do
        if self.myselfpalyer.transform:GetChild(i - 1).localPosition.y == poslen then
            num = num + 1;
            if num == 1 then poker1 = MyselfPokerTab[i]; end
            if num == 2 then poker2 = MyselfPokerTab[i]; end
        end
    end
    if poker1 == 0 or poker1 == 0 then return end

    -- 配牌需要存储
    local data = {
        [1] = poker1,
        [2] = poker2,
    }

    local buffer = SetC2SInfo(TBNNMH.CMD_CS_PLAYER_OPEN_POKER, data)
    Network.Send(MH.MDM_GF_GAME, TBNNMH.SUB_CS_PLAYER_OPEN_POKER, buffer, gameSocketNumber.GameSocket);
    TBNNMH.Game_State = 65534;
    self.SetShowBtn()
end

local IsShowPoint=false
-- 点击牌面 牌的提起放下
function TBNNPanel.ChoosePokerOnClick(args)
    if IsMyselfOpen then return end
    
    MusicManager:PlayX(self.CardBtnMusic);
    IsShowPoint=true
    if args.transform.localPosition.y > 0 then

        args.transform.localPosition = Vector3.New(args.transform.localPosition.x, 0, args.transform.localPosition.z);
        ChoosePokerNum = ChoosePokerNum - 1;
        for i = 1, #ClickPoketNum do
            if ClickPoketNum[i] == tonumber(args.name) then ClickPoketNum[i] = 0; end
        end

    else

        if ChoosePokerNum >= 3 then return; end
        args.transform.localPosition = Vector3.New(args.transform.localPosition.x, 30, args.transform.localPosition.z);
        ChoosePokerNum = ChoosePokerNum + 1;
        
        for i = 1, #ClickPoketNum do
            -- ClickPoketNum[ChoosePokerNum]=tonumber(args.name);

            if ClickPoketNum[i] == 0 and i <= ChoosePokerNum  and IsShowPoint then
                ClickPoketNum[i] = tonumber(args.name);
                IsShowPoint=false
            end

        end
    end
    self.ShowPokerNum();
    if ChoosePokerNum >= 2 then--提起两张牌以后才能点击确定
        self.SureBtn.transform:GetComponent('Button').interactable = true;
    else
        self.SureBtn.transform:GetComponent('Button').interactable = false;
    end;
end

-- 点击牌面，显示点数--计算各个牌的和
function TBNNPanel.ShowPokerNum()
    local allsum = 0;
    for i = 1, #ClickPoketNum do
        --local num = self.Ten2tTwo(ClickPoketNum[i])[2];
        local num = tonumber((string.split(Util.OutPutPokerValue(ClickPoketNum[i]), ",")[2]));

        if num > 10 then num = 10 end
        if ClickPoketNum[i] ~= 0 then self.PokerNumTab[i].transform:GetComponent('Text').text = num; end
        if ClickPoketNum[i] == 0 then self.PokerNumTab[i].transform:GetComponent('Text').text = " "; end
        allsum = allsum + num;
    end
    self.PokerNumSum:GetComponent('Text').text = allsum;
end

-- 每局结束清理、隐藏数据
function TBNNPanel.ClearDesk()
end

-- 点击用户信息
function TBNNPanel.OpenInfo(args)
    if not (gameIsOnline) then return end;
    -- MusicManager:Play("Music/Hall/anniu3")
    HallScenPanel.PlayeBtnMusic();
    local str = args.name;
    local num = tonumber(string.sub(str, #str, -1));
    self.OnClickNum = num;
    PlayerInfoSystem.SelectUserInfo(NiuNiuUserInfoTable[num + 1]._1dwUser_Id, NiuNiu, args.transform:Find("Head/Head").gameObject)
    coroutine.start(self.SetGold);
end
--设置查看用户信息中的金币数量
function TBNNPanel.SetGold()
    while
    PlayerInfoSystem.PlayererInfoPanel == nil
    do
        coroutine.wait(0.1);
    end
    if PlayerInfoSystem.PlayererInfoPanel ~= nil then PlayerInfoSystem.gold.text = tostring(NiuNiuUserInfoTable[self.OnClickNum + 1]._7wGold) end;
end

-- 点击关闭用户界面
function TBNNPanel.ClosePanel()
    destroy(NiuNiu_PlayerInfoPanel)
end

-- 显示提示界面
function TBNNPanel.ShowHintInfo()
    -- 加载提示资源
    --  ResManager:LoadAsset('module03/game_niuniu', 'NiuNiu_MessagePanel', self.CreatHintInfo);
    --   error("加载提示资源=================");
    local t = GeneralTipsSystem_ShowInfo;
    t._01_Title = "提    示";
    t._02_Content = "当前正在游戏，确认退出？";
    t._03_ButtonNum = 2;
    t._04_YesCallFunction = self.SureBtnOnClick;
    t._05_NoCallFunction = self.IguoreBtnOnClick;
    MessageBox.CreatGeneralTipsPanel(t);
end

function TBNNPanel.CreatHintInfo(prefeb)
    local go = newobject(prefeb);
    go.transform:SetParent(self.transform);
    go.name = "NiuNiu_HintInfoPanel";
    go.transform.localScale = Vector3.one;
    go.transform.localPosition = Vector3.New(0, 0, 0);
    NiuNiu_HintInfoPanel = go;
    local NiuNiu_HintInfoPanel_SureBtn = go.transform:Find("Bg/SureBtn").gameObject
    local NiuNiu_HintInfoPanel_IguoreBtn = go.transform:Find("Bg/IguoreBtn").gameObject
    niuniuluaBehaviour:AddClick(NiuNiu_HintInfoPanel_IguoreBtn, self.IguoreBtnOnClick);
    niuniuluaBehaviour:AddClick(NiuNiu_HintInfoPanel_SureBtn, self.SureBtnOnClick)
    -- error("绑定资源方法=================");
end

function TBNNPanel.CloseGameCall()
    Event.Brocast(MH.Game_LEAVE);
end

--确定退出
function TBNNPanel.SureBtnOnClick()
    error("确定退出")
    -- MHallgo.gameObject:SetActive(true);
    GameNextScenName = gameScenName.HALL;
    MessgeEventRegister.Game_Messge_Un();
    for i = 1, #NiuNiuAllPlayerTable do
        NiuNiuAllPlayerTable[i].StartAni = false;
        NiuNiuAllPlayerTable[i]:IsShowTimer(false, 0, 0);
    end
    GameSetsBtnInfo.LuaGameQuit();
    coroutine.start(self.DestoryAb)
end

-- 点击取消提示界面
function TBNNPanel.IguoreBtnOnClick()
    -- error("点击取消按钮");
    --  destroy(NiuNiu_HintInfoPanel)
end

function TBNNPanel.DestoryAb()
    coroutine.wait(1);
    Unload("game_niuniu");
    Unload("game_niuniu_music");
end

-- 清理数据
function TBNNPanel.ClearInfo()
    GameState = 0;--游戏装态归为空状态
    NiuNiuAllPlayerTable = {};
    NiuNiuUserInfoTable = {};
    NiuNiuChipValue = { 400, 800, 1200, 1600 };
    IsTest = false;
    ChoosePokerNum = 0;
    PlayerChoosePoker = {};
    MyselfPokerTab = {};
    -- 判断用户是否是游戏中进入
    NiuNiu_IsGameStartIn = true;
    -- 判断玩家是否参与当局游戏
    NiuNiu_IsPlayingGame = false;

    -- 自己的座位
    TBNNMH.MySelf_ChairID = 65535;
    -- 庄家座位号
    TBNNMH.Banker_ChairID = 65535;

    IsMyselfOpen = true;

    IsBankerTime = false;

    IsSetTimeNum = false;

    timeNum = 0;
    TimeAllNum = 0;
    timing = 0;
    -- 是否为庄家逃跑
    TBNNMH.IsBankerLeave = false;
    -- 当前正在进行的状态
    TBNNMH.Playing_State = 0;
    -- 已经经过的时间
    TBNNMH.Playing_Time = 0;
    -- 牛牛下注表
    TBNNMH.NiuNiuChipObj = {};
end
-- 设置庄家图标位置
function TBNNPanel.ReSetBankerPos()
    self.BankerImg.transform:SetParent(self.transform:Find("Bg"));
    self.BankerImg.transform.localPosition = Vector3.New(0, 0, 0);
    self.BankerImg.transform.localScale = Vector3.New(1, 1, 1);
    for i = 1, #NiuNiuAllPlayerTable do
        NiuNiuAllPlayerTable[i]:SetChangeBg(false)
    end

end

function TBNNPanel.SetMusicVolumn(value)
    MusicManager:SetValue(MusicManager:GetSoundVolume(),value);
    MusicManager:SetMusicMute(value <= 0);
end

function TBNNPanel.SetSoundVolumn(value)
    MusicManager:SetValue(value,MusicManager:GetMusicVolume());
    MusicManager:SetSoundMute(value <= 0);
end

function TBNNPanel.WaitOpenTime()
    if NiuNiu_IsGameStartIn then return end
    if IsMyselfOpen then return end
    coroutine.wait(9);
    if IsMyselfOpen then
        -- 自己开牌
    else
        -- 没有自己开牌
        self.HintPokerOnClick();
    end
end

--未使用拖拽
-- 自己牌型拖拽
-- 拖拽前初始化
function TBNNPanel.InitPoker()
    self.RisMove = false;

    self.pokerStartpos = self.myselfpalyer.transform:GetChild(0).position.x

    self.pokerEndpos = self.myselfpalyer.transform:GetChild(4).position.x

    self.Rmoveing_pos = nil;
    -- 鼠标拖拽的起始点
    self.Rmouse_s_pos = nil;
    -- 鼠标拖拽的结束点
    self.Rmouse_e_pos = nil;
    for i = 1, self.myselfpalyer.transform.childCount do
        local pokerprefeb = self.myselfpalyer.transform:GetChild(i - 1).gameObject;
        local poker_listerner = Util.AddComponent("EventTriggerListener", pokerprefeb);
        poker_listerner.onBeginDrag = self.OnPokerBeginDrag;
        poker_listerner.onDrag = self.OnPokerDrag;
        poker_listerner.onEndDrag = self.OnPokerEndDrag;
    end
end

-- 开始拖拽
function TBNNPanel.OnPokerBeginDrag(go, args)
    if IsMyselfOpen then return end
    --error("开始拖拽=================" .. args.position.x);
    self.Rmouse_s_pos = args.position;
end

-- 拖拽中
function TBNNPanel.OnPokerDrag(go, args)
    if IsMyselfOpen then return end
    if self.Rmouse_s_pos == nil then self.Rmouse_s_pos = args.position end
    if self.Rmoveing_pos == nil then self.Rmoveing_pos = args.position end
    --  error("拖拽中==================" .. args.position.x);
    if self.Rmouse_s_pos.x < args.position.x then
        for i = 1, self.myselfpalyer.transform.childCount do
            local pokerprefeb = self.myselfpalyer.transform:GetChild(i - 1).gameObject;
            if pokerprefeb.transform.position.x > self.Rmouse_s_pos.x - 5 and pokerprefeb.transform.position.x < args.position.x then
                pokerprefeb.transform:GetComponent('Image').color = Color.New(0.5, 0.5, 0.5, 1);
            elseif pokerprefeb.transform.position.x > args.position.x then
                pokerprefeb.transform:GetComponent('Image').color = Color.New(1, 1, 1, 1);
            end
        end
    else
        for i = 1, self.myselfpalyer.transform.childCount do
            local pokerprefeb = self.myselfpalyer.transform:GetChild(i - 1).gameObject;
            if pokerprefeb.transform.position.x < self.Rmouse_s_pos.x + 5 and pokerprefeb.transform.position.x > args.position.x then
                pokerprefeb.transform:GetComponent('Image').color = Color.New(0.5, 0.5, 0.5, 1);
            elseif pokerprefeb.transform.position.x < args.position.x then
                pokerprefeb.transform:GetComponent('Image').color = Color.New(1, 1, 1, 1);
            end
        end
    end
end

-- 拖拽结束
function TBNNPanel.OnPokerEndDrag(go, args)
    if IsMyselfOpen then return end
    --  error("结束拖拽=================" .. args.position.x);
    for i = 1, self.myselfpalyer.transform.childCount do
        local pokerprefeb = self.myselfpalyer.transform:GetChild(i - 1).gameObject;
        pokerprefeb.transform:GetComponent('Image').color = Color.New(1, 1, 1, 1);
    end
    self.Rmouse_e_pos = args.position;
    if self.Rmouse_s_pos == nil then self.Rmouse_e_pos = args.position end
    if self.Rmouse_s_pos.x < self.Rmouse_e_pos.x then
        for i = 1, self.myselfpalyer.transform.childCount do

            local pokerprefeb = self.myselfpalyer.transform:GetChild(i - 1).gameObject;
            if pokerprefeb.transform.position.x > self.Rmouse_s_pos.x - 5 and pokerprefeb.transform.position.x < args.position.x then
                if pokerprefeb.transform.localPosition.y > 0 then
                    ChoosePokerNum = ChoosePokerNum - 1;
                    pokerprefeb.transform.localPosition = Vector3.New(pokerprefeb.transform.localPosition.x, 0, pokerprefeb.transform.localPosition.z)

                else
                    ChoosePokerNum = ChoosePokerNum + 1;
                    if ChoosePokerNum > 3 then ChoosePokerNum = ChoosePokerNum - 1; return end
                    pokerprefeb.transform.localPosition = Vector3.New(pokerprefeb.transform.localPosition.x, 30, pokerprefeb.transform.localPosition.z)
                end
            end
        end
    else
        -- 反选
        for i = 1, self.myselfpalyer.transform.childCount do

            local pokerprefeb = self.myselfpalyer.transform:GetChild(i - 1).gameObject;
            if pokerprefeb.transform.position.x < self.Rmouse_s_pos.x + 5 and pokerprefeb.transform.position.x > args.position.x then
                if pokerprefeb.transform.localPosition.y > 0 then
                    ChoosePokerNum = ChoosePokerNum - 1;
                    pokerprefeb.transform.localPosition = Vector3.New(pokerprefeb.transform.localPosition.x, 0, pokerprefeb.transform.localPosition.z)
                else
                    ChoosePokerNum = ChoosePokerNum + 1;
                    if ChoosePokerNum > 3 then ChoosePokerNum = ChoosePokerNum - 1; return end
                    pokerprefeb.transform.localPosition = Vector3.New(pokerprefeb.transform.localPosition.x, 30, pokerprefeb.transform.localPosition.z)
                end
            end
        end

    end


    if ChoosePokerNum == 2 or ChoosePokerNum == 3 then
        self.SureBtn.transform:GetComponent('Button').interactable = true;
    else
        self.SureBtn.transform:GetComponent('Button').interactable = false;
    end
end

--返回一个值
function TBNNPanel.retnum(n1, n2)
    local num = n1 - n2;
    if num < 0 then
        num = num + TBNNMH.GAME_PLAYER;
    end
    num = num + 1;
    return num;
end