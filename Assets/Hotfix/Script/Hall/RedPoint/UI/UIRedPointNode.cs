using System;
using UnityEngine;

namespace Hotfix.RedPoint
{
    public class UIRedPointNode : MonoBehaviour
    {
        public static UIRedPointNode Add(string redkey, GameObject go)
        {
            if (go == null || string.IsNullOrEmpty(redkey))
            {
                DebugHelper.LogError($"add UIRedPointNode failed");
                return null;
            }

            var uinode = go.CreateOrGetComponent<UIRedPointNode>();
            uinode.Resigter(redkey);
            return uinode;
        }

        [SerializeField] private string _redKey;
        public OnRedPointChange RedPointChange { get; set; }

        public string RedKey
        {
            get => _redKey;
            set => _redKey = value;
        }

        private void Awake()
        {
            Resigter();
        }

        private void OnDestroy()
        {
            Model.Instance.UnResigterRedNodeAction(RedKey, OnChanged);
        }

        private void Resigter()
        {
            if (string.IsNullOrEmpty(RedKey)) return;
            Model.Instance.ResigterRedNodeAction(RedKey, OnChanged);
            var node = Model.Instance.GetRedNode(RedKey);
            gameObject.SetActive(node.RedPoint > 0);
        }

        public void Resigter(string redkey)
        {
            if (RedKey == redkey) return;
            RedKey = redkey;
            Resigter();
        }

        private void OnChanged(RedNode node, bool isRelease)
        {
            RedPointChange?.Invoke(node,isRelease);
            if (isRelease)
            {
                _redKey = "";
                return;
            }
            gameObject.SetActive(node.RedPoint > 0);
            DebugHelper.Log($"red node :{node.KeyName}  point:{node.RedPoint}");
        }
    }
}