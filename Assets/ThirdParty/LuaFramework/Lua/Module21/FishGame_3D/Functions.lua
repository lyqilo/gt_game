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



local CFunctionsLibs = {};
local _globalGameConfig =nil;
local _gcConfig=nil;
local _gcC_Fish=nil; 
local _gcC_Bullet=nil;
local _gcC_CD=nil;
local _gcC_Net=nil; 
local _gcC_PN=nil;
local _gcC_Pao=nil;  
local _gc_EBT=nil;
local _gc_EAT=nil;
local _gc_ENT=nil;
local _gc_EPNT=nil;
local _gc_EPT=nil;

local fishPreSuffix="FN";

local matchFishName=  "([0-9]+)";

function CFunctionsLibs.CreateFishName(_id)
    --return fishPreSuffix .. _id;
    return tonumber(_id);
end

--��ȡ���ID
function CFunctionsLibs.GetFishID(_name)
    --local str=string.gfind(_name, "^([0-9]+)"); 
    --return tonumber(str());
    local str= string.gmatch(_name, matchFishName);
    return tonumber(str());
end

--�ǲ�������ڵ������
function CFunctionsLibs.IsFishRootName(_name)
--    local pos =string.find(_name, fishPreSuffix, 1); 
--    return pos==1;
--    local str= string.gfind(_name, matchFishName); string.gmatch
--    local fishId = str();
    local str= string.gmatch(_name,matchFishName);
    local fishId = str();
    if fishId==nil then
        return false;
    else
        return true,tonumber(fishId);
    end
end

--�Ƿ�����ĸ��ڵ�
function CFunctionsLibs.IsFishRoot(gameObject)
--    if IsNil(gameObject) then
--        return false;
--    end
    return CFunctionsLibs.IsFishRootName(gameObject.name);
end

--��ѯ��ĸ��ڵ�
function CFunctionsLibs.FindFishRoot(gameObject)
    if IsNil(gameObject) then
        return nil;
    end
    local ret,fishId = CFunctionsLibs.IsFishRoot(gameObject);
    if ret then
        if fishId>=1000 then
            return gameObject,fishId;
        end
    end
    local parentObj = gameObject.transform.parent;
    if parentObj~=nil then
        return CFunctionsLibs.FindFishRoot(parentObj.gameObject);
    end
    return nil;
end

--�õ����ID
function CFunctionsLibs.GetFishIDByGameObject(go)
    local fishRoot,fishId = CFunctionsLibs.FindFishRoot(go);
    if fishRoot then
        return fishId;
    end
    return _gcC_CD.C_S_INVALID_FISH_ID;
end

--�Ƿ��������
function CFunctionsLibs.Mod_Fish_IsCanBeLock(_type)
    local fishConfig = _gcC_Fish[_type];
    if fishConfig then
        return fishConfig.isLock;
    end
    return false;
end

--�Ƿ���Ҫת��Ħ����
function CFunctionsLibs.Mod_Fish_IsNeedWheel(_type)
    local fishConfig = _gcC_Fish[_type];
    if fishConfig then
        return fishConfig.isWheel;
    end
    return false;
end

--��ȡ�ӵ�����
function CFunctionsLibs.FUNC_GetBulletMultiple(_bulletType)
    local bullet = _gcC_Bullet[_bulletType];
    if bullet then
        return bullet.multiple;
    else
        return nil;
    end
end

--��ȡ�ӵ�����
function CFunctionsLibs.FUNC_GetBulletTypeByMultiple(_bulletMultiple,_isEnergy)
    _isEnergy = _isEnergy or false;
    local EBT = _gc_EBT;
    local count = EBT.BULLET_KIND_COUNT;
    local Bullet = _gcC_Bullet;
    local bullet;
    for i=EBT.BULLET_KIND_1_NORMAL,count do
        bullet = Bullet[i];
        if bullet then
            if bullet.multiple == _bulletMultiple and  bullet.isEnergy == _isEnergy then
                return i;
            end    
        end
    end
    return EBT.InvalidType;
end


