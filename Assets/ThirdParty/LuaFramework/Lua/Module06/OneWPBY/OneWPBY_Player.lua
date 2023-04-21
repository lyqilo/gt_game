OneWPBY_Player = {};

local self = OneWPBY_Player;
self.data = nil;
self.goldNum = 0;
self.gunLevel = 1;
self.gungrade = 1;

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
self.LevelNode = nil;

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
self.lockTag = nil;

self.continueState = 0;
self.continueTimer = 0;
self.continueDefaultTimer = 0.2;
self.continueMaxTimer = 0.2;
function OneWPBY_Player:New()
    local t = o or {};
    setmetatable(t, self);
    self.__index = self;
    return t;
end
function OneWPBY_Player:InitPlayer(obj)
    self.gameObject = obj;
    self.transform = obj.transform;
    self.luaBehaviour = self.transform:GetComponent("BaseBehaviour");
    if self.luaBehaviour == nil then
        self.luaBehaviour = Util.AddComponent("BaseBehaviour", self.gameObject);
        self.luaBehaviour:SetLuaTab(self, "OneWPBY_Player");
    end
    self.ptTrans = self.transform:Find("PaoTai");
    self.playerInfo = self.transform:Find("UserInfo");
    self.playerGoldChangeGroup = self.transform:Find("ChangeGoldGroup");
    self.playerGoldChangeGroup:GetChild(0).gameObject:SetActive(false);
    self.posTag = self.transform:Find("SelfPos");

    self.gunGroup = self.ptTrans:Find("GunGroup");
    self.gunPoint = self.gunGroup:Find("Gun");
    self.gunEffect = self.gunGroup:Find("GunEffect");
    self.gunEffect_Normal = self.gunEffect:Find("Normal")
    self.gunEffect_Super = self.gunEffect:Find("Super");
    self.shootPoint = self.gunGroup:Find("ShootPoint");
    self.changeGunBtn = self.ptTrans:Find("ChangeGun"):GetComponent("Button");
    self.onSitTag = self.ptTrans:Find("OnSit");
    self.chipNode = self.ptTrans:Find("Chip");
    self.chipNum = self.ptTrans:Find("Chip/Num"):GetComponent("TextMeshProUGUI");
    self.LevelNode = self.ptTrans:Find("Level");

    self.gun_Function = self.ptTrans:Find("Gun_Function");
    self.addBeiBtn = self.gun_Function:Find("Gun_Add"):GetComponent("Button");
    self.reduceBeiBtn = self.gun_Function:Find("Gun_Reduce"):GetComponent("Button");
    self.upgradeGunBtn = self.gun_Function:Find("Gun_UpGrade"):GetComponent("Button");
    self.maxGunBtn = self.gun_Function:Find("Gun_Max"):GetComponent("Button");

    self.userName = self.playerInfo:Find("NickName"):GetComponent("Text");
    self.userGold = self.playerInfo:Find("GoldNum"):GetComponent("TextMeshProUGUI");
    self.userName.gameObject:SetActive(false);
    self.lockObj = self.transform:Find("Lock/lockImage");
    self.bulletList = {};
    self.goldlist = {};
    self.continueMaxTimer = self.continueDefaultTimer;
