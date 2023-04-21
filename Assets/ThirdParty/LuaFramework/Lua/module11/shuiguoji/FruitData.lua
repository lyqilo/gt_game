--FruitData.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion

FruitData = {};

local self = FruitData;

self.E_NOT_IMG = 0;             --无效ID
self.E_LUCK_GOLD = 1;           --// 		1	金色luck：灯停在金色luck上，会随机再转灯，最少1个，有几率luck失败。
self.E_LUCK_BULE = 2;           --// 		2	蓝色luck：灯停在蓝色luck上，会随机再转灯，最少1个，luck失败率高于金色luck。
self.E_APPLE = 3;               --// 		3	苹果：水果机转盘中，苹果灯4个，全部都是正常苹果，固定为5倍。
self.E_ORANGE = 4;              --// 		4	橘子：水果机转盘中，橘子灯共3个，2个正常橘子，中奖读取右半部分倍数，
self.E_ORANGE_SMALL = 5;        --// 		5	小橘子为固定3倍。
self.E_LEMON = 6;               --//  	6	柠檬：水果机转盘中，柠檬灯共3个，2个正常柠檬，中奖读取右半部分倍数，
self.E_LEMON_SMALL = 7;         --//		7	小柠檬为固定3倍。
self.E_BELL = 8;                --//  	8	铃铛：水果机转盘中，铃铛灯共3个，2个正常铃铛，中奖读取右半部分倍数，
self.E_BELL_SMALL = 9;          --//		9	小铃铛为固定3倍。
self.E_XIGUA = 10;              --//  	10	西瓜：水果机转盘中，西瓜灯共2个，1个正常西瓜，中奖读取左半部分倍数，
self.E_XIGUA_SMALL = 11;        --//		11	小西瓜为固定3倍。
self.E_STAR = 12;               --//  	12	星星：水果机转盘中，星星灯共2个，1个正常星星，中奖读取左半部分倍数，
self.E_STAR_SMALL = 13;         --//		13	小星星为固定3倍。
self.E_77 = 14;                 --//  	14	77：水果机转盘中，77灯共2个，1个正常777，中奖读取左半部分倍数，
self.E_77_SMALL = 15;           --//		15	小77为固定3倍。
self.E_BAR_25 = 16;             --// 			BAR：水果机转盘中，BAR灯共3个，图样相同，标示倍数不同，分别为
self.E_BAR_50 = 17;             --// 		16	X25、
self.E_BAR_120 = 18;            --// 		17	X50、
                                --// 		18	X120。
--	//内盘结果
self.E_CAP = 20;                --// 		20	王冠：无奖励。
self.E_XSY = 21;                --// 		21	小三元：转盘亮灯，再次转动，橘子、柠檬、铃铛的小图标同时亮起。
self.E_DSY = 22;                --// 		22	大三元：转盘亮灯，再次转动，橘子、柠檬、铃铛的大图标同时亮起。
self.E_DSX = 23;                --// 		23	大四喜：转盘亮灯，再次转动，4个苹果同事亮起。
self.E_ZHSH = 24;               --// 		24	纵横四海：转盘亮灯，再次转动，同时亮起4种水果图标各一个，大小随机。
self.E_LLDS = 25;               --// 		26	六六大顺：转盘亮灯，再次转动，除BAR、苹果两种图标外，其他六种图标各亮一个，大小随机。
self.E_WLHC = 26;               --// 		25	五节火车：转盘亮灯，再次转动，5盏等连续，再次转动，然后停止，连续5个图表中奖。不会再次停留在GOODLUCK。
self.E_XNSH = 27;               --// 		27	仙女散花：转盘亮灯，再次转动，除BAR外，剩余图标各亮大图标。
self.E_TLBB = 28;               --// 		28	天龙八部：转盘亮灯，再次转动，所有图标各亮大图标，BARx50亮起，
self.E_JBLD = 1000;               --// 		29	九莲宝灯：转盘亮灯，再次转动，同时亮起九盏灯，灯随机停留，不会停留在GODDLUCK，不会两盏灯连接。
self.E_DMG = 29;                --// 		30	大满贯：全屏转盘亮灯并闪烁，最后全盘图标亮起，所有图标中奖。
self.E_GIVE_LIGHT = 30 --送灯

self.C_XSY_GRID_IDS = {2, 14, 20};
self.C_DSY_GRID_IDS = {4, 15, 21};
self.C_DSX_GRID_IDS = {5, 12, 19, 24};
self.C_ZHSH_GRID_IDS = {5, 10, 15, 21};
self.C_LLDS_GRID_IDS = {4, 9, 11, 14, 18, 23};

self.C_XNSH_GRID_IDS = {3, 10,  12,  16, 17, 21, 23};
self.C_TLBB_GRID_IDS = {3, 6, 10, 12,  16, 17, 21, 23};

self.C_RATES_WLHC = {51, 66, 73, 98}; 
self.C_WLHC_GRIDS = {24, 18, 12, 6};



self.D_CHIP_LIST_COUNT = 8; --下注列表长度

self.D_SC_MAIN_RESULT_COUNT = 4;--第一轮主盘结果长度
self.D_SC_WIN_RATE_COUNT = 3; --中奖倍数长度

