namespace Hotfix.HeiJieKe
{
    public class HJK_DataConfig
    {
        public const float TIMER_CHIP = 20; //下注时间
        public const float TIMER_DEAL_POKER_A0 = 1.5f; //发牌时间a0
        public const float TIMER_DEAL_POKER_D = 2; //发牌时间d
        public const float TIMER_DEAL_POKER_OFFSET = 5; //发牌时间offset
        public const float TIMER_INSURACE = 5; //5.5; 保险时间
        public const float TIMER_LOOK_ZJ_BLACK_JACK = 4.5f; //查看庄家是否黑杰克时间
        public const float TIMER_NORMAL_OPERATE = 10.5f; //玩家普通操作时间
        public const float TIMER_GAME_END = 8.5f; //游戏结束时间
        public const float TIMER_START_OPERATE = 1; //开始操作
        public const float TIMER_LOOK_ZJ_SECOND_POKER = 4.5f; //查看庄家第二张扑克
        public const float TIMER_ZJ_HIT_POKER = 4.5f; //庄家拿牌
        public const float TIMER_AUTO_ADD_POKER = 4.5f; //自动补牌
        public const float TIMER_AUTO_ADD_POKER_STAND = 2.5f; //动作补牌停止
        public const float TIMER_SERVER_OR_CLIENT_TIME = 2.5f; //延迟时间
        public const int GAME_PLAYER = 4; //玩家总人数
        public const int C_SPLIT_POKER_COUNT = 2; //分牌数
        public const int C_GROUP_MAX_POKER_COUNT = 8; //每组最大扑克数量
        public const int Chip13Area = 3;
    }

    public class Data
    {
        public HJK_Struct.CMD_SC_GAME_FREE SceneData;
    }
}