LoadingPanel = {}

local self = LoadingPanel

self._LuaBehaviour = nil
self.transform = nil

self.isShow = false;

self.loading = nil;

local time = 0

function LoadingPanel.Init()
    if self.transform ~= nil then
        return ;
    end
    --local obj=HallScenPanel.LoadPool("LoadingPanel").gameObject
    local obj = HallScenPanel.Pool("LoadingPanel").gameObject
    if self.transform == nil then
        self.transform = obj.transform;
        self.transform.gameObject.name = "LoadingPanel"
        Util.AddComponent("LuaBehaviour", self.transform.gameObject)
    end
end

function LoadingPanel:Awake(obj)
    self.transform = obj.transform;
    self.loadProgress = self.transform:Find("Slider"):GetComponent("Slider");
    self.loadProgress.value = 0;
end

function LoadingPanel:Update()
    if self.isShow then
        if self.loadProgress.value < 0.5 then
            self.loadProgress.value = self.loadProgress.value + Time.deltaTime*0.2;
        else
            self.loadProgress.value = self.loadProgress.value + Time.deltaTime * 0.05;
            time = time + Time.deltaTime
            if time >= 60 then
                self.isShow = false
                self.Close();
                MessageBox.CreatGeneralTipsPanel("登录游戏失败", function()
                    GameSetsBtnInfo.LuaGameQuit()
                end);
            end
        end
    end
end

function LoadingPanel.Show()
    if self.transform == nil then
        local obj = HallScenPanel.Pool("LoadingPanel").gameObject
        self.transform = obj.transform;
        self.transform.gameObject.name = "LoadingPanel"
        Util.AddComponent("LuaBehaviour", self.transform.gameObject)
    end
    self.isShow = true;
end

function LoadingPanel.Close()
    self.isShow = false;
    if self.transform~=nil then
        destroy(self.transform.gameObject);
        self.transform = nil;
    end
    logYellow("LoadingPanel.Close")
end