local PlayerData = class("PlayerData");

--玩家数据
function PlayerData:ctor(_data)
    if not (_data) then
        return ;
    end
    self._uid                   = _data._uid; --uid
    self._name                  = _data._name; --姓名
    self._gold                  = _data._gold; --金币
    self._sex                   = _data._sex; --性别
    self._chairId               = _data._chairId;  --座位号
    self._customHead            = 0; --自定义头像
    self._customExtensionName   = _data._customExtensionName;
    self._score                 = _data._score; --积分
    self._betDetail             = {};
    self._betCount              = 0;
    self._Chis                  = 50;
end

--增加积分
function PlayerData:AddScore(_score)
    self._score = self._score + _score;
end

--设置积分
function PlayerData:SetScore(_score)
    self._score = _score;
end

--获取玩家积分
function PlayerData:Score()
    return self._score;
end

--更改金币数
function PlayerData:AddGold(gold)
    self._gold = self._gold + gold;
end

--更改金币数
function PlayerData:ReCodeGold(gold)
    self._gold = self._gold - gold;
end

--设置金币数
function PlayerData:SetGold(gold)
    self._gold = gold;
end

--获取金币
function PlayerData:GetGold()
    return self._gold;
end

--是否金币足够
function PlayerData:IsEnoughGold(gold)
    return self._gold>= gold;
end

function PlayerData:SetBetDetail(betDetail,betCount)
    self._betDetail = betDetail;
    self._betCount  = betCount;
end

function PlayerData:ReduceBet(bet)
    self:AddGold(-bet);
    local betInfo;
    for i=1,self._betCount do
        betInfo = self._betDetail[i];
        if betInfo.bet == bet then
            betInfo.count = betInfo.count + 1;
            return ;
        end
    end
    self._betCount = self._betCount + 1;
    betInfo= {};
    self._betDetail[self._betCount] = betInfo;
    betInfo.bet = bet;
    betInfo.count = 1;
end

function PlayerData:GetBetMoreTimes()
    return self._Chis;
end

return PlayerData;