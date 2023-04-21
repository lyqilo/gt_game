using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Hotfix.WPBY
{
    public static class WPBY_Event
    {
        public static event CAction OnGetSceneInfo;
        /// <summary>
        /// 获取到场景消息
        /// </summary>
        public static void DispatchOnGetSceneInfo()
        {
            OnGetSceneInfo?.Invoke();
        }

        public static event CAction OnLeaveGame;
        public static void DispatchOnLeaveGame()
        {
            OnLeaveGame?.Invoke();
        }

        public static event CAction OnGetConfig;
        /// <summary>
        /// 获取配置
        /// </summary>
        public static void DispatchOnGetConfig()
        {
            OnGetConfig?.Invoke();
        }

        public static event CAction<GameUserData> OnPlayerEnter;
        /// <summary>
        /// 玩家进入
        /// </summary>
        /// <param name="data"></param>
        public static void DispatchOnPlayerEnter(GameUserData data)
        {
            OnPlayerEnter?.Invoke(data);
        }
        public static event CAction<GameUserData> OnPlayerExit;
        /// <summary>
        /// 玩家退出
        /// </summary>
        /// <param name="data"></param>
        public static void DispatchOnPlayerExit(GameUserData data)
        {
            OnPlayerExit?.Invoke(data);
        }

        public static event CAction<GameUserData> OnPlayerScoreChanged;
        /// <summary>
        /// 玩家金币变动
        /// </summary>
        /// <param name="data"></param>
        public static void DispatchOnPlayerScoreChanged(GameUserData data)
        {
            OnPlayerScoreChanged?.Invoke(data);
        }
    }
}
