
using DragonBones;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Transform = UnityEngine.Transform;
using System.Collections;
using DG.Tweening;
using TMPro;

namespace Hotfix.MJHL
{
    public class MJHL_Line : ILHotfixEntity
    {
        private class LineData
        {
            public int Index;
            public bool isGolden;
        }
        private HierarchicalStateMachine hsm;
        private List<IState> states;
        private Transform RollContent;
        private Transform CSContent;
        private Transform icons;

        private List<List<Transform>> lines;
        private List<LineData> lineDatas;
        List<List<int>> hitList;

        private int onceWinGold;
        private int allWinGold;

        bool iscbRerun;
        int twNum = 0;

        private List<GameObject> gameL = new List<GameObject>();



        protected override void Start()
        {
            base.Start();

            lines = new List<List<Transform>>();
            lineDatas = new List<LineData>();
            hitList = new List<List<int>>(5);
            for (int i = 0; i < 5; i++)
            {
                List<int> list = new List<int>();
                for (int j = 0; j < 6; j++)
                {
                    list.Add(1);
                }
                hitList.Add(list);
            }
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
            MJHL_Event.ShowLine += MJHL_Event_ShowLine;
            MJHL_Event.StartRoll += MJHL_Event_StartRoll;
        }

        protected override void RemoveEvent()
        {
            MJHL_Event.ShowLine -= MJHL_Event_ShowLine;
            MJHL_Event.StartRoll -= MJHL_Event_StartRoll;
        }
        private void MJHL_Event_ShowLine()
        {
            if (MJHLEntry.Instance.GameData.ResultData.nWinGold <= 0) return;
            hsm?.ChangeState(nameof(ReceiveResultState));
        }
        private void MJHL_Event_StartRoll()
        {
            hsm?.ChangeState(nameof(CloseEffectState));
        }

        protected override void FindComponent()
        {
            RollContent = MJHLEntry.Instance.mainContent.Find("Content/RollContent"); //转动区域
            CSContent = MJHLEntry.Instance.mainContent.Find("Content/CSContent"); //特效区域
            icons = MJHLEntry.Instance.mainContent.FindChildDepth("Content/Icons"); //图标库

            for (int i = 0; i < CSContent.childCount; i++)
            {
                CSContent.GetChild(i).gameObject.SetActive(false);
            }
        }


        private void PlayRewardIcon(int index)
        {
            MJHL_Audio.Instance.PlaySound(MJHL_Audio.MJ_addgold);
            switch (index)
            {
                case 0:
                    MJHL_Audio.Instance.PlaySound(MJHL_Audio.MJ_0);
                    break;
                case 1:
                    MJHL_Audio.Instance.PlaySound(MJHL_Audio.MJ_1);
                    break;
                case 2:
                    MJHL_Audio.Instance.PlaySound(MJHL_Audio.MJ_2);
                    break;
                case 3:
                    MJHL_Audio.Instance.PlaySound(MJHL_Audio.MJ_3);
                    break;
                case 4:
                    MJHL_Audio.Instance.PlaySound(MJHL_Audio.MJ_4);
                    break;
                case 5:
                    MJHL_Audio.Instance.PlaySound(MJHL_Audio.MJ_5);
                    break;
                case 6:
                    MJHL_Audio.Instance.PlaySound(MJHL_Audio.MJ_6);
                    break;
                case 7:
                    MJHL_Audio.Instance.PlaySound(MJHL_Audio.MJ_7);
                    break;
                case 8:
                    MJHL_Audio.Instance.PlaySound(MJHL_Audio.MJ_8);
                    break;
                default:
                    break;
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
            Transform go = MJHLEntry.Instance.effectPool.Find(effectName);
            if (go != null) return go.gameObject;

            go = MJHLEntry.Instance.effectList.Find(effectName);
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
            effect.transform.SetParent(MJHLEntry.Instance.effectPool);
            effect.SetActive(false);
        }


        private void ChangeResultIcon(int rollIndex)
        {
            if (rollIndex >= RollContent.GetChild(rollIndex).GetComponent<ScrollRect>().content.childCount) return;
            Transform iconParent = RollContent.GetChild(rollIndex).GetComponent<ScrollRect>().content;
            for (int i = 0; i < iconParent.childCount - 1; i++)
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
                    Transform changeIcon = icons.FindChildDepth(MJHL_DataConfig.IconTable[iconIndex]);
                    iconParent.GetChild(i + 1).GetChild(0).gameObject.SetActive(true);
                    iconParent.GetChild(i + 1).FindChildDepth("Item10").gameObject.SetActive(false);
                    iconParent.GetChild(i + 1).FindChildDepth("Item11").gameObject.SetActive(false);

                    iconParent.GetChild(i + 1).GetChild(0).FindChildDepth<Image>("Image").sprite = changeIcon.FindChildDepth<Image>("Image").sprite;
                    iconParent.GetChild(i + 1).GetChild(0).FindChildDepth("Image").GetComponent<Image>().SetNativeSize();
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
                }
                if (i != iconParent.childCount)
                {
                    iconParent.GetChild(i + 1).gameObject.name = MJHL_DataConfig.IconTable[iconIndex];
                }
            }
        }


