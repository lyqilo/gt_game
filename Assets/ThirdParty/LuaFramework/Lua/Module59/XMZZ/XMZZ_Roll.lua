XMZZ_Roll = {}

local self = XMZZ_Roll;
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
function XMZZ_Roll.Init(obj)
    --初始化转动
    self.rollList = {};
    self.currentState = 0;
    self.isstop = false;
    self.scatterCount = 0;
    XMZZEntry.ScatterList = {};
    for i = 1, obj.transform.childCount do
        local rect = obj.transform:GetChild(i - 1):GetComponent("ScrollRect");
        local tempObj = GameObject.New("TempGroup");
        tempObj.transform:SetParent(rect.content:GetChild(0));
        tempObj.transform.localPosition = Vector3.New(0, 150 * 2.5, 0);
        tempObj.transform.localRotation = Quaternion.identity;
        tempObj.transform.localScale = Vector3.New(1, 1, 1);
        for j = 1, 4 do
            local temp1 = newObject(rect.content:GetChild(0):GetChild(0).gameObject);
            temp1.transform:SetParent(tempObj.transform);
            temp1.transform.localPosition = Vector3.New(0, 150 * (j - 2.5), 0);
            temp1.transform.localRotation = Quaternion.identity;
            temp1.transform.localScale = Vector3.New(1, 1, 1);
            temp1.gameObject.name = "Temp";
        end

        local temp2 = newObject(rect.content:GetChild(0):GetChild(0).gameObject);
        temp2.transform:SetParent(rect.content:GetChild(rect.content.childCount - 1));
        temp2.transform.localPosition = Vector3.New(0, -150, 0);
        temp2.transform.localRotation = Quaternion.identity;
        temp2.transform.localScale = Vector3.New(1, 1, 1);
        temp2.gameObject.name = "Temp";
        rect.verticalNormalizedPosition = 0;
        rect.elasticity = XMZZ_DataConfig.rollReboundRate;
        table.insert(self.rollList, rect);
    end
    for i = 1, #self.rollList do
        self.ChangeIconRoll(i);
    end
end
function XMZZ_Roll.ReRoll()
    for i = 1, 5 do
        self.ChangeResultIcon(i);
        local content = self.rollList[i].content;
        for j = 1, content.childCount do
            content:GetChild(j - 1):DOLocalMove(Vector3.New(0, XMZZ_DataConfig.ItemPosList[j], 0), 0.2):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                XMZZ_Audio.PlaySound(XMZZ_Audio.SoundList.Normal_Drop);
            end);
        end
    end
    XMZZEntry.DelayCall(0.3, function()
        XMZZEntry.OnStop();
    end);
end
function XMZZ_Roll.StartRoll()
    XMZZ_Audio.PlaySound(XMZZ_Audio.SoundList.Normal_ReelRun);
    self.rollIndex = 0;
    self.StopIndex = 0;
    self.timer = XMZZ_DataConfig.rollInterval;
    self.stopTimer = 0;
    self.startTimer = 0;
    self.currentState = 1;
    self.scatterCount = 0;
    self.scatter = true;
    self.isstop = false;
    XMZZEntry.ScatterList = {};
    log("开始转动")
end
function XMZZ_Roll.StopRoll()
    if self.isstop then
        return ;
    end
    self.isstop = true;
    if self.rollIndex == #self.rollList then
        self.stopTimer = XMZZ_DataConfig.rollInterval;
        self.currentState = 2;
    end
end
function XMZZ_Roll.Update()
    if self.currentState == 0 then
        --待机状态
        return ;
    elseif self.currentState == 1 then
        --正常旋转
        for i = 1, self.rollIndex do
            self.rollList[i].verticalNormalizedPosition = self.rollList[i].verticalNormalizedPosition + Time.deltaTime * XMZZ_DataConfig.rollSpeed;--旋转
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
        if self.startTimer <= XMZZ_DataConfig.rollTime then
            --计算旋转时间，时间到就停止
            self.startTimer = self.startTimer + Time.deltaTime;
            if self.startTimer >= XMZZ_DataConfig.rollTime then
                self.currentState = 2;
                self.isstop = true;
            end
        end
    elseif self.currentState == 2 then
        for i = 1, self.rollIndex do
            if self.StopIndex < i then
                self.rollList[i].verticalNormalizedPosition = self.rollList[i].verticalNormalizedPosition + Time.deltaTime * XMZZ_DataConfig.rollSpeed;--旋转
                if self.rollList[i].verticalNormalizedPosition >= 1 and self.StopIndex < i - 1 then
                    self.rollList[i].verticalNormalizedPosition = 0;
                    self.ChangeIconRoll(i);
                end
            end
        end
        if self.StopIndex < #self.rollList then
            --计算转动间隔
            self.stopTimer = self.stopTimer + Time.deltaTime;
            if self.stopTimer >= XMZZ_DataConfig.rollInterval then
                self.stopTimer = 0;
                self.StopIndex = self.StopIndex + 1;
                --TODO 换正式结果图片
                local _scatterCount = self.ChangeResultIcon(self.StopIndex);
                local stopindex = self.StopIndex;
                self.rollList[stopindex].verticalNormalizedPosition = 1;
                self.rollList[stopindex].content:DOLocalMove(Vector3.New(90, -XMZZ_DataConfig.rollDistance, 0), 0.1):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                    local timer = 0.1;
                    --log("stopIndex:::" .. stopindex);
                    self.rollList[stopindex].content:DOLocalMove(Vector3.New(90, 0, 0), timer):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                        --log("stopIndex::====:" .. stopindex);
                        if self.rollList[stopindex].transform:GetComponent("CanvasGroup").alpha == 1 then
                            XMZZ_Audio.PlaySound(XMZZ_Audio.SoundList.RollStop);
                        end
                        if stopindex == #self.rollList then
                            self.currentState = 0;
                            XMZZEntry.OnStop();
                        end
                    end);
                end);
            end
        end
    end
