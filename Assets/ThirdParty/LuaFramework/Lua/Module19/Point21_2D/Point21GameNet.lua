--Point21GameNet.lua
--Date
--21点网络通信类
--endregion
--默认的定义
require "Module19/Point21_2D/Point21DataStruct"
--require "Point21_2D/Point21DataStruct" --场景控制
Point21GameNet = {}

local self = Point21GameNet

local wTableID  --桌子号

local againConnectNum = 0

local D_AGAIN_COUNT = 5

local bMessageBlackJack = false

--加入游戏消息事件
function Point21GameNet.addGameMessge()
    EventCallBackTable._01_GameInfo = Point21GameNet.OnHandleGameInfo --游戏消息
    EventCallBackTable._02_ScenInfo = Point21GameNet.OnHandleScenInfo --场景消息
    EventCallBackTable._03_LogonSuccess = Point21GameNet.OnGameLogonWin --登陆成功
    EventCallBackTable._04_LogonOver = Point21GameNet.OnGameLogonOver --登陆完成
    EventCallBackTable._05_LogonFailed = Point21GameNet.OnGameLogonLost --登陆失败
    EventCallBackTable._06_Biao_Action = Point21GameNet.onBiaoAction --表情
    EventCallBackTable._07_UserEnter = Point21GameNet.onPlayerEnter --用户进入
    EventCallBackTable._08_UserLeave = Point21GameNet.OnPlayerLeave --用户离开
    EventCallBackTable._09_UserStatus = Point21GameNet.OnPlyaerStatus --用户状态
    EventCallBackTable._10_UserScore = Point21GameNet.OnUserScore --用户分数
    EventCallBackTable._11_GameQuit = Point21GameNet.onGameQuit --退出游戏
    EventCallBackTable._12_OnSit = Point21GameNet.onInSeatOver --用户入座
    EventCallBackTable._13_ChangeTable = Point21GameNet.onChageTable --换桌
    EventCallBackTable._14_RoomBreakLine = Point21GameNet.onRoomBreakLine --断线消息
    EventCallBackTable._15_OnBackGame = Point21GameNet.OnHomeBack
    EventCallBackTable._16_OnHelp = Point21GameNet.OnHelp --帮助
    EventCallBackTable._17_OnStopGame = Point21GameNet.OnGoHome
    EventCallBackTable._18_OnHandleMessage = Point21GameNet.OnHandleMessage
    MessgeEventRegister.Game_Messge_Reg(EventCallBackTable)
    againConnectNum = 0
end

--用户登陆
function Point21GameNet.playerLogon()
    error("21 point 登陆游戏。。。。")
    local data = {
        [1] = 0, --广场版本 暂时不用
        [2] = 0, --进程版本 暂时不用
        [3] = SCPlayerInfo._01dwUser_Id, --用户 I D
        [4] = SCPlayerInfo._06wPassword, --登录密码 MD5小写加密
        [5] = Opcodes, --机器序列 暂时不用
        [6] = 0,
        [7] = 0
    }
    local buffer = SetC2SInfo(Point21DataStruct.CMD_GR_LogonByUserID, data)
    Network.Send(MH.MDM_GR_LOGON, 3, buffer, gameSocketNumber.GameSocket)
end

--玩家入座
function Point21GameNet.playerInSeat()
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket)
end

--用户准备
function Point21GameNet.playerPrepare()
    error("发送用户准备")
    local Data = {[1] = 0 } --旁观标志 必须等于0
    local buffer = SetC2SInfo(Point21DataStruct.CMD_GF_Info, Data)
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket)
end

--登陆成功
function Point21GameNet.OnGameLogonWin(wMaiID, wSubID, buffer, wSize)
    error("登陆成功 TableID = " .. TableUserInfo._10wTableID)
    wTableID = TableUserInfo._10wTableID
end

