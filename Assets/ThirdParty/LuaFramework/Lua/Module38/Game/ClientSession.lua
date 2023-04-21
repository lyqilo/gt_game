local _CClientSession=class("_CClientSession");
local self=_CClientSession
self.isreqStart=true;
function _CClientSession:ctor()
    --检测断线间隔时长
    self._checkOffLineTime = 0;
    self._offlineTime = 0;

    self._snetCode      = nil;
    self._uid           = nil;
    self._chairId       = nil;
    self._verifyCode    = nil;
    self._isNotifyGameData = false;
end

function _CClientSession:OnSceneInfoHandler(wMaiID, wSubID, buffer, wSize)
    error("加载场景完成，进入游戏成功")
    --加载场景完成，进入游戏成功
    G_GlobalGame:DispatchEventByStringKey("NotifySceneInfo");  
end

function _CClientSession:GetBaseMsg(_buffer)
    local version,errorCode;
    version     = _buffer:ReadUInt16();
    errorCode   = _buffer:ReadUInt16();
    return version,code,errorCode;
end

function _CClientSession:OnMessageHandler(wMaiID, wSubID, buffer, wSize)
    local CommandDefine = G_GlobalGame.GameCommandDefine.SC_CMD;
    local cmd = tonumber(string.sub(wSubID, string.len(tostring(wMaiID)) + 1, string.len(tostring(wSubID) ) ) );
    if (cmd == CommandDefine.Game_Config) then   --游戏配置
        self:_notifyGameConfig(buffer);
    elseif (cmd == CommandDefine.Game_Data) then  --游戏数据
        --暂时保留
        self:_notifyGameData(buffer);
    elseif (cmd == CommandDefine.StartGame) then --开始游戏
        self:_responseStartGame(buffer);
    elseif (cmd == CommandDefine.StartSmallGame) then --点球大战
        self:_responseStartSmallGame(buffer);
    elseif (cmd == CommandDefine.ResponseCaiJin) then --响应彩金 
        self:_responseCaiJin(buffer);
    end
end


-- =====发送消息的结构函数
function _CClientSession:SendLogin()
    logYellow("登录")
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

function _CClientSession:SendSitDown()
    logYellow("发送坐下")
    local bf = ByteBuffer.New();
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, bf, gameSocketNumber.GameSocket);
end

--登陆完成
function _CClientSession:OnLoginOver()
    logYellow("登陆完成")
    G_GlobalGame._gameControl:OnLoginOver();
end

--玩家登陆成功
function _CClientSession:OnLoginSuccess()
    --
    G_GlobalGame:DispatchEventByStringKey("LoginSuccess"); 
end

--玩家登陆失败
function _CClientSession:OnLoginFailed()
    -- 入座失败
    HallScenPanel.NetException("Failed to enter room", gameSocketNumber.GameSocket);
end

--玩家坐下
function _CClientSession:OnSitRet(wMaiID, wSubID, buffer, wSize)
    if wSize == 0 then
        logYellow("入座成功，准备")
        -- 入座成功，准备
        local bf = ByteBuffer.New();
        bf:WriteByte(0);
        Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, bf, gameSocketNumber.GameSocket);
    else
        -- 入座失败
        HallScenPanel.NetException("Failed to enter room", gameSocketNumber.GameSocket);
    end
end

--玩家进入
function _CClientSession:OnUserEnter()
    logYellow("玩家进入")
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
    if not self._uid then
        --赋值UID和座位号
        self._uid       = userInfo.uid;
        self._chairId   = userInfo.chairId;
    end
    if self._isNotifyGameData  then
        --function ab()
        G_GlobalGame:DispatchEventByStringKey("UserEnter",userInfo);
        --end
        --xTryCatch(ab,handler(G_GlobalGame,G_GlobalGame.writeLog));
    end
end

--玩家离开
function _CClientSession:OnUserLeave()
    logYellow("玩家离开")
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
    if self._isNotifyGameData  then
        --function ab()
            G_GlobalGame:DispatchEventByStringKey("UserLeave",userInfo);
        --end
        --xTryCatch(ab,handler(G_GlobalGame,G_GlobalGame.writeLog));
    end
end


--切换到后台
function _CClientSession:OnStopGame()
    --切到后台不做处理
end

