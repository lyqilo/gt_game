local g_sWSZSModuleNum = "Module06/OneWPBY/";

require(g_sWSZSModuleNum .. "OneWPBY_Network")
require(g_sWSZSModuleNum .. "OneWPBY_Struct")
require(g_sWSZSModuleNum .. "OneWPBY_DataConfig")
require(g_sWSZSModuleNum .. "OneWPBY_Rule")
require(g_sWSZSModuleNum .. "OneWPBY_Audio")
require(g_sWSZSModuleNum .. "OneWPBY_Bullet")
require(g_sWSZSModuleNum .. "OneWPBY_BulletController")
require(g_sWSZSModuleNum .. "OneWPBY_Fish")
require(g_sWSZSModuleNum .. "OneWPBY_FishController")
require(g_sWSZSModuleNum .. "OneWPBY_Net")
require(g_sWSZSModuleNum .. "OneWPBY_NetController")
require(g_sWSZSModuleNum .. "OneWPBY_Player")
require(g_sWSZSModuleNum .. "OneWPBY_PlayerController")
require(g_sWSZSModuleNum .. "OneWPBY_GoldEffect")

OneWPBYEntry = {};
local self = OneWPBYEntry;

self.transform = nil;
self.gameObject = nil;

self.backgroundPanel = nil;
self.fishPanel = nil;
self.uiPanel = nil;
self.ChairID = nil;
self.UserList = {};
self.ConfigData = {};
self.myGold = 0;
self.viewportRect = Vector4.New(0, 0, 0, 0);
self.isYc = false;

function OneWPBYEntry:Awake(obj)
    Screen.orientation = UnityEngine.ScreenOrientation.Landscape;
    Screen.autorotateToLandscapeLeft = true;
    Screen.autorotateToLandscapeRight = true;
    Screen.autorotateToPortrait = false;
    Screen.autorotateToPortraitUpsideDown = false;
    self.gameObject = obj.gameObject;
    self.transform = self.gameObject.transform;
    self.isRevert = false;
    self.FindComponent();
    self.AddListener();
    OneWPBY_FishController.Init();
    OneWPBY_BulletController.Init();
    OneWPBY_PlayerController.Init();
    OneWPBY_Audio.Init();
    OneWPBY_Rule.Init();
    OneWPBY_GoldEffect.Init(self.EffectPool);
    OneWPBY_Network.AddMessage();
    OneWPBY_Network.LoginGame();
    OneWPBY_Audio.PlayBGM(OneWPBY_Audio.SoundList.BGM);
end
function OneWPBYEntry.DelayCall(timer, callback)
    local tweener = Util.RunWinScore(0, 1, timer, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        if callback ~= nil then
            callback();
        end
    end);
    return tweener;
end
function OneWPBYEntry:Update()
end
function OneWPBYEntry.OnDestroy()
    OneWPBY_FishController.ClearFish();
