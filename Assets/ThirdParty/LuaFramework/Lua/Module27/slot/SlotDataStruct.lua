--SlotDataStruct.lua
--Date
-- slot 点数据结构定义



--endregion

SlotDataStruct = {};

local self = SlotDataStruct;

local UpdateJackpotTime;

self.CHIPS_LIST_COUNT = 5; --下注列表长度

self.WEALTH_GOD_COUNT = 10; --财神个数

self.D_ROW_COUNT = 3;	 --行数
self.D_COL_COUNT = 5; --列数
self.D_ALL_COUNT = 15;

self.D_LINE_COUNT = 25;  --线数


self.enGameType = --游戏类型
{
	E_GAME_TYPE_NORMAL = 0,--普通
	E_GAME_TYPE_PBSH = 1,--财源滚滚
	E_GAME_TYPE_JYMT = 2 --金玉满堂
};

self.C_LINE_LIST_TYPE =   --线对应的位置
{
    [1] = {6,7,8,9,10},
    [2] = {1,2,3,4,5},
    [3] = {11,12,13,14,15},
    [4] = {1,7,13,9,5},
    [5] = {11,7,3,9,15},
    [6] = {1,2,8,4,5},
    [7] = {11,12,8,14,15},
    [8] = {6,12,13,14,10},
    [9] = {6,2,3,4,10},
    [10] = {1,7,8,9,5},
    [11] = {11,7,8,9,15},
    [12] = {1,7,3,9,5},
    [13] = {11,7,13,9,15},
    [14] = {6,2,8,4,10},
    [15] = {6,12,8,14,10},
    [16] = {6,7,3,9,10},
    [17] = {6,7,13,9,10},
    [18] = {1,12,3,14,5},
    [19] = {11,2,13,4,15},
    [20] = {6,2,13,4,10},
    [21] = {6,12,3,14,10},
    [22] = {1,2,13,4,5},
    [23] = {11,12,3,14,15},
    [24] = {1,12,13,14,5},
    [25] = {11,2,3,4,15},
};

self.enGameImage =  --游戏图标
{
    E_COPPER_IMG            = 10, --铜币 Q
    E_SILVER_IMG            = 9, --银币 K
    E_GOLD_IMG              = 8, --金币 A
    E_SMALL_HONGBAO_IMG     = 5, --小红包
    E_NORMAL_HONGBAO_IMG    = 6, --中红包
    E_BIG_HONGBAO_IMG       = 7,  --大红包
    E_SILVER_YUANBAO_IMG    = 4, --银元宝
    E_GOLD_YUANBAO_IMG      = 3, --金元宝
	E_WEALTH_GOD_IMG        = 0, --财神
	E_NORMAL_CORUNCOPIA_IMG = 1, --普通聚宝盆
	E_SUPER_CORUNCOPIA_IMG  = 2,  --超级聚宝盆
};

self.sImgName = {"Q","K","A","小红包","中红包","大红包","银元宝","金元宝","财神","Wild","2xWild"};


--服务器消息
self.SUB_SC_SEND_ACCPOOL =	0	--发送奖池
--self.SUB_SC_BEGIN_CHIP = 0;			--开始下注

self.SUB_SC_RESULTS_INFO = 1;       --结算信息

self.SUB_SC_USER_INFO = 2;          --用户列表

self.SUB_SC_TEST_INFO = 99; --测试数据




--struct CMD_SC_ACCU_POOL
--{
--	INT64 i64AccuPool;
--};
self.CMD_SC_BEGIN_CHIP = --发送奖池
{
	i64AccuPool = 0;

	DataDispose = function (bytes)
		 if(not bytes) then
            self.CMD_SC_BEGIN_CHIP.i64AccuPool = 0;
            return;
         end
		
		 self.CMD_SC_BEGIN_CHIP.i64AccuPool = int64.tonum2(bytes:ReadInt64());
	end

	
}

--服务器结构体
self.CMD_SC_GAME_SCENE =--游戏场景
{	
	iBet = 0;  --当前底分 Int32
	byFreeNumber = 0; --剩余免费次数 Byte
    byChipList = {};--Int32
    iRateList = {}; --财神倍数列表 Int32
    i64GodScore = 0; --财神阶段总分 Int64
    bLimitChip = 0; --Int32
    iLimitChip = 0;--Int32
	bReturn = false; --Int32()
	i64AccuPool = 0; --Int64

    DataDispose = function (bytes)

        if(not bytes) then
            self.CMD_SC_GAME_SCENE.iBet = 0;
            self.CMD_SC_GAME_SCENE.byFreeNumber = 0;
            self.CMD_SC_GAME_SCENE.byChipList = {};
            self.CMD_SC_GAME_SCENE.iRateList = {};
            self.CMD_SC_GAME_SCENE.i64GodScore = 0;
            self.CMD_SC_GAME_SCENE.bLimitChip = 0;
            self.CMD_SC_GAME_SCENE.iLimitChip = 0;
			self.CMD_SC_GAME_SCENE.bReturn = false;
			self.CMD_SC_GAME_SCENE.i64AccuPool = 0;
            return;
        end

        self.CMD_SC_GAME_SCENE.iBet = bytes:ReadInt32();
        self.CMD_SC_GAME_SCENE.byFreeNumber = bytes:ReadByte();

        for i = 1, self.CHIPS_LIST_COUNT do
            table.insert(self.CMD_SC_GAME_SCENE.byChipList, bytes:ReadInt32() );
        end

        for i = 1, self.WEALTH_GOD_COUNT do
            table.insert(self.CMD_SC_GAME_SCENE.iRateList, bytes:ReadInt32() );
        end

         self.CMD_SC_GAME_SCENE.i64GodScore = int64.tonum2(bytes:ReadInt64());

         self.CMD_SC_GAME_SCENE.bLimitChip = bytes:ReadInt32();
         self.CMD_SC_GAME_SCENE.iLimitChip = bytes:ReadInt32();
		

		local b = bytes:ReadInt32();
		if(b > 0) then self.CMD_SC_GAME_SCENE.bReturn = true;
		else  self.CMD_SC_GAME_SCENE.bReturn = false; end

		self.CMD_SC_GAME_SCENE.i64AccuPool = int64.tonum2(bytes:ReadInt64());

    end
	
};

