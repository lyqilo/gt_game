using System.Collections.Generic;


namespace Hotfix.LTBY
{
    public class SetConfig
    {
        public static FrameData Frame = new FrameData()
        {
            x = 0,
            y = 0,
            w = 650,
            h = 420,
            Title = "game set",
        };

        public const string Effect = "Music";

        public const string Music = "Sound";
        public const string LowPower1 = "Min";
        public const string LowPower2 = "Low";
        public const string LowPower3 = "Nom";
        public const string LowPower4 = "High";

        public const string OpenText = "on";
        public const string CloseText = "off";

        public static Dictionary<string, string> LowPower = new Dictionary<string, string>()
        {
            {"LowPower1", "Min"},
            {"LowPower2", "Low"},
            {"LowPower3", "Nom"},
            {"LowPower4", "High"},
        };
    }
}