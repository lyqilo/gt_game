using System;
using System.Collections.Generic;
using DragonBones;
using UnityEngine;
using UnityEngine.UI;
using Transform = UnityEngine.Transform;

namespace Hotfix.BQTP
{
    public class UILine : MonoBehaviour
    {
        private Transform effectList;
        private Transform effectPool;
        private List<int> showTable = new List<int>(); //显示连线索引列表
        private Transform RollContent;

        public static UILine Add(GameObject go)
        {
            return go.CreateOrGetComponent<UILine>();
        }

        private void Awake()
        {
            effectList = transform.FindChildDepth("EffectList"); //动画库
            effectPool = transform.FindChildDepth("EffectPool"); //动画缓存库
            RollContent = transform.FindChildDepth("RollContent");

            HotfixMessageHelper.AddListener(Model.ShowResult, OnShowResult);
        }

        private void OnDestroy()
        {
            HotfixMessageHelper.RemoveListener(Model.ShowResult, OnShowResult);
        }

        private void OnShowResult(object data)
        {
            if (Model.Instance.ResultInfo.WinScore <= 0) return;
            showTable.Clear();
            for (int i = 0; i < Model.Instance.ResultInfo.LineTypeTable.Count; i++)
            {
                if (Model.Instance.ResultInfo.LineTypeTable[i] == 0) continue;
                showTable.Add(i);
            }
            ShowEffect();
        }

        private void ShowEffect()
        {
            for (int i = 0; i < showTable.Count; i++)
            {
                int index = showTable[i];
                int elem = Model.Instance.ResultInfo.ImgTable[index];
                int cloumn = index % 5;
                int raw = 2 - index / 5;
                GameObject eff = CreateEffect(Data.EffectTable[elem]);
                if (eff == null) continue;
                Image icon = RollContent.GetChild(cloumn).GetComponent<ScrollRect>()
                    .content.GetChild(raw).FindChildDepth<Image>("Icon");
                eff.transform.SetParent(icon.transform);
                eff.transform.localPosition = Vector3.zero;
                eff.transform.localScale = Vector3.one;
                eff.gameObject.SetActive(true);
                icon.enabled = false;
                UnityArmatureComponent anim = eff.transform.FindChildDepth<UnityArmatureComponent>("Sprite");
                anim.dbAnimation.Play("Sprite", 1);
                StartCoroutine(ToolHelper.DelayCall(2, () =>
                {
                    if (Model.Instance.ReRollCount > 0)
                    {
                        GameObject iceBreak = CreateEffect("XC");
                        iceBreak.transform.SetParent(icon.transform);
                        iceBreak.transform.localPosition = Vector3.zero;
                        iceBreak.transform.localScale = Vector3.one;
                        iceBreak.gameObject.SetActive(true);
                        StartCoroutine(ToolHelper.DelayCall(0.5f, () =>
                        {
                            CollectEffect(eff.gameObject);
                        }));
                        Model.Instance.PlaySound(Model.Sound.Smathing_Break);
                        anim = iceBreak.transform.FindChildDepth<UnityArmatureComponent>("Sprite");
                        anim.dbAnimation.Play("Sprite", 1);
                        StartCoroutine(ToolHelper.DelayCall(0.8f, () =>
                        {
                            CollectEffect(iceBreak.gameObject);
                            var parent = icon.transform.parent;
                            parent.SetSiblingIndex(2);
                            Vector3 pos = parent.localPosition;
                            parent.localPosition = new Vector3(pos.x, Data.ItemPosList[3], pos.z);
                        }));
                    }
                    else
                    {
                        CollectEffect(eff.gameObject);
                        icon.enabled = true;
                    }
                }));
            }

            if (Model.Instance.ReRollCount > 0)
            {
                StartCoroutine(ToolHelper.DelayCall(3, () =>
                {
                    //TODO 移动 重转
                    HotfixMessageHelper.PostHotfixEvent(Model.MoveThreeRaw);
                }));
            }
        }

        private void CollectEffect(GameObject obj)
        {
            //回收动画
            if (obj == null) return;

            obj.transform.SetParent(effectPool);
            obj.SetActive(false);
        }

        private GameObject CreateEffect(string effectname)
        {
            //创建动画，先从对象池中获取
            Transform go = effectPool.FindChildDepth(effectname);
            if (go != null) return go.gameObject;

            go = effectList.FindChildDepth(effectname);
            GameObject _go = Instantiate(go.gameObject);
            return _go;
        }
    }
}