﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class DragonBones_ActionTypeWrap
{
	public static void Register(LuaState L)
	{
		L.BeginEnum(typeof(DragonBones.ActionType));
		L.RegVar("Play", get_Play, null);
		L.RegVar("Frame", get_Frame, null);
		L.RegVar("Sound", get_Sound, null);
		L.RegFunction("IntToEnum", IntToEnum);
		L.EndEnum();
		TypeTraits<DragonBones.ActionType>.Check = CheckType;
		StackTraits<DragonBones.ActionType>.Push = Push;
	}

	static void Push(IntPtr L, DragonBones.ActionType arg)
	{
		ToLua.Push(L, arg);
	}

	static bool CheckType(IntPtr L, int pos)
	{
		return TypeChecker.CheckEnumType(typeof(DragonBones.ActionType), L, pos);
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Play(IntPtr L)
	{
		ToLua.Push(L, DragonBones.ActionType.Play);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Frame(IntPtr L)
	{
		ToLua.Push(L, DragonBones.ActionType.Frame);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Sound(IntPtr L)
	{
		ToLua.Push(L, DragonBones.ActionType.Sound);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IntToEnum(IntPtr L)
	{
		int arg0 = (int)LuaDLL.lua_tonumber(L, 1);
		DragonBones.ActionType o = (DragonBones.ActionType)arg0;
		ToLua.Push(L, o);
		return 1;
	}
}

