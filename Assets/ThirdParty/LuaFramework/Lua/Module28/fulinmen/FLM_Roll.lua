FLM_Roll = {}

local self = FLM_Roll;
self.rollList = {};
self.rollIndex = 0;
self.StopIndex = 0;
self.currentState = 0;--0:待机，1：正常转动,2:停止
self.timer = 0;
self.startTimer = 0;
self.stopTimer = 0;
function FLM_Roll.Init(obj)
    --初始化转动
    self.rollList = {};
    self.currentState = 0;
    for i = 1, obj.transform.childCount do
        local rect = obj.transform:GetChild(i - 1):GetComponent("ScrollRect");
        local temp1 = newObject(rect.content:GetChild(0):GetChild(0).gameObject);
        temp1.transform:SetParent(rect.content:GetChild(0));
        temp1.transform.localPosition = Vector3.New(0, 162, 0);
        temp1.transform.localRotation = Quaternion.identity;
        temp1.transform.localScale = Vector3.New(1, 1, 1);
        temp1.gameObject.name = "Temp";
        local temp2 = newObject(rect.content:GetChild(0):GetChild(0).gameObject);
        temp2.transform:SetParent(rect.content:GetChild(rect.content.childCount - 1));
        temp2.transform.localPosition = Vector3.New(0, -162, 0);
        temp2.transform.localRotation = Quaternion.identity;
        temp2.transform.localScale = Vector3.New(1, 1, 1);
        temp2.gameObject.name = "Temp";
        rect.verticalNormalizedPosition = 0;
        rect.elasticity = FLM_DataConfig.rollReboundRate;
        table.insert(self.rollList, rect);
    end
end
function FLM_Roll.StartRoll()
    self.rollIndex = 0;
    self.StopIndex = 0;
    self.timer = FLM_DataConfig.rollInterval;
    self.stopTimer = 0;
    self.startTimer = 0;
    self.currentState = 1;
    FLM_Audio.PlaySound(FLM_Audio.SoundList.Turn);
end
function FLM_Roll.StopRoll()
    if self.rollIndex == #self.rollList then
        self.currentState = 2;
    end
end
function FLM_Roll.Update()
    if self.currentState == 0 then
        --待机状态
        return ;
    elseif self.currentState == 1 then
        --正常旋转
        for i = 1, self.rollIndex do
            self.rollList[i].verticalNormalizedPosition = self.rollList[i].verticalNormalizedPosition + Time.deltaTime * FLM_DataConfig.rollSpeed;--旋转
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
        if self.startTimer <= FLM_DataConfig.rollTime then
            --计算旋转时间，时间到就停止
            self.startTimer = self.startTimer + Time.deltaTime;
            if self.startTimer >= FLM_DataConfig.rollTime then
                self.currentState = 2;
            end
        end
    elseif self.currentState == 2 then
        for i = 1, self.rollIndex do
            if self.StopIndex < i then
                self.rollList[i].verticalNormalizedPosition = self.rollList[i].verticalNormalizedPosition + Time.deltaTime * FLM_DataConfig.rollSpeed;--旋转
                if self.rollList[i].verticalNormalizedPosition >= 1 then
                    self.rollList[i].verticalNormalizedPosition = 0;
                    self.ChangeIconRoll(i);
                end
            end
        end
        if self.StopIndex < #self.rollList then
            --计算转动间隔
            self.stopTimer = self.stopTimer + Time.deltaTime;
            if self.stopTimer >= FLM_DataConfig.rollInterval then
                self.stopTimer = 0;
                self.StopIndex = self.StopIndex + 1;
                --TODO 换正式结果图片
                self.ChangeResultIcon(self.StopIndex);
                self.rollList[self.StopIndex].verticalNormalizedPosition = FLM_DataConfig.rollDistance;
                --self.SingleRollStop();
                if self.StopIndex == #self.rollList then
                    self.currentState = 0;
                    FLMEntry.OnStop();
                end
            end
        end
    end
end

function FLM_Roll.SingleRollStop()
    --TODO 音效
    FLM_Audio.PlaySound(FLM_Audio.SoundList.Turn);
end
function FLM_Roll.ChangeIconRoll(index)
    local iconParent = self.rollList[index].content;
    for i = 0, iconParent.childCount - 1 do
        local iconIndex = math.random(1, 11);
        local changeIcon = FLMEntry.icons:Find(FLM_DataConfig.IconTable[iconIndex]):GetComponent("Image").sprite;
        iconParent:GetChild(i):Find("Icon"):GetComponent("Image").sprite = changeIcon;
        local tempIcon = iconParent:GetChild(i):Find("Temp");
        if tempIcon ~= nil then
            tempIcon:GetComponent("Image").sprite = changeIcon;
            tempIcon:GetComponent("Image"):SetNativeSize();
        end
        iconParent:GetChild(i):Find("Icon"):GetComponent("Image"):SetNativeSize();
        iconParent:GetChild(i):Find("Icon/Num"):GetComponent("TextMeshProUGUI").text = "";
    end
end
function FLM_Roll.ChangeResultIcon(index)
    local iconParent = self.rollList[index].content;
    for i = 0, iconParent.childCount - 1 do
        local img = iconParent:GetChild(i):Find("Icon"):GetComponent("Image");
        local iconIndex = 1;
        if i == iconParent.childCount - 1 then
            iconIndex = math.random(2, 11);
        else
            iconIndex = FLMEntry.ResultData.ImgTable[i * 5 + index] + 1;
        end
        local changeIcon = FLMEntry.icons:Find(FLM_DataConfig.IconTable[iconIndex]):GetComponent("Image").sprite;
        img.sprite = changeIcon;
        img:SetNativeSize();
        if iconIndex==12 then
            local num = img.transform:Find("Num"):GetComponent("TextMeshProUGUI");
            img.transform:Find("Num").gameObject:SetActive(true)
            num.transform:SetParent(img.transform);
            num.transform.localPosition = Vector3.New(10, 5, 0);
            num.transform.localScale = Vector3.New(1, 1, 1);
            num.gameObject.name = "Num";
            local shownum = FLMEntry.ResultData.GoldNum[i * 5 + index];
            if shownum == 0 then
                num.text = "";
            else
                if shownum == 1 then
                    --大福
                    num.text = FLMEntry.ShowText("d");
                elseif shownum == 2 then
                    --小福
                    num.text = FLMEntry.ShowText("x");
                else
                    num.text = FLMEntry.ShowText(FLMEntry.FormatNumberThousands(FLMEntry.ResultData.GoldNum[i * 5 + index]));
                end
            end
        end

        local tempIcon = iconParent:GetChild(i):Find("Temp");
        if tempIcon ~= nil then
            iconIndex = math.random(2, 11);
            changeIcon = FLMEntry.icons:Find(FLM_DataConfig.IconTable[iconIndex]):GetComponent("Image").sprite;
            tempIcon:GetComponent("Image").sprite = changeIcon;
            tempIcon:GetComponent("Image"):SetNativeSize();
        end
    end
end