
using DragonBones;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Transform = UnityEngine.Transform;
using System.Collections;
using DG.Tweening;
using TMPro;

namespace Hotfix.JTJW
{
    public class JW_Line : ILHotfixEntity
    {
        private class LineData
        {
            public int Index;
            public int Count;
        }
        private HierarchicalStateMachine hsm;
        private List<IState> states;
        private Transform RollContent;
        private Transform CSContent;

        private List<List<Transform>> lines;
        private List<LineData> lineDatas;

        bool iscbRerun;
        int twNum = 0;

        private List<GameObject> gameL = new List<GameObject>();

        protected override void Start()
        {
            base.Start();

            lines = new List<List<Transform>>();
            lineDatas = new List<LineData>();

            hsm = new HierarchicalStateMachine(false, gameObject);
            states = new List<IState>();
            states.Add(new IdleState(this, hsm));
            states.Add(new ReceiveResultState(this, hsm));
            states.Add(new ShowSingleState(this, hsm));
            states.Add(new ShowTotalState(this, hsm));
            states.Add(new CloseEffectState(this, hsm));

            hsm.Init(states, nameof(IdleState));
            iscbRerun = false;
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
            JW_Event.ShowLine += JW_Event_ShowLine;
            JW_Event.StartRoll += JW_Event_StartRoll;
            JW_Event.ShowFreePlay += ShowFreeAnim;

        }

        protected override void RemoveEvent()
        {
            JW_Event.ShowLine -= JW_Event_ShowLine;
            JW_Event.StartRoll -= JW_Event_StartRoll;

            JW_Event.ShowFreePlay -= ShowFreeAnim;
        }

        private void JW_Event_ShowLine()
        {
           // if (JWEntry.Instance.GameData.ResultData.nWinGold <= 0) return;
            hsm?.ChangeState(nameof(ReceiveResultState));
        }

        private void JW_Event_StartRoll()
        {
            hsm?.ChangeState(nameof(CloseEffectState));
        }

        protected override void FindComponent()
        {
            RollContent = JWEntry.Instance.MainContent.Find("Content/RollContent"); //转动区域
            CSContent = JWEntry.Instance.MainContent.Find("Content/CSContent"); //特效区域
        }

        private void ShowFreeAnim()
        {
            if (gameL.Count<3) return;
            for (int i = 0; i < gameL.Count; i++)
            {
                gameL[i].transform.parent.GetComponent<Image>().enabled = false;
                gameL[i].transform.Find("loop").gameObject.SetActive(true);
                gameL[i].transform.Find("begin").gameObject.SetActive(false);
                gameL[i].transform.Find("play").gameObject.SetActive(false);
                gameL[i].transform.Find("Double").gameObject.SetActive(false);
                gameL[i].transform.Find("destroy").gameObject.SetActive(false);
                gameL[i].SetActive(true);
            }
        }

