local GameDefine = GameRequire__("GameDefine");
local GameData   = GameRequire__("GameData");

local _CPlayer = class("Player");

function _CPlayer:ctor()
    self.freeCount = 0;
    self.gold      = 0;
    self.isFreeGame= false;
    self.bet       = 0;
    self.multiple  = 1; --当前倍率
    self.gameData  = GameData.New();  --游戏数据
    self.chairID   = G_GlobalGame.ConstDefine.C_S_INVALID_CHAIR_ID;
    self.curRet    = {freeCount=0,getFreeCount =0,extraFreeCount=0,wholeValue =0, extraMultiple=0,multiple=1,clearCells={},
    sepClears={},isEnterFightGame = false,warCount=0,addWarBaseGold = 0,totalWarBaseGold = 0 ,fightCount=0}; --当局结果

    --免费统计
    self.freeTotalCount = 0;
    self.freeGet   = 0;
    self.isFreeGet = false;
    --占领个数
    self.gameFightCount = 0;
    self.gameCellDatas = {};
    local xCount = GameDefine.XCount();
    local yCount = GameDefine.YCount();
    for i=1,yCount do
        self.gameCellDatas[i] = {};
        for j=1,xCount do
            self.gameCellDatas[i][j] = 0;
        end
    end

    self.isSmallGame = false;  --是否在小游戏中
    self.warGameMultiple = 1; --当前征战倍率
    self.curWarGold      = 0; --当前征战金币
    self.warCount        = 1; --当前剩余征战次数
    self.warResults      = {}; --征战结果 ,每个区域结果
    self.warItemCounts   = {}; --征战记录  每次结果点击次数
    self.warMaxGold      = 0;
    self.warMinGold      = 99999999999;
    local areaCount = GameDefine.GetWarAreaCount();
    local EnumSmallRet = GameDefine.EnumSmallGameType();
    for i=1,areaCount do
        self.warResults[i]      = {valueT = EnumSmallRet.EM_SmallGame_Null,value=0 }; --征战结果 ,每个区域结果        
    end
end

function _CPlayer:Init()
    self.freeCount = 0;
    self.gold      = 0;
    self.isFreeGame= false;
    self.bet       = 0;
    self.multiple  = 1; --当前倍率
    self:_initWarData();
end

function _CPlayer:OnInitData(chairData)
    self.gold = chairData.gold;
end

function _CPlayer:_initWarData()
    local areaCount = GameDefine.GetWarAreaCount();
    local EnumSmallRet = GameDefine.EnumSmallGameType();
    self.warGameMultiple = 1; --当前征战倍率
    self.curWarGold      = 0; --当前征战金币
    self.warCount        = 0; --当前剩余征战次数
    self.warMaxGold      = 0;
    self.warMinGold      = 99999999999;
    for i=1,areaCount do
        self.warResults[i].valueT = EnumSmallRet.EM_SmallGame_Null;    
    end
    for i=EnumSmallRet.EM_SmallGame_Gold,EnumSmallRet.EM_SmallGame_XMax do
        self.warItemCounts[i] = 0;
    end 
end


function _CPlayer:_setWarAreaData(pos,valueT,value,count,warGold,warMultiple)
    local result = self.warResults[pos];
    result.valueT  = valueT;
    result.value   = value;
    self.warCount = count;
    self.curWarGold = warGold;
    self.warGameMultiple = warMultiple;
    if self.warMaxGold< value then
        self.warMaxGold = value;
    end
    if self.warMinGold> value then
        self.warMinGold = value;
    end
    self.warItemCounts[valueT] = self.warItemCounts[valueT] + 1;
end

--免费游戏
function _CPlayer:FreeGame(_count)
    self.isFreeGame = true;
    self.freeCount  = _count;
end

function _CPlayer:WarGame(_count,_warGold)
    self:_initWarData();
    self.warCount = _count;
    self.curWarGold = _warGold;
    self.warGameMultiple = 1;
end

--减少征战点击次数
function _CPlayer:ReduceWarCount(_count)
    if self.warCount>=_count then
        self.warCount = self.warCount - _count;
        return true;
    end
    return false;
