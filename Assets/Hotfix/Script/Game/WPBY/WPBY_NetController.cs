using UnityEngine;

namespace Hotfix.WPBY
{
    public class WPBY_NetController : SingletonILEntity<WPBY_NetController>
    {
        public void CreateNew(int site,Vector3 pos,int fishID)
        {
            int index = 1;
            if (site == WPBYEntry.Instance.GameData.ChairID) {
                index = 2;
            }
            else
            {
                index = 1;
            }
            string type = $"BulltEffect_{index}";
            GameObject net = FindEnableNet(type);
            if (net == null) {
                net = ToolHelper.Instantiate(WPBYEntry.Instance.netPool.Find(type).gameObject);
                net.gameObject.name = type;
            }
            WPBY_Fish fish = WPBY_FishController.Instance.GetFish(fishID);
            if (fish != null && fish.fishData.Kind >= 6) {
                //TODO 音效
                WPBY_Audio.Instance.PlaySound(WPBY_Audio.Hit);
            }
     net.transform.SetParent(WPBYEntry.Instance.netScene);
            net.transform.position = pos;
            net.transform.localRotation = Quaternion.Euler(0, 0, Random.Range(0, 359));
            net.transform.localScale = Vector3.one;
            net.gameObject.SetActive(true);
            WPBYEntry.Instance.DelayCall(2, ()=>
            {
                CollectNew(net.gameObject);
            });
        }
        public GameObject FindEnableNet(string type)
        {
            for (int i = 0; i < WPBYEntry.Instance.netCache.childCount; i++) {
                if (WPBYEntry.Instance.netCache.GetChild(i) != null && WPBYEntry.Instance.netCache.GetChild(i).gameObject.name == type) {
                    return WPBYEntry.Instance.netCache.GetChild(i).gameObject;
                }
        }
            return null;
        }
        //回收渔网
        public void CollectNew(GameObject net)
        {
            net.transform.SetParent(WPBYEntry.Instance.netCache);
            net.gameObject.SetActive(false);
            net.transform.localPosition = Vector3.zero;
        }
    }
}