using System.Collections.Generic;
using EasingCore;
using FancyScrollView;
using LuaFramework;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Hall.Share
{
    public partial class UIShareInviteReward
    {
        public class ScrollView : FancyScrollRect<Data, Context>
        {
            private GameObject leftTag;
            private GameObject rightTag;
            private ScrollRect _progressScroll;
            private Slider _progressSlider;
            private GameObject _cellPrefab;
            private float _cellSize;
            protected override GameObject CellPrefab => _cellPrefab;
            protected override float CellSize => _cellSize;

            public int DataCount => ItemsSource.Count;

            public float PaddingTop
            {
                get => paddingHead;
                set
                {
                    paddingHead = value;
                    Relayout();
                }
            }

            public float PaddingBottom
            {
                get => paddingTail;
                set
                {
                    paddingTail = value;
                    Relayout();
                }
            }

            public float Spacing
            {
                get => spacing;
                set
                {
                    spacing = value;
                    Relayout();
                }
            }

            public void Init(List<Data> items, CAction clickCall)
            {
                leftTag ??= transform.FindChildDepth("Left").gameObject;
                rightTag ??= transform.FindChildDepth("Right").gameObject;
                _progressScroll ??= transform.FindChildDepth<ScrollRect>("ProgressView");
                _progressSlider ??= _progressScroll.transform.FindChildDepth<Slider>("Progress");
                _cellPrefab = transform.Find($"Item").gameObject;
                _cellPrefab.CreateOrGetComponent<Cell>();
                cellContainer ??= transform.FindChildDepth($"View/Content");
                _cellSize = _cellPrefab.GetComponent<RectTransform>().rect.height;
                _progressScroll.content.sizeDelta = new Vector2(_cellSize * items.Count, 20);
                Context.SelectedCall = clickCall;
                Scroller.OnValueChangedCall = OnValueChanged;
                UpdateData(items);
                Relayout();

                int progressIndex = -1;
                for (int i = 0; i < DataCount; i++)
                {
                    if (items[i].Cfg.InviteNum > items[i].InviteNum) continue;
                    progressIndex++;
                }

                float progress = (_cellSize / 2 + progressIndex * _cellSize) / (_cellSize * DataCount);
                if (progress < 0) progress = 0;
                if (progressIndex >= items.Count) progress = 1;
                _progressSlider.value = progress;
                ScrollTo(progressIndex, 0f, Ease.InOutQuint, Alignment.Middle);
                leftTag.SetActive(progressIndex > 0);
                rightTag.SetActive(progressIndex < DataCount);
            }

            private void OnValueChanged(float obj)
            {
                if (DataCount <= 1) _progressScroll.horizontalNormalizedPosition = 0;
                else _progressScroll.horizontalNormalizedPosition = obj / (DataCount - 1);
                leftTag.SetActive(obj > 0);
                rightTag.SetActive(obj < DataCount - 1);
            }

            public void UpdateData(IList<Data> items)
            {
                UpdateContents(items);
            }

            public void ScrollTo(int index, float duration, Ease easing, Alignment alignment = Alignment.Middle)
            {
                UpdateSelection(index);
                ScrollTo(index, duration, easing, GetAlignment(alignment));
            }

            public void JumpTo(int index, Alignment alignment = Alignment.Middle)
            {
                UpdateSelection(index);
                JumpTo(index, GetAlignment(alignment));
            }

            public void RefreshData()
            {
                Refresh();
            }

            float GetAlignment(Alignment alignment)
            {
                switch (alignment)
                {
                    case Alignment.Upper: return 0.0f;
                    case Alignment.Middle: return 0.5f;
                    case Alignment.Lower: return 1.0f;
                    default: return GetAlignment(Alignment.Middle);
                }
            }

            void UpdateSelection(int index)
            {
                if (Context.SelectedIndex == index)
                {
                    return;
                }

                Context.SelectedIndex = index;
                Refresh();
            }
        }

        public class Data
        {
            public HallStruct.sInviteAwardCfg Cfg { get; set; }
            public int CurrentPickIndex { get; set; }
            public int InviteNum { get; set; }

            public Data(HallStruct.sInviteAwardCfg cfg, int pickIndex, int inviteNum)
            {
                Cfg = cfg;
                CurrentPickIndex = pickIndex;
                InviteNum = inviteNum;
            }
        }

        public class Context : FancyScrollRectContext
        {
            public int SelectedIndex { get; set; } = -1;
            public CAction SelectedCall { get; set; }
        }

        public class Cell : FancyScrollRectCell<Data, Context>
        {
            private GameObject claimed;
            private GameObject notClaimed;
            private Toggle hasReach;
            private TextMeshProUGUI desc;
            private Button claimBtn;

            public override void Initialize()
            {
                base.Initialize();
                claimed ??= transform.FindChildDepth("RewardNoClaim").gameObject;
                notClaimed ??= transform.FindChildDepth("RewardNoClaimed").gameObject;
                hasReach ??= transform.FindChildDepth<Toggle>("Reach");
                desc ??= transform.FindChildDepth<TextMeshProUGUI>("Desc");
                claimBtn ??= transform.FindChildDepth<Button>("ClaimBtn");

                claimBtn.onClick.RemoveAllListeners();
                claimBtn.onClick.Add(OnClickClaim);
            }

            private void OnClickClaim()
            {
                Context.SelectedIndex = Index;
                Context.SelectedCall?.Invoke();
            }

            public override void UpdateContent(Data itemData)
            {
                claimed.SetActive(itemData.CurrentPickIndex - 1 < Index);
                notClaimed.SetActive(itemData.CurrentPickIndex - 1 >= Index);
                hasReach.isOn = itemData.Cfg.InviteNum <= itemData.InviteNum;
                desc.SetText($"invite {itemData.Cfg.InviteNum} friend");
                claimBtn.gameObject.SetActive(itemData.CurrentPickIndex - 1 < Index &&
                                              itemData.Cfg.InviteNum <= itemData.InviteNum);
            }
        }
    }
}