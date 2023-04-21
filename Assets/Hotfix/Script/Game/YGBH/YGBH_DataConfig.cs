using System.Collections.Generic;

namespace Hotfix.YGBH
{
    public class YGBH_DataConfig
    {
        #region Const
        /// <summary>
        /// 最大下注个数
        /// </summary>
        public const int MAX_BET_COUNT = 10;
        /// <summary>
        /// 最大icon个数
        /// </summary>
        public const int MAX_ALLICON = 15;
        /// <summary>
        /// 最大行
        /// </summary>
        public const int MAX_RAW = 3;
        /// <summary>
        /// 最大列
        /// </summary>
        public const int MAX_COL = 5;
        /// <summary>
        /// 连线数量
        /// </summary>
        public const int ALLLINECOUNT = 25;

        public const int SMALLCHECKNUM = 8;

        public const float freeWaitTime = 30f;//免费自动选择等待时间

        public const float rollInterval = 0.002f;//每列转动间隔时间
        public const float rollStopInterval = 0.25f;//每列转动停止间隔时间
        public const int rollSpeed = 24;//每列转动速度,可调节快慢
        public const float rollTime = 1f;//转动时间
        public const int rollReboundRate = 2;//每列停止后反弹比例（0：立即停止，值越大反弹速度
        public const int rollDistance = 80;//回弹距离，数值越大距离越大
        public const int winGoldChangeRate = 1;//得分跑分速率
        public const float winBigGoldChangeRate = 1.5f;//得分跑分速率
        public const int selfGoldChangeRate = 2;//自身跑分速率
        public const int caijinGoldChangeRate = 10;//彩金跑分速率
        public const float freeLoadingShowTime = 3.3f;//中免费展示时间
        public const float smallGameLoadingShowTime = 1.5f;//中小游戏展示时间
        public const int smallGameRuleShowTime = 5;//中小游戏展示时间
        public const int REQCaiJinTime = 5;//请求彩金频率
        public const int lineAllShowTime = 2;//总连线展示时间
        public const int cyclePlayLineTime = 2;//连线轮播展示时间
        public const float waitShowLineTime = 0.3f;//等待展示连线奖励时间
        public const int autoRewardInterval = 2;//自动或免费中奖间隔
        public const float autoNoRewardInterval = 0.5f;//自动或免费未中奖间隔
        public const int addSpeedTime = 3;
        public const int showSelectFreeResultTime = 2;
        public const int showFreeResultTime = 3;//展示免费结算界面时间
        public const float RERollTime = 0.8f;//重转时间
        public const float smallRollDurationTime = 0.2f;//小游戏转动间隔时间
        public const float smallMoveSpeed = 0.05f;//小游戏转动间隔时间

        #endregion

        public static List<string> WinConfig = new List<string>
        {
            "Great fortune",
            "Keep up(^V^)",
            "It's a pity.",
            "Big Prize Coming",
        };

        public static List<int> autoList = new List<int>
        {
            20, 50, 100, 10000
        };

        public static List<string> IconTable = new List<string>
        {
            "Icon1",    //至尊宝  1
            "Icon2",    //孙悟空  2
            "Icon3",    //唐僧  3
            "Icon4",    //牛魔王  4
            "Icon5",    //猪八戒  5
            "Icon6",    //铃铛  6
            "Icon7",    //A  7
            "Icon8",    //K  8
            "Icon9",    //Q   9
            "Icon10",   //J   10
            "Icon11",   //10   11
            "Icon12",   //月光宝盒   12
            "Icon13",   //紫霞wild   13
            "Icon14"    //白晶晶wild   14
        };

        public static List<List<int>> BeiLVTable = new List<List<int>>
        {
           new List<int>() { 300, 150, 100, 100, 80, 80, 12500, 300 },
           new List<int>() { 100, 100, 80, 80, 50, 25, 250, 125 },
           new List<int>() { 20, 20, 10, 5, 5, 5, 125, 20 },
           new List<int>() { 0, 0, 0, 0, 0, 0, 50, 0 },
        };

        public static List<string> EffectTable = new List<string>
        {
            "ZZB",  //至尊宝
            "SWK",  //孙悟空
            "TS",   //唐僧
            "Niu",  //牛魔王
            "ZBJ",  //猪八戒
            "LD",   //铃铛
            "A",
            "K",
            "Q",
            "J",
            "10",
            "Scatter_Reward", //Scatter中奖
            "ZX", //紫霞wild
            "BJJ", //白晶晶wild
            "Scatter", //Scatter未中奖
        };

