using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Threading;
using DG.Tweening;
using DG.Tweening.Core;
using DragonBones;
using HybridCLR;
using ILRuntime.CLR.Method;
using ILRuntime.CLR.TypeSystem;
using ILRuntime.Mono.Cecil.Pdb;
using ILRuntime.Runtime;
using ILRuntime.Runtime.Generated;
using ILRuntime.Runtime.Intepreter;
using ILRuntime.Runtime.Stack;
using LitJson;
using RenderHeads.Media.AVProVideo;
using Spine;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

namespace LuaFramework
{
    public class ILRuntimeManager : Manager
    {
        ILRuntime.Runtime.Enviorment.AppDomain _appdomain;
        Assembly _app;
        MemoryStream _fs;

        public const string AesKey = "ILRuntime";
        public bool useHybridCLR = true;
        public override void OnInitialize()
        {
            base.OnInitialize();
            _appdomain = new ILRuntime.Runtime.Enviorment.AppDomain(ILRuntimeJITFlags.JITOnDemand);
            EventHelper.LeaveGame += EventHelperOnLeaveGame;
        }

        private void EventHelperOnLeaveGame()
        {
            // AppFacade.Instance.GetManager<LuaManager>().CallFunction("GameSetsBtnInfo.LuaGameQuit");
        }

        public void LeaveGame()
        {
            EventHelper.DispatchLeaveGame();
        }

        public void LoadHotFix(byte[] dll, byte[] pdb)
        {
            StartCoroutine(LoadHotFixAssembly(dll, pdb));
        }

        IEnumerator LoadHotFixAssembly(byte[] dll, byte[] pdb)
        {
            yield return new WaitForEndOfFrame();
            _fs = new MemoryStream(AES.AESDecrypt(dll, AesKey));
            try
            {
                if (useHybridCLR)
                {
                    _app = Assembly.Load(AES.AESDecrypt(dll, AesKey));
                }
                else
                {
                    _appdomain?.LoadAssembly(_fs, null, new PdbReaderProvider());
                }
            }
            catch
            {
                Debug.LogError("加载热更DLL失败，请确保已经编译过热更DLL");
            }
            InitializeILRuntime();
            SetupCLRRedirection();

            OnHotFixLoaded();
        }
        
        void OnHotFixLoaded()
        {
            try
            {
                if (useHybridCLR)
                {
                    var launchType = _app.GetType("Hotfix.ILLauncher");
                    var method = launchType.GetMethod("Init", BindingFlags.Public | BindingFlags.Static);
                    method?.Invoke(null, null);
                    DebugTool.LogError("加载HybridCLR DLL成功");
                }
                else
                {
                    _appdomain?.Invoke("Hotfix.ILLauncher", "Init", null, null);
                    DebugTool.LogError("加载ILRuntime DLL成功");
                }
            }
            catch (Exception e)
            {
                DebugTool.LogError($"加载DLL异常,{e.Message}");
            }
        }
        private unsafe void SetupCLRRedirection()
        {
            //这里面的通常应该写在InitializeILRuntime，这里为了演示写这里
            var arr = typeof(GameObject).GetMethods();
            foreach (var i in arr)
            {
                if (i.Name == "AddComponent" && i.GetGenericArguments().Length == 1)
                {
                    _appdomain.RegisterCLRMethodRedirection(i, AddComponent);
                }

                if (i.Name == "GetComponent" && i.GetGenericArguments().Length == 1)
                {
                    _appdomain.RegisterCLRMethodRedirection(i, GetComponent);
                }
            }
        }
        void OnHotFixUnLoaded()
        {
            try
            {
                _appdomain?.Invoke("Hotfix.ILLauncher", "UnInit", null, null);
            }
            catch (Exception e)
            {
                DebugTool.LogError($"卸载ILRuntime,{e.Message}");
            }
        }

        public void EnterGame(string gameName)
        {
            EventHelper.DispatchOnEnterGame(gameName);
        }

        public override void UnInitialize()
        {
            base.UnInitialize();
            EventHelper.LeaveGame -= EventHelperOnLeaveGame;
            OnHotFixUnLoaded();
            _fs?.Dispose();
            _fs = null;
        }

