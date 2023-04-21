WPBY_GoldEffect = {};
local self = WPBY_GoldEffect;

self.transform = nil;
self.gameObject = nil;

self.superPowr = nil;
self.list = {};
function WPBY_GoldEffect.Init(obj)
    self.gameObject = obj;
    self.transform = self.gameObject.transform;
    self.superPowr = self.transform:Find("SuperPowr");
    self.HaiLangEffect = self.transform:Find("HaiLang").gameObject;
    self.SenceBackJpg = WPBYEntry.backgroundPanel:Find("sence_bg_1").gameObject;
    self.SenceBackJpg2 = WPBYEntry.backgroundPanel:Find("sence_bg_2").gameObject;
    self.list = {};
    self.YC = false;
end

function WPBY_GoldEffect.FlyGold(fish, deadFishData, chairId)
    local player = WPBY_PlayerController.GetPlayer(chairId);
    if player == nil then
        return ;
    end
    local r = WPBYEntry.GetMagnificationToFishID(fish.fishData.id);
    if r >= 25 then
        r = 25;
    end
    local isFrist = true;
    local goldObj = self.FindUsedGold();
    goldObj.transform:SetParent(fish.transform);
    goldObj.transform.localPosition = Vector3.New(0, 0, 0);
    goldObj.transform.localScale = Vector3.New(0, 0, 0);
    goldObj.transform:SetParent(player.userGold.transform);
    goldObj.gameObject:SetActive(true);
    for i = 1, r do
        goldObj.transform:GetChild(i - 1).gameObject:SetActive(true);
    end
    WPBYEntry.DelayCall(0.5, function()
        if goldObj == nil then
            return ;
        end
        local newPoint = Vector3.New(goldObj.transform.localPosition.x + Mathf.Random(-r * 20, r * 20), goldObj.transform.localPosition.y + Mathf.Random(-r * 20, r * 20), 0);
        goldObj.transform:DOScale(Vector3.New(1, 1, 1), 0.5):SetEase(DG.Tweening.Ease.OutBack);
        goldObj.transform:DOLocalMove(newPoint, 0.5):SetEase(DG.Tweening.Ease.OutBack):OnComplete(function()
            WPBYEntry.DelayCall(0.7, function()
                if goldObj == nil then
                    return ;
                end
                goldObj.transform:DOLocalMove(Vector3.New(0, 0, 0), Mathf.Random(0.3, 0.7)):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                    if goldObj == nil then
                        return ;
                    end
                    goldObj.gameObject:SetActive(false);
                    goldObj.transform:SetParent(WPBYEntry.goldEffectPool);
                    if isFrist then
                        self.ShowAddGoldEffect(player.userGold.transform, chairId);
                        isFrist = false;
                    end
                end);
            end);
        end);
    end);
end
--鱼分数文字
function WPBY_GoldEffect.OnShowScure(fish, scur, site)
    local magnification = WPBYEntry.GetMagnificationToFishID(fish.fishData.id);
    local o = nil;
    if magnification <= 10 then
        o = newobject(self.transform:Find("Socur_0").gameObject);
    elseif magnification <= 15 then
        o = newobject(self.transform:Find("Socur_1").gameObject);
    else
        o = newobject(self.transform:Find("Socur_2").gameObject);
    end
    o.gameObject:SetActive(true);
    o.transform:SetParent(WPBYEntry.effectScene);
    o.transform:GetComponent("TextMeshProUGUI").text = WPBYEntry.ShowText("+" .. scur);
    o.transform.position = fish.transform.position;
    o.transform.localScale = Vector3.New(1, 1, 1);
    WPBYEntry.DelayCall(1, function()
        if o ~= nil then
            destroy(o.gameObject);
        end
    end);
    if fish.fishData.Kind >= 6 then
        --TODO 音效

    end
