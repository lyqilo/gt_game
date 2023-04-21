using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.TiaoTiaoTangGuo
{
    public class TTTG_Rule : ILHotfixEntity
    {
        private Button closeBtn;
        private Button rightBtn;
        private Button leftBtn;
        private ScrollRect scrollPage;
        private Transform pllist;
        private bool isInit;

        protected override void Awake()
        {
            base.Awake();
            gameObject.SetActive(false);
        }

        protected override void FindComponent()
        {
            base.FindComponent();
            Transform btngroup = transform.FindChildDepth($"Group");
            closeBtn = btngroup.FindChildDepth<Button>($"CloseBtn");
            leftBtn = btngroup.FindChildDepth<Button>($"LeftBtn");
            rightBtn = btngroup.FindChildDepth<Button>($"RightBtn");
            closeBtn.onClick.RemoveAllListeners();
            closeBtn.onClick.Add(OnClickCloseCall);
            leftBtn.onClick.RemoveAllListeners();
            leftBtn.onClick.Add(OnClickLeftCall);
            rightBtn.onClick.RemoveAllListeners();
            rightBtn.onClick.Add(OnClickRightCall);

            scrollPage = transform.FindChildDepth<ScrollRect>($"ScrollPages");
            pllist = scrollPage.transform.FindChildDepth($"Page1/Image");
            scrollPage.horizontalNormalizedPosition = 0;
        }

        protected override void OnEnable()
        {
            base.OnEnable();
            Init();
        }

        private void Init()
        {
            if (TTTGEntry.Instance.GameData.SceneData == null) return;
            if (isInit) return;
            leftBtn.interactable = false;
            rightBtn.interactable = true;
            for (int i = 0; i < pllist.childCount; i++)
            {
                TextMeshProUGUI text = pllist.GetChild(i).GetComponent<TextMeshProUGUI>();
                text.text = $"${(i + 1) * TTTGEntry.Instance.GameData.CurrentChip}";
            }
            isInit = true;
        }
        private void OnClickRightCall()
        {
            TTTG_Audio.Instance.PlaySound(TTTG_Audio.Candybreak_Click);
            scrollPage.horizontalNormalizedPosition = 1;
            leftBtn.interactable = true;
            rightBtn.interactable = false;
        }

        private void OnClickLeftCall()
        {
            TTTG_Audio.Instance.PlaySound(TTTG_Audio.Candybreak_Click);
            scrollPage.horizontalNormalizedPosition = 0;
            leftBtn.interactable = false;
            rightBtn.interactable = true;
        }

        private void OnClickCloseCall()
        {
            TTTG_Audio.Instance.PlaySound(TTTG_Audio.Candybreak_Click);
            transform.localScale = Vector3.zero;
        }
    }
}