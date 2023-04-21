using DG.Tweening;
using System.Collections.Generic;
using UnityEngine;

namespace Hotfix.TouKui
{
    public class TouKui_Lens:ILHotfixEntity
    {
        Transform kuosanNode;
        Transform gudingNode;
        Transform beishuNode;
        Transform fudongNode;

        HierarchicalStateMachine hsm;
        List<IState> states;
        protected override void Start()
        {
            base.Start();
            hsm = new HierarchicalStateMachine(false, gameObject);
            states = new List<IState>();
            states.Add(new IdleState(this, hsm));
            states.Add(new FuDongState(this, hsm));
            states.Add(new GuDingState(this, hsm));
            states.Add(new BeiShuState(this, hsm));
            states.Add(new KuoSanState(this, hsm));

            hsm.Init(states, nameof(IdleState));
        }

        protected override void Update()
        {
            base.Update();
            hsm?.Update();
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            hsm?.CurrentState.OnExit();
        }

        protected override void FindComponent()
        {
            kuosanNode = transform.FindChildDepth("BB");
            gudingNode = transform.FindChildDepth("JH");
            beishuNode = transform.FindChildDepth("XM");
            fudongNode = transform.FindChildDepth("HS");
        }

        protected override void AddEvent()
        {
            TouKui_Event.ChangeSpecialModeBackground += TouKui_Event_ChangeSpecialModeBackground;
            TouKui_Event.ExitSpecialMode += TouKui_Event_ExitSpecialMode;
        }

        private void TouKui_Event_ExitSpecialMode()
        {
            hsm?.ChangeState(nameof(IdleState));
        }

        private void TouKui_Event_ChangeSpecialModeBackground(SpecialMode obj)
        {
            if (obj == SpecialMode.None) return;
            hsm?.ChangeState($"{obj}State");
        }

        protected override void RemoveEvent()
        {
            TouKui_Event.ExitSpecialMode -= TouKui_Event_ExitSpecialMode;
            TouKui_Event.ChangeSpecialModeBackground -= TouKui_Event_ChangeSpecialModeBackground;
        }
        /// <summary>
        /// 闲置状态
        /// </summary>
        private class IdleState : State<TouKui_Lens>
        {
            public IdleState(TouKui_Lens owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                owner.kuosanNode.gameObject.SetActive(false);
                owner.gudingNode.gameObject.SetActive(false);
                owner.beishuNode.gameObject.SetActive(false);
                owner.fudongNode.gameObject.SetActive(false);
            }
        }
        /// <summary>
        /// 浮动状态
        /// </summary>
        private class FuDongState : State<TouKui_Lens>
        {
            public FuDongState(TouKui_Lens owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            GameObject animObj;
            GameObject bigShowObj;
            GameObject superShowObj;
            GameObject megaShowObj;
            GameObject mtShowObj;
            GameObject jingziObj;
            TouKui_TSUnit tSUnit;
            bool isShow;
            Tweener moveTween;
            public override void OnEnter()
            {
                base.OnEnter();
                isShow = false;
                TouKui_Event.ShowLens += TouKui_Event_ShowLens;
                TouKui_Event.ShowResultComplete += TouKui_Event_ShowResultComplete;
                animObj = owner.fudongNode.transform.FindChildDepth("Anim").gameObject;
                bigShowObj = owner.fudongNode.transform.FindChildDepth("Big").gameObject;
                superShowObj = owner.fudongNode.transform.FindChildDepth("Super").gameObject;
                megaShowObj = owner.fudongNode.transform.FindChildDepth("Mega").gameObject;
                mtShowObj = owner.fudongNode.transform.FindChildDepth("MT").gameObject;
                tSUnit = mtShowObj.AddILComponent<TouKui_TSUnit>();
                tSUnit.gameObject.SetActive(false);
                jingziObj = owner.fudongNode.transform.FindChildDepth("JZ").gameObject;
                tSUnit.Radius = 100;
                tSUnit.Center = TouKui_DataConfig.HSCenter[0];
                animObj.SetActive(true);
                bigShowObj.SetActive(false);
                superShowObj.SetActive(false);
                megaShowObj.SetActive(false);
                mtShowObj.SetActive(false);
                jingziObj.SetActive(false);
                owner.fudongNode.gameObject.SetActive(true);
            }

            public override void OnExit()
            {
                base.OnExit();
                owner.fudongNode.gameObject.SetActive(false);
                mtShowObj.RemoveILComponent<TouKui_TSUnit>();
                TouKui_Event.ShowLens -= TouKui_Event_ShowLens;
                TouKui_Event.ShowResultComplete -= TouKui_Event_ShowResultComplete;
            }

            public override void Update()
            {
                base.Update();
                if (!isShow) return;
                tSUnit.Center = jingziObj.transform.localPosition;
            }
            private void TouKui_Event_ShowResultComplete(bool iswin)
            {
                animObj.SetActive(true);
                bigShowObj.SetActive(false);
                superShowObj.SetActive(false);
                megaShowObj.SetActive(false);
                mtShowObj.SetActive(false);
                jingziObj.SetActive(false);
                isShow = false;
                moveTween?.Kill();
            }
            private void TouKui_Event_ShowLens(ResultType type)
            {
                switch (type)
                {
                    case ResultType.None:
                    case ResultType.NormalWin:
                        return;
                    case ResultType.BigWin:
                        bigShowObj.SetActive(true);
                        superShowObj.SetActive(false);
                        megaShowObj.SetActive(false);
                        break;
                    case ResultType.SuperWin:
                        bigShowObj.SetActive(false);
                        superShowObj.SetActive(true);
                        megaShowObj.SetActive(false);
                        break;
                    case ResultType.MegaWin:
                        bigShowObj.SetActive(false);
                        superShowObj.SetActive(false);
                        megaShowObj.SetActive(true);
                        break;
                }
                animObj.SetActive(false);
                mtShowObj.SetActive(true);
                jingziObj.SetActive(true);
                isShow = true;
                moveTween = jingziObj.transform.DOLocalPath(TouKui_DataConfig.HSCenter.ToArray(), 2).OnComplete(delegate ()
                {
                    MoveJZ();
                });
            }
            private void MoveJZ()
            {
                TouKui_DataConfig.HSCenter.Reverse();
                Vector3[] path = TouKui_DataConfig.HSCenter.ToArray();
                moveTween = jingziObj.transform.DOLocalPath(path, 2).OnComplete(delegate ()
                {
                    MoveJZ();
                });
            }
        }

