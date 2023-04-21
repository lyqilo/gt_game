------------------------------------------服务器传输的数据结构---------------------------
-- 加密KEY   	public const string DESKey = "89219417";
--gameDECkey = MD5Helper.DESKey;
--gameDECkey2 = MD5Helper.DESKey;

-- 下载单个资源完成
UpdateFileOver = 101;

String = {
    Empte = " ",
}

Platform = {
    PC = 1,
    IOS = 2,
    ANDROID = 3,
}
LuaFuncType = {
    luaString = 1,
    luaFile = 2,
}

Channel = {
    AppSotre = 1,
    c91 = 2,
    Test = 3,
}

VersionInfo = {
    [1] = Platform.PC,
    [2] = Channel.AppSotre,
    [3] = 1,
    [4] = 0,
}
screenWidthAndHight = {
    width = 1334,
    hight = 750,
}

-- 各个面板的事件定义
PanelListModeEven = {
    -- 大厅
    _001hallPanel = "",
    -- 排行榜
    _002rankPanel = "",
    -- 充值
    _003rechargePanel = "",
    -- 银行
    _004bankPanel = "",
    -- 个人信息
    _005personalPanel = "",
    -- 免费金币
    _006freeGoldPanel = "",
    -- 红包
    _007redPackagePanel = "",
    -- 兑换(商城)
    _008exchangePanel = "",
    -- 赠送币
    _009cornucopiaPanel = "",
    -- 活动
    _010noticeInfoPanel = "",
    --帮助
    _011helpInfoPanel = "",
    --设置
    _012setInfoPanel = "",
    --分享
    _013sharePanel = "",
    --房间选择
    _014gameRoomListPanel = "",
    --金币变动
    _015ChangeGoldTicket = "",
    --关闭照相遮罩
    _016ClosePohtoZheZ = "",
    --系统邮件
    _017emailPanel = "",
    --大厅网络异常
    _018NetException = "",
    --框架弹窗
    _019FramePopout = "",
}

UnitTag = {
    gameObj = "WenXinTishi",
    gameModuleSign = "rootGameModule",
}
BundleID = {
    ylc = "ylc3d",
    buyu = "buyu3d",
}
-- 游戏服务器名字(必须给服务器发来的名字对应)
gameServerName = {
    LOGON = "logon",
    HALL = "hall",
    LKPY = "李逵劈鱼",
    DDZ = "斗地主",
    POINTS21 = "澳门21点",
    Point21_2D = "决斗21点",
    SFZ = "水浒传",
    Baccara = "百家乐",
    Fish3D = "3D捕鱼",
    SerialIndiana = "龙珠探宝",
    vip = "VIP",
    Game01 = "水果狂欢",
    Game02 = "龙珠探宝",
    Game03 = "开心牛牛",
    Game04 = "奔驰宝马",
    Game05 = "金蟾捕鱼",
    Game06 = "炸金花",
    Game07 = "李逵劈鱼",
    Game08 = "飞禽走兽",
    Game09 = "悟空闹海",
    Game10 = "金龙赐福",
    Game11 = "速度激情",
    Game12 = "ATT连环炮",
    Game13 = "功夫熊猫",
    Game14 = "白蛇传",
    Game15 = "新开心牛牛",
    Game16 = "纸牌老虎机",
    Game17 = "楚河汉界",
    Game18 = "Game18",
    Game19 = "Game19",
    Game20 = "Game20",
}

gameServerName_MS = {
    LOGON = "logon",
    HALL = "hall",
    LKPY = "李逵劈鱼",
    POINTS21 = "澳门21点",
    Point21_2D = "澳门21点",
    SFZ = "水浒传",
    Baccara = "百家乐",
    Fish3D = "3D捕鱼",
    SerialIndiana = "龙珠探宝",
    vip = "VIP",
    Game01 = "水果狂欢",
    Game02 = "龙珠探宝",
    Game03 = "开心牛牛",
    Game04 = "奔驰宝马",
    Game05 = "金蟾捕鱼",
    Game06 = "炸金花",
    Game07 = "李逵劈鱼",
    Game08 = "飞禽走兽",
    Game09 = "悟空闹海",
    Game10 = "金龙赐福",
    Game11 = "速度激情",
    Game12 = "ATT连环炮",
    Game13 = "功夫熊猫",
    Game14 = "白蛇传",
    Game15 = "新开心牛牛",
    Game16 = "纸牌老虎机",
    Game17 = "楚河汉界",
    Game18 = "Game18",
    Game19 = "Game19",
    Game20 = "Game20",
}

-- 游戏各个场景的名字
gameScenName = {
    Start = "Start",
    LOGON = "logon",
    HALL = "hallScen",
    GLOBALSCEN = "GlobalScen",
    LKPY = "FishGame",
    DDZ = "Doudizhu",
    POINTS21 = "21Points",
    POINTS21_2D = "Point21_2D",
    SFZ = "shuihuzhuan",
    Fish3D = "Fish3D",
    Demo1 = "Demo1",
    Baccara = "Baccarat",
    SerialIndiana = "Game02", --龙珠探宝
    vip = "VIP",
    Game01 = "Game01",
    Game02 = "Game02",
    Game03 = "Game03",
    Game04 = "Game04",
    Game05 = "Game05",
    Game06 = "Game06",
    Game07 = "Game07",
    Game08 = "Game08",
    Game09 = "Game09",
    Game10 = "Game10",
    Game11 = "Game11",
    Game12 = "Game12",
    Game13 = "Game13",
    Game14 = "Game14",
    Game15 = "Game15",
    Game16 = "Game16",
    Game17 = "Game17",
    Game18 = "Game18",
    Game19 = "Game19",
    Game20 = "Game20",
}
-- 更新文件的类型
UpdateFileType = {
    DDZ = gameScenName.DDZ,
    SHZ = gameScenName.SFZ,
    POINT21 = gameScenName.POINTS21,
    HALL = gameScenName.HALL,
    LKPY = gameScenName.LKPY, --（Game07也是李逵劈鱼）
    Fish3D = gameScenName.Fish3D,
    Baccara = gameScenName.Baccara,
    Slot = gameScenName.Game01,
    serialindiana = gameScenName.Game02,
    benzbwm = gameScenName.Game04,
    niuniu = gameScenName.Game03,
    jsbuyu = gameScenName.Game05,
    zhajinhua = gameScenName.Game06,
    feiqinzoushou = gameScenName.Game08,
    Game09 = gameScenName.Game09,
    Game10 = gameScenName.Game10,
    Game11 = gameScenName.Game11,
    Game12 = gameScenName.Game12,
    Game13 = gameScenName.Game13,
    Game14 = gameScenName.Game14,
    Game15 = gameScenName.Game15,
    Game16 = gameScenName.Game16,
    Game17 = gameScenName.Game17,
    Game18 = gameScenName.Game18,
    Game19 = gameScenName.Game19,
    Game20 = gameScenName.Game20,
}
-- 每个线程代表?
gameSocketNumber = {
    LogonSoket = 1,
    HallSocket = 0,
    GameSocket = 2,
    ChatSocket = 3,
    LogSocket = 100,
}
GetPhoneCode = {
    [1] = 1,
    [2] = 1,
    [3] = 2,
    [4] = 12,
}
-- IOS内购充值的ID
gameIOSPayID = {
    --   [1] = BundleIdentifier..".1",
    --  [2] = BundleIdentifier..".8",
    --  [3] = BundleIdentifier..".18",
    --  [4] = BundleIdentifier..".68",
    --  [5] = BundleIdentifier..".98",
    --  [6] = BundleIdentifier..".198",
    ----  [7] = BundleIdentifier..".648",
    --  [8] = BundleIdentifier..".648",
}
-- 场景中可以点击物体的名字
HallscenGameButtonObjName = {
    LKPY = "buyuji2",
    DDZ = "dizhu",
    POINTS21 = "21zhuozi",
    SFZ = "shuifuzhuan",
    -- gotoVIP="Plane115",
    -- gotonoVIP="Box109",
}
-- 定义数据类型大小
DataSize = {
    Str = -1,
    ArrayInt32 = -2,
    ArrayInt16 = -3,
    ArrayString = -4,
    null = 0,
    byte = 1,
    Int16 = 2,
    UInt16 = 2,
    UInt32 = 4,
    UInt64 = 8,
    Int32 = 4,
    int = 4,
    Int32 = 4,
    String6 = 6,
    String7 = 7,

    String8 = 8,
    String9 = 9,
    String20 = 20,
    -- 表示传输的字符串大小为12个字节（手机号）
    String12 = 12,
    -- 表示传输的字符串大小为16个字节
    String16 = 16,
    -- 表示传输的字符串大小为32个字节(名字长度)
    String32 = 32,
    -- 字符串大小为33个字节（密码的MD5值）
    String33 = 33,
    -- 字符串大小为34个字节
    String34 = 34,
    -- 字符串大小为50个字节（机器码）
    String50 = 50,
    -- 签名
    String62 = 62,
    -- 字符串大小为64个字节
    String64 = 64,
    -- 地址长度
    String100 = 100,
    String256 = 256,
    -- 512表示这传输的字符传大小位置
    String = 512,
    StringAppStore = 4000,
    -- 根据服务器传输的时间结构体得出的大小为16字节
    SystemTime = 16,
}

-- 事件序号
EventIndex = {
    -- 网络层事件的随机值
    NetworkEventIndex = '10288',
    -- 游戏中事件的随机值
    GameEventIndex = '21355',
    -- 大厅事件的随机值
    HallEventIndex = '39721',
    -- 进入游戏
    loadGame = '9999',
    OnClick = '9998',
    --Home返回
    OnBackGame = '9997',
    --游戏帮助
    OnHelp = '9996',
    OnStopGame = '9995',
    OnHandleMessage = '9994',
    OnNetException = '9993',
}
-- 性别
enum_Sex = {
    -- 未知
    E_SEX_NULL = 0,
    -- 男
    E_SEX_MAN = 1,
    -- 女
    E_SEX_WOMAN = 2,
}

-- 实物类型
enum_GoodsType = {
    -- 未知
    E_GOODS_TYPE_NULL = 0,
    -- 普通
    E_GOODS_TYPE_NORMAL = 1,
    -- 充值卡
    E_GOODS_TYPE_RECHARGE = 2,
}

-- 道具类型
enum_PropType = {
    -- 未知
    E_PROP_TYPE_NULL = 0,
    -- 货币类
    E_PROP_TYPE_MONEY = 1,
    -- 消耗类
    E_PROP_TYPE_CONSUME = 2,
    -- 护腕
    E_PROP_TYPE_ANIMAL_STAR = 3,
    -- 装饰物
    E_PROP_TYPE_ORNAMENT = 4,
    -- 充值卡
    E_PROP_TYPE_RECHARGE_CARD = 5,
    -- 装饰物_时效性
    E_PROP_TYPE_ORNAMENT_TIMEOUT = 6,
}

-- 高低
enum_HighLow = {
    -- 未知
    E_HIGH_LOW_NULL = 0,
    -- 低
    E_HIGH_LOW_LOW = 1,
    -- 中
    E_HIGH_LOW_MID = 2,
    -- 高
    E_HIGH_LOW_HIGH = 3,
}


