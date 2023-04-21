using System.IO;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;


namespace LuaFramework
{
    public class AssetBundleManager : Manager
    {
        private class AssetBundleInfo
        {
            /// <summary>
            /// AssetBundle
            /// </summary>
            public AssetBundle AB { private set; get; }                   

            /// <summary>
            /// 引用次数
            /// </summary>
            public int RefCount { set; get; }

            /// <summary>
            /// 生命周期剩余
            /// </summary>
            public int LeftLife { set; get; }


            public AssetBundleInfo(AssetBundle ab)
            {
                RefCount = 1;
                LeftLife = LIFECYCLETIMES;
                AB = ab;
            }

            public void Unload()
            {
                if (AB != null)
                {
                    DebugTool.Log(string.Format("释放AB = {0}", AB.name));
                    AB.Unload(false);
                }
                AB = null;
            }
        }

        private YieldInstruction waitTime = new WaitForSeconds(0.1f);      //扫描一次列表间隔时间

        private const int LIFECYCLETIMES = 30;      //AssetBundle无引用后的生命周期单位多少次扫描后销毁

        private string DataPath = Util.DataPath;    //AB文件存放地址

        private Dictionary<string, bool> faildLoadMap = new Dictionary<string, bool>();

        private Dictionary<string, AssetBundleInfo> abInfoMap = new Dictionary<string, AssetBundleInfo>();
        private List<AssetBundleInfo> abInfoList = new List<AssetBundleInfo>();

        public override void OnInitialize()
        {
            //StartCoroutine(UpdateAssetInfo());
        }

        public override void UnInitialize()
        {
            //StopAllCoroutines();
            Clear();
        }

        /// <summary>
        /// 清除所有AB缓存
        /// </summary>
        public void Clear()
        {
            for (int i = 0; i < abInfoList.Count; ++i)
            {
                abInfoList[i].Unload();
            }
            abInfoMap.Clear();
            abInfoList.Clear();
        }

        /// <summary>
        /// 检查AssetBundle生命周期
        /// </summary>
        IEnumerator UpdateAssetInfo()
        {
            while (true)
            {
                for (int i = 0; i < abInfoList.Count; )
                {
                    var abInfo = abInfoList[i];
                    if (abInfo.RefCount <= 0)
                    {
                        --abInfo.LeftLife;
                    }
                    if (abInfo.LeftLife > 0)
                    {
                        ++i;
                        continue;
                    }
                    
                    abInfoMap.Remove(abInfo.AB.name);
                    abInfoList.RemoveAt(i);
                    abInfo.Unload();
                }
                yield return waitTime;
            }
        }

        /// <summary>
        /// AB是否加载失败
        /// </summary>
        private bool IsLoadFaild(string abPath)
        {
            return faildLoadMap.ContainsKey(abPath);
        }

        /// <summary>
        /// 回收一个AssetBundle
        /// </summary>
        /// <param name="ab"></param>
        public void ReleaseAssetBundle(AssetBundle ab)
        {
            var abPath = ab.name;
            if (abInfoMap.ContainsKey(abPath))
            {
                var info = abInfoMap[abPath];
                --info.RefCount;                    //减少引用
            }
        }

        /// <summary>
        /// 获取一个AssetBundle
        /// </summary>
        /// <param name="abPath">AssetBundle文件路径名称(相对于DataPath)</param>
        /// <returns></returns>
        public AssetBundle GetAssetBundle(string abPath)
        {
            //载入失败直接返回
            if (IsLoadFaild(abPath)) return null;
            //有缓存直接返回
            if (abInfoMap.ContainsKey(abPath))
            {
                var info = abInfoMap[abPath];
                ++info.RefCount;                    //记录引用
                info.LeftLife = LIFECYCLETIMES;     //重置生命周期
                return info.AB;
            }
            //获取文件路径
            var filePath = DataPath + abPath + AppConst.ExtName;
            //读取AB
            var ab = AssetBundle.LoadFromFile(filePath);
            if (ab == null)
            {
                DebugTool.LogErrorFormat("载入AssetBundle:{0}失败！！", abPath);
                faildLoadMap.Add(abPath, true);
                return null;
            }
            ab.name = abPath;
            var abInfo = new AssetBundleInfo(ab);
            abInfoMap.Add(abPath, abInfo);
            abInfoList.Add(abInfo);

            return ab;
        }
    }

}

