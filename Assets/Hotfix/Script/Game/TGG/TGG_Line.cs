
using DragonBones;
using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Transform = UnityEngine.Transform;

namespace Hotfix.TGG
{
    public class TGG_Line : ILHotfixEntity
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
        private int currentShow = 0;      //当前显示索引
        private bool isShow = false;       //可以展示
        private float showTime = 0;         //展示时间
        private List<List<Transform>> showItemTable;   //展示元素列表
        private List<List<Transform>> showItemTable1;   //展示元素列表
        private float StartShowTime = 0;     //等待展示连线时间
        private bool isWait = false;


        protected override void Awake()
        {
            base.Awake();
        }
        protected override void Start()
        {
            base.Start();
            showTable = new List<int>();
            showItemTable = new List<List<Transform>>();
            showItemTable1 = new List<List<Transform>>();
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            RemoveEvent();
        }

        protected override void AddEvent()
        {
            TGG_Event.ShowResult += TJZ_Event_ShowResult;
            TGG_Event.StartRoll += TJZ_Event_StartRoll;
            HotfixActionHelper.ReconnectGame += EventHelper_ReconnectGame;
        }

        protected override void RemoveEvent()
        {
            TGG_Event.ShowResult -= TJZ_Event_ShowResult;
            TGG_Event.StartRoll -= TJZ_Event_StartRoll;
            HotfixActionHelper.ReconnectGame -= EventHelper_ReconnectGame;
        }

        private void EventHelper_ReconnectGame()
        {
            
        }
        private void TJZ_Event_ShowResult()
        {
            if (TGGEntry.Instance.GameData.ResultData.WinScore <= 0) return;
            Show();
        }

        private void TJZ_Event_StartRoll()
        {
            Close();
        }

        protected override void FindComponent()
        {
            RollContent = TGGEntry.Instance.RollContent; //转动区域
            animContent = TGGEntry.Instance.Icons; //显示库
        }

        private void Show()
        {
            DebugHelper.Log("-----Show------");
            TGG_Audio.Instance.PlaySound(TGG_Audio.LINE);
            showTable.Clear();
            showItemTable.Clear();
            showItemTable1.Clear();
            currentShow = 0;
            showTime = 0;
            StartShowTime = 0;
            for (int i = 0; i < TGGEntry.Instance.GameData.ResultData.LineTypeTable.Count; i++)
            {
                if (TGGEntry.Instance.GameData.ResultData.LineTypeTable[i].cbIcon != 0)
                {
                    List<Transform> tempTable = new List<Transform>();
                    List<Transform> tempTable1 = new List<Transform>();
                    for (int j = 0; j < TGGEntry.Instance.GameData.ResultData.LineTypeTable[i].cbCount; j++)
                    {
                        Transform rollChild = TGGEntry.Instance.RollContent.GetChild(j).GetComponent<ScrollRect>().content;
                        for (int k = 0; k < rollChild.childCount; k++)
                        {
                            if (rollChild.GetChild(k).gameObject.name == TGG_DataConfig.IconTable[TGGEntry.Instance.GameData.ResultData.LineTypeTable[i].cbIcon] || rollChild.GetChild(k).gameObject.name == "Jump")
                            {
                                tempTable.Add(rollChild.GetChild(k));
                                tempTable1.Add(TGGEntry.Instance.CSGroup.GetChild(j).GetChild(k));
                            }
                        }
                    }
                    showItemTable.Add(tempTable);
                    showItemTable1.Add(tempTable1);
                    showTable.Add(TGGEntry.Instance.GameData.ResultData.LineTypeTable[i].cbIcon);
                }
            }
            isWait = true;
        }

        private void Close()
        {
            CloseAll();
            for (int i = 0; i < showItemTable1.Count; i++)
            {
                for (int j = 0; j < showItemTable1[i].Count; j++)
                {
                    if (showItemTable1[i][j].childCount > 0)
                    {
                        CollectEffect(showItemTable1[i][j].GetChild(0).gameObject);
                    }
                }
            }
            TGGEntry.Instance.CSGroup.gameObject.SetActive(false);
            showTable.Clear();
            isWait = false;
            isShow = false;
        }

