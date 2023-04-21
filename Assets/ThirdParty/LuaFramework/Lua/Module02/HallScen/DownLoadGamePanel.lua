DownLoadGamePanel = { }
local self = DownLoadGamePanel;
self.currentDown = nil;
self.transform = nil;
self.isLoad = false;
function DownLoadGamePanel.Init()
    if self.transform == nil then
        local go = HallScenPanel.Pool("DownLoadGamePanel", true);
        self.transform = go.transform;
        --self.transform:SetParent(HallScenPanel.Compose.transform);
        self.transform.localPosition = Vector3.New(0, 0, 0);
        self.transform.localScale = Vector3.New(1, 1, 1);
    end
    self.downLoadPanel = self.transform:Find("Content");
    self.downProgress = self.downLoadPanel:Find("Progress"):GetComponent("Slider");
    self.downloadDesc = self.downLoadPanel:Find("Desc"):GetComponent("Text");
    self.downloadValue = self.downLoadPanel:Find("ProgressValue"):GetComponent("Text");
    self.downloadCloseBtn = self.downLoadPanel:Find("Close"):GetComponent("Button");
    if HallScenPanel.isReconnectGame then
        self.downloadCloseBtn.gameObject:SetActive(false);
    else
        self.downloadCloseBtn.gameObject:SetActive(true);
    end
    self.downloadCloseBtn.onClick:RemoveAllListeners();
    self.downloadCloseBtn.onClick:AddListener(function()
        if self.currentDown ~= nil then
            destroy(self.currentDown.gameObject);
        end
        self.Close();
        HallScenPanel.PlayeBgMusic();
    end);
end
function DownLoadGamePanel.DownLoadGame(gameName, callback)
    self.Init();
    self.downProgress.value = 0;
    if UpdateFile.isDown(gameName) then
        self.downloadDesc.text = "正在下载游戏";
        self.downloadValue.text = "0%";
        local down = function(a, b)
            self.downloadValue.text = tostring(math.floor(a * 100)) .. "%";
            self.downProgress.value = a;
            if a >= 1 then
                self.LoadGame(gameName, callback);
            elseif a < 0 then
                self.downloadDesc.text = "下载错误";
            end
        end
        self.currentDown = UpdateFile.UnityWebRequestAsync(gameName, down);

    else
        self.LoadGame(gameName, callback);
    end
end
function DownLoadGamePanel.LoadGame(gameName, callback)
    self.Init();
    self.downloadDesc.text = "正在加载游戏";
    --LoadingPanel.Show();
    self.downloadCloseBtn.gameObject:SetActive(false);
    table.insert(LaunchModule.sceneList, gameName);
    LoadSceneAsync(gameName, function(apt)
        local f = function()
            while not apt.isDone do
                self.downloadValue.text = tostring(math.floor(apt.progress * 100)) .. "%";
                self.downProgress.value = apt.progress;
                coroutine.wait(0.01);
            end
            self.downProgress.value = 1;
            self.downloadValue.text = 100 .. "%";
        end
        coroutine.start(f);
        if callback ~= nil then
            callback(apt);
        end
    end, 1);
end
function DownLoadGamePanel.Close()
    if self.transform ~= nil then
        destroy(self.transform.gameObject);
        self.transform = nil;
    end
end