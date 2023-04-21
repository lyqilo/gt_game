--万炮捕鱼 玩家管理
WPBY_PlayerController = {};
local self = WPBY_PlayerController;

self.playerList = {};
self.acceleration = 0.3;
self.isLock = false;
function WPBY_PlayerController.Init()
    self.playerList = {};
    for i = 1, WPBYEntry.playerGroup.childCount do
        WPBYEntry.playerGroup:GetChild(i - 1):Find("PaoTai/OnSit").gameObject:SetActive(false);
        WPBYEntry.playerGroup:GetChild(i - 1):Find("PaoTai/GunGroup").gameObject:SetActive(false);
        WPBYEntry.playerGroup:GetChild(i - 1):Find("PaoTai/Reduce").gameObject:SetActive(false);
        WPBYEntry.playerGroup:GetChild(i - 1):Find("PaoTai/Add").gameObject:SetActive(false);
        WPBYEntry.playerGroup:GetChild(i - 1):Find("ChangeGoldGroup").gameObject:SetActive(false);
        WPBYEntry.playerGroup:GetChild(i - 1):Find("UserInfo").gameObject:SetActive(false);
        WPBYEntry.playerGroup:GetChild(i - 1):Find("SelfPos").gameObject:SetActive(false);
    end
end
--生成玩家信息
function WPBY_PlayerController.InitPlayer(userdata)
    local player = WPBY_Player:New();
    table.insert(self.playerList, player);
    player:InitPlayer(WPBYEntry.playerGroup:GetChild(userdata._9wChairID).gameObject);
    player:Enter(userdata);
end
--获取玩家
function WPBY_PlayerController.GetPlayer(chairId)
    for i = 1, #self.playerList do
        if self.playerList[i].data._9wChairID == chairId then
            return self.playerList[i];
        end
    end
end
--清除玩家
function WPBY_PlayerController.DestroyPlayer(pos)
    for i = 1, #self.playerList do
        if self.playerList[i].data._9wChairID == pos then
            self.playerList[i]:Leave();
            destroy(self.playerList[i].luaBehaviour);
            table.remove(self.playerList, i);
            return ;
        end
    end
end
--初始化炮台等级
function WPBY_PlayerController.SetPlayerGunLevel(levels)
    for i = 1, #levels do
        if levels[i] < 10 then
            for j = 1, #self.playerList do
                if self.playerList[j].data._9wChairID == i - 1 then
                    self.playerList[j]:OnSetUserGunLevel(levels[i]);
                end
            end
        end
    end
end
function WPBY_PlayerController.ClearBullet()
    for i = 1, #self.playerList do
        if #self.playerList[i] ~= nil then
            self.playerList[i]:CollectBullet();
        end
    end
end
--设置自己炮台子弹等级
function WPBY_PlayerController.OnInitBulltSeting(config)
    for i = 1, #self.playerList do
        if self.playerList[i] ~= nil then
            if self.playerList[i].isSelf then
                self.playerList[i]:OnInit(config);
            end
        end
    end
end

function WPBY_PlayerController.CollectBullet(bullet)
    for i = 1, #self.bulletList do
        if self.bulletList[i].bulletId == bullet.bulletId then
            bullet.transform:SetParent(WPBYEntry.bulletCache);
            bullet.transform.localPosition = Vector3.New(0, 0, 0);
            bullet.gameObject:SetActive(false);
            destroy(bullet.luaBehaviour);
            table.remove(self.bulletList, i);
        end
    end
end
function WPBY_PlayerController.ShootSelfBullet(pos,chairId)
    local selfPlayer = self.GetPlayer(chairId);
    if selfPlayer.goldNum < WPBY_Struct.CMD_S_CONFIG.bulletScore[selfPlayer.gunLevel + 1] then
        MessageBox.CreatGeneralTipsPanel("Insufficient gold coins!");
        return ;
    end
    local buffer = ByteBuffer.New();
    buffer:WriteFloat(pos.x);
    buffer:WriteFloat(pos.y);
    buffer:WriteInt(chairId);
    buffer:WriteInt(selfPlayer.bulletID);
    buffer:WriteByte(0);
    buffer:WriteByte(0);
    buffer:WriteByte(selfPlayer.gunLevel);
    buffer:WriteInt(WPBY_Struct.CMD_S_CONFIG.bulletScore[selfPlayer.gunLevel + 1]);
    Network.Send(MH.MDM_GF_GAME, WPBY_Network.SUB_C_PRESS_SHOOT, buffer, gameSocketNumber.GameSocket);
    local pao = {};
    setmetatable(pao, { __index = WPBY_Struct.CMD_S_PlayerShoot });
    pao.wChairID = chairId;
    pao.x = pos.x;
    pao.y = pos.y;
    pao.level = selfPlayer.gunLevel;
    pao.playCurScore = selfPlayer.goldNum - WPBY_Struct.CMD_S_CONFIG.bulletScore[selfPlayer.gunLevel + 1];
    WPBY_PlayerController.ShootBullet(pao);
end
function WPBY_PlayerController.ShootBullet(bullet)
    for i = 1, #self.playerList do
        if self.playerList[i].data._9wChairID == bullet.wChairID then
            self.playerList[i]:Shoot(bullet);
        end
    end
end
--切换炮台模式
function WPBY_PlayerController.OnSetPlayerState(mode, wChairID)
    local player = self.GetPlayer(wChairID);
    if player == nil then
        return ;
    end
    local isJoin = mode == 1;
    player:OnJoinSuperPowrModel(isJoin);
end
function WPBY_PlayerController.OnLockFish(data)
    local fish = WPBY_FishController.GetFish(data.fishId);
    if fish ~= nil then
        local player = self.GetPlayer(data.chairId);
        player.LockFish = fish;
        player.IsLock = true;
    end
end
function WPBY_PlayerController.OnCancalLock(site_id)
    local player = self.GetPlayer(site_id);
    if player ~= nil then
        player.LockFish = nil;
        player.IsLock = false;
        WPBY_PlayerController.ContinuousFire(false, site_id, -1);
    end
end
function WPBY_PlayerController.ContinuousFireByFish(free, _sitID, fishId)
    local player = self.GetPlayer(_sitID);
    if player == nil then
        return ;
    end
    if free then
        if player.goldNum < WPBY_Struct.CMD_S_CONFIG.bulletScore[player.gunLevel + 1] then
            MessageBox.CreatGeneralTipsPanel("Insufficient gold coins!");
            return ;
        end
        if fishId < 0 then
            return ;
        end
        player:StopContinueFire();
        player.LockFish = WPBY_FishController.GetFish(fishId);
        if (player.data._9wChairID == WPBYEntry.ChairID) then
            player:ContinueFire(self.acceleration, self.acceleration);
        else
            player:StopContinueFire();
            player:ContinueFire(0.3, 0.3);
        end
    else
        player:StopContinueFire();
        player.isThumb = false;
    end
end
function WPBY_PlayerController.ContinuousFireByPos(free, _sitID, vector)
    local player = self.GetPlayer(_sitID);
    if free then
        if player.goldNum < WPBY_Struct.CMD_S_CONFIG.bulletScore[player.gunLevel + 1] then
            MessageBox.CreatGeneralTipsPanel("Insufficient gold coins!");
            return ;
        end
        -- Debug.LogError ("鼠标持续按下,ContinuousAddBullt"+_sitID +"持续开火速度"+acceleration );
        player.isThumb = true;
        player:ContinueFire(0, self.acceleration);
    else
        player:StopContinueFire();
        player.isThumb = false;
    end
    player.dir = vector;
end