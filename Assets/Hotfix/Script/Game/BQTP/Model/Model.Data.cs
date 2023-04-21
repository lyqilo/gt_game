using System.Collections.Generic;

namespace Hotfix.BQTP
{
    public class Data
    {
        public const int Chiplistcount = 10; //下注列表长度
        public const int Caishencount = 10; //财神个数
        public const int Allimgcount = 15; //图标个数
        public const int Alllinecount = 50; //连线数量
        public const int Columncount = 5; //每列个数
        public const int Smallimgcount = 4; //小游戏图标个数
        public const int Smallrollcount = 24; //小游戏外围图标个数

        public const float RollReboundRate = 0.3f;//每列停止后反弹比例（0：立即停止，值越大反弹速度越慢）
        public const float RollInterval = 0.1f;//每列转动间隔时间
        public const float RollSpeed = 6;//每列转动速度,可调节快慢
        public const float RollTime = 1;//转动时间
        public const float RollDistance = 80;//回弹距离，数值越大距离越大
        public const float AutoNoRewardInterval = 0.2f;//自动或免费未中奖间隔
        public const float WinGoldChangeRate = 2f;//得分跑分速率

        public static List<int> AutoList = new List<int>()
        {
            //自动旋转次数
            20, 50, 100, 10000
        };
        
        public static List<string> IconTable = new List<string>()
        {
            "Item1", //che  1
            "Item2", // xie 2
            "Item3", //红面罩  3
            "Item4", //蓝球场  4
            "Item5", //黄色对抗  5
            "Item6", //绿色裁判  6
            "Item7", //守门员  7
            "Item8", //蓝队员  8
            "Item9", //红色冲刺队员   9
            "Item10", //wild   10
            "Item11", //scatter   11
        };

        public static List<string> EffectTable = new List<string>()
        {
            "Item1", //che  1
            "Item2", // xie 2
            "Item3", //红面罩  3
            "Item4", //蓝球场  4
            "Item5", //黄色对抗  5
            "Item6", //绿色裁判  6
            "Item7", //守门员  7
            "Item8", //蓝队员  8
            "Item9", //红色冲刺队员   9
            "Item10", //wild   10
            "Item11", //scatter   11
        };

        public static List<float> ItemPosList = new List<float>()
        {
            82.5f, 249.5f, 416.5f, 583.5f, 750.5f, 917.5f
        }; //-418,251,-84,
    }
}