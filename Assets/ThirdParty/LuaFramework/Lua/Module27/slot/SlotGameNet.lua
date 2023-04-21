--SlotGameNet.lua
--Date
-- slot 网络通信类
--endregion
--require "Common/define"--默认的定义
--require "Common/functions"--公共函数
--require "Core/MessgeEventRegister"
--require "Data/gameData"
--require "Slot/SlotDataStruct"
--require "Slot/SlotUserInfo"
SlotGameNet = {}

local self = SlotGameNet;

local wTableID; --桌子号

self.isreqStart=true;
self.initOver=false;
function SlotGameNet.addGameMessge()

    EventCallBackTable._01_GameInfo = SlotGameNet.OnHandleGameInfo; --游戏消息
    EventCallBackTable._02_ScenInfo = SlotGameNet.OnHandleScenInfo; --场景消息
    EventCallBackTable._03_LogonSuccess = SlotGameNet.OnGameLogonWin; --登陆成功
    EventCallBackTable._04_LogonOver = SlotGameNet.OnGameLogonOver; --登陆完成
    EventCallBackTable._05_LogonFailed = SlotGameNet.OnGameLogonLost; --登陆失败

    EventCallBackTable._07_UserEnter = SlotGameNet.onPlayerEnter; --用户进入

    EventCallBackTable._10_UserScore = SlotGameNet.OnUserScore; --用户分数
    EventCallBackTable._11_GameQuit = SlotGameNet.onGameQuit; --退出游戏
    EventCallBackTable._12_OnSit = SlotGameNet.onInSeatOver; --用户入座

    EventCallBackTable._14_RoomBreakLine = SlotGameNet.onRoomBreakLine; --断线消息

    EventCallBackTable._16_OnHelp = SlotGameNet.OnHelp; --帮助


    EventCallBackTable._06_Biao_Action = SlotGameNet.nillFun; --表情
    EventCallBackTable._08_UserLeave = SlotGameNet.nillFun; --用户离开
    EventCallBackTable._09_UserStatus = SlotGameNet.nillFun; --用户状态
    EventCallBackTable._13_ChangeTable = SlotGameNet.nillFun;  --换桌
    EventCallBackTable._15_OnBackGame = SlotGameNet.OnBackGame; -- home键返回游戏


    MessgeEventRegister.Game_Messge_Reg(EventCallBackTable);

end

function SlotGameNet.OnBackGame()
    if self.isreqStart then
        Game01Panel.Reconnect()   
    end
end


--用户登陆
function SlotGameNet.playerLogon()

    --coroutine.wait(1);
    log("登陆游戏。。。。");

    local data =    {
        [1] = 0, --广场版本 暂时不用
        [2] = 0, --进程版本 暂时不用
        [3] = SCPlayerInfo._01dwUser_Id, --用户 I D
        [4] = SCPlayerInfo._06wPassword, --登录密码 MD5小写加密
        [5] = Opcodes, --机器序列 暂时不用
        [6] = 0,
        [7] = 0,
    }
    local CMD_GR_LogonByUserID =    {
        [1] = DataSize.UInt32, --广场版本 暂时不用
        [2] = DataSize.UInt32, --进程版本 暂时不用
        [3] = DataSize.UInt32, --用户 I D
        [4] = DataSize.String33, --登录密码 MD5小写加密
        [5] = DataSize.String100, --机器序列 暂时不用
        [6] = DataSize.byte, --补位
        [7] = DataSize.byte, --补位
    }
    local buffer = SetC2SInfo(CMD_GR_LogonByUserID, data);

    Network.Send(MH.MDM_GR_LOGON, 3, buffer, gameSocketNumber.GameSocket);

end

--玩家入座
function SlotGameNet.playerInSeat()

    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket);

end

--用户准备
function SlotGameNet.playerPrepare()
    local CMD_GF_Info =    {
        [1] = DataSize.byte, --旁观标志 必须等于0
    }

    log("==========发送用户准备==========");
    local Data = {[1] = 0,} --旁观标志 必须等于0
    local buffer = SetC2SInfo(CMD_GF_Info, Data);
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket);

