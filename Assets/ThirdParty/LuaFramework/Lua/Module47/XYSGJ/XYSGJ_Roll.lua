XYSGJ_Roll = {}

local self = XYSGJ_Roll;
self.rollList = {};
self.rollIndex = 0;
self.StopIndex = 0;
self.currentState = 0;--0:待机，1：正常转动,2:停止
self.timer = 0;
self.startTimer = 0;
self.stopTimer = 0;
self.isstop = false;
self.scatterCount = 0;
self.addSpeedEffectIndex = 0;

self.isJIsTOP=false

function XYSGJ_Roll.Init(obj)
    --初始化转动
    self.rollList = {};
    self.currentState = 0;
    self.scatterCount = 0;
    self.lastLight=nil
    
    self.isstop = false;
    for i = 1, obj.transform.childCount do
        local rect = obj.transform:GetChild(i - 1):GetComponent("ScrollRect");
        local temp1 = newObject(rect.content:GetChild(0):GetChild(0).gameObject);
        temp1.transform:SetParent(rect.content:GetChild(0));
        temp1.transform.localPosition = Vector3.New(0, 133, 0);
        temp1.transform.localRotation = Quaternion.identity;
        temp1.transform.localScale = Vector3.New(1, 1, 1);
        temp1.gameObject.name = "Temp";
        local temp2 = newObject(rect.content:GetChild(0):GetChild(0).gameObject);
        temp2.transform:SetParent(rect.content:GetChild(rect.content.childCount - 1));
        temp2.transform.localPosition = Vector3.New(0, -133, 0);
        temp2.transform.localRotation = Quaternion.identity;
        temp2.transform.localScale = Vector3.New(1, 1, 1);
        temp2.gameObject.name = "Temp";
        rect.verticalNormalizedPosition = 0;
        rect.elasticity = XYSGJ_DataConfig.rollReboundRate;
        table.insert(self.rollList, rect);
    end
    for i=1,obj.transform.childCount do
        XYSGJ_Roll.ChangeIconRoll(i)
    end

end
function XYSGJ_Roll.StartRoll()
    XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.yx_spin);
    self.rollIndex = 0;
    self.StopIndex = 0;
    self.timer = XYSGJ_DataConfig.rollInterval;
    self.stopTimer = 0;
    self.startTimer = 0;
    self.currentState = 1;
    self.isstop = false;
    self.scatterCount = 0;
    self.addSpeedEffectIndex = 0;
    self.isJIsTOP=false

end
function XYSGJ_Roll.StopRoll()
    if not self.isstop then
        self.isJIsTOP=true
        XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.BTN);
        -- self.currentState = 0;
        -- for i = 1, #self.rollList do
        --     self.ChangeResultIcon(i);
        --     self.rollList[i].verticalNormalizedPosition = 1;
        -- end
        if self.rollIndex == #self.rollList then
            self.currentState = 2;
            self.isstop = true;
        end
        -- XYSGJ_Audio.ClearAuido(XYSGJ_Audio.SoundList.yx_addSpeed);
        -- for i = 1, XYSGJEntry.RollContent.childCount do
        --     XYSGJEntry.RollContent:GetChild(i - 1):Find("XYSGJ_faguang01").gameObject:SetActive(false)
        --     XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.RS);
        -- end
        XYSGJEntry.OnStop1();
    end
end
function XYSGJ_Roll.Update()
    if self.currentState == 0 then
        --待机状态
        return ;
    elseif self.currentState == 1 then
        --正常旋转
        for i = 1, self.rollIndex do
            self.rollList[i].verticalNormalizedPosition = self.rollList[i].verticalNormalizedPosition + Time.deltaTime * XYSGJ_DataConfig.rollSpeed;--旋转
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
                self.rollList[self.rollIndex].transform:Find("XYSGJ_faguang01").gameObject:SetActive(true);
                self.ChangeIconRoll(self.rollIndex);
            end
        end
        if self.startTimer <= XYSGJ_DataConfig.rollTime then
            --计算旋转时间，时间到就停止
            self.startTimer = self.startTimer + Time.deltaTime;
            if self.startTimer >= XYSGJ_DataConfig.rollTime then
                self.currentState = 2;
            end
        end
    elseif self.currentState == 2 then
        for i = 1, self.rollIndex do
            if self.StopIndex < i then
                self.rollList[i].verticalNormalizedPosition = self.rollList[i].verticalNormalizedPosition + Time.deltaTime * XYSGJ_DataConfig.rollSpeed;--旋转
                if self.rollList[i].verticalNormalizedPosition >= 1 then
                    self.rollList[i].verticalNormalizedPosition = 0;
                    self.ChangeIconRoll(i);
                end
            end
        end
        if self.StopIndex < #self.rollList then
            --计算转动间隔
            self.stopTimer = self.stopTimer + Time.deltaTime;
            if self.stopTimer >= XYSGJ_DataConfig.rollInterval then
                if self.addSpeedEffectIndex > 0 then
                    if self.stopTimer < XYSGJ_DataConfig.addSpeedTime + XYSGJ_DataConfig.rollInterval then
                        return ;
                    end
                end
                if self.lastLight ~= nil then
                    self.lastLight.gameObject:SetActive(false);
                end
                self.stopTimer = 0;
                self.StopIndex = self.StopIndex + 1;
                --TODO 换正式结果图片
                self.ChangeResultIcon(self.StopIndex);
                self.AddSpeed();
                self.rollList[self.StopIndex].verticalNormalizedPosition = 1;
                local pos = self.rollList[self.StopIndex].content.localPosition;
                self.rollList[self.StopIndex].content:DOLocalMove(Vector3.New(pos.x, -XYSGJ_DataConfig.rollDistance, pos.z), 0.1):OnComplete(function()
                    self.rollList[self.StopIndex].content:DOLocalMove(Vector3.New(pos.x, 0, pos.z), 0.01):OnComplete(function()
                        self.rollList[self.StopIndex].transform:Find("XYSGJ_faguang01").gameObject:SetActive(false);
                        XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.RS);
                        if self.StopIndex == #self.rollList then
                            self.currentState = 0;
                            XYSGJEntry.OnStop();
                        end
                    end);
                end);
            end
        end
    end
