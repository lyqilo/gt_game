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
    unsafe class LuaFramework_UnityWebPacket_Binding
    {
        public static void Register(ILRuntime.Runtime.Enviorment.AppDomain app)
        {
            BindingFlags flag = BindingFlags.Public | BindingFlags.Instance | BindingFlags.Static | BindingFlags.DeclaredOnly;
            MethodBase method;
            FieldInfo field;
            Type[] args;
            Type type = typeof(LuaFramework.UnityWebPacket);

            field = type.GetField("urlPath", flag);
            app.RegisterCLRFieldGetter(field, get_urlPath_0);
            app.RegisterCLRFieldSetter(field, set_urlPath_0);
            app.RegisterCLRFieldBinding(field, CopyToStack_urlPath_0, AssignFromStack_urlPath_0);
            field = type.GetField("localPath", flag);
            app.RegisterCLRFieldGetter(field, get_localPath_1);
            app.RegisterCLRFieldSetter(field, set_localPath_1);
            app.RegisterCLRFieldBinding(field, CopyToStack_localPath_1, AssignFromStack_localPath_1);
            field = type.GetField("size", flag);
            app.RegisterCLRFieldGetter(field, get_size_2);
            app.RegisterCLRFieldSetter(field, set_size_2);
            app.RegisterCLRFieldBinding(field, CopyToStack_size_2, AssignFromStack_size_2);
            field = type.GetField("func", flag);
            app.RegisterCLRFieldGetter(field, get_func_3);
            app.RegisterCLRFieldSetter(field, set_func_3);
            app.RegisterCLRFieldBinding(field, CopyToStack_func_3, AssignFromStack_func_3);

            args = new Type[]{};
            method = type.GetConstructor(flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, Ctor_0);

        }



        static object get_urlPath_0(ref object o)
        {
            return ((LuaFramework.UnityWebPacket)o).urlPath;
        }

        static StackObject* CopyToStack_urlPath_0(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.UnityWebPacket)o).urlPath;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_urlPath_0(ref object o, object v)
        {
            ((LuaFramework.UnityWebPacket)o).urlPath = (System.String)v;
        }

        static StackObject* AssignFromStack_urlPath_0(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.String @urlPath = (System.String)typeof(System.String).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            ((LuaFramework.UnityWebPacket)o).urlPath = @urlPath;
            return ptr_of_this_method;
        }

        static object get_localPath_1(ref object o)
        {
            return ((LuaFramework.UnityWebPacket)o).localPath;
        }

        static StackObject* CopyToStack_localPath_1(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.UnityWebPacket)o).localPath;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_localPath_1(ref object o, object v)
        {
            ((LuaFramework.UnityWebPacket)o).localPath = (System.String)v;
        }

        static StackObject* AssignFromStack_localPath_1(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.String @localPath = (System.String)typeof(System.String).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            ((LuaFramework.UnityWebPacket)o).localPath = @localPath;
            return ptr_of_this_method;
        }

        static object get_size_2(ref object o)
        {
            return ((LuaFramework.UnityWebPacket)o).size;
        }

        static StackObject* CopyToStack_size_2(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.UnityWebPacket)o).size;
            __ret->ObjectType = ObjectTypes.Long;
            *(ulong*)&__ret->Value = result_of_this_method;
            return __ret + 1;
        }

        static void set_size_2(ref object o, object v)
        {
            ((LuaFramework.UnityWebPacket)o).size = (System.UInt64)v;
        }

        static StackObject* AssignFromStack_size_2(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.UInt64 @size = *(ulong*)&ptr_of_this_method->Value;
            ((LuaFramework.UnityWebPacket)o).size = @size;
            return ptr_of_this_method;
        }

        static object get_func_3(ref object o)
        {
            return ((LuaFramework.UnityWebPacket)o).func;
        }

        static StackObject* CopyToStack_func_3(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.UnityWebPacket)o).func;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_func_3(ref object o, object v)
        {
            ((LuaFramework.UnityWebPacket)o).func = (System.Action<System.Single, System.Object>)v;
        }

        static StackObject* AssignFromStack_func_3(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action<System.Single, System.Object> @func = (System.Action<System.Single, System.Object>)typeof(System.Action<System.Single, System.Object>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.UnityWebPacket)o).func = @func;
            return ptr_of_this_method;
        }


        static StackObject* Ctor_0(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* __ret = ILIntepreter.Minus(__esp, 0);

            var result_of_this_method = new LuaFramework.UnityWebPacket();

            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }


    }
}