        private void OnDestroy()
        {
            UnInitialize();
        }/// <summary>
        /// 注册解释器和委托
        /// </summary>
        private void InitializeILRuntime()
        {
            JsonMapper.RegisterILRuntimeCLRRedirection(_appdomain);
            _appdomain.RegisterCrossBindingAdaptor(new CoroutineAdapter());
            _appdomain.RegisterCrossBindingAdaptor(new MonoBehaviourAdapter());
            _appdomain.RegisterCrossBindingAdaptor(new IAsyncStateMachineClassInheritanceAdaptor());
            _appdomain.DelegateManager.RegisterMethodDelegate<int>();
            _appdomain.DelegateManager.RegisterMethodDelegate<string>();
            _appdomain.DelegateManager.RegisterMethodDelegate<float>();
            _appdomain.DelegateManager.RegisterMethodDelegate<double>();
            _appdomain.DelegateManager.RegisterMethodDelegate<short>();
            _appdomain.DelegateManager.RegisterMethodDelegate<long>();
            _appdomain.DelegateManager.RegisterMethodDelegate<uint>();
            _appdomain.DelegateManager.RegisterMethodDelegate<ushort>();
            _appdomain.DelegateManager.RegisterMethodDelegate<ulong>();
            _appdomain.DelegateManager.RegisterMethodDelegate<decimal>();
            _appdomain.DelegateManager.RegisterMethodDelegate<bool>();
            _appdomain.DelegateManager.RegisterMethodDelegate<byte>();
            _appdomain.DelegateManager.RegisterMethodDelegate<object>();
            _appdomain.DelegateManager.RegisterMethodDelegate<byte[]>();
            _appdomain.DelegateManager.RegisterMethodDelegate<Vector2>();
            _appdomain.DelegateManager.RegisterMethodDelegate<Vector3>();
            _appdomain.DelegateManager.RegisterMethodDelegate<ByteBuffer>();
            _appdomain.DelegateManager.RegisterMethodDelegate<GameObject>();
            _appdomain.DelegateManager.RegisterMethodDelegate<Projector>();
            _appdomain.DelegateManager.RegisterMethodDelegate<Shadow>();
            _appdomain.DelegateManager.RegisterMethodDelegate<Outline>();
            _appdomain.DelegateManager.RegisterMethodDelegate<UnityEngine.Transform>();
            _appdomain.DelegateManager.RegisterMethodDelegate<UnityEngine.Object>();
            _appdomain.DelegateManager.RegisterMethodDelegate<Collider>();
            _appdomain.DelegateManager.RegisterMethodDelegate<Collision>();
            _appdomain.DelegateManager.RegisterMethodDelegate<Collider2D>();
            _appdomain.DelegateManager.RegisterMethodDelegate<Collision2D>();
            _appdomain.DelegateManager.RegisterMethodDelegate<IAsyncResult>();
            _appdomain.DelegateManager.RegisterMethodDelegate<TrackEntry>();
            _appdomain.DelegateManager.RegisterMethodDelegate<BytesPack>();
            _appdomain.DelegateManager.RegisterMethodDelegate<AssetBundle>();
            _appdomain.DelegateManager.RegisterMethodDelegate<String, Session>();
            _appdomain.DelegateManager.RegisterMethodDelegate<Scene, LoadSceneMode>();
            _appdomain.DelegateManager.RegisterMethodDelegate<GameObject, GameObject>();
            _appdomain.DelegateManager.RegisterMethodDelegate<UnityEngine.Object, UnityEngine.Object, UnityEngine.Object>();
            _appdomain.DelegateManager.RegisterMethodDelegate<UnityEngine.Object, UnityEngine.Object>();
            _appdomain.DelegateManager.RegisterMethodDelegate<GameObject, PointerEventData>();
            _appdomain.DelegateManager.RegisterMethodDelegate<Single, System.Object>();
            _appdomain.DelegateManager.RegisterMethodDelegate<ILTypeInstance>();
            _appdomain.DelegateManager.RegisterMethodDelegate<YooAsset.AsyncOperationBase>();
            _appdomain.DelegateManager.RegisterMethodDelegate<int,int,long,long>();
            _appdomain.DelegateManager.RegisterMethodDelegate<string,string>();
            _appdomain.DelegateManager.RegisterMethodDelegate<string,long>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<int>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<string>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<float>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<double>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<short>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<long>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<uint>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<ushort>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<ulong>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<decimal>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<bool>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<byte>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<object>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<byte[]>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<Vector2>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<Vector3>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<ByteBuffer>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<GameObject>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<UnityEngine.Transform>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<Collider>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<Collision>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<Collider2D>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<Collision2D>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<ILTypeInstance>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<ILTypeInstance, ILTypeInstance>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<ILTypeInstance, ILTypeInstance, ILTypeInstance>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<UnityEngine.Object>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<UnityEngine.Object, UnityEngine.Object>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<UnityEngine.Object, UnityEngine.Object, UnityEngine.Object>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<ILTypeInstance, UnityEngine.Object, UnityEngine.Object>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<ILTypeInstance, ILTypeInstance, Int32>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<ILTypeInstance, ILTypeInstance, string>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<ILTypeInstance, ILTypeInstance, long>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<ILTypeInstance, ILTypeInstance, double>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<ILTypeInstance, ILTypeInstance, bool>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<ILTypeInstance, ILTypeInstance, byte>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<ILTypeInstance, ILTypeInstance, float>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<ILTypeInstance, ILTypeInstance, short>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<ILTypeInstance, ILTypeInstance, decimal>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<ILTypeInstance, ILTypeInstance, object>();
            _appdomain.DelegateManager.RegisterFunctionDelegate<ILTypeInstance, ILTypeInstance, UnityEngine.Object>();
            _appdomain.DelegateManager.RegisterDelegateConvertor<ThreadStart>(act =>
            {
                return new ThreadStart(() => { ((Action) act)(); });
            });
            _appdomain.DelegateManager.RegisterDelegateConvertor<YooAsset.DownloaderOperation.OnDownloadError>((act) =>
            {
                return new YooAsset.DownloaderOperation.OnDownloadError((fileName, error) =>
                {
                    ((Action<System.String, System.String>)act)(fileName, error);
                });
            });
            _appdomain.DelegateManager.RegisterDelegateConvertor<YooAsset.DownloaderOperation.OnDownloadOver>((act) =>
            {
                return new YooAsset.DownloaderOperation.OnDownloadOver((isSuccessed) =>
                {
                    ((Action<bool>)act)(isSuccessed);
                });
            });
            _appdomain.DelegateManager.RegisterDelegateConvertor<YooAsset.DownloaderOperation.OnDownloadProgress>((act) =>
            {
                return new YooAsset.DownloaderOperation.OnDownloadProgress((totalDownloadCount, currentDownloadCount, totalDownloadBytes, currentDownloadBytes) =>
                {
                    ((Action<int,int,long,long>)act)(totalDownloadCount, currentDownloadCount, totalDownloadBytes, currentDownloadBytes);
                });
            });
            _appdomain.DelegateManager.RegisterDelegateConvertor<YooAsset.DownloaderOperation.OnStartDownloadFile>((act) =>
            {
                return new YooAsset.DownloaderOperation.OnStartDownloadFile((fileName, sizeBytes) =>
                {
                    ((Action<string,long>)act)(fileName, sizeBytes);
                });
            });

            _appdomain.DelegateManager
                .RegisterDelegateConvertor<UnityAction<Scene,
                    LoadSceneMode>>(act =>
                {
                    return new
                        UnityAction<Scene,
                            LoadSceneMode>((arg0, arg1) =>
                        {
                            ((Action<Scene,
                                LoadSceneMode>) act)(arg0, arg1);
                        });
                });
            _appdomain.DelegateManager.RegisterDelegateConvertor<System.Comparison<ILTypeInstance>>((act) =>
            {
                return new Comparison<ILTypeInstance>((x, y) =>
                    ((Func<ILTypeInstance, ILTypeInstance, System.Int32>) act)(x, y));
            });

            _appdomain.DelegateManager.RegisterDelegateConvertor<System.Comparison<int>>((act) =>
            {
                return new Comparison<int>((x, y) => ((Func<int, int, System.Int32>) act)(x, y));
            });

            _appdomain.DelegateManager.RegisterDelegateConvertor<System.Comparison<string>>((act) =>
            {
                return new Comparison<string>((x, y) => ((Func<string, string, System.Int32>) act)(x, y));
            });
            _appdomain.DelegateManager.RegisterDelegateConvertor<System.Comparison<short>>((act) =>
            {
                return new Comparison<short>((x, y) => ((Func<short, short, System.Int32>) act)(x, y));
            });
            _appdomain.DelegateManager.RegisterDelegateConvertor<System.Comparison<long>>((act) =>
            {
                return new Comparison<long>((x, y) => ((Func<long, long, System.Int32>) act)(x, y));
            });
            _appdomain.DelegateManager.RegisterDelegateConvertor<System.Comparison<float>>((act) =>
            {
                return new Comparison<float>((x, y) => ((Func<float, float, System.Int32>) act)(x, y));
            });
            _appdomain.DelegateManager.RegisterDelegateConvertor<System.Comparison<double>>((act) =>
            {
                return new Comparison<double>((x, y) => ((Func<double, double, System.Int32>) act)(x, y));
            });
            _appdomain.DelegateManager.RegisterDelegateConvertor<System.Comparison<decimal>>((act) =>
            {
                return new Comparison<decimal>((x, y) => ((Func<decimal, decimal, System.Int32>) act)(x, y));
            });
            _appdomain.DelegateManager.RegisterDelegateConvertor<System.Comparison<object>>((act) =>
            {
                return new Comparison<object>((x, y) => ((Func<object, object, System.Int32>) act)(x, y));
            });
            _appdomain.DelegateManager.RegisterDelegateConvertor<TweenCallback>(act =>
            {
                return new TweenCallback(() => { ((Action) act)(); });
            });


            _appdomain.DelegateManager.RegisterDelegateConvertor<AsyncCallback>(act =>
            {
                return new AsyncCallback(ar => { ((Action<IAsyncResult>) act)(ar); });
            });
            _appdomain.DelegateManager.RegisterDelegateConvertor<TweenCallback>(act =>
            {
                return new TweenCallback(() => { ((Action) act)(); });
            });
            _appdomain.DelegateManager.RegisterDelegateConvertor<DOSetter<Single>>(act =>
            {
                return new DOSetter<Single>(pNewValue => { ((Action<Single>) act)(pNewValue); });
            });
            _appdomain.DelegateManager.RegisterDelegateConvertor<DOSetter<Decimal>>(act =>
            {
                return new DOSetter<Decimal>(pNewValue => { ((Action<Decimal>) act)(pNewValue); });
            });
            _appdomain.DelegateManager.RegisterDelegateConvertor<DOSetter<Double>>(act =>
            {
                return new DOSetter<Double>(pNewValue => { ((Action<Double>) act)(pNewValue); });
            });
            _appdomain.DelegateManager.RegisterDelegateConvertor<DOSetter<Int16>>(act =>
            {
                return new DOSetter<Int16>(pNewValue => { ((Action<Int16>) act)(pNewValue); });
            });
            _appdomain.DelegateManager.RegisterDelegateConvertor<DOSetter<Int32>>(act =>
            {
                return new DOSetter<Int32>(pNewValue => { ((Action<Int32>) act)(pNewValue); });
            });
            _appdomain.DelegateManager.RegisterDelegateConvertor<DOSetter<Int64>>(act =>
            {
                return new DOSetter<Int64>(pNewValue => { ((Action<Int64>) act)(pNewValue); });
            });
            _appdomain.DelegateManager.RegisterDelegateConvertor<DOSetter<Color>>(act =>
            {
                return new DOSetter<Color>(pNewValue => { ((Action<Color>) act)(pNewValue); });
            });
            _appdomain.DelegateManager.RegisterDelegateConvertor<Spine.AnimationState.TrackEntryDelegate>(act =>
            {
                return new Spine.AnimationState.TrackEntryDelegate(trackEntry =>
                {
                    ((Action<TrackEntry>) act)(trackEntry);
                });
            });
            _appdomain.DelegateManager.RegisterMethodDelegate<String, EventObject>();
            _appdomain.DelegateManager.RegisterDelegateConvertor<ListenerDelegate<EventObject>>(
                act =>
                {
                    return new ListenerDelegate<EventObject>((type, eventObject) =>
                    {
                        ((Action<String, EventObject>) act)(type, eventObject);
                    });
                });

            _appdomain.DelegateManager.RegisterDelegateConvertor<UnityAction<String>>(act =>
            {
                return new UnityAction<String>(arg0 => { ((Action<String>) act)(arg0); });
            });
            _appdomain.DelegateManager.RegisterDelegateConvertor<UnityAction<MediaPlayer,MediaPlayerEvent.EventType,ErrorCode>>(act =>
            {
                return new UnityAction<MediaPlayer, MediaPlayerEvent.EventType, ErrorCode>((arg0, arg1, arg2) =>
                {
                    ((Action<MediaPlayer, MediaPlayerEvent.EventType, ErrorCode>) act)(arg0, arg1, arg2);
                });
            });


            CLRBindings.Initialize(_appdomain);
        }

