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

local G_GlobalGame_EventID                              = G_GlobalGame_EventID                             
local G_GlobalGame_KeyValue                             = G_GlobalGame_KeyValue                            
local G_GlobalGame_GameConfig                           = G_GlobalGame_GameConfig                          
local G_GlobalGame_GameConfig_FishInfo                  = G_GlobalGame_GameConfig_FishInfo                 
local G_GlobalGame_GameConfig_Bullet                    = G_GlobalGame_GameConfig_Bullet                   
local G_GlobalGame_GameConfig_SceneConfig               = G_GlobalGame_GameConfig_SceneConfig              
local G_GlobalGame_GameConfig_AnimaStyleInfo            = G_GlobalGame_GameConfig_AnimaStyleInfo           
local G_GlobalGame_Enum_FishType                        = G_GlobalGame_Enum_FishType                       
local G_GlobalGame_Enum_FISH_Effect                     = G_GlobalGame_Enum_FISH_Effect                    
local G_GlobalGame_Enum_GoldType                        = G_GlobalGame_Enum_GoldType                       
local G_GlobalGame_Enum_EffectType                      = G_GlobalGame_Enum_EffectType                     
local G_GlobalGame_SoundDefine                          = G_GlobalGame_SoundDefine                         
local G_GlobalGame_ConstDefine                          = G_GlobalGame_ConstDefine                         
local G_GlobalGame_FunctionsLib                         = G_GlobalGame_FunctionsLib                        
local G_GlobalGame_FunctionsLib_FUNC_GetPrefabName      = G_GlobalGame_FunctionsLib_FUNC_GetPrefabName     
local G_GlobalGame_FunctionsLib_FUNC_CacheGO            = G_GlobalGame_FunctionsLib_FUNC_CacheGO           
local G_GlobalGame_FunctionsLib_FUNC_AddAnimate         = G_GlobalGame_FunctionsLib_FUNC_AddAnimate        
local G_GlobalGame_FunctionsLib_FUNC_GetFishPrefabName  = G_GlobalGame_FunctionsLib_FUNC_GetFishPrefabName 
local G_GlobalGame_FunctionsLib_FUNC_GetFishStyleInfo   = G_GlobalGame_FunctionsLib_FUNC_GetFishStyleInfo  
local G_GlobalGame_FunctionsLib_GetFishIDByGameObject   = G_GlobalGame_FunctionsLib_GetFishIDByGameObject  
local G_GlobalGame_FunctionsLib_FUNC_GetEulerAngle      = G_GlobalGame_FunctionsLib_FUNC_GetEulerAngle 
local G_GlobalGame_FunctionsLib_CreateFishName          = G_GlobalGame_FunctionsLib_CreateFishName

local CEventObject=GameRequire("EventObject");

--local _CGroupFish = class("_CGroupFish");
local _CGroupFish = class();

function _CGroupFish:ctor(_fishObj)
    self._fishObj   = _fishObj;
end 

function _CGroupFish:Fish()
    return self._fishObj;
end

function _CGroupFish:FishID()
    return self._fishObj:FishID();
end



--local _CFishGroup = class("_CFishGroup",CEventObject);
local _CFishGroup = class(nil,CEventObject);

function _CFishGroup:ctor(_fishCreator,_existTime)
    _CFishGroup.super.ctor(self);
    self._fishCreator = _fishCreator;
    self._fishMap    = {
        nil,nil,nil,nil,nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,nil,nil,nil,nil,
        nil,nil,nil,nil,nil,nil,nil,nil,nil,};
    self._existTime = _existTime or 9999999999; --����ʱ��
    self._isTimeOut = false;

    self._realStart = false;
    self._asyncCreateFish = false;
    self._asyncCreateCount= 0;
    self._fishGroupData   = nil;
    self._recountAsyncIndex = 0;
    self._fishCount = 0;
end

--������
function _CFishGroup:CreateFish(_type,_id)
    local fish = self._fishCreator(_type,_id,nil,G_GlobalGame.Enum_FISH_FLAG.YC_Fish);
    fish:Init();
    return fish;
end

function _CFishGroup:Init(_fishGroupData)
    self._fishGroupData   = _fishGroupData;
end

function _CFishGroup:AsyncInit(_parent,_fishGroupData)
    --collectgarbage("collect");
    --collectgarbage("stop");
    self._asyncCreateFish = true;
    self._fishGroupData   = _fishGroupData;
    self._asyncCreateCount= 0;
end

--��ʽ��ʼ
function _CFishGroup:RealStart()
    self._realStart = true;
    self.gameObject:SetActive(true);
    self:AsyncCreateLeftFish();
    self._asyncCreateFish = false;
    --self._fishGroupData   = nil;
end


function _CFishGroup:AsyncUpdate(_dt)
    self._recountAsyncIndex = self._recountAsyncIndex + 1;
    if self._recountAsyncIndex%2==0 then
        self:AsyncCreateFish(_dt);
    end
end

function _CFishGroup:AsyncCreateFish(_dt)
    
end

--��������ʣ���
function _CFishGroup:AsyncCreateLeftFish()

end

function _CFishGroup:IsRealStart()
    return self._realStart;
end

function _CFishGroup:Update(_dt)
    if self._isTimeOut then
        return ;
    end
    self._existTime = self._existTime - _dt;
    if self._existTime <0 then
        self._isTimeOut = true;
        self:OnTimeOut();
    else

    end
end



function _CFishGroup:IsTimeOut()
    return self._isTimeOut;
end

--�㳱ʱ�䵽
function _CFishGroup:OnTimeOut()
    self:SendEvent(G_GlobalGame_EventID.NotifyFishGroupOver);
end

function _CFishGroup:OnFishEvent(_eventId,_fish)
    if (_eventId==G_GlobalGame_EventID.FishDead or _eventId == G_GlobalGame_EventID.FishLeaveScreen or _eventId == G_GlobalGame_EventID.FishDie) then
    else
        return;
    end
    if _eventId==G_GlobalGame_EventID.FishDead then
        _fish:SetParentBySame(self.transform.parent);
    end
    if (_eventId==G_GlobalGame_EventID.FishDead)  then
        local _fishId = _fish:FishID();
        --ɾ����
        local _groupFish = self:GetFish(_fishId);
        if _groupFish then
            self:OnFishDead(_groupFish,_fishId);
        end
    elseif(_eventId == G_GlobalGame_EventID.FishLeaveScreen) then
        local _fishId = _fish:FishID();
        local _groupFish  = self:GetFish(_fishId);
        if _groupFish then
            if self:OnFishLeaveScreen(_groupFish,_fishId) then
                self:RemoveFish(_fishId);
            end
        end
    elseif (_eventId == G_GlobalGame_EventID.FishDie) then
        local _fishId = _fish:FishID();
        local _groupFish = self:RemoveFish(_fishId);
        if _groupFish then
            self:OnFishDisappear(_groupFish,_fishId);
        end
    end
    if (_eventId==G_GlobalGame_EventID.FishDie or _eventId == G_GlobalGame_EventID.FishLeaveScreen)  then
        if self:IsOver() then
            --֪ͨ�㳱����
            self:SendEvent(G_GlobalGame_EventID.NotifyFishGroupOver);
            --self:Destroy();
        end   
    end
end

--�����������������д�ķ���
function _CFishGroup:OnFishDead(_fish,_fishId)
    return true;
end

--����ʧ�����������д�ķ���
function _CFishGroup:OnFishDisappear(_fish,_fishId)
    return true;
end

--�뿪��Ļ
function _CFishGroup:OnFishLeaveScreen(_fish,_fishId)
    return true;
end

--���������д
function _CFishGroup:IsOver()
    return self._fishCount==0;
end

function _CFishGroup:RemoveFish(_id)
    local fish = self._fishMap[_id];
    if fish then
        self._fishMap[_id] = nil;
        self._fishCount = self._fishCount - 1;
        return fish;
    end
    return fish;
end

function _CFishGroup:AddFish(_fish)
    if self._fishMap[_fish:FishID()] then
        return ;
    end
    self._fishMap[_fish:FishID()] = _fish;
    self._fishCount = self._fishCount + 1;
end

function _CFishGroup:GetFish(_id)
    return self._fishMap[_id];
end



local FishState = {
    WaitForMove     = 0, --�ȴ�����
    MoveToMid       = 1, --�ƶ��м�λ��
    WaitForMoveOut  = 2, --�ȴ��Ƴ���Ļ
    MoveOut         = 3, --�Ƴ���Ļ
};

local C_S_ArmyGroup_FishMid_Y = -1.6;

--local _CFishArmySmallFish = class("_CFishArmySmallFish");
local _CFishArmySmallFish = class();

function _CFishArmySmallFish:ctor(_fish,_waitTime)
    self._fish = _fish;
    self._waitTime = _waitTime;
    self._fishState= FishState.WaitForMove;
    self._midY     = C_S_ArmyGroup_FishMid_Y;
    self._moveSpeed = 0.8;
    --self._moveSpeed = 300;
    self._beginPos = nil;
    self._moveTime = 0;
end

function _CFishArmySmallFish:Update(_dt)
    if self._fishState == FishState.WaitForMove then
        --�ȴ�����
        self._waitTime = self._waitTime - _dt;
        if self._waitTime <=0 then
            self._fishState = FishState.MoveToMid;
            self._beginPos = self._fish:LocalPosition();
            self._moveTime = 0 - self._waitTime;
        end
    elseif self._fishState == FishState.MoveToMid then
        self._moveTime = self._moveTime + _dt;
        local y = self._moveSpeed * self._moveTime;
        local endY = self._beginPos.y + y;
        local endX = self._beginPos.x;
        if endY>=self._midY  then
            endY = self._midY;
            --�ȴ��Ƴ���Ļ
            self._fishState = FishState.WaitForMoveOut;
        end
        V_Vector3_Value.x = endX;
        V_Vector3_Value.y = endY;
        V_Vector3_Value.z = 0;
        self._fish:SetLocalPosition(V_Vector3_Value);
    elseif self._fishState == FishState.WaitForMoveOut then
        --�ȴ��Ƴ���Ļ��ʲôҲ����
    elseif self._fishState == FishState.MoveOut then
        --�����Ƴ���Ļ
        self._moveTime = self._moveTime + _dt;
        local y = self._moveSpeed * self._moveTime;
        V_Vector3_Value.x = self._beginPos.x;
        V_Vector3_Value.y = self._beginPos.y + y;
        V_Vector3_Value.z = 0;
        self._fish:SetLocalPosition(V_Vector3_Value);
    end
end

