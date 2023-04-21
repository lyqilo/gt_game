using System.Collections.Generic;
using UnityEngine;

namespace Hotfix.LTBY
{
    public class BatteryConfig
    {
        public class Frame
        {
            public const float x = 0;
            public const float y = -20;
            public const float w = 900;
            public const float h = 540;
            public const string Title = "Choose cannon";
            public const string Tip = "Instructions: Click on the turret in the game to reselect the cannon！";
        }
        public const float ShowWaterSpoutTime = 0.5f;
        public const int DragonBatteryLevel = 9;		//雷皇龙炮
        public const int ZCMBatteryLevel = 10;			//招财猫炮
        public const string Unit = "X";
        public const string Qian = "K";
        public const string Wan = "w";
        public const string CountdownText = "Countdown:";
        public const string Day = "day";
        public const string Hour = "h";
        public const string Minute = "m";
        public const string Second = "s";
        public const string Forever = "永久";
        public const string Level = "级";
        public const string LockText = "未开启";
        public const string VipLockText = "获得炮台\nVip≥";
        public const string MemberLockText = "获得炮台\n会员专属";
        public const string ShootCountdownText = "剩余发射时间：";
        public const string MissileTip1 = "请瞄准奖金鱼发射火箭炮";
        public const string MissileTip2 = "火箭炮只能炸奖金鱼哦";
        public const string Permanent = "获得炮台\n永久会员专属";
        public const int LuckyCatGunLevel = 10;

        public static Dictionary<int, BatteryLevelData> DefaultBattery = new Dictionary<int, BatteryLevelData>()
        {
            {1, new BatteryLevelData(){ level = 1, ratio = 1 } },
            {2, new BatteryLevelData(){ level = 2, ratio = 10 } },
            {3, new BatteryLevelData(){ level = 3, ratio = 100 } },
            {4, new BatteryLevelData(){ level = 4, ratio = 1000 } },
            {5, new BatteryLevelData(){ level = 5, ratio = 10000 } },
        };
        public static Dictionary<int, BatteryData> Battery = new Dictionary<int, BatteryData>()
        {
            {1, new BatteryData(){ imageBundleName = "res_battery", imageName = "select_battery_1", name = "Level 1", des1 = "Practice", des2 = "", pivot=new Vector2(0.5f,0.2f)} },
            {2, new BatteryData(){ imageBundleName = "res_battery", imageName = "select_battery_2", name = "Level 2", des1 = "Advance", des2 = "shoot with great precision", pivot=new Vector2(0.5f,0.2f) } },
            {3, new BatteryData(){ imageBundleName = "res_battery", imageName = "select_battery_3", name = "Level 3", des1 = "Skilled", des2 = "Point and shoot", pivot=new Vector2(0.5f,0.2f)} },
            {4, new BatteryData(){ imageBundleName = "res_battery", imageName = "select_battery_4", name = "Level 4", des1 = "High hand", des2 = "Wealthy",pivot=new Vector2(0.5f,0.2f) } },
            {5, new BatteryData(){ imageBundleName = "res_battery", imageName = "select_battery_5", name = "Level 5", des1 = "Master", des2 = "Wealthy",pivot=new Vector2(0.5f,0.2f) } },
            {6, new BatteryData(){ imageBundleName = "res_battery", imageName = "select_battery_6", name = "Gold Armor", des1 = "Gold Armor", des2 = "Glowing all around", pivot=new Vector2(0.5f,0.2f)} },
            {7, new BatteryData(){ imageBundleName = "res_battery", imageName = "select_battery_7", name = "Holy Rider", des1 = "Exude all over", des2 = "Aristocratic air", pivot=new Vector2(0.5f,0.2f)} },
            {8, new BatteryData(){ imageBundleName = "res_battery", imageName = "select_battery_8", name = "Panda gun", des1 = "Panda", des2 = "smile on your face", scale = 1.1f ,pivot=new Vector2(0.5f,0.1f)} },
            {9, new BatteryData(){ imageBundleName = "res_battery", imageName = "select_battery_9", name = "Dragon Striker", des1 = "Dragon King Attack", des2 = "Incredible power", scale = 1.1f,pivot=new Vector2(0.5f,0.3f) } },
            {10, new BatteryData(){ imageBundleName = "res_battery", imageName = "select_battery_10", name = "Lucky Cannon", des1 = "Fortune Cat", des2 = "Gold coins rolled in", scale = 1.1f ,pivot=new Vector2(0.5f,0.3f)} },

        };

        public static Dictionary<int, Dictionary<int, BatteryWaterSpout>> BatteryWaterSpoutConfig = new Dictionary<int, Dictionary<int, BatteryWaterSpout>>()
        {

            { 9 , new Dictionary<int, BatteryWaterSpout>()
            {
                {1 , new BatteryWaterSpout(){ bundleName = "res_effect", materialName = "mat_shuizhu01", spoutWidth = 2 }},
                {2 , new BatteryWaterSpout(){ bundleName = "res_effect", materialName = "mat_shuizhu02", spoutWidth = 2 }},
                {3 , new BatteryWaterSpout(){ bundleName = "res_effect", materialName = "mat_shuizhu03", spoutWidth = 4 }},
                {4 , new BatteryWaterSpout(){ bundleName = "res_effect", materialName = "mat_shuizhu04", spoutWidth = 4 } },
            } },
            { 10 , new Dictionary<int, BatteryWaterSpout>()
            {
                {1 , new BatteryWaterSpout(){ bundleName = "res_effect", materialName = "mat_zcm_shuizhu01", spoutWidth = 4.5f } },
                {2 , new BatteryWaterSpout(){ bundleName = "res_effect", materialName = "mat_shuizhu02", spoutWidth = 2 } },
                {3 , new BatteryWaterSpout(){ bundleName = "res_effect", materialName = "mat_zcm_shuizhu02", spoutWidth = 5 } },
                {4 , new BatteryWaterSpout(){ bundleName = "res_effect", materialName = "mat_shuizhu04", spoutWidth = 4 } },
            } },
        };
    }

    public class BatteryLevelData
    {
        public int level;
        public int ratio;
    }

    public class BatteryData
    {
        public string imageBundleName;
        public string imageName;
        public string name;
        public string des1;
        public string des2;
        public float scale;
        public Vector2 pivot;
    }
    public class BatteryWaterSpout
    {
        public string bundleName;
        public string materialName;
        public float spoutWidth;
    }
}
