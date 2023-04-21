Module13_DataConfig = {}

local self = Module13_DataConfig;
self.ServerDataURL="http://127.0.0.1:80/module27.json"
self.CHIPLISTCOUNT = 5;--下注列表长度
self.CAISHENCOUNT = 10;--财神个数
self.ALLIMGCOUNT = 15;--图标个数
self.ALLLINECOUNT = 9;--连线数量
self.COLUMNCOUNT = 5;--每列个数
self.SELECTSMALLCOUNT = 5;--小游戏可选择个数


self.rollInterval = 0.15;--每列转动间隔时间
self.rollSpeed = 15;--每列转动速度,可调节快慢
self.rollTime = 2;--转动时间
self.rollReboundRate = 0.25;--每列停止后反弹比例（0：立即停止，值越大反弹速度越慢）
self.rollDistance = 2;--回弹距离，数值越大距离越大
self.winGoldChangeRate = 1.7;--得分跑分速率
self.selfGoldChangeRate = 10;--自身跑分速率
self.caijinGoldChangeRate = 10;--彩金跑分速率
self.freeLoadingShowTime = 1;--中免费展示时间
self.smallGameLoadingShowTime = 1;--中小游戏展示时间
self.REQCaiJinTime = 5;--请求彩金频率
self.lineAllShowTime = 1.5;--总连线展示时间
self.cyclePlayLineTime = 2;--连线轮播展示时间
self.waitShowLineTime = 0.3;--等待展示连线奖励时间
self.autoRewardInterval = 2;--自动或免费中奖间隔
self.autoNoRewardInterval = 0.5;--自动或免费未中奖间隔
self.TS_TIME=2; --特殊奖励的时间
self.jiugong_start_value=20--
self.full_start_value=40--
self.FireModeTime=2.3--

self.autoList = {--自动旋转次数
    10000,100,50,20
}
self.IconTable = {
    "ItemWG", --ht  0
    "ItemHX", --ht  1
    "ItemH", --mh  2
    "ItemLH", --fk  3
    "ItemA", --a  4
    "ItemK", --k  5
    "ItemQ", --q  6
    "ItemJ", --j  0
    "ItemWild", --wild   8
    "ItemFree", --free   9
};
self.EffectTable = {
    "WG", --大红包动画
    "WX", --中红包动画
    "XH", --红包动画
    "Hu", --银元宝动画
    "A", --金元宝动画
    "K", --wildx2动画
    "Q", --wild动画
    "J", --财神动画
    "Wild", --A动画
    "Free", --K动画
};
self.GameResultType = {--游戏结果类型
    NORMAL = 0, --普通
    CYGG = 1, --财源滚滚
    JYMT = 2--金玉满堂
};
self.Line = {--连线结果
    { 1, 2, 3, 4, 5 }, --1
    { 6, 7, 8, 9, 10 }, --2
    { 11, 12, 13, 14, 15 }, --3
    { 1, 7, 13, 9, 5 }, --4
    { 11, 7, 3, 9, 15 }, --5
    { 1, 2, 8, 14, 15 }, --6
    { 11, 12, 8, 4, 5 }, --7
    { 6, 2, 3, 4, 10 }, --8
    { 6, 12, 13, 14, 10 }, --9
}