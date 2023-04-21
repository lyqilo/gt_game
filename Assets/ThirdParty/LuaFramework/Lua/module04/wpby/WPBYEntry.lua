local g_sWSZSModuleNum = "Module04/wpby/";

require(g_sWSZSModuleNum .. "WPBY_Network")
require(g_sWSZSModuleNum .. "WPBY_Struct")
require(g_sWSZSModuleNum .. "WPBY_DataConfig")
require(g_sWSZSModuleNum .. "WPBY_Rule")
require(g_sWSZSModuleNum .. "WPBY_Audio")
require(g_sWSZSModuleNum .. "WPBY_Bullet")
require(g_sWSZSModuleNum .. "WPBY_BulletController")
require(g_sWSZSModuleNum .. "WPBY_Fish")
require(g_sWSZSModuleNum .. "WPBY_FishController")
require(g_sWSZSModuleNum .. "WPBY_Net")
require(g_sWSZSModuleNum .. "WPBY_NetController")
require(g_sWSZSModuleNum .. "WPBY_Player")
require(g_sWSZSModuleNum .. "WPBY_PlayerController")
require(g_sWSZSModuleNum .. "WPBY_GoldEffect")

WPBYEntry = {};
local self = WPBYEntry;

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

function WPBYEntry:Awake(obj)
    self.gameObject = obj.gameObject;
    self.transform = self.gameObject.transform;
    self.FindComponent();
    self.AddListener();
    WPBY_FishController.Init();
    WPBY_BulletController.Init();
    WPBY_PlayerController.Init();
    WPBY_Audio.Init();
    WPBY_Rule.Init();
    WPBY_GoldEffect.Init(self.EffectPool);
    WPBY_Network.AddMessage();
    WPBY_Network.LoginGame();
    WPBY_Audio.PlayBGM(WPBY_Audio.SoundList.BGM);
end
function WPBYEntry.DelayCall(timer, callback)
    local tweener = Util.RunWinScore(0, 1, timer, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        if callback ~= nil then
            callback();
        end
    end);
    return tweener;
end
function WPBYEntry:Update()
end
function WPBYEntry.FindComponent()
    self.backgroundPanel = self.transform:Find("BackgroundPanel");
    self.fishPanel = self.transform:Find("FishPanel");
    self.uiPanel = self.transform:Find("UIPanel");

    self.backgroundCamera = self.transform:Find("UICamera"):GetComponent("Camera");
    local _leftBottom = self.backgroundCamera:ViewportToWorldPoint(Vector3.New(0, 0, 0));
    local _rightTop = self.backgroundCamera:ViewportToWorldPoint(Vector3.New(1, 1, 0));
    self.viewportRect = Vector4.New(_leftBottom.x, _rightTop.y, _rightTop.x, _leftBottom.y);

    self.backgroup = self.backgroundPanel:Find("Background");

    self.goldEffectPool = self.fishPanel:Find("GoldEffectPool");
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
    self.addspeedBtn = self.systemGroup:Find("RightGroup/Skill1"):GetComponent("Toggle");
    self.addspeedBtn.isOn = false;
    self.addspeedBtn.transform:Find("Open").gameObject:SetActive(false);
    self.lockBtn = self.systemGroup:Find("RightGroup/Skill2"):GetComponent("Toggle");
    self.lockBtn.isOn = false;
    self.lockBtn.transform:Find("Open").gameObject:SetActive(false);
    self.continueBtn = self.systemGroup:Find("RightGroup/Skill3"):GetComponent("Toggle");
    self.continueBtn.isOn = false;
    self.continueBtn.transform:Find("Open").gameObject:SetActive(false);
    self.specialBtn = self.systemGroup:Find("RightGroup/Skill4"):GetComponent("Toggle");
    self.specialBtn.isOn = false;
    self.specialBtn.interactable = false;
    self.specialBtn.transform:Find("Open").gameObject:SetActive(false);
    self.rulePanel = self.uiPanel:Find("Rule");
    self.lockNode = self.uiPanel:Find("Lock");
    self.soundList = self.uiPanel:Find("SoundList");
    self.tips = self.uiPanel:Find("Tips");
    self.quitPanel = self.uiPanel:Find("QuitPanel");
    self.quitBtn = self.quitPanel:Find("Content/Quit"):GetComponent("Button");
    self.cancelQuitBtn = self.quitPanel:Find("Content/Cancel"):GetComponent("Button");

    self.moveGroup = self.systemGroup:Find("LeftGroup/MoveGroup");
    self.openMoveGroup = self.moveGroup:Find("OpenBtn"):GetComponent("Toggle");
    self.openBackBtn = self.moveGroup:Find("Group/BackGameBtn"):GetComponent("Button");
    self.musicBtn = self.moveGroup:Find("Group/MusicBtn"):GetComponent("Toggle");
    self.openRuleBtn = self.moveGroup:Find("Group/HelpBtn"):GetComponent("Button");

    self.musicBtn.isOn = AllSetGameInfo._5IsPlayAudio and AllSetGameInfo._6IsPlayEffect;

    self.EffectPool = self.uiPanel:Find("EffectPool");
    self.effectScene = self.uiPanel:Find("EffectScene");
    self.heidongEffect = self.EffectPool:Find("HeiDong");

    self.touchArea = self.fishPanel:Find("TouchArea").gameObject;
    self.sceneArea = self.fishPanel:Find("Area");
    self.width = self.sceneArea:Find("Point2").localPosition.x - self.sceneArea:Find("Point1").localPosition.x;
    self.height = self.sceneArea:Find("Point2").localPosition.y - self.sceneArea:Find("Point1").localPosition.y;