--失去连接
function _CClientSession:Disconnect()
    table.insert(ReturnNotShowError, "95003");
    NetManager:Disconnect(gameSocketNumber.GameSocket);
    --重新加载游戏
    G_GlobalGame._gameControl:ReloadGame();
    G_GlobalGame:DispatchEventByStringKey("ReloadGame");
end

function _CClientSession:OnBackGame()
    logYellow("回到游戏")
    if self.isreqStart then
        G_GlobalGame._clientSession:OnReloadGame()
    end
end



--重新加载游戏
function _CClientSession:OnReloadGame()
    logYellow("重新加载游戏")
    G_GlobalGame._clientSession._snetCode      = nil;
    G_GlobalGame._clientSession._uid           = nil;
    G_GlobalGame._clientSession._chairId       = nil;
    G_GlobalGame._clientSession._verifyCode    = nil;
    G_GlobalGame._clientSession._isNotifyGameData = false;
    G_GlobalGame._clientSession:SendLogin();
end

function _CClientSession:OnBiaoAction()

end

--用户积分
function _CClientSession:OnUserScore()
    G_GlobalGame:DispatchEventByStringKey("UserScore",{chairId=TableUserInfo._9wChairID,gold=TableUserInfo._7wGold});
end

-- 用户状态
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
end



--游戏中协议
--客户端请求开始游戏
function _CClientSession:SendStartGame(bet)
    error("=========客户端请求开始游戏========"..bet)
    bet = bet or 1;
    local bf = self:_createByteBuffer();
    bf:WriteInt(bet);
    Network.Send(MH.MDM_GF_GAME, G_GlobalGame.GameCommandDefine.CS_CMD.StartGame, bf, gameSocketNumber.GameSocket);
    self.isreqStart=false;

end

--客户端请求点球
function _CClientSession:SendStartSmallGame(_pos)
    error("=========客户端请求小游戏========"..(_pos))
    local bf = self:_createByteBuffer();
    bf:WriteByte(_pos);
    Network.Send(MH.MDM_GF_GAME, G_GlobalGame.GameCommandDefine.CS_CMD.StartBallGame, bf, gameSocketNumber.GameSocket);
    self.isreqStart=false;

end

--客户端请求彩金
function _CClientSession:SendStartCaiJin()
    local bf = self:_createByteBuffer();
    Network.Send(MH.MDM_GF_GAME, G_GlobalGame.GameCommandDefine.CS_CMD.RequestCaiJin, bf, gameSocketNumber.GameSocket);
end

--
function _CClientSession:_createByteBuffer()
    local bf = ByteBuffer.New();
    bf:WriteUInt16(G_GlobalGame.ConstDefine.GAME_VERSION); --版本默认0
    bf:WriteUInt16(0); --验证码  
    return bf;
end

--读取游戏配置项
function _CClientSession:_notifyGameConfig(_buffer)
    error("读取游戏配置")
    local  _GameDefine = GameRequire__("GameDefine");
    --下注值
    local betCount = _buffer:ReadByte();
    
    for i=1,betCount do
        _GameDefine.PushBet(_buffer:ReadInt());
    end

    _GameDefine.SetIconMultiple();
    _GameDefine.SetLine();

    --全盘奖倍率
    local EnumWholeType = _GameDefine.EnumWholeType();
    _GameDefine.SetWholeMultiple(EnumWholeType.EM_WholeValue_Small,_buffer:ReadInt());
    _GameDefine.SetWholeMultiple(EnumWholeType.EM_WholeValue_Mid,_buffer:ReadInt());
    _GameDefine.SetWholeMultiple(EnumWholeType.EM_WholeValue_Big,_buffer:ReadInt());

    --_GameDefine.WholeMultiple();

    --设置征战特奖
    _GameDefine.SetSepMultiple(_buffer:ReadInt());

    --设置每个可能出现的个数
    local EnumSmallGameType = _GameDefine.EnumSmallGameType();
    for i=EnumSmallGameType.EM_SmallGame_Null,EnumSmallGameType.EM_SmallGame_Max-1 do
        _GameDefine.SetItemCount(i,_buffer:ReadByte());
    end
    --_GameDefine.ItemCount();
    --通知游戏配置
    G_GlobalGame:DispatchEventByStringKey("GameConfig",nil);
end

local Number=0
local NumBet=0
function _CClientSession:Number_Zero()
   Number=0
   NumBet=0
