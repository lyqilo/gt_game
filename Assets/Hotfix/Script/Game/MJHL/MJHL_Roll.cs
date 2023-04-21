

using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


namespace Hotfix.MJHL
{
    public class MJHL_Roll : ILHotfixEntity
    {
        HierarchicalStateMachine hsm;
        List<IState> states;
        private Transform icons;
        List<ScrollRect> rollList;
        List<int> list;
        private int rollIndex;
        private Transform CSContent;
        bool iscbRerun;

        private int AllWinGold;
        int currentShowAddRaw;
        int scatterCount = 0;

        private Transform FreeMove;
        private Transform MoveIcon;
        private Transform Loong;

        protected override void Awake()
        {
            base.Awake();
            Init();
        }

        protected override void AddEvent()
        {
            base.AddEvent();
            MJHL_Event.StartRoll += MJHL_Event_StartRoll;
            MJHL_Event.StopRoll += MJHL_Event_StopRoll;
        }

        private void Init()
        {
            icons = MJHLEntry.Instance.mainContent.FindChildDepth("Content/Icons"); //图标库
            CSContent= MJHLEntry.Instance.mainContent.FindChildDepth("Content/CSContent");
            FreeMove = MJHLEntry.Instance.mainContent.FindChildDepth("Content/FreeMove");
            MoveIcon = FreeMove.FindChildDepth("MoveIcon");
            Loong = FreeMove.FindChildDepth("Loong");
            rollList = new List<ScrollRect>();
            for (int i = 0; i < transform.childCount; i++)
            {
                ScrollRect rect = transform.GetChild(i).GetComponent<ScrollRect>();
                rect.verticalNormalizedPosition = 0;
                rect.elasticity = MJHL_DataConfig.rollReboundRate;
                rollList.Add(rect);
            }
            for (int i = 0; i < rollList.Count; i++)
            {
                ChangeRandomIcon(i);
            }
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
            iscbRerun = false;
            AllWinGold = 0;
        }
        protected override void Update()
        {
            base.Update();
            hsm?.Update();
        }

        protected override void RemoveEvent()
        {
            base.RemoveEvent();
            MJHL_Event.StartRoll -= MJHL_Event_StartRoll;
            MJHL_Event.StopRoll -= MJHL_Event_StopRoll;
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            hsm?.CurrentState.OnExit();

        }

        private void MJHL_Event_StartRoll()
        {
            hsm?.ChangeState(nameof(RollState));
        }