--服务器 消息 定义
self.SUB_SC_FRIUT_RESULT = 0		--第一轮结果
self.SUB_SC_COMPARE_RESULT = 10		--比大小结果
self.SUB_SC_ACCOUNT_END = 20		--结算结束

--场景消息
self.CMD_SC_SCENE = 
{
    [1] = DataSize.Int32;
    [2] = DataSize.Int32;
    [3] = DataSize.Int32;
--	int iTableScale;
--	int iAddStep;
--	int iChipLimit;
};


self.CMD_SC_FRIUT_RESULT = 
{
    i64ChipResult = 0; -- 第一轮结果金额
    tabIChipPicture = {}; --第一轮主盘图案 size 4
    tabIChipPower = {}; --倍率 size 3
    tabiChipFirut = {}; -- 每个图案下注的最后中奖倍数 size 8

    DataDispose = function (bytes)
                        self.CMD_SC_FRIUT_RESULT.i64ChipResult = 0; -- 第一轮结果金额
                        self.CMD_SC_FRIUT_RESULT.tabIChipPicture = {}; --第一轮主盘图案
                        self.CMD_SC_FRIUT_RESULT.tabIChipPower = {}; --倍率
                        self.CMD_SC_FRIUT_RESULT.tabiChipFirut = {} -- 每个图案下注的最后中奖倍数

                        self.CMD_SC_FRIUT_RESULT.i64ChipResult = int64.tonum2(bytes:ReadInt64());

                        for i = 1, self.D_SC_MAIN_RESULT_COUNT do
                            table.insert(self.CMD_SC_FRIUT_RESULT.tabIChipPicture, bytes:ReadInt32() );
                        end

                        for i = 1, self.D_SC_WIN_RATE_COUNT do
                            table.insert(self.CMD_SC_FRIUT_RESULT.tabIChipPower, bytes:ReadInt32() );
                        end

                        for i = 1, self.D_CHIP_LIST_COUNT do
                            table.insert(self.CMD_SC_FRIUT_RESULT.tabiChipFirut, bytes:ReadInt32() );
                        end
                  end
};


self.CMD_SC_COMPARE_RESULT = 
{
    [1] = DataSize.UInt64;
    [2] = DataSize.Int32;
--	INT64 iCompareResult;//比较之后的金额
--	int iCompareNum;//比较大小的数值 1~13
};



--客户端 消息 定义
self.SUB_CS_START = 0;		    --开始
self.SUB_CS_COMPARE = 1;		--比较大小
self.SUB_CS_ACCOUNT	= 2;		--玩家结算


self.CMD_CS_PLAYER_COMPARE = --玩家比较大小
{
    [1] = DataSize.Int32;
--	int iChipNum;//下注值 0是小 1是大
};




-----------------------------客户端结构-----------------------
self.C_MAIN_IMGS = { FruitData.E_LUCK_GOLD, 
                      FruitData.E_BELL_SMALL, 
                      FruitData.E_ORANGE, 
                      FruitData.E_BELL, 
                      FruitData.E_APPLE, 
                      FruitData.E_BAR_50, 
                      FruitData.E_BAR_120, 
                      FruitData.E_BAR_25, 
                      FruitData.E_LEMON, 
                      FruitData.E_XIGUA, 
                      FruitData.E_XIGUA_SMALL, 
                      FruitData.E_APPLE, 
                      FruitData.E_LUCK_BULE, 
                      FruitData.E_ORANGE_SMALL, 
                      FruitData.E_ORANGE, 
                      FruitData.E_BELL,  
                      FruitData.E_77, 
                      FruitData.E_77_SMALL, 
                      FruitData.E_APPLE, 
                      FruitData.E_LEMON_SMALL, 
                      FruitData.E_LEMON, 
                      FruitData.E_STAR_SMALL, 
                      FruitData.E_STAR, 
                      FruitData.E_APPLE };     

--self.C_SUB_IMG = {FruitData.E_CAP, FruitData.E_DSX, FruitData.E_ZHSH, FruitData.E_DMG, FruitData.E_TLBB, FruitData.E_DSY, 
--                        FruitData.E_CAP, FruitData.E_XSY, FruitData.E_JBLD, FruitData.E_XNSH, FruitData.E_LLDS, FruitData.E_WLHC};

self.C_SUB_IMG = {FruitData.E_WLHC, FruitData.E_DSY, FruitData.E_DSX, FruitData.E_XSY, FruitData.E_XNSH, FruitData.E_LLDS,  
                    FruitData.E_ZHSH, FruitData.E_DMG};


self.tabChipImgId = { [1] = {self.E_BAR_25, self.E_BAR_50, self.E_BAR_120},
                      [2] = {self.E_77, self.E_77_SMALL},
                      [3] = {self.E_STAR, self.E_STAR_SMALL},
                      [4] = {self.E_XIGUA, self.E_XIGUA_SMALL}, 
                      [5] = {self.E_BELL, self.E_BELL_SMALL},
                      [6] = {self.E_LEMON, self.E_LEMON_SMALL},
                      [7] = {self.E_ORANGE, self.E_ORANGE_SMALL},
                      [8] = {self.E_APPLE};   
                     };