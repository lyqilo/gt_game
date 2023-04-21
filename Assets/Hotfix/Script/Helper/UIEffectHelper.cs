using Coffee.UIExtensions;
using UnityEngine;

namespace Hotfix
{
    public static class UIEffectHelper
    {
        public static UIEffect GetUIEffect(this Transform transform, string path)
        {
            if (transform == null) return null;
            return transform.FindChildDepth<UIEffect>(path);
        }
        public static UIDissolve GetUIDissolve(this Transform transform, string path)
        {
            if (transform == null) return null;
            return transform.FindChildDepth<UIDissolve>(path);
        }
        public static UIFlip GetUIFlip(this Transform transform, string path)
        {
            if (transform == null) return null;
            return transform.FindChildDepth<UIFlip>(path);
        }
        public static UIGradient GetUIGradient(this Transform transform, string path)
        {
            if (transform == null) return null;
            return transform.FindChildDepth<UIGradient>(path);
        }
        public static UIShiny GetUIShiny(this Transform transform, string path)
        {
            if (transform == null) return null;
            return transform.FindChildDepth<UIShiny>(path);
        }
        public static UIShadow GetUIShadow(this Transform transform, string path)
        {
            if (transform == null) return null;
            return transform.FindChildDepth<UIShadow>(path);
        }
        
        public static UITransitionEffect GetUITransitionEffect(this Transform transform, string path)
        {
            if (transform == null) return null;
            return transform.FindChildDepth<UITransitionEffect>(path);
        }
        public static UIHsvModifier GetUIHsvModifier(this Transform transform, string path)
        {
            if (transform == null) return null;
            return transform.FindChildDepth<UIHsvModifier>(path);
        }
    }
}