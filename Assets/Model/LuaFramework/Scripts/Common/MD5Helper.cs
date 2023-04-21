using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using UnityEngine;
using Random = UnityEngine.Random;

namespace LuaFramework
{
    // Token: 0x020001D4 RID: 468
    public static class MD5Helper
    {
        // Token: 0x06002428 RID: 9256 RVA: 0x000F2998 File Offset: 0x000F0B98
        public static string MD5File(string filePath)
        {
            string result;
            try
            {
                FileStream fileStream = new FileStream(filePath, FileMode.Open);
                MD5 md = new MD5CryptoServiceProvider();
                byte[] array = md.ComputeHash(fileStream);
                fileStream.Close();
                StringBuilder stringBuilder = new StringBuilder();
                for (int i = 0; i < array.Length; i++)
                {
                    stringBuilder.Append(array[i].ToString("x2"));
                }

                result = stringBuilder.ToString();
                md.Dispose();
            }
            catch (Exception ex)
            {
                throw new Exception("MD5File fail, error:" + ex.Message);
            }

            return result;
        }

        // Token: 0x06002429 RID: 9257 RVA: 0x000F2A34 File Offset: 0x000F0C34
        public static string MD5String(string source)
        {
            bool flag = source.IsNullOrEmpty();
            string result;
            if (flag)
            {
                result = string.Empty;
            }
            else
            {
                MD5CryptoServiceProvider md5CryptoServiceProvider = new MD5CryptoServiceProvider();
                byte[] bytes = Encoding.UTF8.GetBytes(source);
                byte[] array = md5CryptoServiceProvider.ComputeHash(bytes, 0, bytes.Length);
                md5CryptoServiceProvider.Clear();
                string text = string.Empty;
                for (int i = 0; i < array.Length; i++)
                {
                    text += Convert.ToString(array[i], 16).PadLeft(2, '0');
                }

                text = text.PadLeft(32, '0');
                result = text;
                md5CryptoServiceProvider.Dispose();
            }

            return result;
        }

        // Token: 0x0600242A RID: 9258 RVA: 0x000F2ACC File Offset: 0x000F0CCC
        public static string Encrypt(byte[] buffer)
        {
            MD5 md = new MD5CryptoServiceProvider();
            byte[] array = md.ComputeHash(buffer);
            StringBuilder stringBuilder = new StringBuilder();
            for (int i = 0; i < array.Length; i++)
            {
                stringBuilder.Append(array[i].ToString("x2"));
            }

            md.Dispose();
            return stringBuilder.ToString();
        }

        // Token: 0x0600242B RID: 9259 RVA: 0x000F2B28 File Offset: 0x000F0D28
        public static string EncryptDES(string encryptString, string encryptKey = "89219417")
        {
            string result;
            try
            {
                byte[] bytes = Encoding.UTF8.GetBytes(encryptKey.Substring(0, 8));
                byte[] keys = MD5Helper.Keys;
                byte[] bytes2 = Encoding.UTF8.GetBytes(encryptString);
                DESCryptoServiceProvider descryptoServiceProvider = new DESCryptoServiceProvider();
                MemoryStream memoryStream = new MemoryStream();
                CryptoStream cryptoStream = new CryptoStream(memoryStream,
                    descryptoServiceProvider.CreateEncryptor(bytes, keys), CryptoStreamMode.Write);
                descryptoServiceProvider.Dispose();
                cryptoStream.Write(bytes2, 0, bytes2.Length);
                cryptoStream.FlushFinalBlock();
                result = Convert.ToBase64String(memoryStream.ToArray());
                memoryStream.Dispose();
                memoryStream.Close();
                cryptoStream.Dispose();
                cryptoStream.Close();
            }
            catch
            {
                result = encryptString;
            }

            return result;
        }

        // Token: 0x0600242C RID: 9260 RVA: 0x000F2BBC File Offset: 0x000F0DBC
        public static string DecryptDES(string decryptString, string decryptKey = "89219417")
        {
            string result;
            try
            {
                byte[] bytes = Encoding.UTF8.GetBytes(decryptKey);
                byte[] keys = MD5Helper.Keys;
                byte[] array = Convert.FromBase64String(decryptString);
                DESCryptoServiceProvider descryptoServiceProvider = new DESCryptoServiceProvider();
                MemoryStream memoryStream = new MemoryStream();
                CryptoStream cryptoStream = new CryptoStream(memoryStream,
                    descryptoServiceProvider.CreateDecryptor(bytes, keys), CryptoStreamMode.Write);
                cryptoStream.Write(array, 0, array.Length);
                cryptoStream.FlushFinalBlock();
                result = Encoding.UTF8.GetString(memoryStream.ToArray());
                descryptoServiceProvider.Dispose();
                cryptoStream.Dispose();
                cryptoStream.Close();
                memoryStream.Dispose();
                memoryStream.Close();
            }
            catch
            {
                result = decryptString;
            }

            return result;
        }

