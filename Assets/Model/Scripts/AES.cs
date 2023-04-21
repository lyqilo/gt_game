using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

/// <summary>
/// AES加密解密
/// </summary>
public class AES
{
    #region 加密

    #region 加密字符串

    /// <summary>
    /// AES 加密(高级加密标准，是下一代的加密算法标准，速度快，安全级别高，目前 AES 标准的一个实现是 Rijndael 算法)
    /// </summary>
    /// <param name="encryptString">待加密密文</param>
    /// <param name="encryptKey">加密密钥</param>
    public static string AESEncrypt(string encryptString, string encryptKey)
    {
        return Convert.ToBase64String(AESEncrypt(Encoding.Default.GetBytes(encryptString), encryptKey));
    }

    #endregion

    #region 加密字节数组

    /// <summary>
    /// AES 加密(高级加密标准，是下一代的加密算法标准，速度快，安全级别高，目前 AES 标准的一个实现是 Rijndael 算法)
    /// </summary>
    /// <param name="encryptByte">待加密密文</param>
    /// <param name="encryptKey">加密密钥</param>
    public static byte[] AESEncrypt(byte[] encryptByte, string encryptKey)
    {
        if (encryptByte.Length == 0)
        {
            throw (new Exception("明文不得为空"));
        }

        if (string.IsNullOrEmpty(encryptKey))
        {
            throw (new Exception("密钥不得为空"));
        }

        byte[] mStrEncrypt;
        byte[] mBtIv = Convert.FromBase64String("Rkb4jvUy/ye7Cd7k89QQgQ==");
        byte[] mSalt = Convert.FromBase64String("gsf4jvkyhye5/d7k8OrLgM==");
        Rijndael mAesProvider = Rijndael.Create();
        try
        {
            MemoryStream mStream = new MemoryStream();
            PasswordDeriveBytes pdb = new PasswordDeriveBytes(encryptKey, mSalt);
            ICryptoTransform transform = mAesProvider.CreateEncryptor(pdb.GetBytes(32), mBtIv);
            CryptoStream mCsstream = new CryptoStream(mStream, transform, CryptoStreamMode.Write);
            mCsstream.Write(encryptByte, 0, encryptByte.Length);
            mCsstream.FlushFinalBlock();
            mStrEncrypt = mStream.ToArray();
            mStream.Close();
            mStream.Dispose();
            mCsstream.Close();
            mCsstream.Dispose();
        }
        catch (IOException ex)
        {
            throw ex;
        }
        catch (CryptographicException ex)
        {
            throw ex;
        }
        catch (ArgumentException ex)
        {
            throw ex;
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            mAesProvider.Clear();
        }

        return mStrEncrypt;
    }

    #endregion

    #endregion

    #region 解密

    #region 解密字符串

    /// <summary>
    /// AES 解密(高级加密标准，是下一代的加密算法标准，速度快，安全级别高，目前 AES 标准的一个实现是 Rijndael 算法)
    /// </summary>
    /// <param name="decryptString">待解密密文</param>
    /// <param name="decryptKey">解密密钥</param>
    public static string AESDecrypt(string decryptString, string decryptKey)
    {
        return Convert.ToBase64String(AESDecrypt(Encoding.Default.GetBytes(decryptString), decryptKey));
    }

    #endregion

    #region 解密字节数组

    /// <summary>
    /// AES 解密(高级加密标准，是下一代的加密算法标准，速度快，安全级别高，目前 AES 标准的一个实现是 Rijndael 算法)
    /// </summary>
    /// <param name="decryptByte">待解密密文</param>
    /// <param name="decryptKey">解密密钥</param>
    public static byte[] AESDecrypt(byte[] decryptByte, string decryptKey)
    {
        if (decryptByte.Length == 0)
        {
            throw (new Exception("密文不得为空"));
        }

        if (string.IsNullOrEmpty(decryptKey))
        {
            throw (new Exception("密钥不得为空"));
        }

        byte[] mStrDecrypt;
        byte[] mBtIv = Convert.FromBase64String("Rkb4jvUy/ye7Cd7k89QQgQ==");
        byte[] mSalt = Convert.FromBase64String("gsf4jvkyhye5/d7k8OrLgM==");
        Rijndael mAesProvider = Rijndael.Create();
        try
        {
            MemoryStream mStream = new MemoryStream();
            PasswordDeriveBytes pdb = new PasswordDeriveBytes(decryptKey, mSalt);
            ICryptoTransform transform = mAesProvider.CreateDecryptor(pdb.GetBytes(32), mBtIv);
            CryptoStream mCsstream = new CryptoStream(mStream, transform, CryptoStreamMode.Write);
            mCsstream.Write(decryptByte, 0, decryptByte.Length);
            mCsstream.FlushFinalBlock();
            mStrDecrypt = mStream.ToArray();
            mStream.Close();
            mStream.Dispose();
            mCsstream.Close();
            mCsstream.Dispose();
        }
        catch (IOException ex)
        {
            throw ex;
        }
        catch (CryptographicException ex)
        {
            throw ex;
        }
        catch (ArgumentException ex)
        {
            throw ex;
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            mAesProvider.Clear();
        }

        return mStrDecrypt;
    }

    #endregion

    #endregion
}