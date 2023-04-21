local CEventObject=GameRequire("EventObject");

local _CFishGroup = class("_CFishGroup",CEventObject);


function _CFishGroup:ctor(_fishCreator,_existTime)
    _CFishGroup.super.ctor(self);
    self._fishGroup = map:new();
    self._fishCreator = _fishCreator;
    self.fishMap    = map:new();
    self._existTime = _existTime or 9999999999; --����ʱ��
    self._isTimeOut = false;
    self._realStart = false;

    self._asyncCreateFish = false;
    self._asyncCreateCount= 0;
    self._fishGroupData   = nil;
end

--������
function _CFishGroup:CreateFish(_type,_id)
    local fish = self._fishCreator(_type,_id,nil,G_GlobalGame.Enum_FISH_FLAG.YC_Fish);
    fish:Init();
    return fish;
end

function _CFishGroup:Init(_parent,_fishGroupData)

end

function _CFishGroup:AsyncInit(_parent,_fishGroupData)
    self._asyncCreateFish = true;
    self._fishGroupData   = _fishGroupData;
    self._asyncCreateCount= 0;
end

--��ʽ��ʼ
function _CFishGroup:RealStart()
    self._realStart = true;
    self:AsyncCreateLeftFish();
    self._asyncCreateFish = false;
    self._fishGroupData   = nil;
    self.gameObject:SetActive(true);
end

function _CFishGroup:AsyncUpdate(_dt)
    self:AsyncCreateFish(_dt);
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
        --[[
        if self._fishMap:size()==0 then
            self._isTimeOut = true;
            --֪ͨ�㳱����
            self:SendEvent(LKPY_EventID.NotifyFishGroupOver);
            self:Destroy();
        end
        --]]
    end
end

function _CFishGroup:IsTimeOut()
    return self._isTimeOut;
end

--�㳱ʱ�䵽
function _CFishGroup:OnTimeOut()
    
end

function _CFishGroup:OnFishEvent(_eventId,_fish)
    local EventID = G_GlobalGame.Enum_EventID;
    if (_eventId==EventID.FishDead or _eventId == EventID.FishLeaveScreen or _eventId == EventID.FishDie) then
    else
        return;
    end
    if _eventId==EventID.FishDead then
        _fish:SetParentBySame(self.transform.parent);
    end
    if (_eventId==EventID.FishDead or _eventId == EventID.FishLeaveScreen)  then
        local _fishId = _fish:FishID();
        --ɾ����
        local _groupFish = self.fishMap:erase(_fishId);
        if _groupFish then
            self:OnFishDisappear(_groupFish,_fishId);
        end
    end
    if (_eventId==EventID.FishDie or _eventId == EventID.FishLeaveScreen)  then
        if self.fishMap:size()==0 then
            --֪ͨ�㳱����
            self:SendEvent(EventID.NotifyFishGroupOver);
            --self:Destroy();
        end   
    end
end

--����ʧ�����������д�ķ���
function _CFishGroup:OnFishDisappear(_fish,_fishId)

end

local _CGroupFish = class("_CGroupFish");

function _CGroupFish:ctor(_fishObj)
    self._fishObj   = _fishObj;
end 

function _CGroupFish:Fish()
    return self._fishObj;
end

function _CGroupFish:FishID()
    return self._fishObj:FishID();
end

local _CFish1 = class("_CFish1",_CGroupFish);

function _CFish1.Create(_fishObj,_groupIndex,_circle)
    local fish =_CFish1.New(_fishObj);
    fish:SetGroupIndex(_groupIndex);
    fish:SetCircle(_circle);
    return fish;
end

function _CFish1:ctor(_fishObj)
    _CFish1.super.ctor(self,_fishObj);
    
end

function _CFish1:SetCircle(_circle)
    self._circle    = _circle;
end

function _CFish1:SetGroupIndex(_groupIndex)
    self._groupIndex = _groupIndex;
end

function _CFish1:GroupIndex()
    return self._groupIndex;
end

function _CFish1:Circle()
    return self._circle;
end

function _CFish1:Fish()
    return self._fishObj;
end

local _CFishGroup1 = class("_CFishGroup1",_CFishGroup);

function _CFishGroup1:ctor(_fishCreator)
    _CFishGroup1.super.ctor(self,_fishCreator,25);
    self.rotation = {0,-30,-30,-30,-30};
    self.initRotation= {0,-90,-90,-90,-90};
    self.distance = {0,150,225,300,375};
    self.groups   = {};
    self.circleCount =0;
    self.bossFishMap = map:new();
    self.isLeave    = false;
    self.leaveIndex = 1;
    self.leaveTimeInterval = 0.5;
    self.leaveTime  = 0;
end

function _CFishGroup1:Init(_parent,_fishGroupData)
    self.gameObject = GameObject.New();
    self.gameObject.name = "FishGroup 1";
    self.transform  = self.gameObject.transform;
    self.transform:SetParent(_parent);
    self.transform.localScale = Vector3.New(0.7,0.7,0.7);
    self.transform.localPosition = Vector3.New(0,0,0);
    self.transform.localRotation= Quaternion.Euler(0,0,0);

    local gameObject;
    local transform ;

    local isRotation = G_GlobalGame:GetKeyValue(G_GlobalGame.Enum_KeyValue.GetSceneIsRotation);
    local needRotation = 0;
    local scale  = Vector3.New(1,1,1);
    if isRotation then
        needRotation = 0;
        scale.y = -1;
    end

    --��ߵ�ȦȦ
    self.groups[1] = {};
    gameObject = GameObject.New();
    transform = gameObject.transform;
    transform:SetParent(self.transform);
    transform.localScale = Vector3.New(1,1,1);
    transform.localPosition = Vector3.New(-450,0,0);
    transform.localRotation = Quaternion.Euler(0,0,0);
    gameObject.name = "CircleLeft";
    self.groups[1].transform = transform;
    self.groups[1].gameObject = gameObject;
    self.groups[1].circles  = {};

    --�ұߵ�ȦȦ
    self.groups[2] = {};
    gameObject = GameObject.New();
    transform = gameObject.transform;
    transform:SetParent(self.transform);
    transform.localScale = Vector3.New(-1,1,1);
    transform.localPosition = Vector3.New(450,0,0);
    transform.localRotation = Quaternion.Euler(0,0,0);
    gameObject.name = "CircleRight";
    self.groups[2].transform = transform;
    self.groups[2].gameObject = gameObject;
    self.groups[2].circles  = {};

    --ÿ�������ٸ�
    local everyCount = _fishGroupData.fishPartCount/2;
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
    local fish;

    self.circleCount = everyCount;

    for i=everyCount,1,-1 do
        r = self.distance[i];

        group = self.groups[1];
        circles = group.circles;
        circles[i]={};
        gameObject = GameObject.New();
        gameObject.name = "Circle" .. i;
        transform = gameObject.transform;
        transform:SetParent(group.transform);
        transform.localScale = Vector3.New(1,1,1);
        transform.localPosition = Vector3.New(0,0,0);
        transform.localRotation= Quaternion.Euler(0,0,0);
        circles[i].gameObject = gameObject;
        circles[i].transform  = transform;
        circles[i].fishMap    = map:new();

        initRotaion =self.initRotation[i];
        groupPart = _fishGroupData.fishGroupParts[i];
        angle = 360/groupPart.fishCount;
        hudu = 2 * math.pi / (groupPart.fishCount);
        for j=1,groupPart.fishCount do
            fishData = groupPart.fishes[j];
            fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
            angleIndex = j-1;
            x = r * math.cos(hudu * angleIndex);
            y = r * math.sin(hudu * angleIndex);
            fishObj:SetParent(transform);
            fishObj:SetLocalPosition(Vector3.New(x, y, 0));
            fishObj:SetLocalRotation(Quaternion.Euler(0,0,angle*angleIndex+initRotaion + needRotation));
            fishObj:SetLocalScale(fishObj:LocalScale():SetScale(scale));
            fishObj:RegEvent(self,self.OnFishEvent);
            fish = _CFish1.Create(fishObj,1,i);
            self.fishMap:insert(fishData.fishId,fish);
            if i==1 then
                self.bossFishMap:insert(fishData.fishId,fish);
            end
            circles[i].fishMap:insert(fishData.fishId,fish);
        end
        

        group = self.groups[2];
        circles = group.circles;
        circles[i]={};
        gameObject = GameObject.New();
        gameObject.name = "Circle" .. i;
        transform = gameObject.transform;
        transform:SetParent(group.transform);
        transform.localScale = Vector3.New(1,1,1);
        transform.localPosition = Vector3.New(0,0,0);
        transform.localRotation= Quaternion.Euler(0,0,0);
        circles[i].gameObject = gameObject;
        circles[i].transform  = transform;
        circles[i].fishMap    = map:new();

        groupPart = _fishGroupData.fishGroupParts[i+everyCount];
        angle = 360/groupPart.fishCount;
        hudu = 2 * math.pi / (groupPart.fishCount);

        for j=1,groupPart.fishCount do
            angleIndex = j-1;
            fishData = groupPart.fishes[j];
            fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
            x = r * math.cos(hudu * angleIndex);
            y = r * math.sin(hudu * angleIndex);
            fishObj:SetParent(transform);
            fishObj:SetLocalPosition(Vector3.New(x, y, 0));
            fishObj:SetLocalRotation(Quaternion.Euler(0,0,angle*angleIndex+initRotaion + needRotation));
            fishObj:SetLocalScale(fishObj:LocalScale():SetScale(scale));
            fishObj:RegEvent(self,self.OnFishEvent);
            fish = _CFish1.Create(fishObj,2,i);
            self.fishMap:insert(fishData.fishId,fish);
            if i==1 then
                self.bossFishMap:insert(fishData.fishId,fish);
            end
            circles[i].fishMap:insert(fishData.fishId,fish);
        end
    end
