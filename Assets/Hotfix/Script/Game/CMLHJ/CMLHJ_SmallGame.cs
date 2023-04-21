using System;
using UnityEngine;
using UnityEngine.UI;
using LuaFramework;
using System.Collections.Generic;
using TMPro;
using System.Collections;
using DG.Tweening;

namespace Hotfix.CMLHJ
{
    public class CMLHJ_SmallGame : ILHotfixEntity
    {
        private HierarchicalStateMachine hsm;
        private List<IState> states;

        private Transform Content;
        private Transform RollInfo;

        private Transform MidInfo;
        private TextMeshProUGUI LastCont;
        private Transform MidScroll;

        private Transform Icons;
        private int SmallCount;
        private int rollIndex;
        List<ScrollRect> rollList;

        private int index;
        private List<int> C_MARY_IMG=new List<int>() 
        {
            -1, 4, 1, 3, 0, 2, 5,-1, 0, 1, 3, 2, 0,-1, 4, 1, 0, 2, 1, 7,-1, 0, 1, 3, 2, 0
        };
        private List<int> friutbl = new List<int>()
        {
            2,5,10,20,50,70,100,0,0,
        };
        protected override void Awake()
        {
            base.Awake();
        }
        protected override void Start()
        {
            base.Start();
            rollList = new List<ScrollRect>();
            for (int i = 0; i < MidScroll.childCount; i++)
            {
                ScrollRect rect = MidScroll.GetChild(i).GetComponent<ScrollRect>();
                rect.verticalNormalizedPosition = 0;
                rect.elasticity = CMLHJ_DataConfig.rollReboundRate;
                rollList.Add(rect);
            }
            for (int i = 0; i < rollList.Count; i++)
            {
                ChangeRandomIcon(i);
            }
            hsm = new HierarchicalStateMachine(false, gameObject);
            states = new List<IState>();
            states.Add(new BonusInitState(this, hsm));
            states.Add(new EnterBonusState(this, hsm));
            states.Add(new BonusState(this, hsm));
            states.Add(new SmallOverState(this, hsm));
            hsm.Init(states, nameof(BonusInitState));


        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            RemoveEvent();
        }
        protected override void Update()
        {
            base.Update();
            hsm?.Update();
        }



        protected override void FindComponent()
        {
            Icons = CMLHJEntry.Instance.Icons; //图标库

            Content = this.transform.FindChildDepth("Content");
            RollInfo = Content.FindChildDepth("RollInfo");
            MidInfo= Content.FindChildDepth("MidInfo");
            LastCont = MidInfo.FindChildDepth<TextMeshProUGUI>("Count");
            MidScroll = MidInfo.FindChildDepth("Scroll");
        }
        protected override void AddEvent()
        {
            CMLHJ_Event.EnterSmallGame += SmallGameShow;
            CMLHJ_Event.StartSmallGame += SmallGameRoll;
        }
        protected override void RemoveEvent()
        {
            CMLHJ_Event.EnterSmallGame -= SmallGameShow;
            CMLHJ_Event.StartSmallGame -= SmallGameRoll;
        }

        private void SmallGameShow()
        {
            DebugHelper.Log("-------SmallGameShow----");
            hsm?.ChangeState(nameof(EnterBonusState));
        }

        private void SmallGameRoll()
        {
            hsm?.ChangeState(nameof(BonusState));
        }

        private void ChangeRandomIcon(int rollIndex, bool isMH = false)
        {
            Transform iconParent = rollList[rollIndex].content;
            for (int i = 0; i < iconParent.childCount; i++)
            {
                int iconIndex = UnityEngine.Random.Range(0, 9);
                string iconName = CMLHJ_DataConfig.IconTable[iconIndex];
                Transform images = Icons.FindChildDepth(iconName);
                Sprite changeIcon = images.FindChildDepth<Image>("Image").sprite;
                iconParent.GetChild(i).FindChildDepth<Image>("Image").sprite = changeIcon;
            }
        }

        private void ChangeResultIcon(int rollIndex)
        {
            if (rollIndex >= rollList.Count) return;
            Transform iconParent = rollList[rollIndex].content;
            for (int i = 0; i < iconParent.childCount; i++)
            {
                Image img = iconParent.GetChild(0).FindChildDepth<Image>("Image");
                int iconIndex;
                iconIndex = CMLHJEntry.Instance.GameData.MaryData.nByPrizeImg[rollIndex];
                Transform imTran = Icons.FindChildDepth(CMLHJ_DataConfig.IconTable[iconIndex]);
                Sprite changeIcon = imTran.FindChildDepth<Image>("Image").sprite;
                img.sprite = changeIcon;
                if (i != iconParent.childCount)
                {
                    iconParent.GetChild(0).gameObject.name = CMLHJ_DataConfig.IconTable[iconIndex];
                }
            }
        }

