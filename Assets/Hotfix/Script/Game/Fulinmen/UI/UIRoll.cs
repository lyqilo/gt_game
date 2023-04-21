using System;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using DragonBones;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using Random = UnityEngine.Random;
using Transform = UnityEngine.Transform;

namespace Hotfix.Fulinmen
{
    public class UIRoll : MonoBehaviour
    {
        public static UIRoll Add(GameObject go)
        {
            return go.CreateOrGetComponent<UIRoll>();
        }

        private List<ScrollRect> rollList = new List<ScrollRect>();
        private int rollIndex = 0;
        private int StopIndex = 0;
        private int currentState = 0; //0:待机，1：正常转动,2:停止
        float timer = 0;
        float startTimer = 0;
        float stopTimer = 0;
        bool isstop = false;
        int scatterCount = 0;
        int addSpeedEffectIndex = 0;
        bool scatter = true;
        private List<int> stoplist = new List<int>();
        private Transform CSGroup;
        private Dictionary<string, Sprite> icons = new Dictionary<string, Sprite>();

        private void Awake()
        {
            var parent = transform.parent;
            CSGroup = parent.FindChildDepth("CSContent"); //显示特別效果
            var icon = parent.Find("Icons"); //图标库
            icons.Clear();
            for (int i = 0; i < icon.childCount; i++)
            {
                var child = icon.GetChild(i);
                icons.Add(child.gameObject.name, child.GetComponent<Image>().sprite);
            }

            //初始化转动
            for (int i = 0; i < transform.childCount; i++)
            {
                ScrollRect rect = transform.GetChild(i).GetComponent<ScrollRect>();
                RectTransform content = rect.content;
                GameObject temp1 = Instantiate(content.GetChild(0).GetChild(0).gameObject,
                    rect.content.GetChild(0), false);
                temp1.transform.localPosition = new Vector3(0, 162, 0);
                temp1.transform.localRotation = Quaternion.identity;
                temp1.transform.localScale = Vector3.one;
                temp1.gameObject.name = "Temp";
                GameObject temp2 = Instantiate(content.GetChild(0).GetChild(0).gameObject,
                    rect.content.GetChild(content.childCount - 1), false);
                temp2.transform.localPosition = new Vector3(0, -162, 0);
                temp2.transform.localRotation = Quaternion.identity;
                temp2.transform.localScale = Vector3.one;
                temp2.gameObject.name = "Temp";
                rect.verticalNormalizedPosition = 0;
                rect.elasticity = Data.rollReboundRate;
                rollList.Add(rect);
            }

            for (int i = 0; i < rollList.Count; i++)
            {
                ChangeIconRoll(i);
            }

            HotfixMessageHelper.AddListener(Model.StartRoll, OnStartRoll);
            HotfixMessageHelper.AddListener(Model.ForceStopRoll, OnForceStopRoll);
        }

        private void OnDestroy()
        {
            HotfixMessageHelper.RemoveListener(Model.StartRoll, OnStartRoll);
            HotfixMessageHelper.RemoveListener(Model.ForceStopRoll, OnForceStopRoll);
        }

        private void OnForceStopRoll(object data)
        {
            if (rollIndex == rollList.Count - 1) currentState = 2;
        }

        private void OnStartRoll(object data)
        {
            Model.Instance.PlaySound(Model.Sound.Turn);
            rollIndex = 0;
            StopIndex = 0;
            timer = Data.RollInterval;
            stopTimer = 0;
            startTimer = 0;
            currentState = 1;
            scatterCount = 0;
            scatter = true;
            isstop = false;
        }

