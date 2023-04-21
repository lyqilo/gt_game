using LuaFramework;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall
{
    public class ChangeHeadPanel : PanelBase
    {
        private Button closeBtn;

        private ScrollRect HeadSelectArea;

        private int selectHeadIndex;
        private Button SureBtn;
        private Transform mainPanel;
        private Button maskCloseBtn;
        private Image CurHead; 

        public ChangeHeadPanel() : base(UIType.Middle, nameof(ChangeHeadPanel))
        {

        }

        public override void Create(params object[] args)
        {
            base.Create(args);
            InitHead();
        }


        protected override void FindComponent()
        {
            mainPanel = transform.FindChildDepth("MainPanel");
            SureBtn = transform.FindChildDepth<Button>("SureBtn");
            closeBtn = transform.FindChildDepth<Button>("CloseBtn");
            maskCloseBtn = transform.FindChildDepth<Button>("Mask");

            HeadSelectArea = transform.FindChildDepth<ScrollRect>("SelectArea");
            CurHead= transform.FindChildDepth<Image>($"head");
        }

        /// <summary>
        /// 初始化头像显示
        /// </summary>
        private void InitHead()
        {

         
            GameObject headIcons = ILGameManager.Instance.HeadIcons.gameObject;
            selectHeadIndex = 0;

            for (var i = 0; i < headIcons.transform.childCount; i++)
            {
                Transform child;
                if (i < HeadSelectArea.content.childCount)
                {
                    child = HeadSelectArea.content.GetChild(i);
                }
                else
                {
                    child = Object.Instantiate(HeadSelectArea.content.GetChild(0).gameObject).transform;
                    child.SetParent(HeadSelectArea.content);
                    child.localPosition = Vector3.zero;
                    child.localScale = Vector3.one;
                }
                CurHead.sprite = ILGameManager.Instance.GetHeadIcon();
                if (i == GameLocalMode.Instance.SCPlayerInfo.FaceID - 1)
                {
                    selectHeadIndex = i;
                    child.FindChildDepth("Select").gameObject.SetActive(true);
                    child.FindChildDepth("Unselect").gameObject.SetActive(false);
                }
                else
                {
                    child.FindChildDepth("Select").gameObject.SetActive(false);
                    child.FindChildDepth("Unselect").gameObject.SetActive(true);
                }

                child.FindChildDepth("Bg").gameObject.SetActive(true);
                child.GetComponent<Image>().sprite = headIcons.transform.GetChild(i).GetComponent<Image>().sprite;
                child.FindChildDepth("Bg").GetComponent<Image>().sprite =
                    headIcons.transform.GetChild(i).GetComponent<Image>().sprite;

                child.GetComponent<Button>().onClick.RemoveAllListeners();
                child.GetComponent<Button>().onClick.Add(() =>
                {
                    SelectHeadCall(child, selectHeadIndex);
                    selectHeadIndex = child.GetSiblingIndex();
                });
            }
        }

        /// <summary>
        ///     选择头像
        /// </summary>
        /// <param name="go"></param>
        /// <param name="index"></param>
        private void SelectHeadCall(Transform go, int index)
        {
            DebugHelper.Log("index====" + index);
            ILMusicManager.Instance.PlayBtnSound();
            HeadSelectArea.content.GetChild(index).FindChildDepth("Select").gameObject.SetActive(false);
            HeadSelectArea.content.GetChild(index).FindChildDepth("Unselect").gameObject.SetActive(true);
            HeadSelectArea.content.GetChild(index).FindChildDepth("Bg").gameObject.SetActive(true);
            go.transform.FindChildDepth("Select").gameObject.SetActive(true);
             go.transform.FindChildDepth("Unselect").gameObject.SetActive(false);
            CurHead.sprite = go.FindChildDepth("Bg").GetComponent<Image>().sprite;

        }

        protected override void AddListener()
        {
            SureBtn.onClick.RemoveAllListeners();
            SureBtn.onClick.Add(ChangeHeadCall);

            closeBtn.onClick.RemoveAllListeners();
            closeBtn.onClick.Add(CloseChangeHeadPanelCall);
            maskCloseBtn.onClick.RemoveAllListeners();
            maskCloseBtn.onClick.Add(CloseChangeHeadPanelCall);
        }

        private void ChangeHeadCall()
        {
            ILMusicManager.Instance.PlayBtnSound();

            var bytebuffer = new ByteBuffer();
            bytebuffer.WriteByte(selectHeadIndex + 1);
            HotfixGameComponent.Instance.Send(DataStruct.PersonalStruct.MDM_3D_PERSONAL_INFO,
                DataStruct.PersonalStruct.SUB_3D_CS_ChangeHeader, bytebuffer, SocketType.Hall);
        }

        private void CloseChangeHeadPanelCall()
        {
            ILMusicManager.Instance.PlayBtnSound();
            UIManager.Instance.Close();
        }
    }
}