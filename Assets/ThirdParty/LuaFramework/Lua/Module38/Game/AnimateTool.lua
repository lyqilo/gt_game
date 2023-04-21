local _AnimateDefine = GameRequire__("AnimateDefine");

local _CLuaAnimateAction = class("_CLuaAnimateAction");

function _CLuaAnimateAction:ctor(animateControl)
--    self.gameObject = gameObject;
--    self.transform  = gameObject.transform;
--    self.shower     = shower;
    self.isReverse  = false;
    self.animateControl = animaterControl;
    self.isEnd      = false;
    self.overTime   = 0;  --结束了多久
    self.useTime    = 0;
    self.dependentAnimate = nil;
    self.waitTime   = 0;
    self.needWaitTime = 0;
    self.loop       = 1;
    self.dependIndex= -1;
    self.type = nil;
end

function _CLuaAnimateAction:GameObject()
    return self.animateControl:GameObject();
end

function _CLuaAnimateAction:Transform()
    return self.animateControl:Transform();
end

function _CLuaAnimateAction:SetAnimateControl(animateControl)
    self.animateControl = animateControl;
end


function _CLuaAnimateAction:SetType(_type)
    self.type = _type;
end

function _CLuaAnimateAction:Init(_animateData)
    
end

function _CLuaAnimateAction:SetDependent(index)
    self.dependIndex = index;
end

function _CLuaAnimateAction:Dependent()
    return self.dependIndex;
end

--每帧执行
function _CLuaAnimateAction:Update(_dt)

end

--设置循环次数
function _CLuaAnimateAction:SetLoop(_loop)
    self.loop       = _loop;
end

--设置等待时间
function _CLuaAnimateAction:SetWaitTime(waitTime)
    self.waitTime = waitTime;
    self.needWaitTime = waitTime;
end

--运行时间
function _CLuaAnimateAction:GetRunTime()

end

--隐藏
function _CLuaAnimateAction:Hide()
    --self.shower.enabled = false;
    self.animateControl:Hide();
end

--显示
function _CLuaAnimateAction:Show()
    --self.shower.enabled = true;
    self.animateControl:Show();
end

--回播
function _CLuaAnimateAction:Reverse()
    local newAnimate = self:Copy();
    return newAnimate;
end

--拷贝自己
function _CLuaAnimateAction:Copy()
    local newAnimate = clone(self);
    return newAnimate;
end

--倒播
function _CLuaAnimateAction:ReversePlay()
    self.isReverse  = true;
    self.isEnd      = false;
end

function _CLuaAnimateAction:NormalPlay()
    self.isReverse  = false;
    self.isEnd      = false;
end

--开始
function _CLuaAnimateAction:OnStart(...)
    self.isEnd = false;
    self.overTime = 0;
    self.useTime  = 0;
    self.waitTime = self.needWaitTime;
end

--结束
function _CLuaAnimateAction:OnEnd()
    self.isEnd      = true;
    self.isReverse  = false;
end

--真实的执行时间
function _CLuaAnimateAction:RealUpdateTime(_updateTime,_leftTime)
    self.useTime  = self.useTime + _updateTime;
    self.overTime = self.overTime + _leftTime;
--    if self.isEnd then

--    end
end

--依赖其他的都动画
function _CLuaAnimateAction:Dependent(_animate)
    self.dependentAnimate = _animate;
end

--开始
function _CLuaAnimateAction:IsEnd()
    if self.dependentAnimate then
        return self.dependentAnimate:IsEnd();
    end
    return self.isEnd;
end

local _CLuaDelayAnimateAction = class("_CLuaDelayAnimateAction",_CLuaAnimateAction);
function _CLuaDelayAnimateAction:ctor(...)
    _CLuaDelayAnimateAction.super.ctor(self,...);
end

function _CLuaDelayAnimateAction:Init(_animateData)
    --开始位置
    self.delayTime = _animateData.delayTime;
    self.runTime  = 0;
end

--开始
function _CLuaDelayAnimateAction:OnStart(_go)
    _CLuaDelayAnimateAction.super.OnStart(self,_go);
    self.overTime = 0;
    self.useTime  = 0;
    self.runTime  = 0;
end

function _CLuaDelayAnimateAction:ReversePlay()
    _CLuaDelayAnimateAction.super.ReversePlay(self);
end


--每帧执行
function _CLuaDelayAnimateAction:Update(_dt)
    if self.isReverse then
        return self:_reverseUpdate(_dt);
    else
        return self:_normalUpdate(_dt);
    end
end

function _CLuaDelayAnimateAction:_normalUpdate(_dt)
    local leftTime=_dt;
    if self.isEnd then
        return leftTime;
    end
    self.runTime = self.runTime + _dt;
    --剩余时间，实际运行时间
    if self.runTime< self.delayTime then
        leftTime = 0;
    else
        leftTime = self.runTime - self.delayTime;
        self:OnEnd();
    end
    return leftTime;
end

function _CLuaDelayAnimateAction:_reverseUpdate(_dt)
    local leftTime=_dt;
    if self.isEnd then
        return leftTime;
    end
    --倒播
    if self.overTime>0  then
        self.overTime = self.overTime - _dt;
    end 
    if self.overTime<0 then
        _dt = - self.overTime;
    else
        return 0;
    end
    self.runTime = self.runTime - _dt;
    
    --剩余时间，实际运行时间
    if self.runTime>0 then
        leftTime = 0;
    else
        leftTime = - self.runTime ;
        self:OnEnd();
    end
    return leftTime;
end


local _CLuaLocalMoveAnimateAction = class("_CLuaLocalMoveAnimateAction",_CLuaAnimateAction);

--
function _CLuaLocalMoveAnimateAction:ctor(...)
    _CLuaLocalMoveAnimateAction.super.ctor(self,...);
end

function _CLuaLocalMoveAnimateAction:Init(_animateData)
    --开始位置
    self._beginPos = _animateData.beginPos;
    self._endPos   = _animateData.endPos;
    self._moveSpeed= (self._endPos - self._beginPos)/_animateData.moveTime;
    self._totalTime= _animateData.moveTime;
    self._runTime  = 0;
end


--倒播
function _CLuaLocalMoveAnimateAction:Reverse()
    local newAnimate = self:Copy();
    newAnimate._beginPos = self._endPos;
    newAnimate._endPos   = self._beginPos;
    newAnimate._totalTime= self._totalTime;
    newAnimate._moveSpeed= Vector3.Zero() - self._moveSpeed;
    newAnimate._runTime  = 0;
    return newAnimate;
end

--开始
function _CLuaLocalMoveAnimateAction:OnStart(_go)
    _CLuaLocalMoveAnimateAction.super.OnStart(self,_go);
    self:Transform().localPosition = self._beginPos;
    self.overTime = 0;
    self.runTime  = 0;
