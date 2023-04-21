WSZS_Roll = {}

local self = WSZS_Roll;
self.rollList = {};
self.rollIndex = 0;
self.StopIndex = 0;
self.currentState = 0;--0:待机，1：正常转动,2:停止
self.timer = 0;
self.startTimer = 0;
self.stopTimer = 0;
self.isstop = false;
self.hasscatter = false;
self.addSpeedEffectIndex = 0;
self.canPlayYW = false;
self.battleCount = 0;
self.isAutoStop = false;
function WSZS_Roll.Init(obj)
    --初始化转动
    self.rollList = {};
    self.currentState = 0;
    self.isstop = false;
    for i = 1, obj.transform.childCount do
        local rect = obj.transform:GetChild(i - 1):GetComponent("ScrollRect");
        local tempObj = GameObject.New("TempGroup");
        tempObj.transform:SetParent(rect.content:GetChild(0));
        tempObj.transform.localPosition = Vector3.New(0, 132 * 2.5, 0);
        tempObj.transform.localRotation = Quaternion.identity;
        tempObj.transform.localScale = Vector3.New(1, 1, 1);
        for j = 1, 4 do
            local temp1 = newObject(rect.content:GetChild(0):GetChild(0).gameObject);
            temp1.transform:SetParent(tempObj.transform);
            temp1.transform.localPosition = Vector3.New(0, 132 * (j - 2.5), 0);
            temp1.transform.localRotation = Quaternion.identity;
            temp1.transform.localScale = Vector3.New(1, 1, 1);
            temp1.gameObject.name = "Temp";
        end

        local temp2 = newObject(rect.content:GetChild(0):GetChild(0).gameObject);
        temp2.transform:SetParent(rect.content:GetChild(rect.content.childCount - 1));
        temp2.transform.localPosition = Vector3.New(0, -132, 0);
        temp2.transform.localRotation = Quaternion.identity;
        temp2.transform.localScale = Vector3.New(1, 1, 1);
        temp2.gameObject.name = "Temp";
        rect.verticalNormalizedPosition = 0;
        rect.elasticity = WSZS_DataConfig.rollReboundRate;
        table.insert(self.rollList, rect);
    end
    for i = 1, #self.rollList do
        self.ChangeIconRoll(i);
    end
end
function WSZS_Roll.StartRoll()
    self.rollIndex = 0;
    self.StopIndex = 0;
    self.timer = WSZS_DataConfig.rollInterval;
    self.stopTimer = 0;
    self.startTimer = 0;
    self.currentState = 1;
    self.addSpeedEffectIndex = 0;
    self.lastLight = nil;
    self.hasscatter = false;
    self.isAutoStop = false;
    self.canPlayYW = false;
    self.battleCount = 0;
    self.isstop = false;
end
function WSZS_Roll.StopRoll()
    if not self.isstop then
        self.isAutoStop = true;
        WSZS_Audio.PlaySound(WSZS_Audio.SoundList.BTN1);
        self.isstop = true;
        for i = 1, WSZSEntry.CSGroup.childCount do
            local yw = WSZSEntry.CSGroup:GetChild(i - 1):Find("YW");
            if yw ~= nil then
                yw.gameObject:SetActive(false);
            end
            local add = WSZSEntry.CSGroup:GetChild(i - 1):Find("AddSpeed");
            if add ~= nil then
                add.gameObject:SetActive(false);
            end
        end
        WSZS_Audio.ClearAuido(WSZS_Audio.SoundList.AddSpeed);
        if self.rollIndex == #self.rollList then
            self.currentState = 2;
        end
    end
end
function WSZS_Roll.RealStop()
    self.currentState = 0;
    self.isAutoStop = true;
    for i = 1, #self.rollList do
        self.ChangeResultIcon(i);
        self.rollList[i].verticalNormalizedPosition = 1;
    end
    WSZSEntry.OnStop();
end
function WSZS_Roll.AddSpeed()
    if self.hasscatter then
        self.addSpeedEffectIndex = self.StopIndex;
        if self.lastLight ~= nil then
            self.lastLight:SetActive(false);
        end
        if self.addSpeedEffectIndex >= #self.rollList - 1 then
            self.addSpeedEffectIndex = 0;
            return ;
        end
        WSZSEntry.CSGroup.gameObject:SetActive(true);
        self.lastLight = WSZSEntry.CSGroup:GetChild(self.addSpeedEffectIndex):Find("AddSpeed").gameObject;
        self.lastLight:SetActive(true);
        --TODO 播放加速音效,延时销毁
        WSZS_Audio.PlaySound(WSZS_Audio.SoundList.AddSpeed, WSZS_DataConfig.addSpeedTime);
    end
