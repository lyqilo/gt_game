

using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


namespace Hotfix.YGBH
{
    public class YGBH_Roll : ILHotfixEntity
    {
        HierarchicalStateMachine hsm;
        List<IState> states;
        private Transform icons;
        List<ScrollRect> rollList;
        private int rollIndex;
        private int scatterCount;

        protected override void Awake()
        {
            base.Awake();
            YGBH_Event.StartRoll += YGBH_Event_StartRoll;
            YGBH_Event.StopRoll += YGBH_Event_StopRoll;
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
            icons = YGBHEntry.Instance.Icons; //图标库
            rollList = new List<ScrollRect>();
            for (int i = 0; i < transform.childCount; i++)
            {
                ScrollRect rect = transform.GetChild(i).GetComponent<ScrollRect>();
                rect.verticalNormalizedPosition = 1;
                rect.elasticity = YGBH_DataConfig.rollReboundRate;
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
            YGBH_Event.StartRoll -= YGBH_Event_StartRoll;
            YGBH_Event.StopRoll -= YGBH_Event_StopRoll;
        }

        private void YGBH_Event_StartRoll()
        {
            hsm?.ChangeState(nameof(RollState));
        }

        private void YGBH_Event_StopRoll(bool force)
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
                string iconName = YGBH_DataConfig.IconTable[iconIndex];
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
                iconIndex = YGBHEntry.Instance.GameData.ResultData.ImgTable[i * 5 + rollIndex];
                bool isscatter = iconIndex == 12;
                scatterCount += 1;
                switch (scatterCount)
                {
                    case 1:
                    {
                        if (rollIndex < 4)
                            YGBH_Audio.Instance.PlaySound(YGBH_Audio.SCATTER1);
                        break;
                    }
                    case 2:
                    {
                        if (rollIndex < 5)
                            YGBH_Audio.Instance.PlaySound(YGBH_Audio.SCATTER2);
                        break;
                    }
                    case 3:
                        YGBH_Audio.Instance.PlaySound(YGBH_Audio.SCATTER3);
                        break;
                }
                //TODO 白晶晶图片处理
                if (iconIndex == 13)
                {
                    iconIndex = Random.Range(2, 11);
                    DebugHelper.Log("位置：" + (i * 5 + rollIndex));
                    YGBHEntry.Instance.bjjList.Add(YGBH_DataConfig.LightPos[(i * 5 + rollIndex)]);
                    YGBHEntry.Instance.bjjImgList.Add(img);
                }

                Sprite changeIcon = icons.FindChildDepth(YGBH_DataConfig.IconTable[iconIndex]).GetComponent<Image>().sprite;
                if (isscatter)
                {
                    if (img.transform.childCount <= 0)
                    {
                        GameObject go = YGBH_Line.CreateEffect(YGBH_DataConfig.EffectTable[14]);
                        if (go != null)
                        {
                            go.transform.SetParent(img.transform);
                            go.transform.localPosition = Vector3.zero;
                            go.transform.localRotation = Quaternion.identity;
                            go.transform.localScale = Vector3.one * 1.15f;
                            go.gameObject.SetActive(true);
                            go.name = YGBH_DataConfig.EffectTable[14];
                            img.enabled = false;
                        }
                    }
                    YGBHEntry.Instance.scatterList.Add(img.transform);
                }
                img.sprite = changeIcon;
                if (i != iconParent.childCount)
                {
                    iconParent.GetChild(i).gameObject.name = YGBH_DataConfig.IconTable[iconIndex];
                }
            }
        }

        /// <summary>
        /// 闲置状态
        /// </summary>
        private class IdleState : State<YGBH_Roll>
        {
            public IdleState(YGBH_Roll owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
        }
        /// <summary>
        /// 转动状态
        /// </summary>
        private class RollState : State<YGBH_Roll>
        {
            public RollState(YGBH_Roll owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer;
            float startTimer;
            public override void OnEnter()
            {
                base.OnEnter();
                timer = YGBH_DataConfig.rollInterval;
                YGBHEntry.Instance.scatterList.Clear();
                YGBHEntry.Instance.bjjList.Clear();
                YGBHEntry.Instance.bjjImgList.Clear();
                YGBHEntry.Instance.WinDesc.text = "Great fortune";
                startTimer = 0;
                owner.rollIndex = 0;
            }

            public override void Update()
            {
                base.Update();
                for (int i = 0; i < owner.rollIndex; i++)
                {
                    owner.rollList[i].verticalNormalizedPosition += Time.deltaTime * YGBH_DataConfig.rollSpeed; //旋转
                    if (!(owner.rollList[i].verticalNormalizedPosition >= 1)) continue;
                    owner.rollList[i].verticalNormalizedPosition = 0;
                    owner.ChangeRandomIcon(i, true);
                }
                if (owner.rollIndex < owner.rollList.Count)
                {
                    //计算转动间隔
                    timer += Time.deltaTime;
                    if (timer >= YGBH_DataConfig.rollInterval)
                    {
                        timer = 0;
                        //TODO 赋值转动icon
                        owner.rollIndex++;
                        if (owner.rollIndex == owner.rollList.Count)
                        {
                            YGBH_Event.DispatchRollPrepreaComplete();
                        }
                    }
                }

                if (owner.rollIndex != owner.rollList.Count || !(startTimer <= YGBH_DataConfig.rollTime)) return;
                //计算旋转时间，时间到就停止
                startTimer += Time.deltaTime;
                if (!(startTimer >= YGBH_DataConfig.rollTime)) return;
                startTimer = 0;
                YGBH_Event.DispatchStopRoll(false);
            }
        }

        /// <summary>
        /// 停止状态
        /// </summary>
        private class StopState : State<YGBH_Roll>
        {
            public StopState(YGBH_Roll owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
                    owner.rollList[i].verticalNormalizedPosition += Time.deltaTime * YGBH_DataConfig.rollSpeed; //旋转
                    if (!(owner.rollList[i].verticalNormalizedPosition >= 1)) continue;
                    owner.rollList[i].verticalNormalizedPosition = 0;
                    owner.ChangeRandomIcon(i, true);
                }
                CalculateStop();
            }

            private void CalculateStop()
            {
                if (stopIndex >= owner.rollList.Count) return;
                //计算转动间隔
                stopTimer += Time.deltaTime;
                if (!(stopTimer >= YGBH_DataConfig.rollStopInterval)) return;
                stopTimer = 0;
                //TODO 换正式结果图片
                stopIndex++;
                int stopindex = stopIndex - 1;
                owner.rollList[stopindex].verticalNormalizedPosition = 0;
                YGBH_Audio.Instance.PlaySound(YGBH_Audio.RS);
                owner.ChangeResultIcon(stopindex);
                if (stopindex == 4)
                {
                    PopStopRaw();
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
                YGBH_Event.DispatchRollComplete();
            }
        }
    }
}