BirdsAndBeast_Socket = {}

local self = BirdsAndBeast_Socket

local wTableID  --桌子号

self.myChairID = -1
self.isongame = false

--加入游戏消息事件
function BirdsAndBeast_Socket.addGameMessge()
    EventCallBackTable._01_GameInfo = BirdsAndBeast_Socket.OnHandleGameInfo --游戏消息
    EventCallBackTable._02_ScenInfo = BirdsAndBeast_Socket.OnHandleScenInfo --场景消息
    EventCallBackTable._03_LogonSuccess = BirdsAndBeast_Socket.OnGameLogonWin --登陆成功
    EventCallBackTable._04_LogonOver = BirdsAndBeast_Socket.OnGameLogonOver --登陆完成
    EventCallBackTable._05_LogonFailed = BirdsAndBeast_Socket.OnGameLogonLost --登陆失败
    EventCallBackTable._06_Biao_Action = BirdsAndBeast_Socket.onBiaoAction --表情
    EventCallBackTable._07_UserEnter = BirdsAndBeast_Socket.onPlayerEnter --用户进入
    EventCallBackTable._08_UserLeave = BirdsAndBeast_Socket.OnPlayerLeave --用户离开
    EventCallBackTable._09_UserStatus = BirdsAndBeast_Socket.OnPlyaerStatus --用户状态
    EventCallBackTable._10_UserScore = BirdsAndBeast_Socket.OnUserScore --用户分数
    EventCallBackTable._11_GameQuit = BirdsAndBeast_Socket.onGameQuit --退出游戏
    EventCallBackTable._12_OnSit = BirdsAndBeast_Socket.onInSeatOver --用户入座
    EventCallBackTable._13_ChangeTable = BirdsAndBeast_Socket.onChageTable --换桌
    EventCallBackTable._14_RoomBreakLine = BirdsAndBeast_Socket.onRoomBreakLine --断线消息

    --EventCallBackTable._01_GameInfo(1, 1, 1, 1);

    MessgeEventRegister.Game_Messge_Reg(EventCallBackTable)
end

--用户登陆
function BirdsAndBeast_Socket.playerLogon()
    --coroutine.wait(1);

    --error("登陆游戏。。。。");

    local data = {
        [1] = 0, --广场版本 暂时不用
        [2] = 0, --进程版本 暂时不用
        [3] = SCPlayerInfo._01dwUser_Id, --用户 I D
        [4] = SCPlayerInfo._06wPassword, --登录密码 MD5小写加密
        [5] = Opcodes, --机器序列 暂时不用
        [6] = 0,
        [7] = 0
    }

    local LogonUserID = {
        [1] = DataSize.UInt32, --广场版本 暂时不用
        [2] = DataSize.UInt32, --进程版本 暂时不用
        [3] = DataSize.UInt32, --用户 I D
        [4] = DataSize.String33, --登录密码 MD5小写加密
        [5] = DataSize.String100, --机器序列 暂时不用
        [6] = DataSize.byte, --补位
        [7] = DataSize.byte --补位
    }

    local buffer = SetC2SInfo(LogonUserID, data)

    --Network.Send(MH.MDM_GR_LOGON, MH.SUB_GR_LOGON_USERID, buffer, gameSocketNumber.GameSocket);
    Network.Send(MH.MDM_GR_LOGON, 3, buffer, gameSocketNumber.GameSocket)
end

--玩家入座
function BirdsAndBeast_Socket.playerInSeat()
    local buffer = ByteBuffer.New()
    Network.Send(MH.MDM_GR_USER, MH.SUB_GR_USER_SIT_AUTO, buffer, gameSocketNumber.GameSocket)
end

--用户准备
function BirdsAndBeast_Socket.playerPrepare()
    --error("==========发送用户准备==========");
    local Info = {
        [1] = DataSize.byte --旁观标志 必须等于0
    }
    local Data = {[1] = 0} --旁观标志 必须等于0
    local buffer = SetC2SInfo(Info, Data)
    Network.Send(MH.MDM_ScenInfo, MH.SUB_GF_INFO, buffer, gameSocketNumber.GameSocket)
end

--登陆成功
function BirdsAndBeast_Socket.OnGameLogonWin(wMaiID, wSubID, buffer, wSize)
    -- error("=============登陆成功============= " .. TableUserInfo._10wTableID);

    wTableID = TableUserInfo._9wChairID
end

