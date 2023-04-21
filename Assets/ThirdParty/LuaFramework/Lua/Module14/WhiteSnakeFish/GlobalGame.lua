local _CGlobalGame = class("_CGlobalGame");
local ExternalLibs  = require "Common.ExternalLibs";
local EventSystem = ExternalLibs.EventSystem;
local GameSceneControl = GameRequire("GameSceneControl");

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

    self._helpPanelCreator = GameRequire("HelpPanel");
    self._helpPanel        = nil;


    self._isStartAsync     = false;
    self._asyncStep        = 1;
    self._isAsyncLoadOver  = true;
    self._asyncPrecent     = 11;
    --�Ƿ��������
    self._isLoginOver      = false;
    self._isSendSitDown    = false;
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
        C_S_FISH_KIND_MAX           = 42,
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
        GAME_ID                     = 25,
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
        Appearance      = idCreator(),   --���ֿ���������
    
    
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
        CatchTranslateFish  = idCreator(), --��׽�������
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
        NotifyFishGroupOver = idCreator(), --�㳱����
        NotifyShakeScreen   = idCreator(), --����Ļ
        NotifyClearAllEffects= idCreator(), --������е�Ч��
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
        FISH_KIND_41    = _idCreator(),
        FISH_KIND_42    = _idCreator(),
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
    self.Enum_BombEffectType   = {
        FishDead    = _idCreator(1),
        JuBuBomb    = _idCreator(2),
        QuanPing    = _idCreator(4),
        Line        = _idCreator(8),
        LineSource  = _idCreator(16),
        PauseScreen = _idCreator(32), --����Ч��
        Max         = _idCreator(64),
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
        Self_Paotai_4           = _idCreator(),
        Other_Paotai_4          = _idCreator(),
        Paotai_Energy           = _idCreator(),
        Paotai_Energy_1         = _idCreator(),
        Paotai_Energy_2         = _idCreator(),
        Paotai_Energy_3         = _idCreator(),
        Paotai_Energy_4         = _idCreator(),
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
        LockFishFlag_41         = _idCreator(),
        LockFishFlag_42         = _idCreator(),
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
        Net_1           = _idCreator(), --1����
        Net_2           = _idCreator(), --2����
        Net_3           = _idCreator(), --3����
        Water           = _idCreator(), --ˮ��
        Wave            = _idCreator(), --����
        BulletSelf1     = _idCreator(),
        BulletSelf2     = _idCreator(),
        BulletSelf3     = _idCreator(),
        BulletSelf4     = _idCreator(),
        BulletOther1    = _idCreator(),
        BulletOther2    = _idCreator(),
        BulletOther3    = _idCreator(),
        BulletOther4    = _idCreator(),
        BulletEmery     = _idCreator(),
        BulletEmery_1   = _idCreator(),
        BulletEmery_2   = _idCreator(),
        BulletEmery_3   = _idCreator(),
        BulletEmery_4   = _idCreator(),
        PaotaiSelf1     = _idCreator(),
        PaotaiSelf2     = _idCreator(),
        PaotaiSelf3     = _idCreator(),
        PaotaiSelf4     = _idCreator(),
        PaotaiOther1    = _idCreator(),
        PaotaiOther2    = _idCreator(),
        PaotaiOther3    = _idCreator(),
        PaotaiOther4    = _idCreator(),
        PaotaiEmery     = _idCreator(),
        PaotaiEmery_1   = _idCreator(),
        PaotaiEmery_2   = _idCreator(),
        PaotaiEmery_3   = _idCreator(),
        PaotaiEmery_4   = _idCreator(),
        Fire            = _idCreator(),
        Fire_2          = _idCreator(),  --��2
        Fire_3          = _idCreator(),  --��3
        Fire_4          = _idCreator(),  --��4
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
            Catch_TranslateFish     = idCreator(115),  --׽�������
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
        Bomb        = idCreator(),
    };
    
    --��ʼ������
    self:_initConstValue();
	
    --��ʼ��
    self:_initAppConstant();

    --��ʼ����Ϸ����
    self:_initGameConfig();

    self._soundCtrl:Init();
    
    self:_initFunctions();
end

function _CGlobalGame:_initConstValue()
    self.RunningPlatform = Application.platform;
    self.IsEditor        = Application.isEditor;
    RuntimePlatform.AndroidPlayer = 11;
end

--???????��???
function _CGlobalGame:_initAppConstant()
    --??????��????
    self.ConstantValue = {
        IsLandscape = true, --??????
        IsPortrait  = false, --???????
        MatchScreenWidth = 1334,
        MatchScreenHeight = 750,
        RealScreenWidth = 1334,
        RealScreenHeight = 750,
        CanvasRate  = 1,
    };
    --??????
    local matchRate = self.ConstantValue.MatchScreenWidth/self.ConstantValue.MatchScreenHeight;
    --?��???????
    if self.ConstantValue.IsLandscape then
        --?????��
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
        --??????
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

function _CGlobalGame:_initFunctions()
    --������
    self.FunctionsLib = GameRequire("Functions");
    self.FunctionsLib.FunctionInit(self);
end

local function _effect(tab,...)
    local arg = { ...}
    local ret = 0;
    for i, k in ipairs(arg) do
        ret = ret + tab[k];
    end
    return ret       
end