--登陆完成
function Point21GameNet.OnGameLogonOver(wMaiID, wSubID, buffer, wSize)
    error("登陆完成 桌子ID = " .. wTableID)
    if (65535 == wTableID) then --不在桌子上
        Point21GameNet.playerInSeat()
    else --若在桌子上 则直接发送玩家准备
        Point21GameNet.playerPrepare()
    end
end

--登陆失败
function Point21GameNet.OnGameLogonLost(wMaiID, wSubID, buffer, wSize)
    local str = buffer:ReadString(wSize)
    error("登陆失败：" .. str)
    self.bUpdate = false
    self.bServerDis = true
    Point21ScenCtrlPanel.ShowMessageBox("登录失败", 1, true)
end

--入座完成
function Point21GameNet.onInSeatOver(wMaiID, wSubID, buffer, wSize)
    if (wSize > 0) then
        local str = buffer:ReadString(wSize)
        error("入座失败：" .. str)
        self.bUpdate = false
        self.bServerDis = true
        Point21ScenCtrlPanel.ShowMessageBox(str, 1, true)
    else
        error("入座成功")
        Point21GameNet.playerPrepare()
    end
end

--用户进入
function Point21GameNet.onPlayerEnter(wMaiID, wSubID, buffer, wSize)
    error("用户进入 chairID = " .. TableUserInfo._9wChairID)
    if (TableUserInfo._1dwUser_Id == SCPlayerInfo._01dwUser_Id) then
        myChairID = TableUserInfo._9wChairID --自己的座位号
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
    point21PlayerTab[TableUserInfo._9wChairID + 1]:initPlayerInfo(isTableUserInfo)
end

--用户离开
function Point21GameNet.OnPlayerLeave(wMaiID, wSubID, buffer, wSize)
    error("用户离开 chairID = " .. TableUserInfo._1dwUser_Id)

    for i = 1, #point21PlayerTab do
        if (TableUserInfo._1dwUser_Id == point21PlayerTab[i].playerInfoTab._1dwUser_Id) then
            point21PlayerTab[i]:playerLeave()
            break
        end
    end
end

--用户状态
function Point21GameNet.OnPlyaerStatus(wMaiID, wSubID, buffer, wSize)
    error("用户状态 chairID = " .. TableUserInfo._9wChairID)
end

--用户分数
function Point21GameNet.OnUserScore(wMaiID, wSubID, buffer, wSize)
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
    point21PlayerTab[TableUserInfo._9wChairID + 1]:setPlayerScore(isTableUserInfo)
end

--换桌
--当所有参数为Null时表示触发了换桌按钮，当不为null时表示收到服务器换桌消息
function Point21GameNet.onChageTable(wMaiID, wSubID, buffer, wSize)
    error("换桌")
end

--退出游戏
function Point21GameNet.onGameQuit(wMaiID, wSubID, buffer, wSize)
    if (point21PlayerTab[myChairID + 1].allChipNumInt > 0) then --在游戏中 弹出提示
        --Point21ScenCtrlPanel.titleImage.gameObject:SetActive(true);
        Point21ScenCtrlPanel.ShowMessageBox("Forced exit will deduct gold coins！", 2, true)
    else --不在游戏中 直接退出
        Point21ScenCtrlPanel.gameQuit()
    end
end

function Point21GameNet.OnHelp()
    Point21ScenCtrlPanel.OnClickBtnHellp()
end

--表情
function Point21GameNet.onBiaoAction(wMaiID, wSubID, buffer, wSize)
    error("表情")

    local sChairId = buffer:ReadUInt16()
    local sIndex = buffer:ReadByte()

    point21PlayerTab[sChairId + 1]:playExpression(sIndex)
end

--断线消息
function Point21GameNet.onRoomBreakLine(wMaiID, wSubID, buffer, wSize)
    --Point21ScenCtrlPanel.gameQuit();
    local msgtype = buffer:ReadUInt16();
    local str = buffer:ReadString(buffer:ReadUInt16());
    error("断线：" .. str)
    self.bUpdate = false -- 停止心跳
    self.bServerDis = true
    Point21ScenCtrlPanel.ShowMessageBox(str, 1, true)
