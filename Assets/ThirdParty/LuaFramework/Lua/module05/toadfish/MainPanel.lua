MainPanel = {}

local GOCreator = nil
local C_GlobalGame = nil
local ClientSession = nil
local GameSceneControl = nil
local SoundControl = nil
local AnimaTool = nil
--包含一些通用的lua文件
local function Include()
    --通用
    if not AlignViewClass or not AlignViewExClass then
        AlignViewClass = LuaFramework.AlignView
        AlignViewExClass = LuaFramework.AlignViewEx
    end
    if not AlignViewClassType or not AlignViewExClassType then
        AlignViewClassType = typeof(AlignViewClass)
        AlignViewClassName = "AlignView"
        AlignViewExClassType = typeof(AlignViewExClass)
        AlignViewExClassName = "AlignViewEx"
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
        Align_RightBottom = 9 --右下
    }

    AlignView = {}
    function AlignView.Awake(luatab, obj)
    end
    function AlignView.Start(luatab, obj)
        --屏幕自适配
        local alignView = obj:GetComponent(AlignViewExClassName)
        if (alignView ~= nil) then
            local localScale = obj.transform.localScale
            alignView:arrangePos()
            if not alignView.isScaleWithScreen then
                obj.transform.localScale = localScale
            end
        else
            alignView = obj:GetComponent(AlignViewClassName)
            if (alignView ~= nil) then
                local localScale = obj.transform.localScale
                alignView:arrangePos()
                if not alignView.isScaleWithScreen then
                    obj.transform.localScale = localScale
                end
            end
        end
    end
    --通用
    GamePacketName("Module05/ToadFish")
    GameRequire("Functions")
    C_GlobalGame = GameRequire("GlobalGame")
    GOCreator = GameRequire("GOCreator")
    ClientSession = GameRequire("ClientSession")
    GameSceneControl = GameRequire("GameSceneControl")
    SoundControl = GameRequire("SoundManager")
    AnimaTool = GameRequire("AnimaTool")
end

function MainPanel:ctor()
    self.bCamerAnimationEnd = false
    self.bBenginLead = false
    self.isInstanceGameObject = false
    self.beginTickCount = 0
    self.transform = nil
end

function MainPanel:Awake(obj)
    Include()
    --全局游戏
    G_GlobalGame = C_GlobalGame.New()
    G_GlobalGame._mainPanel = MainPanel

    --自己游戏窗口对象
    G_GlobalGame._gamePanelObj = obj

    G_GlobalGame._soundCtrl = SoundControl.New()
    G_GlobalGame._goFactory = GOCreator.New()

    G_GlobalGame._animaTool = AnimaTool.New()
    --设置创建器
    G_GlobalGame._animaTool:SetCreator(handler(G_GlobalGame._goFactory, G_GlobalGame._goFactory.getCommonSprite))
    G_GlobalGame:Init()

    G_GlobalGame._canvasPanelGO = G_GlobalGame._goFactory:createMainPanel()
    G_GlobalGame._canvasComponent = G_GlobalGame._canvasPanelGO.transform:GetComponent("Canvas")
    local canvasScaler = G_GlobalGame._canvasComponent:GetComponent("CanvasScaler")
    SetCanvasScalersMatch(canvasScaler, G_GlobalGame:GetCanvasRate())
    SetCanvasScalersMatch(canvasScaler, 1)
    G_GlobalGame._gameSceneGO = G_GlobalGame._goFactory:createGameScene()
    G_GlobalGame._clientSession = ClientSession.New()

    G_GlobalGame._canvasPanel = G_GlobalGame._canvasPanelGO.transform
    G_GlobalGame._canvasPanel:SetParent(obj.transform)
    G_GlobalGame._canvasPanel.localPosition = Vector3.New(0, 0, 0)
    G_GlobalGame._contentLayer = G_GlobalGame._canvasPanel:Find("Layers/ContentLayer")
    G_GlobalGame._tipLayer = G_GlobalGame._canvasPanel:Find("Layers/TipLayer")
    G_GlobalGame._systemLayer = G_GlobalGame._canvasPanel:Find("Layers/SystemLayer")

    --缓冲池
    G_GlobalGame._cachePool = G_GlobalGame._canvasPanel:Find("CachePool")

    --UI相机
    G_GlobalGame._uiCamera = G_GlobalGame._canvasPanel:Find("UICamera"):GetComponent("Camera")

    --添加游戏场景
    local gameSceneTrans = G_GlobalGame._gameSceneGO.transform
    local localScale = gameSceneTrans.localScale
    local localPosition = gameSceneTrans.localPosition
    local localRotation = gameSceneTrans.localRotation
    gameSceneTrans:SetParent(G_GlobalGame._contentLayer)
    gameSceneTrans.localScale = localScale
    gameSceneTrans.localPosition = localPosition
    gameSceneTrans.localRotation = localRotation

    --初始化
    MainPanel:Init()
    MainPanel:InitSystem()

    --游戏场景管理
    G_GlobalGame._gameSceneControl = GameSceneControl.New()
    G_GlobalGame._gameSceneControl:Init(gameSceneTrans)

    --预加载游戏体
    G_GlobalGame._goFactory:PreLoad()

    --开始时间
    G_GlobalGame._beginTickCount = Util.TickCount

    G_GlobalGame._clientSession:SendLogin()

    do
        --其他UI界面
        G_GlobalGame._otherUI = GameObject.Find("HallScenPanel")

        --先隐藏他们的UI界面
        G_GlobalGame._otherUI:SetActive(false)
    end
    G_GlobalGame._contentLayer:Find("GameScene/Border").gameObject:SetActive(false);