--�뿪��Ļ
function _CFishArmySmallFish:FishLeaveScreen()
    if self._fishState == FishState.WaitForMoveOut then
        self._moveTime = 0;
        self._moveSpeed  = 0.6;
        self._fishState = FishState.MoveOut;
        self._beginPos = self._fish:LocalPosition();
    end
end

--local _CFishArmyBossFish = class("_CFishGroup2BossFish");
local _CFishArmyBossFish = class();
function _CFishArmyBossFish:ctor(_fish,_toward)
    self._fish = _fish;
end


--local _CFishArmyGroup = class("_CFishArmyGroup",_CFishGroup);
local _CFishArmyGroup = class(nil,_CFishGroup);

function _CFishArmyGroup:ctor(_fishCreator)
    _CFishArmyGroup.super.ctor(self,_fishCreator,50);

    self.groups   = {};

    --С��Ⱥ
    self._smallFishGroups = {};

    self._bossFishGroups = {};
    self._bossFishGroups[1] = {};
    self._bossFishGroups[2] = {};
    
    --��ʼ�ƶ���λ��
    self._smallFishMoveBeginY = C_S_ArmyGroup_FishMid_Y - 1.9; --3.5

    --������Ⱥ�ķ�ʽ�ƶ�
    self._groupMinCount  = 3;
    self._groupMaxCount  = 10;

    --��Ⱥ����
    self._maxWaitTime    = 3.5;
    --self._maxWaitTime    = 1;
    self._groupWaitTime  = 0.6;

    --boss��Ⱥ
    self._bossFishMap  = {};

    --ˮƽ�ƶ��ȴ�ʱ��
    self._horizontalWaitTime  = 8;
    --self._horizontalWaitTime  = 3;
    --ˮƽ�ƶ��ٶ�
    self._horizontalMoveSpeed = 0.7;
    --self._horizontalMoveSpeed = 800;
    --ˮƽ�ƶ����
    self._horizontalMoveTime  = 32;
    --�Ѿ��ƶ��˶��
    self._horizontalHaveMoveTime =0;
    --ˮƽ����
    self._horizontalDistances = {1,1,1,1.2,1.2,1.1,1.1,1.1,1.2,1.4};
    --�Ƿ�ʼ�ƶ�ˮƽ��
    self._isMoveHorizontal  = false;
    --�Ƿ��ƶ�С��
    self._isMoveSmallFish   = false;
    --ˮƽ��Y����
    self._horizontalY     = 0;

    --���������п��
    self._fishSortWidth   =9.3;

    --ˮƽ����
    self._horizontalLen = 0.5;
end

--�㳱2
function _CFishArmyGroup:Init(_parent,_fishGroupData)
    self.gameObject = GAMEOBJECT_NEW();
    --self.gameObject.name = "FishArmyGroup";
    self.transform  = self.gameObject.transform;
    self.transform:SetParent(_parent);
    self.transform.localScale = C_Vector3_One;
    self.transform.localPosition = C_Vector3_Zero;
    self.transform.localRotation= C_Quaternion_Zero;

    local gameObject,transform;

    --���϶��µ���
    self.groups[1] = {};
    gameObject = GAMEOBJECT_NEW();
    transform = gameObject.transform;
    transform:SetParent(self.transform);
    transform.localScale = C_Vector3_One;
    transform.localPosition = C_Vector3_Zero;
    V_Vector3_Value.x = 0;
    V_Vector3_Value.y = 0;
    V_Vector3_Value.z = 180;
    transform.localEulerAngles = V_Vector3_Value;
    --gameObject.name = "FromUp";
    self.groups[1].transform = transform;
    self.groups[1].gameObject = gameObject;
    self.groups[1].circles  = {};

    --���¶��ϵ���
    self.groups[2] = {};
    gameObject = GAMEOBJECT_NEW();
    transform = gameObject.transform;
    transform:SetParent(self.transform);
    transform.localScale = C_Vector3_One;
    transform.localPosition = C_Vector3_Zero;
    transform.localRotation = C_Quaternion_Zero;
    --gameObject.name = "FromDown";
    self.groups[2].transform = transform;
    self.groups[2].gameObject = gameObject;
    self.groups[2].circles  = {};

     --ÿ�������ٸ�
    local count;
    local groupPart;
    local circles
    local group;
    local fishData;
    local fishObj;
    local angle;
    local hudu;
    local x,y;
    local r;
    local initRotaion;
    local angleIndex;

    local dis ;
    local groupCount=0;
    local groupTime = 0;
    local waitTime =0 ;
    local smallFishItem = nil;
    local beginX = 0;

    local width = self._fishSortWidth;

    group = self.groups[1];
    gameObject = GAMEOBJECT_NEW();
    --gameObject.name = "SmallFish Group 1";
    transform = gameObject.transform;
    transform:SetParent(group.transform);
    transform.localScale = C_Vector3_One;
    transform.localPosition = C_Vector3_Zero;
    transform.localRotation = C_Quaternion_Zero;

    groupPart = _fishGroupData.fishGroupParts[2];

    dis = width/groupPart.fishCount;
    beginX  = -width/2;
    x = beginX;
    y = self._smallFishMoveBeginY;
    local SMN = _CFishArmySmallFish.New;
    for j=1,groupPart.fishCount do
        if groupCount==0 then
            groupCount = math.random(self._groupMinCount,self._groupMaxCount);
            groupTime = math.random(0,self._maxWaitTime*100);
        end
        groupCount = groupCount - 1;
        fishData = groupPart.fishes[j];
        fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
        waitTime = math.random(groupTime,groupTime + self._groupWaitTime*100);
        smallFishItem = SMN(fishObj,waitTime/100);
        --�����б�
        self._smallFishGroups[fishData.fishId]=smallFishItem;
        x = x + dis;
        fishObj:SetParent(transform);
        V_Vector3_Value.x = x;
        V_Vector3_Value.y = y;
        V_Vector3_Value.z = 0;
        fishObj:SetLocalPosition(V_Vector3_Value);
        V_Vector3_Value.x = 0;
        V_Vector3_Value.y = 0;
        V_Vector3_Value.z = 90;
        fishObj:SetLocalEulerAngles(V_Vector3_Value);
        self:AddFish(fishObj);
        fishObj:RegEvent(self,self.OnFishEvent);
    end

    group = self.groups[2];
    gameObject = GAMEOBJECT_NEW();
    --gameObject.name = "SmallFish Group 2";
    transform = gameObject.transform;
    transform:SetParent(group.transform);
    transform.localScale = C_Vector3_One;
    transform.localPosition = C_Vector3_Zero;
    transform.localRotation = C_Quaternion_Zero;

    groupPart = _fishGroupData.fishGroupParts[4];

    dis = width/groupPart.fishCount;
    beginX  = - width/2;
    x = beginX;
    y = self._smallFishMoveBeginY;
    for j=1,groupPart.fishCount do
        if groupCount==0 then
            groupCount = math.random(self._groupMinCount,self._groupMaxCount);
            groupTime = math.random(0,self._maxWaitTime*100);
        end
        groupCount = groupCount - 1;
        fishData = groupPart.fishes[j];
        fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
        waitTime = math.random(groupTime,groupTime + self._groupWaitTime*100);
        smallFishItem = SMN(fishObj,waitTime/100);
        --�����б�
        self._smallFishGroups[fishData.fishId]=smallFishItem;
        x = x + dis;
        fishObj:SetParent(transform);
        V_Vector3_Value.x = x;
        V_Vector3_Value.y = y;
        V_Vector3_Value.z = 0;
        fishObj:SetLocalPosition(V_Vector3_Value);
        V_Vector3_Value.x = 0;
        V_Vector3_Value.y = 0;
        V_Vector3_Value.z = 90;
        fishObj:SetLocalEulerAngles(V_Vector3_Value);
        self:AddFish(fishObj);
        fishObj:RegEvent(self,self.OnFishEvent);
    end
    
    --boss��
    group = self.groups[1];
    gameObject = GAMEOBJECT_NEW();
    --gameObject.name = "BossFish Group 1";
    transform = gameObject.transform;
    transform:SetParent(group.transform);
    transform.localScale = C_Vector3_One;
    transform.localPosition = C_Vector3_Zero;
    transform.localRotation = C_Quaternion_Zero;
    self._bossFishGroups[1].transform = transform;
    self._bossFishGroups[1].gameObject = gameObject;

    groupPart = _fishGroupData.fishGroupParts[1];
    beginX  = - width/2 - self._horizontalLen;
    x = beginX;
    y = self._horizontalY;

    for j=1,groupPart.fishCount do
        fishData = groupPart.fishes[j];
        fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
        x = x - self._horizontalDistances[j];
        fishObj:SetParent(transform);
        V_Vector3_Value.x = x;
        V_Vector3_Value.y = y;
        V_Vector3_Value.z = 0;
        fishObj:SetLocalPosition(V_Vector3_Value);
        fishObj:SetLocalRotation(C_Quaternion_Zero);
        self:AddFish(fishObj);
        fishObj:RegEvent(self,self.OnFishEvent);  
        self._bossFishMap[fishData.fishId]=fishObj;  
    end


    group = self.groups[2];
    gameObject = GAMEOBJECT_NEW();
    --gameObject.name = "BossFish Group 2";
    transform = gameObject.transform;
    transform:SetParent(group.transform);
    transform.localScale = C_Vector3_One;
    transform.localPosition = C_Vector3_Zero;
    transform.localRotation = C_Quaternion_Zero;
    self._bossFishGroups[2].transform = transform;
    self._bossFishGroups[2].gameObject = gameObject;

    groupPart = _fishGroupData.fishGroupParts[3];
    beginX  = - width/2 - self._horizontalLen;
    x = beginX;
    y = self._horizontalY;

    for j=1,groupPart.fishCount do
        fishData = groupPart.fishes[j];
        fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
        x = x - self._horizontalDistances[j];
        fishObj:SetParent(transform);
        V_Vector3_Value.x = x;
        V_Vector3_Value.y = y;
        V_Vector3_Value.z = z;
        fishObj:SetLocalPosition(V_Vector3_Value);
        fishObj:SetLocalRotation(C_Quaternion_Zero);
        self:AddFish(fishObj);
        fishObj:RegEvent(self,self.OnFishEvent);    
        self._bossFishMap[fishData.fishId]=fishObj;     
    end
end


