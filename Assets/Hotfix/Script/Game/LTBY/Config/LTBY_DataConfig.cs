using System.Collections.Generic;
using UnityEngine;

namespace Hotfix.LTBY
{
    public class LTBY_DataConfig
    {
        public const int GAME_PLAYER = 4; //房间人数
        public const int BULLET_COUNT = 10; //
        public const int MAX_FISH_KIND = 1;
        public const int MAX_BULLET = 256;
        public const int MAX_FISH = 35;
        public const int MAX_FISH_BUFFER = 100;
        public const int MAX_YUCHAOFISH_BUFFER = 2000;
        public const int MAX_FISH_POINT = 6;
        public const int MAX_FISH_COUNT = 50;
        public const int MAX_FISH_YC_COUNT = 220; //鱼潮最大个数
        public const int MAX_DEAD_FISH = 30;
        public const int MAX_PROBABILITY = 100000;
        public const int YuWangYuChaoCount = 3;
        public const int CreateFishGroupCount = 15;
        public const int MAX_YuChaoCount = 5;
        public const int MAX_BackgroundPicture = 18;
        public const int MAX_CalcFishMaxOdd = 20;

        public const float ContinueFireTime = 0.32f;

        /// <summary>
        /// 炮台大小
        /// </summary>
        public static readonly List<Vector3> BatteryScales = new List<Vector3>()
        {
            new Vector3(0.8f, 0.8f, 1), //1
            new Vector3(0.8f, 0.8f, 1), //2
            new Vector3(0.8f, 0.8f, 1), //3
            new Vector3(0.8f, 0.8f, 1), //4
            new Vector3(0.8f, 0.8f, 1), //5
            new Vector3(0.8f, 0.8f, 1), //6
            new Vector3(0.8f, 0.8f, 1), //7
            new Vector3(0.8f, 0.8f, 1), //8
            new Vector3(0.85f, 0.85f, 1), //9
            new Vector3(1f, 1f, 1), //10
            new Vector3(1f, 1f, 1), //11
            new Vector3(0.9f, 0.9f, 0.9f), //12
            new Vector3(1f, 1f, 1), //13
            new Vector3(1f, 1f, 1), //14
        };

        /// <summary>
        /// 炮台初始位置
        /// </summary>
        public static readonly List<Vector3> BatteryPoss = new List<Vector3>()
        {
            new Vector3(0, 20, 0), //1
            new Vector3(0, 15, 0), //2
            new Vector3(0, 15, 0), //3
            new Vector3(0, 15, 0), //4
            new Vector3(0, 5, 0), //5
            new Vector3(0, 15, 0), //6
            new Vector3(0, 15, 0), //7
            new Vector3(0, 0, 0), //8
            new Vector3(0, 45, 0), //9
            new Vector3(0, 45, 0), //10
            new Vector3(0, 0, 0), //11
            new Vector3(0, 0, 0), //12
            new Vector3(0, 0, 0), //13
            new Vector3(0, 0, 0), //14
        };

        /// <summary>
        /// 炮台名集合
        /// </summary>
        public static readonly List<string> BatteryNameList = new List<string>()
        {
            "Battery1", "Battery2", "Battery3", "Battery4", "Battery5", "Battery6", "Battery7", "Battery8", "Battery9",
            "Battery10",
        };

