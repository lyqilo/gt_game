flm_Socket = {}

local self = flm_Socket

local wTableID  --桌子号

self.myChairID = -1

self.isReqDataIng = false --是不是在请求游戏的数据中
self.isongame = false
self.isreqStart=true;
--加入游戏消息事件
function flm_Socket.addGameMessge()
    EventCallBackTable._01_GameInfo = flm_Socket.OnHandleGameInfo --游戏消息
    EventCallBackTable._02_ScenInfo = flm_Socket.OnHandleScenInfo --场景消息
    EventCallBackTable._03_LogonSuccess = flm_Socket.OnGameLogonWin --登陆成功
    EventCallBackTable._04_LogonOver = flm_Socket.OnGameLogonOver --登陆完成
    EventCallBackTable._05_LogonFailed = flm_Socket.OnGameLogonLost --登陆失败
    EventCallBackTable._06_Biao_Action = flm_Socket.onBiaoAction --表情
    EventCallBackTable._07_UserEnter = flm_Socket.onPlayerEnter --用户进入
    EventCallBackTable._08_UserLeave = flm_Socket.OnPlayerLeave --用户离开
    EventCallBackTable._09_UserStatus = flm_Socket.OnPlyaerStatus --用户状态
    EventCallBackTable._10_UserScore = flm_Socket.OnUserScore --用户分数
    EventCallBackTable._11_GameQuit = flm_Socket.onGameQuit --退出游戏
    EventCallBackTable._12_OnSit = flm_Socket.onInSeatOver --用户入座
    EventCallBackTable._13_ChangeTable = flm_Socket.onChageTable --换桌
    EventCallBackTable._14_RoomBreakLine = flm_Socket.onRoomBreakLine --断线消息
    EventCallBackTable._15_OnBackGame = flm_Socket.onBackGame --断线消息
    EventCallBackTable._16_OnHelp = flm_Socket.onHelp --帮助

    --EventCallBackTable._01_GameInfo(1, 1, 1, 1);

    MessgeEventRegister.Game_Messge_Reg(EventCallBackTable)
end
function flm_Socket.onBackGame(args)
    logYellow("0000000000000")
    if self.isreqStart then
        flm_InitProt.Reconnect()
    end
end

function flm_Socket.onHelp(args)
    flm_Rule.show()
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

--用户登陆
function flm_Socket.playerLogon()
    --coroutine.wait(1);

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

    --Network.Send(MH.MDM_GR_LOGON, MH.SUB_GR_LOGON_USERID, buffer, gameSocketNumber.GameSocket);
    Network.Send(MH.MDM_GR_LOGON, 3, buffer, gameSocketNumber.GameSocket)
end

--玩家入座
function flm_Socket.playerInSeat()
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket)
end

--用户准备
-- 客户端游戏场景准备好了，准备接收场景消息
self.CMD_GF_Info = {
    [1] = DataSize.byte --旁观标志 必须等于0
}
function flm_Socket.playerPrepare()
    error("==========发送用户准备==========")
    local Data = { [1] = 0 } --旁观标志 必须等于0
    local buffer = SetC2SInfo(self.CMD_GF_Info, Data)
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket)
end

--登陆成功
function flm_Socket.OnGameLogonWin(wMaiID, wSubID, buffer, wSize)
    error("=============OnGameLogonWin============= " .. TableUserInfo._10wTableID)

    wTableID = TableUserInfo._9wChairID
end

--登陆完成
function flm_Socket.OnGameLogonOver(wMaiID, wSubID, buffer, wSize)
    error("=============OnGameLogonOver============= 桌子ID")

    if (65535 == wTableID) then
        --不在桌子上
        self.playerInSeat()
    else
        --若在桌子上 则直接发送玩家准备
        self.playerPrepare()
    end
end

--登陆失败
function flm_Socket.OnGameLogonLost(wMaiID, wSubID, buffer, wSize)
    error("=============登陆失败=============")
