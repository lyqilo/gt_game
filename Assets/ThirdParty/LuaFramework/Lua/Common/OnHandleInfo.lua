OnHandleInfo = {}
local self = OnHandleInfo

--- 大厅登录信息
function OnHandleInfo.LoginInfo(wMaiID, wSubID, buffer, wSize)
    --if (wSubID == MH.SUB_3D_SC_VERSION) then
    --    log("版本信息")
    --    local data = GetS2CInfo(SC_Version, buffer)
    --    Event.Brocast(tostring(wSubID), data)
    --elseif (wSubID == MH.SUB_3D_SC_CODE) then
    --    log("验证码信息")
    --    local data = GetS2CInfo(SC_Code, buffer)
    --    logTable(data)
    --    Event.Brocast(tostring(wSubID), data)
    --elseif (wSubID == MH.SUB_3D_SC_REGISTER) then
    --    log("注册信息")
    --    if wSize == 0 then
    --        Event.Brocast(tostring(wSubID), 0)
    --        return
    --    end
    --    Event.Brocast(tostring(wSubID), buffer:ReadString(wSize))
    --elseif (wSubID == MH.SUB_3D_SC_LOGIN_FAILE) then
    --    local length = buffer:ReadInt32()
    --    local _error = buffer:ReadString(length)
    --    LogonScenPanel.LogonBtnError(_error)
    --elseif (wSubID == MH.SUB_3D_SC_LOGOUT) then
    --    log("注销帐号")
    --    SetInfoSystem.AccountChange()
    --    Network.Close(gameSocketNumber.HallSocket);
    --    Network.Close(gameSocketNumber.GameSocket);
    --elseif (wSubID == MH.SUB_3D_SC_SYSTEM_INFO) then
    --    log("收到系统信息")
    --    local V = GetS2CInfo(SC_SystemInfo, buffer)
    --    SCSystemInfo._1wWebServerAddressData = V[1]
    --    SCSystemInfo._2wWebServerAddress = V[2]
    --    local address = string.split(SCSystemInfo._2wWebServerAddress, ":")
    --    if gameip ~= nil then
    --        SCSystemInfo._2wWebServerAddress = "http://" .. gameip .. ":8088"
    --    end
    --    SCSystemInfo._3wHeaderDirData = V[3]
    --    SCSystemInfo._4wHeaderDir = "Header"
    --    SCSystemInfo._5wHeaderUpLoadPageData = V[5]
    --    SCSystemInfo._6wHeaderUpLoadPage = V[6]
    --    SCSystemInfo._7dwPresentMinGold = V[7]
    --    SCSystemInfo._8wFastStartGameId = V[8]
    --    SCSystemInfo._9dwChangeNickNameOrSexNeedGold = V[9]
    --    SCSystemInfo._10wEverydayLotteryMaxCount = V[10]
    --    SCSystemInfo._11wFirstRechargePresentRate = V[11]
    --    SCSystemInfo._12dwFirstChangeNickNameOrSexPrizeGold = V[12]
    --    SCSystemInfo._13wStartRechargePresentRate = V[13]
    --
    --    Event.Brocast(tostring(MH.SUB_3D_SC_LOGIN_SUCCESS))
    --    Network.RestSendMsg(gameSocketNumber.HallSocket)
    --    Network.ResetNetwork(gameSocketNumber.HallSocket)
    --elseif wSubID == MH.SUB_3D_SC_GAME_HEART then
    --    HallScenPanel.heartBack = true;
    --elseif (wSubID == MH.SUB_3D_SC_ROOM_INFO_BEGIN) then
    --    HallScenPanel.isReceiveRoomInfo = false;
    --elseif (wSubID == MH.SUB_3D_SC_ROOM_INFO_END) then
    --    HallScenPanel.isReceiveRoomInfo = true;
    --elseif (wSubID == MH.SUB_3D_SC_ROOM_INFO) then
    --    --logError(#AllSCGameRoom)
    --    --logError("房间信息****************************************************************");
    --    local n = buffer:ReadUInt32()
    --    for i = 1, n do
    --        local Info = {}
    --        Info._1byFloorID = buffer:ReadByte()
    --        Info._2wGameID = buffer:ReadUInt16()
    --        Info._3wRoomID = buffer:ReadUInt16()
    --        Info._4dwServerAddr = NetworkHelper.Int2IP(buffer:ReadUInt32())
    --        Info._5wServerPort = buffer:ReadUInt16()
    --        Info._6iLessGold = buffer:ReadInt32()
    --        Info._7dwOnLineCount = buffer:ReadUInt32()
    --        Info._8NameLenght = buffer:ReadUInt16()
    --        Info._9Name = buffer:ReadString(Info._8NameLenght)
    --        Info._10BL = "1"
    --        local count = 0
    --        --log("房间信息："..Info._9Name);
    --        -- logErrorTable(Info)
    --        for i = 1, #AllSCGameRoom do
    --            if
    --            AllSCGameRoom[i]._9Name == Info._9Name or
    --                    (AllSCGameRoom[i]._2wGameID == Info._2wGameID and AllSCGameRoom[i]._1byFloorID == Info._1byFloorID)
    --            then
    --                count = count + 1
    --                AllSCGameRoom[i] = Info
    --            end
    --        end
    --        if count == 0 then
    --            table.insert(AllSCGameRoom, Info)
    --        end
    --
    --        GameManager.isLoadGameList = true
    --    end
    --else
    if (wSubID == MH.SUB_3D_SC_LOGIN_SUCCESS) then
        logWarn("收到大厅登录成功")
        local V = GetS2CInfo(SC_LoginSuccess, buffer)

        --用户ID
        --SCPlayerInfo._01dwUser_uuID = V[1];
        --用户靓号
        SCPlayerInfo._01dwUser_Id = V[1]
        SCPlayerInfo._beautiful_Id = V[2]
        --性别
        SCPlayerInfo._02bySex = V[3]
        --是否自定义头像
        SCPlayerInfo._03bCustomHeader = V[4]
        --账号 4.长度 5.字符串
        SCPlayerInfo._04wAccount = V[6]
        --昵称 6.长度 7.字符串
        SCPlayerInfo._05wNickName = V[8]
        --昵称 8.长度 9字符串
        SCPlayerInfo._06wPassword = V[10]
        SCPlayerInfo._6wPassword = SCPlayerInfo._06wPassword
        -- 头像扩展名 10.长度 11.字符串
        SCPlayerInfo._07wHeaderExtensionName = V[12]
        --签名 12.长度 13.字符串
        SCPlayerInfo._08wSign = V[14]
        --应该领取的时间ID 等于INVALID_DWORD表示今天的在线奖励已经领取完成
        SCPlayerInfo._09dwShouldGet_Time_Id = V[15]
        --已经在线时间
        SCPlayerInfo._10dwHasOnlineTime = V[16]
        --已经抽奖次数
        SCPlayerInfo._11dwHasLotteryCount = V[17]
        --是否完成每日对战
        SCPlayerInfo._12bFinishEverydayGame = V[18]
        --是否已经领取兑换码奖励
        SCPlayerInfo._13bHasGetExchangeCodeAward = V[19]
        --已经分享天数
        SCPlayerInfo._14byHasShareDay_Id = V[20]
        --今天是否已经领取
        SCPlayerInfo._15bTodayShare = V[21]
        --是否首充
        SCPlayerInfo._16bIsFirstRecharge = V[22]
        --是否已经修改昵称或者性别
        SCPlayerInfo._17bHasChangeNameOrSex = V[23]
        --抽奖CD时间
        SCPlayerInfo.dwlotteryCDTime = V[24]
        --头像ID
        SCPlayerInfo.faceID = V[25]

        --SCPlayerInfo.byIsFirstRecharge1 = V[26]
        --SCPlayerInfo.byIsFirstRecharge2 = V[27]
        --SCPlayerInfo.byIsFirstRecharge3 = V[28]
        --SCPlayerInfo.byIsFirstRecharge4 = V[29]
        --SCPlayerInfo.byIsFirstRecharge5 = V[30]
        --是否修改过头像
        SCPlayerInfo.isChangeHead = V[26]
        SCPlayerInfo.isChangeSign = V[27]
        SCPlayerInfo.isChangeAccount = V[28]
        SCPlayerInfo.headKey = V[29]

        SCPlayerInfo.bBindInviteCode = V[30]
        SCPlayerInfo.IsAccount = V[31]
        -- 是否VIP账号
        SCPlayerInfo.IsVIP = V[32]
        SCPlayerInfo.redpaacketOFF = V[33]
        SCPlayerInfo._29szPhoneNumber = V[35]
        SCPlayerInfo._36ReconnectGameID = V[36]
        SCPlayerInfo._37ReconnectFloorID = V[37]
        logTable(SCPlayerInfo)
        log("登录个人信息数据")
        --Event.Brocast(tostring(MH.SUB_3D_SC_LOGIN_SUCCESS));
        --LogonScenPanel.LogonBtnCallBack()
    --elseif (wSubID == MH.SUB_3D_SC_AccoutError) then
    --    --MessageBox.CreatGeneralTipsPanel("账号或密码错误")
    --    LogonScenPanel.LogonBtnError("账号或密码错误")
    --elseif wSubID == MH.SUB_3D_SC_ACCOUNT_OFFLINE then
    --    -- 帐号被挤下
    --    PlayerPrefs.SetString("AutoLogin", "0");
    --
    --    LogonScenPanel.restConnectCount = 999
    --    logError("-- 帐号被挤下")
    --    local pop = FramePopoutCompent.Pop.New()
    --    pop._02conten = "你的帐号在另一地方登录！"
    --    pop._99last = true
    --    pop._06noBtnCallFunc = function()
    --        if LaunchModule.modulePanel ~= HallScenPanel.modulePanel then
    --            logError("没有在大厅")
    --            Util.ResetGame()
    --            return
    --        end
    --        LogonScenPanel.Create()
    --    end
    --    pop.isBig = true;
    --    FramePopoutCompent.Add(pop)
    --    Network.Close(gameSocketNumber.GameSocket);
    --    Network.Close(gameSocketNumber.HallSocket);
    --elseif wSubID == MH.SUB_3D_SC_NEED_LOGIN_ACCREDIT_CODE then
    --    -- 需要登录验证
    --    logError("需要验证登录,弹出验证界面")
    --    LogonScenPanel.ShowCodeLogin()
    --elseif wSubID == MH.SUB_3D_SC_RESET_PASSWORD_CODE then
    --    -- 判断是在银行还是登陆界面
    --    logError("重置密码====验证码服务器返回")
    --    Event.Brocast(tostring(wSubID), buffer, wSize)
    --elseif wSubID == MH.SUB_3D_SC_RESET_PASSWORD then
    --    logError("重置密码服务器返回")
    --    --  if BankPanel.BankPanelObj ==nil then
    --    -- else
    --    -- LogonScenPanel.UpdatePwdSuccess(buffer,wSize)
    --    -- end
    --    Event.Brocast(tostring(wSubID), buffer, wSize)
    --elseif wSubID == MH.SUB_SC_RES_MODIFY_USER_PASSWD_CHECK_CODE then
    --    local code = buffer:ReadInt32();
    --    if code <= 0 then
    --        MessageBox.CreatGeneralTipsPanel("该手机号未注册");
    --    end
    end
end

self.isshowmymoney = true
function OnHandleInfo.HeartInfo(wMaiID, wSubID, buffer, wSize)
    log("大厅心跳");
end
-- 登录成功下发的个人信息
function OnHandleInfo.PersonalInfo(wMaiID, wSubID, buffer, wSize)
    if (wSubID == MH.SUB_3D_SC_USER_PROP) then
        -- hz123
        local V = GetS2CInfo(SC_User_Prop, buffer)
        logErrorTable(V)
        AllSCUserProp = {}
        local len = table.getn(AllSCUserProp)
        local tmeNum = nil
        for i = 1, #(AllSCUserProp) do
            if AllSCUserProp[i][1] == V[1] then
                tmeNum = i
            end
        end
        if tmeNum ~= nil then
            AllSCUserProp[tmeNum] = V
        else
            table.insert(AllSCUserProp, V)
        end

        Event.Brocast(PanelListModeEven._015ChangeGoldTicket)
    elseif wSubID == MH.SUB_3D_SC_CHANGE_PASSWORD then
        -- Event.Brocast(tostring(wSubID), buffer, wSize);
        if wSize == 0 then
            PersonalInfoSystem.UpdataPasswordPanelCallBack(buffer, wSize)
        else
            MessageBox.CreatGeneralTipsPanel("修改密码失败：" .. buffer:ReadString(wSize))
            changePassWordPanel.UpdataPasswordPanelCallBack()
            PersonalInfoSystem.UpdataPasswordPanelFillCallBack()

        end
    elseif wSubID == MH.SUB_3D_SC_CHANGE_NICKNAME then
        --   Event.Brocast(tostring(EventIndex.OnClick), buffer, wSize);
        --PersonalInfoSystem.UpdataNickNameCallBack(buffer, wSize)
    elseif wSubID == MH.SUB_3D_SC_CHANGE_ACCOUNT then
        -- Event.Borcast(tostring(wSubID), buffer, wSize);
        log("绑定手机返回")
        if wSize == 0 then
            BDPhonePanel.UpdataPhoneNumberCallBack(buffer, wSize)
        else
            MessageBox.CreatGeneralTipsPanel("绑定手机号失败：" .. buffer:ReadString(wSize))
        end
    elseif wSubID == MH.SUB_3D_SC_CHANGE_SIGN then
        -- PersonalInfoSystem.UpdataPhoneNumberCallBack(buffer, wSize);
        local str = "修改失败"
        if wSize == 0 then
        else
            str = str .. buffer:ReadString(wSize)
        end
        PersonalInfoSystem.LeaveWordCallBack(wSize, str)
    elseif wSubID == MH.SUB_3D_SC_USER_INFO_SELECT then
        -- 查询用户信息

        local data = GetS2CInfo(SC_UserInfoSelect, buffer)
        logTable(data)
        if SeleteInfoToWindows == 1 then
            GiveRedBag.checknameRes(data)
            PersonalInfoSystem.checkNameEnd(data)
        else
            PlayerInfoSystem.SelectUserInfoCallBack(data)
        end
    elseif wSubID == MH.SUB_3D_SC_USER_NEW_HAND_START then
        -- 玩家新手引导开始
        UserNewHand = {}
    elseif wSubID == MH.SUB_3D_SC_USER_NEW_HAND then
        -- 读取玩家新手引导表

        local data = GetS2CInfo(SC_UserNewHand, buffer)

        table.insert(UserNewHand, #UserNewHand + 1, data)
    elseif wSubID == MH.SUB_3D_SC_USER_NEW_HAND_STOP then
        -- 玩家新手引导表结束
        table.sort(
                UserNewHand,
                function(a, b)
                    return a[1] > b[1]
                end
        )

        if #UserNewHand > 0 then
            if UserNewHand[1][1] >= 103 then
                IsShowGuide = false
            else
                if gameIsOnline then
                    IsShowGuide = true
                else
                    IsShowGuide = false
                end
            end
        else
            IsShowGuide = true
        end
    elseif wSubID == MH.SUB_3D_SC_USER_NEW_HAND_FINISH then
        -- 数据大小为0表示成功，否则直接取字符串看错误
        --   GuidePanelSystem.SCInfo(buffer, wSize);
    elseif wSubID == MH.SUB_3D_SC_USER_VIP_SELECT then
        LogonScenPanel.SCVIP(buffer, wSize)
    elseif wSubID == MH.SUB_3D_SC_USER_FIRST_RECHARGE_START then
        FirstReChargeInfoData = {}
    elseif wSubID == MH.SUB_3D_SC_USER_FIRST_RECHARGE then
        local data = GetS2CInfo(SC_UserNewHand, buffer)
        table.insert(FirstReChargeInfoData, #FirstReChargeInfoData + 1, data[1])
    elseif wSubID == MH.SUB_3D_SC_USER_FIRST_RECHARGE_STOP then
    elseif wSubID == MH.SUB_3D_SC_STRONG_SET_PASSWORD then
        -- 修改保险箱密码（0成功）
        logError("--修改保险箱密码（0成功）")
        BankPanel.SetPwdBtnCallBack(buffer, wSize)
    elseif wSubID == MH.SUB_3D_SC_STRONG_SAVE then
        -- 保险箱--存入 数据大小为0表示成功
        error("----保险箱--存入 数据大小为0表示成功")
        BankPanel.SaveGoldBtnCallBack(buffer, wSize)
    elseif wSubID == MH.SUB_3D_SC_STRONG_GET then
        ----保险箱--取出
        error(" ----保险箱--取出")
        BankPanel.GetGoldBtnCallBack(buffer, wSize)
    elseif wSubID == MH.SUB_3D_SC_SET_LOGIN_VALIDATE then
        -- 设置登录验证
        error("--设置登录验证")
        changePassWordPanel.SetCodeBtnSuccess(buffer, wSize)
    elseif wSubID == MH.SUB_3D_SC_STRONG_BOX_COME_IN then
        BankPanel.InBankInfo(buffer, wSize)
    elseif wSubID == MH.SUB_3D_SC_NOTIFY_CHANGE_USER_INFO then
        -- 通知修改消息
        HallScenPanel.UpdatePersonInfo(buffer, wSize)
    elseif wSubID == MH.SUB_3D_SC_SELECT_GOLD_MSG_RES then
        --end
        -- 查询玩家金币消息
        logError("打印数据")
        local V = GetS2CInfo(New_SC_User_Prop, buffer)
        local tmeNum = nil
        for i = 1, #(AllSCUserProp) do
            if AllSCUserProp[i][1] == V[2] then
                tmeNum = i
            end
        end
        if tmeNum ~= nil then
            --AllSCUserProp[tmeNum][7] = V[4]
            gameData.ChangProp(V[4], enum_Prop_Id.E_PROP_GOLD)
        else
            table.insert(AllSCUserProp, V)
        end
        Event.Brocast(PanelListModeEven._015ChangeGoldTicket)
    elseif wSubID == MH.SUB_3D_SC_QUERYLOGINVERIFY_RES then
        HallScenPanel.CheckLoginCodeBack(buffer)
        changePassWordPanel.CheckLoginCodeBack(buffer)
    elseif wSubID == MH.SUB_3D_SC_ChangeHeader then
        local changeResult = buffer:ReadByte();
        log("===============修改头像回调" .. changeResult);
        if changeResult == 0 then
            MessageBox.CreatGeneralTipsPanel("更改头像失败");
        else
            HallScenPanel.ChangeHead(changeResult);
            PersonalInfoSystem.CloseChangeHeadPanelCall()
            MessageBox.CreatGeneralTipsPanel("更改头像成功");
        end
    elseif wSubID == MH.SUB_3D_SC_QUERY_EXCHANGE_CODE then
        QueryPanel.ExchangeCallBack(buffer);
    elseif wSubID == MH.SUB_3D_SC_QUERY_UP_SCORE_RECORD then
        QueryPanel.RecordCallBack(buffer);
    elseif wSubID == MH.SUB_3D_SC_USER_GOLD then
        local userId = buffer:ReadInt32();
        local mGold = buffer:ReadInt64Str();
        log("金币：" .. mGold);
        gameData.ChangProp(mGold, enum_Prop_Id.E_PROP_GOLD)
        Event.Brocast(PanelListModeEven._015ChangeGoldTicket)
    elseif wSubID == MH.SUB_3D_SC_DIANKA_QUERY then
        Event.Brocast(DuiHuanPanel.QueryCard, buffer);
    elseif wSubID == MH.SUB_3D_SC_DIANKA_RECEIVE then
        Event.Brocast(DuiHuanPanel.ReceiveCard, buffer);
    elseif wSubID == MH.SUB_3D_SC_DIANKA_GIVE then
        Event.Brocast(ZSCardPanel.ZSCardResult, buffer);
    end
end
BinPhoneResult = {
    [1] = DataSize.String100
}
-- 免费金币，任务的信息
function OnHandleInfo.FreeGoldInfo(wMaiID, wSubID, buffer, wSize)
    if wSubID == MH.SUB_3D_SC_ONLINE_AWARD_STOP then
    elseif wSubID == MH.SUB_3D_SC_ONLINE_AWARD_START then
        AllOnlineAward = {}
    elseif wSubID == MH.SUB_3D_SC_ALMS_START then
        HallReliefmoney.startRelieFmoneyTable()
    elseif wSubID == MH.SUB_3D_SC_ALMS then
        HallReliefmoney.getIngRelieFmoneyTable(buffer)
    elseif wSubID == MH.SUB_3D_SC_ALMS_STOP then
        HallReliefmoney.EndRelieFmoneyTable()
    elseif wSubID == MH.SUB_3D_SC_ALMS_USER_GET then
        HallReliefmoney.reqReliefRes(buffer)
    elseif wSubID == MH.SUB_3D_SC_ALMS_USER_GET_FAIL then
        MessageBox.CreatTishiPanel("领取失败，两次领取需间隔10分钟")
        HallReliefmoney.reqRelieResFail(buffer)
    elseif wSubID == MH.SUB_3D_SC_ONLINE_AWARD then
        -- 显示在线奖励道具金币
    elseif wSubID == MH.SUB_3D_SC_EVERY_LOTTERY_AWARD_STOP then
        -- 显示每日抽奖结束
    elseif wSubID == MH.SUB_3D_SC_EVERY_LOTTERY_AWARD then
        -- 显示每日抽奖奖励
        -- error("显示每日抽奖奖励");
        --   error("显示每日抽奖结束==显示表长度"..table.getn(AllEveryLotteryAward));
    elseif wSubID == MH.SUB_3D_SC_GET_EVERY_LOTTERY_AWARD then
        -- 领取每日抽奖奖励 数据大小为4表示成功，否则直接取字符串看错误原因
        -- log("执行领取每日抽奖奖励")
    elseif wSubID == MH.SUB_3D_SC_GET_ONLINE_AWARD then
        --        -- 领取在线奖励 数据大小为0表示成功，否则直接取字符串看错误原因
    elseif wSubID == MH.SUB_3D_SC_GET_EXCHANGE_CODE_AWARD then
        -- PersonalInfoSystem.ChangeCodeFill();
        -- 领取兑换码奖励 数据大小为0表示成功，否则直接取字符串看错误原因
        local m = buffer:ReadByte();
        local m2 = buffer:ReadString(1024)
        if m == 0 then
            MessageBox.CreatGeneralTipsPanel(m2, function()
                PersonalInfoSystem.SetDuiHuan_ButtonShow(true)
            end);
            PersonalInfoSystem.SetDuiHuan_ButtonShow(true)
        else
            --MessageBox.CreatGeneralTipsPanel("恭喜您兑换成功，获得"..LogonScenPanel.GWData.ExchangeNumber.."金币!", function()
            --    PersonalInfoSystem.SetDuiHuan_ButtonShow(true)
            --end);

            MessageBox.CreatGeneralTipsPanel(m2, function()
                PersonalInfoSystem.SetDuiHuan_ButtonShow(true)
            end);
            PersonalInfoSystem.SetDuiHuan_ButtonShow(true)
        end
    elseif wSubID == MH.SUB_3D_SC_FINISH_EVERYDAY_GAME then
        -- 每日对战领取成功
        --        local noticeText = "完成每日对战，成功领取相应对战奖励";
        -- Network.OnException(95028);
        --FramePopoutCompent.Show("完成每日对战，成功领取相应对战奖励！")
        --SCPlayerInfo._12bFinishEverydayGame = 1;
    elseif wSubID == MH.SUB_3D_SC_EXCHANGE_CODE_AWARD then
        -- 兑换码奖励物品
    elseif wSubID == MH.SUB_3D_SC_EXCHANGE_CODE_AWARD_STOP then
        -- 兑换码显示结束
    elseif wSubID == MH.SUB_3D_SC_EVERYDAY_GAME_AWARD then
        -- 每日对战奖励物品
    elseif wSubID == MH.SUB_3D_SC_EVERYDAY_GAME_AWARD_STOP then
        -- 每日对战奖励结束
    elseif wSubID == MH.SUB_3D_SC_PHONE_NUM_AWARD then
        -- 手机用户奖励显示
    elseif wSubID == MH.SUB_3D_SC_PHONE_NUM_AWARD_STOP then
        -- 手机显示结束
    elseif wSubID == MH.SUB_3D_SC_LOTTERY_COUNT then
        -- 抽奖次数显示
        local value = GetS2CInfo(SC_LotteryCount, buffer)
        local LotteryCount = {}
        LotteryCount._1dwLotteryCount_Id = value[1]
        LotteryCount._2dwMinCount = value[2]
        LotteryCount._3dwMaxCount = value[3]
        LotteryCount._4dwNeedGold = value[4]
        local count = 0
        for i = 1, table.getn(AllEveryCount) do
            if AllEveryCount[i]._1dwLotteryCount_Id == LotteryCount._1dwLotteryCount_Id then
                count = count + 1
            end
        end
        if count == 0 then
            table.insert(AllEveryCount, LotteryCount)
        end
    elseif wSubID == MH.SUB_3D_SC_LOTTERY_COUNT_STOP then
        -- 抽奖次数结束
        -- error("抽奖次数数据传送完成结束==================================");
    elseif wSubID == MH.SUB_3D_SC_SHARE_AWARD_START then
        ShareAward = {}
    elseif wSubID == MH.SUB_3D_SC_SHARE_AWARD then
        local data = GetS2CInfo(SC_ShareAward, buffer)
        table.insert(ShareAward, #ShareAward + 1, data)
    elseif wSubID == MH.SUB_3D_SC_SHARE_AWARD_STOP then
    elseif wSubID == MH.SUB_3D_SC_SHARE_AND_GET_AWARD then
        -- 数据为0为分享成功，否则打印看结果
        SetInfoSystem.ShareEndSCInfo(buffer, wSize)
    elseif wSubID == MH.SUB_3D_SC_FINISH_ALLDAY_GAME then
        -- 完成全天对战
        MoveNotifyInfoClass.QuanDayNotice()
    elseif wSubID == MH.SUB_3D_SC_DOWN_RESOURCE_DANCER_FINISH then
        -- 完成点舞下载
    elseif wSubID == MH.SUB_3D_SC_DOWN_GAME_RESOURCE_START then
        DownGameResource = {}
    elseif wSubID == MH.SUB_3D_SC_DOWN_GAME_RESOURCE then
        local data = GetS2CInfo(CMD_3D_SC_DownResourceGame, buffer)
        table.insert(DownGameResource, #DownGameResource + 1, data)
    elseif wSubID == MH.SUB_3D_SC_DOWN_GAME_RESOURCE_STOP then
    elseif wSubID == MH.SUB_3D_SC_DOWN_RESOURCE_DANCER_FINISH then
        -- 完成游戏下载
        DownGameResource = { 1, 2, 3 }
    elseif wSubID == MH.SUB_3D_SC_NEW_GET_LOTTERY_AWARD_LOTTERY_ID then
    elseif wSubID == MH.SUB_3D_SC_NEW_GET_LOTTERY_AWARD_GET then
    elseif wSubID == MH.SUB_3D_SC_FREE_GOLD_LIST_START then
    elseif wSubID == MH.SUB_3D_SC_FREE_GOLD_LIST then
    elseif wSubID == MH.SUB_3D_SC_FREE_GOLD_LIST_STOP then
    elseif wSubID == MH.SUB_3D_SC_GET_SIGN_AWARD then
    elseif wSubID == MH.SUB_3D_SC_SELECT_EXCHANGE_CODE then
        PersonalInfoSystem.duihuanmaSc(buffer, wSize)
    end
end

-- 登录大厅消息
function OnHandleInfo.HallLoginInfo(wMaiID, wSubID, buffer, wSize)
    -- 100--登录成功
    -- 101--登录失败
    -- 102--登录完成
    if wSubID == SUB_GR_LOGON_SUCCESS then
    elseif wSubID == SUB_GR_LOGON_ERROR then
        local _error = buffer:ReadString(wSize)
        error("登录出错" .. _error)
        FramePopoutCompent.Show("登录出错")
    elseif wSubID == SUB_GR_LOGON_FINISH then
    end
end

-- 登录游戏
function OnHandleInfo.GameLoginInfo(wMaiID, wSubID, buffer, wSize)
    -- 可以把Mid,SubID分离出来，
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMaiID)) + 1, string.len(tostring(wSubID))))
    if sid == MH.SUB_GR_LOGON_SUCCESS then
        local t = GetS2CInfo(CMD_3D_Table_UserData, buffer)

        -- 把数组赋值到具体结构中
        TableUserInfo._1dwUser_Id = t[1]
        TableUserInfo._2szNickName = t[3]
        TableUserInfo._3bySex = t[4]
        TableUserInfo._4bCustomHeader = t[5]
        TableUserInfo._5szHeaderExtensionName = t[7]
        TableUserInfo._6szSign = t[9]
        TableUserInfo._7wGold = t[10]
        TableUserInfo._8wPrize = t[11]
        TableUserInfo._9wChairID = t[12]
        TableUserInfo._10wTableID = t[13]
        TableUserInfo._11byUserStatus = t[14]
        -- 发送给具体游戏
        error("Lua层收到登录游戏成功" .. TableUserInfo._2szNickName)
        error("Lua层收到登录游戏成功" .. TableUserInfo._10wTableID)
        HallScenPanel.IsInGame = true;
        HallScenPanel.isReconnectGame = false;
        HallScenPanel.reconnectRoomInfo = nil;
        -- 登录成功
        Event.Brocast(
                MH.LoginInfo .. MH.SUB_GR_LOGON_SUCCESS .. gameSocketNumber.GameSocket,
                wMaiID,
                tonumber(sid),
                buffer,
                wSize
        )
    elseif sid == MH.SUB_GR_LOGON_ERROR then
        log("Lua层收到登录游戏失败")
        -- 登录失败
        Event.Brocast(
                MH.LoginInfo .. MH.SUB_GR_LOGON_ERROR .. gameSocketNumber.GameSocket,
                wMaiID,
                tonumber(sid),
                buffer,
                wSize
        )
    elseif sid == MH.SUB_GR_LOGON_FINISH then
        log("Lua层收到登录游戏完成")
        Event.Brocast(
                MH.LoginInfo .. MH.SUB_GR_LOGON_FINISH .. gameSocketNumber.GameSocket,
                wMaiID,
                tonumber(sid),
                buffer,
                wSize
        )
    end
    -- 登录完成
end

-- 桌子上的用户信息
function OnHandleInfo.UserInfoState(wMaiID, wSubID, buffer, wSize)
    -- 可以把Mid,SubID分离出来
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMaiID)) + 1, string.len(tostring(wSubID))))
    -- 解析数据
    local t = GetS2CInfo(CMD_3D_Table_UserData, buffer)
    -- 把数组赋值到具体结构中
    TableUserInfo._1dwUser_Id = t[1]
    TableUserInfo._2szNickName = t[3]
    TableUserInfo._3bySex = t[4]
    TableUserInfo._4bCustomHeader = t[5]
    TableUserInfo._5szHeaderExtensionName = t[7]
    TableUserInfo._6szSign = t[9]
    TableUserInfo._7wGold = t[10]
    error("玩家桌子的分=" .. TableUserInfo._7wGold)
    TableUserInfo._8wPrize = t[11]
    TableUserInfo._9wChairID = t[12]
    TableUserInfo._10wTableID = t[13]
    TableUserInfo._11byUserStatus = t[14]
    gameData.GetProp(TableUserInfo._7wGold, enum_Prop_I)
    --logErrorTable(t)
    --logErrorTable(TableUserInfo)
    if sid == MH.SUB_3D_TABLE_USER_ENTER then
        -- log("Lua层收到用户进入")
        -- 用户进入
        Event.Brocast(
                MH.MDM_3D_TABLE_USER_DATA .. MH.SUB_3D_TABLE_USER_ENTER .. gameSocketNumber.GameSocket,
                wMaiID,
                tonumber(sid),
                buffer,
                wSize
        )
    elseif sid == MH.SUB_3D_TABLE_USER_LEAVE then
        -- log("Lua层收到用户离开")
        -- 用户离开
        Event.Brocast(
                MH.MDM_3D_TABLE_USER_DATA .. MH.SUB_3D_TABLE_USER_LEAVE .. gameSocketNumber.GameSocket,
                wMaiID,
                tonumber(sid),
                buffer,
                wSize
        )
    elseif sid == MH.SUB_3D_TABLE_USER_STATUS then
        -- log("Lua层收到用户状态")
        -- 用户状态
        Event.Brocast(
                MH.MDM_3D_TABLE_USER_DATA .. MH.SUB_3D_TABLE_USER_STATUS .. gameSocketNumber.GameSocket,
                wMaiID,
                tonumber(sid),
                buffer,
                wSize
        )
    elseif sid == MH.SUB_3D_TABLE_USER_SCORE then
        -- log("Lua层收到用户分数")
        -- 用户分数
        Event.Brocast(
                MH.MDM_3D_TABLE_USER_DATA .. MH.SUB_3D_TABLE_USER_SCORE .. gameSocketNumber.GameSocket,
                wMaiID,
                tonumber(sid),
                buffer,
                wSize
        )
    end
    -- Event.Brocast(tostring(wSubID), wMaiID, tonumber(sid), buffer, wSize);
