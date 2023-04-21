using LuaFramework;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall
{
    public class BindPanel : PanelBase
    {
        private Button closeBtn;
        private InputField code;
        private float codeTime;
        private Transform codeTimeText;
        private Transform codeTipText;
        private Button getCodeBtn;


        private int getCodeTime;
        private bool isGetCode;
        private InputField logonPW;
        private Transform mainPanel;

        private Button maskCloseBtn;

        private InputField phoneNum;

        private Button sureBtn;

        private AccountMSG _accountMsg;

        private InputField invite;
        private TextMeshProUGUI _tip;

        public BindPanel() : base(UIType.Middle, nameof(BindPanel))
        {
        }

        public override void Create(params object[] args)
        {
            base.Create(args);
            getCodeTime = 120;
            codeTime = 0f;
            isGetCode = false;
            codeTipText.gameObject.SetActive(true);
            codeTimeText.gameObject.SetActive(false);
            getCodeBtn.interactable = true;
            codeTimeText.GetComponent<Text>().text = "";
            _tip.SetText($"Get <size=50>{50000.ShortNumber().ShowRichText()}</size>gold by binding your phone now");
        }
        protected override void OnDestroy()
        {
            base.OnDestroy();
            HotfixMessageHelper.PostHotfixEvent(PopTaskSystem.Model.CompleteShowPop, BindPhone.Model.Instance.PopName);
        }

        protected override void AddEvent()
        {
            base.AddEvent();
            HallEvent.SC_CHANGE_ACCOUNT += BindAccCallBack;
            HallEvent.SC_BindCodeCallBack += GetCodeCallBack;
        }

        protected override void RemoveEvent()
        {
            base.RemoveEvent();
            HallEvent.SC_CHANGE_ACCOUNT -= BindAccCallBack;
            HallEvent.SC_BindCodeCallBack -= GetCodeCallBack;
        }

        protected override void Update()
        {
            base.Update();
            if (!isGetCode) return;
            codeTime += Time.deltaTime;
            if (codeTime < 1) return;
            codeTime = 0f;
            getCodeTime--;
            GetCodeRemTime(getCodeTime);
        }


        protected override void FindComponent()
        {
            mainPanel = transform.FindChildDepth("MainPanel");

            maskCloseBtn = transform.FindChildDepth<Button>("Mask");
            closeBtn = mainPanel.FindChildDepth<Button>("CloseBtn");

            phoneNum = mainPanel.FindChildDepth<InputField>("SJHM/InputField");
            logonPW = mainPanel.FindChildDepth<InputField>("DLMM/InputField");
            code = mainPanel.FindChildDepth<InputField>("YZM/InputField");
            getCodeBtn = mainPanel.FindChildDepth<Button>("HQTZMBtn");
            codeTipText = mainPanel.FindChildDepth("HQTZMBtn/Image");
            codeTimeText = mainPanel.FindChildDepth("HQTZMBtn/Text");
            sureBtn = mainPanel.FindChildDepth<Button>("SureBtn");
            _tip = mainPanel.FindChildDepth<TextMeshProUGUI>("Tip");

            invite = mainPanel.FindChildDepth<InputField>("invite/InputField");
            sureBtn.interactable = true;
        }

        protected override void AddListener()
        {
            maskCloseBtn.onClick.RemoveAllListeners();
            maskCloseBtn.onClick.Add(CloseBtnOnClick);
            closeBtn.onClick.RemoveAllListeners();
            closeBtn.onClick.Add(CloseBtnOnClick);

            getCodeBtn.onClick.RemoveAllListeners();
            getCodeBtn.onClick.Add(GetCodeBtnOnClick);

            sureBtn.onClick.RemoveAllListeners();
            sureBtn.onClick.Add(SureBtnOnClick);
        }

        private void GetCodeBtnOnClick()
        {
            var msg = ToolHelper.CheckIsFLBPhoneNumber(phoneNum.text);
            if (!string.IsNullOrEmpty(msg))
            {
                ToolHelper.PopSmallWindow(msg);
                return;
            }

            getCodeBtn.interactable = false;
            getCodeTime = 120;
            isGetCode = true;
            codeTipText.gameObject.SetActive(false);
            codeTimeText.GetComponent<Text>().text = $"{getCodeTime}s again";
            codeTimeText.gameObject.SetActive(true);
            string countryPhone = $"63{phoneNum.text}";
            var bind = new HallStruct.REQ_CS_BindGetCode(1, 1, countryPhone);
            HotfixGameComponent.Instance.Send(DataStruct.LoginStruct.MDM_3D_LOGIN,
                DataStruct.LoginStruct.SUB_3D_SC_DOWN_GAME_RESOURCE, bind._ByteBuffer, SocketType.Hall);
        }

        private void GetCodeRemTime(int Time)
        {
            codeTimeText.GetComponent<Text>().text = $"{Time}s again";
            if (Time > 0) return;
            isGetCode = false;
            codeTipText.gameObject.SetActive(true);
            codeTimeText.gameObject.SetActive(false);
            getCodeBtn.interactable = true;
            codeTimeText.GetComponent<Text>().text = "";
        }


        private void GetCodeCallBack(uint index)
        {
            if (index == 0) ToolHelper.PopSmallWindow("The phone number has been bound");
        }

        /// <summary>
        ///     给服务器发送绑定手机号的信息
        /// </summary>
        private void SureBtnOnClick()
        {
            ILMusicManager.Instance.PlayBtnSound();

            sureBtn.interactable = false;
            var NewPhoneNumber = phoneNum.text;
            var Code = code.text;
            var PWText = logonPW.text;


            var msg = ToolHelper.CheckIsFLBPhoneNumber(NewPhoneNumber);
            if (!string.IsNullOrEmpty(msg))
            {
                ToolHelper.PopSmallWindow(msg);
                return;
            }

            if (Code.Length < 4 || Code.Length > 8)
            {
                ToolHelper.PopSmallWindow("Code input error");
                return;
            }

            if (string.IsNullOrEmpty(PWText))
            {
                ToolHelper.PopSmallWindow("password input error");
                return;
            }

            ToolHelper.ShowWaitPanel();
            sureBtn.interactable = true;
            _accountMsg = new AccountMSG()
            {
                account = NewPhoneNumber,
                password = MD5Helper.MD5String(PWText),
                LoginType = GameLocalMode.Instance.SCPlayerInfo.SzPhoneNumber == "" ? 1 : 2,
            };
            var acc = new HallStruct.REQ_CS_ChangeAccount(NewPhoneNumber, int.Parse(Code), MD5Helper.MD5String(PWText),
                invite.text);
            HotfixGameComponent.Instance.Send(DataStruct.PersonalStruct.MDM_3D_PERSONAL_INFO,
                DataStruct.PersonalStruct.SUB_3D_CS_CHANGE_ACCOUNT, acc._ByteBuffer, SocketType.Hall);
        }

        private void BindAccCallBack(HallStruct.sCommonINT16 data)
        {
            ToolHelper.ShowWaitPanel(false);
            // 1：该手机已经注册
            // 2：邀请码错误
            // 3：已经绑定过邀请码
            // 4：玩家未绑定手机号
            // 5：要绑定的用户未绑定手机号
            // 6：不能绑定自己的下级


            // string[] errList = new string[]
            // {
            //     "该手机已经注册",
            //     "邀请码错误",
            //     "已经绑定过邀请码",
            //     "玩家未绑定手机号",
            //     "要绑定的用户未绑定手机号",
            //     "不能绑定自己的下级",
            // };
            string[] errList = new string[]
            {
                "This phone is registered",
                "Invitation code error",
                "Invitation code has been bound",
                "Unbound cell phone number",
                "The user to bind has not bound the phone",
                "Can't bind the person you invited",
            };

            if (data.nValue == 0)
            {
                ToolHelper.PopSmallWindow("cell phone number binding success");
                Clear();
                GameLocalMode.Instance.Account = _accountMsg;
                GameLocalMode.Instance.SaveAccount();
                GameLocalMode.Instance.SCPlayerInfo.SzPhoneNumber = _accountMsg.account;
                UIManager.Instance.Close();
                Mail.Model.Instance.ReqMailList();
                FormData formData = new FormData();
                formData.AddField("userId", GameLocalMode.Instance.SCPlayerInfo.DwUser_Id.ToString());
                formData.AddField("Money", "0");
                formData.AddField("type", "1");
                GameLocalMode.Instance.AdjustLog("dcx5w1",formData);
                HotfixGameComponent.Instance.Send(DataStruct.RechargeStruct.MDM_3D_WEB_RECHARGE,
                    DataStruct.RechargeStruct.C2S_DOT_DATA, new HallStruct.sCommonINT32 {nValue = 1}.Buffer,
                    SocketType.Hall);
            }
            else
            {
                sureBtn.interactable = true;
                ToolHelper.PopSmallWindow(errList[data.nValue - 1]);
            }
        }

        private void CloseBtnOnClick()
        {
            ILMusicManager.Instance.PlayBtnSound();
            Clear();
            UIManager.Instance.Close();
        }

        private void Clear()
        {
            phoneNum.text = "";
            logonPW.text = "";
            code.text = "";
        }
    }
}