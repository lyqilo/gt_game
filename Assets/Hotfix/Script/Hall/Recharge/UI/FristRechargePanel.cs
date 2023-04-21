using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using FancyScrollView;
using LitJson;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall.Recharge
{
    public class FristRechargePanel : PanelBase
    {
        public FristRechargePanel() : base(UIType.Middle, nameof(FristRechargePanel))
        {
        }

        private Button buyBtn;
        private TextMeshProUGUI buyNum;

        private TextMeshProUGUI getNum;
        private TextMeshProUGUI addNum;
        private bool hasConfig;
        Dictionary<int, RechargeArray> rechargeConfig = new Dictionary<int, RechargeArray>();
        private List<RechageData> _rechageDatas = new List<RechageData>();
        private List<RechargeArray> _rechageDataArrs = new List<RechargeArray>();
        private RechageData currentRechargeData = default;
        private RechargeArray currentRechargeDataArr = default;
        private GameObject fristRechargeBtn = null;

        private Button closeBtn;
        private FristRechargeData _fristRechargeData;

        protected override void FindComponent()
        {
            base.FindComponent();
            buyBtn = transform.FindChildDepth<Button>("BuyBtn");
            buyNum = transform.FindChildDepth<TextMeshProUGUI>("BuyBtn/Price");
            getNum = transform.FindChildDepth<TextMeshProUGUI>("GetNum");
            addNum = transform.FindChildDepth<TextMeshProUGUI>("AddNum");
            closeBtn = transform.FindChildDepth<Button>("CloseBtn");
        }

        protected override void AddListener()
        {
            base.AddListener();
            buyBtn.onClick.RemoveAllListeners();
            buyBtn.onClick.Add(OnClickBuyCall);
            closeBtn.onClick.RemoveAllListeners();
            closeBtn.onClick.Add(OnClickCall);
        }

        private void OnClickCall()
        {
            UIManager.Instance.Close();
        }


        public override void Create(params object[] args)
        {
            base.Create(args);
            if (args.Length >= 1 && args[0] is GameObject rechargeObj)
            {
                fristRechargeBtn = rechargeObj;
            }

            rechargeConfig.Clear();
            _rechageDatas.Clear();
            _rechageDataArrs.Clear();
            FormData formData = new FormData();
            currentRechargeData.id = -1;
            getNum.transform.parent.gameObject.SetActive(false);
            addNum.transform.parent.gameObject.SetActive(false);
            buyNum.transform.parent.gameObject.SetActive(false);
            ToolHelper.ShowWaitPanel();
            Model.Instance.ReqFristRechargeConfig( async (t1, result) =>
            {
                ToolHelper.ShowWaitPanel(false);
                if (!t1)
                {
                    ToolHelper.PopSmallWindow("Order generation failed, please try again later");
                    return;
                }

                DebugHelper.Log($"result:{result}");

                CallBackData callBackData = JsonMapper.ToObject<CallBackData>(result);

                if (callBackData.code != 0)
                {
                    ToolHelper.PopSmallWindow("Order generation failed, please try again later");
                    return;
                }

                _fristRechargeData = callBackData.data;
                // var json = JsonMapper.ToObject(result);
                // if (!int.TryParse(json["code"].ToString(), out int code) || code != 0)
                // {
                //     ToolHelper.PopSmallWindow("Order generation failed, please try again later");
                //     return;
                // }
                // _fristRechargeData = JsonMapper.ToObject<FristRechargeData>(json["data"].ToJson());

                getNum.transform.parent.gameObject.SetActive(true);
                addNum.transform.parent.gameObject.SetActive(true);
                buyNum.transform.parent.gameObject.SetActive(true);

                getNum.SetText(callBackData.data.gold.ShortNumber().ShowRichText());
                addNum.SetText(callBackData.data.give_gold.ShortNumber().ShowRichText());
                buyNum.SetText($"{callBackData.data.amount}PHP");
            });
            formData.AddField("type", "0");
            formData.AddField("UserId", $"{GameLocalMode.Instance.SCPlayerInfo.DwUser_Id}");
            Model.Instance.ReqConfigData(formData, (isSuccess, result) =>
            {
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

        private void OnGetRechargeConfig(JsonData result)
        {
            var jsonData = JsonMapper.ToObject<List<RechargeArray>>(result["data"].ToJson());
            for (int i = 0; i < jsonData.Count; i++)
            {
                var rechargedata = jsonData[i];
                rechargeConfig[rechargedata.id] = rechargedata;
                for (int j = 0; j < rechargedata.types.Count; j++)
                {
                    _rechageDatas.Add(rechargedata.types[j]);
                }
            }
        }

        private void OnClickBuyCall()
        {
            if (rechargeConfig.Count <= 0 || _rechageDatas.Count <= 0)
            {
                ToolHelper.PopSmallWindow("Order generation failed, please try again later");
                return;
            }

            Debug.LogError("点击充值");
            if (_rechageDatas.Count != 1)
            {
                if (!_isSelectChannel)
                {
                    UIManager.Instance.OpenUI<FristRechargeBankPanel>(new FristRechargeBankPanelPanelData()
                    {
                        rechargeArrays = new List<RechargeArray>(rechargeConfig.Values),
                        selectCallArr = OnSelectChannel,
                    });
                    return;
                }
            }
            else
            {
                //只有一个渠道，直接发起充值订单
                currentRechargeData = _rechageDatas[0];
            }

            FormData postdata = new FormData();
            postdata.AddField("recharge.userId", $"{GameLocalMode.Instance.SCPlayerInfo.DwUser_Id}");
            postdata.AddField("recharge.topUpAmount", $"{_fristRechargeData.amount}");
            postdata.AddField("recharge.pid", $"{currentRechargeData.pid}");
            postdata.AddField("recharge.id", $"{currentRechargeData.id}");
            postdata.AddField("recharge.isFirstCharge", $"1");
            
            Model.Instance.ReqRechargeData(postdata, (isSuccess, result) =>
            {
                ToolHelper.ShowWaitPanel(false);
                if (!isSuccess) return;
                if (fristRechargeBtn != null) fristRechargeBtn.SetActive(false);
                GameLocalMode.Instance.SCPlayerInfo.IsFirstRecharge = 1;
                DebugHelper.Log($"result:{result}");
                var json = JsonMapper.ToObject(result);
                if (json["code"].ToString() != "0") return;
                Application.OpenURL(json["data"]["urlPay"].ToString());
            });
            UIManager.Instance.Close();
        }

        private bool _isSelectChannel = false;
        private void OnSelectChannel(bool isSelect,RechageData obj)
        {
            currentRechargeData = obj;
            if (!isSelect) return;
            _isSelectChannel = true;
            OnClickBuyCall();
        }

        private void OnSelectChannel(bool isFrist, RechargeArray obj)
        {
            currentRechargeDataArr = obj;
            if (isFrist) return;
            OnClickBuyCall();
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            HotfixMessageHelper.PostHotfixEvent(PopTaskSystem.Model.CompleteShowPop, Model.Instance.PopName);
        }
    }
}