end

-- 场景消息
function OnHandleInfo.ScenInfo(wMaiID, wSubID, buffer, wSize)
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMaiID)) + 1, string.len(tostring(wSubID))))
    if sid == MH.SUB_GF_OPTION then
        local t = GetS2CInfo(CMD_GF_Option, buffer)
        GameOption._1GameStatus = t[1]
        GameOption._2AllowLookon = t[2]
        log("Lua层收到场景信息=" .. bAllowLookon .. "=" .. GameOption._1GameStatus)
    elseif sid == MH.SUB_GF_SCENE then
        -- 发送给具体游戏
        Event.Brocast(MH.MDM_ScenInfo .. MH.SUB_GF_SCENE .. gameSocketNumber.GameSocket, wMaiID, tonumber(sid), buffer, wSize)
        GameManager.isEnterGame = true
    elseif sid == MH.SUB_GF_MESSAGE then
        local msgtype = buffer:ReadUInt16()
        local str = buffer:ReadString(buffer:ReadUInt16())
        MessageBox.CreatGeneralTipsPanel(str)
        --   HallScenPanel.NetException(str, gameSocketNumber.GameSocket);
        log("系统消息——Sceninfo=" .. str)
    end
end

-- 聊天类
function OnHandleInfo.MDM_3D_CHAT_ROOM(wMaiID, wSubID, buffer, wSize)
    MoveNotifyInfoClass.ShowChat(buffer, wSubID, wSize)
