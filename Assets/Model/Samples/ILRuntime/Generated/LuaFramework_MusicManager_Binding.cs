using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Runtime.InteropServices;

using ILRuntime.CLR.TypeSystem;
using ILRuntime.CLR.Method;
using ILRuntime.Runtime.Enviorment;
using ILRuntime.Runtime.Intepreter;
using ILRuntime.Runtime.Stack;
using ILRuntime.Reflection;
using ILRuntime.CLR.Utils;
#if DEBUG && !DISABLE_ILRUNTIME_DEBUG
using AutoList = System.Collections.Generic.List<object>;
#else
using AutoList = ILRuntime.Other.UncheckedList<object>;
#endif
namespace ILRuntime.Runtime.Generated
{
    unsafe class LuaFramework_MusicManager_Binding
    {
        public static void Register(ILRuntime.Runtime.Enviorment.AppDomain app)
        {
            BindingFlags flag = BindingFlags.Public | BindingFlags.Instance | BindingFlags.Static | BindingFlags.DeclaredOnly;
            MethodBase method;
            FieldInfo field;
            Type[] args;
            Type type = typeof(LuaFramework.MusicManager);
            args = new Type[]{typeof(System.Boolean), typeof(System.Boolean)};
            method = type.GetMethod("SetPlaySM", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, SetPlaySM_0);
            args = new Type[]{};
            method = type.GetMethod("KillAllSoundEffect", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, KillAllSoundEffect_1);
            args = new Type[]{};
            method = type.GetMethod("GetIsPlaySV", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, GetIsPlaySV_2);
            args = new Type[]{};
            method = type.GetMethod("GetIsPlayMV", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, GetIsPlayMV_3);
            args = new Type[]{typeof(System.Single), typeof(System.Single)};
            method = type.GetMethod("SetValue", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, SetValue_4);

            field = type.GetField("isPlayMV", flag);
            app.RegisterCLRFieldGetter(field, get_isPlayMV_0);
            app.RegisterCLRFieldSetter(field, set_isPlayMV_0);
            app.RegisterCLRFieldBinding(field, CopyToStack_isPlayMV_0, AssignFromStack_isPlayMV_0);
            field = type.GetField("isPlaySV", flag);
            app.RegisterCLRFieldGetter(field, get_isPlaySV_1);
            app.RegisterCLRFieldSetter(field, set_isPlaySV_1);
            app.RegisterCLRFieldBinding(field, CopyToStack_isPlaySV_1, AssignFromStack_isPlaySV_1);
            field = type.GetField("musicVolume", flag);
            app.RegisterCLRFieldGetter(field, get_musicVolume_2);
            app.RegisterCLRFieldSetter(field, set_musicVolume_2);
            app.RegisterCLRFieldBinding(field, CopyToStack_musicVolume_2, AssignFromStack_musicVolume_2);
            field = type.GetField("soundVolume", flag);
            app.RegisterCLRFieldGetter(field, get_soundVolume_3);
            app.RegisterCLRFieldSetter(field, set_soundVolume_3);
            app.RegisterCLRFieldBinding(field, CopyToStack_soundVolume_3, AssignFromStack_soundVolume_3);


        }


        static StackObject* SetPlaySM_0(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 3);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            System.Boolean @mv = ptr_of_this_method->Value == 1;

            ptr_of_this_method = ILIntepreter.Minus(__esp, 2);
            System.Boolean @sv = ptr_of_this_method->Value == 1;

            ptr_of_this_method = ILIntepreter.Minus(__esp, 3);
            LuaFramework.MusicManager instance_of_this_method = (LuaFramework.MusicManager)typeof(LuaFramework.MusicManager).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);

            instance_of_this_method.SetPlaySM(@sv, @mv);

