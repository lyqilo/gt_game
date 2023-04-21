using System;
using UnityEngine;

namespace BuildConfig
{

    public enum ResUpdateState
    {
        FirstExtract,
        NeedDown,
        Delete,
        Normal
    }

    [Serializable]
    public class ResData
    {
        [SerializeField]
        private string _resName;

        [SerializeField]
        private string _resPath;

        [SerializeField]
        private string _resMD5;

        [SerializeField]
        private long _resSize;

        [SerializeField]
        private ResUpdateState _resState;

        public string ResName
        {
            get
            {
                return this._resName;
            }
            set
            {
                this._resName = value;
            }
        }

        public string ResPath
        {
            get
            {
                return this._resPath;
            }
            set
            {
                this._resPath = value;
            }
        }

        public string ResMD5
        {
            get
            {
                return this._resMD5;
            }
            set
            {
                this._resMD5 = value;
            }
        }

        public long ResSize
        {
            get
            {
                return this._resSize;
            }
            set
            {
                this._resSize = value;
            }
        }


        public ResUpdateState ResState
        {
            get
            {
                return this._resState;
            }
            set
            {
                this._resState = value;
            }
        }

    }
}
