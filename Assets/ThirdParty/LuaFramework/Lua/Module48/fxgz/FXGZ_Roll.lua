FXGZ_Roll = {}

local self = FXGZ_Roll;
self.rollList = {};
self.rollIndex = 0;
self.StopIndex = 0;
self.currentState = 0;--0:待机，1：正常转动,2:停止
self.timer = 0;
self.startTimer = 0;
self.stopTimer = 0;
self.isstop = false;
self.scatterCount = 0;
self.wildCount = 0;
self.mayBeFive = false;
self.addSpeedEffectIndex = 0;
self.scatter = true;
self.wild = true;
self.stoplist = {};
self.rollSpeedList = {};
self.CurrentRollIndex = 0;
self.isStart = false;
self.isAutoStop = false;
self.isAddSpeed = false;
function FXGZ_Roll.Init(obj)
    --初始化转动
    self.rollList = {};
    self.currentState = 0;
    self.isstop = false;
    self.scatterCount = 0;
    self.wildCount = 0;
    FXGZEntry.ScatterList = {};
    for i = 1, obj.transform.childCount do
        local rect = obj.transform:GetChild(i - 1):GetComponent("ScrollRect");
        local tempObj = GameObject.New("TempGroup");
        tempObj.transform:SetParent(rect.content:GetChild(0));
        tempObj.transform.localPosition = Vector3.New(0, 110 * 2.5, 0);
        tempObj.transform.localRotation = Quaternion.identity;
        tempObj.transform.localScale = Vector3.New(1, 1, 1);
        for j = 1, 4 do
            local temp1 = newObject(rect.content:GetChild(0):GetChild(0).gameObject);
            temp1.transform:SetParent(tempObj.transform);
            temp1.transform.localPosition = Vector3.New(0, 110 * (j - 2.5), 0);
            temp1.transform.localRotation = Quaternion.identity;
            temp1.transform.localScale = Vector3.New(1, 1, 1);
            temp1.gameObject.name = "Temp";
        end
        tempObj = GameObject.New("TempGroup");
        tempObj.transform:SetParent(rect.content:GetChild(rect.content.childCount - 1));
        tempObj.transform.localPosition = Vector3.New(0, -110 * 2.5, 0);
        tempObj.transform.localRotation = Quaternion.identity;
        tempObj.transform.localScale = Vector3.New(1, 1, 1);
        for j = 1, 4 do
            local temp1 = newObject(rect.content:GetChild(rect.content.childCount - 1):GetChild(0).gameObject);
            temp1.transform:SetParent(tempObj.transform);
            temp1.transform.localPosition = Vector3.New(0, 110 * (j - 2.5), 0);
            temp1.transform.localRotation = Quaternion.identity;
            temp1.transform.localScale = Vector3.New(1, 1, 1);
            temp1.gameObject.name = "Temp";
        end

        --local temp2 = newObject(rect.content:GetChild(0):GetChild(0).gameObject);
        --temp2.transform:SetParent(rect.content:GetChild(rect.content.childCount - 1));
        --temp2.transform.localPosition = Vector3.New(0, -105, 0);
        --temp2.transform.localRotation = Quaternion.identity;
        --temp2.transform.localScale = Vector3.New(1, 1, 1);
        --temp2.gameObject.name = "Temp";
        rect.verticalNormalizedPosition = 1;
        rect.elasticity = FXGZ_DataConfig.rollReboundRate;
        table.insert(self.rollList, rect);
    end
    for i = 1, #self.rollList do
        self.ChangeIconRoll(i);
    end
end
function FXGZ_Roll.StartRoll()
    self.isstop = false;
    self.rollIndex = 0;
    self.StopIndex = 0;
    self.timer = FXGZ_DataConfig.rollInterval;
    self.stopTimer = 0;
    self.startTimer = 0;
    self.rollSpeedList = { -2, -2, -2, -2, -2 };
    self.currentState = 1;
    self.scatterCount = 0;
    self.wildCount = 0;
    self.isAddSpeed = false;
    self.isAutoStop = false;
    self.scatter = true;
    self.mayBeFive = false;
    self.wild = true;
    self.stoplist = { false, false, false, false, false };
    FXGZEntry.ScatterList = {};
    FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.RStart);
    log("开始转动")
end
function FXGZ_Roll.StopRoll()
    if not self.isstop then
        self.isAutoStop = true;
        FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.BTN);
        self.isstop = true;
        for i = 1, FXGZEntry.CSGroup.childCount do
            local add = FXGZEntry.CSGroup:GetChild(i - 1):Find("Add");
            if add ~= nil then
                add.gameObject:SetActive(false);
            end
        end
        FXGZ_Audio.ClearAuido(FXGZ_Audio.SoundList.AddSpeed);
    end
