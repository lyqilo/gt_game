using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using BuildConfig;
using LuaFramework;
using UnityEditor;
using UnityEngine;
using Debug = UnityEngine.Debug;

namespace BuildTool
{
    public enum BuildType
    {
        Type32,
        Type64
    }

    public class BuildTool
    {
        public static string LuaDir = $"{Application.dataPath}/ThirdParty/LuaFramework/Lua";
        public static string ToluaDir = $"{Application.dataPath}/ThirdParty/LuaFramework/ToLua/Lua";
        public static string PackDirPath = $"{Application.dataPath}/../______________________大厅资源更新包/";
        public static string TempLuaDir = $"{Application.dataPath}/TempLua/";
        public static string LuaAssetName = "luascript.unity3d";
        public static string ExtName = ".unity3d";
        public static BuildType LuaBuildType = BuildType.Type32;
        public static BuildAssetBundleOptions buildAssetBundleOptions = BuildAssetBundleOptions.ChunkBasedCompression;

        private static string md5file(string file)
        {
            string result;
            try
            {
                FileStream fileStream = new FileStream(file, FileMode.Open);
                MD5 md = new MD5CryptoServiceProvider();
                byte[] array = md.ComputeHash(fileStream);
                fileStream.Close();
                StringBuilder stringBuilder = new StringBuilder();
                for (int i = 0; i < array.Length; i++)
                {
                    stringBuilder.Append(array[i].ToString("x2"));
                }

                result = stringBuilder.ToString();
            }
            catch (Exception ex)
            {
                throw new Exception("md5file() fail, error:" + ex.Message);
            }

            return result;
        }


        public static void CopyBuildBat(string path, string tempDir)
        {
            bool flag = BuildTool.LuaBuildType == BuildType.Type32;
            if (flag)
            {
                File.Copy($"{path}/LuaEncoder/Luajit/Build.bat", $"{tempDir}/Build.bat", true);
            }
            else
            {
                bool flag2 = BuildTool.LuaBuildType == BuildType.Type64;
                if (flag2)
                {
                    File.Copy($"{path}/LuaEncoder/Luajit64/Build.bat", $"{tempDir}/Build.bat", true);
                }
            }
        }


        public static void CopyLuaBytesFiles(string sourceDir, string destDir, bool isOut = true,
            string searchPattern = "*.lua", SearchOption option = SearchOption.AllDirectories)
        {
            bool flag = !Directory.Exists(sourceDir);
            if (!flag)
            {
                string[] files = Directory.GetFiles(sourceDir, searchPattern, option);
                int num = sourceDir.Length;
                bool flag2 = sourceDir[num - 1] == '/' || sourceDir[num - 1] == '\\';
                if (flag2)
                {
                    num--;
                }

                for (int i = 0; i < files.Length; i++)
                {
                    string text = files[i].Remove(0, num).Replace("\\", "_");
                    text = (isOut ? "outlua" : "lua") + text;
                    string destFileName = $"{destDir}/{text}";
                    File.Copy(files[i], destFileName, true);
                }
            }
        }
        public static void BuildLua()
        {
            bool flag2 = Directory.Exists($"{BuildTool.TempLuaDir}Out");
            if (flag2)
            {
                Directory.Delete($"{BuildTool.TempLuaDir}Out", true);
            }

            Directory.CreateDirectory(BuildTool.TempLuaDir);
            string text = Application.dataPath.Replace('\\', '/');
            text = text.Substring(0, text.LastIndexOf('/'));
            BuildTool.CopyBuildBat(text, BuildTool.TempLuaDir);
            BuildTool.CopyLuaBytesFiles(BuildTool.LuaDir, BuildTool.TempLuaDir, false, "*.lua",
                SearchOption.AllDirectories);
            BuildTool.CopyLuaBytesFiles(BuildTool.ToluaDir, BuildTool.TempLuaDir, true, "*.lua",
                SearchOption.AllDirectories);
            Process process = Process.Start($"{BuildTool.TempLuaDir}/Build.bat");
            process.WaitForExit();
            AssetDatabase.Refresh();
        }

        public static void BuildLuaBundle(string sourceDir)
        {
            string[] files = Directory.GetFiles(sourceDir, "*.bytes");
            string luaAssetName = BuildTool.LuaAssetName;
            Debug.Log(luaAssetName);
            for (int i = 0; i < files.Length; i++)
            {
                string text = files[i].Replace(Application.dataPath, "Assets").Replace("\\", "/");
                AssetImporter atPath = AssetImporter.GetAtPath(text);
                bool flag = atPath;
                if (flag)
                {
                    atPath.assetBundleName = luaAssetName;
                    atPath.assetBundleVariant = null;
                }
            }
        }