end

--每帧执行
function _CLuaLocalMoveAnimateAction:Update(_dt)
    if self.isReverse then
        return self:_reverseUpdate(_animateControl,_dt);
    else
        return self:_normalUpdate(_animateControl,_dt);
    end
end

function _CLuaLocalMoveAnimateAction:_normalUpdate(_dt)
    local leftTime=_dt;
    if self.isEnd then
        return leftTime;
    end
    self._runTime = self._runTime + _dt;
    --剩余时间，实际运行时间
    if self._runTime< self._totalTime then
        leftTime = 0;
        self:Transform().localPosition = self._beginPos + self._moveSpeed * self._runTime;
    else
        leftTime = self._runTime - self._totalTime;
        self:Transform().localPosition = self._endPos; 
        self:OnEnd();
    end
    return leftTime;
end

function _CLuaLocalMoveAnimateAction:_reverseUpdate(_dt)
    local leftTime=_dt;
    if self.isEnd then
        return leftTime;
    end
    --倒播
    if self.overTime>0  then
        self.overTime = self.overTime - _dt;
    end 
    if self.overTime<0 then
        _dt = - self.overTime;
    else
        return 0;
    end
    self.runTime = self._runTime - _dt;
    
    --剩余时间，实际运行时间
    if self._runTime>0 then
        leftTime = 0;
        self:Transform().localPosition = self._beginPos + self._moveSpeed * self._runTime;
    else
        leftTime = - self._runTime ;
        self:Transform().localPosition = self._beginPos; 
        self:OnEnd();
    end
    return leftTime;
end


local _CLuaImageFrameAnimateAction = class("_CLuaImageFrameAnimateAction",_CLuaAnimateAction);

--
function _CLuaImageFrameAnimateAction:ctor(...)
    _CLuaImageFrameAnimateAction.super.ctor(self,...);
    self.waitTime = 0;
    self.sprites  = {}; --序列帧动画
    self.curFrame = 1;  --当前帧
    self.interval = 0;  --时间间隔
    self.loop     = -1;  --循环次数   -1 : 无线循环
    self.curLoop  = 0;
    self.defaultSprite = nil;
    self.realDefaultSprite = nil;
    --self.max
    self.runTime        = 0;
end

function _CLuaImageFrameAnimateAction:Init(_animateData,_spriteCreator)
    --开始位置
    self.waitTime = _animateData.waitTime or 0;
    self.needWaitTime = self.waitTime;
    self.sprites  = {}; --序列帧动画
    self.curFrame = 1;  --当前帧
    self.interval = 0.5;  --时间间隔
    self.loop     = 1 or -1;  --循环次数   -1 : 无线循环
    self.curLoop  = 0;
    self.maxFrameCount = 0;
    self.runTime  = 0;
    self.interval = _animateData.interval;
    self.isCustomSize = false;
    self.isRaycastTarget = _animateData.isRaycastTarget or false;

    self.restartInterval = _animateData.restartInterval or _animateData.interval;
    local abFileName = _animateData.abfileName;
    local function loadSprite(_animateData,frameIndex)
        local sprite = nil;
        if frameIndex == -1 then
        else
            local str =string.format(_animateData.format, frameIndex);
            sprite = _spriteCreator(abFileName,str);
        end
        return sprite;
    end
    --local transform = self:Transform();
    local frameCount = _animateData.customFrames and #_animateData.customFrames or 0;
    local sprite;
    local frameMin = 0;
    local frameIndex;
    if _animateData.frameMin then
        frameMin = _animateData.frameMin;
    end
    if frameCount>0 then
        --自定义帧率
        for i=1,frameCount do
            frameIndex = _animateData.customFrames[i];
            sprite = loadSprite(_animateData,frameIndex);
            if frameIndex == _animateData.defaultFrame then
                self.realDefaultSprite = sprite;
            end
            self.maxFrameCount = self.maxFrameCount + 1;
            self.sprites[self.maxFrameCount] = sprite;
        end
    else
        frameCount = _animateData.realFrameMax or 9999;
        frameIndex = _animateData.frameBeginIndex;
        for i=1,_animateData.frameCount do
            if frameIndex< frameMin then
                frameIndex = frameMin;
            end
            if _animateData.frameMax then
                --最大的索引
                if frameIndex>_animateData.frameMax then
                    frameIndex = frameMin;
                end
            end
            sprite = loadSprite(_animateData,frameIndex);
            if frameIndex == _animateData.defaultFrame then
                self.realDefaultSprite = sprite;
            end
            self.maxFrameCount = self.maxFrameCount + 1;
            self.sprites[self.maxFrameCount] = sprite;
            frameIndex = frameIndex + _animateData.frameInterval;
        end
    end
    if _animateData.isCorrentSize then
        if _animateData.size then
            --local rect = self.transform:GetComponent("RectTransform");
            --rect.sizeDelta = Vector2.New(animateData.size.x,animateData.size.y);
            self.sizeDelta = Vector2.New(_animateData.size.x,_animateData.size.y);
            self.isCustomSize = true;
        else
            self.isCustomSize = false;
        end
    else
        self.isCustomSize = true;
    end
    --是否还原显示
    self.isReverseShow = _animateData.isReverseShow or false;
    --是否删除sprite
    self.isNullSprite  = _animateData.isNullSprite or false;
end

--设置成当前真
function _CLuaImageFrameAnimateAction:OnStart(_go,...)
    _CLuaImageFrameAnimateAction.super.OnStart(self,...);

    self.gameObject     = _go;
    self.transform      = _go.transform;

    self.isAddImage = false;

    self.overTime       = 0;
    self.useTime        = 0;
    self.runTime        = 0;
    if self.waitTime==0 then
        self:_startPlay();
    elseif self.realDefaultSprite then
        self:_setSprite(self.realDefaultSprite);
    end
end

function _CLuaImageFrameAnimateAction:_setSprite(sprite)
    local image = self.gameObject:GetComponent(ImageClassType);
    if not image then
 
    else
        image.sprite = sprite;
    end
end

function _CLuaImageFrameAnimateAction:_startPlay()
    local image = self.gameObject:GetComponent(ImageClassType);
    if not image then
        image = self.gameObject:AddComponent(ImageClassType);
        self.isAddImage = true;
        self.defaultSprite = nil;
    else
        self.isAddImage = false;
        self.defaultSprite = image.sprite;
    end
    self.curFrame = 1;
    self.runTime  = 0;
    image.enabled = true;
    --图片组建
    self.imageComponent = image;
    image.raycastTarget = self.isRaycastTarget;
    if self.isCustomSize then
        local rect = self.transform:GetComponent("RectTransform");
        rect.sizeDelta = self.sizeDelta;
    end
    self:SetFrame(self.curFrame);
