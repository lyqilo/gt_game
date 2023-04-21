local _CClientSession=class("_CClientSession");

function _CClientSession:ctor()
    self._checkOffLineTime = 0;
    self._offlineTime = 0;
    self.isReloadGame = true;
end

--收到场景消息播放bgm
function _CClientSession:OnSceneInfoHandler(wMaiID, wSubID, buffer, wSize)
    G_GlobalGame:DispatchEventByStringKey("NotifyEnterGame");
end

function _CClientSession:OnMessageHandler(wMaiID, wSubID, buffer, wSize)
    local CommandDefine = G_GlobalGame.GameCommandDefine.SC_CMD;
    local cmd = tonumber(string.sub(wSubID, string.len(tostring(wMaiID)) + 1, string.len(tostring(wSubID) ) ) );
    if self.isReloadGame then
        return ;
    end
    if (cmd == CommandDefine.Game_Config) then  
        self:_notifyGameConfig(buffer);
    elseif (cmd == CommandDefine.Fish_Trace) then  
        self:_createFishs(buffer,wSize);
    elseif (cmd == CommandDefine.Exchange_FishGold) then 
        self:_exchangeFishGold(buffer);
    elseif (cmd == CommandDefine.User_Fire)  then 
        self:_notifyUserFire(buffer);
    elseif (cmd == CommandDefine.Catch_Fish) then 
        self:_catchFish(buffer)
    elseif (cmd == CommandDefine.Power_Bullet_Reached) then 
        self:_notifyEnergyTimeOut(buffer);
    elseif (cmd == CommandDefine.LockTimeOut) then  

    elseif (cmd == CommandDefine.Catch_Special) then 
        self:_catchCauseFish(buffer);
    elseif (cmd == CommandDefine.Notify_Catch_Special) then 
        self:_catchGroupFish(buffer);
    elseif (cmd == CommandDefine.Notify_Catch_LK) then 
        self:_hitLK(buffer);
    elseif (cmd == CommandDefine.Notify_Switch_Scene) then 
        self:_switchScene(buffer);
    elseif (cmd == CommandDefine.Response_Change_FishGold) then 

    end
end

function _CClientSession:_notifyGameConfig(_buffer)
    local exchange_ratio_userscore  = _buffer:ReadInt32();
    local exchange_ratio_fishscore  = _buffer:ReadInt32();
    local exchange_count =  _buffer:ReadInt32();
    local GameConfig = G_GlobalGame.GameConfig;
    GameConfig.SceneConfig.iMinBulletMultiple  = _buffer:ReadInt32();
    GameConfig.SceneConfig.iMaxBulletMultiple  = _buffer:ReadInt32();

    local bomb_range_width = _buffer:ReadInt32();
    local bomb_range_height = _buffer:ReadInt32();
    local wUnk = _buffer:ReadUInt16();
    local FishKindMax = G_GlobalGame.ConstDefine.C_S_FISH_KIND_MAX;
    for i=1,FishKindMax do
        GameConfig.FishInfo[i-1].iMultiple = _buffer:ReadInt32();
    end
    for i=1,FishKindMax do
        GameConfig.FishInfo[i-1].iSpeed = _buffer:ReadInt32();
    end
    for i=1,FishKindMax do
        GameConfig.FishInfo[i-1].iWidth = _buffer:ReadInt32();
    end
    for i=1,FishKindMax do
        GameConfig.FishInfo[i-1].iHeight = _buffer:ReadInt32();
    end
    for i=1,FishKindMax do
        GameConfig.FishInfo[i-1].iRadius = _buffer:ReadInt32();
    end

    local BulletMaxType = G_GlobalGame.ConstDefine.C_S_BULLET_KIND_MAX;
    for i=1,BulletMaxType do
        GameConfig.Bullet[i-1].iSpeed = _buffer:ReadInt32();
    end
    for i=1,BulletMaxType do
        GameConfig.Bullet[i-1].iNetRadius = _buffer:ReadInt32();
    end

    G_GlobalGame:DispatchEventByStringKey("GameConfig",nil);
end

local CREATE_FISH_MESSAGE_SIZE = 58;
local text=1;
function _CClientSession:_createFishs(_buffer,_wSize)
  --  local fishCount = _wSize/CREATE_FISH_MESSAGE_SIZE;
    local _fish={};
  --  for i=1,fishCount  do
        _fish.point={};
        for j=1,5 do
            _fish.point[j] ={};
            _fish.point[j].x = _buffer:ReadInt32();
            _fish.point[j].y = _buffer:ReadInt32();
			_buffer:ReadInt32();
        end
        _fish.wUnk = _buffer:ReadUInt16();
        _fish.initCount = _buffer:ReadInt32();
        _fish.fishKind = _buffer:ReadInt32();
        _fish.fishId = _buffer:ReadInt32();
        _fish.traceType = _buffer:ReadInt32();

        G_GlobalGame:DispatchEventByStringKey("CreateFish",_fish);

   -- end
