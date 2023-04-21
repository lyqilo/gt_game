local DragonMissionPanel = class("DragonMissionPanel");

local ThrowPath = GameRequire("SI_ThrowPath");
local ThrowMove = GameRequire("SI_ThrowMove");

local AtlasNumber = GameRequire("SI_AtlasNumber");

local BalanceNumber = GameRequire("SI_BalanceNumber");

local DRAGON_UI_CONFIG = {
    ColumnH = 60,
    BallH   = 70,
};

local C_AUTO_FALL_DOWN_TIME = 180; --3分钟

--
local DRAGON_FALL_STATE = {
    WAITING         = 0, --什么都不干
    ENTER_SCENE     = 1,  --出场
    VERTICAL_FALL   = 2,  --垂直下落
    SEARCH_PATH     = 3,  --寻找路径
    BALANCE         = 4,  --结算
    FLY_BALANCE     = 5,  --结算字飞起来
    
    GAME_OVER       = 10,  --游戏结束
};

local slotIdCreator = ID_Creator(1);
local pathIdCreator = ID_Creator(1);
local pathPointCreator=ID_Creator(1);

--龙珠掉落路劲配置
local FallPath = {
    [slotIdCreator(1)] = {
        paths = {
            [pathIdCreator(1)] = {[pathPointCreator(1)]=2,[pathPointCreator()]=4,[pathPointCreator()]=7,random=30},
        }
    },
    [slotIdCreator()] = {
        paths = {
            [pathIdCreator(1)] = {[pathPointCreator(1)]=2,[pathPointCreator()]=4,[pathPointCreator()]=7,random=15},
            [pathIdCreator()] = {[pathPointCreator(1)]=2,[pathPointCreator()]=4,[pathPointCreator()]=8,random=20},
            [pathIdCreator()] = {[pathPointCreator(1)]=2,[pathPointCreator()]=5,[pathPointCreator()]=8,random=30},
            [pathIdCreator()] = {[pathPointCreator(1)]=3,[pathPointCreator()]=5,[pathPointCreator()]=8,random=30},
        }
    },
    [slotIdCreator()] = {
        paths = {
            [pathIdCreator(1)] = {[pathPointCreator(1)]=2,[pathPointCreator()]=5,[pathPointCreator()]=8,random=30},
            [pathIdCreator(1)] = {[pathPointCreator(1)]=3,[pathPointCreator()]=5,[pathPointCreator()]=8,random=10},
            [pathIdCreator(1)] = {[pathPointCreator(1)]=2,[pathPointCreator()]=5,[pathPointCreator()]=9,random=10},
            [pathIdCreator(1)] = {[pathPointCreator(1)]=3,[pathPointCreator()]=5,[pathPointCreator()]=9,random=30},

        }
    },
    [slotIdCreator()] = {
        paths = {
            [pathIdCreator(1)] = {[pathPointCreator(1)]=3,[pathPointCreator()]=6,[pathPointCreator()]=10,random=15},
            [pathIdCreator()] = {[pathPointCreator(1)]=3,[pathPointCreator()]=6,[pathPointCreator()]=9,random=20},
            [pathIdCreator()] = {[pathPointCreator(1)]=3,[pathPointCreator()]=5,[pathPointCreator()]=9,random=30},
            [pathIdCreator()] = {[pathPointCreator(1)]=2,[pathPointCreator()]=5,[pathPointCreator()]=9,random=30},
        }
    },
    [slotIdCreator()] = {
        paths = {
            [pathIdCreator(1)] = {[pathPointCreator(1)]=3,[pathPointCreator()]=6,[pathPointCreator()]=10,random=30},
        }
    },
    --获取一条路径
    getPath=function(_data,_slot)
        local random=0;
        local paths = _data[_slot].paths;
        for i=1,#paths do
            random = random + paths[i].random;
        end
        local rand=math.random(1,random);
        for i=1,#paths do
            if rand<=paths[i].random then
                return paths[i];
            end
        end
        return paths[#paths];
    end,
}

local SlotStyle = class("SlotStyle");

function SlotStyle:ctor(back1,
            back2,
            front1,
            front2,
            fire,
            goldLabel)
    self.back1 = back1;
    self.back2 = back2;
    self.front1= front1;
    self.front2= front2;
    self.fire  = fire;
    self.goldLabel = goldLabel;
end

function SlotStyle:bright()
    self.back2:SetActive(true);
    self.front2:SetActive(true);
    self.back1:SetActive(false);
    self.front1:SetActive(false);
    self.fire:Play();
    --self.transform:GetComponent("ParticleSystem");
end
function SlotStyle:normal()
    self.back2:SetActive(false);
    self.front2:SetActive(false);
    self.back1:SetActive(true);
    self.front1:SetActive(true);
    self.fire:Stop();
end

function SlotStyle:setNumber(num)
    self.goldLabel:SetNumber(num);
end

local Slot =class("Slot");
function Slot:ctor(back1,
            back2,
            front1,
            front2,
            fire,
            goldBg,
            goldLabel)
    self.style = SlotStyle.New(back1,back2,front1,front2,fire,goldLabel);
    self.goldBg = goldBg;
    self.isDisplayGoldBg = false;
    self.isBright = false;
end

function Slot:bright()
    --显示燃烧火炉
    self.isBright = true;
    self.style:bright();
--    local changeNormal = function()
--        coroutine.wait(2);
--        if not GlobalGame.isInGame then
--            return;
--        end
--        self:normal();
--    end
--    coroutine.start(changeNormal);
    local changeNormal = function()
        self:normal();
    end
    GlobalGame._timerMgr:FixUpdateOnce(changeNormal,2);

    --改变背景框，闪烁
--    local changeGoldBg = function()
--        while(true) do
--            coroutine.wait(0.06);
--            if not GlobalGame.isInGame then
--                return;
--            end
--            if self.isBright then
--                self.isDisplayGoldBg = not self.isDisplayGoldBg;
--                self.goldBg:SetActive(self.isDisplayGoldBg);
--            else
--                break;
--            end
--        end
--    end
--    coroutine.start(changeGoldBg);
    local changeGoldBg;
    changeGoldBg = function()
        if self.isBright then
            self.isDisplayGoldBg = not self.isDisplayGoldBg;
            self.goldBg:SetActive(self.isDisplayGoldBg);
            GlobalGame._timerMgr:FixUpdateOnce(changeGoldBg,0.06);
        end
    end
    GlobalGame._timerMgr:FixUpdateOnce(changeGoldBg,0.06);
end

function Slot:normal()
    self.style:normal();
    self.isBright = false;
    self.goldBg:SetActive(false);
    self.isDisplayGoldBg = false;
end

function Slot:setNumber(num)
    self.style:setNumber(num);
end

local FADE_IN_GROUP_INDEX = {
    First =0,
    Second=1,
    Third =2,
    Fourth=3,
    Fifth =4,
};

--
function DragonMissionPanel:ctor(gamePanel)
    self.gamePanel   = gamePanel;
end

function DragonMissionPanel:Init(transform,_overHandler)
    self._overHandler   = _overHandler;
    self.transform      = transform;
    self._Obj           = transform.gameObject;
    self.gameObject     = self._Obj;
    self._ball = nil;

    --统一处理的，如果有特殊的单个，自己处理
    self._fadeInImageGroups = {
        groups = nil,
        imageGroupTemplate = nil,
        handler = nil,
        init = function(self,handler)
            self.groups = map:new();
            self.handler = handler;
        end,
        addImageGroups = function(self,groupIndex,_delayTime,_aphlaSpeed)
            if not self.imageGroupTemplate then
                local imageGroup = class("ImageGroup");
                function imageGroup:ctor(_delayTime,_aphlaSpeed)
                    self.imageVec = vector:new();
                    self.delayTime= _delayTime;
                    self.aphlaSpeed= _aphlaSpeed;
                    self.curColor = Color.New(1,1,1,0);
                    self.runTime  = 0;
                    self.isOver   = true;
                    self.isFirst  = true;
                end
                function imageGroup:start()
                    self.curColor.a = 0;
                    local it = self.imageVec:iter();
                    local val = it();
                    while(val) do
                        if val.type==1 then
                            val.obj.color = self.curColor;
                        elseif val.type==2 then
                            val.obj:SetAlpha(self.curColor.a);
                        end
                        val = it();
                    end
                    self.runTime = 0;
                    self.isOver = false;
                    self.isFirst= true;
                end
                function imageGroup:push(image)
                    local data = {obj = image, type =1};
                    self.imageVec:push_back(data);
                end
                function imageGroup:pushAtlasNumber(atlasNumber)
                    local data = {obj = atlasNumber, type =2};
                    self.imageVec:push_back(data);                    
                end
                
                function imageGroup:IsFirst()
                    return self.isFirst;
                end

                function imageGroup:update(dt)
                    if self.isOver then
                        self.isFirst = false;
                        return self.isOver;
                    end
                    if self.runTime>= self.delayTime then
                        self.curColor.a = self.curColor.a + dt* self.aphlaSpeed;
                        if self.curColor.a>=1 then
                            self.isOver = true;
                        end
                        local it = self.imageVec:iter();
                        local val = it();
                        while(val) do
                            if val.type==1 then
                                val.obj.color = self.curColor;
                            elseif val.type==2 then
                                val.obj:SetAlpha(self.curColor.a*255);
                            end
                            val = it();
                        end
                    else
                        self.runTime = self.runTime + dt;
                    end
                    return self.isOver;
                end
                self.imageGroupTemplate = imageGroup;
            end
            local group = self.imageGroupTemplate.New(_delayTime,_aphlaSpeed);
            self.groups:insert(groupIndex,group);
        end,
        pushImageInGroup = function(self,groupIndex,image)
            if groupIndex == nil then
                return ;
            end
            local group = self.groups:value(groupIndex);
            group:push(image);
        end,
        pushInGroup = function(self,groupIndex,transform)
            if groupIndex == nil then
                return ;
            end
            local image = transform:GetComponent("Image");
            if not image then
                return ;
            end
            local group = self.groups:value(groupIndex);
            group:push(image);
        end,
        pushAtlasNumberInGroup = function(self,groupIndex,atlasNumber)
            if groupIndex == nil then
                return ;
            end
            local group = self.groups:value(groupIndex);
            group:pushAtlasNumber(atlasNumber);
        end,
        start = function(self,dt)
            local it = self.groups:iter();
            local val = it();
            local group;
            while(val) do
                group = self.groups:value(val);
                group:start();
                val = it();
            end
        end,
        update = function(self,dt)
            local it = self.groups:iter();
            local val = it();
            local group;
            while(val) do
                group = self.groups:value(val);
                if group:update(dt) then
                    if group:IsFirst() then
                        if self.handler then
                            self.handler(val);
                        end
                    end
                end
                val = it();
            end            
        end,
    };
    
    self._fadeInImageGroups:init(handler(self,self.__imageGroupEventHandler));
    self._fadeInImageGroups:addImageGroups(FADE_IN_GROUP_INDEX.First,0,0.8);
    self._fadeInImageGroups:addImageGroups(FADE_IN_GROUP_INDEX.Second,0.3,0.8);
    self._fadeInImageGroups:addImageGroups(FADE_IN_GROUP_INDEX.Third,0.5,0.8);
    self._fadeInImageGroups:addImageGroups(FADE_IN_GROUP_INDEX.Fourth,0.8,0.6);
    self._fadeInImageGroups:addImageGroups(FADE_IN_GROUP_INDEX.Fifth,0.9,0.6);

    local bg = self.transform:Find("BG");
    self._fadeInImageGroups:pushInGroup(FADE_IN_GROUP_INDEX.First,bg);

    local BallPanel = self.transform:Find("BallPanel");
    self._ball = BallPanel:Find("Ball");
    self._ballImage = self._ball:GetComponent("Image");
    self._beginFallBallPos = self._ball.localPosition; 
    --慢慢显示出球
    self._fadeInImageGroups:pushInGroup(FADE_IN_GROUP_INDEX.Fourth,self._ballImage);

    self.slotStyles = { 
        slots = {
        },  
        fallIn = function(self,index)
            local slot = nil;
            for i=1,#self.slots do
                slot = self.slots[i];
                if i==index  then
                    slot:bright();
                else
                    slot:normal();
                end
            end
        end,
        normal = function(self)
            local slot = nil;
            for i=1,#self.slots do
                slot = self.slots[i];
                slot:normal();
            end
        end,
        init = function(self,data)

        end,
    };


    self._slotPoints    = {};
    self._columnPoints  = {};

    local backStyle1,backStyle2,frontStyle1,frontStyle2,SlotTarget;
    local back1,back2,front1,front2,fire,goldBg,goldNumber;
    local child,temp;
    local BackStyle = self.transform:Find("SlotBack");
    local localPosition;
    backStyle1 = BackStyle:Find("SlotBackStyle1");
    backStyle2 = BackStyle:Find("SlotBackStyle2");

    local FrontStyle = self.transform:Find("SlotFront");
    frontStyle1 = FrontStyle:Find("SlotFrontStyle1");
    frontStyle2 = FrontStyle:Find("SlotFrontStyle2");

    SlotTarget = FrontStyle:Find("SlotTargetPanel");

    --遍历每个槽
    for i=1,SI_MAX_DRAGON_SLOT_COUNT do
        child = backStyle1:GetChild(i-1);
        back1 = child.gameObject;
        --塞入渐变
        self._fadeInImageGroups:pushInGroup(FADE_IN_GROUP_INDEX.Third,child:GetChild(0));

        child = backStyle2:GetChild(i-1);
        back2 = child.gameObject;

        child = frontStyle1:GetChild(i-1);
        front1 = child.gameObject;
        --塞入渐变
        self._fadeInImageGroups:pushInGroup(FADE_IN_GROUP_INDEX.Third,child:GetChild(0));

        child = frontStyle2:GetChild(i-1);
        front2 = child.gameObject;
        child = SlotTarget:GetChild(i-1);

        self._slotPoints[i] = Vector3.New(child.localPosition.x,child.localPosition.y,0);

        temp = child:Find("lztb_huo");
        fire  = temp:GetComponent("ParticleSystem");
		
        if fire and GlobalGame.isPortrait then
            --竖屏粒子要特殊处理下

            local m=fire.main;
            m.startRotation = MinMaxCurve.New(90);
            m.startSize     = MinMaxCurve.New(0.9);
            localPosition = temp.localPosition;
            temp.localPosition = Vector3.New(localPosition.x+16,localPosition.y,localPosition.z);
        end
        child = child:Find("GoldBG");

        --塞入渐变
        self._fadeInImageGroups:pushInGroup(FADE_IN_GROUP_INDEX.Third,child);

        goldBg = child:Find("FrontBg");
        goldBg = goldBg.gameObject;

        child = child:Find("Number");
        goldNumber = self.gamePanel:CreateAtlasNumber(child,-2);
        goldNumber:SetLocalScale(Vector3.New(0.8,0.8,0.8));
        --塞入渐变
        self._fadeInImageGroups:pushAtlasNumberInGroup(FADE_IN_GROUP_INDEX.Third,goldNumber);
        self.slotStyles.slots[i] = Slot.New(back1,back2,front1,front2,fire,goldBg,goldNumber);
    end

    self.startBtnBG   = self.transform:Find("ButtonBG");
    --塞入渐变
    --self._fadeInImageGroups:pushInGroup(FADE_IN_GROUP_INDEX.Fourth,self.startBtnBG);
    local startButton = self.startBtnBG:Find("Start");
    local eventTrigger = Util.AddComponent("EventTriggerListener",startButton.gameObject);
    eventTrigger.onClick = handler(self,self.__onStartDragonMission);
    self.startButton  = startButton;

    local StartTip = self.startBtnBG:Find("Tip");
    --塞入渐变
    self._fadeInImageGroups:pushInGroup(FADE_IN_GROUP_INDEX.Fifth,StartTip);
    self.StartTip  = StartTip;

    local ColumnsPanel = self.transform:Find("ColumnsPanel");
    local columnsCount = ColumnsPanel.childCount;
    local column;
    local num;
    local stoneObj;
    for i=1,columnsCount do
        column = ColumnsPanel:GetChild(i-1);
        num = tonumber(column.gameObject.name);
        stoneObj = GlobalGame._gameObjManager:GetStoneObj(num);
        stoneObj:SetParent(column);
        stoneObj:SetLocalPosition(Vector3.New(0,0,0));
        --塞入渐变
        self._fadeInImageGroups:pushInGroup(FADE_IN_GROUP_INDEX.Second,stoneObj.transform);
        --stoneObj:SetLocalScale(Vector3.New(1.2,1.2,1.2));
        self._columnPoints[i] = Vector3.New(column.localPosition.x,column.localPosition.y + DRAGON_UI_CONFIG.ColumnH/2 + DRAGON_UI_CONFIG.BallH/2,0);
    end

    local Effect = self.transform:Find("Effect");

    local particleSystem = Effect:Find("jujiang"):GetComponent("ParticleSystem");

    --结算文字
    self._balanceNumber = BalanceNumber.New();
    local rewards = Effect:Find("CommonBalance");
    local label = self.gamePanel:CreateAtlasNumber(rewards);
    self._balanceNumber:Push(SI_BALANCE_TYPE.Common,rewards.gameObject,label);
    
    rewards = Effect:Find("BigBalance");
    label = self.gamePanel:CreateAtlasNumber(rewards);
    self._balanceNumber:Push(SI_BALANCE_TYPE.Big,rewards.gameObject,label);

    rewards = Effect:Find("LargeBalance");
    label = self.gamePanel:CreateAtlasNumber(rewards);
    self._balanceNumber:Push(SI_BALANCE_TYPE.Large,rewards.gameObject,label,particleSystem);

    rewards = Effect:Find("SuperLargeBalance");
    label = self.gamePanel:CreateAtlasNumber(rewards);
    self._balanceNumber:Push(SI_BALANCE_TYPE.LeiJi,rewards.gameObject,label,particleSystem);

    --先隐藏
    self._balanceNumber:Hide();

    --初始状态
    self._runingState = {_state = DRAGON_FALL_STATE.WAITING};

    --是否自动落下
    self.isAutoFall = false;
    --自动落下倒计时
    self._autoFallTime = 0;
end

--初始化本地数据
function DragonMissionPanel:InitLoadData(_bet,_isAutoFallDown)
    --初始化本地的数据
    local dragonData = SI_DRAGON_STAGE_DATA[1];
    for i=1,SI_MAX_DRAGON_SLOT_COUNT do
        self.slotStyles.slots[i]:setNumber(dragonData.items[i].i32_multiple);
        logTable(dragonData.items[i]);
        log("=================初始化关卡火盆数=================================="..dragonData.items[i].i32_multiple);
    end

    --正常化
    self.slotStyles:normal();

    --先隐藏
    self._balanceNumber:Hide();

    --开始按钮
    self.startBtnBG.gameObject:SetActive(true);

    --初始状态
    self._runingState._state = DRAGON_FALL_STATE.WAITING;

    --进入初始化
    self._ball.localPosition    = self._beginFallBallPos;
    self._ballImage.color       = Color.New(1,1,1,1);

    --是否自动落下
    self._isAutoFall = _isAutoFallDown;
    if self._isAutoFall then
        --自动落下倒计时
        self._autoFallTime = C_AUTO_FALL_DOWN_TIME;
    end

    --开始
    self._fadeInImageGroups:start();
    --是否可以允许开始
    self._isCanStart = false;

    --请求龙珠模式
    MusicManager:PlayBacksoundX(GlobalGame._gameObjManager:GetMusic(SI_MUSIC_TYPE.Dragon_BG), true);
end

function DragonMissionPanel:StartStage(_serverData)

    --初始球的个数
    --self._ballCount = SI_DRAGON_STAGE_DATA[_serverData.stage].ballCount;
    --只有一个球
    self._ballCount = 1;
    --self:_setBallCount();
    self._fallDatas = _serverData;
    self._fallIndex = 1;
    self._fallPath =  {
        path=nil,
        pathIndex=0,
        throwMovePath=nil,
        x=0,
        y=0,
        target=0,
        getNextPoint= function(_data)
            if _data.pathIndex>#_data.path then
                return nil;
            elseif _data.pathIndex==#_data.path then
                _data.pathIndex = _data.pathIndex + 1;
                return self._slotPoints[_data.target];
            end
            _data.pathIndex = _data.pathIndex + 1;
            local column = _data.path[_data.pathIndex];
            return self._columnPoints[column];
        end,
        setTarget=function(_data,target)
            _data.target = target;
            _data.pathIndex = 0;
            _data.path = FallPath:getPath(target);
        end,
    };
    self._runingState._state = DRAGON_FALL_STATE.WAITING;
    self._fallEndPoint = self._columnPoints[1];
    --初始状态
    self._firstState = DRAGON_FALL_STATE.VERTICAL_FALL;
    
    --self._ballImage.color       = Color.New(1,1,1,0);
    self:StartFallBall();

    self._earnGold = 0;
    self._createItemIndex=0;
    --self._jumpTime = SI_GAME_CONFIG.DragonBallJumpTime;
    self:refreshItemList();
end

--点击开始按钮
function DragonMissionPanel:__onStartDragonMission()
    if not self._isCanStart then
        return false;
    end
    --开始按钮
    self.startBtnBG.gameObject:SetActive(false);
    --self.startButton.gameObject:SetActive(false);
    
    --请求进入龙珠关卡
    GlobalGame._gameControl:RequestDragonBallMission();
    --不需要自动开始了
    self._isAutoFall = false;
    self._isCanStart = false;
    --self:StartFallBall();
    return true;
end

function DragonMissionPanel:__imageGroupEventHandler(groupIndex)
    if groupIndex == FADE_IN_GROUP_INDEX.Fifth then
        self._isCanStart = true;
    end
end

function DragonMissionPanel:StartFallBall(_enterState)
    --得到路径
    self._fallPath:setTarget(self._fallDatas.fallTargets[self._fallIndex]);
    self:_setGameState(_enterState or self._firstState);
end

function DragonMissionPanel:refreshItemList()
    --[[
    local _serverData = self._fallDatas;
    if self._createItemIndex>= _serverData.itemCount then
        return;
    end
    for i=1,self.slotCount do
        if _serverData.items[i] then
            if _serverData.items[i].i8_type == SI_ITEM_TYPE.Item_Gold then
                self._slots[i]._goldValue.text =tostring(_serverData.items[self._createItemIndex+1].i32_count);
                self._slots[i]._ball.gameObject:SetActive(false);
                self._slots[i]._goldTrans.gameObject:SetActive(true);
            elseif _serverData.items[i].i8_type == SI_ITEM_TYPE.Item_Ball then
                self._slots[i]._ballValue.text = string.format("+ %d",_serverData.items[self._createItemIndex+1].i32_count);
                self._slots[i]._goldTrans.gameObject:SetActive(false);
                self._slots[i]._ball.gameObject:SetActive(true);
            end
        end
        self._createItemIndex =  self._createItemIndex + 1;
    end
    --]]
end

--每帧调用
function DragonMissionPanel:Update(_dt)

    --进入龙珠关卡过场控制
    self._fadeInImageGroups:update(_dt);
    
    self:DoStep(_dt);
    --结算
    self._balanceNumber:Update(_dt);

    --自动落下
    if self._isAutoFall then
        self._autoFallTime = self._autoFallTime - _dt;
        if self._autoFallTime<=0 then
            self:__onStartDragonMission();
        end
    end
end

function DragonMissionPanel:DoStep(_dt)
    if self._runingState._state == DRAGON_FALL_STATE.WAITING then
        
    elseif self._runingState._state == DRAGON_FALL_STATE.ENTER_SCENE then
        self:_enterScene(_dt);
    elseif self._runingState._state == DRAGON_FALL_STATE.VERTICAL_FALL then
        self:_verticalFall(_dt);
    elseif self._runingState._state == DRAGON_FALL_STATE.SEARCH_PATH then
        self:_searchPath(_dt);
    elseif self._runingState._state == DRAGON_FALL_STATE.BALANCE then
        self:_balance(_dt);
    elseif self._runingState._state == DRAGON_FALL_STATE.FLY_BALANCE then
        self:_flyBalance(_dt);
    elseif self._runingState._state == DRAGON_FALL_STATE.GAME_OVER then
        self:_gameOver(_dt);
    end
end


--出场
function DragonMissionPanel:_enterScene(_dt)
    self._runingState._a = self._runingState._a +  self._runingState._aSpeed*_dt;
    if self._runingState._a >= 1 then
        self._runingState._a = 1;
        --self._runingState._state = DRAGON_FALL_STATE.VERTICAL_FALL;
        self:_setGameState(DRAGON_FALL_STATE.VERTICAL_FALL);
--        --刷新球个数
--        self:_renewBallCount();
    end   
    self._ballImage.color       = Color.New(1,1,1,self._runingState._a);
end

function DragonMissionPanel:_setGameState(_state)
    self._runingState._state = _state;
    if _state == DRAGON_FALL_STATE.ENTER_SCENE then
        self._runingState._a        = 0;
        self._runingState._aSpeed   = 1.0/SI_GAME_CONFIG.DragonBallEnterSceneTime;
        self._runingState._runTime  = 0;
        self._ballImage.color       = Color.New(1,1,1,0);
        self._ball.localPosition    = self._beginFallBallPos;
        --self._jumpTime = SI_GAME_CONFIG.DragonBallJumpTime;
    elseif _state == DRAGON_FALL_STATE.VERTICAL_FALL then
        self._ball.localPosition    = self._beginFallBallPos;
        self._ballCount             =  self._ballCount - 1;
        self._runingState._aSpeed   = 1.0/SI_GAME_CONFIG.DragonBallEnterSceneTime;
        self._runingState._runTime  = 0;
        self._jumpTime = SI_GAME_CONFIG.DragonBallJumpTime;
    elseif _state == DRAGON_FALL_STATE.BALANCE then
        self._ballImage.color = Color.New(1,1,1,0);
    end
end

--垂直下落
function DragonMissionPanel:_verticalFall(_dt)
    self._runingState._runTime = self._runingState._runTime + _dt;
    local moveY = self._runingState._runTime*SI_GAME_CONFIG.DragonBallFallBeginSpeed + self._runingState._runTime*self._runingState._runTime*SI_GAME_CONFIG.DragonBallFallAddSpeed;
    local realY = self._beginFallBallPos.y - moveY;
    if realY< self._fallEndPoint.y then
        realY = self._fallEndPoint.y ;
        --切换成寻找路径状态
        self:_setGameState(DRAGON_FALL_STATE.SEARCH_PATH);
        self._fallPath.x = self._fallEndPoint.x;
        self._fallPath.y = realY;
        self:_playBallFallDownSound();
    end
    self._ball.localPosition = Vector3.New(self._fallEndPoint.x,realY,self._fallEndPoint.z);
end

function DragonMissionPanel:_playBallFallDownSound()
    MusicManager:PlayX(GlobalGame._gameObjManager:GetMusic(SI_MUSIC_TYPE.DragonBallFallDown));
end

--播放火焰燃烧
function DragonMissionPanel:_playFireBurnning()
    MusicManager:PlayX(GlobalGame._gameObjManager:GetMusic(SI_MUSIC_TYPE.FireBurnning)); 
end

function DragonMissionPanel:_searchPath(_dt)
    if self._fallPath.throwMovePath == nil then
        local nextPoint = self._fallPath:getNextPoint();
        if nextPoint == nil then
            self:_setGameState(DRAGON_FALL_STATE.BALANCE);
            self.slotStyles:fallIn(self._fallPath.target);
            --播放火焰燃烧声音
            self:_playFireBurnning();
            return;
        end
        self:_playBallFallDownSound();
        local topx =(nextPoint.x - self._fallPath.x)*3/9 + self._fallPath.x;
        local throwPath = ThrowPath.CreateWithTopX(self._fallPath.x,self._fallPath.y,nextPoint.x,nextPoint.y,topx);
        --self._fallPath.throwMovePath = ThrowMove.New(throwPath,self._fallPath,nextPoint,SI_GAME_CONFIG.DragonBallJumpTime);
        self._fallPath.throwMovePath = ThrowMove.New(throwPath,self._fallPath,nextPoint,self._jumpTime);
        self._jumpTime =  self._jumpTime + SI_GAME_CONFIG.DragonBallJumpDecayTime;
    else
        local x,y,isOver = self._fallPath.throwMovePath:Step(_dt);
        self._fallPath.x = x;
        self._fallPath.y = y;
        self._ball.localPosition = Vector3.New(x,y,0);
        if isOver then --本段结束
            self._fallPath.throwMovePath = nil;
        end
    end
end

function DragonMissionPanel:_gameOver(_dt)
--    coroutine.start(
--        function ()
--            coroutine.wait(0.5);
--            if not GlobalGame.isInGame then
--                return;
--            end
--            if self._ballCount<=0 then
--                if self._overHandler then
--                    self._overHandler(self._fallDatas.curGold, self._fallDatas._earnGold,self._fallDatas.stage);
--                    --GameObject.Destroy(self._Obj);
--                end
--            end
--        end
--    );
    self:_setGameState(DRAGON_FALL_STATE.WAITING);
    local tempFunc = function ()
        if self._ballCount<=0 then
            if self._overHandler then
                self._overHandler(self._fallDatas.curGold, self._fallDatas._earnGold,self._fallDatas.stage);
                --GameObject.Destroy(self._Obj);
            end
        end
    end
    GlobalGame._timerMgr:FixUpdateOnce(tempFunc,0.5);
end

--隐藏
function DragonMissionPanel:Hide()
    self.gameObject:SetActive(false);
end

--显示
function DragonMissionPanel:Show()
    self.gameObject:SetActive(true);
end

--结算
function DragonMissionPanel:_balance(_dt)
    --[[
    local target = self._fallPath.target;
    local item = self._fallDatas.items[target];
    if item.i8_type == SI_ITEM_TYPE.Item_Gold then
        self._earnGold = self._earnGold + item.i32_count;
    elseif item.i8_type == SI_ITEM_TYPE.Item_Ball then
        self._ballCount = self._ballCount + item.i32_count;
        self:_renewBallCount(item.i32_count);
    end
    --]]
    if self._ballCount<=0 then
        self:_setGameState(DRAGON_FALL_STATE.FLY_BALANCE);
        --self._balanceNumber:SetNumber(SI_BALANCE_TYPE.Common,30000,true,2,1.5,handler(self,self._reduceBalance));
        self._balanceNumber:SetNumber(SI_BALANCE_TYPE.Common,self._fallDatas.earnGold,true,2,2,handler(self,self._reduceBalance));
    else
        self:refreshItemList();
        self._fallIndex = self._fallIndex + 1;
        self:StartFallBall(DRAGON_FALL_STATE.ENTER_SCENE);
    end
end

--金币改变
function DragonMissionPanel:_reduceBalance(_isOver,_num)
    if _isOver then
        self:_setGameState(DRAGON_FALL_STATE.GAME_OVER);
    end
    --通知增加金币
    GlobalGame._eventSystem:DispatchEvent(SI_EventID.NotifyAddGold,_num);
end

function DragonMissionPanel:_flyBalance(_dt)
    --self._runingState._a = self._runingState._a + 0.03;
    --if self._runingState._a>1 then
    --    self._runingState._a = 1;
    --end
    --self._balanceText.color = Color.New(1,1,1,self._runingState._a);
    --[[
    self._textBeginY = self._textBeginY + 6;
    if self._textBeginY>self._textEndY then
        self._textBeginY = self._textEndY;
        self._runingState._state = DRAGON_FALL_STATE.GAME_OVER;
    end
    self._balanceText.transform.localPosition = Vector3.New(self._textBeginX,self._textBeginY,0);
    --]]
end

--设置球个数
function DragonMissionPanel:_setBallCount()
    --self._ballCountText.text = string.format("X%d",self._ballCount);
end


--更新球个数
function DragonMissionPanel:_renewBallCount(_addCount)
    --[[
    local function effect()
        local function fadeOut(_image,_ba,_ea,_sa)
            local _ca = _ba;
            while(_ca>_ea) do
                if not GlobalGame.isInGame then
                    return;
                end
                _image.color = Color.New(1,1,1,_ca);
                coroutine.wait(0.020);
                _ca =_ca + _sa;
            end
        end

        local function fadeIn(_image,_ba,_ea,_sa)
             local _ca = _ba;
             while(_ca<_ea) do
                _ca =_ca + _sa;
                if _ca>_ea then
                    _ca = _ea;
                end
                if not GlobalGame.isInGame then
                    return;
                end
                _image.color = Color.New(1,1,1,_ca);
                coroutine.wait(0.020);
             end
        end
        fadeOut(self._ballCountText,1,0.5,-0.03);
        self._ballCountText.text = string.format("X%d",self._ballCount);
        fadeIn(self._ballCountText,0.5,1,0.03);
    end

    coroutine.start(effect)
    if _addCount then
        local endY = self._addBallBeginPos.y + 25;
        local curY = self._addBallBeginPos.y;
        self._addBallText.text = string.format("+%d",_addCount);
        self._addBallTrans.gameObject:SetActive(true);
        local function flyAddText()
            while(true) do
                if not GlobalGame.isInGame then
                    return;
                end
                curY = curY + 1;
                if curY>endY then
                    self._addBallTrans.gameObject:SetActive(false);
                    break;
                end
                self._addBallTrans.localPosition = Vector3.New(self._addBallTrans.localPosition.x,curY,0);
                coroutine.wait(0.02);
            end
        end
        coroutine.start(flyAddText);
    end
    --]]
end



return DragonMissionPanel;