end
function WPBYEntry.AddListener()
    local touchAreaListener = Util.AddComponent("EventTriggerListener", self.touchArea);
    touchAreaListener.onDown = function()
        log("点击发炮");
        local vector2 = self.backgroundCamera:ScreenToWorldPoint(Input.mousePosition);
        local player = WPBY_PlayerController.GetPlayer(self.ChairID);
        if not player.IsLock then
            player.dir = vector2;
            WPBY_PlayerController.ShootSelfBullet(Vector3.New(vector2.x, vector2.y, 0), self.ChairID);
        else
            if player.LockFish == nil then
                WPBY_PlayerController.ContinuousFireByPos(true, self.ChairID, vector2)
            end
        end
    end;

    self.addspeedBtn.onValueChanged:RemoveAllListeners();
    self.addspeedBtn.onValueChanged:AddListener(function(value)
        local player = WPBY_PlayerController.GetPlayer(self.ChairID);
        if value then
            WPBY_PlayerController.acceleration = 0.15;
        else
            WPBY_PlayerController.acceleration = 0.3;
        end
        self.addspeedBtn.transform:Find("Open").gameObject:SetActive(value);
        player.isThumb = value;
        if player.isContinue then
            player:StopContinueFire();
            player:ContinueFire(WPBY_PlayerController.acceleration, WPBY_PlayerController.acceleration);
        end
    end);
    self.lockBtn.onValueChanged:RemoveAllListeners();
    self.lockBtn.onValueChanged:AddListener(function(value)
        local player = WPBY_PlayerController.GetPlayer(self.ChairID);
        player:SetLockState(value);
        WPBY_FishController.SetLockFish(value);
        if value then
            WPBY_FishController.isLockBigFish = false;
            self.touchArea.transform:SetAsFirstSibling();
            player:StopContinueFire();
            self.specialBtn.interactable = true;
            player:SetLockFish(-1);
            player:ContinueFire(WPBY_PlayerController.acceleration, WPBY_PlayerController.acceleration);
        else
            player:StopContinueFire();
            self.continueBtn.isOn = false;
            player.isContinue = false;
            self.continueBtn.transform:Find("Open").gameObject:SetActive(false);
            self.touchArea.transform:SetAsLastSibling();
            self.specialBtn.interactable = false;
            self.specialBtn.isOn = false;
            self.specialBtn.transform:Find("Open").gameObject:SetActive(false);
            local buffer = ByteBuffer.New();
            buffer:WriteByte(self.ChairID);
            Network.Send(MH.MDM_GF_GAME, WPBY_Network.SUB_C_PlayerCancalLock, buffer, gameSocketNumber.GameSocket);
        end
        self.lockBtn.transform:Find("Open").gameObject:SetActive(value);
    end);
    self.continueBtn.onValueChanged:RemoveAllListeners();
    self.continueBtn.onValueChanged:AddListener(function(value)
        local player = WPBY_PlayerController.GetPlayer(self.ChairID);
        player.isContinue = value;
        self.continueBtn.transform:Find("Open").gameObject:SetActive(value);
        if value then
            player:ContinueFire(WPBY_PlayerController.acceleration, WPBY_PlayerController.acceleration);
        else
            if not player.IsLock then
                player:StopContinueFire();
            end
        end
    end);
    self.specialBtn.onValueChanged:RemoveAllListeners();
    self.specialBtn.onValueChanged:AddListener(function(value)
        local player = WPBY_PlayerController.GetPlayer(self.ChairID);
        WPBY_FishController.isLockBigFish = value;
        self.specialBtn.transform:Find("Open").gameObject:SetActive(value);
        if not value then
            player.IsLock = false;
            self.lockBtn.isOn = false;
            self.lockBtn.transform:Find("Open").gameObject:SetActive(false);
            player.LockFish = nil;
            player:StopContinueFire();
            self.continueBtn.isOn = false;
            player.isContinue = false;
            self.continueBtn.transform:Find("Open").gameObject:SetActive(false);
            local buffer = ByteBuffer.New();
            buffer:WriteByte(self.ChairID);
            Network.Send(MH.MDM_GF_GAME, WPBY_Network.SUB_C_PlayerCancalLock, buffer, gameSocketNumber.GameSocket);
            self.specialBtn.interactable = false;
        end
    end);

    self.openMoveGroup.onValueChanged:RemoveAllListeners();
    self.openMoveGroup.onValueChanged:AddListener(function(value)
        self.openMoveGroup.interactable = false;
        if self.moveGroupTweener ~= nil then
            self.moveGroupTweener:Kill();
            self.moveGroupTweener = nil;
        end
        if value then
            self.moveGroupTweener = self.moveGroup.transform:DOLocalMove(Vector3.New(-90, 0, 0), 0.3):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                self.openMoveGroup.interactable = true;
                self.openMoveGroup.transform:GetChild(0).localScale = Vector3.New(1, 1, 1);
            end);
        else
            self.moveGroupTweener = self.moveGroup.transform:DOLocalMove(Vector3.New(0, 0, 0), 0.3):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                self.openMoveGroup.interactable = true;
                self.openMoveGroup.transform:GetChild(0).localScale = Vector3.New(-1, 1, 1);
            end);
        end
    end);
    self.openBackBtn.onClick:RemoveAllListeners();
    self.openBackBtn.onClick:AddListener(function()
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
        WPBY_Rule.ShowRule();
    end);
    self.musicBtn.onValueChanged:RemoveAllListeners();
    self.musicBtn.onValueChanged:AddListener(function(value)
        if value then
            SetInfoSystem.ResetMute();
        else
            SetInfoSystem.GameMute();
        end ;
        WPBY_Audio.pool.mute = not AllSetGameInfo._5IsPlayAudio;
    end);
