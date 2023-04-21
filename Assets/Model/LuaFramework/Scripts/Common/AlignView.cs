using System;
using System.Collections.Generic;
using UnityEngine;

namespace LuaFramework
{
	// Token: 0x020001C3 RID: 451
	public class AlignView : BaseBehaviour
	{
		// Token: 0x06002308 RID: 8968 RVA: 0x000EFFD4 File Offset: 0x000EE1D4
		protected new void Awake()
		{
			base.mLuaFileName = "AlignView";
			base.Awake();
			foreach (string func in AlignView.onExcludeNames)
			{
				base.addExcludeFuncName(func);
			}
		}

		// Token: 0x06002309 RID: 8969 RVA: 0x000F0040 File Offset: 0x000EE240
		protected new void Start()
		{
			base.Start();
		}

		// Token: 0x0600230A RID: 8970 RVA: 0x000F004C File Offset: 0x000EE24C
		public void arrangePos()
		{
			base.transform.localPosition = AlignView.changePos(base.transform.localPosition, this.align, this.isKeepPos);
			base.transform.localScale = AlignView.changeScale(base.transform.localScale, this.isScaleWithScreen);
		}

		// Token: 0x0600230B RID: 8971 RVA: 0x000F00A4 File Offset: 0x000EE2A4
		public static void setScreenArgs(float _screenRealWidth, float _screenRealHeight, float _screenMatchWidth, float _screenMatchHeight, bool _scaleMatchW)
		{
			bool flag = !AlignView.isInit;
			if (flag)
			{
				AlignView.isInit = true;
			}
			AlignView.ScreenRealHeight = _screenRealHeight;
			AlignView.ScreenRealWidth = _screenRealWidth;
			AlignView.ScreenMatchHeight = _screenMatchHeight;
			AlignView.ScreenMatchWidth = _screenMatchWidth;
			AlignView.isScaleMatchW = _scaleMatchW;
			AlignView.matchW_H = AlignView.ScreenMatchWidth / AlignView.ScreenMatchHeight;
			AlignView.realW_H = AlignView.ScreenRealWidth / AlignView.ScreenRealHeight;
			bool flag2 = (double)Mathf.Abs(AlignView.matchW_H - AlignView.realW_H) <= 0.01;
			if (flag2)
			{
				AlignView.isSameScale = true;
			}
			if (_scaleMatchW)
			{
				AlignView.ScreenMatchRealWidth = AlignView.ScreenMatchWidth;
				AlignView.ScreenMatchRealHeight = AlignView.ScreenMatchHeight / AlignView.realW_H * AlignView.matchW_H;
				AlignView.scaleW = 1f;
				AlignView.scaleH = AlignView.matchW_H / AlignView.realW_H;
			}
			else
			{
				AlignView.ScreenMatchRealHeight = AlignView.ScreenMatchHeight;
				AlignView.ScreenMatchRealWidth = AlignView.ScreenMatchWidth * AlignView.realW_H / AlignView.matchW_H;
				AlignView.scaleW = AlignView.realW_H / AlignView.matchW_H;
				AlignView.scaleH = 1f;
			}
			AlignView.scaleWhole = new Vector3(AlignView.scaleW, AlignView.scaleH, 0f);
			AlignView.matchLeftUpPos = new Vector3(-AlignView.ScreenMatchWidth / 2f, AlignView.ScreenMatchHeight / 2f, 0f);
			AlignView.matchLeftBottomPos = new Vector3(-AlignView.ScreenMatchWidth / 2f, -AlignView.ScreenMatchHeight / 2f, 0f);
			AlignView.matchRightUpPos = new Vector3(AlignView.ScreenMatchWidth / 2f, AlignView.ScreenMatchHeight / 2f, 0f);
			AlignView.matchRightBottomPos = new Vector3(AlignView.ScreenMatchWidth / 2f, -AlignView.ScreenMatchHeight / 2f, 0f);
			AlignView.matchUpPos = new Vector3(0f, AlignView.ScreenMatchHeight / 2f, 0f);
			AlignView.matchBottomPos = new Vector3(0f, -AlignView.ScreenMatchHeight / 2f, 0f);
			AlignView.matchLeftPos = new Vector3(-AlignView.ScreenMatchWidth / 2f, 0f, 0f);
			AlignView.matchRightPos = new Vector3(AlignView.ScreenMatchWidth / 2f, 0f, 0f);
			AlignView.leftUpPos = new Vector3(-AlignView.ScreenMatchRealWidth / 2f, AlignView.ScreenMatchRealHeight / 2f, 0f);
			AlignView.leftBottomPos = new Vector3(-AlignView.ScreenMatchRealWidth / 2f, -AlignView.ScreenMatchRealHeight / 2f, 0f);
			AlignView.rightUpPos = new Vector3(AlignView.ScreenMatchRealWidth / 2f, AlignView.ScreenMatchRealHeight / 2f, 0f);
			AlignView.rightBottomPos = new Vector3(AlignView.ScreenMatchRealWidth / 2f, -AlignView.ScreenMatchRealHeight / 2f, 0f);
			AlignView.upPos = new Vector3(0f, AlignView.ScreenMatchRealHeight / 2f, 0f);
			AlignView.bottomPos = new Vector3(0f, -AlignView.ScreenMatchRealHeight / 2f, 0f);
			AlignView.leftPos = new Vector3(-AlignView.ScreenMatchRealWidth / 2f, 0f, 0f);
			AlignView.rightPos = new Vector3(AlignView.ScreenMatchRealWidth / 2f, 0f, 0f);
		}

