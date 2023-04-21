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
    unsafe class RenderHeads_Media_AVProVideo_MediaPlayer_Binding
    {
        public static void Register(ILRuntime.Runtime.Enviorment.AppDomain app)
        {
            BindingFlags flag = BindingFlags.Public | BindingFlags.Instance | BindingFlags.Static | BindingFlags.DeclaredOnly;
            MethodBase method;
            FieldInfo field;
            Type[] args;
            Type type = typeof(RenderHeads.Media.AVProVideo.MediaPlayer);
            args = new Type[]{};
            method = type.GetMethod("Play", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, Play_0);
            args = new Type[]{};
            method = type.GetMethod("Stop", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, Stop_1);

            field = type.GetField("m_AutoStart", flag);
            app.RegisterCLRFieldGetter(field, get_m_AutoStart_0);
            app.RegisterCLRFieldSetter(field, set_m_AutoStart_0);
            app.RegisterCLRFieldBinding(field, CopyToStack_m_AutoStart_0, AssignFromStack_m_AutoStart_0);
            field = type.GetField("m_VideoLocation", flag);
            app.RegisterCLRFieldGetter(field, get_m_VideoLocation_1);
            app.RegisterCLRFieldSetter(field, set_m_VideoLocation_1);
            app.RegisterCLRFieldBinding(field, CopyToStack_m_VideoLocation_1, AssignFromStack_m_VideoLocation_1);
            field = type.GetField("m_VideoPath", flag);
            app.RegisterCLRFieldGetter(field, get_m_VideoPath_2);
            app.RegisterCLRFieldSetter(field, set_m_VideoPath_2);
            app.RegisterCLRFieldBinding(field, CopyToStack_m_VideoPath_2, AssignFromStack_m_VideoPath_2);
            field = type.GetField("m_Volume", flag);
            app.RegisterCLRFieldGetter(field, get_m_Volume_3);
            app.RegisterCLRFieldSetter(field, set_m_Volume_3);
            app.RegisterCLRFieldBinding(field, CopyToStack_m_Volume_3, AssignFromStack_m_Volume_3);
            field = type.GetField("m_Muted", flag);
            app.RegisterCLRFieldGetter(field, get_m_Muted_4);
            app.RegisterCLRFieldSetter(field, set_m_Muted_4);
            app.RegisterCLRFieldBinding(field, CopyToStack_m_Muted_4, AssignFromStack_m_Muted_4);
            field = type.GetField("m_Loop", flag);
            app.RegisterCLRFieldGetter(field, get_m_Loop_5);
            app.RegisterCLRFieldSetter(field, set_m_Loop_5);
            app.RegisterCLRFieldBinding(field, CopyToStack_m_Loop_5, AssignFromStack_m_Loop_5);


        }


        static StackObject* Play_0(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 1);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            RenderHeads.Media.AVProVideo.MediaPlayer instance_of_this_method = (RenderHeads.Media.AVProVideo.MediaPlayer)typeof(RenderHeads.Media.AVProVideo.MediaPlayer).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);

            instance_of_this_method.Play();

            return __ret;
        }

        static StackObject* Stop_1(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 1);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            RenderHeads.Media.AVProVideo.MediaPlayer instance_of_this_method = (RenderHeads.Media.AVProVideo.MediaPlayer)typeof(RenderHeads.Media.AVProVideo.MediaPlayer).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);

            instance_of_this_method.Stop();

            return __ret;
        }


        static object get_m_AutoStart_0(ref object o)
        {
            return ((RenderHeads.Media.AVProVideo.MediaPlayer)o).m_AutoStart;
        }

        static StackObject* CopyToStack_m_AutoStart_0(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((RenderHeads.Media.AVProVideo.MediaPlayer)o).m_AutoStart;
            __ret->ObjectType = ObjectTypes.Integer;
            __ret->Value = result_of_this_method ? 1 : 0;
            return __ret + 1;
        }

        static void set_m_AutoStart_0(ref object o, object v)
        {
            ((RenderHeads.Media.AVProVideo.MediaPlayer)o).m_AutoStart = (System.Boolean)v;
        }

        static StackObject* AssignFromStack_m_AutoStart_0(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Boolean @m_AutoStart = ptr_of_this_method->Value == 1;
            ((RenderHeads.Media.AVProVideo.MediaPlayer)o).m_AutoStart = @m_AutoStart;
            return ptr_of_this_method;
        }

        static object get_m_VideoLocation_1(ref object o)
        {
            return ((RenderHeads.Media.AVProVideo.MediaPlayer)o).m_VideoLocation;
        }

        static StackObject* CopyToStack_m_VideoLocation_1(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((RenderHeads.Media.AVProVideo.MediaPlayer)o).m_VideoLocation;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_m_VideoLocation_1(ref object o, object v)
        {
            ((RenderHeads.Media.AVProVideo.MediaPlayer)o).m_VideoLocation = (RenderHeads.Media.AVProVideo.MediaPlayer.FileLocation)v;
        }

        static StackObject* AssignFromStack_m_VideoLocation_1(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            RenderHeads.Media.AVProVideo.MediaPlayer.FileLocation @m_VideoLocation = (RenderHeads.Media.AVProVideo.MediaPlayer.FileLocation)typeof(RenderHeads.Media.AVProVideo.MediaPlayer.FileLocation).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)20);
            ((RenderHeads.Media.AVProVideo.MediaPlayer)o).m_VideoLocation = @m_VideoLocation;
            return ptr_of_this_method;
        }

        static object get_m_VideoPath_2(ref object o)
        {
            return ((RenderHeads.Media.AVProVideo.MediaPlayer)o).m_VideoPath;
        }

        static StackObject* CopyToStack_m_VideoPath_2(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((RenderHeads.Media.AVProVideo.MediaPlayer)o).m_VideoPath;
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set_m_VideoPath_2(ref object o, object v)
        {
            ((RenderHeads.Media.AVProVideo.MediaPlayer)o).m_VideoPath = (System.String)v;
        }

        static StackObject* AssignFromStack_m_VideoPath_2(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.String @m_VideoPath = (System.String)typeof(System.String).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            ((RenderHeads.Media.AVProVideo.MediaPlayer)o).m_VideoPath = @m_VideoPath;
            return ptr_of_this_method;
        }

        static object get_m_Volume_3(ref object o)
        {
            return ((RenderHeads.Media.AVProVideo.MediaPlayer)o).m_Volume;
        }

        static StackObject* CopyToStack_m_Volume_3(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((RenderHeads.Media.AVProVideo.MediaPlayer)o).m_Volume;
            __ret->ObjectType = ObjectTypes.Float;
            *(float*)&__ret->Value = result_of_this_method;
            return __ret + 1;
        }

        static void set_m_Volume_3(ref object o, object v)
        {
            ((RenderHeads.Media.AVProVideo.MediaPlayer)o).m_Volume = (System.Single)v;
        }

        static StackObject* AssignFromStack_m_Volume_3(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Single @m_Volume = *(float*)&ptr_of_this_method->Value;
            ((RenderHeads.Media.AVProVideo.MediaPlayer)o).m_Volume = @m_Volume;
            return ptr_of_this_method;
        }

        static object get_m_Muted_4(ref object o)
        {
            return ((RenderHeads.Media.AVProVideo.MediaPlayer)o).m_Muted;
        }

        static StackObject* CopyToStack_m_Muted_4(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((RenderHeads.Media.AVProVideo.MediaPlayer)o).m_Muted;
            __ret->ObjectType = ObjectTypes.Integer;
            __ret->Value = result_of_this_method ? 1 : 0;
            return __ret + 1;
        }

        static void set_m_Muted_4(ref object o, object v)
        {
            ((RenderHeads.Media.AVProVideo.MediaPlayer)o).m_Muted = (System.Boolean)v;
        }

        static StackObject* AssignFromStack_m_Muted_4(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Boolean @m_Muted = ptr_of_this_method->Value == 1;
            ((RenderHeads.Media.AVProVideo.MediaPlayer)o).m_Muted = @m_Muted;
            return ptr_of_this_method;
        }

        static object get_m_Loop_5(ref object o)
        {
            return ((RenderHeads.Media.AVProVideo.MediaPlayer)o).m_Loop;
        }

        static StackObject* CopyToStack_m_Loop_5(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((RenderHeads.Media.AVProVideo.MediaPlayer)o).m_Loop;
            __ret->ObjectType = ObjectTypes.Integer;
            __ret->Value = result_of_this_method ? 1 : 0;
            return __ret + 1;
        }

        static void set_m_Loop_5(ref object o, object v)
        {
            ((RenderHeads.Media.AVProVideo.MediaPlayer)o).m_Loop = (System.Boolean)v;
        }

        static StackObject* AssignFromStack_m_Loop_5(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            System.Boolean @m_Loop = ptr_of_this_method->Value == 1;
            ((RenderHeads.Media.AVProVideo.MediaPlayer)o).m_Loop = @m_Loop;
            return ptr_of_this_method;
        }



    }
}
