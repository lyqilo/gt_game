
using DragonBones;
using System.Collections.Generic;
using System.Collections;
using UnityEngine;
using UnityEngine.UI;
using Transform = UnityEngine.Transform;

namespace Hotfix.CMLHJ
{
    public class CMLHJ_Line : ILHotfixEntity
    {
        private class LineData
        {
            public int Index;
        }
        private HierarchicalStateMachine hsm;
        private List<IState> states;
        private Transform animContent;
        private Transform RollContent;
        private List<List<Transform>> lines;
        private List<List<Transform>> anims;
        private List<LineData> lineDatas;

        protected override void Awake()
        {
            base.Awake();
        }
        protected override void Start()
        {
            base.Start();

            lines = new List<List<Transform>>();
            anims = new List<List<Transform>>();
            lineDatas = new List<LineData>();
            hsm = new HierarchicalStateMachine(false, gameObject);
            states = new List<IState>();
            states.Add(new IdleState(this, hsm));
            states.Add(new ReceiveResultState(this, hsm));
            states.Add(new ShowSingleState(this, hsm));
            states.Add(new CloseEffectState(this, hsm));
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
            RemoveEvent();
        }
        protected override void AddEvent()
        {
            CMLHJ_Event.ShowResult += CMLHJ_Event_ShowResult;
            CMLHJ_Event.StartRoll += CMLHJ_Event_StartRoll;
            HotfixActionHelper.ReconnectGame += EventHelper_ReconnectGame;
        }

        protected override void RemoveEvent()
        {
            CMLHJ_Event.ShowResult -= CMLHJ_Event_ShowResult;
            CMLHJ_Event.StartRoll -= CMLHJ_Event_StartRoll;
            HotfixActionHelper.ReconnectGame -= EventHelper_ReconnectGame;
        }

        private void EventHelper_ReconnectGame()
        {
            hsm?.ChangeState(nameof(CloseEffectState));
        }
        private void CMLHJ_Event_ShowResult()
        {
            hsm?.ChangeState(nameof(ReceiveResultState));
        }

        private void CMLHJ_Event_StartRoll()
        {
            hsm?.ChangeState(nameof(CloseEffectState));
        }

        protected override void FindComponent()
        {
            RollContent = CMLHJEntry.Instance.RollContent; //转动区域
            animContent = CMLHJEntry.Instance.Icons; //显示库
        }
        /// <summary>
        /// 创建动画
        /// </summary>
        /// <param name="effectName">动画名</param>
        /// <returns></returns>
        private GameObject CreatHitEffect(string effectName)
        {
            //创建动画，先从对象池中获取
            Transform go = CMLHJEntry.Instance.effectPool.Find(effectName);
            if (go != null) return go.gameObject;

            go = CMLHJEntry.Instance.Icons.Find(effectName);
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
            effect.transform.SetParent(CMLHJEntry.Instance.effectPool);
            effect.SetActive(false);
        }

        private class IdleState : State<CMLHJ_Line>
        {
            public IdleState(CMLHJ_Line owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
        }

        private class ReceiveResultState : State<CMLHJ_Line>
        {
            float timer = 0f;
            public ReceiveResultState(CMLHJ_Line owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }

