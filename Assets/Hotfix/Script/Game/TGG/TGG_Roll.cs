

using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


namespace Hotfix.TGG
{
    public class TGG_Roll : ILHotfixEntity
    {
        HierarchicalStateMachine hsm;
        List<IState> states;
        private Transform icons;
        List<ScrollRect> rollList;
        private int rollIndex;
        protected override void Awake()
        {
            base.Awake();
            TGG_Event.StartRoll += TJZ_Event_StartRoll;
            TGG_Event.StopRoll += TJZ_Event_StopRoll;
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
            icons = TGGEntry.Instance.Icons; //图标库
            rollList = new List<ScrollRect>();
            for (int i = 0; i < transform.childCount; i++)
            {
                ScrollRect rect = transform.GetChild(i).GetComponent<ScrollRect>();
                rect.verticalNormalizedPosition = 1;
                rect.elasticity = TGG_DataConfig.rollReboundRate;
                rollList.Add(rect);
            }
            for (int i = 0; i < rollList.Count; i++)
            {
                ChangeRandomIcon(i);
            }
        }

        private void StopRoll()
        {
            hsm?.ChangeState(nameof(StopState));
        }

        protected override void Update()
        {
            base.Update();
            hsm?.Update();
        }
        protected override void OnDestroy()
        {
            base.OnDestroy();
            TGG_Event.StartRoll -= TJZ_Event_StartRoll;
            TGG_Event.StopRoll -= TJZ_Event_StopRoll;
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
                int iconIndex = Random.Range(0, 8);
                string iconName = TGG_DataConfig.IconTable[iconIndex];
                Transform images= icons.FindChildDepth(iconName);
                Sprite changeIcon = images.GetComponent<Image>().sprite;
                iconParent.GetChild(i).FindChildDepth<Image>("Icon").sprite = changeIcon;
            }
        }


        private void ChangeResultIcon(int rollIndex)
        {
            if (rollIndex >= rollList.Count) return;
            Transform iconParent = rollList[rollIndex].content;
            rollList[rollIndex].verticalNormalizedPosition = 1;
            for (int i = 0; i < iconParent.childCount-1; i++)
            {
                Image img = iconParent.GetChild(i).FindChildDepth<Image>("Icon");
                int iconIndex;
                iconIndex = TGGEntry.Instance.GameData.ResultData.ImgTable[i * 5 + rollIndex];
                Transform imTran = icons.FindChildDepth(TGG_DataConfig.IconTable[iconIndex]);
                Sprite changeIcon = imTran.GetComponent<Image>().sprite;
                img.sprite = changeIcon;
                if (i != iconParent.childCount)
                {
                    iconParent.GetChild(i).gameObject.name = TGG_DataConfig.IconTable[iconIndex];
                }
            }
        }

        /// <summary>
        /// 闲置状态
        /// </summary>
        private class IdleState : State<TGG_Roll>
        {
            public IdleState(TGG_Roll owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
        }
        /// <summary>
        /// 转动状态
        /// </summary>
        private class RollState : State<TGG_Roll>
        {
            public RollState(TGG_Roll owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer;
            float startTimer;
            public override void OnEnter()
            {
                base.OnEnter();
                timer = TGG_DataConfig.rollInterval;
                startTimer = 0;
                owner.rollIndex = 0;
                TGGEntry.Instance.GameData.JackPotNum = TGGEntry.Instance.GameData.ResultData.caiJin;
                TGG_Event.DispatchOnChangeJackPot();
            }

            public override void Update()
            {
                base.Update();
                for (int i = 0; i < owner.rollIndex; i++)
                {
                    owner.rollList[i].verticalNormalizedPosition += Time.deltaTime * TGG_DataConfig.rollSpeed; //旋转
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
                    if (timer >= TGG_DataConfig.rollInterval)
                    {
                        timer = 0;
                        //TODO 赋值转动icon
                        owner.rollIndex++;
                        if (owner.rollIndex == owner.rollList.Count)
                        {
                            TGG_Event.DispatchRollPrepreaComplete();
                        }
                    }
                }
                if (owner.rollIndex == owner.rollList.Count && startTimer <= TGG_DataConfig.rollTime)
                {
                    //计算旋转时间，时间到就停止
                    startTimer += Time.deltaTime;
                    if (startTimer >= TGG_DataConfig.rollTime)
                    {
                        startTimer = 0;
                        TGG_Event.DispatchStopRoll(false);
                    }
                }
            }
        }

        /// <summary>
        /// 停止状态
        /// </summary>
        private class StopState : State<TGG_Roll>
        {
            public StopState(TGG_Roll owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
                    owner.rollList[i].verticalNormalizedPosition += Time.deltaTime * TGG_DataConfig.rollSpeed; //旋转
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
                    if (stopTimer >= TGG_DataConfig.rollStopInterval)
                    {
                        stopTimer = 0;
                        //TODO 换正式结果图片
                        stopIndex++;
                        int stopindex = stopIndex - 1;
                        owner.rollList[stopindex].verticalNormalizedPosition = 0;
                        TGG_Audio.Instance.PlaySound(TGG_Audio.RS);

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
                hsm?.ChangeState(nameof(IdleState));
                TGG_Event.DispatchRollComplete();
            }
        }
    }
}