end

function MainPanel.Start(obj)
end

function MainPanel:Init()
    MessgeEventRegister.Game_Messge_Un() --清除消息事件
    -- 绑定消息事件
    local eventObj = G_GlobalGame._clientSession

    EventCallBackTable._01_GameInfo = handler(eventObj, eventObj.OnMessageHandler)
    EventCallBackTable._02_ScenInfo = handler(eventObj, eventObj.OnSceneInfoHandler)
    EventCallBackTable._03_LogonSuccess = handler(eventObj, eventObj.OnLoginSuccess)
    EventCallBackTable._04_LogonOver = handler(eventObj, eventObj.OnLoginOver)
    EventCallBackTable._05_LogonFailed = handler(eventObj, eventObj.OnLoginFailed)
    EventCallBackTable._06_Biao_Action = handler(eventObj, eventObj.OnBiaoAction)
    EventCallBackTable._07_UserEnter = handler(eventObj, eventObj.OnUserEnter)
    EventCallBackTable._08_UserLeave = handler(eventObj, eventObj.OnUserLeave)
    EventCallBackTable._09_UserStatus = handler(eventObj, eventObj.OnUserStatus)
    EventCallBackTable._10_UserScore = handler(eventObj, eventObj.OnUserScore)
    EventCallBackTable._11_GameQuit = handler(self, self.OnQuitGame)
    EventCallBackTable._12_OnSit = handler(eventObj, eventObj.OnSitRet)
    EventCallBackTable._13_ChangeTable = handler(eventObj, eventObj.OnChangeTable)
    EventCallBackTable._14_RoomBreakLine = handler(eventObj, eventObj.OnRoomBreakLine)
    EventCallBackTable._15_OnBackGame = handler(eventObj, eventObj.OnBackGame)
    EventCallBackTable._16_OnHelp = handler(self, self.OnClickHelp)
    EventCallBackTable._17_OnStopGame = handler(eventObj, eventObj.OnStopGame)
    MessgeEventRegister.Game_Messge_Reg(EventCallBackTable)

    GameManager.GameScenIntEnd(G_GlobalGame._tipLayer)

    --GameManager.PanelRister(obj);
end

function MainPanel:InitSystem()
    math.randomseed(os.time())
end

function MainPanel:_setCamera(bool)
end

--点击帮助按钮
function MainPanel:OnClickHelp()
    --打开帮助界面
    G_GlobalGame:OpenHelpPanel()
end

function MainPanel:OnQuitGame()
    GameNextScenName = gameScenName.HALL
    MessgeEventRegister.Game_Messge_Un()
    GameSetsBtnInfo.LuaGameQuit()
    --是否退出有些了
    G_GlobalGame.isQuitGame = true
    --删除内存
    G_GlobalGame._goFactory:clear()
    --关闭日志
    G_GlobalGame:closeLog()
    --清理GC内存
    --Util.ClearManager();
    --显示他们的UI
    G_GlobalGame._otherUI:SetActive(true)
end

function MainPanel.Update()
    local _dt = Time.deltaTime
    if G_GlobalGame or G_GlobalGame.isQuitGame then
        G_GlobalGame._clientSession:Update(_dt)
        G_GlobalGame._gameSceneControl:Update(_dt)
        G_GlobalGame._mainPanel:TimeUpdate(_dt)
    end
end

function MainPanel.FixedUpdate()
    local _dt = Time.fixedDeltaTime
    G_GlobalGame:FixedUpdate(_dt)
end

function MainPanel:TimeUpdate(_dt)
end

return MainPanel