end

--获取征战剩余次数
function _CPlayer:WarCount()
    return self.warCount;
end

--获取征战倍率
function _CPlayer:WarMultiple()
    return self.warGameMultiple;
end

function _CPlayer:ResetWarData()
    self.gameFightCount = 0;
    local xCount = GameDefine.XCount();
    local yCount = GameDefine.YCount();
    for i=1,yCount do
        for j=1,xCount do
            self.gameCellDatas[i][j] = 0;
        end
    end
    self:_initWarData();
end

--获取征战金币
function _CPlayer:WarGold()
    return self.warGold;
end

--获取征战结果
function _CPlayer:GetWarInfo(pos)
    return self.warResults[pos].valueT,self.warResults[pos].value;
end


--玩家每帧执行
function _CPlayer:Update(dt)

end

function _CPlayer:OnGameRet(_gameData)
    self.bet = _gameData.bet;
    self.gold = _gameData.curGold;
    if self.isFreeGet then
        self.freeGet = self.freeGet + _gameData.addGold;
    end
    self.gameData:Clear();
    local xCount = GameDefine.XCount();
    local yCount = GameDefine.YCount();
    for i=1,yCount do
        for j=1,xCount do
            self.gameData:SetValue(j,i,_gameData.datas[i][j]);
        end
    end
    
    if (self.isFreeGame) then
        self.curRet.extraFreeCount = _gameData.freeCount - self.freeCount;
        self.curRet.extraMultiple  = _gameData.multiple - self.multiple;
        self.curRet.freeCount = _gameData.freeCount;
        self.curRet.getFreeCount = 0;
        self.curRet.multiple   = _gameData.multiple;
    else
        self.curRet.getFreeCount = _gameData.freeCount;
        self.curRet.extraFreeCount = 0;
        self.curRet.extraMultiple = 0;
        self.curRet.freeCount     = _gameData.freeCount;
        self.curRet.multiple   = _gameData.multiple;
    end
    self.multiple = _gameData.multiple;
    self.curRet.wholeValue = _gameData.wholeValue;

    local ret = self.gameData:GetRet();
    self.gameData:_FreeCount(_gameData.freeCount)

    if _gameData.freeCount>0 then
        self:FreeGame(_gameData.freeCount);
    end
--    local str="gameCell:\n";
--    for i=1,yCount do
--        for j=1,xCount do
--            str = str .. self.gameCellDatas[i][j] .. ",";
--        end
--        str = str .. "\n";
--    end
--    error(str);
--    local count = #ret.lines;
--    for i=1,count do
--        local line =  ret.lines[i];
--        error("NO:" .. line.lineNO .. ",value:" .. line.value .. ",count:" .. line.count);
--    end
--    local count1 = #ret.comCells;
--    for i=1,count1 do
--        error("x:" .. ret.comCells[i].x .. ",y:" ..ret.comCells[i].y);
--    end
    self.curRet.clearCells = {};
    self.curRet.sepClears   = {};
    local cellDatas;
    local count = 0;
    local x,y;
    local count1 = #ret.comCells;
    local fightCount = 0;

    for i=1,count1 do
        x = ret.comCells[i].x;
        y = ret.comCells[i].y;
        if self.gameCellDatas[y][x]==0 then
            self.gameCellDatas[y][x] = 1;
            cellDatas = {x=x,y=y};
            count = count + 1;
            fightCount = fightCount +1;
            self.curRet.clearCells[count] = cellDatas;
        end
    end

    count1 = #ret.sepCells; 
    count = 0;
    for i=1,count1 do
        x = ret.sepCells[i].x;
        y = ret.sepCells[i].y;

        if self.gameCellDatas[y][x]==0 then
            self.gameCellDatas[y][x] = 1;
            cellDatas = {x=x,y=y};
            count = count + 1;
            fightCount = fightCount + 1;
            self.curRet.sepClears[count] = cellDatas;
        end
    end
    if _gameData.fightCount ~= fightCount then
        error("Client fightCount:" .. fightCount .. ", Server fightCount:" .. _gameData.fightCount );
    end
