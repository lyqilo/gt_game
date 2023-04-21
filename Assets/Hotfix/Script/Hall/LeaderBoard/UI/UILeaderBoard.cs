using System.Collections.Generic;
using FancyScrollView;
using UnityEngine;
using UnityEngine.U2D;
using UnityEngine.UI;

namespace Hotfix.Hall.LeaderBoard
{
    public partial class UILeaderBoard : PanelBase
    {
        private Scroller _titleScroller;
        private Scroller _rankScroller;
        private TitleScrollView _titleScroll;
        private RankScrollView _rankScroll;

        private Button closeBtn;

        private Transform leftGroup;
        private Transform rightGroup;
        private Transform titleList;
        private Transform rankList;

        private GameObject titleItemTemp;
        private GameObject rankItemTemp;
        private Transform fixGroup;

        private Image title;
        
        private UILeaderBoardItem rankItem;
        private SpriteAtlas _atlas;
        public UILeaderBoard() : base(UIType.Middle, nameof(UILeaderBoard))
        {
        }

        public override void Create(params object[] args)
        {
            base.Create(args);
            _atlas ??= ToolHelper.LoadAsset<SpriteAtlas>(SceneType.Hall, "Hall_LeaderBoard");
           _titleScroller= CreateScroller(titleList.gameObject,titleList.FindChildDepth("Viewport").GetComponent<RectTransform>(),_titleScroller);
            _titleScroll ??= titleList.gameObject.CreateOrGetComponent<TitleScrollView>();
            List<TitleData> items = new List<TitleData>();
            var group = Model.Instance.Titles;
            for (int i = 0; i < group.Count; i++)
            {
                items.Add(new TitleData(group[i]));
            }

            _titleScroll.Init(items, OnSelectTitle);
            title.sprite = _atlas.GetSprite("paihangbang_title_01");
        }

        protected override void FindComponent()
        {
            base.FindComponent();
            closeBtn = transform.FindChildDepth<Button>($"CloseBtn");
            leftGroup = transform.FindChildDepth($"Left");
            rightGroup = transform.FindChildDepth($"Right");

            titleList = leftGroup.FindChildDepth($"TitleList");
            titleItemTemp = leftGroup.FindChildDepth($"TitleItem").gameObject;
            rankList = rightGroup.FindChildDepth($"RankList");
            rankItemTemp = rightGroup.FindChildDepth($"UIRankItem").gameObject;
            fixGroup = rightGroup.FindChildDepth($"Fix");
            title = transform.FindChildDepth<Image>("Root/Title");
            
        }

        protected override void AddListener()
        {
            base.AddListener();
            closeBtn.onClick.RemoveAllListeners();
            closeBtn.onClick.Add(OnClickClose);
        }

        protected override void AddEvent()
        {
            base.AddEvent();
            Model.Instance.OnLeaderBoardMessage = OnLeaderBoardMessage;
        }

        protected override void RemoveEvent()
        {
            base.RemoveEvent();
            Model.Instance.OnLeaderBoardMessage = null;
        }


        private void OnSelectTitle(byte type)
        {
            _titleScroll.RefreshData();
            ToolHelper.ShowWaitPanel(true,"wait…");
            Model.Instance.ReqLeaderBoardList(type);
            
        }

        private void InitRank(List<HallStruct.LeaderBoard.sRankItem> list)
        {
            if (list == null || list.Count <= 0)
            {
                rankList.gameObject.SetActive(false);
                return;
            }

            GameObject o;
            (o = rankList.gameObject).SetActive(true);
            _rankScroller = CreateScroller(o, rankList.FindChildDepth("Viewport").GetComponent<RectTransform>(),
                _rankScroller);
            _rankScroll ??= rankList.gameObject.CreateOrGetComponent<RankScrollView>();
            List<RankCellData> datas = new List<RankCellData>();

            for (int i = 0; i < list.Count - 1; i++)
            {
                var rankInfo = list[i];
                datas.Add(new RankCellData(rankInfo, i + 1));
            }

            _rankScroll.Init(datas);
        }

        private void OnLeaderBoardMessage(HallStruct.LeaderBoard.sRankInfo msg)
        {
            ToolHelper.ShowWaitPanel(false);
            var info = Model.Instance.GetRankInfo(msg.nType);
            rankList.gameObject.SetActive(info != null);
            if (info == null)
            {
                DebugHelper.LogError($"{msg.nType} 没有排行数据");
                return;
            }

            List<HallStruct.LeaderBoard.sRankItem> list = new List<HallStruct.LeaderBoard.sRankItem>();
            list.AddRange(info.Item2.RankInfo);
            list.RemoveAt(list.Count - 1);
            InitRank(list);
            if (rankItem == null)
            {
                var go = Object.Instantiate(rankItemTemp, fixGroup, false);
                go.transform.localPosition = Vector3.zero;
                go.SetActive(true);
                rankItem = go.CreateOrGetComponent<UILeaderBoardItem>();
            }

            var self = info.Item2.RankInfo[info.Item2.RankInfo.Count - 1];
            int rank = list.FindIndex(p => p.nUserID == self.nUserID);
            rankItem.Initialize();
            rankItem.SetFixBack(true);
            rankItem.UpdateContent(new RankCellData(self, rank >= 0 ? rank + 1 : rank));
        }


        private Scroller CreateScroller(GameObject scrollerObj, RectTransform viewport, Scroller scroller)
        {
            scroller ??= scrollerObj.CreateOrGetComponent<Scroller>();
            scroller.Viewport ??= viewport;
            scroller.SnapEnabled = false;
            scroller.Draggable = true;
            scroller.MovementType = MovementType.Clamped;
            scroller.ScrollDirection = ScrollDirection.Vertical;
            return scroller;
        }

        private void OnClickClose()
        {
            UIManager.Instance.Close();
        }
    }
}