end

-- 排行榜，活动，公告
function OnHandleInfo.MDM_3D_ASSIST(wMaiID, wSubID, buffer, wSize)
    -- 排行榜-金币
    if wSubID == MH.SUB_3D_SC_RANKTOP_GOLD_START then
        --logError("------------------------------排行榜开始")
        --RankingPanelSystem.SetRank(wSubID, buffer)
    elseif wSubID == MH.SUB_3D_SC_RANKTOP_GOLD then
        --logError("------------------------------排行榜进行")
        --RankingPanelSystem.SetRank(wSubID, buffer)
    elseif wSubID == MH.SUB_3D_SC_RANKTOP_GOLD_STOP then
        --logError("------------------------------排行榜结束")
        --RankingPanelSystem.SetRank(wSubID, buffer)
    elseif wSubID == MH.SUB_3D_CS_ACTIVITY_CORE then
        -- 活动中心-开始
    elseif wSubID == MH.SUB_3D_SC_ACTIVITY_CORE_START then
        -- 活动中心
        log("活动中心-开始")
    elseif wSubID == MH.SUB_3D_SC_ACTIVITY_CORE then
        -- 活动中心-结束
        log("接受活动中心信息")
        NoticeInfoSystem.SCNotice(wSubID, buffer, wSize)
    elseif wSubID == MH.SUB_3D_SC_ACTIVITY_CORE_STOP then
        -- 通知信息
        log("活动中心-结束")
        NoticeInfoSystem.SCEndNotice()
    elseif wSubID == MH.SUB_3D_SC_NOTIFY_INFO then
        -- 每日清理数据 应该领取的时间ID为最小的时间ID，已经在线时间为0，已经抽奖次数为0，是否完成每日对战为false
        MoveNotifyInfoClass.NotifyInfo(buffer, wSize)
    elseif wSubID == MH.SUB_3D_SC_EVERYDAY_CLEAR_DATA then
        MoveNotifyInfoClass.EveryDayClear(buffer, wSize)
    elseif wSubID == MH.SUB_3D_SC_DANCER_START then
        -- 舞者开始
        DancerInfo = {}
    elseif wSubID == MH.SUB_3D_SC_DANCER then
        -- 舞者
        HallScenPanel.SaveDanceInfo(buffer, wSize)
    elseif wSubID == MH.SUB_3D_SC_DANCER_STOP then
        -- 舞者结束
    elseif wSubID == MH.SUB_3D_SC_DANCER_REQUEST then
        -- 点舞 是否成功
        DancePanelSystem.DanceBtnOnSucess(wSubID, buffer, wSize)
    elseif wSubID == MH.SUB_3D_SC_DANCER_REQUEST_NOTITY then
        DancePanelSystem.DanceNotice(buffer, wSize)
    elseif wSubID == MH.SUB_3D_SC_RANKROOM_GOLD_SELECT_START then
        GameRoomUserList.startGetdata(buffer)
    elseif wSubID == MH.SUB_3D_SC_RANKROOM_GOLD_SELECT then
        GameRoomUserList.getDataing(buffer)
    elseif wSubID == MH.SUB_3D_SC_RANKROOM_GOLD_SELECT_STOP then
        GameRoomUserList.endData(buffer)
    elseif wSubID == MH.SUB_3D_SC_RANKWIN_YESTERDAY_START then
        --RankingPanelSystem.SetyesterdayRank(wSubID, buffer)
        -- 昨日盈利-开始
        log("-- 昨日盈利-开始")
    elseif wSubID == MH.SUB_3D_SC_RANKWIN_YESTERDAY then
        --RankingPanelSystem.SetyesterdayRank(wSubID, buffer)
        -- 昨日盈利
        log("-- 昨日盈利")
    elseif wSubID == MH.SUB_3D_SC_RANKWIN_YESTERDAY_STOP then
        --RankingPanelSystem.SetyesterdayRank(wSubID, buffer)
        -- 昨日盈利-结束
        log("-- 昨日盈利结束")
    elseif wSubID == MH.SUB_3D_SC_ACTIVITY_MAIL_START then
        -- 活动邮件-开始
        EmailInfoSystem.SCStartNotice()
    elseif wSubID == MH.SUB_3D_SC_ACTIVITY_MAIL then
        -- 活动邮件
        EmailInfoSystem.SCNotice(wSubID, buffer, wSize)
    elseif wSubID == MH.SUB_3D_SC_ACTIVITY_MAIL_STOP then
        -- 活动邮件-结束
        EmailInfoSystem.SCEndNotice()
    elseif wSubID == MH.SUB_3D_SC_ACTIVITY_MAIL_GET then
        EmailInfoSystem.SCGetBtnOnClick(buffer, wSize)
    elseif wSubID == MH.SUB_3D_SC_ROOM_DATA_SELECT_START then
        -- 房间数据-开始
        GameRoomList.startGetRoomData(wSubID, buffer, wSize)
    elseif wSubID == MH.SUB_3D_SC_ROOM_DATA_SELECT then
        -- 房间数据
        logYellow("00000")
        GameRoomList.getIngRoomData(wSubID, buffer, wSize)
    elseif wSubID == MH.SUB_3D_SC_ROOM_DATA_SELECT_STOP then
        -- 房间数据-结束
        GameRoomList.endGetRoomData(wSubID, buffer, wSize)
    elseif wSubID == MH.SUB_3D_SC_LOOK_ACTIVITY_CORE then
        -- //看过公告 没有数据 可以不处理
        if wSize == 0 then
            SCPlayerInfo._30LookNotice = 1
        else
            SCPlayerInfo._30LookNotice = 0
        end
    elseif wSubID == MH.SUB_3D_SC_LOOK_ACTIVITY_MAIL then
        -- //看过邮件 没有数据 可以不处理
        if wSize == 0 then
            SCPlayerInfo._31LookEmail = 1
        else
            SCPlayerInfo._31LookEmail = 0
        end
    elseif wSubID == MH.SUB_3D_SC_NEW_ACTIVITY_MAIL then
        -- 新邮件通知
        log("--新邮件通知")
        SCPlayerInfo._32NewEmail = 1
        HallScenPanel.EmialSetTishi:SetActive(true)
        HallScenPanel.EmialSetTishi_New:SetActive(true)
        if EmailInfoSystem.EmailPanel ~= nil then
            EmailInfoSystem.SendNotice()
        end
    elseif wSubID == MH.SUB_3D_SC_CHECK_CLIENT_NETWORK then
        -- 检测客户端网络
        HallScenPanel.SCCheckClinet()
    end