-- 过期类型
enum_ExpireType = {
    -- 未知
    E_EXPIRE_TYPE_NULL = 0,
    -- 个数
    E_EXPIRE_TYPE_AMOUNT = 1,
    -- 天数
    E_EXPIRE_TYPE_DAY = 2,
};

-- 道具ID
enum_Prop_Id = {
    -- 未知
    E_PROP_NULL = 0,
    -- 金币
    E_PROP_GOLD = 1,
    -- 奖券
    E_PROP_TICKET = 2,
    --保险箱
    E_PROP_STRONG = 3,
}
-- 游戏ID

enum_GameID = {
    -- 大厅
    E_GAME_ID_NULL = 0,
    -- 21点
    E_GAME_ID_BLACKJACK = 1,
    -- //斗地主
    E_GAME_ID_DOUDIZHU = 2,
    -- //水浒传
    E_GAME_ID_SHUIHUZHUI = 3,
    -- //李逵劈鱼
    E_GAME_ID_LKPY = 4,
    --//百家乐
    E_GAME_ID_BACCARAT = 5,
    --//3D捕鱼
    E_GAME_ID_3D_FISH = 6,
    --龙珠探宝
    E_GAME_ID_LHDB = 7,
    --斯洛特
    E_GAME_ID_SLT = 8,
    --牛牛
    E_GAME_ID_NIUNIU = 9,
    --奔驰宝马
    E_GAME_ID_BENCHIBAOMA = 10,
    --僵尸捕鱼
    E_GAME_ID_FISH_ZOMBIE = 11,
    --扎金花
    E_GAME_ID_ZHAJINHUA = 12,
    --VIP
    E_GAME_ID_VIP = 13,
    -- 飞禽走兽
    E_GAME_ID_FQZS = 14,
    --金龙赐福
    E_GAME_ID_JLCF = 15,
    --水果派对
    E_GAME_ID_SGPD = 16,
    --摇钱树
    E_GAME_ID_YQS = 17,
    --悟空闹海
    E_GAME_ID_WKNH = 18,
    --水果狂欢
    E_GAME_ID_SGKH = 19,
    --水果solt
    E_GAME_ID_SGST = 20,
    --疯狂翻牌机
    E_GAME_ID_FKFPJ = 21,
    --熊猫solt
    E_GAME_ID_XMST = 22,
    -- //梭哈
    -- E_GAME_ID_SHOWHAND=1112,
    -- 森林舞会
    -- E_GAME_ID_SENLINWUHUI=1113,
}

-- 分享平台
enum_SharePlatform = {
    -- 未知
    E_SHARE_PLATFORM_NULL = 0,
    -- 新浪微博
    E_SHARE_PLATFORM_SINA_WOBO = 1,
    -- 腾讯微博
    E_SHARE_PLATFORM_TENCENT_WOBO = 2,
    -- 微信
    E_SHARE_PLATFORM_WEI_XIN = 3,
}

--任务ID
enum_Task_Id = {
    E_TASK_NULL = 0, --//未知

    E_TASK_BIND_PHONE = 1, --//绑定手机
    E_TASK_FIRST_CHANGE_NICKNAME = 2, --//首次修改昵称
    E_TASK_FIRST_CHANGE_HEADER = 3, --//首次修改头像
    E_TASK_FIRST_CHANGE_SIGN = 4, --//首次修改签名
    E_TASK_FIRST_SHARE = 5, --//首次分享
    E_TASK_ALMS = 6, --//救济金
    E_TASK_Recharge = 7, --首冲
};

