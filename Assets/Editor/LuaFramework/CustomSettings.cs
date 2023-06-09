﻿using UnityEngine;
using System;
using System.Collections.Generic;
using LuaInterface;
using LuaFramework;
using UnityEditor;
using BindType = ToLuaMenu.BindType;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using UnityEngine.EventSystems;
using UnityEngine.U2D;

public static class CustomSettings
{
    /// <summary>
    /// Lua框架根目录
    /// </summary>
    public static string FrameworkPath = $"{Application.dataPath}/Model/LuaFramework";

    /// <summary>
    /// 注册到lua的C#类型的桥类文件存放目录
    /// </summary>
    public static string saveDir = $"{FrameworkPath}/ToLua/Source/Generate/";

    /// <summary>
    /// 业务逻辑Lua文件存放路径根目录
    /// </summary>
    public static string luaDir = $"{Application.dataPath}/ThirdParty/LuaFramework/Lua/";

    public static string toluaBaseType = FrameworkPath + "/ToLua/BaseType/";

    /// <summary>
    /// ToLua默认提供的Lua脚本根目录
    /// </summary>
    public static string toluaLuaDir = $"{Application.dataPath}/ThirdParty/LuaFramework/ToLua/Lua";

    /// <summary>
    /// 导出时强制做为静态类的类型(注意customTypeList 还要添加这个类型才能导出)
    /// unity 有些类作为sealed class, 其实完全等价于静态类
    /// </summary>
    public static List<Type> staticClassTypes = new List<Type>
    {
        typeof(UnityEngine.Application),
        typeof(UnityEngine.Time),
        typeof(UnityEngine.Screen),
        typeof(UnityEngine.SleepTimeout),
        typeof(UnityEngine.Input),
        typeof(UnityEngine.Resources),
        typeof(UnityEngine.Physics),
        typeof(UnityEngine.RenderSettings),
        typeof(UnityEngine.QualitySettings),
        typeof(UnityEngine.GL),
        typeof(UnityEngine.Graphics),
    };

    /// <summary>
    /// 附加导出委托类型(在导出委托时, customTypeList 中牵扯的委托类型都会导出， 无需写在这里)
    /// </summary>
    public static DelegateType[] customDelegateList =
    {
        _DT(typeof(Action)),
        _DT(typeof(UnityEngine.Events.UnityAction)),
        _DT(typeof(System.Predicate<int>)),
        _DT(typeof(System.Action<int>)),
        _DT(typeof(System.Comparison<int>)),
        _DT(typeof(System.Func<int, int>)),
        _DT(typeof(DG.Tweening.TweenCallback)),
    };

