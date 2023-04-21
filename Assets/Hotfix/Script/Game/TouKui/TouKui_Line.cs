
using DragonBones;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Transform = UnityEngine.Transform;

namespace Hotfix.TouKui
{
    public class TouKui_Line : ILHotfixEntity
    {
        private class LineData
        {
            public int Index;
            public int Count;
        }
        private HierarchicalStateMachine _hsm;
        private List<IState> _states;
        private Transform _animContent;
        private Transform _rollContent;

        private List<List<Transform>> _lines;
        private List<List<Transform>> _anims;
        private List<LineData> _lineDatas;

        private List<int> _fudongList;

        protected override void Start()
        {
            base.Start();

            _lines = new List<List<Transform>>();
            _anims = new List<List<Transform>>();
            _lineDatas = new List<LineData>();
            _fudongList = new List<int>();

            _hsm = new HierarchicalStateMachine(false, gameObject);
            _states = new List<IState>();
            _states.Add(new IdleState(this, _hsm));
            _states.Add(new ReceiveResultState(this, _hsm));
            _states.Add(new ShowSingleState(this, _hsm));
            _states.Add(new ShowTotalState(this, _hsm));
            _states.Add(new CloseEffectState(this, _hsm));

            _hsm.Init(_states, nameof(IdleState));
        }
        protected override void Update()
        {
            base.Update();
            _hsm?.Update();
        }
        protected override void OnDestroy()
        {
            base.OnDestroy();
            _hsm?.CurrentState.OnExit();
        }

        protected override void AddEvent()
        {
            TouKui_Event.ShowResult += TouKui_Event_ShowResult;
            TouKui_Event.StartRoll += TouKui_Event_StartRoll;
            TouKui_Event.ExitSpecialMode += TouKui_Event_ExitSpecialMode;
            HotfixActionHelper.ReconnectGame += EventHelper_ReconnectGame;
        }

        protected override void RemoveEvent()
        {
            TouKui_Event.ShowResult -= TouKui_Event_ShowResult;
            TouKui_Event.StartRoll -= TouKui_Event_StartRoll;
            TouKui_Event.ExitSpecialMode -= TouKui_Event_ExitSpecialMode;
            HotfixActionHelper.ReconnectGame -= EventHelper_ReconnectGame;
        }

        private void EventHelper_ReconnectGame()
        {
            _hsm?.ChangeState(nameof(CloseEffectState));
        }
        private void TouKui_Event_ShowResult()
        {
            if (TouKuiEntry.Instance.GameData.ResultData.nWinGold <= 0) return;
            _hsm?.ChangeState(nameof(ReceiveResultState));
        }

        private void TouKui_Event_StartRoll()
        {
            _hsm?.ChangeState(nameof(CloseEffectState));
        }

        private void TouKui_Event_ExitSpecialMode()
        {
            _hsm?.ChangeState(nameof(CloseEffectState));
        }

