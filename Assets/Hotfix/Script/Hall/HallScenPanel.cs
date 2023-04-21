using System;
using System.Collections;
using System.Diagnostics;
using DG.Tweening;
using LuaFramework;
using RenderHeads.Media.AVProVideo;
using System.Collections.Generic;
using System.Threading.Tasks;
using com.adjust.sdk;
using Hotfix.Hall.ItemBox;
using Hotfix.RedPoint;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using YooAsset;
using static Hotfix.HallStruct;
using Object = UnityEngine.Object;
using Random = UnityEngine.Random;

namespace Hotfix.Hall
{
    public class HallScenPanel : PanelBase
    {
        private Button headBtn;
        private Image headIcon;
        private TextMeshProUGUI id;
        private Text nickName;
        private TextMeshProUGUI selfGold;
        private TextMeshProUGUI bankGold;
        private Button copyBtn;

        private Button gwBtn;
        private Button taskBtn;
        private Button exchangeBtn;
        private Button bankBtn;
        private Button setBtn;
        private Button shopBtn;
        private Button leaderboardBtn;
        private Button inviteBtn;
        private Button mailBtn;
        private Button noticeBtn;
        private Text version;
        private Transform midNode;

        private HallGameShow showContent;
        private Transform otherGroup;

        private Image backgroundImg;
        private Sprite defaultSprite;
        private Button bindBtn;
        private Button fristPlayBtn;
        private Button wheelBtn;
        private Button activityBtn;
        private Button serviceBtn;
        private RectTransform noticeNode;
        private Slider _noticeSlider;
        private bool duringShow = false;
        private Button ActiveBtn;

        private Button AddGoldBtn;
        private Vector3 preNoticePos;

        public HallScenPanel() : base(UIType.Bottom, nameof(HallScenPanel))
        {
        }

        public override void Create(params object[] args)
        {
            base.Create(args);
            HallStruct.REQQueryLoginVerify queryLoginVerify = new HallStruct.REQQueryLoginVerify();
            HotfixGameComponent.Instance.Send(DataStruct.PersonalStruct.MDM_3D_PERSONAL_INFO,
                DataStruct.PersonalStruct.SUB_3D_CS_LOGINVERIFY, queryLoginVerify.ByteBuffer, SocketType.Hall);
            HotfixGameComponent.Instance.Send(DataStruct.LoginStruct.MDM_3D_LOGIN,
                DataStruct.LoginStruct.SUB_3D_CS_REQ_SERVER_LIST, new ByteBuffer(), SocketType.Hall);
            StartModule();
            ILGameManager.Instance.QuerySelfGold();
        }

        protected override void Awake()
        {
            base.Awake();
            // backgroundImg = transform.GetComponent<Image>();
            // defaultSprite = backgroundImg.sprite;
            version.text = $"V {Application.version}.{AppConst.valueConfiger.Version}";
            nickName.text = $"{GameLocalMode.Instance.SCPlayerInfo.NickName}";
            id.text = $"ID:{GameLocalMode.Instance.SCPlayerInfo.BeautifulID}";
            headIcon.sprite = ILGameManager.Instance.GetHeadIcon();
            HallEvent.DispatchEnterGamePre(false);
        }

        private void StartModule()
        {
            _noticeSlider.gameObject.CreateOrGetComponent<HallMarquee>();
            showContent = midNode.gameObject.CreateOrGetComponent<HallGameShow>();
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            Object.Destroy(showContent);
        }

