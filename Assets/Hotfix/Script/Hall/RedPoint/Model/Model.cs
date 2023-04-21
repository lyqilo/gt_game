using System;
using System.Collections.Generic;

namespace Hotfix.RedPoint
{
    public delegate void OnRedPointChange(RedNode node,bool isRelease);
    public class Model : Singleton.Singleton<Model>, IModule
    {
        private Dictionary<string, RedNode> _redNodes = new Dictionary<string, RedNode>();
        private List<string> _redKeys = new List<string>();

        public void Initialize()
        {
            for (int i = 0; i < _redKeys.Count; i++)
            {
                ResigterRedNode(_redKeys[i]);
            }
        }

        public void UnInitialize()
        {
            foreach (var redNode in _redNodes)
            {
                redNode.Value.OnRedPointChanged?.Invoke(null,true);
                redNode.Value.OnRedPointChanged = null;
            }
            _redNodes.Clear();
        }

        /// <summary>
        /// 注册红点
        /// </summary>
        /// <param name="redkey">红点key（每个功能对应自己的功能key）</param>
        public void ResigterRedNode(string redkey)
        {
            if (string.IsNullOrEmpty(redkey))
            {
                DebugHelper.LogError($"redkey resigterd is null");
                return;
            }

            if (_redNodes.ContainsKey(redkey)) return;

            var redArr = redkey.Split('.');
            string key = string.Empty;
            RedNode redParent = null;
            for (int i = 0; i < redArr.Length; i++)
            {
                if (!key.Equals(String.Empty)) key += '.';
                key += redArr[i];
                if (!_redKeys.Contains(key)) _redKeys.Add(key);
                if (_redNodes.ContainsKey(key)) continue;
                var node = new RedNode {KeyName = key, Parent = redParent};
                if (redParent != null && !redParent.Childs.ContainsKey(key))
                {
                    node.Parent.Childs.Add(key, node);
                }

                redParent = node;
                _redNodes.Add(key, node);
            }
        }

        /// <summary>
        /// 注册红点变化事件
        /// </summary>
        /// <param name="redkey">红点key</param>
        /// <param name="onRedPointChanged">红点值变化事件回调</param>
        public void ResigterRedNodeAction(string redkey, OnRedPointChange onRedPointChanged)
        {
            var redNode = GetRedNode(redkey);
            redNode.OnRedPointChanged += onRedPointChanged;
        }

        /// <summary>
        /// 注销红点key下的红点事件
        /// </summary>
        /// <param name="redkey"></param>
        public void UnResigterRedNodeAction(string redkey, OnRedPointChange onRedPointChanged)
        {
            var redNode = GetRedNode(redkey);
            redNode.OnRedPointChanged -= onRedPointChanged;
        }

        /// <summary>
        /// 获取红点
        /// </summary>
        /// <param name="redkey">红点key</param>
        /// <returns></returns>
        public RedNode GetRedNode(string redkey)
        {
            ResigterRedNode(redkey);
            return _redNodes[redkey];
        }

        /// <summary>
        /// 设置红点值
        /// </summary>
        /// <param name="redkey">红点key</param>
        /// <param name="redPoint">红点值</param>
        public void SetRedPoint(string redkey, int redPoint)
        {
            var redNode = GetRedNode(redkey);
            redNode.RedPoint = redPoint;
            while (true)
            {
                if (redNode.Parent == null) break;
                redNode.Parent.RedPoint += redNode.RedPoint;
                redNode = redNode.Parent;
            }
        }
    }

    public class RedNode
    {
        public string KeyName { get; set; }
        public RedNode Parent { get; set; }
        private int _redPoint;

        public int RedPoint
        {
            get => _redPoint;
            set
            {
                _redPoint = value;
                OnRedPointChanged?.Invoke(this, false);
                DebugHelper.Log($"node :{KeyName}  point:{RedPoint}");
            }
        }

        public OnRedPointChange OnRedPointChanged { get; set; }
        public Dictionary<string, RedNode> Childs = new Dictionary<string, RedNode>();
    }
}