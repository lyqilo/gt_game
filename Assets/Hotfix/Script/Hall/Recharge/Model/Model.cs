using System;
using System.Collections.Generic;

namespace Hotfix.Hall.Recharge
{
    public partial class Model : Singleton.Singleton<Model>, IModule
    {
        public const string RechargeUrl = "rechargeDock/phpToUp";
        private const string ExchangeUrl = "rechargeDock/exchangePay";
        private const string ConfigUrl = "rechargeDock/all_channel";
        private const string RechargeRecordUrl = "rechargeDock/recharge";
        private const string ExchangeRecordUrl = "rechargeDock/exchange";
        private const string FristRechargeConfig = "rechargeDock/firstrecharge";
        public const string SaveKey = "StoreSaveKey";

        public BankSaveData SaveDatas;


        private string rechargeConfig;
        private string exchangeConfig;
        private string rechargeRecord;
        private string exchangeRecord;

        private long reqRechargeConfigDuration = 1 * 60;
        private long reqExchangeConfigDuration = 1 * 60;
        private long reqRechargeRecordDuration = 5 * 60;
        private long reqExchangeRecordDuration = 5 * 60;

        private long reqRechargeConfigTime = 0;
        private long reqExchangeConfigTime = 0;
        private long reqRechargeRecordTime = 0;
        private long reqExchangeRecordTime = 0;

        public void Initialize()
        {
            SaveDatas = SaveHelper.Get<BankSaveData>(SaveKey, $"{GameLocalMode.Instance.SCPlayerInfo.DwUser_Id}") ??
                        new BankSaveData() {datas = new List<BankBaseSaveData>()};
            HallEvent.EnterHall += ResetState;
            HotfixActionHelper.OnEnterGame += ResetState;
        }

        public void UnInitialize()
        {
            HallEvent.EnterHall -= ResetState;
            HotfixActionHelper.OnEnterGame -= ResetState;
            reqRechargeConfigTime = 0;
            reqExchangeConfigTime = 0;
            reqRechargeRecordTime = 0;
            reqExchangeRecordTime = 0;
            rechargeConfig = null;
            exchangeConfig = null;
            rechargeRecord = null;
            exchangeRecord = null;
        }

        private void ResetState()
        {
            reqRechargeConfigTime = 0;
            reqExchangeConfigTime = 0;
            reqRechargeRecordTime = 0;
            reqExchangeRecordTime = 0;
        }

        /// <summary>
        /// 请求充值数据
        /// </summary>
        /// <param name="formData">数据参数表单</param>
        /// <param name="result">回调</param>
        public void ReqRechargeData(FormData formData, CAction<bool, string> result)
        {
            HttpManager.Instance.PostText($"{GameLocalMode.HttpURL}{RechargeUrl}", formData, result);
        }

        /// <summary>
        /// 请求充值数据
        /// </summary>
        /// <param name="formData">数据参数表单</param>
        /// <param name="result">回调</param>
        public void ReqConfigData(FormData formData, CAction<bool, string> result, int type)
        {
            long duration = 0;
            long reqtime = 0;
            switch (type)
            {
                case 0:
                    duration = reqRechargeConfigDuration;
                    reqtime = reqRechargeConfigTime;
                    break;
                case 1:
                    duration = reqExchangeConfigDuration;
                    reqtime = reqExchangeConfigTime;
                    break;
            }

            long serverTime = TimeComponent.Instance.GetServerTime();
            if (serverTime > 0 && serverTime - duration < reqtime)
            {
                //处于请求冷却时间，直接返回上次结果
                result?.Invoke(true, type == 0 ? rechargeConfig : exchangeConfig);
                return;
            }

            HttpManager.Instance.PostText($"{GameLocalMode.HttpURL}{ConfigUrl}", formData, (t1, t2) =>
            {
                if (t1)
                {
                    switch (type)
                    {
                        case 0:
                            reqRechargeConfigTime = serverTime;
                            rechargeConfig = t2;
                            break;
                        case 1:
                            reqExchangeConfigTime = serverTime;
                            exchangeConfig = t2;
                            break;
                    }
                }

                result?.Invoke(t1, t2);
            });
        }

        /// <summary>
        /// 请求首充配置
        /// </summary>
        /// <param name="result"></param>
        public void ReqFristRechargeConfig(CAction<bool, string> result)
        {
            HttpManager.Instance.GetText($"{GameLocalMode.HttpURL}{FristRechargeConfig}", result);
        }

        /// <summary>
        /// 请求兑换数据
        /// </summary>
        /// <param name="formData">数据参数表单</param>
        /// <param name="result">回调</param>
        public void ReqExchangeData(FormData formData, CAction<bool, string> result)
        {
            HttpManager.Instance.PostText($"{GameLocalMode.HttpURL}{ExchangeUrl}", formData, result);
        }