function _CFishArmyGroup:AsyncInit(_parent,_fishGroupData)
    _CFishArmyGroup.super.AsyncInit(self,_parent,_fishGroupData);

    local gameObject;
    local transform ;

    self.gameObject = GAMEOBJECT_NEW();
    --self.gameObject.name = "FishArmyGroup";
    self.transform  = self.gameObject.transform;
    self.transform:SetParent(_parent);
    self.transform.localScale = C_Vector3_One;
    V_Vector3_Value.x = 0;
    V_Vector3_Value.y = 0.5;
    V_Vector3_Value.z = -5;
    self.transform.localPosition = V_Vector3_Value;
    self.transform.localRotation= C_Quaternion_Zero;

    --���϶��µ���
    self.groups[1] = {};
    gameObject = GAMEOBJECT_NEW();
    transform = gameObject.transform;
    transform:SetParent(self.transform);
    transform.localScale = C_Vector3_One;
    transform.localPosition = C_Vector3_Zero;
    V_Vector3_Value.x = 0;
    V_Vector3_Value.y = 0;
    V_Vector3_Value.z = 180;
    transform.localEulerAngles = V_Vector3_Value;
    --gameObject.name = "FromUp";
    self.groups[1].transform = transform;
    self.groups[1].gameObject = gameObject;
    self.groups[1].circles  = {};

    --���¶��ϵ���
    self.groups[2] = {};
    gameObject = GAMEOBJECT_NEW();
    transform = gameObject.transform;
    transform:SetParent(self.transform);
    transform.localScale = C_Vector3_One;
    transform.localPosition = C_Vector3_Zero;
    transform.localRotation = C_Quaternion_Zero;
    --gameObject.name = "FromDown";
    self.groups[2].transform = transform;
    self.groups[2].gameObject = gameObject;
    self.groups[2].circles  = {};


    group = self.groups[1];
    gameObject = GAMEOBJECT_NEW();
    --gameObject.name = "SmallFish Group 1";
    transform = gameObject.transform;
    transform:SetParent(group.transform);
    transform.localScale = C_Vector3_One;
    transform.localPosition = C_Vector3_Zero;
    transform.localRotation = C_Quaternion_Zero;
    group.smallTransform = transform;
    group.smallGameObject= gameObject;

    group = self.groups[2];
    gameObject = GAMEOBJECT_NEW();
    --gameObject.name = "SmallFish Group 2";
    transform = gameObject.transform;
    transform:SetParent(group.transform);
    transform.localScale = C_Vector3_One;
    transform.localPosition = C_Vector3_Zero;
    transform.localRotation = C_Quaternion_Zero;
    group.smallTransform = transform;
    group.smallGameObject= gameObject;


    --boss��
    group = self.groups[1];
    gameObject = GAMEOBJECT_NEW();
    --gameObject.name = "BossFish Group 1";
    transform = gameObject.transform;
    transform:SetParent(group.transform);
    transform.localScale = C_Vector3_One;
    transform.localPosition = C_Vector3_Zero;
    transform.localRotation = C_Quaternion_Zero;
    self._bossFishGroups[1].transform = transform;
    self._bossFishGroups[1].gameObject = gameObject;
    self._bossFishGroups[1].beginY     = 0;

    group = self.groups[2];
    gameObject = GAMEOBJECT_NEW();
    --gameObject.name = "BossFish Group 2";
    transform = gameObject.transform;
    transform:SetParent(group.transform);
    transform.localScale = C_Vector3_One;
    V_Vector3_Value.x = 0;
    V_Vector3_Value.y = -1.4;
    V_Vector3_Value.z = 0;
    transform.localPosition = V_Vector3_Value;
    transform.localRotation = C_Quaternion_Zero;
    self._bossFishGroups[2].transform = transform;
    self._bossFishGroups[2].gameObject= gameObject;
    self._bossFishGroups[2].beginY    = -1.4;

    --������
    self.gameObject:SetActive(false);
end

function _CFishArmyGroup:AsyncCreateFish(_dt)
    if not self._asyncCreateFish then
        return ;
    end
    local needCreateCount = 1;
    local gameObject;
    local transform ;

     --ÿ�������ٸ�
    local count;
    local groupPart;
    local circles
    local group;
    local fishData;
    local fishObj;
    local angle;
    local hudu;
    local x,y;
    local r;
    local initRotaion;
    local angleIndex;

    local dis ;
    local groupCount=0;
    local groupTime = 0;
    local waitTime =0 ;
    local smallFishItem = nil;
    local beginX = 0;
    local _fishGroupData = self._fishGroupData;

    local createFishCount = self._asyncCreateCount;
    local isLoadOver = true;
    local isNeedCreate = true;
    --local width = G_GlobalGame:GetKeyValue(G_GlobalGame.Enum_KeyValue.GetScenePixelSize);
    local width  = self._fishSortWidth;
    group = self.groups[1];
    transform = group.smallTransform; 
    gameObject = group.smallGameObject;
    groupPart = _fishGroupData.fishGroupParts[6];
    dis = width/groupPart.fishCount;
    beginX  = -width/2;
    x = beginX;
    y = self._smallFishMoveBeginY;
    local FSFN = _CFishArmySmallFish.New;
    for j=1,groupPart.fishCount do
        x = x + dis;
        if createFishCount>0 then
            createFishCount = createFishCount - 1;
        else
            if groupCount==0 then
                groupCount = MATH_RANDOM(self._groupMinCount,self._groupMaxCount);
                groupTime = MATH_RANDOM(0,self._maxWaitTime*100);
                self._asyncCreateCount = self._asyncCreateCount + groupCount;
                needCreateCount = groupCount;
                isNeedCreate = false;
            end
            if needCreateCount>0 then
                needCreateCount = needCreateCount -1;
                groupCount = groupCount - 1;
                fishData = groupPart.fishes[j];
                fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
                waitTime = MATH_RANDOM(groupTime,groupTime + self._groupWaitTime*100);
                smallFishItem = FSFN(fishObj,waitTime/100);
                --�����б�
                self._smallFishGroups[fishData.fishId]=smallFishItem;
                fishObj:SetParent(transform);
                V_Vector3_Value.x = x;
                V_Vector3_Value.y = y;
                V_Vector3_Value.z = 0;
                fishObj:SetLocalPosition(V_Vector3_Value);
                V_Vector3_Value.x = -90;
                V_Vector3_Value.y = 0;
                V_Vector3_Value.z = 0;
                fishObj:SetLocalEulerAngles(V_Vector3_Value);
                V_Vector3_Value.x = 0.8;
                V_Vector3_Value.y = 0.8;
                V_Vector3_Value.z = 0.8;
                fishObj:SetLocalScale(V_Vector3_Value);
                self:AddFish(fishObj);
                fishObj:RegEvent(self,self.OnFishEvent);
            else
                return ;
            end
        end
    end

    if(groupCount>0) then
        self._asyncCreateCount = self._asyncCreateCount - groupCount;
        return;
    end

    group = self.groups[2];
    transform = group.smallTransform; 
    gameObject = group.smallGameObject;
    groupPart = _fishGroupData.fishGroupParts[12];

    dis = width/groupPart.fishCount;
    beginX  = - width/2;
    x = beginX;
    y = self._smallFishMoveBeginY;
    
    for j=1,groupPart.fishCount do
        x = x + dis;
        if createFishCount>0 then
            createFishCount = createFishCount - 1;
        else
            if groupCount==0 then
                groupCount = MATH_RANDOM(self._groupMinCount,self._groupMaxCount);
                groupTime = MATH_RANDOM(0,self._maxWaitTime*100);
                self._asyncCreateCount = self._asyncCreateCount + groupCount;
                needCreateCount = groupCount;
                isNeedCreate = false;
            end
            if needCreateCount>0 then
                needCreateCount = needCreateCount -1;
                groupCount = groupCount - 1;
                fishData = groupPart.fishes[j];
                fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
                waitTime = MATH_RANDOM(groupTime,groupTime + self._groupWaitTime*100);
                smallFishItem = FSFN(fishObj,waitTime/100);
                --�����б�
                self._smallFishGroups[fishData.fishId]=smallFishItem;
                fishObj:SetParent(transform);
                V_Vector3_Value.x = x;
                V_Vector3_Value.y = y;
                V_Vector3_Value.z = 0;
                fishObj:SetLocalPosition(V_Vector3_Value);
                V_Vector3_Value.x = -90;
                V_Vector3_Value.y = 0;
                V_Vector3_Value.z = 0;
                fishObj:SetLocalEulerAngles(V_Vector3_Value);
                V_Vector3_Value.x = 0.8;
                V_Vector3_Value.y = 0.8;
                V_Vector3_Value.z = 0.8;
                fishObj:SetLocalScale(V_Vector3_Value);
                self:AddFish(fishObj);
                fishObj:RegEvent(self,self.OnFishEvent);  
            else
                return ;
            end
        end
    end
    if(groupCount>0) then
        self._asyncCreateCount = self._asyncCreateCount - groupCount;
        return;
    end
    if needCreateCount<=0 then
        if isNeedCreate then
            needCreateCount = 1;
        else
            return ;
        end
    end
    --boss��
    transform = self._bossFishGroups[1].transform;
    gameObject = self._bossFishGroups[1].gameObject;

    beginX  = - width/2 - self._horizontalLen;
    x = beginX;
    y = self._horizontalY;

    local fishIndex = 0;
    for i=5,1,-1  do
        groupPart = _fishGroupData.fishGroupParts[i];
        for j=1,groupPart.fishCount do
            fishIndex = fishIndex + 1;
            x = x - self._horizontalDistances[fishIndex];
            if createFishCount>0 then
                createFishCount = createFishCount - 1;
            else
                if needCreateCount>0 then
                    needCreateCount = needCreateCount -1;
                    fishData = groupPart.fishes[j];
                    fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
                    fishObj:SetParent(transform);
                    V_Vector3_Value.x = x;
                    V_Vector3_Value.y = y;
                    V_Vector3_Value.z = 0;
                    fishObj:SetLocalPosition(V_Vector3_Value);
                    V_Vector3_Value.x = 0;
                    V_Vector3_Value.y = 90;
                    V_Vector3_Value.z = 180;
                    fishObj:SetLocalEulerAngles(V_Vector3_Value);
                    V_Vector3_Value.x = 0.6;
                    V_Vector3_Value.y = 0.6;
                    V_Vector3_Value.z = 0.6;
                    fishObj:SetLocalScale(V_Vector3_Value);
                    self:AddFish(fishObj);
                    fishObj:RegEvent(self,self.OnFishEvent);  
                    self._bossFishMap[fishData.fishId]=fishObj; 
                else
                    return ;
                end

            end
        end
    end

    if needCreateCount<=0 then
        return ;
    end

    transform = self._bossFishGroups[2].transform;
    gameObject = self._bossFishGroups[2].gameObject;

    beginX  = - width/2 - self._horizontalLen;
    x = beginX;
    y = self._horizontalY;
    fishIndex = 0;
    for i=5,1,-1  do
        groupPart = _fishGroupData.fishGroupParts[i + 6];
        for j=1,groupPart.fishCount do
            fishIndex = fishIndex + 1;
            x = x - self._horizontalDistances[fishIndex];
            if createFishCount>0 then
                createFishCount = createFishCount - 1;
            else
                if needCreateCount>0 then
                    needCreateCount = needCreateCount -1;
                    fishData = groupPart.fishes[j];
                    fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
                    fishObj:SetParent(transform);
                    V_Vector3_Value.x = x;
                    V_Vector3_Value.y = y;
                    V_Vector3_Value.z = 0;
                    fishObj:SetLocalPosition(V_Vector3_Value);
                    V_Vector3_Value.x = 0;
                    V_Vector3_Value.y = -90;
                    V_Vector3_Value.z = 0;
                    fishObj:SetLocalEulerAngles(V_Vector3_Value);
                    V_Vector3_Value.x = 0.6;
                    V_Vector3_Value.y = 0.6;
                    V_Vector3_Value.z = 0.6;
                    fishObj:SetLocalScale(V_Vector3_Value);
                    self:AddFish(fishObj);
                    fishObj:RegEvent(self,self.OnFishEvent);    
                    self._bossFishMap[fishData.fishId]=fishObj;  
                else
                    return ;
                end
            end   
        end
    end
    self._asyncCreateFish = false;
