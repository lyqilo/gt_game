--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local Player = {}

self = Player
function Player:ctor()
    logError(" Player:ctor--------------")
    self.ChairId = nil
    self.Money = nil
    self.name = nil
    self.Id = nil
    self.BankerState = 0 --0未上庄    1上庄列表中     2当庄中
    self.spName = nil
    self.Level = nil

    self.AllBetInfo = {0, 0, 0, 0}
    self.XuYaInfo = {0, 0, 0, 0}
    self.Win = {0, 0, 0 ,0}
end

function Player:GetAllCurBet()
    local allbetval = 0
    for k, v in pairs(self.AllBetInfo)do
        allbetval = allbetval + v
    end
    return allbetval
end

function Player:GetAllCurWin()
    return self.Win[1] + self.Win[2] + self.Win[3] + self.Win[4]
end

function Player:Enter()
    
end

function Player:Bet()
    
end

function Player:Leave()
    
end

function Player:JieSuan()
    
end

function Player:ResetData()
    self.AllBetInfo = {0, 0, 0, 0}
    self.Win = {0, 0, 0 ,0}
end

return Player


--endregion