end
function WSZS_Roll.Update()
    if self.currentState == 0 then
        --待机状态
        return ;
    elseif self.currentState == 1 then
        --正常旋转
        for i = 1, self.rollIndex do
            self.rollList[i].verticalNormalizedPosition = self.rollList[i].verticalNormalizedPosition + Time.deltaTime * WSZS_DataConfig.rollSpeed;--旋转
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
                if self.rollIndex == #self.rollList and self.isstop then
                    self.stopTimer = 0;
                    self.currentState = 2;
                    self.isAutoStop = true;
                end
            end
        end
        if self.startTimer <= WSZS_DataConfig.rollTime then
            --计算旋转时间，时间到就停止
            self.startTimer = self.startTimer + Time.deltaTime;
            if self.startTimer >= WSZS_DataConfig.rollTime then
                self.currentState = 2;
                self.isstop = true;
            end
        end
    elseif self.currentState == 2 then
        for i = 1, self.rollIndex do
            if self.StopIndex < i then
                self.rollList[i].verticalNormalizedPosition = self.rollList[i].verticalNormalizedPosition + Time.deltaTime * WSZS_DataConfig.rollSpeed;--旋转
                if self.rollList[i].verticalNormalizedPosition >= 1 then
                    self.rollList[i].verticalNormalizedPosition = 0;
                    self.ChangeIconRoll(i);
                end
            end
        end
        if self.StopIndex < #self.rollList then
            --计算转动间隔
            self.stopTimer = self.stopTimer + Time.deltaTime;
            if self.stopTimer >= WSZS_DataConfig.rollInterval then
                if self.addSpeedEffectIndex > 0 then
                    if self.stopTimer < WSZS_DataConfig.addSpeedTime + WSZS_DataConfig.rollInterval then
                        return ;
                    end
                end
                self.stopTimer = 0;
                self.StopIndex = self.StopIndex + 1;
                --TODO 换正式结果图片
                self.ChangeResultIcon(self.StopIndex);
                local stopindex = self.StopIndex;
                if not self.isAutoStop then
                    self.AddSpeed();
                end
                self.rollList[stopindex].verticalNormalizedPosition = 1;
                self.rollList[stopindex].content:DOLocalMove(Vector3.New(75, -WSZS_DataConfig.rollDistance, 0), 0.1):OnComplete(function()
                    local timer = 0.2;
                    self.rollList[stopindex].content:DOLocalMove(Vector3.New(75, 0, 0), timer);
                    coroutine.start(function()
                        coroutine.wait(timer - 0.2);
                        if self.canPlayYW and stopindex <= 4 then
                            WSZSEntry.CSGroup.gameObject:SetActive(true);
                            WSZS_Audio.PlaySound(WSZS_Audio.SoundList.AddSpeedStop);
                            WSZSEntry.CSGroup:GetChild(stopindex - 1):Find("YW").gameObject:SetActive(true);
                            coroutine.start(function()
                                coroutine.wait(1);
                                WSZSEntry.CSGroup:GetChild(stopindex - 1):Find("YW").gameObject:SetActive(false);
                            end);
                        end
                        if (stopindex <= 4) and self.hasscatter then
                            self.canPlayYW = true;
                        end
                        --TODO 单列停止
                        WSZS_Audio.PlaySound(WSZS_Audio.SoundList.RS);
                        if stopindex == #self.rollList then
                            self.currentState = 0;
                            WSZSEntry.OnStop();
                        end
                    end);
                end);
            end
        end
    end
end
function WSZS_Roll.ChangeIconRoll(index)
    local iconParent = self.rollList[index].content;
    for i = 0, iconParent.childCount - 1 do
        local iconIndex = math.random(1, 8);
        local changeIcon = WSZSEntry.icons:Find(WSZS_DataConfig.IconTable[iconIndex]):GetComponent("Image").sprite;
        iconParent:GetChild(i):Find("Icon"):GetComponent("Image").sprite = changeIcon;
        local tempgroup = iconParent:GetChild(i):Find("TempGroup");
        if tempgroup ~= nil then
            for j = 1, tempgroup.childCount do
                local tempIcon = tempgroup:GetChild(j - 1);
                tempIcon:GetComponent("Image").sprite = changeIcon;
                tempIcon:GetComponent("Image"):SetNativeSize();
            end
        end
        iconParent:GetChild(i):Find("Icon"):GetComponent("Image"):SetNativeSize();
    end
end
function WSZS_Roll.ChangeResultIcon(index)
    if index > #self.rollList then
        return ;
    end
    local iconParent = self.rollList[index].content;
    local hasbattle = false;
    for i = 0, iconParent.childCount - 1 do
        local img = iconParent:GetChild(i):Find("Icon"):GetComponent("Image");
        local iconIndex = 1;
        if i == iconParent.childCount - 1 then
            iconIndex = math.random(0, 10);
        else
            iconIndex = WSZSEntry.ResultData.ImgTable[i * 5 + index];
            if index == self.StopIndex then
                if iconIndex == 11 and self.StopIndex <= 3 and self.StopIndex > 1 then
                    self.hasscatter = true;
                elseif self.StopIndex == 5 then
                    self.hasscatter = false;
                    self.addSpeedEffectIndex = 0;
                end
                if iconIndex == 10 then
                    hasbattle = true;
                end
            end
        end
        local changeIcon = WSZSEntry.icons:Find(WSZS_DataConfig.IconTable[iconIndex + 1]):GetComponent("Image").sprite;
        img.sprite = changeIcon;
        if i ~= iconParent.childCount - 1 then
            iconParent:GetChild(i).gameObject.name = WSZS_DataConfig.IconTable[iconIndex + 1];
        end
        img:SetNativeSize();
        local tempIcon = iconParent:GetChild(i):Find("Temp");
        if tempIcon ~= nil then
            iconIndex = math.random(0, 10);
            changeIcon = WSZSEntry.icons:Find(WSZS_DataConfig.IconTable[iconIndex + 1]):GetComponent("Image").sprite;
            tempIcon:GetComponent("Image").sprite = changeIcon;
            tempIcon:GetComponent("Image"):SetNativeSize();
        end
        if hasbattle then
            self.battleCount = self.battleCount + 1;
            if self.battleCount >= 3 then
                self.battleCount = 3;
            end
            WSZS_Audio.PlaySound("Bonus" .. self.battleCount);
        end
    end
end