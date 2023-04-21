using System;
using UnityEngine;

namespace LuaFramework
{
	// Token: 0x020001C1 RID: 449
	public static class CSExtension
	{
		// Token: 0x06002302 RID: 8962 RVA: 0x000EFE48 File Offset: 0x000EE048
		public static string RemoveSuffix(this string args)
		{
			bool flag = args.Contains(".");
			if (flag)
			{
				string[] array = args.Split(new char[]
				{
					'.'
				});
				args = array[0];
			}
			return args;
		}

		// Token: 0x06002303 RID: 8963 RVA: 0x000EFE84 File Offset: 0x000EE084
		public static string[] SortArray(this string[] args)
		{
			string text = string.Empty;
			text = args[0];
			for (int i = 0; i < args.Length - 1; i++)
			{
				args[i] = args[i + 1];
			}
			args[args.Length - 1] = text;
			return args;
		}

		// Token: 0x06002304 RID: 8964 RVA: 0x000EFEC8 File Offset: 0x000EE0C8
		public static string[] SortConst(this string[] args, int idex)
		{
			bool flag = args.Length > idex;
			string[] result;
			if (flag)
			{
				result = args;
			}
			else
			{
				string text = args[0];
				args[0] = args[idex];
				args[idex] = text;
				result = args;
			}
			return result;
		}

		// Token: 0x06002305 RID: 8965 RVA: 0x000EFEF8 File Offset: 0x000EE0F8
		public static bool IsNullOrEmpty(this string args)
		{
			bool flag = args == null;
			bool result;
			if (flag)
			{
				result = true;
			}
			else
			{
				bool flag2 = args == "nil";
				if (flag2)
				{
					result = true;
				}
				else
				{
					bool flag3 = args == "null";
					if (flag3)
					{
						result = true;
					}
					else
					{
						bool flag4 = args == string.Empty;
						result = flag4;
					}
				}
			}
			return result;
		}

		// Token: 0x06002306 RID: 8966 RVA: 0x000EFF58 File Offset: 0x000EE158
		public static string FormatPath(this string args)
		{
			return args.Replace("\\", "/");
		}

		// Token: 0x06002307 RID: 8967 RVA: 0x000EFF7C File Offset: 0x000EE17C
		public static float MatchWidthOrHeight(this Screen args)
		{
			int width = Screen.width;
			int height = Screen.height;
			int num = 1344;
			int num2 = 750;
			float num3 = (float)num2 / (float)num;
			float num4 = (float)height / (float)width;
			bool flag = num3 > num4;
			float result;
			if (flag)
			{
				result = 1f;
			}
			else
			{
				result = 0f;
			}
			return result;
		}
	}
}
