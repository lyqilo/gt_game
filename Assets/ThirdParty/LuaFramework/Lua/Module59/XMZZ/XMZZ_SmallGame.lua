XMZZ_SmallGame = {};

local self = XMZZ_SmallGame;

self.rollList = {};
self.rollIndex = 0;
self.StopIndex = 0;
self.currentState = 0;--0:待机，1：正常转动,2:停止
self.timer = 0;
self.startTimer = 0;
self.stopTimer = 0;
self.isstop = false;
self.stopIndex = 0;
self.currentPos = 0;
self.needMove = 0;
self.centerList = {};--中间中奖个数
function XMZZ_SmallGame.Init(obj)
    --初始化转动
    self.midroll = obj.transform:Find("Body/MiddleRoll");
    self.rollGroup = obj.transform:Find("Body/Group");
    self.smallGameCount = obj.transform:Find("Body/SmallGameCount"):GetComponent("TextMeshProUGUI");
    self.SelfGold = obj.transform:Find("Body/SelfGold"):GetComponent("TextMeshProUGUI");
    self.WinNum = obj.transform:Find("Body/WinNum"):GetComponent("TextMeshProUGUI");
    self.BetNum = obj.transform:Find("Body/BetNum"):GetComponent("TextMeshProUGUI");
    self.WinGroup = obj.transform:Find("Body/WinGroup");
    self.rollList = {};
    self.currentState = 0;
    self.isstop = false;
    self.scatterCount = 0;
    for i = 1, self.midroll.transform.childCount do
        local rect = self.midroll.transform:GetChild(i - 1):GetComponent("ScrollRect");
        local temp1 = newObject(rect.content:GetChild(0):GetChild(0).gameObject);
        temp1.transform:SetParent(rect.content:GetChild(0));
        temp1.transform.localPosition = Vector3.New(0, 118, 0);
        temp1.transform.localRotation = Quaternion.identity;
        temp1.transform.localScale = Vector3.New(1, 1, 1);
        temp1.gameObject.name = "Temp";
        local temp2 = newObject(rect.content:GetChild(0):GetChild(0).gameObject);
        temp2.transform:SetParent(rect.content:GetChild(rect.content.childCount - 1));
        temp2.transform.localPosition = Vector3.New(0, -118, 0);
        temp2.transform.localRotation = Quaternion.identity;
        temp2.transform.localScale = Vector3.New(1, 1, 1);
        temp2.gameObject.name = "Temp";
        rect.verticalNormalizedPosition = 0;
        rect.elasticity = 0.135;
        rect.onValueChanged:RemoveAllListeners();
        table.insert(self.rollList, rect);
    end
end
function XMZZ_SmallGame.ShowSmallGame()
    XMZZ_SmallGame.SelfGold.text = XMZZEntry.ShowText(XMZZEntry.myGold);
    self.WinNum.text = XMZZEntry.ShowText(XMZZEntry.ResultData.WinScore);
    self.BetNum.text = XMZZEntry.ShowText(XMZZEntry.CurrentChip * XMZZ_DataConfig.ALLLINECOUNT);
    self.smallGameCount.text = XMZZEntry.ShowText(XMZZEntry.smallGameCount);
    coroutine.start(function()
        coroutine.wait(0.5);
        XMZZ_Network.StartSmallGame()
    end);
end
function XMZZ_SmallGame.Start()
    self.StartRoll();
    self.StartRollSmall();
end
function XMZZ_SmallGame.Update()
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
            end
        end
        --if self.startTimer <= XMZZ_DataConfig.rollTime then
        --    --计算旋转时间，时间到就停止
        --    self.startTimer = self.startTimer + Time.deltaTime;
        --    if self.startTimer >= XMZZ_DataConfig.rollTime then
        --        self.currentState = 2;
        --    end
        --end
    elseif self.currentState == 2 then
        for i = 1, self.rollIndex do
            if self.StopIndex < i then
                self.rollList[i].verticalNormalizedPosition = self.rollList[i].verticalNormalizedPosition + Time.deltaTime * XMZZ_DataConfig.rollSpeed;--旋转
                if self.rollList[i].verticalNormalizedPosition >= 1 then
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
                self.ChangeResultIcon(self.StopIndex);
                self.rollList[self.StopIndex].verticalNormalizedPosition = 1.5;
            end
        end
    end
