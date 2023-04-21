local C_Vector3_One                                     = C_Vector3_One                                    
local C_Color_One                                       = C_Color_One                                      
local V_Vector3_Value                                   = V_Vector3_Value                                  
local V_Color_Value                                     = V_Color_Value                                    
local ImageAnimaClassType                               = ImageAnimaClassType                              
local ImageClassType                                    = ImageClassType                                   
local GAMEOBJECT_NEW                                    = GAMEOBJECT_NEW                                   
local BoxColliderClassType                              = BoxColliderClassType                             
local ParticleSystemClassType                           = ParticleSystemClassType                          
local UTIL_ADDCOMPONENT                                 = UTIL_ADDCOMPONENT                                
local MATH_SQRT                                         = MATH_SQRT                                        
local MATH_SIN                                          = MATH_SIN                                         
local MATH_COS                                          = MATH_COS 
local MATH_ATAN                                         = MATH_ATAN
local MATH_TAN                                          = MATH_TAN                                        
local MATH_FLOOR                                        = MATH_FLOOR                                       
local MATH_ABS                                          = MATH_ABS                                         
local MATH_RAD                                          = MATH_RAD                                         
local MATH_RAD2DEG                                      = MATH_RAD2DEG                                     
local MATH_DEG                                          = MATH_DEG                                         
local MATH_DEG2RAD                                      = MATH_DEG2RAD                                     
local MATH_RANDOM                                       = MATH_RANDOM    
local MATH_PI                                           = MATH_PI                                   

local G_GlobalGame_EventID                              = G_GlobalGame_EventID                             
local G_GlobalGame_KeyValue                             = G_GlobalGame_KeyValue                            
local G_GlobalGame_GameConfig                           = G_GlobalGame_GameConfig                          
local G_GlobalGame_GameConfig_FishInfo                  = G_GlobalGame_GameConfig_FishInfo                 
local G_GlobalGame_GameConfig_Bullet                    = G_GlobalGame_GameConfig_Bullet                   
local G_GlobalGame_GameConfig_SceneConfig               = G_GlobalGame_GameConfig_SceneConfig              
local G_GlobalGame_GameConfig_AnimaStyleInfo            = G_GlobalGame_GameConfig_AnimaStyleInfo           
local G_GlobalGame_Enum_FishType                        = G_GlobalGame_Enum_FishType                       
local G_GlobalGame_Enum_FISH_Effect                     = G_GlobalGame_Enum_FISH_Effect                    
local G_GlobalGame_Enum_GoldType                        = G_GlobalGame_Enum_GoldType                       
local G_GlobalGame_Enum_EffectType                      = G_GlobalGame_Enum_EffectType                     
local G_GlobalGame_SoundDefine                          = G_GlobalGame_SoundDefine                         
local G_GlobalGame_ConstDefine                          = G_GlobalGame_ConstDefine                         
local G_GlobalGame_FunctionsLib                         = G_GlobalGame_FunctionsLib                        
local G_GlobalGame_FunctionsLib_FUNC_GetPrefabName      = G_GlobalGame_FunctionsLib_FUNC_GetPrefabName     
local G_GlobalGame_FunctionsLib_FUNC_CacheGO            = G_GlobalGame_FunctionsLib_FUNC_CacheGO           
local G_GlobalGame_FunctionsLib_FUNC_AddAnimate         = G_GlobalGame_FunctionsLib_FUNC_AddAnimate        
local G_GlobalGame_FunctionsLib_FUNC_GetFishPrefabName  = G_GlobalGame_FunctionsLib_FUNC_GetFishPrefabName 
local G_GlobalGame_FunctionsLib_FUNC_GetFishStyleInfo   = G_GlobalGame_FunctionsLib_FUNC_GetFishStyleInfo  
local G_GlobalGame_FunctionsLib_GetFishIDByGameObject   = G_GlobalGame_FunctionsLib_GetFishIDByGameObject  
local G_GlobalGame_FunctionsLib_FUNC_GetEulerAngle      = G_GlobalGame_FunctionsLib_FUNC_GetEulerAngle 
local G_GlobalGame_FunctionsLib_CreateFishName          = G_GlobalGame_FunctionsLib_CreateFishName


