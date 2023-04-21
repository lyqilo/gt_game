using System;
using System.Collections.Generic;
using System.Net;
using LuaFramework;
using UnityEngine;
using YooAsset;
using com.adjust.sdk;

namespace Hotfix
{
    public class GameLocalMode
    {
        private static GameLocalMode _instance;

        public static string HttpURL = "http://192.168.0.102:8081/NewGame_war_exploded/";
        // public const string HttpURL = "http://8.222.205.176:1234/NewGame/";
        public const string HallPackage = "HallPackage";
        public const string GamePackage = "GamePackage";
        public string CurrentSelectPlatform { get; set; }
        public int CurrentSelectGame;

        private IPEndPoint gameIpEndPoint;

        private IPEndPoint loginIpEndPoint;
        public byte PlatformID = 6;
        public int MoneyRate { get; set; }

        public static GameLocalMode Instance
        {
            get
            {
                if (_instance == null) _instance = new GameLocalMode();

                return _instance;
            }
        }

        public HallStruct.ACP_SC_LOGIN_SUCCESS SCPlayerInfo { get; set; }

        public List<HallStruct.Acp_SC_USER_PROP> AllSCUserProp { get; set; }

        public List<HallStruct.RoomInfo> AllSCGameRoom { get; set; }

        public bool IsSetLoginVerify { get; set; }
        public LoginType LoginType { get; set; }
        public AccountList AccountList { get; set; }

        public GameUserData UserGameInfo { get; set; }
        private AccountMSG _account;

        public List<int> NoShowList { get; }= new List<int>();
        public Dictionary<string, List<int>> GameDic { get; }= new Dictionary<string, List<int>>();

        public AccountMSG Account
        {
            get
            {
                if (_account == null)
                {
                    GetAccount();
                }

                return _account;
            }
            set { _account = value; }
        }

        /// <summary>
        /// 当前开放平台
        /// </summary>
        public List<string> platformList = new List<string>()
        {
            "games_hc", "games_339", "games_ttcm", "games_lldzz", "games_yh", "games_dcr", "games_hy888"
        };

        /// <summary>
        /// 是否开启登录验证
        /// </summary>
        public bool IsSetLoginValidation { set; get; }

        public string HeadUrl { get; set; }
        public string NickName { get; set; }

        public string GameNextScenName { get; set; }

        public HttpData M_HttpData { get; set; }

        public HttpDataConfiger GWData { get; set; }
        public string IP { get; set; }

        public string CurrentGame { get; set; }

        public string MechinaCode
        {
            get
            {
                if (Util.isApplePlatform) return Util.getIosCode();
                return SystemInfo.deviceUniqueIdentifier;
            }
        }

        public byte Platform
        {
            get
            {
                switch (Application.platform)
                {
                    case RuntimePlatform.Android:
                        return 1;
                    case RuntimePlatform.IPhonePlayer:
                        return 0;
                    default:
                        return 2;
                }
            }
        }

        public byte GameQuDao
        {
            get { return 1; }
        }

        public IPEndPoint LoginIPEndPoint
        {
            get
            {
                Debug.Log($"{loginIpEndPoint}");
                return loginIpEndPoint;
            }
            set { loginIpEndPoint = value; }
        }

        public string HallHost { get; set; }

        public string HallPort { get; set; }

        public string GameHost { get; set; }

        public int GamePort { get; set; }

        public IPEndPoint GameIPEndPoint
        {
            get
            {
                Debug.Log($"{gameIpEndPoint}");
                return gameIpEndPoint;
            }
            set => gameIpEndPoint = value;
        }

        public AudioConfig AudioConfig { get; set; }

        /// <summary>
        ///     是否在游戏中
        /// </summary>
        public bool IsInGame { get; set; }

        public bool IsResigter { get; set; }


        public static void Reset()
        {
            _instance = null;
        }

        public long GetProp(Prop_Id prop_Id)
        {
            long num = 0;
            for (var i = 0; i < AllSCUserProp.Count; i++)
            {
                if (AllSCUserProp[i].User_Id == SCPlayerInfo.DwUser_Id)
                {
                    if (prop_Id == Prop_Id.E_PROP_GOLD) num = AllSCUserProp[i].dwAmount;
                    if (prop_Id == Prop_Id.E_PROP_STRONG) num = AllSCUserProp[i].Bank_Gold;
                }
            }

            return num;
        }


