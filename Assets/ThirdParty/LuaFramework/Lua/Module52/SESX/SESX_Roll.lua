SESX_Roll = {}

local self = SESX_Roll;
self.rollList = {};
self.rollIndex = 0;
self.StopIndex = 0;
self.currentState = 0;--0:待机，1：正常转动,2:停止
self.timer = 0;
self.startTimer = 0;
self.stopTimer = 0;
self.isstop = false;
self.scatterCount = 0;
self.isAddSpeed = false;
self.scatter = true;
self.stoplist = {};
self.isAutoStop = false;
function SESX_Roll.Init(obj)
    --初始化转动
    self.rollList = {};
    self.currentState = 0;
    self.isstop = false;
    self.scatterCount = 0;
    SESXEntry.ScatterList = {};
    for i = 1, obj.transform.childCount do
        local rect = obj.transform:GetChild(i - 1):GetComponent("ScrollRect");
        local tempObj = GameObject.New("TempGroup");
        tempObj.transform:SetParent(rect.content:GetChild(0));
        tempObj.transform.localPosition = Vector3.New(0, 152 * 2.5 + 4, 0);
        tempObj.transform.localRotation = Quaternion.identity;
        tempObj.transform.localScale = Vector3.New(1, 1, 1);
        for j = 1, 4 do
            local temp1 = newObject(rect.content:GetChild(0):GetChild(0).gameObject);
            temp1.transform:SetParent(tempObj.transform);
            temp1.transform.localPosition = Vector3.New(0, 152 * (j - 2.5), 0);
            temp1.transform.localRotation = Quaternion.identity;
            temp1.transform.localScale = Vector3.New(1, 1, 1);
            temp1.gameObject.name = "Temp";
        end

        local temp2 = newObject(rect.content:GetChild(0):GetChild(0).gameObject);
        temp2.transform:SetParent(rect.content:GetChild(rect.content.childCount - 1));
        temp2.transform.localPosition = Vector3.New(0, -152, 0);
        temp2.transform.localRotation = Quaternion.identity;
        temp2.transform.localScale = Vector3.New(1, 1, 1);
        temp2.gameObject.name = "Temp";
        rect.verticalNormalizedPosition = 0;
        rect.elasticity = SESX_DataConfig.rollReboundRate;
        table.insert(self.rollList, rect);
    end
    for i = 1, #self.rollList do
        self.ChangeIconRoll(i);
    end
end
function SESX_Roll.StartRoll()
    coroutine.start(function()
        coroutine.wait(0.5);
        SESX_Audio.PlaySound(SESX_Audio.SoundList.Rolling);
    end);
    self.rollIndex = 0;
    self.StopIndex = 0;
    self.timer = SESX_DataConfig.rollInterval;
    self.stopTimer = 0;
    self.startTimer = 0;
    self.currentState = 1;
    self.scatterCount = 0;
    self.isAddSpeed = false;
    self.isAutoStop = false;
    self.scatter = true;
    self.isstop = false;
    self.stoplist = { false, false, false, false, false };
    SESXEntry.ScatterList = {};
    log("开始转动")
end
function SESX_Roll.StopRoll()
    if self.isstop then
        return ;
    end
    self.isstop = true;
    self.isAutoStop = true;
    if self.rollIndex == #self.rollList then
        self.stopTimer = SESX_DataConfig.rollInterval;
        self.currentState = 2;
    end