		// Token: 0x0600230C RID: 8972 RVA: 0x000F03F3 File Offset: 0x000EE5F3
		public void setAlign(int align)
		{
			this.align = (Align)align;
		}

		// Token: 0x0600230D RID: 8973 RVA: 0x000F0400 File Offset: 0x000EE600
		protected static Vector3 changeScale(Vector3 scale, bool isScaleWithScreen)
		{
			bool flag = AlignView.isSameScale;
			Vector3 result;
			if (flag)
			{
				result = scale;
			}
			else
			{
				bool flag2 = !isScaleWithScreen;
				if (flag2)
				{
					result = scale;
				}
				else
				{
					result = new Vector3(scale.x * AlignView.scaleWhole.x, scale.y * AlignView.scaleWhole.y, scale.z * AlignView.scaleWhole.z);
				}
			}
			return result;
		}

		// Token: 0x0600230E RID: 8974 RVA: 0x000F0468 File Offset: 0x000EE668
		protected static Vector3 changePos(Vector3 pos, Align align, bool isKeepPos)
		{
			bool flag = AlignView.isSameScale;
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
				case Align.Align_Normal:
					vector = pos;
					break;
				case Align.Align_LeftUp:
					if (isKeepPos)
					{
						vector = pos - AlignView.matchLeftUpPos;
						vector += AlignView.leftUpPos;
					}
					else
					{
						vector = AlignView.leftUpPos;
					}
					break;
				case Align.Align_Up:
					if (isKeepPos)
					{
						vector = pos - AlignView.matchUpPos;
						vector += AlignView.upPos;
					}
					else
					{
						vector = AlignView.upPos;
					}
					break;
				case Align.Align_RightUp:
					if (isKeepPos)
					{
						vector = pos - AlignView.matchRightPos;
						vector += AlignView.rightPos;
					}
					else
					{
						vector = AlignView.rightPos;
					}
					break;
				case Align.Align_Left:
					if (isKeepPos)
					{
						vector = pos - AlignView.matchLeftPos;
						vector += AlignView.leftPos;
					}
					else
					{
						vector = AlignView.leftPos;
					}
					break;
				case Align.Align_Mid:
					if (isKeepPos)
					{
						vector = pos;
					}
					else
					{
						bool flag2 = AlignView.isScaleMatchW;
						if (flag2)
						{
							vector=new Vector3(pos.x, pos.y / AlignView.realW_H, 0f);
						}
						else
						{
							vector= new Vector3(pos.x * AlignView.realW_H, pos.y, 0f);
						}
					}
					break;
				case Align.Align_Right:
					if (isKeepPos)
					{
						vector = pos - AlignView.matchRightPos;
						vector += AlignView.rightPos;
					}
					else
					{
						vector = AlignView.rightPos;
					}
					break;
				case Align.Align_LeftBottom:
					if (isKeepPos)
					{
						vector = pos - AlignView.matchLeftBottomPos;
						vector += AlignView.leftBottomPos;
					}
					else
					{
						vector = AlignView.leftBottomPos;
					}
					break;
				case Align.Align_Bottom:
					if (isKeepPos)
					{
						vector = pos - AlignView.matchBottomPos;
						vector += AlignView.bottomPos;
					}
					else
					{
						vector = AlignView.bottomPos;
					}
					break;
				case Align.Align_RightBottom:
					if (isKeepPos)
					{
						vector = pos - AlignView.matchRightBottomPos;
						vector += AlignView.rightBottomPos;
					}
					else
					{
						vector = AlignView.rightBottomPos;
					}
					break;
				}
				result = vector;
			}
			return result;
		}

		// Token: 0x040001F0 RID: 496
		public Align align = Align.Align_Normal;

		// Token: 0x040001F1 RID: 497
		public bool isScaleWithScreen = false;

		// Token: 0x040001F2 RID: 498
		public bool isKeepPos = false;

		// Token: 0x040001F3 RID: 499
		private static List<string> onExcludeNames = new List<string>
		{
			"OnTriggerEnter",
			"OnTriggerStay"
		};

		// Token: 0x040001F4 RID: 500
		private static float ScreenRealHeight;

		// Token: 0x040001F5 RID: 501
		private static float ScreenRealWidth;

		// Token: 0x040001F6 RID: 502
		private static float ScreenMatchHeight;

		// Token: 0x040001F7 RID: 503
		private static float ScreenMatchWidth;

		// Token: 0x040001F8 RID: 504
		private static float ScreenMatchRealWidth;

		// Token: 0x040001F9 RID: 505
		private static float ScreenMatchRealHeight;

		// Token: 0x040001FA RID: 506
		private static bool isSameScale = false;

		// Token: 0x040001FB RID: 507
		private static bool isScaleMatchW;

		// Token: 0x040001FC RID: 508
		private static bool isInit = false;

		// Token: 0x040001FD RID: 509
		private static Vector3 matchLeftUpPos;

		// Token: 0x040001FE RID: 510
		private static Vector3 matchLeftBottomPos;

		// Token: 0x040001FF RID: 511
		private static Vector3 matchRightUpPos;

		// Token: 0x04000200 RID: 512
		private static Vector3 matchRightBottomPos;

		// Token: 0x04000201 RID: 513
		private static Vector3 matchUpPos;

		// Token: 0x04000202 RID: 514
		private static Vector3 matchBottomPos;

		// Token: 0x04000203 RID: 515
		private static Vector3 matchLeftPos;

		// Token: 0x04000204 RID: 516
		private static Vector3 matchRightPos;

		// Token: 0x04000205 RID: 517
		private static Vector3 leftUpPos;

		// Token: 0x04000206 RID: 518
		private static Vector3 leftBottomPos;

		// Token: 0x04000207 RID: 519
		private static Vector3 rightUpPos;

		// Token: 0x04000208 RID: 520
		private static Vector3 rightBottomPos;

		// Token: 0x04000209 RID: 521
		private static Vector3 upPos;

		// Token: 0x0400020A RID: 522
		private static Vector3 bottomPos;

		// Token: 0x0400020B RID: 523
		private static Vector3 leftPos;

		// Token: 0x0400020C RID: 524
		private static Vector3 rightPos;

		// Token: 0x0400020D RID: 525
		private static float scaleW;

		// Token: 0x0400020E RID: 526
		private static float scaleH;

		// Token: 0x0400020F RID: 527
		private static Vector3 scaleWhole;

		// Token: 0x04000210 RID: 528
		private static float matchW_H;

		// Token: 0x04000211 RID: 529
		private static float realW_H;
	}
}
