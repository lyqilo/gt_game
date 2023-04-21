

using DG.Tweening;
using DragonBones;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using Transform = UnityEngine.Transform;

namespace Hotfix.TouKui
{
    /// <summary>
    /// 得奖类型
    /// </summary>
    public enum ResultType
    {
        None,
        NormalWin,
        BigWin,
        SuperWin,
        MegaWin,
    }
    public class TouKui_Result : ILHotfixEntity
    {
        HierarchicalStateMachine hsm;
        List<IState> states;
        private Transform normalEffect;
        private TextMeshProUGUI normalEffectNum;
        private Transform bigEffect;
        private UnityArmatureComponent bigEffectAnim;
        private TextMeshProUGUI bigEffectNum;
        private Transform superEffect;
        private UnityArmatureComponent superEffectAnim;
        private TextMeshProUGUI superEffectNum;
        private Transform megaEffect;
        private UnityArmatureComponent megaEffectAnim;
        private TextMeshProUGUI megaEffectNum;

        protected override void AddEvent()
        {
            base.AddEvent();
            TouKui_Event.ShowResult += TouKui_Event_ShowResult;
            HotfixActionHelper.ReconnectGame += EventHelper_ReconnectGame;
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
            states.Add(new SuperWinState(this, hsm));
            states.Add(new MegaWinState(this, hsm));
            hsm.Init(states,nameof(IdleState));
        }
        protected override void Update()
        {
            base.Update();
            hsm?.Update();
        }

        protected override void RemoveEvent()
        {
            base.RemoveEvent();
            TouKui_Event.ShowResult -= TouKui_Event_ShowResult;
            HotfixActionHelper.ReconnectGame -= EventHelper_ReconnectGame;
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            hsm?.CurrentState.OnExit();
        }

        protected override void FindComponent()
        {
            base.FindComponent();
            normalEffect = transform.FindChildDepth("NormalWin");
            normalEffectNum = normalEffect.FindChildDepth<TextMeshProUGUI>("Num"); //本次获得金币
            bigEffect = transform.FindChildDepth("BigWin");
            bigEffectAnim = bigEffect.FindChildDepth<UnityArmatureComponent>("Anim"); //本次获得金币
            bigEffectNum = bigEffect.FindChildDepth<TextMeshProUGUI>("Num"); //本次获得金币
            superEffect = transform.FindChildDepth("SuperWin");
            superEffectAnim = superEffect.FindChildDepth<UnityArmatureComponent>("Anim"); //本次获得金币
            superEffectNum = superEffect.FindChildDepth<TextMeshProUGUI>("Num"); //本次获得金币
            megaEffect = transform.FindChildDepth("SuperWin");
            megaEffectAnim = megaEffect.FindChildDepth<UnityArmatureComponent>("Anim"); //本次获得金币
            megaEffectNum = megaEffect.FindChildDepth<TextMeshProUGUI>("Num"); //本次获得金币
        }

        private void TouKui_Event_ShowResult()
        {
            if (TouKuiEntry.Instance.GameData.ResultData.nWinGold > 0)
            {
                float winRate = (float)TouKuiEntry.Instance.GameData.ResultData.nWinGold / (TouKui_DataConfig.ALLLINECOUNT * TouKuiEntry.Instance.GameData.CurrentChip);

                if (winRate <= 5)
                {
                    hsm?.ChangeState(nameof(NormalWinState));
                }
                else if (winRate > 5 && winRate <= 10)
                {
                    hsm?.ChangeState(nameof(BigWinState));
                }
                else if (winRate > 10 && winRate < 15)
                {
                    hsm?.ChangeState(nameof(SuperWinState));
                }
                else
                {
                    hsm?.ChangeState(nameof(MegaWinState));
                }
            }
            else
            {
                hsm?.ChangeState(nameof(NoWinState));
            }
        }