end

function _CFishGroup1:Update(_dt)
    _CFishGroup1.super.Update(self,_dt);
--    if self.isLeave then
--        --�뿪��
--        return ;
--    end
    if self.isLeave then
        if self.leaveIndex<=0 then 
            --û�п��뿪����
            return;
        end
        self.leaveTime = self.leaveTime - _dt;
        if self.leaveTime<0 then
            self.leaveTime = self.leaveTime + self.leaveTimeInterval;
            local group1 = self.groups[1];
            local group2 = self.groups[2];
            local circle1 ;
            local circle2;
            while(self.leaveIndex>0) do
                circle1 = group1.circles[self.leaveIndex];
                circle2 = group2.circles[self.leaveIndex];
                if circle1.fishMap:size()>0 or circle2.fishMap:size()>0 then
                    local it = circle1.fishMap:iter();
                    local val = it();
                    local fish 
                    --local size=self.fishMap:size();
                    --local index=52;
                    --local i=1;
                    while(val)  do
                        fish = circle1.fishMap:value(val);
                        if self.bossFishMap:value(fish:FishID()) then
                            fish:Fish():StraightMove(4);
                        else
                            fish:Fish():StraightMove(1);
                        end
                        val = it();
                    end
                    it = circle2.fishMap:iter();
                    val = it();
                    while(val)  do
                        fish = circle2.fishMap:value(val);
                        if self.bossFishMap:value(fish:FishID()) then
                            fish:Fish():StraightMove(4);
                        else
                            fish:Fish():StraightMove(1);
                        end
                        val = it();
                    end
                    self.leaveIndex = self.leaveIndex - 1;
                    break;
                else
                    self.leaveIndex = self.leaveIndex - 1;
                end
            end
        end

        local rotation 
        local group = nil;
        local cricle
        for i=1,self.leaveIndex do
            group = self.groups[1];
            circle =  group.circles[i];
            rotation =self.rotation[i]*_dt;
            circle.transform:Rotate(Vector3.New(0,0,rotation));

            group = self.groups[2];
            circle =  group.circles[i];
            rotation =self.rotation[i]*_dt;
            circle.transform:Rotate(Vector3.New(0,0,rotation));
        end
        return ;
    end

    if self:IsTimeOut() then
       return;
    end

    local rotation 
    local group = nil;
    local cricle
    for i=1,self.circleCount do
        group = self.groups[1];
        circle =  group.circles[i];
        rotation =self.rotation[i]*_dt;
        circle.transform:Rotate(Vector3.New(0,0,rotation));

        group = self.groups[2];
        circle =  group.circles[i];
        rotation =self.rotation[i]*_dt;
        circle.transform:Rotate(Vector3.New(0,0,rotation));
    end
    
end

--��ʱ
function _CFishGroup1:OnTimeOut()
    --[[
    local it = self.fishMap:iter();
    local val = it();
    local fish 
    --local size=self.fishMap:size();
    --local index=52;
    --local i=1;
    while(val)  do
        fish = self.fishMap:value(val);
        if self.bossFishMap:value(fish:FishID()) then
            fish:StraightMove(4);
        else
            fish:StraightMove(1);
        end
        --fish:StraightMove(1);
        val = it();
    end
    --]]
    --���ڱ��һȦһȦɢ����
    self.isLeave = true;
    self.leaveTime = self.leaveTimeInterval;
    self.leaveIndex  = self.circleCount;
end

function _CFishGroup1:OnFishDisappear(_fish,_fishId)
    local groupIndex = _fish:GroupIndex();
    local circleIndex= _fish:Circle();
    local group  = self.groups[groupIndex];
    local circle =group.circles[circleIndex];
    circle.fishMap:erase(_fishId);
end

local FishState = {
    WaitForMove     = 0, --�ȴ�����
    MoveToMid       = 1, --�ƶ��м�λ��
    WaitForMoveOut  = 2, --�ȴ��Ƴ���Ļ
    MoveOut         = 3, --�Ƴ���Ļ
};

local C_S_FishMid_Y = -200;

local _CFishGroup2SmallFish = class("_CFishGroup2SmallFish");

function _CFishGroup2SmallFish:ctor(_fish,_waitTime)
    self._fish = _fish;
    self._waitTime = _waitTime;
    self._fishState= FishState.WaitForMove;
    self._midY     = C_S_FishMid_Y;
    self._moveSpeed = 180;
    --self._moveSpeed = 300;
    self._beginPos = nil;
    self._moveTime = 0;
end

function _CFishGroup2SmallFish:Update(_dt)
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
        self._fish:SetLocalPosition(Vector3.New(endX,endY,0));
    elseif self._fishState == FishState.WaitForMoveOut then
        --�ȴ��Ƴ���Ļ��ʲôҲ����
    elseif self._fishState == FishState.MoveOut then
        --�����Ƴ���Ļ
        self._moveTime = self._moveTime + _dt;
        local y = self._moveSpeed * self._moveTime;
        local endY = self._beginPos.y + y;
        local endX = self._beginPos.x;
        self._fish:SetLocalPosition(Vector3.New(endX,endY,0));
    end
end

--�뿪��Ļ
function _CFishGroup2SmallFish:FishLeaveScreen()
    if self._fishState == FishState.WaitForMoveOut then
        self._moveTime = 0;
        self._moveSpeed  = 75;
        self._fishState = FishState.MoveOut;
        self._beginPos = self._fish:LocalPosition();
    end
end

local _CFishGroup2BossFish = class("_CFishGroup2BossFish");

function _CFishGroup2BossFish:ctor(_fish,_toward)
    self._fish = _fish;
end



local _CFishGroup2 = class("_CFishGroup2",_CFishGroup);

function _CFishGroup2:ctor(_fishCreator)
    _CFishGroup2.super.ctor(self,_fishCreator);

    self.groups   = {};

    --С��Ⱥ
    self._smallFishGroups = map:new();

    self._bossFishGroups = {};
    self._bossFishGroups[1] = {};
    self._bossFishGroups[2] = {};
    
    --��ʼ�ƶ���λ��
    self._smallFishMoveBeginY = C_S_FishMid_Y - 350;

    --������Ⱥ�ķ�ʽ�ƶ�
    self._groupMinCount  = 3;
    self._groupMaxCount  = 10;

    --��Ⱥ����
    self._maxWaitTime    = 3.5;
    --self._maxWaitTime    = 1;
    self._groupWaitTime  = 0.6;

    --boss��Ⱥ
    self._bossFishMap  = map:new();

    --ˮƽ�ƶ��ȴ�ʱ��
    self._horizontalWaitTime  = 8;
    --self._horizontalWaitTime  = 3;
    --ˮƽ�ƶ��ٶ�
    self._horizontalMoveSpeed = 100;
    --self._horizontalMoveSpeed = 800;
    --ˮƽ�ƶ����
    self._horizontalMoveTime  = 13;
    --�Ѿ��ƶ��˶��
    self._horizontalHaveMoveTime =0;
    --ˮƽ����
    self._horizontalDistances = {250,250,250,350,350,450};
    --�Ƿ�ʼ�ƶ�ˮƽ��
    self._isMoveHorizontal  = false;
    --ˮƽ��Y����
    self._horizontalY     = C_S_FishMid_Y + 100;
end

