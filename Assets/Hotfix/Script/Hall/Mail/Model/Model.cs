using System.Collections.Generic;
using System.Threading.Tasks;
using LitJson;
using LuaFramework;
using UnityEngine;

namespace Hotfix
{
    public partial class CustomEvent
    {
        public const string MDM_3D_MAIL = "MDM_3D_MAIL";
    }
}

namespace Hotfix.Hall.Mail
{
    public class Model : Singleton.Singleton<Model>, IModule
    {
        public const string RedKey = "hall.mail";
        public const string Config = "/info/senders";
        private Dictionary<int, HallStruct.sMail> _mails = new Dictionary<int, HallStruct.sMail>();

        private bool _isinit;

        private bool hasReqLit;

        public CAction OnMailGetReward { get; set; }
        public CAction OnMailRead { get; set; }

        public Dictionary<int, MailConfig> MailConfigs { get; set; } = new Dictionary<int, MailConfig>();

        private TaskCompletionSource<bool> _completionSource;
        public async void Initialize()
        {
            if (_isinit) UnInitialize();
            _isinit = true;
            AddEvent();
            await ReqMailConfig();
            ReqMailList();
        }

        public void UnInitialize()
        {
            _isinit = false;
            _mails.Clear();
            hasReqLit = false;
            RemoveEvent();
        }

        private void AddEvent()
        {
            HotfixMessageHelper.AddListener(CustomEvent.MDM_3D_MAIL, OnRecieveMailMessage);
        }

        private void RemoveEvent()
        {
            HotfixMessageHelper.RemoveListener(CustomEvent.MDM_3D_MAIL, OnRecieveMailMessage);
        }

        private void OnRecieveMailMessage(object data)
        {
            if (!(data is BytesPack mailMessage)) return;
            switch (mailMessage.sid)
            {
                case DataStruct.MailStruct.S2C_ADD_MAIL:
                {
                    HallStruct.sMail mail = new HallStruct.sMail(new ByteBuffer(mailMessage.bytes));
                    _mails[mail.nMailID] = mail;
                    break;
                }
                case DataStruct.MailStruct.S2C_CLAIM_MAIL_RESP:
                {
                    HallStruct.sCommonINT64 gold = new HallStruct.sCommonINT64(new ByteBuffer(mailMessage.bytes));
                    GameLocalMode.Instance.ChangProp(gold.nValue, Prop_Id.E_PROP_GOLD);
                    OnMailGetReward?.Invoke();
                    break;
                }
                case DataStruct.MailStruct.S2C_GET_MAIL_LIST_RESP:
                {
                    HallStruct.sMailDatas mailDatas = new HallStruct.sMailDatas(new ByteBuffer(mailMessage.bytes));
                    for (int i = 0; i < mailDatas.Mails.Count; i++)
                    {
                        var mail = mailDatas.Mails[i];
                        _mails[mail.nMailID] = mail;
                    }

                    break;
                }
            }

            bool state = CheckHasUnReadOrRecieve();
            RedPoint.Model.Instance.SetRedPoint(RedKey, state ? 1 : 0);
        }

        public async Task ReqMailConfig()
        {
            _completionSource = new TaskCompletionSource<bool>();
            HttpManager.Instance.PostText($"{GameLocalMode.HttpURL}{Config}", new FormData(),
                (isSuccess, result) =>
                {
                    if (!isSuccess)
                    {
                        _completionSource.TrySetResult(false);
                        return;
                    }
                    DebugHelper.LogError(result);
                    var jsonData = JsonMapper.ToObject(result);
                    if (jsonData["code"].ToString() != "0")
                    {
                        _completionSource.TrySetResult(false);
                        return;
                    }
                    MailConfigs.Clear();
                    List<MailConfig> list = JsonMapper.ToObject<List<MailConfig>>(jsonData["data"].ToJson());
                    if (list == null)
                    {
                        _completionSource.TrySetResult(true);
                        return;
                    }
                    for (int i = 0; i < list.Count; i++)
                    {
                        MailConfigs.Add(list[i].id, list[i]);
                    }

                    _completionSource.TrySetResult(true);
                });
            await _completionSource.Task;
        }

        public void ReqMailList()
        {
            if (hasReqLit) return; //如果已经请求过列表了，不再重复请求
            HotfixGameComponent.Instance.Send(DataStruct.MailStruct.MDM_3D_MAIL,
                DataStruct.MailStruct.C2S_GET_MAIL_LIST, new ByteBuffer(), SocketType.Hall);
        }

        /// <summary>
        /// 获取邮件列表，并进行排序未读优先
        /// </summary>
        /// <returns></returns>
        public List<UIMail.TitleData> GetMailData()
        {
            List<UIMail.TitleData> hasRead = new List<UIMail.TitleData>();
            List<UIMail.TitleData> notRead = new List<UIMail.TitleData>();
            foreach (var mail in _mails)
            {
                if (mail.Value.bIsRead) hasRead.Add(new UIMail.TitleData(mail.Value));
                else notRead.Add(new UIMail.TitleData(mail.Value));
            }

            hasRead.Sort((a, b) => a.Mail.nSendTime.CompareTo(b.Mail.nSendTime));
            notRead.Sort((a, b) => a.Mail.nSendTime.CompareTo(b.Mail.nSendTime));
            notRead.AddRange(hasRead);
            return notRead;
        }

        /// <summary>
        /// 查看邮件
        /// </summary>
        /// <param name="mailId"></param>
        public void ReadMail(int mailId)
        {
            if (!_mails.ContainsKey(mailId)) return;
            var mail = _mails[mailId];
            if (mail == null || mail.bIsRead) return;
            HallStruct.sCommonINT32 id = new HallStruct.sCommonINT32 {nValue = mailId};
            HotfixGameComponent.Instance.Send(DataStruct.MailStruct.MDM_3D_MAIL,
                DataStruct.MailStruct.C2S_READ_MAIL, id.Buffer, SocketType.Hall);
            mail.bIsRead = true;

            bool state = CheckHasUnReadOrRecieve();
            RedPoint.Model.Instance.SetRedPoint(RedKey, state ? 1 : 0);
        }

        /// <summary>
        /// 领取邮件
        /// </summary>
        /// <param name="mailId"></param>
        public void ClaimMail(int mailId)
        {
            if (!_mails.ContainsKey(mailId)) return;
            var mail = _mails[mailId];
            if (mail == null || mail.bIsClaim) return;
            mail.bIsClaim = true;
        }

        /// <summary>
        /// 检测是否还有未领取或者未读邮件
        /// </summary>
        /// <returns></returns>
        private bool CheckHasUnReadOrRecieve()
        {
            foreach (var mail in _mails)
            {
                if ((mail.Value.nGold > 0 && !mail.Value.bIsClaim) || !mail.Value.bIsRead) return true;
            }

            return false;
        }
    }

    public struct MailConfig
    {
        public int id;
        public string sender;
    }
}