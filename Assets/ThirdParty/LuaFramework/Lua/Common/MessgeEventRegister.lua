--require 'Module02.LoadDefine'


MessgeEventRegister = { };
local self = MessgeEventRegister;

function MessgeEventRegister.New()

end

-- 游戏事件回掉函数列表
EventCallBackTable =
{
    _01_GameInfo = nil;
    _02_ScenInfo = nil;
    _03_LogonSuccess = nil;
    _04_LogonOver = nil;
    _05_LogonFailed = nil;
    _06_Biao_Action = nil;
    _07_UserEnter = nil;
    _08_UserLeave = nil;
    _09_UserStatus = nil;
    _10_UserScore = nil;
    _11_GameQuit = nil;
    _12_OnSit = nil;
    _13_ChangeTable = nil;
    _14_RoomBreakLine = nil;
    _15_OnBackGame = nil;
    _16_OnHelp=nil;
    _17_OnStopGame=nil;
    _18_OnHandleMessage=nil;
    _19_NetException=nil;
}


-- 大厅各个模块事件回掉函数列表
EventCallBackHallModeTable =
{
    -- 大厅
    _001hallPanel = HallScenPanel.Open,
    -- 排行榜
    _002rankPanel = RankingPanelSystem.Open,
    -- 充值
    _003rechargePanel = RechargeInfoSystem.Open,
    -- 银行
    _004bankPanel = BankPanel.Open,
    -- 个人信息
    _005personalPanel = PersonalInfoSystem.Open,
    -- 免费金币
    _006freeGoldPanel = nil,
    -- 红包
    _007redPackagePanel = GiveRedBag.Open,
    -- 兑换
    _008exchangePanel = MallInfoSystem.Open,
    -- 赠送币
    _009cornucopiaPanel=CornucopiaSystem.Open,
    -- 活动
    _010noticeInfoPanel=NoticeInfoSystem.Open,
    --帮助
    _011helpInfoPanel=HelpInfoSystem.Open,
    --设置
    _012setInfoPanel=SetInfoSystem.Open,
    --分享
    _013sharePanel=SetInfoSystem.ShareOpen,
    --房间选择
    _014gameRoomListPanel=GameRoomList.Open,
    --金币变动
    _015ChangeGoldTicket=nil,
    --关闭相册遮罩
    _016ClosePohtoZheZ=PersonalInfoSystem.HomeBack,
    --系统邮件
    _017emailPanel=EmailInfoSystem.Open,
    --网络异常处理
    _018NetException=HallScenPanel.NetException,
    --框架弹窗
    _019FramePopout=FramePopoutCompent.Open;
}

