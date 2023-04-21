

using DG.Tweening;
using DragonBones;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using Transform = UnityEngine.Transform;

namespace Hotfix.JTJW
{
    public class JW_Result : ILHotfixEntity
    {
        HierarchicalStateMachine hsm;
        List<IState> states;
        private Transform normalEffect;
        private TextMeshProUGUI normalEffectNum;
        private Transform winEffect;
        private UnityArmatureComponent winEffectAnim;
        private TextMeshProUGUI winEffectNum;
        private Transform bigEffect;
        private UnityArmatureComponent bigEffectAnim;
        private TextMeshProUGUI bigEffectNum;
        private Transform megaEffect;
        private UnityArmatureComponent megaEffectAnim;
        private TextMeshProUGUI megaEffectNum;

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

        protected override void AddEvent()
        {
            base.AddEvent();
            JW_Event.ShowResult += JW_Event_ShowResult;
        }

        protected override void Update()
        {
            base.Update();
            hsm?.Update();
        }

        protected override void RemoveEvent()
        {
            base.RemoveEvent();
            JW_Event.ShowResult -= JW_Event_ShowResult;
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            hsm?.CurrentState.OnExit();
        }

        protected override void FindComponent()
        {
            base.FindComponent();
            //normalEffect = transform.FindChildDepth("NormalWin");
            normalEffectNum = JWEntry.Instance.winNum; //本次获得金币

            winEffect = transform.FindChildDepth("Win");
            winEffectAnim = winEffect.FindChildDepth<UnityArmatureComponent>("Anim"); //本次获得金币
            winEffectNum = winEffect.FindChildDepth<TextMeshProUGUI>("Num"); //本次获得金币

            bigEffect = transform.FindChildDepth("BigWin");
            bigEffectAnim = bigEffect.FindChildDepth<UnityArmatureComponent>("Anim"); //本次获得金币
            bigEffectNum = bigEffect.FindChildDepth<TextMeshProUGUI>("Num"); //本次获得金币

            megaEffect = transform.FindChildDepth("MegaWin");
            megaEffectAnim = megaEffect.FindChildDepth<UnityArmatureComponent>("Anim"); //本次获得金币
            megaEffectNum = megaEffect.FindChildDepth<TextMeshProUGUI>("Num"); //本次获得金币

        }
        private void JW_Event_ShowResult()
        {
            if (JWEntry.Instance.GameData.ResultData.nWinGold > 0)
            {
                float winRate = (float)JWEntry.Instance.GameData.ResultData.nWinGold / (JW_DataConfig.ALLLINECOUNT * JWEntry.Instance.GameData.CurrentChip);

                if (winRate <= 1)
                {
                    hsm?.ChangeState(nameof(NormalWinState));
                }
                else if (winRate > 1 && winRate <= 3)
                {
                    hsm?.ChangeState(nameof(BigWinState));
                }
                else if (winRate > 3 && winRate <= 6)
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

        private class IdleState : State<JW_Result>
        {
            public IdleState(JW_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                owner.winEffect.gameObject.SetActive(false);
                owner.bigEffect.gameObject.SetActive(false);
                owner.megaEffect.gameObject.SetActive(false);
                JWEntry.Instance.JW_Event_ShowResultNum(true);
                JWEntry.Instance.JW_Event_ShowResultNum(0);
            }
        }
        /// <summary>
        /// 未中奖
        /// </summary>
        private class NoWinState : State<JW_Result>
        {
            public NoWinState(JW_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
                if (timer >= JW_DataConfig.autoNoRewardInterval)
                {
                    JW_Event.DispatchShowResultComplete();
                    hsm?.ChangeState(nameof(IdleState));
                }
            }
        }
        private class NormalWinState : State<JW_Result>
        {
            public NormalWinState(JW_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            bool isStart;
            public override void OnEnter()
            {
                base.OnEnter();
                timer = 0;
                isStart = true;
            }
            public override void Update()
            {
                base.Update();
                if (!isStart) return;
                timer += Time.deltaTime;
                if (timer >= 0.5f)
                {
                    isStart = false;
                    JW_Event.DispatchShowResultComplete();
                    hsm?.ChangeState(nameof(IdleState));
                }
            }
            public override void OnExit()
            {
                base.OnExit();
               // owner.normalEffect.gameObject.SetActive(false);
            }

        }
        private class BigWinState : State<JW_Result>
        {
            public BigWinState(JW_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
                owner.winEffectNum.text = "";
                owner.winEffect.gameObject.SetActive(true);
                JW_Audio.Instance.PlaySound(JW_Audio.BigWin);

                ToolHelper.RunGoal(0, JWEntry.Instance.GameData.ResultData.nWinGold, JW_DataConfig.winBigGoldChangeRate, delegate (string goal)
                {
                    owner.winEffectNum.text = ToolHelper.ShowRichText(goal);

                }).OnComplete(delegate ()
                {
                    isStart = true;
                    JW_Audio.Instance.PlaySound(JW_Audio.iconWinEnd);
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
                    JW_Event.DispatchShowResultComplete();
                    hsm?.ChangeState(nameof(IdleState));
                }
            }
        }

        private class SuperWinState : State<JW_Result>
        {
            public SuperWinState(JW_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
                JW_Audio.Instance.PlaySound(JW_Audio.SuperWin);

                ToolHelper.RunGoal(0, JWEntry.Instance.GameData.ResultData.nWinGold, JW_DataConfig.winBigGoldChangeRate, delegate (string goal)
                {
                    owner.bigEffectNum.text = ToolHelper.ShowRichText(goal);

                }).OnComplete(delegate ()
                {
                    isStart = true;
                    JW_Audio.Instance.PlaySound(JW_Audio.iconWinEnd);
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
                    JW_Event.DispatchShowResultComplete();
                    hsm?.ChangeState(nameof(IdleState));
                }
            }
        }
        private class MegaWinState : State<JW_Result>
        {
            public MegaWinState(JW_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer = 0;
            bool isStart;
            public override void OnEnter()
            {
                base.OnEnter();
                isStart = false;
                timer = 0;
                owner.megaEffectNum.text = "";
                owner.megaEffect.gameObject.SetActive(true);
                JW_Audio.Instance.PlaySound(JW_Audio.MegaWin);

                ToolHelper.RunGoal(0, JWEntry.Instance.GameData.ResultData.nWinGold, JW_DataConfig.winBigGoldChangeRate, delegate (string goal)
                {
                    owner.megaEffectNum.text = ToolHelper.ShowRichText(goal);

                }).OnComplete(delegate ()
                {
                    isStart = true;
                    JW_Audio.Instance.PlaySound(JW_Audio.iconWinEnd);
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
                    JW_Event.DispatchShowResultComplete();
                    hsm?.ChangeState(nameof(IdleState));
                }
            }
        }
    }
}
