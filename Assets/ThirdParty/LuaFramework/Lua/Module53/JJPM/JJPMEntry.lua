-- Game01Panel.lua
-- Date
-- slot场景控制 对应LuaBehaviour
-- endregion
local g_swlzbNum = "Module53/JJPM/";

require(g_swlzbNum .. "JJPM_Network")
require(g_swlzbNum .. "JJPM_Roll")
require(g_swlzbNum .. "JJPM_DataConfig")
require(g_swlzbNum .. "JJPM_Rule")
require(g_swlzbNum .. "JJPM_Audio")

JJPMEntry = {};
local self = JJPMEntry;
self.transform = nil;
self.gameObject = nil;
self.luaBehaviour = nil;

self.currentBet = 0;
self.currentBetIndex = 0;
self.currentBetArea = 0;

self.startTime = false;
self.RemainTime = 0;

self.isAuto = false;
self.ChipAreaList = {};
self.totalChip = 0;
self.lastChip = 0;
self.totalWin = 0;
self.ChairID = 0;
self.hasResult = false;

self.SceneData = {
    nBetCount = 0, --下注筹码个数
    nBetList = {}, --下注筹码
    tagBetMsg = {}, --已下注信息
    tagMyBetMsg = {}, --自己下注信息
    cbWinMsg = {}, -- 历史开奖记录
    cbRoomState = 0, --当前状态,1:开始,5：结算
    nTime = 0, --剩余时间
};
self.ResultData = {
    cbIndex = 0, --中奖下标
    IsFrist = 0,
    lWinScore = {}, --中奖分数
}
self.UserList = {};

function JJPMEntry:Awake(obj)
    Screen.orientation = UnityEngine.ScreenOrientation.Landscape;
    Screen.autorotateToLandscapeLeft = true;
    Screen.autorotateToLandscapeRight = true;
    Screen.autorotateToPortrait = false;
    Screen.autorotateToPortraitUpsideDown = false;
    self.transform = obj.transform;
    self.gameObject = obj.gameObject;
    self.luaBehaviour = self.transform:GetComponent("LuaBehaviour");
    for i = 1, JJPM_DataConfig.GAME_PLAYER do
        table.insert(self.UserList, nil);
    end
    JJPM_Network.AddMessage();
    self.hasResult = false;

end
function JJPMEntry.Start()
    self.FindComponent();
    self.AddListener();
    JJPM_Roll.Init();
    JJPM_Audio.Init()
    JJPM_Network.LoginGame();
    JJPM_Audio.PlayBGM();