            bool isComplete;
            public override void OnEnter()
            {
                base.OnEnter();
                isComplete = false;
                timer = 0f;
                owner.lineDatas.Clear();
                owner.lines.Clear();
                CMLHJ_Struct.CMD_3D_SC_Result result = CMLHJEntry.Instance.GameData.ResultData;
                for (int i = 0; i < result.nLineRate.Count; i++)
                {
                    if (result.nLineRate[i] > 0)//筛选中奖的位置
                    {
                        LineData data = new LineData();
                        data.Index = i;
                        owner.lineDatas.Add(data);
                    }
                }
            }
            public override void Update()
            {
                base.Update();
                if (isComplete) return;
                if (CMLHJEntry.Instance.GameData.ResultData.nWinGold <= 0)
                {
                    timer += Time.deltaTime;
                    if (timer>=0.5f)
                    {
                        isComplete = true;
                        CMLHJEntry.Instance.CMLHJ_ShowResultNum(true);
                        CMLHJEntry.Instance.CMLHJ_ShowOverBtn(false);
                        CMLHJ_Event.DispatchShowResultComplete();
                    }
                }
                else
                {
                    isComplete = true;
                    hsm?.ChangeState(nameof(ShowSingleState));
                }
            }
        }
        /// <summary>
        /// 单显 轮播
        /// </summary>
        private class ShowSingleState : State<CMLHJ_Line>
        {
            public ShowSingleState(CMLHJ_Line owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
                if (true)
                {

                }

                owner.Behaviour.StartCoroutine(PlayLineAnim());
            }

            IEnumerator PlayLineAnim()
            {
                CMLHJ_Struct.CMD_3D_SC_Result result = CMLHJEntry.Instance.GameData.ResultData;
                if (result.nWinGold/ CMLHJEntry.Instance.GameData.CurrentChip>300)
                {
                    CMLHJ_Audio.Instance.PlaySound(CMLHJ_Audio.Superwin);
                }
                else if (result.nWinGold / CMLHJEntry.Instance.GameData.CurrentChip>90)
                {
                    CMLHJ_Audio.Instance.PlaySound(CMLHJ_Audio.BigWin);
                }

                int index = 0;
                while (index < owner.lineDatas.Count)
                {
                    CMLHJ_Audio.Instance.PlaySound("hitline"+ owner.lineDatas[index].Index);
                    owner.transform.GetChild(owner.lineDatas[index].Index).gameObject.SetActive(true);
                    int gold = result.nLineRate[owner.lineDatas[index].Index] * CMLHJEntry.Instance.GameData.CurrentChip;
                    CMLHJ_Event.DispatchShowSingleLine(gold);
                    yield return new WaitForSeconds(0.5f);
                    index++;
                }
                yield return new WaitForSeconds(0.5f);
                if (CMLHJEntry.Instance.GameData.isAutoGame)
                {
                    CMLHJEntry.Instance.CMLHJ_ShowResultNum(true);
                    CMLHJEntry.Instance.CMLHJ_ShowOverBtn(false);
                    CMLHJ_Network.Instance.StartResult();
                }
                else
                {
                    CMLHJEntry.Instance.CMLHJ_ShowResultNum(true);
                    CMLHJEntry.Instance.CMLHJ_ShowOverBtn(true);
                }
            }
        }
         /// <summary>
        /// 关闭所有icon动画
        /// </summary>
        private class CloseEffectState : State<CMLHJ_Line>
        {
            public CloseEffectState(CMLHJ_Line owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            bool isComplete;
            public override void OnEnter()
            {
                base.OnEnter();
                isComplete = false;
                for (int i = 0; i < owner.RollContent.childCount; i++)
                {
                    Transform tran = owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content;
                    for (int j = 0; j < tran.childCount; j++)
                    {
                        Image img = tran.GetChild(j).FindChildDepth<Image>("Image");
                        img.color = Color.white;
                        img.enabled = true;
                    }
                }
                for (int i = 0; i < owner.RollContent.childCount; i++)
                {
                    Transform tran = owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content;
                    for (int j = 1; j < tran.childCount; j++)
                    {
                        if (tran.GetChild(j).GetChild(0).childCount>0)
                        {
                            owner.CollectEffect(tran.GetChild(j).GetChild(0).GetChild(0).gameObject);
                        }
                    }
                }
                for (int i = 0; i < owner.transform.childCount; i++)
                {
                    owner.transform.GetChild(i).gameObject.SetActive(false);
                }
            }
            public override void Update()
            {
                base.Update();
                if (isComplete) return;
                isComplete = true;
                hsm?.ChangeState(nameof(IdleState));
            }
        }
    }
}
