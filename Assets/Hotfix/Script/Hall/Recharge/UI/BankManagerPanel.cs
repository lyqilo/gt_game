using System;
using System.Collections.Generic;
using FancyScrollView;
using LitJson;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall.Recharge
{
    public class BankManagerPanelData : PanelData
    {
        public Dictionary<string, RechargeArray> rechargeArrays;
        public BankSaveData saveData;
        public Action<BankBaseSaveData> selectCall;
    }
    public partial class BankManagerPanel : PanelBase
    {
        private Transform list;
        private RectTransform view;
        private ScrollView _scrollView;
        private Scroller _scroller;
        private Button closeBtn;

        private BankManagerPanelData _data;
        private List<Data> datas = new List<Data>();
        public BankManagerPanel() : base(UIType.Middle, nameof(BankManagerPanel))
        {
            
        }

        public override void Create(params object[] args)
        {
            base.Create(args);
            if (args.Length < 1) return;
            if (!(args[0] is BankManagerPanelData data)) return;
            _data = data;
            Show(_data);
        }

        protected override void FindComponent()
        {
            base.FindComponent();
            list = transform.FindChildDepth("List");
            closeBtn = transform.FindChildDepth<Button>("CloseBtn");
            view ??= list.FindChildDepth($"View").GetComponent<RectTransform>();
            _scroller ??= ToolHelper.CreateScroller(list.gameObject, view);
            _scrollView ??= list.gameObject.CreateOrGetComponent<ScrollView>();
            List<Data> datas = new List<Data>();
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


        private void Show(BankManagerPanelData data)
        {
            view ??= list.FindChildDepth($"View").GetComponent<RectTransform>();
            _scroller ??= ToolHelper.CreateScroller(list.gameObject, view);
            _scrollView ??= list.gameObject.CreateOrGetComponent<ScrollView>();
            datas.Clear();
            for (int i = 0; i < data.saveData.datas.Count; i++)
            {
                var d = data.saveData.datas[i];
                if (string.IsNullOrEmpty(d.channelName)) continue;
                RechageData rechageData = _data.rechargeArrays[d.channelName].types
                    .Find(p => p.name.Equals(d.channelName));
                datas.Add(new Data(d, rechageData));
            }

            _scrollView.Init(datas, SelectCall, DeleteCall);
        }

        private void SelectCall(BankBaseSaveData data)
        {
            _data.selectCall?.Invoke(data);
            _scrollView.RefreshData();
        }

        private void DeleteCall(string uid)
        {
            Model.Instance.DeleteSaveBankData(uid);
            int index = datas.FindIndex(p => p.SaveData.uid == uid);
            datas.RemoveAt(index);
            _scrollView.Init(datas, SelectCall, DeleteCall);
        }
    }
}