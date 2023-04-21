using UnityEngine;

namespace Hotfix.TiaoTiaoTangGuo
{
    public class TTTG_Event
    {
        public static event CAction<TTTG_Struct.SC_SceneInfo> OnReceiveSceneInfo;

        /// <summary>
        /// 场景消息
        /// </summary>
        /// <param name="sceneInfo">场景消息数据</param>
        public static void DispatchOnReceiveSceneInfo(TTTG_Struct.SC_SceneInfo sceneInfo)
        {
            OnReceiveSceneInfo?.Invoke(sceneInfo);
        }

        public static event CAction<long> OnJackpotChanged;

        /// <summary>
        /// 推送jackpot
        /// </summary>
        /// <param name="jackpot">jackpot值</param>
        public static void DispatchOnJackpotChanged(long jackpot)
        {
            OnJackpotChanged?.Invoke(jackpot);
        }

        public static event CAction<int> OnBetChanged;

        /// <summary>
        /// 改变押注
        /// </summary>
        /// <param name="bet">押注</param>
        public static void DispatchOnBetChanged(int bet)
        {
            OnBetChanged?.Invoke(bet);
        }

        public static event CAction<bool> ShowResultIcon;

        /// <summary>
        /// 显示游戏结果图标
        /// </summary>
        public static void DispatchShowResultIcon(bool isfree)
        {
            ShowResultIcon?.Invoke(isfree);
        }

        public static event CAction<TTTG_Struct.CMD_3D_SC_Result> OnReceiveResult;

        /// <summary>
        /// 结果获取到
        /// </summary>
        /// <param name="result">结果</param>
        public static void DispatchOnReceiveResult(TTTG_Struct.CMD_3D_SC_Result result)
        {
            OnReceiveResult?.Invoke(result);
        }

        public static event CAction<GameUserData> OnUserScoreChanged;

        /// <summary>
        /// 玩家分数改变
        /// </summary>
        /// <param name="data"></param>
        public static void DispatchOnUserScoreChanged(GameUserData data)
        {
            OnUserScoreChanged?.Invoke(data);
        }

        public static event CAction<long> ChangeUserGold;

        /// <summary>
        /// 改变玩家金币
        /// </summary>
        /// <param name="gold"></param>
        public static void DispatchChangeUserGold(long gold)
        {
            ChangeUserGold?.Invoke(gold);
        }

        public static event CAction OnShowResultComplete;

        /// <summary>
        /// 展示结果完成
        /// </summary>
        public static void DispatchOnShowResultComplete()
        {
            OnShowResultComplete?.Invoke();
        }

        public static event CAction<int, Transform> OnHitSpecial;

        /// <summary>
        /// 积满特殊图标
        /// </summary>
        /// <param name="iconIndex">图标索引</param>
        /// <param name="target">目标</param>
        public static void DispatchOnHitSpecial(int iconIndex, Transform target)
        {
            OnHitSpecial?.Invoke(iconIndex, target);
        }

        public static event CAction OnResetGame;

        /// <summary>
        /// 重置游戏
        /// </summary>
        public static void DispatchOnResetGame()
        {
            OnResetGame?.Invoke();
        }

        public static event CAction OnMoveItem;

        /// <summary>
        /// 移动元素
        /// </summary>
        public static void DispatchOnMoveItem()
        {
            OnMoveItem?.Invoke();
        }

        public static event CAction ShowResult;

        /// <summary>
        /// 显示结果
        /// </summary>
        public static void DispatchShowResult()
        {
            ShowResult?.Invoke();
        }

        public static event CAction<int> ShowCombo;

        /// <summary>
        /// 显示combo
        /// </summary>
        public static void DispatchShowCombo(int combo)
        {
            ShowCombo?.Invoke(combo);
        }

        public static event CAction<bool> ShowFree;

        /// <summary>
        /// 显示免费
        /// </summary>
        /// <param name="isShow">true 开始  false 结束</param>
        public static void DispatchShowFree(bool isShow)
        {
            ShowFree?.Invoke(isShow);
        }

        public static event CAction<bool> MoveScreen;

        /// <summary>
        /// 移动屏幕
        /// </summary>
        /// <param name="isFree">是否免费游戏移动</param>
        public static void DispatchMoveScreen(bool isFree)
        {
            MoveScreen?.Invoke(isFree);
        }

        public static event CAction<bool> MoveScreenComplete;

        /// <summary>
        /// 移动屏幕完成
        /// </summary>
        /// <param name="isFree">是否免费游戏移动</param>
        public static void DispatchMoveScreenComplete(bool isFree)
        {
            MoveScreenComplete?.Invoke(isFree);
        }

        public static event CAction OnEnterFree;

        /// <summary>
        /// 进入免费
        /// </summary>
        public static void DispatchOnEnterFree()
        {
            OnEnterFree?.Invoke();
        }
    }
}