--- 消息头（消息命令）
MH = {
    --聊天
    Chat_MDM_player = 10000;
    --退出游戏到大厅
    Game_LEAVE = "2457894154",
    -- 初始化登录消息
    InitializationLogon = 1,
    -- 登录消息
    LoginInfo = 1,
    -- 用户消息
    UserInfo = 2,
    -- 用户状态
    UserStatus = 4,
    -- SystemInfo数据
    SystemInfo = 10,
    -- 游戏消息
    MDM_GF_GAME = 100,
    --------------------------
    MDM_3D_HEARTCOFIG = 29, --心跳配置
    SUB_3D_CS_HEART = 1, --心跳
    SUB_3D_SC_HEART = 2, --心跳返回
    -- =====================场景消息=========================
    MDM_ScenInfo = 101,
    SUB_GF_INFO = 1,
    -- 游戏信息 客户端游戏场景准备好了，准备接收场景消息
    SUB_GF_USER_READY = 2,
    -- 用户同意
    SUB_GF_OPTION = 100,
    -- 游戏配置
    SUB_GF_SCENE = 101,
    -- 场景信息
    SUB_GF_MESSAGE = 300,
    -- 系统消息


    -- =====================桌子用户数据=========================
    MDM_3D_TABLE_USER_DATA = 300,
    SUB_3D_TABLE_USER_ENTER = 0,
    -- 用户进入
    SUB_3D_TABLE_USER_LEAVE = 1,
    -- 用户离开
    SUB_3D_TABLE_USER_STATUS = 2,
    -- 用户状态
    SUB_3D_TABLE_USER_SCORE = 3,
    -- 用户分数

    -- =====================登录服务器=========================
    MDM_SC_LOGIN_SERVER = 1;
    -- 登录服务器
    SUB_CS_LOGIN_SERVER = 1;

    -- =====================登录游戏=========================
    MDM_GR_LOGON = 1,
    -- 房间登录
    SUB_GR_LOGON_USERID = 2,
    -- I D 登录
    SUB_GR_LOGON_GAME = 3,
    -- I D 登录
    SUB_GR_LOGON_SUCCESS = 100,
    -- 登录成功
    SUB_GR_LOGON_ERROR = 101,
    -- 登录失败
    SUB_GR_LOGON_FINISH = 102,
    -- /登录完成


    -- =====================用户数据包定义 =====================
    MDM_GR_USER = 2; -- 用户信息
    SUB_GR_USER_LEFT_GAME_REQ = 4; -- 离开游戏
    SUB_GR_USER_SIT_AUTO = 7; -- 自动坐下（自动查找可坐位置坐下）
    SUB_GR_USER_COME = 100; -- 用户进入
    SUB_GR_USER_STATUS = 101; -- 用户状态
    SUB_GR_USER_SCORE = 102; -- 用户分数
    SUB_GR_SIT_FAILED = 103; -- 坐下失败
    --- ==================登录大厅=============================


    MDM_3D_LOGIN = 20;
    -- 版本
    SUB_3D_CS_VERSION = 0;
    -- 验证码
    SUB_3D_CS_CODE = 1;
    -- 注册
    SUB_3D_CS_REGISTER = 15;
    -- 登录
    SUB_3D_CS_LOGIN = 3;
    -- 发送给服务器注销
    SUB_3D_CS_LOGOUT = 4;
    --登录授权验证码
    SUB_3D_CS_LOGIN_ACCREDIT_CODE = 30;
    --重置密码验证码
    SUB_3D_CS_RESET_PASSWORD_CODE = 6;
    --重置密码
    SUB_3D_CS_RESET_PASSWORD = 7;


    --请求验证码
    SUB_3D_CS_CODE_REQ = 30;
    --请求验证码返回
    SUB_3D_SC_CODE_ACK = 31;

    -- 版本
    SUB_3D_SC_VERSION = 0;
    -- 验证码
    SUB_3D_SC_CODE = 1;
    -- 注册 数据大小为0时表示注册成功，否则取字符串看错误原因
    SUB_3D_SC_REGISTER = 2;
    -- 登录失败	直接取字符串看错误原因
    SUB_3D_SC_LOGIN_FAILE = 3;
    -- 系统信息
    SUB_3D_SC_SYSTEM_INFO = 4;
    -- 房间信息
    SUB_3D_SC_ROOM_INFO = 5;
    -- 登录成功
    SUB_3D_SC_LOGIN_SUCCESS = 6;
    -- 服务器下发注销
    SUB_3D_SC_LOGOUT = 7;
    -- 帐号被挤下
    SUB_3D_SC_ACCOUNT_OFFLINE = 8;
    --需要登录授权验证码
    SUB_3D_SC_NEED_LOGIN_ACCREDIT_CODE = 31;
    --重置密码验证码
    SUB_3D_SC_RESET_PASSWORD_CODE = 10;
    --重置密码
    SUB_3D_SC_RESET_PASSWORD = 20;

    SUB_SC_RES_MODIFY_USER_PASSWD_CHECK_CODE = 23;
    --账号密码错误
    SUB_3D_SC_AccoutError = 24;


    -- ===================个人信息==============================
    MDM_3D_PERSONAL_INFO = 21;
    -- 修改密码
    SUB_3D_CS_CHANGE_PASSWORD = 0;
    -- 修改呢称
    SUB_3D_CS_CHANGE_NICKNAME = 1;
    -- 修改帐号
    SUB_3D_CS_CHANGE_ACCOUNT = 2;
    -- 修改签名
    SUB_3D_CS_CHANGE_SIGN = 3;
    -- 用户信息查询
    SUB_3D_CS_USER_INFO_SELECT = 4;
    -- 玩家新手引导_完成
    SUB_3D_CS_USER_NEW_HAND_FINISH = 5;
    -- 用户VIP查询
    SUB_3D_CS_USER_VIP_SELECT = 6;
    --保险箱-存入
    SUB_3D_CS_STRONG_SAVE = 7;
    --保险箱--取出
    SUB_3D_CS_STRONG_GET = 8;
    --保险箱--设置密码
    SUB_3D_CS_STRONG_SET_PASSWORD = 9;
    --设置登录验证
    SUB_3D_CS_SET_LOGIN_VALIDATE = 10;
    --进入保险箱
    SUB_3D_CS_STRONG_BOX_COME_IN = 20; --原消息ID为11
    --查询玩家金币信息
    SUB_3D_CS_SELECT_GOLD_MSG = 21;

    SUB_3D_CS_QUERY_UP_SCORE_RECORD = 27; -- 查询玩家上下分记录（10条）
    SUB_3D_SC_QUERY_UP_SCORE_RECORD = 28; -- 查询玩家上下分记录返回

    SUB_3D_CS_QUERY_EXCHANGE_CODE = 29; -- 查询兑换码使用情况
    SUB_3D_SC_QUERY_EXCHANGE_CODE = 30; -- 查询兑换码使用情况返回

    SUB_3D_SC_USER_GOLD = 31; --玩家金币

    SUB_3D_CS_DIANKA_QUERY=				32;	--点卡查询
    SUB_3D_SC_DIANKA_QUERY=				33;	--点卡查询返回


    SUB_3D_CS_DIANKA_GIVE=				34;--点卡赠送
    SUB_3D_SC_DIANKA_GIVE=				35;--点卡赠送返回

    SUB_3D_CS_DIANKA_RECEIVE=			36;--点卡领取
    SUB_3D_SC_DIANKA_RECEIVE=			37;--点卡领取返回
    -- 用户道具
    SUB_3D_SC_USER_PROP = 0;
    -- 修改密码 数据大小为0表示成功，否则直接取字符串看错误原因
    SUB_3D_SC_CHANGE_PASSWORD = 1;
    -- 修改呢称 数据大小为0表示成功，否则直接取字符串看错误原因
    SUB_3D_SC_CHANGE_NICKNAME = 2;
    -- 修改帐号 数据大小为0表示成功，否则直接取字符串看错误原因
    SUB_3D_SC_CHANGE_ACCOUNT = 3;
    -- 修改签名 数据大小为0表示成功，否则直接取字符串看错误原因
    SUB_3D_SC_CHANGE_SIGN = 4;
    -- 用户信息查询结果
    SUB_3D_SC_USER_INFO_SELECT = 5;
    -- 玩家新手引导-开始
    SUB_3D_SC_USER_NEW_HAND_START = 6;
    -- 玩家新手引导
    SUB_3D_SC_USER_NEW_HAND = 7;
    -- 玩家新手引导-结束
    SUB_3D_SC_USER_NEW_HAND_STOP = 8;
    -- 玩家新手引导_完成 数据大小为0表示成功，否则直接取字符串看错误原因
    SUB_3D_SC_USER_NEW_HAND_FINISH = 9;
    -- 用户VIP查询
    SUB_3D_SC_USER_VIP_SELECT = 10;
    --保险箱--存入 数据大小为0表示成功
    SUB_3D_SC_STRONG_SAVE = 11;
    --保险箱--取出
    SUB_3D_SC_STRONG_GET = 12;
    --玩家首充——开始
    SUB_3D_SC_USER_FIRST_RECHARGE_START = 13;
    --玩家首充
    SUB_3D_SC_USER_FIRST_RECHARGE = 14;
    --玩家首充——结束
    SUB_3D_SC_USER_FIRST_RECHARGE_STOP = 15;
    --保险箱--设置密码，数据大小为0表示成功
    SUB_3D_SC_STRONG_SET_PASSWORD = 16;
    --设置登录验证
    SUB_3D_SC_SET_LOGIN_VALIDATE = 17;
    --进入保险箱
    SUB_3D_SC_STRONG_BOX_COME_IN = 18;
    --通知、修改消息
    SUB_3D_SC_NOTIFY_CHANGE_USER_INFO = 19;
    -- 查询玩家金币消息
    SUB_3D_SC_SELECT_GOLD_MSG_RES = 22;

    SUB_3D_CS_QUERYLOGINVERIFY = 23; --//查询登录验证状态
    SUB_3D_SC_QUERYLOGINVERIFY_RES = 24; -- //查询登录验证状态返回


    SUB_3D_CS_ChangeHeader = 25; --//更改头像
    SUB_3D_SC_ChangeHeader = 26; -- //更改头像返回

    -- ========================聚宝盆============================
    MDM_3D_GOLDMINET = 22;
    -- 金币对奖券
    SUB_3D_CS_GOLD_TO_PRIZET = 0;
    -- 赠送金币
    SUB_3D_CS_PRESENT_GOLDT = 1;
    -- 金币对奖券 数据大小为0表示成功，否则直接取字符串看错误原因
    SUB_3D_SC_GOLD_TO_PRIZET = 0;
    --客户端请求记录数据
    SUB_3D_CS_PRESENT_GOLD_RECORD = 2;
    --赠送金币领取
    SUB_3D_CS_PRESENT_GOLD_GET = 3;

    -- 赠送金币 数据大小为0表示成功，否则直接取字符串看错误原因
    SUB_3D_SC_PRESENT_GOLDT = 1;
    -- 被赠送通知
    SUB_3D_SC_PRESENT_GOLD_NOTIFY = 2;
    --服务器下发记录的开始
    SUB_3D_SC_PRESENT_GOLD_RECORD_START = 3;
    --服务器下发每条数据
    SUB_3D_SC_PRESENT_GOLD_RECORD = 4;
    --服务器下发数据完成
    SUB_3D_SC_PRESENT_GOLD_RECORD_END = 5;
    --赠送金币领取
    SUB_3D_SC_PRESENT_GOLD_GET = 6;

    SUB_3D_CS_TRANSFERACCOUNTS = 10; --//银行转账
    SUB_3D_SC_TRANSFERACCOUNTS = 11; --//银行转账返回
    SUB_3D_SC_UPDATEBANKERSAVEGOLD = 12; --//刷新银行存款

    SUB_2D_CS_GIVE_RECORD_LIST = 5; -- // 获赠道具列表
    SUB_2D_SC_GIVE_RECORD_LIST = 4; -- // 获赠道具列表


    SUB_3D_CS_WITHDRAW = 13; --撤回邮件
    SUB_3D_SC_WITHDRAW = 14; --撤回邮件

    -- ======================商城================================
    MDM_3D_SHOP = 23;
    -- 查询实物
    SUB_3D_CS_SELECT_GOODS = 0;
    -- 兑换实物-普通
    SUB_3D_CS_EXCHANGE_GOODS_NORMAL = 1;
    -- 兑换实物-充值卡
    SUB_3D_CS_EXCHANGE_GOODS_RECHARGE_CARD = 2;
    -- 兑换实物-记录
    SUB_3D_CS_EXCHANGE_GOODS_RECORD = 3;
    -- 查询实物-开始
    SUB_3D_SC_SELECT_GOODS_START = 0;
    -- 查询实物
    SUB_3D_SC_SELECT_GOODS = 1;
    -- 查询实物-结束
    SUB_3D_SC_SELECT_GOODS_STOP = 2;
    -- 兑换实物-普通 数据大小为0表示成功，否则直接取字符串看错误原因
    SUB_3D_SC_EXCHANGE_GOODS_NORMAL = 3;
    -- 兑换实物-充值卡 数据大小为0表示成功，否则直接取字符串看错误原因
    SUB_3D_SC_EXCHANGE_GOODS_RECHARGE_CARD = 4;
    -- 兑换实物-记录-开始
    SUB_3D_SC_EXCHANGE_GOODS_RECORD_START = 5;
    -- 兑换实物-记录
    SUB_3D_SC_EXCHANGE_GOODS_RECORD = 6;
    -- 兑换实物-记录-结束
    SUB_3D_SC_EXCHANGE_GOODS_RECORD_STOP = 7;
    -- ===================奖励任务==============================
    MDM_3D_TASK = 24;
    -- 在线任务
    SUB_3D_CS_ONLINE_AWARD = 0;
    -- 每日抽奖奖励
    SUB_3D_CS_EVERY_LOTTERY_AWARD = 1;
    -- 领取在线奖励
    SUB_3D_CS_GET_ONLINE_AWARD = 2;
    -- 领取每日抽奖奖励
    SUB_3D_CS_GET_EVERY_LOTTERY_AWARD = 3;
    -- 领取兑换码奖励
    SUB_3D_CS_GET_EXCHANGE_CODE_AWARD = 4;
    -- 兑换码奖励显示
    SUB_3D_CS_EXCHANGE_CODE_AWARD = 5;
    -- 每日对战奖励显示
    SUB_3D_CS_EVERYDAY_GAME_AWARD = 6;
    -- 手机用户奖励
    SUB_3D_CS_PHONE_NUM_AWARD = 7;
    -- 抽奖次数
    SUB_3D_CS_LOTTERY_COUNT = 8;
    -- 分享奖励
    SUB_3D_CS_SHARE_AWARD = 9;
    -- 分享和领取奖励
    SUB_3D_CS_SHARE_AND_GET_AWARD = 10;
    -- 下载资源——舞者——完成
    SUB_3D_CS_DOWN_RESOURCE_DANCER_FINISH = 11;
    -- 下载资源——游戏——完成
    SUB_3D_CS_DOWN_RESOURCE_GAME_FINISH = 12;
    SUB_3D_CS_ALMS = 13; --救济金
    SUB_3D_CS_ALMS_USER_GET = 14; --救济金_用户领取

    --新每日抽奖
    --//新每日抽奖奖励——_获取抽奖ID
    SUB_3D_CS_NEW_GET_LOTTERY_AWARD_LOTTERY_ID = 15;
    --//新每日抽奖奖励——领取
    SUB_3D_CS_NEW_GET_LOTTERY_AWARD_GET = 16;
    --免费金币列表
    SUB_3D_CS_FREE_GOLD_LIST = 17;
    --//领取签到奖励
    SUB_3D_CS_GET_SIGN_AWARD = 18;
    --//查询领取签到奖励
    SUB_3D_CS_SELECT_SIGN_AWARD = 19;
    --//查询兑换码
    SUB_3D_CS_SELECT_EXCHANGE_CODE = 20;


    -- 在线奖励
    SUB_3D_SC_ONLINE_AWARD_START = 0;
    -- 在线奖励
    SUB_3D_SC_ONLINE_AWARD = 1;
    -- 在线奖励
    SUB_3D_SC_ONLINE_AWARD_STOP = 2;
    -- 每日抽奖奖励
    SUB_3D_SC_EVERY_LOTTERY_AWARD_START = 3;
    -- 每日抽奖奖励
    SUB_3D_SC_EVERY_LOTTERY_AWARD = 4;
    -- 每日抽奖奖励
    SUB_3D_SC_EVERY_LOTTERY_AWARD_STOP = 5;
    -- 领取在线奖励 数据大小为0表示成功，否则直接取字符串看错误原因
    SUB_3D_SC_GET_ONLINE_AWARD = 6;
    -- 领取每日抽奖奖励 数据大小为0表示成功，否则直接取字符串看错误原因
    SUB_3D_SC_GET_EVERY_LOTTERY_AWARD = 7;
    -- 完成每日对战任务
    SUB_3D_SC_FINISH_EVERYDAY_GAME = 8;
    -- 领取兑换码奖励 数据大小为0表示成功，否则直接取字符串看错误原因
    SUB_3D_SC_GET_EXCHANGE_CODE_AWARD = 9;
    -- 兑换码奖励_开始
    SUB_3D_SC_EXCHANGE_CODE_AWARD_START = 10;
    -- 兑换码奖励
    SUB_3D_SC_EXCHANGE_CODE_AWARD = 11;
    -- 兑换码奖励_结束
    SUB_3D_SC_EXCHANGE_CODE_AWARD_STOP = 12;
    -- 每日对战奖励_开始
    SUB_3D_SC_EVERYDAY_GAME_AWARD_START = 13;
    -- 每日对战奖励
    SUB_3D_SC_EVERYDAY_GAME_AWARD = 14;
    -- 每日对战奖励_结束
    SUB_3D_SC_EVERYDAY_GAME_AWARD_STOP = 15;
    -- 手机用户奖励_开始
    SUB_3D_SC_PHONE_NUM_AWARD_START = 16;
    -- 手机用户奖励
    SUB_3D_SC_PHONE_NUM_AWARD = 17;
    -- 手机用户奖励_结束
    SUB_3D_SC_PHONE_NUM_AWARD_STOP = 18;
    -- 抽奖次数开始
    SUB_3D_SC_LOTTERY_COUNT_START = 19;
    -- 抽奖次数
    SUB_3D_SC_LOTTERY_COUNT = 20;
    -- 抽奖次数结束
    SUB_3D_SC_LOTTERY_COUNT_STOP = 21;
    -- 分享奖励——开始
    SUB_3D_SC_SHARE_AWARD_START = 22;
    -- 分享奖励
    SUB_3D_SC_SHARE_AWARD = 23;
    -- 分享奖励——结束
    SUB_3D_SC_SHARE_AWARD_STOP = 24;
    -- 分享和领取奖励 数据为0表示成功
    SUB_3D_SC_SHARE_AND_GET_AWARD = 25;
    -- 完成全天对战任务
    SUB_3D_SC_FINISH_ALLDAY_GAME = 26;
    -- //下载资源——舞者——完成 数据大小为0表示成功，否则直接取字符串看错误原因
    SUB_3D_SC_DOWN_RESOURCE_DANCER_FINISH = 27;
    -- //玩家下载游戏资源-开始
    SUB_3D_SC_DOWN_GAME_RESOURCE_START = 28;
    -- 请求验证码
    SUB_3D_SC_DOWN_GAME_RESOURCE = 29;
    -- //玩家下载游戏资源-结束
    SUB_3D_SC_DOWN_GAME_RESOURCE_STOP = 30;
    -- //下载资源——游戏——完成 数据大小为0表示成功，否则直接取字符串看错误原因
    SUB_3D_SC_DOWN_RESOURCE_GAME_FINISH = 31;
    SUB_3D_SC_ALMS_START = 32; --救济金-开始
    SUB_3D_SC_ALMS = 33; --/救济金
    SUB_3D_SC_ALMS_STOP = 34; --救济金-结束


    SUB_3D_SC_ALMS_USER_GET = 35; --救济金_用户领取
    SUB_3D_SC_ALMS_USER_GET_FAIL = 36; --救济金_用户领取 直接取字符串看错误原因

    SUB_3D_SC_UPLOAD_HEADER_GET_AWARD = 37; --上传头像获得奖励
    SUB_3D_SC_NEW_GET_LOTTERY_AWARD_LOTTERY_ID = 38; --//新每日抽奖奖励——_获取抽奖ID
    SUB_3D_SC_NEW_GET_LOTTERY_AWARD_GET = 39; --//新每日抽奖奖励——领取  数据大小为0表示成功，否则取数据

    --免费金币列表_开始
    SUB_3D_SC_FREE_GOLD_LIST_START = 40;
    --免费金币列表
    SUB_3D_SC_FREE_GOLD_LIST = 41;
    --免费金币列表_结束
    SUB_3D_SC_FREE_GOLD_LIST_STOP = 42;
    --//领取签到奖励
    SUB_3D_SC_GET_SIGN_AWARD = 43;
    --//查询兑换码
    SUB_3D_SC_SELECT_EXCHANGE_CODE = 47;
    -- =============聊天信息=================================
    -- 聊天信息
    MDM_3D_CHAT_ROOM = 25,
    -- 发送聊天
    SUB_3D_CS_CHAT_ROOM_CHAT = 0,
    -- 发送聊天
    SUB_3D_CS_CHAT_ROOM_CHAT = 0,

    -- ===================助手（排行榜、活动公告、通告）==============================
    MDM_3D_ASSIST = 26;
    -- 排行榜-金币
    SUB_3D_CS_RANKTOP_GOLD = 0;
    -- 活动中心
    SUB_3D_CS_ACTIVITY_CORE = 1;
    -- 舞者信息
    SUB_3D_CS_DANCER = 2;
    -- 点舞
    SUB_3D_CS_DANCER_REQUEST = 3;
    SUB_3D_CS_RANKROOM_GOLD_SELECT = 4; --排行榜房间——查询
    --检查客户端网络
    SUB_3D_CS_CHECK_CLIENT_NETWORK = 5;
    --昨日盈利
    SUB_3D_CS_RANKWIN_YESTERDAY = 6;
    --活动邮件
    SUB_3D_CS_ACTIVITY_MAIL = 7;
    --活动邮件_领取
    SUB_3D_CS_ACTIVITY_MAIL_GET = 8;
    --//房间数据_查询
    SUB_3D_CS_ROOM_DATA_SELECT = 9;
    --//看过公告
    SUB_3D_CS_LOOK_ACTIVITY_CORE = 10;
    --//看过邮件
    SUB_3D_CS_LOOK_ACTIVITY_MAIL = 11;

    SUB_3D_CS_QUERY_IS_CAN_LOGIN	= 24;--查询是否能登陆
    SUB_3D_SC_QUERY_IS_CAN_LOGIN	= 25;--查询是否能登陆返回


    -- 排行榜-金币-开始
    SUB_3D_SC_RANKTOP_GOLD_START = 0;
    -- 排行榜-金币
    SUB_3D_SC_RANKTOP_GOLD = 1;
    -- 排行榜-金币-结束
    SUB_3D_SC_RANKTOP_GOLD_STOP = 2;
    -- 活动中心-开始
    SUB_3D_SC_ACTIVITY_CORE_START = 3;
    -- 活动中心
    SUB_3D_SC_ACTIVITY_CORE = 4;
    -- 活动中心-结束
    SUB_3D_SC_ACTIVITY_CORE_STOP = 5;
    -- 通知信息
    SUB_3D_SC_NOTIFY_INFO = 6;
    -- 每日清理数据 应该领取的时间ID为最小的时间ID，已经在线时间为0，已经抽奖次数为0，是否完成每日对战为false
    SUB_3D_SC_EVERYDAY_CLEAR_DATA = 7;
    -- 舞者开始
    SUB_3D_SC_DANCER_START = 8;
    -- 舞者
    SUB_3D_SC_DANCER = 9;
    -- 舞者结束
    SUB_3D_SC_DANCER_STOP = 10;
    -- 点舞 数据大小为0表示成功，否则直接取字符串看错误原因
    SUB_3D_SC_DANCER_REQUEST = 11;
    -- 点舞_通告
    SUB_3D_SC_DANCER_REQUEST_NOTITY = 12;
    SUB_3D_SC_RANKROOM_GOLD_SELECT_START = 13; --排行榜房间——查询-开始
    SUB_3D_SC_RANKROOM_GOLD_SELECT = 14; --排行榜房间——查询
    SUB_3D_SC_RANKROOM_GOLD_SELECT_STOP = 15; --排行榜房间——查询-结束
    --检查客户端网络
    SUB_3D_SC_CHECK_CLIENT_NETWORK = 16;
    --昨日盈利-开始
    SUB_3D_SC_RANKWIN_YESTERDAY_START = 17;
    --昨日盈利
    SUB_3D_SC_RANKWIN_YESTERDAY = 18;
    --昨日盈利-结束
    SUB_3D_SC_RANKWIN_YESTERDAY_STOP = 19;
    --活动邮件-开始
    SUB_3D_SC_ACTIVITY_MAIL_START = 20;
    --活动邮件
    SUB_3D_SC_ACTIVITY_MAIL = 21;
    --活动邮件-结束
    SUB_3D_SC_ACTIVITY_MAIL_STOP = 22;
    --活动邮件_领取
    SUB_3D_SC_ACTIVITY_MAIL_GET = 23;
    --房间数据_查询_开始
    SUB_3D_SC_ROOM_DATA_SELECT_START = 24;
    --房间数据
    SUB_3D_SC_ROOM_DATA_SELECT = 25;
    --房间数据_查询_结束
    SUB_3D_SC_ROOM_DATA_SELECT_STOP = 26;
    --//看过公告 没有数据 可以不处理
    SUB_3D_SC_LOOK_ACTIVITY_CORE = 27;
    --//看过邮件 没有数据 可以不处理
    SUB_3D_SC_LOOK_ACTIVITY_MAIL = 28;
    --新邮件通知
    SUB_3D_SC_NEW_ACTIVITY_MAIL = 29;
    -- ===================充值==============================
    MDM_3D_RECHARGE = 27;
    -- //充值列表
    SUB_3D_CS_RECHARGE_LIST = 0;
    -- //非APPStore充值
    SUB_3D_CS_RECHARGE_NO_APPSTORE = 1;
    -- //APPStore充值
    SUB_3D_CS_RECHARGE_APPSTORE = 2;
    -- //充值列表-开始
    SUB_3D_SC_RECHARGE_LIST_START = 0;
    -- //充值列表
    SUB_3D_SC_RECHARGE_LIST = 1;
    -- //充值列表-结束
    SUB_3D_SC_RECHARGE_LIST_STOP = 2;
    -- //非APPStore充值
    SUB_3D_SC_RECHARGE_NO_APPSTORE = 3;
    -- //充值结果 数据大小为0表示成功，否则直接取字符串看错误原因
    SUB_3D_SC_RECHARGE_RESULT = 4;
    -- ===================游戏框架信息（换桌、表情、动作、聊天）==============================
    -- 游戏框架信息
    MDM_3D_FRAME = 301;
    -- 换桌
    SUB_3D_CS_SWITCH_TABLE = 0;
    -- 发送表情
    SUB_3D_CS_SEND_SIGN = 1;
    -- 发送动作
    SUB_3D_CS_SEND_ACTION = 2;
    -- 发送聊天
    SUB_3D_CS_SEND_CHAT = 3;
    -- 自动入座
    SUB_3D_CS_AUTO_SIT = 4;
    SUB_3D_CS_GAME_HEART = 5;
    SUB_3D_SC_GAME_HEART = 11;

    -- 换桌 数据大小为0表示成功，否则直接取字符串看错误原因
    SUB_3D_SC_SWITCH_TABLE = 0;
    -- 发送表情
    SUB_3D_SC_SEND_SIGN = 1;
    -- 发送动作
    SUB_3D_SC_SEND_ACTION = 2;
    -- 发送聊天
    SUB_3D_SC_SEND_CHAT = 3;
    -- 自动入座 数据大小为0表示成功，否则直接取字符串看错误原因
    SUB_3D_SC_AUTO_SIT = 4;
    -- 房间信息 直接取字符串看信息
    SUB_3D_SC_ROOM_INFO = 5;
    -- 房间信息——断线 直接取字符串看信息
    SUB_3D_SC_ROOM_INFO_OFFLINE = 6;
    SUB_3D_SC_ROOM_INFO_BEGIN = 12;
    SUB_3D_SC_ROOM_INFO_END = 13;

    --=========================================银行====================================================
    MDM_GP_USER = 4;
    SUB_GP_BANKFRISTMODIFYPASS = 129;
    SUB_GP_BANKOPENACCOUNTRESULT = 128;
    SUB_GP_SETBANKPASSRESULT = 130;

    -- 新增 客户端发送
    SUB_GP_USER_BANK_OPERATE = 118; -- 银行存取  子消息号
    SUB_GP_MODIFY_BANK_PASSWD_CHECK_CODE = 136; -- 银行获取验证码

    -- 服务器发送
    SUB_GP_USER_BANK_OPERATE_RESULT = 134; -- 银行存取反馈
    SUB_GP_MODIFY_BANK_PASSWD = 135; -- 更改银行密码消息
    SUB_GP_MODIFY_BANK_PASSWD_CHECK_CODE_RESULT = 137; --修改银行密码反馈

}