        MonoBehaviourAdapter.Adaptor GetComponent(ILType type)
        {
            var arr = GetComponents<MonoBehaviourAdapter.Adaptor>();
            for (int i = 0; i < arr.Length; i++)
            {
                var instance = arr[i];
                if (instance.ILInstance != null && instance.ILInstance.Type == type)
                {
                    return instance;
                }
            }

            return null;
        }

        unsafe static StackObject* AddComponent(ILIntepreter __intp, StackObject* __esp, IList<object> __mStack,
            CLRMethod __method, bool isNewObj)
        {
            //CLR重定向的说明请看相关文档和教程，这里不多做解释
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;

            var ptr = __esp - 1;
            //成员方法的第一个参数为this
            GameObject instance = StackObject.ToObject(ptr, __domain, __mStack) as GameObject;
            if (instance == null)
                throw new NullReferenceException();
            __intp.Free(ptr);

            var genericArgument = __method.GenericArguments;
            //AddComponent应该有且只有1个泛型参数
            if (genericArgument != null && genericArgument.Length == 1)
            {
                var type = genericArgument[0];
                object res;
                if (type is CLRType)
                {
                    //Unity主工程的类不需要任何特殊处理，直接调用Unity接口
                    res = instance.AddComponent(type.TypeForCLR);
                }
                else
                {
                    //热更DLL内的类型比较麻烦。首先我们得自己手动创建实例
                    var ilInstance =
                        new ILTypeInstance(type as ILType, false); //手动创建实例是因为默认方式会new MonoBehaviour，这在Unity里不允许
                    //接下来创建Adapter实例
                    var clrInstance = instance.AddComponent<MonoBehaviourAdapter.Adaptor>();
                    //unity创建的实例并没有热更DLL里面的实例，所以需要手动赋值
                    clrInstance.ILInstance = ilInstance;
                    clrInstance.AppDomain = __domain;
                    //这个实例默认创建的CLRInstance不是通过AddComponent出来的有效实例，所以得手动替换
                    ilInstance.CLRInstance = clrInstance;

                    res = clrInstance.ILInstance; //交给ILRuntime的实例应该为ILInstance

                    clrInstance.Awake(); //因为Unity调用这个方法时还没准备好所以这里补调一次
                }

                return ILIntepreter.PushObject(ptr, __mStack, res);
            }

            return __esp;
        }