end

function _CLuaImageFrameAnimateAction:OnEnd()
    _CLuaImageFrameAnimateAction.super.OnEnd(self);
    if self.isReverseShow then
        if self.isAddImage then
            if not IsNil(self.imageComponent) then
                --销毁组件
                Object.Destroy(self.imageComponent);
            end
        else
            if self.isNullSprite then
                self.imageComponent.sprite = nil;
                self.imageComponent.enabled = false;
            else
                --还原成默认图片
                self.imageComponent.sprite = self.defaultSprite;
                if not self.isCustomSize then
                    self.imageComponent:SetNativeSize();
                end
            end
        end
    else
        if self.isNullSprite then
            self.imageComponent.enabled = false;
        end
    end
end

--设置循环次数
function _CLuaImageFrameAnimateAction:SetLoop(_loop)
    self.loop = _loop;
end

--每帧执行
function _CLuaImageFrameAnimateAction:Update(_dt)
    if self.isReverse then
        return self:_reverseUpdate(_dt);
    else
        return self:_normalUpdate(_dt);
    end
end

--正常播放
function _CLuaImageFrameAnimateAction:_normalUpdate(_dt)
    local leftTime = _dt;
    if self.isEnd then
        return leftTime;
    end
    if self.waitTime>0 then
        self.waitTime = self.waitTime  - _dt;
        if self.waitTime<0 then
            leftTime =  0 - self.waitTime;
            self.waitTime = 0;
            self:_startPlay();
            return self:Update(leftTime);
        else
            leftTime = 0;
        end
        return leftTime;
    end
    self.runTime = self.runTime + _dt;
    local interval;
    if self.curFrame == self.maxFrameCount then
        interval = self.restartInterval;
    else
        interval = self.interval;
    end
--    do
--        leftTime = 0;
--        return leftTime;
--    end
    leftTime = 0;
    while(self.runTime>= interval) do
        self.runTime = self.runTime - interval;
        self.curFrame =  self.curFrame + 1;
        if self.curFrame>= self.maxFrameCount + 1 then
            if self.loop == -1 then
            elseif self.curLoop < self.loop-1 then
                self.curLoop = self.curLoop + 1;
            else
                self.curLoop = self.loop;
                leftTime = self.runTime;
                self.runTime = 0;
                self:OnEnd();
                break;
            end
        end 
        self:SetFrame(self.curFrame);
        if self.curFrame == self.maxFrameCount then
            interval = self.restartInterval;
        else
            interval = self.interval;
        end
    end
    return leftTime;
end

function _CLuaImageFrameAnimateAction:_reverseUpdate(_dt)
    --倒播
    if self.overTime>0  then
        self.overTime = self.overTime - _dt;
    end 
    if self.overTime<0 then
        _dt = - self.overTime;
    else
        return 0;
    end   
    local interval;
    self.runTime = self.runTime - _dt; 
    while(self.runTime<=0) do
        self.curFrame =  self.curFrame - 1;
        self:SetFrame(self.curFrame);
        if self.curFrame <= 1 then
            if self.loop == -1 then
            elseif self.curLoop >0 then
                self.curLoop = self.curLoop - 1;
            else
                leftTime = -self.runTime;
                self.runTime = 0;
                self:OnEnd();
                break;
            end
        end 
        if self.curFrame == 1 then
            interval = self.interval;
        else
            interval = self.restartInterval;
        end
        self.runTime = self.runTime + interval;
    end
    return leftTime;
end

--设置当前帧
function _CLuaImageFrameAnimateAction:SetFrame(_frame)
    if _frame> self.maxFrameCount then
        _frame = 1;
        self.curFrame = _frame;
    end
    if _frame<1 then
        _frame = self.maxFrameCount;
        self.curFrame = _frame;
    end
    local sprite = self.sprites[_frame];
    if sprite then
        --显示
        self:Show();
        self.imageComponent.sprite = sprite;
        if not self.isCustomSize then
            self.imageComponent:SetNativeSize();
        end
    else
        --隐藏
        self:Hide();
    end
end

function _CLuaImageFrameAnimateAction:ReversePlay()
    _CLuaImageFrameAnimateAction.super.ReversePlay(self);
    self:SetFrame(self.curFrame);
end




local _CLuaSpriteRendererFrameAnimateAction = class("_CLuaSpriteRendererFrameAnimateAction",_CLuaAnimateAction);

--
function _CLuaSpriteRendererFrameAnimateAction:ctor(...)
    _CLuaSpriteRendererFrameAnimateAction.super.ctor(self,...);
    self.waitTime = 0;
    self.needWaitTime = 0;
    self.sprites  = {}; --序列帧动画
    self.curFrame = 1;  --当前帧
    self.interval = 0;  --时间间隔
    self.loop     = -1;  --循环次数   -1 : 无线循环
    self.curLoop  = 0;
    self.defaultSprite = nil;
    self.realDefaultSprite = nil;
    self.runTime        = 0;
    --self.max
end

function _CLuaSpriteRendererFrameAnimateAction:Init(_animateData,_spriteCreator)
    --开始位置
    self.waitTime = _animateData.waitTime or 0;
    self.needWaitTime = self.waitTime;
    self.sprites  = {}; --序列帧动画
    self.curFrame = 1;  --当前帧
    self.interval = 0.5;  --时间间隔
    self.loop     = 1 or -1;  --循环次数   -1 : 无线循环
    self.curLoop  = 0;
    self.maxFrameCount = 0;
    self.runTime  = 0;
    self.interval = _animateData.interval;
    self.isCustomSize = false;
    self.isRaycastTarget = _animateData.isRaycastTarget or false;

    self.restartInterval = _animateData.restartInterval or _animateData.interval;
    local frameMin = 0;
    if _animateData.frameMin then
        frameMin = _animateData.frameMin;
    end
    local abFileName = _animateData.abfileName;
    local function loadSprite(_animateData,frameIndex)
        local sprite = nil;
        if frameIndex == -1 then
        else
            local str =string.format(_animateData.format, frameIndex);
            sprite = _spriteCreator(abFileName,str);
        end
        return sprite;
    end
    --local transform = self:Transform();
    local frameCount = _animateData.customFrames and #_animateData.customFrames or 0;
    local sprite;
    local frameIndex;
    if frameCount>0 then
        --自定义帧率
        for i=1,frameCount do
            frameIndex = _animateData.customFrames[i];
            sprite = loadSprite(_animateData,frameIndex);
            if frameIndex == _animateData.defaultFrame then
                self.realDefaultSprite = sprite;
            end
            self.maxFrameCount = self.maxFrameCount + 1;
            self.sprites[self.maxFrameCount] = sprite;
        end
    else
        frameCount = _animateData.realFrameMax and _animateData.realFrameMax or 9999;
        frameIndex = _animateData.frameBeginIndex;
        for i=1,_animateData.frameCount do
            if frameIndex< frameMin then
                frameIndex = frameMin;
            end
            if _animateData.frameMax then
                --最大的索引
                if frameIndex>_animateData.frameMax then
                    frameIndex = frameMin;
                end
            end
            sprite = loadSprite(_animateData,frameIndex);
            if frameIndex == _animateData.defaultFrame then
                self.realDefaultSprite = sprite;
            end
            self.maxFrameCount = self.maxFrameCount + 1;
            self.sprites[self.maxFrameCount] = sprite;
            frameIndex = frameIndex + _animateData.frameInterval;
        end
    end

    if _animateData.isCorrentSize then
        if _animateData.size then
            --local rect = self.transform:GetComponent("RectTransform");
            --rect.sizeDelta = Vector2.New(animateData.size.x,animateData.size.y);
            self.sizeDelta = Vector2.New(_animateData.size.x,_animateData.size.y);
            self.isCustomSize = true;
        else
            self.isCustomSize = false;
        end
    else
        self.isCustomSize = true;
    end

    --是否还原显示
    self.isReverseShow = _animateData.isReverseShow or false;
    --是否删除sprite
    self.isNullSprite  = _animateData.isNullSprite or false;
