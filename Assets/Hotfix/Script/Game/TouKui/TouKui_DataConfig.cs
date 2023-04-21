using System.Collections.Generic;
using UnityEngine;

namespace Hotfix.TouKui
{
    public class TouKui_DataConfig
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



        public const float rollInterval = 0.25f;//每列转动间隔时间
        public const float rollStopInterval = 0.35f;//每列转动停止间隔时间
        public const int rollSpeed = 16;//每列转动速度,可调节快慢
        public const float rollTime = 1f;//转动时间
        public const int rollReboundRate = 2;//每列停止后反弹比例（0：立即停止，值越大反弹速度
        public const int rollDistance = 80;//回弹距离，数值越大距离越大
        public const int winGoldChangeRate = 1;//得分跑分速率
        public const float winBigGoldChangeRate = 3f;//得分跑分速率
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
        public const float addSpeedTime = 1f;
        public const int showSelectFreeResultTime = 2;
        public const int showFreeResultTime = 3;//展示免费结算界面时间
        public const int showSmallGameResultTime = 3;//展示小游戏结算界面时间
        public const float smallMoveSpeed = 0.05f;//小游戏外围旋转速度
        #endregion

        public static List<string> IconTable = new List<string>{
            "Item1", //方块  1
            "Item2", // 梅花 2
            "Item3", //红桃  3
            "Item4", //黑桃  4
            "Item5", //女符号  5
            "Item6", //男符号  6
            "Item7", //屁股  7
            "Item8", //A 蓝色 8
            "Item9", //B  绿色 9
            "Item10", //C 黑色  10
            "Item11", //Wild   11
            "Item12", //Scatter   12
            "Item13", //Wild1 波霸  13
            "Item14", //Wild2 警花  14
            "Item15", //Wild3 学妹   15    
            "Item16", //Wild4 护士 16
        };
        /// <summary>
        /// 赔付线
        /// </summary>
        public static List<List<int>> Lines = new List<List<int>>()
        {
            new List<int>(){ 6, 7, 8, 9, 10 }, //1
            new List<int>(){ 1, 2, 3, 4, 5 }, //2
            new List<int>(){ 11, 12, 13, 14, 15 }, //3
            new List<int>(){ 1, 7, 13, 9, 5 }, //4
            new List<int>(){ 11, 7, 3, 9, 15 }, //5
            new List<int>(){ 1, 2, 8, 4, 5 }, //6
            new List<int>(){ 11, 12, 8, 14, 15 }, //7
            new List<int>(){ 6, 12, 13, 14, 10 }, //8
            new List<int>(){ 6, 2, 3, 4, 10 }, //9
            new List<int>(){ 1, 7, 8, 9, 5 }, //10
            new List<int>(){ 11, 7, 8, 9, 15 }, //11
            new List<int>(){ 1, 7, 3, 9, 5 }, //12
            new List<int>(){ 11, 7, 13, 9, 15 }, //13
            new List<int>(){ 6, 2, 8, 4, 10 }, //14
            new List<int>(){ 6, 12, 8, 14, 10 }, //15
            new List<int>(){ 6, 7, 3, 9, 10 }, //16
            new List<int>(){ 6, 7, 13, 9, 10 }, //17
            new List<int>(){ 1, 12, 3, 14, 5 }, //18
            new List<int>(){ 11, 2, 13, 4, 15 }, //19
            new List<int>(){ 6, 2, 13, 4, 10 }, //20
            new List<int>(){ 6, 12, 3, 14, 10 }, //21
            new List<int>(){ 1, 2, 13, 4, 5 }, //22
            new List<int>(){ 11, 12, 3, 14, 15 }, //23
            new List<int>(){ 1, 12, 13, 14, 5 }, //24
            new List<int>(){ 11, 2, 3, 4, 15 } //25
        };

        public static int ToushiRadius = 100;//透视镜半径
        /// <summary>
        /// 学妹透视镜中心点
        /// </summary>
        public static List<Vector3> XMCenter = new List<Vector3>()
        {
            new Vector3( 630, 100 ),
            new Vector3( 550, 25 ),
            new Vector3( 590, -115 ),
            new Vector3( 690, -320 )
        };
        /// <summary>
        /// 护士透视镜中心点
        /// </summary>
        public static List<Vector3> HSCenter = new List<Vector3>()
        {
            new Vector3( 640, 95 ),
            new Vector3( 535, 15 ),
            new Vector3( 565, -205 ),
            new Vector3( 600, -350 )
        };
        /// <summary>
        /// 警花透视镜中心点
        /// </summary>
        public static List<Vector3> JHCenter = new List<Vector3>()
        {
            new Vector3 ( 630, 90 ),
            new Vector3 ( 570, -5 ),
            new Vector3 ( 610, -165 ),
            new Vector3 ( 615, -330 )
        };
        /// <summary>
        /// 波霸中心点
        /// </summary>
        public static List<Vector3> BBCenter = new List<Vector3>()
        {
            new Vector3 ( 615, 100 ),
            new Vector3 ( 610, -30 ),
            new Vector3 ( 670, -200 ),
            new Vector3 ( 620, -330 )
        };

        public static Vector2 Fudong2x1 = new Vector2(404, 220);
        public static Vector2 Fudong2x2 = new Vector2(396, 396);
        public static Vector2 Fudong2x3 = new Vector2(396, 594);
        public static Vector2 Fudong3x3 = new Vector2(608, 608);

    }
    public class Data
    {
        public TouKui_Struct.SC_SceneInfo SceneData { get; set; }
        public TouKui_Struct.CMD_3D_SC_Result ResultData { get; set; }
        public long myGold { get; set; }
        public int CurrentChip { get; set; }
        public bool isFreeGame { get; set; }
        public bool isNormalFreeGame { get; set; }
        public bool isAutoGame { get; set; }
        public int CurrentChipIndex { get; set; }
        public int CurrentAutoCount { get; set; }
        public int CurrentFreeCount { get; set; }
        public int TotalFreeWin { get; set; }
        public SpecialMode CurrentMode { get; set; }
        public SpecialMode CurrentNormalMode { get; set; }

        public List<byte> FixWild { get; set; }

        public int CurrentExtOdd { get; set; }
        /// <summary>
        /// 浮动开始位置
        /// </summary>
        public int FuDongStartRow { get; set; }
        public int FuDongStartCol { get; set; }
        public int CurrentFuDongType { get; set; }
        public int CurrentFuDongExtWildCount { get; set; }
    }
    /// <summary>
    /// 特殊模式
    /// </summary>
    public enum SpecialMode
    {
        None,
        /// <summary>
        /// 扩散  波霸
        /// </summary>
        KuoSan,
        /// <summary>
        /// 固定  女警
        /// </summary>
        GuDing,
        /// <summary>
        /// 倍数  学妹
        /// </summary>
        BeiShu,
        /// <summary>
        /// 浮动  护士
        /// </summary>
        FuDong,
    }
}
