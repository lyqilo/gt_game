using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.UI;
using LuaFramework;


    public enum Transitions
    {
        LINEAR = 0,
        EASE_IN,
        EASE_OUT,
        EASE_IN_OUT,
        EASE_OUT_IN,
        EASE_IN_BACK,
        EASE_OUT_BACK,
        EASE_IN_OUT_BACK,
        EASE_OUT_IN_BACK,
        EASE_IN_ELASTIC,
        EASE_OUT_ELASTIC,
        EASE_IN_OUT_ELASTIC,
        EASE_OUT_IN_ELASTIC,
        EASE_IN_BOUNCE,
        EASE_OUT_BOUNCE,
        EASE_IN_OUT_BOUNCE,
        EASE_OUT_IN_BOUNCE,
        EASE_IN_TO_OUT_ELASTIC,
    }

    public enum TweenType
    {
        Pos,
        Scale,
        Rotate,
        Num
    }

    public class TweenerManager : MonoBehaviour
    {
        private class TweenerManagerData
        {
            private int m_id;
            public int Id {  get{return m_id;} }

            private GameObject gameObject;

            private List<TweenData> TweenDataList = new List<TweenData>();

            public TweenerManagerData(int id,GameObject obj)
            {
                m_id = id;
                gameObject = obj;
            }

            /// <summary>
            /// 获取TweenData
            /// </summary>
            public TweenData GetTweenData(TweenType type)
            {
                for(int i =0;i < TweenDataList.Count;i++)
                {
                    if (TweenDataList[i].TweenType == type)
                        return TweenDataList[i];
                }
                return null;
            }

            /// <summary>
            /// 设置一个TweenData
            /// </summary>
            public void AddTweenData(TweenData data)
            {
                bool isHave = false;
                for(int i = 0;i < TweenDataList.Count;i++)
                {
                    if (TweenDataList[i].TweenType == data.TweenType)
                    {
                        isHave = true;
                        if(!TweenDataList[i].Equals(data))
                        {
                            TweenDataList[i] = data;
                        }
                    }
                }
                if (!isHave)
                    TweenDataList.Add(data);
            }

            public bool Update()
            {
                if (gameObject == null)
                    return true;

                bool isOver = true;
                for (int i = 0; i < TweenDataList.Count; i++)
                {
                    if (!TweenDataList[i].Update(gameObject))
                    {
                        isOver = false;
                    }
                }
                return isOver;
            }

            public void Finished()
            {
                if(TweenDataList!= null)
                    TweenDataList.Clear();
                TweenDataList = null;
                gameObject = null;
            }
        }

        private static bool IsInit = false;

        private static TweenerManager Mgr;

        private static Dictionary<int, TweenerManagerData> TweenDatas = new Dictionary<int, TweenerManagerData>();

        private static Dictionary<Transitions, Func<float, float>> TransitionFuncList = new Dictionary<Transitions, Func<float, float>>();

        private static List<int> DelList = new List<int>();

        private static Dictionary<int,TweenerManagerData> AddList = new Dictionary<int,TweenerManagerData>();

        #region 缓动算法
        private static float TransitionsLinear(float ratio)
        {
            return ratio;
        }

        private static float TransitionsEaseIn(float ratio)
        {
            return ratio * ratio * ratio;
        }
        private static float TransitionsEaseOut(float ratio)
        {
            var invRatio = ratio - 1.0f;
            return invRatio * invRatio * invRatio + 1;
        }

        private static float TransitionsEaseCombined(Func<float, float> startFunc, Func<float, float> endFunc, float ratio)
        {
            if (ratio < 0.5f)
            {
                return 0.5f * startFunc(ratio * 2.0f);
            }
            else
            {
                return 0.5f * endFunc((ratio - 0.5f) * 2.0f) + 0.5f;
            }
        }

        private static float TransitionsEaseInOut(float ratio)
        {
            return TransitionsEaseCombined(TransitionsEaseIn, TransitionsEaseOut, ratio);
        }

        private static float TransitionsEaseOutIn(float ratio)
        {
            return TransitionsEaseCombined(TransitionsEaseOut, TransitionsEaseIn, ratio);
        }

        private static float TransitionsEaseInBack(float ratio)
        {
            var s = 1.70158f;
            return Mathf.Pow(ratio, 2f) * ((s + 1.0f) * ratio - s);
        }

        private static float TransitionsEaseOutBack(float ratio)
        {
            var invRatio = ratio - 1.0f;
            var s = 1.70158f;
            return Mathf.Pow(invRatio, 2f) * ((s + 1.0f) * invRatio + s) + 1.0f;
        }

        private static float TransitionsEaseInOutBack(float ratio)
        {
            return TransitionsEaseCombined(TransitionsEaseInBack, TransitionsEaseOutBack, ratio);
        }

        private static float TransitionsEaseOutInBack(float ratio)
        {
            return TransitionsEaseCombined(TransitionsEaseOutBack, TransitionsEaseInBack, ratio);
        }

        private static float TransitionsEaseulongoOutElastic(float ratio)
        {
            return TransitionsEaseCombined(TransitionsEaseIn, TransitionsEaseOutElastic, ratio);
        }

        private static float TransitionsEaseInElastic(float ratio)
        {
            if (ratio == 0 || ratio == 1)
            {
                return ratio;
            }
            else
            {
                var p = 0.3f;
                var s = p / 4.0f;
                var invRatio = ratio - 1f;
                return -1.0f * Mathf.Pow(2.0f, 10.0f * invRatio) * Mathf.Sin((invRatio - s) * (2.0f * Mathf.PI) / p);
            }
        }

        private static float TransitionsEaseOutElastic(float ratio)
        {
            if (ratio == 0 || ratio == 1)
            {
                return ratio;
            }
            else
            {
                var p = 0.3f;
                var s = p / 4.0f;
                return Mathf.Pow(2.0f, -10.0f * ratio) * Mathf.Sin((ratio - s) * (2.0f * Mathf.PI) / p) + 1f;
            }
        }

        private static float TransitionsEaseInOutElastic(float ratio)
        {
            return TransitionsEaseCombined(TransitionsEaseInElastic, TransitionsEaseOutElastic, ratio);
        }

        private static float TransitionsEaseOutInElastic(float ratio)
        {
            return TransitionsEaseCombined(TransitionsEaseOutElastic, TransitionsEaseInElastic, ratio);
        }

        private static float TransitionsEaseInBounce(float ratio)
        {
            return 1.0f - TransitionsEaseOutBounce(1.0f - ratio);
        }

        private static float TransitionsEaseOutBounce(float ratio)
        {
            var s = 7.5625f;
            var p = 2.75f;
            float l;
            if (ratio < (1.0f / p))
            {
                l = s * Mathf.Pow(ratio, 2f);
            }
            else
            {
                if (ratio < (2.0f / p))
                {
                    ratio = ratio - 1.5f / p;
                    l = s * Mathf.Pow(ratio, 2f) + 0.75f;
                }
                else
                {
                    if (ratio < 2.5f / p)
                    {
                        ratio = ratio - 2.25f / p;
                        l = s * Mathf.Pow(ratio, 2f) + 0.9375f;
                    }
                    else
                    {
                        ratio = ratio - 2.625f / p;
                        l = s * Mathf.Pow(ratio, 2f) + 0.984375f;
                    }
                }
            }
            return l;
        }

        private static float TransitionsEaseInOutBounce(float ratio)
        {
            return TransitionsEaseCombined(TransitionsEaseInBounce, TransitionsEaseOutBounce, ratio);
        }

        private static float TransitionsEaseOutInBounce(float ratio)
        {
            return TransitionsEaseCombined(TransitionsEaseOutBounce, TransitionsEaseInBounce, ratio);
        }

        public static float TransitionsExecute(float startVar, float endVar, float progress)
        {
            return startVar + progress * (endVar - startVar);
        }

        private static void Init()
        {
            if (!IsInit)
            {
                Register(Transitions.LINEAR, TransitionsLinear);
                Register(Transitions.EASE_IN, TransitionsEaseIn);
                Register(Transitions.EASE_OUT, TransitionsEaseOut);
                Register(Transitions.EASE_IN_OUT, TransitionsEaseInOut);
                Register(Transitions.EASE_OUT_IN, TransitionsEaseOutIn);
                Register(Transitions.EASE_IN_BACK, TransitionsEaseInBack);
                Register(Transitions.EASE_OUT_BACK, TransitionsEaseOutBack);
                Register(Transitions.EASE_IN_OUT_BACK, TransitionsEaseInOutBack);
                Register(Transitions.EASE_OUT_IN_BACK, TransitionsEaseOutInBack);
                Register(Transitions.EASE_IN_ELASTIC, TransitionsEaseInElastic);
                Register(Transitions.EASE_OUT_ELASTIC, TransitionsEaseOutElastic);
                Register(Transitions.EASE_IN_OUT_ELASTIC, TransitionsEaseInOutElastic);
                Register(Transitions.EASE_OUT_IN_ELASTIC, TransitionsEaseOutInElastic);
                Register(Transitions.EASE_IN_BOUNCE, TransitionsEaseInBounce);
                Register(Transitions.EASE_OUT_BOUNCE, TransitionsEaseOutBounce);
                Register(Transitions.EASE_IN_OUT_BOUNCE, TransitionsEaseInOutBounce);
                Register(Transitions.EASE_OUT_IN_BOUNCE, TransitionsEaseOutInBounce);
                Register(Transitions.EASE_IN_TO_OUT_ELASTIC, TransitionsEaseulongoOutElastic);
                IsInit = true;
            }
        }

        private static void Register(Transitions name, Func<float, float> func)
        {
            if (!TransitionFuncList.ContainsKey(name))
            {
                TransitionFuncList.Add(name, func);
            }
        }

        public static Func<float, float> GetTransition(Transitions name)
        {
            Init();
            if (TransitionFuncList.ContainsKey(name))
            {
                return TransitionFuncList[name];
            }
            else
            {
                return null;
            }
        }

        #endregion

        void Awake()
        {
            Mgr = this; 
        }
        
        /// <summary>
        /// 创建一个缓动，并返回该TweenData
        /// PS：另外缓动数据不会自动销毁，需要手动调用RemoveTween
        /// </summary>
        /// <param name="obj">要缓动的GameObject，PS：TweenType == TweenType.Num时这个GameObject是一个临时新建的GameObject,float的缓动会体现在其Z轴</param>
        /// <param name="tweentype">缓动的类型</param>
        /// <param name="delay">延时启动时间</param>
        /// <param name="time">缓动所需时间</param>
        /// <param name="startv">缓动开始值</param>
        /// <param name="endv">缓动结束值</param>
        /// <returns>创建好的TweenData</returns>
        public static TweenData Create(GameObject obj, TweenType tweentype, float delay, float time, object startv, object endv)
        {
            if (obj == null)
                return null;

            TweenData tweenData = null;
            switch (tweentype)
            {
                case TweenType.Pos:
                    {
                        tweenData = new TweenDataPos(obj, time, startv, endv, delay);
                    }
                    break;
                case TweenType.Scale:
                    {
                        tweenData = new TweenDataScale(obj, time, startv, endv, delay);
                    }
                    break;
                case TweenType.Num:
                    {
                        tweenData = new TweenDataFloat(obj, time, startv, endv, delay);
                    }
                    break;
                case TweenType.Rotate:
                    {
                        tweenData = new TweenDataRotate(obj, time, startv, endv, delay);
                    }
                    break;
            }
            return tweenData;
        }

        

        /// <summary>
        /// 创建一个缓动，直接传入TweenData，需要手动Start!!!!
        /// </summary>
        /// <param name="obj">需缓动的GameObject</param>
        /// <param name="tweenData">缓动数据</param>
        public static void AddTween(GameObject obj, TweenData tweenData)
        {
            if (obj == null)
                return;

            //获取或创建TweenerManagerData
            int tid = obj.GetInstanceID();
            TweenerManagerData data = null;
            TweenDatas.TryGetValue(tid, out data);
            if (data == null)
            {
                if (AddList.ContainsKey(tid))
                    data = AddList[tid];
                else
                {
                    data = new TweenerManagerData(tid, obj);
                    AddList.Add(tid, data);
                }
            }
            data.AddTweenData(tweenData);
            tweenData.Start();
        }


        /// <summary>
        /// 销毁GameObject的缓动数据
        /// </summary>
        /// <param name="obj">要销毁数据的GameObject</param>
        public static void RemoveTween(GameObject obj)
        {
            if (obj == null)
                return;

            DelList.Add(obj.GetInstanceID());
        }

        /// <summary>
        /// 清除所有缓动
        /// </summary>
        public static void ClearAllTween()
        {
            foreach (int tid in TweenDatas.Keys)
            {
                DelList.Add(tid);
            }
        }

        void FixedUpdate()
        {
            if(AddList.Count > 0)
            {
                foreach(TweenerManagerData v in AddList.Values)
                {
                    TweenDatas.Add(v.Id, v);
                }
                AddList.Clear();
            }
            if (TweenDatas.Count > 0)
            {
                foreach (TweenerManagerData v in TweenDatas.Values)
                {
                    if(v.Update())
                    {
                        DelList.Add(v.Id);
                    }
                }
            }
            if (DelList.Count > 0)
            {
                for (int i = 0; i < DelList.Count;i++ )
                {
                    int tid = DelList[i];
                    if (TweenDatas.ContainsKey(tid))
                    {
                        if (TweenDatas[tid].Update())
                        {
                            TweenDatas[tid].Finished();
                            TweenDatas.Remove(tid);
                        }
                    }
                }
                DelList.Clear();
            }
        }
    }

