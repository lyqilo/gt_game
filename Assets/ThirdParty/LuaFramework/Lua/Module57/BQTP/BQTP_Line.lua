BQTP_Line = {};

local self = BQTP_Line;

self.showTable = {};--显示连线索引列表

function BQTP_Line.Init()
    self.showTable = {};
end
function BQTP_Line.Show()
    self.showTable = {};
    for i = 1, #BQTPEntry.ResultData.LineTypeTable do
        if BQTPEntry.ResultData.LineTypeTable[i] ~= 0 then
            table.insert(self.showTable, i);
        end
    end
    self.ShowEffect();
end
function BQTP_Line.ShowEffect()
    for i = 1, #self.showTable do
        local index = self.showTable[i];
        local elem = BQTPEntry.ResultData.ImgTable[index];
        local cloumn = (index - 1) % 5;
        local raw = 2 - math.floor((index - 1) / 5);
        local eff = self.CreateEffect(BQTP_DataConfig.EffectTable[elem + 1]);
        if eff ~= nil then
            local icon = BQTPEntry.RollContent:GetChild(cloumn):GetComponent("ScrollRect").content:GetChild(raw):Find("Icon"):GetComponent("Image");
            eff.transform:SetParent(icon.transform);
            eff.transform.localPosition = Vector3.New(0, 0, 0);
            eff.transform.localScale = Vector3.New(1, 1, 1);
            eff.gameObject:SetActive(true);
            icon.enabled = false;
            local anim = eff.transform:Find("Sprite"):GetComponent("UnityArmatureComponent");
            anim.dbAnimation:Play("Sprite", 1);
            BQTPEntry.DelayCall(2, function()
                if BQTPEntry.ReRollCount > 0 then
                    local iceBreak = self.CreateEffect("XC");
                    iceBreak.transform:SetParent(icon.transform);
                    iceBreak.transform.localPosition = Vector3.New(0, 0, 0);
                    iceBreak.transform.localScale = Vector3.New(1, 1, 1);
                    iceBreak.gameObject:SetActive(true);
                    BQTPEntry.DelayCall(0.5, function()
                        self.CollectEffect(eff.gameObject);
                    end);
                    BQTP_Audio.PlaySound(BQTP_Audio.SoundList.Smathing_Break);
                    anim = iceBreak.transform:Find("Sprite"):GetComponent("UnityArmatureComponent");
                    anim.dbAnimation:Play("Sprite", 1);
                    BQTPEntry.DelayCall(0.8, function()
                        self.CollectEffect(iceBreak.gameObject);
                        icon.transform.parent:SetSiblingIndex(2);
                        local pos = icon.transform.parent.localPosition;
                        icon.transform.parent.localPosition = Vector3.New(pos.x, BQTP_DataConfig.ItemPosList[4], pos.z);
                    end);
                else
                    self.CollectEffect(eff.gameObject);
                    icon.enabled = true;
                end
            end);
        end
    end
    if BQTPEntry.ReRollCount > 0 then
        BQTPEntry.DelayCall(3, function()
            --TODO 移动 重转
            self.MoveThreeRaw();
        end);
    end
end
function BQTP_Line.MoveThreeRaw()
    for i = 1, 5 do
        for j = 1, 3 do
            local child = BQTP_Roll.rollList[i].content:GetChild(j - 1):Find("Icon");
            if child:GetComponent("Image").enabled then
                child.parent:DOLocalMove(Vector3.New(0, BQTP_DataConfig.ItemPosList[j], 0), 0.2):SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
                    BQTP_Audio.PlaySound(BQTP_Audio.SoundList.Normal_Drop);
                end);
            end
        end
    end
    BQTPEntry.DelayCall(0.3, function()
        BQTPEntry.ReRollState();
    end);
end
function BQTP_Line.Close()

end

function BQTP_Line.CollectEffect(obj)
    --回收动画
    if obj == nil then
        return ;
    end
    obj.transform:SetParent(BQTPEntry.effectPool);
    obj:SetActive(false);
end
function BQTP_Line.CreateEffect(effectname)
    --创建动画，先从对象池中获取
    local go = BQTPEntry.effectPool:Find(effectname);
    if go ~= nil then
        return go.gameObject;
    end
    go = BQTPEntry.effectList:Find(effectname);
    local _go = newObject(go);
    return _go;
end