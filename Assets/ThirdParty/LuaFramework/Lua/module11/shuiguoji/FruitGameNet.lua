--FruitGameNet.lua
--Date
--水果机网路通信类

--endregion

FruitGameNet = {}

local self = FruitGameNet

local wTableID  --桌子号

function FruitGameNet.addGameMessge()
    EventCallBackTable._01_GameInfo = FruitGameNet.OnHandleGameInfo --游戏消息
    EventCallBackTable._02_ScenInfo = FruitGameNet.OnHandleScenInfo --场景消息
    EventCallBackTable._03_LogonSuccess = FruitGameNet.OnGameLogonWin --登陆成功
    EventCallBackTable._04_LogonOver = FruitGameNet.OnGameLogonOver --登陆完成
    EventCallBackTable._05_LogonFailed = FruitGameNet.OnGameLogonLost --登陆失败

    EventCallBackTable._07_UserEnter = FruitGameNet.onPlayerEnter --用户进入

    EventCallBackTable._10_UserScore = FruitGameNet.OnUserScore --用户分数
    EventCallBackTable._11_GameQuit = FruitGameNet.onGameQuit --退出游戏
    EventCallBackTable._12_OnSit = FruitGameNet.onInSeatOver --用户入座

    EventCallBackTable._14_RoomBreakLine = FruitGameNet.onRoomBreakLine --断线消息

    EventCallBackTable._16_OnHelp = FruitGameNet.OnHelp --帮助

    EventCallBackTable._06_Biao_Action = FruitGameNet.nillFun --表情
    EventCallBackTable._08_UserLeave = FruitGameNet.nillFun --用户离开
    EventCallBackTable._09_UserStatus = FruitGameNet.nillFun --用户状态
    EventCallBackTable._13_ChangeTable = FruitGameNet.nillFun --换桌
    EventCallBackTable._15_OnBackGame = FruitGameNet.nillFun -- home键返回游戏

    MessgeEventRegister.Game_Messge_Reg(EventCallBackTable)
end

--用户登陆
function FruitGameNet.playerLogon()
    --coroutine.wait(1);

    logGreen("fruit game 登陆游戏。。。。")

    local data = {
        [1] = 0, --广场版本 暂时不用
        [2] = 0, --进程版本 暂时不用
        [3] = SCPlayerInfo._01dwUser_Id, --用户 I D
        [4] = SCPlayerInfo._06wPassword, --登录密码 MD5小写加密
        [5] = Opcodes, --机器序列 暂时不用
        [6] = 0,
        [7] = 0
    }

    local CMD_GR_LogonByUserID = {
        [1] = DataSize.UInt32, --广场版本 暂时不用
        [2] = DataSize.UInt32, --进程版本 暂时不用
        [3] = DataSize.UInt32, --用户 I D
        [4] = DataSize.String33, --登录密码 MD5小写加密
        [5] = DataSize.String100, --机器序列 暂时不用
        [6] = DataSize.byte, --补位
        [7] = DataSize.byte --补位
    }

    local buffer = SetC2SInfo(CMD_GR_LogonByUserID, data)

    Network.Send(MH.MDM_GR_LOGON, 3, buffer, gameSocketNumber.GameSocket)
end

--玩家入座
function FruitGameNet.playerInSeat()
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket)
end

--用户准备
function FruitGameNet.playerPrepare()
    logGreen("==========发送用户准备==========")
    local Data = {[1] = 0} --旁观标志 必须等于0

    local CMD_GF_Info = {
        [1] = DataSize.byte --旁观标志 必须等于0
    }

    local buffer = SetC2SInfo(CMD_GF_Info, Data)
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket)
end

--登陆成功
function FruitGameNet.OnGameLogonWin(wMaiID, wSubID, buffer, wSize)
    logGreen("=============登陆成功============= " .. TableUserInfo._10wTableID)

    wTableID = TableUserInfo._10wTableID
end

--登陆完成
function FruitGameNet.OnGameLogonOver(wMaiID, wSubID, buffer, wSize)
    logGreen("=============登陆完成============= 桌子ID" .. wTableID)

    if (65535 == wTableID) then --不在桌子上
        FruitGameNet.playerInSeat()
    else --若在桌子上 则直接发送玩家准备
        FruitGameNet.playerPrepare()
    end
end

--登陆失败
function FruitGameNet.OnGameLogonLost(wMaiID, wSubID, buffer, wSize)
    local str = buffer:ReadString(wSize)
    logGreen("=============登陆失败============= " .. str)
    Network.OnException(str, 1)
    --DragonSlotMain.ShowMessageBox(str);
end

--入座完成
function FruitGameNet.onInSeatOver(wMaiID, wSubID, buffer, wSize)
    if (wSize > 0) then
        --DragonSlotMain.ShowMessageBox(str);
        local str = buffer:ReadString(wSize)
        logGreen("=============入座失败=============" .. str)
        Network.OnException(str, 1)
    else
        logGreen("=============入座成功=============")
        FruitGameNet.playerPrepare()
    end
end