        public class BonusInitState : State<CMLHJ_SmallGame>
        {
            public BonusInitState(CMLHJ_SmallGame owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                owner.Content.gameObject.SetActive(false);
                for (int i = 0; i < owner.RollInfo.childCount; i++)
                {
                    owner.RollInfo.GetChild(i).FindChildDepth("light").gameObject.SetActive(false);
                }

                for (int i = 0; i < owner.rollList.Count; i++)
                {
                    for (int j = 0; j < owner.rollList[i].content.childCount; j++)
                    {
                        owner.rollList[i].content.GetChild(j).FindChildDepth("MidLight").gameObject.SetActive(false);
                        owner.rollList[i].content.GetChild(j).FindChildDepth("Num").gameObject.SetActive(false);
                    }
                }
            }
        }

        public class EnterBonusState : State<CMLHJ_SmallGame>
        {
            bool isEnter;
            float timer;
            public EnterBonusState(CMLHJ_SmallGame owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                DebugHelper.Log("--------EnterBonusState-------");
                isEnter = true;
                timer = 0f;
                owner.LastCont.text =ToolHelper.ShowRichText(CMLHJEntry.Instance.GameData.CurrentMaryCount);
                owner.Content.gameObject.SetActive(true);
            }

            public override void Update()
            {
                base.Update();
                if (!isEnter) return;
                timer += Time.deltaTime;
                if (timer>2f)
                {
                    timer = 0f;
                    isEnter = false;
                    CMLHJ_Network.Instance.StartMaryGame();
                }
            }
        }

        public class BonusState : State<CMLHJ_SmallGame>
        {
            public BonusState(CMLHJ_SmallGame owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer;
            float startTimer;
            bool isStop;
            public override void OnEnter()
            {
                owner.rollIndex = 0;
                startTimer = 0;
                owner.index=0;
                for (int i = 0; i < owner.rollList.Count; i++)
                {
                    for (int j = 0; j < owner.rollList[i].content.childCount; j++)
                    {
                        owner.rollList[i].content.GetChild(j).FindChildDepth("MidLight").gameObject.SetActive(false);
                        owner.rollList[i].content.GetChild(j).FindChildDepth("Num").gameObject.SetActive(false);
                    }
                }
                isStop = false;
                timer = CMLHJ_DataConfig.rollInterval;
                owner.Behaviour.StartCoroutine(StartRollInfo());
            }

            IEnumerator StartRollInfo()
            {
                while (!isStop)
                {
                    if (owner.index >= owner.RollInfo.childCount)
                    {
                        owner.index = 0;
                    }
                    owner.RollInfo.GetChild(owner.index).FindChildDepth("light").gameObject.SetActive(true);
                    yield return new WaitForSeconds(0.05f);
                    owner.RollInfo.GetChild(owner.index).FindChildDepth("light").gameObject.SetActive(false);
                    owner.index++;
                }
            }

            public override void Update()
            {
                base.Update();
                for (int i = 0; i < owner.rollIndex; i++)
                {
                    owner.rollList[i].verticalNormalizedPosition += Time.deltaTime * CMLHJ_DataConfig.rollSpeed; //旋转
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
                    if (timer >= CMLHJ_DataConfig.rollInterval)
                    {
                        timer = 0;
                        //TODO 赋值转动icon
                        owner.rollIndex++;
                        if (owner.rollIndex == owner.rollList.Count)
                        {
                            CMLHJ_Event.DispatchRollPrepreaComplete();
                        }
                    }
                }

                if (owner.rollIndex == owner.rollList.Count && startTimer <= CMLHJ_DataConfig.maryRollTime)
                {
                    //计算旋转时间，时间到就停止
                    startTimer += Time.deltaTime;
                    if (startTimer >= CMLHJ_DataConfig.maryRollTime)
                    {
                        startTimer = 0;
                        isStop = true;
                        if (owner.rollIndex == owner.rollList.Count)
                        {
                            hsm?.ChangeState(nameof(SmallOverState));
                        }
                    }
                }
            }
        }