        private void MJHL_Event_StopRoll(bool force)
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
        private void ChangeRandomIcon(int rollIndex, bool isMH = false)
        {
            Transform iconParent = rollList[rollIndex].content;
            int num = 0;
            for (int i = 0; i < iconParent.childCount; i++)
            {
                int iconIndex = Random.Range(0, 9);
                string iconName = isMH ? $"{MJHL_DataConfig.IconTable[iconIndex]}" : MJHL_DataConfig.IconTable[iconIndex];
                Transform changeIcon =icons.FindChildDepth(iconName);
                iconParent.GetChild(i).GetChild(0).FindChildDepth<Image>("Image").sprite = changeIcon.FindChildDepth<Image>("Image").sprite;
                iconParent.GetChild(i).GetChild(0).FindChildDepth("Image").GetComponent<Image>().SetNativeSize();
                iconParent.GetChild(i).GetChild(0).gameObject.SetActive(true);
                iconParent.GetChild(i).FindChildDepth("Item10").gameObject.SetActive(false);
                iconParent.GetChild(i).FindChildDepth("Item11").gameObject.SetActive(false);
                num = Random.Range(0, 11);
                if (num > 10)
                {
                    iconParent.GetChild(i).GetChild(0).FindChildDepth("BG_yellow").gameObject.SetActive(true);
                    iconParent.GetChild(i).GetChild(0).FindChildDepth("BG").gameObject.SetActive(false);
                }
                else
                {
                    iconParent.GetChild(i).GetChild(0).FindChildDepth("BG_yellow").gameObject.SetActive(false);
                    iconParent.GetChild(i).GetChild(0).FindChildDepth("BG").gameObject.SetActive(true);
                }
            }
        }
        private void ChangeResultIcon(int rollIndex)
        {
            if (rollIndex >= rollList.Count) return;
            Transform iconParent = rollList[rollIndex].content;
            int item11Count = 0;
            for (int i = 0; i < iconParent.childCount-1; i++)
            {
                int iconIndex;
                if (i == iconParent.childCount - 1)
                {
                    iconIndex = Random.Range(0, 8);
                }
                else
                {
                    iconIndex = MJHLEntry.Instance.GameData.ResultData.tagIconInfo[MJHLEntry.Instance.GameData.Index].cbIcon[i * 5 + rollIndex];
                }
                if (iconIndex < 9)
                {
                    iconParent.GetChild(i + 1).GetChild(0).gameObject.SetActive(true);
                    iconParent.GetChild(i + 1).FindChildDepth("Item10").gameObject.SetActive(false);
                    iconParent.GetChild(i + 1).FindChildDepth("Item11").gameObject.SetActive(false);
                    Transform changeIcon = icons.FindChildDepth(MJHL_DataConfig.IconTable[iconIndex]);
                    iconParent.GetChild(i + 1).GetChild(0).FindChildDepth<Image>("Image").sprite = changeIcon.FindChildDepth<Image>("Image").sprite;
                    iconParent.GetChild(i + 1).GetChild(0).FindChildDepth("Image").GetComponent<Image>().SetNativeSize();
                    iconParent.GetChild(i + 1).gameObject.name = MJHL_DataConfig.IconTable[iconIndex];

                    if (MJHLEntry.Instance.GameData.ResultData.tagIconInfo[MJHLEntry.Instance.GameData.Index].cbGoldIconInfo[i * 5 + rollIndex] > 0)
                    {
                        iconParent.GetChild(i + 1).GetChild(0).FindChildDepth("BG").gameObject.SetActive(false);
                        iconParent.GetChild(i + 1).GetChild(0).FindChildDepth("BG_yellow").gameObject.SetActive(true);
                    }
                    else
                    {
                        iconParent.GetChild(i + 1).GetChild(0).FindChildDepth("BG").gameObject.SetActive(true);
                        iconParent.GetChild(i + 1).GetChild(0).FindChildDepth("BG_yellow").gameObject.SetActive(false);
                    }
                }
                else 
                {
                    iconParent.GetChild(i + 1).GetChild(0).gameObject.SetActive(false);
                    iconParent.GetChild(i + 1).FindChildDepth(MJHL_DataConfig.IconTable[iconIndex]).gameObject.SetActive(true);
                    iconParent.GetChild(i + 1).gameObject.name = MJHL_DataConfig.IconTable[iconIndex];
                }
                if (i != iconParent.childCount)
                {
                    iconParent.GetChild(i+1).gameObject.name = MJHL_DataConfig.IconTable[iconIndex];
                }
                if (iconIndex == 10 && !MJHLEntry.Instance.GameData.isFreeGame && i != 0 && (i * 5 + rollIndex) != 25 && (i * 5 + rollIndex) != 29)
                {
                    scatterCount++;
                    item11Count++;
                }
            }

            rollList[rollIndex].verticalNormalizedPosition = 0;

            if (item11Count>0)
            {
                MJHL_Audio.Instance.PlaySound(MJHL_Audio.MJ_hu);
            }
        }

        /// <summary>
        /// 闲置状态
        /// </summary>
        private class IdleState : State<MJHL_Roll>
        {
            public IdleState(MJHL_Roll owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
        }
        /// <summary>
        /// 转动状态
        /// </summary>
        private class RollState : State<MJHL_Roll>
        {

            float timer;
            float startTimer;