end

--设置成当前真
function _CLuaSpriteRendererFrameAnimateAction:OnStart(_go,...)
    _CLuaSpriteRendererFrameAnimateAction.super.OnStart(self,...);

    self.gameObject     = _go;
    self.transform      = _go.transform;
    self.isAddSpriteRenderer = false;
    self.overTime       = 0;
    self.useTime        = 0;
    self.runTime        = 0;
    if self.waitTime==0 then
        self:_startPlay();
    else
        if self.realDefaultSprite then
            self:_setSprite(self.realDefaultSprite);
        end
    end
end

function _CLuaSpriteRendererFrameAnimateAction:_setSprite(sprite)
    local spriteRenderer = self.gameObject:GetComponent(SpriteRendererClassType);
    if not spriteRenderer then
 
    else
        spriteRenderer.sprite = sprite;
    end
end

function _CLuaSpriteRendererFrameAnimateAction:_startPlay()
    local spriteRenderer = self.gameObject:GetComponent(SpriteRendererClassType);
    if not spriteRenderer then
        spriteRenderer = self.gameObject:AddComponent(SpriteRendererClassType);
        self.isAddSpriteRenderer = true;
        self.defaultSprite = nil;
    else
        self.isAddSpriteRenderer = false;
        self.defaultSprite = spriteRenderer.sprite;
    end

    --图片组建
    self.spriteRendererComponent = spriteRenderer;

    if self.isCustomSize then
        local rect = self.transform:GetComponent("RectTransform");
        rect.sizeDelta = self.sizeDelta;
    end
    self.curFrame = 1;
    self.runTime  = 0;
    self:SetFrame(self.curFrame);
end

function _CLuaSpriteRendererFrameAnimateAction:OnEnd()
    _CLuaSpriteRendererFrameAnimateAction.super.OnEnd(self);
--    local isLog = false;
--    if self.type == G_GlobalGame.Enum_AnimateStyle.Effect_Boss_Dead_2 then
--        isLog = true;
--    end
--    local log =function(str)
--        if not isLog then
--            return ;
--        end
--        error(str);
--    end
    if self.isReverseShow then
        if self.isAddSpriteRenderer then
            if not IsNil(self.spriteRendererComponent) then
                --销毁组件
                Object.Destroy(self.spriteRendererComponent);
            end
        else
            if self.isNullSprite then
                self.spriteRendererComponent.sprite = nil;
            else
                --还原成默认图片
                self.spriteRendererComponent.sprite = self.defaultSprite;
            end
        end
    else
        if self.isNullSprite then
            self.spriteRendererComponent.sprite = nil;
        end
    end
end

--设置循环次数
function _CLuaSpriteRendererFrameAnimateAction:SetLoop(_loop)
    self.loop = _loop;
end

--每帧执行
function _CLuaSpriteRendererFrameAnimateAction:Update(_dt)
    if self.isReverse then
        return self:_reverseUpdate(_dt);
    else
        return self:_normalUpdate(_dt);
    end
end

--正常播放
function _CLuaSpriteRendererFrameAnimateAction:_normalUpdate(_dt)
    local leftTime = _dt;
    if self.isEnd then
        return leftTime;
    end
    if self.waitTime>0 then
        self.waitTime = self.waitTime  - _dt;
        if self.waitTime<0 then
            leftTime =  0 - self.waitTime;
            self.waitTime = 0;
            self:_startPlay();
            return self:Update(leftTime);
        else
            leftTime = 0;
        end
        return leftTime;
    end
    self.runTime = self.runTime + _dt;
    local interval;
    if self.curFrame == self.maxFrameCount then
        interval = self.restartInterval;
    else
        interval = self.interval;
    end
    leftTime = 0;
    while(self.runTime>= interval) do
        self.runTime = self.runTime - interval;
        self.curFrame =  self.curFrame + 1;
        if self.curFrame>= self.maxFrameCount + 1 then
            if self.loop == -1 then
            elseif self.curLoop < self.loop-1 then
                self.curLoop = self.curLoop + 1;
            else
                self.curLoop = self.loop;
                leftTime = self.runTime;
                self.runTime = self.interval;
                self:OnEnd();
                break;
            end
        end 
        self:SetFrame(self.curFrame);
        if self.curFrame == self.maxFrameCount then
            interval = self.restartInterval;
        else
            interval = self.interval;
        end
    end
    return leftTime;
end

function _CLuaSpriteRendererFrameAnimateAction:_reverseUpdate(_dt)
    --倒播
    if self.overTime>0  then
        self.overTime = self.overTime - _dt;
    end 
    if self.overTime<0 then
        _dt = - self.overTime;
    else
        return 0;
    end   
    local interval;
    self.runTime = self.runTime - _dt; 
    while(self.runTime<=0) do
        self.curFrame =  self.curFrame - 1;
        if self.curFrame <= 0 then
            if self.loop == -1 then
            elseif self.curLoop >0 then
                self.curLoop = self.curLoop - 1;
            else
                leftTime = -self.runTime;
                self.runTime = 0;
                self:OnEnd();
                break;
            end
        end
        self:SetFrame(self.curFrame); 
        if self.curFrame == 1 then
            interval = self.restartInterval;
        else
            interval = self.interval;
        end
        self.runTime = self.runTime + interval;
    end
    return leftTime;
end

