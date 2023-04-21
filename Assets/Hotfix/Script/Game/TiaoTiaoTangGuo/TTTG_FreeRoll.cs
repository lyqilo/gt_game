using System.Collections;
using System.Collections.Generic;
using Spine;
using Spine.Unity;
using UnityEngine;

namespace Hotfix.TiaoTiaoTangGuo
{
    public class TTTG_FreeRoll : ILHotfixEntity
    {
        private Transform icons;

        private Transform rollGroup;

        public Dictionary<int, int> SpecialList { get; set; }
        private List<IState> states;
        private HierarchicalStateMachine hsm;

        private SkeletonGraphic milkAnim;
        private TTTG_Struct.CMD_3D_SC_Result resultData;
        private int currentIndex;
        private Transform candyHouse;
        private Transform candyHouseMask;

        private int currentHitIndex;
        private string currentAnim="";

        protected override void Awake()
        {
            base.Awake();
            states = new List<IState>();
            hsm = new HierarchicalStateMachine(false, gameObject);
            states.Add(new IdleState(this, hsm));
            states.Add(new ShowResultState(this, hsm));
            states.Add(new RemoveState(this, hsm));
            states.Add(new MoveState(this, hsm));
            states.Add(new AddIconState(this, hsm));
            hsm?.Init(states, nameof(IdleState));
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            hsm?.CurrentState.OnExit();
        }

        protected override void AddEvent()
        {
            base.AddEvent();
            TTTG_Event.OnReceiveResult += TTTG_EventOnOnReceiveResult;
            TTTG_Event.MoveScreenComplete += TTTG_EventOnMoveScreenComplete;
            TTTG_Event.ShowFree += TTTG_EventOnShowFree;
            TTTG_Event.MoveScreen += TTTG_EventOnMoveScreen;
        }

        protected override void RemoveEvent()
        {
            base.RemoveEvent();
            TTTG_Event.OnReceiveResult -= TTTG_EventOnOnReceiveResult;
            TTTG_Event.MoveScreenComplete -= TTTG_EventOnMoveScreenComplete;
            TTTG_Event.ShowFree -= TTTG_EventOnShowFree;
            TTTG_Event.MoveScreen -= TTTG_EventOnMoveScreen;
        }

        protected override void FindComponent()
        {
            base.FindComponent();
            icons = TTTGEntry.Instance.transform.FindChildDepth("IconGroup"); //图标库
            candyHouse = transform.FindChildDepth($"CandyHouse");
            candyHouseMask = transform.FindChildDepth($"HouseMask");
            candyHouseMask.gameObject.SetActive(false);

            milkAnim = transform.FindChildDepth<SkeletonGraphic>($"Milk");
            milkAnim.gameObject.SetActive(false);
            rollGroup = transform.FindChildDepth($"Scroll");
            SpecialList = new Dictionary<int, int>();
            for (int i = 0; i < TTTG_DataConfig.GI_count; i++)
            {
                SpecialList.Add(i, 0);
            }

        }

        private IEnumerator DelayInit()
        {
            for (int i = 0; i < rollGroup.childCount; i++)
            {
                yield return new WaitForEndOfFrame();
                Transform rect = rollGroup.GetChild(i);
                for (int j = 0; j < 4; j++)
                {
                    if (rect.childCount >= j + 1) continue;
                    int index = Random.Range(0, 7);
                    GameObject temp1 = FindUseItem(index, rect);
                    temp1.transform.localRotation = Quaternion.identity;
                    temp1.transform.localScale = Vector3.one;
                    temp1.transform.localPosition = new Vector3(0, 250, 0);
                    temp1.gameObject.name = $"Item{index}";
                    TTTG_NormalRollItem item = temp1.AddILComponent<TTTG_NormalRollItem>();
                    Behaviour.StartCoroutine(item.SetItem(index,true));
                }
            }
            milkAnim.gameObject.SetActive(true);
            milkAnim.AnimationState.SetAnimation(0, $"up", false);
            milkAnim.AnimationState.AddAnimation(0, $"fill", true, 0);
        }

        protected override void Update()
        {
            base.Update();
            hsm?.Update();
        }


        private void TTTG_EventOnOnReceiveResult(TTTG_Struct.CMD_3D_SC_Result obj)
        {
            if (!TTTGEntry.Instance.GameData.isFreeGame) return;
            resultData = obj;
            hsm?.ChangeState(nameof(ShowResultState));
        }

        private void TTTG_EventOnMoveScreenComplete(bool isfree)
        {
            candyHouseMask.gameObject.SetActive(isfree);
            if (!isfree) return;
            ToolHelper.DelayRun(3.3f, () =>
            {
                currentAnim = $"down";
                milkAnim.AnimationState.Complete += AnimationStateOnComplete;
                milkAnim.AnimationState.SetAnimation(0, $"down", false);
            });
        }

