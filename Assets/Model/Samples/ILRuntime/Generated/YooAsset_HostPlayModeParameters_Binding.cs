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
    unsafe class YooAsset_HostPlayModeParameters_Binding
    {
        public static void Register(ILRuntime.Runtime.Enviorment.AppDomain app)
        {
            BindingFlags flag = BindingFlags.Public | BindingFlags.Instance | BindingFlags.Static | BindingFlags.DeclaredOnly;
            MethodBase method;
            FieldInfo field;
            Type[] args;
            Type type = typeof(YooAsset.HostPlayModeParameters);

            field = type.GetField("QueryServices", flag);
            app.RegisterCLRFieldGetter(field, get_QueryServices_0);
            app.RegisterCLRFieldSetter(field, set_QueryServices_0);
            app.RegisterCLRFieldBinding(field, CopyToStack_QueryServices_0, AssignFromStack_QueryServices_0);
            field = type.GetField("DefaultHostServer", flag);
            app.RegisterCLRFieldGetter(field, get_DefaultHostServer_1);
            app.RegisterCLRFieldSetter(field, set_DefaultHostServer_1);
            app.RegisterCLRFieldBinding(field, CopyToStack_DefaultHostServer_1, AssignFromStack_DefaultHostServer_1);
            field = type.GetField("FallbackHostServer", flag);
            app.RegisterCLRFieldGetter(field, get_FallbackHostServer_2);
            app.RegisterCLRFieldSetter(field, set_FallbackHostServer_2);
            app.RegisterCLRFieldBinding(field, CopyToStack_FallbackHostServer_2, AssignFromStack_FallbackHostServer_2);

            args = new Type[]{};
            method = type.GetConstructor(flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, Ctor_0);

        }



        static object get_QueryServices_0(ref object o)
        {
            return ((YooAsset.HostPlayModeParameters)o).QueryServices;
        }

        static StackObject* CopyToStack_QueryServices_0(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((YooAsset.HostPlayModeParameters)o).QueryServices;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_QueryServices_0(ref object o, object v)
        {
            ((YooAsset.HostPlayModeParameters)o).QueryServices = (YooAsset.IQueryServices)v;
        }

        static StackObject* AssignFromStack_QueryServices_0(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            YooAsset.IQueryServices @QueryServices = (YooAsset.IQueryServices)typeof(YooAsset.IQueryServices).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            ((YooAsset.HostPlayModeParameters)o).QueryServices = @QueryServices;
            return ptr_of_this_method;
        }

        static object get_DefaultHostServer_1(ref object o)
        {
            return ((YooAsset.HostPlayModeParameters)o).DefaultHostServer;
        }

        static StackObject* CopyToStack_DefaultHostServer_1(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((YooAsset.HostPlayModeParameters)o).DefaultHostServer;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_DefaultHostServer_1(ref object o, object v)
        {
            ((YooAsset.HostPlayModeParameters)o).DefaultHostServer = (System.String)v;
        }

        static StackObject* AssignFromStack_DefaultHostServer_1(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.String @DefaultHostServer = (System.String)typeof(System.String).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            ((YooAsset.HostPlayModeParameters)o).DefaultHostServer = @DefaultHostServer;
            return ptr_of_this_method;
        }

        static object get_FallbackHostServer_2(ref object o)
        {
            return ((YooAsset.HostPlayModeParameters)o).FallbackHostServer;
        }

        static StackObject* CopyToStack_FallbackHostServer_2(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((YooAsset.HostPlayModeParameters)o).FallbackHostServer;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_FallbackHostServer_2(ref object o, object v)
        {
            ((YooAsset.HostPlayModeParameters)o).FallbackHostServer = (System.String)v;
        }

        static StackObject* AssignFromStack_FallbackHostServer_2(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.String @FallbackHostServer = (System.String)typeof(System.String).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            ((YooAsset.HostPlayModeParameters)o).FallbackHostServer = @FallbackHostServer;
            return ptr_of_this_method;
        }


        static StackObject* Ctor_0(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* __ret = ILIntepreter.Minus(__esp, 0);

            var result_of_this_method = new YooAsset.HostPlayModeParameters();

            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }


    }
}
