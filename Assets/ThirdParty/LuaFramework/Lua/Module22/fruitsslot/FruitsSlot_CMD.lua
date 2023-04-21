FruitsSlot_CMD = {};
local self = FruitsSlot_CMD;

self.D_ALL_COUNT =        15;--总图标
self.D_LINE_COUNT =    11;--线数


self.SUB_CS_GAME_START = 0;--启动游戏
self.SUB_CS_BELL_GAME_END = 1;--点击请求铃铛值
self.SUB_CS_GAME_PEILV = 2;--获取下注配置

--服务器消息
self.SUB_SC_GAME_START =    0;--启动游戏 -- 无用
self.SUB_SC_GAME_OVER =    1;--游戏结束
self.SUB_SC_BELL_GAME =    2;--铃铛游戏结算
self.SUB_SC_USER_PEILV =    3;--下注配置返回
