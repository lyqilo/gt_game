using System;
using System.Collections.Generic;
using FancyScrollView;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall.Recharge
{
    public class FristRechargeBankPanelPanelData
    {
        public List<RechargeArray> rechargeArrays;
        public Action<bool,RechageData> selectCallArr;
    }
    public partial class FristRechargeBankPanel : PanelBase
    {
        public FristRechargeBankPanel() : base(UIType.Middle, nameof(FristRechargeBankPanel))
        {
            
        }
        public static FristRechargeBankPanel Open(FristRechargeBankPanelPanelData data)
        {
            return UIManager.Instance.OpenUI<FristRechargeBankPanel>(data);
        }

        
        private Transform _channelGroup;
        private Transform _channelSubGroup;
        private RectTransform _channelView;
        private RectTransform _subChannelView;
        private Scroller _channelScroller;
        private Scroller _channelSubScroller;
        private ChannelScrollView _channelScroll;
        private SubChannelGridView _channelSubScroll;
        Dictionary<int, RechargeArray> rechargeConfig = new Dictionary<int, RechargeArray>();
        private FristRechargeBankPanelPanelData _data;
        private Button closeBtn;
        public override void Create(params object[] args)
        {
            base.Create(args);
            if (args.Length <= 0 || !(args[0] is FristRechargeBankPanelPanelData data)) return;
            _data = data;
            var jsonData = data.rechargeArrays;
            rechargeConfig.Clear();
            for (int i = 0; i < jsonData.Count; i++)
            {
                var rechargedata = jsonData[i];
                rechargeConfig[rechargedata.id] = rechargedata;
            }
            _channelScroller ??= ToolHelper.CreateScroller(_channelGroup.gameObject, _channelView,
                direction: ScrollDirection.Horizontal);
            _channelScroll ??= _channelGroup.gameObject.CreateOrGetComponent<ChannelScrollView>();

            List<ChannelData> datas = new List<ChannelData>();
            List<int> keys = new List<int>(rechargeConfig.Keys);
            for (int i = 0; i < keys.Count; i++)
            {
                datas.Add(new ChannelData(keys[i], rechargeConfig[keys[i]]));
            }

            _channelScroll.Init(datas, OnClickChannel);
        }

        protected override void FindComponent()
        {
            base.FindComponent();
            _channelGroup = transform.FindChildDepth($"Content/ChannelGroup");
            _channelSubGroup = transform.FindChildDepth($"Content/Group");
            _channelView = _channelGroup.FindChildDepth<RectTransform>("View");
            _subChannelView = _channelSubGroup.FindChildDepth<RectTransform>("View");
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

        private void OnClickChannel(int channelID)
        {
            _channelSubScroller ??= ToolHelper.CreateScroller(_channelSubGroup.gameObject, _subChannelView);
            _channelSubScroll ??= _channelSubGroup.gameObject.CreateOrGetComponent<SubChannelGridView>();

            List<SubChannelData> datas = new List<SubChannelData>();
            var config = rechargeConfig[channelID];
            for (int i = 0; i < config.types.Count; i++)
            {
                var data = config.types[i];
                datas.Add(new SubChannelData(data.id, data));
            }

            _channelSubScroll.Init(datas, OnClickSubChannel);
        }
        
        private void OnClickSubChannel(bool isSelect,RechageData data)
        {
            DebugHelper.LogError($"{data.name}");
            UIManager.Instance.Close();
            _data?.selectCallArr?.Invoke(isSelect, data);
        }
    }
}