SC_ChangeCode = {
    [1] = DataSize.byte,
    [2] = 1024,
}
-- 发送版本号
CS_Version = {
    -- 平台ID
    [1] = DataSize.byte,
    [2] = DataSize.byte,
    [3] = DataSize.UInt16,
    [4] = DataSize.UInt16,
}

---- 服务器发送的版本信息
SC_Version = {
    -- bUpdate;//是否更新
    [1] = DataSize.byte,
    -- bOnline;/是否上线
    [2] = DataSize.byte,
    -- 地址大小
    [3] = DataSize.UInt16,
    -- wUpdateAddress;更新地址
    [4] = DataSize.String,

}

-- 登录大厅
CS_LogonInfo = {
    -- 平台ID
    [1] = DataSize.byte,
    -- 渠道ID
    [2] = DataSize.byte,
    --ID
    [3] = DataSize.UInt16,
    [4] = DataSize.UInt32,
    [5] = DataSize.UInt16,
    [6] = DataSize.byte,
    -- 帐号
    [7] = DataSize.String32,
    -- 密码
    [8] = DataSize.String33,
    -- 机器码
    [9] = DataSize.String50,
    -- IP
    [10] = DataSize.String16,
    [11] = DataSize.String256,
    [12] = DataSize.String16,
}
--注册 362 181
CS_Register_ByAccount = {

    [1] = DataSize.byte,
    [2] = DataSize.byte,
    [3] = DataSize.UInt16,
    [4] = DataSize.UInt32,
    [5] = DataSize.UInt16,
    [6] = DataSize.byte,

    --帐号TCHAR szAccount[NAME_LEN*2]
    [7] = DataSize.String32,

    --TCHAR szPassword[PASS_LEN*2]
    [8] = DataSize.String33,
    --TCHAR szMachineNo[MACHINE_NO_LEN*2];//机器码DataSize.String100
    [9] = DataSize.String50,
    --TCHAR szPhoneNumber[PHONE_LEN*2];//手机号码DataSize.String12,
    [10] = DataSize.String12,
    [11] = DataSize.UInt32,
    [12] = DataSize.String16,
}


