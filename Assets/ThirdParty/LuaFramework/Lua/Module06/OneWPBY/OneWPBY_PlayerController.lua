--万炮捕鱼 玩家管理
OneWPBY_PlayerController = {};
local self = OneWPBY_PlayerController;

self.playerList = {};
self.acceleration = 0.2;
self.isLock = false;
local Equal0Index=0
function OneWPBY_PlayerController.Init()
    self.isLock = false;
    self.playerList = {};
    for i = 1, OneWPBYEntry.playerGroup.childCount do
        OneWPBYEntry.playerGroup:GetChild(i - 1):Find("PaoTai/OnSit").gameObject:SetActive(false);
        OneWPBYEntry.playerGroup:GetChild(i - 1):Find("PaoTai/GunGroup").gameObject:SetActive(false);
        OneWPBYEntry.playerGroup:GetChild(i - 1):Find("PaoTai/ChangeGun").gameObject:SetActive(false);
        OneWPBYEntry.playerGroup:GetChild(i - 1):Find("PaoTai/Chip").gameObject:SetActive(false);
        OneWPBYEntry.playerGroup:GetChild(i - 1):Find("PaoTai/Gun_Function").gameObject:SetActive(false);
        OneWPBYEntry.playerGroup:GetChild(i - 1):Find("PaoTai/Level").gameObject:SetActive(false);
        OneWPBYEntry.playerGroup:GetChild(i - 1):Find("ChangeGoldGroup").gameObject:SetActive(false);
        OneWPBYEntry.playerGroup:GetChild(i - 1):Find("UserInfo").gameObject:SetActive(false);
        OneWPBYEntry.playerGroup:GetChild(i - 1):Find("SelfPos").gameObject:SetActive(false);
        OneWPBYEntry.playerGroup:GetChild(i - 1).gameObject:SetActive(false);
    end
end
--生成玩家信息
function OneWPBY_PlayerController.InitPlayer(userdata)
    local player = OneWPBY_Player:New();
    table.insert(self.playerList, player);
    player:InitPlayer(OneWPBYEntry.playerGroup:GetChild(userdata._9wChairID).gameObject);
    player:Enter(userdata);
end
--获取玩家
function OneWPBY_PlayerController.GetPlayer(chairId)
    for i = 1, #self.playerList do
        if self.playerList[i].data._9wChairID == chairId then
            return self.playerList[i];
        end
    end
end
--清除玩家
function OneWPBY_PlayerController.DestroyPlayer(pos)
    for i = 1, #self.playerList do
        if self.playerList[i].data._9wChairID == pos then
            self.playerList[i]:Leave();
            table.remove(self.playerList, i);
            return ;
        end
    end
end
--初始化炮台等级
function OneWPBY_PlayerController.SetPlayerGunLevel(levels)
    for i = 1, OneWPBY_DataConfig.GAME_PLAYER do
        local player = self.GetPlayer(i - 1);
        if player ~= nil then
            player:OnSetUserGunLevel(levels.GunLevel[i], levels.GunType[i]);
        end
    end
end
function OneWPBY_PlayerController.ClearBullet()
    for i = 1, #self.playerList do
        if #self.playerList[i] ~= nil then
            self.playerList[i]:CollectBullet();
        end
    end
end
--设置自己炮台子弹等级
function OneWPBY_PlayerController.OnInitBulltSeting(config)
    for i = 1, #self.playerList do
        if self.playerList[i] ~= nil then
            if self.playerList[i].isSelf then
                self.playerList[i]:OnInit(config);
            end
        end
    end
end

function OneWPBY_PlayerController.CollectBullet(bullet)
    for i = 1, #self.bulletList do
        if self.bulletList[i].bulletId == bullet.bulletId then
            bullet.transform:SetParent(OneWPBYEntry.bulletCache);
            bullet.transform.localPosition = Vector3.New(0, 0, 0);
            bullet.gameObject:SetActive(false);
            destroy(bullet.luaBehaviour);
            table.remove(self.bulletList, i);
        end
    end