end
--初始化玩家信息,玩家进入
function OneWPBY_Player:Enter(userdata)
    self.data = userdata;
    self.goldNum = self.data._7wGold;
    if OneWPBYEntry.ChairID == self.data._9wChairID then
        self.isSelf = true;
        self.onSitTag.gameObject:SetActive(true);
        self.changeGunBtn.gameObject:SetActive(true);
        self.posTag.gameObject:SetActive(true);
        self:SetWhite(self.transform);
    else
        self.isSelf = false;
        self.onSitTag.gameObject:SetActive(false);
        self.changeGunBtn.gameObject:SetActive(false);
        self.posTag.gameObject:SetActive(false);
        self:SetGray(self.transform);
    end
    self.gun_Function.gameObject:SetActive(false);
    self.playerGoldChangeGroup.gameObject:SetActive(true);
    self.gunGroup.gameObject:SetActive(true);
    for i = 1, self.playerGoldChangeGroup.childCount do
        self.playerGoldChangeGroup:GetChild(i - 1).gameObject:SetActive(false);
    end
    for i = 1, self.gunPoint.childCount do
        self.gunPoint:GetChild(i - 1).gameObject:SetActive(false);
    end
    self.ptTrans.gameObject:SetActive(true);
    self.LevelNode.gameObject:SetActive(true);
    self.gunLevel = 0;
    self.gungrade = 0;
    self.chipNode.gameObject:SetActive(true);
    self:OnSetUserGunLevel(self.gunLevel, self.gungrade);
    self.playerInfo.gameObject:SetActive(true);
    self.userName.text = self.data._2szNickName;
    self.userGold.text = OneWPBYEntry.ShowText(self.data._7wGold);
    self:AddListener();
    self.gameObject:SetActive(true);
    self.gunGroup.localRotation = Quaternion.identity;
end
function OneWPBY_Player:AddListener()
    self.addBeiBtn.onClick:RemoveAllListeners();
    self.addBeiBtn.onClick:AddListener(function()
        OneWPBY_Audio.PlaySound(OneWPBY_Audio.SoundList.ChangeGun);
        self:AddBet();
        self:SendChangeGunLevel();
    end);
    self.reduceBeiBtn.onClick:RemoveAllListeners();
    self.reduceBeiBtn.onClick:AddListener(function()
        OneWPBY_Audio.PlaySound(OneWPBY_Audio.SoundList.ChangeGun);
        self:ReduceBet();
        self:SendChangeGunLevel();
    end);
    self.maxGunBtn.onClick:RemoveAllListeners();
    self.maxGunBtn.onClick:AddListener(function()
        OneWPBY_Audio.PlaySound(OneWPBY_Audio.SoundList.ChangeGun);
        --最大炮
        self.gunLevel = 9;
        self:OnSetUserGunLevel(self.gunLevel, self.gungrade);
        self:SendChangeGunLevel();
    end);
    self.upgradeGunBtn.onClick:RemoveAllListeners();
    self.upgradeGunBtn.onClick:AddListener(function()
        OneWPBY_Audio.PlaySound(OneWPBY_Audio.SoundList.ChangeGun);
        --升级
        self.gungrade = self.gungrade + 1;
        if self.gungrade > 2 then
            self.gungrade = 0;
        end
        self.gunLevel = 0;
        self:OnSetUserGunLevel(self.gunLevel, self.gungrade);
        self:SendChangeGunLevel();
    end);
    self.changeGunBtn.onClick:RemoveAllListeners();
    self.changeGunBtn.onClick:AddListener(function()
        if self.gun_Function.gameObject.activeSelf then
            self.gun_Function.gameObject:SetActive(false);
        else
            self.gun_Function.gameObject:SetActive(true);
        end
    end);
end
function OneWPBY_Player:Update()
    self.timer = self.timer + Time.deltaTime;
    if self.timer >= self.updateTime then
        if #self.goldlist > 0 then
            destroy(self.goldlist[1]);
            table.remove(self.goldlist, 1);
        end
        self.timer = 0;
    end
    self:LockControl();
    self:ContinueControl();
