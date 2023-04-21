using UnityEngine;
using UnityEngine.UI;

namespace Hotfix.TouKui
{
    public class TouKui_TSUnit : ILHotfixEntity
    {
        private Image img;

        public Vector4 Center
        {
            set
            {
                center = value;
                SetCenter();
            }
        }
        private Vector4 center;
        private Vector4 _orgin;

        private float radius;
        public float Radius
        {
            set
            {
                radius = value;
                SetRadius();
            }
        }
        public bool IsRun { get; set; }
        protected override void Awake()
        {
            base.Awake();
            IsRun = false;
        }

        private void SetCenter()
        {
            if (img == null) img = transform.GetComponent<Image>();
            if (img == null) return;
            img.material.SetVector($"_Center", center);
        }

        private void SetRadius()
        {
            if (img == null) img = transform.GetComponent<Image>();
            if (img == null) return;
            img.material.SetFloat($"_Radius", radius);
        }
    }
}