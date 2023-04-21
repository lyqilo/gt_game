
using DragonBones;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Transform = UnityEngine.Transform;

namespace Hotfix.FQGY
{
    public class FQGY_Line : ILHotfixEntity
    {
        private class LineData
        {
            public int Index;
            public int Count;
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
            states.Add(new ShowTotalState(this, hsm));
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
            FQGY_Event.ShowResult += FQGY_Event_ShowResult;
            FQGY_Event.StartRoll += FQGY_Event_StartRoll;
            HotfixActionHelper.ReconnectGame += EventHelper_ReconnectGame;
        }

        protected override void RemoveEvent()
        {
            FQGY_Event.ShowResult -= FQGY_Event_ShowResult;
            FQGY_Event.StartRoll -= FQGY_Event_StartRoll;
            HotfixActionHelper.ReconnectGame -= EventHelper_ReconnectGame;
        }

        private void EventHelper_ReconnectGame()
        {
            hsm?.ChangeState(nameof(CloseEffectState));
        }
        private void FQGY_Event_ShowResult()
        {
            if (FQGYEntry.Instance.GameData.ResultData.nWinGold <= 0) return;
            hsm?.ChangeState(nameof(ReceiveResultState));
        }

        private void FQGY_Event_StartRoll()
        {
            hsm?.ChangeState(nameof(CloseEffectState));
        }

        protected override void FindComponent()
        {
            RollContent = FQGYEntry.Instance.RollContent; //转动区域
            animContent = FQGYEntry.Instance.Icons; //显示库
        }
        /// <summary>
        /// 创建动画
        /// </summary>
        /// <param name="effectName">动画名</param>
        /// <returns></returns>
        private GameObject CreatHitEffect(string effectName)
        {
            //创建动画，先从对象池中获取
            Transform go = FQGYEntry.Instance.effectPool.Find(effectName);
            if (go != null) return go.gameObject;

            go = FQGYEntry.Instance.Icons.Find(effectName);
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
            effect.transform.SetParent(FQGYEntry.Instance.effectPool);
            effect.SetActive(false);
        }

        private class IdleState : State<FQGY_Line>
        {
            public IdleState(FQGY_Line owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {

            }
        }

