require "Module20/Game_Baccara/BaccaraDataInfo"
-- 路单顺序大小闲0、庄1、和2、闲天王3、庄天王4
BaccaraPanel = {};

local self = BaccaraPanel;

local strAbRes = "module20/game_baccarat";
local strAbMusic = "module20/game_baccarat_music";
-- 父对象
local BaccaraObj;
local BaccaraCanvas;
local luaBehaviour;
-- 当前选中的筹码Btn名称
local ChooseChipName = "One";
local ChooseChipNum = 100;
local ChooseChipTable = {};
-- 剩余牌的数量
-- 下注最高的庄与闲位置
-- 场景中所有用户信息
local AllScenPlayer = {};
-- 下注时间
local TimeNumber = (1 / 450) * 312;
-- 咪牌时间
local DrawCardTime = 15;
-- 当前是否可以下注
local IsChipBL = false;
-- 记录下注按钮对象
local C_CHIP_AREA_BTN = {}
-- 记录用户选择庄、闲（0代表未选择、1代表闲、2代表庄）
local IsChipNumber = 0;
-- 记录需要发牌的对象
local DealCardParset;
-- 闲扑克数据 无牌为 0
local m_byPlayerPokerData = { 0, 0, 0 }
-- 庄扑克数据 无牌为 0
local m_byBankerPokerData = { 0, 0, 0 }
-- 发牌表
local SendPoker = {};
-- //区域名称
local C_CHIP_AREA_BTN_NAME = { "PlayerKingBtn", "BankerKingBtn", "PlayerBtn", "BankerBtn", "DeuceBtn" };
-- 历史记录
local bywheelCountTable = {};
-- 剩余牌数
local CardCount = 0;
-- 初始限红数据表
local IsNumValue = true;
local StartlimitMaxChipTable = { 0, 0, 0, 0, 0 };
-- 限红数据表
local limitMaxChipTable = {};

-- 所有下注筹码数
local AllChipValueTable = {};
-- 自己下注筹码数
local MyselfChipValueTable = {}
-- 游戏状态
local GameState = 0;
-- 闲家当前点数
local playerPoint = 0;
-- 庄家当前点数
local bankerPoint = 0;
-- 每局输赢结果表
local GameOverInfoTable = {};
-- 记录每局输赢值
local showWinLoseValue = 0;
-- 记录每个下注区域输赢状态 0表示输、1表示赢
local ChipWinOrLoseState = { 0, 0, 0, 0, 0 };
-- 记录上次下注总数
local lastChipValue = 0;
local CreatingAllChip = { 0, 0, 0, 0, 0 };
local CreatingMyselfChip = { 0, 0, 0, 0, 0 };
-- 记录房间个数
local RoomPeople = 0;
-- 等待上庄列表
local BankerListInfoTable = {};

-- 根据按钮的名称来确定是押注的闲Or庄
local IsAllChip = false;
-- 是否播放图片放大
-- 记录每个区域的筹码数量
local CHipAreaNum = { 0, 0, 0, 0, 0 };
-- 下注已经经过的时间
local OldTime = 0;
-- 是否正在播放结算动画
local IsGameEndAni = false;

-- 玩家上局下注数
local LastChipNum = 0;

local StartTime = 0;

-- 是否是自己为庄家
local IsMyselfBanker = false;

-- 百家乐声音
local BaccaraMusic = nil;

-- 是否要创建筹码
local IsWaiteUpdate = true;

local GameTime = 0;

-- 调用发牌时间
local SendPokerTime = 0;
-- 收到服务器消息时间
local PlayingTime = 0;
-- 判断是否网速卡顿
-- 收到结算消息的时间
local GameOverStartTime = 0;

-- 是否Home键返回
local IsBackGame = false;
local BackGameTime = 0;
local AllPlayerInfo = {}
local GameNextScenName = gameScenName.Baccara;
-- 记录续押
local ReChipTable = { 0, 0, 0, 0, 0 };

local IssendPokerpos = false;
local openpokernum = 1;
-- 筹码缩放大小
local chipsclae = 0.335
-- 牌间隔位置
local poketw = 100;

local iWayBillPhonePosY0 = -295;
local iWayBillPhonePosY = -147;

local iWayBillPCPosY0 = -285;
local iWayBillPCPosY = -135;

local C_X_POKEREND_ID = 254;
local C_Z_POKEREND_ID = 255;

local C_BALL_BASE_COL = 13; --二级路单初始列数

local bGameQuit = false;

self.isChipsOn = false;

function BaccaraPanel:Begin(obj)
    logYellow("=================b=====================");
    self.tabObjPool = {};
    BaccaraPanel = self;
    self.ChipTime = 0;
    GameNextScenName = gameScenName.Baccara
    IsBackGame = false;
    BackGameTime = 0;
    StartTime = os.time();
    MessgeEventRegister.Game_Messge_Un();
    self.ClearInfo();
    self.BaccaraObj = obj;
    self.LuaBehaviour = self.BaccaraObj.transform:GetComponent('CsJoinLua');

    --LoadAssetAsync(strAbRes, 'BaccaraCanvasNew_01', self.CreatGamePanel, true, true);
    BaccaraPanel.CreatGamePanel(obj.transform:Find("BaccaraCanvasNew_01"))
    m_byPlayerPokerData = { 0, 0, 0 }
    -- 庄扑克数据 无牌为 0
    m_byBankerPokerData = { 0, 0, 0 }
    RoomPeople = 0;
end

function BaccaraPanel.MusicOver(obj)
    BaccaraMusic = BaccaraPanel.Pool("Baccarat_Music");
    local bgchip = BaccaraMusic.transform:Find("bgm"):GetComponent('AudioSource')
    MusicManager:PlayBacksoundX(bgchip.clip, true);


end
function BaccaraPanel.gamelogon()
    -- 清除消息事件
    MessgeEventRegister.Game_Messge_Un();
    local t = EventCallBackTable;
    error("  -- =====绑定方法==== -- ");
    t._01_GameInfo = self.GameInfoMethod;
    t._02_ScenInfo = self.SceneInfoMethod;
    t._03_LogonSuccess = self.LogonSuccessMethod;
    t._04_LogonOver = self.LogonOverMethod;
    t._05_LogonFailed = self.LogonFailedMethod;
    t._06_Biao_Action = self.BiaoActionMethod;
    t._07_UserEnter = self.UserEnterMethod;
    t._08_UserLeave = self.UserLeaveMethod;
    t._09_UserStatus = self.UserStatusMethod;
    t._10_UserScore = self.UserScoreMethod;
    t._11_GameQuit = self.GameQuitMethod;
    t._12_OnSit = self.GameOnSitMethod;
    t._13_ChangeTable = self.ChangeTableMethod;
    t._14_RoomBreakLine = self.GameBreakLineMethod;
    t._15_OnBackGame = self.BackGame;
    t._16_OnHelp = self.HelpMethod;
    t._17_OnStopGame = self.OnStopGame;
    MessgeEventRegister.Game_Messge_Reg(t);
    -- 发送登陆
    local data = {
        [1] = 0,
        [2] = 0,
        [3] = SCPlayerInfo._01dwUser_Id,
        [4] = SCPlayerInfo._06wPassword,
        [5] = Opcodes,
        [6] = 0,
        [7] = 0,
    }
    local buffer = SetC2SInfo(BaccaraMH.CMD_GR_LogonByUserID, data);
    error("发送登录");
    Network.Send(MH.MDM_GR_LOGON, 3, buffer, gameSocketNumber.GameSocket)
    AllPlayerInfo = {}
end
self.leavetime = 0;
function BaccaraPanel.OnStopGame()
    error("home离开游戏");
    self.leavetime = Util.TickCount;

    table.insert(ReturnNotShowError, "95003");
    Network.Close(gameSocketNumber.GameSocket)
    -- GameNextScenName = gameScenName.HALL
end
-- 创建游戏界面
--function BaccaraPanel.CreatGamePanel(go)
--    LoadAssetAsync(strAbMusic, 'Baccarat_Music', self.MusicOver, false, true);
--    --local go = newobject(prefeb);
--    go.transform:SetParent(self.BaccaraObj.transform);
--    GameManager.PanelRister(self.BaccaraObj);
--    go.name = "BaccaraCanvas";
--    go.transform.localScale = Vector3.one;
--    go.transform.localPosition = Vector3.New(0, 0, 0);
--    BaccaraCanvas = go;
--    GameManager.GameScenIntEnd();
--    self.FindComponent();
--    self.gamelogon();
--    GameManager.PanelInitSucceed(self.BaccaraObj);
--end
function BaccaraPanel.CreatGamePanel(go)

    --LoadAssetAsync(strAbMusic, 'Baccarat_Music', self.MusicOver, false, true);
    BaccaraPanel.MusicOver();
    --local go = newobject(prefeb);
    GameManager.PanelRister(self.BaccaraObj);
    --go.transform:SetParent(self.BaccaraObj.transform);
    go.name = "BaccaraCanvas";
    --go.transform.localScale = Vector3.one;--Find
    --go.transform.localPosition = Vector3.New(0, 0, 0);
    local traCamera = nil;
    traCamera = go.transform:Find("Camera");
    traCamera.transform.localRotation = Vector3.New(0, 0, 0);
    traCamera:GetComponent("Camera").clearFlags = UnityEngine.CameraClearFlags.SolidColor;
    SetCanvasScalersMatch(go.transform:GetComponent("CanvasScaler"), 1); --屏幕适配
    go.transform:GetComponent("CanvasScaler").referenceResolution = Vector2.New(1334, 750);
    GameManager.PanelInitSucceed(self.BaccaraObj);

    --local fun = function (obj)
    obj = BaccaraPanel.PoolForNewobject("Bg");

    obj.transform:SetParent(go.transform);
    obj.transform:SetSiblingIndex(1);
    go.transform:Find("Zhuozi/Show").gameObject:SetActive(false);
    --GameManager.PanelRister(self.BaccaraObj);
    obj.name = "Bg";
    obj.transform.localScale = Vector3.one;
    obj.transform.localPosition = Vector3.New(0, 0, 0);
    BaccaraCanvas = go;
    GameManager.GameScenIntEnd();
    self.FindComponent();
    self.gamelogon();
    --GameManager.PanelInitSucceed(self.BaccaraObj);
    -- end
    --LoadAssetAsync(strAbRes, 'Bg', fun, true, true);
end

