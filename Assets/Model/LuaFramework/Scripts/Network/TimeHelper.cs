using System;

namespace LuaFramework
{
    public static class TimeHelper
    {
        public static int timeOffset { get; set; } = 0;

        static TimeHelper()
        {
            int num = Math.Abs((DateTime.Now - DateTime.UtcNow).Hours);
            bool flag = num != 8;
            if (flag)
            {
                TimeHelper.timeOffset = 8;
            }
        }

        public static long ClientNow()
        {
            return Convert.ToInt64((DateTime.UtcNow - TimeHelper.epoch).TotalMilliseconds);
        }

        public static long ClientNowSeconds()
        {
            return Convert.ToInt64((DateTime.UtcNow - TimeHelper.epoch).TotalSeconds);
        }

        public static long ClientNowTicks()
        {
            return Convert.ToInt64((DateTime.UtcNow - TimeHelper.epoch).Ticks);
        }

        public static long Now()
        {
            return TimeHelper.ClientNow();
        }

        public static string Format(string s = "yyyyMMddhhmmss")
        {
            return string.Format("{0}", DateTime.Now.AddHours((double)TimeHelper.timeOffset).ToString(s));
        }

        public static string TFat
        {
            get
            {
                return string.Format("{0:HH:mm:ss:fff}", DateTime.Now.AddHours((double)TimeHelper.timeOffset));
            }
        }

        public static long ToNumber()
        {
            long result = -1L;
            long.TryParse(TimeHelper.Format("yyyyMMddhhmmss"), out result);
            return result;
        }

        private static readonly DateTime epoch = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc);
    }
}
