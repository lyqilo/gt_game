using UnityEngine;
using System.Collections.Generic;

namespace LuaFramework {

    public delegate void TimerInfoFunc();

    public class TimerInfo {
        public float duration;          //��õ���һ��
        public int loop;                //ѭ������
        public bool scale;              //�Ƿ���� unscaledDeltaTime��ʱ
        public TimerInfoFunc func;      //Timer���ú���

        private float time;

        /// <summary>
        /// ����һ��TimerInfo
        /// </summary>
        /// <param name="func">Timerִ�еĺ���</param>
        /// <param name="duration">Timer��õ���һ�κ������룩</param>
        /// <param name="loop">Timerѭ������ -1����</param>
        /// <param name="scale">�Ƿ���� unscaledDeltaTime��ʱ</param>
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
                if (!objectMap[o])  //ɾ��
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
        /// ��Ӽ�ʱ���¼�
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
        /// ɾ����ʱ���¼�
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