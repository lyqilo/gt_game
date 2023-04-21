MainPanel={};

local Timer = require("Common.Timer");
--捕鱼3D的场景
local GOCreator=nil;
local C_GlobalGame=nil;
local ClientSession=nil;
local GameSceneControl=nil;
local SoundControl= nil;
local AnimaTool   = nil;

local function NewDefine()

    local V_Dis = function (va,vb)
        local x = va.x - vb.x;
        local y = va.y - vb.y;
        local z = va.z - vb.z;
        local sqrt = math.sqrt;
        return sqrt(x*x + y*y + z*z);
    end

    VECTOR2NEW = Vector2.New;
    VECTOR3NEW = Vector3.New;
    VECTOR4NEW = Vector4.New;

    VECTOR3DIS = V_Dis;
    VECTOR3ZERO = Vector3.zero;
    VECTOR3ONE = Vector3.one;
    COLORNEW   = Color.New;
    QUATERNION_EULER =  Quaternion.Euler;
    QUATERNION_LOOKROTATION = Quaternion.LookRotation;
    C_Quaternion_Zero= QUATERNION_EULER(0,0,0);
    C_Vector3_Zero = VECTOR3ZERO;
    C_Vector3_One = VECTOR3ONE;
    C_Color_One   = COLORNEW(1,1,1,1);
    V_Vector3_Value = VECTOR3ONE();
    V_Color_Value   = COLORNEW(1,1,1,1);
    ImageAnimaClassType = typeof(ImageAnima);
    ImageClassType = typeof(UnityEngine.UI.Image);--UnityEngine.UI.Image.GetClassType();
    GAMEOBJECT_NEW = GameObject.New;
    BoxColliderClassType = typeof(UnityEngine.BoxCollider);
    ParticleSystemClassType = typeof(UnityEngine.ParticleSystem);
    UTIL_ADDCOMPONENT = Util.AddComponent;
    MATH_SQRT = math.sqrt;
    MATH_SIN  = math.sin;
    MATH_COS  = math.cos;
    MATH_ATAN = math.atan;
    MATH_TAN  = math.tan;
    MATH_FLOOR= math.floor;
    MATH_ABS  = math.abs;
    MATH_RAD  = math.rad;
    MATH_RAD2DEG     =  Mathf.Rad2Deg; -- math.rad2Deg;
    MATH_DEG  = math.deg;
    MATH_DEG2RAD =  Mathf.Deg2Rad;  --math.rad2Deg;
    MATH_RANDOM = math.random;
    MATH_PI   = math.pi;
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
        Align_Normal        = 0,     --正常
        Align_LeftUp        = 1,      --左上
        Align_Up            = 2,      --上
        Align_RightUp       = 3,      --右上
        Align_Left          = 4,      --左
        Align_Mid           = 5,      --中间
        Align_Right         = 6,      --右
        Align_LeftBottom    = 7,      --左下
        Align_Bottom        = 8,      --下
        Align_RightBottom   = 9,      --右下
    };

    AlignView={};
    function AlignView.Awake(luatab,obj)

    end
    function AlignView.Start(luatab,obj)
        --屏幕自适配
        local alignView=obj:GetComponent(AlignViewExClassName);
        if(alignView~=nil) then
            local localScale = obj.transform.localScale;
            alignView:arrangePos();
            if not alignView.isScaleWithScreen then
                obj.transform.localScale = localScale;
            end
        else
            alignView=obj:GetComponent(AlignViewClassName);
            if(alignView~=nil) then
                local localScale = obj.transform.localScale;
                alignView:arrangePos();
                if not alignView.isScaleWithScreen then
                    obj.transform.localScale = localScale;
                end
            end
        end
    end
    --通用
end