        /// <summary>
        /// 创建动画
        /// </summary>
        /// <param name="effectName">动画名</param>
        /// <returns></returns>
        private GameObject CreatHitEffect(string effectName)
        {
            //创建动画，先从对象池中获取
            Transform go = JWEntry.Instance.effectPool.Find(effectName);
            if (go != null) return go.gameObject;

            go = JWEntry.Instance.effectList.Find(effectName);
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
            effect.transform.SetParent(JWEntry.Instance.effectPool);
            effect.SetActive(false);
        }
        private class IdleState : State<JW_Line>
        {
            public IdleState(JW_Line owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
        }
        private class ReceiveResultState : State<JW_Line>
        {
            public ReceiveResultState(JW_Line owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            bool isComplete;
            public override void OnEnter()
            {
                base.OnEnter();
                isComplete = false;
                owner.lineDatas.Clear();
                owner.lines.Clear();
                JW_Struct.CMD_3D_SC_Result result = JWEntry.Instance.GameData.ResultData;
                for (int i = 0; i < result.cbHitIcon.Count; i++)
                {
                    if (result.cbHitIcon[i] > 0)//筛选中奖的位置
                    {
                        LineData data = new LineData();
                        data.Index = i;
                        List<byte> hits = result.cbHitIcon.FindAllItem(delegate (byte b)
                          {
                              return b > 0;
                          });
                        data.Count = hits.Count;
                        owner.lineDatas.Add(data);
                    }
                }
                //变灰
                for (int i = 0; i < owner.RollContent.childCount; i++)
                {
                    Transform tran = owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content;
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
                if (isComplete) return;
                isComplete = true;
                hsm?.ChangeState(nameof(ShowTotalState));
            }
        }
        /// <summary>
        /// 单显 轮播
        /// </summary>
        private class ShowSingleState : State<JW_Line>
        {
            public ShowSingleState(JW_Line owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            public override void OnEnter()
            {
                base.OnEnter();
            }
            public override void Update()
            {
                base.Update();
            }
        }
        /// <summary>
        /// 总显
        /// </summary>
        private class ShowTotalState : State<JW_Line>
        {
            JW_Struct.CMD_3D_SC_Result result;
            Vector3 v1 = new Vector3(0, 167+250, 0);
            Vector3 v2 = new Vector3(0, 0+250, 0);
            Vector3 v3 = new Vector3(0, -167+250, 0);
            Vector3 _pos;
            List<GameObject> gameList = new List<GameObject>();
            enum AnimPlayState
            {
                Idle,
                Play,
                Double,
                Loop,
                Destroy,
            }
            AnimPlayState playState;

            List<float> listfNV = new List<float>() 
            {
                0.5f,
                0.45f,
                0.5f,
                1.4f,
                1.27f,
            };
            List<float> listfNAN = new List<float>() 
            { 
                0.25f,
                0.43f,
                0.8f,
                1.13f,
                0.8f,
            };
            List<float> listf = new List<float>();
            public ShowTotalState(JW_Line owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            float timer;
            public override void OnEnter()
            {
                base.OnEnter();
                timer = 0;
                owner.lines.Clear();
                gameList.Clear();
                owner.gameL.Clear();
                result = JWEntry.Instance.GameData.ResultData;
                playState = AnimPlayState.Idle;
                for (int i = 0; i < result.cbHitIcon.Count; i++)
                {
                    if (result.cbHitIcon[i]>0)
                    {
                        int hitIndex = i;
                        int col = hitIndex / 5;
                        int raw = hitIndex % 5;
                        Transform hitTrans = owner.RollContent.GetChild(raw).GetComponent<ScrollRect>().content.GetChild(col);
                        owner.CSContent.GetChild(raw).GetComponent<ScrollRect>().content.GetChild(col).gameObject.SetActive(false);
                        Image icon = hitTrans.FindChildDepth<Image>("Icon");
                        icon.enabled = false;
                        if (icon.transform.childCount <= 0)
                        {
                            string effectName = JW_DataConfig.IconTable[JWEntry.Instance.GameData.ResultData.cbIcon[hitIndex]];
                            GameObject effectObj = owner.CreatHitEffect(effectName);
                            effectObj.name = effectName;
                            effectObj.transform.SetParent(icon.transform);
                            effectObj.transform.localPosition = Vector3.zero;
                            effectObj.transform.localRotation = Quaternion.identity;
                            effectObj.transform.localScale = Vector3.one;
                            PlayeStateControl(effectObj,playState);
                            effectObj.SetActive(true);
                            gameList.Add(effectObj);
                        }
                    }
                    else
                    {
                        if (JWEntry.Instance.GameData.ResultData.cbIcon[i]==8)
                        {
                            int hitIndex = i;
                            int col = hitIndex / 5;
                            int raw = hitIndex % 5;
                            Transform hitTrans = owner.RollContent.GetChild(raw).GetComponent<ScrollRect>().content.GetChild(col);
                            Image icon = hitTrans.FindChildDepth<Image>("Icon");
                            //icon.enabled = false;
                            if (icon.transform.childCount <= 0)
                            {
                                string effectName = JW_DataConfig.IconTable[JWEntry.Instance.GameData.ResultData.cbIcon[hitIndex]];
                                GameObject effectObj = owner.CreatHitEffect(effectName);
                                effectObj.name = effectName;
                                effectObj.transform.SetParent(icon.transform);
                                effectObj.transform.localPosition = Vector3.zero;
                                effectObj.transform.localRotation = Quaternion.identity;
                                effectObj.transform.localScale = Vector3.one;
                                owner.gameL.Add(effectObj);
                            }
                        }
                    }
                }
                if (result.cbRerun > 0)
                    owner.Behaviour.StartCoroutine(BeginPlay_Anim());
                else
                    JW_Event.DispatchRollComplete();
            }

            private IEnumerator BeginPlay_Anim()
            {
                yield return new WaitForEndOfFrame();
                JW_Audio.Instance.PlaySound(JW_Audio.iconWinStar);
                if (result.cbDoubleCount > 0)
                {
                    JW_Event.DispatchShowW();
                    owner.twNum++;
                    if (owner.twNum % 2 == 0)
                        listf = listfNAN;
                    else
                        listf = listfNV;
                }

                playState = AnimPlayState.Play;
                for (int i = 0; i < gameList.Count; i++)
                {
                    if (i==0)
                        JW_Audio.Instance.PlaySound(JW_Audio.wuStar);
                    PlayeStateControl(gameList[i], playState);
                }

                if (result.nFreeCount > 0 || JWEntry.Instance.GameData.TotalFreeWin > 0)
                    yield return new WaitForEndOfFrame();
                else
                    yield return new WaitForSeconds(0.45f);

                playState = AnimPlayState.Loop;
                for (int i = 0; i < gameList.Count; i++)
                {
                    PlayeStateControl(gameList[i], playState);
                }

                if (result.nFreeCount > 0 || JWEntry.Instance.GameData.TotalFreeWin > 0)
                {
                    yield return new WaitForEndOfFrame();
                    for (int i = 0; i < result.nDouble.Count; i++)
                    {
                        if (result.cbHitIcon[i] > 0)
                        {
                            if (result.nDouble[i] > 0)
                            {
                                int hitIndex = i;
                                int col = hitIndex / 5;
                                int raw = hitIndex % 5;
                                Transform hitTrans = owner.RollContent.GetChild(raw).GetComponent<ScrollRect>().content.GetChild(col).GetChild(0).GetChild(0);
                                hitTrans.transform.FindChildDepth<Transform>("Double/double").gameObject.SetActive(false);
                                hitTrans.transform.FindChildDepth<Transform>("Double/Text").gameObject.SetActive(false);
                                _pos = hitTrans.transform.FindChildDepth<Transform>("Double/Text").transform.position;
                                hitTrans.transform.FindChildDepth<Transform>("Double/Text").transform.DOLocalMoveY(10, 0.1f);
                                hitTrans.transform.FindChildDepth<TextMeshProUGUI>("Double/double/doubleNum").text = ToolHelper.ShowRichText(("x" + result.nDouble[i]));
                                hitTrans.transform.FindChildDepth<TextMeshProUGUI>("Double/Text").text = ToolHelper.ShowRichText(("+" + result.nDouble[i] * JWEntry.Instance.GameData.CurrentChip));
                                playState = AnimPlayState.Double;
                                PlayeStateControl(hitTrans.gameObject, playState);
                                hitTrans.transform.FindChildDepth<Transform>("Double/double").gameObject.SetActive(true);
                                hitTrans.transform.FindChildDepth<Transform>("Double/Text").gameObject.SetActive(false);
                                yield return new WaitForSeconds(0.05f);
                            }
                        }
                    }
                    yield return new WaitForSeconds(0.5f);

                    for (int i = 0; i < result.nDouble.Count; i++)
                    {
                        if (result.cbHitIcon[i] > 0)
                        {
                            if (result.nDouble[i] > 0)
                            {
                                int hitIndex = i;
                                int col = hitIndex / 5;
                                int raw = hitIndex % 5;
                                Transform hitTrans = owner.RollContent.GetChild(raw).GetComponent<ScrollRect>().content.GetChild(col).GetChild(0).GetChild(0);
                                hitTrans.transform.FindChildDepth<Transform>("Double/double").gameObject.SetActive(false);
                                hitTrans.transform.FindChildDepth<Transform>("Double/Text").gameObject.SetActive(true);
                                hitTrans.transform.FindChildDepth<Transform>("Double/Text").transform.DOLocalMoveY(-10, 0.3f);
                                yield return new WaitForSeconds(0.05f);
                            }
                        }
                    }
                    yield return new WaitForSeconds(0.5f);

                }
                else
                {
                    if (result.cbDoubleCount > 0)
                    {
                        int playCount = 0;
                        int playHitCount = 0;

                        for (int i = 0; i < result.nDouble.Count; i++)
                        {
                            if (result.cbHitIcon[i] > 0)
                            {
                                playHitCount++;
                                if (result.nDouble[i] > 0)
                                {
                                    int hitIndex = i;
                                    int col = hitIndex / 5;
                                    int raw = hitIndex % 5;
                                    Transform hitTrans = owner.RollContent.GetChild(raw).GetComponent<ScrollRect>().content.GetChild(col).GetChild(0).GetChild(0);
                                    hitTrans.transform.FindChildDepth<Transform>("Double/double").gameObject.SetActive(false);
                                    hitTrans.transform.FindChildDepth<Transform>("Double/Text").gameObject.SetActive(false);
                                    _pos = hitTrans.transform.FindChildDepth<Transform>("Double/Text").transform.position;
                                    hitTrans.transform.FindChildDepth<Transform>("Double/Text").transform.DOLocalMoveY(10, 0.1f);
                                    hitTrans.transform.FindChildDepth<TextMeshProUGUI>("Double/double/doubleNum").text = ToolHelper.ShowRichText(("x" + result.nDouble[i]));
                                    hitTrans.transform.FindChildDepth<TextMeshProUGUI>("Double/Text").text = ToolHelper.ShowRichText(("+" + result.nDouble[i] * JWEntry.Instance.GameData.CurrentChip));
                                    if (playCount==0)
                                        yield return new WaitForSeconds(listf[playCount]);
                                    else
                                        yield return new WaitForSeconds(listf[playCount]/2);
                                    playState = AnimPlayState.Double;
                                    PlayeStateControl(hitTrans.gameObject, playState);
                                    JW_Audio.Instance.PlaySound(JW_Audio.iconBO);
                                    hitTrans.transform.FindChildDepth<Transform>("Double/double").gameObject.SetActive(true);
                                    hitTrans.transform.FindChildDepth<Transform>("Double/Text").gameObject.SetActive(false);
                                    JW_Event.DispatchTWGPlay();
                                    playCount++;
                                    if (playCount>= listf.Count)
                                        playCount = listf.Count - 1;

                                    yield return new WaitForSeconds(listfNV[playCount] / 2);
                                    //yield return new WaitForSeconds(0.5f);
                                    hitTrans.transform.FindChildDepth<Transform>("Double/double").gameObject.SetActive(false);
                                    hitTrans.transform.FindChildDepth<Transform>("Double/Text").gameObject.SetActive(true);
                                    hitTrans.transform.FindChildDepth<Transform>("Double/Text").transform.DOLocalMoveY(-10, 0.3f);
                                }
                            }
                        }
                        yield return new WaitForSeconds(3f- (playCount*0.5f));
                        playState = AnimPlayState.Destroy;
                        for (int i = 0; i < result.nDouble.Count; i++)
                        {
                            if (result.cbHitIcon[i] > 0)
                            {
                                if (result.nDouble[i] <= 0)
                                {
                                    int hitIndex = i;
                                    int col = hitIndex / 5;
                                    int raw = hitIndex % 5;
                                    Transform hitTrans = owner.RollContent.GetChild(raw).GetComponent<ScrollRect>().content.GetChild(col).GetChild(0).GetChild(0);
                                    PlayeStateControl(hitTrans.gameObject, playState);
                                }
                                else
                                {
                                    int hitIndex = i;
                                    int col = hitIndex / 5;
                                    int raw = hitIndex % 5;
                                    Transform hitTrans = owner.RollContent.GetChild(raw).GetComponent<ScrollRect>().content.GetChild(col).GetChild(0).GetChild(0);
                                    hitTrans.gameObject.SetActive(false);
                                }
                            }
                        }
                        if (playHitCount > result.cbDoubleCount)
                        {
                            yield return new WaitForSeconds(1f);
                        }
                    }
                    else
                    {
                        yield return new WaitForSeconds(1f);
                        playState = AnimPlayState.Destroy;
                        for (int i = 0; i < gameList.Count; i++)
                        {
                            PlayeStateControl(gameList[i], playState);
                        }
                        yield return new WaitForSeconds(1f);
                    }
                }

                JWEntry.Instance.JW_Event_ShowResultNum(result.nWinGold);

                playState = AnimPlayState.Idle;
                for (int i = 0; i < gameList.Count; i++)
                {
                    PlayeStateControl(gameList[i], playState);
                }
                MovePos();
                yield return new WaitForSeconds(JW_DataConfig.NextWheelShowTime);
                hsm?.ChangeState(nameof(CloseEffectState));
                yield return new WaitForEndOfFrame();
                if (result.cbRerun > 0)
                    JW_Network.Instance.StartGame();
                else
                    JW_Event.DispatchRollComplete();
            }

            private void PlayeStateControl(GameObject go, AnimPlayState staIndex)
            {
                switch (staIndex)
                {
                    case AnimPlayState.Idle:
                        go.transform.Find("begin").gameObject.SetActive(false);
                        go.transform.Find("play").gameObject.SetActive(false);
                        go.transform.Find("loop").gameObject.SetActive(false);
                        go.transform.Find("Double").gameObject.SetActive(false);
                        go.transform.Find("destroy").gameObject.SetActive(false);
                        break;
                    case AnimPlayState.Play:
                        go.transform.Find("begin").gameObject.SetActive(true);
                        go.transform.Find("play").gameObject.SetActive(true);
                        go.transform.Find("loop").gameObject.SetActive(false);
                        go.transform.Find("Double").gameObject.SetActive(false);
                        go.transform.Find("destroy").gameObject.SetActive(false);
                        break;
                    case AnimPlayState.Double:
                        go.transform.Find("begin").gameObject.SetActive(false);
                        go.transform.Find("play").gameObject.SetActive(false);
                        go.transform.Find("loop").gameObject.SetActive(false);
                        go.transform.Find("Double").gameObject.SetActive(true);
                        go.transform.Find("destroy").gameObject.SetActive(false);
                        break;
                    case AnimPlayState.Loop:
                        go.transform.Find("begin").gameObject.SetActive(false);
                        go.transform.Find("play").gameObject.SetActive(false);
                        go.transform.Find("loop").gameObject.SetActive(true);
                        go.transform.Find("Double").gameObject.SetActive(false);
                        go.transform.Find("destroy").gameObject.SetActive(false);
                        break;
                    case AnimPlayState.Destroy:
                        go.transform.Find("begin").gameObject.SetActive(false);
                        go.transform.Find("play").gameObject.SetActive(false);
                        go.transform.Find("loop").gameObject.SetActive(false);
                        go.transform.Find("Double").gameObject.SetActive(false);
                        go.transform.Find("destroy").gameObject.SetActive(true);
                        break;
                    default:
                        break;
                }

            }

            private void MovePos()
            {
                for (int i = 0; i < owner.RollContent.childCount; i++)
                {
                    if (result.cbHitIcon[i] == 0)
                    {
                        if (result.cbHitIcon[i + 5] == 0)
                        {
                            if (result.cbHitIcon[i + 10] > 0)
                            {
                                owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content.GetChild(0).DOLocalMove(v2, JW_DataConfig.ImageDownShowTime);
                                owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content.GetChild(1).DOLocalMove(v3, JW_DataConfig.ImageDownShowTime);
                                owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content.GetChild(2).localPosition = v1;
                                owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content.GetChild(2).SetAsFirstSibling();
                            }
                        }
                        else
                        {
                            if (result.cbHitIcon[i + 10] > 0)
                            {
                                owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content.GetChild(0).DOLocalMove(v3, JW_DataConfig.ImageDownShowTime);
                                owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content.GetChild(1).localPosition = v1;
                                owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content.GetChild(2).localPosition = v2;
                                owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content.GetChild(0).SetAsLastSibling();
                            }
                            else
                            {
                                owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content.GetChild(0).DOLocalMove(v2, JW_DataConfig.ImageDownShowTime);
                                owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content.GetChild(1).localPosition = v1;
                                owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content.GetChild(2).localPosition = v3;
                                owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content.GetChild(1).SetAsFirstSibling();
                            }
                        }
                    }
                    else
                    {
                        if (result.cbHitIcon[i + 5] == 0)
                        {
                            if (result.cbHitIcon[i + 10] > 0)
                            {
                                owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content.GetChild(1).DOLocalMove(v3, JW_DataConfig.ImageDownShowTime);
                                owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content.GetChild(2).localPosition = v2;
                                owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content.GetChild(0).localPosition = v1;
                                owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content.GetChild(1).SetAsLastSibling();
                            }
                        }
                    }
                }
            }

            public override void Update()
            {
                base.Update();
            }

            public override void OnExit()
            {
                base.OnExit();
                owner.Behaviour.StopCoroutine(BeginPlay_Anim());

            }
        }
        /// <summary>
        /// 关闭所有icon动画
        /// </summary>
        private class CloseEffectState : State<JW_Line>
        {
            public CloseEffectState(JW_Line owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
                        Image img = tran.GetChild(j).FindChildDepth<Image>("Icon");
                        img.color = Color.white;
                        if (!owner.iscbRerun)
                        {
                            img.enabled = true;
                        }
                        if (img.transform.childCount > 0)
                        {
                            owner.CollectEffect(img.transform.GetChild(0).gameObject);
                        }
                    }
                }
                for (int i = 0; i < owner.transform.childCount; i++)
                {
                    owner.transform.GetChild(i).gameObject.SetActive(false);
                }

                if (JWEntry.Instance.GameData.ResultData.cbRerun > 0)
                    owner.iscbRerun = true;
                else
                    owner.iscbRerun = false;
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