end


--登陆成功
function SlotGameNet.OnGameLogonWin(wMaiID, wSubID, buffer, wSize)

    log("=============登陆成功============= " .. TableUserInfo._10wTableID);

    wTableID = TableUserInfo._10wTableID;

end


--登陆完成
function SlotGameNet.OnGameLogonOver(wMaiID, wSubID, buffer, wSize)

    log("=============登陆完成============= 桌子ID" .. wTableID);

    if (65535 == wTableID) then --不在桌子上
        SlotGameNet.playerInSeat();
    else --若在桌子上 则直接发送玩家准备
        SlotGameNet.playerPrepare();
    end

end


--登陆失败
function SlotGameNet.OnGameLogonLost(wMaiID, wSubID, buffer, wSize)
    local str = buffer:ReadString(wSize);
    log("=============登陆失败============= " .. str);
    Network.OnException(str, 1);
end


--入座完成
function SlotGameNet.onInSeatOver(wMaiID, wSubID, buffer, wSize)

    if (wSize > 0) then
        local str = buffer:ReadString(wSize);
        log("=============入座失败============= " .. str);
        Network.OnException(str, 1);
    else
        log("=============入座成功=============");
        SlotGameNet.playerPrepare();
    end

end


--用户进入
function SlotGameNet.onPlayerEnter(wMaiID, wSubID, buffer, wSize)

    log(" ===================================用户进入======" .. wMaiID .. "  " .. wSubID .. "=================  " .. TableUserInfo._1dwUser_Id);
    local isTableUserInfo =    {
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
        _11byUserStatus = TableUserInfo._11byUserStatus,
    };
    if (isTableUserInfo._1dwUser_Id ~= TableUserInfo._1dwUser_Id) then
        return;
    end;
    log(" ===================================用户进入======" .. wMaiID .. "  " .. wSubID .. "=================" .. isTableUserInfo._1dwUser_Id .. "   " .. isTableUserInfo._7wGold .. "  " .. TableUserInfo._1dwUser_Id);
    SlotBase.SetGold(isTableUserInfo._7wGold);
end




--用户分数
function SlotGameNet.OnUserScore(wMaiID, wSubID, buffer, wSize)
    local isTableUserInfo =    {
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
        _11byUserStatus = TableUserInfo._11byUserStatus,
    };

    if (not self.bGameBegin) then
        logYellow("刷新玩家金币：" .. isTableUserInfo._7wGold);
        SlotBase.SetGold(isTableUserInfo._7wGold);
    else
        SlotBase.GetPlayerGold(isTableUserInfo._7wGold)
        self.bGameBegin = false;
    end


end


--退出游戏
function SlotGameNet.onGameQuit(wMaiID, wSubID, buffer, wSize)
    Game01Panel.GameQuit();
    SlotDataStruct.UpdateJackpotTime.Stop();
end


--断线消息
function SlotGameNet.onRoomBreakLine(wMaiID, wSubID, buffer, wSize)
    log("================断线===============");
    Game01Panel.GameQuit();
end

function SlotGameNet.OnHelp()
    SlotBase.OnClickExplainBtn();
end


