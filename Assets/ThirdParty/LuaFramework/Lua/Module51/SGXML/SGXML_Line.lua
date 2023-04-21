SGXML_Line = {};

local self = SGXML_Line;

self.showTable = {};--显示连线索引列表
self.showCount = {};--显示元素个数列表
self.currentShow = 0;--当前显示索引
self.isShow = false;--可以展示
self.showTime = 0;--展示时间
self.showItemTable = {}--展示元素列表

self.showFreeTable = {}--展示免费的元素列表
self.StartShowTime = 0;--等待展示连线时间
self.isWait = false;
function SGXML_Line.Init()
    self.showTable = {};
    self.showCount = {};
    self.showItemTable = {};
    self.currentShow = 0;
    self.showTime = 0;
    self.StartShowTime = 0;
end
function SGXML_Line.Show()
    SGXML_Audio.PlaySound(SGXML_Audio.SoundList.LINE);
    self.showTable = {};
    self.showCount = {};
    self.showItemTable = {};
    self.currentShow = 0;
    self.showTime = 0;
    self.StartShowTime = 0;
    for i = 1, #SGXMLEntry.ResultData.LineTypeTable do
        if SGXMLEntry.ResultData.LineTypeTable[i] ~= 0 then
            table.insert(self.showTable, i);
            table.insert(self.showCount, SGXMLEntry.ResultData.LineTypeTable[i]);
        end
    end
    self.isWait = true;
end
function SGXML_Line.Close()
    self.CloseAll();
    for i = 1, SGXMLEntry.RollContent.childCount do
        local child = SGXMLEntry.RollContent:GetChild(i - 1):GetComponent("ScrollRect").content;
        for j = 1, child.childCount do
            child:GetChild(j - 1):Find("Icon"):GetComponent("Image").color = Color.white;
        end
    end
    for i = 1, #self.showItemTable do
        for j = 1, #self.showItemTable[i] do
            if self.showItemTable[i][j]:Find("Icon").childCount > 0 then
                self.CollectEffect(self.showItemTable[i][j]:Find("Icon"):GetChild(0).gameObject);
            end
        end
    end

    SGXMLEntry.CSGroup.gameObject:SetActive(false);
    self.showTable = {};
    self.showCount = {};
    self.isWait = false;
    self.isShow = false;
end
function SGXML_Line.Update()
    if self.isWait then
        self.StartShowTime = self.StartShowTime + Time.deltaTime;
        if self.StartShowTime >= SGXML_DataConfig.waitShowLineTime then
            self.StartShowTime = 0;
            self.isWait = false;
            self.ShowAll();
            self.isShow = true;
        end
    end
    if self.isShow then
        self.showTime = self.showTime + Time.deltaTime;
        if self.currentShow == 0 then
            if self.showTime >= SGXML_DataConfig.lineAllShowTime then
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
            if self.showTime >= SGXML_DataConfig.cyclePlayLineTime then
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
function SGXML_Line.ShowAll()
    --显示总连线
    SGXMLEntry.LineGroup.gameObject:SetActive(true);
    for i = 1, #self.showTable do
        SGXMLEntry.LineGroup:GetChild(self.showTable[i] - 1).gameObject:SetActive(true);
        local showlist = SGXML_DataConfig.Line[self.showTable[i]];--这是单条线对应位置
        local tempTable = {};--每组展示的元素集合
        for j = 1, self.showCount[i] do
            local index = showlist[j];
            local elem = SGXMLEntry.ResultData.ImgTable[index];
            local column = math.ceil(index / 5);
            local raw = math.floor(index % 5);
            if raw == 0 then
                raw = 5;
            end
            local child = SGXMLEntry.RollContent.transform:GetChild(raw - 1):GetComponent("ScrollRect").content:GetChild(column - 1);
            local icon = child:Find("Icon");
            if icon.childCount <= 0 then
                local go = self.CreateEffect(SGXML_DataConfig.EffectTable[elem]);
                go.transform:SetParent(child:Find("Icon"));
                go.transform.localPosition = Vector3.New(0, 0, 0);
                go.transform.localRotation = Quaternion.identity;
                go.transform.localScale = Vector3.New(1, 1, 1);
                go.gameObject:SetActive(true);
                go.name = SGXML_DataConfig.EffectTable[elem];
            end
            child:Find("Icon"):GetComponent("Image").enabled = false;
            table.insert(tempTable, child);
        end
        table.insert(self.showItemTable, tempTable);
    end
end
function SGXML_Line.CloseAll()
    --关闭总显示
    for i = 1, #self.showItemTable do
        for j = 1, #self.showItemTable[i] do
            local icon = self.showItemTable[i][j]:Find("Icon");
            icon:GetComponent("Image").enabled = true;
            if icon.childCount > 0 then
                icon:GetChild(0).gameObject:SetActive(false);
            end
        end
    end
    for i = 1, SGXMLEntry.LineGroup.childCount do
        SGXMLEntry.LineGroup:GetChild(i - 1).gameObject:SetActive(false);
    end
end
function SGXML_Line.ShowSingle()
    --显示轮播
    SGXMLEntry.LineGroup:GetChild(self.showTable[self.currentShow] - 1).gameObject:SetActive(true);
    for i = 1, #self.showItemTable[self.currentShow] do
        local icon = self.showItemTable[self.currentShow][i]:Find("Icon");
        icon:GetComponent("Image").enabled = false;
        if icon.childCount > 0 then
            icon:GetChild(0).gameObject:SetActive(true);
        end
    end
end
function SGXML_Line.CloseSingle()
    --关闭单个显示
    SGXMLEntry.LineGroup:GetChild(self.showTable[self.currentShow] - 1).gameObject:SetActive(false);
    for i = 1, #self.showItemTable[self.currentShow] do
        local icon = self.showItemTable[self.currentShow][i]:Find("Icon");
        icon:GetComponent("Image").enabled = true;
        if icon.childCount > 0 then
            icon:GetChild(0).gameObject:SetActive(false);
        end
    end
end

function SGXML_Line.CollectEffect(obj)
    --回收动画
    if obj == nil then
        return ;
    end
    obj.transform:SetParent(SGXMLEntry.effectPool);
    obj:SetActive(false);
end
function SGXML_Line.CreateEffect(effectname)
    --创建动画，先从对象池中获取
    local go = SGXMLEntry.effectPool:Find(effectname);
    if go ~= nil then
        return go.gameObject;
    end
    go = SGXMLEntry.effectList:Find(effectname);
    local _go = newObject(go);
    return _go;
end