--登陆完成
function BirdsAndBeast_Socket.OnGameLogonOver(wMaiID, wSubID, buffer, wSize)
    --error("=============登陆完成============= 桌子ID" .. wTableID);
    BirdsAndBeast_GameData.playerTable = {}
    BirdsAndBeast_GameData.playerDic = {}
    if (65535 == wTableID) then --不在桌子上
        BirdsAndBeast_Socket.playerInSeat()
    else --若在桌子上 则直接发送玩家准备
        BirdsAndBeast_Socket.playerPrepare()
    end
end

--登陆失败
function BirdsAndBeast_Socket.OnGameLogonLost(wMaiID, wSubID, buffer, wSize)
    error("=============登陆失败=============")
end

--入座完成
function BirdsAndBeast_Socket.onInSeatOver(wMaiID, wSubID, buffer, wSize)
    if (wSize > 0) then
        --error("=============入座失败=============");
    else
        -- error("=============入座成功=============");
        BirdsAndBeast_Socket.playerPrepare()
    end
end

--用户进入
function BirdsAndBeast_Socket.onPlayerEnter(wMaiID, wSubID, buffer, wSize)
    --error("=============用户进入============= chairID ");
    --error("用户进入。。。 wMaiID ：" .. wMaiID .. "  _wSubID : " .. wSubID);
    --error("________onPlayerEnter_____________"..SCPlayerInfo._01dwUser_Id);

    if (TableUserInfo._1dwUser_Id ~= SCPlayerInfo._01dwUser_Id) then
        self.myChairID = TableUserInfo._9wChairID --自己的座位号
    end
    if TableUserInfo._1dwUser_Id == SCPlayerInfo._01dwUser_Id then
        BirdsAndBeast_GameData.myinfoChang(true)
        return
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
        _11byUserStatus = TableUserInfo._11byUserStatus,
        _12score = 0
    }
    BirdsAndBeast_GameData.playerDic["cn_" .. TableUserInfo._1dwUser_Id] = isTableUserInfo
    table.insert(BirdsAndBeast_GameData.playerTable, #BirdsAndBeast_GameData.playerTable + 1, isTableUserInfo)
    jinandyinsha_UserListSp.UserJoin(isTableUserInfo);
    --BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.reflushuserlist, 1)
end

--用户离开
function BirdsAndBeast_Socket.OnPlayerLeave(wMaiID, wSubID, buffer, wSize)
    logYellow("玩家离开");
  
    BirdsAndBeast_GameData.playerDic["cn_" .. TableUserInfo._1dwUser_Id] = nil
    local len = #BirdsAndBeast_GameData.playerTable
    for i = 1, len do
        if BirdsAndBeast_GameData.playerTable[i] ~= nil and (BirdsAndBeast_GameData.playerTable[i]._1dwUser_Id == TableUserInfo._1dwUser_Id) then
            table.remove(BirdsAndBeast_GameData.playerTable, i)
            jinandyinsha_UserListSp.UserLeva(TableUserInfo._1dwUser_Id);
            return
        end
    end
    --BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.reflushuserlist, 2)
end

--用户状态
function BirdsAndBeast_Socket.OnPlyaerStatus(wMaiID, wSubID, buffer, wSize)
    --error("=============用户状态============= chairID " );
end

--用户分数
function BirdsAndBeast_Socket.OnUserScore(wMaiID, wSubID, buffer, wSize)
    if TableUserInfo._1dwUser_Id == SCPlayerInfo._01dwUser_Id then
        error("=1============用户:"..TableUserInfo._1dwUser_Id.." 分数:"..TableUserInfo._7wGold.."============= ");
        BirdsAndBeast_GameData.myinfoChang(false)
        return
    end
    error("=2============用户:"..TableUserInfo._1dwUser_Id.." 分数:"..TableUserInfo._7wGold.."============= ");
    local userinfo = BirdsAndBeast_GameData.playerDic["cn_" .. TableUserInfo._1dwUser_Id]
    userinfo._1dwUser_Id = TableUserInfo._1dwUser_Id
    userinfo._2szNickName = TableUserInfo._2szNickName
    userinfo._3bySex = TableUserInfo._3bySex
    userinfo._4bCustomHeader = TableUserInfo._4bCustomHeader
    userinfo._5szHeaderExtensionName = TableUserInfo._5szHeaderExtensionName
    userinfo._6szSign = TableUserInfo._6szSign
    userinfo._8wPrize = TableUserInfo._8wPrize
    userinfo._9wChairID = TableUserInfo._9wChairID
    userinfo._10wTableID = TableUserInfo._10wTableID
    userinfo._11byUserStatus = TableUserInfo._11byUserStatus
    if self.countscore == true then
        userinfo._12score = TableUserInfo._7wGold - userinfo._7wGold
    else
        userinfo._12score = 0
    end
    userinfo._7wGold = TableUserInfo._7wGold
    jinandyinsha_UserListSp.reflush(userinfo);