--游戏消息
function SlotGameNet.OnHandleGameInfo(wMaiID, wSubID, buffer, wSize)
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMaiID)) + 1, string.len(tostring(wSubID))));
    if (SlotDataStruct.SUB_SC_SEND_ACCPOOL == sid) then --奖池数据         
        local num = int64.tonum2(buffer:ReadInt64());
        logYellow("======================返回奖池：" .. num .. "=======================")
        SlotBase.SetSuperGold(num);
    elseif (SlotDataStruct.SUB_SC_RESULTS_INFO == sid) then --结算
        logYellow("======================游戏结算=======================")
        self.bGameBegin = true;
        SlotDataStruct.CMD_SC_RESULTS_INFO.DataDispose(buffer);
        local tabData =        {
            byImg = SlotDataStruct.CMD_SC_RESULTS_INFO.byImg; --图标15	
            byLineType = SlotDataStruct.CMD_SC_RESULTS_INFO.byLineType; --线类型30*5=150
            byWealthGodNum = SlotDataStruct.CMD_SC_RESULTS_INFO.byWealthGodNum; --财神个数
            byFreeNum = SlotDataStruct.CMD_SC_RESULTS_INFO.byFreeNum; --免费次数;
            gameType = SlotDataStruct.CMD_SC_RESULTS_INFO.gameType;  --游戏类型
            dwWinScore = SlotDataStruct.CMD_SC_RESULTS_INFO.dwWinScore; --赢得的总分
            bLimitChip = SlotDataStruct.CMD_SC_RESULTS_INFO.bLimitChip;
            iLimitChip = SlotDataStruct.CMD_SC_RESULTS_INFO.iLimitChip;
            bReturn = SlotDataStruct.CMD_SC_RESULTS_INFO.bReturn;
        }
        local i64Num = SlotDataStruct.CMD_SC_RESULTS_INFO.i64AccuPool;
        SlotDataStruct.CMD_SC_RESULTS_INFO.DataDispose();
        SlotBase.SetSuperGold(i64Num);
        if (tabData.dwWinScore <= 0) then self.bGameBegin = false; end
        SlotBase.GameStart(tabData, tabData.bReturn);
        logTable(tabData);
    elseif (SlotDataStruct.SUB_SC_USER_INFO == sid) then
    elseif (SlotDataStruct.SUB_SC_TEST_INFO == sid) then  --系统信息测试
        Game01Panel.TestGameSysInfo(buffer);
    end
    self.isreqStart=true;
end


--场景消息
function SlotGameNet.OnHandleScenInfo(wMaiID, wSubID, buffer, wSize)
    log("=============场景消息=============");
    SlotDataStruct.CMD_SC_GAME_SCENE.DataDispose(buffer);
    local tabData =    {
        iBet = SlotDataStruct.CMD_SC_GAME_SCENE.iBet;
        byFreeNumber = SlotDataStruct.CMD_SC_GAME_SCENE.byFreeNumber;
        byChipList = SlotDataStruct.CMD_SC_GAME_SCENE.byChipList;
        iRateList = SlotDataStruct.CMD_SC_GAME_SCENE.iRateList;
        iGodScore = SlotDataStruct.CMD_SC_GAME_SCENE.i64GodScore;
        bLimitChip = SlotDataStruct.CMD_SC_GAME_SCENE.bLimitChip;
        iLimitChip = SlotDataStruct.CMD_SC_GAME_SCENE.iLimitChip;
        bReturn = SlotDataStruct.CMD_SC_GAME_SCENE.bReturn;
    }
    if tabData.iBet==0 then
        tabData.iBet=tabData.byChipList[1]
    end
    logTable(tabData);
    local i64Num = SlotDataStruct.CMD_SC_GAME_SCENE.i64AccuPool;
    SlotDataStruct.CMD_SC_GAME_SCENE.DataDispose();
    SlotBase.InitTable(tabData);
    SlotBase.SetSuperGold(i64Num);
    self.RequestJackPot();
end


--发送用户准备（游戏中）
function SlotGameNet.SendUserReady()

    log("==========发送用户准备==========");
    local buffer = ByteBuffer.New();
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_USER_READY, buffer, gameSocketNumber.GameSocket);

end

--请求用户信息
function SlotGameNet.RequestUserInfo()
    local Data = {[1] = 0,}
    local csData = SetC2SInfo(SlotDataStruct.CMD_CS_USER_INFO, Data);
    Network.Send(MH.MDM_GF_GAME, SlotDataStruct.SUB_CS_USER_INFO, csData, gameSocketNumber.GameSocket);
end


function SlotGameNet.RequestJackPot()
    local buffers = ByteBuffer.New();
    Network.Send(MH.MDM_GF_GAME, SlotDataStruct.SUB_CS_JACKPOT, buffers, gameSocketNumber.GameSocket);
end

function SlotGameNet.nillFun(wMaiID, wSubID, buffer, wSize)
end