end

--游戏消息
function Point21GameNet.OnHandleGameInfo(wMaiID, wSubID, buffer, wSize)
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMaiID)) + 1, string.len(tostring(wSubID))))
    if (sid ~= 49) then
        logYellow(
        "===================================================游戏消息 sid : " ..
        sid .. "    Size:" .. wSize .. "==================================================="
        )
    end
    
    if (Point21DataStruct.CMD_BlackJack.SUB_SC_CHIP == sid) then --下注
        logYellow(
        "===================================================游戏开始==================================================="
        )
        Point21ScenCtrlPanel.gameBegin()
    elseif (Point21DataStruct.CMD_BlackJack.SUB_SC_PLAYER_CHIP == sid) then --玩家下注
        if (Point21ScenCtrlPanel.StartGameMessage~=true) then  return ;    end

        local data = GetS2CInfo(Point21DataStruct.CMD_SC_PLAYER_CHIP, buffer)
        local playerChipTab = {
            iChip = data[1], --下注值
            byChairID = data[2], --座位号
            iType = data[3] --下注类型
        }
        logTable(playerChipTab)
        point21PlayerTab[playerChipTab.byChairID + 1]:throwChips(playerChipTab.iType, playerChipTab.iChip)
        if (playerChipTab.byChairID == myChairID) then
            Point21ScenCtrlPanel.showChipList(true)
        end
    elseif (Point21DataStruct.CMD_BlackJack.SUB_SC_DEAL_POKER == sid) then --发牌
        if (Point21ScenCtrlPanel.StartGameMessage~=true) then  return ;    end
        for i = 1, #point21PlayerTab - 1 do
            if (point21PlayerTab[i].bHaveInfo) then
                point21PlayerTab[i]:setTimer(false) --隐藏时间条
            end
        end
        Point21ZJCtrl.setCountDownTimer(false)
        Point21ScenCtrlPanel.showChipList(false) --隐藏下注界面
        local pokerDataTab = {}
        for i = 1, Point21DataStruct.CMD_BlackJack.GAME_PLAYER + 1 do
            local poker1 = buffer:ReadByte()
            local poker2 = buffer:ReadByte()
            local tempTab = {
                --发牌数据
                byPokerData1 = poker1, --第一张
                byPokerData2 = poker2 --第二张
            }
            table.insert(pokerDataTab, tempTab)
        end
        logTable(pokerDataTab)
        local tabChiapType = {} -- ChipType[GAME_PLAYER][3] //对子下注0，+13下注1，-13下注2(下标，值为1代表下注了)
        for i = 1, Point21DataStruct.CMD_BlackJack.GAME_PLAYER do
            local tabType = {}
            for j = 1, 3 do
                table.insert(tabType, buffer:ReadByte())
            end
            table.insert(tabChiapType, tabType)
        end
        logTable(tabChiapType)
        local tabWin = {} --ChipWin[GAME_PLAYER][3];//对子下注0，+13下注1，-13下注2(下标，值为赢的值)
        for i = 1, Point21DataStruct.CMD_BlackJack.GAME_PLAYER do
            local tabWinVaul = {}
            for j = 1, 3 do
                table.insert(tabWinVaul, buffer:ReadInt32())
            end
            table.insert(tabWin, tabWinVaul)
        end
        logTable(tabWin)
        Point21ZJCtrl.getFirstPokers(pokerDataTab, tabChiapType, tabWin)
        self.isFerist = true;
    elseif (Point21DataStruct.CMD_BlackJack.SUB_SC_INSURANCE == sid) then --保险
        if (Point21ScenCtrlPanel.StartGameMessage~=true) then  return ;    end
        for i = 1, #point21PlayerTab - 1 do
            if (point21PlayerTab[i].allChipNumInt > 0) then --下注了的玩家
                point21PlayerTab[i]:setTimer(true, Point21DataStruct.CMD_BlackJack.TIMER_INSURACE) --显示时间条
            end
        end
        if (point21PlayerTab[myChairID + 1].allChipNumInt > 0) then --自己下注了 表示在游戏中 则弹出购买保险提示
            Point21ScenCtrlPanel.showinsurancePanerl(true)
            --Point21ScenCtrlPanel.insuranceTitleTra.gameObject:SetActive(true);
        end
        bMessageBlackJack = true
    elseif (Point21DataStruct.CMD_BlackJack.SUB_SC_PLAYER_INSURANCE == sid) then --玩家保险
        if (Point21ScenCtrlPanel.StartGameMessage~=true) then  return ;    end
        local data = GetS2CInfo(Point21DataStruct.CMD_SC_PLAYER_INSURANCE, buffer)
        local insuranceData = {
            byChairID = data[1],
            bInsurance = data[2]
        }
        logTable(insuranceData)
        if (insuranceData.bInsurance > 0) then --购买了保险
            point21PlayerTab[insuranceData.byChairID + 1]:throwChips(
            Point21DataStruct.E_CHIPTYPE_OTHER,
            point21PlayerTab[insuranceData.byChairID + 1].allChipValIntTab[1] / 2,
            true
            )
        end
    elseif (Point21DataStruct.CMD_BlackJack.SUB_SC_LOOK_ZJ_BLACK_JACK == sid) then --查看庄家是否黑杰克
        if (Point21ScenCtrlPanel.StartGameMessage~=true) then  return ;    end
        if (bMessageBlackJack) then
            for i = 1, #point21PlayerTab - 1 do
                if (point21PlayerTab[i].allChipNumInt > 0 and i ~= myChairID + 1) then --下注了的玩家 并且不是自己 自己在保险操作框中隐藏时间条
                    point21PlayerTab[i]:setTimer(false) --隐藏时间条
                end
            end
            Point21ScenCtrlPanel.showinsurancePanerl(false)
        end
        local data = GetS2CInfo(Point21DataStruct.CMD_SC_LOOK_ZJ_BLAKC_JACK, buffer)
        local zjBJData = {
            bZJBlackJack = data[1],
            byPokerData = data[2]
        }
        logTable(zjBJData)
        if (not bMessageBlackJack) then
            Point21ZJCtrl.SaveInspectPokerData(zjBJData)
            return
        end
        if (zjBJData.bZJBlackJack > 0) then --庄家黑杰克
            log("======================================庄家黑杰克=============================================")
            --Point21ZJCtrl.playBjAnimation(true, true, zjBJData.byPokerData)
            --Point21ScenCtrlPanel.showOperation(false)
        else
            log("======================================庄家不是黑杰克=============================================")
            --Point21ZJCtrl.playBjAnimation(false, false)
        end
        bMessageBlackJack = false
    elseif (Point21DataStruct.CMD_BlackJack.SUB_SC_PLAYER_BLACK_JACK == sid) then --玩家黑杰克
    elseif (Point21DataStruct.CMD_BlackJack.SUB_SC_NORMAL_OPERATE == sid) then --普通操作
        if (Point21ScenCtrlPanel.StartGameMessage~=true) then  return ;    end
        local data = GetS2CInfo(Point21DataStruct.CMD_SC_NORMAL_OPERATE, buffer)
        local operateData = {
            byChairID = data[1],
            bCanSplitPoker = data[2]
        }
        logTable(operateData)
        if (operateData.byChairID == myChairID) then
            local bSplit  --是否可以分牌
            if (operateData.bCanSplitPoker > 0) then
                bSplit = true
            else
                bSplit = false
            end
            -- if (self.isFerist == false) then
            --     Point21ScenCtrlPanel.showOperation(true, bSplit)
            --     log("显示操作按钮1")
            -- else
           -- if(tonumber(point21PlayerTab[operateData.byChairID + 1].pokerPointsStrTab[2])~=21)then
                coroutine.start(function()
                    coroutine.wait(0.5);
                    log("显示操作按钮2")
                    Point21ScenCtrlPanel.showOperation(true, bSplit,false)
                end)
                self.isFerist = false;
           -- end
        else
            Point21ScenCtrlPanel.showOperation(false)
        end
        if (zjPos ~= (operateData.byChairID + 1)) then --庄家没有黑杰克
            point21PlayerTab[operateData.byChairID + 1]:setTimer(true, Point21DataStruct.CMD_BlackJack.TIMER_NORMAL_OPERATE, true) --显示时间条
            point21PlayerTab[operateData.byChairID + 1]:setCountDownTimer(true, Point21DataStruct.CMD_BlackJack.TIMER_NORMAL_OPERATE) --倒计时音效
        end
    elseif (Point21DataStruct.CMD_BlackJack.SUB_SC_PLAYER_NORMAL_OPERATE == sid) then --玩家普通操作
        if (Point21ScenCtrlPanel.StartGameMessage~=true) then  return ;    end
        local data = GetS2CInfo(Point21DataStruct.CMD_SC_PLAYER_NORMAL_OPERATE, buffer)
        local playerOperateDataTab = {
            --玩家普通操作数据
            OperateTypeTab = data[1], --操作类型
            pokerDataTab = {
                byPokerData1 = data[2],
                byPokerData2 = data[3]
            }, --扑克数据
            byChairID = data[4], --玩家座位号
            bBustPokerByte = data[5], --是否爆牌
            b21Byte = data[6], --21点
            bSelfStopPokerByte = data[7] --自己停牌
        }
        logTable(playerOperateDataTab)
        point21PlayerTab[playerOperateDataTab.byChairID + 1]:playerOperate(playerOperateDataTab)
    elseif (Point21DataStruct.CMD_BlackJack.SUB_SC_LOOK_ZJ_SECOND_POKER == sid) then --查看庄家第二张牌
        Point21ScenCtrlPanel.showOperation(false)

        if (Point21ScenCtrlPanel.StartGameMessage~=true) then  return ;    end
        logYellow("===================================查看庄家第二张牌=======================================")
        local data = GetS2CInfo(Point21DataStruct.CMD_SC_LOOK_ZJ_SECOND_POKER, buffer)
        local operateData = {
            byPokerData = data[1]
        }
        logTable(operateData)
        Point21ZJCtrl.lookZjTwoPoker(operateData.byPokerData)
    elseif (Point21DataStruct.CMD_BlackJack.SUB_SC_NEW_PALYER_ENTER_AT_CHIP == sid) then --下注状态进入玩家
        if (Point21ScenCtrlPanel.StartGameMessage~=true) then  return ;    end
        if (Point21ScenCtrlPanel.surplusTimer < 8) then
            return
        end --下注时间大于八秒才可以下注
        local data = GetS2CInfo(Point21DataStruct.CMD_SC_NEW_PLAYER_ENTER_AT_CHIP, buffer)
        local playerEnterAtChipData = {
            byChairID = data[1]
        }

        logTable(playerEnterAtChipData)
        if (byChairID == myChairID) then
            return
        end
        point21PlayerTab[playerEnterAtChipData.byChairID + 1].bThrowChipTypeIn = true
    elseif (Point21DataStruct.CMD_BlackJack.SUB_SC_GAME_END == sid) then --游戏结束
        if (Point21ScenCtrlPanel.StartGameMessage~=true) then  return ;    end
        Point21DataStruct.CMD_SC_GAME_END.DataDispose(buffer)
        local dataTab = {
            gameEndType = Point21DataStruct.CMD_SC_GAME_END.gameEndType, --游戏结束类型
            gameResult = Point21DataStruct.CMD_SC_GAME_END.gameResult, --玩家输赢
            historyScore = Point21DataStruct.CMD_SC_GAME_END.historyScore --成绩
        }
        logTable(dataTab)
        Point21DataStruct.CMD_SC_GAME_END.DataDispose()

        if (dataTab.gameEndType == Point21DataStruct.CMD_BlackJack.enGameEndType.E_GAME_END_TYPE_NORMAL) then
            Point21ZJCtrl.gameNormalOver(dataTab)
        elseif (dataTab.gameEndType == Point21DataStruct.CMD_BlackJack.enGameEndType.E_GAME_END_TYPE_ZJ_BLACK_JACK) then
            Point21ZJCtrl.waitResetGameInfo()
        end
        Point21ZJCtrl.bIsResult = true
        logYellow(
        "===================================================游戏结束==================================================="
        )
    elseif (Point21DataStruct.CMD_BlackJack.SUB_SC_CHIP_LIST == sid) then --下注列表
        local dataTab = GetS2CInfo(Point21DataStruct.CMD_SC_CHIP_LIST, buffer)
        Point21ScenCtrlPanel.initChipsList(dataTab)
    elseif (Point21DataStruct.CMD_BlackJack.SUB_SC_STOP_CHIP == sid) then --停止下注
        if (Point21ScenCtrlPanel.StartGameMessage~=true) then  return ;    end
        local data = GetS2CInfo(Point21DataStruct.CMD_SC_STOP_CHIP, buffer)

        local playerStopChipTab = {
            byChairID = data[1] --座位号
        }

        point21PlayerTab[playerStopChipTab.byChairID + 1]:setTimer(false) --隐藏时间条
    elseif (Point21DataStruct.CMD_BlackJack.SUB_SC_CHIP_ERROR == sid) then
        local str = buffer:ReadString(wSize)
        Point21ScenCtrlPanel.ShowMessageBox(str, 1)
    elseif (Point21DataStruct.CMD_BlackJack.SUB_SC_HEART_BIT == sid) then
        Point21GameNet.TakeOverHeart()
    end