end
function XMZZ_SmallGame.StartRollSmall()
    coroutine.start(function()
        self.stopIndex = XMZZ_DataConfig.SmallIconPos[XMZZEntry.SmallResultData.nIconType][XMZZEntry.SmallResultData.nIconTypeConut];
        --if self.stopIndex - self.currentPos < 0 then
        --    self.needMove = XMZZ_DataConfig.SMALLROLLCOUNT * 2 + self.stopIndex - self.currentPos;
        --else
        --    self.needMove = XMZZ_DataConfig.SMALLROLLCOUNT + self.stopIndex - self.currentPos;
        --end
        self.needMove = XMZZ_DataConfig.SMALLROLLCOUNT * 2 + self.stopIndex - self.currentPos;
        self.centerList = {};
        for i = 1, #XMZZEntry.SmallResultData.nIconType4 do
            if XMZZEntry.SmallResultData.nIconType4[i] == XMZZEntry.SmallResultData.nIconType then
                table.insert(self.centerList, i);
            end
        end
        if self.currentPos ~= 0 then
            self.rollGroup:GetChild(self.currentPos - 1):Find("Select").gameObject:SetActive(false);
            self.rollGroup:GetChild(self.currentPos - 1):Find("Bingo").gameObject:SetActive(false);
        end
        for i = 1, self.needMove do
            self.currentPos = self.currentPos + 1;
            if self.currentPos > XMZZ_DataConfig.SMALLROLLCOUNT then
                self.currentPos = self.currentPos - XMZZ_DataConfig.SMALLROLLCOUNT;
            end
            local select = self.rollGroup:GetChild(self.currentPos - 1):Find("Select");
            select.gameObject:SetActive(true);
            XMZZ_Audio.PlaySound(XMZZ_Audio.SoundList.SmallRoll);
            select:GetComponent("Image"):DOFade(1, XMZZ_DataConfig.smallMoveSpeed):OnComplete(function()
                select:GetComponent("Image"):DOFade(0, XMZZ_DataConfig.smallMoveSpeed * 5):OnComplete(function()
                    select.gameObject:SetActive(false);
                end);
            end);
            if self.currentState ~= 2 and i > self.needMove / 3 then
                self.currentState = 2;
            end
            if i < 3 then
                coroutine.wait(XMZZ_DataConfig.smallMoveSpeed * 8);
            elseif i >= 3 and i < 5 then
                coroutine.wait(XMZZ_DataConfig.smallMoveSpeed * 5);
            elseif self.needMove - i <= 5 and self.needMove - i > 3 then
                coroutine.wait(XMZZ_DataConfig.smallMoveSpeed * 5);
            elseif self.needMove - i <= 3 then
                coroutine.wait(XMZZ_DataConfig.smallMoveSpeed * 8);
            else
                coroutine.wait(XMZZ_DataConfig.smallMoveSpeed * 0.5);
            end
        end
        self.ShowBingo(self.rollGroup:GetChild(self.currentPos - 1));
        if #self.centerList > 0 then
            XMZZ_Audio.PlaySound(XMZZ_Audio.SoundList.SmallBingo);
        end
        if 8 == XMZZEntry.SmallResultData.nIconType then
            --炸弹
            XMZZ_Audio.PlaySound(XMZZ_Audio.SoundList.Bomb);
            local bob = self.rollGroup:GetChild(self.currentPos - 1):Find("zd");
            bob.gameObject:SetActive(true);
            coroutine.start(function()
                coroutine.wait(0.8);
                bob.gameObject:SetActive(false);
            end);
        end
        for i = 1, #self.centerList do
            local bingo = self.WinGroup:GetChild(self.centerList[i] - 1):GetComponent("Image");
            bingo.gameObject:SetActive(true);
            bingo:DOFade(1, 0.2):OnComplete(function()
                bingo:DOFade(0, 0.2):OnComplete(function()
                    bingo:DOFade(1, 0.2):OnComplete(function()
                        bingo:DOFade(0, 0.2):OnComplete(function()
                            bingo:DOFade(1, 0.2);
                        end);
                    end);
                end);
            end);
        end
        self.WinNum.text = XMZZEntry.ShowText(XMZZEntry.SmallResultData.nGameTatolGold + XMZZEntry.ResultData.WinScore);
        XMZZEntry.myGold = XMZZEntry.myGold + XMZZEntry.SmallResultData.nGameGold;
        XMZZEntry.SetSelfGold(XMZZEntry.myGold);
        coroutine.wait(1);
        self.ReStart();
    end);
end
function XMZZ_SmallGame.ShowBingo(obj)
    local bingo = obj:Find("Bingo"):GetComponent("Image");
    bingo.gameObject:SetActive(true);
    bingo:DOFade(1, 0.2):OnComplete(function()
        bingo:DOFade(0, 0.2):OnComplete(function()
            bingo:DOFade(1, 0.2):OnComplete(function()
                bingo:DOFade(0, 0.2):OnComplete(function()
                    bingo:DOFade(1, 0.2);
                end);
            end);
        end);
    end);
