local VECTOR3DIS                                        = VECTOR3DIS                                       
local VECTOR3ZERO                                       = VECTOR3ZERO                                      
local VECTOR3ONE                                        = VECTOR3ONE                                       
local COLORNEW                                          = COLORNEW                                         
local QUATERNION_EULER                                  = QUATERNION_EULER                                 
local QUATERNION_LOOKROTATION                           = QUATERNION_LOOKROTATION                          
local C_Quaternion_Zero                                 = C_Quaternion_Zero                                
local C_Vector3_Zero                                    = C_Vector3_Zero                                   
local C_Vector3_One                                     = C_Vector3_One                                    
local C_Color_One                                       = C_Color_One                                      
local V_Vector3_Value                                   = V_Vector3_Value                                  
local V_Color_Value                                     = V_Color_Value                                    
local ImageAnimaClassType                               = ImageAnimaClassType                              
local ImageClassType                                    = ImageClassType                                   
local GAMEOBJECT_NEW                                    = GAMEOBJECT_NEW                                   
local BoxColliderClassType                              = BoxColliderClassType                             
local ParticleSystemClassType                           = ParticleSystemClassType                          
local UTIL_ADDCOMPONENT                                 = UTIL_ADDCOMPONENT                                
local MATH_SQRT                                         = MATH_SQRT                                        
local MATH_SIN                                          = MATH_SIN                                         
local MATH_COS                                          = MATH_COS  
local MATH_ATAN                                         = MATH_ATAN
local MATH_TAN                                          = MATH_TAN                                       
local MATH_FLOOR                                        = MATH_FLOOR                                       
local MATH_ABS                                          = MATH_ABS                                         
local MATH_RAD                                          = MATH_RAD                                         
local MATH_RAD2DEG                                      = MATH_RAD2DEG                                     
local MATH_DEG                                          = MATH_DEG                                         
local MATH_DEG2RAD                                      = MATH_DEG2RAD                                     
local MATH_RANDOM                                       = MATH_RANDOM  
local MATH_PI                                           = MATH_PI 


local ExternalLibs  = require "Common.ExternalLibs";
local EventSystem = ExternalLibs.EventSystem;

--local _CGlobalGame = class("_CGlobalGame");
local _CGlobalGame = class();


local AtlasNumber = GameRequire("AtlasNumber");

local _idCreator = ID_Creator(0);
local idCreator  = ID_Creator(0);

function _CGlobalGame:ctor()
    self._eventSystem   = EventSystem.New();
    self._cachePool     = nil;
    self._beginTickCount= 0;
    self._runTime       = 0;
    self._isInitSuccess = false;
    self._valuesMap     = map:new();
    self._soundCtrl     = nil;
    self._cacheObjs     = {};
    --self._fileOut       = io.open("c:\\fishLog.txt", "w+");
    --self:writeLog("startGame");

    --
    self._nameGroupCreator = {};

    self._helpPanelCreator = GameRequire("HelpPanel");
    self._helpPanel        = nil;

    self.defaultCacheGOName = "Tps";

    self._isInitResourceSuccess = false;
	self.bulletId=0;
end

function _CGlobalGame:writeLog(str)
    --self._fileOut:write(str .. "\r\n");
    --self._fileOut:flush();
end

function _CGlobalGame:closeLog()
    --self._fileOut:close();
end



