--[[
游戏逻辑控制

--]]

local BalanceData = class("SI_BalanceData");

function BalanceData:ctor(_dragonData)
    self._drill = 0;
    self._addGold = 0;
    self._curGold = 0;
    self._addExp = 0;
    self._curExp = 0;
    self._isNextStage = false;
    self._dragonData = _dragonData;
end

function BalanceData:Reset()
    self._drill = 0;
    self._addGold = 0;
    self._curGold = 0;
    self._addExp = 0;
    self._curExp = 0;
    self._isNextStage = false;
end

local DragonData = class("SI_DragonData")
function DragonData:ctor()
    self._dragonStage = 1;
    self._curExp = 0;
    self._nextLeftExp = 0;
    self._nextNeedExp = 0;
    self._isUpgrade = false;
end

-- 设置经验
function DragonData:SetExp(_exp)
    self._curExp = _exp;
    self._dragonStage, self._nextLeftExp, self._nextNeedExp = SI_DRAGON_STAGE_DATA:getDragonStageInfo(self._curExp);
end

-- 增加经验
function DragonData:AddExp(_exp)
    local dragonStage = self._dragonStage;
    self._curExp = self._curExp + _exp;
    if self._nextNeedExp == 0 then
        -- 已经升级到最高级了
        self._nextLeftExp = self._nextLeftExp + _exp;
    else
        self._dragonStage, self._nextLeftExp, self._nextNeedExp = SI_DRAGON_STAGE_DATA:getDragonStageInfo(self._curExp);
        if self._dragonStage ~= dragonStage then
            self._isUpgrade = true;
        else
            self._isUpgrade = false;
        end
    end
end

-- 减少经验
function DragonData:ReduceExp(_exp)
    self._curExp = self._curExp - _exp;
    self._dragonStage, self._nextLeftExp, self._nextNeedExp = SI_DRAGON_STAGE_DATA:getDragonStageInfo(self._curExp);
end

-- 获取百分比
function DragonData:GetDragonPrecent()
    if self._nextNeedExp == 0 then
        return 1;
    else
        return self._nextLeftExp * 1.0 / self._nextNeedExp;
    end
end

-- 获取龙珠关卡
function DragonData:GetDragonStage()
    return self._dragonStage;
end

local GameData = GameRequire("SI_GameData");

local PlayerData = GameRequire("SI_PlayerData");

-- local PlayerInfoList = GameRequire("SI_PlayerInfoList");

local GameControl = class("GameControl");

-- 游戏管理
function GameControl:ctor()
    self._mode = SI_GAME_MODE.Hand;
    self._step = SI_GAME_STEP.Bet;
    self._gameData = GameData.New();
    self._gameData:ResetStage(1);
    self._rowDatas = nil;
    self._fallDownSeq = { fallIndex = 1 };
    self._curLines = 0;
    self._dragonData = DragonData.New();
    self._balanceData = BalanceData.New(self._dragonData);
    self._isInit = false;
    -- 下落完成事件通知
    GlobalGame._eventSystem:RegEvent(SI_EventID.FallDownOverCallBack, self, self.OnPanelFalldownOver);
    GlobalGame._eventSystem:RegEvent(SI_EventID.ClearDrillOverCallBack, self, self.OnPanelClearDrillOver);
    GlobalGame._eventSystem:RegEvent(SI_EventID.ClearStoneLinesCallBack, self, self.OnPanelClearStoneOver);
    GlobalGame._eventSystem:RegEvent(SI_EventID.MoveStoneOverCallback, self, self.OnPanelMoveStoneOver);
    GlobalGame._eventSystem:RegEvent(SI_EventID.JiLeiShowCallBack, self, self.OnPanelJiLeiShowOver);
end

-- 是否自动
function GameControl:IsAuto()
    return self._mode == ST_GAME_MODE.Auto;
end

-- 自动
function GameControl:Auto()
    self._mode = ST_GAME_MODE.Auto;
end

-- 手动
function GameControl:StopAuto()
    self._mode = SI_GAME_MODE.Hand;
end

-- 每帧执行
function GameControl:Update(_dt)

end

