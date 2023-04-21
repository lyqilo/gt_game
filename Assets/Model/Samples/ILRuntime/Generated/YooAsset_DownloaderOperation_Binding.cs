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
    unsafe class YooAsset_DownloaderOperation_Binding
    {
        public static void Register(ILRuntime.Runtime.Enviorment.AppDomain app)
        {
            BindingFlags flag = BindingFlags.Public | BindingFlags.Instance | BindingFlags.Static | BindingFlags.DeclaredOnly;
            MethodBase method;
            Type[] args;
            Type type = typeof(YooAsset.DownloaderOperation);
            args = new Type[]{};
            method = type.GetMethod("get_TotalDownloadCount", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, get_TotalDownloadCount_0);
            args = new Type[]{};
            method = type.GetMethod("get_TotalDownloadBytes", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, get_TotalDownloadBytes_1);
            args = new Type[]{typeof(YooAsset.DownloaderOperation.OnDownloadError)};
            method = type.GetMethod("set_OnDownloadErrorCallback", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, set_OnDownloadErrorCallback_2);
            args = new Type[]{typeof(YooAsset.DownloaderOperation.OnDownloadProgress)};
            method = type.GetMethod("set_OnDownloadProgressCallback", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, set_OnDownloadProgressCallback_3);
            args = new Type[]{typeof(YooAsset.DownloaderOperation.OnDownloadOver)};
            method = type.GetMethod("set_OnDownloadOverCallback", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, set_OnDownloadOverCallback_4);
            args = new Type[]{typeof(YooAsset.DownloaderOperation.OnStartDownloadFile)};
            method = type.GetMethod("set_OnStartDownloadFileCallback", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, set_OnStartDownloadFileCallback_5);
            args = new Type[]{};
            method = type.GetMethod("BeginDownload", flag, null, args, null);
            app.RegisterCLRMethodRedirection(method, BeginDownload_6);


        }


        static StackObject* get_TotalDownloadCount_0(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 1);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            YooAsset.DownloaderOperation instance_of_this_method = (YooAsset.DownloaderOperation)typeof(YooAsset.DownloaderOperation).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);

            var result_of_this_method = instance_of_this_method.TotalDownloadCount;

            __ret->ObjectType = ObjectTypes.Integer;
            __ret->Value = result_of_this_method;
            return __ret + 1;
        }

        static StackObject* get_TotalDownloadBytes_1(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 1);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            YooAsset.DownloaderOperation instance_of_this_method = (YooAsset.DownloaderOperation)typeof(YooAsset.DownloaderOperation).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);

            var result_of_this_method = instance_of_this_method.TotalDownloadBytes;

            __ret->ObjectType = ObjectTypes.Long;
            *(long*)&__ret->Value = result_of_this_method;
            return __ret + 1;
        }

        static StackObject* set_OnDownloadErrorCallback_2(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 2);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            YooAsset.DownloaderOperation.OnDownloadError @value = (YooAsset.DownloaderOperation.OnDownloadError)typeof(YooAsset.DownloaderOperation.OnDownloadError).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            __intp.Free(ptr_of_this_method);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 2);
            YooAsset.DownloaderOperation instance_of_this_method = (YooAsset.DownloaderOperation)typeof(YooAsset.DownloaderOperation).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);

            instance_of_this_method.OnDownloadErrorCallback = value;

            return __ret;
        }

        static StackObject* set_OnDownloadProgressCallback_3(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 2);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            YooAsset.DownloaderOperation.OnDownloadProgress @value = (YooAsset.DownloaderOperation.OnDownloadProgress)typeof(YooAsset.DownloaderOperation.OnDownloadProgress).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            __intp.Free(ptr_of_this_method);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 2);
            YooAsset.DownloaderOperation instance_of_this_method = (YooAsset.DownloaderOperation)typeof(YooAsset.DownloaderOperation).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);

            instance_of_this_method.OnDownloadProgressCallback = value;

            return __ret;
        }

        static StackObject* set_OnDownloadOverCallback_4(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 2);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            YooAsset.DownloaderOperation.OnDownloadOver @value = (YooAsset.DownloaderOperation.OnDownloadOver)typeof(YooAsset.DownloaderOperation.OnDownloadOver).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            __intp.Free(ptr_of_this_method);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 2);
            YooAsset.DownloaderOperation instance_of_this_method = (YooAsset.DownloaderOperation)typeof(YooAsset.DownloaderOperation).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);

            instance_of_this_method.OnDownloadOverCallback = value;

            return __ret;
        }

        static StackObject* set_OnStartDownloadFileCallback_5(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 2);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            YooAsset.DownloaderOperation.OnStartDownloadFile @value = (YooAsset.DownloaderOperation.OnStartDownloadFile)typeof(YooAsset.DownloaderOperation.OnStartDownloadFile).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)8);
            __intp.Free(ptr_of_this_method);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 2);
            YooAsset.DownloaderOperation instance_of_this_method = (YooAsset.DownloaderOperation)typeof(YooAsset.DownloaderOperation).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);

            instance_of_this_method.OnStartDownloadFileCallback = value;

            return __ret;
        }

        static StackObject* BeginDownload_6(ILIntepreter __intp, StackObject* __esp, AutoList __mStack, CLRMethod __method, bool isNewObj)
        {
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;
            StackObject* ptr_of_this_method;
            StackObject* __ret = ILIntepreter.Minus(__esp, 1);

            ptr_of_this_method = ILIntepreter.Minus(__esp, 1);
            YooAsset.DownloaderOperation instance_of_this_method = (YooAsset.DownloaderOperation)typeof(YooAsset.DownloaderOperation).CheckCLRTypes(StackObject.ToObject(ptr_of_this_method, __domain, __mStack), (CLR.Utils.Extensions.TypeFlags)0);
            __intp.Free(ptr_of_this_method);

            instance_of_this_method.BeginDownload();

            return __ret;
        }



    }
}