        private class ReceiveResultState : State<FQGY_Line>
        {
            public ReceiveResultState(FQGY_Line owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            List<int> scatterlist = new List<int>();
            List<int> freelist = new List<int>();

            bool isComplete;
            public override void OnEnter()
            {
                base.OnEnter();
                isComplete = false;
                scatterlist.Clear();
                freelist.Clear();
                owner.lineDatas.Clear();
                owner.lines.Clear();
                owner.anims.Clear();

                FQGY_Struct.CMD_3D_SC_Result result = FQGYEntry.Instance.GameData.ResultData;

                for (int i = 0; i < result.cbHitIcon.Count; i++)
                {
                    if (result.cbHitIcon[i] > 0)//筛选中奖的位置
                    {
                        LineData data = new LineData();
                        data.Index = i;
                        //List<byte> hits = result.cbHitIcon.FindAllItem(delegate (byte b)
                        //{
                        //    return b > 0;
                        //});
                        data.Count = result.cbHitIcon[i];
                        owner.lineDatas.Add(data);
                    }
                }
                for (int i = 0; i < owner.RollContent.childCount; i++)
                {
                    Transform tran = owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content;
                    for (int j = 0; j < tran.childCount; j++)
                    {
                        Image img = tran.GetChild(j).FindChildDepth<Image>("Image");
                        img.color = Color.gray;
                    }
                }
            }
            public override void Update()
            {
                base.Update();
                if (isComplete) return;
                isComplete = true;
                if (owner.lineDatas.Count <= 0)
                {
                    for (int i = 0; i < FQGYEntry.Instance.GameData.ResultData.cbIcon.Count; i++)
                    {
                        if (FQGYEntry.Instance.GameData.ResultData.cbIcon[i] == 10)//有scatter
                        {
                            scatterlist.Add(i);
                        }
                        if (FQGYEntry.Instance.GameData.ResultData.cbIcon[i] == 9)
                        {
                            freelist.Add(i);
                        }
                    }
                    if (scatterlist.Count >= 3)//中了scatter奖
                    {
                        for (int i = 0; i < scatterlist.Count; i++)
                        {
                            int row = scatterlist[i] / 5;
                            int col = scatterlist[i] % 5;
                            Transform animTrans = owner.animContent.GetChild(col).GetChild(0).GetChild(row);
                            if (animTrans.childCount <= 0)
                            {
                                GameObject effectObj = owner.CreatHitEffect("Item10");
                                effectObj.transform.SetParent(animTrans);
                                effectObj.transform.localPosition = Vector3.zero;
                                effectObj.transform.localRotation = Quaternion.identity;
                                effectObj.transform.localScale = Vector3.one;
                                effectObj.name = "Item10";
                                effectObj.SetActive(true);
                            }
                        }
                    }
                    else if (freelist.Count >= 6 && FQGYEntry.Instance.GameData.ResultData.nFreeCount > 0)
                    {
                        for (int i = 0; i < freelist.Count; i++)
                        {
                            int row = freelist[i] / 5;
                            int col = freelist[i] % 5;
                            Transform animTrans = owner.animContent.GetChild(col).GetChild(0).GetChild(row);
                            if (animTrans.childCount <= 0)
                            {
                                GameObject effectObj = owner.CreatHitEffect("Item9");
                                effectObj.transform.SetParent(animTrans);
                                effectObj.transform.localPosition = Vector3.zero;
                                effectObj.transform.localRotation = Quaternion.identity;
                                effectObj.transform.localScale = Vector3.one;
                                effectObj.name = "Item9";
                                effectObj.SetActive(true);
                            }
                        }
                    }
                    else
                    {
                        hsm?.ChangeState(nameof(IdleState));
                    }
                }
                else
                {
                    hsm?.ChangeState(nameof(ShowTotalState));
                }
            }
        }
        /// <summary>
        /// 单显 轮播
        /// </summary>
        private class ShowSingleState : State<FQGY_Line>
        {
            public ShowSingleState(FQGY_Line owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            private int currentShowIndex = 0;
            private float timer;
            public override void OnEnter()
            {
                base.OnEnter();
                currentShowIndex = 0;
                timer = 0;
                for (int i = 0; i < owner.RollContent.childCount; i++)
                {
                    Transform tran = owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content;
                    for (int j = 0; j < tran.childCount; j++)
                    {
                        Image img = tran.GetChild(j).FindChildDepth<Image>("Image");
                        img.enabled = true;
                    }
                }
                for (int i = 0; i < owner.transform.childCount; i++)
                {
                    owner.transform.GetChild(i).gameObject.SetActive(false);
                }

                for (int i = 0; i < owner.lineDatas.Count; i++)
                {
                    owner.transform.GetChild(owner.lineDatas[i].Index).gameObject.SetActive(false);
                }
            }
            public override void Update()
            {
                base.Update();
            }
        }
        /// <summary>
        /// 总显
        /// </summary>
        private class ShowTotalState : State<FQGY_Line>
        {
            public ShowTotalState(FQGY_Line owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer;
            public override void OnEnter()
            {
                base.OnEnter();
                timer = 0;
                owner.lines.Clear();
                for (int i = 0; i < owner.lineDatas.Count; i++)
                {
                    List<int> lines = FQGY_DataConfig.Lines[owner.lineDatas[i].Index];//中奖线
                    //GameObject child = owner.transform.gameObject.InstantiateChild(i);
                    //FQGY_Audio.Instance.PlaySound(FQGY_Audio.Line);
                    owner.transform.GetChild(owner.lineDatas[i].Index).gameObject.SetActive(true);
                    List<Transform> showLine = new List<Transform>();
                    for (int j = 0; j < owner.lineDatas[i].Count; j++)
                    {
                        int hitIndex = lines[j] - 1;
                        int row = hitIndex / 5;
                        int col = hitIndex % 5;
                        Transform hitTrans = owner.RollContent.GetChild(col).GetComponent<ScrollRect>().content.GetChild(row + 1);
                        Transform animTrans = hitTrans.GetChild(0);
                        Image icon = hitTrans.FindChildDepth<Image>("Image");
                        icon.enabled = false;
                        //获取中奖的动画图标
                        if (animTrans.childCount <= 0)
                        {
                            string effectName = FQGY_DataConfig.IconTable[FQGYEntry.Instance.GameData.ResultData.cbIcon[hitIndex]];
                            GameObject effectObj = owner.CreatHitEffect(effectName);
                            effectObj.transform.SetParent(animTrans);
                            effectObj.transform.position = icon.transform.position;
                            effectObj.transform.localRotation = Quaternion.identity;
                            effectObj.transform.localScale = Vector3.one;
                            effectObj.name = hitTrans.gameObject.name;
                            effectObj.transform.FindChildDepth("Image").gameObject.SetActive(false);
                            effectObj.transform.FindChildDepth("Anim").gameObject.SetActive(true);
                            effectObj.SetActive(true);
                        }
                        showLine.Add(icon.transform);
                    }
                    owner.lines.Add(showLine);
                }
            }
            public override void Update()
            {
                base.Update();
                timer += Time.deltaTime;
                if (timer >= FQGY_DataConfig.lineAllShowTime)
                {
                    timer = 0;
                    // hsm?.ChangeState(nameof(ShowSingleState));
                }
            }
        }
        /// <summary>
        /// 关闭所有icon动画
        /// </summary>
        private class CloseEffectState : State<FQGY_Line>
        {
            public CloseEffectState(FQGY_Line owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
                        if (tran.GetChild(j).GetChild(0).childCount > 0)
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
