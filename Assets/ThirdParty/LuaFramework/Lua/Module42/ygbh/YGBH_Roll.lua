YGBH_Roll = {}

local self = YGBH_Roll;
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
function YGBH_Roll.Init(obj)
    --初始化转动
    self.rollList = {};
    YGBHEntry.scatterList = {};
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
        rect.elasticity = YGBH_DataConfig.rollReboundRate;
        table.insert(self.rollList, rect);
    end
end
function YGBH_Roll.StartRoll()
    self.rollIndex = 0;
    self.StopIndex = 0;
    self.scatterCount = 0;
    self.timer = YGBH_DataConfig.rollInterval;
    self.stopTimer = 0;
    self.startTimer = 0;
    self.currentState = 1;
    self.lastLight = nil;
    YGBHEntry.scatterList = {};
    YGBHEntry.bjjList = {};
    YGBHEntry.bjjImgList = {};
    self.isstop = false;
    log("timer:" .. YGBH_DataConfig.rollTime)
end
function YGBH_Roll.StopRoll()
    if self.isstop then
        return ;
    end
    local stop = function()
        while self.rollIndex ~= #self.rollList do
            coroutine.wait(0.01);
        end
        self.stopTimer = YGBH_DataConfig.rollInterval
        self.currentState = 2;
        self.isstop = true;
    end
    coroutine.stop(stop);
    coroutine.start(stop);
end
function YGBH_Roll.Update()
    if self.currentState == 0 then
        --待机状态
        return ;
    elseif self.currentState == 1 then
        --正常旋转
        for i = 1, self.rollIndex do
            self.rollList[i].verticalNormalizedPosition = self.rollList[i].verticalNormalizedPosition + Time.deltaTime * YGBH_DataConfig.rollSpeed;--旋转
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
        if self.startTimer <= YGBH_DataConfig.rollTime then
            --计算旋转时间，时间到就停止
            self.startTimer = self.startTimer + Time.deltaTime;
            if self.startTimer >= YGBH_DataConfig.rollTime then
                self.currentState = 2;
            end
        end
    elseif self.currentState == 2 then
        for i = 1, self.rollIndex do
            if self.StopIndex < i then
                self.rollList[i].verticalNormalizedPosition = self.rollList[i].verticalNormalizedPosition + Time.deltaTime * YGBH_DataConfig.rollSpeed;--旋转
                if self.rollList[i].verticalNormalizedPosition >= 1 then
                    self.rollList[i].verticalNormalizedPosition = 0;
                    self.ChangeIconRoll(i);
                end
            end
        end
        if self.StopIndex < #self.rollList then
            --计算转动间隔
            local stoptime = YGBH_DataConfig.rollInterval;
            if self.isstop then
                stoptime = stoptime / 3.5;
            end
            self.stopTimer = self.stopTimer + Time.deltaTime;
            if self.stopTimer >= stoptime then
                if self.addSpeedEffectIndex > 0 then
                    if self.stopTimer < YGBH_DataConfig.addSpeedTime then
                        return ;
                    end
                end
                self.stopTimer = 0;
                self.StopIndex = self.StopIndex + 1;
                --TODO 换正式结果图片
                self.ChangeResultIcon(self.StopIndex);
                self.rollList[self.StopIndex].verticalNormalizedPosition = YGBH_DataConfig.rollDistance;
                self.SingleRollStop();
                self.AddSpeed();
                if self.StopIndex == #self.rollList then
                    self.currentState = 0;
                    YGBHEntry.OnStop();
                end
            end
        end
    end
end
function YGBH_Roll.AddSpeed()
    if self.scatterCount >= 2 then
        self.addSpeedEffectIndex = self.StopIndex;
        if self.lastLight ~= nil then
            self.lastLight:SetActive(false);
        end
        if self.addSpeedEffectIndex >= #self.rollList then
            self.addSpeedEffectIndex = 0;
            return ;
        end
        self.lastLight = YGBHEntry.CSGroup:GetChild(self.addSpeedEffectIndex):Find("Light").gameObject;
        self.lastLight:SetActive(true);
        --TODO 播放加速音效,延时销毁
        YGBH_Audio.PlaySound(YGBH_Audio.SoundList.ADDSPEED, YGBH_DataConfig.addSpeedTime);
    end