        private static void ClearOldBuildTool(string path)
        {
            string[] files = Directory.GetFiles(path, "*" + BuildTool.ExtName, SearchOption.AllDirectories);
            string[] allAssetBundleNames = AssetDatabase.GetAllAssetBundleNames();
            Dictionary<string, bool> dictionary = new Dictionary<string, bool>();
            for (int i = 0; i < allAssetBundleNames.Length; i++)
            {
                dictionary.Add(allAssetBundleNames[i], true);
            }

            foreach (string text in files)
            {
                string fileNameWithoutExtension = Path.GetFileNameWithoutExtension(text);
                bool flag = !dictionary.ContainsKey(fileNameWithoutExtension);
                if (flag)
                {
                    string path2 = text.Replace(BuildTool.ExtName, ".meta");
                    string path3 = text + ".manifest";
                    string path4 = text + ".manifest.meta";
                    File.Delete(text);
                    File.Delete(path2);
                    File.Delete(path3);
                    File.Delete(path4);
                }
            }

            AssetDatabase.Refresh();
        }


        private static FilesData CreateFileData(string abDirPath, string streamDirPath, bool isBase)
        {
            AppVersion appVer = new AppVersion(Application.version, isBase);
            string[] files = Directory.GetFiles(abDirPath, "*" + BuildTool.ExtName, SearchOption.AllDirectories);
            float num = (float) files.Length;
            float num2 = 0f;
            List<ResData> list = new List<ResData>();
            foreach (string text in files)
            {
                ResData resData = new ResData();
                resData.ResName = Path.GetFileName(text);
                resData.ResState = ResUpdateState.FirstExtract;
                string text2 = text.Replace("\\", "/");
                resData.ResPath = text2.Replace(abDirPath, "");
                resData.ResMD5 = BuildTool.md5file(text2);
                FileInfo fileInfo = new FileInfo(text2);
                resData.ResSize = fileInfo.Length;
                string str = string.Concat(new string[]
                {
                    "[",
                    num2.ToString(),
                    "/",
                    num.ToString(),
                    "]\n"
                });
                bool flag = EditorUtility.DisplayCancelableProgressBar("拷贝文件中...", str + text2, num2 / num);
                bool flag2 = flag;
                if (flag2)
                {
                    break;
                }

                list.Add(resData);
                num2 += 1f;
            }

            EditorUtility.ClearProgressBar();
            FilesData filesData = new FilesData();
            filesData.InitData(appVer, list);
            string contents = JsonUtility.ToJson(filesData);
            File.WriteAllText(streamDirPath + "Files.txt", contents, Encoding.UTF8);
            contents = JsonUtility.ToJson(filesData);
            File.WriteAllText(Application.streamingAssetsPath + "/Files.txt", contents, Encoding.UTF8);
            return filesData;
        }


        private static void CopyABFile(string abDirPath, string streamDirPath, List<ResData> resDataList)
        {
            float num = (float) resDataList.Count;
            int num2 = 0;
            while ((float) num2 < num)
            {
                ResData resData = resDataList[num2];
                string text = abDirPath + resData.ResPath;
                string str = string.Concat(new string[]
                {
                    "[",
                    num2.ToString(),
                    "/",
                    num.ToString(),
                    "]\n"
                });
                bool flag = EditorUtility.DisplayCancelableProgressBar("拷贝文件中...", str + text, (float) num2 / num);
                bool flag2 = flag;
                if (flag2)
                {
                    break;
                }

                string destFileName = text.Replace(abDirPath, streamDirPath);
                CreateDirectoryFromFile(destFileName);
                File.Copy(text, destFileName);
                num2++;
            }

            AssetDatabase.Refresh();
            EditorUtility.ClearProgressBar();
        }

        public static void CreateDirectoryFromFile(string path)
        {
            path = path.Replace('\\', '/');
            int num = path.LastIndexOf('/');
            if (num >= 0)
            {
                path = path.Substring(0, num);
                Directory.CreateDirectory(path);
            }
        }


