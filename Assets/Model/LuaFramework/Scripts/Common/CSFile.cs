using System;
using System.IO;
using System.Threading.Tasks;

namespace LuaFramework
{
    public class CSFile
    {
        public static async Task<string> ReadAsync(string path)
        {
            string result;
            using (FileStream stream = File.Open(path, FileMode.Open))
            {
                using (StreamReader sw = new StreamReader(stream))
                {
                    string text = await sw.ReadToEndAsync();
                    result = text;
                    sw.Dispose();
                    sw.Close();
                }
                stream.Dispose();
                stream.Close();
            }
            return result;
        }

        public static async Task WriteAsync(string path, string conte)
        {
            using (FileStream stream = File.Create(path))
            {
                using (StreamWriter sw = new StreamWriter(stream))
                {
                    await sw.WriteAsync(conte);
                    sw.Dispose();
                    sw.Close();
                }
                stream.Dispose();
                stream.Close();
            }
        }

        public static async Task WriteAppendAsync(string path, string conte)
        {
            using (FileStream stream = File.Open(path, FileMode.Append))
            {
                using (StreamWriter sw = new StreamWriter(stream))
                {
                    await sw.WriteAsync(conte);
                    sw.Dispose();
                    sw.Close();
                }
                stream.Dispose();
                stream.Close();
            }
        }

        public static string Read(string path)
        {
            string result;
            using (FileStream fileStream = File.Open(path, FileMode.Open))
            {
                using (StreamReader streamReader = new StreamReader(fileStream))
                {
                    result = streamReader.ReadToEnd();
                    streamReader.Dispose();
                    streamReader.Close();
                }
                fileStream.Dispose();
                fileStream.Close();
            }
            return result;
        }

        public static void Write(string path, string conte)
        {
            using (FileStream fileStream = File.Create(path))
            {
                using (StreamWriter streamWriter = new StreamWriter(fileStream))
                {
                    streamWriter.Write(conte);
                    streamWriter.Dispose();
                    streamWriter.Close();
                }
                fileStream.Dispose();
                fileStream.Close();
            }
        }

        public static void WriteAppend(string path, string conte)
        {
            using (FileStream fileStream = File.Open(path, FileMode.Append))
            {
                using (StreamWriter streamWriter = new StreamWriter(fileStream))
                {
                    streamWriter.Write(conte);
                    streamWriter.Dispose();
                    streamWriter.Close();
                }
                fileStream.Dispose();
                fileStream.Close();
            }
        }
    }
}
