SHT_Roll = {}

local self = SHT_Roll;
self.rollList = {};
self.rollIndex = 0;
self.StopIndex = 0;
self.currentState = 0;--0:待机，1：正常转动,2:停止
self.timer = 0;
self.startTimer = 0;
self.stopTimer = 0;

self.scatterCount = 0;
self.addSpeedEffectIndex = 0;
self.lastLight = nil;

self.isstop = false;
self.freeCount=0

function SHT_Roll.Init(obj)
    --初始化转动
    self.rollList = {};
    SHTEntry.scatterList = {};
    self.currentState = 0;
    self.scatterCount = 0;
    self.isstop = false;
    for i = 1, obj.transform.childCount do
        local rect = obj.transform:GetChild(i - 1):GetComponent("ScrollRect");
        local temp1 = newObject(rect.content:GetChild(0):GetChild(0).gameObject);
        temp1.transform:SetParent(rect.content:GetChild(0));
        temp1.transform.localPosition = Vector3.New(0, 175, 0);
        temp1.transform.localRotation = Quaternion.identity;
        temp1.transform.localScale = Vector3.New(1, 1, 1);
        temp1.gameObject.name = "Temp";
        local temp2 = newObject(rect.content:GetChild(0):GetChild(0).gameObject);
        temp2.transform:SetParent(rect.content:GetChild(rect.content.childCount - 1));
        temp2.transform.localPosition = Vector3.New(0, -175, 0);
        temp2.transform.localRotation = Quaternion.identity;
        temp2.transform.localScale = Vector3.New(1, 1, 1);
        temp2.gameObject.name = "Temp";
        rect.verticalNormalizedPosition = 0;
        rect.elasticity = SHT_DataConfig.rollReboundRate;
        table.insert(self.rollList, rect);
    end

    for i=1,obj.transform.childCount do
        SHT_Roll.ChangeIconRoll(i)
    end
end
function SHT_Roll.StartRoll()
    
    SHT_Audio.PlaySound(SHT_Audio.SoundList.rollBegin5); 
    self.rollIndex = 0;
    self.StopIndex = 0;
    self.scatterCount = 0;
    self.timer = SHT_DataConfig.rollInterval;
    self.stopTimer = 0;
    self.startTimer = 0;
    self.currentState = 1;
    self.lastLight = nil;
    SHTEntry.scatterList = {};
    SHTEntry.bjjList = {};
    SHTEntry.bjjImgList = {};
    self.isstop = false;
    self.freeCount=0
    self.addSpeedEffectIndex = 0;

    log("timer:" .. SHT_DataConfig.rollTime)
end
function SHT_Roll.StopRoll()
    if self.isstop then
        return ;
    end
    local stop = function()
        while self.rollIndex ~= #self.rollList do
            coroutine.wait(0.01);
        end
        self.stopTimer = SHT_DataConfig.rollInterval
        self.currentState = 2;
        self.isstop = true;
    end
    coroutine.stop(stop);
    coroutine.start(stop);
end
function SHT_Roll.Update()
    if self.currentState == 0 then
        --待机状态
        return ;
    elseif self.currentState == 1 then
        --正常旋转
        for i = 1, self.rollIndex do
            self.rollList[i].verticalNormalizedPosition = self.rollList[i].verticalNormalizedPosition + Time.deltaTime * SHT_DataConfig.rollSpeed;--旋转
            if self.rollList[i].verticalNormalizedPosition >= 1 then
                self.rollList[i].verticalNormalizedPosition = 0;
                self.ChangeIconRoll(i);
            end
        end
        if self.rollIndex < #self.rollList then
            --计算转动间隔
            self.timer = self.timer + Time.deltaTime;
            if self.timer >= 0 then
                self.timer = 0;
                self.rollIndex = self.rollIndex + 1;
                --TODO 赋值转动icon
                self.ChangeIconRoll(self.rollIndex);
            end
        end

        if self.startTimer <= SHT_DataConfig.rollTime then
            --计算旋转时间，时间到就停止
            self.startTimer = self.startTimer + Time.deltaTime;
            if self.startTimer >= SHT_DataConfig.rollTime then
                self.currentState = 2;
            end
        end

    elseif self.currentState == 2 then
        for i = 1, self.rollIndex do
            if self.StopIndex < i then
                self.rollList[i].verticalNormalizedPosition = self.rollList[i].verticalNormalizedPosition + Time.deltaTime * SHT_DataConfig.rollSpeed;--旋转
                if self.rollList[i].verticalNormalizedPosition >= 1 then
                    self.rollList[i].verticalNormalizedPosition = 0;
                    self.ChangeIconRoll(i);
                end
            end
        end
        if self.StopIndex < #self.rollList then
            --计算转动间隔
            local stoptime = SHT_DataConfig.rollInterval;
            if self.isstop then
                stoptime = stoptime / 3.5;
            end
            self.stopTimer = self.stopTimer + Time.deltaTime;
            if self.stopTimer >= stoptime then
                if self.addSpeedEffectIndex > 0 then
                    if self.stopTimer < SHT_DataConfig.addSpeedTime then
                        return ;
                    end
                end
                self.stopTimer = 0;
                self.StopIndex = self.StopIndex + 1;
                --TODO 换正式结果图片
                self.ChangeResultIcon(self.StopIndex);
                self.rollList[self.StopIndex].verticalNormalizedPosition = SHT_DataConfig.rollDistance;
                self.SingleRollStop(self.StopIndex);
                self.AddSpeed(self.StopIndex);
                if self.StopIndex == #self.rollList then
                    self.currentState = 0;
                    SHTEntry.OnStop();
                end
            end
        end
    end
