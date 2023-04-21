--包名
--GamePacketName("SerialIndiana");
MainPanel = {};

local ExternalLibs = require "Common.ExternalLibs";
local EventSystem = ExternalLibs.EventSystem;
local Timer;
local GameData
local GameControl
local GameConfig
local GameObjManager
local ThrowPath
local ThrowMove
local HelpPanel;

function Include()
    --通用
    if not AlignViewClass or not AlignViewExClass then
        AlignViewClass = LuaFramework.AlignView;
        AlignViewExClass = LuaFramework.AlignViewEx;
    end
    if not AlignViewClassType or not AlignViewExClassType then
        AlignViewClassType = typeof(AlignViewClass);--AlignViewClass.GetClassType();
        AlignViewClassName = "AlignView";
        AlignViewExClassType = typeof(AlignViewExClass);--AlignViewExClass.GetClassType();
        AlignViewExClassName = "AlignViewEx";
    end
    --针对AlignView 和AlignViewEx
    Enum_AlignViewEx = {
        Align_Normal        = 0, --正常
        Align_LeftUp        = 1, --左上
        Align_Up            = 2, --上
        Align_RightUp    = 3, --右上
        Align_Left        = 4, --左
        Align_Mid        = 5, --中间
        Align_Right        = 6, --右
        Align_LeftBottom    = 7, --左下
        Align_Bottom        = 8, --下
        Align_RightBottom = 9, --右下
    };

    AlignView = {};
    function AlignView.Awake(obj)

    end
    function AlignView.Start(obj)
        --屏幕自适配
        local alignView = obj:GetComponent(AlignViewExClassName);
        if (alignView ~= nil) then
            local localScale = obj.transform.localScale;
            alignView:arrangePos();
            if not alignView.isScaleWithScreen then
                obj.transform.localScale = localScale;
            end
        else
            alignView = obj:GetComponent(AlignViewClassName);
            if (alignView ~= nil) then
                local localScale = obj.transform.localScale;
                alignView:arrangePos();
                if not alignView.isScaleWithScreen then
                    obj.transform.localScale = localScale;
                end
            end
        end
    end
    --是否竖屏
    GlobalGame.isPortrait = true;
    --是否横屏
    GlobalGame.isLandscape = false;
    GamePacketName("Module24/SerialIndiana");
    GameRequire("SI_Define");
    GameRequire("SI_EventDefine");
    GameRequire("SI_Tools");
    GameData = GameRequire("SI_GameData");
    GameObjManager = GameRequire("SI_GameObjManager");
    GameControl = GameRequire("SI_GameControl");
    ThrowPath = GameRequire("SI_ThrowPath");
    ThrowMove = GameRequire("SI_ThrowMove");
    Timer    = GameRequire("SI_Timer");
    HelpPanel = GameRequire("SI_HelpPanel");
end

local _GlobalGame = class();

function _GlobalGame:_initAppConstant()
    self.ConstantValue = {
        IsLandscape = false,
        IsPortrait = true,
        MatchScreenWidth = 1334,
        MatchScreenHeight = 750,
        RealScreenWidth = 1334,
        RealScreenHeight = 750,
        CanvasRate = 1,
    };
    local matchRate = self.ConstantValue.MatchScreenWidth / self.ConstantValue.MatchScreenHeight;
    if self.ConstantValue.IsLandscape then
        if Util.isAndroidPlatform or Util.isApplePlatform then
            self.ConstantValue.RealScreenWidth = Screen.width;
            self.ConstantValue.RealScreenHeight = Screen.height;
        elseif Util.isEditor then
            self.ConstantValue.RealScreenWidth = Screen.width;
            self.ConstantValue.RealScreenHeight = Screen.width / matchRate;
        elseif Util.isPc then
            self.ConstantValue.RealScreenWidth = 1334;--Screen.width;
            self.ConstantValue.RealScreenHeight = 740;--Screen.height;
        else
            self.ConstantValue.RealScreenWidth = Screen.width;--Screen.width;
            self.ConstantValue.RealScreenHeight = Screen.height;--Screen.height;
        end


        if self.ConstantValue.RealScreenWidth / self.ConstantValue.RealScreenHeight > matchRate then
            AlignViewExClass.setScreenArgs(self.ConstantValue.RealScreenWidth, self.ConstantValue.RealScreenHeight,
            self.ConstantValue.MatchScreenWidth, self.ConstantValue.MatchScreenHeight, false);
            self.ConstantValue.CanvasRate = 1;
        else
            AlignViewExClass.setScreenArgs(self.ConstantValue.RealScreenWidth, self.ConstantValue.RealScreenHeight,
            self.ConstantValue.MatchScreenWidth, self.ConstantValue.MatchScreenHeight, true);
            self.ConstantValue.CanvasRate = 0;
        end

    elseif self.ConstantValue.IsPortrait then
        self.ConstantValue.RealScreenWidth = Screen.height;
        self.ConstantValue.RealScreenHeight = Screen.width;
        local matchRate = self.ConstantValue.MatchScreenWidth / self.ConstantValue.MatchScreenHeight;
        if self.ConstantValue.RealScreenWidth / self.ConstantValue.RealScreenHeight > matchRate then
            AlignViewExClass.setScreenArgs(self.ConstantValue.RealScreenWidth, self.ConstantValue.RealScreenHeight,
            self.ConstantValue.MatchScreenWidth, self.ConstantValue.MatchScreenHeight, false);
            self.ConstantValue.CanvasRate = 0;
        else
            AlignViewExClass.setScreenArgs(self.ConstantValue.RealScreenWidth, self.ConstantValue.RealScreenHeight,
            self.ConstantValue.MatchScreenWidth, self.ConstantValue.MatchScreenHeight, true);
            self.ConstantValue.CanvasRate = 1;
        end
    end

