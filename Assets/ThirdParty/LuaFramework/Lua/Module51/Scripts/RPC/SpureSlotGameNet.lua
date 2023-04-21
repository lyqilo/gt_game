require("module51/Scripts/RPC/SuperSlotMessageTemplete")
SpureSlotGameNet = {}
local self = SpureSlotGameNet

function SpureSlotGameNet:addEventMessage()
    EventCallBackTable._01_GameInfo = SpureSlotGameNet.OnHandleGameInfo --游戏消息
    EventCallBackTable._02_ScenInfo = SpureSlotGameNet.OnHandleScenInfo --场景消息
    EventCallBackTable._03_LogonSuccess = SpureSlotGameNet.OnGameLogonWin --登陆成功
    EventCallBackTable._04_LogonOver = SpureSlotGameNet.OnGameLogonOver --登陆完成
    EventCallBackTable._05_LogonFailed = SpureSlotGameNet.OnGameLogonLost --登陆失败
    EventCallBackTable._06_Biao_Action = SpureSlotGameNet.nillFun --表情
    EventCallBackTable._07_UserEnter = SpureSlotGameNet.onPlayerEnter --用户进入
    EventCallBackTable._08_UserLeave = SpureSlotGameNet.OnUserLave --用户离开
    EventCallBackTable._09_UserStatus = SpureSlotGameNet.OnUserState --用户状态
    EventCallBackTable._10_UserScore = SpureSlotGameNet.OnUserScore --用户分数
    EventCallBackTable._11_GameQuit = SpureSlotGameNet.onGameQuit --退出游戏
    EventCallBackTable._12_OnSit = SpureSlotGameNet.onInSeatOver --用户入座
    EventCallBackTable._14_RoomBreakLine = SpureSlotGameNet.onRoomBreakLine --断线消息
    EventCallBackTable._16_OnHelp = SpureSlotGameNet.OnHelp --帮助
    EventCallBackTable._13_ChangeTable = SpureSlotGameNet.nillFun --换桌
    EventCallBackTable._15_OnBackGame = SpureSlotGameNet.GoBackHome -- home键返回游戏
    MessgeEventRegister.Game_Messge_Reg(EventCallBackTable)
end

function SpureSlotGameNet.OnHandleScenInfo(wMaiID, wSubID, buffer, wSize)
    log("===============OnHandleScenInfo:" .. wSubID)
    local SC_Beton_Config = {
        cbCurFreeGameCount = 0, --//剩余免费游戏次数int
        nMultiple = 0, --//单线倍率int
        nBetonCount = 0, --int
        nBetonGold = {},
        --[LABA_MAX_BETON_NUM]; --int
        nFreeGameCotTotal = 0, --//免费游戏总次数int
        nFreeGameGold = 0, --//免费游戏获得金币int
        nSmallCount = 0 --//当前小游戏次数int
    }
    SC_Beton_Config.cbCurFreeGameCount = buffer:ReadInt32()
    SC_Beton_Config.nMultiple = buffer:ReadInt32()
    SC_Beton_Config.nBetonCount = buffer:ReadInt32()
    for i = 1, SC_Beton_Config.nBetonCount do
        SC_Beton_Config.nBetonGold[i] = buffer:ReadInt32()
        if SC_Beton_Config.nBetonGold[i] == SC_Beton_Config.nMultiple then
            LogicDataSpace.CurrSeleteChipsIndex = i;
        end
    end
    SC_Beton_Config.nFreeGameCotTotal = buffer:ReadInt32()
    SC_Beton_Config.nFreeGameGold = buffer:ReadInt32()
    SC_Beton_Config.nSmallCount = buffer:ReadInt32()
    SlotGameEntry.JoinSence(SC_Beton_Config)
end

