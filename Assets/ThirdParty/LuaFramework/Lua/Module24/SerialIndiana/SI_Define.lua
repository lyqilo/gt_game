require("Common.ExternalLibs")
 --==========================111
local id_creator=ID_Creator(1);

--一共做多少关
SI_MAX_STAGE  = 3;

--龙珠关卡
SI_DRAGON_STAGE  = 4;

--每关砖块数
SI_STAGE_BRICKS = 15;

--最大线数
SI_MULTIPLE_MAX = 5;

--龙珠关卡
SI_MAX_DRAGON_STAGE = 5;

--龙珠关卡槽的个数
SI_MAX_DRAGON_SLOT_COUNT = 5;

--每关最小所需的连线数
SI_MIN_STAGE_COUNT = {
    [id_creator(1)] = 4,
    [id_creator()]  = 5,
    [id_creator()]  = 6,
};

--每关的数量
SI_STAGE_DATA = {
    [id_creator(1)] = { stage=1, xCount=4, yCount=4, minCount=4, firstBet=10, betInterval=10, betCount=5, },
    [id_creator()]  = { stage=2, xCount=5, yCount=5, minCount=5, firstBet=100, betInterval=10, betCount=5,},
    [id_creator()]  = { stage=3, xCount=6, yCount=6, minCount=6, firstBet=100, betInterval=10, betCount=5,},
    --获取押注
    getBet=function (_data,stage,index)
        if stage>SI_MAX_STAGE then
            stage = SI_MAX_STAGE;
        end
        if stage<1 then
            stage = 1;
        end
        if index>_data[stage].betCount-1 then
            index = _data[stage].betCount-1;
        end
        if index<0 then
            index = 0;
        end
        return _data[stage].firstBet + (index)*_data[stage].betInterval;
    end,
    --获取押注个数
    getBetCount = function(_data,stage)
        if stage>SI_MAX_STAGE then
            stage = SI_MAX_STAGE;
        end
        if stage<1 then
            stage = 1;
        end
        return _data[stage].betCount;
    end ,
};

--每关的奖励个数
SI_DRAGON_ITEMS_COUNT_PRE_STAGE = 5;

local item_id_creator =ID_Creator(1);

--龙珠关进入所需的分数
SI_DRAGON_STAGE_DATA = {
    [id_creator(1)] = {
        stage     = 1,
        needExp   = 2000,
        ballCount = 1,
        items = {
            [item_id_creator(1)]    = { i8_type=1,i32_count=2,},
            [item_id_creator()]     = { i8_type=1,i32_count=2,},
            [item_id_creator()]     = { i8_type=1,i32_count=2,},
            [item_id_creator()]     = { i8_type=1,i32_count=2,},
            [item_id_creator()]     = { i8_type=1,i32_count=2,},
        },
    },
    [id_creator()] = {
        stage     = 2,
        needExp = 5000,
        ballCount = 1,
        items = {
            [item_id_creator(1)]    = { i8_type=1,i32_count=2,},
            [item_id_creator()]     = { i8_type=1,i32_count=2,},
            [item_id_creator()]     = { i8_type=1,i32_count=2,},
            [item_id_creator()]     = { i8_type=1,i32_count=2,},
            [item_id_creator()]     = { i8_type=1,i32_count=2,},
        },
    },
    [id_creator()] = {
        stage     = 3,
        needExp = 10000,
        ballCount = 1,
        items = {
            [item_id_creator(1)]    = { i8_type=1,i32_count=2,},
            [item_id_creator()]     = { i8_type=1,i32_count=2,},
            [item_id_creator()]     = { i8_type=1,i32_count=2,},
            [item_id_creator()]     = { i8_type=1,i32_count=2,},
            [item_id_creator()]     = { i8_type=1,i32_count=2,},
        },
    },
    [id_creator()] = {
        stage     = 4,
        needExp = 25000,
        ballCount = 1,
        items = {
            [item_id_creator(1)]    = { i8_type=1,i32_count=2,},
            [item_id_creator()]     = { i8_type=1,i32_count=2,},
            [item_id_creator()]     = { i8_type=1,i32_count=2,},
            [item_id_creator()]     = { i8_type=1,i32_count=2,},
            [item_id_creator()]     = { i8_type=1,i32_count=2,},
        },
    },
    [id_creator()] = {
        stage     = 5,
        needExp = 50000,
        ballCount = 1,
        items = {
            [item_id_creator(1)]    = { i8_type=1,i32_count=2,},
            [item_id_creator()]     = { i8_type=1,i32_count=2,},
            [item_id_creator()]     = { i8_type=1,i32_count=2,},
            [item_id_creator()]     = { i8_type=1,i32_count=2,},
            [item_id_creator()]     = { i8_type=1,i32_count=2,},
        },
    },
    --获取对应的等级信息
    getDragonStageInfo=function(_data,_exp)
        local stage,leftExp,nextNeedExp=1,0,0;
        for i=#_data,1,-1 do
            if _data[i].needExp<=_exp then
                stage = i;
                leftExp = _exp - _data[i].needExp;
                if i>=#_data then
                    nextNeedExp = 0;
                else
                    nextNeedExp = _data[i+1].needExp - _data[i].needExp;
                end
                break;
            end
        end
        return stage,leftExp,nextNeedExp;
    end ,
    getDragonStage=function(_data,_exp)
        local stage=1;
        for i=#_data,1,-1 do
            if _data[i].needExp<=_exp then
                stage = i;
                break;
            end
        end
        return stage;
    end,
};

