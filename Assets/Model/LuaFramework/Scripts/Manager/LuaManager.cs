using UnityEngine;
using System.Collections;
using System.IO;
using LuaInterface;
using System;

namespace LuaFramework {
    public class LuaManager : Manager {
        private LuaState lua;
        private LuaLoader loader;
        private LuaLooper loop = null;

        // Use this for initialization
        public override void OnInitialize() {

            loader = new LuaLoader();
            lua = new LuaState();
            this.OpenLibs();
            lua.LuaSetTop(0);

            LuaBinder.Bind(lua);
            DelegateFactory.Init();
            LuaCoroutine.Register(lua, this);
   
        }

        public override void UnInitialize()
        {
            Destroy(loop);
            loop = null;

            lua.Dispose();
            lua = null;
            loader = null;
        }

        public void InitStart() {
 
#if UNITY_EDITOR
            if (!LoadState.LuaLoadState)
            { 
                //初始化Lua文件所在路径
                InitLuaPath();
            }
#endif
            if (AppConst.LuaDebug)
            {
                lua.AddSearchPath(Util.DataPath + "/Lua");
            }
            //启动LUAVM
            this.lua.Start();    
            //this.StartMain();
            this.StartLooper();
     
        }

        void StartLooper() {
            if (loop == null)
            {
                loop = gameObject.AddComponent<LuaLooper>();
                loop.luaState = lua;
            }

        }

        //cjson 比较特殊，只new了一个table，没有注册库，这里注册一下
        protected void OpenCJson() {
            lua.LuaGetField(LuaIndexes.LUA_REGISTRYINDEX, "_LOADED");
            lua.OpenLibs(LuaDLL.luaopen_cjson);
            lua.LuaSetField(-2, "cjson");

            lua.OpenLibs(LuaDLL.luaopen_cjson_safe);
            lua.LuaSetField(-2, "cjson.safe");
        }

        void StartMain() {
            lua.DoFile("Main.lua");

            LuaFunction main = lua.GetFunction("Main");
            main.Call();
            main.Dispose();
            main = null;    
        }
        
        /// <summary>
        /// 初始化加载第三方库
        /// </summary>
        void OpenLibs() {
            lua.OpenLibs(LuaDLL.luaopen_pb);      
#if UNITY_STANDALONE64   
            lua.OpenLibs(LuaDLL.luaopen_sproto_core);
            lua.OpenLibs(LuaDLL.luaopen_protobuf_c);
#endif
            lua.OpenLibs(LuaDLL.luaopen_lpeg);
            lua.OpenLibs(LuaDLL.luaopen_bit);
            lua.OpenLibs(LuaDLL.luaopen_socket_core);

            this.OpenCJson();
        }

#if UNITY_EDITOR
        /// <summary>
        /// 初始化Lua代码加载路径
        /// </summary>
        void InitLuaPath() {

            string rootPath = AppConst.LuaFrameworkRoot;
            lua.AddSearchPath(rootPath + "/Lua");
            lua.AddSearchPath(rootPath + "/ToLua/Lua");
        }
#endif

        public void DoFile(string filename)
        {
            lua.DoFile(filename);
        }


        public T DoFile<T>(string fileName)
        {
            return lua.DoFile<T>(fileName);
        }

        public void LuaGC() {
            lua.LuaGC(LuaGCOptions.LUA_GCCOLLECT);
        }

        public void DoString(string str)
        {
            this.lua.DoString(str, "LuaState.cs");
        }

        #region C#调Lua

        // Token: 0x0600250F RID: 9487 RVA: 0x000F6E0C File Offset: 0x000F500C
        public LuaTable GetTable(string name)
        {
            return this.lua.GetTable(name, true);
        }

        // Token: 0x0600250E RID: 9486 RVA: 0x000F6DEC File Offset: 0x000F4FEC
        public LuaFunction GetFunction(string funcName, bool show = true)
        {
            return this.lua.GetFunction(funcName, false);
        }


        // Update is called once per frame
        public object[] CallFunction(string funcName, params object[] args)
        {
            LuaFunction func = lua.GetFunction(funcName);
            if (func != null)
            {
                return func.LazyCall(args);
            }
            return null;
        }

        public void CallFunction(string funcName)
        {
            LuaFunction func = lua.GetFunction(funcName);
            if (func != null)
            {
                func.Call();
            }
        }

        public void CallFunction<T1>(string funcName, T1 arg)
        {
            LuaFunction func = lua.GetFunction(funcName);
            if (func != null)
            {
                func.Call(arg);
            }
        }

        public void CallFunction<T1, T2>(string funcName, T1 arg1, T2 arg2)
        {
            LuaFunction func = lua.GetFunction(funcName);
            if (func != null)
            {
                func.Call(arg1, arg2);
            }
        }

        public string GetLanguage(int id)
        {
            LuaFunction func = lua.GetFunction("getLanguage");
            if (func != null)
            {
                return func.Invoke<int, string>(id);
            }
            else
            {
                return "Empty";
            }
        }
        public void CallFunction(object obj, params object[] args)
        {
            try
            {
                LuaFunction luaFunction = (LuaFunction)obj;
                bool flag = luaFunction == null;
                if (flag)
                {
                    Debug.LogError("LuaFunction is null");
                }
                else
                {
                    bool flag2 = args.Length == 0;
                    if (flag2)
                    {
                        luaFunction.Call();
                    }
                    else
                    {
                        bool flag3 = args.Length == 1;
                        if (flag3)
                        {
                            luaFunction.Call<object>(args[0]);
                        }
                        else
                        {
                            bool flag4 = args.Length == 2;
                            if (flag4)
                            {
                                luaFunction.Call<object, object>(args[0], args[1]);
                            }
                            else
                            {
                                bool flag5 = args.Length == 3;
                                if (flag5)
                                {
                                    luaFunction.Call<object, object, object>(args[0], args[1], args[2]);
                                }
                                else
                                {
                                    bool flag6 = args.Length == 4;
                                    if (flag6)
                                    {
                                        luaFunction.Call<object, object, object, object>(args[0], args[1], args[2], args[3]);
                                    }
                                    else
                                    {
                                        bool flag7 = args.Length == 5;
                                        if (flag7)
                                        {
                                            luaFunction.Call<object, object, object, object, object>(args[0], args[1], args[2], args[3], args[4]);
                                        }
                                        else
                                        {
                                            bool flag8 = args.Length == 6;
                                            if (flag8)
                                            {
                                                luaFunction.Call<object, object, object, object, object, object>(args[0], args[1], args[2], args[3], args[4], args[5]);
                                            }
                                            else
                                            {
                                                bool flag9 = args.Length == 7;
                                                if (flag9)
                                                {
                                                    luaFunction.Call<object, object, object, object, object, object, object>(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
                                                }
                                                else
                                                {
                                                    bool flag10 = args.Length == 8;
                                                    if (flag10)
                                                    {
                                                        luaFunction.Call<object, object, object, object, object, object, object, object>(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
                                                    }
                                                    else
                                                    {
                                                        bool flag11 = args.Length == 9;
                                                        if (flag11)
                                                        {
                                                            luaFunction.Call<object, object, object, object, object, object, object, object, object>(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Debug.LogError(ex.Message);
            }
        }
        #endregion
    }
}