        protected override void FindComponent()
        {
            base.FindComponent();
            Transform userInfo = transform.FindChildDepth($"Top/UserInfo");
            headBtn = userInfo.FindChildDepth<Button>($"HeadMask");
            headIcon = headBtn.transform.FindChildDepth<Image>($"HeadIcon");
            nickName = userInfo.FindChildDepth<Text>($"NickName");
            id = userInfo.FindChildDepth<TextMeshProUGUI>($"ID");
            copyBtn = userInfo.FindChildDepth<Button>($"CopyBtn");

            Transform moneyInfo = transform.FindChildDepth($"Top/MoneyInfo");
            selfGold = moneyInfo.FindChildDepth<TextMeshProUGUI>($"Gold/Text");
            bankGold = moneyInfo.FindChildDepth<TextMeshProUGUI>($"SelfGold/Text");

            otherGroup = transform.FindChildDepth($"Top/OtherBtnGroup");
            serviceBtn = otherGroup.FindChildDepth<Button>($"ServiceBtn");
            fristPlayBtn = otherGroup.FindChildDepth<Button>($"FristPlayBtn");
            //fristPlayBtn.gameObject.SetActive(GameLocalMode.Instance.SCPlayerInfo.IsFirstRecharge == 0);
            bindBtn = otherGroup.FindChildDepth<Button>($"BindBtn");
            bindBtn.gameObject.SetActive(string.IsNullOrEmpty(GameLocalMode.Instance.SCPlayerInfo.SzPhoneNumber));
            wheelBtn = otherGroup.FindChildDepth<Button>($"WheelBtn");
            activityBtn = otherGroup.FindChildDepth<Button>($"ActivityBtn");
            UIRedPointNode.Add("Activity", activityBtn.transform.FindChildDepth("Reminder").gameObject);
            // gwBtn = otherGroup.FindChildDepth<Button>($"GWBtn");
            // gwBtn.gameObject.SetActive(false);
            Transform floorNode = transform.FindChildDepth($"Floor");
            taskBtn = floorNode.FindChildDepth<Button>($"MissionBtn");
            exchangeBtn = floorNode.FindChildDepth<Button>($"ExchangeBtn");
            bankBtn = floorNode.FindChildDepth<Button>($"BankBtn");
            leaderboardBtn = floorNode.FindChildDepth<Button>($"LeaderBoardBtn");
            setBtn = floorNode.FindChildDepth<Button>($"SetBtn");
            inviteBtn = floorNode.FindChildDepth<Button>($"InviteBtn");
            mailBtn = floorNode.FindChildDepth<Button>($"MailBtn");
            UIRedPointNode.Add(Mail.Model.RedKey, mailBtn.transform.FindChildDepth("Reminder").gameObject);
            noticeBtn = floorNode.FindChildDepth<Button>($"NoticeBtn");
            shopBtn = floorNode.FindChildDepth<Button>($"ChargeBtn");
            version = transform.FindChildDepth<Text>($"Version");
            midNode = transform.FindChildDepth($"Mid");
            AddGoldBtn = moneyInfo.FindChildDepth<Button>($"Gold/Add");

            _noticeSlider = transform.FindChildDepth<Slider>("Top/NoticeSlider");
            _noticeSlider.value = 1;


            taskBtn.gameObject.SetActive(GameLocalMode.Instance.SCPlayerInfo.nIsDrain == 1);
            fristPlayBtn.gameObject.SetActive(GameLocalMode.Instance.SCPlayerInfo.nIsDrain == 1 &&
                                              GameLocalMode.Instance.SCPlayerInfo.IsFirstRecharge != 1);
            wheelBtn.gameObject.SetActive(GameLocalMode.Instance.SCPlayerInfo.nIsDrain == 1);
            activityBtn.gameObject.SetActive(GameLocalMode.Instance.SCPlayerInfo.nIsDrain == 1);
            serviceBtn.gameObject.SetActive(GameLocalMode.Instance.SCPlayerInfo.nIsDrain == 1);
            shopBtn.gameObject.SetActive(GameLocalMode.Instance.SCPlayerInfo.nIsDrain == 1);
            inviteBtn.gameObject.SetActive(GameLocalMode.Instance.SCPlayerInfo.nIsDrain == 1);
            bankBtn.gameObject.SetActive(false);
            exchangeBtn.gameObject.SetActive(GameLocalMode.Instance.SCPlayerInfo.nIsDrain == 1);
            AddGoldBtn.gameObject.SetActive(GameLocalMode.Instance.SCPlayerInfo.nIsDrain == 1);
            noticeBtn.gameObject.SetActive(GameLocalMode.Instance.SCPlayerInfo.nIsDrain == 1);
        }

