local FallStonePanel = GameRequire("SI_FallStonePanel");
local DragonMissionPanel = GameRequire("SI_DragonMissionPanel");
local AtlasNumber     = GameRequire("SI_AtlasNumber");

local AlertStaticPanel = GameRequire("SI_AlertStaticPanel");

local GamePanel = class("GamePanel");

local C_OneScale  = Vector3.New(1,1,1);
local C_ZeroPos   = Vector3.New(0,0,0);
local C_OnePos   = Vector3.New(1,1,1);
local C_NormalVector=Vector3.New(1,1,1);
local C_ZeroRotation = Quaternion.Euler(0,0,0);

function GamePanel:ctor(_gameControl)
    self.gameObject = nil;
    self.transform  = nil;
    self.gameControl= _gameControl;
    self._nameGroupCreator = {};


    self._caijinControl = {
        curCaiJin = 0,
        reduceSpeed = 0,
        fartureCaiJin=0,
        isChange = false;
        isReduce = false,
        changeSpeed = 0,
        minSpeed =0,
        maxSpeed =0,
        addSpeed =0,
        addSpeed2=0,
        waitTime =0,
        init = function(self,atlasNumber,gold)
            self.atlasNumber = atlasNumber;
            if gold and type(gold) =="number" then
                self.curCaiJin = gold;
                self.fartureCaiJin = gold;
                self.atlasNumber:SetNumber(gold);
            end
        end,
        addCaiJin = function(self,value)
            if value==0 then
                return 0;
            end
            self.isChange = true;
            self.fartureCaiJin = self.curCaiJin + value;
            if value>0 then
                self.isReduce = false;
            else
                self.isReduce = true;
            end
            self:_countSpeed(value);
        end,
        changeCaiJin = function(self,value)
            self:addCaiJin(value-self.curCaiJin);
        end,
        setCaiJin = function(self,caijin)
            self.curCaiJin = caijin;
            self.fartureCaiJin = caijin;
            self.atlasNumber = atlasNumber;
            self.atlasNumber:SetNumber(caijin); 
            self.isChange = false;           
        end,
        update = function(self,_dt)
            if not self.isChange then
                return ;
            end
            if self.waitTime>0 then
                self.waitTime = self.waitTime - _dt;
                return ;
            end

            local reduceNum = math.floor(self.changeSpeed*_dt);
            self.changeSpeed = self.changeSpeed + self.addSpeed *_dt;
            self.addSpeed = self.addSpeed - self.addSpeed2 * _dt;
            if self.isReduce then
                if self.changeSpeed>self.minSpeed then
                    self.changeSpeed = self.minSpeed;
                end
            else
                if self.changeSpeed<self.minSpeed then
                    self.changeSpeed = self.minSpeed;
                end
            end

            if self.isReduce then
                if reduceNum>-1 then
                    reduceNum = -1;
                end
            else
                if reduceNum<1 then
                    reduceNum = 1;
                end
            end 

            self.curCaiJin = self.curCaiJin + reduceNum;
            if self.isReduce then
                if self.curCaiJin<self.fartureCaiJin then
                    self.curCaiJin = self.fartureCaiJin;
                    self.isChange  = false;
                end
            else
                if self.curCaiJin>self.fartureCaiJin then
                    self.curCaiJin = self.fartureCaiJin;
                    self.isChange  = false;
                end
            end
            self.atlasNumber:SetNumber(self.curCaiJin);
        end,
        _countSpeed = function(self,_value)
            local absValue = math.abs(_value);
            absValue = absValue /SI_STAGE_DATA:getBet(0,0);
            --absValue = absValue /10000;
            local time=0.6;
--            --�����ٶ�
--            if absValue>100000000 then
--                time = time + 4.2 + 0.3*math.floor(absValue/100000000);
--            elseif absValue>10000000 then
--                time = time + 3.2 + 0.1*math.floor(absValue/10000000);
--            elseif absValue>1000000 then
--                time = time + 2.4 + 0.08*math.floor(absValue/1000000);
--            elseif absValue>100000 then
--                time = time + 1.8 + 0.06*math.floor(absValue/100000);
--            elseif absValue>10000 then
--                time = time + 1.3 + 0.05*math.floor(absValue/10000);
--            elseif absValue>1000 then
--                time = time + 0.9 + 0.04*math.floor(absValue/1000);
--            elseif absValue>100 then
--                time = time + 0.5 + 0.04*math.floor(absValue/100);
--            elseif absValue>10 then
--                time = time + 0.05*math.floor(absValue/10);
--            end

            --�����ٶ�
            if absValue>100000000 then
                time = time + 2.6 + 0.1*math.floor(absValue/100000000);
            elseif absValue>10000000 then
                time = time + 2.1 + 0.05*math.floor(absValue/10000000);
            elseif absValue>1000000 then
                time = time + 1.65 + 0.045*math.floor(absValue/1000000);
            elseif absValue>100000 then
                time = time + 1.25 + 0.04*math.floor(absValue/100000);
            elseif absValue>10000 then
                time = time + 0.9 + 0.035*math.floor(absValue/10000);
            elseif absValue>1000 then
                time = time + 0.6 + 0.03*math.floor(absValue/1000);
            elseif absValue>100 then
                time = time + 0.3 + 0.03*math.floor(absValue/100);
            elseif absValue>10 then
                time = time + 0.03*math.floor(absValue/10);
            end
            self.changeSpeed = _value / time;
            self.minSpeed   = self.changeSpeed/7;
            self.maxSpeed    = self.changeSpeed*2;
            self.addSpeed    = self.changeSpeed/time/1.8;
            self.addSpeed2    = self.addSpeed/time/5;
        end,
    };
