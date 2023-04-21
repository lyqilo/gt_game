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
    unsafe class EventHelper_Binding
    {
        public static void Register(ILRuntime.Runtime.Enviorment.AppDomain app)
        {
            BindingFlags flag = BindingFlags.Public | BindingFlags.Instance | BindingFlags.Static | BindingFlags.DeclaredOnly;
            MethodBase method;
            Type[] args;
            Type type = typeof(global::EventHelper);
            args = new Type[]{typeof(System.Action<LuaFramework.BytesPack>)};
            method = type.GetMethod("add_OnSocketReceive", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, add_OnSocketReceive_0);
            args = new Type[]{typeof(System.Action<System.String>)};
            method = type.GetMethod("add_OnEnterGame", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, add_OnEnterGame_1);
            args = new Type[]{typeof(System.Action)};
            method = type.GetMethod("add_LeaveGame", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, add_LeaveGame_2);
            args = new Type[]{typeof(System.Action<System.String>)};
            method = type.GetMethod("remove_OnEnterGame", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, remove_OnEnterGame_3);
            args = new Type[]{typeof(System.Action<LuaFramework.BytesPack>)};
            method = type.GetMethod("remove_OnSocketReceive", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, remove_OnSocketReceive_4);
            args = new Type[]{typeof(System.Action)};
            method = type.GetMethod("remove_LeaveGame", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, remove_LeaveGame_5);
            args = new Type[]{};
            method = type.GetMethod("DispatchLeaveGame", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, DispatchLeaveGame_6);
            args = new Type[]{typeof(UnityEngine.UI.Button.ButtonClickedEvent), typeof(System.Action)};
            method = type.GetMethod("Add", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, Add_7);
            args = new Type[]{typeof(UnityEngine.UI.Slider.SliderEvent), typeof(System.Action<System.Single>)};
            method = type.GetMethod("Add", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, Add_8);
            args = new Type[]{typeof(UnityEngine.UI.Scrollbar.ScrollEvent), typeof(System.Action<System.Single>)};
            method = type.GetMethod("Add", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, Add_9);
            args = new Type[]{typeof(UnityEngine.UI.ScrollRect.ScrollRectEvent), typeof(System.Action<UnityEngine.Vector2>)};
            method = type.GetMethod("Add", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, Add_10);
            args = new Type[]{typeof(UnityEngine.UI.Dropdown.DropdownEvent), typeof(System.Action<System.Int32>)};
            method = type.GetMethod("Add", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, Add_11);
            args = new Type[]{typeof(TMPro.TMP_Dropdown.DropdownEvent), typeof(System.Action<System.Int32>)};
            method = type.GetMethod("Add", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, Add_12);
            args = new Type[]{typeof(UnityEngine.UI.InputField.OnChangeEvent), typeof(System.Action<System.String>)};
            method = type.GetMethod("Add", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, Add_13);
            args = new Type[]{typeof(UnityEngine.UI.InputField.SubmitEvent), typeof(System.Action<System.String>)};
            method = type.GetMethod("Add", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, Add_14);
            args = new Type[]{typeof(TMPro.TMP_InputField.OnChangeEvent), typeof(System.Action<System.String>)};
            method = type.GetMethod("Add", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, Add_15);
            args = new Type[]{typeof(TMPro.TMP_InputField.SubmitEvent), typeof(System.Action<System.String>)};
            method = type.GetMethod("Add", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, Add_16);
            args = new Type[]{typeof(TMPro.TMP_InputField.SelectionEvent), typeof(System.Action<System.String>)};
            method = type.GetMethod("Add", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, Add_17);
            args = new Type[]{typeof(UnityEngine.UI.Toggle.ToggleEvent), typeof(System.Action<System.Boolean>)};
            method = type.GetMethod("Add", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, Add_18);
            args = new Type[]{typeof(RenderHeads.Media.AVProVideo.MediaPlayerEvent), typeof(System.Action<RenderHeads.Media.AVProVideo.MediaPlayer, RenderHeads.Media.AVProVideo.MediaPlayerEvent.EventType, RenderHeads.Media.AVProVideo.ErrorCode>)};
            method = type.GetMethod("Add", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, Add_19);
            args = new Type[]{typeof(System.String)};
            method = type.GetMethod("DispatchOnEnterGame", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, DispatchOnEnterGame_20);


        }


        static StackObject* add_OnSocketReceive_0(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 1);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            System.Action<LuaFramework.BytesPack> @value = (System.Action<LuaFramework.BytesPack>)typeof(System.Action<LuaFramework.BytesPack>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            __intp.Free(ptr_of_this_method);


            global::EventHelper.OnSocketReceive += value;

            return __ret;
        }

        static StackObject* add_OnEnterGame_1(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 1);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            System.Action<System.String> @value = (System.Action<System.String>)typeof(System.Action<System.String>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            __intp.Free(ptr_of_this_method);


            global::EventHelper.OnEnterGame += value;

            return __ret;
        }

        static StackObject* add_LeaveGame_2(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 1);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            System.Action @value = (System.Action)typeof(System.Action).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            __intp.Free(ptr_of_this_method);


            global::EventHelper.LeaveGame += value;

            return __ret;
        }

        static StackObject* remove_OnEnterGame_3(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 1);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            System.Action<System.String> @value = (System.Action<System.String>)typeof(System.Action<System.String>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            __intp.Free(ptr_of_this_method);


            global::EventHelper.OnEnterGame -= value;

            return __ret;
        }

        static StackObject* remove_OnSocketReceive_4(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 1);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            System.Action<LuaFramework.BytesPack> @value = (System.Action<LuaFramework.BytesPack>)typeof(System.Action<LuaFramework.BytesPack>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            __intp.Free(ptr_of_this_method);


            global::EventHelper.OnSocketReceive -= value;

            return __ret;
        }

        static StackObject* remove_LeaveGame_5(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 1);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            System.Action @value = (System.Action)typeof(System.Action).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            __intp.Free(ptr_of_this_method);


            global::EventHelper.LeaveGame -= value;

            return __ret;
        }

        static StackObject* DispatchLeaveGame_6(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* __ret = ILIntepreter.Minus(__esp, 0);


            global::EventHelper.DispatchLeaveGame();

            return __ret;
        }

        static StackObject* Add_7(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 2);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            System.Action @action = (System.Action)typeof(System.Action).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            __intp.Free(ptr_of_this_method);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 2);
            UnityEngine.UI.Button.ButtonClickedEvent @buttonClickedEvent = (UnityEngine.UI.Button.ButtonClickedEvent)typeof(UnityEngine.UI.Button.ButtonClickedEvent).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);


            global::EventHelper.Add(@buttonClickedEvent, @action);

            return __ret;
        }

        static StackObject* Add_8(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 2);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            System.Action<System.Single> @action = (System.Action<System.Single>)typeof(System.Action<System.Single>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            __intp.Free(ptr_of_this_method);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 2);
            UnityEngine.UI.Slider.SliderEvent @sliderEvent = (UnityEngine.UI.Slider.SliderEvent)typeof(UnityEngine.UI.Slider.SliderEvent).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);


            global::EventHelper.Add(@sliderEvent, @action);

            return __ret;
        }

        static StackObject* Add_9(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 2);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            System.Action<System.Single> @action = (System.Action<System.Single>)typeof(System.Action<System.Single>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            __intp.Free(ptr_of_this_method);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 2);
            UnityEngine.UI.Scrollbar.ScrollEvent @scrollEvent = (UnityEngine.UI.Scrollbar.ScrollEvent)typeof(UnityEngine.UI.Scrollbar.ScrollEvent).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);


            global::EventHelper.Add(@scrollEvent, @action);

            return __ret;
        }

        static StackObject* Add_10(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 2);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            System.Action<UnityEngine.Vector2> @action = (System.Action<UnityEngine.Vector2>)typeof(System.Action<UnityEngine.Vector2>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            __intp.Free(ptr_of_this_method);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 2);
            UnityEngine.UI.ScrollRect.ScrollRectEvent @scrollRectEvent = (UnityEngine.UI.ScrollRect.ScrollRectEvent)typeof(UnityEngine.UI.ScrollRect.ScrollRectEvent).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);


            global::EventHelper.Add(@scrollRectEvent, @action);

            return __ret;
        }

        static StackObject* Add_11(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 2);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            System.Action<System.Int32> @action = (System.Action<System.Int32>)typeof(System.Action<System.Int32>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            __intp.Free(ptr_of_this_method);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 2);
            UnityEngine.UI.Dropdown.DropdownEvent @dropdownEvent = (UnityEngine.UI.Dropdown.DropdownEvent)typeof(UnityEngine.UI.Dropdown.DropdownEvent).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);


            global::EventHelper.Add(@dropdownEvent, @action);

            return __ret;
        }

        static StackObject* Add_12(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 2);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            System.Action<System.Int32> @action = (System.Action<System.Int32>)typeof(System.Action<System.Int32>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            __intp.Free(ptr_of_this_method);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 2);
            TMPro.TMP_Dropdown.DropdownEvent @dropdownEvent = (TMPro.TMP_Dropdown.DropdownEvent)typeof(TMPro.TMP_Dropdown.DropdownEvent).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);


            global::EventHelper.Add(@dropdownEvent, @action);

            return __ret;
        }

        static StackObject* Add_13(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 2);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            System.Action<System.String> @action = (System.Action<System.String>)typeof(System.Action<System.String>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            __intp.Free(ptr_of_this_method);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 2);
            UnityEngine.UI.InputField.OnChangeEvent @onChangeEvent = (UnityEngine.UI.InputField.OnChangeEvent)typeof(UnityEngine.UI.InputField.OnChangeEvent).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);


            global::EventHelper.Add(@onChangeEvent, @action);

            return __ret;
        }

        static StackObject* Add_14(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 2);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            System.Action<System.String> @action = (System.Action<System.String>)typeof(System.Action<System.String>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            __intp.Free(ptr_of_this_method);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 2);
            UnityEngine.UI.InputField.SubmitEvent @submitEvent = (UnityEngine.UI.InputField.SubmitEvent)typeof(UnityEngine.UI.InputField.SubmitEvent).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);


            global::EventHelper.Add(@submitEvent, @action);

            return __ret;
        }

        static StackObject* Add_15(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 2);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            System.Action<System.String> @action = (System.Action<System.String>)typeof(System.Action<System.String>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            __intp.Free(ptr_of_this_method);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 2);
            TMPro.TMP_InputField.OnChangeEvent @onChangeEvent = (TMPro.TMP_InputField.OnChangeEvent)typeof(TMPro.TMP_InputField.OnChangeEvent).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);


            global::EventHelper.Add(@onChangeEvent, @action);

            return __ret;
        }

        static StackObject* Add_16(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 2);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            System.Action<System.String> @action = (System.Action<System.String>)typeof(System.Action<System.String>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            __intp.Free(ptr_of_this_method);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 2);
            TMPro.TMP_InputField.SubmitEvent @submitEvent = (TMPro.TMP_InputField.SubmitEvent)typeof(TMPro.TMP_InputField.SubmitEvent).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);


            global::EventHelper.Add(@submitEvent, @action);

            return __ret;
        }

        static StackObject* Add_17(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 2);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            System.Action<System.String> @action = (System.Action<System.String>)typeof(System.Action<System.String>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            __intp.Free(ptr_of_this_method);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 2);
            TMPro.TMP_InputField.SelectionEvent @selectionEvent = (TMPro.TMP_InputField.SelectionEvent)typeof(TMPro.TMP_InputField.SelectionEvent).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);


            global::EventHelper.Add(@selectionEvent, @action);

            return __ret;
        }

        static StackObject* Add_18(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 2);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            System.Action<System.Boolean> @action = (System.Action<System.Boolean>)typeof(System.Action<System.Boolean>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            __intp.Free(ptr_of_this_method);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 2);
            UnityEngine.UI.Toggle.ToggleEvent @toggleEvent = (UnityEngine.UI.Toggle.ToggleEvent)typeof(UnityEngine.UI.Toggle.ToggleEvent).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);


            global::EventHelper.Add(@toggleEvent, @action);

            return __ret;
        }

        static StackObject* Add_19(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 2);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            System.Action<RenderHeads.Media.AVProVideo.MediaPlayer, RenderHeads.Media.AVProVideo.MediaPlayerEvent.EventType, RenderHeads.Media.AVProVideo.ErrorCode> @action = (System.Action<RenderHeads.Media.AVProVideo.MediaPlayer, RenderHeads.Media.AVProVideo.MediaPlayerEvent.EventType, RenderHeads.Media.AVProVideo.ErrorCode>)typeof(System.Action<RenderHeads.Media.AVProVideo.MediaPlayer, RenderHeads.Media.AVProVideo.MediaPlayerEvent.EventType, RenderHeads.Media.AVProVideo.ErrorCode>).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            __intp.Free(ptr_of_this_method);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 2);
            RenderHeads.Media.AVProVideo.MediaPlayerEvent @mediaPlayerEvent = (RenderHeads.Media.AVProVideo.MediaPlayerEvent)typeof(RenderHeads.Media.AVProVideo.MediaPlayerEvent).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);


            global::EventHelper.Add(@mediaPlayerEvent, @action);

            return __ret;
        }

        static StackObject* DispatchOnEnterGame_20(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 1);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            System.String @gameName = (System.String)typeof(System.String).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);


            global::EventHelper.DispatchOnEnterGame(@gameName);

            return __ret;
        }



    }
}