--房间数据
SI_ROOM_DATA = {
   baseBet      = 10,
   stages       = SI_STAGE_DATA,
   dragonStages = SI_DRAGON_STAGE_DATA,
};



--对象类型
SI_OBJ_CLASS = {
    Stone   = id_creator(1), --宝石
    Effect  = id_creator(),  --特效
    Brick   = id_creator(),  --砖头

};

SI_EFFECT_TYPE = {
    Brick_Disappear =  id_creator(1),  --砖头消失
    Brick2_Disappear=  id_creator(),   --竖砖消失
    Stone_Disappear =  id_creator(),   --宝石消失
    Comb_Fire       =  id_creator(),   --组合火
    Logo            =  id_creator(),   --logo
};


SI_MAX_X_COUNT = 6;
SI_MAX_Y_COUNT = 6;

--宝石类型
SI_STONE_TYPE = {
    Null        = id_creator(0),
    WhiteJade   = id_creator(1),    --白玉
    GreenJade   = id_creator(),     --碧玉
    BlackJade   = id_creator(),     --墨玉
    Agate       = id_creator(),     --玛瑙
    LynxStone   = id_creator(),     --琥珀
    Smaragdos   = id_creator(),     --祖母绿
    CatEye      = id_creator(),     --猫眼石
    Amethyst    = id_creator(),     --紫水晶
    Jade        = id_creator(),     --翡翠
    Pearl       = id_creator(),     --珍珠
    Ruby        = id_creator(),     --红宝石
    Beryl       = id_creator(),     --绿宝石
    YellowJewel = id_creator(),     --黄宝石
    Sapphire    = id_creator(),     --蓝宝石
    Diamond     = id_creator(),     --钻石
    Max         = id_creator(),     --最大值
    Drill       = id_creator(100),  --钻头
};

--音乐类型
SI_MUSIC_TYPE = {
    StoneFallDown_BG_1  = id_creator(1),
    StoneFallDown_BG_2  = id_creator(),
    StoneFallDown_BG_3  = id_creator(),
    StoneFallDown_BG    = id_creator(),
    Dragon_BG           = id_creator(),
    Stone_FallDown      = id_creator(),
    Stone_Disappear     = id_creator(),
    Stone_Clear         = id_creator(), --宝石清空音效
    Brick_Disappear     = id_creator(),
    Drill_Disappear     = id_creator(),
    DragonBallFallDown  = id_creator(),
    DragonUpgrade       = id_creator(),
    FireBurnning        = id_creator(),  --火炉燃烧
};


