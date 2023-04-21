
using DG.Tweening;
using DragonBones;
using System;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using Object = UnityEngine.Object;
using Transform = UnityEngine.Transform;

namespace Hotfix.YGBH
{
    public class YGBH_Line : ILHotfixEntity
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

        private List<int> showTable;//显示连线索引列表
        private List<int> showCount;//显示元素个数列表
        private int currentShow = 0;      //当前显示索引
        private bool isShow = false;       //可以展示
        private float showTime = 0;         //展示时间
        private List<List<Transform>> showItemTable;   //展示元素列表
        private float StartShowTime = 0;     //等待展示连线时间
        private bool isWait = false;



        private List<List<Transform>> showItemTable1;   //展示元素列表

        protected override void Start()
        {
            base.Start();
            showTable = new List<int>();
            showItemTable = new List<List<Transform>>();
            showCount = new List<int>();

            showItemTable1 = new List<List<Transform>>();
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            RemoveEvent();
        }

        protected override void AddEvent()
        {
            YGBH_Event.ShowResult += YGBH_Event_ShowResult;
            YGBH_Event.StartRoll += YGBH_Event_StartRoll;
            YGBH_Event.ShowLine += Show;
            HotfixActionHelper.ReconnectGame += EventHelper_ReconnectGame;
            
        }

        protected override void RemoveEvent()
        {
            YGBH_Event.ShowResult -= YGBH_Event_ShowResult;
            YGBH_Event.StartRoll -= YGBH_Event_StartRoll;
            YGBH_Event.ShowLine -= Show;
            HotfixActionHelper.ReconnectGame -= EventHelper_ReconnectGame;
        }

        private void EventHelper_ReconnectGame()
        {
            
        }
        private void YGBH_Event_ShowResult()
        {
            if (YGBHEntry.Instance.GameData.ResultData.WinScore <= 0) return;
            //Show();
        }

        private void YGBH_Event_StartRoll()
        {
            Close();
        }

        protected override void FindComponent()
        {
            RollContent = YGBHEntry.Instance.RollContent; //转动区域
            animContent = YGBHEntry.Instance.Icons; //显示库
        }

        public void Show()
        {
            DebugHelper.Log("-----Show------");
            //YGBH_Audio.Instance.PlaySound(YGBH_Audio.LINE);
            showTable.Clear();
            showItemTable.Clear();
            showCount.Clear();
            showItemTable1.Clear();
            currentShow = 0;
            showTime = 0;
            StartShowTime = 0;
            for (int i = 0; i < YGBHEntry.Instance.GameData.ResultData.LineTypeTable.Count; i++)
            {
                if (YGBHEntry.Instance.GameData.ResultData.LineTypeTable[i][0] == 0) continue;
                showTable.Add(i);
                int count = 0;

                for (int j = 0; j < YGBHEntry.Instance.GameData.ResultData.LineTypeTable[i].Count; j++)
                {
                    if (YGBHEntry.Instance.GameData.ResultData.LineTypeTable[i][j] != 0)
                    {
                        count += 1;
                    }
                }
                showCount.Add(count);
            }
            YGBHEntry.Instance.WinDesc.text = $"X{showCount.Count}lines";
            isWait = true;
        }

        private void Close()
        {
            CloseAll();
            for (int i = 0; i < showItemTable.Count; i++)
            {
                for (int j = 0; j < showItemTable[i].Count; j++)
                {
                    showItemTable[i][j].FindChildDepth("Icon").GetComponent<Image>().enabled = true;
                    if (showItemTable[i][j].FindChildDepth("Icon").childCount>0)
                    {
                        CollectEffect(showItemTable[i][j].FindChildDepth("Icon").GetChild(0).gameObject);
                    }
                }
            }

            for (int i = 0; i < YGBHEntry.Instance.scatterList.Count; i++)
            {
                YGBHEntry.Instance.scatterList[i].GetComponent<Image>().enabled = true;
                if (YGBHEntry.Instance.scatterList[i].childCount>0)
                {
                    CollectEffect(YGBHEntry.Instance.scatterList[i].GetChild(0).gameObject);
                }
            }

            //YGBHEntry.Instance.CSGroup.gameObject.SetActive(false);
            showTable.Clear();
            showCount.Clear();
            isWait = false;
            isShow = false;
        }