--�㳱2
function _CFishGroup2:Init(_parent,_fishGroupData)
    self.gameObject = GameObject.New();
    self.gameObject.name = "FishGroup 2";
    self.transform  = self.gameObject.transform;
    self.transform:SetParent(_parent);
    self.transform.localScale = Vector3.New(1,1,1);
    self.transform.localPosition = Vector3.New(0,0,0);
    self.transform.localRotation= Quaternion.Euler(0,0,0);

    --���϶��µ���
    self.groups[1] = {};
    gameObject = GameObject.New();
    transform = gameObject.transform;
    transform:SetParent(self.transform);
    transform.localScale = Vector3.New(1,1,1);
    transform.localPosition = Vector3.New(0,0,0);
    transform.localRotation = Quaternion.Euler(0,0,180);
    gameObject.name = "FromUp";
    self.groups[1].transform = transform;
    self.groups[1].gameObject = gameObject;
    self.groups[1].circles  = {};

    --���¶��ϵ���
    self.groups[2] = {};
    gameObject = GameObject.New();
    transform = gameObject.transform;
    transform:SetParent(self.transform);
    transform.localScale = Vector3.New(1,1,1);
    transform.localPosition = Vector3.New(0,0,0);
    transform.localRotation = Quaternion.Euler(0,0,0);
    gameObject.name = "FromDown";
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

    local width = G_GlobalGame:GetKeyValue(G_GlobalGame.Enum_KeyValue.GetScenePixelSize);

    group = self.groups[1];
    gameObject = GameObject.New();
    gameObject.name = "SmallFish Group 1";
    transform = gameObject.transform;
    transform:SetParent(group.transform);
    transform.localScale = Vector3.New(1,1,1);
    transform.localPosition = Vector3.New(0,0,0);
    transform.localRotation = Quaternion.Euler(0,0,0);

    groupPart = _fishGroupData.fishGroupParts[2];

    dis = width/groupPart.fishCount;
    beginX  = -width/2;
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
        smallFishItem = _CFishGroup2SmallFish.New(fishObj,waitTime/100);
        --�����б�
        self._smallFishGroups:insert(fishData.fishId,smallFishItem);
        x = x + dis;
        fishObj:SetParent(transform);
        fishObj:SetLocalPosition(Vector3.New(x, y, 0));
        fishObj:SetLocalRotation(Quaternion.Euler(0,0,90));
        self.fishMap:insert(fishData.fishId,fishObj);
        fishObj:RegEvent(self,self.OnFishEvent);
    end

    group = self.groups[2];
    gameObject = GameObject.New();
    gameObject.name = "SmallFish Group 2";
    transform = gameObject.transform;
    transform:SetParent(group.transform);
    transform.localScale = Vector3.New(1,1,1);
    transform.localPosition = Vector3.New(0,0,0);
    transform.localRotation = Quaternion.Euler(0,0,0);

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
        smallFishItem = _CFishGroup2SmallFish.New(fishObj,waitTime/100);
        --�����б�
        self._smallFishGroups:insert(fishData.fishId,smallFishItem);
        x = x + dis;
        fishObj:SetParent(transform);
        fishObj:SetLocalPosition(Vector3.New(x, y, 0));
        fishObj:SetLocalRotation(Quaternion.Euler(0,0,90));
        self.fishMap:insert(fishData.fishId,fishObj);
        fishObj:RegEvent(self,self.OnFishEvent);
    end
    
    --boss��
    group = self.groups[1];
    gameObject = GameObject.New();
    gameObject.name = "BossFish Group 1";
    transform = gameObject.transform;
    transform:SetParent(group.transform);
    transform.localScale = Vector3.New(1,1,1);
    transform.localPosition = Vector3.New(0,0,0);
    transform.localRotation = Quaternion.Euler(0,0,0);
    self._bossFishGroups[1].transform = transform;
    self._bossFishGroups[1].gameObject = gameObject;

    groupPart = _fishGroupData.fishGroupParts[1];
    beginX  = - width/2 - 300;
    x = beginX;
    y = self._horizontalY;

    for j=1,groupPart.fishCount do
        fishData = groupPart.fishes[j];
        fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
        x = x - self._horizontalDistances[j];
        fishObj:SetParent(transform);
        fishObj:SetLocalPosition(Vector3.New(x, y, 0));
        fishObj:SetLocalRotation(Quaternion.Euler(0,0,0));
        self.fishMap:insert(fishData.fishId,fishObj);
        fishObj:RegEvent(self,self.OnFishEvent);  
        self._bossFishMap:insert(fishData.fishId,fishObj);  
    end


    group = self.groups[2];
    gameObject = GameObject.New();
    gameObject.name = "BossFish Group 2";
    transform = gameObject.transform;
    transform:SetParent(group.transform);
    transform.localScale = Vector3.New(1,1,1);
    transform.localPosition = Vector3.New(0,0,0);
    transform.localRotation = Quaternion.Euler(0,0,0);
    self._bossFishGroups[2].transform = transform;
    self._bossFishGroups[2].gameObject = gameObject;

    groupPart = _fishGroupData.fishGroupParts[3];
    beginX  = - width/2 - 300;
    x = beginX;
    y = self._horizontalY;

    for j=1,groupPart.fishCount do
        fishData = groupPart.fishes[j];
        fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
        x = x - self._horizontalDistances[j];
        fishObj:SetParent(transform);
        fishObj:SetLocalPosition(Vector3.New(x, y, 0));
        fishObj:SetLocalRotation(Quaternion.Euler(0,0,0));
        self.fishMap:insert(fishData.fishId,fishObj);
        fishObj:RegEvent(self,self.OnFishEvent);    
        self._bossFishMap:insert(fishData.fishId,fishObj);     
    end
end

--ÿִ֡��
function _CFishGroup2:Update(_dt)
    --_CFishGroup2.super.Update(self,_dt);
    if self:IsTimeOut() then
        return;
    end
    local it = self._smallFishGroups:iter();
    local val = it();
    local smallFish;
    while(val) do
        smallFish = self._smallFishGroups:value(val);
        smallFish:Update(_dt);
        val =it();
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
                self._bossFishGroups[1].transform.localPosition =Vector3.New(x,0,0);
                self._bossFishGroups[2].transform.localPosition =Vector3.New(x,0,0);
            end

        end
    else
        self._horizontalHaveMoveTime = self._horizontalHaveMoveTime + _dt;
        if self._horizontalHaveMoveTime>0 then
            local x = self._horizontalMoveSpeed*self._horizontalHaveMoveTime;
            self._bossFishGroups[1].transform.localPosition =Vector3.New(x,0,0);
            self._bossFishGroups[2].transform.localPosition =Vector3.New(x,0,0);
        end 
    end

end

--����ʧ
function _CFishGroup2:OnFishDisappear(_fish,_fishId)
    self._smallFishGroups:erase(_fishId);
    if self._bossFishMap:size()>0 then
        self._bossFishMap:erase(_fishId);
        if self._bossFishMap:size()==0 then
            --boss�㶼��ʧ�ˣ���������
            local it = self._smallFishGroups:iter();
            local val = it();
            local smallFish;
            while(val) do
                smallFish = self._smallFishGroups:value(val);
                smallFish:FishLeaveScreen();
                val =it();
            end
        end
    end
end

local _CFishGroup3 = class("_CFishGroup3",_CFishGroup);

function _CFishGroup3:ctor(_fishCreator)
    _CFishGroup3.super.ctor(self,_fishCreator,30);
    self.distance = {0,150,225,300,375};
    self.groups   = {};
    self.circleCount =0;
    self.moveSpeed = 30;
    self.moveTime  = 0;
end

function _CFishGroup3:Init(_parent,_fishGroupData)
    self.gameObject = GameObject.New();
    self.gameObject.name = "FishGroup 3";
    self.transform  = self.gameObject.transform;
    self.transform:SetParent(_parent);
    self.transform.localScale = Vector3.New(1,1,1);
    self.transform.localPosition = Vector3.New(0,0,0);
    self.transform.localRotation= Quaternion.Euler(0,0,0);

    local gameObject;
    local transform ;

    local width = G_GlobalGame:GetKeyValue(G_GlobalGame.Enum_KeyValue.GetScenePixelSize);
    local isRotation = G_GlobalGame:GetKeyValue(G_GlobalGame.Enum_KeyValue.GetSceneIsRotation);
    width = width + 800;

    --��ߵ�ȦȦ
    self.groups[1] = {};
    gameObject = GameObject.New();
    transform = gameObject.transform;
    transform:SetParent(self.transform);
    transform.localScale = Vector3.New(1,1,1);
    transform.localPosition = Vector3.New(-width/2,0,0);
    transform.localRotation = Quaternion.Euler(0,0,0);
    gameObject.name = "CircleLeft";
    self.groups[1].transform = transform;
    self.groups[1].gameObject = gameObject;
    self.groups[1].localPosition = transform.localPosition;
    self.groups[1].circles  = {};

    --�ұߵ�ȦȦ
    self.groups[2] = {};
    gameObject = GameObject.New();
    transform = gameObject.transform;
    transform:SetParent(self.transform);
    transform.localScale = Vector3.New(-1,1,1);
    transform.localPosition = Vector3.New(width/2,0,0);
    transform.localRotation = Quaternion.Euler(0,0,0);
    gameObject.name = "CircleRight";
    self.groups[2].transform = transform;
    self.groups[2].gameObject = gameObject;
    self.groups[2].localPosition = transform.localPosition;
    self.groups[2].circles  = {};

    --ÿ�������ٸ�
    local everyCount = _fishGroupData.fishPartCount/2;
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
    local needScale = Vector3.New(1,1,1);
    if isRotation then
        --rotation = 180;
        needScale.y = -1;
    else
    end

    self.circleCount = everyCount;

    for i=everyCount,1,-1 do
        r = self.distance[i];

        group = self.groups[1];
        circles = group.circles;
        circles[i]={};
        gameObject = GameObject.New();
        gameObject.name = "Circle" .. i;
        transform = gameObject.transform;
        transform:SetParent(group.transform);
        transform.localScale = Vector3.New(1,1,1);
        transform.localPosition = Vector3.New(0,0,0);
        transform.localRotation= Quaternion.Euler(0,0,0);
        circles[i].gameObject = gameObject;
        circles[i].transform  = transform;

        groupPart = _fishGroupData.fishGroupParts[i];
        angle = 360/groupPart.fishCount;
        hudu = 2 * math.pi / (groupPart.fishCount);
        for j=1,groupPart.fishCount do
            fishData = groupPart.fishes[j];
            fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
            angleIndex = j-1;
            x = r * math.cos(hudu * angleIndex);
            y = r * math.sin(hudu * angleIndex);
            fishObj:SetParent(transform);
            fishObj:SetLocalPosition(Vector3.New(x, y, 0));
            fishObj:SetLocalRotation(Quaternion.Euler(0,0,0));
            fishObj:SetLocalScale(fishObj:LocalScale():SetScale(needScale));
            self.fishMap:insert(fishData.fishId,fishObj);
            fishObj:RegEvent(self,self.OnFishEvent);
        end
        

        group = self.groups[2];
        circles = group.circles;
        circles[i]={};
        gameObject = GameObject.New();
        gameObject.name = "Circle" .. i;
        transform = gameObject.transform;
        transform:SetParent(group.transform);
        transform.localScale = Vector3.New(1,1,1);
        transform.localPosition = Vector3.New(0,0,0);
        transform.localRotation= Quaternion.Euler(0,0,0);
        circles[i].gameObject = gameObject;
        circles[i].transform  = transform;

        groupPart = _fishGroupData.fishGroupParts[i+everyCount];
        angle = 360/groupPart.fishCount;
        hudu = 2 * math.pi / (groupPart.fishCount);

        for j=1,groupPart.fishCount do
            angleIndex = j-1;
            fishData = groupPart.fishes[j];
            fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
            x = r * math.cos(hudu * angleIndex);
            y = r * math.sin(hudu * angleIndex);
            fishObj:SetParent(transform);
            fishObj:SetLocalPosition(Vector3.New(x, y, 0));
            fishObj:SetLocalRotation(Quaternion.Euler(0,0,0));
            fishObj:SetLocalScale(fishObj:LocalScale():SetScale(needScale));
            self.fishMap:insert(fishData.fishId,fishObj);
            fishObj:RegEvent(self,self.OnFishEvent);
        end
    end