        /// <summary>
        /// 请求充值记录
        /// </summary>
        /// <param name="formData">数据参数表单</param>
        /// <param name="result">回调</param>
        public void ReqRechargeRecordData(FormData formData, CAction<bool, string> result)
        {
            long serverTime = TimeComponent.Instance.GetServerTime();
            if (serverTime > 0 && serverTime - reqRechargeRecordDuration < reqRechargeRecordTime)
            {
                //处于请求冷却时间，直接返回上次结果
                result?.Invoke(true, rechargeRecord);
                return;
            }

            HttpManager.Instance.PostText($"{GameLocalMode.HttpURL}{RechargeRecordUrl}", formData, (t1, t2) =>
            {
                if (t1)
                {
                    reqRechargeRecordTime = TimeComponent.Instance.GetServerTime();
                    rechargeRecord = t2;
                }

                result?.Invoke(t1, t2);
            });
        }

        /// <summary>
        /// 请求兑换记录
        /// </summary>
        /// <param name="formData">数据参数表单</param>
        /// <param name="result">回调</param>
        public void ReqExchangeRecordData(FormData formData, CAction<bool, string> result)
        {
            long serverTime = TimeComponent.Instance.GetServerTime();
            if (serverTime > 0 && serverTime - reqExchangeRecordDuration < reqExchangeRecordTime)
            {
                //处于请求冷却时间，直接返回上次结果
                result?.Invoke(true, exchangeRecord);
                return;
            }

            HttpManager.Instance.PostText($"{GameLocalMode.HttpURL}{ExchangeRecordUrl}", formData, (t1, t2) =>
            {
                if (t1)
                {
                    reqExchangeRecordTime = TimeComponent.Instance.GetServerTime();
                    exchangeRecord = t2;
                }

                result?.Invoke(t1, t2);
            });
        }

        /// <summary>
        /// 清除不可用银行账户
        /// </summary>
        public void CheckUnEnableBankAccount(List<RechargeArray> dataarray)
        {
            if (SaveDatas.datas.Count <= 0) return;
            for (int i = SaveDatas.datas.Count - 1; i >= 0; i--)
            {
                bool hasExsit = false;
                var data = SaveDatas.datas[i];
                for (int j = 0; j < dataarray.Count; j++)
                {
                    if (!dataarray[j].types.Exists(p =>
                        (!string.IsNullOrEmpty(data.channelName) && data.channelName.Equals(p.name)))) continue;
                    hasExsit = true;
                    break;
                }

                if (hasExsit) continue;
                SaveDatas.datas.RemoveAt(i);
            }
        }

        /// <summary>
        /// 获取上次选中的渠道
        /// </summary>
        /// <returns></returns>
        public BankBaseSaveData GetSelectBankData()
        {
            return SaveDatas.datas.Find(p => p.isSelect);
        }

        /// <summary>
        /// 保存银行账户信息
        /// </summary>
        /// <param name="data"></param>
        public void SaveBankData(BankBaseSaveData data)
        {
            bool isFind = false;
            if (string.IsNullOrEmpty(data.channelName))
            {
                data.uid = $"{data.id}/{data.pid}/{data.account}/{data.holderName}";
            }
            else
            {
                data.uid = $"{data.channelName}/{data.account}/{data.holderName}";
            }

            for (int i = 0; i < SaveDatas.datas.Count; i++)
            {
                var savedata = SaveDatas.datas[i];
                if (string.IsNullOrEmpty(savedata.uid))
                {
                    savedata.uid = $"{savedata.id}/{savedata.pid}/{savedata.account}/{savedata.holderName}";
                }

                if (data.uid.Equals(savedata.uid))
                {
                    isFind = true;
                    savedata.isSelect = true;
                }
                else
                {
                    savedata.isSelect = false;
                }
            }

            if (!isFind) SaveDatas.datas.Add(data);
            SaveHelper.Save(SaveKey, SaveDatas, $"{GameLocalMode.Instance.SCPlayerInfo.DwUser_Id}");
        }

        /// <summary>
        /// 删除银行账户信息
        /// </summary>
        /// <param name="uid"></param>
        public void DeleteSaveBankData(string uid)
        {
            int index = SaveDatas.datas.FindIndex(p => p.uid == uid);
            if (index >= 0) SaveDatas.datas.RemoveAt(index);
            SaveHelper.Save(SaveKey, SaveDatas, $"{GameLocalMode.Instance.SCPlayerInfo.DwUser_Id}");
        }
    }

public class CallBackData{
public int code;
public FristRechargeData data;

public string message;

public bool success;
}

    public struct FristRechargeData
    {
        public long amount;
        public long gold;
        public long give_gold;
        public int type;
        public int beetl_rn;
    }

    /// <summary>
    /// 充值数据
    /// </summary>
    public struct RechageData
    {
        public int id;
        public string name;
        public int pid;
        public int min;
        public int max;
        public double channelTaxRate;
        public int sort;
        public double give;
        public double fee;
        public double goldProportion;

        public int isLabel;
        public long money;
        public string unit;
    }

    public struct RechargeArray
    {
        public string channel_name;
        public int id;
        public List<RechageData> types;
    }

    /// <summary>
    /// 记录充值兑换
    /// </summary>
    public struct CommonRecordData
    {
        public string createTime;
        public long amount;
        public long gold;
        public int orderStatus;
        public string feedback;
        public int status;
    }

    public class BankSaveData : BaseSave
    {
        public List<BankBaseSaveData> datas;
    }

    public class BankBaseSaveData
    {
        public string uid;
        public string account;
        public string holderName;
        public string channelName;
        public int id;
        public int pid;
        public bool isSelect;
    }
}