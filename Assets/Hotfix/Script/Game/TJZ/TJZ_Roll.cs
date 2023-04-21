

using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


namespace Hotfix.TJZ
{
    public class TJZ_Roll : ILHotfixEntity
    {
        HierarchicalStateMachine hsm;
        List<IState> states;
        private Transform icons;
        List<ScrollRect> rollList;
        private int rollIndex;
        protected override void Awake()
        {
            base.Awake();
            TJZ_Event.StartRoll += TJZ_Event_StartRoll;
            TJZ_Event.StopRoll += TJZ_Event_StopRoll;
        }

        protected override void Start()
        {
            base.Start();
            hsm = new HierarchicalStateMachine(false, gameObject);
            states = new List<IState>();
            states.Add(new IdleState(this, hsm));
            states.Add(new RollState(this, hsm));
            states.Add(new StopState(this, hsm));
            hsm.Init(states, nameof(IdleState));
            Init();
        }

        private void Init()
        {
            icons = TJZEntry.Instance.Icons; //图标库
            rollList = new List<ScrollRect>();
            for (int i = 0; i < transform.childCount; i++)
            {
                ScrollRect rect = transform.GetChild(i).GetComponent<ScrollRect>();
                rect.verticalNormalizedPosition = 0;
                rect.elasticity = TJZ_DataConfig.rollReboundRate;
                rollList.Add(rect);
            }
            for (int i = 0; i < rollList.Count; i++)
            {
                ChangeRandomIcon(i);
            }
        }

        protected override void Update()
        {
            base.Update();
            hsm?.Update();
        }
        protected override void OnDestroy()
        {
            base.OnDestroy();
            TJZ_Event.StartRoll -= TJZ_Event_StartRoll;
            TJZ_Event.StopRoll -= TJZ_Event_StopRoll;
        }

        private void TJZ_Event_StartRoll()
        {
            hsm?.ChangeState(nameof(RollState));
        }

        private void TJZ_Event_StopRoll(bool force)
        {
            if (force)
            {
                if (hsm.CurrentStateName.Equals(nameof(RollState)))
                {
                    hsm?.ChangeState(nameof(StopState));
                }
            }
            else
            {
                hsm?.ChangeState(nameof(StopState));
            }
        }
        /// <summary>
        /// 随机图标
        /// </summary>
        /// <param name="rollIndex"></param>
        /// <param name="isMH"></param>
        private void ChangeRandomIcon(int rollIndex, bool isMH = false)
        {
            Transform iconParent = rollList[rollIndex].content;
            for (int i = 0; i < iconParent.childCount; i++)
            {
                int iconIndex = Random.Range(0, 9);
                string iconName = TJZ_DataConfig.IconTable[iconIndex];
                Transform images= icons.FindChildDepth(iconName);
                Sprite changeIcon = images.FindChildDepth<Image>("Image").sprite;
                iconParent.GetChild(i).FindChildDepth<Image>("Image").sprite = changeIcon;
            }
        }


        private void ChangeResultIcon(int rollIndex)
        {
            if (rollIndex >= rollList.Count) return;
            Transform iconParent = rollList[rollIndex].content;
            for (int i = 0; i < iconParent.childCount-1; i++)
            {
                Image img = iconParent.GetChild(i+1).FindChildDepth<Image>("Image");
                int iconIndex;
                iconIndex = TJZEntry.Instance.GameData.ResultData.cbIcon[i * 5 + rollIndex];
                Transform imTran = icons.FindChildDepth(TJZ_DataConfig.IconTable[iconIndex]);
                Sprite changeIcon = imTran.FindChildDepth<Image>("Image").sprite;
                img.sprite = changeIcon;
                if (i != iconParent.childCount)
                {
                    iconParent.GetChild(i+1).gameObject.name = TJZ_DataConfig.IconTable[iconIndex];
                }
            }
        }