        protected override void AddListener()
        {
            base.AddListener();
            headBtn.onClick.RemoveAllListeners();
            headBtn.onClick.Add(OnClickHeadCall);
            taskBtn.onClick.RemoveAllListeners();
            taskBtn.onClick.Add(OnClickTaskCall);
            exchangeBtn.onClick.RemoveAllListeners();
            exchangeBtn.onClick.Add(OnClickExchangeCall);
            bankBtn.onClick.RemoveAllListeners();
            bankBtn.onClick.Add(OnClickBankCall);
            setBtn.onClick.RemoveAllListeners();
            setBtn.onClick.Add(OnClickSettingCall);
            shopBtn.onClick.RemoveAllListeners();
            shopBtn.onClick.Add(OnClickShopCall);
            serviceBtn.onClick.RemoveAllListeners();
            serviceBtn.onClick.Add(OnClickServiceCall);
            bindBtn.onClick.RemoveAllListeners();
            bindBtn.onClick.Add(OnClickBindCall);
            fristPlayBtn.onClick.RemoveAllListeners();
            fristPlayBtn.onClick.Add(OnClickFristPlayCall);
            mailBtn.onClick.RemoveAllListeners();
            mailBtn.onClick.Add(OnClickMailCall);
            noticeBtn.onClick.RemoveAllListeners();
            noticeBtn.onClick.Add(OnClickNoticeCall);
            wheelBtn.onClick.RemoveAllListeners();
            wheelBtn.onClick.Add(OnClickWheelCall);
            activityBtn.onClick.RemoveAllListeners();
            activityBtn.onClick.Add(OnClickActiveCall);
            leaderboardBtn.onClick.RemoveAllListeners();
            leaderboardBtn.onClick.Add(OnClickLeaderBoardCall);
            inviteBtn.onClick.RemoveAllListeners();
            inviteBtn.onClick.Add(OnClickInviteCall);
            AddGoldBtn.onClick.RemoveAllListeners();
            AddGoldBtn.onClick.Add(OnClickShopCall);

            copyBtn.onClick.RemoveAllListeners();
            copyBtn.onClick.Add(OnClickCopyID);
        }

        protected override void AddEvent()
        {
            base.AddEvent();
            HallEvent.ChangeGoldTicket += HallEventOnChangeGoldTicket;
            HallEvent.EnterGamePre += HallEventOnEnterGamePre;
            HallEvent.OnQueryLoginVerifyCallBack += HallEventOnOnQueryLoginVerifyCallBack;
            HallEvent.ChangeHeader += ChangeHead;
            HallEvent.ChangeHallNiKeName += HallEventOnChangeHallNiKeName;
            HallEvent.TurntableDisplaysInfo += HallEventOnEnterWheel;
            HallEvent.SignBackInfo += HallEventOnActivity;
            HallEvent.SC_CHANGE_ACCOUNT += HallEventOnSC_CHANGE_ACCOUNT;
        }

        protected override void RemoveEvent()
        {
            base.RemoveEvent();
            HallEvent.ChangeGoldTicket -= HallEventOnChangeGoldTicket;
            HallEvent.EnterGamePre -= HallEventOnEnterGamePre;
            HallEvent.OnQueryLoginVerifyCallBack -= HallEventOnOnQueryLoginVerifyCallBack;
            HallEvent.ChangeHeader -= ChangeHead;
            HallEvent.ChangeHallNiKeName -= HallEventOnChangeHallNiKeName;
            HallEvent.TurntableDisplaysInfo -= HallEventOnEnterWheel;
            HallEvent.SignBackInfo -= HallEventOnActivity;
            HallEvent.SC_CHANGE_ACCOUNT -= HallEventOnSC_CHANGE_ACCOUNT;
        }

