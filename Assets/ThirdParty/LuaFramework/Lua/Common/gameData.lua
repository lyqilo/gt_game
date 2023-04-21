gameData = { };
this = gameData;

ServerList = {
    HallServer = "HallScenServer",
    Game001Server = "FishiServer",
}

function gameData.SetServerInfo(ScenName, gameName, ip, port)
    self.ScenName = { gameName, ip, port };
end

function gameData.GetServerInfo(ScenName)
    return self.ScenName;
end


function gameData.GetProp(prop_id)
    P = 0;
    for i = 1, #(AllSCUserProp) do
        if (AllSCUserProp[i][1] == SCPlayerInfo._01dwUser_Id) then
            if (prop_id == enum_Prop_Id.E_PROP_GOLD) then
                logYellow("返回金币数据：" .. AllSCUserProp[i][7])
                return AllSCUserProp[i][7]
            end
            if (prop_id == enum_Prop_Id.E_PROP_STRONG) then
                logYellow("返回银行数据：" .. AllSCUserProp[i][4])
                return tostring(AllSCUserProp[i][4]);
            end
        end
    end
    return P;
end

function gameData.ChangProp(args, prop_id)
    for i = 1, #(AllSCUserProp) do
        if (AllSCUserProp[i][1] == SCPlayerInfo._01dwUser_Id) then
            if (prop_id == enum_Prop_Id.E_PROP_GOLD) then
                logYellow("刷新身上携带的金币：" .. args);
                AllSCUserProp[i][7] = args;
            end
            if prop_id == enum_Prop_Id.E_PROP_STRONG then
                AllSCUserProp[i][4] = args;
                logYellow("刷新银行的金币：" .. args);
            end
            Event.Brocast(PanelListModeEven._015ChangeGoldTicket)
        end
    end
end



-- 保存游戏中每个桌子上的用户信息
TableUserInfo = {
    _1dwUser_Id = 0,
    _2szNickName = "",
    _3bySex = 0,
    _4bCustomHeader = 0,
    _5szHeaderExtensionName = "",
    _6szSign = "",
    _7wGold = 0,
    _8wPrize = 0,
    _9wChairID = 0,
    _10wTableID = 0,
    _11byUserStatus = 0,
};

--游戏配置信息
GameOption = {
    _1GameStatus = 0;
    _2AllowLookon = 0;
}

--- 保存登录大厅时服务器返回的系统信息
-- AllSystemInfo={};

SCSystemInfo = {
    -- Web服务器地址
    _1wWebServerAddressData = "",
    _2wWebServerAddress = "",
    -- 头像文件夹
    _3wHeaderDirData = "",
    _4wHeaderDir = "",
    -- 头像上传页面
    _5wHeaderUpLoadPageData = "",
    _6wHeaderUpLoadPage = "",
    -- 修改昵称金币
    -- _7dwChangeAccountPrizeGold="",
    -- 赠送最低金币
    _7dwPresentMinGold = 0,
    -- 快速开始游戏 wFastStartGameId
    _8wFastStartGameId = "",
    -- 修改昵称性别需要的金币
    _9dwChangeNickNameOrSexNeedGold = 0,
    -- 每日抽奖最大次数
    _10wEverydayLotteryMaxCount = 0,
    -- 首充赠送比例
    _11wFirstRechargePresentRate = 0,
    -- 首次修改昵称或者性别奖励金币
    _12dwFirstChangeNickNameOrSexPrizeGold = 0,
    --开服赠送比例
    _13wStartRechargePresentRate = 0,
}
NewHand = {
    buyu_IsNewHand = 0,
}
-- 玩家个人信息
SCPlayerInfo = {
    -- 用户ID
    _beautiful_Id = "",

    _01dwUser_Id = "",

    -- 性别
    _02bySex = "",
    -- 是否自定义头像
    _03bCustomHeader = "",
    -- 帐号
    _04wAccount = "",
    -- 呢称
    _05wNickName = "",
    -- 密码
    _06wPassword = "",
    -- 头像扩展名
    _07wHeaderExtensionName = "",
    -- 签名
    _08wSign = "",
    -- 应该领取的时间ID
    _09dwShouldGet_Time_Id = 0,
    -- 已经在线时间
    _10dwHasOnlineTime = 0,
    -- 已经抽奖次数
    _11dwHasLotteryCount = 0,
    -- 是否完成每日对战
    _12bFinishEverydayGame = 0,
    -- 是否已经领取兑换码奖励
    _13bHasGetExchangeCodeAward = 0,
    -- 已经分享的天数
    _14byHasShareDay_Id = 0,
    -- 今天是否已经领取分享奖励
    _15bTodayShare = 0,
    -- 是否首充
    _16bIsFirstRecharge = 0,
    -- 是否已经修改昵称或性别
    _17bHasChangeNameOrSex = 0,
    -- 是否下载舞者资源
    _18bDownDancerResource = 0,
    --应该领取的时间ID 等于INVALID_DWORD表示今天的救济金已经领取完成
    _19dwShouldGet_Alms_Id = 0,
    --救济金领取剩余时间 等于INVALID_DWORD表示今天的救济金已经领取完成
    _20dwAlmsGetLeftTime = 0,
    --是否开服充值
    _21dwStartServerRecharge = 0;
    --玩家所在地址
    _22Address = "";
    --(是否有保险箱密码)
    _23bHasStrongBoxPassword = 0;
    _24byCurrentSignDay_Id = 0;
    _25bTodaySign = 0;
    --是否需要登录验证
    _26bLoginValidate = 0;
    --是否限制银行
    _27bLimitBank = 0;
    --是否绑定手机
    _28IsPhoneNumber = 0;
    --手机号
    _29szPhoneNumber = 0;
    --看过公告
    _30LookNotice = 0;
    --看过邮件
    _31LookEmail = 0;
    --新邮件通知
    _32NewEmail = 0;
    --玩家显示ID
    _33PlayerID = 0;
    --断线重连游戏ID
    _36ReconnectGameID = 0;
    --断线重连游戏房间id
    _37ReconnectFloorID = 0;
}
-- 保存游戏房间（服务器发送的所以游戏房间信息都存放在这个Table）
AllSCGameRoom = { };