end
function OneWPBY_Player:LockControl()
    if self.IsLock then
        if self.LockFish == nil or self.LockFish.isdead or not self.LockFish:IsToSence() then
            self.LockFish = nil;
            self.lockTag = nil;
            if self.lockObj.gameObject.activeSelf then
                self.lockObj.gameObject:SetActive(false);
            end
            if self.isRobot then
                self.LockFish = OneWPBY_FishController.OnGetRandomLookFish(true);
                if self.LockFish ~= nil then
                    self.lockTag = self.LockFish.transform:Find("Lock");
                    self:ContinueFire(0.5, 0.5);
                end
            end
            return ;
        else
            if not self.isRobot then
                if self.isSelf then
                    if not self.lockObj.gameObject.activeSelf and self.lockTag ~= nil then
                        self.lockObj.gameObject:SetActive(true);
                    end
                    if self.lockTag ~= nil then
                        self.lockObj.transform.position = self.lockTag.position;
                    end
                end
            end
            self.dir = self.LockFish.transform.position;
            self:RotatePaoTaiByPos(self.LockFish.transform.position);
        end
    end
end
function OneWPBY_Player:ContinueControl()
    if self.isContinue then
        if self.continueState == 1 then
            local ranFish = OneWPBY_FishController.OnGetRandomLookFish(true);
            if ranFish == nil then
                self.continueState = 0;
                return ;
            end
            self.continueTimer = self.continueTimer + Time.deltaTime;
            if self.continueTimer >= self.continueMaxTimer then
                self.continueTimer = 0;
                if self.dir == nil then
                    if self.data._9wChairID == 0 or self.data._9wChairID == 1 then
                        if OneWPBYEntry.ChairID <= 1 then
                            self.dir = self.gunGroup.transform.position + Vector3.New(0, 1, 0);
                        else
                            self.dir = self.gunGroup.transform.position + Vector3.New(0, -1, 0);
                        end
                    else
                        if OneWPBYEntry.ChairID > 1 then
                            self.dir = self.gunGroup.transform.position + Vector3.New(0, 1, 0);
                        else
                            self.dir = self.gunGroup.transform.position + Vector3.New(0, -1, 0);
                        end
                    end
                end
                if self.data._9wChairID == 0 then
                end
                OneWPBY_PlayerController.ShootSelfBullet(self.dir, self.data._9wChairID);
            end
        else
            local ranFish = OneWPBY_FishController.OnGetRandomLookFish(true);
            if ranFish ~= nil then
                if self.isRobot then
                    self:ContinueFire(0.5, 0.5);
                else
                    self:ContinueFire(OneWPBY_PlayerController.acceleration, OneWPBY_PlayerController.acceleration);
                end
            end
        end
    end
end
function OneWPBY_Player:ContinueFire(delayTime, time)
    if self.repeatTweener ~= nil then
        self.repeatTweener:Kill();
        self.repeatTweener = nil;
    end
    self.continueState = 0;
    self.continueMaxTimer = time;
    self.continueTimer = 0;
    if self.IsLock and self.LockFish ~= nil then
        self.dir = self.LockFish.transform.position;
    end
    local fish = OneWPBY_FishController.OnGetRandomLookFish(true);
    if fish ~= nil then
        self.continueState = 1;
    end
end
function OneWPBY_Player:StopContinueFire()
    if self.repeatTweener ~= nil then
        self.repeatTweener:Kill();
        self.repeatTweener = nil;
    end
    self.continueState = 0;
    self.continueMaxTimer = self.continueDefaultTimer;
    self.continueTimer = 0;
end
function OneWPBY_Player:SetLockState(value)
    self.IsLock = value;
    if not self.IsLock then
        self.LockFish = nil;
        self.lockObj.gameObject:SetActive(false);
    end
end
function OneWPBY_Player:AddBet()
    self.gunLevel = self.gunLevel + 1;
    if self.gunLevel >= 10 then
        self.gunLevel = 0;
    end
    self:OnSetUserGunLevel(self.gunLevel, self.gungrade);
end
function OneWPBY_Player:ReduceBet()
    self.gunLevel = self.gunLevel - 1;
    if self.gunLevel < 0 then
        self.gunLevel = 9;
    end
    self:OnSetUserGunLevel(self.gunLevel, self.gungrade);