        /// <summary>
        /// 鱼名集合
        /// </summary>
        public static readonly Dictionary<int, string> FishNameDic = new Dictionary<int, string>()
        {
            {1, "fish_101"}, //蝴蝶鱼
            {2, "fish_102"}, //蜻蜓鱼
            {3, "fish_103"}, //比目鱼
            {4, "fish_104"}, //热带黄鱼
            {5, "fish_105"}, //大眼金鱼
            {6, "fish_106"}, //狮头鱼
            {7, "fish_107"}, //七彩鱼
            {8, "fish_108"}, //小丑鱼
            {9, "fish_109"}, //愤怒河豚
            {10, "fish_110"}, //孔雀鱼
            {11, "fish_111"}, //小青蛙
            {12, "fish_112"}, //乌龟
            {13, "fish_113"}, //龙虾
            {14, "fish_114"}, //地鲶鱼
            {15, "fish_115"}, //寒冰鱼
            {16, "fish_116"}, //地狱火鱼
            {17, "fish_117"}, //剑鱼
            {18, "fish_118"}, //飞鱼
            {19, "fish_119"}, //灯笼鱼
            {20, "fish_120"}, //炸弹鱼
            {21, "fish_121"}, //金炸弹鱼
            {22, "fish_122"}, //刺鳐鱼
            {23, "fish_123"}, //大白鲨
            {24, "fish_124"}, //大金鲨
            {25, "fish_125"}, //锤头金鲨
            {26, "fish_126"}, //虎鲸
            {27, "fish_127"}, //金蟾
            {28, "fish_128"}, //深海鲸
            {29, "fish_129"}, //美人鱼
            {30, "fish_131"}, //宝藏章鱼
            {31, "fish_132"}, //闪电海鳗
            {32, "fish_133"}, //奇遇蟹
            {33, "fish_134"}, //穿云蟹
            {34, "fish_136"}, //黄金巨龙
            {35, "fish_139"}, //闪电蝴蝶
            {36, "fish_140"}, //闪电蜻蜓
            {37, "fish_141"}, //电磁蟹
            {38, "fish_142"}, //大奖章鱼
            {39, "fish_143"}, //一网打尽
            {47, "fish_144"}, //雷皇龙
            {41, "fish_145"}, //聚宝盆
        };

