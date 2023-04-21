using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using UnityEngine;

namespace LuaFramework
{
    // Token: 0x02000030 RID: 48
    public static class PathHelp
    {
        // Token: 0x170000CB RID: 203
        // (get) Token: 0x060002AD RID: 685 RVA: 0x0000ACF4 File Offset: 0x00008EF4
        public static string AssemblyCSharpPath
        {
            get
            {
                string result = string.Empty;
                RuntimePlatform platform = Application.platform;
                if (platform == RuntimePlatform.IPhonePlayer) return result;
                if (platform != RuntimePlatform.Android)
                {
                    result = Application.dataPath.Replace("/Assets",
                        "/Library/ScriptAssemblies/Assembly-CSharp.dll");
                }

                return result;
            }
        }

        // Token: 0x170000CC RID: 204
        // (get) Token: 0x060002AE RID: 686 RVA: 0x0000AD3C File Offset: 0x00008F3C
        public static string AssemblyDirectory
        {
            get
            {
                string codeBase = Assembly.GetExecutingAssembly().CodeBase;
                UriBuilder uriBuilder = new UriBuilder(codeBase);
                string path = Uri.UnescapeDataString(uriBuilder.Path);
                return Path.GetDirectoryName(path);
            }
        }

        // Token: 0x170000CD RID: 205
        // (get) Token: 0x060002AF RID: 687 RVA: 0x0000AD74 File Offset: 0x00008F74
        public static string AssemblyCSharpEditorPath
        {
            get
            {
                string result = string.Empty;
                RuntimePlatform platform = Application.platform;
                if (platform == RuntimePlatform.IPhonePlayer) return result;
                if (platform != RuntimePlatform.Android)
                {
                    result = Application.dataPath.Replace("/Assets",
                        "/Library/ScriptAssemblies/Assembly-CSharp-Editor.dll");
                }

                return result;
            }
        }

        // Token: 0x170000CE RID: 206
        // (get) Token: 0x060002B0 RID: 688 RVA: 0x0000ADBC File Offset: 0x00008FBC
        public static string AppHotfixResPath
        {
            get
            {
                string text = PathHelp.AppResPath;
                bool debugMode = AppConst.DebugMode;
                string result;
                if (debugMode)
                {
                    result = text;
                }
                else
                {
                    bool isMobilePlatform = Application.isMobilePlatform;
                    if (isMobilePlatform)
                    {
                        text = Application.persistentDataPath + "/" + Application.identifier + "/";
                    }
                    else
                    {
                        string identifier = Application.identifier;
                        bool flag = !identifier.IsNullOrEmpty();
                        if (flag)
                        {
                            text = "c:/" + identifier + "/";
                        }
                    }

                    result = text;
                }

                return result;
            }
        }

        // Token: 0x170000CF RID: 207
        // (get) Token: 0x060002B1 RID: 689 RVA: 0x0000AE38 File Offset: 0x00009038
        public static string AppResPath
        {
            get
            {
                string result = string.Empty;
                RuntimePlatform platform = Application.platform;
                if (platform != RuntimePlatform.Android)
                {
                    result = Application.streamingAssetsPath + "/";
                }
                else
                {
                    result = "jar:file://" + Application.dataPath + "!/assets/";
                }

                return result;
            }
        }

        // Token: 0x170000D0 RID: 208
        // (get) Token: 0x060002B2 RID: 690 RVA: 0x0000AE88 File Offset: 0x00009088
        public static string RelativePath
        {
            get
            {
                string str = "file:///";
                bool isApplePlatform = Util.isApplePlatform;
                if (isApplePlatform)
                {
                    str = "file://";
                }

                bool flag = Util.isOSXEditor || Util.isOSXPlayer;
                if (!flag) return (str + PathHelp.AppHotfixResPath).Trim();
                str = "file://" + Application.dataPath.Replace("Assets", "");
                bool debugMode = AppConst.DebugMode;
                if (debugMode)
                {
                    str = "file://";
                }

                return (str + PathHelp.AppHotfixResPath).Trim();
            }
        }

        // Token: 0x170000D1 RID: 209
        // (get) Token: 0x060002B3 RID: 691 RVA: 0x0000AF08 File Offset: 0x00009108
        public static string PathPrefix
        {
            get { return "file://"; }
        }

        // Token: 0x060002B4 RID: 692 RVA: 0x0000AF24 File Offset: 0x00009124
        public static List<string> GetAllFiles(string path, List<string> files = null)
        {
            bool flag = files == null;
            if (flag)
            {
                files = new List<string>();
            }

            DirectoryInfo directoryInfo = new DirectoryInfo(path);
            FileInfo[] files2 = directoryInfo.GetFiles();
            DirectoryInfo[] directories = directoryInfo.GetDirectories();
            foreach (FileInfo fileInfo in files2)
            {
                files.Add(fileInfo.FullName.FormatPath());
            }

            foreach (DirectoryInfo directoryInfo2 in directories)
            {
                PathHelp.GetAllFiles(directoryInfo2.FullName, files);
            }

            return files;
        }

        // Token: 0x060002B5 RID: 693 RVA: 0x0000AFC0 File Offset: 0x000091C0
        public static long GetFileSize(string path)
        {
            FileInfo fileInfo = new FileInfo(path);
            bool flag = !File.Exists(path);
            long result;
            if (flag)
            {
                result = -1L;
            }
            else
            {
                result = fileInfo.Length;
            }

            return result;
        }
    }
}