        protected override void FindComponent()
        {
            _rollContent = TouKuiEntry.Instance.MainContent.FindChildDepth("Content/RollContent"); //转动区域
            _animContent = TouKuiEntry.Instance.MainContent.FindChildDepth("Content/AnimContent"); //显示库
        }
        /// <summary>
        /// 创建动画
        /// </summary>
        /// <param name="effectName">动画名</param>
        /// <returns></returns>
        private GameObject CreatHitEffect(string effectName)
        {
            //创建动画，先从对象池中获取
            Transform go = TouKuiEntry.Instance.effectPool.Find(effectName);
            if (go != null) return go.gameObject;

            go = TouKuiEntry.Instance.effectList.Find(effectName);
            GameObject _go = Object.Instantiate(go.gameObject);
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
        private void GetFudongList()
        {
            _fudongList.Clear();
            if (TouKuiEntry.Instance.GameData.ResultData.cbType == 1)
            {
                _fudongList.Add(TouKuiEntry.Instance.GameData.ResultData.nStartRow * 5 + TouKuiEntry.Instance.GameData.ResultData.nStartCol);
                _fudongList.Add(TouKuiEntry.Instance.GameData.ResultData.nStartRow * 5 + TouKuiEntry.Instance.GameData.ResultData.nStartCol + 1);
            }
            else if (TouKuiEntry.Instance.GameData.ResultData.cbType == 2)
            {
                _fudongList.Add(TouKuiEntry.Instance.GameData.ResultData.nStartRow * 5 + TouKuiEntry.Instance.GameData.ResultData.nStartCol);
                _fudongList.Add(TouKuiEntry.Instance.GameData.ResultData.nStartRow * 5 + TouKuiEntry.Instance.GameData.ResultData.nStartCol + 1);
                _fudongList.Add((TouKuiEntry.Instance.GameData.ResultData.nStartRow + 1) * 5 + TouKuiEntry.Instance.GameData.ResultData.nStartCol);
                _fudongList.Add((TouKuiEntry.Instance.GameData.ResultData.nStartRow + 1) * 5 + TouKuiEntry.Instance.GameData.ResultData.nStartCol + 1);
            }
            else if (TouKuiEntry.Instance.GameData.ResultData.cbType == 3)
            {
                _fudongList.Add(TouKuiEntry.Instance.GameData.ResultData.nStartRow * 5 + TouKuiEntry.Instance.GameData.ResultData.nStartCol);
                _fudongList.Add(TouKuiEntry.Instance.GameData.ResultData.nStartRow * 5 + TouKuiEntry.Instance.GameData.ResultData.nStartCol + 1);
                _fudongList.Add((TouKuiEntry.Instance.GameData.ResultData.nStartRow + 1) * 5 + TouKuiEntry.Instance.GameData.ResultData.nStartCol);
                _fudongList.Add((TouKuiEntry.Instance.GameData.ResultData.nStartRow + 1) * 5 + TouKuiEntry.Instance.GameData.ResultData.nStartCol + 1);
                _fudongList.Add((TouKuiEntry.Instance.GameData.ResultData.nStartRow + 2) * 5 + TouKuiEntry.Instance.GameData.ResultData.nStartCol);
                _fudongList.Add((TouKuiEntry.Instance.GameData.ResultData.nStartRow + 2) * 5 + TouKuiEntry.Instance.GameData.ResultData.nStartCol + 1);
            }
            else if (TouKuiEntry.Instance.GameData.ResultData.cbType == 3)
            {
                _fudongList.Add(TouKuiEntry.Instance.GameData.ResultData.nStartRow * 5 + TouKuiEntry.Instance.GameData.ResultData.nStartCol);
                _fudongList.Add(TouKuiEntry.Instance.GameData.ResultData.nStartRow * 5 + TouKuiEntry.Instance.GameData.ResultData.nStartCol + 1);
                _fudongList.Add(TouKuiEntry.Instance.GameData.ResultData.nStartRow * 5 + TouKuiEntry.Instance.GameData.ResultData.nStartCol + 2);
                _fudongList.Add((TouKuiEntry.Instance.GameData.ResultData.nStartRow + 1) * 5 + TouKuiEntry.Instance.GameData.ResultData.nStartCol);
                _fudongList.Add((TouKuiEntry.Instance.GameData.ResultData.nStartRow + 1) * 5 + TouKuiEntry.Instance.GameData.ResultData.nStartCol + 1);
                _fudongList.Add((TouKuiEntry.Instance.GameData.ResultData.nStartRow + 1) * 5 + TouKuiEntry.Instance.GameData.ResultData.nStartCol + 2);
                _fudongList.Add((TouKuiEntry.Instance.GameData.ResultData.nStartRow + 2) * 5 + TouKuiEntry.Instance.GameData.ResultData.nStartCol);
                _fudongList.Add((TouKuiEntry.Instance.GameData.ResultData.nStartRow + 2) * 5 + TouKuiEntry.Instance.GameData.ResultData.nStartCol + 1);
                _fudongList.Add((TouKuiEntry.Instance.GameData.ResultData.nStartRow + 2) * 5 + TouKuiEntry.Instance.GameData.ResultData.nStartCol + 2);
            }
        }
        private class IdleState : State<TouKui_Line>
        {
            public IdleState(TouKui_Line owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
        }
        private class ReceiveResultState : State<TouKui_Line>
        {
            public ReceiveResultState(TouKui_Line owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            List<int> scatterlist = new List<int>();
            bool _isComplete;
            public override void OnEnter()
            {
                base.OnEnter();
                _isComplete = false;
                scatterlist.Clear();
                owner._lineDatas.Clear();
                owner._lines.Clear();
                owner._anims.Clear();
                owner.GetFudongList();
                TouKui_Struct.CMD_3D_SC_Result result = TouKuiEntry.Instance.GameData.ResultData;
                for (int i = 0; i < result.cbHitIcon.Count; i++)
                {
                    if (result.cbHitIcon[i][0] <= 0) continue;
                    LineData data = new LineData();
                    data.Index = i;
                    List<byte> hits = result.cbHitIcon[i].FindAllItem(b => b > 0);
                    data.Count = hits.Count;
                    owner._lineDatas.Add(data);
                }
                for (int i = 0; i < owner._rollContent.childCount; i++)
                {
                    Transform tran = owner._rollContent.GetChild(i).GetComponent<ScrollRect>().content;
                    for (int j = 0; j < tran.childCount; j++)
                    {
                        Image img = tran.GetChild(j).FindChildDepth<Image>("Icon");
                        img.color = Color.gray;
                    }
                }
            }
            public override void Update()
            {
                base.Update();
                if (_isComplete) return;
                _isComplete = true;
                if (owner._lineDatas.Count <= 0)
                {
                    for (int i = 0; i < TouKuiEntry.Instance.GameData.ResultData.cbIcon.Count; i++)
                    {
                        if (TouKuiEntry.Instance.GameData.ResultData.cbIcon[i] == 11)//有scatter
                        {
                            scatterlist.Add(i);
                        }
                    }
                    if (scatterlist.Count >= 3)//中了scatter奖
                    {
                        for (int i = 0; i < scatterlist.Count; i++)
                        {
                            int row = scatterlist[i] / 5;
                            int col = scatterlist[i] % 5;
                            Transform animTrans = owner._animContent.GetChild(col).GetChild(0).GetChild(row);
                            if (animTrans.childCount <= 0)
                            {
                                GameObject effectObj = owner.CreatHitEffect("Item12");
                                effectObj.transform.SetParent(animTrans);
                                effectObj.transform.localPosition = Vector3.zero;
                                effectObj.transform.localRotation = Quaternion.identity;
                                effectObj.transform.localScale = Vector3.one;
                                effectObj.name = "Item12";
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
        private class ShowSingleState : State<TouKui_Line>
        {
            public ShowSingleState(TouKui_Line owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            private int _currentShowIndex = 0;
            private float _timer;
            public override void OnEnter()
            {
                base.OnEnter();
                _currentShowIndex = 0;
                _timer = 0;
                for (int i = 0; i < owner._rollContent.childCount; i++)
                {
                    Transform tran = owner._rollContent.GetChild(i).GetComponent<ScrollRect>().content;
                    for (int j = 0; j < tran.childCount; j++)
                    {
                        Image img = tran.GetChild(j).FindChildDepth<Image>("Icon");
                        img.enabled = true;
                    }
                }
                for (int i = 0; i < owner._anims.Count; i++)
                {
                    for (int j = 0; j < owner._anims[i].Count; j++)
                    {
                        owner._anims[i][j].gameObject.SetActive(false);
                    }
                }
                for (int i = 0; i < owner.transform.childCount; i++)
                {
                    owner.transform.GetChild(i).gameObject.SetActive(false);
                }
                for (int i = 0; i < owner._lines[_currentShowIndex].Count; i++)
                {
                    owner._lines[_currentShowIndex][i].GetComponent<Image>().enabled = false;
                }
                for (int i = 0; i < owner._anims[_currentShowIndex].Count; i++)
                {
                    owner._anims[_currentShowIndex][i].gameObject.SetActive(true);
                }
                owner.transform.GetChild(0).gameObject.SetActive(true);
                owner.transform.GetChild(0).GetComponent<UnityArmatureComponent>().dbAnimation.Play((owner._lineDatas[_currentShowIndex].Index + 1).ToString());
                ShowFudong();
            }
            private void ShowFudong()
            {
                bool isShow = false;
                List<int> lines = TouKui_DataConfig.Lines[owner._lineDatas[_currentShowIndex].Index];//中奖线
                for (int i = 0; i < lines.Count; i++)
                {
                    if (!owner._fudongList.Contains(lines[i] - 1)) continue;
                    isShow = true;
                    break;
                }
                TouKui_Event.DispatchShowFuDongWin(isShow);
            }
            public override void Update()
            {
                base.Update();
                _timer += Time.deltaTime;
                if (_timer < TouKui_DataConfig.cyclePlayLineTime) return;
                _timer = 0;
                for (int i = 0; i < owner._lines[_currentShowIndex].Count; i++)
                {
                    owner._lines[_currentShowIndex][i].GetComponent<Image>().enabled = true;
                }
                for (int i = 0; i < owner._anims[_currentShowIndex].Count; i++)
                {
                    owner._anims[_currentShowIndex][i].gameObject.SetActive(false);
                }
                _currentShowIndex++;
                if (_currentShowIndex >= owner._lines.Count)
                {
                    _currentShowIndex = 0;
                }

                owner.transform.GetChild(0).gameObject.SetActive(true);
                owner.transform.GetChild(0).GetComponent<UnityArmatureComponent>().dbAnimation.Play((owner._lineDatas[_currentShowIndex].Index + 1).ToString());
                for (int i = 0; i < owner._lines[_currentShowIndex].Count; i++)
                {
                    owner._lines[_currentShowIndex][i].GetComponent<Image>().enabled = false;
                }
                for (int i = 0; i < owner._anims[_currentShowIndex].Count; i++)
                {
                    owner._anims[_currentShowIndex][i].gameObject.SetActive(true);
                }
                ShowFudong();
            }
        }
        /// <summary>
        /// 总显
        /// </summary>
        private class ShowTotalState : State<TouKui_Line>
        {
            public ShowTotalState(TouKui_Line owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float _timer;
            public override void OnEnter()
            {
                base.OnEnter();
                _timer = 0;
                owner._lines.Clear();
                owner._anims.Clear();
                bool isShow = false;
                for (int i = 0; i < owner._lineDatas.Count; i++)
                {
                    List<int> lines = TouKui_DataConfig.Lines[owner._lineDatas[i].Index];//中奖线
                    GameObject child = owner.transform.gameObject.InstantiateChild(i);
                    child.transform.localScale = Vector2.one * 100;//龙骨动画本身就是100*100
                    child.SetActive(true);
                    child.transform.GetComponent<UnityArmatureComponent>().dbAnimation.Play((owner._lineDatas[i].Index + 1).ToString());//播放线动画
                    List<Transform> showLine = new List<Transform>();
                    List<Transform> showAnim = new List<Transform>();
                    for (int j = 0; j < owner._lineDatas[i].Count; j++)
                    {
                        int hitIndex = lines[j] - 1;
                        int row = hitIndex / 5;
                        int col = hitIndex % 5;
                        if (owner._fudongList.Contains(hitIndex))
                        {
                            isShow = true;
                        }
                        Transform hitTrans = owner._rollContent.GetChild(col).GetComponent<ScrollRect>().content.GetChild(row);
                        Transform animTrans = owner._animContent.GetChild(col).GetChild(0).GetChild(row);
                        Image icon = hitTrans.FindChildDepth<Image>("Icon");
                        icon.enabled = false;
                        //获取中奖的动画图标
                        if (animTrans.childCount <= 0)
                        {
                            string effectName = TouKui_DataConfig.IconTable[TouKuiEntry.Instance.GameData.ResultData.cbIcon[hitIndex]];
                            if (TouKuiEntry.Instance.GameData.ResultData.cbIcon[hitIndex] == 10)
                            {
                                if (TouKuiEntry.Instance.GameData.isFreeGame)
                                {
                                    effectName = TouKui_DataConfig.IconTable[11 + (int)TouKuiEntry.Instance.GameData.CurrentMode];
                                }
                                else if (TouKuiEntry.Instance.GameData.isNormalFreeGame)
                                {
                                    effectName = TouKui_DataConfig.IconTable[11 + (int)TouKuiEntry.Instance.GameData.CurrentNormalMode];
                                }
                            }
                            GameObject effectObj = owner.CreatHitEffect(effectName);
                            effectObj.transform.SetParent(animTrans);
                            effectObj.transform.position = icon.transform.position;
                            effectObj.transform.localRotation = Quaternion.identity;
                            effectObj.transform.localScale = Vector3.one;
                            effectObj.name = hitTrans.gameObject.name;
                            effectObj.SetActive(true);
                        }
                        showAnim.Add(animTrans.GetChild(0));

                        showLine.Add(icon.transform);
                    }
                    owner._lines.Add(showLine);
                    owner._anims.Add(showAnim);
                }
                TouKui_Event.DispatchShowFuDongWin(isShow);
            }
            public override void Update()
            {
                base.Update();
                _timer += Time.deltaTime;
                if (_timer < TouKui_DataConfig.lineAllShowTime) return;
                _timer = 0;
                hsm?.ChangeState(nameof(ShowSingleState));
            }
        }
        /// <summary>
        /// 关闭所有icon动画
        /// </summary>
        private class CloseEffectState : State<TouKui_Line>
        {
            public CloseEffectState(TouKui_Line owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            bool _isComplete;
            public override void OnEnter()
            {
                base.OnEnter();
                _isComplete = false;
                for (int i = 0; i < owner._rollContent.childCount; i++)
                {
                    Transform tran = owner._rollContent.GetChild(i).GetComponent<ScrollRect>().content;
                    for (int j = 0; j < tran.childCount; j++)
                    {
                        Image img = tran.GetChild(j).FindChildDepth<Image>("Icon");
                        img.color = Color.white;
                        img.enabled = true;
                    }
                }
                for (int i = 0; i < owner._animContent.childCount; i++)
                {
                    if (owner._animContent.GetChild(i).childCount <= 0) continue;
                    Transform child = owner._animContent.GetChild(i).GetChild(0);
                    for (int j = 0; j < child.childCount; j++)
                    {
                        for (int k = 0; k < child.GetChild(j).childCount; k++)
                        {
                            owner.CollectEffect(child.GetChild(j).GetChild(k).gameObject);
                        }
                    }
                }
                for (int i = 0; i < owner.transform.childCount; i++)
                {
                    owner.transform.GetChild(i).gameObject.SetActive(false);
                }
                TouKui_Event.DispatchShowFuDongWin(false);
            }
            public override void Update()
            {
                base.Update();
                if (_isComplete) return;
                _isComplete = true;
                hsm?.ChangeState(nameof(IdleState));
            }
        }
    }
}
