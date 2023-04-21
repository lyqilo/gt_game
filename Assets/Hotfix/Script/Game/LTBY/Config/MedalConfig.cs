using UnityEngine;

namespace Hotfix.LTBY
{
    public class MedalConfig
    {
        public static FrameData Frame = new FrameData()
        {
            x = 0,
            y = -20,
            w = 840,
            h = 500,
            Title = "Vip勋章",
            VipText = "当前 Vip 等级：",
            MedalText = "VIP勋章：",
            Des1 = "1.VIP经验获得方式：在游戏中投入金币可获得VIP经验，提升VIP等级;",
            Des2 = "2.退出游戏时，结算本次VIP经验;",
            Des3 = "3.满足VIP等级要求即可获得对应VIP勋章。",
        };
        public const string Sit = "sit";
    }

    public class FrameData
    {
        public int x;
        public int y;
        public int w;
        public int h;
        public string Title;
        public string VipText;
        public string MedalText;
        public string Des1;
        public string Des2;
        public string Des3;
        public string Flag1;
        public string Flag2;
        public string Flag3;
        public string BtnAll;
        public string BtnNone;
    }
}
