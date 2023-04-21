using System.Collections.Generic;

namespace Hotfix.WPBY
{
    public class WPBY_DataConfig
    {
        public const int GAME_PLAYER = 4;//房间人数
        public const int BULLET_COUNT = 10;
        public const int MAX_FISH_KIND = 1;
        public const int MAX_BULLET = 256;
        public const int MAX_FISH = 35;
        public const int MAX_FISH_BUFFER = 100;
        public const int MAX_YUCHAOFISH_BUFFER = 2000;
        public const int MAX_FISH_POINT = 6;
        public const int MAX_FISH_COUNT = 50;
        public const int MAX_DEAD_FISH = 30;
        public const int MAX_PROBABILITY = 100000;
        public const int YuWangYuChaoCount = 3;
        public const int CreateFishGroupCount = 15;
        public const int MAX_YuChaoCount = 5;
        public const int MAX_BackgroundPicture = 18;
        public const int MAX_CalcFishMaxOdd = 20;
        public static List<string> FishKind = new List<string>()
        {
            "fish_01", //小黄鱼
            "fish_02",//-小草鱼
            "fish_03",//-热带鱼
            "fish_04",//-扁嘴鱼
            "fish_05",//-小扁鱼
            "fish_06",//-小丑鱼
            "fish_07",//刺猬鱼
            "fish_08",//-蓝鲮鱼
            "fish_09",//-灯笼鱼
            "fish_10", //乌龟
            "fish_11", //燕尾鱼
            "fish_12", //蝴蝶鱼
            "fish_13", //公主鱼
            "fish_14", //短吻鱼
            "fish_15", //蝙蝠鱼
            "fish_16", //银鲨
            "fish_17", //金鲨
            "fish_20",//-金币海豚
            "fish_53",//-银龙
            "fish_19", //金龙
            "fish_18", //企鹅
            "fish_21", //李逵
            "fish_22",//-水浒传 全屏炸弹
            "fish_23",//-忠义堂 能量弹
            "fish_28",//-一网打尽
            "fish_27",//局部炸弹
            "fish_29",//-鱼王1
            "fish_31", //鱼王2
            "fish_32",//-鱼王3
            "fish_33",//-鱼王4
            "fish_34",//-鱼王5
            "fish_35",//-鱼王6
            "fish_36",//-鱼王7
            "fish_37",//鱼王8
            "fish_38",//-鱼王9
            "fish_39",//-鱼王10
            "fish_40",//-同类炸弹1
            "fish_41", //同类炸弹2
            "fish_42",//-同类炸弹3
            "fish_43",//-同类炸弹4
            "fish_44",//-同类炸弹5
            "fish_49",//-大三元1
            "fish_50",//-大三元2
            "fish_51", //大三元3
            "fish_52",//-大三元4
            "fish_45",//-大四喜1
            "fish_46",//-大四喜2
            "fish_47",//-大四喜3
            "fish_48",//-大四喜4
        };
        public static List<string> FishType = new List<string>()
        {
            "XiaoHuangYu", // 小黄鱼
            "XiaoCaoYu", // 小草鱼
            "ReDaiYu", // 热带鱼
            "BianZuiYu", // 扁嘴鱼
            "XiaoBianYu", // 小扁鱼
            "XiaoChouYu", // 小丑鱼
            "CiWeiYu", // 刺猬鱼
            "LanLingYu", // 蓝鲮鱼
            "DengLongYu", // 灯笼鱼
            "WuGui", // 乌龟
            "YanWeiYu", // 燕尾鱼
            "HuDieYu", // 蝴蝶鱼
            "GongZhuYu", // 公主鱼
            "DuanWenYu", // 短吻鱼
            "BianFuYu", // 蝙蝠鱼
            "YinSha", // 银鲨
            "JinSha", // 金鲨
            "JinBiHaiTun", // 金币海豚 18
            "YinLong", // 银龙
            "JinLong", // 金龙
            "QiE", // 企鹅
            "LiKui", // 李逵
            "ShuiHuZhuan", // 水浒传 全屏炸弹
            "ZhongYiTang", // 忠义堂 能量弹
            "YiWangDaJin", // 一网打尽
            "JuBuZhaDan", // 局部炸弹
            "YuWang1", // 鱼王1//27
            "YuWang2", // 鱼王2
            "YuWang3", // 鱼王3
            "YuWang4", // 鱼王4
            "YuWang5", // 鱼王5
            "YuWang6", // 鱼王6
            "YuWang7", // 鱼王7
            "YuWang8", // 鱼王8
            "YuWang9", // 鱼王9
            "YuWang10", // 鱼王10//36
            "TongLeiZhaDan1", // 同类炸弹1
            "TongLeiZhaDan2", // 同类炸弹2
            "TongLeiZhaDan3", // 同类炸弹3
            "TongLeiZhaDan4", // 同类炸弹4
            "TongLeiZhaDan5", // 同类炸弹5
            "DaSanYuan1", // 大三元1
            "DaSanYuan2", // 大三元2
            "DaSanYuan3", // 大三元3
            "DaSanYuan4", // 大三元4
            "DaSiXi1", // 大四喜1
            "DaSiXi2", // 大四喜2
            "DaSiXi3", // 大四喜3
            "DaSiXi4", // 大四喜4
         };
        public static List<float> StartScale = new List<float>()
        {
            1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1.5f, 1.5f, 1.3f, 2, 2, 2, 2.5f, 2, 2, 1.5f, 1.2f, 1.3f, 1.3f, 1.3f, 1.3f, 1.3f, 1.3f, 1.3f, 1.3f, 1.3f, 1.3f, 1.5f, 1.5f, 1.5f, 1.5f, 1.5f, 1.2f, 1.2f, 1.2f, 1.2f, 1.2f, 1.2f, 1.2f, 1.2f
        };
    }

    public class Data
    {
        public WPBY_Struct.CMD_S_CONFIG Config;
        public long myGold;
        public int ChairID;
        public bool isRevert;
        public bool isYc;
    }
}