end
function _CClientSession:GetBet_Data(_bet)
    logYellow("改变下注==".._bet)
    NumBet=_bet
end

function _CClientSession:_notifyGameData(_buffer)
    error("读取游戏数据")
    Number=Number+1
    self._isNotifyGameData = true;
    do
        self._uid      = _buffer:ReadUInt32(); 
        self._snetCode = _buffer:ReadUInt16();
        self._chairId  = _buffer:ReadUInt16();
        self._tableID  = _buffer:ReadUInt16();
    end
    local gameData = {};
    gameData.userState = _buffer:ReadByte();    --玩家状态  0 普通模式， 1 点球模式 , 2 免费模式
    gameData.freeCount = _buffer:ReadByte();    --免费次数
    gameData.multiple  = _buffer:ReadByte();    --当前倍率
   
    local n1= _buffer:ReadInt(); 
    logYellow("NumBet1=="..NumBet)
    
    if Number==1 then
        gameData.bet =n1          --下注值
        NumBet=n1/40
        gameData.bet=gameData.bet/40
    else
        gameData.bet=NumBet
    end
    logYellow("NumBet2=="..NumBet)
    gameData.gold      = tonumber(_buffer:ReadInt64Str()) --金币
    gameData.caijin    = tonumber(_buffer:ReadInt64Str()) --彩金
    gameData.fightCount = 0;
    gameData.baseWarGold= 0;
    error("玩家状态=="..gameData.userState)
    error("免费次数=="..gameData.freeCount)
    error("下注值=="..gameData.bet)
    error("彩金=="..gameData.caijin)

    local chairsData = {};
    chairsData[1] = {};
    chairsData[1].userId = self._uid;
    chairsData[1].chairId = self._chairId;
    chairsData[1].gold   = gameData.gold;
    chairsData[1].isOwner = true;
    G_GlobalGame:DispatchEventByStringKey("ChairsData",chairsData);

    local _GameDefine = GameRequire__("GameDefine")
    local Enum_ServerState = _GameDefine.EnumServerState();
    
    --if gameData.userState== Enum_ServerState.EM_ServerState_Normal or gameData.userState== Enum_ServerState.EM_ServerState_FreeGame then
       
        local xCount = _GameDefine.XCount();
        local yCount = _GameDefine.YCount();

        gameData.baseWarGold = tonumber(_buffer:ReadInt64Str()) -- CSBufferToInt64(_buffer);
        gameData.warCellDatas  = {};
        for i=1,yCount do
            gameData.warCellDatas[i]  = {};
            for j=1,xCount do
                gameData.warCellDatas[i][j] = _buffer:ReadByte();
                if (gameData.warCellDatas[i][j]==1) then
                    gameData.fightCount = gameData.fightCount + 1;
                end
            end
        end
    --elseif gameData.userState== Enum_ServerState.EM_ServerState_SmallGame then
        gameData.smallGame = {};
        gameData.smallGame.warTotalGold = tonumber(_buffer:ReadInt64Str()) --CSBufferToInt64(_buffer);
        gameData.smallGame.multiple = _buffer:ReadInt();
        gameData.smallGame.leftCount = _buffer:ReadByte();
        error("小游戏金币=="..gameData.smallGame.warTotalGold)
        error("小游戏倍率=="..gameData.smallGame.multiple)
        error("小游戏剩余次数=="..gameData.smallGame.leftCount)
        local mapDatas = {};
        gameData.smallGame.mapDatas = mapDatas;
        local mapBlockCount = _GameDefine.MapBlockCount();
        local EnumSmallGameType = _GameDefine.EnumSmallGameType();
        for i=1,mapBlockCount do
            mapDatas[i] = {};
            mapDatas[i].valueType = _buffer:ReadByte();
            mapDatas[i].value     = tonumber(_buffer:ReadInt64Str()) --CSBufferToInt64(_buffer);
        end
        logYellow("mapDatas")
        logTable(mapDatas)
    --end

    if xpcall(
        function() 
           G_GlobalGame:DispatchEventByStringKey("GameData",gameData);
        end,
        function (msg)
        error(debug.traceback());
        --error("msg:" .. msg);
    end) then
    end
    --初始化完成
    G_GlobalGame._gameControl:InitSuccess();
end


