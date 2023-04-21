using UnityEngine;

namespace Hotfix.Hall.Share
{
    public class UIDetail : MonoBehaviour, IModuleDetail
    {
        private int _index;

        public int Index
        {
            get => _index;
            set
            {
                _index = value;
                InitState();
            }
        }

        private IModuleDetail _detail;

        private void InitState()
        {
            switch (_index)
            {
                case 0:
                    _detail = gameObject.CreateOrGetComponent<UIShareBind>();
                    break;
                case 1:
                    _detail = gameObject.CreateOrGetComponent<UIShareInviteReward>();
                    break;
                case 2:
                    _detail = gameObject.CreateOrGetComponent<UIShareRechargeReward>();
                    break;
            }

            _detail.Index = _index;
            _detail?.Hide();
        }

        public void Show()
        {
            _detail?.Show();
        }

        public void Hide()
        {
            _detail?.Hide();
        }
    }
}