end
--超级大奖
function WPBY_GoldEffect.ShowSuperJack(scur, fish, chairId)
    local obj = nil;
    log("打死：" .. fish.fishData.Kind);
    if fish.fishData.Kind == 18 then
        --金币海豚
        obj = newobject(self.transform:Find("SuperJack1").gameObject);
    elseif fish.fishData.Kind == 20 then
        --金龙
        obj = newobject(self.transform:Find("SuperJack2").gameObject);
    elseif fish.fishData.Kind == 42 then
        --大三元1
        obj = newobject(self.transform:Find("SuperJack3").gameObject);
    elseif fish.fishData.Kind == 43 then
        --大三元2
        obj = newobject(self.transform:Find("SuperJack3").gameObject);
    elseif fish.fishData.Kind == 44 then
        --大三元3
        obj = newobject(self.transform:Find("SuperJack3").gameObject);
    elseif fish.fishData.Kind == 45 then
        --大三元4
        obj = newobject(self.transform:Find("SuperJack3").gameObject);
    elseif fish.fishData.Kind == 46 then
        --大四喜1
        obj = newobject(self.transform:Find("SuperJack6").gameObject);
    elseif fish.fishData.Kind == 47 then
        --大四喜2
        obj = newobject(self.transform:Find("SuperJack6").gameObject);
    elseif fish.fishData.Kind == 48 then
        --大四喜3
        obj = newobject(self.transform:Find("SuperJack6").gameObject);
    elseif fish.fishData.Kind == 49 then
        --大四喜4
        obj = newobject(self.transform:Find("SuperJack6").gameObject);
    elseif fish.fishData.Kind == 21 then
        --企鹅
        obj = newobject(self.transform:Find("SuperJack4").gameObject);
    elseif fish.fishData.Kind == 19 then
        --银龙
        obj = newobject(self.transform:Find("SuperJack5").gameObject);
    elseif fish.fishData.Kind == 22 then
        --李逵
        obj = newobject(self.transform:Find("SuperJack7").gameObject);
    end
    if obj == nil then
        return ;
    end
    obj.gameObject:SetActive(true);
    obj.transform:SetParent(WPBYEntry.effectScene);
    obj.transform.position = fish.transform.position;
    obj.transform.localScale = Vector3.New(1, 1, 1);
    obj.transform:Find("gold/Text"):GetComponent("TextMeshProUGUI").text = WPBYEntry.ShowText("+" .. scur);
    WPBYEntry.DelayCall(1, function()
        if obj == nil then
            return ;
        end
        if (chairId <= 1) then
            obj.transform:DOLocalMove(Vector3.New(0, 250, 0), 1):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                WPBYEntry.DelayCall(0.5, function()
                    destroy(obj.gameObject);
                end);
            end);
        else
            obj.transform:DOLocalMove(Vector3.New(0, 250, 0), 1):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                WPBYEntry.DelayCall(0.5, function()
                    destroy(obj.gameObject);
                end);
            end);
        end
    end);
end
function WPBY_GoldEffect.ShowAddGoldEffect(t, site)
    if self.addGoldEffect_Up == nil then
        self.addGoldEffect_Up = self.transform:Find("AddGoldEffect_up").gameObject;
    end
    if self.AddGoldEffect == nil then
        self.AddGoldEffect = self.transform:Find("AddGoldEffect_down").gameObject;
    end
    local o = newObject((site > 1) and self.addGoldEffect_Up or self.AddGoldEffect);
    o.gameObject:SetActive(true);
    o.transform:SetParent(t);
    o.transform.localPosition = Vector3.New(0, 0, 0);
    o.transform.localScale = Vector3.New(1, 1, 1);
    WPBY_Audio.PlaySound(WPBY_Audio.SoundList.FlyCoin0);
    WPBYEntry.DelayCall(2, function()
        destroy(o.gameObject);
    end);