-- 接受到玩家自己的数据
function GameControl:RecivePlayerData(_playerData)
    if self._playerData == nil then
        self._playerData = PlayerData.New(_playerData);
        GlobalGame._eventSystem:DispatchEvent(SI_EventID.NotifyUserEnter, self._playerData);
    else
        local playData = PlayerData.New(_playerData);
        GlobalGame._eventSystem:DispatchEvent(SI_EventID.NotifyUserEnter, playData);
    end
end

-- 是否是玩家自己
function GameControl:IsMySelf(_uid)
    return self._playerData._uid == _uid;
end

function GameControl:GetMyUid()
    return self._playerData._uid;
end

-- 初始化关卡
function GameControl:_initStage()
    self._step = SI_GAME_STEP.InitStage;
end

-- 下落完成
function GameControl:OnPanelFalldownOver()
    -- 计算锥子
    self:_countDrill();
end

-- 清理下
function GameControl:OnPanelClearDrillOver()
    local vec = self._gameData:ClearDrill();
    -- local vec = self._gameData:ArrageStonesNode();
    GlobalGame._eventSystem:DispatchEvent(SI_EventID.NotifyUIMoveStone, vec);
end

-- 积累奖显示结束
function GameControl:OnPanelJiLeiShowOver()
    self._step = SI_GAME_STEP.ClearStone;
    -- 通知界面去清除石头
    GlobalGame._eventSystem:DispatchEvent(SI_EventID.NotifyUIClearStone, self._gameData:GetLines());
end

-- 当移动宝石结束后
function GameControl:OnPanelMoveStoneOver()
    -- 随机下落顺序
    self:RandomFallDownSeq();
    -- 通知UI界面落宝石
    GlobalGame._eventSystem:DispatchEvent(SI_EventID.NotifyUIFallStone);
end

-- 清理宝石结束后
function GameControl:OnPanelClearStoneOver()
    local vec = self._gameData:ArrageStonesNode();
    GlobalGame._eventSystem:DispatchEvent(SI_EventID.NotifyUIMoveStone, vec);
end

-- 落下宝石
function GameControl:_fallStone()
    self._step = SI_GAME_STEP.FallStone;
end

-- 计算钻头
function GameControl:_countDrill()
    self._step = SI_GAME_STEP.CountDrill;
    -- 计算钻头
    self._gameData:CountDrill();
    -- 清除锥子
    self:_clearDrill();
end

function GameControl:_clearDrill()
    local size = self._gameData:GetDrillSize();
    if size == 0 then
        -- 没有钻头
        self._step = SI_GAME_STEP.CountStone;
        self:_countStone();
    else
        self._step = SI_GAME_STEP.ClearDrill;
        -- 去掉砖头
        if not self._balanceData._isNextStage then
            self._balanceData._isNextStage = self._gameData:ClearBrick(size);
        end
        -- 通知UI界面清除钻头
        GlobalGame._eventSystem:DispatchEvent(SI_EventID.NotifyUIClearDrill, self._gameData:GetDrills());
    end
end

-- 计算石头组合
function GameControl:_countStone()
    -- 清除组合
    self._gameData:CountStones();
    local size = self._gameData:GetLineSize();
    if size == 0 then
        self._step = SI_GAME_STEP.Balance;
        -- 增加玩家的钱
        -- self._playerData:AddGold(self._balanceData._addGold);
        GlobalGame._eventSystem:DispatchEvent(SI_EventID.NotifyUIBalance, self._balanceData);
        -- 下一关
        if self._balanceData._isNextStage then
            self._gameData:NextStage();
        end
    else
        local vec = self._gameData:GetLines();
        if self._balanceData._jileiCount == 0 then
            self._step = SI_GAME_STEP.ClearStone;
            -- 通知界面去清除石头
            GlobalGame._eventSystem:DispatchEvent(SI_EventID.NotifyUIClearStone, self._gameData:GetLines());
        else
            local value = vec:get(1);
            if value:size() == self._balanceData._jileiCount then
                local val = value:get(1);
                local _type = val._value;
                local multiple = SI_STAGE_DATA:getBet(1, self._selectBetIndex) / SI_ROOM_DATA.baseBet;
                if _type == nil then
                    error("_type is nil");
                end
                if self._curLines == nil then
                    error("curLines isNil");
                end
                local gold = SI_STONE_PRICE[_type][value:size()] * multiple * self._curLines;
                log("赢取金币："..gold);
                gold = self._balanceData._jilei - gold;
                self._step = SI_GAME_STEP.JiLeiShow;
                GlobalGame._eventSystem:DispatchEvent(SI_EventID.NotifyUIJiLeiShow, gold);
            else
                self._step = SI_GAME_STEP.ClearStone;
                -- 通知界面去清除石头
                GlobalGame._eventSystem:DispatchEvent(SI_EventID.NotifyUIClearStone, self._gameData:GetLines());
            end
        end
        -- self._gameData:ArrageStonesNode();
    end
