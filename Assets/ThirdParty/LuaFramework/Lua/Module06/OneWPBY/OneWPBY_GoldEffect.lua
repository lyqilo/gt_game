OneWPBY_GoldEffect = {};
local self = OneWPBY_GoldEffect;

self.transform = nil;
self.gameObject = nil;

self.superPowr = nil;
self.list = {};
function OneWPBY_GoldEffect.Init(obj)
    self.gameObject = obj;
    self.transform = self.gameObject.transform;
    self.superPowr = self.transform:Find("SuperPowr");
    self.HaiLangLeftEffect = self.transform:Find("HaiLangLeft").gameObject;
    self.HaiLangRightEffect = self.transform:Find("HaiLangRight").gameObject;
    self.SenceBackJpg = OneWPBYEntry.backgroundPanel:Find("sence_bg_1").gameObject;
    self.SenceBackJpg2 = OneWPBYEntry.backgroundPanel:Find("sence_bg_2").gameObject;
    self.list = {};
    self.YC = false;
end

function OneWPBY_GoldEffect.FlyGold(fish, deadFishData, chairId)
    local player = OneWPBY_PlayerController.GetPlayer(chairId);
    if player == nil then
        return ;
    end
    if fish.fishData.Kind == 16 then
        local go = newobject(OneWPBYEntry.goldEffectPoolAllScene:GetChild(0).gameObject);
        go.transform:SetParent(player.userGold.transform);
        go.transform.position = OneWPBYEntry.goldEffectPoolAllScene:GetChild(0).transform.position;
        go.transform.localScale = Vector3.New(1, 1, 1);
        go.gameObject:SetActive(true);
        OneWPBYEntry.DelayCall(3, function()
            if go ~= nil then
                go.transform:DOScale(Vector3.New(0, 0, 0), 0.5):SetEase(DG.Tweening.Ease.Linear)
                go.transform:DOLocalMove(Vector3.New(0, 0, 0), 0.5):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                    if go ~= nil then
                        destroy(go.gameObject);
                    end
                end);
            end
        end);
        return ;
    end
    --local r = OneWPBYEntry.GetMagnificationToFishID(fish.fishData.id);
    local r = math.ceil(fish.fishData.Kind / 3);
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
    OneWPBYEntry.DelayCall(0.5, function()
        if goldObj == nil then
            return ;
        end
        local newPoint = Vector3.New(goldObj.transform.localPosition.x + Mathf.Random(-r * 20, r * 20), goldObj.transform.localPosition.y + Mathf.Random(-r * 20, r * 20), 0);
        goldObj.transform:DOScale(Vector3.New(1, 1, 1), 0.5):SetEase(DG.Tweening.Ease.OutBack);
        goldObj.transform:DOLocalMove(newPoint, 0.5):SetEase(DG.Tweening.Ease.OutBack):OnComplete(function()
            OneWPBYEntry.DelayCall(0.7, function()
                if goldObj == nil then
                    return ;
                end
                goldObj.transform:DOLocalMove(Vector3.New(0, 0, 0), Mathf.Random(0.3, 0.7)):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                    if goldObj == nil then
                        return ;
                    end
                    goldObj.gameObject:SetActive(false);
                    goldObj.transform:SetParent(OneWPBYEntry.goldEffectPool);
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
function OneWPBY_GoldEffect.OnShowScure(fish, scur, site)
    if fish.fishData.Kind >= 18 then
        return ;
    end
    local player = OneWPBY_PlayerController.GetPlayer(site);
    if player == nil then
        return ;
    end
    local magnification = OneWPBYEntry.GetMagnificationToFishID(fish.fishData.id);
    local o = newobject(self.transform:Find("Socur_0").gameObject);
    --if magnification <= 10 then
    --    o = newobject(self.transform:Find("Socur_0").gameObject);
    --elseif magnification <= 15 then
    --    o = newobject(self.transform:Find("Socur_1").gameObject);
    --else
    --    o = newobject(self.transform:Find("Socur_2").gameObject);
    --end
    o.gameObject:SetActive(true);
    o.transform:SetParent(OneWPBYEntry.effectScene);
    o.transform:GetComponent("TextMeshProUGUI").text = OneWPBYEntry.ShowText(scur);
    o.transform.position = fish.transform.position;
    o.transform.localScale = Vector3.New(1, 1, 1);
    OneWPBYEntry.DelayCall(1, function()
        if o ~= nil then
            destroy(o.gameObject);
        end
    end);
end
--超级大奖
function OneWPBY_GoldEffect.ShowSuperJack(scur, fish, chairId)
    local obj = nil;
    if fish.fishData.Kind == 13 then
        --银鲨
        obj = newobject(self.transform:Find("WPBU_defengpan01").gameObject);
        local ys = math.random(1, 3);
        OneWPBY_Audio.PlaySound("YS" .. ys);
    elseif fish.fishData.Kind == 14 then
        --金鲨
        obj = newobject(self.transform:Find("WPBU_defengpan01").gameObject);
        local js = math.random(1, 3);
        OneWPBY_Audio.PlaySound("JS" .. js);
    elseif fish.fishData.Kind == 15 then
        --金龙
        local eff = newObject(self.transform:Find("WPBU_baozha03").gameObject);
        eff.transform:SetParent(OneWPBYEntry.effectScene);
        eff.transform.position = fish.transform.position;
        eff.transform.localScale = Vector3.New(1, 1, 1);
        eff.gameObject:SetActive(true);
        OneWPBYEntry.DelayCall(1.5, function()
            if eff ~= nil then
                destroy(eff.gameObject);
            end
        end);
        obj = newobject(self.transform:Find("WPBU_defengpan01").gameObject);
        local jl = math.random(1, 3);
        OneWPBY_Audio.PlaySound("JL" .. jl);
    elseif fish.fishData.Kind == 16 then
        --金币海豚
        obj = newobject(self.transform:Find("WPBU_defengpan02").gameObject);
        OneWPBY_Audio.PlaySound(OneWPBY_Audio.SoundList.Boss);
    elseif fish.fishData.Kind == 18 then
        --全屏
        OneWPBY_Audio.PlaySound(OneWPBY_Audio.SoundList.QP);
    elseif fish.fishData.Kind == 19 then
        --局部
        OneWPBY_Audio.PlaySound(OneWPBY_Audio.SoundList.JBZD);
    elseif fish.fishData.Kind >= 20 and fish.fishData.Kind <= 24 then
        --同类
        OneWPBY_Audio.PlaySound(OneWPBY_Audio.SoundList.TL);
    end
    if obj == nil then
        return ;
    end
    obj.gameObject:SetActive(true);
    obj.transform:SetParent(OneWPBYEntry.effectScene);
    obj.transform.position = fish.transform.position;
    obj.transform.localScale = Vector3.New(1, 1, 1);
    obj.transform:Find("goldText"):GetComponent("TextMeshProUGUI").text = OneWPBYEntry.ShowText(scur);
    OneWPBYEntry.DelayCall(1, function()
        if obj == nil then
            return ;
        end
        local player = OneWPBY_PlayerController.GetPlayer(chairId);
        if player ~= nil then
            obj.transform:SetParent(player.transform);
            obj.transform:DOLocalMove(Vector3.New(0, 170, 0), 1):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                OneWPBYEntry.DelayCall(1, function()
                    if obj ~= nil then
                        destroy(obj.gameObject);
                    end
                end);
            end);
        else
            OneWPBYEntry.DelayCall(1, function()
                if obj ~= nil then
                    destroy(obj.gameObject);
                end
            end);
        end
    end);
end
function OneWPBY_GoldEffect.ShowAddGoldEffect(t, site)
    --if self.addGoldEffect_Up == nil then
    --    self.addGoldEffect_Up = self.transform:Find("AddGoldEffect_up").gameObject;
    --end
    --if self.AddGoldEffect == nil then
    --    self.AddGoldEffect = self.transform:Find("AddGoldEffect_down").gameObject;
    --end
    --local o = newObject((site > 1) and self.addGoldEffect_Up or self.AddGoldEffect);
    --o.gameObject:SetActive(false);
    --o.transform:SetParent(t);
    --o.transform.localPosition = Vector3.New(0, 0, 0);
    --o.transform.localScale = Vector3.New(1, 1, 1);
    OneWPBY_Audio.PlaySound(OneWPBY_Audio.SoundList.FlyCoin0);
    --OneWPBYEntry.DelayCall(2, function()
    --    destroy(o.gameObject);
    --end);
end
function OneWPBY_GoldEffect.FindUsedGold()
    local child = nil;
    local isfind = false;
    for i = 2, OneWPBYEntry.goldEffectPool.childCount do
        child = OneWPBYEntry.goldEffectPool:GetChild(i - 1);
        if not child.gameObject.activeSelf then
            isfind = true;
            return child.gameObject;
        end
    end
    if not isfind then
        child = newobject(OneWPBYEntry.goldEffectPool:GetChild(0).gameObject);
        child.transform:SetParent(OneWPBYEntry.goldEffectPool);
        child.gameObject.name = OneWPBYEntry.goldEffectPool:GetChild(0).gameObject.name;
        child.transform.localPosition = Vector3.New(0, 0, 0);
        child.transform.localScale = Vector3.New(1, 1, 1);
        for i = 0, child.transform.childCount - 1 do
            local trans = child.transform:GetChild(i);
            trans.gameObject:SetActive(false);
            if i == 0 then
                trans.localPosition = Vector3.New(0, 0, 0);
            elseif i == 1 then
                trans.localPosition = Vector3.New(-60, 0, 0);
            elseif i == 2 then
                trans.localPosition = Vector3.New(0, 60, 0);
            elseif i == 3 then
                trans.localPosition = Vector3.New(60, 0, 0);
            elseif i == 4 then
                trans.localPosition = Vector3.New(0, -60, 0);
            elseif i == 5 then
                trans.localPosition = Vector3.New(-60, -60, 0);
            elseif i == 6 then
                trans.localPosition = Vector3.New(60, -60, 0);
            elseif i == 7 then
                trans.localPosition = Vector3.New(-60, 60, 0);
            elseif i == 8 then
                trans.localPosition = Vector3.New(60, 60, 0);
            elseif i == 9 then
                trans.localPosition = Vector3.New(0, 120, 0);
            elseif i == 10 then
                trans.localPosition = Vector3.New(-60, 120, 0);
            elseif i == 11 then
                trans.localPosition = Vector3.New(60, 120, 0);
            elseif i == 12 then
                trans.localPosition = Vector3.New(-120, 0, 0);
            elseif i == 13 then
                trans.localPosition = Vector3.New(-120, 60, 0);
            elseif i == 14 then
                trans.localPosition = Vector3.New(-120, 120, 0);
            elseif i == 15 then
                trans.localPosition = Vector3.New(-120, -60, 0);
            elseif i == 16 then
                trans.localPosition = Vector3.New(120, 0, 0);
            elseif i == 17 then
                trans.localPosition = Vector3.New(120, 60, 0);
            elseif i == 18 then
                trans.localPosition = Vector3.New(120, 120, 0);
            elseif i == 19 then
                trans.localPosition = Vector3.New(120, -60, 0);
            elseif i == 20 then
                trans.localPosition = Vector3.New(0, 120, 0);
            elseif i == 21 then
                trans.localPosition = Vector3.New(-60, -120, 0);
            elseif i == 22 then
                trans.localPosition = Vector3.New(60, 120, 0);
            elseif i == 23 then
                trans.localPosition = Vector3.New(-120, -120, 0);
            elseif i == 24 then
                trans.localPosition = Vector3.New(120, -120, 0);
            end
        end
        return child;
    end
end
function OneWPBY_GoldEffect.OnShowSuperPowrEffect(isshow, time, site)
    self.superPowr.gameObject:SetActive(isshow);
    OneWPBYEntry.DelayCall(time, function()
        self.superPowr.gameObject:SetActive(false);
        OneWPBY_PlayerController.OnSetPlayerState(0, site);
    end);

    for i = 0, OneWPBY_DataConfig.GAME_PLAYER - 1 do
        self.superPowr.transform:Find("ShowGuns_" .. i).gameObject:SetActive(i == site);
    end
end
function OneWPBY_GoldEffect.OnShowHaiLang(spriteId, rotate)
    local rate = Screen.width / Screen.height;
    if rotate == 1 then
        self.HaiLangLeftEffect:SetActive(true);
        self.YC = true;
        OneWPBY_Audio.PlaySound(OneWPBY_Audio.SoundList.HaiLang);
        self.HaiLangLeftEffect.transform.localPosition = Vector3.New(-rate * 640 / 2, 0, 0);
        self.HaiLangLeftEffect.transform:DOLocalMoveX(rate * 640, 4.5):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            self.HaiLangLeftEffect:SetActive(false);
            self.YC = false;
            self.HaiLangLeftEffect.transform.localPosition = Vector3.New(-1000, 0, 0);
        end);
        self.SenceBackJpg.transform:SetAsFirstSibling();
        self.SenceBackJpg.transform:DOLocalMoveX(rate * 640, 3):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            self.SenceBackJpg:GetComponent("Image").sprite = self.SenceBackJpg2:GetComponent("Image").sprite;
            self.SenceBackJpg.transform.localPosition = Vector3.New(0, 0, 0);
        end);
        self.SenceBackJpg2:SetActive(true);
        self.SenceBackJpg2.transform.localPosition = Vector3.New(-rate * 640, 0, 0);
        self.SenceBackJpg2.transform:DOLocalMoveX(0, 3):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            self.SenceBackJpg2.transform.localPosition = Vector3.New(-rate * 640, 0, 0);
            self.SenceBackJpg2:SetActive(false);
            self.SenceBackJpg2.transform:SetAsFirstSibling();
        end);
    elseif rotate == 2 then
        self.YC = true;
        self.HaiLangRightEffect:SetActive(true);
        OneWPBY_Audio.PlaySound(OneWPBY_Audio.SoundList.HaiLang);
        self.HaiLangRightEffect.transform.localPosition = Vector3.New(rate * 640 / 2, 0, 0);
        self.HaiLangRightEffect.transform:DOLocalMoveX(-rate * 640, 4.5):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            self.HaiLangRightEffect:SetActive(false);
            self.YC = false;
            self.HaiLangRightEffect.transform.localPosition = Vector3.New(1085, 0, 0);
        end);
        self.SenceBackJpg.transform:DOLocalMoveX(-rate * 640, 3):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            self.SenceBackJpg:GetComponent("Image").sprite = self.SenceBackJpg2:GetComponent("Image").sprite;
            self.SenceBackJpg.transform.localPosition = Vector3.New(0, 0, 0);
        end);
        self.SenceBackJpg2:SetActive(true);
        self.SenceBackJpg2.transform.localPosition = Vector3.New(rate * 640, 0, 0);
        self.SenceBackJpg2.transform:DOLocalMoveX(0, 3):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
            self.SenceBackJpg2.transform.localPosition = Vector3.New(rate * 640, 0, 0);
            self.SenceBackJpg2:SetActive(false);
        end);
    end