end
function OneWPBY_Player:SendChangeGunLevel()
    local buffer = ByteBuffer.New();
    buffer:WriteInt(self.data._9wChairID);
    buffer:WriteByte(self.gungrade);
    buffer:WriteByte(self.gunLevel);
    Network.Send(MH.MDM_GF_GAME, OneWPBY_Network.SUB_C_CHANGEBULLETLEVEL, buffer, gameSocketNumber.GameSocket);
end
function OneWPBY_Player:ChangePTLevel(changeLevel)
    self.gungrade = changeLevel.cbGunType;
    self.gunLevel = changeLevel.cbGunLevel;
    self:OnSetUserGunLevel(self.gunLevel, self.gungrade);

end
function OneWPBY_Player:OnSetUserGunLevel(level, grade)
    --初始化炮台
    self.gunLevel = level;
    self.gungrade = grade;
    for i = 0, self.gunPoint.childCount - 1 do
        if grade == i then
            self.gunPoint:GetChild(i).gameObject:SetActive(true);
            self.TheGun = self.gunPoint:GetChild(i);
            self.LevelNode:GetChild(i).gameObject:SetActive(true);
        else
            self.gunPoint:GetChild(i).gameObject:SetActive(false);
            self.LevelNode:GetChild(i).gameObject:SetActive(false);
        end
    end
    self:SetPaoTaiChip();
end
function OneWPBY_Player:SetPaoTaiChip()
    if #OneWPBY_Struct.CMD_S_CONFIG.bulletScore > 0 then
        self.chipNum.text = OneWPBYEntry.ShowText(OneWPBY_Struct.CMD_S_CONFIG.bulletScore[self.gungrade + 1] * (self.gunLevel + 1));
    end
end
--旋转炮台通过角度
function OneWPBY_Player:RotatePaoTaiByAngle(angle)
    self.gunGroup.localRotation = Vector3.New(0, 0, angle);
end
function OneWPBY_Player:Shoot(bullet)
    self:OnChangeUserScure(bullet.playCurScore, false);
    --self.userGold.text = tostring(bullet.playCurScore);
    local pos = Vector3.New(bullet.x, bullet.y, 0);
    self:RotatePaoTaiByPos(pos);
    --self:CreateBulltEffect();
    self:CreateBullet(bullet);
end
function OneWPBY_Player:CreateBulltEffect()
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
    OneWPBYEntry.DelayCall(0.3, function()
        eff.gameObject:SetActive(false);
    end);
end
function OneWPBY_Player:CreateBullet(bullet)
    if self.bulletID >= OneWPBY_DataConfig.MAX_BULLET then
        self.bulletID = 1;
    else
        self.bulletID = self.bulletID + 1;
    end
    self:OnCreateBullet(self.bulletID, bullet);
end
function OneWPBY_Player:OnCreateBullet(bulletid, bulletdata)
    if not IsNil(self.TheGun) then
        self.TheGun.transform:GetComponent("Animator"):SetTrigger("Stop");
        self.TheGun.transform:GetComponent("Animator"):SetTrigger("Fire");
    end
    local bullet = nil;
    if self.isSelf then
        bullet = OneWPBYEntry.bulletCache:Find("SelfBullt_" .. (self.gungrade + 1));
    else
        bullet = OneWPBYEntry.bulletCache:Find("Bullt_" .. (self.gungrade + 1));
    end
    if bullet == nil then
        if self.isSelf then
            bullet = newobject(OneWPBYEntry.bulletPool:Find("SelfBullt_" .. (self.gungrade + 1)).gameObject).transform;
        else
            bullet = newobject(OneWPBYEntry.bulletPool:Find("Bullt_" .. (self.gungrade + 1)).gameObject).transform;
        end
    end
    bullet:SetParent(self.shootPoint);
    bullet.localPosition = Vector3.New(0, 0, 0);
    bullet.localRotation = Quaternion.identity;
    bullet:SetParent(OneWPBYEntry.bulletScene);
    bullet.localScale = Vector3.New(1, 1, 1);
    if self.isSelf then
        bullet.gameObject.name = "SelfBullt_" .. (self.gungrade + 1);
    else
        bullet.gameObject.name = "Bullt_" .. (self.gungrade + 1);
    end
    local _bullet = OneWPBY_Bullet:New();
    _bullet.isLock = self.IsLock;
    _bullet.lockFish = self.LockFish;
    _bullet:Init(bullet, bulletid, bulletdata);
    table.insert(self.bulletList, _bullet);
    OneWPBY_Audio.PlayFire();
