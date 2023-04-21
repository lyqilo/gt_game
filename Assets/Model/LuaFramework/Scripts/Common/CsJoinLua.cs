using System;
using System.Collections.Generic;
using LuaInterface;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace LuaFramework
{
	// Token: 0x020001E0 RID: 480
	public class CsJoinLua : EventTrigger
	{
		// Token: 0x0600248C RID: 9356 RVA: 0x000F4454 File Offset: 0x000F2654
		private void Awake()
		{
			this.lua = AppFacade.Instance.GetManager<LuaManager>();
		}

		// Token: 0x0600248D RID: 9357 RVA: 0x000F4462 File Offset: 0x000F2662
		public void LoadLua(string path, string modeName)
		{
			path = path.Replace(".", "/");
			this.lua.DoFile(path);
			this.Init(modeName);
		}

		// Token: 0x0600248E RID: 9358 RVA: 0x000F448C File Offset: 0x000F268C
		public void SetLuaFunc(int type, string luaString, string modeName)
		{
			bool flag = type == 2;
			if (flag)
			{
				this.lua.DoFile(luaString);
			}
			bool flag2 = type == 1;
			if (flag2)
			{
				this.lua.DoString(luaString);
			}
			this.Init(modeName);
		}

		// Token: 0x0600248F RID: 9359 RVA: 0x000F44D0 File Offset: 0x000F26D0
		public void Init(string modeName)
		{
			this.mLuaTable = this.lua.GetTable(modeName);
			this.funcBegin = this.lua.GetFunction(modeName + ".Awake", false);
			bool flag = this.funcBegin == null;
			if (flag)
			{
				this.funcBegin = this.lua.GetFunction(modeName + ".Start", false);
			}
			bool flag2 = this.funcBegin == null;
			if (flag2)
			{
				this.funcBegin = this.lua.GetFunction(modeName + ".Begin", false);
			}
			this.funcUpdate = this.lua.GetFunction(modeName + ".Update", false);
			this.funcFixedUpdate = this.lua.GetFunction(modeName + ".FixedUpdate", false);
			this.funcLateUpdate = this.lua.GetFunction(modeName + ".LateUpdate", false);
			this.funcOnBecameVisible = this.lua.GetFunction(modeName + ".OnBecameVisible", false);
			this.funcOnBecameInvisible = this.lua.GetFunction(modeName + ".OnBecameInvisible", false);
			this.funcOnEnable = this.lua.GetFunction(modeName + ".OnEnable", false);
			this.funcOnTriggerEnter = this.lua.GetFunction(modeName + ".OnTriggerEnter", false);
			this.funcOnTriggerStay = this.lua.GetFunction(modeName + ".OnTriggerStay", false);
			this.funcOnPointerClick = this.lua.GetFunction(modeName + ".OnPointerClick", false);
			this.funcOnPointerDown = this.lua.GetFunction(modeName + ".OnPointerDown", false);
			this.funcOnPointerEnter = this.lua.GetFunction(modeName + ".OnPointerEnter", false);
			this.funcOnPointerExit = this.lua.GetFunction(modeName + ".OnPointerExit", false);
			this.funcOnPointerUp = this.lua.GetFunction(modeName + ".OnPointerUp", false);
			this.funcOnSelect = this.lua.GetFunction(modeName + ".OnSelect", false);
			this.funcOnUpdateSelected = this.lua.GetFunction(modeName + ".OnUpdateSelected", false);
			this.funcOnBeginDrag = this.lua.GetFunction(modeName + ".OnBeginDrag", false);
			this.funcOnCancel = this.lua.GetFunction(modeName + ".OnCancel", false);
			this.funcOnDeselect = this.lua.GetFunction(modeName + ".OnDeselect", false);
			this.funcOnDrag = this.lua.GetFunction(modeName + ".OnDrag", false);
			this.funcOnDrop = this.lua.GetFunction(modeName + ".OnDrop", false);
			this.funcOnEndDrag = this.lua.GetFunction(modeName + ".OnEndDrag", false);
			this.funcOnMove = this.lua.GetFunction(modeName + ".OnMove", false);
			this.funcOnInitializePotentialDrag = this.lua.GetFunction(modeName + ".OnInitializePotentialDrag", false);
			this.funcOnScroll = this.lua.GetFunction(modeName + ".OnScroll", false);
			this.funcOnSubmit = this.lua.GetFunction(modeName + ".OnSubmit", false);
			this.funcOnDestroy = this.lua.GetFunction(modeName + ".OnDestroy", false);
			this.Begin();
		}

		// Token: 0x06002490 RID: 9360 RVA: 0x000F4864 File Offset: 0x000F2A64
		public void CallFunc(LuaFunction func, object obj = null)
		{
			bool flag = obj == null;
			if (flag)
			{
				obj = base.gameObject;
			}
			bool flag2 = func == null;
			if (!flag2)
			{
				this.lua.CallFunction(func, new object[]
				{
					this.mLuaTable,
					obj
				});
			}
		}

		// Token: 0x06002491 RID: 9361 RVA: 0x000F48B4 File Offset: 0x000F2AB4
		public void CallFunc(LuaFunction func, object obj, bool isTab = true)
		{
			bool flag = obj == null;
			if (flag)
			{
				obj = base.gameObject;
			}
			bool flag2 = func == null;
			if (!flag2)
			{
				if (isTab)
				{
					this.lua.CallFunction(func, new object[]
					{
						this.mLuaTable,
						obj
					});
				}
				else
				{
					this.lua.CallFunction(func, new object[]
					{
						obj
					});
				}
			}
		}

		// Token: 0x06002492 RID: 9362 RVA: 0x000F4924 File Offset: 0x000F2B24
		public void CallFunc(string func, params object[] args)
		{
			this.lua.CallFunction(string.Format("{0}.{1}", base.name, func), new object[]
			{
				this.mLuaTable,
				args
			});
		}

		// Token: 0x06002493 RID: 9363 RVA: 0x000F4958 File Offset: 0x000F2B58
		protected void Begin()
		{
			try
			{
				this.CallFunc(this.funcBegin, base.gameObject);
				this.isRun = true;
			}
			catch (LuaException ex)
			{
				DebugTool.LogError(ex.Message);
			}
		}

		// Token: 0x06002494 RID: 9364 RVA: 0x000F49A8 File Offset: 0x000F2BA8
		protected void OnEnable()
		{
			bool flag = this.funcOnEnable != null;
			if (flag)
			{
				this.CallFunc(this.funcOnEnable, null);
			}
		}

		// Token: 0x06002495 RID: 9365 RVA: 0x000F49D8 File Offset: 0x000F2BD8
		protected void OnBecameVisible()
		{
			bool flag = this.funcOnBecameVisible != null && this.isRun;
			if (flag)
			{
				this.CallFunc(this.funcOnBecameVisible, null);
			}
		}

		// Token: 0x06002496 RID: 9366 RVA: 0x000F4A14 File Offset: 0x000F2C14
		protected void OnBecameInvisible()
		{
			bool flag = this.funcOnBecameInvisible != null && this.isRun;
			if (flag)
			{
				this.CallFunc(this.funcOnBecameInvisible, null);
			}
		}

		// Token: 0x06002497 RID: 9367 RVA: 0x000F4A50 File Offset: 0x000F2C50
		protected void Update()
		{
			bool flag = this.isRun && this.funcUpdate != null;
			if (flag)
			{
				this.CallFunc(this.funcUpdate, null);
			}
		}

		// Token: 0x06002498 RID: 9368 RVA: 0x000F4A8C File Offset: 0x000F2C8C
		protected void FixedUpdate()
		{
			bool flag = this.isRun && this.funcFixedUpdate != null;
			if (flag)
			{
				this.CallFunc(this.funcFixedUpdate, null);
			}
		}

		// Token: 0x06002499 RID: 9369 RVA: 0x000F4AC8 File Offset: 0x000F2CC8
		protected void LateUpdate()
		{
			bool flag = this.isRun && this.funcLateUpdate != null;
			if (flag)
			{
				this.CallFunc(this.funcLateUpdate, null);
			}
		}

		// Token: 0x0600249A RID: 9370 RVA: 0x000F4B04 File Offset: 0x000F2D04
		protected void OnTriggerEnter(Collider coll)
		{
			bool flag = this.isRun && this.funcOnTriggerEnter != null;
			if (flag)
			{
				this.CallFunc(this.funcOnTriggerEnter, coll.gameObject);
			}
		}

		// Token: 0x0600249B RID: 9371 RVA: 0x000F4B44 File Offset: 0x000F2D44
		protected void OnTriggerStay(Collider coll)
		{
			bool flag = this.isRun && this.funcOnTriggerStay != null;
			if (flag)
			{
				this.CallFunc(this.funcOnTriggerStay, coll.gameObject);
			}
		}

		// Token: 0x0600249C RID: 9372 RVA: 0x000F4B82 File Offset: 0x000F2D82
		public void AnimationOnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
		{
			this.CallFunc("AnimationOnStateEnter", new object[]
			{
				animator,
				stateInfo,
				layerIndex
			});
		}

		// Token: 0x0600249D RID: 9373 RVA: 0x000F4BAD File Offset: 0x000F2DAD
		public void AnimationOnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
		{
			this.CallFunc("AnimationOnStateExit", new object[]
			{
				animator,
				stateInfo,
				layerIndex
			});
		}

		// Token: 0x0600249E RID: 9374 RVA: 0x000F4BD8 File Offset: 0x000F2DD8
		public void AnimationOnStateMove(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
		{
			this.CallFunc("AnimationOnStateMove", new object[]
			{
				animator,
				stateInfo,
				layerIndex
			});
		}

		// Token: 0x0600249F RID: 9375 RVA: 0x000F4C03 File Offset: 0x000F2E03
		public void AnimationOnPlyerOver(string str)
		{
			base.transform.Rotate(Vector3.up, 12f);
			this.CallFunc("AnimationOnPlyerOver", new object[]
			{
				str
			});
		}

		// Token: 0x060024A0 RID: 9376 RVA: 0x000F4C34 File Offset: 0x000F2E34
		public void AddClick(GameObject go, LuaFunction luafunc)
		{
			bool flag = go == null;
			if (!flag)
			{
				this.AddLuaEvents.Add(luafunc);
				go.GetComponent<Button>().onClick.AddListener(delegate
				{
					this.CallFunc(luafunc, go, false);
				});
			}
		}

		// Token: 0x060024A1 RID: 9377 RVA: 0x000F4CA4 File Offset: 0x000F2EA4
		public void AddValueChangeEvent(GameObject go, LuaFunction luafunc)
		{
			bool flag = go == null;
			if (!flag)
			{
				this.AddLuaEvents.Add(luafunc);
				go.GetComponent<InputField>().onValueChanged.AddListener(delegate(string str)
				{
					this.CallFunc(luafunc, go, false);
				});
			}
		}

		// Token: 0x060024A2 RID: 9378 RVA: 0x000F4D14 File Offset: 0x000F2F14
		public void AddEndEditEvent(GameObject go, LuaFunction luafunc)
		{
			bool flag = go == null;
			if (!flag)
			{
				this.AddLuaEvents.Add(luafunc);
				go.GetComponent<InputField>().onEndEdit.AddListener(delegate(string str)
				{
					this.CallFunc(luafunc, go, false);
				});
			}
		}

		// Token: 0x060024A3 RID: 9379 RVA: 0x000F4D84 File Offset: 0x000F2F84
		public void AddScrollbarEvent(GameObject go, LuaFunction luafunc)
		{
			bool flag = go == null;
			if (!flag)
			{
				this.AddLuaEvents.Add(luafunc);
				go.GetComponent<Scrollbar>().onValueChanged.AddListener(delegate(float f)
				{
					this.CallFunc(luafunc, go, false);
				});
			}
		}

		// Token: 0x060024A4 RID: 9380 RVA: 0x000F4DF4 File Offset: 0x000F2FF4
		public void AddSliderEvent(GameObject go, LuaFunction luafunc)
		{
			bool flag = go == null;
			if (!flag)
			{
				this.AddLuaEvents.Add(luafunc);
				go.GetComponent<Slider>().onValueChanged.AddListener(delegate(float f)
				{
					this.CallFunc(luafunc, go, false);
				});
			}
		}

		// Token: 0x060024A5 RID: 9381 RVA: 0x000F4E64 File Offset: 0x000F3064
		public void ClearClick()
		{
			for (int i = 0; i < this.AddLuaEvents.Count; i++)
			{
				bool flag = this.AddLuaEvents[i] != null;
				if (flag)
				{
					this.AddLuaEvents[i].Dispose();
					this.AddLuaEvents[i] = null;
				}
			}
		}

		// Token: 0x060024A6 RID: 9382 RVA: 0x000F4EC8 File Offset: 0x000F30C8
		public override void OnPointerClick(PointerEventData eventData)
		{
			bool flag = this.funcOnPointerClick != null;
			if (flag)
			{
				this.CallFunc(this.funcOnPointerClick, eventData);
			}
		}

		// Token: 0x060024A7 RID: 9383 RVA: 0x000F4EF4 File Offset: 0x000F30F4
		public override void OnPointerDown(PointerEventData eventData)
		{
			bool flag = this.funcOnPointerDown != null;
			if (flag)
			{
				this.CallFunc(this.funcOnPointerDown, eventData);
			}
		}

		// Token: 0x060024A8 RID: 9384 RVA: 0x000F4F20 File Offset: 0x000F3120
		public override void OnPointerEnter(PointerEventData eventData)
		{
			bool flag = this.funcOnPointerEnter != null;
			if (flag)
			{
				this.CallFunc(this.funcOnPointerEnter, eventData);
			}
		}

		// Token: 0x060024A9 RID: 9385 RVA: 0x000F4F4C File Offset: 0x000F314C
		public override void OnPointerExit(PointerEventData eventData)
		{
			bool flag = this.funcOnPointerExit != null;
			if (flag)
			{
				this.CallFunc(this.funcOnPointerExit, eventData);
			}
		}

		// Token: 0x060024AA RID: 9386 RVA: 0x000F4F78 File Offset: 0x000F3178
		public override void OnPointerUp(PointerEventData eventData)
		{
			bool flag = this.funcOnPointerUp != null;
			if (flag)
			{
				this.CallFunc(this.funcOnPointerUp, eventData);
			}
		}

		// Token: 0x060024AB RID: 9387 RVA: 0x000F4FA4 File Offset: 0x000F31A4
		public override void OnSelect(BaseEventData eventData)
		{
			bool flag = this.funcOnSelect != null;
			if (flag)
			{
				this.CallFunc(this.funcOnSelect, eventData);
			}
		}

		// Token: 0x060024AC RID: 9388 RVA: 0x000F4FD0 File Offset: 0x000F31D0
		public override void OnUpdateSelected(BaseEventData eventData)
		{
			bool flag = this.funcOnUpdateSelected != null;
			if (flag)
			{
				this.CallFunc(this.funcOnUpdateSelected, eventData);
			}
		}

		// Token: 0x060024AD RID: 9389 RVA: 0x000F4FFC File Offset: 0x000F31FC
		public override void OnBeginDrag(PointerEventData eventData)
		{
			bool flag = this.funcOnBeginDrag != null;
			if (flag)
			{
				this.CallFunc(this.funcOnBeginDrag, eventData);
			}
		}

		// Token: 0x060024AE RID: 9390 RVA: 0x000F5028 File Offset: 0x000F3228
		public override void OnCancel(BaseEventData eventData)
		{
			bool flag = this.funcOnCancel != null;
			if (flag)
			{
				this.CallFunc(this.funcOnCancel, eventData);
			}
		}

		// Token: 0x060024AF RID: 9391 RVA: 0x000F5054 File Offset: 0x000F3254
		public override void OnDeselect(BaseEventData eventData)
		{
			bool flag = this.funcOnDeselect != null;
			if (flag)
			{
				this.CallFunc(this.funcOnDeselect, eventData);
			}
		}

		// Token: 0x060024B0 RID: 9392 RVA: 0x000F5080 File Offset: 0x000F3280
		public override void OnDrag(PointerEventData eventData)
		{
			bool flag = this.funcOnDrag != null;
			if (flag)
			{
				this.CallFunc(this.funcOnDrag, eventData);
			}
		}

		// Token: 0x060024B1 RID: 9393 RVA: 0x000F50AC File Offset: 0x000F32AC
		public override void OnDrop(PointerEventData eventData)
		{
			bool flag = this.funcOnDrop != null;
			if (flag)
			{
				this.CallFunc(this.funcOnDrop, eventData);
			}
		}

		// Token: 0x060024B2 RID: 9394 RVA: 0x000F50D8 File Offset: 0x000F32D8
		public override void OnEndDrag(PointerEventData eventData)
		{
			bool flag = this.funcOnEndDrag != null;
			if (flag)
			{
				this.CallFunc(this.funcOnEndDrag, eventData);
			}
		}

		// Token: 0x060024B3 RID: 9395 RVA: 0x000F5104 File Offset: 0x000F3304
		public override void OnMove(AxisEventData eventData)
		{
			bool flag = this.funcOnMove != null;
			if (flag)
			{
				this.CallFunc(this.funcOnMove, eventData);
			}
		}

		// Token: 0x060024B4 RID: 9396 RVA: 0x000F5130 File Offset: 0x000F3330
		public override void OnInitializePotentialDrag(PointerEventData eventData)
		{
			bool flag = this.funcOnInitializePotentialDrag != null;
			if (flag)
			{
				this.CallFunc(this.funcOnInitializePotentialDrag, eventData);
			}
		}

		// Token: 0x060024B5 RID: 9397 RVA: 0x000F515C File Offset: 0x000F335C
		public override void OnScroll(PointerEventData eventData)
		{
			bool flag = this.funcOnScroll != null;
			if (flag)
			{
				this.CallFunc(this.funcOnScroll, eventData);
			}
		}

		// Token: 0x060024B6 RID: 9398 RVA: 0x000F5188 File Offset: 0x000F3388
		public override void OnSubmit(BaseEventData eventData)
		{
			bool flag = this.funcOnSubmit != null;
			if (flag)
			{
				this.CallFunc(this.funcOnSubmit, eventData);
			}
		}

		// Token: 0x060024B7 RID: 9399 RVA: 0x0001156E File Offset: 0x0000F76E
		public void OnWillRenderObject()
		{
		}

		// Token: 0x060024B8 RID: 9400 RVA: 0x0001156E File Offset: 0x0000F76E
		public void OnApplictonQuit()
		{
		}

		// Token: 0x060024B9 RID: 9401 RVA: 0x000F51B4 File Offset: 0x000F33B4
		public void OnDestroy()
		{
			this.CallFunc(this.funcOnDestroy, base.gameObject);
			this.isRun = false;
			this.ClearClick();
			bool flag = this.funcBegin != null;
			if (flag)
			{
				this.funcBegin.Dispose();
				this.funcBegin = null;
			}
			bool flag2 = this.funcUpdate != null;
			if (flag2)
			{
				this.funcUpdate.Dispose();
				this.funcUpdate = null;
			}
			bool flag3 = this.funcFixedUpdate != null;
			if (flag3)
			{
				this.funcFixedUpdate.Dispose();
				this.funcFixedUpdate = null;
			}
			bool flag4 = this.funcLateUpdate != null;
			if (flag4)
			{
				this.funcLateUpdate.Dispose();
				this.funcLateUpdate = null;
			}
			bool flag5 = this.funcOnEnable != null;
			if (flag5)
			{
				this.funcOnEnable.Dispose();
				this.funcOnEnable = null;
			}
			bool flag6 = this.funcOnBecameVisible != null;
			if (flag6)
			{
				this.funcOnBecameVisible.Dispose();
				this.funcOnBecameVisible = null;
			}
			bool flag7 = this.funcOnBecameInvisible != null;
			if (flag7)
			{
				this.funcOnBecameInvisible.Dispose();
				this.funcOnBecameInvisible = null;
			}
			bool flag8 = this.funcOnTriggerEnter != null;
			if (flag8)
			{
				this.funcOnTriggerEnter.Dispose();
				this.funcOnTriggerEnter = null;
			}
			bool flag9 = this.funcOnTriggerStay != null;
			if (flag9)
			{
				this.funcOnTriggerStay.Dispose();
				this.funcOnTriggerStay = null;
			}
			bool flag10 = this.funcOnPointerClick != null;
			if (flag10)
			{
				this.funcOnPointerClick.Dispose();
				this.funcOnPointerClick = null;
			}
			bool flag11 = this.funcOnPointerDown != null;
			if (flag11)
			{
				this.funcOnPointerDown.Dispose();
				this.funcOnPointerDown = null;
			}
			bool flag12 = this.funcOnPointerEnter != null;
			if (flag12)
			{
				this.funcOnPointerEnter.Dispose();
				this.funcOnPointerEnter = null;
			}
			bool flag13 = this.funcOnPointerExit != null;
			if (flag13)
			{
				this.funcOnPointerExit.Dispose();
				this.funcOnPointerExit = null;
			}
			bool flag14 = this.funcOnPointerUp != null;
			if (flag14)
			{
				this.funcOnPointerUp.Dispose();
				this.funcOnPointerUp = null;
			}
			bool flag15 = this.funcOnSelect != null;
			if (flag15)
			{
				this.funcOnSelect.Dispose();
				this.funcOnSelect = null;
			}
			bool flag16 = this.funcOnUpdateSelected != null;
			if (flag16)
			{
				this.funcOnUpdateSelected.Dispose();
				this.funcOnUpdateSelected = null;
			}
			bool flag17 = this.funcOnBeginDrag != null;
			if (flag17)
			{
				this.funcOnBeginDrag.Dispose();
				this.funcOnBeginDrag = null;
			}
			bool flag18 = this.funcOnCancel != null;
			if (flag18)
			{
				this.funcOnCancel.Dispose();
				this.funcOnCancel = null;
			}
			bool flag19 = this.funcOnDeselect != null;
			if (flag19)
			{
				this.funcOnDeselect.Dispose();
				this.funcOnDeselect = null;
			}
			bool flag20 = this.funcOnDrag != null;
			if (flag20)
			{
				this.funcOnDrag.Dispose();
				this.funcOnDrag = null;
			}
			bool flag21 = this.funcOnDrop != null;
			if (flag21)
			{
				this.funcOnDrop.Dispose();
				this.funcOnDrop = null;
			}
			bool flag22 = this.funcOnEndDrag != null;
			if (flag22)
			{
				this.funcOnEndDrag.Dispose();
				this.funcOnEndDrag = null;
			}
			bool flag23 = this.funcOnMove != null;
			if (flag23)
			{
				this.funcOnMove.Dispose();
				this.funcOnMove = null;
			}
			bool flag24 = this.funcOnInitializePotentialDrag != null;
			if (flag24)
			{
				this.funcOnInitializePotentialDrag.Dispose();
				this.funcOnInitializePotentialDrag = null;
			}
			bool flag25 = this.funcOnScroll != null;
			if (flag25)
			{
				this.funcOnScroll.Dispose();
				this.funcOnScroll = null;
			}
			bool flag26 = this.funcOnSubmit != null;
			if (flag26)
			{
				this.funcOnSubmit.Dispose();
				this.funcOnSubmit = null;
			}
			bool flag27 = this.funcOnDestroy != null;
			if (flag27)
			{
				this.funcOnDestroy.Dispose();
				this.funcOnDestroy = null;
			}
			bool flag28 = this.mLuaTable != null;
			if (flag28)
			{
				this.mLuaTable.Dispose();
				this.mLuaTable = null;
			}
			this.lua = null;
		}

		// Token: 0x040002F5 RID: 757
		private List<LuaFunction> AddLuaEvents = new List<LuaFunction>();

		// Token: 0x040002F6 RID: 758
		public static CsJoinLua instance;

		// Token: 0x040002F7 RID: 759
		public LuaTable mLuaTable;

		// Token: 0x040002F8 RID: 760
		public bool isRun = false;

		// Token: 0x040002F9 RID: 761
		private LuaFunction funcBegin = null;

		// Token: 0x040002FA RID: 762
		private LuaFunction funcUpdate = null;

		// Token: 0x040002FB RID: 763
		private LuaFunction funcFixedUpdate = null;

		// Token: 0x040002FC RID: 764
		private LuaFunction funcLateUpdate = null;

		// Token: 0x040002FD RID: 765
		private LuaFunction funcOnEnable = null;

		// Token: 0x040002FE RID: 766
		private LuaFunction funcOnBecameVisible = null;

		// Token: 0x040002FF RID: 767
		private LuaFunction funcOnBecameInvisible = null;

		// Token: 0x04000300 RID: 768
		private LuaFunction funcOnTriggerEnter = null;

		// Token: 0x04000301 RID: 769
		private LuaFunction funcOnTriggerStay = null;

		// Token: 0x04000302 RID: 770
		private LuaFunction funcOnPointerClick = null;

		// Token: 0x04000303 RID: 771
		private LuaFunction funcOnPointerDown = null;

		// Token: 0x04000304 RID: 772
		private LuaFunction funcOnPointerEnter = null;

		// Token: 0x04000305 RID: 773
		private LuaFunction funcOnPointerExit = null;

		// Token: 0x04000306 RID: 774
		private LuaFunction funcOnPointerUp = null;

		// Token: 0x04000307 RID: 775
		private LuaFunction funcOnSelect = null;

		// Token: 0x04000308 RID: 776
		private LuaFunction funcOnUpdateSelected = null;

		// Token: 0x04000309 RID: 777
		private LuaFunction funcOnBeginDrag = null;

		// Token: 0x0400030A RID: 778
		private LuaFunction funcOnCancel = null;

		// Token: 0x0400030B RID: 779
		private LuaFunction funcOnDeselect = null;

		// Token: 0x0400030C RID: 780
		private LuaFunction funcOnDrag = null;

		// Token: 0x0400030D RID: 781
		private LuaFunction funcOnDrop = null;

		// Token: 0x0400030E RID: 782
		private LuaFunction funcOnEndDrag = null;

		// Token: 0x0400030F RID: 783
		private LuaFunction funcOnMove = null;

		// Token: 0x04000310 RID: 784
		private LuaFunction funcOnInitializePotentialDrag = null;

		// Token: 0x04000311 RID: 785
		private LuaFunction funcOnScroll = null;

		// Token: 0x04000312 RID: 786
		private LuaFunction funcOnSubmit = null;

		// Token: 0x04000313 RID: 787
		private LuaFunction funcOnDestroy = null;

		// Token: 0x04000314 RID: 788
		private LuaManager lua = null;

		// Token: 0x020001E1 RID: 481
		public enum LuaFuncType
		{
			// Token: 0x04000316 RID: 790
			luaString = 1,
			// Token: 0x04000317 RID: 791
			luaFile
		}
	}
}