end
function JJPMEntry.ToCharArray(num)
    --拆解字符串
    local str = tostring(num);
    local list1 = {}
    for i = 1, string.len(str) do
        table.insert(list1, #list1 + 1, string.sub(str, i, i));
    end
    return list1;
end
function JJPMEntry.FormatNumberThousands(num)
    --对数字做千分位操作
    local function checknumber(value)
        return tonumber(value) or 0
    end
    local formatted = tostring(checknumber(num))
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        print(formatted, k)
        if k == 0 then
            break
        end

    end
    return formatted
end
function JJPMEntry.ShowText(str)
    str = ShortNumber(str);
    --展示tmp字体
    local arr = self.ToCharArray(str);
    local _str = "";
    for i = 1, #arr do
        _str = _str .. string.format("<sprite name=\"%s\">", arr[i]);
    end
    return _str;
end
function JJPMEntry.ShowChipText(bet)
    local _bet = tonumber(bet);
    if _bet / 100000000 >= 1 then
        if _bet % 100000000 > 0 then
            return string.format("%s亿%s万", math.floor(_bet / 100000000), math.floor((_bet % 100000000) / 10000));
        else
            return string.format("%s亿", math.floor(_bet / 100000000));
        end
    else
        if _bet / 10000 >= 1 then
            if _bet % 10000 > 0 then
                return string.format("%s万%s千", math.floor(_bet / 10000), math.floor((_bet % 10000) / 1000))
            else
                return string.format("%s万", math.floor(_bet / 10000))
            end
        else
            if _bet / 1000 >= 1 then
                if _bet % 1000 > 0 then
                    return string.format("%s千%s", math.floor(_bet / 1000), math.floor(_bet % 1000));
                else
                    return string.format("%s千", math.floor(_bet / 1000));
                end
            else
                return string.format("%s", _bet);
            end
        end
    end
end
function JJPMEntry.FindComponent()
    self.mainPanel = self.transform:Find("MainPanel");
    self.runPanel = self.transform:Find("RunPanel");

    self.betGroup = self.mainPanel:Find("Content/BetGroup");

    self.chipGroup = self.betGroup:Find("ChipGroup");
    for i = 1, self.chipGroup.childCount do
        self.chipGroup:GetChild(i - 1):Find("Select").gameObject:SetActive(false);
        self.chipGroup:GetChild(i - 1):Find("SelfChip").gameObject:SetActive(false);
        self.chipGroup:GetChild(i - 1):Find("SelfChip/Num"):GetComponent("TextMeshProUGUI").text = "";
    end
    local bot = self.betGroup:Find("Bottom");
    local rate = Screen.width / Screen.height;
    bot.localScale = Vector3.New(rate / 1.5, rate / 1.5, rate / 1.5);
    self.head = self.betGroup:Find("Bottom/Head"):GetComponent("Image");
    self.nickName = self.betGroup:Find("Bottom/NickName"):GetComponent("Text");
    self.betlist = self.betGroup:Find("Bottom/BetList");
    self.selfgold = self.betGroup:Find("Bottom/Gold/Num"):GetComponent("TextMeshProUGUI");
    self.autoBtn = self.betGroup:Find("Bottom/Auto"):GetComponent("Toggle");
    self.clearChipBtn = self.betGroup:Find("Bottom/ClearChip"):GetComponent("Button");

    local right = self.betGroup:Find("Right");
    right.localPosition = Vector3.New(right.localPosition.x, right.localPosition.y + 100 * (rate - 1.5), right.localPosition.z);
    self.remainStartTime = self.betGroup:Find("Right/RemainStart/TimeNum"):GetComponent("TextMeshProUGUI");
    self.selfTotalChipNum = self.betGroup:Find("Right/SelfChip/Num"):GetComponent("TextMeshProUGUI");
    self.selfWinNum = self.betGroup:Find("Right/Win/Num"):GetComponent("TextMeshProUGUI");

    self.winCombList = self.betGroup:Find("Right/Background/Comb"):GetComponent("ScrollRect");
    local btngroup = right:Find("BtnGroup");
    self.SetBtn = btngroup:Find("SetBtn"):GetComponent("Button");
    self.HelpBtn = btngroup:Find("HelpBtn"):GetComponent("Button");
    self.RecordBtn = btngroup:Find("RecordBtn"):GetComponent("Button");

    self.settingPanel = self.mainPanel:Find("Content/SettingPanel");
    self.rulePanel = self.mainPanel:Find("Content/RulePanel");
    self.lastRecordPanel = self.mainPanel:Find("Content/LastRecordPanel");
    self.currentRecordPanel = self.mainPanel:Find("Content/CurrentRecordPanel");

    self.stateEffect = self.betGroup:Find("Result");
    self.PlayingEffect = self.stateEffect:Find("Playing").gameObject;
    self.stopChipEffect = self.stateEffect:Find("StopChip").gameObject;
    self.ReconnectEffect = self.stateEffect:Find("Reconnect").gameObject;
    self.ConnectingEffect = self.stateEffect:Find("Connecting").gameObject;
    self.ConnectingEffect:SetActive(true);

    self.resultEffect = self.mainPanel:Find("Content/Result");

    self.quitPanel = self.mainPanel:Find("Content/QuitPanel");
    self.soundList = self.mainPanel:Find("Content/SoundList");
    self.icons = self.mainPanel:Find("Content/Icons");

    self.backgameBtn = self.mainPanel:Find("Content/Back"):GetComponent("Button");
    self.backgameBtn1 = self.betGroup:Find("Back"):GetComponent("Button");
    local rate = Screen.width / Screen.height;
    if rate > 1.8 then
        self.backgameBtn1.transform.localPosition = Vector3.New(-rate * 640 / 2 + 10, 325, 0);
    else
        self.backgameBtn1.transform.localPosition = Vector3.New(-rate * 640 / 2 + 10, 200.5, 0);
    end
    self.leaderGroup = self.mainPanel:Find("Content/Leader");

end
function JJPMEntry.AddListener()
    self.backgameBtn.onClick:RemoveAllListeners();
    self.backgameBtn.onClick:AddListener(self.ShowQuit);
    self.backgameBtn1.onClick:RemoveAllListeners();
    self.backgameBtn1.onClick:AddListener(self.ShowQuit);

    self.SetBtn.onClick:RemoveAllListeners();
    self.SetBtn.onClick:AddListener(self.ShowSettingPanel);
    self.HelpBtn.onClick:RemoveAllListeners();
    self.HelpBtn.onClick:AddListener(self.ShowRulePanel);
    self.RecordBtn.onClick:RemoveAllListeners();
    self.RecordBtn.onClick:AddListener(self.ShowLastRecordPanel);

    self.clearChipBtn.onClick:RemoveAllListeners();
    self.clearChipBtn.onClick:AddListener(self.ClearChipCall);
    self.autoBtn.onValueChanged:RemoveAllListeners();
    self.autoBtn.onValueChanged:AddListener(self.ChipAgainCall);
end
--退出
function JJPMEntry.ShowQuit()
    local cancelbtn = self.quitPanel:Find("Content/CancelBtn"):GetComponent("Button");
    local quitbtn = self.quitPanel:Find("Content/QuitBtn"):GetComponent("Button");
    cancelbtn.onClick:RemoveAllListeners();
    cancelbtn.onClick:AddListener(function()
        self.quitPanel.gameObject:SetActive(false);
    end);
    quitbtn.onClick:RemoveAllListeners();
    quitbtn.onClick:AddListener(function()
        Event.Brocast(MH.Game_LEAVE);
    end);
    self.quitPanel.gameObject:SetActive(true);
end
function JJPMEntry.ShowSettingPanel()
    JJPM_Audio.PlaySound(JJPM_Audio.SoundList.BTN);
    self.settingPanel.gameObject:SetActive(true);
    local close = self.settingPanel:Find("Content/Close"):GetComponent("Button");
    close.onClick:RemoveAllListeners();
    close.onClick:AddListener(function()
        self.settingPanel.gameObject:SetActive(false);
    end);
    local musicprogress = self.settingPanel:Find("Content/Music"):GetComponent("Slider");
    local soundprogress = self.settingPanel:Find("Content/Sound"):GetComponent("Slider");
    --if not PlayerPrefs.HasKey("MusicValue") then
    --    PlayerPrefs.SetString("MusicValue", "1");
    --end
    --if not PlayerPrefs.HasKey("SoundValue") then
    --    PlayerPrefs.SetString("SoundValue", "1");
    --end
    --local musicvalue = tonumber(PlayerPrefs.GetString("MusicValue"));
    --local soundvalue = tonumber(PlayerPrefs.GetString("SoundValue"));
    --if AllSetGameInfo._5IsPlayAudio then
    --    musicprogress.value = musicvalue;
    --else
    --    musicprogress.value = 0;
    --end
    musicprogress.value = MusicManager:GetMusicVolume();
    soundprogress.value = MusicManager:GetSoundVolume();
    --if AllSetGameInfo._6IsPlayEffect then
    --    soundprogress.value = soundvalue;
    --else
    --    soundprogress.value = 0;
    --end
    self.luaBehaviour:AddSliderEvent(musicprogress.gameObject, function(value)
        MusicManager:SetValue(MusicManager:GetSoundVolume(), tonumber(value));
        JJPM_Audio.pool.volume = value;
        MusicManager:SetMusicMute(value <= 0);
        JJPM_Audio.pool.mute = not MusicManager:GetIsPlayMV();
        --GameManager.SetIsPlayMute(AllSetGameInfo._6IsPlayEffect, AllSetGameInfo._5IsPlayAudio);
    end);
    self.luaBehaviour:AddSliderEvent(soundprogress.gameObject, function(value)
        MusicManager:SetValue(tonumber(value),MusicManager:GetMusicVolume());
        MusicManager:SetSoundMute(value <= 0);
        for i = 1, JJPM_Audio.pool.transform.childCount do
            JJPM_Audio.pool.transform:GetChild(i - 1):GetComponent("AudioSource").volume = value;
        end
    end);
end
function JJPMEntry.ShowRulePanel()
    --显示规则
    JJPM_Audio.PlaySound(JJPM_Audio.SoundList.BTN);
    JJPM_Rule.ShowRule();
end
function JJPMEntry.ShowCurrentRecordPanel()
    --上一把的结果和排名
    JJPM_Audio.PlaySound(JJPM_Audio.SoundList.BTN);
    if self.hasResult then
        local frist = self.currentRecordPanel:Find("Content/Frist/Horse"):GetComponent("Image");
        local second = self.currentRecordPanel:Find("Content/Second/Horse"):GetComponent("Image");
        frist.sprite = self.icons:Find("Horse" .. JJPM_Roll.horseList[1]):GetComponent("Image").sprite;
        second.sprite = self.icons:Find("Horse" .. JJPM_Roll.horseList[2]):GetComponent("Image").sprite;
        local plv = self.currentRecordPanel:Find("Content/PeiLv"):GetComponent("TextMeshProUGUI");
        plv.text = "X" .. JJPM_DataConfig.peiLvList[self.ResultData.cbIndex + 1];
        local totalchip = self.currentRecordPanel:Find("Content/TotalChip"):GetComponent("TextMeshProUGUI");
        local totalwin = self.currentRecordPanel:Find("Content/TotalWin"):GetComponent("TextMeshProUGUI");
        local closeBtn = self.currentRecordPanel:Find("Content/Close"):GetComponent("Button");
        local winlist = self.currentRecordPanel:Find("Content/WinList"):GetComponent("ScrollRect");
        totalchip.text = tostring(self.lastChip);
        totalwin.text = tostring(self.totalWin);
        closeBtn.onClick:RemoveAllListeners();
        closeBtn.onClick:AddListener(function()
            self.currentRecordPanel.gameObject:SetActive(false);
        end);
        local recordList = {};
        for i = 1, #self.ResultData.lWinScore do
            local score = self.ResultData.lWinScore[i];
            if self.ResultData.lWinScore[i] > 0 then
                local data = { ChairID = i,
                               Gold = score };
                table.insert(recordList, data);
            end
        end
        table.sort(recordList, function(a, b)
            if a.Gold > b.Gold then
                return true;
            else
                return false;
            end
        end);
        for i = 1, winlist.content.childCount do
            winlist.content:GetChild(i - 1).gameObject:SetActive(false);
        end
        logTable(recordList);
        logTable(self.UserList);
        for i = 1, #recordList do
            local child = nil;
            if i >= winlist.content.childCount then
                child = newObject(winlist.content:GetChild(0).gameObject);
                child.transform:SetParent(winlist.content);
                child.transform.localPosition = Vector3.New(0, 0, 0);
                child.transform.localScale = Vector3.New(1, 1, 1);
            else
                child = winlist.content:GetChild(i - 1).gameObject;
            end
            local _frist = child.transform:Find("Frist").gameObject;
            local _second = child.transform:Find("Second").gameObject;
            local _third = child.transform:Find("Third").gameObject;
            local userhead = child.transform:Find("HeadMask/Head"):GetComponent("Image");
            local nickName = child.transform:Find("NickName"):GetComponent("Text");
            local winNum = child.transform:Find("WinNum"):GetComponent("TextMeshProUGUI");
            winNum.text = self.ShowText("+" .. recordList[i].Gold);
            nickName.text = self.UserList[recordList[i].ChairID]._2szNickName;
            if self.UserList[recordList[i].ChairID]._1dwUser_Id == SCPlayerInfo._01dwUser_Id then
                userhead.sprite = HallScenPanel.GetHeadIcon();
            else
                local ran = math.random(1, 10);
                userhead.sprite = HallScenPanel.headIcons.transform:GetChild(ran - 1):GetComponent("Image").sprite;
            end
            if i == 1 then
                _frist:SetActive(true);
                _second:SetActive(false);
                _third:SetActive(false);
            elseif i == 2 then
                _frist:SetActive(false);
                _second:SetActive(true);
                _third:SetActive(false);
            elseif i == 3 then
                _frist:SetActive(false);
                _second:SetActive(false);
                _third:SetActive(true);
            else
                _frist:SetActive(false);
                _second:SetActive(false);
                _third:SetActive(false);
            end
            child.gameObject:SetActive(true);
        end
        self.currentRecordPanel.gameObject:SetActive(true);
    else
        MessageBox.CreatGeneralTipsPanel("你目前没有上轮数据");
    end
end
function JJPMEntry.ShowLastRecordPanel()
    --上一把的结果和排名
    JJPM_Audio.PlaySound(JJPM_Audio.SoundList.BTN);
    if self.hasResult then
        local frist = self.lastRecordPanel:Find("Content/Frist/Horse"):GetComponent("Image");
        local second = self.lastRecordPanel:Find("Content/Second/Horse"):GetComponent("Image");
        frist.sprite = self.icons:Find("Horse" .. JJPM_Roll.horseList[1]):GetComponent("Image").sprite;
        second.sprite = self.icons:Find("Horse" .. JJPM_Roll.horseList[2]):GetComponent("Image").sprite;
        local plv = self.lastRecordPanel:Find("Content/PeiLv"):GetComponent("TextMeshProUGUI");
        plv.text = "X" .. JJPM_DataConfig.peiLvList[self.ResultData.cbIndex + 1];
        local totalchip = self.lastRecordPanel:Find("Content/TotalChip"):GetComponent("TextMeshProUGUI");
        local totalwin = self.lastRecordPanel:Find("Content/TotalWin"):GetComponent("TextMeshProUGUI");
        local closeBtn = self.lastRecordPanel:Find("Content/Close"):GetComponent("Button");
        local winlist = self.lastRecordPanel:Find("Content/WinList"):GetComponent("ScrollRect");
        totalchip.text = tostring(self.lastChip);
        totalwin.text = tostring(self.totalWin);
        closeBtn.onClick:RemoveAllListeners();
        closeBtn.onClick:AddListener(function()
            self.lastRecordPanel.gameObject:SetActive(false);
        end);
        local recordList = {};
        for i = 1, #self.ResultData.lWinScore do
            local score = self.ResultData.lWinScore[i];
            if self.ResultData.lWinScore[i] > 0 then
                local data = { ChairID = i,
                               Gold = score };
                table.insert(recordList, data);
            end
        end
        table.sort(recordList, function(a, b)
            if a.Gold > b.Gold then
                return true;
            else
                return false;
            end
        end);
        for i = 1, winlist.content.childCount do
            winlist.content:GetChild(i - 1).gameObject:SetActive(false);
        end
        logTable(recordList);
        logTable(self.UserList);
        for i = 1, #recordList do
            local child = nil;
            if i >= winlist.content.childCount then
                child = newObject(winlist.content:GetChild(0).gameObject);
                child.transform:SetParent(winlist.content);
                child.transform.localPosition = Vector3.New(0, 0, 0);
                child.transform.localScale = Vector3.New(1, 1, 1);
            else
                child = winlist.content:GetChild(i - 1).gameObject;
            end
            local _frist = child.transform:Find("Frist").gameObject;
            local _second = child.transform:Find("Second").gameObject;
            local _third = child.transform:Find("Third").gameObject;
            local userhead = child.transform:Find("HeadMask/Head"):GetComponent("Image");
            local nickName = child.transform:Find("NickName"):GetComponent("Text");
            local winNum = child.transform:Find("WinNum"):GetComponent("TextMeshProUGUI");
            winNum.text = self.ShowText("+" .. recordList[i].Gold);
            nickName.text = self.UserList[recordList[i].ChairID]._2szNickName;
            if self.UserList[recordList[i].ChairID]._1dwUser_Id == SCPlayerInfo._01dwUser_Id then
                userhead.sprite = HallScenPanel.GetHeadIcon();
            else
                local ran = math.random(1, 10);
                userhead.sprite = HallScenPanel.headIcons.transform:GetChild(ran - 1):GetComponent("Image").sprite;
            end
            if i == 1 then
                _frist:SetActive(true);
                _second:SetActive(false);
                _third:SetActive(false);
            elseif i == 2 then
                _frist:SetActive(false);
                _second:SetActive(true);
                _third:SetActive(false);
            elseif i == 3 then
                _frist:SetActive(false);
                _second:SetActive(false);
                _third:SetActive(true);
            else
                _frist:SetActive(false);
                _second:SetActive(false);
                _third:SetActive(false);
            end
            child.gameObject:SetActive(true);
        end
        self.lastRecordPanel.gameObject:SetActive(true);
    else
        MessageBox.CreatGeneralTipsPanel("你目前没有上轮数据");
    end
end
--玩家下注
function JJPMEntry.PlayChip(data)
    local index = data.cbIndex;
    local item = self.chipGroup:GetChild(index);
    if data.chairId == self.ChairID then
        --自己的下注信息
        logTable(self.ChipAreaList);
        self.totalChip = 0;
        for i = 1, #self.ChipAreaList do
            if i == index + 1 then
                self.ChipAreaList[i] = self.ChipAreaList[i] + data.nBetScore;
            end
            self.totalChip = self.totalChip + self.ChipAreaList[i];
        end
        item:Find("Select").gameObject:SetActive(true);
        item:Find("SelfChip").gameObject:SetActive(true);
        item:Find("SelfChip/Num"):GetComponent("TextMeshProUGUI").text = self.ShowText(self.ChipAreaList[index + 1]);
        self.selfTotalChipNum.text = tostring(self.totalChip);
        self.clearChipBtn.interactable = true;
        self.autoBtn.interactable = true;
    else
        --其他人的下注信息
        local hud = item:Find("HUD");
        local child = nil;
        for i = 1, hud.childCount do
            if not hud:GetChild(i - 1).gameObject.activeSelf then
                child = hud:GetChild(i - 1);
                break ;
            end
        end
        if child == nil then
            child = newObject(hud:GetChild(0).gameObject).transform;
            child.transform:SetParent(hud);
        end
        child.transform.localScale = Vector3.New(1, 1, 1);
        child.transform.localPosition = Vector3.New(0, 0, 0);
        child.transform:GetComponent("TextMeshProUGUI").text = "+" .. data.nBetScore;
        child.gameObject:SetActive(true);
        child.transform:DOLocalMove(Vector3.New(0, 30, 0), 0.8):SetEase(DG.Tweening.Ease.Linear);
        local color = child.transform:GetComponent("TextMeshProUGUI").color;
        Util.RunWinScore(1, 0, 0.5, function(value)
            child.transform:GetComponent("TextMeshProUGUI").color = Color.New(color.r, color.g, color.b, value);
        end):SetDelay(0.8):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            child.gameObject:SetActive(false);
            child.transform:GetComponent("TextMeshProUGUI").color = Color.New(color.r, color.g, color.b, 1);
        end);
    end