end
function WPBY_GoldEffect.FindUsedGold()
    local child = nil;
    local isfind = false;
    for i = 2, WPBYEntry.goldEffectPool.childCount do
        child = WPBYEntry.goldEffectPool:GetChild(i - 1);
        if not child.gameObject.activeSelf then
            isfind = true;
            return child.gameObject;
        end
    end
    if not isfind then
        child = newobject(WPBYEntry.goldEffectPool:GetChild(0).gameObject);
        child.transform:SetParent(WPBYEntry.goldEffectPool);
        child.gameObject.name = WPBYEntry.goldEffectPool:GetChild(0).gameObject.name;
        child.transform.localPosition = Vector3.New(0, 0, 0);
        child.transform.localScale = Vector3.New(1, 1, 1);
        for i = 0, child.transform.childCount - 1 do
            local trans = child.transform:GetChild(i);
            trans.gameObject:SetActive(false);
            if i == 0 then
                trans.localPosition = Vector3.New(0, 0, 0);
            elseif i == 1 then
                trans.localPosition = Vector3.New(-90, 0, 0);
            elseif i == 2 then
                trans.localPosition = Vector3.New(0, 90, 0);
            elseif i == 3 then
                trans.localPosition = Vector3.New(90, 0, 0);
            elseif i == 4 then
                trans.localPosition = Vector3.New(0, -90, 0);
            elseif i == 5 then
                trans.localPosition = Vector3.New(-90, -90, 0);
            elseif i == 6 then
                trans.localPosition = Vector3.New(90, -90, 0);
            elseif i == 7 then
                trans.localPosition = Vector3.New(-90, 90, 0);
            elseif i == 8 then
                trans.localPosition = Vector3.New(90, 90, 0);
            elseif i == 9 then
                trans.localPosition = Vector3.New(0, 180, 0);
            elseif i == 10 then
                trans.localPosition = Vector3.New(-90, 180, 0);
            elseif i == 11 then
                trans.localPosition = Vector3.New(90, 180, 0);
            elseif i == 12 then
                trans.localPosition = Vector3.New(-180, 0, 0);
            elseif i == 13 then
                trans.localPosition = Vector3.New(-180, 90, 0);
            elseif i == 14 then
                trans.localPosition = Vector3.New(-180, 180, 0);
            elseif i == 15 then
                trans.localPosition = Vector3.New(-180, -90, 0);
            elseif i == 16 then
                trans.localPosition = Vector3.New(180, 0, 0);
            elseif i == 17 then
                trans.localPosition = Vector3.New(180, 90, 0);
            elseif i == 18 then
                trans.localPosition = Vector3.New(180, 180, 0);
            elseif i == 19 then
                trans.localPosition = Vector3.New(180, -90, 0);
            elseif i == 20 then
                trans.localPosition = Vector3.New(0, 180, 0);
            elseif i == 21 then
                trans.localPosition = Vector3.New(-90, -180, 0);
            elseif i == 22 then
                trans.localPosition = Vector3.New(90, 180, 0);
            elseif i == 23 then
                trans.localPosition = Vector3.New(-180, -180, 0);
            elseif i == 24 then
                trans.localPosition = Vector3.New(180, -180, 0);
            end
        end
        return child;
    end
end
function WPBY_GoldEffect.OnShowSuperPowrEffect(isshow, time, site)
    self.superPowr.gameObject:SetActive(isshow);
    WPBYEntry.DelayCall(time, function()
        self.superPowr.gameObject:SetActive(false);
        WPBY_PlayerController.OnSetPlayerState(0, site);
    end);

    for i = 0, WPBY_DataConfig.GAME_PLAYER - 1 do
        self.superPowr.transform:Find("ShowGuns_" .. i).gameObject:SetActive(i == site);
    end