end

function GamePanel:Init(transform)
    self.transform = transform;
    self.gameObject= transform.gameObject;

    --�ȳ�ʼ���Լ�
    self.leftPanel = transform:Find("LeftPanel");
    self.frontPanel = transform:Find("FrontPanel");
    self.frontLeftPanel = self.frontPanel:Find("LeftPanel");
    self.jumpStonePanel = self.frontPanel:Find("JumpStonePanel");
    self.numbers   = transform:Find("Numbers");
    self.numbersSprites = {};
    local count = self.numbers.childCount;
    local child = nil;
    local name  = nil;
    local child2= nil;
    local childCount2 = nil;
    local newSprites;
    local image;
    for i=1,count do
        child = self.numbers:GetChild(i-1);
        name = child.gameObject.name;
        self.numbersSprites[name] = {};
        childCount2 = child.childCount;
        newSprites = self.numbersSprites[name];
        for j=1,childCount2 do
            child2 = child:GetChild(j-1);
            image = child2:GetComponent("Image");
            if image then
                newSprites[child2.gameObject.name] = image.sprite;
            end
        end
    end

    self.fallStonePanel = FallStonePanel.New(self);
    self.dragonMissionPanel = DragonMissionPanel.New(self);
    self.fallStonePanel:Init(transform:Find("CommonMissionPanel"),self.jumpStonePanel);
    self.dragonMissionPanel:Init(transform:Find("DragonMissionPanel"),handler(self,self.DragonMissionOver));

    --logoλ��
    local logoPos = self.leftPanel:Find("Logo");            
    self.logoAnimate = GlobalGame._gameObjManager:GetEffectObj(SI_EFFECT_TYPE.Logo);
    self.logoAnimate:SetParent(logoPos);
    self.logoAnimate:SetLocalPosition(C_ZeroPos);
    self.logoAnimate:SetLocalScale(C_OneScale);
    

    local PlayerLogoOver;
--    PlayerLogoOver = function()
--        coroutine.start(
--            function()
--                local time = math.random(5,10);
--                coroutine.wait(time);
--                if GlobalGame.isInGame then
--                    self.logoAnimate:Disappear(PlayerLogoOver);
--                end
--            end
--        );
--    end
    PlayerLogoOver = function()
        local tempFunc = function()
            self.logoAnimate:Disappear(PlayerLogoOver);
        end
        local time = math.random(5,10);
        GlobalGame._timerMgr:FixUpdateOnce(tempFunc,time);
    end
