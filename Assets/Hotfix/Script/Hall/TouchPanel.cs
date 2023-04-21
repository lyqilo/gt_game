using LuaFramework;
using UnityEngine;
using UnityEngine.EventSystems;

namespace Hotfix.Hall
{
    public class TouchPanel : PanelBase
    {
        public TouchPanel() : base(UIType.Fix, nameof(TouchPanel))
        {
        }

        private GameObject _touchObj;
        private RectTransform _rectTransform;
        public override void Create(params object[] args)
        {
            base.Create(args);
            _rectTransform = transform.GetComponent<RectTransform>();
            _touchObj = transform.FindChildDepth($"Dianji").gameObject;
        }

        protected override void Update()
        {
            base.Update();
            if (!Input.GetMouseButtonDown(0)) return;
            var touch = FindCanUse();
            RectTransformUtility.ScreenPointToLocalPointInRectangle(_rectTransform, Input.mousePosition,
                UIManager.Instance.UICamera, out var pos);
            touch.transform.localPosition = pos;
            touch.SetActive(true);
            Behaviour.StartCoroutine(Delay(1, () => { touch.SetActive(false); }));
        }

        private GameObject FindCanUse()
        {
            for (int i = 0; i < transform.childCount; i++)
            {
                if (!transform.GetChild(i).gameObject.activeSelf) return transform.GetChild(i).gameObject;
            }

            GameObject go = Object.Instantiate(_touchObj, transform, false);
            go.transform.localScale = Vector3.one;
            return go;
        }
    }
}