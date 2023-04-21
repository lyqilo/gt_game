﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class LuaFramework_UnityWebPacketWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(LuaFramework.UnityWebPacket), typeof(System.Object));
		L.RegFunction("New", _CreateLuaFramework_UnityWebPacket);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("name", get_name, set_name);
		L.RegVar("urlPath", get_urlPath, set_urlPath);
		L.RegVar("localPath", get_localPath, set_localPath);
		L.RegVar("size", get_size, set_size);
		L.RegVar("Request", get_Request, set_Request);
		L.RegVar("www", get_www, set_www);
		L.RegVar("hash", get_hash, set_hash);
		L.RegVar("version", get_version, set_version);
		L.RegVar("crc", get_crc, set_crc);
		L.RegVar("token", get_token, set_token);
		L.RegVar("func", get_func, set_func);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateLuaFramework_UnityWebPacket(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 0)
			{
				LuaFramework.UnityWebPacket obj = new LuaFramework.UnityWebPacket();
				ToLua.PushObject(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: LuaFramework.UnityWebPacket.New");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_name(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebPacket obj = (LuaFramework.UnityWebPacket)o;
			string ret = obj.name;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index name on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_urlPath(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebPacket obj = (LuaFramework.UnityWebPacket)o;
			string ret = obj.urlPath;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index urlPath on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_localPath(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebPacket obj = (LuaFramework.UnityWebPacket)o;
			string ret = obj.localPath;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index localPath on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_size(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebPacket obj = (LuaFramework.UnityWebPacket)o;
			ulong ret = obj.size;
			LuaDLL.tolua_pushuint64(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index size on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Request(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebPacket obj = (LuaFramework.UnityWebPacket)o;
			UnityEngine.Networking.UnityWebRequest ret = obj.Request;
			ToLua.PushObject(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index Request on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_www(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebPacket obj = (LuaFramework.UnityWebPacket)o;
			UnityEngine.Networking.UnityWebRequest ret = obj.www;
			ToLua.PushObject(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index www on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_hash(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebPacket obj = (LuaFramework.UnityWebPacket)o;
			UnityEngine.Hash128 ret = obj.hash;
			ToLua.PushValue(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index hash on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_version(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebPacket obj = (LuaFramework.UnityWebPacket)o;
			int ret = obj.version;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index version on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_crc(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebPacket obj = (LuaFramework.UnityWebPacket)o;
			int ret = obj.crc;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index crc on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_token(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebPacket obj = (LuaFramework.UnityWebPacket)o;
			System.Threading.CancellationToken ret = obj.token;
			ToLua.PushValue(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index token on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_func(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebPacket obj = (LuaFramework.UnityWebPacket)o;
			System.Action<float,object> ret = obj.func;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index func on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_name(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebPacket obj = (LuaFramework.UnityWebPacket)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.name = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index name on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_urlPath(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebPacket obj = (LuaFramework.UnityWebPacket)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.urlPath = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index urlPath on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_localPath(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebPacket obj = (LuaFramework.UnityWebPacket)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.localPath = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index localPath on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_size(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebPacket obj = (LuaFramework.UnityWebPacket)o;
			ulong arg0 = LuaDLL.tolua_checkuint64(L, 2);
			obj.size = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index size on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_Request(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebPacket obj = (LuaFramework.UnityWebPacket)o;
			UnityEngine.Networking.UnityWebRequest arg0 = (UnityEngine.Networking.UnityWebRequest)ToLua.CheckObject<UnityEngine.Networking.UnityWebRequest>(L, 2);
			obj.Request = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index Request on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_www(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebPacket obj = (LuaFramework.UnityWebPacket)o;
			UnityEngine.Networking.UnityWebRequest arg0 = (UnityEngine.Networking.UnityWebRequest)ToLua.CheckObject<UnityEngine.Networking.UnityWebRequest>(L, 2);
			obj.www = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index www on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_hash(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebPacket obj = (LuaFramework.UnityWebPacket)o;
			UnityEngine.Hash128 arg0 = StackTraits<UnityEngine.Hash128>.Check(L, 2);
			obj.hash = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index hash on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_version(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebPacket obj = (LuaFramework.UnityWebPacket)o;
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.version = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index version on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_crc(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebPacket obj = (LuaFramework.UnityWebPacket)o;
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.crc = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index crc on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_token(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebPacket obj = (LuaFramework.UnityWebPacket)o;
			System.Threading.CancellationToken arg0 = StackTraits<System.Threading.CancellationToken>.Check(L, 2);
			obj.token = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index token on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_func(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.UnityWebPacket obj = (LuaFramework.UnityWebPacket)o;
			System.Action<float,object> arg0 = (System.Action<float,object>)ToLua.CheckDelegate<System.Action<float,object>>(L, 2);
			obj.func = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index func on a nil value");
		}
	}
}

