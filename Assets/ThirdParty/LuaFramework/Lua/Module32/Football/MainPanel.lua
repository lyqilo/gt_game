MainPanel = class("MainPanel");
--捉鬼特工
--Game26Panel = MainPanel;
--Game14Panel = MainPanel;

--luanet.load_assembly('UnityEditor');
--luanet.load_assembly('Assembly-CSharp');
--UplayerPrefs = luanet.import_type('UnityEditor.EditorApplication');

GamePacketName__ = nil;
GameRequire__ = nil;

local GOCreator = nil;
local C_GlobalGame = nil;
local ClientSession = nil;
local GameSceneControl = nil;
local SoundControl = nil;
local AnimaTool = nil;
local GameLoadPanel = nil;
local _CGameControl = nil;

--包含一些通用的lua文件
local function Include()

    VECTOR2NEW = Vector2.New;
    VECTOR3NEW = Vector3.New;
    VECTOR4NEW = Vector4.New;

    VECTOR3DIS = V_Dis;
    VECTOR3ZERO = VECTOR3NEW(0, 0, 0); --Vector3.Zero();
    VECTOR3ONE = VECTOR3NEW(1, 1, 1);--Vector3.One();
    COLORNEW = Color.New;
    QUATERNION_EULER = Quaternion.Euler;
    QUATERNION_LOOKROTATION = Quaternion.LookRotation;
    C_Quaternion_Zero = QUATERNION_EULER(0, 0, 0);
    C_Quaternion_Rotation = QUATERNION_EULER(0, 0, 180);
    C_Vector3_Zero = VECTOR3ZERO;
    C_Vector3_One = VECTOR3ONE;
    C_Color_One = COLORNEW(1, 1, 1, 1);
    V_Vector3_Value = VECTOR3ONE();
    V_Color_Value = COLORNEW(1, 1, 1, 1);
    ImageAnimaClassType = typeof(ImageAnima);
    ImageClassType = typeof(UnityEngine.UI.Image);--UnityEngine.UI.Image.GetClassType();
    SpriteRendererClassType = typeof(UnityEngine.SpriteRenderer);--UnityEngine.UI.Image.GetClassType();
    AudioSourceClassType = typeof(UnityEngine.AudioSource);
    GAMEOBJECT_NEW = GameObject.New;
    BoxColliderClassType = typeof(UnityEngine.BoxCollider);
    ParticleSystemClassType = typeof(UnityEngine.ParticleSystem);

    --RigidbodyClassType = typeof(UnityEngine.RigidBody);
    UTIL_ADDCOMPONENT = Util.AddComponent;
    -- --通用
    if not AlignViewClass or not AlignViewExClass then
        -- AlignViewClass = SuperLuaFramework.AlignView;
        -- AlignViewExClass = SuperLuaFramework.AlignViewEx;
        AlignViewClass = LuaFramework.AlignView;
        AlignViewExClass = LuaFramework.AlignViewEx;
    end
    if not AlignViewClassType or not AlignViewExClassType then
        AlignViewClassType = typeof(AlignViewClass);
        AlignViewClassName = "AlignView";
        AlignViewExClassType = typeof(AlignViewExClass);
        AlignViewExClassName = "AlignViewEx";
    end

    --针对AlignView 和AlignViewEx
    Enum_AlignViewEx = {
        Align_Normal = 0, --正常
        Align_LeftUp = 1, --左上
        Align_Up = 2, --上
        Align_RightUp = 3, --右上
        Align_Left = 4, --左
        Align_Mid = 5, --中间
        Align_Right = 6, --右
        Align_LeftBottom = 7, --左下
        Align_Bottom = 8, --下
        Align_RightBottom = 9, --右下
    };

    AlignView = {};
    function AlignView.Awake(luatab, obj)

    end

    function AlignView.Start(luatab, obj)
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

    local __PacketName = "";
    local __LoadFileTable = {};

    GamePacketName__ = function(_packetName)
        __PacketName = _packetName;
    end

    GameRequire__ = function(name, _packetname)
        local realName;
        if _packetname then
            realName = (_packetname .. "." .. name);
        else
            if __PacketName then
                realName = (__PacketName .. "." .. name);
            else
                realName = (name);
            end
        end
        if __LoadFileTable[realName] == true then
            return require(realName);
        else
            __LoadFileTable[realName] = true;
            return require(realName);
        end
    end

    --    --屏幕适配
    AlignViewClass.setScreenArgs(Screen.width, Screen.height, 1334, 750, true);

    GamePacketName__("Module32.Football");
    GameRequire__("Functions");
    C_GlobalGame = GameRequire__("GlobalGame");
    GOCreator = GameRequire__("GOCreator");
    ClientSession = GameRequire__("ClientSession");
    AnimaTool = GameRequire__("AnimateTool");
    _CGameControl = GameRequire__("GameControl");
    --加载器
    GameLoadPanel = GameRequire__("GameLoadPanel");