end

--场景消息
function Point21GameNet.OnHandleScenInfo(wMaiID, wSubID, buffer, wSize)
    error("场景消息")

    Point21DataStruct.CMD_SC_GAME_FREE.DataDispose(buffer)

    local dataTab = {
        lCellScore = Point21DataStruct.CMD_SC_GAME_FREE.lCellScore, --基础积分
        cbSetCellStatus = Point21DataStruct.CMD_SC_GAME_FREE.cbSetCellStatus, --自由场状态
        byCurrentOperateChairID = Point21DataStruct.CMD_SC_GAME_FREE.byCurrentOperateChairID, --当前操作座位号
        gameRunState = Point21DataStruct.CMD_SC_GAME_FREE.gameRunState, --游戏运行状态
        zjOperateState = Point21DataStruct.CMD_SC_GAME_FREE.zjOperateState, --庄家操作状态
        iLeftTime = Point21DataStruct.CMD_SC_GAME_FREE.iLeftTime, --下注剩余时间
        iChip = Point21DataStruct.CMD_SC_GAME_FREE.iChip, --下注值
        serverPlayerData = Point21DataStruct.CMD_SC_GAME_FREE.serverPlayerData, --玩家数据
        historyScore = Point21DataStruct.CMD_SC_GAME_FREE.historyScore --成绩
    }

    Point21DataStruct.CMD_SC_GAME_FREE.DataDispose()

    Point21ScenCtrlPanel.scenInfoDispose(dataTab)

    Point21GameNet.InitHeartBitData()
    --error("场景。。。 wMaiID ：" .. wMaiID .. "  _wSubID : " .. wSubID);