end

function _CClientSession:_exchangeFishGold(_buffer)
    local chairId = _buffer:ReadUInt16();
    local addFishGold = int64.tonum2(_buffer:ReadInt64());
    local fishGold = int64.tonum2(_buffer:ReadInt64());
    local data = {chairId = chairId, addFishGold = addFishGold ,fishGold = fishGold};
    G_GlobalGame:DispatchEventByStringKey("ExchangeFishGold",data);
end

function _CClientSession:_notifyUserFire(_buffer)
	--logError("通知开火--------------------")
    local fire = {};
    fire.bulletKind        = _buffer:ReadInt32();
    fire.bulletId          = _buffer:ReadInt32();
    fire.chairId           = _buffer:ReadUInt16();
    fire.androidChairId    = _buffer:ReadUInt16();
    fire.wUnk              = _buffer:ReadUInt16();
    fire.angle             = _buffer:ReadFloat();
    fire.bulletMultiple    = _buffer:ReadInt32();
    fire.lockFishId        = _buffer:ReadInt32();
    fire.fishGold          = int64.tonum2(_buffer:ReadInt64());
	--logError(fire.bulletKind.."--"..fire.bulletId .."--"..fire.bulletMultiple )
    G_GlobalGame:DispatchEventByStringKey("UserFire",fire);
end

function _CClientSession:_catchFish(_buffer)
    local fish = {};
    fish.chairId = _buffer:ReadUInt16();
    fish.fishId  = _buffer:ReadInt32();
    fish.wUnk    = _buffer:ReadUInt16();
    fish.fishKind= _buffer:ReadInt32();
    fish.bulletIon= _buffer:ReadByte();
    fish.fishGold= int64.tonum2(_buffer:ReadInt64());
	--logErrorTable(fish)
    G_GlobalGame:DispatchEventByStringKey("CatchFish",fish);
end

function _CClientSession:_catchCauseFish(_buffer)
    local fish = {};
    fish.chairId = _buffer:ReadUInt16();
    fish.wunk    = _buffer:ReadUInt16();
    fish.fishId  = _buffer:ReadInt32();
    G_GlobalGame:DispatchEventByStringKey("CatchCauseFish",fish);
end

function _CClientSession:_catchGroupFish(_buffer)
    local groupFish = {};
    groupFish.chairId       = _buffer:ReadUInt16();
    groupFish.fishId        = _buffer:ReadInt32();
    groupFish.fishGold      = int64.tonum2(_buffer:ReadInt64());
    groupFish.catchFishCount= _buffer:ReadInt32();
    groupFish.catchFishIds  = {};
    for i=1,groupFish.catchFishCount do
        groupFish.catchFishIds[i] = _buffer:ReadInt32();
    end
    G_GlobalGame:DispatchEventByStringKey("CatchGroupFish",groupFish);
end

function _CClientSession:_notifyEnergyTimeOut(_buffer)
    local info = {};
    info.chairId       = _buffer:ReadUInt16();
    G_GlobalGame:DispatchEventByStringKey("EnergyTimeOut",info);
end

function _CClientSession:_hitLK(_buffer)
    local lk = {};
    lk.chairId      = _buffer:ReadUInt16();
    lk.fishId       = _buffer:ReadInt32();
    lk.fishMultiple = _buffer:ReadInt32();
    G_GlobalGame:DispatchEventByStringKey("HitLK",lk);
end

function _CClientSession:_switchScene(_buffer)
	--error("======================================鱼潮来了============================================")
	--error("======================================鱼潮来了============================================")
	--error("======================================鱼潮来了============================================")
    local sceneInfo = {};
    sceneInfo.sceneKind     = _buffer:ReadInt32();
    sceneInfo.fishPartCount = _buffer:ReadInt32();
	--error("sceneKind="..sceneInfo.sceneKind )
	--error("fishPartCount="..sceneInfo.fishPartCount )
    sceneInfo.fishGroupParts={};
    for i=1,sceneInfo.fishPartCount do
		--error("====================第几部分鱼==================="..i)
        local groupPart = {};
        sceneInfo.fishGroupParts[i] = groupPart;
        groupPart.fishCount = _buffer:ReadInt32();
		--error("fishCount="..groupPart.fishCount )		
        groupPart.fishes  ={};
        for j=1,groupPart.fishCount do
            local fish = {};
            groupPart.fishes[j] = fish;
            fish.fishType = _buffer:ReadInt32();
            fish.fishId = _buffer:ReadInt32();
			--error("fishType="..fish.fishType.."   fishId="..fish.fishId )	
        end
    end
    G_GlobalGame:DispatchEventByStringKey("SwitchScene",sceneInfo);