--找回密码
CS_ResetPassword = {
    [1] = DataSize.String12,
    [2] = DataSize.String33,
    -- //验证码
    [3] = DataSize.UInt32,
    [4] = DataSize.byte,
}
--- 获取验证码
CS_Code = {
    [1] = 12, -- DataSize.String11,
}
--- 获取验证码
CS_Password_Code = {
    [1] = 12, -- DataSize.String11,
    [2] = DataSize.byte,
}
--- 服务器下发验证码
SC_Code = {
    -- 验证码为0表示已经注册过了
    [1] = DataSize.UInt32,
}
-- 注册
CS_Register = {
    -- 平台ID
    [1] = DataSize.byte,
    -- 渠道ID
    [2] = DataSize.byte,
    -- 验证码
    [3] = DataSize.UInt32,
    -- 手机号码
    [4] = DataSize.String12,
    -- 密码
    [5] = DataSize.String33,
    -- 机器码
    [6] = DataSize.String50,
}

SC_GiveRecord = {
    [1] = DataSize.Int32; --// 礼物唯一索引UINT32
    [2] = DataSize.Int32; --// 发送者ID
    [3] = DataSize.Int32; --// 接收者ID
    [4] = DataSize.Int32; --// 道具idUINT32
    [5] = DataSize.UInt64; --// 道具个数UINT32
    [6] = DataSize.Int32; --// 赠送时间UINT32
    [7] = DataSize.Int32; --// 是否已领UINT32
    [8] = 128; --//赠送错误提示TCHAR[128]
    [9] = DataSize.String32; --发送者昵称
    [10] = DataSize.String32; --接收则昵称
};

--[[SC_LoginSuccess =
{
-- 用户ID
[1] = DataSize.UInt32,
-- 性别
[2] = DataSize.byte,
-- 是否自定义头像
[3] = DataSize.byte,
-- 帐号大小
[4] = DataSize.UInt16,
[5] = DataSize.String,
-- 昵称大小
[6] = DataSize.UInt16,
[7] = DataSize.String,
-- 密码大小
[8] = DataSize.UInt16,
[9] = DataSize.String,
-- 头像扩展名
[10] = DataSize.UInt16,
[11] = DataSize.String,
-- 签名大小
[12] = DataSize.UInt16,
[13] = DataSize.String,
-- 应该领取的时间ID
[14] = DataSize.UInt32,
-- 已经在线的时间
[15] = DataSize.UInt32,
-- 已经抽奖次数
[16] = DataSize.UInt32,
-- 是否完成每日对战
[17] = DataSize.byte,
-- 是否已经领取兑换码奖励
[18] = DataSize.byte,
-- 已经分享天数
[19] = DataSize.byte,
-- 今天是否已经领取
[20] = DataSize.byte,
-- 是否首充
[21] = DataSize.byte,
-- bool bHasChangeNameOrSex;//是否已经修改昵称或者性别
[22] = DataSize.byte,
-- bool bDownDancerResource;//是否下载舞者资源
[23] = DataSize.byte,
--应该领取的时间ID 等于INVALID_DWORD表示今天的救济金已经领取完成
[24] = DataSize.UInt32,
--救济金领取剩余时间 等于INVALID_DWORD表示今天的救济金已经领取完成
[25] = DataSize.UInt32,
--是否开服充值
[26] = DataSize.byte,
-- 是否有保险箱密码
[27]= DataSize.byte,
--当前签到天ID
[28]=DataSize.byte,
--今天是否已经签到
[29]=DataSize.byte,
--是否登录验证
[30]=DataSize.byte,
--是否限制银行
[31]=DataSize.byte,
--//手机号码
[32]=DataSize.UInt16,
--//手机号码
[33]=DataSize.String,
[34]=DataSize.byte,
[35]=DataSize.byte,
[36] = DataSize.UInt32,
}--]]

SC_LoginSuccess = {
    -- 用户ID
    [1] = DataSize.UInt32,

    -- 用户靓号ID
    [2] = DataSize.UInt32,
    -- 性别
    [3] = DataSize.byte,
    -- 是否自定义头像
    [4] = DataSize.byte,
    -- 帐号大小
    [5] = DataSize.UInt16,
    [6] = DataSize.String,
    -- 昵称大小
    [7] = DataSize.UInt16,
    [8] = DataSize.String,
    -- 密码大小
    [9] = DataSize.UInt16,
    [10] = DataSize.String,
    -- 头像扩展名
    [11] = DataSize.UInt16,
    [12] = DataSize.String,
    -- 签名大小
    [13] = DataSize.UInt16,
    [14] = DataSize.String,
    --应该领取的时间ID
    [15] = DataSize.UInt32,
    -- 已经在线的时间
    [16] = DataSize.UInt32,
    -- 已经抽奖次数
    [17] = DataSize.UInt32,
    -- 是否完成每日对战
    [18] = DataSize.byte,
    -- 是否已经领取兑换码奖励
    [19] = DataSize.byte,
    -- 已经分享天数
    [20] = DataSize.byte,
    -- 今天是否已经领取
    [21] = DataSize.byte,
    -- 是否首充
    [22] = DataSize.byte,
    -- bool bHasChangeNameOrSex;//是否已经修改昵称或者性别
    [23] = DataSize.byte,


    --抽奖CD时间
    [24] = DataSize.UInt32,
    --FaceId
    [25] = DataSize.UInt32,

    --[26] = DataSize.byte,
    --[27] = DataSize.byte,
    --[28] = DataSize.byte,
    --[29] = DataSize.byte,
    --[30] = DataSize.byte,

    [26] = DataSize.byte,
    [27] = DataSize.byte,
    [28] = DataSize.byte,
    [29] = DataSize.Int32,
    [30] = DataSize.byte,
    [31] = DataSize.byte,

    [32] = DataSize.Int32,

    [33] = DataSize.Int32,
    [34] = DataSize.Int16,

    [35] = DataSize.String,
    [36] = DataSize.UInt32,
    [37] = DataSize.byte,

}


-- 登录大厅成功后的房间信息结构
SC_GameRoom = {
    -- 楼层ID
    [1] = DataSize.byte,
    -- 游戏ID
    [2] = DataSize.UInt16,
    -- 房间ID
    [3] = DataSize.UInt16,
    -- 房间地址把ip地址改成string
    [4] = DataSize.UInt32,

    [5] = DataSize.String32,
    -- 房间端口
    [6] = DataSize.UInt16,
    -- 最低金币
    [7] = DataSize.Int32,
    -- 在线人数
    [8] = DataSize.UInt32,
    -- 房间名称的大小
    [9] = DataSize.UInt16,
    -- 房间名称
    [10] = DataSize.String,
    -- [11]=DataSize.UInt16,
    -- [12]=DataSize.String,
}

-- 登录成功后的系统信息结构
SC_SystemInfo = {
    -- Web服务器地址的长度
    [1] = DataSize.UInt16,
    -- Web服务器地址
    [2] = DataSize.String,
    -- 头像文件夹的长度
    [3] = DataSize.UInt16,
    -- 获取头像地址
    [4] = DataSize.String,
    -- 更新头像文件夹的长度
    [5] = DataSize.UInt16,
    -- 长传头像地址
    [6] = DataSize.String,
    -- 赠送最低需要金币
    [7] = DataSize.UInt32,
    -- 快速开始游戏ID wFastStartGameId
    [8] = DataSize.UInt16,
    -- DWORD dwChangeNickNameOrSexNeedGold;//修改昵称或者性别需要金币
    [9] = DataSize.UInt32,
    -- WORD wEverydayLotteryMaxCount;//每日抽奖最大次数
    [10] = DataSize.UInt16,
    -- WORD wFirstRechargePresentRate;//首充赠送比例
    [11] = DataSize.UInt16,
    -- DWORD dwFirstChangeNickNameOrSexPrizeGold;//首次修改昵称或者性别奖励金币
    [12] = DataSize.UInt32,
    --开服赠送比例
    [13] = DataSize.UInt16,
}

-- 时间结构体
SC_SystemTime = {
    [1] = DataSize.UInt16,
    [2] = DataSize.UInt16,
    [3] = DataSize.UInt16,
    [4] = DataSize.UInt16,
    [5] = DataSize.UInt16,
    [6] = DataSize.UInt16,
    [7] = DataSize.UInt16,
    [8] = DataSize.UInt16,
}
-- 用户道具信息
SC_User_Prop = {
    -- dwUser_Id
    [1] = DataSize.UInt32,
    -- dwProp_Id
    [2] = DataSize.UInt32,
    -- byPropType
    [3] = DataSize.byte,
    -- byHighLow
    [4] = DataSize.byte,
    -- bySex
    [5] = DataSize.byte,
    -- byExpireType
    [6] = DataSize.byte,
    -- dwAmount
    [7] = DataSize.UInt64,
    -- dwRemainTime
    [8] = DataSize.UInt32,
    -- startTime
    -- wYear
    [9] = DataSize.UInt16,
    -- wMonth
    [10] = DataSize.UInt16,
    -- wDayOfWeek
    [11] = DataSize.UInt16,
    -- wDay
    [12] = DataSize.UInt16,
    -- wHour
    [13] = DataSize.UInt16,
    -- wMinute
    [14] = DataSize.UInt16,
    -- wSecond
    [15] = DataSize.UInt16,
    -- wMilliseconds
    [16] = DataSize.UInt16,
    -- stopTime
    -- wYear
    [17] = DataSize.UInt16,
    -- wYear
    [18] = DataSize.UInt16,
    -- wMonth
    [19] = DataSize.UInt16,
    -- wDayOfWeek
    [20] = DataSize.UInt16,
    -- wDay
    [21] = DataSize.UInt16,
    -- wHour
    [22] = DataSize.UInt16,
    -- wMinute
    [23] = DataSize.UInt16,
    -- wSecond
    [24] = DataSize.UInt16,
    -- wMilliseconds
    [25] = DataSize.byte,

}