            public RollState(MJHL_Roll owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                if (MJHLEntry.Instance.GameData.TotalFreeWin>0 || MJHLEntry.Instance.GameData.isFreeGame)
                {
                    MJHLEntry.Instance.GameData.TotalFreeWin += MJHLEntry.Instance.GameData.ResultData.nWinGold;
                }
                startTimer = 0;
                owner.rollIndex = 0;

                if (MJHLEntry.Instance.GameData.isFreeGame)
                {
                    owner.FreeMove.gameObject.SetActive(true);
                    owner.Loong.gameObject.SetActive(true);
                    owner.MoveIcon.localPosition = new Vector3(owner.MoveIcon.localPosition.x, 233, owner.MoveIcon.localPosition.z);
                    for (int i = 0; i < owner.MoveIcon.childCount; i++)
                    {
                        if (i % 2 == 0)
                            owner.MoveIcon.GetChild(i).localPosition = new Vector3(700, owner.MoveIcon.GetChild(i).localPosition.y, owner.MoveIcon.GetChild(i).localPosition.z);
                        else
                            owner.MoveIcon.GetChild(i).localPosition = new Vector3(-700, owner.MoveIcon.GetChild(i).localPosition.y, owner.MoveIcon.GetChild(i).localPosition.z);

                        if (i != 0)
                            owner.MoveIcon.GetChild(i).localScale = new Vector3(2, 2, 2);
                    }
                }
                owner.Behaviour.StartCoroutine(MoveIcons());
            }
            IEnumerator MoveIcons()
            {
                owner.MoveIcon.GetChild(0).localPosition = new Vector3(0, owner.MoveIcon.GetChild(0).localPosition.y, owner.MoveIcon.GetChild(0).localPosition.z);

                yield return new WaitForEndOfFrame();
                owner.MoveIcon.gameObject.SetActive(true);

                owner.MoveIcon.GetChild(1).DOLocalMoveX(0,0.5f);
                owner.MoveIcon.GetChild(1).DOScale(1, 0.5f);
                yield return new WaitForSeconds(0.2f);

                owner.MoveIcon.GetChild(2).DOLocalMoveX(0, 0.5f);
                owner.MoveIcon.GetChild(2).DOScale(1, 0.5f);
                yield return new WaitForSeconds(0.2f);

                owner.MoveIcon.GetChild(3).DOLocalMoveX(0, 0.5f);
                owner.MoveIcon.GetChild(3).DOScale(1, 0.5f);
                yield return new WaitForSeconds(0.2f);

                owner.MoveIcon.GetChild(4).DOLocalMoveX(0, 0.5f);
                owner.MoveIcon.GetChild(4).DOScale(1, 0.5f);
                yield return new WaitForSeconds(0.2f);

                owner.MoveIcon.GetChild(5).DOLocalMoveX(0, 0.5f);
                owner.MoveIcon.GetChild(5).DOScale(1, 0.5f);
                yield return new WaitForSeconds(0.9f);

                owner.MoveIcon.DOLocalMoveY(-1500, 0.3f);
                yield return new WaitForSeconds(0.3f);
                owner.MoveIcon.gameObject.SetActive(false);
                owner.Loong.gameObject.SetActive(false);
            }
            public override void Update()
            {
                base.Update();
                for (int i = 0; i < owner.rollIndex; i++)
                {
                    owner.rollList[i].verticalNormalizedPosition+=Time.deltaTime * MJHL_DataConfig.rollSpeed; //旋转
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
                    if (timer >= MJHL_DataConfig.rollInterval)
                    {
                        timer = 0;
                        //TODO 赋值转动icon
                        owner.rollIndex++;
                        if (owner.rollIndex == owner.rollList.Count)
                        {
                            MJHL_Event.DispatchRollPrepreaComplete();
                        }
                    }
                }
                if (owner.rollIndex == owner.rollList.Count && startTimer <= MJHL_DataConfig.rollTime)
                {
                    //计算旋转时间，时间到就停止
                    startTimer += Time.deltaTime;
                    if (startTimer >= MJHL_DataConfig.rollTime)
                    {
                        startTimer = 0;
                        MJHL_Event.DispatchStopRoll(false);
                    }
                }
            }
        }
  