end

function _CClientSession:SendLogin()
    local bf = ByteBuffer.New();
    bf:WriteUInt32(0);
    bf:WriteUInt32(0);
    bf:WriteUInt32(SCPlayerInfo._01dwUser_Id);
    bf:WriteBytes(DataSize.String33, SCPlayerInfo._06wPassword);
    bf:WriteBytes(100,Opcodes);
    bf:WriteByte(0);
    bf:WriteByte(0);
    Network.Send(MH.MDM_GR_LOGON, 3, bf, gameSocketNumber.GameSocket);
end

function _CClientSession:SendAddScore()
    local bf = ByteBuffer.New();
    bf:WriteUInt16(0);
    bf:WriteByte(1);
    Network.Send(MH.MDM_GF_GAME, G_GlobalGame.GameCommandDefine.CS_CMD.ExchangeFishGold, bf, gameSocketNumber.GameSocket);
end

function _CClientSession:SendRemoveScore()
    local bf = ByteBuffer.New();
    bf:WriteUInt16(0);
    bf:WriteByte(0);
    Network.Send(MH.MDM_GF_GAME, G_GlobalGame.GameCommandDefine.CS_CMD.ExchangeFishGold, bf, gameSocketNumber.GameSocket);
end


function _CClientSession:SendPao(_bulletType,_angle,_bulletMultiple,_lockFishId)
	G_GlobalGame.bulletId=G_GlobalGame.bulletId+1
	--logError("客户端发炮=".._bulletMultiple)
    local bf = ByteBuffer.New();
    bf:WriteUInt32(G_GlobalGame:GetGameRunTime());
    bf:WriteInt(_bulletType);
    bf:WriteFloat(_angle);
    bf:WriteUInt16(G_GlobalGame.GameCommandDefine.CMD_CODE.SendPaoCode);
    bf:WriteInt(_bulletMultiple);
    bf:WriteInt(_lockFishId);
	--logError("_angle=".._angle)
    Network.Send(MH.MDM_GF_GAME, G_GlobalGame.GameCommandDefine.CS_CMD.UserFire, bf, gameSocketNumber.GameSocket);
end

function _CClientSession:SendCatchFish(_chairId,_fishId,_fishMultiple,_bulletType,_bulletId,_bulletMultiple)
	--logError("鱼的ID=".._fishId.." 鱼的倍数=".._fishMultiple.." 子弹ID=".._bulletId.." 子弹倍数=".._bulletMultiple)
    local bf = ByteBuffer.New();
    bf:WriteUInt16(_chairId);
    bf:WriteInt(_fishId);
    bf:WriteUInt16(G_GlobalGame.GameCommandDefine.CMD_CODE.CatchFishCode);
    bf:WriteInt(_fishMultiple);
    bf:WriteInt(_bulletType);
    bf:WriteInt(_bulletId);
    bf:WriteInt(_bulletMultiple);
    Network.Send(MH.MDM_GF_GAME, G_GlobalGame.GameCommandDefine.CS_CMD.CacheFish, bf, gameSocketNumber.GameSocket);
end

function _CClientSession:SendHitLikui(_fishId)
    local bf = ByteBuffer.New();
    bf:WriteUInt16(0);
    bf:WriteInt(_fishId);
    Network.Send(MH.MDM_GF_GAME, G_GlobalGame.GameCommandDefine.CS_CMD.ShotLiKui, bf, gameSocketNumber.GameSocket);
end

function _CClientSession:SendCatchSweepFish(_chairId,_fishId,_vec)
    local bf = ByteBuffer.New();
    bf:WriteUInt16(_chairId);
    bf:WriteInt(_fishId);
    bf:WriteUInt16(0);
    bf:WriteInt(_vec:size());
    local fish
    for i=1,300 do
        fish = _vec:get(i);
        if fish==nil then
            bf:WriteInt(0);
        else
            bf:WriteInt(fish:FishID());
        end
    end
    Network.Send(MH.MDM_GF_GAME, G_GlobalGame.GameCommandDefine.CS_CMD.CatchFishGroup, bf, gameSocketNumber.GameSocket);
end

