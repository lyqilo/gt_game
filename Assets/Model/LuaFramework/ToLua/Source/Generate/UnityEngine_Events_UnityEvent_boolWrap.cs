﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class UnityEngine_Events_UnityEvent_boolWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(UnityEngine.Events.UnityEvent<bool>), typeof(UnityEngine.Events.UnityEventBase), "UnityEvent_bool");
		L.RegFunction("AddListener", AddListener);
		L.RegFunction("RemoveListener", RemoveListener);
		L.RegFunction("Invoke", Invoke);
		L.RegFunction("New", _CreateUnityEngine_Events_UnityEvent_bool);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateUnityEngine_Events_UnityEvent_bool(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 0)
			{
				UnityEngine.Events.UnityEvent<bool> obj = new UnityEngine.Events.UnityEvent<bool>();
				ToLua.PushObject(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: UnityEngine.Events.UnityEvent<bool>.New");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddListener(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.Events.UnityEvent<bool> obj = (UnityEngine.Events.UnityEvent<bool>)ToLua.CheckObject<UnityEngine.Events.UnityEvent<bool>>(L, 1);
			UnityEngine.Events.UnityAction<bool> arg0 = (UnityEngine.Events.UnityAction<bool>)ToLua.CheckDelegate<UnityEngine.Events.UnityAction<bool>>(L, 2);
			obj.AddListener(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int RemoveListener(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.Events.UnityEvent<bool> obj = (UnityEngine.Events.UnityEvent<bool>)ToLua.CheckObject<UnityEngine.Events.UnityEvent<bool>>(L, 1);
			UnityEngine.Events.UnityAction<bool> arg0 = (UnityEngine.Events.UnityAction<bool>)ToLua.CheckDelegate<UnityEngine.Events.UnityAction<bool>>(L, 2);
			obj.RemoveListener(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Invoke(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.Events.UnityEvent<bool> obj = (UnityEngine.Events.UnityEvent<bool>)ToLua.CheckObject<UnityEngine.Events.UnityEvent<bool>>(L, 1);
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.Invoke(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

