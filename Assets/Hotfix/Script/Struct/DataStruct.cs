namespace Hotfix
{
    public partial class DataStruct
    {
        public class ServerHeart
        {
            public const ushort MDM_3D_HEART = 0;
            public const ushort SUB_3D_CS_HEART = 1;
            public const ushort SUB_3D_SC_HEART = 1;
        }
        //充值32

        public class RechargeStruct{
            public const ushort  MDM_3D_WEB_RECHARGE = 32;
            
            public const ushort C2S_RECHARGE_RECORD	=1;	//充值打点
            public const ushort S2C_RECHARGE_RESP=2;	//返回打点数据
            public const ushort C2S_DOT_DATA	=3;	//打点数据统计
            
        }


        /// <summary>
        ///     登录 20
        /// </summary>
        public class LoginStruct
        {
            /// <summary>
            ///     登录
            /// </summary>
            public const ushort MDM_3D_LOGIN = 20;

            #region REQ

            /// <summary>
            ///     版本
            /// </summary>
            public const ushort SUB_3D_CS_VERSION = 0;

            /// <summary>
            ///     验证码
            /// </summary>
            public const ushort SUB_3D_CS_CODE = 1;

            /// <summary>
            ///     注册
            /// </summary>
            public const ushort SUB_3D_CS_REGISTER = 15;

            /// <summary>
            ///     登录
            /// </summary>
            public const ushort SUB_3D_CS_LOGIN = 3;

            /// <summary>
            ///     注销
            /// </summary>
            public const ushort SUB_3D_CS_LOGOUT = 4;

            /// <summary>
            ///     用户设置
            /// </summary>
            public const ushort SUB_3D_CS_USER_SET = 5;

            /// <summary>
            ///     用户申请房间列表
            /// </summary>
            public const ushort SUB_3D_CS_REQ_SERVER_LIST = 6;

            /// <summary>
            ///     检查账号
            /// </summary>
            public const ushort SUB_3D_CS_REQ_CHECK_ACCOUNT = 7;

            /// <summary>
            ///     申请救济金数据
            /// </summary>
            public const ushort SUB_3D_CS_REQ_SAVEGOLDDATA = 8;

            /// <summary>
            ///     找回密码验证码
            /// </summary>
            public const ushort SUB_3D_SC_RESET_PASSWORD_CODE = 10;

            /// <summary>
            ///     请求修改用户密码
            /// </summary>
            public const ushort SUB_CS_REQ_MODIFY_USER_PASSWD = 19;

            /// <summary>
            ///     请求验证码
            /// </summary>
            public const ushort SUB_CS_REQ_MODIFY_USER_PASSWD_CHECK_CODE = 22;

            /// <summary>
            ///     注册验证码
            /// </summary>
            public const ushort SUB_3D_CS_RESIGER_CODE = 28;

            /// <summary>
            ///     请求验证码
            /// </summary>
            public const ushort SUB_3D_SC_DOWN_GAME_RESOURCE = 29;

            /// <summary>
            ///     登陆验证
            /// </summary>
            public const ushort SUB_3D_CS_CODE_LOGIN_VERIFY = 30;

            #endregion

            #region ACP

            /// <summary>
            ///     版本
            /// </summary>
            public const ushort SUB_3D_SC_VERSION = 0;

            /// <summary>
            ///     验证码
            /// </summary>
            public const ushort SUB_3D_SC_CODE = 1;

            /// <summary>
            ///     注册 数据大小为0时表示注册成功，否则取字符串看错误原因
            /// </summary>
            public const ushort SUB_3D_SC_REGISTER = 2;

            /// <summary>
            ///     登录失败	直接取字符串看错误原因
            /// </summary>
            public const ushort SUB_3D_SC_LOGIN_FAILE = 3;

            /// <summary>
            ///     系统信息
            /// </summary>
            public const ushort SUB_3D_SC_SYSTEM_INFO = 4;

            /// <summary>
            ///     房间信息
            /// </summary>
            public const ushort SUB_3D_SC_ROOM_INFO = 5;

            /// <summary>
            ///     登录成功
            /// </summary>
            public const ushort SUB_3D_SC_LOGIN_SUCCESS = 6;

            /// <summary>
            ///     注销
            /// </summary>
            public const ushort SUB_3D_SC_LOGOUT = 7;

            /// <summary>
            ///     账号被挤下
            /// </summary>
            public const ushort SUB_3D_SC_ACCOUNT_OFFLINE = 8;

            /// <summary>
            ///     用户设置
            /// </summary>
            public const ushort SUB_3D_SC_USER_SET = 9;

            /// <summary>
            ///     界面信息
            /// </summary>
            public const ushort SUB_3D_SC_UI_SWITCH = 10;

            /// <summary>
            ///     账号检查结果处理
            /// </summary>
            public const ushort SUB_3D_SC_CHECK_ACCOUNT_RESULT = 11;

            /// <summary>
            ///     房间列表开始
            /// </summary>
            public const ushort SUB_3D_SC_ROOM_INFO_BEGIN = 12;

            /// <summary>
            ///     房间列表结束
            /// </summary>
            public const ushort SUB_3D_SC_ROOM_INFO_END = 13;

            /// <summary>
            ///     救济金数据更新
            /// </summary>
            public const ushort SUB_2D_SC_SAVEGOLDDATA = 14;

            /// <summary>
            ///     请求最近五条建议
            /// </summary>
            public const ushort SUB_REQUEST_RECENTLY_SUGGESION = 15;

            /// <summary>
            ///     回复客户端五条建议
            /// </summary>
            public const ushort SUB_RESPONSE_RECENTLY_SUGGESITON = 16;

            /// <summary>
            ///     发送标识位
            /// </summary>
            public const ushort SUB_RESPONSE_RECENTLY_SUGGESTION_STAR = 17;

            /// <summary>
            ///     结束
            /// </summary>
            public const ushort SUB_RESPONSE_RECENTLY_SUGGESTION_END = 18;

            /// <summary>
            ///     修改密码成功结果, 收到空数据位成功，错误请看具体字符串
            /// </summary>
            public const ushort SUB_SC_RES_MODIFY_USER_PASSWD_RESULT = 20;

            /// <summary>
            ///     给客户端验证码
            /// </summary>
            public const ushort SUB_SC_RES_MODIFY_USER_PASSWD_CHECK_CODE = 23;

            /// <summary>
            ///     用户名或者密码错误
            /// </summary>
            public const ushort SUB_SC_LOGIN_PASSWD_OR_USERNAME_ERROR = 24;

            /// <summary>
            ///     客户端状态
            /// </summary>
            public const ushort SUB_SC_LOGIN_CLIENT_STAUS = 25;

            /// <summary>
            ///     游戏版本号
            /// </summary>
            public const ushort SUB_SC_LOGIN_ROOM_VESION = 26;

            /// <summary>
            ///     兑换成功消息包
            /// </summary>
            public const ushort SUB_SC_RES_REDEEMSUCC_MSG = 27;

            /// <summary>
            ///     需要登录验证
            /// </summary>
            public const ushort SUB_3D_SC_LOGIN_CODE_RESULT = 31;

            #endregion
        }

        /// <summary>
        ///     个人信息 21
        /// </summary>
        public partial class PersonalStruct
        {
            /// <summary>
            ///     个人信息
            /// </summary>
            public const ushort MDM_3D_PERSONAL_INFO = 21;

            #region REQ

            /// <summary>
            ///     修改密码
            /// </summary>
            public const ushort SUB_3D_CS_CHANGE_PASSWORD = 0;

            /// <summary>
            ///     修改呢称
            /// </summary>
            public const ushort SUB_3D_CS_CHANGE_NICKNAME = 1;

            /// <summary>
            ///     修改账号
            /// </summary>
            public const ushort SUB_3D_CS_CHANGE_ACCOUNT = 2;

            /// <summary>
            ///     修改签名
            /// </summary>
            public const ushort SUB_3D_CS_CHANGE_SIGN = 3;

            /// <summary>
            ///     用户信息——查询
            /// </summary>
            public const ushort SUB_3D_CS_USER_INFO_SELECT = 4;

            /// <summary>
            ///     玩家新手引导_完成
            /// </summary>
            public const ushort SUB_3D_CS_USER_NEW_HAND_FINISH = 5;

            /// <summary>
            ///     充值
            /// </summary>
            public const ushort SUB_3D_CS_BUY = 6;

            /// <summary>
            ///     头像配置
            /// </summary>
            public const ushort SUB_3D_CS_GET_HEAD_INFO = 7;

            /// <summary>
            ///     购买头像
            /// </summary>
            public const ushort SUB_3D_CS_BUY_HEAD = 8;

            /// <summary>
            ///     修改用户账号和密码
            /// </summary>
            public const ushort SUB_3D_CS_CHANGE_ACCOUNT_AND_PASSWD = 11;

            /// <summary>
            ///     修改成功
            /// </summary>
            public const ushort SUB_3D_CS_CHANGE_ACCOUTN_AND_PASSWD_RESULT = 12;

            /// <summary>
            ///     购买头像结果
            /// </summary>
            public const ushort SUB_3D_CS_BUY_HEAD_RESULT = 14;

            /// <summary>
            ///     修改 绑定账号时 自动启动登录
            /// </summary>
            public const ushort SUB_3D_CS_CHANGE_ACCOUNT_RegisterS = 15;

            /// <summary>
            ///     打开银行
            /// </summary>
            public const ushort SUB_3D_CS_OPEN_BANK = 20;

            /// <summary>
            ///     查询玩家金币信息
            /// </summary>
            public const ushort SUB_3D_CS_SELECT_GOLD_MSG = 21;

            /// <summary>
            ///     查询登录验证状态
            /// </summary>
            public const ushort SUB_3D_CS_LOGINVERIFY = 23;

            /// <summary>
            ///     绑定支付宝帐号
            /// </summary>
            public const ushort SUB_3D_CS_ChangeHeader = 25;

            /// <summary>
            ///     绑定银行卡
            /// </summary>
            public const ushort SUB_3D_CS_QUERY_UP_SCORE_RECORD = 27;

            /// <summary>
            ///     修改头像
            /// </summary>
            public const ushort SUB_3D_CS_CHANGE_AVATAR = 29;

            public const ushort SUB_3D_CS_DIANKA_QUERY = 32; //点卡查询

            public const ushort SUB_3D_CS_DIANKA_GIVE = 34; //点卡赠送

            public const ushort SUB_3D_CS_DIANKA_RECEIVE = 36; //点卡领取

            public const ushort SUB_3D_CS_QueryChangBindlimits = 38; //解绑查询权限

            public const ushort SUB_3D_CS_ChangVipBindUserId = 40; //解绑修改

            public const ushort SUB_3D_CS_QueryTurntableData = 42;//查询转盘数据

            public const ushort SUB_3D_CS_TurntableRotation=   44;// 转动转盘


            public const ushort SUB_3D_CS_SignCheck=   48;// 签到查询

            public const ushort SUB_3D_CS_SignCheckBegin =52 ; //开始签到

            public const ushort SUB_3D_CS_CodeRebateQuery= 54;  //查询打码返利进度

            public const ushort SUB_3D_CS_CodeRebateBegin =56;//领取打码

            public const ushort SUB_3D_CS_OnlineRewardQuery =58;//在线奖励查询


            public const ushort SUB_3D_CS_OnlineRewardPick =60;//任务奖励领取

            #endregion

            #region ACP

            /// <summary>
            ///     用户道具
            /// </summary>
            public const ushort SUB_3D_SC_USER_PROP = 0;

            /// <summary>
            ///     修改密码 数据大小为0表示成功，否则直接取字符串看错误原因
            /// </summary>
            public const ushort SUB_3D_SC_CHANGE_PASSWORD = 1;

            /// <summary>
            ///     修改呢称 数据大小为0表示成功，否则直接取字符串看错误原因
            /// </summary>
            public const ushort SUB_3D_SC_CHANGE_NICKNAME = 2;

            /// <summary>
            ///     修改账号 数据大小为0表示成功，否则直接取字符串看错误原因
            /// </summary>
            public const ushort SUB_3D_SC_CHANGE_ACCOUNT = 3;

            /// <summary>
            ///     修改签名 数据大小为0表示成功，否则直接取字符串看错误原因
            /// </summary>
            public const ushort SUB_3D_SC_CHANGE_SIGN = 4;

            /// <summary>
            ///     用户信息——查询
            /// </summary>
            public const ushort SUB_3D_SC_USER_INFO_SELECT = 5;

            /// <summary>
            ///     玩家新手引导-开始
            /// </summary>
            public const ushort SUB_3D_SC_USER_NEW_HAND_START = 6;

            /// <summary>
            ///     玩家新手引导
            /// </summary>
            public const ushort SUB_3D_SC_USER_NEW_HAND = 7;

            /// <summary>
            ///     玩家新手引导-结束
            /// </summary>
            public const ushort SUB_3D_SC_USER_NEW_HAND_STOP = 8;

            /// <summary>
            ///     玩家新手引导_完成 数据大小为0表示成功，否则直接取字符串看错误原因
            /// </summary>
            public const ushort SUB_3D_SC_USER_NEW_HAND_FINISH = 9;

            /// <summary>
            ///     充值数据大小为0表示成功，否则直接取字符串看错误原因
            /// </summary>
            public const ushort SUB_3D_SC_USER_VIP_SELECT = 10;

            /// <summary>
            ///     保险箱--存入 数据大小为0表示成功
            /// </summary>
            public const ushort SUB_3D_SC_STRONG_SAVE = 11;

            /// <summary>
            ///     保险箱--取出
            /// </summary>
            public const ushort SUB_3D_SC_STRONG_GET = 12;

            /// <summary>
            ///     头像配置后获取用户输入的手机号 自动绑定
            /// </summary>
            public const ushort SUB_3D_SC_USER_FIRST_RECHARGE_START = 13;

            /// <summary>
            ///     玩家首充
            /// </summary>
            public const ushort SUB_3D_SC_USER_FIRST_RECHARGE = 14;

            /// <summary>
            ///     玩家首充——结束
            /// </summary>
            public const ushort SUB_3D_SC_USER_FIRST_RECHARGE_STOP = 15;

            /// <summary>
            ///     保险箱--设置密码，数据大小为0表示成功
            /// </summary>
            public const ushort SUB_3D_SC_STRONG_SET_PASSWORD = 16;

            /// <summary>
            ///     设置登录验证
            /// </summary>
            public const ushort SUB_3D_SC_SET_LOGIN_VALIDATE = 17;

            /// <summary>
            ///     进入保险箱
            /// </summary>
            public const ushort SUB_3D_SC_STRONG_BOX_COME_IN = 18;

            /// <summary>
            ///     通知、修改消息
            /// </summary>
            public const ushort SUB_3D_SC_NOTIFY_CHANGE_USER_INFO = 19;

            /// <summary>
            ///     查询玩家金币信息
            /// </summary>
            public const ushort SUB_3D_SC_SELECT_GOLD_MSG_RES = 22;

            /// <summary>
            ///     查询登录验证状态返回
            /// </summary>
            public const ushort SUB_3D_SC_QUERYLOGINVERIFY_RES = 24;

            /// <summary>
            ///     更改头像返回
            /// </summary>
            public const ushort SUB_3D_SC_ChangeHeader = 26;

            /// <summary>
            ///     查询玩家上下分记录返回
            /// </summary>
            public const ushort SUB_3D_SC_QUERY_UP_SCORE_RECORD = 28;

            /// <summary>
            ///     查询兑换码使用情况返回
            /// </summary>
            public const ushort SUB_3D_SC_QUERY_EXCHANGE_CODE = 30;

            /// <summary>
            ///     玩家金币
            /// </summary>
            public const ushort SUB_3D_SC_USER_GOLD = 31;

            public const ushort SUB_3D_SC_DIANKA_QUERY = 33; //点卡查询返回

            public const ushort SUB_3D_SC_DIANKA_GIVE = 35; //点卡赠送返回

            public const ushort SUB_3D_SC_DIANKA_RECEIVE = 37; //点卡领取返回

            public const ushort SUB_3D_SC_QueryChangBindlimits = 39; //字段为1 有权限 
            public const ushort SUB_3D_SC_ChangVipBindUserId = 41; //绑定商家结果

            public const ushort SUB_3D_SC_QueryTurntableDataRet = 43; //查询转盘数据返回

            public const ushort SUB_3D_SC_TurntableRotationRet= 45;//转动转盘返回


            public const ushort SUB_3D_SC_SignCheck =49;  //查询签到返回

            public const ushort SUB_3D_SC_SignCheckBegin =53; //签到结果
           

            public const ushort SUB_3D_SC_CodeRebateQuery =55; //打码进度

            public const ushort SUB_3D_SC_CodeRebateBegin =57; //领取打码

            public const ushort SUB_3D_SC_OnlineRewardQuery =59;//在线奖励查询

            public const ushort SUB_3D_SC_OnlineRewardPick =61;//在线奖励领取返回

            #endregion
            
            
            public const ushort SUB_3D_CS_SYNC_SERVER_TIME = 46; //查询服务器当前时间
            public const ushort SUB_3D_SC_SYNC_SERVER_TIME = 47; //查询服务器当前时间返回

            public const ushort SUB_3D_SC_GetPlayerGold = 62;//返回玩家当前金币
        }

        /// <summary>
        ///     聚宝盆 22
        /// </summary>
        public class GoldMineStruct
        {
            /// <summary>
            ///     聚宝盆
            /// </summary>
            public const ushort MDM_3D_GOLDMINE = 22;

            /// <summary>
            ///     礼品退回
            /// </summary>
            public const ushort PROP_BACK_TO = 2;

            #region REQ

            /// <summary>
            ///     金币对奖券
            /// </summary>
            public const ushort SUB_3D_CS_GOLD_TO_PRIZET = 0;

            /// <summary>
            ///     赠送金币
            /// </summary>
            public const ushort SUB_3D_CS_PRESENT_GOLDT = 1;

            /// <summary>
            ///     客户端请求记录数据
            /// </summary>
            public const ushort SUB_3D_CS_PRESENT_GOLD_RECORD = 2;

            /// <summary>
            ///     赠送金币领取
            /// </summary>
            public const ushort SUB_3D_CS_PRESENT_GOLD_GET = 3;

            /// <summary>
            ///     获赠道具列表
            /// </summary>
            public const ushort SUB_2D_CS_GIVE_RECORD_LIST = 5;

            /// <summary>
            ///     银行转账
            /// </summary>
            public const ushort SUB_3D_CS_TRANSFERACCOUNTS = 10;

            /// <summary>
            ///     撤回邮件
            /// </summary>
            public const ushort SUB_3D_CS_WITHDRAW = 13;

            #endregion

            #region ACP

            /// <summary>
            ///     金币兑换奖券 数据大小为0表示成功，否则直接取字符串看错误原因
            /// </summary>
            public const ushort SUB_3D_SC_GOLD_TO_PRIZE = 0;

            /// <summary>
            ///     赠送金币 数据大小为0表示成功，否则直接取字符串看错误原因
            /// </summary>
            public const ushort SUB_3D_SC_PRESENT_GOLDT = 1;

            /// <summary>
            ///     被赠送金币通知
            /// </summary>
            public const ushort SUB_3D_SC_PRESENT_GOLD_NOTIFY = 2;

            /// <summary>
            ///     服务器下发记录的开始
            /// </summary>
            public const ushort SUB_3D_SC_PRESENT_GOLD_RECORD_START = 3;

            /// <summary>
            ///     服务器下发每条数据
            /// </summary>
            public const ushort SUB_2D_SC_GIVE_RECORD_LIST = 4;

            /// <summary>
            ///     服务器下发数据完成
            /// </summary>
            public const ushort SUB_3D_SC_PRESENT_GOLD_RECORD_END = 5;

            /// <summary>
            ///     赠送金币领取
            /// </summary>
            public const ushort SUB_3D_SC_PRESENT_GOLD_GET = 6;

            /// <summary>
            ///     可领取个数
            /// </summary>
            public const ushort SUB_2D_SC_GIVE_RECORD_COUNT = 7;

            /// <summary>
            ///     退回礼品通知
            /// </summary>
            public const ushort SUB_2D_SC_BACK_PROP = 9;

            /// <summary>
            ///     银行转账返回
            /// </summary>
            public const ushort SUB_3D_SC_TRANSFERACCOUNTS = 11;

            /// <summary>
            ///     刷新赠送者金币
            /// </summary>
            public const ushort SUB_3D_SC_UPDATEBANKERSAVEGOLD = 12;

            /// <summary>
            ///     撤回邮件
            /// </summary>
            public const ushort SUB_3D_SC_WITHDRAW = 14;

            #endregion
        }

        public class ClientHallHeart
        {
            #region 心跳

            public const ushort MDM_3D_HEARTCOFIG = 29;
            public const ushort SUB_3D_CS_HEART = 1;
            public const ushort SUB_3D_SC_HEART = 2;

            #endregion
        }

        public class LoginGameStruct
        {
            #region 登录游戏

            /// <summary>
            ///     房间登录
            /// </summary>
            public const ushort MDM_GR_LOGON = 1;

            /// <summary>
            ///     ID登录
            /// </summary>
            public const ushort SUB_GR_LOGON_USERID = 2;

            /// <summary>
            ///     登录游戏
            /// </summary>
            public const ushort SUB_GR_LOGON_GAME = 3;

            /// <summary>
            ///     登录成功
            /// </summary>
            public const ushort SUB_GR_LOGON_SUCCESS = 100;

            /// <summary>
            ///     登录失败
            /// </summary>
            public const ushort SUB_GR_LOGON_ERROR = 101;

            /// <summary>
            ///     登录完成
            /// </summary>
            public const ushort SUB_GR_LOGON_FINISH = 102;

            #endregion
        }

        public class GameSceneStruct
        {
            #region 场景消息

            /// <summary>
            ///     场景消息
            /// </summary>
            public const ushort MDM_ScenInfo = 101;

            /// <summary>
            ///     游戏信息 客户端游戏场景准备好了，准备接收场景消息
            /// </summary>
            public const ushort SUB_GF_INFO = 1;

            /// <summary>
            ///     用户同意
            /// </summary>
            public const ushort SUB_GF_USER_READY = 2;

            /// <summary>
            ///     游戏配置
            /// </summary>
            public const ushort SUB_GF_OPTION = 100;

            /// <summary>
            ///     场景信息
            /// </summary>
            public const ushort SUB_GF_SCENE = 101;

            /// <summary>
            ///     系统消息
            /// </summary>
            public const ushort SUB_GF_MESSAGE = 300;

            #endregion
        }

        public class UserDestDataStruct
        {
            #region 桌子用户数据

            public const ushort MDM_3D_TABLE_USER_DATA = 300;

            /// <summary>
            ///     用户进入
            /// </summary>
            public const ushort SUB_3D_TABLE_USER_ENTER = 0;

            /// <summary>
            ///     用户离开
            /// </summary>
            public const ushort SUB_3D_TABLE_USER_LEAVE = 1;

            /// <summary>
            ///     用户状态
            /// </summary>
            public const ushort SUB_3D_TABLE_USER_STATUS = 2;

            /// <summary>
            ///     用户分数
            /// </summary>
            public const ushort SUB_3D_TABLE_USER_SCORE = 3;

            #endregion
        }

        public class GameLoginServerStruct
        {
            #region 登录服务器

            public const ushort MDM_SC_LOGIN_SERVER = 1;

            /// <summary>
            ///     登录服务器
            /// </summary>
            public const ushort SUB_CS_LOGIN_SERVER = 1;

            #endregion
        }

        public class UserDataStruct
        {
            #region 用户数据包定义

            /// <summary>
            ///     用户信息
            /// </summary>
            public const ushort MDM_GR_USER = 2;

            /// <summary>
            ///     离开游戏
            /// </summary>
            public const ushort SUB_GR_USER_LEFT_GAME_REQ = 4;

            /// <summary>
            ///     自动坐下（自动查找可坐位置坐下）
            /// </summary>
            public const ushort SUB_GR_USER_SIT_AUTO = 7;

            /// <summary>
            ///     用户进入
            /// </summary>
            public const ushort SUB_GR_USER_COME = 100;

            /// <summary>
            ///     用户状态
            /// </summary>
            public const ushort SUB_GR_USER_STATUS = 101;

            /// <summary>
            ///     用户分数
            /// </summary>
            public const ushort SUB_GR_USER_SCORE = 102;

            /// <summary>
            ///     坐下失败
            /// </summary>
            public const ushort SUB_GR_SIT_FAILED = 103;

            #endregion
        }

        public class AssistStruct
        {
            #region 助手（排行榜、活动公告、通告）

            /// <summary>
            ///     排行榜-金币
            /// </summary>
            public const ushort MDM_3D_ASSIST = 26;

            /// <summary>
            ///     活动中心
            /// </summary>
            public const ushort SUB_3D_CS_RANKTOP_GOLD = 0;

            /// <summary>
            ///     舞者信息
            /// </summary>
            public const ushort SUB_3D_CS_ACTIVITY_CORE = 1;

            /// <summary>
            ///     点舞
            /// </summary>
            public const ushort SUB_3D_CS_DANCER = 2;

            public const ushort SUB_3D_CS_DANCER_REQUEST = 3;

            /// <summary>
            ///     排行榜房间——查询
            /// </summary>
            public const ushort SUB_3D_CS_RANKROOM_GOLD_SELECT = 4;

            /// <summary>
            ///     检查客户端网络
            /// </summary>
            public const ushort SUB_3D_CS_CHECK_CLIENT_NETWORK = 5;

            /// <summary>
            ///     昨日盈利
            /// </summary>
            public const ushort SUB_3D_CS_RANKWIN_YESTERDAY = 6;

            /// <summary>
            ///     活动邮件
            /// </summary>
            public const ushort SUB_3D_CS_ACTIVITY_MAIL = 7;

            /// <summary>
            ///     活动邮件_领取
            /// </summary>
            public const ushort SUB_3D_CS_ACTIVITY_MAIL_GET = 8;

            /// <summary>
            ///     房间数据_查询
            /// </summary>
            public const ushort SUB_3D_CS_ROOM_DATA_SELECT = 9;

            /// <summary>
            ///     看过公告
            /// </summary>
            public const ushort SUB_3D_CS_LOOK_ACTIVITY_CORE = 10;

            /// <summary>
            ///     看过邮件
            /// </summary>
            public const ushort SUB_3D_CS_LOOK_ACTIVITY_MAIL = 11;

            /// <summary>
            ///     排行榜-金币-开始
            /// </summary>
            public const ushort SUB_3D_SC_RANKTOP_GOLD_START = 0;

            /// <summary>
            ///     排行榜-金币
            /// </summary>
            public const ushort SUB_3D_SC_RANKTOP_GOLD = 1;

            /// <summary>
            ///     排行榜-金币-结束
            /// </summary>
            public const ushort SUB_3D_SC_RANKTOP_GOLD_STOP = 2;

            /// <summary>
            ///     活动中心-开始
            /// </summary>
            public const ushort SUB_3D_SC_ACTIVITY_CORE_START = 3;

            /// <summary>
            ///     活动中心
            /// </summary>
            public const ushort SUB_3D_SC_ACTIVITY_CORE = 4;

            /// <summary>
            ///     活动中心-结束
            /// </summary>
            public const ushort SUB_3D_SC_ACTIVITY_CORE_STOP = 5;

            /// <summary>
            ///     通知信息
            /// </summary>
            public const ushort SUB_3D_SC_NOTIFY_INFO = 6;

            /// <summary>
            ///     每日清理数据 应该领取的时间ID为最小的时间ID，已经在线时间为0，已经抽奖次数为0，是否完成每日对战为false
            /// </summary>
            public const ushort SUB_3D_SC_EVERYDAY_CLEAR_DATA = 7;

            /// <summary>
            ///     舞者开始
            /// </summary>
            public const ushort SUB_3D_SC_DANCER_START = 8;

            /// <summary>
            ///     舞者
            /// </summary>
            public const ushort SUB_3D_SC_DANCER = 9;

            /// <summary>
            ///     舞者结束
            /// </summary>
            public const ushort SUB_3D_SC_DANCER_STOP = 10;

            /// <summary>
            ///     点舞 数据大小为0表示成功，否则直接取字符串看错误原因
            /// </summary>
            public const ushort SUB_3D_SC_DANCER_REQUEST = 11;

            /// <summary>
            ///     点舞_通告
            /// </summary>
            public const ushort SUB_3D_SC_DANCER_REQUEST_NOTITY = 12;

            /// <summary>
            ///     排行榜房间——查询-开始
            /// </summary>
            public const ushort SUB_3D_SC_RANKROOM_GOLD_SELECT_START = 13;

            /// <summary>
            ///     排行榜房间——查询
            /// </summary>
            public const ushort SUB_3D_SC_RANKROOM_GOLD_SELECT = 14;

            /// <summary>
            ///     排行榜房间——查询-结束
            /// </summary>
            public const ushort SUB_3D_SC_RANKROOM_GOLD_SELECT_STOP = 15;

            /// <summary>
            ///     检查客户端网络
            /// </summary>
            public const ushort SUB_3D_SC_CHECK_CLIENT_NETWORK = 16;

            /// <summary>
            ///     昨日盈利-开始
            /// </summary>
            public const ushort SUB_3D_SC_RANKWIN_YESTERDAY_START = 17;

            /// <summary>
            ///     昨日盈利
            /// </summary>
            public const ushort SUB_3D_SC_RANKWIN_YESTERDAY = 18;

            /// <summary>
            /// </summary>
            public const ushort SUB_3D_SC_RANKWIN_YESTERDAY_STOP = 19;

            /// <summary>
            ///     活动邮件-开始
            /// </summary>
            public const ushort SUB_3D_SC_ACTIVITY_MAIL_START = 20;

            /// <summary>
            ///     活动邮件
            /// </summary>
            public const ushort SUB_3D_SC_ACTIVITY_MAIL = 21;

            /// <summary>
            ///     活动邮件-结束
            /// </summary>
            public const ushort SUB_3D_SC_ACTIVITY_MAIL_STOP = 22;

            /// <summary>
            ///     活动邮件_领取
            /// </summary>
            public const ushort SUB_3D_SC_ACTIVITY_MAIL_GET = 23;

            /// <summary>
            ///     房间数据_查询_开始
            /// </summary>
            public const ushort SUB_3D_SC_ROOM_DATA_SELECT_START = 24;

            /// <summary>
            ///     房间数据
            /// </summary>
            public const ushort SUB_3D_SC_ROOM_DATA_SELECT = 25;

            /// <summary>
            ///     房间数据_查询_结束
            /// </summary>
            public const ushort SUB_3D_SC_ROOM_DATA_SELECT_STOP = 26;

            /// <summary>
            ///     看过公告 没有数据 可以不处理
            /// </summary>
            public const ushort SUB_3D_SC_LOOK_ACTIVITY_CORE = 27;

            /// <summary>
            ///     看过邮件 没有数据 可以不处理
            /// </summary>
            public const ushort SUB_3D_SC_LOOK_ACTIVITY_MAIL = 28;

            /// <summary>
            ///     新邮件通知
            /// </summary>
            public const ushort SUB_3D_SC_NEW_ACTIVITY_MAIL = 29;

            #endregion
        }

        public class GameStruct
        {
            #region 游戏消息

            public const ushort MDM_GF_GAME = 100;

            #endregion
        }

        public class FrameStruct
        {
            #region 游戏框架消息

            /// <summary>
            ///     游戏框架信息
            /// </summary>
            public const ushort MDM_3D_FRAME = 301;

            /// <summary>
            ///     换桌
            /// </summary>
            public const ushort SUB_3D_CS_SWITCH_TABLE = 0;

            /// <summary>
            ///     发送表情
            /// </summary>
            public const ushort SUB_3D_CS_SEND_SIGN = 1;

            /// <summary>
            ///     发送动作
            /// </summary>
            public const ushort SUB_3D_CS_SEND_ACTION = 2;

            /// <summary>
            ///     发送聊天
            /// </summary>
            public const ushort SUB_3D_CS_SEND_CHAT = 3;

            /// <summary>
            ///     自动入座
            /// </summary>
            public const ushort SUB_3D_CS_AUTO_SIT = 4;

            /// <summary>
            ///     换桌 数据大小为0表示成功，否则直接取字符串看错误原因
            /// </summary>
            public const ushort SUB_3D_SC_SWITCH_TABLE = 0;

            /// <summary>
            ///     发送表情
            /// </summary>
            public const ushort SUB_3D_SC_SEND_SIGN = 1;

            /// <summary>
            ///     发送动作
            /// </summary>
            public const ushort SUB_3D_SC_SEND_ACTION = 2;

            /// <summary>
            ///     发送聊天
            /// </summary>
            public const ushort SUB_3D_SC_SEND_CHAT = 3;

            /// <summary>
            ///     自动入座 数据大小为0表示成功，否则直接取字符串看错误原因
            /// </summary>
            public const ushort SUB_3D_SC_AUTO_SIT = 4;

            /// <summary>
            ///     房间信息——断线 直接取字符串看信息
            /// </summary>
            public const ushort SUB_3D_SC_ROOM_INFO_OFFLINE = 6;

            /// <summary>
            ///     心跳
            /// </summary>
            public const ushort SUB_3D_CS_GAME_HEART = 5;

            public const ushort SUB_3D_SC_GAME_HEART = 11;

            #endregion
        }

        public class BankStruct
        {
            #region 银行

            public const ushort MDM_GP_USER = 4;
            public const ushort SUB_GP_BANKFRISTMODIFYPASS = 129;
            public const ushort SUB_GP_BANKOPENACCOUNTRESULT = 128;
            public const ushort SUB_GP_SETBANKPASSRESULT = 130;

            /// <summary>
            ///     银行存取  子消息号
            /// </summary>
            public const ushort SUB_GP_USER_BANK_OPERATE = 118;

            /// <summary>
            ///     银行获取验证码
            /// </summary>
            public const ushort SUB_GP_MODIFY_BANK_PASSWD_CHECK_CODE = 136;

            /// <summary>
            ///     查询
            /// </summary>
            public const ushort SUB_GP_USER_BANK_Query_RESULT = 133;

            /// <summary>
            ///     银行存取反馈
            /// </summary>
            public const ushort SUB_GP_USER_BANK_OPERATE_RESULT = 134;

            /// <summary>
            ///     更改银行密码消息
            /// </summary>
            public const ushort SUB_GP_MODIFY_BANK_PASSWD = 135;

            /// <summary>
            ///     修改银行密码反馈
            /// </summary>
            public const ushort SUB_GP_MODIFY_BANK_PASSWD_CHECK_CODE_RESULT = 137;

            #endregion
        }
    

    }
}