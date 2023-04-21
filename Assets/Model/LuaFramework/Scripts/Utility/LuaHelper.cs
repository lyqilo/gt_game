using UnityEngine;
using System.Collections.Generic;
using System.Reflection;
using LuaInterface;
using System;

namespace LuaFramework
{
    public static class LuaHelper
    {

        /// <summary>
        /// getType
        /// </summary>
        /// <param name="classname"></param>
        /// <returns></returns>
        public static System.Type GetType(string classname)
        {
            Assembly assb = Assembly.GetExecutingAssembly();  //.GetExecutingAssembly();
            System.Type t = null;
            t = assb.GetType(classname); ;
            if (t == null)
            {
                t = assb.GetType(classname);
            }
            return t;
        }



        /// <summary>
        /// 网络管理器
        /// </summary>
        public static NetworkManager GetNetManager()
        {
            return AppFacade.Instance.GetManager<NetworkManager>();
        }

        /// <summary>
        /// 音乐管理器
        /// </summary>
        public static MusicManager GetSoundManager()
        {
            return AppFacade.Instance.GetManager<MusicManager>();
        }

        public static ResourceManager GetResourceManager()
        {
            return AppFacade.Instance.GetManager<ResourceManager>();
        }

        /// <summary>
        /// 缓存池管理器
        /// </summary>
        public static ObjectPoolManager GetObjectPoolManager()
        {
            return AppFacade.Instance.GetManager<ObjectPoolManager>();
        }


        /// <summary>
        /// 缓存池管理器
        /// </summary>
        public static ILRuntimeManager GetILRuntimeManager()
        {
            return AppFacade.Instance.GetManager<ILRuntimeManager>();
        }




        /// <summary>
        /// pbc/pblua函数回调
        /// </summary>
        /// <param name="func"></param>
        public static void OnCallLuaFunc(LuaByteBuffer data, LuaFunction func)
        {
            if (func != null) func.Call(data);
            DebugTool.LogWarning("OnCallLuaFunc length:>>" + data.buffer.Length);
        }

        /// <summary>
        /// cjson函数回调
        /// </summary>
        /// <param name="data"></param>
        /// <param name="func"></param>
        public static void OnJsonCallFunc(string data, LuaFunction func)
        {
            DebugTool.LogWarning("OnJsonCallback data:>>" + data + " lenght:>>" + data.Length);
            if (func != null) func.Call(data);
        }
    }
}