end
function WPBYEntry.GetBezierPoint(controllerPos, segmentNum)
    local poss = {};
    for i = 1, segmentNum do
        local t = i / segmentNum;
        local pos = self.GetPathToPoint(controllerPos, t);
        table.insert(poss, pos);
    end
    return poss;
end
--高阶贝塞尔算法
function WPBYEntry.GetPathToPoint(controlPosList, t)
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
function WPBYEntry.InitPanel(config)
    --初始化背景
    WPBY_GoldEffect.OnChangeBGStart(config.bGID);
end
function WPBYEntry.ToCharArray(num)
    --拆解字符串
    local str = tostring(num);
    local list1 = {}
    for i = 1, string.len(str) do
        table.insert(list1, #list1 + 1, string.sub(str, i, i));
    end
    return list1;
end
function WPBYEntry.FormatNumberThousands(num)
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
function WPBYEntry.ShowText(str)
    --展示tmp字体
    local arr = self.ToCharArray(str);
    local _str = "";
    for i = 1, #arr do
        _str = _str .. string.format("<sprite name=\"%s\" tint=1>", arr[i]);
    end
    return _str;
end
function WPBYEntry.ShowTip(fishkind)
    local tip = nil;
    if fishkind == 18 then
        --海豚
        tip = self.tips:Find("HT");
    elseif fishkind == 19 then
        --银龙
        tip = self.tips:Find("YL");
    elseif fishkind == 20 then
        --金龙
        tip = self.tips:Find("JL");
    elseif fishkind == 21 then
        --企鹅
        tip = self.tips:Find("STQE");
    elseif fishkind == 22 then
        --李逵
        tip = self.tips:Find("LK");
    elseif fishkind >= 27 and fishkind <= 36 then
        --鱼王
        tip = self.tips:Find("YW");
    elseif fishkind == -1 then
        --鱼潮
        tip = self.tips:Find("YC");
    end
    if tip ~= nil then
        tip.gameObject:SetActive(true);
        self.DelayCall(2, function()
            tip.gameObject:SetActive(false);
        end);
    end
end
--通过fishID查找倍率,改变金币柱显示和金币特效生成
function WPBYEntry.GetMagnificationToFishID(fishId)
    local fish = WPBY_FishController.GetFish(fishId);
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
function WPBYEntry.GetHeadIcon(headIndex)
    local index = tonumber(headIndex);
    return HallScenPanel.headIcons.transform:GetChild(index - 1):GetComponent("Image").sprite;
end