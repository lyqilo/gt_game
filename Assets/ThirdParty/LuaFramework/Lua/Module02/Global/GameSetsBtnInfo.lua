-- lua游戏场景名字
LuaGameScenName = {
    "Point21_2D", "shuihuzhuan", "Baccara", "Fish3D", "Baccarat",
}
GameSetsBtnInfo = { }
local self = GameSetsBtnInfo;
local _LuaBehaviour;
local gameObject;
local transform;
local IsMoveAnimator = false;
local MoveXDistance = 0;
local MoveYDistance = 0;
local MovePos = 0;
local IsLuaGame = true;
local IsInitgamemusic = false
local IsInitgamesound = false


local isInitS = false
local isInitM = false

-- ===========================================游戏中设置总按钮信息系统======================================
function GameSetsBtnInfo.Init(obj, LuaBehaviour)
    logYellow("GameSetsBtnInfo.Init")
    -- isInitS=true
    -- isInitM=true

    gameObject = obj;
    transform = obj.transform;
    local t = transform;
    -- 赋值自己
    self.GameSetsBtnPanel = obj;
    self.GameSetsBtnPanel:GetComponent("RectTransform").anchorMax = Vector2.New(1,1);
   self.GameSetsBtnPanel:GetComponent("RectTransform").anchorMin = Vector2.New(0,0);
   self.GameSetsBtnPanel:GetComponent("RectTransform").offsetMax = Vector2.New(0,0);
   self.GameSetsBtnPanel:GetComponent("RectTransform").offsetMin = Vector2.New(0,0);
    self.RecFrameBtns = t:Find("RecFrameMask").gameObject;
    self.RecFrameClose = t:Find("RecFrameMask/Close").gameObject;
    self.GameSetsBtn = t:Find("SetsBtn").gameObject;
    self.MainBtns = t:Find("RecFrameMask/RecFrameBtns").gameObject;
    self.HelpBtn = t:Find("RecFrameMask/RecFrameBtns/HelpBtn").gameObject;
    self.BgMusicBtn = t:Find("RecFrameMask/RecFrameBtns/BgMusicBtn").gameObject;
    self.ReturnBtn = t:Find("RecFrameMask/RecFrameBtns/ReturnBtn").gameObject;
    self.SetInfoPanel = nil;
    self.HelpInfoPanel = nil;
    self.Suona = t:Find("Suona").gameObject;
    self.PlaySuona = t:Find("PlaySuona").gameObject;
    self.Suona.gameObject:SetActive(false);
    self.PlaySuona:SetActive(false);

    self.GameSetsBtn.transform:Find("down").gameObject:SetActive(true)
    self.GameSetsBtn.transform:Find("up").gameObject:SetActive(false)

    self.musicPanel = t:Find("MusicPanel").gameObject;
    self.mainPanel = self.musicPanel.transform:Find("MainPanel")
    self.CloseBtn = self.mainPanel:Find("CloseBtn")

    --self.BgMusicOpenBtn = self.mainPanel:Find("Image/Image1/BgMusic/dk"):GetComponent("Toggle");
    --self.BgMusicCloseBtn = self.mainPanel:Find("Image/Image1/BgMusic/gb"):GetComponent("Toggle");
    self.BgMusicSlider = self.mainPanel:Find("Group/Music/Slider"):GetComponent("Slider");
    
    --self.BgSoundOpenBtn = self.mainPanel:Find("Image/Image2/BgSound/dk"):GetComponent("Toggle");
    --self.BgSoundCloseBtn = self.mainPanel:Find("Image/Image2/BgSound/gb"):GetComponent("Toggle");
    self.BgSoundSlider = self.mainPanel:Find("Group/Sound/Slider"):GetComponent("Slider");
    -- 用户头像的点击事件
    LuaBehaviour:AddClick(self.CloseBtn.gameObject, self.RenWuPanelClose);
    --self.BgMusicOpenBtn.onValueChanged:RemoveAllListeners();
    --self.BgMusicOpenBtn.onValueChanged:AddListener(self.BgMusicBtnOnClick);
    self.BgMusicSlider.value = MusicManager:GetIsPlayMV() and MusicManager:GetMusicVolume() or 0;
    self.BgSoundSlider.value = MusicManager:GetIsPlaySV() and MusicManager:GetSoundVolume() or 0;
    self.BgMusicSlider.onValueChanged:RemoveAllListeners();
    self.BgMusicSlider.onValueChanged:AddListener(self.BgMusicBtnOnClick);
    self.BgSoundSlider.onValueChanged:RemoveAllListeners();
    self.BgSoundSlider.onValueChanged:AddListener(self.BgSoundBtnOnClick);
    --self.BgSoundOpenBtn.onValueChanged:RemoveAllListeners();
    --self.BgSoundOpenBtn.onValueChanged:AddListener(self.BgSoundBtnOnClick);
    --self.RecFrameBtns.transform.localPosition = Vector3.New(1200, self.RecFrameBtns.transform.localPosition.y, self.RecFrameBtns.transform.localPosition.z)
    self.RecFrameBtns:SetActive(false);
    -- if AllSetGameInfo._5IsPlayAudio == false or AllSetGameInfo._6IsPlayEffect == false then
    --     self.BgMusicBtn.transform:Find("off").gameObject:SetActive(true);
    --     self.BgMusicBtn.transform:Find("open").gameObject:SetActive(false);
    -- else
    --     self.BgMusicBtn.transform:Find("off").gameObject:SetActive(false);
    --     self.BgMusicBtn.transform:Find("open").gameObject:SetActive(true);
    -- end 
    -- 绑定事件
    LuaBehaviour:AddClick(self.GameSetsBtn, self.GameSetsBtnOnClick);
    LuaBehaviour:AddClick(self.HelpBtn, self.HelpBtnOnClick);

    LuaBehaviour:AddClick(self.BgMusicBtn, self.SetBtnOnClick);

    LuaBehaviour:AddClick(self.ReturnBtn, self.ReturnBtnOnClick);
    LuaBehaviour:AddClick(self.RecFrameClose, self.CloseBts);
    self._LuaBehaviour = LuaBehaviour;
    IsLuaGame = false;
    --  self.HelpBtn:SetActive(gameIsOnline);
    TishiScenes = gameServerName.SFZ;
    --  if #TishiTextInfo ~= 0 then MessageBox.ShowTableInfo() end
    -- 移动一个长度
    --MoveNotifyInfoClass.Int();
    --MoveNotifyInfoClass.ReturnAnimator();
    --MoveNotifyInfoClass.PlayerDeleteNotifyInfo();
    t.localPosition = Vector3.New(0, 0, 0);
    -- 進入游戲后再關閉房間選擇界面
    -- GameRoomList.ClosePanelBtnOnClick();
    local fScenSeverName = ScenSeverName;
    if string.find(fScenSeverName, gameServerName.POINTS21) then
        --        self.HelpBtn:SetActive(false);
        --        self.MainBtns.transform:GetComponent("RectTransform").sizeDelta=Vector2.New(260,200);
        --        self.MainBtns.transform.localPosition=Vector3.New(80,120,0);
        t.localPosition = Vector3.New(0, 0, 100);
    elseif string.find(fScenSeverName, gameServerName.Baccara) then
        self.HelpBtn:SetActive(false);
        -- self.MainBtns.transform:GetComponent("RectTransform").sizeDelta = Vector2.New(90, 156);
        -- self.MainBtns.transform.localPosition = Vector3.New(102, 273, 0);
    elseif string.find(fScenSeverName, gameServerName.Game08) then
        self.HelpBtn:SetActive(false);
        self.MainBtns.transform:GetComponent("RectTransform").sizeDelta = Vector2.New(90, 156);
        self.MainBtns.transform.localPosition = Vector3.New(102, 273, 0);
    elseif string.find(fScenSeverName, gameServerName.Game06) then
        self.HelpBtn:SetActive(false);
        self.MainBtns.transform:GetComponent("RectTransform").sizeDelta = Vector2.New(156, 156);
        self.MainBtns.transform.localPosition = Vector3.New(102, 273, 0);
    elseif string.find(fScenSeverName, gameServerName.Game11) then
        self.HelpBtn:SetActive(false);
        self.MainBtns.transform:GetComponent("RectTransform").sizeDelta = Vector2.New(156, 156);
        self.MainBtns.transform.localPosition = Vector3.New(102, 273, 0);
    else
    end
