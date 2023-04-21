WSZS_Free = {};

local self = WSZS_Free;
local mianju1 = 1;
local mianju2 = 2;
local mianju3 = 3;
local mianju4 = 4;
local wspos = 5;

local mj1Count = 0;
local mj2Count = 0;
local mj3Count = 0;
local mj4Count = 0;

self.MJTable = {};
self.WSTable = {};
self.mjIndex = 0;
self.wsIndex = 0;
self.currentmj = 0;

local mj1score = nil;
local mj2score = nil;
local mj3score = nil;
local mj4score = nil;
function WSZS_Free.Init(isSceneData)
    --生成原始四个面具
    local mj1 = WSZSEntry.icons:Find("Item10").gameObject;
    local mj2 = WSZSEntry.icons:Find("Item9").gameObject;
    local mj3 = WSZSEntry.icons:Find("Item8").gameObject;
    local mj4 = WSZSEntry.icons:Find("Item7").gameObject;
    local ws = WSZSEntry.icons:Find("Item11").gameObject;

    mj1score = WSZSEntry.ScoreContainer:Find("MJ1"):GetComponent("TextMeshProUGUI");
    mj2score = WSZSEntry.ScoreContainer:Find("MJ2"):GetComponent("TextMeshProUGUI");
    mj3score = WSZSEntry.ScoreContainer:Find("MJ3"):GetComponent("TextMeshProUGUI");
    mj4score = WSZSEntry.ScoreContainer:Find("MJ4"):GetComponent("TextMeshProUGUI");
    if isSceneData then
        for i = 1, WSZSEntry.SceneData.mianjuCount[4] do
            local _mj1 = newObject(mj1);
            _mj1.transform:SetParent(WSZSEntry.IconContainer);
            _mj1.transform.localPosition = Vector3.New(WSZS_DataConfig.IconPos[1], 0, 0);
            _mj1.transform.localScale = Vector3.New(0.5, 0.5, 0.5);
        end

        for i = 1, WSZSEntry.SceneData.mianjuCount[3] do
            local _mj2 = newObject(mj2);
            _mj2.transform:SetParent(WSZSEntry.IconContainer);
            _mj2.transform.localPosition = Vector3.New(WSZS_DataConfig.IconPos[1], 0, 0);
            _mj2.transform.localScale = Vector3.New(0.5, 0.5, 0.5);
        end

        for i = 1, WSZSEntry.SceneData.mianjuCount[2] do
            local _mj3 = newObject(mj3);
            _mj3.transform:SetParent(WSZSEntry.IconContainer);
            _mj3.transform.localPosition = Vector3.New(WSZS_DataConfig.IconPos[1], 0, 0);
            _mj3.transform.localScale = Vector3.New(0.5, 0.5, 0.5);
        end

        for i = 1, WSZSEntry.SceneData.mianjuCount[1] do
            local _mj4 = newObject(mj4);
            _mj4.transform:SetParent(WSZSEntry.IconContainer);
            _mj4.transform.localPosition = Vector3.New(WSZS_DataConfig.IconPos[1], 0, 0);
            _mj4.transform.localScale = Vector3.New(0.5, 0.5, 0.5);
        end
        if WSZSEntry.SceneData.mianjuCount[1] ~= 0 then
            self.currentmj = 4;
        else
            if WSZSEntry.SceneData.mianjuCount[2] ~= 0 then
                self.currentmj = 3;
            else
                if WSZSEntry.SceneData.mianjuCount[3] ~= 0 then
                    self.currentmj = 2;
                else
                    if WSZSEntry.SceneData.mianjuCount[4] ~= 0 then
                        self.currentmj = 1;
                    end
                end
            end
        end
        mj1Count = WSZSEntry.SceneData.mianjuCount[4];
        mj2Count = WSZSEntry.SceneData.mianjuCount[3];
        mj3Count = WSZSEntry.SceneData.mianjuCount[2];
        mj4Count = WSZSEntry.SceneData.mianjuCount[1];
    else
        local _mj1 = newObject(mj1);
        _mj1.transform:SetParent(WSZSEntry.IconContainer);
        _mj1.transform.localPosition = Vector3.New(WSZS_DataConfig.IconPos[1], 0, 0);
        _mj1.transform.localScale = Vector3.New(0.5, 0.5, 0.5);
        local _mj2 = newObject(mj2);
        _mj2.transform:SetParent(WSZSEntry.IconContainer);
        _mj2.transform.localPosition = Vector3.New(WSZS_DataConfig.IconPos[1], 0, 0);
        _mj2.transform.localScale = Vector3.New(0.5, 0.5, 0.5);
        local _mj3 = newObject(mj3);
        _mj3.transform:SetParent(WSZSEntry.IconContainer);
        _mj3.transform.localPosition = Vector3.New(WSZS_DataConfig.IconPos[1], 0, 0);
        _mj3.transform.localScale = Vector3.New(0.5, 0.5, 0.5);
        local _mj4 = newObject(mj4);
        _mj4.transform:SetParent(WSZSEntry.IconContainer);
        _mj4.transform.localPosition = Vector3.New(WSZS_DataConfig.IconPos[1], 0, 0);
        _mj4.transform.localScale = Vector3.New(0.5, 0.5, 0.5);
        self.currentmj = 4;
        mj1Count = 1;
        mj2Count = 1;
        mj3Count = 1;
        mj4Count = 1;
    end
    local _ws = newObject(ws);
    _ws.transform:SetParent(WSZSEntry.IconContainer);
    _ws.transform.localPosition = Vector3.New(WSZS_DataConfig.IconPos[1], 0, 0);
    _ws.transform.localScale = Vector3.New(0.5, 0.5, 0.5);
    for i = 1, WSZSEntry.IconContainer.childCount - 1 do
        local dg = WSZS_Line.CreateEffect("DaoGuang1");
        dg.transform:SetParent(WSZSEntry.IconContainer:GetChild(i - 1));
        dg.transform.localPosition = Vector3.New(0, 0, 0);
        dg.transform.localScale = Vector3.New(1, 1, 1);
        dg.gameObject:SetActive(false);
    end
    local dg1 = WSZS_Line.CreateEffect("DaoGuang2");
    dg1.transform:SetParent(_ws.transform);
    dg1.transform.localPosition = Vector3.New(-50, 20, 0);
    dg1.transform.localScale = Vector3.New(1, 1, 1);
    dg1.gameObject:SetActive(false);

    for i = 1, WSZSEntry.IconContainer.childCount - 1 do
        WSZSEntry.IconContainer:GetChild(i - 1):DOLocalMove(Vector3.New(WSZS_DataConfig.IconPos[i], 0, 0), 0.3):SetEase(DG.Tweening.Ease.OutBack);
    end
    _ws.transform:DOLocalMove(Vector3.New(WSZS_DataConfig.IconPos[WSZSEntry.IconContainer.childCount], 0, 0), 0.3):SetEase(DG.Tweening.Ease.OutBack):OnComplete(function()
        WSZSEntry.FreeRoll();
    end);
    mianju1 = 1;
    mianju2 = mj1Count + 1;
    mianju3 = mj1Count + mj2Count + 1;
    mianju4 = mj1Count + mj2Count + mj3Count + 1;
    wspos = mj1Count + mj2Count + mj3Count + mj4Count + 1;

    if mj1Count > 0 then
        mj1score.text = WSZS_Rule.GetCustomK(WSZS_DataConfig.oddlist[4][mj1Count] * WSZSEntry.CurrentChip);
        local move1pos = Vector3.New((WSZS_DataConfig.IconPos[mianju1] + WSZS_DataConfig.IconPos[mianju1 + mj1Count - 1]) / 2, 55, 0);
        mj1score.transform:DOLocalMove(move1pos, 0.3):SetEase(DG.Tweening.Ease.OutBack);
    end
    if mj2Count > 0 then
        mj2score.text = WSZS_Rule.GetCustomK(WSZS_DataConfig.oddlist[3][mj2Count] * WSZSEntry.CurrentChip);
        local move2pos = Vector3.New((WSZS_DataConfig.IconPos[mianju2] + WSZS_DataConfig.IconPos[mianju2 + mj2Count - 1]) / 2, 55, 0);
        mj2score.transform:DOLocalMove(move2pos, 0.3):SetEase(DG.Tweening.Ease.OutBack);
    end
    if mj3Count > 0 then
        mj3score.text = WSZS_Rule.GetCustomK(WSZS_DataConfig.oddlist[2][mj3Count] * WSZSEntry.CurrentChip);
        local move3pos = Vector3.New((WSZS_DataConfig.IconPos[mianju3] + WSZS_DataConfig.IconPos[mianju3 + mj3Count - 1]) / 2, 55, 0);
        mj3score.transform:DOLocalMove(move3pos, 0.3):SetEase(DG.Tweening.Ease.OutBack);
    end
    if mj4Count > 0 then
        mj4score.text = WSZS_Rule.GetCustomK(WSZS_DataConfig.oddlist[1][mj4Count] * WSZSEntry.CurrentChip);
        local move4pos = Vector3.New((WSZS_DataConfig.IconPos[mianju4] + WSZS_DataConfig.IconPos[mianju4 + mj4Count - 1]) / 2, 55, 0);
        mj4score.transform:DOLocalMove(move4pos, 0.3):SetEase(DG.Tweening.Ease.OutBack);
    end


