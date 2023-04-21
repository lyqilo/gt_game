using System;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using DragonBones;
using UnityEngine;
using UnityEngine.UI;
using Random = UnityEngine.Random;
using Transform = UnityEngine.Transform;

namespace Hotfix.BQTP
{
    public class UIRoll : MonoBehaviour
    {
        public static UIRoll Get(GameObject go)
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
                var rect = transform.GetChild(i).GetComponent<ScrollRect>();
                rect.verticalNormalizedPosition = 0;
                rect.elasticity = Data.RollReboundRate;
                rollList.Add(rect);
            }

            for (int i = 0; i < rollList.Count; i++)
            {
                ChangeIconRoll(i);
            }

            HotfixMessageHelper.AddListener(Model.StartReRoll, OnStartReRoll);
            HotfixMessageHelper.AddListener(Model.StartRoll, OnStartRoll);
            HotfixMessageHelper.AddListener(Model.MoveThreeRaw, MoveThreeRaw);
        }

        private void OnDestroy()
        {
            HotfixMessageHelper.RemoveListener(Model.StartReRoll, OnStartReRoll);
            HotfixMessageHelper.RemoveListener(Model.StartRoll, OnStartRoll);
            HotfixMessageHelper.RemoveListener(Model.MoveThreeRaw, MoveThreeRaw);
        }

        private void OnStartRoll(object data)
        {
            Model.Instance.PlaySound(Model.Sound.Normal_ReelRun);
            rollIndex = 0;
            StopIndex = 0;
            timer = Data.RollInterval;
            stopTimer = 0;
            startTimer = 0;
            currentState = 1;
            scatterCount = 0;
            scatter = true;
            isstop = false;
            if (Model.Instance.ResultInfo.cbSpecialWild <= 0) return;
            int index = Random.Range(0, 2);
            Transform child = CSGroup.GetChild(Model.Instance.ResultInfo.cbSpecialWild - 1).GetChild(index);
            child.gameObject.SetActive(true);
            Model.Instance.PlaySound(Model.Sound.Wild);
            var anim = child.GetComponent<UnityArmatureComponent>();
            anim.AddDBEventListener(DragonBones.EventObject.COMPLETE,
                (type, eventobject) => { child.gameObject.SetActive(false); });
            anim.dbAnimation.Play("Sprite", 1);
        }

        private void MoveThreeRaw(object data)
        {
            for (int i = 0; i < 5; i++)
            {
                for (int j = 0; j < 3; j++)
                {
                    Transform child = rollList[i].content.GetChild(j).FindChildDepth("Icon");
                    if (!child.GetComponent<Image>().enabled) continue;
                    var y = Data.ItemPosList[j];
                    child.parent.DOLocalMove(new Vector3(0, y, 0), 0.2f).SetEase(DG.Tweening.Ease.Linear).OnComplete(
                        () => { StartCoroutine(PlayDropAudio());});
                }
            }

            StartCoroutine(ToolHelper.DelayCall(0.3f, () => { HotfixMessageHelper.PostHotfixEvent(Model.ReqReRoll); }));
        }

        private IEnumerator PlayDropAudio()
        {
            yield return new WaitForEndOfFrame();
            Model.Instance.PlaySound(Model.Sound.Normal_Drop);
        }

        private void OnStartReRoll(object data)
        {
            for (int i = 0; i < Data.Columncount; i++)
            {
                ChangeResultIcon(i);
                var content = rollList[i].content;
                for (int j = 0; j < content.childCount; j++)
                {
                    var y = Data.ItemPosList[j];
                    content.GetChild(j).DOLocalMove(new Vector3(0, y, 0), 0.2f).SetEase(DG.Tweening.Ease.Linear).OnComplete(() => { StartCoroutine(PlayDropAudio()); });
                }
            }

            StartCoroutine(ToolHelper.DelayCall(0.3f, () =>
            {
                Model.Instance.ClearAuido(Model.Sound.Normal_ReelRun.ToString());
                HotfixMessageHelper.PostHotfixEvent(Model.StopRoll);
            }));
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
                                new Vector3(90, -Data.RollDistance - 500, 0),
                                0.1f).SetEase(DG.Tweening.Ease.Linear).OnComplete(() =>
                            {
                                float tempTimer = 0.2f;
                                rollList[stopindex].content.DOLocalMove(new Vector3(90, -500, 0), tempTimer).SetEase(DG
                                    .Tweening.Ease.Linear).OnComplete(() =>
                                {
                                    Model.Instance.PlaySound(Model.Sound.Normal_ReelStop);
                                    if (stopindex != rollList.Count - 1) return;
                                    currentState = 0;
                                    Model.Instance.ClearAuido(Model.Sound.Normal_ReelRun.ToString());
                                    HotfixMessageHelper.PostHotfixEvent(Model.StopRoll);
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
                int iconIndex = Random.Range(0, 8);
                icons.TryGetValue(Data.IconTable[iconIndex], out Sprite changeIcon);
                iconParent.GetChild(i).FindChildDepth<Image>("Icon").sprite = changeIcon;
                Transform tempgroup = iconParent.GetChild(i).Find("TempGroup");
                if (tempgroup != null)
                {
                    for (int j = 0; j < tempgroup.childCount; j++)
                    {
                        Transform tempIcon = tempgroup.GetChild(j);
                        tempIcon.GetComponent<Image>().sprite = changeIcon;
                        tempIcon.GetComponent<Image>().SetNativeSize();
                    }
                }

                iconParent.GetChild(i).FindChildDepth<Image>("Icon").SetNativeSize();
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
                iconIndex = i >= 3 ? Random.Range(0, 7) : Model.Instance.ResultInfo.ImgTable[(2 - i) * 5 + index];
                icons.TryGetValue(Data.IconTable[iconIndex], out Sprite changeIcon);
                img.sprite = changeIcon;
                img.SetNativeSize();
                iconParent.GetChild(i).gameObject.name = Data.IconTable[iconIndex];
            }
        }
    }
}