end
--通过点击位置旋转炮塔
function OneWPBY_Player:RotatePaoTaiByPos(pos)
    local direction = pos - self.gunGroup.transform.position;
    local angle = 360 - Mathf.Atan2(direction.x, direction.y) * Mathf.Rad2Deg;
    self.gunGroup.transform.eulerAngles = Vector3.New(0, 0, angle);
end
function OneWPBY_Player:SetGray(parent)
    if parent == nil then
        return ;
    end
    local img = parent:GetComponent("Image");
    if img ~= nil then
        img.color = Color.New(0.4, 0.4, 0.4, img.color.a);
    end
    for i = 1, parent.childCount do
        self:SetGray(parent:GetChild(i - 1));
    end
end
function OneWPBY_Player:SetWhite(parent)
    if parent == nil then
        return ;
    end
    local img = parent:GetComponent("Image");
    if img ~= nil then
        img.color = Color.New(1, 1, 1, img.color.a);
    end
    for i = 1, parent.childCount do
        self:SetWhite(parent:GetChild(i - 1));
    end
end
--玩家离开
function OneWPBY_Player:Leave()
    self.transform.gameObject:SetActive(false);
    self.onSitTag.gameObject:SetActive(false);
    self.gunGroup.gameObject:SetActive(false);
    self.reduceBeiBtn.gameObject:SetActive(false);
    self.addBeiBtn.gameObject:SetActive(false);
    self.playerGoldChangeGroup.gameObject:SetActive(false);
    self.playerInfo.gameObject:SetActive(false);
    self.posTag.gameObject:SetActive(false);
    self.changeGunBtn.gameObject:SetActive(true);
    self.LevelNode.gameObject:SetActive(false);
    self.chipNode.gameObject:SetActive(false);
    self.chipNum.text = "";
    self.lockObj.gameObject:SetActive(false);
    self.LockFish = nil;
    self.IsLock = false;
    self.isRobot = false;
    self.isContinue = false;
    self.isThumb = false;
    self.isSuperMode = false;
    self.TheGun = nil;
    self.transform = nil;
    self.gameObject = nil;
    destroy(self.luaBehaviour);
    self.luaBehaviour = nil;
    self.dir = nil;
    self:CollectBullet();
    self:StopContinueFire();
    if self.robotLockFishCall ~= nil then
        coroutine.stop(self.robotLockFishCall);
        self.robotLockFishCall = nil;
    end
    if self.repeatTweener ~= nil then
        self.repeatTweener:Kill();
        self.repeatTweener = nil;
    end
end
function OneWPBY_Player:CollectBullet()
    for i = #self.bulletList, 1, -1 do
        self.bulletList[i]:Collect();
    end
end
--设置炮台值
function OneWPBY_Player:OnInit(config)
    self.ptConfig = config;
end
function OneWPBY_Player:OnChangeUserScure(change, isAdd)
    if isAdd then
        self.goldNum = self.goldNum + change;
        self.userGold.text = OneWPBYEntry.ShowText(self.goldNum);
        return ;
    end
    if change >= 0 then
        self.goldNum = change;
        self.userGold.text = OneWPBYEntry.ShowText(self.goldNum);
    else
        self.goldNum = self.goldNum + change;
        self.userGold.text = OneWPBYEntry.ShowText(self.goldNum);
    end
