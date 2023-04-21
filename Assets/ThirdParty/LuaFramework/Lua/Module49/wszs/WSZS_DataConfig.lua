WSZS_DataConfig = {}

local self = WSZS_DataConfig;
self.ServerDataURL = "http://127.0.0.1:80/module27.json"
self.CHIPLISTCOUNT = 5;--下注列表长度
self.CAISHENCOUNT = 10;--财神个数
self.ALLIMGCOUNT = 15;--图标个数
self.ALLLINECOUNT = 12;--连线数量
self.COLUMNCOUNT = 5;--每列个数
self.MIANJUCOUNT = 4;--面具类型数量

self.rollInterval = 0.3;--每列转动间隔时间
self.rollSpeed = 16;--每列转动速度,可调节快慢
self.rollTime = 1.5;--转动时间
self.rollReboundRate = 0.18;--每列停止后反弹比例（0：立即停止，值越大反弹速度越慢）
self.rollDistance = 0;--回弹距离，数值越大距离越大
self.winGoldNormalChangeRate = 1;--得分跑分速率
self.winFreeChangeRate = 3;--得分跑分速率
self.winGoldBigChangeRate = 3;--得分跑分速率
self.selfGoldChangeRate = 2;--自身跑分速率
self.caijinGoldChangeRate = 10;--彩金跑分速率
self.freeLoadingShowTime = 2.5;--中免费展示时间
self.smallGameLoadingShowTime = 1;--中小游戏展示时间
self.REQCaiJinTime = 5;--请求彩金频率
self.lineAllShowTime = 2;--总连线展示时间
self.cyclePlayLineTime = 2;--连线轮播展示时间
self.waitShowLineTime = 0.3;--等待展示连线奖励时间
self.autoRewardInterval = 2;--自动或免费中奖间隔
self.autoNoRewardInterval = 0.3;--自动或免费未中奖间隔
self.addSpeedTime = 1.8;

self.WinConfig = {--结果描述
    "Great fortune",
    "Wish you the best!",
    "Wish you the best!",
    "Wish you the best!",
    "Daily Fortune",
    "Good luck next time"
};
self.IconPos = { 425.15, 340.15, 255.15, 170.15, 85.15, 0.15, -84.85, -168.85, -254.85, -339.85, -424.85, -509.85, -594.85 };
self.brokenPos = -430;
self.autoList = {--自动旋转次数
    10000, 100, 50, 20
}
self.oddlist = {
    { 4, 10, 20, 30, 60, 120, 200, 0, 0, 0 },
    { 10, 20, 30, 40, 50, 100, 200, 300, 0, 0 },
    { 20, 30, 40, 50, 100, 200, 300, 340, 400, 0 },
    { 30, 40, 50, 60, 120, 240, 300, 340, 400, 480 },
}
self.lineoddlist = {
    { 6, 6, 12, 12, 18, 6 },
    { 6, 6, 12, 12, 18, 18, 18, 18, 24, 24, 30, 24 },
    { 12, 12, 18, 24, 24, 36, 36, 36, 42, 48, 48 },
    { 18, 18, 30, 48, 48, 60, 60, 60, 66, 72, 78 }
}
self.IconTable = {
    "Item1", --J
    "Item2", -- Q
    "Item3", -- K
    "Item4", -- A
    "Item5", -- 卷轴
    "Item6", -- 武士刀
    "Item7", -- 面具1
    "Item8", -- 面具2
    "Item9", -- 面具3
    "Item10", -- 面具4
    "Item11", -- 特殊图标
    "Item12", -- 侍
};
self.EffectTable = {
    "Item1", --J
    "Item2", -- Q
    "Item3", -- K
    "Item4", -- A
    "Item5", -- 卷轴
    "Item6", -- 武士刀
    "Item7", -- 面具1
    "Item8", -- 面具2
    "Item9", -- 面具3
    "Item10", -- 面具4
    "Item11", -- 特殊图标
    "Item12", -- 侍
};
self.AnimSort = { 11, 6, 1, 12, 7, 2, 13, 8, 3, 14, 9, 4, 15, 10, 5 };