end

--换桌
--当所有参数为Null时表示触发了换桌按钮，当不为null时表示收到服务器换桌消息
function BirdsAndBeast_Socket.onChageTable(wMaiID, wSubID, buffer, wSize)
    --error("================换桌============");
end

--退出游戏
function BirdsAndBeast_Socket.onGameQuit(wMaiID, wSubID, buffer, wSize)
    self.isongame = false
    self.initdataandres(1)
    GameSetsBtnInfo.LuaGameQuit()
end

function BirdsAndBeast_Socket.initdataandres(args)
    self.isongame = false
    self.myChairID = -1
    self.countscore = false
    BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.exitgame)
    if args == 1 then
        BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.unload_game_res)
    end
    BirdsAndBeastEvent.destroying()
    BirdsAndBeast_GameData.destroying()
    BirdsAndBeastConfig.destroying()
    MessgeEventRegister.Game_Messge_Un()
end

--表情
function BirdsAndBeast_Socket.onBiaoAction(wMaiID, wSubID, buffer, wSize)
    -- error("================表情================ " );
    --[[ local sChairId = buffer:ReadUInt16();
    local sIndex = buffer:ReadByte();

    point21PlayerTab[sChairId + 1]:playExpression(sIndex);]]
end

--断线消息
function BirdsAndBeast_Socket.onRoomBreakLine(wMaiID, wSubID, buffer, wSize)
    error("================断线===============");
  --Point21ScenCtrlPanel.gameQuit();
  local msgtype = buffer:ReadUInt16();
  local str = buffer:ReadString(buffer:ReadUInt16());
  error("断线：" .. str)
  local tab = GeneralTipsSystem_ShowInfo
  tab._01_Title = ""
  tab._02_Content = str
  tab._03_ButtonNum = 1
  tab._04_YesCallFunction = self.onGameQuit
  tab._05_NoCallFunction = nil
  MessageBox.CreatGeneralTipsPanel(tab)
  --Point21ScenCtrlPanel.ShowMessageBox(str, 1, true)
end

--游戏消息
function BirdsAndBeast_Socket.OnHandleGameInfo(wMaiID, wSubID, buffer, wSize)
    if self.isongame == false then
        return
    end
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMaiID)) + 1, string.len(tostring(wSubID))))
    if sid == BirdsAndBeast_CMD.SUB_SC_CHIP_NORMAL then -- 押注-普通
        logYellow("==========================SUB_SC_CHIP_NORMAL===========================")
        BirdsAndBeast_GameData.mypushchang(buffer, 1)
    elseif sid == BirdsAndBeast_CMD.SUB_SC_CHIP_NUM_CHANGE then --总押注的改变
        logYellow("==========================SUB_SC_CHIP_NUM_CHANGE===========================")
        BirdsAndBeast_GameData.allpushchang(buffer, 1,false)
    elseif sid == BirdsAndBeast_CMD.SUB_SC_HIS_CHANG then --历史记录的改变
        logYellow("==========================SUB_SC_HIS_CHANG===========================")
        BirdsAndBeast_GameData.hischang(buffer, 1)
    elseif sid == BirdsAndBeast_CMD.SUB_SC_IDI_START then --开始
        logYellow("==========================SUB_SC_IDI_START===========================")
        BirdsAndBeast_GameData.gameInit(buffer)
    elseif sid == BirdsAndBeast_CMD.SUB_SC_IDI_CHIP then --下注
        logYellow("==========================SUB_SC_IDI_CHIP===========================")
        BirdsAndBeast_GameData.startChip(buffer)
    elseif sid == BirdsAndBeast_CMD.SUB_SC_IDI_STOP_CHIP then --停止下注
        logYellow("==========================SUB_SC_IDI_STOP_CHIP===========================")
        self.countscore = true
        BirdsAndBeast_GameData.stopChip(buffer)
        BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.reflushuserlist, 1)
    elseif sid == BirdsAndBeast_CMD.SUB_SC_IDI_SEND_POKER then --发牌
        logYellow("==========================SUB_SC_IDI_SEND_POKER===========================")
        BirdsAndBeast_GameData.startRun(buffer)
    elseif sid == BirdsAndBeast_CMD.SUB_SC_IDI_GAME_OVER then --游戏结束
        logYellow("==========================SUB_SC_IDI_GAME_OVER===========================")
        BirdsAndBeast_GameData.gameOver(buffer)
    elseif sid == BirdsAndBeast_CMD.SUB_SC_GAME_WIN then --结算
        logYellow("==========================SUB_SC_GAME_WIN===========================")
        BirdsAndBeast_GameData.gameWin(buffer)
    elseif sid == BirdsAndBeast_CMD.SUB_SC_OPEN_PUSH then --看出下面投注区域的显示
        logYellow("==========================SUB_SC_OPEN_PUSH===========================")
        self.countscore = false
        BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.reflushuserlist, 2)
        BirdsAndBeast_GameData.openPush(buffer)
    elseif sid == BirdsAndBeast_CMD.SUB_SC_CHIP_LIMIT_CHANG then --下注区域的倍数限红改变
        logYellow("==========================SUB_SC_CHIP_LIMIT_CHANG===========================")
        BirdsAndBeast_GameData.multipchang(buffer)
    elseif sid == BirdsAndBeast_CMD.SUB_SC_CHIP_NORMAL_LIST then --批量-押注-普通
        logYellow("==========================SUB_SC_CHIP_NORMAL_LIST===========================")
        BirdsAndBeast_GameData.mypushchang_list(buffer)
    elseif sid == BirdsAndBeast_CMD.SUB_SC_CHIP_NUM_CHANGE_LIST then --总押注批量的改变
        logYellow("==========================SUB_SC_CHIP_NUM_CHANGE_LIST===========================")
        BirdsAndBeast_GameData.allpushchang_list(buffer)
    elseif sid == BirdsAndBeast_CMD.SUB_SC_CAI_RATE then --彩金的倍数
        logYellow("==========================SUB_SC_CAI_RATE===========================")
        BirdsAndBeast_GameData.caiJinChang(buffer)
    end
