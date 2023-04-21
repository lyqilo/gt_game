using System;
using System.Collections.Generic;
using LitJson;
using LuaFramework;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall.Recharge
{
    public partial class WithdrawalState : MonoBehaviour, IModuleDetail
    {
        private TextMeshProUGUI _exchangeRate;
        private TMP_InputField _mygoldNum;
        private TMP_InputField _myWithdrawable;
        private TMP_InputField _amount;
        private TMP_InputField _bankAccount;
        private TMP_InputField _holderName;
        private TextMeshProUGUI _wallet;
        private TextMeshProUGUI _fee;

        private Button _chooseWalletBtn;
        private Button _bankManagerBtn;
        private Button _appBtn;
        private bool hasConfig;
        Dictionary<string, RechargeArray> rechargeConfig = new Dictionary<string, RechargeArray>();

        private RechageData currentRechargeData;
        private RechargeArray currentRechargeDataArr;

        private void Awake()
        {
            _exchangeRate = transform.FindChildDepth<TextMeshProUGUI>($"ExchangeRate");
            _mygoldNum = transform.FindChildDepth<TMP_InputField>($"MyGoldNum");
            _myWithdrawable = transform.FindChildDepth<TMP_InputField>($"MyWithdawNum");
            _amount = transform.FindChildDepth<TMP_InputField>($"Step1/Num");
            _bankAccount = transform.FindChildDepth<TMP_InputField>($"Step2/BankAccount");
            _holderName = transform.FindChildDepth<TMP_InputField>($"Step2/HolderName");
            _wallet = transform.FindChildDepth<TextMeshProUGUI>($"Step2/Wallet/TypeName");
            _fee = transform.FindChildDepth<TextMeshProUGUI>($"Step2/Wallet/WithDrawalFee");

            _chooseWalletBtn = transform.FindChildDepth<Button>($"ChooseBtn");
            _bankManagerBtn = transform.FindChildDepth<Button>($"ManagerBtn");
            _appBtn = transform.FindChildDepth<Button>($"AppBtn");

            _chooseWalletBtn.onClick.RemoveAllListeners();
            _chooseWalletBtn.onClick.Add(OnClickChoose);
            _bankManagerBtn.onClick.RemoveAllListeners();
            _bankManagerBtn.onClick.Add(OnClickOpenBankManager);
            _appBtn.onClick.RemoveAllListeners();
            _appBtn.onClick.Add(OnClickApply);
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

        public int Index { get; set; }

        public void Show()
        {
            hasConfig = false;
            gameObject.SetActive(true);
            currentRechargeData = default;
            currentRechargeData.id = -1;
            _exchangeRate.SetText($"");
            _mygoldNum.SetTextWithoutNotify($"{GameLocalMode.Instance.GetProp(Prop_Id.E_PROP_GOLD).ShortNumber()}");
            ToolHelper.ShowWaitPanel();
            FormData formData = new FormData();
            formData.AddField("type", "1");
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

                OnGetExchangeConfig(json);
            }, 1);
        }

        public void Hide()
        {
            gameObject.SetActive(false);
        }

        private void OnGetExchangeConfig(JsonData result)
        {
            var jsonData = JsonMapper.ToObject<List<RechargeArray>>(result["data"].ToJson());
            Model.Instance.CheckUnEnableBankAccount(jsonData);
            rechargeConfig.Clear();
            for (int i = 0; i < jsonData.Count; i++)
            {
                var rechargedata = jsonData[i];
                rechargeConfig[rechargedata.channel_name] = rechargedata;
                if (currentRechargeData.id < 0 && rechargedata.types.Count > 0)
                {
                    for (int j = 0; j < rechargedata.types.Count; j++)
                    {
                        var type = rechargedata.types[j];
                        currentRechargeData = type;
                        currentRechargeDataArr = rechargedata;
                        break;
                    }
                }
            }

            var savedata = Model.Instance.GetSelectBankData();
            if (savedata != null) //这里是容错，先已经筛选了已经没开放的渠道
            {
                var array = jsonData.Find(p => p.id == savedata.pid);
                if (array.types != null)
                {
                    currentRechargeData = array.types.Find(p => p.id == savedata.id);
                    currentRechargeDataArr = array;
                }
            }

            _amount.placeholder.GetComponent<TextMeshProUGUI>()
                .SetText(
                    $"{currentRechargeData.min}{currentRechargeData.unit}-{currentRechargeData.max}{currentRechargeData.unit}");
            _myWithdrawable.SetTextWithoutNotify($"{currentRechargeData.money}{currentRechargeData.unit}");
            _exchangeRate.SetText($"1{currentRechargeData.unit}={currentRechargeData.goldProportion.ShortNumber()}");
            if (currentRechargeData.id >= 0)
            {
                _wallet.SetText(currentRechargeData.name);
                _fee.SetText($"Withdrawal fee:<color=#f9613e>{currentRechargeData.channelTaxRate:P1}</color>");
            }
            else
            {
                ToolHelper.PopBigWindow(new BigMessage() {content = "not find enable withdrawal channel"});
            }
        }

        private void OnClickApply()
        {
            if (string.IsNullOrEmpty(GameLocalMode.Instance.SCPlayerInfo.SzPhoneNumber))
            {
                ToolHelper.PopBigWindow(new BigMessage()
                {
                    content = "You need to bind your phone to make withdrawals",
                    okCall = () =>
                    {
                        UIManager.Instance.OpenUI<BindPanel>();
                    }
                });
                return;
            }
            if (!hasConfig)
            {
                ToolHelper.PopBigWindow(new BigMessage() {content = "server is not work"});
                return;
            }

            if (string.IsNullOrEmpty(_amount.text))
            {
                ToolHelper.PopBigWindow(new BigMessage() {content = "The amount entered cannot be withdrawn"});
                return;
            }


            int.TryParse(_amount.text, out var gold);

            if (gold > currentRechargeData.money)
            {
                ToolHelper.PopBigWindow(new BigMessage() {content = "Not enough money to withdraw"});
                return;
            }

            if (gold < currentRechargeData.min || gold > currentRechargeData.max)
            {
                ToolHelper.PopBigWindow(new BigMessage() {content = "The amount entered cannot be withdrawn"});
                return;
            }

            if (gold > currentRechargeData.money)
            {
                ToolHelper.PopBigWindow(new BigMessage() {content = "Not enough money to withdraw"});
                return;
            }


            if (string.IsNullOrEmpty(_bankAccount.text) || string.IsNullOrEmpty(_holderName.text))
            {
                ToolHelper.PopBigWindow(new BigMessage()
                    {content = "Confirm that the information you fill in is correct"});
                return;
            }

            if (currentRechargeData.id < 0)
            {
                ToolHelper.PopBigWindow(new BigMessage()
                    {content = "Confirm that the information you fill in is correct"});
                return;
            }

            FormData formData = new FormData();
            formData.AddField("exchange.userId", $"{GameLocalMode.Instance.SCPlayerInfo.DwUser_Id}");
            formData.AddField("exchange.exchangeAmount", _amount.text);
            formData.AddField("exchange.bankNumber", _bankAccount.text);
            //formData.AddField("exchange.minId",$"{currentRechargeData.id}");
            //formData.AddField("exchange.maxId",$"{currentRechargeData.pid}");
            formData.AddField("exchange.channelName", $"{_wallet.text}");
            formData.AddField("exchange.cardholder", $"{_holderName.text}");


            //用户id: exchange.userId
            //兑换金额：exchange.exchangeAmount
            //银行卡号：exchange.bankNumber
            //渠道类型: exchange.channelName
            //用户名：exchange.cardholder


            Model.Instance.ReqExchangeData(formData, (t1, t2) =>
            {
                if (!t1)
                {
                    ToolHelper.PopBigWindow(new BigMessage()
                        {content = "Order generation failed, please try again later"});
                    return;
                }

                ToolHelper.PopBigWindow(new BigMessage()
                    {content = "Application is successful, please confirm your withdrawal progress"});
                BankBaseSaveData saveData = new BankBaseSaveData
                {
                    channelName = currentRechargeData.name,
                    account = _bankAccount.text,
                    holderName = _holderName.text
                };
                Model.Instance.SaveBankData(saveData);
                currentRechargeData.money = currentRechargeData.money - int.Parse(_amount.text);
                _myWithdrawable.SetTextWithoutNotify($"{currentRechargeData.money}{currentRechargeData.unit}");

                ByteBuffer buffer = new ByteBuffer();
                buffer.WriteUInt32(GameLocalMode.Instance.SCPlayerInfo.DwUser_Id);
                HotfixGameComponent.Instance.Send(DataStruct.PersonalStruct.MDM_3D_PERSONAL_INFO,
                    DataStruct.PersonalStruct.SUB_3D_CS_SELECT_GOLD_MSG,
                    buffer, SocketType.Hall);
            });
        }

        private void OnClickOpenBankManager()
        {
            if (rechargeConfig == null || rechargeConfig.Count <= 0)
            {
                ToolHelper.PopBigWindow(new BigMessage() {content = "Failed to get channel config"});
                return;
            }

            UIManager.Instance.OpenUI<BankManagerPanel>(new BankManagerPanelData()
            {
                saveData = Model.Instance.SaveDatas,
                selectCall = OnSelectSaveData,
                rechargeArrays = rechargeConfig,
            });
        }

        private void OnSelectSaveData(BankBaseSaveData obj)
        {
            if (string.IsNullOrEmpty(obj.channelName)) return;
            currentRechargeData = rechargeConfig[obj.channelName].types.Find(p => p.id == obj.id);

            _bankAccount.SetTextWithoutNotify(obj.account);
            _holderName.SetTextWithoutNotify(obj.holderName);
            _wallet.SetText(currentRechargeData.name);
            //_wallet.SetText(rechargeConfig[obj.pid].channel_name);

            _amount.placeholder.GetComponent<TextMeshProUGUI>()
                .SetText(
                    $"{currentRechargeData.min}{currentRechargeData.unit}-{currentRechargeData.max}{currentRechargeData.unit}");
        }

        private void OnClickChoose()
        {
            UIManager.Instance.OpenUI<BankPanel>(new BankPanelData()
            {
                config = rechargeConfig,
                data = currentRechargeData,
                dataArr = currentRechargeDataArr,
                selectCall = OnSelectChannel,
                selectCallArr = OnSelectChannel
            });
        }

        private void OnSelectChannel(bool isFrist, RechageData data)
        {
            currentRechargeData = data;
            _exchangeRate.SetText($"1{currentRechargeData.unit}={currentRechargeData.goldProportion.ShortNumber()}");
            _amount.placeholder.GetComponent<TextMeshProUGUI>()
                .SetText(
                    $"{currentRechargeData.min}{currentRechargeData.unit}-{currentRechargeData.max}{currentRechargeData.unit}");
            _wallet.SetText(currentRechargeData.name);
            _myWithdrawable.SetTextWithoutNotify($"{currentRechargeData.money}{currentRechargeData.unit}");
            _fee.SetText($"Withdrawal fee:<color=#f9613e>{currentRechargeData.channelTaxRate:P1}</color>");
            BankBaseSaveData saveData = new BankBaseSaveData
            {
                channelName = currentRechargeData.name,
                account = _bankAccount.text,
                holderName = _holderName.text
            };
            Model.Instance.SaveBankData(saveData);
        }

        private void OnSelectChannel(bool isFrist, RechargeArray data)
        {
            currentRechargeDataArr = data;
            currentRechargeData = data.types[0];
            _amount.placeholder.GetComponent<TextMeshProUGUI>()
                .SetText(
                    $"{currentRechargeData.min}{currentRechargeData.unit}-{currentRechargeData.max}{currentRechargeData.unit}");
            _wallet.SetText(currentRechargeDataArr.channel_name);
            _myWithdrawable.SetTextWithoutNotify($"{currentRechargeData.money}{currentRechargeData.unit}");
            _fee.SetText($"Withdrawal fee:<color=#f9613e>{currentRechargeData.channelTaxRate:P1}</color>");
            BankBaseSaveData saveData = new BankBaseSaveData
            {
                id = currentRechargeData.id,
                pid = currentRechargeData.pid,
                channelName = currentRechargeData.name,
                account = _bankAccount.text,
                holderName = _holderName.text
            };
            Model.Instance.SaveBankData(saveData);
        }

        private void OnEditAmount(string count)
        {
            int.TryParse(count, out var c);
            if (c >= currentRechargeData.min && c <= currentRechargeData.max)
            {
                if (c > currentRechargeData.money)
                {
                    ToolHelper.PopBigWindow(new BigMessage() {content = "Not enough money to withdraw"});
                }

                return;
            }

            _amount.SetTextWithoutNotify("");
            ToolHelper.PopBigWindow(new BigMessage() {content = "The amount of the charge is wrong, please re-enter"});
        }
    }
}