--    local str="After gameCell:\n";
--    for i=1,yCount do
--        for j=1,xCount do
--            str = str .. self.gameCellDatas[i][j] .. ",";
--        end
--        str = str .. "\n";
--    end
--    error(str);
    --是否又占领了
    self.curRet.fightCount = _gameData.fightCount;
    if _gameData.fightCount>0 then

        self.gameFightCount = _gameData.totalFightCount;

        if (self.gameFightCount>=GameDefine.CellCount()) then
            self.curRet.isEnterFightGame = true;
            self.curRet.warCount = _gameData.warCount;
            self:WarGame(_gameData.warCount);
        else
            self.curRet.isEnterFightGame = false;
            self.curRet.warCount = 0;
        end

        self.curRet.totalWarBaseGold = _gameData.totalWarBaseGold;
        self.curRet.addWarBaseGold   = _gameData.addWarBaseGold;
        self.curWarGold = _gameData.totalWarBaseGold;
    else
        self.curRet.isEnterFightGame = false;
        self.curRet.warCount = 0;
        self.curRet.addWarBaseGold = 0;
    end
    return ret;
end

function _CPlayer:OnSmallGameRet(_smallGameData)
    self:_setWarAreaData(_smallGameData.pos,_smallGameData.ret,_smallGameData.addWarGold,
        _smallGameData.leftCount,
        _smallGameData.curWarGold,_smallGameData.multiple)
    if _smallGameData.leftCount <=0 then
        --没有次数了，征战结束
        self.gold = _smallGameData.curGold;
        local areaCount = GameDefine.GetWarAreaCount();
        local EnumSmallRet = GameDefine.EnumSmallGameType();
        local count = 0;
        local itemLeftCounts = {};
        for i=EnumSmallRet.EM_SmallGame_Gold,EnumSmallRet.EM_SmallGame_XMax do
            itemLeftCounts[i] = GameDefine.GetItemCount(i) - self.warItemCounts[i];
            count = count + itemLeftCounts[i];
        end
        local value;
        --计算出剩余的没有点击的地方
        for j=1,areaCount do
            if self.warResults[j].valueT == EnumSmallRet.EM_SmallGame_Null then
                value = math.random(0,count-1);
                for k=EnumSmallRet.EM_SmallGame_Gold,EnumSmallRet.EM_SmallGame_XMax do
                    if value<itemLeftCounts[k] then
                        itemLeftCounts[k] = itemLeftCounts[k] - 1;
                        count = count - 1;
                        self.warResults[j].valueT = k;
                        break;
                    else
                        value = value - itemLeftCounts[k];
                    end
                end
                if self.warResults[j].valueT == EnumSmallRet.EM_SmallGame_Null then
                    self.warResults[j].valueT = EnumSmallRet.EM_SmallGame_Gold;
                end
                --编假的值
                self.warResults[j].value  = math.random(self.warMinGold,self.warMaxGold);
            end
        end
        self.isSmallGame = false;
    end
end

function _CPlayer:GetGameRet()
    return self.gameData:GetRet(),self.curRet;
end

function _CPlayer:GetFightDetail()
    return self.curWarGold,self.gameFightCount,self.gameCellDatas;
end

--获取征收阶段的详情
function _CPlayer:GetWarDetail()
    return self.warCount,self.curWarGold,self.warGameMultiple,self.warResults;
end

function _CPlayer:IsInFreeGame()
    return self.isFreeGame;
end

function _CPlayer:IsSmallGame()
    return self.isSmallGame;
end

function _CPlayer:GetGold()
    return self.gold;
end

function _CPlayer:ReduceGold(_gold)
    if self.gold>=_gold then
        self.gold = self.gold - _gold;
        self.freeTotalCount = 0;
        self.freeGet   = 0;
        self.isFreeGet = false;
        self.isFreeGame = false;
        self.multiple = 1;
        return true;
    end
    return false;
end

function _CPlayer:ReduceFreeCount(_freeCount)
    if self.freeCount>=_freeCount then
        self.freeCount = self.freeCount - _freeCount;
        self.freeTotalCount = self.freeTotalCount + 1;
        self.isFreeGet = true;
        self.isFreeGame = true;
        return true;
    end
    return false;
