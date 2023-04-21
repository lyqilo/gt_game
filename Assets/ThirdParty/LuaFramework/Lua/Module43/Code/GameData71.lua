--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
--[[
enum NiuNiuType
{
	NiuType_0,
	NiuType_1,
	NiuType_2,
	NiuType_3,
	NiuType_4,
	NiuType_5,
	NiuType_6,
	NiuType_7,
	NiuType_8,
	NiuType_9,
	NiuType_NiuNiu,
	NiuType_ZhiZunNiu,		//五花牛
	NiuType_ZhaDan,			//炸弹
	NiuType_WuXiaoNiu,
};
]]

local GameData71 = {}

local self = GameData71

function GameData71.Init()
    self.CurBetIndex = 1
    self.BetList = {}
    self.UpBankerList = {}
    self.CurBanker = {}
    self.NextChangeBanker = nil
    self.CurLastBankerTurns = 0
    self.LuDan = {}
    self.BankerAreaWin = {}--庄家每个区域输赢量  天地玄黄庄
    self.AreaWin = {}--庄家区域输赢   0 输   1   赢       天地玄黄庄
    self.CardType = {} --牌型 天地玄黄庄
    self.CardList = {{}, {}, {}, {}, {}}    --天地玄黄庄
    self.GameState = {GAME_STATE_CHIP = 0, GAME_STATE_SEND_POKER = 1, GAME_STATE_GAME_OVER = 2, GAME_STATE_GAME_WAIT = 3}
    self.CurGameState = nil
    self.TopThree = {{}, {}, {}} --冠亚季
    self.BankerWin = 0 --庄家输赢
   
end

function GameData71.InitBeList(data)
    logError("12312312")
    self.BetList = {}
    for i = 1, #data do
        if(data[i] ~= nil)then
            self.BetList[i] = data[i]
        else
            logError("传入注值是空值: "..i)
        end
    end
end

function GameData71.SetTopThree(data)
    for k, v in pairs(data) do
        self.TopThree[k] = v
    end
end

function GameData71.GetAllBankerWin()
    return self.BankerAreaWin[1] + self.BankerAreaWin[2] + self.BankerAreaWin[3] + self.BankerAreaWin[4]
end

function GameData71.SetBankerAreaWin()
    if(self.AreaWin[1] == 0)then
        self.BankerAreaWin[1] = -self.TianArea_Bet
    else
        self.BankerAreaWin[1] = self.TianArea_Bet
    end

    if(self.AreaWin[2] == 0)then
        self.BankerAreaWin[2] = -self.DiArea_Bet
    else
        self.BankerAreaWin[2] = self.DiArea_Bet
    end

    if(self.AreaWin[3] == 0)then
        self.BankerAreaWin[3] = -self.XuanArea_Bet
    else
        self.BankerAreaWin[3] = self.XuanArea_Bet
    end

    if(self.AreaWin[4] == 0)then
        self.BankerAreaWin[4] = -self.HuangArea_Bet
    else
        self.BankerAreaWin[4] = self.HuangArea_Bet
    end
end

function GameData71.SetAreaWin(data)
    self.AreaWin = data
end

function GameData71.SetCardType(data)
    self.CardType = data
end

function GameData71.SetCardData(data)
    self.CardList = data
end

function GameData71.SetBankerData(data)
    self.CurBanker = {}
    self.CurBanker.ChairId = data.ChairId
    logError("data.ChairId: "..tostring(data.ChairId))
    if(self.CurBanker.ChairId >= 65535)then
        self.CurBanker.name = "bank"
    else
        self.CurBanker.name = data.name
    end
    self.CurBanker.money = data.money
    self.CurBanker.TurnCount = data.TurnCount
end

function GameData71.SetnLimitChip(data)
    self.LimitChip = data
end

function GameData71.SetLuDan(data)
    self.LuDan = data
end

function GameData71.SetAllTurnsIInfo(data)
    self.Allturns = data.Allturns 
    self.Winturns_Tian = data.winturns_Tian
    self.Loseturns_Tian = data.loseturns_Tian
    self.Winturns_Di = data.winturns_Di
    self.Loseturns_Di = data.loseturns_Di
    self.Winturns_Xuan = data.winturns_Xuan
    self.Loseturns_Xuan = data.loseturns_Xuan
    self.Winturns_Huang = data.winturns_Huang
    self.Loseturns_Huang = data.loseturns_Huang
end  

function GameData71.AddNewRecord(playerWinarea)
    self.Allturns = self.Allturns + 1
    if(playerWinarea[1] > 0)then
        self.Loseturns_Tian = self.Loseturns_Tian + 1
    else
        self.Winturns_Tian = self.Winturns_Tian + 1
    end

    if(playerWinarea[2] > 0)then
        self.Loseturns_Di = self.Loseturns_Di + 1
    else
        self.Winturns_Di = self.Winturns_Di + 1
    end

    if(playerWinarea[3] > 0)then
        self.Loseturns_Xuan = self.Loseturns_Xuan + 1
    else
        self.Winturns_Xuan = self.Winturns_Xuan + 1
    end

    if(playerWinarea[4] > 0)then
        self.Loseturns_Huang = self.Loseturns_Huang + 1
    else
        self.Winturns_Huang = self.Winturns_Huang + 1
    end
end

function GameData71.InitAllBetData(data)
    self.TianArea_Bet = data[1]
    self.DiArea_Bet = data[2]
    self.XuanArea_Bet = data[3]
    self.HuangArea_Bet = data[4]
end

function GameData71.ResetData()
    self.TianArea_Bet = 0
    self.DiArea_Bet = 0
    self.XuanArea_Bet = 0
    self.HuangArea_Bet = 0

    self.AreaWin = {0, 0, 0, 0}
    self.BankerAreaWin = {0, 0, 0, 0}
    self.CardList = {{}, {}, {}, {}, {}}
    self.CardType = {}
end

function GameData71.AddAllBetData(data)
    self.TianArea_Bet = self.TianArea_Bet + data[1]
    self.DiArea_Bet = self.DiArea_Bet + data[2]
    self.XuanArea_Bet = self.XuanArea_Bet + data[3]
    self.HuangArea_Bet = self.HuangArea_Bet + data[4]
end

function GameData71.GetAllBet()
    local allbet = 0
    allbet = allbet + self.TianArea_Bet + self.DiArea_Bet + self.XuanArea_Bet + self.HuangArea_Bet
    return allbet
end

function GameData71.SetGameState(data)
     if(data == 0)then
        self.CurGameState = self.GameState.GAME_STATE_CHIP
    elseif(data == 1)then
        self.CurGameState = self.GameState.GAME_STATE_SEND_POKER
    elseif(data == 2)then
        self.CurGameState = self.GameState.GAME_STATE_GAME_OVER
    elseif(data == 3)then
        self.CurGameState = self.GameState.GAME_STATE_GAME_WAIT
    else
        logError("self.CurGameState is error: "..data)
    end
end

function GameData71.SetUpBankerList(data)
    self.UpBankerList = {}
    for i = 1, # data do
        if(data[i] ~= nil)then
            self.UpBankerList[i] = data[i]
        else
            logError("上庄列表有空值: "..i)
        end
    end
end

return GameData71
--endregion
