using System;
using System.Collections.Generic;
using UnityEngine;

namespace BuildConfig
{
    [Serializable]
    public class FilesData
    {
        [SerializeField]
        private AppVersion _appVersion;

        [SerializeField]
        private List<ResData> _resDataList = new List<ResData>();

        private Dictionary<string, ResData> _resDataMap = new Dictionary<string, ResData>();

        public AppVersion AppVersion
        {
            get
            {
                return this._appVersion;
            }
            set
            {
                this._appVersion = value;
            }
        }

        public List<ResData> ResDataList
        {
            get
            {
                return this._resDataList;
            }
        }

        public Dictionary<string, ResData> ResDataMap
        {
            get
            {
                return this._resDataMap;
            }
        }

        public void InitData(AppVersion appVer, List<ResData> resDataList)
        {
            this._appVersion = appVer;
            this._resDataList.Clear();
            this._resDataList.AddRange(resDataList);
            this._resDataMap.Clear();
        }

        public void OnAfterDeserialize()
        {
            this._resDataMap.Clear();
            for (int i = 0; i < this._resDataList.Count; i++)
            {
                this.ResDataMap.Add(this._resDataList[i].ResName, this._resDataList[i]);
            }
        }
    }
}
