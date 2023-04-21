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
    unsafe class LuaFramework_CollisionTriggerUtility_Binding
    {
        public static void Register(ILRuntime.Runtime.Enviorment.AppDomain app)
        {
            BindingFlags flag = BindingFlags.Public | BindingFlags.Instance | BindingFlags.Static | BindingFlags.DeclaredOnly;
            MethodBase method;
            FieldInfo field;
            Type[] args;
            Type type = typeof(LuaFramework.CollisionTriggerUtility);
            args = new Type[]{typeof(UnityEngine.Transform)};
            method = type.GetMethod("Get", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, Get_0);

            field = type.GetField("onTriggerEnter2D", flag);
            app.RegisterCLRFieldGetter(field, get_onTriggerEnter2D_0);
            app.RegisterCLRFieldSetter(field, set_onTriggerEnter2D_0);
            app.RegisterCLRFieldBinding(field, CopyToStack_onTriggerEnter2D_0, AssignFromStack_onTriggerEnter2D_0);
            field = type.GetField("onTriggerStay2D", flag);
            app.RegisterCLRFieldGetter(field, get_onTriggerStay2D_1);
            app.RegisterCLRFieldSetter(field, set_onTriggerStay2D_1);
            app.RegisterCLRFieldBinding(field, CopyToStack_onTriggerStay2D_1, AssignFromStack_onTriggerStay2D_1);
            field = type.GetField("onTriggerExit2D", flag);
            app.RegisterCLRFieldGetter(field, get_onTriggerExit2D_2);
            app.RegisterCLRFieldSetter(field, set_onTriggerExit2D_2);
            app.RegisterCLRFieldBinding(field, CopyToStack_onTriggerExit2D_2, AssignFromStack_onTriggerExit2D_2);


        }


        static StackObject* Get_0(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 1);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            UnityEngine.Transform @trans = (UnityEngine.Transform)typeof(UnityEngine.Transform).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);


            var result_of_this_method = LuaFramework.CollisionTriggerUtility.Get(@trans);

            object obj_result_of_this_method = result_of_this_method;
            if(obj_result_of_this_method is CrossBindingAdaptorType)
            {    
                return ILIntepreter.PushObject(__ret, __mStack, ((CrossBindingAdaptorType)obj_result_of_this_method).ILInstance);
            }
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }


        static object get_onTriggerEnter2D_0(ref object o)
        {
            return ((LuaFramework.CollisionTriggerUtility)o).onTriggerEnter2D;
        }

        static StackObject* CopyToStack_onTriggerEnter2D_0(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.CollisionTriggerUtility)o).onTriggerEnter2D;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_onTriggerEnter2D_0(ref object o, object v)
        {
            ((LuaFramework.CollisionTriggerUtility)o).onTriggerEnter2D = (System.Action<UnityEngine.GameObject, UnityEngine.GameObject>)v;
        }

        static StackObject* AssignFromStack_onTriggerEnter2D_0(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action<UnityEngine.GameObject, UnityEngine.GameObject> @onTriggerEnter2D = (System.Action<UnityEngine.GameObject, UnityEngine.GameObject>)typeof(System.Action<UnityEngine.GameObject, UnityEngine.GameObject>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.CollisionTriggerUtility)o).onTriggerEnter2D = @onTriggerEnter2D;
            return ptr_of_this_method;
        }

        static object get_onTriggerStay2D_1(ref object o)
        {
            return ((LuaFramework.CollisionTriggerUtility)o).onTriggerStay2D;
        }

        static StackObject* CopyToStack_onTriggerStay2D_1(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.CollisionTriggerUtility)o).onTriggerStay2D;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_onTriggerStay2D_1(ref object o, object v)
        {
            ((LuaFramework.CollisionTriggerUtility)o).onTriggerStay2D = (System.Action<UnityEngine.GameObject, UnityEngine.GameObject>)v;
        }

        static StackObject* AssignFromStack_onTriggerStay2D_1(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action<UnityEngine.GameObject, UnityEngine.GameObject> @onTriggerStay2D = (System.Action<UnityEngine.GameObject, UnityEngine.GameObject>)typeof(System.Action<UnityEngine.GameObject, UnityEngine.GameObject>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.CollisionTriggerUtility)o).onTriggerStay2D = @onTriggerStay2D;
            return ptr_of_this_method;
        }

        static object get_onTriggerExit2D_2(ref object o)
        {
            return ((LuaFramework.CollisionTriggerUtility)o).onTriggerExit2D;
        }

        static StackObject* CopyToStack_onTriggerExit2D_2(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.CollisionTriggerUtility)o).onTriggerExit2D;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_onTriggerExit2D_2(ref object o, object v)
        {
            ((LuaFramework.CollisionTriggerUtility)o).onTriggerExit2D = (System.Action<UnityEngine.GameObject, UnityEngine.GameObject>)v;
        }

        static StackObject* AssignFromStack_onTriggerExit2D_2(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action<UnityEngine.GameObject, UnityEngine.GameObject> @onTriggerExit2D = (System.Action<UnityEngine.GameObject, UnityEngine.GameObject>)typeof(System.Action<UnityEngine.GameObject, UnityEngine.GameObject>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.CollisionTriggerUtility)o).onTriggerExit2D = @onTriggerExit2D;
            return ptr_of_this_method;
        }



    }
}
