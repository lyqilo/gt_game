BaccaraMH={
--登陆游戏
CMD_GR_LogonByUserID=
{
    [1]=DataSize.UInt32,--广场版本，暂时不用
    [2]=DataSize.UInt32,--进程版本 ，暂时不用
    [3]=DataSize.UInt32, --用户ID
    [4]=DataSize.String33, --登录密码，MD5小写加密
    [5]=DataSize.String100,--机器码 暂时不用
    [6]=DataSize.byte, --补位
    [7]=DataSize.byte, --补位
},

--用户准备 客户端游戏场景准备好了，准备接收场景消息
CMD_GF_Info =
{
    -- public byte bAllowLookon; //旁观标志 必须等于0
    [1]=DataSize.byte,
},


--游戏状态
--洗牌
GAME_STATE_SHUFFLE_POKER=0,
--下注
GAME_STATE_CHIP=1,
--停止下注
 GAME_STATE_STOP_CHIP=2,
--发牌
GAME_STATE_SEND_POKER=3,
--//闲家眯牌
GAME_STATE_PEEKPOKER_X=4,
--//庄家眯牌
GAME_STATE_PEEKPOKER_Z=5,
--闲家补牌
GAME_STATE_PLAYER_ADD_POKER=6,
--眯牌_庄家_加
GAME_STATE_PEEKADDPOKER_Z=7,
--庄家补牌
GAME_STATE_BANKER_ADD_POKER=8,
--//眯牌_闲家_加
GAME_STATE_PEEKADDPOKER_X=9,
--游戏结束
GAME_STATE_GAME_OVER=10,
--游戏等待
GAME_STATE_GAME_WAIT=11,

---//时间长度
--//洗牌
TIMER_SHUFFLE_POKER = 5000,
--//下注
TIMER_CHIP=20,
--//停止下注
TIMER_STOP_CHIP=2000,
--//发牌
TIMER_SEND_POKER=4000,
--//眯牌
TIMER_PLAYER_ADD_POKER=15,
--//闲家补牌
--TIMER_PLAYER_ADD_POKER=2000,
--//庄家补牌
--TIMER_BANKER_ADD_POKER=2000,
--//游戏结束
--//游戏结束_有下注
TIMER_GAME_OVER_CHIP=7000,
--//游戏结束_无下注
TIMER_GAME_OVER_CHIP_ZERO=3000,
TIMER_GAME_OVER=5000,


D_SIT_PLAYER_COUNT = 5; --坐下玩家数量

---//扑克
--//每副牌数量
D_PRE_POKER_COUNT=52,
--//扑克副数量
D_POKER_PAIR_COUNT=8,
--//扑克总数量
D_POKER_TOTAL_COUNT=52*8,
--//洗牌轮数
D_SHUFFLE_POKER_WHEEL_COUNT=60,
--//头牌数量
D_HEADER_POKER_COUNT=2,
--//最大手牌数量
D_MAX_HANDER_POKER_COUNT=3,
--//点数个数
D_POINT_COUNT=10,

--//下注区域
--//闲对子
D_CHIP_ARAE_PLAYER_TWINS=0,
--//庄对子
D_CHIP_ARAE_BANKER_TWINS=1,
--//闲
D_CHIP_ARAE_PLAYER=3,
--//庄
D_CHIP_ARAE_BANKER=4,
--//和
D_CHIP_ARAE_EQUAL=5,
--//下注区域数
D_CHIP_ARAE_COUNT=5,

---//大小
--//闲大
D_BIG_OR_SMALL_PLAYER=0,
--//庄大
D_BIG_OR_SMALL_BANKER=1,
--//和
D_BIG_OR_SMALL_EQUAL=2,
--闲对大
D_BIG_OR_SMALL_PLAYER_COUPLE=3,
--庄对大
D_BIG_OR_SMALL_BANKER_COUPLE=4,
--一副牌
C_ONE_POKER_DATA={
    0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D,--// 黑桃 A ~ K
	0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19,0x1A,0x1B,0x1C,0x1D,--// 红桃 A ~ K
	0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D,--// 梅花 A ~ K
	0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C,0x3D --// 方块 A ~ K
},

--//游戏状态名称
C_GAME_STATE_NAME={"洗牌","下注","停止下注","发牌","闲家补牌","庄家补牌","游戏结束"},
--//区域名称
C_CHIP_AREA_NAME={"闲对","庄对","闲","庄","和"},
--//大小名称
C_BIG_OR_SMALL_NAME={"闲大","庄大","和","闲对大","庄对大"},
--//服务器消息
--//庄家信息
SUB_SC_BANKER_INFO=0,
--//上庄 数据大小为0表示成功，否则直接取字符串看错误原因
SUB_SC_REQUEST_BANKER=1,
--//下庄 数据大小为0表示成功，否则直接取字符串看错误原因
SUB_SC_LOSE_BANKER=2,
--//洗牌
SUB_SC_SHUFFLE_POKER=3,
--//开始下注
SUB_SC_BEGIN_CHIP=4,
--//更新下注值
SUB_SC_UPDATE_CHIP_VALUE=5,
--玩家下注
SUB_SC_PLAYER_CHIP=6,
--//下注失败 查看字符串获取失败原因
SUB_SC_CHIP_FAIL=7,
--//停止下注
SUB_SC_STOP_CHIP=8,
--//发牌
SUB_SC_SEND_POKER=9,
--//闲家补牌
SUB_SC_PLAYER_ADD_POKER=10,
--//庄家补牌
SUB_SC_BANKER_ADD_POKER=11,
--//游戏结束
SUB_SC_GAME_OVER=12,
--玩家成绩（总输赢分数）
SUB_SC_TOTAL_WIN_LOSE_SCORE=13,
--玩家坐下
SUB_SC_USER_SETDOWN=17,
--玩家起立
SUB_SC_USER_GETUP=18,
--玩家眯牌
SUB_SC_USER_PEEKPOKER_X=19,
--庄家眯牌
SUB_SC_USER_PEEKPOKER_Z=20,
--玩家眯牌广播
SUB_SC_USER_PEEKPOKER_BOATCAST=21,
--玩家眯加牌_庄家
SUB_SC_USER_PEEKADDPOKER_Z=22,
--玩家眯加牌_闲家
SUB_SC_USER_PEEKADDPOKER_X=23,
--玩家眯牌广播
SUB_SC_USER_PEEKADDPOKER_BOATCAST=24,

--客户端消息
--//闲家下注
SUB_CS_PLAYER_CHIP=0,
--//申请上庄
SUB_CS_REQUEST_BANKER=1,
--//申请下庄
SUB_CS_LOSE_BANKER=2,
--玩家坐下
SUB_CS_USER_SITDOWN=3,
--玩家起立
SUB_CS_USER_GETUP=4,
--玩家眯牌
SUB_CS_USER_PEEK=5,
--玩家眯牌确认
SUB_CS_USER_PEEK_STOP=6,
--玩家眯牌确认
SUB_CS_USER_PEEKADD_STOP=7;
--//闲家下注
CMD_CS_PLAYER_CHIP=
{
--	BYTE byChipAreaIndex;//下注区域索引
[1]=DataSize.byte,
--	DWORD dwChipValue;//下注值
[2]=DataSize.UInt32,
},
--庄家信息
BankerInfoTable={
_01wChair=655353,
_02Name="王小二",   
_03Gold=496871566,
_04WinOrLose=0,
_05Bankercount=0,
_06BankerAllCount=0,
},



-- MySelfInfo
mySelfInfo = {
    name = "",
    gold = 0,
    ticket = 0,
    score = 0,
    wchair=0,
},

}