end
SC_TanrsfromGold = {
    [1] = DataSize.String100
}

SC_GiveGoldRecoder = {
    [1] = DataSize.Int32, --// 礼物唯一索引UINT32
    [2] = DataSize.Int32, --// 发送者ID
    [3] = DataSize.Int32, --// 接收者ID
    [4] = DataSize.Int32, --// 道具idUINT32
    [5] = DataSize.UInt64, --// 道具个数UINT32
    [6] = DataSize.Int32, --// 赠送时间UINT32
    [7] = DataSize.Int32, --// 是否已领UINT32
    [8] = DataSize.String32, --发送者昵称
    [9] = DataSize.String32 --接收则昵称
}
-- 聚宝盆
function OnHandleInfo.MDM_3D_GOLDMINET(wMaiID, wSubID, buffer, wSize)
    if wSubID == 0 then
        -- 金币对奖券
        CornucopiaSystem.GetGoldSuccess(wSubID, buffer, wSize)
    elseif wSubID == MH.SUB_3D_SC_TRANSFERACCOUNTS then
        -- 赠送金币
        if wSize == 0 then
            GiveRedBag.GiveGoldSuccess(wSubID, buffer, wSize)
        else
            if wSize == 100 then
                MessageBox.CreatGeneralTipsPanel("网络错误，请重新操作");
            else
                local num = buffer:ReadUInt16()
                local mes = buffer:ReadString(num)
                GiveRedBag.GiveGoldFill()
                MessageBox.CreatGeneralTipsPanel(mes)
            end
        end
    elseif wSubID == 2 then
        local isshow = buffer:ReadByte()
        RedBagPanel.setState(isshow)
    elseif wSubID == MH.SUB_3D_SC_WITHDRAW then
        local recallResult = buffer:ReadByte();
        local recallGold = buffer:ReadInt64Str();
        log("recallGold:" .. recallGold);
        local recallUserID = buffer:ReadInt32();
        local recallMsg = buffer:ReadString(100);
        recallMsg = string.gsub(recallMsg, " ", "");
        if recallResult == 1 then
            local currentgold = gameData.GetProp(enum_Prop_Id.E_PROP_STRONG);
            if recallUserID == tonumber(SCPlayerInfo._01dwUser_Id) then
                gameData.ChangProp(currentgold - recallGold, enum_Prop_Id.E_PROP_STRONG)
            else
                gameData.ChangProp(currentgold + recallGold, enum_Prop_Id.E_PROP_STRONG)
            end
            Event.Brocast(PanelListModeEven._015ChangeGoldTicket)
        end
        MessageBox.CreatGeneralTipsPanel(recallMsg);
    end
    if wSubID == MH.SUB_2D_SC_GIVE_RECORD_LIST then
        log("recvieSize:" .. wSize)
        local length = buffer:ReadInt32()
        if length <= 0 then
            log("没有赠送记录")
            return
        end
        local isInit = false
        local isSendReadPacket = false
        --1 转出  0转入
        --2 谁送的UINT32  3 送给谁UINT32
        for i = 1, length do
            SC_GiveGoldRecoder = {
                [1] = buffer:ReadInt32(), --// 礼物唯一索引UINT32
                [2] = buffer:ReadInt32(), --// 发送者ID
                [3] = buffer:ReadInt32(), --// 接收者ID
                [4] = buffer:ReadInt32(), --// 道具idUINT32
                [5] = buffer:ReadInt64Str(), --// 道具个数UINT32
                [6] = buffer:ReadInt32(), --// 赠送时间UINT32
                [7] = buffer:ReadInt32(), --// 是否已领UINT32
                [8] = buffer:ReadString(), --发送者昵称
                [9] = buffer:ReadString() --接收则昵称
            }
            log("================记录")
            logTable(SC_GiveGoldRecoder)
            local ma = SC_GiveGoldRecoder
            if (isInit == false) then
                if (ma[3] == SCPlayerInfo._beautiful_Id) then
                    GiveAndSendMoneyRecordPanle.startRecord(1)
                    isSendReadPacket = true
                else
                    GiveAndSendMoneyRecordPanle.startRecord(0)
                    isSendReadPacket = false
                end
                isInit = true
            end
            if (ma[2] == SCPlayerInfo._beautiful_Id) then
                GiveAndSendMoneyRecordPanle.record(ma, 1)
            else
                ma[3] = ma[2]
                GiveAndSendMoneyRecordPanle.record(ma, 0)
            end
        end
        log("送礼记录返回,共：" .. length .. "条记录" .. wSize)
        if (isSendReadPacket == true) then
            GiveAndSendMoneyRecordPanle.endRecord(1)
        else
            GiveAndSendMoneyRecordPanle.endRecord(0)
        end
    end

    if wSubID == MH.SUB_3D_SC_PRESENT_GOLD_RECORD_START then
        --GiveAndSendMoneyRecordPanle.startRecord(buffer, wSize);
    end

    if wSubID == MH.SUB_3D_SC_PRESENT_GOLD_RECORD then
        --GiveAndSendMoneyRecordPanle.record(buffer, wSize);
    end

    if wSubID == MH.SUB_3D_SC_UPDATEBANKERSAVEGOLD then
        log("================================刷新银行存款记录=======================================")
        local gold = buffer:ReadInt64Str()
        local localGold = 0;
        -- if (SCPlayerInfo.IsVIP ~= 1) then
        --     -- if LaunchModule.currentSceneName == "module02" then
        --     --     --BankPanel.QCBankZSGold(gold)
        --     -- else
        --     --     local pop = FramePopoutCompent.Pop.New();
        --     --     pop._02conten = "您当前收到转账" .. gold .. "金币，请到大厅查询！";
        --     --     pop._99last = true
        --     --     pop.isBig = true;
        --     --     FramePopoutCompent.Add(pop)
        --     -- end
        -- else
            localGold = gameData.GetProp(enum_Prop_Id.E_PROP_STRONG) + gold
            gameData.ChangProp(localGold, enum_Prop_Id.E_PROP_STRONG)
        -- end

        Event.Brocast(PanelListModeEven._015ChangeGoldTicket)
    end
    if wSubID == MH.SUB_3D_SC_PRESENT_GOLD_GET then
        GiveAndSendMoneyRecordPanle.getGoldRes(buffer, wSize)
    end