end
function XMZZ_Roll.ChangeIconRoll(index)
    local iconParent = self.rollList[index].content;
    for i = 0, iconParent.childCount - 1 do
        local iconIndex = math.random(1, 7);
        local changeIcon = XMZZEntry.icons:Find(XMZZ_DataConfig.IconTable[iconIndex + 1]):GetComponent("Image").sprite;
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
function XMZZ_Roll.ChangeResultIcon(index)
    if index > #self.rollList then
        return ;
    end
    local iconParent = self.rollList[index].content;
    local csIconParent = XMZZEntry.CSGroup:GetChild(index - 1);
    local longtype = 0;
    local longlist = {};
    for i = 0, 2 do
        local longIndex = XMZZEntry.ResultData.ImgTable[i * 5 + index];
        if longIndex == 9 then
            table.insert(longlist, i);
        end
    end
    if #longlist > 0 then
        local count = #longlist;
        if count == 1 then
            if longlist[1] == 0 then
                longtype = 1;--第一格为竹根
            elseif longlist[1] == 1 then
                longtype = 2;--第二格为普通龙根
            else
                longtype = 3;--第三格为竹尖
            end
        elseif count == 2 then
            if longlist[1] == 0 then
                if longlist[2] == 1 then
                    longtype = 4;--第一格为竹身,第二格为竹根
                else
                    longtype = 5;--第一格为竹根,第三格为竹尖
                end
            else
                longtype = 6;--第二格为竹尖,第三个为竹身
            end
        else
            longtype = 7;--全竹
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
            iconIndex = math.random(1, 7);
        else
            iconIndex = XMZZEntry.ResultData.ImgTable[i * 5 + index];
            if iconIndex == 9 then
                if longtype == 1 then
                    iconIndex = 12;
                elseif longtype == 2 then
                    iconIndex = 9;
                elseif longtype == 3 then
                    iconIndex = 10;
                elseif longtype == 4 then
                    if i == 0 then
                        iconIndex = 11;
                    else
                        iconIndex = 12;
                    end
                elseif longtype == 5 then
                    if i == 0 then
                        iconIndex = 12;
                    else
                        iconIndex = 10;
                    end
                elseif longtype == 6 then
                    if i == 1 then
                        iconIndex = 10;
                    else
                        iconIndex = 11;
                    end
                elseif longtype == 7 then
                    if i == 0 then
                        iconIndex = 10;
                    elseif i == 1 then
                        iconIndex = 11;
                    else
                        iconIndex = 12;
                    end
                end
                if iconIndex > 12 then
                    iconIndex = 12;
                end
            end
        end
        local changeIcon = XMZZEntry.icons:Find(XMZZ_DataConfig.IconTable[iconIndex + 1]):GetComponent("Image").sprite;
        img.sprite = changeIcon;
        img:SetNativeSize();
        if csimg ~= nil then
            csimg.sprite = changeIcon;
            csimg:SetNativeSize();
        end
        if i ~= iconParent.childCount - 1 then
            iconParent:GetChild(i).gameObject.name = XMZZ_DataConfig.IconTable[iconIndex + 1];
            csIconParent:GetChild(i).gameObject.name = XMZZ_DataConfig.IconTable[iconIndex + 1];
        end
        local tempgroup = iconParent:GetChild(i):Find("TempGroup");
        if tempgroup ~= nil then
            for j = 1, tempgroup.childCount do
                local tempIcon = tempgroup:GetChild(j - 1);
                if tempgroup.parent.name == "Item10_2" then
                    if j == 1 then
                        iconIndex = 10;
                    else
                        iconIndex = math.random(1, 7);
                    end
                elseif tempgroup.parent.name == "Item10_3" then
                    if j == 1 then
                        iconIndex = 11;
                    elseif j == 2 then
                        iconIndex = 10;
                    else
                        iconIndex = math.random(1, 7);
                    end
                else
                    iconIndex = math.random(1, 7);
                end
                changeIcon = XMZZEntry.icons:Find(XMZZ_DataConfig.IconTable[iconIndex + 1]):GetComponent("Image").sprite;
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