end

--入座完成
function flm_Socket.onInSeatOver(wMaiID, wSubID, buffer, wSize)
    if (wSize > 0) then
        error("=============入座失败=============")
    else
        error("=============入座成功=============")
        self.playerPrepare()
    end
end

--用户进入
function flm_Socket.onPlayerEnter(wMaiID, wSubID, buffer, wSize)
    error("=============用户进入============= chairID " .. TableUserInfo._1dwUser_Id)
    --error("用户进入。。。 wMaiID ：" .. wMaiID .. "  _wSubID : " .. wSubID);
    error("________onPlayerEnter_____________" .. SCPlayerInfo._01dwUser_Id)
    if (TableUserInfo._1dwUser_Id ~= SCPlayerInfo._01dwUser_Id) then
        return
    end

    flm_Data.myinfoChang()
end

--用户离开
function flm_Socket.OnPlayerLeave(wMaiID, wSubID, buffer, wSize)
    self.isreflushScore = true
    --UserListSp.reflush();
end

--用户状态
function flm_Socket.OnPlyaerStatus(wMaiID, wSubID, buffer, wSize)
    --error("=============用户状态============= chairID " ..TableUserInfo._9wChairID );
end

--用户分数
function flm_Socket.OnUserScore(wMaiID, wSubID, buffer, wSize)
    error("=============用户分数============= chairID " .. TableUserInfo._9wChairID)
    if (TableUserInfo._1dwUser_Id ~= SCPlayerInfo._01dwUser_Id) then
        return
    end
    --error("______OnUserScore_______");
    flm_Data.myinfoChang()
end

--换桌
--当所有参数为Null时表示触发了换桌按钮，当不为null时表示收到服务器换桌消息
function flm_Socket.onChageTable(wMaiID, wSubID, buffer, wSize)
    error("================换桌============")
end

--退出游戏
function flm_Socket.onGameQuit(wMaiID, wSubID, buffer, wSize)
    error("________直接退出_________")
    flm_Data.InitCount_Zero()
    self.initdataandres(1)
    GameSetsBtnInfo.LuaGameQuit()
end

function flm_Socket.initdataandres(args)
    self.isongame = false
    flm_Event.dispathEvent(flm_Event.xiongm_exit, nil)
    if args == 1 then
        flm_Event.dispathEvent(flm_Event.xiongm_unload_game_res, nil)
    end
    flm_Event.destroying()
    self.distory()
    flm_Data.distory()
    MessgeEventRegister.Game_Messge_Un()
end

function flm_Socket.distory(args)
    self.myChairID = -1

    self.isReqDataIng = false --是不是在请求游戏的数据中
end

--表情
function flm_Socket.onBiaoAction(wMaiID, wSubID, buffer, wSize)
    error("================表情================ ")
end

--断线消息
function flm_Socket.onRoomBreakLine(wMaiID, wSubID, buffer, wSize)
    -- error("================断线===============" .. buffer:ReadString())
    -- Point21ScenCtrlPanel.gameQuit();
    local one = buffer:ReadInt32()
    local l = buffer:ReadInt32()
    local str = buffer:ReadString(l)
    logYellow("断线消息=="..str)
    HallScenPanel.NetException(str, gameSocketNumber.GameSocket)
end

--游戏消息
function flm_Socket.OnHandleGameInfo(wMaiID, wSubID, buffer, wSize)
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMaiID)) + 1, string.len(tostring(wSubID))))
    if sid == flm_CMD.SUB_SC_GAME_OVER then
        flm_Data.gameOver(buffer)
    elseif sid == flm_CMD.SUB_SC_UPDATE_PRIZE_POOL then
        flm_Data.updateAllFuValue(buffer)
    end
end

--场景消息
function flm_Socket.OnHandleScenInfo(wMaiID, wSubID, buffer, wSize)
    self.isReqSamllClick = false
    flm_Data.gameSence(buffer)
    self.isongame = true
