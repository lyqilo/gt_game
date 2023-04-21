using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.UI;
using FancyScrollView;
using TMPro;
using YooAsset;

namespace Hotfix.Hall
{
    public partial class HallIconItem : FancyScrollRectCell<HallGameShow.GameItemData, HallGameShow.GameItemContext>
    {
        private bool _isHide;
        private HallGameShow.GameItemData _data;

        private Transform _iconGroup;
        private Transform hideMask;
        private Button enterGameBtn;
        private Transform iconNode;
        private bool isInit;
        private Dictionary<string, GameObject> games = new Dictionary<string, GameObject>();

        private Transform _downGroup;
        private TextMeshProUGUI _downProgress;
        private GameDownStatus _status;
        private GameObject _needdown;

        public override void Initialize()
        {
            base.Initialize();
            FindComponent();
            AddListener();
            Context?.OnCellClicked?.Invoke(Index);
        }

        private void OnEnable()
        {
            HotfixMessageHelper.AddEvent(CustomEvent.DownStatus, OnDownStatusChanged);
            HotfixMessageHelper.AddEvent(CustomEvent.DownEvent, OnDownProgressChanged);
        }

        private void OnDisable()
        {
            HotfixMessageHelper.RemoveEvent(CustomEvent.DownStatus, OnDownStatusChanged);
            HotfixMessageHelper.RemoveEvent(CustomEvent.DownEvent, OnDownProgressChanged);
        }
        public override void UpdateContent(HallGameShow.GameItemData itemData)
        {
            _data = itemData;
            CheckGameStatus();
            SetItem(_data.IsHide);
        }

        private void CheckGameStatus()
        {
            _status = ILGameManager.Instance.GetGameStatus(_data.GameId);
            _downGroup.gameObject.SetActive(_status != GameDownStatus.Downed);
            _downProgress.gameObject.SetActive(_status == GameDownStatus.Downing);
            _needdown.SetActive(_status == GameDownStatus.None);
        }

        private void FindComponent()
        {
            if (isInit) return;
            hideMask = transform.FindChildDepth($"open");
            iconNode = transform.FindChildDepth($"ICO");
            _downGroup = transform.transform.FindChildDepth($"DownGroup");
            _downProgress = _downGroup.FindChildDepth<TextMeshProUGUI>($"Progress");
            _needdown = _downGroup.FindChildDepth($"NeedDown").gameObject;
            _downGroup.gameObject.SetActive(false);
            enterGameBtn = iconNode.GetComponent<Button>();
            isInit = true;
        }

        private void AddListener()
        {
            enterGameBtn.onClick.RemoveAllListeners();
            enterGameBtn.onClick.Add(OnClickEnterGameCall);
        }

        private void OnDownStatusChanged(object[] data)
        {
            if (data.Length < 2) return;
            if (!(data[0] is int gameId) || !(data[1] is GameDownStatus status)) return;
            if (_data == null) return;
            if (_data.GameId != gameId) return;
            _status = status;
            _downGroup.gameObject.SetActive(status == GameDownStatus.None || status == GameDownStatus.Downing);
            _needdown.SetActive(status == GameDownStatus.None);
            _downProgress.gameObject.SetActive(status == GameDownStatus.Downing);
        }

        private void OnDownProgressChanged(object[] data)
        {
            if (data.Length < 2) return;
            if (!(data[0] is int gameId) || !(data[1] is double progress)) return;
            if (_data == null) return;
            if (_data.GameId != gameId) return;
            _downProgress.SetText($"{progress:P0}");
        }

        private void OnClickEnterGameCall()
        {
            DebugHelper.LogError($"点击{_data.GameId}");
            if (_data.GameId >= 255)
            {
                ToolHelper.PopSmallWindow($"no open!");
                return;
            }

            if (GameLocalMode.Instance.SCPlayerInfo.IsVIP == 1)
            {
                ToolHelper.PopSmallWindow($"VIP Cannot enter game!");
                return;
            }

            GameData data = GameConfig.GetGameData(_data.GameId);
            if (data == null)
            {
                ToolHelper.PopSmallWindow($"find game config failed！");
                return;
            }

            var list = GameLocalMode.Instance.AllSCGameRoom.FindAllItem(p => p._2wGameID == data.clientId);
            if (list == null || list.Count <= 0)
            {
                list = GameLocalMode.Instance.AllSCGameRoom.FindAllItem(p => p._2wGameID == data.otherClientId);
                if (list == null || list.Count <= 0)
                {
                    ToolHelper.PopSmallWindow($"Game not open yet");
                    return;
                }
            }

            switch (_status)
            {
                case GameDownStatus.None:
                    ILGameManager.Instance.CreateDownLoader(_data.GameId);
                    return;
                case GameDownStatus.Downing:
                    ILGameManager.Instance.StopDownload(_data.GameId);
                    return;
                case GameDownStatus.Downed:
                    break;
            }

            HallEvent.DispatchEnterGamePre(true);
            UIManager.Instance.OpenUI<GameRoomListPanel>(_data.GameId, list);
        }

        private void SetItem(bool isHide)
        {
            foreach (var o in games)
            {
                o.Value.SetActive(false);
            }

            this._isHide = isHide;
            _iconGroup ??= ToolHelper.LoadAsset<GameObject>(SceneType.Hall, "GameImg")?.transform;
            hideMask.gameObject.SetActive(this._isHide);
            GameData data = GameConfig.GetGameData(_data.GameId);
            if (data == null)
            {
                DebugHelper.LogError($"未找到{_data.GameId} 配置");
                return;
            }
            
            gameObject.name = data.scenName;
            if (games.ContainsKey(data.scenName))
            {
                games[data.scenName].SetActive(true);
                return;
            }

            Transform obj = _iconGroup.FindChildDepth(data.scenName);
            if (obj == null)
            {
                DebugHelper.LogError($"未找到 {data.scenName} icon");
                return;
            }

            GameObject go = Instantiate(obj.gameObject, iconNode, false);
            go.transform.localPosition = Vector3.zero;
            go.transform.localScale = Vector3.one;
            go.transform.localRotation = Quaternion.identity;
            games.Add(data.scenName, go);
        }
    }
}