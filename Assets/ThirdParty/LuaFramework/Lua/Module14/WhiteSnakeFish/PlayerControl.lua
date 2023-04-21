--图锟斤拷锟斤拷锟斤拷
local CEventObject = GameRequire("EventObject");

--图锟斤拷锟斤拷锟斤拷
local CAtlasNumber = GameRequire("AtlasNumber");

--锟缴斤拷夜锟斤拷锟?
local CFlyGoldControl = GameRequire("FlyGoldControl");

--锟斤拷锟斤拷锟斤拷锟斤拷
local CNewHandControl = GameRequire("NewHandControl");

local _CScoreColumn = class("_CScoreColumn",CEventObject);

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

    --锟角凤拷锟斤拷示锟斤拷锟斤拷
    self.isDisplayBorn  = false;
    self.bornTime       = 0;
    self.bornCount      = 1;
    self.totalCount     = 0;
    self.bornDisplayInterval = 0.009;
    self.bornDisplayAddSpeed = 0.0005;
    self.bornMaxInterval = 0.012;
    self.bornSpeed      = 1;
end

function _CScoreColumn:Init(transform,sprCreator)
    self.transform  = transform;
    self.gameObject = transform.gameObject;
    self.itemParent = transform:Find("Items");
    self.scoreParent= transform:Find("ScoreBg");
    self.allImage[0]= self.scoreParent:GetComponent("Image");
    self.scoreRectTransform = self.scoreParent:GetComponent("RectTransform");
    self.defaultW   = self.scoreRectTransform.sizeDelta.x;
    self.defaultH   = self.scoreRectTransform.sizeDelta.y;
    self.itemTemp   = self:AddGoldItem();
    --self.itemTemp   = self.itemParent:Find("Item").gameObject;
    self.maxCount   = 1;
    self.items[1]   = self.itemTemp;
    self.allImage[1]= self.itemTemp:GetComponent(typeof(UnityEngine.UI.Image));
    local spr       = self.allImage[1].sprite;
    self.itemH      = spr.rect.size.y;
    self.displayCount   = 1;
    self.getScoreLabel  = CAtlasNumber.New(sprCreator);
    self.getScoreLabel:SetParent(self.scoreParent);

    spr             = self.scoreParent:GetComponent(typeof(UnityEngine.UI.Image)).sprite;
    self.scoreBgH      = spr.rect.size.y;
end

function _CScoreColumn:Color()
    return self.color;
end

function _CScoreColumn:AddGoldItem()
    local item = G_GlobalGame._goFactory:createGoldItem();
    item.transform:SetParent(self.itemParent);
    item.transform.localPosition = Vector3.zero;
    item.transform.localScale    = Vector3.New(1,1,1);
    item.transform.localRotation = Quaternion.Euler(0,0,0);
    item.name = "Item";
    return item;
end

--锟斤拷锟矫凤拷锟斤拷锟斤拷时锟斤拷
function _CScoreColumn:SetScore(_score,_displayerTime)
    local count ;
    if _score<=400000 then
        count = math.floor(_score/14000);
    else
        count = math.floor((_score-400000)/230000)+28;
    end
    if count>40 then
        count = 40;
    end
    if count<2 then
        count=2;
    end
    self.gameObject:SetActive(true);
    self:_setDisplayCount(count,_score);
    self.displayTime = _displayerTime;
    self.isFadeOut = false;

    --锟斤拷锟斤拷锟斤拷锟斤拷
    self.isDisplayBorn  = true;
    self.bornTime       = 0;
    self.bornCount      = 0;
    self.totalCount     = count;
    self.bornDisplayInterval = 0.1;
    if count>30 then
        self.bornSpeed = 1;
    elseif count>20 then
        self.bornSpeed = 1.6;
    elseif count>10 then
        self.bornSpeed = 2.4;
    else
        self.bornSpeed = 3;
    end 
    --self:_setDisplayCount(self.bornCount,_score);    
end

--锟角凤拷锟斤拷锟?
function _CScoreColumn:IsBorn()
    return self.isDisplayBorn;
end

--锟斤拷锟斤拷
function _CScoreColumn:Hide()
    self.gameObject:SetActive(false);
end

--锟斤拷锟矫憋拷锟斤拷锟斤拷锟斤拷
function _CScoreColumn:SetLocalPosition(localPosition)
    self.transform.localPosition = localPosition;
end

--锟斤拷锟矫斤拷锟斤拷位锟斤拷
function _CScoreColumn:SetEndPosition(localEndPosition)
    if self.isMove then
        self.transform.localPosition = self.endPosition;
    end
    self.isMove = true;
    self.endPosition = localEndPosition;
end

