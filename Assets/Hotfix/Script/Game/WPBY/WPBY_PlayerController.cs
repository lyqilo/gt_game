using System;
using System.Collections;
using System.Collections.Generic;
using Hotfix;
using UnityEngine;

namespace Hotfix.WPBY
{
    public class WPBY_PlayerController : SingletonILEntity<WPBY_PlayerController>
    {
        Dictionary<int, WPBY_Player> playerList;
        public float acceleration = 0.2f;
        public bool isLock = false;
        protected override void Awake()
        {
            base.Awake();
            playerList = new Dictionary<int, WPBY_Player>();
            isLock = false;
        }
        protected override void FindComponent()
        {
            base.FindComponent();
            for (int i = 0; i < WPBYEntry.Instance.playerGroup.childCount; i++)
            {
                WPBYEntry.Instance.playerGroup.GetChild(i).Find("PaoTai/OnSit").gameObject.SetActive(false);
                WPBYEntry.Instance.playerGroup.GetChild(i).Find("PaoTai/GunGroup").gameObject.SetActive(false);
                WPBYEntry.Instance.playerGroup.GetChild(i).Find("PaoTai/ChangeGun").gameObject.SetActive(false);
                WPBYEntry.Instance.playerGroup.GetChild(i).Find("PaoTai/Chip").gameObject.SetActive(false);
                WPBYEntry.Instance.playerGroup.GetChild(i).Find("PaoTai/Gun_Function").gameObject.SetActive(false);
                WPBYEntry.Instance.playerGroup.GetChild(i).Find("PaoTai/Level").gameObject.SetActive(false);
                WPBYEntry.Instance.playerGroup.GetChild(i).Find("ChangeGoldGroup").gameObject.SetActive(false);
                WPBYEntry.Instance.playerGroup.GetChild(i).Find("UserInfo").gameObject.SetActive(false);
                WPBYEntry.Instance.playerGroup.GetChild(i).Find("SelfPos").gameObject.SetActive(false);
                WPBYEntry.Instance.playerGroup.GetChild(i).gameObject.SetActive(false);
            }
        }
        protected override void AddEvent()
        {
            base.AddEvent();
            WPBY_Event.OnGetConfig += WPBY_Event_OnGetConfig;
            WPBY_Event.OnPlayerEnter += WPBY_Event_OnPlayerEnter;
            WPBY_Event.OnPlayerExit += WPBY_Event_OnPlayerExit;
            WPBY_Event.OnPlayerScoreChanged += WPBY_Event_OnPlayerScoreChanged;
        }

        protected override void RemoveEvent()
        {
            base.RemoveEvent();
            WPBY_Event.OnGetConfig -= WPBY_Event_OnGetConfig;
            WPBY_Event.OnPlayerEnter -= WPBY_Event_OnPlayerEnter;
            WPBY_Event.OnPlayerExit -= WPBY_Event_OnPlayerExit;
            WPBY_Event.OnPlayerScoreChanged -= WPBY_Event_OnPlayerScoreChanged;
        }

        private void WPBY_Event_OnPlayerScoreChanged(GameUserData data)
        {
            WPBY_Player player = GetPlayer(data.ChairId);
            if (player == null) return;
            player.userGold.text = ToolHelper.ShowRichText(data.Gold);
        }

        private void WPBY_Event_OnPlayerExit(GameUserData data)
        {
            DestroyPlayer(data.ChairId);
        }
        private void WPBY_Event_OnGetConfig()
        {

        }

        private void WPBY_Event_OnPlayerEnter(GameUserData data)
        {
            InitPlayer(data);
        }

        private void InitPlayer(GameUserData userdata)
        {
            WPBY_Player player = WPBYEntry.Instance.playerGroup.GetChild(userdata.ChairId).gameObject.AddILComponent<WPBY_Player>();
            player.gameObject.SetActive(true);
            playerList.Add(userdata.ChairId, player);
            player.Enter(userdata);
        }
        public WPBY_Player GetPlayer(int wChairId)
        {
            WPBY_Player player = null;
            playerList.TryGetValue(wChairId, out player);
            return player;
        }

        public void DestroyPlayer(int pos)
        {
            if (playerList.ContainsKey(pos))
            {
                playerList[pos].Leave();
                playerList.Remove(pos);
            }
        }
        public void SetPlayerGunLevel(WPBY_Struct.CMD_S_PlayerGunLevel levels)
        {
            for (int i = 0; i < WPBY_DataConfig.GAME_PLAYER; i++)
            {
                WPBY_Player player = GetPlayer(i);
                if (player != null)
                {
                    player.OnSetUserGunLevel((byte)levels.GunLevel[i], (byte)levels.GunType[i]);
                }
            }
        }
        public void ClearBullet()
        {
            WPBY_Player[] players = playerList.GetDictionaryValues();
            for (int i = 0; i < players.Length; i++)
            {
                if (players[i] != null)
                {
                    players[i].CollectBullet();
                }
            }
        }
        public void OnInitBulltSeting(WPBY_Struct.CMD_S_CONFIG config)
        {

        }