--设置当前帧
function _CLuaSpriteRendererFrameAnimateAction:SetFrame(_frame)
    if _frame> self.maxFrameCount then
        _frame = 1;
        self.curFrame = _frame;
    end
    if _frame<1 then
        _frame = self.maxFrameCount;
        self.curFrame = _frame;
    end
    local sprite = self.sprites[_frame];
    if sprite then
        --显示
        self:Show();
        self.spriteRendererComponent.sprite = sprite;
    else
        --隐藏
        self:Hide();
    end
end

function _CLuaSpriteRendererFrameAnimateAction:ReversePlay()
    _CLuaSpriteRendererFrameAnimateAction.super.ReversePlay(self);
    self:SetFrame(self.curFrame);
end


--淡入
local _CLuaFadeInAnimateAction = class("_CLuaFadeInAnimateAction",_CLuaAnimateAction)

function _CLuaFadeInAnimateAction:ctor(...)
    _CLuaFadeInAnimateAction.super.ctor(self,...);
end

function _CLuaFadeInAnimateAction:Init(_animateData)

end

function _CLuaFadeInAnimateAction:Update(_dt)

end

--淡出
local _CLuaFadeOutAnimateAction = class("_CLuaFadeOutAnimateAction",_CLuaAnimateAction)

function _CLuaFadeOutAnimateAction:ctor(...)
    _CLuaFadeOutAnimateAction.super.ctor(self,...);
end

function _CLuaFadeOutAnimateAction:Init(_animateData)

end

function _CLuaFadeOutAnimateAction:Update(_dt)

end


--动画单元
local _CLuaAnimateUnit = class("_CLuaAnimateUnit");

function _CLuaAnimateUnit:ctor()
    self._animateActions = {};
    self._actionCount    = 0;
    self._useTime        = 0;
    self.isReverse       = false;
    self._animateControl = nil;
end

--初始化动画
function _CLuaAnimateUnit:Init()

end

--开始播放
function _CLuaAnimateUnit:Play(_go)
    local count = self._actionCount;
    local action;
    for i=1,count do
        action = self._animateActions[i];
        action:OnStart(_go);
    end
    self._useTime = 0;
    self.isReverse       = false;
end

--倒播
function _CLuaAnimateUnit:ReversePlay()
    local count = self._actionCount;
    local action;
    for i=1,count do
        action = self._animateActions[i];
        action:ReversePlay();
    end 
    self.isReverse       = true;   
end

function _CLuaAnimateUnit.CreateAnimateAction(_animateData,_spriteCreator)
    local animateAction;
    if _animateData then
        local AnimateKind = _AnimateDefine.Enum_AnimateKind;
         
        if _animateData.animateType == AnimateKind.ImageFrameAnimate then
            animateAction = _CLuaImageFrameAnimateAction.New();
            animateAction:Init(_animateData,_spriteCreator);
        elseif _animateData.animateType == AnimateKind.SpriteFrameAnimate then
            animateAction = _CLuaSpriteRendererFrameAnimateAction.New();
            animateAction:Init(_animateData,_spriteCreator);
        elseif _animateData.animateType == AnimateKind.DelayTime then
            animateAction = _CLuaDelayAnimateAction.New();
            animateAction:Init(_animateData);
        elseif _animateData.animateType == AnimateKind.FadeOutAnimate then
            
        elseif _animateData.animateType == AnimateKind.FadeInAnimate then 
            
        elseif _animateData.animateType == AnimateKind.LocalScaleAnimate then  
            
        elseif _animateData.animateType == AnimateKind.LocalMoveAnimate then 
        
        end      
    end
    return animateAction;
end

function _CLuaAnimateUnit:AddAnimateAction(_action)
    self._actionCount = self._actionCount + 1;
    self._animateActions[self._actionCount] = _action;
    _action:SetAnimateControl(self._animateControl);
end

function _CLuaAnimateUnit:SetAnimateControl(animateControl)
    local count = self._actionCount;
    local action;
    self._animateControl = animateControl;
    for i=1,count do
        action = self._animateActions[i];
        action:SetAnimateControl(animateControl);
    end 
end

--
function _CLuaAnimateUnit:Update(_dt)
    if self.isReverse then
        --倒播
        return self._reverseUpdate(_dt);
    else
        --正常播放
        return self:_normalUpdate(_dt);        
    end
end

--正常执行
function _CLuaAnimateUnit:_normalUpdate(_dt)
    local count = self._actionCount;
    local action;
    local leftTime = _dt;
    local tempLefTime;
    local isAll = true;
    local isAlls = {};
    local leftTimes = {};
    --执行每帧
    for i=1,count do
        action = self._animateActions[i];
        tempLefTime = action:Update(_dt);
        leftTimes[i] = tempLefTime;
        isAlls[i] = action:IsEnd();
        --isAll = isAll and isAlls[i];
    end

    for i=1,count do
        action = self._animateActions[i];
        if not isAlls[i] then
            local dependentIndex = action:Dependent();
            if dependentIndex~=-1 then
                if isAlls[dependentIndex] then
                    isAlls[i] = true;
                    leftTimes[i] = leftTimes[dependentIndex];
                end
            end
        end
        if leftTimes[i] < leftTime then
            leftTime = leftTimes[i];
        end
        isAll = isAll and isAlls[i];
    end

    --这一系列动画所花费的总时间
    local curUseTime = _dt - leftTime;
    self._useTime = self._useTime + curUseTime;

    --统计时长
    for i=1,count do
        action = self._animateActions[i];
        --tempLefTime = action:Update(_dt);
        action:RealUpdateTime(_dt-leftTimes[i],leftTimes[i] - leftTime);
    end

    --是否结束，且剩余时间
    return isAll,leftTime;
end


function _CLuaAnimateUnit:_reverseUpdate(_dt)
    local count = self._actionCount;
    local action;
    local realDt = 0;
    local leftTime = 0;
    local isAll = false;
    if self._useTime>_dt then
        realDt = _dt;
        isAll = false;
        leftTime = 0;
    else
        realDt = self._useTime;
        isAll = true;
        leftTime = _dt - self._useTime;
    end

    --执行每帧
    for i=1,count do
        action = self._animateActions[i];
        action:Update(realDt);
        isAll = isAll and action:IsEnd();
    end 
    return isAll,leftTime;   
end


local ENUM_CatchOP = {
    Play = 1,
    Pause = 2,
    Resume= 3,
    Stop = 4,
    Reverse = 5,
    RestartPlay = 6,
    PlayAlways = 7,
    SkipActionUnit = 8,
    SkipToActionUnit = 9,
    Destroy = 10,
};

local _CLuaAnimate = class("_CLuaAnimate");

