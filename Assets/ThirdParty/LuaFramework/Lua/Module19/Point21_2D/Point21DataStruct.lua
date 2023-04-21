--Point21DataStruct.lua
--Date
--21点数据结构定义

--endregion

Point21DataStruct = {}

local self = Point21DataStruct

------------------------------------登陆部分发送消息数据结构-------------------------

local String100 = 100
--发送登陆数据结构
self.CMD_GR_LogonByUserID = {
    [1] = DataSize.UInt32, --广场版本 暂时不用
    [2] = DataSize.UInt32, --进程版本 暂时不用
    [3] = DataSize.UInt32, --用户 I D
    [4] = DataSize.String33, --登录密码 MD5小写加密
    [5] = String100,
    [6] = DataSize.byte, --补位
    [7] = DataSize.byte --补位
}

-- 客户端游戏场景准备好了，准备接收场景消息
self.CMD_GF_Info = {
    [1] = DataSize.byte --旁观标志 必须等于0
}

--------------------------------登陆部分发送消息数据结构 end------------------------------

-------------------------------------游戏消息结构----------------------------------------
self.E_CHIPTYPE_OTHER = 0
self.E_CHIPTYPE_NORMAL = 1
self.E_CHIPTYPE_NORMAL_D = 2 --对子
self.E_CHIPTYPE_NORMAL_A13 = 3 --正13
self.E_CHIPTYPE_NORMAL_S13 = 4