end

function MainPanel:ctor()
    self.bCamerAnimationEnd = false;
    self.bBenginLead = false;
    self.isInstanceGameObject = false;
    self.beginTickCount = 0;
    self.transform = nil;
end

function MainPanel:Awake(obj)
    Screen.orientation = UnityEngine.ScreenOrientation.Landscape;
    Screen.autorotateToLandscapeLeft = true;
    Screen.autorotateToLandscapeRight = true;
    Screen.autorotateToPortrait = false;
    Screen.autorotateToPortraitUpsideDown = false;
    Event.AddListener(HallScenPanel.ReconnectEvent, self.Reconnect);

    Include();

    --全局游戏
    G_GlobalGame = C_GlobalGame.New();

    local mainPanel = MainPanel.New();
    G_GlobalGame._mainPanel = mainPanel;

    --自己游戏窗口对象
    G_GlobalGame._gamePanelObj = obj;
    G_GlobalGame._goFactory = GOCreator.New();
    G_GlobalGame._animaTool = AnimaTool.New();

    --设置创建器
    G_GlobalGame._animaTool:SetCreator(handler(G_GlobalGame._goFactory, G_GlobalGame._goFactory.getCommonSprite));
    --G_GlobalGame:Init();

    --初始化网络接收器
    G_GlobalGame._clientSession = ClientSession.New();
    --初始化游戏管理
    G_GlobalGame._gameControl = _CGameControl.New();
    -- 初始化框架结构
    G_GlobalGame._canvasPanelGO = G_GlobalGame._goFactory:createMainPanel();
    G_GlobalGame._canvasPanel = G_GlobalGame._canvasPanelGO.transform;

    G_GlobalGame._canvasPanel:SetParent(obj.transform);
    G_GlobalGame._canvasPanel.localPosition = VECTOR3NEW(0, 0, 0);
    G_GlobalGame._canvasComponent = G_GlobalGame._canvasPanelGO.transform:GetComponent("Canvas");
    local canvasScaler = G_GlobalGame._canvasComponent:GetComponent("CanvasScaler");

    --UI相机
    G_GlobalGame._uiCamera = G_GlobalGame._canvasPanel:Find("UICamera"):GetComponent("Camera");

    --初始化摄像机等系统参数
    G_GlobalGame:InitSystem(canvasScaler, G_GlobalGame._uiCamera);
    canvasScaler.referenceResolution = Vector2.New(1334, 750);
    SetCanvasScalersMatch(canvasScaler, 1);
    G_GlobalGame._contentLayer = G_GlobalGame._canvasPanel:Find("Layers/ContentLayer");
    G_GlobalGame._tipLayer = G_GlobalGame._canvasPanel:Find("Layers/TipLayer");
    G_GlobalGame._tipLayer:GetComponent("RectTransform").anchorMax = Vector2.New(1,1);
    G_GlobalGame._tipLayer:GetComponent("RectTransform").anchorMin = Vector2.New(0,0);
    G_GlobalGame._tipLayer:GetComponent("RectTransform").offsetMax = Vector2.New(0,0);
    G_GlobalGame._tipLayer:GetComponent("RectTransform").offsetMin = Vector2.New(0,0);
    G_GlobalGame._systemLayer = G_GlobalGame._canvasPanel:Find("Layers/SystemLayer");

    --缓冲池
    G_GlobalGame._cachePool = G_GlobalGame._canvasPanel:Find("Layers/CachePool");

    --所有的 UIlayer
    G_GlobalGame._UILayers = G_GlobalGame._canvasPanel:Find("Layers/UILayer");

    --放UI的Layer
    G_GlobalGame._uiLayer = G_GlobalGame._UILayers:Find("ContentLayer");

    --放LoadPanel的Layer
    G_GlobalGame._setLayer = G_GlobalGame._UILayers:Find("SetLayer");

    --在UI之上
    G_GlobalGame._overLayer = G_GlobalGame._UILayers:Find("OverLayer");

    --加载游戏loadPanel
    G_GlobalGame._loadPanel = GameLoadPanel.New();

    --异步加载
    G_GlobalGame._loadPanel:AsyncLoad(handler(G_GlobalGame._gameControl, _CGameControl.OnAsyncLoad), nil);

    --显示
    G_GlobalGame._loadPanel:Show();

    do
        --其他UI界面
        G_GlobalGame._otherUI = GameObject.Find("HallScenPanel");

        --先隐藏他们的UI界面
        if (G_GlobalGame._otherUI ~= nil) then
            G_GlobalGame._otherUI:SetActive(false);
        end
    end