        public static readonly List<Vector2> Points = new List<Vector2>()
        {
            new Vector2() {x = 1260, y = -380}, //1
            new Vector2() {x = 756, y = -380}, //2
            new Vector2() {x = 252, y = -380}, //3
            new Vector2() {x = -252, y = -380}, //4
            new Vector2() {x = -756, y = -380}, //5
            new Vector2() {x = -1260, y = -380}, //6
            new Vector2() {x = 1260, y = 380}, //7
            new Vector2() {x = 756, y = 380}, //8
            new Vector2() {x = 252, y = 380}, //9
            new Vector2() {x = -252, y = 380}, //10
            new Vector2() {x = -756, y = 380}, //11
            new Vector2() {x = -1260, y = 380}, //12
            new Vector2() {x = 1260, y = -330}, //13
            new Vector2() {x = 756, y = -330}, //14
            new Vector2() {x = 252, y = -330}, //15
            new Vector2() {x = -252, y = -330}, //16
            new Vector2() {x = -756, y = -330}, //17
            new Vector2() {x = -1260, y = -330}, //18
            new Vector2() {x = 1260, y = 330}, //19
            new Vector2() {x = 756, y = 330}, //20
            new Vector2() {x = 252, y = 330}, //21
            new Vector2() {x = -252, y = 330}, //22
            new Vector2() {x = -756, y = 330}, //2
            new Vector2() {x = -1260, y = 330}, //24
            new Vector2() {x = 1260, y = -235}, //25
            new Vector2() {x = 756, y = 840}, //26
            new Vector2() {x = 252, y = -640}, //27
            new Vector2() {x = -252, y = -640}, //28
            new Vector2() {x = -756, y = 840}, //29
            new Vector2() {x = -1260, y = -235}, //30
            new Vector2() {x = 1260, y = 235}, //31
            new Vector2() {x = 756, y = -840}, //32
            new Vector2() {x = 252, y = 640}, //33
            new Vector2() {x = -252, y = 640}, //34
            new Vector2() {x = -756, y = -840}, //35
            new Vector2() {x = -1260, y = 235}, //36
            new Vector2() {x = 1260, y = -205}, //37
            new Vector2() {x = 756, y = -205}, //38
            new Vector2() {x = 252, y = -205}, //39
            new Vector2() {x = -252, y = -205}, //40
            new Vector2() {x = -756, y = -205}, //41
            new Vector2() {x = -1260, y = -205}, //42
            new Vector2() {x = 1260, y = 205}, //43
            new Vector2() {x = 756, y = 205}, //44
            new Vector2() {x = 252, y = 205}, //45
            new Vector2() {x = -252, y = 205}, //46
            new Vector2() {x = -756, y = 205}, //47
            new Vector2() {x = -1260, y = 205}, //48
            new Vector2() {x = 1260, y = 0}, //49
            new Vector2() {x = 756, y = 0}, //50
            new Vector2() {x = 252, y = 0}, //51
            new Vector2() {x = -252, y = 0}, //52
            new Vector2() {x = -756, y = 0}, //53
            new Vector2() {x = -1260, y = 0}, //54
            new Vector2() {x = 1260, y = 400}, //55
            new Vector2() {x = 780, y = 30}, //56
            new Vector2() {x = 100, y = 100}, //57
            new Vector2() {x = -100, y = 100}, //58
            new Vector2() {x = -780, y = 30}, //59
            new Vector2() {x = -1260, y = 400}, //60
            new Vector2() {x = 1260, y = -400}, //61
            new Vector2() {x = 780, y = -30}, //62
            new Vector2() {x = 100, y = -100}, //63
            new Vector2() {x = -100, y = -100}, //64
            new Vector2() {x = -780, y = -30}, //65
            new Vector2() {x = -1260, y = -400}, //66
            new Vector2() {x = 756, y = 600}, //67
            new Vector2() {x = 756, y = 290}, //68
            new Vector2() {x = 523, y = 60}, //69
            new Vector2() {x = 233, y = 60}, //70
            new Vector2() {x = 30, y = 290}, //71
            new Vector2() {x = 30, y = 600}, //72
            new Vector2() {x = -756, y = 600}, //73
            new Vector2() {x = -756, y = 290}, //74
            new Vector2() {x = -523, y = 60}, //75
            new Vector2() {x = -233, y = 60}, //76
            new Vector2() {x = -30, y = 290}, //77
            new Vector2() {x = -30, y = 600}, //78
            new Vector2() {x = 756, y = -600}, //79
            new Vector2() {x = 756, y = -290}, //80
            new Vector2() {x = 523, y = -60}, //81
            new Vector2() {x = 233, y = -60}, //82
            new Vector2() {x = 30, y = -290}, //83
            new Vector2() {x = 30, y = -600}, //84
            new Vector2() {x = -756, y = -600}, //85
            new Vector2() {x = -756, y = -290}, //86
            new Vector2() {x = -523, y = -60}, //87
            new Vector2() {x = -233, y = -60}, //88
            new Vector2() {x = -30, y = -290}, //89
            new Vector2() {x = -30, y = -600}, //90
            new Vector2() {x = 596, y = 540}, //91
            new Vector2() {x = 596, y = 360}, //92
            new Vector2() {x = 388, y = 220}, //93
            new Vector2() {x = 208, y = 220}, //94
            new Vector2() {x = 190, y = 360}, //95
            new Vector2() {x = 190, y = 540}, //96
            new Vector2() {x = -596, y = 540}, //97
            new Vector2() {x = -596, y = 360}, //98
            new Vector2() {x = -388, y = 220}, //99
            new Vector2() {x = -208, y = 220}, //100
            new Vector2() {x = -190, y = 360}, //101
            new Vector2() {x = -190, y = 540}, //102
            new Vector2() {x = 596, y = -540}, //103
            new Vector2() {x = 596, y = -360}, //104
            new Vector2() {x = 388, y = -220}, //105
            new Vector2() {x = 208, y = -220}, //106
            new Vector2() {x = 190, y = -360}, //107
            new Vector2() {x = 190, y = -540}, //108
            new Vector2() {x = -596, y = -540}, //109
            new Vector2() {x = -596, y = -360}, //110
            new Vector2() {x = -388, y = -220}, //111
            new Vector2() {x = -208, y = -220}, //112
            new Vector2() {x = -190, y = -360}, //113
            new Vector2() {x = -190, y = -540}, //114
            new Vector2() {x = 1000, y = 600}, //115
            new Vector2() {x = 1000, y = 296}, //116
            new Vector2() {x = 932, y = 0}, //117
            new Vector2() {x = 628, y = 0}, //118
            new Vector2() {x = 324, y = 0}, //119
            new Vector2() {x = 20, y = 0}, //120
            new Vector2() {x = 1131, y = -283}, //121
            new Vector2() {x = 916, y = -498}, //122
            new Vector2() {x = 659, y = -659}, //123
            new Vector2() {x = 444, y = -444}, //124
            new Vector2() {x = 229, y = -229}, //125
            new Vector2() {x = 14, y = -14}, //126
            new Vector2() {x = 600, y = -1000}, //127
            new Vector2() {x = 296, y = -1000}, //128
            new Vector2() {x = 0, y = -932}, //129
            new Vector2() {x = 0, y = -628}, //130
            new Vector2() {x = 0, y = -324}, //131
            new Vector2() {x = 0, y = -20}, //132
            new Vector2() {x = -283, y = -1131}, //133
            new Vector2() {x = -498, y = -916}, //134
            new Vector2() {x = -659, y = -659}, //135
            new Vector2() {x = -444, y = -444}, //136
            new Vector2() {x = -229, y = -229}, //137
            new Vector2() {x = -14, y = -14}, //138
            new Vector2() {x = -1000, y = -600}, //139
            new Vector2() {x = -1000, y = -296}, //140
            new Vector2() {x = -932, y = 0}, //141
            new Vector2() {x = -628, y = 0}, //142
            new Vector2() {x = -324, y = 0}, //143
            new Vector2() {x = -20, y = 0}, //144
            new Vector2() {x = -1131, y = 283}, //145
            new Vector2() {x = -916, y = 498}, //146
            new Vector2() {x = -659, y = 659}, //147
            new Vector2() {x = -444, y = 444}, //148
            new Vector2() {x = -229, y = 229}, //149
            new Vector2() {x = -14, y = 14}, //150
            new Vector2() {x = -600, y = 1000}, //151
            new Vector2() {x = -296, y = 1000}, //152
            new Vector2() {x = 0, y = 932}, //153
            new Vector2() {x = 0, y = 628}, //154
            new Vector2() {x = 0, y = 324}, //155
            new Vector2() {x = 0, y = 20}, //156
            new Vector2() {x = 283, y = 1131}, //157
            new Vector2() {x = 498, y = 916}, //158
            new Vector2() {x = 659, y = 659}, //159
            new Vector2() {x = 444, y = 444}, //160
            new Vector2() {x = 229, y = 229}, //161
            new Vector2() {x = 14, y = 14}, //162
            new Vector2() {x = 1000, y = -600}, //163
            new Vector2() {x = 1000, y = -296}, //164
            new Vector2() {x = 283, y = -1131}, //165
            new Vector2() {x = 498, y = -916}, //166
            new Vector2() {x = -600, y = -1000}, //167
            new Vector2() {x = -296, y = -1000}, //168
            new Vector2() {x = -1131, y = -283}, //169
            new Vector2() {x = -916, y = -498}, //170
            new Vector2() {x = -1000, y = 600}, //171
            new Vector2() {x = -1000, y = 296}, //172
            new Vector2() {x = -283, y = 1131}, //173
            new Vector2() {x = -498, y = 916}, //174
            new Vector2() {x = 600, y = 1000}, //175
            new Vector2() {x = 296, y = 1000}, //176
            new Vector2() {x = 1131, y = 283}, //177
            new Vector2() {x = 916, y = 498,}, //178
        };

