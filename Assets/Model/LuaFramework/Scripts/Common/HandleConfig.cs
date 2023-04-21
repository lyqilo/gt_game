using System;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

namespace LuaFramework
{
	
	public class HandleConfig : MonoBehaviour
	{
		
		public static void InitConfiger()
		{
			HandleConfig.DictionaryConfiger.Clear();
			bool flag = File.Exists(AppConst.DataFileSavePath);
			bool flag2 = !flag;
			if (flag2)
			{
				HandleConfig.DictionaryConfiger.Add("InitAppTime", AppConst.AppInstallTime);
				HandleConfig.DictionaryConfiger.Add("ip", AppConst.Ip.ToString());
				HandleConfig.DictionaryConfiger.Add("port", AppConst.Port.ToString());
				HandleConfig.DictionaryConfiger.Add("Version", AppConst.Version.ToString());
				HandleConfig.DictionaryConfiger.Add("soundVolume", MusicManager.soundVolume.ToString());
				HandleConfig.DictionaryConfiger.Add("musicVolume", MusicManager.musicVolume.ToString());
				HandleConfig.DictionaryConfiger.Add("gameQuality", MusicManager.gameQuality.ToString());
				HandleConfig.DictionaryConfiger.Add("isPlaySV", MusicManager.isPlaySV.ToString());
				HandleConfig.DictionaryConfiger.Add("isPlayMV", MusicManager.isPlayMV.ToString());
				HandleConfig.DictionaryConfiger.Add("luaEncode", AppConst.LuaEncode.ToString());
				HandleConfig.DictionaryConfiger.Add("savelog", AppConst.SaveLogMode.ToString());
				HandleConfig.DictionaryConfiger.Add("showlog", AppConst.LogMode.ToString());
				HandleConfig.DictionaryConfiger.Add(AppConst.SkinVersionName, AppConst.UpdateVersion.ToString());
			}
			else
			{
				HandleConfig.DictionaryConfiger = HandleConfig.GetConfiger();
				foreach (string a in HandleConfig.DictionaryConfiger.Keys)
				{
					bool flag3 = a == "soundVolume";
					if (flag3)
					{
						MusicManager.soundVolume = float.Parse(HandleConfig.DictionaryConfiger["soundVolume"]);
					}
					bool flag4 = a == "musicVolume";
					if (flag4)
					{
						MusicManager.musicVolume = float.Parse(HandleConfig.DictionaryConfiger["musicVolume"]);
					}
					bool flag5 = a == "gameQuality";
					if (flag5)
					{
						MusicManager.gameQuality = float.Parse(HandleConfig.DictionaryConfiger["gameQuality"]);
					}
					bool flag6 = a == "isPlayMV";
					if (flag6)
					{
						MusicManager.isPlayMV = HandleConfig.stringToBool(HandleConfig.DictionaryConfiger["isPlayMV"]);
					}
					bool flag7 = a == "isPlaySV";
					if (flag7)
					{
						MusicManager.isPlaySV = HandleConfig.stringToBool(HandleConfig.DictionaryConfiger["isPlaySV"]);
					}
					bool flag8 = a == "luaEncode";
					if (flag8)
					{
						AppConst.LuaEncode = HandleConfig.stringToBool(HandleConfig.DictionaryConfiger["luaEncode"]);
					}
					bool flag9 = a == "showlog";
					if (flag9)
					{
						AppConst.LogMode = HandleConfig.stringToBool(HandleConfig.DictionaryConfiger["showlog"]);
					}
					bool flag10 = a == "savelog";
					if (flag10)
					{
						AppConst.SaveLogMode = HandleConfig.stringToBool(HandleConfig.DictionaryConfiger["savelog"]);
					}
					bool flag11 = a == AppConst.SkinVersionName;
					if (flag11)
					{
						AppConst.UpdateVersion = int.Parse(HandleConfig.DictionaryConfiger[AppConst.SkinVersionName]);
					}
					bool flag12 = a == "InitAppTime";
					if (flag12)
					{
						AppConst.AppInstallTime = HandleConfig.DictionaryConfiger["InitAppTime"];
					}
				}
			}
		}

		
		public static void SaveConfiger()
		{

			HandleConfig.Write("port", AppConst.Port.ToString());
			HandleConfig.Write("Version", AppConst.Version.ToString());
			HandleConfig.Write("soundVolume", MusicManager.soundVolume.ToString());
			HandleConfig.Write("musicVolume", MusicManager.musicVolume.ToString());
			HandleConfig.Write("gameQuality", MusicManager.gameQuality.ToString());
			HandleConfig.Write("isPlaySV", MusicManager.isPlaySV.ToString());
			HandleConfig.Write("isPlayMV", MusicManager.isPlayMV.ToString());
			HandleConfig.Write("luaEncode", AppConst.LuaEncode.ToString());
			HandleConfig.Write("savelog", AppConst.SaveLogMode.ToString());
			HandleConfig.Write("showlog", AppConst.LogMode.ToString());
			HandleConfig.Write(AppConst.SkinVersionName, AppConst.UpdateVersion.ToString());
			HandleConfig.Write("InitAppTime", AppConst.AppInstallTime);
			string contents = HandleConfig.DicToString(HandleConfig.DictionaryConfiger);
			string dataFileSavePath = AppConst.DataFileSavePath;
			bool flag = !Directory.Exists(PathHelp.AppHotfixResPath);
			if (flag)
			{
				Directory.CreateDirectory(PathHelp.AppHotfixResPath);
			}
			bool flag2 = File.Exists(dataFileSavePath);
			if (flag2)
			{
				File.Delete(dataFileSavePath);
			}
			File.AppendAllText(dataFileSavePath, contents);
		}

		
		public static string DicToString(Dictionary<string, string> dic)
		{
			string text = string.Empty;
			foreach (KeyValuePair<string, string> keyValuePair in dic)
			{
				text = string.Concat(new string[]
				{
					text,
					keyValuePair.Key,
					"=",
					keyValuePair.Value,
					"\n"
				});
			}
			return text;
		}

		
		public static Dictionary<string, string> GetConfiger()
		{
			string dataFileSavePath = AppConst.DataFileSavePath;
			string[] array = File.ReadAllLines(dataFileSavePath);
			int i = 0;
			while (i < array.Length)
			{
				bool flag = array[i].Contains("=");
				if (flag)
				{
					string[] array2 = array[i].Split(new char[]
					{
						'='
					});
					bool flag2 = array2[0].Equals(string.Empty) || array2[1].Equals(string.Empty) || array2[0] == null;
					if (!flag2)
					{
						HandleConfig.Write(array2[0], array2[1]);
					}
				}
				IL_7D:
				i++;
				continue;

				goto IL_7D;
			}
			return HandleConfig.DictionaryConfiger;
		}

		
		public static bool Write(string key, string val)
		{
			object obj = HandleConfig.obj;
			bool result;
			lock (obj)
			{
				bool flag2 = key == string.Empty;
				if (flag2)
				{
					DebugTool.LogError("The key can't be empty");
					result = false;
				}
				else
				{
					bool flag3 = val == string.Empty;
					if (flag3)
					{
                        DebugTool.LogError("The value can't be empty");
						result = false;
					}
					else
					{
						int num = -1;
						foreach (KeyValuePair<string, string> keyValuePair in HandleConfig.DictionaryConfiger)
						{
							bool flag4 = keyValuePair.Key == key;
							if (flag4)
							{
								num = 1;
							}
						}
						bool flag5 = num == 1;
						if (flag5)
						{
							HandleConfig.DictionaryConfiger[key] = val;
						}
						bool flag6 = num == -1;
						if (flag6)
						{
							HandleConfig.DictionaryConfiger.Add(key, val);
						}
						result = true;
					}
				}
			}
			return result;
		}

		
		public static string Read(string key)
		{
			bool flag = key == string.Empty;
			string result;
			if (flag)
			{
                DebugTool.LogError("The key can't be empty");
				result = string.Empty;
			}
			else
			{
				string text = string.Empty;
				foreach (KeyValuePair<string, string> keyValuePair in HandleConfig.DictionaryConfiger)
				{
					bool flag2 = keyValuePair.Key.Equals(key);
					if (flag2)
					{
						text = HandleConfig.DictionaryConfiger[key];
					}
				}
				result = text;
			}
            return result;
		}

		
		public static bool stringToBool(string str)
		{
			bool result = false;
			bool flag = str.ToLower() == "true";
			if (flag)
			{
				result = true;
			}
			return result;
		}

		
		private static Dictionary<string, string> DictionaryConfiger = new Dictionary<string, string>();

		
		private static readonly object obj = new object();
	}
}