--包含一些通用的lua文件
local function Include()

    GamePacketName("Module21/FishGame_3D");
    GameRequire("Functions");
    C_GlobalGame        = GameRequire("GlobalGame");
    --全局游戏
    G_GlobalGame = C_GlobalGame.New();
    G_GlobalGame:Init();
    --重命名
    G_GlobalGame_EventID = G_GlobalGame.Enum_EventID;
    G_GlobalGame_KeyValue = G_GlobalGame.Enum_KeyValue;
    G_GlobalGame_GameConfig = G_GlobalGame.GameConfig;
    G_GlobalGame_GameConfig_FishInfo = G_GlobalGame_GameConfig.FishInfo;
    G_GlobalGame_GameConfig_Bullet = G_GlobalGame_GameConfig.Bullet;
    G_GlobalGame_GameConfig_SceneConfig = G_GlobalGame_GameConfig.SceneConfig;
    G_GlobalGame_GameConfig_AnimaStyleInfo = G_GlobalGame_GameConfig.AnimaStyleInfo;
    G_GlobalGame_Enum_FishType = G_GlobalGame.Enum_FishType;
    G_GlobalGame_Enum_FISH_Effect = G_GlobalGame.Enum_FISH_Effect;
    G_GlobalGame_Enum_GoldType = G_GlobalGame.Enum_GoldType;
    G_GlobalGame_Enum_EffectType = G_GlobalGame.Enum_EffectType;
    G_GlobalGame_SoundDefine = G_GlobalGame.SoundDefine;
    G_GlobalGame_ConstDefine = G_GlobalGame.ConstDefine;
    G_GlobalGame_FunctionsLib = G_GlobalGame.FunctionsLib;
    G_GlobalGame_FunctionsLib_FUNC_GetPrefabName = G_GlobalGame_FunctionsLib.FUNC_GetPrefabName;
    G_GlobalGame_FunctionsLib_FUNC_CacheGO = G_GlobalGame_FunctionsLib.FUNC_CacheGO;
    G_GlobalGame_FunctionsLib_FUNC_AddAnimate = G_GlobalGame_FunctionsLib.FUNC_AddAnimate;
    G_GlobalGame_FunctionsLib_FUNC_GetFishPrefabName = G_GlobalGame_FunctionsLib.FUNC_GetFishPrefabName;
    G_GlobalGame_FunctionsLib_FUNC_GetFishStyleInfo  = G_GlobalGame_FunctionsLib.FUNC_GetFishStyleInfo;
    G_GlobalGame_FunctionsLib_GetFishIDByGameObject  = G_GlobalGame_FunctionsLib.GetFishIDByGameObject;
    G_GlobalGame_FunctionsLib_FUNC_GetEulerAngle = G_GlobalGame_FunctionsLib.FUNC_GetEulerAngle;
    G_GlobalGame_FunctionsLib_CreateFishName     = G_GlobalGame_FunctionsLib.CreateFishName;
    GOCreator           = GameRequire("GOCreator");
    ClientSession       = GameRequire("ClientSession");
    GameSceneControl    = GameRequire("GameSceneControl");
    SoundControl        = GameRequire("SoundManager");
    AnimaTool           = GameRequire("AnimaTool");
end


function MainPanel:ctor()

end

MainPanel.prefabPool = { };

function MainPanel.Pool(prefabName)
    local obj = MainPanel.prefabPool[prefabName];

    if obj == nil then
        local t = MainPanel.modulePanel.transform:Find("Pool");
        t = t.transform:Find(prefabName);
        if t == nil then error("没有找到 " .. prefabName); return end
        MainPanel.prefabPool[prefabName] = t.gameObject;
        return t.gameObject;
    end
    return obj;
end


function MainPanel.OnAsyncLoadOver(obj)
    G_GlobalGame._canvasPanelGO = obj;


    G_GlobalGame_clientSession = G_GlobalGame._clientSession;
    local canvasPanel;
    canvasPanel = G_GlobalGame._canvasPanelGO.transform;
    G_GlobalGame._canvasPanel = canvasPanel;
    canvasPanel:SetParent(G_GlobalGame._gamePanelTransform);
    canvasPanel.localPosition =C_Vector3_Zero;
    local layers = canvasPanel:Find("Layers");
    G_GlobalGame._layers = layers;
    G_GlobalGame._contentLayer = layers:Find("ContentLayer");
    G_GlobalGame._tipLayer     = layers:Find("TipLayer");
    G_GlobalGame._systemLayer  = layers:Find("SystemLayer");
    --UI层
    G_GlobalGame._uiLayer      = layers:Find("UILayer");
    G_GlobalGame._canvasComponent = G_GlobalGame._uiLayer:GetComponent("Canvas");

    --替换shader
    local screenObj  = G_GlobalGame._contentLayer:Find("GodRay/Screen/screen"):GetComponent("Renderer");
    screenObj.material.shader = G_GlobalGame_goFactory:getShader(G_GlobalGame.Enum_ShaderID.Custom_User_DiffMultiply);

    --3D相机
    G_GlobalGame._3DCameraTransform     = G_GlobalGame._contentLayer:Find("MainCamera");
    G_GlobalGame._3DCamera     = G_GlobalGame._3DCameraTransform:GetComponent("Camera");
    --G_GlobalGame._3DCameraTransform.gameObject:AddComponent(UnityEngine.AudioListener.GetClassType());

    --UI相机
    G_GlobalGame._uiCamera     = G_GlobalGame._uiLayer:Find("UICamera"):GetComponent("Camera");
    local pos = G_GlobalGame._uiCamera.transform.position ; 
    G_GlobalGame._uiCameraPos  = {x=pos.x,y=pos.y,z=pos.z};

    --缓存池
    G_GlobalGame._cachePool    = layers:Find("CachePool");

    --设置面板
    G_GlobalGame._setLayer     = G_GlobalGame._uiLayer:Find("SetLayer");

    --UI层
    G_GlobalGame._helpPanelTrans = G_GlobalGame._setLayer:Find("HelpPanel");

    --初始化数字图片
    G_GlobalGame:InitNumbers(layers:Find("Numbers"));

    local gameSceneTrans = G_GlobalGame._contentLayer:Find("GameScene");

    --预加载游戏体
    G_GlobalGame_goFactory:PreLoadAsync();

    G_GlobalGame._gameSceneControl:Init(gameSceneTrans,G_GlobalGame._uiLayer);

    --发送登录请求
    G_GlobalGame_clientSession:SendLogin();

    G_GlobalGame._mainPanel:DisplayMainPanel();
