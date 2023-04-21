using System;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.BQTP
{
    public class UIUserInfo : MonoBehaviour
    {
        private TextMeshProUGUI _selfGold;
        public TextMeshProUGUI SelfGold => _selfGold;
        private Image _head;

        public static UIUserInfo Add(GameObject go)
        {
            return go.CreateOrGetComponent<UIUserInfo>();
        }

        private void Awake()
        {
            _selfGold = transform.FindChildDepth<TextMeshProUGUI>("GoldNum"); //自身金币
            _head = transform.FindChildDepth<Image>("Head"); //自身金币
            _head.sprite = ILGameManager.Instance.GetHeadIcon();
            HotfixMessageHelper.AddListener(Model.RefreshGold, OnRefreshGold);
        }

        private void OnDestroy()
        {
            HotfixMessageHelper.RemoveListener(Model.RefreshGold, OnRefreshGold);
        }

        private void OnRefreshGold(object data)
        {
            if (data != null && data is ulong gold) _selfGold.SetText($"{gold.ShortNumber()}");
            else _selfGold.SetText($"{Model.Instance.MyGold.ShortNumber()}");
        }
    }
}