        // Token: 0x0600242D RID: 9261 RVA: 0x000F2C48 File Offset: 0x000F0E48
        public static byte[] EncryptBytes(byte[] src, string encryptKey = "89219417")
        {
            byte[] result;
            try
            {
                byte[] bytes = Encoding.UTF8.GetBytes(encryptKey.Substring(0, 8));
                byte[] keys = MD5Helper.Keys;
                DESCryptoServiceProvider descryptoServiceProvider = new DESCryptoServiceProvider();
                MemoryStream memoryStream = new MemoryStream();
                CryptoStream cryptoStream = new CryptoStream(memoryStream,
                    descryptoServiceProvider.CreateEncryptor(bytes, keys), CryptoStreamMode.Write);
                cryptoStream.Write(src, 0, src.Length);
                cryptoStream.FlushFinalBlock();
                result = memoryStream.ToArray();
                descryptoServiceProvider.Dispose();
                cryptoStream.Dispose();
                cryptoStream.Close();
                memoryStream.Dispose();
                memoryStream.Close();
            }
            catch
            {
                result = src;
            }

            return result;
        }

        // Token: 0x0600242E RID: 9262 RVA: 0x000F2CC8 File Offset: 0x000F0EC8
        public static byte[] DecryptBytes(byte[] src, string decryptKey = "89219417")
        {
            byte[] result;
            try
            {
                byte[] bytes = Encoding.UTF8.GetBytes(decryptKey);
                byte[] keys = MD5Helper.Keys;
                DESCryptoServiceProvider descryptoServiceProvider = new DESCryptoServiceProvider();
                MemoryStream memoryStream = new MemoryStream();
                CryptoStream cryptoStream = new CryptoStream(memoryStream,
                    descryptoServiceProvider.CreateDecryptor(bytes, keys), CryptoStreamMode.Write);
                cryptoStream.Write(src, 0, src.Length);
                cryptoStream.FlushFinalBlock();
                result = memoryStream.ToArray();
                descryptoServiceProvider.Dispose();
                cryptoStream.Dispose();
                cryptoStream.Close();
                memoryStream.Dispose();
                memoryStream.Close();
            }
            catch
            {
                result = src;
            }

            return result;
        }

        // Token: 0x040002C2 RID: 706
        public static byte[] Keys = new byte[]
        {
            18,
            52,
            86,
            120,
            144,
            171,
            205,
            239
        };

        // Token: 0x040002C3 RID: 707
        public const string DESKey = "89219417";

        public const int FileKey = 11;

        /// <summary> 加密文件
        ///
        /// </summary> 
        /// <param name="m_InFilePath">原路径</param> 
        /// <param name="m_OutFilePath">加密后的文件路径</param> 
        /// <param name="strEncrKey">密钥</param> 
        public static void DesEncryptFile(string m_InFilePath, string m_OutFilePath, string strEncrKey)
        {
            try
            {
                byte[] byKey = null;
                byte[] IV = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};

                byKey = Encoding.UTF8.GetBytes(strEncrKey.Substring(0, 8));
                FileStream fin = new FileStream(m_InFilePath, FileMode.Open, FileAccess.Read);
                FileStream fout = new FileStream(m_OutFilePath, FileMode.OpenOrCreate, FileAccess.Write);
                fout.SetLength(0);
                //Create variables to help with read and write. 
                byte[] bin = new byte[100]; //This is intermediate storage for the encryption. 
                long rdlen = 0; //This is the total number of bytes written. 
                long totlen = fin.Length; //This is the total length of the input file. 
                int len; //This is the number of bytes to be written at a time.

                DES des = new DESCryptoServiceProvider();
                CryptoStream encStream = new CryptoStream(fout, des.CreateEncryptor(byKey, IV), CryptoStreamMode.Write);

                //Read from the input file, then encrypt and write to the output file. 
                while (rdlen < totlen)
                {
                    len = fin.Read(bin, 0, 100);
                    encStream.Write(bin, 0, len);
                    rdlen = rdlen + len;
                }

                encStream.Close();
                fout.Close();
                fin.Close();
            }
            catch
            {
            }
        }

        /// <summary>
        /// 简易加密文件
        /// </summary>
        /// <param name="m_InFilePath"></param>
        /// <param name="m_OutFilePath"></param>
        /// <param name="sDecrKey"></param>
        public static void SamplyDESEn(string m_InFilePath, string m_OutFilePath, int length)
        {
            if (!Directory.Exists(Path.GetDirectoryName(m_OutFilePath)))
            {
                Directory.CreateDirectory(Path.GetDirectoryName(m_OutFilePath));
            }

            File.Copy(m_InFilePath, m_OutFilePath, true);
            byte[] filebytes = File.ReadAllBytes(m_OutFilePath);
            byte[] newfiles = new byte[filebytes.Length + length];
            for (int i = 0; i < length; i++)
            {
                newfiles[i] = (byte) ((i + length) * (length % (i + 1)));
            }

            for (int i = length; i < newfiles.Length; i++)
            {
                newfiles[i] = filebytes[i - length];
            }

            File.WriteAllBytes(m_OutFilePath, newfiles);
            if (File.Exists(m_InFilePath))
            {
                File.Delete(m_InFilePath);
            }

            File.Move(m_OutFilePath, m_InFilePath);
        }