end

function _GlobalGame:GetCanvasRate()
    return self.ConstantValue.CanvasRate;
end

function MainPanel:Awake(obj)
    Screen.orientation = UnityEngine.ScreenOrientation.Landscape;
    Screen.autorotateToLandscapeLeft = true;
    Screen.autorotateToLandscapeRight = true;
    Screen.autorotateToPortrait = false;
    Screen.autorotateToPortraitUpsideDown = false;
    self.modulePanel = obj;
    Event.AddListener(HallScenPanel.ReconnectEvent, self.Reconnect);
    math.randomseed(os.time());
    GlobalGame = _GlobalGame.New();--全局事件
    Include();--包含通用的
    GlobalGame:_initAppConstant();
    MessgeEventRegister.Game_Messge_Un(); --清除消息事件
    -- 绑定消息事件
    EventCallBackTable._01_GameInfo = MainPanel.GameInfo;
    EventCallBackTable._02_ScenInfo = MainPanel.ScenInfo;
    EventCallBackTable._03_LogonSuccess = MainPanel.LogonSuccess;
    EventCallBackTable._04_LogonOver = MainPanel.logonOver;
    EventCallBackTable._05_LogonFailed = MainPanel.logonFailed;
    EventCallBackTable._06_Biao_Action = MainPanel.Biao_Action;
    EventCallBackTable._07_UserEnter = MainPanel.UserEnter;
    EventCallBackTable._08_UserLeave = MainPanel.UserLeave;
    EventCallBackTable._09_UserStatus = MainPanel.UserStatus;
    EventCallBackTable._10_UserScore = MainPanel.UserScore;
    EventCallBackTable._11_GameQuit = MainPanel.GameQuit;
    EventCallBackTable._12_OnSit = MainPanel.OnSit;
    EventCallBackTable._13_ChangeTable = MainPanel.ChangeTable;
    EventCallBackTable._14_RoomBreakLine = MainPanel.RoomBreakLine;
    EventCallBackTable._15_OnBackGame = MainPanel.onBackGame;
    EventCallBackTable._16_OnHelp = MainPanel.OnClickHelp;
    MessgeEventRegister.Game_Messge_Reg(EventCallBackTable);
    GlobalGame._mainPanel = MainPanel;
    GlobalGame._eventSystem = EventSystem.New();
    GlobalGame._timerMgr = Timer.New();--定时器
    GlobalGame._gameControl = GameControl.New();--游戏管理
    GlobalGame._gameObjManager = GameObjManager.New();--游戏对象管理器
    GlobalGame.isInGame = true;
    MainPanel.Send_Logon();--发送登录
    do
        GlobalGame._otherUI = GameObject.Find("HallScenPanel");--其他UI界面
        if GlobalGame._otherUI~=nil then GlobalGame._otherUI:SetActive(false); end--先隐藏他们的UI界面
    end
    local MainPanel = GlobalGame._gameObjManager:CreateMainPanel();
    local MainPanelTransform = MainPanel.transform;
    GlobalGame._gameObjManager:SetCacheTransform(MainPanelTransform:Find("CachePool"));	--设置缓存基节点

    local mainCanvas = MainPanelTransform:Find("Canvas").gameObject;
    MainPanel:GetComponent("CanvasScaler").referenceResolution = Vector2.New(1334,750);
    MainPanelTransform:Find("UICamera").localRotation = Quaternion.identity;
    MainPanelTransform:Find("UICamera"):GetComponent('Camera').clearFlags = UnityEngine.CameraClearFlags.SolidColor
    MainPanelTransform:Find("UICamera"):GetComponent('Camera').backgroundColor = Color.New(0, 0, 0, 0)
    local canvasScaler = MainPanel:GetComponent("CanvasScaler");
    if canvasScaler ~= nil then
        SetCanvasScalersMatch(canvasScaler, GlobalGame:GetCanvasRate());
    end
    SetCanvasScalersMatch(canvasScaler, 1);
    GlobalGame._uiCamera    = MainPanelTransform:Find("UICamera");

    -- bg:GetComponent("RectTransform").sizeDelta = Vector2.New(750 * (Screen.width / Screen.height), 750)
    -- self.per:GetComponent("CanvasScaler").referenceResolution = Vector2.New(1334, 750);
    -- self.per.transform:Find("mycarcam").localRotation = Quaternion.identity;
    GlobalGame._uiCamera :GetComponent('Camera').clearFlags = UnityEngine.CameraClearFlags.SolidColor
    GlobalGame._uiCamera :GetComponent('Camera').backgroundColor = Color.New(0, 0, 0, 0)




    GlobalGame._mainCanvas = mainCanvas;
    GlobalGame._mainCanvasTransform = mainCanvas.transform;
    GlobalGame._contentLayer = GlobalGame._mainCanvasTransform:Find("ContentLayer");
    GlobalGame._tipLayer = GlobalGame._mainCanvasTransform:Find("TipLayer");
    GlobalGame._systemLayer = GlobalGame._mainCanvasTransform:Find("SystemLayer");
    GlobalGame._systemLayer:GetComponent("RectTransform").anchorMax = Vector2.New(1,1);
    GlobalGame._systemLayer:GetComponent("RectTransform").anchorMin = Vector2.New(0,0);
    GlobalGame._systemLayer:GetComponent("RectTransform").offsetMax = Vector2.New(0,0);
    GlobalGame._systemLayer:GetComponent("RectTransform").offsetMin = Vector2.New(0,0);
    MainPanel.transform:SetParent(obj.transform);
    MainPanel.transform.localPosition = Vector3.New(0, 0, 0);
    MainPanel.transform.localScale = Vector3.New(1, 1, 1);
    local GamePanel = GameRequire("SI_GamePanel");
    GlobalGame._gamePanel = GamePanel.New(GlobalGame._gameControl);
    local gamePanel = GlobalGame._contentLayer:Find("GamePanel");


    local bg = GameObject.New("BgImage"):AddComponent(typeof(UnityEngine.UI.Image));
    bg.transform:SetParent(gamePanel);
    bg.transform:SetSiblingIndex(4);
    bg.transform.localPosition = Vector3(0, 0, 50);
    bg.transform.localScale = Vector3(1, 1, 1);
    --bg.sprite = HallScenPanel.moduleBg:Find("module24"):GetComponent("Image").sprite;
    bg:GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
    GlobalGame._gamePanel:Init(gamePanel);
    GlobalGame._gameObjManager:GetMusic(SI_MUSIC_TYPE.StoneFallDown_BG_1);
    GameManager.GameScenIntEnd(GlobalGame._contentLayer);