end

function _CFishGroup3:Update(_dt)
    self.moveTime = self.moveTime + _dt;
    local moveX = self.moveTime* self.moveSpeed;
    self.groups[1].transform.localPosition = self.groups[1].localPosition + Vector3.New(moveX,0,0);
    self.groups[2].transform.localPosition = self.groups[2].localPosition - Vector3.New(moveX,0,0);
end


local _CFish4 = class("_CFish4",_CGroupFish);

function _CFish4.Create(_fishObj,_circle)
    local fish =_CFish4.New(_fishObj);
    fish:SetCircle(_circle);
    return fish;
end

function _CFish4:ctor(_fishObj)
    _CFish4.super.ctor(self,_fishObj);
    
end

function _CFish4:SetCircle(_circle)
    self._circle    = _circle;
end

function _CFish4:Circle()
    return self._circle;
end

function _CFish4:Fish()
    return self._fishObj;
end


local _CFishGroup4 = class("_CFishGroup4",_CFishGroup);

function _CFishGroup4:ctor(_fishCreator)
    _CFishGroup4.super.ctor(self,_fishCreator,30);
    self.rotation = {0,-30,-30,-30,-30};
    self.initRotation= {0,90,-90,90,-90};
    self.distance = {0,150,225,300,375};
    self.groups   = {};
    self.circleCount =0;
    self.moveSpeed = 80;
    self.moveTime  = 0;
    self.bossFishMap = map:new();

    self.isLeave    = false;
    self.leaveIndex = 1;
    self.leaveTimeInterval = 0.5;
    self.leaveTime  = 0;
end

function _CFishGroup4:Init(_parent,_fishGroupData)
    self.gameObject = GameObject.New();
    self.gameObject.name = "FishGroup 4";
    self.transform  = self.gameObject.transform;
    self.transform:SetParent(_parent);
    self.transform.localScale = Vector3.New(0.9,0.9,0.9);
    self.transform.localPosition = Vector3.New(0,0,0);
    self.transform.localRotation= Quaternion.Euler(0,0,0);

    local gameObject;
    local transform ;

    local isRotation = G_GlobalGame:GetKeyValue(G_GlobalGame.Enum_KeyValue.GetSceneIsRotation);

    local needScale = Vector3.New(1,1,1);
    if isRotation then
        --rotation = 180;
        needScale.y = -1;
    end

    --�м��ȦȦ
    self.groups[1] = {};
    gameObject = GameObject.New();
    transform = gameObject.transform;
    transform:SetParent(self.transform);
    transform.localScale = Vector3.New(1,1,1);
    transform.localPosition = Vector3.New(0,0,0);
    transform.localRotation = Quaternion.Euler(0,0,0);
    gameObject.name = "CircleMid";
    self.groups[1].transform = transform;
    self.groups[1].gameObject = gameObject;
    self.groups[1].localPosition = transform.localPosition;
    self.groups[1].circles  = {};

    --ÿ�������ٸ�
    local everyCount = _fishGroupData.fishPartCount;
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

    self.circleCount = everyCount;

    for i=everyCount,1,-1 do
        r = self.distance[i];

        group = self.groups[1];
        circles = group.circles;
        circles[i]={};
        gameObject = GameObject.New();
        gameObject.name = "Circle" .. i;
        transform = gameObject.transform;
        transform:SetParent(group.transform);
        transform.localScale = Vector3.New(1,1,1);
        transform.localPosition = Vector3.New(0,0,0);
        transform.localRotation= Quaternion.Euler(0,0,0);
        circles[i].gameObject = gameObject;
        circles[i].transform  = transform;
        circles[i].fishMap    = map:new();

        initRotaion =self.initRotation[i];
        groupPart = _fishGroupData.fishGroupParts[i];
        angle = 360/groupPart.fishCount;
        hudu = 2 * math.pi / (groupPart.fishCount);
        for j=1,groupPart.fishCount do
            fishData = groupPart.fishes[j];
            fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
            angleIndex = j-1;
            x = r * math.cos(hudu * angleIndex);
            y = r * math.sin(hudu * angleIndex);
            fishObj:SetParent(transform);
            fishObj:SetLocalPosition(Vector3.New(x, y, 0));
            fishObj:SetLocalRotation(Quaternion.Euler(0,0,angle*angleIndex+initRotaion));
            fishObj:SetLocalScale(fishObj:LocalScale():SetScale(needScale));
            fishObj:RegEvent(self,self.OnFishEvent);
            fish = _CFish4.Create(fishObj,i);
            self.fishMap:insert(fishData.fishId,fish);
            if i==1 then
                self.bossFishMap:insert(fishData.fishId,fish);
            end
            circles[i].fishMap:insert(fishData.fishId,fish);
        end

    end
end


--��ʱ
function _CFishGroup4:OnTimeOut()
    --[[
    local it = self.fishMap:iter();
    local val = it();
    local fish 
    --local size=self.fishMap:size();
    --local index=52;
    --local i=1;
    while(val)  do
        fish = self.fishMap:value(val);
        if self.bossFishMap:value(fish:FishID()) then
            fish:StraightMove(3);
        else
            fish:StraightMove(1);
        end
        --fish:StraightMove(1);
        val = it();
    end
    --]]

    self.isLeave    = true;
    self.leaveIndex = self.circleCount;
    self.leaveTime  = self.leaveTimeInterval;
end

function _CFishGroup4:Update(_dt)
    _CFishGroup4.super.Update(self,_dt);

    if self.isLeave then
        if self.leaveIndex<=0 then 
            --û�п��뿪����
            return;
        end
        self.leaveTime = self.leaveTime - _dt;
        if self.leaveTime<0 then
            self.leaveTime = self.leaveTime + self.leaveTimeInterval;
            local group1 = self.groups[1];
            local circle1 ;
            local circle2;
            while(self.leaveIndex>0) do
                circle1 = group1.circles[self.leaveIndex];
                if circle1.fishMap:size()>0 then
                    local it = circle1.fishMap:iter();
                    local val = it();
                    local fish;
                    while(val)  do
                        fish = circle1.fishMap:value(val);
                        if self.bossFishMap:value(fish:FishID()) then
                            fish:Fish():StraightMove(4);
                        else
                            fish:Fish():StraightMove(1);
                        end
                        val = it();
                    end
                    self.leaveIndex = self.leaveIndex - 1;
                    break;
                else
                    self.leaveIndex = self.leaveIndex - 1;
                end
            end
        end

        local rotation 
        local group = nil;
        local cricle;
        local toward = 1;
        for i=1,self.leaveIndex do
            group = self.groups[1];
            circle =  group.circles[i];
            rotation =self.rotation[i]*_dt;
            circle.transform:Rotate(Vector3.New(0,0,rotation*toward));
            toward = toward==1 and -1 or 1;
        end
        return ;
    end

    if self:IsTimeOut() then
       return;
    end

    local rotation 
    local group = nil;
    local cricle
    local toward = 1;
    for i=1,self.circleCount do
        group = self.groups[1];
        circle =  group.circles[i];
        rotation =self.rotation[i]*_dt;
        circle.transform:Rotate(Vector3.New(0,0,rotation*toward));
        toward = toward==1 and -1 or 1;
    end
end

function _CFishGroup4:OnFishDisappear(_fish,_fishId)
    local circleIndex= _fish:Circle();
    local group  = self.groups[1];
    local circle =group.circles[circleIndex];
    circle.fishMap:erase(_fishId);
end

local _CFishGroup1Ex = class("_CFishGroup1Ex",_CFishGroup);

--�㳱1
function _CFishGroup1Ex:ctor(_fishCreator)
    _CFishGroup1Ex.super.ctor(self,_fishCreator,40);
    self._moveBeginDis = 800;
    self._movePadding = 120;
    self._moveSpeed    = 100;
    self._innerPaddingX = {0,210,210,250,260,260,260,260,260,260,260,260,260,260,260,260,260,260,260,260};

    --�ٶ�
    self._speeds   = {
                        Vector3.New(self._moveSpeed,0,0),
                        Vector3.New(0,self._moveSpeed,0),
                        Vector3.New(-self._moveSpeed,0,0),
                        Vector3.New(0,-self._moveSpeed,0),
                        };

    --��ʼλ��
    self._beginPoses  = {
                    Vector3.New(-self._moveBeginDis,-self._movePadding,0),
                    Vector3.New(-self._movePadding,-self._moveBeginDis,0),
                    Vector3.New(self._moveBeginDis,self._movePadding,0),
                    Vector3.New(self._movePadding,self._moveBeginDis,0),
                    };

    --��ת
    self._rotation    = {
                    Quaternion.Euler(0,0,0),
                    Quaternion.Euler(0,0,90),
                    Quaternion.Euler(0,0,180),
                    Quaternion.Euler(0,0,270),   
                    };
