using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace Hotfix.LTBY
{
    /// <summary>
    /// 规则界面
    /// </summary>
    public class LTBY_Help: LTBY_Messagebox
    {
        Transform content;

        Transform Content1;
        Transform Content2;
        Transform Content3;

        Dictionary<string, Transform> HelpDic;
        public LTBY_Help() : base(nameof(LTBY_Help), true)
        {
            HelpDic = new Dictionary<string, Transform>();
        }

        protected override void OnCreate(params object[] args)
        {
            base.OnCreate(args);
            SetTitle(HelpConfig.Frame.Title);
            SetBoardProperty(HelpConfig.Frame.x, HelpConfig.Frame.y, HelpConfig.Frame.w, HelpConfig.Frame.h);
            content = LTBY_Extend.Instance.LoadPrefab("LTBY_Help", contentParent);
            RectTransform rect = content.GetComponent<RectTransform>();
            if (rect != null)
            {
                rect.offsetMin = Vector2.zero;
                rect.offsetMax = Vector2.zero;
            }
            InitBtn();
            InitContent();
            ShowContent(1);
        }

       public override void GTGameChange()
        {
            Content3 = content.FindChildDepth("Content3");
            HelpDic.Add("Content3", Content3);
            Content3.FindChildDepth<Text>("Viewport/Content/Text").text="客服热线：4006603789\n客服QQ：3135367、17812777";
        }

        private void InitBtn()
        {
            for (int i = 1; i <= 3; i++)
            {
                int index = i;
                HelpDic.Add(($"btnFlag{i}"),content.FindChildDepth($"Flag{i}"));
                HelpDic[$"btnFlag{i}"].FindChildDepth<Text>("Text").text = HelpConfig.Flag[$"Flag{i}"];
                AddClick(HelpDic[$"btnFlag{i}"], (go, eventData) => ShowContent(index));
                HelpDic.Add(($"btnFlagChoose{i}"), HelpDic[$"btnFlag{i}"].FindChildDepth("Choose"));
                HelpDic[$"btnFlagChoose{i}"].FindChildDepth<Text>("Text").text = HelpConfig.Flag[$"Flag{i}"];
            }
        }


        private void InitContent(int index = 1)
        {
            switch (index)
            {
                case 1:
                {
                    Content1 = content.FindChildDepth("Content1");
                    HelpDic.Add("Content1", Content1);
                    Content1.FindChildDepth<Text>("Viewport/Content/SpecialTitle/Text").text = HelpConfig.Content1.special;

                    Content1.FindChildDepth<Text>("Viewport/Content/NormalTitle/Text").text = HelpConfig.Content1.normal;
                    Transform specialParent = Content1.FindChildDepth("Viewport/Content/SpecialFish");
                    Transform normalParent = Content1.FindChildDepth("Viewport/Content/NormalFish");

                    for (int i = 0; i < FishConfig.Fish.Count; i++)
                    {
                        FishDataConfig v = FishConfig.Fish[i];
                        if (v.fishOrginType == 143 && v.fishType != 143) continue;
                        Transform fish = LTBY_Extend.Instance.LoadPrefab("LTBY_HelpFishItem", v.specialFish ? specialParent : normalParent);
                        string imageBundle = FishConfig.GetFishImageBundle(v.fishOrginType);
                        fish.FindChildDepth("Fish").GetComponent<Image>().sprite = LTBY_Extend.Instance.LoadSprite(imageBundle, $"fish_{v.fishOrginType}");
                        fish.FindChildDepth<Text>("Bottom/Score").text = v.fishScore;
                        fish.FindChildDepth<Text>("Name").text = v.fishName;
                        fish.FindChildDepth("AwardFish").gameObject.SetActive(v.isAwardFish);
                        fish.FindChildDepth<Text>("AwardFish/Text").text = FishConfig.AwardFishText;
                        AddClick(fish, delegate (GameObject go, PointerEventData eventData)
                        {
                            LTBY_ViewManager.Instance.Open<LTBY_FishPreView>(v);
                        });
                    }

                    break;
                }
                case 2:
                {
                    Content2 = content.FindChildDepth("Content2");
                    HelpDic.Add("Content2", Content2);
                    Transform _parent = Content2.FindChildDepth("Viewport/Content");
                    for (int i = 0; i < HelpConfig.Content2.Count; i++)
                    {
                        var v = HelpConfig.Content2[i];
                        Transform item = LTBY_Extend.Instance.LoadPrefab("LTBY_HelpOpItem", _parent);
                        item.FindChildDepth<Text>("Frame/Name").text = v.name;
                        item.FindChildDepth<Text>("Des").text = v.des;
                        Transform image = item.FindChildDepth("Des/Image");
                        image.GetComponent<Image>().sprite = LTBY_Extend.Instance.LoadSprite(v.imageBundleName, v.imageName);
                        image.localPosition = new Vector3(v.imageX, v.imageY);

                    }

                    break;
                }
                case 3:
                    Content3 = content.FindChildDepth("Content3");
                    HelpDic.Add("Content3", Content3);
                    Content3.FindChildDepth<Text>("Viewport/Content/Text").text = HelpConfig.Content3.Text;
                    break;
            }
        }

        private void ShowContent(int index)
        {
            if (!HelpDic.ContainsKey($"Content{index}"))
            {
                InitContent(index);
            }
            for (int i = 1; i <= 3; i++)
            {
                HelpDic[$"btnFlagChoose{i}"].gameObject.SetActive(i == index);
                if (HelpDic.ContainsKey($"Content{i}"))
                {
                    HelpDic[$"Content{i}"].gameObject.SetActive(false);
                }
            }
            HelpDic[$"Content{index}"].gameObject.SetActive(true);
        }
    }
}
