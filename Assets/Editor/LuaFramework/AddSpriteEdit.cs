using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using BuildTool;
using Common;
using LitJson;
using LuaFramework;
using TMPro;
using UnityEditor;
using UnityEditor.Build;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.U2D;
using UnityEngine.UI;
using YooAsset;
using YooAsset.Editor;
using Debug = UnityEngine.Debug;
using Object = UnityEngine.Object;
using Random = UnityEngine.Random;

public class AddSpriteEdit : EditorWindow, IActiveBuildTargetChanged
{
    [MenuItem("Tools/AddSprite")]
    public static void AddSprite()
    {
        GameObject obj = Selection.activeGameObject;
        SpriteAtlas spriteAtlas = Resources.Load<SpriteAtlas>("Fish");
        Add(obj.transform, spriteAtlas);
    }

    static void Add(Transform trans, SpriteAtlas atlas)
    {
        DebugTool.LogError(atlas.spriteCount);
        for (int i = 0; i < trans.childCount; i++)
        {
            EditorUtility.DisplayProgressBar("处理中>>>", trans.GetChild(i).name, i / (float) trans.childCount);
            Sprite sprite = Resources.Load<Sprite>("Sprite/" + trans.GetChild(i).name);
            if (sprite == null) continue;
            SpriteRenderer render = trans.GetChild(i).GetComponent<SpriteRenderer>();
            if (render == null) continue;
            render.sprite = sprite;
        }

        EditorUtility.ClearProgressBar();
    }

    [MenuItem("Tools/AddChildSprite")]
    public static void AddChildSprite()
    {
        Transform trans = Selection.activeTransform;
        for (int i = 0; i < trans.childCount; i++)
        {
            trans.GetChild(i).name = trans.name + "_" + i;
            trans.GetChild(i).GetComponent<Image>().sprite =
                AssetDatabase.LoadAssetAtPath<Sprite>("Assets/Sprite/" + trans.GetChild(i).name + ".png");
        }
    }

    [MenuItem("Tools/AddChildSpriteNormal")]
    public static void AddChildSpriteNormal()
    {
        Transform trans = Selection.activeTransform;
        for (int i = 0; i < trans.childCount; i++)
        {
            trans.GetChild(i).name = trans.name + i + "_" + i;
            trans.GetChild(i).GetComponent<Image>().sprite =
                AssetDatabase.LoadAssetAtPath<Sprite>("Assets/Sprite/" + trans.GetChild(i).name + ".png");
        }
    }

    [MenuItem("Tools/AddChildSpriteRevert")]
    public static void AddChildSpriteRevert()
    {
        Transform trans = Selection.activeTransform;
        for (int i = 0; i < trans.childCount; i++)
        {
            trans.GetChild(i).name = trans.name + (trans.childCount - i - 1) + "_" + i;
            trans.GetChild(i).GetComponent<Image>().sprite =
                AssetDatabase.LoadAssetAtPath<Sprite>("Assets/Sprite/" + trans.GetChild(i).name + ".png");
        }
    }

    [MenuItem("Tools/CreateNewLua")]
    public static void CreateNewLua()
    {
        Object[] objects = Selection.GetFiltered(typeof(Object), SelectionMode.Assets); //获取选择文件夹
        for (int i = 0; i < objects.Length; i++)
        {
            string dirPath = AssetDatabase.GetAssetPath(objects[i]).Replace("\\", "/");
            if (!Directory.Exists(dirPath))
            {
                EditorUtility.DisplayDialog("错误", "选择正确文件夹！", "好的");
                continue;
            }

            HalveSprite(dirPath);
        }

        EditorUtility.ClearProgressBar();
        EditorUtility.DisplayDialog("成功", "处理完成！", "好的");
    }

    private static void HalveSprite(string dirPath)
    {
        string[] files = Directory.GetFiles(dirPath, "*.*", SearchOption.AllDirectories);
        for (int i = 0; i < files.Length; i++)
        {
            string filePath = files[i];
            filePath = filePath.Replace("\\", "/");

            if (filePath.EndsWith(".meta")) continue;
            EditorUtility.DisplayProgressBar("处理中>>>", filePath, i / (float) files.Length);
            FileInfo info = new FileInfo(filePath);
            string[] arr = filePath.Split('.');
            info.MoveTo(arr[0] + ".lua");
        }

        AssetDatabase.Refresh();
    }

    [MenuItem("Tools/ChangeEncoding")]
    static void ChangeEncoding()
    {
        Object[] objects = Selection.GetFiltered(typeof(Object), SelectionMode.Assets); //获取选择文件夹
        for (int i = 0; i < objects.Length; i++)
        {
            string dirPath = AssetDatabase.GetAssetPath(objects[i]).Replace("\\", "/");
            if (!Directory.Exists(dirPath))
            {
                EditorUtility.DisplayDialog("错误", "选择正确文件夹！", "好的");
                continue;
            }

            string[] files = Directory.GetFiles(dirPath, "*.*", SearchOption.AllDirectories);
            for (int j = 0; j < files.Length; j++)
            {
                string filePath = files[j];
                filePath = filePath.Replace("\\", "/");

                if (filePath.EndsWith(".meta")) continue;
                EditorUtility.DisplayProgressBar("处理中>>>", filePath, i / (float) files.Length);
                string[] arr = filePath.Split('.');
                string str = File.ReadAllText(filePath);
                File.WriteAllText(arr[0] + ".lua", str);
                File.Delete(filePath);
            }
        }

        EditorUtility.ClearProgressBar();
        EditorUtility.DisplayDialog("成功", "处理完成！", "好的");
        AssetDatabase.Refresh();
    }

    static List<AssetBundleBuild> maps = new List<AssetBundleBuild>();
    static string buildPath = "";
    static string m_bundlename = "";

    [MenuItem("Tools/BuildAndroidBundle")]
    public static void BuildAndroid()
    {
        HandleAssetBundle(Application.streamingAssetsPath + "/module02");
        BuildPipeline.BuildAssetBundles(buildPath, maps.ToArray(), BuildAssetBundleOptions.ChunkBasedCompression,
            BuildTarget.Android);
        AssetDatabase.Refresh();
        DeleteOther();
        AssetDatabase.Refresh();
    }

    [MenuItem("Tools/BuildIOSBundle")]
    public static void BuildIOS()
    {
        HandleAssetBundle(Application.streamingAssetsPath + "/module02");
        BuildPipeline.BuildAssetBundles(buildPath, maps.ToArray(), BuildAssetBundleOptions.ChunkBasedCompression,
            BuildTarget.iOS);
        AssetDatabase.Refresh();
        DeleteOther();
        AssetDatabase.Refresh();
    }

    [MenuItem("Tools/BuildWindowsBundle")]
    public static void BuildWindows()
    {
        HandleAssetBundle(Application.streamingAssetsPath + "/module02");
        BuildPipeline.BuildAssetBundles(buildPath, maps.ToArray(), BuildAssetBundleOptions.ChunkBasedCompression,
            BuildTarget.StandaloneWindows64);
        AssetDatabase.Refresh();
        DeleteOther();
        AssetDatabase.Refresh();
    }

    static void HandleAssetBundle(string _path)
    {
        m_bundlename = "";
        maps.Clear();
        buildPath = Application.streamingAssetsPath;
        string scenePath = Application.dataPath.ToLower() + "/Scene/";
        string[] dirs = Directory.GetFiles(scenePath, "*", SearchOption.AllDirectories);
        StringBuilder path = new StringBuilder();
        for (int i = 0; i < dirs.Length; i++)
        {
            if (dirs[i].EndsWith(".meta")) continue;
            string bundlename = dirs[i].Replace(scenePath, string.Empty);
            bundlename = bundlename.Replace("\\", "/");
            string[] arr = bundlename.Split('/');
            string bun = arr[arr.Length - 1];
            string bunname = bun.Replace(".unity", "");
            buildPath = buildPath + "/" + bunname;
            m_bundlename = bunname;
            if (!Directory.Exists(buildPath))
            {
                Directory.CreateDirectory(buildPath);
            }

            AssetDatabase.Refresh();
            if (File.Exists(buildPath + "/" + bunname + AppConst.ExtName))
            {
                File.Delete(buildPath + "/" + bunname + AppConst.ExtName);
            }

            AssetDatabase.Refresh();
            AddBuildMap(bunname + AppConst.ExtName, "*", "Assets/Scene");
        }
    }

    [MenuItem("Tools/BuildActiveTargetAssetBundle")]
    public static void BuildActiveTarget()
    {
        HandleAssetBundle(Application.streamingAssetsPath + "/module02");
        BuildPipeline.BuildAssetBundles(buildPath, maps.ToArray(), BuildAssetBundleOptions.ChunkBasedCompression,
            EditorUserBuildSettings.activeBuildTarget);
        AssetDatabase.Refresh();
        DeleteOther();
        AssetDatabase.Refresh();
        BuildAllScenes();
        AssetDatabase.Refresh();
    }