end


function _CFishGroup1Ex:Init(_parent,_fishGroupData)
    self.gameObject = GameObject.New();
    self.gameObject.name = "FishGroup 1 && 3";
    self.transform  = self.gameObject.transform;
    self.transform:SetParent(_parent);
    self.transform.localScale = Vector3.New(1,1,1);
    self.transform.localPosition = Vector3.New(0,0,0);
    self.transform.localRotation= Quaternion.Euler(0,0,0);

    local lineCount = 4;
    local everyCount = math.floor(_fishGroupData.fishPartCount/lineCount);
    self.lines = {};
    self.lineCount = lineCount;
    local line;
    local groupPart;
    local fishCount;
    local groupPartIndex;
    local groupPartBeginIndex;
    local fishIndex;
    local x,y;
    local fishObj,fishData;
    local transform;
    for i=1,lineCount do
        line = {};
        self.lines[i] = line;
        line.gameObject = GameObject.New();
        line.transform  = line.gameObject.transform;
        line.fishMap    = map:new();
        line.transform:SetParent(self.transform);
        line.transform.localScale = Vector3.New(1,1,1);
        --line.transform.localPosition = Vector3.New(0,0,0);
        line.transform.localPosition = self._beginPoses[i];
        --line.transform.localRotation= Quaternion.Euler(0,0,0);
        line.transform.localRotation  = self._rotation[i];
        transform = line.transform;
        line.runTime = 0;
        line.speed  = self._speeds[i];
        line.beginPos = self._beginPoses[i];

        groupPartBeginIndex = (i-1)*everyCount;
        fishIndex  = 1;

        x = 0;
        y = 0;
        for j=1,everyCount do
            groupPartIndex = groupPartBeginIndex + j;
            groupPart = _fishGroupData.fishGroupParts[groupPartIndex];
            fishCount = groupPart.fishCount;
            for k=1,fishCount do  --���е���
                x = x - self._innerPaddingX[fishIndex];
                fishData = groupPart.fishes[k];
                fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
                fishObj:SetParent(transform);
                fishObj:SetLocalPosition(Vector3.New(x, y, 0));
                fishObj:SetLocalRotation(Quaternion.Euler(0,0,0));
                fishObj:SetLocalScale(Vector3.New(1,1,1));
                --fishObj:SetLocalScale(fishObj:LocalScale():SetScale(needScale));
                fishObj:RegEvent(self,self.OnFishEvent);
                self.fishMap:insert(fishData.fishId,fishObj);
                fishIndex = fishIndex + 1;
            end
        end
    end
end


function _CFishGroup1Ex:AsyncInit(_parent,_fishGroupData)
    _CFishGroup1Ex.super.AsyncInit(self,_parent,_fishGroupData);

    self.gameObject = GameObject.New();
    self.gameObject.name = "FishGroup 1 && 3";
    self.transform  = self.gameObject.transform;
    self.transform:SetParent(_parent);
    self.transform.localScale = Vector3.New(1,1,1);
    self.transform.localPosition = Vector3.New(0,0,0);
    self.transform.localRotation= Quaternion.Euler(0,0,0);

    local gameObject;
    local transform ;

    local lineCount = 4;
    local everyCount = math.floor(_fishGroupData.fishPartCount/lineCount);
    local line;
    self.lines = {};
    self.lineCount = lineCount;

    for i=1,lineCount do
        line = {};
        self.lines[i] = line;
        line.gameObject = GameObject.New();
        line.transform  = line.gameObject.transform;
        line.fishMap    = map:new();
        line.transform:SetParent(self.transform);
        line.transform.localScale = Vector3.New(1,1,1);
        line.transform.localPosition = self._beginPoses[i];
        line.transform.localRotation  = self._rotation[i];
        transform = line.transform;
        line.runTime = 0;
        line.speed  = self._speeds[i];
        line.beginPos = self._beginPoses[i];
    end

    --������
    self.gameObject:SetActive(false);
end

function _CFishGroup1Ex:AsyncCreateFish(_dt)
    if not self._asyncCreateFish then
        return ;
    end
    local gameObject;
    local transform ;
    local lineCount=4;
    local _fishGroupData = self._fishGroupData;

    
    local needCreateCount = 6;
    local createFishCount = self._asyncCreateCount;
    --�ܵĴ�������
    self._asyncCreateCount = self._asyncCreateCount + needCreateCount;

    local everyCount = math.floor(_fishGroupData.fishPartCount/lineCount);

    for i=1,lineCount do
        line = self.lines[i];
        transform = line.transform;

        groupPartBeginIndex = (i-1)*everyCount;
        fishIndex  = 1;

        x = 0;
        y = 0;
        for j=1,everyCount do
            groupPartIndex = groupPartBeginIndex + j;
            groupPart = _fishGroupData.fishGroupParts[groupPartIndex];
            fishCount = groupPart.fishCount;
            for k=1,fishCount do  --���е���
                x = x - self._innerPaddingX[fishIndex];
                if createFishCount>0 then
                    createFishCount = createFishCount - 1;
                else
                    if needCreateCount>0 then
                        needCreateCount = needCreateCount -1;
                        fishData = groupPart.fishes[k];
                        fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
                        fishObj:SetParent(transform);
                        fishObj:SetLocalPosition(Vector3.New(x, y, 0));
                        fishObj:SetLocalRotation(Quaternion.Euler(0,0,0));
                        fishObj:SetLocalScale(Vector3.New(1,1,1));
                        --fishObj:SetLocalScale(fishObj:LocalScale():SetScale(needScale));
                        fishObj:RegEvent(self,self.OnFishEvent);
                        self.fishMap:insert(fishData.fishId,fishObj);
                    else
                        return ;
                    end                    
                end
                fishIndex = fishIndex + 1;
            end
        end
    end
    self._asyncCreateFish = false;
end

--��������ʣ���
function _CFishGroup1Ex:AsyncCreateLeftFish()
    if not self._asyncCreateFish then
        return ;
    end
    local gameObject;
    local transform ;
    local lineCount=4;
    local _fishGroupData = self._fishGroupData;

    
    local needCreateCount = 9999;
    local createFishCount = self._asyncCreateCount;
    --�ܵĴ�������
    self._asyncCreateCount = self._asyncCreateCount + needCreateCount;

    local everyCount = math.floor(_fishGroupData.fishPartCount/lineCount);

    for i=1,lineCount do
        line = self.lines[i];
        transform = line.transform;

        groupPartBeginIndex = (i-1)*everyCount;
        fishIndex  = 1;

        x = 0;
        y = 0;
        for j=1,everyCount do
            groupPartIndex = groupPartBeginIndex + j;
            groupPart = _fishGroupData.fishGroupParts[groupPartIndex];
            fishCount = groupPart.fishCount;
            for k=1,fishCount do  --���е���
                x = x - self._innerPaddingX[fishIndex];
                if createFishCount>0 then
                    createFishCount = createFishCount - 1;
                else
                    if needCreateCount>0 then
                        needCreateCount = needCreateCount -1;
                        fishData = groupPart.fishes[k];
                        fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
                        fishObj:SetParent(transform);
                        fishObj:SetLocalPosition(Vector3.New(x, y, 0));
                        fishObj:SetLocalRotation(Quaternion.Euler(0,0,0));
                        fishObj:SetLocalScale(Vector3.New(1,1,1));
                        --fishObj:SetLocalScale(fishObj:LocalScale():SetScale(needScale));
                        fishObj:RegEvent(self,self.OnFishEvent);
                        self.fishMap:insert(fishData.fishId,fishObj);
                    else
                        return ;
                    end                    
                end
                fishIndex = fishIndex + 1;
            end
        end
    end
    self._asyncCreateFish = false;
end

function _CFishGroup1Ex:Update(_dt)
    --�ƶ�
    local line;
    for i=1,self.lineCount do
        line = self.lines[i];
        line.runTime =  line.runTime + _dt;
        line.transform.localPosition = line.beginPos + line.speed * line.runTime;
    end
end

function _CFishGroup1Ex:OnFishDisappear(_fish,_fishId)

end

--��ʱ
function _CFishGroup1Ex:OnTimeOut()

end


local _CFishGroup2Ex = class("_CFishGroup2Ex",_CFishGroup);

--�㳱2
function _CFishGroup2Ex:ctor(_fishCreator)
    _CFishGroup2Ex.super.ctor(self,_fishCreator);
    self._moveBeginDis = 800;
    self._movePadding = 120;
    self._moveSpeed    = 100;
    self._innerPaddingX = {0,240,240,230,230,220,200,200,220,260,260,260,320,320,480,480,360};

    --�ٶ�
    self._speeds   = {
                        Vector3.New(self._moveSpeed,0,0),
                        Vector3.New(-self._moveSpeed,0,0),
                        };

    --��ʼλ��
    self._beginPoses  = {
                    Vector3.New(-self._moveBeginDis,-self._movePadding,0),
                    Vector3.New(self._moveBeginDis,self._movePadding,0),
                    };

    --��ת
    self._rotation    = {
                    Quaternion.Euler(0,0,0),
                    Quaternion.Euler(0,0,180),   
                    };

end