--宝石连线的倍数
local count_creator=ID_Creator(1);
SI_STONE_PRICE = {
    [SI_STONE_TYPE.Null] = {
    },
    [SI_STONE_TYPE.WhiteJade]= {
        [count_creator(SI_MIN_STAGE_COUNT[1])] = 0.2,
        [count_creator()] = 0.4,
        [count_creator()] = 0.5,
        [count_creator()] = 0.8,
        [count_creator()] = 1,
        [count_creator()] = 2,
        [count_creator()] = 3,
        [count_creator()] = 5,
        [count_creator()] = 10,
        [count_creator()] = 20,
        [count_creator()] = 40,
        [count_creator()] = 1500,
    },
    [SI_STONE_TYPE.GreenJade]= {
        [count_creator(SI_MIN_STAGE_COUNT[1])] = 0.4,
        [count_creator()] = 0.5,
        [count_creator()] = 1,
        [count_creator()] = 2,
        [count_creator()] = 3,
        [count_creator()] = 5,
        [count_creator()] = 10,
        [count_creator()] = 25,
        [count_creator()] = 50,
        [count_creator()] = 75,
        [count_creator()] = 80,
        [count_creator()] = 1500,
    },
    [SI_STONE_TYPE.BlackJade]= {
        [count_creator(SI_MIN_STAGE_COUNT[1])] = 0.5,
        [count_creator()] = 1,
        [count_creator()] = 2,
        [count_creator()] = 4,
        [count_creator()] = 8,
        [count_creator()] = 16,
        [count_creator()] = 50,
        [count_creator()] = 100,
        [count_creator()] = 200,
        [count_creator()] = 500,
        [count_creator()] = 600,
        [count_creator()] = 1500,
    },
    [SI_STONE_TYPE.Agate]= {
        [count_creator(SI_MIN_STAGE_COUNT[1])] = 1,
        [count_creator()] = 3,
        [count_creator()] = 5,
        [count_creator()] = 6,
        [count_creator()] = 10,
        [count_creator()] = 75,
        [count_creator()] = 100,
        [count_creator()] = 1000,
        [count_creator()] = 2000,
        [count_creator()] = 5000,
        [count_creator()] = 6000,
        [count_creator()] = 1500,
    },
    [SI_STONE_TYPE.LynxStone]= {
        [count_creator(SI_MIN_STAGE_COUNT[1])] = 2,
        [count_creator()] = 5,
        [count_creator()] = 10,
        [count_creator()] = 50,
        [count_creator()] = 100,
        [count_creator()] = 200,
        [count_creator()] = 500,
        [count_creator()] = 2000,
        [count_creator()] = 5000,
        [count_creator()] = 6000,
        [count_creator()] = 8000,
        [count_creator()] = 1500,
    },
    [SI_STONE_TYPE.Smaragdos]= {
        [count_creator(SI_MIN_STAGE_COUNT[2])] = 0.2,
        [count_creator()] = 0.4,
        [count_creator()] = 0.5,
        [count_creator()] = 0.8,
        [count_creator()] = 1,
        [count_creator()] = 2,
        [count_creator()] = 3,
        [count_creator()] = 5,
        [count_creator()] = 10,
        [count_creator()] = 20,
        [count_creator()] = 45,
        [count_creator()] = 1500,
    },
    [SI_STONE_TYPE.CatEye]= {
        [count_creator(SI_MIN_STAGE_COUNT[2])] = 0.4,
        [count_creator()] = 0.5,
        [count_creator()] = 1,
        [count_creator()] = 2,
        [count_creator()] = 3,
        [count_creator()] = 5,
        [count_creator()] = 10,
        [count_creator()] = 25,
        [count_creator()] = 50,
        [count_creator()] = 75,
        [count_creator()] = 100,
        [count_creator()] = 1500,
    },
    [SI_STONE_TYPE.Amethyst]= {
        [count_creator(SI_MIN_STAGE_COUNT[2])] =0.5,
        [count_creator()] = 1,
        [count_creator()] = 2,
        [count_creator()] = 4,
        [count_creator()] = 8,
        [count_creator()] = 16,
        [count_creator()] = 50,
        [count_creator()] = 100,
        [count_creator()] = 200,
        [count_creator()] = 500,
        [count_creator()] = 700,
        [count_creator()] = 1500,
    },
    [SI_STONE_TYPE.Jade]= {
        [count_creator(SI_MIN_STAGE_COUNT[2])] = 1,
        [count_creator()] = 3,
        [count_creator()] = 5,
        [count_creator()] = 6,
        [count_creator()] = 10,
        [count_creator()] = 75,
        [count_creator()] = 100,
        [count_creator()] = 1000,
        [count_creator()] = 2000,
        [count_creator()] = 5000,
        [count_creator()] = 7000,
        [count_creator()] = 1500,
    },
    [SI_STONE_TYPE.Pearl]= {
        [count_creator(SI_MIN_STAGE_COUNT[2])] = 2,
        [count_creator()] = 5,
        [count_creator()] = 10,
        [count_creator()] = 50,
        [count_creator()] = 100,
        [count_creator()] = 200,
        [count_creator()] = 500,
        [count_creator()] = 2000,
        [count_creator()] = 5000,
        [count_creator()] = 8000,
        [count_creator()] = 10000,
        [count_creator()] = 1500,
    },
    [SI_STONE_TYPE.Ruby]= {
        [count_creator(SI_MIN_STAGE_COUNT[3])] = 0.2,
        [count_creator()] = 0.4,
        [count_creator()] = 0.5,
        [count_creator()] = 0.8,
        [count_creator()] = 1,
        [count_creator()] = 2,
        [count_creator()] = 3,
        [count_creator()] = 5,
        [count_creator()] = 10,
        [count_creator()] = 20,
        [count_creator()] = 50,
        [count_creator()] = 1500,
    },
    [SI_STONE_TYPE.Beryl]= {
        [count_creator(SI_MIN_STAGE_COUNT[3])] = 0.4,
        [count_creator()] = 0.5,
        [count_creator()] = 1,
        [count_creator()] = 2,
        [count_creator()] = 3,
        [count_creator()] = 5,
        [count_creator()] = 10,
        [count_creator()] = 25,
        [count_creator()] = 50,
        [count_creator()] = 75,
        [count_creator()] = 100,
        [count_creator()] = 1500,
    },
    [SI_STONE_TYPE.YellowJewel]= {
        [count_creator(SI_MIN_STAGE_COUNT[3])] = 0.5,
        [count_creator()] = 1,
        [count_creator()] = 2,
        [count_creator()] = 4,
        [count_creator()] = 8,
        [count_creator()] = 16,
        [count_creator()] = 50,
        [count_creator()] = 100,
        [count_creator()] = 200,
        [count_creator()] = 500,
        [count_creator()] = 800,
        [count_creator()] = 1500,
    },
    [SI_STONE_TYPE.Sapphire]= {
        [count_creator(SI_MIN_STAGE_COUNT[3])] = 1,
        [count_creator()] = 3,
        [count_creator()] = 5,
        [count_creator()] = 6,
        [count_creator()] = 10,
        [count_creator()] = 75,
        [count_creator()] = 100,
        [count_creator()] = 1000,
        [count_creator()] = 2000,
        [count_creator()] = 5000,
        [count_creator()] = 8000,
        [count_creator()] = 1500,
    },
    [SI_STONE_TYPE.Diamond]= {
        [count_creator(SI_MIN_STAGE_COUNT[3])] = 2,
        [count_creator()] = 5,
        [count_creator()] = 10,
        [count_creator()] = 50,
        [count_creator()] = 100,
        [count_creator()] = 200,
        [count_creator()] = 500,
        [count_creator()] = 2000,
        [count_creator()] = 5000,
        [count_creator()] = 10000,
        [count_creator()] = 10000,
        [count_creator()] = 1500,
    },
};



