

using DG.Tweening;
using DragonBones;
using Spine.Unity;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using Transform = UnityEngine.Transform;

namespace Hotfix.FQGY
{
    public class FQGY_Result : ILHotfixEntity
    {
        HierarchicalStateMachine hsm;
        List<IState> states;

        private Transform winEffect;
        private Transform winEffectParticles;
        private TextMeshProUGUI winEffectNum;

        private Transform bigEffect;
        private SkeletonGraphic bigEffectAnim;
        private SkeletonGraphic bigEffectGoldAnim;

        private TextMeshProUGUI bigEffectNum;


        protected override void Awake()
        {
            base.Awake();
            FQGY_Event.ShowResult += JW_Event_ShowResult;
        }
        protected override void Start()
        {
            base.Start();
            hsm = new HierarchicalStateMachine(false, gameObject);
            states = new List<IState>();
            states.Add(new IdleState(this, hsm));
            states.Add(new NoWinState(this, hsm));
            states.Add(new NormalWinState(this, hsm));
            states.Add(new BigWinState(this, hsm));
            states.Add(new UltraWinState(this, hsm));

            hsm.Init(states,nameof(IdleState));
        }
        protected override void Update()
        {
            base.Update();
            hsm?.Update();
        }
        protected override void OnDestroy()
        {
            base.OnDestroy();
            FQGY_Event.ShowResult -= JW_Event_ShowResult;
        }

        protected override void FindComponent()
        {

            winEffect = transform.FindChildDepth("Content/Win");
            winEffectParticles = winEffect.FindChildDepth("particles"); //
            winEffectNum = winEffect.FindChildDepth<TextMeshProUGUI>("bg/Text"); //

            bigEffect = transform.FindChildDepth("BigPrize");
            bigEffectGoldAnim = bigEffect.FindChildDepth<SkeletonGraphic>("Gold"); //
            bigEffectAnim = bigEffect.FindChildDepth<SkeletonGraphic>("Win"); //
            bigEffectNum = bigEffect.FindChildDepth<TextMeshProUGUI>("Win/Text"); //

        }
        private void JW_Event_ShowResult()
        {
            if (FQGYEntry.Instance.GameData.ResultData.nWinGold > 0)
            {
                float winRate = (float)FQGYEntry.Instance.GameData.ResultData.nWinGold / (FQGY_DataConfig.ALLLINECOUNT * FQGYEntry.Instance.GameData.CurrentChip);

                if (winRate <= 4)
                {
                    hsm?.ChangeState(nameof(NormalWinState));
                }
                else if (winRate > 4 && winRate <= 10)
                {
                    hsm?.ChangeState(nameof(BigWinState));
                }
                else
                {
                    hsm?.ChangeState(nameof(UltraWinState));
                }
            }
            else
            {
                hsm?.ChangeState(nameof(NoWinState));
            }
        }