        unsafe static StackObject* GetComponent(ILIntepreter __intp, StackObject* __esp, IList<object> __mStack,
            CLRMethod __method, bool isNewObj)
        {
            //CLR重定向的说明请看相关文档和教程，这里不多做解释
            ILRuntime.Runtime.Enviorment.AppDomain __domain = __intp.AppDomain;

            var ptr = __esp - 1;
            //成员方法的第一个参数为this
            GameObject instance = StackObject.ToObject(ptr, __domain, __mStack) as GameObject;
            if (instance == null)
                throw new NullReferenceException();
            __intp.Free(ptr);

            var genericArgument = __method.GenericArguments;
            //AddComponent应该有且只有1个泛型参数
            if (genericArgument != null && genericArgument.Length == 1)
            {
                var type = genericArgument[0];
                object res = null;
                if (type is CLRType)
                {
                    //Unity主工程的类不需要任何特殊处理，直接调用Unity接口
                    res = instance.GetComponent(type.TypeForCLR);
                }
                else
                {
                    //因为所有DLL里面的MonoBehaviour实际都是这个Component，所以我们只能全取出来遍历查找
                    var clrInstances = instance.GetComponents<MonoBehaviourAdapter.Adaptor>();
                    for (int i = 0; i < clrInstances.Length; i++)
                    {
                        var clrInstance = clrInstances[i];
                        if (clrInstance.ILInstance != null) //ILInstance为null, 表示是无效的MonoBehaviour，要略过
                        {
                            if (clrInstance.ILInstance.Type == type)
                            {
                                res = clrInstance.ILInstance; //交给ILRuntime的实例应该为ILInstance
                                break;
                            }
                        }
                    }
                }

                return ILIntepreter.PushObject(ptr, __mStack, res);
            }

            return __esp;
        }
    }
}