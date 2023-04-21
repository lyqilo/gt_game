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


--???????
local CEventObject = GameRequire("EventObject");

--???????
local CAtlasNumber = GameRequire("AtlasNumber");

--???????
local CFlyGoldControl = GameRequire("FlyGoldControl");

--????????
--local CNewHandControl = GameRequire("NewHandControl");
local Enum_ScoreColumnColor = {
    Red = 0,
    Green = 1,
};

--local _CScoreColumn = class("_CScoreColumn",CEventObject);
local _CScoreColumn = class(nil,CEventObject);

--local INVALID_FISH_ID = G_GlobalGame_ConstDefine.C_S_INVALID_FISH_ID;

function _CScoreColumn:ctor(color)
    _CScoreColumn.super.ctor(self);
    self.transform      = nil;
    self.gameObject     = nil;
    self.displayCount   = 0;
    self.maxCount       = 0;
    self.preDisplayCount= 0;
    self.itemH          = 0;
    self.itemParent     = nil;
    self.scoreParent    = nil;
    self.items          = {};
    self.itemTemp       = nil;
    self.scoreBgH       = nil;
    self.displayTime    = 0;
    self.isFadeOut      = false;
    self.alpha          = 1;
    self.color          = color;
    self.allImage       = {}; 
    self.endPosition    = nil;
    self.isMove         = false;
end

function _CScoreColumn:Init(transform,sprCreator)
    self.transform  = transform;
    self.gameObject = transform.gameObject;
    self.itemParent = transform:Find("Items");
    self.scoreParent= transform:Find("ScoreBg");
    self.allImage[0]= self.scoreParent:GetComponent(ImageClassType);
    self.scoreRectTransform = self.scoreParent:GetComponent("RectTransform");
    self.defaultW   = self.scoreRectTransform.sizeDelta.x;
    self.defaultH   = self.scoreRectTransform.sizeDelta.y;
    self.itemTemp   = self:AddGoldItem();
    --self.itemTemp   = self.itemParent:Find("Item").gameObject;
    self.maxCount   = 1;
    self.items[1]   = self.itemTemp;
    self.allImage[1]= self.itemTemp:GetComponent(ImageClassType);
    local spr       = self.allImage[1].sprite;
    self.itemH      = spr.rect.size.y;
    self.displayCount   = 1;
    self.getScoreLabel  = CAtlasNumber.New(sprCreator);
    self.getScoreLabel:SetParent(self.scoreParent);

    spr             = self.scoreParent:GetComponent(ImageClassType).sprite;
    self.scoreBgH      = spr.rect.size.y;
end

function _CScoreColumn:Color()
    return self.color;
end

function _CScoreColumn:AddGoldItem()
    local item = G_GlobalGame_goFactory:createGoldItem();
    item.transform:SetParent(self.itemParent);
    item.transform.localPosition = C_Vector3_Zero;
    item.transform.localScale    = C_Vector3_One;
    item.transform.localRotation = C_Quaternion_Zero;
    --item.name = "Item";
    return item;
end

--???÷????????
function _CScoreColumn:SetScore(_score,_displayerTime)
    local count = math.floor(_score/3168000*62)+1;
    self.gameObject:SetActive(true);
    self:_setDisplayCount(count,_score);
    self.displayTime = _displayerTime;
    self.isFadeOut = false;
end

--????
function _CScoreColumn:Hide()
    self.gameObject:SetActive(false);
end

--???????????
function _CScoreColumn:SetLocalPosition(localPosition)
    self.transform.localPosition = localPosition;
end

--???y???λ??
function _CScoreColumn:SetEndPosition(localEndPosition)
    if self.isMove then
        self.transform.localPosition = self.endPosition;
    end
    self.isMove = true;
    self.endPosition = localEndPosition;
end

