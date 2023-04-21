using LuaFramework;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall
{
    public class SetPanel : PanelBase
    {
        private Transform accInfo;
        private Button accInfoBtn;
        private Text accInfoName;

        private Button closeBtn;

        private Text logonType;
        private Transform mainPanel;
        private Button maskCloseBtn;
        private Button musicBtn;
        private Text nowSta;

        private Transform phoneInfo;
        private Button phoneInfoBtn;

        private Transform PWInfo;
        private Button PWInfoBtn;

        private Button quitGameBtn;

        private Transform RecFrameBtns;
        private Slider MusicSlider;
        private Slider SoundSlider;

        private Toggle Musictog;
        private Toggle Musictog2;

        private Toggle Soundtog;
        private Toggle Soundtog2;
        public SetPanel() : base(UIType.Middle, nameof(SetPanel))
        {
        }

        public override void Create(params object[] args)
        {
            base.Create(args);
            Init();
        }

        protected override void FindComponent()
        {
            mainPanel = transform.FindChildDepth("MainPanel");
            maskCloseBtn = transform.FindChildDepth<Button>("Mask");
            closeBtn = mainPanel.FindChildDepth<Button>("CloseBtn");

            logonType = mainPanel.FindChildDepth<Text>("logonType/Text");
            nowSta = mainPanel.FindChildDepth<Text>("nowSta/Text");

            RecFrameBtns = mainPanel.FindChildDepth("Group");

            accInfo = RecFrameBtns.FindChildDepth("AccountInfo");
            accInfoName = accInfo.FindChildDepth<Text>("name");
            accInfoBtn = accInfo.FindChildDepth<Button>("SetBtn");

            PWInfo = RecFrameBtns.FindChildDepth("PasswordInfo");
            PWInfoBtn = PWInfo.FindChildDepth<Button>("SetBtn");

            phoneInfo = RecFrameBtns.FindChildDepth("SetPhone");
            phoneInfoBtn = phoneInfo.FindChildDepth<Button>("SetBtn");

            quitGameBtn = mainPanel.FindChildDepth<Button>("quitGameBtn");
            musicBtn = mainPanel.FindChildDepth<Button>("musicBtn");

            
            MusicSlider = mainPanel.FindChildDepth<Slider>("GroupMusic/Music/Slider");
            SoundSlider = mainPanel.FindChildDepth<Slider>("GroupMusic/Sound/Slider");
        }

        protected override void AddListener()
        {
            maskCloseBtn.onClick.RemoveAllListeners();
            maskCloseBtn.onClick.Add(() => { CloseSetPanel(); });
            closeBtn.onClick.RemoveAllListeners();
            closeBtn.onClick.Add(() => { CloseSetPanel(closeBtn.transform); });

            accInfoBtn.onClick.RemoveAllListeners();
            accInfoBtn.onClick.Add(ChangeAccOnClick);

            PWInfoBtn.onClick.RemoveAllListeners();
            PWInfoBtn.onClick.Add(SafeBtnOnClick);

            phoneInfoBtn.onClick.RemoveAllListeners();
            phoneInfoBtn.onClick.Add(BDPhonePanel);

            quitGameBtn.onClick.RemoveAllListeners();
            quitGameBtn.onClick.Add(ExitGameCall);

            musicBtn.onClick.RemoveAllListeners();
            musicBtn.onClick.Add(OpenMusicPanel);
            MusicSlider.onValueChanged.RemoveAllListeners();
            MusicSlider.onValueChanged.Add(OnMusicValueChanged);

            SoundSlider.onValueChanged.RemoveAllListeners();
            SoundSlider.onValueChanged.Add(OnSoundValueChanged);
        }

        private void Init()
        {
            if (GameLocalMode.Instance.SCPlayerInfo.SzPhoneNumber == "")
            {
                logonType.text = "游客登录";
                nowSta.text = GameLocalMode.Instance.IsSetLoginValidation ? $"已开启验证登录" : $"未开启验证登录";
                PWInfo.gameObject.SetActive(false);
                phoneInfo.gameObject.SetActive(false);
                phoneInfo.transform.localPosition = PWInfo.localPosition;
            }
            else
            {
                logonType.text = "账号登录";
                nowSta.text = GameLocalMode.Instance.IsSetLoginValidation ? $"已开启验证登录" : $"未开启验证登录";
                PWInfo.gameObject.SetActive(false);
                phoneInfo.gameObject.SetActive(false);
            }

            accInfoName.text = GameLocalMode.Instance.SCPlayerInfo.NickName;
        }

        private void ChangeAccOnClick()
        {
            DebugHelper.Log($"切换账号");
            ILMusicManager.Instance.PlayBtnSound();
            GameLocalMode.Instance.AllSCUserProp.Clear();
            UIManager.Instance.CloseAllUI();

            var buffer = new ByteBuffer();
            buffer.WriteUInt16(0);
            HotfixGameComponent.Instance.Send(DataStruct.LoginStruct.MDM_3D_LOGIN,
                DataStruct.LoginStruct.SUB_3D_CS_LOGOUT, buffer, SocketType.Hall);
            HotfixGameComponent.Instance.CloseNetwork(SocketType.Hall);
            GameLocalMode.Instance.AccountList.isAuto = false;
            GameLocalMode.Instance.SaveAccount();
            System.GC.Collect();
            UIManager.Instance.OpenUI<LogonScenPanel>();
        }

        private void BDPhonePanel()
        {
            ILMusicManager.Instance.PlayBtnSound();
            UIManager.Instance.ReplaceUI<BindPanel>();
        }

        private void SafeBtnOnClick()
        {
            ILMusicManager.Instance.PlayBtnSound();
            if (string.IsNullOrWhiteSpace(GameLocalMode.Instance.SCPlayerInfo.SzPhoneNumber))
            {
                UIManager.Instance.OpenUI<BindPanel>();
                return;
            }
            UIManager.Instance.ReplaceUI<ChangePassWordPanel>();
        }

        private void OpenMusicPanel()
        {
            ILMusicManager.Instance.PlayBtnSound();
            UIManager.Instance.ReplaceUI<MusicPanel>();
        }

        private void CloseSetPanel(Transform args = null)
        {
            ILMusicManager.Instance.PlayBtnSound();
            UIManager.Instance.Close();
        }

        private void ExitGameCall()
        {
            ILMusicManager.Instance.PlayBtnSound();
            ToolHelper.PopBigWindow(new BigMessage
            {
                content = "Whether to quit the game?",
                okCall = () => { Application.Quit(); }
            });
        }

        private void OnMusicValueChanged(float value)
        {
            ILMusicManager.Instance.SetMusicValue(value);
        }

        private void OnSoundValueChanged(float value)
        {
            ILMusicManager.Instance.SetSoundValue(value);
        }
    }
}