FLM_Line = {};

local self = FLM_Line;

self.showTable = {};--显示连线索引列表
self.showCount = {};--显示元素个数列表
self.currentShow = 0;--当前显示索引
self.isShow = false;--可以展示
self.showTime = 0;--展示时间
self.showItemTable = {}--展示元素列表

self.StartShowTime = 0;--等待展示连线时间
self.isWait = false;
function FLM_Line.Init()
    self.showTable = {};
    self.showCount = {};
    self.showItemTable = {};
    self.currentShow = 0;
    self.showTime = 0;
    self.StartShowTime = 0;
end
function FLM_Line.Show()
    FLM_Audio.PlaySound(FLM_Audio.SoundList.LINE);
    self.showTable = {};
    self.showCount = {};
    self.showItemTable = {};
    self.currentShow = 0;
    self.showTime = 0;
    self.StartShowTime = 0;
    for i = 1, #FLMEntry.ResultData.LineTypeTable do
        if FLMEntry.ResultData.LineTypeTable[i][1] ~= 0 then
            local index = i;
            table.insert(self.showTable, index);
            local count = 0;
            for j = 1, #FLMEntry.ResultData.LineTypeTable[i] do
                if FLMEntry.ResultData.LineTypeTable[i][j] ~= 0 then
                    count = count + 1;
                end
            end
            table.insert(self.showCount, count);
        end
    end
    self.isWait = true;
end
function FLM_Line.Close()
    self.CloseAll();
    for i = 1, #self.showItemTable do
        for j = 1, #self.showItemTable[i] do
            self.showItemTable[i][j]:Find("Icon"):GetComponent("Image").enabled = true;
            if self.showItemTable[i][j]:Find("Icon").childCount > 1 then
                self.CollectEffect(self.showItemTable[i][j]:Find("Icon/Effect").gameObject);
            end
        end
    end
    self.showTable = {};
    self.showCount = {};
    self.isWait = false;
    self.isShow = false;
end
function FLM_Line.Update()
    if self.isWait then
        self.StartShowTime = self.StartShowTime + Time.deltaTime;
        if self.StartShowTime >= FLM_DataConfig.waitShowLineTime then
            self.StartShowTime = 0;
            self.isWait = false;
            self.ShowAll();
            self.isShow = true;
        end
    end
    if self.isShow then
        self.showTime = self.showTime + Time.deltaTime;
        if self.currentShow == 0 then
            if self.showTime >= FLM_DataConfig.lineAllShowTime then
                self.showTime = 0;
                if #self.showTable == 1 then
                    return ;
                end
                self.currentShow = self.currentShow + 1;
                if self.currentShow > #self.showTable then
                    self.currentShow = 1;
                end
                self.CloseAll();
                self.ShowSingle();
            end
        else
            if self.showTime >= FLM_DataConfig.cyclePlayLineTime then
                self.showTime = 0;
                self.CloseSingle();
                self.currentShow = self.currentShow + 1;
                if self.currentShow > #self.showTable then
                    self.currentShow = 1;
                end
                self.ShowSingle();
            end
        end
    end
end
function FLM_Line.ShowAll()
    --显示总连线
    FLMEntry.LineGroup.gameObject:SetActive(true);
    local isPlayerBoy = false
    local isPlayerlone = false

    for i = 1, #self.showTable do
        FLMEntry.LineGroup:GetChild(self.showTable[i] - 1).gameObject:SetActive(true);
        local showlist = FLM_DataConfig.Line[self.showTable[i]];--这是单条线对应位置
        local tempTable = {};--每组展示的元素集合
        for j = 1, self.showCount[i] do
            local index = showlist[j];
            local elem = FLMEntry.ResultData.ImgTable[index + 1];
            local column = math.floor(index / 5);
            local raw = math.floor(index % 5);
            local child = FLMEntry.RollContent.transform:GetChild(raw):GetComponent("ScrollRect").content:GetChild(column);
            local icon = child:Find("Icon");
            if icon:Find("Effect") == nil and elem ~= 11 then
                local go = self.CreateEffect(FLM_DataConfig.EffectTable[elem + 1]);
                go.transform:SetParent(child:Find("Icon"));
                go.transform.localPosition = Vector3.New(0, 0, 0);
                go.transform.localRotation = Quaternion.identity;
                go.transform.localScale = Vector3.New(1, 1, 1);
                go.gameObject:SetActive(true);
                go.name = FLM_DataConfig.EffectTable[elem + 1];
                go.transform:GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0, "animation", true);
                if elem == 6 or elem == 7 then
                    isPlayerBoy = true
                elseif elem == 8 then
                    isPlayerlone = true
                end
                go.gameObject.name = "Effect";
                icon:GetComponent("Image").enabled = false;
            end
            table.insert(tempTable, child);
        end
        table.insert(self.showItemTable, tempTable);
    end
    logTable(self.showItemTable)
    if isPlayerBoy then
        FLM_Audio.PlaySound(FLM_Audio.SoundList.BoyLaugh);
    elseif isPlayerlone then
        FLM_Audio.PlaySound(FLM_Audio.SoundList.Lion);
    end
end

function FLM_Line.CloseAll()
    --关闭总显示
    for i = 1, #self.showTable do
        FLMEntry.LineGroup:GetChild(self.showTable[i] - 1).gameObject:SetActive(false);
        for j = 1, #self.showItemTable[i] do
            local icon = self.showItemTable[i][j]:Find("Icon");
            icon:GetComponent("Image").enabled = true;
            if icon.childCount > 1 then
                icon:Find("Effect").gameObject:SetActive(false);
            end
        end
    end
end
function FLM_Line.ShowSingle()
    --显示轮播
    FLMEntry.LineGroup:GetChild(self.showTable[self.currentShow] - 1).gameObject:SetActive(true);
    for i = 1, #self.showItemTable[self.currentShow] do
        local icon = self.showItemTable[self.currentShow][i]:Find("Icon");
        icon:GetComponent("Image").enabled = false;
        if icon.childCount > 1 then
            icon:Find("Effect").gameObject:SetActive(true);
            icon:Find("Effect").transform:GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0, "animation", true);
        end
    end
end
function FLM_Line.CloseSingle()
    --关闭单个显示
    FLMEntry.LineGroup:GetChild(self.showTable[self.currentShow] - 1).gameObject:SetActive(false);
    for i = 1, #self.showItemTable[self.currentShow] do
        local icon = self.showItemTable[self.currentShow][i]:Find("Icon");
        icon:GetComponent("Image").enabled = true;
        if icon.childCount > 1 then
            icon:Find("Effect").gameObject:SetActive(false);
        end
    end
end

function FLM_Line.CollectEffect(obj)
    --回收动画
    if obj == nil then
        return ;
    end
    obj.transform:SetParent(FLMEntry.effectPool);
    obj:SetActive(false);
end
function FLM_Line.CreateEffect(effectname)
    --创建动画，先从对象池中获取
    local go = FLMEntry.effectPool:Find(effectname);
    if go ~= nil then
        return go.gameObject;
    end
    go = FLMEntry.effectList:Find(effectname);
    local _go = newObject(go);
    return _go;
end