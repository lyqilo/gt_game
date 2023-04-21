using System;
using UnityEngine;
using UnityEngine.UI;
using LuaFramework;
using System.Collections.Generic;
using TMPro;
using System.Collections;
using DG.Tweening;

namespace Hotfix.FQGY
{
    public class FQGY_MiniGame : ILHotfixEntity
    {
        private HierarchicalStateMachine hsm;
        private List<IState> states;

        public Transform EnterBonus;
        private TextMeshProUGUI EnterBonusNum;
        private Button BeginBonusBtn;

        private Transform mainBonus;
        private TextMeshProUGUI winNum;
        private Transform Amount_item;
        private Transform Slots;
        private Transform Mark;
        private Button BeginBtn;
        private Transform Pull;
        private TextMeshProUGUI MiNiGameNum;

        private Transform BonusResult;
        private TextMeshProUGUI BonusResultNum;
        private Button BonusBackBtn;


        bool isInitSmallGame;

        List<Vector3> MovePos;

        int stopIndex;

        protected override void Awake()
        {
            base.Awake();
        }
        protected override void Start()
        {
            base.Start();
            isInitSmallGame = false;
            MovePos = new List<Vector3>();
            hsm = new HierarchicalStateMachine(false, gameObject);
            states = new List<IState>();
            states.Add(new BonusInitState(this, hsm));
            states.Add(new EnterBonusState(this, hsm));
            states.Add(new BonusState(this, hsm));
            states.Add(new BonusRollState(this, hsm));
            states.Add(new BonusResultState(this, hsm));
            
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
            EnterBonus = this.transform.FindChildDepth("EnterBonus");
            EnterBonusNum = EnterBonus.FindChildDepth<TextMeshProUGUI>("BonusGameEnter/Text");
            BeginBonusBtn = EnterBonus.FindChildDepth<Button>("BonusGameEnter/Btn");

            mainBonus =this.transform.FindChildDepth("Content");
            winNum = mainBonus.FindChildDepth<TextMeshProUGUI>("Center/WinBg/Num");
            Amount_item = mainBonus.FindChildDepth("Center/Amount_item");
            Slots = mainBonus.FindChildDepth("Slots");
            Mark = mainBonus.FindChildDepth("Mark");
            BeginBtn = mainBonus.FindChildDepth<Button>("Begin/Idle");
            Pull = mainBonus.FindChildDepth("Begin/Pull");
            MiNiGameNum = mainBonus.FindChildDepth<TextMeshProUGUI>("Begin/Num/Text");

            BonusResult = this.transform.FindChildDepth("BonusResult");
            BonusResultNum = BonusResult.FindChildDepth<TextMeshProUGUI>("BonusGameFinish/Text");
            BonusBackBtn = BonusResult.FindChildDepth<Button>("BonusGameFinish/Btn");
        }

        private void AddListener()
        {

        }

        protected override void AddEvent()
        {
            FQGY_Event.EnterSmallGame+=SmallGameShow;
            FQGY_Event.StartSmallGame += SmallGameRoll;
        }

        protected override void RemoveEvent()
        {
            FQGY_Event.EnterSmallGame -= SmallGameShow;
            FQGY_Event.StartSmallGame -= SmallGameRoll;

        }

        private void SmallGameShow()
        {
            hsm?.ChangeState(nameof(EnterBonusState));
        }

        private void SmallGameRoll()
        {
            hsm?.ChangeState(nameof(BonusRollState));
        }

        public class BonusInitState : State<FQGY_MiniGame>
        {
            public BonusInitState(FQGY_MiniGame owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {

            }
            public override void OnEnter()
            {

                owner.EnterBonus.gameObject.SetActive(false);
                owner.EnterBonusNum.text = ToolHelper.ShowRichText(0);

                owner.mainBonus.gameObject.SetActive(false);
                owner.winNum.text = ToolHelper.ShowRichText(0);
                owner.MiNiGameNum.text = ToolHelper.ShowRichText(0);
                owner.Mark.gameObject.SetActive(false);
                owner.Pull.gameObject.SetActive(false);

                owner.BonusResult.gameObject.SetActive(false);
                owner.BonusResultNum.text = ToolHelper.ShowRichText(0);

               // FQGY_Event.DispatchShowResultComplete();
            }
        }

        public class EnterBonusState : State<FQGY_MiniGame>
        {
            float timer;
            bool isEnter=false;
            public EnterBonusState(FQGY_MiniGame owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {

            }

            public override void OnEnter()
            {
                timer = 0;
                isEnter = true;

                owner.MovePos.Clear();

                for (int i = 0; i < owner.Slots.childCount - 1; i++)
                {
                    owner.MovePos.Add(owner.Slots.GetChild(i).position);
                }

                owner.EnterBonus.gameObject.SetActive(true);
                owner.EnterBonusNum.text = ToolHelper.ShowRichText(FQGYEntry.Instance.GameData.ResultData.nSmallGameCount);
                owner.BeginBonusBtn.onClick.RemoveAllListeners();
                owner.BeginBonusBtn.onClick.Add(()=> 
                {
                    hsm.ChangeState(nameof(BonusState));
                });
            }

            public override void Update()
            {
                base.Update();
                if (isEnter)
                {
                    timer += Time.deltaTime;
                    if (timer>FQGY_DataConfig.enterSmallWaitTime)
                    {
                        isEnter = false;
                        timer = 0;
                        hsm.ChangeState(nameof(BonusState));
                    }
                }
            }
        }