    static void AddBuildMap(string bundleName, string pattern, string path)
    {
        string[] files = Directory.GetFiles(path, pattern);
        if (files.Length == 0)
        {
            DebugTool.Log(string.Format("路径:{0}，没有包含{1}", path, pattern));
            return;
        }

        for (int i = 0; i < files.Length; i++)
        {
            files[i] = files[i].Replace('\\', '/');
        }

        AssetBundleBuild build = new AssetBundleBuild();
        build.assetBundleName = bundleName;
        build.assetNames = files;
        maps.Add(build);
    }

    static void DeleteOther()
    {
        AssetDatabase.RemoveUnusedAssetBundleNames();
        if (m_bundlename == "") return;
        DirectoryInfo info = new DirectoryInfo(Application.streamingAssetsPath + "/" + m_bundlename);
        FileInfo[] files = info.GetFiles();
        for (int i = 0; i < files.Length; i++)
        {
            FileInfo _info = files[i];
            if (_info.FullName.EndsWith(".meta")) continue;
            if (!_info.FullName.Contains(AppConst.ExtName))
            {
                _info.Delete();
                continue;
            }

            // if (_info.FullName.Contains(m_bundlename) && _info.FullName.Contains(".manifest"))
            // {
            //     _info.Delete();
            //     continue;
            // }
            if (_info.Name.Contains(m_bundlename) && _info.Name.EndsWith(".manifest"))
            {
                _info.Delete();
            }
        }

        SaveCsConfig();
        Debug.LogError("Bundle build Success");
    }

    [MenuItem("Tools/SaveCsConfig")]
    public static void SaveCsConfig()
    {
        TextAsset asset = Resources.Load<TextAsset>("CSConfiger");
        string str = Util.EncryptDES(asset.text, "89219417");
        Debug.LogError(str);
        string path = Application.streamingAssetsPath + "/" + "CSConfiger.json";
        if (File.Exists(path))
        {
            File.Delete(path);
        }

        File.WriteAllText(path, str);
        AssetDatabase.Refresh();
    }

    [MenuItem("Tools/SaveHttpConfig")]
    public static void SaveHttpConfig()
    {
        string str1 = File.ReadAllText($"{Application.dataPath}/HttpConfiger.json");
        string str = MD5Helper.Encrypt(str1, "Http");
        Debug.LogError(str);
        string path = Application.dataPath + "/../HttpConfiger.json";
        if (File.Exists(path))
        {
            File.Delete(path);
        }

        File.WriteAllText(path, str);
        AssetDatabase.Refresh();
    }

