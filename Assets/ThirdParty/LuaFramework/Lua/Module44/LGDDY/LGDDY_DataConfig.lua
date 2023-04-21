LGDDY_DataConfig = {}

local self = LGDDY_DataConfig;
self.ServerDataURL = "http://127.0.0.1:80/module27.json"
self.CHIPLISTCOUNT = 5;--下注列表长度
self.CAISHENCOUNT = 10;--财神个数
self.ALLIMGCOUNT = 15;--图标个数
self.ALLLINECOUNT = 9;--连线数量
self.COLUMNCOUNT = 5;--每列个数
self.SMALLIMGCOUNT = 4;--小游戏图标个数
self.SMALLROLLCOUNT = 24;--小游戏外围图标个数

self.rollInterval = 0.3;--每列转动间隔时间
self.rollSpeed = 12;--每列转动速度,可调节快慢
self.rollTime = 1;--转动时间
self.rollReboundRate = 2;--每列停止后反弹比例（0：立即停止，值越大反弹速度越慢）
self.rollDistance = 116;--回弹距离，数值越大距离越大
self.winGoldChangeRate = 2;--得分跑分速率
self.winBigGoldChangeRate = 3.1;--得分跑分速率
self.selfGoldChangeRate = 2;--自身跑分速率
self.caijinGoldChangeRate = 10;--彩金跑分速率
self.freeLoadingShowTime = 3.3;--中免费展示时间
self.smallGameLoadingShowTime = 1.5;--中小游戏展示时间
self.smallGameRuleShowTime = 5;--中小游戏展示时间
self.REQCaiJinTime = 5;--请求彩金频率
self.lineAllShowTime = 2;--总连线展示时间
self.cyclePlayLineTime = 2;--连线轮播展示时间
self.waitShowLineTime = 0.3;--等待展示连线奖励时间
self.autoRewardInterval = 2;--自动或免费中奖间隔
self.autoNoRewardInterval = 0.2;--自动或免费未中奖间隔
self.addSpeedTime = 3;
self.showSelectFreeResultTime = 2;
self.showFreeResultTime = 3;--展示免费结算界面时间
self.showSmallGameResultTime = 3;--展示小游戏结算界面时间
self.smallMoveSpeed = 0.05;--小游戏外围旋转速度

self.autoList = {--自动旋转次数
    10000, 100, 50, 20
}
self.IconTable = {
    "Item1", --香蕉  1
    "Item2", -- 西瓜 2
    "Item3", --柠檬  3
    "Item4", --葡萄  4
    "Item5", --菠萝  5
    "Item6", --铃铛  6
    "Item7", --樱桃  7
    "Item8", --Bar  8
    "Item9", --bonus   9
    "Item10", --scatter   10
    "Item11", --wild   11
};
self.SmallIconTable = {
    "SmallItem1", --香蕉  1
    "SmallItem2", -- 西瓜 2
    "SmallItem3", --柠檬  3
    "SmallItem4", --葡萄  4
    "SmallItem5", --菠萝  5
    "SmallItem6", --铃铛  6
    "SmallItem7", --樱桃  7
    "SmallItem8", --Bar  8
    "SmallItem9", --bonus   9
    "SmallItem10", --scatter   10
    "SmallItem11", --wild   11
};
self.SmallIconPos = {
    { 6, 15, 21 }, --菠萝
    { 10, 16 }, --橘子
    { 2, 9, 14 }, --香蕉
    { 3, 11, 22 }, --樱桃
    { 12, 17, 23 }, --柠檬
    { 5, 18, 24 }, --葡萄
    { 4, 8, 20 }, --西瓜
    { 1, 7, 13, 19 } --炸弹
}
self.EffectTable = {
    "Item1", --香蕉  1
    "Item2", -- 西瓜 2
    "Item3", --柠檬  3
    "Item4", --葡萄  4
    "Item5", --菠萝  5
    "Item6", --铃铛  6
    "Item7", --樱桃  7
    "Item8", --Bar  8
    "Item9", --bonus   9
    "Item10", --scatter   10
    "Item11", --wild   11
};
self.GameResultType = {--游戏结果类型
    NORMAL = 0, --普通
    CYGG = 1, --财源滚滚
    JYMT = 2--金玉满堂
};
self.Line = {--连线结果
    { 6, 7, 8, 9, 10 }, --1
    { 1, 2, 3, 4, 5 }, --2
    { 11, 12, 13, 14, 15 }, --3
    { 1, 7, 13, 9, 5 }, --4
    { 11, 7, 3, 9, 15 }, --5
    { 1, 2, 8, 14, 15 }, --6
    { 11, 12, 8, 4, 5 }, --7
    { 6, 12, 8, 4, 10 }, --8
    { 6, 2, 8, 14, 10 }, --9
}