end

function GameControl:_clearStone()

end

-- 下一步
function GameControl:NextStep()
    if self._step == SI_GAME_STEP.Bet then
        self:_initStage();
    elseif self._step == SI_GAME_STEP.InitStage then
        self:_fallStone();
    elseif self._step == SI_GAME_STEP.FallStone then
        self:_countDrill();
    elseif self._step == SI_GAME_STEP.ClearDrill then
        self:_fallStone();
    elseif self._step == SI_GAME_STEP.CountStone then
    elseif self._step == SI_GAME_STEP.ClearStone then
        if self._gameData:IsFull() then
            self._step = SI_GAME_STEP.Balance;
        else
            -- 还有空的格子
            self._step = SI_GAME_STEP.FallStone;
        end
    end
end


local num=0

function GameControl:_Zero()
    num=0
end

function GameControl:retNum()
    return num
end

function GameControl:NotifySceneInfo(_buffer)
    num=num+1
    local errCode = _buffer:ReadInt();
    logYellow("errCode=="..errCode.."---"..SI_ERROR_CODE.ErrCode_Null)
    -- 错误码
    if errCode ~= SI_ERROR_CODE.ErrCode_Null then
        return;
    end

    -- 房间的基本宝石
    SI_ROOM_DATA.baseBet = _buffer:ReadInt();
    -- 宝石配置
    -- 宝石关卡，每关的配置  --有默认值
    for i = 1, SI_MAX_STAGE do
        SI_STAGE_DATA[i].stage = _buffer:ReadByte();
        -- 关卡
        SI_STAGE_DATA[i].minCount = _buffer:ReadByte();
        -- 最小列数
        SI_STAGE_DATA[i].xCount = _buffer:ReadByte();
        -- 列数
        SI_STAGE_DATA[i].yCount = _buffer:ReadByte();
        -- 行数
        SI_STAGE_DATA[i].firstBet = _buffer:ReadInt();
        -- 每一个最低押注，默认押注
        SI_STAGE_DATA[i].betInterval = _buffer:ReadInt();
        -- 下注间隔倍数
        SI_STAGE_DATA[i].betCount = _buffer:ReadInt();
        -- 筹码列表个数
    end
    logTable(SI_STAGE_DATA);
    -- 龙珠关卡，倍率是一样的 --有默认值
    local stage
    SI_DRAGON_STAGE_DATA[1].ballCount = 1;
    -- 探宝环节球的数量
    for j = 1, SI_DRAGON_ITEMS_COUNT_PRE_STAGE do
        SI_DRAGON_STAGE_DATA[1].items[j].i8_type = _buffer:ReadByte();
        -- 类型，都是1
        SI_DRAGON_STAGE_DATA[1].items[j].i32_multiple = _buffer:ReadInt();
        -- 火盆倍率
        log("SI_DRAGON_STAGE_DATA[1].items[j].i8_type:" .. SI_DRAGON_STAGE_DATA[1].items[j].i8_type .. " SI_DRAGON_STAGE_DATA[1].items[j].i32_multiple:" .. SI_DRAGON_STAGE_DATA[1].items[j].i32_multiple)
    end

    local datas = {
        stage = _buffer:ReadInt() + 1,
        -- 关卡
        brickCount = _buffer:ReadInt(),
        -- 剩余的砖
        isDragon = _buffer:ReadByte(),
        -- 是否探宝
        isClear = _buffer:ReadByte();-- 数据是否被清除
        brickIndex = 0;
    };
    self._playerData._Chis=SI_STAGE_DATA[datas.stage].firstBet*   SI_STAGE_DATA[datas.stage].betCount;
    datas.brickIndex = datas.brickCount;
    datas.brickCount = SI_STAGE_BRICKS - datas.brickCount + 1;
    log("宝箱下标：" .. datas.brickIndex .. " 宝箱数量：" .. datas.brickCount);
    logYellow("isDragon=="..datas.isDragon)
    self._gameData:ResetStage(datas.stage, datas.brickCount);

    local betSize = 50;
    -- 下注历史 列表长度50
    local betDetail = { };
    for i = 1, betSize do
        -- 下注情况
        betDetail[i] = { }
        betDetail[i].bet = 0;
        -- 都是0
        betDetail[i].count = 0;
        -- 都是0
    end
    self._playerData:SetBetDetail(betDetail, betSize);
    -- 设置玩家下注详情
    GlobalGame._eventSystem:DispatchEvent(SI_EventID.NotifySceneInfo, datas);
    local _caijin = 0;
    GlobalGame._eventSystem:DispatchEvent(SI_EventID.NotifyUICaiJin, _caijin);
    self._isInit = true;
