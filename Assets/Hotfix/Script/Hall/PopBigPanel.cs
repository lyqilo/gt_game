using DG.Tweening;
using UnityEngine;
using UnityEngine.UI;
using System.Collections;
namespace Hotfix.Hall
{
    public class TishiPanel_Version3 : PanelBase
    {
        private Button iguore;
        private GameObject FreeGoldBtn;
        private GameObject RechagreBtn;
        private GameObject Time;
        private Button SureBtn;
        private Button SureBtn_One;
        private Text content;
        private BigMessage big;
        public const string ScreenOrientation = "ScreenOrientation";

        private CanvasScaler _canvas;
        
        public TishiPanel_Version3() : base(UIType.TipWindow, nameof(TishiPanel_Version3)) { }
        
        
        protected override void Awake()
        {
            base.Awake();
            _canvas = transform.GetComponent<CanvasScaler>();
            transform.GetChild(0).name = "tishi";
            FreeGoldBtn.SetActive(false);
            iguore.gameObject.SetActive(false);
            RechagreBtn.SetActive(false);
            Time.SetActive(false);
            SureBtn.gameObject.SetActive(false);
            SureBtn_One.gameObject.SetActive(true);
        }
        protected override void FindComponent()
        {
            base.FindComponent();
            iguore = transform.FindChildDepth<Button>("IguoreBtn");
            FreeGoldBtn = transform.FindChildDepth("FreeGoldBtn").gameObject;
            RechagreBtn = transform.FindChildDepth("RechagreBtn").gameObject;
            Time = transform.FindChildDepth("Time").gameObject;
            SureBtn = transform.FindChildDepth<Button>("SureBtn");
            SureBtn_One = transform.FindChildDepth<Button>("SureBtn_One");
            content = transform.FindChildDepth<Text>("Bg/Text");
        }
        public override void Create(params object[] args)
        {
            base.Create(args);
            string orientation = SaveHelper.GetString(ScreenOrientation);
            _canvas.referenceResolution = orientation == UnityEngine.ScreenOrientation.Portrait.ToString() ? new Vector2(750, 1334) : new Vector2(1334, 750);
            big = (BigMessage)args[0];
            content.text = big.content;
            content.fontSize = 48;
            content.raycastTarget = false;

            if (big.okCall != null && big.cancelCall != null)
            {
                SureBtn.gameObject.SetActive(true);
                iguore.gameObject.SetActive(true);
                SureBtn.transform.localPosition = new Vector3(167, SureBtn.transform.localPosition.y, 0);
                SureBtn.onClick.RemoveAllListeners();
                SureBtn.onClick.Add(SureCall);
                iguore.onClick.RemoveAllListeners();
                iguore.onClick.Add(CancelCall);
                SureBtn_One.onClick.RemoveAllListeners();
                SureBtn_One.onClick.Add(CancelCall);
            }
            else if (big.okCall != null && big.cancelCall == null)
            {
                SureBtn.gameObject.SetActive(true);
                iguore.gameObject.SetActive(false);
                SureBtn.transform.localPosition = new Vector3(0, SureBtn.transform.localPosition.y, 0);
                SureBtn.onClick.RemoveAllListeners();
                SureBtn.onClick.Add(SureCall);
                iguore.onClick.RemoveAllListeners();
                iguore.onClick.Add(CancelCall);
                SureBtn_One.onClick.RemoveAllListeners();
                SureBtn_One.onClick.Add(CancelCall);
            }
            else if (big.okCall == null && big.cancelCall != null)
            {
                SureBtn.gameObject.SetActive(false);
                iguore.gameObject.SetActive(true);
                iguore.transform.localPosition = new Vector3(0, iguore.transform.localPosition.y, 0);
                SureBtn.onClick.RemoveAllListeners();
                SureBtn.onClick.Add(SureCall);
                iguore.onClick.RemoveAllListeners();
                iguore.onClick.Add(CancelCall);
                SureBtn_One.onClick.RemoveAllListeners();
                SureBtn_One.onClick.Add(CancelCall);
            }
            else if (big.okCall == null && big.cancelCall == null)
            {
                SureBtn.gameObject.SetActive(false);
                iguore.gameObject.SetActive(false);
                SureBtn.onClick.RemoveAllListeners();
                SureBtn.onClick.Add(SureCall);
                iguore.onClick.RemoveAllListeners();
                iguore.onClick.Add(CancelCall);
                SureBtn_One.onClick.RemoveAllListeners();
                SureBtn_One.onClick.Add(CancelCall);
            }
        }
        private void SureCall()
        {
            big.okCall?.Invoke();
            UIManager.Instance.CloseUI(this);
        }
        private void CancelCall()
        {
            big.cancelCall?.Invoke();
            UIManager.Instance.CloseUI(this);
        }
        protected override void OnDestroy()
        {
            base.OnDestroy();
            HallEvent.DispatchOnClosePopBig();
        }
    }

    public class TipPanel : PanelBase
    {
        private RectTransform backgroundrect;
        private Text desc;
        private CanvasGroup background;

        public TipPanel() : base(UIType.SmallTipWindow, nameof(TipPanel)) { }
        protected override void FindComponent()
        {
            base.FindComponent();
            background = transform.FindChildDepth<CanvasGroup>("Image");
            backgroundrect = background.transform.GetComponent<RectTransform>();
            desc = transform.FindChildDepth<Text>("Image/Text");
        }
        protected override void Awake()
        {
            base.Awake();
            background.alpha = 0;
            desc.fontSize = 48;
            background.transform.localPosition = new Vector3(0, 0, 0);
        }
        public override void Create(params object[] args)
        {
            base.Create(args);
            string content = args[0].ToString();
            desc.text = content;
            Behaviour.StartCoroutine(Delay());
        }
        private IEnumerator Delay()
        {
            yield return new WaitForEndOfFrame();
            backgroundrect.sizeDelta = new Vector2(desc.preferredWidth + 30, desc.preferredHeight + 10);
            Vector2 size = new Vector2(desc.preferredWidth, desc.preferredHeight);
            desc.GetComponent<RectTransform>().sizeDelta = new Vector2(size.x, size.y);
            background.GetComponent<RectTransform>().sizeDelta = new Vector2(size.x + 40, size.y + 50);
            background.alpha = 1;
            background.DOFade(0, 0.5f).SetDelay(2f);
            background.transform.DOLocalMove(new Vector3(0, 200, 0), 0.5f).SetDelay(2f).OnComplete(() =>
            {
                Object.Destroy(gameObject);
            }).SetLink(gameObject);
        }
    }
}