end

--播放声
--isbgsound true 播放的是音乐 不然就是音效, isplay 是背景音乐的时候 它是播放还是停止
function flm_Socket.playaudio(audioname, isbgsound, isplay, issave)
    local musicchip = flm_Data.soundres.transform:Find(audioname):GetComponent("AudioSource").clip
    if isbgsound == true then
        MusicManager:PlayBacksoundX(musicchip, isplay)
    elseif issave == true then
        flm_Data.saveSound = MusicManager:PlayX(musicchip).gameObject
    else
        return MusicManager:PlayX(musicchip).gameObject
    end
end

self.reqnum = 0
function flm_Socket.reqStart()
    logYellow("请求开始游戏")
    if self.isReqDataIng == true then
        return
    end
    if self.isongame == false or flm_Data.isResCom ~= 2 then
        return
    end
    if flm_Data.autoRunNum > 0 and flm_Data.isAutoGame == true and flm_Data.byFreeCnt == 0 then
        flm_Data.autoRunNum = math.max(flm_Data.autoRunNum - 1, 0)
    end
    flm_Data.curGameIndex = flm_Data.curGameIndex + 1
    flm_Event.dispathEvent(flm_Event.xiongm_colse_line_anima)
    self.SendUserReady()
    self.isReqDataIng = true
    local bf = ByteBuffer.New()
    bf:WriteUInt32(flm_Data.curSelectChoum)
    if flm_Data.byFreeCnt <= 0 and flm_Data.byGoldModeNum <= 0 then
        flm_Data.myinfoData._7wGold = flm_Data.myinfoData._7wGold - (flm_Data.curSelectChoum * 25)
    end
    flm_Data.isshowmygold = true
    flm_Event.dispathEvent(flm_Event.xiongm_gold_chang, true)
    Network.Send(MH.MDM_GF_GAME, flm_CMD.SUB_CS_GAME_START, bf, gameSocketNumber.GameSocket)
    self.isreqStart=false;
end

function flm_Socket.ShowMessageBox(strTitle, iBtnCount, yesfun)
    iBtnCount = iBtnCount or 1
    local tab = GeneralTipsSystem_ShowInfo
    tab._01_Title = ""
    tab._02_Content = strTitle
    tab._03_ButtonNum = iBtnCount
    tab._04_YesCallFunction = yesfun
    tab._05_NoCallFunction = nil
    MessageBox.CreatGeneralTipsPanel(tab)
end

--发送用户准备（游戏中）
function flm_Socket.SendUserReady()
    --error("=====游戏中=====发送用户准备==========");
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_USER_READY, buffer, gameSocketNumber.GameSocket)
end

--判断是不是显示烈火
function flm_Socket.showLiehuo()
    if flm_Data.isShowLieHuoBg == true then
        --flm_Socket.playaudio("firebg",true,true);
        flm_Event.dispathEvent(flm_Event.xiongm_lihuo_bg_anima)
        flm_Event.dispathEvent(flm_Event.xiongm_lihuo_btn_anima)
    end
end

function flm_Socket.gameOneOver2(isauto)
    if flm_Data.byFreeCnt > 0 or flm_Data.isAutoGame == true then
        coroutine.start(
                function(args)
                    coroutine.wait(1)
                    self.gameOneOver(isauto)
                    log("===========================++++++++++++++++++++++++++免费次数：" .. flm_Data.byFreeCnt)
                end
        )
    else
        log("===========================免费次数：" .. flm_Data.byFreeCnt)
        self.gameOneOver(isauto)
    end
end