end

-- 响应开始游戏
function GameControl:ResponseStartGame(_buffer)
    logYellow("响应开始游戏")
    local errCode = _buffer:ReadInt();
    if errCode ~= SI_ERROR_CODE.ErrCode_Null then
        return;
    end
    local rowDatas = { };
    self._gameData:ResetData();-- 初始化数据
    rowDatas.betIndex = _buffer:ReadByte();  -- 线数
    rowDatas.multiple = _buffer:ReadByte();-- 倍数
    local baseBet = SI_STAGE_DATA:getBet(self._gameData:GetStage(), self._selectBetIndex);
    baseBet = baseBet *  self._curLines;
    logYellow("===================扣钱："..baseBet)
    self._playerData._Chis=baseBet; -- 总扣的钱数
    local xCount = _buffer:ReadByte(); -- 读取服务器通知的数据
    rowDatas.xCount = xCount;
    local count;
    local row;
    local ramIndex;
    local tmp = { };
    local tmpCount = 0;
    for i = 1, 6 do
        local mc = _buffer:ReadByte();
        row = { };
        row.data = { };
        for j = 1, 64 do
            local stonType = _buffer:ReadByte();
            -- 宝石类型
            if stonType ~= 0 then
                row.data[j] = stonType;
                if row.data[j] ~= SI_STONE_TYPE.Drill then
                    tmpCount = tmpCount + 1;
                    tmp[tmpCount] = row.data[j];
                end
            end
        end
        if mc ~= 0 then
            rowDatas[i] = row;
            rowDatas[i].fallIndex = 1;
        end
    end
    self._balanceData:Reset();-- 初始化结算数据
    self._balanceData._drill = _buffer:ReadByte();
    self._balanceData._addGold = int64.tonum2(_buffer:ReadInt64());
    logYellow("================================")
    -- local testGold =;
    -- logYellow("testGold ："..testGold)
    self._balanceData._curGold = tonumber(_buffer:ReadInt64Str()) --int64.tonum2(testGold);
    self._balanceData._jilei = int64.tonum2(_buffer:ReadInt64());
    self._balanceData._jileiCount = _buffer:ReadByte(); -- 积累奖的个数
    local _caijin = int64.tonum2(_buffer:ReadInt64());
    self._rowDatas = rowDatas;
    logTable(self._rowDatas);
    -- log("self._balanceData._addGold:"..self._balanceData._addGold.."  self._balanceData._curGold:"..self._balanceData._curGold.." totalBet:"..totalBet.."  rowDatas.multiple:".. rowDatas.multiple.." rowDatas.betIndex:"..rowDatas.betIndex)
    local function StartGame()
        self._playerData:ReduceBet( rowDatas.multiple);
        self._playerData:SetGold(self._balanceData._curGold);
        GlobalGame._eventSystem:DispatchEvent(SI_EventID.NotifyChangeGold, self._playerData:GetGold());  -- 玩家扣钱
        self:RandomFallDownSeq(); -- 随机下落顺序
        GlobalGame._eventSystem:DispatchEvent(SI_EventID.NotifyStartGame); -- 通知开始游戏
        GlobalGame._eventSystem:DispatchEvent(SI_EventID.NotifyUIFallStone);-- 通知UI界面开始游戏
        GlobalGame._eventSystem:DispatchEvent(SI_EventID.NotifyUICaiJin, _caijin); -- 彩金值
       
    end
    GlobalGame._eventSystem:DispatchEvent(SI_EventID.NotifyOpenStartGame, StartGame);-- 开关入口函数通知过去