end
function FXGZ_Roll.RealStop()
    self.isAutoStop = true;
    self.currentState = 0;
    for i = 1, #self.rollList do
        self.ChangeResultIcon(i);
        self.rollList[i].verticalNormalizedPosition = 1.2;
        local index = i;
        Util.RunWinScore(1.2, 1, 0.2, function(value)
            self.rollList[i].verticalNormalizedPosition = value;
        end):OnComplete(function()
            if index == #self.rollList then
                FXGZEntry.OnStop();
            end
        end);
    end
end
function FXGZ_Roll.Update()
    if self.currentState == 0 then
        --待机状态
        return ;
    elseif self.currentState == 1 then
        --正常旋转
        for i = 1, self.rollIndex do
            self.rollList[i].verticalNormalizedPosition = self.rollList[i].verticalNormalizedPosition + Time.deltaTime * self.rollSpeedList[i];--旋转
            if self.rollSpeedList[i] < 0 and self.rollList[i].verticalNormalizedPosition < 0.5 then
                self.rollSpeedList[i] = FXGZ_DataConfig.rollSpeed;
            else
                if self.rollList[i].verticalNormalizedPosition >= 1 then
                    self.rollList[i].verticalNormalizedPosition = 0;
                    self.ChangeIconRoll(i);
                end
            end
        end

        if self.rollIndex < #self.rollList then
            --计算转动间隔
            self.timer = self.timer + Time.deltaTime;
            if self.timer >= FXGZ_DataConfig.rollInterval then
                self.timer = 0;
                self.startTimer = 0;
                self.rollIndex = self.rollIndex + 1;
                --TODO 赋值转动icon
                log("RollIndex:" .. self.rollIndex);
                if self.rollIndex == #self.rollList and self.isstop then
                    self.stopTimer = 0;
                    self.currentState = 2;
                    self.isAutoStop = true;
                end
            end
        end
        if self.startTimer <= FXGZ_DataConfig.rollTime then
            --计算旋转时间，时间到就停止
            self.startTimer = self.startTimer + Time.deltaTime;
            if self.startTimer >= FXGZ_DataConfig.rollTime then
                self.currentState = 2;
                self.isstop = true;
            end
        end
    elseif self.currentState == 2 then
        for i = 1, self.rollIndex do
            if self.StopIndex < i then
                self.rollList[i].verticalNormalizedPosition = self.rollList[i].verticalNormalizedPosition + Time.deltaTime * FXGZ_DataConfig.rollSpeed;--旋转
                if self.rollList[i].verticalNormalizedPosition >= 1 then
                    self.rollList[i].verticalNormalizedPosition = 0;
                    self.ChangeIconRoll(i);
                end
            end
        end
        if self.StopIndex < #self.rollList then
            --计算转动间隔
            self.stopTimer = self.stopTimer + Time.deltaTime;
            if self.stopTimer >= FXGZ_DataConfig.rollInterval then
                if self.isAddSpeed then
                    if self.stopTimer < FXGZ_DataConfig.addSpeedTime then
                        if self.rollList[self.StopIndex + 1].verticalNormalizedPosition >= 1 then
                            self.rollList[self.StopIndex + 1].verticalNormalizedPosition = 0;
                            self.ChangeIconRoll(self.StopIndex + 1);
                        end
                        return ;
                    end
                end
                self.mayBeFive = false;
                self.stopTimer = 0;
                self.StopIndex = self.StopIndex + 1;
                --TODO 换正式结果图片
                self.ChangeResultIcon(self.StopIndex);
                local stopindex = self.StopIndex;
                if not self.isAutoStop then
                    self.AddSpeed();
                end
                self.rollList[stopindex].verticalNormalizedPosition = 1;
                self.rollList[stopindex].content:DOLocalMove(Vector3.New(75, -FXGZ_DataConfig.rollDistance, 0), 0.1):OnComplete(function()
                    local timer = 0.2;
                    self.rollList[stopindex].content:DOLocalMove(Vector3.New(75, 0, 0), timer);
                    coroutine.start(function()
                        coroutine.wait(timer - 0.2);
                        --TODO 单列停止
                        if FXGZEntry.isReRollGame then
                            if stopindex ~= 1 and stopindex ~= 5 then
                                FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.RollStop);
                            end
                        else
                            FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.RollStop);
                        end
                        if not FXGZEntry.isFreeGame and self.wild then
                            self.wild = false;
                            self.wildCount = self.wildCount + 1;
                            if self.wildCount >= 3 then
                                self.wildCount = 3;
                            end
                            FXGZ_Audio.PlaySound("Bonus" .. self.wildCount);
                        end
                        if self.scatter and not FXGZEntry.isFreeGame then
                            self.scatter = false;
                            self.scatterCount = self.scatterCount + 1;
                            if self.scatterCount >= 3 then
                                self.scatterCount = 3;
                            end
                            FXGZ_Audio.PlaySound("Bonus" .. self.scatterCount);
                        end
                        if stopindex == #self.rollList then
                            self.addLight = FXGZEntry.CSGroup:GetChild(4):Find("Add").gameObject;
                            self.addLight:SetActive(false);
                            self.currentState = 0;
                            FXGZEntry.OnStop();
                        end
                    end);
                end);
            end
        end
    end
