using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;
using LitJson;
using UnityEngine;

namespace LuaFramework
{
	
	public class ConfigHelp : MonoBehaviour
	{
		
		
		public static string ServerUpdateConfigerPath
		{
			get
			{
				return ConfigHelp.ServerValueConfigerPath;
			}
		}

		
		
		public static string ServerValueConfigerPath
		{
			get
			{
				bool flag = ConfigHelp.AppHotfixResPath.IsNullOrEmpty();
				if (flag)
				{
					ConfigHelp.AppHotfixResPath = PathHelp.AppHotfixResPath;
				}
				return string.Format("/{0}/{1}/{2}/{3}", new object[]
				{
					AppConst.CdnDirectoryName,
					Util.PlatformName,
					AppConst.HotUpdateDirectoryName,
					AppConst.ValueConfigerName
				});
			}
		}

		
		
		public static string ServerGameValueConfigerPath
		{
			get
			{
				return string.Format("/{0}/{1}/{2}/{3}", new object[]
				{
					AppConst.CdnDirectoryName,
					Util.PlatformName,
					AppConst.HotUpdateDirectoryName,
					AppConst.GameValueConfigerName
				});
			}
		}

		
		
		public static string ServerAppInfoConfigerPath
		{
			get
			{
				return string.Format("/{0}/{1}", AppConst.CdnDirectoryName, AppConst.AppInfoConfigerName);
			}
		}

		
		
		public static string ServerGameEnterConfigerPath
		{
			get
			{
				return string.Format("/{0}/{1}", AppConst.CdnDirectoryName, AppConst.GameEnterConfigerName);
			}
		}

		
		public static void SaveJsonCofiger(string json, string path)
		{
			string text = Path.GetFileName(path);
			bool fileNameEncryption = AppConst.FileNameEncryption;
			if (fileNameEncryption)
			{
				text = Util.EncryptDES(text.RemoveSuffix(), "89219417");
				text += AppConst.TextSuffix;
			}
			bool flag = File.Exists(path);
			if (flag)
			{
				File.Delete(path);
			}
			File.AppendAllText(path, json);
			DebugTool.Log(string.Format("保存{0}配置完成", text));
		}

		
		public static void SaveCSConfiger()
		{
			string path = PathHelp.AppHotfixResPath + "CSConfiger.json";
			string json = JsonMapper.ToJson(AppConst.csConfiger);
			ConfigHelp.SaveJsonCofiger(json, path);
		}

		
		public static void SaveValueConfiger()
		{
		}

		
		public static void SaveAppInfoConfiger()
		{
		}

		
		public static void SaveText()
		{
		}

		
		public static void SaveConfig()
		{
			// HandleConfig.SaveConfiger();
		}

		
		public static async Task InitGameValueConfiger()
		{
 
            string path = string.Empty;
			string text = string.Empty;
			path = ConfigHelp.AppHotfixResPath + AppConst.GameValueConfigerName;
			bool flag = !File.Exists(path);
			if (flag)
			{
                DebugTool.Log("本地默认配置" + AppConst.GameValueConfigerName + "不存在!");
			}
			else
			{
				text = File.ReadAllText(path);
				await Task.Run(() => AppConst.gameValueConfiger = JsonMapper.ToObject<ValueConfiger>(text));
			}
		}

		
		public static async Task InitAppInfoConfiger()
		{
			string path = string.Empty;
			string text = string.Empty;
			path = ConfigHelp.AppHotfixResPath + AppConst.AppInfoConfigerName;
			bool flag = !File.Exists(path);
			if (flag)
			{
                DebugTool.Log("本地默认配置" + AppConst.AppInfoConfigerName + "不存在!");
			}
			else
			{
				text = File.ReadAllText(path);
                await Task.Run(() => AppConst.appInfoConfiger = JsonMapper.ToObject<AppInfoConfiger>(text));
			}
		}

		
		public static List<string> GetHotFixUrls()
		{
			List<string> list = new List<string>();
			for (int i = 0; i < AppConst.DNS.Length; i++)
			{
				// string str = string.Empty;
				// string str2 = string.Empty;
				// for (int j = 0; j < AppConst.ResourcePortRange; j++)
				// {
				// 	str2 = AppConst.DNS[i] + str;
				// 	list.Add(str2 + ConfigHelp.ServerUpdateConfigerPath);
				// 	str = ":" + (AppConst.ResourcePort + j);
				// }
				list.Add($"{AppConst.DNS[i]}/{AppConst.CdnDirectoryName}/{Application.version}/Auth.json");
			}
			return list;
		}

		
		public static string AppHotfixResPath = PathHelp.AppHotfixResPath;
	}
}
