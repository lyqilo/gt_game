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
    unsafe class DragonBones_EventObject_Binding
    {
        public static void Register(ILRuntime.Runtime.Enviorment.AppDomain app)
        {
            BindingFlags flag = BindingFlags.Public | BindingFlags.Instance | BindingFlags.Static | BindingFlags.DeclaredOnly;
            FieldInfo field;
            Type[] args;
            Type type = typeof(DragonBones.EventObject);

            field = type.GetField("animationState", flag);
            app.RegisterCLRFieldGetter(field, get_animationState_0);
            app.RegisterCLRFieldSetter(field, set_animationState_0);
            app.RegisterCLRFieldBinding(field, CopyToStack_animationState_0, AssignFromStack_animationState_0);


        }



        static object get_animationState_0(ref object o)
        {
            return ((DragonBones.EventObject)o).animationState;
        }

        static StackObject* CopyToStack_animationState_0(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((DragonBones.EventObject)o).animationState;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_animationState_0(ref object o, object v)
        {
            ((DragonBones.EventObject)o).animationState = (DragonBones.AnimationState)v;
        }

        static StackObject* AssignFromStack_animationState_0(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            DragonBones.AnimationState @animationState = (DragonBones.AnimationState)typeof(DragonBones.AnimationState).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            ((DragonBones.EventObject)o).animationState = @animationState;
            return ptr_of_this_method;
        }



    }
}