end
function WSZS_Free.Result()
    if #WSZS_Free.WSTable > 0 then
        self.mjIndex = 1;
        log("面具开始移动");
        if self.mjIndex < #self.MJTable then
            self.MoveMJ();
        else
            --TODO  开始武士斩杀
            self.wsIndex = 1;
            WSZS_Audio.PlaySound(WSZS_Audio.SoundList.Sha);
            WSZSEntry.StartKilEffect.gameObject:SetActive(true);
            --播放杀特效
            Util.RunWinScore(0, 1, 2, nil):OnComplete(function()
                WSZSEntry.StartKilEffect.gameObject:SetActive(false);
                self.WSZSAnimation();
            end);
        end
    else
        --没有面具的情况直接开始下一把
        log("没有面具");
        WSZSEntry.FreeRoll();
    end
end
function WSZS_Free.MoveMJ()
    Util.RunWinScore(0, 1, 0.5, nil):OnComplete(function()
        local go = GameObject.New("Item");
        local img = go:AddComponent(typeof(UnityEngine.UI.Image));
        local index = 0;
        if self.MJTable[self.mjIndex].parent.name == "Item7" then
            if mj4Count <= 0 then
                mianju4 = mj1Count + mj2Count + mj3Count + 1;
            end
            index = mianju4;
            wspos = wspos + 1;
            if self.currentmj < 4 then
                self.currentmj = 4;
            end
            mj4Count = mj4Count + 1;
        elseif self.MJTable[self.mjIndex].parent.name == "Item8" then
            if mj3Count <= 0 then
                mianju3 = mj1Count + mj2Count + 1;
            end
            index = mianju3;
            mianju4 = mianju4 + 1;
            wspos = wspos + 1;
            if self.currentmj < 3 then
                self.currentmj = 3;
            end
            mj3Count = mj3Count + 1;
        elseif self.MJTable[self.mjIndex].parent.name == "Item9" then
            if mj2Count <= 0 then
                mianju2 = mj1Count + 1;
            end
            index = mianju2;
            mianju4 = mianju4 + 1;
            mianju3 = mianju3 + 1;
            wspos = wspos + 1;
            if self.currentmj < 2 then
                self.currentmj = 2;
            end
            mj2Count = mj2Count + 1;
        elseif self.MJTable[self.mjIndex].parent.name == "Item10" then
            if mj1Count <= 0 then
                mianju1 = 1;
            end
            index = mianju1;
            mianju2 = mianju2 + 1;
            mianju4 = mianju4 + 1;
            mianju3 = mianju3 + 1;
            wspos = wspos + 1;
            mj1Count = mj1Count + 1;
        end
        if mj1Count > 0 then
            log("mianju1:"..mianju1);
            log("mj1Count:"..mj1Count);
            local move1pos = Vector3.New((WSZS_DataConfig.IconPos[mianju1] + WSZS_DataConfig.IconPos[mianju1 + mj1Count - 1]) / 2, 55, 0);
            mj1score.transform:DOLocalMove(move1pos, 0.3):SetEase(DG.Tweening.Ease.OutBack);
        end
        if mj2Count > 0 then
            log("mianju2:"..mianju2);
            log("mj2Count:"..mj2Count);
            local move2pos = Vector3.New((WSZS_DataConfig.IconPos[mianju2] + WSZS_DataConfig.IconPos[mianju2 + mj2Count - 1]) / 2, 55, 0);
            mj2score.transform:DOLocalMove(move2pos, 0.3):SetEase(DG.Tweening.Ease.OutBack);
        end
        if mj3Count > 0 then
            log("mianju3:"..mianju3);
            log("mj3Count:"..mj3Count);
            local move3pos = Vector3.New((WSZS_DataConfig.IconPos[mianju3] + WSZS_DataConfig.IconPos[mianju3 + mj3Count - 1]) / 2, 55, 0);
            mj3score.transform:DOLocalMove(move3pos, 0.3):SetEase(DG.Tweening.Ease.OutBack);
        end
        if mj4Count > 0 then
            log("mianju4:"..mianju4);
            log("mj4Count:"..mj4Count);
            local move4pos = Vector3.New((WSZS_DataConfig.IconPos[mianju4] + WSZS_DataConfig.IconPos[mianju4 + mj4Count - 1]) / 2, 55, 0);
            mj4score.transform:DOLocalMove(move4pos, 0.3):SetEase(DG.Tweening.Ease.OutBack);
        end
        for i = index, WSZSEntry.IconContainer.childCount do
            WSZSEntry.IconContainer:GetChild(i - 1):DOLocalMove(Vector3.New(WSZS_DataConfig.IconPos[i + 1], 0, 0), 0.3):SetEase(DG.Tweening.Ease.OutBack);
        end
        img.sprite = self.MJTable[self.mjIndex]:GetComponent("Image").sprite;
        img:SetNativeSize();
        self.MJTable[self.mjIndex]:Find("Effect"):GetComponent("Animator").enabled = true;
        img.color = Color.New(1, 1, 1, 0.5);
        go.transform:SetParent(self.MJTable[self.mjIndex])
        go.transform.localPosition = Vector3.New(0, 0, 0);
        go.transform.localScale = Vector3.New(1, 1, 1);
        go.transform:SetParent(WSZSEntry.IconContainer);
        go.transform:SetSiblingIndex(index - 1);
        go.transform:DOLocalMove(Vector3.New(WSZS_DataConfig.IconPos[index], 0, 0), 1):OnComplete(function()
            go.transform:DOScale(Vector3.New(0.5, 0.5, 0.5), 0.3):OnComplete(function()
                img.color = Color.New(1, 1, 1, 1);
                --TODO 播放烟雾
                local yw = WSZS_Line.CreateEffect("YanWu");
                yw.transform:SetParent(go.transform);
                yw.transform.localPosition = Vector3.New(0, 0, 0);
                yw.transform.localScale = Vector3.New(1, 1, 1);
                if mj1Count > 0 then
                    mj1score.text = WSZS_Rule.GetCustomK(WSZS_DataConfig.oddlist[4][mj1Count] * WSZSEntry.CurrentChip);
                end
                if mj2Count > 0 then
                    mj2score.text = WSZS_Rule.GetCustomK(WSZS_DataConfig.oddlist[3][mj2Count] * WSZSEntry.CurrentChip);
                end
                if mj3Count > 0 then
                    mj3score.text = WSZS_Rule.GetCustomK(WSZS_DataConfig.oddlist[2][mj3Count] * WSZSEntry.CurrentChip);
                end
                if mj4Count > 0 then
                    mj4score.text = WSZS_Rule.GetCustomK(WSZS_DataConfig.oddlist[1][mj4Count] * WSZSEntry.CurrentChip);
                end
                Util.RunWinScore(0, 1, 0.5, nil):OnComplete(function()
                    WSZS_Line.CollectEffect(yw.gameObject);
                    local dg = WSZS_Line.CreateEffect("DaoGuang1");
                    dg.transform:SetParent(go.transform);
                    dg.transform.localPosition = Vector3.New(0, 0, 0);
                    dg.transform.localScale = Vector3.New(1, 1, 1);
                    dg.gameObject:SetActive(false);
                end);

                if WSZSEntry.IconContainer.childCount >= 12 then
                    --TODO 失败了,播放剑士掉落动画                  
                    local ws = WSZSEntry.IconContainer:GetChild(WSZSEntry.IconContainer.childCount - 1);
                    ws:DOLocalMove(Vector3.New(ws.localPosition.x, WSZS_DataConfig.brokenPos, 0), 1.5):OnComplete(function()
                        local broken = WSZS_Line.CreateEffect("PoSui");
                        broken.transform:SetParent(ws);
                        broken.transform.localPosition = Vector3.New(0, 0, 0);
                        broken.transform.localScale = Vector3.New(0.5, 0.5, 0.5);
                        ws:GetComponent("Image").enabled = false;
                        broken.gameObject:SetActive(true);
                        WSZS_Audio.PlaySound(WSZS_Audio.SoundList.Broken);
                        Util.RunWinScore(0, 1, 2, nil):OnComplete(function()
                            WSZS_Result.ShowFreeResultEffect(false);
                        end);
                    end);
                else
                    if self.mjIndex < #self.MJTable then
                        self.mjIndex = self.mjIndex + 1;
                        self.MoveMJ();
                    else
                        --TODO  开始武士斩杀
                        self.wsIndex = 1;
                        WSZS_Audio.PlaySound(WSZS_Audio.SoundList.Sha);
                        WSZSEntry.StartKilEffect.gameObject:SetActive(true);
                        --播放杀特效
                        Util.RunWinScore(0, 1, 2, nil):OnComplete(function()
                            WSZSEntry.StartKilEffect.gameObject:SetActive(false);
                            self.WSZSAnimation();
                        end);
                    end
                end
            end);
        end);
    end);
