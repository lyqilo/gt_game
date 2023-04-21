SuperSlotMessageTemplete = {}
local self = SuperSlotMessageTemplete

--//游戏定义
local enFRUIT_PEILV_LEVEL = {
    FRUIT_PEILV_LEVEL_08 = 0,
    FRUIT_PEILV_LEVEL_09 = 1,
    FRUIT_PEILV_LEVEL_10 = 2,
    FRUIT_PEILV_LEVEL_11 = 3,
    FRUIT_PEILV_LEVEL_12 = 4
}
---水果类型
self.enFRUIT_TYPE = {
    FRUIT_TYPE_MIN = 0,
    ---wild
    FRUIT_TYPE_TINGYONG = 1,
    ---7
    FRUIT_TYPE_SEVEN = 2,
    ---bar
    FRUIT_TYPE_BAR = 3,
    FRUIT_TYPE_RING = 4,
    FRUIT_TYPE_STAR = 5,
    ---西瓜
    FRUIT_TYPE_WATERMELON = 6,
    ---樱桃
    FRUIT_TYPE_CHERRY = 7,
    FRUIT_TYPE_ORANGE = 8,
    FRUIT_TYPE_LEMON = 9,
    FRUIT_TYPE_APPLE = 10,
    FRUIT_TYPE_PRIZE_CUP = 11,
    FRUIT_TYPE_PLAY_STATION = 12,
    FRUIT_TYPE_MAX = 13
}
self.LABA_MSG_CS_START = 1
self.LABA_MSG_CS_SMALL_GAME = 5

---//游戏开始
self.LABA_MSG_SC_START = 1
---//游戏结果
self.LABA_MSG_SC_CHECKOUT = 2
---//玩家金币，上把赢得金币，总赢金币
self.LABA_MSG_SC_SYNC_GOLD = 5
---//小游戏
self.LABA_MSG_SC_SMALL_GAME = 6
---//奖池消息
self.LABA_MSG_SC_UPDATE_PRIZE_POOL = 8
---场景消息
self.LABA_MSG_SC_BETON_CONFIG = 10
---//更新奖池
self.LABA_GLOBAL_MSG_UPDATE_PRIZE_POOL = 1

self.enLABA_TIMER = {
    LABA_TIMER_UPDATE_PRIZE_POOL = 1,
    LABA_TIMER_MODIFY_PRIZE_POOL = 2,
    LABA_TIMER_DEDUCTION_PRIZE_POOL = 3
}

self.enSMAll_GAME_ICON_TYPE = {
    SMAll_GAME_ICON_TYPE_MIN = 0,
    SMAll_GAME_ICON_TYPE_1 = 1,
    SMAll_GAME_ICON_TYPE_2 = 2,
    SMAll_GAME_ICON_TYPE_3 = 3,
    SMAll_GAME_ICON_TYPE_4 = 4,
    SMAll_GAME_ICON_TYPE_5 = 5,
    SMAll_GAME_ICON_TYPE_MAX = 6
}

self.eTotalType = {
    eTotalType_Normal = 0,
    eTotalType_Free = 1,
    eTotalType_SmallGame = 2
}

self.enStatusType = {
    enStatusType_NULL = 0,
    enStatusType_PrizePool = 1,
    enStatusType_Chip = 2
}

--//开始
self.CS_Start = {
    m_nLineNum = 0, --//未使用int
    m_nLineGold = 0 --//下注金额int
}

--//小游戏
self.SC_SmallGame = {
    GoldLine = 0 --//下注金额
}

--//MSG: LABA_MSG_SC_START
self.SC_Start = {
    m_nRetCode = 0 --//1为未压线,2为未压钱,3为钱不够,4-CD,5-单线押注不对
}
--//MSG: LABA_MSG_SC_CHECKOUT
self.SC_CheckOut = {
    m_nResult = {},
    --[15];--//游戏结果，15个int
    m_nRewardLineFruitCount = {}, -- [9];					--//水果线数
    m_nWinPeiLv = 0, --//赢得赔率int
    m_nCurrGold = 0, --//当前金币INT64
    m_nWinGold = 0, --//本次赢得金币int
    m_nTotalWinGold = 0, --//总赢的金币int
    m_nFreeTimes = 0, --//免费次数int
    m_nMultiple = 0, --//单线倍率int
    m_bFreeGame = 0, --//免费游戏标识 bool
    m_nJackPotValue = 0, --//奖金池奖int
    m_bSmallGame = 0 --//小游戏 bool
}