        private void Update()
        {
            switch (currentState)
            {
                case 0:
                    //待机状态
                    return;
                case 1:
                {
                    //正常旋转
                    for (int i = 0; i < rollIndex; i++)
                    {
                        rollList[i].verticalNormalizedPosition += Time.deltaTime * Data.RollSpeed; //旋转
                        if (rollList[i].verticalNormalizedPosition < 1) continue;
                        rollList[i].verticalNormalizedPosition = 0;
                        ChangeIconRoll(i);
                    }

                    if (rollIndex < rollList.Count)
                    {
                        //计算转动间隔
                        timer += Time.deltaTime;
                        if (timer >= 0)
                        {
                            timer = 0;
                            rollIndex += 1;
                        }
                    }

                    if (startTimer <= Data.RollTime)
                    {
                        //计算旋转时间，时间到就停止
                        startTimer += Time.deltaTime;
                        if (startTimer >= Data.RollTime) currentState = 2;
                    }

                    break;
                }
                case 2:
                {
                    for (int i = 0; i < rollIndex; i++)
                    {
                        if (StopIndex > i) continue;
                        rollList[i].verticalNormalizedPosition += Time.deltaTime * Data.RollSpeed; //旋转
                        if (rollList[i].verticalNormalizedPosition < 1 || StopIndex >= i) continue;
                        rollList[i].verticalNormalizedPosition = 0;
                        ChangeIconRoll(i);
                    }

                    if (StopIndex < rollList.Count)
                    {
                        //计算转动间隔
                        stopTimer += Time.deltaTime;
                        if (stopTimer >= Data.RollInterval)
                        {
                            stopTimer = 0;
                            StopIndex += 1;
                            //TODO 换正式结果图片
                            int stopindex = StopIndex - 1;
                            ChangeResultIcon(stopindex);
                            rollList[stopindex].verticalNormalizedPosition = 0;
                            rollList[stopindex].content.DOLocalMove(
                                new Vector3(90, -Data.RollDistance - 50, 0),
                                0.1f).SetEase(DG.Tweening.Ease.Linear).OnComplete(() =>
                            {
                                float tempTimer = 0.2f;
                                rollList[stopindex].content.DOLocalMove(new Vector3(90, -50, 0), tempTimer).SetEase(DG
                                    .Tweening.Ease.Linear).OnComplete(() =>
                                {
                                    if (stopindex != rollList.Count - 1) return;
                                    currentState = 0;
                                    HotfixMessageHelper.PostHotfixEvent(Model.ShowResult);
                                });
                            });
                        }
                    }

                    break;
                }
            }
        }

        private void ChangeIconRoll(int index)
        {
            Transform iconParent = rollList[index].content;
            for (int i = 0; i < iconParent.childCount; i++)
            {
                int iconIndex = Random.Range(0, 10);
                icons.TryGetValue(Data.IconTable[iconIndex], out Sprite changeIcon);
                iconParent.GetChild(i).FindChildDepth<Image>("Icon").sprite = changeIcon;
                Transform tempIcon = iconParent.GetChild(i).Find("Temp");
                if (tempIcon != null)
                {
                    tempIcon.GetComponent<Image>().sprite = changeIcon;
                    tempIcon.GetComponent<Image>().SetNativeSize();
                }

                iconParent.GetChild(i).FindChildDepth<Image>("Icon").SetNativeSize();
                iconParent.GetChild(i).FindChildDepth<TextMeshProUGUI>("Icon/Num").text = "";
            }
        }

        private void ChangeResultIcon(int index)
        {
            if (index >= rollList.Count) return;

            Transform iconParent = rollList[index].content;
            for (int i = 0; i < iconParent.childCount; i++)
            {
                Image img = iconParent.GetChild(i).FindChildDepth<Image>("Icon");
                img.enabled = true;
                int iconIndex = 1;
                iconIndex = i == iconParent.childCount - 1
                    ? Random.Range(1, 10)
                    : Model.Instance.ResultInfo.ImgTable[i * 5 + index];
                icons.TryGetValue(Data.IconTable[iconIndex], out Sprite changeIcon);
                img.sprite = changeIcon;
                img.SetNativeSize();
                if (iconIndex == 11)
                {
                    TextMeshProUGUI num = img.transform.FindChildDepth<TextMeshProUGUI>("Num");
                    num.gameObject.SetActive(true);
                    num.transform.SetParent(img.transform);
                    num.transform.localPosition = new Vector3(10, 5, 0);
                    num.transform.localScale = Vector3.one;
                    num.gameObject.name = "Num";
                    int shownum = Model.Instance.ResultInfo.GoldNum[i * 5 + index];
                    num.text = shownum switch
                    {
                        0 => "",
                        1 => "d".ShowRichText(),
                        2 => "x".ShowRichText(),
                        _ => Model.Instance.ResultInfo.GoldNum[i * 5 + index].ShortNumber().ShowRichText()
                    };
                }

                Transform tempIcon = iconParent.GetChild(i).Find("Temp");
                if (tempIcon == null) continue;
                iconIndex = Random.Range(1, 10);
                icons.TryGetValue(Data.IconTable[iconIndex], out changeIcon);
                tempIcon.GetComponent<Image>().sprite = changeIcon;
                tempIcon.GetComponent<Image>().SetNativeSize();
            }
        }
    }
}