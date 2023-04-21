WPBY_Player = {};

local self = WPBY_Player;
self.data = nil;
self.goldNum = 0;
self.gunLevel = 1;

self.ptTrans = nil;
self.playerInfo = nil;
self.playerGoldChangeGroup = nil;
self.posTag = nil;

self.addBeiBtn = nil;
self.reduceBeiBtn = nil;
self.gunGroup = nil;
self.gunPoint = nil;
self.gunEffect_Normal = nil;
self.gunEffect_Super = nil;
self.onSitTag = nil;
self.changeGunBtn = nil;

self.userHead = nil;
self.userName = nil;
self.userGold = nil;
self.isSelf = false;
self.ptConfig = {};
self.shootPoint = nil;
self.LockFish = nil;
self.IsLock = false;
self.bulletID = 0;
self.bulletList = {};

self.goldlist = {};
self.goldMaxNum = 12;
self.timer = 0;
self.updateTime = 3;
self.isSuperMode = false;

self.isRobot = false;
self.isRobotIsLock = false;

self.dir = nil;
self.isThumb = false;
self.isContinue = false;

self.TheGun = nil;
self.lockObj = nil;
function WPBY_Player:New()
    local t = o or {};
    setmetatable(t, self);
    self.__index = self;
    return t;
end
function WPBY_Player:InitPlayer(obj)
    self.gameObject = obj;
    self.transform = obj.transform;
    self.luaBehaviour = self.transform:GetComponent("BaseBehaviour");
    if self.luaBehaviour == nil then
        self.luaBehaviour = Util.AddComponent("BaseBehaviour", self.gameObject);
        self.luaBehaviour:SetLuaTab(self, "WPBY_Player");
    end
    self.ptTrans = self.transform:Find("PaoTai");
    self.playerInfo = self.transform:Find("UserInfo");
    self.playerGoldChangeGroup = self.transform:Find("ChangeGoldGroup");
    self.playerGoldChangeGroup:GetChild(0).gameObject:SetActive(false);
    self.posTag = self.transform:Find("SelfPos");

    self.addBeiBtn = self.ptTrans:Find("Add"):GetComponent("Button");
    self.reduceBeiBtn = self.ptTrans:Find("Reduce"):GetComponent("Button");
    self.gunGroup = self.ptTrans:Find("GunGroup");
    self.gunPoint = self.gunGroup:Find("Gun");
    self.gunEffect = self.gunGroup:Find("GunEffect");
    self.gunEffect_Normal = self.gunEffect:Find("Normal")
    self.gunEffect_Super = self.gunEffect:Find("Super");
    self.shootPoint = self.gunGroup:Find("ShootPoint");
    self.changeGunBtn = self.ptTrans:Find("ChangeGun"):GetComponent("Button");
    self.onSitTag = self.ptTrans:Find("OnSit");
    self.chipNum = self.ptTrans:Find("Chip"):GetComponent("TextMeshProUGUI");

    self.userHead = self.playerInfo:Find("Head"):GetComponent("Image");
    self.userName = self.playerInfo:Find("NickName"):GetComponent("Text");
    self.userGold = self.playerInfo:Find("GoldNum"):GetComponent("TextMeshProUGUI");
    self.bulletList = {};
    self.goldlist = {};
end
--初始化玩家信息,玩家进入
function WPBY_Player:Enter(userdata)
    self.data = userdata;
    self.goldNum = self.data._7wGold;
    if WPBYEntry.ChairID == self.data._9wChairID then
        self.onSitTag.gameObject:SetActive(true);
        self.addBeiBtn.gameObject:SetActive(true);
        self.reduceBeiBtn.gameObject:SetActive(true);
        self.changeGunBtn.gameObject:SetActive(false);
        self.posTag.gameObject:SetActive(true);
    else
        self.onSitTag.gameObject:SetActive(false);
        self.addBeiBtn.gameObject:SetActive(false);
        self.reduceBeiBtn.gameObject:SetActive(false);
        self.changeGunBtn.gameObject:SetActive(false);
        self.posTag.gameObject:SetActive(false);
    end
    self.playerGoldChangeGroup.gameObject:SetActive(true);
    self.gunGroup.gameObject:SetActive(true);
    for i = 1, self.playerGoldChangeGroup.childCount do
        self.playerGoldChangeGroup:GetChild(i - 1).gameObject:SetActive(false);
    end
    for i = 1, self.gunPoint.childCount do
        self.gunPoint:GetChild(i - 1).gameObject:SetActive(false);
    end
    self.ptTrans.gameObject:SetActive(true);
    self.gunLevel = 0;
    self:OnSetUserGunLevel(self.gunLevel);
    self.playerInfo.gameObject:SetActive(true);
    self.userHead.sprite = WPBYEntry.GetHeadIcon(self.data._5szHeaderExtensionName);
    self.userName.text = self.data._2szNickName;
    self.userGold.text = self.data._7wGold;
    self:AddListener();