-- 查找游戏界面元素
function BaccaraPanel.FindComponent()

    -- local bg = GameObject.New("BgImage"):AddComponent(typeof(UnityEngine.UI.Image));
    -- bg.transform:SetParent(BaccaraCanvas.transform);
    -- bg.transform:SetAsFirstSibling();
    -- bg.transform.localPosition = Vector3(0, 0, 0);
    -- bg.transform.localScale = Vector3(1, 1, 1);
    -- bg.sprite = HallScenPanel.moduleBg:Find("module17-20/module20"):GetComponent("Image").sprite;
    -- bg:GetComponent("RectTransform").sizeDelta = Vector2.New(Screen.width / Screen.height * 750 + 20, 750 + 20);
    BaccaraCanvas.transform:Find("Zhuozi"):SetAsFirstSibling();
    BaccaraCanvas.transform:Find("BgImage"):SetAsFirstSibling();

    -- BaccaraCanvas.transform:Find("Bg"):GetComponent("RectTransform").sizeDelta = Vector2.New(1700, 750);
    -- BaccaraCanvas.transform:Find("Bg/SendCard"):GetComponent("RectTransform").sizeDelta = Vector2.New(1700, 800);


    -- 相机
    self.mycarmer = BaccaraCanvas.transform:Find("Camera").gameObject;
    -- 无人当庄图片
    self.waitBankerInfoImg = BaccaraCanvas.transform:Find("waitImg").gameObject;
    self.waitBankerInfoImg:SetActive(false);
    -- 显示可下注分数
    self.ShowChipScore = BaccaraCanvas.transform:Find("Bg/ShowChipScore").gameObject;
    -- 庄下分
    self.BankerScores = BaccaraCanvas.transform:Find("Bg/ShowChipScore/Banker/Text").gameObject;
    -- 庄对下分
    self.BankerKingScores = BaccaraCanvas.transform:Find("Bg/ShowChipScore/BankerKing/Text").gameObject;
    -- 闲下分
    self.PlayerScores = BaccaraCanvas.transform:Find("Bg/ShowChipScore/Player/Text").gameObject;
    -- 闲对下分
    self.PlayerKingScores = BaccaraCanvas.transform:Find("Bg/ShowChipScore/PlayerKing/Text").gameObject;
    -- 和下分
    self.DecuceScores = BaccaraCanvas.transform:Find("Bg/ShowChipScore/Decuce/Text").gameObject;
    for i = 1, 5 do
        self.ShowChipScore.transform:GetChild(i - 1):Find("Text"):GetComponent("Text").text = "limit："
    end
    -- 开始发牌
    self.SendCardBg = BaccaraCanvas.transform:Find("Bg/SendCard").gameObject;
    -- 赢家显示动画
    self.WinAni = BaccaraCanvas.transform:Find("Bg/SendCard/Win").gameObject;
    -- 和显示动画
    self.heAni = BaccaraCanvas.transform:Find("Bg/SendCard/he").gameObject;
    -- 显示庄闲每局点数
    -- 显示庄家点数
    self.BankerCardPoint = BaccaraCanvas.transform:Find("Bg/SendCard/BankerNumPoint").gameObject;
    self.BankerCardPoint:SetActive(false);
    -- 显示闲家点数
    self.PlayerCardPoint = BaccaraCanvas.transform:Find("Bg/SendCard/PlayerNumPoint").gameObject;
    self.PlayerCardPoint:SetActive(false);

    -- 显示庄家点数
    self.BankerCardValue = BaccaraCanvas.transform:Find("Bg/SendCard/BankerNumPoint/num").gameObject;
    -- 显示闲家点数
    self.PlayerCardValue = BaccaraCanvas.transform:Find("Bg/SendCard/PlayerNumPoint/num").gameObject;

    -- 玩家筹码
    self.ChipImg = BaccaraCanvas.transform:Find("ChipBtn").gameObject;
    self.ChipImg:SetActive(false);
    -- 可下注筹码
    self.ChipBtn = BaccaraCanvas.transform:Find("Bg/ChipBtn").gameObject;
    self.ChipBtn.transform.localPosition = Vector3.New(0, -500, 0)
    -- 下注值
    self.ChipHundred = BaccaraCanvas.transform:Find("Bg/ChipBtn/One").gameObject;
    self.ChipThousand = BaccaraCanvas.transform:Find("Bg/ChipBtn/Two").gameObject;
    self.ChipTenThousand = BaccaraCanvas.transform:Find("Bg/ChipBtn/Three").gameObject;
    self.ChipHundredThousand = BaccaraCanvas.transform:Find("Bg/ChipBtn/Four").gameObject;
    -- 续押
    -- 玩家自己详情
    self.MyselfHeadImg = BaccaraCanvas.transform:Find("Bg/PersonalInfo/HeadMask/HeadImg").gameObject;
    self.MyselfHeadImg.transform:GetComponent('Image').sprite = HallScenPanel.GetHeadIcon();
    self.MySelfBtn = self.MyselfHeadImg;
    self.MyselfName = BaccaraCanvas.transform:Find("Bg/PersonalInfo/Myself/Name").gameObject;
    self.MyselfName:GetComponent("Text").text = SCPlayerInfo._05wNickName;
    self.MyselfScore = BaccaraCanvas.transform:Find("Bg/PersonalInfo/Myself/Score").gameObject;
    self.MyselfScore:GetComponent("Text").text = tostring(gameData.GetProp(enum_Prop_Id.E_PROP_GOLD));
    self.MyselfScore:GetComponent("RectTransform").sizeDelta = Vector2.New(180, 30);
    self.MyselfScore.transform.localPosition = Vector3.New(60, -24.5, 0);
    self.MyselfScore:GetComponent("Text").fontSize = 20;
    self.MyScoreImg = BaccaraCanvas.transform:Find("Bg/PersonalInfo/Myself/ScoreImg").gameObject;
    self.MyScoreImg:SetActive(false);
    self.MyselfAddGold = BaccaraCanvas.transform:Find("Bg/PersonalInfo/Myself/Text").gameObject;
    self.MyselfAddGold:SetActive(false);
    -- 自己下注，所有人下注
    self.BetAreaChipNumBg = BaccaraCanvas.transform:Find("Bg/BetAreaChipNumBg").gameObject;
    -- 筹码位置
    self.BetArea = BaccaraCanvas.transform:Find("Bg/BetArea").gameObject;
    -- 显示点击区域
    self.BetAreaBg = BaccaraCanvas.transform:Find("Bg/BetAreaBg").gameObject;
    -- 押注（庄）
    self.BankerBtn = BaccaraCanvas.transform:Find("Bg/BetAreaBg/BankerBtn").gameObject;
    -- 押注（闲）
    self.PlayerBtn = BaccaraCanvas.transform:Find("Bg/BetAreaBg/PlayerBtn").gameObject;
    -- 押注（和）
    self.DeuceBtn = BaccaraCanvas.transform:Find("Bg/BetAreaBg/DeuceBtn").gameObject;
    -- 押注（庄对）
    self.BankerKingBtn = BaccaraCanvas.transform:Find("Bg/BetAreaBg/BankerKingBtn").gameObject;
    -- 押注（闲对）
    self.PlayerKingBtn = BaccaraCanvas.transform:Find("Bg/BetAreaBg/PlayerKingBtn").gameObject;
    -- 弃牌盒子
    self.ChipPos = BaccaraCanvas.transform:Find("Bg/desk/Huishou").gameObject;
    -- 发牌盒子
    self.CardsBox = BaccaraCanvas.transform:Find("Bg/CardBox").gameObject;
    -- 装牌对象
    self.ShowPlayerCard = BaccaraCanvas.transform:Find("Bg/SendCard/PlayerCard").gameObject;
    self.ShowBankerCard = BaccaraCanvas.transform:Find("Bg/SendCard/BankerCard").gameObject;
    -- 所有牌
    self.AllPoker = BaccaraCanvas.transform:Find("Poker").gameObject;
    self.AllPoker:SetActive(false);
    -- 显示numImg
    self.ChipNum = BaccaraCanvas.transform:Find("ChipNum").gameObject;
    self.ChipNum:SetActive(false);
    -- 洗牌动画
    self.PlayCardAnimator = BaccaraCanvas.transform:Find("PlayCardAnimator").gameObject;
    C_CHIP_AREA_BTN = {}
    table.insert(C_CHIP_AREA_BTN, #C_CHIP_AREA_BTN + 1, self.PlayerKingBtn);
    table.insert(C_CHIP_AREA_BTN, #C_CHIP_AREA_BTN + 1, self.BankerKingBtn);
    table.insert(C_CHIP_AREA_BTN, #C_CHIP_AREA_BTN + 1, self.PlayerBtn);
    table.insert(C_CHIP_AREA_BTN, #C_CHIP_AREA_BTN + 1, self.BankerBtn);
    table.insert(C_CHIP_AREA_BTN, #C_CHIP_AREA_BTN + 1, self.DeuceBtn);

    -- 显示隐藏下注倒计时
    self.SceneHint = BaccaraCanvas.transform:Find("Bg/SceneHint").gameObject;
    -- 下注倒计时
    self.ChipCountDown = BaccaraCanvas.transform:Find("Bg/SceneHint/ChipCountDown").gameObject;

    self.ChipCountDownTimeNum = BaccaraCanvas.transform:Find("Bg/SceneHint/ChipCountDown/Time").gameObject;
    self.SceneHint:SetActive(false);
    -- 路单
    self.WayBill = BaccaraCanvas.transform:Find("Bg/WayBill").gameObject;
    -- 创建路单Img
    self.WayBillMain = self.WayBill.transform:Find("FirstBg/Main").gameObject;
    self.WayBillMain_Two = self.WayBill.transform:Find("Two/DaluBg/Main").gameObject;
    self.ShouqiWayBillBtn = self.WayBill.transform:Find("Two/Button").gameObject;
    self.ShouqiWayBillBtn:SetActive(false);

    if not (Util.isPc) and not (Util.isEditor) then
        self.WayBill.transform.localPosition = Vector3.New(self.WayBill.transform.localPosition.x, iWayBillPhonePosY0, 0);
    end

    -- 路单值
    self.WayBillImg = BaccaraCanvas.transform:Find("waybillImg").gameObject;
    self.WayBillImg:SetActive(false);
    -- 缩放路单
    self.HideShowWayBillBtn = BaccaraCanvas.transform:Find("Bg/WayBill/HideShowWayBillBtn").gameObject;

    --    -- 添加滑动触发事件
    --    self.R_scroolRect_listerner = Util.AddComponent("EventTriggerListener", self.WayBill.transform:Find("FirstBg").gameObject);
    --    self.R_scroolRect_listerner.onEndDrag = self.onendDrag;
    -- 剩余牌数
    self.PokerNumText = BaccaraCanvas.transform:Find("Bg/desk/FaPai/Text"):GetComponent("Text");
    -- 当前局数
    self.HuishouNumText = BaccaraCanvas.transform:Find("Bg/desk/Huishou/Text"):GetComponent("Text");
    -- 开始下注动画
    self.StartChipAni = BaccaraCanvas.transform:Find("Start").gameObject;
    -- 洗牌动画
    self.ClearPoker = BaccaraCanvas.transform:Find("ClearPoker").gameObject;
    -- 入座信息
    self.Player_other = BaccaraCanvas.transform:Find("Bg/Player_other").gameObject;
    for i = 1, 5 do
        self.LuaBehaviour:AddClick(self.Player_other.transform:GetChild(i - 1):Find("Button").gameObject, self.SitOrUpOnClick);
    end
    self.Player_other:SetActive(false);
    self.StartChipAni:SetActive(false);
    self.ClearPoker:SetActive(false);
    self.PlayCardAnimator:SetActive(false);

    self.TwoWayBillTab = {};
    self.TwoWayTabPos = {};
    bywheelCountTable = {};
    self.SetWayBillValue()
    -- 眯牌效果
    self.MipaiAni = BaccaraCanvas.transform:Find("MiPai").gameObject;
    self.MipaiAni:SetActive(false);
    self.MipaiAni.transform.localPosition = Vector3.New(0, 0, 0);
    self.MipaiAni_MovePoker = self.MipaiAni.transform:Find("Back").gameObject;
    self.MipaiAni_PokerValue = self.MipaiAni.transform:Find("Look/PokerValue").gameObject;
    self.MipaiAni_TishiText = self.MipaiAni.transform:Find("Look/Text").gameObject;
    self.MipaiAni_StopLook = self.MipaiAni.transform:Find("SureBtn").gameObject;
    self.LuaBehaviour:AddClick(self.MipaiAni_StopLook, self.StopLookOnClick);
    self.MipaiAni_NoMipai = BaccaraCanvas.transform:Find("NoMiPai").gameObject;
    self.MipaiAni_NoMipai:SetActive(false);
    self.R_scroolRect_listerner = Util.AddComponent("EventTriggerListener", self.MipaiAni);
    self.R_scroolRect_listerner.onBeginDrag = self.onstartDragF;
    self.R_scroolRect_listerner.onDrag = self.onDragF;
    self.R_scroolRect_listerner.onEndDrag = self.onendDragF;
    -- 默认选中100
    self.ChipHundred:GetComponent("Button").interactable = false;
    self.AddOnClickEvent();

    self.WinLight = BaccaraCanvas.transform:Find("Bg/WinLight").gameObject;
    self.WinLight:SetActive(false);

end
function BaccaraPanel.onstartDragF(obj, evendata)
    if not Util.IsPointerOverGameObject() then
        return
    end
    self.MipaiAni_PokerValue.transform.localPosition = self.MipaiAni_MovePoker.transform.localPosition
end
function BaccaraPanel.onDragF(obj, evendata)
    if not Util.IsPointerOverGameObject() then
        return
    end
    local v3 = self.MipaiAni_MovePoker.transform.localPosition;
    --    if v3.x > 700 or v3.x < -700 then
    --        if v3.x > 0 then v3.x = 700 end
    --        if v3.x < 0 then v3.x = -700 end
    --    end
    --    if v3.y > 400 or v3.y - 400 then
    --        if v3.y > 0 then v3.x = 400 end
    --        if v3.y < 0 then v3.x = -400 end
    --    end
    self.MipaiAni_MovePoker.transform.localPosition = v3;
    self.MipaiAni_PokerValue.transform.localPosition = self.MipaiAni_MovePoker.transform.localPosition

end

function BaccaraPanel.onendDragF(obj, evendata)
    error("拖拽结束");
    if not IssendPokerpos then
        return
    end
    if not Util.IsPointerOverGameObject() then
        return
    end
    self.MipaiAni_PokerValue.transform.localPosition = self.MipaiAni_MovePoker.transform.localPosition
    local lastpos = self.MipaiAni_MovePoker.transform.localPosition
    if math.abs(lastpos.x) < 50 and math.abs(lastpos.y) < 50 then
        self.MipaiAni_NoMipai:SetActive(true);
        IssendPokerpos = false;
        -- error("发送拖拽结束");
        self.MipaiAni_MovePoker.transform.localPosition = Vector3.New(0, 0, 0)
        self.MipaiAni_PokerValue.transform.localPosition = Vector3.New(0, 0, 0)
        self.SendPokerpos(openpokernum, self.MipaiAni_MovePoker.transform.localPosition)
    end
end

function BaccaraPanel.SendPokerpos(num, pos)

    -- SUB_CS_USER_PEEK
    local buffer = ByteBuffer.New()
    buffer:WriteByte(num)
    buffer:WriteLong(pos.x)
    buffer:WriteLong(pos.y)
    buffer:WriteLong(pos.z)
    if (2 == num) then
        --error("send pos x " .. pos.x .. "  y " .. pos.y .. "  z  " .. pos.z) 
    end
    Network.Send(MH.MDM_GF_GAME, BaccaraMH.SUB_CS_USER_PEEK, buffer, gameSocketNumber.GameSocket);
end
-- 1，2，5闲家牌，3,4,6庄家牌
function BaccaraPanel.StopLookOnClick(obj)

    logYellow("==============立即看牌=============");
    BaccaraPanel.PokerMoveEnd();

    --    error("跳过眯牌，翻牌");    
    --    self.MipaiAni_StopLook.transform:GetComponent("Button").interactable = false
    --    if self.MipaiAniuserid == SCPlayerInfo._01dwUser_Id then
    --        if openpokernum == 6 then
    --            self.SendPokerpos(6, Vector3.New(0, 0, 1))
    --        end
    --        if openpokernum == 5 then
    --            self.SendPokerpos(5, Vector3.New(0, 0, 1))
    --        end
    --        if openpokernum == 4 then
    --            IssendPokerpos = false
    --            self.SendPokerpos(255, Vector3.New(0, 0, 1))
    --        end
    --        if openpokernum == 3 then
    --            self.SendPokerpos(3, Vector3.New(0, 0, 1))
    --        end
    --        if openpokernum == 2 then
    --            IssendPokerpos = false
    --            error("第二张跳过---------------------");
    --            self.SendPokerpos(254, Vector3.New(0, 0, 1))          
    --        end
    --        if openpokernum == 1 then
    --            error("第一张跳过---------------------");
    --            self.SendPokerpos(1, Vector3.New(0, 0, 0))
    --        end
    --    end
end

function BaccaraPanel.PokerMoveEnd(iPokerId)

    self.MipaiAni_StopLook.transform:GetComponent("Button").interactable = false
    if self.MipaiAniuserid == SCPlayerInfo._01dwUser_Id then
        if (iPokerId) then
            IssendPokerpos = false
            self.SendPokerpos(iPokerId, Vector3.New(0, 0, 1));
        else
            self.SendPokerpos(openpokernum, Vector3.New(0, 0, 1));
        end
    end

end

function BaccaraPanel.SitOrUpOnClick(obj)
    error("点击入坐 ")
    local num = tonumber(obj.transform.parent.gameObject.name);

    obj.transform:GetComponent('Button').interactable = false;
    for i = 1, #self.PlayerShowInfo do
        if self.PlayerShowInfo[i] == SCPlayerInfo._01dwUser_Id then
            if i ~= num then
                MessageBox.CreatGeneralTipsPanel("你在其他位置已入座");
                --Network.OnException("111111你在其他位置已入座");
                obj.transform:GetComponent('Button').interactable = true;
                return ;
            end
        end
    end
    if self.PlayerShowInfo[num] == 0 then
        error("申请入座")
        local buffer = ByteBuffer.New()
        buffer:WriteByte(num)
        Network.Send(MH.MDM_GF_GAME, BaccaraMH.SUB_CS_USER_SITDOWN, buffer, gameSocketNumber.GameSocket);
    elseif self.PlayerShowInfo[num] == SCPlayerInfo._01dwUser_Id then
        -- 申请起立
        -- SUB_CS_USER_GETUP
        local buffer = ByteBuffer.New()
        buffer:WriteByte(num)
        Network.Send(MH.MDM_GF_GAME, BaccaraMH.SUB_CS_USER_GETUP, buffer, gameSocketNumber.GameSocket);
    else
        -- 点击玩家头像
    end
    obj.transform:GetComponent('Button').interactable = true;
end


-- 添加点击事件
function BaccaraPanel.AddOnClickEvent()
    self.LuaBehaviour:AddClick(self.BankerBtn, self.DeskTopBtnOnClick);
    self.LuaBehaviour:AddClick(self.PlayerBtn, self.DeskTopBtnOnClick);
    self.LuaBehaviour:AddClick(self.BankerKingBtn, self.DeskTopBtnOnClick);
    self.LuaBehaviour:AddClick(self.PlayerKingBtn, self.DeskTopBtnOnClick);
    self.LuaBehaviour:AddClick(self.DeuceBtn, self.DeskTopBtnOnClick);
    -- 绑定点击筹码事件
    self.LuaBehaviour:AddClick(self.ChipHundred, self.SetChipValue);
    self.LuaBehaviour:AddClick(self.ChipThousand, self.SetChipValue);
    self.LuaBehaviour:AddClick(self.ChipTenThousand, self.SetChipValue);
    self.LuaBehaviour:AddClick(self.ChipHundredThousand, self.SetChipValue);
    -- 添加路单点击事件self.BigHideShowWayBillBtn
    self.LuaBehaviour:AddClick(self.HideShowWayBillBtn, self.HideShowWayBillBtnOnClick);
    self.LuaBehaviour:AddClick(self.ShouqiWayBillBtn, self.SetTwoWayBill);
    -- 点击玩家自己详情
    --  luaBehaviour:AddClick(self.MySelfBtn, self.PlayerInfoMethod)
    self.LuaBehaviour:AddClick(self.MyselfHeadImg, self.PlayerInfoMethod)
end

function BaccaraPanel:Update()
end
self.jiangetime = 0;
self.onesencond = 0
function BaccaraPanel:FixedUpdate()
    if GameNextScenName == gameScenName.HALL then
        return
    end
    if BaccaraPanel.ChipTime == nil then
        return
    end
    if BaccaraPanel.jiangetime == nil then
        return
    end
    if BaccaraPanel.onesencond == nil then
        return
    end
    if IssendPokerpos then
        BaccaraPanel.jiangetime = BaccaraPanel.jiangetime + 0.02;
        if BaccaraPanel.jiangetime > 0.5 then
            if BaccaraPanel.ChipTime > 0 then
                local pos = BaccaraPanel.MipaiAni_MovePoker.transform.localPosition
                pos = Vector3.New(math.ceil(pos.x), math.ceil(pos.y), math.ceil(pos.z))
                if (2 == openpokernum) then
                    --error("wai send pos x " .. pos.x .. "  y " .. pos.y .. "  z  " .. pos.z) 
                end
                BaccaraPanel.SendPokerpos(
                        openpokernum, pos)
                BaccaraPanel.jiangetime = 0;
            end
        end
    end

    if BaccaraPanel.ChipTime > 0 then
        BaccaraPanel.onesencond = BaccaraPanel.onesencond + 0.02
        if BaccaraPanel.onesencond > 1 then
            BaccaraPanel.onesencond = 0;
            BaccaraPanel.ChipTime = BaccaraPanel.ChipTime - 1;
            BaccaraPanel.ChipCountDownMethod();
        end
    else

    end

end
-- 初始化场景信息
function BaccaraPanel.SceneInfoMethod(wMain, wSubID, buffer, wSize)
    bGameQuit = false;
    bywheelCountTable = {};
    error("初始化场景信息");

    if (not Util.isPc and not Util.isEditor) then
        GameSetsBtnInfo.SetPlaySuonaPos(0, 345, 0);
    end

    IsWaiteUpdate = true;
    local chipLen = 4;
    ChooseChipTable = {};
    for i = 1, chipLen do
        table.insert(ChooseChipTable, #ChooseChipTable + 1, buffer:ReadUInt32());
    end
    ChooseChipName = "One";
    ChooseChipNum = ChooseChipTable[1];
    self.SetChipVale()
    self.NoClickBtn();
    error("设置庄家信息")
    -- 庄家信息
    BaccaraMH.BankerInfoTable._01wChair = buffer:ReadUInt16();
    BaccaraMH.BankerInfoTable._02Name = buffer:ReadString(128);
    BaccaraMH.BankerInfoTable._03Gold = buffer:ReadUInt32();
    BaccaraMH.BankerInfoTable._04WinOrLose = buffer:ReadUInt64();
    BaccaraMH.BankerInfoTable._05Bankercount = buffer:ReadByte();
    BaccaraMH.BankerInfoTable._06BankerAllCount = buffer:ReadByte();
    if BaccaraMH.BankerInfoTable._02Name == SCPlayerInfo._05wNickName then
        IsMyselfBanker = true;
    end
    local Banklen = buffer:ReadByte();
    error("设置庄家信息完成")
    BankerListInfoTable = {};
    for i = 1, 10 do
        local waitBankerInfo = {};
        table.insert(waitBankerInfo, #waitBankerInfo + 1, buffer:ReadUInt16());
        table.insert(waitBankerInfo, #waitBankerInfo + 1, buffer:ReadUInt32());
        table.insert(waitBankerInfo, #waitBankerInfo + 1, buffer:ReadString(128));
        table.insert(BankerListInfoTable, #BankerListInfoTable + 1, waitBankerInfo);
    end
    local bywheelCount = buffer:ReadByte();
    logYellow("bywheelCount = " .. bywheelCount);
    for i = 1, 60 do
        local wheeldata = {}
        table.insert(wheeldata, #wheeldata + 1, buffer:ReadByte());
        table.insert(wheeldata, #wheeldata + 1, buffer:ReadByte());
        local data = {};
        for i = 1, 5 do
            table.insert(data, #data + 1, buffer:ReadByte());
        end
        if bywheelCount >= i then
            table.insert(wheeldata, #wheeldata + 1, data);
            table.insert(bywheelCountTable, #bywheelCountTable + 1, wheeldata);
        end
    end

    local playwinnum = buffer:ReadByte();
    local bankerwinnum = buffer:ReadByte();
    local deucnwinnum = buffer:ReadByte();
    GameState = buffer:ReadByte();
    error("当前游戏状态:" .. GameState)
    limitMaxChipTable = {};
    -- 所有下注筹码数
    AllChipValueTable = {};
    -- 自己下注筹码数
    MyselfChipValueTable = {}
    -- 改变已创建的值
    CreatingAllChip = { 0, 0, 0, 0, 0 };
    CreatingMyselfChip = { 0, 0, 0, 0, 0 };

    for i = 1, #BaccaraMH.C_CHIP_AREA_NAME do
        table.insert(limitMaxChipTable, #limitMaxChipTable + 1, buffer:ReadUInt32())
    end
    logTable(limitMaxChipTable);
    for i = 1, #BaccaraMH.C_CHIP_AREA_NAME do
        table.insert(AllChipValueTable, #AllChipValueTable + 1, buffer:ReadUInt32())
    end
    for i = 1, #BaccaraMH.C_CHIP_AREA_NAME do
        table.insert(MyselfChipValueTable, #MyselfChipValueTable + 1, buffer:ReadUInt32())
    end

    self.SendCardBg.transform.localPosition = Vector3.New(0, 3000, 0)

    self.SendCardBg:SetActive(false);
    self.BetAreaMethod(true);
    -- 闲家点数
    playerPoint = 0;
    -- 庄家当前点数
    bankerPoint = 0;
    -- error("初始化手牌");
    for i = 1, BaccaraMH.D_MAX_HANDER_POKER_COUNT do
        m_byPlayerPokerData[i] = buffer:ReadByte();
        -- error("手牌数据:"..m_byPlayerPokerData[i]);
        error(Util.OutPutPokerValue(m_byPlayerPokerData[i]));
        local pokerpoint = (string.split(Util.OutPutPokerValue(m_byPlayerPokerData[i]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byPlayerPokerData[i]), ",")[2]);
        -- local pokerpoint =(self.Ten2tTwo(m_byPlayerPokerData[i])[1]) * 13 +(self.Ten2tTwo(m_byPlayerPokerData[i])[2]);
        -- error("牌位置=======================" .. pokerpoint);
        if pokerpoint > 0 and pokerpoint < 53 then
            local prefeb = self.CardsBox.transform:GetChild(0).gameObject;
            local go = newobject(prefeb);
            go:SetActive(true);
            go.transform:SetParent(self.ShowPlayerCard.transform);
            go.transform.localScale = Vector3.New(0.5, 0.5, 0.5);
            go:GetComponent("RectTransform").rotation = Vector3.New(0, 0, 0);
            go.transform.localPosition = Vector3.New(-poketw + (i - 1) * poketw, 0, 0);
            if GameState > 4 then

                go:GetComponent("Image").sprite = self.AllPoker.transform:GetChild(pokerpoint - 1):GetComponent("Image").sprite;
            end
            -- error("闲家创建牌");
        end

    end

    for i = 1, BaccaraMH.D_MAX_HANDER_POKER_COUNT do
        m_byBankerPokerData[i] = buffer:ReadByte();
        local pokerpoint = (string.split(Util.OutPutPokerValue(m_byBankerPokerData[i]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byBankerPokerData[i]), ",")[2])
        -- local pokerpoint =(self.Ten2tTwo(m_byBankerPokerData[i])[1]) * 13 +(self.Ten2tTwo(m_byBankerPokerData[i])[2]);
        if pokerpoint > 0 and pokerpoint < 53 then
            local prefeb = self.CardsBox.transform:GetChild(0).gameObject;
            local go = newobject(prefeb);
            go:SetActive(true);
            go.transform:SetParent(self.ShowBankerCard.transform);
            go.transform.localScale = Vector3.New(0.5, 0.5, 0.5);
            go:GetComponent("RectTransform").rotation = Vector3.New(0, 0, 0);
            go.transform.localPosition = Vector3.New(-poketw + (i - 1) * poketw, 0, 0);
            if GameState > 5 then
                go:GetComponent("Image").sprite = self.AllPoker.transform:GetChild(pokerpoint - 1):GetComponent("Image").sprite;
            else
            end
        end

    end
    CardCount = buffer:ReadUInt16();
    self.PokerNumText.text = "cards left：" .. CardCount
    -- error("剩余牌数：" .. CardCount)
    OldTime = buffer:ReadUInt32();
    -- 闲家点数
    playerPoint = buffer:ReadByte();
    if playerPoint >= 10 then
        playerPoint = playerPoint - 10
    end
    -- 庄家点数
    bankerPoint = buffer:ReadByte();
    if bankerPoint >= 10 then
        bankerPoint = bankerPoint - 10
    end
    -- error("游戏状态剩余时间：" .. OldTime);
    -- 显示庄家点数
    self.BankerCardValue.transform:GetComponent('Image').sprite = self.ChipNum.transform:Find("One"):GetChild(bankerPoint).gameObject:GetComponent('Image').sprite;
    if GameState > 5 then
        self.BankerCardPoint:SetActive(true);
        self.PlayerCardPoint:SetActive(true);
    else
        self.BankerCardPoint:SetActive(false);
        self.PlayerCardPoint:SetActive(false);
    end
    -- 显示闲家点数
    self.PlayerCardValue.transform:GetComponent('Image').sprite = self.ChipNum.transform:Find("One"):GetChild(playerPoint).gameObject:GetComponent('Image').sprite;
    -- 五个坐下一个旁观
    self.PlayerShowInfo = {};
    for i = 1, 6 do
        table.insert(self.PlayerShowInfo, #self.PlayerShowInfo + 1, buffer:ReadUInt32())
    end
    self.SitTiaojian = buffer:ReadUInt32();
    self.HuishouNumText.text =  buffer:ReadUInt32() .. " rounds " .. buffer:ReadUInt32() .. " times"
    local iMiChipLimit = buffer:ReadUInt32(); --咪牌筹码下限
    iMiChipLimit = iMiChipLimit / 10000;
    logYellow("咪牌下限值： " .. iMiChipLimit);
    local comText = self.SceneHint.transform:Find("TextTitle"):GetComponent("Text");
    if (iMiChipLimit > 0) then
        comText.text = comText.text .. iMiChipLimit .. "10,000 to pass";
    else
        comText.text = "";
    end
    self.SetOtherPlayer();
    self.InitializingScene();
    error("准备设置路单")
    self.SetWayBillValue();
    error("初始化完成");
end
function BaccaraPanel.SetOtherPlayer()
    for i = 1, 5 do
        --self.Player_other:SetActive(true);
        local go = self.Player_other.transform:GetChild(i - 1).gameObject;
        local traHead = go.transform:Find("Head");
        if self.PlayerShowInfo[i] == 0 then
            -- 可以入座
            go.transform:Find("My").gameObject:SetActive(false);
            traHead.gameObject:SetActive(false);
            go.transform:Find("Button/Yes").gameObject:SetActive(true);
            go.transform:Find("Button/No").gameObject:SetActive(false);
            traHead:Find("Gold/Text"):GetComponent("Text").text = " ";
            go.transform:Find("Button"):GetComponent('Button').interactable = true;
            if toInt64(self.SitTiaojian) > toInt64(BaccaraMH.mySelfInfo.gold) then
                go.transform:Find("Button/Yes").gameObject:SetActive(false);
                go.transform:Find("Button/No").gameObject:SetActive(true);
                go.transform:Find("Button"):GetComponent('Button').interactable = false;
            end

            if (self.objSignX) then
                if (not IsNil(self.objSignX)) then
                    self.objSignX:SetActive(false);
                    self.objSignX = nil;
                end
            end
            if (self.objSignZ) then
                if (not IsNil(self.objSignZ)) then
                    self.objSignZ:SetActive(false);
                    self.objSignZ = nil;
                end
            end

        else
            if self.PlayerShowInfo[i] == SCPlayerInfo._01dwUser_Id then
                go.transform:Find("My").gameObject:SetActive(true);
            else
                go.transform:Find("My").gameObject:SetActive(false);
            end
            for k = 1, #AllPlayerInfo do
                if self.PlayerShowInfo[i] == AllPlayerInfo[k]._1dwUser_Id then
                    traHead.gameObject:SetActive(true);
                    go.transform:Find("Button/Yes").gameObject:SetActive(false);
                    go.transform:Find("Button/No").gameObject:SetActive(false);
                    go.transform:Find("Button"):GetComponent('Button').interactable = true;
                    traHead:Find("ImageNameBox/TextName"):GetComponent("Text").text = AllPlayerInfo[k]._2szNickName;
                    traHead:Find("Gold/Text"):GetComponent("Text").text = tostring(AllPlayerInfo[k]._7wGold);
                    if AllPlayerInfo[k]._4bCustomHeader == 0 or AllPlayerInfo[k]._4bCustomHeader == 2 then
                        local Url = SCSystemInfo._2wWebServerAddress .. "/" .. SCSystemInfo._4wHeaderDir .. "/0" .. AllPlayerInfo[k]._3bySex .. ".png";
                        local headstr = AllPlayerInfo[k]._3bySex;
                        -- error("Url=========================="..Url);
                        UpdateFile.downHead(Url, headstr, nil, go.transform:Find("Head").gameObject);
                    else
                        local Url = SCSystemInfo._2wWebServerAddress .. "/" .. SCSystemInfo._4wHeaderDir .. "/" .. AllPlayerInfo[k]._1dwUser_Id .. "." .. AllPlayerInfo[k]._5szHeaderExtensionName;
                        --  error("Url=======111111111111111111111==================="..Url);
                        local headstr = AllPlayerInfo[k]._1dwUser_Id .. "." .. AllPlayerInfo[k]._5szHeaderExtensionName;
                        UpdateFile.downHead(Url, headstr, nil, go.transform:Find("Head").gameObject);
                    end
                end
            end
        end
    end
end

function BaccaraPanel.UpdateScore()

    for i = 1, 5 do
        for k = 1, #AllPlayerInfo do
            if self.PlayerShowInfo[i] == AllPlayerInfo[k]._1dwUser_Id then
                local go = self.Player_other.transform:GetChild(i - 1).gameObject;
                go.transform:Find("Head/Gold/Text"):GetComponent("Text").text = tostring(AllPlayerInfo[k]._7wGold);
            end
        end
    end
end


-- Home键回来等一秒钟处理消息
function BaccaraPanel.WaitBackGame(wMain, wSubID, buffer, wSize)
    coroutine.wait(1);
    IsBackGame = false;
    self.GameInfoMethod(wMain, wSubID, buffer, wSize);
end
-- 游戏消息
function BaccaraPanel.GameInfoMethod(wMain, wSubID, buffer, wSize)
    local id = string.gsub(wSubID, wMain, "");
    id = tonumber(id);
    -- error("有新消息:"..id);
    if id == BaccaraMH.SUB_SC_BANKER_INFO then
        error("庄家信息");
    elseif id == BaccaraMH.SUB_SC_REQUEST_BANKER then
        error("申请上庄信息");
    elseif id == BaccaraMH.SUB_SC_LOSE_BANKER then
        error("申请下庄信息");
    elseif id == BaccaraMH.SUB_SC_SHUFFLE_POKER then
        self.MyselfAddGold:SetActive(false);
        self.MyselfAddGold:GetComponent("Text").text = " "
        error("洗牌消息");
        self.BankerCardPoint:SetActive(false);
        self.PlayerCardPoint:SetActive(false);
        for i = 0, self.ShowPlayerCard.transform.childCount - 1 do
            self.ShowPlayerCard.transform:GetChild(i).gameObject:SetActive(false);
        end
        for i = 0, self.ShowBankerCard.transform.childCount - 1 do
            self.ShowBankerCard.transform:GetChild(i).gameObject:SetActive(false);
        end
        CardCount = buffer:ReadUInt16();
        self.PokerNumText.text = "cards left:" .. CardCount
        GameState = BaccaraMH.GAME_STATE_SHUFFLE_POKER;
        self.ShowScenes();
        error("剩余牌数1：" .. CardCount)
    elseif id == BaccaraMH.SUB_SC_BEGIN_CHIP then
        -- error("开始下注");
        self.ChipBtn.transform.localPosition = Vector3.New(0, -311, 0)
        self.MyselfAddGold:SetActive(false);
        self.MyselfAddGold:GetComponent("Text").text = " "
        StartlimitMaxChipTable = { 0, 0, 0, 0, 0 };
        IsNumValue = true;

        self.HuishouNumText.text =buffer:ReadUInt32() .. " rounds " .. buffer:ReadUInt32() .. " times"
        self.BankerCardPoint:SetActive(false);
        self.PlayerCardPoint:SetActive(false);
        for i = 0, self.ShowPlayerCard.transform.childCount - 1 do
            self.ShowPlayerCard.transform:GetChild(i).gameObject:SetActive(false);
        end
        for i = 0, self.ShowBankerCard.transform.childCount - 1 do
            self.ShowBankerCard.transform:GetChild(i).gameObject:SetActive(false);
        end
        self.SendCardBg.transform.localPosition = Vector3.New(0, 3000, 0)
        self.SendCardBg:SetActive(false);
        for i = 1, #m_byBankerPokerData do
            m_byPlayerPokerData[i] = 0;
            m_byBankerPokerData[i] = 0;
        end
        GameState = BaccaraMH.GAME_STATE_CHIP;
        self.ShowScenes();
        IsWaiteUpdate = true;
        coroutine.start(self.WaitUpdate);
        -- error("开始下注完成");
        self.isChipsOn = false;
    elseif id == BaccaraMH.SUB_SC_UPDATE_CHIP_VALUE then
        error("增加下注");
        limitMaxChipTable = {};
        -- 所有下注筹码数
        AllChipValueTable = {};
        --    -- 自己下注筹码数
        MyselfChipValueTable = {}
        for i = 1, #BaccaraMH.C_CHIP_AREA_NAME do
            table.insert(limitMaxChipTable, #limitMaxChipTable + 1, buffer:ReadUInt32())
        end
        for i = 1, #BaccaraMH.C_CHIP_AREA_NAME do
            table.insert(AllChipValueTable, #AllChipValueTable + 1, buffer:ReadUInt32())
        end
        logTable(AllChipValueTable);
        for i = 1, #BaccaraMH.C_CHIP_AREA_NAME do
            table.insert(MyselfChipValueTable, #MyselfChipValueTable + 1, buffer:ReadUInt32());
        end
        -- 初始化下注列表信息
        for i = 1, #BaccaraMH.C_CHIP_AREA_NAME do
            if CreatingMyselfChip[i] < MyselfChipValueTable[i] then
                self.BetAreaMethod(false);
            end
        end
        if IsWaiteUpdate then
            IsWaiteUpdate = false;
            if not (IsNil(BaccaraMusic)) then
                local musicchip = BaccaraMusic.transform:Find("Snd_Chip"):GetComponent('AudioSource').clip
                MusicManager:PlayX(musicchip);
            end
            self.BetAreaMethod(false);
        end
        self.isChipsOn = false;        -- error("增加下注完成");
    elseif id == BaccaraMH.SUB_SC_PLAYER_CHIP then
        -- 座位玩家下注
        local playerid = buffer:ReadUInt32();
        local chipareanum = buffer:ReadByte();
        local chipvalue = buffer:ReadUInt32();
        error("座位玩家下注:" .. chipareanum)
        error("座位玩家ID:" .. playerid)
        if playerid == SCPlayerInfo_SCPlayerInfo._01dwUser_Id then
            return
        end
        self.Sit_OtherPlayerChip(playerid, chipvalue, chipareanum + 1)
        self.isChipsOn = false;
    elseif id == BaccaraMH.SUB_SC_STOP_CHIP then
        -- error("停止下注");
        local iPlayerUserId = buffer:ReadUInt32();
        local iBankerUserId = buffer:ReadUInt32();

        for i = 1, BaccaraMH.D_SIT_PLAYER_COUNT do
            if (iPlayerUserId > 0 and self.PlayerShowInfo[i] == iPlayerUserId) then
                self.objSignX = self.Player_other.transform:GetChild(i - 1):Find("ZOrX/ImageX").gameObject; --闲家标志
                self.objSignX:SetActive(true);
            end
            if (iBankerUserId > 0 and self.PlayerShowInfo[i] == iBankerUserId) then
                self.objSignZ = self.Player_other.transform:GetChild(i - 1):Find("ZOrX/ImageZ").gameObject; --庄家标志
                self.objSignZ:SetActive(true);
            end
        end

        self.ChipBtn.transform.localPosition = Vector3.New(0, -500, 0)
        GameState = BaccaraMH.GAME_STATE_STOP_CHIP;
        for i = 1, #MyselfChipValueTable do
            if MyselfChipValueTable[i] > 0 then
                ReChipTable[i] = MyselfChipValueTable[i]
            end
        end
        self.SceneHint:SetActive(false);
        -- self.SceneHint.transform:Find("Image/Image"):GetComponent('Image').fillAmount = 1;
        -- if num > 0 then ReChipTable = MyselfChipValueTable; end
        self.ShowScenes();

        self.isChipsOn = false;
        -- error("停止下注完成");
    elseif id == BaccaraMH.SUB_SC_CHIP_FAIL then
        error("下注失败");
        -- local str = buffer:ReadString(wSize);
        local index = buffer:ReadByte();
        local str = "";
        if index == 0 then
            str = "下注超过区域限制";
        elseif index == 1 then
            str = "Insufficient gold coins";
        end
        self.isChipsOn = false;
        MessageBox.CreatGeneralTipsPanel(str);
    elseif id == BaccaraMH.SUB_SC_SEND_POKER then
        -- error("发牌");
        GameState = BaccaraMH.GAME_STATE_SEND_POKER;
        for i = 1, BaccaraMH.D_HEADER_POKER_COUNT do
            m_byPlayerPokerData[i] = buffer:ReadByte();
        end
        for i = 1, BaccaraMH.D_HEADER_POKER_COUNT do
            m_byBankerPokerData[i] = buffer:ReadByte();
        end
        -- 闲家点数
        playerPoint = buffer:ReadByte();
        -- 庄家点数
        bankerPoint = buffer:ReadByte();
        -- 剩余牌数
        CardCount = buffer:ReadUInt16();
        self.PokerNumText.text = "cards left：" .. CardCount
        self.ShowScenes();
        error("发牌后,剩余牌数：" .. CardCount)
        -- error("发牌完成");
    elseif id == BaccaraMH.SUB_SC_PLAYER_ADD_POKER then
        -- error("闲家补牌");
        if not (IsNil(BaccaraMusic)) then
            local musicchip = BaccaraMusic.transform:Find("Baccarat_xian_bu"):GetComponent('AudioSource').clip
            MusicManager:PlayX(musicchip);
        end
        self.CheckDealMethod(true, 1)
        self.CheckDealMethod(true, 2)
        IssendPokerpos = false
        GameState = BaccaraMH.GAME_STATE_PLAYER_ADD_POKER;
        m_byPlayerPokerData[BaccaraMH.D_MAX_HANDER_POKER_COUNT] = buffer:ReadByte();
        -- 闲家点数
        playerPoint = buffer:ReadByte();
        local data = Util.OutPutPokerValue(m_byPlayerPokerData[BaccaraMH.D_MAX_HANDER_POKER_COUNT]);
        -- 剩余牌数
        CardCount = buffer:ReadUInt16();
        self.PokerNumText.text = "cards left：" .. CardCount
        self.ShowScenes();
        -- error("闲家补牌结束");
    elseif id == BaccaraMH.SUB_SC_BANKER_ADD_POKER then
        -- error("庄家补牌");
        --        if not(IsNil(BaccaraMusic)) then
        --            local musicchip = BaccaraMusic.transform:Find("Baccarat_zhuang_bu"):GetComponent('AudioSource').clip
        --            MusicManager:PlayX(musicchip);
        --        end
        coroutine.start(BaccaraPanel.WaitPlayZjAddPokerMusic);

        self.CheckDealMethod(true, 1)
        self.CheckDealMethod(true, 2)
        IssendPokerpos = false
        GameState = BaccaraMH.GAME_STATE_BANKER_ADD_POKER;
        m_byBankerPokerData[BaccaraMH.D_MAX_HANDER_POKER_COUNT] = buffer:ReadByte();
        -- 庄家点数
        bankerPoint = buffer:ReadByte();
        local data = Util.OutPutPokerValue(m_byBankerPokerData[BaccaraMH.D_MAX_HANDER_POKER_COUNT]);
        -- local data = self.Ten2tTwo(m_byBankerPokerData[BaccaraMH.D_MAX_HANDER_POKER_COUNT]);
        -- 剩余牌数
        CardCount = buffer:ReadUInt16();
        self.PokerNumText.text = "cards left：" .. CardCount
        self.ShowScenes();
        -- error(" 庄家补牌结束")
    elseif id == BaccaraMH.SUB_SC_GAME_OVER then
        error("游戏结束");
        self.CheckDealMethod(true, 1)
        self.CheckDealMethod(true, 2)
        IssendPokerpos = false
        IsNumValue = true;
        CHipAreaNum = { 0, 0, 0, 0, 0 };
        StartlimitMaxChipTable = { 0, 0, 0, 0, 0 };
        GameState = BaccaraMH.GAME_STATE_GAME_OVER;
        local wheeldata = {}
        table.insert(wheeldata, #wheeldata + 1, playerPoint);
        table.insert(wheeldata, #wheeldata + 1, bankerPoint);
        local data = {};
        for i = 1, 5 do
            table.insert(data, #data + 1, buffer:ReadByte());
        end
        logTable(data);
        table.insert(wheeldata, #wheeldata + 1, data);
        showWinLoseValue = 0;
        table.insert(bywheelCountTable, #bywheelCountTable + 1, wheeldata);
        GameOverInfoTable = {};
        for i = 1, BaccaraMH.D_CHIP_ARAE_COUNT do
            table.insert(GameOverInfoTable, #GameOverInfoTable + 1, buffer:ReadInt32())
        end
        logTable(GameOverInfoTable);
        for i = 1, BaccaraMH.D_CHIP_ARAE_COUNT do
            ChipWinOrLoseState[i] = buffer:ReadByte();
        end
        logTable(ChipWinOrLoseState);
        self.ShowScenes();
        error("游戏结束完成");
    elseif id == BaccaraMH.SUB_SC_TOTAL_WIN_LOSE_SCORE then
        -- 玩家成绩
        -- error("玩家成绩");
        self.ChangeScoreMethod(buffer, wSize);
    elseif id == BaccaraMH.SUB_SC_USER_SETDOWN then
        error("玩家坐下");
        -- UINT UserID;
        local userid = buffer:ReadUInt32();
        -- BYTE ChairID;
        local chairid = buffer:ReadByte();
        self.PlayerShowInfo[chairid] = userid;
        self.SetOtherPlayer()
    elseif id == BaccaraMH.SUB_SC_USER_GETUP then
        error("玩家起立");
        -- UINT UserID;
        local userid = buffer:ReadUInt32();
        -- BYTE ChairID;
        local chairid = buffer:ReadByte();
        self.PlayerShowInfo[chairid] = 0;
        self.SetOtherPlayer()
    elseif id == BaccaraMH.SUB_SC_USER_PEEKPOKER_X then
        -- 玩家眯牌
        -- error("玩家眯牌");
        GameState = BaccaraMH.GAME_STATE_PEEKPOKER_X;
        local userid = buffer:ReadUInt32();
        openpokernum = 1;
        self.MipaiAniuserid = userid
        self.MipaiAni_MovePoker.transform.localPosition = Vector3.New(220, 223, 0)
        self.MipaiAni_PokerValue.transform.localPosition = Vector3.New(220, 223, 0)
        self.MipaiAni_PokerValue:GetComponent("Image").sprite = self.AllPoker.transform:GetChild((string.split(Util.OutPutPokerValue(m_byPlayerPokerData[1]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byPlayerPokerData[1]), ",")[2]) - 1):GetComponent("Image").sprite;
        DealCardParset = self.ShowPlayerCard;
        SendPoker = {};
        for i = 1, BaccaraMH.D_HEADER_POKER_COUNT do
            table.insert(SendPoker, #SendPoker + 1, (string.split(Util.OutPutPokerValue(m_byPlayerPokerData[i]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byPlayerPokerData[i]), ",")[2]));

        end
        if userid == 0 then
            logYellow("000000000000000");
            coroutine.start(self.DealOverCallBack, true)
        else
            logYellow("1111111111111111");
            if not (IsNil(BaccaraMusic)) then
                local musicchip = BaccaraMusic.transform:Find("Baccarat_xian_mi"):GetComponent('AudioSource').clip
                MusicManager:PlayX(musicchip);
            end
            self.MiPaiStart()
        end
    elseif id == BaccaraMH.SUB_SC_USER_PEEKPOKER_Z then
        -- 庄家眯牌
        -- error("庄家眯牌");
        self.CheckDealMethod(true, 1)
        GameState = BaccaraMH.GAME_STATE_PEEKPOKER_Z;
        openpokernum = 3;
        self.MipaiAni_MovePoker.transform.localPosition = Vector3.New(220, 223, 0)
        self.MipaiAni_PokerValue.transform.localPosition = Vector3.New(220, 223, 0)
        self.MipaiAni_PokerValue:GetComponent("Image").sprite = self.AllPoker.transform:GetChild((string.split(Util.OutPutPokerValue(m_byBankerPokerData[1]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byBankerPokerData[1]), ",")[2]) - 1):GetComponent("Image").sprite;
        local userid = buffer:ReadUInt32();
        DealCardParset = self.ShowBankerCard;
        SendPoker = {};
        for i = 1, BaccaraMH.D_HEADER_POKER_COUNT do
            table.insert(SendPoker, #SendPoker + 1, (string.split(Util.OutPutPokerValue(m_byBankerPokerData[i]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byBankerPokerData[i]), ",")[2]));

        end
        self.MipaiAniuserid = userid
        if userid == 0 then
            coroutine.start(self.DealOverCallBack, false)
        else
            if not (IsNil(BaccaraMusic)) then
                local musicchip = BaccaraMusic.transform:Find("Baccarat_zhuang_mi"):GetComponent('AudioSource').clip
                MusicManager:PlayX(musicchip);
            end
            self.MiPaiStart()
        end
    elseif id == BaccaraMH.SUB_SC_USER_PEEKPOKER_BOATCAST then
        -- error("玩家眯牌广播");
        self.ScMiPaiPos(buffer)
    elseif id == BaccaraMH.SUB_SC_USER_PEEKADDPOKER_Z then
        -- 庄家补牌眯牌
        -- error("庄家补牌眯牌");
        self.MipaiAni_MovePoker.transform.localPosition = Vector3.New(220, 223, 0)
        self.MipaiAni_PokerValue.transform.localPosition = Vector3.New(220, 223, 0)
        openpokernum = 6;
        local userid = buffer:ReadUInt32();
        self.MipaiAniuserid = userid
        DealCardParset = self.ShowBankerCard;
        SendPoker = {};
        table.insert(SendPoker, #SendPoker + 1, (string.split(Util.OutPutPokerValue(m_byBankerPokerData[3]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byBankerPokerData[3]), ",")[2]));

        self.MipaiAni_PokerValue:GetComponent("Image").sprite = self.AllPoker.transform:GetChild(SendPoker[1] - 1):GetComponent("Image").sprite;
        GameState = BaccaraMH.GAME_STATE_PEEKADDPOKER_Z;
        if userid == 0 then
            coroutine.start(self.DealOverCallBack, false)
        else
            self.MiPaiStart()
        end
    elseif id == BaccaraMH.SUB_SC_USER_PEEKADDPOKER_X then
        -- error("闲家补牌眯牌");
        self.MipaiAni_MovePoker.transform.localPosition = Vector3.New(220, 223, 0)
        self.MipaiAni_PokerValue.transform.localPosition = Vector3.New(220, 223, 0)
        self.MipaiAni_PokerValue:GetComponent("Image").sprite = self.AllPoker.transform:GetChild((string.split(Util.OutPutPokerValue(m_byPlayerPokerData[3]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byPlayerPokerData[3]), ",")[2]) - 1):GetComponent("Image").sprite;
        GameState = BaccaraMH.GAME_STATE_PEEKADDPOKER_X;
        openpokernum = 5;
        local userid = buffer:ReadUInt32();
        DealCardParset = self.ShowPlayerCard;
        SendPoker = {};
        table.insert(SendPoker, #SendPoker + 1, (string.split(Util.OutPutPokerValue(m_byPlayerPokerData[3]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byPlayerPokerData[3]), ",")[2]));

        self.MipaiAni_PokerValue:GetComponent("Image").sprite = self.AllPoker.transform:GetChild(SendPoker[1] - 1):GetComponent("Image").sprite;
        self.MipaiAniuserid = userid
        if userid == 0 then
            coroutine.start(self.DealOverCallBack, true)
        else
            self.MiPaiStart()
        end
    elseif id == BaccaraMH.SUB_SC_USER_PEEKADDPOKER_BOATCAST then
        -- 补牌位置广播
        error("玩家眯加广播")
        self.ScMiPaiPos(buffer)
    else
    end
end

--延迟播放庄家补牌音效
function BaccaraPanel.WaitPlayZjAddPokerMusic()

    coroutine.wait(0.5);

    if (BaccaraMusic) then
        if not (IsNil(BaccaraMusic)) then
            local musicchip = BaccaraMusic.transform:Find("Baccarat_zhuang_bu"):GetComponent('AudioSource').clip
            MusicManager:PlayX(musicchip);
        end
    end

end

function BaccaraPanel.MiPaiStart()
    if self.MipaiAniuserid == SCPlayerInfo._01dwUser_Id then
        self.MipaiAni_NoMipai:SetActive(false);
        self.MipaiAni_StopLook:SetActive(true);
        self.MipaiAni_TishiText:SetActive(true);
        self.MipaiAni_MovePoker:SetActive(false);
        self.MipaiAni:SetActive(true);
        IssendPokerpos = true;

        self.MipaiAni_StopLook.transform:GetComponent("Button").interactable = true
    else
        self.MipaiAni_NoMipai:SetActive(true);
        self.MipaiAni_StopLook:SetActive(false);
        self.MipaiAni_TishiText:SetActive(false);
        self.MipaiAni_MovePoker:SetActive(false);
        self.MipaiAni:SetActive(true);
        IssendPokerpos = false;
    end
    self.ChipTime = BaccaraMH.TIMER_PLAYER_ADD_POKER;
    -- self.SceneHint.transform:Find("Image/Image"):GetComponent('Image'):GetComponent('Image').fillAmount =(self.ChipTime / 15);
    self.SceneHint:SetActive(true);
    self.SceneHint.transform:Find("TextTitle").gameObject:SetActive(false);
    self.ChipCountDownTimeNum.transform:GetChild(0):GetComponent('Text').text = self.ChipTime
    -- coroutine.start(self.JianTiming);
    self.MipaiAni_MovePoker.transform.localPosition = Vector3.New(220, 223, 0)
    self.MipaiAni_PokerValue.transform.localPosition = Vector3.New(220, 223, 0)
    if openpokernum == 1 then
        local tweener = self.ShowPlayerCard.transform:GetChild(0):DOMove(self.MipaiAni_MovePoker.transform.position, 0.5, false);
        tweener:SetEase(DG.Tweening.Ease.Linear);
        tweener:OnKill(function()
            self.MipaiAni_MovePoker:SetActive(true);
            self.ShowPlayerCard.transform:GetChild(0).gameObject:SetActive(false);
        end);
    end ;
    if openpokernum == 2 then
        local tweener = self.ShowPlayerCard.transform:GetChild(1):DOMove(self.MipaiAni_MovePoker.transform.position, 0.5, false);
        tweener:SetEase(DG.Tweening.Ease.Linear);
        tweener:OnKill(function()
            self.MipaiAni_MovePoker:SetActive(true);
            self.ShowPlayerCard.transform:GetChild(1).gameObject:SetActive(false);
        end);
    end ;
    if openpokernum == 3 then

        self.CheckDealMethod(true, 1)
        local tweener = self.ShowBankerCard.transform:GetChild(0):DOMove(self.MipaiAni_MovePoker.transform.position, 0.5, false);
        tweener:SetEase(DG.Tweening.Ease.Linear);
        tweener:OnKill(function()
            self.MipaiAni_MovePoker:SetActive(true);
            self.ShowBankerCard.transform:GetChild(0).gameObject:SetActive(false);
        end);
    end ;
    if openpokernum == 4 then
        local tweener = self.ShowBankerCard.transform:GetChild(1):DOMove(self.MipaiAni_MovePoker.transform.position, 0.5, false);
        tweener:SetEase(DG.Tweening.Ease.Linear);
        tweener:OnKill(function()
            self.MipaiAni_MovePoker:SetActive(true);
            self.ShowBankerCard.transform:GetChild(1).gameObject:SetActive(false);
        end);
    end ;
    if openpokernum == 5 then
        -- 闲家补牌眯牌
        self.CheckDealMethod(true, 2)
        if self.ShowPlayerCard.transform.childCount == 2 then
            return
        end
        self.MipaiAni:SetActive(true);
        local tweener = self.ShowPlayerCard.transform:GetChild(2):DOMove(self.MipaiAni_MovePoker.transform.position, 0.5, false);
        tweener:SetEase(DG.Tweening.Ease.Linear);
        tweener:OnKill(function()
            self.MipaiAni_MovePoker:SetActive(true);
            self.ShowPlayerCard.transform:GetChild(2).gameObject:SetActive(false);
        end);
    end ;
    if openpokernum == 6 then
        -- 庄家补牌眯牌
        self.CheckDealMethod(true, 1)
        if self.ShowBankerCard.transform.childCount == 2 then
            return
        end
        local tweener = self.ShowBankerCard.transform:GetChild(2):DOMove(self.MipaiAni_MovePoker.transform.position, 0.5, false);
        tweener:SetEase(DG.Tweening.Ease.Linear);
        tweener:OnKill(function()
            self.MipaiAni_MovePoker:SetActive(true);
            self.ShowBankerCard.transform:GetChild(2).gameObject:SetActive(false);
        end);
    end ;
end
local isfiirt = 0;
function BaccaraPanel.ScMiPaiPos(buffer)
    -- if not IssendPokerpos then return end
    local pokernum = buffer:ReadByte();
    local posx = CSBufferToInt64(buffer); --buffer:ReadLong();
    local posy = CSBufferToInt64(buffer);
    local posz = CSBufferToInt64(buffer);
    error("pokernum:" .. pokernum);
    --    error("posx=====================" .. posx .. "," .. posy .. "," .. posz);
    --	logYellow("=========================openpokernum = " .. openpokernum);
    --    logYellow("posx=====================" .. posx .. "," .. posy .. "," .. posz);
    if pokernum < openpokernum then
        return
    end

    if self.MipaiAniuserid == SCPlayerInfo._01dwUser_Id then

        -- self.MipaiAni_MovePoker.transform.localPosition = Vector3.New(posx, posy, 0)
        -- self.MipaiAni_PokerValue.transform.localPosition = Vector3.New(posx, posy, 0)
        if posx == 0 and posy == 0 then
            self.MipaiAni_MovePoker.transform:DOLocalMove(Vector3.New(posx, posy, 0), 0.3, false):SetEase(DG.Tweening.Ease.Linear);
            self.MipaiAni_PokerValue.transform:DOLocalMove(Vector3.New(posx, posy, 0), 0.3, false):SetEase(DG.Tweening.Ease.Linear);
        end
    else
        -- if posz == 0 then
        local postime = (math.random(5, 11)) * 0.1;
        if posx == 0 and posy == 0 then
            postime = 0.3
        end ;
        self.MipaiAni_MovePoker.transform:DOLocalMove(Vector3.New(posx, posy, 0), postime, false):SetEase(DG.Tweening.Ease.Linear);
        self.MipaiAni_PokerValue.transform:DOLocalMove(Vector3.New(posx, posy, 0), postime, false):SetEase(DG.Tweening.Ease.Linear);
        -- end
    end
    -- 坐标
    if isfiirt == 0 then
        isfiirt = 1;
        if pokernum < 3 then
            self.MipaiAni_PokerValue:GetComponent("Image").sprite = self.AllPoker.transform:GetChild((string.split(Util.OutPutPokerValue(m_byPlayerPokerData[pokernum]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byPlayerPokerData[pokernum]), ",")[2]) - 1):GetComponent("Image").sprite;
        elseif pokernum < 5 then
            self.MipaiAni_PokerValue:GetComponent("Image").sprite = self.AllPoker.transform:GetChild((string.split(Util.OutPutPokerValue(m_byBankerPokerData[pokernum - 2]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byBankerPokerData[pokernum - 2]), ",")[2]) - 1):GetComponent("Image").sprite;
        else

        end
    end
    local traMovePoker;
    if pokernum == 254 then
        -- 玩家开牌
        logYellow("poker 254：  " .. pokernum)
        IssendPokerpos = false;
        self.ShowPlayerCard.transform:GetChild(1).gameObject:SetActive(true);
        self.ShowPlayerCard.transform:GetChild(1).transform.localRotation = Vector3.New(0, 0, 0);
        self.ShowPlayerCard.transform:GetChild(1):DOLocalMove(Vector3.New(-poketw + (1) * poketw, 0, 0), 0.5, false);
        self.CheckDealMethod(true, 1)
        self.MipaiAni_MovePoker:SetActive(false);
        if self.MipaiAniuserid == SCPlayerInfo._01dwUser_Id then
            local buffer = ByteBuffer.New()
            logYellow("poker 254------------------")
            Network.Send(MH.MDM_GF_GAME, BaccaraMH.SUB_CS_USER_PEEK_STOP, buffer, gameSocketNumber.GameSocket);

        end
        return ;
    elseif pokernum == 255 then
        -- 庄家开牌
        IssendPokerpos = false;
        self.ShowBankerCard.transform:GetChild(1).gameObject:SetActive(true);
        self.ShowBankerCard.transform:GetChild(1).transform.localRotation = Vector3.New(0, 0, 0);
        self.ShowBankerCard.transform:GetChild(1):DOLocalMove(Vector3.New(-poketw + (1) * poketw, 0, 0), 0.5, false);
        self.CheckDealMethod(true, 2)
        self.MipaiAni_MovePoker:SetActive(false);

        if self.MipaiAniuserid == SCPlayerInfo._01dwUser_Id then
            local buffer = ByteBuffer.New()
            Network.Send(MH.MDM_GF_GAME, BaccaraMH.SUB_CS_USER_PEEK_STOP, buffer, gameSocketNumber.GameSocket);
        end
        return ;
    elseif pokernum == 1 then
        -- 闲家翻牌第一张位置
        if (posx == 0 and posy == 0) then
            IssendPokerpos = false;
            logYellow("=========================player 1 poker = " .. pokernum);
            self.ShowPlayerCard.transform:GetChild(0):GetComponent("Image").sprite = self.AllPoker.transform:GetChild((string.split(Util.OutPutPokerValue(m_byPlayerPokerData[1]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byPlayerPokerData[1]), ",")[2]) - 1):GetComponent("Image").sprite;
            self.ShowPlayerCard.transform:GetChild(0).transform.localRotation = Vector3.New(0, 0, 0);
            self.ShowPlayerCard.transform:GetChild(0).transform.position = self.MipaiAni.transform.position;
            logYellow("mipaipoker pos x 1 " .. self.MipaiAni.transform.position.x .. " y = " .. self.MipaiAni.transform.position.y);
            self.ShowPlayerCard.transform:GetChild(0).gameObject:SetActive(true);
            traMovePoker = self.ShowPlayerCard.transform:GetChild(0);
            --self.ShowPlayerCard.transform:GetChild(0):DOLocalMove(Vector3.New(- poketw +(0) * poketw, 0, 0), 0.5, false);
        end
    elseif pokernum == 2 then
        -- 闲家翻牌第二张位置
        if (posx == 0 and posy == 0) then
            logYellow("=========================player 2 poker = " .. pokernum);
            if (self.ShowPlayerCard.transform:GetChild(1).gameObject.activeSelf) then
                return ;
            end

            IssendPokerpos = false
            self.ShowPlayerCard.transform:GetChild(0):GetComponent("Image").sprite = self.AllPoker.transform:GetChild((string.split(Util.OutPutPokerValue(m_byPlayerPokerData[1]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byPlayerPokerData[1]), ",")[2]) - 1):GetComponent("Image").sprite;
            self.ShowPlayerCard.transform:GetChild(1):GetComponent("Image").sprite = self.AllPoker.transform:GetChild((string.split(Util.OutPutPokerValue(m_byPlayerPokerData[2]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byPlayerPokerData[2]), ",")[2]) - 1):GetComponent("Image").sprite;
            self.ShowPlayerCard.transform:GetChild(1).gameObject:SetActive(true);
            self.ShowPlayerCard.transform:GetChild(1).transform.localRotation = Vector3.New(0, 0, 0);
            self.ShowPlayerCard.transform:GetChild(1).transform.position = self.MipaiAni.transform.position;
            --logYellow("mipaipoker pos x 2 " .. self.MipaiAni.transform.position.x .. " y = " .. self.MipaiAni.transform.position.y);
            traMovePoker = self.ShowPlayerCard.transform:GetChild(1);
            --self.ShowPlayerCard.transform:GetChild(1):DOLocalMove(Vector3.New(- poketw +(1) * poketw, 0, 0), 0.5, false);
            --            if posz == 0 then
            --                IssendPokerpos = false
            --                self.StopLookOnClick()
            --            end
            self.ChipTime = 0;
            -- return;
        end
    elseif pokernum == 3 then
        -- 庄家翻牌第一张位置
        if (posx == 0 and posy == 0) then
            self.ShowBankerCard.transform:GetChild(0):GetComponent("Image").sprite = self.AllPoker.transform:GetChild((string.split(Util.OutPutPokerValue(m_byBankerPokerData[1]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byBankerPokerData[1]), ",")[2]) - 1):GetComponent("Image").sprite;
            self.ShowBankerCard.transform:GetChild(0).transform.localRotation = Vector3.New(0, 0, 0);
            self.ShowBankerCard.transform:GetChild(0).transform.position = self.MipaiAni.transform.position
            self.ShowBankerCard.transform:GetChild(0).gameObject:SetActive(true);
            traMovePoker = self.ShowBankerCard.transform:GetChild(0);
            --self.ShowBankerCard.transform:GetChild(0):DOLocalMove(Vector3.New(- poketw +(0) * poketw, 0, 0), 0.5, false);
        end
    elseif pokernum == 4 then
        -- 庄家翻牌第二张位置
        if (posx == 0 and posy == 0) then
            logYellow("=========================Zj 2 poker = " .. pokernum);
            if (self.ShowBankerCard.transform:GetChild(1).gameObject.activeSelf) then
                return ;
            end

            self.ShowBankerCard.transform:GetChild(0):GetComponent("Image").sprite = self.AllPoker.transform:GetChild((string.split(Util.OutPutPokerValue(m_byBankerPokerData[1]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byBankerPokerData[1]), ",")[2]) - 1):GetComponent("Image").sprite;
            self.ShowBankerCard.transform:GetChild(1):GetComponent("Image").sprite = self.AllPoker.transform:GetChild((string.split(Util.OutPutPokerValue(m_byBankerPokerData[2]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byBankerPokerData[2]), ",")[2]) - 1):GetComponent("Image").sprite;
            self.ShowBankerCard.transform:GetChild(1).gameObject:SetActive(true);
            self.ShowBankerCard.transform:GetChild(1).transform.localRotation = Vector3.New(0, 0, 0);
            self.ShowBankerCard.transform:GetChild(1).transform.position = self.MipaiAni.transform.position;
            traMovePoker = self.ShowBankerCard.transform:GetChild(1);
            --self.MipaiAni:SetActive(false);
            --self.ShowBankerCard.transform:GetChild(1):DOLocalMove(Vector3.New(- poketw +(1) * poketw, 0, 0), 0.5, false);
            --            if posz == 0 then
            --                IssendPokerpos = false
            --                self.StopLookOnClick()
            --            end
            self.SceneHint:SetActive(false);
            self.ChipTime = 0;
            --  return;
        end
    elseif pokernum == 5 then
        -- 闲家补牌眯牌
        if (posx == 0 and posy == 0) then
            self.ShowPlayerCard.transform:GetChild(0):GetComponent("Image").sprite = self.AllPoker.transform:GetChild((string.split(Util.OutPutPokerValue(m_byPlayerPokerData[1]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byPlayerPokerData[1]), ",")[2]) - 1):GetComponent("Image").sprite;
            self.ShowPlayerCard.transform:GetChild(1):GetComponent("Image").sprite = self.AllPoker.transform:GetChild((string.split(Util.OutPutPokerValue(m_byPlayerPokerData[2]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byPlayerPokerData[2]), ",")[2]) - 1):GetComponent("Image").sprite;
            self.ShowPlayerCard.transform:GetChild(2):GetComponent("Image").sprite = self.AllPoker.transform:GetChild((string.split(Util.OutPutPokerValue(m_byPlayerPokerData[3]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byPlayerPokerData[3]), ",")[2]) - 1):GetComponent("Image").sprite;
            self.ShowPlayerCard.transform:GetChild(2).gameObject:SetActive(true);
            self.ShowPlayerCard.transform:GetChild(2).transform.localRotation = Vector3.New(0, 0, 0);
            self.ShowPlayerCard.transform:GetChild(2).transform.position = self.MipaiAni.transform.position;
            traMovePoker = self.ShowPlayerCard.transform:GetChild(2);
            --self.ShowPlayerCard.transform:GetChild(2):DOLocalMove(Vector3.New(- poketw +(2) * poketw, 0, 0), 0.5, false);
            self.ChipTime = 0;
            self.SceneHint:SetActive(false);

            if self.MipaiAniuserid == SCPlayerInfo._01dwUser_Id then
                if posz == 0 then
                    IssendPokerpos = false
                    local buffer = ByteBuffer.New()
                    Network.Send(MH.MDM_GF_GAME, BaccaraMH.SUB_CS_USER_PEEKADD_STOP, buffer, gameSocketNumber.GameSocket);
                end
            end
            --  return;
        end
    elseif pokernum == 6 then
        -- 庄家翻牌第二张位置
        if (posx == 0 and posy == 0) then
            self.ShowBankerCard.transform:GetChild(0):GetComponent("Image").sprite = self.AllPoker.transform:GetChild((string.split(Util.OutPutPokerValue(m_byBankerPokerData[1]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byBankerPokerData[1]), ",")[2]) - 1):GetComponent("Image").sprite;
            self.ShowBankerCard.transform:GetChild(1):GetComponent("Image").sprite = self.AllPoker.transform:GetChild((string.split(Util.OutPutPokerValue(m_byBankerPokerData[2]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byBankerPokerData[2]), ",")[2]) - 1):GetComponent("Image").sprite;
            self.ShowBankerCard.transform:GetChild(2):GetComponent("Image").sprite = self.AllPoker.transform:GetChild((string.split(Util.OutPutPokerValue(m_byBankerPokerData[3]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byBankerPokerData[3]), ",")[2]) - 1):GetComponent("Image").sprite;
            self.ShowBankerCard.transform:GetChild(2).gameObject:SetActive(true);
            self.ShowBankerCard.transform:GetChild(2).transform.localRotation = Vector3.New(0, 0, 0);
            self.ShowBankerCard.transform:GetChild(2).transform.position = self.MipaiAni.transform.position
            traMovePoker = self.ShowBankerCard.transform:GetChild(2);
            --self.ShowBankerCard.transform:GetChild(2):DOLocalMove(Vector3.New(- poketw +(2) * poketw, 0, 0), 0.5, false);
            self.ChipTime = 0;
            self.SceneHint:SetActive(false);

            if self.MipaiAniuserid == SCPlayerInfo._01dwUser_Id then
                if posz == 0 then
                    IssendPokerpos = false
                    local buffer = ByteBuffer.New()
                    Network.Send(MH.MDM_GF_GAME, BaccaraMH.SUB_CS_USER_PEEKADD_STOP, buffer, gameSocketNumber.GameSocket);
                end
            end
        end
    end

    if (posx == 0 and posy == 0) then
        local function waittime()
            IssendPokerpos = false
            self.MipaiAni_NoMipai:SetActive(true);
            coroutine.wait(0.5);
            if pokernum == 2 or pokernum == 5 then
                coroutine.start(self.PlayLastMusic, true);
            elseif pokernum == 4 or pokernum == 6 then

                coroutine.start(self.PlayLastMusic, false);
            end

            --            self.MipaiAni_MovePoker.transform:DOLocalMove(Vector3.New(220, 223, 0), 0.1, false):SetEase(DG.Tweening.Ease.Linear);
            --            self.MipaiAni_PokerValue.transform:DOLocalMove(Vector3.New(220, 223, 0), 0.1, false):SetEase(DG.Tweening.Ease.Linear);
            self.MipaiAni_MovePoker.transform.localPosition = Vector3.New(220, 223, 0);
            self.MipaiAni_PokerValue.transform.localPosition = Vector3.New(220, 223, 0);
            self.MipaiAni_MovePoker:SetActive(false);
            self.MipaiAni:SetActive(false);
            IssendPokerpos = true;

            logYellow("=========================poker move = " .. pokernum);
            local fTimePokerMove = 0.5;
            local doTweenMove = traMovePoker:DOLocalMove(Vector3.New(-poketw + (traMovePoker:GetSiblingIndex()) * poketw, 0, 0), fTimePokerMove, false);

            doTweenMove:OnKill(function()
                if (2 == pokernum or 4 == pokernum or 5 == pokernum or 6 == pokernum) then
                    --if posz == 0 then
                    IssendPokerpos = false
                    --self.StopLookOnClick();
                    local iPokerId;
                    if (2 == pokernum or 5 == pokernum) then
                        iPokerId = C_X_POKEREND_ID;
                    else
                        iPokerId = C_Z_POKEREND_ID;
                    end
                    if (5 == pokernum or 6 == pokernum) then
                        openpokernum = openpokernum + 1;
                    end
                    BaccaraPanel.PokerMoveEnd(iPokerId);
                    --end
                end
            end);

            if pokernum == 1 then
                self.MipaiAni_PokerValue:GetComponent("Image").sprite = self.AllPoker.transform:GetChild((string.split(Util.OutPutPokerValue(m_byPlayerPokerData[2]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byPlayerPokerData[2]), ",")[2]) - 1):GetComponent("Image").sprite;
                openpokernum = 2;
                coroutine.wait(fTimePokerMove + 0.2);
                logYellow("=========================poker move 2 ====================== ");
                self.MiPaiStart()
            end

            if pokernum == 3 then
                self.MipaiAni_PokerValue:GetComponent("Image").sprite = self.AllPoker.transform:GetChild((string.split(Util.OutPutPokerValue(m_byBankerPokerData[2]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byBankerPokerData[2]), ",")[2]) - 1):GetComponent("Image").sprite;
                openpokernum = 4;
                coroutine.wait(fTimePokerMove + 0.2);
                self.MiPaiStart()
            end

            if self.MipaiAniuserid == SCPlayerInfo._01dwUser_Id then
                self.MipaiAni_NoMipai:SetActive(false);
            end
        end
        coroutine.start(waittime)
    end
end

-- 创建其他玩家下注时间间隔
function BaccaraPanel.WaitUpdate()
    if GameState ~= 1 then
        return
    end
    coroutine.wait(1);
    IsWaiteUpdate = true;
    coroutine.start(self.WaitUpdate)
end

-- 登陆成功消息
function BaccaraPanel.LogonSuccessMethod(wMain, wSubID, buffer, wSize)
    --  error("登陆成功消息");
    BaccaraMH.mySelfInfo.wchair = TableUserInfo._10wTableID;
    GameNextScenName = gameScenName.Baccara;
end

-- 登陆完成消息
function BaccaraPanel.LogonOverMethod(wMain, wSubID, buffer, wSize)
    if (65535 == BaccaraMH.mySelfInfo.wchair) then
        -- 不在桌子上
        local buffer = ByteBuffer.New()
        Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket);
    else
        -- 若在桌子上 则直接发送玩家准备
        local Data = { [1] = 0, }
        -- 旁观标志 必须等于0
        local buffer = SetC2SInfo(Point21DataStruct.CMD_GF_Info, Data);
        Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket);
    end


end

-- 登陆失败消息
function BaccaraPanel.LogonFailedMethod(wMain, wSubID, buffer, wSize)
    Network.OnException("房间人数已满，请稍后再试！！", 1);
end

-- 表情动作消息
function BaccaraPanel.BiaoActionMethod(wMain, wSubID, buffer, wSize)

end

function BaccaraPanel.WaitGameQuit()
    GameNextScenName = gameScenName.HALL;
    coroutine.wait(2);
    GameSetsBtnInfo.LuaGameQuit();
end
-- 用户进入消息
function BaccaraPanel.UserEnterMethod()
    -- error("用户进入消息");
    local data = {};
    data = TableUserInfo;
    local newdata = {
        _1dwUser_Id = data._1dwUser_Id,
        _2szNickName = data._2szNickName,
        _3bySex = data._3bySex,
        _4bCustomHeader = data._4bCustomHeader,
        _5szHeaderExtensionName = data._5szHeaderExtensionName,
        _6szSign = data._6szSign,
        _7wGold = data._7wGold,
        _8wPrize = data._8wPrize,
        _9wChairID = data._9wChairID,
        _10wTableID = data._10wTableID,
        _11byUserStatus = data._11byUserStatus,
        _12wScore = 0;
    };
    local issame = 0;
    for i = 1, #AllPlayerInfo do
        if AllPlayerInfo[i]._10wTableID == 65535 then
            table.remove(AllPlayerInfo, i)
        end ;
        if data._9wChairID == AllPlayerInfo[i]._9wChairID then
            issame = 1;
            AllPlayerInfo[i] = newdata
        end
    end
    if issame == 0 then
        table.insert(AllPlayerInfo, #AllPlayerInfo + 1, newdata)
    end
    RoomPeople = RoomPeople + 1;
    -- error("用户进入==========================" .. AllPlayerInfo[#AllPlayerInfo]._1dwUser_Id);
    if SCPlayerInfo._01dwUser_Id == data._1dwUser_Id then
        BaccaraMH.mySelfInfo.wchair = data._9wChairID;
        self.MySelfBtn.name = SCPlayerInfo._01dwUser_Id;
        self.MyselfHeadImg.name = SCPlayerInfo._01dwUser_Id;
        BaccaraMH.mySelfInfo.name = data._2szNickName;
        BaccaraMH.mySelfInfo.gold = data._7wGold;
        BaccaraMH.mySelfInfo.ticket = data._8wPrize;
        BaccaraMH.mySelfInfo.score = 0;
        self.MyselfName:GetComponent('Text').text = BaccaraMH.mySelfInfo.name;
        self.MyselfScore:GetComponent('Text').text = tostring(BaccaraMH.mySelfInfo.gold);
        self.CreatShowNum(self.ChipNum.transform:Find("Gold").gameObject, self.MyScoreImg.gameObject, tostring(BaccaraMH.mySelfInfo.gold));
        local UrlHeadImg = "";
        -- if data._4bCustomHeader == 0 then
        --     UrlHeadImg = SCSystemInfo._2wWebServerAddress .. "/" .. SCSystemInfo._4wHeaderDir .. "/0" .. data._3bySex .. ".png";
        --     local headstr = data._3bySex;
        --     UpdateFile.downHead(UrlHeadImg, headstr, nil, self.MyselfHeadImg);
        -- else
        --     UrlHeadImg = SCSystemInfo._2wWebServerAddress .. "/" .. SCSystemInfo._4wHeaderDir .. "/" .. data._1dwUser_Id .. "." .. data._5szHeaderExtensionName;
        --     local headstr = data._1dwUser_Id .. "." .. data._5szHeaderExtensionName;
        --     UpdateFile.downHead(UrlHeadImg, headstr, nil, self.MyselfHeadImg);
        -- end
        if SCPlayerInfo._02bySex == enum_Sex.E_SEX_MAN then
            self.MyselfHeadImg.transform:GetComponent('Image').sprite = HallScenPanel.nanSprtie;
        elseif SCPlayerInfo._02bySex == enum_Sex.E_SEX_WOMAN then
            self.MyselfHeadImg.transform:GetComponent('Image').sprite = HallScenPanel.nvSprtie
        else
            self.MyselfHeadImg.transform:GetComponent('Image').sprite = HallScenPanel.nanSprtie;
        end
        self.MyselfHeadImg.transform:GetComponent('Image').sprite = HallScenPanel.GetHeadIcon();
    end
    -- error("用户进入消息处理完成");
end

-- 初始化庄家信息
function BaccaraPanel.FirstBankerInfo()
end

-- 用户离开
function BaccaraPanel.UserLeaveMethod()
    local data = TableUserInfo;
    --  error("用户离开=============RoomPeople" .. RoomPeople);
    for i = 1, #AllPlayerInfo do
        if data._9wChairID == AllPlayerInfo[i]._9wChairID then
            AllPlayerInfo[i]._10wTableID = 65535
        end
    end
end

-- 用户状态
function BaccaraPanel.UserStatusMethod()
    -- error("用户状态");
    local data = TableUserInfo;
    if SCPlayerInfo._01dwUser_Id == data._1dwUser_Id then
        --    error("用户状态");
        BaccaraMH.mySelfInfo.name = data._2szNickName;
        BaccaraMH.mySelfInfo.gold = data._7wGold;
        BaccaraMH.mySelfInfo.ticket = data._8wPrize;
        --  self.MyselfName:GetComponent('Text').text = BaccaraMH.mySelfInfo.name;
        --  self.MyselfScore:GetComponent('Text').text = BaccaraMH.mySelfInfo.gold;
    end
    local newdata = {
        _1dwUser_Id = data._1dwUser_Id,
        _2szNickName = data._2szNickName,
        _3bySex = data._3bySex,
        _4bCustomHeader = data._4bCustomHeader,
        _5szHeaderExtensionName = data._5szHeaderExtensionName,
        _6szSign = data._6szSign,
        _7wGold = data._7wGold,
        _8wPrize = data._8wPrize,
        _9wChairID = data._9wChairID,
        _10wTableID = data._10wTableID,
        _11byUserStatus = data._11byUserStatus,
        _12wScore = 0;
    };
    local issame = 0;
    for i = 1, #AllPlayerInfo do
        if data._9wChairID == AllPlayerInfo[i]._9wChairID then
            issame = 1;
            AllPlayerInfo[i] = newdata
        end
    end
    if issame == 0 then
        table.insert(AllPlayerInfo, #AllPlayerInfo + 1, newdata)
    end
end

-- 用户分数
function BaccaraPanel.UserScoreMethod()

    -- error("用户分数");
    local data = TableUserInfo;
    if SCPlayerInfo._01dwUser_Id == data._1dwUser_Id then
        BaccaraMH.mySelfInfo.name = data._2szNickName;
        BaccaraMH.mySelfInfo.gold = data._7wGold;
        BaccaraMH.mySelfInfo.ticket = data._8wPrize;
        self.MyselfName:GetComponent('Text').text = BaccaraMH.mySelfInfo.name;
        if toInt64(BaccaraMH.mySelfInfo.gold) < toInt64(self.MyselfScore:GetComponent('Text').text) then
            self.MyselfScore:GetComponent('Text').text = tostring(BaccaraMH.mySelfInfo.gold);
            self.MyselfScore:GetComponent('Text').text = tostring(BaccaraMH.mySelfInfo.gold);
            self.CreatShowNum(self.ChipNum.transform:Find("Gold").gameObject, self.MyScoreImg.gameObject, tostring(BaccaraMH.mySelfInfo.gold));
        end
        self.NoClickBtn();
    end
    local newdata = {
        _1dwUser_Id = data._1dwUser_Id,
        _2szNickName = data._2szNickName,
        _3bySex = data._3bySex,
        _4bCustomHeader = data._4bCustomHeader,
        _5szHeaderExtensionName = data._5szHeaderExtensionName,
        _6szSign = data._6szSign,
        _7wGold = data._7wGold,
        _8wPrize = data._8wPrize,
        _9wChairID = data._9wChairID,
        _10wTableID = data._10wTableID,
        _11byUserStatus = data._11byUserStatus,
        _12wScore = 0;
    };
    local issame = 0;
    for i = 1, #AllPlayerInfo do
        if data._9wChairID == AllPlayerInfo[i]._9wChairID then
            issame = 1;
            newdata._12wScore = AllPlayerInfo[i]._12wScore;
            AllPlayerInfo[i] = newdata
        end
    end
    if issame == 0 then
        table.insert(AllPlayerInfo, #AllPlayerInfo + 1, newdata)
    end
    BaccaraPanel.UpdateScore();
end

-- 设置哪些筹码不可点
function BaccaraPanel.NoClickBtn()
    if ChooseChipName ~= "All" then
        if toInt64(ChooseChipNum) > toInt64(BaccaraMH.mySelfInfo.gold) then
            ChooseChipName = "One";
            ChooseChipNum = ChooseChipTable[1];
            self.ChipBtn.transform:GetChild(0):GetComponent("Button").interactable = false;
            for i = 1, self.ChipBtn.transform.childCount - 1 do
                self.ChipBtn.transform:GetChild(i):GetComponent("Button").interactable = true;
            end
        end
    end
end

-- 游戏退出coroutine.status(co)  
function BaccaraPanel.GameQuitMethod(wMain, wSubID, buffer, wSize)
    local myselfchipvalue = 0;
    for i = 1, #MyselfChipValueTable do
        myselfchipvalue = myselfchipvalue + MyselfChipValueTable[i];
    end
    if myselfchipvalue == 0 and BaccaraMH.BankerInfoTable._01wChair ~= BaccaraMH.mySelfInfo.wchair then
        self.ChipTime = 0;
        MusicManager:PlayBacksound("end", false);
        GameNextScenName = gameScenName.HALL;
        MessgeEventRegister.Game_Messge_Un();
        GameSetsBtnInfo.LuaGameQuit();
        coroutine.start(self.DestoryAb)
    elseif BaccaraMH.BankerInfoTable._01wChair == BaccaraMH.mySelfInfo.wchair then
        self.ShowMessageTishiPanel("You are banker, if you force to quit the game, you will be deducted 5 million gold , do you want to continue?")
    else
        -- Network.OnException("当前正在游戏，是否需要退出？");
        self.ShowMessageTishiPanel("The game is currently playing, do you need to exit？")
    end
end

-- 入座消息
function BaccaraPanel.GameOnSitMethod(wMain, wSubID, buffer, wSize)
    if wSize == 0 then
        -- 入座成功，准备
        local data = { [1] = 0, }
        local buffer = SetC2SInfo(BaccaraMH.CMD_GF_Info, data);
        Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket);
        -- error("入座成功，准备");
    else
        -- 入座失败
        Network.OnException(95008);
    end
end

-- 换桌消息
function BaccaraPanel.ChangeTableMethod(wMain, wSubID, buffer, wSize)
    if wSize == nil then
        error("换桌准备");
        return ;
    end
    if wSize == 0 then
        -- 换桌成功
        --        local data = { [1] = 0, }
        --        local buffer = SetC2SInfo(BaccaraMH.CMD_GF_Info, data);
        --        Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket);
        --  error("换桌成功，准备");
    else
        -- 换桌失败
        Network.OnException(buffer:ReadString(wSize));
    end

end

-- 断线消息
function BaccaraPanel.GameBreakLineMethod(wMain, wSubID, buffer, wSize)
    self.ChipTime = 0;
    IssendPokerpos = false;
    self.ClearInfo();
    GameNextScenName = gameScenName.HALL;
    MessgeEventRegister.Game_Messge_Un();
    local one = buffer:ReadInt32();
    local l = buffer:ReadInt32();
    HallScenPanel.NetException(buffer:ReadString(l), gameSocketNumber.GameSocket);
    -- Network.OnException(buffer:ReadString(l), 1);
end

function BaccaraPanel.BackGame()
    self.SetChipValue(self.ChipHundred)
    error("home回来游戏");
    self.SureClearUp();
    IsBackGame = true;
    BackGameTime = 0;
    HallScenPanel.ReLoadGame(self.ReLoadGame);
end

function BaccaraPanel.ReLoadGame()
    error("重新登录");
    if not (Network.State(gameSocketNumber.GameSocket)) then
        error("链接失败重新链接");

        HallScenPanel.ReLoadGame(self.ReLoadGame);
        return
    end
    -- 发送登陆
    local data = {
        [1] = 0,
        [2] = 0,
        [3] = SCPlayerInfo._01dwUser_Id,
        [4] = SCPlayerInfo._06wPassword,
        [5] = Opcodes,
        [6] = 0,
        [7] = 0,
    }
    local buffer = SetC2SInfo(BaccaraMH.CMD_GR_LogonByUserID, data);
    error("发送登录");
    Network.Send(MH.MDM_GR_LOGON, 3, buffer, gameSocketNumber.GameSocket)
    AllPlayerInfo = {}
end

-- 点击帮助
function BaccaraPanel.HelpMethod()
    error("点击了百家乐帮助");
end
-- 点击桌面押注（庄、闲、闲对、庄对、和）
-- 一秒总次数15
local CheckNum = 0;
local CheckTime = 0;
function BaccaraPanel.DeskTopBtnOnClick(arg)
    ReChipTable = { 0, 0, 0, 0, 0 };
    --    if GameTime >= 1 then
    --        GameTime = 0; CheckNum = 0;
    --    else
    --        CheckNum = CheckNum + 1;
    --        if CheckNum >= 20 then return end
    --    end
    error("点击下注:" .. GameState);
    if GameState ~= 1 then
        return
    end ;
    for i = 1, #C_CHIP_AREA_BTN do
        C_CHIP_AREA_BTN[i]:GetComponent("Button").interactable = false;
    end
    -- 全压
    local numi = 0;
    for i = 1, #C_CHIP_AREA_BTN_NAME do
        if arg.name == C_CHIP_AREA_BTN_NAME[i] then
            numi = i;
        end
    end
    local numvalue = 0;
    if IsAllChip then
        --  error("全压只能下注一次")
        return
    else
        if ChooseChipName == "All" then
            IsAllChip = true;
            if (toInt64(BaccaraMH.mySelfInfo.gold) <= toInt64(2100000000)) then
                numvalue = (math.floor(BaccaraMH.mySelfInfo.gold / ChooseChipTable[1])) * ChooseChipTable[1];
                if numvalue > limitMaxChipTable[numi] then
                    numvalue = (math.floor(limitMaxChipTable[numi] / ChooseChipTable[1])) * ChooseChipTable[1];
                end
            else
                numvalue = (BaccaraMH.mySelfInfo.gold / ChooseChipTable[1]) * ChooseChipTable[1];
                if toInt64(numvalue) > toInt64(limitMaxChipTable[numi]) then
                    numvalue = (limitMaxChipTable[numi] / ChooseChipTable[1]) * ChooseChipTable[1];
                end
            end

            self.CSPlayChip(numi, numvalue);
            for i = 1, #C_CHIP_AREA_BTN do
                C_CHIP_AREA_BTN[i]:GetComponent("Button").interactable = true;
            end
            return ;
        end
    end
    -- 金币不足最低下主值
    if toInt64(BaccaraMH.mySelfInfo.gold) < toInt64(ChooseChipTable[1]) then
        for i = 1, #C_CHIP_AREA_BTN do
            C_CHIP_AREA_BTN[i]:GetComponent("Button").interactable = true;
        end
        return
    end ;

    if toInt64(ChooseChipNum) > toInt64(BaccaraMH.mySelfInfo.gold) then
        self.NoClickBtn();
        for i = 1, #C_CHIP_AREA_BTN do
            C_CHIP_AREA_BTN[i]:GetComponent("Button").interactable = true;
        end
        return
    end ;
    -- 下注大于限红，下限红数值
    if ChooseChipNum > limitMaxChipTable[numi] then
        --   numvalue =(math.floor(limitMaxChipTable[numi] / ChooseChipTable[1])) * ChooseChipTable[1];
        MessageBox.CreatGeneralTipsPanel("下注失败：下注值大于限红最大值");
        --        return;
        --        if limitMaxChipTable[numi] == 0 then error("限红等于0"); return end
        --        self.CSPlayChip(numi, numvalue);
        for i = 1, #C_CHIP_AREA_BTN do
            C_CHIP_AREA_BTN[i]:GetComponent("Button").interactable = true;
        end
        return ;
    end ;
    -- 4、记录创建值    
    local currentgoal = tonumber(self.MyselfScore:GetComponent('Text').text);
    if self.isChipsOn then
        for i = 1, #C_CHIP_AREA_BTN do
            C_CHIP_AREA_BTN[i]:GetComponent("Button").interactable = true;
        end
        return
    end
    -- error("===========(ChooseChipNum + AllChipValueTable[numi]):"..(ChooseChipNum + AllChipValueTable[numi]).."======== limitMaxChipTable[numi]:".. limitMaxChipTable[numi]);
    if currentgoal >= ChooseChipNum and (ChooseChipNum + AllChipValueTable[numi]) <= limitMaxChipTable[numi] then
        self.MyselfScore:GetComponent('Text').text = tostring(currentgoal - ChooseChipNum);
        self.CreatShowNum(self.ChipNum.transform:Find("Gold").gameObject, self.MyScoreImg.gameObject, tostring(currentgoal - ChooseChipNum));
    end
    self.CSPlayChip(numi, ChooseChipNum);
    for i = 1, #C_CHIP_AREA_BTN do
        C_CHIP_AREA_BTN[i]:GetComponent("Button").interactable = true;
    end
end
-- 玩家发送下注消息
function BaccaraPanel.CSPlayChip(num, numvalue)
    if not (IsNil(BaccaraMusic)) then
        local musicchip = BaccaraMusic.transform:Find("Snd_Chip"):GetComponent('AudioSource').clip
        MusicManager:PlayX(musicchip);
    end
    local numchip = numvalue;
    if toInt64(numchip) < toInt64(ChooseChipTable[1]) then
        return
    end
    if toInt64(numchip) > toInt64(BaccaraMH.mySelfInfo.gold) then
        self.NoClickBtn();
        return
    end ;
    if toInt64(numchip) > toInt64(limitMaxChipTable[num]) then
        self.NoClickBtn();
        return
    end ;
    local data = {
        [1] = num - 1,
        [2] = numchip;
    }
    -- self.MyselfScore:GetComponent('Text').text = tostring(BaccaraMH.mySelfInfo.gold - ); 
    local buffer = SetC2SInfo(BaccaraMH.CMD_CS_PLAYER_CHIP, data)
    Network.Send(MH.MDM_GF_GAME, BaccaraMH.SUB_CS_PLAYER_CHIP, buffer, gameSocketNumber.GameSocket);
    error("send chip " .. tostring(numchip));
    self.isChipsOn = true;
end

-- 选择押注的筹码值
function BaccaraPanel.SetChipValue(args)

    local num = tonumber(args.transform:GetChild(0).gameObject.name);
    if toInt64(num) > toInt64(BaccaraMH.mySelfInfo.gold) then
        return ;
    end
    ChooseChipName = args.name;
    for i = 0, args.transform.parent.childCount - 1 do
        args.transform.parent:GetChild(i):GetComponent("Button").interactable = true;
        args.transform.parent:GetChild(i).localScale = Vector3.New(1, 1, 1);
        if args.transform.parent:GetChild(i).gameObject.name == ChooseChipName then
            args:GetComponent("Button").interactable = false;
            args.transform.parent:GetChild(i).localScale = Vector3.New(1.1, 1.1, 1.1);
            if num ~= nil then
                ChooseChipNum = num;
            end
        end
    end
end
-- 续押按钮
function BaccaraPanel.ReSetChipValue(args)
    local num = 0;
    for i = 1, #ReChipTable do
        num = ReChipTable[i] + num;
    end
    if num == 0 then
        return ;
    elseif toInt64(num) > toInt64(BaccaraMH.mySelfInfo.gold) then
        return ;
    else
        args.transform:GetComponent('Button').interactable = false;
    end
    for i = 1, #ReChipTable do
        if ReChipTable[i] ~= nil and ReChipTable[i] > 0 then
            self.CSPlayChip(i, ReChipTable[i])
            ReChipTable[i] = 0;
        end
    end
end
function BaccaraPanel.SetChipWinOrLoseState()
    local childnum = 0;
    for i = 1, #GameOverInfoTable do
        childnum = childnum + AllChipValueTable[i];
    end
    coroutine.start(self.WinAreaLight, childnum)
end

function BaccaraPanel.WinAreaLight(stopnum)
    local args = 9;
    local IsLight = false;
    for i = 1, 2 do
        if ChipWinOrLoseState[i] == 0 then
            IsLight = true;
        end
    end
    if stopnum == 0 then
        args = 4
    end
    self.WinLight:SetActive(true);
    for timenum = 1, args do
        for i = 1, #ChipWinOrLoseState do
            if not string.find(ScenSeverName, gameServerName.Baccara) then
                return ;
            end
            self.WinLight.transform:GetChild(i - 1).gameObject:SetActive(false);
            if ChipWinOrLoseState[i] == 0 then
                self.WinLight.transform:GetChild(i - 1).gameObject:SetActive(true);
            end
        end
        if GameNextScenName ~= gameScenName.Baccara then
            return
        end ;
        coroutine.wait(0.3);
        if GameNextScenName ~= gameScenName.Baccara then
            return
        end ;
        if not string.find(ScenSeverName, gameServerName.Baccara) then
            return ;
        end
        for i = 1, #ChipWinOrLoseState do
            self.WinLight.transform:GetChild(i - 1).gameObject:SetActive(false);
            if ChipWinOrLoseState[i] == 2 then
                self.WinLight.transform:GetChild(i - 1).gameObject:SetActive(false);
            end
        end
        if GameNextScenName ~= gameScenName.Baccara then
            return
        end ;
        coroutine.wait(0.3);
        if GameNextScenName ~= gameScenName.Baccara then
            return
        end ;
    end

    self.WinLight:SetActive(false);
end
local StartSendPoker = 0;

function BaccaraPanel.SendBackPoker()
    local prefeb = self.CardsBox.transform:GetChild(0).gameObject;
    for i = 1, 2 do
        if not (IsNil(BaccaraMusic)) then
            local musicchip = BaccaraMusic.transform:Find("Snd_SendCard"):GetComponent('AudioSource').clip
            MusicManager:PlayX(musicchip);
        end
        local go = newobject(prefeb);
        go.transform:SetParent(self.ShowPlayerCard.transform);
        -- error(prefeb.name);
        go.transform.localScale = Vector3.New(0.5, 0.5, 0.5);
        go.transform.position = Vector3.New(prefeb.transform.position.x, prefeb.transform.position.y, 0);
        go.name = prefeb.name;
        go:SetActive(true);
        local movepos = Vector3.New(-poketw + ((i - 1) * poketw), 0, 0)
        -- 判断牌位置
        local tweener = go.transform:DOLocalMove(movepos, 0.3, false);
        tweener:SetEase(DG.Tweening.Ease.Linear);
        if GameNextScenName ~= gameScenName.Baccara then
            return
        end ;

        -- 庄家
        local go = newobject(prefeb);
        go.transform:SetParent(self.ShowBankerCard.transform);
        go.transform.localScale = Vector3.New(0.5, 0.5, 0.5);
        go.transform.position = Vector3.New(prefeb.transform.position.x, prefeb.transform.position.y, 0);
        go.name = prefeb.name;
        go:SetActive(true);
        local movepos = Vector3.New(-poketw + ((i - 1) * poketw), 0, 0)
        -- 判断牌位置
        if not (IsNil(BaccaraMusic)) then
            local musicchip = BaccaraMusic.transform:Find("Snd_SendCard"):GetComponent('AudioSource').clip
            MusicManager:PlayX(musicchip);
        end
        local tweener = go.transform:DOLocalMove(movepos, 0.3, false);
        tweener:SetEase(DG.Tweening.Ease.Linear);
        if GameNextScenName ~= gameScenName.Baccara then
            return
        end ;
    end
end
-- 开始发牌
function BaccaraPanel.DealMethod(IsAdd)
    local prefeb = self.CardsBox.transform:GetChild(0).gameObject;
    local go = newobject(prefeb);
    go.transform:SetParent(DealCardParset.transform);
    go.transform.localScale = Vector3.New(0.5, 0.5, 0.5);
    go.transform.position = Vector3.New(prefeb.transform.position.x, prefeb.transform.position.y, 0);
    go.name = prefeb.name;
    go:SetActive(true);
    local movepos = Vector3.New(-poketw + ((DealCardParset.transform.childCount - 1) * poketw), 0, 0)
    -- if IsAdd then movepos=Vector3.New() end
    -- 判断牌位置
    if not (IsNil(BaccaraMusic)) then
        local musicchip = BaccaraMusic.transform:Find("Snd_SendCard"):GetComponent('AudioSource').clip
        MusicManager:PlayX(musicchip);
    end
    local tweener = go.transform:DOLocalMove(movepos, 0.3, false);
    tweener:SetEase(DG.Tweening.Ease.Linear);
    if GameNextScenName ~= gameScenName.Baccara then
        return
    end ;
    -- if IsOpen==true then  tweener:OnComplete(self.DealOverCallBack); end
end

-- 每张牌发完后回调事件
function BaccaraPanel.DealOverCallBack(IsPlayerBl)
    local DealCardcardNum = DealCardParset.transform.childCount;
    for i = 1, #SendPoker do
        local cardNum = SendPoker[i];
        if not (IsNil(BaccaraMusic)) then
            local musicchip = BaccaraMusic.transform:Find("Snd_SendCard_Bak"):GetComponent('AudioSource').clip
            MusicManager:PlayX(musicchip);
        end
        if DealCardcardNum == 3 then
            i = 3
        end
        local pos = DealCardParset.transform.localPosition;
        pos = Vector3.New(-pos.x, -pos.y, 0)
        local tweener = DealCardParset.transform:GetChild(i - 1):DOLocalMove(pos, 0.5, false);
        tweener:SetEase(DG.Tweening.Ease.Linear);
        tweener:OnKill(function()
            if (bGameQuit) then
                return ;
            end
            DealCardParset.transform:GetChild(i - 1).localScale = Vector3.New(1, 1, 1);
        end);

        if (bGameQuit) then
            return ;
        end

        coroutine.wait(0.5);
        DealCardParset.transform:GetChild(i - 1):GetComponent("Image").sprite = self.WinAni.transform:GetChild(0):GetComponent("Image").sprite;
        coroutine.wait(0.05);
        DealCardParset.transform:GetChild(i - 1):GetComponent("Image").sprite = self.WinAni.transform:GetChild(1):GetComponent("Image").sprite;
        coroutine.wait(0.05);
        DealCardParset.transform:GetChild(i - 1):GetComponent("Image").sprite = self.WinAni.transform:GetChild(2):GetComponent("Image").sprite;
        coroutine.wait(0.05);
        DealCardParset.transform:GetChild(i - 1):GetComponent("Image").sprite = self.AllPoker.transform:GetChild(cardNum - 1):GetComponent("Image").sprite;
        DealCardParset.transform:GetChild(i - 1).localRotation = Vector3.New(0, 0, 0);
        coroutine.wait(0.6);
        DealCardParset.transform:GetChild(i - 1):DOLocalMove(Vector3.New(-poketw + (i - 1) * poketw, 0, 0), 0.5, false):SetEase(DG.Tweening.Ease.Linear);
        -- 补牌判断
        if i > 1 then
            -- 显示闲家点数
            coroutine.start(self.PlayLastMusic, IsPlayerBl);
        end
        DealCardParset.transform:GetChild(i - 1).localScale = Vector3.New(0.5, 0.5, 0.5);
        coroutine.wait(0.6);
    end
end

-- 播放点数
function BaccaraPanel.PlayLastMusic(IsPlayerBl)

    if IsPlayerBl then
        local DealCardcardNum = self.ShowPlayerCard.transform.childCount;
        -- 显示闲家点数
        if not (IsNil(BaccaraMusic)) then
            local musicchip = BaccaraMusic.transform:Find("Baccarat_xian" .. playerPoint):GetComponent('AudioSource').clip
            local source = MusicManager:PlayX(musicchip);
            -- 播放庄点数
        end
        self.PlayerCardValue.transform:GetComponent('Image').sprite = self.ChipNum.transform:Find("One"):GetChild(playerPoint).gameObject:GetComponent('Image').sprite
        self.PlayerCardPoint:SetActive(true);
        if (2 == DealCardcardNum) then
            --            coroutine.wait(0.2);
            --            local a = string.split(Util.OutPutPokerValue(m_byPlayerPokerData[1]), ",")[2]
            --            local b = string.split(Util.OutPutPokerValue(m_byPlayerPokerData[2]), ",")[2]
            --            if (a == b) then
            --                if not(IsNil(BaccaraMusic))  then
            --                    local musicchip = BaccaraMusic.transform:Find("Baccarat_xian2p"):GetComponent('AudioSource').clip
            --                    MusicManager:PlayX(musicchip)
            --            coroutine.wait(0.2);
            --                end
            --                -- 播放闲对
            --            end
        end
    else
        local DealCardcardNum = self.ShowBankerCard.transform.childCount;
        -- 显示庄家点数
        if not (IsNil(BaccaraMusic)) then
            local musicchip = BaccaraMusic.transform:Find("Baccarat_zhuang" .. bankerPoint):GetComponent('AudioSource').clip
            logYellow("zj point ~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
            local source = MusicManager:PlayX(musicchip);
            -- 播放庄点数
        end
        self.BankerCardValue.transform:GetComponent('Image').sprite = self.ChipNum.transform:Find("One"):GetChild(bankerPoint).gameObject:GetComponent('Image').sprite;
        self.BankerCardPoint:SetActive(true);
        if (2 == DealCardcardNum) then
            --            coroutine.wait(0.2);
            --            local a = string.split(Util.OutPutPokerValue(m_byBankerPokerData[1]), ",")[2]
            --            local b = string.split(Util.OutPutPokerValue(m_byBankerPokerData[2]), ",")[2]
            --            if (a == b) then
            --                if not(IsNil(BaccaraMusic))  then
            --                    local musicchip = BaccaraMusic.transform:Find("Baccarat_zhuang2p"):GetComponent('AudioSource').clip
            --                    MusicManager:PlayX(musicchip)
            --            coroutine.wait(0.2);
            --                end
            --                -- 播放庄对
            --            end
        end
    end
end

-- 下注倒计时
function BaccaraPanel.ChipCountDownMethod()

    if self.ChipTime < 0 then
        return
    end ;
    self.ChipCountDownTimeNum.transform:GetChild(1):GetComponent('Text').text = " "
    self.ChipCountDownTimeNum.transform:GetChild(0):GetComponent('Text').text = self.ChipTime
    if GameNextScenName ~= gameScenName.Baccara then
        return
    end ;
    if self.ChipTime < 1 then
        -- if GameState>BaccaraMH.GAME_STATE_SEND_POKER then self.StopLookOnClick(); end
        self.ChipCountDownTimeNum.transform:GetChild(0):GetComponent('Text').text = "0";
        IsChipBL = false;
        if GameNextScenName ~= gameScenName.Baccara then
            return
        end ;
        if self.ChipTime == 0 then
            return
        end ;
    end
end

function BaccaraPanel.JianTiming()
    IsChipBL = true;
    if GameNextScenName ~= gameScenName.Baccara then
        return
    end ;
    coroutine.wait(1);
    if GameNextScenName ~= gameScenName.Baccara then
        return
    end ;
    self.ChipCountDownMethod();
    if GameState == 1 then
        if self.ChipTime > 0 then
            coroutine.start(self.JianTiming);
        end
    end
end

function BaccaraPanel.onendDrag(args)
    if self.WayBillMain.transform.localPosition.x < 0 then
        if #bywheelCountTable > 40 then
            for i = 0, 39 do
                self.WayBillMain.transform:GetChild(i).gameObject:SetActive(false);
            end
            for i = 40, #bywheelCountTable - 1 do
                self.WayBillMain.transform:GetChild(i).gameObject:SetActive(true);
            end
        else

        end
    elseif self.WayBillMain.transform.localPosition.x > 0 then
        if #bywheelCountTable > 40 then
            for i = 0, 39 do
                self.WayBillMain.transform:GetChild(i).gameObject:SetActive(true);
            end
            for i = 40, self.WayBillMain.transform.childCount - 1 do
                self.WayBillMain.transform:GetChild(i).gameObject:SetActive(false);
            end
        else

        end
    end
end

-- 创建路单信息(闲0，庄1，和2，闲对3，庄对4)
-- （闲数字，庄数字）
function BaccaraPanel.SetWayBillValue()
    error("路单数量:" .. #bywheelCountTable);
    -- error("创建路单信息(闲0，庄1，和2，闲对3，庄对4)");
    if #bywheelCountTable == 0 then
        for i = 0, self.WayBillMain.transform.childCount - 1 do
            local go = self.WayBillMain.transform:GetChild(i).gameObject
            go.transform:Find("Num"):GetComponent("Text").text = " ";
            go.transform:GetComponent("Image").sprite = self.WayBillImg.transform:GetChild(3):GetComponent("Image").sprite
            go.transform:Find("xian").gameObject:SetActive(false);
            go.transform:Find("zhuang").gameObject:SetActive(false);
        end
        for i = 0, self.WayBillMain_Two.transform.childCount - 1 do
            local go = self.WayBillMain_Two.transform:GetChild(i).gameObject
            go.transform:GetComponent("Image").sprite = self.WayBillImg.transform:GetChild(3):GetComponent("Image").sprite
            go.transform:Find("Num"):GetComponent("Text").text = " ";
            go.transform:Find("xian").gameObject:SetActive(false);
            go.transform:Find("zhuang").gameObject:SetActive(false);
        end
        return
    end
    for i = 1, #bywheelCountTable do
        error("创建路单======" .. i);
        self.CreatWayBillPrefeb(i, self.WayBillMain)
        error("创建路单1======" .. i);
    end
    self.SetTwoWayBillValue();
end
self.TwoWayBillTab = {};
self.TwoWayTabPos = {};
function BaccaraPanel.SetTwoWayBillValue()
    logYellow("------------------SetTwoWayBillValue------------------------  .. " .. #self.TwoWayTabPos);
    if #bywheelCountTable == 0 then
        logYellow("------------------init bill------------------------");
        self.TwoWayBillTab = {};
        self.TwoWayTabPos = {};
        return
    end
    -- 0代表空，1代表闲，2代表庄
    local data = { 0, 0, 0, 0, 0, 0 };
    local pos = { 0, 0, 0, 0, 0, 0 };
    if #self.TwoWayBillTab == 0 then
        table.insert(self.TwoWayBillTab, data)
        table.insert(self.TwoWayTabPos, pos)
    end
    local num = 11;
    if #bywheelCountTable < 11 then
        num = #bywheelCountTable
    end
    for i = 1, #bywheelCountTable do
        if bywheelCountTable[i][3][5] ~= 1 then
            local value = 0;
            if bywheelCountTable[i][3][3] == 1 then
                value = 1
            end
            if bywheelCountTable[i][3][4] == 1 then
                value = 2
            end
            local setynum = 1;
            for k = 1, #self.TwoWayBillTab do
                if self.TwoWayBillTab[k][1] ~= 0 then
                    setynum = k
                end ;
            end
            if self.TwoWayBillTab[setynum][1] == value then
                -- error("  -- 上一局和本局相同====" .. setynum)
                local setdata = self.TwoWayBillTab[setynum]
                local setpos = 0;
                local somelastnum = 0;
                for n = 1, #setdata do
                    if setdata[n] == 0 and setpos == 0 then
                        setpos = n
                    end
                    -- 代表空白位置
                    if setdata[n] == value then
                        somelastnum = n
                    end
                end
                if setpos == 0 then
                    -- 这一列已经满了
                    if somelastnum == 6 then
                        -- 最后一行
                        -- error("  -- 上一局和本局相同   -- 这一列已经满了" .. i)
                        local v = { 0, 0, 0, 0, 0, value };
                        local pos = { 0, 0, 0, 0, 0, i };
                        table.insert(self.TwoWayBillTab, #self.TwoWayBillTab + 1, v)
                        table.insert(self.TwoWayTabPos, #self.TwoWayTabPos + 1, pos)
                    elseif somelastnum < 6 then
                        if setynum == #self.TwoWayBillTab then
                            data = { 0, 0, 0, 0, 0, 0 }
                            data[somelastnum] = value;
                            local pos = { 0, 0, 0, 0, 0, 0 }
                            pos[somelastnum] = i;
                            table.insert(self.TwoWayBillTab, #self.TwoWayBillTab + 1, data)
                            table.insert(self.TwoWayTabPos, #self.TwoWayTabPos + 1, pos)
                        else
                            local iswhile = true

                            local newsetynum = setynum;
                            while iswhile do

                                if self.TwoWayBillTab[newsetynum][somelastnum] == value then
                                    local iswhile = true
                                    local ynum = somelastnum + 1;
                                    while iswhile do

                                        if self.TwoWayBillTab[newsetynum][ynum] == 0 then
                                            self.TwoWayBillTab[newsetynum][ynum] = value
                                            self.TwoWayTabPos[newsetynum][ynum] = i
                                            iswhile = false;
                                        elseif ynum > 6 then
                                            newsetynum = newsetynum + 1;
                                            iswhile = false;
                                        else
                                            ynum = ynum + 1;
                                        end
                                    end

                                elseif self.TwoWayBillTab[newsetynum][somelastnum] == 0 then
                                    self.TwoWayBillTab[newsetynum][somelastnum] = value
                                    self.TwoWayTabPos[newsetynum][somelastnum] = i
                                    iswhile = false;
                                end
                                local upsamenum = somelastnum;
                                if newsetynum > #self.TwoWayBillTab then
                                    local iswhile = true;
                                    while iswhile do
                                        if self.TwoWayBillTab[newsetynum - 1][upsamenum] == value then
                                            upsamenum = upsamenum + 1;
                                            if upsamenum > 6 then
                                                upsamenum = 6
                                                iswhile = false;
                                            end
                                        else
                                            iswhile = false
                                        end
                                    end
                                    data = { 0, 0, 0, 0, 0, 0 }
                                    data[upsamenum] = value;
                                    local pos = { 0, 0, 0, 0, 0, 0 }
                                    pos[upsamenum] = i;
                                    table.insert(self.TwoWayBillTab, #self.TwoWayBillTab + 1, data)
                                    table.insert(self.TwoWayTabPos, #self.TwoWayTabPos + 1, pos)
                                    iswhile = false
                                end
                            end

                        end
                    end
                elseif setpos == 6 then
                    self.TwoWayBillTab[setynum][setpos] = value
                    self.TwoWayTabPos[setynum][setpos] = i
                elseif setpos < 6 then
                    if self.TwoWayBillTab[setynum][setpos + 1] ~= 0 then
                        -- 赋值位置下一位已经有位置（需要判断需要间隔不）
                        if self.TwoWayBillTab[setynum][setpos + 1] == value then
                            -- 需要空格向右加一
                            if setynum == #self.TwoWayBillTab then
                                for i = 1, 6 do
                                    if self.TwoWayBillTab[setynum][i] == value then
                                        somelastnum = i;
                                    end
                                end
                                data = { 0, 0, 0, 0, 0, 0 }
                                data[somelastnum] = value;
                                local pos = { 0, 0, 0, 0, 0, 0 }
                                pos[somelastnum] = i;

                                table.insert(self.TwoWayBillTab, #self.TwoWayBillTab + 1, data)
                                table.insert(self.TwoWayTabPos, #self.TwoWayTabPos + 1, pos)
                            else
                                local iswhile = true

                                local newsetynum = setynum;
                                while iswhile do
                                    if self.TwoWayBillTab[newsetynum][somelastnum] == value then
                                        newsetynum = newsetynum + 1;
                                    elseif self.TwoWayBillTab[newsetynum][somelastnum] == 0 then
                                        self.TwoWayBillTab[newsetynum][somelastnum] = value
                                        self.TwoWayTabPos[newsetynum][somelastnum] = i
                                        iswhile = false;
                                    end
                                    if newsetynum > #self.TwoWayBillTab then
                                        data = { 0, 0, 0, 0, 0, 0 }
                                        data[somelastnum] = value;
                                        local pos = { 0, 0, 0, 0, 0, 0 }
                                        pos[somelastnum] = i;
                                        table.insert(self.TwoWayBillTab, #self.TwoWayBillTab + 1, data)
                                        table.insert(self.TwoWayTabPos, #self.TwoWayTabPos + 1, pos)
                                        iswhile = false
                                    end
                                end

                            end
                        else
                            self.TwoWayBillTab[setynum][setpos] = value
                            self.TwoWayTabPos[setynum][setpos] = i
                            -- error("setpos < 6 ============setynum===" .. setynum .. "      setpos====" .. setpos);
                        end
                    else
                        self.TwoWayBillTab[setynum][setpos] = value
                        self.TwoWayTabPos[setynum][setpos] = i
                        -- error("setpos < 6 ============setynum===" .. setynum .. "      setpos====" .. setpos);
                    end
                end
            end ;
            --
            if self.TwoWayBillTab[setynum][1] == 0 then
                -- error("最后一列第一行是空值");
                self.TwoWayBillTab[#self.TwoWayBillTab][1] = value
                self.TwoWayTabPos[#self.TwoWayBillTab][1] = i
            end ;
            if self.TwoWayBillTab[setynum][1] ~= value then
                -- error("最后一列第一行是值与需要存得值不同");
                if setynum == #self.TwoWayBillTab then
                    --  error("添加新一行赋值=========setynum===" .. setynum);
                    data = { value, 0, 0, 0, 0, 0 }
                    local pos = { i, 0, 0, 0, 0, 0 }
                    table.insert(self.TwoWayBillTab, #self.TwoWayBillTab + 1, data)
                    table.insert(self.TwoWayTabPos, #self.TwoWayTabPos + 1, pos)
                else
                    --  error("不添加直接赋值");
                    self.TwoWayBillTab[setynum + 1][1] = value
                    self.TwoWayTabPos[setynum + 1][1] = i
                end
            end ;
        end
    end
    -- 获取位置完成开始创建位置
    local setvaluepos = 1;
    for i = 1, #self.TwoWayBillTab do
        for k = 1, #self.TwoWayBillTab[i] do
            -- 0创建空白图片
            if tonumber(self.TwoWayBillTab[i][k]) == 0 then
                self.CreatWayBillPrefeb(0, self.WayBillMain_Two, (i - 1) * 6 + k)
            end
            -- 1创建闲家图片
            if tonumber(self.TwoWayBillTab[i][k]) == 1 then
                --while bywheelCountTable[setvaluepos][3][5] == 1 do setvaluepos = setvaluepos + 1; error("s = " .. setvaluepos); end
                self.CreatWayBillPrefeb(self.TwoWayTabPos[i][k], self.WayBillMain_Two, (i - 1) * 6 + k)
                setvaluepos = setvaluepos + 1
            end
            -- 2创建庄家图片
            if tonumber(self.TwoWayBillTab[i][k]) == 2 then
                --while bywheelCountTable[setvaluepos][3][5] == 1 do setvaluepos = setvaluepos + 1;  error("s = " .. setvaluepos); end
                self.CreatWayBillPrefeb(self.TwoWayTabPos[i][k], self.WayBillMain_Two, (i - 1) * 6 + k)
                setvaluepos = setvaluepos + 1
            end
            --error("  4-- 获取位置完成开始创建位置 i " .. i .. " k " .. k);
        end
    end
    -- 设置长度
    --    local allcount = 0;
    --    if #self.TwoWayBillTab < 20 then allcount =(20 - #self.TwoWayBillTab) * 26 end
    --    local w = #self.TwoWayBillTab * 26 + 10 + allcount;
    --    self.WayBillMain_Two.transform:GetComponent("RectTransform").sizeDelta = Vector2.New(w, 162)
    --    self.WayBillMain_Two.transform.localPosition = Vector3.New(((350 - w) / 2) + allcount, 0, 0)
    BaccaraPanel.SetTwoWayBillSize(#self.TwoWayBillTab);

end

--设置录单2大小 iBillCol 录单挡墙列数 bRestore 是否还原本来大小
function BaccaraPanel.SetTwoWayBillSize(iBillCol, bRestore)
    if (iBillCol <= C_BALL_BASE_COL and not bRestore) then
        return ;
    end
    local comLayout = self.WayBillMain_Two.transform:GetComponent('GridLayoutGroup');
    local fChange = (comLayout.cellSize.x + comLayout.spacing.x) * iBillCol;
    local comRectTra = self.WayBillMain_Two.transform:GetComponent("RectTransform");
    --comRectTra.sizeDelta = Vector2.New(comRectTra.sizeDelta.x + fChange * (#self.TwoWayBillTab - c_iBaseCol), comRectTra.sizeDelta.y);
    comRectTra.sizeDelta = Vector2.New(fChange + comLayout.spacing.x, comRectTra.sizeDelta.y);
end

-- 记录上一局路单2
function BaccaraPanel.RecordWayBillInfo_Two()
end
-- 记录上局路单信息
function BaccaraPanel.RecordWayBillInfo()
    logYellow("=======================记录上局路单信息=======================================");
    if #bywheelCountTable == 0 then
        logYellow("=======================清除录单=======================================");
        for i = 0, self.WayBillMain.transform.childCount - 1 do
            local go = self.WayBillMain.transform:GetChild(i).gameObject
            go.transform:Find("Num"):GetComponent("Text").text = " ";
            go.transform:GetComponent("Image").sprite = self.WayBillImg.transform:GetChild(3):GetComponent("Image").sprite
            go.transform:Find("xian").gameObject:SetActive(false);
            go.transform:Find("zhuang").gameObject:SetActive(false);
            go.transform:Find("ImageType").gameObject:SetActive(false);
        end
        for i = 0, self.WayBillMain_Two.transform.childCount - 1 do
            local go = self.WayBillMain_Two.transform:GetChild(i).gameObject
            go.transform:GetComponent("Image").sprite = self.WayBillImg.transform:GetChild(3):GetComponent("Image").sprite
            go.transform:Find("Num"):GetComponent("Text").text = " ";
            go.transform:Find("xian").gameObject:SetActive(false);
            go.transform:Find("zhuang").gameObject:SetActive(false);
            go.transform:Find("ImageType").gameObject:SetActive(false);
        end
        BaccaraPanel.SetTwoWayBillSize(C_BALL_BASE_COL, true);
        return ;
    end
    self.CreatWayBillPrefeb(#bywheelCountTable, self.WayBillMain)
    error("-- 记录上局路单信息");
    -- self.RecordWayBillInfo_Two()
    self.TwoWayBillTab = {};
    self.TwoWayTabPos = {};
    self.SetTwoWayBillValue()
end
function BaccaraPanel.CreatWayBillPrefeb(i, father, child)
    local go = nil;
    if i == 0 then
        if child > father.transform.childCount then
            go = newobject(self.WayBillImg.transform:GetChild(3).gameObject);
            go.transform:SetParent(father.transform);
            go.transform.localScale = Vector3.one;
            go.transform:Find("Num"):GetComponent("Text").text = " ";
            go.transform:Find("xian").gameObject:SetActive(false);
            go.transform:Find("zhuang").gameObject:SetActive(false);
            go:SetActive(true);
        else
            go = father.transform:GetChild(child - 1).gameObject
            father.transform:GetChild(child - 1).gameObject:SetActive(true);
            go.transform:GetComponent("Image").sprite = self.WayBillImg.transform:GetChild(3):GetComponent("Image").sprite
            go.transform:Find("Num"):GetComponent("Text").text = " ";
            go.transform:Find("xian").gameObject:SetActive(false);
            go.transform:Find("zhuang").gameObject:SetActive(false);
        end
        return
    end
    local num = 0
    if bywheelCountTable[i][3][3] == 1 then
        num = 0
    end
    if bywheelCountTable[i][3][4] == 1 then
        num = 1
    end
    if bywheelCountTable[i][3][5] == 1 then
        num = 2
    end
    if child == nil then
        if i > father.transform.childCount then
            go = newobject(self.WayBillImg.transform:GetChild(num).gameObject)
            go.transform:SetParent(father.transform);
            go.transform.localScale = Vector3.one;
            go:SetActive(true);
        else
            go = father.transform:GetChild(i - 1).gameObject
            father.transform:GetChild(i - 1).gameObject:SetActive(true);
        end

    else
        if child > father.transform.childCount then
            local traClone = self.WayBillImg.transform:GetChild(num);
            if (father.name == "Main" and traClone.name ~= "tmt") then
                go = BaccaraPanel.CreatWayBill_Add(father.transform);
            else
                go = newobject(traClone.gameObject)
                go.transform:SetParent(father.transform);
                go.transform.localScale = Vector3.one;
                go:SetActive(true);
            end

        else
            go = father.transform:GetChild(child - 1).gameObject;
            father.transform:GetChild(child - 1).gameObject:SetActive(true);
        end
    end
    go.transform:Find("xian").gameObject:SetActive(false);
    go.transform:Find("zhuang").gameObject:SetActive(false);
    if bywheelCountTable[i][3][1] == 1 then
        go.transform:Find("xian").gameObject:SetActive(true);
    end
    if bywheelCountTable[i][3][2] == 1 then
        go.transform:Find("zhuang").gameObject:SetActive(true);
    end

    go.transform:Find("ImageType"):GetComponent("Image").sprite = self.WayBillImg.transform:GetChild(num):GetComponent("Image").sprite
    go.transform:Find("ImageType"):GetComponent('Image'):SetNativeSize();
    go.transform:Find("ImageType").gameObject:SetActive(true);

    if bywheelCountTable[i][1] > bywheelCountTable[i][2] then
        go.transform:Find("Num"):GetComponent("Text").text = bywheelCountTable[i][1];
    elseif bywheelCountTable[i][1] < bywheelCountTable[i][2] then
        go.transform:Find("Num"):GetComponent("Text").text = bywheelCountTable[i][2];
    elseif bywheelCountTable[i][1] == bywheelCountTable[i][2] then
        go.transform:Find("Num"):GetComponent("Text").text = bywheelCountTable[i][2];
    end
end

function BaccaraPanel.CreatWayBill_Add(tabParent)
    local go = newobject(self.WayBillImg.transform:GetChild(3).gameObject);
    go.name = "myCreat"
    go.transform:SetParent(tabParent);
    go.transform.localScale = Vector3.one;
    go.transform:Find("Num"):GetComponent("Text").text = " ";
    go.transform:Find("xian").gameObject:SetActive(false);
    go.transform:Find("zhuang").gameObject:SetActive(false);
    go:SetActive(true);
    return go;
end

function BaccaraPanel.SetTwoWayBill(args)
    self.HideShowWayBillBtn:SetActive(true);
    self.ShouqiWayBillBtn:SetActive(false);
    args.transform:GetComponent("Button").interactable = false

    local iMoveY = 0;
    if not (Util.isPc) and not (Util.isEditor) then
        iMoveY = iWayBillPhonePosY0;
    else
        iMoveY = iWayBillPCPosY0;
    end

    local tweener = self.WayBill.transform:DOLocalMoveY(iMoveY, 0.5, false);
    tweener:SetEase(DG.Tweening.Ease.Linear);
    args.transform:GetComponent("Button").interactable = true
end
-- 显示隐藏路单
function BaccaraPanel.HideShowWayBillBtnOnClick(args)

    local fBaseW = self.WayBillMain_Two.transform.parent:GetComponent("RectTransform").sizeDelta.x;
    local comRectTra = self.WayBillMain_Two.transform:GetComponent("RectTransform");
    local comLayout = self.WayBillMain_Two.transform:GetComponent('GridLayoutGroup');
    local fdif = comRectTra.sizeDelta.x - fBaseW; --移动框宽度与基础框宽度差值

    if (comRectTra.sizeDelta.x - fBaseW >= comLayout.cellSize.x and comRectTra.sizeDelta.x - fBaseW > 0) then
        self.WayBillMain_Two.transform.localPosition = Vector3.New(-fdif / 2, 0, 0);
    end

    self.ShouqiWayBillBtn:SetActive(true);
    self.HideShowWayBillBtn:SetActive(false);
    args.transform:GetComponent("Button").interactable = false;
    local iMoveY = 0;
    if not (Util.isPc) and not (Util.isEditor) then
        iMoveY = iWayBillPhonePosY;
    else
        iMoveY = iWayBillPCPosY;
    end
    local tweener = self.WayBill.transform:DOLocalMoveY(iMoveY, 0.5, false);
    tweener:SetEase(DG.Tweening.Ease.Linear);

    args.transform:GetComponent("Button").interactable = true;
end

-- 庄家信息
-- 初始化庄家信息
function BaccaraPanel.BankerInfoMethod()
end

-- 更新庄家信息
function BaccaraPanel.UpdateBankerInfoMethod()
end

-- 等待上庄下拉列表
function BaccaraPanel.BankerMoreBtnOnClick(args)

end

-- 申请上下庄事件
function BaccaraPanel.ApplyOrDownBankerBtnOnClick(args)

end

-- 下注区域信息初始化
function BaccaraPanel.BetAreaMethod(isFirst)
    --	logYellow("BetAreaMethod");
    IsWaiteUpdate = false;
    if IsNumValue then
        IsNumValue = false;
        for i = 1, #limitMaxChipTable do
            local num = limitMaxChipTable[i];
            StartlimitMaxChipTable[i] = num;
        end
    end

    for i = 1, #limitMaxChipTable do
        self.ShowChipScore.transform:GetChild(i - 1):Find("Text"):GetComponent("Text").text = "limit：" .. limitMaxChipTable[i]
    end

    if #MyselfChipValueTable == #C_CHIP_AREA_BTN then

        for i = 1, #MyselfChipValueTable do
            self.BetAreaChipNumBg.transform:GetChild(i - 1):Find("myselfChip"):GetComponent('Image').enabled = false;
            self.BetAreaChipNumBg.transform:GetChild(i - 1):Find("myselfChip/Text"):GetComponent('Text').text = "  ";
            if MyselfChipValueTable[i] > 0 then
                self.BetAreaChipNumBg.transform:GetChild(i - 1):Find("myselfChip"):GetComponent('Image').enabled = true;
                self.BetAreaChipNumBg.transform:GetChild(i - 1):Find("myselfChip/Text"):GetComponent('Text').text = MyselfChipValueTable[i];
            end
        end

        local datanum = 0;
        for i = 1, #AllChipValueTable do
            self.CreatShowNum(self.ChipNum.transform:Find("Two").gameObject, self.BetAreaChipNumBg.transform:GetChild(i - 1):Find("AllChipValue").gameObject, AllChipValueTable[i])
        end
        self.OtherPlayerChipAnimation(isFirst);
    else
        for i = 1, #C_CHIP_AREA_BTN do
            self.BetAreaChipNumBg.transform:GetChild(i - 1):Find("myselfChip/Text"):GetComponent('Text').text = "  ";
            self.CreatShowNum(self.ChipNum.transform:Find("Two").gameObject, self.BetAreaChipNumBg.transform:GetChild(i - 1):Find("AllChipValue").gameObject, 0)
        end
    end

    --	logYellow("BetAreaMethod end");
end
-- 座位玩家下注
function BaccaraPanel.Sit_OtherPlayerChip(playerid, datanum, areanum)
    local t = self.ChipNumChangeTable(datanum);
    local chairnum = 0;
    for i = 1, #self.PlayerShowInfo do
        if self.PlayerShowInfo[i] == playerid then
            chairnum = i;
        end
    end
    local go = self.Player_other.transform:GetChild(chairnum - 1).gameObject;

    local startpos = 0;
    local creatnum = 0;
    startpos = go.transform.position
    for j = 1, #t do
        if t[j] > 0 then
            creatnum = creatnum + 1;
            if creatnum < 3 then
                self.OtherPlayerDOTween(self.ChipImg.transform:GetChild(#t - j).gameObject, t[j], areanum, startpos);
            end
        end
    end
end
-- 玩家下注动画效果
function BaccaraPanel.OtherPlayerChipAnimation(bl)
    -- error("玩家下注动画")
    local startobj = self.ChipImg.transform:GetChild(0).gameObject;
    for i = 1, #AllChipValueTable do
        if bl then
            local t = self.ChipNumChangeTable(AllChipValueTable[i])
            self.CreateChiping(self.ChipImg.transform:GetChild(3).gameObject, t[1], i);
            self.CreateChiping(self.ChipImg.transform:GetChild(2).gameObject, t[2], i);
            self.CreateChiping(self.ChipImg.transform:GetChild(1).gameObject, t[3], i);
            self.CreateChiping(self.ChipImg.transform:GetChild(0).gameObject, t[4], i);
        else
            if CreatingAllChip[i] == AllChipValueTable[i] then
                -- 总下注与上次创建金币数相同
            elseif CreatingAllChip[i] < AllChipValueTable[i] then
                --            -- 不是玩家下注
                local datanum = AllChipValueTable[i] - CreatingAllChip[i];
                local t = self.ChipNumChangeTable(datanum);
                local startpos = 0;

                if CreatingMyselfChip[i] < MyselfChipValueTable[i] then
                    startpos = BaccaraCanvas.transform:Find("Bg/ChipBtn/" .. ChooseChipName).position;
                end
                local creatnum = 0;
                for j = 1, #t do
                    if t[j] > 0 then
                        creatnum = creatnum + 1;
                        if creatnum < 3 then
                            self.OtherPlayerDOTween(self.ChipImg.transform:GetChild(#t - j).gameObject, t[j], i, startpos);
                        end
                    end
                end
                CreatingAllChip[i] = AllChipValueTable[i];
                CreatingMyselfChip[i] = MyselfChipValueTable[i];
            end
        end
    end
    for i = 1, #AllChipValueTable do
        CreatingAllChip[i] = AllChipValueTable[i];
        CreatingMyselfChip[i] = MyselfChipValueTable[i];
    end
    -- error("玩家下注动画完成")
end
-- 创建筹码
function BaccaraPanel.CreateChiping(prefeb, num, parentnum)
    -- logYellow("prefeb  = " .. prefeb.name  .."  num =  " ..  num .. "   parentnum = " .. parentnum);
    for i = 1, num do
        local go = newobject(prefeb);
        go:SetActive(true);
        go.transform:SetParent(self.BetArea.transform:GetChild(parentnum - 1):Find("ChipAnimation"));
        go.transform.localScale = Vector3.New(chipsclae, chipsclae, chipsclae);
        go:GetComponent('RectTransform').sizeDelta = Vector2.New(155, 155);
        local vet2 = self.BetArea.transform:GetChild(parentnum - 1):Find("ChipAnimation"):GetComponent('RectTransform').sizeDelta;
        go.transform.localPosition = Vector3.New(((vet2.x / 2) - 30 - math.random(0, (vet2.x - 60))), ((vet2.y / 2) - 30 - math.random(0, (vet2.y - 60))), 0);
    end
end
local destroyObject = {};
-- 其他玩家下注startpos(0代表其他玩家下注，vetcor3代码自己,座位玩家)
function BaccaraPanel.OtherPlayerDOTween(prefeb, num, parentnum, startpos)
    if num == 0 then
        return
    end
    local k = math.random(1, 30);
    for i = 1, num do
        local go = nil;
        CHipAreaNum[parentnum] = CHipAreaNum[parentnum] + 1;
        local pos = Vector3.New(0, 0, 0);
        local vet2 = self.BetArea.transform:GetChild(parentnum - 1):Find("ChipAnimation"):GetComponent('RectTransform').sizeDelta;
        pos = Vector3.New(((vet2.x / 2) - 30 - math.random(0, (vet2.x - 60))), ((vet2.y / 2) - 30 - math.random(0, (vet2.y - 60))), 0);
        if CHipAreaNum[parentnum] > 40 and startpos == 0 then
            go = self.BetArea.transform:GetChild(parentnum - 1):Find("ChipAnimation"):GetChild(k).gameObject
            pos = self.BetArea.transform:GetChild(parentnum - 1):Find("ChipAnimation"):GetChild(k).localPosition;
        else
            go = newobject(prefeb);
            go:SetActive(true);
        end

        go.transform:SetParent(self.BetArea.transform:GetChild(parentnum - 1):Find("ChipAnimation"));
        go.transform.localScale = Vector3.New(chipsclae, chipsclae, chipsclae);
        go:GetComponent('RectTransform').sizeDelta = Vector2.New(156, 155);
        if startpos == 0 then
            go.transform.position = self.Player_other.transform:GetChild(5).position;
        else
            go.transform.position = startpos;
        end
        local tweener = go.transform:DOLocalMove(pos, 0.5, false);
        tweener:SetEase(DG.Tweening.Ease.OutCirc);
        --        tweener:OnComplete( function()
        --            if GameNextScenName ~= gameScenName.Baccara then return end;
        --            if CHipAreaNum[parentnum] > 40 then
        --                destroy(destroyObject[#destroyObject])
        --            end
        --        end );
    end
end


-- 创建数字Img显示对象
-- 第一个参数：父版（prefeb）
-- 第二个参数：新建物体的父物体（fatherprefeb）
-- 第三个参数：num数字
function BaccaraPanel.CreatShowNum(prefeb, fatherprefeb, num)
    error("数字============" .. num)
    for i = 1, string.len(num) do
        local prefebnum = string.sub(num, i, i);
        if fatherprefeb.transform.childCount > string.len(num) then
            for j = string.len(num), fatherprefeb.transform.childCount - 1 do
                destroy(fatherprefeb.transform:GetChild(j).gameObject);
            end
        end
        if fatherprefeb.transform.childCount < i then
            local go2 = newobject(prefeb.transform:GetChild(tonumber(prefebnum)).gameObject);
            go2:SetActive(true);
            go2.transform:SetParent(fatherprefeb.transform);
            go2.transform.localScale = Vector3.one;
            go2.transform.localPosition = Vector3.New(0, 0, 0);
            go2.name = prefebnum;
        else
            if tonumber(prefebnum) ~= tonumber(fatherprefeb.transform:GetChild(i - 1).gameObject.name) and prefebnum ~= "-" then
                fatherprefeb.transform:GetChild(i - 1).gameObject.name = prefebnum;
                error("显示数字=================" .. prefebnum);
                fatherprefeb.transform:GetChild(i - 1).gameObject:GetComponent('Image').sprite = prefeb.transform:GetChild(tonumber(prefebnum)).gameObject:GetComponent('Image').sprite;
            end
        end
    end
    --    if num == 0 then
    --        fatherprefeb.transform:GetChild(0).gameObject:SetActive(false);
    --    else
    --        fatherprefeb.transform:GetChild(0).gameObject:SetActive(true);
    --    end;
end
-- 初始化场景
function BaccaraPanel.InitializingScene()
    self.SceneHint:SetActive(false);
    --  self.SceneHint.transform:Find("Image/Image"):GetComponent('Image').fillAmount = 1;
    error("GameState[i]=======================" .. GameState);
    if GameState == BaccaraMH.GAME_STATE_CHIP then
        self.ChipBtn.transform.localPosition = Vector3.New(0, -311, 0)
        for i = 0, self.BetAreaBg.transform.childCount - 1 do
            if string.find(self.BetAreaBg.transform:GetChild(i).gameObject.name, "Btn") then
                self.BetAreaBg.transform:GetChild(i):GetComponent("Button").interactable = true;
            end
        end
        self.ChipTime = math.floor(BaccaraMH.TIMER_CHIP - OldTime / 1000);
        -- self.SceneHint.transform:Find("Image/Image"):GetComponent('Image').fillAmount =(self.ChipTime / BaccaraMH.TIMER_CHIP);
        coroutine.start(self.WaitUpdate);
        self.SceneHint:SetActive(true);
        -- coroutine.start(self.JianTiming);
    else
        self.ChipBtn.transform.localPosition = Vector3.New(0, -500, 0)
        for i = 0, self.BetAreaBg.transform.childCount - 1 do
            if string.find(self.BetAreaBg.transform:GetChild(i).gameObject.name, "Btn") then
                self.BetAreaBg.transform:GetChild(i):GetComponent("Button").interactable = false;
            end
        end
        self.SendCardBg.transform.localPosition = Vector3.New(0, 0, 0);

        self.SendCardBg:SetActive(true);
        -- 游戏状态展现模式
        if GameState == BaccaraMH.GAME_STATE_SHUFFLE_POKER then
            -- 洗牌
            self.SendCardBg.transform.localPosition = Vector3.New(0, 3000, 0);
            self.SendCardBg:SetActive(false);
            IsNumValue = true;
            bywheelCountTable = {};
            self.RecordWayBillInfo();
        elseif GameState == BaccaraMH.GAME_STATE_STOP_CHIP then
            -- 停止下注
            error("停止下注");
            self.SendCardBg.transform.localPosition = Vector3.New(0, 3000, 0);
            self.SendCardBg:SetActive(false);
            self.MipaiAni:SetActive(false);
            self.MipaiAni_NoMipai:SetActive(false);
            self.SceneHint:SetActive(false);
            self.SceneHint.transform:Find("Image/Image"):GetComponent('Image').fillAmount = 1;
            error("停止下注完成");
        elseif GameState == BaccaraMH.GAME_STATE_SEND_POKER then
            -- 发牌
            self.SendCardBg.transform.localPosition = Vector3.New(0, 0, 0);

            self.SendCardBg:SetActive(true);
            for i = 0, self.ShowPlayerCard.transform.childCount - 1 do
                self.ShowPlayerCard.transform:GetChild(i).localPosition = Vector3.New(-poketw + (i * poketw), 0, 0);
            end
            for i = 0, self.ShowBankerCard.transform.childCount - 1 do
                self.ShowBankerCard.transform:GetChild(i).localPosition = Vector3.New(-poketw + (i * poketw), 0, 0);
            end
            self.MipaiAni:SetActive(false);
            self.MipaiAni_NoMipai:SetActive(false);
            self.ShowPlayerCard.transform.localPosition = Vector3.New(-160, 280, 0);
            self.ShowBankerCard.transform.localPosition = Vector3.New(260, 280, 0);
        elseif GameState == BaccaraMH.GAME_STATE_PEEKPOKER_X then
            -- 闲家眯牌
            self.SendCardBg.transform.localPosition = Vector3.New(0, 0, 0);

            self.SendCardBg:SetActive(true);
            for i = 0, self.ShowPlayerCard.transform.childCount - 1 do
                self.ShowPlayerCard.transform:GetChild(i).localPosition = Vector3.New(-poketw + (i * poketw), 0, 0);
            end
            for i = 0, self.ShowBankerCard.transform.childCount - 1 do
                self.ShowBankerCard.transform:GetChild(i).localPosition = Vector3.New(-poketw + (i * poketw), 0, 0);
            end
            -- self.MipaiAni:SetActive(true);
            -- self.MipaiAni_NoMipai:SetActive(true);
            self.SendCardBg.transform.localPosition = Vector3.New(0, 0, 0);

            self.SendCardBg:SetActive(true);
        elseif GameState == BaccaraMH.GAME_STATE_PEEKPOKER_Z then
            -- 庄家眯牌
            self.SendCardBg.transform.localPosition = Vector3.New(0, 0, 0);
            self.SendCardBg:SetActive(true);
            for i = 0, self.ShowPlayerCard.transform.childCount - 1 do
                self.ShowPlayerCard.transform:GetChild(i).localPosition = Vector3.New(-poketw + (i * poketw), 0, 0);
            end
            for i = 0, self.ShowBankerCard.transform.childCount - 1 do
                self.ShowBankerCard.transform:GetChild(i).localPosition = Vector3.New(-poketw + (i * poketw), 0, 0);
            end
            -- self.MipaiAni:SetActive(true);
            -- self.MipaiAni_NoMipai:SetActive(true);
            self.SendCardBg.transform.localPosition = Vector3.New(0, 0, 0);
            self.SendCardBg:SetActive(true);
        elseif GameState == BaccaraMH.GAME_STATE_PLAYER_ADD_POKER then
            -- 闲家补牌
            if not (IsNil(BaccaraMusic)) then
                local musicchip = BaccaraMusic.transform:Find("Baccarat_xian_bu"):GetComponent('AudioSource').clip
                MusicManager:PlayX(musicchip);
            end
            self.CheckDealMethod(true, 1)
            self.CheckDealMethod(true, 2)
            self.ShowPlayerCard.transform.localPosition = Vector3.New(-210, 280, 0);
            self.MipaiAni:SetActive(false);
            self.MipaiAni_NoMipai:SetActive(false);
            self.SendCardBg.transform.localPosition = Vector3.New(0, 0, 0);
            self.SendCardBg:SetActive(true);
            for i = 0, self.ShowPlayerCard.transform.childCount - 1 do
                self.ShowPlayerCard.transform:GetChild(i).localPosition = Vector3.New(-poketw + (i * poketw), 0, 0);
            end
            for i = 0, self.ShowBankerCard.transform.childCount - 1 do
                self.ShowBankerCard.transform:GetChild(i).localPosition = Vector3.New(-poketw + (i * poketw), 0, 0);
            end
        elseif GameState == BaccaraMH.GAME_STATE_PEEKADDPOKER_X then
            ----//眯牌_闲家_加
        elseif GameState == BaccaraMH.GAME_STATE_BANKER_ADD_POKER then
            -- 庄家补牌
            error("庄家补牌");
            if not (IsNil(BaccaraMusic)) then
                local musicchip = BaccaraMusic.transform:Find("Baccarat_zhuang_bu"):GetComponent('AudioSource').clip
                MusicManager:PlayX(musicchip);
            end
            self.CheckDealMethod(true, 1)
            self.CheckDealMethod(true, 2)
            self.ShowBankerCard.transform.localPosition = Vector3.New(210, 280, 0);
            self.MipaiAni:SetActive(false);
            self.MipaiAni_NoMipai:SetActive(false);
            self.SendCardBg.transform.localPosition = Vector3.New(0, 0, 0);
            self.SendCardBg:SetActive(true);
            for i = 0, self.ShowPlayerCard.transform.childCount - 1 do
                self.ShowPlayerCard.transform:GetChild(i).localPosition = Vector3.New(-poketw + (i * poketw), 0, 0);
            end
            for i = 0, self.ShowBankerCard.transform.childCount - 1 do
                self.ShowBankerCard.transform:GetChild(i).localPosition = Vector3.New(-poketw + (i * poketw), 0, 0);
            end
            error("庄家补牌结束");
        elseif GameState == BaccaraMH.GAME_STATE_PEEKADDPOKER_Z then
        elseif GameState == BaccaraMH.GAME_STATE_GAME_OVER then
            -- 游戏结束
            error("游戏结束1");
            self.CheckDealMethod(true, 1)
            self.CheckDealMethod(true, 2)
            self.MipaiAni:SetActive(false);
            self.MipaiAni_NoMipai:SetActive(false);
            self.SendCardBg.transform.localPosition = Vector3.New(0, 0, 0);
            self.SendCardBg:SetActive(true);
            --   error("游戏结束==================");
            self.CheckDealMethod(true, 1)
            self.CheckDealMethod(true, 2)
            IsNumValue = true;
            CHipAreaNum = { 0, 0, 0, 0, 0 };
            if OldTime < 2000 then
                for i = 0, self.ShowPlayerCard.transform.childCount - 1 do
                    self.ShowPlayerCard.transform:GetChild(i).localPosition = Vector3.New(-poketw + (i * poketw), 0, 0);

                end
                for i = 0, self.ShowBankerCard.transform.childCount - 1 do
                    self.ShowBankerCard.transform:GetChild(i).localPosition = Vector3.New(-poketw + (i * poketw), 0, 0);
                end
                local childnum = 0;
                for i = 1, #AllChipValueTable do
                    childnum = childnum + AllChipValueTable[i];
                end
                if childnum > 0 then
                    self.ResetGame();
                else
                    self.GameOver()
                end
            else
                for i = 0, self.ShowPlayerCard.transform.childCount - 1 do
                    destroy(self.ShowPlayerCard.transform:GetChild(i).gameObject)
                end
                for i = 0, self.ShowBankerCard.transform.childCount - 1 do
                    destroy(self.ShowBankerCard.transform:GetChild(i).gameObject)
                end
                -- 播放结果动画(播放结束、重置)
                -- 金币消失
                for i = 1, #ChipWinOrLoseState do
                    self.BetAreaChipNumBg.transform:GetChild(i - 1):Find("myselfChip/Text"):GetComponent('Text').text = "  ";
                    self.BetAreaChipNumBg.transform:GetChild(i - 1):Find("myselfChip"):GetComponent('Image').enabled = false;
                    self.CreatShowNum(self.ChipNum.transform:Find("Two").gameObject, self.BetAreaChipNumBg.transform:GetChild(i - 1):Find("AllChipValue").gameObject, 0);
                    local destroyObj = self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation").gameObject;
                    for j = 0, destroyObj.transform.childCount - 1 do
                        destroy(destroyObj.transform:GetChild(j).gameObject);
                    end
                end
            end
            error("游戏结束2");
        elseif GameState == BaccaraMH.GAME_STATE_GAME_WAIT then
            error("游戏等待")
            self.SendCardBg.transform.localPosition = Vector3.New(0, 3000, 0);
            self.SendCardBg:SetActive(false);
            self.MipaiAni:SetActive(false);
            self.MipaiAni_NoMipai:SetActive(false);
            self.SceneHint:SetActive(false);
            self.SceneHint.transform:Find("Image/Image"):GetComponent('Image').fillAmount = 1;
        end
    end
end

-- 设置游戏状态
function BaccaraPanel.ShowScenes()
    -- 是否可以下注
    -- error("当前状态:"..GameState)
    if GameNextScenName ~= gameScenName.Baccara then
        return
    end ;
    if GameState == BaccaraMH.GAME_STATE_CHIP then
        -- error("下注1");
        for i = 0, self.BetAreaBg.transform.childCount - 1 do
            if string.find(self.BetAreaBg.transform:GetChild(i).gameObject.name, "Btn") then
                self.BetAreaBg.transform:GetChild(i):GetComponent("Button").interactable = true;
            end
        end
        -- error("下注2");
    else
        for i = 0, self.BetAreaBg.transform.childCount - 1 do
            if string.find(self.BetAreaBg.transform:GetChild(i).gameObject.name, "Btn") then
                self.BetAreaBg.transform:GetChild(i):GetComponent("Button").interactable = false;
            end
        end
    end
    -- 游戏状态展现模式
    if GameState == BaccaraMH.GAME_STATE_SHUFFLE_POKER then
        -- error("洗牌状态1")
        -- 洗牌
        CHipAreaNum = { 0, 0, 0, 0, 0 };
        --     error("洗牌");
        -- 播放洗牌动画
        -- self.PlayCardAnimator:SetActive(true);
        self.ClearPoker:SetActive(true);
        bywheelCountTable = {};
        for i = 1, #ChipWinOrLoseState do
            self.BetAreaChipNumBg.transform:GetChild(i - 1):Find("myselfChip/Text"):GetComponent('Text').text = "  ";
            self.CreatShowNum(self.ChipNum.transform:Find("Two").gameObject, self.BetAreaChipNumBg.transform:GetChild(i - 1):Find("AllChipValue").gameObject, 0);
        end
        self.MipaiAni:SetActive(false);
        self.MipaiAni_NoMipai:SetActive(false);
        bywheelCountTable = {};
        self.RecordWayBillInfo();
        -- error("洗牌状态2")
        -- self.ClearPoker:GetComponent("Animator"):Play();
    elseif GameState == BaccaraMH.GAME_STATE_CHIP then
        -- 显示下注时间
        -- error("显示下注时间");
        self.ClearPoker:SetActive(false);
        self.StartChipAni:SetActive(true);
        -- self.StartChipAni:GetComponent("Animator"):Play();
        self.MipaiAni:SetActive(false);
        self.MipaiAni_NoMipai:SetActive(false);
        for i = 1, #ChipWinOrLoseState do
            self.BetAreaChipNumBg.transform:GetChild(i - 1):Find("myselfChip/Text"):GetComponent('Text').text = "  ";
            self.CreatShowNum(self.ChipNum.transform:Find("Two").gameObject, self.BetAreaChipNumBg.transform:GetChild(i - 1):Find("AllChipValue").gameObject, 0);
        end
        self.ChipTime = BaccaraMH.TIMER_CHIP;

        self.SureClearUp();
        -- self.SceneHint.transform:Find("Image/Image"):GetComponent('Image'):GetComponent('Image').fillAmount =(self.ChipTime / BaccaraMH.TIMER_CHIP);
        self.SceneHint:SetActive(true);
        self.SceneHint.transform:Find("TextTitle").gameObject:SetActive(true);
        self.ChipCountDownTimeNum.transform:GetChild(0):GetComponent('Text').text = self.ChipTime
        -- coroutine.start(self.JianTiming);
        -- error("显示下注时间1");
    elseif GameState == BaccaraMH.GAME_STATE_STOP_CHIP then
        -- 停止下注
        -- error("停止下注1");
        self.SceneHint:SetActive(false);
        self.StartChipAni:SetActive(false);
        CHipAreaNum = { 0, 0, 0, 0, 0 };
        self.MipaiAni:SetActive(false);
        self.MipaiAni_NoMipai:SetActive(false);
        for i = 1, #MyselfChipValueTable do
            if MyselfChipValueTable[i] > 0 then
                self.BetAreaChipNumBg.transform:GetChild(i - 1):Find("myselfChip"):GetComponent('Image').enabled = true;
                self.BetAreaChipNumBg.transform:GetChild(i - 1):Find("myselfChip/Text"):GetComponent('Text').text = MyselfChipValueTable[i];
            else
                self.BetAreaChipNumBg.transform:GetChild(i - 1):Find("myselfChip"):GetComponent('Image').enabled = false;
                self.BetAreaChipNumBg.transform:GetChild(i - 1):Find("myselfChip/Text"):GetComponent('Text').text = "  ";
            end
        end
        local datanum = 0;
        for i = 1, #AllChipValueTable do
            self.CreatShowNum(self.ChipNum.transform:Find("Two").gameObject, self.BetAreaChipNumBg.transform:GetChild(i - 1):Find("AllChipValue").gameObject, AllChipValueTable[i])
        end
        IsChipBL = false;
        self.ChipTime = 0;
        -- self.SceneHint.transform:Find("Image/Image"):GetComponent('Image').fillAmount =(self.ChipTime / BaccaraMH.TIMER_CHIP);
        self.SceneHint:SetActive(false);
        -- error("停止下注2");
        -- 播放停止动画，已经所有的按钮区域不可下注
    elseif GameState == BaccaraMH.GAME_STATE_SEND_POKER then
        -- error("开始发牌")
        self.SceneHint:SetActive(false);
        self.MipaiAni:SetActive(false);
        self.MipaiAni_NoMipai:SetActive(false);
        self.SendCardBg.transform.localPosition = Vector3.New(0, 0, 0);
        self.SendCardBg:SetActive(true);
        for i = 1, #MyselfChipValueTable do
            LastChipNum = MyselfChipValueTable[i] + LastChipNum;
        end
        -- 发牌
        self.ShowPlayerCard.transform.localPosition = Vector3.New(-160, 280, 0);
        self.ShowBankerCard.transform.localPosition = Vector3.New(260, 280, 0);
        DealCardParset = self.ShowPlayerCard;
        SendPoker = {};
        for i = 1, BaccaraMH.D_HEADER_POKER_COUNT do
            table.insert(SendPoker, #SendPoker + 1, (string.split(Util.OutPutPokerValue(m_byPlayerPokerData[i]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byPlayerPokerData[i]), ",")[2]));
            -- table.insert(SendPoker, #SendPoker + 1,(self.Ten2tTwo(m_byPlayerPokerData[i])[1]) * 13 +(self.Ten2tTwo(m_byPlayerPokerData[i])[2]));
        end
        for i = 1, BaccaraMH.D_HEADER_POKER_COUNT do
            table.insert(SendPoker, #SendPoker + 1, (string.split(Util.OutPutPokerValue(m_byBankerPokerData[i]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byBankerPokerData[i]), ",")[2]));
            -- table.insert(SendPoker, #SendPoker + 1,(self.Ten2tTwo(m_byBankerPokerData[i])[1]) * 13 +(self.Ten2tTwo(m_byBankerPokerData[i])[2]));
        end

        local playercardNum = self.ShowPlayerCard.transform.childCount;
        local bankercardNum = self.ShowBankerCard.transform.childCount;
        if playercardNum >= 2 or bankercardNum >= 2 then
        else
            -- self.DealMethod(false);
            self.SendBackPoker();
        end
        -- error("开始发牌结束")
        -- 显示庄/闲值
    elseif GameState == BaccaraMH.GAME_STATE_PLAYER_ADD_POKER then
        -- 闲家补牌
        -- error("闲家补牌1");
        self.SceneHint:SetActive(false);
        self.ShowPlayerCard.transform.localPosition = Vector3.New(-210, 280, 0);
        self.MipaiAni:SetActive(false);
        self.MipaiAni_NoMipai:SetActive(false);
        local playercardNum = self.ShowPlayerCard.transform.childCount;
        if playercardNum >= 3 then
        else
            DealCardParset = self.ShowPlayerCard;
            SendPoker = {};
            table.insert(SendPoker, #SendPoker + 1, (string.split(Util.OutPutPokerValue(m_byPlayerPokerData[BaccaraMH.D_MAX_HANDER_POKER_COUNT]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byPlayerPokerData[BaccaraMH.D_MAX_HANDER_POKER_COUNT]), ",")[2]));
            self.DealMethod(true);
        end
        -- error("闲家补牌2");
        -- 显示闲家三张牌
    elseif GameState == BaccaraMH.GAME_STATE_BANKER_ADD_POKER then
        -- 庄家补牌
        -- error("庄家补牌1");
        self.SceneHint:SetActive(false);
        self.ShowBankerCard.transform.localPosition = Vector3.New(210, 280, 0);
        self.MipaiAni:SetActive(false);
        self.MipaiAni_NoMipai:SetActive(false);
        local bankercardNum = self.ShowBankerCard.transform.childCount;
        if bankercardNum >= 3 then
        else
            DealCardParset = self.ShowBankerCard;
            SendPoker = {};
            table.insert(SendPoker, #SendPoker + 1, (string.split(Util.OutPutPokerValue(m_byBankerPokerData[BaccaraMH.D_MAX_HANDER_POKER_COUNT]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byBankerPokerData[BaccaraMH.D_MAX_HANDER_POKER_COUNT]), ",")[2]));
            -- 显示庄家三张牌
            self.DealMethod(true);
        end
        -- error("庄家补牌2");
    elseif GameState == BaccaraMH.GAME_STATE_GAME_OVER then
        -- 显示庄家点数
        -- error("结束一局1");
        self.SceneHint:SetActive(false);
        self.MipaiAni:SetActive(false);
        self.MipaiAni_NoMipai:SetActive(false);
        -- error("bankerPoint====================" .. bankerPoint);
        self.BankerCardValue.transform:GetComponent('Image').sprite = self.ChipNum.transform:Find("One"):GetChild(bankerPoint).gameObject:GetComponent('Image').sprite;
        -- 显示闲家点数
        --  error("playerPoint====================" .. playerPoint);
        self.PlayerCardValue.transform:GetComponent('Image').sprite = self.ChipNum.transform:Find("One"):GetChild(playerPoint).gameObject:GetComponent('Image').sprite;
        CHipAreaNum = { 0, 0, 0, 0, 0 };
        -- 显示点数
        --  error(" -- 显示当前状态");
        self.SetChipWinOrLoseState();
        coroutine.start(self.ZoomPkoer);
        -- 记录路单
        --  error(" -- 记录路单");
        self.RecordWayBillInfo()
        -- error("结束一局2");
    end

end
function BaccaraPanel.SureClearUp()
    self.BankerCardPoint:SetActive(false);
    self.PlayerCardPoint:SetActive(false);
    self.WinLight:SetActive(false);
    if self.ShowBankerCard.transform.childCount > 0 then
        for i = 0, self.ShowBankerCard.transform.childCount - 1 do
            destroy(self.ShowBankerCard.transform:GetChild(i).gameObject);
        end
    end
    if self.ShowPlayerCard.transform.childCount > 0 then
        for i = 0, self.ShowPlayerCard.transform.childCount - 1 do
            destroy(self.ShowPlayerCard.transform:GetChild(i).gameObject);
        end
    end
    for i = 1, #ChipWinOrLoseState do
        if self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation").childCount > 0 then
            for k = 0, self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation").childCount - 1 do
                destroy(self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation"):GetChild(k).gameObject)
            end
        end
    end
    CHipAreaNum = { 0, 0, 0, 0, 0 };
end
-- 显示隐藏玩家列表对象
function BaccaraPanel.MovePlayerBtnonClick()
    self.UpdatePlayerInfo();
    if self.PlayerBg.transform.localPosition.x < -667 then
        -- 展开
        --    error("展开用户列表");
        local tweener = self.PlayerBg.transform:DOLocalMove(Vector3.New(self.PlayerBg.transform.localPosition.x + 165, self.PlayerBg.transform.localPosition.y, 0), 0.5, false);
        tweener:SetEase(DG.Tweening.Ease.Linear);
    else
        -- 隐藏
        --      error("隐藏用户列表");
        local tweener = self.PlayerBg.transform:DOLocalMove(Vector3.New(self.PlayerBg.transform.localPosition.x - 165, self.PlayerBg.transform.localPosition.y, 0), 0.5, false);
        tweener:SetEase(DG.Tweening.Ease.Linear);
    end

end

-- 更新玩家列表
function BaccaraPanel.UpdatePlayerInfo()
    local creatnum = 0;
    for i = 1, #AllPlayerInfo do
        if AllPlayerInfo[i]._10wTableID == 65535 then
        else
            creatnum = creatnum + 1;
            if i <= self.PlayerParset.transform.childCount then
                self.PlayerParset.transform:GetChild(i - 1).gameObject.name = AllPlayerInfo[i]._1dwUser_Id;
                self.PlayerParset.transform:GetChild(i - 1):Find("Name"):GetComponent("Text").text = AllPlayerInfo[i]._2szNickName;
                self.PlayerParset.transform:GetChild(i - 1):Find("Gold"):GetComponent("Text").text = tostring(AllPlayerInfo[i]._7wGold);
                self.PlayerParset.transform:GetChild(i - 1):Find("Score"):GetComponent("Text").text = AllPlayerInfo[i]._12wScore;
                self.PlayerParset.transform:GetChild(i - 1):Find("Image").gameObject:SetActive(false);
                if tonumber(AllPlayerInfo[i]._9wChairID) == tonumber(BaccaraMH.BankerInfoTable._01wChair) then
                    self.PlayerParset.transform:GetChild(i - 1).transform:Find("Image").gameObject:SetActive(true);
                end
                if AllPlayerInfo[i]._4bCustomHeader == 0 then
                    AllPlayerInfo[i]._5szHeaderExtensionName = "null";
                end
                self.PlayerParset.transform:GetChild(i - 1):Find("Info"):GetComponent("Text").text = AllPlayerInfo[i]._1dwUser_Id .. "," .. AllPlayerInfo[i]._2szNickName .. "," .. AllPlayerInfo[i]._3bySex .. "," .. AllPlayerInfo[i]._4bCustomHeader .. "," .. AllPlayerInfo[i]._5szHeaderExtensionName .. "," .. AllPlayerInfo[i]._6szSign .. "," .. tostring(AllPlayerInfo[i]._7wGold) .. "," .. AllPlayerInfo[i]._8wPrize .. "," .. AllPlayerInfo[i]._9wChairID .. "," .. AllPlayerInfo[i]._10wTableID .. "," .. AllPlayerInfo[i]._11byUserStatus;
            else
                local go = newobject(self.PlayerPrefeb);
                go:SetActive(true);
                go.transform:SetParent(self.PlayerParset.transform);
                go.name = AllPlayerInfo[i]._1dwUser_Id;
                go.transform.localScale = Vector3.one;
                go.transform.localPosition = Vector3.New(0, 0, 0);
                go.transform.localRotation = Vector3.New(0, -180, 0);
                go.transform:Find("Name"):GetComponent("Text").text = AllPlayerInfo[i]._2szNickName;
                go.transform:Find("Gold"):GetComponent("Text").text = tostring(AllPlayerInfo[i]._7wGold);
                go.transform:Find("Score"):GetComponent("Text").text = AllPlayerInfo[i]._12wScore;
                go.transform:Find("Image").gameObject:SetActive(false);
                if tonumber(AllPlayerInfo[i]._9wChairID) == tonumber(BaccaraMH.BankerInfoTable._01wChair) then
                    go.transform:Find("Image").gameObject:SetActive(true);
                end
                if AllPlayerInfo[i]._4bCustomHeader == 0 then
                    AllPlayerInfo[i]._5szHeaderExtensionName = "null";
                end
                go.transform:Find("Info"):GetComponent("Text").text = AllPlayerInfo[i]._1dwUser_Id .. "," .. AllPlayerInfo[i]._2szNickName .. "," .. AllPlayerInfo[i]._3bySex .. "," .. AllPlayerInfo[i]._4bCustomHeader .. "," .. AllPlayerInfo[i]._5szHeaderExtensionName .. "," .. AllPlayerInfo[i]._6szSign .. "," .. tostring(AllPlayerInfo[i]._7wGold) .. "," .. AllPlayerInfo[i]._8wPrize .. "," .. AllPlayerInfo[i]._9wChairID .. "," .. AllPlayerInfo[i]._10wTableID .. "," .. AllPlayerInfo[i]._11byUserStatus;
                self.LuaBehaviour:AddClick(go, self.PlayerInfoMethod);
            end
        end
    end
    for i = creatnum, self.PlayerParset.transform.childCount - 1 do
        destroy(self.PlayerParset.transform:GetChild(i).gameObject);
    end
    if (creatnum * 93) + 20 > 485 then
        local BgSize = Vector2.New(198, creatnum * 93 + 20);
        self.PlayerParset.transform:GetComponent("RectTransform").sizeDelta = BgSize;
    else
    end
end

-- 结果牌放大
function BaccaraPanel.ZoomPkoer()
    -- error("结果牌放大");
    GameOverStartTime = SendPokerTime;
    self.BankerCardPoint:SetActive(true);
    self.PlayerCardPoint:SetActive(true);
    if GameNextScenName ~= gameScenName.Baccara then
        return
    end ;
    coroutine.wait(0.5);
    if GameNextScenName ~= gameScenName.Baccara then
        return
    end ;
    if playerPoint > bankerPoint then

        for i = 0, self.ShowBankerCard.transform.childCount - 1 do
            self.ShowBankerCard.transform:GetChild(i):GetComponent("Image").color = Color.New(0.6, 0.6, 0.6, 1);
        end
        for i = 0, self.BankerCardPoint.transform.childCount - 1 do
            self.BankerCardPoint.transform:GetChild(i):GetComponent("Image").color = Color.New(0.6, 0.6, 0.6, 1);
        end
        self.objWintitle = self.SendCardBg.transform:Find("WinTitle/ImagePlayerWin").gameObject; --胜利标志
    elseif playerPoint < bankerPoint then
        for i = 0, self.PlayerCardPoint.transform.childCount - 1 do
            self.PlayerCardPoint.transform:GetChild(i):GetComponent("Image").color = Color.New(0.6, 0.6, 0.6, 1);
        end
        for i = 0, self.ShowPlayerCard.transform.childCount - 1 do
            self.ShowPlayerCard.transform:GetChild(i):GetComponent("Image").color = Color.New(0.6, 0.6, 0.6, 1);
        end
        self.objWintitle = self.SendCardBg.transform:Find("WinTitle/ImageBankerWin").gameObject;
    elseif playerPoint == bankerPoint then
        self.objWintitle = self.SendCardBg.transform:Find("WinTitle/ImageTie").gameObject;
    end
    if (self.objWintitle) then
        if (not IsNil(self.objWintitle)) then
            self.objWintitle:SetActive(true);
        end
    end

    if not (IsNil(BaccaraMusic)) then
        -- 播放庄点数
        local str;
        local winInt = bankerPoint - playerPoint
        logYellow("===================================zj point = " .. winInt);
        if (winInt > 0) then
            str = "Snd_BWin";
        elseif (winInt < 0) then
            str = "Snd_PWin";
        else
            str = "Snd_DWin";
        end
        local musicchip = BaccaraMusic.transform:Find(str):GetComponent('AudioSource').clip
        MusicManager:PlayX(musicchip);
    end
    -- 延迟播放闲点数
    if GameNextScenName ~= gameScenName.Baccara then
        return
    end ;
    --    coroutine.wait(2);
    --    if GameNextScenName ~= gameScenName.Baccara then return end;
    --    if GameNextScenName ~= gameScenName.Baccara then return end;
    coroutine.wait(0.5);
    if GameNextScenName ~= gameScenName.Baccara then
        return
    end ;
    for i = 0, self.PlayerCardPoint.transform.childCount - 1 do
        self.PlayerCardPoint.transform:GetChild(i):GetComponent("Image").color = Color.New(1, 1, 1, 1);
        self.BankerCardPoint.transform:GetChild(i):GetComponent("Image").color = Color.New(1, 1, 1, 1);
    end
    if GameNextScenName ~= gameScenName.Baccara then
        return
    end ;
    local childnum = 0;
    logTable(AllChipValueTable);
    for i = 1, #GameOverInfoTable do
        childnum = childnum + AllChipValueTable[i];
    end
    error(childnum);
    if childnum > 0 then
        self.ResetGame();
    elseif childnum <= 0 then
        --  self.ShowWinLose:GetComponent("Text").text = "    ";
        self.GameOver();
        IsAllChip = false;
    end
    -- error("结果牌放大1");
end


-- 延迟播放音效
-- t 等待时间, musicNametr 音乐名字, bPoint 是否播放点数, bLast 是否播放下个点数, winInt >0庄赢 <0闲赢 =0平
function BaccaraPanel.waitPlayerMusic(t, musicNametr, bPoint, bLast, winInt)

    coroutine.wait(t);

    --    if (bPoint) then
    --        musicNametr = "Baccarat_xian" .. musicNametr;
    --    end
    local source = nil;
    --    if not(IsNil(BaccaraMusic)) then
    --        local musicchip = BaccaraMusic.transform:Find(musicNametr):GetComponent('AudioSource').clip
    --        source = MusicManager:PlayX(musicchip);
    --    end
    if (bLast) then

        local str;
        if (winInt > 0) then
            str = "Snd_BWin";
        elseif (winInt < 0) then
            str = "Snd_PWin";
        else
            str = "Snd_DWin";
        end

        if not (IsNil(source)) then
            coroutine.start(self.waitPlayerMusic, source.clip.length, str, false, false);
        end
    end

end


-- 输家飞金币
function BaccaraPanel.ResetGame()
    --    for i = 0, self.ShowBankerCard.transform.childCount - 1 do
    --        destroy(self.ShowBankerCard.transform:GetChild(i).gameObject);
    --    end
    --    for i = 0, self.ShowPlayerCard.transform.childCount - 1 do
    --        destroy(self.ShowPlayerCard.transform:GetChild(i).gameObject);
    --    end
    --    self.SendCardBg.transform.localPosition = Vector3.New(0, 1000, 0)
    local isPlayAnimation = false;
    local tweener = "  ";
    for i = 1, #ChipWinOrLoseState do
        if ChipWinOrLoseState[i] == 2 then
            if self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation").childCount > 0 then
                isPlayAnimation = true;
                local movepos = self.ChipPos.transform.position;
                tweener = self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation"):DOMove(movepos, 1, false);
                tweener:SetEase(DG.Tweening.Ease.InCubic);
                tweener:OnPlay(function()
                    for j = 0, self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation").childCount - 1 do
                        self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation"):GetChild(j):DOLocalMove(Vector3.New(20 - math.random(0, 40), 20 - math.random(0, 40), 0), 0.5, false);
                        self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation"):GetChild(j):DOScale(Vector3.New(chipsclae, chipsclae, chipsclae), 1);
                    end
                end)
            end
        end
    end
    if isPlayAnimation then
        if GameNextScenName ~= gameScenName.Baccara then
            return
        end ;
        tweener:OnComplete(self.DestoryGold);
        --  error("tween后开始播放飞的动画");
    else
        self.DestoryGold();
        --  error("没有输家动画开始播放飞的动画");
    end
end
-- 赢家飞金币
function BaccaraPanel.DestoryGold()
    error("开始播放飞的动画");
    local isPlayAnimation = false;
    for i = 1, #ChipWinOrLoseState do
        if ChipWinOrLoseState[i] == 2 then
            if self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation").childCount > 0 then
                self.BetAreaChipNumBg.transform:GetChild(i - 1):Find("myselfChip/Text"):GetComponent('Text').text = "  ";

                self.BetAreaChipNumBg.transform:GetChild(i - 1):Find("myselfChip"):GetComponent('Image').enabled = false;
                self.CreatShowNum(self.ChipNum.transform:Find("Two").gameObject, self.BetAreaChipNumBg.transform:GetChild(i - 1):Find("AllChipValue").gameObject, 0)
                local destroyObj = self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation").gameObject;
                for j = 0, destroyObj.transform.childCount - 1 do
                    destroy(destroyObj.transform:GetChild(j).gameObject);
                end
                destroyObj.transform.localPosition = Vector3.New(0, 0, 0);
                -- destroyObj.transform.Scale = Vector3.New(1, 1, 1);
            end
        end
    end
    -- 金币飞向赢家
    --  error("金币飞向赢家");
    local tweener = "   ";
    for i = 1, #ChipWinOrLoseState do
        if ChipWinOrLoseState[i] == 0 then
            error("动画完成后，赢家金币向两处飞");
            if self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation").childCount > 0 then
                local destroyObj = newobject(self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation").gameObject);
                destroyObj.transform:SetParent(self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation"));
                destroyObj.name = "ChipAnimation";
                destroyObj.transform.localScale = Vector3.New(chipsclae, chipsclae, chipsclae);
                destroyObj.transform.position = self.ChipPos.transform.position
                isPlayAnimation = true;
                tweener = destroyObj.transform:DOLocalMove(Vector3.New(0, 0, 0), 1, false);
                tweener:OnPlay(function()
                    destroyObj.transform:DOScale(Vector3.New(1, 1, 1), 1);
                    for j = 0, self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation/ChipAnimation").childCount - 1 do
                        self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation/ChipAnimation"):GetChild(j):DOLocalMove(Vector3.New(20 - math.random(0, 40), 20 - math.random(0, 40), 0), 0.5, false);
                    end
                end);
                tweener:SetEase(DG.Tweening.Ease.Linear);

            end
        end
    end
    -- 玩家头像上显示正负金币
    showWinLoseValue = 0;
    if Util.SystmeMode() == 64 then
        for i = 1, #ChipWinOrLoseState do
            local beishu = 1;
            if i <= 2 then
                beishu = 11
            elseif i <= 4 then
                beishu = 1
            elseif i == 5 then
                beishu = 8
            end

            if ChipWinOrLoseState[i] == 0 then
                -- 赢
                --error("ChipWinOrLoseState[i]=========" .. i .. "=========赢======" .. ChipWinOrLoseState[i])
                --bankerPoint
                if (4 == i and 6 == bankerPoint) then
                    --庄家以6点获胜
                    showWinLoseValue = showWinLoseValue + ((MyselfChipValueTable[i] / 2) * beishu + MyselfChipValueTable[i]);
                else
                    showWinLoseValue = showWinLoseValue + (MyselfChipValueTable[i] * beishu + MyselfChipValueTable[i]);
                end

            elseif ChipWinOrLoseState[i] == 1 then
                -- 平
                --error("ChipWinOrLoseState[i]=========" .. i .. "=========平======" .. ChipWinOrLoseState[i])
                showWinLoseValue = showWinLoseValue + (MyselfChipValueTable[i] * 1);
            elseif ChipWinOrLoseState[i] == 2 then
                --error("ChipWinOrLoseState[i]=========" .. i .. "=========输======" .. ChipWinOrLoseState[i])
                --                    -- 输
                --                    showWinLoseValue = showWinLoseValue - MyselfChipValueTable[i];
            end
        end
    else
        for i = 1, #GameOverInfoTable do
            if GameOverInfoTable[i] > 0 then
                showWinLoseValue = showWinLoseValue + GameOverInfoTable[i];
            end
            --   error("玩家赢得金币=====" .. showWinLoseValue);
        end
    end
    -- logTable(MyselfChipValueTable);
    error("是否贏了：" .. showWinLoseValue);
    if showWinLoseValue > 0 then
        self.MyselfAddGold:GetComponent("Text").text = "+" .. showWinLoseValue;
        self.MyselfAddGold:SetActive(true);
        coroutine.start(self.ChangeScoreText)
    elseif showWinLoseValue < 0 then
        self.MyselfAddGold:GetComponent("Text").text = "-" .. showWinLoseValue;
        self.MyselfAddGold:SetActive(true);
        BaccaraMH.mySelfInfo.score = BaccaraMH.mySelfInfo.score + showWinLoseValue;
        self.MyselfScore:GetComponent('Text').text = tostring(BaccaraMH.mySelfInfo.gold);
        self.MyselfScore:GetComponent('Text').text = tostring(BaccaraMH.mySelfInfo.gold);
        self.CreatShowNum(self.ChipNum.transform:Find("Gold").gameObject, self.MyScoreImg.gameObject, tostring(BaccaraMH.mySelfInfo.gold));
    elseif showWinLoseValue == 0 then
        self.MyselfScore:GetComponent('Text').text = tostring(BaccaraMH.mySelfInfo.gold);
        self.MyselfScore:GetComponent('Text').text = tostring(BaccaraMH.mySelfInfo.gold);
        self.CreatShowNum(self.ChipNum.transform:Find("Gold").gameObject, self.MyScoreImg.gameObject, tostring(BaccaraMH.mySelfInfo.gold));
    end
    LastChipNum = 0;
    if isPlayAnimation then
        if GameNextScenName ~= gameScenName.Baccara then
            return
        end ;
        tweener:OnComplete(self.GameOver);
    else
        self.GameOver();
    end
end
-- 赢了得时候金币成绩变换
function BaccaraPanel.ChangeScoreText()
    local jishu = showWinLoseValue / 20
    local endnum = BaccaraMH.mySelfInfo.score + showWinLoseValue;
    local endGold = tonumber(self.MyselfScore:GetComponent('Text').text);
    local jishugold = (BaccaraMH.mySelfInfo.gold - endGold) / 20;
    --    for i = 1, 20 do
    --        BaccaraMH.mySelfInfo.score = BaccaraMH.mySelfInfo.score + jishu;
    --        self.MyselfResults:GetComponent('Text').text = BaccaraMH.mySelfInfo.score + jishu;
    --        endGold = endGold + jishugold;
    --        --     error("endGold================"..endGold)
    --        self.MyselfScore:GetComponent('Text').text = endGold + jishugold;
    --        coroutine.wait(0.02);
    --    end
    BaccaraMH.mySelfInfo.score = endnum;
    self.MyselfScore:GetComponent('Text').text = tostring(BaccaraMH.mySelfInfo.gold);
    self.MyselfScore:GetComponent('Text').text = tostring(BaccaraMH.mySelfInfo.gold);
    self.CreatShowNum(self.ChipNum.transform:Find("Gold").gameObject, self.MyScoreImg.gameObject, tostring(BaccaraMH.mySelfInfo.gold));
end

-- 重置游戏，记录输赢
function BaccaraPanel.GameOver()

    if (self.objWintitle) then
        --隐藏赢标志 
        if (not IsNil(self.objWintitle)) then
            self.objWintitle:SetActive(false);
            self.objWintitle = nil;
        end
    end

    if (self.objSignX) then
        if (not IsNil(self.objSignX)) then
            self.objSignX:SetActive(false);
            self.objSignX = nil;
        end
    end
    if (self.objSignZ) then
        if (not IsNil(self.objSignZ)) then
            self.objSignZ:SetActive(false);
            self.objSignZ = nil;
        end
    end

    -- 收牌动画
    for i = 0, self.ShowPlayerCard.transform.childCount - 1 do
        local dotween = self.ShowPlayerCard.transform:GetChild(i):DOMove(self.ChipPos.transform.position, 0.5, false):SetEase(DG.Tweening.Ease.Linear);
        dotween:OnKill(function()
            self.ShowPlayerCard.transform:GetChild(i).gameObject:SetActive(false);
        end)
    end
    for i = 0, self.ShowBankerCard.transform.childCount - 1 do
        local dotween = self.ShowBankerCard.transform:GetChild(i):DOMove(self.ChipPos.transform.position, 0.5, false):SetEase(DG.Tweening.Ease.Linear);
        dotween:OnKill(function()
            self.ShowBankerCard.transform:GetChild(i).gameObject:SetActive(false);

            if i == self.ShowBankerCard.transform.childCount - 1 then
                self.SendCardBg.transform.localPosition = Vector3.New(0, 3000, 0);
                self.SendCardBg:SetActive(false);
            end
        end)
    end
    IsAllChip = false;
    for i = 1, #ChipWinOrLoseState do
        if ChipWinOrLoseState[i] == 0 or ChipWinOrLoseState[i] == 1 then
            if self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation").childCount > 0 then
                if AllChipValueTable[i] == MyselfChipValueTable[i] then
                    error("只有玩家自己下注");
                    for j = 0, self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation").childCount - 1 do
                        tweener = self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation"):GetChild(j):DOMove(self.MyselfHeadImg.transform.position, 1, false);
                        tweener:SetEase(DG.Tweening.Ease.Linear);
                        tweener:OnPlay(function()
                            self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation"):GetChild(j):DOScale(Vector3.New(chipsclae, chipsclae, chipsclae), 1)
                        end)
                        tweener:OnKill(function()

                            if GameNextScenName ~= gameScenName.Baccara then
                                return
                            end ;
                            destroy(self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation"):GetChild(j).gameObject)
                        end);
                    end
                else
                    --error("所有玩家都有下注");
                    for j = 0, self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation").childCount - 2 + ChipWinOrLoseState[i] do

                        if MyselfChipValueTable[i] > 0 then
                            if j % 2 == 0 then
                                local tweener = self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation"):GetChild(j):DOMove(self.MyselfHeadImg.transform.position, 0.8, false);
                                tweener:SetEase(DG.Tweening.Ease.Linear);
                                tweener:OnPlay(function()
                                    self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation"):GetChild(j):DOScale(Vector3.New(chipsclae, chipsclae, chipsclae), 0.8)
                                end)
                                tweener:OnKill(function()

                                    if GameNextScenName ~= gameScenName.Baccara then
                                        return
                                    end ;
                                    destroy(self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation"):GetChild(j).gameObject)
                                end);
                                --error("飞向自己");
                            else
                                local pos = Vector3.New(1000, 100, 0);
                                local tweener = self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation"):GetChild(j):DOLocalMove(pos, 0.8, false);
                                tweener:SetEase(DG.Tweening.Ease.Linear);
                                tweener:OnPlay(function()
                                    self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation"):GetChild(j):DOScale(Vector3.New(chipsclae, chipsclae, chipsclae), 0.8)
                                end)
                                tweener:OnKill(function()
                                    if GameNextScenName ~= gameScenName.Baccara then
                                        return
                                    end ;
                                    destroy(self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation"):GetChild(j).gameObject)
                                end);
                            end
                        else
                            local pos = Vector3.New(1000, 100, 0);
                            local tweener = self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation"):GetChild(j):DOLocalMove(pos, 0.8, false);
                            tweener:SetEase(DG.Tweening.Ease.Linear);
                            tweener:OnPlay(function()
                                self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation"):GetChild(j):DOScale(Vector3.New(chipsclae, chipsclae, chipsclae), 0.8)
                            end)
                            tweener:OnKill(function()
                                if GameNextScenName ~= gameScenName.Baccara then
                                    return
                                end ;
                                destroy(self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation"):GetChild(j).gameObject)
                            end);
                        end

                    end
                    if ChipWinOrLoseState[i] == 0 then
                        local pos = Vector3.New(-1000, 100, 0);
                        local tweener = self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation/ChipAnimation"):DOLocalMove(pos, 0.8, false);
                        tweener:SetEase(DG.Tweening.Ease.Linear);
                        tweener:OnPlay(function()
                            self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation/ChipAnimation"):DOScale(Vector3.New(chipsclae, chipsclae, chipsclae), 1)
                        end)
                        tweener:OnKill(function()

                            if GameNextScenName ~= gameScenName.Baccara then
                                return
                            end ;
                            destroy(self.BetArea.transform:GetChild(i - 1):Find("ChipAnimation/ChipAnimation").gameObject);
                            GameOverStartTime = 0;
                        end
                        );
                    end
                end
            end
            self.BetAreaChipNumBg.transform:GetChild(i - 1):Find("myselfChip/Text"):GetComponent('Text').text = "  ";

            self.BetAreaChipNumBg.transform:GetChild(i - 1):Find("myselfChip"):GetComponent('Image').enabled = false;
            self.CreatShowNum(self.ChipNum.transform:Find("Two").gameObject, self.BetAreaChipNumBg.transform:GetChild(i - 1):Find("AllChipValue").gameObject, 0)
        end
    end
    --  self.ShowWinLose:GetComponent("Text").text = "    ";
    IsGameEndAni = false;
    if BaccaraMH.BankerInfoTable._02Name ~= SCPlayerInfo._05wNickName then
        IsMyselfBanker = false;
    end
    if toInt64(BaccaraMH.mySelfInfo.gold) < toInt64(ChooseChipTable[1]) then
        -- self.ShowMessageTishiPanel("当前金币不足,是否返回大厅充值？")
        HallScenPanel.NetException("Insufficient gold coins, please recharge!", gameSocketNumber.GameSocket);
        for i = 1, #C_CHIP_AREA_BTN do
            C_CHIP_AREA_BTN[i]:GetComponent("Button").interactable = true;
        end
    end ;
    self.MyselfScore:GetComponent('Text').text = tostring(BaccaraMH.mySelfInfo.gold);
    self.MyselfScore:GetComponent('Text').text = tostring(BaccaraMH.mySelfInfo.gold);
    self.CreatShowNum(self.ChipNum.transform:Find("Gold").gameObject, self.MyScoreImg.gameObject, tostring(BaccaraMH.mySelfInfo.gold));
end
-- 点击玩家信息显示详情
function BaccaraPanel.PlayerInfoMethod(args)
    -- 游戏审核期间要屏蔽  gameIsOnline==false 表示游戏在审核没有上线
    if not (gameIsOnline) then
        return
    end ;

    local infodata = {
        _1dwUser_Id = 0,
        _2szNickName = 0,
        _3bySex = 0,
        _4bCustomHeader = 0,
        _5szHeaderExtensionName = 0,
        _6szSign = 0,
        _7wGold = 0,
        _8wPrize = 0,
        _9wChairID = 0,
        _10wTableID = 0,
        _11byUserStatus = 0,
        _12wScore = 0;
    };
    if args.name == "无人当庄" then
        BaccaraMH.BankerInfoTable._01wChair = 65535
        return
    end ;
    if tonumber(args.name) ~= nil then
        PlayerInfoSystem.SelectUserInfo(tonumber(args.name), BaccaraCanvas, args)
    end
    --    for i = 1, #AllPlayerInfo do
    --    error()
    --        if tonumber(args.name) == tonumber(AllPlayerInfo[i]._1dwUser_Id) then
    --            infodata = AllPlayerInfo[i];
    --            PlayerInfoSystem.SelectUserInfo(AllPlayerInfo[i]._1dwUser_Id, BaccaraCanvas, args)
    --          --  PlayerInfoSystem.CreatPanel(AllPlayerInfo[i]._1dwUser_Id, BaccaraCanvas, infodata, args)
    --            return;
    --        end
    --    end
end

function BaccaraPanel.ClosePlayerInfoBg()
    self.PlayerDetail.transform.localPosition = Vector3.New(0, 10000, 0);
end
-- 获取要播放的音乐 BGM,Snd_BetBegin,Snd_BetEnd,Snd_BWin,Snd_Chip,Snd_DWin,Snd_GameEnd,
function BaccaraPanel.GetMusic(MusicName)
    local path = "Music/Baccarat/" .. MusicName;
    return path;
end
-- 显示提示面板
function BaccaraPanel.ShowMessageTishiPanel(messageinfo)
    local t = GeneralTipsSystem_ShowInfo;
    t._01_Title = "提    示";
    t._02_Content = messageinfo;
    t._03_ButtonNum = 2;
    t._04_YesCallFunction = self.MessageTishiPanel_YesBtnOnClick;
    t._05_NoCallFunction = self.MessageTishiPanel_NoBtnOnClick;
    MessageBox.CreatGeneralTipsPanel(t);
end
-- 提示面板确认
function BaccaraPanel.MessageTishiPanel_YesBtnOnClick()
    self.ChipTime = 0;
    MusicManager:PlayBacksound("end", false);
    GameNextScenName = gameScenName.HALL;
    MessgeEventRegister.Game_Messge_Un();
    GameSetsBtnInfo.LuaGameQuit();
    coroutine.start(self.DestoryAb)
end
-- 提示面板取消
function BaccaraPanel.MessageTishiPanel_NoBtnOnClick()
    -- self.GameMessagePanel.transform.localPosition = Vector3.New(0, 1000, 0);
end

-- 下注数值转换成表个数
function BaccaraPanel.ChipNumChangeTable(num)
    local t = {}
    local shiwannum = math.floor(num / ChooseChipTable[4]);
    table.insert(t, #t + 1, shiwannum);
    local wannum = math.floor((num - shiwannum * ChooseChipTable[4]) / ChooseChipTable[3]);
    table.insert(t, #t + 1, wannum);
    local qiannum = math.floor((num - shiwannum * ChooseChipTable[4] - wannum * ChooseChipTable[3]) / ChooseChipTable[2])
    table.insert(t, #t + 1, qiannum);
    local bainum = math.floor((num - shiwannum * ChooseChipTable[4] - wannum * ChooseChipTable[3] - qiannum * ChooseChipTable[2]) / ChooseChipTable[1]);
    table.insert(t, #t + 1, bainum);
    return t;

end

-- 设置筹码值
function BaccaraPanel.SetChipVale()
    -- error("开始设置筹码")
    local ChipImage = self.ChipNum.transform:Find("Three").gameObject;

    for i = 1, 4 do
        for n = 1, self.ChipBtn.transform:GetChild(i - 1):GetChild(0).childCount do
            destroy(self.ChipBtn.transform:GetChild(i - 1):GetChild(0):GetChild(n - 1).gameObject)
        end
        if ChooseChipTable[i] / 10000 < 1 then
            for j = 1, string.len(ChooseChipTable[i]) do
                local chiponevalue = tonumber(string.sub(ChooseChipTable[i], j, j));
                self.ChipBtn.transform:GetChild(i - 1):GetChild(0).gameObject.name = ChooseChipTable[i];
                local go2 = newobject(ChipImage.transform:GetChild(chiponevalue).gameObject);
                go2:SetActive(true);
                go2.transform:SetParent(self.ChipBtn.transform:GetChild(i - 1):GetChild(0));
                go2.transform.localScale = Vector3.New(1, 1, 1);
            end
        else
            local newvale = ChooseChipTable[i] / 10000;
            for j = 1, string.len(newvale) do
                local chiponevalue = tonumber(string.sub(newvale, j, j));
                self.ChipBtn.transform:GetChild(i - 1):GetChild(0).gameObject.name = ChooseChipTable[i];
                local go2 = newobject(ChipImage.transform:GetChild(chiponevalue).gameObject);
                go2:SetActive(true);
                go2.transform:SetParent(self.ChipBtn.transform:GetChild(i - 1):GetChild(0));
                go2.transform.localScale = Vector3.New(1, 1, 1);
            end
            local go2 = newobject(ChipImage.transform:Find("w").gameObject);
            go2:SetActive(true);
            go2.transform:SetParent(self.ChipBtn.transform:GetChild(i - 1):GetChild(0));
            go2.transform.localScale = Vector3.New(1, 1, 1);
        end
    end
    -- error("设置筹码完成")
end

-- 更新成绩
function BaccaraPanel.ChangeScoreMethod(buffer, wsize)
    -- error("没有玩家列表，不需要显示");
    --    local palyernum = wsize / 10
    --    for i = 1, palyernum do
    --        local chairid = buffer:ReadUInt16();
    --        local newscore = buffer:ReadInt64();
    --        for k = 1, #AllPlayerInfo do
    --            if AllPlayerInfo[k]._9wChairID == chairid then
    --                AllPlayerInfo[k]._12wScore = newscore
    --                self.PlayerParset.transform:Find(AllPlayerInfo[k]._1dwUser_Id .. "/Score"):GetComponent("Text").text = newscore;
    --                self.PlayerParset.transform:Find(AllPlayerInfo[k]._1dwUser_Id .. "/Gold"):GetComponent("Text").text = AllPlayerInfo[k]._7wGold;
    --            end
    --        end
    --    end
end

function BaccaraPanel.DestoryAb()
    logYellow("quit game");
    bGameQuit = true;
    self.ClearInfo();
    --coroutine.wait(1);
    --Unload(strAbRes);
    --Unload(strAbMusic);
end

function BaccaraPanel.ClearInfo()
    self.ChipTime = 0;
    isfiirt = 0;
    ChooseChipName = "One";
    ChooseChipTable = {};
    AllScenPlayer = {};
    IsChipBL = false;
    C_CHIP_AREA_BTN = {}
    IsChipNumber = 0;
    m_byPlayerPokerData = { 0, 0, 0 }
    m_byBankerPokerData = { 0, 0, 0 }
    SendPoker = {};
    bywheelCountTable = {};
    CardCount = 0;
    IsNumValue = true;
    StartlimitMaxChipTable = { 0, 0, 0, 0, 0 };
    limitMaxChipTable = {};
    AllChipValueTable = {};
    MyselfChipValueTable = {}
    GameState = 0;
    playerPoint = 0;
    bankerPoint = 0;
    GameOverInfoTable = {};
    showWinLoseValue = 0;
    ChipWinOrLoseState = { 0, 0, 0, 0, 0 };
    lastChipValue = 0;
    CreatingAllChip = { 0, 0, 0, 0, 0 };
    CreatingMyselfChip = { 0, 0, 0, 0, 0 };
    RoomPeople = 0;
    BankerListInfoTable = {};
    IsAllChip = false;
    CHipAreaNum = { 0, 0, 0, 0, 0 };
    OldTime = 0;
    IsGameEndAni = false;
    LastChipNum = 0;
    StartTime = 0;
    BaccaraMusic = nil;
    self.BaccaraObj = nil;
    IssendPokerpos = false;
    self.onesencond = 0
    self.MipaiAniuserid = 0;
end
-- 检查是否已经发完两张牌切翻牌正常
function BaccaraPanel.CheckDealMethod(IsGameOver, bl)
    -- error("检查是否已经发完两张牌切翻牌正常");
    if bl == nil then
        bl = 0;
    end
    local playercardNum = self.ShowPlayerCard.transform.childCount;
    local bankercardNum = self.ShowBankerCard.transform.childCount;
    local fornumplayer = 2;
    local fornunbanker = 2;
    if bl == 0 or bl == 1 then
        for i = 1, playercardNum do
            if fornumplayer > 0 then
                fornumplayer = fornumplayer - 1
            end
            self.ShowPlayerCard.transform:GetChild(i - 1):GetComponent("Image").sprite = self.AllPoker.transform:GetChild((string.split(Util.OutPutPokerValue(m_byPlayerPokerData[i]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byPlayerPokerData[i]), ",")[2]) - 1):GetComponent("Image").sprite;
            self.ShowPlayerCard.transform.localRotation = Vector3.New(0, 0, 0);
            self.ShowPlayerCard.transform:GetChild(i - 1).localPosition = Vector3.New(-poketw + (i - 1) * poketw, 0, 0);
            self.ShowPlayerCard.transform:GetChild(i - 1).gameObject:SetActive(true);
            self.ShowPlayerCard.transform:GetChild(i - 1).localScale = Vector3.New(0.5, 0.5, 0.5);
        end
        for i = 1, fornumplayer do
            playercardNum = playercardNum + 1;
            local prefeb = self.CardsBox.transform:GetChild(0).gameObject;
            local go = newobject(prefeb);
            local cardNum = (string.split(Util.OutPutPokerValue(m_byPlayerPokerData[playercardNum]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byPlayerPokerData[playercardNum]), ",")[2])
            go:SetActive(true);
            go.transform:SetParent(self.ShowPlayerCard.transform);
            go.transform.localScale = Vector3.New(0.5, 0.5, 0.5);
            go.transform.localPosition = Vector3.New(-poketw + ((playercardNum - 1) * poketw), 0, 0);
            go.transform.localRotation = Vector3.New(0, 0, 0);
            go:GetComponent("Image").sprite = self.AllPoker.transform:GetChild(cardNum - 1):GetComponent("Image").sprite;
            go.name = prefeb.name;

        end
        self.PlayerCardValue.transform:GetComponent('Image').sprite = self.ChipNum.transform:Find("One"):GetChild(playerPoint).gameObject:GetComponent('Image').sprite
        self.PlayerCardPoint:SetActive(true);
    end
    if bl == 0 or bl == 2 then
        for i = 1, bankercardNum do
            if fornunbanker > 0 then
                fornunbanker = fornunbanker - 1
            end
            self.ShowBankerCard.transform:GetChild(i - 1):GetComponent("Image").sprite = self.AllPoker.transform:GetChild((string.split(Util.OutPutPokerValue(m_byBankerPokerData[i]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byBankerPokerData[i]), ",")[2]) - 1):GetComponent("Image").sprite;
            self.ShowBankerCard.transform.localRotation = Vector3.New(0, 0, 0);
            self.ShowBankerCard.transform:GetChild(i - 1).localPosition = Vector3.New(-poketw + (i - 1) * poketw, 0, 0);
            self.ShowBankerCard.transform:GetChild(i - 1).localScale = Vector3.New(0.5, 0.5, 0.5);
            self.ShowBankerCard.transform:GetChild(i - 1).gameObject:SetActive(true);
        end
        for i = 1, fornunbanker do
            bankercardNum = bankercardNum + 1;
            local prefeb = self.CardsBox.transform:GetChild(0).gameObject;
            local go = newobject(prefeb);
            local cardNum = (string.split(Util.OutPutPokerValue(m_byBankerPokerData[bankercardNum]), ",")[1]) * 13 + (string.split(Util.OutPutPokerValue(m_byBankerPokerData[bankercardNum]), ",")[2])
            go:SetActive(true);
            go.transform:SetParent(self.ShowBankerCard.transform);
            go.transform.localScale = Vector3.New(0.5, 0.5, 0.5);
            go.transform.localPosition = Vector3.New(-poketw + ((bankercardNum - 1) * poketw), 0, 0);
            go.transform.localRotation = Vector3.New(0, 0, 0);
            go:GetComponent("Image").sprite = self.AllPoker.transform:GetChild(cardNum - 1):GetComponent("Image").sprite;
            go.name = prefeb.name;

        end
        self.BankerCardValue.transform:GetComponent('Image').sprite = self.ChipNum.transform:Find("One"):GetChild(bankerPoint).gameObject:GetComponent('Image').sprite
        self.BankerCardPoint:SetActive(true);
    end

end

function BaccaraPanel.Pool(prefabName)
    local obj = self.tabObjPool[prefabName];

    if obj == nil then
        local t = self.BaccaraObj.transform:Find("Pool");
        t = t.transform:Find(prefabName);
        if t == nil then
            error("Pool下没有找到 " .. prefabName);
            return
        end
        self.tabObjPool[prefabName] = t.gameObject;
        return t.gameObject;
    end
    return obj;
end

function BaccaraPanel.PoolForNewobject(prefabName)

    local res = BaccaraPanel.Pool(prefabName)

    if res == nil then
        return ;
    end

    local obj = newobject(res);
    obj:SetActive(true);
    obj.name = prefabName;
    return obj;
end
--牌型转化
function BaccaraPanel.Ten2tTwo(num)
    local arr = {}
    local i = 1;
    local n = num
    while n > 0 do
        arr[i] = math.fmod(n, 2);
        i = i + 1
        n = math.floor(n * 0.5)
    end

    local b = 0;

    if #arr < 8 then
        b = 8 - #arr;
    end
    for i = 1, tonumber(b) do
        table.insert(arr, #arr + 1, 0)
    end
    local arr1 = {}
    arr1 = self.reverseTable(arr);
    local c = {}
    c = self.Two2Ten(arr1);

    local mmm = c[1] * 13 + c[2]
    return c;
end
--表翻转
function BaccaraPanel.reverseTable(tab)
    local tmp = {}
    for i = 1, #tab do
        local key = #tab
        tmp[i] = table.remove(tab)
    end
    return tmp
end
--2to10
function BaccaraPanel.Two2Ten(tb)
    local arr = {}
    arr = tb;
    local b = "";
    local arr2 = {}
    for i = 1, #tb do
        b = b .. tostring(arr[i]);
        table.insert(arr2, arr[i])
    end
    local arr1 = {};
    arr1[1] = self.tw2te(1, arr2)
    arr1[2] = self.tw2te(2, arr2)
    return arr1;
end
--10to2
function BaccaraPanel.tw2te(num, tb)
    local n = 0
    local t = {}
    t = tb;
    if num == 1 then
        local s = 4;
        for i = 1, 4 do
            n = n + t[s] * (2 ^ (i - 1));
            s = s - 1;
        end
    elseif num == 2 then
        local s = 8;
        for i = 5, 8 do
            n = n + t[s] * math.pow(2, i - 5)
            s = s - 1;
        end
    end
    return n;
end