--��ȡ�ӵ�����
function CFunctionsLibs.FUNC_GetBulletTypeByPaotaiType(_type)
    local info = _gcC_Pao[_type];
    if info==nil then
        return _gc_EBT.InvalidType;
    end
    return info.BulletType;
end

--��ȡ�ӵ�kind
function CFunctionsLibs.FUNC_GetBulletKind(_type)
    local info = _gcC_Bullet[_type];
    if info==nil then
        return _gc_EBT.InvalidType;
    end
    return info.bulletKind;
end


--�õ���Ӧ��Ԥ��������
function CFunctionsLibs.FUNC_GetPrefabName(_styleType)
    local prefabInfo = _gcC_PN[_styleType];
    if prefabInfo==nil then
        error("!!!!====> PrefabName(" .. _styleType .. ") is empty!!!!");
        return String.Empte;
    end
    return prefabInfo.prefabName;
end

--�õ���Ҷ�
function CFunctionsLibs.FUNC_GetScoreColumnPrefabName(index)
    return CFunctionsLibs.FUNC_GetPrefabName(_gc_EPNT.ScoreColumnRed + index)
end

--�õ���̨����������
function CFunctionsLibs.FUNC_GetPaotaiStyleInfo(_type,_isSelf)
    _isSelf = _isSelf or false;
    local info = _gcC_Pao[_type];
    if info==nil then
        return nil;
    end
    local styleInfo 
    if _isSelf then
        styleInfo = info.Style.self;
    else
        styleInfo = info.Style.other;
    end
    return styleInfo;
end


function CFunctionsLibs.FUNC_GetPaotaiStyleType(_type,_isSelf)
    _isSelf = _isSelf or false;
    local info = _gcC_Pao[_type];
    if info==nil then
        return _gc_EPNT.InvalidType;
    end
    local styleType 
    if _isSelf then
        styleType = info.Style.self.preType;
    else
        styleType = info.Style.other.preType;
    end
    return styleType;
end

--�õ���̨Ԥ���������
function CFunctionsLibs.FUNC_GetPaotaiPrefabName(_type,_isSelf)
    local styleInfo = CFunctionsLibs.FUNC_GetPaotaiStyleInfo(_type,_isSelf);
    if styleInfo==nil then
        return String.Empte;
    end
    if styleInfo.preType == _gc_EPNT.InvalidType then
        error("!!!!====>Paotai PrefabName is empty!!!!");
        return String.Empte;
    end
    return CFunctionsLibs.FUNC_GetPrefabName(styleInfo.preType);
end

--�õ���̨����������
function CFunctionsLibs.FUNC_GetBulletStyleType(_type,_isSelf)
    _isSelf = _isSelf or false;
    local info = _gcC_Bullet[_type];
    if info==nil then
        return _gc_EPNT.InvalidType;
    end
    local styleType 
    if _isSelf then
        styleType = info.SelfName;
    else
        styleType = info.OtherName;
    end
    return styleType;
end

--�õ��ӵ�Ԥ���������
function CFunctionsLibs.FUNC_GetBulletPrefabName(_type,_isSelf)
    local styleType = CFunctionsLibs.FUNC_GetBulletStyleType(_type,_isSelf);
    if styleType == _gc_EPNT.InvalidType then
        error("!!!!====>Bullet PrefabName is empty!!!!");
        return String.Empte;
    end
    return CFunctionsLibs.FUNC_GetPrefabName(styleType);
end

--�����ӵ����͵õ���̨����
function CFunctionsLibs.FUNC_GetPaotaiTypeByBulletType(_type)
    local info = _gcC_Bullet[_type];
    if not info then
        return _gc_EPT.InvalidType;
    end
    return info.paoType;
end

--��һ����
function CFunctionsLibs.FUNC_GetNextPaotai(_type)
    local info = _gcC_Pao[_type];
    if not info then
        return _gc_EPT.InvalidType;
    end
    if not info.NextPao then
        return _gc_EPT.InvalidType;
    end
    return info.NextPao;
end

