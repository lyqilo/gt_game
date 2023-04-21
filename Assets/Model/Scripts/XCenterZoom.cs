using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace LuaFramework
{
    [RequireComponent(typeof(ScrollRect))]
    public class XCenterZoom : MonoBehaviour, IBeginDragHandler, IEndDragHandler
    {
        ScrollRect _scrollRect;

        private enum Direction
        {
            Horizontal,
            Vertical
        }

        [SerializeField] Direction direction = Direction.Horizontal;

        [SerializeField] AnimationCurve animationCurve; //曲线

        [SerializeField] [Range(0.5f, 1)] float scaleSpace = 1; //调整缩放的速度

        int _childCount = 0; //列表Content中子对象个数
        float _spacingRatio = 0; //间距比，
        bool _isDrag = false;

        //拖拽结束时，在哪个下标
        private int GetEndIndex()
        {
            float pos = GetNormalizedPosition();
            if (pos < 0) return 1;
            if (pos > 1) return _childCount;

            for (int i = 0; i < _childCount; i++)
            {
                float minPos = (i * _spacingRatio) - (_spacingRatio / 2);
                float maxPos = (i * _spacingRatio) + (_spacingRatio / 2);
                if (pos >= minPos && pos <= maxPos) return i + 1;
            }
            return -1;
        }

        //获取拖到进度
        private float GetNormalizedPosition()
        {
            //scrollRect的进度(从上往下，从左往右)值是1->0，我们要给他翻转一下，得到0->1的值
            return direction == Direction.Horizontal
                ? -_scrollRect.horizontalNormalizedPosition + 1
                : -_scrollRect.verticalNormalizedPosition + 1;
        }

        //修改拖到进度
        private void SetNormalizedPosition(float value)
        {
            switch (direction)
            {
                case Direction.Horizontal:
                    _scrollRect.horizontalNormalizedPosition = -value + 1;
                    break;
                default:
                    _scrollRect.verticalNormalizedPosition = -value + 1;
                    break;
            }
        }

        //获取移动速度
        private float GetMoveSpeed()
        {
            var velocity = _scrollRect.velocity;
            return Mathf.Abs(direction == Direction.Horizontal ? velocity.x : velocity.y);
        }

        public void OnBeginDrag(PointerEventData eventData)
        {
            _isDrag = true;
        }

        public void OnEndDrag(PointerEventData eventData)
        {
            _isDrag = false;
        }

        private void Start()
        {
            _scrollRect = gameObject.GetComponent<ScrollRect>();
            _childCount = _scrollRect.content.childCount;
            _spacingRatio = 1.0f / (_childCount - 1);
        }

        private void Update()
        {
            if (_childCount > 1)
            {
                UpdateScale();
                UpdatePos();
            }
            else if (_childCount == 1)
            {
                //一个子对象要特殊处理一下
                var scale = animationCurve.Evaluate(0.5f);
                Transform cell = _scrollRect.content.GetChild(0);
                cell.localScale = Vector3.one * (scale + 1);
            }
        }

        //增加拖拽结束后，位置回正
        private void UpdatePos()
        {
            float endIndex = GetEndIndex();
            float moveSpeed = GetMoveSpeed();
            if (_isDrag != false || !(moveSpeed < 100) || endIndex == -1) return;
            float pos = GetNormalizedPosition();
            float endPos = (endIndex - 1) * _spacingRatio;
            float space = Mathf.Abs(endPos - pos) / 5;
            float value = Mathf.Lerp(pos, endPos, space);
            if (value < 0.001f)
            {
                value = endPos;
                _scrollRect.StopMovement();
            }

            SetNormalizedPosition(value);
        }

        //子对象的缩放
        private void UpdateScale()
        {
            float pos = GetNormalizedPosition();
            for (int i = 0; i < _childCount; i++)
            {
                //此对象的中心点值
                float centrePos = i * _spacingRatio;
                //此对象缩放开始的地方（进度值，当value走到这里后开始缩放）
                float startPos = centrePos - (_spacingRatio * scaleSpace);
                float endPos = centrePos + (_spacingRatio * scaleSpace);
                float t = pos - startPos;
                t = t / (endPos - startPos);
                var scale = animationCurve.Evaluate(t);
                Transform cell = _scrollRect.content.GetChild(i);
                cell.localScale = Vector3.one * (scale + 1);
            }
        }
    }
}