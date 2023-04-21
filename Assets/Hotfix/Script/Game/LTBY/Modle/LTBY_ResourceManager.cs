using DG.Tweening;
using LuaFramework;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.LTBY
{
    /// <summary>
    /// 资源加载器
    /// </summary>
    public class LTBY_ResourceManager : SingletonNew<LTBY_ResourceManager>
    {
        private string editorPrefabPath = $"Assets/OtherScene/module62/Prefab";
        private string editorSoundPath = $"Assets/OtherScene/module62/Prefab";
        private Transform fishCache;
        public override void Init(Transform iLEntity = null)
        {
            base.Init(iLEntity);
            cacheBundleDic = new Dictionary<string, GameObject>();
            if (fishCache == null)
            {
                GameObject go = new GameObject("FishCache");
                go.transform.SetParent(LTBYEntry.Instance.transform);
                fishCache = go.transform;
                fishCache.transform.localPosition = new Vector3(10000, 0, 0);
            }
        }
        public override void Release()
        {
            base.Release();
            cacheBundleDic.Clear();
            imgParent = null;
            SoundParent = null;
            fishCache = null;
            Resources.UnloadUnusedAssets();
        }
        Dictionary<string, GameObject> cacheBundleDic = new Dictionary<string, GameObject>();
        public void Destroy(GameObject go)
        {
            if (go == null) return;
            go.SetActive(false);
            go.transform.SetParent(fishCache);
            go.transform.localPosition = Vector3.zero;
        }
        public void Destroy(Transform trans)
        {
            if (trans == null) return;
            Destroy(trans.gameObject);
        }

        public T LoadAsset<T>(string bundleName, string prefabName) where T : UnityEngine.Object
        {
            return ToolHelper.LoadAsset<T>(SceneType.Game, prefabName);
        }

        public UnityEngine.Transform LoadPrefab(string prefabName, Transform parent = null, string name = null,
            string layerName = null)
        {
            Transform fish = fishCache.Find(prefabName);
            if (fish != null)
            {
                fish.gameObject.SetActive(true);
                if (parent != null) fish.SetParent(parent);
                return fish;
            }

            cacheBundleDic.TryGetValue(prefabName, out GameObject go);
            if (go == null)
            {
                go = ToolHelper.LoadAsset<GameObject>(SceneType.Game, prefabName);
            }

            if (go == null) return null;
            GameObject _go = Object.Instantiate(go);
            if (parent != null) _go.transform.SetParent(parent);
            _go.transform.localPosition = Vector3.zero;
            _go.transform.localRotation = Quaternion.identity;
            _go.transform.localScale = Vector3.one;
            _go.name = !string.IsNullOrEmpty(name) ? name : prefabName;
            if (!string.IsNullOrEmpty(layerName)) _go.layer = LayerMask.NameToLayer(layerName);
            if (!cacheBundleDic.ContainsKey(prefabName)) cacheBundleDic.Add(prefabName, go);
            return _go.transform;
        }

        GameObject imgParent;
        public Sprite LoadAssetSprite(string bundleName, string assetName)
        {
            if (imgParent == null)
            {
                imgParent = ToolHelper.LoadAsset<GameObject>(SceneType.Game,$"LTBY_FishImgs");
            }
            if (imgParent == null) return null;
            for (int i = 0; i < imgParent.transform.childCount; i++)
            {
                if (!imgParent.transform.GetChild(i).gameObject.name.Equals(assetName)) continue;
                return imgParent.transform.GetChild(i).GetComponent<Image>().sprite;
            }
            return null;
        }
        private const string soundBundleName= "module62/prefab";
        GameObject SoundParent;
        public AudioClip LoadAudioClip(string assetName)
        {
            if (SoundParent == null)
            {
                SoundParent = ToolHelper.LoadAsset<GameObject>(SceneType.Game,$"LTBY_Audio");
            }
            if (SoundParent == null)
            {
                DebugHelper.LogError($"加载音效文件失败");
                return null;
            }
            for (int i = 0; i < SoundParent.transform.childCount; i++)
            {
                if (!SoundParent.transform.GetChild(i).gameObject.name.Equals(assetName)) continue;
                return SoundParent.transform.GetChild(i).GetComponent<AudioSource>().clip;
            }
            return null;
        }
    }
    
}
