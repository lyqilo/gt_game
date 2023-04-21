using System.Collections.Generic;

namespace LuaFramework
{	
	public struct AppInfoConfiger
	{		
		public string AuthCode { get; set; }		
		public int Version { get; set; }	
		public bool CloseGame { get; set; }	
		public string CloseHit { get; set; }	
		public string QQ1 { get; set; }
		public string QQ2 { get; set; }	
		public string QQ3 { get; set; }
		public string RankNum { get; set; }
		public string AndroidNewPakUrl { get; set; }
		public string iOSNewPakUrl { get; set; }
		public string WinPcNewPakUrl { get; set; }
		public string MacPcNewPakUrl { get; set; }
		public string[] NeedUpdatePakName { get; set; }
		public string Extend { get; set; }
		public Dictionary<string, BaseAppInfoJson> JsonData { get; set; }

		public bool isNeedUpdate(string key)
		{
			for (int i = 0; i < this.NeedUpdatePakName.Length; i++)
			{
				bool flag = key.Equals(this.NeedUpdatePakName[i]);
				if (flag)
				{
					return true;
				}
			}
			return false;
		}

		public BaseAppInfoJson GetValue(string k)
		{
			bool flag = this.JsonData.Count == 0;
			BaseAppInfoJson result;
			if (flag)
			{
				result = default(BaseAppInfoJson);
			}
			else
			{
				bool flag2 = !this.JsonData.ContainsKey(k);
				if (flag2)
				{
					result = default(BaseAppInfoJson);
				}
				else
				{
					result = this.JsonData[k];
				}
			}
			return result;
		}
	
		public int Count()
		{
			return this.JsonData.Count;
		}

		public void Remove(string k)
		{
			bool flag = !this.JsonData.ContainsKey(k);
			if (!flag)
			{
				this.JsonData.Remove(k);
			}
		}
	
		public void Add(string k, BaseAppInfoJson v)
		{
			bool flag = this.JsonData.ContainsKey(k);
			if (flag)
			{
				this.Remove(k);
			}
			this.JsonData.Add(k, v);
		}

		public bool Exist(string k)
		{
			return this.JsonData.ContainsKey(k);
		}
	}
}