end

local targetFrameRate;

function MainPanel.Start(obj)
    --targetFrameRate = UnityEngine.Application.targetFrameRate;
    --UnityEngine.Application.targetFrameRate = 60;
end

function MainPanel:OnDestroy()
    Event.RemoveListener(HallScenPanel.ReconnectEvent, self.Reconnect);
end

--回到游戏
function MainPanel:Reconnect()
    logYellow("回到游戏")

    G_GlobalGame._clientSession:OnReloadGame()

    --coroutine.start(MainPanel._WaitTime)
end

function MainPanel:_WaitTime()
    coroutine.wait(1.5)
end

--初始化消息绑定
function MainPanel:Init()

    MessgeEventRegister.Game_Messge_Un(); --清除消息事件
    -- 绑定消息事件
    local eventObj = G_GlobalGame._clientSession;
    EventCallBackTable._01_GameInfo = handler(eventObj, eventObj.OnMessageHandler);--游戏消息
    EventCallBackTable._02_ScenInfo = handler(eventObj, eventObj.OnSceneInfoHandler);--场景消息
    EventCallBackTable._03_LogonSuccess = handler(eventObj, eventObj.OnLoginSuccess);--玩家登陆成功
    EventCallBackTable._04_LogonOver = handler(eventObj, eventObj.OnLoginOver);
    EventCallBackTable._05_LogonFailed = handler(eventObj, eventObj.OnLoginFailed);
    EventCallBackTable._06_Biao_Action = handler(eventObj, eventObj.OnBiaoAction);
    EventCallBackTable._07_UserEnter = handler(eventObj, eventObj.OnUserEnter);
    EventCallBackTable._08_UserLeave = handler(eventObj, eventObj.OnUserLeave);
    EventCallBackTable._09_UserStatus = handler(eventObj, eventObj.OnUserStatus);
    EventCallBackTable._10_UserScore = handler(eventObj, eventObj.OnUserScore);
    EventCallBackTable._11_GameQuit = handler(self, self.OnQuitGame);--1
    EventCallBackTable._12_OnSit = handler(eventObj, eventObj.OnSitRet);
    EventCallBackTable._13_ChangeTable = handler(eventObj, eventObj.OnChangeTable);
    EventCallBackTable._14_RoomBreakLine = handler(eventObj, eventObj.OnRoomBreakLine);
    EventCallBackTable._15_OnBackGame = handler(eventObj, eventObj.OnBackGame);
    EventCallBackTable._16_OnHelp = handler(self, self.OnClickHelp);--1
    EventCallBackTable._17_OnStopGame = handler(eventObj, eventObj.OnStopGame);
    MessgeEventRegister.Game_Messge_Reg(EventCallBackTable);

    GameManager.GameScenIntEnd(G_GlobalGame._tipLayer);
    GameManager.PanelRister(obj);

