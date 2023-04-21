using System;
using UnityEngine;
using UnityEngine.UI;
using LuaFramework;
using System.Collections.Generic;
using TMPro;
using System.Collections;
using DG.Tweening;

namespace Hotfix.SG777
{
    public class SG777_SmallGame : ILHotfixEntity
    {
        private HierarchicalStateMachine hsm;
        private List<IState> states;
        private Transform Content;
        private Transform bellgamecont;
        private Transform ItemCont;
        private Text WinNum;
        private Text LastCont;
        private long allWinSMGold;
        private int SmallCount;
        private Transform winobj;
        private TextMeshProUGUI winNum;

        private List<int> NoOpenList;

        bool isEnterBonus;
        float timer;
        bool isStar;
        float timer2;

        protected override void Awake()
        {
            base.Awake();
            NoOpenList = new List<int>();
        }

        protected override void Start()
        {
            base.Start();
            hsm = new HierarchicalStateMachine(false, gameObject);
            states = new List<IState>();
            states.Add(new BonusInitState(this, hsm));
            states.Add(new EnterBonusState(this, hsm));
            states.Add(new BonusState(this, hsm));
            states.Add(new SmallOverState(this, hsm));
            hsm.Init(states, nameof(BonusInitState));
            AddListener();
            SmallCount = 0;
            allWinSMGold = 0;
        }

        protected override void OnEnable()
        {
            base.OnEnable();
        }

        protected override void OnDisable()
        {
            base.OnDisable();
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
            if (isEnterBonus)
            {
                timer += Time.deltaTime;
                if (timer >= SG777_DataConfig.ALLSmallWaitTime)
                {
                    isEnterBonus = false;
                    timer = 0;
                    isStar = true;
                }
            }

            if (isStar)
            {
                timer2 += Time.deltaTime;
                if (timer2 >= SG777_DataConfig.AutoSmallWaitTime)
                {
                    timer2 = 0f;
                    AutoSendSmallGame();
                }
            }
        }

        private void AutoSendSmallGame()
        {
            int index = UnityEngine.Random.Range(0, NoOpenList.Count);
            SG777_Network.Instance.StartSmallGame(index);
            NoOpenList.Remove(index);
            if (NoOpenList.Count <= 10)
            {
                isStar = false;
            }
        }


        protected override void FindComponent()
        {
            Content = this.transform.FindChildDepth("Content");
            bellgamecont = Content.FindChildDepth("bellgamecont");
            ItemCont = Content.FindChildDepth("bellgamecont/itemcont");
            WinNum = Content.FindChildDepth<Text>("bellgamecont/WinNum/cont");
            LastCont = Content.FindChildDepth<Text>("bellgamecont/LastCont/cont");

            winobj = Content.FindChildDepth("winInfo");
            winNum = Content.FindChildDepth<TextMeshProUGUI>("winInfo/Text");
        }

        private void AddListener()
        {
            for (int i = 0; i < ItemCont.childCount; i++)
            {
                int index = i;
                ItemCont.GetChild(i).FindChildDepth<Button>("button").onClick.RemoveAllListeners();
                ItemCont.GetChild(i).FindChildDepth<Button>("button").onClick.Add(() =>
                {
                    SG777_Network.Instance.StartSmallGame(index);
                    NoOpenList.Remove(index);
                });
            }
        }

        protected override void AddEvent()
        {
            SG777_Event.EnterSmallGame += SmallGameShow;
            SG777_Event.StartSmallGame += SmallGameRoll;
        }