end
function WPBY_Player:OnDestroy()
    self:Leave();
end
function WPBY_Player:AddListener()
    self.addBeiBtn.onClick:RemoveAllListeners();
    self.addBeiBtn.onClick:AddListener(function()
        self:AddBet();
        self:SendChangeGunLevel(true);
    end);
    self.reduceBeiBtn.onClick:RemoveAllListeners();
    self.reduceBeiBtn.onClick:AddListener(function()
        self:ReduceBet();
        self:SendChangeGunLevel(false);
    end);
end
function WPBY_Player:Update()
    self.timer = self.timer + Time.deltaTime;
    if self.timer >= self.updateTime then
        if #self.goldlist > 0 then
            destroy(self.goldlist[1]);
            table.remove(self.goldlist, 1);
        end
        self.timer = 0;
    end
    if self.IsLock then
        if self.LockFish == nil or self.LockFish.isdead or not self.LockFish:IsToSence() then
            if self.lockObj == nil then
                self.lockObj = newObject(WPBYEntry.lockNode:GetChild(0).gameObject);
                self.lockObj.transform:SetParent(WPBYEntry.lockNode);
                self.lockObj.transform.localPosition = Vector3.New(0, 0, 0);
                self.lockObj.transform.localScale = Vector3.New(1, 1, 1);
            end
            self.lockObj.gameObject:SetActive(false);
            self.LockFish = WPBY_FishController.OnGetRandomLookFish(self.isRobot);
            if self.LockFish ~= nil and not self.isRobot then
                self.lockObj.gameObject:SetActive(true);
                return ;
            end
        else
            if not self.isRobot then
                if self.lockObj == nil then
                    self.lockObj = newObject(WPBYEntry.lockNode:GetChild(0).gameObject);
                    self.lockObj.transform:SetParent(WPBYEntry.lockNode);
                    self.lockObj.transform.localPosition = Vector3.New(0, 0, 0);
                    self.lockObj.transform.localScale = Vector3.New(1, 1, 1);
                end
                self.lockObj.transform.position = self.LockFish.transform.position;
            end
            self:RotatePaoTaiByPos(self.LockFish.transform.position);
        end
    end
end
function WPBY_Player:ContinueFire(delayTime, time)
    if self.repeatTweener ~= nil then
        coroutine.stop(self.repeatTweener);
        self.repeatTweener = nil;
    end
    self.repeatTweener = coroutine.start(function()
        coroutine.wait(delayTime);
        if self.IsLock and self.LockFish ~= nil then
            self.dir = self.LockFish.transform.position;
        end
        while true do
            while WPBY_GoldEffect.YC do
                coroutine.wait(0.1);
            end
            --TODO 发射子弹
            if self.IsLock and self.LockFish ~= nil then
                self.dir = self.LockFish.transform.position;
            end
            if self.dir == nil then
                if self.data._9wChairID == 0 or self.data._9wChairID == 1 then
                    self.dir = self.gunGroup.transform.position + Vector3.New(0, 1, 0);
                else
                    self.dir = self.gunGroup.transform.position - Vector3.New(0, 1, 0);
                end
            end
            WPBY_PlayerController.ShootSelfBullet(self.dir, self.data._9wChairID);
            coroutine.wait(time);
        end
    end);
end
function WPBY_Player:SetLockState(value)
    self.IsLock = value;
    if self.lockObj ~= nil then
        self.lockObj.gameObject:SetActive(false);
    end
end
function WPBY_Player:StopContinueFire()
    if self.repeatTweener ~= nil then
        coroutine.stop(self.repeatTweener);
        self.repeatTweener = nil;
    end