-- hz123 新增用户道具信息
New_SC_User_Prop = {
    -- cbResult 成功失败
    [1] = DataSize.byte,
    -- dwUser_Id
    [2] = DataSize.UInt32,
    -- dwProp_Id
    [3] = DataSize.UInt32,
    -- dwAmount
    [4] = DataSize.UInt64,
    -- dwRemainTime
    [5] = DataSize.UInt32,
    -- startTime
    
    -- wYear
    [6] = DataSize.UInt16,
    -- wMonth
    [7] = DataSize.UInt16,
    -- wDayOfWeek
    [8] = DataSize.UInt16,
    -- wDay
    [9] = DataSize.UInt16,
    -- wHour
    [10] = DataSize.UInt16,
    -- wMinute
    [11] = DataSize.UInt16,
    -- wSecond
    [12] = DataSize.UInt16,
    -- wMilliseconds
    [13] = DataSize.UInt16,
    -- stopTime
    -- wYear
    [14] = DataSize.UInt16,
    -- wYear
    [15] = DataSize.UInt16,
    -- wMonth
    [16] = DataSize.UInt16,
    -- wDayOfWeek
    [17] = DataSize.UInt16,
    -- wDay
    [18] = DataSize.UInt16,
    -- wHour
    [19] = DataSize.UInt16,
    -- wMinute
    [20] = DataSize.UInt16,
    -- wSecond
    [21] = DataSize.UInt16,
    -- wMilliseconds
    [22] = DataSize.byte,

}

----------------客户端到服务器-----------------
-- 游戏房间ID登录
CS_LogonByUserID = {
    -- DwPlazaVersion
    [1] = DataSize.UInt32,
    -- DwProcessVersion
    [2] = DataSize.UInt32,
    -- DwUserID
    [3] = DataSize.UInt32,
    -- szPassword
    [4] = DataSize.String33,
    -- szComputerID
    [5] = DataSize.String33,
}
-- 客户端场景准备好了
CS_Info = {
    -- bAllowLookon允许旁观 必须为0
    [1] = DataSize.byte,
}

-- 修改密码
CS_ChangePassword = {
    -- szOldPassword
    [1] = DataSize.String33,
    -- szNewPassword
    [2] = DataSize.String33,
}

-- 修改昵称
CS_ChangeNickName = {
    -- szNewNickName
    [1] = DataSize.String32,
    -- byNewSex
    [2] = DataSize.byte,
    -- szNewPassword
    --  [3] = DataSize.String33,
}

-- 修改帐号
CS_ChangeAccount = {
    -- szNewPhoneNum
    [1] = DataSize.String12,
    -- dwCode
    [2] = DataSize.UInt32,
    [3] = DataSize.String33,
}
-- 修改签名
CS_ChangeSign = {
    [1] = DataSize.String,

}

-- 金币对奖券
CS_GoldToPrize = {
    -- 金币
    [1] = DataSize.UInt32;
}



-- 赠送金币
CS_PresentGold = {
    -- dwGold;//金币
    [1] = DataSize.UInt64,
    -- szOtherNickaName;//别人呢称
    [2] = DataSize.UInt32,
}
-- 赠送金币通知
SC_PresentGold_Notify = {
    -- DWORD dwUser_Id;//用户ID --客户端可以不用 但是必须读取占位
    [1] = DataSize.UInt32,
    -- DWORD dwGold;//金币
    [2] = DataSize.UInt32,
    -- DWORD dwNickName;//昵称
    [3] = DataSize.UInt16,
    -- TCHAR szNickName[NAME_LEN];//呢称
    [4] = DataSize.String,
}

--- 查询实物

SC_SelectGoods = {
    -- dwGoods_Id;//实物ID
    [1] = DataSize.UInt32,
    -- dwTicket;//奖券数
    [2] = DataSize.UInt32,
    -- byGoodsType;//实物类型
    [3] = DataSize.byte,
    -- iRelationAmount;//关联数量
    [4] = DataSize.Int32,
}

-- 兑换实物-普通
CS_ExchangeGoods_Normal = {
    -- dwGoods_Id;//普通实物ID
    [1] = DataSize.UInt32,
    -- dwAmount;//数量
    [2] = DataSize.UInt32,
    -- szPassword;//密码
    [3] = DataSize.String33,
    -- szUserName;//姓名
    [4] = DataSize.String32,
    -- szPhoneNum;//手机号码
    [5] = DataSize.String12,
    -- szAddress;//地址
    [6] = DataSize.String100,
    -- szZIPCode;//邮编
    [7] = DataSize.String7,
}

-- 兑换实物-充值卡
CS_ExchangeGoods_RechargeCard = {
    -- dwGoods_Id;//充值卡实物ID
    [1] = DataSize.UInt32,
    -- dwAmount;//数量
    [2] = DataSize.UInt32,
    -- szPassword;//密码
    [3] = DataSize.String33,
    -- szPhoneNum;//手机号码
    [4] = DataSize.String12,
}
-- 兑换实物-记录
CS_ExchangeGoods_Record = {
    -- DWORD dwStartPos;//开始位置 从 0 开始
    [1] = DataSize.UInt32,
    -- DWORD dwAmount;//数量
    [2] = DataSize.UInt32,
}
-- 兑换实物-记录
SC_ExchangeGoods_Record = {
    -- DWORD dwGoods_Id;//实物ID
    [1] = DataSize.UInt32,
    -- LONGLONG lTotalTicketAmount;//总奖券数量
    [2] = DataSize.UInt64,
    -- INT32 iAmount;//数量
    [3] = DataSize.Int32,
    -- SYSTEMTIME buyTime;//购买时间
    -- wYear
    [4] = DataSize.UInt16,
    -- wMonth
    [5] = DataSize.UInt16,
    -- wDayOfWeek
    [6] = DataSize.UInt16,
    -- wDay
    [7] = DataSize.UInt16,
    -- wHour
    [8] = DataSize.UInt16,
    -- wMinute
    [9] = DataSize.UInt16,
    -- wSecond
    [10] = DataSize.UInt16,
    -- wMilliseconds
    [11] = DataSize.UInt16,
    -- WORD wOrder_No;//订单号
    [12] = DataSize.UInt16,
    -- TCHAR szOrder_No[NORMAL_LEN];//订单号
    [13] = DataSize.String,

}
-- 在线奖励
SC_OnlineAward = {
    -- dwTime_Id;//时间ID
    [1] = DataSize.UInt32,
    -- DWORD dwProp_Id;//道具ID
    [2] = DataSize.UInt32,
    -- DWORD dwAmount;//数量
    [3] = DataSize.UInt32,
}
-- 每日抽奖奖励
SC_EveryLotteryAward = {
    -- DWORD dwLottery_Id;//抽奖ID
    [1] = DataSize.UInt32,
    -- DWORD dwProp_Id;//道具ID
    [2] = DataSize.UInt32,
    -- DWORD dwAmount;//数量
    [3] = DataSize.UInt32,
}
-- 领取在线奖励
CS_GetOnlineAward = {
    -- DWORD dwShouldGet_Time_Id;//应该领取的时间ID
    [1] = DataSize.UInt32,
}
-- 领取每日抽奖奖励
SC_GetEveryLotteryAward = {
    -- DWORD dwLottery_Id;//抽奖ID
    [1] = DataSize.UInt32,
}
-- 领取加群兑换奖励
CS_GetExchangeCodeAward = {
    -- TCHAR szExchangeCode[EXCHANGE_CODE_LEN*2];//兑换码
    -- szExchangeCode的长度
    [1] = DataSize.UInt32,
    [2] = DataSize.String20,

}
-- 查询兑换码对应金币
CS_DuiHuanMa_Gold = {
    -- TCHAR szExchangeCode[EXCHANGE_CODE_LEN*2];//兑换码
    [1] = DataSize.String9,
    [2] = DataSize.String9,
}
-- 普通奖励
SC_NormalAward = {
    -- DWORD dwProp_Id;//道具ID
    [1] = DataSize.UInt32,
    -- DWORD dwAmount;//数量
    [2] = DataSize.UInt32,
}
-- 抽奖次数
SC_LotteryCount = {
    -- DWORD dwLotteryCount_Id;//抽奖次数ID
    [1] = DataSize.UInt32,
    -- DWORD dwMinCount;//最小次数
    [2] = DataSize.UInt32,
    -- DWORD dwMaxCount;//最大次数
    [3] = DataSize.UInt32,
    -- DWORD dwNeedGold;//需要金币
    [4] = DataSize.UInt32,
}

