SGXML_Roll = {}

local self = SGXML_Roll;
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
self.scatter = true;
self.stoplist = {};
function SGXML_Roll.Init(obj)
    --初始化转动
    self.rollList = {};
    self.currentState = 0;
    self.isstop = false;
    self.scatterCount = 0;
    SGXMLEntry.ScatterList = {};
    for i = 1, obj.transform.childCount do
        local rect = obj.transform:GetChild(i - 1):GetComponent("ScrollRect");
        local tempObj = GameObject.New("TempGroup");
        tempObj.transform:SetParent(rect.content:GetChild(0));
        tempObj.transform.localPosition = Vector3.New(0, 116 * 2.5, 0);
        tempObj.transform.localRotation = Quaternion.identity;
        tempObj.transform.localScale = Vector3.New(1, 1, 1);
        for j = 1, 4 do
            local temp1 = newObject(rect.content:GetChild(0):GetChild(0).gameObject);
            temp1.transform:SetParent(tempObj.transform);
            temp1.transform.localPosition = Vector3.New(0, 116 * (j - 1) - 116 * 1.5, 0);
            temp1.transform.localRotation = Quaternion.identity;
            temp1.transform.localScale = Vector3.New(1, 1, 1);
            temp1.gameObject.name = "Temp";
        end

        local temp2 = newObject(rect.content:GetChild(0):GetChild(0).gameObject);
        temp2.transform:SetParent(rect.content:GetChild(rect.content.childCount - 1));
        temp2.transform.localPosition = Vector3.New(0, -116, 0);
        temp2.transform.localRotation = Quaternion.identity;
        temp2.transform.localScale = Vector3.New(1, 1, 1);
        temp2.gameObject.name = "Temp";
        rect.verticalNormalizedPosition = 0;
        rect.elasticity = SGXML_DataConfig.rollReboundRate;
        table.insert(self.rollList, rect);
    end
    for i = 1, #self.rollList do
        self.ChangeIconRoll(i);
    end
end
function SGXML_Roll.StartRoll()
    SGXML_Audio.PlaySound(SGXML_Audio.SoundList.RStart);
    coroutine.start(function()
        coroutine.wait(0.5);
        SGXML_Audio.PlaySound(SGXML_Audio.SoundList.Rolling);
    end);
    self.rollIndex = 0;
    self.StopIndex = 0;
    self.timer = SGXML_DataConfig.rollInterval;
    self.stopTimer = 0;
    self.startTimer = 0;
    self.currentState = 1;
    self.scatterCount = 0;
    self.scatter = true;
    self.isstop = false;
    self.stoplist = { false, false, false, false, false };
    SGXMLEntry.ScatterList = {};
    log("开始转动")
end
function SGXML_Roll.StopRoll()
    if self.isstop then
        return ;
    end
    self.isstop = true;
    if self.rollIndex == #self.rollList then
        self.stopTimer = SGXML_DataConfig.rollInterval;
        self.currentState = 2;
    end