end
function WPBY_Player:AddBet()
    self.gunLevel = self.gunLevel + 1;
    if self.gunLevel >= 10 then
        self.gunLevel = 0;
    end
    self:OnSetUserGunLevel(self.gunLevel);
end
function WPBY_Player:ReduceBet()
    self.gunLevel = self.gunLevel - 1;
    if self.gunLevel < 0 then
        self.gunLevel = 9;
    end
    self:OnSetUserGunLevel(self.gunLevel);
end
function WPBY_Player:SendChangeGunLevel(isadd)
    local add = 0;
    if isadd then
        add = 1;
    else
        add = 0;
    end
    local buffer = ByteBuffer.New();
    buffer:WriteInt(self.data._9wChairID);
    buffer:WriteByte(add);
    Network.Send(MH.MDM_GF_GAME, WPBY_Network.SUB_C_CHANGEBULLETLEVEL, buffer, gameSocketNumber.GameSocket);
end
function WPBY_Player:ChangePTLevel(isadd)
    if isadd == 1 then
        self:AddBet();
    else
        self:ReduceBet();
    end
end
function WPBY_Player:OnSetUserGunLevel(level)
    --初始化炮台
    if self.isSuperMode then
        for i = 0, self.gunPoint.childCount - 1 do
            self.gunPoint:GetChild(i).gameObject:SetActive(false);
        end
        self.gunPoint:GetChild(10).gameObject:SetActive(true);
        self.TheGun = self.gunPoint:GetChild(10);
        return ;
    end
    self.gunLevel = level;
    for i = 0, self.gunPoint.childCount - 1 do
        if level == i then
            self.gunPoint:GetChild(i).gameObject:SetActive(true);
            self.TheGun = self.gunPoint:GetChild(i);
        else
            self.gunPoint:GetChild(i).gameObject:SetActive(false);
        end
    end
    self:SetPaoTaiChip();
end
function WPBY_Player:SetPaoTaiChip()
    if #WPBY_Struct.CMD_S_CONFIG.bulletScore > 0 then
        self.chipNum.text = WPBYEntry.ShowText(WPBY_Struct.CMD_S_CONFIG.bulletScore[self.gunLevel + 1]);
    end
end
--旋转炮台通过角度
function WPBY_Player:RotatePaoTaiByAngle(angle)
    self.gunGroup.localRotation = Vector3.New(0, 0, angle);
end
function WPBY_Player:Shoot(bullet)
    self:OnChangeUserScure(bullet.playCurScore, false);
    --self.userGold.text = tostring(bullet.playCurScore);
    local pos = Vector3.New(bullet.x, bullet.y, 0);
    self:RotatePaoTaiByPos(pos);
    self:CreateBulltEffect();
    self:CreateBullet(bullet);
end
function WPBY_Player:CreateBulltEffect()
    local eff = nil;
    local effParent = nil;
    if self.isSuperMode then
        effParent = self.gunEffect_Super;
    else
        effParent = self.gunEffect_Normal;
    end
    for i = 1, effParent.childCount do
        if not effParent:GetChild(i - 1).gameObject.activeSelf then
            eff = effParent:GetChild(i - 1);
            break ;
        end
    end

    if eff == nil then
        local go = newObject(effParent:GetChild(0).gameObject);
        go.transform:SetParent(effParent);
        go.transform.localPosition = Vector3.New(0, 0, 0);
        go.transform.localScale = Vector3.New(1, 1, 1);
        eff = go.transform;
    end

    eff.gameObject:SetActive(true);
    WPBYEntry.DelayCall(0.3, function()
        eff.gameObject:SetActive(false);
    end);
end
function WPBY_Player:CreateBullet(bullet)
    if self.bulletID >= WPBY_DataConfig.MAX_BULLET then
        self.bulletID = 1;
    else
        self.bulletID = self.bulletID + 1;
    end
    self:OnCreateBullet(self.bulletID, bullet);