end
-- 充值
function OnHandleInfo.MDM_3D_RECHARGE(wMaiID, wSubID, buffer, wSize)
    if wSubID == 0 then
        -- 充值开始
        RechargeInfoSystem.SetInfo(wSubID, buffer)
    elseif wSubID == 1 then
        -- 充值列表
        RechargeInfoSystem.SetInfo(wSubID, buffer)
    elseif wSubID == 2 then
        -- 充值结束
        RechargeInfoSystem.SetInfo(wSubID, buffer)
    elseif wSubID == 3 then
    elseif wSubID == 4 then
        RechargeInfoSystem.ServerBuyOk(wSubID, buffer, wSize)
    end
end

-- 新框架消息
function OnHandleInfo.FrameInfo(wMaiID, wSubID, buffer, wSize)
    -- 可以把Mid,SubID分离出来
    local sid = tonumber(string.sub(wSubID, string.len(tostring(wMaiID)) + 1, string.len(tostring(wSubID))))
    -- 表情
    if sid == MH.SUB_3D_SC_SEND_SIGN then
        -- 动作
        Event.Brocast(
                MH.MDM_3D_FRAME .. MH.SUB_3D_SC_SEND_SIGN .. gameSocketNumber.GameSocket,
                wMaiID,
                tonumber(sid),
                buffer,
                wSize
        )
    elseif sid == MH.SUB_3D_SC_SEND_ACTION then
        -- 入座
        Event.Brocast(
                MH.MDM_3D_FRAME .. MH.SUB_3D_SC_SEND_SIGN .. gameSocketNumber.GameSocket,
                wMaiID,
                tonumber(sid),
                buffer,
                wSize
        )
    elseif sid == MH.SUB_3D_SC_AUTO_SIT then
        Event.Brocast(
                MH.MDM_3D_FRAME .. MH.SUB_3D_SC_AUTO_SIT .. gameSocketNumber.GameSocket,
                wMaiID,
                tonumber(sid),
                buffer,
                wSize
        )
    elseif sid == MH.SUB_3D_SC_SWITCH_TABLE then
        -- 换桌
        Event.Brocast(
                MH.MDM_3D_FRAME .. MH.SUB_3D_SC_SWITCH_TABLE .. gameSocketNumber.GameSocket,
                wMaiID,
                tonumber(sid),
                buffer,
                wSize
        )
    elseif sid == MH.SUB_3D_SC_ROOM_INFO_OFFLINE then
        -- 断线消息
        Event.Brocast(
                MH.MDM_3D_FRAME .. MH.SUB_3D_SC_ROOM_INFO_OFFLINE .. gameSocketNumber.GameSocket,
                wMaiID,
                tonumber(sid),
                buffer,
                wSize
        )
    end
    Event.Brocast(MH.MDM_3D_FRAME .. gameSocketNumber.HallSocket, wMaiID, tonumber(sid), buffer, wSize)
