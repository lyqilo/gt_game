local _CAnimateDefine = {};
local _idCreator = ID_Creator(0);
local __Enum_AnimateKind           = {
    InvalidValue            = _idCreator(0), --无效值
    SpriteFrameAnimate      = _idCreator(),  --sprite帧动画
    ImageFrameAnimate       = _idCreator(),  --Image帧动画
    LocalMoveAnimate        = _idCreator(),  --移动
    LocalScaleAnimate       = _idCreator(),  --移动
    FadeInAnimate           = _idCreator(),  --淡入
    FadeOutAnimate          = _idCreator(),  --淡出 最后消失
    DelayTime               = _idCreator(),  -- 空闲时间，什么都不做，可以理解为停留时间 
};
--动画类型定义
local __Enum_AnimateStyle          = {
    InvalidValue        = _idCreator(0), --无效值
    Wheel               = _idCreator(),
    Net                 = _idCreator(),
    FadeOut             = _idCreator(),  --淡出
    FadeIn              = _idCreator(),  --淡入
    LocalScale          = _idCreator(),  --缩放
    LocalMove           = _idCreator(),  --本地移动
    SpriteFrame         = _idCreator(),  --sprite帧动画
    ImageFrame          = _idCreator(),  --Image帧动画
    Monster_1_Move      = _idCreator(),
    Icon_0              = _idCreator(),
    Icon_1_Animator     = _idCreator(),
    Icon_2_Animator     = _idCreator(),
    Icon_3_Animator     = _idCreator(),
    Icon_4_Animator     = _idCreator(),
    Icon_5_Animator     = _idCreator(),
    Icon_6_Animator     = _idCreator(),
    Icon_7_Animator     = _idCreator(),
    Icon_8_Animator     = _idCreator(),
    Icon_9_Animator     = _idCreator(),
    Icon_10_Animator    = _idCreator(),
    Quick_Scroll        = _idCreator(), --快速转动
    ShanGuang           = _idCreator(), --闪光
    Star                = _idCreator(), --星星
    Qizi                = _idCreator(), --棋子

    Keeper_CT           = _idCreator(),
    Keeper_CD           = _idCreator(),
    Keeper_LT           = _idCreator(),
    Keeper_LD           = _idCreator(),
    
    FootBaller_1        = _idCreator(), --足球手  
    FootBaller_2        = _idCreator(), --足球手 
    FootBaller_3        = _idCreator(), --足球手 
    FootBaller_4        = _idCreator(), --足球手 
    FootBaller_5        = _idCreator(), --足球手   
};
    --动画类型定义
local __Enum_AnimateSetStyle          = {
    InvalidValue        = _idCreator(0), --无效值
    Monster_1_Move      = _idCreator(),
    FootBaller          = _idCreator(),
};