        private void TTTG_EventOnMoveScreen(bool isfree)
        {
            if (isfree)
            {
                Behaviour.StartCoroutine(DelayInit());
            }

            milkAnim.gameObject.SetActive(true);
            milkAnim.AnimationState.SetAnimation(0, $"up", false);
            milkAnim.AnimationState.AddAnimation(0, $"fill", true, 0);
        }

        private void TTTG_EventOnShowFree(bool isShow)
        {
            milkAnim.gameObject.SetActive(true);
            milkAnim.AnimationState.Complete += AnimationStateOnComplete;
            if (!isShow) return;
            //牛奶开始上涨，特殊图标开始动画
            currentAnim = $"up";
            milkAnim.AnimationState.SetAnimation(0, $"up", false);
            milkAnim.AnimationState.AddAnimation(0, $"fill", true, 0);
        }

        private void AnimationStateOnComplete(TrackEntry trackentry)
        {
            milkAnim.AnimationState.Complete -= AnimationStateOnComplete;
            if (currentAnim.Equals($"up"))
            {
                //牛奶上涨完成，开始移动屏幕
                // TTTG_Event.DispatchMoveScreen(true);
            }
            else if (currentAnim.Equals($"down"))
            {
                //牛奶下降完成，开始新回合
                TTTG_Event.DispatchOnShowResultComplete();
            }

            currentAnim = "";
        }

        /// <summary>
        /// 生成特殊动画
        /// </summary>
        /// <param name="resultIndex">结果索引</param>
        /// <param name="pos">坐标</param>
        private void ChangeResultIcon(int resultIndex, Vector3 pos)
        {
            GameObject _temp1 = FindUseSpecialItem(resultIndex, candyHouse);
            _temp1.gameObject.name = $"SpecialItem{resultIndex}";
            _temp1.transform.localRotation = Quaternion.identity;
            _temp1.transform.localScale = Vector3.one;
            _temp1.transform.position = pos;
            TTTG_FreeRollItem _item = _temp1.AddILComponent<TTTG_FreeRollItem>();
            _item.Show(resultIndex);
        }

        /// <summary>
        /// 变为正式结果
        /// </summary>
        /// <param name="row">当前行</param>
        /// <param name="col">当前列</param>
        /// <param name="resultIndex">结果索引</param>
        private IEnumerator ChangeResultIcon(int row, int col, int resultIndex)
        {
            Transform rect = rollGroup.GetChild(col);
            GameObject temp1 = FindUseItem(resultIndex, rect);
            temp1.gameObject.name = $"Item{resultIndex}";
            TTTG_NormalRollItem item = temp1.AddILComponent<TTTG_NormalRollItem>();
            yield return item.SetItem(resultIndex, true);
        }

        /// <summary>
        /// 查找有用Item
        /// </summary>
        /// <param name="index">索引</param>
        /// <param name="parent">父物体</param>
        /// <returns></returns>
        private GameObject FindUseItem(int index, Transform parent)
        {
            Transform child = TTTGEntry.Instance.cacheGroup.Find($"Item{index}");
            if (child == null)
            {
                child = Object.Instantiate(icons.Find($"Item{index}").gameObject, parent).transform;
            }
            else
            {
                child.SetParent(parent);
            }

            return child.gameObject;
        }

        /// <summary>
        /// 查找有用specialItem
        /// </summary>
        /// <param name="index">索引</param>
        /// <param name="parent">父物体</param>
        /// <returns></returns>
        private GameObject FindUseSpecialItem(int index, Transform parent)
        {
            Transform child = TTTGEntry.Instance.cacheGroup.Find($"SpecialItem{index}");
            if (child == null)
            {
                child = Object.Instantiate(icons.Find($"SpecialItem{index}").gameObject, parent).transform;
            }
            else
            {
                child.SetParent(parent);
            }

            return child.gameObject;
        }

        /// <summary>
        /// 待机
        /// </summary>
        private class IdleState : State<TTTG_FreeRoll>
        {
            public IdleState(TTTG_FreeRoll owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
        }

