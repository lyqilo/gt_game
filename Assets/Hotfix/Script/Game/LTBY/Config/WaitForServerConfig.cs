namespace Hotfix.LTBY
{
    public class WaitForServerConfig
    {
        //多久之后出黑屏
        public const float waitTime1 = 3;
        //出黑屏之后多久提回大厅
        public const float waitTime2 = 10;
        //连接的文字
        public const string connectText = "connecting...";
        public const string reconnectText = "reconnecting...";
        public const string ConnectError = "Connection server failed, please go back to the login screen to log in again";
    }
}