        /// <summary>
        /// 闲置状态
        /// </summary>
        private class IdleState : State<TJZ_Roll>
        {
            public IdleState(TJZ_Roll owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
        }
        /// <summary>
        /// 转动状态
        /// </summary>
        private class RollState : State<TJZ_Roll>
        {
            public RollState(TJZ_Roll owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer;
            float startTimer;
            public override void OnEnter()
            {
                base.OnEnter();
                timer = TJZ_DataConfig.rollInterval;
                startTimer = 0;
                owner.rollIndex = 0;
                TJZEntry.Instance.GameData.JackPotNum = TJZEntry.Instance.GameData.ResultData.AccuPool;
                TJZ_Event.DispatchOnChangeJackPot();
                if (TJZEntry.Instance.GameData.Return)
                {
                    owner.Behaviour.StartCoroutine(RERoll());
                }
            }

            IEnumerator RERoll()
            {
                yield return new WaitForSeconds(0.2f);
                Transform reRollTrans = TJZEntry.Instance.RERoll;
                for (int i = 0; i < reRollTrans.childCount; i++)
                {
                    for (int j = 0; j < reRollTrans.GetChild(i).childCount; j++)
                    {
                        if (reRollTrans.GetChild(i).GetChild(j).gameObject.activeSelf)
                        {
                            Transform go = reRollTrans.GetChild(i).GetChild(j);
                            go.transform.DOLocalMove(new Vector3(go.localPosition.x - 190, go.localPosition.y, go.localPosition.z), TJZ_DataConfig.RERollTime);
                            //go.transform.DOLocalMoveX(-190, TJZ_DataConfig.RERollTime);
                        }
                    }
                }
            }

            public override void Update()
            {
                base.Update();
                for (int i = 0; i < owner.rollIndex; i++)
                {
                    owner.rollList[i].verticalNormalizedPosition += Time.deltaTime * TJZ_DataConfig.rollSpeed; //旋转
                    if (owner.rollList[i].verticalNormalizedPosition >= 1)
                    {
                        owner.rollList[i].verticalNormalizedPosition = 0;
                        owner.ChangeRandomIcon(i, true);
                    }
                }
                if (owner.rollIndex < owner.rollList.Count)
                {
                    //计算转动间隔
                    timer += Time.deltaTime;
                    if (timer >= TJZ_DataConfig.rollInterval)
                    {
                        timer = 0;
                        //TODO 赋值转动icon
                        owner.rollIndex++;
                        if (owner.rollIndex == owner.rollList.Count)
                        {
                            TJZ_Event.DispatchRollPrepreaComplete();
                        }
                    }
                }
                if (owner.rollIndex == owner.rollList.Count && startTimer <= TJZ_DataConfig.rollTime)
                {
                    //计算旋转时间，时间到就停止
                    startTimer += Time.deltaTime;
                    if (startTimer >= TJZ_DataConfig.rollTime)
                    {
                        startTimer = 0;
                        TJZ_Event.DispatchStopRoll(false);
                    }
                }
            }
        }

        /// <summary>
        /// 停止状态
        /// </summary>
        private class StopState : State<TJZ_Roll>
        {
            public StopState(TJZ_Roll owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            int stopIndex = 0;
            float stopTimer = 0;
            public override void OnEnter()
            {
                base.OnEnter();
                stopIndex = 0;
                stopTimer = 0;
            }
            public override void Update()
            {
                base.Update();
                for (int i = stopIndex; i < owner.rollIndex; i++)
                {
                    owner.rollList[i].verticalNormalizedPosition += Time.deltaTime * TJZ_DataConfig.rollSpeed; //旋转
                    if (owner.rollList[i].verticalNormalizedPosition >= 1)
                    {
                        owner.rollList[i].verticalNormalizedPosition = 0;
                        owner.ChangeRandomIcon(i, true);
                    }
                }
                CalculateStop();
            }

            private void CalculateStop()
            {
                if (stopIndex < owner.rollList.Count)
                {
                    //计算转动间隔
                    stopTimer += Time.deltaTime;
                    if (stopTimer >= TJZ_DataConfig.rollStopInterval)
                    {
                        stopTimer = 0;
                        //TODO 换正式结果图片
                        stopIndex++;
                        int stopindex = stopIndex - 1;
                        owner.rollList[stopindex].verticalNormalizedPosition = 0;
                        owner.ChangeResultIcon(stopindex);
                        if (stopindex==4)
                        {
                            PopStopRaw();
                        }
                    }
                }
            }
            /// <summary>
            /// 上弹停止列
            /// </summary>
            /// <param name="stopindex">停止列数</param>
            private void PopStopRaw()
            {
                DebugHelper.Log("----PopStopRaw-----");
                Transform reRollTrans = TJZEntry.Instance.RERoll;
                for (int i = 0; i < reRollTrans.childCount; i++)
                {
                    for (int j = 0; j < reRollTrans.GetChild(i).childCount; j++)
                    {
                        Transform go = reRollTrans.GetChild(i).GetChild(j);
                        go.gameObject.SetActive(false);
                        go.transform.localPosition=new Vector3(0, go.transform.localPosition.y, go.transform.localPosition.z);
                    }
                }
                hsm?.ChangeState(nameof(IdleState));
                TJZ_Event.DispatchRollComplete();
            }
        }
    }
}