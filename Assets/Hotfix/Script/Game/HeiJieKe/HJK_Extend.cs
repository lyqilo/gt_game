using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.HeiJieKe
{
    public class HJK_Extend : SingletonILEntity<HJK_Extend>
    {
        private Transform pool;
        private Transform cache;

        protected override void FindComponent()
        {
            base.FindComponent();
            pool = transform.FindChildDepth($"Pool");
            cache = transform.FindChildDepth($"Cache");
        }

        /// <summary>
        /// 获取物体
        /// </summary>
        /// <param name="itemname">元素名</param>
        /// <returns></returns>
        public Transform GetItem(string itemname)
        {
            Transform child = cache.FindChildDepth(itemname);
            if (child != null)
            {
                child.gameObject.SetActive(true);
                return child;
            }
            Transform orgin = pool.FindChildDepth(itemname);
            if (orgin == null)
            {
                DebugHelper.LogError($"没找到item {itemname}");
                return null;
            }

            child = ToolHelper.Instantiate(orgin.gameObject).transform;
            child.gameObject.name = itemname;
            child.gameObject.SetActive(true);
            return child;
        }

        /// <summary>
        /// 回收
        /// </summary>
        /// <param name="obj"></param>
        public void Collect(GameObject obj)
        {
            Collect(obj.transform);
        }

        /// <summary>
        /// 回收
        /// </summary>
        /// <param name="trans"></param>
        public void Collect(Transform trans)
        {
            trans.SetParent(cache);
            trans.localPosition = Vector3.zero;
            trans.gameObject.SetActive(false);
        }
    }
}