--local _CClientSession=class("_CClientSession");
local _CClientSession=class();
function _CClientSession:ctor()
    --锟斤拷锟斤拷锟竭硷拷锟绞憋拷锟?
    self._checkOffLineTime = 0;
    self._offlineTime = 0;
    self.isReloadGame = true;

    --锟斤拷锟节憋拷锟解卡锟斤拷锟斤拷锟斤拷锟斤拷
    self._onlyRefreshCount = 15;
    self._isOnlyRefreshCount = false;
    self._onlyRefreshTime = 0;
    self._isCanPreparedLogin = true;
    self._isPreparedLogin = false;
    self._preparedTime    = 4;
    do
        local _fish = {wUnk = 1,initCount=1,fishKind =1,
            fishId=1,traceType=1,existTime=1,
            args = {0,0,0,0,0},
            point={
            {x=1,y=1,z=1},
            {x=1,y=1,z=1},
            {x=1,y=1,z=1},
            {x=1,y=1,z=1},
            {x=1,y=1,z=1}
            }
            };
        self._fishData = _fish; 

        --锟揭伙拷锟斤拷锟斤拷
        self.exchangeData = {chairId = 0, addFishGold = 0 ,fishGold = 0};

        --锟斤拷锟斤拷锟斤拷锟斤拷
        self.fireData = {
            bulletKind=0,
            bulletId=0,
            chairId           = 0,
            androidChairId    = 0,
            wUnk              = 0,
            angle             = 0,
            bulletMultiple    = 0,
            lockFishId        = 0,
            fishGold          = 0
        };

        --捉锟斤拷锟斤拷锟斤拷锟斤拷
        self.catchFishData = {
            chairId        = 0,
            fishId         = 0,
            wUnk           = 0,
            fishKind       = 0,
            bulletIon      = 0,
            fishGold       = 0,
            totalFishGold  = 0
        };

        --抓锟斤拷源头锟斤拷
        self.catchCauseFish = {
            chairId        = 0,
            wunk           = 0,
            fishId         = 0,
            fishGold       = 0,
            totalFishGold  = 0
        };  
        
        --锟斤拷锟斤拷锟斤拷锟?
        self.userInfoData = {
            uid = 0,
            name = 0,
            sex = 0,
            customHeader = 0,
            headerExtensionName = 0,
            leaveWord = 0,
            gold = 0,
            price = 0,
            chairId = 0,
            tableId = 0,
            userStatus = 0
        }; 
    end
    --锟角凤拷锟窖撅拷锟斤拷锟斤拷锟斤拷锟襟场撅拷锟斤拷息
    self.isSitDownSuccess       = false;
    self.isSendGetSceneInfo     = false;
end

function _CClientSession:OnSceneInfoHandler(wMaiID, wSubID, buffer, wSize)
    --锟斤拷锟截筹拷锟斤拷锟斤拷桑锟斤拷锟斤拷锟斤拷锟较凤拷晒锟?
    G_GlobalGame:DispatchEvent(G_GlobalGame_EventID.NotifyEnterGame);
end

