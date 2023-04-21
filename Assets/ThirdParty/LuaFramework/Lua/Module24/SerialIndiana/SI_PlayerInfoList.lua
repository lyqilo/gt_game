local PlayerInfo=class("PlayerInfo");

function PlayerInfo:ctor(uid,name,dragonExp,gold)
    self._uid   = uid;
    self._name  = name;
    self._dragonExp = dragonExp;
    self._gold  = gold;
end

function PlayerInfo:SetDragonExp(dragonExp)
    self._dragonExp = dragonExp;
end

function PlayerInfo:SetGold(gold)
    self._gold  = gold;
end


local PlayerInfoList = class("PlayerInfoList");

function PlayerInfoList:ctor()
    self._playerMap = map:new();
    self._version   = 0;
end

function PlayerInfoList:Clear()
    self._playerMap:clear();
end

function PlayerInfoList:AddPlayer(uid,gold,dragonExp,name)
    local player = PlayerInfo.New(uid,name,gold,dragonExp);
    self._playerMap:insert(uid,player);
end

function PlayerInfoList:RemovePlayer(uid)
    return self._playerMap:erase(uid);
end

function PlayerInfoList:UpdatePlayerGold(uid,gold)
    local player = self._playerMap:value(uid);
    player:SetGold(gold);
end

function PlayerInfoList:GetPlayerByUid(_uid)
    return self._playerMap:value(_uid);
end

function PlayerInfoList:UpdatePlayerDragonExp(uid,dragonExp)
    local player = self._playerMap:value(uid);
    player:SetDragonExp(dragonExp);
end

function PlayerInfoList:Foreach(func)
    local it = self._playerMap:iter();
    local val = it();
    while(val) do
        func(self._playerMap:value(val));
        val = it();
    end
end

function PlayerInfoList:Count()
    return self._playerMap:size();
end

return PlayerInfoList;