function SpureSlotGameNet.OnHandleGameInfo(wMaiID, wSubID, buffer, wSize)
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMaiID)) + 1, string.len(tostring(wSubID))))
    if (sid == SuperSlotMessageTemplete.LABA_MSG_SC_SMALL_GAME) then
        log("========================小游戏返回=====================")
        local SC_stSmallGameInfo = {
            nSmallGameTatolConut = 0, --//小游戏次数int
            nSmallGameConut = 0, --	//小游戏剩余次数int
            nGameTatolGold = 0, --//小游戏总获得金币int
            nIconType = 0, --//游戏图标int
            nIconTypeConut = 0, --//第几个水果int
            nIconType4 = {},
            --[4]//中间四个图标int
            nGameGold = 0, --//游戏本次获得金币int
            nGameEnd = 0, --是否结束
            nLineGold = 0               --//单线金币int
        }

        SC_stSmallGameInfo.nSmallGameTatolConut = buffer:ReadInt32();
        SC_stSmallGameInfo.nSmallGameConut = buffer:ReadInt32()
        SC_stSmallGameInfo.nGameTatolGold = buffer:ReadInt32()
        SC_stSmallGameInfo.nIconType = buffer:ReadInt32()
        SC_stSmallGameInfo.nIconTypeConut = buffer:ReadInt32()
        for i = 1, LogicDataSpace.MINIICONS do
            SC_stSmallGameInfo.nIconType4[i] = buffer:ReadInt32()
        end
        SC_stSmallGameInfo.nGameGold = buffer:ReadInt32()

        SC_stSmallGameInfo.nGameEnd = buffer:ReadByte()
        SC_stSmallGameInfo.nLineGold = buffer:ReadInt32()
        SlotGameEntry.HandleMiniGameStarResult(SC_stSmallGameInfo)
    end
    if (sid == SuperSlotMessageTemplete.LABA_MSG_SC_CHECKOUT) then
        log("========================开始返回=====================")
        local SC_CheckOut = {
            m_icons = {},
            --[15];--//游戏结果，15个int
            m_line = {}, -- [9];					--//水果线数
            m_nWinPeiLv = 0, --//赢得赔率int
            m_nCurrGold = 0, --//当前金币INT64
            m_nWinGold = 0, --//本次赢得金币int
            m_nTotalWinGold = 0, --//总赢的金币int
            m_nFreeTimes = 0, --//免费次数int
            m_nMultiple = 0, --//单线倍率int
            m_nJackPotValue = 0, --//奖金池奖int
            m_bSmallGame = 0 --//小游戏 bool
        }
        for i = 1, LogicDataSpace.MAX_ALLICON do
            SC_CheckOut.m_icons[i] = buffer:ReadInt32()
        end
        for i = 1, LogicDataSpace.MAX_LINES do
            SC_CheckOut.m_line[i] = buffer:ReadInt32()
        end
        SC_CheckOut.m_nWinPeiLv = buffer:ReadInt32()
        SC_CheckOut.m_nCurrGold = buffer:ReadInt64Str()
        SC_CheckOut.m_nWinGold = buffer:ReadInt32()
        SC_CheckOut.m_nTotalWinGold = buffer:ReadInt32()
        SC_CheckOut.m_nFreeTimes = buffer:ReadInt32()
        SC_CheckOut.m_nMultiple = buffer:ReadInt32()
        SC_CheckOut.m_nJackPotValue = buffer:ReadInt32()
        SC_CheckOut.m_bSmallGame = buffer:ReadInt32()
        SlotGameEntry.HandleGameStarResult(SC_CheckOut)
    end
    if (sid == SuperSlotMessageTemplete.LABA_MSG_SC_START) then
        error("=========================游戏结果===========================")
        local SC_Start = {
            m_nRetCode = 0 --//1为未压线,2为未压钱,3为钱不够,4-CD,5-单线押注不对
        }
    end
    if (sid == SuperSlotMessageTemplete.LABA_MSG_SC_SYNC_GOLD) then
        error("=========================金币同步===========================")
        local SC_SyncGold = {
            m_nGold = 0, --//玩家当前金币INT64
            m_nLastWinGold = 0, --//未使用int
            m_nTotalWinGold = 0 --//总输赢int
        }
    end
    if (sid == SuperSlotMessageTemplete.LABA_MSG_SC_UPDATE_PRIZE_POOL) then
        local jackport = buffer:ReadInt32();
        if LogicDataSpace.JackpotPool == 0 then
            SlotGameEntry.currentJackport = jackport;
        end
        if jackport <= SlotGameEntry.currentJackport then
            SlotGameEntry.currentJackport = jackport - SlotGameEntry.jackpotCha;
        end
        SlotGameEntry.jackpotCha = jackport - SlotGameEntry.currentJackport;
        log("jackport:" .. jackport)
        LogicDataSpace.JackpotPool = jackport;
    end
end

---请求开始游戏
function SpureSlotGameNet.RsqGameStar(chips)
    local bf = ByteBuffer.New()
    bf:WriteInt(0)
    bf:WriteInt(chips)
    Network.Send(MH.MDM_GF_GAME, SuperSlotMessageTemplete.LABA_MSG_CS_START, bf, gameSocketNumber.GameSocket)
end

---请求开始小游戏
function SpureSlotGameNet.RsqMiniGameStar(chips)
    local bf = ByteBuffer.New()
    bf:WriteInt(chips)
    Network.Send(MH.MDM_GF_GAME, SuperSlotMessageTemplete.LABA_MSG_CS_SMALL_GAME, bf, gameSocketNumber.GameSocket)