end

-- ��û�з�ת��ʱ�� 90��180��0
--��������ʣ���
function _CFishArmyGroup:AsyncCreateLeftFish()
    if not self._asyncCreateFish then
        return ;
    end
    local gameObject;
    local transform ;
    local needCreateCount=1;
    local _fishGroupData = self._fishGroupData;
    local createFishCount = self._asyncCreateCount;
    local isLoadOver = true;

     --ÿ�������ٸ�
    local count;
    local groupPart;
    local circles
    local group;
    local fishData;
    local fishObj;
    local angle;
    local hudu;
    local x,y;
    local r;
    local initRotaion;
    local angleIndex;

    local dis ;
    local groupCount=0;
    local groupTime = 0;
    local waitTime =0 ;
    local smallFishItem = nil;
    local beginX = 0;

    --local width = G_GlobalGame:GetKeyValue(G_GlobalGame.Enum_KeyValue.GetScenePixelSize);
    local width  = self._fishSortWidth;
    group = self.groups[1];
    transform = group.smallTransform; 
    gameObject = group.smallGameObject;
    groupPart = _fishGroupData.fishGroupParts[6];

    dis = width/groupPart.fishCount;
    beginX  = -width/2;
    x = beginX;
    y = self._smallFishMoveBeginY;
    local MATH_RANDOM = MATH_RANDOM;
    local FSFN = _CFishArmySmallFish.New;
    for j=1,groupPart.fishCount do
        x = x + dis;
        if createFishCount>0 then
            createFishCount = createFishCount - 1;
        else
            if groupCount==0 then
                groupCount = MATH_RANDOM(self._groupMinCount,self._groupMaxCount);
                groupTime = MATH_RANDOM(0,self._maxWaitTime*100);
            end
            needCreateCount = needCreateCount -1;
            groupCount = groupCount - 1;
            fishData = groupPart.fishes[j];
            fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
            waitTime = MATH_RANDOM(groupTime,groupTime + self._groupWaitTime*100);
            smallFishItem = FSFN(fishObj,waitTime/100);
            --�����б�
            self._smallFishGroups[fishData.fishId]=smallFishItem;
            fishObj:SetParent(transform);
            V_Vector3_Value.x = x;
            V_Vector3_Value.y = y;
            V_Vector3_Value.z = 0;
            fishObj:SetLocalPosition(V_Vector3_Value);
            V_Vector3_Value.x = -90;
            V_Vector3_Value.y = 0;
            V_Vector3_Value.z = 0;
            fishObj:SetLocalEulerAngles(V_Vector3_Value);
            V_Vector3_Value.x = 0.8;
            V_Vector3_Value.y = 0.8;
            V_Vector3_Value.z = 0.8;
            fishObj:SetLocalScale(V_Vector3_Value);
            self:AddFish(fishObj);
            fishObj:RegEvent(self,self.OnFishEvent);
        end
    end

    group = self.groups[2];
    transform = group.smallTransform; 
    gameObject = group.smallGameObject;

    groupPart = _fishGroupData.fishGroupParts[12];

    dis = width/groupPart.fishCount;
    beginX  = - width/2;
    x = beginX;
    y = self._smallFishMoveBeginY;
    for j=1,groupPart.fishCount do
        x = x + dis;
        if createFishCount>0 then
            createFishCount = createFishCount - 1;
        else
            if groupCount==0 then
                groupCount = MATH_RANDOM(self._groupMinCount,self._groupMaxCount);
                groupTime = MATH_RANDOM(0,self._maxWaitTime*100);
            end
            groupCount = groupCount - 1;
            fishData = groupPart.fishes[j];
            fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
            waitTime = MATH_RANDOM(groupTime,groupTime + self._groupWaitTime*100);
            smallFishItem = FSFN(fishObj,waitTime/100);
            --�����б�
            self._smallFishGroups[fishData.fishId] = smallFishItem;
            fishObj:SetParent(transform);
            V_Vector3_Value.x = x;
            V_Vector3_Value.y = y;
            V_Vector3_Value.z = 0;
            fishObj:SetLocalPosition(V_Vector3_Value);
            V_Vector3_Value.x = -90;
            V_Vector3_Value.y = 0;
            V_Vector3_Value.z = 0;
            fishObj:SetLocalEulerAngles(V_Vector3_Value);
            V_Vector3_Value.x = 0.8;
            V_Vector3_Value.y = 0.8;
            V_Vector3_Value.z = 0.8;
            fishObj:SetLocalScale(V_Vector3_Value);
            self:AddFish(fishObj);
            fishObj:RegEvent(self,self.OnFishEvent);  
        end
    end
    --boss��
    transform = self._bossFishGroups[1].transform;
    gameObject = self._bossFishGroups[1].gameObject;
    beginX  = - width/2 - self._horizontalLen;
    x = beginX;
    y = self._horizontalY;
    local fishIndex =0 ;
    for i=5,1,-1  do
        groupPart = _fishGroupData.fishGroupParts[i];
        for j=1,groupPart.fishCount do
            fishIndex = fishIndex + 1;
            x = x - self._horizontalDistances[fishIndex];
            if createFishCount>0 then
                createFishCount = createFishCount - 1;
            else
                fishData = groupPart.fishes[j];
                fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
                fishObj:SetParent(transform);
                V_Vector3_Value.x = x;
                V_Vector3_Value.y = y;
                V_Vector3_Value.z = 0;
                fishObj:SetLocalPosition(V_Vector3_Value);
                V_Vector3_Value.x = 0;
                V_Vector3_Value.y = 90;
                V_Vector3_Value.z = 180;
                fishObj:SetLocalEulerAngles(V_Vector3_Value);
                V_Vector3_Value.x = 0.6;
                V_Vector3_Value.y = 0.6;
                V_Vector3_Value.z = 0.6;
                fishObj:SetLocalScale(V_Vector3_Value);
                self:AddFish(fishObj);
                fishObj:RegEvent(self,self.OnFishEvent);  
                self._bossFishMap[fishData.fishId]=fishObj; 
            end
        end
    end


    transform = self._bossFishGroups[2].transform;
    gameObject = self._bossFishGroups[2].gameObject;

    groupPart = _fishGroupData.fishGroupParts[3];
    beginX  = - width/2 - self._horizontalLen;
    x = beginX;
    y = self._horizontalY;

--    for j=1,groupPart.fishCount do
--        x = x - self._horizontalDistances[j];
--        if createFishCount>0 then
--            createFishCount = createFishCount - 1;
--        else
--            fishData = groupPart.fishes[j];
--            fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
--            fishObj:SetParent(transform);
--            fishObj:SetLocalPosition(Vector3.New(x, y, 0));
--            fishObj:SetLocalRotation(Quaternion.Euler(0,-90,0));
--            fishObj:SetLocalScale(Vector3.New(0.4,0.4,0.4));
--            self.fishMap:insert(fishData.fishId,fishObj);
--            fishObj:RegEvent(self,self.OnFishEvent);    
--            self._bossFishMap:insert(fishData.fishId,fishObj);  
--        end   
--    end
    fishIndex =0 ;
    for i=5,1,-1  do
        groupPart = _fishGroupData.fishGroupParts[i+6];
        for j=1,groupPart.fishCount do
            fishIndex = fishIndex + 1;
            x = x - self._horizontalDistances[fishIndex];
            if createFishCount>0 then
                createFishCount = createFishCount - 1;
            else
                fishData = groupPart.fishes[j];
                fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
                fishObj:SetParent(transform);
                V_Vector3_Value.x = x;
                V_Vector3_Value.y = y;
                V_Vector3_Value.z = 0;
                fishObj:SetLocalPosition(V_Vector3_Value);
                V_Vector3_Value.x = 0;
                V_Vector3_Value.y = 90;
                V_Vector3_Value.z = 0;
                fishObj:SetLocalEulerAngles(V_Vector3_Value);
                V_Vector3_Value.x = 0.6;
                V_Vector3_Value.y = 0.6;
                V_Vector3_Value.z = 0.6;
                fishObj:SetLocalScale(V_Vector3_Value);
                self:AddFish(fishObj);
                fishObj:RegEvent(self,self.OnFishEvent);  
                self._bossFishMap[fishData.fishId] = fishObj; 
            end
        end
    end
end

