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
    unsafe class LuaFramework_AppConst_Binding
    {
        public static void Register(ILRuntime.Runtime.Enviorment.AppDomain app)
        {
            BindingFlags flag = BindingFlags.Public | BindingFlags.Instance | BindingFlags.Static | BindingFlags.DeclaredOnly;
            MethodBase method;
            FieldInfo field;
            Type[] args;
            Type type = typeof(LuaFramework.AppConst);
            args = new Type[]{};
            method = type.GetMethod("get_DNSUrl", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, get_DNSUrl_0);

            field = type.GetField("csConfiger", flag);
            app.RegisterCLRFieldGetter(field, get_csConfiger_0);
            app.RegisterCLRFieldSetter(field, set_csConfiger_0);
            app.RegisterCLRFieldBinding(field, CopyToStack_csConfiger_0, AssignFromStack_csConfiger_0);
            field = type.GetField("gameValueConfiger", flag);
            app.RegisterCLRFieldGetter(field, get_gameValueConfiger_1);
            app.RegisterCLRFieldSetter(field, set_gameValueConfiger_1);
            app.RegisterCLRFieldBinding(field, CopyToStack_gameValueConfiger_1, AssignFromStack_gameValueConfiger_1);
            field = type.GetField("WebUrl", flag);
            app.RegisterCLRFieldGetter(field, get_WebUrl_2);
            app.RegisterCLRFieldSetter(field, set_WebUrl_2);
            app.RegisterCLRFieldBinding(field, CopyToStack_WebUrl_2, AssignFromStack_WebUrl_2);
            field = type.GetField("valueConfiger", flag);
            app.RegisterCLRFieldGetter(field, get_valueConfiger_3);
            app.RegisterCLRFieldSetter(field, set_valueConfiger_3);
            app.RegisterCLRFieldBinding(field, CopyToStack_valueConfiger_3, AssignFromStack_valueConfiger_3);


        }


        static StackObject* get_DNSUrl_0(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* __ret = ILIntepreter.Minus(__esp, 0);


            var result_of_this_method = LuaFramework.AppConst.DNSUrl;

            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }


        static object get_csConfiger_0(ref object o)
        {
            return LuaFramework.AppConst.csConfiger;
        }

        static StackObject* CopyToStack_csConfiger_0(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = LuaFramework.AppConst.csConfiger;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_csConfiger_0(ref object o, object v)
        {
            LuaFramework.AppConst.csConfiger = (LuaFramework.CSConfiger)v;
        }

        static StackObject* AssignFromStack_csConfiger_0(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            LuaFramework.CSConfiger @csConfiger = (LuaFramework.CSConfiger)typeof(LuaFramework.CSConfiger).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            LuaFramework.AppConst.csConfiger = @csConfiger;
            return ptr_of_this_method;
        }

        static object get_gameValueConfiger_1(ref object o)
        {
            return LuaFramework.AppConst.gameValueConfiger;
        }

        static StackObject* CopyToStack_gameValueConfiger_1(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = LuaFramework.AppConst.gameValueConfiger;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_gameValueConfiger_1(ref object o, object v)
        {
            LuaFramework.AppConst.gameValueConfiger = (LuaFramework.ValueConfiger)v;
        }

        static StackObject* AssignFromStack_gameValueConfiger_1(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            LuaFramework.ValueConfiger @gameValueConfiger = (LuaFramework.ValueConfiger)typeof(LuaFramework.ValueConfiger).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)16);
            LuaFramework.AppConst.gameValueConfiger = @gameValueConfiger;
            return ptr_of_this_method;
        }

        static object get_WebUrl_2(ref object o)
        {
            return LuaFramework.AppConst.WebUrl;
        }

        static StackObject* CopyToStack_WebUrl_2(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = LuaFramework.AppConst.WebUrl;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_WebUrl_2(ref object o, object v)
        {
            LuaFramework.AppConst.WebUrl = (System.String)v;
        }

        static StackObject* AssignFromStack_WebUrl_2(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.String @WebUrl = (System.String)typeof(System.String).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            LuaFramework.AppConst.WebUrl = @WebUrl;
            return ptr_of_this_method;
        }

        static object get_valueConfiger_3(ref object o)
        {
            return LuaFramework.AppConst.valueConfiger;
        }

        static StackObject* CopyToStack_valueConfiger_3(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = LuaFramework.AppConst.valueConfiger;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_valueConfiger_3(ref object o, object v)
        {
            LuaFramework.AppConst.valueConfiger = (LuaFramework.ValueConfiger)v;
        }

        static StackObject* AssignFromStack_valueConfiger_3(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            LuaFramework.ValueConfiger @valueConfiger = (LuaFramework.ValueConfiger)typeof(LuaFramework.ValueConfiger).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)16);
            LuaFramework.AppConst.valueConfiger = @valueConfiger;
            return ptr_of_this_method;
        }



    }
}
