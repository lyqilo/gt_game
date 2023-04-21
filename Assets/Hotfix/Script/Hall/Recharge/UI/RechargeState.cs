using System;
using System.Collections.Generic;
using System.Text;
using FancyScrollView;
using Hotfix.Hall;
using LitJson;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall.Recharge
{
    public partial class RechargeState : MonoBehaviour, IModuleDetail
    {
        public int Index { get; set; }
        private bool hasConfig;
        private TMP_InputField _mygoldNum;
        private TextMeshProUGUI _exchangeRate;
        private TMP_InputField _amount;
        private TMP_InputField _addPre;
        private TMP_InputField _addAfter;
        private TextMeshProUGUI _handingFee;

        private Transform _channelGroup;
        private Transform _channelSubGroup;

        private Button _rechargeBtn;

        private RectTransform _channelView;
        private RectTransform _subChannelView;
        private Scroller _channelScroller;
        private Scroller _channelSubScroller;
        private ChannelScrollView _channelScroll;
        private SubChannelGridView _channelSubScroll;

        private RechageData currentRechargeData;

        Dictionary<int, RechargeArray> rechargeConfig = new Dictionary<int, RechargeArray>();

        private void Awake()
        {
            _mygoldNum = transform.FindChildDepth<TMP_InputField>($"MyGold/Num");
            _exchangeRate = transform.FindChildDepth<TextMeshProUGUI>($"MyGold/ExchangeRate");
            _amount = transform.FindChildDepth<TMP_InputField>($"Step1/Amount");
            _addPre = transform.FindChildDepth<TMP_InputField>($"Step1/AddPre");
            _addAfter = transform.FindChildDepth<TMP_InputField>($"Step1/AddAfter");

            _channelGroup = transform.FindChildDepth($"Step2/ChannelGroup");
            _channelSubGroup = transform.FindChildDepth($"Step2/Group");
            _handingFee = transform.FindChildDepth<TextMeshProUGUI>($"HandlingFee");
            _rechargeBtn = transform.FindChildDepth<Button>($"RechargeBtn");

            _channelView = _channelGroup.FindChildDepth<RectTransform>("View");
            _subChannelView = _channelSubGroup.FindChildDepth<RectTransform>("View");

            _rechargeBtn.onClick.RemoveAllListeners();
            _rechargeBtn.onClick.Add(OnClickRecharge);

            _amount.onEndEdit.RemoveAllListeners();
            _amount.onEndEdit.Add(OnEditAmount);

            HallEvent.ChangeGoldTicket += HallEventOnChangeGoldTicket;
        }

        private void OnDestroy()
        {
            HallEvent.ChangeGoldTicket -= HallEventOnChangeGoldTicket;
        }

        private void HallEventOnChangeGoldTicket()
        {
            _mygoldNum.SetTextWithoutNotify($"{GameLocalMode.Instance.GetProp(Prop_Id.E_PROP_GOLD).ShortNumber()}");
        }

        public void Show()
        {
            hasConfig = false;
            gameObject.SetActive(true);
            _addPre.SetTextWithoutNotify("");
            _addAfter.SetTextWithoutNotify("");
            _amount.SetTextWithoutNotify("");
            _exchangeRate.SetText($"");
            _mygoldNum.SetTextWithoutNotify($"{GameLocalMode.Instance.GetProp(Prop_Id.E_PROP_GOLD).ShortNumber()}");
            ToolHelper.ShowWaitPanel();
            FormData formData = new FormData();
            formData.AddField("type", "0");
            formData.AddField("UserId", $"{GameLocalMode.Instance.SCPlayerInfo.DwUser_Id}");
            Model.Instance.ReqConfigData(formData, (isSuccess, result) =>
            {
                ToolHelper.ShowWaitPanel(false);
                hasConfig = isSuccess;
                if (!isSuccess)
                {
                    ToolHelper.PopSmallWindow("Order generation failed, please try again later");
                    return;
                }

                DebugHelper.Log($"result:{result}");
                var json = JsonMapper.ToObject(result);
                if (!int.TryParse(json["code"].ToString(), out int code) || code != 0)
                {
                    hasConfig = false;
                    ToolHelper.PopSmallWindow("Order generation failed, please try again later");
                    return;
                }

                OnGetRechargeConfig(json);
            }, 0);
        }

        public void Hide()
        {
            gameObject.SetActive(false);
        }

        /// <summary>
        /// 成功获取充值配置后
        /// </summary>
        /// <param name="result"></param>
        private void OnGetRechargeConfig(JsonData result)
        {
            var jsonData = JsonMapper.ToObject<List<RechargeArray>>(result["data"].ToJson());
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

            _exchangeRate.SetText($"1{currentRechargeData.unit}={currentRechargeData.goldProportion.ShortNumber()}");
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

        private void OnClickSubChannel(RechageData data)
        {
            currentRechargeData = data;
            _handingFee.SetText($"{(data.channelTaxRate > 0 ? $"{data.channelTaxRate}" : "")}");
            _exchangeRate.SetText($"1{currentRechargeData.unit}={currentRechargeData.goldProportion.ShortNumber()}");
            _addPre.SetTextWithoutNotify("");
            _addAfter.SetTextWithoutNotify("");
            _amount.SetTextWithoutNotify("");
            _amount.placeholder.GetComponent<TextMeshProUGUI>()
                .SetText($"{data.min}{data.unit}-{data.max}{data.unit}");
        }

        private void OnClickRecharge()
        {
            if (!hasConfig)
            {
                ToolHelper.PopBigWindow(new BigMessage() {content = "server is not work"});
                return;
            }

            if (string.IsNullOrEmpty(_amount.text))
            {
                ToolHelper.PopBigWindow(new BigMessage()
                    {content = "The amount of the charge is wrong, please re-enter"});
                return;
            }

            int.TryParse(_amount.text, out var gold);
            if (gold < currentRechargeData.min || gold > currentRechargeData.max)
            {
                ToolHelper.PopBigWindow(new BigMessage()
                    {content = "The amount of the charge is wrong, please re-enter"});
                return;
            }

            ToolHelper.ShowWaitPanel();
            FormData postdata = new FormData();
            postdata.AddField("recharge.userId", $"{GameLocalMode.Instance.SCPlayerInfo.DwUser_Id}");
            postdata.AddField("recharge.topUpAmount", $"{_amount.text}");
            postdata.AddField("recharge.pid", $"{currentRechargeData.pid}");
            postdata.AddField("recharge.id", $"{currentRechargeData.id}");
            postdata.AddField("recharge.isFirstCharge", $"0");

            Model.Instance.ReqRechargeData(postdata, (isSuccess, result) =>
            {
                ToolHelper.ShowWaitPanel(false);
                if (!isSuccess) return;
                DebugHelper.Log($"result:{result}");
                var json = JsonMapper.ToObject(result);
                Application.OpenURL(json["data"]["urlPay"].ToString());
            });
        }


        private void OnEditAmount(string count)
        {
            int.TryParse(count, out var c);
            if (c < currentRechargeData.min || c > currentRechargeData.max)
            {
                _amount.SetTextWithoutNotify("");
                ToolHelper.PopBigWindow(new BigMessage()
                    {content = "The amount of the charge is wrong, please re-enter"});
                return;
            }

            _addPre.SetTextWithoutNotify(
                $"{(c * currentRechargeData.goldProportion).ShortNumber()}+{(c * currentRechargeData.goldProportion * currentRechargeData.give).ShortNumber()}");
            _addAfter.SetTextWithoutNotify(
                $"{(c * currentRechargeData.goldProportion * (1 + currentRechargeData.give)).ShortNumber()}");
        }
    }
}