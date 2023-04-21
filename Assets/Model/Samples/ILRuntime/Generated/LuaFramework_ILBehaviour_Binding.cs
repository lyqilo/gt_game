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
    unsafe class LuaFramework_ILBehaviour_Binding
    {
        public static void Register(ILRuntime.Runtime.Enviorment.AppDomain app)
        {
            BindingFlags flag = BindingFlags.Public | BindingFlags.Instance | BindingFlags.Static | BindingFlags.DeclaredOnly;
            FieldInfo field;
            Type[] args;
            Type type = typeof(LuaFramework.ILBehaviour);

            field = type.GetField("UpdateEvent", flag);
            app.RegisterCLRFieldGetter(field, get_UpdateEvent_0);
            app.RegisterCLRFieldSetter(field, set_UpdateEvent_0);
            app.RegisterCLRFieldBinding(field, CopyToStack_UpdateEvent_0, AssignFromStack_UpdateEvent_0);
            field = type.GetField("BehaviourName", flag);
            app.RegisterCLRFieldGetter(field, get_BehaviourName_1);
            app.RegisterCLRFieldSetter(field, set_BehaviourName_1);
            app.RegisterCLRFieldBinding(field, CopyToStack_BehaviourName_1, AssignFromStack_BehaviourName_1);
            field = type.GetField("Behaviour", flag);
            app.RegisterCLRFieldGetter(field, get_Behaviour_2);
            app.RegisterCLRFieldSetter(field, set_Behaviour_2);
            app.RegisterCLRFieldBinding(field, CopyToStack_Behaviour_2, AssignFromStack_Behaviour_2);
            field = type.GetField("FixedUpdateEvent", flag);
            app.RegisterCLRFieldGetter(field, get_FixedUpdateEvent_3);
            app.RegisterCLRFieldSetter(field, set_FixedUpdateEvent_3);
            app.RegisterCLRFieldBinding(field, CopyToStack_FixedUpdateEvent_3, AssignFromStack_FixedUpdateEvent_3);
            field = type.GetField("OnEnableEvent", flag);
            app.RegisterCLRFieldGetter(field, get_OnEnableEvent_4);
            app.RegisterCLRFieldSetter(field, set_OnEnableEvent_4);
            app.RegisterCLRFieldBinding(field, CopyToStack_OnEnableEvent_4, AssignFromStack_OnEnableEvent_4);
            field = type.GetField("OnDisableEvent", flag);
            app.RegisterCLRFieldGetter(field, get_OnDisableEvent_5);
            app.RegisterCLRFieldSetter(field, set_OnDisableEvent_5);
            app.RegisterCLRFieldBinding(field, CopyToStack_OnDisableEvent_5, AssignFromStack_OnDisableEvent_5);
            field = type.GetField("LateUpdateEvent", flag);
            app.RegisterCLRFieldGetter(field, get_LateUpdateEvent_6);
            app.RegisterCLRFieldSetter(field, set_LateUpdateEvent_6);
            app.RegisterCLRFieldBinding(field, CopyToStack_LateUpdateEvent_6, AssignFromStack_LateUpdateEvent_6);
            field = type.GetField("OnDestroyEvent", flag);
            app.RegisterCLRFieldGetter(field, get_OnDestroyEvent_7);
            app.RegisterCLRFieldSetter(field, set_OnDestroyEvent_7);
            app.RegisterCLRFieldBinding(field, CopyToStack_OnDestroyEvent_7, AssignFromStack_OnDestroyEvent_7);
            field = type.GetField("OnApplicationFocusEvent", flag);
            app.RegisterCLRFieldGetter(field, get_OnApplicationFocusEvent_8);
            app.RegisterCLRFieldSetter(field, set_OnApplicationFocusEvent_8);
            app.RegisterCLRFieldBinding(field, CopyToStack_OnApplicationFocusEvent_8, AssignFromStack_OnApplicationFocusEvent_8);
            field = type.GetField("OnApplicationPauseEvent", flag);
            app.RegisterCLRFieldGetter(field, get_OnApplicationPauseEvent_9);
            app.RegisterCLRFieldSetter(field, set_OnApplicationPauseEvent_9);
            app.RegisterCLRFieldBinding(field, CopyToStack_OnApplicationPauseEvent_9, AssignFromStack_OnApplicationPauseEvent_9);
            field = type.GetField("OnApplicationQuitEvent", flag);
            app.RegisterCLRFieldGetter(field, get_OnApplicationQuitEvent_10);
            app.RegisterCLRFieldSetter(field, set_OnApplicationQuitEvent_10);
            app.RegisterCLRFieldBinding(field, CopyToStack_OnApplicationQuitEvent_10, AssignFromStack_OnApplicationQuitEvent_10);
            field = type.GetField("OnCollisionEnterEvent", flag);
            app.RegisterCLRFieldGetter(field, get_OnCollisionEnterEvent_11);
            app.RegisterCLRFieldSetter(field, set_OnCollisionEnterEvent_11);
            app.RegisterCLRFieldBinding(field, CopyToStack_OnCollisionEnterEvent_11, AssignFromStack_OnCollisionEnterEvent_11);
            field = type.GetField("OnCollisionStayEvent", flag);
            app.RegisterCLRFieldGetter(field, get_OnCollisionStayEvent_12);
            app.RegisterCLRFieldSetter(field, set_OnCollisionStayEvent_12);
            app.RegisterCLRFieldBinding(field, CopyToStack_OnCollisionStayEvent_12, AssignFromStack_OnCollisionStayEvent_12);
            field = type.GetField("OnCollisionExitEvent", flag);
            app.RegisterCLRFieldGetter(field, get_OnCollisionExitEvent_13);
            app.RegisterCLRFieldSetter(field, set_OnCollisionExitEvent_13);
            app.RegisterCLRFieldBinding(field, CopyToStack_OnCollisionExitEvent_13, AssignFromStack_OnCollisionExitEvent_13);
            field = type.GetField("OnTriggerEnterEvent", flag);
            app.RegisterCLRFieldGetter(field, get_OnTriggerEnterEvent_14);
            app.RegisterCLRFieldSetter(field, set_OnTriggerEnterEvent_14);
            app.RegisterCLRFieldBinding(field, CopyToStack_OnTriggerEnterEvent_14, AssignFromStack_OnTriggerEnterEvent_14);
            field = type.GetField("OnTriggerStayEvent", flag);
            app.RegisterCLRFieldGetter(field, get_OnTriggerStayEvent_15);
            app.RegisterCLRFieldSetter(field, set_OnTriggerStayEvent_15);
            app.RegisterCLRFieldBinding(field, CopyToStack_OnTriggerStayEvent_15, AssignFromStack_OnTriggerStayEvent_15);
            field = type.GetField("OnTriggerExitEvent", flag);
            app.RegisterCLRFieldGetter(field, get_OnTriggerExitEvent_16);
            app.RegisterCLRFieldSetter(field, set_OnTriggerExitEvent_16);
            app.RegisterCLRFieldBinding(field, CopyToStack_OnTriggerExitEvent_16, AssignFromStack_OnTriggerExitEvent_16);
            field = type.GetField("OnCollisionEnter2DEvent", flag);
            app.RegisterCLRFieldGetter(field, get_OnCollisionEnter2DEvent_17);
            app.RegisterCLRFieldSetter(field, set_OnCollisionEnter2DEvent_17);
            app.RegisterCLRFieldBinding(field, CopyToStack_OnCollisionEnter2DEvent_17, AssignFromStack_OnCollisionEnter2DEvent_17);
            field = type.GetField("OnCollisionExit2DEvent", flag);
            app.RegisterCLRFieldGetter(field, get_OnCollisionExit2DEvent_18);
            app.RegisterCLRFieldSetter(field, set_OnCollisionExit2DEvent_18);
            app.RegisterCLRFieldBinding(field, CopyToStack_OnCollisionExit2DEvent_18, AssignFromStack_OnCollisionExit2DEvent_18);
            field = type.GetField("OnCollisionStay2DEvent", flag);
            app.RegisterCLRFieldGetter(field, get_OnCollisionStay2DEvent_19);
            app.RegisterCLRFieldSetter(field, set_OnCollisionStay2DEvent_19);
            app.RegisterCLRFieldBinding(field, CopyToStack_OnCollisionStay2DEvent_19, AssignFromStack_OnCollisionStay2DEvent_19);
            field = type.GetField("OnTriggerEnter2DEvent", flag);
            app.RegisterCLRFieldGetter(field, get_OnTriggerEnter2DEvent_20);
            app.RegisterCLRFieldSetter(field, set_OnTriggerEnter2DEvent_20);
            app.RegisterCLRFieldBinding(field, CopyToStack_OnTriggerEnter2DEvent_20, AssignFromStack_OnTriggerEnter2DEvent_20);
            field = type.GetField("OnTriggerExit2DEvent", flag);
            app.RegisterCLRFieldGetter(field, get_OnTriggerExit2DEvent_21);
            app.RegisterCLRFieldSetter(field, set_OnTriggerExit2DEvent_21);
            app.RegisterCLRFieldBinding(field, CopyToStack_OnTriggerExit2DEvent_21, AssignFromStack_OnTriggerExit2DEvent_21);
            field = type.GetField("OnTriggerStay2DEvent", flag);
            app.RegisterCLRFieldGetter(field, get_OnTriggerStay2DEvent_22);
            app.RegisterCLRFieldSetter(field, set_OnTriggerStay2DEvent_22);
            app.RegisterCLRFieldBinding(field, CopyToStack_OnTriggerStay2DEvent_22, AssignFromStack_OnTriggerStay2DEvent_22);
            field = type.GetField("AwakeEvent", flag);
            app.RegisterCLRFieldGetter(field, get_AwakeEvent_23);
            app.RegisterCLRFieldSetter(field, set_AwakeEvent_23);
            app.RegisterCLRFieldBinding(field, CopyToStack_AwakeEvent_23, AssignFromStack_AwakeEvent_23);
            field = type.GetField("StartEvent", flag);
            app.RegisterCLRFieldGetter(field, get_StartEvent_24);
            app.RegisterCLRFieldSetter(field, set_StartEvent_24);
            app.RegisterCLRFieldBinding(field, CopyToStack_StartEvent_24, AssignFromStack_StartEvent_24);


        }



        static object get_UpdateEvent_0(ref object o)
        {
            return ((LuaFramework.ILBehaviour)o).UpdateEvent;
        }

        static StackObject* CopyToStack_UpdateEvent_0(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.ILBehaviour)o).UpdateEvent;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_UpdateEvent_0(ref object o, object v)
        {
            ((LuaFramework.ILBehaviour)o).UpdateEvent = (System.Action)v;
        }

        static StackObject* AssignFromStack_UpdateEvent_0(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action @UpdateEvent = (System.Action)typeof(System.Action).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.ILBehaviour)o).UpdateEvent = @UpdateEvent;
            return ptr_of_this_method;
        }

        static object get_BehaviourName_1(ref object o)
        {
            return ((LuaFramework.ILBehaviour)o).BehaviourName;
        }

        static StackObject* CopyToStack_BehaviourName_1(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.ILBehaviour)o).BehaviourName;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_BehaviourName_1(ref object o, object v)
        {
            ((LuaFramework.ILBehaviour)o).BehaviourName = (System.String)v;
        }

        static StackObject* AssignFromStack_BehaviourName_1(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.String @BehaviourName = (System.String)typeof(System.String).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            ((LuaFramework.ILBehaviour)o).BehaviourName = @BehaviourName;
            return ptr_of_this_method;
        }

        static object get_Behaviour_2(ref object o)
        {
            return ((LuaFramework.ILBehaviour)o).Behaviour;
        }

        static StackObject* CopyToStack_Behaviour_2(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.ILBehaviour)o).Behaviour;
            object obj_result_of_this_method = result_of_this_method;
            if(obj_result_of_this_method is CrossBindingAdaptorType)
            {    
                return ILIntepreter.PushObject(__ret, __mStack, ((CrossBindingAdaptorType)obj_result_of_this_method).ILInstance, true);
            }
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method, true);
        }

        static void set_Behaviour_2(ref object o, object v)
        {
            ((LuaFramework.ILBehaviour)o).Behaviour = (System.Object)v;
        }

        static StackObject* AssignFromStack_Behaviour_2(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Object @Behaviour = (System.Object)typeof(System.Object).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            ((LuaFramework.ILBehaviour)o).Behaviour = @Behaviour;
            return ptr_of_this_method;
        }

        static object get_FixedUpdateEvent_3(ref object o)
        {
            return ((LuaFramework.ILBehaviour)o).FixedUpdateEvent;
        }

        static StackObject* CopyToStack_FixedUpdateEvent_3(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.ILBehaviour)o).FixedUpdateEvent;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_FixedUpdateEvent_3(ref object o, object v)
        {
            ((LuaFramework.ILBehaviour)o).FixedUpdateEvent = (System.Action)v;
        }

        static StackObject* AssignFromStack_FixedUpdateEvent_3(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action @FixedUpdateEvent = (System.Action)typeof(System.Action).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.ILBehaviour)o).FixedUpdateEvent = @FixedUpdateEvent;
            return ptr_of_this_method;
        }

        static object get_OnEnableEvent_4(ref object o)
        {
            return ((LuaFramework.ILBehaviour)o).OnEnableEvent;
        }

        static StackObject* CopyToStack_OnEnableEvent_4(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.ILBehaviour)o).OnEnableEvent;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_OnEnableEvent_4(ref object o, object v)
        {
            ((LuaFramework.ILBehaviour)o).OnEnableEvent = (System.Action)v;
        }

        static StackObject* AssignFromStack_OnEnableEvent_4(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action @OnEnableEvent = (System.Action)typeof(System.Action).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.ILBehaviour)o).OnEnableEvent = @OnEnableEvent;
            return ptr_of_this_method;
        }

        static object get_OnDisableEvent_5(ref object o)
        {
            return ((LuaFramework.ILBehaviour)o).OnDisableEvent;
        }

        static StackObject* CopyToStack_OnDisableEvent_5(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.ILBehaviour)o).OnDisableEvent;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_OnDisableEvent_5(ref object o, object v)
        {
            ((LuaFramework.ILBehaviour)o).OnDisableEvent = (System.Action)v;
        }

        static StackObject* AssignFromStack_OnDisableEvent_5(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action @OnDisableEvent = (System.Action)typeof(System.Action).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.ILBehaviour)o).OnDisableEvent = @OnDisableEvent;
            return ptr_of_this_method;
        }

        static object get_LateUpdateEvent_6(ref object o)
        {
            return ((LuaFramework.ILBehaviour)o).LateUpdateEvent;
        }

        static StackObject* CopyToStack_LateUpdateEvent_6(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.ILBehaviour)o).LateUpdateEvent;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_LateUpdateEvent_6(ref object o, object v)
        {
            ((LuaFramework.ILBehaviour)o).LateUpdateEvent = (System.Action)v;
        }

        static StackObject* AssignFromStack_LateUpdateEvent_6(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action @LateUpdateEvent = (System.Action)typeof(System.Action).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.ILBehaviour)o).LateUpdateEvent = @LateUpdateEvent;
            return ptr_of_this_method;
        }

        static object get_OnDestroyEvent_7(ref object o)
        {
            return ((LuaFramework.ILBehaviour)o).OnDestroyEvent;
        }

        static StackObject* CopyToStack_OnDestroyEvent_7(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.ILBehaviour)o).OnDestroyEvent;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_OnDestroyEvent_7(ref object o, object v)
        {
            ((LuaFramework.ILBehaviour)o).OnDestroyEvent = (System.Action)v;
        }

        static StackObject* AssignFromStack_OnDestroyEvent_7(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action @OnDestroyEvent = (System.Action)typeof(System.Action).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.ILBehaviour)o).OnDestroyEvent = @OnDestroyEvent;
            return ptr_of_this_method;
        }

        static object get_OnApplicationFocusEvent_8(ref object o)
        {
            return ((LuaFramework.ILBehaviour)o).OnApplicationFocusEvent;
        }

        static StackObject* CopyToStack_OnApplicationFocusEvent_8(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.ILBehaviour)o).OnApplicationFocusEvent;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_OnApplicationFocusEvent_8(ref object o, object v)
        {
            ((LuaFramework.ILBehaviour)o).OnApplicationFocusEvent = (System.Action<System.Boolean>)v;
        }

        static StackObject* AssignFromStack_OnApplicationFocusEvent_8(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action<System.Boolean> @OnApplicationFocusEvent = (System.Action<System.Boolean>)typeof(System.Action<System.Boolean>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.ILBehaviour)o).OnApplicationFocusEvent = @OnApplicationFocusEvent;
            return ptr_of_this_method;
        }

        static object get_OnApplicationPauseEvent_9(ref object o)
        {
            return ((LuaFramework.ILBehaviour)o).OnApplicationPauseEvent;
        }

        static StackObject* CopyToStack_OnApplicationPauseEvent_9(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.ILBehaviour)o).OnApplicationPauseEvent;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_OnApplicationPauseEvent_9(ref object o, object v)
        {
            ((LuaFramework.ILBehaviour)o).OnApplicationPauseEvent = (System.Action<System.Boolean>)v;
        }

        static StackObject* AssignFromStack_OnApplicationPauseEvent_9(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action<System.Boolean> @OnApplicationPauseEvent = (System.Action<System.Boolean>)typeof(System.Action<System.Boolean>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.ILBehaviour)o).OnApplicationPauseEvent = @OnApplicationPauseEvent;
            return ptr_of_this_method;
        }

        static object get_OnApplicationQuitEvent_10(ref object o)
        {
            return ((LuaFramework.ILBehaviour)o).OnApplicationQuitEvent;
        }

        static StackObject* CopyToStack_OnApplicationQuitEvent_10(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.ILBehaviour)o).OnApplicationQuitEvent;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_OnApplicationQuitEvent_10(ref object o, object v)
        {
            ((LuaFramework.ILBehaviour)o).OnApplicationQuitEvent = (System.Action)v;
        }

        static StackObject* AssignFromStack_OnApplicationQuitEvent_10(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action @OnApplicationQuitEvent = (System.Action)typeof(System.Action).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.ILBehaviour)o).OnApplicationQuitEvent = @OnApplicationQuitEvent;
            return ptr_of_this_method;
        }

        static object get_OnCollisionEnterEvent_11(ref object o)
        {
            return ((LuaFramework.ILBehaviour)o).OnCollisionEnterEvent;
        }

        static StackObject* CopyToStack_OnCollisionEnterEvent_11(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.ILBehaviour)o).OnCollisionEnterEvent;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_OnCollisionEnterEvent_11(ref object o, object v)
        {
            ((LuaFramework.ILBehaviour)o).OnCollisionEnterEvent = (System.Action<UnityEngine.Collision>)v;
        }

        static StackObject* AssignFromStack_OnCollisionEnterEvent_11(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action<UnityEngine.Collision> @OnCollisionEnterEvent = (System.Action<UnityEngine.Collision>)typeof(System.Action<UnityEngine.Collision>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.ILBehaviour)o).OnCollisionEnterEvent = @OnCollisionEnterEvent;
            return ptr_of_this_method;
        }

        static object get_OnCollisionStayEvent_12(ref object o)
        {
            return ((LuaFramework.ILBehaviour)o).OnCollisionStayEvent;
        }

        static StackObject* CopyToStack_OnCollisionStayEvent_12(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.ILBehaviour)o).OnCollisionStayEvent;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_OnCollisionStayEvent_12(ref object o, object v)
        {
            ((LuaFramework.ILBehaviour)o).OnCollisionStayEvent = (System.Action<UnityEngine.Collision>)v;
        }

        static StackObject* AssignFromStack_OnCollisionStayEvent_12(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action<UnityEngine.Collision> @OnCollisionStayEvent = (System.Action<UnityEngine.Collision>)typeof(System.Action<UnityEngine.Collision>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.ILBehaviour)o).OnCollisionStayEvent = @OnCollisionStayEvent;
            return ptr_of_this_method;
        }

        static object get_OnCollisionExitEvent_13(ref object o)
        {
            return ((LuaFramework.ILBehaviour)o).OnCollisionExitEvent;
        }

        static StackObject* CopyToStack_OnCollisionExitEvent_13(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.ILBehaviour)o).OnCollisionExitEvent;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_OnCollisionExitEvent_13(ref object o, object v)
        {
            ((LuaFramework.ILBehaviour)o).OnCollisionExitEvent = (System.Action<UnityEngine.Collision>)v;
        }

        static StackObject* AssignFromStack_OnCollisionExitEvent_13(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action<UnityEngine.Collision> @OnCollisionExitEvent = (System.Action<UnityEngine.Collision>)typeof(System.Action<UnityEngine.Collision>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.ILBehaviour)o).OnCollisionExitEvent = @OnCollisionExitEvent;
            return ptr_of_this_method;
        }

        static object get_OnTriggerEnterEvent_14(ref object o)
        {
            return ((LuaFramework.ILBehaviour)o).OnTriggerEnterEvent;
        }

        static StackObject* CopyToStack_OnTriggerEnterEvent_14(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.ILBehaviour)o).OnTriggerEnterEvent;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_OnTriggerEnterEvent_14(ref object o, object v)
        {
            ((LuaFramework.ILBehaviour)o).OnTriggerEnterEvent = (System.Action<UnityEngine.Collider>)v;
        }

        static StackObject* AssignFromStack_OnTriggerEnterEvent_14(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action<UnityEngine.Collider> @OnTriggerEnterEvent = (System.Action<UnityEngine.Collider>)typeof(System.Action<UnityEngine.Collider>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.ILBehaviour)o).OnTriggerEnterEvent = @OnTriggerEnterEvent;
            return ptr_of_this_method;
        }

        static object get_OnTriggerStayEvent_15(ref object o)
        {
            return ((LuaFramework.ILBehaviour)o).OnTriggerStayEvent;
        }

        static StackObject* CopyToStack_OnTriggerStayEvent_15(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.ILBehaviour)o).OnTriggerStayEvent;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_OnTriggerStayEvent_15(ref object o, object v)
        {
            ((LuaFramework.ILBehaviour)o).OnTriggerStayEvent = (System.Action<UnityEngine.Collider>)v;
        }

        static StackObject* AssignFromStack_OnTriggerStayEvent_15(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action<UnityEngine.Collider> @OnTriggerStayEvent = (System.Action<UnityEngine.Collider>)typeof(System.Action<UnityEngine.Collider>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.ILBehaviour)o).OnTriggerStayEvent = @OnTriggerStayEvent;
            return ptr_of_this_method;
        }

        static object get_OnTriggerExitEvent_16(ref object o)
        {
            return ((LuaFramework.ILBehaviour)o).OnTriggerExitEvent;
        }

        static StackObject* CopyToStack_OnTriggerExitEvent_16(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.ILBehaviour)o).OnTriggerExitEvent;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_OnTriggerExitEvent_16(ref object o, object v)
        {
            ((LuaFramework.ILBehaviour)o).OnTriggerExitEvent = (System.Action<UnityEngine.Collider>)v;
        }

        static StackObject* AssignFromStack_OnTriggerExitEvent_16(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action<UnityEngine.Collider> @OnTriggerExitEvent = (System.Action<UnityEngine.Collider>)typeof(System.Action<UnityEngine.Collider>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.ILBehaviour)o).OnTriggerExitEvent = @OnTriggerExitEvent;
            return ptr_of_this_method;
        }

        static object get_OnCollisionEnter2DEvent_17(ref object o)
        {
            return ((LuaFramework.ILBehaviour)o).OnCollisionEnter2DEvent;
        }

        static StackObject* CopyToStack_OnCollisionEnter2DEvent_17(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.ILBehaviour)o).OnCollisionEnter2DEvent;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_OnCollisionEnter2DEvent_17(ref object o, object v)
        {
            ((LuaFramework.ILBehaviour)o).OnCollisionEnter2DEvent = (System.Action<UnityEngine.Collision2D>)v;
        }

        static StackObject* AssignFromStack_OnCollisionEnter2DEvent_17(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action<UnityEngine.Collision2D> @OnCollisionEnter2DEvent = (System.Action<UnityEngine.Collision2D>)typeof(System.Action<UnityEngine.Collision2D>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.ILBehaviour)o).OnCollisionEnter2DEvent = @OnCollisionEnter2DEvent;
            return ptr_of_this_method;
        }

        static object get_OnCollisionExit2DEvent_18(ref object o)
        {
            return ((LuaFramework.ILBehaviour)o).OnCollisionExit2DEvent;
        }

        static StackObject* CopyToStack_OnCollisionExit2DEvent_18(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.ILBehaviour)o).OnCollisionExit2DEvent;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_OnCollisionExit2DEvent_18(ref object o, object v)
        {
            ((LuaFramework.ILBehaviour)o).OnCollisionExit2DEvent = (System.Action<UnityEngine.Collision2D>)v;
        }

        static StackObject* AssignFromStack_OnCollisionExit2DEvent_18(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action<UnityEngine.Collision2D> @OnCollisionExit2DEvent = (System.Action<UnityEngine.Collision2D>)typeof(System.Action<UnityEngine.Collision2D>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.ILBehaviour)o).OnCollisionExit2DEvent = @OnCollisionExit2DEvent;
            return ptr_of_this_method;
        }

        static object get_OnCollisionStay2DEvent_19(ref object o)
        {
            return ((LuaFramework.ILBehaviour)o).OnCollisionStay2DEvent;
        }

        static StackObject* CopyToStack_OnCollisionStay2DEvent_19(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.ILBehaviour)o).OnCollisionStay2DEvent;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_OnCollisionStay2DEvent_19(ref object o, object v)
        {
            ((LuaFramework.ILBehaviour)o).OnCollisionStay2DEvent = (System.Action<UnityEngine.Collision2D>)v;
        }

        static StackObject* AssignFromStack_OnCollisionStay2DEvent_19(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action<UnityEngine.Collision2D> @OnCollisionStay2DEvent = (System.Action<UnityEngine.Collision2D>)typeof(System.Action<UnityEngine.Collision2D>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.ILBehaviour)o).OnCollisionStay2DEvent = @OnCollisionStay2DEvent;
            return ptr_of_this_method;
        }

        static object get_OnTriggerEnter2DEvent_20(ref object o)
        {
            return ((LuaFramework.ILBehaviour)o).OnTriggerEnter2DEvent;
        }

        static StackObject* CopyToStack_OnTriggerEnter2DEvent_20(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.ILBehaviour)o).OnTriggerEnter2DEvent;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_OnTriggerEnter2DEvent_20(ref object o, object v)
        {
            ((LuaFramework.ILBehaviour)o).OnTriggerEnter2DEvent = (System.Action<UnityEngine.Collider2D>)v;
        }

        static StackObject* AssignFromStack_OnTriggerEnter2DEvent_20(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action<UnityEngine.Collider2D> @OnTriggerEnter2DEvent = (System.Action<UnityEngine.Collider2D>)typeof(System.Action<UnityEngine.Collider2D>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.ILBehaviour)o).OnTriggerEnter2DEvent = @OnTriggerEnter2DEvent;
            return ptr_of_this_method;
        }

        static object get_OnTriggerExit2DEvent_21(ref object o)
        {
            return ((LuaFramework.ILBehaviour)o).OnTriggerExit2DEvent;
        }

        static StackObject* CopyToStack_OnTriggerExit2DEvent_21(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.ILBehaviour)o).OnTriggerExit2DEvent;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_OnTriggerExit2DEvent_21(ref object o, object v)
        {
            ((LuaFramework.ILBehaviour)o).OnTriggerExit2DEvent = (System.Action<UnityEngine.Collider2D>)v;
        }

        static StackObject* AssignFromStack_OnTriggerExit2DEvent_21(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action<UnityEngine.Collider2D> @OnTriggerExit2DEvent = (System.Action<UnityEngine.Collider2D>)typeof(System.Action<UnityEngine.Collider2D>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.ILBehaviour)o).OnTriggerExit2DEvent = @OnTriggerExit2DEvent;
            return ptr_of_this_method;
        }

        static object get_OnTriggerStay2DEvent_22(ref object o)
        {
            return ((LuaFramework.ILBehaviour)o).OnTriggerStay2DEvent;
        }

        static StackObject* CopyToStack_OnTriggerStay2DEvent_22(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.ILBehaviour)o).OnTriggerStay2DEvent;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_OnTriggerStay2DEvent_22(ref object o, object v)
        {
            ((LuaFramework.ILBehaviour)o).OnTriggerStay2DEvent = (System.Action<UnityEngine.Collider2D>)v;
        }

        static StackObject* AssignFromStack_OnTriggerStay2DEvent_22(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action<UnityEngine.Collider2D> @OnTriggerStay2DEvent = (System.Action<UnityEngine.Collider2D>)typeof(System.Action<UnityEngine.Collider2D>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.ILBehaviour)o).OnTriggerStay2DEvent = @OnTriggerStay2DEvent;
            return ptr_of_this_method;
        }

        static object get_AwakeEvent_23(ref object o)
        {
            return ((LuaFramework.ILBehaviour)o).AwakeEvent;
        }

        static StackObject* CopyToStack_AwakeEvent_23(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.ILBehaviour)o).AwakeEvent;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_AwakeEvent_23(ref object o, object v)
        {
            ((LuaFramework.ILBehaviour)o).AwakeEvent = (System.Action)v;
        }

        static StackObject* AssignFromStack_AwakeEvent_23(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action @AwakeEvent = (System.Action)typeof(System.Action).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.ILBehaviour)o).AwakeEvent = @AwakeEvent;
            return ptr_of_this_method;
        }

        static object get_StartEvent_24(ref object o)
        {
            return ((LuaFramework.ILBehaviour)o).StartEvent;
        }

        static StackObject* CopyToStack_StartEvent_24(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.ILBehaviour)o).StartEvent;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_StartEvent_24(ref object o, object v)
        {
            ((LuaFramework.ILBehaviour)o).StartEvent = (System.Action)v;
        }

        static StackObject* AssignFromStack_StartEvent_24(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action @StartEvent = (System.Action)typeof(System.Action).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.ILBehaviour)o).StartEvent = @StartEvent;
            return ptr_of_this_method;
        }



    }
}