        public class BonusState : State<FQGY_MiniGame>
        {
            float timer;
            bool isEnter = false;
            public BonusState(FQGY_MiniGame owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {

            }
            public override void OnEnter()
            {
                owner.stopIndex = 0;
                owner.MiNiGameNum.text= ToolHelper.ShowRichText(FQGYEntry.Instance.GameData.ResultData.nSmallGameCount);
                owner.mainBonus.gameObject.SetActive(true);
                owner.EnterBonus.gameObject.SetActive(false);
                owner.BeginBtn.onClick.RemoveAllListeners();
                owner.BeginBtn.onClick.Add(() =>
                {
                    owner.BeginBtn.gameObject.SetActive(false);
                    owner.BeginBtn.interactable = false;
                    owner.Pull.gameObject.SetActive(true);
                    timer = 0;
                    isEnter = true;
                    FQGY_Network.Instance.StartSmallGame();
                });
            }

            public override void Update()
            {
                base.Update();
                if (isEnter)
                {
                    timer += Time.deltaTime;
                    if (timer > 0.15f)
                    {
                        owner.BeginBtn.gameObject.SetActive(true);
                        owner.Pull.gameObject.SetActive(false);
                    }
                }
            }
        }

        public class BonusRollState : State<FQGY_MiniGame>
        {
            float timer;
            bool isEnter = false;
            public BonusRollState(FQGY_MiniGame owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {

            }
            public override void OnEnter()
            {
                for (int i = 0; i < owner.Slots.childCount - 1; i++)
                {
                    owner.Slots.GetChild(i).GetChild(0).GetComponent<Image>().color = Color.gray;
                    owner.Slots.GetChild(i).GetChild(1).GetComponent<Image>().color = Color.gray;
                }

                owner.Behaviour.StartCoroutine(StartRoll());
            }

            IEnumerator StartRoll()
            {
                yield return new WaitForEndOfFrame();

                owner.Slots.GetChild(owner.stopIndex).GetChild(0).GetComponent<Image>().color = Color.white;
                owner.Slots.GetChild(owner.stopIndex).GetChild(1).GetComponent<Image>().color = Color.white;
                owner.Mark.gameObject.SetActive(true);

                bool isRoll = true;
                int index = owner.stopIndex;
                int count = 0;
                while (isRoll)
                {
                    owner.Mark.DOLocalMove(owner.MovePos[index], 0.1f);
                    index++;
                    if (index < owner.MovePos.Count)
                    {
                        index = 0;
                        count++;
                    }
                    if (count >= 2)
                    {
                        isRoll = false;
                    }
                    yield return new WaitForSeconds(0.2f);
                }

                int stopIndex= FQGYEntry.Instance.GameData.SmallGameData.nStopIndex;
                int iconIndex = UnityEngine.Random.Range(0, FQGY_DataConfig.SmallIconStopList[stopIndex].Count);
                int lackNum =Mathf.Abs(index - iconIndex);

                if (lackNum<=6)
                {
                    lackNum = lackNum + owner.MovePos.Count;
                }
                bool isAnainRoll = true;
                while (isAnainRoll)
                {
                    owner.Mark.DOLocalMove(owner.MovePos[index], 0.15f);
                    index++;
                    lackNum--;
                    if (lackNum<=0)
                    {
                        isAnainRoll = false;
                    }
                    yield return new WaitForSeconds(0.2f);
                }
                owner.stopIndex = index;
                owner.winNum.text = ToolHelper.ShowRichText(FQGYEntry.Instance.GameData.SmallGameData.nTatolGold);
                owner.MiNiGameNum.text = ToolHelper.ShowRichText(FQGYEntry.Instance.GameData.ResultData.nSmallGameCount);
                yield return new WaitForSeconds(1f);
                owner.BeginBtn.interactable = true;
                if (FQGYEntry.Instance.GameData.ResultData.nSmallGameCount <= 0)
                {
                    timer = 0;
                    isEnter = true;
                }
            }

            public override void Update()
            {
                base.Update();
                if (isEnter)
                {
                    timer += Time.deltaTime;
                    if (timer > 0.1f)
                    {
                        isEnter = false;
                        timer = 0;
                        hsm.ChangeState(nameof(BonusResultState));
                    }
                }
            }
        }



        public class BonusResultState : State<FQGY_MiniGame>
        {
            public BonusResultState(FQGY_MiniGame owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {

            }

            public override void OnEnter()
            {
                owner.BonusResultNum.text = ToolHelper.ShowRichText(FQGYEntry.Instance.GameData.SmallGameData.nTatolGold);
                owner.BonusResult.gameObject.SetActive(true);
                owner.mainBonus.gameObject.SetActive(false);
                owner.BonusBackBtn.onClick.RemoveAllListeners();
                owner.BonusBackBtn.onClick.Add(() =>
                {
                    hsm.ChangeState(nameof(BonusInitState));
                });
            }
        }

    }


}