end

-- 响应龙珠关卡
function GameControl:ResponseDragonMission(_buffer)
    logYellow("响应龙珠关卡")
    local errCode = _buffer:ReadInt();
    logYellow("errCode=="..errCode.."---"..SI_ERROR_CODE.ErrCode_Null)
    if errCode ~= SI_ERROR_CODE.ErrCode_Null then
        return;
    end
    logYellow("响应龙珠关卡1111")

    local datas = {
        stage = 1,
        itemCount = 1,
        items = { },
        fallCount = 1,
        fallTargets = { },
        earnGold = 0,
        curGold = 0,
        readData = function(_datas, _buffer)
            -- 每一关龙珠奖励
            _datas.fallTargets[1] = _buffer:ReadByte() + 1;
            _datas.bet = _buffer:ReadInt();
            _datas.earnGold = int64.tonum2(_buffer:ReadUInt64());
            _datas.curGold = int64.tonum2(_buffer:ReadUInt64());
            log(" _datas.fallTargets[1]:" .. _datas.fallTargets[1] .. " _datas.bet:" .. _datas.bet .. " _datas.earnGold:" .. _datas.earnGold .. " _datas.curGold:" .. _datas.curGold)

        end,
    };
    datas:readData(_buffer);
    self._dragonRetData = datas;
    self._playerData:SetGold(datas.curGold);
    GlobalGame._eventSystem:DispatchEvent(SI_EventID.NotifyDragonMission, self._dragonRetData);
    -- 事件通知龙珠开始
end

function GameControl:GetBetMoreTimes()
    return self._playerData:GetBetMoreTimes();
end

-- 响应彩金
function GameControl:ResponseCaijin(_buffer)
    local errCode = _buffer:ReadInt();
    if errCode ~= SI_ERROR_CODE.ErrCode_Null then
        return;
    end
    local caijin = _buffer:ReadInt();
    log("彩金返回：" .. caijin);
    -- 彩金值
    GlobalGame._eventSystem:DispatchEvent(SI_EventID.NotifyUICaiJin, caijin);
end

-- 响应玩家列表
function GameControl:ResponsePlayerList(_buffer)
    local errCode = _buffer:ReadInt();
    if errCode ~= SI_ERROR_CODE.ErrCode_Null then
        return;
    end
    local version = _buffer:ReadInt();
    -- 还是同一个列表
    if version == self._playerInfoList._version then
        return;
    end
    self._playerInfoList._version = version;
    -- 清空玩家列表
    self._playerInfoList:Clear();
    -- 获取玩家数据
    local count = _buffer:ReadInt();
    -- error("recive count:" .. count);
    local uid, dragonExp, gold, name
    for i = 1, count do
        uid = _buffer:ReadUInt32();
        dragonExp = _buffer:ReadInt();
        gold = int64.tonum2(_buffer:ReadInt64());
        name = _buffer:ReadString();
        self._playerInfoList:AddPlayer(uid, dragonExp, gold, name);
    end

    -- 事件通知玩家列表
    GlobalGame._eventSystem:DispatchEvent(SI_EventID.ResponsePlayerList, self._playerInfoList);
end

-- 下一个宝石
function GameControl:NextStone(xIndex)
    if self._rowDatas.xCount < xIndex or xIndex < 0 then
        return nil;
    end
    local rowDatas = self._rowDatas[xIndex];
    local val = rowDatas.data[rowDatas.yIndex];
    rowDatas.yIndex = rowDatas.yIndex + 1;
    return val;
end