    /// <summary>
    /// 在这里添加你要导出注册到lua的类型列表
    /// </summary>
    public static BindType[] customTypeList =
    {
        //------------------------为例子导出--------------------------------
        //_GT(typeof(TestEventListener)),
        //_GT(typeof(TestProtol)),
        //_GT(typeof(TestAccount)),
        //_GT(typeof(TestExport)),
        //_GT(typeof(TestExport.Space)),
        //-------------------------------------------------------------------        

        _GT(typeof(Debugger)).SetNameSpace(null),
        _GT(typeof(DG.Tweening.Ease)),
        _GT(typeof(DG.Tweening.DOTween)),
        _GT(typeof(DG.Tweening.Tween)).SetBaseType(typeof(System.Object))
            .AddExtendType(typeof(DG.Tweening.TweenExtensions)),
        _GT(typeof(DG.Tweening.Sequence)).AddExtendType(typeof(DG.Tweening.TweenSettingsExtensions)),
        _GT(typeof(DG.Tweening.Tweener)).AddExtendType(typeof(DG.Tweening.TweenSettingsExtensions)),
        _GT(typeof(DG.Tweening.LoopType)),
        _GT(typeof(DG.Tweening.PathMode)),
        _GT(typeof(DG.Tweening.PathType)),
        _GT(typeof(DG.Tweening.RotateMode)),
        _GT(typeof(Component)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(Transform)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)).AddExtendType(typeof(UtilExpand)),
//        _GT(typeof(Light)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)),
        _GT(typeof(Material)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(Rigidbody)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(Camera)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(AudioSource)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        //_GT(typeof(LineRenderer)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)),
        //_GT(typeof(TrailRenderer)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)),    

        _GT(typeof(Behaviour)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(MonoBehaviour)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(GameObject)).AddExtendType(typeof(UtilExpand)),
        _GT(typeof(TrackedReference)),
        _GT(typeof(Application)),
        _GT(typeof(Physics)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(Collider)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(Time)),
        _GT(typeof(Texture)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(Texture2D)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(Shader)),
        _GT(typeof(Renderer)),
        _GT(typeof(WWW)),
        _GT(typeof(Screen)),
        _GT(typeof(ScreenOrientation)),
        _GT(typeof(CameraClearFlags)),
        _GT(typeof(AudioClip)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(AssetBundle)),
        _GT(typeof(ParticleSystem)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(ParticleSystemRenderSpace)),
        // _GT(typeof(ParticleSystemRenderer)),
        _GT(typeof(ParticleSystem.MinMaxCurve)),
        _GT(typeof(ParticleSystem.MainModule)),
        _GT(typeof(ParticleSystem.MinMaxGradient)),

        _GT(typeof(AsyncOperation)).SetBaseType(typeof(System.Object)),
        _GT(typeof(LightType)),
        _GT(typeof(SleepTimeout)),
        _GT(typeof(SpriteRenderer)),

#if UNITY_5_3_OR_NEWER && !UNITY_5_6_OR_NEWER
        _GT(typeof(UnityEngine.Experimental.Director.DirectorPlayer)),
#endif
        _GT(typeof(Animator)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(Input)),
        _GT(typeof(Touch)),
        _GT(typeof(TouchPhase)),
        _GT(typeof(TouchType)),
        _GT(typeof(KeyCode)),
        _GT(typeof(SkinnedMeshRenderer)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(Space)),


        // _GT(typeof(MeshRenderer)),

#if !UNITY_5_4_OR_NEWER
        _GT(typeof(ParticleEmitter)),
        _GT(typeof(ParticleRenderer)),
        _GT(typeof(ParticleAnimator)),
#endif

        _GT(typeof(BoxCollider)),
        _GT(typeof(MeshCollider)),
        _GT(typeof(SphereCollider)),
        _GT(typeof(CharacterController)),
        _GT(typeof(CapsuleCollider)),

        _GT(typeof(Animation)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(AnimationClip)).SetBaseType(typeof(UnityEngine.Object)),
        _GT(typeof(AnimationState)),
        _GT(typeof(AnimationBlendMode)),
        _GT(typeof(QueueMode)),
        _GT(typeof(PlayMode)),
        _GT(typeof(WrapMode)),

//        _GT(typeof(QualitySettings)),
        _GT(typeof(RenderSettings)),
        _GT(typeof(SkinWeights)),
        _GT(typeof(RenderTexture)),
        _GT(typeof(Resources)),
        _GT(typeof(LuaProfiler)),

        //for LuaFramework
        _GT(typeof(RectTransform)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(Text)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)),
        //_GT(typeof(LayoutGroup)),
        _GT(typeof(RectOffset)),
        _GT(typeof(GridLayoutGroup)),
        _GT(typeof(HorizontalLayoutGroup)),
        _GT(typeof(Util)),
        _GT(typeof(AppConst)),
        _GT(typeof(LuaHelper)),
        _GT(typeof(ByteBuffer)),
        _GT(typeof(LuaBehaviour)),

        _GT(typeof(LuaManager)),
        _GT(typeof(MusicManager)),
        _GT(typeof(TimerManager)),
        _GT(typeof(NetworkManager)),

        _GT(typeof(ResourceManager)),
        _GT(typeof(ObjectPoolManager)),

        _GT(typeof(RawImage)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),


        _GT(typeof(TweenType)),
        _GT(typeof(TweenData)),
        _GT(typeof(TweenerManager)),

        _GT(typeof(Button)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(Button.ButtonClickedEvent)),
        _GT(typeof(Toggle)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(ToggleGroup)),
        _GT(typeof(Toggle.ToggleEvent)),
        _GT(typeof(InputField)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(InputField.ContentType)),
        _GT(typeof(Image)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(Sprite)),
        _GT(typeof(Rect)),

        _GT(typeof(Slider)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(Slider.SliderEvent)),

        _GT(typeof(HttpRequest)),
        _GT(typeof(HttpResponse)),

        _GT(typeof(Session)),


        _GT(typeof(SystemInfo)),
        _GT(typeof(PlayerPrefs)),
        _GT(typeof(SceneManager)),
        _GT(typeof(LoadSceneMode)),
        _GT(typeof(HorizontalWrapMode)),

