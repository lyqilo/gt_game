using System.Collections.Generic;
using UnityEngine;

namespace Hotfix.HeiJieKe
{
    public class HJK_PlayerManager : SingletonILEntity<HJK_PlayerManager>
    {
        private Dictionary<int, HJK_Player> playerDic;

        protected override void Awake()
        {
            base.Awake();
            playerDic = new Dictionary<int, HJK_Player>();
        }

        protected override void AddEvent()
        {
            base.AddEvent();
            HJK_Event.OnPlayerEnter += HJK_EventOnOnPlayerEnter;
            HJK_Event.OnPlayerExit += HJK_EventOnOnPlayerExit;
        }

        protected override void RemoveEvent()
        {
            base.RemoveEvent();
            HJK_Event.OnPlayerEnter -= HJK_EventOnOnPlayerEnter;
            HJK_Event.OnPlayerExit -= HJK_EventOnOnPlayerExit;
        }

        private void HJK_EventOnOnPlayerExit(GameUserData obj)
        {
            if (!playerDic.ContainsKey(obj.ChairId)) return;
            HJK_Player player = playerDic[obj.ChairId];
            if (player == null) return;
            HJK_Extend.Instance.Collect(player.transform);
            Destroy(player);
            playerDic.Remove(obj.ChairId);
        }

        private void HJK_EventOnOnPlayerEnter(GameUserData obj)
        {
            HJK_Player player = null;
            if (!playerDic.ContainsKey(obj.ChairId))
            {
                Transform child = transform.GetChild(obj.ChairId);
                player = child.AddILComponent<HJK_Player>();
                player.SetData(obj);
                playerDic.Add(obj.ChairId, player);
                return;
            }

            player = playerDic[obj.ChairId];
            if (player == null) return;
            Destroy(player);
            playerDic.Remove(obj.ChairId);
        }
    }
}