        public void ChangProp(long num, Prop_Id prop_Id)
        {
            for (var i = 0; i < AllSCUserProp.Count; i++)
            {
                if (AllSCUserProp[i].User_Id != SCPlayerInfo.DwUser_Id) continue;
                switch (prop_Id)
                {
                    case Prop_Id.E_PROP_GOLD:
                        AllSCUserProp[i].dwAmount = num;
                        break;
                    case Prop_Id.E_PROP_STRONG:
                        AllSCUserProp[i].Bank_Gold = num;
                        break;
                }
            }

            HallEvent.DispatchChangeGoldTicket();
        }

        #region 登录注册密钥

        public ushort ResigterPlatMultiply = 12357;
        public byte ResigterPlatAdd = 79;
        public ushort LoginPlatMultiply = 14596;
        public byte LoginPlatAdd = 61;

        #endregion

        /// <summary>
        /// 账号
        /// </summary>
        private const string AccountKey = "AccountKey";

        /// <summary>
        /// 获取账号列表
        /// </summary>
        /// <returns></returns>
        public AccountMSG GetAccount()
        {
            AccountList = SaveHelper.Get<AccountList>(AccountKey);
            if (AccountList == null)
            {
                AccountList = new AccountList();
                AccountList.Accounts = new List<AccountMSG>();
            }

            if (AccountList.Accounts.Count <= 0)
            {
                Account = new AccountMSG();
                Account.account = "";
                Account.password = "";
            }
            else
            {
                Account = AccountList.Accounts[AccountList.Accounts.Count - 1];
            }

            return Account;
        }

        /// <summary>
        /// 存储账号
        /// </summary>
        public void SaveAccount()
        {
            if (AccountList == null) AccountList = new AccountList();
            if (AccountList.Accounts == null) AccountList.Accounts = new List<AccountMSG>();
            AccountMSG msg = AccountList.Accounts.FindItem(p => p.account == Account.account);
            if (msg != null) AccountList.Accounts.Remove(msg);
            AccountList.Accounts.Add(Account);
            SaveHelper.Save(AccountKey, AccountList);
        }

        public const string ScreenOrientation = "ScreenOrientation";

        public void SetScreen(ScreenOrientation orientation)
        {
            if (orientation == UnityEngine.ScreenOrientation.Portrait)
            {
                Screen.orientation = UnityEngine.ScreenOrientation.Portrait;
                Screen.autorotateToLandscapeLeft = false;
                Screen.autorotateToLandscapeRight = false;
                Screen.autorotateToPortrait = true;
                Screen.autorotateToPortraitUpsideDown = false;
            }
            else
            {
                Screen.orientation = UnityEngine.ScreenOrientation.Landscape;
                Screen.autorotateToLandscapeLeft = true;
                Screen.autorotateToLandscapeRight = true;
                Screen.autorotateToPortrait = false;
                Screen.autorotateToPortraitUpsideDown = false;
            }

            SaveHelper.SaveCommon(ScreenOrientation, orientation.ToString());
        }

        public AssetsPackage GetPackage(SceneType sceneType)
        {
            string pack = sceneType == SceneType.Hall ? HallPackage : GamePackage;
            var package = YooAssets.GetAssetsPackage(pack) ?? YooAssets.CreateAssetsPackage(pack);
            return package;
        }

        public void AdjustLog(string logEvent, double amount = 0, string currency = null)
        {
            if (!Util.isAndroidPlatform) return;
            AdjustEvent adjustEvent = new AdjustEvent(logEvent);
            if (amount > 0 && !string.IsNullOrEmpty(currency)) adjustEvent.setRevenue(amount, currency);
            Adjust.trackEvent(adjustEvent);
        }

        public void AdjustLog(string logEvent, FormData data, double amount = 0, string currency = null)
        {
            if (!Util.isAndroidPlatform) return;
            AdjustEvent adjustEvent = new AdjustEvent(logEvent);
            if (amount > 0 && !string.IsNullOrEmpty(currency)) adjustEvent.setRevenue(amount, currency);
            if (data != null)
            {
                for (int i = 0; i < data.FieldNames.Count; i++)
                {
                    adjustEvent.addCallbackParameter(data.FieldNames[i], data.FieldValues[i]);
                }
            }
            Adjust.trackEvent(adjustEvent);
        }