self.CMD_BlackJack = {
    TIMER_CHIP = 20, --下注时间
    TIMER_DEAL_POKER_A0 = 1.5, --发牌时间a0
    TIMER_DEAL_POKER_D = 2, --发牌时间d
    TIMER_DEAL_POKER_OFFSET = 5, --发牌时间offset
    TIMER_INSURACE = 5, --5.5; 保险时间
    TIMER_LOOK_ZJ_BLACK_JACK = 4.5, --查看庄家是否黑杰克时间
    TIMER_NORMAL_OPERATE = 10.5, --玩家普通操作时间
    TIMER_GAME_END = 8.5, --游戏结束时间
    TIMER_START_OPERATE = 1, --开始操作
    TIMER_LOOK_ZJ_SECOND_POKER = 4.5, --查看庄家第二张扑克
    TIMER_ZJ_HIT_POKER = 4.5, --庄家拿牌
    TIMER_AUTO_ADD_POKER = 4.5, --自动补牌
    TIMER_AUTO_ADD_POKER_STAND = 2.5, --动作补牌停止
    TIMER_SERVER_OR_CLIENT_TIME = 2.5, --延迟时间
    GAME_PLAYER = 4, --玩家总人数
    C_SPLIT_POKER_COUNT = 2, --分牌数
    C_GROUP_MAX_POKER_COUNT = 8, --每组最大扑克数量
    enGameRunState = {
        --游戏运行状态
        E_GAME_RUN_STATE_NULL = -1,
        --未知
        E_GAME_RUN_STATE_START = 0,
        --开始状态
        E_GAME_RUN_STATE_CHIP = 1,
        --下注状态
        E_GAME_RUN_STATE_NOT_CHIP = 2,
        --不是下注状态
        E_GAME_RUN_STATE_OFFLINE = 3
        --断线重连
    },
    enPlayerOperateState = {
        --玩家操作状态
        E_PLAYER_OPERATE_STATE_NULL = -1,
        --未知
        E_PLAYER_OPERATE_STATE_CHIP = 0, --下注状态
        E_PLAYER_OPERATE_STATE_DEAL_POKER = 1,
        --发牌状态
        E_PLAYER_OPERATE_STATE_INSURANCE = 2,
        --保险状态
        E_PLAYER_OPERATE_STATE_PRE_LOOK_ZJ_BLACK_JACK = 3,
        --查看庄家是否黑杰克前
        E_PLAYER_OPERATE_STATE_AFT_LOOK_ZJ_BLACK_JACK = 4,
        --查看庄家是否黑杰克后
        E_PLAYER_OPERATE_STATE_PRE_LOOK_ZJ_SECOND_POKER = 5,
        --查看庄家第二张扑克前
        E_PLAYER_OPERATE_STATE_AFT_LOOK_ZJ_SECOND_POKER = 6,
        --查看庄家第二张扑克后
        E_PLAYER_OPERATE_STATE_NORMAL_OPERATE = 7,
        --普通操作
        E_PLAYER_OPERATE_STATE_AUTO_ADD_POKER = 8
        --自动补牌操作
    },
    enPlayerNormalOperate = {
        --玩家普通操作
        E_PLAYER_NORMAL_OPERATE_NULL = -1,
        --未知
        E_PLAYER_NORMAL_OPERATE_SURRENDER = 0, --投降
        E_PLAYER_NORMAL_OPERATE_SPLIT_POKER = 1, --分牌
        E_PLAYER_NORMAL_OPERATE_DOUBLE_CHIP = 2, --双倍
        E_PLAYER_NORMAL_OPERATE_STAND_POKER = 3, --停牌
        E_PLAYER_NORMAL_OPERATE_HIT_POKER = 4, --拿牌
        E_PLAYER_NORMAL_OPERATE_AUTO_ADD_POKER = 5 --自动补牌
    },
    enGameEndType = {
        --游戏结束类型
        E_GAME_END_TYPE_NULL = -1, --未知
        E_GAME_END_TYPE_ZJ_BLACK_JACK = 0, --庄家黑杰克
        E_GAME_END_TYPE_NORMAL = 1 --正常结束
    },
    enPlayerWin = {
        --玩家输赢
        E_PLAYER_WIN_NULL = -1, --未知
        E_PLAYER_WIN_WIN = 0, --赢了
        E_PLAYER_WIN_EVEN = 1, --平局
        E_PLAYER_WIN_LOST = 2 --输了
    },
    --服务器消息
    SUB_SC_SMALL_TIP = 0, --打赏小费
    SUB_SC_CHIP = 1, --下注
    SUB_SC_PLAYER_CHIP = 2, --玩家下注
    SUB_SC_DEAL_POKER = 3, --发牌
    SUB_SC_INSURANCE = 4, --保险
    SUB_SC_PLAYER_INSURANCE = 5, --玩家保险
    SUB_SC_LOOK_ZJ_BLACK_JACK = 6, --查看庄家是否黑杰克
    SUB_SC_PLAYER_BLACK_JACK = 7, --玩家黑杰克
    SUB_SC_NORMAL_OPERATE = 8, --普通操作
    SUB_SC_PLAYER_NORMAL_OPERATE = 9, --玩家普通操作
    SUB_SC_LOOK_ZJ_SECOND_POKER = 10, --查看庄家第二张牌
    SUB_SC_NEW_PALYER_ENTER_AT_CHIP = 11, --下注状态进入玩家
    SUB_SC_GAME_END = 20, --游戏结束
    SUB_SC_CHIP_LIST = 21, --下注列表
    SUB_SC_STOP_CHIP = 22, --停止下注
    SUB_SC_CHIP_ERROR = 23,
    SUB_SC_HEART_BIT = 49, --心跳
    --客户端 消息 定义
    SUB_CS_SET_CELLSCORE = 0, --自由场
    SUB_CS_SMALL_TIP = 1, --打赏小费
    SUB_CS_PLAYER_CHIP = 2, --玩家下注
    SUB_CS_PLAYER_INSURANCE = 3, --玩家保险
    SUB_CS_PLAYER_NORMAL_OPERATE = 4, --玩家普通操作
    SUB_CS_TE_SHU_CHU_LI = 5, --特殊处理
    SUB_CS_STOP_CHIP = 6, --停止下注
    SUB_CS_ANIMAL_END = 7, --游戏结束
    SUB_CS_HEART_BIT = 49 --心跳
}

self.stDealPoker = {
    --牌数据
    [1] = DataSize.byte, --第一张
    [2] = DataSize.byte --第二张
}

--  服务器发送结构体