-- 绑定消息接受事件
function MessgeEventRegister.Hall_Messge_Reg()
    --- 事件KEY  （主命令+子命令+线程ID）防止key重复
    --新版聊天
    Event.AddListener(MH.Chat_MDM_player..gameSocketNumber.ChatSocket, ChatPanel.RecvInfo);

    Event.AddListener(MH.MDM_3D_LOGIN .. gameSocketNumber.HallSocket, OnHandleInfo.LoginInfo);
    -- 登录大厅
    Event.AddListener(MH.LoginInfo .. gameSocketNumber.HallSocket, OnHandleInfo.HallLoginInfo);
    -- 登录游戏
    Event.AddListener(MH.LoginInfo .. gameSocketNumber.GameSocket, OnHandleInfo.GameLoginInfo);
    -- 桌子信息
    Event.AddListener(MH.MDM_3D_TABLE_USER_DATA .. gameSocketNumber.GameSocket, OnHandleInfo.UserInfoState);
    -- 场景消息
    Event.AddListener(MH.MDM_ScenInfo .. gameSocketNumber.GameSocket, OnHandleInfo.ScenInfo);
    -- 框架消息
    Event.AddListener(MH.MDM_3D_FRAME .. gameSocketNumber.GameSocket, OnHandleInfo.FrameInfo);
    -- 大厅个人信息
    --Event.AddListener(MH.MDM_3D_PERSONAL_INFO .. gameSocketNumber.HallSocket, OnHandleInfo.PersonalInfo);
    -- 排行榜，活动，公告
    --Event.AddListener(MH.MDM_3D_ASSIST .. gameSocketNumber.HallSocket, OnHandleInfo.MDM_3D_ASSIST);
    -- 聚宝盆
    --Event.AddListener(MH.MDM_3D_GOLDMINET .. gameSocketNumber.HallSocket, OnHandleInfo.MDM_3D_GOLDMINET);
    -- 大厅聊天类
    Event.AddListener(MH.MDM_3D_CHAT_ROOM .. gameSocketNumber.HallSocket, OnHandleInfo.MDM_3D_CHAT_ROOM);
    -- 免费金币
    Event.AddListener(MH.MDM_3D_TASK .. gameSocketNumber.HallSocket, OnHandleInfo.FreeGoldInfo);
    -- 充值
    Event.AddListener(MH.MDM_3D_RECHARGE .. gameSocketNumber.HallSocket, OnHandleInfo.MDM_3D_RECHARGE);
    -- 商城
    Event.AddListener(MH.MDM_3D_SHOP .. gameSocketNumber.HallSocket, OnHandleInfo.MallInfo);
	--银行
	Event.AddListener(MH.MDM_GP_USER .. gameSocketNumber.HallSocket, OnHandleInfo.BankInfo);
    --心跳
    Event.AddListener(MH.MDM_3D_HEARTCOFIG .. gameSocketNumber.HallSocket, OnHandleInfo.HeartInfo);
	
	
    -- 换桌
    --Event.AddListener(MH.MDM_3D_FRAME .. gameSocketNumber.HallSocket, GameSetsBtnInfo.ChangeTableMessage);

    -- ==注册各个模块调用事件
    Event.AddListener(PanelListModeEven._001hallPanel, EventCallBackHallModeTable._001hallPanel);
    Event.AddListener(PanelListModeEven._002rankPanel, EventCallBackHallModeTable._002rankPanel);
    Event.AddListener(PanelListModeEven._003rechargePanel, EventCallBackHallModeTable._003rechargePanel);
    Event.AddListener(PanelListModeEven._004bankPanel, EventCallBackHallModeTable._004bankPanel);
    Event.AddListener(PanelListModeEven._005personalPanel, EventCallBackHallModeTable._005personalPanel);
    Event.AddListener(PanelListModeEven._006freeGoldPanel, EventCallBackHallModeTable._006freeGoldPanel);
    Event.AddListener(PanelListModeEven._007redPackagePanel, EventCallBackHallModeTable._007redPackagePanel);
    Event.AddListener(PanelListModeEven._008exchangePanel, EventCallBackHallModeTable._008exchangePanel);
    Event.AddListener(PanelListModeEven._009cornucopiaPanel, EventCallBackHallModeTable._009cornucopiaPanel);
    Event.AddListener(PanelListModeEven._010noticeInfoPanel, EventCallBackHallModeTable._010noticeInfoPanel);
    Event.AddListener(PanelListModeEven._011helpInfoPanel, EventCallBackHallModeTable._011helpInfoPanel);
    Event.AddListener(PanelListModeEven._012setInfoPanel , EventCallBackHallModeTable._012setInfoPanel);
    Event.AddListener(PanelListModeEven._013sharePanel, EventCallBackHallModeTable._013sharePanel);
    Event.AddListener(PanelListModeEven._014gameRoomListPanel, EventCallBackHallModeTable._014gameRoomListPanel);
    Event.AddListener(PanelListModeEven._015ChangeGoldTicket, EventCallBackHallModeTable._015ChangeGoldTicket);
    Event.AddListener(PanelListModeEven._016ClosePohtoZheZ, EventCallBackHallModeTable._016ClosePohtoZheZ);
    Event.AddListener(PanelListModeEven._017emailPanel, EventCallBackHallModeTable._017emailPanel);
    Event.AddListener(PanelListModeEven._018NetException, EventCallBackHallModeTable._018NetException);
    Event.AddListener(PanelListModeEven._019FramePopout, EventCallBackHallModeTable._019FramePopout);
end