end
--显示金币柱
function OneWPBY_Player:OnShowGold(gold, fishId)
    local magnificat = OneWPBYEntry.GetMagnificationToFishID(fishId);
    if #self.goldlist >= 3 then
        destroy(self.goldlist[1]);
        table.remove(self.goldlist, 1);
    end
    local obj = newobject(self.playerGoldChangeGroup:GetChild(0).gameObject);
    obj.transform:SetParent(self.playerGoldChangeGroup);
    obj.transform.localPosition = Vector3.New(0, 0, 0);
    obj.transform.localRotation = Quaternion.identity;
    obj.transform.localScale = Vector3.New(1, 1, 1);
    obj.transform:Find("Slider"):GetComponent("Slider").value = 0;
    obj.gameObject:SetActive(true);
    local max = 1000;
    local h = (30 * 212 * magnificat) / max;
    obj.transform:Find("Slider/Handle Slide Area/Handle/Num"):GetComponent("TextMeshProUGUI").text = "";
    Util.RunWinScore(0, magnificat / 30, 0.5, function(value)
        obj.transform:Find("Slider"):GetComponent("Slider").value = value;
    end):SetEase(DG.Tweening.Ease.Linear);
    table.insert(self.goldlist, obj.gameObject);
end

function OneWPBY_Player:OnJoinSuperPowrModel(isJoin)
    self.isSuperMode = isJoin;
    self:OnSetUserGunLevel(self.gunLevel);
end
function OneWPBY_Player:IsRobotLockFish()
    --if self.robotLockFishCall ~= nil then
    --    coroutine.stop(self.robotLockFishCall);
    --    self.robotLockFishCall = nil;
    --end
    --self.robotLockFishCall = coroutine.start(function()
    --    self:IsRobotLockFishChange()
    --end);
end
function OneWPBY_Player:IsRobotLockFishChange()
    while self.isRobot do
        if self.LockFish == nil or not self.LockFish:IsToSence() then
            local fish = OneWPBY_FishController.OnGetRandomLookFish(true);
            if fish ~= nil then
                self.LockFish = fish;
            end
            coroutine.wait(0.1);
        end
        if self.LockFish ~= nil and not self.LockFish:IsToSence() then
            self.LockFish = nil;
        end
        coroutine.wait(0.5);
    end
end

function OneWPBY_Player:SendBulltPackIsLock(fishId)
    if self.IsLock then
        log("锁定鱼：" .. fishId);
        local fish = OneWPBY_FishController.GetFish(fishId);
        if fish ~= nil then
            self.LockFish = fish;
            self.lockTag = self.LockFish.transform:Find("Lock");
            self.IsLock = true;
            self.dir = fish.transform.position;
            local buffer = ByteBuffer.New();
            buffer:WriteByte(self.data._9wChairID);
            buffer:WriteInt(fishId);
            Network.Send(MH.MDM_GF_GAME, OneWPBY_Network.SUB_C_PlayerLock, buffer, gameSocketNumber.GameSocket);
        end
    end
end
--锁定鱼
function OneWPBY_Player:SetLockFish(fishId)
    self.IsLock = true;
    if self.lockObj == nil then
        self.lockObj = newObject(OneWPBYEntry.lockNode:GetChild(0).gameObject);
        self.lockObj.transform:SetParent(OneWPBYEntry.lockNode);
        self.lockObj.transform.localPosition = Vector3.New(0, 0, 0);
        self.lockObj.transform.localScale = Vector3.New(1, 1, 1);
    end
    local fish = OneWPBY_FishController.GetFish(fishId);
    if fish ~= nil and fish:IsToSence() then
        self.LockFish = fish;
        self.lockTag = self.LockFish.transform:Find("Lock");
    else
        while true do
            fish = OneWPBY_FishController.OnGetRandomLookFish(false);
            if fish ~= nil and fish:IsToSence() then
                self.LockFish = fish;
                self.lockTag = self.LockFish.transform:Find("Lock");
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