        /// <summary>
        /// 赔付线
        /// </summary>
        public static List<List<int>> Line = new List<List<int>>()
        {

            new List<int>() { 6, 7, 8, 9, 10 }, //1
            new List<int>() { 1, 2, 3, 4, 5 }, //2
            new List<int>() { 11, 12, 13, 14, 15 }, //3
            new List<int>() { 1, 7, 13, 9, 5 }, //4
            new List<int>() { 11, 7, 3, 9, 15 }, //5
            new List<int>() { 6, 2, 3, 4, 10 }, //6
            new List<int>() { 6, 12, 13, 14, 10 }, //7
            new List<int>() { 1, 2, 8, 14, 15 }, //8
            new List<int>() { 11, 12, 8, 4, 5 }, //9
            new List<int>() { 6, 12, 8, 4, 10 }, //10
            new List<int>() { 6, 2, 8, 14, 10 }, //11
            new List<int>() { 1, 7, 8, 9, 5 }, //12
            new List<int>() { 11, 7, 8, 9, 15 }, //13
            new List<int>() { 1, 7, 3, 9, 5 }, //14
            new List<int>() { 11, 7, 13, 9, 15 }, //15
            new List<int>() { 6, 7, 3, 9, 10 }, //16
            new List<int>() { 6, 7, 13, 9, 10 }, //17
            new List<int>() { 1, 2, 13, 4, 5 }, //18
            new List<int>() { 11, 12, 3, 14, 15 }, //19
            new List<int>() { 1, 12, 13, 14, 5 }, //20
            new List<int>() { 11, 2, 3, 4, 15 }, //21
            new List<int>() { 6, 12, 3, 14, 10 }, //22
            new List<int>() { 6, 2, 13, 4, 10 }, //23
            new List<int>() { 1, 12, 3, 14, 5 }, //24
            new List<int>() { 11, 2, 13, 4, 15 }, //25
        };

        /// <summary>
        /// 白晶晶光团跑动位置
        /// </summary>
        public static List<List<int>> LightPos = new List<List<int>>()
        {
             new List<int>() { -354, 201, 0 },   //1
             new List<int>() { -177, 201, 0 },   //2
             new List<int>() { 0, 201, 0 },      //3
             new List<int>() { 177, 201, 0 },    //4
             new List<int>() { 354, 201, 0 },    //5
             new List<int>() { -354, 28, 0 }, //6
             new List<int>() { -177, 28, 0 }, //7
             new List<int>() { 0, 28, 0 },    //8
             new List<int>() { 177, 28, 0 },  //9
             new List<int>() { 354, 28, 0 },  //10
             new List<int>() { -354, -144, 0 }, //11
             new List<int>() { -177, -144, 0 }, //12
             new List<int>() { 0, -144, 0 },    //13
             new List<int>() { 177, -144, 0 },  //14
             new List<int>() { 354, -144, 0 },  //15
        };

        public static List<float> smallLighIconPos = new List<float>() 
        {
            15.5f, 13, 0,//戏旋转光标位置
        };

        public static int smallLighIconAngle = 135;//小游戏旋转光标角度
        
        public static List<int> ZPList = new List<int>()
        {
            4, 5, 6, 1, 2, 3, 8, 7,//戏旋转光标位置
        };


        public static List<List<float>> rollPoss = new List<List<float>>()
        {
             new List<float>() { 144, -59, 0 },
             new List<float>() { 321, -59, 0 },
             new List<float>() { 498, -59, 0 },
             new List<float>() { 675, -59, 0 },
             new List<float>() { 852, -59, 0 },
             new List<float>() { 144, -231.92f, 0 },
             new List<float>() { 321, -231.92f, 0 },
             new List<float>() { 498, -231.92f, 0 },
             new List<float>() { 675, -231.92f, 0 },
             new List<float>() { 852, -231.92f, 0 },
             new List<float>() { 144, -404.84f, 0 },
             new List<float>() { 321, -404.84f, 0 },
             new List<float>() { 498, -404.84f, 0 },
             new List<float>() { 675, -404.84f, 0 },
             new List<float>() { 852, -404.84f, 0 },
        };


    }

    public class Data
    {
        public YGBH_Struct.SC_SceneInfo SceneData { get; set; }
        public YGBH_Struct.CMD_3D_SC_Result ResultData { get; set; }
        public YGBH_Struct.CMD_3D_SC_SmallResult SmallData { get; set; }
        public YGBH_Struct.CMD_3D_SC_SmallEnd SmallEndData { get; set; }
        public long myGold { get; set; }
        public int CurrentChip { get; set; }
        public bool isFreeGame { get; set; }
        public bool isAutoGame { get; set; }
        public bool isSmallGame { get; set; }
        public int CurrentChipIndex { get; set; }
        public int CurrentAutoCount { get; set; }
        public int currentFreeCount { get; set; }
        public long TotalFreeWin { get; set; }
        public int smallSPCount;
        public int smallWinIndex;
        public bool hasNewSP;
        public uint m_FreeType;
    }
}