        private void EventHelper_ReconnectGame()
        {
            hsm?.ChangeState(nameof(IdleState));
        }
        private class IdleState : State<TouKui_Result>
        {
            public IdleState(TouKui_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.normalEffect.gameObject.SetActive(false);
                owner.bigEffect.gameObject.SetActive(false);
                owner.superEffect.gameObject.SetActive(false);
                owner.megaEffect.gameObject.SetActive(false);
            }
        }

        /// <summary>
        /// 未中奖
        /// </summary>
        private class NoWinState : State<TouKui_Result>
        {
            public NoWinState(TouKui_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
                if (timer >= TouKui_DataConfig.autoNoRewardInterval)
                {
                    TouKui_Event.DispatchShowResultComplete(false);
                    hsm?.ChangeState(nameof(IdleState));
                }
            }
        }
        private class NormalWinState : State<TouKui_Result>
        {
            public NormalWinState(TouKui_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            bool isStart;
            public override void OnEnter()
            {
                base.OnEnter();
                isStart = false;
                timer = 0;
                owner.normalEffectNum.text = 0.ShortNumber().ShowRichText();
                owner.normalEffect.gameObject.SetActive(true);
                TouKui_Audio.Instance.PlaySound(TouKui_Audio.NormalWin);
                ToolHelper.RunGoal(0, TouKuiEntry.Instance.GameData.ResultData.nWinGold, TouKui_DataConfig.winGoldChangeRate, delegate (string goal)
                {
                    long.TryParse(goal, out long num);
                    owner.normalEffectNum.text = num.ShortNumber().ShowRichText();
                }).OnComplete(delegate()
                {
                    isStart = true;
                });
                TouKui_Event.DispatchShowLens(ResultType.NormalWin);
            }
            public override void Update()
            {
                base.Update();
                if (!isStart) return;
                timer += Time.deltaTime;
                if (!(timer >= 1)) return;
                isStart = false;
                TouKui_Event.DispatchShowResultComplete(true);
                hsm?.ChangeState(nameof(IdleState));
            }
            public override void OnExit()
            {
                base.OnExit();
                owner.normalEffect.gameObject.SetActive(false);
            }

        }
        private class BigWinState : State<TouKui_Result>
        {
            public BigWinState(TouKui_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            private string animName;
            public override void OnEnter()
            {
                base.OnEnter();
                owner.bigEffectNum.text = 0.ShortNumber().ShowRichText();
                owner.bigEffect.gameObject.SetActive(true);
                TouKui_Audio.Instance.PlaySound(TouKui_Audio.BigWin);
                owner.bigEffectAnim.AddDBEventListener(EventObject.COMPLETE, this.OnAnimationEventHandler);
                animName = "bigwin1";
                owner.bigEffectAnim.dbAnimation.Play(animName, 1); 
                TouKui_Event.DispatchShowLens(ResultType.BigWin);

            }

            private void OnAnimationEventHandler(string type, EventObject eventObject)
            {
                if (animName.Equals("bigwin1"))
                {
                    animName = "bigwin2";
                    owner.bigEffectAnim.dbAnimation.Play(animName,1);
                    ToolHelper.RunGoal(0, TouKuiEntry.Instance.GameData.ResultData.nWinGold, TouKui_DataConfig.winBigGoldChangeRate, delegate (string goal)
                    {
                        long.TryParse(goal, out long num);
                        owner.bigEffectNum.text = num.ShortNumber().ShowRichText();
                    }).OnComplete(delegate ()
                    {
                        animName = "bigwin3";
                        owner.bigEffectAnim.dbAnimation.Play(animName, 1);
                    });
                }
                else if (animName.Equals("bigwin3"))
                {
                    owner.bigEffectNum.text = 0.ShortNumber().ShowRichText();
                    TouKui_Event.DispatchShowResultComplete(true);
                    hsm?.ChangeState(nameof(IdleState));
                }
            }
            public override void OnExit()
            {
                base.OnExit();
                owner.bigEffect.gameObject.SetActive(false);
                owner.bigEffectAnim.RemoveDBEventListener(EventObject.COMPLETE, this.OnAnimationEventHandler);
            }
        }
        private class SuperWinState : State<TouKui_Result>
        {
            public SuperWinState(TouKui_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            private string animName;
            public override void OnEnter()
            {
                base.OnEnter();
                owner.superEffectNum.text = 0.ShortNumber().ShowRichText();
                owner.superEffect.gameObject.SetActive(true);
                TouKui_Audio.Instance.PlaySound(TouKui_Audio.SuperWin);
                owner.superEffectAnim.AddDBEventListener(EventObject.COMPLETE, this.OnAnimationEventHandler);
                animName = "superwin1";
                owner.superEffectAnim.dbAnimation.Play(animName, 1);
                TouKui_Event.DispatchShowLens(ResultType.SuperWin);
            }

            private void OnAnimationEventHandler(string type, EventObject eventObject)
            {
                if (animName.Equals("superwin1"))
                {
                    animName = "superwin2";
                    owner.superEffectAnim.dbAnimation.Play(animName,1);
                    ToolHelper.RunGoal(0, TouKuiEntry.Instance.GameData.ResultData.nWinGold, TouKui_DataConfig.winBigGoldChangeRate, delegate (string goal)
                    {
                        long.TryParse(goal, out long num);
                        owner.superEffectNum.text = num.ShortNumber().ShowRichText();
                    }).OnComplete(delegate ()
                    {
                        animName = "superwin3";
                        owner.superEffectAnim.dbAnimation.Play(animName, 1);
                    });
                }
                else if (animName.Equals("superwin3"))
                {
                    owner.superEffectNum.text = 0.ShortNumber().ShowRichText();
                    TouKui_Event.DispatchShowResultComplete(true);
                    hsm?.ChangeState(nameof(IdleState));
                }
            }
            public override void OnExit()
            {
                base.OnExit();
                owner.superEffect.gameObject.SetActive(false);
                owner.superEffectAnim.RemoveDBEventListener(EventObject.COMPLETE, this.OnAnimationEventHandler);
            }
        }
        private class MegaWinState : State<TouKui_Result>
        {
            public MegaWinState(TouKui_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            private string animName;
            public override void OnEnter()
            {
                base.OnEnter();
                owner.megaEffectNum.text = 0.ShortNumber().ShowRichText();
                owner.megaEffect.gameObject.SetActive(true);
                TouKui_Audio.Instance.PlaySound(TouKui_Audio.MegaWin);
                owner.megaEffectAnim.AddDBEventListener(EventObject.COMPLETE, this.OnAnimationEventHandler);
                animName = "megawin1";
                owner.megaEffectAnim.dbAnimation.Play(animName, 1);
                TouKui_Event.DispatchShowLens(ResultType.MegaWin);

            }

            private void OnAnimationEventHandler(string type, EventObject eventObject)
            {
                if (animName.Equals("megawin1"))
                {
                    animName = "megawin2";
                    owner.megaEffectAnim.dbAnimation.Play(animName,1);

                    ToolHelper.RunGoal(0, TouKuiEntry.Instance.GameData.ResultData.nWinGold, TouKui_DataConfig.winBigGoldChangeRate, delegate (string goal)
                    {
                        long.TryParse(goal, out long num);
                        owner.megaEffectNum.text = num.ShortNumber().ShowRichText();
                    }).OnComplete(delegate ()
                    {
                        animName = "megawin3";
                        owner.megaEffectAnim.dbAnimation.Play(animName,1);
                    });
                }
                else if (animName.Equals("megawin3"))
                {
                    owner.megaEffectNum.text = 0.ShortNumber().ShowRichText();
                    TouKui_Event.DispatchShowResultComplete(true);
                    hsm?.ChangeState(nameof(IdleState));
                }
            }
            public override void OnExit()
            {
                base.OnExit();
                owner.megaEffect.gameObject.SetActive(false);
                owner.megaEffectAnim.RemoveDBEventListener(EventObject.COMPLETE, this.OnAnimationEventHandler);
            }
        }
    }
}
