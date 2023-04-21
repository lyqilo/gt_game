using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using EasingCore;
using FancyScrollView;
using UnityEngine;

namespace Hotfix.Hall
{
    public partial class HallGameShow
    {
        public class GameItemScrollView : FancyScrollRect<GameItemData, GameItemContext>
        {
            [SerializeField] float cellSize = 80f;
            private GameObject _cellPrefab;
            protected override GameObject CellPrefab => _cellPrefab;
            protected override float CellSize => cellSize;
            public void Init(List<GameItemData> items, GameObject tempcell)
            {
                _cellPrefab ??= tempcell.CreateOrGetComponent<HallIconItem>().gameObject;
                cellContainer ??= transform.FindChildDepth($"View/Content");
                cellSize = _cellPrefab.GetComponent<RectTransform>().rect.width;
                UpdateContents(items);
                ScrollTo(0, 0f, Ease.InOutQuint, Alignment.Upper);
            }

            public void RefreshData()
            {
                Refresh();
            }

            public void UpdateSelection(int index)
            {
                if (Context.SelectedIndex == index)
                {
                    return;
                }

                Context.SelectedIndex = index;
                Refresh();
            }

            public void OnCellClicked(CAction<int> callback)
            {
                Context.OnCellClicked = callback;
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
        }

        [System.Serializable]
        public class GameItemData
        {
            public int GameId;
            public bool IsHide;

            public GameItemData(int gameId, bool isHide)
            {
                GameId = gameId;
                IsHide = isHide;
            }
        }

        public class GameItemContext : FancyGridViewContext
        {
            public int SelectedIndex = -1;
            public CAction<int> OnCellClicked;
        }
    }
}