end
function OneWPBY_GoldEffect.OnChangeBGYuChao(bgId)
    self.SenceBackJpg2:GetComponent("Image").sprite = OneWPBYEntry.backgroup:GetChild(bgId):GetComponent("Image").sprite;
end

function OneWPBY_GoldEffect.OnChangeBGStart(bgId)
    self.SenceBackJpg:GetComponent("Image").sprite = OneWPBYEntry.backgroup:GetChild(bgId):GetComponent("Image").sprite;
end
function OneWPBY_GoldEffect.ShuiHuZhuan()
    local shz = self.transform:Find("WPBU_baozha04");
    OneWPBY_Audio.PlaySound(OneWPBY_Audio.SoundList.QP);
    shz.gameObject:SetActive(true);
    OneWPBYEntry.DelayCall(2, function()
        shz.gameObject:SetActive(false);
    end);
    local fishlist = OneWPBY_FishController.OnGetFishToSence();
    self.ShowSingleBomb(fishlist);
end
function OneWPBY_GoldEffect.ShowSingleBomb(fishlist)
    for i = 1, #fishlist do
        local go = newobject(self.transform:Find("WPBU_baozha01").gameObject);
        go.transform:SetParent(fishlist[i].transform);
        go.transform.localPosition = Vector3.New(0, 0, 0);
        go.transform.localScale = Vector3.New(1, 1, 1);
        go.gameObject:SetActive(true);
        OneWPBYEntry.DelayCall(1, function()
            if go ~= nil then
                destroy(go.gameObject);
            end
        end);
    end
end

function OneWPBY_GoldEffect.TLZDEffectEvent()
    local tlzd = self.transform:Find("WPBU_baozha03");
    tlzd.gameObject:SetActive(true);
    OneWPBYEntry.DelayCall(1, function()
        tlzd.gameObject:SetActive(false);
    end);
end
function OneWPBY_GoldEffect.JBZDEffectEvent()
    local jbzd = self.transform:Find("WPBU_baozha02");
    jbzd.gameObject:SetActive(true);
    OneWPBYEntry.DelayCall(2, function()
        jbzd.gameObject:SetActive(false);
    end);
end
function OneWPBY_GoldEffect.ShowOhterFishDead(scur, name, par, fish)
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
    OneWPBYEntry.DelayCall(2, function()
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