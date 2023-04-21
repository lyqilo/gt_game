using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using Spine;
using Spine.Unity;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.TiaoTiaoTangGuo
{
    public class TTTG_Result : ILHotfixEntity
    {
        private TTTG_Struct.CMD_3D_SC_Result resultData;

        private List<IState> states;
        private HierarchicalStateMachine hsm;

        private int totalFreeWin;

        protected override void Start()
        {
            base.Start();
            states = new List<IState>();
            hsm = new HierarchicalStateMachine(false, gameObject);
            states.Add(new IdleState(this, hsm));
            states.Add(new CheckState(this, hsm));
            states.Add(new WinState(this, hsm));
            states.Add(new EnterFreeState(this, hsm));
            states.Add(new FinishFreeState(this, hsm));
            states.Add(new NoWinState(this, hsm));
            hsm.Init(states, nameof(IdleState));
        }

        protected override void Update()
        {
            base.Update();
            hsm?.Update();
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            hsm?.CurrentState.OnExit();
        }

        protected override void AddEvent()
        {
            base.AddEvent();
            TTTG_Event.ShowResult += TTTG_EventOnShowResult;
            TTTG_Event.OnReceiveResult += TTTG_EventOnOnReceiveResult;
            TTTG_Event.OnEnterFree += TTTG_EventOnOnEnterFree;
        }

        protected override void RemoveEvent()
        {
            base.RemoveEvent();
            TTTG_Event.ShowResult -= TTTG_EventOnShowResult;
            TTTG_Event.OnReceiveResult -= TTTG_EventOnOnReceiveResult;
            TTTG_Event.OnEnterFree -= TTTG_EventOnOnEnterFree;
        }

        private void TTTG_EventOnShowResult()
        {
            hsm?.ChangeState(nameof(CheckState));
        }

        private void TTTG_EventOnOnReceiveResult(TTTG_Struct.CMD_3D_SC_Result obj)
        {
            resultData = obj;
        }

        private void TTTG_EventOnOnEnterFree()
        {
            hsm?.ChangeState(nameof(EnterFreeState));
        }

        #region 状态机

        private class IdleState : State<TTTG_Result>
        {
            public IdleState(TTTG_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            private bool isInit;
            private Transform normalResult;
            private Transform freeResult;
            private SkeletonGraphic normalCombo;
            private TextMeshProUGUI normalNum;

            public override void OnEnter()
            {
                base.OnEnter();
                Init();
                owner.transform.localScale = Vector3.zero;
                freeResult.gameObject.SetActive(false);
                normalResult.gameObject.SetActive(false);
                normalNum.text = "";
                TTTG_Event.ShowCombo += ShowCombo;
            }

            public override void OnExit()
            {
                base.OnExit();
                TTTG_Event.ShowCombo -= ShowCombo;
            }

            private void Init()
            {
                if (isInit) return;
                normalResult = owner.transform.FindChildDepth($"Win");
                freeResult = owner.transform.FindChildDepth($"FreeGame");
                normalCombo = normalResult.FindChildDepth<SkeletonGraphic>($"Combo");
                normalNum = normalResult.FindChildDepth<TextMeshProUGUI>($"Text");
                isInit = true;
            }

            private void ShowCombo(int combo)
            {
                owner.transform.localScale = Vector3.one;
                normalResult.gameObject.SetActive(true);
                normalCombo.gameObject.SetActive(true);
                normalCombo.AnimationState.ClearTracks();
                normalCombo.AnimationState.SetAnimation(0, $"combo_{combo}", false);
                TTTG_Audio.Instance.PlaySound($"Candybreak_combo{combo}");
            }
        }

        private class CheckState : State<TTTG_Result>
        {
            public CheckState(TTTG_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            private bool isComplete;

            public override void OnEnter()
            {
                base.OnEnter();
                isComplete = false;
            }

            public override void Update()
            {
                base.Update();
                if (isComplete) return;
                isComplete = true;
                if (TTTGEntry.Instance.GameData.isFreeGame)
                {
                    if (TTTGEntry.Instance.GameData.CurrentFreeCount <= 0)
                    {
                        hsm?.ChangeState(nameof(FinishFreeState));
                        return;
                    }
                }
                if (owner.resultData == null)
                {
                    hsm?.ChangeState(nameof(IdleState));
                    return;
                }

                if (owner.resultData.nWinGold <= 0) //没中奖
                {
                    hsm?.ChangeState(nameof(NoWinState));
                }
                else
                {
                    hsm?.ChangeState(nameof(WinState));
                }
            }
        }

        private class NoWinState : State<TTTG_Result>
        {
            public NoWinState(TTTG_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            private float timer = 0;

            public override void OnEnter()
            {
                base.OnEnter();
                timer = 0;
            }

            public override void Update()
            {
                base.Update();
                timer += Time.deltaTime;
                if (timer < 0.5f) return;
                owner.resultData = null;
                hsm?.ChangeState(nameof(CheckState));
                TTTG_Event.DispatchOnUserScoreChanged(GameLocalMode.Instance.UserGameInfo);
                timer = 0;
            }
        }

        private class WinState : State<TTTG_Result>
        {
            public WinState(TTTG_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            private bool isInit;
            private Transform freeResult;
            private Transform normalResult;
            private SkeletonGraphic normalCombo;
            private TextMeshProUGUI normalNum;

            public override void OnEnter()
            {
                base.OnEnter();
                Init();
                normalResult.gameObject.SetActive(true);
                freeResult.gameObject.SetActive(false);
                normalCombo.gameObject.SetActive(false);
                normalNum.text = ToolHelper.ShowRichText($"$0");
                owner.transform.localScale = Vector3.one;
                if (TTTGEntry.Instance.GameData.isFreeGame)
                {
                    owner.totalFreeWin += owner.resultData.nWinGold;
                }

                ShowNormalResult();
            }

            private void Init()
            {
                if (isInit) return;
                isInit = true;
                normalResult = owner.transform.FindChildDepth($"Win");
                freeResult = owner.transform.FindChildDepth($"FreeGame");
                normalCombo = normalResult.FindChildDepth<SkeletonGraphic>($"Combo");
                normalNum = normalResult.FindChildDepth<TextMeshProUGUI>($"Text");
            }

            private void ShowNormalResult()
            {
                ToolHelper.RunGoal(0, owner.resultData.nWinGold, 0.7f,
                        p => { normalNum.text = ToolHelper.ShowRichText($"${p}"); })
                    .OnComplete(() =>
                    {
                        normalNum.text = ToolHelper.ShowRichText($"${owner.resultData.nWinGold}");
                        ToolHelper.DelayRun(1f, () =>
                        {
                            owner.resultData = null;
                            hsm?.ChangeState(nameof(CheckState));
                            TTTG_Event.DispatchOnUserScoreChanged(GameLocalMode.Instance.UserGameInfo);
                        });
                    });
                ShowGoldFly();
            }

            private void ShowGoldFly()
            {
                for (int i = 0; i < 6; i++)
                {
                    Transform eff = TTTGEntry.Instance.GetEffect(TTTG_DataConfig.goldEffect, owner.transform);
                    eff.localScale = Vector3.zero;
                    eff.gameObject.SetActive(true);
                    TTTG_Audio.Instance.PlaySound(TTTG_Audio.Candybreak_Click);
                    var position = normalNum.transform.position;
                    eff.position = new Vector3(Random.Range(position.x - 2, position.x + 2),
                        Random.Range(position.y - 1, position.y + 1), position.z);
                    eff.DOScale(new Vector3(0.4f, 0.4f), 0.01f).SetDelay((i + 1) * 0.2f).OnComplete(() =>
                    {
                        eff.DOMove(TTTGEntry.Instance.flyGoldTrans.position, 0.6f).OnComplete(() =>
                        {
                            TTTG_Audio.Instance.PlaySound(TTTG_Audio.Candybreak_Click);
                            ToolHelper.DelayRun(0.3f,
                                () => { TTTGEntry.Instance.CollectEffect(eff.gameObject); });
                        });
                    });
                }
            }
        }

        private class EnterFreeState : State<TTTG_Result>
        {
            public EnterFreeState(TTTG_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            private bool isInit;
            private Transform freeResult;
            private Transform normalResult;
            private Transform freeEnterNode;
            private Transform freeFinishNode;
            private Button freeEnterSureBtn;
            private TextMeshProUGUI freeEnterNum;

            public override void OnEnter()
            {
                base.OnEnter();
                Init();
                owner.totalFreeWin = 0;
                normalResult.gameObject.SetActive(false);
                freeResult.gameObject.SetActive(true);
                freeEnterNode.gameObject.SetActive(true);
                freeFinishNode.gameObject.SetActive(false);
                freeEnterNum.text = ToolHelper.ShowRichText(TTTGEntry.Instance.GameData.CurrentFreeCount);
                owner.transform.localScale = Vector3.one;
            }

            private void Init()
            {
                if (isInit) return;
                isInit = true;
                normalResult = owner.transform.FindChildDepth($"Win");
                freeResult = owner.transform.FindChildDepth($"FreeGame");
                freeFinishNode = freeResult.FindChildDepth($"FreeGameFinish");
                freeEnterNode = freeResult.FindChildDepth($"FreeGameEnter");
                freeEnterNum = freeEnterNode.FindChildDepth<TextMeshProUGUI>($"Num");
                freeEnterSureBtn = freeEnterNode.FindChildDepth<Button>($"Btn");
                freeEnterSureBtn.onClick.RemoveAllListeners();
                freeEnterSureBtn.onClick.Add(OnClickSureCall);
            }

            private void OnClickSureCall()
            {
                TTTGEntry.Instance.GameData.isFreeGame = true;
                freeEnterNode.gameObject.SetActive(false);
                TTTG_Audio.Instance.PlayBGM(TTTG_Audio.FreeBGM);
                TTTG_Event.DispatchShowFree(true);
            }
        }

        private class FinishFreeState : State<TTTG_Result>
        {
            public FinishFreeState(TTTG_Result owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            private bool isInit;
            private Transform freeResult;
            private Transform normalResult;
            private Transform freeEnterNode;
            private Transform freeFinishNode;
            private TextMeshProUGUI freeFinishScore;
            private Button freeFinishSureBtn;

            public override void OnEnter()
            {
                base.OnEnter();
                Init();
                normalResult.gameObject.SetActive(false);
                freeResult.gameObject.SetActive(true);
                freeEnterNode.gameObject.SetActive(false);
                freeFinishNode.gameObject.SetActive(true);
                freeFinishScore.text = owner.totalFreeWin.ToString();
                owner.transform.localScale = Vector3.one;
            }

            private void Init()
            {
                if (isInit) return;
                isInit = true;
                normalResult = owner.transform.FindChildDepth($"Win");
                freeResult = owner.transform.FindChildDepth($"FreeGame");
                freeFinishNode = freeResult.FindChildDepth($"FreeGameFinish");
                freeEnterNode = freeResult.FindChildDepth($"FreeGameEnter");
                freeFinishScore = freeFinishNode.FindChildDepth<TextMeshProUGUI>($"TotalWin");
                freeFinishSureBtn = freeFinishNode.FindChildDepth<Button>($"Btn");
                freeFinishSureBtn.onClick.RemoveAllListeners();
                freeFinishSureBtn.onClick.Add(OnClickSureCall);
            }

            private void OnClickSureCall()
            {
                owner.resultData = null;
                TTTGEntry.Instance.GameData.isFreeGame = false;
                owner.transform.localScale = Vector3.zero;
                hsm?.ChangeState(nameof(CheckState));
                TTTG_Event.DispatchMoveScreen(false);
            }
        }

        #endregion
    }
}