--一次游戏完成 isauto 是不是在update里面检测发出的
function flm_Socket.gameOneOver(isauto)
    error("__00__flm_Data.bFireMode_____" .. flm_Data.byFreeCnt)
    
    self.isreqStart=true;
    flm_Data.InitOver=true;
    if HallScenPanel.IsConnectGame and HallScenPanel.restConnectCount <= 0 and not HallScenPanel.OnReConnnect then
    else
        return
    end        
    if GameManager.IsStopGame then
       return 
    end

    if isauto == false then
        self.isReqDataIng = false
    end
    if self.isReqDataIng == false then
    end
    if flm_Data.isruning == true then
        return
    end
    if flm_Data.byFreeCnt > 0 or flm_Data.isAutoGame == true then
    else
        flm_Event.dispathEvent(flm_Event.xiongm_start_btn_no_inter, true)
    end
    if flm_Data.byFreeCnt == 0 and flm_Data.freeAllGold > 0 then
        flm_Data.isFreeing = false
        flm_Event.dispathEvent(flm_Event.xiongm_show_free_all_gold)
        return
    end
    if flm_Data.isFreeing == true and flm_Data.byFreeCnt == 0 then
        flm_Data.isFreeing = false
        flm_Event.dispathEvent(flm_Event.xiongm_close_free_bg)
        flm_Socket.playaudio("normalbg", true, true)
    end
    flm_Event.dispathEvent(flm_Event.xiongm_mianf_btn_mode)
    flm_Event.dispathEvent(flm_Event.xiongm_title_mode)
    if flm_Data.isgudi == true then
        flm_Event.dispathEvent(flm_Event.xiongm_show_gudi)
    else
        flm_Event.dispathEvent(flm_Event.xiongm_close_gudi)
    end

    if isauto == false and flm_Data.byFreeCnt >= 1 then
        flm_Event.dispathEvent(flm_Event.xiongm_show_free_num_chang)
        flm_Event.dispathEvent(flm_Event.xiongm_start_btn_click)
        self.reqStart()
        return
    end

    flm_Event.dispathEvent(flm_Event.xiongm_show_gold_mode_num_chang)
    if isauto == false and flm_Data.byGoldModeNum >= 1 then
        --flm_Event.dispathEvent(flm_Event.xiongm_show_gold_mode_num_chang);
        flm_Event.dispathEvent(flm_Event.xiongm_start_btn_click)
        --error("byGoldModeNum————00——");
        self.reqStart()
        --error("byGoldModeNum————11——");
        return
    end
    if flm_Data.bGoldingMode == true and flm_Data.byGoldModeNum == 0 and isauto == false then
        flm_Data.bGoldingMode = false
        flm_Event.dispathEvent(flm_Event.xiongm_show_gold_mode_com_anima)
        return
    end
    -- error("______reqStart______");

    if isauto == true and self.isReqDataIng == false then
        if toInt64(flm_Data.curSelectChoum * flm_CMD.D_LINE_COUNT) > toInt64(flm_Data.myinfoData._7wGold) then
            self.ShowMessageBox("金币不够", 1, nil)
            flm_Data.isAutoGame = false
            flm_Event.dispathEvent(flm_Event.xiongm_show_start_btn)
            flm_Event.dispathEvent(flm_Event.xiongm_start_btn_no_inter, true)
            return
        end
        flm_Event.dispathEvent(flm_Event.xiongm_start_btn_click)
        self.reqStart()
        return
    end
    if flm_Data.isAutoGame == true and self.isReqDataIng == false then
        if toInt64(flm_Data.curSelectChoum * flm_CMD.D_LINE_COUNT) > toInt64(flm_Data.myinfoData._7wGold) then
            self.ShowMessageBox("金币不够", 1, nil)
            flm_Data.isAutoGame = false
            flm_Event.dispathEvent(flm_Event.xiongm_show_start_btn)
            flm_Event.dispathEvent(flm_Event.xiongm_start_btn_no_inter, true)
            return
        end
        flm_Event.dispathEvent(flm_Event.xiongm_show_no_start_btn)
        flm_Event.dispathEvent(flm_Event.xiongm_start_btn_click)
        self.reqStart()
        return
    end
    flm_Event.dispathEvent(flm_Event.xiongm_show_start_btn, nil)
end