end
function OneWPBY_PlayerController.ShootSelfBullet(pos, chairId)
    local selfPlayer = self.GetPlayer(chairId);
    if selfPlayer==nil then
        return;
    end
    if selfPlayer.goldNum < OneWPBY_Struct.CMD_S_CONFIG.bulletScore[selfPlayer.gungrade + 1] * (selfPlayer.gunLevel + 1) then
        if selfPlayer.isSelf then
            MessageBox.CreatGeneralTipsPanel("Not enough gold!");
            OneWPBYEntry.ControlLock(false);
            OneWPBYEntry.ControlContinue(false);
            return ;
        else
            logError("没有金币了"..chairId);
        end
    end
    local buffer = ByteBuffer.New();
    if OneWPBYEntry.isRevert then
        buffer:WriteFloat(-pos.x);
        buffer:WriteFloat(-pos.y);
    else
        buffer:WriteFloat(pos.x);
        buffer:WriteFloat(pos.y);
    end
    buffer:WriteInt(chairId);
    buffer:WriteInt(selfPlayer.bulletID);
    buffer:WriteByte(0);
    buffer:WriteByte(0);
    buffer:WriteByte(selfPlayer.gunLevel);
    buffer:WriteByte(selfPlayer.gungrade);
    buffer:WriteInt(OneWPBY_Struct.CMD_S_CONFIG.bulletScore[selfPlayer.gungrade + 1] * (selfPlayer.gunLevel + 1));
    Network.Send(MH.MDM_GF_GAME, OneWPBY_Network.SUB_C_PRESS_SHOOT, buffer, gameSocketNumber.GameSocket);
    if selfPlayer.isRobot then
        if selfPlayer.goldNum < OneWPBY_Struct.CMD_S_CONFIG.bulletScore[selfPlayer.gungrade + 1] * (selfPlayer.gunLevel + 1) then
            return;
        end
    end
    local pao = {};
    setmetatable(pao, { __index = OneWPBY_Struct.CMD_S_PlayerShoot });
    pao.wChairID = chairId;
    pao.x = pos.x;
    pao.y = pos.y;
    pao.level = selfPlayer.gunLevel;
    pao.type = selfPlayer.gungrade;
    pao.playCurScore = selfPlayer.goldNum - OneWPBY_Struct.CMD_S_CONFIG.bulletScore[selfPlayer.gungrade + 1] * (selfPlayer.gunLevel + 1);
    
    OneWPBY_PlayerController.ShootBullet(pao);
end
function OneWPBY_PlayerController.ShootBullet(bullet)
    for i = 1, #self.playerList do
        if self.playerList[i].data._9wChairID == bullet.wChairID then
            self.playerList[i]:Shoot(bullet);
        end
    end
end
--切换炮台模式
function OneWPBY_PlayerController.OnSetPlayerState(mode, wChairID)
    local player = self.GetPlayer(wChairID);
    if player == nil then
        return ;
    end
    local isJoin = mode == 1;
    player:OnJoinSuperPowrModel(isJoin);
end
function OneWPBY_PlayerController.OnLockFish(data)
    local fish = OneWPBY_FishController.GetFish(data.fishId);
    if fish ~= nil then
        local player = self.GetPlayer(data.chairId);
        player.LockFish = fish;
        player.IsLock = true;
    end
end
function OneWPBY_PlayerController.OnCancalLock(site_id)
    local player = self.GetPlayer(site_id);
    if player ~= nil then
        player.LockFish = nil;
        player.IsLock = false;
        OneWPBY_PlayerController.ContinuousFire(false, site_id, -1);
    end
end
function OneWPBY_PlayerController.ContinuousFireByFish(free, _sitID, fishId)
    local player = self.GetPlayer(_sitID);
    if player == nil then
        return ;
    end
    if free then
        if player.goldNum < OneWPBY_Struct.CMD_S_CONFIG.bulletScore[player.gungrade + 1] * (player.gunLevel + 1) then
            MessageBox.CreatGeneralTipsPanel("Not enough gold!");
            return ;
        end
        if fishId < 0 then
            return ;
        end
        player:StopContinueFire();
        player.LockFish = OneWPBY_FishController.GetFish(fishId);
        if (player.data._9wChairID == OneWPBYEntry.ChairID) then
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
function OneWPBY_PlayerController.ContinuousFireByPos(free, _sitID, vector)
    local player = self.GetPlayer(_sitID);
    if free then
        if player.goldNum < OneWPBY_Struct.CMD_S_CONFIG.bulletScore[player.gungrade + 1] * (player.gunLevel + 1) then
           -- MessageBox.CreatGeneralTipsPanel("Not enough gold!");
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
    player:RotatePaoTaiByPos(player.dir);
end