function _CClientSession:OnMessageHandler(wMaiID, wSubID, buffer, wSize)
    local CommandDefine = G_GlobalGame.GameCommandDefine.SC_CMD;
    local cmd = tonumber(string.sub(wSubID, string.len(tostring(wMaiID)) + 1, string.len(tostring(wSubID) ) ) );
    if self.isReloadGame then
        return ;
    end
    if (cmd == CommandDefine.Game_Config) then   --锟斤拷戏锟斤拷锟斤拷
        self:_notifyGameConfig(buffer);
    elseif (cmd == CommandDefine.Fish_Trace) then  --锟斤拷锟斤拷锟斤拷
        self:_createFishs(buffer,wSize);
    elseif (cmd == CommandDefine.Exchange_FishGold) then --锟揭伙拷锟斤拷锟?
        self:_exchangeFishGold(buffer);
    elseif (cmd == CommandDefine.User_Fire)  then --锟斤拷铱锟斤拷锟?
        self:_notifyUserFire(buffer);
    elseif (cmd == CommandDefine.Catch_Fish) then --锟斤拷锟斤拷锟斤拷
        self:_catchFish(buffer)
    elseif (cmd == CommandDefine.Power_Bullet_Reached) then --锟斤拷锟斤拷锟节碉拷锟斤拷
        self:_notifyEnergyTimeOut(buffer);
    elseif (cmd == CommandDefine.LockTimeOut) then  --锟斤拷锟斤拷时锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟?

    elseif (cmd == CommandDefine.Catch_Special) then --捉锟斤拷锟斤拷锟斤拷锟姐，应锟斤拷锟斤拷炸锟斤拷之锟斤拷
        self:_catchCauseFish(buffer);
    elseif (cmd == CommandDefine.Notify_Catch_Special) then --炸锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟饺ｏ拷锟斤拷锟饺猴拷说锟斤拷锟斤拷锟斤拷锟?
        self:_catchGroupFish(buffer);
    elseif (cmd == CommandDefine.Notify_Catch_LK) then --锟斤拷锟斤拷锟斤拷锟斤拷
        self:_hitLK(buffer);
    elseif (cmd == CommandDefine.Notify_Switch_Scene) then --锟姐潮锟斤拷锟斤拷
        self:_switchScene(buffer);
    elseif (cmd == CommandDefine.Response_Change_FishGold) then --锟斤拷锟斤拷锟斤拷锟?

    end
end

--锟斤拷取锟斤拷戏锟斤拷锟斤拷锟斤拷
function _CClientSession:_notifyGameConfig(_buffer)
    local exchange_ratio_userscore  = _buffer:ReadInt32();
    local exchange_ratio_fishscore  = _buffer:ReadInt32();
    local exchange_count =  _buffer:ReadInt32();
    local GameConfig = G_GlobalGame_GameConfig;
    G_GlobalGame_GameConfig_SceneConfig.iMinBulletMultiple  = _buffer:ReadInt32();
    G_GlobalGame_GameConfig_SceneConfig.iMaxBulletMultiple  = _buffer:ReadInt32();
    local bomb_range_width = _buffer:ReadInt32();
    local bomb_range_height = _buffer:ReadInt32();
    local wUnk = _buffer:ReadUInt16();
    local FishKindMax = G_GlobalGame_ConstDefine.C_S_FISH_KIND_MAX;
    for i=1,FishKindMax do
        G_GlobalGame_GameConfig_FishInfo[i-1].iMultiple = _buffer:ReadInt32();
    end
    for i=1,FishKindMax do
        G_GlobalGame_GameConfig_FishInfo[i-1].iSpeed = _buffer:ReadInt32();
    end
    for i=1,FishKindMax do
        G_GlobalGame_GameConfig_FishInfo[i-1].iWidth = _buffer:ReadInt32();
		
    end
    for i=1,FishKindMax do
        G_GlobalGame_GameConfig_FishInfo[i-1].iHeight = _buffer:ReadInt32();
    end
    for i=1,FishKindMax do
        G_GlobalGame_GameConfig_FishInfo[i-1].iRadius = _buffer:ReadInt32();
    end

    local BulletMaxType = G_GlobalGame_ConstDefine.C_S_BULLET_KIND_MAX;
    for i=1,BulletMaxType do
        G_GlobalGame_GameConfig_Bullet[i-1].iSpeed = _buffer:ReadInt32();
		--error(G_GlobalGame_GameConfig_Bullet[i-1].iSpeed)
	end
	for i=1,BulletMaxType do
        G_GlobalGame_GameConfig_Bullet[i-1].iNetRadius = _buffer:ReadInt32();			
    end
		logErrorTable(G_GlobalGame_GameConfig_Bullet)
    --通知锟斤拷戏锟斤拷锟斤拷
    G_GlobalGame:DispatchEvent(G_GlobalGame_EventID.GameConfig);
end

