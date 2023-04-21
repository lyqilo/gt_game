LaunchModule = { };
local self = LaunchModule;

local modulePanel = nil;

self.currentSceneName = "module02";

local fun1 = nil
local fun2 = nil

LaunchModule.LoadType = {
    _01LuaBehaviour = 1;
    _02CsJoinLua = 2;
    _03Scene = 3;
}

LaunchModule.Tag = {
    _01frameTag = "rootFrameModule",
    _02hallTag = "rootHallModule",
    _01gameTag = "rootGameModule",
    _GameMgr = "GameManager"
}
self.IsILRuntime = false;
-- 进入游戏
function LaunchModule.Enter(scenName)
    self.sceneList = {};
    self.IsILRuntime = false;
    --logError("进入游戏-----------------------------"..scenName)
    local modeName = "nil";
    local driveType = "LuaBehaviour";
    HallScenPanel.PlayeBgMusic(false);
    -- LuaBehaviour驱动lua代码
    local luaDrive1 = function()
        local go = GameObject.New();
        go.name = modeName;
        go.tag = UnitTag.gameModuleSign;
        go.transform.localScale = Vector3.New(1, 1, 1);
        go.transform.localPosition = Vector3.New(0, 0, 0);
        Util.AddComponent(driveType, go);
        GameManager.PanelRister(go);
        self.modulePanel = go;
    end

    -- CsJoinLua驱动lua代码
    local luaDrive2 = function(path)
        local go = GameObject.New();
        go.name = modeName;
        go.tag = UnitTag.gameModuleSign;
        go.transform.localScale = Vector3.New(1, 1, 1);
        go.transform.localPosition = Vector3.New(0, 0, 0);
        local CS = go:AddComponent(typeof(CsJoinLua));
        CS:LoadLua(path, modeName);
        GameManager.PanelRister(go);
        self.modulePanel = go;
        return ;
    end

    --    DownTishiInfo.clearAllDown();
    local t = GameManager.PassScenNameToConfiger(scenName);
    logError("初始化模块代码：" .. t.configer().luaPath)
    -- 初始化模块代码
    if t.configer().driveType ~= "ILRuntime" then
        reimport(t.configer().luaPath)
        self.IsILRuntime = false;
    else
        self.IsILRuntime = true;
    end
    logError("初始化模块代码：1")
    --require("module24.serialindiana.MainPanel")  
    --require("module24.serialindiana.MainPanel")
    --logError("初始化模块代码============================：");
    local str = System.String.New(t.configer().luaPath);

    local strArry = { };

    -- 获取lua文件名字作为lua tab
    if str:Contains('/') then
        strArry = str:Split('/', 5);
    end
    if str:Contains('.') then
        strArry = str:Split('.', 5);
    end
    modeName = strArry[strArry.Length - 1];
    log("launch module name: " .. modeName);
    self.currentSceneName = strArry[0];
    self.currentModuleName = modeName;

    self.currentModuleConfiger = t.configer();
    logTable(self.currentModuleConfiger);
    self.currentHallScene = GameObject.Find("HallScenPanel");

    HallScenPanel.waitTransform.gameObject:SetActive(false);
    if t.configer().driveType == driveType then
        luaDrive1();
        self.currentEnterMod = LaunchModule.LoadType._01LuaBehaviour;
    elseif t.configer().driveType == "CsJoinLua" then
        luaDrive2(t.configer().luaPath);
        self.currentEnterMod = LaunchModule.LoadType._02CsJoinLua;
    elseif t.configer().driveType == "Scene" then
        DownLoadGamePanel.DownLoadGame(t.scenName, self.EnterSucceed);
        self.currentSceneName = t.scenName;--部分游戏使用的场景
        logError("场景名字-----------------" .. self.currentSceneName)
        self.currentEnterMod = LaunchModule.LoadType._03Scene;
        self.currentHallScene = GameObject.FindGameObjectWithTag(LaunchModule.Tag._02hallTag);
    elseif t.configer().driveType == "Prefab" then

        DownLoadGamePanel.DownLoadGame(t.scenName, self.LoadSceneSuccessd);
        self.currentSceneName = t.scenName;--部分游戏使用的场景
        logError("场景名字-----------------" .. self.currentSceneName)
        self.currentEnterMod = LaunchModule.LoadType._03Scene;
        self.currentHallScene = GameObject.FindGameObjectWithTag(LaunchModule.Tag._02hallTag);
    elseif t.configer().driveType == "ILRuntime" then

        DownLoadGamePanel.DownLoadGame(t.scenName, self.LoadILSceneSuccessd);
        self.currentSceneName = t.scenName;--部分游戏使用的场景
        logError("场景名字-----------------" .. self.currentSceneName)
        self.currentEnterMod = LaunchModule.LoadType._03Scene;
        self.currentHallScene = GameObject.FindGameObjectWithTag(LaunchModule.Tag._02hallTag);
    end

    log("Load game start scen.");
