AJDMX_DataConfig = {}

local self = AJDMX_DataConfig;
self.CHIPLISTCOUNT = 10;--下注列表长度
self.CAISHENCOUNT = 10;--财神个数
self.ALLIMGCOUNT = 15;--图标个数
self.ALLLINECOUNT = 25;--连线数量
self.COLUMNCOUNT = 5;--每列个数
self.SMALLCHECKNUM = 8;--小游戏模块数量

self.rollInterval = 0.3;--每列转动间隔时间
self.rollSpeed = 16;--每列转动速度,可调节快慢
self.rollTime = 1.5;--转动时间
self.rollReboundRate = 0.1;--每列停止后反弹比例（0：立即停止，值越大反弹速度越慢）
self.rollDistance = 1.2;--回弹距离，数值越大距离越大
self.winBigGoldChangeRate = 3;--得分跑分速率
self.winGoldChangeRate = 1.5;--得分跑分速率
self.selfGoldChangeRate = 2;--自身跑分速率
self.caijinGoldChangeRate = 10;--彩金跑分速率
self.freeLoadingShowTime = 1;--中免费展示时间
self.smallGameLoadingShowTime = 1;--中小游戏展示时间
self.REQCaiJinTime = 5;--请求彩金频率
self.lineAllShowTime = 1.5;--总连线展示时间
self.cyclePlayLineTime = 2;--连线轮播展示时间
self.waitShowLineTime = 0.3;--等待展示连线奖励时间
self.autoRewardInterval = 2;--自动或免费中奖间隔
self.autoNoRewardInterval = 0.5;--自动或免费未中奖间隔
self.addSpeedTime = 3;--加速时间
self.freeWaitTime = 5;--免费自动选择等待时间
self.smallRollDurationTime = 0.2;--小游戏转动间隔时间
self.smallRollMaxCycle = 2;--小游戏最大圈数
self.smallMoveSpeed = 0.05;

self.WinConfig = {--结果描述
    "Hope you win the prize",
};
self.autoList = {--自动旋转次数
    20, 50, 100, 10000
}
self.IconTable = {
    "Icon0", --至尊宝  1
    "Icon1", --孙悟空  2
    "Icon2", --唐僧  3
    "Icon3", --牛魔王  4
    "Icon4", --猪八戒  5
    "Icon5", --铃铛  6
    "Icon6", --A  7
    "Icon7", --K  8
    "Icon8", --Q   9
    "Icon9", --J   10
    "Icon10", --10   11
    "Icon11", --10   11
    "Icon12", --10   11
};

self.EffectTable = {
    "Icon0", --至尊宝  1
    "Icon1", --孙悟空  2
    "Icon2", --唐僧  3
    "Icon3", --牛魔王  4
    "Icon4", --猪八戒  5
    "Icon5", --铃铛  6
    "Icon6", --A  7
    "Icon7", --K  8
    "Icon8", --Q   9
    "Icon9", --J   10
    "Icon10", --10   11
    "Icon11", --10   11
    "Icon12", --10   11
};

self.BeiLVTable = {
    { 25, 25, 25, 40, 50, 80, 250, 500 },
    { 10, 10, 10, 20, 25, 50, 100, 250 },
    { 3,  3,  3,  10, 10, 15, 25,  50 },
}

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
    { 6, 2, 3, 4, 10 }, --6
    { 6, 12, 13, 14, 10 }, --7
    { 1, 2, 8, 14, 15 }, --8
    { 11, 12, 8, 4, 5 }, --9
    { 6, 2, 8, 4, 10 }, --10
    { 6, 12, 8, 14, 10 }, --11
    { 1, 7, 8, 9, 15 }, --12
    { 11, 7, 8, 9, 5 }, --13
    { 6, 7, 3, 9, 15 }, --14
    { 6, 7, 13, 9, 5 }, --15
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
}

function AJDMX_DataConfig.GetEffectName(index)
    return self.EffectTable[index];
end