    private static void MD5File()
    {
        string[] files = Directory.GetFiles(Application.streamingAssetsPath, "*", SearchOption.AllDirectories);

        ValueConfiger valueConfiger = new ValueConfiger();
        valueConfiger.JsonData = new Dictionary<string, BaseValueConfigerJson>();
        valueConfiger.AuthCode = "SJYT20175638D2893M753029039V32f700";
        valueConfiger.Version = 100;
        valueConfiger.Extend = null;
        valueConfiger.UpdateUrl = null;
        valueConfiger.AuditPak = null;
        foreach (string p in files)
        {
            string fileNameExtension = Path.GetExtension(p);
            string valueConfigName = Path.GetFileName(p);

            if (fileNameExtension == ".meta" || fileNameExtension == ".txt" ||
                valueConfigName == "ValueConfiger.json") continue;
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
        string buildPath = BuildTool.BuildTool.PackDirPath + buildTarget;
        string hallResPath = BuildTool.BuildTool.PackDirPath + buildTarget + "/skinversion";
        bool flag = Directory.Exists(buildPath);
        if (flag)
        {
            Directory.Delete(buildPath, true);
        }

        Directory.CreateDirectory(buildPath);
        string[] exArray = {"meta", "txt"};
        FileHelper.CopyDirectory(Application.streamingAssetsPath, hallResPath, null, exArray);
        AssetDatabase.Refresh();

        BackUpRes();
    }

    [MenuItem("Tools/复制替换沙盒bundle")]
    public static void CopyBundleFileToP()
    {
        bool iscopySuccess = CopyDirectory(Application.streamingAssetsPath, PathHelp.AppHotfixResPath, true);
    }

    /// <summary>
    /// 文件夹下所有内容copy
    /// </summary>
    /// <param name="SourcePath">要Copy的文件夹</param>
    /// <param name="DestinationPath">要复制到哪个地方</param>
    /// <param name="overwriteexisting">是否覆盖</param>
    /// <returns></returns>
    private static bool CopyDirectory(string SourcePath, string DestinationPath, bool overwriteexisting)
    {
        bool ret = false;
        try
        {
            SourcePath = SourcePath.EndsWith(@"\") ? SourcePath : SourcePath + @"\";
            DestinationPath = DestinationPath.EndsWith(@"\") ? DestinationPath : DestinationPath + @"\";

            if (Directory.Exists(SourcePath))
            {
                if (Directory.Exists(DestinationPath) == false)
                    Directory.CreateDirectory(DestinationPath);

                foreach (string fls in Directory.GetFiles(SourcePath))
                {
                    FileInfo flinfo = new FileInfo(fls);
                    flinfo.CopyTo(DestinationPath + flinfo.Name, overwriteexisting);
                }

                foreach (string drs in Directory.GetDirectories(SourcePath))
                {
                    DirectoryInfo drinfo = new DirectoryInfo(drs);
                    if (CopyDirectory(drs, DestinationPath + drinfo.Name, overwriteexisting) == false)
                        ret = false;
                }
            }

            ret = true;
        }
        catch (Exception ex)
        {
            Debug.Log(ex.Message);
            ret = false;
        }

        return ret;
    }

    public static string copyPath = "G:/U3Dgame/BoleRes";

    public static bool isswitch;

    public int callbackOrder
    {
        get { return 0; }
    }

    [MenuItem("Tools/BuildAllBundle")]
    public static void BuildAllBundle()
    {
        isswitch = true;
        copyPath = Application.dataPath.Replace("Assets", "");
        copyPath = copyPath + "BoleUpdateRes";
        Debug.LogError(copyPath);

        EditorUserBuildSettings.SwitchActiveBuildTarget(BuildTargetGroup.Android, BuildTarget.Android);
    }

    [MenuItem("Tools/BuildLua")]
    public static void BuildLua()
    {
#if BUILD64
        BuildTool.BuildTool.LuaBuildType = BuildType.Type64;
#else
        BuildTool.BuildTool.LuaBuildType = BuildType.Type32;
#endif
        BuildTool.BuildTool.BuildAppBuildTool();
    }

    public static void BuildTargetBundle(BuildTarget target)
    {
        if (Directory.Exists(Application.streamingAssetsPath))
        {
            Directory.Delete(Application.streamingAssetsPath, true);
        }

        AssetDatabase.Refresh();
        Debug.Log(target.ToString());
        switch (target)
        {
            case BuildTarget.Android:
                CopyDirectory(copyPath + "/android/StreamingAssets", Application.streamingAssetsPath, true);
                Debug.Log("复制android源文件成功");
                AssetDatabase.Refresh();
                BuildTool.BuildTool.LuaBuildType = BuildType.Type32;
                BuildTool.BuildTool.LuaAssetName = "luascript.unity3d";
                break;
            case BuildTarget.iOS:
                CopyDirectory(copyPath + "/ios/StreamingAssets", Application.streamingAssetsPath, true);
                Debug.Log("复制IOS源文件成功");
                AssetDatabase.Refresh();
                BuildTool.BuildTool.LuaBuildType = BuildType.Type64;
                BuildTool.BuildTool.LuaAssetName = "luascript.unity3d";
                break;
            case BuildTarget.StandaloneWindows64:
                CopyDirectory(copyPath + "/win/StreamingAssets", Application.streamingAssetsPath, true);
                Debug.Log("复制Windows源文件成功");
                AssetDatabase.Refresh();
                BuildTool.BuildTool.LuaBuildType = BuildType.Type64;
                BuildTool.BuildTool.LuaAssetName = "luascript.unity3d";
                break;
        }

        BuildAppBuildTool(target);
        switch (target)
        {
            case BuildTarget.Android:
                BuildAndroid();
                break;
            case BuildTarget.iOS:
                BuildIOS();
                break;
            case BuildTarget.StandaloneWindows64:
                BuildWindows();
                break;
        }

        AssetDatabase.Refresh();
        SaveCsConfig();
        AssetDatabase.Refresh();
        if (File.Exists(Application.streamingAssetsPath + "/" + BuildTool.BuildTool.LuaAssetName + ".manifest"))
        {
            File.Delete(Application.streamingAssetsPath + "/" + BuildTool.BuildTool.LuaAssetName + ".manifest");
        }

        if (File.Exists(Application.streamingAssetsPath + "/StreamingAssets.manifest"))
        {
            File.Delete(Application.streamingAssetsPath + "/StreamingAssets.manifest");
        }

        if (File.Exists(Application.streamingAssetsPath + "/StreamingAssets"))
        {
            File.Delete(Application.streamingAssetsPath + "/StreamingAssets");
        }

        MD5File();
        AssetDatabase.Refresh();
    }

    public void OnActiveBuildTargetChanged(BuildTarget previousTarget, BuildTarget newTarget)
    {
        if (isswitch)
        {
            BuildTargetGroup group = BuildTargetGroup.Android;
            switch (newTarget)
            {
                case BuildTarget.Android:
                    group = BuildTargetGroup.Android;
                    break;
                case BuildTarget.iOS:
                    group = BuildTargetGroup.iOS;
                    break;
                case BuildTarget.StandaloneWindows64:
                    group = BuildTargetGroup.Standalone;
                    break;
            }

            BuildTargetBundle(newTarget);
            if (newTarget == BuildTarget.Android)
            {
                EditorUserBuildSettings.SwitchActiveBuildTarget(group, BuildTarget.iOS);
            }
            else if (newTarget == BuildTarget.iOS)
            {
                EditorUserBuildSettings.SwitchActiveBuildTarget(group, BuildTarget.StandaloneWindows64);
            }
            else if (newTarget == BuildTarget.StandaloneWindows64)
            {
                isswitch = false;
            }
        }
    }

    public static void BuildAppBuildTool(BuildTarget target)
    {
        string streamingAssetsPath = Application.streamingAssetsPath;
        bool flag = !Directory.Exists(streamingAssetsPath);
        if (flag)
        {
            Directory.CreateDirectory(streamingAssetsPath);
        }

        bool flag2 = Directory.Exists(BuildTool.BuildTool.TempLuaDir);
        if (flag2)
        {
            Directory.Delete(BuildTool.BuildTool.TempLuaDir, true);
        }

        Directory.CreateDirectory(BuildTool.BuildTool.TempLuaDir);
        string text = Application.dataPath.Replace('\\', '/');
        text = text.Substring(0, text.LastIndexOf('/'));
        BuildTool.BuildTool.CopyBuildBat(text, BuildTool.BuildTool.TempLuaDir);
        BuildTool.BuildTool.CopyLuaBytesFiles(BuildTool.BuildTool.LuaDir, BuildTool.BuildTool.TempLuaDir, false,
            "*.lua", SearchOption.AllDirectories);
        BuildTool.BuildTool.CopyLuaBytesFiles(BuildTool.BuildTool.ToluaDir, BuildTool.BuildTool.TempLuaDir, true,
            "*.lua", SearchOption.AllDirectories);
        Process process =
            Process.Start(BuildTool.BuildTool.TempLuaDir + "/Build.bat");
        process.WaitForExit();
        AssetDatabase.Refresh();
        BuildTool.BuildTool.BuildLuaBundle(BuildTool.BuildTool.TempLuaDir + "Out/");
        AssetDatabase.Refresh();


        //BuildTool.BuildTool.ClearOldBuildTool.BuildTool(streamingAssetsPath);

        // string path = "E:/3Dyuyule/LuaFramework_UGUI-master/Assets/Test";
        BuildPipeline.BuildAssetBundles(streamingAssetsPath, BuildTool.BuildTool.buildAssetBundleOptions, target);
        AssetDatabase.Refresh();

        // string fileName = Path.GetFileName(streamingAssetsPath);
        // string sourceFileName = streamingAssetsPath + "/" + fileName;
        // File.Move(sourceFileName, streamingAssetsPath + "/manifest" + BuildTool.BuildTool.ExtName);
        Directory.Delete(BuildTool.BuildTool.TempLuaDir, true);
        AssetDatabase.Refresh();

        Debug.Log(string.Format("AssetsBundle打包完毕,文件存放在路劲{0}下", streamingAssetsPath));
    }

    static ValueConfiger configer;
    static string gameConfig;

    [MenuItem("Assets/BuildOtherActiveBundle")]
    static void BuildActiveBundle()
    {
        Object obj = Selection.activeObject;
        gameConfig = Application.streamingAssetsPath + "/GameValueConfiger.json";
        if (File.Exists(gameConfig))
        {
            configer = JsonMapper.ToObject<ValueConfiger>(File.ReadAllText(gameConfig));
        }
        else
        {
            configer = default;
        }

        m_bundlename = "";
        string bundlename = obj.name.ToLower();
        Debug.LogError(bundlename);
        List<AssetBundleBuild> list = new List<AssetBundleBuild>();
        AssetBundleBuild build = new AssetBundleBuild();
        build.assetBundleName = bundlename;
        build.assetBundleVariant = "unity3d";
        build.assetNames = new[] {AssetDatabase.GetAssetPath(obj)};
        list.Add(build);
        buildPath = Application.streamingAssetsPath + "/temp";
        AssetDatabase.Refresh();
        if (Directory.Exists(buildPath))
        {
            Directory.Delete(buildPath, true);
        }

        Directory.CreateDirectory(buildPath);
        BuildPipeline.BuildAssetBundles(buildPath, list.ToArray(), BuildAssetBundleOptions.ChunkBasedCompression,
            EditorUserBuildSettings.activeBuildTarget);
        AssetDatabase.Refresh();
        string md5str = GetMD5HashFromFile(buildPath + "/" + bundlename + AppConst.ExtName);
        FileInfo info = new FileInfo(buildPath + "/" + bundlename + AppConst.ExtName);
        if (configer.JsonData.ContainsKey(bundlename + "/" + bundlename + AppConst.ExtName))
        {
            BaseValueConfigerJson json =
                configer.JsonData[bundlename + "/" + bundlename + AppConst.ExtName];
            json.md5 = md5str;
            json.hash = md5str;
            json.version = 0;
            json.size = info.Length.ToString();
            configer.JsonData[bundlename + "/" + bundlename + AppConst.ExtName] = json;
            DebugTool.Log("更新" + bundlename);
        }
        else
        {
            BaseValueConfigerJson json = new BaseValueConfigerJson();
            json.moduleName = bundlename;
            json.dirPath = bundlename + "/" + bundlename + AppConst.ExtName;
            json.crc = 0;
            json.hash = md5str;
            json.md5 = md5str;
            json.version = 0;
            json.size = info.Length.ToString();
            configer.JsonData.Add(bundlename + "/" + bundlename + AppConst.ExtName, json);
            DebugTool.Log("添加" + bundlename);
        }

        File.WriteAllText(gameConfig, JsonMapper.ToJson(configer));
        string newpath = Application.streamingAssetsPath + "/" + bundlename;
        if (Directory.Exists(newpath))
        {
            Directory.Delete(newpath, true);
        }

        Directory.CreateDirectory(newpath);
        File.Move(buildPath + "/" + bundlename + AppConst.ExtName, newpath + "/" + bundlename + AppConst.ExtName);
        Directory.Delete(buildPath, true);
        AssetDatabase.RemoveUnusedAssetBundleNames();
        AssetDatabase.Refresh();
        Debug.LogError("build " + bundlename + " Bundle Successd");
    }

    /// <summary>
    /// 计算文件的MD5校验
    /// </summary>
    /// <param name="fileName"></param>
    /// <returns></returns>
    public static string GetMD5HashFromFile(string fileName)
    {
        try
        {
            FileStream file = new FileStream(fileName, FileMode.Open);
            MD5 md5 = new MD5CryptoServiceProvider();
            byte[] retVal = md5.ComputeHash(file);
            file.Close();
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < retVal.Length; i++)
            {
                sb.Append(retVal[i].ToString("x2"));
            }

            return sb.ToString();
        }
        catch (Exception ex)
        {
            throw new Exception("GetMD5HashFromFile() fail,error:" + ex.Message);
        }
    }

    [MenuItem(("Tools/打包所有游戏场景"))]
    public static void BuildAllScenes()
    {
        AssetDatabase.RemoveUnusedAssetBundleNames();
        string _buildPath = Application.dataPath + "/../OtherSceneBundle_" +
                            EditorUserBuildSettings.activeBuildTarget;

        if (Directory.Exists(_buildPath))
        {
            Directory.Delete(_buildPath, true);
        }

        Directory.CreateDirectory(_buildPath);
        string[] files =
            Directory.GetFiles(Application.dataPath + "/OtherScene", "*.unity", SearchOption.AllDirectories);
        List<AssetBundleBuild> builds = new List<AssetBundleBuild>();
        string tempDir = Application.dataPath + "/TempScene";
        if (Directory.Exists(tempDir))
        {
            Directory.Delete(tempDir, true);
        }

        Directory.CreateDirectory(tempDir);
        for (int i = 0; i < files.Length; i++)
        {
            FileInfo info = new FileInfo(files[i]);
            string filename = Path.GetFileNameWithoutExtension(files[i]);
            string dist = tempDir + "/" + filename + info.Extension;
            info.CopyTo(dist);
        }

        AssetDatabase.Refresh();
        string[] _files =
            Directory.GetFiles(tempDir, "*.unity", SearchOption.AllDirectories);
        for (int i = 0; i < _files.Length; i++)
        {
            AssetImporter importer =
                AssetImporter.GetAtPath(_files[i].Replace("\\", "/").Replace(Application.dataPath, "Assets"));
            string filename = Path.GetFileNameWithoutExtension(_files[i]);
            importer.assetBundleName = filename + AppConst.ExtName;
            importer.assetBundleVariant = null;
        }

        AssetDatabase.Refresh();

        BuildPipeline.BuildAssetBundles(_buildPath,
            BuildAssetBundleOptions.ChunkBasedCompression, EditorUserBuildSettings.activeBuildTarget);
        AssetDatabase.Refresh();
        Directory.Delete(tempDir, true);
        AssetDatabase.RemoveUnusedAssetBundleNames();

        AssetDatabase.Refresh();
        DebugTool.Log("Build 场景bundle完成--" + _buildPath);
        gameConfig = Application.streamingAssetsPath + "/GameValueConfiger.json";
        if (File.Exists(gameConfig))
        {
            configer = JsonMapper.ToObject<ValueConfiger>(File.ReadAllText(gameConfig));
        }
        else
        {
            configer = default;
        }

        string[] bundles = Directory.GetFiles(_buildPath, "*.unity3d", SearchOption.AllDirectories);
        for (int i = 0; i < bundles.Length; i++)
        {
            FileInfo info = new FileInfo(bundles[i]);
            string bundlename = Path.GetFileNameWithoutExtension(bundles[i]);
            string md5str = GetMD5HashFromFile(_buildPath + "/" + bundlename + AppConst.ExtName);
            if (configer.JsonData.ContainsKey(bundlename + "/" + bundlename + AppConst.ExtName))
            {
                BaseValueConfigerJson json =
                    configer.JsonData[bundlename + "/" + bundlename + AppConst.ExtName];
                json.md5 = md5str;
                json.hash = md5str;
                json.version = 0;
                json.size = info.Length.ToString();
                configer.JsonData[bundlename + "/" + bundlename + AppConst.ExtName] = json;
                DebugTool.Log("更新" + bundlename);
            }
            else
            {
                BaseValueConfigerJson json = new BaseValueConfigerJson();
                json.moduleName = bundlename;
                json.dirPath = bundlename + "/" + bundlename + AppConst.ExtName;
                json.crc = 0;
                json.hash = md5str;
                json.md5 = md5str;
                json.version = 0;
                json.size = info.Length.ToString();
                configer.JsonData.Add(bundlename + "/" + bundlename + AppConst.ExtName, json);
                DebugTool.Log("添加" + bundlename);
            }
        }

        File.WriteAllText(gameConfig, JsonMapper.ToJson(configer));
        AssetDatabase.RemoveUnusedAssetBundleNames();
        AssetDatabase.Refresh();
        string[] bundlepath = Directory.GetFiles(_buildPath, "*", SearchOption.AllDirectories);
        for (int i = 0; i < bundlepath.Length; i++)
        {
            string ext = Path.GetExtension(bundlepath[i]);
            if (ext != ".unity3d")
            {
                File.Delete(bundlepath[i]);
            }
        }

        AssetDatabase.Refresh();

        string[] _bundlepath = Directory.GetFiles(_buildPath, "*.unity3d", SearchOption.AllDirectories);
        for (int i = 0; i < _bundlepath.Length; i++)
        {
            string bundlename = Path.GetFileNameWithoutExtension(_bundlepath[i]);
            string bundlefullname = Path.GetFileName(_bundlepath[i]);
            if (Directory.Exists(_buildPath + "/" + bundlename))
            {
                Directory.Delete(_buildPath + "/" + bundlename);
            }

            Directory.CreateDirectory(_buildPath + "/" + bundlename);
            File.Copy(_bundlepath[i], _buildPath + "/" + bundlename + "/" + bundlefullname);
            File.Delete(_bundlepath[i]);
        }

        AssetDatabase.Refresh();
    }

    [MenuItem("Tools/备份更新资源")]
    public static void BackUpRes()
    {
        string _buildPath = Application.dataPath + "/../OtherSceneBundle_" +
                            EditorUserBuildSettings.activeBuildTarget;
        string updateres = Application.dataPath + "/../UpdateRes/" +
                           EditorUserBuildSettings.activeBuildTarget.ToString().ToLower();
        string hallResPath = BuildTool.BuildTool.PackDirPath + EditorUserBuildSettings.activeBuildTarget +
                             "/skinversion";

        if (EditorUtility.DisplayDialog("提示", "是否需要备份StreamingAsset更新资源", "ok", "cancel"))
        {
            FileHelper.CopyDirectory(hallResPath, updateres + "/StreamingAssets");
        }

        AssetDatabase.Refresh();
        if (EditorUtility.DisplayDialog("提示", "是否备份所有游戏场景更新资源", "确定", "取消"))
        {
            FileHelper.CopyDirectory(_buildPath, updateres + "/games");
        }

        EditorUtility.DisplayDialog("提示", "备份资源完成", "确定");
    }

    [MenuItem("Tools/UpdateGameValueConfig")]
    public static void UpdateGameValueConfig()
    {
        string _buildPath = Application.dataPath + "/../OtherSceneBundle_" +
                            EditorUserBuildSettings.activeBuildTarget;
        gameConfig = Application.streamingAssetsPath + "/GameValueConfiger.json";
        if (File.Exists(gameConfig))
        {
            configer = JsonMapper.ToObject<ValueConfiger>(File.ReadAllText(gameConfig));
        }
        else
        {
            configer = default;
        }

        string[] bundles = Directory.GetFiles(_buildPath, "*.unity3d", SearchOption.AllDirectories);
        for (int i = 0; i < bundles.Length; i++)
        {
            FileInfo info = new FileInfo(bundles[i]);
            string bundlename = Path.GetFileNameWithoutExtension(bundles[i]);
            string md5str = GetMD5HashFromFile(_buildPath + "/" + bundlename + AppConst.ExtName);
            if (configer.JsonData.ContainsKey(bundlename + "/" + bundlename + AppConst.ExtName))
            {
                BaseValueConfigerJson json =
                    configer.JsonData[bundlename + "/" + bundlename + AppConst.ExtName];
                json.md5 = md5str;
                json.hash = md5str;
                json.version = 0;
                json.size = info.Length.ToString();
                configer.JsonData[bundlename + "/" + bundlename + AppConst.ExtName] = json;
                DebugTool.Log("更新" + bundlename);
            }
            else
            {
                BaseValueConfigerJson json = new BaseValueConfigerJson();
                json.moduleName = bundlename;
                json.dirPath = bundlename + "/" + bundlename + AppConst.ExtName;
                json.crc = 0;
                json.hash = md5str;
                json.md5 = md5str;
                json.version = 0;
                json.size = info.Length.ToString();
                configer.JsonData.Add(bundlename + "/" + bundlename + AppConst.ExtName, json);
                DebugTool.Log("添加" + bundlename);
            }
        }

        File.WriteAllText(gameConfig, JsonMapper.ToJson(configer));
        AssetDatabase.RemoveUnusedAssetBundleNames();
        AssetDatabase.Refresh();
        if (EditorUtility.DisplayDialog("提示", "是否需要生成MD5文件", "ok", "cancel"))
        {
            MD5File();
        }

        AssetDatabase.Refresh();
    }

    [MenuItem("Tools/CopyStreamingRes")]
    public static void CopyStreamingRes()
    {
        if (Directory.Exists(Application.streamingAssetsPath))
        {
            Directory.Delete(Application.streamingAssetsPath, true);
        }

        string plat = EditorUserBuildSettings.activeBuildTarget.ToString();
        DebugTool.LogError(plat);
        FileHelper.CopyDirectory($"{Application.dataPath}/../EnUpdateRes/{plat}/StreamingAssets",
            $"{Application.dataPath}/StreamingAssets");

        AssetDatabase.Refresh();
#if BUILD64
        BuildTool.BuildTool.LuaBuildType = BuildType.Type64;
#else
        BuildTool.BuildTool.LuaBuildType = BuildType.Type32;
#endif
        BuildTool.BuildTool.BuildAppBuildTool();
        HandleAssetBundle(Application.streamingAssetsPath + "/module02");
        AssetDatabase.Refresh();
        BuildPipeline.BuildAssetBundles(buildPath, maps.ToArray(), BuildAssetBundleOptions.ChunkBasedCompression,
            EditorUserBuildSettings.activeBuildTarget);

        string _path02 = $"{Application.streamingAssetsPath}/module02/module02.unity3d";
        string newpath02 = $"{Application.dataPath}/module02.unity3d";
        MD5Helper.SamplyDESEn(_path02, newpath02, MD5Helper.FileKey);

        AssetDatabase.Refresh();
        DeleteOther();
        AssetDatabase.Refresh();
//        MD5File();
        AssetDatabase.Refresh();
    }

    [MenuItem("Tools/BuildAllUpdateRes")]
    public static void BuildUpdateResources()
    {
        CopyStreamingRes();
        AssetDatabase.Refresh();
        BuildSceneAndPrefab();
        SaveCsConfig();
        AssetDatabase.Refresh();
        if (EditorUtility.DisplayDialog("提示", "是否需要生成MD5文件", "ok", "cancel"))
        {
            AddSpriteEdit.MD5File();
        }
    }

    public static void BuildSceneAndPrefab()
    {
        string[] files = Directory.GetFiles(Application.dataPath + "/Prefab", "*.prefab", SearchOption.AllDirectories);
        string temppath = Application.dataPath + "/TempPrefab";
        if (Directory.Exists(temppath))
        {
            Directory.Delete(temppath, true);
        }

        Directory.CreateDirectory(temppath);
        for (int i = 0; i < files.Length; i++)
        {
            File.Copy(files[i], temppath + "/" + Path.GetFileName(files[i]));
        }

        AssetDatabase.Refresh();
        files = Directory.GetFiles(temppath, "*.prefab", SearchOption.AllDirectories);
        if (!Directory.Exists(Application.streamingAssetsPath + "/module02"))
        {
            Directory.CreateDirectory(Application.streamingAssetsPath + "/module02");
        }

        Directory.CreateDirectory(Application.streamingAssetsPath + "/module02");
        if (File.Exists(Application.streamingAssetsPath + "/module02/pools" + AppConst.ExtName))
        {
            File.Delete(Application.streamingAssetsPath + "/module02/pools" + AppConst.ExtName);
        }

        for (int i = 0; i < files.Length; i++)
        {
            files[i] = files[i].Replace('\\', '/').Replace(Application.dataPath, "Assets");
        }

        // build.assetNames = files;
        // build.assetBundleName = "pools" + AppConst.ExtName;
        // builds.Add(build);
        for (int i = 0; i < files.Length; i++)
        {
            AssetImporter importer =
                AssetImporter.GetAtPath(temppath.Replace(Application.dataPath, "Assets") + "/" +
                                        Path.GetFileName(files[i]));
            importer.assetBundleName = Path.GetFileNameWithoutExtension(files[i]);
            importer.assetBundleVariant = AppConst.ExtName.Replace(".", "");
        }

        // BuildPipeline.BuildAssetBundles(Application.streamingAssetsPath + "/module02", builds.ToArray(),
        //     BuildAssetBundleOptions.ChunkBasedCompression, EditorUserBuildSettings.activeBuildTarget);
        if (Directory.Exists(Application.streamingAssetsPath + "/module02/Pool"))
        {
            Directory.Delete(Application.streamingAssetsPath + "/module02/Pool", true);
        }

        Directory.CreateDirectory(Application.streamingAssetsPath + "/module02/Pool");
        BuildPipeline.BuildAssetBundles(Application.streamingAssetsPath + "/module02/Pool",
            BuildAssetBundleOptions.ChunkBasedCompression, EditorUserBuildSettings.activeBuildTarget);
        string[] ms = Directory.GetFiles(Application.streamingAssetsPath, "*", SearchOption.AllDirectories);
        for (int i = 0; i < ms.Length; i++)
        {
            FileInfo info = new FileInfo(ms[i]);
            if (info.Extension == "" || info.Extension == ".manifest")
            {
                info.Delete();
            }
        }

        AssetDatabase.Refresh();
        Directory.Delete(temppath, true);
        AssetDatabase.RemoveUnusedAssetBundleNames();
        AssetDatabase.Refresh();

        string[] pathpools = Directory.GetFiles($"{Application.streamingAssetsPath}/module02/Pool", "*.unity3d",
            SearchOption.AllDirectories);
        string path = $"{Application.streamingAssetsPath}/module02/Pool";
        string newpath = $"{Application.dataPath}/Pools";
        for (int i = 0; i < pathpools.Length; i++)
        {
            string fileName = Path.GetFileName(pathpools[i]);
            MD5Helper.SamplyDESEn($"{path}/{fileName}", $"{newpath}/{fileName}", MD5Helper.FileKey);
        }

        string plat = EditorUserBuildSettings.activeBuildTarget.ToString();
        string sourcePath = Application.dataPath.Replace("Assets", "EnUpdateRes/") + plat +
                            "/StreamingAssets/ValueConfiger.json";
        string distPath = Application.streamingAssetsPath + "/ValueConfiger.json";
        File.Copy(sourcePath, distPath, true);
        AssetDatabase.Refresh();
    }

    [MenuItem("Tools/BuildPrefabBundle")]
    public static void BuildPrefabBundle()
    {
        DebugTool.Log(Application.dataPath + "/Prefab");
        string[] files = Directory.GetFiles(Application.dataPath + "/Prefab", "*.prefab", SearchOption.AllDirectories);
        string temppath = Application.dataPath + "/TempPrefab";
        if (Directory.Exists(temppath))
        {
            Directory.Delete(temppath, true);
        }

        Directory.CreateDirectory(temppath);
        for (int i = 0; i < files.Length; i++)
        {
            File.Copy(files[i], temppath + "/" + Path.GetFileName(files[i]));
        }

        AssetDatabase.Refresh();
        files = Directory.GetFiles(temppath, "*.prefab", SearchOption.AllDirectories);
        if (!Directory.Exists(Application.streamingAssetsPath + "/module02"))
        {
            Directory.CreateDirectory(Application.streamingAssetsPath + "/module02");
        }

        if (File.Exists(Application.streamingAssetsPath + "/module02/pools" + AppConst.ExtName))
        {
            File.Delete(Application.streamingAssetsPath + "/module02/pools" + AppConst.ExtName);
        }

        for (int i = 0; i < files.Length; i++)
        {
            files[i] = files[i].Replace('\\', '/').Replace(Application.dataPath, "Assets");
        }

        List<AssetBundleBuild> builds = new List<AssetBundleBuild>();
        // build.assetNames = files;
        // build.assetBundleName = "pools" + AppConst.ExtName;
        // builds.Add(build);
        for (int i = 0; i < files.Length; i++)
        {
            AssetImporter importer =
                AssetImporter.GetAtPath(temppath.Replace(Application.dataPath, "Assets") + "/" +
                                        Path.GetFileName(files[i]));
            importer.assetBundleName = Path.GetFileNameWithoutExtension(files[i]);
            importer.assetBundleVariant = AppConst.ExtName.Replace(".", "");
            // AssetBundleBuild build = new AssetBundleBuild();
            // build.assetNames = new []{files[i]};
            // build.assetBundleName = Path.GetFileNameWithoutExtension(files[i]);
            // build.assetBundleVariant = AppConst.ExtName.Replace(".", "");
            // builds.Add(build);
        }

        if (Directory.Exists(Application.streamingAssetsPath + "/module02/Pool"))
        {
            Directory.Delete(Application.streamingAssetsPath + "/module02/Pool", true);
        }

        Directory.CreateDirectory(Application.streamingAssetsPath + "/module02/Pool");
        // BuildPipeline.BuildAssetBundles(Application.streamingAssetsPath + "/module02/Pool", builds.ToArray(),
        //     BuildAssetBundleOptions.ChunkBasedCompression, EditorUserBuildSettings.activeBuildTarget);
        BuildPipeline.BuildAssetBundles(Application.streamingAssetsPath + "/module02/Pool",
            BuildAssetBundleOptions.ChunkBasedCompression, EditorUserBuildSettings.activeBuildTarget);
        string[] ms = Directory.GetFiles(Application.streamingAssetsPath, "*", SearchOption.AllDirectories);
        for (int i = 0; i < ms.Length; i++)
        {
            if (ms[i].EndsWith("StreamingAssets") || ms[i].EndsWith("module02") || ms[i].EndsWith("manifest"))
            {
                File.Delete(ms[i]);
            }
        }

        AssetDatabase.Refresh();
        Directory.Delete(temppath, true);
        AssetDatabase.RemoveUnusedAssetBundleNames();
        AssetDatabase.Refresh();
        DebugTool.Log("build module02 pool success");

        string[] pathpools = Directory.GetFiles($"{Application.streamingAssetsPath}/module02/Pool", "*.unity3d",
            SearchOption.AllDirectories);
        string path = $"{Application.streamingAssetsPath}/module02/Pool";
        string newpath = $"{Application.dataPath}/Pools";
        for (int i = 0; i < pathpools.Length; i++)
        {
            string fileName = Path.GetFileName(pathpools[i]);
            MD5Helper.SamplyDESEn($"{path}/{fileName}", $"{newpath}/{fileName}", MD5Helper.FileKey);
        }

        string plat = EditorUserBuildSettings.activeBuildTarget.ToString();
        string sourcePath = Application.dataPath.Replace("Assets", "EnUpdateRes/") + plat +
                            "/StreamingAssets/ValueConfiger.json";
        string distPath = Application.streamingAssetsPath + "/ValueConfiger.json";
        File.Copy(sourcePath, distPath, true);
        AssetDatabase.RemoveUnusedAssetBundleNames();
        AssetDatabase.Refresh();
    }

    [MenuItem("文件助手/OperateFile")]
    public static void OperateFile()
    {
        string path = $"{Application.dataPath}/NewTexture";
        string[] files = Directory.GetFiles(path, "*", SearchOption.AllDirectories);
        for (int i = 0; i < files.Length; i++)
        {
            if (files[i].Contains("图层"))
            {
                string _path = files[i].Replace("图层", "");
                File.Move(files[i], _path);
            }
        }

        AssetDatabase.Refresh();
        DebugTool.Log($"操作完成:{files.Length}");
    }

    [MenuItem("Tools/加密单个bundle")]
    public static void ESSingleAssetBundle()
    {
        List<string> bundlenames = new List<string>() {"module63"}; //,"module64"
        string path = $"{Application.dataPath}/../UpdateRes";
        string newPath = $"{Application.dataPath}/../EnUpdateRes";
        if (!Directory.Exists(newPath))
        {
            ESAssetBundle();
            return;
        }

        List<string> platformlist = new List<string>() {"android", "ios", "StandaloneWindows"};
        List<string> platform1list = new List<string>() {"AndroidGames2", "IOSGames2", "PCGames2"};
        for (int j = 0; j < platformlist.Count; j++)
        {
            string platform = platformlist[j];
            string platform1 = platform1list[j];
            string configer = $"{newPath}/{platform}/StreamingAssets/GameValueConfiger.json";
            ValueConfiger gameconfig = JsonMapper.ToObject<ValueConfiger>(File.ReadAllText(configer));
            for (int k = 0; k < bundlenames.Count; k++)
            {
                string bundlename = bundlenames[k];
                string dirName = $"{path}/{platform}/games/{bundlename}";
                if (!Directory.Exists(dirName))
                {
                    Directory.CreateDirectory(dirName);
                }

                DebugTool.Log(dirName);
                string[] files =
                    Directory.GetFiles(dirName, "*.unity3d", SearchOption.AllDirectories);
                DebugTool.Log(files.Length);
                for (int i = 0; i < files.Length; i++)
                {
                    string filename = Path.GetFileNameWithoutExtension(files[i]);
                    string _path = newPath.Replace($"EnUpdateRes", platform1);
                    _path = _path.Replace(platform, "");
                    string filePath = files[i].Replace(path, _path);
                    filePath = filePath.Replace(platform, "");
                    string _dirName = Path.GetDirectoryName(filePath);
                    if (!Directory.Exists(_dirName)) Directory.CreateDirectory(_dirName);
                    DirectoryInfo dir = new DirectoryInfo(_dirName);
                    File.Copy(files[i], filePath, true);
                    string newfile = filePath.Replace(".unity3d", ".assetbundle");
                    MD5Helper.SamplyDESEn(filePath, newfile, MD5Helper.FileKey);
                    string md5 = MD5Helper.MD5File(filePath);
                    string key = $"{dir.Name}/{filename}{AppConst.ExtName}";
                    DebugTool.Log(key);
                    if (gameconfig.JsonData.ContainsKey(key))
                    {
                        BaseValueConfigerJson json = gameconfig.JsonData[key];
                        json.dirPath = $"{dir.Name}/{filename}{AppConst.ExtName}";
                        json.crc = 0;
                        json.hash = md5;
                        json.md5 = md5;
                        json.version = 0;
                        json.moduleName = dir.Name;
                        json.size = new FileInfo(filePath).Length.ToString();
                        gameconfig.JsonData[key] = json;
                    }
                    else
                    {
                        BaseValueConfigerJson json = new BaseValueConfigerJson();
                        json.dirPath = $"{dir.Name}/{filename}{AppConst.ExtName}";
                        json.crc = 0;
                        json.hash = md5;
                        json.md5 = md5;
                        json.version = 0;
                        json.moduleName = dir.Name;
                        json.size = new FileInfo(filePath).Length.ToString();
                        gameconfig.JsonData.Add($"{dir.Name}/{filename}{AppConst.ExtName}", json);
                    }

                    DebugTool.Log($"{platform}/{key}:{md5}");
                }
            }

            File.WriteAllText(configer, JsonMapper.ToJson(gameconfig));
        }
    }

    [MenuItem("Tools/加密所有平台游戏文件")]
    public static void ESAssetBundle()
    {
        string path = $"{Application.dataPath}/../UpdateRes";
        string newPath = $"{Application.dataPath}/../EnUpdateRes";
        if (Directory.Exists(newPath))
        {
            Directory.Delete(newPath, true);
        }

        Directory.CreateDirectory(newPath);

        List<string> platformlist = new List<string>() {"android", "ios", "StandaloneWindows"};
        for (int j = 0; j < platformlist.Count; j++)
        {
            string platform = platformlist[j];
            FileHelper.CopyDirectory($"{path}/{platform}", $"{newPath}/{platform}");
            string configer = $"{newPath}/{platform}/StreamingAssets/GameValueConfiger.json";
            ValueConfiger gameconfig = JsonMapper.ToObject<ValueConfiger>(File.ReadAllText(configer));
            string dirName = $"{newPath}/{platform}/games";
            if (!Directory.Exists(dirName)) Directory.CreateDirectory(dirName);
            string[] files =
                Directory.GetFiles(dirName, "*.unity3d", SearchOption.AllDirectories);
            DebugTool.Log(files.Length);
            for (int i = 0; i < files.Length; i++)
            {
                string filename = Path.GetFileNameWithoutExtension(files[i]);
                string _dirName = Path.GetDirectoryName(files[i]);
                if (!Directory.Exists(_dirName)) Directory.CreateDirectory(_dirName);
                DirectoryInfo dir = new DirectoryInfo(_dirName);
                string newfile = files[i].Replace(".unity3d", ".assetbundle");
                MD5Helper.SamplyDESEn(files[i], newfile, MD5Helper.FileKey);
                string md5 = MD5Helper.MD5File(files[i]);
                string key = $"{dir.Name}/{filename}{AppConst.ExtName}";
                DebugTool.Log(key);
                if (gameconfig.JsonData.ContainsKey(key))
                {
                    BaseValueConfigerJson json = gameconfig.JsonData[key];
                    json.dirPath = $"{dir.Name}/{filename}{AppConst.ExtName}";
                    json.crc = 0;
                    json.hash = md5;
                    json.md5 = md5;
                    json.version = 0;
                    json.moduleName = dir.Name;
                    json.size = new FileInfo(files[i]).Length.ToString();
                    gameconfig.JsonData[key] = json;
                }
                else
                {
                    BaseValueConfigerJson json = new BaseValueConfigerJson();
                    json.dirPath = $"{dir.Name}/{filename}{AppConst.ExtName}";
                    json.crc = 0;
                    json.hash = md5;
                    json.md5 = md5;
                    json.version = 0;
                    json.moduleName = dir.Name;
                    json.size = new FileInfo(files[i]).Length.ToString();
                    gameconfig.JsonData.Add($"{dir.Name}/{filename}{AppConst.ExtName}", json);
                }

                DebugTool.Log($"{platform}/{key}:{md5}");
            }

            File.WriteAllText(configer, JsonMapper.ToJson(gameconfig));
        }
    }

    [MenuItem("Tools/SaveSprite")]
    public static void SaveSingleSprite()
    {
        GameObject obj = Selection.activeGameObject;
        DebugTool.Log(obj.name);
        SpriteRenderer render = obj.GetComponent<SpriteRenderer>();
        if (render != null)
        {
            Sprite sprite = render.sprite;
            Texture2D texture2D = new Texture2D((int) sprite.rect.width, (int) sprite.rect.height);
            var pixels = sprite.texture.GetPixels(
                (int) sprite.textureRect.x,
                (int) sprite.textureRect.y,
                (int) sprite.textureRect.width,
                (int) sprite.textureRect.height);
            texture2D.SetPixels(pixels);
            texture2D.Apply();

            System.IO.File.WriteAllBytes($"{Application.dataPath}/{sprite.name}.png", texture2D.EncodeToPNG());
        }
    }

    [MenuItem("Tools/导出精灵")]
    static void ExportSprite()
    {
        string resourcesPath = "Assets/Resources/";
        foreach (Object obj in Selection.objects)
        {
            string selectionPath = AssetDatabase.GetAssetPath(obj);
            if (selectionPath.StartsWith(resourcesPath))
            {
                string selectionExt = System.IO.Path.GetExtension(selectionPath);
                if (selectionExt.Length == 0)
                {
                    Debug.LogError($"资源{selectionPath}的扩展名不对，请选择图片资源");
                    continue;
                }

                // 如果selectionPath = "Assets/Resources/UI/Common.png"
                // 那么loadPath = "UI/Common"
                string loadPath = selectionPath.Remove(selectionPath.Length - selectionExt.Length);
                loadPath = loadPath.Substring(resourcesPath.Length);
                // 加载此文件下的所有资源
                Sprite[] sprites = Resources.LoadAll<Sprite>(loadPath);
                if (sprites.Length > 0)
                {
                    // 创建导出目录
                    string exportPath = Application.dataPath + "/ExportSprite/" + loadPath;
                    System.IO.Directory.CreateDirectory(exportPath);

                    foreach (Sprite sprite in sprites)
                    {
                        Texture2D tex = new Texture2D((int) sprite.rect.width, (int) sprite.rect.height,
                            sprite.texture.format, false);
                        tex.SetPixels(sprite.texture.GetPixels((int) sprite.rect.xMin, (int) sprite.rect.yMin,
                            (int) sprite.rect.width, (int) sprite.rect.height));
                        tex.Apply();

                        // 将图片数据写入文件
                        System.IO.File.WriteAllBytes(exportPath + "/" + sprite.name + ".png", tex.EncodeToPNG());
                    }

                    Debug.Log("导出精灵到" + exportPath);
                }

                Debug.Log("导出精灵完成");
                // 刷新资源
                AssetDatabase.Refresh();
            }
            else
            {
                Debug.LogError($"请将资源放在{resourcesPath}目录下");
            }
        }
    }

    [MenuItem("Tools/自定义打包预制件")]
    public static void CustomBuildPrefabBundle()
    {
        AddSpriteEdit myWindow =
            (AddSpriteEdit) EditorWindow.GetWindow(typeof(AddSpriteEdit), false, "打包预制件", true); //创建窗口
        myWindow.Show(); //展示
    }

    private static string prefabName = "";

    private void OnGUI()
    {
        EditorGUILayout.LabelField("输入需要打包的预制件名（不同预制件用逗号分隔,如果不填预制件名将默认全部build）：");
        prefabName = EditorGUILayout.TextField(prefabName);

        if (GUILayout.Button("打包"))
        {
            StartBuildPrefabBundle();
        }
    }

    public static void StartBuildPrefabBundle()
    {
        DebugTool.Log(Application.dataPath + "/Prefab");

        string[] prefabarr = prefabName.Split(',');
        List<string> prefablist = new List<string>();
        for (int i = 0; i < prefabarr.Length; i++)
        {
            if (!string.IsNullOrEmpty(prefabarr[i]) && prefabarr[i] != "")
            {
                prefablist.Add(prefabarr[i]);
            }
        }

        if (prefablist.Count <= 0)
        {
            BuildPrefabBundle();
            return;
        }

        string[] files = Directory.GetFiles(Application.dataPath + "/Prefab", "*.prefab", SearchOption.AllDirectories);
        string temppath = Application.dataPath + "/TempPrefab";
        if (Directory.Exists(temppath))
        {
            Directory.Delete(temppath, true);
        }

        Directory.CreateDirectory(temppath);
        for (int i = 0; i < files.Length; i++)
        {
            string filename = Path.GetFileNameWithoutExtension(files[i]);
            if (prefablist.Contains(filename) || prefablist.Count <= 0)
            {
                File.Copy(files[i], temppath + "/" + Path.GetFileName(files[i]));
            }
        }

        AssetDatabase.Refresh();
        files = Directory.GetFiles(temppath, "*.prefab", SearchOption.AllDirectories);
        if (!Directory.Exists(Application.streamingAssetsPath + "/module02"))
        {
            Directory.CreateDirectory(Application.streamingAssetsPath + "/module02");
        }

        for (int i = 0; i < files.Length; i++)
        {
            files[i] = files[i].Replace('\\', '/').Replace(Application.dataPath, "Assets");
        }

        List<AssetBundleBuild> builds = new List<AssetBundleBuild>();
        // build.assetNames = files;
        // build.assetBundleName = "pools" + AppConst.ExtName;
        // builds.Add(build);
        for (int i = 0; i < files.Length; i++)
        {
            string filename = Path.GetFileNameWithoutExtension(files[i]);
            if (prefablist.Contains(filename) || prefablist.Count <= 0)
            {
                DebugTool.Log(filename);
                AssetImporter importer =
                    AssetImporter.GetAtPath(temppath.Replace(Application.dataPath, "Assets") + "/" +
                                            Path.GetFileName(files[i]));
                importer.assetBundleName = filename;
                importer.assetBundleVariant = AppConst.ExtName.Replace(".", "");
                if (File.Exists($"{Application.streamingAssetsPath}/module02/Pool/{filename}{AppConst.ExtName}"))
                {
                    File.Delete($"{Application.streamingAssetsPath}/module02/Pool/{filename}{AppConst.ExtName}");
                }
            }

            // AssetBundleBuild build = new AssetBundleBuild();
            // build.assetNames = new []{files[i]};
            // build.assetBundleName = Path.GetFileNameWithoutExtension(files[i]);
            // build.assetBundleVariant = AppConst.ExtName.Replace(".", "");
            // builds.Add(build);
        }

        if (!Directory.Exists(Application.streamingAssetsPath + "/module02/Pool"))
        {
            Directory.CreateDirectory(Application.streamingAssetsPath + "/module02/Pool");
        }

        // BuildPipeline.BuildAssetBundles(Application.streamingAssetsPath + "/module02/Pool", builds.ToArray(),
        //     BuildAssetBundleOptions.ChunkBasedCompression, EditorUserBuildSettings.activeBuildTarget);
        BuildPipeline.BuildAssetBundles(Application.streamingAssetsPath + "/module02/Pool",
            BuildAssetBundleOptions.ChunkBasedCompression, EditorUserBuildSettings.activeBuildTarget);
        string[] ms = Directory.GetFiles(Application.streamingAssetsPath, "*", SearchOption.AllDirectories);
        for (int i = 0; i < ms.Length; i++)
        {
            if (ms[i].EndsWith("StreamingAssets") || ms[i].EndsWith("module02") || ms[i].EndsWith("manifest"))
            {
                File.Delete(ms[i]);
            }
        }

        AssetDatabase.Refresh();
        Directory.Delete(temppath, true);
        AssetDatabase.RemoveUnusedAssetBundleNames();
        AssetDatabase.Refresh();
        DebugTool.Log("build module02 pool success");

        string[] pathpools = Directory.GetFiles($"{Application.streamingAssetsPath}/module02/Pool", "*.unity3d",
            SearchOption.AllDirectories);
        string path = $"{Application.streamingAssetsPath}/module02/Pool";
        string newpath = $"{Application.dataPath}/Pools";
        for (int i = 0; i < pathpools.Length; i++)
        {
            string fileName = Path.GetFileName(pathpools[i]);
            MD5Helper.SamplyDESEn($"{path}/{fileName}", $"{newpath}/{fileName}", MD5Helper.FileKey);
        }

        string plat = EditorUserBuildSettings.activeBuildTarget.ToString();
        string sourcePath = Application.dataPath.Replace("Assets", "EnUpdateRes/") + plat +
                            "/StreamingAssets/ValueConfiger.json";
        string distPath = Application.streamingAssetsPath + "/ValueConfiger.json";
        File.Copy(sourcePath, distPath, true);
        AssetDatabase.RemoveUnusedAssetBundleNames();
        AssetDatabase.Refresh();
    }

    static Dictionary<string, AssetBundle> dic = new Dictionary<string, AssetBundle>();
    private static List<Object> objList = new List<Object>();
    private static string needShowAssetbundle = "fish_141";

    [MenuItem("文件助手/加载指定名的bundle")]
    private static void LoadAssetBundleByName()
    {
        AssetBundle.UnloadAllAssetBundles(true);
        objList.Clear();
        dic.Clear();

        string[] files = Directory.GetFiles($"{Application.dataPath}/OtherScene/module62/bundle", "*.u3d",
            SearchOption.AllDirectories);
        for (int i = 0; i < files.Length; i++)
        {
            AssetBundle bundle = AssetBundle.LoadFromFile(files[i]);
            dic.Add(bundle.name, bundle);
        }

        Object[] objs = dic["f4buyu_prefab.u3d".ToLower()].LoadAllAssets();
        for (int i = 0; i < objs.Length; i++)
        {
            if (!objs[i].name.Contains(needShowAssetbundle)) continue;
            GameObject go = Instantiate(objs[i]) as GameObject;
            if (go != null) go.name = objs[i].name;
            break;
        }
    }

    [MenuItem("文件助手/LoadAssetBundle")]
    public static void LoadAssetBundle()
    {
        AssetBundle.UnloadAllAssetBundles(true);

        for (int i = 0; i < objList.Count; i++)
        {
            if (objList[i] != null)
            {
                Destroy(objList[i]);
            }
        }

        objList.Clear();
        dic.Clear();
        string[] files = Directory.GetFiles($"{Application.dataPath}/Bundle", "*.assetbundle",
            SearchOption.AllDirectories);
        for (int i = 0; i < files.Length; i++)
        {
            AssetBundle bundle = AssetBundle.LoadFromFile(files[i]);
            dic.Add(bundle.name, bundle);
            DebugTool.Log(bundle.name);
        }

        Object[] objs = dic["mainuinewperfabe.assetbundle".ToLower()].LoadAllAssets();
        // Transform parent = FindObjectOfType<Canvas>().transform;
        for (int i = 0; i < objs.Length; i++)
        {
            DebugTool.Log(objs[i].name);
            GameObject go = Instantiate(objs[i]) as GameObject;
            if (go != null) go.name = objs[i].name;
        }
    }

    private static List<AssetBundle> bundlelist = new List<AssetBundle>();

    [MenuItem("文件助手/LoadScene")]
    public static void LoadScene()
    {
        AssetBundle.UnloadAllAssetBundles(true);
        dic.Clear();
        string[] files = Directory.GetFiles($"{Application.dataPath}/OtherScene/module06", "*.unity3d",
            SearchOption.AllDirectories);
        for (int i = 0; i < files.Length; i++)
        {
            AssetBundle bundle = AssetBundle.LoadFromFile(files[i]);
            dic.Add(bundle.name, bundle);
            DebugTool.Log(bundle.name);
        }

        SceneManager.LoadScene($"module06", LoadSceneMode.Additive);
    }

    [MenuItem("文件助手/LoadSingleBundle")]
    public static void LoadSingleBundle()
    {
        AssetBundle.UnloadAllAssetBundles(true);
        string modulename = "module62";
        string path = $"{Application.dataPath}/OtherScene/{modulename}/slotxml.assetbundle";
        Dictionary<string, Object> dic = new Dictionary<string, Object>();
        AssetBundle bundle = AssetBundle.LoadFromFile(path);
        Object[] objs = bundle.LoadAllAssets();
        for (int i = 0; i < objs.Length; i++)
        {
            DebugTool.Log(objs[i].name);
            Instantiate(objs[i]);
        }
    }

    /// <summary>  
    /// 对相机截图。   
    /// </summary>  
    /// <returns>The screenshot2.</returns>  
    /// <param name="camera">Camera.要被截屏的相机</param>  
    /// <param name="rect">Rect.截屏的区域</param>
    [MenuItem("Tools/ShootPicture")]
    public static void CaptureCamera()
    {
        Camera camera = Camera.main;
        Rect rect = new Rect(0, 0, 1920, 1080);
        // 创建一个RenderTexture对象  
        RenderTexture rt = new RenderTexture((int) rect.width, (int) rect.height, 0);
        // 临时设置相关相机的targetTexture为rt, 并手动渲染相关相机  
        camera.targetTexture = rt;
        camera.Render();
        //ps: --- 如果这样加上第二个相机，可以实现只截图某几个指定的相机一起看到的图像。  
        //ps: camera2.targetTexture = rt;  
        //ps: camera2.Render();  
        //ps: -------------------------------------------------------------------  

        // 激活这个rt, 并从中中读取像素。  
        RenderTexture.active = rt;
        Texture2D screenShot = new Texture2D((int) rect.width, (int) rect.height, TextureFormat.RGB24, false);
        screenShot.ReadPixels(rect, 0, 0); // 注：这个时候，它是从RenderTexture.active中读取像素  
        screenShot.Apply();

        // 重置相关参数，以使用camera继续在屏幕上显示  
        camera.targetTexture = null;
        //ps: camera2.targetTexture = null;  
        RenderTexture.active = null; // JC: added to avoid errors  
        GameObject.Destroy(rt);
        // 最后将这些纹理数据，成一个png图片文件  
        byte[] bytes = screenShot.EncodeToPNG();
        string dirname = $"{Application.dataPath}/Screenshoot";
        if (!Directory.Exists(dirname)) Directory.CreateDirectory(dirname);
        string filename = $"{dirname}/Screenshoot_{DateTime.Now.ToString($"yyyyMMddhhmmss")}.png";
        System.IO.File.WriteAllBytes(filename, bytes);
        Debug.Log($"截屏了一张照片: {filename}");
        AssetDatabase.Refresh();
    }

    [MenuItem("Tools/修改文件名")]
    public static void ChangeFileName()
    {
        string path = $"D:/Projects/解包/亲朋捕鱼大乱斗/TextAsset/";
        string newPath = "D:/Projects/解包/亲朋捕鱼大乱斗/NewTextAsset/";
        if (!Directory.Exists(newPath)) Directory.CreateDirectory(newPath);
        string[] files = Directory.GetFiles(path);
        for (int i = 0; i < files.Length; i++)
        {
            string fileFullName = Path.GetFileNameWithoutExtension(files[i]);
            string fileName = fileFullName.Replace(path, "");
            File.Copy(files[i], $"{newPath}{fileName}.lua");
        }
    }

    [MenuItem("Tools/BuildLuaNoDelete")]
    public static void BuildLuaNoDelete()
    {
#if BUILD64
        BuildTool.BuildTool.LuaBuildType = BuildType.Type64;
#else
        BuildTool.BuildTool.LuaBuildType = BuildType.Type32;
#endif
        BuildTool.BuildTool.BuildLua();
        DebugTool.Log($"Build Lua Complete");
    }

    private static void SetDefaultInfo()
    {
        DNS dns = new DNS();
        dns.dns = new List<string>()
        {
            "http://192.168.0.108:8080"
            //"https://gamesgt.s3.ap-southeast-1.amazonaws.com"
        };
        dns.cdnDirectoryName = "SJHLCRes";
        //dns.cdnDirectoryName = "SJHLCResMono";
        dns.auth = "SJYT20175638D2893M753029039V32f700";

        File.WriteAllText($"{Application.dataPath}/dns.bytes", JsonMapper.ToJson(dns));
        AssetDatabase.Refresh();
    }

    [MenuItem("Tools/EncryptDNS")]
    public static void EncryptDNSInfo()
    {
        string path = $"{Application.dataPath}/dns.bytes";
        SetDefaultInfo();
        var text = File.ReadAllText(path);
        string key = $"byte";

        if (File.Exists($"{Application.dataPath}/Resources/dns.bytes"))
        {
            File.Delete($"{Application.dataPath}/Resources/dns.bytes");
        }

        File.WriteAllText($"{Application.dataPath}/Resources/dns.bytes",
            MD5Helper.Encrypt(text, key));
        AssetDatabase.Refresh();
    }


    [MenuItem("Assets/替换Text为TMP")]
    private static void ReplaceTextToTMP()
    {
        var obj = Selection.activeObject;
        ChangePrefab(obj);
    }

    private static void ChangePrefab(Object obj)
    {
        var go = obj as GameObject;
        ChangeChild(go.transform);
    }

    private static void ChangeChild(Transform trans)
    {
        var parent = trans;
        Text txt = trans.GetComponent<Text>();
        if (txt != null)
        {
            parent = Instantiate(trans.gameObject, trans.parent).transform;
            parent.gameObject.name = trans.gameObject.name;
            ChangeTxt(parent, txt);
            // DestroyImmediate(txt.gameObject);
        }

        for (int i = 0; i < parent.childCount; i++)
        {
            ChangeChild(parent.GetChild(i));
        }
    }

    private static Transform ChangeTxt(Transform parent, Text txt)
    {
        DestroyImmediate(parent.GetComponent<Text>());
        var tmpTxt = parent.gameObject.AddComponent<TextMeshProUGUI>();
        tmpTxt.color = txt.color;
        tmpTxt.text = txt.text;
        tmpTxt.font = AssetDatabase.LoadAssetAtPath<TMP_FontAsset>("Assets/Module/Hall/Font/MSYH SDF.asset");
        tmpTxt.fontSize = txt.fontSize;
        tmpTxt.fontStyle = (FontStyles) ((int) txt.fontStyle);
        Enum.TryParse<TextAlignmentOptions>(txt.alignment.ToString(), out var t);
        tmpTxt.alignment = t;
        tmpTxt.lineSpacing = txt.lineSpacing;
        tmpTxt.autoSizeTextContainer = txt.resizeTextForBestFit;
        tmpTxt.fontSizeMin = txt.resizeTextMinSize;
        tmpTxt.fontSizeMax = txt.resizeTextMaxSize;
        return parent;
    }

    private static void SavePrefab(Object obj)
    {
        PrefabUtility.ApplyPrefabInstance(obj as GameObject, InteractionMode.UserAction);
    }
}