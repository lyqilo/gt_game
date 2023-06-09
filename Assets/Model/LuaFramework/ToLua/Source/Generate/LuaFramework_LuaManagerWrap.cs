﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class LuaFramework_LuaManagerWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(LuaFramework.LuaManager), typeof(Manager));
		L.RegFunction("OnInitialize", OnInitialize);
		L.RegFunction("UnInitialize", UnInitialize);
		L.RegFunction("InitStart", InitStart);
		L.RegFunction("DoFile", DoFile);
		L.RegFunction("LuaGC", LuaGC);
		L.RegFunction("DoString", DoString);
		L.RegFunction("GetTable", GetTable);
		L.RegFunction("GetFunction", GetFunction);
		L.RegFunction("CallFunction", CallFunction);
		L.RegFunction("GetLanguage", GetLanguage);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnInitialize(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			LuaFramework.LuaManager obj = (LuaFramework.LuaManager)ToLua.CheckObject<LuaFramework.LuaManager>(L, 1);
			obj.OnInitialize();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UnInitialize(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			LuaFramework.LuaManager obj = (LuaFramework.LuaManager)ToLua.CheckObject<LuaFramework.LuaManager>(L, 1);
			obj.UnInitialize();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int InitStart(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			LuaFramework.LuaManager obj = (LuaFramework.LuaManager)ToLua.CheckObject<LuaFramework.LuaManager>(L, 1);
			obj.InitStart();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DoFile(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			LuaFramework.LuaManager obj = (LuaFramework.LuaManager)ToLua.CheckObject<LuaFramework.LuaManager>(L, 1);
			string arg0 = ToLua.CheckString(L, 2);
			obj.DoFile(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LuaGC(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			LuaFramework.LuaManager obj = (LuaFramework.LuaManager)ToLua.CheckObject<LuaFramework.LuaManager>(L, 1);
			obj.LuaGC();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DoString(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			LuaFramework.LuaManager obj = (LuaFramework.LuaManager)ToLua.CheckObject<LuaFramework.LuaManager>(L, 1);
			string arg0 = ToLua.CheckString(L, 2);
			obj.DoString(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetTable(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			LuaFramework.LuaManager obj = (LuaFramework.LuaManager)ToLua.CheckObject<LuaFramework.LuaManager>(L, 1);
			string arg0 = ToLua.CheckString(L, 2);
			LuaInterface.LuaTable o = obj.GetTable(arg0);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetFunction(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 2)
			{
				LuaFramework.LuaManager obj = (LuaFramework.LuaManager)ToLua.CheckObject<LuaFramework.LuaManager>(L, 1);
				string arg0 = ToLua.CheckString(L, 2);
				LuaInterface.LuaFunction o = obj.GetFunction(arg0);
				ToLua.Push(L, o);
				return 1;
			}
			else if (count == 3)
			{
				LuaFramework.LuaManager obj = (LuaFramework.LuaManager)ToLua.CheckObject<LuaFramework.LuaManager>(L, 1);
				string arg0 = ToLua.CheckString(L, 2);
				bool arg1 = LuaDLL.luaL_checkboolean(L, 3);
				LuaInterface.LuaFunction o = obj.GetFunction(arg0, arg1);
				ToLua.Push(L, o);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: LuaFramework.LuaManager.GetFunction");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CallFunction(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 2 && TypeChecker.CheckTypes<LuaFramework.LuaManager, string>(L, 1))
			{
				LuaFramework.LuaManager obj = (LuaFramework.LuaManager)ToLua.ToObject(L, 1);
				string arg0 = ToLua.ToString(L, 2);
				obj.CallFunction(arg0);
				return 0;
			}
			else if (TypeChecker.CheckTypes<LuaFramework.LuaManager, string>(L, 1) && TypeChecker.CheckParamsType<object>(L, 3, count - 2))
			{
				LuaFramework.LuaManager obj = (LuaFramework.LuaManager)ToLua.ToObject(L, 1);
				string arg0 = ToLua.ToString(L, 2);
				object[] arg1 = ToLua.ToParamsObject(L, 3, count - 2);
				object[] o = obj.CallFunction(arg0, arg1);
				ToLua.Push(L, o);
				return 1;
			}
			else if (TypeChecker.CheckTypes<LuaFramework.LuaManager, object>(L, 1) && TypeChecker.CheckParamsType<object>(L, 3, count - 2))
			{
				LuaFramework.LuaManager obj = (LuaFramework.LuaManager)ToLua.ToObject(L, 1);
				object arg0 = ToLua.ToVarObject(L, 2);
				object[] arg1 = ToLua.ToParamsObject(L, 3, count - 2);
				obj.CallFunction(arg0, arg1);
				return 0;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: LuaFramework.LuaManager.CallFunction");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetLanguage(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			LuaFramework.LuaManager obj = (LuaFramework.LuaManager)ToLua.CheckObject<LuaFramework.LuaManager>(L, 1);
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			string o = obj.GetLanguage(arg0);
			LuaDLL.lua_pushstring(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int op_Equality(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.Object arg0 = (UnityEngine.Object)ToLua.ToObject(L, 1);
			UnityEngine.Object arg1 = (UnityEngine.Object)ToLua.ToObject(L, 2);
			bool o = arg0 == arg1;
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