-- 卸载大厅的消息接受事件
function MessgeEventRegister.Hall_Messge_Un()
    Event.RemoveListener(MH.Chat_MDM_player..gameSocketNumber.ChatSocket);
    Event.RemoveListener(MH.MDM_3D_LOGIN .. gameSocketNumber.HallSocket);
    Event.RemoveListener(MH.LoginInfo .. gameSocketNumber.HallSocket);
    Event.RemoveListener(MH.LoginInfo .. gameSocketNumber.GameSocket);
    Event.RemoveListener(MH.MDM_3D_TABLE_USER_DATA .. gameSocketNumber.GameSocket);
    Event.RemoveListener(MH.MDM_ScenInfo .. gameSocketNumber.GameSocket);
    Event.RemoveListener(MH.MDM_3D_PERSONAL_INFO .. gameSocketNumber.HallSocket);
    Event.RemoveListener(MH.MDM_3D_TASK .. gameSocketNumber.HallSocket);
    Event.RemoveListener(MH.MDM_3D_GOLDMINET .. gameSocketNumber.HallSocket);
    Event.RemoveListener(MH.MDM_3D_ASSIST .. gameSocketNumber.HallSocket);
    Event.RemoveListener(MH.MDM_3D_CHAT_ROOM .. gameSocketNumber.HallSocket);
    Event.RemoveListener(MH.MDM_3D_FRAME .. gameSocketNumber.HallSocket);
    Event.RemoveListener(MH.MDM_3D_RECHARGE .. gameSocketNumber.HallSocket)
    Event.RemoveListener(MH.MDM_3D_SHOP .. gameSocketNumber.HallSocket)
    Event.RemoveListener(MH.MDM_3D_FRAME .. gameSocketNumber.HallSocket);
    Event.RemoveListener(MH.MDM_3D_HEARTCOFIG .. gameSocketNumber.HallSocket);

    -- 模块事件
    Event.RemoveListener(PanelListModeEven._001hallPanel);
    Event.RemoveListener(PanelListModeEven._002rankPanel);
    Event.RemoveListener(PanelListModeEven._003rechargePanel);
    Event.RemoveListener(PanelListModeEven._004bankPanel);
    Event.RemoveListener(PanelListModeEven._005personalPanel);
    Event.RemoveListener(PanelListModeEven._006freeGoldPanel);
    Event.RemoveListener(PanelListModeEven._007redPackagePanel);
    Event.RemoveListener(PanelListModeEven._008exchangePanel);
    Event.RemoveListener(PanelListModeEven._009cornucopiaPanel);
    Event.RemoveListener(PanelListModeEven._010noticeInfoPanel);
    Event.RemoveListener(PanelListModeEven._011helpInfoPanel);
    Event.RemoveListener(PanelListModeEven._012setInfoPanel);
    Event.RemoveListener(PanelListModeEven._013sharePanel);
    Event.RemoveListener(PanelListModeEven._014gameRoomListPanel);
    Event.RemoveListener(PanelListModeEven._015ChangeGoldTicket);
    Event.RemoveListener(PanelListModeEven._016ClosePohtoZheZ);
    Event.RemoveListener(PanelListModeEven._017emailPanel);
    Event.RemoveListener(PanelListModeEven._018NetException);
    Event.RemoveListener(PanelListModeEven._019FramePopout);
    
    EventCallBackHallModeTable._001hallPanel=nil;
    EventCallBackHallModeTable._002rankPanel=nil;
    EventCallBackHallModeTable._003rechargePanel=nil;
    EventCallBackHallModeTable._004bankPanel=nil;
    EventCallBackHallModeTable._005personalPanel=nil;
    EventCallBackHallModeTable._006freeGoldPanel=nil;
    EventCallBackHallModeTable._007redPackagePanel=nil;
    EventCallBackHallModeTable._008exchangePanel=nil;
    EventCallBackHallModeTable.__009cornucopiaPanel=nil;
    EventCallBackHallModeTable._010noticeInfoPanel=nil;
    EventCallBackHallModeTable._011helpInfoPanel=nil;
    EventCallBackHallModeTable._012setInfoPanel=nil;
    EventCallBackHallModeTable._013sharePanel=nil;
    EventCallBackHallModeTable._014gameRoomListPanel=nil;
    EventCallBackHallModeTable._015ChangeGoldTicket=nil;
    EventCallBackHallModeTable._016ClosePohtoZheZ=nil;
    EventCallBackHallModeTable._017emailPanel=nil;
    EventCallBackHallModeTable._018NetException=nil;
    EventCallBackHallModeTable._019FramePopout=nil;