        private class IdleState : State<FQGY_Result>
        {
            public IdleState(FQGY_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                owner.winEffect.gameObject.SetActive(false);
                for (int i = 0; i < owner.winEffectParticles.childCount; i++)
                {
                    owner.winEffectParticles.GetChild(i).gameObject.SetActive(false);
                }
                owner.bigEffect.gameObject.SetActive(false);
                FQGYEntry.Instance.FQGY_Event_ShowResultNum(true);
            }
        }
        /// <summary>
        /// 未中奖
        /// </summary>
        public class NoWinState : State<FQGY_Result>
        {
            public NoWinState(FQGY_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            public override void OnEnter()
            {
                base.OnEnter();
                timer = 0;
            }
            public override void Update()
            {
                base.Update();
                timer += Time.deltaTime;
                if (timer >= FQGY_DataConfig.autoNoRewardInterval)
                {
                    FQGY_Event.DispatchShowResultComplete();
                    hsm?.ChangeState(nameof(IdleState));
                }
            }
        }
        private class NormalWinState : State<FQGY_Result>
        {
            public NormalWinState(FQGY_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            bool isStart;
            public override void OnEnter()
            {
                base.OnEnter();
                timer = 0;
                isStart = true;
                int index = Random.Range(0, 2);
                DebugHelper.Log("index====" + index);
                owner.winEffectParticles.GetChild(index).gameObject.SetActive(true);

                owner.winEffectNum.text = "";
                owner.winEffect.gameObject.SetActive(true);
                FQGY_Audio.Instance.PlaySound(FQGY_Audio.BigWin);
                ToolHelper.RunGoal(0, FQGYEntry.Instance.GameData.ResultData.nWinGold, FQGY_DataConfig.winBigGoldChangeRate, delegate (string goal)
                {
                    owner.winEffectNum.text = ToolHelper.ShowRichText(goal);

                }).OnComplete(delegate ()
                {
                    isStart = true;
                    FQGY_Audio.Instance.PlaySound(FQGY_Audio.iconWinEnd);
                });
            }
            public override void Update()
            {
                base.Update();
                if (!isStart) return;
                timer += Time.deltaTime;
                if (timer >= 0.5f)
                {
                    isStart = false;
                    FQGY_Event.DispatchShowResultComplete();
                    hsm?.ChangeState(nameof(IdleState));
                }
            }
        }
        private class BigWinState : State<FQGY_Result>
        {
            public BigWinState(FQGY_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            bool isStart;
            public override void OnEnter()
            {
                base.OnEnter();
                isStart = false;
                timer = 0;
                owner.bigEffectNum.text = "";
                owner.bigEffect.gameObject.SetActive(true);
                FQGY_Audio.Instance.PlaySound(FQGY_Audio.BigWin);
                owner.bigEffectGoldAnim.AnimationState.SetAnimation(0, "Start", false);
                owner.bigEffectGoldAnim.AnimationState.AddAnimation(0, "Loop", true, 0);
                owner.bigEffectGoldAnim.AnimationState.AddAnimation(0, "End", false, 3);

                owner.bigEffectAnim.AnimationState.SetAnimation(0, "bigwin", false);
                owner.bigEffectAnim.AnimationState.AddAnimation(0, "bigwin_loop", true, 0);
                ToolHelper.RunGoal(0, FQGYEntry.Instance.GameData.ResultData.nWinGold, FQGY_DataConfig.winBigGoldChangeRate, delegate (string goal)
                {
                    owner.bigEffectNum.text = ToolHelper.ShowRichText(goal);

                }).OnComplete(delegate ()
                {
                    isStart = true;
                    FQGY_Audio.Instance.PlaySound(FQGY_Audio.iconWinEnd);
                });
            }
            public override void Update()
            {
                base.Update();
                if (!isStart) return;
                timer += Time.deltaTime;
                if (timer >= 1f)
                {
                    isStart = false;
                    FQGY_Event.DispatchShowResultComplete();
                    hsm?.ChangeState(nameof(IdleState));
                }
            }
        }

        private class UltraWinState : State<FQGY_Result>
        {
            public UltraWinState(FQGY_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            bool isStart;
            private string animName;
            public override void OnEnter()
            {
                base.OnEnter();
                isStart = false;
                timer = 0;
                owner.bigEffectNum.text = "";
                owner.bigEffect.gameObject.SetActive(true);
                FQGY_Audio.Instance.PlaySound(FQGY_Audio.SuperWin);
                owner.bigEffectGoldAnim.AnimationState.SetAnimation(0, "Start", false);
                owner.bigEffectGoldAnim.AnimationState.AddAnimation(0, "Loop", true, 0);
                owner.bigEffectGoldAnim.AnimationState.AddAnimation(0, "End", false, 3);
                owner.bigEffectAnim.AnimationState.SetAnimation(0, "bigwin", false);
                owner.bigEffectAnim.AnimationState.AddAnimation(0, "bigwin_loop", true, 0);
                owner.bigEffectAnim.AnimationState.AddAnimation(0, "megawin", true, 0.1f);
                owner.bigEffectAnim.AnimationState.AddAnimation(0, "megawin_loop", true, 0);
                owner.bigEffectAnim.AnimationState.AddAnimation(0, "superwin", true, 0);
                owner.bigEffectAnim.AnimationState.AddAnimation(0, "superwin_loop", true, 0.1f);
                owner.bigEffectAnim.AnimationState.AddAnimation(0, "ultrawin", true, 0);
                owner.bigEffectAnim.AnimationState.AddAnimation(0, "ultrawin_loop", true, 0.1f);

                ToolHelper.RunGoal(0, FQGYEntry.Instance.GameData.ResultData.nWinGold, FQGY_DataConfig.winBigGoldChangeRate, delegate (string goal)
                {
                    owner.bigEffectNum.text = ToolHelper.ShowRichText(goal);

                }).OnComplete(delegate ()
                {
                    isStart = true;
                    FQGY_Audio.Instance.PlaySound(FQGY_Audio.iconWinEnd);
                });

            }

            public override void Update()
            {
                base.Update();
                if (!isStart) return;
                timer += Time.deltaTime;
                if (timer >= 1f)
                {
                    isStart = false;
                    FQGY_Event.DispatchShowResultComplete();
                    hsm?.ChangeState(nameof(IdleState));
                }
            }
        }

    }
}
