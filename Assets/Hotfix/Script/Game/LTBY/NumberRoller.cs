using DG.Tweening;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.LTBY
{
    public class NumberRoller : ILHotfixEntity
    {
        public Text _bindText;
        public TextMeshProUGUI _bindTMPText;
        private bool isRich;

        public bool _useSplit;

        private long _baseNum;

        private long _deltaNum;

        private long _toNum;

        private Tweener key = null;

        private bool isTMP;

        private bool isInit = false;

        public string text
        {
            get { return _baseNum.ToString(); }
            set
            {
                FindComponent();
                if (_useSplit)
                {
                    if (isTMP)
                        _bindTMPText.text = isRich ? value.ShowRichText(true) : ToolHelper.ShowThousandText(value);
                    else _bindText.text = ToolHelper.ShowThousandText(value);
                }
                else
                {
                    if (isTMP) _bindTMPText.text = isRich ? $"{value}".ShowRichText() : $"{value}";
                    else _bindText.text = $"{value}";
                }
            }
        }

        protected override void FindComponent()
        {
            base.FindComponent();
            if(isInit) return;
            isTMP = false;
            _bindText = gameObject.GetComponent<Text>();
            if (_bindText != null) return;
            _bindTMPText = gameObject.GetComponent<TextMeshProUGUI>();
            isTMP = true;
            isInit = true;
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            if (key == null || !key.IsActive()) return;
            key?.Kill();
            key = null;
        }

        public void Init(bool isSplite = false, bool isRich = true)
        {
            _useSplit = isSplite;
            this.isRich = isRich;
            _toNum = 0;
            _deltaNum = 0;
            _baseNum = 0;
            FindComponent();
        }

        public void RollBy(long deltaNum, float time)
        {
            _toNum += deltaNum;
            if (key != null && key.IsActive()) key?.Kill();
            _baseNum = _deltaNum;
            key = DOTween.To(value =>
            {
                int v = Mathf.CeilToInt(value);
                if (_useSplit)
                {
                    if (isTMP)
                    {
                        if (_bindTMPText == null) return;
                        _bindTMPText.text = isRich ? v.ShortNumber().ShowRichText() : v.ShortNumber();
                    }
                    else
                    {
                        if (_bindText == null) return;
                        _bindText.text = v.ShortNumber();
                    }
                }
                else
                {
                    if (isTMP)
                    {
                        if (_bindTMPText == null) return;
                        _bindTMPText.text = isRich ? v.ShortNumber(false).ShowRichText() : v.ShortNumber(false);
                    }
                    else
                    {
                        if (_bindText == null) return;
                        _bindText.text = v.ShortNumber(false);
                    }
                }
            }, _baseNum, _toNum, time).SetEase(Ease.Linear).OnComplete(() =>
            {
                key = null;
                if (_useSplit)
                {
                    if (isTMP)
                    {
                        if (_bindTMPText == null) return;
                        _bindTMPText.text = isRich ? _toNum.ShortNumber().ShowRichText() : _toNum.ShortNumber();
                    }
                    else
                    {
                        if (_bindText == null) return;
                        _bindText.text = _toNum.ShortNumber();
                    }
                }
                else
                {
                    if (isTMP)
                    {
                        if (_bindTMPText == null) return;
                        _bindTMPText.text = isRich ? _toNum.ShortNumber(false).ShowRichText() : _toNum.ShortNumber(false);
                    }
                    else
                    {
                        if (_bindText == null) return;
                        _bindText.text = _toNum.ShortNumber(false);
                    }
                }
            });
            key?.SetAutoKill();
        }

        public void RollTo(long to, float time)
        {
            _toNum = to;
            if (key != null && key.IsActive()) key?.Kill();
            _baseNum = _deltaNum;
            key = DOTween.To(value =>
            {
                int v = Mathf.CeilToInt(value);
                if (_useSplit)
                {
                    if (isTMP)
                    {
                        if (_bindTMPText == null) return;
                        _bindTMPText.text = isRich ? v.ShortNumber().ShowRichText() : v.ShortNumber();
                    }
                    else
                    {
                        if (_bindText == null) return;
                        _bindText.text = v.ShortNumber();
                    }
                }
                else
                {
                    if (isTMP)
                    {
                        if (_bindTMPText == null) return;
                        _bindTMPText.text = isRich ? v.ShortNumber(false).ShowRichText() : v.ShortNumber(false);
                    }
                    else
                    {
                        if (_bindText == null) return;
                        _bindText.text = v.ShortNumber(false);
                    }
                }
            }, _baseNum, _toNum, time).OnComplete(() =>
            {
                key = null;
                if (_useSplit)
                {
                    if (isTMP)
                    {
                        if (_bindTMPText == null) return;
                        _bindTMPText.text = isRich ? _toNum.ShortNumber().ShowRichText() : _toNum.ShortNumber();
                    }
                    else
                    {
                        if (_bindText == null) return;
                        _bindText.text = _toNum.ShortNumber();
                    }
                }
                else
                {
                    if (isTMP)
                    {
                        if (_bindTMPText == null) return;
                        _bindTMPText.text = isRich ? _toNum.ShortNumber(false).ShowRichText() : _toNum.ShortNumber(false);
                    }
                    else
                    {
                        if (_bindText == null) return;
                        _bindText.text = _toNum.ShortNumber(false);
                    }
                }
            });
            key?.SetAutoKill();
        }

        public void RollFromTo(long from, long to, float time)
        {
            _baseNum = from;
            _toNum = to;
            if (key != null && key.IsActive()) key?.Kill();
            if (_useSplit)
            {
                if (isTMP)
                {
                    if (_bindTMPText == null) return;
                    _bindTMPText.text = isRich ? from.ShortNumber().ShowRichText() : from.ShortNumber();
                }
                else
                {
                    if (_bindText == null) return;
                    _bindText.text = from.ShortNumber();
                }
            }
            else
            {
                if (isTMP)
                {
                    if (_bindTMPText == null) return;
                    _bindTMPText.text = isRich ? from.ShortNumber(false).ShowRichText() : from.ShortNumber(false);
                }
                else
                {
                    if (_bindText == null) return;
                    _bindText.text = from.ShortNumber(false);
                }
            }

            key = DOTween.To(value =>
            {
                int v = Mathf.CeilToInt(value);
                if (_useSplit)
                {
                    if (isTMP)
                    {
                        if (_bindTMPText == null) return;
                        _bindTMPText.text = isRich ? v.ShortNumber().ShowRichText() :v.ShortNumber();
                    }
                    else
                    {
                        if (_bindText == null) return;
                        _bindText.text = v.ShortNumber();
                    }
                }
                else
                {
                    if (isTMP)
                    {
                        if (_bindTMPText == null) return;
                        _bindTMPText.text = isRich ? v.ShortNumber(false).ShowRichText() : v.ShortNumber(false);
                    }
                    else
                    {
                        if (_bindText == null) return;
                        _bindText.text = v.ShortNumber(false);
                    }
                }
            }, _baseNum, _toNum, time).OnComplete(() =>
            {
                key = null;

                if (_useSplit)
                {
                    if (isTMP)
                    {
                        if (_bindTMPText == null) return;
                        _bindTMPText.text = isRich ? _toNum.ShortNumber().ShowRichText() : _toNum.ShortNumber();
                    }
                    else
                    {
                        if (_bindText == null) return;
                        _bindText.text = _toNum.ShortNumber();
                    }
                }
                else
                {
                    if (isTMP)
                    {
                        if (_bindTMPText == null) return;
                        _bindTMPText.text = isRich ? _toNum.ShortNumber(false).ShowRichText() : _toNum.ShortNumber(false);
                    }
                    else
                    {
                        if (_bindText == null) return;
                        _bindText.text = _toNum.ShortNumber(false);
                    }
                }
            });
            key?.SetAutoKill();
        }

        public long GetFinalNum()
        {
            return _toNum;
        }
    }
}