-- 得到下一个宝石  //用于展示
function GameControl:GetNextStone(xIndex)
    if self._rowDatas.xCount < xIndex or xIndex < 0 then
        return nil;
    end
    local rowDatas = self._rowDatas[xIndex];
    return rowDatas.data[rowDatas.yIndex];
end

-- 请求彩金
function GameControl:RequestCaiJin()
    local bf = ByteBuffer.New();
    -- error("RequestCaiJin");
    Network.Send(MH.MDM_GF_GAME, SI_CMD.RequestCaijin, bf, gameSocketNumber.GameSocket);
end

-- 请求开始游戏
function GameControl:RequestStartGame(_multiple, _betIndex)
    if not self._isInit then
        log("未初始化");
        return;
    end
    local bf = ByteBuffer.New();
    bf:WriteByte(_betIndex);
      bf:WriteByte(_multiple);
    -- 记录当前线数
    self._curLines = _multiple;
    self._selectBetIndex = _betIndex;
    log("=====================================游戏开始==========================================")
    log("下注下标："..self._selectBetIndex.." 当前线数："..  self._curLines)
    Network.Send(MH.MDM_GF_GAME, SI_CMD.RequestStartGame, bf, gameSocketNumber.GameSocket);
end

-- 请求龙珠关卡
function GameControl:RequestDragonBallMission()
    local bf = ByteBuffer.New();
    Network.Send(MH.MDM_GF_GAME, SI_CMD.RequestDragonMission, bf, gameSocketNumber.GameSocket);
end

-- 请求玩家列表
function GameControl:RequestPlayerList()
    local bf = ByteBuffer.New();
    bf:WriteInt(self._playerInfoList._version);
    Network.Send(MH.MDM_GF_GAME, SI_CMD.RequestPlayerList, bf, gameSocketNumber.GameSocket);
end

-- 随机下落顺序
function GameControl:RandomFallDownSeq()
    local tempRandom = { };
    local count = self._gameData:XCount();
    local j, index
    local rowDatas, fallIndex
    fallIndex = 1;
    -- self._fallDownSeq = {};
    self._fallDownSeq.fallIndex = 1;
    local ret, _x, _y;
    local _type;
    local _readArea = { };
    local isFull = true;
    while (true) do
        j = 1;
        isFull = true;
        for i = 1, count do
            if self._gameData:IsRowFull(i) then
                if _readArea[i] == nil then
                    tempRandom[j] = i;
                    j = j + 1;
                end
            else
                tempRandom[j] = i;
                j = j + 1;
            end
        end
        index = math.random(1, j - 1);
        _x = tempRandom[index];
        rowDatas = self._rowDatas[_x];
        _type = rowDatas.data[rowDatas.fallIndex];
        if _type == nil then
            error("超出 _x:" .. _x .. ",fallIndex:" .. rowDatas.fallIndex);
        end
        if self._gameData:IsRowFull(_x) then
            _readArea[_x] = 1;
            _y = -1;
        else
            ret, _, _y = self._gameData:FallIn(_x, _type);
            rowDatas.fallIndex = rowDatas.fallIndex + 1;
        end
        self._fallDownSeq[fallIndex] = { };
        self._fallDownSeq[fallIndex].fallX = _x;
        self._fallDownSeq[fallIndex].fallY = _y;
        -- 下落位置
        self._fallDownSeq[fallIndex]._type = _type;
        fallIndex = fallIndex + 1;
        if (self._gameData:IsFull()) then
            for i = 1, count do
                if _readArea[i] == nil then
                    isFull = false;
                end
            end
            if isFull then
                -- 如果待落区都满了
                break;
            end
        end
    end
    self._fallDownSeq[fallIndex] = nil;
end

-- 下一个落下的数据
function GameControl:NextFallData()
    local index = self._fallDownSeq.fallIndex;
    self._fallDownSeq.fallIndex = index + 1;
    if index > #self._fallDownSeq then
        return nil;
    end
    return self._fallDownSeq[index];
end

-- 得到下一个宝石
function GameControl:GetNextStone(xIndex)
    local rowData = self._rowDatas[xIndex];
    if not rowData then
        return nil;
    end
    return rowData.data[rowData.fallIndex];
end

return GameControl;