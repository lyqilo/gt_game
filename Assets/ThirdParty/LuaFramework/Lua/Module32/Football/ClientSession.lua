--=========客户端协议===============---

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

--加载场景完成，进入游戏成功
function _CClientSession:OnSceneInfoHandler(wMaiID, wSubID, buffer, wSize)
    error("通知场景消息")
    G_GlobalGame:DispatchEventByStringKey("NotifySceneInfo");  --通知场景消息
end

--获取消息
function _CClientSession:GetBaseMsg(_buffer)
    local version,errorCode;
    version     = _buffer:ReadUInt16();
    errorCode   = _buffer:ReadUInt16();
    return version,code,errorCode;
end

--消息处理--游戏消息
function _CClientSession:OnMessageHandler(wMaiID, wSubID, buffer, wSize)
    local CommandDefine = G_GlobalGame.GameCommandDefine.SC_CMD;
    local cmd = tonumber(string.sub(wSubID, string.len(tostring(wMaiID)) + 1, string.len(tostring(wSubID) ) ) );

    --local version,code,errorCode = self:GetBaseMsg(buffer);
    if (cmd == CommandDefine.Game_Config) then   --游戏配置      100
        self:_notifyGameConfig(buffer);

    elseif (cmd == CommandDefine.Game_Data) then  --用于断线重连 101
        --暂时保留
        self:_notifyGameData(buffer);

    elseif (cmd == CommandDefine.StartGame) then --开始游戏      102
        self:_responseStartGame(buffer);

    elseif (cmd == CommandDefine.StartBallGame) then --点球大战   103
        self:_responseStartBallGame(buffer);

    elseif (cmd == CommandDefine.ResponseCaiJin) then --响应彩金  104
        self:_responseCaiJin(buffer);
    end
end


--=====发送消息的结构函数--玩家登陆
function _CClientSession:SendLogin()
    error("发送消息--玩家登陆")
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

--==坐下
function _CClientSession:SendSitDown()
    error("发送消息--玩家坐下")
    local bf = ByteBuffer.New();
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, bf, gameSocketNumber.GameSocket);--2 --7
end

--登陆完成
function _CClientSession:OnLoginOver()
    logYellow("登陆完成")
    G_GlobalGame._gameControl:OnLoginOver();
    G_GlobalGame._clientSession:SendSitDown();

end

--玩家登陆成功
function _CClientSession:OnLoginSuccess()
    --error("玩家登陆成功")
    G_GlobalGame:DispatchEventByStringKey("LoginSuccess"); --无
end

--玩家登陆失败
function _CClientSession:OnLoginFailed()
    --error("入座失败")
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
        --error("入座成功!!");
    else
        -- 入座失败
       -- Network.OnException(95008);
        HallScenPanel.NetException("Failed to enter room", gameSocketNumber.GameSocket);
    end
end

--玩家进入
function _CClientSession:OnUserEnter()
    error("玩家进入点球大战")
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
        G_GlobalGame:DispatchEventByStringKey("UserEnter",userInfo); --玩家進入      10004
        --end
        --xTryCatch(ab,handler(G_GlobalGame,G_GlobalGame.writeLog));
    end
end

--玩家离开
function _CClientSession:OnUserLeave()
    error("玩家离开点球大战")
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
            G_GlobalGame:DispatchEventByStringKey("UserLeave",userInfo);--玩家離開      10005
        --end
        --xTryCatch(ab,handler(G_GlobalGame,G_GlobalGame.writeLog));
    end
end


--切换到后台
function _CClientSession:OnStopGame()
    --切到后台不做处理
end

function _CClientSession:OnBackGame()
    if self.isreqStart then
        G_GlobalGame._clientSession:OnReloadGame()
    end
end

--失去连接
function _CClientSession:Disconnect()
    --error("失去连接")

    table.insert(ReturnNotShowError, "95003");
    NetManager:Disconnect(gameSocketNumber.GameSocket);
    --重新加载游戏
    G_GlobalGame._gameControl:ReloadGame();
    G_GlobalGame:DispatchEventByStringKey("ReloadGame");--无
end

--重新加载游戏
function _CClientSession:OnReloadGame()
    logYellow("重新加载游戏")
    G_GlobalGame._clientSession:SendLogin();
    -- G_GlobalGame._clientSession._snetCode      = nil;
    -- G_GlobalGame._clientSession._uid           = nil;
    -- G_GlobalGame._clientSession._chairId       = nil;
    -- G_GlobalGame._clientSession._verifyCode    = nil;
    -- G_GlobalGame._clientSession._isNotifyGameData = false;
end

function _CClientSession:OnBiaoAction()

end

