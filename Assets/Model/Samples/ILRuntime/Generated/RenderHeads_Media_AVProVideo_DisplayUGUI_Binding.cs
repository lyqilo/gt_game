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
    unsafe class RenderHeads_Media_AVProVideo_DisplayUGUI_Binding
    {
        public static void Register(ILRuntime.Runtime.Enviorment.AppDomain app)
        {
            BindingFlags flag = BindingFlags.Public | BindingFlags.Instance | BindingFlags.Static | BindingFlags.DeclaredOnly;
            FieldInfo field;
            Type[] args;
            Type type = typeof(RenderHeads.Media.AVProVideo.DisplayUGUI);

            field = type.GetField("_mediaPlayer", flag);
            app.RegisterCLRFieldGetter(field, get__mediaPlayer_0);
            app.RegisterCLRFieldSetter(field, set__mediaPlayer_0);
            app.RegisterCLRFieldBinding(field, CopyToStack__mediaPlayer_0, AssignFromStack__mediaPlayer_0);


        }



        static object get__mediaPlayer_0(ref object o)
        {
            return ((RenderHeads.Media.AVProVideo.DisplayUGUI)o)._mediaPlayer;
        }

        static StackObject* CopyToStack__mediaPlayer_0(ref object o, ILIntepreter __intp, StackObject* __ret, AutoList __mStack)
        {
            var result_of_this_method = ((RenderHeads.Media.AVProVideo.DisplayUGUI)o)._mediaPlayer;
            object obj_result_of_this_method = result_of_this_method;
            if(obj_result_of_this_method is CrossBindingAdaptorType)
            {    
                return ILIntepreter.PushObject(__ret, __mStack, ((CrossBindingAdaptorType)obj_result_of_this_method).ILInstance);
            }
            return ILIntepreter.PushObject(__ret, __mStack, result_of_this_method);
        }

        static void set__mediaPlayer_0(ref object o, object v)
        {
            ((RenderHeads.Media.AVProVideo.DisplayUGUI)o)._mediaPlayer = (RenderHeads.Media.AVProVideo.MediaPlayer)v;
        }

        static StackObject* AssignFromStack__mediaPlayer_0(ref object o, ILIntepreter __intp, StackObject* ptr_of_this_method, AutoList __mStack)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            RenderHeads.Media.AVProVideo.MediaPlayer @_mediaPlayer = (RenderHeads.Media.AVProVideo.MediaPlayer)typeof(RenderHeads.Media.AVProVideo.MediaPlayer).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            ((RenderHeads.Media.AVProVideo.DisplayUGUI)o)._mediaPlayer = @_mediaPlayer;
            return ptr_of_this_method;
        }



    }
}
