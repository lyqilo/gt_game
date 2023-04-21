using FancyScrollView;
using TMPro;
using UnityEngine;
using UnityEngine.U2D;
using UnityEngine.UI;

namespace Hotfix.Hall.LeaderBoard
{
    public class UILeaderBoardItem : FancyScrollRectCell<UILeaderBoard.RankCellData, UILeaderBoard.RankContentData>
    {
        private bool _isinit;
        private Image _rankIcon;
        private TextMeshProUGUI _rankTxt;
        private TextMeshProUGUI _noRankTxt;
        private Image _head;
        private Text _nickName;
        private TextMeshProUGUI _goldNum;
        private UILeaderBoard.RankCellData _data;
        private SpriteAtlas _atlas;
        private Image _background;
        private bool isFixed = false;

        public override void Initialize()
        {
            base.Initialize();
            FindComponent();
        }

        private void FindComponent()
        {
            if (_isinit) return;
            _isinit = true;
            _rankIcon = transform.FindChildDepth<Image>($"RankIcon");
            _rankTxt = transform.FindChildDepth<TextMeshProUGUI>($"RankIcon/Rank");
            _noRankTxt = transform.FindChildDepth<TextMeshProUGUI>($"RankIcon/NoRank");
            _head = transform.FindChildDepth<Image>($"Head");
            _nickName = transform.FindChildDepth<Text>($"NickName");
            _goldNum = transform.FindChildDepth<TextMeshProUGUI>($"Gold");
            _background = transform.FindChildDepth<Image>($"BG");
            _atlas ??= ToolHelper.LoadAsset<SpriteAtlas>(SceneType.Hall, "Hall_LeaderBoard");
        }

        public override void UpdateContent(UILeaderBoard.RankCellData itemData)
        {
            if (_data == itemData && !isFixed) return;
            _data = itemData;
            string spriteName = "paihangbang_Rank_Other";
            if (itemData.Rank <= 3 && itemData.Rank > 0)
            {
                spriteName = $"paihangbang_Rank_{_data.Rank}";
            }

            _rankIcon.sprite = _atlas.GetSprite(spriteName);
            _rankIcon.SetNativeSize();
            _rankIcon.enabled = _data.Rank > 0;
            _rankTxt.gameObject.SetActive(_data.Rank > 3);
            _noRankTxt.gameObject.SetActive(_data.Rank < 0);
            _rankTxt.SetText(_data.Rank.ToString());
            _noRankTxt.SetText("NO\r\nRANKING");
            _nickName.SetText(_data.ItemData.strNickName);
            _goldNum.SetText(_data.ItemData.nGold.ShortNumber());
            _head.sprite = ILGameManager.Instance.GetHeadIcon((uint) _data.ItemData.nHeadID);
            _background.sprite = _atlas.GetSprite(isFixed ? "paihangbang_pic_fixbg" : "paihangbang_pic_bg");
        }

        public void SetFixBack(bool isFix)
        {
            isFixed = isFix;
        }
    }
}