end
function WPBY_Player:OnCreateBullet(bulletid, bulletdata)
    if self.fireTweener ~= nil then
        coroutine.stop(self.fireTweener);
        self.fireTweener = nil;
    end
    self.fireTweener = coroutine.start(function()
        self.TheGun.localScale = Vector3.New(1, 0.9, 1);
        coroutine.wait(0.05);
        self.TheGun.localScale = Vector3.New(1, 0.8, 1);
        coroutine.wait(0.05);
        self.TheGun.localScale = Vector3.New(1, 1.1, 1);
        coroutine.wait(0.05);
        self.TheGun.localScale = Vector3.New(1, 1, 1);
    end);
    local bullet = nil;
    if self.isSuperMode then
        bullet = WPBYEntry.bulletCache:Find("Bullt_11");
    else
        bullet = WPBYEntry.bulletCache:Find("Bullt_" .. (bulletdata.level + 1));
    end
    if bullet == nil then
        if self.isSuperMode then
            bullet = newobject(WPBYEntry.bulletPool:Find("Bullt_11").gameObject).transform;
        else
            bullet = newobject(WPBYEntry.bulletPool:Find("Bullt_" .. (bulletdata.level + 1)).gameObject).transform;
        end
    end
    bullet:SetParent(self.shootPoint);
    bullet.localPosition = Vector3.New(0, 0, 0);
    bullet.localRotation = Quaternion.identity;
    bullet.localScale = Vector3.New(1, 1, 1);
    bullet:SetParent(WPBYEntry.bulletScene);
    if self.isSuperMode then
        bullet.gameObject.name = "Bullt_11";
    else
        bullet.gameObject.name = "Bullt_" .. (bulletdata.level + 1);
    end
    local _bullet = WPBY_Bullet:New();
    _bullet.isLock = self.IsLock;
    _bullet.lockFish = self.LockFish;
    _bullet:Init(bullet, bulletid, bulletdata);
    table.insert(self.bulletList, _bullet);
    WPBY_Audio.PlaySound(WPBY_Audio.SoundList.Shoot);
end
--通过点击位置旋转炮塔
function WPBY_Player:RotatePaoTaiByPos(pos)
    local direction = pos - self.gunGroup.transform.position;
    local angle = 360 - Mathf.Atan2(direction.x, direction.y) * Mathf.Rad2Deg;
    self.gunGroup.transform.eulerAngles = Vector3.New(0, 0, angle);
end
--玩家离开
function WPBY_Player:Leave()
    self.onSitTag.gameObject:SetActive(false);
    self.gunGroup.gameObject:SetActive(false);
    self.reduceBeiBtn.gameObject:SetActive(false);
    self.addBeiBtn.gameObject:SetActive(false);
    self.playerGoldChangeGroup.gameObject:SetActive(false);
    self.playerInfo.gameObject:SetActive(false);
    self.posTag.gameObject:SetActive(false);
    self.changeGunBtn.gameObject:SetActive(true);
    self.chipNum.text = "";
    destroy(self.lockObj);
    self.lockObj = nil;
    self.LockFish = nil;
    self.IsLock = false;
    self.isRobot = false;
    self.isContinue = false;
    self.isThumb = false;
    self.isSuperMode = false;
    self.TheGun = nil;
    self.transform = nil;
    self.gameObject = nil;
    self.luaBehaviour = nil;
    self.dir = nil;
    self:CollectBullet();
    self:StopContinueFire();
    if self.robotLockFishCall ~= nil then
        coroutine.stop(self.robotLockFishCall);
        self.robotLockFishCall = nil;
    end
    if self.repeatTweener ~= nil then
        coroutine.stop(self.repeatTweener);
        self.repeatTweener = nil;
    end
end
function WPBY_Player:CollectBullet()
    for i = #self.bulletList, 1, -1 do
        self.bulletList[i]:Collect();
    end
end
--设置炮台值
function WPBY_Player:OnInit(config)
    self.ptConfig = config;
end
function WPBY_Player:OnChangeUserScure(change, isAdd)
    if isAdd then
        self.goldNum = self.goldNum + change;
        self.userGold.text = tostring(self.goldNum);
        return ;
    end
    if change > 0 then
        self.goldNum = change;
        self.userGold.text = tostring(self.goldNum);
    else
        self.goldNum = self.goldNum + change;
        self.userGold.text = tostring(self.goldNum);
    end