--模式: 手动，自动
SI_GAME_MODE = {
    Hand = id_creator(0),
    Auto = id_creator(),
};

--[[
    游戏步骤:


    游戏本身玩法：
    --非自动模式(1局)
                                 ←←←←←←←←←←←←←←←←←←←←←←←←←←←
                                ↓                         ↑                          ↑
        Bet →  InitStage → FallStone → CountDrill→ ClearDrill → CountStone → ClearStone → Balance
    --自动模式 (...为上图的循环部分)
                   ←←←←←←←←←←           
                  ↓                  ↑
        Bet → InitStage →  ...  → Balance 
    自动模式下出现以下几种情况，将终止自动模式（金币不足，关卡升级，人为终止自动模式）
--]]
SI_GAME_STEP = {
    Bet         = id_creator(1), --下注
    InitStage   = id_creator(),  --初始化关卡
    FallStone   = id_creator(),  --下落石头
    CountDrill  = id_creator(),  --计算钻头
    ClearDrill  = id_creator(),  --清除钻头
    CountStone  = id_creator(),  --计算石头
    JiLeiShow   = id_creator(),  --展示积累奖
    ClearStone  = id_creator(),  --清除石头
    Balance     = id_creator(),  --结算
};

--一些常用的时间参数定义
SI_GAME_CONFIG = {
    FallOverWaitTime            = 1,  --落完后，多久开始计算
    WaitClearDrillTime          = 2,  --计算完钻头后，多久开始清除钻头
    ClearDrillInterval          = 1,  --清除钻头间的时间间隔
    ClearStoneInterval          = 1,  --清除宝石间的时间间隔
    SepClearStoneInterval       = 0.7,  --特殊清除宝石时间间隔
    SepClearStoneEndInterval    = 1.5,  --特殊清除宝石时间间隔
    BalanceWaitTime             = 3,  --结算等待时间
    WaitClearStoneTime          = 2,  --计算完宝石组合后，多久开始清除宝石
    QueryCaiJinPeriod           = 15,  --查询彩金的周期
    AutoStartTime               = 1,   --3秒后自动变成自动开始
    LongPressBtnTime            = 0.6, --长按按钮多久触发按钮点击事件
    LongPressInterval           = 0.4, --长按后多久还会触发按钮点击
    FallStoneSpeed              = 2200,  --宝石每秒下落多少像素
    StonePlayInterval           = 0.05, --宝石播放时间间隔
    FallStoneInterval           = 0.02, --落下宝石的时间间隔.
    DisappearPlayInterval       = 0.02,
    StoneJumpMinTime            = 0.6,  --跳的最短时间
    StoneJumpMaxTime            = 0.9,  --跳的最长时间
    StoneMoveInterval           = 0.05, --移动宝石间的时间间隔
    ShowLineInterval            = 0.01, --显示连线时间间隔
    ShowLineCount               = 6,    --最多显示连线条数
    ShowLineMoveSpeed           = 1600,  --连线移动速度
    DragonBallFallBeginSpeed    = 60,  --出场下落的初始速度
    DragonBallFallAddSpeed      = 300,  --出场下落的加速度
    DragonBallEnterSceneTime    = 1,  --出场的时间
    DragonBallJumpTime          = 0.47, --跳的时间
    DragonBallJumpDecayTime     = 0.045, --跳的时间
    QueryPlayerListPeriod       = 20,   --20秒周期
    BurningCombLine             = 3,    --燃烧连线数
    SepDisappearLine            = 3,   --特殊消除
    JiLeiShowTime               = 3,   --积累奖显示时间
};

