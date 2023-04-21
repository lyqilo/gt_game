using System;
using UnityEngine;

namespace LuaFramework
{
    public class ILBehaviour : MonoBehaviour
    {
        public string BehaviourName;
        public object Behaviour;
        public Action AwakeEvent;
        public Action StartEvent;
        public Action OnEnableEvent;
        public Action UpdateEvent;
        public Action FixedUpdateEvent;
        public Action LateUpdateEvent;
        public Action OnDisableEvent;
        public Action OnDestroyEvent;
        public Action<Collision> OnCollisionEnterEvent;
        public Action<Collision> OnCollisionStayEvent;
        public Action<Collision> OnCollisionExitEvent;
        public Action<Collider> OnTriggerEnterEvent;
        public Action<Collider> OnTriggerStayEvent;
        public Action<Collider> OnTriggerExitEvent;
        public Action<Collision2D> OnCollisionEnter2DEvent;
        public Action<Collision2D> OnCollisionStay2DEvent;
        public Action<Collision2D> OnCollisionExit2DEvent;
        public Action<Collider2D> OnTriggerEnter2DEvent;
        public Action<Collider2D> OnTriggerStay2DEvent;
        public Action<Collider2D> OnTriggerExit2DEvent;
        public Action<bool> OnApplicationFocusEvent;
        public Action<bool> OnApplicationPauseEvent;
 
        public Action OnApplicationQuitEvent;

        // Start is called before the first frame update
        private void Awake()
        {
            this.AwakeEvent?.Invoke();
        }

        private void OnEnable()
        {
            this.OnEnableEvent?.Invoke();
        }

        private void Start()
        {
            this.StartEvent?.Invoke();
        }

        private void Update()
        {
            this.UpdateEvent?.Invoke();
        }

        private void FixedUpdate()
        {
            this.FixedUpdateEvent?.Invoke();
        }

        private void LateUpdate()
        {
            this.LateUpdateEvent?.Invoke();
        }

        private void OnDisable()
        {
            this.OnDisableEvent?.Invoke();
        }

        private void OnDestroy()
        {
            this.OnDestroyEvent?.Invoke();
            RemoveEvent();
        }

        private void RemoveEvent()
        {
            AwakeEvent = null;
            StartEvent = null;
            OnEnableEvent = null;
            UpdateEvent = null;
            FixedUpdateEvent = null;
            LateUpdateEvent = null;
            OnDisableEvent = null;
            OnCollisionEnterEvent=null;
            OnCollisionStayEvent=null;
            OnCollisionExitEvent = null;
            OnTriggerEnterEvent=null;
            OnTriggerStayEvent=null;
            OnTriggerExitEvent=null;
            OnCollisionEnter2DEvent = null;
            OnCollisionExit2DEvent = null;
            OnCollisionStay2DEvent = null;
            OnTriggerEnter2DEvent = null;
            OnTriggerExit2DEvent = null;
            OnTriggerStay2DEvent = null;
            OnApplicationFocusEvent = null;
            OnApplicationPauseEvent=null;
            OnApplicationQuitEvent = null;
            OnDestroyEvent = null;
        }
        private void OnCollisionEnter(Collision other)
        {
            this.OnCollisionEnterEvent?.Invoke(other);
        }

        private void OnCollisionStay(Collision other)
        {
            this.OnCollisionStayEvent?.Invoke(other);
        }

        private void OnCollisionExit(Collision other)
        {
            this.OnCollisionExitEvent?.Invoke(other);
        }

        private void OnTriggerEnter(Collider other)
        {
            this.OnTriggerEnterEvent?.Invoke(other);
        }

        private void OnTriggerStay(Collider other)
        {
            this.OnTriggerStayEvent?.Invoke(other);
        }

        private void OnTriggerExit(Collider other)
        {
            this.OnTriggerExitEvent?.Invoke(other);
        }

        private void OnCollisionEnter2D(Collision2D other)
        {
            this.OnCollisionEnter2DEvent?.Invoke(other);
        }

        private void OnCollisionStay2D(Collision2D other)
        {
            this.OnCollisionStay2DEvent?.Invoke(other);
        }

        private void OnCollisionExit2D(Collision2D other)
        {
            this.OnCollisionExit2DEvent?.Invoke(other);
        }

        private void OnTriggerEnter2D(Collider2D other)
        {
            this.OnTriggerEnter2DEvent?.Invoke(other);
        }

        private void OnTriggerStay2D(Collider2D other)
        {
            this.OnTriggerStay2DEvent?.Invoke(other);
        }

        private void OnTriggerExit2D(Collider2D other)
        {
            this.OnTriggerExit2DEvent?.Invoke(other);
        }

        private void OnApplicationFocus(bool hasFocus)
        {
            this.OnApplicationFocusEvent?.Invoke(hasFocus);
        }

        private void OnApplicationPause(bool pauseStatus)
        {
            this.OnApplicationPauseEvent?.Invoke(pauseStatus);
        }

        private void OnApplicationQuit()
        {
            this.OnApplicationQuitEvent?.Invoke();
        }
    }
}