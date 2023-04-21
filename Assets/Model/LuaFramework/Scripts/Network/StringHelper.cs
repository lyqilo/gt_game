using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;

namespace LuaFramework
{
    public static class StringHelper
    {
        public static IEnumerable<byte> ToBytes(this string str)
        {
            return Encoding.Default.GetBytes(str);
        }

        public static byte[] ToByteArray(this string str)
        {
            return Encoding.Default.GetBytes(str);
        }

        public static byte[] ToUtf8(this string str)
        {
            return Encoding.UTF8.GetBytes(str);
        }

        public static byte[] HexToBytes(this string hexString)
        {
            bool flag = hexString.Length % 2 != 0;
            if (flag)
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "The binary key cannot have an odd number of digits: {0}", hexString));
            }
            byte[] array = new byte[hexString.Length / 2];
            for (int i = 0; i < array.Length; i++)
            {
                string text = "";
                text += hexString[i * 2].ToString();
                text += hexString[i * 2 + 1].ToString();
                array[i] = byte.Parse(text, NumberStyles.HexNumber, CultureInfo.InvariantCulture);
            }
            return array;
        }

        public static string Fmt(this string text, params object[] args)
        {
            return string.Format(text, args);
        }

        public static string ListToString<T>(this List<T> list)
        {
            StringBuilder stringBuilder = new StringBuilder();
            foreach (T t in list)
            {
                stringBuilder.Append(t);
                stringBuilder.Append(",");
            }
            return stringBuilder.ToString();
        }

        public static string ToHex(string s)
        {
            string name = "utf-8";
            bool flag = false;
            bool flag2 = s.Length % 2 != 0;
            if (flag2)
            {
                s += " ";
            }
            Encoding encoding = Encoding.GetEncoding(name);
            byte[] bytes = encoding.GetBytes(s);
            string text = "";
            for (int i = 0; i < bytes.Length; i++)
            {
                text += string.Format("{0:X}", bytes[i]);
                bool flag3 = flag && i != bytes.Length - 1;
                if (flag3)
                {
                    text += string.Format("{0}", ",");
                }
            }
            return text.ToLower();
        }

        public static string UnHex(string hex)
        {
            string name = "utf-8";
            bool flag = hex == null;
            if (flag)
            {
                throw new ArgumentNullException("hex");
            }
            hex = hex.Replace(",", "");
            hex = hex.Replace("\n", "");
            hex = hex.Replace("\\", "");
            hex = hex.Replace(" ", "");
            bool flag2 = hex.Length % 2 != 0;
            if (flag2)
            {
                hex += "20";
            }
            byte[] array = new byte[hex.Length / 2];
            for (int i = 0; i < array.Length; i++)
            {
                try
                {
                    array[i] = byte.Parse(hex.Substring(i * 2, 2), NumberStyles.HexNumber);
                }
                catch
                {
                    throw new ArgumentException("hex is not a valid hex number!", "hex");
                }
            }
            Encoding encoding = Encoding.GetEncoding(name);
            return encoding.GetString(array);
        }
    }
}