--游戏状态
SI_GAME_STATE = {
    Null                = id_creator(0), --空闲
    Free                = id_creator(),  --可以押注
    RequestGameData     = id_creator(), --请求游戏数据
    Gaming              = id_creator(), --游戏中
    RequestDragonData   = id_creator(), --请求龙珠关卡
    DragonBall          = id_creator(), --龙珠关卡  
};

--游戏命令
SI_CMD = {
    NotifyGameSceneInfo     = 2,  --通知游戏场景消息，以及配置文件数据
    NotifyPlayerData        = 4,  --通知玩家数据
    RequestStartGame        = 101,
    ResponseStartGame       = 102,
    RequestDragonMission    = 103,
    ResponseDragonMission   = 104,
    RequestCaijin           = 105,
    ResponseCaijin          = 106,
    RequestPlayerList       = 107,
    ResponsePlayerList      = 108,
}

SI_ERROR_CODE = {
    ErrCode_Null=0,
};

SI_DONE_CODE = {
    Done_Success        = id_creator(1),
    Done_Failed         = id_creator(),
    Done_Doing          = id_creator(),
    Done_NoGold         = id_creator(),
    Done_InvalidOperate = id_creator(1000),
};

SI_WORD_CODE = {
    ENTER_DRAGON_MISSION = id_creator(1),
    RECHANGE_TIPS        = id_creator(),
    DRAGON_DESCRIPTION   = id_creator(),
    CLEAR_RECORD         = id_creator(),
};

SI_WORD = 
{
    [SI_WORD_CODE.ENTER_DRAGON_MISSION] = "The game level is now %d level, do you enter the level?",
    [SI_WORD_CODE.RECHANGE_TIPS]        = "Not enough coins, please recharge, keep going!",
    [SI_WORD_CODE.DRAGON_DESCRIPTION]   = "Experience will be added after each successful connection equals points.\n" ..
                                            "The higher the game level the higher the special mode jackpot multiplier.\n" ..
                                            "1-star dragon ball: Enter the special mode to drop 1 Dragonballs.\n" ..
                                            "2-star Dragonball: Enter the special mode to drop 2 Dragonballs.\n" ..
                                            "3-star dragon ball: Enter the special mode to drop 3 Dragonballs.\n" ..
                                            "4-star Dragonball: Enter the special mode to drop 4 Dragonballs.\n" ..
                                            "5-star Dragonball: Enter the special mode to drop 5 Dragonballs.",
    [SI_WORD_CODE.CLEAR_RECORD]         = "Since you have not entered the game for 7 days, your progress and level have been cleared, please start again",
};

--道具类型
SI_ITEM_TYPE = {
    Item_Null = id_creator(0),
    Item_Gold = id_creator(),
    Item_Ball = id_creator(),
};

--结算类型
SI_BALANCE_TYPE = {
    Common    = id_creator(1),
    Big       = id_creator(),
    Large     = id_creator(),
    LeiJi     = id_creator(),
};

--游戏场景
SI_GAME_SCENE = 
{
    Common      = id_creator(1),
    Dragon      = id_creator(),
};