function _CLuaAnimate:ctor()
    --动画数据
    self._animates = vector:new();

    --是否循环
    self._isLoop   = false;
    --次数 
    self._loop     = 1;
    self._ifLoop   = 1; --具体判断使用变量
    self._curLoop  = 1;

    --播放速度
    self._playSpeed    = 1;

    --是否倒播
    self._isReverse = false;

    --是否暂停
    self._isPause = true;
    
    --当前
    self._curAnimateIndex = 0;
    --是否
    self._lastAniamteIndex = nil;

    --动画个数
    self._animateCount = 0;

    --动画唯一的ID
    self._animateId     = 0;

    --是否是无效的
    self._isInvalid   = false;

    --是否是添加了Image组件
    self._isAddImage  = false;

    --结束事件
    self._endHandler   = nil;

    --一轮结束
    self._loopEndHandler = nil;

    --开始事件
    self._animateUnitStartHandler   = nil;
    --结束事件
    self._animateUnitEndHandler     = nil;
    --过程事件
    self._animateUnitProgressHandler= nil;
    --时间监听事件
    self._timeListener = {};
    --正在执行
    self._isRunning = false;
    --是否跳出循环
    self._isBreakLoop = false;
    --缓存操作
    self._catchOp     =  {};

    self._type        = nil;
end

function _CLuaAnimate.Create(_go)
    local animate = _CLuaAnimate:New();
    animate:Init(_go);
    return animate;
end

function _CLuaAnimate:Init(_go)
    self.gameObject     = _go;
    self.transform      = _go.transform;
end

function _CLuaAnimate:Renew(_go)
    self:Init(_go);
--    local count = self._animates:size();
--    for i=1,count do
--        self._animates:get(i):SetAnimateControl(self);
--    end
end

function _CLuaAnimate:GameObject()
    return self.gameObject;
end

function _CLuaAnimate:Transform()
    return self.transform;
end

function _CLuaAnimate:SetType(animaType)
    self._type = animaType;
end

function _CLuaAnimate:Hide()
    self.isShow = false;
    self.gameObject:SetActive(self.isShow);
end

function _CLuaAnimate:Show()
    self.isShow = true;
    self.gameObject:SetActive(self.isShow);
end

--设置具体动画的播放速度
function _CLuaAnimate:SetPlaySpeed(_playSpeed)
    self._playSpeed = _playSpeed or 1;
end

function _CLuaAnimate:ID()
    return self._animateId;
end

--得到当前的动画索引
function _CLuaAnimate:GetAnimateIndex()
    return self._curAnimateIndex;
end

--添加一个上一个动画的倒播
function _CLuaAnimate:AddReverseAnimate()

end

function _CLuaAnimate:_play()
    self._isPause = false;
    if self._curAnimateIndex==0 then
        self._curAnimateIndex = 1;
        self._lastAniamteIndex = 0;
        local curAnimateUnit = self._animates:get(self._curAnimateIndex);
        curAnimateUnit:Play(self.gameObject);
        self:OnAnimateUnitStart();
    end
end

