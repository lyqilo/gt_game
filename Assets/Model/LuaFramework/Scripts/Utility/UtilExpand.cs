
using UnityEngine;
using System.Collections;
using DG.Tweening;

namespace LuaFramework
{
    public static class UtilExpand
    {
        #region 回收拓展

        public static void Release(this GameObject go)
        {
            var autoRelease = go.GetComponent<AutoRelease>();
            if (autoRelease != null)
            {
                autoRelease.Release();
            }
            else
            {
                GameObject.Destroy(go);
            }
        }

        public static void Release(this Transform go)
        {
            var autoRelease = go.GetComponent<AutoRelease>();
            if (autoRelease != null)
            {
                autoRelease.Release();
            }
            else
            {
                GameObject.Destroy(go.gameObject);
            }
        }

        #endregion

        #region 设置坐标拓展

        public static void SetPos(this GameObject obj,Vector3 pos)
        {
            obj.transform.localPosition = pos;
        }

        public static void SetPos(this GameObject obj, float x, float y, float z)
        {
            obj.transform.localPosition = new Vector3(x, y, z);
        }

        public static void SetPos(this Transform transform, Vector3 pos)
        {
            transform.localPosition = pos;
        }

        public static void SetPos(this Transform transform, float x, float y, float z)
        {
            transform.localPosition = new Vector3(x, y, z);
        }

        public static void SetGlobalPos(this GameObject obj, Vector3 pos)
        {
            obj.transform.position = pos;
        }

        public static void SetGlobalPos(this GameObject obj, float x, float y, float z)
        {
            obj.transform.position = new Vector3(x, y, z);
        }

        public static void SetGlobalPos(this Transform transform, Vector3 pos)
        {
            transform.position = pos;
        }

        public static void SetGlobalPos(this Transform transform, float x, float y, float z)
        {
            transform.position = new Vector3(x, y, z);
        }

        #endregion

        #region 设置缩放拓展

        public static void SetScale(this GameObject obj, Vector3 scale)
        {
            obj.transform.localScale = scale;
        }

        public static void SetScale(this GameObject obj, float x, float y, float z)
        {
            obj.transform.localScale = new Vector3(x,y,z);
        }

        public static void SetScale(this Transform transform, Vector3 scale)
        {
            transform.localScale = scale;
        }

        public static void SetScale(this Transform transform, float x, float y, float z)
        {
            transform.localScale = new Vector3(x, y, z);
        }

        #endregion

        #region 设置旋转拓展

        public static void SetRotate(this GameObject obj, Vector3 rotate)
        {
            obj.transform.localRotation = Quaternion.Euler(rotate);
        }

        public static void SetRotate(this GameObject obj, float x, float y, float z)
        {
            obj.transform.localRotation = Quaternion.Euler(x,y,z);
        }

        public static void SetRotate(this Transform transform, Vector3 rotate)
        {
            transform.localRotation = Quaternion.Euler(rotate);
        }

        public static void SetRotate(this Transform transform, float x, float y, float z)
        {
            transform.localRotation = Quaternion.Euler(x, y, z);
        }

        public static void SetGlobalRotate(this GameObject obj, Vector3 rotate)
        {
            obj.transform.rotation = Quaternion.Euler(rotate);
        }

        public static void SetGlobalRotate(this GameObject obj, float x, float y, float z)
        {
            obj.transform.rotation = Quaternion.Euler(x, y, z);
        }

        public static void SetGlobalRotate(this Transform transform, Vector3 rotate)
        {
            transform.rotation = Quaternion.Euler(rotate);
        }

        public static void SetGlobalRotate(this Transform transform, float x, float y, float z)
        {
            transform.rotation = Quaternion.Euler(x, y, z);
        }

        #endregion

        #region 设置父节点拓展

        public static void SetParent(this GameObject obj,GameObject parent, bool reset)
        {
            obj.transform.SetParent(parent.transform);
            if (reset)
            {
                obj.transform.localRotation = Quaternion.Euler(Vector3.zero);
                obj.transform.localScale = Vector3.one;
                obj.transform.localPosition = Vector3.zero;
            }
        }

        public static void SetParent(this GameObject obj, Transform parent, bool reset)
        {
            obj.transform.SetParent(parent);
            if (reset)
            {
                obj.transform.localRotation = Quaternion.Euler(Vector3.zero);
                obj.transform.localScale = Vector3.one;
                obj.transform.localPosition = Vector3.zero;
            }
        }

        #endregion

        #region 批量获取child拓展

        public static Transform[] GetChilds(this Transform transform)
        {
            var childs = new Transform[transform.childCount];
            for (int i = 0; i < childs.Length; i++)
            {
                childs[i] = transform.GetChild(i);
            }
            return childs;
        }

        public static Transform[] GetChilds(this GameObject obj)
        {
            var childs = new Transform[obj.transform.childCount];
            for (int i = 0; i < childs.Length; i++)
            {
                childs[i] = obj.transform.GetChild(i);
            }
            return childs;
        }

        #endregion
    }

}
