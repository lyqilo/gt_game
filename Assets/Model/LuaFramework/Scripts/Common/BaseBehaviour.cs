using System;
using System.Collections.Generic;
using LuaInterface;
using UnityEngine;

namespace LuaFramework
{
	// Token: 0x020001DE RID: 478
	public class BaseBehaviour : MonoBehaviour
	{
		// Token: 0x170000F3 RID: 243
		// (get) Token: 0x0600247B RID: 9339 RVA: 0x000F3E8B File Offset: 0x000F208B
		// (set) Token: 0x0600247C RID: 9340 RVA: 0x000F3E93 File Offset: 0x000F2093
		public LuaTable mLuaTable { get; set; }

		// Token: 0x170000F4 RID: 244
		// (get) Token: 0x0600247D RID: 9341 RVA: 0x000F3E9C File Offset: 0x000F209C
		// (set) Token: 0x0600247E RID: 9342 RVA: 0x000F3EA4 File Offset: 0x000F20A4
		public string mLuaFileName { get; set; }

		// Token: 0x0600247F RID: 9343 RVA: 0x000F3EB0 File Offset: 0x000F20B0
		protected void Awake()
		{
			bool flag = this.mLuaFileName.IsNullOrEmpty();
			if (flag)
			{
				this.mLuaFileName = base.name;
				this.mLuaFileName = this.mLuaFileName.Replace("(Clone)", "");
			}
            this.lua = AppFacade.Instance.GetManager<LuaManager>();

            bool flag2 = this.mLuaTable == null;
			if (flag2)
			{
				this.mLuaTable = this.lua.GetTable(this.mLuaFileName);
			}
			this.funcAwake = this.lua.GetFunction(string.Format("{0}.Awake", this.mLuaFileName), false);
			bool flag3 = this.funcAwake == null;
			if (flag3)
			{
				this.funcAwake = this.lua.GetFunction(this.mLuaFileName + ".Begin", false);
			}
			this.funcStart = this.lua.GetFunction(string.Format("{0}.Start", this.mLuaFileName), false);
			this.funcUpdate = this.lua.GetFunction(string.Format("{0}.Update", this.mLuaFileName), false);
			this.funcFixedUpdate = this.lua.GetFunction(string.Format("{0}.FixedUpdate", this.mLuaFileName), false);
			this.funcOnEnable = this.lua.GetFunction(string.Format("{0}.OnEnable", this.mLuaFileName), false);
			this.funcOnClick = this.lua.GetFunction(string.Format("{0}.OnClick", this.mLuaFileName), false);
			this.funcOnBeginDrag = this.lua.GetFunction(string.Format("{0}.OnBeginDrag", this.mLuaFileName), false);
			this.funcOnDrag = this.lua.GetFunction(string.Format("{0}.OnDrag", this.mLuaFileName), false);
			this.funcOnEndDrag = this.lua.GetFunction(string.Format("{0}.OnEndDrag", this.mLuaFileName), false);
			this.funcOnDrop = this.lua.GetFunction(string.Format("{0}.OnDrop", this.mLuaFileName), false);
			this.funcOnDestroy = this.lua.GetFunction(string.Format("{0}.OnDestroy", this.mLuaFileName), false);
			this.funcOnPointerClick = this.lua.GetFunction(string.Format("{0}.OnPointerClick", this.mLuaFileName), false);
			this.funcOnWillRenderObject = this.lua.GetFunction(string.Format("{0}.OnWillRenderObject", this.mLuaFileName), false);
			this.funcOnTriggerEnter = this.lua.GetFunction(string.Format("{0}.OnTriggerEnter", this.mLuaFileName), false);
			this.funcOnTriggerStay = this.lua.GetFunction(string.Format("{0}.OnTriggerStay", this.mLuaFileName), false);
			this.funcAnimationOnStateEnter = this.lua.GetFunction(string.Format("{0}.AnimationOnStateEnter", this.mLuaFileName), false);
			this.funcAnimationOnStateExit = this.lua.GetFunction(string.Format("{0}.AnimationOnStateExit", this.mLuaFileName), false);
			this.funcAnimationOnStateMove = this.lua.GetFunction(string.Format("{0}.AnimationOnStateMove", this.mLuaFileName), false);
			this.funcAnimationOnPlyerOver = this.lua.GetFunction(string.Format("{0}.AnimationOnPlyerOver", this.mLuaFileName), false);
			try
			{
				this.CallFunc(this.funcAwake, new object[]
				{
					this.mLuaTable,
					base.gameObject
				});
			}
			catch (LuaException ex)
			{
				Debugger.LogError(ex.Message);
			}
		}

		// Token: 0x06002480 RID: 9344 RVA: 0x000F4234 File Offset: 0x000F2434
		protected void Start()
		{
			this.CallFunc(this.funcStart, new object[]
			{
				this.mLuaTable,
				base.gameObject
			});
		}