        protected override void Update()
        {
            base.Update();
            if (isWait)
            {
                StartShowTime += Time.deltaTime;
                if (StartShowTime >= YGBH_DataConfig.waitShowLineTime)
                {
                    StartShowTime = 0;
                    isWait = false;
                    ShowAll();
                    //isShow = true;
                    //YGBHEntry.Instance.isRoll = false;
                }
            }

            if (!isShow) return;
            showTime += Time.deltaTime;
            if (currentShow == 0)
            {
                if (!(showTime >= YGBH_DataConfig.lineAllShowTime)) return;
                showTime = 0;
                if (showTable.Count == 1)
                {
                    return;
                }
                currentShow += 1;
                if (currentShow > showTable.Count)
                {
                    currentShow = 1;
                }
                CloseAll();
                ShowSingle();
            }
            else
            {
                if (!(showTime >= YGBH_DataConfig.cyclePlayLineTime)) return;
                showTime = 0;
                CloseSingle();
                currentShow += 1;
                if (currentShow > showTable.Count)
                {
                    currentShow = 1;
                }
                ShowSingle();
            }
        }

        private void ShowFree()
        {
            showTable.Clear();
            showItemTable.Clear();
            showItemTable1.Clear();
            List<Transform> tempTable = new List<Transform>();
            List<Transform> tempTable1 = new List<Transform>();
            for (int i = 0; i < YGBHEntry.Instance.RollContent.childCount; i++)
            {
                Transform childRoll = YGBHEntry.Instance.RollContent.GetChild(i).GetComponent<ScrollRect>().content;
                for (int j = 0; j < childRoll.childCount; j++)
                {
                    if (childRoll.GetChild(j - 1).gameObject.name != "Ball") continue;
                    tempTable.Add(childRoll.GetChild(j - 1));
                    tempTable1.Add(YGBHEntry.Instance.CSGroup.GetChild(i).GetChild(j));
                }
            }
            showItemTable.Add(tempTable);
            showItemTable1.Add(tempTable1);
            showTable.Add(9);
            ShowAll();
        }

        private void ShowAll()
        {
            List<int> spPosList = new List<int>();
            for (int i = 0; i < showTable.Count; i++)
            {
                List<int> showlist = YGBH_DataConfig.Line[showTable[i]];//这是单条线对应位置
                List<Transform> tempTable=new List<Transform>(); //每组展示的元素集合
                for (int j = 0; j < showCount[i]; j++)
                {
                    int index = showlist[j]-1;
                    byte elem = YGBHEntry.Instance.GameData.ResultData.ImgTable[index];
                    int column =(int)Mathf.Ceil(index / 5);
                    int raw = (int)Mathf.Floor(index % 5);
                    //if (raw == 0)
                    //    raw = 5;

                    Transform child = YGBHEntry.Instance.RollContent.transform.GetChild(raw).GetComponent<ScrollRect>().content.GetChild(column);

                    if (YGBHEntry.Instance.GameData.hasNewSP)
                    {
                        spPosList.Add(index);
                    }
                    
                    Transform icon = child.FindChildDepth("Icon");
                    child.FindChildDepth("Icon").GetComponent<Image>().enabled = false;

                    if (icon.childCount <= 0)
                    {
                        GameObject go = CreateEffect(YGBH_DataConfig.EffectTable[elem]);
                        if (go!=null)
                        {
                            go.transform.SetParent(child.FindChildDepth("Icon"));
                            go.transform.localPosition = Vector3.zero;
                            go.transform.localRotation = Quaternion.identity;
                            go.transform.localScale = new Vector3(1.15f, 1.15f, 1.15f);
                            go.gameObject.SetActive(true);
                            go.name = child.gameObject.name;
                        }
                        else
                        {
                            child.FindChildDepth("Icon").GetComponent<Image>().enabled = true;
                        }
                    }
                    tempTable.Add(child);
                }
                showItemTable.Add(tempTable);
            }

            if (!YGBHEntry.Instance.GameData.hasNewSP) return;
            {
                int index = 0;
                for (int i = 0; i < spPosList.Count; i++)
                {
                    GameObject child = i >= YGBHEntry.Instance.dlLightGroup.childCount 
                        ? Object.Instantiate(YGBHEntry.Instance.dlLightGroup.GetChild(0).gameObject, YGBHEntry.Instance.dlLightGroup, false) 
                        : YGBHEntry.Instance.dlLightGroup.GetChild(i).gameObject;
                    child.transform.localScale = Vector3.one;
                    List<float> pos = YGBH_DataConfig.rollPoss[spPosList[i]];
                    child.transform.localPosition = new Vector3(pos[0], pos[1], pos[2]);
                    child.SetActive(true);
                    child.transform.DOLocalMove(new Vector3(0, -106, 0), 0.3f).OnComplete(() =>
                    {
                        child.transform.DOScale(new Vector3(3, 3, 3), 0.5f).OnComplete(() =>
                        {
                            if (index == 0)
                            {
                                index++;
                                YGBHEntry.Instance.smallSPRealCount = 0;
                                for (int j = 0; j < YGBHEntry.Instance.GameData.SceneData.smallGameTrack.Count; j++)
                                {
                                    if (YGBHEntry.Instance.GameData.SceneData.smallGameTrack[j] > 0)
                                    {
                                        YGBHEntry.Instance.smallSPRealCount += 1;
                                    }
                                }

                                for (int j = 0; j < YGBHEntry.Instance.smallSPCount; j++)
                                {
                                    YGBHEntry.Instance.dlBtn.transform.GetChild(j).gameObject.SetActive(true);
                                }

                                YGBHEntry.Instance.zpProgress.text = YGBHEntry.Instance.smallSPRealCount + "/6";
                                for (int j = 0; j < YGBHEntry.Instance.GameData.SceneData.smallGameTrack.Count; j++)
                                {
                                    if (YGBHEntry.Instance.GameData.SceneData.smallGameTrack[j] > 0)
                                    {
                                        YGBHEntry.Instance.maskGroup.GetChild(j).GetComponent<Image>().enabled = false;
                                        YGBHEntry.Instance.smallGoldGroup.GetChild(j).GetComponent<TextMeshProUGUI>().text = "" + YGBHEntry.Instance.GameData.SceneData.smallGameTrack[j].ShortNumber();
                                    }
                                    else
                                    {
                                        YGBHEntry.Instance.maskGroup.GetChild(j).GetComponent<Image>().enabled = true;
                                        YGBHEntry.Instance.smallGoldGroup.GetChild(j).GetComponent<TextMeshProUGUI>().text = "";
                                    }
                                }

                                if (YGBHEntry.Instance.smallSPCount >= 8)
                                {
                                    YGBHEntry.Instance.FullSP = true;//碎片集满了，开启小游戏

                                }
                            }
                            child.SetActive(false);
                        });
                    });
                }
                YGBHEntry.Instance.GameData.hasNewSP = false;
            }

        }

