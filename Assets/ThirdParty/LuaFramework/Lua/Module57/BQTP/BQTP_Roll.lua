BQTP_Roll = {}

local self = BQTP_Roll;
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
function BQTP_Roll.Init(obj)
    --初始化转动
    self.rollList = {};
    self.currentState = 0;
    self.isstop = false;
    self.scatterCount = 0;
    BQTPEntry.ScatterList = {};
    for i = 1, obj.transform.childCount do
        local rect = obj.transform:GetChild(i - 1):GetComponent("ScrollRect");
        rect.verticalNormalizedPosition = 0;
        rect.elasticity = BQTP_DataConfig.rollReboundRate;
        table.insert(self.rollList, rect);
    end
    for i = 1, #self.rollList do
        self.ChangeIconRoll(i);
    end
end
function BQTP_Roll.ReRoll()
    for i = 1, 5 do
        self.ChangeResultIcon(i);
        local content = self.rollList[i].content;
        for j = 1, content.childCount do
            content:GetChild(j - 1):DOLocalMove(Vector3.New(0, BQTP_DataConfig.ItemPosList[j], 0), 0.2):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                BQTP_Audio.PlaySound(BQTP_Audio.SoundList.Normal_Drop);
            end);
        end
    end
    BQTPEntry.DelayCall(0.3, function()
        BQTPEntry.OnStop();
    end);
end
function BQTP_Roll.StartRoll()
    BQTP_Audio.PlaySound(BQTP_Audio.SoundList.Normal_ReelRun);
    self.rollIndex = 0;
    self.StopIndex = 0;
    self.timer = BQTP_DataConfig.rollInterval;
    self.stopTimer = 0;
    self.startTimer = 0;
    self.currentState = 1;
    self.scatterCount = 0;
    self.scatter = true;
    self.isstop = false;
    BQTPEntry.ScatterList = {};
    log("开始转动")
    if BQTPEntry.ResultData.cbSpecialWild > 0 then
        local index = math.random(0, 2);
        local child = BQTPEntry.CSGroup:GetChild(BQTPEntry.ResultData.cbSpecialWild - 1):GetChild(index);
        child.gameObject:SetActive(true);
        BQTP_Audio.PlaySound(BQTP_Audio.SoundList.Wild);
        local anim = child:GetComponent("UnityArmatureComponent");
        anim:AddDBEventListener(DragonBones.EventObject.COMPLETE, function(type, eventobject)
            child.gameObject:SetActive(false);
        end);
        anim.dbAnimation:Play("Sprite", 1);
    end
end
function BQTP_Roll.StopRoll()
    if self.isstop then
        return ;
    end
    self.isstop = true;
    if self.rollIndex == #self.rollList then
        self.stopTimer = BQTP_DataConfig.rollInterval;
        self.currentState = 2;
    end
end
function BQTP_Roll.Update()
    if self.currentState == 0 then
        --待机状态
        return ;
    elseif self.currentState == 1 then
        --正常旋转
        for i = 1, self.rollIndex do
            self.rollList[i].verticalNormalizedPosition = self.rollList[i].verticalNormalizedPosition + Time.deltaTime * BQTP_DataConfig.rollSpeed;--旋转
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
            end
        end
        if self.startTimer <= BQTP_DataConfig.rollTime then
            --计算旋转时间，时间到就停止
            self.startTimer = self.startTimer + Time.deltaTime;
            if self.startTimer >= BQTP_DataConfig.rollTime then
                self.currentState = 2;
            end
        end
    elseif self.currentState == 2 then
        for i = 1, self.rollIndex do
            if self.StopIndex < i then
                self.rollList[i].verticalNormalizedPosition = self.rollList[i].verticalNormalizedPosition + Time.deltaTime * BQTP_DataConfig.rollSpeed;--旋转
                if self.rollList[i].verticalNormalizedPosition >= 1 and self.StopIndex < i - 1 then
                    self.rollList[i].verticalNormalizedPosition = 0;
                    self.ChangeIconRoll(i);
                end
            end
        end
        if self.StopIndex < #self.rollList then
            --计算转动间隔
            self.stopTimer = self.stopTimer + Time.deltaTime;
            if self.stopTimer >= BQTP_DataConfig.rollInterval then
                self.stopTimer = 0;
                self.StopIndex = self.StopIndex + 1;
                --TODO 换正式结果图片
                self.ChangeResultIcon(self.StopIndex);
                local stopindex = self.StopIndex;
                self.rollList[stopindex].verticalNormalizedPosition = 0;
                self.rollList[stopindex].content:DOLocalMove(Vector3.New(90, -BQTP_DataConfig.rollDistance - 500, 0), 0.1):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                    local timer = 0.2;
                    self.rollList[stopindex].content:DOLocalMove(Vector3.New(90, -500, 0), timer):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                        log("stopIndex::====:" .. stopindex);
                        BQTP_Audio.PlaySound(BQTP_Audio.SoundList.Normal_ReelStop);
                        if stopindex == #self.rollList then
                            self.currentState = 0;
                            BQTPEntry.OnStop();
                        end
                    end);
                end);
            end
        end
    end
end
function BQTP_Roll.ChangeIconRoll(index)
    local iconParent = self.rollList[index].content;
    for i = 0, iconParent.childCount - 1 do
        local iconIndex = math.random(1, 9);
        local changeIcon = BQTPEntry.icons:Find(BQTP_DataConfig.IconTable[iconIndex]):GetComponent("Image").sprite;
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
function BQTP_Roll.ChangeResultIcon(index)
    if index > #self.rollList then
        return ;
    end
    local iconParent = self.rollList[index].content;
    local hasScatter = false;
    for i = 0, iconParent.childCount - 1 do
        local img = iconParent:GetChild(i):Find("Icon"):GetComponent("Image");
        img.enabled = true;
        local iconIndex = 1;
        if i >= 3 then
            iconIndex = math.random(1, 8);
        else
            iconIndex = BQTPEntry.ResultData.ImgTable[(2 - i) * 5 + index] + 1;
        end
        local changeIcon = BQTPEntry.icons:Find(BQTP_DataConfig.IconTable[iconIndex]):GetComponent("Image").sprite;
        img.sprite = changeIcon;
        img:SetNativeSize();
        iconParent:GetChild(i).gameObject.name = BQTP_DataConfig.IconTable[iconIndex];
    end
end