end

-- 商城
function OnHandleInfo.MallInfo(wMaiID, wSubID, buffer, wSize)
    MallInfoSystem.MallInfo(wSubID, buffer, wSize)
end

--银行
function OnHandleInfo.BankInfo(wMaiID, wSubID, buffer, wSize)
    logError("接收银行操作")
    if wSubID == MH.SUB_GP_BANKOPENACCOUNTRESULT then
        logError("接收银行操作128===" .. wSize)
        local data = {}
        data[1] = buffer:ReadInt32()
        data[2] = buffer:ReadInt64Str()
        data[3] = buffer:ReadInt64Str()
        logErrorTable(data)
        gameData.ChangProp(data[2], enum_Prop_Id.E_PROP_GOLD)
        gameData.ChangProp(data[3], enum_Prop_Id.E_PROP_STRONG)
        if HallScenPanel.isOpenBank then
            Event.Brocast(PanelListModeEven._004bankPanel, data)
        end
        Event.Brocast(PanelListModeEven._015ChangeGoldTicket)
    elseif wSubID == MH.SUB_GP_SETBANKPASSRESULT then
        log("==================================初始银行信息130=========================================" .. wSize)
        local data = {}
        data[1] = tonumber(buffer:ReadInt64Str())
        data[2] = tonumber(buffer:ReadInt64Str())
        data[3] = tonumber(buffer:ReadInt64Str())
        data[4] = buffer:ReadString(1024)

        --logError(data[2])
        --logError(data[3])
        --


        Event.Brocast(PanelListModeEven._015ChangeGoldTicket)
        BankPanel.SetPwdBtnCallBack(data)
    elseif wSubID == MH.SUB_GP_USER_BANK_OPERATE_RESULT then
        logError("接收银行操作存取款消息返回情况")
        -- 存取反馈
        local data = {}

        data.szInsureScore = buffer:ReadInt64Str() -- 玩家保险箱金币
        data.cbSuccess = buffer:ReadByte() -- 成功标识  0 成功   1：失败
        data.cbDrawOut = buffer:ReadByte() -- 存取标识
        data.szInfoDiscrib = buffer:ReadString(128) -- 描述信息
        logErrorTable(data)
        if data.cbDrawOut == 0 then
            BankPanel.SaveGoldBtnCallBack(data, data.cbSuccess)
        elseif data.cbDrawOut == 1 then
            BankPanel.GetGoldBtnCallBack(data, data.cbSuccess)
        end
        Event.Brocast(PanelListModeEven._015ChangeGoldTicket)
    elseif wSubID == MH.SUB_GP_MODIFY_BANK_PASSWD_CHECK_CODE_RESULT then
        --changePassWordPanel.UpdatePwdSuccess(buffer, wSize)
        BankPanel.UpdatePwdSuccess(buffer, wSize)
    end
end

-- 接受游戏消息注册
function OnHandleInfo.Registered(method)
end
