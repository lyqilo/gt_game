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
    unsafe class DragonBones_DragonBoneEventDispatcher_Binding
    {
        public static void Register(ILRuntime.Runtime.Enviorment.AppDomain app)
        {
            BindingFlags flag = BindingFlags.Public | BindingFlags.Instance | BindingFlags.Static | BindingFlags.DeclaredOnly;
            MethodBase method;
            Type[] args;
            Type type = typeof(DragonBones.DragonBoneEventDispatcher);
            args = new Type[]{typeof(System.String), typeof(DragonBones.ListenerDelegate<DragonBones.EventObject>)};
            method = type.GetMethod("AddDBEventListener", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, AddDBEventListener_0);
            args = new Type[]{typeof(System.String), typeof(DragonBones.ListenerDelegate<DragonBones.EventObject>)};
            method = type.GetMethod("RemoveDBEventListener", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, RemoveDBEventListener_1);


        }


        static StackObject* AddDBEventListener_0(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 3);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            DragonBones.ListenerDelegate<DragonBones.EventObject> @listener = (DragonBones.ListenerDelegate<DragonBones.EventObject>)typeof(DragonBones.ListenerDelegate<DragonBones.EventObject>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            __intp.Free(ptr_of_this_method);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 2);
            System.String @type = (System.String)typeof(System.String).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 3);
            DragonBones.DragonBoneEventDispatcher instance_of_this_method = (DragonBones.DragonBoneEventDispatcher)typeof(DragonBones.DragonBoneEventDispatcher).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);

            instance_of_this_method.AddDBEventListener(@type, @listener);

            return __ret;
        }

        static StackObject* RemoveDBEventListener_1(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 3);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            DragonBones.ListenerDelegate<DragonBones.EventObject> @listener = (DragonBones.ListenerDelegate<DragonBones.EventObject>)typeof(DragonBones.ListenerDelegate<DragonBones.EventObject>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            __intp.Free(ptr_of_this_method);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 2);
            System.String @type = (System.String)typeof(System.String).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 3);
            DragonBones.DragonBoneEventDispatcher instance_of_this_method = (DragonBones.DragonBoneEventDispatcher)typeof(DragonBones.DragonBoneEventDispatcher).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);

            instance_of_this_method.RemoveDBEventListener(@type, @listener);

            return __ret;
        }



    }
}