end

function Point21GameNet.OnGoHome(args)

    error(" -- 重新连接");
    if self.ReLogon then return end
    self.ReLogon = true;

    if self.LogonNum > 3 then self.RoomBreakQuit("网络异常，重连失败！") self.ReLogon = false; self.LogonNum = 0; return end
    Network.Close(gameSocketNumber.GameSocket)
    HallScenPanel.ReLoadGame(self.GoBackGame);
    self.LogonNum = self.LogonNum + 1;
    local function checkSuccess()
        local i = 0;
        repeat
            coroutine.wait(1);
            i = i + 1;
            if i > 5 then Network.OnException(10001); self.ReLogon = false return end
        until (not self.ReLogon)
    end
    -- error("go home back")
    -- self.bGoHome = true
    -- Point21GameNet.BreakGame()
    -- Point21ScenCtrlPanel.LeaveGame()
end

function Point21GameNet.OnHomeBack(iTime)
    HallScenPanel.ReLoadGame(Point21ScenCtrlPanel.GoBackGame)
end

function Point21GameNet.OnHandleMessage(args)
    error("on Handle message")
    if (self.bServerDis) then
        logYellow(" 服务器send主动断开游戏")
        self.bServerDis = false
        return false
    end
    if (not self.bSelfBreak) then
        logYellow(" 服务器主动断开游戏 ")
        return nil
    else
        self.bSelfBreak = false
    end
    if (self.bGoHome) then
        logYellow(" home back message")
        self.bGoHome = false
        return false
    end
    if (againConnectNum > D_AGAIN_COUNT) then
        return true
    end
    HallScenPanel.ReLoadGame(Point21ScenCtrlPanel.GoBackGame)
    local bRet = self.bHeartEnd or false
    return bRet
