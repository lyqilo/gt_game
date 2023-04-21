

using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


namespace Hotfix.JTJW
{
    public class JW_Roll : ILHotfixEntity
    {
        HierarchicalStateMachine hsm;
        List<IState> states;
        private Transform icons;
        List<ScrollRect> rollList;
        List<int> list;
        private int rollIndex;

        bool iscbRerun;

        private int AllWinGold;

        protected override void Awake()
        {
            base.Awake();
            Init();
        }

        protected override void AddEvent()
        {
            base.AddEvent();
            JW_Event.StartRoll += JW_Event_StartRoll;
            JW_Event.ChangeImage += JW_Event_ChangeState;
            JW_Event.StopRoll += JW_Event_StopRoll;
            JW_Event.StartReRoll += JW_Event_StartReRoll;
        }

        private void Init()
        {
            icons = JWEntry.Instance.MainContent.FindChildDepth("Content/Icons"); //图标库
            rollList = new List<ScrollRect>();
            for (int i = 0; i < transform.childCount; i++)
            {
                ScrollRect rect = transform.GetChild(i).GetComponent<ScrollRect>();
                rect.verticalNormalizedPosition = 0;
                rect.elasticity = JW_DataConfig.rollReboundRate;
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
            states.Add(new ChangeImageState(this, hsm));
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
            JW_Event.StartRoll -= JW_Event_StartRoll;
            JW_Event.ChangeImage -= JW_Event_ChangeState;
            JW_Event.StopRoll -= JW_Event_StopRoll;
            JW_Event.StartReRoll -= JW_Event_StartReRoll;
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            hsm?.CurrentState.OnExit();

        }

        private void JW_Event_StartRoll()
        {
            hsm?.ChangeState(nameof(RollState));
        }

        private void JW_Event_StartReRoll()
        {
          //  hsm?.ChangeState(nameof(RollReState));
        }

        private void JW_Event_ChangeState()
        {
            hsm?.ChangeState(nameof(ChangeImageState));
        }

        private void JW_Event_StopRoll(bool force)
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
            for (int i = 0; i < iconParent.childCount; i++)
            {
                int iconIndex = Random.Range(0, 9);
                string iconName = isMH ? $"MH_{JW_DataConfig.IconTable[iconIndex]}" : JW_DataConfig.IconTable[iconIndex];
                Sprite changeIcon = icons.FindChildDepth<Image>(iconName).sprite;
                iconParent.GetChild(i).Find("Icon").GetComponent<Image>().sprite = changeIcon;
                iconParent.GetChild(i).Find("Icon").GetComponent<Image>().SetNativeSize();
            }
        }
        private void ChangeResultIcon(int rollIndex)
        {
            if (rollIndex >= rollList.Count) return;
            Transform iconParent = rollList[rollIndex].content;
            for (int i = 0; i < iconParent.childCount; i++)
            {
                Image img = iconParent.GetChild(i).FindChildDepth<Image>("Icon");
                int iconIndex;
                iconIndex = JWEntry.Instance.GameData.ResultData.cbIcon[i * 5 + rollIndex];
                Sprite changeIcon = icons.FindChildDepth<Image>(JW_DataConfig.IconTable[iconIndex]).sprite;
                img.sprite = changeIcon;
                if (i != iconParent.childCount)
                {
                    iconParent.GetChild(i).gameObject.name = JW_DataConfig.IconTable[iconIndex];
                }
                img.SetNativeSize();
            }
        }

        private Image ReRoll(int num)
        {
            int column = Mathf.FloorToInt(num / 5);
            int raw = Mathf.FloorToInt(num % 5);
            Transform tran = transform.GetChild(raw).transform.GetComponent<ScrollRect>().content.GetChild(column).GetChild(0);
            Image image = tran.GetComponent<Image>();
            image.enabled = true;
            return image;
        }

        /// <summary>
        /// 闲置状态
        /// </summary>
        private class IdleState : State<JW_Roll>
        {
            public IdleState(JW_Roll owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
        }
        /// <summary>
        /// 转动状态
        /// </summary>
        private class RollState : State<JW_Roll>
        {

            int ranNum;
            int iconIndex;
            private List<byte> ListIcon = new List<byte>();