		// Token: 0x06002481 RID: 9345 RVA: 0x000F425C File Offset: 0x000F245C
		public void CallFunc(LuaFunction func, params object[] args)
		{
			bool flag = func == null;
			if (!flag)
			{
				this.lua.CallFunction(func, args);
			}
		}

		// Token: 0x06002482 RID: 9346 RVA: 0x000F4286 File Offset: 0x000F2486
		public void CallFunc(string func, params object[] args)
		{
			this.lua.CallFunction(string.Format("{0}.{1}", base.name, func), args);
		}

		// Token: 0x06002483 RID: 9347 RVA: 0x000F42A8 File Offset: 0x000F24A8
		public void SetLuaTab(LuaTable tb, string name = "")
		{
			this.mLuaTable = tb;
			bool flag = !name.Equals("");
			if (flag)
			{
				this.mLuaFileName = name;
			}
			this.Awake();
		}

		// Token: 0x06002484 RID: 9348 RVA: 0x000F42E1 File Offset: 0x000F24E1
		public void addExcludeFuncName(string func)
		{
			this.excludeSet.Add(func);
		}

		// Token: 0x06002485 RID: 9349 RVA: 0x000F42F1 File Offset: 0x000F24F1
		protected void OnEnable()
		{
			this.CallFunc(this.funcOnEnable, new object[]
			{
				this.mLuaTable,
				base.gameObject
			});
		}

		// Token: 0x06002486 RID: 9350 RVA: 0x000F4319 File Offset: 0x000F2519
		protected void Update()
		{
			this.CallFunc(this.funcUpdate, new object[]
			{
				this.mLuaTable,
				base.gameObject
			});
		}

		// Token: 0x06002487 RID: 9351 RVA: 0x000F4341 File Offset: 0x000F2541
		protected void FixedUpdate()
		{
			this.CallFunc(this.funcFixedUpdate, new object[]
			{
				this.mLuaTable,
				base.gameObject
			});
		}

		// Token: 0x06002488 RID: 9352 RVA: 0x000F4369 File Offset: 0x000F2569
		protected void OnTriggerEnter(Collider coll)
		{
			this.CallFunc(this.funcOnTriggerEnter, new object[]
			{
				this.mLuaTable,
				coll
			});
		}

		// Token: 0x06002489 RID: 9353 RVA: 0x000F438C File Offset: 0x000F258C
		protected void OnTriggerStay(Collider coll)
		{
			this.CallFunc(this.funcOnTriggerStay, new object[]
			{
				this.mLuaTable,
				coll
			});
		}

		// Token: 0x040002D4 RID: 724
		protected HashSet<string> excludeSet = new HashSet<string>();

		// Token: 0x040002D7 RID: 727
		public LuaManager lua;

		// Token: 0x040002D8 RID: 728
		protected LuaFunction funcAwake = null;

		// Token: 0x040002D9 RID: 729
		protected LuaFunction funcStart = null;

		// Token: 0x040002DA RID: 730
		protected LuaFunction funcUpdate = null;

		// Token: 0x040002DB RID: 731
		protected LuaFunction funcFixedUpdate = null;

		// Token: 0x040002DC RID: 732
		protected LuaFunction funcOnEnable = null;

		// Token: 0x040002DD RID: 733
		protected LuaFunction funcOnClick = null;

		// Token: 0x040002DE RID: 734
		protected LuaFunction funcOnBeginDrag = null;

		// Token: 0x040002DF RID: 735
		protected LuaFunction funcOnDrag = null;

		// Token: 0x040002E0 RID: 736
		protected LuaFunction funcOnEndDrag = null;

		// Token: 0x040002E1 RID: 737
		protected LuaFunction funcOnDrop = null;

		// Token: 0x040002E2 RID: 738
		protected LuaFunction funcOnPointerClick = null;

		// Token: 0x040002E3 RID: 739
		protected LuaFunction funcOnWillRenderObject = null;

		// Token: 0x040002E4 RID: 740
		protected LuaFunction funcOnTriggerEnter = null;

		// Token: 0x040002E5 RID: 741
		protected LuaFunction funcOnTriggerStay = null;

		// Token: 0x040002E6 RID: 742
		protected LuaFunction funcAnimationOnStateEnter = null;

		// Token: 0x040002E7 RID: 743
		protected LuaFunction funcAnimationOnStateExit = null;

		// Token: 0x040002E8 RID: 744
		protected LuaFunction funcAnimationOnStateMove = null;

		// Token: 0x040002E9 RID: 745
		protected LuaFunction funcAnimationOnPlyerOver = null;

		// Token: 0x040002EA RID: 746
		protected LuaFunction funcOnDestroy = null;
	}
}