        public static AssetBundle SamplyDESDN(string m_InFilePath, int length)
        {
            AssetBundle assetBundle = AssetBundle.LoadFromFile(m_InFilePath, 0, (ulong)length);
            return assetBundle;
        }

        public static AssetBundleCreateRequest SamplyDESDNAsync(string m_InFilePath, int length)
        {
            AssetBundleCreateRequest assetBundle = AssetBundle.LoadFromFileAsync(m_InFilePath, 0, (ulong)length);
            return assetBundle;
        }

        /// <summary> 解密文件
        /// 
        /// </summary> 
        /// <param name="m_InFilePath">被解密路径</param> 
        /// <param name="m_OutFilePath">解密后的路径</param> 
        /// <param name="sDecrKey">密钥</param> 
        public static void DesDecryptFile(string m_InFilePath, string m_OutFilePath, string sDecrKey)
        {
            try
            {
                byte[] byKey = null;
                byte[] IV = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};

                byKey = Encoding.UTF8.GetBytes(sDecrKey.Substring(0, 8));
                FileStream fin = new FileStream(m_InFilePath, FileMode.Open, FileAccess.Read);
                FileStream fout = new FileStream(m_OutFilePath, FileMode.OpenOrCreate, FileAccess.Write);
                fout.SetLength(0);
                //Create variables to help with read and write. 
                byte[] bin = new byte[100]; //This is intermediate storage for the encryption. 
                long rdlen = 0; //This is the total number of bytes written. 
                long totlen = fin.Length; //This is the total length of the input file. 
                int len; //This is the number of bytes to be written at a time.

                DES des = new DESCryptoServiceProvider();
                CryptoStream encStream = new CryptoStream(fout, des.CreateDecryptor(byKey, IV), CryptoStreamMode.Write);

                //Read from the input file, then encrypt and write to the output file. 
                while (rdlen < totlen)
                {
                    len = fin.Read(bin, 0, 100);
                    encStream.Write(bin, 0, len);
                    rdlen = rdlen + len;
                }

                encStream.Close();
                fout.Close();
                fin.Close();
            }
            catch
            {
            }
        }
        #region 加密字符串

        /// <summary> /// 加密字符串  
        /// </summary> 
        /// <param name="str">要加密的字符串</param> 
        /// <returns>加密后的字符串</returns> 
        public static string Encrypt(string str, string encryptKey)
        {
            DESCryptoServiceProvider descsp = new DESCryptoServiceProvider(); //实例化加/解密类对象  
            byte[] key = Encoding.Unicode.GetBytes(encryptKey); //定义字节数组，用来存储密钥   
            byte[] data = Encoding.Unicode.GetBytes(str); //定义字节数组，用来存储要加密的字符串 
            MemoryStream MStream = new MemoryStream(); //实例化内存流对象     
            //使用内存流实例化加密流对象  
            CryptoStream CStream = new CryptoStream(MStream, descsp.CreateEncryptor(key, key), CryptoStreamMode.Write);
            CStream.Write(data, 0, data.Length); //向加密流中写入数据
            CStream.FlushFinalBlock(); //释放加密流     
            return Convert.ToBase64String(MStream.ToArray()); //返回加密后的字符串 
        }

        #endregion


        #region 解密字符串

        /// <summary> 
        /// 解密字符串  
        /// </summary> 
        /// <param name="str">要解密的字符串</param> 
        /// <returns>解密后的字符串</returns> 
        public static string Decrypt(string str, string encryptKey)
        {
            DESCryptoServiceProvider descsp = new DESCryptoServiceProvider(); //实例化加/解密类对象   
            byte[] key = Encoding.Unicode.GetBytes(encryptKey); //定义字节数组，用来存储密钥   
            byte[] data = Convert.FromBase64String(str); //定义字节数组，用来存储要解密的字符串 
            MemoryStream MStream = new MemoryStream(); //实例化内存流对象     
            //使用内存流实例化解密流对象      
            CryptoStream CStream = new CryptoStream(MStream, descsp.CreateDecryptor(key, key), CryptoStreamMode.Write);
            CStream.Write(data, 0, data.Length); //向解密流中写入数据    
            CStream.FlushFinalBlock(); //释放解密流     
            return Encoding.Unicode.GetString(MStream.ToArray()); //返回解密后的字符串 
        }

        #endregion
    }
}