end

function MainPanel.onBackGame()
    MainPanel.Reconnect()
end


function MainPanel:OnDestroy()
    Event.RemoveListener(HallScenPanel.ReconnectEvent, self.Reconnect);
end

function MainPanel.Reconnect()
    log("重连成功")
    MainPanel.Send_Logon();
end
-- =====发送消息的结构函数
function MainPanel.Send_Logon()
    local bf = ByteBuffer.New();
    bf:WriteUInt32(0);
    bf:WriteUInt32(0);
    bf:WriteUInt32(SCPlayerInfo._01dwUser_Id);
    bf:WriteBytes(DataSize.String33, SCPlayerInfo._06wPassword);
    bf:WriteBytes(100, Opcodes);
    bf:WriteByte(0);
    bf:WriteByte(0);
    Network.Send(MH.MDM_GR_LOGON, 3, bf, gameSocketNumber.GameSocket);
end


function MainPanel.Update()
    if GlobalGame == nil then
        return;
    end
    if not GlobalGame.isInGame then
        return;
    end
    --启动定时器
    local dt = Time.deltaTime;
    if GlobalGame._timerMgr then
        GlobalGame._timerMgr:Execute(dt);
    end

    if GlobalGame._gamePanel then
        GlobalGame._gamePanel:Update(dt);
    end