--ÿִ֡��
function _CFishArmyGroup:Update(_dt)
    _CFishArmyGroup.super.Update(self,_dt);
    if self:IsTimeOut() then
        return;
    end
    
    local smallFishGroup = self._smallFishGroups;
    for i,v in pairs(smallFishGroup) do
        v:Update(_dt);
    end

    --�Ƿ�ˮƽ�ƶ�
    if not self._isMoveHorizontal then
        self._horizontalWaitTime = self._horizontalWaitTime - _dt;
        if self._horizontalWaitTime<=0 then
            --ˮƽ�㿪ʼ�ƶ�
            self._isMoveHorizontal = true;
            self._horizontalHaveMoveTime = 0-self._horizontalWaitTime;
            if self._horizontalHaveMoveTime>0 then
                local x = self._horizontalMoveSpeed*self._horizontalHaveMoveTime;
                V_Vector3_Value.x = x;
                V_Vector3_Value.y = self._bossFishGroups[1].beginY;
                V_Vector3_Value.z = 0;
                self._bossFishGroups[1].transform.localPosition = V_Vector3_Value;
                V_Vector3_Value.y = self._bossFishGroups[2].beginY;
                self._bossFishGroups[2].transform.localPosition = V_Vector3_Value;
            end

        end
    else
        self._horizontalHaveMoveTime = self._horizontalHaveMoveTime + _dt;
        if self._horizontalHaveMoveTime>0 then
            local x = self._horizontalMoveSpeed*self._horizontalHaveMoveTime;
            V_Vector3_Value.x = x;
            V_Vector3_Value.y = self._bossFishGroups[1].beginY;
            V_Vector3_Value.z = 0;
            self._bossFishGroups[1].transform.localPosition = V_Vector3_Value;
            V_Vector3_Value.y = self._bossFishGroups[2].beginY;
            self._bossFishGroups[2].transform.localPosition = V_Vector3_Value;
        end 
        if self._horizontalHaveMoveTime>=self._horizontalMoveTime then
            if not self._isMoveSmallFish then
                --boss���Ѿ��뿪��Ļ��
                for i,v in pairs(smallFishGroup) do
                    v:FishLeaveScreen();
                end
                self._isMoveSmallFish = true;
            end

        end
    end
end

function _CFishArmyGroup:OnFishDead(_fish,_fishId)
    self._smallFishGroups[_fishId]=nil;
    self._bossFishMap[_fishId]=nil;
end

--����ʧ
function _CFishArmyGroup:OnFishDisappear(_fish,_fishId)
    self._smallFishGroups[_fishId]=nil;
    self._bossFishMap[_fishId]=nil;
--    self._smallFishGroups:erase(_fishId);
--    if self._bossFishMap:size()>0 then
--        self._bossFishMap:erase(_fishId);
--        if self._bossFishMap:size()==0 then
--            --boss�㶼��ʧ�ˣ���������
--            local it = self._smallFishGroups:iter();
--            local val = it();
--            local smallFish;
--            while(val) do
--                smallFish = self._smallFishGroups:value(val);
--                smallFish:FishLeaveScreen();
--                val =it();
--            end
--        end
--    end
end


--local _CFishMoveBottomCircleGroup = class("_CFishMoveBottomCircleGroup",_CFishGroup);
local _CFishMoveBottomCircleGroup = class(nil,_CFishGroup);

function _CFishMoveBottomCircleGroup:ctor(_fishCreator)
    _CFishMoveBottomCircleGroup.super.ctor(self,_fishCreator);

    --�뾶
    self._radius = {0,1.1,1.6};

    --��ʱ��
    self.totalUseTime = 50;
    self.totalDivNumber =1/self.totalUseTime;

    --�ύ
    self.groups  = {};
end

function _CFishMoveBottomCircleGroup:AsyncInit(_parent,_fishGroupData)
    _CFishMoveBottomCircleGroup.super.AsyncInit(self,_parent,_fishGroupData);


    local gameObject;
    local transform ;

    --�㳱�ܽڵ�
    self.gameObject = GAMEOBJECT_NEW();
    --self.gameObject.name = "MoveBottomCircleGroup";
    self.transform  = self.gameObject.transform;
    self.transform:SetParent(_parent);
    self.transform.localScale = C_Vector3_One;
    V_Vector3_Value.x = 0;
    V_Vector3_Value.y = 0;
    V_Vector3_Value.z = -5;
    self.transform.localPosition = V_Vector3_Value;
    self.transform.localRotation = C_Quaternion_Zero;

    --���ϵ�group
    self.groups[1] = {};
    gameObject = GAMEOBJECT_NEW();
    transform = gameObject.transform;
    transform:SetParent(self.transform);
    transform.localScale = C_Vector3_One;
    V_Vector3_Value.z = -45;
    transform.localEulerAngles = V_Vector3_Value;
    local group = self.groups[1];
    group.transform = transform;
    group.gameObject = gameObject;
    group.circles  = {};
    group.beginPos = {x=-5.75,y=3.79,z=0};
    group.endPos   = {x=2.3,y=-4.26,z=0};
    local bp = group.beginPos;
    local ep = group.endPos;
    local divNumber = self.totalDivNumber;
    group.speed    = {x = (ep.x - bp.x)*divNumber,y= (ep.y - bp.y)*divNumber,z=(ep.z - bp.z)*divNumber};
    --self.groups[1].speed    = 
    transform.localPosition =  bp;

    --���ϵ�group
    self.groups[2] = {};
    gameObject = GAMEOBJECT_NEW();
    transform = gameObject.transform;
    transform:SetParent(self.transform);
    transform.localScale = C_Vector3_One;
    V_Vector3_Value.y = 180;
    V_Vector3_Value.z = -45;
    transform.localEulerAngles = V_Vector3_Value;

    local group = self.groups[2];
    group.transform = transform;
    group.gameObject = gameObject;
    group.circles  = {};
    group.beginPos = {x=5.85,y=3.79,z=0};
    group.endPos   = {x=-2.31,y=-4.37,z=0.65};
    local bp = group.beginPos;
    local ep = group.endPos;
    local divNumber = self.totalDivNumber;
    group.speed    = {x = (ep.x - bp.x)*divNumber,y= (ep.y - bp.y)*divNumber,z=(ep.z - bp.z)*divNumber};
    --self.groups[1].speed    = 
    transform.localPosition =  bp;

    --������
    self.gameObject:SetActive(false);

    --���㳱����ʱ��
    self.runTime = 0;
end