        /// <summary>
        /// 判断用户是不是自然量
        /// </summary>
        /// <returns></returns>
        public bool CheckUserIsNature()
        {
            var attri = Adjust.getAttribution();
            if (attri == null || !attri.network.Equals("Organic")) return false;
            if (string.IsNullOrEmpty(ILGameManager.Instance.UserAttribution)) return false;
            if (ILGameManager.Instance.UserAttribution.Equals("ERROR")) return false;
            string source = null;
            string medium = null;
            if (ILGameManager.Instance.Attribution.TryGetValue("utm_source", out source) &&
                ILGameManager.Instance.Attribution.TryGetValue("utm_medium", out medium))
            {
                if (source == "google-play" && medium == "organic") return true;
            }

            return false;
        }
    }

    public enum Prop_Id
    {
        E_PROP_NULL = 0,
        E_PROP_GOLD = 1, //自身
        E_PROP_TICKET = 2,
        E_PROP_STRONG = 3 //银行
    }

    public class AccountMSG
    {
        public int LoginType;
        public string account;
        public string password;
    }

    public class AccountList : BaseSave
    {
        public List<AccountMSG> Accounts;
        public bool isAuto;

        /// <summary>
        /// 登录类型0 默认  1.游客  2.账号 3。微信等
        /// </summary>
        public int LoginType;

        public AccountList()
        {
            Accounts = new List<AccountMSG>();
        }
    }

    public class HttpData : BaseSave
    {
        public string login_ip;
        public string login_port;
    }

    public class CodeDownTimer
    {
        public DateTime exitTime;
        public float remainTime;
    }

    /// <summary>
    ///     声音配置
    /// </summary>
    public class AudioConfig
    {
        public bool IsMuteMusic;
        public bool IsMuteSound;
        public float MusicVolum;
        public float SoundVolum;
    }

    /// <summary>
    ///     登录类型
    /// </summary>
    public enum LoginType
    {
        None = 0,
        Account = 1,
        Guest,
        WX
    }

    /// <summary>
    ///     通用标签
    /// </summary>
    public class LaunchTag
    {
        public const string _01frameTag = "rootFrameModule";
        public const string _01StartTag = "rootStartModule";
        public const string _02hallTag = "rootHallModule";
        public const string _01gameTag = "rootGameModule";
        public const string _GameMgr = "GameManager";
    }

    public class HttpDataConfiger : BaseSave
    {
        public double version;
        public string CNameGold;
        public bool ShowDebug;
        public Dictionary<string, HttpGame> GameList;
        public string GWUrl;
        public List<string> IPUrls;
        public int MoneyRate;
        public string GameIP;
        public string LoginIP;
        public string PCGameIP;
        public string PCLoginIP;
        public string DefenceGameIP;
        public string DefenceLoginIP;
        public string DefencePCGameIP;
        public string DefencePCLoginIP;
        public string HttpUrl;
        public string PCUrl;
        public string AndroidUrl;
        public string iOSUrl;
        public List<string> PCUrls;
        public List<string> REQGameList;
        public List<string> REQLoginList;
        public List<string> PCREQGameList;
        public List<string> PCREQLoginList;
        public List<int> TransferConfig;
        public List<string> Urls;
        public bool isUseLoginIP;
        public bool isUseGameIP;
        public bool isUseDefence;
        public byte platformId;
        public int ExchangeNumber;
        public bool IsForbidEmulator;
        public Dictionary<string, List<int>> gameList;
    }


    public class HttpGame
    {
        public bool hasFix;
        public List<string> group;
        public List<string> slots;
        public List<string> poker;
        public List<string> fish;
    }

    public class gameServerName
    {
        public const string LOGON = "logon";
        public const string HALL = "hall";
        public const string Game03 = "开心牛牛";
    }

    public enum SceneType
    {
        Hall,
        Game,
    }

    public enum GameDownStatus
    {
        None,
        Downing,
        Downed,
    }
}