        /// <summary>
        /// 鱼线配置
        /// </summary>
        public static readonly List<List<int>> Lines = new List<List<int>>()
        {
            new List<int>() {0, 1, 2, 3, 4, 5},
            new List<int>() {6, 7, 8, 9, 10, 11},
            new List<int>() {12, 13, 14, 15, 16, 17},
            new List<int>() {18, 19, 20, 21, 22, 23},
            new List<int>() {24, 25, 26, 27, 28, 29},
            new List<int>() {30, 31, 32, 33, 34, 35},
            new List<int>() {36, 37, 38, 39, 40, 41},
            new List<int>() {42, 43, 44, 45, 46, 47},
            new List<int>() {48, 49, 50, 51, 52, 53},
            new List<int>() {5, 4, 3, 2, 1, 0},
            new List<int>() {11, 10, 9, 8, 7, 6},
            new List<int>() {17, 16, 15, 14, 13, 12},
            new List<int>() {23, 22, 21, 20, 19, 18},
            new List<int>() {29, 28, 27, 26, 25, 24},
            new List<int>() {35, 34, 33, 32, 31, 30},
            new List<int>() {41, 40, 39, 38, 37, 36},
            new List<int>() {47, 46, 45, 44, 43, 42},
            new List<int>() {53, 52, 51, 50, 49, 48},
            new List<int>() {48, 49, 50, 51, 52, 53},
            new List<int>() {54, 55, 56, 57, 58, 59},
            new List<int>() {60, 61, 62, 63, 64, 65},
            new List<int>() {66, 67, 68, 69, 70, 71},
            new List<int>() {72, 73, 74, 75, 76, 77},
            new List<int>() {78, 79, 80, 81, 82, 83},
            new List<int>() {84, 85, 86, 87, 88, 89},
            new List<int>() {90, 91, 92, 93, 94, 95},
            new List<int>() {96, 97, 98, 99, 100, 101},
            new List<int>() {102, 103, 104, 105, 106, 107},
            new List<int>() {108, 109, 110, 111, 112, 113},
            new List<int>() {114, 115, 116, 117, 118, 119},
            new List<int>() {120, 121, 122, 123, 124, 125},
            new List<int>() {126, 127, 128, 129, 130, 131},
            new List<int>() {132, 133, 134, 135, 136, 137},
            new List<int>() {138, 139, 140, 141, 142, 143},
            new List<int>() {144, 145, 146, 147, 148, 149},
            new List<int>() {150, 151, 152, 153, 154, 155},
            new List<int>() {156, 157, 158, 159, 160, 161},
            new List<int>() {162, 163, 116, 117, 118, 119},
            new List<int>() {164, 165, 122, 123, 124, 125},
            new List<int>() {166, 167, 128, 129, 130, 131},
            new List<int>() {168, 169, 134, 135, 136, 137},
            new List<int>() {170, 171, 140, 141, 142, 143},
            new List<int>() {172, 173, 146, 147, 148, 149},
            new List<int>() {174, 175, 152, 153, 154, 155},
            new List<int>() {176, 177, 158, 159, 160, 161}
        };