end

function GameSetsBtnInfo.BgMusicBtnOnClick(value1)
    logYellow("BgMusicBtnOnClick=="..tostring(value1))
    logYellow("isInitM=="..tostring(isInitM))

    if isInitM then
        isInitM = false
        return 
    end
    --HallScenPanel.PlayeBtnMusic()
    local value=value1;
    ----if value1 then
    ----    value=1
    ----else
    ----    value=0
    ----end ;
    --
    --local isplay = AllSetGameInfo._5IsPlayAudio;
    --if value == 0 then
    --    AllSetGameInfo._5IsPlayAudio = false;
    --else
    --    AllSetGameInfo._5IsPlayAudio = true;
    --end
    --Util.Write("IsPlayAudio", tostring(AllSetGameInfo._5IsPlayAudio));
    --PlayerPrefs.SetString("IsPlayAudio", tostring(AllSetGameInfo._5IsPlayAudio));
    --PlayerPrefs.SetString("MusicValue", tostring(value));
    --GameManager.SetIsPlayMute(AllSetGameInfo._6IsPlayEffect, AllSetGameInfo._5IsPlayAudio);

    local soundValue = MusicManager:GetSoundVolume();
    --if PlayerPrefs.HasKey("SoundValue") then
    --    soundValue = PlayerPrefs.GetString("SoundValue");
    --end
    MusicManager:SetValue(tonumber(soundValue), tonumber(value))
    MusicManager:SetMusicMute(value <= 0);