--用户积分
function _CClientSession:OnUserScore()
    --error("通知玩家分数改变")
    G_GlobalGame:DispatchEventByStringKey("UserScore",{chairId=TableUserInfo._9wChairID,gold=TableUserInfo._7wGold});--通知玩家分数改变 10008
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
--100--1
function _CClientSession:SendStartGame(bet)--下注倍数
    error("客户端请求开始游戏")
    bet = bet or 1;
    local bf = self:_createByteBuffer();
    bf:WriteInt(bet);--下注值
    Network.Send(MH.MDM_GF_GAME, G_GlobalGame.GameCommandDefine.CS_CMD.StartGame, bf, gameSocketNumber.GameSocket);
    self.isreqStart=false;
end

--客户端请求点球
--100--2
function _CClientSession:SendStartBallGame()
    error("客户端请求点球")
    local bf = self:_createByteBuffer();
    Network.Send(MH.MDM_GF_GAME, G_GlobalGame.GameCommandDefine.CS_CMD.StartBallGame, bf, gameSocketNumber.GameSocket);
    self.isreqStart=false;
end

--客户端请求彩金
--100--3
function _CClientSession:SendStartCaiJin()
    local bf = self:_createByteBuffer();
    Network.Send(MH.MDM_GF_GAME, G_GlobalGame.GameCommandDefine.CS_CMD.RequestCaiJin, bf, gameSocketNumber.GameSocket);
end


function _CClientSession:_createByteBuffer()
    local bf = ByteBuffer.New();
    bf:WriteUInt16(G_GlobalGame.ConstDefine.GAME_VERSION); --版本默认0
    bf:WriteUInt16(0); --验证码  
    return bf;
end

--读取游戏配置项
function _CClientSession:_notifyGameConfig(_buffer)
    local  _GameDefine = GameRequire__("GameDefine");

    local betCount = _buffer:ReadByte();--可以选择的下注数
    for i=1,betCount do
       -- _GameDefine.PushBet(_buffer:ReadInt());--5 10 15 20 25 
        local betNum=_buffer:ReadInt()
        _GameDefine.PushBet(betNum);--5 10 15 20 25 
    end
    --设置图标倍率
    _GameDefine.SetIconMultiple()

    --设置线
    _GameDefine.SetLine()

    -- local iconMultipleCount = _buffer:ReadByte();--总图标数
    -- for i=1,iconMultipleCount do
    --     local iconValue = _buffer:ReadByte()+1;       

    --     for j=1,5 do
    --         --_GameDefine.SetIconMultiple(iconValue,_buffer:ReadByte(),_buffer:ReadInt());--图标的个数   每个的倍数   1  ==0     2==0    3==...
    --     end
    -- end

    --具体线
    -- local lineCount = _buffer:ReadByte();--总线数 
    -- local number;
    -- for i=1,lineCount do
    --     -- number = _buffer:ReadByte(); --第几条线
    --     -- _GameDefine.SetLine(number,_buffer:ReadByte()+1,_buffer:ReadByte()+1,_buffer:ReadByte()+1,_buffer:ReadByte()+1,_buffer:ReadByte()+1);--具体位置
    -- end


    --通知游戏配置
    G_GlobalGame:DispatchEventByStringKey("GameConfig",nil); --游戏设置 10001
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

--读取游戏数据
function _CClientSession:_notifyGameData(_buffer)
    local  _GameDefine = GameRequire__("GameDefine");
    Number=Number+1
    error("读取游戏数据")
    self._isNotifyGameData = true
    do
        self._uid      = _buffer:ReadUInt32();--玩家ID
        self._snetCode = _buffer:ReadUInt16();--
        self._chairId  = _buffer:ReadUInt16();--座位ID
        self._tableID  = _buffer:ReadUInt16();--0
    end

    --游戏中的基本信息
    local gameData = {};
    gameData.userState =_buffer:ReadByte();    --玩家状态  0 普通模式， 1 点球模式 , 2 免费模式
    gameData.freeCount =_buffer:ReadByte();    --免费次数
    gameData.multiple  =_buffer:ReadByte();    --当前倍率
    local n1= _buffer:ReadInt(); 
    if Number==1 then
        gameData.bet =n1          --下注值
        NumBet=n1
    else
        gameData.bet=NumBet
    end

    gameData.gold      =tonumber(_buffer:ReadInt64Str())    --CSBufferToInt64(_buffer); --金币
    gameData.caijin    =tonumber(_buffer:ReadInt64Str())     -- CSBufferToInt64(_buffer); --彩金


    error("玩家状态---------"..gameData.userState)
    error("免费次数---------"..gameData.freeCount)    
    error("下注值---------"..gameData.bet)

    if gameData.freeCount <= 0 then
        local index = CheckNear(gameData.gold,_GameDefine.GetBetList());
        gameData.bet = _GameDefine.GetBet(index);
    end
    --玩家座位信息
    local chairsData = {};
    chairsData[1] = {};
    chairsData[1].userId = self._uid;
    chairsData[1].chairId = self._chairId;
    chairsData[1].gold   = gameData.gold;
    chairsData[1].isOwner = true;
    G_GlobalGame:DispatchEventByStringKey("ChairsData",chairsData);--椅子数据      10003

    if xpcall(function()
        G_GlobalGame:DispatchEventByStringKey("GameData",gameData);--游戏数据      10002
    end,
    function (msg)
        --error(debug.traceback());
        --error("msg:" .. msg);
    end) then
    end
    --初始化完成
    G_GlobalGame._gameControl:InitSuccess();
