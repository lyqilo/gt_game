FLM_DataConfig = {}

local self = FLM_DataConfig;
self.ServerDataURL = "http://127.0.0.1:80/FLMEntry.json"
self.CHIPLISTCOUNT = 5;--下注列表长度
self.CAISHENCOUNT = 10;--财神个数
self.ALLIMGCOUNT = 15;--图标个数
self.ALLLINECOUNT = 25;--连线数量
self.COLUMNCOUNT = 5;--每列个数

self.rollInterval = 0.07;--每列转动间隔时间
self.rollSpeed = 15;--每列转动速度,可调节快慢
self.rollTime = 1;--转动时间
self.rollReboundRate = 0.1;--每列停止后反弹比例（0：立即停止，值越大反弹速度越慢）
self.rollDistance = 1.5;--回弹距离，数值越大距离越大
self.winGoldChangeRate = 2;--得分跑分速率
self.winBigGoldChangeRate = 4;--得分跑分速率
self.selfGoldChangeRate = 10;--自身跑分速率
self.caijinGoldChangeRate = 10;--彩金跑分速率
self.freeLoadingShowTime = 1;--中免费展示时间
self.smallGameLoadingShowTime = 2;--中小游戏展示时间
self.REQCaiJinTime = 5;--请求彩金频率
self.lineAllShowTime = 2;--总连线展示时间
self.cyclePlayLineTime = 2;--连线轮播展示时间
self.waitShowLineTime = 0.3;--等待展示连线奖励时间
self.autoRewardInterval = 2;--自动或免费中奖间隔
self.autoNoRewardInterval = 0.5;--自动或免费未中奖间隔


self.autoList = {--自动旋转次数
    20, 50, 100, 10000
}
self.IconTable = {
    "Item1", --9  0
    "Item2", --10  1
    "Item3", --J  2
    "Item4", --Q  3
    "Item5", --K  4
    "Item6", --财  5
    "Item7", --寿(女娃)  6
    "Item8", --福(男娃)  7
    "Item9", --狮子(龙)   8
    "Item10", --听用(鱼)   9
    "Item11", --鞭炮   10
    "Item12", --金币   11
    "Item13", --金币数字   12
};
self.EffectTable = {
    "9", --财神动画 
    "10", --wild动画
    "J", --wildx2动画
    "Q", --金元宝动画
    "K", --银元宝动画
    "Cai", --红包动画
    "Shou", --中红包动画
    "Fu", --大红包动画
    "Long", --A动画
    "Wild", --K动画
    "BP",--Q动画
    "GOLD"--Q动画
};
self.GameResultType = {--游戏结果类型
    NORMAL = 0, --普通
    CYGG = 1, --财源滚滚
    JYMT = 2--金玉满堂
};
self.Line = {--连线结果
    { 5, 6, 7, 8, 9 }, --1
    { 0, 1, 2, 3, 4 }, --2
    { 10, 11, 12, 13, 14 }, --3
    { 0, 6, 12, 8, 4 }, --4
    { 10, 6, 2, 8, 14 }, --5
    { 0, 1, 7, 13, 14 }, --6
    { 10, 11, 7, 3, 4 }, --7
    { 5, 11, 12, 13, 9 }, --8
    { 5, 1, 2, 3, 9 }, --9
    { 0, 6, 7, 8, 4 }, --10
    { 10, 6, 7, 8, 14 }, --11
    { 0, 6, 2, 8, 4 }, --12
    { 10, 6, 12, 8, 14 }, --13
    { 5, 1, 7, 3, 9 }, --14
    { 5, 11, 7, 13, 9 }, --15
    { 5, 6, 2, 8, 9 }, --16
    { 5, 6, 12, 8, 9 }, --17
    { 0, 11, 2, 13, 4 }, --18
    { 10, 1, 12, 3, 14 }, --19
    { 5, 1, 12, 3, 9 }, --20
    { 5, 11, 2, 13, 9 }, --21
    { 0, 1, 12, 3, 4 }, --22
    { 10, 11, 2, 13, 14 }, --23
    { 0, 11, 12, 13, 4 }, --24
    { 10, 1, 2, 3, 14 }     --25
}