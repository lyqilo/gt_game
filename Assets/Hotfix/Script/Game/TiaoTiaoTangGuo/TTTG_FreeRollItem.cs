using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using Spine;
using Spine.Unity;
using UnityEngine;

namespace Hotfix.TiaoTiaoTangGuo
{
    public class TTTG_FreeRollItem : ILHotfixEntity
    {
        public int Index;
        private SkeletonGraphic moveSmoke;
        public SkeletonGraphic anim;
        private SkeletonGraphic bomb;
        private List<IState> states;
        private HierarchicalStateMachine hsm;
        private Vector3 pos;

        protected override void Awake()
        {
            base.Awake();
            pos = transform.localPosition;
        }

        protected override void Start()
        {
            base.Start();
            states = new List<IState>();
            hsm = new HierarchicalStateMachine(false, gameObject);
            states.Add(new IdleState(this, hsm));
            states.Add(new FreeEnterState(this, hsm));
            states.Add(new HitSpecialState(this, hsm));
            states.Add(new FreeResultShowState(this, hsm));
            hsm.Init(states, nameof(IdleState));
        }

        protected override void Update()
        {
            base.Update();
            hsm?.Update();
        }

        protected override void OnDestroy()
        {
            if (TTTGEntry.Instance != null)
            {
                transform.SetParent(TTTGEntry.Instance.cacheGroup);
            }

            base.OnDestroy();
        }

        protected override void AddEvent()
        {
            base.AddEvent();
            TTTG_Event.MoveScreenComplete += TTTG_EventOnMoveScreenComplete;
        }

        protected override void RemoveEvent()
        {
            base.RemoveEvent();
            TTTG_Event.MoveScreenComplete -= TTTG_EventOnMoveScreenComplete;
        }

        private void TTTG_EventOnMoveScreenComplete(bool isFree)
        {
            // if (isFree) return;
            // hsm?.ChangeState(nameof(IdleState));
        }

        protected override void FindComponent()
        {
            base.FindComponent();
            moveSmoke = transform.FindChildDepth<SkeletonGraphic>($"MoveSmoke");
            anim = transform.FindChildDepth<SkeletonGraphic>($"Anim");
            bomb = transform.FindChildDepth<SkeletonGraphic>($"Bomb");
        }

        public void Init(int index)
        {
            Index = index;
        }

        public void Show(int resultIndex)
        {
            Index = resultIndex;
            hsm?.ChangeState(nameof(FreeResultShowState));
        }

        public void ShowHitSpecial()
        {
            hsm?.ChangeState(nameof(HitSpecialState));
        }

        public void ShowFreeEnter()
        {
            hsm?.ChangeState(nameof(FreeEnterState));
        }

        private class IdleState : State<TTTG_FreeRollItem>
        {
            public IdleState(TTTG_FreeRollItem owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                owner.anim.gameObject.SetActive(true);
                owner.anim.AnimationState.ClearTracks();
                owner.bomb.gameObject.SetActive(false);
                owner.moveSmoke.gameObject.SetActive(false);
                owner.anim.AnimationState.SetAnimation(0, $"disable", true);
            }
        }

        private class FreeResultShowState : State<TTTG_FreeRollItem>
        {
            public FreeResultShowState(TTTG_FreeRollItem owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                owner.bomb.gameObject.SetActive(true);
                owner.moveSmoke.gameObject.SetActive(false);
                owner.bomb.AnimationState.SetAnimation(0, $"bomb_2", false);
                owner.anim.AnimationState.SetAnimation(0, $"appearance", false);
                Sequence sequence = DOTween.Sequence();
                sequence.Append(ToolHelper.DelayRun(0.5f,
                    () => { owner.anim.AnimationState.SetAnimation(0, $"jump", false); }));
                sequence.Append(owner.transform.DOLocalMoveY(-300, 0.3f * Random.Range(1, 1.8f)).OnComplete(() =>
                {
                    owner.moveSmoke.gameObject.SetActive(true);
                    owner.anim.AnimationState.SetAnimation(0, $"landing", false);
                }));
                sequence.Append(ToolHelper.DelayRun(0.5f, () =>
                {
                    owner.anim.AnimationState.SetAnimation(0, $"move", true);
                    owner.moveSmoke.AnimationState.SetAnimation(0, $"move_smoke", true);
                }));
                sequence.Append(owner.transform.DOLocalMoveX(1000, 1f));
                sequence.OnComplete(() => { owner.gameObject.RemoveILComponent<TTTG_FreeRollItem>(); });
            }
        }

        private class FreeEnterState : State<TTTG_FreeRollItem>
        {
            public FreeEnterState(TTTG_FreeRollItem owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                owner.bomb.gameObject.SetActive(false);
                owner.moveSmoke.gameObject.SetActive(false);
                owner.anim.AnimationState.SetAnimation(0, $"appearance", false);
                Sequence sequence = DOTween.Sequence();
                sequence.Append(ToolHelper.DelayRun(0.5f,
                    () => { owner.anim.AnimationState.SetAnimation(0, $"jump", false); }));
                Tweener tweener = owner.transform.DOLocalMoveY(-300, owner.Index * 0.1f+0.3f).OnComplete(() =>
                {
                    owner.anim.AnimationState.SetAnimation(0, $"landing", false);
                });
                sequence.Append(tweener);
                sequence.Append(ToolHelper.DelayRun(0.5f, () =>
                {
                    owner.moveSmoke.gameObject.SetActive(true);
                    owner.anim.AnimationState.SetAnimation(0, $"move", true);
                }));
                Tweener tweener1 = owner.transform.DOLocalMoveX(-420, owner.Index * 0.1f + 2f).OnComplete(
                    () =>
                    {
                        owner.moveSmoke.gameObject.SetActive(false);
                        owner.anim.AnimationState.SetAnimation(0, $"brake", false);
                        ToolHelper.DelayRun(3.3f, () =>
                        {
                            owner.transform.SetParent(TTTG_NormalRoll.Instance.Cabinet);
                            owner.transform.localPosition = owner.pos;
                            hsm?.ChangeState(nameof(IdleState));
                        });
                    });
                sequence.Append(tweener1);
            }
        }

        private class HitSpecialState : State<TTTG_FreeRollItem>
        {
            public HitSpecialState(TTTG_FreeRollItem owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                owner.anim.AnimationState.ClearTracks();
                owner.anim.AnimationState.SetAnimation(0, $"life", false);
                owner.anim.AnimationState.AddAnimation(0, $"idle", true, 0);
            }
        }
    }
}