            return __ret;
        }

        static StackObject* KillAllSoundEffect_1(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 1);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            LuaFramework.MusicManager instance_of_this_method = (LuaFramework.MusicManager)typeof(LuaFramework.MusicManager).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);

            instance_of_this_method.KillAllSoundEffect();

            return __ret;
        }

        static StackObject* GetIsPlaySV_2(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 1);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            LuaFramework.MusicManager instance_of_this_method = (LuaFramework.MusicManager)typeof(LuaFramework.MusicManager).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);

            var result_of_this_method = instance_of_this_method.GetIsPlaySV();

            __ret->ObjectType = ObjectTypes.Integer;
            __ret->Value = result_of_this_method ? 1 : 0;
            return __ret + 1;
        }

        static StackObject* GetIsPlayMV_3(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 1);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            LuaFramework.MusicManager instance_of_this_method = (LuaFramework.MusicManager)typeof(LuaFramework.MusicManager).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);

            var result_of_this_method = instance_of_this_method.GetIsPlayMV();

            __ret->ObjectType = ObjectTypes.Integer;
            __ret->Value = result_of_this_method ? 1 : 0;
            return __ret + 1;
        }

        static StackObject* SetValue_4(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 3);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            System.Single @mv = *(float*)&ptr_of_this_method->Value;

            ptr_of_this_method = ILIntepreter.Minus(__esp, 2);
            System.Single @sv = *(float*)&ptr_of_this_method->Value;

            ptr_of_this_method = ILIntepreter.Minus(__esp, 3);
            LuaFramework.MusicManager instance_of_this_method = (LuaFramework.MusicManager)typeof(LuaFramework.MusicManager).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);

            instance_of_this_method.SetValue(@sv, @mv);

            return __ret;
        }


        static object get_isPlayMV_0(ref object o)
        {
            return LuaFramework.MusicManager.isPlayMV;
        }

        static StackObject* CopyToStack_isPlayMV_0(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = LuaFramework.MusicManager.isPlayMV;
            __ret->ObjectType = ObjectTypes.Integer;
            __ret->Value = result_of_this_method ? 1 : 0;
            return __ret + 1;
        }

        static void set_isPlayMV_0(ref object o, object v)
        {
            LuaFramework.MusicManager.isPlayMV = (System.Boolean)v;
        }

        static StackObject* AssignFromStack_isPlayMV_0(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Boolean @isPlayMV = ptr_of_this_method->Value == 1;
            LuaFramework.MusicManager.isPlayMV = @isPlayMV;
            return ptr_of_this_method;
        }

        static object get_isPlaySV_1(ref object o)
        {
            return LuaFramework.MusicManager.isPlaySV;
        }

        static StackObject* CopyToStack_isPlaySV_1(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = LuaFramework.MusicManager.isPlaySV;
            __ret->ObjectType = ObjectTypes.Integer;
            __ret->Value = result_of_this_method ? 1 : 0;
            return __ret + 1;
        }

        static void set_isPlaySV_1(ref object o, object v)
        {
            LuaFramework.MusicManager.isPlaySV = (System.Boolean)v;
        }

        static StackObject* AssignFromStack_isPlaySV_1(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Boolean @isPlaySV = ptr_of_this_method->Value == 1;
            LuaFramework.MusicManager.isPlaySV = @isPlaySV;
            return ptr_of_this_method;
        }

        static object get_musicVolume_2(ref object o)
        {
            return LuaFramework.MusicManager.musicVolume;
        }

        static StackObject* CopyToStack_musicVolume_2(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = LuaFramework.MusicManager.musicVolume;
            __ret->ObjectType = ObjectTypes.Float;
            *(float*)&__ret->Value = result_of_this_method;
            return __ret + 1;
        }

        static void set_musicVolume_2(ref object o, object v)
        {
            LuaFramework.MusicManager.musicVolume = (System.Single)v;
        }

        static StackObject* AssignFromStack_musicVolume_2(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Single @musicVolume = *(float*)&ptr_of_this_method->Value;
            LuaFramework.MusicManager.musicVolume = @musicVolume;
            return ptr_of_this_method;
        }

        static object get_soundVolume_3(ref object o)
        {
            return LuaFramework.MusicManager.soundVolume;
        }

        static StackObject* CopyToStack_soundVolume_3(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = LuaFramework.MusicManager.soundVolume;
            __ret->ObjectType = ObjectTypes.Float;
            *(float*)&__ret->Value = result_of_this_method;
            return __ret + 1;
        }

        static void set_soundVolume_3(ref object o, object v)
        {
            LuaFramework.MusicManager.soundVolume = (System.Single)v;
        }

        static StackObject* AssignFromStack_soundVolume_3(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Single @soundVolume = *(float*)&ptr_of_this_method->Value;
            LuaFramework.MusicManager.soundVolume = @soundVolume;
            return ptr_of_this_method;
        }



    }
}