        private void HallEventOnOnQueryLoginVerifyCallBack(HallStruct.ACP_SC_QueryLoginVerify obj)
        {
            GameLocalMode.Instance.IsSetLoginValidation = obj.isOn;
            DebugHelper.Log(LitJson.JsonMapper.ToJson(obj));
        }

        private void OnNotice()
        {
            var pos = noticeNode.localPosition;
            float rate = Screen.width / (float) Screen.height;
            noticeNode.localPosition = new Vector3(750 * rate / 2 + 300, pos.y);
            duringShow = true;
            noticeNode.gameObject.SetActive(true);

            string[] nameList = new string[]
            {
                "Wieland",
                "Jorine",
                "Daan",
                "Mary",
                "Marygrace",
                "Pia",
                "Charmaine",
                "Sirena",
                "Retha",
            };
            string[] gameList = new string[]
            {
                "Dragon Legend",
                "Fruit slot 777",
                "Fortune Panda",
                "Fartune Gods",
                "Fruit Mary",
                "Gold Digger",
                "High Jump",
                "3D Fishing",
                "Fulinmen",
            };
            int score = Random.Range(10000, 10000000);
            string name = nameList[Random.Range(0, nameList.Length)];
            string game = gameList[Random.Range(0, gameList.Length)];
            noticeNode.FindChildDepth<Text>("name").SetText(name);
            noticeNode.FindChildDepth<Text>("game").SetText(game);
            noticeNode.FindChildDepth<Text>("score").SetText(score.ShortNumber());
            Image head = noticeNode.FindChildDepth<Image>("HeadMask/Mask/HeadIcon");

            head.sprite = ILGameManager.Instance.GetHeadIcon((uint) Random.Range(0, 8));
            Sequence sequence = DOTween.Sequence();

            sequence.Append(noticeNode.DOLocalMoveX(750 * rate / 2 - 200, 0.5f));
            sequence.AppendInterval(6);
            sequence.AppendCallback(() =>
            {
                noticeNode.gameObject.SetActive(false);
                noticeNode.localPosition = new Vector3(pos.x, pos.y, 0);
            });
            sequence.AppendInterval(4);
            sequence.AppendCallback(() => { duringShow = false; });
            //sequence.Append()
            // noticeNode.DOLocalMoveX(pos.x- 400, 1f).SetDelay(6f).OnComplete(() =>
            // {
            // //    //noticeNode.gameObject.SetActive(false);
            // //    //noticeNode.localPosition = new Vector3(pos.x, pos.y, 0);
            // //    //duringShow = false;
            // });
        }


        private void ChangeHead(int faceID)
        {
            headIcon.sprite = ILGameManager.Instance.GetHeadIcon((uint) faceID);
        }

        private void HallEventOnChangeHallNiKeName()
        {
            nickName.text = GameLocalMode.Instance.SCPlayerInfo.NickName;
        }

        private void HallEventOnChangeGoldTicket()
        {
            selfGold.text = $"{GameLocalMode.Instance.GetProp(Prop_Id.E_PROP_GOLD).ShortNumber()}";
        }

        private void HallEventOnEnterGamePre(bool isEnter)
        {
            midNode.gameObject.SetActive(!isEnter);
            otherGroup.gameObject.SetActive(!isEnter);
        }

        private void HallEventOnEnterWheel(ACP_SC_TurntableDisplaysInfo turn)
        {
            UIManager.Instance.OpenUI<WheelPanel>(turn);
        }

        private void HallEventOnActivity(ACP_SC_SignCheck_QueryRet info)
        {
            UIManager.Instance.ReplaceUI<Activity.ActivityPanel>(info);
        }

        private void HallEventOnSC_CHANGE_ACCOUNT(sCommonINT16 obj)
        {
            bindBtn.gameObject.SetActive(!(obj.nValue == 0));
        }

        private void OnClickCopyID()
        {
            ILMusicManager.Instance.PlayBtnSound();
            var strID = GameLocalMode.Instance.SCPlayerInfo.BeautifulID;
            ToolHelper.SetText($"{strID}");
            ToolHelper.PopSmallWindow("Copy success");
        }