        private void CloseAll()
        {
            for (int i = 0; i < showTable.Count; i++)
            {
                for (int j = 0; j < showItemTable[i].Count; j++)
                {
                    Transform icon = showItemTable[i][j].FindChildDepth("Icon");
                    icon.GetComponent<Image>().enabled = true;
                    if (icon.childCount > 0)
                    {
                        icon.GetChild(0).gameObject.SetActive(false);
                    }
                }
            }
        }

        private void ShowSingle()
        {
            for (int i = 0; i < showItemTable[currentShow].Count; i++)
            {
                Transform icon = showItemTable[currentShow][i].FindChildDepth("Icon");
                icon.GetComponent<Image>().enabled = false;
                if (icon.childCount > 0)
                {
                    icon.GetChild(0).gameObject.SetActive(true);
                }
            }
        }

        private void CloseSingle()
        {
            for (int i = 0; i < showItemTable[currentShow].Count; i++)
            {
                Transform icon = showItemTable[currentShow][i].FindChildDepth("Icon");
                icon.GetComponent<Image>().enabled = true;
                if (icon.childCount > 0)
                {
                    icon.GetChild(0).gameObject.SetActive(false);
                }
            }
        }

        /// <summary>
        /// 回收特效动画
        /// </summary>
        /// <param name="effect">特效动画</param>
        private void CollectEffect(GameObject effect)
        {
            if (effect == null) return;
            effect.transform.SetParent(YGBHEntry.Instance.effectPool);
            effect.SetActive(false);
        }

        /// <summary>
        /// 创建动画
        /// </summary>
        /// <param name="effectName">动画名</param>
        /// <returns></returns>
        public static GameObject CreateEffect(string effectName)
        {
            Transform go = YGBHEntry.Instance.effectPool.Find(effectName);
            if (go != null) return go.gameObject;

            go = YGBHEntry.Instance.effectList.Find(effectName);
            GameObject _go = Object.Instantiate(go.gameObject);
            return _go;
        }
    }
}