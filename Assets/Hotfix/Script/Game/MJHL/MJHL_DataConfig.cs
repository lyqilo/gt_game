using System.Collections.Generic;
using UnityEngine;

namespace Hotfix.MJHL
{
    public class MJHL_DataConfig
    {
        #region Const
        /// <summary>
        /// 最大下注个数
        /// </summary>
        public const int MAX_BET_COUNT = 5;
        /// <summary>
        /// 最大icon个数
        /// </summary>
        public const int MAX_ALLICON = 30;
        /// <summary>
        /// 最大行
        /// </summary>
        public const int MAX_RAW = 6;
        /// <summary>
        /// 最大列
        /// </summary>
        public const int MAX_COL = 5;
        /// <summary>
        /// 连线数量
        /// </summary>
        public const int ALLLINECOUNT = 20;

        /// <summary>
        /// 免费自动结算
        /// </summary>
        public const int AUTOVERFREETIME = 20;


        /// <summary>
        /// 每次数据最大发送的值
        /// </summary>
        public const int ALLAcceptMaxCount = 5;

        public const float ImageDownShowTime = 0.15f;//下落时间
        public const float PlayTime = 5f;//下落时间

        public const float rollInterval = 0.1f;//每列转动间隔时间
        public const float rollStopInterval = 0.3f;//每列转动停止间隔时间

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
        #endregion

        public static List<string> IconTable = new List<string>{
            "Item1", 
            "Item2", 
            "Item3", 
            "Item4", 
            "Item5", 
            "Item6", 
            "Item7", 
            "Item8", 
            "Item9", 
            "Item10",
            "Item11",
        };

        public static List<Vector3> moveList = new List<Vector3>()
        {
            new Vector3(0,669,0),
            new Vector3(0,446,0),
            new Vector3(0,223,0),
            new Vector3(0,0,0),
            new Vector3(0,-223,0),
            new Vector3(0,-446,0),
            new Vector3(0,-669,0),
        };
    }
    public class Data
    {
        public MJHL_Struct.SC_SceneInfo SceneData { get; set; }
        public MJHL_Struct.CMD_3D_SC_Result ResultData { get; set; }
        public long myGold { get; set; }
        public int CurrentChip { get; set; }
        public bool isFreeGame { get; set; }
        public bool isAutoGame { get; set; }
        public int CurrentChipIndex { get; set; }
        public int CurrentAutoCount { get; set; }
        public int CurrentFreeCount { get; set; }
        public int TotalFreeWin { get; set; }
        public int Index { get; set; }


    }
}