function _CFishMoveBottomCircleGroup:AsyncCreateFish(_dt)
    if not self._asyncCreateFish then
        return ;
    end
    local gameObject;
    local transform ;
    local needCreateCount=1;
    local _fishGroupData = self._fishGroupData;

    local createFishCount = self._asyncCreateCount;
    local everyCount = _fishGroupData.fishPartCount/2; 
    local r;
    local groupPart;
    local simpleGroupPart,doubleGroupPart;
    local totalCount;
    local fishData;
    local fishObj;
    local groupFish;
    local hudu,curHudu;
    local x,y,z;
    local simpleCount,doubleCount;
    local curCount;

    local group1_gameObject= self.groups[1].gameObject;
    local group1_transform = self.groups[1].transform;
    local group2_gameObject= self.groups[2].gameObject;
    local group2_transform = self.groups[2].transform;

    self._asyncCreateCount = self._asyncCreateCount + needCreateCount;

    for i=1,3 do
        r = self._radius[i];

        if i==1 then --��һȦ
            --����
            groupPart = _fishGroupData.fishGroupParts[i];
            totalCount = groupPart.fishCount;
            hudu  = 2 * MATH_PI / totalCount;
            for j=1,totalCount do
                if createFishCount>0 then 
                    createFishCount = createFishCount - 1;
                else --if createFishCount>0 then
                    if needCreateCount>0 then
                        needCreateCount = needCreateCount - 1;
                        curHudu = hudu*(j-1);
                        x = r * MATH_COS(curHudu);
                        y = r * MATH_SIN(curHudu); 
                        z = 0;
                        fishData = groupPart.fishes[j];
                        fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
                        fishObj:SetParent(group1_transform);
                        V_Vector3_Value.x = x;
                        V_Vector3_Value.y = y;
                        V_Vector3_Value.z = 0;
                        fishObj:SetLocalPosition(V_Vector3_Value);
                        V_Vector3_Value.x = 0;
                        V_Vector3_Value.y = 90;
                        --V_Vector3_Value.z = 0;
                        fishObj:SetLocalEulerAngles(V_Vector3_Value);
                        V_Vector3_Value.x = 0.8;
                        V_Vector3_Value.y = 0.8;
                        V_Vector3_Value.z = 0.8;
                        fishObj:SetLocalScale(V_Vector3_Value);
                        self:AddFish(fishObj);
                        fishObj:RegEvent(self,self.OnFishEvent);  
                    else  --if needCreateCount>0 then
                        return ;
                    end   --if needCreateCount>0 then
                end  --if createFishCount>0 then
            end -- for j=1,totalCount do

            --����
            groupPart = _fishGroupData.fishGroupParts[i+everyCount];
            totalCount = groupPart.fishCount;
            hudu  = 2 * MATH_PI / totalCount;
            for j=1,totalCount do
                if createFishCount>0 then 
                    createFishCount = createFishCount - 1;
                else --if createFishCount>0 then
                    if needCreateCount>0 then
                        needCreateCount = needCreateCount - 1;
                        curHudu = hudu*(j-1);
                        x = r * MATH_COS(curHudu);
                        y = r * MATH_SIN(curHudu); 
                        z = 0;
                        fishData = groupPart.fishes[j];
                        fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
                        fishObj:SetParent(group2_transform);
                        V_Vector3_Value.x = x;
                        V_Vector3_Value.y = y;
                        V_Vector3_Value.z = 0;
                        fishObj:SetLocalPosition(V_Vector3_Value);
                        V_Vector3_Value.x = 0;
                        V_Vector3_Value.y = 90;
                        --V_Vector3_Value.z = 0;
                        fishObj:SetLocalEulerAngles(V_Vector3_Value);
                        V_Vector3_Value.x = 0.8;
                        V_Vector3_Value.y = 0.8;
                        V_Vector3_Value.z = 0.8;
                        fishObj:SetLocalScale(V_Vector3_Value);
                        self:AddFish(fishObj);
                        fishObj:RegEvent(self,self.OnFishEvent);  
                    else  --if needCreateCount>0 then
                        return ;
                    end   --if needCreateCount>0 then
                end  --if createFishCount>0 then
            end -- for j=1,totalCount do
        elseif i==2 then  --if i==1 then
            simpleGroupPart = _fishGroupData.fishGroupParts[2];
            doubleGroupPart = _fishGroupData.fishGroupParts[3];
            totalCount = simpleGroupPart.fishCount + doubleGroupPart.fishCount;
            simpleCount = 0;
            doubleCount = 0;
            hudu  = 2 * MATH_PI / totalCount;
            for j=1,totalCount do  
                if createFishCount>0 then
                    createFishCount = createFishCount - 1;
                else  --if createFishCount>0 then
                    if needCreateCount>0 then
                        needCreateCount = needCreateCount - 1;
                        curHudu = hudu*(j-1);
                        x = r * MATH_COS(curHudu);
                        y = r * MATH_SIN(curHudu); 
                        z = 0;
                        if j%2==1 then
                            simpleCount = simpleCount + 1;
                            groupPart = simpleGroupPart;
                            curCount = simpleCount;
                        else
                            doubleCount = doubleCount + 1;
                            groupPart = doubleGroupPart;
                            curCount = doubleCount;
                        end
                        fishData = groupPart.fishes[curCount];
                        fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
                        fishObj:SetParent(group1_transform);
                        V_Vector3_Value.x = x;
                        V_Vector3_Value.y = y;
                        V_Vector3_Value.z = 0;
                        fishObj:SetLocalPosition(V_Vector3_Value);
                        V_Vector3_Value.x = 0;
                        V_Vector3_Value.y = 90;
                        --V_Vector3_Value.z = 0;
                        fishObj:SetLocalEulerAngles(V_Vector3_Value);
                        V_Vector3_Value.x = 0.8;
                        V_Vector3_Value.y = 0.8;
                        V_Vector3_Value.z = 0.8;
                        fishObj:SetLocalScale(V_Vector3_Value);
                        self:AddFish(fishObj);
                        fishObj:RegEvent(self,self.OnFishEvent);  
                    else   --if needCreateCount>0 then
                        return ;
                    end   --if needCreateCount>0 then                
                end   --if createFishCount>0 then              
            end  --for j=1,totalCount do


            simpleGroupPart = _fishGroupData.fishGroupParts[2 + everyCount];
            doubleGroupPart = _fishGroupData.fishGroupParts[3 + everyCount];
            totalCount = simpleGroupPart.fishCount + doubleGroupPart.fishCount;
            simpleCount = 0;
            doubleCount = 0;
            hudu  = 2 * MATH_PI / totalCount;
            for j=1,totalCount do  
                if createFishCount>0 then
                    createFishCount = createFishCount - 1;
                else  --if createFishCount>0 then
                    if needCreateCount>0 then
                        needCreateCount = needCreateCount - 1;
                        curHudu = hudu*(j-1);
                        x = r * MATH_COS(curHudu);
                        y = r * MATH_SIN(curHudu); 
                        z = 0;
                        if j%2==1 then
                            simpleCount = simpleCount + 1;
                            groupPart = simpleGroupPart;
                            curCount = simpleCount;
                        else
                            doubleCount = doubleCount + 1;
                            groupPart = doubleGroupPart;
                            curCount = doubleCount;
                        end
                        fishData = groupPart.fishes[curCount];
                        fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
                        fishObj:SetParent(group2_transform);
                        V_Vector3_Value.x = x;
                        V_Vector3_Value.y = y;
                        V_Vector3_Value.z = 0;
                        fishObj:SetLocalPosition(V_Vector3_Value);
                        V_Vector3_Value.x = 0;
                        V_Vector3_Value.y = 90;
                        --V_Vector3_Value.z = 0;
                        fishObj:SetLocalEulerAngles(V_Vector3_Value);
                        V_Vector3_Value.x = 0.8;
                        V_Vector3_Value.y = 0.8;
                        V_Vector3_Value.z = 0.8;
                        fishObj:SetLocalScale(V_Vector3_Value);
                        self:AddFish(fishObj);
                        fishObj:RegEvent(self,self.OnFishEvent);  
                    else    --if needCreateCount>0 then
                        return ;
                    end     --if needCreateCount>0 then                
                end   --if createFishCount>0 then              
            end  --for j=1,totalCount do
        elseif i==3 then  --elseif i==2 then
            simpleGroupPart = _fishGroupData.fishGroupParts[4];
            doubleGroupPart = _fishGroupData.fishGroupParts[5];
            totalCount = simpleGroupPart.fishCount + doubleGroupPart.fishCount;
            simpleCount = 0;
            doubleCount = 0;
            hudu  = 2 * MATH_PI / totalCount;
            for j=1,totalCount do
                if createFishCount>0 then
                    createFishCount = createFishCount - 1;
                else  --if createFishCount>0 then
                    if needCreateCount>0 then 
                        needCreateCount = needCreateCount - 1;
                        curHudu = hudu*(j-1);
                        x = r * MATH_COS(curHudu);
                        y = r * MATH_SIN(curHudu); 
                        z = 0;
                        if j%2==1 then
                            simpleCount = simpleCount + 1;
                            groupPart = simpleGroupPart;
                            curCount = simpleCount;
                        else
                            doubleCount = doubleCount + 1;
                            groupPart = doubleGroupPart;
                            curCount = doubleCount;
                        end
                        fishData = groupPart.fishes[curCount];
                        fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
                        fishObj:SetParent(group1_transform);
                        V_Vector3_Value.x = x;
                        V_Vector3_Value.y = y;
                        V_Vector3_Value.z = 0;
                        fishObj:SetLocalPosition(V_Vector3_Value);
                        V_Vector3_Value.x = 0;
                        V_Vector3_Value.y = 90;
                        --V_Vector3_Value.z = 0;
                        fishObj:SetLocalEulerAngles(V_Vector3_Value);
                        V_Vector3_Value.x = 0.8;
                        V_Vector3_Value.y = 0.8;
                        V_Vector3_Value.z = 0.8;
                        fishObj:SetLocalScale(V_Vector3_Value);
                        self:AddFish(fishObj);
                        fishObj:RegEvent(self,self.OnFishEvent);  
                    else --if needCreateCount>0 then
                        return ;
                    end  --if needCreateCount>0 then                  
                end  --if createFishCount>0 then              
            end  --for j=1,totalCount do

            simpleGroupPart = _fishGroupData.fishGroupParts[4 + everyCount];
            doubleGroupPart = _fishGroupData.fishGroupParts[5 + everyCount];
            totalCount = simpleGroupPart.fishCount + doubleGroupPart.fishCount;
            simpleCount = 0;
            doubleCount = 0;
            hudu  = 2 * MATH_PI / totalCount;
            for j=1,totalCount do
                if createFishCount>0 then
                    createFishCount = createFishCount - 1;
                else  --if createFishCount>0 then
                    if needCreateCount>0 then 
                        needCreateCount = needCreateCount - 1;
                        curHudu = hudu*(j-1);
                        x = r * MATH_COS(curHudu);
                        y = r * MATH_SIN(curHudu); 
                        z = 0;
                        if j%2==1 then
                            simpleCount = simpleCount + 1;
                            groupPart = simpleGroupPart;
                            curCount = simpleCount;
                        else
                            doubleCount = doubleCount + 1;
                            groupPart = doubleGroupPart;
                            curCount = doubleCount;
                        end
                        fishData = groupPart.fishes[curCount];
                        fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
                        fishObj:SetParent(group2_transform);
                        V_Vector3_Value.x = x;
                        V_Vector3_Value.y = y;
                        V_Vector3_Value.z = 0;
                        fishObj:SetLocalPosition(V_Vector3_Value);
                        V_Vector3_Value.x = 0;
                        V_Vector3_Value.y = 90;
                        --V_Vector3_Value.z = 0;
                        fishObj:SetLocalEulerAngles(V_Vector3_Value);
                        V_Vector3_Value.x = 0.8;
                        V_Vector3_Value.y = 0.8;
                        V_Vector3_Value.z = 0.8;
                        fishObj:SetLocalScale(V_Vector3_Value);
                        self:AddFish(fishObj);
                        fishObj:RegEvent(self,self.OnFishEvent);  
                    else --if needCreateCount>0 then
                        return ;
                    end  --if needCreateCount>0 then                  
                end  --if createFishCount>0 then              
            end  --for j=1,totalCount do
        end -- if i==1 then --elseif i==3 then 
    end --for i=1,3 do
end