end
function JJPMEntry.Update()
    JJPM_Roll.Update();
    if self.startTime then
        --剩余时间计时
        self.RemainTime = self.RemainTime - Time.deltaTime;
        if self.RemainTime <= 0 then
            self.RemainTime = 0;
            self.remainStartTime.text = "00:00";
            self.startTime = false;
            self.stopChipEffect.gameObject:SetActive(true);
            return ;
        end
        self.remainStartTime.text = string.format("%02d:%02d", Mathf.Floor(self.RemainTime / 60), Mathf.Ceil(self.RemainTime % 60));
    end
end
function JJPMEntry.OnDestroy()
    JJPM_Network.UnMessage()
    self.transform = nil;
    self.gameObject = nil;
end
function JJPMEntry.InitPanel()
    self.ConnectingEffect:SetActive(false);
    JJPMEntry.nickName.text = SCPlayerInfo._05wNickName;
    JJPMEntry.selfgold.text = tostring(self.myGold);
    self.head.sprite = HallScenPanel.GetHeadIcon();
    self.RemainTime = self.SceneData.nTime;
    self.stopChipEffect:SetActive(false);
    self.ConnectingEffect:SetActive(false);
    self.ReconnectEffect:SetActive(false);
    if self.SceneData.cbRoomState == 1 then
        self.PlayingEffect:SetActive(false);
        self.remainStartTime.text = string.format("%02d:%02d", Mathf.Floor(self.RemainTime / 60), Mathf.Ceil(self.RemainTime % 60));
        self.startTime = true;
    else
        self.remainStartTime.text = "00:00";
        self.PlayingEffect:SetActive(true);
    end
    for i = 1, JJPMEntry.SceneData.nBetCount do
        local icon = self.betlist:GetChild(i - 1):Find("Icon");
        icon:Find("Num"):GetComponent("TextMeshProUGUI").text = self.ShowChipText(JJPMEntry.SceneData.nBetList[i]);
        icon.parent.gameObject.name = tostring(JJPMEntry.SceneData.nBetList[i]);
        if i == 1 then
            icon.transform.localPosition = Vector3.New(0, 20, 0);
            self.currentBet = JJPMEntry.SceneData.nBetList[i];
            self.currentBetIndex = i;
        else
            icon.transform.localPosition = Vector3.New(0, 0, 0);
        end
        local toggle = self.betlist:GetChild(i - 1):GetComponent("Toggle");
        toggle.isOn = i == 1;
        toggle.onValueChanged:RemoveAllListeners();
        toggle.onValueChanged:AddListener(function(isOn)
            if isOn then
                icon.localPosition = Vector3.New(0, 20, 0);
                self.currentBet = JJPMEntry.SceneData.nBetList[i];
                self.currentBetIndex = i;
            else
                icon.localPosition = Vector3.New(0, 0, 0);
            end
        end);
    end
    self.clearChipBtn.interactable = false;
    self.autoBtn.interactable = false;
    for i = 1, #self.SceneData.tagMyBetMsg do
        local index = self.SceneData.tagMyBetMsg[i].cbIndex;
        if self.SceneData.tagMyBetMsg[i].nGold > 0 then
            self.chipGroup:GetChild(index):Find("Select").gameObject:SetActive(true);
            self.chipGroup:GetChild(index):Find("SelfChip").gameObject:SetActive(true);
            self.chipGroup:GetChild(index):Find("SelfChip/Num"):GetComponent("TextMeshProUGUI").text = self.ShowText(self.SceneData.tagMyBetMsg[i].nGold);
        else
            self.chipGroup:GetChild(index):Find("Select").gameObject:SetActive(false);
            self.chipGroup:GetChild(index):Find("SelfChip").gameObject:SetActive(false);
            self.chipGroup:GetChild(index):Find("SelfChip/Num"):GetComponent("TextMeshProUGUI").text = "";
        end
        local btn = self.chipGroup:GetChild(index):GetComponent("Button");
        btn.onClick:RemoveAllListeners();
        btn.onClick:AddListener(function()
            self.currentBetArea = index;
            JJPM_Audio.PlaySound(JJPM_Audio.SoundList.Coin);
            JJPM_Network.Chip();
        end);
    end
