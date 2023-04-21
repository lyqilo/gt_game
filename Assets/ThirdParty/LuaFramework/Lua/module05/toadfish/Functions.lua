local fishPreSuffix="FishName_";
local matchFishName = "([0-9]+)";

local CFunctionsLibs = {};
local _globalGameConfig ;

function CFunctionsLibs.CreateFishName(_id)
    return "" .. _id;
end

--��ȡ���ID
function CFunctionsLibs.GetFishID(_name)
    --local str=string.gfind(_name, fishPreSuffix .. "([0-9]+)"); 
    local str= string.gmatch(_name,matchFishName);
    local fishId = str();
    if fishId==nil then
        return false;
    else
        return true,tonumber(fishId);
    end
end

--�ǲ�������ڵ������
function CFunctionsLibs.IsFishRootName(_name)
--    local pos =string.find(_name, fishPreSuffix, 1); 
--    return pos==1;
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
    if IsNil(gameObject) then
        return false;
    end
    return CFunctionsLibs.IsFishRootName(gameObject.name,fishPreSuffix,1);
end

--��ѯ��ĸ��ڵ�
function CFunctionsLibs.FindFishRoot(gameObject)
    if IsNil(gameObject) then
        return nil;
    end
    local ret,fishId = CFunctionsLibs.IsFishRoot(gameObject);
    if ret then
        return gameObject,fishId;
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
    return _globalGameConfig.ConstDefine.C_S_INVALID_FISH_ID;
end


--�Ƿ��������
function CFunctionsLibs.Mod_Fish_IsCanBeLock(_type)
    local fishConfig = _globalGameConfig.GameConfig.FishInfo[_type];
    if fishConfig then
        return fishConfig.isLock;
    end
    return false;
end

--�Ƿ���Ҫת��Ħ����
function CFunctionsLibs.Mod_Fish_IsNeedWheel(_type)
    local fishConfig = _globalGameConfig.GameConfig.FishInfo[_type];
    if fishConfig then
        return fishConfig.isWheel;
    end
    return false;
end

--��ȡ�ӵ�����
function CFunctionsLibs.FUNC_GetBulletMultiple(_bulletType)
    if _globalGameConfig.GameConfig.Bullet[_bulletType] then
        return _globalGameConfig.GameConfig.Bullet[_bulletType].multiple;
    else
        return nil;
    end
end

--��ȡ�ӵ�����
function CFunctionsLibs.FUNC_GetBulletTypeByMultiple(_bulletMultiple,_isEnergy)
    _isEnergy = _isEnergy or false;
    local count = _globalGameConfig.Enum_BulletType.BULLET_KIND_COUNT;
    local GameConfig = _globalGameConfig.GameConfig;
    for i=_globalGameConfig.Enum_BulletType.BULLET_KIND_1_NORMAL,count do
        if GameConfig.Bullet[i] then
            if GameConfig.Bullet[i].multiple == _bulletMultiple and  GameConfig.Bullet[i].isEnergy == _isEnergy then
                return i;
            end    
        end
    end
    return _globalGameConfig.Enum_BulletType.InvalidType;
end


--��ȡ�ӵ�����
function CFunctionsLibs.FUNC_GetBulletTypeByPaotaiType(_type)
    local info = _globalGameConfig.GameConfig.PaotaiInfo[_type];
    if info==nil then
        return _globalGameConfig.Enum_BulletType.InvalidType;
    end
    return info.BulletType;
end

--��ȡ�ӵ�kind
function CFunctionsLibs.FUNC_GetBulletKind(_type)
    local info = _globalGameConfig.GameConfig.Bullet[_type];
    if info==nil then
        return _globalGameConfig.Enum_BulletType.InvalidType;
    end
    return info.bulletKind;
end


--�õ���Ӧ��Ԥ��������
function CFunctionsLibs.FUNC_GetPrefabName(_styleType)
    local prefabInfo = _globalGameConfig.GameConfig.PrefabName[_styleType];
    if prefabInfo==nil then
        error("!!!!====> PrefabName(" .. _styleType .. ") is empty!!!!");
        return String.Empte;
    end
    return prefabInfo.prefabName;
