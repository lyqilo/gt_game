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
    unsafe class YooAsset_InitializeParameters_Binding
    {
        public static void Register(ILRuntime.Runtime.Enviorment.AppDomain app)
        {
            BindingFlags flag = BindingFlags.Public | BindingFlags.Instance | BindingFlags.Static | BindingFlags.DeclaredOnly;
            FieldInfo field;
            Type[] args;
            Type type = typeof(YooAsset.InitializeParameters);

            field = type.GetField("DecryptionServices", flag);
            app.RegisterCLRFieldGetter(field, get_DecryptionServices_0);
            app.RegisterCLRFieldSetter(field, set_DecryptionServices_0);
            app.RegisterCLRFieldBinding(field, CopyToStack_DecryptionServices_0, AssignFromStack_DecryptionServices_0);


        }



        static object get_DecryptionServices_0(ref object o)
        {
            return ((YooAsset.InitializeParameters)o).DecryptionServices;
        }

        static StackObject* CopyToStack_DecryptionServices_0(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((YooAsset.InitializeParameters)o).DecryptionServices;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_DecryptionServices_0(ref object o, object v)
        {
            ((YooAsset.InitializeParameters)o).DecryptionServices = (YooAsset.IDecryptionServices)v;
        }

        static StackObject* AssignFromStack_DecryptionServices_0(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            YooAsset.IDecryptionServices @DecryptionServices = (YooAsset.IDecryptionServices)typeof(YooAsset.IDecryptionServices).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            ((YooAsset.InitializeParameters)o).DecryptionServices = @DecryptionServices;
            return ptr_of_this_method;
        }



    }
}