end
function JJPMEntry.ClearChipCall()
    JJPM_Network.ClearChip();
end
function JJPMEntry.ClearChip()
    for i = 1, JJPM_DataConfig.AREA_COUNT do
        JJPMEntry.ChipAreaList[i] = 0;
        self.chipGroup:GetChild(self.SceneData.tagMyBetMsg[i].cbIndex):Find("Select").gameObject:SetActive(false);
        self.chipGroup:GetChild(self.SceneData.tagMyBetMsg[i].cbIndex):Find("SelfChip").gameObject:SetActive(false);
        self.chipGroup:GetChild(self.SceneData.tagMyBetMsg[i].cbIndex):Find("SelfChip/Num"):GetComponent("TextMeshProUGUI").text = "";
    end
    self.totalChip = 0;
    self.clearChipBtn.interactable = false;
    self.autoBtn.interactable = false;
    self.autoBtn.isOn = false;
end
function JJPMEntry.StartChipState()
    JJPM_Roll.Comb.text = "";
    JJPM_Roll.peilv.text = "";
    self.currentRecordPanel.gameObject:SetActive(false);
    self.betGroup:DOLocalMove(Vector3.New(0, 0, 0), 1):SetEase(DG.Tweening.Ease.Linear);
    self.selfgold.text = tostring(self.myGold);
    JJPM_Audio.ClearAuido(JJPM_Audio.SoundList.Jia);
    for i = 1, #self.ResultData.lWinScore do
        if i - 1 == JJPMEntry.ChairID then
            JJPMEntry.selfWinNum.text = self.ResultData.lWinScore[i];
            break ;
        end
    end
    if self.betGroup.localPosition.y > 0 then
        JJPM_Audio.PlayBGM();
    end
    JJPMEntry.RemainTime = 27;
    JJPMEntry.startTime = true;
    self.PlayingEffect:SetActive(false);
    self.stopChipEffect:SetActive(false);
    self.ConnectingEffect:SetActive(false);
    self.ReconnectEffect:SetActive(false);
    self.lastChip = self.totalChip;
    if not self.isAuto then
        self.ClearChip();
    else
        JJPM_Network.ChipAgain();
    end
    self.ShowCombRecordLv();
