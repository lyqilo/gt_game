FruitsSlot_Socket = {}

local self = FruitsSlot_Socket

local wTableID  --桌子号

self.myChairID = -1

self.isReqDataIng = false --是不是在请求游戏的数据中
self.isongame = false
self.isreqStart=true
--加入游戏消息事件
function FruitsSlot_Socket.addGameMessge()
    EventCallBackTable._01_GameInfo = FruitsSlot_Socket.OnHandleGameInfo --游戏消息
    EventCallBackTable._02_ScenInfo = FruitsSlot_Socket.OnHandleScenInfo --场景消息
    EventCallBackTable._03_LogonSuccess = FruitsSlot_Socket.OnGameLogonWin --登陆成功
    EventCallBackTable._04_LogonOver = FruitsSlot_Socket.OnGameLogonOver --登陆完成
    EventCallBackTable._05_LogonFailed = FruitsSlot_Socket.OnGameLogonLost --登陆失败
    EventCallBackTable._06_Biao_Action = FruitsSlot_Socket.onBiaoAction --表情
    EventCallBackTable._07_UserEnter = FruitsSlot_Socket.onPlayerEnter --用户进入
    EventCallBackTable._08_UserLeave = FruitsSlot_Socket.OnPlayerLeave --用户离开
    EventCallBackTable._09_UserStatus = FruitsSlot_Socket.OnPlyaerStatus --用户状态
    EventCallBackTable._10_UserScore = FruitsSlot_Socket.OnUserScore --用户分数
    EventCallBackTable._11_GameQuit = FruitsSlot_Socket.onGameQuit --退出游戏
    EventCallBackTable._12_OnSit = FruitsSlot_Socket.onInSeatOver --用户入座
    EventCallBackTable._13_ChangeTable = FruitsSlot_Socket.onChageTable --换桌
    EventCallBackTable._14_RoomBreakLine = FruitsSlot_Socket.onRoomBreakLine --断线消息
    EventCallBackTable._15_OnBackGame = FruitsSlot_Socket.onBackGame --断线消息
    EventCallBackTable._16_OnHelp = FruitsSlot_Socket.onHelp --帮助
    EventCallBackTable._17_OnStopGame = FruitsSlot_Socket.onStopGame --停止游戏

    --EventCallBackTable._01_GameInfo(1, 1, 1, 1);
    MessgeEventRegister.Game_Messge_Reg(EventCallBackTable)
end
function FruitsSlot_Socket.onBackGame(args)
    logYellow("Game22Panel-->回到游戏=="..tostring(self.isreqStart))
    if self.isreqStart then
        Game22Panel.Reconnect()
    end
end

function FruitsSlot_Socket.onHelp(args)
    FruiltsSlot_Rule.show()
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
function FruitsSlot_Socket.playerLogon()
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
function FruitsSlot_Socket.playerInSeat()
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket)
end

--用户准备
-- 客户端游戏场景准备好了，准备接收场景消息
self.CMD_GF_Info = {
    [1] = DataSize.byte --旁观标志 必须等于0
}
function FruitsSlot_Socket.playerPrepare()
    error("==========发送用户准备==========")
    local Data = {[1] = 0 } --旁观标志 必须等于0
    local buffer = SetC2SInfo(self.CMD_GF_Info, Data)
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket)
end

--登陆成功
function FruitsSlot_Socket.OnGameLogonWin(wMaiID, wSubID, buffer, wSize)
    error("=============OnGameLogonWin============= " .. TableUserInfo._10wTableID)

    wTableID = TableUserInfo._9wChairID
end

--登陆完成
function FruitsSlot_Socket.OnGameLogonOver(wMaiID, wSubID, buffer, wSize)
    error("=============OnGameLogonOver============= 桌子ID")

    if (100 <= wTableID) then --不在桌子上
        self.playerInSeat()
    else --若在桌子上 则直接发送玩家准备
        self.playerPrepare()
    end
end

--登陆失败
function FruitsSlot_Socket.OnGameLogonLost(wMaiID, wSubID, buffer, wSize)
    error("=============登陆失败=============")
    Network.OnException("登陆失败")
end

--入座完成
function FruitsSlot_Socket.onInSeatOver(wMaiID, wSubID, buffer, wSize)
    if (wSize > 0) then
        error("=============入座失败=============")
        Network.OnException("Failed to enter room")
    else
        error("=============入座成功=============")
        self.playerPrepare()
    end
end

--用户进入
function FruitsSlot_Socket.onPlayerEnter(wMaiID, wSubID, buffer, wSize)
    error("=============用户进入============= chairID " .. TableUserInfo._1dwUser_Id)
    --error("用户进入。。。 wMaiID ：" .. wMaiID .. "  _wSubID : " .. wSubID);
    error("________onPlayerEnter_____________" .. SCPlayerInfo._01dwUser_Id)
    if (TableUserInfo._1dwUser_Id ~= SCPlayerInfo._01dwUser_Id) then
        return
    end

    FruitsSlot_Data.myinfoChang()