end

function _CPlayer:FreeCount()
    return self.freeCount;
end

function _CPlayer:Multiple()
    return self.multiple;
end

--获取免费统计
function _CPlayer:GetFreeTotal()
    return self.freeTotalCount,self.freeGet;
end

local _CPlayersControl = class("PlayersControl");

function _CPlayersControl:ctor()
    self.players = {};
    self.chairIds = {};
    self.myChairId = -1;
    self.onlineCount = 0;
    self.isEmpty  = true;
    self.userIdsMap = map:new();
end

function _CPlayersControl:Init()
    local maxPlayerCount = G_GlobalGame.ConstDefine.C_S_PLAYER_COUNT;
    local player = nil;
    for i=1,maxPlayerCount do
        player = _CPlayer.New();
        player:Init();
        self.players[i] = player;
    end
end

function _CPlayersControl:OnLineCount()
    return self.onlineCount;
end

--玩家管理
function _CPlayersControl:Update(dt)
    
end

function _CPlayersControl:OnChairsData(_eventData)
    if self.isEmpty then
        self.chairIds[0]=1;
        self.chairIds[1]=2;
        self.chairIds[2]=3;
        self.chairIds[3]=4;        
        self.isEmpty = false;
    end
    local maxPlayerCount = G_GlobalGame.ConstDefine.C_S_PLAYER_COUNT;
    local curPlayer;
    local chairData;
    for i=1,maxPlayerCount do
        chairData = _eventData[i];
        if (chairData~=nil) then
            curPlayer = self.players[self.chairIds[chairData.chairId]];
            if chairData.userId == G_GlobalGame.ConstDefine.C_S_INVALID_USER_ID then 
                --没有玩家
            else
                self.userIdsMap:assign(chairData.userId,chairData.chairId);
            end
            curPlayer:OnInitData(chairData);
            if chairData.isOwner then
                self.myChairId = chairData.chairId;
            end 
        end
    end
end

function _CPlayersControl:OnGameData(_eventData)
    log("游戏数据返回")
    local Enum_ServerState = GameDefine.EnumServerState();
    local curPlayer = self.players[self.chairIds[self.myChairId]];
    curPlayer.freeCount = _eventData.freeCount;
    curPlayer.gold      = _eventData.gold;
    curPlayer.bet       = _eventData.bet;
    curPlayer.multiple  = _eventData.multiple; --倍率
    --if _eventData.userState == Enum_ServerState.EM_ServerState_Normal or _eventData.userState ==Enum_ServerState.EM_ServerState_FreeGame then
        curPlayer.isWarGame = false;
        curPlayer.curWarGold   = _eventData.baseWarGold;
        local xCount = GameDefine.XCount();
        local yCount = GameDefine.YCount();
        for i=1,yCount do
            for j=1,xCount do
                curPlayer.gameCellDatas[i][j] = _eventData.warCellDatas[i][j];
            end
        end
        curPlayer.gameFightCount = _eventData.fightCount;
    --elseif _eventData.userState ==Enum_ServerState.EM_ServerState_SmallGame then
        local mapBlockCount = GameDefine.MapBlockCount();
        local EnumSmallGameType = GameDefine.EnumSmallGameType();
        curPlayer.isWarGame = true;
        curPlayer.curWarGold   = _eventData.smallGame.warTotalGold;
        curPlayer.warGameMultiple= _eventData.smallGame.multiple;
        curPlayer.warCount  = _eventData.smallGame.leftCount;
        local mapDatas = _eventData.smallGame.mapDatas;
        for i=1,mapBlockCount do
            if mapDatas[i].valueType ~= EnumSmallGameType.EM_SmallGame_Null then
                curPlayer.warResults[i].valueT = mapDatas[i].valueType;
                curPlayer.warResults[i].value  = mapDatas[i].value;
                curPlayer.warItemCounts[mapDatas[i].valueType] = curPlayer.warItemCounts[mapDatas[i].valueType] + 1;
            end
        end
    --end
    if curPlayer.freeCount>0 then
        curPlayer.isFreeGame= true;
    else
        curPlayer.isFreeGame = false;
    end
    _CPlayer.isInitOver=true;
