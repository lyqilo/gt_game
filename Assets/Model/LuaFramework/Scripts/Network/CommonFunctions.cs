using System;
using System.IO;
using System.Text;
using System.Collections;
using System.Security.Cryptography;
using System.Runtime.InteropServices;


    public class CommonFunctions
    {
        //object转byte[]
       private static  Encoding EN = Encoding.Unicode;
        public static byte[] ObjectToBytes(object sendData, int iStartIndex = -1, int iLen = 0)
        {
            int size = Marshal.SizeOf(sendData); //得到数据的大小
            byte[] bytes = new byte[size]; //创建byte数组
            System.IntPtr structPtr = Marshal.AllocHGlobal(size); //分配内存空间
            Marshal.StructureToPtr(sendData, structPtr, false); //拷到分配好的内存空间
            Marshal.Copy(structPtr, bytes, 0, size); //从内存空间拷到byte数组
            Marshal.FreeHGlobal(structPtr); //释放内存空间

            if (iStartIndex >= 0 && iLen > 0)
            {
                //减到多余的
                byte[] bytesDst = new byte[size - iLen];
                System.Buffer.BlockCopy(bytes, 0, bytesDst, 0, iStartIndex);
                System.Buffer.BlockCopy(bytes, iStartIndex + iLen, bytesDst, iStartIndex, size - iLen - iStartIndex);
                return bytesDst;
            }
            return bytes;

        }


        //byte[]转object
        public static object BytesToObject(byte[] bytes, Type type)
        {

            System.IntPtr objPtr = Marshal.AllocHGlobal(bytes.Length); //分配内存空间
            Marshal.Copy(bytes, 0, objPtr, bytes.Length);
            object obj = (object)Marshal.PtrToStructure(objPtr, type);
            Marshal.FreeHGlobal(objPtr); //释放内存空间
            return obj;
        }

		//byte[]转object
		public static T BytesToObject<T>(byte[] bytes)
		{

			System.IntPtr objPtr = Marshal.AllocHGlobal(bytes.Length); //分配内存空间
			Marshal.Copy(bytes, 0, objPtr, bytes.Length);
			object obj = (object)Marshal.PtrToStructure(objPtr, typeof(T));
			Marshal.FreeHGlobal(objPtr); //释放内存空间
			return (T)obj;
		}

        //byte[]转string
        public static string BytesToString(byte[] bytes,int iLen = -1)
        {
            if (-1 == iLen)
            {
                return EN.GetString(bytes).Replace("\0", "");
            }
            else
            {
                byte[] by = new byte[iLen];
                System.Buffer.BlockCopy(bytes, 0, by, 0, iLen);
                return EN.GetString(by).Replace("\0", "");
            }
        }

        //string转byte[]
        public static byte[] StringToBytes(string strSrc,int iDstLen = -1)
        {
            if(-1 == iDstLen)
            {
                return EN.GetBytes(strSrc);
            }
            else
            {
                byte[] byDst = new byte[iDstLen];
                byte[] bySrc = EN.GetBytes(strSrc);
                System.Buffer.BlockCopy(bySrc, 0, byDst, 0, bySrc.Length);
                return byDst;
            }
        }

        //int转ip登录服务器
        public static string Int2IP_LoginServer(System.UInt32 ipCode)
        {
            byte a = (byte)((ipCode & 0xFF000000) >> 0x18);//24
            byte b = (byte)((ipCode & 0x00FF0000) >> 0x10);//16
            byte c = (byte)((ipCode & 0x0000FF00) >> 0x8);//8
            byte d = (byte)(ipCode & 0x000000FF);
            string ipStr = string.Format("{0}.{1}.{2}.{3}", a, b, c, d);
            return ipStr;
        }

        //int转ip
        public static string Int2IP(System.UInt32 ipCode)
        {
            byte a = (byte)((ipCode & 0xFF000000) >> 0x18);//24
            byte b = (byte)((ipCode & 0x00FF0000) >> 0x10);//16
            byte c = (byte)((ipCode & 0x0000FF00) >> 0x8);//8
            byte d = (byte)(ipCode & 0x000000FF);
            string ipStr = string.Format("{3}.{2}.{1}.{0}", a, b, c, d);
            return ipStr;
        }

        //获取信息
        public static string GetMsg(byte[] dataBytes,ref int iOffset)
        {
            int iIntSize = Marshal.SizeOf(typeof(int));
            int iShortSize = Marshal.SizeOf(typeof(short));

            byte[] bySize = new byte[iShortSize];
            System.Buffer.BlockCopy(dataBytes, iOffset, bySize, 0, iShortSize);
            short sSize = System.BitConverter.ToInt16(bySize, 0);

            byte[] byMsg = new byte[sSize];
            System.Buffer.BlockCopy(dataBytes, iOffset + iIntSize, byMsg, 0, sSize);

            iOffset += sSize + iIntSize;

            return BytesToString(byMsg);
        }

        // 获取JSON信息
        public static string GetJsonMsg(string strMsg,string strKey)
        {
            int iStartIndex = strMsg.IndexOf(strKey);
            if(-1 == iStartIndex)
            {
                return string.Empty;
            }
            iStartIndex += strKey.Length + 2;

            int iStopIndex = strMsg.IndexOfAny(new char[]{',','}'},iStartIndex);
            if (-1 == iStopIndex)
            {
                return string.Empty;
            }
            string strValue = strMsg.Substring(iStartIndex,iStopIndex - iStartIndex).Replace("\"","");

            return strValue;
        }

    //private static GlobalDef.System_Info m_systemInfo;//系统信息

    ////设置系统信息
    //public static void SetSystemInfo(GlobalDef.System_Info systemInfo)
    //{
    //    m_systemInfo = systemInfo;
    //}

    ////获取头像地址
    //public static string GetHeaderAddress(bool bCustomHeader, byte byGender, System.UInt32 dwUser_Id, string strHeaderExtensionName)
    //    {
    //        string strUser_Id = dwUser_Id.ToString();
    //        if (!bCustomHeader)
    //        {
    //            strHeaderExtensionName = "0" + byGender .ToString()+ "png";
    //        }
    //        return m_systemInfo.strWebServerAddress + "/" + m_systemInfo.strHeaderDir + "/" + strUser_Id + "." + strHeaderExtensionName;
    //    }

    //    public static bool UpLoadHeaderFile(string strAccount, string strPassword, string strLocalFileName, out string strRespnse)
    //    {
    //        string strAddress = m_systemInfo.strWebServerAddress + "/" + m_systemInfo.strHeaderUpLoadPage + "?Account=" + strAccount + "&Password=" + strPassword;
    //        System.Net.WebClient webClient = new System.Net.WebClient();
    //        byte[] byResponse = webClient.UploadFile(strAddress, "POST", strLocalFileName);
    //        strRespnse = Encoding.GetEncoding("UTF-8").GetString(byResponse);
    //        bool bSuccess = strRespnse.Contains("success");
    //        return bSuccess;
    //    }

		public static void CopyBytesContent(byte[] dest, byte[] src)
		{
			for (int i = 0; i < src.Length; i++)
			{
				dest[i] = src[i];
			}
		}

		public static void CopyStringBytesContent(byte[] dest, string str)
		{
			CopyBytesContent(dest, StringToBytes(str));
		}
    }

