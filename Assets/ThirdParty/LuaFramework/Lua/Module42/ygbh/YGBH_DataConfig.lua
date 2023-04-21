YGBH_DataConfig = {}

local self = YGBH_DataConfig;
self.CHIPLISTCOUNT = 10;--下注列表长度
self.CAISHENCOUNT = 10;--财神个数
self.ALLIMGCOUNT = 15;--图标个数
self.ALLLINECOUNT = 25;--连线数量
self.COLUMNCOUNT = 5;--每列个数
self.SMALLCHECKNUM = 8;--小游戏模块数量

self.rollInterval = 0.3;--每列转动间隔时间
self.rollSpeed = 20;--每列转动速度,可调节快慢
self.rollTime = 1;--转动时间
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
self.freeWaitTime = 30;--免费自动选择等待时间
self.smallRollDurationTime = 0.2;--小游戏转动间隔时间
self.smallRollMaxCycle = 2;--小游戏最大圈数
self.smallMoveSpeed = 0.05;

self.WinConfig = {--结果描述
    "Great fortune",
    "Sad, try again",
    "Sad, try again",
    "Good Luck"
};
self.autoList = {--自动旋转次数
    20, 50, 100, 10000
}
self.IconTable = {
    "Icon1", --至尊宝  1
    "Icon2", --孙悟空  2
    "Icon3", --唐僧  3
    "Icon4", --牛魔王  4
    "Icon5", --猪八戒  5
    "Icon6", --铃铛  6
    "Icon7", --A  7
    "Icon8", --K  8
    "Icon9", --Q   9
    "Icon10", --J   10
    "Icon11", --10   11
    "Icon12", --月光宝盒   12
    "Icon13", --紫霞wild   13
    "Icon14" --白晶晶wild   14
};
self.BeiLVTable = {
    { 300, 150, 100, 100, 80, 80, 12500, 300 },
    { 100, 100, 80, 80, 50, 25, 250, 125 },
    { 20, 20, 10, 5, 5, 5, 125, 20 },
    { 0, 0, 0, 0, 0, 0, 50, 0 },
}
self.EffectTable = {
    "ZZB", --至尊宝
    "SWK", --孙悟空
    "TS", --唐僧
    "Niu", --牛魔王
    "ZBJ", --猪八戒
    "LD", --铃铛
    "A",
    "K",
    "Q",
    "J",
    "10",
    "Scatter_Reward", --Scatter中奖
    "ZX", --紫霞wild
    "BJJ", --白晶晶wild
    "Scatter", --Scatter未中奖
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
    { 6, 2, 3, 4, 10 }, --6
    { 6, 12, 13, 14, 10 }, --7
    { 1, 2, 8, 14, 15 }, --8
    { 11, 12, 8, 4, 5 }, --9
    { 6, 12, 8, 4, 10 }, --10
    { 6, 2, 8, 14, 10 }, --11
    { 1, 7, 8, 9, 5 }, --12
    { 11, 7, 8, 9, 15 }, --13
    { 1, 7, 3, 9, 5 }, --14
    { 11, 7, 13, 9, 15 }, --15
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
--白晶晶光团跑动位置
self.LightPos = {
    { -354, 201, 0 }, --1
    { -177, 201, 0 }, --2
    { 0, 201, 0 }, --3
    { 177, 201, 0 }, --4
    { 354, 201, 0 }, --5
    { -354, 28.08, 0 }, --6
    { -177, 28.08, 0 }, --7
    { 0, 28.08, 0 }, --8
    { 177, 28.08, 0 }, --9
    { 354, 28.08, 0 }, --10
    { -354, -144.84, 0 }, --11
    { -177, -144.84, 0 }, --12
    { 0, -144.84, 0 }, --13
    { 177, -144.84, 0 }, --14
    { 354, -144.84, 0 }, --15
}
self.smallLighIconPos = { 15.5, 13, 0 };--小游戏旋转光标位置
self.smallLighIconAngle = 135;--小游戏旋转光标角度
self.ZPList = { 4, 5, 6, 1, 2, 3, 8, 7 };
self.rollPoss = {--相对于灯笼的图标位置
    { 144, -59, 0 },
    { 321, -59, 0 },
    { 498, -59, 0 },
    { 675, -59, 0 },
    { 852, -59, 0 },
    { 144, -231.92, 0 },
    { 321, -231.92, 0 },
    { 498, -231.92, 0 },
    { 675, -231.92, 0 },
    { 852, -231.92, 0 },
    { 144, -404.84, 0 },
    { 321, -404.84, 0 },
    { 498, -404.84, 0 },
    { 675, -404.84, 0 },
    { 852, -404.84, 0 },
}
function YGBH_DataConfig.GetEffectName(index)
    return self.EffectTable[index];
end