end

--玩家进入游戏
function _CPlayersControl:OnUserEnter(_user)
    local curPlayer = self.players[self.chairIds[_user.chairId]];
    --UID对应座位号
    self._userIdsMap:assign(_user.uid,_user.chairId);
    --需要在这里生成炮台
    curPlayer:OnUserEnter(_user,_isOwner);
end

--玩家离开游戏
function _CPlayersControl:OnUserLeave(_user)
    local chairId = self.userIdsMap:erase(_user.uid);
    if chairId then
        local curPlayer = self.players[self.chairIds[chairId]];
        curPlayer:OnUserLeave(_user);
    end
end

--游戏数据回来
function _CPlayersControl:OnPlayGameCallBack(_gameData)
    local chairId = self.userIdsMap:value(_gameData.userID);
    local curPlayer = self.players[self.chairIds[chairId]];
    if curPlayer==nil then
        return ;
    end
    return curPlayer:OnGameRet(_gameData);
end

function _CPlayersControl:OnSmallGameCallBack(_gameData)
    local chairId = self.userIdsMap:value(_gameData.userID);
    local curPlayer = self.players[self.chairIds[chairId]];
    if curPlayer==nil then
        return ;
    end
    return curPlayer:OnSmallGameRet(_gameData);
end

function _CPlayersControl:MyPlayer()
    if self.myChairId == G_GlobalGame.ConstDefine.C_S_INVALID_CHAIR_ID then
        return nil;
    else
        return self.players[self.chairIds[self.myChairId]];
    end
end

function _CPlayersControl:GetGameRet(_userID)
    local chairId = self.userIdsMap:value(_userID);
    local curPlayer = self.players[self.chairIds[chairId]];
    return curPlayer:GetGameRet();
end

function _CPlayersControl:GetSelfGameRet()
    local curPlayer = self.players[self.chairIds[self.myChairId]];
    return curPlayer:GetGameRet();
end

--获取征战进度
function _CPlayersControl:GetFightDetail()
    local curPlayer = self.players[self.chairIds[self.myChairId]];
    return curPlayer:GetFightDetail();
end

function _CPlayersControl:GetWarDetail()
    local curPlayer = self.players[self.chairIds[self.myChairId]];
    return curPlayer:GetWarDetail();
end

function _CPlayersControl:GetGameRetByChaird(_chairID)
    local curPlayer = self.players[self.chairIds[_chairID]];
    return curPlayer:GetGameRet();
end

function _CPlayersControl:OnRechargeGold(_gold)
    local curPlayer = self.players[self.chairIds[self.myChairId]];
    return curPlayer:ReduceGold(_gold);
end

function _CPlayersControl:OnRechargeFreeCount(freeCount)
    local curPlayer = self.players[self.chairIds[self.myChairId]];
    return curPlayer:ReduceFreeCount(freeCount);
end

function _CPlayersControl:OnCanRechargeGold(_gold)
    local curPlayer = self.players[self.chairIds[self.myChairId]];
    if curPlayer:GetGold()>=_gold then
        return true;
    end
    return false;
end

function _CPlayersControl:OnCanReduceFreeCount(_count)
    local curPlayer = self.players[self.chairIds[self.myChairId]];
    if curPlayer:FreeCount()>=_count then
        return true;
    end
    return false;
end

function _CPlayersControl:OnCanReduceSmallGameCount(_count)
    local curPlayer = self.players[self.chairIds[self.myChairId]];
    if curPlayer:WarCount()>=_count then
        return true;
    end
    return false;
end

function _CPlayersControl:OnRechargeWarCount(_count)
    local curPlayer = self.players[self.chairIds[self.myChairId]];
    return curPlayer:ReduceWarCount(freeCount);
end

function _CPlayersControl:OnResetWarData()
    local curPlayer = self.players[self.chairIds[self.myChairId]];
    curPlayer:ResetWarData();
end

return _CPlayersControl;
