--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

BRNN_CMD = {};
local self = BRNN_CMD;
-------------------------C2S------------------------------
self.SUB_CS_PLAYER_CHIP =        0;--玩家下注
self.SUB_CS_REQUEST_BANKER =     1;--申请上庄
self.SUB_CS_LOSE_BANKER =        2;--申请下庄



-------------------------S2C------------------------------
self.SUB_SC_BANKER_INFO =           0;--庄家信息
self.SUB_SC_REQUEST_BANKER =        1;--上庄 数据大小为0表示成功，否则直接取字符串看错误原因
self.SUB_SC_LOSE_BANKER =           2;--下庄
self.SUB_SC_BEGIN_CHIP =            3;--开始下注
self.SUB_SC_UPDATE_CHIP_VALUE =     4;--更新下注值
self.SUB_SC_PLAYER_CHIP =           5;--玩家下注
self.SUB_SC_CHIP_FAIL =             6;--下注失败 查看字符串获取失败原因
self.SUB_SC_STOP_CHIP =             7;--停止下注
self.SUB_SC_SEND_POKER =            8;--发牌
self.SUB_SC_GAME_OVER =             9;--游戏结束
self.SUB_SC_BANKER_LIST =           10;--上庄列表

return BRNN_CMD

--endregion
