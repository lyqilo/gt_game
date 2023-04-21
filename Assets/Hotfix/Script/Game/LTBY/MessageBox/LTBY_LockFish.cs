using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;


namespace Hotfix.LTBY
{
    public class LTBY_LockFish: LTBY_Messagebox
    {
        Transform content;
        Transform btnAll;
        Transform btnNone;

        public static Dictionary<int, bool> autoLockFishList;
        public static Dictionary<int, Transform> fishList;
        public LTBY_LockFish() : base(nameof(LTBY_LockFish), true)
        {
            autoLockFishList = new Dictionary<int, bool>();
            fishList = new Dictionary<int, Transform>();
        }

        protected override void OnCreate(params object[] args)
        {
            base.OnCreate(args);
            SetTitle(LockFishConfig.Frame.Title);
            SetBoardProperty(LockFishConfig.Frame.x, LockFishConfig.Frame.y, LockFishConfig.Frame.w, LockFishConfig.Frame.h);
            content = LTBY_Extend.Instance.LoadPrefab("LTBY_LockFish", contentParent);

            RectTransform rect = content.GetComponent<RectTransform>();
            if (rect != null)
            {
                rect.offsetMax = Vector2.zero;
                rect.offsetMin = Vector2.zero;
            }
            InitBtn();
            InitContent();
        }

        protected override  void OnBtnBack()
        {
            LockFishConfig.SetLockFishList(autoLockFishList);
            LTBY_GameView.GameInstance.SetLockFish(true);
            ExitAction();
        }

        public void CheckLock()
        {
            Transform[] _values = fishList.GetDictionaryValues();
            for (int i = 0; i < _values.Length; i++)
            {
                Transform fish = _values[i];
                fish.FindChildDepth("ChooseFrame").gameObject.SetActive(false);
                fish.FindChildDepth("ChooseTick").gameObject.SetActive(false);
            }

            int[] keys= autoLockFishList.GetDictionaryKeys();
            for (int i = 0; i < keys.Length; i++)
            {
                Transform fish = fishList[keys[i]];
                fish.FindChildDepth("ChooseFrame").gameObject.SetActive(true);
                fish.FindChildDepth("ChooseTick").gameObject.SetActive(true);
            }
        }


        private void InitBtn()
        {
            btnAll = content.FindChildDepth("BtnFrame/All");
            btnAll.FindChildDepth<Text>("Text").text= LockFishConfig.Frame.BtnAll;
            AddClick(btnAll, (go, eventData)=>
            {
                int[] _keys = fishList.GetDictionaryKeys();
                for (int i = 0; i < _keys.Length; i++)
                {
                    if (autoLockFishList.ContainsKey(_keys[i])) autoLockFishList.Remove(_keys[i]);
                    autoLockFishList.Add(_keys[i], true);
                }
                CheckLock();
            });

            btnNone = content.FindChildDepth("BtnFrame/None");
            btnNone.FindChildDepth<Text>("Text").text= LockFishConfig.Frame.BtnNone;
            AddClick(btnNone, (go, eventData)=>
            {
                autoLockFishList.Clear();
                CheckLock();
            });
        }

        private void InitContent()
        {
            content.FindChildDepth<Text>("Des1").text = LockFishConfig.Frame.Des1;
            content.FindChildDepth<Text>("Des2").text = LockFishConfig.Frame.Des2;
            content.FindChildDepth<Text>("Des3").text = LockFishConfig.Frame.Des3;                              
            autoLockFishList = LockFishConfig.LockFishList;
            fishList.Clear();

            var parent = content.FindChildDepth("ScrollView/Viewport/Content");
            for (int i = 0; i < FishConfig.Fish.Count; i++)
            {
                int index = i;
                var v = FishConfig.Fish[index];
                var fish = LTBY_Extend.Instance.LoadPrefab("LTBY_LockFishItem", parent);
                var imageBundle = FishConfig.GetFishImageBundle(v.fishOrginType);
                fish.FindChildDepth("Fish").GetComponent<Image>().sprite = LTBY_Extend.Instance.LoadSprite(imageBundle, $"fish_{v.fishOrginType}");
                fish.FindChildDepth<Text>("Bottom/Score").text = v.fishScore;
                fish.FindChildDepth<Text>("ChooseFrame/Bottom/Score").text = v.fishScore;
                fish.FindChildDepth<Text>("AwardFish/Text").text = FishConfig.AwardFishText;
                fish.FindChildDepth("AwardFish").gameObject.SetActive(v.isAwardFish);

                AddClick(fish, (go, eventData)=>
                {
                    if (autoLockFishList.ContainsKey(v.fishOrginType))
                    {
                        autoLockFishList.Remove(v.fishOrginType);
                        fish.FindChildDepth("ChooseFrame").gameObject.SetActive(false);
                        fish.FindChildDepth("ChooseTick").gameObject.SetActive(false);
                    }
                    else
                    {
                        autoLockFishList.Add(v.fishOrginType, true);
                        fish.FindChildDepth("ChooseFrame").gameObject.SetActive(true);
                        fish.FindChildDepth("ChooseTick").gameObject.SetActive(true);
                    }
                    CheckLock();
                });
                fishList.Remove(v.fishOrginType);
                fishList.Add(v.fishOrginType, fish);
            }
            CheckLock();
        }

    }
}