end

-- 场景消息
function MainPanel.ScenInfo(wMaiID, wSubID, buffer, wSize)
    logYellow("场景消息")
    
    GlobalGame._gameControl:NotifySceneInfo(buffer);
    --周期查询彩金
    GlobalGame._timerMgr:FixUpdateByPeriod(handler(GlobalGame._gameControl, GlobalGame._gameControl.RequestCaiJin), nil, SI_GAME_CONFIG.QueryCaiJinPeriod);
end

function MainPanel.GameInfo(wMaiID, wSubID, buffer, wSize)

    local id = string.gsub(wSubID, wMaiID, "");
    id = tonumber(id);
    if id == SI_CMD.ResponseStartGame then --开始游戏
        GlobalGame._gameControl:ResponseStartGame(buffer);
    elseif id == SI_CMD.ResponseDragonMission then
        --龙珠关卡
        GlobalGame._gameControl:ResponseDragonMission(buffer);
    elseif id == SI_CMD.ResponseCaijin then
        --彩金
        GlobalGame._gameControl:ResponseCaijin(buffer);
    elseif id == SI_CMD.ResponsePlayerList then
        GlobalGame._gameControl:ResponsePlayerList(buffer);
    end
end

-- 登陆成功
function MainPanel.LogonSuccess(wMaiID, wSubID, buffer, wSize)
    error("MainPanel.LogonSuccess");
end

-- 登陆完成
function MainPanel.logonOver(wMaiID, wSubID, buffer, wSize)
    local bf = ByteBuffer.New();
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, bf, gameSocketNumber.GameSocket);
end

-- 登陆失败
function MainPanel.logonFailed(wMaiID, wSubID, buffer, wSize)
    error("MainPanel.logonFailed");
    -- 登录失败
    Network.OnException("与服务器失去连接！");
end

-- 用户进入
function MainPanel.UserEnter(wMaiID, wSubID, buffer, wSize)
    local UserInfo =    {
        _uid = TableUserInfo._1dwUser_Id,
        _name = TableUserInfo._2szNickName,
        _sex = TableUserInfo._3bySex,
        _customHeader = TableUserInfo._4bCustomHeader,
        _customExtensionName = TableUserInfo._5szHeaderExtensionName,
        _gold = TableUserInfo._7wGold,
        _chairId = TableUserInfo._9wChairID,
    };
    GlobalGame._gameControl:RecivePlayerData(UserInfo);
end

-- 用户离开
function MainPanel.UserLeave(wMaiID, wSubID, buffer, wSize)

end

-- 用户状态
function MainPanel.UserStatus(wMaiID, wSubID, buffer, wSize)
end

-- 用户分数
function MainPanel.UserScore(wMaiID, wSubID, buffer, wSize)
    TableUserInfo._9wChairID = TableUserInfo._9wChairID + 1;
end


-- 入座结果
function MainPanel.OnSit(wMaiID, wSubID, buffer, wSize)
    if wSize == 0 then
        -- 入座成功，准备
        local bf = ByteBuffer.New();
        bf:WriteByte(0);
        Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, bf, gameSocketNumber.GameSocket);
        log("=======================================开始准备============================================")
    else
        -- 入座失败
        Network.OnException(buffer.ReadString(buffer));
    end
end


--点击帮助
function MainPanel.OnClickHelp()
    if not GlobalGame._helpPanel then
        GlobalGame._helpPanel = HelpPanel.Create(GlobalGame._systemLayer);
        GlobalGame._helpPanel:Init();
        --重新打开
        --self._helpPanel:OnOpen();
    end
    GlobalGame._helpPanel:OnOpen();
end

-- 游戏退出
function MainPanel.GameQuit()
    GlobalGame._gameControl:_Zero()
    do
        --显示他们的UI界面
        if  GlobalGame._otherUI~=nil then
            GlobalGame._otherUI:SetActive(true);
        end
    end
    GlobalGame._gamePanel:Destroy();
    GlobalGame._gamePanel = nil;
    --清理GC内存
    GlobalGame._eventSystem:Clear();
    GlobalGame._gameObjManager:Unload();
    GamePacketName("");
    GameNextScenName = gameScenName.HALL;
    MessgeEventRegister.Game_Messge_Un();
    GameSetsBtnInfo.LuaGameQuit();
    GlobalGame = nil;
    GlobalGame = {};
    GlobalGame.isInGame = false;
end

return MainPanel;