using System;
using UnityEngine;

namespace BuildConfig
{
    [Serializable]
    public class AppVersion
    {
        [SerializeField]
        private int _mainVersion = 1;

        [SerializeField]
        private int _subVersion;

        [SerializeField]
        private int _dataVersion;

        [SerializeField]
        private bool _isBase;


        public int MainVersion
        {
            get
            {
                return this._mainVersion;
            }
        }

        public int SubVersion
        {
            get
            {
                return this._subVersion;
            }
        }

        public int DataVersion
        {
            get
            {
                return this._dataVersion;
            }
        }

        public bool IsBase
        {
            get
            {
                return this._isBase;
            }
        }

        public AppVersion()
        {
        }

        public AppVersion(string verStr, bool isBase)
        {
            string[] array = Application.version.Split(new char[]
            {
                '.'
            });
            this._mainVersion = int.Parse(array[0]);
            this._subVersion = int.Parse(array[1]);
            this._dataVersion = int.Parse(array[2]);
            this._isBase = isBase;
        }

        public AppVersion(int mainVersion, int subVersion, int dataVersion)
        {
            this._mainVersion = mainVersion;
            this._subVersion = subVersion;
            this._dataVersion = dataVersion;
        }

        public new string ToString()
        {
            return string.Format("{0}.{1}.{2}", this._mainVersion, this._subVersion, this._dataVersion);
        }

        public int CompareTo(AppVersion appVersion)
        {
            bool flag = appVersion.MainVersion == this.MainVersion;
            int result;
            if (flag)
            {
                bool flag2 = appVersion.SubVersion == this.SubVersion;
                if (flag2)
                {
                    bool flag3 = appVersion.DataVersion == this.DataVersion;
                    if (flag3)
                    {
                        result = 0;
                    }
                    else
                    {
                        result = ((this.DataVersion > appVersion.DataVersion) ? 1 : -1);
                    }
                }
                else
                {
                    result = ((this.SubVersion > appVersion.SubVersion) ? 1 : -1);
                }
            }
            else
            {
                result = ((this.MainVersion > appVersion.MainVersion) ? 1 : -1);
            }
            return result;
        }

        public bool CanUpdateTo(AppVersion newVersion)
        {
            bool flag = this.MainVersion == newVersion.MainVersion;
            if (flag)
            {
                bool flag2 = this.SubVersion <= newVersion.SubVersion;
                if (flag2)
                {
                    bool flag3 = this.DataVersion <= newVersion.DataVersion;
                    if (flag3)
                    {
                        return true;
                    }
                }
            }
            return false;
        }

  

    }
}