function _CFishGroup2Ex:Init(_parent,_fishGroupData)
    self.gameObject = GameObject.New();
    self.gameObject.name = "FishGroup 2";
    self.transform  = self.gameObject.transform;
    self.transform:SetParent(_parent);
    self.transform.localScale = Vector3.New(1,1,1);
    self.transform.localPosition = Vector3.New(0,0,0);
    self.transform.localRotation= Quaternion.Euler(0,0,0);

    local lineCount = 2;
    local everyCount = math.floor(_fishGroupData.fishPartCount/lineCount);
    self.lines = {};
    self.lineCount = lineCount;
    local line;
    local groupPart;
    local fishCount;
    local groupPartIndex;
    local groupPartBeginIndex;
    local fishIndex;
    local x,y;
    local fishObj,fishData;
    local transform;
    for i=1,lineCount do
        line = {};
        self.lines[i] = line;
        line.gameObject = GameObject.New();
        line.transform  = line.gameObject.transform;
        line.fishMap    = map:new();
        line.transform:SetParent(self.transform);
        line.transform.localScale = Vector3.New(1,1,1);
        --line.transform.localPosition = Vector3.New(0,0,0);
        line.transform.localPosition = self._beginPoses[i];
        --line.transform.localRotation= Quaternion.Euler(0,0,0);
        line.transform.localRotation  = self._rotation[i];
        transform = line.transform;
        line.runTime = 0;
        line.speed  = self._speeds[i];
        line.beginPos = self._beginPoses[i];

        groupPartBeginIndex = (i-1)*everyCount;
        fishIndex  = 1;

        x = 0;
        y = 0;
        for j=1,everyCount do
            groupPartIndex = groupPartBeginIndex + j;
            groupPart = _fishGroupData.fishGroupParts[groupPartIndex];
            fishCount = groupPart.fishCount;
            for k=1,fishCount do  --���е���
                x = x - self._innerPaddingX[fishIndex];
                fishData = groupPart.fishes[k];
                fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
                fishObj:SetParent(transform);
                fishObj:SetLocalPosition(Vector3.New(x, y, 0));
                fishObj:SetLocalRotation(Quaternion.Euler(0,0,0));
                fishObj:SetLocalScale(Vector3.New(1,1,1));
                --fishObj:SetLocalScale(fishObj:LocalScale():SetScale(needScale));
                fishObj:RegEvent(self,self.OnFishEvent);
                self.fishMap:insert(fishData.fishId,fishObj);
                fishIndex = fishIndex + 1;
            end
        end
    end

end


function _CFishGroup2Ex:AsyncInit(_parent,_fishGroupData)
    _CFishGroup2Ex.super.AsyncInit(self,_parent,_fishGroupData);

    self.gameObject = GameObject.New();
    self.gameObject.name = "FishGroup 2";
    self.transform  = self.gameObject.transform;
    self.transform:SetParent(_parent);
    self.transform.localScale = Vector3.New(1,1,1);
    self.transform.localPosition = Vector3.New(0,0,0);
    self.transform.localRotation= Quaternion.Euler(0,0,0);

    local gameObject;
    local transform ;

    local lineCount = 2;
    local everyCount = math.floor(_fishGroupData.fishPartCount/lineCount);
    self.lines = {};
    self.lineCount = lineCount;
    local line;
    for i=1,lineCount do
        line = {};
        self.lines[i] = line;
        line.gameObject = GameObject.New();
        line.transform  = line.gameObject.transform;
        line.fishMap    = map:new();
        line.transform:SetParent(self.transform);
        line.transform.localScale = Vector3.New(1,1,1);
        --line.transform.localPosition = Vector3.New(0,0,0);
        line.transform.localPosition = self._beginPoses[i];
        --line.transform.localRotation= Quaternion.Euler(0,0,0);
        line.transform.localRotation  = self._rotation[i];
        line.runTime = 0;
        line.speed  = self._speeds[i];
        line.beginPos = self._beginPoses[i];
    end

    --������
    self.gameObject:SetActive(false);
end

function _CFishGroup2Ex:AsyncCreateFish(_dt)
    if not self._asyncCreateFish then
        return ;
    end
    local gameObject;
    local transform ;
    local lineCount=2;
    local _fishGroupData = self._fishGroupData;

    local needCreateCount = 6;
    local createFishCount = self._asyncCreateCount;
    --�ܵĴ�������
    self._asyncCreateCount = self._asyncCreateCount + needCreateCount;

    local everyCount = math.floor(_fishGroupData.fishPartCount/lineCount);

    for i=1,lineCount do
        line = self.lines[i];
        transform = line.transform;

        groupPartBeginIndex = (i-1)*everyCount;
        fishIndex  = 1;

        x = 0;
        y = 0;
        for j=1,everyCount do
            groupPartIndex = groupPartBeginIndex + j;
            groupPart = _fishGroupData.fishGroupParts[groupPartIndex];
            fishCount = groupPart.fishCount;
            for k=1,fishCount do  --���е���
                x = x - self._innerPaddingX[fishIndex];
                if createFishCount>0 then
                    createFishCount = createFishCount - 1;
                else
                    if needCreateCount>0 then
                        needCreateCount = needCreateCount -1;
                        fishData = groupPart.fishes[k];
                        fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
                        fishObj:SetParent(transform);
                        fishObj:SetLocalPosition(Vector3.New(x, y, 0));
                        fishObj:SetLocalRotation(Quaternion.Euler(0,0,0));
                        fishObj:SetLocalScale(Vector3.New(1,1,1));
                        --fishObj:SetLocalScale(fishObj:LocalScale():SetScale(needScale));
                        fishObj:RegEvent(self,self.OnFishEvent);
                        self.fishMap:insert(fishData.fishId,fishObj);
                    else
                        return ;
                    end                    
                end
                fishIndex = fishIndex + 1;
            end
        end
    end
    self._asyncCreateFish = false;
end

--��������ʣ���
function _CFishGroup2Ex:AsyncCreateLeftFish()
    if not self._asyncCreateFish then
        return ;
    end
    local gameObject;
    local transform ;
    local lineCount=2;
    local _fishGroupData = self._fishGroupData;

    local needCreateCount = 9999;
    local createFishCount = self._asyncCreateCount;
    --�ܵĴ�������
    self._asyncCreateCount = self._asyncCreateCount + needCreateCount;

    local everyCount = math.floor(_fishGroupData.fishPartCount/lineCount);

    for i=1,lineCount do
        line = self.lines[i];
        transform = line.transform;

        groupPartBeginIndex = (i-1)*everyCount;
        fishIndex  = 1;

        x = 0;
        y = 0;
        for j=1,everyCount do
            groupPartIndex = groupPartBeginIndex + j;
            groupPart = _fishGroupData.fishGroupParts[groupPartIndex];
            fishCount = groupPart.fishCount;
            for k=1,fishCount do  --���е���
                x = x - self._innerPaddingX[fishIndex];
                if createFishCount>0 then
                    createFishCount = createFishCount - 1;
                else
                    if needCreateCount>0 then
                        needCreateCount = needCreateCount -1;
                        fishData = groupPart.fishes[k];
                        fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
                        fishObj:SetParent(transform);
                        fishObj:SetLocalPosition(Vector3.New(x, y, 0));
                        fishObj:SetLocalRotation(Quaternion.Euler(0,0,0));
                        fishObj:SetLocalScale(Vector3.New(1,1,1));
                        --fishObj:SetLocalScale(fishObj:LocalScale():SetScale(needScale));
                        fishObj:RegEvent(self,self.OnFishEvent);
                        self.fishMap:insert(fishData.fishId,fishObj);
                    else
                        return ;
                    end                    
                end
                fishIndex = fishIndex + 1;
            end
        end
    end
    self._asyncCreateFish = false;
end

function _CFishGroup2Ex:Update(_dt)
    --�ƶ�
    local line;
    for i=1,self.lineCount do
        line = self.lines[i];
        line.runTime =  line.runTime + _dt;
        line.transform.localPosition = line.beginPos + line.speed * line.runTime;
    end
end

function _CFishGroup2Ex:OnFishDisappear(_fish,_fishId)

end

--��ʱ
function _CFishGroup2Ex:OnTimeOut()

end


local _CFishGroup3Ex = class("_CFishGroup3Ex",_CFishGroup);

--�㳱1
function _CFishGroup3Ex:ctor(_fishCreator)
    _CFishGroup3Ex.super.ctor(self,_fishCreator,40);
    self._moveBeginDis = 800;
    self._movePadding = 120;
    self._moveSpeed    = 100;
    self._innerPaddingX = {0,210,210,250,260,260,260,260,260,260,260,260,260,260,500,500,520,520};

    --�ٶ�
    self._speeds   = {
                        Vector3.New(self._moveSpeed,0,0),
                        Vector3.New(0,self._moveSpeed,0),
                        Vector3.New(-self._moveSpeed,0,0),
                        Vector3.New(0,-self._moveSpeed,0),
                        };

    --��ʼλ��
    self._beginPoses  = {
                    Vector3.New(-self._moveBeginDis,-self._movePadding,0),
                    Vector3.New(-self._movePadding,-self._moveBeginDis,0),
                    Vector3.New(self._moveBeginDis,self._movePadding,0),
                    Vector3.New(self._movePadding,self._moveBeginDis,0),
                    };

    --��ת
    self._rotation    = {
                    Quaternion.Euler(0,0,0),
                    Quaternion.Euler(0,0,90),
                    Quaternion.Euler(0,0,180),
                    Quaternion.Euler(0,0,270),   
                    };
end


