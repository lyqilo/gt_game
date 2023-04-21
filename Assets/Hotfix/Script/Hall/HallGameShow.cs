using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using FancyScrollView;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall
{
    public partial class HallGameShow : MonoBehaviour
    {
        private GameObject h_Prefab;
        private GameObject s_Prefab;
        private ScrollRect _showRect;
        private float _waitTimer = 0;
        private bool _isDrag;
        private bool _isUseAutoScroll = true;
        private bool _isUp;
        private int _rate = 1;

        private Transform otherContent;

        private GameItemScrollView _gameScrollView;
        private MenuItemScrollView _menuScrollView;
        private Transform togGroup;

        public List<int> noShowList = new List<int>();
        private Dictionary<string, List<int>> gameDic = new Dictionary<string, List<int>>();
        private Scroller _scroller;
        private Scroller _menuScroller;

        private void Awake()
        {
            otherContent = transform.FindChildDepth("GameList");
            togGroup = transform.FindChildDepth("Menu/Scroll View");
            h_Prefab = transform.FindChildDepth("prefeb_H").gameObject;
            s_Prefab = transform.FindChildDepth("prefeb_S").gameObject;
        }

        private void OnEnable()
        {
            InitGame();
        }

        private void InitGame()
        {
            gameDic = GameLocalMode.Instance.GameDic;
            noShowList = GameLocalMode.Instance.NoShowList;
            if (gameDic.Count <= 0) togGroup.gameObject.SetActive(false);
            else
            {
                togGroup.gameObject.SetActive(true);
                CreateMenuScroller(togGroup.FindChildDepth("Viewport").GetComponent<RectTransform>());
                _menuScrollView ??= togGroup.gameObject.CreateOrGetComponent<MenuItemScrollView>();
                List<MenuItemData> items = new List<MenuItemData>();
                List<string> group = new List<string>(gameDic.Keys);
                for (int i = 0; i < group.Count; i++)
                {
                    items.Add(new MenuItemData(group[i], gameDic[group[i]]));
                }

                _menuScrollView.Init(items, OnSelectTag);
            }
        }

        private void OnSelectTag(string tagName)
        {
            if (!gameDic.TryGetValue(tagName, out var list))
            {
                DebugHelper.LogError($"{tagName} 没有游戏列表");
                return;
            }
            _menuScrollView.RefreshData();
            Init(list);
        }

        private void Init(List<int> gameList)
        {
            if (gameList == null || gameList.Count <= 0)
            {
                otherContent.gameObject.SetActive(false);
                return;
            }

            otherContent.gameObject.SetActive(true);
            CreateScroller(otherContent.FindChildDepth("View").GetComponent<RectTransform>());
            _gameScrollView ??= otherContent.gameObject.CreateOrGetComponent<GameItemScrollView>();
            List<GameItemData> items = new List<GameItemData>();
            for (int i = 0; i < gameList.Count; i++)
            {
                if(GameLocalMode.Instance.SCPlayerInfo.nIsDrain==1||gameList[i]==22||gameList[i]==49||gameList[i]==32||gameList[i]==54){
                    var config = GameConfig.GetGameData(gameList[i]);
                    if (config == null) continue;
                    items.Add(new GameItemData(config.clientId, noShowList.Contains(config.clientId)));
                }
            }

            _gameScrollView.Init(items, h_Prefab);
        }

        private void CreateScroller(RectTransform viewport)
        {
            _scroller ??= otherContent.gameObject.CreateOrGetComponent<Scroller>();
            _scroller.Viewport ??= viewport;
            _scroller.SnapEnabled = false;
            _scroller.Draggable = true;
            _scroller.MovementType = MovementType.Elastic;
            _scroller.ScrollDirection = ScrollDirection.Horizontal;
        }
        
        private void CreateMenuScroller(RectTransform viewport)
        {
            _menuScroller ??= togGroup.gameObject.CreateOrGetComponent<Scroller>();
            _menuScroller.Viewport ??= viewport;
            _menuScroller.SnapEnabled = false;
            _menuScroller.Draggable = true;
            _menuScroller.MovementType = MovementType.Elastic;
            _menuScroller.ScrollDirection = ScrollDirection.Vertical;
        }
    }

    public enum Alignment
    {
        Upper,
        Middle,
        Lower,
    }
}