local CREATE_FISH_MESSAGE_SIZE = 78;
local test=1;
local fishType=0;
function _CClientSession:_createFishs(_buffer,_wSize)
	
		--error("==================这条鱼信息============================")
    --local fishCount = _wSize/CREATE_FISH_MESSAGE_SIZE;
    local _fish = self._fishData;
    --for i=1,fishCount  do

        for j=1,5 do
            _fish.point[j].x = _buffer:ReadFloat();
            _fish.point[j].y = _buffer:ReadFloat();
            _fish.point[j].z = _buffer:ReadFloat();		

        end
		

        _fish.wUnk = _buffer:ReadUInt16();
			-- error("wUnk=".._fish.wUnk)
        _fish.initCount = _buffer:ReadInt32();
		-- error("initCount=".._fish.initCount)
--[[        for j=1,5 do
            _fish.args[j] = _buffer:ReadFloat();
        end--]]
		
        _fish.fishKind = _buffer:ReadInt32();

        _fish.fishId = _buffer:ReadInt32();
		--if _fish.fishKind ==20 then
          --error("fishKind=".._fish.fishKind)
		--end
		--error("fishId=".._fish.fishId)
        _fish.traceType = _buffer:ReadInt32();
        _fish.existTime = _buffer:ReadInt32()/1000;
		--_fish.existTime = _buffer:ReadInt32();
		if _fish.fishKind ==20 then
			do return end 
		end 
		--logErrorTable(_fish)
		-- error("traceType=".._fish.traceType)
		-- error("刷鱼了=".._fish.existTime)
		--error("==================结束============================")
            if self._isOnlyRefreshCount then
                if self._onlyRefreshCount>0 then
                    self._onlyRefreshCount = self._onlyRefreshCount - 1;

                    G_GlobalGame:DispatchEvent(G_GlobalGame_EventID.CreateFish,_fish);
                end
            else
		
                G_GlobalGame:DispatchEvent(G_GlobalGame_EventID.CreateFish,_fish);
            end
	
    --end
end

function _CClientSession:_exchangeFishGold(_buffer)
    self.exchangeData.chairId = _buffer:ReadUInt16();
    self.exchangeData.addFishGold = int64.tonum2(_buffer:ReadInt64());
    self.exchangeData.fishGold = int64.tonum2(_buffer:ReadInt64());
    --锟揭伙拷锟斤拷锟?
    G_GlobalGame:DispatchEvent(G_GlobalGame_EventID.ExchangeFishGold,self.exchangeData);
end

function _CClientSession:_notifyUserFire(_buffer)
	--logError("-------------------------------------")
    local fire = self.fireData;
    fire.bulletKind        = _buffer:ReadInt32();
    fire.bulletId          = _buffer:ReadInt32();
    fire.chairId           = _buffer:ReadUInt16();
    fire.androidChairId    = _buffer:ReadUInt16();
    fire.wUnk              = _buffer:ReadUInt16();
    fire.angle             = _buffer:ReadFloat();
    fire.bulletMultiple    = _buffer:ReadInt32();
    fire.lockFishId        = _buffer:ReadInt32();
    fire.fishGold          = int64.tonum2(_buffer:ReadInt64());
	--logError("服务器通知开火="..fire.bulletId)
    --锟街凤拷锟铰硷拷
    G_GlobalGame:DispatchEvent(G_GlobalGame_EventID.UserFire,fire);
end

--抓锟斤拷
function _CClientSession:_catchFish(_buffer)
    local fish = self.catchFishData;
    fish.chairId = _buffer:ReadUInt16();
    fish.fishId  = _buffer:ReadInt32();
    fish.wUnk    = _buffer:ReadUInt16();
    fish.fishKind= _buffer:ReadInt32();
    fish.bulletIon= _buffer:ReadByte();
    fish.fishGold= int64.tonum2(_buffer:ReadInt64());
	
    fish.totalFishGold= int64.tonum2(_buffer:ReadInt64());
	--logError("=====================================")
		--logErrorTable(fish)
    --抓锟斤拷锟斤拷
    G_GlobalGame:DispatchEvent(G_GlobalGame_EventID.CatchFish,fish);
end

--锟斤拷捉锟斤拷
function _CClientSession:_catchCauseFish(_buffer)
    local fish = self.catchCauseFish;
    fish.chairId = _buffer:ReadUInt16();
    fish.wunk    = _buffer:ReadUInt16();
    fish.fishId  = _buffer:ReadInt32();
    fish.fishGold = int64.tonum2(_buffer:ReadInt64());
    fish.totalFishGold=int64.tonum2(_buffer:ReadInt64());
    G_GlobalGame:DispatchEvent(G_GlobalGame_EventID.CatchCauseFish,fish);