--    local time = math.random(5,10);
--    GlobalGame._timerMgr:FixUpdateOnce(PlayerLogoOver,time);
    self.logoAnimate:Disappear(PlayerLogoOver);

    --�ؿ�����
    self.missionName = self.frontLeftPanel:Find("MissionName"):GetComponent("Image");
    --�ۻ���
    self.stockNumberLabel = self:CreateAtlasNumber(self.leftPanel:Find("StockNumber"),1);
    --���
    self.goldNumberLabel  = self:CreateAtlasNumber(self.leftPanel:Find("GoldNumber"),1);

    --�ʽ�ı�����ʼ��
    self._caijinControl:init(self.stockNumberLabel,0);


    --����������ʾ
    self._dragonTip = {
        transform = nil,
        gameObject= nil,
        tip1 = nil,
        tip2 = nil,
        handler = nil,
        curColor = Color.New(1,1,1,1),
        step = 0,
        runTime =0,
        init = function(self,transform)
            self.transform = transform;
            self.gameObject= transform.gameObject;
            self.tip1 = transform:Find("Tip1"):GetComponent("Image");
            self.tip2 = transform:Find("Tip2"):GetComponent("Image");
        end,
        show = function(self,handler)
            self.handler = handler;
            self.gameObject:SetActive(true);
            self.curColor.a = 1;
            self.tip1.color = self.curColor;
            self.tip2.color = self.curColor;
            self.runTime = 2;
            self.step    = 1;
        end,
        update= function(self,dt)
            if self.step==0 then
            elseif self.step==1 then
                self.runTime = self.runTime - dt;
                if self.runTime<=0 then
                    self.step = 2;
                    if self.handler then
                        self.handler();
                    end
                end
            elseif self.step==2 then
                self.curColor.a = self.curColor.a - dt;
                if self.curColor.a<=0 then
                    self.step=0;
                    self.curColor.a=0;
                    self.gameObject:SetActive(false);
                end
                self.tip1.color = self.curColor;
                self.tip2.color = self.curColor;
            end
        end,
    };
    --����ؿ���ʾ
    local dragonTip = self.transform:Find("DragonTip");
    self._dragonTip:init(dragonTip);

--    local testCaiJin = function()
--        self._caijinControl:changeCaiJin(99);
--        coroutine.wait(4);
--        self._caijinControl:changeCaiJin(990);
--        coroutine.wait(6);
--        self._caijinControl:changeCaiJin(9990);
--        coroutine.wait(8);
--        self._caijinControl:changeCaiJin(99990);
--        coroutine.wait(8);
--        self._caijinControl:changeCaiJin(999990);
--        coroutine.wait(8);
--        self._caijinControl:changeCaiJin(9999990);
--        coroutine.wait(8);
--        self._caijinControl:changeCaiJin(99999990);
--        coroutine.wait(8);
--        self._caijinControl:changeCaiJin(999999990);
--        coroutine.wait(8);
--        self._caijinControl:changeCaiJin(999990);
--        coroutine.wait(8);
--        self._caijinControl:changeCaiJin(990);
--        coroutine.wait(8);
--        self._caijinControl:changeCaiJin(0);
--    end

--    coroutine.start(testCaiJin);

    --��Ǯ�ı�
    GlobalGame._eventSystem:RegEvent(SI_EventID.NotifyChangeGold,self,self.NotifyChangeGold);
    --��Ǯ���Ӹı�
    GlobalGame._eventSystem:RegEvent(SI_EventID.NotifyAddGold,self,self.NotifyAddGold);
    --����ؿ��¼�
    GlobalGame._eventSystem:RegEvent(SI_EventID.NotifyDragonMission,self,self.NotifyStartDragonMission);
    --�ʽ�ı��¼�
    GlobalGame._eventSystem:RegEvent(SI_EventID.NotifyUICaiJin,self,self.NotifyCaijin);
    --֪ͨ������Ϣ
    GlobalGame._eventSystem:RegEvent(SI_EventID.NotifySceneInfo,self,self.NotifySceneInfo);
    --֪ͨ��ҽ����¼�
    GlobalGame._eventSystem:RegEvent(SI_EventID.NotifyUserEnter,self,self.NotifyUserEnter);
    --�յ��������Ŀ�ʼ��Ϸ����
    GlobalGame._eventSystem:RegEvent(SI_EventID.NotifyOpenStartGame,self,self.NotifyOpenStartGame);
    

    --Ĭ�ϵĳ���״̬
    self.sceneMode = SI_GAME_SCENE.Common;
