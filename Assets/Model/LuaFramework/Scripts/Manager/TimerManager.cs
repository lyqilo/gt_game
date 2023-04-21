using UnityEngine;
using System.Collections.Generic;

namespace LuaFramework {

    public delegate void TimerInfoFunc();

    public class TimerInfo {
        public float duration;          //多久调用一次
        public int loop;                //循环次数
        public bool scale;              //是否采用 unscaledDeltaTime计时
        public TimerInfoFunc func;      //Timer调用函数

        private float time;

        /// <summary>
        /// 创建一个TimerInfo
        /// </summary>
        /// <param name="func">Timer执行的函数</param>
        /// <param name="duration">Timer多久调用一次函数（秒）</param>
        /// <param name="loop">Timer循环次数 -1无限</param>
        /// <param name="scale">是否采用 unscaledDeltaTime计时</param>
        public TimerInfo(TimerInfoFunc func,float duration, int loop = 1,bool scale = false)
        {
            this.func = func;
            this.duration = duration;
            this.loop = loop;
            this.scale = scale;
            this.time = duration;
        }

        public void Start(TimerInfoFunc func, float duration, int loop = 1, bool scale = false)
        {
            var mrg = AppFacade.Instance.GetManager<TimerManager>();
            mrg.AddTimerEvent(this);
        }

        public void Reset(TimerInfoFunc func, float duration, int loop = 1, bool scale = false)
        {
            this.func = func;
            this.duration = duration;
            this.loop = loop;
            this.scale = scale;
            this.time = duration;
        }

        public void Stop()
        {
            var mrg = AppFacade.Instance.GetManager<TimerManager>();
            mrg.RemoveTimerEvent(this);
        }

        public void Update()
        {
            var delta = scale ? Time.deltaTime : Time.unscaledDeltaTime;
            time -= delta;
            
            if ( time <= 0 )
            {
                if (loop > 0)
                {
                    if (func != null) func();
                    --loop;
                    time += duration;
                }

                if (loop == 0)
                {
                    Stop();
                }
                else if(loop < 0)
                {
                    if (func != null) func();
                    time += duration;
                }
            }
        }
    }


    public class TimerManager : Manager
    {

        private List<TimerInfo> objects = new List<TimerInfo>();

        private Dictionary<TimerInfo,bool> objectMap = new Dictionary<TimerInfo, bool>();

        void Update()
        {
            if (objects.Count == 0) return;
            for (int i = 0; i < objects.Count;)
            {
                TimerInfo o = objects[i];
                if (!objectMap[o])  //删除
                {
                    objects.Remove(o);
                    objectMap.Remove(o);
                }
                else
                {
                    o.Update();
                    i++;
                }
            }
        }

        /// <summary>
        /// 添加计时器事件
        /// </summary>
        /// <param name="name"></param>
        /// <param name="o"></param>
        public void AddTimerEvent(TimerInfo info) {
            if(!objectMap.ContainsKey(info))
            {
                objectMap.Add(info,true);
                objects.Add(info);
            }
        }

        /// <summary>
        /// 删除计时器事件
        /// </summary>
        /// <param name="name"></param>
        public void RemoveTimerEvent(TimerInfo info) {
            if (objectMap.ContainsKey(info))
            {
                objectMap[info] = false;
            }
        }

      
        
    }
}