--//MSG: LABA_MSG_SC_UPDATE_PRIZE_POOL
self.SC_UpdatePrizePool = {
    m_nPrizePoolGold = 0 --//奖金池奖int
}

---//同步金币
---//MSG: LABA_MSG_SC_SYNC_GOLD
self.SC_SyncGold = {
    m_nGold = 0, --//玩家当前金币INT64
    m_nLastWinGold = 0, --//未使用int
    m_nTotalWinGold = 0 --//总输赢int
}
---//MSG: LABA_MSG_SC_BETON_CONFIG
self.SC_Beton_Config = {
    nLeftFreeGameCnt = 0, --				//剩余免费游戏次数int
    nMultiple = 0, --				//单线倍率int
    nBetonCount = 0, --int
    nBetonGold = {},
    --[LABA_MAX_BETON_NUM]; --int
    nFreeGameCotTotal = 0, --					//免费游戏总次数int
    nFreeGameGold = 0, --						//免费游戏获得金币int
    nSmallCount = 0 --						//当前小游戏次数int
}
self.SmallGameType = {
    GameType_zhada1 = 1, --//炸弹1
    GameType_xiangjiao1 = 2, --//香蕉1
    GameType_yingtao1 = 3, --//樱桃1
    GameType_xigua1 = 4, --//西瓜1
    GameType_putao1 = 5, --//葡萄1
    GameType_boluo1 = 6, --//菠萝1
    GameType_zhadan2 = 7, --//炸弹2
    GameType_xigua2 = 8, --//西瓜2
    GameType_xiangjiao2 = 9, --//香蕉2
    GameType_juzi1 = 10, --//橘子1
    GameType_yingtao2 = 11, --//樱桃2
    GameType_ningmeng1 = 12, --//柠檬1
    GameType_zhadan3 = 13, --//炸弹3
    GameType_xiangjiao3 = 14, --//香蕉3
    GameType_boluo2 = 15, --//菠萝2
    GameType_juzi2 = 16, --//橘子2
    GameType_ningmeng2 = 17, --//柠檬2
    GameType_putao2 = 18, --//葡萄2
    GameType_zhadan4 = 19, --//炸弹4
    GameType_xigua3 = 20, --//西瓜3
    GameType_boluo3 = 21, --//菠萝3
    GameType_yingtao3 = 22, --//樱桃3
    GameType_ningmeng3 = 23, --//柠檬3
    GameType_putao3 = 24 --//葡萄3
}
self.IconPos = {
    { 6, 15, 21 }, --菠萝
    { 10, 16 }, --橘子
    { 2, 9, 14 }, --香蕉
    { 3, 11, 22 }, --樱桃
    { 12, 17, 23 }, --柠檬
    { 5, 18, 24 }, --葡萄
    { 4, 8, 20 }, --西瓜
    { 1, 7, 13, 19 } --炸弹
}
---//MSG: LABA_MSG_SC_SMALL_GAME
self.SC_stSmallGameInfo = {
    nSmallGameTatolConut = 0, --//小游戏次数int
    nSmallGameConut = 0, --	//小游戏剩余次数int
    nGameTatolGold = 0, --		//小游戏总获得金币int
    nIconType = 0, --			//游戏图标int
    nIconTypeConut = 0, --		//第几个水果int
    nIconType4 = {},
    --[4];		//中间四个图标int
    nGameGold = 0, --			//游戏本次获得金币int
    bGameEnd = 0, --			//游戏是否结束 0结束 bool
    nLineGold = 0 --			//单线金币int
}