end

-- local   ballNum=0;
-- local   freeNum=0;

--开始游戏
function _CClientSession:_responseStartGame(_buffer)
    error("开始游戏--S-->C")
    local _startGameData = {};
    local  _GameDefine = GameRequire__("GameDefine");
    --error("--=======================================================================================--")
    _startGameData.userID = _buffer:ReadUInt32(); --玩家ID
    _startGameData.bet    = _buffer:ReadInt();  --下注
    _startGameData.comGold=tonumber(_buffer:ReadInt64Str())  --CSBufferToInt64(_buffer); --一次获得的金币
    _startGameData.addGold=tonumber(_buffer:ReadInt64Str()) --CSBufferToInt64(_buffer);--一下注的金币
    _startGameData.curGold=tonumber(_buffer:ReadInt64Str())  --CSBufferToInt64(_buffer);--本身的金币
    _startGameData.caijin =tonumber(_buffer:ReadInt64Str())  --CSBufferToInt64(_buffer);--彩金
    _startGameData.freeCount= _buffer:ReadInt();     --免费次数

    -- error("一次获得的金币==".._startGameData.comGold)
    -- error("下注的金币==".._startGameData.addGold)
    -- error("本身的金币==".._startGameData.curGold)
    -- error("彩金==".._startGameData.caijin)
    -- error("免费次数==".._startGameData.freeCount)
    -- error("--=======================================================================================--")

    _startGameData.datas  = {};

    local xCount = _GameDefine.XCount();
    local yCount = _GameDefine.YCount();
    local data;
    for i=1,4 do --4
        data = {};
        for j=1,5 do --5
            data[j] = _buffer:ReadByte()+1;
        end
        _startGameData.datas[i] = data;
    end


--    error("总共运行--"..ballNum.."次，共计免费次数--"..freeNum.."--免费概率为"..math.floor((freeNum/ballNum)*100 )/100 )
    
    --发送消息--去绑定事件-->ui开始
    G_GlobalGame:DispatchEventByStringKey("ResponseStartGame",_startGameData); --开始游戏 10011 
end


--开始点球
function _CClientSession:_responseStartBallGame(_buffer)
    --freeNum=freeNum+1;
    error("开始点球--S-->C")
    local _startBallGameData = {};
    _startBallGameData.userID = _buffer:ReadUInt32(); --玩家ID
    _startBallGameData.ret    = _buffer:ReadByte();   --免费奖励的类型 0 没有， 1金币奖励	2 金币翻倍 

    _startBallGameData.addGold=tonumber(_buffer:ReadInt64Str())  --CSBufferToInt64(_buffer);  获得的金币
    _startBallGameData.curGold=tonumber(_buffer:ReadInt64Str())  --CSBufferToInt64(_buffer);  本身的金币
    _startBallGameData.caijin =tonumber(_buffer:ReadInt64Str())  --CSBufferToInt64(_buffer);--彩金
    _startBallGameData.multiple = _buffer:ReadByte();--倍数

    error("获得的金币:...".._startBallGameData.addGold)
    error("本身的金币:...".._startBallGameData.curGold)
    error("彩金:...".._startBallGameData.caijin)
    error("倍数:...".._startBallGameData.multiple)

    if _startBallGameData.ret ~= 1 then
        _startBallGameData.addGold = 0;
    end

    G_GlobalGame:DispatchEventByStringKey("ResponseBallGame",_startBallGameData);--点球10012
end

--彩金
function _CClientSession:_responseCaiJin(_buffer)
    local _caijinData = {};
    _caijinData.caijin    =tonumber(_buffer:ReadInt64Str())  --CSBufferToInt64(_buffer);--彩金 
    G_GlobalGame:DispatchEventByStringKey("ResponseCaijin",_caijinData); --彩金10013
end

return _CClientSession;