        protected override void Update()
        {
            base.Update();
            if (isWait)
            {
                StartShowTime = StartShowTime + Time.deltaTime;
                if (StartShowTime >= TGG_DataConfig.waitShowLineTime)
                {
                    StartShowTime = 0;
                    isWait = false;
                    ShowAll();
                    //isShow = true;
                    TGGEntry.Instance.isRoll = false;
                }
            }

            if (isShow)
            {

                showTime = showTime + Time.deltaTime;
                if (currentShow == 0)
                {
                    if (showTime >= TGG_DataConfig.lineAllShowTime)
                    {
                        showTime = 0;
                        if (showTable.Count == 1)
                        {
                            return;
                        }
                        currentShow = currentShow + 1;
                        if (currentShow > showTable.Count)
                        {
                            currentShow = 1;
                        }
                        CloseAll();
                        ShowSingle();
                    }
                }
                else
                {
                    if (showTime >= TGG_DataConfig.cyclePlayLineTime)
                    {
                        showTime = 0;
                        CloseSingle();
                        currentShow = currentShow + 1;
                        if (currentShow > showTable.Count)
                        {
                            currentShow = 1;
                        }
                        ShowSingle();

                    }
                }
            }
        }

        private void ShowFree()
        {
            showTable.Clear();
            showItemTable.Clear();
            showItemTable1.Clear();
            List<Transform> tempTable = new List<Transform>();
            List<Transform> tempTable1 = new List<Transform>();
            for (int i = 0; i < TGGEntry.Instance.RollContent.childCount; i++)
            {
                Transform childRoll = TGGEntry.Instance.RollContent.GetChild(i).GetComponent<ScrollRect>().content;
                for (int j = 0; j < childRoll.childCount; j++)
                {
                    if (childRoll.GetChild(j - 1).gameObject.name == "Ball")
                    {
                        tempTable.Add(childRoll.GetChild(j - 1));
                        tempTable1.Add(TGGEntry.Instance.CSGroup.GetChild(i).GetChild(j));
                    }
                }
            }
            showItemTable.Add(tempTable);
            showItemTable1.Add(tempTable1);
            showTable.Add(9);
            ShowAll();
        }

        private void ShowAll()
        {
            for (int i = 0; i < showTable.Count; i++)
            {
                int index = showTable[i];
                int elem = index;

                for (int j = 0; j < showItemTable[i].Count; j++)
                {
                    Transform child = showItemTable[i][j];
                    Transform child1 = showItemTable1[i][j];
                    Transform icon = child.FindChildDepth("Icon");
                    if (child1.childCount <= 0)
                    {
                        GameObject go = CreateEffect(child.gameObject.name);
                        go.transform.SetParent(child1);
                        go.transform.localPosition = Vector3.zero;
                        go.transform.localRotation = Quaternion.identity;
                        go.transform.localScale = Vector3.one;
                        go.gameObject.SetActive(true);
                        go.name = child.gameObject.name;
                    }
                    icon.GetComponent<Image>().enabled = false;
                }
            }
            TGGEntry.Instance.CSGroup.gameObject.SetActive(true);
        }

        private void CloseAll()
        {
            for (int i = 0; i < showItemTable.Count; i++)
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
            effect.transform.SetParent(TGGEntry.Instance.effectPool);
            effect.SetActive(false);
        }

        /// <summary>
        /// 创建动画
        /// </summary>
        /// <param name="effectName">动画名</param>
        /// <returns></returns>
        private GameObject CreateEffect(string effectName)
        {
            Transform go = TGGEntry.Instance.effectPool.Find(effectName);
            if (go != null) return go.gameObject;

            go = TGGEntry.Instance.effectList.Find(effectName);
            GameObject _go = GameObject.Instantiate(go.gameObject);
            return _go;
        }

    }
}