function _CGlobalGame:_initGameConfig()
    local PrefabType = self.Enum_PrefabType;
    local PaotaiType = self.Enum_PaotaiType;
    local BulletType = self.Enum_BulletType;
    local AnimateType= self.Enum_AnimateType;
    local NetType    = self.Enum_NetType;
    local FishType   = self.Enum_FishType;
    local FISH_Effect= self.Enum_FISH_Effect;
    local BombEffectType = self.Enum_BombEffectType;
    local GoldType   = self.Enum_GoldType;
    local FishCombType  = self.Enum_FishCombType;
    local FishUnderPanType = self.Enum_FishUnderPanType;


    local ef=_effect;
    local BET = BombEffectType;
    self.GameConfig={
        PrefabName  = {
            [PrefabType.Self_Paotai_1          ] = {prefabName = "PaoTai_2_self"        ,abName=nil },
            [PrefabType.Other_Paotai_1         ] = {prefabName = "PaoTai_2_other"       ,abName=nil },
            [PrefabType.Self_Paotai_2          ] = {prefabName = "PaoTai_3_self"        ,abName=nil },
            [PrefabType.Other_Paotai_2         ] = {prefabName = "PaoTai_3_other"       ,abName=nil },
            [PrefabType.Self_Paotai_3          ] = {prefabName = "PaoTai_4_self"        ,abName=nil },
            [PrefabType.Other_Paotai_3         ] = {prefabName = "PaoTai_4_other"       ,abName=nil },
            [PrefabType.Self_Paotai_4          ] = {prefabName = "PaoTai_4_self"        ,abName=nil },
            [PrefabType.Other_Paotai_4         ] = {prefabName = "PaoTai_4_other"       ,abName=nil },
            [PrefabType.Paotai_Energy          ] = {prefabName = "PaoTai_energy"        ,abName=nil },
            [PrefabType.Paotai_Energy_1        ] = {prefabName = "PaoTai_energy"        ,abName=nil },
            [PrefabType.Paotai_Energy_2        ] = {prefabName = "PaoTai_energy"        ,abName=nil },
            [PrefabType.Paotai_Energy_3        ] = {prefabName = "PaoTai_energy"        ,abName=nil },
            [PrefabType.Paotai_Energy_4        ] = {prefabName = "PaoTai_energy"        ,abName=nil },
            [PrefabType.Self_Bullet_1          ] = {prefabName = "Bullet_2_self"        ,abName=nil },
            [PrefabType.Self_Bullet_2          ] = {prefabName = "Bullet_3_self"        ,abName=nil },
            [PrefabType.Self_Bullet_3          ] = {prefabName = "Bullet_4_self"        ,abName=nil },
            [PrefabType.Bullet_Energy_1        ] = {prefabName = "Bullet_2_energy"      ,abName=nil },
            [PrefabType.Bullet_Energy_2        ] = {prefabName = "Bullet_3_energy"      ,abName=nil },
            [PrefabType.Bullet_Energy_3        ] = {prefabName = "Bullet_4_energy"      ,abName=nil },
            [PrefabType.Other_Bullet_1         ] = {prefabName = "Bullet_2_other"       ,abName=nil },
            [PrefabType.Other_Bullet_2         ] = {prefabName = "Bullet_3_other"       ,abName=nil },
            [PrefabType.Other_Bullet_3         ] = {prefabName = "Bullet_4_other"       ,abName=nil },
            [PrefabType.CommonBullet           ] = {prefabName = "CommonBullet"         ,abName=nil },


            --��
            [PrefabType.FISH_KIND_1            ] = {prefabName = "Fish_1"               ,abName=nil },
            [PrefabType.FISH_KIND_2            ] = {prefabName = "Fish_2"               ,abName=nil },
            [PrefabType.FISH_KIND_3            ] = {prefabName = "Fish_3"               ,abName=nil },
            [PrefabType.FISH_KIND_4            ] = {prefabName = "Fish_4"               ,abName=nil },
            [PrefabType.FISH_KIND_5            ] = {prefabName = "Fish_5"               ,abName=nil },
            [PrefabType.FISH_KIND_6            ] = {prefabName = "Fish_6"               ,abName=nil },
            [PrefabType.FISH_KIND_7            ] = {prefabName = "Fish_7"               ,abName=nil },
            [PrefabType.FISH_KIND_8            ] = {prefabName = "Fish_8"               ,abName=nil },
            [PrefabType.FISH_KIND_9            ] = {prefabName = "Fish_9"               ,abName=nil },
            [PrefabType.FISH_KIND_10           ] = {prefabName = "Fish_10"              ,abName=nil },
            [PrefabType.FISH_KIND_11           ] = {prefabName = "Fish_11"              ,abName=nil },
            [PrefabType.FISH_KIND_12           ] = {prefabName = "Fish_12"              ,abName=nil },
            [PrefabType.FISH_KIND_13           ] = {prefabName = "Fish_13"              ,abName=nil },
            [PrefabType.FISH_KIND_14           ] = {prefabName = "Fish_14"              ,abName=nil },
            [PrefabType.FISH_KIND_15           ] = {prefabName = "Fish_15"              ,abName=nil },
            [PrefabType.FISH_KIND_16           ] = {prefabName = "Fish_16"              ,abName=nil },
            [PrefabType.FISH_KIND_17           ] = {prefabName = "Fish_17"              ,abName=nil },
            [PrefabType.FISH_KIND_18           ] = {prefabName = "Fish_18"              ,abName=nil },
            [PrefabType.FISH_KIND_19           ] = {prefabName = "Fish_19"              ,abName=nil },
            [PrefabType.FISH_KIND_20           ] = {prefabName = "Fish_20"              ,abName=nil },
            [PrefabType.FISH_KIND_21           ] = {prefabName = "Fish_21"              ,abName=nil },
            [PrefabType.FISH_KIND_22           ] = {prefabName = "Fish_22"              ,abName=nil },
            [PrefabType.FISH_KIND_23           ] = {prefabName = "Fish_23"              ,abName=nil },
            [PrefabType.FISH_KIND_24           ] = {prefabName = "Fish_24"              ,abName=nil },
            [PrefabType.FISH_KIND_25           ] = {prefabName = "Fish_25"              ,abName=nil },
            [PrefabType.FISH_KIND_26           ] = {prefabName = "Fish_26"              ,abName=nil },
            [PrefabType.FISH_KIND_27           ] = {prefabName = "Fish_27"              ,abName=nil },
            [PrefabType.FISH_KIND_28           ] = {prefabName = "Fish_28"              ,abName=nil },
            [PrefabType.FISH_KIND_29           ] = {prefabName = "Fish_29"              ,abName=nil },
            [PrefabType.FISH_KIND_30           ] = {prefabName = "Fish_30"              ,abName=nil },
            [PrefabType.FISH_KIND_31           ] = {prefabName = "Fish_31"              ,abName=nil },
            [PrefabType.FISH_KIND_32           ] = {prefabName = "Fish_32"              ,abName=nil },
            [PrefabType.FISH_KIND_33           ] = {prefabName = "Fish_33"              ,abName=nil },
            [PrefabType.FISH_KIND_34           ] = {prefabName = "Fish_34"              ,abName=nil },
            [PrefabType.FISH_KIND_35           ] = {prefabName = "Fish_35"              ,abName=nil },
            [PrefabType.FISH_KIND_36           ] = {prefabName = "Fish_36"              ,abName=nil },
            [PrefabType.FISH_KIND_37           ] = {prefabName = "Fish_37"              ,abName=nil },
            [PrefabType.FISH_KIND_38           ] = {prefabName = "Fish_38"              ,abName=nil },
            [PrefabType.FISH_KIND_39           ] = {prefabName = "Fish_39"              ,abName=nil },
            [PrefabType.FISH_KIND_40           ] = {prefabName = "Fish_40"              ,abName=nil },
            [PrefabType.LockLine               ] = {prefabName = "LockLine"             ,abName=nil },
            [PrefabType.LockTarget_1           ] = {prefabName = "LockItem_1"           ,abName=nil },
            [PrefabType.LockTarget_2           ] = {prefabName = "LockItem_2"           ,abName=nil },
            [PrefabType.LockTarget_3           ] = {prefabName = "LockItem_3"           ,abName=nil },
            [PrefabType.LockTarget_4           ] = {prefabName = "LockItem_4"           ,abName=nil },
            [PrefabType.ScoreColumnRed         ] = {prefabName = "ScoreColumnRed"       ,abName=nil },
            [PrefabType.ScoreColumnGreen       ] = {prefabName = "ScoreColumnGreen"     ,abName=nil },

            --��ըЧ��
            [PrefabType.Effect_FishDead        ] = {prefabName = "JuBuEffect"               ,abName=nil },
            [PrefabType.Effect_Bomb            ] = {prefabName = "JuBuEffect"               ,abName=nil },
            [PrefabType.Effect_Line            ] = {prefabName = "BossDeadLine"             ,abName=nil },
            [PrefabType.Effect_PauseScreen     ] = {prefabName = "PauseScreenEffect"        ,abName=nil },
            

            [PrefabType.LockFishFlag_1         ] = {prefabName = "lock_flag0_000"           ,abName=nil },
            [PrefabType.LockFishFlag_2         ] = {prefabName = "lock_flag0_001"           ,abName=nil },
            [PrefabType.LockFishFlag_3         ] = {prefabName = "lock_flag0_002"           ,abName=nil },
            [PrefabType.LockFishFlag_4         ] = {prefabName = "lock_flag0_003"           ,abName=nil },
            [PrefabType.LockFishFlag_5         ] = {prefabName = "lock_flag0_004"           ,abName=nil },
            [PrefabType.LockFishFlag_6         ] = {prefabName = "lock_flag0_005"           ,abName=nil },
            [PrefabType.LockFishFlag_7         ] = {prefabName = "lock_flag0_006"           ,abName=nil },
            [PrefabType.LockFishFlag_8         ] = {prefabName = "lock_flag0_007"           ,abName=nil },
            [PrefabType.LockFishFlag_9         ] = {prefabName = "lock_flag0_008"           ,abName=nil },
            [PrefabType.LockFishFlag_10        ] = {prefabName = "lock_flag0_009"           ,abName=nil },
            [PrefabType.LockFishFlag_11        ] = {prefabName = "lock_flag0_010"           ,abName=nil },
            [PrefabType.LockFishFlag_12        ] = {prefabName = "lock_flag0_011"           ,abName=nil },
            [PrefabType.LockFishFlag_13        ] = {prefabName = "lock_flag0_012"           ,abName=nil },
            [PrefabType.LockFishFlag_14        ] = {prefabName = "lock_flag0_013"           ,abName=nil },
            [PrefabType.LockFishFlag_15        ] = {prefabName = "lock_flag0_014"           ,abName=nil },
            [PrefabType.LockFishFlag_16        ] = {prefabName = "LockRound_006"            ,abName=nil },
            [PrefabType.LockFishFlag_17        ] = {prefabName = "LockRound_007"            ,abName=nil },
            [PrefabType.LockFishFlag_18        ] = {prefabName = "LockRound_008"            ,abName=nil },
            [PrefabType.LockFishFlag_19        ] = {prefabName = "LockRound_009"            ,abName=nil },
            [PrefabType.LockFishFlag_20        ] = {prefabName = "LockRound_010"            ,abName=nil },
            [PrefabType.LockFishFlag_21        ] = {prefabName = "LockRound_011"            ,abName=nil },
            [PrefabType.LockFishFlag_22        ] = {prefabName = "LockRound_012"            ,abName=nil },
            [PrefabType.LockFishFlag_23        ] = {prefabName = "LockRound_023"            ,abName=nil },
            [PrefabType.LockFishFlag_24        ] = {prefabName = "LockRound_024"            ,abName=nil },
            [PrefabType.LockFishFlag_25        ] = {prefabName = "LockRound_027"            ,abName=nil },
            [PrefabType.LockFishFlag_26        ] = {prefabName = "LockRound_028"            ,abName=nil },
            [PrefabType.LockFishFlag_27        ] = {prefabName = "LockRound_029"            ,abName=nil },
            [PrefabType.LockFishFlag_28        ] = {prefabName = "LockRound_030"            ,abName=nil },
            [PrefabType.LockFishFlag_29        ] = {prefabName = "LockRound_031"            ,abName=nil },
            [PrefabType.LockFishFlag_30        ] = {prefabName = "LockRound_032"            ,abName=nil },
            [PrefabType.LockFishFlag_31        ] = {prefabName = "LockRound_013"            ,abName=nil },
            [PrefabType.LockFishFlag_32        ] = {prefabName = "LockRound_014"            ,abName=nil }, 
            [PrefabType.LockFishFlag_33        ] = {prefabName = "LockRound_015"            ,abName=nil },
            [PrefabType.LockFishFlag_34        ] = {prefabName = "LockRound_016"            ,abName=nil },
            [PrefabType.LockFishFlag_35        ] = {prefabName = "LockRound_017"            ,abName=nil },
            [PrefabType.LockFishFlag_36        ] = {prefabName = "LockRound_018"            ,abName=nil },
            [PrefabType.LockFishFlag_37        ] = {prefabName = "LockRound_019"            ,abName=nil },
            [PrefabType.LockFishFlag_38        ] = {prefabName = "LockRound_020"            ,abName=nil },
            [PrefabType.LockFishFlag_39        ] = {prefabName = "LockRound_021"            ,abName=nil },
            [PrefabType.LockFishFlag_40        ] = {prefabName = "LockRound_022"            ,abName=nil },
            [PrefabType.LockFishFlag_41        ] = {prefabName = "LockRound_025"            ,abName=nil },
            [PrefabType.LockFishFlag_42        ] = {prefabName = "LockRound_026"            ,abName=nil },
        },
        PaotaiInfo = {
            [PaotaiType.Paotai_1] = {
                NextPao = PaotaiType.Paotai_2,
                PrePao  = PaotaiType.Paotai_4,
                Bigger  = PaotaiType.Paotai_Energy_1,
                Smaller = nil,
                BulletType= BulletType.BULLET_KIND_1_NORMAL,
                Style   = {
                    self = { 
                        preType     = PrefabType.Self_Paotai_2,
                        bodyAnima   = AnimateType.PaotaiSelf2,
                        fireAnima   = AnimateType.Fire_2,
                    },
                    other = {
                        preType     = PrefabType.Other_Paotai_2,
                        bodyAnima   = AnimateType.PaotaiOther2,
                        fireAnima   = AnimateType.Fire_2,
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
                        fireAnima   = AnimateType.Fire_2,
                    },
                    other = {
                        preType     = PrefabType.Other_Paotai_2,
                        bodyAnima   = AnimateType.PaotaiOther2,
                        fireAnima   = AnimateType.Fire_2,
                    },
                },
            },
            [PaotaiType.Paotai_3] = {
                NextPao = PaotaiType.Paotai_4,
                PrePao  = PaotaiType.Paotai_2,
                Bigger  = PaotaiType.Paotai_Energy_3,
                Smaller = nil,
                BulletType= BulletType.BULLET_KIND_3_NORMAL,
                Style   = {
                    self = { 
                        preType     = PrefabType.Self_Paotai_3,
                        bodyAnima   = AnimateType.PaotaiSelf3,
                        fireAnima   = AnimateType.Fire_3,
                    },
                    other = {
                        preType     = PrefabType.Other_Paotai_3,
                        bodyAnima   = AnimateType.PaotaiOther3,
                        fireAnima   = AnimateType.Fire_3,
                    },
                },
            },
            [PaotaiType.Paotai_4] = {
                NextPao = PaotaiType.Paotai_1,
                PrePao  = PaotaiType.Paotai_3,
                Bigger  = PaotaiType.Paotai_Energy_4,
                Smaller = nil,
                BulletType= BulletType.BULLET_KIND_4_NORMAL,
                Style   = {
                    self = { 
                        preType     = PrefabType.Self_Paotai_4,
                        bodyAnima   = AnimateType.PaotaiSelf4,
                        fireAnima   = AnimateType.Fire_4,
                    },
                    other = {
                        preType     = PrefabType.Other_Paotai_4,
                        bodyAnima   = AnimateType.PaotaiOther4,
                        fireAnima   = AnimateType.Fire_4,
                    },
                },
            },
            [PaotaiType.Paotai_Energy_1] = {
                NextPao = PaotaiType.Paotai_Energy_2,
                PrePao  = PaotaiType.Paotai_Energy_4,
                Bigger  = nil,
                Smaller = PaotaiType.Paotai_1,
                BulletType= BulletType.BULLET_KIND_1_ION,
                Style   = {
                    self = { 
                        preType     = PrefabType.Paotai_Energy_2,
                        bodyAnima   = AnimateType.PaotaiEmery_2,
                        fireAnima   = AnimateType.Fire_2,
                    },
                    other = {
                        preType     = PrefabType.Paotai_Energy_2,
                        bodyAnima   = AnimateType.PaotaiEmery_2,
                        fireAnima   = AnimateType.Fire_2,
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
                        preType     = PrefabType.Paotai_Energy_2,
                        bodyAnima   = AnimateType.PaotaiEmery_2,
                        fireAnima   = AnimateType.Fire_2,
                    },
                    other = {
                        preType     = PrefabType.Paotai_Energy_2,
                        bodyAnima   = AnimateType.PaotaiEmery_2,
                        fireAnima   = AnimateType.Fire_2,
                    },
                },
            },
            [PaotaiType.Paotai_Energy_3] = {
                NextPao = PaotaiType.Paotai_Energy_4,
                PrePao  = PaotaiType.Paotai_Energy_2,
                Bigger  = nil,
                Smaller = PaotaiType.Paotai_3,
                BulletType= BulletType.BULLET_KIND_3_ION,
                Style   = {
                    self = { 
                        preType     = PrefabType.Paotai_Energy_3,
                        bodyAnima   = AnimateType.PaotaiEmery_3,
                        fireAnima   = AnimateType.Fire_3,
                    },
                    other = {
                        preType     = PrefabType.Paotai_Energy_3,
                        bodyAnima   = AnimateType.PaotaiEmery_3,
                        fireAnima   = AnimateType.Fire_3,
                    },
                },
            },
            [PaotaiType.Paotai_Energy_4] = {
                NextPao = PaotaiType.Paotai_Energy_1,
                PrePao  = PaotaiType.Paotai_Energy_3,
                Bigger  = nil,
                Smaller = PaotaiType.Paotai_4,
                BulletType= BulletType.BULLET_KIND_4_ION,
                Style   = {
                    self = { 
                        preType     = PrefabType.Paotai_Energy_4,
                        bodyAnima   = AnimateType.PaotaiEmery_4,
                        fireAnima   = AnimateType.Fire_4,
                    },
                    other = {
                        preType     = PrefabType.Paotai_Energy_4,
                        bodyAnima   = AnimateType.PaotaiEmery_4,
                        fireAnima   = AnimateType.Fire_4,
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
                multiple    = 1000,
                paoType     = PaotaiType.Paotai_1,
                netType     = NetType.Common,
                bulletKind  = BulletType.BULLET_KIND_1_NORMAL,
                isEnergy    = false,
                Style       = {
                    self = { 
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.BulletSelf1,
                        boxCollider = {
                            center  = { x = 0, y = 0, z = 0, },
                            size    = { x = 29, y = 32, z = 1, },
                        },
                    },
                    other = {
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.BulletOther1,
                        boxCollider = {
                            center  = { x = 0, y = 0, z = 0, },
                            size    = { x = 29, y = 32, z = 1, },
                        },
                    },
                },
            },
            [BulletType.BULLET_KIND_2_NORMAL] = {
                iSpeed      = 35,
                SelfName    = PrefabType.Self_Bullet_2,
                OtherName   = PrefabType.Other_Bullet_2,
                iNetRadius  = 0 ,
                multiple    = 2000,
                paoType     = PaotaiType.Paotai_2,
                netType     = NetType.Common,
                bulletKind  = BulletType.BULLET_KIND_2_NORMAL,
                isEnergy    = false,
                Style       = {
                    self = { 
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.BulletSelf2,
                        boxCollider = {
                            center  = { x = 0, y = 0, z = 0, },
                            size    = { x = 29, y = 27, z = 1, },
                        },
                    },
                    other = {
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.BulletOther2,
                        boxCollider = {
                            center  = { x = 0, y = 0, z = 0, },
                            size    = { x = 29, y = 27, z = 1, },
                        },
                    },
                },
            },
            [BulletType.BULLET_KIND_3_NORMAL] = {
                iSpeed      = 35,
                SelfName    = PrefabType.Self_Bullet_3,
                OtherName   = PrefabType.Other_Bullet_3,
                iNetRadius  = 0 ,
                multiple    = 5000,
                paoType     = PaotaiType.Paotai_3,
                netType     = NetType.Double,
                bulletKind  = BulletType.BULLET_KIND_3_NORMAL,
                isEnergy    = false,
                Style       = {
                    self = { 
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.BulletSelf3,
                        boxCollider = {
                            center  = { x = 0, y = 0, z = 0, },
                            size    = { x = 43, y = 32, z = 1, },
                        },
                    },
                    other = {
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.BulletOther3,
                        boxCollider = {
                            center  = { x = 0, y = 0, z = 0, },
                            size    = { x = 43, y = 32, z = 1, },
                        },
                    },
                },
            },
            [BulletType.BULLET_KIND_4_NORMAL] = {
                iSpeed      = 35,
                SelfName    = nil,
                OtherName   = nil,
                iNetRadius  = 0 ,
                multiple    = 10000,
                paoType     = PaotaiType.Paotai_4,
                netType     = NetType.Three,
                bulletKind  = BulletType.BULLET_KIND_4_NORMAL,
                isEnergy    = false,
                Style       = {
                    self = { 
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.BulletSelf4,
                        boxCollider = {
                            center  = { x = 0, y = 0, z = 0, },
                            size    = { x = 70, y = 24, z = 1, },
                        },
                    },
                    other = {
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.BulletOther4,
                        boxCollider = {
                            center  = { x = 0, y = 0, z = 0, },
                            size    = { x = 70, y = 24, z = 1, },
                        },
                    },
                },
            },
            [BulletType.BULLET_KIND_1_ION] = {
                iSpeed      = 40,
                SelfName    = PrefabType.Bullet_Energy_1,
                OtherName   = PrefabType.Bullet_Energy_1,
                iNetRadius  = 0 ,
                multiple    = 1000,
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
                multiple    = 2000,
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
                multiple    = 5000,
                paoType     = PaotaiType.Paotai_Energy_3,
                netType     = NetType.Double,
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
                multiple    = 10000,
                paoType     = PaotaiType.Paotai_Energy_4,
                netType     = NetType.Three,
                bulletKind  = BulletType.BULLET_KIND_4_NORMAL,
                isEnergy    = true,
                Style       = {
                    self = { 
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.BulletEmery_4,
                        boxCollider = {
                            center  = { x = 0, y = 0, z = 0, },
                            size    = { x = 52, y = 57, z = 1, },
                        },
                    },
                    other = {
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.BulletEmery_4,
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
            iFireInterval       = 0.33,  --����ʱ���� 0.33
            iFireEnergyInterval = 0.25,  --�����ڵĿ��ڼ�� 0.25
            fishHurtTime        = 0.2,   --��������ʾʱ��
            netAnimaInterval    = 0.05,  ---���Ĳ��Ŷ����ٶ�
            goldColumn          = 3, --�����ʾ�������
            goldColumnTime      = 5, --�����ʾ5��
            goldColumnMoveSpeed = 80, --�ƶ��ٶ�
            goldColumnDis       = 45, --���
            wheelDisplayTime    = 5, --Ħ������ʾʱ��
            pauseScreenTime     = 20, --����
            bombRound           = 300, --��ը��Χ���ֲ�ը��
            switchSceneInterval = 0.5, --�л��㳱�Ķ���ʱ����
            createGoldInterval  = 0.01, --��ұ�����ʱ����
            flyGoldSpeed        = 300, --�ɽ���ٶ�
            playSpeed_BombEffect= 0.20,  --�����ٶ�
            FrameCount          = 40,   --40֡
            iFishDeadTime       = 2,    --������ʱ�� ͳһ����
            iLineDisplayTime    = 1,    --������ʾʱ��
            iBulletLiveTime     = 10,   --�ӵ����ʱ��
            iPosTipTime         = 4,    --λ����ʾ��ʾ4��
            isAutoShot          = false, --�Ƿ��Զ�����
        },
        --����Ϣ
        FishInfo = {
            [FishType.FISH_KIND_1] = {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                           ShakeScreen=false, iMultiple = 1, localSpeed=13 , iRadius=0,groupIds={1,},actInterval=0.1,bgActInterval=0.1,isLock=false,isWheel=false,gold=2 ,goldType=GoldType.Silver   , iWidth=0, iHeight=0, iSpeed=13, cacheCount=15,},
            [FishType.FISH_KIND_2] = {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                           ShakeScreen=false, iMultiple = 1, localSpeed=13 , iRadius=0,groupIds={1,},actInterval=0.1,bgActInterval=0.1,isLock=false,isWheel=false,gold=2 ,goldType=GoldType.Silver   , iWidth=0, iHeight=0, iSpeed=13, cacheCount=15,},
            [FishType.FISH_KIND_3] = {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                           ShakeScreen=false, iMultiple = 1, localSpeed=13 , iRadius=0,groupIds={1,},actInterval=0.1,bgActInterval=0.1,isLock=false,isWheel=false,gold=3 ,goldType=GoldType.Silver   , iWidth=0, iHeight=0, iSpeed=13, cacheCount=15,},
            [FishType.FISH_KIND_4] = {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                           ShakeScreen=false, iMultiple = 1, localSpeed=13 , iRadius=0,groupIds={1,},actInterval=0.1,bgActInterval=0.1,isLock=false,isWheel=false,gold=3 ,goldType=GoldType.Silver   , iWidth=0, iHeight=0, iSpeed=13, cacheCount=15,},
            [FishType.FISH_KIND_5] = {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                           ShakeScreen=false, iMultiple = 1, localSpeed=13 , iRadius=0,groupIds={1,},actInterval=0.1,bgActInterval=0.1,isLock=false,isWheel=false,gold=4 ,goldType=GoldType.Silver   , iWidth=0, iHeight=0, iSpeed=13, cacheCount=15,},
            [FishType.FISH_KIND_6] = {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                           ShakeScreen=false, iMultiple = 1, localSpeed=13 , iRadius=0,groupIds={1,},actInterval=0.1,bgActInterval=0.1,isLock=false,isWheel=false,gold=5 ,goldType=GoldType.Silver   , iWidth=0, iHeight=0, iSpeed=13, cacheCount=15,},
            [FishType.FISH_KIND_7] = {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                           ShakeScreen=false, iMultiple = 1, localSpeed=13 , iRadius=0,groupIds={1,},actInterval=0.1,bgActInterval=0.1,isLock=false,isWheel=false,gold=5 ,goldType=GoldType.Silver   , iWidth=0, iHeight=0, iSpeed=13, cacheCount=10,},
            [FishType.FISH_KIND_8] = {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                           ShakeScreen=false, iMultiple = 1, localSpeed=13 , iRadius=0,groupIds={1,},actInterval=0.1,bgActInterval=0.1,isLock=false,isWheel=false,gold=5 ,goldType=GoldType.Silver   , iWidth=0, iHeight=0, iSpeed=13, cacheCount=10,},
            [FishType.FISH_KIND_9] = {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                           ShakeScreen=false, iMultiple = 1, localSpeed=13 , iRadius=0,groupIds={1,},actInterval=0.1,bgActInterval=0.1,isLock=false,isWheel=false,gold=5 ,goldType=GoldType.Silver   , iWidth=0, iHeight=0, iSpeed=13, cacheCount=7 ,},
            [FishType.FISH_KIND_10]= {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                           ShakeScreen=false, iMultiple = 1, localSpeed=20 , iRadius=0,groupIds={1,},actInterval=0.1,bgActInterval=0.1,isLock=false,isWheel=false,gold=2 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=5 ,},
            [FishType.FISH_KIND_11]= {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                           ShakeScreen=false, iMultiple = 1, localSpeed=20 , iRadius=0,groupIds={1,},actInterval=0.1,bgActInterval=0.1,isLock=false,isWheel=false,gold=3 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=5 ,},
            [FishType.FISH_KIND_12]= {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                           ShakeScreen=false, iMultiple = 1, localSpeed=20 , iRadius=0,groupIds={1,},actInterval=0.1,bgActInterval=0.1,isLock=false,isWheel=false,gold=3 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=5 ,},
            [FishType.FISH_KIND_13]= {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                           ShakeScreen=false, iMultiple = 1, localSpeed=20 , iRadius=0,groupIds={1,},actInterval=0.1,bgActInterval=0.1,isLock=false,isWheel=false,gold=4 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=5 ,},
            [FishType.FISH_KIND_14]= {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                           ShakeScreen=false, iMultiple = 1, localSpeed=20 , iRadius=0,groupIds={1,},actInterval=0.1,bgActInterval=0.1,isLock=false,isWheel=false,gold=5 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=5 ,},
            [FishType.FISH_KIND_15]= {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                           ShakeScreen=false, iMultiple = 1, localSpeed=25 , iRadius=0,groupIds={2,},actInterval=0.1,bgActInterval=0.1,isLock=false,isWheel=false,gold=6 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=25, cacheCount=3 ,},
            [FishType.FISH_KIND_16]= {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                           ShakeScreen=false, iMultiple = 1, localSpeed=25 , iRadius=0,groupIds={2,},actInterval=0.1,bgActInterval=0.1,isLock=true ,isWheel=true ,gold=6 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=25, cacheCount=3 ,},
            [FishType.FISH_KIND_17]= {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                           ShakeScreen=false, iMultiple = 1, localSpeed=25 , iRadius=0,groupIds={2,},actInterval=0.1,bgActInterval=0.1,isLock=true ,isWheel=true ,gold=6 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=25, cacheCount=3 ,},
            [FishType.FISH_KIND_18]= {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                           ShakeScreen=false, iMultiple = 1, localSpeed=30 , iRadius=0,groupIds={3,},actInterval=0.1,bgActInterval=0.1,isLock=true ,isWheel=true ,gold=6 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=30, cacheCount=2 ,},
            [FishType.FISH_KIND_19]= {effectType=FISH_Effect.Common_Fish, deadEffect=ef(BET,"FishDead","QuanPing"), ShakeScreen=true , iMultiple = 1, localSpeed=30 , iRadius=0,groupIds={3,},actInterval=0.1,bgActInterval=0.1,isLock=true ,isWheel=true ,gold=6 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=30, cacheCount=2 ,},
            [FishType.FISH_KIND_20]= {effectType=FISH_Effect.Common_Fish, deadEffect=ef(BET,"FishDead","QuanPing"), ShakeScreen=true , iMultiple = 1, localSpeed=35 , iRadius=0,groupIds={4,},actInterval=0.1,bgActInterval=0.1,isLock=true ,isWheel=true ,gold=10,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=35, cacheCount=2 ,},
            [FishType.FISH_KIND_21]= {effectType=FISH_Effect.Bomb_Fish  , deadEffect=ef(BET,"FishDead","QuanPing"), ShakeScreen=true , iMultiple = 1, localSpeed=30 , iRadius=0,groupIds={4,},actInterval=0.1,bgActInterval=0.1,isLock=true ,isWheel=true ,gold=0 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=30, cacheCount=2 ,},
            [FishType.FISH_KIND_22]= {effectType=FISH_Effect.Common_Fish, deadEffect=nil,                           ShakeScreen=false, iMultiple = 1, localSpeed=20 , iRadius=0,groupIds={3,},actInterval=0.1,bgActInterval=0.1,isLock=true ,isWheel=false,gold=0 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=2 ,},
            [FishType.FISH_KIND_23]= {effectType=FISH_Effect.Bomb_Fish  , deadEffect=ef(BET,"FishDead","QuanPing"), ShakeScreen=true , iMultiple = 1, localSpeed=25 , iRadius=0,groupIds={3,},actInterval=0.1,bgActInterval=0.1,isLock=true ,isWheel=false,gold=0 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=25, cacheCount=2 ,},
            [FishType.FISH_KIND_24]= {effectType=FISH_Effect.Stop_Fish  , deadEffect=BombEffectType.QuanPing,       ShakeScreen=true , iMultiple = 1, localSpeed=25 , iRadius=0,groupIds={3,},actInterval=0.1,bgActInterval=0.1,isLock=true ,isWheel=false,gold=0 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=25, cacheCount=2 ,},
            [FishType.FISH_KIND_25]= {effectType=FISH_Effect.Common_Fish, deadEffect=ef(BET,"FishDead","QuanPing"), ShakeScreen=true , iMultiple = 1, localSpeed=20 , iRadius=0,groupIds={1,},actInterval=0.1,bgActInterval=0.1,isLock=true ,isWheel=true ,gold=6 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=2 ,},
            [FishType.FISH_KIND_26]= {effectType=FISH_Effect.Common_Fish, deadEffect=ef(BET,"FishDead","QuanPing"), ShakeScreen=true , iMultiple = 1, localSpeed=20 , iRadius=0,groupIds={1,},actInterval=0.1,bgActInterval=0.1,isLock=true ,isWheel=true ,gold=6 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=2 ,},
            [FishType.FISH_KIND_27]= {effectType=FISH_Effect.Common_Fish, deadEffect=ef(BET,"FishDead","QuanPing"), ShakeScreen=true , iMultiple = 1, localSpeed=20 , iRadius=0,groupIds={1,},actInterval=0.1,bgActInterval=0.1,isLock=true ,isWheel=true ,gold=6 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=2 ,},
            [FishType.FISH_KIND_28]= {effectType=FISH_Effect.Common_Fish, deadEffect=ef(BET,"FishDead","QuanPing"), ShakeScreen=true , iMultiple = 1, localSpeed=20 , iRadius=0,groupIds={1,},actInterval=0.1,bgActInterval=0.1,isLock=true ,isWheel=true ,gold=8 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=2 ,},
            [FishType.FISH_KIND_29]= {effectType=FISH_Effect.Common_Fish, deadEffect=ef(BET,"FishDead","QuanPing"), ShakeScreen=true , iMultiple = 1, localSpeed=20 , iRadius=0,groupIds={1,},actInterval=0.1,bgActInterval=0.1,isLock=true ,isWheel=true ,gold=8 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=2 ,},
            [FishType.FISH_KIND_30]= {effectType=FISH_Effect.Common_Fish, deadEffect=ef(BET,"FishDead","QuanPing"), ShakeScreen=true , iMultiple = 1, localSpeed=20 , iRadius=0,groupIds={1,},actInterval=0.1,bgActInterval=0.1,isLock=true ,isWheel=true ,gold=8 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=2 ,},
            [FishType.FISH_KIND_31]= {effectType=FISH_Effect.Fish_Boss  , deadEffect=nil,                           ShakeScreen=false, iMultiple = 1, localSpeed=20 , iRadius=0,groupIds={1,},actInterval=0.1,bgActInterval=0.1,isLock=true ,isWheel=true ,gold=2 ,goldType=GoldType.Silver   , iWidth=0, iHeight=0, iSpeed=20, cacheCount=2 ,},
            [FishType.FISH_KIND_32]= {effectType=FISH_Effect.Fish_Boss  , deadEffect=nil,                           ShakeScreen=false, iMultiple = 1, localSpeed=20 , iRadius=0,groupIds={1,},actInterval=0.1,bgActInterval=0.1,isLock=true ,isWheel=true ,gold=2 ,goldType=GoldType.Silver   , iWidth=0, iHeight=0, iSpeed=20, cacheCount=2 ,},
            [FishType.FISH_KIND_33]= {effectType=FISH_Effect.Fish_Boss  , deadEffect=nil,                           ShakeScreen=false, iMultiple = 1, localSpeed=20 , iRadius=0,groupIds={1,},actInterval=0.1,bgActInterval=0.1,isLock=true ,isWheel=true ,gold=3 ,goldType=GoldType.Silver   , iWidth=0, iHeight=0, iSpeed=20, cacheCount=2 ,},
            [FishType.FISH_KIND_34]= {effectType=FISH_Effect.Fish_Boss  , deadEffect=nil,                           ShakeScreen=false, iMultiple = 1, localSpeed=20 , iRadius=0,groupIds={1,},actInterval=0.1,bgActInterval=0.1,isLock=true ,isWheel=true ,gold=3 ,goldType=GoldType.Silver   , iWidth=0, iHeight=0, iSpeed=20, cacheCount=2 ,},
            [FishType.FISH_KIND_35]= {effectType=FISH_Effect.Fish_Boss  , deadEffect=nil,                           ShakeScreen=false, iMultiple = 1, localSpeed=20 , iRadius=0,groupIds={1,},actInterval=0.1,bgActInterval=0.1,isLock=true ,isWheel=true ,gold=4 ,goldType=GoldType.Silver   , iWidth=0, iHeight=0, iSpeed=20, cacheCount=2 ,},
            [FishType.FISH_KIND_36]= {effectType=FISH_Effect.Fish_Boss  , deadEffect=nil,                           ShakeScreen=false, iMultiple = 1, localSpeed=20 , iRadius=0,groupIds={1,},actInterval=0.1,bgActInterval=0.1,isLock=true ,isWheel=true ,gold=5 ,goldType=GoldType.Silver   , iWidth=0, iHeight=0, iSpeed=20, cacheCount=2 ,},
            [FishType.FISH_KIND_37]= {effectType=FISH_Effect.Fish_Boss  , deadEffect=nil,                           ShakeScreen=false, iMultiple = 1, localSpeed=20 , iRadius=0,groupIds={1,},actInterval=0.1,bgActInterval=0.1,isLock=true ,isWheel=true ,gold=5 ,goldType=GoldType.Silver   , iWidth=0, iHeight=0, iSpeed=20, cacheCount=2 ,},
            [FishType.FISH_KIND_38]= {effectType=FISH_Effect.Fish_Boss  , deadEffect=nil,                           ShakeScreen=false, iMultiple = 1, localSpeed=20 , iRadius=0,groupIds={1,},actInterval=0.1,bgActInterval=0.1,isLock=true ,isWheel=true ,gold=5 ,goldType=GoldType.Silver   , iWidth=0, iHeight=0, iSpeed=20, cacheCount=2 ,},
            [FishType.FISH_KIND_39]= {effectType=FISH_Effect.Fish_Boss  , deadEffect=nil,                           ShakeScreen=false, iMultiple = 1, localSpeed=20 , iRadius=0,groupIds={1,},actInterval=0.1,bgActInterval=0.1,isLock=true ,isWheel=true ,gold=5 ,goldType=GoldType.Silver   , iWidth=0, iHeight=0, iSpeed=20, cacheCount=2 ,},
            [FishType.FISH_KIND_40]= {effectType=FISH_Effect.Fish_Boss  , deadEffect=nil,                           ShakeScreen=false, iMultiple = 1, localSpeed=20 , iRadius=0,groupIds={1,},actInterval=0.1,bgActInterval=0.1,isLock=true ,isWheel=true ,gold=2 ,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=2 ,},
            [FishType.FISH_KIND_41]= {effectType=FISH_Effect.Common_Fish, deadEffect=ef(BET,"FishDead","QuanPing"), ShakeScreen=true , iMultiple = 1, localSpeed=38 , iRadius=0,groupIds={5,},actInterval=0.1,bgActInterval=0.1,isLock=true ,isWheel=true ,gold=10,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=1 ,},
            [FishType.FISH_KIND_42]= {effectType=FISH_Effect.Common_Fish, deadEffect=ef(BET,"FishDead","QuanPing"), ShakeScreen=true , iMultiple = 1, localSpeed=40 , iRadius=0,groupIds={6,},actInterval=0.1,bgActInterval=0.1,isLock=true ,isWheel=true ,gold=10,goldType=GoldType.Gold     , iWidth=0, iHeight=0, iSpeed=20, cacheCount=1 ,},
        },
        FishStyleInfo = {
            [FishType.FISH_KIND_1] = {
                                            modelName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            abName = "module14/game_white_snake_fish_p1",
                                            actions = {
                                                --����
                                                --actionPos = { x = 0, y = 0, z = 0,},  --λ��
                                                move = { 
                                                    format="Fisha0_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =12,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 0, y = 0, z = 0, },
                                                        size    = { x = 65, y = 22, z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd0_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=1, --��ʼ֡����
                                                    frameCount     =5,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Null,
                                                fileName    = "",
                                                interval       =0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_2] = {
                                            modelName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            abName = "module14/game_white_snake_fish_p1",
                                            actions = {
                                                move = { 
                                                    format="Fisha1_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =16,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 0, y = 0, z = 0, },
                                                        size    = { x = 50, y = 22, z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd1_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=1, --��ʼ֡����
                                                    frameCount     =3,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Null,
                                                fileName    = "",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_3] = {
                                            modelName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            abName = "module14/game_white_snake_fish_p1",
                                            actions = {
                                                move = { 
                                                    format="Fisha2_%03d",--֡���ָ�ʽ��
                                                    customFrames={0,1,3,4,6,7,9,10,12,13,15,16,18,19,21,22}, 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =12,
                                                    frameInterval  =2, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 0, y = 1.352654, z = 0, },
                                                        size    = { x = 72, y = 44, z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd2_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=1, --��ʼ֡����
                                                    frameCount     =3,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },     
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Null,
                                                fileName    = "",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_4] = {
                                            modelName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            abName = "module14/game_white_snake_fish_p1",
                                            actions  = {
                                                move = { 
                                                    format="Fisha3_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =24,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 6.5, y = 2.14, z = 0, },
                                                        size    = { x = 92, y = 60, z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd3_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =10,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },                                                    
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Null,
                                                fileName    = "",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_5] = {
                                            modelName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            abName = "module14/game_white_snake_fish_p1",
                                            actions = {
                                                move = { 
                                                    format="Fisha4_%03d",--֡���ָ�ʽ��
                                                    customFrames={0,1,3,5,6,8,9,11,12,14,15,17,18,20,21,23},  
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =13,
                                                    frameInterval  =2, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 8, y = 0, z = 0, },
                                                        size    = { x = 90, y = 42, z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd4_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=1, --��ʼ֡����
                                                    frameCount     =3,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },                   
                                            },
                                            bg   =  {
                                                type        = FishUnderPanType.Null,
                                                fileName    = "",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_6] = {
                                            modelName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            abName = "module14/game_white_snake_fish_p1",
                                            actions = {
                                                move = { 
                                                    format="Fisha5_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =13,
                                                    frameInterval  =2, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 0,  y = 0, z = 0, },
                                                        size    = { x = 97,y = 70, z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd5_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =6,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Null,
                                                fileName    = "",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_7] = {
                                            modelName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            abName = "module14/game_white_snake_fish_p1",
                                            actions = {
                                                move = { 
                                                    format="Fisha6_%03d",--֡���ָ�ʽ��
                                                    customFrames={0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,33,34,35},  
                                                    frameBeginIndex=1, --��ʼ֡����
                                                    frameCount     =23,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 6.27,  y = 0,  z = 0, },
                                                        size    = { x = 111,   y = 54, z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd6_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=1, --��ʼ֡����
                                                    frameCount     =3,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },
                                            },
                                            bg   =  {
                                                type        = FishUnderPanType.Null,
                                                fileName    = "",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_8] = {
                                            modelName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            abName = "module14/game_white_snake_fish_p1",
                                            actions = {
                                                move = { 
                                                    format="Fisha7_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =10,
                                                    frameInterval  =2, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 0,     y = 0,  z = 0, },
                                                        size    = { x = 122,   y = 68, z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd7_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =6,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },   
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Null,
                                                fileName    = "",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_9] = {
                                            modelName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            abName = "module14/game_white_snake_fish_p1",
                                            actions = {
                                                move = { 
                                                    format="Fisha8_%03d",--֡���ָ�ʽ�� 
                                                    customFrames={0,1,3,4,6,7,9,10,12,13,15,16,18,19,21,22},
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =16,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 0,     y = 5,  z = 0, },
                                                        size    = { x = 166,   y = 63, z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd8_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =4,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Null,
                                                fileName    = "",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_10]= {
                                            modelName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            abName = "module14/game_white_snake_fish_p1",
                                            actions = {
                                                move = { 
                                                    format="Fisha9_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =16,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 0,     y = 0,   z = 0, },
                                                        size    = { x = 125,   y = 134, z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd9_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =7,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Null,
                                                fileName    = "",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_11]= {
                                            modelName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������\
                                            abName = "module14/game_white_snake_fish_p1",
                                            actions = {
                                                move = { 
                                                    format="Fisha10_%03d",--֡���ָ�ʽ�� 
                                                    customFrames={0,2,4,6,8,10,12,14,16,18,20,22,23},
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =16,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 22.5,  y = 0,   z = 0, },
                                                        size    = { x = 145,   y = 78, z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd10_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =4,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Null,
                                                fileName    = "",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_12]= {
                                            modelName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            abName = "module14/game_white_snake_fish_p1",
                                            actions = {
                                                move = { 
                                                    format="Fisha11_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =12,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 12,  y = 0,   z = 0, },
                                                        size    = { x = 137, y = 152, z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd11_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =4,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },                                        
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Null,
                                                fileName    = "",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_13]= {
                                            modelName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            abName = "module14/game_white_snake_fish_p2",
                                            actions = {
                                                move = { 
                                                    format="Fisha12_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =12,
                                                    frameInterval  =2, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 0,  y = 0,   z = 0, },
                                                        size    = { x = 203, y = 81,  z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd12_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =4,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },                                       
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Null,
                                                fileName    = "",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_14]= {
                                            modelName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            abName = "module14/game_white_snake_fish_p3",
                                            actions = {
                                                move = { 
                                                    format="Fisha13_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =10,
                                                    frameInterval  =2, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 0,  y = 0,   z = 0, },
                                                        size    = { x = 264,y = 89,  z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd13_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=1, --��ʼ֡����
                                                    frameCount     =3,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },                                        
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Null,
                                                fileName    = "",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_15]= {
                                            modelName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            abName = "module14/game_white_snake_fish_p2",
                                            actions = {
                                                move = { 
                                                    format="Fisha14_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =12,
                                                    frameInterval  =2, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 15,  y = 2,   z = 0, },
                                                        size    = { x = 151, y = 231,  z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd14_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =6,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },                                        
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Null,
                                                fileName    = "",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_16]= {
                                            modelName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            abName = "module14/game_white_snake_fish_p3",
                                            actions = {
                                                move = { 
                                                    format="Fisha15_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =24,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 25,  y = 0,   z = 0, },
                                                        size    = { x = 248, y = 129,  z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd15_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =6,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },                                        
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Null,
                                                fileName    = "",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_17]= {
                                            modelName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            abName = "module14/game_white_snake_fish_p3",
                                            actions = {
                                                move = { 
                                                    format="Fisha16_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =12,
                                                    frameInterval  =2, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 24,  y = 0,   z = 0, },
                                                        size    = { x = 251, y = 129,  z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd16_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =4,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Null,
                                                fileName    = "",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_18]= {
                                            modelName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            abName = "module14/game_white_snake_fish_p2",
                                            actions = {
                                                move = { 
                                                    format="Fisha17_%03d",--֡���ָ�ʽ��
                                                    customFrames={0,1,3,4,6,7,9,10}, 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =9,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 7.6,  y = 0,   z = 0, },
                                                        size    = { x = 295, y = 180,  z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd17_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =2,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },                                        
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Null,
                                                fileName    = "",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_19]= {
                                            modelName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            abName = "module14/game_white_snake_fish_p9",
                                            actions = {
                                                move = { 
                                                    format="Fisha18_%03d",--֡���ָ�ʽ��
                                                    customFrames={0,2,4,6,8,10,12,14,15}, 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =9,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 77.31,  y = 0,   z = 0, },
                                                        size    = { x = 306, y = 72,  z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd18_%03d",--֡���ָ�ʽ�� 
                                                    customFrames={0,2,4,5,7,9,11,13}, 
                                                    frameBeginIndex=1, --��ʼ֡����
                                                    frameCount     =4,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.28, --����ʱ����
                                                },                                        
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Null,
                                                fileName    = "",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_20]= {
                                            modelName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            abName = "module14/game_white_snake_fish_p6",
                                            actions = {
                                                move = { 
                                                    format="Fisha19_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =15,
                                                    frameInterval  =2, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 49.88,  y = 16.88,   z = 0, },
                                                        size    = { x = 130, y = 190,  z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd19_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =9,
                                                    frameInterval  =2, --֡�������
                                                    interval       =0.3, --����ʱ����
                                                },                                        
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Null,
                                                fileName    = "",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_21]= {
                                            modelName = "BossFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            abName = "module14/game_white_snake_fish_p4",
                                            actions = {
                                                move = { 
                                                    format="Fisha20",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =0,
                                                    frameInterval  =2, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 0,  y = 0,   z = 0, },
                                                        size    = { x = 150, y = 150,  z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd20_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =0,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Custom,
                                                fileName    = "Fisha20",
                                                abName = "module14/game_white_snake_fish_p4",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_22]= {
                                            modelName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            abName = "module14/game_white_snake_fish_p4",
                                            actions = {
                                                move = { 
                                                    format="Fisha21_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =8,
                                                    frameInterval  =2, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 0,  y = 0,   z = 0, },
                                                        size    = { x = 120,   y = 120,  z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd21_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =0,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },                                        
                                            },
                                            bg   =  {
                                                type        = FishUnderPanType.Null,
                                                fileName    = "",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_23]= {
                                            modelName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            abName = "module14/game_white_snake_fish_p4",
                                            actions = {
                                                move = { 
                                                    format="Fisha23_%03d",--֡���ָ�ʽ�� 
                                                    customFrames={0,2,6,8,12,14,18,20,24,26},
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =15,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 0,  y = 0,   z = 0, },
                                                        size    = { x = 220,   y = 180,  z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd23_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =0,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },                                        
                                            },
                                            bg   =  {
                                                type        = FishUnderPanType.Null,
                                                fileName    = "",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_24]= {
                                            modelName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            abName = "module14/game_white_snake_fish_p4",
                                            actions = {
                                                move = { 
                                                    format="Fisha24_%03d",--֡���ָ�ʽ�� 
                                                    customFrames={0,1,3,4,6,7,9,10,11},
                                                    frameBeginIndex=1, --��ʼ֡����
                                                    frameCount     =0,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 0,   y = 0,   z = 0, },
                                                        size    = { x = 160, y = 80,  z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd24_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =0,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Null,
                                                fileName    = "",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_25]= {
                                            modelName = "SanYuanFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Group, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            abName = "module14/game_white_snake_fish_p1",
                                            actions = {
                                                actionPos = { x = -8, y = 0, z = 0,},  --λ��
                                                scale = {0.8,0.8,0.8},
                                                move = { 
                                                    format="Fisha3_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =24,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 0,   y = 0, z = 0, },
                                                        size    = { x = 132, y = 132, z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd3_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =10,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },                                         
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Custom,
                                                fileName    = "FBk0_001",
                                                abName = "module14/game_white_snake_fish_p1",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_26]= {
                                            modelName = "SanYuanFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Group, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            abName = "module14/game_white_snake_fish_p1",
                                            actions = {
                                                actionPos = { x = -8, y = 0, z = 0,},  --λ��
                                                scale = {0.8,0.8,0.8},
                                                move = { 
                                                    format="Fisha4_%03d",--֡���ָ�ʽ�� 
                                                    customFrames= {0,1,3,5,6,8,9,11,12,14,15,17,18,20,21,23},
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =13,
                                                    frameInterval  =2, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 0, y = 0, z = 0, },
                                                        size    = { x = 132, y = 132, z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd4_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=1, --��ʼ֡����
                                                    frameCount     =3,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },  
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Custom,
                                                fileName    = "FBk0_001",
                                                abName = "module14/game_white_snake_fish_p1",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_27]= {
                                            modelName = "SanYuanFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Group, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            abName = "module14/game_white_snake_fish_p1",
                                            actions = {
                                                actionPos = { x = -14, y = 0, z = 0,},  --λ��
                                                scale = {0.8,0.8,0.8},
                                                move = { 
                                                    format="Fisha6_%03d",--֡���ָ�ʽ�� 
                                                    customFrames= {0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,33,34,35},
                                                    frameBeginIndex=1, --��ʼ֡����
                                                    frameCount     =23,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 6.27,  y = 0,  z = 0, },
                                                        size    = { x = 132,   y = 132, z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd6_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=1, --��ʼ֡����
                                                    frameCount     =3,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Custom,
                                                fileName    = "FBk0_001",
                                                abName = "module14/game_white_snake_fish_p1",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_28]= {
                                            modelName = "SiXiFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Group, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            abName = "module14/game_white_snake_fish_p1",
                                            actions = {
                                                scale = {0.8,0.8,0.8},
                                                move = { 
                                                    format="Fisha5_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =13,
                                                    frameInterval  =2, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 0,  y = 0, z = 0, },
                                                        size    = { x = 132,y = 132, z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd5_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =6,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },                                    
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Custom,
                                                fileName    = "FBk0_002",
                                                abName = "module14/game_white_snake_fish_p1",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_29]= {
                                            modelName = "SiXiFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Group, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            abName = "module14/game_white_snake_fish_p1",
                                            actions = {
                                                actionPos = { x = -5, y = -9, z = 0,},  --λ��
                                                scale = {0.8,0.8,0.8},
                                                move = { 
                                                    format="Fisha7_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =10,
                                                    frameInterval  =2, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 0,     y = 0,  z = 0, },
                                                        size    = { x = 132,   y = 132, z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd7_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =6,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                }, 
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Custom,
                                                fileName    = "FBk0_002",
                                                abName = "module14/game_white_snake_fish_p1",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_30]= {
                                            modelName = "SiXiFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Group, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                           abName = "module14/game_white_snake_fish_p1",
                                            actions = {
                                                actionPos = { x = 0, y = 0, z = 0,},  --λ��
                                                scale = {0.75,0.75,0.75},
                                                move = { 
                                                    format="Fisha9_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =16,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 0,     y = 0,   z = 0, },
                                                        size    = { x = 132,   y = 132, z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd9_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =7,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },                                       
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Custom,
                                                fileName    = "FBk0_002",
                                               abName = "module14/game_white_snake_fish_p1",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_31]= {
                                            modelName = "BossFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                           abName = "module14/game_white_snake_fish_p1",
                                            actions = {
                                                actionPos = { x = -5.8, y = 0, z = 0,},  --λ��
                                                move = { 
                                                    format="Fisha0_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =12,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 0, y = 0, z = 0, },
                                                        size    = { x = 132, y = 132, z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd0_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=1, --��ʼ֡����
                                                    frameCount     =5,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Boss,
                                                fileName    = "",
                                               abName = "module14/game_white_snake_fish_p1",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_32]= {
                                            modelName = "BossFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                           abName = "module14/game_white_snake_fish_p1",
                                            actions = {
                                                move = { 
                                                    format="Fisha1_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =16,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 0, y = 0, z = 0, },
                                                        size    = { x = 132, y = 132, z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd1_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=1, --��ʼ֡����
                                                    frameCount     =3,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Boss,
                                                fileName    = "",
                                               abName = "module14/game_white_snake_fish_p1",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_33]= {
                                            modelName = "BossFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                           abName = "module14/game_white_snake_fish_p1",
                                            actions = {
                                                move = { 
                                                    format="Fisha2_%03d",--֡���ָ�ʽ�� 
                                                    customFrames= {0,1,3,4,6,7,9,10,12,13,15,16,18,19,21,22},
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =12,
                                                    frameInterval  =2, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 0, y = 1.352654, z = 0, },
                                                        size    = { x = 132, y = 132, z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd2_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=1, --��ʼ֡����
                                                    frameCount     =3,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Boss,
                                                fileName    = "",
                                               abName = "module14/game_white_snake_fish_p1",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_34]= {
                                            modelName = "BossFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                           abName = "module14/game_white_snake_fish_p1",
                                            actions = {
                                                actionPos = { x = -12.6, y = 0, z = 0,},  --λ��
                                                move = { 
                                                    format="Fisha3_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =24,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 0, y = 0, z = 0, },
                                                        size    = { x = 132, y = 132, z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd3_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =10,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },                                        
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Boss,
                                                fileName    = "",
                                               abName = "module14/game_white_snake_fish_p1",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_35]= {
                                            modelName = "BossFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                           abName = "module14/game_white_snake_fish_p1",
                                            actions = {
                                                actionPos = { x = -4.9, y = 0, z = 0,},  --λ��
                                                move = { 
                                                    format="Fisha4_%03d",--֡���ָ�ʽ�� 
                                                    customFrames= {0,1,3,5,6,8,9,11,12,14,15,17,18,20,21,23},
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =13,
                                                    frameInterval  =2, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 0, y = 0, z = 0, },
                                                        size    = { x = 132, y = 132, z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd4_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=1, --��ʼ֡����
                                                    frameCount     =3,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },                                             
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Boss,
                                                fileName    = "",
                                               abName = "module14/game_white_snake_fish_p1",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_36]= {
                                            modelName = "BossFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                           abName = "module14/game_white_snake_fish_p1",
                                            actions = {
                                                move = { 
                                                    format="Fisha5_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =13,
                                                    frameInterval  =2, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 0,  y = 0, z = 0, },
                                                        size    = { x = 132,y = 132, z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd5_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =6,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },                                           
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Boss,
                                                fileName    = "",
                                               abName = "module14/game_white_snake_fish_p1",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_37]= {
                                            modelName = "BossFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                           abName = "module14/game_white_snake_fish_p1",
                                            actions = {
                                                actionPos = { x = -5.7, y = 0, z = 0,},  --λ��
                                                move = { 
                                                    format="Fisha6_%03d",--֡���ָ�ʽ�� 
                                                    customFrames= {0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,33,34,35},
                                                    frameBeginIndex=1, --��ʼ֡����
                                                    frameCount     =23,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 0,     y = 0,  z = 0, },
                                                        size    = { x = 132,   y = 132, z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd6_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=1, --��ʼ֡����
                                                    frameCount     =3,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },                                      
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Boss,
                                                fileName    = "",
                                               abName = "module14/game_white_snake_fish_p1",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_38]= {
                                            modelName = "BossFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                           abName = "module14/game_white_snake_fish_p1",
                                            actions = {
                                                actionPos = { x = -6.4, y = 0, z = 0,},  --λ��
                                                move = { 
                                                    format="Fisha7_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =10,
                                                    frameInterval  =2, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 0,     y = 0,  z = 0, },
                                                        size    = { x = 132,   y = 132, z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd7_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =6,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },                                      
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Boss,
                                                fileName    = "",
                                               abName = "module14/game_white_snake_fish_p1",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_39]= {
                                            modelName = "BossFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                           abName = "module14/game_white_snake_fish_p1",
                                            actions = {
                                                actionPos = { x = 7, y = 8, z = 0,},  --λ��
                                                move = { 
                                                    format="Fisha8_%03d",--֡���ָ�ʽ�� 
                                                    customFrames    = {0,1,3,4,6,7,9,10,12,13,15,16,18,19,21,22},
                                                    frameBeginIndex = 0, --��ʼ֡����
                                                    frameCount      = 16,
                                                    frameInterval   = 1, --֡�������
                                                    interval        = 0.1, --����ʱ����
                                                    boxCollider     = {
                                                        center  = { x = 0,     y = 0,  z = 0, },
                                                        size    = { x = 132,   y = 132, z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd8_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =4,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },                                     
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Boss,
                                                fileName    = "",
                                                abName = "module14/game_white_snake_fish_p1",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_40]= {
                                            modelName = "BossFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            abName = "module14/game_white_snake_fish_p1",
                                            actions = {
                                                move = { 
                                                    format="Fisha9_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =16,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 0,     y = 0,   z = 0, },
                                                        size    = { x = 132,   y = 132, z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd9_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =7,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                },
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Boss,
                                                fileName    = "",
                                               abName = "module14/game_white_snake_fish_p1",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_41]= {
                                            modelName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            abName = "module14/game_white_snake_fish_p8",
                                            actions = {
                                                actionPos = { x = -8, y = 0, z = 0,},  --λ��
                                                move = { 
                                                    format="Fisha25_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =15,
                                                    frameInterval  =2, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 60,   y = 25, z = 0, },
                                                        size    = { x = 180, y = 215, z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd25_%03d",--֡���ָ�ʽ�� 
                                                    frameBeginIndex=1, --��ʼ֡����
                                                    frameCount     =10,
                                                    frameInterval  =2, --֡�������
                                                    interval       =0.3, --����ʱ����
                                                },                                         
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Null,
                                                fileName    = "",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
            [FishType.FISH_KIND_42]= {
                                            modelName = "CommonFish",  --��Ӧ��ģ������
                                            combType  = FishCombType.Single, --�Ƿ�������ϣ�ֻ�д���Ԫ�ʹ���ϲ�ǣ�������Ŀǰ������
                                            abName = "module14/game_white_snake_fish_p7",
                                            actions = {
                                                actionPos = { x = -8, y = 0, z = 0,},  --λ��
                                                move = { 
                                                    format="Fisha26_%03d",--֡���ָ�ʽ�� 
                                                    customFrames={0,2,4,6,8,10,12,14,16,18,19},
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =15,
                                                    frameInterval  =2, --֡�������
                                                    interval       =0.1, --����ʱ����
                                                    boxCollider    = {
                                                        center  = { x = 0,   y = -42, z = 0, },
                                                        size    = { x = 214, y = 185, z = 1, },
                                                    },
                                                },
                                                dead = {
                                                    format="Fishd26_%03d",--֡���ָ�ʽ�� 
                                                    customFrames={0,2,3,5,7,9,11,13,15,17,19,20},
                                                    frameBeginIndex=0, --��ʼ֡����
                                                    frameCount     =10,
                                                    frameInterval  =1, --֡�������
                                                    interval       =0.17, --����ʱ����
                                                },                                         
                                            },

                                            bg   =  {
                                                type        = FishUnderPanType.Null,
                                                fileName    = "",
                                                interval    = 0.1, --����ʱ����
                                            },
            },
        },
    
        AnimaStyleInfo = {
            [AnimateType.Wheel] = {
                isRaycastTarget = false, --�Ƿ�����¼���Ĭ�ϲ�����
                abfileName  = "module14/game_white_snake_ui",
                format="CJ_%03d",--֡���ָ�ʽ�� 
                customFrames = {},  --�Զ���֡���� 
                frameBeginIndex=0, --��ʼ֡����
                frameCount     =10,
                frameInterval  =1, --֡�������
                frameMax       =11,
                interval       =0.05, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.FlyGold] = {
                abfileName  = "module14/game_white_snake_ui",
                format="xj_%02d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =20,
                frameInterval  =1, --֡�������
                --frameMax       =11,
                interval       =0.1, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.FlySilver] = {
                abfileName  = "module14/game_white_snake_ui",
                format="xj_%02d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =20,
                frameInterval  =1, --֡�������
                interval       =0.1, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.Net] = {
                abfileName  = "module14/game_white_snake_net",
                format="ZDWN_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=0, --��ʼ֡����
                frameCount     =9,
                frameInterval  =1, --֡�������
                interval       =0.1, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.Net_Self_2] = {
                abfileName  = "module14/game_white_snake_net",
                format="net2_2ion_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=0, --��ʼ֡����
                frameCount     =10,
                frameInterval  =1, --֡�������
                interval       =0.1, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.Net_Self_3] = {
                abfileName  = "module14/game_white_snake_net",
                format="net3_3ion_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=0, --��ʼ֡����
                frameCount     =10,
                frameInterval  =1, --֡�������
                interval       =0.1, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.Net_1] = {
                abfileName  = "module14/game_white_snake_net",
                format="net2_ion_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=0, --��ʼ֡����
                frameCount     =10,
                frameInterval  =1, --֡�������
                interval       =0.1, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.Net_2] = {
                abfileName  = "module14/game_white_snake_net",
                format="net3_ion_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=0, --��ʼ֡����
                frameCount     =10,
                frameInterval  =1, --֡�������
                interval       =0.1, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.Net_3] = {
                abfileName  = "module14/game_white_snake_net",
                format="net4_ion_%04d",--֡���ָ�ʽ�� 
                frameBeginIndex=0, --��ʼ֡����
                frameCount     =10,
                frameInterval  =1, --֡�������
                interval       =0.1, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.Water] = {
                abfileName  = "module14/game_white_snake_water",
                format="water%02d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =16,
                frameInterval  =1, --֡�������
                interval       =0.1, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.BulletSelf1] = {
                abfileName  = "module14/game_white_snake_scene",
                format="bullet2_norm9_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =2,
                frameInterval  =1, --֡�������
                interval       =0.05, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.BulletSelf2] = {
                abfileName  = "module14/game_white_snake_scene",
                format="bullet2_norm9_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =2,
                frameInterval  =1, --֡�������
                interval       =0.05, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.BulletSelf3] = {
                abfileName  = "module14/game_white_snake_scene",
                format="bullet3_norm9_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =2,
                frameInterval  =1, --֡�������
                interval       =0.05, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.BulletSelf4] = {
                abfileName  = "module14/game_white_snake_scene",
                format="bullet4_norm9_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =2,
                frameInterval  =1, --֡�������
                interval       =0.05, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.BulletOther1] = {
                abfileName  = "module14/game_white_snake_scene",
                format="bullet2_norm7_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =2,
                frameInterval  =1, --֡�������
                interval       =0.05, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.BulletOther2] = {
                abfileName  = "module14/game_white_snake_scene",
                format="bullet2_norm7_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =2,
                frameInterval  =1, --֡�������
                interval       =0.05, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.BulletOther3] = {
                abfileName  = "module14/game_white_snake_scene",
                format="bullet3_norm7_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =2,
                frameInterval  =1, --֡�������
                interval       =0.05, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.BulletOther4] = {
                abfileName  = "module14/game_white_snake_scene",
                format="bullet4_norm7_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =2,
                frameInterval  =1, --֡�������
                interval       =0.05, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.BulletEmery] = {
                abfileName  = "module14/game_white_snake_scene",
                format="bullet4_norm7_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =2,
                frameInterval  =1, --֡�������
                interval       =0.05, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.BulletEmery_1] = {
                abfileName  = "module14/game_white_snake_scene",
                format="MaxZDB_%d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =2,
                frameInterval  =1, --֡�������
                interval       =0.05, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.BulletEmery_2] = {
                abfileName  = "module14/game_white_snake_scene",
                format="MaxZDB_%d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =2,
                frameInterval  =1, --֡�������
                interval       =0.05, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.BulletEmery_3] = {
                abfileName  = "module14/game_white_snake_scene",
                format="MaxZDC_%d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =2,
                frameInterval  =1, --֡�������
                interval       =0.05, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.BulletEmery_4] = {
                abfileName  = "module14/game_white_snake_scene",
                format="MaxZDD_%d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =2,
                frameInterval  =1, --֡�������
                interval       =0.05, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.PaotaiSelf1] = {
                abfileName  = "module14/game_white_snake_ui",
                format="FourPaoD_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =3,
                frameInterval  =1, --֡�������
                interval       =0.1, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.PaotaiSelf2] = {
                abfileName  = "module14/game_white_snake_ui",
                format="PaoTongB_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =3,
                frameInterval  =1, --֡�������
                interval       =0.1, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.PaotaiSelf3] = {
                abfileName  = "module14/game_white_snake_ui",
                format="PaoTongC_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =3,
                frameInterval  =1, --֡�������
                interval       =0.1, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.PaotaiSelf4] = {
                abfileName  = "module14/game_white_snake_ui",
                format="FourPaoD_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =3,
                frameInterval  =1, --֡�������
                interval       =0.1, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.PaotaiOther2] = {
                abfileName  = "module14/game_white_snake_ui",
                format="TongB_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =3,
                frameInterval  =1, --֡�������
                interval       =0.1, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.PaotaiOther3] = {
                abfileName  = "module14/game_white_snake_ui",
                format="TongC_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =3,
                frameInterval  =1, --֡�������
                interval       =0.1, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.PaotaiOther4] = {
                abfileName  = "module14/game_white_snake_ui",
                format="PaoD_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =3,
                frameInterval  =1, --֡�������
                interval       =0.1, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.PaotaiEmery_1] = {
                abfileName  = "module14/game_white_snake_ui",
                format="pt__5-%d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =3,
                frameInterval  =1, --֡�������
                interval       =0.08, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.PaotaiEmery_2] = {
                abfileName  = "module14/game_white_snake_ui",
                format="MaxPaoTongB_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =3,
                frameInterval  =1, --֡�������
                interval       =0.08, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.PaotaiEmery_3] = {
                abfileName  = "module14/game_white_snake_ui",
                format="MaxPaoTongC_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =3,
                frameInterval  =1, --֡�������
                interval       =0.08, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.PaotaiEmery_4] = {
                abfileName  = "module14/game_white_snake_ui",
                format="MaxFourPaoD_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =3,
                frameInterval  =1, --֡�������
                interval       =0.08, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.BombEffect] = {
                abfileName  = "module14/game_white_snake_effect",
                format="kingbomb_%05d",--֡���ָ�ʽ�� 
                customFrames = {0,2,4,6,8,9,10,11},
                frameBeginIndex=0, --��ʼ֡����
                frameCount     =8,
                frameInterval  =1, --֡�������
                interval       =0.12, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },

            [AnimateType.FishDeadEffect] = {
                abfileName  = "module14/game_white_snake_effect",
                format="coinfly_%05d",--֡���ָ�ʽ�� 
                customFrames = {0,2,3,5,7,8,9,10},
                frameBeginIndex=0, --��ʼ֡����
                frameCount     =8,
                frameInterval  =1, --֡�������
                interval       =0.08, --����ʱ����
                isCorrentSize  = true, --�Ƿ���Ҫ������С
            },
            [AnimateType.LineEffect] = {
                abfileName  = "module14/game_white_snake_effect",
                format="xian_%05d",--֡���ָ�ʽ�� 
                frameBeginIndex=0, --��ʼ֡����
                frameCount     =4,
                frameInterval  =1, --֡�������
                interval       =0.05, --����ʱ����
                isCorrentSize  =true, --�Ƿ���Ҫ������С
            },
            [AnimateType.LineSourceEffect] = {
                abfileName  = "module14/game_white_snake_effect",
                format="zhe_%05d",--֡���ָ�ʽ�� 
                frameBeginIndex=0, --��ʼ֡����
                frameCount     =3,
                frameInterval  =1, --֡�������
                interval       =0.1, --����ʱ����
                isCorrentSize  =true, --�Ƿ���Ҫ������С
            },
            [AnimateType.Wave] = {
                abfileName  = "module14/game_white_snake_scene",
                format="HaiLang_%03d",--֡���ָ�ʽ�� 
                frameBeginIndex=1, --��ʼ֡����
                frameCount     =3,
                frameInterval  =1, --֡�������
                interval       =0.16, --����ʱ����
                isCorrentSize  =true, --�Ƿ���Ҫ������С
            },
            [AnimateType.Fire_2] = {
                abfileName  = "module14/game_white_snake_ui",
                format="fire_%d",  --֡���ָ�ʽ��
                frameBeginIndex=1,  --��ʼ֡����
                frameCount     =2,
                frameInterval  =1,   --֡�������  
                interval       =0.1,  --����ʱ����
                realFrameMax   =2,    --��ʵ��֡��
                isNullDefault = true, --����ҪĬ��ͼ��
                isCorrentSize  =true,  --�Ƿ���Ҫ������С
            },
            [AnimateType.Fire_3] = {
                abfileName  = "module14/game_white_snake_ui",
                format="fire_%d",  --֡���ָ�ʽ��
                frameBeginIndex=2,  --��ʼ֡����
                frameCount     =2,
                frameInterval  =1,  --֡������� 
                interval       =0.1, --����ʱ����
                realFrameMax   =3,    --��ʵ��֡��
                isNullDefault = true, --����ҪĬ��ͼ��
                isCorrentSize  =true, --�Ƿ���Ҫ������С
            },
	        [AnimateType.Fire_4] = {
                abfileName  = "module14/game_white_snake_ui",
                format="fire_%d",  --֡���ָ�ʽ��
                frameBeginIndex=4,  --��ʼ֡����
                frameCount     =2,
                frameInterval  =1,  --֡������� 
                interval       =0.1, --����ʱ����
                realFrameMax   =5,    --��ʵ��֡��
                isNullDefault = true, --����ҪĬ��ͼ��
                isCorrentSize  =true, --�Ƿ���Ҫ������С
            },
        },
    };
    self.GameConfig.NetInfo = {
        [NetType.Common]  = {
                Style       = {
                    self = { 
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.Net_1,
                    },
                    other = {
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.Net_1,
                    },
                },            
        },
        [NetType.Double]  = {
                Style       = {
                    self = { 
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.Net_2,
                    },
                    other = {
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.Net_2,
                    },
                },            
        },
        [NetType.Three]  = {
                Style       = {
                    self = { 
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.Net_3,
                    },
                    other = {
                        preType     = PrefabType.CommonBullet,
                        bodyAnima   = AnimateType.Net_3,
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
    if self._cachePool then
        local position = cobject:Position();
        local localScale    = cobject:LocalScale();
        local localRotation = cobject:LocalRotation();
        if cacheName and cacheName~=String.Empte then
            local obj  = self._cacheObjs[cacheName];
            if not obj then
                obj = GameObject.New();
                obj.name = cacheName;
                obj = obj.transform;
                obj:SetParent(self._cachePool);  
                self._cacheObjs[cacheName] = obj;
            end
            cobject:SetParent(obj);  
        else
            cobject:SetParent(self._cachePool);        
        end
        cobject:SetPosition(position);
        cobject:SetLocalScale(localScale);
        cobject:SetLocalRotation(localRotation);
        return true;
    else
        cobject:Destroy();
        return false;
    end
end

--������Ϸ��
function _CGlobalGame:CacheGO(gameObject,cacheName)
    if gameObject==nil then
        return false;
    end
    if self._cachePool then
        local localPosition = gameObject.transform.localPosition;
        local localScale    = gameObject.transform.localScale;
        local localRotation = gameObject.transform.localRotation;
        if cacheName and cacheName~=String.Empte then
            local obj  = self._cacheObjs[cacheName];
            if not obj then
                obj = GameObject.New();
                obj.name = cacheName;
                obj = obj.transform;
                obj:SetParent(self._cachePool);  
                self._cacheObjs[cacheName] = obj;
            end
            gameObject.transform:SetParent(obj);  
        else
            gameObject.transform:SetParent(self._cachePool);
        end
        gameObject.transform.localPosition = localPosition;
        gameObject.transform.localScale = localScale;
        gameObject.transform.localRotation = localRotation;
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
    if self._helpPanel then
        self._helpPanel:Update(_dt);
    end
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
        self._helpPanel = self._helpPanelCreator.Create(self._systemLayer);
        self._helpPanel:Init();
        --���´�
        --self._helpPanel:OnOpen();
    end
    self._helpPanel:OnOpen();
end


function _CGlobalGame:SwitchScreenPosToWorldPosByUICamera(pos)
    --local newPos = {x=pos.x,y=pos.y,z=z};
    --return self._uiCamera:ScreenToWorldPoint(newPos);
    local newPos  = self._uiCamera:ScreenToViewportPoint(pos);
    newPos =  self._uiCamera:ViewportToWorldPoint(newPos);
    return newPos;
    --local newPos =  self._uiCamera.WorldToViewportPoint(pos);
    --self._uiCamera.ViewportToWorldPoint()

--    local position = self._uiCamera.transform.position;
--    z = pos.z;

--    return self._uiCamera:ScreenToWorldPoint(newPos);
--    local newPos = {x=(pos.x-position.y),y=(pos.y - position.y),z=(z- position.z)};
--    if z==nil then
--        return self._uiCamera:ScreenToWorldPoint(newPos);
--    else
--        --local newPos = {x=pos.x,y=pos.y,z=z};
--        return self._uiCamera:ScreenToWorldPoint(newPos);
--    end
    --return Util.ScreenPointToWorldSpace(pos.x, pos.y, self._uiCamera, z);
end



function _CGlobalGame:InitSuccess()
--    if not self._isAsyncLoadOver then

--    end
    --�첽�������
    self._isAsyncLoadOver = true;

    if not self._isInitSuccess then
        self._isInitSuccess = true;

        --���������ǵ�UI����
        if not self._otherUI then
            --����UI����
            --���ش���
            self._otherUI = GameObject.Find("HallScenPanel");
        end
        self._otherUI:SetActive(false);

        if self._gamePanelObj then
            GameManager.PanelRister(self._gamePanelObj);
            GameManager.PanelInitSucceed(self._gamePanelObj); 
        end

        --��ʾ������
        self._canvasPanelGO:SetActive(true);
    end
end



--�첽����ϵ��
function _CGlobalGame:_asyncLoadStep1(_runTime,_data)
    --self:Init();
    --��ʼ��
    --G_GlobalGame._mainPanel:Init();
    --G_GlobalGame._mainPanel:InitSystem();
 
    self._clientSession:SendLogin();
    return true;
end

function _CGlobalGame:_asyncLoadStep2(_runTime,_data)
    --����
    return true;
end

function _CGlobalGame:_asyncLoadStep3(_runTime,_data)
    local loadGameSceneOver = function (obj)
        self._gameSceneGO = obj;
        --�����Ϸ����
        local gameSceneTrans = self._gameSceneGO.transform;
        local localScale    = gameSceneTrans.localScale;
        local localPosition = gameSceneTrans.localPosition;
        local localRotation = gameSceneTrans.localRotation;
        gameSceneTrans:SetParent(self._contentLayer);
        gameSceneTrans.localScale       = localScale;
        gameSceneTrans.localPosition    = localPosition;
        gameSceneTrans.localRotation    = localRotation;
        self._loadGameSceneSuccess = true;
    end
    self._isBeginLoadGameScene = self._isBeginLoadGameScene or false;
    self._loadGameSceneSuccess = self._loadGameSceneSuccess or false;
    if not self._isBeginLoadGameScene then
        self._isBeginLoadGameScene = true;
        self._loadGameSceneSuccess = false;
        self._gameSceneGO = self._goFactory:createGameScene(loadGameSceneOver);
    end
    
    
--    --�����Ϸ����
--    local gameSceneTrans = self._gameSceneGO.transform;
--    local localScale    = gameSceneTrans.localScale;
--    local localPosition = gameSceneTrans.localPosition;
--    local localRotation = gameSceneTrans.localRotation;
--    gameSceneTrans:SetParent(G_GlobalGame._contentLayer);
--    gameSceneTrans.localScale       = localScale;
--    gameSceneTrans.localPosition    = localPosition;
--    gameSceneTrans.localRotation    = localRotation;
    return self._loadGameSceneSuccess;
end

function _CGlobalGame:_asyncLoadStep4(_runTime,_data)
    --��Ϸ��������
    --���س���Ԫ��
    if not (self._gameSceneControl) then
        self._gameSceneControl  = GameSceneControl.New();
    end
    local gameSceneTrans = self._gameSceneGO.transform;
    local isComplete = self._gameSceneControl:AsyncInit(gameSceneTrans,_runTime,_data);
    self._canSitDown = isComplete;
    return isComplete;
end

function _CGlobalGame:_asyncLoadStep5(_runTime,_data)
    --Ԥ������Ϸ��
    return self._goFactory:AsyncPreLoad(_runTime,_data);
end

function _CGlobalGame:_asyncLoadStep6(_runTime,_data)
    --��ʼʱ��
    self._beginTickCount    = Util.TickCount;
    if self._isLoginOver then
        self._clientSession:SendSitDown();
        self._isSendSitDown = true;
    end
    return self._isSendSitDown;
end


function _CGlobalGame:_asyncLoadStep7(_runTime,_data)
    --�ȴ�������Ϣ���
    return self._isAsyncLoadOver;
end

function _CGlobalGame:AsyncLoading(_runTime,_data)
    if not self._isStartAsync then
        return false;
    end
    if self._asyncPrecent<90 then
        self._asyncPrecent = self._asyncPrecent + math.random(2,5);
    else
        self._asyncPrecent = self._asyncPrecent + 1;
    end
    local isStepOver = false;
    if self._asyncStep == 1 then
        isStepOver = self:_asyncLoadStep1(_runTime,data);
        if isStepOver then
            if self._asyncPrecent<15 then
                self._asyncPrecent = 15;
            end
        end
    elseif self._asyncStep == 2 then
        isStepOver = true;
    elseif self._asyncStep == 3 then
        isStepOver = self:_asyncLoadStep2(_runTime,data);
        if isStepOver then
            if self._asyncPrecent<35 then
                self._asyncPrecent = 35;
            end
        end
    elseif self._asyncStep == 4 then
        isStepOver = true;
    elseif self._asyncStep == 5 then
        isStepOver = self:_asyncLoadStep3(_runTime,data); 
        if isStepOver then
            if self._asyncPrecent< 50 then
                self._asyncPrecent = math.random(50,65);
            end
        end
    elseif self._asyncStep == 6 then
        isStepOver = true;
    elseif self._asyncStep == 7 then
        isStepOver = self:_asyncLoadStep4(_runTime,data);
    elseif self._asyncStep == 8 then
        isStepOver = true;
    elseif self._asyncStep == 9 then
        isStepOver = self:_asyncLoadStep5(_runTime,data); 
        if isStepOver then
            if self._asyncPrecent< 78 then
                self._asyncPrecent = math.random(78,83);
            end
        end
    elseif self._asyncStep == 10 then
        isStepOver = true;
    elseif self._asyncStep == 11 then
        isStepOver = self:_asyncLoadStep6(_runTime,data);
    elseif self._asyncStep == 12 then  
        isStepOver = true;  
    elseif self._asyncStep == 13 then
        isStepOver = self:_asyncLoadStep7(_runTime,data);  
    end
    --error("LoadStep:" .. self._asyncStep);
    if isStepOver then
        self._asyncStep = self._asyncStep + 1;
        if self._asyncStep>=14 then
            self._isStartAsync = false;
            return true,100;
        end
    end
    if self._asyncPrecent>= 100 then
        self._asyncPrecent = 99;
    end
    return false,self._asyncPrecent;
end

--�Ƿ��첽�������
function _CGlobalGame:IsAsyncLoad()
    return not self._isAsyncLoadOver;
end

function _CGlobalGame:AsyncLoadOver()
    self._isStartAsync = false;
    self._isAsyncLoadOver = true;
end

function _CGlobalGame:AsyncLoad()
    self._isAsyncLoadOver = false;
    self._isStartAsync    = false;
end

--��ʼ�첽����
function _CGlobalGame:StartAsyncLoad()
    self._isStartAsync = true;
end

--�����첽����
function _CGlobalGame:ReAsyncLoad()
    self._isStartAsync = true;
    self._isAsyncLoadOver = false;
    self._asyncStep = 11;
    self._isLoginOver      = false;
    self._isSendSitDown    = false;
end

return _CGlobalGame;