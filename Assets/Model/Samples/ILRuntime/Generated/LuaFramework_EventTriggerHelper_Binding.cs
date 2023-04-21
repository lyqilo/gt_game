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
    unsafe class LuaFramework_EventTriggerHelper_Binding
    {
        public static void Register(ILRuntime.Runtime.Enviorment.AppDomain app)
        {
            BindingFlags flag = BindingFlags.Public | BindingFlags.Instance | BindingFlags.Static | BindingFlags.DeclaredOnly;
            MethodBase method;
            FieldInfo field;
            Type[] args;
            Type type = typeof(LuaFramework.EventTriggerHelper);
            args = new Type[]{typeof(UnityEngine.GameObject)};
            method = type.GetMethod("Get", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, Get_0);

            field = type.GetField("onBeginDrag", flag);
            app.RegisterCLRFieldGetter(field, get_onBeginDrag_0);
            app.RegisterCLRFieldSetter(field, set_onBeginDrag_0);
            app.RegisterCLRFieldBinding(field, CopyToStack_onBeginDrag_0, AssignFromStack_onBeginDrag_0);
            field = type.GetField("onEndDrag", flag);
            app.RegisterCLRFieldGetter(field, get_onEndDrag_1);
            app.RegisterCLRFieldSetter(field, set_onEndDrag_1);
            app.RegisterCLRFieldBinding(field, CopyToStack_onEndDrag_1, AssignFromStack_onEndDrag_1);
            field = type.GetField("onDown", flag);
            app.RegisterCLRFieldGetter(field, get_onDown_2);
            app.RegisterCLRFieldSetter(field, set_onDown_2);
            app.RegisterCLRFieldBinding(field, CopyToStack_onDown_2, AssignFromStack_onDown_2);
            field = type.GetField("onUp", flag);
            app.RegisterCLRFieldGetter(field, get_onUp_3);
            app.RegisterCLRFieldSetter(field, set_onUp_3);
            app.RegisterCLRFieldBinding(field, CopyToStack_onUp_3, AssignFromStack_onUp_3);
            field = type.GetField("onClick", flag);
            app.RegisterCLRFieldGetter(field, get_onClick_4);
            app.RegisterCLRFieldSetter(field, set_onClick_4);
            app.RegisterCLRFieldBinding(field, CopyToStack_onClick_4, AssignFromStack_onClick_4);
            field = type.GetField("onDrag", flag);
            app.RegisterCLRFieldGetter(field, get_onDrag_5);
            app.RegisterCLRFieldSetter(field, set_onDrag_5);
            app.RegisterCLRFieldBinding(field, CopyToStack_onDrag_5, AssignFromStack_onDrag_5);


        }


        static StackObject* Get_0(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 1);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            UnityEngine.GameObject @go = (UnityEngine.GameObject)typeof(UnityEngine.GameObject).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);


            var result_of_this_method = LuaFramework.EventTriggerHelper.Get(@go);

            object obj_result_of_this_method = result_of_this_method;
            if(obj_result_of_this_method is CrossBindingAdaptorType)
            {    
                return ILIntepreter.PushObject(__ret, __mStack, ((CrossBindingAdaptorType)obj_result_of_this_method).ILInstance);
            }
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }


        static object get_onBeginDrag_0(ref object o)
        {
            return ((LuaFramework.EventTriggerHelper)o).onBeginDrag;
        }

        static StackObject* CopyToStack_onBeginDrag_0(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.EventTriggerHelper)o).onBeginDrag;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_onBeginDrag_0(ref object o, object v)
        {
            ((LuaFramework.EventTriggerHelper)o).onBeginDrag = (System.Action<UnityEngine.GameObject, UnityEngine.EventSystems.PointerEventData>)v;
        }

        static StackObject* AssignFromStack_onBeginDrag_0(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action<UnityEngine.GameObject, UnityEngine.EventSystems.PointerEventData> @onBeginDrag = (System.Action<UnityEngine.GameObject, UnityEngine.EventSystems.PointerEventData>)typeof(System.Action<UnityEngine.GameObject, UnityEngine.EventSystems.PointerEventData>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.EventTriggerHelper)o).onBeginDrag = @onBeginDrag;
            return ptr_of_this_method;
        }

        static object get_onEndDrag_1(ref object o)
        {
            return ((LuaFramework.EventTriggerHelper)o).onEndDrag;
        }

        static StackObject* CopyToStack_onEndDrag_1(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.EventTriggerHelper)o).onEndDrag;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_onEndDrag_1(ref object o, object v)
        {
            ((LuaFramework.EventTriggerHelper)o).onEndDrag = (System.Action<UnityEngine.GameObject, UnityEngine.EventSystems.PointerEventData>)v;
        }

        static StackObject* AssignFromStack_onEndDrag_1(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action<UnityEngine.GameObject, UnityEngine.EventSystems.PointerEventData> @onEndDrag = (System.Action<UnityEngine.GameObject, UnityEngine.EventSystems.PointerEventData>)typeof(System.Action<UnityEngine.GameObject, UnityEngine.EventSystems.PointerEventData>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.EventTriggerHelper)o).onEndDrag = @onEndDrag;
            return ptr_of_this_method;
        }

        static object get_onDown_2(ref object o)
        {
            return ((LuaFramework.EventTriggerHelper)o).onDown;
        }

        static StackObject* CopyToStack_onDown_2(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.EventTriggerHelper)o).onDown;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_onDown_2(ref object o, object v)
        {
            ((LuaFramework.EventTriggerHelper)o).onDown = (System.Action<UnityEngine.GameObject, UnityEngine.EventSystems.PointerEventData>)v;
        }

        static StackObject* AssignFromStack_onDown_2(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action<UnityEngine.GameObject, UnityEngine.EventSystems.PointerEventData> @onDown = (System.Action<UnityEngine.GameObject, UnityEngine.EventSystems.PointerEventData>)typeof(System.Action<UnityEngine.GameObject, UnityEngine.EventSystems.PointerEventData>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.EventTriggerHelper)o).onDown = @onDown;
            return ptr_of_this_method;
        }

        static object get_onUp_3(ref object o)
        {
            return ((LuaFramework.EventTriggerHelper)o).onUp;
        }

        static StackObject* CopyToStack_onUp_3(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.EventTriggerHelper)o).onUp;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_onUp_3(ref object o, object v)
        {
            ((LuaFramework.EventTriggerHelper)o).onUp = (System.Action<UnityEngine.GameObject, UnityEngine.EventSystems.PointerEventData>)v;
        }

        static StackObject* AssignFromStack_onUp_3(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action<UnityEngine.GameObject, UnityEngine.EventSystems.PointerEventData> @onUp = (System.Action<UnityEngine.GameObject, UnityEngine.EventSystems.PointerEventData>)typeof(System.Action<UnityEngine.GameObject, UnityEngine.EventSystems.PointerEventData>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.EventTriggerHelper)o).onUp = @onUp;
            return ptr_of_this_method;
        }

        static object get_onClick_4(ref object o)
        {
            return ((LuaFramework.EventTriggerHelper)o).onClick;
        }

        static StackObject* CopyToStack_onClick_4(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.EventTriggerHelper)o).onClick;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_onClick_4(ref object o, object v)
        {
            ((LuaFramework.EventTriggerHelper)o).onClick = (System.Action<UnityEngine.GameObject, UnityEngine.EventSystems.PointerEventData>)v;
        }

        static StackObject* AssignFromStack_onClick_4(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action<UnityEngine.GameObject, UnityEngine.EventSystems.PointerEventData> @onClick = (System.Action<UnityEngine.GameObject, UnityEngine.EventSystems.PointerEventData>)typeof(System.Action<UnityEngine.GameObject, UnityEngine.EventSystems.PointerEventData>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.EventTriggerHelper)o).onClick = @onClick;
            return ptr_of_this_method;
        }

        static object get_onDrag_5(ref object o)
        {
            return ((LuaFramework.EventTriggerHelper)o).onDrag;
        }

        static StackObject* CopyToStack_onDrag_5(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.EventTriggerHelper)o).onDrag;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_onDrag_5(ref object o, object v)
        {
            ((LuaFramework.EventTriggerHelper)o).onDrag = (System.Action<UnityEngine.GameObject, UnityEngine.EventSystems.PointerEventData>)v;
        }

        static StackObject* AssignFromStack_onDrag_5(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action<UnityEngine.GameObject, UnityEngine.EventSystems.PointerEventData> @onDrag = (System.Action<UnityEngine.GameObject, UnityEngine.EventSystems.PointerEventData>)typeof(System.Action<UnityEngine.GameObject, UnityEngine.EventSystems.PointerEventData>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.EventTriggerHelper)o).onDrag = @onDrag;
            return ptr_of_this_method;
        }



    }
}
