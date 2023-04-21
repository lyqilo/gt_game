using System;
using System.Collections.Generic;
using DG.Tweening;
using Hotfix.Hall.ItemBox;
using UnityEngine;
using UnityEngine.UI;
using static Hotfix.HallStruct;
using System.Collections;
using FancyScrollView;
using Object = UnityEngine.Object;
using Random = UnityEngine.Random;

namespace Hotfix.Hall.Activity
{
    public partial class ActivityPanel : PanelBase
    {
        private Scroller _titleScroller;
        private Scroller _rankScroller;
        private TitleScrollView _titleScroll;
        private Transform titleList;
        private Transform rightGroup;
        private Button closeBtn;
        private Transform mainPanel;
        private Button[] btnList = new Button[4];
        private int selectIndex = 1;

        private Button wheelBtn;

        private Sequence[] waitsequence = new Sequence[3];
        private Transform leftGroup;

        enum ActivityType
        {
            Online,
            Login,
            Recharge,
            Bet,
        }

        public ActivityPanel() : base(UIType.Middle, nameof(ActivityPanel))
        {
        }

        public override void Create(params object[] args)
        {
            base.Create(args);
            // Init();
            _titleScroller = CreateScroller(titleList.gameObject,
                titleList.FindChildDepth("Viewport").GetComponent<RectTransform>(), _titleScroller);
            _titleScroll ??= titleList.gameObject.CreateOrGetComponent<TitleScrollView>();
            List<TitleData> items = new List<TitleData>();
            var group = Model.Instance.Titles;
            for (int i = 0; i < group.Count; i++)
            {
                items.Add(new TitleData(group[i]));
            }

            for (int i = 0; i < rightGroup.childCount; i++)
            {
                Transform child = rightGroup.GetChild(i);
                child.gameObject.SetActive(true);
                child.gameObject.AddComponent(Type.GetType($"Hotfix.Hall.Activity.UI{child.gameObject.name}"));
            }

            initSign(args[0] as ACP_SC_SignCheck_QueryRet);

            _titleScroll.Init(items, OnSelectTitle);
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            HotfixMessageHelper.PostHotfixEvent(PopTaskSystem.Model.CompleteShowPop, Model.Instance.PopName);
        }

        protected override void FindComponent()
        {
            closeBtn = transform.FindChildDepth<Button>($"CloseBtn");
            leftGroup = transform.FindChildDepth($"Left");
            rightGroup = transform.FindChildDepth($"Right");

            titleList = leftGroup.FindChildDepth($"TitleList");

            wheelBtn = transform.FindChildDepth<Button>("WheelBtn");
        }

        protected override void AddEvent()
        {
            base.AddEvent();

            HallEvent.CodeRebate += initBet;
            HallEvent.SignResInfo += signBack;
            HallEvent.sActiveInfo += onTaskBack;
            HallEvent.sActiveGetInfo += onTaskGetBack;
            HallEvent.CodeRebateRes += onGetBet;
        }

        protected override void RemoveEvent()
        {
            base.RemoveEvent();
            HallEvent.CodeRebate -= initBet;
            HallEvent.SignResInfo -= signBack;
            HallEvent.sActiveInfo -= onTaskBack;
            HallEvent.sActiveGetInfo -= onTaskGetBack;
            HallEvent.CodeRebateRes -= onGetBet;
        }

        protected override void AddListener()
        {
            closeBtn.onClick.RemoveAllListeners();
            closeBtn.onClick.Add(() =>
            {
                ILMusicManager.Instance.PlayBtnSound();
                UIManager.Instance.Close();
            });

            wheelBtn.onClick.RemoveAllListeners();
            wheelBtn.onClick.Add(() =>
            {
                ILMusicManager.Instance.PlayBtnSound();
                UIManager.Instance.Close();
                HotfixGameComponent.Instance.Send(DataStruct.PersonalStruct.MDM_3D_PERSONAL_INFO, 42, null,
                    SocketType.Hall);
            });
        }

        private Scroller CreateScroller(GameObject scrollerObj, RectTransform viewport, Scroller scroller)
        {
            scroller ??= scrollerObj.CreateOrGetComponent<Scroller>();
            scroller.Viewport ??= viewport;
            scroller.SnapEnabled = false;
            scroller.Draggable = true;
            scroller.MovementType = MovementType.Clamped;
            scroller.ScrollDirection = ScrollDirection.Vertical;
            return scroller;
        }

        private void OnSelectTitle(byte index)
        {
            _titleScroll.RefreshData();
            for (int i = 0; i < rightGroup.childCount; i++)
            {
                IReward reward = rightGroup.GetChild(i).GetComponent<IReward>();
                if (i == index) reward.Show();
                else reward.Hide();
            }
        }

        private void onGetBet(ACP_SC_DBR_3D_Res_CodeRebateBeign info)
        {
            DebugTool.Log("打码结果返回");
            rightGroup.FindChildDepth<UIBettingReward>("BettingReward").OnGetData(info);
        }

        private void onTaskGetBack(HallStruct.ACP_SC_sActiveInfoSCPick info)
        {
            DebugTool.Log("任务领取返回");
            ILGameManager.Instance.QuerySelfGold();
            if (info.ActiveID == 3)
            {
                rightGroup.FindChildDepth<UIOnLineReward>("OnLineReward").Show();
            }
            else if (info.ActiveID == 1)
            {
                rightGroup.FindChildDepth<UIRechargeReward>("RechargeReward").Show();
            }

            if (info.IsPick == 1)
            {
                UIItemBox.Open(info.RewardType, info.Reward);
            }
        }


        private void initSign(ACP_SC_SignCheck_QueryRet info)
        {
            rightGroup.FindChildDepth<UILoginReward>("LoginReward").Init(info);
        }

        private void initBet(ACP_SC_DBR_3D_Res_CodeRebateQuery info)
        {
            rightGroup.FindChildDepth<UIBettingReward>("BettingReward").SetData(info);
        }

        private void signBack(ACP_SC_SignCheck_Begin info)
        {
            DebugTool.Log("签到返回");
            rightGroup.FindChildDepth<UILoginReward>("LoginReward").SignBack(info);
        }

        private void onTaskBack(HallStruct.ACP_SC_sActiveInfoSC info)
        {
            int id = info.data[0].ActiveID;
            switch (id)
            {
                case 1:
                    rightGroup.FindChildDepth<UIRechargeReward>("RechargeReward").InitRecharge(info);
                    break;
                case 3:
                    rightGroup.FindChildDepth<UIOnLineReward>("OnLineReward").InitOnline(info);
                    break;
            }
        }
    }
}