﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class DragonBones_AnimationConfigWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(DragonBones.AnimationConfig), typeof(DragonBones.BaseObject));
		L.RegFunction("Clear", Clear);
		L.RegFunction("CopyFrom", CopyFrom);
		L.RegFunction("ContainsBoneMask", ContainsBoneMask);
		L.RegFunction("AddBoneMask", AddBoneMask);
		L.RegFunction("RemoveBoneMask", RemoveBoneMask);
		L.RegFunction("New", _CreateDragonBones_AnimationConfig);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("pauseFadeOut", get_pauseFadeOut, set_pauseFadeOut);
		L.RegVar("fadeOutMode", get_fadeOutMode, set_fadeOutMode);
		L.RegVar("fadeOutTweenType", get_fadeOutTweenType, set_fadeOutTweenType);
		L.RegVar("fadeOutTime", get_fadeOutTime, set_fadeOutTime);
		L.RegVar("pauseFadeIn", get_pauseFadeIn, set_pauseFadeIn);
		L.RegVar("actionEnabled", get_actionEnabled, set_actionEnabled);
		L.RegVar("additiveBlending", get_additiveBlending, set_additiveBlending);
		L.RegVar("displayControl", get_displayControl, set_displayControl);
		L.RegVar("resetToPose", get_resetToPose, set_resetToPose);
		L.RegVar("fadeInTweenType", get_fadeInTweenType, set_fadeInTweenType);
		L.RegVar("playTimes", get_playTimes, set_playTimes);
		L.RegVar("layer", get_layer, set_layer);
		L.RegVar("position", get_position, set_position);
		L.RegVar("duration", get_duration, set_duration);
		L.RegVar("timeScale", get_timeScale, set_timeScale);
		L.RegVar("weight", get_weight, set_weight);
		L.RegVar("fadeInTime", get_fadeInTime, set_fadeInTime);
		L.RegVar("autoFadeOutTime", get_autoFadeOutTime, set_autoFadeOutTime);
		L.RegVar("name", get_name, set_name);
		L.RegVar("animation", get_animation, set_animation);
		L.RegVar("group", get_group, set_group);
		L.RegVar("boneMask", get_boneMask, null);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateDragonBones_AnimationConfig(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 0)
			{
				DragonBones.AnimationConfig obj = new DragonBones.AnimationConfig();
				ToLua.PushObject(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: DragonBones.AnimationConfig.New");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Clear(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)ToLua.CheckObject<DragonBones.AnimationConfig>(L, 1);
			obj.Clear();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CopyFrom(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)ToLua.CheckObject<DragonBones.AnimationConfig>(L, 1);
			DragonBones.AnimationConfig arg0 = (DragonBones.AnimationConfig)ToLua.CheckObject<DragonBones.AnimationConfig>(L, 2);
			obj.CopyFrom(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ContainsBoneMask(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)ToLua.CheckObject<DragonBones.AnimationConfig>(L, 1);
			string arg0 = ToLua.CheckString(L, 2);
			bool o = obj.ContainsBoneMask(arg0);
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddBoneMask(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 3)
			{
				DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)ToLua.CheckObject<DragonBones.AnimationConfig>(L, 1);
				DragonBones.Armature arg0 = (DragonBones.Armature)ToLua.CheckObject<DragonBones.Armature>(L, 2);
				string arg1 = ToLua.CheckString(L, 3);
				obj.AddBoneMask(arg0, arg1);
				return 0;
			}
			else if (count == 4)
			{
				DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)ToLua.CheckObject<DragonBones.AnimationConfig>(L, 1);
				DragonBones.Armature arg0 = (DragonBones.Armature)ToLua.CheckObject<DragonBones.Armature>(L, 2);
				string arg1 = ToLua.CheckString(L, 3);
				bool arg2 = LuaDLL.luaL_checkboolean(L, 4);
				obj.AddBoneMask(arg0, arg1, arg2);
				return 0;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: DragonBones.AnimationConfig.AddBoneMask");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int RemoveBoneMask(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 3)
			{
				DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)ToLua.CheckObject<DragonBones.AnimationConfig>(L, 1);
				DragonBones.Armature arg0 = (DragonBones.Armature)ToLua.CheckObject<DragonBones.Armature>(L, 2);
				string arg1 = ToLua.CheckString(L, 3);
				obj.RemoveBoneMask(arg0, arg1);
				return 0;
			}
			else if (count == 4)
			{
				DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)ToLua.CheckObject<DragonBones.AnimationConfig>(L, 1);
				DragonBones.Armature arg0 = (DragonBones.Armature)ToLua.CheckObject<DragonBones.Armature>(L, 2);
				string arg1 = ToLua.CheckString(L, 3);
				bool arg2 = LuaDLL.luaL_checkboolean(L, 4);
				obj.RemoveBoneMask(arg0, arg1, arg2);
				return 0;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: DragonBones.AnimationConfig.RemoveBoneMask");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_pauseFadeOut(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			bool ret = obj.pauseFadeOut;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index pauseFadeOut on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_fadeOutMode(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			DragonBones.AnimationFadeOutMode ret = obj.fadeOutMode;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index fadeOutMode on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_fadeOutTweenType(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			DragonBones.TweenType ret = obj.fadeOutTweenType;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index fadeOutTweenType on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_fadeOutTime(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			float ret = obj.fadeOutTime;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index fadeOutTime on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_pauseFadeIn(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			bool ret = obj.pauseFadeIn;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index pauseFadeIn on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_actionEnabled(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			bool ret = obj.actionEnabled;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index actionEnabled on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_additiveBlending(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			bool ret = obj.additiveBlending;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index additiveBlending on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_displayControl(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			bool ret = obj.displayControl;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index displayControl on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_resetToPose(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			bool ret = obj.resetToPose;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index resetToPose on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_fadeInTweenType(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			DragonBones.TweenType ret = obj.fadeInTweenType;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index fadeInTweenType on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_playTimes(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			int ret = obj.playTimes;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index playTimes on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_layer(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			int ret = obj.layer;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index layer on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_position(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			float ret = obj.position;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index position on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_duration(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			float ret = obj.duration;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index duration on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_timeScale(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			float ret = obj.timeScale;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index timeScale on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_weight(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			float ret = obj.weight;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index weight on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_fadeInTime(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			float ret = obj.fadeInTime;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index fadeInTime on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_autoFadeOutTime(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			float ret = obj.autoFadeOutTime;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index autoFadeOutTime on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_name(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
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
	static int get_animation(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			string ret = obj.animation;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index animation on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_group(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			string ret = obj.group;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index group on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_boneMask(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			System.Collections.Generic.List<string> ret = obj.boneMask;
			ToLua.PushSealed(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index boneMask on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_pauseFadeOut(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.pauseFadeOut = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index pauseFadeOut on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_fadeOutMode(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			DragonBones.AnimationFadeOutMode arg0 = (DragonBones.AnimationFadeOutMode)ToLua.CheckObject(L, 2, typeof(DragonBones.AnimationFadeOutMode));
			obj.fadeOutMode = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index fadeOutMode on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_fadeOutTweenType(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			DragonBones.TweenType arg0 = (DragonBones.TweenType)ToLua.CheckObject(L, 2, typeof(DragonBones.TweenType));
			obj.fadeOutTweenType = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index fadeOutTweenType on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_fadeOutTime(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.fadeOutTime = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index fadeOutTime on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_pauseFadeIn(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.pauseFadeIn = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index pauseFadeIn on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_actionEnabled(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.actionEnabled = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index actionEnabled on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_additiveBlending(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.additiveBlending = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index additiveBlending on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_displayControl(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.displayControl = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index displayControl on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_resetToPose(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.resetToPose = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index resetToPose on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_fadeInTweenType(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			DragonBones.TweenType arg0 = (DragonBones.TweenType)ToLua.CheckObject(L, 2, typeof(DragonBones.TweenType));
			obj.fadeInTweenType = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index fadeInTweenType on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_playTimes(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.playTimes = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index playTimes on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_layer(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.layer = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index layer on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_position(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.position = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index position on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_duration(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.duration = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index duration on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_timeScale(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.timeScale = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index timeScale on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_weight(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.weight = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index weight on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_fadeInTime(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.fadeInTime = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index fadeInTime on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_autoFadeOutTime(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.autoFadeOutTime = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index autoFadeOutTime on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_name(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
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
	static int set_animation(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.animation = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index animation on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_group(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			DragonBones.AnimationConfig obj = (DragonBones.AnimationConfig)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.group = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index group on a nil value");
		}
	}
}

