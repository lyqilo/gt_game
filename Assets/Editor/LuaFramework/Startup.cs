using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using Common;
using LuaFramework;
using UnityEditor;
using UnityEngine;

[InitializeOnLoad]
public class Startup : EditorWindow
{
    private const string ScriptAssembliesDirOrgin = "Library/ScriptAssemblies";
    private const string ScriptAssembliesDir = "Assets/Res/CodeForIL/";
    private const string CodeDir = "Assets/Res/Code/";
    private const string HotfixDll = "Hotfix.dll.bytes";
    private const string HotfixPdb = "Hotfix.pdb.bytes";
    private const string HotfixDllOrgin = "Hotfix.dll";
    private const string HotfixPdbOrgin = "Hotfix.pdb";

    private const string ScriptAssembliesDirOrginAOT = "HybridCLRData/AssembliesPostIl2CppStrip/";
    private const string ScriptAssembliesDirAOT = "Assets/Res/CodeForILAOT/";
    private const string CodeDirAOT = "Assets/Res/CodeAOT/";
    static Startup()
    {
        CopyDll();
    }

    [MenuItem("ILRuntime/复制Hotfix.dll")]
    public static void CopyDll()
    {
        if (!Directory.Exists(CodeDir))
        {
            Directory.CreateDirectory(CodeDir);
        }
        File.Copy(Path.Combine(ScriptAssembliesDirOrgin, HotfixDllOrgin), Path.Combine(ScriptAssembliesDir, "Hotfix.dll.bytes"), true);
        File.Copy(Path.Combine(ScriptAssembliesDirOrgin, HotfixPdbOrgin), Path.Combine(ScriptAssembliesDir, "Hotfix.pdb.bytes"), true);
        Debug.Log($"复制Hotfix.dll, Hotfix.pdb到Res/Code完成");
        AssetDatabase.Refresh();
        EncryptDll();
    }

    [MenuItem("ILRuntime/加密Hotfix.dll")]
    private static void EncryptDll()
    {
        Save(ScriptAssembliesDir,CodeDir,HotfixDll);
        Save(ScriptAssembliesDir,CodeDir,HotfixPdb);
        Debug.Log($"加密Hotfix.dll, Hotfix.pdb到Res/Code完成");
        AssetDatabase.Refresh();
    }

    private static void Save(string dir,string targetdir,string fileName)
    {
        string originPath = Path.Combine(dir, fileName);
        string savePath = Path.Combine(targetdir, fileName);

        byte[] bytes;

        using (FileStream fs = new FileStream(originPath, FileMode.Open))
        {
            int len = (int) fs.Length;
            bytes = new byte[len];
            fs.Read(bytes, 0, len);
        }

        bytes = AES.AESEncrypt(bytes, ILRuntimeManager.AesKey);

        if (File.Exists(savePath))
        {
            File.Delete(savePath);
        }

        using (FileStream fs = new FileStream(savePath, FileMode.Create))
        {
            fs.Write(bytes, 0, bytes.Length);
            fs.Flush();
        }
    }

    [MenuItem("HybridCLR/CopyAOT")]
    private static void CopyAOT()
    {
        if (Directory.Exists(CodeDirAOT))
        {
            Directory.Delete(CodeDirAOT,true);
        }
        Directory.CreateDirectory(CodeDirAOT);
        if (Directory.Exists(ScriptAssembliesDirAOT))
        {
            Directory.Delete(ScriptAssembliesDirAOT, true);
        }
        Directory.CreateDirectory(ScriptAssembliesDirAOT);

        var files = Directory.GetFiles($"{ScriptAssembliesDirOrginAOT}{EditorUserBuildSettings.activeBuildTarget}","*.dll");
        string str = String.Empty;
        foreach (var file in files)
        {
            string fileName = Path.GetFileName(file);
            File.Copy(file, Path.Combine(ScriptAssembliesDirAOT, $"{fileName}.bytes"), true);
            AssetDatabase.Refresh();
            Save(ScriptAssembliesDirAOT, CodeDirAOT, $"{fileName}.bytes");
            str += $"\"{fileName}\",";
        }
        AssetDatabase.Refresh();
        DebugTool.LogError(str);
    }
}