--用户进入
function FruitGameNet.onPlayerEnter(wMaiID, wSubID, buffer, wSize)
    logGreen(TableUserInfo._1dwUser_Id .. " =============用户进入============= chairID " .. TableUserInfo._9wChairID)

    if (TableUserInfo._1dwUser_Id == SCPlayerInfo._01dwUser_Id) then
    --自己的座位号
    end

    local isTableUserInfo = {
        _1dwUser_Id = TableUserInfo._1dwUser_Id,
        _2szNickName = TableUserInfo._2szNickName,
        _3bySex = TableUserInfo._3bySex,
        _4bCustomHeader = TableUserInfo._4bCustomHeader,
        _5szHeaderExtensionName = TableUserInfo._5szHeaderExtensionName,
        _6szSign = TableUserInfo._6szSign,
        _7wGold = TableUserInfo._7wGold,
        _8wPrize = TableUserInfo._8wPrize,
        _9wChairID = TableUserInfo._9wChairID,
        _10wTableID = TableUserInfo._10wTableID,
        _11byUserStatus = TableUserInfo._11byUserStatus
    }
    logYellow("gold = " .. tostring(isTableUserInfo._7wGold))
    FruitGameMain.SetPlayerGold(isTableUserInfo._7wGold, FruitResource.strTraMyGoldNum, true)
end

--用户分数
function FruitGameNet.OnUserScore(wMaiID, wSubID, buffer, wSize)
    logGreen("=============用户分数============= chairID " .. TableUserInfo._9wChairID)

    local isTableUserInfo = {
        _1dwUser_Id = TableUserInfo._1dwUser_Id,
        _2szNickName = TableUserInfo._2szNickName,
        _3bySex = TableUserInfo._3bySex,
        _4bCustomHeader = TableUserInfo._4bCustomHeader,
        _5szHeaderExtensionName = TableUserInfo._5szHeaderExtensionName,
        _6szSign = TableUserInfo._6szSign,
        _7wGold = TableUserInfo._7wGold,
        _8wPrize = TableUserInfo._8wPrize,
        _9wChairID = TableUserInfo._9wChairID,
        _10wTableID = TableUserInfo._10wTableID,
        _11byUserStatus = TableUserInfo._11byUserStatus
    }
    logYellow("current gold = " .. tostring(isTableUserInfo._7wGold))
    FruitGameMain.SetPlayerGold(isTableUserInfo._7wGold, FruitResource.strTraMyGoldNum, true)
end

--退出游戏
function FruitGameNet.onGameQuit(wMaiID, wSubID, buffer, wSize)
    FruitGameMain.GameQuit()
end

--断线消息
function FruitGameNet.onRoomBreakLine(wMaiID, wSubID, buffer, wSize)
    local one = buffer:ReadInt32()
    local l = buffer:ReadInt32()
    local str = buffer:ReadString(l)
    logGreen("================断线===============" .. str)
    --FruitGameMain.GameQuit();
    FruitGameMain.ShowMessageBox(str)
    --DragonSlotMain.ShowMessageBox(str);
end

--游戏消息
function FruitGameNet.OnHandleGameInfo(wMaiID, wSubID, buffer, wSize)
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMaiID)) + 1, string.len(tostring(wSubID))))
    logGreen("=============游戏消息============= sid : " .. sid)

    if (FruitData.SUB_SC_FRIUT_RESULT == sid) then --第一轮结果
        FruitData.CMD_SC_FRIUT_RESULT.DataDispose(buffer)

        local tabData = {
            iChipResult = FruitData.CMD_SC_FRIUT_RESULT.i64ChipResult, -- 第一轮结果金额
            tabImgId = FruitData.CMD_SC_FRIUT_RESULT.tabIChipPicture, --第一轮主盘图案 size 4
            tabRates = FruitData.CMD_SC_FRIUT_RESULT.tabIChipPower, --倍率 size 3
            iChipList = FruitData.CMD_SC_FRIUT_RESULT.tabiChipFirut -- 每个图案下注的最后中奖倍数 size 8
        }

        FruitGameMain.GameStart(tabData)
    elseif (FruitData.SUB_SC_COMPARE_RESULT == sid) then --比倍
        local data = GetS2CInfo(FruitData.CMD_SC_COMPARE_RESULT, buffer)
        local tabData = {
            iWinGold = data[1], --赢得金币
            iNumber = data[2] --比大小最终值
        }
        FruitGameMain.ComGame(tabData)
    elseif (FruitData.SUB_SC_ACCOUNT_END == sid) then --结算结束
        FruitGameMain.BeginChip()
    end
end

--场景消息
function FruitGameNet.OnHandleScenInfo(wMaiID, wSubID, buffer, wSize)
    logGreen("=============场景消息============= .. " .. wSize)

    local data = GetS2CInfo(FruitData.CMD_SC_SCENE, buffer)

    local tabData = {
        iMinScale = data[1], --最小倍数
        iAddStep = data[2], --每次增加倍数
        iMaxStep = data[3] --最大倍数
    }

    FruitGameMain.InitScene(tabData)
    logGreen("----sceen message end---- ")
end

--帮助
function FruitGameNet.OnHelp()
    --DragonSlotMain.OnClickHelpBtn();
end

--发送用户准备（游戏中）
function FruitGameNet.SendUserReady()
    logGreen("==========发送用户准备==========")
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_USER_READY, buffer, gameSocketNumber.GameSocket)
    logGreen("==========发送用户准备========== end")
end

function FruitGameNet.nillFun(wMaiID, wSubID, buffer, wSize)
end