end
function JJPMEntry.ShowChipAgain()
    for i = 1, JJPM_DataConfig.AREA_COUNT do
        if self.ChipAreaList[i] > 0 then
            self.chipGroup:GetChild(self.SceneData.tagMyBetMsg[i].cbIndex):Find("Select").gameObject:SetActive(true);
            self.chipGroup:GetChild(self.SceneData.tagMyBetMsg[i].cbIndex):Find("SelfChip").gameObject:SetActive(true);
            self.chipGroup:GetChild(self.SceneData.tagMyBetMsg[i].cbIndex):Find("SelfChip/Num"):GetComponent("TextMeshProUGUI").text = self.ShowText(self.ChipAreaList[i]);
        else
            self.chipGroup:GetChild(self.SceneData.tagMyBetMsg[i].cbIndex):Find("Select").gameObject:SetActive(false);
            self.chipGroup:GetChild(self.SceneData.tagMyBetMsg[i].cbIndex):Find("SelfChip").gameObject:SetActive(false);
            self.chipGroup:GetChild(self.SceneData.tagMyBetMsg[i].cbIndex):Find("SelfChip/Num"):GetComponent("TextMeshProUGUI").text = "";
        end
    end
    self.selfTotalChipNum.text = tostring(self.totalChip);
end
function JJPMEntry.ShowCombRecordLv()
    if self.hasResult then
        local child = nil;
        local comb = JJPM_DataConfig.WinList[self.ResultData.cbIndex + 1];
        local peilv = JJPM_DataConfig.peiLvList[self.ResultData.cbIndex + 1];
        if self.winCombList.content.childCount < 8 then
            child = newObject(self.winCombList.content:GetChild(0).gameObject);
            child.transform:SetParent(self.winCombList.content);
            child.transform.localScale = Vector3.New(1, 1, 1);
            child.transform.localPosition = Vector3.New(0, 0, 0);
        else
            child = self.winCombList.content:GetChild(1).gameObject;
            child.transform:SetAsLastSibling();
        end
        local combstr = child.transform:Find("Comb"):GetComponent("TextMeshProUGUI");
        local peilvstr = child.transform:Find("PeiLv"):GetComponent("TextMeshProUGUI");
        combstr.text = comb[1] .. "-" .. comb[2];
        peilvstr.text = "X" .. peilv;
        child.gameObject:SetActive(true);
    end
end
function JJPMEntry.ChipAgainCall(value)
    log("是否挂机：" .. tostring(value));
    self.isAuto = value;
end