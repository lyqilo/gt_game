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
    unsafe class LuaFramework_NetworkManager_Binding
    {
        public static void Register(ILRuntime.Runtime.Enviorment.AppDomain app)
        {
            BindingFlags flag = BindingFlags.Public | BindingFlags.Instance | BindingFlags.Static | BindingFlags.DeclaredOnly;
            FieldInfo field;
            Type[] args;
            Type type = typeof(LuaFramework.NetworkManager);

            field = type.GetField("DicSession", flag);
            app.RegisterCLRFieldGetter(field, get_DicSession_0);
            app.RegisterCLRFieldSetter(field, set_DicSession_0);
            app.RegisterCLRFieldBinding(field, CopyToStack_DicSession_0, AssignFromStack_DicSession_0);


        }



        static object get_DicSession_0(ref object o)
        {
            return LuaFramework.NetworkManager.DicSession;
        }

        static StackObject* CopyToStack_DicSession_0(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = LuaFramework.NetworkManager.DicSession;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_DicSession_0(ref object o, object v)
        {
            LuaFramework.NetworkManager.DicSession = (System.Collections.Generic.Dictionary<System.Int32, LuaFramework.Session>)v;
        }

        static StackObject* AssignFromStack_DicSession_0(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Collections.Generic.Dictionary<System.Int32, LuaFramework.Session> @DicSession = (System.Collections.Generic.Dictionary<System.Int32, LuaFramework.Session>)typeof(System.Collections.Generic.Dictionary<System.Int32, LuaFramework.Session>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            LuaFramework.NetworkManager.DicSession = @DicSession;
            return ptr_of_this_method;
        }



    }
}