self.CMD_SC_GAME_FREE = {
    -- 游戏空闲
    lCellScore = 0, --基础积分
    cbSetCellStatus = 0, --自由场状态
    byCurrentOperateChairID = 0, --当前操作座位号
    gameRunState = 0, --游戏运行状态
    zjOperateState = 0, --庄家操作状态
    iLeftTime = 0, --下注剩余时间
    iChip = {}, --下注值
    serverPlayerData = {}, --玩家数据
    historyScore = {}, --成绩
    DataDispose = function(bytes)
        if (not bytes) then
            self.CMD_SC_GAME_FREE.lCellScore = 0 --基础积分
            self.CMD_SC_GAME_FREE.cbSetCellStatus = 0 --自由场状态
            self.CMD_SC_GAME_FREE.byCurrentOperateChairID = 0 --当前操作座位号
            self.CMD_SC_GAME_FREE.gameRunState = 0 --游戏运行状态
            self.CMD_SC_GAME_FREE.zjOperateState = 0 --庄家操作状态
            self.CMD_SC_GAME_FREE.iLeftTime = 0 --下注剩余时间
            self.CMD_SC_GAME_FREE.iChip = {} --下注值
            self.CMD_SC_GAME_FREE.serverPlayerData = {} --玩家数据
            self.CMD_SC_GAME_FREE.historyScore = {} --成绩
            return
        end

        self.CMD_SC_GAME_FREE.lCellScore = bytes:ReadInt32()
        self.CMD_SC_GAME_FREE.cbSetCellStatus = bytes:ReadByte()
        self.CMD_SC_GAME_FREE.byCurrentOperateChairID = bytes:ReadByte()
        self.CMD_SC_GAME_FREE.gameRunState = bytes:ReadInt32()
        self.CMD_SC_GAME_FREE.zjOperateState = bytes:ReadInt32()
        self.CMD_SC_GAME_FREE.iLeftTime = bytes:ReadInt32()

        for i = 1, self.CMD_BlackJack.GAME_PLAYER do
            table.insert(self.CMD_SC_GAME_FREE.iChip, bytes:ReadInt32())
        end

        for i = 1, self.CMD_BlackJack.GAME_PLAYER + 1 do
            local stServerPlayerData = {
                m_iChip = {0, 0, 0, 0}, --下注
                m_iChipList = {}, --下注列表
                m_byGroupIndex = 0, --组索引
                m_byGroupCount = 0, --组数量
                m_byPokerData = {}, --扑克数据
                m_byPokerCount = {}, --扑克数量
                m_bSurrender = {}, --是否投降
                m_bInsurance = 0, --是否购买保险
                m_bPlaying = 0, --是否游戏中
                m_bHasOperatePoker = {}, --是否已经操作扑克
                m_byNotChipCount = 0, --不下注次数
                m_enPlayerOperateState = 0 --玩家操作状态
            }

            for i = 1, 4 do
                stServerPlayerData.m_iChip[i] = bytes:ReadInt32()
            end
            for j = 1, self.CMD_BlackJack.C_SPLIT_POKER_COUNT do
                table.insert(stServerPlayerData.m_iChipList, bytes:ReadInt32())
            end
            stServerPlayerData.m_byGroupIndex = bytes:ReadByte()
            stServerPlayerData.m_byGroupCount = bytes:ReadByte()
            for j = 1, self.CMD_BlackJack.C_SPLIT_POKER_COUNT * self.CMD_BlackJack.C_GROUP_MAX_POKER_COUNT do
                table.insert(stServerPlayerData.m_byPokerData, bytes:ReadByte())
            end
            for j = 1, self.CMD_BlackJack.C_SPLIT_POKER_COUNT do
                table.insert(stServerPlayerData.m_byPokerCount, bytes:ReadByte())
            end
            for j = 1, self.CMD_BlackJack.C_SPLIT_POKER_COUNT do
                table.insert(stServerPlayerData.m_bSurrender, bytes:ReadByte())
            end
            stServerPlayerData.m_bInsurance = bytes:ReadByte()
            stServerPlayerData.m_bPlaying = bytes:ReadByte()
            for j = 1, self.CMD_BlackJack.C_SPLIT_POKER_COUNT do
                table.insert(stServerPlayerData.m_bHasOperatePoker, bytes:ReadByte())
            end
            stServerPlayerData.m_byNotChipCount = bytes:ReadByte()
            stServerPlayerData.m_enPlayerOperateState = bytes:ReadInt32()

            table.insert(self.CMD_SC_GAME_FREE.serverPlayerData, stServerPlayerData)
        end

        for i = 1, self.CMD_BlackJack.GAME_PLAYER do
            local stHistoryScore = {
                --成绩
                bValid = 0, --是否有效
                byChairID = 0, --座位号
                iLastWinGameGold = 0, --上轮成绩
                iTotalWinGameGold = 0 --总成绩
            }

            stHistoryScore.bValid = bytes:ReadByte()
            stHistoryScore.byChairID = bytes:ReadByte()
            stHistoryScore.iLastWinGameGold = bytes:ReadInt32()
            stHistoryScore.iTotalWinGameGold = bytes:ReadInt32()

            table.insert(self.CMD_SC_GAME_FREE.historyScore, stHistoryScore)
        end
    end
}

--打赏小费