end
--> (点击事件) 设置静音
function GameSetsBtnInfo.BgSoundBtnOnClick(value1)
    logYellow("BgSoundBtnOnClick=="..tostring(value1))
    logYellow("isInitS=="..tostring(isInitS))

    if isInitS then
        isInitS = false
        return 
    end
    local value=value1

    --if value1 then
    --    value=1
    --else
    --    value=0
    --end ;
    --if value == 0 then
    --    AllSetGameInfo._6IsPlayEffect = false;
    --else
    --    AllSetGameInfo._6IsPlayEffect = true;
    --end
    --Util.Write("isCanPlaySound", tostring(AllSetGameInfo._6IsPlayEffect));
    --PlayerPrefs.SetString("isCanPlaySound", tostring(AllSetGameInfo._6IsPlayEffect));
    --
    --PlayerPrefs.SetString("SoundValue", tostring(value));
    --GameManager.SetIsPlayMute(AllSetGameInfo._6IsPlayEffect, AllSetGameInfo._5IsPlayAudio);
    local musicValue = MusicManager:GetMusicVolume();
    --if PlayerPrefs.HasKey("MusicValue") then
    --    musicValue = PlayerPrefs.GetString("MusicValue");
    --end
    MusicManager:SetValue(tonumber(value), tonumber(musicValue))
    MusicManager:SetSoundMute(value <= 0);
end

function GameSetsBtnInfo.RenWuPanelClose()
    HallScenPanel.PlayeBtnMusic()
    self.musicPanel:SetActive(false);
end

function GameSetsBtnInfo.SetPlaySuonaPos(x, y, z)
    local posx = x or 0;
    local posy = y or -120;
    local posz = z or 0;

    if IsNil(self.PlaySuona) then
        error("设置公告物体的坐标失败")
        return
    end
    self.PlaySuona.transform.localPosition = Vector3.New(posx, posy, posz);
end
--- 功能集合按钮的点击事件
function GameSetsBtnInfo.GameSetsBtnOnClick()
    log("OnClick GameSetsBtn");
    IsMoveAnimator = true;
    HallScenPanel.PlayeBtnMusic();
    local datapos = self.RecFrameBtns.transform.localPosition
    if not self.RecFrameBtns.activeSelf then
        self.RecFrameBtns:SetActive(true);
        self.GameSetsBtn.transform:Find("down").gameObject:SetActive(false)
        self.GameSetsBtn.transform:Find("up").gameObject:SetActive(true)
    else
        IsMoveAnimator = false;
        --self.RecFrameBtns.transform.localPosition = Vector3.New(1200, datapos.y, datapos.z)
        self.RecFrameBtns:SetActive(false);
        self.GameSetsBtn.transform:Find("down").gameObject:SetActive(true)
        self.GameSetsBtn.transform:Find("up").gameObject:SetActive(false)
    end
end

-- 5秒后如果没有操作自己隐藏
function GameSetsBtnInfo.CloseBts()
    if self.RecFrameBtns == nil then
        return
    end
    local datapos = self.RecFrameBtns.transform.localPosition
    if datapos.x < 600 then
        HallScenPanel.PlayeBtnMusic();
        --self.RecFrameBtns.transform.localPosition = Vector3.New(1200, datapos.y, datapos.z)
        self.RecFrameBtns:SetActive(false);
    end
