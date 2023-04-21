BirdsAndBeast_CMD = {};
local self = BirdsAndBeast_CMD;


self.SUB_CS_CHIP_NORMAL = 0;--押注-普通
self.SUB_CS_CLEAR_MYPUSHMONEY = 1;--清空下注
self.SUB_CS_CHIP_NORMAL_LIST = 2; --用于续压功能

--服务器 消息 定义
self.SUB_SC_CHIP_NORMAL=		0;--押注-普通
self.SUB_SC_CHIP_NUM_CHANGE=	1;--总押注的改变
self.SUB_SC_HIS_CHANG=        2;--历史记录的改变

self.SUB_SC_IDI_START=			3--开始
self.SUB_SC_IDI_CHIP	=	    	4--下注
self.SUB_SC_IDI_STOP_CHIP=		5--停止下注
self.SUB_SC_IDI_SEND_POKER=		6--发牌
self.SUB_SC_IDI_GAME_OVER=		7--游戏结束

self.SUB_SC_TOTAL_WIN_LOSE_SCORE=		8--总输赢分数(客户端暂时没有处理)

self.SUB_SC_GAME_WIN=				9--结算

self.SUB_SC_OPEN_PUSH =       10--看出下面投注区域的显示

self.SUB_SC_CHIP_LIMIT_CHANG=        11--下注区域的倍数限红改变

self.SUB_SC_CHIP_NORMAL_LIST=		12--批量-押注-普通

self.SUB_SC_CHIP_NUM_CHANGE_LIST=	13 --总押注批量的改变
self.SUB_SC_CAI_RATE =	14 -- 彩金的倍数




self.D_ANIMAL_OR_COLOR_AREA_COUNT = 12--下注区域
self.D_CHOUM_NUM = 5--筹码的数量
self.D_HIS_COUNT = 12 --历史数
self.INVALID_BYTE = 0xFF--Byte的无效值
self.INVALID_WORD = 0XFFFF--Byte的无效值



--游戏内状态
self.D_GAME_STATE_NULL = 	0;--空
self.D_GAME_STATE_CHIP = 	1;--下注
self.D_GAME_STATE_STOP_CHIP =  2;--停止下注
self.D_GAME_STATE_RUN =    3;--发送运动
self.D_GAME_STATE_HIS = 	4;--发送历史
self.D_GAME_STATE_OVER = 	5;--结算