end
function XYSGJ_Roll.AddSpeed()
    if self.hasscatter and not self.isJIsTOP then
        self.addSpeedEffectIndex = self.StopIndex;
        if self.lastLight ~= nil then
            self.lastLight:SetActive(false);
        end
        XYSGJEntry.CSGroup.gameObject:SetActive(true);
        self.lastLight = XYSGJEntry.CSGroup:GetChild(self.addSpeedEffectIndex):Find("AddSpeed").gameObject;
        self.lastLight:SetActive(true);
        --TODO 播放加速音效,延时销毁
        XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.yx_addSpeed, XYSGJ_DataConfig.addSpeedTime);
    end
end
function XYSGJ_Roll.ChangeIconRoll(index)
    local iconParent = self.rollList[index].content;
    for i = 0, iconParent.childCount - 1 do
        local iconIndex = math.random(1, 10);
        local changeIcon = XYSGJEntry.icons:Find(XYSGJ_DataConfig.IconTable[iconIndex]):GetComponent("Image").sprite;
        iconParent:GetChild(i):Find("Icon"):GetComponent("Image").sprite = changeIcon;
        local tempIcon = iconParent:GetChild(i):Find("Temp");
        if tempIcon ~= nil then
            tempIcon:GetComponent("Image").sprite = changeIcon;
            tempIcon:GetComponent("Image"):SetNativeSize();
        end
        iconParent:GetChild(i):Find("Icon"):GetComponent("Image"):SetNativeSize();
    end
end
function XYSGJ_Roll.ChangeResultIcon(index)
    local iconParent = self.rollList[index].content;
    local isscatter = false;
    for i = 0, iconParent.childCount - 1 do
        local img = iconParent:GetChild(i):Find("Icon"):GetComponent("Image");
        local iconIndex = 1;
        if i == iconParent.childCount - 1 then
            iconIndex = math.random(0, 9);
        else
            iconIndex = XYSGJEntry.ResultData.ImgTable[i * 3 + index];
            if iconIndex == 7 then
                isscatter = true;
                self.scatterCount = self.scatterCount + 1;
                if self.scatterCount == 1 and index ==1 then
                    XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.yx_bonus3);
                elseif self.scatterCount == 2 and index <= 2  then
                    XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.yx_bonus3);
                elseif self.scatterCount == 3  then
                    XYSGJ_Audio.PlaySound(XYSGJ_Audio.SoundList.yx_bonus3);  
                end
            end
        end
        local changeIcon = XYSGJEntry.icons:Find(XYSGJ_DataConfig.IconTable[iconIndex + 1]):GetComponent("Image").sprite;
        img.sprite = changeIcon;
        if i ~= iconParent.childCount - 1 then
            iconParent:GetChild(i).gameObject.name = XYSGJ_DataConfig.IconTable[iconIndex + 1];
        end
        img:SetNativeSize();
        local tempIcon = iconParent:GetChild(i):Find("Temp");
        if tempIcon ~= nil then
            iconIndex = math.random(0, 9);
            changeIcon = XYSGJEntry.icons:Find(XYSGJ_DataConfig.IconTable[iconIndex + 1]):GetComponent("Image").sprite;
            tempIcon:GetComponent("Image").sprite = changeIcon;
            tempIcon:GetComponent("Image"):SetNativeSize();
        end
    end
    if index == 2 and self.scatterCount == 2 then
        self.hasscatter = true;
    else
        self.hasscatter = false;
        self.addSpeedEffectIndex = -1;
    end
end