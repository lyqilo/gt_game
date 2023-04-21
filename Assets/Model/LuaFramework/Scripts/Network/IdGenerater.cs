
namespace LuaFramework
{
    public static class IdGenerater
    {
        public static long AppId { private get; set; }

        public static long GenerateId()
        {
            long num = TimeHelper.ClientNowSeconds();
            return (IdGenerater.AppId << 48) + (num << 16) + (long)((ulong)(IdGenerater.value += 1));
        }

        private static ushort value;
    }
}
