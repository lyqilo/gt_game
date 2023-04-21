using System.Collections.Generic;

namespace Hotfix.JTJW
{
    public class JW_DataConfig
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
        public const int ALLLINECOUNT = 35;

        /// <summary>
        /// 免费自动结算
        /// </summary>
        public const int AUTOVERFREETIME = 20;


        public const float rollImageShowHideTime = 0.2f;//隐藏开启的时间
        public const float nextImageShowTime = 0.1f;//下张图片开始的时间
        public const float ImageDownShowTime = 0.2f;//下落时间
        public const float NextWheelShowTime = 0.3f;//下落时间
        public const float PlayTime = 5f;//下落时间

        public const float rollInterval = 0.3f;//每列转动间隔时间
        public const int rollSpeed = 16;//每列转动速度,可调节快慢
        public const float rollTime = 0.5f;//转动时间
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
        public const float autoNoRewardInterval = 0.2f;//自动或免费未中奖间隔
        public const int addSpeedTime = 3;
        public const int showSelectFreeResultTime = 2;
        public const int showFreeResultTime = 3;//展示免费结算界面时间
        public const int showSmallGameResultTime = 3;//展示小游戏结算界面时间
        public const float smallMoveSpeed = 0.05f;//小游戏外围旋转速度
        #endregion

        public static List<string> IconTable = new List<string>{
            "Item1", //上键  1
            "Item2", // 下键 2
            "Item3", //右键  3
            "Item4", //中分  4
            "Item5", //黄毛  5
            "Item6", //黑头  6
            "Item7", //白头  7
            "Item8", //A wild 8
            "Item9", //B scatter 9
        };
        /// <summary>
        /// 赔付线
        /// </summary>
        public static List<List<int>> Lines = new List<List<int>>()
        {
            new List<int>(){ 6, 7, 8, 9, 10 }, //1
            new List<int>(){ 1, 2, 3, 4, 5 }, //2
            new List<int>(){ 11,12,13,14,15 }, //3
            new List<int>(){ 1, 7, 13,9, 5 }, //4
            new List<int>(){ 11,7, 3, 9, 15 }, //5
            new List<int>(){ 6, 2, 3, 4, 10 }, //6
            new List<int>(){ 6, 12,13,14,10 }, //7
            new List<int>(){ 1, 2, 8, 14,15 }, //8
            new List<int>(){ 11,12,8, 4, 5 }, //9
            new List<int>(){ 6, 2, 8, 4, 10 }, //10
            new List<int>(){ 6, 12,8, 14,10 }, //11
            new List<int>(){ 1, 7, 8, 9, 15 }, //12
            new List<int>(){ 11,7, 8, 9, 5 }, //13
            new List<int>(){ 6, 7, 3, 9, 15 }, //14
            new List<int>(){ 6, 7, 13,9, 5 }, //15
            new List<int>(){ 1, 7, 3, 9, 5 }, //16
            new List<int>(){ 11,7, 13,9, 15 }, //17
            new List<int>(){ 1, 2, 13,4, 5 }, //18
            new List<int>(){ 11,12, 3,14,15 }, //19
            new List<int>(){ 6, 2, 13,4, 10 }, //20
            new List<int>(){ 6, 12,3, 14,10 }, //21
            new List<int>(){ 1, 12,3, 14,5 }, //22
            new List<int>(){ 11,2, 13,4, 15 }, //23
            new List<int>(){ 1, 12,13,14,5 }, //24
            new List<int>(){ 11,2, 3, 4, 15 } //25
        };

        public static List<List<int>> LineIconList = new List<List<int>>()
        {
            new List<int>(){1,  2,6,        3,7,11,         4,8,12,     5,9,13,     10,14,  15},
            new List<int>(){2,  1,3,7,      6,12,8,4,       11,13,9,5,  10,14,      15},
            new List<int>(){3,  2,8,4,      1,7,13,9,5,     6,12,14,10, 11,15},
            new List<int>(){4,  3,9,5,      2,8,14,10,      1,7,13,15,  6,12,       11},
            new List<int>(){5,  4,10,       3,9,15,         2,8,14,     1,7,13,     6,12,   11},
            new List<int>(){6,  1,7,11,     2,8,12,         3,9,13,     4,10,14,    5,15},
            new List<int>(){7,  2,6,8,12,   1,11,3,9,13,    4,10,14,    5,15},
            new List<int>(){8,  3,7,9,13,   2,6,12,4,10,14, 1,11,5,15},
            new List<int>(){9,  4,8,10,14,  5,15,3,7,13,    2,6,12,     1,11},
            new List<int>(){10, 5,9,15,     4,8,14,         3,7,13,     2,6,12,     1,11},
            new List<int>(){11, 6,12,       1,7,13,         2,8,14,     3,9,15,     4,10,   5},
            new List<int>(){12, 11,13,7,    6,2,8,14,       1,3,9,15,   10,4,       5},
            new List<int>(){13, 12,8,14,    11,7,3,9,15,    6,2,4,10,   1,5},
            new List<int>(){14, 13,9,15,    12,8,4,10,      11,7,3,5,   6,2,        1},
            new List<int>(){15, 14,10,      13,9,5,         12,8,4,     11,7,3,     6,2,    1},
        };

        public static List<List<int>> LineIndexList = new List<List<int>>()
        {
            new List<int>(){1,  2,  3,  3,  3,  2,  1},//1
            new List<int>(){1,  3,  4,  4,  2,  1    },//2
            new List<int>(){1,  3,  5,  4,  2        },//3
            new List<int>(){1,  3,  4,  4,  2,  1    },//4
            new List<int>(){1,  2,  3,  3,  3,  2,  1},//5
            new List<int>(){1,  3,  3,  3,  3,  2    },//6
            new List<int>(){1,  4,  5,  3,  2        },//7
            new List<int>(){1,  4,  6,  4            },//8
            new List<int>(){1,  4,  5,  3,  2        },//9
            new List<int>(){1,  3,  3,  3,  3,  2    },//10
            new List<int>(){1,  2,  3,  3,  3,  2,  1},//11
            new List<int>(){1,  3,  4,  4,  2,  1    },//12
            new List<int>(){1,  3,  5,  4,  2        },//13
            new List<int>(){1,  3,  4,  4,  2,  1    },//14
            new List<int>(){1,  2,  3,  3,  3,  2,  1},//15
        };
    }
    public class Data
    {
        public JW_Struct.SC_SceneInfo SceneData { get; set; }
        public JW_Struct.CMD_3D_SC_Result ResultData { get; set; }
        public long myGold { get; set; }
        public int CurrentChip { get; set; }
        public bool isFreeGame { get; set; }
        public bool isAutoGame { get; set; }
        public int CurrentChipIndex { get; set; }
        public int CurrentAutoCount { get; set; }
        public int CurrentFreeCount { get; set; }
        public int TotalFreeWin { get; set; }

    }
}
