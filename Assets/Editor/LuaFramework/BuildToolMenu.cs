using LuaFramework;
using System.IO;
using UnityEditor;
using UnityEngine;
using LitJson;
using System.Text;
using Common;

namespace BuildTool
{
    public class BuildToolMenu
    {
        [MenuItem("Build/PackTool/option 1.打包现版本的资源基础包", false, 1)]
        private static void BuildAppPackageRes()
        {
#if BUILD64
            BuildTool.LuaBuildType = BuildType.Type64;
#else
            BuildTool.LuaBuildType = BuildType.Type32;
#endif
            BuildTool.BuildAppPackageRes();
        }

        [MenuItem("Build/PackTool/option 2.打包目标版本的增量更新包", false, 1)]
        private static void BuildAppUpdatePackageRes()
        {
            var targetPath = EditorUtility.OpenFolderPanel("选择需要增量更新的基础版本的目录", "", "");
            BuildTool.BuildAppUpdatePackageRes(targetPath);
        }

        [MenuItem("Build/清空流数据文件夹", false, 100)]
        private static void ClearStream()
        {
            EditorUtility.ClearProgressBar();
            if (Directory.Exists(Application.streamingAssetsPath))
                Directory.Delete(Application.streamingAssetsPath, true);
            Directory.CreateDirectory(Application.streamingAssetsPath);
            AssetDatabase.Refresh();
        }

        [MenuItem("Build/PackTool/打包现版本AssetsBundle", false, 101)]
        private static void BuildAppBuildTool()
        {
#if BUILD64
            BuildTool.LuaBuildType = BuildType.Type64;
#else
            BuildTool.LuaBuildType = BuildType.Type32;
#endif
            BuildTool.BuildAppBuildTool();
            if (EditorUserBuildSettings.activeBuildTarget == BuildTarget.Android)
            {
                AddSpriteEdit.BuildAndroid();
            }
            else if (EditorUserBuildSettings.activeBuildTarget == BuildTarget.iOS)
            {
                AddSpriteEdit.BuildIOS();
            }
            else
            {
                AddSpriteEdit.BuildWindows();
            }
        }

        [MenuItem("Assets/生成md5")]
        private static void MD5()
        {
            Object obj = Selection.activeObject;
            string path = AssetDatabase.GetAssetPath(obj);

            string md5 = Util.md5file(path);
            FileInfo info = new FileInfo(path);
            Debug.LogError("MD5= " + md5 + " Size= " + info.Length);
        }

        [MenuItem("Assets/生成md5文件")]
        private static void MD5File()
        {
            Object obj = Selection.activeObject;
            string path = AssetDatabase.GetAssetPath(obj);
            string[] files = Directory.GetFiles(path, "*", SearchOption.AllDirectories);

            ValueConfiger valueConfiger = new ValueConfiger();
            valueConfiger.JsonData = new System.Collections.Generic.Dictionary<string, BaseValueConfigerJson>();
            valueConfiger.AuthCode = "SJYT20175638D2893M753029039V32f700";
            valueConfiger.Version = 100;
            valueConfiger.Extend = null;
            valueConfiger.UpdateUrl = null;
            valueConfiger.AuditPak = null;
            foreach (string p in files)
            {

                string fileNameExtension = Path.GetExtension(p);
                string valueConfigName = Path.GetFileName(p);

                if (fileNameExtension == ".meta" || fileNameExtension == ".txt" || valueConfigName == "ValueConfiger.json") continue;
                string text = p.Replace("\\", "/");
                FileInfo info = new FileInfo(text);
                BaseValueConfigerJson bj = new BaseValueConfigerJson();

                string fileName = Path.GetFileName(p);
                if (p.Contains("module"))
                {
                    bj.moduleName = fileName.RemoveSuffix();
                    fileName = text.Replace("Assets/StreamingAssets/", "");
                }
                else
                {
                    bj.moduleName = "skinversion";
                }

                bj.dirPath = fileName;
                bj.crc = 0;
                bj.md5 = Util.md5file(text);
                bj.hash = Util.md5file(text);
                bj.version = 0;
                bj.size = info.Length.ToString();
                valueConfiger.Add(fileName, bj);
            }
            string json = JsonMapper.ToJson(valueConfiger);

            if (File.Exists(Application.streamingAssetsPath + "/ValueConfiger.json"))
            {
                File.Delete(Application.streamingAssetsPath + "/ValueConfiger.json");
            }
            File.WriteAllText(Application.streamingAssetsPath + "/ValueConfiger.json", json);

            string buildTarget = EditorUserBuildSettings.activeBuildTarget.ToString();
            string buildPath = BuildTool.PackDirPath + buildTarget;
            string hallResPath = BuildTool.PackDirPath + buildTarget + "/skinversion";
            bool flag = Directory.Exists(buildPath);
            if (flag)
            {
                Directory.Delete(buildPath, true);
            }
            Directory.CreateDirectory(buildPath);
            string[] exArray = new string[] { "meta", "txt" };
            FileHelper.CopyDirectory(Application.streamingAssetsPath, hallResPath, null, exArray);
            AssetDatabase.Refresh();
        }

        [MenuItem("Assets/以文件夹为前缀批量命名", false, 72)]
        public static void ChangeFilesName()
        {
            //Object o = Selection.activeObject;
            //string path = AssetDatabase.GetAssetPath(o);

            //List<string> lst = FileHelper.GetAllFilesExcept(path, new string[] { "meta" });

            //foreach (string text in lst)
            //{
            //    string name = FileHelper.GetFileName(text);
            //    string newName = o.name + "_" + name;

            //    int index = text.LastIndexOf(@"\");
            //    string p = text.Substring(0, index + 1) + newName;

            //    File.Move(text, p);
            //}
            //AssetDatabase.Refresh();

        }

    }

}