-- 手机绑定，兑换码，每日对战奖励物品内容
SC_NormalAward = {
    -- DWORD dwProp_Id;//道具ID
    [1] = DataSize.UInt32,
    -- DWORD dwAmount;//数量
    [2] = DataSize.UInt32,
}
-- 分享奖励
SC_ShareAward = {
    -- 分享天数
    [1] = DataSize.byte,
    -- 道具ID
    [2] = DataSize.UInt32,
    -- 道具数量
    [3] = DataSize.UInt32,
}
-- 发送分享和领取奖励
CS_ShareAndGetAward = {
    -- BYTE bySharePlatform_Id;//分享平台
    [1] = DataSize.byte,
}
SC_RankTopOrYesterWin_Start = {
    [1] = DataSize.UInt32,
    -- SYSTEMTIME startTime;//开始时间
    -- wYear
    [2] = DataSize.UInt16,
    -- wMonth
    [3] = DataSize.UInt16,
    -- wDayOfWeek
    [4] = DataSize.UInt16,
    -- wDay
    [5] = DataSize.UInt16,
    -- wHour
    [6] = DataSize.UInt16,
    -- wMinute
    [7] = DataSize.UInt16,
    -- wSecond
    [8] = DataSize.UInt16,
    -- wMilliseconds
    [9] = DataSize.UInt16,
}
-- 排行榜-金币
SC_RankTopGold = {
    -- DWORD dwUser_Id;//用户ID
    [1] = DataSize.UInt32,
    -- WORD wNickName;//呢称
    -- TCHAR szNickName[NAME_LEN];//呢称
    [2] = DataSize.UInt16,
    [3] = DataSize.String,
    -- DWORD dwGold;//金币
    [4] = DataSize.UInt64,
    -- DWORD dwPrize;//奖券
    [5] = DataSize.UInt64,
    -- BYTE bySex;//性别
    [6] = DataSize.byte,
    -- bool bCustomHeader;//是否自定义头像
    [7] = DataSize.byte,
    -- WORD wHeaderExtensionName;//头像扩展名
    -- TCHAR szHeaderExtensionName[HEADER_EXT_LEN];//头像扩展名
    [8] = DataSize.UInt16,
    [9] = DataSize.String,
    -- WORD wSign;//签名
    -- TCHAR szSign[SIGN_LEN];//签名
    [10] = DataSize.UInt16,
    [11] = DataSize.String,
    [12] = DataSize.byte,
}
SC_RoomTopGold = {
    -- DWORD dwUser_Id;//用户ID
    [1] = DataSize.UInt32,
    -- WORD wNickName;//呢称
    -- TCHAR szNickName[NAME_LEN];//呢称
    [2] = DataSize.UInt16,
    [3] = DataSize.String,
    -- DWORD dwGold;//金币
    [4] = DataSize.UInt64,
    -- DWORD dwPrize;//奖券
    [5] = DataSize.UInt64,
    -- BYTE bySex;//性别
    [6] = DataSize.byte,
    -- bool bCustomHeader;//是否自定义头像
    [7] = DataSize.byte,
    -- WORD wHeaderExtensionName;//头像扩展名
    -- TCHAR szHeaderExtensionName[HEADER_EXT_LEN];//头像扩展名
    [8] = DataSize.UInt16,
    [9] = DataSize.String,
    -- WORD wSign;//签名
    -- TCHAR szSign[SIGN_LEN];//签名
    [10] = DataSize.UInt16,
    [11] = DataSize.String,
}
--昨日盈利
SC_RankWin_Yesterday = {
    -- DWORD dwUser_Id;//用户ID
    [1] = DataSize.UInt32,
    -- WORD wNickName;//呢称
    -- TCHAR szNickName[NAME_LEN];//呢称
    [2] = DataSize.UInt16,
    [3] = DataSize.String,
    -- DWORD dwGold;//金币
    [4] = DataSize.UInt64,
    -- DWORD dwPrize;//奖券
    [5] = DataSize.UInt64,
    -- BYTE bySex;//性别
    [6] = DataSize.byte,
    -- bool bCustomHeader;//是否自定义头像
    [7] = DataSize.byte,
    -- WORD wHeaderExtensionName;//头像扩展名
    -- TCHAR szHeaderExtensionName[HEADER_EXT_LEN];//头像扩展名
    [8] = DataSize.UInt16,
    [9] = DataSize.String,
    -- WORD wSign;//签名
    -- TCHAR szSign[SIGN_LEN];//签名
    [10] = DataSize.UInt16,
    [11] = DataSize.String,
    --昨日盈利
    [12] = DataSize.UInt64,
}
-- 活动中心
SC_ActivityCore = {
    -- DWORD ActivityCore_Id;//活动中心ID
    [1] = DataSize.UInt32,
    -- WORD wTitle;//标题
    -- TCHAR szTitle[NORMAL_LEN];//标题
    [2] = DataSize.UInt16,
    [3] = DataSize.String,
    -- WORD wRemark;//备注
    -- TCHAR szRemark[NORMAL_LEN];//备注
    [4] = DataSize.UInt16,
    [5] = DataSize.String,
    -- SYSTEMTIME startTime;//开始时间
    -- wYear
    [6] = DataSize.UInt16,
    -- wMonth
    [7] = DataSize.UInt16,
    -- wDayOfWeek
    [8] = DataSize.UInt16,
    -- wDay
    [9] = DataSize.UInt16,
    -- wHour
    [10] = DataSize.UInt16,
    -- wMinute
    [11] = DataSize.UInt16,
    -- wSecond
    [12] = DataSize.UInt16,
    -- wMilliseconds
    [13] = DataSize.UInt16,
    -- SYSTEMTIME stopTime;//结束时间
    -- wYear
    [14] = DataSize.UInt16,
    -- wMonth
    [15] = DataSize.UInt16,
    -- wDayOfWeek
    [16] = DataSize.UInt16,
    -- wDay
    [17] = DataSize.UInt16,
    -- wHour
    [18] = DataSize.UInt16,
    -- wMinute
    [19] = DataSize.UInt16,
    -- wSecond
    [20] = DataSize.UInt16,
    -- wMilliseconds
    [21] = DataSize.UInt16,
    -- WORD wImgUrl;//图片地址
    -- TCHAR szImgUrl[NORMAL_LEN];//图片地址
    [22] = DataSize.UInt16,
    [23] = DataSize.String,
}

--活动邮件
SC_ActivityMail = {
    -- DWORD Mail_Id;//邮件ID
    [1] = DataSize.UInt64,
    -- WORD wTitle;//标题
    -- TCHAR szTitle[NORMAL_LEN];//标题
    [2] = DataSize.UInt16,
    [3] = DataSize.String,
    -- WORD wRemark;//备注
    -- TCHAR szRemark[NORMAL_LEN];//备注
    [4] = DataSize.UInt16,
    [5] = DataSize.String,
    -- INT64 i64Gold;//金币 0不需要领取
    -- wYear
    [6] = DataSize.UInt64,
    -- SYSTEMTIME sendTime;//发送时间
    -- wMonth
    [7] = DataSize.UInt16,
    -- wDayOfWeek
    [8] = DataSize.UInt16,
    -- wDay
    [9] = DataSize.UInt16,
    -- wHour
    [10] = DataSize.UInt16,
    -- wMinute
    [11] = DataSize.UInt16,
    -- wSecond
    [12] = DataSize.UInt16,
    -- wMilliseconds
    [13] = DataSize.UInt16,
    -- SYSTEMTIME getTime;//领取时间
    -- wYear
    [14] = DataSize.UInt16,
    -- wMonth
    [15] = DataSize.UInt16,
    -- wDayOfWeek
    [16] = DataSize.UInt16,
    -- wDay
    [17] = DataSize.UInt16,
    -- wHour
    [18] = DataSize.UInt16,
    -- wMinute
    [19] = DataSize.UInt16,
    -- wSecond
    [20] = DataSize.UInt16,
    -- wMilliseconds
    [21] = DataSize.UInt16,
    [22] = DataSize.UInt16,
    -- 昨天 0未领取 1 已经领取
    [23] = DataSize.byte,
}

--活动邮件-领取
CS_ActivityMail = {
    --DWORD dwStartPos;//开始位置 从 0 开始
    [1] = DataSize.UInt32,
    --DWORD dwAmount;//数量 1 到 100
    [2] = DataSize.UInt32,
}

-- 接受聊天
CMD_3D_SC_ChatRoom_Chat = {
    -- WORD wKindID,--0表示世界 客户端无用,但是必须读出占位
    [1] = DataSize.UInt16,
    -- DWORD dwUser_Id,--0用户ID
    [2] = DataSize.UInt32,
    -- WORD wNickName,--0呢称
    [3] = DataSize.UInt16,
    -- TCHAR szNickName[NAME_LEN],--0呢称
    [4] = DataSize.String,
    -- BYTE bySex,--0性别
    [5] = DataSize.byte,
    -- bool bCustomHeader,--0是否自定义头像
    [6] = DataSize.byte,
    -- WORD wHeaderExtensionName,--0头像扩展名
    [7] = DataSize.UInt16,
    -- TCHAR szHeaderExtensionName[HEADER_EXT_LEN],--0头像扩展名
    [8] = DataSize.String,
    -- WORD wSign,--0签名
    [9] = DataSize.UInt16,
    -- TCHAR szSign[SIGN_LEN],--0签名
    [10] = DataSize.String,
    -- DWORD dwGold,--0金币
    [11] = DataSize.UInt64,
    -- DWORD dwPrize,--0奖券
    [12] = DataSize.UInt64,
    -- WORD wChatMsg,--0聊天内容
    [13] = DataSize.UInt16,
    -- TCHAR szChatMsg[NORMAL_LEN],--0聊天内容
    [14] = DataSize.String,
}

-- 接受游戏中聊天
SUB_3D_SC_SEND_CHAT = {
    -- WORD wKindID,--0表示世界 客户端无用,但是必须读出占位
    [1] = DataSize.UInt16,
    -- DWORD dwUser_Id,--0用户ID
    [2] = DataSize.UInt32,
    -- WORD wNickName,--0呢称
    [3] = DataSize.UInt16,
    -- TCHAR szNickName[NAME_LEN],--0呢称
    [4] = DataSize.String,
    -- BYTE bySex,--0性别
    [5] = DataSize.byte,
    -- bool bCustomHeader,--0是否自定义头像
    [6] = DataSize.byte,
    -- WORD wHeaderExtensionName,--0头像扩展名
    [7] = DataSize.UInt16,
    -- TCHAR szHeaderExtensionName[HEADER_EXT_LEN],--0头像扩展名
    [8] = DataSize.String,
    -- WORD wSign,--0签名
    [9] = DataSize.UInt16,
    -- TCHAR szSign[SIGN_LEN],--0签名
    [10] = DataSize.String,
    -- DWORD dwGold,--0金币
    [11] = DataSize.UInt64,
    -- DWORD dwPrize,--0奖券
    [12] = DataSize.UInt64,
    -- WORD wChatMsg,--0聊天内容
    [13] = DataSize.UInt16,
    -- TCHAR szChatMsg[NORMAL_LEN],--0聊天内容
    [14] = DataSize.String,
}
-- 充值列表
SC_RecharegeList = {
    -- DWORD dwBuy_Id;//购买ID
    [1] = DataSize.UInt32,
    -- WORD wIOS_Product_Id;//IOS产品ID
    [2] = DataSize.UInt16,
    -- TCHAR szIOS_Product_Id[NORMAL_LEN];//IOS产品ID
    [3] = DataSize.String,
    -- DWORD dwGold;//金币
    [4] = DataSize.UInt32,
    -- DWORD dwPayRMB;//人民币
    [5] = DataSize.UInt32,
}
-- APPStore
CS_RecharegeAppstore = {
    [1] = DataSize.StringAppStore,
}
-- 发送表情
CS_SendSign = {
    -- 表情索引，客户端自己定义，服务器只作转发
    [1] = DataSize.byte,
}
-- 发送动作
CS_SendAction = {
    -- 动作索引，客户端自己定义，服务器只作转发
    [1] = DataSize.byte,
}
-- 发送聊天
CS_SendChat = {
    -- 聊天内容 以实际大小发送 必须在 1 到 NORMAL_LEN(100) 字节之间

}
-- 发送桌子
SC_SendSign = {
    -- 桌子号
    [1] = DataSize.UInt16,
    -- 表情索引，客户端自己定义，服务器只作转发
    [2] = DataSize.byte,
}
-- 发送动作
SC_SendSign = {
    -- 桌子号
    [1] = DataSize.UInt16,
    -- 动作索引，客户端自己定义，服务器只作转发
    [2] = DataSize.byte,
}
-- 发送查询用户
CS_UserInfoSelect = {
    [1] = DataSize.UInt32,
    [2] = DataSize.byte, --那个窗口发出的消息
}
-- 接受查询用户信息
SC_UserInfoSelect = {
    -- DWORD dwUser_Id,--用户ID
    [1] = DataSize.byte,
    [2] = DataSize.UInt32,
    [3] = DataSize.UInt32,
    -- WORD wNickName,--0呢称
    [4] = DataSize.UInt16,
    -- TCHAR szNickName[NAME_LEN],--0呢称
    [5] = DataSize.String,
    -- BYTE bySex,--0性别
    [6] = DataSize.byte,
    -- bool bCustomHeader,--0是否自定义头像
    [7] = DataSize.byte,
    -- WORD wHeaderExtensionName,--0头像扩展名
    [8] = DataSize.UInt16,
    -- TCHAR szHeaderExtensionName[HEADER_EXT_LEN],--0头像扩展名
    [9] = DataSize.String,
    -- WORD wSign,--0签名
    [10] = DataSize.UInt16,
    -- TCHAR szSign[SIGN_LEN],--0签名
    [11] = DataSize.String,
    -- DWORD dwGold,--0金币
    [12] = DataSize.UInt16,
    [13] = DataSize.String,
    -- DWORD dwPrize,--0奖券
    [14] = DataSize.UInt32,
    -- BYTE byFloorID;//楼层ID		离线(0 == byFloorID)
    [15] = DataSize.byte,
    -- WORD wGameID;//游戏ID		在大厅(0 != byFloorID && 0 == wGameID)
    [16] = DataSize.UInt16,
    -- WORD wRoomID;//房间ID		在游戏(0 != byFloorID && 0 != wGameID && 0 != wRoomID)
    [17] = DataSize.UInt16,
    [18] = DataSize.byte, --那个窗口发出的消息
}
-- 通告信息
SC_NotifyInfo = {
    -- 玩家或者系统信息 true:玩家信息，false:系统信息
    [1] = DataSize.byte,
    -- /显示次数 = INVALID_BYTE 持续显示
    [2] = DataSize.byte,
    -- 是否重要
    [3] = DataSize.byte,
    -- 信息长度
    [4] = DataSize.UInt16,
    -- 具体信息
    [5] = DataSize.String,

}