        /// <summary>
        /// 展示结果
        /// </summary>
        private class ShowResultState : State<TTTG_FreeRoll>
        {
            public ShowResultState(TTTG_FreeRoll owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            private int _totalChildCount = 0;
            private bool _isComplete;

            public override void OnEnter()
            {
                base.OnEnter();
                _isComplete = false;
                owner.currentIndex = 0;
                owner.currentHitIndex = 0;
                TTTG_Event.DispatchShowResultIcon(true);
            }

            public override void Update()
            {
                base.Update();
                if (GetTotalChildCount() > 0)
                {
                    if (!_isComplete) return;
                    if (_totalChildCount < TTTG_DataConfig.MAX_Col * TTTG_DataConfig.MAX_Row) return;
                    if (owner.resultData.nWinGold <= 0) //没中奖
                    {
                        hsm?.ChangeState(nameof(IdleState));
                        TTTG_Event.DispatchShowResult();
                        return;
                    }

                    hsm?.ChangeState(nameof(RemoveState)); //开始消除
                }
                else
                {
                    if (_isComplete) return;
                    _isComplete = true;
                    owner.Behaviour.StartCoroutine(ShowResult());
                }
            }

            private int GetTotalChildCount()
            {
                _totalChildCount = 0;
                for (int i = 0; i < owner.rollGroup.childCount; i++)
                {
                    _totalChildCount += owner.rollGroup.GetChild(i).childCount;
                }

                return _totalChildCount;
            }

            private IEnumerator ShowResult()
            {
                for (int i = 0; i < TTTG_DataConfig.MAX_Row; i++)
                {
                    yield return new WaitForSeconds(0.05f);
                    for (int j = 0; j < TTTG_DataConfig.MAX_Col; j++)
                    {
                        int row = i;
                        int col = j;
                        owner.Behaviour.StartCoroutine(owner.ChangeResultIcon(row, col,
                            owner.resultData.cbIcon[owner.currentIndex]));
                        owner.currentIndex++;
                    }
                }
            }
        }

        /// <summary>
        /// 消除
        /// </summary>
        private class RemoveState : State<TTTG_FreeRoll>
        {
            public RemoveState(TTTG_FreeRoll owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                int[] specialKeys = owner.SpecialList.GetDictionaryKeys();
                for (int i = 0; i < specialKeys.Length; i++)
                {
                    owner.SpecialList[specialKeys[i]] = 0;
                }

                owner.Behaviour.StartCoroutine(DelayRemove());
            }

            private IEnumerator DelayRemove()
            {
                yield return new WaitForEndOfFrame();
                if (owner.currentHitIndex >= owner.resultData.hitTimes)
                {
                    hsm?.ChangeState(nameof(IdleState));
                    TTTG_Event.DispatchShowResult();
                    yield break;
                }

                yield return new WaitForSeconds(0.3f);
                for (int i = 0; i < owner.resultData.cbHit[owner.currentHitIndex].Count; i++)
                {
                    if (owner.resultData.cbHit[owner.currentHitIndex][i] <= 0) continue;
                    int row = i / 5;
                    int col = i % 5;
                    yield return new WaitForSeconds(0.05f);
                    TTTG_NormalRollItem item = owner.rollGroup.GetChild(col).GetChild(row).gameObject
                        .GetILComponent<TTTG_NormalRollItem>();
                    owner.Behaviour.StartCoroutine(ShowSpecialIcon(item.transform.position, item.Index));
                    owner.Behaviour.StartCoroutine(item.HitIcon());
                    owner.SpecialList[item.Index]++;
                }

                if (owner.currentHitIndex > 0)
                {
                    TTTG_Event.DispatchShowCombo(owner.currentHitIndex);
                }

                owner.currentHitIndex++;
                yield return new WaitForSeconds(1f);
                hsm?.ChangeState(nameof(MoveState));
            }

            private IEnumerator ShowSpecialIcon(Vector3 pos, int itemIndex)
            {
                yield return new WaitForSeconds(0.5f);
                owner.ChangeResultIcon(itemIndex, pos);
            }
        }

        /// <summary>
        /// 下移
        /// </summary>
        private class MoveState : State<TTTG_FreeRoll>
        {
            public MoveState(TTTG_FreeRoll owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                owner.Behaviour.StartCoroutine(DelayMove());
            }

            private IEnumerator DelayMove()
            {
                TTTG_Event.DispatchOnMoveItem();
                yield return new WaitForSeconds(0.5f);
                hsm?.ChangeState(nameof(AddIconState));
            }
        }

        /// <summary>
        /// 增加元素
        /// </summary>
        private class AddIconState : State<TTTG_FreeRoll>
        {
            public AddIconState(TTTG_FreeRoll owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                owner.Behaviour.StartCoroutine(DelayAdd());
            }

            private IEnumerator DelayAdd()
            {
                for (int i = 0; i < TTTG_DataConfig.MAX_Row; i++)
                {
                    for (int j = 0; j < TTTG_DataConfig.MAX_Col; j++)
                    {
                        if (owner.rollGroup.GetChild(j).childCount > i) continue;
                        int row = i;
                        int col = j;
                        yield return owner.ChangeResultIcon(row, col, owner.resultData.cbIcon[owner.currentIndex]);
                        owner.currentIndex++;
                    }
                }

                if (owner.currentIndex >= owner.resultData.useIdx)
                {
                    DebugHelper.LogError("显示结果");
                    hsm?.ChangeState(nameof(IdleState));
                    TTTG_Event.DispatchShowResult();
                    yield break;
                }

                yield return new WaitForSeconds(0.5f);
                hsm?.ChangeState(nameof(RemoveState));
            }
        }
    }
}