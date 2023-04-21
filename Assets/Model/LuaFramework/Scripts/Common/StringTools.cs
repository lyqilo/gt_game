// dnSpy decompiler from Assembly-CSharp.dll class: StringTools
using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;

public class StringTools
{
	public static string GetFirstMatch(string str, string regexStr)
	{
		Match match = Regex.Match(str, regexStr);
		if (!string.IsNullOrEmpty(match.ToString()))
		{
			return match.ToString();
		}
		return null;
	}

	public static string[] GetAllMatchs(string str, string regexStr)
	{
		MatchCollection matchCollection = Regex.Matches(str, regexStr);
		if (matchCollection.Count == 0)
		{
			return null;
		}
		string[] array = new string[matchCollection.Count];
		for (int i = 0; i < matchCollection.Count; i++)
		{
			array[i] = matchCollection[i].Value;
		}
		return array;
	}

	public static List<string> GetAllMatchs2(string str, string regexStr)
	{
		MatchCollection matchCollection = Regex.Matches(str, regexStr);
		if (matchCollection.Count == 0)
		{
			return null;
		}
		List<string> list = new List<string>();
		for (int i = 0; i < matchCollection.Count; i++)
		{
			list.Add(matchCollection[i].Value);
		}
		return list;
	}

	public static string Format(string str, params object[] args)
	{
		string text = str;
		string pattern = "\\{[0-9]+\\}";
		MatchCollection matchCollection = Regex.Matches(str, pattern);
		if (matchCollection.Count > 0)
		{
			for (int i = 0; i < matchCollection.Count; i++)
			{
				if (i < args.Length)
				{
					string oldValue = "{" + i + "}";
					text = text.Replace(oldValue, args[i].ToString());
				}
			}
		}
		return text;
	}

	public static string[] Split(string str, string splitStr)
	{
		return Regex.Split(str, splitStr);
	}

	public static List<string> Split2(string str, string splitStr)
	{
		string[] array = Regex.Split(str, splitStr);
		List<string> list = new List<string>();
		for (int i = 0; i < array.Length; i++)
		{
			list.Add(array[i]);
		}
		return list;
	}

	public static string RemoveReturn(string str)
	{
		return StringTools.Replace(str, "\r\n|\r|\n", string.Empty);
	}

	public static string Replace(string str, string str1, string str2)
	{
		Regex regex = new Regex(str1);
		return regex.Replace(str, str2);
	}

	public static bool isNeedUpdata(string wwwVer, string localVer)
	{
		if (string.IsNullOrEmpty(localVer))
		{
			return true;
		}
		string[] array = wwwVer.Split(new char[]
		{
			'.'
		});
		string[] array2 = localVer.Split(new char[]
		{
			'.'
		});
		int num = (array.Length <= array2.Length) ? array2.Length : array.Length;
		bool result = false;
		for (int i = 0; i < num; i++)
		{
			int value = StringTools.GetValue(array, i);
			int value2 = StringTools.GetValue(array2, i);
			if (value > value2)
			{
				result = true;
				break;
			}
			if (value2 > value)
			{
				break;
			}
		}
		return result;
	}

	private static int GetValue(string[] strs, int ind)
	{
		if (strs.Length > ind)
		{
			return int.Parse(strs[ind]);
		}
		return 0;
	}

	public static string GetExName(string str)
	{
		string regexStr = "(?<=\\.)[^\\.]+$";
		return StringTools.GetFirstMatch(str, regexStr);
	}

	public static string RemoveExName(string str)
	{
		string regexStr = ".+(?=\\.)";
		string text = StringTools.GetFirstMatch(str, regexStr);
		if (string.IsNullOrEmpty(text))
		{
			text = str;
		}
		return text;
	}

	public static int String2Unicode(string str)
	{
		UnicodeEncoding unicodeEncoding = new UnicodeEncoding();
		byte[] bytes = unicodeEncoding.GetBytes(str);
		int num = 0;
		for (int i = 0; i < bytes.Length; i++)
		{
			int num2 = (int)bytes[i];
			int num3 = (int)Math.Pow(256.0, (double)i) * num2;
			num += num3;
		}
		return num;
	}

	public static int[] String2Unicodes(string str)
	{
		int[] array = new int[str.Length];
		for (int i = 0; i < str.Length; i++)
		{
			string str2 = str.Substring(i, 1);
			array[i] = StringTools.String2Unicode(str2);
		}
		return array;
	}

	public static bool IsNumber(string expression)
	{
		string pattern = "^\\-?[0-9]+(\\.[0-9]*)?$";
		MatchCollection matchCollection = Regex.Matches(expression, pattern);
		return matchCollection.Count > 0;
	}

	//public static string AnalysNumber2CNS(string numberr)
	//{
	//	string text = string.Empty;
	//	List<string> list = new List<string>();
	//	list.Add(Language.Get("cNum_0"));
	//	list.Add(Language.Get("cNum_1"));
	//	list.Add(Language.Get("cNum_2"));
	//	list.Add(Language.Get("cNum_3"));
	//	list.Add(Language.Get("cNum_4"));
	//	list.Add(Language.Get("cNum_5"));
	//	list.Add(Language.Get("cNum_6"));
	//	list.Add(Language.Get("cNum_7"));
	//	list.Add(Language.Get("cNum_8"));
	//	list.Add(Language.Get("cNum_9"));
	//	list.Add(Language.Get("cNum_10"));
	//	list.Add(Language.Get("cNum_100"));
	//	for (int i = 0; i < numberr.Length; i++)
	//	{
	//		int index = Convert.ToInt32(numberr.Substring(i, 1));
	//		text += list[index];
	//	}
	//	if (numberr.Length == 2)
	//	{
	//		int num = Convert.ToInt32(numberr.Substring(0, 1));
	//		if (Convert.ToInt32(numberr.Substring(1, 1)) == 0)
	//		{
	//			text = text.Replace(list[0], list[10]);
	//			if (num == 1)
	//			{
	//				text = text.Substring(1, text.Length - 1);
	//			}
	//		}
	//		else
	//		{
	//			text = text.Insert(1, list[10]);
	//			if (num == 1)
	//			{
	//				text = text.Substring(1, text.Length - 1);
	//			}
	//		}
	//	}
	//	if (numberr.Length == 3)
	//	{
	//		int num2 = Convert.ToInt32(numberr.Substring(1, 1));
	//		int num3 = Convert.ToInt32(numberr.Substring(2, 1));
	//		if (num2 == 0 && num3 == 0)
	//		{
	//			text = text.Replace(list[0], string.Empty);
	//			text += list[11];
	//		}
	//		else if (num2 == 0 && num3 != 0)
	//		{
	//			text = text.Insert(1, list[11]);
	//		}
	//		else if (num2 != 0 && num3 == 0)
	//		{
	//			text = text.Insert(1, list[11]);
	//			text = text.Replace(list[0], list[10]);
	//		}
	//		else
	//		{
	//			text = text.Insert(1, list[10]);
	//			text = text.Insert(3, list[9]);
	//		}
	//	}
	//	return text;
	//}

	public static string InsertSpace2String(string s, int c)
	{
		char[] array = s.ToCharArray();
		string text = string.Empty;
		foreach (char c2 in array)
		{
			text += c2.ToString();
			for (int j = 0; j < c - 1; j++)
			{
				text += " ";
			}
		}
		return text;
	}
}