function _CFishMoveBottomCircleGroup:AsyncCreateLeftFish()
    if not self._asyncCreateFish then
        return ;
    end
    local gameObject;
    local transform ;
    local needCreateCount=1;
    local _fishGroupData = self._fishGroupData;

    local createFishCount = self._asyncCreateCount;
    local everyCount = _fishGroupData.fishPartCount/2; 
    local r;
    local groupPart;
    local simpleGroupPart,doubleGroupPart;
    local totalCount;
    local fishData;
    local fishObj;
    local groupFish;
    local hudu,curHudu;
    local x,y,z;
    local simpleCount,doubleCount;
    local curCount;

    local group1_gameObject= self.groups[1].gameObject;
    local group1_transform = self.groups[1].transform;
    local group2_gameObject= self.groups[2].gameObject;
    local group2_transform = self.groups[2].transform;

    self._asyncCreateCount = self._asyncCreateCount + needCreateCount;

    for i=1,3 do
        r = self._radius[i];

        if i==1 then --��һȦ
            --����
            groupPart = _fishGroupData.fishGroupParts[i];
            totalCount = groupPart.fishCount;
            hudu  = 2 * MATH_PI / totalCount;
            for j=1,totalCount do
                if createFishCount>0 then 
                    createFishCount = createFishCount - 1;
                else --if createFishCount>0 then
                    curHudu = hudu*(j-1);
                    x = r * MATH_COS(curHudu);
                    y = r * MATH_SIN(curHudu); 
                    z = 0;
                    fishData = groupPart.fishes[j];
                    fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
                    fishObj:SetParent(group1_transform);
                    V_Vector3_Value.x = x;
                    V_Vector3_Value.y = y;
                    V_Vector3_Value.z = 0;
                    fishObj:SetLocalPosition(V_Vector3_Value);
                    V_Vector3_Value.x = 0;
                    V_Vector3_Value.y = 90;
                    --V_Vector3_Value.z = 0;
                    fishObj:SetLocalEulerAngles(V_Vector3_Value);
                    V_Vector3_Value.x = 0.8;
                    V_Vector3_Value.y = 0.8;
                    V_Vector3_Value.z = 0.8;
                    fishObj:SetLocalScale(V_Vector3_Value);
                    self:AddFish(fishObj);
                    fishObj:RegEvent(self,self.OnFishEvent);  
                end  --if createFishCount>0 then
            end -- for j=1,totalCount do

            --����
            groupPart = _fishGroupData.fishGroupParts[i+everyCount];
            totalCount = groupPart.fishCount;
            hudu  = 2 * MATH_PI / totalCount;
            for j=1,totalCount do
                if createFishCount>0 then 
                    createFishCount = createFishCount - 1;
                else --if createFishCount>0 then
                    curHudu = hudu*(j-1);
                    x = r * MATH_COS(curHudu);
                    y = r * MATH_SIN(curHudu); 
                    z = 0;
                    fishData = groupPart.fishes[j];
                    fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
                    fishObj:SetParent(group2_transform);
                    V_Vector3_Value.x = x;
                    V_Vector3_Value.y = y;
                    V_Vector3_Value.z = 0;
                    fishObj:SetLocalPosition(V_Vector3_Value);
                    V_Vector3_Value.x = 0;
                    V_Vector3_Value.y = 90;
                    --V_Vector3_Value.z = 0;
                    fishObj:SetLocalEulerAngles(V_Vector3_Value);
                    V_Vector3_Value.x = 0.8;
                    V_Vector3_Value.y = 0.8;
                    V_Vector3_Value.z = 0.8;
                    fishObj:SetLocalScale(V_Vector3_Value);
                    self:AddFish(fishObj);
                    fishObj:RegEvent(self,self.OnFishEvent); 
                end  --if createFishCount>0 then
            end -- for j=1,totalCount do
        elseif i==2 then  --if i==1 then
            simpleGroupPart = _fishGroupData.fishGroupParts[2];
            doubleGroupPart = _fishGroupData.fishGroupParts[3];
            totalCount = simpleGroupPart.fishCount + doubleGroupPart.fishCount;
            simpleCount = 0;
            doubleCount = 0;
            hudu  = 2 * MATH_PI / totalCount;
            for j=1,totalCount do  
                if createFishCount>0 then
                    createFishCount = createFishCount - 1;
                else  --if createFishCount>0 then
                    curHudu = hudu*(j-1);
                    x = r * MATH_COS(curHudu);
                    y = r * MATH_SIN(curHudu); 
                    z = 0;
                    if j%2==1 then
                        simpleCount = simpleCount + 1;
                        groupPart = simpleGroupPart;
                        curCount = simpleCount;
                    else
                        doubleCount = doubleCount + 1;
                        groupPart = doubleGroupPart;
                        curCount = doubleCount;
                    end
                    fishData = groupPart.fishes[curCount];
                    fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
                    fishObj:SetParent(group1_transform);
                    V_Vector3_Value.x = x;
                    V_Vector3_Value.y = y;
                    V_Vector3_Value.z = 0;
                    fishObj:SetLocalPosition(V_Vector3_Value);
                    V_Vector3_Value.x = 0;
                    V_Vector3_Value.y = 90;
                    --V_Vector3_Value.z = 0;
                    fishObj:SetLocalEulerAngles(V_Vector3_Value);
                    V_Vector3_Value.x = 0.8;
                    V_Vector3_Value.y = 0.8;
                    V_Vector3_Value.z = 0.8;
                    fishObj:SetLocalScale(V_Vector3_Value);
                    self:AddFish(fishObj);
                    fishObj:RegEvent(self,self.OnFishEvent);               
                end   --if createFishCount>0 then              
            end  --for j=1,totalCount do


            simpleGroupPart = _fishGroupData.fishGroupParts[2 + everyCount];
            doubleGroupPart = _fishGroupData.fishGroupParts[3 + everyCount];
            totalCount = simpleGroupPart.fishCount + doubleGroupPart.fishCount;
            simpleCount = 0;
            doubleCount = 0;
            hudu  = 2 * MATH_PI / totalCount;
            for j=1,totalCount do  
                if createFishCount>0 then
                    createFishCount = createFishCount - 1;
                else  --if createFishCount>0 then
                    curHudu = hudu*(j-1);
                    x = r * MATH_COS(curHudu);
                    y = r * MATH_SIN(curHudu); 
                    z = 0;
                    if j%2==1 then
                        simpleCount = simpleCount + 1;
                        groupPart = simpleGroupPart;
                        curCount = simpleCount;
                    else
                        doubleCount = doubleCount + 1;
                        groupPart = doubleGroupPart;
                        curCount = doubleCount;
                    end
                    fishData = groupPart.fishes[curCount];
                    fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
                    fishObj:SetParent(group2_transform);
                    V_Vector3_Value.x = x;
                    V_Vector3_Value.y = y;
                    V_Vector3_Value.z = 0;
                    fishObj:SetLocalPosition(V_Vector3_Value);
                    V_Vector3_Value.x = 0;
                    V_Vector3_Value.y = 90;
                    --V_Vector3_Value.z = 0;
                    fishObj:SetLocalEulerAngles(V_Vector3_Value);
                    V_Vector3_Value.x = 0.8;
                    V_Vector3_Value.y = 0.8;
                    V_Vector3_Value.z = 0.8;
                    fishObj:SetLocalScale(V_Vector3_Value);
                    self:AddFish(fishObj);
                    fishObj:RegEvent(self,self.OnFishEvent);               
                end   --if createFishCount>0 then              
            end  --for j=1,totalCount do
        elseif i==3 then  --elseif i==2 then
            simpleGroupPart = _fishGroupData.fishGroupParts[4];
            doubleGroupPart = _fishGroupData.fishGroupParts[5];
            totalCount = simpleGroupPart.fishCount + doubleGroupPart.fishCount;
            simpleCount = 0;
            doubleCount = 0;
            hudu  = 2 * MATH_PI / totalCount;
            for j=1,totalCount do
                if createFishCount>0 then
                    createFishCount = createFishCount - 1;
                else  --if createFishCount>0 then
                    curHudu = hudu*(j-1);
                    x = r * MATH_COS(curHudu);
                    y = r * MATH_SIN(curHudu); 
                    z = 0;
                    if j%2==1 then
                        simpleCount = simpleCount + 1;
                        groupPart = simpleGroupPart;
                        curCount = simpleCount;
                    else
                        doubleCount = doubleCount + 1;
                        groupPart = doubleGroupPart;
                        curCount = doubleCount;
                    end
                    fishData = groupPart.fishes[curCount];
                    fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
                    fishObj:SetParent(group1_transform);
                    V_Vector3_Value.x = x;
                    V_Vector3_Value.y = y;
                    V_Vector3_Value.z = 0;
                    fishObj:SetLocalPosition(V_Vector3_Value);
                    V_Vector3_Value.x = 0;
                    V_Vector3_Value.y = 90;
                    --V_Vector3_Value.z = 0;
                    fishObj:SetLocalEulerAngles(V_Vector3_Value);
                    V_Vector3_Value.x = 0.8;
                    V_Vector3_Value.y = 0.8;
                    V_Vector3_Value.z = 0.8;
                    fishObj:SetLocalScale(V_Vector3_Value);
                    self:AddFish(fishObj);
                    fishObj:RegEvent(self,self.OnFishEvent);                    
                end  --if createFishCount>0 then              
            end  --for j=1,totalCount do

            simpleGroupPart = _fishGroupData.fishGroupParts[4 + everyCount];
            doubleGroupPart = _fishGroupData.fishGroupParts[5 + everyCount];
            totalCount = simpleGroupPart.fishCount + doubleGroupPart.fishCount;
            simpleCount = 0;
            doubleCount = 0;
            hudu  = 2 * MATH_PI / totalCount;
            for j=1,totalCount do
                if createFishCount>0 then
                    createFishCount = createFishCount - 1;
                else  --if createFishCount>0 then
                    curHudu = hudu*(j-1);
                    x = r * MATH_COS(curHudu);
                    y = r * MATH_SIN(curHudu); 
                    z = 0;
                    if j%2==1 then
                        simpleCount = simpleCount + 1;
                        groupPart = simpleGroupPart;
                        curCount = simpleCount;
                    else
                        doubleCount = doubleCount + 1;
                        groupPart = doubleGroupPart;
                        curCount = doubleCount;
                    end
                    fishData = groupPart.fishes[curCount];
                    fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
                    fishObj:SetParent(group2_transform);
                    V_Vector3_Value.x = x;
                    V_Vector3_Value.y = y;
                    V_Vector3_Value.z = 0;
                    fishObj:SetLocalPosition(V_Vector3_Value);
                    V_Vector3_Value.x = 0;
                    V_Vector3_Value.y = 90;
                    --V_Vector3_Value.z = 0;
                    fishObj:SetLocalEulerAngles(V_Vector3_Value);
                    V_Vector3_Value.x = 0.8;
                    V_Vector3_Value.y = 0.8;
                    V_Vector3_Value.z = 0.8;
                    fishObj:SetLocalScale(V_Vector3_Value);
                    self:AddFish(fishObj);
                    fishObj:RegEvent(self,self.OnFishEvent);                 
                end  --if createFishCount>0 then              
            end  --for j=1,totalCount do
        end -- if i==1 then --elseif i==3 then
       
    end --for i=1,3 do

    self._asyncCreateFish = false;
end

function _CFishMoveBottomCircleGroup:Update(dt)
    self.runTime = self.runTime + dt;
    if self.runTime >= self.totalUseTime + 1 then
        self:OnTimeOut();
    end
    local group = self.groups[1];
    local bp = group.beginPos;
    local speed = group.speed;
    local rt = self.runTime;
    V_Vector3_Value.x = bp.x + speed.x*rt;
    V_Vector3_Value.y = bp.y + speed.y*rt;
    V_Vector3_Value.z = bp.z + speed.z*rt;
    group.transform.localPosition = V_Vector3_Value;

    group = self.groups[2];
    bp = group.beginPos;
    speed = group.speed;
    rt = self.runTime;
    V_Vector3_Value.x = bp.x + speed.x*rt;
    V_Vector3_Value.y = bp.y + speed.y*rt;
    V_Vector3_Value.z = bp.z + speed.z*rt;
    group.transform.localPosition = V_Vector3_Value;
end

--local _CBallFish = class("_CBallFish",_CGroupFish);
local _CBallFish = class(nil,_CGroupFish);

function _CBallFish:ctor(_fishObj,_circle)
    _CBallFish.super.ctor(self,_fishObj);
    self.circle = _circle;
end

function _CBallFish:Circle()
    return self.circle;
end


--local _CFishBallGroup = class("_CFishBallGroup",_CFishGroup);
local _CFishBallGroup = class(nil,_CFishGroup);

function _CFishBallGroup:ctor(_fishCreator)
    _CFishBallGroup.super.ctor(self,_fishCreator);
    self.circles = {};
    --�뾶
    self._radius = {0,2.5,2.5,1.4,1.4,1.4,1.4,};
    --��ת�ٶ�
    self._rotationSpeeds = {0,0,0,45,45,45,45,};
    --����λ��
    self._offsetPos    = {VECTOR3NEW(0,-0.4,0),VECTOR3NEW(0,-0.4,0),VECTOR3NEW(0,-0.4,0),nil,nil,nil,nil};
    --���˻���
    self._offsetRadian = {0,math.pi,0,0,0,0,0};
    --����ʱ��
    self._runTime= 0;


    --��ʼλ��
    self.beginPos  = VECTOR3NEW(7.3,0.1,-7);

    --���й���
    self.moveTime = 10;
    self.speed   = VECTOR3NEW(-self.beginPos.x/self.moveTime,0,0);
    self.waitTime= 40;
    self.runTime = 0;
    self.step=1;
    self.curPos = self.beginPos;
    self.circleCount = 0;
