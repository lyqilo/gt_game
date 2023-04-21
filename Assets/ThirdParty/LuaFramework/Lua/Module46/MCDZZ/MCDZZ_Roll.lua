MCDZZ_Roll = {}

local self = MCDZZ_Roll;
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
self.lastLight = nil;
local isPlayscatter=false

function MCDZZ_Roll.Init(obj)
    --初始化转动
    self.rollList = {};
    self.currentState = 0;
    self.scatterCount = 0;

    self.isstop = false;

   -- content

    for i = 1, obj.transform.childCount do
        for j=1,obj.transform:GetChild(i - 1):GetComponent("ScrollRect").content.childCount do
            obj.transform:GetChild(i - 1):GetComponent("ScrollRect").content:GetChild(j-1):GetChild(0):GetComponent("Image").sprite=MCDZZEntry.icons:Find(MCDZZ_DataConfig.IconTable[math.random(0,10) + 1]):GetComponent("Image").sprite
        end
    end
    
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
        rect.elasticity = MCDZZ_DataConfig.rollReboundRate;
        table.insert(self.rollList, rect);
    end
end
function MCDZZ_Roll.StartRoll()
    self.rollIndex = 0;
    self.StopIndex = 0;
    self.scatterCount = 0;
    self.lastLight = nil;
    isPlayscatter=false
    self.timer = MCDZZ_DataConfig.rollInterval;
    self.stopTimer = 0;
    self.startTimer = 0;
    self.currentState = 1;
    self.isstop = false;
    MCDZZEntry.scatterList = {};
    self.addSpeedEffectIndex = 0
end
function MCDZZ_Roll.StopRoll()
    if self.isstop then
        return ;
    end
    if self.rollIndex == #self.rollList then
        self.currentState = 2;
        self.isstop = true;
    end
    MCDZZEntry.OnStop1();
end
function MCDZZ_Roll.Update()
    if self.currentState == 0 then
        --待机状态
        return ;
    elseif self.currentState == 1 then
        --正常旋转
        for i = 1, self.rollIndex do
            self.rollList[i].verticalNormalizedPosition = self.rollList[i].verticalNormalizedPosition + Time.deltaTime * MCDZZ_DataConfig.rollSpeed;--旋转
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
        if self.startTimer <= MCDZZ_DataConfig.rollTime then
            --计算旋转时间，时间到就停止
            self.startTimer = self.startTimer + Time.deltaTime;
            if self.startTimer >= MCDZZ_DataConfig.rollTime then
                self.currentState = 2;
            end
        end
    elseif self.currentState == 2 then
        for i = 1, self.rollIndex do
            if self.StopIndex < i then
                self.rollList[i].verticalNormalizedPosition = self.rollList[i].verticalNormalizedPosition + Time.deltaTime * MCDZZ_DataConfig.rollSpeed;--旋转
                if self.rollList[i].verticalNormalizedPosition >= 1 then
                    self.rollList[i].verticalNormalizedPosition = 0;
                    self.ChangeIconRoll(i);
                end
            end
        end
        if self.StopIndex < #self.rollList then
            --计算转动间隔
            self.stopTimer = self.stopTimer + Time.deltaTime;
            if self.stopTimer >= MCDZZ_DataConfig.rollInterval then
                if self.addSpeedEffectIndex > 0 then
                    if self.stopTimer < MCDZZ_DataConfig.addSpeedTime then
                        return ;
                    end
                end
                self.stopTimer = 0;
                self.StopIndex = self.StopIndex + 1;
                --TODO 换正式结果图片
                self.ChangeResultIcon(self.StopIndex);
                self.rollList[self.StopIndex].verticalNormalizedPosition = MCDZZ_DataConfig.rollDistance;
                self.SingleRollStop();
                self.AddSpeed(self.StopIndex);
                MCDZZEntry.rollLight:GetChild(self.StopIndex-1):Find("Light").gameObject:SetActive(false)    

                if self.StopIndex == #self.rollList then
                    self.currentState = 0;
                    MCDZZEntry.OnStop();
                end
            end
        end
    end
end
function MCDZZ_Roll.SingleRollStop()
    --TODO 音效
    MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.RS);
end

