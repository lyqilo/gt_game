using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using FancyScrollView;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall.ItemBox
{
    public partial class UIItemBox : PanelBase
    {
        public class PopData
        {
            public List<int> itemIds;
            public List<long> itemCounts;
            public CAction closeCall;
        }

        public UIItemBox() : base(UIType.Top, nameof(UIItemBox))
        {
        }

        public static UIItemBox Open(List<int> itemIds, List<int> itemCounts, CAction onCloseCall = null)
        {
            var ui = UIManager.Instance.GetUI<UIItemBox>();
            ui ??= UIManager.Instance.OpenUI<UIItemBox>();
            ui.Pop(itemIds, itemCounts, onCloseCall);
            return ui;
        }

        public static UIItemBox Open(int itemId, int itemCount, CAction onCloseCall = null)
        {
            var ui = Open(new List<int>() {itemId}, new List<long>() {itemCount}, onCloseCall);
            return ui;
        }

        public static UIItemBox Open(int itemId, long itemCount, CAction onCloseCall = null)
        {
            var ui = Open(new List<int>() {itemId}, new List<long>() {itemCount}, onCloseCall);
            return ui;
        }
        public static UIItemBox Open(List<int> itemIds, List<long> itemCounts, CAction onCloseCall = null)
        {
            var ui = UIManager.Instance.GetUI<UIItemBox>();
            ui ??= UIManager.Instance.OpenUI<UIItemBox>();
            ui.Pop(itemIds, itemCounts, onCloseCall);
            return ui;
        }

        private Queue<PopData> _queue = new Queue<PopData>();
        private bool isPoped;

        private Transform root;
        private Transform listObj;
        private Scroller _scroller;
        private ScrollView _scrollView;
        private Button maskBtn;
        private Animator _anim;
        private HorizontalLayoutGroup _layoutGroup;

        protected override void FindComponent()
        {
            base.FindComponent();
            root = transform.FindChildDepth("Content");
            listObj = root.transform.FindChildDepth($"Group/ItemGroup");
            maskBtn = transform.FindChildDepth<Button>($"Mask");
            _layoutGroup = listObj.FindChildDepth<HorizontalLayoutGroup>("Content");
        }

        protected override void AddListener()
        {
            base.AddListener();
            maskBtn.onClick.RemoveAllListeners();
            maskBtn.onClick.Add(OnClickClose);
        }

        private void OnClickClose()
        {
            if (_queue.Count <= 0)
            {
                UIManager.Instance.Close();
                return;
            }

            Behaviour.StartCoroutine(StartNextPop());
        }

        IEnumerator StartNextPop()
        {
            _anim.Play("Close", 0, 0f);
            yield return new WaitForSeconds(0.15f);
            _anim.Play("Open", 0, 0f);
            StartPop(_queue.Dequeue());
        }

        private void Pop(List<int> itemIds, List<int> itemCounts, CAction onCloseCall)
        {
            List<long> counts = new List<long>();
            for (int i = 0; i < itemCounts.Count; i++)
            {
                counts.Add(itemCounts[i]);
            }

            Pop(itemIds, counts, onCloseCall);
        }

        private void Pop(List<int> itemIds, List<long> itemCounts, CAction onCloseCall)
        {
            var pop = new PopData() {itemIds = itemIds, itemCounts = itemCounts, closeCall = onCloseCall};
            if (isPoped)
            {
                _queue.Enqueue(pop);
                return;
            }

            StartPop(pop);
        }

        private void StartPop(PopData pop)
        {
            CreateScroller(listObj.FindChildDepth("View").GetComponent<RectTransform>());
            _scrollView ??= listObj.gameObject.CreateOrGetComponent<ScrollView>();
            List<Data> datas = new List<Data>();
            for (int i = 0; i < pop.itemIds.Count; i++)
            {
                datas.Add(new Data(pop.itemIds[i], pop.itemCounts[i]));
            }

            _layoutGroup.enabled = datas.Count < 3;
            _layoutGroup.padding = new RectOffset(0,0,20,20);
            _layoutGroup.spacing = 10;
            _scrollView.Init(datas);
        }

        private void CreateScroller(RectTransform viewport)
        {
            _scroller ??= listObj.gameObject.CreateOrGetComponent<Scroller>();
            _scroller.Viewport ??= viewport;
            _scroller.SnapEnabled = false;
            _scroller.Draggable = true;
            _scroller.MovementType = MovementType.Clamped;
            _scroller.ScrollDirection = ScrollDirection.Horizontal;
        }
    }
}


namespace Hotfix
{
    public enum ItemType
    {
        Coin = 1,
        SpinCount = 2,
    }
}