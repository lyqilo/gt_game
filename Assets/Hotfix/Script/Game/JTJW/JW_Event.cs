

namespace Hotfix.JTJW
{
    public class JW_Event
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
        /// 图片切换
        /// </summary>
        public static event CAction ChangeImage;
        public static void DispatchChangeImage()
        {
            ChangeImage?.Invoke();
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

        public static event CAction JW_TWG_PLAY;
        public static void DispatchTWGPlay()
        {
            JW_TWG_PLAY?.Invoke();
        }

        public static event CAction ShowFreePlay;
        public static void DispatchShowFreePlay()
        {
            ShowFreePlay?.Invoke();
        }
    }
}