end

--用户离开
function FruitsSlot_Socket.OnPlayerLeave(wMaiID, wSubID, buffer, wSize)
    self.isreflushScore = true
    --UserListSp.reflush();
end

--用户状态
function FruitsSlot_Socket.OnPlyaerStatus(wMaiID, wSubID, buffer, wSize)
    --error("=============用户状态============= chairID " ..TableUserInfo._9wChairID );
end

--用户分数
function FruitsSlot_Socket.OnUserScore(wMaiID, wSubID, buffer, wSize)
    --error("=============用户分数============= chairID " ..TableUserInfo._9wChairID );
    if (TableUserInfo._1dwUser_Id ~= SCPlayerInfo._01dwUser_Id) then
        return
    end
    --error("______OnUserScore_______");
    FruitsSlot_Data.myinfoChang()
end

--换桌
--当所有参数为Null时表示触发了换桌按钮，当不为null时表示收到服务器换桌消息
function FruitsSlot_Socket.onChageTable(wMaiID, wSubID, buffer, wSize)
    --error("================换桌============");
end

--退出游戏
function FruitsSlot_Socket.onGameQuit(wMaiID, wSubID, buffer, wSize)
    --[[if(point21PlayerTab[myChairID + 1].allChipNumInt > 0) then --在游戏中 弹出提示
        Point21ScenCtrlPanel.titleImage.gameObject:SetActive(true);
    else --不在游戏中 直接退出
        Point21ScenCtrlPanel.gameQuit();
    end]]
    --error("________直接退出_________");
    if Network.IsConnected then
        if FruitsSlot_Data.byFreeCnt > 0 or FruitsSlot_Data.bellnum > 0 then
            return
        end
    end
    self.gameInitData()
    GameSetsBtnInfo.LuaGameQuit()
end
--把数据初始化
function FruitsSlot_Socket.gameInitData()
    FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_exit, nil)
    FruitsSlotEvent.destroying()
    self.distory()
    FruitsSlot_Data.distory()
    self.isongame = false
    MessgeEventRegister.Game_Messge_Un()
end

function FruitsSlot_Socket.distory(args)
    self.myChairID = -1

    self.isReqDataIng = false --是不是在请求游戏的数据中
end

--表情
function FruitsSlot_Socket.onBiaoAction(wMaiID, wSubID, buffer, wSize)
    -- error("================表情================ " );
--[[ local sChairId = buffer:ReadUInt16();
    local sIndex = buffer:ReadByte();

    point21PlayerTab[sChairId + 1]:playExpression(sIndex);]]
end

--断线消息
function FruitsSlot_Socket.onRoomBreakLine(wMaiID, wSubID, buffer, wSize)
    --error("================断线===============");
    -- Point21ScenCtrlPanel.gameQuit();
    local one = buffer:ReadInt32()
    local l = buffer:ReadInt32()
    local str = buffer:ReadString(l)
    HallScenPanel.NetException(str, gameSocketNumber.GameSocket)
end

--游戏消息
function FruitsSlot_Socket.OnHandleGameInfo(wMaiID, wSubID, buffer, wSize)
    --error("游戏。。。 wMaiID ：" .. wMaiID .. "  _wSubID : " .. wSubID);
    if self.isongame == false then
        return
    end
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMaiID)) + 1, string.len(tostring(wSubID))))
    if sid == FruitsSlot_CMD.SUB_SC_GAME_START then -- 启动游戏
    elseif sid == FruitsSlot_CMD.SUB_SC_GAME_OVER then -- 游戏结束
        FruitsSlot_Data.gameOver(buffer)
    elseif sid == FruitsSlot_CMD.SUB_SC_BELL_GAME then -- 铃铛游戏结算
        FruitsSlot_Data.bellValueChang(buffer)
    elseif sid == FruitsSlot_CMD.SUB_SC_USER_PEILV then -- 下注配置返回        
        FruitsSlot_Data.GetPEILV(buffer)
    end
end

--场景消息
function FruitsSlot_Socket.OnHandleScenInfo(wMaiID, wSubID, buffer, wSize)
    --error("====11=========场景消息============="..wSize);
    self.isReqBellClick = false
    self.isongame = true
    FruitsSlot_Data.gameSence(buffer)
    local buffer = ByteBuffer.New();
    Network.Send(MH.MDM_GF_GAME, FruitsSlot_CMD.SUB_CS_GAME_PEILV, bf, gameSocketNumber.GameSocket)
end

--播放声
--isbgsound true 播放的是音乐 不然就是音效, isplay 是背景音乐的时候 它是播放还是停止
function FruitsSlot_Socket.playaudio(audioname, isbgsound, isplay)
    if FruitsSlot_Data.sound_res == nil then
        return
    end
    if self.isongame == false then
        return
    end
    local musicchip = FruitsSlot_Data.sound_res.transform:Find(audioname):GetComponent("AudioSource").clip
    if isbgsound == true then
        MusicManager:PlayBacksoundX(musicchip, isplay)
    else
        return MusicManager:PlayX(musicchip).gameObject
    end