end
function SHT_Roll.AddSpeed()
    -- if self.scatterCount >= 2 then
    --     self.addSpeedEffectIndex = self.StopIndex;
    --     -- if self.lastLight ~= nil then
    --     --     self.lastLight:SetActive(false);
    --     -- end
    --     if self.addSpeedEffectIndex >= #self.rollList then
    --         self.addSpeedEffectIndex = 0;
    --         return ;
    --     end
    --     -- self.lastLight = SHTEntry.CSGroup:GetChild(self.addSpeedEffectIndex):Find("Light").gameObject;
    --     -- self.lastLight:SetActive(true);
    --     --TODO 播放加速音效,延时销毁
    --     SHT_Audio.PlaySound(SHT_Audio.SoundList.speed1, SHT_DataConfig.addSpeedTime);
    -- end
    if self.freeCount >= 2 then
        self.addSpeedEffectIndex = self.StopIndex;
        -- if self.lastLight ~= nil then
        --     self.lastLight:SetActive(false);
        -- end
        if self.addSpeedEffectIndex >= #self.rollList then
            self.addSpeedEffectIndex = 0;
            return ;
        end
        -- self.lastLight = SHTEntry.CSGroup:GetChild(self.addSpeedEffectIndex):Find("Light").gameObject;
        -- self.lastLight:SetActive(true);
        --TODO 播放加速音效,延时销毁
        SHT_Audio.PlaySound(SHT_Audio.SoundList.speed1, SHT_DataConfig.addSpeedTime);
    end

end
function SHT_Roll.SingleRollStop(index)
    --TODO 音效
    if self.isstop then
        if index==#self.rollList then
            SHT_Audio.PlaySound(SHT_Audio.SoundList.mati_01); 
        end 
    else
        SHT_Audio.PlaySound(SHT_Audio.SoundList.mati_01);
    end
end
function SHT_Roll.ChangeIconRoll(index)
    local iconParent = self.rollList[index].content;
    for i = 0, iconParent.childCount - 1 do
        local iconIndex = math.random(1, 11);
        local changeIcon = SHTEntry.icons:Find(SHT_DataConfig.IconTable[iconIndex]):GetComponent("Image").sprite;
        iconParent:GetChild(i):Find("Icon"):GetComponent("Image").sprite = changeIcon;
        local tempIcon = iconParent:GetChild(i):Find("Temp");
        if tempIcon ~= nil then
            tempIcon:GetComponent("Image").sprite = changeIcon;
            tempIcon:GetComponent("Image"):SetNativeSize();
        end
        iconParent:GetChild(i):Find("Icon"):GetComponent("Image"):SetNativeSize();
    end
end
function SHT_Roll.ChangeResultIcon(index)
    --切换正式Icon
    local iconParent = self.rollList[index].content;
    for i = 0, iconParent.childCount - 1 do
        local img = iconParent:GetChild(i):Find("Icon"):GetComponent("Image");
        local iconIndex = 1;
        local isscatter = false;
        local isfree = false;

        if i == iconParent.childCount - 1 then
            iconIndex = math.random(2, 9);
        else
            iconIndex = SHTEntry.ResultData.ImgTable[i * 5 + index];
            if iconIndex == 9 then
                isscatter = true;
                self.scatterCount = self.scatterCount + 1;
                if self.scatterCount == 2 then
                     SHT_Audio.PlaySound(SHT_Audio.SoundList.freeBoundS2);
                elseif self.scatterCount == 3 then
                    SHT_Audio.PlaySound(SHT_Audio.SoundList.freeBoundS2);
                end
            end
            if iconIndex==10 then
                isfree=true
                self.freeCount=self.freeCount+1
                if self.freeCount>=2 and index==5 then
                    SHT_Audio.PlaySound(SHT_Audio.SoundList.freeBoundS3);
                end
            end
        end
        local changeIcon = SHTEntry.icons:Find(SHT_DataConfig.IconTable[iconIndex+1]):GetComponent("Image").sprite;
        img.sprite = changeIcon;
        img:SetNativeSize();
        local tempIcon = iconParent:GetChild(i):Find("Temp");
        if tempIcon ~= nil then
            iconIndex = math.random(2, 11);
            changeIcon = SHTEntry.icons:Find(SHT_DataConfig.IconTable[iconIndex]):GetComponent("Image").sprite;
            tempIcon:GetComponent("Image").sprite = changeIcon;
            tempIcon:GetComponent("Image"):SetNativeSize();
        end
    end
end