end

function MainPanel:DisplayMainPanel()
    local G_GlobalGame = G_GlobalGame;
    --开始时间
    G_GlobalGame._beginTickCount    = Util.TickCount;

    --初始化
    G_GlobalGame._mainPanel:Init();
    G_GlobalGame._layers.gameObject:SetActive(true);

    do
        G_GlobalGame._otherUI = GameObject.Find("GuiCamera");

        if G_GlobalGame._otherUI then
            G_GlobalGame.hallCamera = G_GlobalGame._otherUI.transform:GetComponent("Camera");
            G_GlobalGame.tempHallCullingMask = G_GlobalGame.hallCamera.cullingMask;
            G_GlobalGame.hallCamera.cullingMask = 1;
        end
    end
end

function MainPanel:AwakeBak(obj)
    error(" MainPanel:AwakeBak");
    --collectgarbage("stop");
    NewDefine();
    Include();

    G_GlobalGame._gamePanelObj = obj;
    G_GlobalGame._gamePanelTransform = obj.transform;
    local mainPanel = MainPanel--.New();
    G_GlobalGame._mainPanel = mainPanel;
    mainPanel:InitSystem();

    G_GlobalGame._soundCtrl = SoundControl.New();
    G_GlobalGame._soundCtrl:Init();

    G_GlobalGame._goFactory = GOCreator.New();
    G_GlobalGame_goFactory = G_GlobalGame._goFactory;

    G_GlobalGame._animaTool    = AnimaTool.New();
    --设置创建器
    G_GlobalGame._animaTool:SetCreator(handler(G_GlobalGame._goFactory,G_GlobalGame._goFactory.getCommonSprite));
    
    G_GlobalGame._timer = Timer.New();
    --创建
    G_GlobalGame_goFactory:createMainPanelEx(MainPanel.OnAsyncLoadOver);

    G_GlobalGame._clientSession = ClientSession.New();

        --游戏场景管理
    G_GlobalGame._gameSceneControl  = GameSceneControl.New();
end

