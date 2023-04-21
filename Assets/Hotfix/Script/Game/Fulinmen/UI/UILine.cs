using System;
using System.Collections.Generic;
using Spine.Unity;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.Fulinmen
{
    public class UILine : MonoBehaviour
    {
        public static UILine Add(GameObject go)
        {
            UILine ui = go.CreateOrGetComponent<UILine>();
            ui.Init();
            return ui;
        }

        private List<int> _showTable = new List<int>(); //显示连线索引列表
        private List<int> _showCount = new List<int>(); //显示元素个数列表
        private int _currentShow = -1; //当前显示索引
        private bool _isShow = false; //可以展示
        private float _showTime = 0; //展示时间
        private List<List<Transform>> _showItemTable = new List<List<Transform>>(); //展示元素列表

        private float _startShowTime = 0; //等待展示连线时间
        private bool _isWait = false;
        private Transform _effectList;
        private Transform _effectPool;
        private Transform _rollContent;

        private void Init()
        {
            _showTable.Clear();
            _showCount.Clear();
            _showItemTable.Clear();
            _currentShow = -1;
            _showTime = 0;
            _startShowTime = 0;
        }

        private void Awake()
        {
            var parent = transform.parent;
            _rollContent = parent.FindChildDepth("RollContent"); //转动区域
            HotfixMessageHelper.AddListener(Model.ShowResult, OnShowResult);
            HotfixMessageHelper.AddListener(Model.StartRoll, OnRoll);
        }

        private void OnDestroy()
        {
            HotfixMessageHelper.RemoveListener(Model.ShowResult, OnShowResult);
            HotfixMessageHelper.RemoveListener(Model.StartRoll, OnRoll);
            Close();
        }


        private void OnRoll(object data)
        {
            Close();
        }

        private void OnShowResult(object data)
        {
            Show();
        }

        private void Update()
        {
            StartShow();
        }

        private void StartShow()
        {
            if (_isWait)
            {
                _startShowTime += Time.deltaTime;
                if (_startShowTime >= Data.waitShowLineTime)
                {
                    this._startShowTime = 0;
                    this._isWait = false;
                    this.ShowAll();
                    this._isShow = true;
                }
            }

            if (!this._isShow) return;
            this._showTime += Time.deltaTime;
            if (this._currentShow < 0)
            {
                if (this._showTime < Data.lineAllShowTime) return;
                this._showTime = 0;
                if (this._showTable.Count == 1) return;
                this._currentShow += 1;
                if (this._currentShow >= this._showTable.Count) this._currentShow = 0;
                this.CloseAll();
                this.ShowSingle();
            }
            else
            {
                if (this._showTime < Data.cyclePlayLineTime) return;
                this._showTime = 0;
                this.CloseSingle();
                this._currentShow += 1;
                if (this._currentShow >= this._showTable.Count) this._currentShow = 0;
                this.ShowSingle();
            }
        }

        private void Show()
        {
            _showTable.Clear();
            _showCount.Clear();
            _showItemTable.Clear();
            _currentShow = 0;
            _showTime = 0;
            _startShowTime = 0;
            var lineData = Model.Instance.ResultInfo.LineTypeTable;
            for (int i = 0; i < lineData.Count; i++)
            {
                if (lineData[i][0] == 0) continue;
                int index = i;
                _showTable.Add(index);
                int count = 0;
                for (int j = 0; j < lineData[i].Count; j++)
                {
                    if (lineData[i][j] == 0) continue;
                    count++;
                }

                _showCount.Add(count);
            }

            _isWait = true;
        }

        private void Close()
        {
            _isWait = false;
            _isShow = false;
            CloseAll();
            for (int i = 0; i < _showItemTable.Count; i++)
            {
                for (int j = 0; j < _showItemTable[i].Count; j++)
                {
                    var icon = _showItemTable[i][j].FindChildDepth("Icon");
                    icon.GetComponent<Image>().enabled = true;
                    if (icon.childCount <= 1) continue;
                    Model.Instance.CollectEffect(icon.FindChildDepth("Effect").gameObject);
                }
            }

            _showTable.Clear();
            _showCount.Clear();
        }

        private void ShowAll()
        {
            //显示总连线
            bool isPlayerBoy = false;
            bool isPlayerlone = false;

            for (int i = 0; i < _showTable.Count; i++)
            {
                transform.GetChild(_showTable[i]).gameObject.SetActive(true);
                var showlist = Data.Line[_showTable[i]]; //这是单条线对应位置
                List<Transform> tempTable = new List<Transform>(); //每组展示的元素集合
                for (int j = 0; j < _showCount[i]; j++)
                {
                    int index = showlist[j];
                    byte elem = Model.Instance.ResultInfo.ImgTable[index];
                    int column = index / 5;
                    int raw = index % 5;
                    Transform child = _rollContent.transform.GetChild(raw).GetComponent<ScrollRect>().content
                        .GetChild(column);
                    Transform icon = child.FindChildDepth("Icon");
                    if (icon.FindChildDepth("Effect") == null && elem != 11)
                    {
                        GameObject go = Model.Instance.CreateEffect(Data.EffectTable[elem]);
                        go.transform.SetParent(child.FindChildDepth("Icon"));
                        go.transform.localPosition = Vector3.zero;
                        go.transform.localRotation = Quaternion.identity;
                        go.transform.localScale = Vector3.one;
                        go.gameObject.SetActive(true);
                        go.name = Data.EffectTable[elem];
                        go.GetComponent<SkeletonGraphic>().AnimationState.SetAnimation(0, "animation", true);
                        if (elem == 6 || elem == 7)
                        {
                            isPlayerBoy = true;
                        }
                        else if (elem == 8)
                        {
                            isPlayerlone = true;
                        }

                        go.gameObject.name = "Effect";
                        icon.GetComponent<Image>().enabled = false;
                    }

                    tempTable.Add(child);
                }

                _showItemTable.Add(tempTable);
            }

            if (isPlayerBoy)
            {
                Model.Instance.PlaySound(Model.Sound.BoyLaugh);
            }
            else if (isPlayerlone)
            {
                Model.Instance.PlaySound(Model.Sound.Lion);
            }
        }

        private void CloseAll()
        {
            //关闭总显示
            for (int i = 0; i < _showTable.Count; i++)
            {
                transform.GetChild(_showTable[i]).gameObject.SetActive(false);
                for (int j = 0; j < _showItemTable[i].Count; j++)
                {
                    var icon = _showItemTable[i][j].Find("Icon");
                    icon.GetComponent<Image>().enabled = true;
                    if (icon.childCount <= 1) continue;
                    icon.Find("Effect").gameObject.SetActive(false);
                }
            }
        }

        private void ShowSingle()
        {
            //显示轮播
            if (_showTable.Count <= 0 || _showItemTable.Count <= 0) return;
            transform.GetChild(_showTable[_currentShow]).gameObject.SetActive(true);
            for (int i = 0; i < _showItemTable[_currentShow].Count; i++)
            {
                var icon = _showItemTable[_currentShow][i].Find("Icon");
                icon.GetComponent<Image>().enabled = false;
                if (icon.childCount <= 1) continue;
                icon.Find("Effect").gameObject.SetActive(true);
                icon.FindChildDepth<SkeletonGraphic>("Effect").AnimationState.SetAnimation(0, "animation", true);
            }
        }

        private void CloseSingle()
        {
            //关闭单个显示
            if (_showTable.Count <= 0 || _showItemTable.Count <= 0) return;
            transform.GetChild(_showTable[_currentShow]).gameObject.SetActive(false);
            for (int i = 0; i < _showItemTable[_currentShow].Count; i++)
            {
                var icon = _showItemTable[_currentShow][i].Find("Icon");
                icon.GetComponent<Image>().enabled = true;
                if (icon.childCount <= 1) continue;
                icon.Find("Effect").gameObject.SetActive(false);
            }
        }
    }
}