function _CScoreColumn:_setDisplayCount(_count,_score)
    if _count>40 then
        _count = 40;
    end
    if _count<2 then
        _count=2;
    end
    if self.maxCount< _count then
        --???????????item;
        local count = _count-self.maxCount;
        local item;
        local image;
        local beginY = self.itemH *(self.maxCount);
        for i=1,count do
            item = self:AddGoldItem();
            item.transform.localPosition = VECTOR3NEW(0,beginY,0);
            beginY = beginY + self.itemH;
            self.items[self.maxCount+1] = item;
            self.maxCount = self.maxCount + 1;
            self.allImage[#self.allImage+1] = item:GetComponent(ImageClassType);
        end
    else
            
    end
    if self.preDisplayCount>_count then
        for i=_count+1,self.preDisplayCount do
            self.items[i]:SetActive(false);
        end
    elseif self.preDisplayCount<_count then
        for i=self.preDisplayCount+1,_count do
            self.items[i]:SetActive(true);
        end
    end
    self.preDisplayCount = _count;

    --???÷????????λ??
    local y = self.itemH *(_count-1)+0.5 *self.itemH + self.scoreBgH/2;
    self.scoreParent.localPosition = VECTOR3NEW(0,y,0);

    --???÷???
    self.getScoreLabel:SetNumber(_score);
    local w = self.getScoreLabel:Width();
    if w<self.defaultW-20 then
        self.scoreRectTransform.sizeDelta =Vector2.New(self.defaultW,self.defaultH);
    else
        self.scoreRectTransform.sizeDelta =Vector2.New(w+20,self.defaultH);
    end
end

--????alpha?
function _CScoreColumn:SetAlpha(_a)
    self.alpha = _a;
    self.getScoreLabel:SetAlpha(_a);
    local color = nil;
    for i=0,#self.allImage do
        color = self.allImage[i].color;
        self.allImage[i].color =COLORNEW(color.r,color.g,color.b,_a);
    end
end

function _CScoreColumn:Update(_dt,_moveToward)
    if self.isMove then
        --???????
        local moveDis = _moveToward * G_GlobalGame_GameConfig_SceneConfig.goldColumnMoveSpeed*_dt;
        local x = self.transform.localPosition.x;
        x = x + moveDis;
        if _moveToward<0 then
            if self.endPosition.x>= x then
                self.transform.localPosition = self.endPosition;
                self.isMove = false;
            else
                self.transform.localPosition = self.transform.localPosition + VECTOR3NEW(moveDis,0,0);
            end
        else
            if self.endPosition.x<= x then
                self.transform.localPosition = self.endPosition;
                self.isMove = false;
            else
                self.transform.localPosition = self.transform.localPosition + VECTOR3NEW(moveDis,0,0);
            end
        end
    end
    if self.isFadeOut then
        self.alpha = self.alpha - 0.5*_dt;
        if self.alpha<0 then
            self.alpha=0;
            --???????
            self:SendEvent(G_GlobalGame_EventID.ScoreColumnDisappear);
        end
        self:SetAlpha(self.alpha);
    else
        self.displayTime = self.displayTime - _dt;
        if self.displayTime>0 then
        else
            --?????
            self.isFadeOut = true;
        end
    end
end

--???????
function _CScoreColumn:Normal()
    self:SetAlpha(1);
    self.isFadeOut = false;
end

--????
function _CScoreColumn:FadeOut()
    self.isFadeOut = true;
    self:SetAlpha(0.6);
end

--????????????
function _CScoreColumn:IsOver()
    return self.displayTime<=0;
end


--???????
--local _CScoreColumnsControl = class("_CScoreColumnsControl");
local _CScoreColumnsControl = class(nil);

function _CScoreColumnsControl:ctor(displayCount,displayTime,moveToward)
    self.displayingVec  = {};
    --?????б?
    self.cacheColorMap  = {{},{}};
    self.displayCount   = displayCount;
    self.displayTime    = displayTime;
    self.points         = {};
    self.transform      = nil;
    self.gameObject     = gameObject;
    self.color          = 0;
    self.delCount       = 0;
    self.moveToward     = moveToward;
end


function _CScoreColumnsControl:Init(transform)
    self.transform = transform;
    self.gameObject = gameObject; 

    local numberImage = transform:Find("Numbers"):GetComponent(ImageAnimaClassType);
    self.numbers        = {};
    local count=numberImage.lSprites.Count;
    for i=0,count-1 do
        self.numbers[tostring(i)] =numberImage.lSprites[i];
    end
    local columns = transform:Find("Columns");
    local childCount = columns.childCount;
    local child=columns:GetChild(0);
    local scoreColumn;
    local dis = G_GlobalGame_GameConfig_SceneConfig.goldColumnDis
    self.points[0] = child.localPosition;
    for i=1,self.displayCount + 1 do 
        self.points[i] = self.points[i-1] + VECTOR3NEW(self.moveToward*dis);
    end
    self.columnsTranform = columns;
end

--???????????
function _CScoreColumnsControl:getNextColor()
    self.color = self.color==Enum_ScoreColumnColor.Red and Enum_ScoreColumnColor.Green or Enum_ScoreColumnColor.Red;
    return self.color;
end

--???????
function _CScoreColumnsControl:DisplayScore(_score)
    local function createSprite(_chr)
        return self.numbers[_chr];
    end
    local vec =self.displayingVec;
    if #vec>=self.displayCount then
        local scoreColumn = vec[G_GlobalGame_GameConfig_SceneConfig.goldColumn];
        --????
        scoreColumn:FadeOut();
    end
    local color = self:getNextColor();
    local vec = self.cacheColorMap[color];
    local scoreColumn = nil;
    if #vec<1 then
        --??л???
        scoreColumn = _CScoreColumn.New(color);
        local obj = G_GlobalGame_goFactory:createScoreColumn(color);
        scoreColumn:Init(obj.transform,createSprite);
    else
        scoreColumn = table.remove(vec);
        scoreColumn:Normal();
    end
    scoreColumn:RegEvent(self,self.OnScoreColumnEvent);
    scoreColumn:SetParent(self.columnsTranform);
    scoreColumn:SetScore(_score,self.displayTime);
    table.insert(vec,1,scoreColumn);
    scoreColumn:SetLocalPosition(self.points[0]);
    --???????
    scoreColumn:SetLocalRotation(C_Quaternion_Zero);
    --????λ??
    for i=1,#vec do
        if self.points[i]~=nil then
            vec[i]:SetEndPosition(self.points[i]);
        end
    end
end

function _CScoreColumnsControl:OnScoreColumnEvent(_eventId,_eventObj)
    if _eventId == G_GlobalGame_EventID.ScoreColumnDisappear then
        --?????????????
        self.delCount = self.delCount + 1;
    end
end

--?????
function _CScoreColumnsControl:Update(_dt)
    local column
    local color
    local vec = self.displayingVec;
    local cacheVec;
    while(self.delCount>0) do
        column = table.remove(vec);
        column:Cache();
        color = column:Color();
        cacheVec = self.cacheColorMap[color];
        cacheVec[#cacheVec+1] = column;
        self.delCount = self.delCount - 1;
    end

    local moveToward = self.moveToward;
    for i=1,#vec do
        vec[i]:Update(_dt,moveToward);
    end
end

function _CScoreColumnsControl:Clear()
    local vec = self.displayingVec;
    local val;
    local cacheVec;
    local color;
    for i=1,#vec do
        val = #vec[i];
        val:Cache();
        color = val:Color();
        cacheVec = self.cacheColorMap[color];
        cacheVec[#cacheVec+1] = val;
    end

    self.delCount = 0;
    self.displayingVec = {};
end

--local LockLine = class("LockLine");
local LockLine = class();
--??????
function LockLine:ctor(sep)
    self._curCount  = 0;
    self._totalCount= 0;
    self._sep       = sep;
    self._itemH     = 64;
    self._lineH     = 32;
    self._padding   = 10;
    self.gameObject = GAMEOBJECT_NEW();
    self.transform  = self.gameObject.transform;
    --self.gameObject.name = "LockLine";
    self.baseH      = self._itemH/2;
    self.lineTarget = self:AddItem();
    self.items      = {};
end

--????????
function LockLine:SetParent(_parent)
    self.transform:SetParent(_parent);
    self.transform.localScale = C_Vector3_One;
end

--????
function LockLine:Hide()
    self.gameObject:SetActive(false);
end

--???
function LockLine:Display()
    self.gameObject:SetActive(true);
end
local targetName = "Target";

--??????
function LockLine:AddItem()
    local item = G_GlobalGame_goFactory:createLockItem(self._sep);
    local transform = item.transform;
    transform:SetParent(self.transform);
    --item.name = targetName;
    transform.localPosition = C_Vector3_Zero;
    transform.localScale    = C_Vector3_One;
    V_Vector3_Value.x = 0;
    V_Vector3_Value.y = 0;
    V_Vector3_Value.z = 180;
    transform.localEulerAngles = V_Vector3_Value;
    return item;
end

local lineName = "Line";
--
function LockLine:AddLine()
    local item = G_GlobalGame_goFactory:createLockLine();
    local transform = item.transform;
    transform:SetParent(self.transform);
    --item.name = lineName;
    transform.localPosition = C_Vector3_Zero;
    transform.localScale    = C_Vector3_One;
    transform.localRotation = C_Quaternion_Zero;
    return item;
end

--????
function LockLine:Toward(localPosition,r,len)
    self.transform.localPosition = localPosition;
    V_Vector3_Value.x = 0;
    V_Vector3_Value.y = 0;
    V_Vector3_Value.z = r;
    self.transform.eulerAngles = V_Vector3_Value;
    len = len - self.baseH - self._padding;
    local needCount = math.floor(len/(self._lineH+self._padding));
    local needLen = needCount*(self._lineH+self._padding);
    local lessLen = len - needLen + self._padding;
    if lessLen> 0 then
        --????2??
        needCount = needCount + 2;
    else
        needCount = needCount + 1;
    end
    if needCount==self._curCount then
        return ;
    end
    if needCount>self._totalCount then
        local count = needCount-self._totalCount;
        local item;
        local image;
        local beginY = (self._lineH + self._padding) *(self._totalCount)+self._lineH/2 + self.baseH + self._padding;
        for i=1,count do
            item = self:AddLine();
            item.transform.localPosition = VECTOR3NEW(0,beginY,0);
            beginY = beginY + (self._lineH + self._padding);
            self.items[self._totalCount+1] = item;
            self._totalCount = self._totalCount + 1;
        end
    end

    if self._curCount>needCount then
        for i=needCount+1,self._curCount do
            self.items[i]:SetActive(false);
        end
    elseif self._curCount<needCount then
        for i=self._curCount+1,needCount do
            self.items[i]:SetActive(true);
        end
    end
    self._curCount = needCount;
end


local ENUM_UI_EffectType =
{
    KillBigFish  = 1,
    XingXing     = 2,
};


--local _CUIEffect = class("_CUIEffect",CEventObject);
local _CUIEffect = class(nil,CEventObject);

local UIEffect_ID = 1;

function _CUIEffect:ctor(_type)
    _CUIEffect.super.ctor(self);
    self._id = UIEffect_ID;
    self._type = _type;
    UIEffect_ID = UIEffect_ID + 1;
end

function _CUIEffect:ID()
    return self._id;
end

function _CUIEffect:Type()
    return self._type;
end

--?????
function _CUIEffect:Update(_dt)

end

--????
function _CUIEffect:Hide()
    self.gameObject:SetActive(false);
end

--?????
function _CUIEffect:Disappear()
    self.gameObject:SetActive(false);
    self:SendEvent(G_GlobalGame_EventID.UIEffectDisappear);
end

local colorIdCreator = ID_Creator(1);


--local _CUIKillFish = class("_CUIKillFish",_CUIEffect);
local _CUIKillFish = class(nil,_CUIEffect);

function _CUIKillFish:ctor()
    _CUIKillFish.super.ctor(self,ENUM_UI_EffectType.KillBigFish);
    self._chairId  = nil;
    self._fishType = nil;
    self._gold     = nil;
    self._goldNumberLabel = nil;


    self._fishNameMap = map:new();
    self._curNameTrans=nil;
    self._waitTime = 3.2;
end

function _CUIKillFish.Create(transform)
    local killFish = _CUIKillFish.New();
    killFish:_initStyle(transform);
    return killFish;
end

--???
function _CUIKillFish:_initStyle(transform)
    self.gameObject = transform.gameObject;
    self.transform  = transform;

    local killFishTag = transform:Find("KillTag");
    local childCount  = killFishTag.childCount;
    local child;
    local number;
    for i=1,childCount do
        child = killFishTag:GetChild(i-1);
        number = tonumber(child.gameObject.name);
        self._fishNameMap:assign(number,child);
    end

    local getScore = transform:Find("GetScore");
    self._goldNumberLabel = G_GlobalGame:CreateAtlasNumber(getScore);

    --?????????????
    self._goldNumberControl = {
        goldNumberLabel = nil,
        maxOffsetY  = -35,
        speed       = 150,
        createInterval = 0.07, --?????????
        offsetPos   = VECTOR3ZERO(),
        step        = 0,
        waitTime    = 0,
        init  = function(self,goldNumberLabel)
            self._goldNumberCreateIndex =0;
            self.goldNumberLabel = goldNumberLabel;
            self._isCreateNumber = false;
        end,
        update = function(self,_dt)
            while(_dt>0) do
                _dt = self:execute(_dt);
            end
        end,
        execute = function(self,_dt)
            if not self._isCreateNumber then
                return 0;
            end
            if self.step == 1 then
                self.waitTime = self.waitTime - _dt;
                if self.waitTime <=0 then
                    self.step=0;
                    self:showNumber(self._goldNumberCreateIndex);
                    return -self.waitTime;
                end
                return 0;
            end
            local y = self.speed * _dt;
            local curIsOver =false;
            local leftDt =0;
            self.offsetPos.y = self.offsetPos.y + y;
            if self.offsetPos.y>=0 then
                leftDt = self.offsetPos.y /self.speed;
                self.offsetPos.y = 0;
                curIsOver = true;
            end
            self.goldNumberLabel:OffsetPos(self._goldNumberCreateIndex,self.offsetPos);
            if curIsOver then
                if self._goldNumberCreateIndex< self._createCount then
                    self._goldNumberCreateIndex = self._goldNumberCreateIndex + 1;
                    self.step = 1;
                    self.waitTime = self.createInterval;
                else
                    self._isCreateNumber = false;
                end
            end
            return leftDt;
        end,
        reset  = function(self,gold)
            local gnl = self.goldNumberLabel;
            gnl:SetNumber(gold);
            gnl:HideNumbers();
            self._goldNumberCreateIndex = 1;
            self._createCount = gnl:NumberCount();
            self._isCreateNumber = true;
            self:showNumber(self._goldNumberCreateIndex);
            self.step = 0;
        end,
        showNumber = function(self,index)
            self.offsetPos.y = self.maxOffsetY;
            self.goldNumberLabel:ShowNumber(index);
            self.goldNumberLabel:OffsetPos(index,self.offsetPos);
        end,
    };
    --?????
    self._goldNumberControl:init(self._goldNumberLabel);

    local obj = G_GlobalGame_goFactory:createEffect(G_GlobalGame_Enum_EffectType.FishDead);
    G_GlobalGame:DispatchEvent(G_GlobalGame_EventID.NotifyAddEffect,obj);

    self._effectTransform = obj.transform;

    --??????Ч
    self._particleSystem = obj.transform:GetComponent(ParticleSystemClassType);

    self._step = 0;
    self._runTime = 0;
end

--?????????
function _CUIKillFish:_initData(_chairId,_fishType,_gold,_isShowWinFishGold,_playerControl)
    self._chairId  =  _chairId;
    self._gold     =  _gold;
    self._fishType = _fishType;
    self._isShowWinFishGold = _isShowWinFishGold;
    self._playerControl  = _playerControl;
    local it = self._fishNameMap:iter();
    local val= it();
    local fishName;
    self.gameObject:SetActive(true);
    self._curNameTrans = nil;
    while(val) do
        if val==_fishType+1 then
            self._curNameTrans = self._fishNameMap:value(val);
            self._curNameTrans.gameObject:SetActive(true);
        else
            fishName = self._fishNameMap:value(val);
            fishName.gameObject:SetActive(false);
        end
        val = it();
    end
    --????????????
    self._goldNumberControl:reset(_gold);

    --??????????Ч
    self._particleSystem:Play();
    self._step = 1;
    self._runTime = 0;
    self._minScale = 0.6;
    self._curPos   = {x=1,y=1,z=1};
end

function _CUIKillFish:Init(_chairId, _fishType, _gold,_fishPos,_playerPos,_isShowWinFishGold,_playerControl)
    self:_initData(_chairId,_fishType,_gold,_isShowWinFishGold,_playerControl);
    local effectPosition = self._effectTransform.position;
    local worldPos = G_GlobalGame:SwitchWorldPosToWorldPosBy3DCamera(_fishPos,effectPosition.z);
    self._effectTransform.position = worldPos;
    local screenPos = G_GlobalGame:SwitchWorldPosToScreenPosBy3DCamera(_fishPos);
    local uiWorldPos = G_GlobalGame:SwitchScreenPosToWorldPosByUICamera(screenPos);
    self.transform.position  = uiWorldPos;
    self._curScale = {x=1,y=1,z=1};
    self.transform.localScale    = self._curScale;
    self.gameObject:SetActive(true);
    --???????????
    self:_countSpeedAndTime(_playerPos);

    local selfPosition = self.transform.localPosition;
    local realPos = {x=selfPosition.x,y=selfPosition.y,z=selfPosition.z};
    local isChange = false;
    if realPos.x<-513 then
        realPos.x = - 513;
        isChange = true;
    end
    if realPos.x>513 then
        realPos.x = 513;
        isChange = true;
    end
    if realPos.y<-323 then
        realPos.y = -323;
        isChange = true;
    end
    if realPos.y>270 then
        realPos.y = 270;
        isChange = true;
    end
    if isChange then
        self.transform.localPosition = realPos;
    end

    selfPosition = self._particleSystem.transform.localPosition;
    realPos = {x=selfPosition.x,y=selfPosition.y,z=selfPosition.z};
    isChange = false;
    if realPos.x<-0.18 then
        realPos.x = - 0.18;
        isChange = true;
    end
    if realPos.x>0.18 then
        realPos.x = 0.18;
        isChange = true;
    end
    if realPos.y<-0.1 then
        realPos.y = -0.1;
        isChange = true;
    end
    if realPos.y>0.07 then
        realPos.y = 0.07;
        isChange = true;
    end
    if isChange then
        self._particleSystem.transform.localPosition = realPos;
    end
end

--???????????
function _CUIKillFish:_countSpeedAndTime(_playerPos)
    self._playerPos = VECTOR3NEW(_playerPos.x,_playerPos.y,_playerPos.z);
    self._beginPos = self.transform.localPosition;
    self.transform.position = _playerPos;
    self._endPos   = self.transform.localPosition;
    self.transform.localPosition = self._beginPos;
    

    --??????;
    self._jumpMaxY = 180;
    --self._jumpYDisAtXMove= 200;

    --???
    self._topY     = self._beginPos.y + self._jumpMaxY;
    if self._topY<= self._endPos.y+80 then --???????????
        self._jumpMaxY = self._jumpMaxY + self._endPos.y - self._topY + 80; 
        self._topY = self._beginPos.y + self._jumpMaxY;
    end

    local xBeginMoveY = (self._topY - self._endPos.y) /9;
    xBeginMoveY = 0;
    self._jumpYDisAtXMove= self._jumpMaxY + xBeginMoveY;

    --
    self._ySpeed   = 300; 

    --?????????
    self._jumpTime = self._jumpMaxY/self._ySpeed;

    --????????
    self._fallDis = self._topY - self._endPos.y;

    local normalFallTime = self._fallDis/self._ySpeed;
    local addNormalFallTime = normalFallTime*2/5;

    self._moveTime = self._jumpTime + addNormalFallTime;
    self._yAddSpeed = (self._fallDis - self._ySpeed * addNormalFallTime )*2/(addNormalFallTime * addNormalFallTime);

    --?????????
    --self._moveTime = (self._jumpMaxY*2 + self._beginPos.y - self._endPos.y)/self._ySpeed;



    --x?????????
    self._xWaitTime = self._jumpYDisAtXMove/self._ySpeed;

    --x??????????
    self._xMoveTime = self._moveTime - self._xWaitTime;
    if self._xMoveTime<=0 then
        self._xMoveTime = 0.001;
    end

    --x?????????
    self._xAddSpeed = (self._endPos.x - self._beginPos.x)*2/(self._xMoveTime*self._xMoveTime);

    --????????
    self._scaleSpeed=(1 - self._minScale)/self._moveTime;

    --??????
    self._runTime = 0;

    --????????С
    self._beginScale=1;
end

function _CUIKillFish:Update(_dt)
    --???????
    self._goldNumberControl:update(_dt);
    while(_dt>0) do
        _dt = self:execute(_dt);
    end
end

function _CUIKillFish:execute(_dt)
    local leftDt = 0;
    local transform = self.transform;
    if self._step==1 then
        self._runTime = self._runTime + _dt;
        if self._runTime>=self._waitTime then
            if self._curNameTrans then
                self._curNameTrans.gameObject:SetActive(false);
            end
            self._step = 2;
            self._runTime = 0;
            leftDt = self._runTime - self._waitTime;
        end
    elseif self._step == 2 then
        --???????????С
        local runTime = self._runTime + _dt;  
        local jumeTime = self._jumpTime;
        --self._runTime = self._runTime + _dt;  
        if runTime>jumeTime then
            leftDt = runTime - jumeTime;
            self._step = 3;
            runTime=jumeTime;
        end
        local scale = self._beginScale - self._scaleSpeed * runTime;
        if scale<=self._minScale then
            scale = self._minScale;
        end
        local cs = self._curScale;
        cs.x = scale;
        cs.y = scale;
        cs.z = scale;
        transform.localScale    = cs;
        local curPos = self._curPos;
        local beginPos = self._beginPos;
        if runTime>self._xWaitTime then
            --x????λ??
            local moveTime = runTime - self._xWaitTime;
            curPos.x = beginPos.x +  self._xAddSpeed * moveTime * moveTime*0.5;
        else
            curPos.x = beginPos.x;
        end
        curPos.z = beginPos.z;
        curPos.y = runTime* self._ySpeed + beginPos.y;
        transform.localPosition = curPos;
        self._runTime = runTime;
    elseif self._step == 3 then
        --???????????С
        local runTime = self._runTime + _dt;   
        if runTime>=self._moveTime then
            self._step = 4;
            runTime = self._moveTime;
            self:Disappear();
        end
        local scale = self._beginScale - self._scaleSpeed * self._runTime;
        if scale<=self._minScale then
            scale = self._minScale;
        end
        local cs = self._curScale;
        cs.x = scale;
        cs.y = scale;
        cs.z = scale;
        transform.localScale    = cs;
        local curPos = self._curPos;
        local beginPos = self._beginPos;
        if runTime>self._xWaitTime then
            --x????λ??
            local moveTime = runTime - self._xWaitTime;
            if moveTime>self._xMoveTime then
                moveTime = self._xMoveTime;
            end
            curPos.x = beginPos.x +  self._xAddSpeed * moveTime * moveTime *0.5;
        else
            curPos.x = beginPos.x;
        end
        curPos.z = beginPos.z;
        local fallTime = (runTime - self._jumpTime);
        curPos.y = beginPos.y + self._jumpMaxY - fallTime* self._ySpeed - self._yAddSpeed*fallTime*fallTime*0.5 ;
        transform.localPosition = curPos;
        self._runTime = runTime;
    end
    return leftDt;
end

function _CUIKillFish:Disappear()
    _CUIKillFish.super.Disappear(self);
    if self._isShowWinFishGold then
        --?????????
        self._playerControl:WinFishGold(self._gold);
    end 
end

--local _CUIXingXing = class("_CUIXingXing",_CUIEffect);
local _CUIXingXing = class(nil,_CUIEffect);

function _CUIXingXing:ctor()
    _CUIXingXing.super.ctor(self,ENUM_UI_EffectType.XingXing);
    self.existTime = 0;
end

function _CUIXingXing.Create(transform)
    local xingxing = _CUIXingXing.New();
    xingxing:_initStyle(transform);
    return xingxing;
end

--???
function _CUIXingXing:_initStyle(transform)
    self.transform = transform;
    self.gameObject= transform.gameObject;  
    local xx = transform:Find("xx");
    --??????Ч
    self._particleSystem = xx:GetComponent(ParticleSystemClassType); 
end

function _CUIXingXing:Init(_playerPos)
    self.transform.position = _playerPos;
    self.existTime = 2;
    self._particleSystem:Play();
    self.gameObject:SetActive(true);
end

function _CUIXingXing:Update(_dt)
    if self.existTime>0 then
        self.existTime = self.existTime - _dt;
        if self.existTime<0 then
            self:Disappear();
        end
    end
end

--local _CUIEffectControl = class("_CUIEffectControl");
local _CUIEffectControl = class();

--UIЧ??????
function _CUIEffectControl:ctor(transform)
    self.transform = transform;
    self.gameObject= gameObject;
    local killBigFish = transform:Find("KillBigFish");
    self.showKillBigFishTemplate = killBigFish.gameObject;
    local xingxing    = transform:Find("XX");
    self.xingxingTemplate        = xingxing.gameObject;
    self.effectMap = {};
    self.cacheMap  = {};
    for i=ENUM_UI_EffectType.KillBigFish,ENUM_UI_EffectType.XingXing do
        self.cacheMap[i] = {};
    end
end

function _CUIEffectControl:ShowEffectKillFish(_chairId, _fishType, _gold,_fishPos,_playerPos
            ,isShowWinFishGold,playerControl)
    local vec = self.cacheMap[ENUM_UI_EffectType.KillBigFish];
    local killFish
    if #vec<1 then
        local go = newobject(self.showKillBigFishTemplate);
        local transform = go.transform;
        local localScale    = transform.localScale;
        transform:SetParent(self.transform);
        transform.localScale = localScale;
        killFish = _CUIKillFish.Create(transform);
        killFish:RegEvent(self,self.OnEffectEvent);
    else
        killFish = table.remove(vec);
    end
    killFish:Init(_chairId,_fishType,_gold,_fishPos,_playerPos,isShowWinFishGold,playerControl);
    self.effectMap[killFish:ID()] = killFish;
    return killFish;
end

function _CUIEffectControl:ShowXingXing(_playerPos)
    local vec = self.cacheMap[ENUM_UI_EffectType.XingXing];
    local xingxing
    if #vec<1 then
        local go = newobject(self.xingxingTemplate);
        local transform = go.transform;
        local localScale    = transform.localScale;
        transform:SetParent(self.transform);
        transform.localScale = localScale;
        xingxing = _CUIXingXing.Create(transform);
        xingxing:RegEvent(self,self.OnEffectEvent);
    else
        xingxing = table.remove(vec);
    end
    xingxing:Init(_playerPos);
    --????????
    G_GlobalGame:PlayEffect(G_GlobalGame_SoundDefine.Coinsfly); 
    self.effectMap[xingxing:ID()] = xingxing;
    return xingxing;
end

function _CUIEffectControl:Update(_dt)
    local effectMap = self.effectMap;
    for i,v in pairs(effectMap) do
        v:Update(_dt);
    end
end

function _CUIEffectControl:OnEffectEvent(_eventId,_uiEffect)
    if _eventId == G_GlobalGame_EventID.UIEffectDisappear then
        self.effectMap[_uiEffect:ID()] = nil;
        local vec = self.cacheMap[_uiEffect:Type()];
        vec[#vec+1] = _uiEffect;
        if _uiEffect:Type() == ENUM_UI_EffectType.KillBigFish then
            self:ShowXingXing(_uiEffect._playerPos);
        end
    end
end

--local _CPlayerControl = class("_CPlayerControl");
local _CPlayerControl = class();

function _CPlayerControl:ctor(_allPlayerControl,_bulletControl,_moveToward)
    _moveToward = _moveToward or 1;
    self._uid       = -1;
    self._tableId   = 0;
    self._chairId   = 0;
    self._isLock    = false;
    self._angle     = 0;
    self._lockFish  = nil;
    self._isAndroid = false;
    self._name      = nil;
    self._paotaiType= nil;
    self._paoStyle  = nil;
    self._bulletType= nil;
    self._bulletKind= nil
    self._isOwner   = false;
    self._isEnabled = false;
    self._fishGold  = 0;
    self._multiple  = 0;
    self.paotai     = nil;
    self._bulletControl= _bulletControl;
    self._allPlayerControl  = _allPlayerControl;
    self._fireInterval = 0;

    self._isEnergy  = false;

    --????
    self._colorIndex = colorIdCreator();

    --????????
    self._wheelTime    = 0;
    self._wheelPanel   = nil;
    self._wheelNumber  = nil;
    self._wheelAnima   = nil;
    self._wheelRotation= 0;
    self._wheelToward  = 1;

    --???????
    self._isContinueShot = false;

    --????????
    self._preAngle  = 0;

    --???????
    self._scoreColumnControl = _CScoreColumnsControl.New(G_GlobalGame_GameConfig_SceneConfig.goldColumn,G_GlobalGame.GameConfig.SceneConfig.goldColumnTime,_moveToward);
end

--?????
function _CPlayerControl:Init(transform,lockLayer)
	--logError("最后============================1")
    self.parentTransform = transform;
    self.lockLayer                  = lockLayer;
    self.lockStart                  = lockLayer:Find("Start");
    self.lockEnd                    = lockLayer:Find("End");

    --UI??????Ч??
    self._UIKillFish                = nil;

    --????????
    self.paotaiParent               = transform:Find("Paotai");
	--logError("最后============================2")
    self:_loadPaotai();
	--logError("最后============================3")
    --??????
    self:_getCtrls();

end

function _CPlayerControl:_loadPaotai()
    local player        = self:CreatePaotai();
    local transform     = player.transform;
    self.transform      = transform;
    local localScale    = transform.localScale;
    local localPosition = transform.localPosition;
    local localRotation = transform.localRotation;
    transform:SetParent(self.paotaiParent);
    transform.localScale       = localScale;
    transform.localPosition    = localPosition;
    transform.localRotation    = localRotation;
end

--??????
function _CPlayerControl:_getCtrls()
    local transform = self.transform;
    --?л???????
			--error("炮炮炮炮炮炮炮炮炮炮炮炮炮炮炮炮炮炮炮炮炮炮炮炮炮炮="..transform.name)
    local paos           = transform:Find("Paos");

    self.paos = paos;
    --??????
    self.paoContainer   = paos:Find("PaoContainer");
    --?????
    self.paoFront       = paos:Find("PaoFront");

    --????
    self.addPao         = transform:Find("Switch");
    local eventTrigger
	--logError("最后============================4")
    if self.addPao then
        eventTrigger  = Util.AddComponent("EventTriggerListener",self.addPao.gameObject);
        eventTrigger.onClick= handler(self,self._onAddPaotai);
    end
	--logError("最后============================5")
    --???????
    self.multiplePanel  = paos:Find("BulletInfo");
	--error(self.multiplePanel.name)
    self.multipleNumber = G_GlobalGame:CreateAtlasNumber(self.multiplePanel);
	--logError("最后============================5.1")
    --???
    self.fishGoldPanel  = transform:Find("FishGold");
    self.fishGoldNumber = G_GlobalGame:CreateAtlasNumber(self.fishGoldPanel,0,HorizontalAlignType.Right);
	--logError("最后============================5.2")
    --?????
    self.goldPanel  = transform:Find("Gold");
    if self.goldPanel then
        self.goldNumber = G_GlobalGame:CreateAtlasNumber(self.goldPanel,0,HorizontalAlignType.Right);
    end
	--logError("最后============================6")
    --??????
    self.getScorePanel  = transform:Find("GetScore");
    local childGetScore = self.getScorePanel:GetChild(0);
    local getScoreGroupName = childGetScore.gameObject.name;
    local CreateScoreHandler = function(name)
        return G_GlobalGame:GetSprite(getScoreGroupName,name);
    end

    self.getScoreCtrlCache = {nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil};
    self.runningScoreCtrl  = {nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil};

    self.createScoreHandler = CreateScoreHandler;

    self.showKillFishNumber = self.transform:Find("KillFishNumber");
--logError("最后============================7")
    self._changeControl = {
        nextPaoType = nil,
        step    = 0,
        curMoveY= 0,
        bottomY = -39, --????
        topY    = 11,  --????
        moveSpeed= 150, --??????
        control = nil,
        localPosition = nil,
        --?????
        Init    = function(self,transform,control)
            self.transform = transform;
            local pos = transform.localPosition;
            self.localPosition = VECTOR3NEW(pos.x,pos.y,pos.z);
            self.control = control;
            self.curMoveY = self.topY;
        end,
        --?????????
        Update  = function(self,_dt)
            if self.step==0 then
                    
            elseif self.step==1 then
                --???
                local moveDis = self.moveSpeed * _dt;
                self.curMoveY = self.curMoveY - moveDis;
                if self.curMoveY<=self.bottomY then
                    self.curMoveY = self.bottomY;
                    self.step = 2;
                    if self.nextPaoType then
                        self.control:setPaotaiType(self.nextPaoType);
                    end
                end
                self.localPosition.y = self.curMoveY;
                self.transform.localPosition = self.localPosition;
            elseif self.step==2 then
                --????
                local moveDis = self.moveSpeed * _dt;
                self.curMoveY = self.curMoveY + moveDis;
                if self.curMoveY>=self.topY then
                    self.curMoveY = self.topY;
                    self.step = 0;
                end
                self.localPosition.y = self.curMoveY;
                self.transform.localPosition = self.localPosition;
            end
        end,
        --?л??????????
        ChangeNext = function(self,_nextType)
            self.nextPaoType = _nextType;
            self.step = 1;
        end,
    };
--logError("最后============================8")
    --????????????
    self._changeControl:Init(self.paoContainer,self);
end

function _CPlayerControl:displayGetScore(_score)
    local ctrl;
    local scoreCache = self.getScoreCtrlCache;
    if #scoreCache>0 then
        ctrl = table.remove(scoreCache);
        local cl = ctrl.ctrl;
        cl:SetParent(nil);
        cl:SetParent(self.getScorePanel);
    else
        ctrl = self:createGetScore(); 
    end
    local rsc = self.runningScoreCtrl;
    local count = #rsc;
    if count>0 then
        local preCtrl = rsc[count];
        preCtrl.isSkipStep3 = true;
         
    end
    count = count + 1;
    rsc[count] = ctrl;
    local getNumberCtrl = ctrl.ctrl;
    getNumberCtrl:SetNumber(_score);
    local levelY  = -13; 
    --ctrl.curPos.y = levelY - 15;
    ctrl.curPos.y = levelY;
    ctrl.runTime  = 0;
    ctrl.alpha    = 1;  
    ctrl.step     = 1;
    ctrl.speed    = 96;
    ctrl.isSkipStep3 = false;

    getNumberCtrl:SetAlpha(ctrl.alpha);
    getNumberCtrl:SetLocalPosition(ctrl.curPos);
    --???
    getNumberCtrl:Display();
    local scale = ctrl.scale;
    scale.x = 1.2;
    scale.y = 1.2;
    scale.z = 1.2;
    getNumberCtrl:SetLocalScale(scale);

    local displayDis = 28;
    
    local y=levelY;
    local minY = y - displayDis*2; 
    for i=count,1,-1 do
        ctrl = rsc[i];
        ctrl.endPos.y = y;
        y = y + displayDis;
        if count>2 then
            if i <= count-2 then
                ctrl.step = 2;
            end
        end
        if y<minY then
            y = minY;
        end
    end
end

function _CPlayerControl:createGetScore()
    local getScoreNumber = CAtlasNumber.New(self.createScoreHandler,0,HorizontalAlignType.Right);
    getScoreNumber:SetParent(self.getScorePanel);
    getScoreNumber:DisplayAdd();
    local ctrlScoreData = 
    {
        ctrl    = getScoreNumber,
        alpha   = 1,
        runTime = 0,
        endPos  = {x=20,y=0,z=0},
        curPos  = {x=20,y=0,z=0},
        step    = 1,
        scale   = {x=1,y=1,z=1},
        scaleV  = 1,
        isSkipStep3 = false,
    };
    return ctrlScoreData;
end

function _CPlayerControl:_controlGetScoreCtrls(_dt)
    local rsc = self.runningScoreCtrl;
    local count = #rsc;
    local y = 0;
    local cache = self.getScoreCtrlCache ;
    for i=count,1,-1 do
        local ctrl = rsc[i];
        local scale = ctrl.scale;
        local step = ctrl.step;
        if step==1 then
            local scaleV = ctrl.scaleV + _dt * 3.3;
            if scaleV>=1.4 then
                scaleV = 1.4;
                ctrl.step = 2;
            end
            scale.x = scaleV;
            scale.y = scaleV;
            scale.z = scaleV;
            ctrl.scaleV = scaleV;
            ctrl.ctrl:SetLocalScale(scale);
        elseif step == 2 then
            local scaleV = ctrl.scaleV - _dt * 3.3;
            if scaleV<=1 then
                scaleV = 1;
                if ctrl.isSkipStep3 then
                    ctrl.step = 4;
                else
                    ctrl.step = 3;
                end
            end
            scale.x = scaleV;
            scale.y = scaleV;
            scale.z = scaleV;
            ctrl.scaleV = scaleV;
            ctrl.ctrl:SetLocalScale(scale);   
        elseif step == 3 then
            ctrl.runTime = ctrl.runTime + _dt;
            if ctrl.runTime>0.8 or ctrl.isSkipStep3 then
                ctrl.step = 4;
            end         
        elseif step == 4 then
            ctrl.alpha = ctrl.alpha - _dt*0.7;
            if ctrl.alpha <=0 then
                --rsc[i] = nil;
                table.remove(rsc,i);
                ctrl.ctrl:Hide();
                cache[#cache+1] = ctrl;
            else
                --?????????
                ctrl.ctrl:SetAlpha(ctrl.alpha);
            end
            local cp = ctrl.curPos;
            local ep = ctrl.endPos;
            if cp.y< ctrl.endPos.y then
                local moveDis = ctrl.speed * _dt;

                cp.y = cp.y + moveDis;
                if cp.y> ep.y then
                    cp.y = ep.y;
                end
                ctrl.ctrl:SetLocalPosition(cp);
            end
        end
    end  
end

function _CPlayerControl:getScoreNumber(chr)
    return self.scoreSprites[chr];
end

function  _CPlayerControl:_getSepNumber(chr)
    return self.wheelNumbersSprite[chr];
end

function _CPlayerControl:setPaotaiType(_paotaiType)
    local preStyle = self._paoStyle;
    self._paotaiType= _paotaiType;
    self._paoStyle  = G_GlobalGame_FunctionsLib.FUNC_GetPaotaiStyleType(_paotaiType,self._isOwner);
    local bt= G_GlobalGame_FunctionsLib.FUNC_GetBulletTypeByPaotaiType(_paotaiType);
    self._bulletKind= G_GlobalGame_FunctionsLib.FUNC_GetBulletKind(bt);
    local mp  = G_GlobalGame_FunctionsLib.FUNC_GetBulletMultiple(bt);
    self._bulletType = bt;
    if mp==nil then
        mp = 0;
        error("PaotaiType:" .. self._paotaiType);
        error("_bulletType:" .. bt);
    end
    self._multiple   = mp;
    self.multipleNumber:SetNumber(mp);
    if preStyle ~= self._paoStyle then
        self:_renewStyle();
    end
end

local paoShotName = "Shot";
local paoBodyName = "Body";

--???????
function _CPlayerControl:_renewStyle()
    --??????????
    local paotai = self.paotai;
    if paotai then
        destroy(paotai);
        paotai = nil;
    end
    local pao
    if self._isEnergy then
        pao = G_GlobalGame_goFactory:createPaotai(self._paotaiType,self._isOwner);
    else
        pao = G_GlobalGame_goFactory:createPaotai(self._paotaiType,self._isOwner);
    end
    paotai  = pao;
    self.paotai = paotai;
    local Ptransform    = pao.transform;
    local localScale    = Ptransform.localScale;
    local localPosition = Ptransform.localPosition;
    local localRotation = Ptransform.localRotation;
    Ptransform:SetParent(self.paoContainer);
    Ptransform.localScale       = localScale;
    Ptransform.localPosition    = localPosition;
    Ptransform.localRotation    = localRotation;
    self.shotTrans = Ptransform:Find(paoShotName);
    self.shotAnima = Ptransform:Find(paoBodyName):GetComponent(ImageAnimaClassType);
end

--??????
function _CPlayerControl:_removePaotai()
    if self.paotai then
        destroy(self.paotai);
        self.paotai = nil;
    end
    self._paoStyle  = nil;
end

--???????
function _CPlayerControl:CreatePaotai()
    return G_GlobalGame_goFactory:createPlayer(self._isOwner);
end

--????????????
function _CPlayerControl:CalculateNext()

end

--?????
function _CPlayerControl:KillFish(_fishType,_gold)
--    if self._UIKillFish then
--        self._UIKillFish:Init(self._chairId,_fishType,_gold);
--    else
--        self._UIKillFish = _CUIKillFish.Create(self.parentTransform);
--        self._UIKillFish:Init(self._chairId,_fishType,_gold);
--    end
end

--????λ??
function _CPlayerControl:FlyGoldPosition()
    return self.paos.position;
end

--?????Number???λ??
function _CPlayerControl:KillFishNumberPosition()
    return self.showKillFishNumber.position;
end

function _CPlayerControl:Lock()
    self._isLock = true;
end

function _CPlayerControl:Unlock()
    self._isLock = false;
end

--??????????????
function _CPlayerControl:IsCanShotY(_y)
    --return self.paos.position.y<_y-15;
    return self.paos.position.y<_y;
end

--???????
function _CPlayerControl:IsContinueShot()
    return self._isContinueShot;
end

--????
function _CPlayerControl:ContinueShot()
    self._isContinueShot = true;
end

--???????
function _CPlayerControl:NormalShot()
    self._isContinueShot = false;
end

--
function _CPlayerControl:Update(_dt)
    --????÷?
    self:_controlGetScoreCtrls(_dt);
    if self:IsEmpty() then
        return ;
    end

    if self._fireInterval >0 then
        self._fireInterval = self._fireInterval - _dt;
    end
    --????
    self:_controlPopTip(_dt);

    --?????л???
    self._changeControl:Update(_dt);

    if self._UIKillFish then
        --?????Ч??
        self._UIKillFish:Update(_dt);
    end

end

--???????????
function _CPlayerControl:_controlPowerFlag(_dt)
    --[[
    if self._isPower then
        self._powerMoveTime = self._powerMoveTime + _dt;
        local moveDis = self._powerSpeedVec[self._powerSpeedIndex] * _dt;
        self._powerFlag.localPosition = self._powerFlag.localPosition + moveDis;
        if self._powerEveryMoveTime<=self._powerMoveTime then
            self._powerMoveTime = 0;
            self._powerSpeedIndex= self._powerSpeedIndex + 1;
            if self._powerSpeedIndex>4 then
                self._powerSpeedIndex = 1;
            end
        end
    end
    --]]
end

--???????????
function _CPlayerControl:_controlLockFlag(_dt)
    --[[
    if self._lockFish then
        self._lockFishMoveTime = self._lockFishMoveTime + _dt;
        local moveDis = self._lockFishSpeedVec[self._lockFishSpeedIndex] * _dt;
        self._lockFishTrans.localPosition = self._lockFishTrans.localPosition + moveDis;
        if self._lockFishEveryMoveTime <=self._lockFishMoveTime then
            self._lockFishMoveTime = 0;
            self._lockFishSpeedIndex= self._lockFishSpeedIndex + 1;
            if self._lockFishSpeedIndex>4 then
                self._lockFishSpeedIndex = 1;
            end
        end
    end
    --]]
end

--?????
function _CPlayerControl:Wheel(_fishGold)
    --[[
    _fishGold = _fishGold or 0;
    self._wheelPanel.gameObject:SetActive(true);
    self._wheelAnima:StopAndRevert();
    self._wheelAnima:PlayAlways();
    self._wheelTime = G_GlobalGame.GameConfig.SceneConfig.wheelDisplayTime;
    self._wheelNumber:SetNumber(_fishGold);
    self._wheelRotation  = 0;
    self._wheelToward = 1;
    --]]
end

--????????
function _CPlayerControl:_controlWheel(_dt)
    --[[
    if self._wheelTime>0 then
        self._wheelTime = self._wheelTime - _dt;
        self._wheelRotation  = self._wheelRotation +  self._wheelToward * _dt*180;
        if self._wheelRotation>30 then
            self._wheelToward = -self._wheelToward;
            self._wheelRotation = 60 - self._wheelRotation;
        end
        if self._wheelRotation<-30 then
            self._wheelToward = -self._wheelToward;
            self._wheelRotation = -60 - self._wheelRotation;
        end
        --???????????
        self._wheelNumber:SetLocalRotation(Quaternion.Euler(0,0,self._wheelRotation));
        if self._wheelTime<=0 then
            self._wheelPanel.gameObject:SetActive(false);
        end
    end
    --]]
end

--??????
function _CPlayerControl:_onClickPaotai()
    if self._isEnabled then
        self:SwitchPaotai();
    end
end

--????
function _CPlayerControl:_onAddPaotai()
    if self._isEnabled then
        self:SwitchPaotai();
    end
end

--????
function _CPlayerControl:_onReducePaotai()
    if self._isEnabled then
        self:SwitchPaotai(true);
    end
end


function _CPlayerControl:EnabledClickSwitchPaotai(isEnabled)
    self._isEnabled = isEnabled;
end


--
function _CPlayerControl:SwitchPaotai(isReduce)
    --??????λ??
    if self:IsEmpty() then
        return ;
    end
    isReduce = isReduce or false;

    local _paotaiType;
    if isReduce then
        _paotaiType = G_GlobalGame_FunctionsLib.FUNC_GetPrePaotai(self._paotaiType);
    else
        _paotaiType = G_GlobalGame_FunctionsLib.FUNC_GetNextPaotai(self._paotaiType);
    end
    if _paotaiType == G_GlobalGame.Enum_PaotaiType.InvalidType then
    else

        ----???????
        --self:setPaotaiType(_paotaiType);
        --?л????????
        self._changeControl:ChangeNext(_paotaiType);

        --?л???????
        G_GlobalGame:PlayEffect(G_GlobalGame_SoundDefine.CantSwitch); 
    end
end

--??????????
function _CPlayerControl:GetMultiple()
    return self._multiple;
end

--??????
function _CPlayerControl:OnUserEnter(_user,_isOwner)
    local tempIsOwner = self._isOwner;
    self._uid                   = _user.uid;
    self._chairId               = _user.chairId;
    self._isAndroid             = _user.isAndroid;
    self._name                  = _user.name;
    self._gold                  = _user.gold;
    self._customHeader          = _user.customHeader;
    self._headerExtensionName   = _user.headerExtensionName;
    self._isOwner               = _isOwner; 
    if tempIsOwner~=_isOwner then
        --?????
        if self.transform then
            destroy(self.transform.gameObject);
            self.transform=nil;
        end
        self:_loadPaotai();
        --??????
        self:_getCtrls();
    end
    self.multipleNumber:Display();
    self.fishGoldNumber:SetNumber(0);
    if self.goldNumber then
        self.goldNumber:SetNumber(0);
    end
    self._bulletVec             = vector:new();
    self._lockFish              = nil;
    self:setPaotaiType(G_GlobalGame.Enum_PaotaiType.Paotai_1);
    --?????????
    self.lastShotAngle = 0;
end


--???????????
function _CPlayerControl:_displayNewHandGuide()
    if not self._tipArraws then
        return ;
    end
    self._tipArraws._tipPosTime = G_GlobalGame_GameConfig_SceneConfig.iPosTipTime;
    local _ctrls = self._tipArraws._ctrls;
    for i=1,#_ctrls do
        _ctrls[i]._activeCtrl.gameObject:SetActive(true);
    end
end

--????????????
function _CPlayerControl:_hideNewHandGuide()
    if not self._tipArraws then
        return ;
    end
    self._tipArraws._tipPosTime = 0;
    local _ctrls = self._tipArraws._ctrls;
    for i=1,#_ctrls do
        _ctrls[i]._activeCtrl.gameObject:SetActive(false);
    end
end

function _CPlayerControl:_controlPopTip(_dt)
    if self._tipArraws == nil then
        return ;
    end
    local tipArraws = self._tipArraws;
    if tipArraws._tipPosTime>0 then
        --???????λ?????
        tipArraws._tipPosTime = tipArraws._tipPosTime -  _dt;
        tipArraws._moveY = tipArraws._moveY + tipArraws._moveToward;
        if tipArraws._moveY<-13  then
            tipArraws._moveY = -13;
            tipArraws._moveToward = -tipArraws._moveToward;
        elseif tipArraws._moveY>0 then
            tipArraws._moveY = 0;
            tipArraws._moveToward = -tipArraws._moveToward;
        end

        --???????λ??
        local _ctrls = tipArraws._ctrls;
        for i=1,#_ctrls do
            _ctrls[i]._moveCtrl.localPosition = _ctrls[i]._beginPos + VECTOR3NEW(0,tipArraws._moveY,0);
        end
        if tipArraws._tipPosTime<=0 then
            self:_hideNewHandGuide();
        end

    end
end


--?????
function _CPlayerControl:SetFishGold(_fishGold)
    _fishGold = _fishGold or 0;
    self.fishGoldNumber:SetNumber(_fishGold);
    self._fishGold = _fishGold;
end

--???y????
function _CPlayerControl:SetGold(_gold)
    _gold     = _gold or 0;
    if self.goldNumber then
        self.goldNumber:SetNumber(_gold);
    end
    self._gold = _gold;
end

--???????
function _CPlayerControl:SetName(_name)
--    if self.playerNickName then
--        self.playerNickName.text = _name;
--    end
end

--??????????????
function _CPlayerControl:IsEnoughFire()
    return self._fishGold >= self._multiple;
end

--?????????
function _CPlayerControl:AddFishGold(_fishGold)
    self._fishGold = self._fishGold + _fishGold;
    if self._fishGold<0 then
        self._fishGold=0;
    end
    self.fishGoldNumber:SetNumber(self._fishGold);
end

--?????
function _CPlayerControl:OnUserLeave(_user)
    if self._uid==-1 then
        return ;
    end
    self._uid = -1;
    self.fishGoldNumber:Clear();
    if self.goldNumber then
        self.goldNumber:Clear();
    end
    self.multipleNumber:Clear();

    --?????????
    self._fireInterval = 0;

    --???????
    self:SetLockFish(nil);
    --??????
    self:_removePaotai();

    --??????????
    if self._bulletVec~=nil then
        self._bulletVec:clear();
    end
    --?????
    self._fishGold = 0;
    --???????
    self._scoreColumnControl:Clear();

    if self._UIKillFish then
        --????
        self._UIKillFish:_hide();
    end
    --?????????
    self:_hideNewHandGuide();


end

--??????λ??
function _CPlayerControl:IsEmpty()
    return self._uid == -1;
end

--???????
function _CPlayerControl:TowardTarget(_targetPos)
    if self:IsEmpty() then
        return ;
    end
    return self:ChangeToward(_targetPos);
end

function _CPlayerControl:ChangeToward(_targetPos) 
    local p = self.paos.position;
    --local p = G_GlobalGame:SwitchWorldPosToScreenPosByUICamera(self.paos.position);
    local t = _targetPos;
    local lf = self._lockFish;
    if lf then
        if lf:IsDie() or not lf:IsInScreen() then
            self._allPlayerControl:OnSwitchNextLockFish(self._chairId,lf);
            return 0;
        else
            t = lf:Position();
        end
        
    end 
    if t== nil then
        return;
    end
    local r;
    if t.x==p.x then
        r=0;
    else
        r= MATH_RAD2DEG * MATH_ATAN((t.y-p.y)/(t.x-p.x));
    end
    local canAngle = 90;
    if (t.x-p.x)<=0 then r=90+r else r=r-90 end

    if not self._lockFish then
        if r>=canAngle or r<=-canAngle then
            return 3600;
        end 
    end
    self:SetPaoAngle(r);

    if lf then
        self.lockStart.position = self.paos.position;
        self.lockEnd.position   = t;
        local len = VECTOR3DIS(self.lockStart.localPosition,self.lockEnd.localPosition);
        self._lockLine:Toward(self.lockEnd.localPosition,r+180,len);
    end
    if r>=canAngle or r<=-canAngle then
       return 3600;
    end
    return r;      
end

--??????
function _CPlayerControl:UserFire(_targetPos,_isNeedFire)
    if self:IsEmpty() then
        return ;
    end
    local count = self._bulletControl:GetBulletCount(self._chairId);
    if count >100 then
        return ;
    end

    --?????
    local r = self:ChangeToward(_targetPos);
    if r==3600 then
        return ;
    elseif _isNeedFire then
        if r==nil then
            r = self.lastShotAngle;
        else
            self.lastShotAngle = r;
        end
    else
        if r==nil then
            return ;
        end
    end
    if self._fireInterval>0 then --????????????
        return;
    end

    self.shotAnima:Play();
    --self.fireAnima:Play();

    --???????????
    if self._isEnergy then
        self._fireInterval = G_GlobalGame_GameConfig_SceneConfig.iFireEnergyInterval + self._fireInterval;
    else
        self._fireInterval = G_GlobalGame_GameConfig_SceneConfig.iFireInterval + self._fireInterval;
    end


    local localr =self:GetPaoLocalAnle();

    if self._lockFish then
        G_GlobalGame._clientSession:SendPao(self._bulletKind,localr,self._multiple,self._lockFish:FishID());
    else
        G_GlobalGame._clientSession:SendPao(self._bulletKind,localr,self._multiple,G_GlobalGame_ConstDefine.C_S_INVALID_FISH_ID);
    end
    local pos = G_GlobalGame:SwitchWorldPosToScreenPosByUICamera(self.shotTrans.position);
    local bullet = self._bulletControl:CreateBullet(self._bulletType,self._isOwner,pos,localr,self._chairId,self._lockFish,G_GlobalGame.bulletId,false,self._bulletKind);
    --????з??????ID
    self._bulletVec:push_back(bullet);
    if self._isEnergy then
        G_GlobalGame:PlayEffect(G_GlobalGame_SoundDefine.Ion_Fire);
    else
        G_GlobalGame:PlayEffect(G_GlobalGame_SoundDefine.Fire);
    end
 
end

--???y??
function _CPlayerControl:SetPaoLocalAngle(_angle)
    self.paos.localEulerAngles = VECTOR3NEW(0,0,_angle);
end

--??????
function _CPlayerControl:GetPaoLocalAnle()
    return self.paos.localEulerAngles.z;
end

--???y??
function _CPlayerControl:SetPaoAngle(_angle)
    V_Vector3_Value.x = 0;
    V_Vector3_Value.y = 0;
    V_Vector3_Value.z = _angle;
    self.paos.eulerAngles = V_Vector3_Value;
end

--??????
function _CPlayerControl:GetPaoAngle()
    return self.paos.eulerAngles.z;
end

--?????????
function _CPlayerControl:ChangeToEnergy()
    self._isEnergy = true;
    local paotaiType = G_GlobalGame_FunctionsLib.FUNC_GetUpPaotai(self._paotaiType);
    if paotaiType == G_GlobalGame.Enum_PaotaiType.InvalidType then
    else
        self:setPaotaiType(paotaiType);
        G_GlobalGame:PlayEffect(G_GlobalGame_SoundDefine.Ion_Get);
        --?????????
        self._powerFlag.gameObject:SetActive(true);
        self._isPower = true;
        self._powerSpeedIndex = 1;
        self._powerFlag.localPosition = self._powerBeginPos;
    end
end

--???????
function _CPlayerControl:ChangeToNormal()
    self._isEnergy = false;
    local paotaiType = G_GlobalGame_FunctionsLib.FUNC_GetDownPaotai(self._paotaiType);
    if paotaiType == G_GlobalGame.Enum_PaotaiType.InvalidType then
    else
        self:setPaotaiType(paotaiType);
        self._powerFlag.gameObject:SetActive(false);
        self._isPower = false; 
    end
end


function _CPlayerControl:OnUserFire(_fire,_myChairId)
    --??????????????
    if self._isOwner then 
        --??????
        local bullet = self._bulletVec:pop_front();
        if bullet then 
            --??????ID
            bullet:SetBulletId(_fire.bulletId);
        end        
    else
        --??????????????л???
        local bulletType = G_GlobalGame_FunctionsLib.FUNC_GetBulletTypeByMultiple(_fire.bulletMultiple,self._isEnergy);
        local paotaiType = G_GlobalGame_FunctionsLib.FUNC_GetPaotaiTypeByBulletType(bulletType);
        --???????
        self:setPaotaiType(paotaiType);
        if _fire.lockFishId~=G_GlobalGame_ConstDefine.C_S_INVALID_FISH_ID then
            --????????????????
            local fish = G_GlobalGame:GetKeyValue(G_GlobalGame_KeyValue.GetFishById,_fire.lockFishId);
            if fish~=nil then
                if fish:IsDie() then
                    self:SetLockFish(fish);
                else
                    --??????????
                    self:SetLockFish(nil);
                end
            end
        else
            --??????????
            self:SetLockFish(nil);
            if _fire.androidChairId>=G_GlobalGame_ConstDefine.C_S_PLAYER_COUNT or _fire.androidChairId<0  then
                self:SetPaoLocalAngle(_fire.angle);
            else
                --??????
                --local angle =math.deg(_fire.angle);
                --self:SetPaoLocalAngle(angle);
                self:SetPaoLocalAngle(_fire.angle);
            end
        end
        local isMyAndroid;
        if _fire.androidChairId == _myChairId then
            isMyAndroid = true;
        else
            isMyAndroid = false;
        end

        local pos = G_GlobalGame:SwitchWorldPosToScreenPosByUICamera(self.shotTrans.position);
        --???????
        self._bulletControl:CreateBullet(self._bulletType,self._isOwner,pos,self:GetPaoAngle(),self._chairId,self._lockFish,_fire.bulletId
        ,isMyAndroid,_fire.bulletKind);
        if self._isEnergy then
            G_GlobalGame:PlayEffect(G_GlobalGame_SoundDefine.Ion_Fire);
        else
            G_GlobalGame:PlayEffect(G_GlobalGame_SoundDefine.Fire);
        end

        --?????????
        self.shotAnima:Play();
    end
    self:SetFishGold(_fire.fishGold);
end

--???????????
function _CPlayerControl:GetLockFish()
    return self._lockFish;
end

--????????????
function _CPlayerControl:SetLockFish(_lockFish)
    if self._lockFish == _lockFish then
        return ;
    end
    if self._lockFish then
        self._lockFish:RemoveEvent(self);
    end
    do
        return ;
    end
    self._lockFish = _lockFish;
    if _lockFish then
        self._lockFish:RegEvent(self,self.OnEventFish);
        self._lockLine:Display();
        --?л????
        self:ChangeToward(_lockFish:Position());

        self._lockFishTrans.gameObject:SetActive(true);
        self._lockFishImage.sprite = G_GlobalGame_goFactory:getLockFishFlag(_lockFish._fishType);
    else
        self._lockLine:Hide();
        self._lockFishTrans.gameObject:SetActive(false);
    end
end

function _CPlayerControl:OnEventFish(_eventId,_fish)
    if (_eventId==G_GlobalGame_EventID.FishDead or _eventId == G_GlobalGame_EventID.FishLeaveScreen) then
    else
        return;
    end
    if _fish:FishID() == self._lockFish:FishID() then
        --self._lockFish:RemoveEvent(self);
        --?л????
        self._allPlayerControl:OnSwitchNextLockFish(self._chairId,self._lockFish);
    end
end

--??y????
function _CPlayerControl:WinFishGold(_fishGold)
    --self._scoreColumnControl:DisplayScore(_fishGold);
    self:displayGetScore(_fishGold);
end

--local _CPlayerLeftControl= class("_CPlayerLeftControl",_CPlayerControl);
local _CPlayerLeftControl= class(nil,_CPlayerControl);

function _CPlayerLeftControl:ctor(...)
    _CPlayerLeftControl.super.ctor(self,...,1);
end

--???????
function _CPlayerLeftControl:CreatePaotai()
    return G_GlobalGame_goFactory:createLeftPlayer(self._isOwner);
end

--??????
function _CPlayerLeftControl:OnUserEnter(_user,_isOwner)
    _CPlayerLeftControl.super.OnUserEnter(self,_user,_isOwner);
end

--?????
function _CPlayerLeftControl:OnUserLeave(_user)
    _CPlayerLeftControl.super.OnUserLeave(self,_user);
end

--??????
function _CPlayerLeftControl:OnUserFire(_fire,_myChairId)
    _CPlayerLeftControl.super.OnUserFire(self,_fire,_myChairId);
end


--local _CPlayerRightControl = class("_CPlayerRightControl",_CPlayerControl);
local _CPlayerRightControl = class(nil,_CPlayerControl);

function _CPlayerRightControl:ctor(...)
    _CPlayerRightControl.super.ctor(self,...,1);
end

--???????
function _CPlayerRightControl:CreatePaotai()
    return G_GlobalGame_goFactory:createRightPlayer(self._isOwner);
end


--??????
function _CPlayerRightControl:OnUserEnter(_user,_isOwner)
    _CPlayerRightControl.super.OnUserEnter(self,_user,_isOwner);
end

--?????
function _CPlayerRightControl:OnUserLeave(_user)
    _CPlayerRightControl.super.OnUserLeave(self,_user);
end

--??????
function _CPlayerRightControl:OnUserFire(_fire,_myChairId)
    _CPlayerRightControl.super.OnUserFire(self,_fire,_myChairId);
end

local BUTTON_TYPE = {
    Btn_Null        = 0,
    Btn_UpScore     = 1,
};

--local LongPressItem = class("LongPressItem");
local LongPressItem = class();
--
function LongPressItem:ctor()
    self.isDown      = false;
    self.pressTime   = 0;
    self.btnType     = BUTTON_TYPE.Btn_Null;
    self.isLongPress = false;
    self.longHandler = nil;
    self.shortHandler= nil;
    self.count       = 0; --??д???
    self.longKeyTime = 0;
    self.intervalTime= 0;
end

function LongPressItem:Init(_type,longPressTime,intervalTime,longPressHandler,shortPressHandler)
    self.longPressTime  = longPressTime or 0; --?????????
    self.intervalTime   = intervalTime or 0; --???????
    self.btnType        = _type;
    self.longHandler    = longPressHandler;
    self.shortHandler   = shortPressHandler;
    self.isDown         = true;
    self.pressTime      = 0;
    self.isLongPress    = false;
end

function LongPressItem:Update(_dt)
    --?????????
    if not self.isDown then
        return ;
    end
    self.pressTime = self.pressTime + _dt;
    if self.isLongPress then
        if self.pressTime>= self.intervalTime then
            self.pressTime = self.pressTime - self.intervalTime;
            if self.longHandler then
                self.longHandler(self.btnType,self.count);
            end
            self.count = self.count + 1;
        end
    else
        if self.pressTime>= self.longPressTime then
            self.pressTime = self.pressTime - self.longPressTime;
            if self.longHandler then
                self.longHandler(self.btnType,self.count);
            end
            self.count = self.count + 1;
            self.isLongPress = true;
        end
    end
end

function LongPressItem:Stop()
    self.isDown      = false;
    if self.isLongPress then
    else
        if self.shortHandler then
            self.shortHandler(self.btnType);
        end
    end
    self.isLongPress = false;
end

function LongPressItem:IsInvalid()
    return self.isDown==false;
end

--local LongPressControl = class("LongPressControl");
local LongPressControl = class();

function LongPressControl:ctor()
    self._itemMap = map:new();
    self._delList = vector:new();
end

--???
-- @longPressTime ???????
-- @intervalTime ???????
-- @longPressHandler ???????
-- @shortPressHandler ?????? 
function LongPressControl:Start(_type,longPressTime,intervalTime,longPressHandler,shortPressHandler)
    local item = LongPressItem.New();
    item:Init(_type,longPressTime,intervalTime,longPressHandler,shortPressHandler);
    self._itemMap:insert(_type,item);
end

--??
function LongPressControl:Stop(_type)
    local item = self._itemMap:value(_type);
    if item then
        item:Stop();
    end 
    self._delList:push_back(_type);
end

--??? 
function LongPressControl:Execute(_dt)
    local it = self._delList:iter();
    local val= it();
    while(val) do
        self._itemMap:erase(val);
        val = it();
    end
    it = self._itemMap:iter();
    val = it();
    self._delList:clear();
    local item;

    while(val) do
        item = self._itemMap:value(val);
        if not item:IsInvalid() then
            item:Update(_dt);
        end
        val = it();
    end
end

local ENUM_ShowNumberType = {
    GOLD   = 1,
    SILVER = 2,
};

--local _CShowGoldNumber = class("_CShowGoldNumber",CEventObject);
local _CShowGoldNumber = class(nil,CEventObject);

function _CShowGoldNumber:ctor(_creator,_type)
    _CShowGoldNumber.super.ctor(self);
    self.goldType   = _type or ENUM_ShowNumberType.GOLD;
    self.gameObject = GAMEOBJECT_NEW();
    self.transform  = self.gameObject.transform;
    --self.gameObject.name= "GoldNumber";
--    self.transform:SetParent(_parent);
--    self.transform.localPosition = Vector3.New(0,0,0);
--    self.transform.localScale = Vector3.One();
    self._atlasNumber = CAtlasNumber.New(_creator);
    self._atlasNumber:SetParent(self.transform);
    self._pos  = nil;
        
    self.scale = {x=1,y=1,z=1};
    self.localPos = {x=0,y=0,z=0};
    
end

--?????
function _CShowGoldNumber:Init(transform,_pos,_time)
    self.transform:SetParent(transform);
    --self.transform.localPosition = Vector3.New(0,0,0);
    self.transform.localScale = C_Vector3_One;
    self.transform.position = _pos;

    self._pos  = _pos;
    self.scaleNumber = 0.6;
    self.addScale  = 1;
    local scale = self.scaleNumber;
    local lscale = self.scale;
    lscale.x = scale;
    lscale.y = scale;
    lscale.z = scale;
    self._atlasNumber:SetLocalScale(lscale);
    self._moveY = 20;
    self._endY  = 60;
    self._topY  = 100;
    self._moveSpeed = 310;
    self._displayTime = _time or 0.7; --??????

    local lpos = self.localPos;
    lpos.y = self._moveY;
    self._atlasNumber:SetLocalPosition(lpos);
    self._moveDistance = self._topY*2 - self._moveY - self._endY; --???????
    
    self._scaleSpeed  =(1-self.scaleNumber)*self._moveSpeed/self._moveDistance;
    self._firstDisPer = (self._endY -self._moveY)* self._scaleSpeed/self._moveDistance + self.scaleNumber ;
    self._step  = 0;
    self._shakeTime     = 0;
    self._shakeToward   = 1;
    self._shakeCount    = 0;
end

function _CShowGoldNumber:GoldType()
    return self.goldType;
end

function _CShowGoldNumber:SetNumber(num)
    self._atlasNumber:SetNumber(num);
end

function _CShowGoldNumber:Update(_dt)
    if self._step == 0 then
        local moveY = self._moveY + _dt*self._moveSpeed;  
        if moveY>self._topY then
            moveY = self._topY;
            self._step  = 1;
        end
        self._moveY =  moveY;
        local lpos = self.localPos;
        lpos.y = moveY;
        self._atlasNumber:SetLocalPosition(lpos);

        local scale = self.scaleNumber + _dt*self._scaleSpeed;
        if scale>1 then
            scale=1;
        end
        self.scaleNumber = scale;
        local lscale = self.scale;
        lscale.x = scale;
        lscale.y = scale;
        lscale.z = scale;
        self._atlasNumber:SetLocalScale(lscale);
    elseif self._step == 1 then
        local moveY = self._moveY - _dt*self._moveSpeed;  
        if moveY<=self._endY then
            moveY = self._endY;
            self._step  = 2;
        end
        self._moveY =  moveY;
        local lpos = self.localPos;
        lpos.y = moveY;
        self._atlasNumber:SetLocalPosition(lpos);

        local scale = self.scaleNumber + _dt*self._scaleSpeed;
        if scale>1 then
            scale=1;
        end
        self.scaleNumber = scale;
        local lscale = self.scale;
        lscale.x = scale;
        lscale.y = scale;
        lscale.z = scale;
        self._atlasNumber:SetLocalScale(lscale);
    elseif self._step == 2 then
        do
            --????Ч??
            self._shakeTime = self._shakeTime + _dt;
            if self._shakeTime>0.05 then
                self._shakeTime = self._shakeTime - 0.05;
                self._shakeToward = 0 - self._shakeToward;
                self._shakeCount = self._shakeCount + 1;
                if self._shakeCount>=4 then
                    self._step = 3;
                end
            end
            --[[
            if self._shakeToward==1 then
                self._atlasNumber:SetLocalPosition(Vector3.New(0,self._endY + 10,0));
            else
                self._atlasNumber:SetLocalPosition(Vector3.New(0,self._endY -10,0));
            end
            --]]
        end

    elseif self._step == 3 then
        self._displayTime = self._displayTime - _dt;
        if self._displayTime<=0 then
            self._step = 4;
            self:SendEvent(G_GlobalGame_EventID.ShowGoldNumberDisappear);
        end
    end
end

--local _CShowGoldNumberControl = class("_CShowGoldNumberControl",CEventObject);
local _CShowGoldNumberControl = class(nil,CEventObject);

function _CShowGoldNumberControl:ctor()
    _CShowGoldNumberControl.super.ctor(self);
    self._atlasNumberCacheMap = {};
    --self._atlasNumberCache = vector:new();
    self._atlasNumberRunMap= map:new();
    self._delList          = vector:new();
    self._goldNumber       = {};
    self._silverNumber     = {};
end

function _CShowGoldNumberControl:Init(transform)
    self.transform  = transform;
    self.gameObject = transform.gameObject;
    self.myTransform = transform:Find("My"); 
    self.otherTransform = transform:Find("Other");

    local numberImage   = self.myTransform:Find("Numbers"):GetComponent(ImageAnimaClassType);
	if numberImage==nil then
		numberImage   =  Util.AddComponent("ImageAnima", self.myTransform:Find("Numbers").gameObject);
		for i=0,9 do
			numberImage:AddSprite(G_GlobalGame.numbersSprites["GetScore"][tostring(i)]);
		end
		--numberImage:AddSprite(G_GlobalGame.numbersSprites["GetScore"]["+"]);
	end 
    local count=numberImage.lSprites.Count;
    for i=0,count-1 do
        if i==10 then
            --???
            self._goldNumber["+"] =numberImage.lSprites[i];
        else
            self._goldNumber[tostring(i)] =numberImage.lSprites[i];
        end
    end


    numberImage   = self.otherTransform:Find("Numbers"):GetComponent(ImageAnimaClassType);
	if numberImage==nil then
		numberImage   =  Util.AddComponent("ImageAnima", self.otherTransform:Find("Numbers").gameObject);
		for i=0,9 do
			numberImage:AddSprite(G_GlobalGame.numbersSprites["GetScore"][tostring(i)]);
		end
		--numberImage:AddSprite(G_GlobalGame.numbersSprites["GetScore"]["+"]);
	end 	
    count=numberImage.lSprites.Count;
    for i=0,count-1 do
        if i==10 then
            --???
            self._silverNumber["+"] =numberImage.lSprites[i];
        else
            self._silverNumber[tostring(i)] =numberImage.lSprites[i];
        end
    end
end

--??????????????
function _CShowGoldNumberControl:CreateNumber(_number,_position,_time)
    local number;
    _position = G_GlobalGame:SwitchWorldPosToScreenPosBy3DCamera(_position);
    _position.z = 0;
    _position = G_GlobalGame:SwitchScreenPosToWorldPosByUICamera(_position);
    local atlasNumberCache = self._atlasNumberCacheMap[ENUM_ShowNumberType.GOLD];
    if atlasNumberCache and atlasNumberCache:size()>0 then
        number = atlasNumberCache:pop();
    else
        number = _CShowGoldNumber.New(handler(self,self._createNumberSpr),ENUM_ShowNumberType.GOLD);
    end
    _position.y = _position.y + 0.7;
    _position.z = 0;
    number:Init(self.myTransform,_position,_time);
    self._atlasNumberRunMap:insert(number:LID(),number);
    number:RegEvent(self,self.OnShowGoldNumberEvent);
    number:SetNumber(_number);
    number:SetPosition(_position);
end

function _CShowGoldNumberControl:CreateSilverNumber(_number,_position,_time)
    local number;
    _position = G_GlobalGame:SwitchWorldPosToScreenPosBy3DCamera(_position);
    _position.z = 0;
    _position = G_GlobalGame:SwitchScreenPosToWorldPosByUICamera(_position);
    local atlasNumberCache = self._atlasNumberCacheMap[ENUM_ShowNumberType.SILVER];
    if atlasNumberCache and atlasNumberCache:size()>0 then
        number = atlasNumberCache:pop();
    else
        number = _CShowGoldNumber.New(handler(self,self._createSilverNumberSpr),ENUM_ShowNumberType.SILVER);
    end
    _position.y = _position.y + 0.7;
    number:Init(self.otherTransform,_position,_time);
    self._atlasNumberRunMap:insert(number:LID(),number);
    number:RegEvent(self,self.OnShowGoldNumberEvent);
    number:SetNumber(_number);
    number:SetPosition(_position);
end

function _CShowGoldNumberControl:_createNumberSpr(_chr)
    return self._goldNumber[_chr];
end

function _CShowGoldNumberControl:_createSilverNumberSpr(_chr)
    return self._silverNumber[_chr];
end

function _CShowGoldNumberControl:Update(_dt)
    local it = self._delList:iter();
    local val= it();
    local goldNumber;
    local atlasNumberCache;
    local goldType;
    while(val) do
        goldNumber = self._atlasNumberRunMap:erase(val);
        if goldNumber then
            goldNumber:Cache();
            goldType = goldNumber:GoldType();
            atlasNumberCache = self._atlasNumberCacheMap[goldType];
            if not atlasNumberCache then
                atlasNumberCache = vector:new();
                self._atlasNumberCacheMap[goldType] = atlasNumberCache; 
            end
            atlasNumberCache:push_back(goldNumber);
        end
        val = it();
    end
    self._delList:clear();
    it = self._atlasNumberRunMap:iter();
    val= it();
    while(val) do
        goldNumber = self._atlasNumberRunMap:value(val);
        goldNumber:Update(_dt);
        val = it();
    end
end

function _CShowGoldNumberControl:OnShowGoldNumberEvent(_eventId,_showGold)
    if _eventId ==G_GlobalGame_EventID.ShowGoldNumberDisappear then
        self._delList:push_back(_showGold:LID());
    end
end


--local _CPlayersControl = class("_CPlayersControl");
local _CPlayersControl = class();

function _CPlayersControl:ctor(_sceneControl,_bulletControl,_fishControl)
    self._canAngle          = 90; --????????????
    self._angleSpeed        = 0;  --????????
    self._bulletDuration    = 0.3; --?????????
    --self._

    self._isEmpty           = true;
    self._chairIds          = {};
    self._myChairId         = G_GlobalGame_ConstDefine.C_S_INVALID_CHAIR_ID;
    self._isRotation        = false; --??????

    self.playerChairs       = {};
    self.playerControls     = {};

    self._sceneControl      = _sceneControl;
    self._bulletControl     = _bulletControl;
    
    self._fishControl       = _fishControl;
    self._flyGoldControl    = CFlyGoldControl.New();
    self._userIdsMap        = map:new();
    self._showGoldNumControl= _CShowGoldNumberControl.New();

    G_GlobalGame:RegEvent(G_GlobalGame_EventID.UserFire,self,self.OnUserFire);
    G_GlobalGame:RegEvent(G_GlobalGame_EventID.UserEnter,self,self.OnUserEnter);
    G_GlobalGame:RegEvent(G_GlobalGame_EventID.UserLeave,self,self.OnUserLeave);
    G_GlobalGame:RegEvent(G_GlobalGame_EventID.ExchangeFishGold,self,self.OnExchangeFishGold); 
    G_GlobalGame:RegEvent(G_GlobalGame_EventID.CatchFish,self,self.OnCatchFish); 
    G_GlobalGame:RegEvent(G_GlobalGame_EventID.CatchCauseFish,self,self.OnCatchFish); 
    G_GlobalGame:RegEvent(G_GlobalGame_EventID.CatchGroupFish,self,self.OnCatchGroupFish);
    G_GlobalGame:RegEvent(G_GlobalGame_EventID.UserScore,self,self.OnUserScoreChange); 
    G_GlobalGame:RegEvent(G_GlobalGame_EventID.EnergyTimeOut,self,self.OnEnergyTimeOut); 
    G_GlobalGame:RegEvent(G_GlobalGame_EventID.NewHandEnd,self,self.OnNewHandEnd);
    G_GlobalGame:RegEvent(G_GlobalGame_EventID.NotifySwitchPao,self,self.OnSwitchPaotai);
    G_GlobalGame:RegEvent(G_GlobalGame_EventID.NotifyAddScore,self,self.OnAddScore);
    G_GlobalGame:RegEvent(G_GlobalGame_EventID.NotifyCreateFlyGold,self,self.OnCreateFlyGold); --????????
    
    --???
    G_GlobalGame:SetKeyHandler(G_GlobalGame_KeyValue.GetSceneIsRotation,handler(self,self.IsRotation));
    
    --???????
    self._longKeyPress = LongPressControl.New();

    self._isCanCreateBullet = true;

    self._isNewHand = false;

    --??????????????
    colorIdCreator(0);

    --???λ?????
    self._popTipPosData = {
        _tipPosTime = 0,
        _moveToward = -1,
        _moveY      = 0,
    };

    --???????????????
    self._isNeedClickToward = true;

    --??????ε???
    self._recordClickObjectMap =  map:new();
    --??????ε???
    self._recordNotClickObjectMap =  map:new();

    --?????
    self._lastClick = false;
    self._curClick  = false;
end

--?????
function _CPlayersControl:Init(transform)
	--logError("wwwwwwwwwwwwwwwwwwww1=")
    self.transform      = transform;
    self.setLayer       = self.transform:Find("SetLayer");

    self:_initPlayers();
		--logError("wwwwwwwwwwwwwwwwwwww2")
    self:_initUI();
		--logError("wwwwwwwwwwwwwwwwwwww3")
    self:_initShadows();
		--logError("wwwwwwwwwwwwwwwwwwww4")
end

--?????UI????
function _CPlayersControl:_initUI()
    local uiPart = self.setLayer:Find("UIPart");
    local transform = uiPart;
    self._uiTransform = transform;

    --?????
    self._btnsGroup = {
        
        --??????
        bgRectTransform = nil,

        --????????????
        isSpread = false,

        --??????
        moveTime = 1,

        --???????
        runTime  = 0,

        --?????????????????
        spreadPoints ={}, 

        --???????
        beginLen = 110,

        beginW   = 112,

        --???????
        moveLen  = 290,

        --???????
        curLen   = 0,
        
        --??????
        speed    = 0,

        --????????
        playersManager = nil,

        --?????????
        moveDisVec     = VECTOR3ZERO(),

        --?????
        Init   = function(self,transform,control)
            --UI??????
            self.playersManager = control;

            --local MoveBtnAction = class("MoveBtnAction");
            local MoveBtnAction = class();

            function MoveBtnAction:ctor(transform,beginPos,topPos,endPos)
                self.transform  = transform;
                self.transform  = transform;
                self.gameObject = transform.gameObject;
                self.endPos     = endPos;
                self.beginPos   = beginPos;
                self.topPos     = topPos;
                self.isSpread   = false;
                self.isAction   = false;
                self.isShow  = false;
            end

            --?????
            function MoveBtnAction:Update(moveDis)
                if self.isAction then
                    local curPos = self.topPos - moveDis;
                    if (curPos.y>=self.beginPos.y) then
                        if self.isShow then
                            self:Hide();
                        end
                    else
                        if not self.isShow then
                            self:Show();
                        end
                        self.transform.localPosition = curPos;
                    end
                end
            end

            --???????
            function MoveBtnAction:Spread()
                self.isSpread = true;
                self.isAction = false;
                self:Show();
                self.transform.localPosition = self.endPos;
            end

            --????????
            function MoveBtnAction:Shrink()
                self.isSpread = false;
                self.isAction = false;
                self:Hide();
                --self.transform.localPosition = self.endPos;
            end

            --?????
            function MoveBtnAction:ChangeState()
                self.isSpread = not self.isSpread;
                self.isAction = true;
            end

            --????
            function MoveBtnAction:Hide()
                self.isShow = false;
                self.gameObject:SetActive(false);
            end

            --???
            function MoveBtnAction:Show()
                self.isShow = true;
                self.gameObject:SetActive(true);
            end

            --????
            self.isContinueShot = false;

            --???????
			logError("===============transform=================>"..transform.name)
            self.spreadBg = transform:Find("Bg");

            --????
            self.bgRectTransform = self.spreadBg:GetComponent("RectTransform");

            --???????
            self.moveButtonsVec  =  vector:new();

            local btnTrans = transform:Find("zhankai");
            local zhankaiBtn = btnTrans;
            local eventTrigger = UTIL_ADDCOMPONENT("EventTriggerListener",btnTrans.gameObject);
            eventTrigger.onClick = handler(self,self.ChangeState);

            --???
            btnTrans = transform:Find("AddScore");
            eventTrigger = UTIL_ADDCOMPONENT("EventTriggerListener",btnTrans.gameObject);
            eventTrigger.onDown = handler(control,control._onAddFishGoldClick);
            eventTrigger.onUp = handler(control,control._onAddFishGoldUp);

            local beginPos = zhankaiBtn.localPosition;
            local moveDis= VECTOR3NEW(0,self.moveLen,0);
            local endPos = btnTrans.localPosition;
            local topPos = endPos + moveDis;
            local moveBtn = MoveBtnAction.New(btnTrans,beginPos,topPos,endPos);
            self.moveButtonsVec:push_back(moveBtn);

            --?·?
            btnTrans = transform:Find("RemoveScore");
            eventTrigger = UTIL_ADDCOMPONENT("EventTriggerListener",btnTrans.gameObject);
            eventTrigger.onClick = handler(control,control._onRemoveFishGoldClick);

            endPos = btnTrans.localPosition;
            topPos = endPos + moveDis;
            moveBtn = MoveBtnAction.New(btnTrans,beginPos,topPos,endPos);
            self.moveButtonsVec:push_back(moveBtn);

            --????
            btnTrans = transform:Find("lianshe");
            eventTrigger = UTIL_ADDCOMPONENT("EventTriggerListener",btnTrans.gameObject);
            eventTrigger.onClick = handler(self,self.OnClickContinueShot);

            endPos = btnTrans.localPosition;
            topPos = endPos + moveDis;
            moveBtn = MoveBtnAction.New(btnTrans,beginPos,topPos,endPos);
            self.moveButtonsVec:push_back(moveBtn);

            --??????
            btnTrans = btnTrans:Find("stopLianShe");
            eventTrigger = Util.AddComponent("EventTriggerListener",btnTrans.gameObject);
            eventTrigger.onClick = handler(self,self.OnClickCloseContinueShot);
            self.stopLianSheGO = btnTrans.gameObject;

            --??????
            self.isMove = false;

            --??????
            self.speed      = 600;

            --????
            self:Spread();
        end,

        --???
        Spread = function(self)
            local it = self.moveButtonsVec:iter();
            local val= it();
            while(val) do
                val:Spread();
                val = it();
            end
            self.isSpread = true;
            self.isMove   = false;
            self.curLen   = self.moveLen;
            self.bgRectTransform.sizeDelta = Vector2.New(self.beginW,self.curLen+self.beginLen);
        end,

        --????
        Shrink = function(self)
            local it = self.moveButtonsVec:iter();
            local val= it();
            while(val) do
                val:Shrink();
                val = it();
            end
            self.isSpread = false;
            self.isMove   = false;
            self.curLen   = 0;
            self.bgRectTransform.sizeDelta = Vector2.New(self.beginW,self.curLen+self.beginLen);
        end,

        --?????
        ChangeState = function(self)
            local it = self.moveButtonsVec:iter();
            local val= it();
            while(val) do
                val:ChangeState();
                val = it();
            end
            self.isSpread = not self.isSpread;
            self.isMove   = true;
        end,

        --?????
        Update = function(self,dt)
            if self.isMove then
                if self.isSpread then
                    --???????
                    self.curLen = self.curLen + self.speed * dt;
                    if self.curLen>=self.moveLen then
                        self.isMove = false;
                        self.curLen = self.moveLen;
                        --???
                        self:Spread();
                    else --if self.curLen>self.moveLen then
                        self.moveDisVec.y = self.curLen;
                        local it = self.moveButtonsVec:iter();
                        local val= it();
                        while(val) do
                            val:Update(self.moveDisVec);
                            val = it();
                        end  
                    end  --if self.curLen>self.moveLen then
                    self.bgRectTransform.sizeDelta = Vector2.New(self.beginW,self.curLen+self.beginLen);
                else  --if self.isSpread then
                    --?????????
                    self.curLen = self.curLen - self.speed * dt;
                    
                    if self.curLen<=0 then 
                        self.isMove = false;
                        self.curLen = 0;
                        --???????
                        self:Shrink();
                    else --if self.curLen<=0 then
                        self.moveDisVec.y = self.curLen;
                        local it = self.moveButtonsVec:iter();
                        local val= it();
                        while(val) do
                            val:Update(self.moveDisVec);
                            val = it();
                        end     
                    end  --if self.curLen<=0 then
                    
                    self.bgRectTransform.sizeDelta = Vector2.New(self.beginW,self.curLen+self.beginLen);
                end  --if self.isSpread then
            end --if self.isMove then
        end,

        --???????
        OnClickContinueShot = function(self)
            self:OpenContinueShot();
        end,

        --?????????书??
        OnClickCloseContinueShot = function(self)
            self:CloseContinueShot();
        end,

        --??????书??
        OpenContinueShot = function(self)
            self.isContinueShot = true;
            self.stopLianSheGO:SetActive(true);
            self.playersManager:ContinueShot();
        end,

        --??????书??
        CloseContinueShot = function(self)
            self.isContinueShot = false;
            self.stopLianSheGO:SetActive(false);
            self.playersManager:NormalShot();
        end,

        --???????
        IsContinueShot    = function(self)
            return self.isContinueShot;
        end,
        
    }; 

    

--    transform:SetParent(self.transform);
--    transform.localScale = Vector3.New(1,1,1);
--    transform.localPosition = Vector3.New(0,0,0);

    local buttonPanel = transform:Find("ButtonPanel");
    self.buttonPanel  = buttonPanel;
    -- local alignView = self.buttonPanel.gameObject:AddComponent(AlignViewExClassType);
    -- alignView:setAlign(Enum_AlignViewEx.Align_Right);
    -- alignView.isKeepPos = false;
    self.buttonPanel.localPosition = Vector3(-667, self.buttonPanel.localPosition.y,0);
    --??????????
    self._btnsGroup:Init(self.buttonPanel,self);

--    --???书??
--    local ContinueStatusObj = G_GlobalGame._goFactory:createContinueShotObj();
--    local ContinueStatus =  ContinueStatusObj.transform;
--    ContinueStatus:SetParent(buttonPanel);
--    ContinueStatus.localPosition = Vector3.New(0,0,0);
--    ContinueStatus.localScale    = Vector3.One();
--    self._openContinueShotTrans = ContinueStatus:Find("OpenContinueShot");
--    self._openContinueShotTrans.gameObject:SetActive(true);
--    self._continueStatus = ContinueStatus:Find("ContinueStaus");
--    self._continueStatus.gameObject:SetActive(false);
--    self._continueStatusImageAnima = self._continueStatus:GetComponent("ImageAnima");
--    --self._continueStatusImageAnima:PlayAlways(); 

--    self.isContinueShot = false;

--    --??????
--    self.continueRotationSpeed = 360;

--    eventTrigger = Util.AddComponent("EventTriggerListener",self._openContinueShotTrans.gameObject);
--    eventTrigger.onClick = handler(self,self.OnClickContinueShot);

    --[[
    --?л??????
    local lockObj = buttonPanel:Find("LockObjs");
    btnTrans = lockObj:Find("Switch");
    eventTrigger = Util.AddComponent("EventTriggerListener",btnTrans.gameObject);
    eventTrigger.onClick = handler(self,self._onSwitchFish);

    --??????
    btnTrans = lockObj:Find("Lock");
    self.lockBtn = btnTrans;
    eventTrigger = Util.AddComponent("EventTriggerListener",btnTrans.gameObject);
    eventTrigger.onClick = handler(self,self._onLockFish);
    self.lockBtnObj = self.lockBtn.gameObject;

    --????
    btnTrans = lockObj:Find("Unlock");
    self.unlockBtn = btnTrans;
    eventTrigger = Util.AddComponent("EventTriggerListener",btnTrans.gameObject);
    eventTrigger.onClick = handler(self,self._onUnlockFish);
    self.unlockBtnObj = self.unlockBtn.gameObject;
    self.unlockBtnObj:SetActive(false);
    --]]

    --??????
    --[[
    local playerInfo = bottomPanel:Find("PlayerInfo");
    self._nameLabel = bottomPanel:Find("Name"):GetComponent("Text");
    local numberImage  = playerInfo:Find("Numbers"):GetComponent("ImageAnima");
    self.goldSprites = {};
    local count=numberImage.lSprites.Count;
    for i=0,count-1 do
        self.goldSprites[tostring(i)] =numberImage.lSprites[i];
    end
    local function createGoldNumber(chr)
        return self.goldSprites[chr];
    end
    self._goldAtlasNumber = CAtlasNumber.New(createGoldNumber,0,HorizontalAlignType.Left);
    self._goldAtlasNumber:SetParent(playerInfo);
    self._goldAtlasNumber.transform.localPosition = numberImage.transform.localPosition;
    self._goldAtlasNumber:SetNumber(0);
    --]]
    
    --λ??????
    --[[
    local bottomPanel = transform:Find("BottomAlign");
    self.bottomPanel  = bottomPanel;
    self._leftPosTip  = self.bottomPanel:Find("Left");
    self._rightPosTip = self.bottomPanel:Find("Right");
    self._leftPosTip.gameObject:SetActive(false);
    self._rightPosTip.gameObject:SetActive(false);
    --]]


    --??????
    self._addScoreTips = transform:Find("TipBg");
    self._addScoreTips.gameObject:SetActive(false);

    --???UI??Ч????
    local effectTransform = transform:Find("UIEffectPanel");
    self._uiEffectControl = _CUIEffectControl.New(effectTransform);
end

function _CPlayersControl:GetUITransform()
    return self._uiTransform;
end

function _CPlayersControl:GetPlayersTransform()
    return self._playersTransform;
end


--????????
function _CPlayersControl:_initPlayers()
    local transform = self.setLayer:Find("Players");
    self._playersTransform = transform;
--    transform:SetParent(self.transform);
--    transform.localScale = Vector3.New(1,1,1);
--    transform.localPosition = Vector3.New(0,0,0);

    --self.upPlayers      = transform:Find("UpPlayer");
    self.downPlayers    = transform:Find("DownPlayer");

--logError("wwwwwwwwwwwwwwwwwwww10=")
    --?????PC??
    if Util.isPc then
        --PC?棬???????????????
        local position = self.downPlayers.localPosition;
        self.downPlayers.localPosition = position + VECTOR3NEW(0,10,0);
    end

    --self._isCanFire = false;

    --??????
    self.lockLayer      = transform:Find("LockLayer");
--logError("wwwwwwwwwwwwwwwwwwww1=11")
    --????
    local flyGoldTransform = transform:Find("FlyGoldLayer");
    self._flyGoldControl:Init(flyGoldTransform);

    local count = self.downPlayers.childCount;
    for i=1,count do
			--logError("wwwwwwwwwwwwwwwwwwww12="..count)
        self.playerChairs[i]= self.downPlayers:GetChild(i-1);
					--logError("wwwwwwwwwwwwwwwwwwww13="..count)
        self.playerControls[i]= _CPlayerControl.New(self,self._bulletControl);
					--logError("wwwwwwwwwwwwwwwwwwww14=")
        self.playerControls[i]:Init(self.playerChairs[i],self.lockLayer);
					--logError("wwwwwwwwwwwwwwwwwwww15="..count)
    end
	--logError("wwwwwwwwwwwwwwwwwwww13=")
    --[[
    self.playerChairs[1]= self.downPlayers:Find("Player1"); 
    self.playerChairs[2]= self.downPlayers:Find("Player2");
    self.playerChairs[3]= self.upPlayers:Find("Player1"); 
    self.playerChairs[4]= self.upPlayers:Find("Player2");
    self.playerControls[1]= _CPlayerControl.New(self,self._bulletControl);
    self.playerControls[2]= _CPlayerControl.New(self,self._bulletControl);
    self.playerControls[3]= _CPlayerControl.New(self,self._bulletControl);
    self.playerControls[4]= _CPlayerControl.New(self,self._bulletControl);
    self.playerControls[1]:Init(self.playerChairs[1],self.lockLayer);
    self.playerControls[2]:Init(self.playerChairs[2],self.lockLayer);
    self.playerControls[3]:Init(self.playerChairs[3],self.lockLayer);
    self.playerControls[4]:Init(self.playerChairs[4],self.lockLayer);
    --]] 

    --????????
    self.showGoldNumLayer = transform:Find("GoldNumberLayer");
    self._showGoldNumControl:Init(self.showGoldNumLayer);

end

function _CPlayersControl:_initShadows()
    local transform = self.setLayer:Find("FirstEnterMask");
    self._enterMask = transform;

    --????????????
    self._showPosTipControl = {
        beginScale = 0.4,
        midScale   = 2.1,
        step1Scale = 2.5, 
        step2Scale =1.85,
        curScale   =VECTOR3NEW(0,0,0),
        step       = 0,
        scaleSpeed1= 1.6,
        scaleAddSpeed1 =1.4,
        scaleSpeed1Ex  = 1.2,
        scaleAddSpeed1Ex =0.5,
        scaleSpeed2 = 3,
        scaleAddSpeed2 =45,
        runTime    = 0,
        waitTime   = 1.2, --??????

        --???????????
        isTimeControl = false,

        --λ?????????
        tipPosTime = G_GlobalGame_GameConfig_SceneConfig.iPosTipTime,
        tipMoveToward = -2,
        tipChairTip   = nil,
        tipChairArraw = nil,
        tipChairTipGameObject = nil,
        tipMoveY      = 0,
        tipBeginPos   = nil,
        tipCharImage  = nil,
        tipArrawImage = nil,
        tipColor      = COLORNEW(1,1,1,1),
        tipColorSpeed = 2,
        isTipFadeOut  = false,
        --λ????????

        datas = {
            [1] = {
                pos = VECTOR3NEW(-528,0,0),
                scale= 25,
            },
                        
            [2] = {
                pos = VECTOR3NEW(-198,0,0),
                scale = 19,
            },
            [3] = {
                pos = VECTOR3NEW(131,0,0),
                scale = 19,
            },
            [4] = {
                pos = VECTOR3NEW(461,0,0),
                scale = 24,
            },
        },

        Init = function(self,transform)
            self.transform = transform;
            self.gameObject= transform.gameObject;
            self.gameObject:SetActive(true);

            self.bgMask = transform:Find("Mask");
            local eventTrigger = UTIL_ADDCOMPONENT("EventTriggerListener",self.bgMask.gameObject);
            eventTrigger.onClick = handler(self,self.ScaleOut);

            self.pos = transform:Find("Pos");
            self.bottomAlign = self.pos:Find("BottomAlign");
            self.bottomBorder= self.bottomAlign:Find("BottomBorder");

            --??λ???
            self.tipChairTip    = self.pos:Find("ChairTip");
            self.tipChairArraw  = self.tipChairTip:Find("Arraw");
            self.tipChairTipGameObject = self.tipChairTip.gameObject;
            self.tipChairTipGameObject:SetActive(false);
            self.tipBeginPos = self.tipChairArraw.localPosition;
            self.tipArrawImage = self.tipChairArraw:GetComponent(ImageClassType);
            local pos = self.tipChairTip:Find("Pos");
            if pos then
                self.tipCharImage  = pos:GetComponent(ImageClassType);
            end
            
            self.isTimeControl = true;
            self.timeControlValue=0;
            self.isFadeOut = false;
            self.step = 0;
        end,

        Start = function(self,chairId)
            self.bottomBorder.gameObject:SetActive(false);
            self.curData    = self.datas[chairId];
            self.pos.localPosition = self.curData.pos;
            self.curScale.x = self.beginScale;
            self.curScale.y = self.beginScale;
            self.bottomAlign.localScale = self.curScale;

            --??????
            self:_showPopTip();
            self.step       = 1;
            self.beginSpeed = self.scaleSpeed1;
        end,

        Update = function(self,dt)
            if self.step==0 then
            elseif self.step==1 then
                --???self.step1Scale ??С
                self.runTime = self.runTime + dt;
                local scale = self.beginScale + self.scaleSpeed1*self.runTime + self.scaleAddSpeed1*self.runTime*self.runTime/2;
                if scale>self.step1Scale then
                    self.step = 2;
                    scale = self.step1Scale;
                    self.runTime = 0;
                    self.beginScale = scale;
                    self.beginSpeed = self.beginSpeed + self.scaleAddSpeed1*self.runTime;
                end
                self.curScale.x = scale;
                self.curScale.y = scale;
                self.bottomAlign.localScale = self.curScale;

                self:_movePopTip();
            elseif self.step==2 then
                --?????
                self.runTime = self.runTime + dt;
                local scale = self.beginScale - self.beginSpeed* self.runTime + self.scaleAddSpeed1*self.runTime*self.runTime/2;
                if scale<self.step2Scale then
                    self.step = 3;
                    scale = self.step2Scale;
                    self.runTime = 0;
                    self.beginScale = scale;
                    self.beginSpeed = self.beginSpeed - self.scaleAddSpeed1*self.runTime;
                end
                self.curScale.x = scale;
                self.curScale.y = scale;
                self.bottomAlign.localScale = self.curScale;

                self:_movePopTip();
            elseif self.step==3 then
                --??????
                self.runTime = self.runTime + dt;
                local scale = self.beginScale + self.beginSpeed*self.runTime + self.scaleAddSpeed1*self.runTime*self.runTime/2;
                if scale>self.midScale then
                    self.step = 4;
                    scale = self.midScale;
                    self.runTime = 0;
                    self.beginScale = scale;
                    self.beginSpeed = self.beginSpeed + self.scaleAddSpeed1*self.runTime;
                    self.timeControlValue = 0;
                end
                self.curScale.x = scale;
                self.curScale.y = scale;
                self.bottomAlign.localScale = self.curScale;

                self:_movePopTip();
            elseif self.step==4 or self.step==5 then
                if self.step==4 then
                    --?????
                    self.runTime = self.runTime + dt;
                    local scale = self.beginScale - self.scaleSpeed1Ex* self.runTime;
                    if scale<self.step2Scale then
                        self.step = 5;
                        scale = self.step2Scale;
                        self.runTime = 0;
                        self.beginScale = scale;
                        self.beginSpeed = self.beginSpeed;
                    end
                    self.curScale.x = scale;
                    self.curScale.y = scale;
                    self.bottomAlign.localScale = self.curScale;

                    self:_movePopTip();
                elseif self.step==5 then
                    --??????
                    self.runTime = self.runTime + dt;
                    local scale = self.beginScale + self.scaleSpeed1Ex*self.runTime ;
                    if scale>self.midScale then
                        self.step = 4;
                        scale = self.midScale;
                        self.runTime = 0;
                        self.beginScale = scale;
                        self.beginSpeed = self.beginSpeed;
                    end
                    self.curScale.x = scale;
                    self.curScale.y = scale;
                    self.bottomAlign.localScale = self.curScale;

                    self:_movePopTip();
                end
                if self.isFadeOut then
                    self:_fadeOut(dt);
                else
                    if self.isTimeControl then
                        self.timeControlValue = self.timeControlValue + dt;
                        if self.timeControlValue>=self.waitTime then
                            self.timeControlValue = 0;
                            self.runTime = 0;
                            --self.step = 6;
                            self:_scaleOut();
                        end
                    end  
                end

--            elseif self.step==4 then
--                --??????
--                if self.isTimeControl then
--                    self.runTime = self.runTime + dt;
--                    if self.runTime>=self.waitTime then
--                        self.runTime = 0;
--                        self.step = 5;
--                    end
--                else

--                end
--                self:_movePopTip();
--            elseif self.step==6 then
--                --
--                self:_movePopTip();    
--                self:_fadeOut(dt);
            elseif self.step==7 then
                --?????
                self.runTime = self.runTime + dt;
                local scale = self.beginScale + self.scaleSpeed2*self.runTime + self.scaleAddSpeed2*self.runTime*self.runTime/2;
                if scale>=self.curData.scale then
                    self.step = 0;
                    scale = self.curData.scale;
                    self.runTime = 0;
                    self.beginScale = scale;
                    --????
                    self.gameObject:SetActive(false);
                    self:_hidePopTip();
                end
                self.curScale.x = scale;
                self.curScale.y = scale;
                self.bottomAlign.localScale = self.curScale;
                self:_movePopTip();
                self:_fadeOut(dt);
            end
        end,

        ScaleOut = function(self,dt)
            if not self.isTimeControl then
                self:_scaleOut();
            end
        end,
        _scaleOut = function(self,dt)
            if self.step==4 or self.step==5 then
                self.isFadeOut = true;
                self.isTipFadeOut = true;
            end
        end,
        _movePopTip = function(self)
            --???????λ?????
            self.tipMoveY = self.tipMoveY + self.tipMoveToward;
            if self.tipMoveY<-13  then
                self.tipMoveY = -13;
                self.tipMoveToward = -self.tipMoveToward;
            elseif self.tipMoveY>0 then
                self.tipMoveY = 0;
                self.tipMoveToward = -self.tipMoveToward;
            end

            V_Vector3_Value.x = 0;
            V_Vector3_Value.y = self.tipMoveY;
            V_Vector3_Value.z = 0;

            --???????λ??
            self.tipChairArraw.localPosition = self.tipBeginPos + V_Vector3_Value;
        end,

        --??????
        _showPopTip = function(self)
            self.tipColor.a = 1;
            if self.tipArrawImage then
                self.tipArrawImage.color = self.tipColor;
            end
            if self.tipCharImage then
                self.tipCharImage.color  = self.tipColor;
            end
            self.tipChairTipGameObject:SetActive(true);
        end,

        _hidePopTip = function(self)
            self.tipChairTipGameObject:SetActive(false);
        end,

        --????
        _fadeOut = function(self,dt)
            if self.isTipFadeOut then
                local a = self.tipColorSpeed* dt;
                self.tipColor.a = self.tipColor.a - a;

                if self.tipColor.a <=0.5 then
                    self.step = 7;
                end
                if self.tipColor.a<0.3 then
                    --???????
                    self:_hidePopTip();
                    self.isTipFadeOut = false;
                else
                    if self.tipArrawImage then
                        self.tipArrawImage.color = self.tipColor;
                    end
                    if self.tipCharImage then
                        self.tipCharImage.color  = self.tipColor;
                    end
                end
            end
        end,
        _clear = function(self)
            self.tipChairTip   = nil;
            self.tipChairArraw = nil;
            self.tipChairTipGameObject = nil;
            self.tipMoveY      = 0;
            self.tipBeginPos   = nil;
            self.tipCharImage  = nil;
            self.tipArrawImage = nil;
            self.tipColor      = nil;
        end
    };

    --?????
    self._showPosTipControl:Init(self._enterMask);
end

--????????
function _CPlayersControl:OnUserEnter(_eventId,_user)
    local _isOwner = false;
    if self._isEmpty then
        self._chairIds[0]=1;
        self._chairIds[1]=2;
        self._chairIds[2]=3;
        self._chairIds[3]=4;
        self._isRotation = false;

        self._myChairId = _user.chairId;
        local chairIndex = self._chairIds[_user.chairId];
        self._curPlayerControls = self.playerControls[chairIndex];
        --??????????
        self._showPosTipControl:Start(chairIndex);

        self._isEmpty = false;
        _isOwner = true;
        if self._isRotation then
            self._sceneControl:Rotation();
            self._sceneControl:FadeOutMaskBg();
        else
            self._sceneControl:DisappearMaskBg();
        end
    else
    end
    local curPlayerControls = self.playerControls[self._chairIds[_user.chairId]];
    --UID?????λ??
    self._userIdsMap:assign(_user.uid,_user.chairId);
    --????????????????
    curPlayerControls:OnUserEnter(_user,_isOwner);
    if _isOwner then --?????? ?????????л????
        curPlayerControls:EnabledClickSwitchPaotai(true);
    end
    --???????????????
    curPlayerControls:SetGold(_user.gold);
    curPlayerControls:SetName(_user.name);
end

--???????????
function _CPlayersControl:SetMyGold(_gold)
    --self._goldAtlasNumber:SetNumber(_gold);
end

--????????
function _CPlayersControl:SetName(_name)
    --self._nameLabel.text = _name;
end

function _CPlayersControl:IsRotation()
    return self._isRotation;
end

--???????
function _CPlayersControl:OnClickContinueShot()
--    if self.isContinueShot then
--        self:NormalShot();
--    else
--        self:ContinueShot();
--    end
end

--????????
function _CPlayersControl:NormalShot()
    self._curPlayerControls:NormalShot();

    --??????????仯
    --self._openContinueShotTrans.gameObject:SetActive(true);
    --self.isContinueShot = false;
end

--????
function _CPlayersControl:ContinueShot()
    self._curPlayerControls:ContinueShot();

    --??????????仯
    --self._openContinueShotTrans.gameObject:SetActive(false);
    --self.isContinueShot = true;
end

function _CPlayersControl:_controlContinueShot(_dt)
--    if self.isContinueShot then
--        local rotation = self.continueRotationSpeed * _dt;
--        self._continueStatus:Rotate(Vector3.New(0,0,-rotation));
--    end
end

--?????
function _CPlayersControl:_onAddFishGoldClick()
    ----??????????????????
    --G_GlobalGame._clientSession:SendAddScore();
    self._longKeyPress:Start(BUTTON_TYPE.Btn_UpScore,
                0.4,
                0.2,
                handler(self,self._onSendFishGold),
                handler(self,self._onSendFishGold));
end

function _CPlayersControl:_onAddFishGoldUp()
    self._longKeyPress:Stop(BUTTON_TYPE.Btn_UpScore);
end

function _CPlayersControl:_onSendFishGold()
    --??????????????????
    if GameManager.isEnterGame then
        G_GlobalGame._clientSession:SendAddScore();
    end
    --?????·?????
    G_GlobalGame:PlayEffect(G_GlobalGame_SoundDefine.UpScore);
end


--?·???
function _CPlayersControl:_onRemoveFishGoldClick()
    --????????????·?????
    G_GlobalGame._clientSession:SendRemoveScore();
    ----?????·?????
    G_GlobalGame:PlayEffect(G_GlobalGame_SoundDefine.ChangeScore);
end

--??????
function _CPlayersControl:_onLockFish()
    --??????????????
    self:_openLock();
    local fish =self._fishControl:GetNextLockFish();
    if not fish then
        --??п?????????
        return ;
    end
    self._curPlayerControls:SetLockFish(fish);
end


function _CPlayersControl:_openLock()
    self._isOpenLock = true;
    self.lockBtnObj:SetActive(false);
    self.unlockBtnObj:SetActive(true);
    if self.displayChooseData.isFirstChoose then
        self.displayChooseData.isFirstChoose = false;
        self.displayChooseData.time = 4;
        self.displayChooseData.aphla = 1;
        self.displayChooseData.aphlaSpeed = -0.03;
        self.chooseFishTip.gameObject:SetActive(true);
    end
end

function _CPlayersControl:_closeLock()
    if self.unlockBtnObj then
        self.unlockBtnObj:SetActive(false);
        self.lockBtnObj:SetActive(true);
        self._isOpenLock = false;
    end
end

function _CPlayersControl:IsOpenLock()
    return self._isOpenLock;
end

--??????
function _CPlayersControl:_onUnlockFish()
    self:_closeLock();
    --????????????
    self._curPlayerControls:SetLockFish(nil);
end

--?л???
function _CPlayersControl:_onSwitchFish()
    local curPlayerControl = self._curPlayerControls;
    local fish = curPlayerControl:GetLockFish();
    if fish ==nil then
        --????????????
        return ;
    end
    fish = self._fishControl:GetNextLockFish(fish);
    if fish ==nil then
        self:_onUnlockFish();
    else
        --?л??????
        curPlayerControl:SetLockFish(fish);
    end
end

--????????
function _CPlayersControl:OnCreateFlyGold(_eventId,_eventData)
    local  _type,_count,_chairId,_pos,_isRotation;
    _type = _eventData.goldType;
    _count = _eventData.gold;
    _chairId = _eventData.chairId;
    _pos     = _eventData.pos ;
    _isRotation = _eventData.isRotation;
    local curPlayerControl = self.playerControls[self._chairIds[_chairId]];
    if not curPlayerControl  or curPlayerControl:IsEmpty() then
       return ;
    end
    self._flyGoldControl:CreateFlyGold(_chairId,_type,_count,_pos,curPlayerControl:FlyGoldPosition(),_isRotation);
end

--?л?????????
function _CPlayersControl:OnSwitchNextLockFish(_chairId,_fish)
    if _chairId==self._myChairId then
        self:_onSwitchFish();
    else
        local curPlayerControl = self.playerControls[self._chairIds[_chairId]];
        local fish = curPlayerControl:GetLockFish();
        if fish ==nil then
            --????????????
            curPlayerControl:SetLockFish(nil);  
            return ;
        end
        fish = self._fishControl:GetNextLockFish(fish);
        curPlayerControl:SetLockFish(fish);       
    end
end

--?????
function _CPlayersControl:OnUserLeave(_eventId,_user)
    local chairId = self._userIdsMap:erase(_user.uid);
    if chairId then
        local curPlayerControl = self.playerControls[self._chairIds[chairId]];
        curPlayerControl:OnUserLeave(_user);
    end
end

--??????????????
function _CPlayersControl:OnUserFire(_eventId,_fire)
    --????????????
    if not self._isCanCreateBullet then
        return ;
    end
    local curPlayerControl = self.playerControls[self._chairIds[_fire.chairId]];
    if curPlayerControl:IsEmpty() then
        return;
    end
    if _fire.chairId == self._myChairId then
        --??????
        curPlayerControl:OnUserFire(_fire,self._myChairId);
    else
        --???????
        curPlayerControl:OnUserFire(_fire,self._myChairId);
    end
end

--????л???
function _CPlayersControl:OnUserChangeBullet(_data)

end

--??????
function _CPlayersControl:OnExchangeFishGold(_eventId,_exchangeData)
    local curPlayerControl = self.playerControls[self._chairIds[_exchangeData.chairId]];
    curPlayerControl:SetFishGold(_exchangeData.fishGold);
    if _exchangeData.chairId==self._myChairId then
        if curPlayerControl:IsEnoughFire() then
            --?????????
            self:_setScoreTipsVisible(false);
        end
    end
end


--
function _CPlayersControl:IsNeedShowEffectKillFish(fishType)
    if (fishType>= G_GlobalGame_Enum_FishType.FISH_KIND_17 and fishType<= G_GlobalGame_Enum_FishType.FISH_KIND_21) then
        return true;
    end
    return false;
end

--?????
function _CPlayersControl:OnCatchFish(_eventId,_fishInfo)
    --???????
    local fish = self._fishControl:GetFish(_fishInfo.fishId);
    if not fish then
        --???????????????
        return ;
    end
    local fishType = fish._fishType;
    local fishConfig = G_GlobalGame_GameConfig_FishInfo[fishType];
    local curPlayerControl = self.playerControls[self._chairIds[_fishInfo.chairId]];
    if fishConfig.effectType == G_GlobalGame_Enum_FISH_Effect.Common_Fish then
        --?????
        fish:Die();

        --???????
        curPlayerControl:SetFishGold(_fishInfo.totalFishGold);

        --????
        local isRotation
        if self._chairIds[_fishInfo.chairId]>=3 then
            isRotation = true;
        else
            isRotation = false;
        end

        if self:IsNeedShowEffectKillFish(fishType) then
            self._uiEffectControl:ShowEffectKillFish(_fishInfo.chairId,
                fishType,_fishInfo.fishGold,fish:Position(),
                curPlayerControl:KillFishNumberPosition(),true,curPlayerControl);
        else
            if fishConfig.gold>0 then
                fish:FlyGoldData({goldType = G_GlobalGame_Enum_GoldType.Gold,gold = fishConfig.gold,chairId = _fishInfo.chairId,pos = fish:Position(),isRotation = isRotation});         
            end

            if _fishInfo.fishGold>0 then
                if _fishInfo.chairId == self._myChairId then
                    self._showGoldNumControl:CreateNumber(_fishInfo.fishGold,fish:Position());
                else
                    self._showGoldNumControl:CreateSilverNumber(_fishInfo.fishGold,fish:Position()); 
                end
                --????
                curPlayerControl:WinFishGold(_fishInfo.fishGold);
            end
        end

    elseif fishConfig.effectType == G_GlobalGame_Enum_FISH_Effect.Stop_Fish then
        --???
        fish:Die();

        curPlayerControl:SetFishGold(_fishInfo.totalFishGold);
        --????
        self._sceneControl:Pause();

        if G_GlobalGame_FunctionsLib.Mod_Fish_IsNeedWheel(fishType) then
            --?????
            curPlayerControl:Wheel(_fishInfo.fishGold);
        end

        --???????????
        if _fishInfo.bulletIon==1 then
            --?????????
            curPlayerControl:ChangeToEnergy();
        end

        --????
        local isRotation
        if self._chairIds[_fishInfo.chairId]>=3 then
            isRotation = true;
        else
            isRotation = false;
        end

        if self:IsNeedShowEffectKillFish(fishType) then
            self._uiEffectControl:ShowEffectKillFish(_fishInfo.chairId,fishType,_fishInfo.fishGold,fish:Position(),
                curPlayerControl:KillFishNumberPosition(),true,curPlayerControl);
        else
            if fishConfig.gold>0 then
                fish:FlyGoldData({goldType = G_GlobalGame_Enum_GoldType.Gold,gold = fishConfig.gold,chairId = _fishInfo.chairId,pos = fish:Position(),isRotation = isRotation});
            end

            if _fishInfo.fishGold>0 then
                if _fishInfo.chairId == self._myChairId then
                    self._showGoldNumControl:CreateNumber(_fishInfo.fishGold,fish:Position());
                else
                    self._showGoldNumControl:CreateSilverNumber(_fishInfo.fishGold,fish:Position()); 
                end

                curPlayerControl:WinFishGold(_fishInfo.fishGold);
            end
        end
    elseif fishConfig.effectType == G_GlobalGame_Enum_FISH_Effect.Bomb_Fish then
        --??????????????
        local vec=nil;

        --???????????
        if _fishInfo.bulletIon==1 then
            --?????????
            curPlayerControl:ChangeToEnergy();
        end

        if fishType == G_GlobalGame_Enum_FishType.FISH_KIND_23 then
            --??????
            vec = self._fishControl:GetFishesInScreenInnerRound(fish,G_GlobalGame_GameConfig_SceneConfig.bombRound);
        else
            --??????
            vec = self._fishControl:GetFishesInScreenExceptFish(fish);
        end
        --???????
        G_GlobalGame._clientSession:SendCatchSweepFish(_fishInfo.chairId,_fishInfo.fishId,vec);

    elseif fishConfig.effectType == G_GlobalGame_Enum_FISH_Effect.Fish_Boss then
        --????????????????

        --???????????
        if _fishInfo.bulletIon==1 then
            --?????????
            curPlayerControl:ChangeToEnergy();
        end
        local vec = self._fishControl:GetFishesInScreenWithFishType(fishType-30);
        --???????
        G_GlobalGame._clientSession:SendCatchSweepFish(_fishInfo.chairId,_fishInfo.fishId,vec);
    end

end

local _Common_LineEffectData = 
{type=1,sourcePos = 1,endPos = 1,vec=1};

--??????
function _CPlayersControl:OnCatchGroupFish(_eventId,_fishGroupInfo)
    local chairId = _fishGroupInfo.chairId;
    local curPlayerControl = self.playerControls[self._chairIds[chairId]];    
    local isRotation = false;

    local causeFishData = _fishGroupInfo.causeFish;
    --????????
    local causeFish = self._fishControl:GetFalseDieFish(causeFishData.fishId);
    if not causeFish then
        --?????????
        return ;
    end
    local fishType = causeFish._fishType;
    local fishConfig = G_GlobalGame_GameConfig_FishInfo[fishType];
    if not fishConfig then
        return 
    end
    local fish;
    local isLine = false;
    local position = causeFish:Position();
    local isNeedPause = true;
    local tab = {type = G_GlobalGame_Enum_EffectType.Line, bossPosition = position};
    local time = nil;
    if fishConfig.effectType == G_GlobalGame_Enum_FISH_Effect.Fish_Boss then
        --??????????Ч??
        isLine = true;
        time = 1.9 + _fishGroupInfo.catchFishCount*0.1;
    end

    if fishType == G_GlobalGame_Enum_FishType.FISH_KIND_24 then
        isNeedPause = false;
    end

    if self:IsNeedShowEffectKillFish(fishType) then
        self._uiEffectControl:ShowEffectKillFish(chairId,fishType,
            causeFishData.fishScore,causeFish:Position(),
                curPlayerControl:KillFishNumberPosition(),false);
    else
        if fishConfig.gold>0 then
            causeFish:FlyGoldData({goldType = G_GlobalGame_Enum_GoldType.Gold,gold = fishConfig.gold,chairId = chairId,pos = causeFish:Position(),isRotation = isRotation});
        end

        if causeFishData.fishScore>0 then
            if chairId == self._myChairId then
                self._showGoldNumControl:CreateNumber(causeFishData.fishScore,position,time);
            else
                self._showGoldNumControl:CreateSilverNumber(causeFishData.fishScore,position,time); 
            end
        end
    end
    if isLine then
        causeFish.isFalseDie = false;
        causeFish:DeadRotation();
    else
        --??????
        causeFish:RealDie();    
    end
    local otherFishDead = function()
        local fishData;
        local fishType;
        for i=1,_fishGroupInfo.catchFishCount do
            fishData = _fishGroupInfo.catchFishes[i];
            fish = self._fishControl:GetFish(fishData.fishId);
            if fish then
                fishType = fish._fishType;
                if fishType >= G_GlobalGame_Enum_FishType.FISH_KIND_22 and  fishType <= G_GlobalGame_Enum_FishType.FISH_KIND_24 then
                    fish:NotPlaySound();
                end
                if fish._fishType == G_GlobalGame_Enum_FishType.FISH_KIND_21 then
                    if isNeedPause then
                        fish:Die();
                    else
                        fish:Die(false);
                    end
                else
                    fish:Die();
                end
            
                fishConfig = G_GlobalGame_GameConfig_FishInfo[fishType];
                if self:IsNeedShowEffectKillFish(fishType) then
                    self._uiEffectControl:ShowEffectKillFish(chairId,
                        fishType,fishData.fishScore,fish:Position(),
                        curPlayerControl:KillFishNumberPosition(),false);
                else
                    if fishConfig.gold>0 then
                        fish:FlyGoldData({goldType = G_GlobalGame_Enum_GoldType.Gold,  gold = fishConfig.gold,chairId = chairId,pos = fish:Position(),isRotation = isRotation});             
                    end
                    if chairId == self._myChairId then
                        self._showGoldNumControl:CreateNumber(fishData.fishScore,fish:Position(),time);
                    else
                        self._showGoldNumControl:CreateSilverNumber(fishData.fishScore,fish:Position(),time); 
                    end
                end
            end;
        end
    end

    local otherFishLineDead = function()
        local fishData;
        local fishType;
        local lineVec = {};
        for i=1,_fishGroupInfo.catchFishCount do
            fishData = _fishGroupInfo.catchFishes[i];
            fish = self._fishControl:GetFish(fishData.fishId);
            if fish then
                fishType = fish._fishType;
                if fishType >= G_GlobalGame_Enum_FishType.FISH_KIND_22 and  fishType <= G_GlobalGame_Enum_FishType.FISH_KIND_24 then
                    fish:NotPlaySound();
                end

                fish:DeadRotation(causeFish:LocalRotation());

                fishConfig = G_GlobalGame_GameConfig_FishInfo[fishType];
                if self:IsNeedShowEffectKillFish(fishType) then
                    self._uiEffectControl:ShowEffectKillFish(chairId,
                        fishType,_fishInfo.fishGold,fish:Position(),
                        curPlayerControl:KillFishNumberPosition(),false);
                else
                    if fishConfig.gold>0 then
                        fish:FlyGoldData({goldType = G_GlobalGame_Enum_GoldType.Gold,  gold = fishConfig.gold,chairId = chairId,pos = fish:Position(),isRotation = isRotation});             
                    end

                    if fishData.fishScore>0 then
                        if chairId == self._myChairId then
                            self._showGoldNumControl:CreateNumber(fishData.fishScore,fish:Position(),time);
                        else
                            self._showGoldNumControl:CreateSilverNumber(fishData.fishScore,fish:Position(),time); 
                        end
                    end
                end
                time = time - 0.1;
                if isLine then
                    local sourcePos = causeFish:DeadRotationWorldPos();
                    --????????
                    local position = fish:DeadRotationWorldPos();
                    _Common_LineEffectData.sourcePos=sourcePos;
                    _Common_LineEffectData.endPos = position;
                    _Common_LineEffectData.vec = lineVec;
                    _Common_LineEffectData.type=G_GlobalGame_Enum_EffectType.Line;
                    --{type=G_GlobalGame.Enum_EffectType.Line,sourcePos = sourcePos,endPos = position,vec=lineVec,}
                    G_GlobalGame:DispatchEvent(G_GlobalGame_EventID.NotifyCreateLine,_Common_LineEffectData); 
                end
                coroutine.wait(0.1);
                if G_GlobalGame.isQuitGame and G_GlobalGame_clientSession.isReloadGame then
                    return ;
                end
            end
        end

        coroutine.wait(2);
        if G_GlobalGame.isQuitGame then
            return ;
        end
        --?????????
        for i=1,_fishGroupInfo.catchFishCount do
            fishData = _fishGroupInfo.catchFishes[i];
            fish = self._fishControl:GetFish(fishData.fishId);
            if fish then
                fish:_onDieActionOver();
            end
        end
        causeFish:_onDieActionOver();
        for i=1,#lineVec do
            lineVec[i]:Disappear();
        end
        lineVec = nil
    end

    coroutine.start(function()
        coroutine.wait(0.5);
        if G_GlobalGame.isQuitGame then
            return ;
        end
        if isLine then
            coroutine.start(otherFishLineDead);
        else
            otherFishDead();
        end
    end
    );
    --???????
    curPlayerControl:AddFishGold(_fishGroupInfo.fishGold);
  
    --????
    curPlayerControl:WinFishGold(_fishGroupInfo.fishGold);

    if G_GlobalGame_FunctionsLib.Mod_Fish_IsNeedWheel(fishType) then
        --?????
        curPlayerControl:Wheel(_fishGroupInfo.fishGold);
    end
end

function _CPlayersControl:OnUserScoreChange(_eventId,_userScore)
    if self._myChairId == _userScore.chairId then
        --????????????
        --self:SetMyGold(_userScore.gold);
    end
    --???????
    local curPlayerControls = self.playerControls[self._chairIds[_userScore.chairId]];
    if curPlayerControls then
        curPlayerControls:SetGold(_userScore.gold);
    end
end

--?????????
function _CPlayersControl:OnEnergyTimeOut(_eventId,_info)
    local curPlayerControl = self.playerControls[self._chairIds[_info.chairId]];  
    if curPlayerControl then
        curPlayerControl:ChangeToNormal();
    end
end

--UI???????????????????
function _CPlayersControl:UIPointChangeToScenePoint(targetPoint)

end

--???????????????UI????
function _CPlayersControl:ScenePointChangeToUIPoint(scenePoint)

end


--??????
function _CPlayersControl:Update(_dt)
    --????????
    if self._btnsGroup then
        --?????
        self._btnsGroup:Update(_dt);
    end

    --λ?????
    if self._showPosTipControl then
        self._showPosTipControl:Update(_dt);
    end

    --??????????
    self:_controlContinueShot(_dt);

    for i=1,G_GlobalGame_ConstDefine.C_S_PLAYER_COUNT do
        if self.playerControls[i] then
            self.playerControls[i]:Update(_dt);
        end
    end
    self._flyGoldControl:Update(_dt);
    if not self:IsInNewHand() then
        self:_onFire();
    end
    self._longKeyPress:Execute(_dt);
    self._showGoldNumControl:Update(_dt);

    if not self._isEmpty then
        --?????  
        if self._curPlayerControls:IsEnoughFire() then
            --?????????
            self:_setScoreTipsVisible(false);
        end
    end

    --????UI?????????Ч
    if self._uiEffectControl then
        self._uiEffectControl:Update(_dt);
    end
    --????????????????????????????????
    --self.upPlayers.localScale = Vector3.New(1,1,1);
    --self.downPlayers.localScale = Vector3.New(1,1,1);
    --self.bottomPanel.localScale = Vector3.New(1,1,1);
end

local inorgeTargetName = "GameScene";
function lookupParentIsName(go,name)
    if not go then
        return false;
    end 
    if go.name == name then
        return true;
    end
    local parent = go.transform.parent;
    if parent then
        return lookupParentIsName(parent.gameObject);
    end
    return false;
end

local Input_GetKey = Input.GetKey;
local KeyCode_Mouse0 = KeyCode.Mouse0;
local KeyCode_Space = KeyCode.Space;
local Input_GetMouseButton = Input.GetMouseButton;
local Util_IsPointerOverGameObject = Util.IsPointerOverGameObject2;

function _CPlayersControl:_onFire()
    if self._myChairId==G_GlobalGame_ConstDefine.C_S_INVALID_CHAIR_ID then
        return ;
    end
    local targetPos=Input.mousePosition;
    local curPlayerControls = self._curPlayerControls;

    local isClickBtn = false;
    local isClick = (Input_GetKey(KeyCode_Mouse0) == true or Input_GetKey(KeyCode_Space) == true or Input_GetMouseButton(0) == true );

    if isClick then
        if self._lastIsClick then
            isClickBtn = self._lastClickBtn;
        else
            if Util_IsPointerOverGameObject(G_GlobalGame._canvasComponent,targetPos) then
                isClickBtn = true; 
            end            
        end
        self._lastIsClick = true;
    else
        self._lastIsClick = false;
    end

    self._lastClickBtn = isClickBtn;

    --?????ε??
    self._lastClick = self._curClick;
    if isClick then
        if isClickBtn then
            self._curClick = false;
        else
            self._curClick = true;
        end
    else
        self._curClick = false;   
    end

    if not curPlayerControls:IsEnoughFire() then
        --????????
        self:_setScoreTipsVisible(true);
        --???????
        if self._btnsGroup:IsContinueShot() then
            --???????
            self._btnsGroup:CloseContinueShot();
        end
    end
--    if curPlayerControls._fireInterval>0 then --????????????
--        return;
--    end
    if self:IsOpenLock() then
        if self._curClick and not self._lastClick and not isClickBtn then
            --?л???
            local fish = self:GetCanLockFishByPos(targetPos);
            if fish then
                curPlayerControls:SetLockFish(fish);
            end
        end
    end
    
    if not self._isCanCreateBullet or not curPlayerControls:IsEnoughFire()  then
        --???????
        --????????
        if self._isNeedClickToward then
            if self._curClick then
                targetPos = G_GlobalGame:SwitchScreenPosToWorldPosByUICameraEx(targetPos);
                curPlayerControls:TowardTarget(targetPos);
            else
                curPlayerControls:TowardTarget(nil);
            end
        else
            targetPos = G_GlobalGame:SwitchScreenPosToWorldPosByUICameraEx(targetPos);
            curPlayerControls:TowardTarget(targetPos);
        end
    else
        --???????
        if self._btnsGroup:IsContinueShot() or self._curClick then
            if self._isNeedClickToward then
                if self._curClick then
                    targetPos = G_GlobalGame:SwitchScreenPosToWorldPosByUICameraEx(targetPos);
                    curPlayerControls:UserFire(targetPos,true);
                else
                    curPlayerControls:UserFire(nil,true);
                end
            else
                if self._curClick then
                    targetPos = G_GlobalGame:SwitchScreenPosToWorldPosByUICameraEx(targetPos);
                    curPlayerControls:UserFire(targetPos,true);
                else
                    curPlayerControls:UserFire(nil,true);
                end
            end
        end
    end
    return true;
end

function _CPlayersControl:_changeToPlayerPos(targetPos)
    --self.downPlayers
end

function _CPlayersControl:_setScoreTipsVisible(isVisible)
    self._addScoreTips.gameObject:SetActive(isVisible);
end

function _CPlayersControl:_getSepNumber(_chr)
    --if self._myChairId~=G_GlobalGame.ConstDefine.C_S_INVALID_CHAIR_ID then
    --    local curPlayerControls = self.playerControls[self._chairIds[self._myChairId]];
    --    return curPlayerControls:_getSepNumber(_chr);
    --end
    --return nil;
    return self._showGoldNumControl:_createNumberSpr(_chr);
end

--??????????
function _CPlayersControl:PauseCreateBullet()
    self._isCanCreateBullet = false; 
end

--??????????
function _CPlayersControl:ResumeCreateBullet()
    self._isCanCreateBullet = true;
end

--function _CPlayersControl:On

--????л????
function _CPlayersControl:OnSwitchPaotai()
    self._curPlayerControls:SwitchPaotai();
end

--??????????
function _CPlayersControl:OnAddScore()
    --??????????????????
    G_GlobalGame._clientSession:SendAddScore();
    --G_GlobalGame:PlayEffect(G_GlobalGame.SoundDefine.UpScore);
end

--????????????
function _CPlayersControl:OnNewHandEnd()
    local da={[1]=G_GlobalGame_ConstDefine.GAME_ID};
    UserNewHand[#UserNewHand+1]=da;

    G_GlobalGame._clientSession:NewHandOver();

    self._isNewHand = false;
end

--????????????
function _CPlayersControl:IsNeedNewHandGuide()
    local isNewHand = true;
    if UserNewHand==nil then
        return isNewHand;
    end
    for i=1,#UserNewHand do
        if UserNewHand[i]==nil then
        elseif UserNewHand[i][1]==G_GlobalGame_ConstDefine.GAME_ID then
            isNewHand = false;
            break;
        else
        end
    end
    return isNewHand;
end

--???????????
function _CPlayersControl:StartNewHand()
    --[[
    self._isNewHand = true;
    self._newHandControl = CNewHandControl.New();
    local obj  = G_GlobalGame._goFactory:createNewHand();
    local transform = obj.transform;
    self._newHandControl:Init(transform,self._myChairId);
    local localPosition = transform.localPosition;
    local localScale    = transform.localScale;
    transform:SetParent(self._uiTransform);
    transform.localScale     = localScale;
    transform.localPosition  = localPosition;
    --]]
end

--???????????
function _CPlayersControl:IsInNewHand()
    return self._isNewHand;
end

--??????е????
function _CPlayersControl:ClearAllPlayers()
    --self:_onUnlockFish();
    local chairId ;
    local curPlayerControl;

    for i=1,4 do
        curPlayerControl = self.playerControls[i];
        if curPlayerControl then
            curPlayerControl:OnUserLeave();
        end
    end
    self._isEmpty = true;
    
    self._userIdsMap:clear();
    self._myChairId = G_GlobalGame_ConstDefine.C_S_INVALID_CHAIR_ID;
    self._showPosTipControl:clear();
end


function _CPlayersControl:Unload()
    self._showPosTipControl:_clear();
end


return _CPlayersControl;
