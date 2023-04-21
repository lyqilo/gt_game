XMZZ_DataConfig = {}

local self = XMZZ_DataConfig;
self.ServerDataURL = "http://127.0.0.1:80/module27.json"
self.CHIPLISTCOUNT = 10;--下注列表长度
self.CAISHENCOUNT = 10;--财神个数
self.ALLIMGCOUNT = 15;--图标个数
self.ALLLINECOUNT = 30;--连线数量
self.COLUMNCOUNT = 5;--每列个数
self.SMALLIMGCOUNT = 4;--小游戏图标个数
self.SMALLROLLCOUNT = 24;--小游戏外围图标个数

self.rollInterval = 0.1;--每列转动间隔时间
self.rollSpeed = 12;--每列转动速度,可调节快慢
self.rollTime = 1;--转动时间
self.rollReboundRate = 2;--每列停止后反弹比例（0：立即停止，值越大反弹速度越慢）
self.rollDistance = 80;--回弹距离，数值越大距离越大
self.winGoldChangeRate = 1;--得分跑分速率
self.winBigGoldChangeRate = 4.5;--得分跑分速率
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

self.CSRollPos = {
    -335, -166.5, 2, 170.5, 339
}
self.IconTable = {
    "Item1", --10  1
    "Item2", -- J 2
    "Item3", --Q  3
    "Item4", --K  4
    "Item5", --A  5
    "Item6", --笋子  6
    "Item7", --竹子  7
    "Item8", --熊猫  8
    "Item9", --Scatter   9
    "Item10", --Wild   10
    "Item10_1", --Wild1   11
    "Item10_2", --Wild2   12
    "Item10_3", --Wild3   13
};
self.EffectTable = {
    "Item1", --10  1
    "Item2", -- J 2
    "Item3", --Q  3
    "Item4", --K  4
    "Item5", --A  5
    "Item6", --笋子  6
    "Item7", --竹子  7
    "Item8", --熊猫  8
    "Item9", --Scatter   9
    "Item10", --Wild   10
    "Item10_1", --Wild1   11
    "Item10_2", --Wild2   12
    "Item10_3", --Wild3   13
};
self.Line = {
    { 6, 7, 8, 9, 10 }, --1
    { 1, 2, 3, 4, 5 }, --2
    { 11, 12, 13, 14, 15 }, --3
    { 1, 7, 13, 9, 5 }, --4
    { 11, 7, 3, 9, 15 }, --5
    { 6, 2, 3, 4, 10 }, --6
    { 6, 12, 13, 14, 10 }, --7
    { 1, 2, 8, 14, 15 }, --8
    { 11, 12, 8, 4, 5 }, --9
    { 6, 12, 8, 4, 10 }, --10
    { 6, 2, 8, 14, 10 }, --11
    { 1, 7, 8, 9, 5 }, --12
    { 11, 7, 8, 9, 15 }, --13
    { 1, 7, 3, 9, 5 }, --14
    { 11, 7, 13, 9, 15 }, --15
    { 6, 7, 3, 9, 10 }, --16
    { 6, 7, 13, 9, 10 }, --17
    { 1, 2, 13, 4, 5 }, --18
    { 11, 12, 3, 14, 15 }, --19
    { 1, 12, 13, 14, 5 }, --20
    { 11, 2, 3, 4, 15 }, --21
    { 6, 12, 3, 14, 10 }, --22
    { 6, 2, 13, 4, 10 }, --23
    { 1, 12, 3, 14, 5 }, --24
    { 11, 2, 13, 4, 15 }, --25
    { 11, 2, 8, 14, 5 }, --26
    { 1, 12, 8, 4, 15 }, --27
    { 1, 12, 8, 14, 5 }, --28
    { 11, 2, 8, 4, 15 }, --29
    { 11, 7, 3, 4, 10 }--30
}
self.ItemPosList = {
    82.5, 249.5, 416.5, 583.5, 750.5, 917.5
}---418,251,-84,