function MCDZZ_Roll.AddSpeed(index)
    -- if index >= 2  then
    --     MCDZZEntry.rollLight:GetChild(1):Find("Light").gameObject:SetActive(false)
    -- end
    -- if index >= 3  then
    --     self.addSpeedEffectIndex=0
    --     MCDZZEntry.rollLight:GetChild(2):Find("Light").gameObject:SetActive(false)
    -- end

    if self.scatterCount ~= index  then
        -- if index>2 and index <= 4 then
        --     MCDZZEntry.rollLight:GetChild(index-2):Find("Light").gameObject:SetActive(false)            
        -- end
        if index==3 and self.scatterCount < 3   then
            if isPlayscatter then
                MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.failScatter3);
            end
            for i = 1, #MCDZZEntry.scatterList do
                MCDZZEntry.scatterList[i]:GetComponent("Image").enabled=true
                MCDZZEntry.scatterList[i]:GetChild(0).transform:Find("Image").gameObject:SetActive(true)
                MCDZZ_Line.CollectEffect(MCDZZEntry.scatterList[i]:GetChild(0).gameObject);
            end
        end
        self.addSpeedEffectIndex=0
        return
    end

    if self.scatterCount >= 1  and index < 3   then
        self.addSpeedEffectIndex = self.StopIndex;
        if self.addSpeedEffectIndex >= #self.rollList then
            self.addSpeedEffectIndex = 0;
            return ;
        end
        if self.lastLight ~= nil then
            self.lastLight:SetActive(false);
        end
        --MCDZZEntry.CSGroup.gameObject:SetActive(true);
        self.lastLight = MCDZZEntry.rollLight:GetChild(self.addSpeedEffectIndex):Find("Light").gameObject;
        self.lastLight:SetActive(true);
        MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.Jiasu_150_2s, MCDZZ_DataConfig.addSpeedTime);
    end
end

function MCDZZ_Roll.ChangeIconRoll(index)
    local iconParent = self.rollList[index].content;
    for i = 0, iconParent.childCount - 1 do
        local iconIndex = math.random(1, 10);
        local changeIcon = MCDZZEntry.icons:Find(MCDZZ_DataConfig.IconTable[iconIndex]):GetComponent("Image").sprite;
        iconParent:GetChild(i):Find("Icon"):GetComponent("Image").sprite = changeIcon;
        local tempIcon = iconParent:GetChild(i):Find("Temp");
        if tempIcon ~= nil then
            tempIcon:GetComponent("Image").sprite = changeIcon;
            tempIcon:GetComponent("Image"):SetNativeSize();
        end
        iconParent:GetChild(i):Find("Icon"):GetComponent("Image"):SetNativeSize();
    end
end


function MCDZZ_Roll.ChangeResultIcon(index)
    local iconParent = self.rollList[index].content;
    local _scatterCount = 0

    for i = 0, iconParent.childCount - 1 do
        local img = iconParent:GetChild(i):Find("Icon"):GetComponent("Image");
        local iconIndex = 1;
        if i == iconParent.childCount - 1 then
            iconIndex = math.random(0, 9);
        else
            iconIndex = MCDZZEntry.ResultData.ImgTable[i * 5 + index];
            if iconIndex == 12 then
                _scatterCount = _scatterCount + 1;
                if _scatterCount== 1 and (isPlayscatter or index==1)  then
                    MCDZZ_Audio.PlaySound("Button_"..(index+3));
                    -- if index == 1 then
                --         MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.Button_4);
                    -- end
                -- elseif self.scatterCount == 2 and isPlayscatter ==true then
                --     if index == 2  then
                --         MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.Button_5);
                --     end
                -- elseif self.scatterCount == 3 and isPlayscatter ==true then
                --     if index == 3  then
                --         MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.Button_6);  
                --     end
                end
            end
        end
        local changeIcon = MCDZZEntry.icons:Find(MCDZZ_DataConfig.IconTable[iconIndex + 1]):GetComponent("Image").sprite;
        if index==1 or (index <= 3 and index>1 and self.scatterCount== index-1)then
            if _scatterCount== 1 and iconIndex==12   then
                if img.transform.childCount <= 0 then
                    local go = MCDZZ_Line.CreateEffect(MCDZZ_DataConfig.GetEffectName(13));
                    if go ~= nil then
                        go.transform:SetParent(img.transform);
                        go.transform:Find("Image").gameObject:SetActive(false)
                        go.transform.localPosition = Vector3.New(0, 0, 0);
                        go.transform.localRotation = Quaternion.identity;
                        go.transform.localScale = Vector3.New(1, 1, 1);
                        go.gameObject:SetActive(true);
                        go.name = MCDZZ_DataConfig.EffectTable[13];
                        img.enabled = false;
                    end
                end
                table.insert(MCDZZEntry.scatterList, img.transform);
            end
        end

        img.sprite = changeIcon;
        if i ~= iconParent.childCount - 1 then
            iconParent:GetChild(i).gameObject.name = MCDZZ_DataConfig.IconTable[iconIndex + 1];
        end
        img:SetNativeSize();
        local tempIcon = iconParent:GetChild(i):Find("Temp");
        if tempIcon ~= nil then
            iconIndex = math.random(0, 9);
            changeIcon = MCDZZEntry.icons:Find(MCDZZ_DataConfig.IconTable[iconIndex + 1]):GetComponent("Image").sprite;
            tempIcon:GetComponent("Image").sprite = changeIcon;
            tempIcon:GetComponent("Image"):SetNativeSize();
        end
    end
    if _scatterCount>0 then
        self.scatterCount = self.scatterCount + 1; 
    end
    if index==1 and _scatterCount > 0 then
        isPlayscatter=true
    end
end