function _CFishGroup3Ex:Init(_parent,_fishGroupData)
    self.gameObject = GameObject.New();
    self.gameObject.name = "FishGroup 1 && 3";
    self.transform  = self.gameObject.transform;
    self.transform:SetParent(_parent);
    self.transform.localScale = Vector3.New(1,1,1);
    self.transform.localPosition = Vector3.New(0,0,0);
    self.transform.localRotation= Quaternion.Euler(0,0,0);

    local lineCount = 4;
    local everyCount = math.floor(_fishGroupData.fishPartCount/lineCount);
    self.lines = {};
    self.lineCount = lineCount;
    local line;
    local groupPart;
    local fishCount;
    local groupPartIndex;
    local groupPartBeginIndex;
    local fishIndex;
    local x,y;
    local fishObj,fishData;
    local transform;
    for i=1,lineCount do
        line = {};
        self.lines[i] = line;
        line.gameObject = GameObject.New();
        line.transform  = line.gameObject.transform;
        line.fishMap    = map:new();
        line.transform:SetParent(self.transform);
        line.transform.localScale = Vector3.New(1,1,1);
        --line.transform.localPosition = Vector3.New(0,0,0);
        line.transform.localPosition = self._beginPoses[i];
        --line.transform.localRotation= Quaternion.Euler(0,0,0);
        line.transform.localRotation  = self._rotation[i];
        transform = line.transform;
        line.runTime = 0;
        line.speed  = self._speeds[i];
        line.beginPos = self._beginPoses[i];

        groupPartBeginIndex = (i-1)*everyCount;
        fishIndex  = 1;

        x = 0;
        y = 0;
        for j=1,everyCount do
            groupPartIndex = groupPartBeginIndex + j;
            groupPart = _fishGroupData.fishGroupParts[groupPartIndex];
            fishCount = groupPart.fishCount;
            for k=1,fishCount do  --���е���
                x = x - self._innerPaddingX[fishIndex];
                fishData = groupPart.fishes[k];
                fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
                fishObj:SetParent(transform);
                fishObj:SetLocalPosition(Vector3.New(x, y, 0));
                fishObj:SetLocalRotation(Quaternion.Euler(0,0,0));
                fishObj:SetLocalScale(Vector3.New(1,1,1));
                --fishObj:SetLocalScale(fishObj:LocalScale():SetScale(needScale));
                fishObj:RegEvent(self,self.OnFishEvent);
                self.fishMap:insert(fishData.fishId,fishObj);
                fishIndex = fishIndex + 1;
            end
        end
    end
end

function _CFishGroup3Ex:AsyncInit(_parent,_fishGroupData)
    _CFishGroup3Ex.super.AsyncInit(self,_parent,_fishGroupData);

    self.gameObject = GameObject.New();
    self.gameObject.name = "FishGroup 1 && 3";
    self.transform  = self.gameObject.transform;
    self.transform:SetParent(_parent);
    self.transform.localScale = Vector3.New(1,1,1);
    self.transform.localPosition = Vector3.New(0,0,0);
    self.transform.localRotation= Quaternion.Euler(0,0,0);

    local gameObject;
    local transform ;

    local lineCount = 4;
    local everyCount = math.floor(_fishGroupData.fishPartCount/lineCount);
    local line;
    self.lines = {};
    self.lineCount = lineCount;

    for i=1,lineCount do
        line = {};
        self.lines[i] = line;
        line.gameObject = GameObject.New();
        line.transform  = line.gameObject.transform;
        line.fishMap    = map:new();
        line.transform:SetParent(self.transform);
        line.transform.localScale = Vector3.New(1,1,1);
        line.transform.localPosition = self._beginPoses[i];
        line.transform.localRotation  = self._rotation[i];
        transform = line.transform;
        line.runTime = 0;
        line.speed  = self._speeds[i];
        line.beginPos = self._beginPoses[i];
    end

    --������
    self.gameObject:SetActive(false);
end

function _CFishGroup3Ex:AsyncCreateFish(_dt)
    if not self._asyncCreateFish then
        return ;
    end
    local gameObject;
    local transform ;
    local lineCount=4;
    local _fishGroupData = self._fishGroupData;

    
    local needCreateCount = 6;
    local createFishCount = self._asyncCreateCount;
    --�ܵĴ�������
    self._asyncCreateCount = self._asyncCreateCount + needCreateCount;

    local everyCount = math.floor(_fishGroupData.fishPartCount/lineCount);

    for i=1,lineCount do
        line = self.lines[i];
        transform = line.transform;

        groupPartBeginIndex = (i-1)*everyCount;
        fishIndex  = 1;

        x = 0;
        y = 0;
        for j=1,everyCount do
            groupPartIndex = groupPartBeginIndex + j;
            groupPart = _fishGroupData.fishGroupParts[groupPartIndex];
            fishCount = groupPart.fishCount;
            for k=1,fishCount do  --���е���

				if fishIndex>18 then fishIndex=18 end 
                x = x - self._innerPaddingX[fishIndex];			
                if createFishCount>0 then
                    createFishCount = createFishCount - 1;
                else
                    if needCreateCount>0 then
                        needCreateCount = needCreateCount -1;
                        fishData = groupPart.fishes[k];
                        fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
                        fishObj:SetParent(transform);
                        fishObj:SetLocalPosition(Vector3.New(x, y, 0));
                        fishObj:SetLocalRotation(Quaternion.Euler(0,0,0));
                        fishObj:SetLocalScale(Vector3.New(1,1,1));
                        --fishObj:SetLocalScale(fishObj:LocalScale():SetScale(needScale));
                        fishObj:RegEvent(self,self.OnFishEvent);
                        self.fishMap:insert(fishData.fishId,fishObj);
                    else
                        return ;
                    end                    
                end
                fishIndex = fishIndex + 1;
            end
        end
    end
    self._asyncCreateFish = false;
end

--��������ʣ���
function _CFishGroup3Ex:AsyncCreateLeftFish()
    if not self._asyncCreateFish then
        return ;
    end
    local gameObject;
    local transform ;
    local lineCount=4;
    local _fishGroupData = self._fishGroupData;

    
    local needCreateCount = 9999;
    local createFishCount = self._asyncCreateCount;
    --�ܵĴ�������
    self._asyncCreateCount = self._asyncCreateCount + needCreateCount;

    local everyCount = math.floor(_fishGroupData.fishPartCount/lineCount);

    for i=1,lineCount do
        line = self.lines[i];
        transform = line.transform;

        groupPartBeginIndex = (i-1)*everyCount;
        fishIndex  = 1;

        x = 0;
        y = 0;
        for j=1,everyCount do
            groupPartIndex = groupPartBeginIndex + j;
            groupPart = _fishGroupData.fishGroupParts[groupPartIndex];
            fishCount = groupPart.fishCount;
            for k=1,fishCount do  --���е���
                x = x - self._innerPaddingX[fishIndex];
                if createFishCount>0 then
                    createFishCount = createFishCount - 1;
                else
                    if needCreateCount>0 then
                        needCreateCount = needCreateCount -1;
                        fishData = groupPart.fishes[k];
                        fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
                        fishObj:SetParent(transform);
                        fishObj:SetLocalPosition(Vector3.New(x, y, 0));
                        fishObj:SetLocalRotation(Quaternion.Euler(0,0,0));
                        fishObj:SetLocalScale(Vector3.New(1,1,1));
                        --fishObj:SetLocalScale(fishObj:LocalScale():SetScale(needScale));
                        fishObj:RegEvent(self,self.OnFishEvent);
                        self.fishMap:insert(fishData.fishId,fishObj);
                    else
                        return ;
                    end                    
                end
                fishIndex = fishIndex + 1;
            end
        end
    end
    self._asyncCreateFish = false;
end

function _CFishGroup3Ex:Update(_dt)
    --�ƶ�
    local line;
    for i=1,self.lineCount do
        line = self.lines[i];
        line.runTime =  line.runTime + _dt;
        line.transform.localPosition = line.beginPos + line.speed * line.runTime;
    end
end

function _CFishGroup3Ex:OnFishDisappear(_fish,_fishId)
    
end

--��ʱ
function _CFishGroup3Ex:OnTimeOut()

end


local _CFishGroup4Ex = class("_CFishGroup4Ex",_CFishGroup);

--�㳱4
function _CFishGroup4Ex:ctor(_fishCreator)
    _CFishGroup2Ex.super.ctor(self,_fishCreator);
    self._moveBeginDis = 667;
    self._movePadding = 360;
    self._moveSpeed    = 100;
    self._innerPaddingX = {0,250,250,270,290,290,290,290,290,290,290,290,290,290,290,290,450,450};

    --�ٶ�
    self._speeds   = {
                        Vector3.New(self._moveSpeed,self._moveSpeed,0),
                        Vector3.New(-self._moveSpeed,self._moveSpeed,0),
                        Vector3.New(-self._moveSpeed,-self._moveSpeed,0),
                        Vector3.New(self._moveSpeed,-self._moveSpeed,0),
                        };

    --��ʼλ��
    self._beginPoses  = {
                    Vector3.New(-self._moveBeginDis,-self._movePadding,0),
                    Vector3.New(self._moveBeginDis,-self._movePadding,0),
                    Vector3.New(self._moveBeginDis,self._movePadding,0),
                    Vector3.New(-self._moveBeginDis,self._movePadding,0),
                    };

    --��ת
    self._rotation    = {
                    Quaternion.Euler(0,0,45),
                    Quaternion.Euler(0,0,135),
                    Quaternion.Euler(0,0,225),
                    Quaternion.Euler(0,0,315),   
                    };

