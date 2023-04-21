Module27_DataConfig = {}

local self = Module27_DataConfig;
self.ServerDataURL="http://127.0.0.1:80/module27.json"
self.CHIPLISTCOUNT = 5;--下注列表长度
self.CAISHENCOUNT = 10;--财神个数
self.ALLIMGCOUNT = 15;--图标个数
self.ALLLINECOUNT = 25;--连线数量
self.COLUMNCOUNT = 5;--每列个数

self.rollInterval = 0.15;--每列转动间隔时间
self.rollSpeed = 15;--每列转动速度,可调节快慢
self.rollTime = 2;--转动时间
self.rollReboundRate = 0.25;--每列停止后反弹比例（0：立即停止，值越大反弹速度越慢）
self.rollDistance = 2;--回弹距离，数值越大距离越大
self.winGoldChangeRate = 2;--得分跑分速率
self.selfGoldChangeRate = 2;--自身跑分速率
self.caijinGoldChangeRate = 10;--彩金跑分速率
self.freeLoadingShowTime = 1;--中免费展示时间
self.smallGameLoadingShowTime = 1;--中小游戏展示时间
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
    "Itemcaishen0", --财神  0
    "ItemWILD", --wild  1
    "Item2WILD", --wildx2  2
    "Itemyuanbao2", --金元宝  3
    "Itemyuanbao1", --银元宝  4
    "Itemhongbao1", --小红包  5
    "Itemhongbao2", --中红包  6
    "Itemhongbao3", --大红包  7
    "ItemA", --A   8
    "ItemK", --K   9
    "ItemQ", --Q   10
};
self.EffectTable = {
    "CaiShen", --财神动画
    "Wild", --wild动画
    "Wild2", --wildx2动画
    "Jinding", --金元宝动画
    "Yinding", --银元宝动画
    "Hongbao", --红包动画
    "Hongbao2", --中红包动画
    "Hongbao3", --大红包动画
    "A", --A动画
    "K", --K动画
    "Q"--Q动画
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