end

--初始化系统
function MainPanel:InitSystem()
    math.randomseed(os.time());
end

function function_name()

end

function MainPanel:_setCamera(bool)

end


--点击帮助按钮
function MainPanel:OnClickHelp()
    --error("打开帮助界面")
    --打开帮助界面
    G_GlobalGame:OpenHelpPanel();
end

--退出游戏
function MainPanel:OnQuitGame()
    --error("退出游戏")
    G_GlobalGame._clientSession:Number_Zero()
    G_GlobalGame._gameControl:OnClearBet();
    --UnityEngine.Application.targetFrameRate = targetFrameRate;
    GameNextScenName = gameScenName.HALL;--下一个场景
    MessgeEventRegister.Game_Messge_Un();--注销事件
    GameSetsBtnInfo.LuaGameQuit();      --加载下一个场景
    --是否退出有些了
    G_GlobalGame.isQuitGame = true;
    --删除内存
    G_GlobalGame._goFactory:clear();
    --声音销毁
    G_GlobalGame._soundCtrl:Destroy();
    --关闭日志
    G_GlobalGame:closeLog();
    --清理GC内存
    --Util.ClearManager();
    --显示他们的UI
    G_GlobalGame._otherUI:SetActive(true);
end

--update
function MainPanel.Update()
    local _dt = Time.deltaTime;
    if G_GlobalGame and not G_GlobalGame.isQuitGame then
        --        local real = 0;
        --        if G_GlobalGame:isOpenLog() then
        --            real = os.clock();
        --        end
        G_GlobalGame._animaTool:Update(_dt);
        --        if G_GlobalGame:isOpenLog() then
        --            error("animaTool:update:" .. ( os.clock() - real));
        --            real = os.clock()
        --        end
        G_GlobalGame._clientSession:Update(_dt);
        if G_GlobalGame._loadPanel:IsLoading() then
            --加载
            G_GlobalGame._loadPanel:Update(_dt);
            if not G_GlobalGame._gameControl:IsRunGame() then
                return ;
            end
        end
        G_GlobalGame._mainPanel:TimeUpdate(_dt);
        G_GlobalGame._gameControl:Update(_dt);
    end
    --    if xpcall(function()
    --        local _dt = Time.deltaTime;
    --        if G_GlobalGame and not G_GlobalGame.isQuitGame then
    --            G_GlobalGame._animaTool:Update(_dt);
    --            G_GlobalGame._clientSession:Update(_dt);
    --            if G_GlobalGame._loadPanel:IsLoading() then
    --                --加载
    --                G_GlobalGame._loadPanel:Update(_dt);
    --                if not G_GlobalGame._gameControl:IsRunGame() then
    --                    return ;
    --                end
    --            end
    --            G_GlobalGame._mainPanel:TimeUpdate(_dt);
    --            G_GlobalGame._gameControl:Update(_dt);
    --        end
    --    end,function (msg)
    --        error(debug.traceback());
    --        --error("msg:" .. msg);
    --    end) then
    --    end
end

--FixedUpdate

function MainPanel.FixedUpdate()
    local _dt = Time.fixedDeltaTime;
    G_GlobalGame:FixedUpdate(_dt);
end

function MainPanel:TimeUpdate(_dt)

end

return MainPanel;