--��һ����
function CFunctionsLibs.FUNC_GetPrePaotai(_type)
    local info = _gcC_Pao[_type];
    if not info then
        return _gc_EPT.InvalidType;
    end
    if not info.PrePao then
        return _gc_EPT.InvalidType;
    end
    return info.PrePao;
end

--������
function CFunctionsLibs.FUNC_GetUpPaotai(_type)
    local info = _gcC_Pao[_type];
    if not info then
        return _gc_EPT.InvalidType;
    end
    if not info.Bigger then
        return _gc_EPT.InvalidType;
    end
    return info.Bigger;
end

--������
function CFunctionsLibs.FUNC_GetDownPaotai(_type)
    local info = _gcC_Pao[_type];
    if not info then
        return _gc_EPT.InvalidType;
    end
    if not info.Smaller then
        return _gc_EPT.InvalidType;
    end
    return info.Smaller;
end

--�õ����Ԥ��������
function CFunctionsLibs.FUNC_GetFishPrefabName(_type)
    return CFunctionsLibs.FUNC_GetPrefabName(_gc_EPNT.FISH_KIND_1+_type);
end

--�õ�����Ŀ���Ԥ��������
function CFunctionsLibs.FUNC_GetLockTargetPrefabName(_sep)
    return CFunctionsLibs.FUNC_GetPrefabName(_gc_EPNT.LockTarget_1+_sep);
end

--�õ������ߵ�Ԥ��������
function CFunctionsLibs.FUNC_GetLockLinePrefabName()
    return CFunctionsLibs.FUNC_GetPrefabName(_gc_EPNT.LockLine);
end

--�õ����־��flag
function CFunctionsLibs.FUNC_GetLockFishFlagPrefabName(_type)
    return CFunctionsLibs.FUNC_GetPrefabName(_gc_EPNT.LockFishFlag_1+_type);
end

--��ȡЧ��Ԥ����
function CFunctionsLibs.FUNC_GetEffectPrefabName(_type,_isOwner)
    local EFT = _globalGameConfig.Enum_EffectType;
    if _type == EFT.BeatMyFish then
        return CFunctionsLibs.FUNC_GetPrefabName(_gc_EPNT.Effect_MyBeat);
    end
    if _type == EFT.FishKingDead then
        return CFunctionsLibs.FUNC_GetPrefabName(_gc_EPNT.Effect_FishKingDead);
    end
    if _type == EFT.SmallFishDead then
        return CFunctionsLibs.FUNC_GetPrefabName(_gc_EPNT.Effect_SmallFishDead);
    end
    if _type == EFT.BeatFish then
        --����Ч��
        --[[
        if _isOwner then
            return CFunctionsLibs.FUNC_GetPrefabName(GlobalGame.Enum_PrefabType.Effect_MyBeat);
        else
            return CFunctionsLibs.FUNC_GetPrefabName(GlobalGame.Enum_PrefabType.Effect_Beat);
        end
        --]]
        return CFunctionsLibs.FUNC_GetPrefabName(_gc_EPNT.Effect_Beat);
    end
    if _type == EFT.FishDead then
        --��������
        return CFunctionsLibs.FUNC_GetPrefabName(_gc_EPNT.Effect_FishDead);
    end
    if _type == EFT.PauseScreen then
        ---����Ч��
        return CFunctionsLibs.FUNC_GetPrefabName(_gc_EPNT.Effect_PauseScreen);
    end
    if _type == EFT.DingPing then
        --����������
        return CFunctionsLibs.FUNC_GetPrefabName(_gc_EPNT.Effect_BingGuiDead);
    end
    if _type == EFT.JuBuBomb then
        --�ֲ�ը����ը
        return CFunctionsLibs.FUNC_GetPrefabName(_gc_EPNT.Effect_Jubu);
    end
    if _type == EFT.QuanPing then
        --ȫ��ը��
        return CFunctionsLibs.FUNC_GetPrefabName(_gc_EPNT.Effect_Bomb);
    end
    if _type == EFT.Line then
        --������Ч
        return CFunctionsLibs.FUNC_GetPrefabName(_gc_EPNT.Effect_Line);
    end
    return nil;
end