end

--锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷录锟?
function _CClientSession:_catchGroupFish(_buffer)
--    local groupFish = {};
--    groupFish.chairId       = _buffer:ReadUInt16();
--    groupFish.fishId        = _buffer:ReadInt32();
--    groupFish.fishGold      = int64.tonum2(_buffer:ReadInt64());
--    groupFish.catchFishCount= _buffer:ReadInt32();
--    groupFish.catchFishIds  = {};
--    for i=1,groupFish.catchFishCount do
--        groupFish.catchFishIds[i] = _buffer:ReadInt32();
--    end
--    G_GlobalGame:DispatchEventByStringKey("CatchGroupFish",groupFish);
    local groupFish = {};
    groupFish.chairId       = _buffer:ReadUInt16();
    groupFish.fishGold      = int64.tonum2(_buffer:ReadInt64());
    local fish = {};
    groupFish.causeFish = fish;
    fish.fishId         = _buffer:ReadInt32();
    fish.fishScore      = int64.tonum2(_buffer:ReadInt64());
    groupFish.catchFishCount= _buffer:ReadInt32();
    groupFish.catchFishes   = {};
    for i=1,groupFish.catchFishCount do
        groupFish.catchFishes[i]  = {};
        groupFish.catchFishes[i].fishId     = _buffer:ReadInt32();
        groupFish.catchFishes[i].fishScore  = int64.tonum2(_buffer:ReadInt64());
    end
    G_GlobalGame:DispatchEvent(G_GlobalGame_EventID.CatchGroupFish,groupFish);
end

--锟斤拷锟斤拷锟节碉拷锟斤拷
function _CClientSession:_notifyEnergyTimeOut(_buffer)
    local info = {};
    info.chairId       = _buffer:ReadUInt16();
    G_GlobalGame:DispatchEvent(G_GlobalGame_EventID.EnergyTimeOut,info);
end

--撞锟斤拷锟斤拷锟斤拷
function _CClientSession:_hitLK(_buffer)
    local lk = {};
    lk.chairId      = _buffer:ReadUInt16();
    lk.fishId       = _buffer:ReadInt32();
    lk.fishMultiple = _buffer:ReadInt32();
    G_GlobalGame:DispatchEvent(G_GlobalGame_EventID.HitLK,lk);
end

--锟叫伙拷锟斤拷锟斤拷
function _CClientSession:_switchScene(_buffer)
    if self.isReloadGame then
        return ;
    end
    if G_GlobalGame:GetGameRunTime()<20000 then
        --锟斤拷锟斤拷锟斤拷戏锟斤拷锟斤拷锟节ｏ拷锟秸碉拷锟姐潮锟斤拷锟饺猴拷锟斤拷
        return ;
    end
    local sceneInfo = {};
	
    sceneInfo.sceneKind     = _buffer:ReadInt32();
	--error("sceneKind="..sceneInfo.sceneKind )
    sceneInfo.fishPartCount = _buffer:ReadInt32();
	--error("fishPartCount="..sceneInfo.fishPartCount)
    sceneInfo.fishGroupParts={};
    for i=1,sceneInfo.fishPartCount do
		--error("第几部分鱼="..i)
        local groupPart = {};
        sceneInfo.fishGroupParts[i] = groupPart;
        groupPart.fishCount = _buffer:ReadInt32();
		--error("fishCount="..groupPart.fishCount )
        groupPart.fishes  ={};
        for j=1,groupPart.fishCount do
			--error("第几条鱼="..j)
            local fish = {};
            groupPart.fishes[j] = fish;
            fish.fishType = _buffer:ReadInt32();
            fish.fishId = _buffer:ReadInt32();
			--error("fishType="..fish.fishType )
			--error("fishId="..fish.fishId )
        end
    end
    G_GlobalGame:DispatchEvent(G_GlobalGame_EventID.SwitchScene,sceneInfo);
end

