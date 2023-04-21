using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using LuaFramework;
using UnityEngine;
using UnityEngine.UI;
using LuaInterface;
    public class TweenData
    {
        #region 基础参数

        protected TweenType m_TweenType;
        public TweenType TweenType { get { return m_TweenType; } }
        /// <summary>
        /// 起始数值保存
        /// </summary>
        protected object StartValue { set; get; }

        /// <summary>
        /// 目标数值保存
        /// </summary>
        protected object EndValue { set; get; }


        private float m_totalTime;
        /// <summary>
        /// 缓动所需总时间
        /// </summary>
        protected float TotalTime { 
            set{
                m_totalTime = Mathf.Max(1/AppConst.GameFrameRate,value);
            }
            get
            {
                return m_totalTime;
            }
        }

        /// <summary>
        /// 当前已经缓动时间
        /// </summary>
        protected float CurTime { set; get; }

        /// <summary>
        /// 距离缓动完成剩余时间，被暂停返回-1
        /// </summary>
        public float RemaTime
        {
            get
            {
                if (IsPause)
                    return -1;
                return (TotalTime - CurTime);
            }
        }

        protected Transitions transitionType;
        /// <summary>
        /// 设置缓动类型，默认Liner
        /// </summary>
        public Transitions TransitionType
        {
            set
            {
                transitionType = value;
                TransitionFunc = TweenerManager.GetTransition(value);
            }
            get { return transitionType; }
        }
        protected Func<float, float> TransitionFunc;

        /// <summary>
        /// 循环次数
        /// </summary>
        protected int m_loop = 0;

        /// <summary>
        /// 是否為PingPong
        /// </summary>
        protected bool m_pingpong = false;
        protected float m_pingpongCount = 0;


        #endregion

        #region 回调函数
        /// <summary>
        /// C#使用启动回调函数，外部可设置
        /// </summary>
        public Action OnStart { set; get; }
        /// <summary>
        /// C#使用更新回调函数，外部可设置
        /// </summary>
        public Action OnUpdate { set; get; }
        /// <summary>
        /// C#使用完成回调函数，外部可设置
        /// </summary>
        public Action OnComplete { set; get; }

        private LuaFunction onLuaStart;
        /// <summary>
        /// Lua使用启动回调函数，外部可设置
        /// </summary>
        public LuaFunction OnLuaStart 
        { 
            set 
            {
                if (value == null)
                {
                    if (onLuaStart != null)
                    {
                        onLuaStart.Dispose();
                        onLuaStart = null;
                    }
                }
                else if (onLuaStart != null && !onLuaStart.Equals(value))
                {
                    onLuaStart.Dispose();
                    onLuaStart = null;
                    onLuaStart = value;
                }
                else
                {
                    onLuaStart = value;
                }
            } 
            get
            {
                return onLuaStart;
            } 
        }

        private LuaFunction onLuaUpdate;
        /// <summary>
        /// Lua使用更新回调函数，外部可设置 PS:效率低建议不使用
        /// </summary>
        public LuaFunction OnLuaUpdate
        {
            set
            {
                if (value == null)
                {
                    if (onLuaUpdate != null)
                    {
                        onLuaUpdate.Dispose();
                        onLuaUpdate = null;
                    }
                }
                else if (onLuaUpdate != null && !onLuaUpdate.Equals(value))
                {
                    onLuaUpdate.Dispose();
                    onLuaUpdate = null;
                    onLuaUpdate = value;
                }
                else
                {
                    onLuaUpdate = value;
                }
            }
            get
            {
                return onLuaUpdate;
            }
        }

        private LuaFunction onLuaComplete;
        /// <summary>
        /// Lua使用完成回调函数，外部可设置
        /// </summary>
        public LuaFunction OnLuaComplete
        {
            set
            {
                if (value == null)
                {
                    if (onLuaComplete != null)
                    {
                        onLuaComplete.Dispose();
                        onLuaComplete = null;
                    }
                }
                else if (onLuaComplete != null && !onLuaComplete.Equals(value))
                {
                    onLuaComplete.Dispose();
                    onLuaComplete = null;
                    onLuaComplete = value;
                }
                else
                {
                    onLuaComplete = value;
                }
            }
            get
            {
                return onLuaComplete;
            }
        }
        #endregion

        /// <summary>
        /// 是否暂停移动，外部可设置
        /// </summary>
        public bool IsPause { set; get; }
        /// <summary>
        /// 是否销毁移动，外部可设置
        /// </summary>
        public bool IsOver { set; get; }

        /// <summary>
        /// 重新设置参数
        /// </summary>
        /// <param name="obj">重设缓动的GameObject</param>
        /// <param name="time">缓动时间</param>
        /// <param name="startv">开始值</param>
        /// <param name="endv">结束值</param>
        /// <param name="delay">延时时间</param>
        public void ReSetInfo(GameObject obj, float time, object startv, object endv, float delay = 0)
        {
            IsOver = true;

            IsPause = false;

            CurTime = -delay;

            TotalTime = time;

            StartValue = startv;

            EndValue = endv;

            ReSetStartPos(obj, startv);
        }

        public TweenData(float time, object startv, object endv, float delay)
        {
            TransitionType = Transitions.LINEAR;

            IsOver = true;

            IsPause = false;

            CurTime = -delay;

            TotalTime = time;

            StartValue = startv;

            EndValue = endv;
        }

        ~TweenData()
        {
            TransitionFunc = null;

            OnStart = null;
            OnUpdate = null;
            OnComplete = null;

            if (OnLuaStart != null)
                OnLuaStart.Dispose();
            if (OnLuaUpdate != null)
                OnLuaUpdate.Dispose();
            if (OnLuaComplete != null)
                OnLuaComplete.Dispose();
            OnLuaStart = null;
            OnLuaUpdate = null;
            OnLuaComplete = null;
        }

        /// <summary>
        /// 开始缓动
        /// </summary>
        public void Start()
        {
            IsPause = false;
            IsOver = false;
        }

        public void Stop()
        {
            IsOver = true;
        }

        /// <summary>
        /// 重新缓动
        /// </summary>
        public void Reset()
        {
            IsPause = false;
            IsOver = false;
            CurTime = 0;
        }

        public void Reset(float delay)
        {
            IsPause = false;
            IsOver = false;
            CurTime = -delay;
        }

        /// <summary>
        /// 反向缓动
        /// </summary>
        public void Reverse()
        {
            object temp = StartValue;
            StartValue = EndValue;
            EndValue = temp;
            Reset();
        }

        /// <summary>
        /// 设置是否为PingPong
        /// </summary>
        public void SetPingPong(bool key,int count)
        {
            m_pingpong = key;
            m_pingpongCount = count;
        }
        public void SetPingPong(bool key)
        {
            m_pingpong = key;
            m_pingpongCount = -1f;
        }

        /// <summary>
        /// 设置Loop次数,负数为无限次
        /// </summary>
        /// <param name="loop"></param>
        public void SetLoopCount(int loop)
        {
            m_loop = loop;
        }

        public bool Update(GameObject obj)
        {

            if (IsOver)
                return true;
            if (IsPause)
                return false;

            if (CurTime == 0)
            {
                if (OnStart != null)
                {
                    OnStart();
                    OnStart = null;
                }
                if (OnLuaStart != null)
                {
                    OnLuaStart.Call();
                    OnLuaStart.Dispose();
                    OnLuaStart = null;
                }
            }

            CurTime = CurTime + Time.deltaTime;

            if (CurTime < 0)
            { }
            else if (TotalTime - CurTime > 0)
            {
                if (OnStart != null)
                {
                    OnStart();
                    OnStart = null;
                }
                if (OnLuaStart != null)
                {
                    OnLuaStart.Call();
                    OnLuaStart.Dispose();
                    OnLuaStart = null;
                }

                if (OnLuaUpdate != null)
                    OnLuaUpdate.Call();
                if (OnUpdate != null)
                    OnUpdate();

                TweenUpdateFunc(obj);
            }
            else if (TotalTime - CurTime <= 0)
            {
                if (OnLuaUpdate != null)
                    OnLuaUpdate.Call();
                if (OnUpdate != null)
                    OnUpdate();

                TweenUpdateFunc(obj);

                if (OnLuaUpdate != null)
                {
                    OnLuaUpdate.Call();
                    OnLuaUpdate.Dispose();
                    OnLuaUpdate = null;
                }
                if (OnUpdate != null)
                    OnUpdate();
                OnUpdate = null;

                if (m_pingpongCount != 0 || m_loop != 0)
                {
                    if (m_pingpong)
                    {
                        if (m_pingpongCount > 0)
                        {
                            --m_pingpongCount;
                        }
                        Reverse();
                    }
                    else
                    {
                        if (m_loop > 0)
                        {
                            --m_loop;
                        }
                        Reset();
                    }
                    return false;
                }

                IsOver = true;

                if (OnLuaComplete != null)
                {
                    OnLuaComplete.Call();
                }
                if (OnComplete != null)
                    OnComplete();

                return IsOver;
            }
            return false;
        }

        public virtual void ReSetStartPos(GameObject obj, object startv){}

        public virtual void TweenUpdateFunc(GameObject Obj){}
    }

    public class TweenDataPos : TweenData
    {

        /// <summary>
        /// 创建位移缓动数据
        /// </summary>
        /// <param name="obj">需缓动物体</param>
        /// <param name="time">缓动时间</param>
        /// <param name="endpos">缓动目标位置</param>
        /// <param name="delay">延迟启动时间</param>
        public TweenDataPos(GameObject obj, float time, object startv, object endv, float delay = 0)
            : base(time,startv,endv,delay)
        {
            m_TweenType = TweenType.Pos;
            obj.transform.localPosition = (Vector3)startv;
        }

        public override void ReSetStartPos(GameObject obj, object startv)
        {
            obj.transform.localPosition = (Vector3)startv;
        }

        public override void TweenUpdateFunc(GameObject Obj)
        {
            var ratio = Mathf.Min(1f, CurTime / TotalTime);
            if (TransitionFunc != null)
            {
                var progress = TransitionFunc(ratio);
                Vector3 endVar = (Vector3)(EndValue);
                Vector3 start = (Vector3)(StartValue);
                var curX = TweenerManager.TransitionsExecute(start.x, endVar.x, progress);
                var curY = TweenerManager.TransitionsExecute(start.y, endVar.y, progress);
                var curZ = TweenerManager.TransitionsExecute(start.z, endVar.z, progress);
                Obj.transform.localPosition = new Vector3(curX, curY, curZ);    
            }
        }
    }

    public class TweenDataScale : TweenData
    {
        /// <summary>
        /// 创建大小缓动数据
        /// </summary>
        /// <param name="obj">需缓动物体</param>
        /// <param name="time">缓动时间</param>
        /// <param name="endscale">缓动目标大小</param>
        /// <param name="delay">延迟启动时间</param>
        public TweenDataScale(GameObject obj, float time, object startv, object endv, float delay = 0)
            : base(time, startv, endv, delay)
        {
            m_TweenType = TweenType.Scale;
            obj.transform.localScale = (Vector3)startv;
        }

        /// <summary>
        /// 重新设置参数
        /// </summary>
        /// <param name="time">缓动时间</param>
        /// <param name="startv">开始值</param>
        /// <param name="endv">结束值</param>
        /// <param name="delay">延时时间</param>
        public override void ReSetStartPos(GameObject obj, object startv)
        {
            obj.transform.localScale = (Vector3)startv;
        }

        public override void TweenUpdateFunc(GameObject Obj)
        {
            var ratio = Mathf.Min(1f, CurTime / TotalTime);
            if (TransitionFunc != null)
            {
                var progress = TransitionFunc(ratio);
                Vector3 endVar = (Vector3)(EndValue);
                Vector3 start = (Vector3)(StartValue);
                var curX = TweenerManager.TransitionsExecute(start.x, endVar.x, progress);
                var curY = TweenerManager.TransitionsExecute(start.y, endVar.y, progress);
                var curZ = TweenerManager.TransitionsExecute(start.z, endVar.z, progress);
                Obj.transform.localScale = new Vector3(curX, curY, curZ);
            }
        }
    }

    public class TweenDataRotate : TweenData
    {
        /// <summary>
        /// 创建大小缓动数据
        /// </summary>
        /// <param name="obj">需缓动物体</param>
        /// <param name="time">缓动时间</param>
        /// <param name="endscale">缓动目标大小</param>
        /// <param name="delay">延迟启动时间</param>
        public TweenDataRotate(GameObject obj, float time, object startv, object endv, float delay = 0)
            : base(time, startv, endv, delay)
        {
            m_TweenType = TweenType.Rotate;
            obj.transform.localRotation = Quaternion.Euler((Vector3)startv);
        }

        /// <summary>
        /// 重新设置参数
        /// </summary>
        /// <param name="time">缓动时间</param>
        /// <param name="startv">开始值</param>
        /// <param name="endv">结束值</param>
        /// <param name="delay">延时时间</param>
        public override void ReSetStartPos(GameObject obj,object startv)
        {
            obj.transform.localRotation = Quaternion.Euler((Vector3)startv);
        }

        public override void TweenUpdateFunc(GameObject Obj)
        {
            var ratio = Mathf.Min(1f, CurTime / TotalTime);
            if (TransitionFunc != null)
            {
                var progress = TransitionFunc(ratio);
                Vector3 endVar = (Vector3)(EndValue);
                Vector3 start = (Vector3)(StartValue);
                var curX = TweenerManager.TransitionsExecute(start.x, endVar.x, progress);
                var curY = TweenerManager.TransitionsExecute(start.y, endVar.y, progress);
                var curZ = TweenerManager.TransitionsExecute(start.z, endVar.z, progress);
                Vector3 newR = new Vector3(curX, curY, curZ);
                Obj.transform.localRotation = Quaternion.Euler((Vector3)newR);
            }
        }
    }

    public class TweenDataFloat : TweenData
    {
        /// <summary>
        /// 创建数字缓动数据
        /// </summary>
        /// <param name="obj">需缓数字的依托Gameobject,数值变动会反映在localPosion的Z轴，建议新建一个不用的GameObject</param>
        /// <param name="time">缓动时间</param>
        /// <param name="svalue">开始数值</param>
        /// <param name="evalue">结束数值</param>
        /// <param name="delay">延迟启动时间</param>
        public TweenDataFloat(GameObject obj, float time, object svalue, object evalue, float delay = 0)
            : base(time, svalue, evalue, delay)
        {
            m_TweenType = TweenType.Num;
        }

        /// <summary>
        /// 重新设置参数
        /// </summary>
        /// <param name="time">缓动时间</param>
        /// <param name="startv">开始值</param>
        /// <param name="endv">结束值</param>
        /// <param name="delay">延时时间</param>
        public override void ReSetStartPos(GameObject obj,  object svalue){}

        public override void TweenUpdateFunc(GameObject Obj)
        {
            var ratio = Mathf.Min(1f, CurTime / TotalTime);
            if (TransitionFunc != null)
            {
                var progress = TransitionFunc(ratio); 
                float endVar = (float)(EndValue);
                float start = (float)(StartValue);
                float curA = TweenerManager.TransitionsExecute(start, endVar, progress);
                Obj.transform.localPosition = new Vector3(-10000, -10000, curA);
            }
        }

    }