end
function SESX_Roll.Update()
    if self.currentState == 0 then
        --待机状态
        return ;
    elseif self.currentState == 1 then
        --正常旋转
        for i = 1, self.rollIndex do
            self.rollList[i].verticalNormalizedPosition = self.rollList[i].verticalNormalizedPosition + Time.deltaTime * SESX_DataConfig.rollSpeed;--旋转
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
                    self.isAutoStop = true;
                end
            end
        end
        if self.startTimer <= SESX_DataConfig.rollTime then
            --计算旋转时间，时间到就停止
            self.startTimer = self.startTimer + Time.deltaTime;
            if self.startTimer >= SESX_DataConfig.rollTime then
                self.currentState = 2;
                self.isstop = true;
            end
        end
    elseif self.currentState == 2 then
        for i = 1, self.rollIndex do
            if self.StopIndex < i then
                self.rollList[i].verticalNormalizedPosition = self.rollList[i].verticalNormalizedPosition + Time.deltaTime * SESX_DataConfig.rollSpeed;--旋转
                if self.rollList[i].verticalNormalizedPosition >= 1 and self.StopIndex < i - 1 then
                    self.rollList[i].verticalNormalizedPosition = 0;
                    self.ChangeIconRoll(i);
                end
            end
        end
        if self.StopIndex < #self.rollList then
            --计算转动间隔
            self.stopTimer = self.stopTimer + Time.deltaTime;
            if self.stopTimer >= SESX_DataConfig.rollInterval then
                if self.isAddSpeed then
                    if self.stopTimer < SESX_DataConfig.addSpeedTime then
                        if self.rollList[self.StopIndex + 1].verticalNormalizedPosition >= 1 then
                            self.rollList[self.StopIndex + 1].verticalNormalizedPosition = 0;
                            self.ChangeIconRoll(self.StopIndex + 1);
                        end
                        return ;
                    end
                end
                self.stopTimer = 0;
                self.StopIndex = self.StopIndex + 1;
                --TODO 换正式结果图片
                local _scatterCount = self.ChangeResultIcon(self.StopIndex);
                local stopindex = self.StopIndex;
                if not self.isAutoStop then
                    self.AddSpeed();
                end
                self.rollList[stopindex].verticalNormalizedPosition = 1;
                self.rollList[stopindex].content:DOLocalMove(Vector3.New(90, -SESX_DataConfig.rollDistance, 0), 0.1):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                    local timer = 0.1;
                    log("stopIndex:::" .. stopindex);
                    self.rollList[stopindex].content:DOLocalMove(Vector3.New(90, 0, 0), timer):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                        log("stopIndex::====:" .. stopindex);
                        SESX_Audio.PlaySound(SESX_Audio.SoundList.RollStop);
                        if stopindex == #self.rollList then
                            self.currentState = 0;
                            SESXEntry.OnStop();
                        end
                    end);
                end);
            end
        end
    end
end
function SESX_Roll.AddSpeed()
    SESXEntry.AddSpeedObj:SetActive(false);
    if self.scatterCount == 2 and self.StopIndex == 4 then
        self.isAddSpeed = true;
        SESXEntry.AddSpeedObj:SetActive(true);
        --TODO 播放加速音效,延时销毁
        SESX_Audio.PlaySound(SESX_Audio.SoundList.Shengxiao_SpeedUp);
    end
