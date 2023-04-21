

namespace Hotfix.MJHL
{
    public class MJHL_Event
    {
        /// <summary>
        /// 下注失败
        /// </summary>
        public static event CAction RollFailed;
        public static void DispatchRollFailed()
        {
            RollFailed?.Invoke();
        }
        /// <summary>
        /// 开始转动
        /// </summary>
        public static event CAction StartRoll;
        public static void DispatchStartRoll()
        {
            StartRoll?.Invoke();
        }

        public static event CAction StartReRoll;
        public static void DispatchStartReRoll()
        {
            StartReRoll?.Invoke();
        }
        /// <summary>
        /// 停止转动
        /// </summary>
        public static event CAction<bool> StopRoll;
        public static void DispatchStopRoll(bool isForce)
        {
            StopRoll?.Invoke(isForce);
        }

        /// <summary>
        /// 显示线
        /// </summary>
        public static event CAction ShowLine;
        public static void DispatchShowLine()
        {
            ShowLine?.Invoke();
        }


        public static event CAction ShowW;
        public static void DispatchShowW()
        {
            ShowW?.Invoke();
        }

        /// <summary>
        /// 展示结果
        /// </summary>
        public static event CAction ShowResult;
        public static void DispatchShowResult()
        {
            ShowResult?.Invoke();
        }

        /// <summary>
        /// 刷新金币
        /// </summary>
        public static event CAction<long> RefreshGold;
        public static void DispatchRefreshGold(long gold)
        {
            RefreshGold?.Invoke(gold);
        }
        /// <summary>
        /// 获取到场景消息
        /// </summary>
        public static event CAction OnGetSceneData;
        public static void DispatchOnGetSceneData()
        {
            OnGetSceneData?.Invoke();
        }
        /// <summary>
        /// 获取到游戏结果消息
        /// </summary>
        public static event CAction ShowResultComplete;
        public static void DispatchShowResultComplete()
        {
            ShowResultComplete?.Invoke();
        }
        /// <summary>
        /// 更改下注
        /// </summary>
        public static event CAction OnChangeBet;
        public static void DispatchOnChangeBet()
        {
            OnChangeBet.Invoke();
        }
        /// <summary>
        /// 转动准备完
        /// </summary>
        public static event CAction RollPrepreaComplete;
        public static void DispatchRollPrepreaComplete()
        {
            RollPrepreaComplete?.Invoke();
        }
        /// <summary>
        /// 转动完成
        /// </summary>
        public static event CAction RollComplete;
        public static void DispatchRollComplete()
        {
            RollComplete?.Invoke();
        }

        public static event CAction MJHL_PLAY_Multiple;
        public static void DispatchPLAY_Multiple()
        {
            MJHL_PLAY_Multiple?.Invoke();
        }


        public static event CAction<bool> MJHL_ISShow_FreeTIP;
        public static void DispatchISShow_FreeTIP(bool isShow)
        {
            MJHL_ISShow_FreeTIP?.Invoke(isShow);
        }


        public static event CAction<int> MJHL_OnceWinGold;
        public static void DispatchIOnceWinGold(int gold)
        {
            MJHL_OnceWinGold?.Invoke(gold);
        }

        public static event CAction<int> MJHL_AllWinGold;
        public static void DispatchIAllWinGold(int gold)
        {
            MJHL_AllWinGold?.Invoke(gold);
        }
    }
}