function _CScoreColumn:_setDisplayCount(_count,_score)
    if self.maxCount< _count then
        --锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟絠tem;
        local count = _count-self.maxCount;
        local item;
        local image;
        local beginY = self.itemH *(self.maxCount);
        for i=1,count do
            item = self:AddGoldItem();
            item.transform.localPosition = Vector3.New(0,beginY,0);
            beginY = beginY + self.itemH;
            self.items[self.maxCount+1] = item;
            self.maxCount = self.maxCount + 1;
            self.allImage[#self.allImage+1] = item:GetComponent("Image");
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

    --锟斤拷锟矫凤拷锟斤拷锟斤拷示锟斤拷位锟斤拷
    local y = self.itemH *(_count-1)+0.5 *self.itemH + self.scoreBgH/2;
    self.scoreParent.localPosition = Vector3.New(0,y,0);

    --锟斤拷锟矫凤拷锟斤拷
    if _score then
        self.getScoreLabel:SetNumber(_score);
    end
    local w = self.getScoreLabel:Width();
    if w<self.defaultW-20 then
        self.scoreRectTransform.sizeDelta =Vector2.New(self.defaultW,self.defaultH);
    else
        self.scoreRectTransform.sizeDelta =Vector2.New(w+20,self.defaultH);
    end
end

--锟斤拷锟斤拷alpha值
function _CScoreColumn:SetAlpha(_a)
    self.alpha = _a;
    self.getScoreLabel:SetAlpha(_a);
    local color = nil;
    for i=0,#self.allImage do
        color = self.allImage[i].color;
        self.allImage[i].color =Color.New(color.r,color.g,color.b,_a);
    end
end

function _CScoreColumn:Update(_dt,_moveToward)
    if self.waitTime>0 then
        --锟饺达拷时锟斤拷
        self.waitTime = self.waitTime - _dt;
        if self.waitTime<0 then
            self.gameObject:SetActive(true);
            self:Update(-self.waitTime,_moveToward);
            self.waitTime = 0;
            return ;
        end
    end
    if self.isDisplayBorn then
        --锟斤拷锟斤拷锟绞斤拷锟斤拷锟?
        self.bornTime = self.bornTime + _dt;
        while(true) do
            if self.bornTime< self.bornDisplayInterval*self.bornSpeed then
                break;
            end
            self.bornCount = self.bornCount + 1;
            self.bornTime = self.bornTime - self.bornDisplayInterval*self.bornSpeed;
            self.bornDisplayInterval = self.bornDisplayInterval + self.bornDisplayAddSpeed;
            if self.bornDisplayInterval>self.bornMaxInterval then
                self.bornDisplayInterval = self.bornMaxInterval;
            end 
            if self.bornCount>= self.totalCount then
                self.bornCount = self.totalCount;
                self.isDisplayBorn = false;
                break;
            end
        end
        self:_setDisplayCount(self.bornCount);
--        local count = math.floor(self.bornTime/self.bornDisplayInterval);
--        if count<1 then
--            count = 1;
--        end
--        if count>= self.totalCount then
--            count = self.totalCount;
--            self.isDisplayBorn = false;
--        end
--        self:_setDisplayCount(count);
        return ;
    end
    if self.isMove then
        --锟狡讹拷锟斤拷叶锟?
        local moveDis = _moveToward * G_GlobalGame.GameConfig.SceneConfig.goldColumnMoveSpeed*_dt;
        local x = self.transform.localPosition.x;
        x = x + moveDis;
        if _moveToward<0 then
            if self.endPosition.x>= x then
                self.transform.localPosition = self.endPosition;
                self.isMove = false;
            else
                self.transform.localPosition = self.transform.localPosition + Vector3.New(moveDis,0,0);
            end
        else
            if self.endPosition.x<= x then
                self.transform.localPosition = self.endPosition;
                self.isMove = false;
            else
                self.transform.localPosition = self.transform.localPosition + Vector3.New(moveDis,0,0);
            end
        end
    end
    if self.isFadeOut then
        self.alpha = self.alpha - 0.5*_dt;
        if self.alpha<0 then
            self.alpha=0;
            --锟斤拷叶锟斤拷锟绞?
            self:SendEvent(G_GlobalGame.Enum_EventID.ScoreColumnDisappear);
        end
        self:SetAlpha(self.alpha);
    else
        self.displayTime = self.displayTime - _dt;
        if self.displayTime>0 then
        else
            --时锟戒到锟斤拷
            self.isFadeOut = true;
        end
    end
end

function _CScoreColumn:SetWaitTime(_waitTime)
    self.waitTime = _waitTime or 0;
    if self.waitTime>0 then
        self.gameObject:SetActive(false);
    else
        self.gameObject:SetActive(true);
    end
end

--锟截革拷锟斤拷锟斤拷
function _CScoreColumn:Normal()
    self:SetAlpha(1);
    self.isFadeOut = false;
end

--锟斤拷锟斤拷
function _CScoreColumn:FadeOut()
    self.isFadeOut = true;
    self:SetAlpha(0.6);
end

--锟角凤拷锟窖撅拷锟斤拷示锟斤拷锟?
function _CScoreColumn:IsOver()
    return self.displayTime<=0;
end


--锟斤拷叶压锟斤拷锟?
local _CScoreColumnsControl = class("_CScoreColumnsControl");

function _CScoreColumnsControl:ctor(displayCount,displayTime,moveToward)
    self.displayingVec  = vector:new();
    --锟斤拷锟斤拷锟叫憋拷
    self.cacheColorMap  = map:new();
    --删锟斤拷锟叫憋拷
    self.delListVec     = vector:new();
    self.displayCount   = displayCount;
    self.displayTime    = displayTime;
    self.points         = {};
    self.transform      = nil;
    self.gameObject     = gameObject;
    self.color          = 0;
    self.delCount       = 0;
    self.moveToward     = moveToward;

    --准锟斤拷锟斤拷示
    self.readyToDisplay = vector:new();
end


function _CScoreColumnsControl:Init(transform)
    self.transform = transform;
    self.gameObject = gameObject;
    -- local numberImage = transform:Find("Numbers"):GetComponent("ImageAnima");
    local numberImage = HallScenPanel.GetImageAnima(transform:Find("Numbers"));
    self.numbers = {};
    local count=numberImage.lSprites.Count;
    for i=0,count-1 do
        self.numbers[tostring(i)] =numberImage.lSprites[i];
    end
    local columns = transform:Find("Columns");
    local childCount = columns.childCount;
    local child=columns:GetChild(0);
    local scoreColumn;
    local dis = G_GlobalGame.GameConfig.SceneConfig.goldColumnDis
    self.points[0] = child.localPosition;
    for i=1,self.displayCount + 1 do 
        self.points[i] = self.points[i-1] + Vector3.New(self.moveToward*dis);
    end
    self.columnsTranform = columns;
end

--锟矫碉拷锟斤拷一锟斤拷锟斤拷色
function _CScoreColumnsControl:getNextColor()
    self.color = self.color==1 and 0 or 1;
    return self.color;
end

--锟斤拷示锟斤拷锟斤拷
function _CScoreColumnsControl:DisplayScore(_score)
    --锟斤拷锟斤拷位锟斤拷
    local scoreColumn = self.displayingVec:get(1);
    if scoreColumn and scoreColumn:IsBorn() then
        self.readyToDisplay:push_front(_score);
        return ;
    end
    self:_displayScore(_score);
end

function _CScoreColumnsControl:_displayScore(_score)
    local function createSprite(_chr)
        return self.numbers[_chr];
    end
    if self.displayingVec:size()>=self.displayCount then
        local scoreColumn = self.displayingVec:get(G_GlobalGame.GameConfig.SceneConfig.goldColumn);
        --锟斤拷锟斤拷
        scoreColumn:FadeOut();
    end
    local color = self:getNextColor();
    local vec = self.cacheColorMap:value(color);
    local scoreColumn = nil;
    if vec==nil or vec:size()==0 then
        --没锟叫伙拷锟斤拷
        scoreColumn = _CScoreColumn.New(color);
        local obj = G_GlobalGame._goFactory:createScoreColumn(color);
        scoreColumn:Init(obj.transform,createSprite);
    else
        scoreColumn = vec:pop();
        scoreColumn:Normal();
    end
    scoreColumn:RegEvent(self,self.OnScoreColumnEvent);
    scoreColumn:SetParent(self.columnsTranform);
    scoreColumn:SetScore(_score,self.displayTime);
    self.displayingVec:push_front(scoreColumn);
    --scoreColumn:SetLocalPosition(self.points[0]);
    --直锟斤拷锟斤拷示锟节改筹拷锟街碉拷位锟斤拷
    scoreColumn:SetLocalPosition(self.points[1]);
    --锟斤拷原锟斤拷锟斤拷
    scoreColumn:SetLocalRotation(Quaternion.Euler(0,0,0));
    if self.displayingVec:size()>=2 then
        scoreColumn:SetWaitTime(0.15);
    else
        scoreColumn:SetWaitTime(0);
    end
    --锟斤拷锟斤拷位锟斤拷
    local it = self.displayingVec:iter();
    local val= it();
    local i=1;
    while(val) do
        if self.points[i]~=nil then
            val:SetEndPosition(self.points[i]);
        end
        i = i + 1;
        val=it();
    end
end

function _CScoreColumnsControl:OnScoreColumnEvent(_eventId,_eventObj)
    if _eventId == G_GlobalGame.Enum_EventID.ScoreColumnDisappear then
        --锟斤拷叶锟斤拷锟绞э拷锟斤拷锟斤拷锟?
        --self.delListVec:Push(_eventObj:LID());
        self.delCount = self.delCount + 1;
    end
end

--每帧执锟斤拷
function _CScoreColumnsControl:Update(_dt)
    local column
    local color
    local vec
    while(self.delCount>0) do
        column = self.displayingVec:pop();
        column:Cache();
        color = column:Color();
        vec = self.cacheColorMap:value(color);
        if vec==nil then
            vec = vector:new();
            self.cacheColorMap:assign(color,vec);
        end
        vec:push_front(column);
        self.delCount = self.delCount - 1;
    end
    local it = self.displayingVec:iter();
    local val= it();
    while(val) do
        val:Update(_dt,self.moveToward);
        val = it();
    end

    --锟斤拷锟斤拷锟斤拷要锟斤拷示锟斤拷
    local size = self.readyToDisplay:size();
    if size>0 then
        --锟斤拷锟斤拷位锟斤拷
        local scoreColumn = self.displayingVec:get(1);
        if scoreColumn and scoreColumn:IsBorn() then
            return ;
        end
        --锟斤拷示锟斤拷锟揭伙拷锟斤拷锟斤拷锟?
        local _score = self.readyToDisplay:pop();
        self:_displayScore(_score); 
    end
end

function _CScoreColumnsControl:Clear()
    local it = self.displayingVec:iter();
    local val= it();
    local color,vec;
    while(val) do
        val:Cache();
        color = val:Color();
        vec = self.cacheColorMap:value(color);
        if vec==nil then
            vec = vector:new();
            self.cacheColorMap:assign(color,vec);
        end
        vec:push_front(val);
        val = it();
    end
    self.delCount = 0;
    self.displayingVec:clear();
end

local LockLine = class("LockLine");
--锟斤拷锟斤拷锟斤拷
function LockLine:ctor(sep)
    self._curCount  = 0;
    self._totalCount= 0;
    self._sep       = sep;
    self._itemH     = 64;
    self._lineH     = 32;
    self._padding   = 10;
    self.gameObject = GameObject.New();
    self.transform  = self.gameObject.transform;
    self.gameObject.name = "LockLine";
    self.baseH      = self._itemH/2;
    self.lineTarget = self:AddItem();
    self.items      = {};
end

--锟斤拷锟矫革拷锟节碉拷
function LockLine:SetParent(_parent)
    self.transform:SetParent(_parent);
    self.transform.localScale = Vector3.one;
end

--锟斤拷锟斤拷
function LockLine:Hide()
    self.gameObject:SetActive(false);
end

--锟斤拷示
function LockLine:Display()
    self.gameObject:SetActive(true);
end

local targetName = "Target";

--锟斤拷锟揭伙拷锟?
function LockLine:AddItem()
    local item = G_GlobalGame._goFactory:createLockItem(self._sep);
    local transform = item.transform;
    transform:SetParent(self.transform);
    item.name = targetName;
    transform.localPosition = Vector3.zero;
    transform.localScale    = Vector3.one;
    transform.localRotation = Quaternion.Euler(0,0,180);
    return item;
end

local lineName = "Line";
--
function LockLine:AddLine()
    local item = G_GlobalGame._goFactory:createLockLine();
    local transform = item.transform;
    transform:SetParent(self.transform);
    item.name = lineName;
    transform.localPosition = Vector3.zero;
    transform.localScale    = Vector3.one;
    transform.localRotation = Quaternion.Euler(0,0,0);
    return item;
end

--锟斤拷锟斤拷
--[[
function LockLine:Toward(startPoint,endPoint,len)
    self.transform.position = startPoint;
    local r;
    if endPoint.x==startPoint.x then
        r=0;
    else
        r=Mathf.Rad2Deg*math.atan((endPoint.y-startPoint.y)/(endPoint.x-startPoint.x));
    end
    if (endPoint.x-startPoint.x)<=0 then r=90+r else r=r-90 end
    self.transform.rotation = Quaternion.Euler(0, 0, r);
    local needCount = math.floor(len/(self._itemH+self._padding));
    local needLen = needCount*(self._itemH+self._padding);
    local lessLen = len - needLen + self._padding;
    if lessLen> self._padding +10 then
        --锟斤拷锟斤拷一锟斤拷
        needCount = needCount + 1;
    end
    if needCount>self._totalCount then
        local count = needCount-self._totalCount;
        local item;
        local image;
        local beginY = (self.itemH + self._padding) *(self._totalCount);
        for i=1,count do
            item = self:AddItem();
            item.transform.localPosition = Vector3.New(0,beginY,0);
            beginY = beginY + (self.itemH + self._padding);
            self.items[self._totalCount+1] = item;
            self._totalCount = self._totalCount + 1;
        end
    end

    if self._curCount>needCount then
        for i=_count+1,self._curCount do
            self.items[i]:SetActive(false);
        end
    elseif self._curCount<needCount then
        for i=self._curCount+1,_count do
            self.items[i]:SetActive(true);
        end
    end
    self._curCount = needCount;
end
--]]

--锟斤拷锟斤拷
function LockLine:Toward(localPosition,r,len)
    self.transform.localPosition = localPosition;
    self.transform.rotation = Quaternion.Euler(0, 0, r);
    len = len - self.baseH - self._padding;
    local needCount = math.floor(len/(self._lineH+self._padding));
    local needLen = needCount*(self._lineH+self._padding);
    local lessLen = len - needLen + self._padding;
    if lessLen> 0 then
        --锟斤拷锟斤拷2锟斤拷
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
            item.transform.localPosition = Vector3.New(0,beginY,0);
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

local colorIdCreator = ID_Creator(1);

local _CPlayerControl = class("_CPlayerControl");


function _CPlayerControl:ctor(_moveToward,_allPlayerControl,_bulletControl)
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

    --锟斤拷色值
    self._colorIndex = colorIdCreator();

    --摩锟斤拷锟街匡拷锟斤拷
    self._wheelTime    = 0;
    self._wheelPanel   = nil;
    self._wheelNumber  = nil;
    self._wheelAnima   = nil;
    self._wheelRotation= 0;
    self._wheelToward  = 1;

    --锟斤拷叶压锟斤拷锟?
    self._scoreColumnControl = _CScoreColumnsControl.New(G_GlobalGame.GameConfig.SceneConfig.goldColumn,G_GlobalGame.GameConfig.SceneConfig.goldColumnTime,_moveToward);

end

--锟斤拷始锟斤拷
function _CPlayerControl:Init(transform,lockLayer)
    self.parentTransform = transform;
    self.lockLayer                  = lockLayer;
    self.lockStart                  = lockLayer:Find("Start");
    self.lockEnd                    = lockLayer:Find("End");
    self:_loadPaotai();

    --锟斤拷取锟截硷拷
    self:_getCtrls();
end

function _CPlayerControl:_loadPaotai()
    local player        = self:CreatePaotai();
    self.transform      = player.transform;
    local localScale    = self.transform.localScale;
    local localPosition = self.transform.localPosition;
    local localRotation = self.transform.localRotation;
    self.transform:SetParent(self.parentTransform);
    self.transform.localScale       = localScale;
    self.transform.localPosition    = localPosition;
    self.transform.localRotation    = localRotation;
end

--锟矫碉拷锟斤拷应
function _CPlayerControl:_getCtrls()
    --锟叫伙拷锟斤拷台锟斤拷锟?
    --[[
    self.bgTans         = self.transform:Find("Bg");
    local eventTrigger  = Util.AddComponent("EventTriggerListener",self.bgTans.gameObject);
    eventTrigger.onClick= handler(self,self._onClickPaotai);
    --]]

    self.paos           = self.transform:Find("Paos");

    --锟斤拷锟斤拷
    self.addPao         = self.transform:Find("AddPao");
    local eventTrigger
    if self.addPao then
        eventTrigger  = Util.AddComponent("EventTriggerListener",self.addPao.gameObject);
        eventTrigger.onClick= handler(self,self._onAddPaotai);
    end


    --锟斤拷锟斤拷
    self.reducePao         = self.transform:Find("ReducePao");
    if self.reducePao then
        eventTrigger  = Util.AddComponent("EventTriggerListener",self.reducePao.gameObject);
        eventTrigger.onClick= handler(self,self._onReducePaotai);
    end
    
    --锟接碉拷锟斤拷锟斤拷
    self.multiplePanel  = self.transform:Find("BulletInfo");
    local multipleNumbers = self.multiplePanel:Find("Numbers");
    -- local numberImage   = multipleNumbers:GetComponent("ImageAnima");
    local numberImage = HallScenPanel.GetImageAnima(multipleNumbers);

    self.multipleSprite = {};
    local count=numberImage.lSprites.Count;
    for i=0,count-1 do
        self.multipleSprite[tostring(i)] =numberImage.lSprites[i];
    end

    local function createMultipleNumber(chr)
        return self.multipleSprite[chr];
    end

    self.multipleNumber = CAtlasNumber.New(createMultipleNumber);
    self.multipleNumber:SetParent(self.multiplePanel);
    self.multipleNumber:SetLocalPosition(multipleNumbers.localPosition);
    self.multipleNumber:SetNumber(0);
    self.multipleNumber:SetLocalScale(Vector3.New(0.8,0.8,0.8));
    self.multipleNumber:Hide();

    --锟斤拷锟?
    self.fishGoldPanel  = self.transform:Find("FishGoldBg");
    local fishGoldNumbers= self.fishGoldPanel:Find("Numbers");
    -- local numberImage   = fishGoldNumbers:GetComponent("ImageAnima");
    local numberImage = HallScenPanel.GetImageAnima(fishGoldNumbers);
    self.fishGoldSprite = {};
    local count=numberImage.lSprites.Count;
    for i=0,count-1 do
        self.fishGoldSprite[tostring(i)] =numberImage.lSprites[i];
    end
    local function createFishGoldNumber(chr)
        return self.fishGoldSprite[chr];
    end
    self.fishGoldNumber = CAtlasNumber.New(createFishGoldNumber,0,HorizontalAlignType.Right);
    self.fishGoldNumber:SetParent(self.fishGoldPanel);
    self.fishGoldNumber:SetLocalPosition(fishGoldNumbers.localPosition);
    self.fishGoldNumber:SetLocalScale(Vector3.New(1,1,1));
    self.fishGoldNumber:SetNumber(0);
    self.fishGoldNumber:Hide();

    --锟斤拷锟斤拷锟较⒛ｏ拷锟?
    self.playerInfoPanel = self.transform:Find("InfoBg");
    self.playerInfoImage = self.playerInfoPanel:GetComponent("Image");

    --锟斤拷锟斤拷锟斤拷
    --self.playerInfoImage.sprite = G_GlobalGame._goFactory:createPlayerInfoBg(self._colorIndex);

    --锟斤拷锟斤拷锟斤拷锟?
    self.playerNickName  = self.transform:Find("Name"):GetComponent("Text");

	 self.playerNickName.gameObject:AddComponent(typeof(CreateFont))
	
    self.playerNickName.gameObject:SetActive(false);

    --锟斤拷医锟斤拷
    local goldNumbers= self.playerInfoPanel:Find("Numbers");
    -- local numberImage   = goldNumbers:GetComponent("ImageAnima");
    local numberImage = HallScenPanel.GetImageAnima(goldNumbers);

    self.goldSprite = {};
    local count=numberImage.lSprites.Count;
    for i=0,count-1 do
        self.goldSprite[tostring(i)] =numberImage.lSprites[i];
    end
    local function createGoldNumber(chr)
        return self.goldSprite[chr];
    end
    self.goldNumber = CAtlasNumber.New(createGoldNumber,0,HorizontalAlignType.Right);
    self.goldNumber:SetParent(self.playerInfoPanel);
    self.goldNumber:SetLocalPosition(goldNumbers.localPosition);
    self.goldNumber:SetNumber(0);
    self.goldNumber:Hide();

    self.goldFlag   = self.playerInfoPanel:Find("GoldFront");

    --锟斤拷媒锟揭讹拷
    self.scoreColumn = self.transform:Find("GetScores");
    self._scoreColumnControl:Init(self.scoreColumn);

    --摩锟斤拷锟斤拷
    self._wheelPanel  = self.transform:Find("Lucky");
    self._wheelObj    = self._wheelPanel:Find("Wheel");
    --锟斤拷态锟斤拷锟截讹拷锟斤拷
    self._wheelAnima  = G_GlobalGame.FunctionsLib.FUNC_AddAnimate(self._wheelObj.gameObject,G_GlobalGame.Enum_AnimateType.Wheel);
    self._wheelObj.localScale=Vector3.New(1,1,1);
    --self._wheelAnima  = self._wheelPanel:Find("Wheel"):GetComponent(typeof(ImageAnima));

    --摩锟斤拷锟斤拷锟斤拷锟斤拷
    local wheelNumbers= self._wheelPanel:Find("Numbers");
    -- local numberImage   = wheelNumbers:GetComponent("ImageAnima");
    local numberImage = HallScenPanel.GetImageAnima(wheelNumbers);
    self.wheelNumbersSprite = {};
    local count=numberImage.lSprites.Count;
    for i=0,count-1 do
        self.wheelNumbersSprite[tostring(i)] =numberImage.lSprites[i];
    end
    local function createWheelNumber(chr)
        return self.wheelNumbersSprite[chr];
    end
    self._wheelNumber = CAtlasNumber.New(createWheelNumber,-4);
    self._wheelNumber:SetParent(self._wheelPanel);
    self._wheelNumber:SetLocalScale(Vector3.New(0.5,0.5,0.5));
    self._wheelNumber:SetNumber(0);

    --锟斤拷锟斤拷锟斤拷谋锟绞?
    self._lockFishTrans     = self.transform:Find("LockView");
    self._lockFishImage     = self._lockFishTrans:GetComponent("Image");
    self._lockFishBeginPos  = self._lockFishTrans.localPosition;
    self._lockFishSpeed     = 85;
    self._lockFishSpeedIndex = 1;
    self._lockFishEveryMoveTime = 0.5;
    self._lockFishMoveTime = 0;
    self._lockFishSpeedVec = {
                            Vector3.New(-self._lockFishSpeed,0,0),
                            Vector3.New(0,self._lockFishSpeed*0.9,0),
                            Vector3.New(self._lockFishSpeed,0,0),
                            Vector3.New(0,-self._lockFishSpeed*0.9,0),
                            };

    --锟斤拷锟斤拷锟节憋拷识
    self._powerFlag   = self.transform:Find("Power");
    self._isPower     = false;
    self._powerBeginPos = self._powerFlag.localPosition;
    self._powerSpeed  = 85;
    self._powerSpeedIndex = 1;
    self._powerEveryMoveTime = 0.5;
    self._powerMoveTime = 0;
    self._powerSpeedVec = {
                            Vector3.New(self._powerSpeed,0,0),
                            Vector3.New(0,self._powerSpeed*0.9,0),
                            Vector3.New(-self._powerSpeed,0,0),
                            Vector3.New(0,-self._powerSpeed*0.9,0),
                            };
    self._getPowerData = {
        _getPower = false,
        _powerScale = Vector3.zero,  
        _powerScaleSpeed = 5,
        _getPowerStep  = 0,
        _totalMoveTime = 0.5,
        _runTime       = 0,
        _waitTime      = 1,
    };
    self._getPowerData._powerScaleSpeed  = 1/self._getPowerData._totalMoveTime; 

    --锟斤拷锟斤拷锟斤拷示 锟斤拷选锟斤拷锟斤拷
    self.displayChooseData = {
        isFirstChoose = true,
        time = 0,
        aphla = 1,
        aphlaSpeed = 0.03,
        lowAphla = 0.5,
        maxAphla = 1,  
        chooseFishTrans = nil,
        chooseFishTip = nil,
        chooseFishGO  = nil,
        init = function (self,playerControl)
            self.chooseFishTrans = playerControl.transform:Find("ChooseFish");
            self.chooseFishTip = self.chooseFishTrans:GetComponent("Image");
            self.chooseFishGO  = self.chooseFishTrans.gameObject;
        end,
    };
    if self._isOwner then
        --锟斤拷始锟斤拷
        self.displayChooseData:init(self);
    end
end


function _CPlayerControl:_controlChooseFish(_dt)
    local displayChooseData = self.displayChooseData;
    if displayChooseData.time>0 then
        displayChooseData.time = displayChooseData.time - _dt;
        displayChooseData.aphla = displayChooseData.aphla + displayChooseData.aphlaSpeed;
        if displayChooseData.aphla<= displayChooseData.lowAphla or displayChooseData.aphla>= displayChooseData.maxAphla then
            displayChooseData.aphlaSpeed =  0 - displayChooseData.aphlaSpeed;
        end
        if displayChooseData.chooseFishTip then
            if displayChooseData.time<=0 then
                displayChooseData.chooseFishGO:SetActive(false);
            else
                displayChooseData.chooseFishTip.color = Color.New(1,1,1,displayChooseData.aphla);
            end
        end
    end
end

--锟斤拷锟斤拷锟斤拷锟斤拷
function _CPlayerControl:_onOpenLock()
    if self.displayChooseData.isFirstChoose then
        self.displayChooseData.isFirstChoose = false;
        self.displayChooseData.time = 4;
        self.displayChooseData.aphla = 1;
        self.displayChooseData.aphlaSpeed = -0.03;
        self.displayChooseData.chooseFishGO:SetActive(true);
    end
end

--锟截憋拷锟斤拷锟斤拷
function _CPlayerControl:_onCloseLock()

end

function  _CPlayerControl:_getSepNumber(chr)
    return self.wheelNumbersSprite[chr];
end

function _CPlayerControl:setPaotaiType(_paotaiType)
    local preStyle = self._paoStyle;
    self._paotaiType= _paotaiType;
    self._paoStyle  = G_GlobalGame.FunctionsLib.FUNC_GetPaotaiStyleType(_paotaiType,self._isOwner);
    self._bulletType= G_GlobalGame.FunctionsLib.FUNC_GetBulletTypeByPaotaiType(_paotaiType);
    self._bulletKind= G_GlobalGame.FunctionsLib.FUNC_GetBulletKind(self._bulletType);
    self._multiple  = G_GlobalGame.FunctionsLib.FUNC_GetBulletMultiple(self._bulletType);
    if self._multiple==nil then
        error("PaotaiType:" .. self._paotaiType);
        error("_bulletType:" .. self._bulletType);
    end
    self._multiple = self._multiple or 0;
    self.multipleNumber:SetNumber(self._multiple);
    if preStyle ~= self._paoStyle then
        self:_renewStyle();
    end
end

--锟斤拷锟斤拷锟斤拷台
function _CPlayerControl:_renewStyle()
    --删锟斤拷之前锟斤拷锟斤拷台
    if self.paotai then
        destroy(self.paotai);
        self.paotai = nil;
    end
    local pao
    if self._isEnergy then
        pao = G_GlobalGame._goFactory:createPaotai(self._paotaiType,self._isOwner);
    else
        pao = G_GlobalGame._goFactory:createPaotai(self._paotaiType,self._isOwner);
    end
    self.paotai  = pao;
    local Ptransform    = pao.transform;
    local localScale    = Ptransform.localScale;
    local localPosition = Ptransform.localPosition;
    local localRotation = Ptransform.localRotation;
    Ptransform:SetParent(self.paos);
    Ptransform.localScale       = localScale;
    Ptransform.localPosition    = localPosition;
    Ptransform.localRotation    = localRotation;

    self.shotTrans = self.paotai.transform:Find("Shot");
    self.shotAnima = self.paotai.transform:Find("Body"):GetComponent("ImageAnima");
    self.fireAnima = self.paotai.transform:Find("Fire"):GetComponent("ImageAnima");
end

--锟狡筹拷锟斤拷台
function _CPlayerControl:_removePaotai()
    self._paoStyle  = nil;
    if self.paotai then
        destroy(self.paotai);
        self.paotai = nil;
    end
    --锟斤拷锟斤拷锟斤拷锟斤拷锟节憋拷识
    self:HidePower();
end

--锟斤拷锟斤拷锟斤拷台
function _CPlayerControl:CreatePaotai()
    return nil;
end

--锟斤拷锟斤拷锟斤拷一锟斤拷目锟斤拷
function _CPlayerControl:CalculateNext()

end

--锟斤拷锟斤拷锟角讹拷
function _CPlayerControl:CorrectAngle()
    local r = self:GetPaoAngle(); 
    if r>85 or r<-85 then
        self:SetPaoAngle(0);
        self.lastShotAngle = 0;
    end
end

--锟斤拷业锟轿伙拷锟?
function _CPlayerControl:FlyGoldPosition()
    return self.paos.position;
end

function _CPlayerControl:Lock()
    self._isLock = true;
end

function _CPlayerControl:Unlock()
    self._isLock = false;
end

--某锟斤拷锟竭讹拷锟角凤拷锟杰匡拷锟斤拷
function _CPlayerControl:IsCanShotY(_y)
    --return self.paos.position.y<_y-15;
    return self.paos.position.y<_y;
end

--
function _CPlayerControl:Update(_dt)
    if self._fireInterval >0 then
        self._fireInterval = self._fireInterval - _dt;
    end
    self._scoreColumnControl:Update(_dt);
    self:_controlWheel(_dt);
    --锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷志
    self:_controlPowerFlag(_dt);
    --锟斤拷锟斤拷锟斤拷锟斤拷位锟斤拷
    self:_controlLockFlag(_dt);
    --锟斤拷锟斤拷锟斤拷选锟斤拷锟斤拷
    self:_controlChooseFish(_dt);

    --锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷嵌锟?
    self:TowardTarget(nil);
end

function _CPlayerControl:IsLockFish()
    return self._lockFish ~= nil;
end

--锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷识
function _CPlayerControl:_controlPowerFlag(_dt)
    if self._getPowerData._getPower then
        local getPowerData = self._getPowerData;
        if getPowerData._getPowerStep == 0 then
            --锟脚达拷
            if getPowerData._powerScale.x<1 then
                getPowerData._powerScale.x = getPowerData._powerScale.x + getPowerData._powerScaleSpeed * _dt;
            end
            if getPowerData._powerScale.x>1 then
                getPowerData._powerScale.x = 1;
            end
            getPowerData._powerScale.y = getPowerData._powerScale.x;
            getPowerData._powerScale.z = getPowerData._powerScale.x;
            self._powerFlag.localScale = getPowerData._powerScale;

            --锟狡讹拷
            getPowerData._runTime = getPowerData._runTime + _dt;
            if getPowerData._runTime >= getPowerData._totalMoveTime then
                getPowerData._runTime = 0;
                self._powerFlag.localPosition = self._powerBeginPos;
                getPowerData._getPowerStep = 1;
            else
                self._powerFlag.localPosition = getPowerData._moveSpeed * getPowerData._runTime + getPowerData._moveBeginPos;
            end
        elseif getPowerData._getPowerStep == 1 then
            --锟饺达拷0.5锟斤拷
            getPowerData._runTime = getPowerData._runTime + _dt;
            if getPowerData._runTime>= getPowerData._waitTime then
                self._getPowerData._getPower = false;
                --锟斤拷时锟斤拷锟斤拷谢锟轿拷锟斤拷锟斤拷锟?
                self:ChangeToEnergy();
            end
        end
    end
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
end

function _CPlayerControl:SetIsHaveLockFish(isHaveLock)
    self.isHaveLock = isHaveLock;
end

--锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷识
function _CPlayerControl:_controlLockFlag(_dt)
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
end

--锟斤拷转锟斤拷
function _CPlayerControl:Wheel(_fishGold)
    _fishGold = _fishGold or 0;
    self._wheelPanel.gameObject:SetActive(true);
    self._wheelAnima:StopAndRevert();
    self._wheelAnima:PlayAlways();
    self._wheelTime = G_GlobalGame.GameConfig.SceneConfig.wheelDisplayTime;
    self._wheelNumber:SetNumber(_fishGold);
    self._wheelRotation  = 0;
    self._wheelToward = 1;
    --锟斤拷锟斤拷锟斤拷锟斤拷
    G_GlobalGame:PlayEffect(G_GlobalGame.SoundDefine.Bingo);
end

--摩锟斤拷锟街匡拷锟斤拷
function _CPlayerControl:_controlWheel(_dt)
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
        --锟斤拷锟斤拷锟斤拷锟捷的角讹拷
        self._wheelNumber:SetLocalRotation(Quaternion.Euler(0,0,self._wheelRotation));
        if self._wheelTime<=0 then
            self._wheelPanel.gameObject:SetActive(false);
        end
    end
end

--锟斤拷锟斤拷锟教?
function _CPlayerControl:_onClickPaotai()
    if self._isEnabled then
        self:SwitchPaotai();
    end
end

--锟斤拷锟斤拷
function _CPlayerControl:_onAddPaotai()
    if self._isEnabled then
        self:SwitchPaotai();
    end
end

--锟斤拷锟斤拷
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
    --锟角凤拷锟角匡拷位锟斤拷
    if self:IsEmpty() then
        return ;
    end
    isReduce = isReduce or false;

    local _paotaiType;
    if isReduce then
        _paotaiType = G_GlobalGame.FunctionsLib.FUNC_GetPrePaotai(self._paotaiType);
    else
        _paotaiType = G_GlobalGame.FunctionsLib.FUNC_GetNextPaotai(self._paotaiType);
    end

    if _paotaiType == G_GlobalGame.Enum_PaotaiType.InvalidType then
    else
        --锟斤拷锟斤拷锟斤拷台
        self:setPaotaiType(_paotaiType);

        --锟叫伙拷锟斤拷锟斤拷锟斤拷
        G_GlobalGame:PlayEffect(G_GlobalGame.SoundDefine.CantSwitch); 
    end
end

--锟矫碉拷锟接碉拷锟斤拷锟斤拷
function _CPlayerControl:GetMultiple()
    return self._multiple;
end

function _CPlayerControl:_reloadPaotai()
    --锟斤拷一锟斤拷
    if self.transform then
        destroy(self.transform.gameObject);
        self.transform=nil;
    end
    self:_loadPaotai();
    --锟斤拷取锟截硷拷
    self:_getCtrls();
end

--锟斤拷医锟斤拷锟?
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
        --锟斤拷锟铰硷拷锟截碉拷锟铰碉拷锟节硷拷
        self:_reloadPaotai();
    end
    self.multipleNumber:Display();
    self.fishGoldNumber:Display();
    self.fishGoldNumber:SetNumber(0);
    self.goldNumber:Display();
    --self.goldFlag.gameObject:SetActive(true);
    self.playerNickName.gameObject:SetActive(true);
    self._bulletVec             = vector:new();
    self._lockFish              = nil;
    self._paoStyle              = nil;
    --锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷
    if not self._lockLine then
        self._lockLine = LockLine.New(self._chairId);
        self._lockLine:SetParent(self.lockLayer);
        self._lockLine:Hide();
    end
    self:setPaotaiType(G_GlobalGame.Enum_PaotaiType.Paotai_1);
    --self:ChangeToEnergy();

    --锟斤拷始锟斤拷台锟角讹拷
    self.lastShotAngle = 0;
end

--锟斤拷锟斤拷锟?
function _CPlayerControl:SetFishGold(_fishGold)
    self.fishGoldNumber:SetNumber(_fishGold);
    self._fishGold = _fishGold;
end

--锟斤拷锟矫斤拷锟斤拷锟?
function _CPlayerControl:SetGold(_gold)
    self.goldNumber:SetNumber(_gold);
end

--锟斤拷锟斤拷锟角筹拷
function _CPlayerControl:SetName(_name)
    self.playerNickName.text = _name;
end

--锟角凤拷锟斤拷锟姐够锟斤拷钱锟斤拷锟斤拷
function _CPlayerControl:IsEnoughFire()
    return self._fishGold >= self._multiple;
end

--锟斤拷锟斤拷锟斤拷锟斤拷锟?
function _CPlayerControl:AddFishGold(_fishGold)
    self._fishGold = self._fishGold + _fishGold;
    if self._fishGold<0 then
        self._fishGold=0;
    end
    self.fishGoldNumber:SetNumber(self._fishGold);
end

--锟斤拷锟斤拷肟?
function _CPlayerControl:OnUserLeave(_user)
    if self._uid ==-1 then
        return ;
    end
    self._uid = -1;
    self.fishGoldNumber:Hide();
    if self.multipleNumber then
    	self.multipleNumber:Hide();
    end
    self.goldNumber:Hide();
    --self.goldFlag.gameObject:SetActive(false);
    self.playerNickName.gameObject:SetActive(false);
    self._wheelTime = 0;
    self._wheelPanel.gameObject:SetActive(false);
    --取锟斤拷锟斤拷锟斤拷
    self:SetLockFish(nil);

    --锟斤拷为锟斤拷锟斤拷锟斤拷台
    --self:ChangeToNormal();

    --删锟斤拷锟斤拷台
    self:_removePaotai();

    if self._isOwner then
        --锟斤拷锟铰硷拷锟斤拷锟斤拷台锟斤拷锟斤拷
        self._isOwner = false;
        self._isEnergy = false;
        self:_reloadPaotai();
    end

    --锟斤拷锟斤拷拥锟斤拷锟斤拷锟?
    if self._bulletVec~=nil then
        self._bulletVec:clear();
    end
    --锟斤拷锟斤拷锟?
    self._fishGold = 0;
    --锟斤拷锟斤拷锟斤拷注
    self._scoreColumnControl:Clear();
end

--锟斤拷锟斤拷power锟斤拷识
function _CPlayerControl:HidePower()
    self._getPowerData._getPower = false;
    self._isPower = false;
    self._powerFlag.gameObject:SetActive(false);
end

--锟角凤拷锟角匡拷位锟斤拷
function _CPlayerControl:IsEmpty()
    return self._uid == -1;
end

--锟斤拷锟斤拷目锟斤拷
function _CPlayerControl:TowardTarget(_targetPos)
    if self:IsEmpty() then
        return ;
    end
    local r = self:ChangeToward(_targetPos);
    if r==3600 then
        --self:_stopAnima();
        return ;
    elseif _isNeedFire then
        if r==nil then

        else
            self.lastShotAngle = r;
        end
    else
    end
end

function _CPlayerControl:ChangeToward(_targetPos) 
    local p = self.paos.position;
    local t = _targetPos;
    if self._lockFish then
        if self._lockFish:IsDie() or not self._lockFish:IsInScreen() then
            self._allPlayerControl:OnSwitchNextLockFish(self._chairId,self._lockFish);
            return 0;
        else
            t = self._lockFish:Position();
        end
        
    end 
    if t== nil then
        return;
    end
    local r;
    if t.x==p.x then
        r=0;
    else
        r=Mathf.Rad2Deg*math.atan((t.y-p.y)/(t.x-p.x));
    end
    if (t.x-p.x)<=0 then r=90+r else r=r-90 end
    local canAngle = 90;
    if not self._lockFish then
        if r>=canAngle or r<=-canAngle then
            return 3600;
        end 
    end 
    self:SetPaoAngle(r);

    if self._lockFish then
        self.lockStart.position = self.paos.position;
        self.lockEnd.position   = t;
        local len = Vector3.Distance(self.lockStart.localPosition,self.lockEnd.localPosition);
        self._lockLine:Toward(self.lockEnd.localPosition,r+180,len);
    end
    if r>=canAngle or r<=-canAngle then
       return 3600;
    end
    return r;      
end

function _CPlayerControl:_fireAnima(_time)
--    self.shotAnima:Play();
--    if self.fireAnima.isPlaying then

--    else
--        self.fireAnima.fDelta = 0;
--        self.fireAnima:Play();
--    end
    _time = _time or 0;
    if _time ==0  then
        self.shotAnima:PlayAlways();
        self.fireAnima:PlayAlways();
    else
        self:_stopAnima();
        self.shotAnima.fDelta = 0;
        self.shotAnima:Play(_time);
        self.fireAnima.fDelta = 0;
        self.fireAnima:Play(_time);
    end

end

function _CPlayerControl:_stopAnima()
    if not IsNil(self.shotAnima) then
        self.shotAnima:StopAndRevert();
    end
    if not IsNil(self.fireAnima) then
        self.fireAnima:StopAndRevert();
    end
end

--停止锟斤拷锟斤拷
function _CPlayerControl:StopFire()
    self:_stopAnima();
end


--锟斤拷铱锟斤拷锟?
function _CPlayerControl:UserFire(_targetPos,_isNeedFire)

    if self:IsEmpty() then
        return ;
    end

    if self._bulletVec:size()>30 then
        --同锟斤拷锟斤拷每锟斤拷锟斤拷锟斤拷业慕锟斤拷锟斤拷锟斤拷,锟斤拷锟斤拷锟斤拷锟狡就诧拷锟斤拷锟接碉拷
        return ;
    end

    --锟侥憋拷嵌锟?
    local r = self:ChangeToward(_targetPos);
    if r==3600 then
        self:_stopAnima();
        return ;
    elseif _isNeedFire then
        if r==nil then
            r = self.lastShotAngle;
        else
            self.lastShotAngle = r;
        end
    else
        if r==nil then
            self:_stopAnima();
            return ;
        end
    end
    if self._fireInterval>0 then --锟斤拷锟斤拷时锟斤拷锟斤拷太锟斤拷
        return;
    end

    self:_fireAnima();

    --锟角凤拷锟斤拷锟斤拷锟斤拷锟斤拷
    if self._isEnergy then
        self._fireInterval = G_GlobalGame.GameConfig.SceneConfig.iFireEnergyInterval + self._fireInterval;
    else
        self._fireInterval = G_GlobalGame.GameConfig.SceneConfig.iFireInterval + self._fireInterval;
    end


    local localr =self:GetPaoLocalAnle();

    if self._lockFish then
        G_GlobalGame._clientSession:SendPao(self._bulletKind,localr,self._multiple,self._lockFish:FishID());
    else
        G_GlobalGame._clientSession:SendPao(self._bulletKind,localr,self._multiple,G_GlobalGame.ConstDefine.C_S_INVALID_FISH_ID);
    end

    local bullet = self._bulletControl:CreateBullet(self._bulletType,self._isOwner,self.shotTrans.position,localr,self._chairId,self._lockFish,G_GlobalGame.bulletId,false,self._bulletKind);
    --锟斤拷没锟叫凤拷锟斤拷锟接碉拷ID
    self._bulletVec:push_back(bullet);
--    if self._isEnergy then
--        G_GlobalGame:PlayEffect(G_GlobalGame.SoundDefine.Ion_Fire);
--    end
    G_GlobalGame:PlayEffect(G_GlobalGame.SoundDefine.Fire);
end

--锟斤拷锟矫角讹拷
function _CPlayerControl:SetPaoLocalAngle(_angle)
    self.paos.localEulerAngles = Vector3.New(0,0,_angle);
end

--锟矫碉拷锟角讹拷
function _CPlayerControl:GetPaoLocalAnle()
    return self.paos.localEulerAngles.z;
end

--锟斤拷锟矫角讹拷
function _CPlayerControl:SetPaoAngle(_angle)
    self.paos.eulerAngles = Vector3.New(0,0,_angle);
    --[[
    local eulerAngles = self.paos.eulerAngles;
    self.paos.eulerAngles = Vector3.New(0,0,_angle);
    local localEulerAngles = self.paos.localEulerAngles;
    if localEulerAngles.z>85 or localEulerAngles.z<-85 then
        self.paos.eulerAngles = eulerAngles;
    end
    --]]
end

--锟矫碉拷锟角讹拷
function _CPlayerControl:GetPaoAngle()
    return self.paos.eulerAngles.z;
end

--锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷
function _CPlayerControl:GetEnergy(_pos)
    --锟斤拷示锟斤拷锟斤拷锟节伙拷取锟斤拷锟斤拷
    self._powerFlag.position = _pos;
    self._getPowerData._getPower = true;
    self._getPowerData._powerScale = Vector3.zero;
    self._getPowerData._powerScaleSpeed = 5;
    self._getPowerData._getPowerStep  = 0;
    self._powerFlag.localScale = self._getPowerData._powerScale;
    --锟斤拷锟斤拷锟斤拷锟狡讹拷
    self._powerFlag.gameObject:SetActive(true);

    self._getPowerData._moveBeginPos = self._powerFlag.localPosition;
    local dis = self._powerBeginPos - self._powerFlag.localPosition;
    self._getPowerData._moveSpeed = dis / self._getPowerData._totalMoveTime;
    self._getPowerData._runTime = 0;
end

--锟斤拷锟斤拷锟斤拷锟斤拷锟?
function _CPlayerControl:ChangeToEnergy()
    self._isEnergy = true;
    local paotaiType = G_GlobalGame.FunctionsLib.FUNC_GetUpPaotai(self._paotaiType);
    if paotaiType == G_GlobalGame.Enum_PaotaiType.InvalidType then
    else
        self:setPaotaiType(paotaiType);
        G_GlobalGame:PlayEffect(G_GlobalGame.SoundDefine.Ion_Get);
        self._isPower = true;
        self._powerSpeedIndex = 1;
        self._powerFlag.localPosition = self._powerBeginPos;
    end
end

--锟斤拷锟斤拷锟斤拷锟?
function _CPlayerControl:ChangeToNormal()
    self._isEnergy = false;
    local paotaiType = G_GlobalGame.FunctionsLib.FUNC_GetDownPaotai(self._paotaiType);
    if paotaiType == G_GlobalGame.Enum_PaotaiType.InvalidType then
    else
        G_GlobalGame:PlayEffect(G_GlobalGame.SoundDefine.Ion_Get);
        self:setPaotaiType(paotaiType);
        self._powerFlag.gameObject:SetActive(false);
        self._isPower = false; 
    end
end


function _CPlayerControl:OnUserFire(_fire,_myChairId)
    --锟斤拷锟斤拷锟斤拷通知锟斤拷铱锟斤拷锟?
    if self._isOwner then

        --锟斤拷锟斤拷约锟?
        local bullet = self._bulletVec:pop_front();
        if bullet then 
            --同锟斤拷锟接碉拷ID
            bullet:SetBulletId(_fire.bulletId);
        end        
    else
        
        --锟斤拷锟斤拷一锟斤拷锟斤拷锟酵的撅拷锟叫伙拷锟斤拷
        local bulletType = G_GlobalGame.FunctionsLib.FUNC_GetBulletTypeByMultiple(_fire.bulletMultiple,self._isEnergy);
        local paotaiType = G_GlobalGame.FunctionsLib.FUNC_GetPaotaiTypeByBulletType(bulletType);
        --锟斤拷锟斤拷锟斤拷台
        self:setPaotaiType(paotaiType);
        if _fire.lockFishId~=G_GlobalGame.ConstDefine.C_S_INVALID_FISH_ID then
            --锟斤拷锟斤拷锟斤拷锟揭诧拷锟斤拷锟斤拷锟斤拷锟?
            local fish = G_GlobalGame:GetKeyValue(G_GlobalGame.Enum_KeyValue.GetFishById,_fire.lockFishId);
            if fish~=nil then
                if fish:IsDie() then
	    	    --取锟斤拷锟斤拷锟斤拷目锟斤拷
                    self:SetLockFish(nil);
                    self:SetPaoLocalAngle(_fire.angle);
                else               
                    self:SetLockFish(fish);
                end
            end
        else
            --取锟斤拷锟斤拷锟斤拷目锟斤拷
            self:SetLockFish(nil);
            if _fire.androidChairId>=G_GlobalGame.ConstDefine.C_S_PLAYER_COUNT or _fire.androidChairId<0  then
                self:SetPaoLocalAngle(_fire.angle);
            else
                --锟斤拷锟斤拷锟斤拷
                local angle =math.deg(_fire.angle);
                self:SetPaoLocalAngle(angle);
            end
        end
        local isMyAndroid;
        if _fire.androidChairId == _myChairId then
            isMyAndroid = true;
        else
            isMyAndroid = false;
        end
        --锟斤拷锟斤拷锟接碉拷
        self._bulletControl:CreateBullet(self._bulletType,self._isOwner,self.shotTrans.position,self:GetPaoAngle(),self._chairId,self._lockFish,_fire.bulletId
        ,isMyAndroid,_fire.bulletKind);
--        if self._isEnergy then
--            G_GlobalGame:PlayEffect(G_GlobalGame.SoundDefine.Ion_Fire); 
--        end
        G_GlobalGame:PlayEffect(G_GlobalGame.SoundDefine.Fire);
        --锟斤拷锟金动伙拷
        self:_fireAnima(1);
    end
    self:SetFishGold(_fire.fishGold);
end

--锟矫碉拷锟斤拷锟斤拷锟斤拷锟斤拷
function _CPlayerControl:GetLockFish()
    return self._lockFish;
end

--锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷
function _CPlayerControl:SetLockFish(_lockFish)
    if self._lockFish == _lockFish then
        return ;
    end
    if self._lockFish then
        self._lockFish:RemoveEvent(self);
    end
    self._lockFish = _lockFish;
    if _lockFish then
        self._lockFish:RegEvent(self,self.OnEventFish);
        self._lockLine:Display();
        --锟叫伙拷锟角讹拷
        self:ChangeToward(_lockFish:Position());
        self._lockFishTrans.gameObject:SetActive(true);
		logError("*********************************************************************")
		logError(_lockFish:FishType())
        self._lockFishImage.sprite = G_GlobalGame._goFactory:getLockFishFlag(_lockFish:FishType());
    else
        self._lockLine:Hide();
        self._lockFishTrans.gameObject:SetActive(false);
    end
end

function _CPlayerControl:OnEventFish(_eventId,_fish)
    if (_eventId==G_GlobalGame.Enum_EventID.FishDead or _eventId == G_GlobalGame.Enum_EventID.FishLeaveScreen) then
    else
        return;
    end
    if _fish:FishID() == self._lockFish:FishID() then
        --self._lockFish:RemoveEvent(self);
        --锟叫伙拷目锟斤拷
        self._allPlayerControl:OnSwitchNextLockFish(self._chairId,self._lockFish);
    end
end

--赢锟矫斤拷锟斤拷锟?
function _CPlayerControl:WinFishGold(_fishGold)
    self._scoreColumnControl:DisplayScore(_fishGold);
end

local _CPlayerLeftControl= class("_CPlayerLeftControl",_CPlayerControl);

function _CPlayerLeftControl:ctor(...)
    _CPlayerLeftControl.super.ctor(self,1,...);
end

--锟斤拷锟斤拷锟斤拷台
function _CPlayerLeftControl:CreatePaotai()
    return G_GlobalGame._goFactory:createLeftPlayer(self._isOwner);
end

--锟斤拷医锟斤拷锟?
function _CPlayerLeftControl:OnUserEnter(_user,_isOwner)
    _CPlayerLeftControl.super.OnUserEnter(self,_user,_isOwner);
end

--锟斤拷锟斤拷肟?
function _CPlayerLeftControl:OnUserLeave(_user)
    _CPlayerLeftControl.super.OnUserLeave(self,_user);
end

--锟斤拷铱锟斤拷锟?
function _CPlayerLeftControl:OnUserFire(_fire,_myChairId)
    _CPlayerLeftControl.super.OnUserFire(self,_fire,_myChairId);
end


local _CPlayerRightControl = class("_CPlayerRightControl",_CPlayerControl);

function _CPlayerRightControl:ctor(...)
    _CPlayerRightControl.super.ctor(self,1,...);
end

--锟斤拷锟斤拷锟斤拷台
function _CPlayerRightControl:CreatePaotai()
    return G_GlobalGame._goFactory:createRightPlayer(self._isOwner);
end


--锟斤拷医锟斤拷锟?
function _CPlayerRightControl:OnUserEnter(_user,_isOwner)
    _CPlayerRightControl.super.OnUserEnter(self,_user,_isOwner);
end

--锟斤拷锟斤拷肟?
function _CPlayerRightControl:OnUserLeave(_user)
    _CPlayerRightControl.super.OnUserLeave(self,_user);
end

--锟斤拷铱锟斤拷锟?
function _CPlayerRightControl:OnUserFire(_fire,_myChairId)
    _CPlayerRightControl.super.OnUserFire(self,_fire,_myChairId);
end

local BUTTON_TYPE = {
    Btn_Null        = 0,
    Btn_UpScore     = 1,
};

local LongPressItem = class("LongPressItem");

--
function LongPressItem:ctor()
    self.isDown      = false;
    self.pressTime   = 0;
    self.btnType     = BUTTON_TYPE.Btn_Null;
    self.isLongPress = false;
    self.longHandler = nil;
    self.shortHandler= nil;
    self.count       = 0; --执锟叫达拷锟斤拷
    self.longKeyTime = 0;
    self.intervalTime= 0;
end

function LongPressItem:Init(_type,longPressTime,intervalTime,longPressHandler,shortPressHandler)
    self.longPressTime  = longPressTime or 0; --锟斤拷锟斤拷锟斤拷时锟斤拷
    self.intervalTime   = intervalTime or 0; --锟斤拷锟斤拷时锟斤拷
    self.btnType        = _type;
    self.longHandler    = longPressHandler;
    self.shortHandler   = shortPressHandler;
    self.isDown         = true;
    self.pressTime      = 0;
    self.isLongPress    = false;
end

function LongPressItem:Update(_dt)
    --锟斤拷锟角筹拷锟斤拷状态
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

local LongPressControl = class("LongPressControl");

function LongPressControl:ctor()
    self._itemMap = map:new();
    self._delList = vector:new();
end

--锟斤拷始
-- @longPressTime 锟斤拷锟斤拷时锟斤拷
-- @intervalTime 锟斤拷锟斤拷频锟斤拷
-- @longPressHandler 锟斤拷锟斤拷锟铰硷拷
-- @shortPressHandler 锟教帮拷锟铰硷拷 
function LongPressControl:Start(_type,longPressTime,intervalTime,longPressHandler,shortPressHandler)
    local item = LongPressItem.New();
    item:Init(_type,longPressTime,intervalTime,longPressHandler,shortPressHandler);
    self._itemMap:insert(_type,item);
end

--停止
function LongPressControl:Stop(_type)
    local item = self._itemMap:value(_type);
    if item then
        item:Stop();
    end 
    self._delList:push_back(_type);
end

--执锟斤拷 
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

local _CShowGoldNumber = class("_CShowGoldNumber",CEventObject);

function _CShowGoldNumber:ctor(_creator)
    _CShowGoldNumber.super.ctor(self);
    self.gameObject = GameObject.New();
    self.transform  = self.gameObject.transform;
    self.gameObject.name= "GoldNumber";
--    self.transform:SetParent(_parent);
--    self.transform.localPosition = Vector3.Zero();
--    self.transform.localScale = Vector3.One();
    self._atlasNumber = CAtlasNumber.New(_creator);
    self._atlasNumber:SetParent(self.transform);
    self._pos  = nil;
end

--锟斤拷始锟斤拷
function _CShowGoldNumber:Init(transform,_pos)
    self.transform:SetParent(transform);
    --self.transform.localPosition = Vector3.Zero();
    self.transform.localScale = Vector3.New(0.6,0.6,0.6);
    self.transform.position = _pos;
    self._pos  = _pos;
    self.scaleNumber = 0;
    self.addScale  = 1;
    self._atlasNumber:SetLocalScale(Vector3.New(0,0,0));
    self._moveY = 30;
    self._endY  = 90;
    self._moveSpeed = 300;
    --锟斤拷锟斤拷锟狡讹拷锟斤拷锟斤拷0.5锟诫，
    --锟斤拷锟斤拷锟斤拷1.5锟诫，锟杰癸拷2锟斤拷
    self.runTime    =1.5; --锟斤拷示时锟斤拷

    self._atlasNumber:SetLocalPosition(Vector3.New(0,self._moveY,0));
    self._moveDistance = self._endY*2 - self._moveY
    
    self._moveTime  =self._moveSpeed/self._moveDistance;
    self._firstDisPer = (self._endY -self._moveY)/self._moveDistance;
    self._step  = 0;
    self._shakeTime     = 0;
    self._shakeToward   = 1;
    self._shakeCount    = 0;
end

function _CShowGoldNumber:SetNumber(num)
    self._atlasNumber:SetNumber(num);
end

function _CShowGoldNumber:Update(_dt)
    if self._step == 0 then
        self._moveY = self._moveY + _dt*self._moveSpeed;
        self.scaleNumber = self.scaleNumber + _dt*self._moveTime;
        if self._moveY>self._endY then
            --self._moveY = self._endY;
            self._moveY = self._endY*2 - self._moveY;
            self._step  = 1;
        end
        if self.scaleNumber>=self._firstDisPer then
            self.scaleNumber = self._firstDisPer;
        end
        self._atlasNumber:SetLocalScale(Vector3.New(self.scaleNumber,self.scaleNumber,self.scaleNumber));
        self._atlasNumber:SetLocalPosition(Vector3.New(0,self._moveY,0));
    elseif self._step == 1 then
        self._moveY = self._moveY - _dt*self._moveSpeed;
        self.scaleNumber = self.scaleNumber + _dt*self._moveTime;
        if self._moveY<=0 then
            self._moveY = 0;
            --锟斤拷锟斤拷要锟斤拷锟斤拷
            self._step  = 3;
        end
        if self.scaleNumber>1 then
            self.scaleNumber=1;
        end
        self._atlasNumber:SetLocalScale(Vector3.New(self.scaleNumber,self.scaleNumber,self.scaleNumber));
        self._atlasNumber:SetLocalPosition(Vector3.New(0,self._moveY,0));
    elseif self._step == 2 then
        do
            --锟斤拷锟斤拷效锟斤拷
            self._shakeTime = self._shakeTime + _dt;
            if self._shakeTime>0.05 then
                self._shakeTime = self._shakeTime - 0.05;
                self._shakeToward = 0 - self._shakeToward;
                self._shakeCount = self._shakeCount + 1;
                if self._shakeCount>=4 then
                    self._step = 3;
                end
            end
            if self._shakeToward==1 then
                self._atlasNumber:SetLocalPosition(Vector3.New(0,10,0));
            else
                self._atlasNumber:SetLocalPosition(Vector3.New(0,-10,0));
            end
        end

    elseif self._step == 3 then
        self.runTime = self.runTime - _dt;
        if self.runTime<=0 then
            self._step = 4;
            self:SendEvent(G_GlobalGame.Enum_EventID.ShowGoldNumberDisappear);
        end
    end
end

local _CShowGoldNumberControl = class("_CShowGoldNumberControl",CEventObject);

function _CShowGoldNumberControl:ctor()
    _CShowGoldNumberControl.super.ctor(self);
    self._atlasNumberCache = vector:new();
    self._atlasNumberRunMap= map:new();
    self._delList          = vector:new();
    self._goldNumber       = {};
end

function _CShowGoldNumberControl:Init(transform)
    self.transform  = transform;
    self.gameObject = transform.gameObject;
    -- local numberImage   = transform:Find("Numbers"):GetComponent("ImageAnima");
    local numberImage = HallScenPanel.GetImageAnima(transform:Find("Numbers"));
    local count=numberImage.lSprites.Count;
    for i=0,count-1 do
        self._goldNumber[tostring(i)] =numberImage.lSprites[i];
    end
end

--锟斤拷锟斤拷锟斤拷示锟斤拷锟斤拷锟斤拷锟?
function _CShowGoldNumberControl:CreateNumber(_number,_position)
    local number;
    if self._atlasNumberCache:size()>0 then
        number = self._atlasNumberCache:pop();
    else
        number = _CShowGoldNumber.New(handler(self,self._createNumberSpr));
    end
    number:Init(self.transform,_position);
    self._atlasNumberRunMap:insert(number:LID(),number);
    number:RegEvent(self,self.OnShowGoldNumberEvent);
    number:SetNumber(_number);
    number:SetPosition(_position);
end

function _CShowGoldNumberControl:_createNumberSpr(_chr)
    return self._goldNumber[_chr];
end

function _CShowGoldNumberControl:Update(_dt)
    local it = self._delList:iter();
    local val= it();
    local goldNumber;
    while(val) do
        goldNumber = self._atlasNumberRunMap:erase(val);
        if goldNumber then
            goldNumber:Cache();
            self._atlasNumberCache:push_back(goldNumber);
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
    if _eventId ==G_GlobalGame.Enum_EventID.ShowGoldNumberDisappear then
        self._delList:push_back(_showGold:LID());
    end
end

--锟斤拷锟斤拷锟斤拷锟斤拷系锟斤拷锟斤拷锟斤拷锟绞?
function _CShowGoldNumberControl:Clear()
    local it = self._atlasNumberRunMap:iter();
    local val= it();
    local goldNumber;
    while(val) do
        goldNumber = self._atlasNumberRunMap:value(val);
        if goldNumber then
            goldNumber:Cache();
            self._atlasNumberCache:push_back(goldNumber);
        end
        val = it();
    end
    self._delList:clear();
    self._atlasNumberRunMap:clear();
end


local _CPlayersControl = class("_CPlayersControl");

function _CPlayersControl:ctor(_sceneControl,_bulletControl,_fishControl)
    self._canAngle          = 90; --锟斤拷台锟斤拷锟斤拷转锟侥角讹拷
    self._angleSpeed        = 0;  --锟斤拷转锟斤拷锟劫讹拷
    self._bulletDuration    = 0.3; --锟斤拷锟斤拷时锟斤拷锟斤拷
    --self._

    self._isEmpty           = true;
    self._chairIds          = {};
    self._myChairId         = G_GlobalGame.ConstDefine.C_S_INVALID_CHAIR_ID;
    self._isRotation        = false; --锟角凤拷转锟斤拷

    self.playerChairs       = {};
    self.playerControls     = {};

    self._sceneControl      = _sceneControl;
    self._bulletControl     = _bulletControl;
    self._fishControl       = _fishControl;
    self._flyGoldControl    = CFlyGoldControl.New();
    self._userIdsMap        = map:new();
    self._showGoldNumControl= _CShowGoldNumberControl.New();

    G_GlobalGame:RegEventByStringKey("UserFire",self,self.OnUserFire);
    G_GlobalGame:RegEventByStringKey("UserEnter",self,self.OnUserEnter);
    G_GlobalGame:RegEventByStringKey("UserLeave",self,self.OnUserLeave);
    G_GlobalGame:RegEventByStringKey("ExchangeFishGold",self,self.OnExchangeFishGold); 
    G_GlobalGame:RegEventByStringKey("CatchFish",self,self.OnCatchFish); 
    G_GlobalGame:RegEventByStringKey("CatchTranslateFish",self,self.OnCatchTranslateFish);
    G_GlobalGame:RegEventByStringKey("CatchCauseFish",self,self.OnCatchFish); 
    G_GlobalGame:RegEventByStringKey("CatchGroupFish",self,self.OnCatchGroupFish);
    G_GlobalGame:RegEventByStringKey("UserScore",self,self.OnUserScoreChange); 
    G_GlobalGame:RegEventByStringKey("EnergyTimeOut",self,self.OnEnergyTimeOut); 
    G_GlobalGame:RegEventByStringKey("NewHandEnd",self,self.OnNewHandEnd);
    G_GlobalGame:RegEventByStringKey("NotifySwitchPao",self,self.OnSwitchPaotai);
    G_GlobalGame:RegEventByStringKey("NotifyAddScore",self,self.OnAddScore);
    --锟斤拷锟街匡拷锟斤拷锟斤拷锟斤拷锟斤拷
    G_GlobalGame:RegEventByStringKey("Appearance",self,self.AppearanceLockFish);
    --注锟斤拷
    G_GlobalGame:SetKeyHandler(G_GlobalGame.Enum_KeyValue.GetSceneIsRotation,handler(self,self.IsRotation));
    
    --锟斤拷锟斤拷锟铰硷拷
    self._longKeyPress = LongPressControl.New();

    self._isCanCreateBullet = true;

    self._isNewHand = false;

    --锟斤拷始锟斤拷锟斤拷色锟斤拷锟斤拷锟斤拷
    colorIdCreator(0);

    --锟斤拷示位锟矫匡拷锟斤拷
    self._popTipPosData = {
        _tipPosTime = 0,
        _moveToward = -1,
        _moveY      = 0,
    };
    --没锟叫匡拷锟斤拷锟斤拷锟斤拷
    self._isContinueShot = false;

    --锟角凤拷锟斤拷要锟斤拷锟斤拷鸥谋浞斤拷锟?
    self._isNeedClickToward = true;

    --锟斤拷录锟斤拷锟轿的帮拷钮
    self._recordClickObjectMap =  map:new();
    --锟斤拷录锟斤拷锟轿的帮拷钮
    self._recordNotClickObjectMap =  map:new();

    --锟斤拷锟阶刺?
    self._lastClick = false;
    self._curClick  = false;
    self._lastClickBtn = false;
    self._lastIsClick = false;
end

--锟斤拷始锟斤拷
function _CPlayersControl:Init(transform)
    self.transform      = transform;
    self:_initFlyLayer();
    self:_initPlayers();
    self:_initUI();
    
end

--锟斤拷始锟斤拷
function _CPlayersControl:AsyncInit(transform)
    self._asyncStep = self._asyncStep or 1;
    if self._asyncStep == 1 then
        --锟斤拷锟斤拷锟斤拷戏UI
        self.transform = transform;
        self:_initFlyLayer();
        self._asyncStep = self._asyncStep + 1;
        return false;
    elseif self._asyncStep == 2 then
        self:_initPlayers();
        self._asyncStep = self._asyncStep + 1;
        return false;
    elseif self._asyncStep == 3 then
    	self:_initUI();
        self._asyncStep = self._asyncStep + 1;
        self._isInit = true;
        return true;
    end  
end

--锟斤拷始锟斤拷fly
function _CPlayersControl:_initFlyLayer()
    local obj = G_GlobalGame._goFactory:createFlyLayer();
    local transform = obj.transform;
    self._playersTransform = obj.transform;
    transform:SetParent(self.transform);
    transform.localScale = Vector3.New(1,1,1);
    transform.localPosition = Vector3.New(0,0,0);

    --锟斤拷锟斤拷锟斤拷
    self.lockLayer      = transform:Find("LockLayer");

    --锟缴斤拷锟?
    local flyGoldTransform = transform:Find("FlyGoldLayer");
    self._flyGoldControl:Init(flyGoldTransform);
 
    --锟斤拷示锟斤拷锟斤拷锟?
    self.showGoldNumLayer = transform:Find("GoldNumberLayer");
    self._showGoldNumControl:Init(self.showGoldNumLayer);
end

--锟斤拷始锟斤拷UI锟斤拷锟斤拷
function _CPlayersControl:_initUI()
    local uiPart = G_GlobalGame._goFactory:createUIPart();
    transform = uiPart.transform
    self._uiTransform = transform;

    transform:SetParent(self.transform);
    transform.localScale = Vector3.New(1,1,1);
    transform.localPosition = Vector3.New(0,0,0);

    --锟斤拷锟斤拷陌锟脚ワ拷锟?
    local moveGroup = transform:Find("ButtonPanel");
    moveGroup.localPosition=Vector3.New((Screen.width / Screen.height) * 750 *0.5-105,moveGroup.localPosition.y,moveGroup.localPosition.z)

    local buttonPanel   = moveGroup:Find("MoveAction");
    self.buttonPanel  = buttonPanel;
    -- local alignView = moveGroup.gameObject:AddComponent(AlignViewExClassType);
    -- alignView:setAlign(Enum_AlignViewEx.Align_Right);
    -- alignView.isKeepPos = false;
    --moveGroup.localPosition = Vector3(562,moveGroup.localPosition.y,0);

    moveGroup.localPosition=Vector3.New((Screen.width/Screen.height)*750/2-106,moveGroup.localPosition.y,0)
    self._moveButtonAction = {
        moveInBtn   = nil,
        moveInGO    = nil,
        moveOutBtn  = nil,
        moveOutGO   = nil,
        isMove      = false,
        curMoveToward = 0,
        buttonGroup = buttonPanel,
        moveDis     = nil,
        beginPos    = nil,
        maxX        = 105,
        minX        = 0,
        runTime     = 0,
        
        init        = function (self,mgr)
            self.moveDis = self.buttonGroup.localPosition;
            self.beginPos= self.moveDis:Clone();
            self.moveInBtn   = self.buttonGroup:Find("MoveIn");
            self.moveOutBtn  = self.buttonGroup:Find("MoveOut");
            self.curMoveToward = 350;
            self.isMove      = false;

            --锟斤拷始锟斤拷
            self.moveInGO = self.moveInBtn.gameObject;
            self.moveOutGO = self.moveOutBtn.gameObject;

            local eventTrigger = Util.AddComponent("EventTriggerListener",self.moveInGO);
            eventTrigger.onClick = handler(mgr,mgr._onMoveBtnClick);
            eventTrigger = Util.AddComponent("EventTriggerListener",self.moveOutGO);
            eventTrigger.onClick = handler(mgr,mgr._onMoveBtnClick);

            --展锟斤拷
            self:spread();

--            self.moveInGO:SetActive(false);
--            self.moveOutGO:SetActive(true);
        end,
        --锟斤拷锟斤拷
        changeToward= function(self)
            self.beginPos = self.moveDis:Clone();
            self.curMoveToward = -self.curMoveToward;
            self.runTime       = 0;
            if self.curMoveToward>0 then
                self.moveInGO:SetActive(false);
                self.moveOutGO:SetActive(true);
            else
                self.moveInGO:SetActive(true);
                self.moveOutGO:SetActive(false);                
            end
        end,
        --锟斤拷锟斤拷始锟狡讹拷
        moveOpposite= function(self)
            self.isMove = true;
            self:changeToward();
        end,
        setStatus   = function(self,isSpread)
            if isSpread then
                self:spread();
            else
                self:hide();
            end
            
        end,
        spread = function(self)
            if self.curMoveToward>0 then
                self.curMoveToward = -self.curMoveToward; 
            end
            if self.curMoveToward>0 then
                self.moveInGO:SetActive(false);
                self.moveOutGO:SetActive(true);
            else
                self.moveInGO:SetActive(true);
                self.moveOutGO:SetActive(false);                
            end
            self.moveDis.x = self.minX;
            self.beginPos  = self.moveDis:Clone();
            self.buttonGroup.localPosition = self.beginPos;
        end,
        hide   = function(self)
            if self.curMoveToward<0 then
                self.curMoveToward = -self.curMoveToward; 
            end
            if self.curMoveToward>0 then
                self.moveInGO:SetActive(false);
                self.moveOutGO:SetActive(true);
            else
                self.moveInGO:SetActive(true);
                self.moveOutGO:SetActive(false);                
            end
            self.moveDis.x = self.maxX;
            self.beginPos  = self.moveDis:Clone();
            self.buttonGroup.localPosition = self.beginPos;
        end,
    };
    --锟斤拷始锟斤拷
    self._moveButtonAction:init(self);

    --锟较凤拷
    local btnTrans = buttonPanel:Find("AddScore");
    local eventTrigger = Util.AddComponent("EventTriggerListener",btnTrans.gameObject);
    --eventTrigger.onClick = handler(self,self._onAddFishGoldClick);
    eventTrigger.onDown = handler(self,self._onAddFishGoldClick);
    eventTrigger.onUp = handler(self,self._onAddFishGoldUp);
 
    --锟铰凤拷
    btnTrans = buttonPanel:Find("RemoveScore");
    eventTrigger = Util.AddComponent("EventTriggerListener",btnTrans.gameObject);
    eventTrigger.onClick = handler(self,self._onRemoveFishGoldClick);

    local ContinueStatus = buttonPanel:Find("ContinueStatus");
    
    --锟斤拷锟斤拷
    btnTrans = ContinueStatus:Find("OpenContinueShot");
    eventTrigger = Util.AddComponent("EventTriggerListener",btnTrans.gameObject);
    self.openContinueGO = btnTrans.gameObject;
    eventTrigger.onClick = handler(self,self._onOpenContinueShot);

    --锟截憋拷锟斤拷锟斤拷
    btnTrans = ContinueStatus:Find("CloseContinueShot");
    eventTrigger = Util.AddComponent("EventTriggerListener",btnTrans.gameObject);
    self.closeContinueGO = btnTrans.gameObject;
    eventTrigger.onClick = handler(self,self._onCloseContinueShot);
  

    --锟叫伙拷目锟斤拷锟斤拷
    local lockObj = buttonPanel:Find("LockObjs");
--    btnTrans = lockObj:Find("Switch");
--    eventTrigger = Util.AddComponent("EventTriggerListener",btnTrans.gameObject);
--    eventTrigger.onClick = handler(self,self._onSwitchFish);

    --锟斤拷锟斤拷锟斤拷
    btnTrans = lockObj:Find("Lock");
    self.lockBtn = btnTrans;
    eventTrigger = Util.AddComponent("EventTriggerListener",btnTrans.gameObject);
    eventTrigger.onClick = handler(self,self._onLockFish);
    self.lockBtnObj = self.lockBtn.gameObject;

    --锟斤拷锟斤拷
    btnTrans = lockObj:Find("Unlock");
    self.unlockBtn = btnTrans;
    eventTrigger = Util.AddComponent("EventTriggerListener",btnTrans.gameObject);
    eventTrigger.onClick = handler(self,self._onUnlockFish);
    self.unlockBtnObj = self.unlockBtn.gameObject;
    self.unlockBtnObj:SetActive(false);

--    --选锟斤拷锟斤拷
--    self.chooseFishTip = transform:Find("ChooseFish"):GetComponent("Image");
--    self.displayChooseData = {
--        isFirstChoose = true,
--        time = 0,
--        aphla = 1,
--        aphlaSpeed = 0.03,
--        lowAphla = 0.5,
--        maxAphla = 1,
--    };

    --锟斤拷锟斤拷锟较?
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
    


    --锟较凤拷锟斤拷示
    self._addScoreTips = transform:Find("TipBg");
    self._addScoreTips.gameObject:SetActive(false);

end


--锟斤拷始锟斤拷锟斤拷锟?
function _CPlayersControl:_initPlayers()
    local obj = G_GlobalGame._goFactory:createPlayers();
    local transform = obj.transform;
    self._playersTransform = obj.transform;
    transform:SetParent(self.transform);
    transform.localScale = Vector3.New(1,1,1);
    transform.localPosition = Vector3.New(0,0,0);

    self.upPlayers      = transform:Find("UpPlayer");
    self.downPlayers    = transform:Find("DownPlayer");

    --锟斤拷锟斤拷锟斤拷
    local alignView = self.upPlayers.gameObject:AddComponent(AlignViewExClassType);
    alignView:setAlign(Enum_AlignViewEx.Align_Up);
    alignView.isKeepPos = true;
    alignView = self.downPlayers.gameObject:AddComponent(AlignViewExClassType);
    alignView:setAlign(Enum_AlignViewEx.Align_Bottom);
    alignView.isKeepPos = true;

--    --锟斤拷锟斤拷锟斤拷
--    self.lockLayer      = transform:Find("LockLayer");

--    --锟缴斤拷锟?
--    local flyGoldTransform = transform:Find("FlyGoldLayer");
--    self._flyGoldControl:Init(flyGoldTransform);

    self.playerChairs[1]= self.downPlayers:Find("Player1"); 
    self.playerChairs[2]= self.downPlayers:Find("Player2");
    self.playerChairs[3]= self.upPlayers:Find("Player1"); 
    self.playerChairs[4]= self.upPlayers:Find("Player2"); 
    self.playerControls[1]= _CPlayerRightControl.New(self,self._bulletControl);
    self.playerControls[2]= _CPlayerLeftControl.New(self,self._bulletControl);
    self.playerControls[3]= _CPlayerRightControl.New(self,self._bulletControl);
    self.playerControls[4]= _CPlayerLeftControl.New(self,self._bulletControl);
    self.playerControls[1]:Init(self.playerChairs[1],self.lockLayer);
    self.playerControls[2]:Init(self.playerChairs[2],self.lockLayer);
    self.playerControls[3]:Init(self.playerChairs[3],self.lockLayer);
    self.playerControls[4]:Init(self.playerChairs[4],self.lockLayer);
 
--    --锟斤拷示锟斤拷锟斤拷锟?
--    self.showGoldNumLayer = transform:Find("GoldNumberLayer");
--    self._showGoldNumControl:Init(self.showGoldNumLayer);
    --位锟斤拷锟斤拷锟斤拷
    local bottomPanel = transform:Find("BottomAlign");
    self.bottomPanel  = bottomPanel;
    self._leftPosTip  = self.bottomPanel:Find("Left");
    self._rightPosTip = self.bottomPanel:Find("Right");
    self._leftPosTip.gameObject:SetActive(false);
    self._rightPosTip.gameObject:SetActive(false);
    local alignView = bottomPanel.gameObject:AddComponent(AlignViewExClassType);
    alignView:setAlign(Enum_AlignViewEx.Align_Bottom);
    alignView.isKeepPos = true;
end

--锟斤拷医锟斤拷敕匡拷锟?
function _CPlayersControl:OnUserEnter(_eventId,_user)
    local _isOwner = false;
    if self._isEmpty then
        if _user.chairId<2 then --锟斤拷锟斤拷
            self._chairIds[0]=1;
            self._chairIds[1]=2;
            self._chairIds[2]=3;
            self._chairIds[3]=4;
            self._isRotation = false;
        else
            self._chairIds[0]=3;
            self._chairIds[1]=4;
            self._chairIds[2]=1;
            self._chairIds[3]=2;
            self._isRotation = true;
        end

        do
            --锟斤拷示位锟斤拷锟斤拷示时锟斤拷
            self._popTipPosData = {
                _tipPosTime = G_GlobalGame.GameConfig.SceneConfig.iPosTipTime,
                _moveToward = -1,
                _moveY      = 0,
                _moveBeginPos = nil,
                _movePosCtrl= nil,
                _curPosTip = nil,
            };

            if _user.chairId ==0 or _user.chairId == 2 then
                self._rightPosTip.gameObject:SetActive(true);
                self._popTipPosData._movePosCtrl = self._rightPosTip:Find("Arraw");
                self._popTipPosData._curPosTip   = self._rightPosTip;
                self._popTipPosData._popCircle   = self._rightPosTip:Find("HereFlag");
            else
                self._leftPosTip.gameObject:SetActive(true);
                self._popTipPosData._movePosCtrl = self._leftPosTip:Find("Arraw");
                self._popTipPosData._curPosTip   = self._leftPosTip;
                self._popTipPosData._popCircle   = self._leftPosTip:Find("HereFlag");
            end
            self._popTipPosData._moveBeginPos = self._popTipPosData._movePosCtrl.localPosition;
        end
        self._myChairId = _user.chairId;
        self._isEmpty = false;
        _isOwner = true;
        if self._isRotation then
            self._sceneControl:Rotation();
            self._sceneControl:FadeOutMaskBg();
        else
            self._sceneControl:NormalRotation();
            self._sceneControl:DisappearMaskBg();
        end
    end
    local curPlayerControls = self.playerControls[self._chairIds[_user.chairId]];
    --UID锟斤拷应锟斤拷位锟斤拷
    self._userIdsMap:assign(_user.uid,_user.chairId);
    --锟斤拷要锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷台
    curPlayerControls:OnUserEnter(_user,_isOwner);
    if _isOwner then --锟斤拷锟斤拷约锟?锟斤拷锟斤拷锟皆碉拷锟斤拷谢锟斤拷锟教?
        curPlayerControls:EnabledClickSwitchPaotai(true);
    end

    --锟斤拷锟斤拷锟斤拷业锟斤拷锟斤拷趾徒锟斤拷
    curPlayerControls:SetGold(_user.gold);
    curPlayerControls:SetName(_user.name);

end

--锟斤拷锟斤拷锟斤拷医锟斤拷锟斤拷
function _CPlayersControl:SetMyGold(_gold)
    --self._goldAtlasNumber:SetNumber(_gold);
end

--锟斤拷锟斤拷锟斤拷锟斤拷
function _CPlayersControl:SetName(_name)
    --self._nameLabel.text = _name;
end

function _CPlayersControl:IsRotation()
    return self._isRotation;
end

function _CPlayersControl:_onMoveBtnClick()
    --锟侥变方锟斤拷
    self._moveButtonAction:moveOpposite();
end

--锟较分碉拷锟?
function _CPlayersControl:_onAddFishGoldClick()
    ----锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷戏锟斤拷锟斤拷锟?
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
    --锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷戏锟斤拷锟斤拷锟?
    if GameManager.isEnterGame then
        G_GlobalGame._clientSession:SendAddScore();
    end
    --锟斤拷锟斤拷锟铰凤拷锟斤拷锟斤拷
    G_GlobalGame:PlayEffect(G_GlobalGame.SoundDefine.UpScore);
end


--锟铰分碉拷锟?
function _CPlayersControl:_onRemoveFishGoldClick()
    --锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷路锟斤拷锟斤拷锟?
    G_GlobalGame._clientSession:SendRemoveScore();
    --锟斤拷锟斤拷锟铰凤拷锟斤拷锟斤拷
    G_GlobalGame:PlayEffect(G_GlobalGame.SoundDefine.ChangeScore);
end

--锟斤拷锟斤拷锟斤拷锟戒功锟斤拷
function _CPlayersControl:_onOpenContinueShot()
    self.openContinueGO:SetActive(false);
    self.closeContinueGO:SetActive(true);
    self._isContinueShot = true;
end

--锟截憋拷锟斤拷锟戒功锟斤拷
function _CPlayersControl:_onCloseContinueShot()
    self.openContinueGO:SetActive(true);
    self.closeContinueGO:SetActive(false);
    self._isContinueShot = false;
end

--锟斤拷锟斤拷锟斤拷
function _CPlayersControl:_onLockFish()
    --锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷墓锟斤拷锟?
    self:_openLock();
    local curPlayerControl = self.playerControls[self._chairIds[self._myChairId]];
    curPlayerControl:_onOpenLock();
    local fish =self._fishControl:GetNextLockFish();
    if not fish then
        --没锟叫匡拷锟斤拷锟斤拷锟斤拷锟斤拷
        return ;
    end
    curPlayerControl:SetLockFish(fish);
end


function _CPlayersControl:_openLock()
    local curPlayerControl = self.playerControls[self._chairIds[self._myChairId]];
    curPlayerControl:_onCloseLock();
    self._isOpenLock = true;
    self.lockBtnObj:SetActive(false);
    self.unlockBtnObj:SetActive(true);
end

function _CPlayersControl:_closeLock()
    self.unlockBtnObj:SetActive(false);
    self.lockBtnObj:SetActive(true);
    self._isOpenLock = false;
end

function _CPlayersControl:IsOpenLock()
    return self._isOpenLock;
end

--锟斤拷锟斤拷锟斤拷
function _CPlayersControl:_onUnlockFish()
    self:_closeLock();
    --锟斤拷锟饺★拷锟斤拷锟斤拷锟斤拷锟?
    local curPlayerControl = self.playerControls[self._chairIds[self._myChairId]];
    curPlayerControl:SetLockFish(nil);
end

--锟叫伙拷锟斤拷
function _CPlayersControl:_onSwitchFish()
    local curPlayerControl = self.playerControls[self._chairIds[self._myChairId]];
    local fish = curPlayerControl:GetLockFish();
    if fish ==nil then
        --锟斤拷锟矫伙拷锟斤拷锟斤拷锟斤拷锟?
        return ;
    end
    fish = self._fishControl:GetNextLockFish(fish);
    if fish ==nil then
        --锟斤拷锟截憋拷锟斤拷锟斤拷锟斤拷锟斤拷
        --self:_onUnlockFish();
        curPlayerControl:CorrectAngle();
        curPlayerControl:SetLockFish(nil); 
    else
        --锟叫伙拷锟斤拷目锟斤拷
        curPlayerControl:SetLockFish(fish);
    end
end

--锟叫伙拷锟斤拷锟斤拷锟斤拷锟斤拷
function _CPlayersControl:OnSwitchNextLockFish(_chairId,_fish)
    if _chairId==self._myChairId then
        self:_onSwitchFish();
    else
        local curPlayerControl = self.playerControls[self._chairIds[_chairId]];
        local fish = curPlayerControl:GetLockFish();
        if fish ==nil then
            --锟斤拷锟矫伙拷锟斤拷锟斤拷锟斤拷锟?
            curPlayerControl:SetLockFish(nil);  
            return ;
        end
        fish = self._fishControl:GetNextLockFish(fish);
        curPlayerControl:SetLockFish(fish);       
    end
end

--锟斤拷锟街匡拷锟斤拷锟斤拷锟斤拷锟斤拷
function _CPlayersControl:AppearanceLockFish(_eventId,_fish)
    if not self._isOpenLock then
        return ;
    end
    --锟斤拷锟斤拷锟斤拷
    local curPlayerControl = self.playerControls[self._chairIds[self._myChairId]];
    local fish = curPlayerControl:GetLockFish();
    if fish ==nil then
    	--锟斤拷锟矫伙拷锟斤拷锟斤拷锟斤拷锟?
    	curPlayerControl:SetLockFish(_fish); 
    	return ;
    end
end

--锟斤拷锟斤拷肟?
function _CPlayersControl:OnUserLeave(_eventId,_user)
    local chairId = self._userIdsMap:erase(_user.uid);
    if chairId then
        local curPlayerControl = self.playerControls[self._chairIds[chairId]];
        curPlayerControl:OnUserLeave(_user);
    end
end


function _CPlayersControl:OnUserFire(_eventId,_fire)

    if not self._isCanCreateBullet then
        return 
    end
    local curPlayerControl = self.playerControls[self._chairIds[_fire.chairId]];
    if _fire.chairId == self._myChairId then

        curPlayerControl:OnUserFire(_fire,self._myChairId);
    else
		_fire.lockFishId=0
        curPlayerControl:OnUserFire(_fire,self._myChairId);
    end
end

--锟斤拷锟斤拷谢锟斤拷锟?
function _CPlayersControl:OnUserChangeBullet(_data)

end

--锟揭伙拷锟斤拷锟?
function _CPlayersControl:OnExchangeFishGold(_eventId,_exchangeData)
    local curPlayerControl = self.playerControls[self._chairIds[_exchangeData.chairId]];
    curPlayerControl:SetFishGold(_exchangeData.fishGold);
    if _exchangeData.chairId==self._myChairId then
        if curPlayerControl:IsEnoughFire() then
            --锟角凤拷锟姐够锟斤拷锟斤拷
            self:_setScoreTipsVisible(false);
        end
    end
end

--抓锟斤拷锟斤拷
function _CPlayersControl:OnCatchFish(_eventId,_fishInfo)
    --抓锟斤拷锟斤拷锟斤拷
    local fish = self._fishControl:GetFish(_fishInfo.fishId);
    if not fish then
        --锟斤拷锟斤拷锟斤拷没锟斤拷锟斤拷锟斤拷锟斤拷
        return ;
    end
    local fishType = fish:FishType();
    local fishConfig = G_GlobalGame.GameConfig.FishInfo[fishType];
    local curPlayerControl = self.playerControls[self._chairIds[_fishInfo.chairId]];
    local EnumFishEffect = G_GlobalGame.Enum_FISH_Effect;
    local waitFlyTime = G_GlobalGame.GameConfig.SceneConfig.iFishDeadTime;

    if fishConfig.effectType == EnumFishEffect.Common_Fish then
        --锟斤拷通锟斤拷
        fish:Die();
        if _fishInfo.chairId ~= self._myChairId then
            --锟斤拷锟斤拷锟斤拷掖锟斤拷锟姐不锟斤拷锟?
            fish:NormalColor();
        end
        --锟斤拷锟斤拷锟斤拷锟?
        curPlayerControl:AddFishGold(_fishInfo.fishGold);
        --锟斤拷叶锟?
        curPlayerControl:WinFishGold(_fishInfo.fishGold);

        if G_GlobalGame.FunctionsLib.Mod_Fish_IsNeedWheel(fishType) then
            --摩锟斤拷锟斤拷
            curPlayerControl:Wheel(_fishInfo.fishGold);
        end
        --锟角凤拷锟斤拷锟斤拷锟斤拷锟斤拷
        if _fishInfo.bulletIon==1 then
            --锟斤拷锟斤拷锟斤拷锟斤拷锟?
            curPlayerControl:GetEnergy(fish:Position());
        end

        --锟斤拷锟斤拷锟斤拷锟?
        --G_GlobalGame:PlayEffect(G_GlobalGame.SoundDefine.Catch);

        --锟缴斤拷锟?
        local isRotation
        if self._chairIds[_fishInfo.chairId]>=3 then
            isRotation = true;
        else
            isRotation = false;
        end

        if fishConfig.gold>0 then
            self._flyGoldControl:CreateFlyGold(_fishInfo.chairId,fishConfig.goldType,fishConfig.gold,fish:Position(),
                    curPlayerControl:FlyGoldPosition(),isRotation,waitFlyTime);
        end

        if _fishInfo.fishGold>0 then
            self._showGoldNumControl:CreateNumber(_fishInfo.fishGold,fish:Position());
        end
    elseif fishConfig.effectType == EnumFishEffect.Stop_Fish then
        --锟斤拷时
        fish:Die();
        if _fishInfo.chairId ~= self._myChairId then
            --锟斤拷锟斤拷锟斤拷掖锟斤拷锟姐不锟斤拷锟?
            fish:NormalColor();
        end
        --锟斤拷锟斤拷锟斤拷锟?
        curPlayerControl:AddFishGold(_fishInfo.fishGold);

        --锟斤拷叶锟?
        curPlayerControl:WinFishGold(_fishInfo.fishGold);
        --锟斤拷锟斤拷
        self._sceneControl:Pause();

        --锟斤拷锟斤拷效锟斤拷
        G_GlobalGame:DispatchEventByStringKey("NotifyCreatePauseScrn",{type = G_GlobalGame.Enum_BombEffectType.PauseScreen, position = Vector3.zero});

        if G_GlobalGame.FunctionsLib.Mod_Fish_IsNeedWheel(fishType) then
            --摩锟斤拷锟斤拷
            curPlayerControl:Wheel(_fishInfo.fishGold);
        end

        --锟角凤拷锟斤拷锟斤拷锟斤拷锟斤拷
        if _fishInfo.bulletIon==1 then
            --锟斤拷锟斤拷锟斤拷锟斤拷锟?
            --curPlayerControl:ChangeToEnergy();
            curPlayerControl:GetEnergy(fish:Position());
        end

        --锟斤拷锟斤拷锟斤拷锟?
        --G_GlobalGame:PlayEffect(G_GlobalGame.SoundDefine.Catch);

        --锟缴斤拷锟?
        local isRotation
        if self._chairIds[_fishInfo.chairId]>=3 then
            isRotation = true;
        else
            isRotation = false;
        end
        --self._flyGoldControl:CreateFlyGold(_fishInfo.chairId,5,fish:Position(),curPlayerControl:FlyGoldPosition(),isRotation);
        if fishConfig.gold>0 then
            self._flyGoldControl:CreateFlyGold(_fishInfo.chairId,fishConfig.goldType,fishConfig.gold,fish:Position(),
                curPlayerControl:FlyGoldPosition(),isRotation,waitFlyTime);
        end

        if _fishInfo.fishGold>0 then
            self._showGoldNumControl:CreateNumber(_fishInfo.fishGold,fish:Position());
        end
    elseif fishConfig.effectType == EnumFishEffect.Bomb_Fish then
        --锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷
        local vec=nil;
        --fish:FalseDie();

        if _fishInfo.chairId ~= self._myChairId then
            --锟斤拷锟斤拷锟斤拷掖锟斤拷锟姐不锟斤拷锟?
            fish:NormalColor();
        end
        --锟角凤拷锟斤拷锟斤拷锟斤拷锟斤拷
        if _fishInfo.bulletIon==1 then
            --锟斤拷锟斤拷锟斤拷锟斤拷锟?
            --curPlayerControl:ChangeToEnergy();
            curPlayerControl:GetEnergy(fish:Position());
        end

        if fishType == G_GlobalGame.Enum_FishType.FISH_KIND_23 then
            --锟街诧拷炸锟斤拷
            vec = self._fishControl:GetFishesInScreenInnerRound(fish,G_GlobalGame.GameConfig.SceneConfig.bombRound);
        else
            --全锟斤拷炸锟斤拷
            vec = self._fishControl:GetFishesInScreenExceptFish(fish);
        end
        --锟斤拷锟斤拷锟斤拷息
        G_GlobalGame._clientSession:SendCatchSweepFish(_fishInfo.chairId,_fishInfo.fishId,vec);
    elseif fishConfig.effectType == EnumFishEffect.Fish_Boss then
        --锟斤拷锟斤拷同锟斤拷锟酵碉拷锟斤拷锟斤拷锟斤拷
        --fish:FalseDie();
        if _fishInfo.chairId ~= self._myChairId then
            --锟斤拷锟斤拷锟斤拷掖锟斤拷锟姐不锟斤拷锟?
            fish:NormalColor();
        end

        --锟角凤拷锟斤拷锟斤拷锟斤拷锟斤拷
        if _fishInfo.bulletIon==1 then
            --锟斤拷锟斤拷锟斤拷锟斤拷锟?
            --curPlayerControl:ChangeToEnergy();
            curPlayerControl:GetEnergy(fish:Position());
        end

        local vec = self._fishControl:GetFishesInScreenWithFishType(fishType-30);
        --锟斤拷锟斤拷锟斤拷息
        G_GlobalGame._clientSession:SendCatchSweepFish(_fishInfo.chairId,_fishInfo.fishId,vec);

        --锟斤拷锟斤拷锟斤拷锟?
        --G_GlobalGame:PlayEffect(G_GlobalGame.SoundDefine.Catch);
    end

end

--捉锟斤拷锟斤拷锟斤拷锟?
function _CPlayersControl:OnCatchTranslateFish(_eventId,_fishInfo)
    local chairId = _fishInfo.chairId;
    local curPlayerControl = self.playerControls[self._chairIds[chairId]]; 
    local fish = self._fishControl:GetFish(_fishInfo.fishId);

    local fishType = fish:FishType();
    local fishConfig = G_GlobalGame.GameConfig.FishInfo[fishType];
    local EnumFishEffect = G_GlobalGame.Enum_FISH_Effect;
    local position = fish:Position();
    fish:Die();
    fish:Disappear();
    local newFishConfig = G_GlobalGame.GameConfig.FishInfo[_fishInfo.fishKind];
    local newFish = self._fishControl:CreateLocalFish(_fishInfo.fishKind);
    newFish:SetPosition(position);
    --锟斤拷锟斤拷锟斤拷
    newFish:Die();
    local isRotation
    if self._chairIds[chairId]>=3 then
        isRotation = true;
    else
        isRotation = false;
    end

    --锟缴斤拷锟?
    if newFishConfig.gold>0 then
        self._flyGoldControl:CreateFlyGold(_fishInfo.chairId,newFishConfig.goldType,newFishConfig.gold,position,curPlayerControl:FlyGoldPosition(),isRotation);
    end

    --锟斤拷示锟斤拷锟斤拷
    if _fishInfo.fishGold>0 then
        self._showGoldNumControl:CreateNumber(_fishInfo.fishGold,position);
    end

    --锟斤拷锟斤拷锟斤拷锟?
    curPlayerControl:AddFishGold(_fishInfo.fishGold);

    --锟斤拷叶锟?
    curPlayerControl:WinFishGold(_fishInfo.fishGold);

end

--抓锟斤拷锟斤拷群
function _CPlayersControl:OnCatchGroupFish(_eventId,_fishGroupInfo)
    local chairId = _fishGroupInfo.chairId;
    local curPlayerControl = self.playerControls[self._chairIds[chairId]];    
    local isRotation
    local waitFlyTime = G_GlobalGame.GameConfig.SceneConfig.iFishDeadTime;
    if self._chairIds[chairId]>=3 then
        isRotation = true;
    else
        isRotation = false;
    end
        
    --锟矫碉拷锟斤拷源锟斤拷
    local causeFish = self._fishControl:GetFalseDieFish(_fishGroupInfo.fishId);

    if not causeFish then
        --锟揭诧拷锟斤拷源头锟斤拷
        return ;
    end

    local fishConfig = G_GlobalGame.GameConfig.FishInfo[causeFish:FishType()];
    if fishConfig.gold>0 then
        self._flyGoldControl:CreateFlyGold(chairId,fishConfig.goldType,fishConfig.gold,causeFish:Position(),
            curPlayerControl:FlyGoldPosition(),isRotation,waitFlyTime);
    end

    if _fishGroupInfo.fishGold>0 then
        self._showGoldNumControl:CreateNumber(_fishGroupInfo.fishGold,causeFish:Position());
    end

    local fishType = causeFish:FishType();
    local fish;
    local isLine = false;
    local position = causeFish:Position();
    local tab = {type = G_GlobalGame.Enum_BombEffectType.Line, bossPosition = position};
    if fishConfig.effectType == G_GlobalGame.Enum_FISH_Effect.Fish_Boss then
        --锟斤拷要锟斤拷锟斤拷锟竭碉拷效锟斤拷
        isLine = true;
    end

    --锟斤拷锟斤拷锟斤拷
    causeFish:RealDie();

    for i=1,_fishGroupInfo.catchFishCount do
        fish = self._fishControl:GetFish(_fishGroupInfo.catchFishIds[i]);
        fish:Die();

        if chairId ~= self._myChairId then
            --锟斤拷锟斤拷锟斤拷掖锟斤拷锟姐不锟斤拷锟?
            fish:NormalColor();
        end
        fishConfig = G_GlobalGame.GameConfig.FishInfo[fish:FishType()];
        if fishConfig.gold>0 then
            self._flyGoldControl:CreateFlyGold(chairId,fishConfig.goldType,fishConfig.gold,fish:Position(),
                curPlayerControl:FlyGoldPosition(),isRotation,waitFlyTime);
        end
        if isLine then
            --锟斤拷锟斤拷锟斤拷锟斤拷
            tab.smallPosition = fish:Position();
            G_GlobalGame:DispatchEventByStringKey("NotifyCreateLine",tab);
        end
    end

    --锟斤拷锟斤拷锟斤拷锟?
    curPlayerControl:AddFishGold(_fishGroupInfo.fishGold);
  
    --锟斤拷叶锟?
    curPlayerControl:WinFishGold(_fishGroupInfo.fishGold);

    if isLine and _fishGroupInfo.catchFishCount>0 then
        --锟斤拷锟斤拷锟斤拷锟斤拷源头
        G_GlobalGame:DispatchEventByStringKey("NotifyCreateLineSour",{type = G_GlobalGame.Enum_BombEffectType.LineSource, position = position});
    end

    if G_GlobalGame.FunctionsLib.Mod_Fish_IsNeedWheel(fishType) then
        --摩锟斤拷锟斤拷
        curPlayerControl:Wheel(_fishGroupInfo.fishGold);
    end

end

function _CPlayersControl:OnUserScoreChange(_eventId,_userScore)
    if self._myChairId == _userScore.chairId then
        --刷锟斤拷锟皆硷拷锟斤拷业慕锟斤拷
        --self:SetMyGold(_userScore.gold);
    end
    --锟斤拷医锟揭改憋拷
    local curPlayerControls = self.playerControls[self._chairIds[_userScore.chairId]];
    if curPlayerControls then
        curPlayerControls:SetGold(_userScore.gold);
    end
end

--锟斤拷锟斤拷锟节碉拷锟斤拷
function _CPlayersControl:OnEnergyTimeOut(_eventId,_info)
    local curPlayerControl = self.playerControls[self._chairIds[_info.chairId]];  
    if curPlayerControl then
        curPlayerControl:ChangeToNormal();
    end
end

--UI锟斤拷锟斤拷转锟斤拷为锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟?
function _CPlayersControl:UIPointChangeToScenePoint(targetPoint)

end

--锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟阶拷锟轿猆I锟斤拷锟斤拷
function _CPlayersControl:ScenePointChangeToUIPoint(scenePoint)

end


--每帧锟斤拷锟斤拷
function _CPlayersControl:Update(_dt)
    --锟斤拷锟斤拷锟斤拷示位锟斤拷
    self:_controlPopTip(_dt);
    --锟斤拷锟狡帮拷钮锟斤拷
    self:_controlMoveBtn(_dt);
    for i=1,G_GlobalGame.ConstDefine.C_S_PLAYER_COUNT do
        if self.playerControls[i] then
            self.playerControls[i]:Update(_dt);
        end
    end
    self._flyGoldControl:Update(_dt);
    if not self:IsInNewHand() then
        self:_onFire();
    end
    if  G_GlobalGame.bulletId>1000 then 
		G_GlobalGame.bulletId=0
	end
    self._longKeyPress:Execute(_dt);
    self._showGoldNumControl:Update(_dt);

    if not self._isEmpty then
        --锟斤拷锟斤拷锟?
        local curPlayerControl = self.playerControls[self._chairIds[self._myChairId]];    
        if curPlayerControl:IsEnoughFire() then
            --锟角凤拷锟姐够锟斤拷锟斤拷
            self:_setScoreTipsVisible(false);
        end
    end
end

function _CPlayersControl:_controlPopTip(_dt)
    local popPosTipData = self._popTipPosData;
    if popPosTipData._tipPosTime>0 then
        --锟斤拷锟斤拷锟斤拷示位锟斤拷锟斤拷息
        popPosTipData._tipPosTime = popPosTipData._tipPosTime -  _dt;
        popPosTipData._moveY = popPosTipData._moveY + popPosTipData._moveToward;
        if popPosTipData._moveY<-13 or popPosTipData._moveY>0 then
            popPosTipData._moveToward = popPosTipData._moveToward == -1 and 1 or -1;
        end
        popPosTipData._movePosCtrl.localPosition = popPosTipData._moveBeginPos + Vector3.New(0,popPosTipData._moveY,0);
        if popPosTipData._tipPosTime<=0 then
            popPosTipData._curPosTip.gameObject:SetActive(false);
        end
        --圆圈锟斤拷转
        popPosTipData._popCircle:Rotate(Vector3.New(0,0,80*_dt));
    end
end


--锟斤拷锟斤拷锟狡讹拷锟斤拷钮锟斤拷
function _CPlayersControl:_controlMoveBtn(_dt)
    local moveData = self._moveButtonAction;
    if moveData.isMove then
        moveData.runTime = moveData.runTime + _dt;
        moveData.moveDis.x = moveData.beginPos.x + moveData.curMoveToward * moveData.runTime;
        if moveData.moveDis.x<=moveData.minX then
            moveData.moveDis.x = moveData.minX;
            moveData.isMove = false;
        end
        if moveData.moveDis.x>=moveData.maxX then
            moveData.moveDis.x = moveData.maxX;
            moveData.isMove = false;
        end
        moveData.buttonGroup.localPosition = moveData.moveDis;
    end
end

local inorgeTargetName = "GOContainer_BelowUI";
local UIPartName = "UI_Part";

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

function _CPlayersControl:_onFire()
    if self._myChairId==G_GlobalGame.ConstDefine.C_S_INVALID_CHAIR_ID then
        return ;
    end
    local targetPos=Input.mousePosition;
    local curPlayerControls = self.playerControls[self._chairIds[self._myChairId]];
    local isClickBtn = false;
    
    if (Input.GetKey(KeyCode.Mouse0) == true or Input.GetKey(KeyCode.Space) == true or Input.GetMouseButton(0) == true ) then
        if self._lastIsClick then
            isClickBtn = self._lastClickBtn;
        else
            local func = Util.IsPointerOverGameObject2;
            if func~=nil then
                if func(G_GlobalGame._canvasComponent,targetPos) then
                    isClickBtn = true; 
                end
            else
                if UnityEngine.EventSystems.EventSystem.current:IsPointerOverGameObject() then
                    local currentSelectedGameObject = UnityEngine.EventSystems.EventSystem.current.currentSelectedGameObject;
                    if currentSelectedGameObject and currentSelectedGameObject.transform.parent then
                        isClickBtn = true; 
                    end
                end        
            end            
        end
        self._lastIsClick = true;
    else
        self._lastIsClick = false;
    end

    self._lastClickBtn = isClickBtn;

    --锟斤拷录锟较次碉拷锟?
    self._lastClick = self._curClick;
    if (Input.GetKey(KeyCode.Mouse0) == true or Input.GetKey(KeyCode.Space) == true or Input.GetMouseButton(0) == true ) then
        if isClickBtn then
            self._curClick = false;
        else
            self._curClick = true;
        end
    else
        self._curClick = false;   
    end
    
    if not curPlayerControls:IsEnoughFire() then
        if self._myChairId == 0 or self._myChairId==2 then
            --self._addScoreTips.localPosition = Vector3.New(424,112,0);
            --锟斤拷锟斤拷锟斤拷锟斤拷
            self:_setScoreTipsVisible(true);
        else
            --self._addScoreTips.localPosition = Vector3.New(-310,112,0);
            --锟斤拷锟斤拷锟斤拷锟斤拷
            self:_setScoreTipsVisible(true);
        end
        --锟截憋拷锟斤拷锟戒功锟斤拷
        self:_onCloseContinueShot();
--        return true;
    end
    
    if self:IsOpenLock() then
        if self._curClick and not self._lastClick and not isClickBtn then
            --锟叫伙拷锟斤拷
            local fish = self:GetCanLockFishByPos(targetPos);
            if fish then
                curPlayerControls:SetLockFish(fish);
            end
        end
    end
    --转锟斤拷锟斤拷锟斤拷锟斤拷系
    if G_GlobalGame.RunningPlatform == RuntimePlatform.WindowsPlayer  or G_GlobalGame.IsEditor then
        if self._isNeedClickToward then
            if self._curClick then
                targetPos = G_GlobalGame:SwitchScreenPosToWorldPosByUICamera(targetPos);
            end
        else
            targetPos = G_GlobalGame:SwitchScreenPosToWorldPosByUICamera(targetPos);
        end
    else
        if self._curClick then
            targetPos = G_GlobalGame:SwitchScreenPosToWorldPosByUICamera(targetPos);
        end
    end
    --targetPos = G_GlobalGame:SwitchScreenPosToWorldPosByUICamera(targetPos);
	--error("_isCanCreateBullet=" ..tostring(self._isCanCreateBullet))
	
    if not self._isCanCreateBullet or not curPlayerControls:IsEnoughFire()  then
        --锟斤拷锟皆匡拷锟斤拷
        --只锟斤拷锟斤拷转锟斤拷
        if self._isNeedClickToward then
            if self._curClick then
                curPlayerControls:TowardTarget(targetPos);
            else
                curPlayerControls:TowardTarget(nil);
            end
        else
            if G_GlobalGame.RunningPlatform == RuntimePlatform.WindowsPlayer  or G_GlobalGame.IsEditor then
                curPlayerControls:TowardTarget(targetPos);
            else
                if self._curClick then
                    targetPos = curPlayerControls:TowardTarget(targetPos);
                end
            end
        end
        --停锟斤拷
        curPlayerControls:StopFire();
    else
        --锟斤拷锟斤拷锟斤拷锟?
        if self._isContinueShot or self._curClick then
            if self._isNeedClickToward then
                if self._curClick then
                    curPlayerControls:UserFire(targetPos,true);
                else
                    curPlayerControls:UserFire(nil,true);
                end
            else
                if self._curClick then
                    curPlayerControls:UserFire(targetPos,true);
                else
                    curPlayerControls:UserFire(nil,true);
                end
            end
        else
            --停锟斤拷
            curPlayerControls:StopFire();
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

--锟斤拷停锟斤拷锟斤拷锟接碉拷
function _CPlayersControl:PauseCreateBullet()
    self._isCanCreateBullet = false; 

end

--锟截革拷锟斤拷锟斤拷锟接碉拷
function _CPlayersControl:ResumeCreateBullet()
    self._isCanCreateBullet = true;

end

--function _CPlayersControl:On

--锟秸碉拷锟叫伙拷锟斤拷台
function _CPlayersControl:OnSwitchPaotai()
    local curPlayerControls = self.playerControls[self._chairIds[self._myChairId]];
    curPlayerControls:SwitchPaotai();
end

--锟秸碉拷锟较凤拷锟斤拷锟斤拷
function _CPlayersControl:OnAddScore()
    --锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷戏锟斤拷锟斤拷锟?
    G_GlobalGame._clientSession:SendAddScore();
    G_GlobalGame:PlayEffect(G_GlobalGame.SoundDefine.UpScore);
end

--锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷
function _CPlayersControl:OnNewHandEnd()
    local da={[1]=G_GlobalGame.ConstDefine.GAME_ID};
    UserNewHand[#UserNewHand+1]=da;

    G_GlobalGame._clientSession:NewHandOver();

    self._isNewHand = false;
end

--锟角凤拷始锟斤拷锟斤拷锟斤拷锟斤拷
function _CPlayersControl:IsNeedNewHandGuide()
    local isNewHand = true;
    if UserNewHand==nil then
        return isNewHand;
    end
    for i=1,#UserNewHand do
        if UserNewHand[i]==nil then
        elseif UserNewHand[i][1]==G_GlobalGame.ConstDefine.GAME_ID then
            isNewHand = false;
            break;
        else
        end
    end
    return isNewHand;
end

--锟斤拷始锟斤拷锟斤拷锟斤拷锟斤拷
function _CPlayersControl:StartNewHand()
    self._isNewHand = true;
    self._newHandControl = CNewHandControl.New();
    local obj  = G_GlobalGame._goFactory:createNewHand();
    local transform = obj.transform;
    self._newHandControl:Init(transform,self._myChairId);
    local localPosition = transform.localPosition;
    local localScale    = transform.localScale;
    transform:SetParent(self.transform);
    transform.localScale     = localScale;
    transform.localPosition  = localPosition;
end

--锟角凤拷锟斤拷锟斤拷锟斤拷锟斤拷
function _CPlayersControl:IsInNewHand()
    return self._isNewHand;
end

--锟斤拷锟斤拷锟斤拷械锟斤拷锟斤拷
function _CPlayersControl:ClearAllPlayers()
    self:_onUnlockFish();
    local chairId ;
    local curPlayerControl;
    --[[
    local it = self._userIdsMap:iter();
    local val = it();

    while(val) do
        chairId = self._userIdsMap:value(val);
        if chairId then
            curPlayerControl = self.playerControls[self._chairIds[chairId];
            if curPlayerControl then
                curPlayerControl:OnUserLeave();
            end
        end
        val = it();
    end
    --]]
    self:_onCloseContinueShot();
    for i=1,4 do
        curPlayerControl = self.playerControls[i];
        if curPlayerControl then
            curPlayerControl:StopFire();
            curPlayerControl:OnUserLeave();
        end
    end
    self._isEmpty = true;

    --影锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟绞?
    local popPosTipData = self._popTipPosData;
    if popPosTipData._curPosTip then
        popPosTipData._curPosTip.gameObject:SetActive(false);
    end

    --锟斤拷锟斤拷锟斤拷锟?
    self._showGoldNumControl:Clear();

    self._userIdsMap:clear();
    self._myChairId = G_GlobalGame.ConstDefine.C_S_INVALID_CHAIR_ID;
end

function _CPlayersControl:GetCanLockFishByPos(_target)
    local it=self._fishControl:IterScreenFish();
    local fish = it();
    local fishCollider;
    local colliders;
    local count;

    --锟斤拷锟斤拷锟?锟斤拷锟斤拷锟斤拷
    local main =  G_GlobalGame._uiCamera;
    local ray = main:ScreenPointToRay(_target);  
    local t;  
    local ret,hitInfo;
    local it2,val2;
    while(fish) do
        if fish:IsCanBeLock() then
            --fishCollider = fish:BoxCollider();
            colliders = fish:BoxColliders();
            it2 = colliders:iter();
            val2 = it2();
            while(val2) do
                ret,hitInfo = val2:Raycast(ray,t,2000);
                if ret then
                    return fish;
                end 
                val2 = it2();
            end
--            count = #colliders;
--            for i=1,count do
--                ret,hitInfo = colliders[i]:Raycast(ray,t,2000);
--                if ret then
--                    return fish;
--                end
--            end
        end
        fish = it();
    end
    return nil;
end

return _CPlayersControl;
