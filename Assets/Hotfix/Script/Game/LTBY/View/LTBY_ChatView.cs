using UnityEngine;
using LuaFramework;
using DG.Tweening;
using UnityEngine.UI;
using Spine.Unity;

namespace Hotfix.LTBY
{
    public class LTBY_ChatView : LTBY_ViewBase
    {
        private Transform chatPlane;
        private int showUiActionKey;

        public LTBY_ChatView() : base(nameof(LTBY_ChatView))
        {
        }

        protected override void OnCreate(params object[] args)
        {
            base.OnCreate(args);
            transform.GetComponent<RectTransform>().offsetMin = Vector2.zero;
            transform.GetComponent<RectTransform>().offsetMax = Vector2.zero;
            AddClick(FindChild("BtnChat"), () => { OpenChatPlane(); });

            this.chatPlane = FindChild("ChatFrame");
            AddClick(this.chatPlane, () => { this.chatPlane.gameObject.SetActive(false); });

            //防止点击穿透

            EventTriggerHelper hepler = EventTriggerHelper.Get(this.chatPlane.FindChildDepth("Board").gameObject);
            hepler.onDown = (obj, eventData) => { };
            int[] txtkeys = ChatConfig.Text.GetDictionaryKeys();
            for (int i = 0; i < txtkeys.Length; i++)
            {
                AddTextContent(txtkeys[i], ChatConfig.Text[txtkeys[i]]);
            }

            int[] emojikeys = ChatConfig.Emoji.GetDictionaryKeys();

            for (int i = 0; i < emojikeys.Length; i++)
            {
                AddEmojiContent(emojikeys[i], ChatConfig.Emoji[emojikeys[i]]);
            }

            this.showUiActionKey = 0;

            RegisterEvent();
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            UnregisterEvent();
        }

        private void RegisterEvent()
        {
            LTBY_Event.ShowGameUi += LTBY_Event_ShowGameUi;
            //    GC.Notification.NetworkRegister(self, "SCChat", function(_, data)

            //self: ResponseChatMsg(data);
            //    end);
        }

        private void LTBY_Event_ShowGameUi(bool flag)
        {
            ShowGameUi(flag);
        }

        private void UnregisterEvent()
        {
            LTBY_Event.ShowGameUi -= LTBY_Event_ShowGameUi;
        }

        private void ShowGameUi(bool flag)
        {
            if (this.showUiActionKey > 0) return;
            if (flag)
            {
                Tween tween = transform
                    .DOBlendableLocalMoveBy(new Vector2(-GameViewConfig.ShowGameUi.Dis, 0),
                        GameViewConfig.ShowGameUi.Time).SetEase(Ease.OutBack).OnKill(() =>
                    {
                        StopAction(this.showUiActionKey);
                        this.showUiActionKey = 0;
                    }).SetLink(transform.gameObject);
                this.showUiActionKey = RunAction(tween);
            }
            else
            {
                Tween tween = transform
                    .DOBlendableLocalMoveBy(new Vector2(GameViewConfig.ShowGameUi.Dis, 0),
                        GameViewConfig.ShowGameUi.Time).SetEase(Ease.InBack).OnKill(() =>
                    {
                        StopAction(this.showUiActionKey);
                        this.showUiActionKey = 0;
                    }).SetLink(transform.gameObject);
                this.showUiActionKey = RunAction(tween);
            }
        }

        private void AddTextContent(int index, string str)
        {
            Transform parent = this.chatPlane.FindChildDepth("TextView/Viewport/Content");
            Transform content = LTBY_Extend.Instance.LoadPrefab("LTBY_ChatItem", parent);
            content.FindChildDepth<Text>("Text").text = str;
            AddClick(content, () => { RequestChatMsg(1, index); });
        }

        private void AddEmojiContent(int index, string str)
        {
            Transform parent = this.chatPlane.FindChildDepth("EmojiView/Viewport/Content");
            Transform content = LTBY_Extend.Instance.LoadPrefab(str, parent);
            AddClick(content, () => { RequestChatMsg(2, index); });
        }

        private void RequestChatMsg(int msgType, int index)
        {
            this.chatPlane.gameObject.SetActive(false);
            //        local data = {
            //    msg_type = msgType,
            //    msg_idx = index,
            //};
            //        GC.NetworkRequest.Request("CSChat", data);
            //data.chair_idx = LTBY_GameView.GameInstance.chairId;
            ResponseChatMsg(LTBY_GameView.GameInstance.chairId, msgType, index);
        }

        private void ResponseChatMsg(int chair_idx, int msg_type, int msg_idx)
        {
            int chairId = LTBY_GameView.GameInstance.GetPlayerPosition(chair_idx);
            int msgType = msg_type;
            int index = msg_idx;

            if (msgType == 1)
            {
                ShowTextMsg(chairId, index);
            }
            else
            {
                ShowEmojiMsg(chairId, index);
            }
        }

        private void ShowTextMsg(int chairId, int index)
        {
            RectTransform player = FindChild<RectTransform>($"Player{chairId}");
            player.gameObject.SetActive(true);
            player.sizeDelta = new Vector2(290, 110);
            player.FindChildDepth("Emoji").gameObject.SetActive(false);
            Text text = player.FindChildDepth<Text>("Text");
            text.gameObject.SetActive(true);
            text.text = ChatConfig.Text[index];
            StopTimer($"Player{chairId}");
            StartTimer($"Player{chairId}", 3, () => { player.gameObject.SetActive(false); }, 1);
        }

        private void ShowEmojiMsg(int chairId, int index)
        {
            RectTransform player = FindChild<RectTransform>($"Player{chairId}");
            player.gameObject.SetActive(true);
            player.sizeDelta = new Vector2(130, 110);
            player.FindChildDepth("Text").gameObject.SetActive(false);
            Transform parent = player.FindChildDepth("Emoji");
            parent.gameObject.SetActive(true);

            LTBY_Extend.Instance.DestroyAllChildren(parent);

            Transform emoji = LTBY_Extend.Instance.LoadPrefab(ChatConfig.Emoji[index], parent);
            SkeletonGraphic skeleton = emoji.FindChildDepth<SkeletonGraphic>("Skeleton");
            if (skeleton != null)
            {
                skeleton.AnimationState.SetAnimation(0, "stand", false);
            }

            StopTimer($"Player{chairId}");
            StartTimer($"Player{chairId}", 2, () => { player.gameObject.SetActive(false); }, 1);
        }

        private void OpenChatPlane()
        {
            chatPlane.gameObject.SetActive(true);
        }
    }
}