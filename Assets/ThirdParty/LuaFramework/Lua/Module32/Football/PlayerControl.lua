local GameDefine = GameRequire__("GameDefine");
local GameData   = GameRequire__("GameData");
local _CCreator   = GameRequire__("GOCreator");

local _CPlayer = class("Player");

function _CPlayer:ctor()
    self.freeCount = 0;
    self.gold      = 0;
    self.isBallGame= false;
    self.isFreeGame= false;
    self.bet       = 0;
    self.multiple  = 1; --当前倍率
    self.gameData  = GameData.New();  --游戏数据
    self.chairID   = G_GlobalGame.ConstDefine.C_S_INVALID_CHAIR_ID;

    --免费统计
    self.freeTotalCount = 0;
    self.freeGet   = 0;
    self.isFreeGet = false;
end

function _CPlayer:Init()
    self.freeCount = 0;
    self.gold      = 0;
    self.isBallGame= false;
    self.isFreeGame= false;
    self.bet       = 0;
    self.multiple  = 1; --当前倍率
end

function _CPlayer:OnInitData(chairData)
    self.gold = chairData.gold;
end

--免费游戏
function _CPlayer:FreeGame()
    self.isFreeGame = true;
    self.isBallGame = true;
end

--玩家每帧执行
function _CPlayer:Update(dt)

end

function _CPlayer:OnGameRet(_gameData)
    self.bet = _gameData.bet;
    self.gold = _gameData.curGold;
    if self.isFreeGet then
        self.freeGet = self.freeGet + _gameData.comGold;
        --self.freeGet = self.freeGet + _gameData.addGold;
    end
    self.gameData:Clear();
    self.freeCount = _gameData.freeCount;

    local xCount = GameDefine.XCount();
    local yCount = GameDefine.YCount();

    for i=1,yCount do
        for j=1,xCount do
            self.gameData:SetValue(j,i,_gameData.datas[i][j]);
        end
    end

    local ret = self.gameData:GetRet();
    if ret.isFreeGame then
        self:FreeGame();
    end
    return ret;
end

function _CPlayer:OnBallGameRet(_ballGameData)
    self.gold = _ballGameData.curGold;
    self.freeGet = self.freeGet + _ballGameData.addGold;
    self.multiple = _ballGameData.multiple;
    self.isBallGame = false;
end

function _CPlayer:GetGameRet()
    return self.gameData:GetRet();
end

--获取是否免费游戏
function _CPlayer:IsInFreeGame()
    return self.isFreeGame;
end

--获取是否点球
function _CPlayer:IsBallGame()
    return self.isBallGame;
end

--获取金币
function _CPlayer:GetGold()
    return self.gold;
end

function _CPlayer:ReduceGold(_gold)
    if self.gold>=_gold then
        self.gold = self.gold - _gold;
        self.isFreeGet = false;
        self.freeTotalCount = 0;
        self.freeGet   = 0;
        return true;
    end
    return false;
end

function _CPlayer:ReduceFreeCount(_freeCount)
    if self.freeCount>=_freeCount then
        self.freeCount = self.freeCount - _freeCount;
        self.freeTotalCount = self.freeTotalCount + 1;
        self.isFreeGet = true;
        if self.freeCount<=0 then
            self.isFreeGame = false;
            self.multiple = 1;
        end
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

function _CPlayer:OnUserLeave(_data)
    -- error("玩家退出")
    -- --卸载资源
    -- _CCreator:clear();
    -- --下一个加载的场景名字
    -- GameNextScenName = gameScenName.HALL;
    -- --卸载消息绑定
    -- MessgeEventRegister.Game_Messge_Un();
    -- --加载下一个场景
    -- GameSetsBtnInfo.LuaGameQuit();
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
    local curPlayer = self.players[self.chairIds[self.myChairId]];
    curPlayer.freeCount = _eventData.freeCount;
    curPlayer.gold      = _eventData.gold;
    curPlayer.bet       = _eventData.bet;
    curPlayer.multiple  = _eventData.multiple; --倍率
    if _eventData.userState == 2 then
        curPlayer.isBallGame = false; 
        curPlayer.isFreeGame = true; 
    elseif _eventData.userState ==1 then
        curPlayer.isBallGame = true;
        curPlayer.isFreeGame = false;
    else
        curPlayer.isBallGame = false;
        curPlayer.isFreeGame = false;
    end
    
end

--玩家进入游戏
function _CPlayersControl:OnUserEnter(_user)
    local curPlayer = self.players[self.chairIds[_user.chairId]];
    --UID对应座位号
    self._userIdsMap:assign(_user.uid,_user.chairId);
    --需要在这里生成炮台
    --curPlayer:OnUserEnter(_user,_isOwner);
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

function _CPlayersControl:OnBallGameCallBack(_gameData)
    local chairId = self.userIdsMap:value(_gameData.userID);
    local curPlayer = self.players[self.chairIds[chairId]];
    if curPlayer==nil then
        return ;
    end
    return curPlayer:OnBallGameRet(_gameData);
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

return _CPlayersControl;