SC_Dancer = {
    -- 舞者ID
    [1] = DataSize.UInt32,
    -- DWORD dwGold;//金币
    [2] = DataSize.UInt32,
    -- BYTE byGrade;//等级 1：低级，2：高级
    [3] = DataSize.byte,
    -- DWORD dwPlayingTime;//跳舞时间
    [4] = DataSize.UInt32,
}

-- 点舞
CS_Dancer_Request = {
    -- DWORD dwDancer_Id;//舞者ID
    [1] = DataSize.UInt32,
    -- TCHAR szMsg[NORMAL_LEN];//信息
    [2] = DataSize.String100,

}
-- 点舞成功
SC_Dancer_Request_Success = {
    -- bool bSuccess;//是否成功
    [1] = DataSize.byte,
    -- WORD wErrMsg;//错误信息
    -- [2]=DataSize.UInt16,
    -- TCHAR szErrMsg[NORMAL_LEN];//错误信息 只有在失败 时才能读取此值
    -- [3]=DataSize.String,
    -- DWORD dwFrontCount;//前面个数 只有在成功时才能读取此值，0表示你就是NO1
    [2] = DataSize.UInt32,
}
-- 点舞失败
SC_Dancer_Request_Fail = {
    -- bool bSuccess;//是否成功
    [1] = DataSize.byte,
    -- WORD wErrMsg;//错误信息
    [2] = DataSize.UInt16,
    -- TCHAR szErrMsg[NORMAL_LEN];//错误信息 只有在失败 时才能读取此值
    [3] = DataSize.String,
    -- DWORD dwFrontCount;//前面个数 只有在成功时才能读取此值，0表示你就是NO1
    -- [4]=DataSize.UInt32,
}
-- 点舞通告
SC_Dancer_Request_Notify = {
    -- DWORD dwDancer_Id;//舞者ID
    [1] = DataSize.UInt32,
    -- DWORD dwStartAction_Id;//随机动作ID(1到INVALID_DWORD) 假设当前舞者总动作数为A，则客户端当前动作ID = A / (INVALID_DWORD / dwStartAction_Id)
    [2] = DataSize.UInt32,
    -- WORD wNickName;//昵称
    [3] = DataSize.UInt16,
    -- TCHAR szNickName[NORMAL_LEN];//昵称
    [4] = DataSize.String,
    -- WORD wMsg;//信息
    [5] = DataSize.UInt16,
    -- TCHAR szMsg[NORMAL_LEN];//信息
    [6] = DataSize.String,
    -- DWORD dwPlayingTime_Start;//跳舞时间_开始 客户端不用此值,但必须读取占位
    [7] = DataSize.UInt32,
    -- DWORD dwPlayingTime_Pass;//跳舞时间_已经经过时间
    [8] = DataSize.UInt32,
    -- DWORD dwPlayingTime_Total;//跳舞时间_总时间
    [9] = DataSize.UInt32,
}
-- 玩家新手引导
SC_UserNewHand = {
    -- 新手引导ID
    [1] = DataSize.UInt32,
}
-- 玩家新手引导_完成
CS_UserNewHand_Finish = {
    -- 新手引导ID
    [1] = DataSize.UInt32,
}
-- 每日数据清理
SC_EverydayClearData = {
    -- 应该领取的时间ID
    [1] = DataSize.UInt32,
    -- 已经在线时间
    [2] = DataSize.UInt32,
    -- 已经抽奖次数
    [3] = DataSize.UInt32,
    -- 是否完成每日对战
    [4] = DataSize.byte,
    -- 已经分享天数
    [5] = DataSize.byte,
    -- 是否今天已经领取
    [6] = DataSize.byte,
    --DWORD dwShouldGet_Alms_Id;//应该领取的时间ID 等于INVALID_DWORD表示今天的救济金已经领取完成
    [7] = DataSize.UInt32,
    --DWORD dwAlmsGetLeftTime;//救济金领取剩余时间 等于INVALID_DWORD表示今天的救济金已经领取完成
    [8] = DataSize.UInt32,

}

CS_USER_VIP_SELECT = {
    [1] = DataSize.UInt32,
}

CS_USER_VIP_SELECT_Ten = {
    [1] = DataSize.UInt32,
    [2] = DataSize.UInt32,
    [3] = DataSize.UInt32,
    [4] = DataSize.UInt32,
    [5] = DataSize.UInt32,
    [6] = DataSize.UInt32,
    [7] = DataSize.UInt32,
    [8] = DataSize.UInt32,
    [9] = DataSize.UInt32,
    [10] = DataSize.UInt32,
    [11] = DataSize.UInt32,
    [12] = DataSize.UInt32,
    [13] = DataSize.UInt32,
    [14] = DataSize.UInt32,
    [15] = DataSize.UInt32,
    [16] = DataSize.UInt32,
    [17] = DataSize.UInt32,
    [18] = DataSize.UInt32,
    [19] = DataSize.UInt32,
    [20] = DataSize.UInt32,
    [21] = DataSize.UInt32,
    [22] = DataSize.UInt32,
    [23] = DataSize.UInt32,
    [24] = DataSize.UInt32,
    [25] = DataSize.UInt32,
    [26] = DataSize.UInt32,
    [27] = DataSize.UInt32,
    [28] = DataSize.UInt32,
    [29] = DataSize.UInt32,
    [30] = DataSize.UInt32,
    [31] = DataSize.UInt32,
    [32] = DataSize.UInt32,
    [33] = DataSize.UInt32,
    [34] = DataSize.UInt32,
    [35] = DataSize.UInt32,
    [36] = DataSize.UInt32,
    [37] = DataSize.UInt32,
    [38] = DataSize.UInt32,
    [39] = DataSize.UInt32,
    [40] = DataSize.UInt32,
    [41] = DataSize.UInt32,
    [42] = DataSize.UInt32,
    [43] = DataSize.UInt32,
    [44] = DataSize.UInt32,
    [45] = DataSize.UInt32,
    [46] = DataSize.UInt32,
    [47] = DataSize.UInt32,
    [48] = DataSize.UInt32,
    [49] = DataSize.UInt32,
    [50] = DataSize.UInt32,


}
-- //下载游戏资源
CMD_3D_SC_DownResourceGame = {
    -- DWORD dwGame_Id;//游戏ID
    [1] = DataSize.UInt32,
}
-- //下载游戏资源_完成
CMD_3D_CS_DownResouceGame_Finish = {
    -- DWORD dwGame_Id;//游戏ID
    [1] = DataSize.UInt32,
}

--游戏中每张桌子上的用户数据结构
CMD_3D_Table_UserData = {
    [1] = DataSize.UInt32,
    [2] = DataSize.UInt16,
    [3] = DataSize.String,
    [4] = DataSize.byte,
    [5] = DataSize.byte,
    [6] = DataSize.UInt16,
    [7] = DataSize.String,
    [8] = DataSize.UInt16,
    [9] = DataSize.String,
    [10] = DataSize.UInt64,
    [11] = DataSize.UInt32,
    [12] = DataSize.UInt16,
    [13] = DataSize.UInt16,
    [14] = DataSize.byte,
}
--游戏配置信息
CMD_GF_Option = {
    [1] = DataSize.byte;
    [2] = DataSize.byte;
}

--保险箱存入
CMD_3D_CS_StrongBox_Save = {
    [1] = DataSize.UInt32;
}
--保险箱取出
CMD_3D_CS_StrongBox_Get = {
    --DWORD dwAmount;
    [1] = DataSize.UInt32;
    --TCHAR szStrongBoxPassword[PASS_LEN*2];//保险箱密码
    [2] = DataSize.String33,
};
--保险箱--取出
CMD_3D_SC_StrongBox_Get = {
    --BYTE byLeftErrorCount;//剩余错误次数 0表示取款成功，INVALID_BYTE 表示输入错误次数达最大次数将封号
    [1] = DataSize.byte;
};
--//保险箱——设置密码
CMD_3D_CS_StrongBox_SetPassword = {
    --TCHAR szStrongBoxPassword[PASS_LEN*2];//保险箱密码
    [1] = DataSize.String33,
};
--进入保险箱
CMD_3D_CS_StrongBoxComeIn = {
    --TCHAR szStrongBoxPassword[PASS_LEN*2];//保险箱密码
    [1] = DataSize.String33,
};
--服务器返回进入保险箱
CMD_3D_SC_StrongBoxComeIn = {
    --BYTE byLeftErrorCount;//剩余错误次数 0表示取款成功，INVALID_BYTE 表示输入错误次数达最大次数将封号
    [1] = DataSize.byte;
}
--免费金币列表
SC_FreeGoldList = {
    --DWORD dwTask_Id;//任务ID
    [1] = DataSize.UInt32;
    --WORD wTitle;//标题
    [2] = DataSize.UInt16;
    --TCHAR szTitle[NORMAL_LEN];//标题
    [3] = DataSize.String;
    --WORD wRemark;//备注
    [4] = DataSize.UInt16;
    --TCHAR szRemark[NORMAL_PACK_LEN];//备注
    [5] = DataSize.String;
};

--通知修改用户信息
CMD_3D_SC_NotifyChangeUserInfo = {
    --BYTE byChangeType;//1ID 2昵称 3签名
    [1] = DataSize.byte;
    --DWORD dwID;//ID   byChangeType只有等于1时才能取
    [2] = DataSize.UInt32;
    --WORD wRemark;//备注
    [3] = DataSize.UInt16;
    --TCHAR szRemark[NORMAL_PACK_LEN];//信息
    [4] = DataSize.String;
};

---最新聊天
CHAT_CMD_SC_RecvInfo = {

};