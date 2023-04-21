using System;
using System.Collections;
using LitJson;
using LuaFramework;
using System.Collections.Generic;
using System.Threading.Tasks;
using DG.Tweening;
using Spine.Unity;
using SRDebugger;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall
{
    public class LogonScenPanel : PanelBase
    {
        private Transform LoginGroup;
        private Button LoginBtn;
        private Button GuestBtn;

        private Transform LoginBg;
        private Transform FindPwdBg;
        private Transform RegisterBg;

        List<IState> states;
        HierarchicalStateMachine hsm;
        private SkeletonGraphic anim;

        public LogonScenPanel() : base(UIType.Bottom, nameof(LogonScenPanel))
        {
        }

        public override void Create(params object[] args)
        {
            base.Create(args);
            var startSence = GameObject.FindGameObjectWithTag(LaunchTag._01StartTag);
            if (startSence != null) HallExtend.Destroy(startSence);
            GameLocalMode.Instance.GetAccount();
            hsm = new HierarchicalStateMachine(false, gameObject);
            states = new List<IState>();
            states.Add(new IdleState(this, hsm));
            states.Add(new GetHttpConfigerState(this, hsm));
            states.Add(new CheckAutoLogin(this, hsm));
            states.Add(new LoginState(this, hsm));
            states.Add(new ResigterState(this, hsm));
            states.Add(new FindPasswordState(this, hsm));
            hsm?.Init(states, nameof(GetHttpConfigerState));
        }

        protected override void FindComponent()
        {
            base.FindComponent();
            LoginGroup = transform.FindChildDepth("LoginGroup");
            LoginBtn = LoginGroup.FindChildDepth<Button>("LoginBtn"); //账号登录
            GuestBtn = LoginGroup.FindChildDepth<Button>("GuestBtn"); //游客登录

            LoginBg = transform.FindChildDepth("LoginBg");
            RegisterBg = transform.FindChildDepth("RegisterBg");
            FindPwdBg = transform.FindChildDepth("FindPwdBg");
            anim = transform.FindChildDepth<SkeletonGraphic>($"tilet_1/Anim");
            anim.transform.localScale = Vector3.zero;
            anim.transform.DOScale(1, 0.5f).SetEase(Ease.OutBack);
        }

        protected override void AddEvent()
        {
            base.AddEvent();
            HallEvent.OnShowCodeLogin += HallEventOnOnShowCodeLogin;
        }

        protected override void RemoveEvent()
        {
            base.RemoveEvent();
            HallEvent.OnShowCodeLogin -= HallEventOnOnShowCodeLogin;
        }

        protected override void Update()
        {
            base.Update();
            hsm?.Update();
        }

        protected override void AddListener()
        {
            base.AddListener();
            LoginBtn.onClick.RemoveAllListeners();
            LoginBtn.onClick.Add(ClickLoginCall);

            GuestBtn.onClick.RemoveAllListeners();
            GuestBtn.onClick.Add(ClickGuestCall);
        }

        /// <summary>
        ///     游客登录
        /// </summary>
        private void ClickGuestCall()
        {
            try
            {
                if (GameLocalMode.Instance.GWData.IsForbidEmulator && Util.IsEmulator())
                {
                    ToolHelper.PopBigWindow(new BigMessage()
                        {content = "Please change your device to log in to the game！"});
                    return;
                }
            }
            catch (Exception e)
            {
                DebugHelper.LogError($"{e.Message}");
            }

            if (GameLocalMode.Instance.M_HttpData == null)
            {
                ToolHelper.PopBigWindow(new BigMessage()
                {
                    content = "Please restart the game to get the login configuration！",
                    okCall = () => { Application.Quit(0); },
                    cancelCall = () => { Application.Quit(0); }
                });
                return;
            }

            GameLocalMode.Instance.IsResigter = false;
            HotfixGameComponent.Instance.ConnectHallServer(isSuccess =>
            {
                if (!isSuccess)
                {
                    ToolHelper.PopSmallWindow($"Network connection failure");
                    return;
                }

                ToolHelper.ShowWaitPanel(true, $"Logging in……");
                ILGameManager.Instance.SendLoginMasseage(GameLocalMode.Instance.Account);
            });
        }

        /// <summary>
        ///     点击登录
        /// </summary>
        private void ClickLoginCall()
        {
            if (GameLocalMode.Instance.M_HttpData == null)
            {
                ToolHelper.PopBigWindow(new BigMessage()
                {
                    content = "Please restart the game to obtain the login configuration！",
                    okCall = () => { Application.Quit(0); },
                    cancelCall = () => { Application.Quit(0); }
                });
                return;
            }

            hsm?.ChangeState(nameof(LoginState));
        }


        private void HallEventOnOnShowCodeLogin()
        {
            UIManager.Instance.OpenUI<CodeLoginPanel>();
        }

        /// <summary>
        /// 闲置状态
        /// </summary>
        private class IdleState : State<LogonScenPanel>
        {
            public IdleState(LogonScenPanel owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                owner.LoginGroup.gameObject.SetActive(true);
                owner.LoginBg.gameObject.SetActive(false);
                owner.RegisterBg.gameObject.SetActive(false);
                owner.FindPwdBg.gameObject.SetActive(false);
            }
        }

        /// <summary>
        /// 自动登录
        /// </summary>
        private class CheckAutoLogin : State<LogonScenPanel>
        {
            public CheckAutoLogin(LogonScenPanel owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            bool _isComplete;

            public override void OnEnter()
            {
                base.OnEnter();
                _isComplete = false;
            }

            public override void Update()
            {
                base.Update();
                if (_isComplete) return;
                _isComplete = true;
                try
                {
                    if (GameLocalMode.Instance.GWData.IsForbidEmulator && Util.IsEmulator())
                    {
                        ToolHelper.PopBigWindow(new BigMessage()
                            {content = "Please change your device to log in to the game！"});
                        GameLocalMode.Instance.AccountList.isAuto = false;
                        ToolHelper.ShowWaitPanel(false);
                        hsm.ChangeState(nameof(IdleState));
                        return;
                    }
                }
                catch (System.Exception e)
                {
                    DebugHelper.LogError($"{e.Message}");
                }

                if (!GameLocalMode.Instance.AccountList.isAuto ||
                    GameLocalMode.Instance.AccountList.LoginType == 0) //普通登录
                {
                    GameLocalMode.Instance.AccountList.isAuto = false;
                    ToolHelper.ShowWaitPanel(false);
                    hsm.ChangeState(nameof(IdleState));
                    return;
                }

                GameLocalMode.Instance.IsResigter = false;
                //开始自动登录
                HotfixGameComponent.Instance.ConnectHallServer(isSuccess =>
                {
                    if (!isSuccess)
                    {
                        hsm?.ChangeState(nameof(IdleState));
                        return;
                    }

                    ToolHelper.ShowWaitPanel(true, $"Logging in……");
                    ILGameManager.Instance.SendLoginMasseage(GameLocalMode.Instance.Account);
                });
            }
        }

        /// <summary>
        /// 获取网络配置状态
        /// </summary>
        private class GetHttpConfigerState : State<LogonScenPanel>
        {
            public GetHttpConfigerState(LogonScenPanel owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            private int reqIPIndex = 0;
            private int reqLoginCount = 0;
            private int reqLoginIndex = 0;

            public override void OnEnter()
            {
                base.OnEnter();
                reqLoginIndex = 0;
                reqLoginCount = 0;
                // ToolHelper.ShowWaitPanel(true, $"获取基础配置中，请稍后…");
                GetHttpConfiger();
            }

            /// <summary>
            /// 请求httpConfiger
            /// </summary>
            private void GetHttpConfiger()
            {
                ToolHelper.ShowWaitPanel(true, $"");
                DebugHelper.Log($"获取httpconfiger");
                FormData form = new FormData();
                form.AddField("time", System.DateTime.Now.ToString("yyyyMMddHHmmSS"));
                string url = $"{AppConst.DNSUrl}/HttpConfiger.json";
                HttpManager.Instance.GetText(url, form, (isSuccess, result) =>
                {
                    ToolHelper.ShowWaitPanel(false, $"");
                    if (!isSuccess)
                    {
                        GetHttpConfiger();
                        return;
                    }

                    string msg = MD5Helper.Decrypt(result, "Http");
                    GameLocalMode.Instance.GWData = JsonMapper.ToObject<HttpDataConfiger>(msg);
                    SRDebug.Instance.IsTriggerEnabled = GameLocalMode.Instance.GWData.ShowDebug;
                    if (!GameLocalMode.Instance.GWData.ShowDebug) SRDebug.Instance.HideDebugPanel();
                    GameLocalMode.Instance.PlatformID = GameLocalMode.Instance.GWData.platformId;
                    DebugHelper.IsDebug = GameLocalMode.Instance.GWData.ShowDebug;
                    GameLocalMode.HttpURL = GameLocalMode.Instance.GWData.HttpUrl;
                    SRDebug.Instance.Settings.ProfilerAlignment = PinAlignment.TopCenter;
                    UnityEngine.Debug.unityLogger.logEnabled = GameLocalMode.Instance.GWData.ShowDebug;
                    DebugHelper.LogError(msg);
                    reqIPIndex = 0;
                    GetPlatformConfig();
                    // GetSDKConfiger();
                });
            }

            private void GetPlatformConfig()
            {
                FormData form = new FormData();
                form.AddField("cid", $"{GameLocalMode.Instance.PlatformID}");
                HttpManager.Instance.PostText($"{GameLocalMode.HttpURL}info/clientConf", form, (isSuccess, result) =>
                {
                    if (!isSuccess)
                    {
                        GetPlatformConfig();
                        return;
                    }

                    DebugHelper.LogError($"config:{result}");
                    JsonData data = JsonMapper.ToObject(result);
                    if (data["code"].ToString() != "0")
                    {
                        DebugHelper.LogError($"{data["message"]}");
                        ToolHelper.PopSmallWindow("Get platfom config error");
                        return;
                    }

                    int.TryParse(data["data"]["ratio"].ToJson(), out var ratio);
                    GameLocalMode.Instance.MoneyRate = ratio <= 0 ? GameLocalMode.Instance.GWData.MoneyRate : ratio;
                    GetSDKConfiger();
                });
            }

            /// <summary>
            /// 请求httpConfiger
            /// </summary>
            private void GetSDKConfiger()
            {
                DebugHelper.Log($"获取sdkkey");
                FormData form = new FormData();
                form.AddField("time", System.DateTime.Now.ToString("yyyyMMddHHmmSS"));
                string url = AppConst.WebUrl.Replace("/android", "");
                url = url.Replace("/ios", "");
                url = url.Replace("/iOS", "");
                url = url.Replace("/win", "");
                HttpManager.Instance.GetText($"{url}SDKKey.json", form, (isSuccess, result) =>
                {
                    if (!isSuccess)
                    {
                        ReqIP();
                        return;
                    }

                    ReqIP();
                    if (GameLocalMode.Instance.GWData.isUseDefence) InitSDK(result);
                });
            }

            private void InitSDK(string sdkStr)
            {
                if (Defence.Defence.IsInit) return;
                var init = Defence.Defence.InitDefenceSDK(sdkStr, out string sysName);
                DebugHelper.LogError($"sysName:{sysName},init:{init}");
            }

            /// <summary>
            /// 请求IP
            /// </summary>
            private void ReqIP()
            {
                // ToolHelper.ShowWaitPanel(true, $"获取其他配置中，请稍后…");
                ToolHelper.ShowWaitPanel(true, $"");
                DebugHelper.Log($"获取IP");
                FormData form = new FormData();
                form.AddField("time", System.DateTime.Now.ToString("yyyyMMddHHmmSS"));
                HttpManager.Instance.GetText(GameLocalMode.Instance.GWData.IPUrls[reqIPIndex], form, (isSuccess, msg) =>
                {
                    ToolHelper.ShowWaitPanel(false, $"");
                    if (!isSuccess)
                    {
                        reqIPIndex++;
                        if (reqIPIndex >= GameLocalMode.Instance.GWData.IPUrls.Count) reqIPIndex = 0;
                        ReqIP();
                        return;
                    }

                    DebugHelper.Log($"msg:{msg}");
                    string ip = ToolHelper.GetIPFromHtml(msg);
                    if (ip == null)
                    {
                        reqIPIndex++;
                        if (reqIPIndex >= GameLocalMode.Instance.GWData.IPUrls.Count) reqIPIndex = 0;
                        ReqIP();
                        return;
                    }

                    GameLocalMode.Instance.IP = ip;
                    DebugHelper.Log($"IP:{GameLocalMode.Instance.IP}");
                    reqLoginIndex = 0;
                    reqLoginCount = 0;
                    UpdateAllGameConfig();
                    // GameLocalMode.Instance.HallPort = $"{28101}";
                    // hsm?.ChangeState(nameof(CheckAutoLogin));
                });
            }

            private async void UpdateAllGameConfig()
            {
                await ILGameManager.Instance.UpdateAllGameConfig();
                ReqLoginConfig();
            }

            private void ReqLoginConfig()
            {
                DebugHelper.Log($"获取loginConfig");
                FormData form = new FormData();
                form.AddField("clientkey", "107");
                form.AddField("account", GameLocalMode.Instance.Account.account);
                form.AddField("clientID", "0");
                form.AddField("sendIp", "192.168.1.1");
                form.AddField("machine", "37342d44342d33352d44362d30442d39");
                form.AddField("param", $"{GameLocalMode.Instance.PlatformID}");
                form.AddField("md5", "a9e4553ae02ff86d37578525aae3f163");
                GameLocalMode.Instance.M_HttpData = null;
                List<string> urls = (Util.isEditor || Util.isPc)
                    ? GameLocalMode.Instance.GWData.PCUrls
                    : GameLocalMode.Instance.GWData.Urls;

                ToolHelper.ShowWaitPanel(true);
                HttpManager.Instance.GetText(
                    $"http://{urls[reqLoginIndex]}/LoginIpHandler.ashx", form,
                    // $"http://192.168.0.108:8081/LoginIpHandler.ashx", form,
                    (isSuccess, msg) =>
                    {
                        ToolHelper.ShowWaitPanel(false);
                        DebugHelper.Log(msg);
                        if (!isSuccess)
                        {
                            reqLoginIndex++;
                            reqLoginCount++;
                            if (reqLoginCount >= 10)
                            {
                                ToolHelper.PopBigWindow(new BigMessage()
                                {
                                    content = "Unable to finish loading, please try again later",
                                    okCall = () =>
                                    {
                                        reqLoginIndex = 0;
                                        reqLoginCount = 0;
                                        ReqLoginConfig();
                                    }
                                });
                                return;
                            }

                            if (reqLoginIndex >= urls.Count) reqLoginIndex = 0;
                            ReqLoginConfig();
                            return;
                        }

                        GameLocalMode.Instance.M_HttpData = JsonMapper.ToObject<HttpData>(msg);
                        GameLocalMode.Instance.HallHost = GameLocalMode.Instance.M_HttpData.login_ip;
                        if (GameLocalMode.Instance.GWData.isUseLoginIP)
                        {
                            if (GameLocalMode.Instance.GWData.isUseDefence)
                            {
                                GameLocalMode.Instance.HallHost = Util.isPc || Util.isEditor
                                    ? GameLocalMode.Instance.GWData.DefencePCLoginIP
                                    : GameLocalMode.Instance.GWData.DefenceLoginIP;
                            }
                            else
                            {
                                GameLocalMode.Instance.HallHost = Util.isPc || Util.isEditor
                                    ? GameLocalMode.Instance.GWData.PCLoginIP
                                    : GameLocalMode.Instance.GWData.LoginIP;
                            }
                        }
                        else
                        {
                            if (GameLocalMode.Instance.GWData.isUseDefence)
                            {
                                GameLocalMode.Instance.HallHost = Util.isPc || Util.isEditor
                                    ? GameLocalMode.Instance.GWData.DefencePCLoginIP
                                    : GameLocalMode.Instance.GWData.DefenceLoginIP;
                            }
                        }

                        GameLocalMode.Instance.HallPort = GameLocalMode.Instance.M_HttpData.login_port;
                        GameLocalMode.Instance.HallHost = GameLocalMode.Instance.GWData.isUseLoginIP
                            ? GameLocalMode.Instance.GWData.LoginIP
                            : GameLocalMode.Instance.M_HttpData.login_ip;
                        // GameLocalMode.Instance.HallPort = $"{31007}";
                        hsm?.ChangeState(CheckVersion() ? nameof(CheckAutoLogin) : nameof(IdleState));
                    });
            }

            /// <summary>
            /// 检查版本
            /// </summary>
            /// <returns></returns>
            private bool CheckVersion()
            {
                double.TryParse(Application.version, out double version);
                if (version >= GameLocalMode.Instance.GWData.version) return true;

                void OpenUrl()
                {
                    if (Util.isPc || Util.isEditor)
                    {
                        Application.OpenURL(GameLocalMode.Instance.GWData.PCUrl);
                    }
                    else if (Util.isAndroidPlatform)
                    {
                        Application.OpenURL(GameLocalMode.Instance.GWData.AndroidUrl);
                    }
                    else if (Util.isApplePlatform)
                    {
                        Application.OpenURL(GameLocalMode.Instance.GWData.iOSUrl);
                    }

                    Util.Quit();
                }

                ToolHelper.PopBigWindow(new BigMessage()
                {
                    content = "Please download the latest version of the game！",
                    okCall = OpenUrl,
                    cancelCall = OpenUrl
                });
                return false;
            }
        }

        #region 登录

        /// <summary>
        /// 登录状态
        /// </summary>
        private class LoginState : State<LogonScenPanel>
        {
            private InputField LoginIDInput;
            private InputField LoginPassword;
            private Button LoginSureBtn;
            private Button LoginFindPwdBtn;
            private Button LoginRegistBtn;
            public Button LoginCloseBtn;

            private bool isInit;
            private Transform mainPanel;

            public LoginState(LogonScenPanel owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                Init();
                owner.LoginGroup.gameObject.SetActive(false);
                if (GameLocalMode.Instance.Account == null || GameLocalMode.Instance.Account.LoginType != 2)
                {
                    LoginIDInput.text = "";
                    LoginPassword.text = "";
                }
                else
                {
                    LoginIDInput.text = GameLocalMode.Instance.Account.account;
                    LoginPassword.text = GameLocalMode.Instance.Account.account == ""
                        ? ""
                        : $"{GameLocalMode.Instance.Account.account}md5";
                }

                owner.LoginBg.gameObject.SetActive(true);
            }

            public override void OnExit()
            {
                base.OnExit();
                owner.LoginBg.gameObject.SetActive(false);
            }

            private void Init()
            {
                if (isInit) return;
                mainPanel = owner.LoginBg.FindChildDepth("MainPanel");
                LoginCloseBtn = mainPanel.FindChildDepth<Button>("CloseBtn"); //关闭登录
                LoginIDInput = mainPanel.FindChildDepth<InputField>("ID/InputField"); //ID输入
                LoginPassword = mainPanel.FindChildDepth<InputField>("Password/InputField"); //密码输入
                LoginSureBtn = mainPanel.FindChildDepth<Button>("LoginSureBtn"); //确认登录
                LoginFindPwdBtn = mainPanel.FindChildDepth<Button>("FindPwdBtn"); //找回密码
                LoginRegistBtn = mainPanel.FindChildDepth<Button>("RegistBtn"); //注册
                LoginSureBtn.onClick.RemoveAllListeners();
                LoginSureBtn.onClick.Add(LogonBtnOnClick);

                LoginFindPwdBtn.onClick.RemoveAllListeners();
                LoginFindPwdBtn.onClick.Add(FindPwdBtnOnClick);

                LoginRegistBtn.onClick.RemoveAllListeners();
                LoginRegistBtn.onClick.Add(RegisterBtnOnClick);

                LoginCloseBtn.onClick.RemoveAllListeners();
                LoginCloseBtn.onClick.Add(ClickLoginBgClose);
                isInit = true;
            }

            /// <summary>
            ///     点击关闭登录
            /// </summary>
            private void ClickLoginBgClose()
            {
                hsm?.ChangeState(nameof(IdleState));
            }

            /// <summary>
            ///     点击登录
            /// </summary>
            private void LogonBtnOnClick()
            {
                GameLocalMode.Instance.IsResigter = false;
                try
                {
                    if (GameLocalMode.Instance.GWData.IsForbidEmulator && Util.IsEmulator())
                    {
                        ToolHelper.PopBigWindow(new BigMessage()
                            {content = "Please change your device to log in to the game！"});
                        return;
                    }
                }
                catch (Exception e)
                {
                    DebugHelper.LogError($"{e.Message}");
                }

                if (string.IsNullOrWhiteSpace(LoginIDInput.text))
                {
                    ToolHelper.PopSmallWindow("The account or password is incorrect");
                    return;
                }

                if (string.IsNullOrWhiteSpace(LoginPassword.text))
                {
                    ToolHelper.PopSmallWindow("The account or password is incorrect");
                    return;
                }

                LoginSureBtn.interactable = false;
                var account = new AccountMSG();
                if (string.IsNullOrWhiteSpace(GameLocalMode.Instance.Account.account))
                {
                    //    account = new AccountMSG();
                    account.account = LoginIDInput.text;
                    account.password = MD5Helper.MD5String(LoginPassword.text);
                }
                else
                {
                    account = GameLocalMode.Instance.Account;
                    if (account.account != LoginIDInput.text)
                    {
                        account = new AccountMSG();
                        account.account = LoginIDInput.text;
                        account.password = MD5Helper.MD5String(LoginPassword.text);
                    }

                    if (!$"{LoginIDInput.text}md5".Equals(LoginPassword.text) &&
                        account.password != MD5Helper.MD5String(LoginPassword.text))
                    {
                        account.password = MD5Helper.MD5String(LoginPassword.text);
                    }
                }

                HotfixGameComponent.Instance.ConnectHallServer(isSuccess =>
                {
                    if (LoginSureBtn != null) LoginSureBtn.interactable = true;
                    if (!isSuccess)
                    {
                        ToolHelper.PopSmallWindow($"Network connection failure");
                        return;
                    }

                    ToolHelper.ShowWaitPanel(true, $"Logging in……");
                    ILGameManager.Instance.SendLoginMasseage(account);
                });
            }

            /// <summary>
            ///     找回密码事件
            /// </summary>
            private void FindPwdBtnOnClick()
            {
                hsm?.ChangeState(nameof(FindPasswordState));
            }

            /// <summary>
            ///     注册界面
            /// </summary>
            private void RegisterBtnOnClick()
            {
                hsm?.ChangeState(nameof(ResigterState));
            }
        }

        #endregion

        #region 注册

        /// <summary>
        /// 注册状态
        /// </summary>
        private class ResigterState : State<LogonScenPanel>
        {
            public ResigterState(LogonScenPanel owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            private bool isInit;
            private Button RegisterCloseBtn;
            private InputField RegisterCodeInput;

            private Button RegisterGetCodeBtn;

            // private Transform codeImg;
            private TextMeshProUGUI codeTimeTxt;

            private InputField RegisterIDInput;
            private InputField RegisterMobileNumInput;
            private InputField RegisterPassword2Input;
            private InputField RegisterPasswordInput;

            private InputField RegisterInvitationInput;
            private Button RegisterSureBtn;
            private int codeAllTime = 60;
            private float timer;
            private bool isStart;
            private Transform timeUnderLine;
            private Transform mainPanel;

            public override void OnEnter()
            {
                base.OnEnter();
                Init();
                owner.LoginGroup.gameObject.SetActive(false);
                RegisterIDInput.text = "";
                RegisterMobileNumInput.text = "";
                RegisterPasswordInput.text = "";
                RegisterPassword2Input.text = "";
                RegisterCodeInput.text = "";
                RegisterInvitationInput.text = "";
                HallEvent.LogonRegisterCallBack += RegisterS2CCallBack;
                HallEvent.LogonCodeCallBack += GetCodeBtnCallBack;
                owner.RegisterBg.gameObject.SetActive(true);
                isStart = false;
                CountDownComplete();
            }

            public override void OnExit()
            {
                base.OnExit();
                HallEvent.LogonRegisterCallBack -= RegisterS2CCallBack;
                HallEvent.LogonCodeCallBack -= GetCodeBtnCallBack;
                owner.RegisterBg.gameObject.SetActive(false);
            }

            public override void Update()
            {
                base.Update();
                StartCodeTimer();
            }

            /// <summary>
            /// 获取验证码倒计时
            /// </summary>
            private void StartCodeTimer()
            {
                if (!isStart) return;
                timer -= Time.deltaTime;
                RegisterText(timer);
                if (timer > 0) return;
                isStart = false;
                CountDownComplete();
            }

            private void Init()
            {
                if (isInit) return;
                mainPanel = owner.RegisterBg.FindChildDepth("MainPanel");
                RegisterCloseBtn = mainPanel.FindChildDepth<Button>("CloseBtn"); //关闭注册
                RegisterIDInput = mainPanel.FindChildDepth<InputField>("ID/InputField"); //ID输入
                RegisterMobileNumInput = mainPanel.FindChildDepth<InputField>("MobileNum/InputField"); //号码输入
                RegisterPasswordInput = mainPanel.FindChildDepth<InputField>("Password/InputField"); //密码输入
                RegisterPassword2Input = mainPanel.FindChildDepth<InputField>("Password2/InputField"); //确认密码
                RegisterCodeInput = mainPanel.FindChildDepth<InputField>("Code/InputField"); //验证码
                RegisterGetCodeBtn = mainPanel.FindChildDepth<Button>("GetCodeBtn"); //获取验证码
                RegisterSureBtn = mainPanel.FindChildDepth<Button>("RegistBtn"); //确认
                RegisterInvitationInput = mainPanel.FindChildDepth<InputField>("InviteCode/InputField"); //邀请码
                // codeImg = RegisterGetCodeBtn.transform.FindChildDepth("Image");
                codeTimeTxt = RegisterGetCodeBtn.transform.FindChildDepth<TextMeshProUGUI>($"BtnShow");
                timeUnderLine = RegisterGetCodeBtn.transform.FindChildDepth($"Image");
                RegisterGetCodeBtn.transform.FindChildDepth($"Time").gameObject.SetActive(false);
                RegisterSureBtn.onClick.RemoveAllListeners();
                RegisterSureBtn.onClick.Add(() => { RegisterSureBtnOnClick(RegisterSureBtn); });

                RegisterCloseBtn.onClick.RemoveAllListeners();
                RegisterCloseBtn.onClick.Add(RegisterCloseBtnOnClick);

                RegisterGetCodeBtn.onClick.RemoveAllListeners();
                RegisterGetCodeBtn.onClick.Add(() => { RegisterGetCodeBtnOnClick(RegisterGetCodeBtn); });
                isInit = true;
            }

            /// <summary>
            ///     确认注册
            /// </summary>
            private void RegisterSureBtnOnClick(Button args)
            {
                GameLocalMode.Instance.IsResigter = true;
                try
                {
                    if (GameLocalMode.Instance.GWData.IsForbidEmulator && Util.IsEmulator())
                    {
                        ToolHelper.PopBigWindow(new BigMessage()
                            {content = "Please change your device to log in to the game！"});
                        return;
                    }
                }
                catch (Exception e)
                {
                    DebugHelper.LogError($"{e.Message}");
                }

                string IDInput = RegisterIDInput.text;
                string MobileNumInput = RegisterMobileNumInput.text;
                string PasswordInput = RegisterPasswordInput.text;
                string RePasswordInput = RegisterPassword2Input.text;
                string CodeInput = RegisterCodeInput.text;
                string invitation = RegisterInvitationInput.text;
                DebugHelper.Log("MobileNumInput:" + MobileNumInput.Length);
                var msg = ToolHelper.CheckIsFLBPhoneNumber(MobileNumInput);
                if (!string.IsNullOrEmpty(msg))
                {
                    ToolHelper.PopSmallWindow(msg);
                    return;
                }

                if (PasswordInput.Length < 6 || PasswordInput.Length > 12)
                {
                    ToolHelper.PopSmallWindow("Incorrect password format");
                    return;
                }

                if (RePasswordInput != PasswordInput)
                {
                    ToolHelper.PopSmallWindow("Inconsistent passwords");
                    return;
                }

                if (CodeInput.Length < 4 || CodeInput.Length > 8)
                {
                    ToolHelper.PopSmallWindow("Code input error");
                    return;
                }

                args.interactable = false;
                HallStruct.REQ_CS_Register register = new HallStruct.REQ_CS_Register();
                register.platform = GameLocalMode.Instance.Platform;
                register.channelID = GameLocalMode.Instance.GameQuDao;
                register.iD = GameLocalMode.Instance.PlatformID;
                register.addMultiplyID =
                    (uint) (GameLocalMode.Instance.PlatformID * GameLocalMode.Instance.ResigterPlatMultiply +
                            GameLocalMode.Instance.ResigterPlatAdd);
                register.multiplyID =
                    (ushort) (GameLocalMode.Instance.PlatformID * GameLocalMode.Instance.ResigterPlatMultiply);
                register.addID = (byte) (GameLocalMode.Instance.PlatformID * GameLocalMode.Instance.ResigterPlatAdd);
                register.account = IDInput;
                register.password = MD5Helper.MD5String(PasswordInput);
                register.mechinaCode = GameLocalMode.Instance.MechinaCode;
                register.phoneNum = MobileNumInput;
                register.phoneCode = uint.Parse(CodeInput);
                register.iP = GameLocalMode.Instance.IP;
                register.nIsDrain = (byte) (GameLocalMode.Instance.CheckUserIsNature() ? 0 : 1);
                register.inviteCode = invitation;
                DebugHelper.Log(JsonMapper.ToJson(register));
                HotfixGameComponent.Instance.ConnectHallServer(isSuccess =>
                {
                    if (args != null) args.interactable = true;
                    if (!isSuccess) return;
                    HotfixGameComponent.Instance.Send(DataStruct.PersonalStruct.MDM_3D_PERSONAL_INFO,
                        DataStruct.LoginStruct.SUB_3D_CS_REGISTER, register.ByteBuffer, SocketType.Hall);
                });
            }

            /// <summary>
            ///     注册回调
            /// </summary>
            private void RegisterS2CCallBack(HallStruct.ACP_SC_LOGIN_REGISTER registerInfo)
            {
                ToolHelper.ShowWaitPanel(false);
                if (registerInfo.Length > 0)
                {
                    ToolHelper.PopSmallWindow(registerInfo.Error);
                }
                else
                {
                    ToolHelper.PopSmallWindow("Successful registration");
                    RegisterCloseBtnOnClick();
                }

                RegisterSureBtn.interactable = true;
            }

            /// <summary>
            ///     关闭注册
            /// </summary>
            private void RegisterCloseBtnOnClick()
            {
                hsm?.ChangeState(nameof(IdleState));
            }

            /// <summary>
            ///     获取注册验证码
            /// </summary>
            private void RegisterGetCodeBtnOnClick(Button args)
            {
                timeUnderLine.gameObject.SetActive(false);
                var phonenum = RegisterMobileNumInput.text;
                var msg = ToolHelper.CheckIsFLBPhoneNumber(phonenum);
                if (!string.IsNullOrEmpty(msg))
                {
                    ToolHelper.PopSmallWindow(msg);
                    codeTimeTxt.text = "get code";
                    timeUnderLine.gameObject.SetActive(true);
                    return;
                }

                args.interactable = false;

                string countryPhone = $"63{phonenum}";
                HotfixGameComponent.Instance.ConnectHallServer(isSuccess =>
                {
                    if (!isSuccess) return;
                    var Code = new HallStruct.REQ_CS_CODE_RegisterS(1, 1, 1, countryPhone);
                    HotfixGameComponent.Instance.Send(DataStruct.LoginStruct.MDM_3D_LOGIN, 29, Code._ByteBuffer,
                        SocketType.Hall);
                });
                timer = codeAllTime;
                // codeImg.gameObject.SetActive(false);
                RegisterText(timer);
                // codeTimeTxt.gameObject.SetActive(true);
                isStart = true;
            }

            /// <summary>
            ///     注册验证码返回
            /// </summary>
            /// <param name="num"></param>
            private void GetCodeBtnCallBack(uint num)
            {
                DebugHelper.Log("------注册验证码返回--------------");
                var str = num.ToString();
                HotfixGameComponent.Instance.CloseNetwork(SocketType.Hall);
                ToolHelper.ShowWaitPanel(false);
                if (str == "0") ToolHelper.PopSmallWindow("phone number is bound");
            }

            /// <summary>
            ///     注册时间
            /// </summary>
            /// <param name="num"></param>
            private void RegisterText(float num)
            {
                codeTimeTxt.text = $"{Mathf.Ceil(num)}s again";
            }

            private void CountDownComplete()
            {
                codeTimeTxt.text = "get code";
                timeUnderLine.gameObject.SetActive(true);
                // codeTimeTxt.gameObject.SetActive(false);
                // codeImg.gameObject.SetActive(true);
                RegisterGetCodeBtn.interactable = true;
            }
        }

        #endregion

        #region 找回密码

        /// <summary>
        /// 找回密码状态
        /// </summary>
        private class FindPasswordState : State<LogonScenPanel>
        {
            public FindPasswordState(LogonScenPanel owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            private bool isInit;

            private InputField FindPwdCodeInput;
            private Button FindPwdGetCodeBtn;
            private InputField FindPwdMobileNumInput;
            private InputField FindPwdPassword2Input;
            private InputField FindPwdPasswordInput;
            private Button FindPwdSureBtn;
            private Button FindPwdBackBtn;

            // private Transform findBtnImg;
            private int codeAllTime = 60;

            private float timer;
            private bool isStart;
            private Transform mainPanel;
            private TextMeshProUGUI codeTimeTxt;
            private Transform timeUnderLine;

            public override void OnEnter()
            {
                base.OnEnter();
                Init();
                owner.LoginGroup.gameObject.SetActive(false);
                FindPwdMobileNumInput.text = "";
                FindPwdPasswordInput.text = "";
                FindPwdPassword2Input.text = "";
                FindPwdCodeInput.text = "";
                owner.FindPwdBg.gameObject.SetActive(true);
                HallEvent.LogonFindPWCallBack += UpdatePwdSuccess;
                HallEvent.LogonFindPW_GetCode += UpdatePwdCodeSC;
                isStart = false;
                CountDownComplete();
            }

            public override void OnExit()
            {
                base.OnExit();
                HallEvent.LogonFindPWCallBack -= UpdatePwdSuccess;
                HallEvent.LogonFindPW_GetCode -= UpdatePwdCodeSC;
                owner.FindPwdBg.gameObject.SetActive(false);
            }

            public override void Update()
            {
                base.Update();
                StartCodeTimer();
            }

            private void Init()
            {
                if (isInit) return;
                mainPanel = owner.FindPwdBg.FindChildDepth("MainPanel");
                FindPwdBackBtn = mainPanel.FindChildDepth<Button>("CloseBtn"); //关闭
                FindPwdMobileNumInput = mainPanel.FindChildDepth<InputField>("MobileNum/InputField"); //号码输入
                FindPwdPasswordInput = mainPanel.FindChildDepth<InputField>("Password/InputField"); //密码输入
                FindPwdPassword2Input = mainPanel.FindChildDepth<InputField>("Password2/InputField"); //密码2输入
                FindPwdCodeInput = mainPanel.FindChildDepth<InputField>("Code/InputField"); //验证码输入
                FindPwdGetCodeBtn = mainPanel.FindChildDepth<Button>("GetCodeBtn"); //获取验证码
                FindPwdSureBtn = mainPanel.FindChildDepth<Button>("SureBtn"); //确认

                // findBtnImg = FindPwdGetCodeBtn.transform.FindChildDepth("Image");
                codeTimeTxt = FindPwdGetCodeBtn.transform.FindChildDepth<TextMeshProUGUI>($"BtnShow");
                timeUnderLine = FindPwdGetCodeBtn.transform.FindChildDepth($"Image");
                FindPwdGetCodeBtn.transform.FindChildDepth($"Time").gameObject.SetActive(false);

                FindPwdSureBtn.onClick.RemoveAllListeners();
                FindPwdSureBtn.onClick.Add(() => { FindPwdSureBtnOnClick(FindPwdSureBtn); });

                FindPwdBackBtn.onClick.RemoveAllListeners();
                FindPwdBackBtn.onClick.Add(FindPwdCloseBtnOnClick);

                FindPwdGetCodeBtn.onClick.RemoveAllListeners();
                FindPwdGetCodeBtn.onClick.Add(() => { FindPwdGetCodeBtnOnClick(FindPwdGetCodeBtn); });
                isInit = true;
            }

            /// <summary>
            /// 获取验证码倒计时
            /// </summary>
            private void StartCodeTimer()
            {
                if (!isStart) return;
                timer -= Time.deltaTime;
                FindPWText(timer);
                if (timer > 0) return;
                isStart = false;
                CountDownComplete();
            }

            /// <summary>
            ///     确认修改密码
            /// </summary>
            /// <param name="args"></param>
            private void FindPwdSureBtnOnClick(Button args)
            {
                var iphone = FindPwdMobileNumInput.text;
                var pw = FindPwdPasswordInput.text;
                var pw2 = FindPwdPassword2Input.text;
                var code = FindPwdCodeInput.text;
                var msg = ToolHelper.CheckIsFLBPhoneNumber(iphone);
                if (!string.IsNullOrEmpty(msg))
                {
                    ToolHelper.PopSmallWindow(msg);
                    return;
                }

                if (pw != pw2)
                {
                    ToolHelper.PopSmallWindow("Inconsistent passwords");
                    return;
                }

                if (pw.Length < 6 || pw.Length > 12)
                {
                    ToolHelper.PopSmallWindow("Incorrect password format");
                    return;
                }

                if (code.Length < 4 || code.Length > 8)
                {
                    ToolHelper.PopSmallWindow("The verification code is incorrect");
                    return;
                }

                args.interactable = false;

                HotfixGameComponent.Instance.ConnectHallServer(isSuccess =>
                {
                    if (args != null)
                    {
                        args.interactable = true;
                    }

                    if (!isSuccess) return;

                    HallStruct.REQ_CS_FindPassword findPassword = new HallStruct.REQ_CS_FindPassword();
                    findPassword.phoneNumber = iphone;
                    findPassword.password = MD5Helper.MD5String(pw);
                    findPassword.code = uint.Parse(code);
                    findPassword.platform = GameLocalMode.Instance.PlatformID;
                    HotfixGameComponent.Instance.Send(DataStruct.LoginStruct.MDM_3D_LOGIN, 19, findPassword.ByteBuffer,
                        SocketType.Hall);
                });
            }

            /// <summary>
            ///     修改密码返回
            /// </summary>
            /// <param name="pwInfo"></param>
            private void UpdatePwdSuccess(HallStruct.ACP_SC_LOGIN_FINDPW pwInfo)
            {
                HotfixGameComponent.Instance.CloseNetwork(SocketType.Hall);
                FindPwdSureBtn.interactable = true;
                if (pwInfo == null)
                {
                    GameLocalMode.Instance.Account.account = FindPwdMobileNumInput.text;
                    GameLocalMode.Instance.Account.password = MD5Helper.MD5String(FindPwdPasswordInput.text);
                    GameLocalMode.Instance.Account.LoginType =
                        GameLocalMode.Instance.SCPlayerInfo.SzPhoneNumber == "" ? 1 : 2;
                    GameLocalMode.Instance.SaveAccount();
                    ToolHelper.PopSmallWindow("The reset password is successful, please keep it safe");
                    FindPwdCloseBtnOnClick();
                }
                else
                {
                    ToolHelper.PopSmallWindow(pwInfo.Error);
                }

                ToolHelper.ShowWaitPanel(false);
            }


            /// <summary>
            /// 找回密码验证码返回
            /// </summary>
            /// <param name="code"></param>
            private void UpdatePwdCodeSC(int code)
            {
                HotfixGameComponent.Instance.CloseNetwork(SocketType.Hall);
                ToolHelper.ShowWaitPanel(false);
                if (code <= 0) ToolHelper.PopSmallWindow("Phone number is not registered");
            }

            /// <summary>
            ///     修改密码时间
            /// </summary>
            /// <param name="num"></param>
            private void FindPWText(float num)
            {
                codeTimeTxt.text = $"{Mathf.Ceil(num)}s again";
            }

            /// <summary>
            ///     关闭修改密码
            /// </summary>
            private void FindPwdCloseBtnOnClick()
            {
                hsm?.ChangeState(nameof(LoginState));
            }

            /// <summary>
            ///     获取找回密码验证码
            /// </summary>
            private void FindPwdGetCodeBtnOnClick(Button args)
            {
                timeUnderLine.gameObject.SetActive(false);
                string msg = ToolHelper.CheckIsFLBPhoneNumber(FindPwdMobileNumInput.text);

                if (!string.IsNullOrEmpty(msg))
                {
                    ToolHelper.PopSmallWindow(msg);
                    codeTimeTxt.text = "get code";
                    timeUnderLine.gameObject.SetActive(true);
                    return;
                }

                args.interactable = false;

                string phonenum = $"63{FindPwdMobileNumInput.text}";
                HotfixGameComponent.Instance.ConnectHallServer(isSuccess =>
                {
                    if (!isSuccess) return;
                    var Code = new HallStruct.REQ_CS_FindPasswordCode(phonenum);
                    HotfixGameComponent.Instance.Send(DataStruct.LoginStruct.MDM_3D_LOGIN, 22, Code._ByteBuffer,
                        SocketType.Hall);
                });
                timer = codeAllTime;
                // findBtnImg.gameObject.SetActive(false);
                FindPWText(timer);
                isStart = true;
            }

            private void CountDownComplete()
            {
                codeTimeTxt.text = "get code";
                timeUnderLine.gameObject.SetActive(true);
                // findBtnImg.gameObject.SetActive(true);
                // findBtnTimeTxt.gameObject.SetActive(false);
                FindPwdGetCodeBtn.interactable = true;
            }
        }

        #endregion
    }
}