function _CLuaAnimate:SkipActionUnit()
    local _actionCount = self._animates:size();
    if not self._isRunning then
        self:OnAnimateUnitEnd();
        self._curAnimateIndex = self._curAnimateIndex + 1;
        if self._curAnimateIndex>_actionCount then
            if self._isLoop then
                self:OnLoopEnd();
            elseif self._ifLoop==-1 then
                self:OnLoopEnd();
            else
                self._curLoop = self._curLoop + 1;
                if self._curLoop> self._loop then
                    self:OnEnd();
                    return ;
                end
            end
            self._curAnimateIndex = 1;
            self._lastAniamteIndex = 0;
        end
        local curAnimateUnit = self._animates:get(self._curAnimateIndex);
        curAnimateUnit:Play(self.gameObject);
        self:OnAnimateUnitStart();
    else
        self._isBreakLoop = true;
        self._catchOp[#self._catchOp+1] = {op =ENUM_CatchOP.SkipActionUnit};
    end
end

function _CLuaAnimate:SkipToActionUnit(index)
    local _actionCount = self._animates:size();
    if index<1 or index>_actionCount then
        return ;
    end
    if not self._isRunning then
        self:OnAnimateUnitEnd();
        self._curAnimateIndex = index;
        self._lastAniamteIndex = 0;
        local curAnimateUnit = self._animates:get(self._curAnimateIndex);
        curAnimateUnit:Play(self.gameObject);
        self:OnAnimateUnitStart();
    else
        self._isBreakLoop = true;
        self._catchOp[#self._catchOp+1] =  {op =ENUM_CatchOP.SkipToActionUnit,data =index};
    end
end

--开始播放
function _CLuaAnimate:Play()
    if not self._isRunning then
        self:_play();
        self._ifLoop  = self._loop;
    else
        self._isBreakLoop = true;
        self._catchOp[#self._catchOp+1] =  {op =ENUM_CatchOP.Play} ;
    end
end

--重新开始播放
function _CLuaAnimate:RestartPlay()
    if not self._isRunning then
        self._curAnimateIndex = 0;
        self:_play();
    else
        self._isBreakLoop = true;
        self._catchOp[#self._catchOp+1] =  {op =ENUM_CatchOP.RestartPlay};
    end
end

--一直播
function _CLuaAnimate:PlayAlways()
    if not self._isRunning then
        self:_play();
        self._ifLoop  = - 1;
    else
        self._isBreakLoop = true;
        self._catchOp[#self._catchOp+1] = {op =ENUM_CatchOP.PlayAlways};
    end
end

--添加一个动画
function _CLuaAnimate:addAnimate()

end

--获取
function _CLuaAnimate:getEndAnimateUnit()
    
end

--显示默认的
function _CLuaAnimate:DisplayDefault()

end

--重播
function _CLuaAnimate:Rewind()
    
end

--是否无效的
function _CLuaAnimate:IsInvalid()
    return self._isInvalid or IsNil(self.gameObject);
end

--销毁
function _CLuaAnimate:Destroy()
    if not self._isRunning then
        self._isInvalid = true;
    else
        self._isBreakLoop = true;
        self._catchOp[#self._catchOp+1] = {op =ENUM_CatchOP.Destroy};
    end
end

--添加animateUtil
function _CLuaAnimate:AddAnimateUnit(_unit)
    _unit = _unit or _CLuaAnimateUnit.New();
    --self._animates[#self._animates + 1] = _util;
    self._animates:push_back(_unit);
    _unit:SetAnimateControl(self);
    return _unit;
end

--每次都延迟,针对循环有效
function _CLuaAnimate:DelayPlay(_time)
    local _unit = _CLuaAnimateUnit.New();
    self._animates:push_front(_unit);
    local delayTimeAnimate = _CLuaDelayAnimateAction.New();
    local t= {delayTime = _time};
    delayTimeAnimate:Init(t);
    _unit:AddAnimateAction(delayTimeAnimate);
    _unit:SetAnimateControl(self);
    return _unit;
end

--只延迟一次
function _CLuaAnimate:DelayOnePlay(_time)
    local _unit = _CLuaAnimateUnit.New();
    local delayTimeAnimate = _CLuaDelayAnimateAction.New();
    local t= {delayTime = _time};
    delayTimeAnimate:Init(t);
    _unit:AddAnimateAction(delayTimeAnimate);
    _unit:SetAnimateControl(self);
    self._delayPlay = _unit;
    return _unit;
end

--屁股后添加一个延迟播放时间
function _CLuaAnimate:AppendDelayPlay(_time)
    local _unit = _CLuaAnimateUnit.New();
    self._animates:push_back(_unit);
    local delayTimeAnimate = _CLuaDelayAnimateAction.New();
    local t= {delayTime = _time};
    delayTimeAnimate:Init(t);
    _unit:AddAnimateAction(delayTimeAnimate);
    _unit:SetAnimateControl(self);
    return _unit;
end

--结束的事件
function _CLuaAnimate:SetEndHandler(handler)
    self._endHandler = handler;
end

--设置一轮结束的事件
function _CLuaAnimate:SetLoopEndHandler(handler)
    self._loopEndHandler = handler;
end

--设置小单元动作监听事件
function _CLuaAnimate:SetAnimateUnitHandler(startHandler,endHandler,progressHandler)
    self._animateUnitStartHandler   = startHandler;
    self._animateUnitEndHandler     = endHandler;
    self._animateUnitProgressHandler= progressHandler;
end

--倒播
function _CLuaAnimate:Reverse()
    if not self._isRunning then
        self._isReverse = true;
        self._isPause = false;
    else
        self._isBreakLoop = true;
        self._catchOp[#self._catchOp+1] = {op =ENUM_CatchOP.Reverse};
    end
end

function _CLuaAnimate:Loop()
    self._isLoop = true;
end

function _CLuaAnimate:Copy()
    local newImageAnimate = clone(self);
    return newImageAnimate;
end

--停止
function _CLuaAnimate:Pause()
    if not self._isRunning then
        self._isPause = true;
    else
        self._isBreakLoop = true;
        self._catchOp[#self._catchOp+1] =  {op =ENUM_CatchOP.Pause} ;
    end
end

function _CLuaAnimate:Resume()
    if not self._isRunning then
        self._isPause = false;
    else
        self._isBreakLoop = true;
        self._catchOp[#self._catchOp+1] =  {op =ENUM_CatchOP.Resume} ;
    end
end

--每帧执行
function _CLuaAnimate:Update(_dt)
    if self._isPause or _dt<=0 then
        --暂停
        return ;
    end
    local _actionCount = self._animates:size();
    local curAnimateUnit = self._animates:get(self._curAnimateIndex);
    if curAnimateUnit==nil then
        self:Stop();
        return ;
    end
    local isEnd,useTime;
    local _realDt = _dt * self._playSpeed;
    self._isBreakLoop = false;
    self._isRunning = true;
    while(true) do
        useTime = _realDt;
        isEnd,_realDt=curAnimateUnit:Update(_realDt);
        useTime = useTime - _realDt;
        for i=1,#self._timeListener do
            self._timeListener[i](self._curAnimateIndex,useTime,self._lastAniamteIndex~=self._curAnimateIndex);
        end
        self._lastAniamteIndex = self._curAnimateIndex;
        if self._isBreakLoop then
            break;
        end
--        if self._type == G_GlobalGame.Enum_AnimateSetStyle.Effect_Nangua_BossDead or 
--            self._type == G_GlobalGame.Enum_AnimateSetStyle.Effect_San_BossDead or 
--            self._type == G_GlobalGame.Enum_AnimateSetStyle.Effect_Youling_BossDead then
--            error("curAnimateIndex:" .. self._curAnimateIndex);
--        end
        if isEnd then
            self:OnAnimateUnitEnd();
            self._curAnimateIndex = self._curAnimateIndex + 1;
            if self._curAnimateIndex> _actionCount then
                if self._isLoop then
                    self:OnLoopEnd();
                elseif self._ifLoop==-1 then
                    self:OnLoopEnd();
                else
                    self._curLoop = self._curLoop + 1;
                    if self._curLoop> self._loop then
                        self:OnEnd(_realDt);
                        break ;
                    end
                end
                if self._isBreakLoop then
                    break;
                end
                self._curAnimateIndex = 1;
                self._lastAniamteIndex = 0;
            end
            curAnimateUnit = self._animates:get(self._curAnimateIndex);
            curAnimateUnit:Play(self.gameObject);
            if self._isBreakLoop then
                break;
            end
            self:OnAnimateUnitStart();
        end
        if _realDt<=0 then
            break;
        end
        if self._isBreakLoop then
            break;
        end
    end
    self._isRunning = false;
    if #self._catchOp>0 then
        local count = #self._catchOp;
        local op;
        for i=1,count do
            op = self._catchOp[i].op;
            if op==ENUM_CatchOP.Play then
                self:Play();
            elseif op==ENUM_CatchOP.Pause then
                self:Pause(); 
            elseif op==ENUM_CatchOP.Resume then
                self:Resume();
            elseif op==ENUM_CatchOP.PlayAlways then
                self:PlayAlways();
            elseif op==ENUM_CatchOP.Reverse then
                self:Reverse();
            elseif op==ENUM_CatchOP.Destroy then
                self:Destroy();
            elseif op==ENUM_CatchOP.Stop then
                self:Stop();
            elseif op==ENUM_CatchOP.RestartPlay then
                self:RestartPlay();
            elseif op==ENUM_CatchOP.SkipActionUnit then
                self:SkipActionUnit();
            elseif op==ENUM_CatchOP.SkipToActionUnit then
                self:SkipToActionUnit(op.data);
            end
            self._catchOp[i] = nil;
        end
    end
end

--监听时间消耗
function _CLuaAnimate:ListenTime(handler)
    self._timeListener[#self._timeListener+1] = handler;
end

function _CLuaAnimate:ClearTimeListener()
    self._timeListener = {};
end

function _CLuaAnimate:_stop()
    self._curLoop = 1;
    self._isPause = true;
    self._curAnimateIndex = 0;
    self._lastAniamteIndex= 0;
end

function _CLuaAnimate:Stop()
    if not self._isRunning then
        self:_stop();
    else
        self._isBreakLoop = true;
        self._catchOp[#self._catchOp+1] =  {op=ENUM_CatchOP.Stop};
    end
end

--结束事件
function _CLuaAnimate:OnEnd()
    self:_stop();
    if self._endHandler then
        self._endHandler(self,_realDt);
    end
end

function _CLuaAnimate:OnAnimateUnitStart()
    if self._animateUnitStartHandler then
        local curAnimateUnit = self._animates:get(self._curAnimateIndex);
        self._animateUnitStartHandler(self._curAnimateIndex,curAnimateUnit);
    end
end

function _CLuaAnimate:OnAnimateUnitEnd()
    if self._animateUnitEndHandler then
        local curAnimateUnit = self._animates:get(self._curAnimateIndex);
        self._animateUnitEndHandler(self._curAnimateIndex,curAnimateUnit);
    end
end

--一轮结束
function _CLuaAnimate:OnLoopEnd()
    if self._loopEndHandler then
        self._loopEndHandler(self);
    end
end

--当前播放到第几步了
function _CLuaAnimate:CurIndex()
    return self._curAnimateIndex;
end


local _CAnimaTool = class("_CAnimaTool");

function _CAnimaTool:ctor()

    self._spriteCreator = nil;
    self.ENUM_Animate_Style = {
    
    };

    self._animateSetCache = {
    };

    self._animateCache = {
    };
    self._animateControlMap = map:new();
    self._deleteControlVec  = vector:new();
    self._speed  = 1;
    self._idCreator = 1;
end

--设置sprite 创建器
function _CAnimaTool:SetCreator(_spriteCreator)
    self._spriteCreator = _spriteCreator;
end

--全局播放速度
function _CAnimaTool:SetPlaySpeed(_playSpeed)
    self._speed  = _playSpeed or 1;
end


--每帧执行
function _CAnimaTool:Update(_dt)
    local realDt = self._speed * _dt;
    local it = self._animateControlMap:iter();
    local val = it();
    local animateControl;
    while(val) do
        animateControl = self._animateControlMap:value(val);
        if not animateControl:IsInvalid() then
            animateControl:Update(realDt);
        else
            self._deleteControlVec:push_back(val);
        end
        val = it();
    end

    local it = self._deleteControlVec:iter();
    local val = it();
    while(val) do
        animateControl = self._animateControlMap:erase(val);
        animateControl:Destroy();
        val = it();
    end
    self._deleteControlVec:clear();
end

--删除动画
function _CAnimaTool:Delete(animate)
    animate:Destroy();
end

--为某个游戏体添加动画组件
--如果没有image组件，会添加，如果没有imageAnima，会添加
function _CAnimaTool:AddAnimate(go,animateData)
    if not self._spriteCreator then
        return ;
    end
    local animaType = animateData.type;
    local animateControl;
    if self._animateCache[animateData] then 
        animateControl = self._animateCache[animateData]:Copy();
        animateControl:Renew(go);
        self:_addAnimate(animateControl);
        return animateControl;
    end

    local animateData = animateData;
    if not animateData then
        return ;
    end  

    local animateControl = _CLuaAnimate.New();
    animateControl:Init(go);
    local animateUnit = nil;
    local animateAction;
    local animateInfo;
    local AnimateKind = _AnimateDefine.Enum_AnimateKind;

    animateUnit = animateControl:AddAnimateUnit();

    if animateData.animateType==nil then
        if animateData.animateKind == AnimateKind.DelayTime then
            -- DelayTime类型
            animateInfo = {animateType = AnimateKind.DelayTime, delayTime = animateData.waitTime};
        end
    else
        animateInfo = animateData;
    end
    if animateInfo then
        animateAction = _CLuaAnimateUnit.CreateAnimateAction(animateInfo,self._spriteCreator);
        animateUnit:AddAnimateAction(animateAction);
        if animateData.loop then
            --设置循环次数
            animateAction:SetLoop(animateData.loop);
        end
        if animateData.waitTime then
            --设置等待时间
            animateAction:SetWaitTime(animateData.waitTime);
        end
    end 
    self:_addAnimate(animateControl);
    self._animateCache[animateData] = animateControl:Copy();
    return animateControl;
end

function _CAnimaTool:AddAnimateType(go,animateType)
    return self:AddAnimate(go,_AnimateDefine.GetAnimateData(animateType));
end


--添加AnimateSet
function _CAnimaTool:AddAnimateSet(go,animateData)
    if not self._spriteCreator then
        return nil;
    end
    local animateControl;
    local animaSetType = animateData.type;
    if self._animateSetCache[animateData] then 
        animateControl = self._animateSetCache[animateData]:Copy();
        animateControl:Renew(go);
        self:_addAnimate(animateControl);
        return animateControl;
    end
    local animateSetData = animateData;
    if not animateSetData then
        return nil;
    end  
    local AnimateKind = _AnimateDefine.Enum_AnimateKind;
    local animateSet = animateSetData.animateSets;
    local count = #animateSet; 
    local animateControl = _CLuaAnimate.New();
    animateControl:Init(go);
    local animateUnit = nil;
    local animateAction;
    local animateUtilDatas
    local actionCount;
    local animateData;
    local animateInfo;
    if animateSet.loop ==-1 or animateSet.loop==true then
        animateControl:Loop();
    end
    for i=1,count do
        animateUnit = animateControl:AddAnimateUnit();
        animateUtilDatas = animateSet[i].actionUnits;
        actionCount = #animateUtilDatas;
        for j=1,actionCount do
            animateData = animateUtilDatas[j];
            if animateData.animateType==nil then
                if animateData.animateKind == AnimateKind.DelayTime then
                    -- DelayTime类型
                    animateInfo = {animateType = AnimateKind.DelayTime, delayTime = animateData.waitTime};
                end
            else
                animateInfo = _AnimateDefine.GetAnimateData(animateData.animateType);
            end
            if animateInfo then
                animateAction = _CLuaAnimateUnit.CreateAnimateAction(animateInfo,self._spriteCreator);
                animateAction:SetType(animateData.animateType);
                animateUnit:AddAnimateAction(animateAction);
                --设置依赖
                if animateData.dependent then
                    animateAction:SetDependent(animateData.dependent);
                end
                if animateData.loop then
                    --设置循环次数
                    animateAction:SetLoop(animateData.loop);
                end
                if animateData.waitTime then
                    --设置等待时间
                    animateAction:SetWaitTime(animateData.waitTime);
                end
            end
        end
    end
    animateControl:SetType(animateData);
    self:_addAnimate(animateControl);
    self._animateSetCache[animateData] = animateControl:Copy();
    return animateControl;
end

function _CAnimaTool:AddAnimateSetType(go,animateSetType)
    return self:AddAnimateSet(go,_AnimateDefine.GetAnimateSetData(animateSetType));
end

function _CAnimaTool:_addAnimate(animateControl)
    self._idCreator = self._idCreator + 1;
    self._animateControlMap:insert(self._idCreator,animateControl);
end

return _CAnimaTool;