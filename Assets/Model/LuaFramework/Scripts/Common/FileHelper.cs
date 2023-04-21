// dnSpy decompiler from Assembly-CSharp.dll class: Common.FileHelper
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using LuaInterface;
using UnityEngine;

namespace Common
{
	public static class FileHelper
	{
		public static void CreateDirectoryFromFile(string path)
		{
			path = path.Replace('\\', '/');
			int num = path.LastIndexOf('/');
			if (num >= 0)
			{
				path = path.Substring(0, num);
				FileHelper.CreateDirectory(path);
				return;
			}
		}

		public static void CreateDirectory(string path)
		{
			if (!Directory.Exists(path))
			{
				Directory.CreateDirectory(path);
			}
		}

		public static void SaveFile(string path, string content, bool needUtf8 = false)
		{
			FileHelper.CheckFileSavePath(path);
			if (needUtf8)
			{
				UTF8Encoding encoding = new UTF8Encoding(false);
				File.WriteAllText(path, content, encoding);
			}
			else
			{
				File.WriteAllText(path, content, Encoding.Default);
			}
		}

		public static void SaveLine(string path, string content)
		{
			FileHelper.CheckFileSavePath(path);
			StreamWriter streamWriter = new StreamWriter(path, true);
			streamWriter.WriteLine(content);
			streamWriter.Close();
		}

		public static void SaveString(string path, string content)
		{
			StreamWriter streamWriter = new StreamWriter(path, true);
			streamWriter.Write(content);
			streamWriter.Close();
		}

		public static void WriteLine(string path, string content)
		{
			StreamWriter streamWriter = new StreamWriter(path, true);
			streamWriter.WriteLine(content);
			streamWriter.Close();
		}

		public static void WriteAllText(string path, string content)
		{
			UTF8Encoding encoding = new UTF8Encoding(false);
			File.WriteAllText(path, content, encoding);
		}

		public static void DelFolder(string path)
		{
			if (!FileHelper.IsDirectoryExists(path))
			{
				return;
			}
			Directory.Delete(path, true);
		}

		public static void DelFile(string path)
		{
			if (!FileHelper.IsFileExists(path))
			{
				return;
			}
			File.Delete(path);
		}

		public static void CleanFolder(string path)
		{
			if (!FileHelper.IsDirectoryExists(path))
			{
				return;
			}
			FileHelper.DOCleanFolder(path);
		}

		private static void DOCleanFolder(string path)
		{
			DirectoryInfo directoryInfo = new DirectoryInfo(path);
			FileInfo[] files = directoryInfo.GetFiles();
			for (int i = 0; i < files.Length; i++)
			{
				File.Delete(files[i].FullName);
			}
			DirectoryInfo[] directories = directoryInfo.GetDirectories();
			for (int j = 0; j < directories.Length; j++)
			{
				FileHelper.DOCleanFolder(directories[j].FullName);
			}
		}

		[NoToLua]
		public static IEnumerator CleanupDirectory(string path, int count)
		{
			if (!Directory.Exists(path))
			{
				yield break;
			}
			string[] filePaths = Directory.GetFiles(path, "*.*", SearchOption.AllDirectories);
			yield return Yielders.EndOfFrame;
			for (int i = 0; i < filePaths.Length; i++)
			{
				File.Delete(filePaths[i]);
				if (i % count == 0)
				{
					yield return Yielders.EndOfFrame;
				}
			}
			yield break;
		}

		public static string ReadFileText(string path, bool reportError = true)
		{
			if (!File.Exists(path))
			{
				if (reportError)
				{
					UnityEngine.Debug.LogError("unable to load file " + path);
				}
				return string.Empty;
			}
			UTF8Encoding encoding = new UTF8Encoding(false);
			return File.ReadAllText(path, encoding);
		}

		public static bool CheckDirection(string path)
		{
			if (!Directory.Exists(path))
			{
				DirectoryInfo directoryInfo = Directory.CreateDirectory(path);
				return directoryInfo.Exists;
			}
			return true;
		}

		public static bool IsDirectoryExists(string path)
		{
			return Directory.Exists(path);
		}

		public static bool IsFileExists(string path)
		{
			return File.Exists(path);
		}

		public static void CopyFile(string path, string tarPath)
		{
			if (!FileHelper.IsFileExists(path))
			{
				return;
			}
			FileHelper.CheckFileSavePath(tarPath);
			File.Copy(path, tarPath, true);
		}