self.CMD_SC_BEGIN_CHIP =--开始下注信息
{
	byOnChip = 0;
}

self.CMD_SC_RESULTS_INFO =--结算信息
{

    byImg = {}; --图标15	Byte
    byLineType = {}; --线类型30*5=150 Byte
    byWealthGodNum = 0; --财神个数 Byte
    byFreeNum = 0; --免费次数; Byte
    gameType = self.enGameType.E_GAME_TYPE_NORMAL;  --游戏类型 Int32
    dwWinScore = 0; --赢得的总分 Int64
    temp = 0; --Int32
    bLimitChip = 0; --Int32
    iLimitChip = 0; --Int32
	bSuperRate;		--是否超级倍率 Int32
	bReturn;			--是否重转  Int32
	i64AccuPool = 0; --Int64
    DataDispose = function (bytes)
        if(not bytes) then
            self.CMD_SC_RESULTS_INFO.byImg = {}; --图标15	
            self.CMD_SC_RESULTS_INFO.byLineType = {} --线类型30*5=150
            self.CMD_SC_RESULTS_INFO.byWealthGodNum = 0; --财神个数
            self.CMD_SC_RESULTS_INFO.byFreeNum = 0; --免费次数;
            self.CMD_SC_RESULTS_INFO.gameType = self.enGameType.E_GAME_TYPE_NORMAL;  --游戏类型
            self.CMD_SC_RESULTS_INFO.dwWinScore = 0; --赢得的总分

            self.CMD_SC_RESULTS_INFO.bLimitChip = 0;
            self.CMD_SC_RESULTS_INFO.iLimitChip = 0;

			self.CMD_SC_RESULTS_INFO.bSuperRate = false;
            self.CMD_SC_RESULTS_INFO.bReturn = false;
			
			self.CMD_SC_RESULTS_INFO.i64AccuPool = 0;
            return ;
        end


        for i = 1, self.D_ALL_COUNT do
            table.insert(self.CMD_SC_RESULTS_INFO.byImg, bytes:ReadByte() );
        end

        for i = 1, self.D_LINE_COUNT do
            local tempTab = {};
            for j = 1, self.D_COL_COUNT do
                table.insert(tempTab, bytes:ReadByte() );
            end
            table.insert(self.CMD_SC_RESULTS_INFO.byLineType, tempTab);
        end

        self.CMD_SC_RESULTS_INFO.byWealthGodNum = bytes:ReadByte();
        self.CMD_SC_RESULTS_INFO.byFreeNum = bytes:ReadByte();
        self.CMD_SC_RESULTS_INFO.gameType = bytes:ReadInt32();
        self.CMD_SC_RESULTS_INFO.dwWinScore = int64.tonum2(bytes:ReadInt64());

        self.CMD_SC_RESULTS_INFO.temp = bytes:ReadInt32();
        self.CMD_SC_RESULTS_INFO.bLimitChip = bytes:ReadInt32();
        self.CMD_SC_RESULTS_INFO.iLimitChip = bytes:ReadInt32();

		local b = bytes:ReadInt32();
		if(b > 0) then self.CMD_SC_RESULTS_INFO.bSuperRate = true;
		else  self.CMD_SC_RESULTS_INFO.bSuperRate = false; end

		b = bytes:ReadInt32();
		if(b > 0) then self.CMD_SC_RESULTS_INFO.bReturn = true;
        
		else  self.CMD_SC_RESULTS_INFO.bReturn = false; end

		self.CMD_SC_RESULTS_INFO.i64AccuPool = int64.tonum2(bytes:ReadInt64());
		logTable(self.CMD_SC_RESULTS_INFO);
    end

};

self.CMD_SC_TEST_INFO = --测试数据
{
	i64BloodScore = 0;
	iCheate = 0;
};


--客户端消息
self.SUB_CS_GAME_START = 0  --启动游戏
self.SUB_CS_GAME_END = 1		--游戏结束
self.SUB_CS_USER_INFO = 2 --用户列表
self.SUB_CS_JACKPOT	=	3;
self.SUB_CS_TEST_INFO = 99; --测试数据

--客户端结构
self.CMD_CS_GAME_START = --启动游戏
{
    [1] = DataSize.Int32,
    --iChipNmuber;   --下注值
};


self.CMD_CS_GAME_END =  --游戏结束
{
	[1] = byEnd;   --结束
};


self.CMD_CS_USER_INFO = --玩家列表
{
	[1] = byVar;   
};