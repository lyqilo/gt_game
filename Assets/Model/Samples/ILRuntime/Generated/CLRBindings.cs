using System;
using System.Collections.Generic;
using System.Reflection;
#if DEBUG && !DISABLE_ILRUNTIME_DEBUG
using AutoList = System.Collections.Generic.List<object>;
#else
using AutoList = ILRuntime.Other.UncheckedList<object>;
#endif
namespace ILRuntime.Runtime.Generated
{
    class CLRBindings
    {

//will auto register in unity
#if UNITY_5_3_OR_NEWER
        [UnityEngine.RuntimeInitializeOnLoadMethod(UnityEngine.RuntimeInitializeLoadType.BeforeSceneLoad)]
#endif
        static private void RegisterBindingAction()
        {
            ILRuntime.Runtime.CLRBinding.CLRBindingUtils.RegisterBindingAction(Initialize);
        }

        internal static ILRuntime.Runtime.Enviorment.ValueTypeBinder<UnityEngine.Vector3> s_UnityEngine_Vector3_Binding_Binder = null;
        internal static ILRuntime.Runtime.Enviorment.ValueTypeBinder<UnityEngine.Vector2> s_UnityEngine_Vector2_Binding_Binder = null;
        internal static ILRuntime.Runtime.Enviorment.ValueTypeBinder<UnityEngine.Quaternion> s_UnityEngine_Quaternion_Binding_Binder = null;

