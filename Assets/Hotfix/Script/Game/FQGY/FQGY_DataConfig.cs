using System.Collections.Generic;

namespace Hotfix.FQGY
{
    public class FQGY_DataConfig
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
        public const int ALLLINECOUNT = 30;

        public const float rollStopInterval = 0.35f;//每列转动停止间隔时间
        public const float rollInterval = 0.3f;//每列转动间隔时间
        public const int rollSpeed = 16;//每列转动速度,可调节快慢
        public const float rollTime = 0.5f;//转动时间
        public const int rollReboundRate = 2;//每列停止后反弹比例（0：立即停止，值越大反弹速度
        public const int rollDistance = 80;//回弹距离，数值越大距离越大
        public const int winGoldChangeRate = 1;//得分跑分速率
        public const float winBigGoldChangeRate = 3f;//跑分时间
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


        public const float enterSmallWaitTime = 2f;//小游戏外围旋转速度

        #endregion

        public static List<string> IconTable = new List<string>{
            "item0",
            "item1",
            "item2",
            "item3",
            "item4",
            "item5",
            "item6",
            "item7",
            "item8",
            "item9",
            "item10",
        };
        /// <summary>
        /// 赔付线
        /// </summary>
        public static List<List<int>> Lines = new List<List<int>>()
        {
            new List<int>(){ 6, 7, 8, 9, 10 }, //1
            new List<int>(){ 1, 2, 3, 4, 5  }, //2
            new List<int>(){ 11,12,13,14,15 }, //3
            new List<int>(){ 1, 7, 13,9, 5  }, //4
            new List<int>(){ 11,7, 3, 9, 15 }, //5
            new List<int>(){ 6, 2, 3, 4, 10 }, //6
            new List<int>(){ 6, 12,13,14,10 }, //7
            new List<int>(){ 1, 2, 8, 14,15 }, //8
            new List<int>(){ 11,12,8, 4, 5  }, //9
            new List<int>(){ 6, 12,8, 4, 10 },//10
            new List<int>(){ 6, 2, 8, 14,10 }, //11
            new List<int>(){ 1, 7, 8, 9, 5  }, //12
            new List<int>(){ 11,7, 8, 9, 15 }, //13
            new List<int>(){ 1, 7, 3, 9, 5  }, //14
            new List<int>(){ 11,7, 13,9, 15 }, //15
            new List<int>(){ 6, 7, 3, 9, 10 }, //16
            new List<int>(){ 6, 7, 13,9, 10 }, //17
            new List<int>(){ 1, 2, 13,4, 5  }, //18
            new List<int>(){ 11,12,3, 14,15 }, //19
            new List<int>(){ 1, 12,13,14,5  }, //20
            new List<int>(){ 11,2, 3, 4, 15 }, //21
            new List<int>(){ 6, 12,3, 14,10 }, //22
            new List<int>(){ 6, 2, 13,4, 10 }, //23
            new List<int>(){ 1, 12,3, 14,5  }, //24
            new List<int>(){ 11,2, 13,4, 15 }, //25
            new List<int>(){ 11,2, 8, 14,5  }, //26
            new List<int>(){ 1, 12,8, 4, 15 }, //27
            new List<int>(){ 1, 12,8, 14,5  }, //28
            new List<int>(){ 11,2, 8, 4, 15 }, //29
            new List<int>(){ 11,7, 3, 4, 10 }, //20
        };

        /// <summary>
        /// 赔付线
        /// </summary>
        public static List<List<int>> SmallIconStopList = new List<List<int>>()
        {
            new List<int>(){ 0,6,16 },//1
            new List<int>(){ 5,17}, //2
            new List<int>(){ 8,11,22 }, //3
            new List<int>(){ 4,15,23 }, //4
            new List<int>(){ 7,14,20 }, //5
            new List<int>(){ 2,12,18 }, //6
            new List<int>(){ 3,10,19}, //7
            new List<int>(){ 9 }, //8
            new List<int>(){ 13 }, //9
            new List<int>(){ 1 },//10
            new List<int>(){ 21 }, //11
        };



    }
    public class Data
    {
        public FQGY_Struct.SC_SceneInfo SceneData { get; set; }
        public FQGY_Struct.CMD_3D_SC_Result ResultData { get; set; }
        public FQGY_Struct.CMD_3D_SC_SmallGameResult SmallGameData { get; set; }
        public long myGold { get; set; }
        public int CurrentChip { get; set; }
        public bool isFreeGame { get; set; }
        public bool isAutoGame { get; set; }
        public int CurrentChipIndex { get; set; }
        public int CurrentAutoCount { get; set; }
        public int CurrentFreeCount { get; set; }
        public int TotalFreeWin { get; set; }
        public bool isSmallGame { get; set; }
    }
}
