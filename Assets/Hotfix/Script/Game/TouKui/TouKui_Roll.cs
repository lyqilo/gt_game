

using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.TouKui
{
    public class TouKui_Roll : ILHotfixEntity
    {
        HierarchicalStateMachine hsm;
        List<IState> states;
        private Transform icons;
        private Transform addContent;
        List<ScrollRect> rollList;
        private int rollIndex;
        int currentShowAddRaw;
        int scatterCount = 0;
        bool isForce = false;

        protected override void AddEvent()
        {
            base.AddEvent();
            TouKui_Event.StartRoll += TouKui_Event_StartRoll;
            TouKui_Event.StopRoll += TouKui_Event_StopRoll;
            TouKui_Event.ExitSpecialMode += TouKui_Event_ExitSpecialMode;
            HotfixActionHelper.ReconnectGame += EventHelper_ReconnectGame;
        }


        protected override void Start()
        {
            base.Start();
            hsm = new HierarchicalStateMachine(false, gameObject);
            states = new List<IState>();
            states.Add(new IdleState(this, hsm));
            states.Add(new InitState(this, hsm));
            states.Add(new RollState(this, hsm));
            states.Add(new StopState(this, hsm));
            hsm.Init(states, nameof(InitState));
        }
        protected override void Update()
        {
            base.Update();
            hsm?.Update();
        }

        protected override void RemoveEvent()
        {
            base.RemoveEvent();
            TouKui_Event.StartRoll -= TouKui_Event_StartRoll;
            TouKui_Event.StopRoll -= TouKui_Event_StopRoll;
            TouKui_Event.ExitSpecialMode -= TouKui_Event_ExitSpecialMode;
            HotfixActionHelper.ReconnectGame -= EventHelper_ReconnectGame;
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            hsm?.CurrentState.OnExit();
        }

        private void TouKui_Event_ExitSpecialMode()
        {
            for (int i = 0; i < TouKuiEntry.Instance.GameData.ResultData.cbIcon.Count; i++)
            {
                int iconIndex = TouKuiEntry.Instance.GameData.ResultData.cbIcon[i];
                if (iconIndex != 10) continue;
                int row = i / 5;
                int col = i % 5;
                Image img = rollList[col].content.GetChild(row).FindChildDepth<Image>("Icon");
                Sprite changeIcon = icons.FindChildDepth<Image>(TouKui_DataConfig.IconTable[iconIndex]).sprite;
                img.sprite = changeIcon;
            }
        }


        private void EventHelper_ReconnectGame()
        {
            hsm?.ChangeState(nameof(IdleState));
        }
        private void TouKui_Event_StartRoll()
        {
            //判断特殊模式时候是否延迟
            if (TouKuiEntry.Instance.GameData.CurrentMode.Equals(SpecialMode.GuDing))
            {
                Behaviour.StartCoroutine(DelayRoll(0.5f));
                return;
            }

            if (TouKuiEntry.Instance.GameData.CurrentNormalMode != SpecialMode.None)//特殊模式
            {
                DebugHelper.Log($"进入特殊模式{TouKuiEntry.Instance.GameData.CurrentNormalMode}");
                TouKuiEntry.Instance.GameData.isNormalFreeGame = true;
                TouKui_Event.DispatchOnEnterSpecialGame(false, TouKuiEntry.Instance.GameData.CurrentNormalMode);
            }
            Behaviour.StartCoroutine(DelayRoll(0));
        }
        private IEnumerator DelayRoll(float timer)
        {
            if (timer <= 0)
            {
                yield return new WaitForEndOfFrame();
            }
            else
            {
                yield return new WaitForSeconds(timer);
            }
            hsm?.ChangeState(nameof(RollState));
        }
        private void TouKui_Event_StopRoll(bool force)
        {
            if (force)
            {
                isForce = force;
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
        private void ChangeRandomIcon(int rollIndex,bool isMH=false)
        {
            Transform iconParent = rollList[rollIndex].content;
            for (int i = 0; i < iconParent.childCount; i++)
            {
                int iconIndex = Random.Range(0, 9);
                string iconName = isMH ? $"MH_{TouKui_DataConfig.IconTable[iconIndex]}" : TouKui_DataConfig.IconTable[iconIndex];
                Sprite changeIcon = icons.FindChildDepth<Image>(iconName).sprite;
                iconParent.GetChild(i).Find("Icon").GetComponent<Image>().sprite = changeIcon;
                Transform tempgroup = iconParent.GetChild(i).Find("TempGroup");
                if (tempgroup != null)
                {
                    for (int j = 1; j < tempgroup.childCount; j++)
                    {
                        Transform tempIcon = tempgroup.GetChild(j);
                        tempIcon.GetComponent<Image>().sprite = changeIcon;
                        tempIcon.GetComponent<Image>().SetNativeSize();
                    }
                }
                iconParent.GetChild(i).Find("Icon").GetComponent<Image>().SetNativeSize();
            }
        }
        private void ChangeResultIcon(int rollIndex)
        {
            if (rollIndex >= rollList.Count) return;
            Transform iconParent = rollList[rollIndex].content;
            for (int i = 0; i < iconParent.childCount - 1; i++)
            {
                Image img = iconParent.GetChild(i).FindChildDepth<Image>("Icon");
                int iconIndex;
                if (i == iconParent.childCount - 1)
                {
                    iconIndex = Random.Range(0, 9);
                }
                else
                {
                    iconIndex = TouKuiEntry.Instance.GameData.ResultData.cbIcon[i * 5 + rollIndex];
                    if (iconIndex == 10)//是否是特殊免费模式，更换wild
                    {
                        if (TouKuiEntry.Instance.GameData.isFreeGame)
                        {
                            iconIndex = 11 + (int)TouKuiEntry.Instance.GameData.CurrentMode;
                        }
                        else if (TouKuiEntry.Instance.GameData.isNormalFreeGame)
                        {
                            iconIndex = 11 + (int)TouKuiEntry.Instance.GameData.CurrentNormalMode;
                        }
                    }
                    if (iconIndex == 11 && !TouKuiEntry.Instance.GameData.isFreeGame && !TouKuiEntry.Instance.GameData.isNormalFreeGame)
                    {
                        //判断是否为scatter
                        scatterCount++;
                        currentShowAddRaw = rollIndex + 1;
                    }
                }
                Sprite changeIcon = icons.FindChildDepth<Image>(TouKui_DataConfig.IconTable[iconIndex]).sprite;
                img.sprite = changeIcon;
                if (i != iconParent.childCount - 1)
                {
                    iconParent.GetChild(i).gameObject.name = TouKui_DataConfig.IconTable[iconIndex];
                }
                img.SetNativeSize();
                Transform tempgroup = iconParent.GetChild(i).Find("TempGroup");
                if (tempgroup != null)
                {
                    for (int j = 0; j < tempgroup.childCount; j++)
                    {
                        Transform tempIcon = tempgroup.GetChild(j);
                        iconIndex = Random.Range(1, 8);
                        changeIcon = icons.FindChildDepth<Image>(TouKui_DataConfig.IconTable[iconIndex]).sprite;
                        tempIcon.GetComponent<Image>().SetNativeSize();
                        tempIcon.GetComponent<Image>().sprite = changeIcon;
                    }
                }
            }
        }
        /// <summary>
        /// 闲置状态
        /// </summary>
        private class IdleState : State<TouKui_Roll>
        {
            public IdleState(TouKui_Roll owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
        }
        /// <summary>
        /// 初始化
        /// </summary>
        private class InitState : State<TouKui_Roll>
        {
            public InitState(TouKui_Roll owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                Init();
            }
            private void Init()
            {
                owner.icons = TouKuiEntry.Instance.MainContent.FindChildDepth("Content/Icons"); //图标库
                owner.addContent = TouKuiEntry.Instance.MainContent.FindChildDepth("Content/CSContent"); //图标库
                owner.rollList = new List<ScrollRect>();
                for (int i = 0; i < owner.transform.childCount; i++)
                {
                    ScrollRect rect = owner.transform.GetChild(i).GetComponent<ScrollRect>();
                    GameObject tempObj = new GameObject("TempGroup");
                    tempObj.transform.SetParent(rect.content.GetChild(0));
                    tempObj.transform.localPosition = new Vector3(0, 188 * 2.5f, 0);
                    tempObj.transform.localRotation = Quaternion.identity;
                    tempObj.transform.localScale = Vector3.one;
                    for (int j = 0; j < 4; j++)
                    {
                        GameObject temp1 = GameObject.Instantiate(rect.content.GetChild(0).GetChild(0).gameObject);
                        temp1.transform.SetParent(tempObj.transform);
                        temp1.transform.localPosition = new Vector3(0, 188 * (j - 1.5f), 0);
                        temp1.transform.localRotation = Quaternion.identity;
                        temp1.transform.localScale = Vector3.one;
                        temp1.gameObject.name = "Temp";
                    }

                    GameObject temp2 = GameObject.Instantiate(rect.content.GetChild(0).GetChild(0).gameObject);
                    temp2.transform.SetParent(rect.content.GetChild(rect.content.childCount - 1));
                    temp2.transform.localPosition = new Vector3(0, -188, 0);
                    temp2.transform.localRotation = Quaternion.identity;
                    temp2.transform.localScale = Vector3.one;
                    temp2.gameObject.name = "Temp";
                    rect.verticalNormalizedPosition = 0;
                    rect.elasticity = TouKui_DataConfig.rollReboundRate;
                    owner.rollList.Add(rect);
                }
                for (int i = 0; i < owner.rollList.Count; i++)
                {
                    owner.ChangeRandomIcon(i);
                }
            }
        }

        /// <summary>
        /// 转动状态
        /// </summary>
        private class RollState : State<TouKui_Roll>
        {
            public RollState(TouKui_Roll owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer;
            float startTimer;
            int count = 0;
            public override void OnEnter()
            {
                base.OnEnter();
                timer = TouKui_DataConfig.rollInterval;
                startTimer = 0;
                owner.rollIndex = 0;
                count = 0;
                owner.scatterCount = 0;
                owner.isForce = false;
            }
            public override void Update()
            {
                base.Update();
                for (int i = 0; i < owner.rollIndex; i++)
                {
                    owner.rollList[i].verticalNormalizedPosition += Time.deltaTime * TouKui_DataConfig.rollSpeed; //旋转
                    if (owner.rollList[i].verticalNormalizedPosition >= 1)
                    {
                        owner.rollList[i].verticalNormalizedPosition = 0;
                        owner.ChangeRandomIcon(i,true);
                        count++;
                        if (count >= 2)
                        {
                            count = 0;
                            TouKui_Audio.Instance.PlaySound(TouKui_Audio.LoopWheel);
                        }
                    }
                }
                if (owner.rollIndex < owner.rollList.Count)
                {
                    //计算转动间隔
                    timer += Time.deltaTime;
                    if (timer >= TouKui_DataConfig.rollInterval)
                    {
                        timer = 0;
                        TouKui_Audio.Instance.PlaySound(TouKui_Audio.RunWheel);
                        //TODO 赋值转动icon
                        owner.rollIndex++;
                        if (owner.rollIndex == owner.rollList.Count)
                        {
                            TouKui_Event.DispatchRollPrepreaComplete();
                        }
                    }
                }
                if (owner.rollIndex == owner.rollList.Count && startTimer <= TouKui_DataConfig.rollTime)
                {
                    //计算旋转时间，时间到就停止
                    startTimer += Time.deltaTime;
                    if (startTimer >= TouKui_DataConfig.rollTime)
                    {
                        startTimer = 0;
                        TouKui_Event.DispatchStopRoll(false);
                    }
                }
            }
        }
        /// <summary>
        /// 停止状态
        /// </summary>
        private class StopState : State<TouKui_Roll>
        {
            public StopState(TouKui_Roll owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            int stopIndex = 0;
            float stopTimer = 0;
            int count = 0;

            public override void OnEnter()
            {
                base.OnEnter();
                stopIndex = 0;
                stopTimer = 0;
                count = 0;
                owner.currentShowAddRaw = 0;
            }
            public override void Update()
            {
                base.Update();
                RollRepeat();
                CalculateStop();
            }

            private void CalculateStop()
            {
                if (stopIndex < owner.rollList.Count)
                {
                    //计算转动间隔
                    stopTimer += Time.deltaTime;
                    if (stopTimer >= TouKui_DataConfig.rollStopInterval)
                    {
                        if (stopIndex == owner.currentShowAddRaw && owner.currentShowAddRaw != 0)
                        {
                            if (stopTimer <= TouKui_DataConfig.addSpeedTime) return;
                        }
                        stopTimer = 0;
                        //TODO 换正式结果图片
                        stopIndex++;
                        int stopindex = stopIndex - 1;
                        owner.ChangeResultIcon(stopindex);
                        ShowAddEffect(stopindex);
                        PopStopRaw(stopindex);
                    }
                }
            }
            /// <summary>
            /// 展示加速
            /// </summary>
            private void ShowAddEffect(int stopindex)
            {
                if (TouKuiEntry.Instance.GameData.isFreeGame || TouKuiEntry.Instance.GameData.isNormalFreeGame) return;
                if (owner.scatterCount == 2)
                {
                    if (owner.currentShowAddRaw != 0 && owner.currentShowAddRaw <= 4)
                    {
                        owner.addContent.GetChild(owner.currentShowAddRaw).GetComponent<CanvasGroup>().alpha = 0;
                    }
                    owner.currentShowAddRaw = stopindex + 1;
                    if (owner.currentShowAddRaw > 4)
                    {
                        owner.currentShowAddRaw = 0;
                        return;
                    }
                    TouKui_Audio.Instance.PlaySound(TouKui_Audio.Light);
                    owner.addContent.GetChild(owner.currentShowAddRaw).GetComponent<CanvasGroup>().alpha = 1;
                }
                else
                {
                    for (int i = 0; i < owner.addContent.childCount; i++)
                    {
                        owner.addContent.GetChild(i).GetComponent<CanvasGroup>().alpha = 0;
                    }
                    owner.currentShowAddRaw = 0;
                }
            }
            /// <summary>
            /// 上弹停止列
            /// </summary>
            /// <param name="stopindex">停止列数</param>
            private void PopStopRaw(int stopindex)
            {
                owner.rollList[stopindex].verticalNormalizedPosition = 1;
                owner.rollList[stopindex].content.DOLocalMove(new Vector3(94.5f, -TouKui_DataConfig.rollDistance, 0), 0.1f).SetEase(Ease.Linear).OnComplete(delegate ()
                {
                    float timer = 0.1f;
                    owner.rollList[stopindex].content.DOLocalMove(new Vector3(94.5f, 0, 0), timer).SetEase(Ease.Linear).OnComplete(delegate ()
                    {
                        TouKui_Audio.Instance.PlaySound(TouKui_Audio.StopWheel);
                        PlaySpecialAnim(stopindex);
                        CollectBeiShu(stopindex);
                        if (stopIndex == owner.rollList.Count)
                        {
                            for (int i = 0; i < owner.addContent.childCount; i++)
                            {
                                owner.addContent.GetChild(i).GetComponent<CanvasGroup>().alpha = 0;
                            }
                            hsm?.ChangeState(nameof(IdleState));
                            ToolHelper.RunGoal(0, 1, 0.7f).OnComplete(delegate ()
                            {
                                TouKui_Event.DispatchRollComplete();
                            });
                        }
                    });
                });
            }
            /// <summary>
            /// 收集学妹icon位置
            /// </summary>
            private void CollectBeiShu(int stopindex)
            {
                List<Vector3> pos = new List<Vector3>();
                for (int i = 0; i < 3; i++)
                {
                    Transform child = owner.rollList[stopindex].content.GetChild(i);
                    if (child.name.Equals("Item15"))
                    {
                        pos.Add(child.position);
                    }
                }
                TouKui_Event.DispatchAddSpecialBeiShu(pos);
            }
            /// <summary>
            /// 播放特殊符号动画（屁股 胸）
            /// </summary>
            /// <param name="stopindex">停止列数</param>
            private void PlaySpecialAnim(int stopindex)
            {
                //判断该列里面有没有 需要独立显示一次动画的
                for (int i = 0; i < 3; i++)
                {
                    Transform child = owner.rollList[stopindex].content.GetChild(i);
                    if (child.name.Equals("Item7") || child.name.Equals("Item8") || child.name.Equals("Item9") || child.name.Equals("Item10"))
                    {
                        GameObject effect = CreateEffect(child.name);
                        Image icon = child.FindChildDepth<Image>("Icon");
                        effect.transform.SetParent(icon.transform);
                        effect.transform.localPosition = Vector3.zero;
                        effect.transform.localRotation = Quaternion.identity;
                        effect.transform.localScale = Vector3.one;
                        effect.SetActive(true);
                        icon.enabled = false;
                        ToolHelper.RunGoal(0, 1, 0.7f).OnComplete(delegate ()
                        {
                            CollectEffect(effect);
                            icon.enabled = true;
                        });
                    }
                }
            }

            /// <summary>
            /// 循环旋转
            /// </summary>
            private void RollRepeat()
            {
                for (int i = stopIndex; i < owner.rollIndex; i++)
                {
                    owner.rollList[i].verticalNormalizedPosition += Time.deltaTime * TouKui_DataConfig.rollSpeed; //旋转
                    if (owner.rollList[i].verticalNormalizedPosition >= 1)
                    {
                        owner.rollList[i].verticalNormalizedPosition = 0;
                        owner.ChangeRandomIcon(i, true);
                        count++;
                        if (count >= 2)
                        {
                            count = 0;
                            TouKui_Audio.Instance.PlaySound(TouKui_Audio.LoopWheel);
                        }
                    }
                }
            }

            private GameObject CreateEffect(string effectName)
            {
                //创建动画，先从对象池中获取
                Transform go = TouKuiEntry.Instance.effectPool.Find(effectName);
                if (go != null) return go.gameObject;

                go = TouKuiEntry.Instance.effectList.Find(effectName);
                GameObject _go = GameObject.Instantiate(go.gameObject);
                return _go;
            }
            /// <summary>
            /// 回收特效动画
            /// </summary>
            /// <param name="effect">特效动画</param>
            private void CollectEffect(GameObject effect)
            {
                if (effect == null) return;
                effect.transform.SetParent(TouKuiEntry.Instance.effectPool);
                effect.SetActive(false);
            }
        }
    }
}
