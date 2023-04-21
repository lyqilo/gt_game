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
    unsafe class LuaFramework_Session_Binding
    {
        public static void Register(ILRuntime.Runtime.Enviorment.AppDomain app)
        {
            BindingFlags flag = BindingFlags.Public | BindingFlags.Instance | BindingFlags.Static | BindingFlags.DeclaredOnly;
            MethodBase method;
            FieldInfo field;
            Type[] args;
            Type type = typeof(LuaFramework.Session);
            args = new Type[]{typeof(System.UInt16), typeof(System.UInt16), typeof(LuaFramework.ByteBuffer)};
            method = type.GetMethod("Send", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, Send_0);
            args = new Type[]{};
            method = type.GetMethod("Dispose", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, Dispose_1);

            field = type.GetField("Id", flag);
            app.RegisterCLRFieldGetter(field, get_Id_0);
            app.RegisterCLRFieldSetter(field, set_Id_0);
            app.RegisterCLRFieldBinding(field, CopyToStack_Id_0, AssignFromStack_Id_0);
            field = type.GetField("run", flag);
            app.RegisterCLRFieldGetter(field, get_run_1);
            app.RegisterCLRFieldSetter(field, set_run_1);
            app.RegisterCLRFieldBinding(field, CopyToStack_run_1, AssignFromStack_run_1);
            field = type.GetField("CloseFunc", flag);
            app.RegisterCLRFieldGetter(field, get_CloseFunc_2);
            app.RegisterCLRFieldSetter(field, set_CloseFunc_2);
            app.RegisterCLRFieldBinding(field, CopyToStack_CloseFunc_2, AssignFromStack_CloseFunc_2);
            field = type.GetField("CallBack", flag);
            app.RegisterCLRFieldGetter(field, get_CallBack_3);
            app.RegisterCLRFieldSetter(field, set_CallBack_3);
            app.RegisterCLRFieldBinding(field, CopyToStack_CallBack_3, AssignFromStack_CallBack_3);

            args = new Type[]{typeof(System.String), typeof(System.Int32), typeof(System.Int32), typeof(System.Int32), typeof(System.Action<System.String, LuaFramework.Session>)};
            method = type.GetConstructor(flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, Ctor_0);

        }


        static StackObject* Send_0(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 4);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            LuaFramework.ByteBuffer @bf = (LuaFramework.ByteBuffer)typeof(LuaFramework.ByteBuffer).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 2);
            System.UInt16 @sid = (ushort)ptr_of_this_method->Value;

            ptr_of_this_method = ILIntepreter.Minus(__esp, 3);
            System.UInt16 @mid = (ushort)ptr_of_this_method->Value;

            ptr_of_this_method = ILIntepreter.Minus(__esp, 4);
            LuaFramework.Session instance_of_this_method = (LuaFramework.Session)typeof(LuaFramework.Session).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);

            var result_of_this_method = instance_of_this_method.Send(@mid, @sid, @bf);

            __ret->ObjectType = ObjectTypes.Integer;
            __ret->Value = result_of_this_method ? 1 : 0;
            return __ret + 1;
        }

        static StackObject* Dispose_1(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 1);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            LuaFramework.Session instance_of_this_method = (LuaFramework.Session)typeof(LuaFramework.Session).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);

            instance_of_this_method.Dispose();

            return __ret;
        }


        static object get_Id_0(ref object o)
        {
            return ((LuaFramework.Session)o).Id;
        }

        static StackObject* CopyToStack_Id_0(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.Session)o).Id;
            __ret->ObjectType = ObjectTypes.Integer;
            __ret->Value = result_of_this_method;
            return __ret + 1;
        }

        static void set_Id_0(ref object o, object v)
        {
            ((LuaFramework.Session)o).Id = (System.Int32)v;
        }

        static StackObject* AssignFromStack_Id_0(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Int32 @Id = ptr_of_this_method->Value;
            ((LuaFramework.Session)o).Id = @Id;
            return ptr_of_this_method;
        }

        static object get_run_1(ref object o)
        {
            return ((LuaFramework.Session)o).run;
        }

        static StackObject* CopyToStack_run_1(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.Session)o).run;
            __ret->ObjectType = ObjectTypes.Integer;
            __ret->Value = result_of_this_method ? 1 : 0;
            return __ret + 1;
        }

        static void set_run_1(ref object o, object v)
        {
            ((LuaFramework.Session)o).run = (System.Boolean)v;
        }

        static StackObject* AssignFromStack_run_1(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Boolean @run = ptr_of_this_method->Value == 1;
            ((LuaFramework.Session)o).run = @run;
            return ptr_of_this_method;
        }

        static object get_CloseFunc_2(ref object o)
        {
            return ((LuaFramework.Session)o).CloseFunc;
        }

        static StackObject* CopyToStack_CloseFunc_2(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.Session)o).CloseFunc;
            object obj_result_of_this_method = result_of_this_method;
            if(obj_result_of_this_method is CrossBindingAdaptorType)
            {    
                return ILIntepreter.PushObject(__ret, __mStack, ((CrossBindingAdaptorType)obj_result_of_this_method).ILInstance, true);
            }
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method, true);
        }

        static void set_CloseFunc_2(ref object o, object v)
        {
            ((LuaFramework.Session)o).CloseFunc = (System.Object)v;
        }

        static StackObject* AssignFromStack_CloseFunc_2(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Object @CloseFunc = (System.Object)typeof(System.Object).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            ((LuaFramework.Session)o).CloseFunc = @CloseFunc;
            return ptr_of_this_method;
        }

        static object get_CallBack_3(ref object o)
        {
            return ((LuaFramework.Session)o).CallBack;
        }

        static StackObject* CopyToStack_CallBack_3(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((LuaFramework.Session)o).CallBack;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_CallBack_3(ref object o, object v)
        {
            ((LuaFramework.Session)o).CallBack = (System.Action<System.String>)v;
        }

        static StackObject* AssignFromStack_CallBack_3(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Action<System.String> @CallBack = (System.Action<System.String>)typeof(System.Action<System.String>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            ((LuaFramework.Session)o).CallBack = @CallBack;
            return ptr_of_this_method;
        }


        static StackObject* Ctor_0(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 5);
            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            System.Action<System.String, LuaFramework.Session> @callBack = (System.Action<System.String, LuaFramework.Session>)typeof(System.Action<System.String, LuaFramework.Session>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            __intp.Free(ptr_of_this_method);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 2);
            System.Int32 @timeOut = ptr_of_this_method->Value;

            ptr_of_this_method = ILIntepreter.Minus(__esp, 3);
            System.Int32 @sessionId = ptr_of_this_method->Value;

            ptr_of_this_method = ILIntepreter.Minus(__esp, 4);
            System.Int32 @port = ptr_of_this_method->Value;

            ptr_of_this_method = ILIntepreter.Minus(__esp, 5);
            System.String @host = (System.String)typeof(System.String).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);


            var result_of_this_method = new LuaFramework.Session(@host, @port, @sessionId, @timeOut, @callBack);

            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }


    }
}