        private class SmallOverState : State<CMLHJ_SmallGame>
        {
            public SmallOverState(CMLHJ_SmallGame owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            int stopIndex = 0;
            float stopTimer = 0;
            bool isStop;
            bool isRoll;

            public override void OnEnter()
            {
                base.OnEnter();
                stopIndex = 0;
                stopTimer = 0;
                isStop = false;
                isRoll = false;
                owner.Behaviour.StartCoroutine(StartRollInfo());
            }
            IEnumerator StartRollInfo()
            {
                while (!isRoll)
                {
                    if (owner.index >= owner.RollInfo.childCount)
                    {
                        owner.index = 0;
                    }
                    owner.RollInfo.GetChild(owner.index).FindChildDepth("light").gameObject.SetActive(true);
                    yield return new WaitForSeconds(0.05f);
                    owner.RollInfo.GetChild(owner.index).FindChildDepth("light").gameObject.SetActive(false);
                    owner.index++;
                }
                while (owner.index!= CMLHJEntry.Instance.GameData.MaryData.nStopIndex)
                {
                    if (owner.index >= owner.RollInfo.childCount)
                    {
                        owner.index = 0;
                    }
                    owner.RollInfo.GetChild(owner.index).FindChildDepth("light").gameObject.SetActive(true);
                    yield return new WaitForSeconds(0.05f);
                    owner.RollInfo.GetChild(owner.index).FindChildDepth("light").gameObject.SetActive(false);
                    owner.index++;
                }
                yield return new WaitForSeconds(0.05f);
                owner.RollInfo.GetChild(CMLHJEntry.Instance.GameData.MaryData.nStopIndex).FindChildDepth("light").gameObject.SetActive(true);

                yield return new WaitForSeconds(0.5f);

                owner.LastCont.text = ToolHelper.ShowRichText(CMLHJEntry.Instance.GameData.MaryData.nMaryCount);
                for (int i = 0; i < CMLHJEntry.Instance.GameData.MaryData.nByPrizeImg.Count; i++)
                {
                    if (CMLHJEntry.Instance.GameData.MaryData.nByPrizeImg[i] == owner.C_MARY_IMG[CMLHJEntry.Instance.GameData.MaryData.nStopIndex])
                    {
                        if (i == 0)
                        {
                            CMLHJ_Audio.Instance.PlaySound(CMLHJ_Audio.MarryHit);
                        }
                        owner.rollList[i].content.GetChild(0).FindChildDepth("MidLight").gameObject.SetActive(true);
                    }
                }
                Transform obj;
                int allgold = 0;
                for (int i = 0; i < CMLHJEntry.Instance.GameData.MaryData.nByPrizeImg.Count; i++)
                {
                    if (CMLHJEntry.Instance.GameData.MaryData.nByPrizeImg[i] == owner.C_MARY_IMG[CMLHJEntry.Instance.GameData.MaryData.nStopIndex])
                    {
                        obj = owner.rollList[i].content.GetChild(0);
                        int data = owner.friutbl[CMLHJEntry.Instance.GameData.MaryData.nByPrizeImg[i]];
                        obj.FindChildDepth<TextMeshProUGUI>("Num/Text").text = data.ShowRichText();
                        obj.FindChildDepth("Num").gameObject.SetActive(true);

                        while (data > 0)
                        {
                            data--;
                            obj = owner.rollList[0].content.GetChild(0);
                            obj.FindChildDepth<TextMeshProUGUI>("Num/Text").text = data.ShortNumber().ShowRichText();
                            allgold += CMLHJEntry.Instance.GameData.CurrentChip * CMLHJ_DataConfig.ALLLINECOUNT;
                            CMLHJEntry.Instance.WinInfoNum.text = allgold.ShortNumber().ShowRichText();
                            yield return new WaitForSeconds(0.2f);
                        }
                    }
                }

                CMLHJEntry.Instance.WinInfoNum.text = CMLHJEntry.Instance.GameData.MaryData.nWinGold.ShortNumber().ShowRichText();
                yield return new WaitForSeconds(0.5f);
                if (CMLHJEntry.Instance.GameData.MaryData.nMaryCount <= 0)
                {
                    CMLHJEntry.Instance.GameData.CurrentMaryCount = 0;
                    CMLHJ_Event.DispatchShowResultComplete();
                    CMLHJEntry.Instance.GameData.isMaryGame = false;
                    CMLHJEntry.Instance.CMLHJ_ShowResultNum(true);
                    CMLHJEntry.Instance.SmallGamePanel.gameObject.SetActive(false);
                    hsm?.ChangeState(nameof(BonusInitState));
                }
                else
                {
                    CMLHJ_Network.Instance.StartMaryGame();
                }

            }
            public override void Update()
            {
                base.Update();
                if (isStop) return;
                CalculateStop();
            }

            private void CalculateStop()
            {
                if (stopIndex < owner.rollList.Count)
                {
                    //计算转动间隔
                    stopTimer += Time.deltaTime;
                    if (stopTimer >= 0.2f)
                    {
                        stopTimer = 0;
                        //TODO 换正式结果图片
                        stopIndex++;
                        int stopindex = stopIndex - 1;
                        owner.rollList[stopindex].verticalNormalizedPosition = 1;
                        owner.ChangeResultIcon(stopindex);
                        if (stopindex == 2)
                        {
                            isRoll = true;
                            isStop = true;
                        }
                    }
                }
            }
        }
    }
}