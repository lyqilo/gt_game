using System.Collections.Generic;
using System.Runtime.InteropServices;
using DG.Tweening;
using UnityEngine;
using UnityEngine.UI;
using Spine;
using Spine.Unity;
using static Hotfix.HallStruct;
using Hotfix.Hall.ItemBox;

namespace Hotfix.Hall
{
    public class WheelPanel : PanelBase
    {
        private Button closeBtn;
        private Transform image1;
        private Transform image2;
        private Button maskCloseBtn;
        private ScrollRect group;
        private GameObject noTask;
        private Transform mainPanel;
        private Transform wheel;
        private Button spinBtn;
        private Button ruleBtn;
        private Button ruleMask;
        private Transform rule;
        private Text turnNum;
        private SkeletonAnimation ske;

        private Transform allContent;
        private Text allItem;

        private Transform myContent;
        private Transform myItem;

        private Toggle tgAll;
        private Toggle tgMy;

        private Transform viewAll;
        private Transform viewMy;
        private SkeletonAnimation rewardAnim;
        private SkeletonAnimation spinAnim;

        public WheelPanel() : base(UIType.Middle, nameof(WheelPanel))
        {
        }

        public override void Create(params object[] args)
        {
            base.Create(args);
            DebugTool.Log("wheelpanel create");
            DebugHelper.Log(LitJson.JsonMapper.ToJson(args[0]));
            Init(args[0] as ACP_SC_TurntableDisplaysInfo);
        }

        protected override void FindComponent()
        {
            mainPanel = transform.FindChildDepth("MainPanel");
            wheel = mainPanel.FindChildDepth("wheel");
            spinBtn = mainPanel.FindChildDepth<Button>("SpinBtn");
            spinAnim = mainPanel.FindChildDepth<SkeletonAnimation>("SpinBtn/Anim");
            closeBtn = mainPanel.FindChildDepth<Button>("CloseBtn");

            ske = mainPanel.FindChildDepth<SkeletonAnimation>("WheelAnim");
            rewardAnim = mainPanel.FindChildDepth<SkeletonAnimation>("Reward");
            turnNum = mainPanel.FindChildDepth<Text>("turnNum");
            allContent = mainPanel.FindChildDepth("Image/all/scro/Viewport/Content");
            allItem = mainPanel.FindChildDepth<Text>("Image/all/item");

            myContent = mainPanel.FindChildDepth("Image/my/scro/Viewport/Content");
            myItem = mainPanel.FindChildDepth<Transform>("Image/my/item");

            tgAll = mainPanel.FindChildDepth<Toggle>("group/all");
            tgMy = mainPanel.FindChildDepth<Toggle>("group/my");

            viewAll = mainPanel.FindChildDepth<Transform>("Image/all");
            viewMy = mainPanel.FindChildDepth<Transform>("Image/my");
            rule = mainPanel.FindChildDepth<Transform>("rule");
            ruleBtn = mainPanel.FindChildDepth<Button>("ruleBtn");
            ruleMask = mainPanel.FindChildDepth<Button>("rule/ruleMask");
        }

        protected override void AddListener()
        {
            closeBtn.onClick.RemoveAllListeners();
            closeBtn.onClick.Add(() =>
            {
                ILMusicManager.Instance.PlayBtnSound();
                UIManager.Instance.Close();
            });

            spinBtn.onClick.RemoveAllListeners();
            spinBtn.onClick.Add(() =>
            {
                spinBtn.interactable = false;
                ILMusicManager.Instance.PlayBtnSound();
                HotfixGameComponent.Instance.Send(DataStruct.PersonalStruct.MDM_3D_PERSONAL_INFO, 44, null,
                    SocketType.Hall);
                //wheel.DORotate(new Vector3(0, 0, 360*10), 10f, DG.Tweening.RotateMode.FastBeyond360).SetEase(Ease.InOutSine);
                //ske.
                //ske.state.SetAnimation(0, "zhongjiang", true);
            });

            tgAll.onValueChanged.RemoveAllListeners();
            tgAll.onValueChanged.AddListener((ison) =>
            {
                viewAll.gameObject.SetActive(ison);
                viewMy.gameObject.SetActive(!ison);
            });
            tgMy.onValueChanged.RemoveAllListeners();
            tgMy.onValueChanged.AddListener((ison) =>
            {
                viewMy.gameObject.SetActive(ison);
                viewAll.gameObject.SetActive(!ison);
            });

            ruleBtn.onClick.RemoveAllListeners();
            ruleBtn.onClick.Add(() =>
            {
                ILMusicManager.Instance.PlayBtnSound();
                rule.gameObject.SetActive(true);
            });
            ruleMask.onClick.RemoveAllListeners();
            ruleMask.onClick.Add(() =>
            {
                ILMusicManager.Instance.PlayBtnSound();
                rule.gameObject.SetActive(false);
            });
        }

