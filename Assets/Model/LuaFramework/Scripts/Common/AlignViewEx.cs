using System;
using System.Collections.Generic;
using UnityEngine;

namespace LuaFramework
{
	// Token: 0x020001C5 RID: 453
	public class AlignViewEx : BaseBehaviour
	{
		// Token: 0x06002311 RID: 8977 RVA: 0x000F06F4 File Offset: 0x000EE8F4
		protected new void Awake()
		{
			base.mLuaFileName = "AlignView";
			base.Awake();
			foreach (string func in AlignViewEx.onExcludeNames)
			{
				base.addExcludeFuncName(func);
			}
		}

		// Token: 0x06002312 RID: 8978 RVA: 0x000F0040 File Offset: 0x000EE240
		protected new void Start()
		{
			base.Start();
		}

		// Token: 0x06002313 RID: 8979 RVA: 0x000F0760 File Offset: 0x000EE960
		public void arrangePos()
		{
			base.transform.localPosition = AlignViewEx.changePos(base.transform.localPosition, this.align, this.isKeepPos);
			base.transform.localScale = AlignViewEx.changeScale(base.transform.localScale, this.isScaleWithScreen);
		}

		// Token: 0x06002314 RID: 8980 RVA: 0x000F07B8 File Offset: 0x000EE9B8
		public static void setScreenArgs(float _screenRealWidth, float _screenRealHeight, float _screenMatchWidth, float _screenMatchHeight, bool _scaleMatchW)
		{
			AlignViewEx.isInit = true;
			AlignViewEx.ScreenRealHeight = _screenRealHeight;
			AlignViewEx.ScreenRealWidth = _screenRealWidth;
			AlignViewEx.ScreenMatchHeight = _screenMatchHeight;
			AlignViewEx.ScreenMatchWidth = _screenMatchWidth;
			AlignViewEx.isScaleMatchW = _scaleMatchW;
			AlignViewEx.matchW_H = AlignViewEx.ScreenMatchWidth / AlignViewEx.ScreenMatchHeight;
			AlignViewEx.realW_H = AlignViewEx.ScreenRealWidth / AlignViewEx.ScreenRealHeight;
			bool flag = (double)Mathf.Abs(AlignViewEx.matchW_H - AlignViewEx.realW_H) <= 0.01;
			if (flag)
			{
				AlignViewEx.isSameScale = true;
			}
			if (_scaleMatchW)
			{
				AlignViewEx.ScreenMatchRealWidth = AlignViewEx.ScreenMatchWidth;
				AlignViewEx.ScreenMatchRealHeight = AlignViewEx.ScreenMatchHeight / AlignViewEx.realW_H * AlignViewEx.matchW_H;
				AlignViewEx.scaleW = 1f;
				AlignViewEx.scaleH = AlignViewEx.matchW_H / AlignViewEx.realW_H;
			}
			else
			{
				AlignViewEx.ScreenMatchRealHeight = AlignViewEx.ScreenMatchHeight;
				AlignViewEx.ScreenMatchRealWidth = AlignViewEx.ScreenMatchWidth * AlignViewEx.realW_H / AlignViewEx.matchW_H;
				AlignViewEx.scaleW = AlignViewEx.realW_H / AlignViewEx.matchW_H;
				AlignViewEx.scaleH = 1f;
			}
			AlignViewEx.scaleWhole = new Vector3(AlignViewEx.scaleW, AlignViewEx.scaleH, 0f);
			AlignViewEx.matchLeftUpPos = new Vector3(-AlignViewEx.ScreenMatchWidth / 2f, AlignViewEx.ScreenMatchHeight / 2f, 0f);
			AlignViewEx.matchLeftBottomPos = new Vector3(-AlignViewEx.ScreenMatchWidth / 2f, -AlignViewEx.ScreenMatchHeight / 2f, 0f);
			AlignViewEx.matchRightUpPos = new Vector3(AlignViewEx.ScreenMatchWidth / 2f, AlignViewEx.ScreenMatchHeight / 2f, 0f);
			AlignViewEx.matchRightBottomPos = new Vector3(AlignViewEx.ScreenMatchWidth / 2f, -AlignViewEx.ScreenMatchHeight / 2f, 0f);
			AlignViewEx.matchUpPos = new Vector3(0f, AlignViewEx.ScreenMatchHeight / 2f, 0f);
			AlignViewEx.matchBottomPos = new Vector3(0f, -AlignViewEx.ScreenMatchHeight / 2f, 0f);
			AlignViewEx.matchLeftPos = new Vector3(-AlignViewEx.ScreenMatchWidth / 2f, 0f, 0f);
			AlignViewEx.matchRightPos = new Vector3(AlignViewEx.ScreenMatchWidth / 2f, 0f, 0f);
			AlignViewEx.leftUpPos = new Vector3(-AlignViewEx.ScreenMatchRealWidth / 2f, AlignViewEx.ScreenMatchRealHeight / 2f, 0f);
			AlignViewEx.leftBottomPos = new Vector3(-AlignViewEx.ScreenMatchRealWidth / 2f, -AlignViewEx.ScreenMatchRealHeight / 2f, 0f);
			AlignViewEx.rightUpPos = new Vector3(AlignViewEx.ScreenMatchRealWidth / 2f, AlignViewEx.ScreenMatchRealHeight / 2f, 0f);
			AlignViewEx.rightBottomPos = new Vector3(AlignViewEx.ScreenMatchRealWidth / 2f, -AlignViewEx.ScreenMatchRealHeight / 2f, 0f);
			AlignViewEx.upPos = new Vector3(0f, AlignViewEx.ScreenMatchRealHeight / 2f, 0f);
			AlignViewEx.bottomPos = new Vector3(0f, -AlignViewEx.ScreenMatchRealHeight / 2f, 0f);
			AlignViewEx.leftPos = new Vector3(-AlignViewEx.ScreenMatchRealWidth / 2f, 0f, 0f);
			AlignViewEx.rightPos = new Vector3(AlignViewEx.ScreenMatchRealWidth / 2f, 0f, 0f);
		}