end

-- 设置按钮点击事件
function GameSetsBtnInfo.SetBtnOnClick()
    --HallScenPanel.PlayeBtnMusic();
    --if PlayerPrefs.HasKey("SoundValue") then
    --    local soundVole = PlayerPrefs.GetString("SoundValue");
    --    if tonumber(soundVole) > 0 then
    --        AllSetGameInfo._6IsPlayEffect=true
    --    else
    --        AllSetGameInfo._6IsPlayEffect=false
    --    end
    --end
    --if PlayerPrefs.HasKey("MusicValue") then
    --    local musicValue = PlayerPrefs.GetString("MusicValue");
    --    if tonumber(musicValue) > 0 then
    --        AllSetGameInfo._5IsPlayAudio=true
    --    else
    --        AllSetGameInfo._5IsPlayAudio=false
    --    end
    --end
    logYellow("_5IsPlayAudio=="..tostring(AllSetGameInfo._5IsPlayAudio))
    --if AllSetGameInfo._5IsPlayAudio == false then
    --    self.BgMusicOpenBtn.isOn=false
    --    self.BgMusicCloseBtn.isOn=true
    --else
    --    self.BgMusicOpenBtn.isOn=true
    --    self.BgMusicCloseBtn.isOn=false
    --end
    logYellow("_6IsPlayEffect=="..tostring(AllSetGameInfo._6IsPlayEffect))

    --if AllSetGameInfo._6IsPlayEffect == false then
    --    self.BgSoundOpenBtn.isOn=false
    --    self.BgSoundCloseBtn.isOn=true
    --else
    --    self.BgSoundOpenBtn.isOn=true
    --    self.BgSoundCloseBtn.isOn=false
    --end
    self.musicPanel:SetActive(true);
end

function GameSetsBtnInfo.CreatSetPanel(prefab)
    local go = newobject(prefab);
    go.transform:SetParent(self.GameSetsBtnPanel.transform);
    go.name = "SetInfoPanel";
    go.layer = 5;
    go.transform.localScale = Vector3.New(1, 1, 1);
    go.transform.localPosition = Vector3.New(0, 1000, 0);
    self.SetInfoPanel = go;
    SetInfoSystem.Init(self.SetInfoPanel, self._LuaBehaviour);
    self.SetInfoPanel:SetActive(true);
    SetInfoSystem.ShowPanel(self.SetInfoPanel);
    go.transform.localPosition = Vector3.New(0, -70, 0);
    self.SetInfoPanel = nil;
    self.SetBtn:GetComponent('Button').interactable = true;
end

-- 退出游戏按钮点击事件
local is_QiutGame = true;
function GameSetsBtnInfo.ReturnBtnOnClick(...)
    IsInitgamemusic = false
    IsInitgamesound = false
    logError("GameSetsBtnInfo.ReturnBtnOnClick");
    IsMoveAnimator = false;
    if IsNil(self.ReturnBtn) == false then
        self.ReturnBtn:GetComponent('Button').interactable = false;
    end
    for i, v in ipairs({ ... }) do
        local str = tostring(v);
        if string.find(str, 'lse') ~= nil then
            is_QiutGame = str;
        else
            is_QiutGame = true;
        end
    end
    --    if IsLuaGame then
    --        NetManager:GameQuit();
    --    else
    Event.Brocast(MH.Game_LEAVE);
    --  end
    coroutine.start(self.ReturnBtnOnClick2);

end

function GameSetsBtnInfo.Ret(bl, ischang)
    IsMoveAnimator = false;
    local buffer = ByteBuffer.New();
    is_QiutGame = bl;
    if is_QiutGame == false then
        error("parameters error,not bool!");
        return
    end ;
    if is_QiutGame == true then
        Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_LEFT_GAME_REQ, buffer, gameSocketNumber.GameSocket);
    end
    HanderTime = -1;
    TishiScenes = nil;
    if IsNil(self.SetInfoPanel) == false then
        self.SetInfoPanel = nil;
    end
    if IsNil(self.HelpInfoPanel) == false then
        self.HelpInfoPanel = nil;
    end
    if IsNil(self.ExpressionPanel) == false then
        self.ExpressionPanel = nil;
    end
    if IsNil(self.ActionPanel) == false then
        self.ActionPanel = nil;
    end
    if ischang == nil then
        GameManager.ChangeScen(gameScenName.HALL);
    end