end


-- 注册游戏的消息接受事件
function MessgeEventRegister.Game_Messge_Reg(t)

    log("===========统一注册============")
    if t == nil then error("游戏事件回掉注册失败") return end
    -- 游戏消息
    Event.AddListener(MH.MDM_GF_GAME .. gameSocketNumber.GameSocket, t._01_GameInfo);
    -- 场景消息
    Event.AddListener(MH.MDM_ScenInfo .. MH.SUB_GF_SCENE .. gameSocketNumber.GameSocket, t._02_ScenInfo);
    -- 登录成功
    Event.AddListener(MH.LoginInfo .. MH.SUB_GR_LOGON_SUCCESS .. gameSocketNumber.GameSocket, t._03_LogonSuccess);
    -- 登录完成
    Event.AddListener(MH.LoginInfo .. MH.SUB_GR_LOGON_FINISH .. gameSocketNumber.GameSocket, t._04_LogonOver);
    -- 登录失败
    Event.AddListener(MH.LoginInfo .. MH.SUB_GR_LOGON_ERROR .. gameSocketNumber.GameSocket, t._05_LogonFailed);
    -- 表情，动作
    Event.AddListener(MH.MDM_3D_FRAME .. MH.SUB_3D_SC_SEND_SIGN .. gameSocketNumber.GameSocket, t._06_Biao_Action);
    -- 用户进入
    Event.AddListener(MH.MDM_3D_TABLE_USER_DATA .. MH.SUB_3D_TABLE_USER_ENTER .. gameSocketNumber.GameSocket, t._07_UserEnter);
    -- 用户离开
    Event.AddListener(MH.MDM_3D_TABLE_USER_DATA .. MH.SUB_3D_TABLE_USER_LEAVE .. gameSocketNumber.GameSocket, t._08_UserLeave);
    -- 用户状态
    Event.AddListener(MH.MDM_3D_TABLE_USER_DATA .. MH.SUB_3D_TABLE_USER_STATUS .. gameSocketNumber.GameSocket, t._09_UserStatus);
    -- 用户分数
    Event.AddListener(MH.MDM_3D_TABLE_USER_DATA .. MH.SUB_3D_TABLE_USER_SCORE .. gameSocketNumber.GameSocket, t._10_UserScore);
    -- 游戏退出
    Event.AddListener(MH.Game_LEAVE, t._11_GameQuit);
    -- 用户入座
    Event.AddListener(MH.MDM_3D_FRAME .. MH.SUB_3D_SC_AUTO_SIT .. gameSocketNumber.GameSocket, t._12_OnSit);
    -- 换桌消息
    Event.AddListener(MH.MDM_3D_FRAME .. MH.SUB_3D_SC_SWITCH_TABLE .. gameSocketNumber.GameSocket, t._13_ChangeTable);
    -- 断线消息
    Event.AddListener(MH.MDM_3D_FRAME .. MH.SUB_3D_SC_ROOM_INFO_OFFLINE .. gameSocketNumber.GameSocket, t._14_RoomBreakLine);
    -- home键的返回回掉,后面加上的方法，判断一下主要是为了兼容之前的游戏
    Event.AddListener(EventIndex.OnBackGame .. gameSocketNumber.GameSocket, t._15_OnBackGame);
    Event.AddListener(EventIndex.OnStopGame .. gameSocketNumber.GameSocket, t._17_OnStopGame);
    -- 游戏帮助
    Event.AddListener(EventIndex.OnHelp .. gameSocketNumber.GameSocket, t._16_OnHelp);
    --框架弹窗消息处理    
    Event.AddListener(EventIndex.OnHandleMessage .. gameSocketNumber.GameSocket, t._18_OnHandleMessage);
    --网络异常处理
    Event.AddListener(EventIndex.OnNetException .. gameSocketNumber.GameSocket, t._19_NetException);