function CFunctionsLibs.FUNC_GetEffectAnimaType(_type)
--    if _type == GlobalGame.Enum_EffectType.FishDead then
--        return GlobalGame.Enum_AnimateType.FishDeadEffect;
--    end
--    if _type == GlobalGame.Enum_EffectType.JuBuBomb or _type == GlobalGame.Enum_EffectType.QuanPing then
--        return GlobalGame.Enum_AnimateType.BombEffect;
--    end
--    if _type == GlobalGame.Enum_EffectType.Line then
--        return GlobalGame.Enum_AnimateType.LineEffect;
--    end
--    if _type == GlobalGame.Enum_EffectType.LineSource then
--        return GlobalGame.Enum_AnimateType.LineSourceEffect;
--    end
    return _gc_EAT.InvalidValue;
end

--�õ���������Ϣ
function CFunctionsLibs.FUNC_GetFishStyleInfo(_type)
    return _gcConfig.FishStyleInfo[_type];
end

--UI�����Ϣ
function CFunctionsLibs.FUNC_GetFishUIStyleInfo(_type)
    return _gcConfig.UIFishStyleInfo[_type];
end

--�õ��ӵ��������Ϣ
function CFunctionsLibs.FUNC_GetBulletStyleInfo(_type,_isOwn)
    local bulletConfig =_gcC_Bullet[_type];
    if bulletConfig  and bulletConfig.Style then
        if _isOwn then
            return bulletConfig.Style.self;
        else
            return bulletConfig.Style.other; 
        end
    end
    return nil;
end

--�����ӵ����ͣ��õ���������
function CFunctionsLibs.FUNC_GetNetType(_bulletType)
    local bulletConfig = _gcC_Bullet[_type];
    if bulletConfig then
        return bulletConfig.netType;
    end
    return _gc_ENT.Invalid;
end

--�����������͵õ�����
function CFunctionsLibs.FUNC_GetNetAnimateType(_netType,_isOwner)
    _isOwner = _isOwner or false;
    if _netType == _gc_ENT.Invalid then
        return _gc_EAT.InvalidValue;
    end
    local netInfo = _gcC_Net[_netType];
    if not netInfo then
        return _gc_EAT.InvalidValue;
    end
    local data ;
    if _isOwner then
        data = netInfo.Style and netInfo.Style.self or nil;
    else
        data = netInfo.Style and netInfo.Style.other or nil;
    end
    if not data then
        return _gc_EAT.InvalidValue;
    end
    return data.bodyAnima;
end

--����Ƕ�
function CFunctionsLibs.FUNC_GetEulerAngle(p1,p2)
    local r
    if p1.x==p2.x then
        if p1.y>p2.y then
            r=0;
        elseif p1.y<p2.y then
            r=180;
        else
            r=0;
        end
    else
        r=MATH_RAD2DEG*MATH_ATAN((p2.y-p1.y)/(p2.x-p1.x));
    end
    if (p2.x-p1.x)<=0 then r=90+r else r=r-90 end
    return r;
end

--����Ƕ�
function CFunctionsLibs.FUNC_GetEulerAngleByLevel(p1,p2)
    local r
    if p1.y == p2.y then
        if p1.x<=p2.x then
            r = 0;
        else
            r = 180;
        end
    else
        r= MATH_RAD2DEG * MATH_ATAN((p2.y-p1.y)/(p2.x-p1.x));
        if p2.x>=p1.x then
        else
            r = r + 180;
        end
    end
    return r;
end

--��Ӷ���
function CFunctionsLibs.FUNC_AddAnimate(_go,_animateType)
    return _globalGameConfig._animaTool:AddAnima(_go,_animateType);
end

--������Ϸ��
function CFunctionsLibs.FUNC_CacheGO(_go,_cacheName)
    _globalGameConfig:CacheGO(_go,_cacheName);
end

--���shader������
function CFunctionsLibs.FUNC_GetShaderName(_shaderId)
    return _gcConfig.ShaderName[_shaderId];
end