end

--�õ���Ҷ�
function CFunctionsLibs.FUNC_GetScoreColumnPrefabName(index)
    return CFunctionsLibs.FUNC_GetPrefabName(_globalGameConfig.Enum_PrefabType.ScoreColumnRed + index)
end

--�õ���̨����������
function CFunctionsLibs.FUNC_GetPaotaiStyleInfo(_type,_isSelf)
    _isSelf = _isSelf or false;
    local info = _globalGameConfig.GameConfig.PaotaiInfo[_type];
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
    local info = _globalGameConfig.GameConfig.PaotaiInfo[_type];
    if info==nil then
        return _globalGameConfig.Enum_PrefabType.InvalidType;
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
    if styleInfo.preType == _globalGameConfig.Enum_PrefabType.InvalidType then
        error("!!!!====>Paotai PrefabName is empty!!!!");
        return String.Empte;
    end
    return CFunctionsLibs.FUNC_GetPrefabName(styleInfo.preType);
end

--�õ���̨����������
function CFunctionsLibs.FUNC_GetBulletStyleType(_type,_isSelf)
    local GlobalGame = _globalGameConfig;
    _isSelf = _isSelf or false;
    local info = GlobalGame.GameConfig.Bullet[_type];
    if info==nil then
        return GlobalGame.Enum_PrefabType.InvalidType;
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
    if styleType == _globalGameConfig.Enum_PrefabType.InvalidType then
        error("!!!!====>Bullet PrefabName is empty!!!!");
        return String.Empte;
    end
    return CFunctionsLibs.FUNC_GetPrefabName(styleType);
end

--�����ӵ����͵õ���̨����
function CFunctionsLibs.FUNC_GetPaotaiTypeByBulletType(_type)
    local info = _globalGameConfig.GameConfig.Bullet[_type];
    if not info then
        return _globalGameConfig.Enum_PaotaiType.InvalidType;
    end
    return info.paoType;
end

--��һ����
function CFunctionsLibs.FUNC_GetNextPaotai(_type)
    local info = _globalGameConfig.GameConfig.PaotaiInfo[_type];
    if not info then
        return _globalGameConfig.Enum_PaotaiType.InvalidType;
    end
    if not info.NextPao then
        return _globalGameConfig.Enum_PaotaiType.InvalidType;
    end
    return info.NextPao;
end

--��һ����
function CFunctionsLibs.FUNC_GetPrePaotai(_type)
    local info = _globalGameConfig.GameConfig.PaotaiInfo[_type];
    if not info then
        return _globalGameConfig.Enum_PaotaiType.InvalidType;
    end
    if not info.PrePao then
        return _globalGameConfig.Enum_PaotaiType.InvalidType;
    end
    return info.PrePao;
end

--������
function CFunctionsLibs.FUNC_GetUpPaotai(_type)
    local info = _globalGameConfig.GameConfig.PaotaiInfo[_type];
    if not info then
        return _globalGameConfig.Enum_PaotaiType.InvalidType;
    end
    if not info.Bigger then
        return _globalGameConfig.Enum_PaotaiType.InvalidType;
    end
    return info.Bigger;
end

--������
function CFunctionsLibs.FUNC_GetDownPaotai(_type)
    local info = _globalGameConfig.GameConfig.PaotaiInfo[_type];
    if not info then
        return _globalGameConfig.Enum_PaotaiType.InvalidType;
    end
    if not info.Smaller then
        return _globalGameConfig.Enum_PaotaiType.InvalidType;
    end
    return info.Smaller;
end

--�õ����Ԥ��������
function CFunctionsLibs.FUNC_GetFishPrefabName(_type)
    return CFunctionsLibs.FUNC_GetPrefabName(_globalGameConfig.Enum_PrefabType.FISH_KIND_1+_type);
end

--�õ�����Ŀ���Ԥ��������
function CFunctionsLibs.FUNC_GetLockTargetPrefabName(_sep)
    return CFunctionsLibs.FUNC_GetPrefabName(_globalGameConfig.Enum_PrefabType.LockTarget_1+_sep);
end