		// Token: 0x06002315 RID: 8981 RVA: 0x000F0AFB File Offset: 0x000EECFB
		public void setAlign(int align)
		{
			this.align = (AlignEx)align;
		}

		// Token: 0x06002316 RID: 8982 RVA: 0x000F0B08 File Offset: 0x000EED08
		protected static Vector3 changeScale(Vector3 scale, bool isScaleWithScreen)
		{
			bool flag = AlignViewEx.isSameScale;
			Vector3 result;
			if (flag)
			{
				result = scale;
			}
			else
			{
				result = new Vector3(scale.x * AlignViewEx.scaleWhole.x, scale.y * AlignViewEx.scaleWhole.y, scale.z * AlignViewEx.scaleWhole.z);
			}
			return result;
		}

		// Token: 0x06002317 RID: 8983 RVA: 0x000F0B60 File Offset: 0x000EED60
		protected static Vector3 changePos(Vector3 pos, AlignEx align, bool isKeepPos)
		{
			bool flag = AlignViewEx.isSameScale;
			Vector3 result;
			if (flag)
			{
				result = pos;
			}
			else
			{
				Vector3 vector = Vector3.zero;
				switch (align)
				{
				case AlignEx.Align_Normal:
					vector = pos;
					break;
				case AlignEx.Align_LeftUp:
					if (isKeepPos)
					{
						vector = pos - AlignViewEx.matchLeftUpPos;
						vector += AlignViewEx.leftUpPos;
					}
					else
					{
						vector = AlignViewEx.leftUpPos;
					}
					break;
				case AlignEx.Align_Up:
					if (isKeepPos)
					{
						vector = pos - AlignViewEx.matchUpPos;
						vector += AlignViewEx.upPos;
					}
					else
					{
						vector = AlignViewEx.upPos;
					}
					break;
				case AlignEx.Align_RightUp:
					if (isKeepPos)
					{
						vector = pos - AlignViewEx.matchRightPos;
						vector += AlignViewEx.rightPos;
					}
					else
					{
						vector = AlignViewEx.rightPos;
					}
					break;
				case AlignEx.Align_Left:
					if (isKeepPos)
					{
						vector = pos - AlignViewEx.matchLeftPos;
						vector += AlignViewEx.leftPos;
					}
					else
					{
						vector = AlignViewEx.leftPos;
					}
					break;
				case AlignEx.Align_Mid:
					if (isKeepPos)
					{
						vector = pos;
					}
					else
					{
						bool flag2 = AlignViewEx.isScaleMatchW;
						if (flag2)
						{
                                vector = new Vector3(pos.x, pos.y / AlignViewEx.realW_H, 0f);
						}
						else
						{
                                vector = new Vector3(pos.x * AlignViewEx.realW_H, pos.y, 0f);
						}
					}
					break;
				case AlignEx.Align_Right:
					if (isKeepPos)
					{
						vector = pos - AlignViewEx.matchRightPos;
						vector += AlignViewEx.rightPos;
					}
					else
					{
						vector = AlignViewEx.rightPos;
					}
					break;
				case AlignEx.Align_LeftBottom:
					if (isKeepPos)
					{
						vector = pos - AlignViewEx.matchLeftBottomPos;
						vector += AlignViewEx.leftBottomPos;
					}
					else
					{
						vector = AlignViewEx.leftBottomPos;
					}
					break;
				case AlignEx.Align_Bottom:
					if (isKeepPos)
					{
						vector = pos - AlignViewEx.matchBottomPos;
						vector += AlignViewEx.bottomPos;
					}
					else
					{
						vector = AlignViewEx.bottomPos;
					}
					break;
				case AlignEx.Align_RightBottom:
					if (isKeepPos)
					{
						vector = pos - AlignViewEx.matchRightBottomPos;
						vector += AlignViewEx.rightBottomPos;
					}
					else
					{
						vector = AlignViewEx.rightBottomPos;
					}
					break;
				}
				result = vector;
			}
			return result;
		}

