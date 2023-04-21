﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class LuaFramework_UnityWebDownPacketQueueWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(LuaFramework.UnityWebDownPacketQueue), typeof(System.Object));
		L.RegFunction("Add", Add);
		L.RegFunction("Rmove", Rmove);
		L.RegFunction("New", _CreateLuaFramework_UnityWebDownPacketQueue);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("paks", get_paks, set_paks);
		L.RegVar("Count", get_Count, null);
		L.RegVar("Size", get_Size, null);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateLuaFramework_UnityWebDownPacketQueue(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 0)
			{
				LuaFramework.UnityWebDownPacketQueue obj = new LuaFramework.UnityWebDownPacketQueue();
				ToLua.PushObject(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: LuaFramework.UnityWebDownPacketQueue.New");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Add(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			LuaFramework.UnityWebDownPacketQueue obj = (LuaFramework.UnityWebDownPacketQueue)ToLua.CheckObject<LuaFramework.UnityWebDownPacketQueue>(L, 1);
			LuaFramework.UnityWebPacket arg0 = (LuaFramework.UnityWebPacket)ToLua.CheckObject<LuaFramework.UnityWebPacket>(L, 2);
			obj.Add(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Rmove(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			LuaFramework.UnityWebDownPacketQueue obj = (LuaFramework.UnityWebDownPacketQueue)ToLua.CheckObject<LuaFramework.UnityWebDownPacketQueue>(L, 1);
			LuaFramework.UnityWebPacket arg0 = (LuaFramework.UnityWebPacket)ToLua.CheckObject<LuaFramework.UnityWebPacket>(L, 2);
			obj.Rmove(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_paks(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebDownPacketQueue obj = (LuaFramework.UnityWebDownPacketQueue)o;
			System.Collections.Generic.List<LuaFramework.UnityWebPacket> ret = obj.paks;
			ToLua.PushSealed(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index paks on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Count(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebDownPacketQueue obj = (LuaFramework.UnityWebDownPacketQueue)o;
			int ret = obj.Count;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index Count on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Size(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebDownPacketQueue obj = (LuaFramework.UnityWebDownPacketQueue)o;
			ulong ret = obj.Size;
			LuaDLL.tolua_pushuint64(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index Size on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_paks(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebDownPacketQueue obj = (LuaFramework.UnityWebDownPacketQueue)o;
			System.Collections.Generic.List<LuaFramework.UnityWebPacket> arg0 = (System.Collections.Generic.List<LuaFramework.UnityWebPacket>)ToLua.CheckObject(L, 2, typeof(System.Collections.Generic.List<LuaFramework.UnityWebPacket>));
			obj.paks = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index paks on a nil value");
		}
	}
}