end
function XMZZ_SmallGame.ReStart()
    if self.currentPos ~= 0 then
        self.rollGroup:GetChild(self.currentPos - 1):Find("Select").gameObject:SetActive(false);
        self.rollGroup:GetChild(self.currentPos - 1):Find("Bingo").gameObject:SetActive(false);
        local bob = self.rollGroup:GetChild(self.currentPos - 1):Find("zd");
        if bob ~= nil then
            bob.gameObject:SetActive(false);
        end
    end
    for i = 1, self.WinGroup.childCount do
        self.WinGroup:GetChild(i - 1).gameObject:SetActive(false);
    end
    self.smallGameCount.text = XMZZEntry.ShowText(XMZZEntry.SmallResultData.nSmallGameConut);
    if XMZZEntry.SmallResultData.nSmallGameConut <= 0 then
        self.ShowResult();
    else
        coroutine.start(function()
            coroutine.wait(0.5);
            XMZZ_Network.StartSmallGame()
        end);
    end
end
function XMZZ_SmallGame.StartRoll()
    for i = 1, #self.rollList do
        self.rollList[i].onValueChanged:RemoveAllListeners();
    end
    self.rollIndex = 0;
    self.StopIndex = 0;
    self.timer = XMZZ_DataConfig.rollInterval;
    self.stopTimer = 0;
    self.startTimer = 0;
    self.currentState = 1;
    self.isstop = false;
    log("开始转动")
end
function XMZZ_SmallGame.StopRoll()
    if self.isstop then
        return ;
    end
    if self.rollIndex == #self.rollList then
        self.stopTimer = XMZZ_DataConfig.rollInterval;
        self.currentState = 2;
    end
    self.isstop = true;
end
function XMZZ_SmallGame.ShowResult()
    XMZZ_Audio.PlaySound(XMZZ_Audio.SoundList.SmallEnd);
    XMZZEntry.resultEffect.gameObject:SetActive(true);
    XMZZEntry.SmallResultEffect.gameObject:SetActive(true);
    XMZZEntry.SmallLineWinNum.text = XMZZEntry.ShowText(XMZZEntry.ResultData.WinScore);
    XMZZEntry.SmallWinNum.text = XMZZEntry.ShowText(XMZZEntry.SmallResultData.nGameTatolGold);
    local closebtn = XMZZEntry.SmallResultEffect:Find("BackGame"):GetComponent("Button");
    closebtn.onClick:RemoveAllListeners();
    closebtn.onClick:AddListener(function()
        XMZZEntry.isSmallGame = false;
        XMZZEntry.resultEffect.gameObject:SetActive(false);
        XMZZEntry.SmallResultEffect.gameObject:SetActive(false);
        XMZZEntry.SmallGamePanel.gameObject:SetActive(false);
        XMZZ_Result.CheckFree();
    end);
end
function XMZZ_SmallGame.ChangeIconRoll(index)
    local iconParent = self.rollList[index].content;
    for i = 0, iconParent.childCount - 1 do
        local iconIndex = math.random(1, 7);
        local changeIcon = XMZZEntry.icons:Find(XMZZ_DataConfig.SmallIconTable[iconIndex] .. "m"):GetComponent("Image").sprite;
        iconParent:GetChild(i):Find("Icon"):GetComponent("Image").sprite = changeIcon;
        local tempIcon = iconParent:GetChild(i):Find("Temp");
        if tempIcon ~= nil then
            tempIcon:GetComponent("Image").sprite = changeIcon;
            tempIcon:GetComponent("Image"):SetNativeSize();
        end
        iconParent:GetChild(i):Find("Icon"):GetComponent("Image"):SetNativeSize();
    end
end
function XMZZ_SmallGame.ChangeResultIcon(index)
    local iconParent = self.rollList[index].content;
    for i = 0, iconParent.childCount - 1 do
        local img = iconParent:GetChild(i):Find("Icon"):GetComponent("Image");
        local iconIndex = 1;
        if i == iconParent.childCount - 1 then
            iconIndex = math.random(1, 7);
        else
            iconIndex = XMZZEntry.SmallResultData.nIconType4[index];
        end
        local changeIcon = XMZZEntry.icons:Find(XMZZ_DataConfig.SmallIconTable[iconIndex]):GetComponent("Image").sprite;
        img.sprite = changeIcon;
        if i ~= iconParent.childCount - 1 then
            iconParent:GetChild(i).gameObject.name = XMZZ_DataConfig.IconTable[iconIndex];
        end
        img:SetNativeSize();
        local tempIcon = iconParent:GetChild(i):Find("Temp");
        if tempIcon ~= nil then
            iconIndex = math.random(1, 7);
            changeIcon = XMZZEntry.icons:Find(XMZZ_DataConfig.SmallIconTable[iconIndex]):GetComponent("Image").sprite;
            tempIcon:GetComponent("Image").sprite = changeIcon;
            tempIcon:GetComponent("Image"):SetNativeSize();
        end
    end
end