end
function WSZS_Free.WSZSAnimation()
    self.WSTable[self.wsIndex]:Find("Effect"):GetComponent("Animator").enabled = true;
    WSZSEntry.IconContainer:GetChild(wspos - 1):GetChild(0).gameObject:SetActive(true);
    WSZS_Audio.PlaySound(WSZS_Audio.SoundList.Attack);
    Util.RunWinScore(0, 1, 1, nil):OnComplete(function()
        WSZSEntry.IconContainer:GetChild(wspos - 1):GetChild(0).gameObject:SetActive(false);
        local pos = 0;
        local goal = 0;
        local currentgoal = nil;
        if self.currentmj == 1 then
            pos = mianju1;
            goal = WSZS_DataConfig.oddlist[4][mj1Count] * WSZSEntry.CurrentChip;
            currentgoal = mj1score;
        elseif self.currentmj == 2 then
            pos = mianju2;
            goal = WSZS_DataConfig.oddlist[3][mj2Count] * WSZSEntry.CurrentChip;
            currentgoal = mj2score;
        elseif self.currentmj == 3 then
            pos = mianju3;
            goal = WSZS_DataConfig.oddlist[2][mj3Count] * WSZSEntry.CurrentChip;
            currentgoal = mj3score;
        elseif self.currentmj == 4 then
            pos = mianju4;
            goal = WSZS_DataConfig.oddlist[1][mj4Count] * WSZSEntry.CurrentChip;
            currentgoal = mj4score;
        end
        WSZS_Audio.PlaySound(WSZS_Audio.SoundList.Dao);
        for i = pos, wspos - 1 do
            WSZSEntry.IconContainer:GetChild(i - 1):GetComponent("Image").enabled = false;
            WSZSEntry.IconContainer:GetChild(i - 1):GetChild(0).gameObject:SetActive(true);
            Util.RunWinScore(0, 1, 0.6, nil):OnComplete(function()
                WSZS_Line.CollectEffect(WSZSEntry.IconContainer:GetChild(i - 1):GetChild(0).gameObject);
                destroy(WSZSEntry.IconContainer:GetChild(i - 1).gameObject);
            end);
        end
        self.mjIndex = self.mjIndex - 1;
        WSZS_Result.totalFreeGold = WSZS_Result.totalFreeGold + goal;
        WSZSEntry.WinNum.text = WSZSEntry.ShowText(WSZS_Result.totalFreeGold);
        Util.RunWinScore(0, 1, 0.6, nil):OnComplete(function()
            if self.currentmj == 1 then
                wspos = mianju1;
                self.currentmj = 0;
                mianju1 = 0;
                mj1Count = 0;
            elseif self.currentmj == 2 then
                wspos = mianju2;
                if mj1Count <= 0 then
                    self.currentmj = 0;
                else
                    self.currentmj = 1;
                end
                mianju2 = mianju2 - mj2Count;
                mianju3 = mianju3 - mj2Count;
                mianju4 = mianju4 - mj2Count;
                mj2Count = 0;
            elseif self.currentmj == 3 then
                wspos = mianju3;
                if mj2Count <= 0 and mj1Count <= 0 then
                    self.currentmj = 0;
                elseif mj2Count <= 0 and mj1Count > 0 then
                    self.currentmj = 1;
                elseif mj2Count > 0 then
                    self.currentmj = 2;
                end
                mianju3 = mianju3 - mj3Count;
                mianju4 = mianju4 - mj3Count;
                mj3Count = 0;
            elseif self.currentmj == 4 then
                wspos = mianju4;
                if mj3Count <= 0 and mj2Count <= 0 and mj1Count <= 0 then
                    self.currentmj = 0;
                elseif mj3Count <= 0 and mj2Count <= 0 and mj1Count > 0 then
                    self.currentmj = 1;
                elseif mj3Count <= 0 and mj2Count > 0 then
                    self.currentmj = 2;
                elseif mj3Count > 0 then
                    self.currentmj = 3;
                end
                mianju4 = mianju4 - mj4Count;
                mj4Count = 0;
            end
            currentgoal.text = "";
            WSZSEntry.IconContainer:GetChild(WSZSEntry.IconContainer.childCount - 1):DOLocalMove(Vector3.New(WSZS_DataConfig.IconPos[wspos], 0, 0), 0.3):OnComplete(function()
                if self.currentmj <= 0 then
                    --TODO 胜利
                    WSZS_Result.ShowFreeResultEffect(true);
                else
                    self.wsIndex = self.wsIndex + 1;
                    if self.wsIndex > #self.WSTable then
                        self.wsIndex = 0;
                        WSZSEntry.FreeRoll();
                    else
                        self.WSZSAnimation();
                    end
                end
            end);
        end);
    end);
end