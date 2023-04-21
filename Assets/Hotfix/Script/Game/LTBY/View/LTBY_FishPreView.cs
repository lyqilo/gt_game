using System;
using UnityEngine.UI;
using LuaFramework;
using UnityEngine;

namespace Hotfix.LTBY
{
    public class LTBY_FishPreView : LTBY_ViewBase
    {
        private Transform previewFish;
        private Vector2 touchPos;

        public LTBY_FishPreView() : base(nameof(LTBY_FishPreView), true)
        {
        }

        protected override void OnCreate(params object[] args)
        {
            base.OnCreate(args);
            FishDataConfig config = args.Length >= 1 ? (FishDataConfig)args[0] : null;
            GraphicRaycaster graphic = this.transform.GetComponent<GraphicRaycaster>();
            if (graphic == null)
            {
                graphic = this.transform.gameObject.AddComponent<GraphicRaycaster>();
            }
            this.transform.GetComponent<Canvas>().overrideSorting = true;
            this.transform.GetComponent<Canvas>().sortingOrder = 11;
            this.transform.GetComponent<RectTransform>().offsetMax = Vector2.zero;
            this.transform.GetComponent<RectTransform>().offsetMin = Vector2.zero;
            DebugHelper.Log($"{ FindChild("Board/Name") == null}");
            FindChild<Text>("Board/Name").text = $"{config.fishName}{config.nameSuffix}";
            FindChild<Text>("Board/Score").text = HelpConfig.ScoreText;
            FindChild<Text>("Board/Score/Number").text = $"{config.fishScore}";
            FindChild<Text>("Board/Des").text = config.des;

            //EventTriggerHelper.Get(FindChild("Board").gameObject).onDown = (go,eventData) => { };

            FindChild<Camera>("Board/Preview/FishCamera").orthographicSize = config.previewCameraSize;
            if (config.previewOffset != default)
            {
                FindChild("Board/Preview/FishCamera/FishNode").localPosition = new Vector3(config.previewOffset.x, config.previewOffset.y, 100);
            }

            Transform parent = FindChild("Board/Preview/FishCamera/FishNode");
            this.previewFish = LTBY_Extend.Instance.LoadPrefab(FishConfig.CheckIsElectricDragon(config.fishOrginType) ? $"fish_{config.fishOrginType}_preview" : $"fish_{config.fishOrginType}", parent);


            if (config.previewRotation != default)
            {
                this.previewFish.localEulerAngles = new Vector3(config.previewRotation.x, config.previewRotation.y, config.previewRotation.z);
            }

            if (config.previewPlayAnim != 0)
            {
                this.previewFish.FindChildDepth<Animator>("model").Play("swim01", -1, 0);
                StartTimer("PlayAnimLoop", config.previewPlayAnim, () =>
                {
                    this.previewFish.FindChildDepth<Animator>("model").Play("swim01", -1, 0);
                });
            }


            if (!config.previewForbidTouch)
            {
                Transform touch = FindChild("Board/Preview/FishTouch");
                EventTriggerHelper hepler = EventTriggerHelper.Get(touch.gameObject);
                hepler.onDown = (_, eventData) =>
                {
                    this.touchPos = eventData.position;
                };
                hepler.onDrag = (_, eventData) =>
                {
                    Vector3 angles = this.previewFish.localEulerAngles;
                    angles.z = angles.z + (eventData.position.x - this.touchPos.x);
                    //angles.x = angles.x + (eventData.position.y - this.touchPos.y);
                    this.previewFish.localEulerAngles = angles;
                    this.touchPos = eventData.position;
                };
            }


            LTBY_Extend.Instance.FadeAllIn(this.transform, 0.5f);


            DelayRun(0.5f, () =>
            {
                AddClick(this.transform, Exit);
            });
        }

        private void Exit()
        {
            AddClick(this.transform, () => { });

            LTBY_Extend.Instance.FadeAllOut(this.transform, 0.5f);
            DelayRun(0.5f, Destroy);
        }
    }
}
