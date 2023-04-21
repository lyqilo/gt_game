FXGZ_SmallGame = {};

local self = FXGZ_SmallGame;
self.guCount = 0;
self.luoCount = 0;
self.huaCount = 0;
self.yupeiCount = 0;
self.ismove = false;

function FXGZ_SmallGame.Init(obj)
    --初始化转动
    self.mainPanel = obj.transform:Find("MainPanel");
    self.gatePanel = obj.transform:Find("GatePanel");
    self.leftgate = self.gatePanel:Find("GateLeft");
    self.rightgate = self.gatePanel:Find("GateRight");
    self.selectGroup = self.mainPanel:Find("Mammons");
    self.effectObj = self.mainPanel:Find("FXGZ_tuowei");
    self.guGroup = self.mainPanel:Find("WinIcons_Gu");
    self.luoGroup = self.mainPanel:Find("WinIcons_Luo");
    self.huaGroup = self.mainPanel:Find("WinIcons_Hua");
    self.yupeiGroup = self.mainPanel:Find("WinIcons_YuPei");
    self.ResetState();
    for i = 1, self.selectGroup.childCount do
        local selectChild = self.selectGroup:GetChild(i - 1):GetComponent("Button");
        local index = i;
        selectChild.onClick:RemoveAllListeners();
        selectChild.onClick:AddListener(function()
            FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.SmallGameClick);
            if self.ismove then
                return ;
            end
            self.ismove = true;
            FXGZEntry.currentSelectBonus = index - 1;
            FXGZ_Network.StartSmallGame();
        end);
    end
end
function FXGZ_SmallGame.ResetState()
    self.guCount = 0;
    self.luoCount = 0;
    self.huaCount = 0;
    self.yupeiCount = 0;
    for i = 1, self.selectGroup.childCount do
        self.selectGroup:GetChild(i - 1):GetComponent("Image").enabled = true;
    end
    for i = 1, self.guGroup.childCount do
        self.guGroup:GetChild(i - 1).gameObject:SetActive(false);
    end
    for i = 1, self.luoGroup.childCount do
        self.luoGroup:GetChild(i - 1).gameObject:SetActive(false);
    end
    for i = 1, self.huaGroup.childCount do
        self.huaGroup:GetChild(i - 1).gameObject:SetActive(false);
    end
    for i = 1, self.yupeiGroup.childCount do
        self.yupeiGroup:GetChild(i - 1).gameObject:SetActive(false);
    end
    self.effectObj.gameObject:SetActive(false);
end
function FXGZ_SmallGame.ShowSmallGame(isSceneData)
    if isSceneData then
        self.guCount = FXGZEntry.SceneData.cbFreeGameIconCount[4];
        self.luoCount = FXGZEntry.SceneData.cbFreeGameIconCount[3];
        self.huaCount = FXGZEntry.SceneData.cbFreeGameIconCount[2];
        self.yupeiCount = FXGZEntry.SceneData.cbFreeGameIconCount[1];

        for i = 1, #FXGZEntry.SceneData.cbFreeGameIndex do
            if FXGZEntry.SceneData.cbFreeGameIndex[i] ~= 0 then
                self.selectGroup:GetChild(i - 1):GetComponent("Image").enabled = false;
            else
                self.selectGroup:GetChild(i - 1):GetComponent("Image").enabled = true;
            end
        end
        for i = 1, self.guGroup.childCount do
            if i > self.guCount then
                self.guGroup:GetChild(i - 1).gameObject:SetActive(false);
            else
                self.guGroup:GetChild(i - 1).gameObject:SetActive(true);
            end
        end
        for i = 1, self.luoGroup.childCount do
            if i > self.luoCount then
                self.luoGroup:GetChild(i - 1).gameObject:SetActive(false);
            else
                self.luoGroup:GetChild(i - 1).gameObject:SetActive(true);
            end
        end
        for i = 1, self.huaGroup.childCount do
            if i > self.huaCount then
                self.huaGroup:GetChild(i - 1).gameObject:SetActive(false);
            else
                self.huaGroup:GetChild(i - 1).gameObject:SetActive(true);
            end
        end
        for i = 1, self.yupeiGroup.childCount do
            if i > self.yupeiCount then
                self.yupeiGroup:GetChild(i - 1).gameObject:SetActive(false);
            else
                self.yupeiGroup:GetChild(i - 1).gameObject:SetActive(true);
            end
        end
        self.effectObj.gameObject:SetActive(false);
    else
        self.ResetState();
    end
    FXGZEntry.SmallGamePanel.gameObject:SetActive(true);
    self.leftgate.localPosition = Vector3.New(0, 0, 0);
    self.rightgate.localPosition = Vector3.New(0, 0, 0);
    Util.RunWinScore(0, 1, 0.5, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        self.leftgate:DOLocalMove(Vector3.New(-640, 0, 0), 1):SetEase(DG.Tweening.Ease.Linear);
        self.rightgate:DOLocalMove(Vector3.New(640, 0, 0), 1):SetEase(DG.Tweening.Ease.Linear);
    end);