        protected override void RemoveEvent()
        {
            SG777_Event.EnterSmallGame -= SmallGameShow;
            SG777_Event.StartSmallGame -= SmallGameRoll;
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

        public class BonusInitState : State<SG777_SmallGame>
        {
            public BonusInitState(SG777_SmallGame owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                owner.Content.gameObject.SetActive(false);
                for (int i = 0; i < owner.ItemCont.childCount; i++)
                {
                    owner.ItemCont.GetChild(i).FindChildDepth<Button>("button").interactable = true;
                    owner.ItemCont.GetChild(i).FindChildDepth("goldanima").gameObject.SetActive(false);
                    owner.ItemCont.GetChild(i).FindChildDepth("moneycont").gameObject.SetActive(false);
                    owner.ItemCont.GetChild(i).FindChildDepth("Image").gameObject.SetActive(false);
                    owner.ItemCont.GetChild(i).FindChildDepth<TextMeshProUGUI>("moneycont").text = "";
                }
            }
        }

        public class EnterBonusState : State<SG777_SmallGame>
        {
            public EnterBonusState(SG777_SmallGame owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                DebugHelper.Log("--------EnterBonusState-------");
                SG777_Audio.Instance.PlaySound(SG777_Audio.BELL_ON);
                owner.NoOpenList.Clear();
                for (int i = 0; i < 15; i++)
                {
                    owner.NoOpenList.Add(i);
                }

                owner.isEnterBonus = true;
                owner.timer = 0f;
                owner.isStar = false;
                owner.timer2 = 0f;


                if (SG777Entry.Instance.GameData.SmallGameData != null &&
                    SG777Entry.Instance.GameData.SmallGameData.nSmallGameCount > 0)
                {
                    owner.SmallCount = SG777Entry.Instance.GameData.SmallGameData.nSmallGameCount;
                    owner.allWinSMGold = 0;
                }
                else
                {
                    if (SG777Entry.Instance.GameData.ResultData != null)
                    {
                        owner.SmallCount = SG777Entry.Instance.GameData.ResultData.nSmallGameCount;
                        owner.allWinSMGold = 0;
                    }
                    else
                    {
                        owner.SmallCount = SG777Entry.Instance.GameData.SceneData.nSmallGameCount;
                        owner.allWinSMGold = SG777Entry.Instance.GameData.SceneData.nSmallGameTatolGold;
                        for (int i = 0; i < SG777Entry.Instance.GameData.SceneData.nSmallGameData.Count; i++)
                        {
                            var item = SG777Entry.Instance.GameData.SceneData.nSmallGameData;
                            if (item[i].isOpen >= 1)
                            {
                                owner.ItemCont.GetChild(item[i].isOpen - 1).FindChildDepth<Button>("button")
                                    .interactable = false;
                                owner.ItemCont.GetChild(item[i].isOpen - 1).FindChildDepth("moneycont").gameObject
                                    .SetActive(true);
                                owner.ItemCont.GetChild(item[i].isOpen - 1).FindChildDepth<TextMeshProUGUI>("moneycont")
                                    .text = item[i].nBellGold.ShortNumber().ShowRichText();
                                owner.NoOpenList.Remove(item[i].isOpen - 1);
                            }
                        }
                    }
                }

                owner.LastCont.text = owner.SmallCount.ToString();
                owner.WinNum.text = owner.allWinSMGold.ShortNumber();

                owner.winobj.gameObject.SetActive(false);
                owner.bellgamecont.gameObject.SetActive(true);
                owner.Content.gameObject.SetActive(true);
            }
        }

        public class BonusState : State<SG777_SmallGame>
        {
            float timer;
            bool isEnter;

            public BonusState(SG777_SmallGame owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                timer = 0f;
                isEnter = false;
                Transform item = owner.ItemCont.GetChild(SG777Entry.Instance.GameData.SmallGameData.nStopIndex - 1);
                item.FindChildDepth<Button>("button").interactable = false;
                item.FindChildDepth("button").gameObject.SetActive(false);
                item.FindChildDepth("goldanima").gameObject.SetActive(true);
                SG777_Audio.Instance.PlaySound(SG777_Audio.BELL);

                ToolHelper.DelayRun(1.5f, () =>
                {
                    item.FindChildDepth("goldanima").gameObject.SetActive(false);
                    item.FindChildDepth("button").gameObject.SetActive(true);
                    item.FindChildDepth("moneycont").gameObject.SetActive(true);
                    item.FindChildDepth("Image").gameObject.SetActive(true);
                    TextMeshProUGUI itemText = item.FindChildDepth<TextMeshProUGUI>("moneycont");
                    ToolHelper.RunGoal(0, SG777Entry.Instance.GameData.SmallGameData.nWinGold, 1.5f,
                        delegate(string goal)
                        {
                            long.TryParse(goal, out var num);
                            itemText.text = num.ShortNumber().ShowRichText();
                        }).OnComplete(delegate()
                    {
                        item.FindChildDepth("Image").gameObject.SetActive(false);
                        owner.allWinSMGold += SG777Entry.Instance.GameData.SmallGameData.nWinGold;
                        owner.LastCont.text = $"{SG777Entry.Instance.GameData.SmallGameData.nSmallGameCount}";
                        owner.WinNum.text = owner.allWinSMGold.ShortNumber();
                        if (SG777Entry.Instance.GameData.SmallGameData.nSmallGameCount <= 0)
                        {
                            isEnter = true;
                        }
                    });
                });
            }

            public override void Update()
            {
                base.Update();
                if (isEnter)
                {
                    timer += Time.deltaTime;
                    if (timer > 1.5f)
                    {
                        isEnter = false;
                        hsm?.ChangeState(nameof(SmallOverState));
                    }
                }
            }
        }

        private class SmallOverState : State<SG777_SmallGame>
        {
            bool isStart;
            float timer;

            public SmallOverState(SG777_SmallGame owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                isStart = false;
                timer = 0f;
                SG777Entry.Instance.GameData.isSmallGame = false;
                owner.winobj.gameObject.SetActive(true);
                owner.bellgamecont.gameObject.SetActive(false);
                ToolHelper.RunGoal(0, owner.allWinSMGold, SG777_DataConfig.winBigGoldChangeRate,
                        delegate(string goal)
                        {
                            long.TryParse(goal, out var num);
                            owner.winNum.text = num.ShortNumber().ShowRichText();
                        })
                    .OnComplete(delegate() { isStart = true; });
            }

            public override void Update()
            {
                base.Update();
                if (isStart)
                {
                    timer += Time.deltaTime;
                    if (timer > 1.5f)
                    {
                        isStart = false;
                        owner.isEnterBonus = false;
                        owner.timer = 0f;
                        owner.isStar = false;
                        owner.timer2 = 0f;
                        SG777Entry.Instance.GameData.isSmallGame = false;
                        if (SG777Entry.Instance.GameData.ResultData != null)
                        {
                            SG777Entry.Instance.GameData.ResultData.nSmallGameCount = 0;
                        }

                        SG777_Event.DispatchShowResultComplete();
                        if (SG777Entry.Instance.GameData.isFreeGame)
                        {
                            SG777_Audio.Instance.PlayBGM(SG777_Audio.FreeBGM);
                        }
                        else
                        {
                            SG777_Audio.Instance.PlayBGM();
                        }

                        hsm?.ChangeState(nameof(BonusInitState));
                    }
                }
            }
        }
    }
}