function _CGlobalGame:Init()
    --����
    self.ConstDefine                = {
        --�������
        C_S_FISH_KIND_MAX           = 40,
        --�ӵ�����
        C_S_BULLET_KIND_MAX         = 8,
        --�Ƿ�����ID
        C_S_INVALID_FISH_ID         = 0,
        --�Ƿ���������
        C_S_INVALID_FISH_TYPE       = -1,
        --�Ƿ���λ��
        C_S_INVALID_CHAIR_ID        = -1,
        --�Ƿ��ӵ�ID
        C_S_INVALID_BULLET_ID       = 0, 
        --��Ҹ���  
        C_S_PLAYER_COUNT            = 4,
        --�Ƿ����ӵ����� 
        C_S_INVALID_BULLET_TYPE     = 0xffff,
        --�Ƿ���̨���� 
        C_S_INVALID_PAOTAI_TYPE     = -1,
        --��Ϸ��Ӧ��ID
        GAME_ID                     = 4,
    };

    --layer���
    self.Enum_Layer =  {
        UI   = idCreator(5), --UIlayer
    };

    --�¼�����
    self.Enum_EventID               = {
        --ϵͳ�¼�
        SYS_PlayEffect          = idCreator(0), --������Ч
        SYS_PlayBackgroundSound = idCreator(), --���ű�������
        SYS_StopBackgroundSound = idCreator(), --ֹͣ��������

        --�ֲ��¼�
        FishDead        = idCreator(3000),
        FishDie         = idCreator(),
        NetActionEnd    = idCreator(),
        BulletDisappear = idCreator(),
        BulletDelete    = idCreator(),
        BeforeFishEnterScreen = idCreator(), --�������Ļ֮ǰ
        BeforeFishLeaveScreen = idCreator(), --���뿪��Ļ֮ǰ
        FishEnterScreen = idCreator(),  --�������Ļ
        FishLeaveScreen = idCreator(),  --���뿪��Ļ
        FlyGoldDisappear= idCreator(),  --�����ʧ���¼�
        FlyGoldGroupDisappear = idCreator(),  --�������ʧ���¼�
        ScoreColumnDisappear  = idCreator(),  --��Ҷ���ʧ���¼�
        EffectDisappear = idCreator(),   --Ч����ʧ
        ShowGoldNumberDisappear = idCreator(), --��ʾ���������ʧ���¼�
        UIEffectDisappear= idCreator(),  --UI��Ч��ʧ
    
    
        --ȫ�ֵ��¼�
        GameConfig          = idCreator(10000),
        UserFire            = idCreator(),
        UserEnter           = idCreator(),
        UserLeave           = idCreator(),
        UserScore           = idCreator(),
        NotifyEnterGame     = idCreator(),
        ExchangeFishGold    = idCreator(),
        DownFishGold        = idCreator(),
        CreateFish          = idCreator(),
        CatchFish           = idCreator(),
        CatchCauseFish      = idCreator(), --׽���㣬����������ը��������
        CatchGroupFish      = idCreator(), --׽����������ը�������������������
        EnergyTimeOut       = idCreator(), --�����ڵ���
        HitLK               = idCreator(), --ײ������
        SwitchScene         = idCreator(), --�л��������㳱����
        CreateBullet        = idCreator(), --�����ӵ�
        FishHurt            = idCreator(),
        NewHandEnd          = idCreator(), --������������
        NotifySwitchPao     = idCreator(), --֪ͨ�л���̨
        NotifyAddScore      = idCreator(), --֪ͨ�Ϸ�
        NotifyRemoveScore   = idCreator(), --֪ͨ�·�
        NotifyCreateEffect  = idCreator(), --֪ͨ������Ч
        NotifyCreateLine    = idCreator(), --������������
        NotifyCreateLineSour= idCreator(), --������������Դͷ
        NotifyCreatePauseScrn= idCreator(), --��������Ч��
        NotifyClearEffectType= idCreator(), --ɾ������Ч��
        NotifyCreateBeatEffect= idCreator(), --�����ӵ����Ч��
        NotifyUIBossBattleOver= idCreator(), --bossս����
        NotifyAddEffect     = idCreator(),  
        NotifyFishGroupOver = idCreator(), --�㳱����
        NotifyShakeScreen   = idCreator(), --����Ļ
        NotifyClearAllEffects= idCreator(), --������е�Ч��
        NotifyCreateFlyGold = idCreator(), --�����ɽ��
        LoginSuccess        = idCreator(), --��½�ɹ�
        ReloadGame          = idCreator(), --���¼�����Ϸ
    };

    --��ֵ�Զ���
    self.Enum_KeyValue               = 
    {
        GetFishById         = _idCreator(0),
        GetScenePixelSize   = _idCreator(), --�õ��������ش�С
        GetIsInSwitchScene  = _idCreator(), --�Ƿ����л��㳱
        GetRealSceneSize    = _idCreator(), --�õ�չʾ���ڴ�С,
        GetSceneIsRotation  = _idCreator(), --��ȡ�����Ƿ���ת��
        CreateUIFish        = _idCreator(), --����UI��
    };

    --��������
    self.Enum_NetType               = 
    {
        Invalid = _idCreator(-1),
        Common  =  _idCreator(0),
        Double  =  _idCreator(),
        Three   =  _idCreator(),
    };

    --�㳱����
    self.Enum_SceneKind             =
    {
        SCENE_KIND_1 = _idCreator(0),
        SCENE_KIND_2 = _idCreator(),
        SCENE_KIND_3 = _idCreator(),
        SCENE_KIND_4 = _idCreator(),
        SCENE_KIND_5 = _idCreator(),
        SCENE_KIND_COUNT = _idCreator(),
    }; 

    --����ƶ��켣
    self.Enum_TraceType             = {
        TRACE_LINEAR = 0,
        TRACE_BEZIER = 1,
    };

    --�������
    self.Enum_FishType              = {
        FISH_KIND_1     = _idCreator(0),
        FISH_KIND_2     = _idCreator(),
        FISH_KIND_3     = _idCreator(),
        FISH_KIND_4     = _idCreator(),
        FISH_KIND_5     = _idCreator(),
        FISH_KIND_6     = _idCreator(),
        FISH_KIND_7     = _idCreator(),
        FISH_KIND_8     = _idCreator(),
        FISH_KIND_9     = _idCreator(),
        FISH_KIND_10    = _idCreator(),
        FISH_KIND_11    = _idCreator(),
        FISH_KIND_12    = _idCreator(),
        FISH_KIND_13    = _idCreator(),
        FISH_KIND_14    = _idCreator(),
        FISH_KIND_15    = _idCreator(),
        FISH_KIND_16    = _idCreator(),
        FISH_KIND_17    = _idCreator(),
        FISH_KIND_18    = _idCreator(),
        FISH_KIND_19    = _idCreator(),
        FISH_KIND_20    = _idCreator(),
        FISH_KIND_21    = _idCreator(),
        FISH_KIND_22    = _idCreator(),
        FISH_KIND_23    = _idCreator(),
        FISH_KIND_24    = _idCreator(),
        FISH_KIND_25    = _idCreator(),
        FISH_KIND_26    = _idCreator(),
        FISH_KIND_27    = _idCreator(),
        FISH_KIND_28    = _idCreator(),
        FISH_KIND_29    = _idCreator(),
        FISH_KIND_30    = _idCreator(),
        FISH_KIND_31    = _idCreator(),
        FISH_KIND_32    = _idCreator(),
        FISH_KIND_33    = _idCreator(),
        FISH_KIND_34    = _idCreator(),
        FISH_KIND_35    = _idCreator(),
        FISH_KIND_36    = _idCreator(),
        FISH_KIND_37    = _idCreator(),
        FISH_KIND_38    = _idCreator(),
        FISH_KIND_39    = _idCreator(),
        FISH_KIND_40    = _idCreator(),
        FISH_KIND_COUNT = _idCreator()-1,
    };

    --�ӵ�����
    self.Enum_BulletType            = {
        InvalidType         = _idCreator(self.ConstDefine.C_S_INVALID_BULLET_TYPE),
        BULLET_KIND_1_NORMAL = _idCreator(0),
        BULLET_KIND_2_NORMAL = _idCreator(),
        BULLET_KIND_3_NORMAL = _idCreator(),
        BULLET_KIND_4_NORMAL = _idCreator(),
        BULLET_KIND_1_ION = _idCreator(),
        BULLET_KIND_2_ION = _idCreator(),
        BULLET_KIND_3_ION = _idCreator(),
        BULLET_KIND_4_ION = _idCreator(),
        BULLET_KIND_COUNT = _idCreator(),
    };

    --��̨����
    self.Enum_PaotaiType            = {
        InvalidType     = _idCreator(self.ConstDefine.C_S_INVALID_PAOTAI_TYPE),
        Paotai_1        = _idCreator(1),
        Paotai_2        = _idCreator(),
        Paotai_3        = _idCreator(),
        Paotai_4        = _idCreator(),
        Paotai_Energy_1 = _idCreator(),
        Paotai_Energy_2 = _idCreator(),
        Paotai_Energy_3 = _idCreator(),
        Paotai_Energy_4 = _idCreator(),
    };

    --��ըЧ������
    self.Enum_EffectType   = {
        FishDead    = _idCreator(0),
        DingPing    = _idCreator(),
        JuBuBomb    = _idCreator(),
        QuanPing    = _idCreator(),
        Line        = _idCreator(),
        LineSource  = _idCreator(),
        PauseScreen = _idCreator(), --����Ч��
        BeatFish    = _idCreator(), --�����Ч��
        BeatMyFish  = _idCreator(), --�������Լ�����
        FishKingDead= _idCreator(), --��������
        SmallFishDead= _idCreator(), --С������
        Max         = _idCreator(),
    };

    --Ԥ��������
    self.Enum_PrefabType            = {
        InvalidType             = _idCreator(0xff),
        Self_Paotai_1           = _idCreator(1),
        Other_Paotai_1          = _idCreator(),
        Self_Paotai_2           = _idCreator(),
        Other_Paotai_2          = _idCreator(),
        Self_Paotai_3           = _idCreator(),
        Other_Paotai_3          = _idCreator(),
        Paotai_Energy           = _idCreator(),
        Paotai_Energy_1         = _idCreator(),
        Paotai_Energy_2         = _idCreator(),
        Paotai_Energy_3         = _idCreator(),
        Self_Bullet_1           = _idCreator(),
        Self_Bullet_2           = _idCreator(),
        Self_Bullet_3           = _idCreator(),
        Other_Bullet_1          = _idCreator(),
        Other_Bullet_2          = _idCreator(),
        Other_Bullet_3          = _idCreator(),
        Bullet_Energy_1         = _idCreator(),
        Bullet_Energy_2         = _idCreator(),
        Bullet_Energy_3         = _idCreator(),
        CommonBullet            = _idCreator(),
        FISH_KIND_1             = _idCreator(),
        FISH_KIND_2             = _idCreator(),
        FISH_KIND_3             = _idCreator(),
        FISH_KIND_4             = _idCreator(),
        FISH_KIND_5             = _idCreator(),
        FISH_KIND_6             = _idCreator(),
        FISH_KIND_7             = _idCreator(),
        FISH_KIND_8             = _idCreator(),
        FISH_KIND_9             = _idCreator(),
        FISH_KIND_10            = _idCreator(),
        FISH_KIND_11            = _idCreator(),
        FISH_KIND_12            = _idCreator(),
        FISH_KIND_13            = _idCreator(),
        FISH_KIND_14            = _idCreator(),
        FISH_KIND_15            = _idCreator(),
        FISH_KIND_16            = _idCreator(),
        FISH_KIND_17            = _idCreator(),
        FISH_KIND_18            = _idCreator(),
        FISH_KIND_19            = _idCreator(),
        FISH_KIND_20            = _idCreator(),
        FISH_KIND_21            = _idCreator(),
        FISH_KIND_22            = _idCreator(),
        FISH_KIND_23            = _idCreator(),
        FISH_KIND_24            = _idCreator(),
        FISH_KIND_25            = _idCreator(),
        FISH_KIND_26            = _idCreator(),
        FISH_KIND_27            = _idCreator(),
        FISH_KIND_28            = _idCreator(),
        FISH_KIND_29            = _idCreator(),
        FISH_KIND_30            = _idCreator(),
        FISH_KIND_31            = _idCreator(),
        FISH_KIND_32            = _idCreator(),
        FISH_KIND_33            = _idCreator(),
        FISH_KIND_34            = _idCreator(),
        FISH_KIND_35            = _idCreator(),
        FISH_KIND_36            = _idCreator(),
        FISH_KIND_37            = _idCreator(),
        FISH_KIND_38            = _idCreator(),
        FISH_KIND_39            = _idCreator(),
        FISH_KIND_40            = _idCreator(),
        LockLine                = _idCreator(),
        LockTarget_1            = _idCreator(),
        LockTarget_2            = _idCreator(),
        LockTarget_3            = _idCreator(),
        LockTarget_4            = _idCreator(),
        ScoreColumnRed          = _idCreator(),
        ScoreColumnGreen        = _idCreator(),
        Effect_FishDead         = _idCreator(),
        Effect_Bomb             = _idCreator(),
        Effect_Line             = _idCreator(),
        Effect_PauseScreen      = _idCreator(),
        Effect_MyBeat           = _idCreator(),  --�Լ������Ч
        Effect_Beat             = _idCreator(),  --�����Ч
        Effect_BingGuiDead      = _idCreator(),  --����������Ч
        Effect_Jubu             = _idCreator(),  --�ֲ���ը��Ч
        Effect_FishKingDead     = _idCreator(),  --��������
        Effect_SmallFishDead    = _idCreator(),  --С������

        LockFishFlag_1          = _idCreator(),
        LockFishFlag_2          = _idCreator(),
        LockFishFlag_3          = _idCreator(),
        LockFishFlag_4          = _idCreator(),
        LockFishFlag_5          = _idCreator(),
        LockFishFlag_6          = _idCreator(),
        LockFishFlag_7          = _idCreator(),
        LockFishFlag_8          = _idCreator(),
        LockFishFlag_9          = _idCreator(),
        LockFishFlag_10         = _idCreator(),
        LockFishFlag_11         = _idCreator(),
        LockFishFlag_12         = _idCreator(),
        LockFishFlag_13         = _idCreator(),
        LockFishFlag_14         = _idCreator(),
        LockFishFlag_15         = _idCreator(),
        LockFishFlag_16         = _idCreator(),
        LockFishFlag_17         = _idCreator(),
        LockFishFlag_18         = _idCreator(),
        LockFishFlag_19         = _idCreator(),
        LockFishFlag_20         = _idCreator(),
        LockFishFlag_21         = _idCreator(),
        LockFishFlag_22         = _idCreator(),
        LockFishFlag_23         = _idCreator(),
        LockFishFlag_24         = _idCreator(),
        LockFishFlag_25         = _idCreator(),
        LockFishFlag_26         = _idCreator(),
        LockFishFlag_27         = _idCreator(),
        LockFishFlag_28         = _idCreator(),
        LockFishFlag_29         = _idCreator(),
        LockFishFlag_30         = _idCreator(),
        LockFishFlag_31         = _idCreator(),
        LockFishFlag_32         = _idCreator(),
        LockFishFlag_33         = _idCreator(),
        LockFishFlag_34         = _idCreator(),
        LockFishFlag_35         = _idCreator(),
        LockFishFlag_36         = _idCreator(),
        LockFishFlag_37         = _idCreator(),
        LockFishFlag_38         = _idCreator(),
        LockFishFlag_39         = _idCreator(),
        LockFishFlag_40         = _idCreator(),

    };

    --�㳱����
    self.Enum_FishGroupType         = {
       FishGroup_1  = _idCreator(0),
       FishGroup_2  = _idCreator(),
       FishGroup_3  = _idCreator(),
       FishGroup_4  = _idCreator(),
    };

    --�������
    self.Enum_GoldType              =
    {
        Gold   = _idCreator(0),
        Silver = _idCreator(),
    };

    --��������
    self.Enum_FishUnderPanType      = {
        Null    = _idCreator(0),  --�޵���
        Group   = _idCreator(),   --����Ԫ�����ߴ���ϲ����
        Boss    = _idCreator(),   --��������
        Custom  = _idCreator(),   --�Զ���
    };

    --���������
    self.Enum_FishCombType          = {
        Single      = _idCreator(0),  --����
        Group       = _idCreator(),   --����Ԫ�����ߴ���ϲ����
    };

    --�������Ͷ���
    self.Enum_AnimateType           = {
        InvalidValue    = _idCreator(0), --��Чֵ
        Wheel           = _idCreator(),
        FlyGold         = _idCreator(),
        FlySilver       = _idCreator(),
        Net             = _idCreator(),
        Net_Self_1      = _idCreator(), --1����
        Net_Self_2      = _idCreator(), --2����
        Net_Self_3      = _idCreator(), --3����
        Net_Self        = _idCreator(), --�Լ�������
        Net_Other       = _idCreator(), --���˵�����
        Net_1           = _idCreator(), --1����
        Net_2           = _idCreator(), --2����
        Net_3           = _idCreator(), --3����
        Water           = _idCreator(), --ˮ��
        Wave            = _idCreator(), --����
        BulletSelf1     = _idCreator(),
        BulletSelf2     = _idCreator(),
        BulletSelf3     = _idCreator(),
        BulletOther1    = _idCreator(),
        BulletOther2    = _idCreator(),
        BulletOther3    = _idCreator(),
        BulletEmery     = _idCreator(),
        BulletEmery_1   = _idCreator(),
        BulletEmery_2   = _idCreator(),
        BulletEmery_3   = _idCreator(),
        PaotaiSelf1     = _idCreator(),
        PaotaiSelf2     = _idCreator(),
        PaotaiSelf3     = _idCreator(),
        PaotaiOther1    = _idCreator(),
        PaotaiOther2    = _idCreator(),
        PaotaiOther3    = _idCreator(),
        PaotaiEmery     = _idCreator(),
        PaotaiEmery_1   = _idCreator(),
        PaotaiEmery_2   = _idCreator(),
        PaotaiEmery_3   = _idCreator(),
        Fire            = _idCreator(),
        BombEffect      = _idCreator(),
        FishDeadEffect  = _idCreator(),
        LineEffect      = _idCreator(),
        LineSourceEffect= _idCreator(),  --Դͷ
    };

    --��ı�־
    self.Enum_FISH_FLAG             = {
        Common_Fish = idCreator(0),
        YC_Fish     = idCreator(),
    };

    --���Ч��
    self.Enum_FISH_Effect           = {
        Common_Fish = idCreator(0),
        Stop_Fish   = idCreator(),
        Bomb_Fish   = idCreator(),
        Fish_Boss   = idCreator(),
    };


    self.GameCommandDefine = {
        SC_CMD = {
            Game_Config             = idCreator(100),
            Fish_Trace              = idCreator(),
            Exchange_FishGold       = idCreator(),
            User_Fire               = idCreator(),
            Catch_Fish              = idCreator(),
            Power_Bullet_Reached    = idCreator(),
            LockTimeOut             = idCreator(),
            Catch_Special           = idCreator(),
            Notify_Catch_Special    = idCreator(),
            Notify_Catch_LK         = idCreator(),
            Notify_Switch_Scene     = idCreator(),
            Response_Change_FishGold= idCreator(),
        },

        CS_CMD = {
            ExchangeFishGold        = idCreator(1),
            UserFire                = idCreator(),
            CacheFish               = idCreator(),
            CatchFishGroup          = idCreator(),
            ShotLiKui               = idCreator(),
            AndroidBulletMultiple   = idCreator(),
        },

        --һЩ�������ֵ
        CMD_CODE ={
            SendPaoCode = 0x3135,
            CatchFishCode= 0x7322,
        },
    
    };

    self.Enum_ShaderID= {
        Standard                        =   idCreator(0),
        Custom_User_StandardFish        =   idCreator(),
        Custom_User_FengZhao            =   idCreator(),
        Custom_User_YinBaoXiang         =   idCreator(),
        Custom_User_JinBaoXiang         =   idCreator(),
        Custom_User_TextureAlphaAdd     =   idCreator(),
        Custom_User_AlphaTexture        =   idCreator(),
        Mobile_Particles_Additive       =   idCreator(),
        Custom_User_DiffMultiply        =   idCreator(),
        Custom_User_SelfTextured        =   idCreator(),
        Custom_screen_GodRayDS1         =   idCreator(),
        Custom_User_MyMask              =   idCreator(),
        Mobile_Bumped_Diffuse           =   idCreator(),
        Mobile_Bumped_Specular          =   idCreator(),
        Particles_Alpha_Blended         =   idCreator(),
    };

    self.SoundDefine = {
        BG1         = idCreator(),
        BG2         = idCreator(),
        BG3         = idCreator(),
        BG4         = idCreator(),
        HaiLang     = idCreator(),
        Bingo       = idCreator(),
        CantSwitch  = idCreator(),
        Casting     = idCreator(),
        Catch       = idCreator(),
        Fire        = idCreator(),
        Ion_Casting = idCreator(),
        Ion_Catch   = idCreator(),
        Ion_Fire    = idCreator(),
        Ion_Get     = idCreator(),
        Lock        = idCreator(),
        Silver      = idCreator(),
        SuperArm    = idCreator(),
        Wave        = idCreator(),
        ChangeScore = idCreator(),
        UpScore     = idCreator(),
        CatchFish_1 = idCreator(),
        CatchFish_2 = idCreator(),
        CatchFish_3 = idCreator(),
        CatchFish_4 = idCreator(),
        CatchFish_5 = idCreator(),
        CatchFish_6 = idCreator(),
        CatchFish_7 = idCreator(),
        CatchFish_8 = idCreator(),
        CatchFish_9 = idCreator(),
        CatchFish_10= idCreator(),
        CatchFish_11= idCreator(),
        CatchFish_12= idCreator(),
        CatchFish_13= idCreator(),
        CatchFish_14= idCreator(),
        Bomb        = idCreator(),
        QuanPingBomb= idCreator(),
        PauseBomb   = idCreator(),
        ChangeScene = idCreator(),
        Coinsfly    = idCreator(),
        BigFishGold = idCreator(),
    };

    --��ʼ����Ϸ����
    self:_initGameConfig();
    
    --һЩ������ֵ
    self:_initAppConstant();

    self:_initFunctions();
end

function _CGlobalGame:_initFunctions()
    --������
    self.FunctionsLib = GameRequire("Functions");
    self.FunctionsLib.FunctionInit(self);
end

--��ʼ��Ӧ�ó���
function _CGlobalGame:_initAppConstant()
    --��ʼ��һЩ����
    self.ConstantValue = {
        IsLandscape = false, --�Ƿ����
        IsPortrait  = true, --�Ƿ�����
        MatchScreenWidth = 1334,
        MatchScreenHeight = 750,
        RealScreenWidth = 1334,
        RealScreenHeight = 750,
        CanvasRate  = 1,
    };
    --������
    local matchRate = self.ConstantValue.MatchScreenWidth/self.ConstantValue.MatchScreenHeight;
    --һЩ������ֵ
    if self.ConstantValue.IsLandscape then
        --�̶���С
        if Util.isAndroidPlatform or Util.isApplePlatform then
            self.ConstantValue.RealScreenWidth = Screen.width;
            self.ConstantValue.RealScreenHeight = Screen.height;
        elseif Util.isEditor then
            self.ConstantValue.RealScreenWidth = Screen.width;
            --self.ConstantValue.RealScreenHeight = Screen.height;      
            self.ConstantValue.RealScreenHeight = Screen.width/matchRate;       
        elseif Util.isPc then
            self.ConstantValue.RealScreenWidth = 1334;--Screen.width;
            self.ConstantValue.RealScreenHeight = 740;--Screen.height;
        else
            self.ConstantValue.RealScreenWidth = Screen.width;--Screen.width;
            self.ConstantValue.RealScreenHeight = Screen.height;--Screen.height;
        end


        if self.ConstantValue.RealScreenWidth/self.ConstantValue.RealScreenHeight>matchRate then
            AlignViewExClass.setScreenArgs(self.ConstantValue.RealScreenWidth,self.ConstantValue.RealScreenHeight,
                self.ConstantValue.MatchScreenWidth,self.ConstantValue.MatchScreenHeight,false);
            self.ConstantValue.CanvasRate = 1;
        else
            AlignViewExClass.setScreenArgs(self.ConstantValue.RealScreenWidth,self.ConstantValue.RealScreenHeight,
                self.ConstantValue.MatchScreenWidth,self.ConstantValue.MatchScreenHeight,true);
            self.ConstantValue.CanvasRate = 0;
        end

    elseif self.ConstantValue.IsPortrait then
        self.ConstantValue.RealScreenWidth = Screen.height;
        self.ConstantValue.RealScreenHeight = Screen.width;
        --������
        local matchRate = self.ConstantValue.MatchScreenWidth/self.ConstantValue.MatchScreenHeight;
        if self.ConstantValue.RealScreenWidth/self.ConstantValue.RealScreenHeight>matchRate then
            AlignViewExClass.setScreenArgs(self.ConstantValue.RealScreenWidth,self.ConstantValue.RealScreenHeight,
                self.ConstantValue.MatchScreenWidth,self.ConstantValue.MatchScreenHeight,false);
            self.ConstantValue.CanvasRate = 0;
        else
            AlignViewExClass.setScreenArgs(self.ConstantValue.RealScreenWidth,self.ConstantValue.RealScreenHeight,
                self.ConstantValue.MatchScreenWidth,self.ConstantValue.MatchScreenHeight,true);
            self.ConstantValue.CanvasRate = 1;
        end
    end