end
function SGXML_Roll.Update()
    if self.currentState == 0 then
        --待机状态
        return ;
    elseif self.currentState == 1 then
        --正常旋转
        for i = 1, self.rollIndex do
            self.rollList[i].verticalNormalizedPosition = self.rollList[i].verticalNormalizedPosition + Time.deltaTime * SGXML_DataConfig.rollSpeed;--旋转
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
                if self.rollIndex == #self.rollList and self.isstop then
                    self.stopTimer = 0;
                    self.currentState = 2;
                end
            end
        end
        if self.startTimer <= SGXML_DataConfig.rollTime then
            --计算旋转时间，时间到就停止
            self.startTimer = self.startTimer + Time.deltaTime;
            if self.startTimer >= SGXML_DataConfig.rollTime then
                self.currentState = 2;
                self.ChangeResultIcon(self.StopIndex + 1);
            end
        end
    elseif self.currentState == 2 then
        for i = 1, self.rollIndex do
            if self.StopIndex < i then
                self.rollList[i].verticalNormalizedPosition = self.rollList[i].verticalNormalizedPosition + Time.deltaTime * SGXML_DataConfig.rollSpeed;--旋转
                if self.rollList[i].verticalNormalizedPosition >= 1 and self.StopIndex < i - 1 then
                    self.rollList[i].verticalNormalizedPosition = 0;
                    self.ChangeIconRoll(i);
                end
            end
        end
        if self.StopIndex < #self.rollList then
            --计算转动间隔
            self.stopTimer = self.stopTimer + Time.deltaTime;
            if self.stopTimer >= SGXML_DataConfig.rollInterval then
                self.stopTimer = 0;
                self.StopIndex = self.StopIndex + 1;
                --TODO 换正式结果图片
                self.ChangeResultIcon(self.StopIndex);
                local stopindex = self.StopIndex;
                self.rollList[stopindex].verticalNormalizedPosition = 1;
                self.rollList[stopindex].content:DOLocalMove(Vector3.New(75, -SGXML_DataConfig.rollDistance, 0), 0.1):OnComplete(function()
                    local timer = 0.7;
                    --log("stopIndex:::" .. stopindex);
                    if stopindex == #self.rollList then
                        timer = 1;
                    end
                    self.rollList[stopindex].content:DOLocalMove(Vector3.New(75, 0, 0), timer);
                    coroutine.start(function()
                        coroutine.wait(timer - 0.2);
                        --log("stopIndex::====:" .. stopindex);
                        SGXML_Audio.PlaySound(SGXML_Audio.SoundList.RollStop);
                        if stopindex == #self.rollList then
                            self.currentState = 0;
                            SGXMLEntry.OnStop();
                        end
                    end);
                end);
                --self.rollList[self.StopIndex].verticalNormalizedPosition = SGXML_DataConfig.rollDistance;
                --local stopcall = function(stopindex)
                --    local temp = GameObject.New("Temp").transform;
                --    temp.localScale = Vector3.New(SGXML_DataConfig.rollDistance, 1, 1);
                --    local timer = 0.7;
                --    if stopindex == #self.rollList then
                --        timer = 1;
                --    end
                --    temp:DOScale(Vector3.New(1, 1, 1), timer):OnComplete(function()
                --        destroy(temp.gameObject);
                --        temp = nil;
                --    end);
                --
                --    coroutine.start(function()
                --        while temp ~= nil do
                --            self.rollList[stopindex].verticalNormalizedPosition = temp.localScale.x;
                --            if temp.localScale.x <= 1.2 and not self.stoplist[stopindex] then
                --                self.stoplist[stopindex] = true;
                --                SGXML_Audio.PlaySound(SGXML_Audio.SoundList.RollStop);
                --            end
                --            coroutine.wait(0);
                --        end
                --        if stopindex == #self.rollList then
                --            self.currentState = 0;
                --            SGXMLEntry.OnStop();
                --        end
                --    end)
                --end
                --stopcall(self.StopIndex);
            end
        end
    end
end
function SGXML_Roll.ChangeIconRoll(index)
    local iconParent = self.rollList[index].content;
    for i = 0, iconParent.childCount - 1 do
        local iconIndex = math.random(1, 8);
        local changeIcon = SGXMLEntry.icons:Find(SGXML_DataConfig.IconTable[iconIndex]):GetComponent("Image").sprite;
        iconParent:GetChild(i).localScale=Vector3.New(1.1,1.1,1.1);
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
function SGXML_Roll.ChangeResultIcon(index)
    if index > #self.rollList then
        return ;
    end
    local iconParent = self.rollList[index].content;
    local hasScatter = false;
    for i = 0, iconParent.childCount - 1 do
        local img = iconParent:GetChild(i):Find("Icon"):GetComponent("Image");
        local iconIndex = 1;
        if i == iconParent.childCount - 1 then
            iconIndex = math.random(1, 8);
        else
            iconIndex = SGXMLEntry.ResultData.ImgTable[i * 5 + index];
            if iconIndex == 12 then
                if self.scatter then
                    if index == 1 then
                        hasScatter = true;
                        self.scatterCount = self.scatterCount + 1;
                        table.insert(SGXMLEntry.ScatterList, img);
                    else
                        if self.scatterCount == index - 1 then
                            hasScatter = true;
                            self.scatterCount = self.scatterCount + 1;
                            table.insert(SGXMLEntry.ScatterList, img);
                        end
                    end
                end
            elseif iconIndex == 13 then
                if SGXMLEntry.isFreeGame then
                    iconIndex = 13 + SGXMLEntry.CurrentFreeIndex;
                end
            end
        end
        local changeIcon = SGXMLEntry.icons:Find(SGXML_DataConfig.IconTable[iconIndex]):GetComponent("Image").sprite;
        img.sprite = changeIcon;
        if i ~= iconParent.childCount - 1 then
            iconParent:GetChild(i).gameObject.name = SGXML_DataConfig.IconTable[iconIndex];
        end
        img:SetNativeSize();
        local tempgroup = iconParent:GetChild(i):Find("TempGroup");
        if tempgroup ~= nil then
            for j = 1, tempgroup.childCount do
                local tempIcon = tempgroup:GetChild(j - 1);
                iconIndex = math.random(1, 8);
                changeIcon = SGXMLEntry.icons:Find(SGXML_DataConfig.IconTable[iconIndex]):GetComponent("Image").sprite;
                tempIcon:GetComponent("Image").sprite = changeIcon;
                tempIcon:GetComponent("Image"):SetNativeSize();
            end
        end
    end
    self.scatter = hasScatter;
    return hasScatter;
end