local AnimateStyle = __Enum_AnimateStyle;
local AnimateSetStyle = __Enum_AnimateSetStyle;
local AnimateKind = __Enum_AnimateKind;
local AnimateModelConfig = {
    AnimaStyleInfo = {  --单步动画
        [AnimateStyle.Wheel] = {
            animateType     = AnimateKind.SpriteFrameAnimate,  --默认为 AnimateKind.ImageFrameAnimate 帧动画
            isRaycastTarget = false, --是否接受事件，默认不接受
            abfileName  = "game_white_snake_ui",
            format="CJ_%03d",--帧名字格式化 
            customFrames = {},  --自定义帧队列 
            frameBeginIndex=0, --开始帧索引
            frameCount     =10,
            frameInterval  =1, --帧索引间隔
            frameMax       =11,
            interval       =0.05, --动画时间间隔
            isCorrentSize  = true, --是否需要矫正大小
            restartInterval= 1,    --循环时, 最后一帧到第一帧的时间间隔,为空默认取值interval;
            isReverseShow  = false,  --是否还原显示 为空默认为false
        },
        [AnimateStyle.SpriteFrame] = {
            animateType     = AnimateKind.SpriteFrameAnimate,  --默认为 AnimateKind.ImageFrameAnimate 帧动画
            abfileName  = "game_white_snake_ui",
            format="CJ_%03d",--帧名字格式化 
            customFrames = {},  --自定义帧队列 
            frameBeginIndex=0, --开始帧索引
            frameCount     =10,
            frameInterval  =1, --帧索引间隔
            frameMax       =11,
            interval       =0.05, --动画时间间隔
            isCorrentSize  = false, --是否需要矫正大小
            restartInterval= 1,    --循环时, 最后一帧到第一帧的时间间隔,为空默认取值interval;
        },
        [AnimateStyle.ImageFrame] = {
            animateType     = AnimateKind.ImageFrameAnimate,  --默认为 AnimateKind.ImageFrameAnimate 帧动画
            isRaycastTarget = false, --是否接受事件，默认不接受
            abfileName  = "game_white_snake_ui",
            format="CJ_%03d",--帧名字格式化 
            customFrames = {},  --自定义帧队列 
            frameBeginIndex=0, --开始帧索引
            frameCount     =10,
            frameInterval  =1, --帧索引间隔
            frameMax       =11,
            interval       =0.05, --动画时间间隔
            isCorrentSize  = true, --是否需要矫正大小
            restartInterval= 1,    --循环时, 最后一帧到第一帧的时间间隔,为空默认取值interval;
        },
        [AnimateStyle.FadeOut] = {  --淡出 
            animateType     = AnimateKind.FadeOutAnimate,  --默认为 AnimateKind.FrameAnimate 帧动画
            beginAlpha      = 0.8,   --开始的alpha 通道值
            endAlpha        = 0,     --结束的alpha 通道值
            time            = 1,     --时间
            isSameSpeed     = 1,     --1 为 匀速 , 0 为加速
        },
        [AnimateStyle.FadeIn]  = {
            animateType     = AnimateKind.FadeInAnimate,  --默认为 AnimateKind.FrameAnimate 帧动画
            beginAlpha      = 0,   --开始的alpha 通道值
            endAlpha        = 1,     --结束的alpha 通道值
            time            = 1,     --时间
            isSameSpeed     = 1,     --1 为 匀速 , 0 为加速
        },
        [AnimateStyle.LocalScale]  = {
            animateType     = AnimateKind.LocalScaleAnimate,  --默认为 AnimateKind.FrameAnimate 帧动画
            scaleSpeed      = Vector3.New(1,1,1),   --缩放速度，优先取这个
            beginScale      = Vector3.New(0,0,0),   --开始的 缩放值
            endScale        = Vector3.New(1,0.5,1),     --结束的缩放值,
            time            = 1,     --时间
            isSameSpeed     = 1,     --1 为 匀速 , 0 为加速
        },
        [AnimateStyle.LocalMove]  = {
            animateType     = AnimateKind.LocalMoveAnimate,  --默认为 AnimateKind.FrameAnimate 帧动画
            beginPos        = Vector3.New(0,0,0),           --开始位置
            endPos          = Vector3.New(200,200,200),     --结束位置
            time            = 1,     --时间
            isSameSpeed     = 1,     --1 为 匀速 , 0 为加速
        },

        --怪物动画
        [AnimateStyle.Monster_1_Move] = {  --白幽灵移动
            animateType     = AnimateKind.SpriteFrameAnimate,  --默认为 AnimateKind.ImageFrameAnimate 帧动画
            abfileName      = "test",
            format          = "baiyidong_%02d",  --帧名字格式化
            frameBeginIndex = 1,  --开始帧索引
            frameCount      = 6,
            frameInterval   = 1,  --帧索引间隔 
            interval        = 0.1, --动画时间间隔
            isCorrentSize   = true, --是否需要矫正大小
        },
        [AnimateStyle.Icon_1_Animator] = {
            animateType     = AnimateKind.ImageFrameAnimate,  --默认为 AnimateKind.ImageFrameAnimate 帧动画
            isRaycastTarget = false, --是否接受事件，默认不接受
            abfileName  = "game_ui",
            format="iconAnimate/feng_%05d",--帧名字格式化 
            customFrames = {},  --自定义帧队列 
            frameBeginIndex=0, --开始帧索引
            frameCount     =12,
            frameInterval  =1, --帧索引间隔
            --frameMax       =11,
            interval       =0.05, --动画时间间隔
            isCorrentSize  = true, --是否需要矫正大小
            restartInterval= 0.05,    --循环时, 最后一帧到第一帧的时间间隔,为空默认取值interval;
        },
        [AnimateStyle.Icon_2_Animator]  = {
            animateType     = AnimateKind.ImageFrameAnimate,  --默认为 AnimateKind.ImageFrameAnimate 帧动画
            isRaycastTarget = false, --是否接受事件，默认不接受
            abfileName  = "game_ui",
            format="iconAnimate/huo_%05d",--帧名字格式化 
            customFrames = {},  --自定义帧队列 
            frameBeginIndex=0, --开始帧索引
            frameCount     =12,
            frameInterval  =1, --帧索引间隔
            --frameMax       =11,
            interval       =0.05, --动画时间间隔
            isCorrentSize  = true, --是否需要矫正大小
            restartInterval= 0.05,    --循环时, 最后一帧到第一帧的时间间隔,为空默认取值interval;
        },
        [AnimateStyle.Icon_3_Animator]  = {
            animateType     = AnimateKind.ImageFrameAnimate,  --默认为 AnimateKind.ImageFrameAnimate 帧动画
            isRaycastTarget = false, --是否接受事件，默认不接受
            abfileName  = "game_ui",
            format="iconAnimate/xing_%05d",--帧名字格式化 
            customFrames = {},  --自定义帧队列 
            frameBeginIndex=0, --开始帧索引
            frameCount     =12,
            frameInterval  =1, --帧索引间隔
            --frameMax       =11,
            interval       =0.05, --动画时间间隔
            isCorrentSize  = true, --是否需要矫正大小
            restartInterval= 0.05,    --循环时, 最后一帧到第一帧的时间间隔,为空默认取值interval;
        },
        [AnimateStyle.Icon_4_Animator]  = {
            animateType     = AnimateKind.ImageFrameAnimate,  --默认为 AnimateKind.ImageFrameAnimate 帧动画
            isRaycastTarget = false, --是否接受事件，默认不接受
            abfileName  = "game_ui",
            format="iconAnimate/liangcao_%05d",--帧名字格式化 
            customFrames = {},  --自定义帧队列 
            frameBeginIndex=0, --开始帧索引
            frameCount     =24,
            frameInterval  =1, --帧索引间隔
            --frameMax       =11,
            interval       =0.05, --动画时间间隔
            isCorrentSize  = true, --是否需要矫正大小
            restartInterval= 0.1,    --循环时, 最后一帧到第一帧的时间间隔,为空默认取值interval;
        },
        [AnimateStyle.Icon_5_Animator]  = {
            animateType     = AnimateKind.ImageFrameAnimate,  --默认为 AnimateKind.ImageFrameAnimate 帧动画
            isRaycastTarget = false, --是否接受事件，默认不接受
            abfileName  = "game_ui",
            format="iconAnimate/wuqi_%05d",--帧名字格式化 
            customFrames = {},  --自定义帧队列 
            frameBeginIndex=0, --开始帧索引
            frameCount     =24,
            frameInterval  =1, --帧索引间隔
            --frameMax       =11,
            interval       =0.05, --动画时间间隔
            isCorrentSize  = true, --是否需要矫正大小
            restartInterval= 0.1,    --循环时, 最后一帧到第一帧的时间间隔,为空默认取值interval;
        },
        [AnimateStyle.Icon_6_Animator] = {
            animateType     = AnimateKind.ImageFrameAnimate,  --默认为 AnimateKind.ImageFrameAnimate 帧动画
            isRaycastTarget = false, --是否接受事件，默认不接受
            abfileName  = "game_ui",
            format="iconAnimate/jundui_%05d",--帧名字格式化 
            customFrames = {},  --自定义帧队列 
            frameBeginIndex=0, --开始帧索引
            frameCount     =24,
            frameInterval  =1, --帧索引间隔
            --frameMax       =11,
            interval       =0.05, --动画时间间隔
            isCorrentSize  = true, --是否需要矫正大小
            restartInterval= 0.1,    --循环时, 最后一帧到第一帧的时间间隔,为空默认取值interval;
        },
        [AnimateStyle.Icon_7_Animator] = {
            animateType     = AnimateKind.ImageFrameAnimate,  --默认为 AnimateKind.ImageFrameAnimate 帧动画
            isRaycastTarget = false, --是否接受事件，默认不接受
            abfileName  = "game_ui",
            format="iconAnimate/jiangjun_%05d",--帧名字格式化 
            customFrames = {},  --自定义帧队列 
            frameBeginIndex=0, --开始帧索引
            frameCount     =24,
            frameInterval  =1, --帧索引间隔
            --frameMax       =11,
            interval       =0.05, --动画时间间隔
            isCorrentSize  = true, --是否需要矫正大小
            restartInterval= 0.1,    --循环时, 最后一帧到第一帧的时间间隔,为空默认取值interval;
        },
        [AnimateStyle.Icon_8_Animator]= {
            animateType     = AnimateKind.ImageFrameAnimate,  --默认为 AnimateKind.ImageFrameAnimate 帧动画
            isRaycastTarget = false, --是否接受事件，默认不接受
            abfileName  = "game_ui",
            format="iconAnimate/wild_%05d",--帧名字格式化 
            customFrames = {},  --自定义帧队列 
            frameBeginIndex=0, --开始帧索引
            frameCount     =24,
            frameInterval  =1, --帧索引间隔
            --frameMax       =11,
            interval       =0.05, --动画时间间隔
            isCorrentSize  = true, --是否需要矫正大小
            restartInterval= 0.1,    --循环时, 最后一帧到第一帧的时间间隔,为空默认取值interval;
        },
        [AnimateStyle.Icon_9_Animator]   = {
            animateType     = AnimateKind.ImageFrameAnimate,  --默认为 AnimateKind.ImageFrameAnimate 帧动画
            isRaycastTarget = false, --是否接受事件，默认不接受
            abfileName  = "game_ui",
            format="iconAnimate/free_%05d",--帧名字格式化 
            customFrames = {},  --自定义帧队列 
            frameBeginIndex=0, --开始帧索引
            frameCount     =24,
            frameInterval  =1, --帧索引间隔
            --frameMax       =11,
            interval       =0.05, --动画时间间隔
            isCorrentSize  = true, --是否需要矫正大小
            restartInterval= 0.1,    --循环时, 最后一帧到第一帧的时间间隔,为空默认取值interval;
        },
        [AnimateStyle.Icon_10_Animator]   = {
            animateType     = AnimateKind.ImageFrameAnimate,  --默认为 AnimateKind.ImageFrameAnimate 帧动画
            isRaycastTarget = false, --是否接受事件，默认不接受
            abfileName  = "game_ui",
            format="iconAnimate/jackpot_%05d",--帧名字格式化 
            customFrames = {},  --自定义帧队列 
            frameBeginIndex=0, --开始帧索引
            frameCount     =0,
            frameInterval  =1, --帧索引间隔
            --frameMax       =11,
            interval       =0.05, --动画时间间隔
            isCorrentSize  = true, --是否需要矫正大小
            restartInterval= 0.1,    --循环时, 最后一帧到第一帧的时间间隔,为空默认取值interval;
        },
        [AnimateStyle.Quick_Scroll] = {
            animateType     = AnimateKind.ImageFrameAnimate,  --默认为 AnimateKind.ImageFrameAnimate 帧动画
            isRaycastTarget = false, --是否接受事件，默认不接受
            abfileName  = "game_ui",
            format="qucikScroll/zdk_%05d",--帧名字格式化 
            customFrames = {},  --自定义帧队列 
            frameBeginIndex=0, --开始帧索引
            frameCount     =14,
            frameInterval  =1, --帧索引间隔
            --frameMax       =11,
            interval       =0.05, --动画时间间隔
            isCorrentSize  = true, --是否需要矫正大小
            --restartInterval= 1,    --循环时, 最后一帧到第一帧的时间间隔,为空默认取值interval;
        },
        [AnimateStyle.ShanGuang] = {
            animateType     = AnimateKind.ImageFrameAnimate,  --默认为 AnimateKind.ImageFrameAnimate 帧动画
            isRaycastTarget = false, --是否接受事件，默认不接受
            abfileName  = "game_ui",
            format="shanguang/sweep%d",--帧名字格式化 
            customFrames = {},  --自定义帧队列 
            frameBeginIndex=1, --开始帧索引
            frameCount     =4,
            frameInterval  =1, --帧索引间隔
            --frameMax       =11,
            interval       =0.08, --动画时间间隔
            isCorrentSize  = true, --是否需要矫正大小
            --restartInterval= 1,    --循环时, 最后一帧到第一帧的时间间隔,为空默认取值interval;
        },
        [AnimateStyle.Star] = {
            animateType     = AnimateKind.ImageFrameAnimate,  --默认为 AnimateKind.ImageFrameAnimate 帧动画
            isRaycastTarget = false, --是否接受事件，默认不接受
            abfileName  = "game_ui",
            format="star/starlight1_%05d",--帧名字格式化 
            customFrames = {},  --自定义帧队列 
            frameBeginIndex=1, --开始帧索引
            frameCount     =7,
            frameInterval  =1, --帧索引间隔
            --frameMax       =11,
            interval       =0.08, --动画时间间隔
            isCorrentSize  = true, --是否需要矫正大小
            --restartInterval= 1,    --循环时, 最后一帧到第一帧的时间间隔,为空默认取值interval;
        },
        [AnimateStyle.Qizi] = {
            animateType     = AnimateKind.ImageFrameAnimate,  --默认为 AnimateKind.ImageFrameAnimate 帧动画
            isRaycastTarget = false, --是否接受事件，默认不接受
            abfileName  = "game_ui",
            format="animates/qizi/qizhi%d",--帧名字格式化 
            customFrames = {},  --自定义帧队列 
            frameBeginIndex=0, --开始帧索引
            frameCount     =10,
            frameInterval  =1, --帧索引间隔
            --frameMax       =11,
            interval       =0.16, --动画时间间隔
            isCorrentSize  = true, --是否需要矫正大小
            --restartInterval= 1,    --循环时, 最后一帧到第一帧的时间间隔,为空默认取值interval;
        },
        [AnimateStyle.Keeper_CT] = {
            animateType     = AnimateKind.ImageFrameAnimate,  --默认为 AnimateKind.ImageFrameAnimate 帧动画
            isRaycastTarget = false, --是否接受事件，默认不接受
            abfileName  = "game_ui",
            format="keepers/kp_ct_%d",--帧名字格式化 
            customFrames = {},  --自定义帧队列 
            frameBeginIndex=1, --开始帧索引
            frameCount     =13,  --19
            frameInterval  =1, --帧索引间隔
            --frameMax       =11,
            interval       =0.046, --动画时间间隔
            isCorrentSize  = true, --是否需要矫正大小
            --restartInterval= 1,    --循环时, 最后一帧到第一帧的时间间隔,为空默认取值interval;
        },
        [AnimateStyle.Keeper_CD] = {
            animateType     = AnimateKind.ImageFrameAnimate,  --默认为 AnimateKind.ImageFrameAnimate 帧动画
            isRaycastTarget = false, --是否接受事件，默认不接受
            abfileName  = "game_ui",
            format="keepers/kp_cd_%d",--帧名字格式化 
            customFrames = {},  --自定义帧队列 
            frameBeginIndex=1, --开始帧索引
            frameCount     =6, --7
            frameInterval  =1, --帧索引间隔
            --frameMax       =11,
            interval       =0.075, --动画时间间隔
            isCorrentSize  = true, --是否需要矫正大小
            --restartInterval= 1,    --循环时, 最后一帧到第一帧的时间间隔,为空默认取值interval;
        },
        [AnimateStyle.Keeper_LT] = {
            animateType     = AnimateKind.ImageFrameAnimate,  --默认为 AnimateKind.ImageFrameAnimate 帧动画
            isRaycastTarget = false, --是否接受事件，默认不接受
            abfileName  = "game_ui",
            format="keepers/kp_lt_%d",--帧名字格式化 
            customFrames = {},  --自定义帧队列 
            frameBeginIndex=1, --开始帧索引
            frameCount     =11, --24
            frameInterval  =1, --帧索引间隔
            --frameMax       =11,
            interval       =0.05, --动画时间间隔
            isCorrentSize  = true, --是否需要矫正大小
            --restartInterval= 1,    --循环时, 最后一帧到第一帧的时间间隔,为空默认取值interval;
        },
        [AnimateStyle.Keeper_LD] = {
            animateType     = AnimateKind.ImageFrameAnimate,  --默认为 AnimateKind.ImageFrameAnimate 帧动画
            isRaycastTarget = false, --是否接受事件，默认不接受
            abfileName  = "game_ui",
            format="keepers/kp_ld_%d",--帧名字格式化 
            customFrames = {},  --自定义帧队列 
            frameBeginIndex=1, --开始帧索引
            frameCount     =13, --13
            frameInterval  =1, --帧索引间隔
            --frameMax       =11,
            interval       =0.046, --动画时间间隔
            isCorrentSize  = true, --是否需要矫正大小
            --restartInterval= 1,    --循环时, 最后一帧到第一帧的时间间隔,为空默认取值interval;
        },
        [AnimateStyle.FootBaller_1] = {
            animateType     = AnimateKind.ImageFrameAnimate,  --默认为 AnimateKind.ImageFrameAnimate 帧动画
            isRaycastTarget = false, --是否接受事件，默认不接受
            abfileName  = "game_ui",
            format="footballer/shot_%d",--帧名字格式化 
            customFrames = {},  --自定义帧队列 
            frameBeginIndex=1, --开始帧索引
            frameCount     =1,
            frameInterval  =1, --帧索引间隔
            --frameMax       =11,
            interval       =0.07, --动画时间间隔
            isCorrentSize  = true, --是否需要矫正大小
            --restartInterval= 1,    --循环时, 最后一帧到第一帧的时间间隔,为空默认取值interval;
        },
        [AnimateStyle.FootBaller_2] = {
            animateType     = AnimateKind.ImageFrameAnimate,  --默认为 AnimateKind.ImageFrameAnimate 帧动画
            isRaycastTarget = false, --是否接受事件，默认不接受
            abfileName  = "game_ui",
            format="footballer/shot_%d",--帧名字格式化 
            customFrames = {},  --自定义帧队列 
            frameBeginIndex=2, --开始帧索引
            frameCount     =1,
            frameInterval  =1, --帧索引间隔
            --frameMax       =11,
            interval       =0.07, --动画时间间隔
            isCorrentSize  = true, --是否需要矫正大小
            --restartInterval= 1,    --循环时, 最后一帧到第一帧的时间间隔,为空默认取值interval;
        },
        [AnimateStyle.FootBaller_3] = {
            animateType     = AnimateKind.ImageFrameAnimate,  --默认为 AnimateKind.ImageFrameAnimate 帧动画
            isRaycastTarget = false, --是否接受事件，默认不接受
            abfileName  = "game_ui",
            format="footballer/shot_%d",--帧名字格式化 
            customFrames = {},  --自定义帧队列 
            frameBeginIndex=3, --开始帧索引
            frameCount     =1,
            frameInterval  =1, --帧索引间隔
            --frameMax       =11,
            interval       =0.07, --动画时间间隔
            isCorrentSize  = true, --是否需要矫正大小
            --restartInterval= 1,    --循环时, 最后一帧到第一帧的时间间隔,为空默认取值interval;
        },
        [AnimateStyle.FootBaller_4] = {
            animateType     = AnimateKind.ImageFrameAnimate,  --默认为 AnimateKind.ImageFrameAnimate 帧动画
            isRaycastTarget = false, --是否接受事件，默认不接受
            abfileName  = "game_ui",
            format="footballer/shot_%d",--帧名字格式化 
            customFrames = {},  --自定义帧队列 
            frameBeginIndex=4, --开始帧索引
            frameCount     =1,
            frameInterval  =1, --帧索引间隔
            --frameMax       =11,
            interval       =0.07, --动画时间间隔
            isCorrentSize  = true, --是否需要矫正大小
            --restartInterval= 1,    --循环时, 最后一帧到第一帧的时间间隔,为空默认取值interval;
        },
        [AnimateStyle.FootBaller_5] = {
            animateType     = AnimateKind.ImageFrameAnimate,  --默认为 AnimateKind.ImageFrameAnimate 帧动画
            isRaycastTarget = false, --是否接受事件，默认不接受
            abfileName  = "game_ui",
            format="footballer/shot_%d",--帧名字格式化 
            customFrames = {},  --自定义帧队列 
            frameBeginIndex=5, --开始帧索引
            frameCount     =1,
            frameInterval  =1, --帧索引间隔
            --frameMax       =11,
            interval       =0.07, --动画时间间隔
            isCorrentSize  = true, --是否需要矫正大小
            --restartInterval= 1,    --循环时, 最后一帧到第一帧的时间间隔,为空默认取值interval;
        },
    },
    --动画集合
    AnimateSetsStyle    = {
        [AnimateSetStyle.FootBaller]     = {
            animateSets = {  --表里面存档，动画单元，动画单元是线性，顺序执行
                loop = 1,
                [1] = {   
                    actionUnits = { --动画单元 里面的动画是并行  
                        [1] = {  --每一步里面的动画
                            waitTime   = 0,
                            animateType= AnimateStyle.FootBaller_1,
                            loop       =  1,  
                        },
                    },
                },
                [2] = {   
                    actionUnits = { --动画单元 里面的动画是并行  
                        [1] = {  --每一步里面的动画
                            waitTime   = 0,
                            animateType= AnimateStyle.FootBaller_2,
                            loop       =  1,  
                        },
                    },
                },
                [3] = {   
                    actionUnits = { --动画单元 里面的动画是并行  
                        [1] = {  --每一步里面的动画
                            waitTime   = 0,
                            animateType= AnimateStyle.FootBaller_3,
                            loop       =  1,  
                        },
                    },
                },
                [4] = {   
                    actionUnits = { --动画单元 里面的动画是并行  
                        [1] = {  --每一步里面的动画
                            waitTime   = 0,
                            animateType= AnimateStyle.FootBaller_4,
                            loop       =  1,  
                        },
                    },
                },
                [5] = {   
                    actionUnits = { --动画单元 里面的动画是并行  
                        [1] = {  --每一步里面的动画
                            waitTime   = 0,
                            animateType= AnimateStyle.FootBaller_5,
                            loop       =  1,  
                        },
                    },
                },
            },
        },
        [AnimateSetStyle.Monster_1_Move] = {
            animateSets = {  --表里面存档，动画单元，动画单元是线性，顺序执行
                loop = -1,
                [1] = {   
                    actionUnits = { --动画单元 里面的动画是并行  
                        [1] = {  --每一步里面的动画
                            waitTime   = 0,
                            animateType= AnimateStyle.Monster_18_Move_3,
                            loop       =  1,  
                        },
                    },
                },
                [2] = {   
                    actionUnits = { --动画单元 里面的动画是并行  
                        [1] = {  --每一步里面的动画
                            waitTime   = 0,
                            animateType= AnimateStyle.Monster_18_Move,
                            loop       =  1,  
                        },
                    },
                },
                [3] = {   
                    actionUnits = { --动画单元 里面的动画是并行  
                        [1] = {  --每一步里面的动画
                            waitTime   = 0,
                            animateType= AnimateStyle.Monster_18_Move_4,
                            loop       =  1,  
                        },
                    },
                },
                [4] = {   
                    actionUnits = { --动画单元 里面的动画是并行  
                        [1] = {  --每一步里面的动画
                            waitTime   = 0,
                            animateType= AnimateStyle.Monster_18_Move_4,
                            loop       =  1,  
                        },
                    },
                },
                [5] = {   
                    actionUnits = { --动画单元 里面的动画是并行  
                        [1] = {  --每一步里面的动画
                            waitTime   = 0,
                            animateType= AnimateStyle.Monster_18_Move,
                            loop       =  1,  
                        },
                    },
                },
                [6] = { 
                    actionUnits = { --动画单元 里面的动画是并行  
                        [1] = {  --每一步里面的动画
                            waitTime   = 0,
                            animateType= AnimateStyle.Monster_18_Move_2,
                            loop       =  1,  
                        },
                    },
                },
                [7] = {   
                    actionUnits = { --动画单元 里面的动画是并行  
                        [1] = {  --每一步里面的动画
                            waitTime   = 0,
                            animateType= AnimateStyle.Monster_18_Move_1,
                            loop       =  1,  
                        },
                    },
                },
                [8] = { 
                    actionUnits = { --动画单元 里面的动画是并行  
                        [1] = {  --每一步里面的动画
                            waitTime   = 0,
                            animateType= AnimateStyle.Monster_18_Move_2,
                            loop       =  1,  
                        },
                    },
                },
            },
        },
    },    
};

--获取数据
function _CAnimateDefine.GetAnimateData(_type)
    return AnimateModelConfig.AnimaStyleInfo[_type];
end

--获取数据
function _CAnimateDefine.GetAnimateSetData(_settype)
    return AnimateModelConfig.AnimateSetsStyle[_settype];
end

_CAnimateDefine.Enum_AnimateKind = __Enum_AnimateKind;
_CAnimateDefine.Enum_AnimateStyle = __Enum_AnimateStyle;
_CAnimateDefine.Enum_AnimateSetStyle = __Enum_AnimateSetStyle;
return _CAnimateDefine;