function MainPanel:Awake(obj)
	    error(" MainPanel:Awake");

    MainPanel.modulePanel=obj;
    --collectgarbage("stop");
    NewDefine();
    Include();
    local time1 = os.clock();
    G_GlobalGame._goFactory = GOCreator.New();

    G_GlobalGame_goFactory = G_GlobalGame._goFactory;
    --创建
    G_GlobalGame._canvasPanelGO = G_GlobalGame_goFactory:createMainPanel();
    local mainPanel = MainPanel;
    G_GlobalGame._mainPanel = mainPanel;
    mainPanel:InitSystem();
    --自己游戏窗口对象
    G_GlobalGame._gamePanelObj  = obj;
    G_GlobalGame._gamePanelTransform = obj.transform;

    G_GlobalGame._soundCtrl = SoundControl.New();
    G_GlobalGame._soundCtrl:Init();
  
    G_GlobalGame._animaTool    = AnimaTool.New();
    --设置创建器
    G_GlobalGame._animaTool:SetCreator(handler(G_GlobalGame._goFactory,G_GlobalGame._goFactory.getCommonSprite));

    G_GlobalGame._clientSession = ClientSession.New();

    G_GlobalGame_clientSession = G_GlobalGame._clientSession;
    local canvasPanel = G_GlobalGame._canvasPanelGO.transform;
    G_GlobalGame._canvasPanel = canvasPanel;
    G_GlobalGame._canvasPanel:SetParent(obj.transform);
    local layers = canvasPanel:Find("Layers");
    G_GlobalGame._layers = layers;
    G_GlobalGame._layers.gameObject:SetActive(true);
    G_GlobalGame._contentLayer = G_GlobalGame._canvasPanel:Find("Layers/ContentLayer");
    G_GlobalGame._tipLayer     = G_GlobalGame._canvasPanel:Find("Layers/TipLayer");
    G_GlobalGame._systemLayer  = G_GlobalGame._canvasPanel:Find("Layers/SystemLayer");
    --UI层
    G_GlobalGame._uiLayer      = G_GlobalGame._canvasPanel:Find("Layers/UILayer");
    G_GlobalGame._canvasComponent = G_GlobalGame._uiLayer:GetComponent("Canvas");
    local canvasScaler = G_GlobalGame._uiLayer:GetComponent("CanvasScaler");
    SetCanvasScalersMatch(canvasScaler,G_GlobalGame:GetCanvasRate());
    --替换shader

    local screenObj  = G_GlobalGame._contentLayer:Find("GodRay/Screen/screen"):GetComponent("Renderer");
    --screenObj.material.shader = G_GlobalGame_goFactory:getShader(G_GlobalGame.Enum_ShaderID.Custom_User_DiffMultiply);

    --3D相机
    G_GlobalGame._3DCameraTransform     = G_GlobalGame._contentLayer:Find("MainCamera");
    G_GlobalGame._3DCamera     = G_GlobalGame._3DCameraTransform:GetComponent("Camera");
    --G_GlobalGame._3DCameraTransform.gameObject:AddComponent(UnityEngine.AudioListener.GetClassType());

    --UI相机
    G_GlobalGame._uiCamera     = G_GlobalGame._uiLayer:Find("UICamera"):GetComponent("Camera");
    local pos = G_GlobalGame._uiCamera.transform.position ; 
    G_GlobalGame._uiCameraPos  = {x=pos.x,y=pos.y,z=pos.z};

    --缓存池
    G_GlobalGame._cachePool    = G_GlobalGame._canvasPanel:Find("Layers/CachePool");

    --设置面板
    G_GlobalGame._setLayer     = G_GlobalGame._uiLayer:Find("SetLayer");

    --UI层
    G_GlobalGame._helpPanelTrans = G_GlobalGame._setLayer:Find("HelpPanel");

    --初始化数字图片 
    G_GlobalGame:InitNumbers(G_GlobalGame._canvasPanel:Find("Layers/Numbers"));

    local gameSceneTrans = G_GlobalGame._contentLayer:Find("GameScene");

    --游戏场景管理
    G_GlobalGame._gameSceneControl  = GameSceneControl.New();
    G_GlobalGame._gameSceneControl:Init(gameSceneTrans,G_GlobalGame._uiLayer);

    --预加载游戏体
    G_GlobalGame_goFactory:PreLoad();

    --开始时间
    G_GlobalGame._beginTickCount    = Util.TickCount;

    --初始化
    mainPanel:Init();
    

    G_GlobalGame._clientSession:SendLogin();

    G_GlobalGame._timer = Timer.New();

    do
        G_GlobalGame._otherUI = GameObject.Find("GuiCamera");

        if G_GlobalGame._otherUI then
            G_GlobalGame.hallCamera = G_GlobalGame._otherUI.transform:GetComponent("Camera");
            G_GlobalGame.tempHallCullingMask = G_GlobalGame.hallCamera.cullingMask;
            G_GlobalGame.hallCamera.cullingMask = 1;
        end

    end
end