-- =====锟斤拷锟斤拷锟斤拷息锟侥结构锟斤拷锟斤拷
function _CClientSession:SendLogin()
    local bf = ByteBuffer.New();
    bf:WriteUInt32(0);
    bf:WriteUInt32(0);
    bf:WriteUInt32(SCPlayerInfo._01dwUser_Id);
    bf:WriteBytes(DataSize.String33, SCPlayerInfo._06wPassword);
    bf:WriteBytes(100,Opcodes);
    bf:WriteByte(0);
    bf:WriteByte(0);
    --Network.Send(MH.MDM_GR_LOGON, MH.SUB_GR_LOGON_USERID, bf, gameSocketNumber.GameSocket);--锟缴的凤拷锟斤拷指锟筋不锟斤拷锟斤拷
    Network.Send(MH.MDM_GR_LOGON, 3, bf, gameSocketNumber.GameSocket);
end

function _CClientSession:SendAddScore()
    if self.isReloadGame then
        return ;
    end
    --锟酵伙拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷戏锟?
    local bf = ByteBuffer.New();
    bf:WriteUInt16(0);
    bf:WriteByte(1);
    Network.Send(MH.MDM_GF_GAME, G_GlobalGame.GameCommandDefine.CS_CMD.ExchangeFishGold, bf, gameSocketNumber.GameSocket);
end

function _CClientSession:SendRemoveScore()
    if self.isReloadGame then
        return ;
    end
    --锟酵伙拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷路锟?
    local bf = ByteBuffer.New();
    bf:WriteUInt16(0);
    bf:WriteByte(0);
    Network.Send(MH.MDM_GF_GAME, G_GlobalGame.GameCommandDefine.CS_CMD.ExchangeFishGold, bf, gameSocketNumber.GameSocket);
end


function _CClientSession:SendPao(_bulletType,_angle,_bulletMultiple,_lockFishId)
    if self.isReloadGame then
        return ;
    end
		G_GlobalGame.bulletId=G_GlobalGame.bulletId+1

    --锟酵伙拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟?
    local bf = ByteBuffer.New();
    bf:WriteUInt32(G_GlobalGame:GetGameRunTime());
    bf:WriteInt(_bulletType);
    bf:WriteFloat(_angle);
    bf:WriteUInt16(G_GlobalGame.GameCommandDefine.CMD_CODE.SendPaoCode);
    bf:WriteInt(_bulletMultiple);
    bf:WriteInt(_lockFishId);
	--logError("_angle=".._angle)
	--logError("_bulletMultiple".._bulletMultiple)	
    Network.Send(MH.MDM_GF_GAME, G_GlobalGame.GameCommandDefine.CS_CMD.UserFire, bf, gameSocketNumber.GameSocket);
end

function _CClientSession:SendCatchFish(_chairId,_fishId,_fishMultiple,_bulletType,_bulletId,_bulletMultiple)
    if self.isReloadGame then
        return ;
    end
	--	logError("客户端发送捕获鱼ID=".._bulletId)
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

--锟斤拷锟斤拷锟斤拷锟斤拷
function _CClientSession:SendHitLikui(_fishId)
    if self.isReloadGame then
        return ;
    end
    local bf = ByteBuffer.New();
    bf:WriteUInt16(0);
    bf:WriteInt(_fishId);
    Network.Send(MH.MDM_GF_GAME, G_GlobalGame.GameCommandDefine.CS_CMD.ShotLiKui, bf, gameSocketNumber.GameSocket);
end

--锟斤拷捉锟斤拷锟斤拷锟斤拷
function _CClientSession:SendCatchSweepFish(_chairId,_fishId,_vec)
    if self.isReloadGame then
        return ;
    end
    local bf = ByteBuffer.New();
    bf:WriteUInt16(_chairId);
    bf:WriteInt(_fishId);
    bf:WriteUInt16(0);
    bf:WriteInt(#_vec);
    local fish
    for i=1,300 do
        fish = _vec[i];
        if fish==nil then
            bf:WriteInt(0);
        else
            bf:WriteInt(fish:FishID());
        end
    end
    Network.Send(MH.MDM_GF_GAME, G_GlobalGame.GameCommandDefine.CS_CMD.CatchFishGroup, bf, gameSocketNumber.GameSocket);
end

--锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟?
function _CClientSession:NewHandOver()
    local bf = ByteBuffer.New();
    bf:WriteUInt32(G_GlobalGame_ConstDefine.GAME_ID);
    Network.Send(MH.MDM_3D_PERSONAL_INFO, MH.SUB_3D_CS_USER_NEW_HAND_FINISH, bf, gameSocketNumber.HallSocket);
end

--锟斤拷陆锟斤拷锟?
function _CClientSession:OnLoginOver()
    self:SendSitDown();
end

function _CClientSession:SendSitDown()
    local bf = ByteBuffer.New();
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, bf, gameSocketNumber.GameSocket);
end

