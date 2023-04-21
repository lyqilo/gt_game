JPM_DataConfig = {}

local self = JPM_DataConfig;
self.ServerDataURL="http://127.0.0.1:80/module27.json"
self.CHIPLISTCOUNT = 10;--下注列表长度
self.CAISHENCOUNT = 10;--财神个数
self.ALLIMGCOUNT = 20;--图标个数
self.ALLLINECOUNT = 25;--连线数量
self.COLUMNCOUNT = 5;--每列个数

self.rollInterval = 0.2;--每列转动间隔时间
self.rollSpeed = 20;--每列转动速度,可调节快慢
self.rollTime = 1;--转动时间
self.rollReboundRate = 0.18;--每列停止后反弹比例（0：立即停止，值越大反弹速度越慢）
self.rollDistance = 1.5;--回弹距离，数值越大距离越大
self.winGoldChangeRate = 1.7;--得分跑分速率
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


self.autoList = {--自动旋转次数
    20, 50, 100, 10000
}
self.IconTable = {
    "HairClasp", --J  0
    "DD", --Q  1
    "PZ", --K  2
    "MH", --梅花  3
    "XZ", --箱子  4
    "JIU", --酒  5
    "JZ", --耳机  6
    "R1", --唱片  7
    "R2", --jump wild   8
    "R3", --球   9
    "TU",--球   10
    "Book", --球   11
    "NAN" --球   12
};
self.EffectTable = {
    "HairClasp", --J  0
    "DD", --Q  1
    "PZ", --K  2
    "MH", --梅花  3
    "XZ", --箱子  4
    "JIU", --酒  5
    "JZ", --耳机  6
    "R1", --唱片  7
    "R2", --jump wild   8
    "R3", --球   9
    "TU",--球   10
    "Book", --球   11
    "NAN" --球   12
};
self.GameResultType = {--游戏结果类型
    NORMAL = 0, --普通
    CYGG = 1, --财源滚滚
    JYMT = 2--金玉满堂
};
self.Line = {--连线结果
    { 6, 7, 8, 4, 10 }, --1
    { 6, 7, 8, 9, 15 }, --2
    { 6, 7, 13, 9, 15 }, --3
    { 6, 7, 13, 14, 20 }, --4
    { 6, 7, 18, 9, 10 }, --5
    { 6, 17, 18, 19, 10 }, --6

    { 11, 7, 8, 9, 10 }, --7
    { 11, 7, 13, 9, 10 }, --8
    { 11, 7, 13, 14, 20 }, --9
    { 11, 7, 18, 9, 15 }, --10
    { 11, 12, 18, 14, 15 }, --11
    { 11, 2, 8, 4, 15 }, --12

    { 16, 2, 13, 4, 15 }, --13
    { 16, 2, 18, 4, 15 }, --14
    { 16, 2, 13, 19, 15 }, --15

    { 16, 17, 18, 14, 15 }, --16
    { 16, 17, 13, 4, 10 }, --17
    { 16, 17, 13, 19, 20 }, --18

    { 16, 17, 8, 19, 20 }, --19
    { 16, 12, 18, 19, 20 }, --20
    { 16, 7, 13, 14, 10 }, --21
    { 16, 7, 8, 9, 20 }, --22
    { 16, 2, 18, 4, 20 }, --23
    { 16, 2, 13, 19, 10 }, --24

    { 16, 2, 8, 4, 20 }, --25
}