        public static readonly List<GunInfoData> gunInfos = new List<GunInfoData>()
        {
            new GunInfoData() {gun_level = 1, ratio_min = 1000, ratio_max = 10000, enable = true},
            new GunInfoData() {gun_level = 2, ratio_min = 2000, ratio_max = 20000, enable = true},
            new GunInfoData() {gun_level = 3, ratio_min = 3000, ratio_max = 30000, enable = true},
            new GunInfoData() {gun_level = 4, ratio_min = 4000, ratio_max = 40000, enable = true},
            new GunInfoData() {gun_level = 5, ratio_min = 5000, ratio_max = 50000, enable = true},
            new GunInfoData() {gun_level = 6, ratio_min = 6000, ratio_max = 60000, enable = true},
            new GunInfoData() {gun_level = 7, ratio_min = 7000, ratio_max = 70000, enable = true},
            new GunInfoData() {gun_level = 8, ratio_min = 8000, ratio_max = 80000, enable = true},
            new GunInfoData() {gun_level = 9, ratio_min = 9000, ratio_max = 90000, enable = true},
            new GunInfoData() {gun_level = 10, ratio_min = 10000, ratio_max = 100000, enable = true}
        };

        public static readonly VIPInfoData vipInfos = new VIPInfoData();
    }

    public class SCUserInfoNotify
    {
        public int chair_idx;
        public List<GunInfoData> gun_info;
        public List<VIPInfoData> vip_info;
        public List<PropInfoData> prop_info;
        public int last_gun_level;
        public int last_ratio;
    }

    public class GunInfoData
    {
        public bool new_enable;
        public int gun_level;
        public int ratio_min;
        public int ratio_max;
        public bool enable;
        public bool is_vip;
        public int vip_limit;
        public bool is_member;
        public int member_sec;
    }

    public class VIPInfoData
    {
        public int old_vip;
        public int cur_vip;
    }

    public class PropInfoData
    {
        public bool enable;
        public List<PropItemData> prop;
    }

    public class PropItemData
    {
    }

    /// <summary>
    /// 数据
    /// </summary>
    public class GameData : SingletonNew<GameData>
    {
        /// <summary>
        /// 记录本来的刷新时间
        /// </summary>
        public float recordFixedDeltaTime;

        /// <summary>
        /// 记录原有的质量
        /// </summary>
        public int recordQuality;

        /// <summary>
        /// 记录原有的帧率
        /// </summary>
        public int recordFps;

        /// <summary>
        /// 金币数
        /// </summary>
        public ulong Gold { get; set; }

        /// <summary>
        /// 椅子ID
        /// </summary>
        public int WChairID { get; set; }

        /// <summary>
        /// 玩家地图是否翻转
        /// </summary>
        public bool IsPlayerRevert { get; set; }

        /// <summary>
        /// 初始化配置
        /// </summary>
        public LTBY_Struct.CMD_S_CONFIG Config { get; set; }

        /// <summary>
        /// 玩家炮台数据
        /// </summary>
        public LTBY_Struct.CMD_S_PlayerGunLevel playerGuns { get; set; }
        public int ElectricDragonMultiple { get; set; }
    }
}