function _CClientSession:_responseStartGame(_buffer)
    error("==============服务器返回开始游戏============")
    local _data = {};
    local  _GameDefine = GameRequire__("GameDefine");
    _data.userID = _buffer:ReadUInt32();--玩家id
    _data.bet    = _buffer:ReadInt();--下注值
    _data.addGold = tonumber(_buffer:ReadInt64Str()) --本次获得金币
    _data.comGold = tonumber(_buffer:ReadInt64Str()) --下注总金币
    _data.curGold= tonumber(_buffer:ReadInt64Str()) --本身的金币
    _data.multiple = _buffer:ReadByte();            --当前的倍数
    _data.caijin = tonumber(_buffer:ReadInt64Str()) --彩金
    _data.freeCount= _buffer:ReadInt(); --免费次数
    _data.datas  = {};
    _data.totalFightCount=0

    
    error("下注值==".._data.bet)
    error("本次获得金币==".._data.addGold )
    error("免费次数==".._data.freeCount)

    local xCount = _GameDefine.XCount();
    local yCount = _GameDefine.YCount();
    local data;

    local str="\n";
    for i=1,yCount do
        data = {};
        for j=1,xCount do
            data[j] = _buffer:ReadByte();
            str = str .. data[j] .. ",";
        end
        str = str .. "\n";
        _data.datas[i] = data;
    end
    log("服务器返回具体值：".."\n"..str)

    _data.wholeValue = _buffer:ReadByte(); --读取全盘类型
    _data.fightCount = _buffer:ReadByte(); --本次占领格子数量
    error("读取全盘类型==".._data.wholeValue)
    error("本次占领格子数量==".._data.fightCount)

    --if _data.fightCount>0 then
    _data.totalFightCount = _buffer:ReadByte();
    _data.addWarBaseGold  = tonumber(_buffer:ReadInt64Str()) --CSBufferToInt64(_buffer);
    _data.totalWarBaseGold = tonumber(_buffer:ReadInt64Str()) --CSBufferToInt64(_buffer);
    error("已占领的个数==".._data.totalFightCount)
    if (_data.fightCount>0) then
        if (_data.totalFightCount>=_GameDefine.CellCount()) then
                --只有这样有效
            _data.warCount = _buffer:ReadByte();
            error("剩余征战次数==".._data.warCount)
        end
    end

    --end
    G_GlobalGame:DispatchEventByStringKey("ResponseStartGame",_data);
    --error("isResponseData Over!!");
end

function _CClientSession:_responseStartSmallGame(_buffer)
    logBlue("============服务器返回小游戏数据============")
    local _data = {};
    _data.userID = _buffer:ReadUInt32();
    _data.ret    = _buffer:ReadByte();   --0 没有， 1金币奖励	2 次数+2, 3次数+3 , 4 倍率X2, 5倍率X3,6 特奖
    _data.addWarGold= tonumber(_buffer:ReadInt64Str()) --CSBufferToInt64(_buffer);
    _data.curWarGold= tonumber(_buffer:ReadInt64Str()) --CSBufferToInt64(_buffer);
    _data.caijin = tonumber(_buffer:ReadInt64Str()) --CSBufferToInt64(_buffer);
    _data.multiple = _buffer:ReadByte();
    _data.leftCount = _buffer:ReadByte();
    if (_data.leftCount<=0) then
        _data.addGold = tonumber(_buffer:ReadInt64Str()) --CSBufferToInt64(_buffer);
        _data.curGold = tonumber(_buffer:ReadInt64Str()) --CSBufferToInt64(_buffer);
    end

    error("奖励类型==".._data.ret)
    error("当前区域的金币值==".._data.addWarGold)
    error("当前征战获得金币==".._data.curWarGold)
    error("彩金==".._data.caijin)
    error("当前倍数==".._data.multiple)
    error("剩余次数==".._data.leftCount)
    if (_data.leftCount<=0) then
        error("征战获得的总金币==".._data.addGold)
        error("自身的金币==".._data.curGold)
    end
    G_GlobalGame:DispatchEventByStringKey("ResponseSmallGame",_data);
end

function _CClientSession:_responseCaiJin(_buffer)
    local _caijinData = {};
    _caijinData.caijin    = tonumber(_buffer:ReadInt64Str()) --CSBufferToInt64(_buffer);
    G_GlobalGame:DispatchEventByStringKey("ResponseCaijin",_caijinData);
end

return _CClientSession;