end

--断开游戏
function Point21GameNet.BreakGame(bShowError)
    self.bSelfBreak = true -- 客户端主动断开
    if (not bShowError) then
        table.insert(ReturnNotShowError, "95003")
    end
    Network.Close(gameSocketNumber.GameSocket)
end

function Point21GameNet.FixedUpdate()
    if (not self.bUpdate) then
        return
    end
    if (not self.timeData) then
        return
    end

    if (not self.bWait) then
        Point21GameNet.TimerSendHeart(Time.fixedDeltaTime)
    else
        Point21GameNet.TimerWaitHeart(Time.fixedDeltaTime)
    end
end

function Point21GameNet.InitHeartBitData()
    self.D_HEART_BIT_COUNT = 3

    self.iHeartNum = 0

    self.timeData = 0
    self.timeEnd = 5

    self.timerWaitTick = 0
    self.timeWait = 2
    self.bWait = false

    self.bTackHeart = false

    self.bHeartEnd = false

    self.bUpdate = true

    logYellow("init hear bit data")
end

function Point21GameNet.TimerSendHeart(fDeltaTime)
    self.timeData = self.timeData + fDeltaTime
    if (self.timeData >= self.timeEnd - self.timeWait) then
        self.timeData = self.timeData - (self.timeEnd - self.timeWait)
        Point21GameNet.SendHeartBit()
        self.bWait = true
    end