        _GT(typeof(IMGResolution)),
        _GT(typeof(MD5Helper)),
        _GT(typeof(EventTriggerListener)),
        _GT(typeof(CsJoinLua)),
        _GT(typeof(CanvasScaler)),
        _GT(typeof(Canvas)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(ImageAnima)),
        _GT(typeof(AlignView)),
        _GT(typeof(AlignViewEx)),
        _GT(typeof(ABPacket)),
        _GT(typeof(AnimatorStateInfo)),
        _GT(typeof(ValueConfiger)),
        _GT(typeof(PathHelp)),
        _GT(typeof(UnityWebDownPacketQueue)),
        _GT(typeof(BaseValueConfigerJson)),
        _GT(typeof(UnityWebPacket)),
        _GT(typeof(Caching)),
        _GT(typeof(UnityWebRequestAsync)),
        _GT(typeof(ScrollRect)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(ConfigHelp)),
        _GT(typeof(PointerEventData)),
        _GT(typeof(NetworkHelper)),
        _GT(typeof(CreateFont)),
        _GT(typeof(UnityWebRequestHelper)),
        _GT(typeof(UnityWebRequestManager)),
        _GT(typeof(FormData)),

        _GT(typeof(Spine.Unity.SkeletonGraphic)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(Spine.AnimationState)),
        _GT(typeof(RectTransformUtility)),
        _GT(typeof(TextAsset)),
        _GT(typeof(RectTransform.Axis)),
        _GT(typeof(CanvasGroup)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(SpriteAtlas)),
        _GT(typeof(Font)),
        _GT(typeof(FontStyle)),
        _GT(typeof(Scrollbar)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(TMPro.TextMeshProUGUI)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(TMPro.TMP_Dropdown)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(TMPro.TMP_InputField)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(DragonBones.UnityArmatureComponent)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(DragonBones.UnityDragonBonesData)),
        _GT(typeof(DragonBones.SortingMode)),
        _GT(typeof(DragonBones.Animation)),
        _GT(typeof(DragonBones.AnimationConfig)),
        _GT(typeof(DragonBones.AnimationState)),
        _GT(typeof(DragonBones.EventObject)),
        _GT(typeof(DragonBones.AnimationFadeOutMode)),
        _GT(typeof(DragonBones.ActionType)),
        _GT(typeof(DragonBones.ActionData)),
        _GT(typeof(DragonBones.BlendMode)),
        _GT(typeof(ILRuntimeManager)),
    };

    public static List<Type> dynamicList = new List<Type>()
    {
        typeof(MeshRenderer),
#if !UNITY_5_4_OR_NEWER
        typeof(ParticleEmitter),
        typeof(ParticleRenderer),
        typeof(ParticleAnimator),
#endif

        typeof(BoxCollider),
        typeof(MeshCollider),
        typeof(SphereCollider),
        typeof(CharacterController),
        typeof(CapsuleCollider),

        typeof(Animation),
        typeof(AnimationClip),
        typeof(AnimationState),

        typeof(SkinWeights),
        typeof(RenderTexture),
        typeof(Rigidbody),
    };

    //重载函数，相同参数个数，相同位置out参数匹配出问题时, 需要强制匹配解决
    //使用方法参见例子14
    public static List<Type> outList = new List<Type>()
    {
    };

    //ngui优化，下面的类没有派生类，可以作为sealed class
    public static List<Type> sealedList = new List<Type>()
    {
        /*typeof(Transform),
        typeof(UIRoot),
        typeof(UICamera),
        typeof(UIViewport),
        typeof(UIPanel),
        typeof(UILabel),
        typeof(UIAnchor),
        typeof(UIAtlas),
        typeof(UIFont),
        typeof(UITexture),
        typeof(UISprite),
        typeof(UIGrid),
        typeof(UITable),
        typeof(UIWrapGrid),
        typeof(UIInput),
        typeof(UIScrollView),
        typeof(UIEventListener),
        typeof(UIScrollBar),
        typeof(UICenterOnChild),
        typeof(UIScrollView),        
        typeof(UIButton),
        typeof(UITextList),
        typeof(UIPlayTween),
        typeof(UIDragScrollView),
        typeof(UISpriteAnimation),
        typeof(UIWrapContent),
        typeof(TweenWidth),
        typeof(TweenAlpha),
        typeof(TweenColor),
        typeof(TweenRotation),
        typeof(TweenPosition),
        typeof(TweenScale),
        typeof(TweenHeight),
        typeof(TypewriterEffect),
        typeof(UIToggle),
        typeof(Localization),*/
    };

    public static BindType _GT(Type t)
    {
        return new BindType(t);
    }

    public static DelegateType _DT(Type t)
    {
        return new DelegateType(t);
    }


    [MenuItem("Lua/Attach Profiler", false, 151)]
    static void AttachProfiler()
    {
        if (!Application.isPlaying)
        {
            EditorUtility.DisplayDialog("警告", "请在运行时执行此功能", "确定");
            return;
        }

        LuaClient.Instance.AttachProfiler();
    }

    [MenuItem("Lua/Detach Profiler", false, 152)]
    static void DetachProfiler()
    {
        if (!Application.isPlaying)
        {
            return;
        }

        LuaClient.Instance.DetachProfiler();
    }
}