        /// <summary>
        /// 点击商店
        /// </summary>
        private void OnClickShopCall()
        {
            // if (string.IsNullOrWhiteSpace(GameLocalMode.Instance.SCPlayerInfo.SzPhoneNumber))
            // {
            //     UIManager.Instance.OpenUI<BindPanel>();
            //     return;
            // }

            UIManager.Instance.ReplaceUI<Recharge.RechargePanel>();
        }

        private void OnClickTuiGuangCall()
        {
            ToolHelper.PopBigWindow(new BigMessage());
        }

        private void OnClickServiceCall()
        {
            UIManager.Instance.ReplaceUI<Service.ServicePanel>();
            //ToolHelper.PopBigWindow(new BigMessage());
        }

        private void OnClickFuliCall()
        {
            ToolHelper.PopBigWindow(new BigMessage());
        }

        private void OnClickMailCall()
        {
            UIManager.Instance.ReplaceUI<Mail.UIMail>();
        }

        private void OnClickNoticeCall()
        {
            UIManager.Instance.OpenUI<Announcement.AnnouncementPanel>();
        }

        private void OnClickWheelCall()
        {
            DebugHelper.Log("OnClickWheelCall");
            HotfixGameComponent.Instance.Send(DataStruct.PersonalStruct.MDM_3D_PERSONAL_INFO, 42, null,
                SocketType.Hall);
        }

        private void OnClickActiveCall()
        {
            DebugHelper.Log("OnClickActiveCall");
            HotfixGameComponent.Instance.Send(DataStruct.PersonalStruct.MDM_3D_PERSONAL_INFO, 48, null,
                SocketType.Hall);
        }

        private void OnClickLeaderBoardCall()
        {
            UIManager.Instance.OpenUI<LeaderBoard.UILeaderBoard>();
        }

        /// <summary>
        /// 点击设置
        /// </summary>
        private void OnClickSettingCall()
        {
            UIManager.Instance.ReplaceUI<SetPanel>();
        }

        private void OnClickInviteCall()
        {
            UIManager.Instance.OpenUI<Share.UIShare>();
        }

        /// <summary>
        /// 点击银行
        /// </summary>
        private void OnClickBankCall()
        {
            // if (string.IsNullOrWhiteSpace(GameLocalMode.Instance.SCPlayerInfo.SzPhoneNumber))
            // {
            //     UIManager.Instance.OpenUI<BindPanel>();
            //     return;
            // }
            //
            // UIManager.Instance.ReplaceUI<BankPanel>();
        }

        /// <summary>
        /// 点击兑换
        /// </summary>
        private void OnClickExchangeCall()
        {
            // if (string.IsNullOrWhiteSpace(GameLocalMode.Instance.SCPlayerInfo.SzPhoneNumber))
            // {
            //     UIManager.Instance.OpenUI<BindPanel>();
            //     return;
            // }

            if (GameLocalMode.Instance.SCPlayerInfo.IsVIP == 1)
            {
                ToolHelper.PopSmallWindow($"VIP不能进行该操作");
                return;
            }

            UIManager.Instance.ReplaceUI<Recharge.RechargePanel>(1);
        }

        /// <summary>
        /// 点击任务
        /// </summary>
        private void OnClickTaskCall()
        {
            ToolHelper.PopSmallWindow("Function not yet open, please wait!");
        }

        /// <summary>
        /// 点击官网
        /// </summary>
        private void OnClickGWCall()
        {
            UIManager.Instance.ReplaceUI<GWPanel>();
        }

        /// <summary>
        /// 点击头像
        /// </summary>
        private void OnClickHeadCall()
        {
            UIManager.Instance.ReplaceUI<PersonalInfoPanel>();
        }


        private void OnClickFristPlayCall()
        {
            UIManager.Instance.ReplaceUI<Recharge.FristRechargePanel>(fristPlayBtn.gameObject);
        }

        private void OnClickBindCall()
        {
            UIManager.Instance.ReplaceUI<BindPanel>();
        }
    }
}