        public static void BuildAppBuildTool()
        {
            string streamingAssetsPath = Application.streamingAssetsPath;
            bool flag = !Directory.Exists(streamingAssetsPath);
            if (flag)
            {
                Directory.CreateDirectory(streamingAssetsPath);
            }

            bool flag2 = Directory.Exists(BuildTool.TempLuaDir);
            if (flag2)
            {
                Directory.Delete(BuildTool.TempLuaDir, true);
            }

            Directory.CreateDirectory(BuildTool.TempLuaDir);
            string text = Application.dataPath.Replace('\\', '/');
            text = text.Substring(0, text.LastIndexOf('/'));
            BuildTool.CopyBuildBat(text, BuildTool.TempLuaDir);
            BuildTool.CopyLuaBytesFiles(BuildTool.LuaDir, BuildTool.TempLuaDir, false, "*.lua",
                SearchOption.AllDirectories);
            BuildTool.CopyLuaBytesFiles(BuildTool.ToluaDir, BuildTool.TempLuaDir, true, "*.lua",
                SearchOption.AllDirectories);
            Process process = Process.Start($"{BuildTool.TempLuaDir}/Build.bat");
            process.WaitForExit();
            AssetDatabase.Refresh();
            BuildTool.BuildLuaBundle($"{BuildTool.TempLuaDir}Out/");
            AssetDatabase.Refresh();


            //BuildTool.ClearOldBuildTool(streamingAssetsPath);

            // string path = "E:/3Dyuyule/LuaFramework_UGUI-master/Assets/Test";
            BuildPipeline.BuildAssetBundles(streamingAssetsPath, BuildTool.buildAssetBundleOptions,
                EditorUserBuildSettings.activeBuildTarget);
            AssetDatabase.Refresh();

            // string fileName = Path.GetFileName(streamingAssetsPath);
            // string sourceFileName = streamingAssetsPath + "/" + fileName;
            // File.Move(sourceFileName, streamingAssetsPath + "/manifest" + BuildTool.ExtName);
            Directory.Delete(BuildTool.TempLuaDir,true);
            AssetDatabase.Refresh();

            Debug.Log($"AssetsBundle打包完毕,文件存放在路劲{streamingAssetsPath}下");
            string path = $"{Application.streamingAssetsPath}/{LuaAssetName}";
            string newpath = $"{Application.dataPath}/{LuaAssetName}";
            MD5Helper.SamplyDESEn(path, newpath, MD5Helper.FileKey);
        }


        public static void BuildAppPackageRes()
        {
            Debug.Log(string.Format("开始基础包资源构建流程,基础版本号：{0}", Application.version));
            BuildTool.BuildAppBuildTool();
            AssetDatabase.Refresh();
            string text = BuildTool.PackDirPath + Application.version + "/";
            bool flag = Directory.Exists(text);
            if (flag)
            {
                Directory.Delete(text, true);
            }

            Directory.CreateDirectory(text);
            string text2 = Application.streamingAssetsPath + "/";
            bool flag2 = !Directory.Exists(text2);
            if (flag2)
            {
                Directory.CreateDirectory(text2);
            }

            FilesData filesData = BuildTool.CreateFileData(text2, "E:/U3d/LuaFramework_UGUI-master/Assets/Test/", true);
            BuildTool.CopyABFile(text2, text, filesData.ResDataList);
            Debug.Log(string.Format("基础包资源构建流程完毕路径为：{0}", text));

            AssetDatabase.Refresh();
        }


        public static void BuildAppUpdatePackageRes(string targetPath)
        {
            string path = targetPath + "/Files.txt";
            bool flag = !File.Exists(path);
            if (flag)
            {
                EditorUtility.DisplayDialog("错误", "目标文件夹没有版本管理文件,无法进行增量更新包的构建！！", "Cancel");
            }
            else
            {
                string text = File.ReadAllText(path);
                FilesData filesData = JsonUtility.FromJson<FilesData>(text);
                bool flag2 = !filesData.AppVersion.IsBase;
                if (flag2)
                {
                    EditorUtility.DisplayDialog("错误", "目标文件夹不是基础版本,无法进行增量更新包的构建！！", "Cancel");
                }
                else
                {
                    AppVersion appVersion = new AppVersion(Application.version, false);
                    AppVersion appVersion2 = filesData.AppVersion;
                    bool flag3 = appVersion.MainVersion != appVersion2.MainVersion ||
                                 appVersion.SubVersion != appVersion2.SubVersion ||
                                 appVersion.DataVersion <= appVersion2.DataVersion;
                    if (flag3)
                    {
                        EditorUtility.DisplayDialog("错误", "当前版本与目标版本版本不连续,无法进行增量更新包的构建！！", "Cancel");
                    }
                    else
                    {
                        BuildTool.BuildAppBuildTool();
                        AssetDatabase.Refresh();
                        string streamingAssetsPath = Application.streamingAssetsPath;
                        string text2 = BuildTool.PackDirPath + Application.version + "/";
                        bool flag4 = Directory.Exists(text2);
                        if (flag4)
                        {
                            Directory.Delete(text2, true);
                        }

                        Directory.CreateDirectory(text2);
                        FilesData filesData2 = BuildTool.CreateFileData(streamingAssetsPath, text2, false);
                        filesData.OnAfterDeserialize();
                        List<ResData> list = new List<ResData>();
                        foreach (ResData resData in filesData2.ResDataList)
                        {
                            ResData resData2 = null;
                            filesData.ResDataMap.TryGetValue(resData.ResName, out resData2);
                            bool flag5 = resData2 != null;
                            if (flag5)
                            {
                                bool flag6 = resData.ResMD5 != resData2.ResMD5;
                                if (flag6)
                                {
                                    list.Add(resData);
                                }
                            }
                            else
                            {
                                list.Add(resData);
                            }
                        }

                        BuildTool.CopyABFile(streamingAssetsPath, text2, list);
                    }
                }
            }
        }
    }
}