		public static void CopyDirectory(string srcDir, string tgtDir, string[] skips_dir_contains = null, string[] skips_ext = null)
		{
			string str = "\\";
			OperatingSystem osversion = Environment.OSVersion;
			if (osversion.Platform == PlatformID.MacOSX || osversion.Platform == PlatformID.Unix)
			{
				str = "/";
			}
			DirectoryInfo directoryInfo = new DirectoryInfo(srcDir);
			DirectoryInfo directoryInfo2 = new DirectoryInfo(tgtDir);
			if (directoryInfo2.FullName.StartsWith(directoryInfo.FullName))
			{
				throw new Exception("父目录不能拷贝到子目录！");
			}
			if (skips_dir_contains != null)
			{
				for (int i = 0; i < skips_dir_contains.Length; i++)
				{
					if (srcDir.Contains(skips_dir_contains[i]))
					{
						UnityEngine.Debug.LogFormat("skip dir {0}", new object[]
						{
							srcDir
						});
						return;
					}
				}
			}
			if (!directoryInfo.Exists)
			{
				return;
			}
			if (!directoryInfo2.Exists)
			{
				directoryInfo2.Create();
			}
			FileInfo[] files = directoryInfo.GetFiles();
			for (int j = 0; j < files.Length; j++)
			{
				bool flag = false;
				if (skips_ext != null)
				{
					for (int k = 0; k < skips_ext.Length; k++)
					{
						if (files[j].Name.EndsWith(skips_ext[k]))
						{
							flag = true;
							break;
						}
					}
				}
				if (!flag)
				{
					File.Copy(files[j].FullName, directoryInfo2.FullName + str + files[j].Name, true);
				}
			}
			DirectoryInfo[] directories = directoryInfo.GetDirectories();
			for (int l = 0; l < directories.Length; l++)
			{
				FileHelper.CopyDirectory(directories[l].FullName, directoryInfo2.FullName + str + directories[l].Name, skips_dir_contains, skips_ext);
			}
		}

		public static bool CheckFileSavePath(string path)
		{
			path = path.Replace('\\', '/');
			int num = path.LastIndexOf('/');
			if (num >= 0)
			{
				path = path.Substring(0, num);
				return FileHelper.CheckDirection(path);
			}
			return true;
		}

		[NoToLua]
		public static string[] ReadAllLines(string path)
		{
			if (!File.Exists(path))
			{
				return null;
			}
			return File.ReadAllLines(path);
		}

		[NoToLua]
		public static void SaveAllLines(string path, string[] lines)
		{
			FileHelper.CheckFileSavePath(path);
			File.WriteAllLines(path, lines);
		}

		[NoToLua]
		public static void SaveBytes(string path, byte[] bytes)
		{
			FileHelper.CheckFileSavePath(path);
			File.WriteAllBytes(path, bytes);
		}

		[NoToLua]
		public static byte[] ReadFileBytes(string path)
		{
			if (!File.Exists(path))
			{
				return null;
			}
			return File.ReadAllBytes(path);
		}

		[NoToLua]
		public static List<string> GetAllFiles(string path, string exName)
		{
			if (!FileHelper.IsDirectoryExists(path))
			{
				return null;
			}
			List<string> list = new List<string>();
			DirectoryInfo directoryInfo = new DirectoryInfo(path);
			FileInfo[] files = directoryInfo.GetFiles();
			for (int i = 0; i < files.Length; i++)
			{
				string exName2 = FileHelper.GetExName(files[i].FullName);
				if (!(exName2 != exName))
				{
					list.Add(files[i].FullName);
				}
			}
			DirectoryInfo[] directories = directoryInfo.GetDirectories();
			if (directories.Length > 0)
			{
				for (int j = 0; j < directories.Length; j++)
				{
					List<string> allFiles = FileHelper.GetAllFiles(directories[j].FullName, exName);
					if (allFiles.Count > 0)
					{
						for (int k = 0; k < allFiles.Count; k++)
						{
							list.Add(allFiles[k]);
						}
					}
				}
			}
			return list;
		}

		[NoToLua]
		public static List<FileInfo> GetAllFileInfos(string path, string exName)
		{
			if (!FileHelper.IsDirectoryExists(path))
			{
				return null;
			}
			List<FileInfo> list = new List<FileInfo>();
			DirectoryInfo directoryInfo = new DirectoryInfo(path);
			FileInfo[] files = directoryInfo.GetFiles();
			for (int i = 0; i < files.Length; i++)
			{
				string exName2 = FileHelper.GetExName(files[i].FullName);
				if (string.IsNullOrEmpty(exName) || !(exName2 != exName))
				{
					list.Add(files[i]);
				}
			}
			DirectoryInfo[] directories = directoryInfo.GetDirectories();
			if (directories.Length > 0)
			{
				for (int j = 0; j < directories.Length; j++)
				{
					List<FileInfo> allFileInfos = FileHelper.GetAllFileInfos(directories[j].FullName, exName);
					if (allFileInfos.Count > 0)
					{
						for (int k = 0; k < allFileInfos.Count; k++)
						{
							list.Add(allFileInfos[k]);
						}
					}
				}
			}
			return list;
		}

