using LuaFramework;
using UnityEngine;

namespace Hotfix.BQTP
{
    public partial class Model : Game.Singleton<Model>
    {
        public bool IsScene { get; set; }
        public bool IsFreeGame { get; set; }
        public bool IsRoll { get; set; }
        public bool IsAutoGame { get; set; }
        public int CurrentAutoCount { get; set; }
        public int ReRollCount { get; set; }
        public ulong MyGold { get; set; }
        public long TotalFreeGold = 0; //免费总金币

        public int CurrentChipIndex { get; set; }
        public int CurrentChip { get; set; }
        public BQTPStruct.SceneInfo SceneInfo { get; set; }
        public BQTPStruct.ResultInfo ResultInfo { get; set; }
        public bool IsReRoll { get; set; }
        public int FreeCount { get; set; }

        protected override void Awake()
        {
            base.Awake();
            InitAudio();
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
    }
}