using LuaFramework;
using UnityEngine;

namespace Hotfix
{
    /// <summary>
    /// 不含Mono的节点
    /// </summary>
    public class ILHotfixEntity : IILManager
    {
        public GameObject gameObject;
        public Transform transform;
        public ILBehaviour Behaviour;
        private bool isInitAwake;
        private bool isInitStart;

        /// <summary>
        /// 初始化类
        /// </summary>
        /// <param name="go"></param>
        public void Init(GameObject go)
        {
            gameObject = go;
            transform = go.transform;
            if (Behaviour != null) Object.Destroy(Behaviour);
            Behaviour = gameObject.AddComponent<ILBehaviour>();
            Behaviour.UpdateEvent = Update;
            Behaviour.FixedUpdateEvent = FixedUpdate;
            Behaviour.OnEnableEvent = OnEnable;
            Behaviour.OnDisableEvent = OnDisable;
            Behaviour.LateUpdateEvent = LateUpdate;
            Behaviour.OnDestroyEvent = OnDestroy;
            Behaviour.OnApplicationFocusEvent = OnApplicationFocus;
            Behaviour.OnApplicationPauseEvent = OnApplicationPause;
            Behaviour.OnApplicationQuitEvent = OnApplicationQuit;
            Behaviour.OnCollisionEnterEvent = OnCollisionEnter;
            Behaviour.OnCollisionStayEvent = OnCollisionStay;
            Behaviour.OnCollisionExitEvent = OnCollisionExit;
            Behaviour.OnTriggerEnterEvent = OnTriggerEnter;
            Behaviour.OnTriggerStayEvent = OnTriggerStay;
            Behaviour.OnTriggerExitEvent = OnTriggerExit;
            Behaviour.OnCollisionEnter2DEvent = OnCollisionEnter2D;
            Behaviour.OnCollisionExit2DEvent = OnCollisionExit2D;
            Behaviour.OnCollisionStay2DEvent = OnCollisionStay2D;
            Behaviour.OnTriggerEnter2DEvent = OnTriggerEnter2D;
            Behaviour.OnTriggerExit2DEvent = OnTriggerExit2D;
            Behaviour.OnTriggerStay2DEvent = OnTriggerStay2D;
            Behaviour.Behaviour = this;
            Behaviour.BehaviourName = GetType().Name;
            if (!gameObject.activeSelf)
            {
                Behaviour.AwakeEvent = Awake;
                Behaviour.StartEvent = Start;
                return;
            }
            Awake();
            OnEnable();
            Start();
        }

        protected virtual void Awake()
        {
            FindComponent();
            AddEvent();
        }

        protected virtual void Start()
        {
        }

        protected virtual void OnTriggerStay2D(Collider2D obj)
        {
        }

        protected virtual void OnTriggerExit2D(Collider2D obj)
        {
        }

        protected virtual void OnTriggerEnter2D(Collider2D obj)
        {
        }

        protected virtual void OnCollisionStay2D(Collision2D obj)
        {
        }

        protected virtual void OnCollisionExit2D(Collision2D obj)
        {
        }

        protected virtual void OnCollisionEnter2D(Collision2D obj)
        {
        }

        protected virtual void OnTriggerExit(Collider obj)
        {
        }

        protected virtual void OnTriggerStay(Collider obj)
        {
        }

        protected virtual void OnTriggerEnter(Collider obj)
        {
        }

        protected virtual void OnCollisionExit(Collision obj)
        {
        }

        protected virtual void OnCollisionStay(Collision obj)
        {
        }

        protected virtual void OnCollisionEnter(Collision obj)
        {
        }

        protected virtual void OnApplicationQuit()
        {
        }

        protected virtual void OnApplicationPause(bool obj)
        {
        }

        protected virtual void OnApplicationFocus(bool obj)
        {
        }

        protected virtual void OnDisable()
        {
        }

        protected virtual void OnEnable()
        {
        }

        protected virtual void Update()
        {
        }

        protected virtual void FixedUpdate()
        {
        }

        protected virtual void LateUpdate()
        {
        }

        protected virtual void OnDestroy()
        {
            RemoveEvent();
            gameObject = null;
            transform = null;
        }

        protected virtual void FindComponent()
        {
        }

        protected virtual void AddEvent()
        {
        }

        protected virtual void RemoveEvent()
        {
        }

        /// <summary>
        /// 销毁节点
        /// </summary>
        /// <param name="entity">节点</param>
        /// <param name="timer">延迟时间</param>
        public static void Destroy(ILHotfixEntity entity, float timer = 0)
        {
            if (entity == null) return;
            if (entity.Behaviour == null) return;
            if (timer > 0)
            {
                Object.Destroy(entity.Behaviour, timer);
            }
            else
            {
                Object.Destroy(entity.Behaviour);
            }
        }
    }
}