end
function YGBH_Roll.SingleRollStop()
    --TODO 音效
    YGBH_Audio.PlaySound(YGBH_Audio.SoundList.RS);
end
function YGBH_Roll.ChangeIconRoll(index)
    local iconParent = self.rollList[index].content;
    for i = 0, iconParent.childCount - 1 do
        local iconIndex = math.random(1, 11);
        local changeIcon = YGBHEntry.icons:Find(YGBH_DataConfig.IconTable[iconIndex]):GetComponent("Image").sprite;
        iconParent:GetChild(i):Find("Icon"):GetComponent("Image").sprite = changeIcon;
        local tempIcon = iconParent:GetChild(i):Find("Temp");
        if tempIcon ~= nil then
            tempIcon:GetComponent("Image").sprite = changeIcon;
            tempIcon:GetComponent("Image"):SetNativeSize();
        end
        iconParent:GetChild(i):Find("Icon"):GetComponent("Image"):SetNativeSize();
    end
end
function YGBH_Roll.ChangeResultIcon(index)
    --切换正式Icon
    local iconParent = self.rollList[index].content;
    for i = 0, iconParent.childCount - 1 do
        local img = iconParent:GetChild(i):Find("Icon"):GetComponent("Image");
        local iconIndex = 1;
        local isscatter = false;
        if i == iconParent.childCount - 1 then
            iconIndex = math.random(2, 11);
        else
            iconIndex = YGBHEntry.ResultData.ImgTable[i * 5 + index] + 1;
            if iconIndex == 12 then
                isscatter = true;
                self.scatterCount = self.scatterCount + 1;
                if self.scatterCount == 1 then
                    if index < 4 then
                        YGBH_Audio.PlaySound(YGBH_Audio.SoundList.SCATTER1);
                    end
                elseif self.scatterCount == 2 then
                    if index < 5 then
                        YGBH_Audio.PlaySound(YGBH_Audio.SoundList.SCATTER2);
                    end
                elseif self.scatterCount == 3 then
                    YGBH_Audio.PlaySound(YGBH_Audio.SoundList.SCATTER3);
                end
            end
            --TODO 白晶晶图片处理
            if iconIndex == 14 then
                iconIndex = math.random(2, 11);
                log("位置：" .. i * 5 + index)
                table.insert(YGBHEntry.bjjList, YGBH_DataConfig.LightPos[i * 5 + index]);
                table.insert(YGBHEntry.bjjImgList, img);
            end
        end
        local changeIcon = YGBHEntry.icons:Find(YGBH_DataConfig.IconTable[iconIndex]):GetComponent("Image").sprite;
        if isscatter then
            if img.transform.childCount <= 0 then
                local go = YGBH_Line.CreateEffect(YGBH_DataConfig.GetEffectName(15));
                if go ~= nil then
                    go.transform:SetParent(img.transform);
                    go.transform.localPosition = Vector3.New(0, 0, 0);
                    go.transform.localRotation = Quaternion.identity;
                    go.transform.localScale = Vector3.New(1.15, 1.15, 1.15);
                    go.gameObject:SetActive(true);
                    go.name = YGBH_DataConfig.EffectTable[15];
                    img.enabled = false;
                end
            end
            table.insert(YGBHEntry.scatterList, img.transform);
        end
        img.sprite = changeIcon;
        img:SetNativeSize();
        local tempIcon = iconParent:GetChild(i):Find("Temp");
        if tempIcon ~= nil then
            iconIndex = math.random(2, 11);
            changeIcon = YGBHEntry.icons:Find(YGBH_DataConfig.IconTable[iconIndex]):GetComponent("Image").sprite;
            tempIcon:GetComponent("Image").sprite = changeIcon;
            tempIcon:GetComponent("Image"):SetNativeSize();
        end
    end
end