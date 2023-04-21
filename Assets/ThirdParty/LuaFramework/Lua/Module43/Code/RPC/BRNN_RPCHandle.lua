
BRNN_RPCHandle = {};
local self = BRNN_RPCHandle;

self.RpcBase = nil;

function BRNN_RPCHandle.OnAeake()
    self.RpcBase = BRNN_RPCBase:new();
    self.RpcBase:RegisterSystemMessage();
    --//庄家信息返回
    self.RpcBase:RegisterNetMessage(BRNN_CMD.SUB_SC_BANKER_INFO, self.BankInfo_Reslut);
    --//请求上庄返回
    self.RpcBase:RegisterNetMessage(BRNN_CMD.SUB_SC_REQUEST_BANKER, self.UpBankInfo_Reslut);
    --//玩家下庄
    self.RpcBase:RegisterNetMessage(BRNN_CMD.SUB_SC_LOSE_BANKER, self.DownBank_Result);
    --//开始下注
    self.RpcBase:RegisterNetMessage(BRNN_CMD.SUB_SC_BEGIN_CHIP, self.BeginBeginBet);
    --//更新下注值
    self.RpcBase:RegisterNetMessage(BRNN_CMD.SUB_SC_UPDATE_CHIP_VALUE, self.UpdateBet);
    --//玩家下注返回
    self.RpcBase:RegisterNetMessage(BRNN_CMD.SUB_SC_PLAYER_CHIP, self.PlayerBet_Result);
    --//下注失败
    self.RpcBase:RegisterNetMessage(BRNN_CMD.SUB_SC_CHIP_FAIL, self.BetFail);
    --//停止下注
    self.RpcBase:RegisterNetMessage(BRNN_CMD.SUB_SC_STOP_CHIP, self.StopBet);
    --//发牌
    self.RpcBase:RegisterNetMessage(BRNN_CMD.SUB_SC_SEND_POKER, self.FlopCard);
    --//游戏结束
    self.RpcBase:RegisterNetMessage(BRNN_CMD.SUB_SC_GAME_OVER, self.GameOver);
    --//上庄列表
    self.RpcBase:RegisterNetMessage(BRNN_CMD.SUB_SC_BANKER_LIST, self.UpBankList);
end
function BRNN_RPCHandle.OnDestroy()
    logError("OnDestroy  001")
   
    self.RpcBase:ClearRegisterMessage();
end

-- =================================框架消息=======================================
function BRNN_RPCHandle.UserJoinSite(wMaiID, wSubID, buffer, wSize)
    error("=============入座=============")
    if (wSize > 0) then
        error("=============入座失败=============")
    else
        error("=============入座成功=============")
        BRNN_RPCSend.PlayerPrepare()
    end
end
function BRNN_RPCHandle.SocketOutLine(wMaiID, wSubID, buffer, wSize)
    Game71Panel.QuitGame();
end
function BRNN_RPCHandle.LogicSuccess(buff, size)
    log("登录成功: "..TableUserInfo._9wChairID);
    --Game71Panel.Mine.ChairId = TableUserInfo._9wChairID

end
function BRNN_RPCHandle.LoginOver(wMaiID, wSubID, buffer, wSize)
    error("=============OnGameLogonOver============= 桌子ID")
    --if (65535 ==  Game71Panel.Mine.ChairId) then --不在桌子上
        BRNN_RPCSend.PlayerInSeat()
    --else --若在桌子上 则直接发送玩家准备
       -- BRNN_RPCSend.PlayerPrepare();
    --end
end
function BRNN_RPCHandle.LoginFail(wMaiID, wSubID, buffer, wSize)
    error("=============登陆失败=============")
    LoadingPanel.Close()
