using System;
using UnityEngine;

namespace LuaFramework
{
	// Token: 0x0200024B RID: 587
	public class IMGResolution : MonoBehaviour
	{
		// Token: 0x06002789 RID: 10121 RVA: 0x00104AE8 File Offset: 0x00102CE8
		private void Awake()
		{
			int width = Screen.width;
			int height = Screen.height;
			int num = (int)(base.transform as RectTransform).sizeDelta.x;
			int num2 = (int)(base.transform as RectTransform).sizeDelta.y;
			float num3 = (float)num / (float)num2;
			float num4 = (float)width / (float)height;
			bool flag = num3 < num4;
			if (flag)
			{
				num = Mathf.FloorToInt((float)num2 * num4);
			}
			else
			{
				bool flag2 = num3 > num4;
				if (flag2)
				{
					num2 = Mathf.FloorToInt((float)num / num4);
				}
			}
			RectTransform rectTransform = base.transform as RectTransform;
			bool flag3 = rectTransform != null;
			if (flag3)
			{
				rectTransform.sizeDelta = new Vector2((float)num, (float)num2);
			}
		}

		// Token: 0x0600278A RID: 10122 RVA: 0x00104BA0 File Offset: 0x00102DA0
		public static float MatchWidthOrHeight()
		{
			int width = Screen.width;
			int height = Screen.height;
			int num = 1344;
			int num2 = 750;
			float num3 = (float)num2 / (float)num;
			float num4 = (float)height / (float)width;
			bool flag = num3 < num4;
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
