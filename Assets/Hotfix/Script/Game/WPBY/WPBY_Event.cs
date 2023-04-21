using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Hotfix.WPBY
{
    public static class WPBY_Event
    {
        public static event CAction OnGetSceneInfo;
        /// <summary>
        /// ��ȡ��������Ϣ
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
        /// ��ȡ����
        /// </summary>
        public static void DispatchOnGetConfig()
        {
            OnGetConfig?.Invoke();
        }

        public static event CAction<GameUserData> OnPlayerEnter;
        /// <summary>
        /// ��ҽ���
        /// </summary>
        /// <param name="data"></param>
        public static void DispatchOnPlayerEnter(GameUserData data)
        {
            OnPlayerEnter?.Invoke(data);
        }
        public static event CAction<GameUserData> OnPlayerExit;
        /// <summary>
        /// ����˳�
        /// </summary>
        /// <param name="data"></param>
        public static void DispatchOnPlayerExit(GameUserData data)
        {
            OnPlayerExit?.Invoke(data);
        }

        public static event CAction<GameUserData> OnPlayerScoreChanged;
        /// <summary>
        /// ��ҽ�ұ䶯
        /// </summary>
        /// <param name="data"></param>
        public static void DispatchOnPlayerScoreChanged(GameUserData data)
        {
            OnPlayerScoreChanged?.Invoke(data);
        }
    }
}
