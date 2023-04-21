using LuaFramework;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall
{
    public class ZSCardPanel : PanelBase
    {
        private Button closeBtn;
        private InputField CountText;

        private Text DKCount;

        private InputField IDText;

        private Transform mainPanel;
        private Button maskBtn;
        private Button sendBtn;
        private Text nickName;
        private int cardCount;

        public ZSCardPanel() : base(UIType.Middle, nameof(ZSCardPanel))
        {

        }
        public override void Create(params object[] args)
        {
            base.Create(args);
            DebugHelper.LogError($"进入赠送卡");
            IDText.text = "";
            nickName.text = "";
            HotfixGameComponent.Instance.Send(DataStruct.PersonalStruct.MDM_3D_PERSONAL_INFO,
                                        DataStruct.PersonalStruct.SUB_3D_CS_DIANKA_QUERY, new ByteBuffer(), SocketType.Hall);
        }

        protected override void AddEvent()
        {
            base.AddEvent();
            HallEvent.ZSCardResult += InitData;
            HallEvent.DIANKA_QUERY += QueryCardResult;
            HallEvent.OnQueryPlayer += HallEventOnQueryPlayer;
        }
        protected override void RemoveEvent()
        {
            base.RemoveEvent();
            HallEvent.ZSCardResult -= InitData;
            HallEvent.DIANKA_QUERY -= QueryCardResult;
            HallEvent.OnQueryPlayer -= HallEventOnQueryPlayer;
        }

        protected override void FindComponent()
        {
            mainPanel = transform.FindChildDepth("MainPanel");
            maskBtn = transform.FindChildDepth<Button>("Mask");
            closeBtn = mainPanel.FindChildDepth<Button>("CloseBtn");
            sendBtn = mainPanel.FindChildDepth<Button>("SendBtn");
            IDText = mainPanel.FindChildDepth<InputField>("ID");
            CountText = mainPanel.FindChildDepth<InputField>("Count");
            DKCount = mainPanel.FindChildDepth<Text>("DKCount");
            nickName = mainPanel.FindChildDepth<Text>("NickName");
        }

        protected override void AddListener()
        {
            closeBtn.onClick.RemoveAllListeners();
            closeBtn.onClick.Add(CloseZSCardPanel);

            maskBtn.onClick.RemoveAllListeners();
            maskBtn.onClick.Add(CloseZSCardPanel);

            sendBtn.onClick.RemoveAllListeners();
            sendBtn.onClick.Add(OnClickReceive);
            IDText.onEndEdit.RemoveAllListeners();
            IDText.onEndEdit.Add(OnInputIDComplete);
        }

        /// <summary>
        ///     服务器返回赠送
        /// </summary>
        /// <param name="buffer"></param>
        private void InitData(ByteBuffer buffer)
        {
            var count = buffer.ReadInt32();
            var dianka = buffer.ReadString(40);
            var msg = buffer.ReadString(100);
            ToolHelper.PopSmallWindow(msg);
            DKCount.text = $"点卡剩余数量: {count} 张";
            cardCount = count;
        }


        private void OnInputIDComplete(string id)
        {
            HallStruct.REQ_CS_QueryPlayer queryPlayer = new HallStruct.REQ_CS_QueryPlayer();
            queryPlayer.id = uint.Parse(id);
            HotfixGameComponent.Instance.Send(DataStruct.PersonalStruct.MDM_3D_PERSONAL_INFO,
                DataStruct.PersonalStruct.SUB_3D_CS_USER_INFO_SELECT, queryPlayer.ByteBuffer, SocketType.Hall);
        }
        /// <summary>
        ///     初始化数量
        /// </summary>
        /// <param name="data"></param>
        private void QueryCardResult(HallStruct.ACP_SC_DIANKA_QUERY data)
        {
            DebugHelper.LogErrorObject(data);
            DKCount.text = $"点卡剩余数量: {data.Count} 张";
            cardCount = data.Count;
        }


        private void HallEventOnQueryPlayer(HallStruct.ACP_SC_QueryPlayer obj)
        {
            if (!obj.isReal)
            {
                ToolHelper.PopSmallWindow($"ID不存在");
                nickName.text = "";
                return;
            }
            if (nickName == null) return;
            nickName.text = obj.nickName;
        }

        /// <summary>
        ///     赠送
        /// </summary>
        private void OnClickReceive()
        {
            ILMusicManager.Instance.PlayBtnSound();
            if (string.IsNullOrEmpty(IDText.text))
            {
                ToolHelper.PopSmallWindow("输入赠送ID有误，请重新输入!");
                return;
            }

            if (string.IsNullOrEmpty(CountText.text))
            {
                ToolHelper.PopSmallWindow("输入赠送数量有误，请重新输入!");
                return;
            }

            var id = int.Parse(IDText.text);
            var count = int.Parse(CountText.text);
            if (cardCount < count)
            {
                ToolHelper.PopSmallWindow("剩余卡余额不足!");
                return;
            }
            var userid = (int) GameLocalMode.Instance.SCPlayerInfo.DwUser_Id;
            sendBtn.interactable = false;
            var give = new HallStruct.REQ_CS_DIANKA_GIVE(id, userid, count);
            HotfixGameComponent.Instance.Send(DataStruct.PersonalStruct.MDM_3D_PERSONAL_INFO,
                DataStruct.PersonalStruct.SUB_3D_CS_DIANKA_GIVE, give._ByteBuffer, SocketType.Hall);
            CountText.text = "";            
            sendBtn.interactable = true;
        }

        private void CloseZSCardPanel()
        {
            ILMusicManager.Instance.PlayBtnSound();
            UIManager.Instance.Close();
        }
    }
}