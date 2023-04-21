using System;
using UnityEngine.EventSystems;

namespace LuaFramework
{
	// Token: 0x020001E7 RID: 487
	public class EventTriggerListener : EventTrigger
	{
		// Token: 0x060024C5 RID: 9413 RVA: 0x000F57A0 File Offset: 0x000F39A0
		public void CallFunc(object func, params object[] agrs)
		{
			bool flag = func == null;
			if (!flag)
			{
                AppFacade.Instance.GetManager<LuaManager>().CallFunction(func, agrs);
			}
		}

		// Token: 0x060024C6 RID: 9414 RVA: 0x000F57C6 File Offset: 0x000F39C6
		public override void OnPointerClick(PointerEventData eventData)
		{
			this.CallFunc(this.onClick, new object[]
			{
				base.gameObject,
				eventData
			});
		}

		// Token: 0x060024C7 RID: 9415 RVA: 0x000F57E9 File Offset: 0x000F39E9
		public override void OnPointerDown(PointerEventData eventData)
		{
			this.CallFunc(this.onDown, new object[]
			{
				base.gameObject,
				eventData
			});
		}

		// Token: 0x060024C8 RID: 9416 RVA: 0x000F580C File Offset: 0x000F3A0C
		public override void OnPointerEnter(PointerEventData eventData)
		{
			this.CallFunc(this.onEnter, new object[]
			{
				base.gameObject,
				eventData
			});
		}

		// Token: 0x060024C9 RID: 9417 RVA: 0x000F582F File Offset: 0x000F3A2F
		public override void OnPointerExit(PointerEventData eventData)
		{
			this.CallFunc(this.onExit, new object[]
			{
				base.gameObject,
				eventData
			});
		}

		// Token: 0x060024CA RID: 9418 RVA: 0x000F5852 File Offset: 0x000F3A52
		public override void OnPointerUp(PointerEventData eventData)
		{
			this.CallFunc(this.onUp, new object[]
			{
				base.gameObject,
				eventData
			});
		}

		// Token: 0x060024CB RID: 9419 RVA: 0x000F5875 File Offset: 0x000F3A75
		public override void OnSelect(BaseEventData eventData)
		{
			this.CallFunc(this.onSelect, new object[]
			{
				base.gameObject,
				eventData
			});
		}

		// Token: 0x060024CC RID: 9420 RVA: 0x000F5898 File Offset: 0x000F3A98
		public override void OnUpdateSelected(BaseEventData eventData)
		{
			this.CallFunc(this.onUpdateSelect, new object[]
			{
				base.gameObject,
				eventData
			});
		}

		// Token: 0x060024CD RID: 9421 RVA: 0x000F58BB File Offset: 0x000F3ABB
		public override void OnBeginDrag(PointerEventData eventData)
		{
			this.CallFunc(this.onBeginDrag, new object[]
			{
				base.gameObject,
				eventData
			});
		}

		// Token: 0x060024CE RID: 9422 RVA: 0x000F58DE File Offset: 0x000F3ADE
		public override void OnCancel(BaseEventData eventData)
		{
			this.CallFunc(this.onCancel, new object[]
			{
				base.gameObject,
				eventData
			});
		}

		// Token: 0x060024CF RID: 9423 RVA: 0x000F5901 File Offset: 0x000F3B01
		public override void OnDeselect(BaseEventData eventData)
		{
			this.CallFunc(this.onDeselect, new object[]
			{
				base.gameObject,
				eventData
			});
		}

		// Token: 0x060024D0 RID: 9424 RVA: 0x000F5924 File Offset: 0x000F3B24
		public override void OnDrag(PointerEventData eventData)
		{
			this.CallFunc(this.onDrag, new object[]
			{
				base.gameObject,
				eventData
			});
		}

		// Token: 0x060024D1 RID: 9425 RVA: 0x000F5947 File Offset: 0x000F3B47
		public override void OnDrop(PointerEventData eventData)
		{
			this.CallFunc(this.onDrop, new object[]
			{
				base.gameObject,
				eventData
			});
		}

		// Token: 0x060024D2 RID: 9426 RVA: 0x000F596A File Offset: 0x000F3B6A
		public override void OnEndDrag(PointerEventData eventData)
		{
			this.CallFunc(this.onEndDrag, new object[]
			{
				base.gameObject,
				eventData
			});
		}

		// Token: 0x060024D3 RID: 9427 RVA: 0x000F598D File Offset: 0x000F3B8D
		public override void OnMove(AxisEventData eventData)
		{
			this.CallFunc(this.onMove, new object[]
			{
				base.gameObject,
				eventData
			});
		}

		// Token: 0x060024D4 RID: 9428 RVA: 0x000F59B0 File Offset: 0x000F3BB0
		public override void OnInitializePotentialDrag(PointerEventData eventData)
		{
			this.CallFunc(this.onInitializePotentialDrag, new object[]
			{
				base.gameObject,
				eventData
			});
		}

		// Token: 0x060024D5 RID: 9429 RVA: 0x000F59D3 File Offset: 0x000F3BD3
		public override void OnScroll(PointerEventData eventData)
		{
			this.CallFunc(this.onScroll, new object[]
			{
				base.gameObject,
				eventData
			});
		}

		// Token: 0x060024D6 RID: 9430 RVA: 0x000F59F6 File Offset: 0x000F3BF6
		public override void OnSubmit(BaseEventData eventData)
		{
			this.CallFunc(this.onSubmit, new object[]
			{
				base.gameObject,
				eventData
			});
		}

		// Token: 0x060024D7 RID: 9431 RVA: 0x0001156E File Offset: 0x0000F76E
		public void OnDestroy()
		{
		}

		// Token: 0x04000327 RID: 807
		public object onClick = null;

		// Token: 0x04000328 RID: 808
		public object onDown = null;

		// Token: 0x04000329 RID: 809
		public object onEnter = null;

		// Token: 0x0400032A RID: 810
		public object onExit = null;

		// Token: 0x0400032B RID: 811
		public object onUp = null;

		// Token: 0x0400032C RID: 812
		public object onSelect = null;

		// Token: 0x0400032D RID: 813
		public object onUpdateSelect = null;

		// Token: 0x0400032E RID: 814
		public object onBeginDrag = null;

		// Token: 0x0400032F RID: 815
		public object onCancel = null;

		// Token: 0x04000330 RID: 816
		public object onDeselect = null;

		// Token: 0x04000331 RID: 817
		public object onDrag = null;

		// Token: 0x04000332 RID: 818
		public object onDrop = null;

		// Token: 0x04000333 RID: 819
		public object onEndDrag = null;

		// Token: 0x04000334 RID: 820
		public object onMove = null;

		// Token: 0x04000335 RID: 821
		public object onInitializePotentialDrag = null;

		// Token: 0x04000336 RID: 822
		public object onScroll = null;

		// Token: 0x04000337 RID: 823
		public object onSubmit = null;
	}
}