end
function FXGZ_Roll.AddSpeed()
    if (self.wildCount > 0 and self.StopIndex == #self.rollList - 1) and not FXGZEntry.isReRollGame then
        FXGZEntry.CSGroup.gameObject:SetActive(true);
        self.addLight = FXGZEntry.CSGroup:GetChild(4):Find("Add").gameObject;
        self.addLight:SetActive(true);
        --TODO 播放加速音效,延时销毁
        FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.AddSpeed);
        self.isAddSpeed = true;
    elseif self.mayBeFive then
        FXGZEntry.CSGroup.gameObject:SetActive(true);
        local add = nil;
        if FXGZEntry.isReRollGame then
            add = FXGZEntry.CSGroup:GetChild(3):Find("Add").gameObject;
        else
            add = FXGZEntry.CSGroup:GetChild(4):Find("Add").gameObject;
        end
        add:SetActive(true);
        --TODO 播放加速音效,延时销毁
        FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.AddSpeed);
        coroutine.start(function()
            coroutine.wait(2);
            add:SetActive(false);
        end);
        self.isAddSpeed = true;
    else
        self.isAddSpeed = false;
    end
end
function FXGZ_Roll.ChangeIconRoll(index)
    local iconParent = self.rollList[index].content;
    for i = 0, iconParent.childCount - 1 do
        local iconIndex = math.random(0, 11);
        local changeIcon = FXGZEntry.icons:Find(FXGZ_DataConfig.IconTable[iconIndex + 1]):GetComponent("Image").sprite;
        iconParent:GetChild(i):Find("Icon"):GetComponent("Image").sprite = changeIcon;
        local tempgroup = iconParent:GetChild(i):Find("TempGroup");
        iconIndex = math.random(0, 3);
        changeIcon = FXGZEntry.icons:Find(FXGZ_DataConfig.IconTable[iconIndex + 1]):GetComponent("Image").sprite;
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
function FXGZ_Roll.ChangeResultIcon(index)
    if index > #self.rollList then
        return ;
    end
    local iconParent = self.rollList[index].content;
    local hasScatter = false;
    local haswild = false;
    for i = 0, iconParent.childCount - 1 do
        local img = iconParent:GetChild(i):Find("Icon"):GetComponent("Image");
        local iconIndex = 1;
        if i == iconParent.childCount - 1 then
            iconIndex = math.random(0, 3);
        else
            iconIndex = FXGZEntry.ResultData.ImgTable[i * 5 + index];
            if iconIndex == 10 and index == 1 then
                haswild = true;
            elseif iconIndex == 11 then
                hasScatter = true;
            end
        end
        local changeIcon = FXGZEntry.icons:Find(FXGZ_DataConfig.IconTable[iconIndex + 1]):GetComponent("Image").sprite;
        img.sprite = changeIcon;
        if i ~= iconParent.childCount - 1 then
            iconParent:GetChild(i).gameObject.name = FXGZ_DataConfig.IconTable[iconIndex + 1];
        end
        img:SetNativeSize();
        local tempgroup = iconParent:GetChild(i):Find("TempGroup");
        if tempgroup ~= nil then
            for j = 1, tempgroup.childCount do
                local tempIcon = tempgroup:GetChild(j - 1);
                iconIndex = math.random(0, 3);
                changeIcon = FXGZEntry.icons:Find(FXGZ_DataConfig.IconTable[iconIndex + 1]):GetComponent("Image").sprite;
                tempIcon:GetComponent("Image").sprite = changeIcon;
                tempIcon:GetComponent("Image"):SetNativeSize();
            end
        end
    end
    self.scatter = hasScatter;
    self.wild = haswild;
    if FXGZEntry.isReRollGame then
        if index == 3 then
            for i = 1, #FXGZEntry.ResultData.LineTypeTable do
                if FXGZEntry.ResultData.LineTypeTable[i][1] ~= 0 then
                    local count = 0;
                    for j = 1, #FXGZEntry.ResultData.LineTypeTable[i] do
                        if FXGZEntry.ResultData.LineTypeTable[i][j] ~= 0 then
                            count = count + 1;
                            if count == 3 then
                                self.mayBeFive = true;
                                break ;
                            end
                        end
                    end
                end
            end
        end
    else
        if index == 4 and not (self.wildCount > 0 and self.StopIndex == #self.rollList - 1) then
            for i = 1, #FXGZEntry.ResultData.LineTypeTable do
                if FXGZEntry.ResultData.LineTypeTable[i][1] ~= 0 then
                    local count = 0;
                    for j = 1, #FXGZEntry.ResultData.LineTypeTable[i] do
                        if FXGZEntry.ResultData.LineTypeTable[i][j] ~= 0 then
                            count = count + 1;
                            if count == 4 then
                                self.mayBeFive = true;
                                break ;
                            end
                        end
                    end
                end
            end
        end
    end
end