end
--显示金币柱
function WPBY_Player:OnShowGold(gold, fishId)
    local magnificat = WPBYEntry.GetMagnificationToFishID(fishId);
    if magnificat >= 10 then
        --TODO 音效
        local ran1 = math.random(0, 1);
        local ran2 = 0;
        if ran1 == 0 then
            ran2 = math.random(0, 7);
        else
            ran2 = math.random(9, 16);
        end
        WPBY_Audio.PlaySound("Fish" .. ran2);
    end
    if #self.goldlist > 12 then
        destroy(self.goldlist[1]);
        table.remove(self.goldlist, 1);
    end
    local obj = newobject(self.playerGoldChangeGroup:GetChild(0).gameObject);
    obj.transform:SetParent(self.playerGoldChangeGroup);
    obj.transform.localPosition = Vector3.New(0, 0, 0);
    obj.transform.localRotation = Quaternion.identity;
    obj.transform.localScale = Vector3.New(1, 1, 1);
    obj.transform:GetChild(0):GetComponent("RectTransform").sizeDelta = Vector2.New(15, 1);
    obj.gameObject:SetActive(true);
    local max = 1000;
    local h = (30 * 212 * magnificat) / max;
    Util.RunWinScore(1, h, h * Time.deltaTime, function(value)
        local v = math.ceil(value);
        if obj ~= nil then
            obj.transform:GetChild(0):GetComponent("RectTransform").sizeDelta = Vector2.New(15, v);
        end
    end):SetEase(DG.Tweening.Ease.Linear);
    table.insert(self.goldlist, obj.gameObject);
end

function WPBY_Player:OnJoinSuperPowrModel(isJoin)
    self.isSuperMode = isJoin;
    self:OnSetUserGunLevel(self.gunLevel);
end
function WPBY_Player:IsRobotLockFish()
    if self.robotLockFishCall ~= nil then
        coroutine.stop(self.robotLockFishCall);
        self.robotLockFishCall = nil;
    end
    self.robotLockFishCall = coroutine.start(function()
        self:IsRobotLockFishChange()
    end);
end
function WPBY_Player:IsRobotLockFishChange()
    while self.isRobot do
        if self.LockFish == nil or not self.LockFish.gameObject.activeSelf then
            local fish = WPBY_FishController.OnGetRandomLookFish(true);
            if fish ~= nil then
                self.LockFish = fish;
            end
            coroutine.wait(0.1);
        end
        if self.LockFish == nil then
            break ;
        end
        if self.LockFish:IsToSence() then
            self.LockFish = nil;
        end
        coroutine.wait(0.5);
    end
end

function WPBY_Player:SendBulltPackIsLock(fishId)
    if self.IsLock then
        log("锁定鱼：" .. fishId);
        local fish = WPBY_FishController.GetFish(fishId);
        if fish ~= nil then
            self.LockFish = fish;
            self.IsLock = true;
            self.dir = fish.transform.position;
            local buffer = ByteBuffer.New();
            buffer:WriteByte(self.data._9wChairID);
            buffer:WriteInt(fishId);
            Network.Send(MH.MDM_GF_GAME, WPBY_Network.SUB_C_PlayerLock, buffer, gameSocketNumber.GameSocket);
            WPBY_PlayerController.ContinuousFireByFish(true, self.data._9wChairID, fishId);
        end
    end
end
--锁定鱼
function WPBY_Player:SetLockFish(fishId)
    self.IsLock = true;
    if self.lockObj == nil then
        self.lockObj = newObject(WPBYEntry.lockNode:GetChild(0).gameObject);
        self.lockObj.transform:SetParent(WPBYEntry.lockNode);
        self.lockObj.transform.localPosition = Vector3.New(0, 0, 0);
        self.lockObj.transform.localScale = Vector3.New(1, 1, 1);
    end
    local fish = WPBY_FishController.GetFish(fishId);
    if fish ~= nil and fish:IsToSence() then
        self.LockFish = fish;
    else
        while true do
            fish = WPBY_FishController.OnGetRandomLookFish(false);
            if fish ~= nil and fish:IsToSence() then
                self.LockFish = fish;
                break ;
            end
            if not self.IsLock then
                break ;
            end
        end
    end
    if fish ~= nil then
        self.dir = fish.transform.position;
        self.lockObj.gameObject:SetActive(true);
    end
end