end



-- 卸载游戏的消息接受事件
function MessgeEventRegister.Game_Messge_Un()
    Event.RemoveListener(MH.MDM_GF_GAME .. gameSocketNumber.GameSocket);
    Event.RemoveListener(MH.MDM_ScenInfo .. MH.SUB_GF_SCENE .. gameSocketNumber.GameSocket);
    Event.RemoveListener(MH.LoginInfo .. MH.SUB_GR_LOGON_SUCCESS .. gameSocketNumber.GameSocket);
    Event.RemoveListener(MH.LoginInfo .. MH.SUB_GR_LOGON_FINISH .. gameSocketNumber.GameSocket);
    Event.RemoveListener(MH.LoginInfo .. MH.SUB_GR_LOGON_ERROR .. gameSocketNumber.GameSocket);
    Event.RemoveListener(MH.MDM_3D_FRAME .. MH.SUB_3D_SC_SEND_SIGN .. gameSocketNumber.GameSocket);
    Event.RemoveListener(MH.MDM_3D_TABLE_USER_DATA .. MH.SUB_3D_TABLE_USER_ENTER .. gameSocketNumber.GameSocket);
    Event.RemoveListener(MH.MDM_3D_TABLE_USER_DATA .. MH.SUB_3D_TABLE_USER_LEAVE .. gameSocketNumber.GameSocket);
    Event.RemoveListener(MH.MDM_3D_TABLE_USER_DATA .. MH.SUB_3D_TABLE_USER_STATUS .. gameSocketNumber.GameSocket);
    Event.RemoveListener(MH.MDM_3D_TABLE_USER_DATA .. MH.SUB_3D_TABLE_USER_SCORE .. gameSocketNumber.GameSocket);
    Event.RemoveListener(MH.Game_LEAVE);
    Event.RemoveListener(MH.MDM_3D_FRAME .. MH.SUB_3D_SC_AUTO_SIT .. gameSocketNumber.GameSocket);
    Event.RemoveListener(MH.MDM_3D_FRAME .. MH.SUB_3D_SC_SWITCH_TABLE .. gameSocketNumber.GameSocket);
    Event.RemoveListener(MH.MDM_3D_FRAME .. MH.SUB_3D_SC_ROOM_INFO_OFFLINE .. gameSocketNumber.GameSocket);
    Event.RemoveListener(EventIndex.OnBackGame .. gameSocketNumber.GameSocket);
    Event.RemoveListener(EventIndex.OnStopGame .. gameSocketNumber.GameSocket);
    Event.RemoveListener(EventIndex.OnHelp .. gameSocketNumber.GameSocket);   
    Event.RemoveListener(EventIndex.OnHandleMessage .. gameSocketNumber.GameSocket);
    Event.RemoveListener(EventIndex.OnNetException .. gameSocketNumber.GameSocket);
    EventCallBackTable._01_GameInfo=nil;
    EventCallBackTable._02_ScenInfo=nil;
    EventCallBackTable._03_LogonSuccess=nil;
    EventCallBackTable._04_LogonOver=nil;
    EventCallBackTable._05_LogonFailed=nil;
    EventCallBackTable._06_Biao_Action=nil;
    EventCallBackTable._07_UserEnter=nil;
    EventCallBackTable._08_UserLeave=nil;
    EventCallBackTable._09_UserStatus=nil;
    EventCallBackTable._10_UserScore=nil;
    EventCallBackTable._11_GameQuit=nil;
    EventCallBackTable._12_OnSit=nil;
    EventCallBackTable._13_ChangeTable=nil;
    EventCallBackTable._14_RoomBreakLine=nil;
    EventCallBackTable._15_OnBackGame=nil;
    EventCallBackTable._16_OnHelp=nil;      
    EventCallBackTable._17_OnStopGame=nil;
    EventCallBackTable._18_OnHandleMessage=nil;
    EventCallBackTable._19_NetException=nil;
end


