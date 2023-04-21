MCDZZ_DataConfig = {}

local self = MCDZZ_DataConfig;
self.ServerDataURL="http://127.0.0.1:80/module27.json"
self.CHIPLISTCOUNT = 5;--下注列表长度
self.CAISHENCOUNT = 10;--财神个数
self.ALLIMGCOUNT = 20;--图标个数
self.ALLLINECOUNT = 50;--连线数量
self.COLUMNCOUNT = 5;--每列个数

self.ColumnCount=5 --lie
self.RowCount=4 --hang


self.rollInterval = 0.3;--每列转动间隔时间
self.rollSpeed = 16;--每列转动速度,可调节快慢
self.rollTime = 1.5;--转动时间
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
self.winBigGoldChangeRate = 3;--得分跑分速率
self.addSpeedTime = 2;--加速时间

self.WinConfig = {--结果描述
    "恭喜发财",
    "再接再厉(^V^)",
    "很遗憾QAQ",
    "大奖就要来了"
};

self.autoList = {--自动旋转次数
    20, 50, 100, 10000
}
self.IconTable = {
    "FK", --J  0
    "MH", --Q  1
    "HT", --K  2
    "HT1", --梅花  3
    "YC", --箱子  4
    "NN", --酒  5
    "DLM", --耳机  6
    "TD", --唱片  7
    "BM", --jump wild   8
    "XH", --球   9
    "EH",--球   10
    "WILD", --球   12
    "SCATTER", --球   11
};
self.EffectTable = {
    "FK", --J  0
    "MH", --Q  1
    "HT", --K  2
    "HT1", --梅花  3
    "YC", --箱子  4
    "NN", --酒  5
    "DLM", --耳机  6
    "TD", --唱片  7
    "BM", --jump wild   8
    "XH", --球   9
    "EH",--球   10
    "WILD", --球   12
    "SCATTER", --球   11
};
self.GameResultType = {--游戏结果类型
    NORMAL = 0, --普通
    CYGG = 1, --财源滚滚
    JYMT = 2--金玉满堂
};
self.BeiLVTable = {
    { 50, 50, 50,  75, 75, 100},
    { 10, 15, 20,  25, 50, 50 },
    { 5,  5,  10,  15, 15, 15 },
    { 0,  0,  0,   0,  5,  5  },
}
self.Line = {--连线结果
    { 1,  2,  3,  4,  5  }, --1
    { 6,  7,  8,  9,  10 }, --2
    { 11, 12, 13, 14, 15 }, --3
    { 16, 17, 18, 19, 20 }, --4
    { 1,  2,  8,  4,  5  }, --5
    { 1,  2,  13, 4,  5  }, --6
    { 1,  2,  18, 4,  5  }, --7
    { 6,  7,  3,  9,  10 }, --8
    { 6,  7,  13, 9,  10 }, --9
    { 6,  7,  18, 9,  10 }, --10
    { 11, 12, 3,  14, 15 }, --11
    { 11, 12, 8,  14, 15 }, --12
    { 11, 12, 18, 14, 15 }, --13
    { 16, 17, 3,  19, 20 }, --14
    { 16, 17, 8,  19, 20 }, --15
    { 16, 17, 13, 19, 20 }, --16
    { 1,  7,  8,  9,  5  }, --17
    { 1,  12, 13, 14, 5  }, --18
    { 1,  17, 18, 19, 5  }, --19
    { 6,  2,  3,  4,  10 }, --20
    { 6,  12, 13, 14, 10 }, --21
    { 6,  17, 18, 19, 10 }, --22
    { 11, 2,  3,  4,  15 }, --23
    { 11, 7,  8,  9,  15 }, --24
    { 11, 17, 18, 19, 15 }, --25
    { 16, 2,  3,  4,  20 }, --26
    { 16, 7,  8,  9,  20 }, --27
    { 16, 12, 13, 14, 20 }, --28
    { 1,  7,  13, 9,  5  }, --29
    { 6,  12, 18, 14, 10 }, --30
    { 11, 17, 3,  19, 15 }, --31
    { 16, 2,  8,  4,  20 }, --32
    { 1,  2,  8,  9,  10 }, --33
    { 1,  2,  13, 14, 15 }, --34
    { 1,  2,  18, 19, 20 }, --35
    { 6,  7,  3,  4,  5  }, --36
    { 6,  7,  13, 14, 15 }, --37
    { 6,  7,  18, 19, 20 }, --38
    { 11, 12, 3,  4,  5  }, --39
    { 11, 12, 8,  9,  10 }, --40
    { 11, 12, 18, 19, 20 }, --41
    { 16, 17, 3,  4,  5  }, --42
    { 16, 17, 8,  9,  10 }, --43
    { 16, 17, 13, 14, 15 }, --44
    { 1,  2,  3,  9,  10 }, --45
    { 6,  7,  8,  14, 15 }, --46
    { 11, 12, 13, 19, 20 }, --47
    { 16, 17, 13, 4,  5  }, --48
    { 1,  2,  3,  4,  10 }, --49
    { 6,  7,  8,  9,  15 }, --50
}
function MCDZZ_DataConfig.GetEffectName(index)
    return self.EffectTable[index];
end