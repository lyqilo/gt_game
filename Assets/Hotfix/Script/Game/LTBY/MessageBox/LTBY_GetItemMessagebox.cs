using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.LTBY
{
    public class LTBY_GetItemMessagebox : LTBY_Messagebox
    {
        object data;
        string itemType;
        CAction callBack;
        private Dictionary<string, object> dic;
        Dictionary<string, object> nextData;

        List<Transform> itemList;

        public LTBY_GetItemMessagebox() : base(nameof(LTBY_GetItemMessagebox), true)
        {
            itemList = new List<Transform>();
            nextData = new Dictionary<string, object>();
            dic = new Dictionary<string, object>();
        }

        protected override void OnCreate(params object[] args)
        {
            DelayRun(1, () =>{
                AddClick(this.transform, () =>{
                    OnBack();
                });
            });

            this.data = args.Length >= 2 ? args[1] : null;
            string _itemType = args.Length >= 1 ? args[0].ToString() : "";

            if (_itemType.Equals("Medal"))
            {
                SetTitle(GetItemConfig.Medal.imageBundleName, GetItemConfig.Medal.imageName);
                InitMedal(data);
            }
            else if (_itemType.Equals("MatchGift"))
            {
                SetTitle(GetItemConfig.Item.imageBundleName, GetItemConfig.Item.imageName);
                InitMatchGift(data);
            }
            else
            {
                SetTitle(GetItemConfig.Item.imageBundleName, GetItemConfig.Item.imageName);
                InitItem(data);
            }
            this.itemType = _itemType;

            this.callBack = args.Length >= 3 ? (CAction)args[2] : null;

            dic.Clear();
            nextData.Clear();

            LTBY_Audio.Instance.Play(SoundConfig.GetItem);

            //GC.Notification.GameRegister( "OnGamePause", function()

            //     Destroy();
            //end);

        }

        private void OnBack()
        {
            if(itemType .Equals("Item") || itemType .Equals( "MatchGift"))
            {
                var v = nextData.GetDictionaryValues();

                for (int i = 0; i < nextData.Count; i++)
                {
                    LTBY_EffectManager.Instance.CreateEffect<GetItem>(LTBY_GameView.GameInstance.chairId,
                       itemList[i].position,v[i] , callBack);
                }
            }
            else
            {
                callBack?.Invoke();
            }

            Destroy();

            if (nextData.Count> 0)
            {
                var _keys = nextData.GetDictionaryKeys();
                var _values = nextData.GetDictionaryValues();

                //var view = LTBY_ViewManager.Instance.Open<LTBY_GetItemMessagebox>(null, _keys[0], _values[0]);


                for (int i = 0; i < nextData.Count; i++)
                {
                    SetNextData(_keys[i], _values[i]);
                }        
            }
        }

        public void SetNextData(string _itemType, object _data)
        {
            nextData.Add(_itemType, _data);
        }

        private void SetTitle(string imageBundleName, string assetName)
        {
            var image = this.transform.FindChildDepth("caidai/zi").GetComponent<Image>();
            image.sprite = LTBY_Extend.Instance.LoadSprite(bundleName, assetName);
            image.SetNativeSize();
        }

        private void InitItem(object _data)
        {
            List<Item> mdata = (List<Item>)_data;
            itemList.Clear();
            var parent = this.transform.FindChildDepth("Item");
            for (int i = 0; i < mdata.Count; i++)
            {
                var v = mdata[i];
                var item = LTBY_Extend.Instance.LoadPrefab("LTBY_GetItem", parent);
                if (string.IsNullOrEmpty(v.name))
                {
                    var name = item.FindChildDepth("Name");
                    name.gameObject.SetActive(true);
                    name.name=v.name;
                    //GetComponent<Text>().text
                }

                if (v.num!=0)
                {
                    var num = item.FindChildDepth("Num");
                    num.gameObject.SetActive(true);
                    num.GetComponent<NumberRoller>().text=v.num.ShortNumber().ToString();
                }

                var image = item.GetComponent<Image>();
                image.sprite = LTBY_Extend.Instance.LoadSprite(v.imageBundleName, v.imageName);
                image.SetNativeSize();
                itemList.Add(item);
            }
        }

        private void InitMatchGift(object _data)
        {

        }


        private void InitMedal(object _data)
        {
            var parent = this.transform.FindChildDepth("Item");
            var item = LTBY_Extend.Instance.LoadPrefab("LTBY_GetItem", parent);
            item.FindChildDepth("Name").gameObject.SetActive(false);
            item.FindChildDepth("Num").gameObject.SetActive(false);

            //未使用vip
            //var config = MedalConfig.GetConfigByLevel(level);
            //var image = item.GetComponent<Image>();
            //image.sprite = LTBY_Extend.Instance.LoadSprite(config.imageBundleName, config.imageName);
            //image.SetNativeSize();
        }

    }

    public class Item
    {
        public string name;
        public int num;
        public string imageBundleName;
        public string imageName;
    }
}