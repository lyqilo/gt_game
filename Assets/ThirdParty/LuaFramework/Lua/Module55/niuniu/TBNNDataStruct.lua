TBNNMH={

    --游戏IDf
    KIND_ID=3,
    --游戏人数
    GAME_PLAYER=5,
    --游戏状态
    GS_WK_FREE=0,--等待开始
    GS_WK_PLAYING=100,--游戏进行
    
    
    --游戏内状态
    D_GAME_STATE_NULL=0,--空
    D_GAME_STATE_ROB_BANKER=1,--抢庄
    D_GAME_STATE_CHIP=2,--下注
    D_GAME_STATE_SEND_POKER=3,--发牌
    D_GAME_STATE_OPEN_POKER=4,--开牌
    D_GAME_STATE_GAME_RESULT=5,--游戏结算
    D_GAME_STATE_GAME_END=6,--游戏结束
    
    
    --时间标识
    D_TIMER_READY=10000,--准备  10s
    D_TIMER_ROB_BANKER=15000,--抢庄  15s
    D_TIMER_CHIP=10000,--下注    10s
    D_TIMER_SEND_POKER=3000,--发牌   3s
    D_TIMER_OPEN_POKER=10000,--开牌   10s
    D_TIMER_GAME_RESULT=5000,--游戏结算  5s
    
    --游戏
    --//扑克总数量
    D_ALL_POKER_COUNT=52,
    --//玩家扑克数量
    D_PLAYER_POKER_COUNT=5,
    --//左扑克数量
    D_LEFT_POKER_COUNT=3,
    --//右扑克数量
    D_RIGHT_POKER_COUNT=2,
    --//牛牛
    D_NIU_NIU=10,
    
    
    --服务器命令结构
    SUB_SC_ROB_BANKER=0,--抢庄
    SUB_SC_PLAYER_ROB_BANKER=1,--玩家抢庄
    SUB_SC_CHIP=2,--下注
    SUB_SC_PLAYER_CHIP=3,--玩家下注
    SUB_SC_SEND_POKER=4,--发牌
    SUB_SC_OPEN_POKER=5,--开牌
    SUB_SC_PLAYER_OPEN_POKER=6,--玩家开牌。
    SUB_SC_GAME_RESULT=7,--游戏结算。
    SUB_SC_GAME_END=8,--游戏结束
    
    --客户端 消息 定义
    SUB_CS_PLAYER_ROB_BANKER=0,--//玩家抢庄
    SUB_CS_PLAYER_CHIP=1,--//玩家下注
    SUB_CS_PLAYER_OPEN_POKER=2,--//玩家开牌
    SUB_CS_PLAYER_OPEN_POKER_TIP=3,--提示
    
    CANEXIT=0; --是否比牌完毕--可以退出游戏
    NOWCHAIRIDISHAVEP=0;
    
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
    
    -- 玩家数据结构
    stPlayerData =
    {
        [1] = DataSize.UInt16,
        [2] = DataSize.byte,
        [3] = DataSize.byte,
        [4] = DataSize.UInt64,
        [5] = DataSize.byte,
        [6] = DataSize.byte,
        [7] = DataSize.UInt64,
    
    },
    --游戏场景
    CMD_SC_GAME_SCENE=
    {
     [1]=DataSize.byte,
     [2]=DataSize.UInt32,
     [3]=DataSize.UInt16,
     [4]=DataSize.UInt16,
    },
    
    --抢庄
    CMD_SC_ROB_BANKER=
    {
    [1] = DataSize.UInt16,
    },
    
    --玩家抢庄
    CMD_SC_PLAYER_ROB_BANKER=
    {
    [1]=DataSize.UInt16,
    [2]=DataSize.byte,
    },
    
    --下注
    CMD_SC_CHIP=
    {
    [1]=DataSize.UInt16,
    [2]=DataSize.UInt64,
    },
    
    --玩家下注
    CMD_SC_PLAYER_CHIP=
    {
    [1]=DataSize.UInt16,
    [2]=DataSize.UInt64,
    },
    
    --发牌
    CMD_SC_SEND_POKER=
    {},
    
    --玩家开牌
    CMD_SC_PLAYER_OPEN_POKER=
    {},
    
    --游戏结算
    CMD_SC_GAME_RESULT=
    {},
    
    --客户端结构体
    --//玩家抢庄
    CMD_CS_PLAYER_ROB_BANKER=
    {
    [1]= DataSize.byte,
    },
    
    --玩家下注
    CMD_CS_PLAYER_CHIP=
    {
    [1]=DataSize.UInt64,
    },
    
    
    
    --玩家自己开牌
    CMD_CS_PLAYER_OPEN_POKER=
    {
    [1]= DataSize.byte,
    [2]= DataSize.byte,
    },
    
    
    Start_User_Data =
    {
        _1dwUser_Id = -100,
        _2szNickName = 0,
        _3bySex = 0,
        _4bCustomHeader = 0,
        _5szHeaderExtensionName = 0,
        _6szSign = 0,
        _7wGold = 0,
        _8wPrize = 0,
        _9wChairID = -100,
        _10wTableID = 65535,
        _11byUserStatus = 0,
        _12wScore = 0;
    },
    
    --自己椅子号
    MySelf_ChairID=65535,
    
    --庄家座位号
    Banker_ChairID=65535,
    
    --游戏状态
    Game_State=0,
    
    --是否为庄家逃跑
    IsBankerLeave=false,
    
    --当前正在进行的状态
    Playing_State=1,
    
    --已经经过的时间
    Playing_Time=0;
    
    --牛牛下注表
    NiuNiuChipObj={},

    PlayerScore=0,
    IsOver=false,
    
    lowChip=0,
    
    --表情名字
    NiuNiuExpressin=
    {
    [1]="bishi",
    [2]="daku",
    [3]="daxiao",
    [4]="dianzan",
    [5]="dongxin",
    [6]="gaoxing",
    [7]="jiayou",
    [8]="jiangya",
    [9]="liuhan",
    [10]="paizhuan",
    [11]="shengqi",
    [12]="touxiang",
    [13]="yinxian",
    [14]="zan",
    [15]="zibao",
    [16]="anwei",
    }  
    }
    