end

--场景消息
function BirdsAndBeast_Socket.OnHandleScenInfo(wMaiID, wSubID, buffer, wSize)
    --error("====11=========场景消息============="..wSize);
    self.isongame = true
    --登录的时候，先把数据归于初始
    BirdsAndBeast_GameData.initData()
    --检出下注的倍数和限红
    BirdsAndBeast_GameData.multipchang(buffer)
    --筹码的改变
    BirdsAndBeast_GameData.choumChang(buffer)
    --总下注的改变 这里有刚登录的总共改变，和下注的时候单个改变，所以用size
    BirdsAndBeast_GameData.allpushchang(buffer, BirdsAndBeast_CMD.D_ANIMAL_OR_COLOR_AREA_COUNT,true)
    --自己下注的改变 这里有刚登录的总共改变，和下注的时候单个改变，所以用size
    BirdsAndBeast_GameData.mypushchang(buffer, BirdsAndBeast_CMD.D_ANIMAL_OR_COLOR_AREA_COUNT)
    --历史记录
    BirdsAndBeast_GameData.hischang(buffer, BirdsAndBeast_CMD.D_HIS_COUNT)
    --游戏状态
    BirdsAndBeast_GameData.gameStateChang(buffer)
    --游戏时间
    BirdsAndBeast_GameData.gameTimereChang(buffer)
    BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.gameinit, nil)
    BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.reflushuserlist, 1)
    if Util.isApplePlatform or Util.isAndroidPlatform then
        GameSetsBtnInfo.SetPlaySuonaPos(-3000, 0, 0)
    end
    logYellow("场景接收完成")
end

--播放声
--isbgsound true 播放的是音乐 不然就是音效, isplay 是背景音乐的时候 它是播放还是停止 issave是不是要保存这个音效
function BirdsAndBeast_Socket.playaudio(audioname, isbgsound, isplay, issave)
    if BirdsAndBeast_GameData.soundres == nil then
        logYellow("没找到音效资源组");
        BirdsAndBeast_GameData.soundres = GameObject.Find("bad_sound").gameObject;
        self.playaudio(audioname,isbgsound,isplay,issave)
       
        return
    end
    local obj =  BirdsAndBeast_GameData.soundres.transform:Find(audioname):GetComponent("AudioSource");
    if (obj  == nil) then 
        logYellow("没有找到指定的音效："..audioname);
        return;
    end
    local musicchip = obj.clip
    if isbgsound == true then
        MusicManager:PlayBacksoundX(musicchip, isplay)
    else
        if issave == true then
            BirdsAndBeast_GameData.savesound = MusicManager:PlayX(musicchip).gameObject
        else
            MusicManager:PlayX(musicchip)
        end
    end
end