end

function Point21GameNet.TimerWaitHeart(fDeltaTime)
    self.timerWaitTick = self.timerWaitTick + fDeltaTime
    if (self.timerWaitTick >= self.timeWait) then
        self.timerWaitTick = self.timerWaitTick - self.timeWait

        if (not self.bTackHeart) then
            self.iHeartNum = self.iHeartNum + 1
        end

        if (self.iHeartNum >= self.D_HEART_BIT_COUNT) then
            againConnectNum = againConnectNum + 1
            if (againConnectNum > D_AGAIN_COUNT) then
                --self.bUpdate = false
                Point21GameNet.BreakGame()
                Point21ScenCtrlPanel.ShowMessageBox("网络不稳定", 1, true)
                return
            end

            self.bHeartEnd = true
            Point21GameNet.BreakGame(true)
            Point21ScenCtrlPanel.LeaveGame()
            return
        end

        self.bTackHeart = false
        self.bWait = false
    end
end

--接收心跳包
function Point21GameNet.TakeOverHeart()
    self.bTackHeart = true
    if (self.iHeartNum > 0) then
        self.iHeartNum = self.iHeartNum - 1
    end
end

--发送心跳包
function Point21GameNet.SendHeartBit()
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_GF_GAME, Point21DataStruct.CMD_BlackJack.SUB_CS_HEART_BIT, buffer, gameSocketNumber.GameSocket)
end

function Point21GameNet.nillFun(wMaiID, wSubID, buffer, wSize)
    --error("wMaiID ：" .. wMaiID .. "  _wSubID : " .. wSubID);
end