self.CMD_SC_PLAYER_CHIP = {
    --玩家下注
    [1] = DataSize.Int32, --下注值
    [2] = DataSize.byte, --座位号
    [3] = DataSize.byte -- 下注类型
}

--发牌

self.CMD_SC_PLAYER_INSURANCE = {
    --玩家保险
    [1] = DataSize.byte, --座位号
    [2] = DataSize.byte --是否购买保险
}

self.CMD_SC_LOOK_ZJ_BLAKC_JACK = {
    --查看庄家是否黑杰克
    [1] = DataSize.byte, --庄家是否黑杰克
    [2] = DataSize.byte --扑克数据
}

--游戏结束
--玩家黑杰克

self.CMD_SC_NORMAL_OPERATE = {
    --普通操作
    [1] = DataSize.byte, --座位号
    [2] = DataSize.byte --是否能够分牌
}

self.CMD_SC_PLAYER_NORMAL_OPERATE = {
    --玩家普通操作
    [1] = DataSize.Int32, --玩家普通操作
    --扑克数据
    [2] = DataSize.byte, --第一张
    [3] = DataSize.byte, --第二张
    [4] = DataSize.byte, --座位号
    [5] = DataSize.byte, --爆牌
    [6] = DataSize.byte, --21点
    [7] = DataSize.byte --自己停牌
}

self.CMD_SC_LOOK_ZJ_SECOND_POKER = {
    --查看庄家第二张牌
    [1] = DataSize.byte --扑克数据
}

self.CMD_SC_NEW_PLAYER_ENTER_AT_CHIP = {
    --新玩家在下注状态时进入
    [1] = DataSize.byte --座位号
}

self.CMD_SC_GAME_END = {
    --游戏结束
    gameEndType = 0, --游戏结束类型
    gameResult = {}, --玩家输赢
    historyScore = {}, --成绩
    DataDispose = function(bytes)
        if (not bytes) then
            self.CMD_SC_GAME_END.gameEndType = 0
            self.CMD_SC_GAME_END.gameResult = {}
            self.CMD_SC_GAME_END.historyScore = {}
            return
        end

        self.CMD_SC_GAME_END.gameEndType = bytes:ReadInt32()

        for i = 1, self.CMD_BlackJack.GAME_PLAYER * self.CMD_BlackJack.C_SPLIT_POKER_COUNT do
            local stGameResult = {
                bPlayerWin = 0, --玩家输赢
                bBlackJack = 0, --是否黑杰克
                bDragon = 0, --是否龙
                iWinGameGold = 0 --赢的游戏金币
            }

            stGameResult.bPlayerWin = bytes:ReadInt32()
            stGameResult.bBlackJack = bytes:ReadByte()
            stGameResult.bDragon = bytes:ReadByte()
            stGameResult.iWinGameGold = bytes:ReadInt32()

            table.insert(self.CMD_SC_GAME_END.gameResult, stGameResult)
        end

        for i = 1, self.CMD_BlackJack.GAME_PLAYER do
            local stHistoryScore = {
                --成绩
                bValid = 0, --是否有效
                byChairID = 0, --座位号
                iLastWinGameGold = 0, --上轮成绩
                iTotalWinGameGold = 0 --总成绩
            }

            stHistoryScore.bValid = bytes:ReadByte()

            stHistoryScore.byChairID = bytes:ReadByte()
            stHistoryScore.iLastWinGameGold = bytes:ReadInt32()
            stHistoryScore.iTotalWinGameGold = bytes:ReadInt32()

            table.insert(self.CMD_SC_GAME_END.historyScore, stHistoryScore)
        end
    end
}

self.CMD_SC_CHIP_LIST = {
    --下注列表
    [1] = DataSize.Int32,
    [2] = DataSize.Int32,
    [3] = DataSize.Int32,
    [4] = DataSize.Int32
    --    [5] = DataSize.Int32;
}

self.CMD_SC_STOP_CHIP = {
    -- 停止下注
    [1] = DataSize.byte --座位号
}

--   客服端发送结构体

--基础分

self.CMD_CS_PLAYER_CHIP = {
    -- 玩家下注
    [1] = DataSize.byte, --下注类型
    [2] = DataSize.Int32 --下注值
}

self.CMD_CS_PLAYER_INSURANCE = {
    --玩家保险
    [1] = DataSize.byte --是否购买保险
}

self.CMD_CS_PLAYER_NORMAL_OPERATE = {
    --玩家普通操作
    [1] = DataSize.Int32 --玩家普通操
}

--特殊处理

--------------------------游戏消息结构 end---------------
