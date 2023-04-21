using System;
using System.Collections.Generic;

namespace LuaFramework
{
	
	public struct ValueConfiger
	{
		
		
		
		public string AuthCode { get; set; }

		
		
		
		public int Version { get; set; }

		
		
		
		public string Extend { get; set; }

		
		
		
		public string UpdateUrl { get; set; }

		
		
		
		public string[] AuditPak { get; set; }

		
		
		
		public Dictionary<string, BaseValueConfigerJson> JsonData { get; set; }

		
		public bool isAudit(string key)
		{
			bool flag = this.AuditPak == null;
			bool result;
			if (flag)
			{
				result = false;
			}
			else
			{
				for (int i = 0; i < this.AuditPak.Length; i++)
				{
					bool flag2 = key.Equals(this.AuditPak[i]);
					if (flag2)
					{
						return true;
					}
				}
				result = false;
			}
			return result;
		}

		
		public BaseValueConfigerJson GetValue(string k)
		{
			bool flag = this.JsonData.Count == 0;
			BaseValueConfigerJson result;
			if (flag)
			{
				result = default(BaseValueConfigerJson);
			}
			else
			{
				bool flag2 = !this.JsonData.ContainsKey(k);
				if (flag2)
				{
					result = default(BaseValueConfigerJson);
				}
				else
				{
					result = this.JsonData[k];
				}
			}
			return result;
		}

		
		public BaseValueConfigerJson[] GetModule(string name)
		{
			List<BaseValueConfigerJson> list = new List<BaseValueConfigerJson>();
			foreach (BaseValueConfigerJson item in this.JsonData.Values)
			{
				bool flag = item.moduleName == name;
				if (flag)
				{
					list.Add(item);
				}
			}
			return list.ToArray();
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
				Dictionary<string, BaseValueConfigerJson> jsonData = this.JsonData;
				if (jsonData != null)
				{
					jsonData.Remove(k);
				}
			}
		}

		
		public void Add(string k, BaseValueConfigerJson v)
		{
			bool flag = this.JsonData.ContainsKey(k);
			if (flag)
			{
				this.Remove(k);
			}
			Dictionary<string, BaseValueConfigerJson> jsonData = this.JsonData;
			if (jsonData != null)
			{
				jsonData.Add(k, v);
			}
		}

		
		public void Add(BaseValueConfigerJson[] data)
		{
			foreach (BaseValueConfigerJson v in data)
			{
				this.Add(v.dirPath, v);
			}
		}

		
		public void Add(Dictionary<string, BaseValueConfigerJson> data)
		{
			bool flag = data == null;
			if (!flag)
			{
				foreach (KeyValuePair<string, BaseValueConfigerJson> keyValuePair in data)
				{
					this.Add(keyValuePair.Key, keyValuePair.Value);
				}
			}
		}

		
		public bool Exist(string k)
		{
			bool flag = this.JsonData == null;
			bool result;
			if (flag)
			{
				result = false;
			}
			else
			{
				bool flag2 = this.JsonData.Count == 0;
				result = (!flag2 && this.JsonData.ContainsKey(k));
			}
			return result;
		}
	}
}