end
function OneWPBYEntry.FindComponent()
    self.luaBehaviour = self.transform:GetComponent("LuaBehaviour");
    self.backgroundPanel = self.transform:Find("BackgroundPanel");
    self.fishPanel = self.transform:Find("FishPanel");
    self.uiPanel = self.transform:Find("UIPanel");
    self.transform:Find("EventSystem").gameObject:SetActive(false);

    self.backgroundCamera = self.transform:Find("UICamera"):GetComponent("Camera");
    local _leftBottom = self.backgroundCamera:ViewportToWorldPoint(Vector3.New(0, 0, 0));
    local _rightTop = self.backgroundCamera:ViewportToWorldPoint(Vector3.New(1, 1, 0));
    self.viewportRect = Vector4.New(_leftBottom.x, _rightTop.y, _rightTop.x, _leftBottom.y);

    self.backgroup = self.backgroundPanel:Find("Background");

    self.goldEffectPool = self.fishPanel:Find("GoldEffectPool");
    self.goldEffectPoolAllScene = self.fishPanel:Find("GoldEffectPoolAllScene");
    self.fishPool = self.fishPanel:Find("FishPool");
    self.bulletPool = self.fishPanel:Find("BulletPool");
    self.netPool = self.fishPanel:Find("NetPool");

    self.fishScene = self.fishPanel:Find("FishScene");
    self.bulletEffectScene = self.fishPanel:Find("BulletEffectScene");
    self.bulletScene = self.fishPanel:Find("BulletScene");
    self.netScene = self.fishPanel:Find("NetScene");

    self.fishCache = self.fishPanel:Find("FishCache");
    self.bulletEffectCache = self.fishPanel:Find("BulletEffectCache");
    self.bulletCache = self.fishPanel:Find("BulletCache");
    self.netCache = self.fishPanel:Find("NetCache");

    self.playerGroup = self.uiPanel:Find("PlayerGunGroup");
    self.systemGroup = self.uiPanel:Find("SystemGroup");
    self.lockBtn = self.systemGroup:Find("RightGroup/Lock"):GetComponent("Toggle");
    self.lockBtn.isOn = false;
    self.lockBtn.transform:Find("Flag").gameObject:SetActive(false);
    self.continueBtn = self.systemGroup:Find("RightGroup/Continue"):GetComponent("Toggle");
    self.continueBtn.isOn = false;
    self.continueBtn.transform:Find("Flag").gameObject:SetActive(false);
    self.rulePanel = self.uiPanel:Find("Rule");
    self.lockNode = self.uiPanel:Find("Lock");
    self.soundList = self.uiPanel:Find("SoundList");
    self.tips = self.uiPanel:Find("Tips");
    self.quitPanel = self.uiPanel:Find("QuitPanel");
    self.quitBtn = self.quitPanel:Find("Content/Quit"):GetComponent("Button");
    self.cancelQuitBtn = self.quitPanel:Find("Content/Cancel"):GetComponent("Button");

    self.settingPanel = self.uiPanel:Find("Setting");
    self.musicSet = self.settingPanel:Find("Music/MusicSlider"):GetComponent("Slider");
    self.soundSet = self.settingPanel:Find("Sound/SoundSlider"):GetComponent("Slider");
    self.closeSet = self.settingPanel:Find("Sure"):GetComponent("Button");

    self.moveGroup = self.systemGroup:Find("LeftGroup/GroupImage");
    self.openMoveGroup = self.systemGroup:Find("LeftGroup/OpenBtn"):GetComponent("Toggle");
    self.openBackBtn = self.moveGroup:Find("Quit"):GetComponent("Button");
    self.setBtn = self.moveGroup:Find("Setting"):GetComponent("Button");
    self.openRuleBtn = self.moveGroup:Find("Help"):GetComponent("Button");
    self.openMoveGroup.isOn = false;
    self.moveGroup.gameObject:SetActive(false);

    self.EffectPool = self.uiPanel:Find("EffectPool");
    self.effectScene = self.uiPanel:Find("EffectScene");
    self.heidongEffect = self.EffectPool:Find("HeiDong");

    self.touchArea = self.fishPanel:Find("TouchArea").gameObject;
    self.sceneArea = self.fishPanel:Find("Area");
    self.width = self.sceneArea:Find("Point2").localPosition.x - self.sceneArea:Find("Point1").localPosition.x;
    self.height = self.sceneArea:Find("Point2").localPosition.y - self.sceneArea:Find("Point1").localPosition.y;

