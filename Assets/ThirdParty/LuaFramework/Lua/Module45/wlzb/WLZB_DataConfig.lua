WLZB_DataConfig = {}

local self = WLZB_DataConfig;
self.ServerDataURL = "http://127.0.0.1:80/module27.json"
self.CHIPLISTCOUNT = 5;--下注列表长度
self.CAISHENCOUNT = 10;--财神个数
self.ALLIMGCOUNT = 15;--图标个数
self.ALLLINECOUNT = 20;--连线数量
self.COLUMNCOUNT = 5;--每列个数

self.rollInterval = 0.3;--每列转动间隔时间
self.rollSpeed = 20;--每列转动速度,可调节快慢
self.rollTime = 1;--转动时间
self.rollReboundRate = 0.45;--每列停止后反弹比例（0：立即停止，值越大反弹速度越慢）
self.rollDistance = 2;--回弹距离，数值越大距离越大
self.winGoldChangeRate = 3;--得分跑分速率
self.selfGoldChangeRate = 2;--自身跑分速率
self.caijinGoldChangeRate = 10;--彩金跑分速率
self.freeLoadingShowTime = 1;--中免费展示时间
self.smallGameLoadingShowTime = 1;--中小游戏展示时间
self.REQCaiJinTime = 5;--请求彩金频率
self.lineAllShowTime = 2;--总连线展示时间
self.cyclePlayLineTime = 2;--连线轮播展示时间
self.waitShowLineTime = 0.3;--等待展示连线奖励时间
self.autoRewardInterval = 2;--自动或免费中奖间隔
self.autoNoRewardInterval = 0.2;--自动或免费未中奖间隔
self.addSpeedTime = 3;
self.showSelectFreeResultTime = 2;

self.autoList = {--自动旋转次数
    20, 50, 100, 10000
}
self.IconTable = {
    "Item1", --金元宝  1
    "Item2", --金狮子  2
    "Item3", --金鲤鱼  3
    "Item4", --金乌龟  4
    "Item5", --红包  5
    "Item6", --A  6
    "Item7", --K  7
    "Item8", --Q  8
    "Item9", --J   9
    "Item10", --10   10
    "Item11", --9   11
    "Item12", --Scatter   12
    "Item13", --wild   13
    "Item14", --free_wild1   14
    "Item15", --free_wild2   15
    "Item16", --free_wild3   16
    "Item17", --free_wild4   17
    "Item18", --free_wild5   18
    "Item19", --free_wild6   19
};
self.EffectTable = {
    "Item1", --金元宝  1
    "Item2", --金狮子  2
    "Item3", --金鲤鱼  3
    "Item4", --金乌龟  4
    "Item5", --红包  5
    "Item6", --A  6
    "Item7", --K  7
    "Item8", --Q  8
    "Item9", --J   9
    "Item10", --10   10
    "Item11", --9   11
    "Item12", --Scatter   12
    "Item13", --wild   13
    "Item14", --free_wild1   14
    "Item15", --free_wild2   15
    "Item16", --free_wild3   16
    "Item17", --free_wild4   17
    "Item18", --free_wild5   18
    "Item19", --free_wild6   19
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
    { 1, 2, 8, 4, 5 }, --6
    { 11, 12, 8, 14, 15 }, --7
    { 6, 12, 13, 14, 10 }, --8
    { 6, 2, 3, 4, 10 }, --9
    { 1, 7, 8, 9, 5 }, --10
    { 11, 7, 8, 9, 15 }, --11
    { 1, 7, 3, 9, 5 }, --12
    { 11, 7, 13, 9, 15 }, --13
    { 6, 2, 8, 4, 10 }, --14
    { 6, 12, 8, 14, 10 }, --15
    { 6, 7, 3, 9, 10 }, --16
    { 6, 7, 13, 9, 10 }, --17
    { 1, 12, 3, 14, 5 }, --18
    { 11, 2, 13, 4, 15 }, --19
    { 6, 2, 13, 4, 10 }, --20
    { 6, 12, 3, 14, 10 }, --21
    { 1, 2, 13, 4, 5 }, --22
    { 11, 12, 3, 14, 15 }, --23
    { 1, 12, 13, 14, 5 }, --24
    { 11, 2, 3, 4, 15 }, --25
}