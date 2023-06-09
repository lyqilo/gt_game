﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class LuaFramework_UnityWebRequestAsyncWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(LuaFramework.UnityWebRequestAsync), typeof(UnityEngine.MonoBehaviour));
		L.RegFunction("Update", Update);
		L.RegFunction("Save", Save);
		L.RegFunction("DownloadAsync", DownloadAsync);
		L.RegFunction("Dispose", Dispose);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("pak", get_pak, set_pak);
		L.RegVar("count", get_count, set_count);
		L.RegVar("currentCount", get_currentCount, set_currentCount);
		L.RegVar("allSize", get_allSize, set_allSize);
		L.RegVar("downSize", get_downSize, set_downSize);
		L.RegVar("isCancel", get_isCancel, set_isCancel);
		L.RegVar("tcs", get_tcs, set_tcs);
		L.RegVar("Progress", get_Progress, null);
		L.RegVar("ByteDownloaded", get_ByteDownloaded, null);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Update(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			LuaFramework.UnityWebRequestAsync obj = (LuaFramework.UnityWebRequestAsync)ToLua.CheckObject<LuaFramework.UnityWebRequestAsync>(L, 1);
			obj.Update();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Save(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			LuaFramework.UnityWebRequestAsync obj = (LuaFramework.UnityWebRequestAsync)ToLua.CheckObject<LuaFramework.UnityWebRequestAsync>(L, 1);
			string arg0 = ToLua.CheckString(L, 2);
			byte[] arg1 = ToLua.CheckByteBuffer(L, 3);
			obj.Save(arg0, arg1);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DownloadAsync(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 2 && TypeChecker.CheckTypes<LuaFramework.UnityWebPacket>(L, 2))
			{
				LuaFramework.UnityWebRequestAsync obj = (LuaFramework.UnityWebRequestAsync)ToLua.CheckObject<LuaFramework.UnityWebRequestAsync>(L, 1);
				LuaFramework.UnityWebPacket arg0 = (LuaFramework.UnityWebPacket)ToLua.ToObject(L, 2);
				System.Threading.Tasks.Task<bool> o = obj.DownloadAsync(arg0);
				ToLua.PushObject(L, o);
				return 1;
			}
			else if (count == 2 && TypeChecker.CheckTypes<System.Collections.Generic.List<LuaFramework.UnityWebPacket>>(L, 2))
			{
				LuaFramework.UnityWebRequestAsync obj = (LuaFramework.UnityWebRequestAsync)ToLua.CheckObject<LuaFramework.UnityWebRequestAsync>(L, 1);
				System.Collections.Generic.List<LuaFramework.UnityWebPacket> arg0 = (System.Collections.Generic.List<LuaFramework.UnityWebPacket>)ToLua.ToObject(L, 2);
				System.Threading.Tasks.Task<bool> o = obj.DownloadAsync(arg0);
				ToLua.PushObject(L, o);
				return 1;
			}
			else if (count == 2 && TypeChecker.CheckTypes<LuaFramework.UnityWebDownPacketQueue>(L, 2))
			{
				LuaFramework.UnityWebRequestAsync obj = (LuaFramework.UnityWebRequestAsync)ToLua.CheckObject<LuaFramework.UnityWebRequestAsync>(L, 1);
				LuaFramework.UnityWebDownPacketQueue arg0 = (LuaFramework.UnityWebDownPacketQueue)ToLua.ToObject(L, 2);
				System.Threading.Tasks.Task<bool> o = obj.DownloadAsync(arg0);
				ToLua.PushObject(L, o);
				return 1;
			}
			else if (count == 3 && TypeChecker.CheckTypes<System.Collections.Generic.List<LuaFramework.UnityWebPacket>, System.Action>(L, 2))
			{
				LuaFramework.UnityWebRequestAsync obj = (LuaFramework.UnityWebRequestAsync)ToLua.CheckObject<LuaFramework.UnityWebRequestAsync>(L, 1);
				System.Collections.Generic.List<LuaFramework.UnityWebPacket> arg0 = (System.Collections.Generic.List<LuaFramework.UnityWebPacket>)ToLua.ToObject(L, 2);
				System.Action arg1 = (System.Action)ToLua.ToObject(L, 3);
				System.Threading.Tasks.Task<bool> o = obj.DownloadAsync(arg0, arg1);
				ToLua.PushObject(L, o);
				return 1;
			}
			else if (count == 3 && TypeChecker.CheckTypes<LuaFramework.UnityWebDownPacketQueue, System.Action>(L, 2))
			{
				LuaFramework.UnityWebRequestAsync obj = (LuaFramework.UnityWebRequestAsync)ToLua.CheckObject<LuaFramework.UnityWebRequestAsync>(L, 1);
				LuaFramework.UnityWebDownPacketQueue arg0 = (LuaFramework.UnityWebDownPacketQueue)ToLua.ToObject(L, 2);
				System.Action arg1 = (System.Action)ToLua.ToObject(L, 3);
				System.Threading.Tasks.Task<bool> o = obj.DownloadAsync(arg0, arg1);
				ToLua.PushObject(L, o);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: LuaFramework.UnityWebRequestAsync.DownloadAsync");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Dispose(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			LuaFramework.UnityWebRequestAsync obj = (LuaFramework.UnityWebRequestAsync)ToLua.CheckObject<LuaFramework.UnityWebRequestAsync>(L, 1);
			obj.Dispose();
			return 0;
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

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_pak(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebRequestAsync obj = (LuaFramework.UnityWebRequestAsync)o;
			LuaFramework.UnityWebPacket ret = obj.pak;
			ToLua.PushObject(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index pak on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_count(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebRequestAsync obj = (LuaFramework.UnityWebRequestAsync)o;
			int ret = obj.count;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index count on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_currentCount(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebRequestAsync obj = (LuaFramework.UnityWebRequestAsync)o;
			int ret = obj.currentCount;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index currentCount on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_allSize(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebRequestAsync obj = (LuaFramework.UnityWebRequestAsync)o;
			ulong ret = obj.allSize;
			LuaDLL.tolua_pushuint64(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index allSize on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_downSize(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebRequestAsync obj = (LuaFramework.UnityWebRequestAsync)o;
			ulong ret = obj.downSize;
			LuaDLL.tolua_pushuint64(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index downSize on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_isCancel(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebRequestAsync obj = (LuaFramework.UnityWebRequestAsync)o;
			bool ret = obj.isCancel;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index isCancel on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_tcs(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebRequestAsync obj = (LuaFramework.UnityWebRequestAsync)o;
			System.Threading.Tasks.TaskCompletionSource<bool> ret = obj.tcs;
			ToLua.PushObject(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index tcs on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Progress(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebRequestAsync obj = (LuaFramework.UnityWebRequestAsync)o;
			float ret = obj.Progress;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index Progress on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_ByteDownloaded(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebRequestAsync obj = (LuaFramework.UnityWebRequestAsync)o;
			ulong ret = obj.ByteDownloaded;
			LuaDLL.tolua_pushuint64(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index ByteDownloaded on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_pak(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebRequestAsync obj = (LuaFramework.UnityWebRequestAsync)o;
			LuaFramework.UnityWebPacket arg0 = (LuaFramework.UnityWebPacket)ToLua.CheckObject<LuaFramework.UnityWebPacket>(L, 2);
			obj.pak = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index pak on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_count(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebRequestAsync obj = (LuaFramework.UnityWebRequestAsync)o;
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.count = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index count on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_currentCount(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebRequestAsync obj = (LuaFramework.UnityWebRequestAsync)o;
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.currentCount = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index currentCount on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_allSize(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebRequestAsync obj = (LuaFramework.UnityWebRequestAsync)o;
			ulong arg0 = LuaDLL.tolua_checkuint64(L, 2);
			obj.allSize = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index allSize on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_downSize(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebRequestAsync obj = (LuaFramework.UnityWebRequestAsync)o;
			ulong arg0 = LuaDLL.tolua_checkuint64(L, 2);
			obj.downSize = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index downSize on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_isCancel(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebRequestAsync obj = (LuaFramework.UnityWebRequestAsync)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.isCancel = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index isCancel on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_tcs(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebRequestAsync obj = (LuaFramework.UnityWebRequestAsync)o;
			System.Threading.Tasks.TaskCompletionSource<bool> arg0 = (System.Threading.Tasks.TaskCompletionSource<bool>)ToLua.CheckObject<System.Threading.Tasks.TaskCompletionSource<bool>>(L, 2);
			obj.tcs = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index tcs on a nil value");
		}
	}
}

