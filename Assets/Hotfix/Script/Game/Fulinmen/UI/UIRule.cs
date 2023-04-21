using System;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Fulinmen
{
    public class UIRule : MonoBehaviour
    {
        public static UIRule Add(GameObject go)
        {
            UIRule rule = go.CreateOrGetComponent<UIRule>();
            rule.Hide();
            return rule;
        }

        private Button _leftShowBtn;
        private Button _rightShowBtn;
        private Button _closeRuleBtn;
        private ScrollRect _ruleList;
        private TextMeshProUGUI _page;

        private int _currentPos;
        private int _totalPos;

        private void Awake()
        {
            FindComponent();
            AddListener();
        }

        private void FindComponent()
        {
            _ruleList ??= transform.FindChildDepth<ScrollRect>("Content/RuleList"); //规则子界面
            _leftShowBtn ??= transform.FindChildDepth<Button>("Content/LeftBtn");
            _rightShowBtn ??= transform.FindChildDepth<Button>("Content/RightBtn");
            _closeRuleBtn ??= transform.FindChildDepth<Button>("Content/BackBtn");
            _page ??= transform.FindChildDepth<TextMeshProUGUI>("Page");
        }

        private void AddListener()
        {
            _closeRuleBtn.onClick.RemoveAllListeners();
            _closeRuleBtn.onClick.AddListener(CloseRule);
            _leftShowBtn.onClick.RemoveAllListeners();
            _leftShowBtn.onClick.AddListener(ClickLeftBtn);
            _rightShowBtn.onClick.RemoveAllListeners();
            _rightShowBtn.onClick.AddListener(ClickRightBtn);
        }

        private void OnEnable()
        {
            _currentPos = 0;
            _ruleList.horizontalNormalizedPosition = 0;
            _totalPos = _ruleList.content.childCount - 1;
            _page.SetText($"{_currentPos + 1}/{_totalPos + 1}");
        }

        public void Show()
        {
            gameObject.SetActive(true);
        }

        public void Hide()
        {
            gameObject.SetActive(false);
        }

        private void ClickRightBtn()
        {
            Model.Instance.PlaySound(Model.Sound.Button.ToString());
            _currentPos += 1;
            if (_currentPos > _totalPos) _currentPos = 0;

            _ruleList.horizontalNormalizedPosition = (float) _currentPos / _totalPos;
            _page.SetText($"{_currentPos + 1}/{_totalPos + 1}");
        }

        private void ClickLeftBtn()
        {
            Model.Instance.PlaySound(Model.Sound.Button.ToString());
            _currentPos -= 1;
            if (_currentPos < 0) _currentPos = _totalPos;
            _ruleList.horizontalNormalizedPosition = (float) _currentPos / _totalPos;
            _page.SetText($"{_currentPos + 1}/{_totalPos + 1}");
        }

        private void CloseRule()
        {
            Model.Instance.PlaySound(Model.Sound.Button.ToString());
            Hide();
        }
    }
}