        public void ShootSelfBullet(Vector2 pos, int chairId)
        {
            WPBY_Player selfPlayer = GetPlayer(chairId);
            if (selfPlayer == null) return;
            if (selfPlayer.goldNum < (ulong)(WPBYEntry.Instance.GameData.Config.bulletScore[selfPlayer.gungrade] * (selfPlayer.gunLevel + 1)))
            {
                if (selfPlayer.isSelf)
                {
                    ToolHelper.PopSmallWindow($"金币不足!");
                    WPBYEntry.Instance.ControlLock(false);
                    WPBYEntry.Instance.ControlContinue(false);
                    return;
                }
                else
                {
                    DebugHelper.LogError($"没有金币了{chairId}");
                }
            }
            WPBY_Struct.PlayerShoot playerShoot = new WPBY_Struct.PlayerShoot();
            if (WPBYEntry.Instance.GameData.isRevert)
            {
                playerShoot.x = -pos.x;
                playerShoot.y = -pos.y;
            }
            else
            {
                playerShoot.x = pos.x;
                playerShoot.y = pos.y;
            }
            playerShoot.chairID = chairId;
            playerShoot.bulletId = selfPlayer.bulletID;
            playerShoot.temp1 = 0;
            playerShoot.temp2 = 0;
            playerShoot.gunLevel = selfPlayer.gunLevel;
            playerShoot.gunGrade = selfPlayer.gungrade;
            playerShoot.bet = WPBYEntry.Instance.GameData.Config.bulletScore[selfPlayer.gungrade] * (selfPlayer.gunLevel + 1);
            HotfixGameComponent.Instance.Send(DataStruct.GameStruct.MDM_GF_GAME, WPBY_Network.SUB_C_PRESS_SHOOT, playerShoot.ByteBuffer, SocketType.Game);
            if (selfPlayer.isRobot)
            {
                if (selfPlayer.goldNum < (ulong)(WPBYEntry.Instance.GameData.Config.bulletScore[selfPlayer.gungrade] * (selfPlayer.gunLevel + 1)))
                {
                    return;
                }
            }
            WPBY_Struct.CMD_S_PlayerShoot pao = new WPBY_Struct.CMD_S_PlayerShoot();
            pao.wChairID = chairId;
            pao.x = pos.x;
            pao.y = pos.y;
            pao.level = selfPlayer.gunLevel;
            pao.type = selfPlayer.gungrade;
            pao.playCurScore = (long)selfPlayer.goldNum - (long)(WPBYEntry.Instance.GameData.Config.bulletScore[selfPlayer.gungrade] * (selfPlayer.gunLevel + 1));
            ShootBullet(pao);
        }

        public void ShootBullet(WPBY_Struct.CMD_S_PlayerShoot bullet)
        {
            WPBY_Player player = GetPlayer(bullet.wChairID);
            if (player == null) return;
            player.Shoot(bullet);
        }

        public void OnSetPlayerState(int mode, int wChairID)
        {
            WPBY_Player player = GetPlayer(wChairID);
            if (player == null) return;
            bool isJoin = mode == 1;
            player.OnJoinSuperPowrModel(isJoin);
        }

        public void OnLockFish(WPBY_Struct.CMD_S_PlayerLock data)
        {
            WPBY_Fish fish = WPBY_FishController.Instance.GetFish(data.fishId);
            if (fish != null)
            {
                WPBY_Player player = GetPlayer(data.chairId);
                player.LockFish = fish;
                player.IsLock = true;
            }
        }

        public void OnCancalLock(int site_id)
        {
            WPBY_Player player = GetPlayer(site_id);
            if (player != null)
            {
                player.LockFish = null;
                player.IsLock = false;
                ContinuousFireByFish(false, site_id, -1);
            }
        }

        public void ContinuousFireByFish(bool free, int _sitID, int fishId)
        {
            WPBY_Player player = GetPlayer(_sitID);
            if (player == null) return;
            if (free)
            {
                if (player.goldNum < (ulong)(WPBYEntry.Instance.GameData.Config.bulletScore[player.gungrade] * (player.gunLevel + 1)))
                {
                    ToolHelper.PopSmallWindow("金币不足!");
                    return;
                }
                if (fishId < 0) return;
                player.StopContinueFire();
                player.LockFish = WPBY_FishController.Instance.GetFish(fishId);
                if (player.data.ChairId == WPBYEntry.Instance.GameData.ChairID)
                {
                    player.ContinueFire(acceleration, acceleration);
                }
                else
                {
                    player.StopContinueFire();
                    player.ContinueFire(0.3f, 0.3f);
                }
            }
            else
            {
                player.StopContinueFire();
                player.isThumb = false;
            }
        }
        public void ContinuousFireByPos(bool free, int _sitID, Vector3 vector)
        {
            WPBY_Player player = GetPlayer(_sitID);
            if (free)
            {
                if (player.goldNum < (ulong)(WPBYEntry.Instance.GameData.Config.bulletScore[player.gungrade] * (player.gunLevel + 1))) return;

                player.isThumb = true;
                player.ContinueFire(0, acceleration);
            }
            else
            {
                player.StopContinueFire();
                player.isThumb = false;
            }
            player.dir = vector;
            player.RotatePaoTaiByPos(player.dir);
        }
    }
}