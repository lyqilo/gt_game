JJPM_Roll = {}

local self = JJPM_Roll;

self.cameraRunDistance = 10000;
self.horseList = {};
self.startRun = false;
self.isRun = false;
self.tweenlist = {};
self.horseTable = {};
self.frist = nil;
self.second = nil;
self.horseSpeed = {};
self.speed = 7;
function JJPM_Roll.Init()
    self.runCamera = JJPMEntry.runPanel:Find("Camera");
    self.runGroup = JJPMEntry.runPanel:Find("RunGroup");
    self.startPoint = self.runGroup:Find("StartPoint");
    self.doorGroup = self.startPoint:Find("Door");
    self.endPoint = self.runGroup:Find("EndPoint");
    self.horseGroup = self.runGroup:Find("HourseGroup");
    self.addspeedGroup = self.runGroup:Find("AddSpeed");
    self.addspeedGroup.gameObject:SetActive(false);
    self.horseTable = {};
    for i = 1, self.horseGroup.childCount do
        self.horseGroup:GetChild(i - 1):GetComponent("Animator"):SetTrigger("Idle");
        table.insert(self.horseTable, i);
    end
    self.timedown = JJPMEntry.runPanel:Find("TimeDown"):GetComponent("TextMeshProUGUI");
    self.cameraMask = JJPMEntry.resultEffect:Find("CameraMask"):GetComponent("Image");
    self.gameResultEffect = JJPMEntry.resultEffect:Find("GameResult");
    self.Comb = self.gameResultEffect:Find("Comb"):GetComponent("TextMeshProUGUI");
    self.peilv = self.gameResultEffect:Find("BeiLv"):GetComponent("TextMeshProUGUI");
    self.cameraMask.color = Color.New(1, 1, 1, 0);
    self.horseSpeed = { 7, 7, 7, 7, 7, 7 };
end
function JJPM_Roll.Update()
    if self.startRun then
        table.sort(self.horseTable, function(a, b)
            if self.horseGroup:GetChild(a - 1).localPosition.x > self.horseGroup:GetChild(b - 1).localPosition.x then
                return true;
            else
                return false;
            end
        end);
        if self.horseTable[1] ~= self.frist then
            self.frist = self.horseTable[1];
            JJPMEntry.leaderGroup:GetChild(0):GetChild(0):GetComponent("Image").sprite = JJPMEntry.icons:Find("Horse" .. self.frist):GetComponent("Image").sprite;
        end
        if self.horseTable[2] ~= self.second then
            self.second = self.horseTable[2];
            JJPMEntry.leaderGroup:GetChild(1):GetChild(0):GetComponent("Image").sprite = JJPMEntry.icons:Find("Horse" .. self.second):GetComponent("Image").sprite;
        end
        for i = 1, #self.horseList do
            if self.isRun then
                self.horseGroup:GetChild(self.horseList[i] - 1):Translate(Vector3.right * Time.deltaTime * self.horseSpeed[i]);
                if self.runCamera.transform.localPosition.x < 9000 then
                    local ran = math.random(1, 10);
                    if ran>5 then
                        self.horseSpeed[i] = Mathf.Lerp(self.horseSpeed[i], math.random(8.55, 12.01), Time.deltaTime);
                    else
                        self.horseSpeed[i] = Mathf.Lerp(self.horseSpeed[i], math.random(4.01, 8.55), Time.deltaTime);
                    end
                else
                    self.isRun = false;
                    self.OverRun();
                end
            end
        end
    end
end

function JJPM_Roll.ShowRun()
    self.frist = 1;
    self.second = 2;
    self.Comb.text = "";
    self.peilv.text = "";
    self.horseSpeed = { 7, 7, 7, 7, 7, 7 };
    self.runCamera.transform.localPosition = Vector3.New(0, 0, -10000);
    JJPMEntry.lastRecordPanel.gameObject:SetActive(false);
    Util.RunWinScore(0, 1, 1, nil):OnComplete(function()
        JJPMEntry.betGroup:DOLocalMove(Vector3.New(0, 1500, 0), 1):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            JJPM_Audio.PlayBGM(JJPM_Audio.SoundList.BGMRun);
            JJPMEntry.stopChipEffect.gameObject:SetActive(false);
            self.StartTimeDown();
        end);
    end);
end
function JJPM_Roll.StartTimeDown()
    self.timedown.transform.localScale = Vector3.New(1, 1, 1);
    self.timedown.text = JJPMEntry.ShowText("r");
    self.timedown.transform:DOScale(Vector3.New(4, 4, 4), 0.6):SetEase(DG.Tweening.Ease.OutBack):OnComplete(function()
        self.timedown.text = "";
        self.timedown.transform.localScale = Vector3.New(1, 1, 1);
    end);
    JJPM_Audio.PlaySound(JJPM_Audio.SoundList.Ready);
    local count = 0;
    Util.RunWinScore(0, 3, 3, function(value)
        if value - count > 1 then
            if 3 - count > 0 then
                self.timedown.transform.localScale = Vector3.New(1, 1, 1);
                self.timedown.text = JJPMEntry.ShowText(3 - count);
                self.timedown.transform:DOScale(Vector3.New(4, 4, 4), 0.6):SetEase(DG.Tweening.Ease.OutBack):OnComplete(function()
                    self.timedown.text = "";
                    self.timedown.transform.localScale = Vector3.New(1, 1, 1);
                end);
            end
            count = count + 1;
            JJPM_Audio.PlaySound(JJPM_Audio.SoundList.Di);
        end
    end):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
        self.timedown.transform.localScale = Vector3.New(1, 1, 1);
        self.timedown.text = JJPMEntry.ShowText(1);
        self.timedown.transform:DOScale(Vector3.New(4, 4, 4), 0.6):SetEase(DG.Tweening.Ease.OutBack):OnComplete(function()
            self.timedown.text = "";
            self.timedown.transform.localScale = Vector3.New(1, 1, 1);
        end);
        JJPM_Audio.PlaySound(JJPM_Audio.SoundList.Di);
        Util.RunWinScore(0, 1, 1, nil):OnComplete(function()
            self.timedown.text = JJPMEntry.ShowText("g");
            self.timedown.transform:DOScale(Vector3.New(4, 4, 4), 0.6):SetEase(DG.Tweening.Ease.OutBack):OnComplete(function()
                self.timedown.text = "";
                self.timedown.transform.localScale = Vector3.New(1, 1, 1);
            end);
            JJPM_Audio.PlaySound(JJPM_Audio.SoundList.Go);
            self.StartRun();
        end);
    end);