end
function OneWPBYEntry.AddListener()
    local touchAreaListener = Util.AddComponent("EventTriggerListener", self.touchArea);
    touchAreaListener.onDown = function()
        log("点击发炮");
        local vector2 = self.backgroundCamera:ScreenToWorldPoint(Input.mousePosition);
        local player = OneWPBY_PlayerController.GetPlayer(self.ChairID);
        player.gun_Function.gameObject:SetActive(false);
        local ranFish = OneWPBY_FishController.OnGetRandomLookFish(true);
        if ranFish == nil then
            player.dir = vector2;
            player:RotatePaoTaiByPos(player.dir);
            return ;
        end
        if player.LockFish == nil then
            player.dir = vector2;
            if player.isContinue then
                player:RotatePaoTaiByPos(player.dir);
            else
                OneWPBY_PlayerController.ShootSelfBullet(Vector3.New(vector2.x, vector2.y, 0), self.ChairID);
            end
        else
            if not player.isContinue then
                vector2 = player.LockFish.transform.position;
                OneWPBY_PlayerController.ShootSelfBullet(Vector3.New(vector2.x, vector2.y, 0), self.ChairID);
            end
        end
    end;

    self.lockBtn.onValueChanged:RemoveAllListeners();
    self.lockBtn.onValueChanged:AddListener(function(value)
        self.ControlLock(value);
    end);
    self.continueBtn.onValueChanged:RemoveAllListeners();
    self.continueBtn.onValueChanged:AddListener(function(value)
        local player = OneWPBY_PlayerController.GetPlayer(self.ChairID);
        if player ~= nil then
            if player.goldNum < OneWPBY_Struct.CMD_S_CONFIG.bulletScore[player.gungrade + 1] * (player.gunLevel + 1) then
                MessageBox.CreatGeneralTipsPanel("Not enough gold!");
                return ;
            end
        end
        self.ControlContinue(value);
    end);

    self.openMoveGroup.onValueChanged:RemoveAllListeners();
    self.openMoveGroup.onValueChanged:AddListener(function(value)
        self.moveGroup.gameObject:SetActive(value);
    end);
    self.openBackBtn.onClick:RemoveAllListeners();
    self.openBackBtn.onClick:AddListener(function()
        self.openMoveGroup.isOn = false;
        self.moveGroup.gameObject:SetActive(false);
        self.quitPanel.gameObject:SetActive(true);
        self.quitBtn.onClick:RemoveAllListeners();
        self.quitBtn.onClick:AddListener(function()
            Event.Brocast(MH.Game_LEAVE);
        end);
        self.cancelQuitBtn.onClick:RemoveAllListeners();
        self.cancelQuitBtn.onClick:AddListener(function()
            self.quitPanel.gameObject:SetActive(false);
        end);
    end);
    self.openRuleBtn.onClick:RemoveAllListeners();
    self.openRuleBtn.onClick:AddListener(function()
        OneWPBY_Rule.ShowRule();
    end);
    self.setBtn.onClick:RemoveAllListeners();
    self.setBtn.onClick:AddListener(self.OpenSettingPanel);
end
function OneWPBYEntry.ControlContinue(value)
    local player = OneWPBY_PlayerController.GetPlayer(self.ChairID);
    player.isContinue = value;
    self.continueBtn.isOn = value;
    self.continueBtn.transform:Find("Flag").gameObject:SetActive(value);
    if value then
        player:ContinueFire(OneWPBY_PlayerController.acceleration, OneWPBY_PlayerController.acceleration);
    else
        player:StopContinueFire();
    end
end
function OneWPBYEntry.ControlLock(value)
    local player = OneWPBY_PlayerController.GetPlayer(self.ChairID);
    player:SetLockState(value);
    self.lockBtn.isOn = value;
    OneWPBY_FishController.SetLockFish(value);
    if value then
        self.touchArea.transform:SetAsFirstSibling();
    else
        self.touchArea.transform:SetAsLastSibling();
        local buffer = ByteBuffer.New();
        buffer:WriteByte(self.ChairID);
        Network.Send(MH.MDM_GF_GAME, OneWPBY_Network.SUB_C_PlayerCancalLock, buffer, gameSocketNumber.GameSocket);
    end
    self.lockBtn.transform:Find("Flag").gameObject:SetActive(value);