        /// <summary>
        /// 固定状态
        /// </summary>
        private class GuDingState : State<TouKui_Lens>
        {
            public GuDingState(TouKui_Lens owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            GameObject animObj;
            GameObject bigShowObj;
            GameObject superShowObj;
            GameObject megaShowObj;
            GameObject mtShowObj;
            GameObject jingziObj;
            TouKui_TSUnit tSUnit;
            bool isShow;
            Tweener moveTween;
            public override void OnEnter()
            {
                base.OnEnter();
                isShow = false;
                TouKui_Event.ShowLens += TouKui_Event_ShowLens;
                TouKui_Event.ShowResultComplete += TouKui_Event_ShowResultComplete;
                animObj = owner.gudingNode.transform.FindChildDepth("Anim").gameObject;
                bigShowObj = owner.gudingNode.transform.FindChildDepth("Big").gameObject;
                superShowObj = owner.gudingNode.transform.FindChildDepth("Super").gameObject;
                megaShowObj = owner.gudingNode.transform.FindChildDepth("Mega").gameObject;
                mtShowObj = owner.gudingNode.transform.FindChildDepth("MT").gameObject;
                tSUnit = mtShowObj.AddILComponent<TouKui_TSUnit>();
                tSUnit.gameObject.SetActive(false);
                jingziObj = owner.gudingNode.transform.FindChildDepth("JZ").gameObject;
                tSUnit.Radius = 100;
                tSUnit.Center = TouKui_DataConfig.JHCenter[0];
                animObj.SetActive(true);
                bigShowObj.SetActive(false);
                superShowObj.SetActive(false);
                megaShowObj.SetActive(false);
                mtShowObj.SetActive(false);
                jingziObj.SetActive(false);
                owner.gudingNode.gameObject.SetActive(true);
            }

            public override void OnExit()
            {
                base.OnExit();
                owner.gudingNode.gameObject.SetActive(false);
                mtShowObj.RemoveILComponent<TouKui_TSUnit>();
                TouKui_Event.ShowLens -= TouKui_Event_ShowLens;
                TouKui_Event.ShowResultComplete -= TouKui_Event_ShowResultComplete;
            }

            public override void Update()
            {
                base.Update();
                if (!isShow) return;
                tSUnit.Center = jingziObj.transform.localPosition;
            }
            private void TouKui_Event_ShowResultComplete(bool iswin)
            {
                animObj.SetActive(true);
                bigShowObj.SetActive(false);
                superShowObj.SetActive(false);
                megaShowObj.SetActive(false);
                mtShowObj.SetActive(false);
                jingziObj.SetActive(false);
                isShow = false;
                moveTween?.Kill();
            }
            private void TouKui_Event_ShowLens(ResultType type)
            {
                switch (type)
                {
                    case ResultType.None:
                    case ResultType.NormalWin:
                        return;
                    case ResultType.BigWin:
                        bigShowObj.SetActive(true);
                        superShowObj.SetActive(false);
                        megaShowObj.SetActive(false);
                        break;
                    case ResultType.SuperWin:
                        bigShowObj.SetActive(false);
                        superShowObj.SetActive(true);
                        megaShowObj.SetActive(false);
                        break;
                    case ResultType.MegaWin:
                        bigShowObj.SetActive(false);
                        superShowObj.SetActive(false);
                        megaShowObj.SetActive(true);
                        break;
                }
                animObj.SetActive(false);
                mtShowObj.SetActive(true);
                jingziObj.SetActive(true);
                isShow = true;
                moveTween = jingziObj.transform.DOLocalPath(TouKui_DataConfig.JHCenter.ToArray(), 2).OnComplete(delegate ()
                {
                    MoveJZ();
                });
            }
            private void MoveJZ()
            {
                TouKui_DataConfig.JHCenter.Reverse();
                Vector3[] path = TouKui_DataConfig.JHCenter.ToArray();
                moveTween = jingziObj.transform.DOLocalPath(path, 2).OnComplete(delegate ()
                {
                    MoveJZ();
                });
            }
        }
        /// <summary>
        /// 倍数状态
        /// </summary>
        private class BeiShuState : State<TouKui_Lens>
        {
            public BeiShuState(TouKui_Lens owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            GameObject animObj;
            GameObject bigShowObj;
            GameObject superShowObj;
            GameObject megaShowObj;
            GameObject mtShowObj;
            GameObject jingziObj;
            TouKui_TSUnit tSUnit;
            bool isShow;
            Tweener moveTween;
            public override void OnEnter()
            {
                base.OnEnter();
                isShow = false;
                TouKui_Event.ShowLens += TouKui_Event_ShowLens;
                TouKui_Event.ShowResultComplete += TouKui_Event_ShowResultComplete;
                animObj = owner.beishuNode.transform.FindChildDepth("Anim").gameObject;
                bigShowObj = owner.beishuNode.transform.FindChildDepth("Big").gameObject;
                superShowObj = owner.beishuNode.transform.FindChildDepth("Super").gameObject;
                megaShowObj = owner.beishuNode.transform.FindChildDepth("Mega").gameObject;
                mtShowObj = owner.beishuNode.transform.FindChildDepth("MT").gameObject;
                tSUnit = mtShowObj.AddILComponent<TouKui_TSUnit>();
                tSUnit.gameObject.SetActive(false);
                jingziObj = owner.beishuNode.transform.FindChildDepth("JZ").gameObject;
                tSUnit.Radius = 100;
                tSUnit.Center = TouKui_DataConfig.XMCenter[0];
                animObj.SetActive(true);
                bigShowObj.SetActive(false);
                superShowObj.SetActive(false);
                megaShowObj.SetActive(false);
                mtShowObj.SetActive(false);
                jingziObj.SetActive(false);
                owner.beishuNode.gameObject.SetActive(true);
            }

            public override void OnExit()
            {
                base.OnExit();
                owner.beishuNode.gameObject.SetActive(false);
                mtShowObj.RemoveILComponent<TouKui_TSUnit>();
                TouKui_Event.ShowLens -= TouKui_Event_ShowLens;
                TouKui_Event.ShowResultComplete -= TouKui_Event_ShowResultComplete;
            }

            public override void Update()
            {
                base.Update();
                if (!isShow) return;
                tSUnit.Center = jingziObj.transform.localPosition;
            }
            private void TouKui_Event_ShowResultComplete(bool iswin)
            {
                animObj.SetActive(true);
                bigShowObj.SetActive(false);
                superShowObj.SetActive(false);
                megaShowObj.SetActive(false);
                mtShowObj.SetActive(false);
                jingziObj.SetActive(false);
                isShow = false;
                moveTween?.Kill();
            }
            private void TouKui_Event_ShowLens(ResultType type)
            {
                switch (type)
                {
                    case ResultType.None:
                    case ResultType.NormalWin:
                        return;
                    case ResultType.BigWin:
                        bigShowObj.SetActive(true);
                        superShowObj.SetActive(false);
                        megaShowObj.SetActive(false);
                        break;
                    case ResultType.SuperWin:
                        bigShowObj.SetActive(false);
                        superShowObj.SetActive(true);
                        megaShowObj.SetActive(false);
                        break;
                    case ResultType.MegaWin:
                        bigShowObj.SetActive(false);
                        superShowObj.SetActive(false);
                        megaShowObj.SetActive(true);
                        break;
                }
                animObj.SetActive(false);
                mtShowObj.SetActive(true);
                jingziObj.SetActive(true);
                isShow = true;
                moveTween = jingziObj.transform.DOLocalPath(TouKui_DataConfig.XMCenter.ToArray(), 2).OnComplete(delegate ()
                {
                    MoveJZ();
                });
            }
            private void MoveJZ()
            {
                TouKui_DataConfig.XMCenter.Reverse();
                Vector3[] path = TouKui_DataConfig.XMCenter.ToArray();
                moveTween = jingziObj.transform.DOLocalPath(path, 2).OnComplete(delegate ()
                {
                    MoveJZ();
                });
            }
        }
        /// <summary>
        /// 扩散状态
        /// </summary>
        private class KuoSanState : State<TouKui_Lens>
        {
            public KuoSanState(TouKui_Lens owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            GameObject animObj;
            GameObject bigShowObj;
            GameObject superShowObj;
            GameObject megaShowObj;
            GameObject mtShowObj;
            GameObject jingziObj;
            TouKui_TSUnit tSUnit;
            bool isShow;
            Tweener moveTween;
            public override void OnEnter()
            {
                base.OnEnter();
                isShow = false;
                TouKui_Event.ShowLens += TouKui_Event_ShowLens;
                TouKui_Event.ShowResultComplete += TouKui_Event_ShowResultComplete;
                animObj = owner.kuosanNode.transform.FindChildDepth("Anim").gameObject;
                bigShowObj = owner.kuosanNode.transform.FindChildDepth("Big").gameObject;
                superShowObj = owner.kuosanNode.transform.FindChildDepth("Super").gameObject;
                megaShowObj = owner.kuosanNode.transform.FindChildDepth("Mega").gameObject;
                mtShowObj = owner.kuosanNode.transform.FindChildDepth("MT").gameObject;
                tSUnit = mtShowObj.AddILComponent<TouKui_TSUnit>();
                tSUnit.gameObject.SetActive(false);
                jingziObj = owner.kuosanNode.transform.FindChildDepth("JZ").gameObject;
                tSUnit.Radius = 100;
                tSUnit.Center = TouKui_DataConfig.BBCenter[0];
                animObj.SetActive(true);
                bigShowObj.SetActive(false);
                superShowObj.SetActive(false);
                megaShowObj.SetActive(false);
                mtShowObj.SetActive(false);
                jingziObj.SetActive(false);
                owner.kuosanNode.gameObject.SetActive(true);
            }

            public override void OnExit()
            {
                base.OnExit();
                owner.kuosanNode.gameObject.SetActive(false);
                mtShowObj.RemoveILComponent<TouKui_TSUnit>();
                TouKui_Event.ShowLens -= TouKui_Event_ShowLens;
                TouKui_Event.ShowResultComplete -= TouKui_Event_ShowResultComplete;
            }

            public override void Update()
            {
                base.Update();
                if (!isShow) return;
                tSUnit.Center = jingziObj.transform.localPosition;
            }
            private void TouKui_Event_ShowResultComplete(bool iswin)
            {
                animObj.SetActive(true);
                bigShowObj.SetActive(false);
                superShowObj.SetActive(false);
                megaShowObj.SetActive(false);
                mtShowObj.SetActive(false);
                jingziObj.SetActive(false);
                isShow = false;
                moveTween?.Kill();
            }
            private void TouKui_Event_ShowLens(ResultType type)
            {
                switch (type)
                {
                    case ResultType.None:
                    case ResultType.NormalWin:
                        return;
                    case ResultType.BigWin:
                        bigShowObj.SetActive(true);
                        superShowObj.SetActive(false);
                        megaShowObj.SetActive(false);
                        break;
                    case ResultType.SuperWin:
                        bigShowObj.SetActive(false);
                        superShowObj.SetActive(true);
                        megaShowObj.SetActive(false);
                        break;
                    case ResultType.MegaWin:
                        bigShowObj.SetActive(false);
                        superShowObj.SetActive(false);
                        megaShowObj.SetActive(true);
                        break;
                }
                animObj.SetActive(false);
                mtShowObj.SetActive(true);
                jingziObj.SetActive(true);
                isShow = true;
                moveTween = jingziObj.transform.DOLocalPath(TouKui_DataConfig.BBCenter.ToArray(), 2).OnComplete(delegate ()
                {
                    MoveJZ();
                });
            }
            private void MoveJZ()
            {
                TouKui_DataConfig.BBCenter.Reverse();
                Vector3[] path = TouKui_DataConfig.BBCenter.ToArray();
                moveTween = jingziObj.transform.DOLocalPath(path, 2).OnComplete(delegate ()
                {
                    MoveJZ();
                });
            }
        }
    }
}
