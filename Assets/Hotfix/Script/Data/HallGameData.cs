namespace Hotfix
{
    public class HallGameData : SingletonNew<HallGameData>
    {
    }

    public class AllSetGameInfo
    {
        // 背景音乐
        public static int _1audio = 1;

        // 音效
        public static int _2soundEffect = 1;

        // 亮度
        public static string _3Brightness = "";

        // 画质
        public static int _4quality = 4;

        // 背景音乐静音
        public static bool _5IsPlayAudio = true;

        // 音效 静音
        public static bool _6IsPlayEffect = true;
    }
}