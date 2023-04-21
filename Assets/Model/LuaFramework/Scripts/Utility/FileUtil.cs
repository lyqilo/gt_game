using System.Collections;
using System.Collections.Generic;
using System.IO;

namespace LuaFramework
{
    public class FileUtil
    {
        
        /// <summary>
        /// 获取传入路径下所有指定查找文件夹
        /// </summary>
        public static List<string> GetDirectories(string path, string searchPattern, SearchOption searchOption)
        {
            var files = new List<string>();
            var tempfiles = Directory.GetDirectories(path, searchPattern, searchOption);
            for (int j = 0; j < tempfiles.Length; ++j)
            {
                files.Add(tempfiles[j].Replace("\\", "/"));
            }
            return files;
        }

        /// <summary>
        /// 获取传入路径下所有指定查找文件
        /// </summary>
        public static List<string> GetFiles(string path, string searchPattern, SearchOption searchOption)
        {
            var files = new List<string>();
            var tempfiles = Directory.GetFiles(path, searchPattern, searchOption);
            for (int j = 0; j < tempfiles.Length; ++j)
            {
                files.Add(tempfiles[j].Replace("\\", "/"));
            }
            return files;
        }

        /// <summary>
        /// 获取传入路径下所有指定查找文件
        /// </summary>
        public static List<string> GetDirectories(string[] paths, string searchPattern, SearchOption searchOption)
        {
            var files = new List<string>();
            for (int i = 0; i < paths.Length; ++i)
            {
                var tempfiles = Directory.GetDirectories(paths[i], searchPattern, searchOption);
                for (int j = 0; j < tempfiles.Length; ++j)
                {
                    files.Add(tempfiles[j].Replace("\\", "/"));
                }
            }
            return files;
        }

        /// <summary>
        /// 获取传入路径下所有指定查找文件
        /// </summary>
        public static List<string> GetFiles(string[] paths, string searchPattern, SearchOption searchOption)
        {
            var files = new List<string>();
            for (int i = 0; i < paths.Length; ++i)
            {
                var tempfiles = Directory.GetFiles(paths[i], searchPattern, searchOption);
                for (int j = 0; j < tempfiles.Length; ++j)
                {
                    files.Add(tempfiles[j].Replace("\\", "/"));
                }
            }
            return files;
        }

    }
}