end
function OneWPBYEntry.OpenSettingPanel()
    OneWPBY_Audio.PlaySound(OneWPBY_Audio.SoundList.BTN);
    self.moveGroup.gameObject:SetActive(false);
    self.settingPanel.gameObject:SetActive(true);
    self.openMoveGroup.isOn = false;
    --if not PlayerPrefs.HasKey("MusicValue") then
    --    PlayerPrefs.SetString("MusicValue", "1");
    --end
    --if not PlayerPrefs.HasKey("SoundValue") then
    --    PlayerPrefs.SetString("SoundValue", "1");
    --end
    self.musicSet.value = MusicManager:GetIsPlayMV() and MusicManager:GetMusicVolume() or 0;
    self.soundSet.value = MusicManager:GetIsPlaySV() and MusicManager:GetSoundVolume() or 0;
    self.luaBehaviour:AddSliderEvent(self.musicSet.gameObject, function(value)
        --PlayerPrefs.SetString("MusicValue", tostring(value));
        --if value <= 0 then
        --    AllSetGameInfo._5IsPlayAudio = false;
        --else
        --    AllSetGameInfo._5IsPlayAudio = true;
        --end
        --Util.Write("IsPlayAudio", tostring(AllSetGameInfo._5IsPlayAudio));
        --PlayerPrefs.SetString("IsPlayAudio", tostring(AllSetGameInfo._5IsPlayAudio));
        MusicManager:SetValue(MusicManager:GetSoundVolume(), tonumber(value));
        OneWPBY_Audio.pool.volume = value;
        MusicManager:SetMusicMute(value <= 0);
        OneWPBY_Audio.pool.mute = not MusicManager:GetIsPlayMV();
        --GameManager.SetIsPlayMute(AllSetGameInfo._6IsPlayEffect, AllSetGameInfo._5IsPlayAudio);
    end);
    self.luaBehaviour:AddSliderEvent(self.soundSet.gameObject, function(value)
        MusicManager:SetValue(tonumber(value),MusicManager:GetMusicVolume());
        MusicManager:SetSoundMute(value <= 0);
        --PlayerPrefs.SetString("SoundValue", tostring(value));
        --if value <= 0 then
        --    AllSetGameInfo._6IsPlayEffect = false;
        --else
        --    AllSetGameInfo._6IsPlayEffect = true;
        --end
        --Util.Write("isCanPlaySound", tostring(AllSetGameInfo._6IsPlayEffect));
        --PlayerPrefs.SetString("isCanPlaySound", tostring(AllSetGameInfo._6IsPlayEffect));
        --GameManager.SetIsPlayMute(AllSetGameInfo._6IsPlayEffect, AllSetGameInfo._5IsPlayAudio);
    end);
    self.closeSet.onClick:RemoveAllListeners();
    self.closeSet.onClick:AddListener(function()
        self.settingPanel.gameObject:SetActive(false);
    end);
end
function OneWPBYEntry.GetBezierPoint(controllerPos, segmentNum)
    local poss = {};
    for i = 1, segmentNum do
        local t = i / segmentNum;
        local pos = self.GetPathToPoint(controllerPos, t);
        table.insert(poss, pos);
    end
    return poss;
end
--高阶贝塞尔算法
function OneWPBYEntry.GetPathToPoint(controlPosList, t)
    local p = Vector3.New(0, 0, 0);
    local n = 1 - t;
    --系数是根据杨辉三角的值是相同的
    --TODO: 实现任意阶贝塞尔曲线
    local x = 0;
    local y = 0;
    local count = #controlPosList;
    for i = 1, count do
        local index = 1;
        if i == 2 then
            index = 4;
        elseif i >= 3 and i <= count - 2 then
            index = 8;
        elseif i == count - 1 then
            index = 4;
        end
        x = x + index * controlPosList[i].x * Mathf.Pow(n, count - i) * Mathf.Pow(t, i - 1);
        y = y + index * controlPosList[i].y * Mathf.Pow(n, count - i) * Mathf.Pow(t, i - 1);
    end
    p = Vector3.New(x, y, 0);
    return p;
end
function OneWPBYEntry.InitPanel(config)
    --初始化背景
    OneWPBY_GoldEffect.OnChangeBGStart(config.bGID);
end
function OneWPBYEntry.ToCharArray(num)
    --拆解字符串
    local str = tostring(num);
    local list1 = {}
    for i = 1, string.len(str) do
        table.insert(list1, #list1 + 1, string.sub(str, i, i));
    end
    return list1;
end
function OneWPBYEntry.FormatNumberThousands(num)
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
function OneWPBYEntry.ShowText(str)
    return ShowRichText(ShortNumber(str));
    --展示tmp字体
    --local arr = self.ToCharArray(str);
    --local _str = "";
    --for i = 1, #arr do
    --    _str = _str .. string.format("<sprite name=\"%s\" tint=1>", arr[i]);
    --end
    --return _str;
end
function OneWPBYEntry.ShowTip(fishkind)
    local tip = nil;
    if fishkind == -1 then
        --鱼潮
        tip = self.tips:Find("YC");
    end
    if tip ~= nil then
        tip.gameObject:SetActive(true);
        local tipNum = tip:Find("TimeNum"):GetComponent("TextMeshProUGUI");
        Util.RunWinScore(5, 0, 5, function(value)
            local v = math.ceil(value);
            if tipNum ~= nil then
                tipNum.text = tostring(v);
            end
        end):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            if tip ~= nil then
                tip.gameObject:SetActive(false);
            end
        end);
    end
