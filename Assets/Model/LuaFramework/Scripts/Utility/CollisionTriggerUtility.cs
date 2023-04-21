using System;
using UnityEngine;

namespace LuaFramework
{
	public class CollisionTriggerUtility : MonoBehaviour
	{
		public Action<GameObject, GameObject> onTriggerEnter2D;

		public Action<GameObject, GameObject> onTriggerExit2D;

		public Action<GameObject, GameObject> onTriggerStay2D;

		public Action<GameObject, GameObject> onCollisionEnter2D;

		public Action<GameObject, GameObject> onCollisionExit2D;

		public Action<GameObject, GameObject> onCollisionStay2D;

		public Action<GameObject, GameObject> onTriggerEnter;

		public Action<GameObject, GameObject> onTriggerExit;

		public Action<GameObject, GameObject> onTriggerStay;

		public Action<GameObject, GameObject> onCollisionEnter;

		public Action<GameObject, GameObject> onCollisionExit;

		public Action<GameObject, GameObject> onCollisionStay;

		public static CollisionTriggerUtility Get(Transform trans)
		{
			CollisionTriggerUtility utility = trans.GetComponent<CollisionTriggerUtility>();
			if (utility == null) utility = trans.gameObject.AddComponent<CollisionTriggerUtility>();
			return utility;
		}

		private void OnTriggerEnter2D(Collider2D hit)
		{
			onTriggerEnter2D?.Invoke(gameObject,hit.gameObject);
		}

		private void OnTriggerExit2D(Collider2D hit)
		{
			onTriggerExit2D?.Invoke(gameObject,hit.gameObject);
		}

		private void OnTriggerStay2D(Collider2D hit)
		{
			onTriggerStay2D?.Invoke(gameObject,hit.gameObject);
		}

		private void OnCollisionEnter2D(Collision2D hit)
		{
			onCollisionEnter2D?.Invoke(gameObject,hit.gameObject);
		}

		private void OnCollisionExit2D(Collision2D hit)
		{
			onCollisionExit2D?.Invoke(gameObject,hit.gameObject);
		}

		private void OnCollisionStay2D(Collision2D hit)
		{
			onCollisionStay2D?.Invoke(gameObject,hit.gameObject);
		}

		private void OnTriggerEnter(Collider hit)
		{
			onTriggerEnter?.Invoke(gameObject,hit.gameObject);
		}

		private void OnTriggerExit(Collider hit)
		{
			onTriggerExit?.Invoke(gameObject,hit.gameObject);
		}

		private void OnTriggerStay(Collider hit)
		{
			onTriggerStay?.Invoke(gameObject,hit.gameObject);
		}

		private void OnCollisionEnter(Collision hit)
		{
			onCollisionEnter?.Invoke(gameObject,hit.gameObject);
		}

		private void OnCollisionExit(Collision hit)
		{
			onCollisionExit?.Invoke(gameObject,hit.gameObject);
		}

		private void OnCollisionStay(Collision hit)
		{
			onCollisionStay?.Invoke(gameObject,hit.gameObject);
		}
	}
}