end
function JJPM_Roll.StartRun()
    self.GetRank();
    self.tweenlist = {};
    JJPM_Audio.PlaySound(JJPM_Audio.SoundList.GameStart);
    JJPM_Audio.PlaySound(JJPM_Audio.SoundList.Jia);
    for i = 1, self.doorGroup.childCount do
        self.doorGroup:GetChild(i - 1):GetComponent("Animator"):SetTrigger("Start");
    end
    for i = 1, #self.horseList do
        self.horseGroup:GetChild(self.horseList[i] - 1):GetComponent("Animator"):SetTrigger("Run");
    end
    self.runCamera.transform:DOLocalMove(Vector3.New(10000, 0, -10000), 16):SetDelay(0.5):SetEase(DG.Tweening.Ease.Linear);
    self.addspeedGroup.gameObject:SetActive(true);
    self.startRun = true;
    self.isRun = true;
end
function JJPM_Roll.GetRank()
    self.horseList = {};
    local win = JJPM_DataConfig.WinList[JJPMEntry.ResultData.cbIndex + 1];
    if JJPMEntry.ResultData.IsFrist == 0 then
        table.insert(self.horseList, win[1]);
        table.insert(self.horseList, win[2]);
    else
        table.insert(self.horseList, win[2]);
        table.insert(self.horseList, win[1]);
    end
    for i = 1, 6 do
        if not table.contains(self.horseList, i) then
            table.insert(self.horseList, i);
        end
    end
end
function JJPM_Roll.OverRun()
    for j = 1, #self.tweenlist do
        self.tweenlist[j]:Kill();
    end
    for i = 1, #self.horseList do
        local trans = self.horseGroup:GetChild(self.horseList[i] - 1);
        local index = i;
        if i > 4 then
            index = 4;
        end
        local tweener = trans:DOLocalMove(Vector3.New(10920, trans.localPosition.y, trans.localPosition.z), 2 + (index - 1) * math.random(0.06, 0.1)):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            if i == 1 then
                for j = 1, self.horseGroup.childCount do
                    self.horseGroup:GetChild(j - 1):GetComponent("Animator").enabled = false;
                end
                for j = 1, #self.tweenlist do
                    self.tweenlist[j]:Kill();
                end
                --展示结果
                self.startRun = false;
                JJPMEntry.resultEffect.gameObject:SetActive(true);
                self.gameResultEffect.gameObject:SetActive(true);
                local winComb = JJPM_DataConfig.WinList[JJPMEntry.ResultData.cbIndex + 1];
                self.Comb.text = JJPMEntry.ShowText(winComb[1] .. "-" .. winComb[2]);
                self.peilv.text = JJPMEntry.ShowText("X" .. JJPM_DataConfig.peiLvList[JJPMEntry.ResultData.cbIndex + 1]);
                --拍照
                JJPM_Audio.PlaySound(JJPM_Audio.SoundList.CameraShutter);
                JJPM_Audio.PlaySound(JJPM_Audio.SoundList.Over);
                JJPM_Audio.ClearAuido(JJPM_Audio.SoundList.Jia);
                self.cameraMask.gameObject:SetActive(true);
                self.cameraMask.color = Color.New(1, 1, 1, 0);
                self.cameraMask:DOFade(1, 0.1):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                    self.cameraMask:DOFade(0, 0.1):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                        self.cameraMask.gameObject:SetActive(false);
                    end);
                end);
                Util.RunWinScore(0, 1, 1.5, nil):OnComplete(function()
                    for j = 1, self.horseGroup.childCount do
                        self.horseGroup:GetChild(j - 1):GetComponent("Animator").enabled = true;
                        self.horseGroup:GetChild(j - 1):DOLocalMove(Vector3.New(11800, self.horseGroup:GetChild(j - 1).localPosition.y, 0), 2):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                            self.horseGroup:GetChild(j - 1).localPosition = Vector3.New(0, self.horseGroup:GetChild(j - 1).localPosition.y, 0);
                            self.horseGroup:GetChild(j - 1):GetComponent("Animator"):SetTrigger("Idle");
                        end);
                    end
                    for j = 1, self.doorGroup.childCount do
                        self.doorGroup:GetChild(j - 1):GetComponent("Animator"):SetTrigger("Stop");
                    end
                    Util.RunWinScore(0, 1, 1.5, nil):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                        self.gameResultEffect.gameObject:SetActive(false);
                        if JJPMEntry.totalChip > 0 then
                            JJPMEntry.ShowCurrentRecordPanel();
                        end
                    end);
                end);
            end
        end);
        table.insert(self.tweenlist, tweener);
    end
end