        /// <summary>
        /// Initialize the CLR binding, please invoke this AFTER CLR Redirection registration
        /// </summary>
        public static void Initialize(ILRuntime.Runtime.Enviorment.AppDomain app)
        {
            System_Collections_Generic_Queue_1_Action_Binding.Register(app);
            System_Action_Binding.Register(app);
            System_Threading_Interlocked_Binding.Register(app);
            System_Collections_Generic_List_1_ILTypeInstance_Binding.Register(app);
            EventHelper_Binding.Register(app);
            LuaFramework_BytesPack_Binding.Register(app);
            LuaFramework_Session_Binding.Register(app);
            System_Object_Binding.Register(app);
            System_String_Binding.Register(app);
            System_Runtime_CompilerServices_AsyncVoidMethodBuilder_Binding.Register(app);
            LuaFramework_NetworkManager_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_Int32_Session_Binding.Register(app);
            LuaFramework_ByteBuffer_Binding.Register(app);
            System_Int32_Binding.Register(app);
            LitJson_JsonMapper_Binding.Register(app);
            System_Array_Binding.Register(app);
            System_Collections_Generic_List_1_String_Binding.Register(app);
            System_Threading_Tasks_Task_Binding.Register(app);
            System_Action_1_String_Binding.Register(app);
            System_Runtime_CompilerServices_TaskAwaiter_Binding.Register(app);
            UnityEngine_Application_Binding.Register(app);
            UnityEngine_Time_Binding.Register(app);
            UnityEngine_GameObject_Binding.Register(app);
            UnityEngine_Object_Binding.Register(app);
            System_Collections_Generic_Queue_1_ILTypeInstance_Binding.Register(app);
            System_Collections_Generic_Queue_1_String_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_String_ILTypeInstance_Binding.Register(app);
            LuaFramework_Util_Binding.Register(app);
            UnityEngine_SystemInfo_Binding.Register(app);
            UnityEngine_Debug_Binding.Register(app);
            UnityEngine_Screen_Binding.Register(app);
            YooAsset_YooAssets_Binding.Register(app);
            UnityEngine_Component_Binding.Register(app);
            UnityEngine_UI_Slider_Binding.Register(app);
            UnityEngine_UI_Button_Binding.Register(app);
            UnityEngine_Events_UnityEventBase_Binding.Register(app);
            LuaFramework_ILBehaviour_Binding.Register(app);
            ES3_Binding.Register(app);
            System_Activator_Binding.Register(app);
            System_NotImplementedException_Binding.Register(app);
            System_Reflection_MemberInfo_Binding.Register(app);
            System_Action_2_String_String_Binding.Register(app);
            UnityEngine_UI_Text_Binding.Register(app);
            TMPro_TMP_Text_Binding.Register(app);
            UniClipboard_Binding.Register(app);
            UnityEngine_Transform_Binding.Register(app);
            System_Type_Binding.Register(app);
            System_Text_RegularExpressions_Regex_Binding.Register(app);
            System_Text_RegularExpressions_Group_Binding.Register(app);
            System_Text_RegularExpressions_Capture_Binding.Register(app);
            System_Collections_Generic_List_1_Int32_Binding.Register(app);
            System_Collections_Generic_List_1_Byte_Binding.Register(app);
            System_Int64_Binding.Register(app);
            System_Text_StringBuilder_Binding.Register(app);
            DG_Tweening_DOTween_Binding.Register(app);
            DG_Tweening_TweenSettingsExtensions_Binding.Register(app);
            UnityEngine_Vector3_Binding.Register(app);
            System_IComparable_Binding.Register(app);
            LuaFramework_HandleConfig_Binding.Register(app);
            System_TimeZone_Binding.Register(app);
            System_DateTime_Binding.Register(app);
            System_Double_Binding.Register(app);
            System_Char_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_Int32_ILTypeInstance_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_Int32_ILTypeInstance_Binding_KeyCollection_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_Int32_Int32_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_Int32_Int32_Binding_KeyCollection_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_Int32_Boolean_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_Int32_Boolean_Binding_KeyCollection_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_String_Object_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_String_Object_Binding_KeyCollection_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_Int32_Transform_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_Int32_Transform_Binding_KeyCollection_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_Transform_Int32_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_Transform_Int32_Binding_KeyCollection_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_Int32_Dictionary_2_Int32_ILTypeInstance_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_Int32_Dictionary_2_Int32_ILTypeInstance_Binding_KeyCollection_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_Int32_List_1_Int32_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_Int32_List_1_Int32_Binding_KeyCollection_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_String_List_1_ILTypeInstance_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_String_List_1_ILTypeInstance_Binding_KeyCollection_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_Int32_List_1_Transform_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_Int32_List_1_Transform_Binding_KeyCollection_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_Int32_String_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_Int32_String_Binding_KeyCollection_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_String_Boolean_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_String_Boolean_Binding_KeyCollection_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_String_ILTypeInstance_Binding_KeyCollection_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_Int32_ILTypeInstance_Binding_ValueCollection_Binding.Register(app);
            DG_Tweening_Tween_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_Int32_Tween_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_Int32_Tween_Binding_ValueCollection_Binding.Register(app);
            UnityEngine_UI_ScrollRect_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_String_ScrollRect_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_String_ScrollRect_Binding_ValueCollection_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_String_Int32_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_String_Int32_Binding_ValueCollection_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_String_Object_Binding_ValueCollection_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_Int32_Transform_Binding_ValueCollection_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_Transform_Int32_Binding_ValueCollection_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_String_ILTypeInstance_Binding_ValueCollection_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_Int32_Dictionary_2_Int32_ILTypeInstance_Binding_ValueCollection_Binding.Register(app);
            LuaFramework_MusicManager_Binding.Register(app);
            System_Boolean_Binding.Register(app);
            UnityEngine_PlayerPrefs_Binding.Register(app);
            AppFacade_Binding.Register(app);
            Facade_Binding.Register(app);
            Coffee_UIExtensions_UIEffect_Binding.Register(app);
            YooAsset_AssetsPackage_Binding.Register(app);
            YooAsset_AssetOperationHandle_Binding.Register(app);
            System_Single_Binding.Register(app);
            UnityEngine_WaitForSeconds_Binding.Register(app);
            System_NotSupportedException_Binding.Register(app);
            UnityEngine_MonoBehaviour_Binding.Register(app);
            FormData_Binding.Register(app);
            UnityEngine_WaitForEndOfFrame_Binding.Register(app);
            UnityEngine_Networking_UnityWebRequest_Binding.Register(app);
            LuaFramework_AppConst_Binding.Register(app);
            LuaFramework_CSConfiger_Binding.Register(app);
            UnityEngine_Networking_DownloadHandler_Binding.Register(app);
            SRDebug_Binding.Register(app);
            SRDebugger_Services_IDebugService_Binding.Register(app);
            Manager_Binding.Register(app);
            UnityEngine_UI_Image_Binding.Register(app);
            UnityEngine_Quaternion_Binding.Register(app);
            UnityEngine_Vector2_Binding.Register(app);
            UnityEngine_RectTransform_Binding.Register(app);
            UnityEngine_SceneManagement_SceneManager_Binding.Register(app);
            YooAsset_OperationHandleBase_Binding.Register(app);
            System_Decimal_Binding.Register(app);
            YooAsset_HostPlayModeParameters_Binding.Register(app);
            YooAsset_QueryStreamingAssetsFileServices_Binding.Register(app);
            YooAsset_BundleDecryptionServices_Binding.Register(app);
            YooAsset_InitializeParameters_Binding.Register(app);
            YooAsset_AsyncOperationBase_Binding.Register(app);
            YooAsset_UpdatePackageVersionOperation_Binding.Register(app);
            YooAsset_DownloaderOperation_Binding.Register(app);
            UnityEngine_AudioSource_Binding.Register(app);
            RenderHeads_Media_AVProVideo_DisplayUGUI_Binding.Register(app);
            RenderHeads_Media_AVProVideo_MediaPlayer_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_String_GameObject_Binding.Register(app);
            LuaFramework_PathHelp_Binding.Register(app);
            UnityEngine_AudioClip_Binding.Register(app);
            UnityEngine_Input_Binding.Register(app);
            LuaFramework_NetworkHelper_Binding.Register(app);
            LuaFramework_MD5Helper_Binding.Register(app);
            UnityEngine_UI_InputField_Binding.Register(app);
            UnityEngine_UI_Selectable_Binding.Register(app);
            UnityEngine_Events_UnityEvent_1_String_Binding.Register(app);
            System_UInt32_Binding.Register(app);
            UnityEngine_Mathf_Binding.Register(app);
            UnityEngine_UI_Toggle_Binding.Register(app);
            LuaFramework_LuaManager_Binding.Register(app);
            LuaFramework_ValueConfiger_Binding.Register(app);
            System_IO_File_Binding.Register(app);
            System_IO_Path_Binding.Register(app);
            System_IO_Directory_Binding.Register(app);
            LuaFramework_BaseValueConfigerJson_Binding.Register(app);
            LuaFramework_UnityWebDownPacketQueue_Binding.Register(app);
            LuaFramework_UnityWebPacket_Binding.Register(app);
            System_UInt64_Binding.Register(app);
            LuaFramework_UnityWebRequestAsync_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_String_Transform_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_String_ILTypeInstance_Binding_KeyCollection_Binding_Enumerator_Binding.Register(app);
            System_IDisposable_Binding.Register(app);
            UnityEngine_UI_Graphic_Binding.Register(app);
            UnityEngine_SpriteRenderer_Binding.Register(app);
            DG_Tweening_TweenExtensions_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_String_ILTypeInstance_Binding_Enumerator_Binding.Register(app);
            System_Collections_Generic_KeyValuePair_2_String_ILTypeInstance_Binding.Register(app);
            LuaFramework_EventTriggerHelper_Binding.Register(app);
            System_Exception_Binding.Register(app);
            Defence_Defence_Binding.Register(app);
            SRDebugger_Settings_Binding.Register(app);
            UnityEngine_ILogger_Binding.Register(app);
            UnityEngine_EventSystems_PointerEventData_Binding.Register(app);
            UnityEngine_EventSystems_RaycastResult_Binding.Register(app);
            UnityEngine_UI_CanvasScaler_Binding.Register(app);
            UnityEngine_CanvasGroup_Binding.Register(app);
            DG_Tweening_DOTweenModuleUI_Binding.Register(app);
            DG_Tweening_ShortcutExtensions_Binding.Register(app);
            UnityEngine_Rect_Binding.Register(app);
            UnityEngine_UI_HorizontalOrVerticalLayoutGroup_Binding.Register(app);
            System_Collections_Generic_List_1_Single_Binding.Register(app);
            UnityEngine_UI_GridLayoutGroup_Binding.Register(app);
            System_GC_Binding.Register(app);
            UnityEngine_RectTransformUtility_Binding.Register(app);
            Coffee_UIExtensions_UITransitionEffect_Binding.Register(app);
            System_Collections_Generic_List_1_List_1_Int32_Binding.Register(app);
            System_Collections_Generic_List_1_Image_Binding.Register(app);
            System_Collections_Generic_List_1_Transform_Binding.Register(app);
            UnityEngine_Behaviour_Binding.Register(app);
            Spine_Unity_SkeletonGraphic_Binding.Register(app);
            Spine_AnimationState_Binding.Register(app);
            UnityEngine_Animator_Binding.Register(app);
            System_Collections_Generic_List_1_List_1_Single_Binding.Register(app);
            System_Collections_Generic_List_1_List_1_Transform_Binding.Register(app);
            System_Collections_Generic_List_1_List_1_Byte_Binding.Register(app);
            UnityEngine_Random_Binding.Register(app);
            System_Collections_Generic_List_1_ScrollRect_Binding.Register(app);
            UnityEngine_Camera_Binding.Register(app);
            UnityEngine_Vector4_Binding.Register(app);
            System_Collections_Generic_List_1_Vector3_Binding.Register(app);
            UnityEngine_Collider_Binding.Register(app);
            UnityEngine_Color_Binding.Register(app);
            System_Collections_Generic_List_1_Boolean_Binding.Register(app);
            System_Collections_Generic_Queue_1_GameObject_Binding.Register(app);
            System_Collections_Generic_List_1_Int64_Binding.Register(app);
            DragonBones_DragonBoneEventDispatcher_Binding.Register(app);
            DragonBones_UnityArmatureComponent_Binding.Register(app);
            DragonBones_Animation_Binding.Register(app);
            DragonBones_EventObject_Binding.Register(app);
            DragonBones_AnimationState_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_String_String_Binding.Register(app);
            System_Collections_Generic_List_1_Vector2_Binding.Register(app);
            UnityEngine_Material_Binding.Register(app);
            System_Collections_Generic_List_1_GameObject_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_Int32_Single_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_Int32_Vector3_Binding.Register(app);
            System_Collections_Generic_List_1_Dictionary_2_String_Int32_Binding.Register(app);
            System_Collections_Generic_List_1_Int16_Binding.Register(app);
            UnityEngine_Physics2D_Binding.Register(app);
            UnityEngine_QualitySettings_Binding.Register(app);
            UnityEngine_Resources_Binding.Register(app);
            System_Math_Binding.Register(app);
            LuaFramework_CollisionTriggerUtility_Binding.Register(app);
            System_Collections_Generic_Queue_1_Transform_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_Int32_Material_Binding.Register(app);
            UnityEngine_LineRenderer_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_String_Int64_Binding.Register(app);
            System_Collections_Generic_Stack_1_ILTypeInstance_Binding.Register(app);
            System_Collections_Generic_Queue_1_Int64_Binding.Register(app);
            System_Collections_Generic_Queue_1_Single_Binding.Register(app);
            UnityEngine_ParticleSystem_Binding.Register(app);
            UnityEngine_Renderer_Binding.Register(app);
            UnityEngine_RaycastHit2D_Binding.Register(app);
            System_Collections_Generic_Dictionary_2_Int32_Int64_Binding.Register(app);
            System_Collections_Generic_List_1_Material_Binding.Register(app);
            UnityEngine_AnimatorStateInfo_Binding.Register(app);
            System_Collections_Generic_Stack_1_Transform_Binding.Register(app);
            UnityEngine_LayerMask_Binding.Register(app);
            UnityEngine_Canvas_Binding.Register(app);
            DG_Tweening_ShortcutExtensionsTMPText_Binding.Register(app);

            ILRuntime.CLR.TypeSystem.CLRType __clrType = null;
            __clrType = (ILRuntime.CLR.TypeSystem.CLRType)app.GetType (typeof(UnityEngine.Vector3));
            s_UnityEngine_Vector3_Binding_Binder = __clrType.ValueTypeBinder as ILRuntime.Runtime.Enviorment.ValueTypeBinder<UnityEngine.Vector3>;
            __clrType = (ILRuntime.CLR.TypeSystem.CLRType)app.GetType (typeof(UnityEngine.Vector2));
            s_UnityEngine_Vector2_Binding_Binder = __clrType.ValueTypeBinder as ILRuntime.Runtime.Enviorment.ValueTypeBinder<UnityEngine.Vector2>;
            __clrType = (ILRuntime.CLR.TypeSystem.CLRType)app.GetType (typeof(UnityEngine.Quaternion));
            s_UnityEngine_Quaternion_Binding_Binder = __clrType.ValueTypeBinder as ILRuntime.Runtime.Enviorment.ValueTypeBinder<UnityEngine.Quaternion>;
        }

        /// <summary>
        /// Release the CLR binding, please invoke this BEFORE ILRuntime Appdomain destroy
        /// </summary>
        public static void Shutdown(ILRuntime.Runtime.Enviorment.AppDomain app)
        {
            s_UnityEngine_Vector3_Binding_Binder = null;
            s_UnityEngine_Vector2_Binding_Binder = null;
            s_UnityEngine_Quaternion_Binding_Binder = null;
        }
    }
}