function _CClientSession:NewHandOver()
    local bf = ByteBuffer.New();
    bf:WriteUInt32(G_GlobalGame.ConstDefine.GAME_ID);
    Network.Send(MH.MDM_3D_PERSONAL_INFO, MH.SUB_3D_CS_USER_NEW_HAND_FINISH, bf, gameSocketNumber.HallSocket);
end

function _CClientSession:OnLoginOver()
    local bf = ByteBuffer.New();
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, bf, gameSocketNumber.GameSocket);
end

function _CClientSession:OnLoginSuccess()
    --
    G_GlobalGame:DispatchEventByStringKey("LoginSuccess"); 
end

function _CClientSession:OnLoginFailed()
    Network.OnException(buffer:ReadString(wSize),1);
end

function _CClientSession:OnSitRet(wMaiID, wSubID, buffer, wSize)
    if wSize == 0 then
        local bf = ByteBuffer.New();
        bf:WriteByte(0);
        Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, bf, gameSocketNumber.GameSocket);
        self.isReloadGame = false;
    else

        Network.OnException(buffer:ReadString(wSize),1);
    end
end

function _CClientSession:OnUserEnter()
    if self.isReloadGame then
        return ;
    end
    local userInfo =
    {
        uid = TableUserInfo._1dwUser_Id,
        name = TableUserInfo._2szNickName,
        sex = TableUserInfo._3bySex,
        customHeader = TableUserInfo._4bCustomHeader,
        headerExtensionName = TableUserInfo._5szHeaderExtensionName,
        leaveWord = TableUserInfo._6szSign,
        gold = TableUserInfo._7wGold,
        price = TableUserInfo._8wPrize,
        chairId = TableUserInfo._9wChairID,
        tableId = TableUserInfo._10wTableID,
        userStatus = TableUserInfo._11byUserStatus,
    };
	logErrorTable(userInfo)
    G_GlobalGame:InitSuccess();
        G_GlobalGame:DispatchEventByStringKey("UserEnter",userInfo);
end

function _CClientSession:OnUserLeave()
    if self.isReloadGame then
        return ;
    end
    local userInfo =
    {
        uid = TableUserInfo._1dwUser_Id,
        name = TableUserInfo._2szNickName,
        sex = TableUserInfo._3bySex,
        customHeader = TableUserInfo._4bCustomHeader,
        headerExtensionName = TableUserInfo._5szHeaderExtensionName,
        leaveWord = TableUserInfo._6szSign,
        gold = TableUserInfo._7wGold,
        price = TableUserInfo._8wPrize,
        chairId = TableUserInfo._9wChairID,
        tableId = TableUserInfo._10wTableID,
        userStatus = TableUserInfo._11byUserStatus,
    };
        G_GlobalGame:DispatchEventByStringKey("UserLeave",userInfo);

end


function _CClientSession:OnStopGame()

end

function _CClientSession:Disconnect()
    table.insert(ReturnNotShowError, "95003");
    Network.Close(gameSocketNumber.GameSocket);
    G_GlobalGame:DispatchEventByStringKey("ReloadGame");
    self.isReloadGame = true;
end

function _CClientSession:OnBackGame(_time)
    self._offlineTime = self._offlineTime + _time;
    if self._offlineTime>5 then
        if Network.State(gameSocketNumber.GameSocket) then 
            self:Disconnect();
            HallScenPanel.ReLoadGame(handler(self,self.OnReloadGame));
            self._offlineTime = 0;
        else
            HallScenPanel.ReLoadGame(handler(self,self.OnReloadGame));
        end
    else
        if Network.State(gameSocketNumber.GameSocket) then 
        else
            HallScenPanel.ReLoadGame(handler(self,self.OnReloadGame));
            self._offlineTime = 0;
        end
    end
    self._checkOffLineTime = 0;
end


function _CClientSession:OnReloadGame()
    self:SendLogin();
end

function _CClientSession:OnBiaoAction()

end

function _CClientSession:OnUserScore()
    G_GlobalGame:DispatchEventByStringKey("UserScore",{chairId=TableUserInfo._9wChairID,gold=TableUserInfo._7wGold});
end

function _CClientSession:OnUserStatus(wMaiID, wSubID, buffer, wSize)
    
end

function _CClientSession:OnRoomBreakLine()
    Network.OnException(buffer:ReadString(wSize),1);
end

function _CClientSession:OnChangeTable()

end


function _CClientSession:Update(_dt)
    self._checkOffLineTime = self._checkOffLineTime + _dt;
    if self._checkOffLineTime>2 then
        self._offlineTime = 0;
    end
end

return _CClientSession;