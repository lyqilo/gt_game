BQTP_DataConfig = {}

local self = BQTP_DataConfig;
self.ServerDataURL = "http://127.0.0.1:80/module27.json"
self.CHIPLISTCOUNT = 10;--下注列表长度
self.CAISHENCOUNT = 10;--财神个数
self.ALLIMGCOUNT = 15;--图标个数
self.ALLLINECOUNT = 50;--连线数量
self.COLUMNCOUNT = 5;--每列个数
self.SMALLIMGCOUNT = 4;--小游戏图标个数
self.SMALLROLLCOUNT = 24;--小游戏外围图标个数

self.rollInterval = 0.1;--每列转动间隔时间
self.rollSpeed = 6;--每列转动速度,可调节快慢
self.rollTime = 1;--转动时间
self.rollReboundRate = 0.3;--每列停止后反弹比例（0：立即停止，值越大反弹速度越慢）
self.rollDistance = 80;--回弹距离，数值越大距离越大
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
    "Item1", --che  1
    "Item2", -- xie 2
    "Item3", --红面罩  3
    "Item4", --蓝球场  4
    "Item5", --黄色对抗  5
    "Item6", --绿色裁判  6
    "Item7", --守门员  7
    "Item8", --蓝队员  8
    "Item9", --红色冲刺队员   9
    "Item10", --wild   10
    "Item11", --scatter   11
};
self.EffectTable = {
    "Item1", --che  1
    "Item2", -- xie 2
    "Item3", --红面罩  3
    "Item4", --蓝球场  4
    "Item5", --黄色对抗  5
    "Item6", --绿色裁判  6
    "Item7", --守门员  7
    "Item8", --蓝队员  8
    "Item9", --红色冲刺队员   9
    "Item10", --wild   10
    "Item11", --scatter   11
};
self.ItemPosList = {
    82.5, 249.5, 416.5, 583.5, 750.5, 917.5
}---418,251,-84,