end
function FXGZ_SmallGame.StartSmallGame()
    local startPos = self.selectGroup:GetChild(FXGZEntry.currentSelectBonus).localPosition;
    self.effectObj:SetParent(self.selectGroup);
    self.effectObj.localPosition = startPos;
    local endPos = nil;
    local animname = nil;
    local needShowObj = nil;
    if FXGZEntry.SmallResultData.cbResCode == 4 then
        self.guCount = self.guCount + 1;
        needShowObj = self.guGroup:GetChild(self.guCount - 1);
        endPos = needShowObj.localPosition;
        self.effectObj:SetParent(self.guGroup);
        animname = "Item9";
    elseif FXGZEntry.SmallResultData.cbResCode == 3 then
        self.luoCount = self.luoCount + 1;
        needShowObj = self.luoGroup:GetChild(self.luoCount - 1);
        endPos = needShowObj.localPosition;
        self.effectObj:SetParent(self.luoGroup);
        animname = "Item7";
    elseif FXGZEntry.SmallResultData.cbResCode == 2 then
        self.huaCount = self.huaCount + 1;
        needShowObj = self.huaGroup:GetChild(self.huaCount - 1);
        endPos = needShowObj.localPosition;
        self.effectObj:SetParent(self.huaGroup);
        animname = "Item5";
    elseif FXGZEntry.SmallResultData.cbResCode == 1 then
        self.yupeiCount = self.yupeiCount + 1;
        needShowObj = self.yupeiGroup:GetChild(self.yupeiCount - 1);
        endPos = needShowObj.localPosition;
        self.effectObj:SetParent(self.yupeiGroup);
        animname = "Item6";
    end
    local anim = FXGZ_Line.CreateEffect(animname);
    anim.transform:SetParent(self.selectGroup:GetChild(FXGZEntry.currentSelectBonus));
    anim.transform.localPosition = Vector3.New(0, 0, 0);
    anim.transform.localScale = Vector3.New(0.6, 0.6, 0.6);
    self.selectGroup:GetChild(FXGZEntry.currentSelectBonus):GetComponent("Image").enabled = false;
    self.effectObj.gameObject:SetActive(true);
    self.effectObj:DOLocalMove(endPos, 1):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        FXGZ_Line.CollectEffect(anim.gameObject);
        needShowObj.gameObject:SetActive(true);
        self.effectObj.gameObject:SetActive(false);
        self.effectObj:SetParent(self.mainPanel);
        self.ismove = false;
        if FXGZEntry.SmallResultData.nFreeCount > 0 then
            FXGZEntry.freeCount = FXGZEntry.SmallResultData.nFreeCount;
            self.ShowResult();
        end
    end);
end
function FXGZ_SmallGame.ShowResult()
    FXGZ_Audio.PlaySound(FXGZ_Audio.SoundList.SmallGameResult);
    self.leftgate:DOLocalMove(Vector3.New(0, 0, 0), 1):SetEase(DG.Tweening.Ease.Linear);
    self.rightgate:DOLocalMove(Vector3.New(0, 0, 0), 1):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        --TODO 显示免费入场动画
        Util.RunWinScore(0, 1, 0.5, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            FXGZEntry.SmallGamePanel.gameObject:SetActive(false);
            FXGZEntry.isSmallGame = false;
            FXGZEntry.ResultData.FreeType = 1;
            FXGZ_Result.CheckFree();
        end);
    end);
end