Module13_Roll = {}

local self = Module13_Roll;
self.rollList = {};
self.rollIndex = 0;
self.StopIndex = 0;
self.currentState = 0;--0:待机，1：正常转动,2:停止
self.timer = 0;
self.startTimer = 0;
self.stopTimer = 0;
function Module13_Roll.Init(obj)
    --初始化转动
    self.rollList = {};
    self.currentState = 0;
    for i = 1, obj.transform.childCount do
        local rect = obj.transform:GetChild(i - 1):GetComponent("ScrollRect");
        local temp1 = newObject(rect.content:GetChild(0):GetChild(0).gameObject);
        temp1.transform:SetParent(rect.content:GetChild(0));
        temp1.transform.localPosition = Vector3.New(0, 183, 0);
        temp1.transform.localRotation = Quaternion.identity;
        temp1.transform.localScale = Vector3.New(1, 1, 1);
        temp1.gameObject.name = "Temp";
        local temp2 = newObject(rect.content:GetChild(0):GetChild(0).gameObject);
        temp2.transform:SetParent(rect.content:GetChild(rect.content.childCount - 1));
        temp2.transform.localPosition = Vector3.New(0, -183, 0);
        temp2.transform.localRotation = Quaternion.identity;
        temp2.transform.localScale = Vector3.New(1, 1, 1);
        temp2.gameObject.name = "Temp";
        rect.verticalNormalizedPosition = 0;
        rect.elasticity = Module13_DataConfig.rollReboundRate;
        table.insert(self.rollList, rect);
    end
end
function Module13_Roll.StartRoll()
    Module13_Audio.PlaySound(Module13_Audio.SoundList.StarRoll);

    self.rollIndex = 0;
    self.StopIndex = 0;
    self.timer = Module13_DataConfig.rollInterval;
    self.stopTimer = 0;
    self.startTimer = 0;
    self.currentState = 1;
end
function Module13_Roll.StopRoll()
    Module13_Audio.StopPlaySound(Module13_Audio.SoundList.StarRoll)
    if self.rollIndex == #self.rollList then
        self.currentState = 2;
    end
end
function Module13_Roll.Update()
    if self.currentState == 0 then
        --待机状态
        return ;
    elseif self.currentState == 1 then
        --正常旋转
        for i = 1, self.rollIndex do
            self.rollList[i].verticalNormalizedPosition = self.rollList[i].verticalNormalizedPosition + Time.deltaTime * Module13_DataConfig.rollSpeed;--旋转
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
        if self.startTimer <= Module13_DataConfig.rollTime then
            --计算旋转时间，时间到就停止
            self.startTimer = self.startTimer + Time.deltaTime;
            if self.startTimer >= Module13_DataConfig.rollTime then
                self.currentState = 2;
            end
        end
    elseif self.currentState == 2 then
        for i = 1, self.rollIndex do
            if self.StopIndex < i then
                self.rollList[i].verticalNormalizedPosition = self.rollList[i].verticalNormalizedPosition + Time.deltaTime * Module13_DataConfig.rollSpeed;--旋转
                if self.rollList[i].verticalNormalizedPosition >= 1 then
                    self.rollList[i].verticalNormalizedPosition = 0;
                end
            end
        end
        if self.StopIndex < #self.rollList then
            --计算转动间隔
            self.stopTimer = self.stopTimer + Time.deltaTime;
            if self.stopTimer >= Module13_DataConfig.rollInterval then
                self.stopTimer = 0;
                self.StopIndex = self.StopIndex + 1;
                --TODO 换正式结果图片
                self.ChangeResultIcon(self.StopIndex);
                self.rollList[self.StopIndex].verticalNormalizedPosition = Module13_DataConfig.rollDistance;

                self.SingleRollStop();
                if self.StopIndex == #self.rollList then
                    self.currentState = 0;
                    Module13Entry.OnStop();
                end
            end
        end
    end
end
function Module13_Roll.SingleRollStop()
    --TODO 音效
    Module13_Audio.PlaySound(Module13_Audio.SoundList.RS);
end
function Module13_Roll.ChangeIconRoll(index)
    local iconParent = self.rollList[index].content;
    for i = 0, iconParent.childCount - 1 do
        local iconIndex = math.random(1, table.nums(Module13_DataConfig.IconTable));
        local changeIcon = Module13Entry.icons:Find(Module13_DataConfig.IconTable[iconIndex] .. "0"):GetComponent("Image").sprite;
        iconParent:GetChild(i):Find("Icon"):GetComponent("Image").sprite = changeIcon;
        local tempIcon = iconParent:GetChild(i):Find("Temp");
        if tempIcon ~= nil then
            tempIcon:GetComponent("Image").sprite = changeIcon;
            tempIcon:GetComponent("Image"):SetNativeSize();
        end
        iconParent:GetChild(i):Find("Icon"):GetComponent("Image"):SetNativeSize();
    end
end
function Module13_Roll.ChangeResultIcon(index)
    local iconParent = self.rollList[index].content;
    local GD=Module13Entry.CSGroup:GetChild(index-1)
    for i = 0, iconParent.childCount - 1 do
        local img = iconParent:GetChild(i):Find("Icon"):GetComponent("Image");
        local iconIndex = 1;
        if i == iconParent.childCount - 1 then
            iconIndex = math.random(2, table.nums(Module13_DataConfig.IconTable));
        else
            iconIndex = Module13Entry.ResultData.ImgTable[i * 5 + index] + 1;
        end
        local changeIcon = Module13Entry.icons:Find(Module13_DataConfig.IconTable[iconIndex]):GetComponent("Image").sprite;
        img.sprite = changeIcon;
        img:SetNativeSize();
        logYellow("iconIndex=="..iconIndex)
        if i<=2 and Module13Entry.isFireMode then
            if iconIndex==(Module13Entry.ResultData.ImgTable[1]+1) or iconIndex == 9 then
                GD:GetChild(i):Find("Icon"):GetComponent("Image").sprite=Module13Entry.icons:Find(Module13_DataConfig.IconTable[iconIndex]):GetComponent("Image").sprite;
                GD:GetChild(i):Find("Icon"):GetComponent("Image"):SetNativeSize();
                GD:GetChild(i).gameObject:SetActive(true)
            else
                GD:GetChild(i).gameObject:SetActive(false)
            end
        end

        local tempIcon = iconParent:GetChild(i):Find("Temp");
        if tempIcon ~= nil then
            iconIndex = math.random(2, table.nums(Module13_DataConfig.IconTable));
            changeIcon = Module13Entry.icons:Find(Module13_DataConfig.IconTable[iconIndex]):GetComponent("Image").sprite;
            tempIcon:GetComponent("Image").sprite = changeIcon;
            tempIcon:GetComponent("Image"):SetNativeSize();
        end
    end
   -- Module13Entry.CSGroup:GetChild(index-1).gameObject:SetActive(false)
end