        private class IdleState : State<MJHL_Line>
        {
            public IdleState(MJHL_Line owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
        }
        private class ReceiveResultState : State<MJHL_Line>
        {
            public ReceiveResultState(MJHL_Line owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            bool isComplete;
            public override void OnEnter()
            {
                base.OnEnter();
                isComplete = false;
                owner.lineDatas.Clear();
                owner.lines.Clear();
                MJHL_Struct.CMD_3D_SC_Result result = MJHLEntry.Instance.GameData.ResultData;

                for (int i = 0; i < result.tagIconInfo[MJHLEntry.Instance.GameData.Index].cbHitIcon.Count; i++)
                {
                    if (result.tagIconInfo[MJHLEntry.Instance.GameData.Index].cbHitIcon[i] > 0)
                    {
                        LineData data = new LineData();
                        data.Index = i;
                        if (result.tagIconInfo[MJHLEntry.Instance.GameData.Index].cbGoldIconInfo[i] > 0)
                        {
                            data.isGolden = true;
                        }
                        owner.lineDatas.Add(data);
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
        private class ShowSingleState : State<MJHL_Line>
        {
            public ShowSingleState(MJHL_Line owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
        private class ShowTotalState : State<MJHL_Line>
        {
            MJHL_Struct.CMD_3D_SC_Result result;
            enum AnimPlayState
            {
                Idle,
                Frame,
                Rotate,
                Destroy,
            }
            AnimPlayState playState;
            List<GameObject> gameList = new List<GameObject>();

            public ShowTotalState(MJHL_Line owner, HierarchicalStateMachine hsm) : base(owner, hsm)
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
                for (int i = 0; i < 5; i++)
                {
                    for (int j = 0; j < 6; j++)
                    {
                        owner.hitList[i][j] = 1;
                    }
                }

                result = MJHLEntry.Instance.GameData.ResultData;
                playState = AnimPlayState.Idle;
                for (int i = 0; i < result.tagIconInfo[MJHLEntry.Instance.GameData.Index].cbHitIcon.Count; i++)
                {
                    if (result.tagIconInfo[MJHLEntry.Instance.GameData.Index].cbHitIcon[i]>0)
                    {
                        int hitIndex = i;
                        int col = hitIndex / 5;
                        int raw = hitIndex % 5;
                        if (result.tagIconInfo[MJHLEntry.Instance.GameData.Index].cbGoldIconInfo[i]<=0)
                            owner.hitList[raw][col] = 0;
                        else
                            owner.hitList[raw][col] = 1;

                        Transform hitTrans = owner.RollContent.GetChild(raw).GetComponent<ScrollRect>().content.GetChild(col+1);
                        Transform icon = hitTrans.FindChildDepth("Icon");
                        if (icon.childCount <= 0 && result.tagIconInfo[MJHLEntry.Instance.GameData.Index].cbIcon[i] < 9)
                        {
                            string effectName = MJHL_DataConfig.IconTable[MJHLEntry.Instance.GameData.ResultData.tagIconInfo[MJHLEntry.Instance.GameData.Index].cbIcon[hitIndex]];
                            GameObject effectObj = owner.CreatHitEffect(effectName);
                            effectObj.name = effectName;
                            effectObj.transform.SetParent(icon.transform);
                            effectObj.transform.localPosition = Vector3.zero;
                            effectObj.transform.localRotation = Quaternion.identity;
                            effectObj.transform.localScale = Vector3.one;
                            if (result.tagIconInfo[MJHLEntry.Instance.GameData.Index].cbGoldIconInfo[i]>0)
                            {
                                effectObj.transform.FindChildDepth("BG/BG").gameObject.SetActive(false);
                                effectObj.transform.FindChildDepth("BG/BG_yellow").gameObject.SetActive(true);
                            }
                            else
                            {
                                effectObj.transform.FindChildDepth("BG/BG").gameObject.SetActive(true);
                                effectObj.transform.FindChildDepth("BG/BG_yellow").gameObject.SetActive(false);
                            }
                            PlayeStateControl(effectObj, playState);

                            effectObj.SetActive(true);
                            hitTrans.transform.GetChild(0).gameObject.SetActive(false);
                            hitTrans.transform.FindChildDepth("Item10").gameObject.SetActive(false);
                            gameList.Add(effectObj);

                        }
                        else
                        {
                            string effectName = MJHL_DataConfig.IconTable[MJHLEntry.Instance.GameData.ResultData.tagIconInfo[MJHLEntry.Instance.GameData.Index].cbIcon[hitIndex]];
                            GameObject effectObj = owner.CreatHitEffect(effectName);
                            effectObj.name = effectName;
                            effectObj.transform.SetParent(icon.transform);
                            effectObj.transform.localPosition = Vector3.zero;
                            effectObj.transform.localRotation = Quaternion.identity;
                            effectObj.transform.localScale = Vector3.one;
                            effectObj.SetActive(true);
                            hitTrans.transform.GetChild(0).gameObject.SetActive(false);
                            hitTrans.transform.FindChildDepth("Item10").gameObject.SetActive(false);
                            gameList.Add(effectObj);
                        }
                    }
                }
                if (result.cbTurn > MJHLEntry.Instance.GameData.Index)
                    BeginPlay_Anim();
                else
                    MJHL_Event.DispatchRollComplete();
            }

            private void BeginPlay_Anim()
            {
                ToolHelper.DelayRun(0.2f).OnComplete(delegate () 
                {
                    for (int i = MJHLEntry.Instance.GameData.ResultData.tagIconInfo[MJHLEntry.Instance.GameData.Index].cbIcon.Count-1; i >=0 ; i--)
                    {
                        if (MJHLEntry.Instance.GameData.ResultData.tagIconInfo[MJHLEntry.Instance.GameData.Index].cbHitIcon[i]>0)
                        {
                            owner.PlayRewardIcon(MJHLEntry.Instance.GameData.ResultData.tagIconInfo[MJHLEntry.Instance.GameData.Index].cbIcon[i]);
                            break;
                        }
                    }
                    if (MJHLEntry.Instance.GameData.CurrentChip * MJHLEntry.Instance.GameData.ResultData.tagIconInfo[MJHLEntry.Instance.GameData.Index].odd>0)
                    {
                        owner.onceWinGold = MJHLEntry.Instance.GameData.CurrentChip * MJHLEntry.Instance.GameData.ResultData.tagIconInfo[MJHLEntry.Instance.GameData.Index].odd;
                        MJHL_Event.DispatchIOnceWinGold(owner.onceWinGold);
                        owner.allWinGold += owner.onceWinGold;
                        MJHL_Event.DispatchIAllWinGold(owner.allWinGold);
                    }
                    playState = AnimPlayState.Frame;
                    for (int i = 0; i < gameList.Count; i++)
                    {
                        PlayeStateControl(gameList[i], playState, owner.lineDatas[i]);
                    }
                    ToolHelper.DelayRun(0.9f).OnComplete(delegate ()
                    {
                        playState = AnimPlayState.Rotate;
                        for (int i = 0; i < gameList.Count; i++)
                        {
                            PlayeStateControl(gameList[i], playState, owner.lineDatas[i]);
                        }
                        ToolHelper.DelayRun(0.9f).OnComplete(delegate ()
                        {
                            playState = AnimPlayState.Destroy;
                            for (int i = 0; i < gameList.Count; i++)
                            {
                                PlayeStateControl(gameList[i], playState, owner.lineDatas[i]);
                            }
                            ToolHelper.DelayRun(0.9f).OnComplete(delegate ()
                            {
                                playState = AnimPlayState.Idle;
                                for (int i = 0; i < gameList.Count; i++)
                                {
                                    if (owner.lineDatas[i].isGolden)
                                    {
                                        gameList[i].transform.parent.parent.FindChildDepth("Item10").gameObject.SetActive(true);
                                    }
                                    else
                                    {
                                        PlayeStateControl(gameList[i], playState);
                                    }
                                }
                                MovePos();
                            });
                        });
                    });
                });
            }

            private void PlayeStateControl(GameObject go, AnimPlayState staIndex, LineData data = null)
            {
                switch (staIndex)
                {
                    case AnimPlayState.Idle:
                        go.transform.FindChildDepth("Frame").gameObject.SetActive(false);
                        go.transform.FindChildDepth("BG").gameObject.SetActive(true);
                        go.transform.FindChildDepth("Rot").gameObject.SetActive(false);
                        go.transform.FindChildDepth("Destroy").gameObject.SetActive(false);
                        break;
                    case AnimPlayState.Frame:
                        go.transform.FindChildDepth("Frame").gameObject.SetActive(true);
                        go.transform.FindChildDepth("BG").gameObject.SetActive(true);
                        go.transform.FindChildDepth("Rot").gameObject.SetActive(false);
                        go.transform.FindChildDepth("Destroy").gameObject.SetActive(false);
                        break;
                    case AnimPlayState.Rotate:
                        go.transform.FindChildDepth("Frame").gameObject.SetActive(false);
                        go.transform.FindChildDepth("BG").gameObject.SetActive(false);
                        go.transform.FindChildDepth("Rot").gameObject.SetActive(true);
                        go.transform.FindChildDepth("Destroy").gameObject.SetActive(false);
                        if (go.name== "Item10")
                        {
                            go.transform.FindChildDepth("Rot/icon/Image1").gameObject.SetActive(false);
                        }
                        if (data.isGolden)
                        {
                            go.transform.FindChildDepth("Rot/BG").gameObject.SetActive(false);
                            go.transform.FindChildDepth("Rot/icon").gameObject.SetActive(false);
                            go.transform.FindChildDepth("Rot/BG_yellow").gameObject.SetActive(true);
                        }
                        else
                        {
                            go.transform.FindChildDepth("Rot/BG").gameObject.SetActive(true);
                            go.transform.FindChildDepth("Rot/icon").gameObject.SetActive(true);
                            go.transform.FindChildDepth("Rot/BG_yellow").gameObject.SetActive(false);
                        }
                        break;
                    case AnimPlayState.Destroy:
                        go.transform.FindChildDepth("Frame").gameObject.SetActive(false);
                        go.transform.FindChildDepth("BG").gameObject.SetActive(false);
                        go.transform.FindChildDepth("Rot").gameObject.SetActive(false);
                        go.transform.FindChildDepth("Rot/BG").gameObject.SetActive(true);
                        go.transform.FindChildDepth("Rot/BG_yellow").gameObject.SetActive(false);
                        if (go.name == "Item10")
                        {
                            go.transform.FindChildDepth("Rot/icon/Image1").gameObject.SetActive(true);
                        }
                        if (!data.isGolden)
                        {
                            go.transform.FindChildDepth("Destroy").gameObject.SetActive(true);
                        }

                        break;
                    default:
                        break;
                }
            }

            private void MovePos()
            {
                for (int i = 0; i < owner.hitList.Count; i++)
                {
                    for (int j = owner.hitList[i].Count-1; j >=0; j--)
                    {
                        if (owner.hitList[i][j]>0)
                        {
                            if (owner.hitList[i][owner.hitList[i].Count - 1] == 0 && j < 5)
                            {
                                owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content.GetChild(j + 1).DOLocalMove(MJHL_DataConfig.moveList[6],MJHL_DataConfig.ImageDownShowTime);
                                owner.hitList[i][owner.hitList[i].Count - 1] = 1;
                                owner.hitList[i][j] = 0;
                                owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content.GetChild(j + 1).SetAsLastSibling();
                            }
                            else if (owner.hitList[i][owner.hitList[i].Count - 2] == 0 && j < 4)
                            {
                                owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content.GetChild(j + 1).DOLocalMove(MJHL_DataConfig.moveList[5], MJHL_DataConfig.ImageDownShowTime);
                                owner.hitList[i][owner.hitList[i].Count - 2] = 1;
                                owner.hitList[i][j] = 0;
                                owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content.GetChild(j + 1).SetSiblingIndex(owner.hitList[i].Count - 2);
                            }
                            else if (owner.hitList[i][owner.hitList[i].Count - 3] == 0 && j < 3)
                            {
                                owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content.GetChild(j + 1).DOLocalMove(MJHL_DataConfig.moveList[4], MJHL_DataConfig.ImageDownShowTime);
                                owner.hitList[i][owner.hitList[i].Count - 3] = 1;
                                owner.hitList[i][j] = 0;
                                owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content.GetChild(j + 1).SetSiblingIndex(owner.hitList[i].Count - 3);
                            }
                            else if (owner.hitList[i][owner.hitList[i].Count - 4] == 0 && j < 2)
                            {
                                owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content.GetChild(j + 1).DOLocalMove(MJHL_DataConfig.moveList[3], MJHL_DataConfig.ImageDownShowTime);
                                owner.hitList[i][owner.hitList[i].Count - 4] = 1;
                                owner.hitList[i][j] = 0;
                                owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content.GetChild(j + 1).SetSiblingIndex(owner.hitList[i].Count - 4);
                            }
                            else if (owner.hitList[i][owner.hitList[i].Count - 5] == 0 && j < 1)
                            {
                                owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content.GetChild(j + 1).DOLocalMove(MJHL_DataConfig.moveList[2], MJHL_DataConfig.ImageDownShowTime);
                                owner.hitList[i][owner.hitList[i].Count - 5] = 1;
                                owner.hitList[i][j] = 0;
                                owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content.GetChild(j + 1).SetSiblingIndex(owner.hitList[i].Count - 5);
                            }
                            else if (owner.hitList[i][owner.hitList[i].Count - 6] == 0 && j < 1)
                            {
                            }
                        }
                        else
                        {
                            owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content.GetChild(j + 1).localPosition = MJHL_DataConfig.moveList[0];
                        }
                    }
                }

                MJHLEntry.Instance.GameData.Index++;
                if (MJHLEntry.Instance.GameData.ResultData.cbTurn>= MJHLEntry.Instance.GameData.Index)
                {
                    ToolHelper.DelayRun(0.5f).OnComplete(delegate ()
                    {
                        for (int i = 0; i < 5; i++)
                        {
                            for (int j = 0; j < 6; j++)
                            {
                                if (owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content.GetChild(j + 1).localPosition == MJHL_DataConfig.moveList[0])
                                {
                                    owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content.GetChild(j + 1).SetAsFirstSibling();
                                }
                            }
                        }

                        for (int i = 0; i < owner.RollContent.childCount; i++)
                        {
                            Transform tran = owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content;
                            for (int j = 0; j < tran.childCount; j++)
                            {
                                Transform img = tran.GetChild(j).FindChildDepth("Icon");
                                if (img.transform.childCount > 0)
                                {
                                    owner.CollectEffect(img.transform.GetChild(0).gameObject);
                                }
                            }
                        }

                        for (int i = 0; i < 5; i++)
                        {
                            owner.ChangeResultIcon(i);
                        }

                        for (int i = 0; i < owner.hitList.Count; i++)
                        {
                            for (int j = owner.hitList[i].Count - 1; j >= 0; j--)
                            {
                                if (owner.hitList[i][j] == 0)
                                {
                                    owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content.GetChild(j + 1).DOLocalMove(MJHL_DataConfig.moveList[j + 1], MJHL_DataConfig.ImageDownShowTime);
                                    owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content.GetChild(j + 1).SetSiblingIndex(j + 1);
                                    owner.hitList[i][j] = 1;
                                }
                            }
                        }
                        MJHL_Event.DispatchPLAY_Multiple();
                        ToolHelper.DelayRun(0.5f).OnComplete(delegate ()
                        {
                            MJHL_Event.DispatchShowLine();
                        });
                    });
                }
                else
                {
                    ToolHelper.DelayRun(0.5f).OnComplete(delegate ()
                    {
                        MJHL_Event.DispatchShowLine();
                    });
                }

            }

            public override void Update()
            {
                base.Update();
            }
        }


        /// <summary>
        /// 关闭所有icon动画
        /// </summary>
        private class CloseEffectState : State<MJHL_Line>
        {
            public CloseEffectState(MJHL_Line owner, HierarchicalStateMachine hsm) : base(owner, hsm)
            {
            }
            bool isComplete;
            public override void OnEnter()
            {
                base.OnEnter();
                isComplete = false;
                owner.allWinGold = 0;
                for (int i = 0; i < owner.RollContent.childCount; i++)
                {
                    Transform tran = owner.RollContent.GetChild(i).GetComponent<ScrollRect>().content;
                    for (int j = 0; j < tran.childCount; j++)
                    {
                        Transform img = tran.GetChild(j).FindChildDepth("Icon");
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

                if (MJHLEntry.Instance.GameData.ResultData.cbTurn > 0)
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