end

function GameSetsBtnInfo.ReturnBtnOnClick2()
    coroutine.wait(0.1);
    if IsNil(self.ReturnBtn) == false then
        self.ReturnBtn:GetComponent('Button').interactable = true;
    end
end


-- 帮助按钮点击事件
function GameSetsBtnInfo.HelpBtnOnClick()
    HallScenPanel.PlayeBtnMusic();
    Event.Brocast(EventIndex.OnHelp .. gameSocketNumber.GameSocket);
    self.RecFrameBtns:SetActive(false);
    ---local dotween = self.RecFrameBtns.transform:DOLocalMoveX(1000, 0.1, false)
    -- dotween:SetEase(DG.Tweening.Ease.Linear)
    -- dotween:OnComplete(function()
    --     self.RecFrameBtns:SetActive(false);
    -- end)
end

function GameSetsBtnInfo.CreatHelp(prefab)
    local go = newobject(prefab);
    go.transform:SetParent(self.GameSetsBtnPanel.transform);
    go.name = "HelpInfoPanel";
    go.layer = 5;
    go.transform.localScale = Vector3.New(1, 1, 1);
    go.transform.localPosition = Vector3.New(0, 1000, 0);
    self.HelpInfoPanel = go;
    HelpInfoSystem.Init(self.HelpInfoPanel, self._LuaBehaviour);
    local GameHelpBtnParset = self.HelpInfoPanel.transform:Find("Bg/LeftBg/LeftMainInfo").gameObject;
    for i = 0, GameHelpBtnParset.transform.childCount - 1 do
        GameHelpBtnParset.transform:GetChild(i).gameObject:SetActive(false);
    end
    local fScenSeverName = ScenSeverName;
    if string.find(fScenSeverName, gameServerName.vip) then
        fScenSeverName = string.gsub(fScenSeverName, " ", "");
    end
    if string.find(fScenSeverName, gameServerName.SFZ) then
        GameHelpBtnParset.transform:Find("shz").gameObject:SetActive(true);
        HelpInfoSystem.LeftBtnshzOnClick(GameHelpBtnParset.transform:Find("shz").gameObject);
    elseif string.find(fScenSeverName, gameServerName.DDZ) then
        GameHelpBtnParset.transform:Find("ddz").gameObject:SetActive(true);
        HelpInfoSystem.LeftBtnddzOnClick(GameHelpBtnParset.transform:Find("ddz").gameObject)
    elseif string.find(fScenSeverName, gameServerName.LKPY) then
        GameHelpBtnParset.transform:Find("lkpy").gameObject:SetActive(true);
        HelpInfoSystem.LeftBtnlkpyOnClick(GameHelpBtnParset.transform:Find("lkpy").gameObject)
    elseif string.find(fScenSeverName, gameServerName.POINTS21) then
        GameHelpBtnParset.transform:Find("d21").gameObject:SetActive(true);
        HelpInfoSystem.LeftBtnd21OnClick(GameHelpBtnParset.transform:Find("d21").gameObject)
    elseif string.find(fScenSeverName, gameServerName.Baccara) then
        GameHelpBtnParset.transform:Find("bjl").gameObject:SetActive(true);
        HelpInfoSystem.LeftBtnbjlOnClick(GameHelpBtnParset.transform:Find("bjl").gameObject)
    elseif string.find(fScenSeverName, gameServerName.Fish3D) then
        GameHelpBtnParset.transform:Find("by3d").gameObject:SetActive(true);
        HelpInfoSystem.LeftBtnby3dOnClick(GameHelpBtnParset.transform:Find("by3d").gameObject)
    elseif string.find(fScenSeverName, gameServerName.Game01) then
        GameHelpBtnParset.transform:Find("财神驾到").gameObject:SetActive(true);
        HelpInfoSystem.OnClickNewBtn(GameHelpBtnParset.transform:Find("财神驾到").gameObject)
    elseif string.find(fScenSeverName, gameServerName.Game02) then
        GameHelpBtnParset.transform:Find("龙珠探宝").gameObject:SetActive(true);
        HelpInfoSystem.OnClickNewBtn(GameHelpBtnParset.transform:Find("龙珠探宝").gameObject)
    elseif string.find(fScenSeverName, gameServerName.Game03) then
        GameHelpBtnParset.transform:Find("火拼牛牛").gameObject:SetActive(true);
        HelpInfoSystem.OnClickNewBtn(GameHelpBtnParset.transform:Find("火拼牛牛").gameObject)
    elseif string.find(fScenSeverName, gameServerName.Game04) then
        GameHelpBtnParset.transform:Find("奔驰宝马").gameObject:SetActive(true);
        HelpInfoSystem.OnClickNewBtn(GameHelpBtnParset.transform:Find("奔驰宝马").gameObject)
    elseif string.find(fScenSeverName, gameServerName.Game06) then
        GameHelpBtnParset.transform:Find("诈金花").gameObject:SetActive(true);
        HelpInfoSystem.OnClickNewBtn(GameHelpBtnParset.transform:Find("诈金花").gameObject)
    end
    HelpInfoSystem.ShowPanel(self.HelpInfoPanel);
    go.transform.localPosition = Vector3.New(0, -70, 0);
    go = nil;
    self.HelpInfoPanel = nil;
    self.HelpBtn:GetComponent('Button').interactable = true;