end

function GamePanel:Update(_dt)
    
    self._caijinControl:update(_dt);
    --������ʾ����
    self._dragonTip:update(_dt);

    if self.fallStonePanel and self.sceneMode== SI_GAME_SCENE.Common then
        self.fallStonePanel:Update(_dt);
    end
    if self.dragonMissionPanel and self.sceneMode== SI_GAME_SCENE.Dragon then
        self.dragonMissionPanel:Update(_dt);
    end
end


function GamePanel:GetSprite(nameGroup,name)
    local spriteGroup = self.numbersSprites[nameGroup];
    if spriteGroup then
        return spriteGroup[name];
    end
    return nil;
end

function GamePanel:CreateAtlasNumber(transform,...)
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
    return atlasLabel;
end

function GamePanel:CreateAtlasNumberByIndex(transform,index,...)
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
    return atlasLabel;
end


function GamePanel:NotifyUserEnter(_eventId,_playerData)
    --��ҽ��
    --self.goldNumberLabel:SetNumber(_playerData._gold);
    self:NotifyChangeGold(_eventId,_playerData._gold);
end

--֪ͨ������Ϣ
function GamePanel:NotifySceneInfo(_eventId,_sceneInfo)
    if Util.isAndroidPlatform or Util.isApplePlatform then
        GameSetsBtnInfo.SetPlaySuonaPos(0,340,0);
    end
    local _num=GlobalGame._gameControl:retNum();

    if _sceneInfo.isClear==1 then
        --��Ҫ�����Ի���
        AlertStaticPanel.New(GlobalGame._tipLayer,SI_WORD[SI_WORD_CODE.CLEAR_RECORD]);
    else
        if _sceneInfo.isDragon==1 then
            --����ؿ�
            if _num==1 then
                self:PrepareDragonMission();
                self:_setStage(SI_DRAGON_STAGE);
            end

        else
            --��ͨ�ؿ�
            self:PrepareCommonMission();
            self:_setStage(_sceneInfo.stage);
        end
    end

    --���ùؿ���Ϣ
    self.fallStonePanel:NotifySceneInfo(_sceneInfo.stage,_sceneInfo.brickIndex);
end

function GamePanel:NotifyOpenStartGame(_eventId,_handler)
--    coroutine.start(
--        function ()
--            while(true) do
--                if not GlobalGame.isInGame then
--                    return;
--                end
--                if self.fallStonePanel:IsCanStartGame() then
--                    _handler();
--                    return ;
--                end
--                coroutine.wait(0.1);
--            end
--        end
--    );
    local tempFunc;
    tempFunc = function ()
        if self.fallStonePanel:IsCanStartGame() then
            _handler();
            return ;
        end
        GlobalGame._timerMgr:FixUpdateOnce(tempFunc,0.1);
    end
    GlobalGame._timerMgr:FixUpdateOnce(tempFunc,0.1);
end

function GamePanel:NotifyChangeGold(_eventId,_gold)
    if tonumber(_gold)>100000000 then
        self.goldNumberLabel:SetFontPadding(-4,false);
    else
        self.goldNumberLabel:SetFontPadding(-3,false);
    end
    self.goldNumberLabel:SetNumber(_gold);
end

function GamePanel:NotifyAddGold(_eventId,_gold)
    self.goldNumberLabel:AddNumber(_gold);
end

function GamePanel:NotifyCaijin(_eventId,_caijin)
    if tonumber(_caijin)>100000000 then
        self.stockNumberLabel:SetFontPadding(-4,false);
    else
        self.stockNumberLabel:SetFontPadding(-3,false);
    end
    self._caijinControl:changeCaiJin(_caijin);
    --self.stockNumberLabel:SetNumber(_caijin);
end

function GamePanel:NotifyStartDragonMission(_eventId,_data)
    --������֪ͨ��ʼ����
    self.dragonMissionPanel:StartStage(_data);
end

function GamePanel:_setStage(_stage)
    local _num=GlobalGame._gameControl:retNum();
    logYellow("_num==".._num)
    if _num~=1 then
        return
    end
    if self._stage==_stage then
        return ;
    end
    self._stage = _stage;
    self.missionName.sprite = GlobalGame._gameObjManager:GetDragonLevelImage(self._stage);
