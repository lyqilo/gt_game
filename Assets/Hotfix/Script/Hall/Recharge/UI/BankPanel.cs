using System;
using System.Collections.Generic;
using System.Linq;
using FancyScrollView;
using LitJson;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall.Recharge
{
    public class BankPanelData : PanelData
    {
        public RechageData data;
        public RechargeArray dataArr;
        public Dictionary<string, RechargeArray> config;
        public Action<bool,RechageData> selectCall;
        public Action<bool, RechargeArray> selectCallArr;
    }
    public partial class BankPanel : PanelBase
    {
        public int Index { get; set; }
        private Transform list;
        private RectTransform view;
        private Scroller _scroller;
        private GridView _scrollView;
        private Button closeBtn;

        private RechageData _currentSelect;
        private RechargeArray _currentSelectArr;
        public Dictionary<string, RechargeArray> _config = new Dictionary<string, RechargeArray>();
        private Action<bool,RechageData> selectCall;
        private Action<bool, RechargeArray> selectCallArr;
        public BankPanel() : base(UIType.Middle, nameof(BankPanel))
        {
            
        }
        public override void Create(params object[] args)
        {
            base.Create(args);
            if (args.Length < 1) return;
            if (!(args[0] is BankPanelData data)) return;
            _config = data.config;
            _currentSelect = data.data;
            _currentSelectArr = data.dataArr;
            selectCall = data.selectCall;
            selectCallArr = data.selectCallArr;
            Show();
        }

        protected override void FindComponent()
        {
            base.FindComponent();
            list = transform.FindChildDepth($"List");
            closeBtn = transform.FindChildDepth<Button>("CloseBtn");
        }

        protected override void AddListener()
        {
            base.AddListener();
            closeBtn.onClick.RemoveAllListeners();
            closeBtn.onClick.Add(OnClickClose);
        }

        private void OnClickClose()
        {
            UIManager.Instance.Close();
        }

        private void Show()
        {
            Debug.LogError("开始表单");
            view ??= list.FindChildDepth($"View").GetComponent<RectTransform>();
            _scroller ??= ToolHelper.CreateScroller(list.gameObject, view);
            _scrollView ??= list.gameObject.CreateOrGetComponent<GridView>();

            List<DataArr> datas = new List<DataArr>();
            List<string> keys = new List<string>(_config.Keys);
            for (int i = 0; i < keys.Count; i++)
            {
                var v = _config[keys[i]];
                //for (int j = 0; j < v.types.Count; j++)
                //{
                //    datas.Add(new DataArr(v.types[j].id, v));
                //}

                datas.Add(new DataArr(v.id, v));
            }

            _scrollView.Init(datas, (isFrist, data) =>
            {
                selectCallArr?.Invoke(isFrist, data);
                _scrollView.RefreshData();
            }, _currentSelectArr);


            //List<RechargeArray> datas = _config.Values.ToList();

            //_scrollView.Init(datas, (isFrist, datas) =>
            //{
            //    //selectCall?.Invoke(isFrist, datas);
            //    _scrollView.RefreshData();
            //});


        }
    }
}