using LuaFramework;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall
{
    public class UpdateBankPWPanel : PanelBase
    {
        private Button backBtn;
        private Button CloseBtn;
        private Button codeBtn;
        private InputField codeText;
        private float codeTime;

        private int getCodeTime;
        private bool isGetCode;

        private Text phoneText;
        private InputField PWText;
        private Button resetBtn;
        private InputField surePWText;
        private TextMeshProUGUI timetext;
        private Transform mainPanel;
        private Button maskCloseBtn;


        public UpdateBankPWPanel() : base(UIType.Middle, nameof(UpdateBankPWPanel))
        {
        }

        public override void Create(params object[] args)
        {
            base.Create(args);
            Init();
            isGetCode = false;
            getCodeTime = 60;
        }


        protected override void AddEvent()
        {
            base.AddEvent();

            HallEvent.LogonFindPW_GetCode += UpdatePwdCodeSC;
            HallEvent.Bank_Change_PW += UpdatePwdSuccess;
        }

        protected override void RemoveEvent()
        {
            base.RemoveEvent();
            HallEvent.LogonFindPW_GetCode -= UpdatePwdCodeSC;
            HallEvent.Bank_Change_PW -= UpdatePwdSuccess;
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
            CloseBtn = mainPanel.FindChildDepth<Button>("CloseBtn");
            
            phoneText = mainPanel.FindChildDepth<Text>("phone/Text");
            PWText = mainPanel.FindChildDepth<InputField>("pwd/InputField");
            surePWText = mainPanel.FindChildDepth<InputField>("surepwd/InputField");
            codeText = mainPanel.FindChildDepth<InputField>("code/InputField");
            codeBtn = mainPanel.FindChildDepth<Button>("codebtn");
            backBtn = mainPanel.FindChildDepth<Button>("BackBtn");
            resetBtn = mainPanel.FindChildDepth<Button>("ResetBtn");
            timetext = codeBtn.transform.FindChildDepth<TextMeshProUGUI>("Time");
        }

        protected override void AddListener()
        {
            codeBtn.onClick.RemoveAllListeners();
            codeBtn.onClick.Add(UpdatePwdCodeBtn);

            backBtn.onClick.RemoveAllListeners();
            backBtn.onClick.Add(UpdateBackOnClick);

            CloseBtn.onClick.RemoveAllListeners();
            CloseBtn.onClick.Add(UpdateBackOnClick);
            maskCloseBtn.onClick.RemoveAllListeners();
            maskCloseBtn.onClick.Add(UpdateBackOnClick);

            resetBtn.onClick.RemoveAllListeners();
            resetBtn.onClick.Add(() => { UpdateResetBtnOnClick(resetBtn); });
        }

        private void UpdateResetBtnOnClick(Button args)
        {
            ILMusicManager.Instance.PlayBtnSound();
            args.interactable = false;

            if (PWText.text.Length < 6 || PWText.text.Length > 12)
            {
                ToolHelper.PopSmallWindow("Incorrect password format");
                args.interactable = true;
                return;
            }

            if (codeText.text.Length < 4 || codeText.text.Length > 8)
            {
                ToolHelper.PopSmallWindow("The verification code is incorrect");
                args.interactable = true;
                return;
            }

            if (PWText.text != surePWText.text)
            {
                ToolHelper.PopSmallWindow("Two passwords entered are different");
                args.interactable = true;
                return;
            }

            var phoneNum = GameLocalMode.Instance.SCPlayerInfo.SzPhoneNumber;
            var _PW = MD5Helper.MD5String(PWText.text);
            var code = int.Parse(codeText.text);
            var PlatformID = (byte) GameLocalMode.Instance.PlatformID;
            var resetPW = new HallStruct.REQ_CS_Bank_Reset_Password(phoneNum, _PW, code, PlatformID);
            HotfixGameComponent.Instance.Send(DataStruct.BankStruct.MDM_GP_USER,
                DataStruct.BankStruct.SUB_GP_MODIFY_BANK_PASSWD, resetPW._ByteBuffer, SocketType.Hall);
        }

        private void UpdatePwdSuccess(HallStruct.ACP_SC_Bank_Change_PW data)
        {
            resetBtn.GetComponent<Button>().interactable = true;
            if (data.cbSuccess == 1)
            {
                ToolHelper.PopSmallWindow("The reset password is successful, please keep it safe");
                return;
            }

            ToolHelper.PopSmallWindow(data.szInfoDiscrib);
        }


        private void UpdateBackOnClick()
        {
            ILMusicManager.Instance.PlayBtnSound();
            UIManager.Instance.Close();
        }

        /// <summary>
        ///     获取验证码
        /// </summary>
        private void UpdatePwdCodeBtn()
        {
            ILMusicManager.Instance.PlayBtnSound();
            var phonenum = GameLocalMode.Instance.SCPlayerInfo.SzPhoneNumber;
            
            var msg = ToolHelper.CheckIsFLBPhoneNumber(phonenum);
            if (!string.IsNullOrEmpty(msg))
            {
                ToolHelper.PopSmallWindow(msg);
                return;
            }

            codeBtn.interactable = false;
            codeBtn.transform.FindChildDepth($"Show").gameObject.SetActive(false);
            timetext.gameObject.SetActive(true);
            timetext.text = "60s again";
            getCodeTime = 60;
            GetCodeRemTime(getCodeTime);
            isGetCode = true;
            string countryPhone = $"63{phonenum}";
            var check_Code = new HallStruct.REQ_CS_Bank_Code(countryPhone);
            HotfixGameComponent.Instance.Send(DataStruct.BankStruct.MDM_GP_USER,
                DataStruct.BankStruct.SUB_GP_MODIFY_BANK_PASSWD_CHECK_CODE, check_Code._ByteBuffer, SocketType.Hall);
        }

        /// <summary>
        ///     获取验证码返回
        /// </summary>
        /// <param name="code"></param>
        private void UpdatePwdCodeSC(int code)
        {
            if (code > 0) return;
            ToolHelper.PopSmallWindow("Can't find the phone number");
            codeBtn.transform.FindChildDepth("Show").gameObject.SetActive(true);
            timetext.gameObject.SetActive(false);
            codeBtn.interactable = true;
        }

        /// <summary>
        ///     验证码时间
        /// </summary>
        /// <param name="num"></param>
        private void GetCodeRemTime(int num)
        {
            timetext.text = num + "s again";
            if (num > 0) return;
            timetext.gameObject.SetActive(false);
            codeBtn.transform.FindChildDepth("Show").gameObject.SetActive(true);
            isGetCode = false;
            codeBtn.interactable = true;
        }

        private void Init()
        {
            if (GameLocalMode.Instance.SCPlayerInfo.SzPhoneNumber == "") return;
            var str = GameLocalMode.Instance.SCPlayerInfo.SzPhoneNumber;
            var str1 = str.Substring(0, 3);
            var str2 = str.Substring(str.Length - 5, 4);
            phoneText.text = $"{str1}****{str2}";
        }
    }
}