SCGameLoginInfo = {
    -- 楼层ID
    _1byFloorID = "",
    -- 游戏ID
    _2wGameID = "",
    -- 房间ID
    _3wRoomID = "",
    -- 房间地址
    _4dwServerAddr = "",
    -- 房间端口
    _5wServerPort = "",
    -- 最低金币
    _6iLessGold = "",
    -- 在线人数
    _7dwOnLineCount = "",
    -- 房间大小
    _8NameLenght = "",
    -- 房间名称
    _9Name = "",
}
--- 保存用户道具信息


-- 玩家的道具信息
AllSCUserProp = {
}

SaveUserProp = {
    -- 用户ID
    _01dwUser_Id = "",
    -- 道具ID
    _02dwProp_Id = "",
    -- 道具类型
    _03byPropType = "",
    -- 高低
    _04byHighLow = "",
    -- 性别
    _05bySex = "",
    -- 过期类型
    _06byExpireType = "",
    -- 数量
    _07dwAmount = "",
    -- 剩余时间
    _08dwRemainTime = "",
    -- 开始年份
    _09wYear = "",
    -- 开始月份
    _10wMonth = "",
    -- 开始星期
    _11wDayOfWeek = "",
    -- 开始日数
    _12wDay = "",
    -- 开始小时
    _13wHour = "",
    -- 开始分钟
    _14wMinute = "",
    -- 开始秒
    _15wSecond = "",
    -- 开始毫秒
    _16wMilliseconds = "",
    -- 结束年份
    _17wYear = "",
    -- 结束月份
    _18wMonth = "",
    -- 结束星期
    _19wDayOfWeek = "",
    -- 结束日数
    _20wDay = "",
    -- 结束小时
    _21wHour = "",
    -- 结束分钟
    _22wMinute = "",
    -- 结束秒
    _23wSecond = "",
    -- 结束毫秒
    _24wMilliseconds = "",
    -- 是否在使用
    _25bUse = "",
}
-- 聚宝信息
SCCornucopiaInfo = {
    _1Prize = "",
}
-- 所有在线时间信息
AllOnlineAward = {
}
-- 所有每日抽奖奖励
AllEveryLotteryAward = {
}
-- 抽奖次数
AllEveryCount = {
}
-- 排行榜信息
RankTab = {
}
-- 排行榜VIP对应信息
RankTabVIP = { }
-- 设置信息
AllSetGameInfo = {
    -- 背景音乐
    _1audio = 1,
    -- 音效
    _2soundEffect = 1,
    -- 亮度
    _3Brightness = "",
    -- 画质
    _4quality = 4,
    -- 背景音乐静音
    _5IsPlayAudio = true,
    -- 音效 静音
    _6IsPlayEffect = true,

}
-- 充值的所有信息
AllRecharege = { }
-- 聊天消息
ChatMainInfo = { }
-- 设置按钮显示的聊天消息
ShowChatInfo = { };
-- 新手引导表
UserNewHand = { }
-- 分享数据
ShareAward = { }
-- 公告
AllNotice = { };
-- 加载显示文字
-- 下载游戏资源序列
DownGameResource = { };

--大厅配置表信息
enum_hall = {
    hall1 = "GameOrder", --代表游戏显示顺序
    hall2 = "h2", --代表游戏QQ
    hall3 = "buy", --代表是否显示充值
    hall4 = "h4", --代表是否显示活动
    hall5 = "gameIsOnline", --代表游戏是否上线
    hall6 = "share", --是否显示分享

}
SeleteInfoToWindows = 1;
--
GameQQ = "3338753498";
