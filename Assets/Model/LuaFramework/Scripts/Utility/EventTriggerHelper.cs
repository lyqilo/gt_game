using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

namespace LuaFramework
{
    /// <summary>
    /// 委托点击事件
    /// </summary>
    public class EventTriggerHelper : MonoBehaviour, IPointerClickHandler, IPointerDownHandler, IPointerEnterHandler,
        IPointerExitHandler, IPointerUpHandler, ISelectHandler, IUpdateSelectedHandler, IDeselectHandler,
        IBeginDragHandler, IDragHandler, IEndDragHandler, IDropHandler, IScrollHandler, IMoveHandler, ISubmitHandler
    {
        public Action<GameObject, PointerEventData> onClick = null;
        public Action<GameObject, PointerEventData> onUp = null;
        public Action<GameObject, PointerEventData> onDown = null;
        public Action<GameObject, PointerEventData> onEnter = null;
        public Action<GameObject, PointerEventData> onExit = null;
        public Action<GameObject, BaseEventData> onSelect = null;
        public Action<GameObject, BaseEventData> onUpdateSelect = null;
        public Action<GameObject, BaseEventData> onDeselect = null;
        public Action<GameObject, PointerEventData> onBeginDrag = null;
        public Action<GameObject, PointerEventData> onDrag = null;
        public Action<GameObject, PointerEventData> onEndDrag = null;
        public Action<GameObject, PointerEventData> onDrop = null;
        public Action<GameObject, PointerEventData> onScroll = null;
        public Action<GameObject, AxisEventData> onMove = null;
        public Action<GameObject, BaseEventData> onSubmit = null;

        public static EventTriggerHelper Get(GameObject go)
        {
            EventTriggerHelper hepler = go.GetComponent<EventTriggerHelper>();
            if (hepler == null) hepler = go.AddComponent<EventTriggerHelper>();
            return hepler;
        }

        public void OnPointerEnter(PointerEventData eventData)
        {
            onEnter?.Invoke(gameObject, eventData);
        }

        public void OnPointerExit(PointerEventData eventData)
        {
            onExit?.Invoke(gameObject, eventData);
        }

        public void OnSelect(BaseEventData eventData)
        {
            onSelect?.Invoke(gameObject, eventData);
        }

        public void OnUpdateSelected(BaseEventData eventData)
        {
            onUpdateSelect?.Invoke(gameObject, eventData);
        }

        public void OnDeselect(BaseEventData eventData)
        {
            onDeselect?.Invoke(gameObject, eventData);
        }

        public void OnBeginDrag(PointerEventData eventData)
        {
            onBeginDrag?.Invoke(gameObject, eventData);
        }

        public void OnDrag(PointerEventData eventData)
        {
            onDrag?.Invoke(gameObject, eventData);
        }

        public void OnEndDrag(PointerEventData eventData)
        {
            onEndDrag?.Invoke(gameObject, eventData);
        }

        public void OnDrop(PointerEventData eventData)
        {
            onDrop?.Invoke(gameObject, eventData);
        }

        public void OnScroll(PointerEventData eventData)
        {
            onScroll?.Invoke(gameObject, eventData);
        }

        public void OnMove(AxisEventData eventData)
        {
            onMove?.Invoke(gameObject, eventData);
        }

        public void OnPointerClick(PointerEventData eventData)
        {
            onClick?.Invoke(gameObject, eventData);
        }

        public void OnPointerDown(PointerEventData eventData)
        {
            onDown?.Invoke(gameObject, eventData);
        }

        public void OnPointerUp(PointerEventData eventData)
        {
            onUp?.Invoke(gameObject, eventData);
        }

        public void OnSubmit(BaseEventData eventData)
        {
            onSubmit?.Invoke(gameObject, eventData);
        }
    }
}