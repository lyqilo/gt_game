using LuaFramework;
using UnityEngine;

namespace Hotfix.Fulinmen
{
    public partial class Model : Game.Singleton<Model>
    {
        private Transform _effectList;
        private Transform _effectPool;
        public bool IsScene { get; set; }
        public bool IsFreeGame { get; set; }
        public bool IsRoll { get; set; }
        public bool IsAutoGame { get; set; }
        public int CurrentAutoCount { get; set; }
        public int ReRollCount { get; set; }
        public ulong MyGold { get; set; }

        public int CurrentChipIndex { get; set; }
        public int CurrentChip { get; set; }
        public FulinmenStruct.SceneInfo SceneInfo { get; set; }
        public FulinmenStruct.ResultInfo ResultInfo { get; set; }
        public bool IsReRoll { get; set; }
        public int FreeCount { get; set; }
        public bool IsDJJY { get; set; }

        protected override void Awake()
        {
            base.Awake();
            InitAudio();
            ContactEffect();
        }

        protected void Start()
        {
            InitNetwork();
        }

        protected override void OnDestroy()
        {
            base.OnDestroy();
            ReleaseNetwork();
            ReleaseAudio();
        }

        private void ContactEffect()
        {
            _effectList = transform.FindChildDepth("EffectList"); //动画库
            _effectPool = transform.FindChildDepth("EffectPool"); //动画缓存库
        }

        public void CollectEffect(GameObject obj)
        {
            //回收动画
            if (obj == null) return;
            obj.transform.SetParent(_effectPool);
            obj.SetActive(false);
        }

        public GameObject CreateEffect(string effectname)
        {
            //创建动画，先从对象池中获取
            Transform go = _effectPool.FindChildDepth(effectname);
            if (go != null) return go.gameObject;
            go = _effectList.FindChildDepth(effectname);
            GameObject _go = Instantiate(go.gameObject);
            return _go;
        }
    }
}