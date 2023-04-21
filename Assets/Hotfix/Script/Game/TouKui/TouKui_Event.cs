

using System.Collections.Generic;
using UnityEngine;

namespace Hotfix.TouKui
{
    public class TouKui_Event
    {
        /// <summary>
        /// 下注失败
        /// </summary>
        public static event CAction BetFailed;
        public static void DispatchBetFailed()
        {
            BetFailed?.Invoke();
        }
        /// <summary>
        /// 开始转动
        /// </summary>
        public static event CAction StartRoll;
        public static void DispatchStartRoll()
        {
            StartRoll?.Invoke();
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
        public static event CAction<bool> ShowResultComplete;
        public static void DispatchShowResultComplete(bool isWin)
        {
            ShowResultComplete?.Invoke(isWin);
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
        /// <summary>
        /// 显示特殊模式背景
        /// </summary>
        public static event CAction<SpecialMode> ChangeSpecialModeBackground;
        public static void DispatchChangeSpecialModeBackground(SpecialMode mode)
        {
            ChangeSpecialModeBackground?.Invoke(mode);
        }
        /// <summary>
        /// 进入特殊模式
        /// </summary>
        public static event CAction<bool,SpecialMode> OnEnterSpecialGame;
        public static void DispatchOnEnterSpecialGame(bool isFree,SpecialMode specialMode)
        {
            OnEnterSpecialGame?.Invoke(isFree,specialMode);
        }
        /// <summary>
        /// 选场完毕
        /// </summary>
        public static event CAction SelectFreeGameComplete;
        public static void DispatchSelectFreeGameComplete()
        {
            SelectFreeGameComplete?.Invoke();
        }
        /// <summary>
        /// 离开特殊模式
        /// </summary>
        public static event CAction ExitSpecialMode;
        public static void DispatchExitSpecialMode()
        {
            ExitSpecialMode?.Invoke();
        }
        /// <summary>
        /// 增加倍数
        /// </summary>
        public static event CAction<List<Vector3>> AddSpecialBeiShu;
        public static void DispatchAddSpecialBeiShu(List<Vector3> beishupos)
        {
            AddSpecialBeiShu?.Invoke(beishupos);
        }
        /// <summary>
        /// 显示浮动
        /// </summary>
        public static event CAction ChangeFudong;
        public static void DispatchChangeFudong()
        {
            ChangeFudong?.Invoke();
        }

        /// <summary>
        /// 启动开始
        /// </summary>
        public static event CAction CheckRunState;
        public static void DispatchCheckRunState()
        {
            CheckRunState?.Invoke();
        }
        /// <summary>
        /// 显示透视镜
        /// </summary>
        public static event CAction<ResultType> ShowLens;
        public static void DispatchShowLens(ResultType type)
        {
            ShowLens?.Invoke(type);
        }
        /// <summary>
        /// 显示浮动中奖
        /// </summary>
        public static event CAction<bool> ShowFuDongWin;
        public static void DispatchShowFuDongWin(bool isShow)
        {
            ShowFuDongWin?.Invoke(isShow);
        }

    }
}
