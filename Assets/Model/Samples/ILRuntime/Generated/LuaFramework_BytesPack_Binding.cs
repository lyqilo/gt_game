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
    unsafe class LuaFramework_BytesPack_Binding
    {
        public static void Register(ILRuntime.Runtime.Enviorment.AppDomain app)
        {
            BindingFlags flag = BindingFlags.Public | BindingFlags.Instance | BindingFlags.Static | BindingFlags.DeclaredOnly;
            FieldInfo field;
            Type[] args;
            Type type = typeof(LuaFramework.BytesPack);

            field = type.GetField("session", flag);
            app.RegisterCLRFieldGetter(field, get_session_0);
            app.RegisterCLRFieldSetter(field, set_session_0);
            app.RegisterCLRFieldBinding(field, CopyToStack_session_0, AssignFromStack_session_0);
            field = type.GetField("mid", flag);
            app.RegisterCLRFieldGetter(field, get_mid_1);
            app.RegisterCLRFieldSetter(field, set_mid_1);
            app.RegisterCLRFieldBinding(field, CopyToStack_mid_1, AssignFromStack_mid_1);
            field = type.GetField("sid", flag);
            app.RegisterCLRFieldGetter(field, get_sid_2);
            app.RegisterCLRFieldSetter(field, set_sid_2);
            app.RegisterCLRFieldBinding(field, CopyToStack_sid_2, AssignFromStack_sid_2);
            field = type.GetField("bytes", flag);
            app.RegisterCLRFieldGetter(field, get_bytes_3);
            app.RegisterCLRFieldSetter(field, set_bytes_3);
            app.RegisterCLRFieldBinding(field, CopyToStack_bytes_3, AssignFromStack_bytes_3);

            app.RegisterCLRCreateDefaultInstance(type, () => new LuaFramework.BytesPack());


        }

        static void WriteBackInstance(ILRuntime.Runtime.Enviorment.AppDomain __domain, StackObject* ptr_of_this_method, AutoList __mStack, ref LuaFramework.BytesPack instance_of_this_method)
        {
            ptr_of_this_method = ILIntepreter.GetObjectAndResolveReference(ptr_of_this_method);
            switch(ptr_of_this_method->ObjectType)
            {
                case ObjectTypes.Object:
                    {
                        __mStack[ptr_of_this_method->Value] = instance_of_this_method;
                    }
                    break;
                case ObjectTypes.FieldReference:
                    {
                        var ___obj = __mStack[ptr_of_this_method->Value];
                        if(___obj is ILTypeInstance)
                        {
                            ((ILTypeInstance)___obj)[ptr_of_this_method->ValueLow] = instance_of_this_method;
                        }
                        else
                        {
                            var t = __domain.GetType(___obj.GetType()) as CLRType;
                            t.SetFieldValue(ptr_of_this_method->ValueLow, ref ___obj, instance_of_this_method);
                        }
                    }
                    break;
                case ObjectTypes.StaticFieldReference:
                    {
                        var t = __domain.GetType(ptr_of_this_method->Value);
                        if(t is ILType)
                        {
                            ((ILType)t).StaticInstance[ptr_of_this_method->ValueLow] = instance_of_this_method;
                        }
                        else
                        {
                            ((CLRType)t).SetStaticFieldValue(ptr_of_this_method->ValueLow, instance_of_this_method);
                        }
                    }
                    break;
                 case ObjectTypes.ArrayReference:
                    {
                        var instance_of_arrayReference = __mStack[ptr_of_this_method->Value] as LuaFramework.BytesPack[];
                        instance_of_arrayReference[ptr_of_this_method->ValueLow] = instance_of_this_method;
                    }
                    break;
            }
        }


        static object get_session_0(ref object o)
        {
            return ((LuaFramework.BytesPack)o).session;
        }

        static StackObject* CopyToStack_session_0(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.BytesPack)o).session;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_session_0(ref object o, object v)
        {
            LuaFramework.BytesPack ins =(LuaFramework.BytesPack)o;
            ins.session = (LuaFramework.Session)v;
            o = ins;
        }

        static StackObject* AssignFromStack_session_0(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            LuaFramework.Session @session = (LuaFramework.Session)typeof(LuaFramework.Session).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            LuaFramework.BytesPack ins =(LuaFramework.BytesPack)o;
            ins.session = @session;
            o = ins;
            return ptr_of_this_method;
        }

        static object get_mid_1(ref object o)
        {
            return ((LuaFramework.BytesPack)o).mid;
        }

        static StackObject* CopyToStack_mid_1(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.BytesPack)o).mid;
            __ret->ObjectType = ObjectTypes.Integer;
            __ret->Value = result_of_this_method;
            return __ret + 1;
        }

        static void set_mid_1(ref object o, object v)
        {
            LuaFramework.BytesPack ins =(LuaFramework.BytesPack)o;
            ins.mid = (System.Int32)v;
            o = ins;
        }

        static StackObject* AssignFromStack_mid_1(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Int32 @mid = ptr_of_this_method->Value;
            LuaFramework.BytesPack ins =(LuaFramework.BytesPack)o;
            ins.mid = @mid;
            o = ins;
            return ptr_of_this_method;
        }

        static object get_sid_2(ref object o)
        {
            return ((LuaFramework.BytesPack)o).sid;
        }

        static StackObject* CopyToStack_sid_2(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.BytesPack)o).sid;
            __ret->ObjectType = ObjectTypes.Integer;
            __ret->Value = result_of_this_method;
            return __ret + 1;
        }

        static void set_sid_2(ref object o, object v)
        {
            LuaFramework.BytesPack ins =(LuaFramework.BytesPack)o;
            ins.sid = (System.Int32)v;
            o = ins;
        }

        static StackObject* AssignFromStack_sid_2(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Int32 @sid = ptr_of_this_method->Value;
            LuaFramework.BytesPack ins =(LuaFramework.BytesPack)o;
            ins.sid = @sid;
            o = ins;
            return ptr_of_this_method;
        }

        static object get_bytes_3(ref object o)
        {
            return ((LuaFramework.BytesPack)o).bytes;
        }

        static StackObject* CopyToStack_bytes_3(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.BytesPack)o).bytes;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_bytes_3(ref object o, object v)
        {
            LuaFramework.BytesPack ins =(LuaFramework.BytesPack)o;
            ins.bytes = (System.Byte[])v;
            o = ins;
        }

        static StackObject* AssignFromStack_bytes_3(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Byte[] @bytes = (System.Byte[])typeof(System.Byte[]).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            LuaFramework.BytesPack ins =(LuaFramework.BytesPack)o;
            ins.bytes = @bytes;
            o = ins;
            return ptr_of_this_method;
        }



    }
}