end

function _CFishBallGroup:AsyncInit(_parent,_fishGroupData)
    _CFishBallGroup.super.AsyncInit(self,_parent,_fishGroupData);

    local gameObject;
    local transform ;

    local gameObject = GAMEOBJECT_NEW();
    local transform = gameObject.transform;
    --�㳱�ܽڵ�
    self.gameObject = gameObject
    --self.gameObject.name = "FishBallGroup";
    self.transform  = transform;
    transform:SetParent(_parent);
    transform.localScale = C_Vector3_One;
    --self.transform.localPosition = Vector3.New(0,0,-5);
    transform.localPosition = self.beginPos;
    transform.localRotation= C_Quaternion_Zero;


    local circleCount = _fishGroupData.fishPartCount;
    local circle;
    local rotationOffSet = 360 /8;
    local curRotationOffSet = 0;

    for i=1,circleCount do
        circle = {};
        self.circles[i] = circle;
        local gameObject = GAMEOBJECT_NEW();
        local transform1  = gameObject.transform; 
        circle.gameObject = gameObject;
        circle.transform  = transform1;
        transform1:SetParent(transform);
        transform1.localPosition = C_Vector3_Zero;
        circle.rotationSpeed = self._rotationSpeeds[i];
        circle.offsetPos     = self._offsetPos[i] or C_Vector3_Zero;
        circle.beginRotation = QUATERNION_EULER(0,-90,0);
        if circle.rotationSpeed ==0 then
            circle.rotationOffSet = 0 ;
            --����Ĭ����ת�Ƕ�
            transform1.localRotation = C_Quaternion_Zero;
        else
            curRotationOffSet = curRotationOffSet + rotationOffSet;
            circle.rotationOffSet = curRotationOffSet;
            --����Ĭ����ת�Ƕ�
            V_Vector3_Value.x = circle.rotationOffSet;
            V_Vector3_Value.y = 0;
            V_Vector3_Value.z = 0;
            transform1.localEulerAngles = V_Vector3_Value;
        end
        circle.fishMap = {};
    end

    --���㳱����ʱ��
    self.runTime = 0;
end


function _CFishBallGroup:AsyncCreateFish(_dt)
    if not self._asyncCreateFish then
        return ;
    end
    local gameObject;
    local transform;
    local needCreateCount=1;
    local _fishGroupData = self._fishGroupData;

    local createFishCount = self._asyncCreateCount;
    local everyCount = _fishGroupData.fishPartCount/2; 
    local r;
    local groupPart;
    local simpleGroupPart,doubleGroupPart;
    local totalCount;
    local fishData;
    local fishObj;
    local groupFish;
    local hudu,curHudu;
    local x,y,z;
    local simpleCount,doubleCount;
    local curCount;


    local circleCount = _fishGroupData.fishPartCount;
    local circle;
    local curHudu;
    local hudu;
    local curRotationOffSet = 0;
    local offsetRadian;
    local offsetRotation;
    local offsetPos;
    local fish;

    self.circleCount = circleCount;
    for i=1,circleCount do
        r = self._radius[i];
        offsetRadian = self._offsetRadian[i];

        circle = self.circles[i];
        transform = circle.transform;
        groupPart = _fishGroupData.fishGroupParts[i];
        totalCount = groupPart.fishCount;
        offsetRotation = circle.rotationOffSet;
        offsetPos = circle._offsetPos;
        hudu = 2 * MATH_PI / totalCount;
        for j=1,totalCount do
            if createFishCount>0 then 
                createFishCount = createFishCount - 1;
            else --if createFishCount>0 then
                if needCreateCount<=0 then
                    return ;
                else
                    needCreateCount = needCreateCount - 1;
                    curHudu = hudu*(j-1);
                    x = r * MATH_COS(curHudu + offsetRadian) + offsetPos.x;
                    z = r * MATH_SIN(curHudu + offsetRadian) + offsetPos.z; 
                    y = 0 + offsetPos.y;
                    fishData = groupPart.fishes[j];
                    fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
                    fish = _CBallFish.New(fishObj,i);
                    fishObj:SetParent(transform);
                    V_Vector3_Value.x = x;
                    V_Vector3_Value.y = y;
                    V_Vector3_Value.z = z;
                    fishObj:SetLocalPosition(V_Vector3_Value);
                    --fishObj:SetLocalRotation(Quaternion.Euler(0,-90,-offsetRotation));
                    fishObj:SetRotation(circle.beginRotation);
                    V_Vector3_Value.x = 0.8;
                    V_Vector3_Value.y = 0.8;
                    V_Vector3_Value.z = 0.8;
                    fishObj:SetLocalScale(V_Vector3_Value);
                    self:AddFish(fish);
                    circle.fishMap[fishData.fishId]=fish;
                    fishObj:RegEvent(self,self.OnFishEvent);  
                end 
            end         
        end
    end
end


function _CFishBallGroup:AsyncCreateLeftFish()
    if not self._asyncCreateFish then
        return ;
    end
    local gameObject;
    local transform;
    local needCreateCount=1;
    local _fishGroupData = self._fishGroupData;

    local createFishCount = self._asyncCreateCount;
    local r;
    local groupPart;
    local simpleGroupPart,doubleGroupPart;
    local totalCount;
    local fishData;
    local fishObj;
    local groupFish;
    local hudu,curHudu;
    local x,y,z;
    local simpleCount,doubleCount;
    local curCount;


    local circleCount = _fishGroupData.fishPartCount;
    local circle;
    local curHudu;
    local hudu;
    local curRotationOffSet = 0;
    local offsetRadian;
    local offsetRotation;
    local offsetPos;
    local fish;

    self.circleCount = circleCount;
    for i=1,circleCount do
        r = self._radius[i];
        offsetRadian = self._offsetRadian[i];
        circle = self.circles[i];
        transform = circle.transform;
        groupPart = _fishGroupData.fishGroupParts[i];
        offsetPos = self._offsetPos[i] or VECTOR3ZERO();
        totalCount = groupPart.fishCount;
        offsetRotation = circle.rotationOffSet;
        hudu = 2 * MATH_PI / totalCount;
        for j=1,totalCount do
            curHudu = hudu*(j-1);
            x = r * MATH_COS(curHudu + offsetRadian) + offsetPos.x;
            z = r * MATH_SIN(curHudu + offsetRadian) + offsetPos.z; 
            y = 0 + offsetPos.y;
            fishData = groupPart.fishes[j];
            fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
            fish = _CBallFish.New(fishObj,i);
            fishObj:SetParent(transform);
            V_Vector3_Value.x = x;
            V_Vector3_Value.y = y;
            V_Vector3_Value.z = z;
            fishObj:SetLocalPosition(V_Vector3_Value);
            --fishObj:SetLocalRotation(Quaternion.Euler(0,-90,-offsetRotation));
            fishObj:SetRotation(circle.beginRotation);
            V_Vector3_Value.x = 0.8;
            V_Vector3_Value.y = 0.8;
            V_Vector3_Value.z = 0.8;
            fishObj:SetLocalScale(V_Vector3_Value);
            self:AddFish(fish);
            circle.fishMap[fishData.fishId]=fish;
            fishObj:RegEvent(self,self.OnFishEvent);       
        end
    end
    self.step = 1;
end

function _CFishBallGroup:Update(_dt)
    _CFishBallGroup.super.Update(self,_dt);
    local circleCount = self.circleCount;
    local circle;
    local rotation;
    local offsetRotation;
    local transform;
    local it;
    local val;
    for i=1,circleCount do
        circle = self.circles[i];
        if circle.rotationSpeed==0 then
        else
            rotation = circle.rotationSpeed * _dt;
            offsetRotation = circle.rotationOffSet + rotation;
            circle.rotationOffSet  = offsetRotation;
            transform = circle.transform;
            V_Vector3_Value.x = offsetRotation;
            V_Vector3_Value.y = 0;
            V_Vector3_Value.z = 0;
            transform.localEulerAngles = V_Vector3_Value;
            local fishMap = circle.fishMap;
            local br = circle.beginRotation;
            for i,v in pairs(fishMap) do
                v:Fish():SetRotation(br);
            end
        end
    end

    --��λ��
    self.runTime = self.runTime + _dt;
    if self.step==1 then
        self.curPos = self.beginPos + self.speed* self.runTime;
        if self.curPos.x<=0 then
            self.curPos.x = 0;
            self.step=2;
            self.runTime =0;
            self.beginPos = self.curPos;
        end
        self.transform.localPosition = self.curPos;
    elseif self.step==2 then
        if self.runTime>=self.waitTime then
            self.step = 3;
            self.runTime = 0;
        end
    elseif self.step==3 then
        self.curPos = self.beginPos + self.speed* self.runTime;
        self.transform.localPosition = self.curPos;
        if self.runTime>=self.moveTime then
            --�㳱������
            self:OnTimeOut();
        end
    end
end

function _CFishBallGroup:OnFishDead(_fish,_fishId)
    local circleIndex= _fish:Circle();
    local circle =self.circles[circleIndex];
    circle.fishMap[_fishId]=nil;
    return true;
end

function _CFishGroup.Create(_parent,_creator,_fishGroupData)
    local fishGroup=nil;
    if _fishGroupData.sceneKind == G_GlobalGame.Enum_FishGroupType.FishGroup_1 then
        --������С���㳱
        fishGroup = _CFishArmyGroup.New(_creator);
        fishGroup:AsyncInit(_parent,_fishGroupData);
    elseif _fishGroupData.sceneKind == G_GlobalGame.Enum_FishGroupType.FishGroup_2 then
        --���¸����㳱
        fishGroup = _CFishMoveBottomCircleGroup.New(_creator);
        fishGroup:AsyncInit(_parent,_fishGroupData);
    elseif _fishGroupData.sceneKind == G_GlobalGame.Enum_FishGroupType.FishGroup_3 then
        --����״�㳱
        fishGroup = _CFishBallGroup.New(_creator);
        fishGroup:AsyncInit(_parent,_fishGroupData);
    elseif _fishGroupData.sceneKind == G_GlobalGame.Enum_FishGroupType.FishGroup_4 then
--        fishGroup = _CFishGroup3Ex.New(_creator);
--        fishGroup:Init(_parent,_fishGroupData);
    end
    return fishGroup;
end

return _CFishGroup;