end

function GamePanel:SetStage(_stage)
    if self._stage==_stage then
        return ;
    end
    self._stage = _stage;
    self:_changeStage();
end

function GamePanel:_changeStage()
    local sprite = GlobalGame._gameObjManager:GetDragonLevelImage(self._stage);
    self.missionName.color = Color.New(1,1,1,1);
--    local function effect()
--        local function fadeOut(_image,_ba,_ea,_sa)
--             local _ca = _ba;
--             while(_ca>_ea) do
--                _image.color = Color.New(1,1,1,_ca);
--                coroutine.wait(0.020);
--                _ca =_ca + _sa;
--             end
--        end

--        local function fadeIn(_image,_ba,_ea,_sa)
--             local _ca = _ba;
--             while(_ca<_ea) do
--                _ca =_ca + _sa;
--                if _ca>_ea then
--                    _ca = _ea;
--                end
--                if IsNil(_image) then
--                    return;
--                end
--                _image.color = Color.New(1,1,1,_ca);
--                coroutine.wait(0.020);
--             end
--        end
--        fadeOut(self.missionName,1,0.3,-0.03);
--        self.missionName.sprite = sprite;
--        self.missionName:SetNativeSize();
--        fadeIn(self.missionName,0.3,1,0.03);
--        if self.sceneMode == SI_GAME_SCENE.Common then
--        else
--            --����״̬
--            --self.fallStonePanel:FreeState();
--        end
--    end
--    coroutine.start(effect);
    local function fadeIn(_image,_ba,_ea,_sa)
            local _ca = _ba;
            local func1;
            func1 = function()
                _ca =_ca + _sa;
                if _ca>_ea then
                    _ca = _ea;
                end
                _image.color = Color.New(1,1,1,_ca);
                if(_ca<_ea) then
                    GlobalGame._timerMgr:FixUpdateOnce(func1,0.02);
                else
                    
                end
            end
            func1();
    end
    local function fadeOut(_image,_ba,_ea,_sa)
        local _ca = _ba;
        local func1;
        func1 = function()
            _image.color = Color.New(1,1,1,_ca);
            _ca =_ca + _sa;
            if(_ca>_ea) then
                GlobalGame._timerMgr:FixUpdateOnce(func1,0.02);
            else
                local funcFadeIn=function()
                    self.missionName.sprite = sprite;
                    self.missionName:SetNativeSize();
                    fadeIn(self.missionName,0.3,1,0.03);
                end
                GlobalGame._timerMgr:FixUpdateOnce(funcFadeIn,0.02);    
            end
        end
        func1();
    end
    fadeOut(self.missionName,1,0.3,-0.03);
end

function GamePanel:EnterDragonMission(isAutoFallDown)
    self:PrepareDragonMission(isAutoFallDown);
end

--����ؿ�����
function GamePanel:DragonMissionOver(curGold,addGold,stage)
    --��������ؿ�
    self.dragonMissionPanel:Hide();
    --ͬ�����
    self.goldNumberLabel:SetNumber(curGold);
    
    self.sceneMode = SI_GAME_SCENE.Common;
    self:SetStage(1);
    --׼����ͨ�ؿ�
    self:PrepareCommonMission();
    --����ؿ�����
    self.fallStonePanel:NotifyDragonMissionOver(true);
end

--׼������ؿ�
function GamePanel:PrepareDragonMission(isAutoFallDown)
    local startDragonMission = function()
        local bet = self.gameControl:GetBetMoreTimes();
        self.dragonMissionPanel:InitLoadData(bet,isAutoFallDown);
        self.dragonMissionPanel:Show();
        self.sceneMode = SI_GAME_SCENE.Dragon;
        self:SetStage(SI_DRAGON_STAGE);
    end

    --����һ�����ɻ�������ؿ�
    self._dragonTip:show(startDragonMission);
end

--׼������ؿ�
function GamePanel:PrepareCommonMission()
    self.sceneMode = SI_GAME_SCENE.Common;
end


--���ٶ��󴰿�
function GamePanel:Destroy()
    self.fallStonePanel:Destroy();
end

return GamePanel;
