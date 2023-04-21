XYSGJ_DataConfig = {}

local self = XYSGJ_DataConfig;
self.ServerDataURL = "http://127.0.0.1:80/module27.json"
self.CHIPLISTCOUNT = 5;--下注列表长度
self.CAISHENCOUNT = 10;--财神个数
self.ALLIMGCOUNT = 9;--图标个数
self.ALLLINECOUNT = 5;--连线数量
self.COLUMNCOUNT = 3;--每列个数

self.rollInterval = 0.3;--每列转动间隔时间
self.rollSpeed = 16;--每列转动速度,可调节快慢
self.rollTime = 1.5;--转动时间
self.rollReboundRate = 0.18;--每列停止后反弹比例（0：立即停止，值越大反弹速度越慢）
self.rollDistance = 0;--回弹距离，数值越大距离越大
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
self.addSpeedTime = 2.5

self.autoList = {--自动旋转次数
    20, 50, 100, 10000
}
self.IconTable = {
    "yt", --J  0
    "pg", --Q  1
    "nm", --K  2
    "pt", --梅花  3
    "bar", --箱子  4
    "3bar", --酒  5
    "ld", --耳机  6
    "bouns", --唱片  7
    "17", --jump wild   8
    "27", --球   9
    "37", --球   10
};
self.EffectTable = {
    "yt", --J  0
    "pg", --Q  1
    "nm", --K  2
    "pt", --梅花  3
    "bar", --箱子  4
    "3bar", --酒  5
    "ld", --耳机  6
    "bouns", --唱片  7
    "17", --jump wild   8
    "27", --球   9
    "37", --球   10
};
self.GameResultType = {--游戏结果类型
    NORMAL = 0, --普通
    CYGG = 1, --财源滚滚
    JYMT = 2--金玉满堂
};
self.Line = {--连线结果
    { 1, 2, 3 }, --1
    { 4, 5, 6 }, --2
    { 7, 8, 9 }, --3
    { 1, 5, 9 }, --4
    { 7, 5, 3 }, --5
}