end
function SESX_Roll.ChangeIconRoll(index)
    local iconParent = self.rollList[index].content;
    for i = 0, iconParent.childCount - 1 do
        local iconIndex = math.random(1, 10);
        local changeIcon = SESXEntry.icons:Find(SESX_DataConfig.IconTable[iconIndex]):GetComponent("Image").sprite;
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
function SESX_Roll.ChangeResultIcon(index)
    if index > #self.rollList then
        return ;
    end
    local iconParent = self.rollList[index].content;
    local csIconParent = SESXEntry.CSGroup:GetChild(index - 1);
    local longtype = 0;
    local longlist = {};
    for i = 0, 2 do
        local longIndex = SESXEntry.ResultData.ImgTable[i * 5 + index];
        if longIndex == 13 then
            table.insert(longlist, i);
        end
    end
    if #longlist > 0 then
        local count = #longlist;
        if count == 1 then
            if longlist[1] == 0 then
                longtype = 1;--第一格为龙尾
            else
                longtype = 2;--第三格为龙头
            end
        elseif count == 2 then
            if longlist[1] == 0 then
                if longlist[2] == 1 then
                    longtype = 3;--第一格为龙身,第二格为龙尾
                else
                    longtype = 4;--第一格为龙尾,第三格为龙头
                end
            else
                longtype = 5;--第二格为龙头,第三个为龙身
            end
        else
            longtype = 6;--全龙
        end
    end
    local isscatter = 0;
    for i = 0, iconParent.childCount - 1 do
        local img = iconParent:GetChild(i):Find("Icon"):GetComponent("Image");
        local csimg = nil;
        if i < csIconParent.childCount then
            csimg = csIconParent:GetChild(i):Find("Icon"):GetComponent("Image");
        end
        local iconIndex = 1;
        if i == iconParent.childCount - 1 then
            iconIndex = math.random(1, 10);
        else
            iconIndex = SESXEntry.ResultData.ImgTable[i * 5 + index];
            if iconIndex == 12 then
                if index == 1 and self.scatterCount == 0 then
                    --scatter动画
                    isscatter = 1;
                    SESX_Audio.PlaySound(SESX_Audio.SoundList.Shengxiao_Scatter_First);
                elseif index == 3 and self.scatterCount == 1 then
                    isscatter = 2;
                    SESX_Audio.PlaySound(SESX_Audio.SoundList.Shengxiao_Scatter_Second);
                elseif index == 5 and self.scatterCount == 2 then
                    isscatter = 3;
                    SESX_Audio.PlaySound(SESX_Audio.SoundList.Shengxiao_Scatter_Third);
                end
                if isscatter > 0 then
                    self.scatterCount = self.scatterCount + 1;
                    local go = SESX_Line.CreateEffect(SESX_DataConfig.EffectTable[12]);
                    go.transform:SetParent(img.transform);
                    go.transform.localPosition = Vector3.New(0, 0, 0);
                    go.transform.localRotation = Quaternion.identity;
                    go.transform.localScale = Vector3.New(1, 1, 1);
                    go.gameObject:SetActive(true);
                    go.name = SESX_DataConfig.EffectTable[12];
                    go.transform:Find("Anim"):GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0, "chuxian", false);
                    img.enabled = false;
                    table.insert(SESXEntry.ScatterList, go);
                end
            elseif iconIndex == 13 then
                if longtype == 1 then
                    iconIndex = 16;
                elseif longtype == 2 then
                    iconIndex = 14;
                elseif longtype == 3 then
                    if i == 0 then
                        iconIndex = 15;
                    else
                        iconIndex = 16;
                    end
                elseif longtype == 4 then
                    if i == 0 then
                        iconIndex = 16;
                    else
                        iconIndex = 14;
                    end
                elseif longtype == 5 then
                    if i == 1 then
                        iconIndex = 14;
                    else
                        iconIndex = 15;
                    end
                elseif longtype == 6 then
                    if i == 0 then
                        iconIndex = 14;
                    elseif i == 1 then
                        iconIndex = 15;
                    else
                        iconIndex = 16;
                    end
                end
                if iconIndex > 16 then
                    iconIndex = 16;
                end
            end
        end
        local changeIcon = SESXEntry.icons:Find(SESX_DataConfig.IconTable[iconIndex]):GetComponent("Image").sprite;
        img.sprite = changeIcon;
        img:SetNativeSize();
        if csimg ~= nil then
            csimg.sprite = changeIcon;
            csimg:SetNativeSize();
        end
        if i ~= iconParent.childCount - 1 then
            iconParent:GetChild(i).gameObject.name = SESX_DataConfig.IconTable[iconIndex];
            csIconParent:GetChild(i).gameObject.name = SESX_DataConfig.IconTable[iconIndex];
        end
        local tempgroup = iconParent:GetChild(i):Find("TempGroup");
        if tempgroup ~= nil then
            for j = 1, tempgroup.childCount do
                local tempIcon = tempgroup:GetChild(j - 1);
                if tempgroup.parent.name == "Item13_2" then
                    if j == 1 then
                        iconIndex = 14;
                    else
                        iconIndex = math.random(1, 10);
                    end
                elseif tempgroup.parent.name == "Item13_3" then
                    if j == 1 then
                        iconIndex = 15;
                    elseif j == 2 then
                        iconIndex = 14;
                    else
                        iconIndex = math.random(1, 10);
                    end
                else
                    iconIndex = math.random(1, 10);
                end
                changeIcon = SESXEntry.icons:Find(SESX_DataConfig.IconTable[iconIndex]):GetComponent("Image").sprite;
                tempIcon:GetComponent("Image").sprite = changeIcon;
                tempIcon:GetComponent("Image"):SetNativeSize();
            end
        end
    end
    if index == 4 and self.scatterCount == 2 then
        self.scatter = true;
    end
    return isscatter;
end