end

function GameSetsBtnInfo.Update()
    if LaunchModule.IsILRuntime then
        return;
    end
    if HallScenPanel.connectGameSuccess then
        HallScenPanel.rqgameHeartTimer = HallScenPanel.rqgameHeartTimer - Time.deltaTime;
        if HallScenPanel.rqgameHeartTimer <= 0 then
            log("发送心跳")
            HallScenPanel.rqgameHeartTimer = HallScenPanel.connectgameMaxTimer;
            local buffer = ByteBuffer.New();
            HallScenPanel.connectgameTimer = HallScenPanel.connectgameMaxTimer;
            HallScenPanel.heartBack = false;
            Network.Send(MH.MDM_3D_FRAME, MH.SUB_3D_CS_GAME_HEART, buffer, gameSocketNumber.GameSocket);
        end
    end
    HallScenPanel.CheckGameSocketConnect();
end

function GameSetsBtnInfo.SetMoveAnimator()

end
self.wait = nil;
function GameSetsBtnInfo.InitConnectWait(isshow)
    if transform == nil then
        return ;
    end
    
    if isshow then
        if self.wait == nil then
            self.wait = newobject(HallScenPanel.waitTransform.gameObject);
            self.wait.transform:SetParent(transform);
            self.wait.transform.localPosition = Vector3.New(0, 0, 0);
            self.wait.transform.localScale = Vector3.New(1, 1, 1);
            self.wait.transform:Find("Text"):GetComponent("Text").text = "网络连接中…";
        end
        self.wait.gameObject:SetActive(true);
    else
        if self.wait ~= nil then
            destroy(self.wait.gameObject);
            self.wait = nil;
        end
    end
end
-- lua游戏退出游戏
function GameSetsBtnInfo.LuaGameQuit(callBack)
    logError("退出游戏")
    GameNextScenName = "";
    ILRuntimeManager:LeaveGame();
    --IsMoveAnimator = false;
    --self.wait = nil;
    --if not (IsLuaGame) then
    --    MusicManager:PlayBacksound("end", false);
    --end
    ---- 取消系统通告显示
    --NotifyInfoTextObj = nil;
    ---- 取消玩家通告显示
    --PlayerNotifyInfoTextObj = nil;
    --ReturnHallNum = 0;
    --ReturnLoginNum = 0;
    --if Network.State(gameSocketNumber.GameSocket) then
    --    local bf = ByteBuffer.New();
    --    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_LEFT_GAME_REQ, bf, gameSocketNumber.GameSocket);
    --end
    --
    --TishiScenes = nil;
    --gameIsNotice = false;
    MessgeEventRegister.Game_Messge_Un();
    --GameManager.ChangeScen(gameScenName.HALL);
    --
    ---- 回掉到游戏
    --if callBack ~= nil then
    --    callBack()
    --end
    --
    --LaunchModule.Quit();
    --
    --ScenSeverName = gameServerName.HALL
    ----if not Network.State(gameSocketNumber.HallSocket) then
    ----    logError("退出游戏时检测到大厅断线!尝试重新连接...");
    ----    coroutine.start(
    ----            function()
    ----                coroutine.wait(2);
    ----                LogonScenPanel.ConnectHallServer(LogonScenPanel.SendLoginMasseg)
    ----            end
    ----    );
    ----else
    ----    log("退出游戏时检测到大厅连接正常");
    ----end
end