end

--请求下注
function FruitsSlot_Socket.reqStart()

        if self.isReqDataIng == true then
            return
        end
        if self.isongame == false then
            return
        end
    --log("钱不够1")
        if
        toInt64(FruitsSlot_Data.curSelectChoum * FruitsSlot_CMD.D_LINE_COUNT) >
                toInt64(FruitsSlot_Data.myinfoData._7wGold)
        then
            --log("钱不够2")
            return
        end
        if FruitsSlot_Data.isGoldMoreThan() == true then
            return
        end
    --log("钱不够3")
        self.SendUserReady()
        self.isReqDataIng = true
        FruitsSlot_Data.isshowmygold = true
        local bf = ByteBuffer.New()
        bf:WriteUInt32(FruitsSlot_Data.curSelectChoum)
        Network.Send(MH.MDM_GF_GAME, FruitsSlot_CMD.SUB_CS_GAME_START, bf, gameSocketNumber.GameSocket)
    --log("钱不够4")
        self.isreqStart=false

end

--发送用户准备（游戏中）
function FruitsSlot_Socket.SendUserReady()
    -- logGreen("=====游戏中=====发送用户准备==========");
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_USER_READY, buffer, gameSocketNumber.GameSocket)
end

self.isReqBellClick = false
--点击铃铛游戏里面的铃铛
function FruitsSlot_Socket.reqBellClick(posint)
    logError("==========================================================" .. posint)
    if self.isReqBellClick == true then
        --return;
    end
    if self.isongame == false then
        return
    end

    self.isReqBellClick = true
    local bf = ByteBuffer.New()
    bf:WriteByte(posint)
    Network.Send(MH.MDM_GF_GAME, FruitsSlot_CMD.SUB_CS_BELL_GAME_END, bf, gameSocketNumber.GameSocket)
end

--判断当前的金币能不能够下注
function FruitsSlot_Socket.isHandMoney()
    if
    toInt64(FruitsSlot_Data.curSelectChoum * FruitsSlot_CMD.D_LINE_COUNT) >
    toInt64(FruitsSlot_Data.myinfoData._7wGold)
    then
        local dataTab = {
            _01_Title = "提示",
            _02_Content = "当前金币不能满足下注",
            _03_ButtonNum = 1,
            _04_YesCallFunction = nil,
            _05_NoCallFunction = nil
        }
        MessageBox.CreatGeneralTipsPanel(dataTab)
        return false
    end
    return true
end

--一次游戏完成 isauto 是不是在update里面检测发出的
function FruitsSlot_Socket.gameOneOver(isauto)
    --error("___gameOneOver________");
    if isauto == false then
        self.isReqDataIng = false
    end
    if self.isReqDataIng == false then
        --error("__111_gameOneOver________");
    end
    if FruitsSlot_Data.isruning == true then
        return
    end
    if FruitsSlot_Data.isGoldMoreThan() == true then
        return
    end

    self.isreqStart=true
    if HallScenPanel.IsConnectGame and HallScenPanel.restConnectCount <= 0 and not HallScenPanel.OnReConnnect then
    else
        return
    end
    if GameManager.IsStopGame then
        return 
    end

    if isauto == true and self.isReqDataIng == false then
        if self.isHandMoney() == false then
            FruitsSlot_Data.isAutoGame = false
            FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_start_btn_inter, true)
            return
        end
        FruitsSlot_PushFun.CreatShowNum(
        Game22Panel.mygoldcont,
        FruitsSlot_Data.myinfoData._7wGold - FruitsSlot_Data.curSelectChoum * FruitsSlot_CMD.D_LINE_COUNT,
        "my_gold_",
        false,
        25,
        true,
        230,
        -43
        )
        FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_start_btn_click)
        self.reqStart()
        return
    end
    if isauto == false and FruitsSlot_Data.byFreeCnt >= 1 then
        FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_start_btn_click)
        self.reqStart()
        return
    end
    if FruitsSlot_Data.isAutoGame == true and self.isReqDataIng == false then
        if self.isHandMoney() == false then
            FruitsSlot_Data.isAutoGame = false
            FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_start_btn_inter, true)
            return
        end
        FruitsSlot_PushFun.CreatShowNum(
        Game22Panel.mygoldcont,
        FruitsSlot_Data.myinfoData._7wGold - FruitsSlot_Data.curSelectChoum * FruitsSlot_CMD.D_LINE_COUNT,
        "my_gold_",
        false,
        25,
        true,
        230,
        -43
        )
        FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_start_btn_click)
        self.reqStart()
        return
    end
    if self.isReqDataIng == false then
        FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_start_btn_inter, true)
    end
end