end
function BRNN_RPCHandle.UserJoin(wMaiID, wSubID, buffer, wSize)
    error("=============用户进入============= chairID ") --TableUserInfo._1dwUser_Id)
    --
    logTable(TableUserInfo)

    local UserInfo =    {
        _uid = TableUserInfo._1dwUser_Id,
        _name = TableUserInfo._2szNickName,
        _sex = TableUserInfo._3bySex,
        _customHeader = TableUserInfo._4bCustomHeader,
        _customExtensionName = TableUserInfo._5szHeaderExtensionName,
        _gold = TableUserInfo._7wGold,
        _chairId = TableUserInfo._9wChairID,
    };

    if (TableUserInfo._1dwUser_Id == SCPlayerInfo._01dwUser_Id) then
         logError("设置自己信息")
         Game71Panel.Mine.ChairId = TableUserInfo._9wChairID
         Game71Panel.Mine.name = TableUserInfo._2szNickName
         Game71Panel.Mine.Money = TableUserInfo._7wGold
         Game71Panel.Mine.Id = TableUserInfo._1dwUser_Id
        
         Game71Panel.Mine.spName = TableUserInfo._5szHeaderExtensionName
         local play = {}
         play.ChairId = TableUserInfo._9wChairID
         play.name = TableUserInfo._2szNickName
         play.Money = TableUserInfo._7wGold
         play.Id = TableUserInfo._1dwUser_Id
       
         play.spName = TableUserInfo._5szHeaderExtensionName
         Game71Panel.AddPlayerInfo(play)

    else
        logError("添加其他玩家")
        local play = {}
        play.ChairId = TableUserInfo._9wChairID
        play.name = TableUserInfo._2szNickName
        play.Money = TableUserInfo._7wGold
        play.Id = TableUserInfo._1dwUser_Id
      
        play.spName = TableUserInfo._5szHeaderExtensionName
        Game71Panel.AddPlayerInfo(play)
    end
    logTable(UserInfo)
    -- LogicDataSpace.UserNick = TableUserInfo._2szNickName
    -- LogicDataSpace.UserGold = TableUserInfo._7wGold
    -- LogicDataSpace.Sex = TableUserInfo._3bySex
    -- SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestUserInfo.ProcedureName)
end
function BRNN_RPCHandle.UserLave(wMaiID, wSubID, buffer, wSize)
    error("=============玩家离开=============: "..tostring(TableUserInfo._1dwUser_Id))
    if (TableUserInfo._1dwUser_Id ~= SCPlayerInfo._01dwUser_Id) then
        Game71Panel.ShanChuPlayerInfo(TableUserInfo._1dwUser_Id)
    end
end
function BRNN_RPCHandle.UserState(wMaiID, wSubID, buffer, wSize)

end

function BRNN_RPCHandle.OpenHelp()
    Game71Panel.OpenHelp()
end

function BRNN_RPCHandle.UserScore(wMaiID, wSubID, buffer, wSize)
     local UserInfo =    {
        _uid = TableUserInfo._1dwUser_Id,
        _name = TableUserInfo._2szNickName,
        _sex = TableUserInfo._3bySex,
        _customHeader = TableUserInfo._4bCustomHeader,
        _customExtensionName = TableUserInfo._5szHeaderExtensionName,
        _gold = TableUserInfo._7wGold,
        _chairId = TableUserInfo._9wChairID,
    };
    if SCPlayerInfo._01dwUser_Id==UserInfo._uid then
        Game71Panel.UserInfo=UserInfo
    else
        Game71Panel.UpdatePlayerMoney(UserInfo)
    end
end
function BRNN_RPCHandle.QuitGame(wMaiID, wSubID, buffer, wSize)
    logError("122222222222222222221")
    Game71Panel.QuitGame()
    GameSetsBtnInfo.LuaGameQuit();
end
function BRNN_RPCHandle.JoinGameRoomInfo(wMaiID, wSubID, buffer, wSize)
    log("==============场景消息=============: "..tostring(wSize))
    Game71Panel.FristEnterScense(buffer)
    LoadingPanel.Close()
end

-- ================================游戏消息========================================
function BRNN_RPCHandle.BankInfo_Reslut(buff, size)
    log("===========================庄家信息返回============================")
    Game71Panel.UpdateBankerInfo(buff)
end
function BRNN_RPCHandle.UpBankInfo_Reslut(buff, size)
    log("===========================请求上庄返回============================")
    Game71Panel.UpBankeResult(buff)
end
function BRNN_RPCHandle.DownBank_Result(buff, size)
    log("===========================玩家下庄============================")
    Game71Panel.DownBankerResult(buff)
end
function BRNN_RPCHandle.BeginBeginBet(buff, size)
    log("===========================开始下注============================")
    Game71Panel.StartBet(buff)
end
function BRNN_RPCHandle.UpdateBet(buff, size)
    log("===========================更新下注值============================")
    --Game71Panel.UpdateBetInfo(buff)
end
function BRNN_RPCHandle.PlayerBet_Result(buff, size)
    log("===========================玩家下注返回============================")
    Game71Panel.PlayerBetResult(buff, size)
end
function BRNN_RPCHandle.BetFail(buff, size)
    log("===========================下注失败============================")
    Game71Panel.PlayerBetFail(buff)
end
function BRNN_RPCHandle.StopBet(buff, size)
    log("===========================停止下注============================")
    Game71Panel.StopBet(buff)
end
function BRNN_RPCHandle.FlopCard(buff, size)
    log("===========================发牌============================")
    Game71Panel.FlodCard(buff)
end
function BRNN_RPCHandle.GameOver(buff, size)
    log("===========================游戏结束============================")
    Game71Panel.GameResult(buff)
end
function BRNN_RPCHandle.UpBankList(buff, size)
    log("===========================上庄列表============================")
    Game71Panel.UpdateBakerList(buff)
end