function MainPanel:Init()
    MessgeEventRegister.Game_Messge_Un(); --清除消息事件
    -- 绑定消息事件
    local eventObj =G_GlobalGame._clientSession;

    EventCallBackTable._01_GameInfo = handler(eventObj,eventObj.OnMessageHandler);
    EventCallBackTable._02_ScenInfo = handler(eventObj,eventObj.OnSceneInfoHandler);
    EventCallBackTable._03_LogonSuccess = handler(eventObj,eventObj.OnLoginSuccess);
    EventCallBackTable._04_LogonOver = handler(eventObj,eventObj.OnLoginOver);
    EventCallBackTable._05_LogonFailed = handler(eventObj,eventObj.OnLoginFailed);
    EventCallBackTable._06_Biao_Action = handler(eventObj,eventObj.OnBiaoAction);
    EventCallBackTable._07_UserEnter = handler(eventObj,eventObj.OnUserEnter);
    EventCallBackTable._08_UserLeave = handler(eventObj,eventObj.OnUserLeave);
    EventCallBackTable._09_UserStatus = handler(eventObj,eventObj.OnUserStatus);
    EventCallBackTable._10_UserScore  = handler(eventObj,eventObj.OnUserScore);
    EventCallBackTable._11_GameQuit = handler(self,self.OnQuitGame);
    EventCallBackTable._12_OnSit = handler(eventObj,eventObj.OnSitRet);
    EventCallBackTable._13_ChangeTable = handler(eventObj,eventObj.OnChangeTable);
    EventCallBackTable._14_RoomBreakLine = handler(eventObj,eventObj.OnRoomBreakLine);
    EventCallBackTable._15_OnBackGame    = handler(eventObj,eventObj.OnBackGame);
    EventCallBackTable._16_OnHelp = handler(self,self.OnClickHelp);
    EventCallBackTable._17_OnStopGame = handler(eventObj,eventObj.OnStopGame);
    EventCallBackTable._18_OnHandleMessage = handler(eventObj,eventObj.OnHandleMessage);
    MessgeEventRegister.Game_Messge_Reg(EventCallBackTable);

    GameManager.GameScenIntEnd(G_GlobalGame._tipLayer);

    GameManager.PanelRister(G_GlobalGame._gamePanelObj);
    --GameManager.PanelInitSucceed(G_GlobalGame._gamePanelObj);

    G_GlobalGame_FunctionsLib.SetGameObjectsLayer( G_GlobalGame._setLayer.gameObject,G_GlobalGame.Enum_Layer.UI);
end

function MainPanel:InitSystem()
    math.randomseed(os.time());
    --屏幕适配
    --SuperLuaFramework.AlignView.setScreenArgs(Screen.height,Screen.width,1334,750,true);
end

function MainPanel:_setCamera(bool)
    
end


--点击帮助按钮
function MainPanel:OnClickHelp()
    --打开帮助界面
    G_GlobalGame:OpenHelpPanel();
end

function MainPanel:OnQuitGame()
	G_GlobalGame.bulletId=0;
    --collectgarbage("restart");
    MainPanel.prefabPool = {};
    if G_GlobalGame.isQuitGame then
        return ;
    end
    GameNextScenName = gameScenName.HALL;
    MessgeEventRegister.Game_Messge_Un();
    GameSetsBtnInfo.LuaGameQuit();
   
   local goFactory = G_GlobalGame_goFactory;
    --关闭日志
    G_GlobalGame:closeLog();
    --清理GC内存
    --Util.ClearManager();
    G_GlobalGame._gameSceneControl:Unload();
    G_GlobalGame:Clear();
    G_GlobalGame._animaTool = nil;
    --显示他们的UI
    if G_GlobalGame.hallCamera then
        G_GlobalGame.hallCamera.cullingMask = G_GlobalGame.tempHallCullingMask;
    end
    --G_GlobalGame = {};
    MainPanel = {};
    --是否退出有些了
    G_GlobalGame.isQuitGame = true;
    --删除内存
    goFactory:clear();
end

local dataTime=0;
function MainPanel.Update()
    local _dt = Time.deltaTime;
    --and G_GlobalGame._isInitResourceSuccess
    if G_GlobalGame and not G_GlobalGame.isQuitGame
         then
        G_GlobalGame._clientSession:Update(_dt);
        G_GlobalGame._gameSceneControl:Update(_dt);
        G_GlobalGame._mainPanel:TimeUpdate(_dt);
        G_GlobalGame:Update(_dt);
    end
end

function MainPanel.FixedUpdate()
    local _dt = Time.fixedDeltaTime;
    if G_GlobalGame and not G_GlobalGame.isQuitGame then
        G_GlobalGame:FixedUpdate(_dt);
        --每帧执行
        G_GlobalGame._timer:Execute(_dt);
    end
end

function MainPanel:TimeUpdate(_dt)
    
end


return MainPanel;