end
--发送登陆数据结构
self.CMD_GR_LogonByUserID = {
    [1] = DataSize.UInt32, --广场版本 暂时不用
    [2] = DataSize.UInt32, --进程版本 暂时不用
    [3] = DataSize.UInt32, --用户 I D
    [4] = DataSize.String33, --登录密码 MD5小写加密
    [5] = DataSize.String100, --机器序列 暂时不用
    [6] = DataSize.byte, --补位
    [7] = DataSize.byte --补位
}
---用户登陆
function SpureSlotGameNet.playerLogon()
    error("登陆游戏。。。。")
    local data = {
        [1] = 0, --广场版本 暂时不用
        [2] = 0, --进程版本 暂时不用
        [3] = SCPlayerInfo._01dwUser_Id, --用户 I D
        [4] = SCPlayerInfo._06wPassword, --登录密码 MD5小写加密
        [5] = Opcodes, --机器序列 暂时不用
        [6] = 0,
        [7] = 0
    }
    local buffer = SetC2SInfo(self.CMD_GR_LogonByUserID, data)
    Network.Send(MH.MDM_GR_LOGON, 3, buffer, gameSocketNumber.GameSocket)
end

function SpureSlotGameNet.playerPrepare()
    local CMD_GF_Info = {
        [1] = DataSize.byte --旁观标志 必须等于0
    }
    local Data = { [1] = 0 }
    local buffer = ByteBuffer.New()
    buffer:WriteByte(0)
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket)
    error("==========发送用户准备==========")
end
--玩家入座
function SpureSlotGameNet.playerInSeat()
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket)
end

function SpureSlotGameNet.OnGameLogonWin(wMaiID, wSubID, buffer, wSize)
    log("===============OnGameLogonWin:" .. wSubID)
    LogicDataSpace.wTableID = TableUserInfo._9wChairID
end

function SpureSlotGameNet.OnGameLogonOver(wMaiID, wSubID, buffer, wSize)
    error("=============OnGameLogonOver============= 桌子ID")
    if (65535 == LogicDataSpace.wTableID) then
        --不在桌子上
        self.playerInSeat()
    else
        --若在桌子上 则直接发送玩家准备
        self.playerPrepare()
    end
end
function SpureSlotGameNet.OnGameLogonLost(wMaiID, wSubID, buffer, wSize)
    log("===============OnGameLogonLost:" .. wSubID)
    error("=============登陆失败=============")
end
function SpureSlotGameNet.onPlayerEnter(wMaiID, wSubID, buffer, wSize)
    log("===============onPlayerEnter:" .. wSubID)
    error("=============用户进入============= chairID " .. TableUserInfo._1dwUser_Id)
    if (TableUserInfo._1dwUser_Id ~= SCPlayerInfo._01dwUser_Id) then
        return
    end
    LogicDataSpace.UserNick = TableUserInfo._2szNickName
    LogicDataSpace.UserGold = TableUserInfo._7wGold
    LogicDataSpace.Sex = TableUserInfo._3bySex
    SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestUserInfo.ProcedureName)
end
function SpureSlotGameNet.OnUserScore(wMaiID, wSubID, buffer, wSize)
    error("=============用户分数============= chairID " .. TableUserInfo._9wChairID)
    if (TableUserInfo._1dwUser_Id ~= SCPlayerInfo._01dwUser_Id) then
        return
    end
    -- LogicDataSpace.UserGold = TableUserInfo._7wGold
    SenceMgr.FindSence(MainGameSence.SenceName).ProMgr:RunProcedure(Procedure_MainGameSence_RestUserInfo.ProcedureName)
end
function SpureSlotGameNet.onGameQuit(wMaiID, wSubID, buffer, wSize)
    -- log("===============onGameQuit:" .. wSubID)
    error("________直接退出_________")
    GameSetsBtnInfo.LuaGameQuit();
end
function SpureSlotGameNet.onInSeatOver(wMaiID, wSubID, buffer, wSize)
    log("===============onInSeatOver:" .. wSubID)
    if (wSize > 0) then
        error("=============入座失败=============")
    else
        error("=============入座成功=============")
        self.playerPrepare()
    end
end
function SpureSlotGameNet.onRoomBreakLine(wMaiID, wSubID, buffer, wSize)
    log("===============onRoomBreakLine:" .. wSubID)
    error("================断线===============" .. buffer:ReadString())
end
function SpureSlotGameNet.OnHelp(wMaiID, wSubID, buffer, wSize)
    log("===============OnHelp:" .. wSubID)
    flm_Rule.show()
end
function SpureSlotGameNet.OnUserLave(wMaiID, wSubID, buffer, wSize)
    log("用户离开")
    log("===============OnUserLave:" .. wSubID)
end
function SpureSlotGameNet.OnUserState(wMaiID, wSubID, buffer, wSize)
    log("===============OnUserState:" .. wSubID)
end
function SpureSlotGameNet.GoBackHome(wMaiID, wSubID, buffer, wSize)
    log("===============GoBackHome:" .. wSubID)
end