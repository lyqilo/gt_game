JSYC_DataConfig = {}

local self = JSYC_DataConfig;
self.ServerDataURL="http://127.0.0.1:80/module27.json"
self.CHIPLISTCOUNT = 5;--下注列表长度
self.CAISHENCOUNT = 10;--财神个数
self.ALLIMGCOUNT = 15;--图标个数
self.ALLLINECOUNT = 30;--连线数量
self.COLUMNCOUNT = 5;--每列个数

self.rollInterval = 0.2;--每列转动间隔时间
self.rollSpeed = 15;--每列转动速度,可调节快慢
self.rollTime = 1;--转动时间
self.rollReboundRate = 0.18;--每列停止后反弹比例（0：立即停止，值越大反弹速度越慢）
self.rollDistance = 1.5;--回弹距离，数值越大距离越大
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
self.autoNoRewardInterval = 1;--自动或免费未中奖间隔


self.autoList = {--自动旋转次数
    20, 50, 100, 10000
}
self.IconTable = {
    "J", --J  0
    "Q", --Q  1
    "K", --K  2
    "A", --A  3
    "Cup", --啤酒杯  4
    "Goblet", --高脚杯  5
    "HeadSet", --耳机  6
    "Record", --唱片  7
    "Jump", --jump wild   8
    "Ball" --球   9
};
self.EffectTable = {
    "J", --财神动画
    "Q", --wild动画
    "K", --wildx2动画
    "A", --金元宝动画
    "Cup", --银元宝动画
    "Goblet", --红包动画
    "HeadSet", --红包动画
    "Record", --中红包动画
    "Jump", --大红包动画
    "Ball" --A动画
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