end
function WPBY_GoldEffect.OnShowHaiLang(spriteId, rotate)
    if rotate == 1 then
        self.HaiLangEffect:SetActive(true);
        self.YC = true;
        WPBY_Audio.PlaySound(WPBY_Audio.SoundList.HaiLang);
        self.HaiLangEffect.transform.localPosition = Vector3.New(-980, 0, 0);
        self.HaiLangEffect.transform:DOLocalMoveX(1300, 4):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            self.HaiLangEffect:SetActive(false);
            self.YC = false;
            self.HaiLangEffect.transform.localPosition = Vector3.New(-1000, 0, 0);
        end);
        self.SenceBackJpg.transform:DOLocalMoveX(1140, 3):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            self.SenceBackJpg.transform.localPosition = Vector3.New(0, 0, 0);
            self.SenceBackJpg:GetComponent("Image").sprite = self.SenceBackJpg2:GetComponent("Image").sprite;
        end);
        self.SenceBackJpg2:SetActive(true);
        self.SenceBackJpg2.transform.localPosition = Vector3.New(-1140, 0, 0);
        self.SenceBackJpg2.transform:DOLocalMoveX(0, 3):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            self.SenceBackJpg2.transform.localPosition = Vector3.New(-1920, 0, 0);
            self.SenceBackJpg2:SetActive(false);
        end);
    elseif rotate == 2 then
        self.YC = true;
        self.HaiLangEffect:SetActive(true);
        WPBY_Audio.PlaySound(WPBY_Audio.SoundList.HaiLang);
        self.HaiLangEffect.transform.localPosition = Vector3.New(1022, 0, 0);
        self.HaiLangEffect.transform:DOLocalMoveX(-1300, 4):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            self.HaiLangEffect:SetActive(false);
            self.YC = false;
            self.HaiLangEffect.transform.localPosition = Vector3.New(1085, 0, 0);
        end);
        self.SenceBackJpg.transform:DOLocalMoveX(-1140, 3):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            self.SenceBackJpg.transform.localPosition = Vector3.New(0, 0, 0);
            self.SenceBackJpg:GetComponent("Image").sprite = self.SenceBackJpg2:GetComponent("Image").sprite;
        end);
        self.SenceBackJpg2:SetActive(true);
        self.SenceBackJpg2.transform.localPosition = Vector3.New(1140, 0, 0);
        self.SenceBackJpg2.transform:DOLocalMoveX(0, 3):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            self.SenceBackJpg2.transform.localPosition = Vector3.New(1920, 0, 0);
            self.SenceBackJpg2:SetActive(false);
        end);
    end
end
function WPBY_GoldEffect.OnChangeBGYuChao(bgId)
    self.SenceBackJpg2:GetComponent("Image").sprite = WPBYEntry.backgroup:GetChild(bgId):GetComponent("Image").sprite;
end

function WPBY_GoldEffect.OnChangeBGStart(bgId)
    self.SenceBackJpg:GetComponent("Image").sprite = WPBYEntry.backgroup:GetChild(bgId):GetComponent("Image").sprite;
end
function WPBY_GoldEffect.ShuiHuZhuan()
    local shz = self.transform:Find("ShuiHuZhuanDead");
    shz.gameObject:SetActive(true);
    WPBYEntry.DelayCall(2, function()
        shz.gameObject:SetActive(false);
    end);
end
function WPBY_GoldEffect.JBZDEffectEvent()
    local jbzd = self.transform:Find("by_jbzd 1");
    jbzd.gameObject:SetActive(true);
    WPBY_Audio.PlaySound(WPBY_Audio.SoundList.JBZD);
    WPBYEntry.DelayCall(5, function()
        jbzd.gameObject:SetActive(false);
    end);
end
function WPBY_GoldEffect.ShowOhterFishDead(scur, name, par, fish)
    if #list > 0 then
        for i = 1, #list do
            destroy(list[i].gameObject);
        end
    end
    local ohterFishDeadEffect = self.transform:Find("OhterFishDead").gameObject;
    local o = newObject(ohterFishDeadEffect);
    o:SetActive(true);
    o.transform:SetParent(par);
    o.transform.localRotation = Quaternion.identity;
    o.transform.localScale = Vector3.New(0.8, 0.8, 1);
    o.transform.position = fish.transform.position;
    WPBYEntry.DelayCall(2, function()
        if (o == null) then
            return ;
        end
        o.transform:DOScale(Vector3.New(0.3, 0.3, 0), 0.5):SetEase(DG.Tweening.Ease.Linear);
        o.transform:DOLocalMove(Vector3.New(0, 0, 0), 1):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            destroy(o.gameObject);
            for i = 1, #list do
                if list[i] == o then
                    table.remove(list, i);
                    return ;
                end
            end
        end);
    end);
end