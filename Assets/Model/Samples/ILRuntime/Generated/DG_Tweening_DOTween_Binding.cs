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
    unsafe class DG_Tweening_DOTween_Binding
    {
        public static void Register(ILRuntime.Runtime.Enviorment.AppDomain app)
        {
            BindingFlags flag = BindingFlags.Public | BindingFlags.Instance | BindingFlags.Static | BindingFlags.DeclaredOnly;
            MethodBase method;
            FieldInfo field;
            Type[] args;
            Type type = typeof(DG.Tweening.DOTween);
            args = new Type[]{typeof(DG.Tweening.Core.DOSetter<System.Single>), typeof(System.Single), typeof(System.Single), typeof(System.Single)};
            method = type.GetMethod("To", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, To_0);
            args = new Type[]{};
            method = type.GetMethod("Sequence", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, Sequence_1);

            field = type.GetField("defaultEaseType", flag);
            app.RegisterCLRFieldGetter(field, get_defaultEaseType_0);
            app.RegisterCLRFieldSetter(field, set_defaultEaseType_0);
            app.RegisterCLRFieldBinding(field, CopyToStack_defaultEaseType_0, AssignFromStack_defaultEaseType_0);


        }


        static StackObject* To_0(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 4);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            System.Single @duration = *(float*)&ptr_of_this_method->Value;

            ptr_of_this_method = ILIntepreter.Minus(__esp, 2);
            System.Single @endValue = *(float*)&ptr_of_this_method->Value;

            ptr_of_this_method = ILIntepreter.Minus(__esp, 3);
            System.Single @startValue = *(float*)&ptr_of_this_method->Value;

            ptr_of_this_method = ILIntepreter.Minus(__esp, 4);
            DG.Tweening.Core.DOSetter<System.Single> @setter = (DG.Tweening.Core.DOSetter<System.Single>)typeof(DG.Tweening.Core.DOSetter<System.Single>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            __intp.Free(ptr_of_this_method);


            var result_of_this_method = DG.Tweening.DOTween.To(@setter, @startValue, @endValue, @duration);

            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static StackObject* Sequence_1(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* __ret = ILIntepreter.Minus(__esp, 0);


            var result_of_this_method = DG.Tweening.DOTween.Sequence();

            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }


        static object get_defaultEaseType_0(ref object o)
        {
            return DG.Tweening.DOTween.defaultEaseType;
        }

        static StackObject* CopyToStack_defaultEaseType_0(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = DG.Tweening.DOTween.defaultEaseType;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_defaultEaseType_0(ref object o, object v)
        {
            DG.Tweening.DOTween.defaultEaseType = (DG.Tweening.Ease)v;
        }

        static StackObject* AssignFromStack_defaultEaseType_0(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            DG.Tweening.Ease @defaultEaseType = (DG.Tweening.Ease)typeof(DG.Tweening.Ease).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)20);
            DG.Tweening.DOTween.defaultEaseType = @defaultEaseType;
            return ptr_of_this_method;
        }



    }
}