--锟斤拷业锟铰斤拷晒锟?
function _CClientSession:OnLoginSuccess()
    --
    G_GlobalGame:DispatchEvent(G_GlobalGame_EventID.LoginSuccess); 
end

--锟斤拷业锟铰绞э拷锟?
function _CClientSession:OnLoginFailed(wMaiID, wSubID, buffer, wSize)
--    local GeneralTipsSystem_ShowInfo =
--    {
--        _01_Title = nil;
--        _02_Content = "锟斤拷锟斤拷失锟斤拷";
--        _03_ButtonNum = 1;
--        _04_YesCallFunction = handler(self,self.OnMessageHandler);
--        _05_NoCallFunction = nil;
--    }
--    MessageBox.CreatGeneralTipsPanel(GeneralTipsSystem_ShowInfo);    
end

function _CClientSession:OnHandleMessage()
--    if G_GlobalGame._otherUI then
--        --锟斤拷示锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷
--        G_GlobalGame._otherUI:SetActive(true);
--    end
--    if G_GlobalGame._otherUI then
--        G_GlobalGame._otherUI:SetActive(true);
--    end
    if G_GlobalGame.hallCamera then
        G_GlobalGame.hallCamera.cullingMask = G_GlobalGame.tempHallCullingMask;
    end
    Network.OnException(95003);
    self._isCanPreparedLogin = false;
end

--锟斤拷锟斤拷锟斤拷锟?
function _CClientSession:OnSitRet(wMaiID, wSubID, buffer, wSize)
    if wSize == 0 then
--        self.isSitDownSuccess = true;
--        if G_GlobalGame._isInitResourceSuccess then
--            self:SendGetSceneInfo();
--        end
--        self.isReloadGame = false;
        self.isReloadGame = false;
        self:SendGetSceneInfo();
    else
        -- 锟斤拷锟斤拷失锟斤拷
        Network.OnException(95008);
    end
end

function _CClientSession:SendGetSceneInfo()
    -- 锟斤拷锟斤拷锟缴癸拷锟斤拷准锟斤拷
    local bf = ByteBuffer.New();
    bf:WriteByte(0);
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, bf, gameSocketNumber.GameSocket);
    --self.isSendGetSceneInfo = true;
end

--锟斤拷医锟斤拷锟?
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
    --function ab()
        G_GlobalGame:DispatchEvent(G_GlobalGame_EventID.UserEnter,userInfo);
    --end
    --xTryCatch(ab,handler(G_GlobalGame,G_GlobalGame.writeLog));
end

--锟斤拷锟斤拷肟?
function _CClientSession:OnUserLeave()
    if self.isReloadGame then
        return ;
    end
    local userInfo = self.userInfoData;
    userInfo.uid = TableUserInfo._1dwUser_Id;
    userInfo.name = TableUserInfo._2szNickName;
    userInfo.sex = TableUserInfo._3bySex;
    userInfo.customHeader = TableUserInfo._4bCustomHeader;
    userInfo.headerExtensionName = TableUserInfo._5szHeaderExtensionName;
    userInfo.leaveWord = TableUserInfo._6szSign;
    userInfo.gold = TableUserInfo._7wGold;
    userInfo.price = TableUserInfo._8wPrize;
    userInfo.chairId = TableUserInfo._9wChairID;
    userInfo.tableId = TableUserInfo._10wTableID;
    userInfo.userStatus = TableUserInfo._11byUserStatus;
    --function ab()
        G_GlobalGame:DispatchEvent(G_GlobalGame_EventID.UserLeave,userInfo);
    --end
    --xTryCatch(ab,handler(G_GlobalGame,G_GlobalGame.writeLog));