end
self.sceneList = {};
function LaunchModule.LoadILSceneSuccessd(apt)
    local f = function(apt)
        coroutine.wait(0.2)
        while not apt.isDone do
            coroutine.wait(0)
        end
        DownLoadGamePanel.Close();
        ILRuntimeManager:EnterGame(self.currentSceneName);
        HallScenPanel.waitTransform.gameObject:SetActive(false);
        self.modulePanel = LuaBehaviourRoot;
        self.currentHallScene = HallScenPanel.Compose.transform.parent.parent.parent.gameObject;
        self.currentHallScene.gameObject:SetActive(false);

        --HallScenPanel.GC(self.currentSceneName);
        coroutine.wait(1);
        LoadingPanel.Close();
        fun1 = nil
    end
    fun1 = coroutine.start(f, apt);
end
function LaunchModule.LoadSceneSuccessd(apt)
    local f = function(apt)
        coroutine.wait(0.2)
        while not apt.isDone do
            coroutine.wait(0)
        end
        local LuaBehaviourRoot = GameObject.FindGameObjectWithTag(LaunchModule.Tag._01gameTag);
        local LuaBehaviour = LuaBehaviourRoot:GetComponent("LuaBehaviour");
        if LuaBehaviour == nil then
            Util.AddComponent("LuaBehaviour", LuaBehaviourRoot);
        end
        while not GameManager.isEnterGame do
            coroutine.wait(0.1);
        end
        coroutine.wait(1);
        DownLoadGamePanel.Close();
        HallScenPanel.waitTransform.gameObject:SetActive(false);
        self.modulePanel = LuaBehaviourRoot;
        self.currentHallScene = HallScenPanel.Compose.transform.parent.parent.parent.gameObject;
        self.currentHallScene.gameObject:SetActive(false);

        --HallScenPanel.GC(self.currentSceneName);
        coroutine.wait(1);
        LoadingPanel.Close();
        fun1 = nil
    end
    fun1 = coroutine.start(f, apt);
end
-- 加载模块的异步回掉
function LaunchModule.EnterSucceed(apt)

    local f = function(apt)
        coroutine.wait(0.2)
        while not apt.isDone do
            coroutine.wait(0)
        end
        --LoadingPanel.Show();
        log(self.currentModuleName);
        local LuaBehaviourRoot = find(self.currentModuleName)
        if LuaBehaviourRoot ~= nil then
            local LuaBehaviour = LuaBehaviourRoot:GetComponent("LuaBehaviour");
            if LuaBehaviour == nil then
                Util.AddComponent("LuaBehaviour", LuaBehaviourRoot);
            end
        else
            error("没找到===LuaBehaviourRoot");
        end
        while not GameManager.isEnterGame do
            coroutine.wait(0.1);
        end

        coroutine.wait(1);

        HallScenPanel.waitTransform.gameObject:SetActive(false);
        DownLoadGamePanel.Close();
        self.modulePanel = GameObject.FindGameObjectWithTag(LaunchModule.Tag._01gameTag);
        --HallScenPanel.GC(self.currentSceneName);
        --self.currentHallScene = GameObject.Find("HallScenPanel");
        --self.currentHallScene = GameObject.FindGameObjectWithTag(LaunchModule.Tag._02hallTag);
        self.currentHallScene = HallScenPanel.Compose.transform.parent.parent.parent.gameObject;
        self.currentHallScene.gameObject:SetActive(false);
        coroutine.wait(1);
        LoadingPanel.Close();
        fun2 = nil
    end
    fun2 = coroutine.start(f, apt);
end

function LaunchModule.StopEnterGame()
    if fun1 ~= nil then
        coroutine.stop(fun1)
        fun1 = nil
    end
    if fun2 ~= nil then
        coroutine.stop(fun2)
        fun2 = nil
    end
end
-- 退出模块处理
function LaunchModule.Quit()
    -- Loading隐藏

    --HallScenPanel.waitTransform.gameObject:SetActive(false);

    HallScenPanel.IsInGame = false;

    --大厅Root显示
    --if (IsNil(self.currentHallScene)) then
    --    logError("not find currentHallScene!")
    --    return
    --end

    --HallScenPanel.Compose.transform.parent.parent.parent.gameObject:SetActive(true);
    --HallScenPanel.modulePanel.gameObject:SetActive(true);

    --当前模块->大厅模块
    --self.modulePanel = HallScenPanel.modulePanel;

    AllSetGameInfo._5IsPlayAudio = MusicManager:GetIsPlayMV();
    AllSetGameInfo._6IsPlayEffect = MusicManager:GetIsPlaySV();
    MusicManager:KillAllSoundEffect()
    HallScenPanel.PlayeBgMusic()
    --（1）如果是场景，直接卸载场景  （2）如果是界面，直接销毁
    SceneManager.UnloadSceneAsync(self.currentSceneName);
    if self.currentEnterMod == LaunchModule.LoadType._03Scene or self.currentEnterMod == "Prefab" then
        if self.currentSceneName == "module02" then
            return
        end
        SceneManager.UnloadSceneAsync(self.currentSceneName);
        --for i = 1, #self.sceneList do
        --    if self.sceneList[i] == self.currentSceneName then
        --        SceneManager.UnloadSceneAsync(self.currentSceneName);
        --        table.remove(self.sceneList, i);
        --    end
        --end

        --Util.isAndroidPlatform
        if Util.isApplePlatform then
            Util.GC();
            GamesCleanPanel.UnLoadBundle({ name = self.currentSceneName });
        end
    else
        destroy(self.modulePanel.gameObject);
    end
    --当前场景->module02
    self.currentSceneName = "module02";

    this.isEnterGame = false
end




