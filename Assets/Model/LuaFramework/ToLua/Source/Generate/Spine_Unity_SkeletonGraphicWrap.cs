﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using DG.Tweening;
using LuaInterface;

public class Spine_Unity_SkeletonGraphicWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(Spine.Unity.SkeletonGraphic), typeof(UnityEngine.UI.MaskableGraphic));
		L.RegFunction("NewSkeletonGraphicGameObject", NewSkeletonGraphicGameObject);
		L.RegFunction("AddSkeletonGraphicComponent", AddSkeletonGraphicComponent);
		L.RegFunction("Rebuild", Rebuild);
		L.RegFunction("Update", Update);
		L.RegFunction("LateUpdate", LateUpdate);
		L.RegFunction("GetLastMesh", GetLastMesh);
		L.RegFunction("Clear", Clear);
		L.RegFunction("Initialize", Initialize);
		L.RegFunction("UpdateMesh", UpdateMesh);
		L.RegFunction("DOBlendableColor", DOBlendableColor);
		L.RegFunction("DOFade", DOFade);
		L.RegFunction("DOColor", DOColor);
		L.RegFunction("DOTogglePause", DOTogglePause);
		L.RegFunction("DOSmoothRewind", DOSmoothRewind);
		L.RegFunction("DORewind", DORewind);
		L.RegFunction("DORestart", DORestart);
		L.RegFunction("DOPlayForward", DOPlayForward);
		L.RegFunction("DOPlayBackwards", DOPlayBackwards);
		L.RegFunction("DOPlay", DOPlay);
		L.RegFunction("DOPause", DOPause);
		L.RegFunction("DOGoto", DOGoto);
		L.RegFunction("DOFlip", DOFlip);
		L.RegFunction("DOKill", DOKill);
		L.RegFunction("DOComplete", DOComplete);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("skeletonDataAsset", get_skeletonDataAsset, set_skeletonDataAsset);
		L.RegVar("initialSkinName", get_initialSkinName, set_initialSkinName);
		L.RegVar("initialFlipX", get_initialFlipX, set_initialFlipX);
		L.RegVar("initialFlipY", get_initialFlipY, set_initialFlipY);
		L.RegVar("startingAnimation", get_startingAnimation, set_startingAnimation);
		L.RegVar("startingLoop", get_startingLoop, set_startingLoop);
		L.RegVar("timeScale", get_timeScale, set_timeScale);
		L.RegVar("freeze", get_freeze, set_freeze);
		L.RegVar("unscaledTime", get_unscaledTime, set_unscaledTime);
		L.RegVar("SkeletonDataAsset", get_SkeletonDataAsset, null);
		L.RegVar("OverrideTexture", get_OverrideTexture, set_OverrideTexture);
		L.RegVar("mainTexture", get_mainTexture, null);
		L.RegVar("Skeleton", get_Skeleton, null);
		L.RegVar("SkeletonData", get_SkeletonData, null);
		L.RegVar("IsValid", get_IsValid, null);
		L.RegVar("AnimationState", get_AnimationState, null);
		L.RegVar("MeshGenerator", get_MeshGenerator, null);
		L.RegVar("UpdateLocal", get_UpdateLocal, set_UpdateLocal);
		L.RegVar("UpdateWorld", get_UpdateWorld, set_UpdateWorld);
		L.RegVar("UpdateComplete", get_UpdateComplete, set_UpdateComplete);
		L.RegVar("OnPostProcessVertices", get_OnPostProcessVertices, set_OnPostProcessVertices);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int NewSkeletonGraphicGameObject(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			Spine.Unity.SkeletonDataAsset arg0 = (Spine.Unity.SkeletonDataAsset)ToLua.CheckObject<Spine.Unity.SkeletonDataAsset>(L, 1);
			UnityEngine.Transform arg1 = (UnityEngine.Transform)ToLua.CheckObject<UnityEngine.Transform>(L, 2);
			UnityEngine.Material arg2 = (UnityEngine.Material)ToLua.CheckObject<UnityEngine.Material>(L, 3);
			Spine.Unity.SkeletonGraphic o = Spine.Unity.SkeletonGraphic.NewSkeletonGraphicGameObject(arg0, arg1, arg2);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddSkeletonGraphicComponent(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			UnityEngine.GameObject arg0 = (UnityEngine.GameObject)ToLua.CheckObject(L, 1, typeof(UnityEngine.GameObject));
			Spine.Unity.SkeletonDataAsset arg1 = (Spine.Unity.SkeletonDataAsset)ToLua.CheckObject<Spine.Unity.SkeletonDataAsset>(L, 2);
			UnityEngine.Material arg2 = (UnityEngine.Material)ToLua.CheckObject<UnityEngine.Material>(L, 3);
			Spine.Unity.SkeletonGraphic o = Spine.Unity.SkeletonGraphic.AddSkeletonGraphicComponent(arg0, arg1, arg2);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Rebuild(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject<Spine.Unity.SkeletonGraphic>(L, 1);
			UnityEngine.UI.CanvasUpdate arg0 = (UnityEngine.UI.CanvasUpdate)ToLua.CheckObject(L, 2, typeof(UnityEngine.UI.CanvasUpdate));
			obj.Rebuild(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Update(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 1)
			{
				Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject<Spine.Unity.SkeletonGraphic>(L, 1);
				obj.Update();
				return 0;
			}
			else if (count == 2)
			{
				Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject<Spine.Unity.SkeletonGraphic>(L, 1);
				float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
				obj.Update(arg0);
				return 0;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: Spine.Unity.SkeletonGraphic.Update");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LateUpdate(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject<Spine.Unity.SkeletonGraphic>(L, 1);
			obj.LateUpdate();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetLastMesh(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject<Spine.Unity.SkeletonGraphic>(L, 1);
			UnityEngine.Mesh o = obj.GetLastMesh();
			ToLua.PushSealed(L, o);
			return 1;
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
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject<Spine.Unity.SkeletonGraphic>(L, 1);
			obj.Clear();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Initialize(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject<Spine.Unity.SkeletonGraphic>(L, 1);
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.Initialize(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UpdateMesh(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject<Spine.Unity.SkeletonGraphic>(L, 1);
			obj.UpdateMesh();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOBlendableColor(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject<Spine.Unity.SkeletonGraphic>(L, 1);
			UnityEngine.Color arg0 = ToLua.ToColor(L, 2);
			float arg1 = (float)LuaDLL.luaL_checknumber(L, 3);
			DG.Tweening.Tweener o = obj.DOBlendableColor(arg0, arg1);
			ToLua.PushObject(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOFade(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject<Spine.Unity.SkeletonGraphic>(L, 1);
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			float arg1 = (float)LuaDLL.luaL_checknumber(L, 3);
			DG.Tweening.Core.TweenerCore<UnityEngine.Color,UnityEngine.Color,DG.Tweening.Plugins.Options.ColorOptions> o = obj.DOFade(arg0, arg1);
			ToLua.PushObject(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOColor(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject<Spine.Unity.SkeletonGraphic>(L, 1);
			UnityEngine.Color arg0 = ToLua.ToColor(L, 2);
			float arg1 = (float)LuaDLL.luaL_checknumber(L, 3);
			DG.Tweening.Core.TweenerCore<UnityEngine.Color,UnityEngine.Color,DG.Tweening.Plugins.Options.ColorOptions> o = obj.DOColor(arg0, arg1);
			ToLua.PushObject(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOTogglePause(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject<Spine.Unity.SkeletonGraphic>(L, 1);
			int o = obj.DOTogglePause();
			LuaDLL.lua_pushinteger(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOSmoothRewind(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject<Spine.Unity.SkeletonGraphic>(L, 1);
			int o = obj.DOSmoothRewind();
			LuaDLL.lua_pushinteger(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DORewind(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 1)
			{
				Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject<Spine.Unity.SkeletonGraphic>(L, 1);
				int o = obj.DORewind();
				LuaDLL.lua_pushinteger(L, o);
				return 1;
			}
			else if (count == 2)
			{
				Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject<Spine.Unity.SkeletonGraphic>(L, 1);
				bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
				int o = obj.DORewind(arg0);
				LuaDLL.lua_pushinteger(L, o);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: Spine.Unity.SkeletonGraphic.DORewind");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DORestart(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 1)
			{
				Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject<Spine.Unity.SkeletonGraphic>(L, 1);
				int o = obj.DORestart();
				LuaDLL.lua_pushinteger(L, o);
				return 1;
			}
			else if (count == 2)
			{
				Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject<Spine.Unity.SkeletonGraphic>(L, 1);
				bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
				int o = obj.DORestart(arg0);
				LuaDLL.lua_pushinteger(L, o);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: Spine.Unity.SkeletonGraphic.DORestart");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOPlayForward(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject<Spine.Unity.SkeletonGraphic>(L, 1);
			int o = obj.DOPlayForward();
			LuaDLL.lua_pushinteger(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOPlayBackwards(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject<Spine.Unity.SkeletonGraphic>(L, 1);
			int o = obj.DOPlayBackwards();
			LuaDLL.lua_pushinteger(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOPlay(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject<Spine.Unity.SkeletonGraphic>(L, 1);
			int o = obj.DOPlay();
			LuaDLL.lua_pushinteger(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOPause(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject<Spine.Unity.SkeletonGraphic>(L, 1);
			int o = obj.DOPause();
			LuaDLL.lua_pushinteger(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOGoto(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 2)
			{
				Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject<Spine.Unity.SkeletonGraphic>(L, 1);
				float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
				int o = obj.DOGoto(arg0);
				LuaDLL.lua_pushinteger(L, o);
				return 1;
			}
			else if (count == 3)
			{
				Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject<Spine.Unity.SkeletonGraphic>(L, 1);
				float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
				bool arg1 = LuaDLL.luaL_checkboolean(L, 3);
				int o = obj.DOGoto(arg0, arg1);
				LuaDLL.lua_pushinteger(L, o);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: Spine.Unity.SkeletonGraphic.DOGoto");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOFlip(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject<Spine.Unity.SkeletonGraphic>(L, 1);
			int o = obj.DOFlip();
			LuaDLL.lua_pushinteger(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOKill(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 1)
			{
				Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject<Spine.Unity.SkeletonGraphic>(L, 1);
				int o = obj.DOKill();
				LuaDLL.lua_pushinteger(L, o);
				return 1;
			}
			else if (count == 2)
			{
				Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject<Spine.Unity.SkeletonGraphic>(L, 1);
				bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
				int o = obj.DOKill(arg0);
				LuaDLL.lua_pushinteger(L, o);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: Spine.Unity.SkeletonGraphic.DOKill");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DOComplete(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 1)
			{
				Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject<Spine.Unity.SkeletonGraphic>(L, 1);
				int o = obj.DOComplete();
				LuaDLL.lua_pushinteger(L, o);
				return 1;
			}
			else if (count == 2)
			{
				Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject<Spine.Unity.SkeletonGraphic>(L, 1);
				bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
				int o = obj.DOComplete(arg0);
				LuaDLL.lua_pushinteger(L, o);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: Spine.Unity.SkeletonGraphic.DOComplete");
			}
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
	static int get_skeletonDataAsset(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)o;
			Spine.Unity.SkeletonDataAsset ret = obj.skeletonDataAsset;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index skeletonDataAsset on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_initialSkinName(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)o;
			string ret = obj.initialSkinName;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index initialSkinName on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_initialFlipX(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)o;
			bool ret = obj.initialFlipX;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index initialFlipX on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_initialFlipY(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)o;
			bool ret = obj.initialFlipY;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index initialFlipY on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_startingAnimation(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)o;
			string ret = obj.startingAnimation;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index startingAnimation on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_startingLoop(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)o;
			bool ret = obj.startingLoop;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index startingLoop on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_timeScale(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)o;
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
	static int get_freeze(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)o;
			bool ret = obj.freeze;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index freeze on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_unscaledTime(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)o;
			bool ret = obj.unscaledTime;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index unscaledTime on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_SkeletonDataAsset(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)o;
			Spine.Unity.SkeletonDataAsset ret = obj.SkeletonDataAsset;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index SkeletonDataAsset on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_OverrideTexture(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)o;
			UnityEngine.Texture ret = obj.OverrideTexture;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index OverrideTexture on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_mainTexture(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)o;
			UnityEngine.Texture ret = obj.mainTexture;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index mainTexture on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Skeleton(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)o;
			Spine.Skeleton ret = obj.Skeleton;
			ToLua.PushObject(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index Skeleton on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_SkeletonData(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)o;
			Spine.SkeletonData ret = obj.SkeletonData;
			ToLua.PushObject(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index SkeletonData on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_IsValid(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)o;
			bool ret = obj.IsValid;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index IsValid on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_AnimationState(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)o;
			Spine.AnimationState ret = obj.AnimationState;
			ToLua.PushObject(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index AnimationState on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_MeshGenerator(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)o;
			Spine.Unity.MeshGenerator ret = obj.MeshGenerator;
			ToLua.PushObject(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index MeshGenerator on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_UpdateLocal(IntPtr L)
	{
		ToLua.Push(L, new EventObject(typeof(Spine.Unity.UpdateBonesDelegate)));
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_UpdateWorld(IntPtr L)
	{
		ToLua.Push(L, new EventObject(typeof(Spine.Unity.UpdateBonesDelegate)));
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_UpdateComplete(IntPtr L)
	{
		ToLua.Push(L, new EventObject(typeof(Spine.Unity.UpdateBonesDelegate)));
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_OnPostProcessVertices(IntPtr L)
	{
		ToLua.Push(L, new EventObject(typeof(Spine.Unity.MeshGeneratorDelegate)));
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_skeletonDataAsset(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)o;
			Spine.Unity.SkeletonDataAsset arg0 = (Spine.Unity.SkeletonDataAsset)ToLua.CheckObject<Spine.Unity.SkeletonDataAsset>(L, 2);
			obj.skeletonDataAsset = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index skeletonDataAsset on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_initialSkinName(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.initialSkinName = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index initialSkinName on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_initialFlipX(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.initialFlipX = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index initialFlipX on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_initialFlipY(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.initialFlipY = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index initialFlipY on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_startingAnimation(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.startingAnimation = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index startingAnimation on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_startingLoop(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.startingLoop = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index startingLoop on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_timeScale(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)o;
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
	static int set_freeze(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.freeze = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index freeze on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_unscaledTime(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.unscaledTime = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index unscaledTime on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_OverrideTexture(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)o;
			UnityEngine.Texture arg0 = (UnityEngine.Texture)ToLua.CheckObject<UnityEngine.Texture>(L, 2);
			obj.OverrideTexture = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index OverrideTexture on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_UpdateLocal(IntPtr L)
	{
		try
		{
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject(L, 1, typeof(Spine.Unity.SkeletonGraphic));
			EventObject arg0 = null;

			if (LuaDLL.lua_isuserdata(L, 2) != 0)
			{
				arg0 = (EventObject)ToLua.ToObject(L, 2);
			}
			else
			{
				return LuaDLL.luaL_throw(L, "The event 'Spine.Unity.SkeletonGraphic.UpdateLocal' can only appear on the left hand side of += or -= when used outside of the type 'Spine.Unity.SkeletonGraphic'");
			}

			if (arg0.op == EventOp.Add)
			{
				Spine.Unity.UpdateBonesDelegate ev = (Spine.Unity.UpdateBonesDelegate)arg0.func;
				obj.UpdateLocal += ev;
			}
			else if (arg0.op == EventOp.Sub)
			{
				Spine.Unity.UpdateBonesDelegate ev = (Spine.Unity.UpdateBonesDelegate)arg0.func;
				obj.UpdateLocal -= ev;
			}

			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_UpdateWorld(IntPtr L)
	{
		try
		{
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject(L, 1, typeof(Spine.Unity.SkeletonGraphic));
			EventObject arg0 = null;

			if (LuaDLL.lua_isuserdata(L, 2) != 0)
			{
				arg0 = (EventObject)ToLua.ToObject(L, 2);
			}
			else
			{
				return LuaDLL.luaL_throw(L, "The event 'Spine.Unity.SkeletonGraphic.UpdateWorld' can only appear on the left hand side of += or -= when used outside of the type 'Spine.Unity.SkeletonGraphic'");
			}

			if (arg0.op == EventOp.Add)
			{
				Spine.Unity.UpdateBonesDelegate ev = (Spine.Unity.UpdateBonesDelegate)arg0.func;
				obj.UpdateWorld += ev;
			}
			else if (arg0.op == EventOp.Sub)
			{
				Spine.Unity.UpdateBonesDelegate ev = (Spine.Unity.UpdateBonesDelegate)arg0.func;
				obj.UpdateWorld -= ev;
			}

			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_UpdateComplete(IntPtr L)
	{
		try
		{
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject(L, 1, typeof(Spine.Unity.SkeletonGraphic));
			EventObject arg0 = null;

			if (LuaDLL.lua_isuserdata(L, 2) != 0)
			{
				arg0 = (EventObject)ToLua.ToObject(L, 2);
			}
			else
			{
				return LuaDLL.luaL_throw(L, "The event 'Spine.Unity.SkeletonGraphic.UpdateComplete' can only appear on the left hand side of += or -= when used outside of the type 'Spine.Unity.SkeletonGraphic'");
			}

			if (arg0.op == EventOp.Add)
			{
				Spine.Unity.UpdateBonesDelegate ev = (Spine.Unity.UpdateBonesDelegate)arg0.func;
				obj.UpdateComplete += ev;
			}
			else if (arg0.op == EventOp.Sub)
			{
				Spine.Unity.UpdateBonesDelegate ev = (Spine.Unity.UpdateBonesDelegate)arg0.func;
				obj.UpdateComplete -= ev;
			}

			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_OnPostProcessVertices(IntPtr L)
	{
		try
		{
			Spine.Unity.SkeletonGraphic obj = (Spine.Unity.SkeletonGraphic)ToLua.CheckObject(L, 1, typeof(Spine.Unity.SkeletonGraphic));
			EventObject arg0 = null;

			if (LuaDLL.lua_isuserdata(L, 2) != 0)
			{
				arg0 = (EventObject)ToLua.ToObject(L, 2);
			}
			else
			{
				return LuaDLL.luaL_throw(L, "The event 'Spine.Unity.SkeletonGraphic.OnPostProcessVertices' can only appear on the left hand side of += or -= when used outside of the type 'Spine.Unity.SkeletonGraphic'");
			}

			if (arg0.op == EventOp.Add)
			{
				Spine.Unity.MeshGeneratorDelegate ev = (Spine.Unity.MeshGeneratorDelegate)arg0.func;
				obj.OnPostProcessVertices += ev;
			}
			else if (arg0.op == EventOp.Sub)
			{
				Spine.Unity.MeshGeneratorDelegate ev = (Spine.Unity.MeshGeneratorDelegate)arg0.func;
				obj.OnPostProcessVertices -= ev;
			}

			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