		// Token: 0x0400021D RID: 541
		public AlignEx align = AlignEx.Align_Normal;

		// Token: 0x0400021E RID: 542
		public bool isScaleWithScreen = false;

		// Token: 0x0400021F RID: 543
		public bool isKeepPos = false;

		// Token: 0x04000220 RID: 544
		private static List<string> onExcludeNames = new List<string>
		{
			"OnTriggerEnter",
			"OnTriggerStay"
		};

		// Token: 0x04000221 RID: 545
		private static float ScreenRealHeight;

		// Token: 0x04000222 RID: 546
		private static float ScreenRealWidth;

		// Token: 0x04000223 RID: 547
		private static float ScreenMatchHeight;

		// Token: 0x04000224 RID: 548
		private static float ScreenMatchWidth;

		// Token: 0x04000225 RID: 549
		private static float ScreenMatchRealWidth;

		// Token: 0x04000226 RID: 550
		private static float ScreenMatchRealHeight;

		// Token: 0x04000227 RID: 551
		private static bool isSameScale = false;

		// Token: 0x04000228 RID: 552
		private static bool isScaleMatchW;

		// Token: 0x04000229 RID: 553
		private static bool isInit = false;

		// Token: 0x0400022A RID: 554
		private static Vector3 matchLeftUpPos;

		// Token: 0x0400022B RID: 555
		private static Vector3 matchLeftBottomPos;

		// Token: 0x0400022C RID: 556
		private static Vector3 matchRightUpPos;

		// Token: 0x0400022D RID: 557
		private static Vector3 matchRightBottomPos;

		// Token: 0x0400022E RID: 558
		private static Vector3 matchUpPos;

		// Token: 0x0400022F RID: 559
		private static Vector3 matchBottomPos;

		// Token: 0x04000230 RID: 560
		private static Vector3 matchLeftPos;

		// Token: 0x04000231 RID: 561
		private static Vector3 matchRightPos;

		// Token: 0x04000232 RID: 562
		private static Vector3 leftUpPos;

		// Token: 0x04000233 RID: 563
		private static Vector3 leftBottomPos;

		// Token: 0x04000234 RID: 564
		private static Vector3 rightUpPos;

		// Token: 0x04000235 RID: 565
		private static Vector3 rightBottomPos;

		// Token: 0x04000236 RID: 566
		private static Vector3 upPos;

		// Token: 0x04000237 RID: 567
		private static Vector3 bottomPos;

		// Token: 0x04000238 RID: 568
		private static Vector3 leftPos;

		// Token: 0x04000239 RID: 569
		private static Vector3 rightPos;

		// Token: 0x0400023A RID: 570
		private static float scaleW;

		// Token: 0x0400023B RID: 571
		private static float scaleH;

		// Token: 0x0400023C RID: 572
		private static Vector3 scaleWhole;

		// Token: 0x0400023D RID: 573
		private static float matchW_H;

		// Token: 0x0400023E RID: 574
		private static float realW_H;
	}
}