end

function _CGlobalGame:GetCanvasRate()
    return self.ConstantValue.CanvasRate;
end

function _CGlobalGame:_initGameConfig()
    local PrefabType = self.Enum_PrefabType;
    local PaotaiType = self.Enum_PaotaiType;
    local BulletType = self.Enum_BulletType;
    local AnimateType= self.Enum_AnimateType;
    local NetType    = self.Enum_NetType;
    local FishType   = self.Enum_FishType;
    local FISH_Effect= self.Enum_FISH_Effect;
    local EffectType = self.Enum_EffectType;
    local GoldType   = self.Enum_GoldType;
    local FishCombType  = self.Enum_FishCombType;
    local FishUnderPanType = self.Enum_FishUnderPanType;
    local ShaderID   = self.Enum_ShaderID;
    self.GameConfig={
        PrefabName  = {
            [PrefabType.Self_Paotai_1          ] = {prefabName = "PaoTai_1"             ,abName=nil },
            [PrefabType.Other_Paotai_1         ] = {prefabName = "PaoTai_1"             ,abName=nil },
            [PrefabType.Self_Paotai_2          ] = {prefabName = "PaoTai_2"             ,abName=nil },
            [PrefabType.Other_Paotai_2         ] = {prefabName = "PaoTai_2"             ,abName=nil },
            [PrefabType.Self_Paotai_3          ] = {prefabName = "PaoTai_3"             ,abName=nil },
            [PrefabType.Other_Paotai_3         ] = {prefabName = "PaoTai_3"             ,abName=nil },
            [PrefabType.Paotai_Energy          ] = {prefabName = "PaoTai_energy"        ,abName=nil },
            [PrefabType.Paotai_Energy_1        ] = {prefabName = "PaoTai_energy"        ,abName=nil },
            [PrefabType.Paotai_Energy_2        ] = {prefabName = "PaoTai_energy"        ,abName=nil },
            [PrefabType.Paotai_Energy_3        ] = {prefabName = "PaoTai_energy"        ,abName=nil },
            [PrefabType.Self_Bullet_1          ] = {prefabName = "Bullet_2_self"        ,abName=nil },
            [PrefabType.Self_Bullet_2          ] = {prefabName = "Bullet_3_self"        ,abName=nil },
            [PrefabType.Self_Bullet_3          ] = {prefabName = "Bullet_4_self"        ,abName=nil },
            [PrefabType.Bullet_Energy_1        ] = {prefabName = "Bullet_2_energy"      ,abName=nil },
            [PrefabType.Bullet_Energy_2        ] = {prefabName = "Bullet_3_energy"      ,abName=nil },
            [PrefabType.Bullet_Energy_3        ] = {prefabName = "Bullet_4_energy"      ,abName=nil },
            [PrefabType.Other_Bullet_1         ] = {prefabName = "Bullet_2_other"       ,abName=nil },
            [PrefabType.Other_Bullet_2         ] = {prefabName = "Bullet_3_other"       ,abName=nil },
            [PrefabType.Other_Bullet_3         ] = {prefabName = "Bullet_4_other"       ,abName=nil },
            [PrefabType.CommonBullet           ] = {prefabName = "BulletNew"            ,abName=nil },


            --��
            [PrefabType.FISH_KIND_1            ] = {prefabName = "Fish_1"            ,abName=nil },
            [PrefabType.FISH_KIND_2            ] = {prefabName = "Fish_2"            ,abName=nil },
            [PrefabType.FISH_KIND_3            ] = {prefabName = "Fish_3"            ,abName=nil },
            [PrefabType.FISH_KIND_4            ] = {prefabName = "Fish_4"            ,abName=nil },
            [PrefabType.FISH_KIND_5            ] = {prefabName = "Fish_5"            ,abName=nil },
            [PrefabType.FISH_KIND_6            ] = {prefabName = "Fish_6"            ,abName=nil },
            [PrefabType.FISH_KIND_7            ] = {prefabName = "Fish_7"            ,abName=nil },
            [PrefabType.FISH_KIND_8            ] = {prefabName = "Fish_8"            ,abName=nil },
            [PrefabType.FISH_KIND_9            ] = {prefabName = "Fish_9"            ,abName=nil },
            [PrefabType.FISH_KIND_10           ] = {prefabName = "Fish_10"           ,abName=nil },
            [PrefabType.FISH_KIND_11           ] = {prefabName = "Fish_11"           ,abName=nil },
            [PrefabType.FISH_KIND_12           ] = {prefabName = "Fish_12"           ,abName=nil },
            [PrefabType.FISH_KIND_13           ] = {prefabName = "Fish_13"           ,abName=nil },
            [PrefabType.FISH_KIND_14           ] = {prefabName = "Fish_14"           ,abName=nil },
            [PrefabType.FISH_KIND_15           ] = {prefabName = "Fish_15"           ,abName=nil },
            [PrefabType.FISH_KIND_16           ] = {prefabName = "Fish_16"           ,abName=nil },
            [PrefabType.FISH_KIND_17           ] = {prefabName = "Fish_17"           ,abName=nil },
            [PrefabType.FISH_KIND_18           ] = {prefabName = "Fish_18"           ,abName=nil },
            [PrefabType.FISH_KIND_19           ] = {prefabName = "Fish_19"           ,abName=nil },
            [PrefabType.FISH_KIND_20           ] = {prefabName = "Fish_20"           ,abName=nil },
            [PrefabType.FISH_KIND_21           ] = {prefabName = "Fish_21"           ,abName=nil },
            [PrefabType.FISH_KIND_22           ] = {prefabName = "Fish_22"           ,abName=nil },
            [PrefabType.FISH_KIND_23           ] = {prefabName = "Fish_23"           ,abName=nil },
            [PrefabType.FISH_KIND_24           ] = {prefabName = "Fish_24"           ,abName=nil },
            [PrefabType.FISH_KIND_25           ] = {prefabName = "Fish_25"           ,abName=nil },
            [PrefabType.FISH_KIND_26           ] = {prefabName = "Fish_26"           ,abName=nil },
            [PrefabType.FISH_KIND_27           ] = {prefabName = "Fish_27"           ,abName=nil },
            [PrefabType.FISH_KIND_28           ] = {prefabName = "Fish_28"           ,abName=nil },
            [PrefabType.FISH_KIND_29           ] = {prefabName = "Fish_29"           ,abName=nil },
            [PrefabType.FISH_KIND_30           ] = {prefabName = "Fish_30"           ,abName=nil },
            [PrefabType.FISH_KIND_31           ] = {prefabName = "Fish_31"           ,abName=nil },
            [PrefabType.FISH_KIND_32           ] = {prefabName = "Fish_32"           ,abName=nil },
            [PrefabType.FISH_KIND_33           ] = {prefabName = "Fish_33"           ,abName=nil },
            [PrefabType.FISH_KIND_34           ] = {prefabName = "Fish_34"           ,abName=nil },
            [PrefabType.FISH_KIND_35           ] = {prefabName = "Fish_35"           ,abName=nil },
            [PrefabType.FISH_KIND_36           ] = {prefabName = "Fish_36"           ,abName=nil },
            [PrefabType.FISH_KIND_37           ] = {prefabName = "Fish_37"           ,abName=nil },
            [PrefabType.FISH_KIND_38           ] = {prefabName = "Fish_38"           ,abName=nil },
            [PrefabType.FISH_KIND_39           ] = {prefabName = "Fish_39"           ,abName=nil },
            [PrefabType.FISH_KIND_40           ] = {prefabName = "Fish_40"           ,abName=nil },
            [PrefabType.LockLine               ] = {prefabName = "LockLine"          ,abName=nil },
            [PrefabType.LockTarget_1           ] = {prefabName = "LockItem_1"        ,abName=nil },
            [PrefabType.LockTarget_2           ] = {prefabName = "LockItem_2"        ,abName=nil },
            [PrefabType.LockTarget_3           ] = {prefabName = "LockItem_3"        ,abName=nil },
            [PrefabType.LockTarget_4           ] = {prefabName = "LockItem_4"        ,abName=nil },
            [PrefabType.ScoreColumnRed         ] = {prefabName = "ScoreColumnRed"    ,abName=nil },
            [PrefabType.ScoreColumnGreen       ] = {prefabName = "ScoreColumnGreen"  ,abName=nil },

            --��ըЧ��
            [PrefabType.Effect_FishDead        ] = {prefabName = "dayusiwang"           ,abName=nil },
            [PrefabType.Effect_Bomb            ] = {prefabName = "quanpingbaozha"       ,abName=nil },
            [PrefabType.Effect_Line            ] = {prefabName = "xian"                 ,abName=nil },
            [PrefabType.Effect_PauseScreen     ] = {prefabName = "effect_xuehua_binggui",abName=nil },
            [PrefabType.Effect_MyBeat          ] = {prefabName = "effect_zidan_h"       ,abName=nil },
            [PrefabType.Effect_Beat            ] = {prefabName = "effect_zidan_l"       ,abName=nil },
            [PrefabType.Effect_BingGuiDead     ] = {prefabName = "effect_bingguisiwang" ,abName=nil },
            [PrefabType.Effect_Jubu            ] = {prefabName = "jububaozha"           ,abName=nil },
            [PrefabType.Effect_FishKingDead    ] = {prefabName = "effect_yuwangbaodian" ,abName=nil },
            [PrefabType.Effect_SmallFishDead   ] = {prefabName = "effect_xiaoyubaodian" ,abName=nil },
             
            
            

            [PrefabType.LockFishFlag_1         ] = {prefabName = "lock_flag0_000"         ,abName=nil },
            [PrefabType.LockFishFlag_2         ] = {prefabName = "lock_flag0_001"         ,abName=nil },
            [PrefabType.LockFishFlag_3         ] = {prefabName = "lock_flag0_002"         ,abName=nil },
            [PrefabType.LockFishFlag_4         ] = {prefabName = "lock_flag0_003"         ,abName=nil },
            [PrefabType.LockFishFlag_5         ] = {prefabName = "lock_flag0_004"         ,abName=nil },
            [PrefabType.LockFishFlag_6         ] = {prefabName = "lock_flag0_005"         ,abName=nil },
            [PrefabType.LockFishFlag_7         ] = {prefabName = "lock_flag0_006"         ,abName=nil },
            [PrefabType.LockFishFlag_8         ] = {prefabName = "lock_flag0_007"         ,abName=nil },
            [PrefabType.LockFishFlag_9         ] = {prefabName = "lock_flag0_008"         ,abName=nil },
            [PrefabType.LockFishFlag_10        ] = {prefabName = "lock_flag0_009"         ,abName=nil },
            [PrefabType.LockFishFlag_11        ] = {prefabName = "lock_flag0_010"         ,abName=nil },
            [PrefabType.LockFishFlag_12        ] = {prefabName = "lock_flag0_011"         ,abName=nil },
            [PrefabType.LockFishFlag_13        ] = {prefabName = "lock_flag0_012"         ,abName=nil },
            [PrefabType.LockFishFlag_14        ] = {prefabName = "lock_flag0_013"         ,abName=nil },
            [PrefabType.LockFishFlag_15        ] = {prefabName = "lock_flag0_014"         ,abName=nil },
            [PrefabType.LockFishFlag_16        ] = {prefabName = "lock_flag0_015"         ,abName=nil },
            [PrefabType.LockFishFlag_17        ] = {prefabName = "lock_flag0_016"         ,abName=nil },
            [PrefabType.LockFishFlag_18        ] = {prefabName = "lock_flag0_017"         ,abName=nil },
            [PrefabType.LockFishFlag_19        ] = {prefabName = "lock_flag0_018"         ,abName=nil },
            [PrefabType.LockFishFlag_20        ] = {prefabName = "lock_flag0_019"         ,abName=nil },
            [PrefabType.LockFishFlag_21        ] = {prefabName = "lock_flag0_020"         ,abName=nil },
            [PrefabType.LockFishFlag_22        ] = {prefabName = "lock_flag0_021"         ,abName=nil },
            [PrefabType.LockFishFlag_23        ] = {prefabName = "lock_flag0_022"         ,abName=nil },
            [PrefabType.LockFishFlag_24        ] = {prefabName = "lock_flag0_023"         ,abName=nil },
            [PrefabType.LockFishFlag_25        ] = {prefabName = "lock_flag0_024"         ,abName=nil },
            [PrefabType.LockFishFlag_26        ] = {prefabName = "lock_flag0_025"         ,abName=nil },
            [PrefabType.LockFishFlag_27        ] = {prefabName = "lock_flag0_026"         ,abName=nil },
            [PrefabType.LockFishFlag_28        ] = {prefabName = "lock_flag0_027"         ,abName=nil },
            [PrefabType.LockFishFlag_29        ] = {prefabName = "lock_flag0_028"         ,abName=nil },
            [PrefabType.LockFishFlag_30        ] = {prefabName = "lock_flag0_029"         ,abName=nil },
            [PrefabType.LockFishFlag_31        ] = {prefabName = "lock_flag0_030"         ,abName=nil },
            [PrefabType.LockFishFlag_32        ] = {prefabName = "lock_flag0_031"         ,abName=nil }, 
            [PrefabType.LockFishFlag_33        ] = {prefabName = "lock_flag0_032"         ,abName=nil },
            [PrefabType.LockFishFlag_34        ] = {prefabName = "lock_flag0_033"         ,abName=nil },
            [PrefabType.LockFishFlag_35        ] = {prefabName = "lock_flag0_034"         ,abName=nil },
            [PrefabType.LockFishFlag_36        ] = {prefabName = "lock_flag0_035"         ,abName=nil },
            [PrefabType.LockFishFlag_37        ] = {prefabName = "lock_flag0_036"         ,abName=nil },
            [PrefabType.LockFishFlag_38        ] = {prefabName = "lock_flag0_037"         ,abName=nil },
            [PrefabType.LockFishFlag_39        ] = {prefabName = "lock_flag0_038"         ,abName=nil },
            [PrefabType.LockFishFlag_40        ] = {prefabName = "lock_flag0_039"         ,abName=nil },
        },
        PaotaiInfo = {
            [PaotaiType.Paotai_1] = {
                NextPao = PaotaiType.Paotai_2,
                PrePao  = PaotaiType.Paotai_3,
                Bigger  = PaotaiType.Paotai_Energy_1,
                Smaller = nil,
                BulletType= BulletType.BULLET_KIND_1_NORMAL,
                Style   = {
                    self = { 
                        preType     = PrefabType.Self_Paotai_1,
                        bodyAnima   = AnimateType.PaotaiSelf1,
                    },
                    other = {
                        preType     = PrefabType.Other_Paotai_1,
                        bodyAnima   = AnimateType.PaotaiOther1,
                    },
                },
            },
            [PaotaiType.Paotai_2] = {
                NextPao = PaotaiType.Paotai_3,
                PrePao  = PaotaiType.Paotai_1,
                Bigger  = PaotaiType.Paotai_Energy_2,
                Smaller = nil,
                BulletType= BulletType.BULLET_KIND_2_NORMAL,
                Style   = {
                    self = { 
                        preType     = PrefabType.Self_Paotai_2,
                        bodyAnima   = AnimateType.PaotaiSelf2,
                    },
                    other = {
                        preType     = PrefabType.Other_Paotai_2,
                        bodyAnima   = AnimateType.PaotaiOther2,
                    },
                },
            },
            [PaotaiType.Paotai_3] = {
                NextPao = PaotaiType.Paotai_1,
                PrePao  = PaotaiType.Paotai_2,
                Bigger  = PaotaiType.Paotai_Energy_3,
                Smaller = nil,
                BulletType= BulletType.BULLET_KIND_3_NORMAL,
                Style   = {
                    self = { 
                        preType     = PrefabType.Self_Paotai_3,
                        bodyAnima   = AnimateType.PaotaiSelf3,
                    },
                    other = {
                        preType     = PrefabType.Other_Paotai_3,
                        bodyAnima   = AnimateType.PaotaiOther3,
                    },
                },
            },
            [PaotaiType.Paotai_Energy_1] = {
                NextPao = PaotaiType.Paotai_Energy_2,
                PrePao  = PaotaiType.Paotai_Energy_3,
                Bigger  = nil,
                Smaller = PaotaiType.Paotai_1,
                BulletType= BulletType.BULLET_KIND_1_ION,
                Style   = {
                    self = { 
                        preType     = PrefabType.Paotai_Energy,
                        bodyAnima   = AnimateType.PaotaiEmery_1,
                    },
                    other = {
                        preType     = PrefabType.Paotai_Energy,
                        bodyAnima   = AnimateType.PaotaiEmery_1,
                    },
                },
            },
            [PaotaiType.Paotai_Energy_2] = {
                NextPao = PaotaiType.Paotai_Energy_3,
                PrePao  = PaotaiType.Paotai_Energy_1,
                Bigger  = nil,
                Smaller = PaotaiType.Paotai_2,
                BulletType= BulletType.BULLET_KIND_2_ION,
                Style   = {
                    self = { 
                        preType     = PrefabType.Paotai_Energy,
                        bodyAnima   = AnimateType.PaotaiEmery_2,
                    },
                    other = {
                        preType     = PrefabType.Paotai_Energy,
                        bodyAnima   = AnimateType.PaotaiEmery_2,
                    },
                },
            },
            [PaotaiType.Paotai_Energy_3] = {
                NextPao = PaotaiType.Paotai_Energy_1,
                PrePao  = PaotaiType.Paotai_Energy_2,
                Bigger  = nil,
                Smaller = PaotaiType.Paotai_3,
                BulletType= BulletType.BULLET_KIND_3_ION,
                Style   = {
                    self = { 
                        preType     = PrefabType.Paotai_Energy,
                        bodyAnima   = AnimateType.PaotaiEmery_3,
                    },
                    other = {
                        preType     = PrefabType.Paotai_Energy,
                        bodyAnima   = AnimateType.PaotaiEmery_3,
                    },
                },
            },
        },
        --�ӵ�
        Bullet = {
            [BulletType.BULLET_KIND_1_NORMAL] = {
                iSpeed      = 35,
                SelfName    = PrefabType.Self_Bullet_1,
                OtherName   = PrefabType.Other_Bullet_1,
                iNetRadius  = 0 ,
                multiple    = 10,
                paoType     = PaotaiType.Paotai_1,
                netType     = NetType.Common,
                bulletKind  = BulletType.BULLET_KIND_1_NORMAL,
                isEnergy    = false,
                Style       = {
                    self = { 
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.BulletSelf1,
                        boxCollider = {
--                            center  = { x = 0, y = 0, z = 0, },
--                            size    = { x = 29.71161, y = 25.24368, z = 10000, },
                            size    = { x = 0.12, y = 0.1, z = 12, },
                        },
                    },
                    other = {
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.BulletOther1,
                        boxCollider = {
--                            center  = { x = 0, y = 0, z = 0, },
--                            size    = { x = 29.71161, y = 25.24368, z = 10000, },
                            size    = { x = 0.12, y = 0.1, z = 12, },
                        },
                    },
                },
            },
            [BulletType.BULLET_KIND_2_NORMAL] = {
                iSpeed      = 35,
                SelfName    = PrefabType.Self_Bullet_2,
                OtherName   = PrefabType.Other_Bullet_2,
                iNetRadius  = 0 ,
                multiple    = 50,
                paoType     = PaotaiType.Paotai_2,
                netType     = NetType.Common,
                bulletKind  = BulletType.BULLET_KIND_2_NORMAL,
                isEnergy    = false,
                Style       = {
                    self = { 
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.BulletSelf2,
                        boxCollider = {
--                            center  = { x = 0, y = 0, z = 0, },
--                            size    = { x = 29.71161, y = 25.24368, z = 10000, },
                            size    = { x = 0.144, y = 0.11, z = 12, },
                        },
                    },
                    other = {
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.BulletOther2,
                        boxCollider = {
--                            center  = { x = 0, y = 0, z = 0, },
--                            size    = { x = 29.71161, y = 25.24368, z = 10000, },
                            size    = { x = 0.144, y = 0.11, z = 12, },
                        },
                    },
                },
            },
            [BulletType.BULLET_KIND_3_NORMAL] = {
                iSpeed      = 35,
                SelfName    = PrefabType.Self_Bullet_3,
                OtherName   = PrefabType.Other_Bullet_3,
                iNetRadius  = 0 ,
                multiple    = 100,
                paoType     = PaotaiType.Paotai_3,
                netType     = NetType.Common,
                bulletKind  = BulletType.BULLET_KIND_3_NORMAL,
                isEnergy    = false,
                Style       = {
                    self = { 
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.BulletSelf3,
                        boxCollider = {
--                            center  = { x = 0, y = 0, z = 0 },
--                            size    = { x = 29.71161, y = 25.24368, z = 10000, },
                            size    = { x = 0.168, y = 0.12, z = 12, },
                        },
                    },
                    other = {
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.BulletOther3,
                        boxCollider = {
--                            center  = { x = 0, y = 0, z = 0, },
--                            size    = { x = 29.71161, y = 25.24368, z = 10000, },
                            size    = { x = 0.168, y = 0.12, z = 12, },
                        },
                    },
                },
            },
            [BulletType.BULLET_KIND_4_NORMAL] = {
                iSpeed      = 35,
                SelfName    = nil,
                OtherName   = nil,
                iNetRadius  = 0 ,
                multiple    = 9900,
                paoType     = PaotaiType.InvalidType,
                netType     = NetType.Common,
                bulletKind  = BulletType.BULLET_KIND_4_NORMAL,
                isEnergy    = false,
                Style       = {
                    self = { 
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.BulletSelf3,
                        boxCollider = {
                            center  = { x = 0, y = 0, z = 0, },
                            size    = { x = 70, y = 24, z = 1, },
                        },
                    },
                    other = {
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.BulletOther3,
                        boxCollider = {
                            center  = { x = 0, y = 0, z = 0, },
--                            size    = { x = 70, y = 24, z = 1, },
                        },
                    },
                },
            },
            [BulletType.BULLET_KIND_1_ION] = {
                iSpeed      = 40,
                SelfName    = PrefabType.Bullet_Energy_1,
                OtherName   = PrefabType.Bullet_Energy_1,
                iNetRadius  = 0 ,
                multiple    = 3300,
                paoType     = PaotaiType.Paotai_Energy_1,
                netType     = NetType.Common,
                bulletKind  = BulletType.BULLET_KIND_1_NORMAL,
                isEnergy    = true,
                Style       = {
                    self = { 
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.BulletEmery_1,
                        boxCollider = {
                            center  = { x = 0, y = 0, z = 0, },
                            size    = { x = 49, y = 54, z = 1, },
                        },
                    },
                    other = {
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.BulletEmery_1,
                        boxCollider = {
                            center  = { x = 0, y = 0, z = 0, },
                            size    = { x = 49, y = 54, z = 1, },
                        },
                    },
                },
            },
            [BulletType.BULLET_KIND_2_ION] = {
                iSpeed      = 40,
                SelfName    = PrefabType.Bullet_Energy_2,
                OtherName   = PrefabType.Bullet_Energy_2,
                iNetRadius  = 0 ,
                multiple    = 6600,
                paoType     = PaotaiType.Paotai_Energy_2,
                netType     = NetType.Common,
                bulletKind  = BulletType.BULLET_KIND_2_NORMAL,
                isEnergy    = true,
                Style       = {
                    self = {
                        preType     = PrefabType.CommonBullet, 
                        preName     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.BulletEmery_2,
                        boxCollider = {
                            center  = { x = 0, y = 0, z = 0, },
                            size    = { x = 48, y = 41, z = 1, },
                        },
                    },
                    other = {
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.BulletEmery_2,
                        boxCollider = {
                            center  = { x = 0, y = 0, z = 0, },
                            size    = { x = 48, y = 41, z = 1, },
                        },
                    },
                },
            },
            [BulletType.BULLET_KIND_3_ION] = {
                iSpeed      = 40,
                SelfName    = PrefabType.Bullet_Energy_3,
                OtherName   = PrefabType.Bullet_Energy_3,
                iNetRadius  = 0 ,
                multiple    = 9900,
                paoType     = PaotaiType.Paotai_Energy_3,
                netType     = NetType.Common,
                bulletKind  = BulletType.BULLET_KIND_3_NORMAL,
                isEnergy    = true,
                Style       = {
                    self = { 
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.BulletEmery_3,
                        boxCollider = {
                            center  = { x = 0, y = 0, z = 0, },
                            size    = { x = 57, y = 63, z = 1, },
                        },
                    },
                    other = {
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.BulletEmery_3,
                        boxCollider = {
                            center  = { x = 0, y = 0, z = 0, },
                            size    = { x = 57, y = 63, z = 1, },
                        },
                    },
                },
            },
            [BulletType.BULLET_KIND_4_ION] = {
                iSpeed      = 40,
                SelfName    = nil,
                OtherName   = nil,
                iNetRadius  = 0 ,
                multiple    = 0,
                paoType     = PaotaiType.InvalidType,
                netType     = NetType.Common,
                bulletKind  = BulletType.BULLET_KIND_1_NORMAL,
                isEnergy    = true,
                Style       = {
                    self = { 
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.BulletSelf1,
                        boxCollider = {
                            center  = { x = 0, y = 0, z = 0, },
                            size    = { x = 52, y = 57, z = 1, },
                        },
                    },
                    other = {
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.BulletOther1,
                        boxCollider = {
                            center  = { x = 0, y = 0, z = 0, },
                            size    = { x = 52, y = 57, z = 1, },
                        },
                    },
                },
            },
        },  
        --��������
        SceneConfig = {
            lExchangeNeedGold   = 0,  --�Ϸ���Ҫ�Ľ��
            iMinBulletMultiple  = 0,  --��С�ӵ�����
            iMaxBulletMultiple  = 0,  --����ӵ����� 
            iFireInterval       = 0.33,  --����ʱ���� 
            iFireEnergyInterval = 0.25,  --�����ڵĿ��ڼ��
            fishHurtTime        = 0.2,   --��������ʾʱ��
            netAnimaInterval    = 0.6,  ---���Ĳ��Ŷ����ٶ�
            goldColumn          = 3, --�����ʾ�������
            goldColumnTime      = 5, --�����ʾ5��
            goldColumnMoveSpeed = 80, --�ƶ��ٶ�
            goldColumnDis       = 45, --���
            wheelDisplayTime    = 5, --Ħ������ʾʱ��
            pauseScreenTime     = 20, --����
            bombRound           = 0.35,  --��ը��Χ���ֲ�ը��
            switchSceneInterval = 0.5, --�л��㳱�Ķ���ʱ����
            createGoldInterval  = 0.01, --��ұ�����ʱ����
            flyGoldSpeed        = 300, --�ɽ���ٶ�
            playSpeed_BombEffect= 0.20,  --�����ٶ�
            FrameCount          = 40,   --40֡
            iFishDeadTime       = 0.9,    --������ʱ��
            iLineDisplayTime    = 1,    --������ʾʱ��
            iBulletLiveTime     = 10,   --�ӵ����ʱ��
            iPosTipTime         = 4,    --λ����ʾ��ʾ4��
        },
        --����Ϣ
        FishInfo = {
            [FishType.FISH_KIND_1] = {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                       ShakeScreen=false, iMultiple = 1, useTime={10,15}, keaiEffect={isKeai=true , minTime= 8,maxTime=11,speed=1.3,},iRadius=0,groupIds={1,},isLock=false,isWheel=false,gold=1 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=13, cacheCount=20,updateIndex=1,updateDelta=0.035,},
            [FishType.FISH_KIND_2] = {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                       ShakeScreen=false, iMultiple = 1, useTime={10,15}, keaiEffect={isKeai=true , minTime= 8,maxTime=11,speed=1.3,},iRadius=0,groupIds={1,},isLock=false,isWheel=false,gold=1 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=13, cacheCount=20,updateIndex=1,updateDelta=0.035,},
            [FishType.FISH_KIND_3] = {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                       ShakeScreen=false, iMultiple = 1, useTime={10,15}, keaiEffect={isKeai=true , minTime=10,maxTime=13,speed=0,  },iRadius=0,groupIds={1,},isLock=false,isWheel=false,gold=1 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=13, cacheCount=15,updateIndex=1,updateDelta=0.035,},
            [FishType.FISH_KIND_4] = {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                       ShakeScreen=false, iMultiple = 1, useTime={10,15}, keaiEffect={isKeai=true , minTime=10,maxTime=12,speed=0  ,},iRadius=0,groupIds={1,},isLock=false,isWheel=false,gold=2 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=13, cacheCount=15,updateIndex=2,updateDelta=0.035,},
            [FishType.FISH_KIND_5] = {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                       ShakeScreen=false, iMultiple = 1, useTime={10,15}, keaiEffect={isKeai=true , minTime=12,maxTime=18,speed=0.2,},iRadius=0,groupIds={1,},isLock=false,isWheel=false,gold=2 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=13, cacheCount=12,updateIndex=2,updateDelta=0.035,},
            [FishType.FISH_KIND_6] = {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                       ShakeScreen=false, iMultiple = 1, useTime={10,15}, keaiEffect={isKeai=true , minTime= 8,maxTime=17,speed=0,  },iRadius=0,groupIds={1,},isLock=false,isWheel=false,gold=2 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=13, cacheCount=12,updateIndex=2,updateDelta=0.035,},
            [FishType.FISH_KIND_7] = {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                       ShakeScreen=false, iMultiple = 1, useTime={10,15}, keaiEffect={isKeai=true , minTime=12,maxTime=17,speed=0  ,},iRadius=0,groupIds={1,},isLock=false,isWheel=false,gold=3 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=13, cacheCount=12,updateIndex=1,updateDelta=0.035,},
            [FishType.FISH_KIND_8] = {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                       ShakeScreen=false, iMultiple = 1, useTime={13,17}, keaiEffect={isKeai=true , minTime=13,maxTime=40,speed=0,  },iRadius=0,groupIds={1,},isLock=false,isWheel=false,gold=3 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=13, cacheCount=10,updateIndex=1,updateDelta=0.035,},
            [FishType.FISH_KIND_9] = {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                       ShakeScreen=false, iMultiple = 1, useTime={13,17}, keaiEffect={isKeai=true , minTime=10,maxTime=17,speed=0  ,},iRadius=0,groupIds={1,},isLock=false,isWheel=false,gold=3 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=13, cacheCount=8 ,updateIndex=1,updateDelta=0.035,},
            [FishType.FISH_KIND_10]= {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                       ShakeScreen=false, iMultiple = 1, useTime={15,18}, keaiEffect={isKeai=true , minTime=13,maxTime=17,speed=0.2,},iRadius=0,groupIds={1,},isLock=false,isWheel=false,gold=4 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=8 ,updateIndex=2,updateDelta=0.035,},
            [FishType.FISH_KIND_11]= {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                       ShakeScreen=false, iMultiple = 1, useTime={18,22}, keaiEffect={isKeai=true , minTime= 8,maxTime=30,speed=0,  },iRadius=0,groupIds={1,},isLock=false,isWheel=false,gold=4 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=6 ,updateIndex=2,updateDelta=0.040,},
            [FishType.FISH_KIND_12]= {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                       ShakeScreen=false, iMultiple = 1, useTime={18,22}, keaiEffect={isKeai=true , minTime= 8,maxTime=12,speed=0  ,},iRadius=0,groupIds={1,},isLock=false,isWheel=false,gold=4 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=6 ,updateIndex=2,updateDelta=0.040,},
            [FishType.FISH_KIND_13]= {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                       ShakeScreen=false, iMultiple = 1, useTime={18,22}, keaiEffect={isKeai=true , minTime=10,maxTime=14,speed=0,  },iRadius=0,groupIds={1,},isLock=false,isWheel=false,gold=5 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=5 ,updateIndex=1,updateDelta=0.040,},
            [FishType.FISH_KIND_14]= {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                       ShakeScreen=false, iMultiple = 1, useTime={18,22}, keaiEffect={isKeai=true , minTime=10,maxTime=14,speed=0.8,},iRadius=0,groupIds={1,},isLock=false,isWheel=false,gold=5 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=5 ,updateIndex=1,updateDelta=0.040,},
            [FishType.FISH_KIND_15]= {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                       ShakeScreen=false, iMultiple = 1, useTime={25,30}, keaiEffect={isKeai=true , minTime=12,maxTime=17,speed=0.4,},iRadius=0,groupIds={2,},isLock=false,isWheel=false,gold=5 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=25, cacheCount=4 ,updateIndex=1,updateDelta=0.040,},
            [FishType.FISH_KIND_16]= {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                       ShakeScreen=false, iMultiple = 1, useTime={25,30}, keaiEffect={isKeai=true , minTime=12,maxTime=17,speed=0,  },iRadius=0,groupIds={2,},isLock=true ,isWheel=false,gold=5 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=25, cacheCount=4 ,updateIndex=2,updateDelta=0.045,},
            [FishType.FISH_KIND_17]= {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                       ShakeScreen=false, iMultiple = 1, useTime={25,30}, keaiEffect={isKeai=true , minTime=12,maxTime=17,speed=0  ,},iRadius=0,groupIds={2,},isLock=true ,isWheel=false,gold=6 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=25, cacheCount=3 ,updateIndex=2,updateDelta=0.045,},
            [FishType.FISH_KIND_18]= {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                       ShakeScreen=true , iMultiple = 1, useTime={35,38}, keaiEffect={isKeai=true , minTime=15,maxTime=22,speed=0  ,},iRadius=0,groupIds={3,},isLock=true ,isWheel=true ,gold=6 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=30, cacheCount=3 ,updateIndex=2,updateDelta=0.045,},
            [FishType.FISH_KIND_19]= {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                       ShakeScreen=true , iMultiple = 1, useTime={24,28}, keaiEffect={isKeai=true , minTime=12,maxTime=16,speed=0  ,},iRadius=0,groupIds={3,},isLock=true ,isWheel=true ,gold=6 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=30, cacheCount=3 ,updateIndex=1,updateDelta=0.045,},
            [FishType.FISH_KIND_20]= {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                       ShakeScreen=true , iMultiple = 1, useTime={35,40}, keaiEffect={isKeai=true , minTime=18,maxTime=22,speed=0.7,},iRadius=0,groupIds={4,},isLock=true ,isWheel=true ,gold=6 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=35, cacheCount=3 ,updateIndex=1,updateDelta=0.045,},
            [FishType.FISH_KIND_21]= {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                       ShakeScreen=true , iMultiple = 1, useTime={32,35}, keaiEffect={isKeai=true , minTime=16,maxTime=18,speed=0,  },iRadius=0,groupIds={4,},isLock=true ,isWheel=true ,gold=6 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=30, cacheCount=2 ,updateIndex=1,updateDelta=0.035,},
            [FishType.FISH_KIND_22]= {effectType=FISH_Effect.Stop_Fish  , deadEffect=EffectType.DingPing,       ShakeScreen=true , iMultiple = 1, useTime={30,38}, keaiEffect={isKeai=true , minTime=14,maxTime=20,speed=0,  },iRadius=0,groupIds={3,},isLock=true ,isWheel=false,gold=1 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=2 ,updateIndex=2,updateDelta=0.035,},
            [FishType.FISH_KIND_23]= {effectType=FISH_Effect.Bomb_Fish  , deadEffect=EffectType.JuBuBomb,       ShakeScreen=true , iMultiple = 1, useTime={40,  }, keaiEffect={isKeai=true , minTime=18,maxTime=22,speed=0.8,},iRadius=0,groupIds={3,},isLock=true ,isWheel=false,gold=0 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=25, cacheCount=2 ,updateIndex=2,updateDelta=0.050,},
            [FishType.FISH_KIND_24]= {effectType=FISH_Effect.Bomb_Fish  , deadEffect=EffectType.QuanPing,       ShakeScreen=true , iMultiple = 1, useTime={45,  }, keaiEffect={isKeai=true , minTime=20,maxTime=24,speed=0,  },iRadius=0,groupIds={3,},isLock=true ,isWheel=false,gold=0 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=25, cacheCount=2 ,updateIndex=2,updateDelta=0.050,},
            [FishType.FISH_KIND_25]= {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                       ShakeScreen=false, iMultiple = 1, useTime={20,26}, keaiEffect={isKeai=true , minTime=11,maxTime=15,speed=0.6,},iRadius=0,groupIds={1,},isLock=true ,isWheel=true ,gold=5 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=2 ,updateIndex=1,updateDelta=0.050,},
            [FishType.FISH_KIND_26]= {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                       ShakeScreen=false, iMultiple = 1, useTime={20,26}, keaiEffect={isKeai=true , minTime= 8,maxTime=17,speed=0,  },iRadius=0,groupIds={1,},isLock=true ,isWheel=true ,gold=5 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=2 ,updateIndex=1,updateDelta=0.045,},
            [FishType.FISH_KIND_27]= {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                       ShakeScreen=false, iMultiple = 1, useTime={20,26}, keaiEffect={isKeai=true , minTime= 8,maxTime=17,speed=0,  },iRadius=0,groupIds={1,},isLock=true ,isWheel=true ,gold=5 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=2 ,updateIndex=1,updateDelta=0.045,},
            [FishType.FISH_KIND_28]= {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                       ShakeScreen=false, iMultiple = 1, useTime={20,28}, keaiEffect={isKeai=true , minTime=11,maxTime=16,speed=0.6,},iRadius=0,groupIds={1,},isLock=true ,isWheel=true ,gold=5 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=3 ,updateIndex=2,updateDelta=0.045,},
            [FishType.FISH_KIND_29]= {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                       ShakeScreen=false, iMultiple = 1, useTime={20,28}, keaiEffect={isKeai=true , minTime=11,maxTime=16,speed=0,  },iRadius=0,groupIds={1,},isLock=true ,isWheel=true ,gold=5 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=3 ,updateIndex=2,updateDelta=0.035,},
            [FishType.FISH_KIND_30]= {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                       ShakeScreen=true , iMultiple = 1, useTime={20,28}, keaiEffect={isKeai=true , minTime=11,maxTime=16,speed=0,  },iRadius=0,groupIds={1,},isLock=true ,isWheel=true ,gold=5 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=3 ,updateIndex=2,updateDelta=0.035,},
            [FishType.FISH_KIND_31]= {effectType=FISH_Effect.Fish_Boss  , deadEffect=nil,                       ShakeScreen=true , iMultiple = 1, useTime={20,22}, keaiEffect={isKeai=true , minTime=10,maxTime=12,speed=1.3,},iRadius=0,groupIds={1,},isLock=true ,isWheel=true ,gold=1 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=3 ,updateIndex=1,updateDelta=0.035,},
            [FishType.FISH_KIND_32]= {effectType=FISH_Effect.Fish_Boss  , deadEffect=nil,                       ShakeScreen=true , iMultiple = 1, useTime={20,22}, keaiEffect={isKeai=true , minTime=10,maxTime=12,speed=1.3,},iRadius=0,groupIds={1,},isLock=true ,isWheel=true ,gold=1 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=3 ,updateIndex=1,updateDelta=0.035,},
            [FishType.FISH_KIND_33]= {effectType=FISH_Effect.Fish_Boss  , deadEffect=nil,                       ShakeScreen=true , iMultiple = 1, useTime={20,24}, keaiEffect={isKeai=true , minTime=10,maxTime=13,speed=0,  },iRadius=0,groupIds={1,},isLock=true ,isWheel=true ,gold=1 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=3 ,updateIndex=1,updateDelta=0.035,},
            [FishType.FISH_KIND_34]= {effectType=FISH_Effect.Fish_Boss  , deadEffect=nil,                       ShakeScreen=true , iMultiple = 1, useTime={20,24}, keaiEffect={isKeai=true , minTime=10,maxTime=13,speed=0  ,},iRadius=0,groupIds={1,},isLock=true ,isWheel=true ,gold=2 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=3 ,updateIndex=2,updateDelta=0.035,},
            [FishType.FISH_KIND_35]= {effectType=FISH_Effect.Fish_Boss  , deadEffect=nil,                       ShakeScreen=true , iMultiple = 1, useTime={20,24}, keaiEffect={isKeai=true , minTime=10,maxTime=13,speed=0.2,},iRadius=0,groupIds={1,},isLock=true ,isWheel=true ,gold=2 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=3 ,updateIndex=2,updateDelta=0.035,},
            [FishType.FISH_KIND_36]= {effectType=FISH_Effect.Fish_Boss  , deadEffect=nil,                       ShakeScreen=true , iMultiple = 1, useTime={20,24}, keaiEffect={isKeai=true , minTime=10,maxTime=13,speed=0,  },iRadius=0,groupIds={1,},isLock=true ,isWheel=true ,gold=2 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=3 ,updateIndex=2,updateDelta=0.035,},
            [FishType.FISH_KIND_37]= {effectType=FISH_Effect.Fish_Boss  , deadEffect=nil,                       ShakeScreen=true , iMultiple = 1, useTime={20,26}, keaiEffect={isKeai=true , minTime=10,maxTime=14,speed=0  ,},iRadius=0,groupIds={1,},isLock=true ,isWheel=true ,gold=3 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=3 ,updateIndex=1,updateDelta=0.035,},
            [FishType.FISH_KIND_38]= {effectType=FISH_Effect.Fish_Boss  , deadEffect=nil,                       ShakeScreen=true , iMultiple = 1, useTime={20,26}, keaiEffect={isKeai=true , minTime=10,maxTime=14,speed=0,  },iRadius=0,groupIds={1,},isLock=true ,isWheel=true ,gold=3 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=3 ,updateIndex=1,updateDelta=0.035,},
            [FishType.FISH_KIND_39]= {effectType=FISH_Effect.Fish_Boss  , deadEffect=nil,                       ShakeScreen=true , iMultiple = 1, useTime={20,28}, keaiEffect={isKeai=true , minTime=10,maxTime=15,speed=0  ,},iRadius=0,groupIds={1,},isLock=true ,isWheel=true ,gold=3 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=3 ,updateIndex=1,updateDelta=0.035,},
            [FishType.FISH_KIND_40]= {effectType=FISH_Effect.Fish_Boss  , deadEffect=nil,                       ShakeScreen=true , iMultiple = 1, useTime={25,30}, keaiEffect={isKeai=true , minTime=13,maxTime=17,speed=0.2,},iRadius=0,groupIds={1,},isLock=true ,isWheel=true ,gold=4 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=3 ,updateIndex=1,updateDelta=0.035,},
        },
        FishStyleInfo = {
            [FishType.FISH_KIND_1] = {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_01_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.07,0.07,0.07},
                                                    effects = {
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_2] = {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_02_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.07,0.07,0.07},
                                                    effects = {
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_3] = {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_03_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.052,0.052,0.052},
                                                    effects = {
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_4] = {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_04_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.05,0.05,0.05},
                                                    effects = {
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_5] = {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_05_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.046,0.046,0.046},
                                                    effects = {
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_6] = {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_06_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.041,0.041,0.041},
                                                    effects = {
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_7] = {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_07_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.045,0.045,0.045},
                                                    effects = {
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_8] = {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_08_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.046,0.046,0.046},
                                                    effects = {
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_9] = {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_09_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.04,0.04,0.04},
                                                    effects = {
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_10]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_10_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.036,0.036,0.036},
                                                    effects = {
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_11]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_11_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.043,0.043,0.043},
                                                    effects = {
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_12]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_12_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.04,0.04,0.04},
                                                    effects = {
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_13]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_13_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.038,0.038,0.038},
                                                    effects = {
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_14]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_14_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.033,0.033,0.033},
                                                    effects = {
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_15]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_15_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    scale = {0.7,0.7,0.7},
                                                    effects = {
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_16]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_16_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    scale = {0.7,0.7,0.7},
                                                    effects = {
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_17]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_17_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.04,0.04,0.04},
                                                    effects = {
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_18]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_18_fish",
                                                    name = "FishAnimate",
                                                    --scale = {0.040,0.040,0.040},
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    effects = {
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_19]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_19_fish",
                                                    name = "FishAnimate",
                                                    --scale = {0.048,0.048,0.048},
                                                    scale = {1.2,1.2,1.2},
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    effects = {
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_20]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_20_fish",
                                                    name = "FishAnimate",
                                                    scale = {1.3,1.3,1.3},
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    effects = {
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_21]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_21_fish",
                                                    name = "FishAnimate",
                                                    --scale = {0.039,0.039,0.039},
                                                    --pos = {-0.055,0,0},  --Ĭ��Ϊ 0,0,0;
                                                    effects = {
--                                                        {
--                                                            prefabName = "effect_daxxx",
--                                                            name = "Effect",
--                                                            pos = {-30.3,-0.1,-1.1}, --Ĭ��Ϊ 0,0,0;
--                                                            scale = {1,1,1},
--                                                            isInAnimate = true,
--                                                            animateBoneName = "Dummy001/Bip001 Pelvis/Bip001 Spine/Bip001 Spine1/Bip001 Spine2/Bip001 Neck/Bip001 L Clavicle/Bip001 L UpperArm/Bip001 L Forearm/Bone008(mirrored)/Bone010(mirrored)",
--                                                        },
--                                                        {
--                                                            prefabName = "effect_daxxx",
--                                                            name = "Effect",
--                                                            pos = {-29.6,0.3,-1.7}, --Ĭ��Ϊ 0,0,0;
--                                                            scale = {1,1,1},
--                                                            isInAnimate = true,
--                                                            animateBoneName = "Dummy001/Bip001 Pelvis/Bip001 Spine/Bip001 Spine1/Bip001 Spine2/Bip001 Neck/Bip001 R Clavicle/Bip001 R UpperArm/Bip001 R Forearm/Bone008/Bone010",
--                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_22]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_22_fish",
                                                    name = "FishAnimate",
                                                    --scale = {0.04,0.04,0.04},
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    effects = {
--                                                        {
--                                                            prefabName = "effect_binggui2",
--                                                            name = "EffectBingGui",
--                                                            pos = {-0.1779561,0.1904,0}, --Ĭ��Ϊ 0,0,0;
--                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_23]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_23_fish",
                                                    name = "FishAnimate",
                                                    --scale = {0.063,0.063,0.063},
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    effects = {
--                                                        {
--                                                            prefabName = "effect_baojian",
--                                                            name = "Effect",
--                                                            pos = {-0.31,0.07,2.61}, --Ĭ��Ϊ 0,0,0;
--                                                            rotation = {0,270,90}, --��ת�Ƕ�
--                                                            scale = {1,1,1},
--                                                            isInAnimate = true,
--                                                            animateBoneName = "Dummy001",
--                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_24]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_24_fish",
                                                    name = "FishAnimate",
                                                    --scale = {0.074,0.074,0.074},
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    effects = {
--                                                        {
--                                                            prefabName = "effect_zhadan",
--                                                            name = "EffectZhaDan",
--                                                            pos = {1,0,-0.5}, --Ĭ��Ϊ 0,0,0;
--                                                            scale = {1.5,1.5,1.5},
--                                                            isInAnimate = true,
--                                                            animateBoneName = "Dummy001",
--                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_25]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Group, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_25_fish",
                                                    name = "FishAnimate",
                                                    scale = {1.2,1.2,1.2},
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    effects = {
--                                                        {
--                                                            prefabName = "effect_sanyuan",
--                                                            pos = {0,-4.5,-1.944}, --Ĭ��Ϊ 0,0,0;
--                                                            isInAnimate = true,
--                                                            animateBoneName = "Dummy001",
--                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_26]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Group, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_25_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.021,0.021,0.021},
                                                    effects = {
--                                                        {
--                                                            prefabName = "effect_sanyuan",
--                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_27]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Group, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_25_fish",
                                                    name = "FishAnimate",
                                                    --scale = {0.021,0.021,0.021},
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    effects = {
--                                                        {
--                                                            prefabName = "effect_sanyuan",
--                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_28]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Group, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_28_fish",
                                                    name = "FishAnimate",
                                                    scale = {1.2,1.2,1.2},
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    effects = {
--                                                        {
--                                                            prefabName = "effect_sixi",
--                                                            pos = {0,-4.5,-1.944}, --Ĭ��Ϊ 0,0,0;
--                                                            isInAnimate = true,
--                                                            animateBoneName = "Dummy001",
--                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_29]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Group, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_28_fish",
                                                    name = "FishAnimate",
                                                    --scale = {0.021,0.021,0.021},
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    effects = {
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_30]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Group, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_28_fish",
                                                    name = "FishAnimate",
                                                    --scale = {0.021,0.021,0.021},
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    effects = {
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_31]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_31_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.07,0.07,0.07},
                                                    effects = {
--                                                        {
--                                                            prefabName = "effect_yuwang_d",
--                                                            isInAnimate = true,
--                                                            animateBoneName = "Dummy001/Bone001",
--                                                            --pos = {-0.01,0.26,-0.04},
--                                                            pos = {-1.47,-0.01,0.56},
--                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_32]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_32_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.07,0.07,0.07},
                                                    effects = {
--                                                        {
--                                                            prefabName = "effect_yuwang_d",
--                                                            isInAnimate = true,
--                                                            animateBoneName = "Dummy001/Bone001",
--                                                            --pos = {0,0.52,0.07},
--                                                            pos = {-1.5,0.1,0.3},
--                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_33]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_33_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.052,0.052,0.052},
                                                    effects = {
--                                                        {
--                                                            prefabName = "effect_yuwang_d",
--                                                            isInAnimate = true,
--                                                            animateBoneName = "Dummy001/Bone001",
--                                                            --pos = {0,0.221,0.03},
--                                                            --pos = {-2.7,-0.7,0.3},
--                                                            pos = {-2.6,-0.5,-0.4},
--                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_34]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_34_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.05,0.05,0.05},
                                                    effects = {
--                                                        {
--                                                            prefabName = "effect_yuwang_d",
--                                                            isInAnimate = true,
--                                                            animateBoneName = "Dummy001/Bone001",
--                                                            pos = {-2.6,-0.1,0.8},
--                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_35]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_35_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.046,0.046,0.046},
                                                    effects = {
--                                                        {
--                                                            prefabName = "effect_yuwang_d",
--                                                            isInAnimate = true,
--                                                            animateBoneName = "Dummy001/Bone001",
--                                                            --pos = {-1,0,0.3},
--                                                            pos = {-2.8,-0.2,-0.9},
--                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_36]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_36_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.041,0.041,0.041},
                                                    effects = {
--                                                        {
--                                                            prefabName = "effect_yuwang_d",
--                                                            isInAnimate = true,
--                                                            animateBoneName = "Dummy001/Bone001",
--                                                            --pos = {0.026,0.3,0.054},
--                                                            pos = {-2.3,0.2,0.1},
--                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_37]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_37_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.045,0.045,0.045},
                                                    effects = {
--                                                        {
--                                                            prefabName = "effect_yuwang_d",
--                                                            isInAnimate = true,
--                                                            animateBoneName = "Dummy001/Bone001",
--                                                            --pos = {-4.40202,-0.5652109,0.369894},
--                                                            pos = {-4.40,-0.565,0.37},
--                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_38]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_38_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.046,0.046,0.046},
                                                    effects = {
--                                                        {
--                                                            prefabName = "effect_yuwang_d",
--                                                            isInAnimate = true,
--                                                            animateBoneName = "Dummy001/Bone001",
--                                                            --pos = {-0.03,0.14,0.16},
--                                                            --pos = {-3.379717,-0.351621,0.4641922},
--                                                            pos = {-3.38,-0.35,0.464},
--                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_39]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_39_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.04,0.04,0.04},
                                                    effects = {
--                                                        {
--                                                            prefabName = "effect_yuwang_d",
--                                                            isInAnimate = true,
--                                                            animateBoneName = "Dummy001/Bone001",
--                                                            --pos = {0.1,0.26,0},
--                                                            --pos = {-2.927546,-0.2853407,-0.3131419},
--                                                            pos = {-2.927,-0.285,-0.313},
--                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_40]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_40_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.036,0.036,0.036},
                                                    effects = {
--                                                        {
--                                                            prefabName = "effect_yuwang_d",
--                                                            --pos = {-5.885505,-0.681901,-1.275103},
--                                                            pos = {-5.885,-0.681,-1.275},
--                                                            isInAnimate = true,
--                                                            animateBoneName = "Dummy001/Bone001",
--                                                        },
                                                    },
                                                },
                                            },
            },
        },
        UIFishStyleInfo = {
--            [FishType.FISH_KIND_18]= {
--                                            prefabName = "CommonFish",  --��Ӧ��ģ������
--                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
--                                            bones = {
--                                                Body = {
--                                                    prefabName = "_18_fish",
--                                                    name = "FishAnimate",
--                                                    --scale = {0.022,0.022,0.022},
--                                                    --scale = {0.022,0.022,0.022},  --UI��������ű���
--                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
--                                                    effects = {
--                                                    },
--                                                },
--                                            },
--            },
--            [FishType.FISH_KIND_19]= {
--                                            prefabName = "CommonFish",  --��Ӧ��ģ������
--                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
--                                            bones = {
--                                                Body = {
--                                                    prefabName = "_19_fish",
--                                                    name = "FishAnimate",
--                                                    --scale = {0.034,0.034,0.034},
--                                                    --scale = {0.034,0.034,0.034},
--                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
--                                                    effects = {
--                                                    },
--                                                },
--                                            },
--            },
--            [FishType.FISH_KIND_20]= {
--                                            prefabName = "CommonFish",  --��Ӧ��ģ������
--                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
--                                            bones = {
--                                                Body = {
--                                                    prefabName = "_20_fish",
--                                                    name = "FishAnimate",
--                                                    --scale = {0.025,0.025,0.025},
--                                                    --scale = {0.025,0.025,0.025},
--                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
--                                                    effects = {
--                                                    },
--                                                },
--                                            },
--            },
--            [FishType.FISH_KIND_21]= {
--                                            prefabName = "CommonFish",  --��Ӧ��ģ������
--                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
--                                            bones = {
--                                                Body = {
--                                                    prefabName = "_21_fish",
--                                                    name = "FishAnimate",
--                                                    --scale = {0.032,0.032,0.032},
--                                                    --scale = {0.032,0.032,0.032},
--                                                    pos = {-0.055,0,0},  --Ĭ��Ϊ 0,0,0;
--                                                    effects = {
----                                                        {
----                                                            prefabName = "effect_daxxx",
----                                                            name = "Effect",
----                                                            pos = {-30.3,-0.1,-1.1}, --Ĭ��Ϊ 0,0,0;
----                                                            scale = {1,1,1},
----                                                            isInAnimate = true,
----                                                            animateBoneName = "Dummy001/Bip001 Pelvis/Bip001 Spine/Bip001 Spine1/Bip001 Spine2/Bip001 Neck/Bip001 L Clavicle/Bip001 L UpperArm/Bip001 L Forearm/Bone008(mirrored)/Bone010(mirrored)",
----                                                        },
----                                                        {
----                                                            prefabName = "effect_daxxx",
----                                                            name = "Effect",
----                                                            pos = {-29.6,0.3,-1.7}, --Ĭ��Ϊ 0,0,0;
----                                                            scale = {1,1,1},
----                                                            isInAnimate = true,
----                                                            animateBoneName = "Dummy001/Bip001 Pelvis/Bip001 Spine/Bip001 Spine1/Bip001 Spine2/Bip001 Neck/Bip001 R Clavicle/Bip001 R UpperArm/Bip001 R Forearm/Bone008/Bone010",
----                                                        },
--                                                    },
--                                                },
--                                            },
--            },
            [FishType.FISH_KIND_15]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_15_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.04,0.04,0.04},
                                                    effects = {
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_16]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_16_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.042,0.042,0.042},
                                                    effects = {
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_19]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_19_fish",
                                                    name = "FishAnimate",
                                                    --scale = {0.048,0.048,0.048},
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    effects = {
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_20]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_20_fish",
                                                    name = "FishAnimate",
                                                    --scale = {0.040,0.040,0.040},
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    effects = {
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_21]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "ui_21_fish",
                                                    name = "FishAnimate",
                                                    --scale = {0.04,0.04,0.04},
                                                    --scale = {0.04,0.04,0.04},
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    effects = {
                                                        {
--                                                            prefabName = "effect_binggui2",
--                                                            name = "EffectBingGui",
--                                                            pos = {-0.1779561,0.1904,0}, --Ĭ��Ϊ 0,0,0;
                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_22]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_22_fish",
                                                    name = "FishAnimate",
                                                    --scale = {0.04,0.04,0.04},
                                                    --scale = {0.04,0.04,0.04},
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    effects = {
                                                        {
--                                                            prefabName = "effect_binggui2",
--                                                            name = "EffectBingGui",
--                                                            pos = {-0.1779561,0.1904,0}, --Ĭ��Ϊ 0,0,0;
                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_23]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "ui_23_fish",
                                                    name = "FishAnimate",
                                                    --scale = {0.054,0.054,0.054},
                                                    --scale = {0.054,0.054,0.054},
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    effects = {
                                                        {
--                                                            prefabName = "effect_baojian",
--                                                            name = "Effect",
--                                                            pos = {-0.31,0.07,2.61}, --Ĭ��Ϊ 0,0,0;
--                                                            rotation = {0,270,90}, --��ת�Ƕ�
--                                                            scale = {1,1,1},
--                                                            isInAnimate = true,
--                                                            animateBoneName = "Dummy001",
                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_24]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "ui_24_fish",
                                                    name = "FishAnimate",
                                                    --scale = {0.07,0.07,0.07},
                                                    --scale = {0.07,0.07,0.07},
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    effects = {
                                                        {
--                                                            prefabName = "effect_zhadan",
--                                                            name = "EffectZhaDan",
--                                                            pos = {1,0,-0.5}, --Ĭ��Ϊ 0,0,0;
--                                                            scale = {1.5,1.5,1.5},
--                                                            isInAnimate = true,
--                                                            animateBoneName = "Dummy001",
                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_25]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Group, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "ui_25_fish",
                                                    name = "FishAnimate",
                                                    --scale = {0.018,0.018,0.018},
                                                    --scale = {0.018,0.018,0.018},
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    effects = {
                                                        {
--                                                            prefabName = "effect_sanyuan",
--                                                            pos = {0,-4.5,-1.944}, --Ĭ��Ϊ 0,0,0;
--                                                            isInAnimate = true,
--                                                            animateBoneName = "Dummy001",
                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_26]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Group, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_25_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.018,0.018,0.018},
                                                    --scale = {0.018,0.018,0.018},
                                                    effects = {
--                                                        {
--                                                            prefabName = "effect_sanyuan",
--                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_27]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Group, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_25_fish",
                                                    name = "FishAnimate",
                                                    --scale = {0.018,0.018,0.018},
                                                    --scale = {0.018,0.018,0.018},
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    effects = {
--                                                        {
--                                                            prefabName = "effect_sanyuan",
--                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_28]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Group, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "ui_28_fish",
                                                    name = "FishAnimate",
                                                    --scale = {0.018,0.018,0.018},
                                                    --scale = {0.018,0.018,0.018},
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    effects = {
                                                        {
--                                                            prefabName = "effect_sixi",
--                                                            pos = {0,-4.5,-1.944}, --Ĭ��Ϊ 0,0,0;
--                                                            isInAnimate = true,
--                                                            animateBoneName = "Dummy001",
                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_29]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Group, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_28_fish",
                                                    name = "FishAnimate",
                                                    --scale = {0.018,0.018,0.018},
                                                    --scale = {0.018,0.018,0.018},
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    effects = {
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_30]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Group, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "_28_fish",
                                                    name = "FishAnimate",
                                                    --scale = {0.018,0.018,0.018},
                                                    --scale = {0.018,0.018,0.018},
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    effects = {
                                                    },
                                                },
                                            },
            },   
            [FishType.FISH_KIND_31]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "ui_31_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.07,0.07,0.07},
                                                    effects = {
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_32]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "ui_32_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.07,0.07,0.07},
                                                    effects = {
--                                                        {
--                                                            prefabName = "effect_yuwang_d",
--                                                            isInAnimate = true,
--                                                            animateBoneName = "Dummy001/Bone001",
--                                                            --pos = {0,0.52,0.07},
--                                                            pos = {-1.5,0.1,0.3},
--                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_33]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "ui_33_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.052,0.052,0.052},
                                                    effects = {
--                                                        {
--                                                            prefabName = "effect_yuwang_d",
--                                                            isInAnimate = true,
--                                                            animateBoneName = "Dummy001/Bone001",
--                                                            --pos = {0,0.221,0.03},
--                                                            --pos = {-2.7,-0.7,0.3},
--                                                            pos = {-2.6,-0.5,-0.4},
--                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_34]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "ui_34_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.05,0.05,0.05},
                                                    effects = {
--                                                        {
--                                                            prefabName = "effect_yuwang_d",
--                                                            isInAnimate = true,
--                                                            animateBoneName = "Dummy001/Bone001",
--                                                            pos = {-2.6,-0.1,0.8},
--                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_35]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "ui_35_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.046,0.046,0.046},
                                                    effects = {
--                                                        {
--                                                            prefabName = "effect_yuwang_d",
--                                                            isInAnimate = true,
--                                                            animateBoneName = "Dummy001/Bone001",
--                                                            --pos = {-1,0,0.3},
--                                                            pos = {-2.8,-0.2,-0.9},
--                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_36]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "ui_36_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.041,0.041,0.041},
                                                    effects = {
--                                                        {
--                                                            prefabName = "effect_yuwang_d",
--                                                            isInAnimate = true,
--                                                            animateBoneName = "Dummy001/Bone001",
--                                                            --pos = {0.026,0.3,0.054},
--                                                            pos = {-2.3,0.2,0.1},
--                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_37]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "ui_37_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.045,0.045,0.045},
                                                    effects = {
--                                                        {
--                                                            prefabName = "effect_yuwang_d",
--                                                            isInAnimate = true,
--                                                            animateBoneName = "Dummy001/Bone001",
--                                                            --pos = {-4.40202,-0.5652109,0.369894},
--                                                            pos = {-4.40,-0.565,0.37},
--                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_38]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "ui_38_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.046,0.046,0.046},
                                                    effects = {
--                                                        {
--                                                            prefabName = "effect_yuwang_d",
--                                                            isInAnimate = true,
--                                                            animateBoneName = "Dummy001/Bone001",
--                                                            --pos = {-0.03,0.14,0.16},
--                                                            --pos = {-3.379717,-0.351621,0.4641922},
--                                                            pos = {-3.38,-0.35,0.464},
--                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_39]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "ui_39_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.04,0.04,0.04},
                                                    effects = {
--                                                        {
--                                                            prefabName = "effect_yuwang_d",
--                                                            isInAnimate = true,
--                                                            animateBoneName = "Dummy001/Bone001",
--                                                            --pos = {0.1,0.26,0},
--                                                            --pos = {-2.927546,-0.2853407,-0.3131419},
--                                                            pos = {-2.927,-0.285,-0.313},
--                                                        },
                                                    },
                                                },
                                            },
            },
            [FishType.FISH_KIND_40]= {
                                            prefabName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            bones = {
                                                Body = {
                                                    prefabName = "ui_40_fish",
                                                    name = "FishAnimate",
                                                    pos = nil,  --Ĭ��Ϊ 0,0,0;
                                                    --scale = {0.036,0.036,0.036},
                                                    effects = {
--                                                        {
--                                                            prefabName = "effect_yuwang_d",
--                                                            --pos = {-5.885505,-0.681901,-1.275103},
--                                                            pos = {-5.885,-0.681,-1.275},
--                                                            isInAnimate = true,
--                                                            animateBoneName = "Dummy001/Bone001",
--                                                        },
                                                    },
                                                },
                                            },
            },     
        },
        ShaderName={
            [ShaderID.Standard              ]           =   "Standard",
            [ShaderID.Custom_User_StandardFish]         =   "custom/user/StandardFish",
            [ShaderID.Custom_User_FengZhao]             =   "custom/user/fengzhao",
            [ShaderID.Custom_User_YinBaoXiang]          =   "custom/user/yinbaoxiang",
            [ShaderID.Custom_User_JinBaoXiang]          =   "custom/user/jinbaoxiang",
            [ShaderID.Custom_User_TextureAlphaAdd]      =   "custom/user/TextureAlphaAdd",
            [ShaderID.Custom_User_AlphaTexture]         =   "custom/user/AlphaTexture",
            [ShaderID.Mobile_Particles_Additive]        =   "Mobile/Particles/Additive",
            [ShaderID.Custom_User_DiffMultiply]         =   "custom/user/DiffMultiply",
            [ShaderID.Custom_User_SelfTextured]         =   "custom/user/SelfTextured",
            [ShaderID.Custom_User_MyMask]               =   "custom/user/MyMask",
            [ShaderID.Custom_screen_GodRayDS1]          =   "custom/screen/GodRayDS1",
            [ShaderID.Mobile_Bumped_Diffuse]            =   "Mobile/Bumped Diffuse",
            [ShaderID.Mobile_Bumped_Specular]           =   "Mobile/Bumped Specular",  
            [ShaderID.Particles_Alpha_Blended]          =   "Particles/Vertexlit Blended"--"Particles/Alpha Blended Premultiply",
            --[ShaderID.Particles_Alpha_Blended]          =   "Particles/Alpha Blended",
        },
        AnimaStyleInfo = {
            [AnimateType.Wheel] = {
                isRaycastTarget = false, --�Ƿ�����¼���Ĭ�ϲ�����
                abfileName  = "module21/game_fish3d2_player",
                format="CJ_%04d",--֡���ָ�ʽ�� 
                frameBeginIndex=0, --��ʼ֡����
                frameCount     =3,
                frameInterval  =1, --֡�������
                frameMax       =11,
                interval       =0.05, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.FlyGold] = {
                abfileName  = "module21/game_fish3d2_scene",
                format="xj_%02d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =20,
                frameInterval  =1, --֡�������
                interval       =0.07, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.FlySilver] = {
                abfileName  = "module21/game_fish3d2_scene",
                format="xj_%02d",--֡���ָ�ʽ�� 
                frameBeginIndex=0, --��ʼ֡����
                frameCount     =20,
                frameInterval  =1, --֡�������
                interval       =0.1, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.Net] = {
                abfileName  = "module21/game_fish3d2_scene",
                format="net3_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=0, --��ʼ֡����
                frameCount     =12,
                frameInterval  =1, --֡�������
                interval       =0.1, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.Net_Self_2] = {
                abfileName  = "module21/game_fish3d2_scene",
                format="net2_2ion_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=0, --��ʼ֡����
                frameCount     =10,
                frameInterval  =1, --֡�������
                interval       =0.1, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.Net_Self_3] = {
                abfileName  = "module21/game_fish3d2_scene",
                format="net3_3ion_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=0, --��ʼ֡����
                frameCount     =10,
                frameInterval  =1, --֡�������
                interval       =0.1, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.Net_2] = {
                abfileName  = "module21/game_fish3d2_scene",
                format="net2_ion_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=0, --��ʼ֡����
                frameCount     =10,
                frameInterval  =1, --֡�������
                interval       =0.1, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.Net_3] = {
                abfileName  = "module21/game_fish3d2_scene",
                format="net3_ion_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=0, --��ʼ֡����
                frameCount     =10,
                frameInterval  =1, --֡�������
                interval       =0.1, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.Net_Self] = {
                abfileName  = "module21/game_fish3d2_scene",
                format="yw_L_%05d",--֡���ָ�ʽ�� 
                frameBeginIndex=0, --��ʼ֡����
                frameCount     =10,
                frameInterval  =1, --֡�������
                interval       =0.05, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.Net_Other] = {
                abfileName  = "module21/game_fish3d2_scene",
                format="yw_Z_%05d",--֡���ָ�ʽ�� 
                frameBeginIndex=0, --��ʼ֡����
                frameCount     =10,
                frameInterval  =1, --֡�������
                interval       =0.05, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.Water] = {
                abfileName  = "module21/game_fish3d2_scene",
                format="water%02d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =8,
                frameInterval  =2, --֡�������
                interval       =0.1, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.BulletSelf1] = {
                abfileName  = "module21/game_fish3d2_ui",
                format="lv_%d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =1,
                frameInterval  =1, --֡�������
                --interval       =0.05, --����ʱ����
                interval       =99999, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.BulletSelf2] = {
                abfileName  = "module21/game_fish3d2_ui",
                format="lv_%d",--֡���ָ�ʽ�� 
                frameBeginIndex=2, --��ʼ֡����
                frameCount     =1,
                frameInterval  =1, --֡�������
                --interval       =0.05, --����ʱ����
                interval       =99999, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.BulletSelf3] = {
                abfileName  = "module21/game_fish3d2_ui",
                format="lv_%d",--֡���ָ�ʽ�� 
                frameBeginIndex=3, --��ʼ֡����
                frameCount     =1,
                frameInterval  =1, --֡�������
                --interval       =0.05, --����ʱ����
                interval       =99999, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.BulletOther1] = {
                abfileName  = "module21/game_fish3d2_ui",
                format="lv_%d_1",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =1,
                frameInterval  =1, --֡�������
                --interval       =0.05, --����ʱ����
                interval       =99999, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.BulletOther2] = {
                abfileName  = "module21/game_fish3d2_ui",
                format="lv_%d_1",--֡���ָ�ʽ�� 
                frameBeginIndex=2, --��ʼ֡����
                frameCount     =1,
                frameInterval  =1, --֡�������
                --interval       =0.05, --����ʱ����
                interval       =99999, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.BulletOther3] = {
                abfileName  = "module21/game_fish3d2_ui",
                format="lv_%d_1",--֡���ָ�ʽ�� 
                frameBeginIndex=3, --��ʼ֡����
                frameCount     =1,
                frameInterval  =1, --֡�������
                --interval       =0.05, --����ʱ����
                interval       =99999, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.BulletEmery] = {
                abfileName  = "module21/game_fish3d2_scene",
                format="bullet4_ion_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =2,
                frameInterval  =1, --֡�������
                interval       =0.05, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.BulletEmery_1] = {
                abfileName  = "module21/game_fish3d2_scene",
                format="MaxZDB_%d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =2,
                frameInterval  =1, --֡�������
                interval       =0.05, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.BulletEmery_2] = {
                abfileName  = "module21/game_fish3d2_scene",
                format="MaxZDC_%d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =2,
                frameInterval  =1, --֡�������
                interval       =0.05, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.BulletEmery_3] = {
                abfileName  = "module21/game_lkpy2_scene",
                format="MaxZDD_%d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =2,
                frameInterval  =1, --֡�������
                interval       =0.05, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.PaotaiSelf1] = {
                abfileName  = "module21/game_fish3d2_ui",
                defaultSprite = "sp_1_1",
                format="sp_1_%d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =5,
                frameInterval  =1, --֡�������
                interval       =0.055, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.PaotaiSelf2] = {
                abfileName  = "module21/game_fish3d2_ui",
                defaultSprite = "sp_2_1",
                format="sp_2_%d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =5,
                frameInterval  =1, --֡�������
                interval       =0.055, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.PaotaiSelf3] = {
                abfileName  = "module21/game_fish3d2_ui",
                defaultSprite = "sp_3_1",
                format="sp_3_%d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =5,
                frameInterval  =1, --֡�������
                interval       =0.055, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.PaotaiOther1] = {
                abfileName  = "module21/game_fish3d2_ui",
                defaultSprite = "op_1_0000_0",
                format="op_1_0000_%d",--֡���ָ�ʽ�� 
                frameBeginIndex=0, --��ʼ֡����
                frameCount     =5,
                frameInterval  =1, --֡�������
                interval       =0.055, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.PaotaiOther2] = {
                abfileName  = "module21/game_fish3d2_ui",
                defaultSprite = "op_2_0000_0",
                format="op_2_0000_%d",--֡���ָ�ʽ�� 
                frameBeginIndex=0, --��ʼ֡����
                frameCount     =5,
                frameInterval  =1, --֡�������
                interval       =0.055, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.PaotaiOther3] = {
                abfileName  = "module21/game_fish3d2_ui",
                defaultSprite = "op_3_0000_0",
                format="op_3_0000_%d",--֡���ָ�ʽ�� 
                frameBeginIndex=0, --��ʼ֡����
                frameCount     =5,
                frameInterval  =1, --֡�������
                interval       =0.055, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.PaotaiEmery] = {
                abfileName  = "module21/game_fish3d2_scene",
                format="pt__5-%d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =3,
                frameInterval  =1, --֡�������
                interval       =0.08, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.PaotaiEmery_1] = {
                abfileName  = "module21/game_fish3d2_scene",
                format="MaxPaoTongB_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =3,
                frameInterval  =1, --֡�������
                interval       =0.08, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.PaotaiEmery_2] = {
                abfileName  = "module21/game_fish3d2_scene",
                format="MaxPaoTongC_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =3,
                frameInterval  =1, --֡�������
                interval       =0.08, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.PaotaiEmery_3] = {
                abfileName  = "module21/game_fish3d2_scene",
                format="MaxFourPaoD_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =3,
                frameInterval  =1, --֡�������
                interval       =0.08, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.BombEffect] = {
                abfileName  = "module21/game_fish3d2_scene",
                format="kingbomb_%05d",--֡���ָ�ʽ�� 
                frameBeginIndex=0, --��ʼ֡����
                frameCount     =15,
                frameInterval  =1, --֡�������
                interval       =0.03, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },

            [AnimateType.FishDeadEffect] = {
                abfileName  = "module21/game_fish3d2_scene",
                format="coinfly_%05d",--֡���ָ�ʽ�� 
                frameBeginIndex=0, --��ʼ֡����
                frameCount     =15,
                frameInterval  =1, --֡�������
                interval       =0.06, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.LineEffect] = {
                abfileName  = "module21/game_fish3d2_scene",
                format="xian_%05d",--֡���ָ�ʽ�� 
                frameBeginIndex=0, --��ʼ֡����
                frameCount     =4,
                frameInterval  =1, --֡�������
                interval       =0.05, --����ʱ����
                isCorrentSize  =true, --�Ƿ���Ҫ������С
            },
            [AnimateType.LineSourceEffect] = {
                abfileName  = "module21/game_fish3d2_scene",
                format="zhe_%05d",--֡���ָ�ʽ�� 
                frameBeginIndex=0, --��ʼ֡����
                frameCount     =6,
                frameInterval  =1, --֡�������
                interval       =0.1, --����ʱ����
                isCorrentSize  =true, --�Ƿ���Ҫ������С
            },
            [AnimateType.Wave] = {
                abfileName  = "module21/game_fish3d2_scene",
                format="HaiLang_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =3,
                frameInterval  =1, --֡�������
                interval       =0.16, --����ʱ����
                isCorrentSize  =true, --�Ƿ���Ҫ������С
            },
        },
    };
    self.GameConfig.NetInfo = {
        [NetType.Common]  = {
                Style       = {
                    self = { 
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.Net_Self,
                    },
                    other = {
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.Net_Other,
                    },
                },            
        },
        [NetType.Double]  = {
                Style       = {
                    self = { 
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.Net_Self,
                    },
                    other = {
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.Net_Other,
                    },
                },            
        },
        [NetType.Three]  = {
                Style       = {
                    self = { 
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.Net_Self,
                    },
                    other = {
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.Net_Other,
                    },
                },            
        },
    };
end

--ע���¼�
function _CGlobalGame:RegEvent(_eventId,_obj,_handler)
    self._eventSystem:RegEvent(_eventId,_obj,_handler);
end

--ȥ���¼�
function _CGlobalGame:RemoveEvent(_obj)
    self._eventSystem:RemoveEvent(_obj);
end

--����¼�
function _CGlobalGame:Clear()
    self._cachePool = nil;
    self._eventSystem:Clear();
end

--�ַ��¼�
function _CGlobalGame:DispatchEvent(_eventId,_eventData)
    self._eventSystem:DispatchEvent(_eventId,_eventData);
end

--�ַ��¼�
function _CGlobalGame:DispatchEventByStringKey(_eventStr,_eventData)
    self._eventSystem:DispatchEvent(self.Enum_EventID[_eventStr],_eventData);
end


--ע���¼�
function _CGlobalGame:RegEventByStringKey(_eventStr,_obj,_handler)
    self._eventSystem:RegEvent(self.Enum_EventID[_eventStr],_obj,_handler);
end

--������Ч
function _CGlobalGame:PlayEffect(_effectId)
    if self._soundCtrl then
        self._soundCtrl:PlaySound(_effectId);
    end
end

--���ű�������
function _CGlobalGame:PlayBgSound(_effectId)
    if self._soundCtrl then
        self._soundCtrl:PlayBgSound(_effectId);
    end
end

--ֹͣ��������
function _CGlobalGame:StopBgSound()
    if self._soundCtrl then
        self._soundCtrl:StopBgSound();
    end
end

--��������
function _CGlobalGame:CacheObject(cobject,cacheName)
    if G_GlobalGame.isQuitGame then
        return false;
    end
    if self._cachePool then
        local position;
        local localScale;
        local localRotation;
        if cobject:IsKeepSame() then
            position = cobject:Position();
            localScale    = cobject:LocalScale();
            localRotation = cobject:LocalRotation();
        end
        if cacheName and cacheName~=String.Empte then
            local obj  = self._cacheObjs[cacheName];
            if not obj then
                obj = GAMEOBJECT_NEW();
                obj.name = cacheName;
                obj = obj.transform;
                obj:SetParent(self._cachePool);
                obj.localPosition = C_Vector3_Zero; 
                obj.localScale  = C_Vector3_One; 
                self._cacheObjs[cacheName] = obj;
            end
            cobject:SetParent(obj);  
        else
            cobject:SetParent(self._cachePool);        
        end
        if cobject:IsKeepSame() then
            cobject:SetPosition(position);
            cobject:SetLocalScale(localScale);
            cobject:SetLocalRotation(localRotation);
        end
        return true;
    else
        cobject:Destroy();
        return false;
    end
end

--������Ϸ��
function _CGlobalGame:CacheGO(gameObject,cacheName)
    cacheName = cacheName or self.defaultCacheGOName;
    if G_GlobalGame.isQuitGame then
        return false;
    end
    if gameObject==nil then
        return false;
    end
    if self._cachePool then
        local transform = gameObject.transform;
        local localPosition = transform.localPosition;
        local localScale    = transform.localScale;
        local localRotation = transform.localRotation;
        if cacheName then
            local obj  = self._cacheObjs[cacheName];
            if not obj then
                obj = GAMEOBJECT_NEW();
                obj.name = cacheName;
                obj = obj.transform;
                obj:SetParent(self._cachePool);
                obj.localPosition = C_Vector3_Zero; 
                obj.localScale  = C_Vector3_One; 
                self._cacheObjs[cacheName] = obj;
            end
            transform:SetParent(obj);  
        else
            transform:SetParent(self._cachePool);
        end
        transform.localPosition = localPosition;
        transform.localScale = localScale;
        transform.localRotation = localRotation;
        return true; 
    else
        destroy(gameObject);
        return false;
    end
end


function _CGlobalGame:GetGameRunTime()
    return self._runTime;
end

function _CGlobalGame:FixedUpdate(_dt)
    self._runTime = self._runTime + _dt*1000;
end

--��ֵ��
function _CGlobalGame:GetKeyValue(_key,...)
    if not _key then
        return nil;
    end
    local handler = self._valuesMap:value(_key);
    if handler==nil then
        return nil;
    end
    return handler(...);
end

function _CGlobalGame:SetKeyHandler(_key,_handler)
    if not _key then
        return nil;
    end
    if _handler then
        self._valuesMap:assign(_key,_handler);
    else
        self:RemoveKeyHandler(_key);
    end
end

function _CGlobalGame:RemoveKeyHandler(_key)
    self._valuesMap:erase(_key);
end

--�򿪰�������
function _CGlobalGame:OpenHelpPanel()
    if not self._helpPanel then
        self._helpPanel = self._helpPanelCreator.Create(self._helpPanelTrans);
        self._helpPanel:Init();
        --���´�
        --self._helpPanel:OnOpen();
    end
    self._helpPanel:OnOpen();
end


function _CGlobalGame:InitSuccess()
    if not self._isInitSuccess then
        self._isInitSuccess = true;
        if self._gamePanelObj then
            GameManager.PanelInitSucceed(self._gamePanelObj); 
        end
    end
end

function _CGlobalGame:SwitchWorldPosToScreenPosBy3DCamera(pos)
    return Util.WorlPointToScreenSpace(pos, self._3DCamera);
end

function _CGlobalGame:SwitchScreenPosToWorldPosBy3DCamera(pos,z)
    if z==nil then
        return self._3DCamera:ScreenToWorldPoint(pos);
    else
        V_Vector3_Value.x=pos.x;
        V_Vector3_Value.y=pos.y;
        V_Vector3_Value.z=z;
        return self._3DCamera:ScreenToWorldPoint(V_Vector3_Value);
    end
end

--���������л�����������
function _CGlobalGame:SwitchWorldPosToWorldPosBy3DCamera(pos,z)
    local pos1= self:SwitchWorldPosToScreenPosBy3DCamera(pos);
    pos1.z = z;
    return self:SwitchScreenPosToWorldPosBy3DCamera(pos1);
end

function _CGlobalGame:SwitchWorldPosToScreenPosByUICamera(pos)
    return self._uiCamera:WorldToScreenPoint(pos);
end

function _CGlobalGame:SwitchScreenPosToWorldPosByUICamera(pos,z)
    --local position = self._uiCameraPos;
    local position = self._uiCamera.transform.position;
    z = pos.z;
    V_Vector3_Value.x=(pos.x- position.x);
    V_Vector3_Value.y=(pos.y - position.y);
    V_Vector3_Value.z= z - position.z;
    if z==nil then
        return self._uiCamera:ScreenToWorldPoint(V_Vector3_Value);
    else
        return self._uiCamera:ScreenToWorldPoint(V_Vector3_Value);
    end
end

function _CGlobalGame:SwitchScreenPosToWorldPosByUICameraEx(pos)
    local newPos  = self._uiCamera:ScreenToViewportPoint(pos);
    newPos =  self._uiCamera:ViewportToWorldPoint(newPos);
    return newPos;
end

function _CGlobalGame:InitNumbers(transform)
    self.numbers = transform;
    self.numbersSprites = {};
    local count = self.numbers.childCount;
    local child = nil;
    local name  = nil;
    local child2= nil;
    local childCount2 = nil;
    local newSprites;
    local image;
    local sprite;
    for i=1,count do
        child = self.numbers:GetChild(i-1);
        name = child.gameObject.name;
        self.numbersSprites[name] = {};
        childCount2 = child.childCount;
        newSprites = self.numbersSprites[name];
        for j=1,childCount2 do
            child2 = child:GetChild(j-1);
            image = child2:GetComponent(ImageClassType);
            if image then
                sprite = image.sprite;
                newSprites[child2.gameObject.name]=image.sprite;
                if sprite then
                   -- newSprites[child2.gameObject.name] = UnityEngine.Sprite.Create(sprite.texture,sprite.textureRect,sprite.pivot);
                else
                   -- newSprites[child2.gameObject.name] = image.sprite;
                end
            end
        end
    end 
end

function _CGlobalGame:GetSprite(nameGroup,name)
    local spriteGroup = self.numbersSprites[nameGroup];
    if spriteGroup then
        return spriteGroup[name];
    end
    return nil;
end

function _CGlobalGame:Update(_dt)
    if self._helpPanel then
        self._helpPanel:Update(_dt);
    end
end


function _CGlobalGame:CreateAtlasNumber(transform,...)
	--error("----------------CreateAtlasNumber------------------"..transform.name)
    local child = transform:GetChild(0);
    local nameGroup = child.gameObject.name;
    if self._nameGroupCreator[nameGroup] then

    else
        local GetAtlasNumber = function(name)
            return self:GetSprite(nameGroup,name);
        end
        self._nameGroupCreator[nameGroup] = GetAtlasNumber;
    end
    local atlasLabel = AtlasNumber.New(self._nameGroupCreator[nameGroup],...);
    atlasLabel:SetParent(transform);
    atlasLabel:SetLocalPosition(child.localPosition);
    atlasLabel:SetLocalScale(child.localScale);
    return atlasLabel;
end

function _CGlobalGame:CreateAtlasNumberByIndex(transform,index,...)
    index = index or 0;
    local child = transform:GetChild(index);
    local nameGroup = child.gameObject.name;
    if self._nameGroupCreator[nameGroup] then

    else
        local GetAtlasNumber = function(name)
            return self:GetSprite(nameGroup,name);
        end
        self._nameGroupCreator[nameGroup] = GetAtlasNumber;
    end
    local atlasLabel = AtlasNumber.New(self._nameGroupCreator[nameGroup],...);
    atlasLabel:SetParent(transform);
    atlasLabel:SetLocalPosition(child.localPosition);
    atlasLabel:SetLocalScale(child.localScale);
    return atlasLabel;
end

return _CGlobalGame;