            public RollState(JW_Roll owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            public override void OnEnter()
            {
                base.OnEnter();
                iconIndex = 0;
                ranNum = Random.Range(0, 14);
                owner.Behaviour.StartCoroutine(ImageHide());
            }

            private IEnumerator ImageHide()
            {
                for (int i = 0; i < JW_DataConfig.LineIndexList[ranNum].Count; i++)
                {
                    for (int j = 0; j < JW_DataConfig.LineIndexList[ranNum][i]; j++)
                    {
                        if (!owner.iscbRerun)
                        {
                            owner.ReRoll(JW_DataConfig.LineIconList[ranNum][iconIndex] - 1).DOFade(0, JW_DataConfig.rollImageShowHideTime);
                            owner.ReRoll(JW_DataConfig.LineIconList[ranNum][iconIndex] - 1).transform.DOScale(0.8f, JW_DataConfig.rollImageShowHideTime);
                            iconIndex++;
                        }
                    }
                    if (!owner.iscbRerun)
                        yield return new WaitForSeconds(JW_DataConfig.nextImageShowTime);
                }
                yield return new WaitForEndOfFrame();
                JW_Event.DispatchChangeImage();
            }
            public override void Update()
            {
                base.Update();
            }
            public override void OnExit()
            {
                base.OnExit();
                owner.Behaviour.StopCoroutine(ImageHide());

            }
        }

        /// <summary>
        /// 改变图片
        /// </summary>
        private class ChangeImageState : State<JW_Roll>
        {
            public ChangeImageState(JW_Roll owner, HierarchicalStateMachine hsm): base(owner, hsm)
            {
            }
            bool isComplete;
            public override void OnEnter()
            {
                base.OnEnter();
                for (int i = 0; i < 5; i++)
                {
                    owner.ChangeResultIcon(i);
                }
                isComplete = false;
            }
            public override void Update()
            {
                base.Update();
                if (isComplete) return;
                isComplete = true;
                JW_Event.DispatchStopRoll(false);
            }
        }


        /// <summary>
        /// 停止状态
        /// </summary>
        private class StopState : State<JW_Roll>
        {
            int ranNum;
            int iconIndex;
            int iconIndex2;

            private List<byte> ListIcon = new List<byte>();

            public StopState(JW_Roll owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                iconIndex = 0;
                iconIndex2 = 0;
                if (owner.iscbRerun)
                    ranNum = 0;
                else
                    ranNum = Random.Range(0, 14);

                owner.Behaviour.StartCoroutine(ImageShow());
            }

