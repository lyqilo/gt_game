using System.Collections.Generic;

namespace Hotfix.Fulinmen
{
    public class Data
    {
        public const int Chiplistcount = 5; //下注列表长度
        public const int Caishencount = 10; //财神个数
        public const int Allimgcount = 15; //图标个数
        public const int Alllinecount = 25; //连线数量
        public const int Columncount = 5; //每列个数

        public const float RollReboundRate = 0.3f; //每列停止后反弹比例（0：立即停止，值越大反弹速度越慢）
        public const float RollInterval = 0.07f; //每列转动间隔时间
        public const float RollSpeed = 15; //每列转动速度,可调节快慢
        public const float RollTime = 1; //转动时间
        public const float RollDistance = 80; //回弹距离，数值越大距离越大
        public const float waitShowLineTime = 0.3f;//等待展示连线奖励时间
        public const float lineAllShowTime = 2;//总连线展示时间
        public const float cyclePlayLineTime = 2;//连线轮播展示时间
        public const float autoNoRewardInterval = 0.5f;//自动或免费未中奖间隔
        public const float autoRewardInterval = 2;//自动或免费中奖间隔
        public const float freeLoadingShowTime = 1;//中免费展示时间
        public const float winGoldChangeRate = 1;//得分跑分速率
        public const float winBigGoldChangeRate = 2;//得分跑分速率
        public const float smallGameLoadingShowTime = 2;//中小游戏展示时间
        public const float rollReboundRate = 0.1f;//每列停止后反弹比例（0：立即停止，值越大反弹速度越慢）

        public static List<int> AutoList { get; }= new List<int>()
        {
            //自动旋转次数
            20, 50, 100, 10000
        };


        public static List<string> IconTable { get; }= new List<string>()
        {
            "Item1", //9  0
            "Item2", //10  1
            "Item3", //J  2
            "Item4", //Q  3
            "Item5", //K  4
            "Item6", //财  5
            "Item7", //寿(女娃)  6
            "Item8", //福(男娃)  7
            "Item9", //狮子(龙)   8
            "Item10", //听用(鱼)   9
            "Item11", //鞭炮   10
            "Item12", //金币   11
            "Item13", //金币数字   12
        };

        public static List<string> EffectTable { get; }= new List<string>()
        {
            "9", //财神动画 
            "10", //wild动画
            "J", //wildx2动画
            "Q", //金元宝动画
            "K", //银元宝动画
            "Cai", //红包动画
            "Shou", //中红包动画
            "Fu", //大红包动画
            "Long", //A动画
            "Wild", //K动画
            "BP", //Q动画
            "GOLD" //Q动画
        };

        public enum GameResultType
        {
            //游戏结果类型
            NORMAL = 0, //普通
            CYGG = 1, //财源滚滚
            JYMT = 2 //金玉满堂
        }

        public static List<List<byte>> Line { get; }= new List<List<byte>>()
        {
            //连线结果
            new List<byte>() {5, 6, 7, 8, 9}, //1
            new List<byte>() {0, 1, 2, 3, 4}, //2
            new List<byte>() {10, 11, 12, 13, 14}, //3
            new List<byte>() {0, 6, 12, 8, 4}, //4
            new List<byte>() {10, 6, 2, 8, 14}, //5
            new List<byte>() {0, 1, 7, 13, 14}, //6
            new List<byte>() {10, 11, 7, 3, 4}, //7
            new List<byte>() {5, 11, 12, 13, 9}, //8
            new List<byte>() {5, 1, 2, 3, 9}, //9
            new List<byte>() {0, 6, 7, 8, 4}, //10
            new List<byte>() {10, 6, 7, 8, 14}, //11
            new List<byte>() {0, 6, 2, 8, 4}, //12
            new List<byte>() {10, 6, 12, 8, 14}, //13
            new List<byte>() {5, 1, 7, 3, 9}, //14
            new List<byte>() {5, 11, 7, 13, 9}, //15
            new List<byte>() {5, 6, 2, 8, 9}, //16
            new List<byte>() {5, 6, 12, 8, 9}, //17
            new List<byte>() {0, 11, 2, 13, 4}, //18
            new List<byte>() {10, 1, 12, 3, 14}, //19
            new List<byte>() {5, 1, 12, 3, 9}, //20
            new List<byte>() {5, 11, 2, 13, 9}, //21
            new List<byte>() {0, 1, 12, 3, 4}, //22
            new List<byte>() {10, 11, 2, 13, 14}, //23
            new List<byte>() {0, 11, 12, 13, 4}, //24
            new List<byte>() {10, 1, 2, 3, 14} //25
        };
    }
}