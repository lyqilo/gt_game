using System.Collections.Generic;
using UnityEngine;

namespace Hotfix.TiaoTiaoTangGuo
{
    public class TTTG_DataConfig
    {
        /// <summary>
        /// 最大下注个数
        /// </summary>
        public const int MAX_BET_COUNT = 10;

        /// <summary>
        /// 线数
        /// </summary>
        public const int LineCount = 25;

        /// <summary>
        /// 免费图标个数
        /// </summary>
        public const int GI_count = 7;

        public const int MAX_ICONCOUNT = 256;

        public const int MAX_HITTIMES = 7;

        public const int MAX_ALLICON = 20;

        public const int MAX_Col = 5;
        public const int MAX_Row = 4;
        public const string starEffect = "WinStar";
        public const string goldEffect = "Gold";

        /// <summary>
        /// 自动次数配置
        /// </summary>
        public static List<int> AutoConfig = new List<int>()
        {
            25, 50, 100, 200,
        };

        /// <summary>
        /// 元素倍数
        /// </summary>
        public static List<int> RateList = new List<int>()
        {
            1, 2, 3, 4, 5, 6, 7
        };
    }

    /// <summary>
    /// 游戏数据类
    /// </summary>
    public class Data
    {
        public bool isScene;
        public TTTG_Struct.SC_SceneInfo SceneData { get; set; }
        public TTTG_Struct.CMD_3D_SC_Result ResultData { get; set; }
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