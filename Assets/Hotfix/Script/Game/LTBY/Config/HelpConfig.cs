using System.Collections.Generic;

namespace Hotfix.LTBY
{
    public class HelpConfig
    {
        public class HelpContent
        {
            public string special;
            public string normal;
            public string name;
            public string des;
            public string imageBundleName;
            public string imageName;
            public float imageX;
            public float imageY;
            public string Text;
        }

        public static FrameData Frame = new FrameData()
        {
            x = 0, y = -20, w = 910, h = 540,
            Title = "Game Help",
            Flag1 = "Fish Gallery",
            Flag2 = "Operating",
            Flag3 = "Customer",
        };

        public static Dictionary<string, string> Flag = new Dictionary<string, string>()
        {
            {"Flag1", "Fish Gallery"},
            {"Flag2", "Operating"},
            {"Flag3", "Customer"},
        };


        public const string ScoreText = "score:";

        public static HelpContent Content1 = new HelpContent()
        {
            special = "Special Fish",
            normal = "Normal Fish",
        };

        public static List<HelpContent> Content2 = new List<HelpContent>()
        {
            new HelpContent()
            {
                name = "auto shoot",
                des = "Click“            ”can auto fire bullets, but need the player to control the way.",
                imageBundleName = "res_view",
                imageName = "yxjm_jn_zd_1",
                imageX = 97,
                imageY = 0,
            },
            new HelpContent()
            {
                name = "lock",
                des =
                    "Hold“             ”,open the locking setting, check the locking fish, you can set the locking range. \nClick the icon to open the lock function; you can lock and keep attacking the target. <color=#FFCB25FF>If the lock setting is checked, it will auto lock the checked fish for auto shooting;</color> during the process of auto locking, click the fish to switch the lock target. <color=#FFCB25FF>If all of the lock settings are unchecked, you need to click on the fish to lock the capture. </color>",
                imageBundleName = "res_view",
                imageName = "yxjm_jn_xz_1",
                imageX = 97,
                imageY = 90,
            },
            //new HelpContent(){
            //	name = "狂暴功能",
            //	des = "<color=#FFCB25FF>会员专属技能,充值任意点券即可获得会员。</color>\n点击“             ”图标可开启狂暴技能，可以加快发射子弹的速度。",
            //	imageBundleName = "res_view",
            //	imageName = "yxjm_p3_1",
            //	imageX = 97,
            //	imageY = -20,
            //},
            //new HelpContent(){
            //	name = "散射功能",
            //	des = "<color=#FFCB25FF>刺激战场专属技能，三弹齐发威力无比。</color>\n点击“             ”图标可开启散射技能，可以同时发射三发子弹。\n",
            //	imageBundleName = "res_view",
            //	imageName = "yxjm_ss",
            //	imageX = 97,
            //	imageY = 0,
            //},
        };

        public static HelpContent Content3 = new HelpContent()
        {
            //Text = "客服电话 ：4000-234-000\n客服 QQ  ：4000234000"
            // Text = "客服 QQ  ：4000234000"
            Text = "Please contact us in the game lobby"
        };
    }
}