end


--锟叫伙拷锟斤拷锟斤拷台
function _CClientSession:OnStopGame()
    --锟叫碉拷锟斤拷台锟斤拷锟斤拷锟斤拷锟斤拷
end

--失去锟斤拷锟斤拷
function _CClientSession:Disconnect()
    table.insert(ReturnNotShowError, "95003");
    Network.Close(gameSocketNumber.GameSocket);
    G_GlobalGame:DispatchEvent(G_GlobalGame_EventID.ReloadGame);
    self.isReloadGame = true;
end

--锟截碉拷锟斤拷戏
function _CClientSession:OnBackGame(_time)
    self._offlineTime = self._offlineTime + _time;
    if self._offlineTime>8 then
        if Network.State(gameSocketNumber.GameSocket) then 
            self:Disconnect();
            if Util.isPc and not Util.isEditor then
                HallScenPanel.ReLoadGame(handler(self,self.OnReloadGame));
            else
                if self._isPreparedLogin then
                else 
                    self._isPreparedLogin = true;
                    self._preparedTime = 0;
                end 
            end
            --HallScenPanel.ReLoadGame(handler(self,self.OnReloadGame));
            self._offlineTime = 0;
        else
            if Util.isPc and not Util.isEditor then
                HallScenPanel.ReLoadGame(handler(self,self.OnReloadGame));
            else
                if self._isPreparedLogin then
                else 
                    self._isPreparedLogin = true;
                    self._preparedTime = 0;
                end 
            end
            --HallScenPanel.ReLoadGame(handler(self,self.OnReloadGame));
        end
    else
        if Network.State(gameSocketNumber.GameSocket) then 
        else
            if Util.isPc and not Util.isEditor then
                HallScenPanel.ReLoadGame(handler(self,self.OnReloadGame));
            else
                if self._isPreparedLogin then
                else 
                    self._isPreparedLogin = true;
                    self._preparedTime = 0;
                end 
            end
            --HallScenPanel.ReLoadGame(handler(self,self.OnReloadGame));
            self._offlineTime = 0;
        end
        if self._offlineTime>2 then
            --只刷锟斤拷锟斤拷锟斤拷
            --锟斤拷锟解卡锟斤拷锟斤拷锟斤拷锟斤拷
            self._onlyRefreshCount = 15;
            self._isOnlyRefreshCount = true;
            self._onlyRefreshTime = 0;
        end
    end
    --锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷时锟斤拷锟斤拷锟斤拷锟?
    self._checkOffLineTime = 0;
end


--锟斤拷锟铰硷拷锟斤拷锟斤拷戏
function _CClientSession:OnReloadGame()
    self:SendLogin();
end

function _CClientSession:OnBiaoAction()

end

--锟矫伙拷锟斤拷锟斤拷
function _CClientSession:OnUserScore()
    G_GlobalGame:DispatchEvent(G_GlobalGame_EventID.UserScore,{chairId=TableUserInfo._9wChairID,gold=TableUserInfo._7wGold});
end

-- 锟矫伙拷状态
function _CClientSession:OnUserStatus(wMaiID, wSubID, buffer, wSize)
    
end


function _CClientSession:OnRoomBreakLine()

end

function _CClientSession:OnChangeTable()

end


function _CClientSession:Update(_dt)
    self._checkOffLineTime = self._checkOffLineTime + _dt;
    if self._checkOffLineTime>2 then
        self._offlineTime = 0;
    end
    if self._isOnlyRefreshCount then
        self._onlyRefreshTime = self._onlyRefreshTime + _dt;
        if self._onlyRefreshTime>0.5 then
            self._isOnlyRefreshCount = false;
        end
    end
    if self._isPreparedLogin and self._isCanPreparedLogin then
        self._preparedTime = self._preparedTime + _dt;
        if self._preparedTime>=3.2 then
            self._isPreparedLogin = false;
            self._preparedTime = 0;
            HallScenPanel.ReLoadGame(handler(self,self.OnReloadGame));
        end
    end
end

return _CClientSession;