--���ú�����ʼ��
function CFunctionsLibs.FunctionInit(_globalGame)
    _globalGameConfig = _globalGame;
    _gcConfig = _globalGameConfig.GameConfig;
    _gcC_Fish = _gcConfig.FishInfo; 
    _gcC_Bullet = _gcConfig.Bullet;
    _gcC_CD     = _globalGame.ConstDefine;
    _gcC_Net    = _gcConfig.NetInfo;
    _gcC_PN     = _gcConfig.PrefabName;
    _gcC_Pao    = _gcConfig.PaotaiInfo; 
    _gc_EBT     = _globalGameConfig.Enum_BulletType;
    _gc_ENT     = _globalGameConfig.Enum_NetType;
    _gc_EAT     = _globalGameConfig.Enum_AnimateType;
    _gc_EPNT    = _globalGameConfig.Enum_PrefabType;
    _gc_EPT     = _globalGameConfig.Enum_PaotaiType;
end

--�ݹ����
function CFunctionsLibs.SetGameObjectsLayer(go,layer)
    local transform = go.transform;
    local childCount = transform.childCount;
    go.layer = layer;
    local child;
    if childCount==0 then
        return ;
    end
    for i=1,childCount do
        child = transform:GetChild(i-1);
        --�ݹ����
        CFunctionsLibs.SetGameObjectsLayer(child.gameObject,layer);
    end
end

function CFunctionsLibs.FloatEqules(a,b)
    if MATH_ABS(a -b) <1e-6 then
        return true;
    end
    return false;
end
local bit={data32={}}
for i=1,32 do
    bit.data32[i]=2^(32-i)
end

function bit:d2b(arg)
    local   tr={}
    for i=1,32 do
        if arg >= self.data32[i] then
        tr[i]=1
        arg=arg-self.data32[i]
        else
        tr[i]=0
        end
    end
    return   tr
end   --bit:d2b

function    bit:b2d(arg)
    local   nr=0
    for i=1,32 do
        if arg[i] ==1 then
        nr=nr+2^(32-i)
        end
    end
    return  nr
end   --bit:b2d

function    bit:_xor(a,b)
    local   op1=self:d2b(a)
    local   op2=self:d2b(b)
    local   r={}

    for i=1,32 do
        if op1[i]==op2[i] then
            r[i]=0
        else
            r[i]=1
        end
    end
    return  self:b2d(r)
end --bit:xor

function    bit:_and(a,b)
    local   op1=self:d2b(a)
    local   op2=self:d2b(b)
    local   r={}
    
    for i=1,32 do
        if op1[i]==1 and op2[i]==1  then
            r[i]=1
        else
            r[i]=0
        end
    end
    return  self:b2d(r)
    
end --bit:_and

function bit:_or(a,b)
    local   op1=self:d2b(a)
    local   op2=self:d2b(b)
    local   r={}
    
    for i=1,32 do
        if  op1[i]==1 or   op2[i]==1   then
            r[i]=1
        else
            r[i]=0
        end
    end
    return  self:b2d(r)
end --bit:_or

function    bit:_not(a)
    local   op1=self:d2b(a)
    local   r={}

    for i=1,32 do
        if  op1[i]==1   then
            r[i]=0
        else
            r[i]=1
        end
    end
    return  self:b2d(r)
end --bit:_not

function    bit:_rshift(a,n)
    local   op1=self:d2b(a)
    local   r=self:d2b(0)
    
    if n < 32 and n > 0 then
        for i=1,n do
            for i=31,1,-1 do
                op1[i+1]=op1[i]
            end
            op1[1]=0
        end
    r=op1
    end
    return  self:b2d(r)
end --bit:_rshift

function    bit:_lshift(a,n)
    local   op1=self:d2b(a)
    local   r=self:d2b(0)
    
    if n < 32 and n > 0 then
        for i=1,n   do
            for i=1,31 do
                op1[i]=op1[i+1]
            end
            op1[32]=0
        end
    r=op1
    end
    return  self:b2d(r)
end --bit:_lshift


function    bit:print(ta)
    local   sr=""
    for i=1,32 do
        sr=sr..ta[i]
    end
    print(sr)
end

CFunctionsLibs.Bit = bit;

return CFunctionsLibs;