--请求下注
function BirdsAndBeast_Socket.reqChipNormal(BirdsAndBeastType, valu)

    if BirdsAndBeast_GameData.gameState ~= BirdsAndBeast_CMD.D_GAME_STATE_CHIP or  valu <= 0 then
        return
    end
    if toInt64(valu) > toInt64(BirdsAndBeast_GameData.myinfoData._7wGold) then
        MessageBox.CreatGeneralTipsPanel("金币不足，无法下注！");
        return
    end
    if BirdsAndBeast_GameData.pushmoney_data[BirdsAndBeastType] + valu > BirdsAndBeast_GameData.multiple_data[BirdsAndBeastType].limt then
        return
    end
    local bf = ByteBuffer.New()
    BirdsAndBeastType = self.GetIconTypeToServer(BirdsAndBeastType);
    bf:WriteByte(BirdsAndBeastType)
    bf:WriteUInt32(valu)
    BirdsAndBeast_GameData.lastChip = {badtype = BirdsAndBeastType, va = valu}
    logYellow("点击下注："..BirdsAndBeastType.."  "..valu);
    Network.Send(MH.MDM_GF_GAME, BirdsAndBeast_CMD.SUB_CS_CHIP_NORMAL, bf, gameSocketNumber.GameSocket)
    BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.continuechipiter, false)
end
function BirdsAndBeast_Socket.GetIconTypeToServer(args)
    if (args == BirdsAndBeastConfig.bab_yanz) then
        return 8;
     end
     if (args == BirdsAndBeastConfig.bab_gez) then
        return 9;
     end
     if (args == BirdsAndBeastConfig.bab_kongq) then
        return 4;
     end
     if (args == BirdsAndBeastConfig.bab_laoy) then
        return 5;
     end
     if (args == BirdsAndBeastConfig.bab_shiz) then
        return 6;
     end
     if (args == BirdsAndBeastConfig.bab_xiongm) then
        return 7;
     end
     if (args == BirdsAndBeastConfig.bab_zous) then
        return 3;
     end
     if (args == BirdsAndBeastConfig.bab_tuz) then
        return 11;
     end
     if (args == BirdsAndBeastConfig.bab_yins) then
        return 2;
     end
     if (args == BirdsAndBeastConfig.bab_jinsha) then
        return 1;
     end
  
     if (args == BirdsAndBeastConfig.bab_houz) then
        return 10;
     end
     if (args == BirdsAndBeastConfig.bab_feiq) then
        return 0;
     end
end
--清空下注
function BirdsAndBeast_Socket.clearChipNormal()
    if BirdsAndBeast_GameData.gameState ~= BirdsAndBeast_CMD.D_GAME_STATE_CHIP then
        return
    end
    local cont = self.myNumPushMoeny(BirdsAndBeast_GameData.pushmoney_data)
    if cont == 0 then
        return
    end
    local bf = ByteBuffer.New()
    Network.Send(MH.MDM_GF_GAME, BirdsAndBeast_CMD.SUB_CS_CLEAR_MYPUSHMONEY, bf, gameSocketNumber.GameSocket)
    --BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.continuechipiter, true)
    coroutine.start(
        function()
            coroutine.wait(1)
            BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.continuechipiter, true)
        end
    )
end

--计算金额  这里有自己的下注 总下注 和上一次下注 所以要传入要计算的table
function BirdsAndBeast_Socket.myNumPushMoeny(contTable)
    local cont = 0
    table.foreachi(
        contTable,
        function(i, k)
            if k > 0 then
                cont = cont + k
            end
        end
    )
    return cont
end

--续压
function BirdsAndBeast_Socket.continueChipNormal()
    -- --这个游戏的续压改成了上一次的押注
    -- if BirdsAndBeast_GameData.lastChip~=nil then
    --    self.reqChipNormal(BirdsAndBeast_GameData.lastChip.badtype,BirdsAndBeast_GameData.lastChip.va);
    -- end
    if BirdsAndBeast_GameData.gameState ~= BirdsAndBeast_CMD.D_GAME_STATE_CHIP then
        return
    end
    BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.continuechipiter, false)
    for i = 0, #BirdsAndBeast_GameData.pushmoneylast_data do
        if (BirdsAndBeast_GameData.pushmoneylast_data[i] > 0 ) then
            local bf = ByteBuffer.New()
            bf:WriteByte(self.GetIconTypeToServer(i));
            bf:WriteUInt32(BirdsAndBeast_GameData.pushmoneylast_data[i])
            Network.Send(MH.MDM_GF_GAME, BirdsAndBeast_CMD.SUB_CS_CHIP_NORMAL, bf, gameSocketNumber.GameSocket)
        end
    end
end