        /// <summary>
        /// 停止状态
        /// </summary>
        private class StopState : State<MJHL_Roll>
        {
            int stopIndex = 0;
            float stopTimer = 0;
            int count = 0;

            private List<byte> ListIcon = new List<byte>();

            public StopState(MJHL_Roll owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                stopIndex = 0;
                stopTimer = 0;
                count = 0;
                owner.scatterCount = 0;
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
                    if (stopTimer >= MJHL_DataConfig.rollStopInterval)
                    {
                        if (stopIndex == owner.currentShowAddRaw && owner.currentShowAddRaw != 0)
                        {
                            if (stopTimer <= MJHL_DataConfig.addSpeedTime) return;
                        }
                        stopTimer = 0;
                        //TODO 换正式结果图片
                        stopIndex++;
                        int stopindex = stopIndex - 1;
                        owner.ChangeResultIcon(stopindex);
                        MJHL_Audio.Instance.PlaySound(MJHL_Audio.MJ_forcestop);
                        if (owner.scatterCount>=2)
                        {
                            ShowAddEffect(stopindex);
                        }
                        if (stopIndex == owner.rollList.Count)
                        {
                            hsm?.ChangeState(nameof(IdleState));
                            if (MJHLEntry.Instance.GameData.Index < MJHLEntry.Instance.GameData.ResultData.cbTurn)
                            {
                                MJHL_Event.DispatchShowLine();
                            }
                            else
                            {
                                MJHL_Event.DispatchRollComplete();
                            }
                        }
                    }
                }
            }

            /// <summary>
            /// 展示加速
            /// </summary>
            private void ShowAddEffect(int stopindex)
            {
                if (MJHLEntry.Instance.GameData.isFreeGame) return;
                if (owner.scatterCount >= 2)
                {
                    for (int i = 0; i < owner.CSContent.childCount; i++)
                    {
                        owner.CSContent.GetChild(i).gameObject.SetActive(true);
                        owner.CSContent.GetChild(i).GetComponent<Image>().enabled = true;
                        owner.CSContent.GetChild(i).FindChildDepth("Light").gameObject.SetActive(false);
                    }
                    if (stopindex<4)
                    {
                        owner.CSContent.GetChild(stopindex + 1).GetComponent<Image>().enabled = false;
                        owner.CSContent.GetChild(stopindex + 1).FindChildDepth("Light").gameObject.SetActive(true);
                    }
                    owner.currentShowAddRaw = stopindex + 1;
                    if (owner.currentShowAddRaw > 4)
                    {
                        owner.currentShowAddRaw = 0;
                        for (int i = 0; i < owner.CSContent.childCount; i++)
                        {
                            owner.CSContent.GetChild(i).gameObject.SetActive(false);
                            owner.CSContent.GetChild(i).GetComponent<Image>().enabled = true;
                            owner.CSContent.GetChild(i).FindChildDepth("Light").gameObject.SetActive(false);
                        }
                        return;
                    }
                    //MJHL_Audio.Instance.PlaySound(MJHL_Audio.Light);
                }
            }

            /// <summary>
            /// 循环旋转
            /// </summary>
            private void RollRepeat()
            {
                for (int i = stopIndex; i < owner.rollIndex; i++)
                {
                    owner.rollList[i].verticalNormalizedPosition += Time.deltaTime * MJHL_DataConfig.rollSpeed; //旋转
                    if (owner.rollList[i].verticalNormalizedPosition >= 1)
                    {
                        owner.rollList[i].verticalNormalizedPosition = 0;
                        owner.ChangeRandomIcon(i, true);
                        count++;
                        if (count >= 2)
                        {
                            count = 0;
                           // MJHL_Audio.Instance.PlaySound(MJHL_Audio.LoopWheel);
                        }
                    }
                }
            }
        }
    }
}
