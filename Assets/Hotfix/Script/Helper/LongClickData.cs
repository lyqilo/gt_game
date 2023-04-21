using UnityEngine;
using UnityEngine.EventSystems;

namespace Hotfix
{
    public class LongClickData
    {
        public CAction<GameObject, PointerEventData> funcClick;
        public CAction<GameObject, PointerEventData> funcDown;
        public CAction<GameObject, BaseEventData> funcLongClick;
        public CAction<GameObject, PointerEventData> funcUp;
        public float time;
    }
}