        private void updateHistory(List<TurntableHistory> allHistory, List<TurntableHistory> myHistory)
        {
            for (int i = 0; i < allContent.childCount; i++)
            {
                Object.Destroy(allContent.GetChild(i).gameObject);
            }

            for (int i = 0; i < myContent.childCount; i++)
            {
                Object.Destroy(myContent.GetChild(i).gameObject);
            }

            foreach (var val in allHistory)
            {
                Text item = Object.Instantiate(allItem);
                item.transform.SetParent(allContent);
                item.gameObject.SetActive(true);
                item.transform.localPosition = Vector3.zero;
                item.transform.localScale = Vector3.one;
                item.SetText(val.NickName + " won " + val.AmountOfReward.ShortNumber() + " gold");
            }

            foreach (var val in myHistory)
            {
                Transform item = Object.Instantiate(myItem);
                item.transform.SetParent(myContent);
                item.gameObject.SetActive(true);
                item.transform.localPosition = Vector3.zero;
                item.transform.localScale = Vector3.one;
                item.FindChildDepth<Text>("txt").SetText("You has won " + val.AmountOfReward.ShortNumber() + " gold");
                //item.SetText(val.NickName+" won "+val.AmountOfReward+" gold");
            }
        }


        private void Init(ACP_SC_TurntableDisplaysInfo arges)
        {
            int num = 0;
            for (int i = 0; i < arges.TurntableCount.Count; i++)
            {
                num += arges.TurntableCount[i];
            }

            turnNum.SetText(num);
            updateHistory(arges.allhistory, arges.myhistory);
            wheel.rotation = Quaternion.Euler(new Vector3(0, 0, 60));
            ske.AnimationState.SetAnimation(0, "daiji", true);
            rewardAnim.AnimationState.SetAnimation(0, "normal", true);
            this.spinBtn.interactable = num > 0;
            closeBtn.interactable = true;
            spinAnim.AnimationState.SetAnimation(0, num > 0 ? "click" : "unclick", true);
            //arges.allhistory.    
            //allContent
            rule.gameObject.SetActive(false);
        }

        private void onWheelBack(ACP_SC_TurntableRotationRet res)
        {
            ILGameManager.Instance.QuerySelfGold();
            spinBtn.interactable = false;
            closeBtn.interactable = false;
            spinAnim.AnimationState.SetAnimation(0, "unclick", true);
            rewardAnim.AnimationState.SetAnimation(0, "normal", true);
            int num = 0;
            for (int i = 0; i < res.TurntableCount.Count; i++)
            {
                num += res.TurntableCount[i];
            }

            turnNum.SetText(num);
            ILMusicManager.Instance.PlaySound("sping", -1);
            ske.AnimationState.SetEmptyAnimation(0, 0);
            wheel.rotation = Quaternion.Euler(new Vector3(0, 0, 60));
            wheel.DORotate(new Vector3(0, 0, 60 + 360 * 5 + (res.ID + 1) * 30), 5f,
                DG.Tweening.RotateMode.FastBeyond360).SetEase(Ease.InOutSine).onComplete += () =>
            {
                updateHistory(res.allhistory, res.myhistory);
                ske.AnimationState.SetAnimation(0, "zhongjiang", true);
                UIItemBox.Open(res.turn.Type, res.turn.Data);
                spinAnim.AnimationState.SetAnimation(0, num > 0 ? "click" : "unclick", true);
                rewardAnim.AnimationState.SetAnimation(0, "Rewards", true);
                ILMusicManager.Instance.StopSound("sping");
                ILMusicManager.Instance.PlaySound("spinwin");
                ILGameManager.Instance.QuerySelfGold();
                spinBtn.interactable = num > 0;
                closeBtn.interactable = true;
            };
        }

        protected override void AddEvent()
        {
            base.AddEvent();
            HallEvent.TurntableBackInfo += onWheelBack;
        }

        protected override void RemoveEvent()
        {
            base.RemoveEvent();
            HallEvent.TurntableBackInfo -= onWheelBack;
        }
    }
}