end
--通过fishID查找倍率,改变金币柱显示和金币特效生成
function OneWPBYEntry.GetMagnificationToFishID(fishId)
    local fish = OneWPBY_FishController.GetFish(fishId);
    local magnification = 0;
    local conversion = 0;
    if fish.fishData.Kind <= 2 then
        magnification = 2;
    elseif fish.fishData.Kind > 2 and fish.fishData.Kind <= 10 then
        magnification = fish.fishData.Kind;
    elseif fish.fishData.Kind == 11 then
        magnification = 12;
    elseif fish.fishData.Kind == 12 then
        magnification = 15;
    elseif fish.fishData.Kind == 13 then
        magnification = 18;
    elseif fish.fishData.Kind == 14 then
        magnification = 20;
    elseif fish.fishData.Kind == 15 then
        magnification = 25;
    elseif fish.fishData.Kind == 16 then
        magnification = 30;
    elseif fish.fishData.Kind == 17 then
        magnification = 35;
    elseif fish.fishData.Kind == 18 then
        magnification = 350;
    elseif fish.fishData.Kind == 19 then
        magnification = 150;
    elseif fish.fishData.Kind == 20 then
        magnification = 200;
    elseif fish.fishData.Kind == 21 then
        magnification = 320;
    elseif fish.fishData.Kind == 22 then
        magnification = 300;
    elseif fish.fishData.Kind == 27 then
        magnification = 2;
    elseif fish.fishData.Kind == 28 then
        magnification = 2;
    elseif fish.fishData.Kind == 29 then
        magnification = 3;
    elseif fish.fishData.Kind == 30 then
        magnification = 4;
    elseif fish.fishData.Kind == 31 then
        magnification = 5;
    elseif fish.fishData.Kind == 32 then
        magnification = 6;
    elseif fish.fishData.Kind == 33 then
        magnification = 7;
    elseif fish.fishData.Kind == 34 then
        magnification = 8;
    elseif fish.fishData.Kind == 35 then
        magnification = 9;
    elseif fish.fishData.Kind == 36 then
        magnification = 12;
    elseif fish.fishData.Kind == 37 then
        magnification = 2;
    elseif fish.fishData.Kind == 38 then
        magnification = 4;
    elseif fish.fishData.Kind == 39 then
        magnification = 8;
    elseif fish.fishData.Kind == 40 then
        magnification = 12;
    elseif fish.fishData.Kind == 41 then
        magnification = 18;
    elseif fish.fishData.Kind == 42 then
        magnification = 12;
    elseif fish.fishData.Kind == 43 then
        magnification = 18;
    elseif fish.fishData.Kind == 44 then
        magnification = 24;
    elseif fish.fishData.Kind == 45 then
        magnification = 30;
    elseif fish.fishData.Kind == 46 then
        magnification = 12;
    elseif fish.fishData.Kind == 47 then
        magnification = 20;
    elseif fish.fishData.Kind == 48 then
        magnification = 28;
    elseif fish.fishData.Kind == 49 then
        magnification = 36;
    end
    if magnification <= 10 then
        conversion = magnification;
    elseif magnification <= 50 then
        conversion = magnification / 5 + 7;
    elseif magnification <= 150 then
        conversion = magnification / 10 + 2;
    else
        conversion = magnification / 20 + 10;
    end
    return conversion;
end
function OneWPBYEntry.GetHeadIcon(headIndex)
    local index = tonumber(headIndex);
    return HallScenPanel.headIcons.transform:GetChild(index - 1):GetComponent("Image").sprite;
end