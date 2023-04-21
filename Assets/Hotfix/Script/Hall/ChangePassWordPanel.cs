using LuaFramework;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall
{
    internal class ChangePassWordPanel : PanelBase
    {
        private Button closeBtn;

        private Transform mainPanel;

        private Button maskCloseBtn;
        private InputField new2PW;
        private InputField newPW;
        private InputField oldPW;

        private Text phoneText;
        private Button sureBtn;
        private Toggle loginCodeOn;
        private Toggle loginCodeOff;

        public ChangePassWordPanel() : base(UIType.Middle, nameof(ChangePassWordPanel))
        {
        }

        public override void Create(params object[] args)
        {
            base.Create(args);
            loginCodeOff.isOn = !GameLocalMode.Instance.IsSetLoginValidation;
            phoneText.text = GameLocalMode.Instance.SCPlayerInfo.SzPhoneNumber;
        }

        protected override void FindComponent()
        {
            mainPanel = transform.FindChildDepth("MainPanel");
            maskCloseBtn = transform.FindChildDepth<Button>("Mask");
            closeBtn = mainPanel.FindChildDepth<Button>("CloseBtn");
            sureBtn = mainPanel.FindChildDepth<Button>("SureBtn");
            phoneText = mainPanel.FindChildDepth<Text>("Conent/phoneText/Text");
            oldPW = mainPanel.FindChildDepth<InputField>("Conent/OldPassWord/InputField");
            newPW = mainPanel.FindChildDepth<InputField>("Conent/newPassWord/InputField");
            new2PW = mainPanel.FindChildDepth<InputField>("Conent/TWoNewPassWord/InputField");
            Transform logincode = mainPanel.FindChildDepth($"LoginCode");
            loginCodeOn = logincode.FindChildDepth<Toggle>($"On");
            loginCodeOff = logincode.FindChildDepth<Toggle>($"Off");
        }

        protected override void AddEvent()
        {
            base.AddEvent();
            HallEvent.OnQueryLoginVerifyCallBack += HallEventOnOnQueryLoginVerifyCallBack;
            HallEvent.SC_CHANGE_PASSWORD += UpdataPasswordCallBack;
        }

        protected override void RemoveEvent()
        {
            base.RemoveEvent();
            HallEvent.OnQueryLoginVerifyCallBack -= HallEventOnOnQueryLoginVerifyCallBack;
            HallEvent.SC_CHANGE_PASSWORD -= UpdataPasswordCallBack;
        }

        protected override void AddListener()
        {
            maskCloseBtn.onClick.RemoveAllListeners();
            maskCloseBtn.onClick.Add(CloseBtnOnClick);
            closeBtn.onClick.RemoveAllListeners();
            closeBtn.onClick.Add(CloseBtnOnClick);

            sureBtn.onClick.RemoveAllListeners();
            sureBtn.onClick.Add(SureBtnOnClick);
            loginCodeOn.onValueChanged.RemoveAllListeners();
            loginCodeOn.onValueChanged.Add(OnOpenLoginCodeCall);
        }


        private void HallEventOnOnQueryLoginVerifyCallBack(HallStruct.ACP_SC_QueryLoginVerify obj)
        {
            loginCodeOn.isOn = obj.isOn;
        }
        private void OnOpenLoginCodeCall(bool isOn)
        {
            HallStruct.REQQueryLoginVerify reqQueryLoginVerify=new HallStruct.REQQueryLoginVerify();
            reqQueryLoginVerify.isChange = true;
            reqQueryLoginVerify.isSetOn = isOn;
            HotfixGameComponent.Instance.Send(DataStruct.PersonalStruct.MDM_3D_PERSONAL_INFO,
                DataStruct.PersonalStruct.SUB_3D_CS_LOGINVERIFY, reqQueryLoginVerify.ByteBuffer, SocketType.Hall);
        }

        private void SureBtnOnClick()
        {
            var oldPwd = oldPW.text;
            var newPwd = newPW.text;
            var ConfirmPwd = new2PW.text;
            if (newPwd.Length < 6 || newPwd.Length > 20)
            {
                ToolHelper.PopSmallWindow("password input error");
                return;
            }

            if (newPwd != ConfirmPwd)
            {
                ToolHelper.PopSmallWindow("The passwords entered twice are different, please re-enter");
                return;
            }

            sureBtn.interactable = false;

            var pw1 = MD5Helper.MD5String(oldPW.text);
            var pw2 = MD5Helper.MD5String(newPW.text);
            var changePW = new HallStruct.REQ_CS_ChangePassword(pw1, pw2);
            DebugHelper.Log($"修改密码:{pw1}----->{pw2}");
            HotfixGameComponent.Instance.Send(DataStruct.PersonalStruct.MDM_3D_PERSONAL_INFO,
                DataStruct.PersonalStruct.SUB_3D_CS_CHANGE_PASSWORD, changePW._ByteBuffer, SocketType.Hall);
        }

        private void UpdataPasswordCallBack(HallStruct.ACP_SC_CHANGE_PASSWOR data)
        {
            if (data == null)
            {
                ToolHelper.PopSmallWindow("password has been updated");
                GameLocalMode.Instance.Account.password = MD5Helper.MD5String(newPW.text);
                GameLocalMode.Instance.SaveAccount();
            }
            else
            {
                ToolHelper.PopSmallWindow($"Failed to change password:{data.Error}");
            }

            oldPW.text = "";
            newPW.text = "";
            new2PW.text = "";
            sureBtn.interactable = true;
        }

        private void CloseBtnOnClick()
        {
            ILMusicManager.Instance.PlayBtnSound();
            UIManager.Instance.Close();
        }
    }
}