end


function _CFishGroup4Ex:Init(_parent,_fishGroupData)
    self.gameObject = GameObject.New();
    self.gameObject.name = "FishGroup 4";
    self.transform  = self.gameObject.transform;
    self.transform:SetParent(_parent);
    self.transform.localScale = Vector3.New(1,1,1);
    self.transform.localPosition = Vector3.New(0,0,0);
    self.transform.localRotation= Quaternion.Euler(0,0,0);

    local lineCount = 4;
    local everyCount = math.floor(_fishGroupData.fishPartCount/lineCount);
    self.lines = {};
    self.lineCount = lineCount;
    local line;
    local groupPart;
    local fishCount;
    local groupPartIndex;
    local groupPartBeginIndex;
    local fishIndex;
    local x,y;
    local fishObj,fishData;
    local transform;
    for i=1,lineCount do
        line = {};
        self.lines[i] = line;
        line.gameObject = GameObject.New();
        line.transform  = line.gameObject.transform;
        line.fishMap    = map:new();
        line.transform:SetParent(self.transform);
        line.transform.localScale = Vector3.New(1,1,1);
        --line.transform.localPosition = Vector3.New(0,0,0);
        line.transform.localPosition = self._beginPoses[i];
        --line.transform.localRotation= Quaternion.Euler(0,0,0);
        line.transform.localRotation  = self._rotation[i];
        transform = line.transform;
        line.runTime = 0;
        line.speed  = self._speeds[i];
        line.beginPos = self._beginPoses[i];

        groupPartBeginIndex = (i-1)*everyCount;
        fishIndex  = 1;

        x = 0;
        y = 0;
        for j=1,everyCount do
            groupPartIndex = groupPartBeginIndex + j;
            groupPart = _fishGroupData.fishGroupParts[groupPartIndex];
            fishCount = groupPart.fishCount;
            for k=1,fishCount do  --���е���
                x = x - self._innerPaddingX[fishIndex];
                fishData = groupPart.fishes[k];
                fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
                fishObj:SetParent(transform);
                fishObj:SetLocalPosition(Vector3.New(x, y, 0));
                fishObj:SetLocalRotation(Quaternion.Euler(0,0,0));
                fishObj:SetLocalScale(Vector3.New(1,1,1));
                --fishObj:SetLocalScale(fishObj:LocalScale():SetScale(needScale));
                fishObj:RegEvent(self,self.OnFishEvent);
                self.fishMap:insert(fishData.fishId,fishObj);
                fishIndex = fishIndex + 1;
            end
        end
    end
end

function _CFishGroup4Ex:AsyncInit(_parent,_fishGroupData)
    _CFishGroup4Ex.super.AsyncInit(self,_parent,_fishGroupData);

    self.gameObject = GameObject.New();
    self.gameObject.name = "FishGroup 4";
    self.transform  = self.gameObject.transform;
    self.transform:SetParent(_parent);
    self.transform.localScale = Vector3.New(1,1,1);
    self.transform.localPosition = Vector3.New(0,0,0);
    self.transform.localRotation= Quaternion.Euler(0,0,0);

    local gameObject;
    local transform ;

    local lineCount = 4;
    local everyCount = math.floor(_fishGroupData.fishPartCount/lineCount);
    self.lines = {};
    self.lineCount = lineCount;
    local line;

    for i=1,lineCount do
        line = {};
        self.lines[i] = line;
        line.gameObject = GameObject.New();
        line.transform  = line.gameObject.transform;
        line.fishMap    = map:new();
        line.transform:SetParent(self.transform);
        line.transform.localScale = Vector3.New(1,1,1);
        --line.transform.localPosition = Vector3.New(0,0,0);
        line.transform.localPosition = self._beginPoses[i];
        --line.transform.localRotation= Quaternion.Euler(0,0,0);
        line.transform.localRotation  = self._rotation[i];
        transform = line.transform;
        line.runTime = 0;
        line.speed  = self._speeds[i];
        line.beginPos = self._beginPoses[i];
    end

    --������
    self.gameObject:SetActive(false);
end

function _CFishGroup4Ex:AsyncCreateFish(_dt)
    if not self._asyncCreateFish then
        return ;
    end
    local gameObject;
    local transform ;
    local lineCount=4;
    local _fishGroupData = self._fishGroupData;

    
    local needCreateCount = 1;
    local createFishCount = self._asyncCreateCount;
    --�ܵĴ�������
    self._asyncCreateCount = self._asyncCreateCount + needCreateCount;

    local everyCount = math.floor(_fishGroupData.fishPartCount/lineCount);

    for i=1,lineCount do
        line = self.lines[i];
        transform = line.transform;

        groupPartBeginIndex = (i-1)*everyCount;
        fishIndex  = 1;

        x = 0;
        y = 0;
        for j=1,everyCount do
            groupPartIndex = groupPartBeginIndex + j;
            groupPart = _fishGroupData.fishGroupParts[groupPartIndex];
            fishCount = groupPart.fishCount;
            for k=1,fishCount do  --���е���
                x = x - self._innerPaddingX[fishIndex];
                if createFishCount>0 then
                    createFishCount = createFishCount - 1;
                else
                    if needCreateCount>0 then
                        needCreateCount = needCreateCount -1;
                        fishData = groupPart.fishes[k];
                        fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
                        fishObj:SetParent(transform);
                        fishObj:SetLocalPosition(Vector3.New(x, y, 0));
                        fishObj:SetLocalRotation(Quaternion.Euler(0,0,0));
                        fishObj:SetLocalScale(Vector3.New(1,1,1));
                        --fishObj:SetLocalScale(fishObj:LocalScale():SetScale(needScale));
                        fishObj:RegEvent(self,self.OnFishEvent);
                        self.fishMap:insert(fishData.fishId,fishObj);
                    else
                        return ;
                    end                    
                end
                fishIndex = fishIndex + 1;
            end
        end
    end
    self._asyncCreateFish = false;
end

--��������ʣ���
function _CFishGroup4Ex:AsyncCreateLeftFish()
    if not self._asyncCreateFish then
        return ;
    end
    local gameObject;
    local transform ;
    local lineCount=4;
    local _fishGroupData = self._fishGroupData;

    
    local needCreateCount = 9999;
    local createFishCount = self._asyncCreateCount;
    --�ܵĴ�������
    self._asyncCreateCount = self._asyncCreateCount + needCreateCount;

    local everyCount = math.floor(_fishGroupData.fishPartCount/lineCount);

    for i=1,lineCount do
        line = self.lines[i];
        transform = line.transform;

        groupPartBeginIndex = (i-1)*everyCount;
        fishIndex  = 1;

        x = 0;
        y = 0;
        for j=1,everyCount do
            groupPartIndex = groupPartBeginIndex + j;
            groupPart = _fishGroupData.fishGroupParts[groupPartIndex];
            fishCount = groupPart.fishCount;
            for k=1,fishCount do  --���е���
                x = x - self._innerPaddingX[fishIndex];
                if createFishCount>0 then
                    createFishCount = createFishCount - 1;
                else
                    if needCreateCount>0 then
                        needCreateCount = needCreateCount -1;
                        fishData = groupPart.fishes[k];
                        fishObj = self:CreateFish(fishData.fishType,fishData.fishId);
                        fishObj:SetParent(transform);
                        fishObj:SetLocalPosition(Vector3.New(x, y, 0));
                        fishObj:SetLocalRotation(Quaternion.Euler(0,0,0));
                        fishObj:SetLocalScale(Vector3.New(1,1,1));
                        --fishObj:SetLocalScale(fishObj:LocalScale():SetScale(needScale));
                        fishObj:RegEvent(self,self.OnFishEvent);
                        self.fishMap:insert(fishData.fishId,fishObj);
                    else
                        return ;
                    end                    
                end
                fishIndex = fishIndex + 1;
            end
        end
    end
    self._asyncCreateFish = false;
end

function _CFishGroup4Ex:Update(_dt)
    --�ƶ�
    local line;
    for i=1,self.lineCount do
        line = self.lines[i];
        line.runTime =  line.runTime + _dt;
        line.transform.localPosition = line.beginPos + line.speed * line.runTime;
    end
end

function _CFishGroup4Ex:OnFishDisappear(_fish,_fishId)
    return true;
end

--��ʱ
function _CFishGroup4Ex:OnTimeOut()

end


function _CFishGroup.Create(_parent,_creator,_fishGroupData)
    local fishGroup=nil;
    if _fishGroupData.sceneKind == G_GlobalGame.Enum_FishGroupType.FishGroup_1 then
        fishGroup = _CFishGroup1Ex.New(_creator);
        fishGroup:AsyncInit(_parent,_fishGroupData);
    elseif _fishGroupData.sceneKind == G_GlobalGame.Enum_FishGroupType.FishGroup_2 then
        fishGroup = _CFishGroup2Ex.New(_creator);
        fishGroup:AsyncInit(_parent,_fishGroupData);
    elseif _fishGroupData.sceneKind == G_GlobalGame.Enum_FishGroupType.FishGroup_3 then
        fishGroup = _CFishGroup3Ex.New(_creator);
        fishGroup:AsyncInit(_parent,_fishGroupData);
    elseif _fishGroupData.sceneKind == G_GlobalGame.Enum_FishGroupType.FishGroup_4 then
        fishGroup = _CFishGroup4Ex.New(_creator);
        fishGroup:AsyncInit(_parent,_fishGroupData);
    end
    return fishGroup;
end

return _CFishGroup;