            private IEnumerator ImageShow()
            {
                JW_Audio.Instance.PlaySound(JW_Audio.rollEnd);

                for (int i = 0; i < JW_DataConfig.LineIndexList[ranNum].Count; i++)
                {
                    for (int j = 0; j < JW_DataConfig.LineIndexList[ranNum][i]; j++)
                    {
                        if (owner.iscbRerun && ListIcon.Count > 0)
                        {
                            if (ListIcon[iconIndex2] > 0)
                            {
                                owner.ReRoll(iconIndex2).transform.localScale = new Vector3(0.8f, 0.8f, 0.8f);
                                owner.ReRoll(iconIndex2).color = Color.gray;
                            }
                            iconIndex2++;
                        }
                    }
                }

                yield return new WaitForEndOfFrame();

                for (int i = 0; i < JW_DataConfig.LineIndexList[ranNum].Count; i++)
                {
                    for (int j = 0; j < JW_DataConfig.LineIndexList[ranNum][i]; j++)
                    {
                        if (owner.iscbRerun && ListIcon.Count > 0)
                        {
                            if (ListIcon[iconIndex] > 0)
                            {
                                owner.ReRoll(iconIndex).DOFade(1, JW_DataConfig.rollImageShowHideTime);
                                owner.ReRoll(iconIndex).transform.DOScale(1f, JW_DataConfig.nextImageShowTime);
                                owner.ReRoll(iconIndex).color = Color.white;
                            }
                            iconIndex++;
                        }
                        else
                        {
                            owner.ReRoll(JW_DataConfig.LineIconList[ranNum][iconIndex] - 1).DOFade(1, JW_DataConfig.rollImageShowHideTime);
                            owner.ReRoll(JW_DataConfig.LineIconList[ranNum][iconIndex] - 1).transform.DOScale(1f, JW_DataConfig.nextImageShowTime);
                            iconIndex++;
                        }
                    }
                    yield return new WaitForSeconds(JW_DataConfig.nextImageShowTime);
                }

                if (JWEntry.Instance.GameData.ResultData.nFreeCount > 0 || JWEntry.Instance.GameData.TotalFreeWin > 0)
                    JWEntry.Instance.GameData.TotalFreeWin +=JWEntry.Instance.GameData.ResultData.nWinGold;
                else
                {
                    if (owner.iscbRerun || JWEntry.Instance.GameData.ResultData.cbRerun > 0)
                        owner.AllWinGold += JWEntry.Instance.GameData.ResultData.nWinGold;
                    else
                        owner.AllWinGold = 0;

                    JWEntry.Instance.GameData.ResultData.nWinGold = owner.AllWinGold;
                }

                if (JWEntry.Instance.GameData.ResultData.cbRerun > 0)
                    owner.iscbRerun = true;
                else
                {
                    owner.iscbRerun = false;
                    owner.AllWinGold = 0;
                }

                ListIcon.Clear();
                for (int i = 0; i < JWEntry.Instance.GameData.ResultData.cbHitIcon.Count; i++)
                {
                    ListIcon.Add(JWEntry.Instance.GameData.ResultData.cbHitIcon[i]);
                }

                for (int i = 0; i < 5; i++)
                {
                    if (JWEntry.Instance.GameData.ResultData.cbHitIcon[i] > 0)
                    {
                        if (JWEntry.Instance.GameData.ResultData.cbHitIcon[i + 5] > 0)
                        {
                            if (JWEntry.Instance.GameData.ResultData.cbHitIcon[i + 10] > 0)
                            {
                                ListIcon[i] = 1;
                                ListIcon[i + 5] = 1;
                                ListIcon[i + 10] = 1;
                            }
                            else
                            {
                                ListIcon[i] = 1;
                                ListIcon[i + 5] = 1;
                                ListIcon[i + 10] = 0;
                            }
                        }
                        else
                        {
                            if (JWEntry.Instance.GameData.ResultData.cbHitIcon[i + 10] > 0)
                            {
                                ListIcon[i] = 1;
                                ListIcon[i + 5] = 1;
                                ListIcon[i + 10] = 0;
                            }
                            else
                            {
                                ListIcon[i] = 1;
                                ListIcon[i + 5] = 0;
                                ListIcon[i + 10] = 0;
                            }
                        }
                    }
                    else
                    {
                        if (JWEntry.Instance.GameData.ResultData.cbHitIcon[i + 5] > 0)
                        {
                            if (JWEntry.Instance.GameData.ResultData.cbHitIcon[i + 10] > 0)
                            {
                                ListIcon[i] = 1;
                                ListIcon[i + 5] = 1;
                                ListIcon[i + 10] = 0;
                            }
                            else
                            {
                                ListIcon[i] = 1;
                                ListIcon[i + 5] = 0;
                                ListIcon[i + 10] = 0;
                            }
                        }
                        else
                        {
                            if (JWEntry.Instance.GameData.ResultData.cbHitIcon[i + 10] > 0)
                            {
                                ListIcon[i] = 1;
                                ListIcon[i + 5] = 0;
                                ListIcon[i + 10] = 0;
                            }
                            else
                            {
                                ListIcon[i] = 0;
                                ListIcon[i + 5] = 0;
                                ListIcon[i + 10] = 0;
                            }
                        }
                    }
                }
                yield return new WaitForEndOfFrame();

                int _num = 0;
                for (int i = 0; i < JWEntry.Instance.GameData.ResultData.cbIcon.Count; i++)
                {
                    if (JWEntry.Instance.GameData.ResultData.cbIcon[i]==8)
                    {
                        _num++;
                    }
                }

                if (JWEntry.Instance.GameData.ResultData.nWinGold > 0 || _num>=3)
                    JW_Event.DispatchShowLine();
                else
                    JW_Event.DispatchRollComplete();
            }
            public override void Update()
            {
                base.Update();
            }
            public override void OnExit()
            {
                base.OnExit();
                owner.Behaviour.StopCoroutine(ImageShow());

            }
        }
    }
}