--�õ������ߵ�Ԥ��������
function CFunctionsLibs.FUNC_GetLockLinePrefabName()
    return CFunctionsLibs.FUNC_GetPrefabName(_globalGameConfig.Enum_PrefabType.LockLine);
end

--�õ����־��flag
function CFunctionsLibs.FUNC_GetLockFishFlagPrefabName(_type)
    return CFunctionsLibs.FUNC_GetPrefabName(_globalGameConfig.Enum_PrefabType.LockFishFlag_1+_type);
end

--��ȡЧ��Ԥ����
function CFunctionsLibs.FUNC_GetEffectPrefabName(_type)
    local GlobalGame = _globalGameConfig;
    if _type == GlobalGame.Enum_BombEffectType.FishDead then
        return CFunctionsLibs.FUNC_GetPrefabName(GlobalGame.Enum_PrefabType.Effect_FishDead);
    end
    if _type == GlobalGame.Enum_BombEffectType.JuBuBomb or _type == G_GlobalGame.Enum_BombEffectType.QuanPing then
        return CFunctionsLibs.FUNC_GetPrefabName(GlobalGame.Enum_PrefabType.Effect_Bomb);
    end
    if _type == GlobalGame.Enum_BombEffectType.Line then
        return CFunctionsLibs.FUNC_GetPrefabName(GlobalGame.Enum_PrefabType.Effect_Line);
    end
    return nil;
end

function CFunctionsLibs.FUNC_GetEffectAnimaType(_type)
    local GlobalGame = _globalGameConfig;
    if _type == GlobalGame.Enum_BombEffectType.FishDead then
        return GlobalGame.Enum_AnimateType.FishDeadEffect;
    end
    if _type == GlobalGame.Enum_BombEffectType.JuBuBomb or _type == GlobalGame.Enum_BombEffectType.QuanPing then
        return GlobalGame.Enum_AnimateType.BombEffect;
    end
    if _type == GlobalGame.Enum_BombEffectType.Line then
        return GlobalGame.Enum_AnimateType.LineEffect;
    end
    if _type == GlobalGame.Enum_BombEffectType.LineSource then
        return GlobalGame.Enum_AnimateType.LineSourceEffect;
    end
    return GlobalGame.Enum_AnimateType.InvalidValue;
end

--�õ���������Ϣ
function CFunctionsLibs.FUNC_GetFishStyleInfo(_type)
    return _globalGameConfig.GameConfig.FishStyleInfo[_type];
end

--�õ��ӵ��������Ϣ
function CFunctionsLibs.FUNC_GetBulletStyleInfo(_type,_isOwn)
    local bulletConfig =_globalGameConfig.GameConfig.Bullet[_type];
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
    local bulletConfig =_globalGameConfig.GameConfig.Bullet[_type];
    if bulletConfig then
        return bulletConfig.netType;
    end
    return _globalGameConfig.Enum_NetType.Invalid;
end

--�����������͵õ�����
function CFunctionsLibs.FUNC_GetNetAnimateType(_netType,_isOwner)
    _isOwner = _isOwner or false;
    if _netType == _globalGameConfig.Enum_NetType.Invalid then
        return _globalGameConfig.Enum_AnimateType.InvalidValue;
    end
    local netInfo = _globalGameConfig.GameConfig.NetInfo[_netType];
    if not netInfo then
        return _globalGameConfig.Enum_AnimateType.InvalidValue;
    end
    local data ;
    if _isOwner then
        data = netInfo.Style and netInfo.Style.self or nil;
    else
        data = netInfo.Style and netInfo.Style.other or nil;
    end
    if not data then
        return _globalGameConfig.Enum_AnimateType.InvalidValue;
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
        r=Mathf.Rad2Deg*math.atan((p2.y-p1.y)/(p2.x-p1.x));
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
        r=Mathf.Rad2Deg*math.atan((p2.y-p1.y)/(p2.x-p1.x));
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
    return _globalGameConfig.GameConfig.ShaderName[_shaderId];
end

--���ú�����ʼ��
function CFunctionsLibs.FunctionInit(_globalGame)
    _globalGameConfig = _globalGame;
end


return CFunctionsLibs;