		[NoToLua]
		public static List<string> GetAllFilesExcept(string path, string[] exName)
		{
			List<string> list = new List<string>();
			DirectoryInfo directoryInfo = new DirectoryInfo(path);
			FileInfo[] files = directoryInfo.GetFiles();
			for (int i = 0; i < files.Length; i++)
			{
				string exName2 = FileHelper.GetExName(files[i].FullName);
				if (Array.IndexOf<string>(exName, exName2) == -1)
				{
					list.Add(files[i].FullName);
				}
			}
			DirectoryInfo[] directories = directoryInfo.GetDirectories();
			if (directories.Length > 0)
			{
				for (int j = 0; j < directories.Length; j++)
				{
					List<string> allFilesExcept = FileHelper.GetAllFilesExcept(directories[j].FullName, exName);
					if (allFilesExcept.Count > 0)
					{
						for (int k = 0; k < allFilesExcept.Count; k++)
						{
							list.Add(allFilesExcept[k]);
						}
					}
				}
			}
			return list;
		}

		[NoToLua]
		public static List<string> GetSubFolders(string path)
		{
			if (!FileHelper.IsDirectoryExists(path))
			{
				return null;
			}
			DirectoryInfo directoryInfo = new DirectoryInfo(path);
			DirectoryInfo[] directories = directoryInfo.GetDirectories();
			List<string> list = new List<string>();
			if (directories.Length > 0)
			{
				for (int i = 0; i < directories.Length; i++)
				{
					list.Add(directories[i].FullName);
				}
			}
			return list;
		}

		[NoToLua]
		public static List<string> GetSubFiles(string path, string exName)
		{
			List<string> list = new List<string>();
			DirectoryInfo directoryInfo = new DirectoryInfo(path);
			FileInfo[] files = directoryInfo.GetFiles();
			for (int i = 0; i < files.Length; i++)
			{
				string exName2 = FileHelper.GetExName(files[i].FullName);
				if (!(exName2 != exName))
				{
					list.Add(files[i].FullName);
				}
			}
			return list;
		}

		[NoToLua]
		public static List<string> GetSubFilesExcept(string path, string exName)
		{
			List<string> list = new List<string>();
			DirectoryInfo directoryInfo = new DirectoryInfo(path);
			FileInfo[] files = directoryInfo.GetFiles();
			for (int i = 0; i < files.Length; i++)
			{
				string exName2 = FileHelper.GetExName(files[i].FullName);
				if (!(exName2 == exName))
				{
					list.Add(files[i].FullName);
				}
			}
			return list;
		}

		[NoToLua]
		public static AssetBundle LoadAbFormFile(string path)
		{
			if (!File.Exists(path))
			{
				return null;
			}
			AssetBundle assetBundle = AssetBundle.LoadFromFile(path);
			if (assetBundle != null)
			{
				return assetBundle;
			}
			return null;
		}

		[NoToLua]
		public static string GetPackName(string str)
		{
			string regexStr = "(?<=\\\\)[^\\\\\\.]+$";
			return StringTools.GetFirstMatch(str, regexStr);
		}

		[NoToLua]
		public static string GetTableName(string str)
		{
			string regexStr = "(?<=\\\\)[^\\\\\\.]+(?=\\.)";
			return StringTools.GetFirstMatch(str, regexStr);
		}

		[NoToLua]
		public static string GetFileName(string str)
		{
			string regexStr = "(?<=\\\\)[^\\\\]+$|(?<=/)[^/]+$";
			return StringTools.GetFirstMatch(str, regexStr);
		}

		[NoToLua]
		public static string GetExName(string str)
		{
			string regexStr = "(?<=\\\\[^\\\\]+.)[^\\\\.]+$|(?<=/[^/]+.)[^/.]+$";
			return StringTools.GetFirstMatch(str, regexStr);
		}

		[NoToLua]
		public static string RemoveExName(string str)
		{
			string result = str;
			string regexStr = "[^\\.]+(?=\\.)";
			string firstMatch = StringTools.GetFirstMatch(str, regexStr);
			if (!string.IsNullOrEmpty(firstMatch))
			{
				result = firstMatch;
			}
			return result;
		}

		private const string SAVE_PATH = "savePath.txt";
	}
}
