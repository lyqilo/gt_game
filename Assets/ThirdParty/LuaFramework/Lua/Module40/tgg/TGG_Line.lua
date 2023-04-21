TGG_Line = {};

local self = TGG_Line;

self.showTable = {};--显示连线索引列表
self.showCount = {};--显示元素个数列表
self.currentShow = 0;--当前显示索引
self.isShow = false;--可以展示
self.showTime = 0;--展示时间
self.showItemTable = {}--展示元素列表
self.showItemTable1 = {}--展示元素列表

self.showFreeTable = {}--展示免费的元素列表
self.StartShowTime = 0;--等待展示连线时间
self.isWait = false;
function TGG_Line.Init()
    self.showTable = {};
    self.showCount = {};
    self.showItemTable = {};
    self.showItemTable1 = {};
    self.currentShow = 0;
    self.showTime = 0;
    self.StartShowTime = 0;
end
function TGG_Line.Show()
    TGG_Audio.PlaySound(TGG_Audio.SoundList.LINE);
    self.showTable = {};
    self.showCount = {};
    self.showItemTable = {};
    self.showItemTable1 = {};
    self.currentShow = 0;
    self.showTime = 0;
    self.StartShowTime = 0;
    for i = 1, #TGGEntry.ResultData.LineTypeTable do
        if TGGEntry.ResultData.LineTypeTable[i].cbCount ~= 0 then
            local tempTable = {};
            local tempTable1 = {};
            for j = 1, TGGEntry.ResultData.LineTypeTable[i].cbCount do
                local rollChild = TGGEntry.RollContent:GetChild(j - 1):GetComponent("ScrollRect").content;
                for k = 1, rollChild.childCount do
                    if rollChild:GetChild(k - 1).gameObject.name == TGG_DataConfig.IconTable[TGGEntry.ResultData.LineTypeTable[i].cbIcon + 1] or rollChild:GetChild(k - 1).gameObject.name == "Jump" then
                        table.insert(tempTable, rollChild:GetChild(k - 1));
                        table.insert(tempTable1, TGGEntry.CSGroup:GetChild(j - 1):GetChild(k - 1));
                    end
                end
            end
            table.insert(self.showItemTable, tempTable);
            table.insert(self.showItemTable1, tempTable1);
            table.insert(self.showTable, TGGEntry.ResultData.LineTypeTable[i].cbIcon);
        end
    end
    self.isWait = true;
end
function TGG_Line.Close()
    self.CloseAll();
    for i = 1, #self.showItemTable1 do
        for j = 1, #self.showItemTable1[i] do
            if self.showItemTable1[i][j].childCount > 0 then
                self.CollectEffect(self.showItemTable1[i][j]:GetChild(0).gameObject);
            end
        end
    end

    TGGEntry.CSGroup.gameObject:SetActive(false);
    self.showTable = {};
    self.showCount = {};
    self.isWait = false;
    self.isShow = false;
end
function TGG_Line.Update()
    if self.isWait then
        self.StartShowTime = self.StartShowTime + Time.deltaTime;
        if self.StartShowTime >= TGG_DataConfig.waitShowLineTime then
            self.StartShowTime = 0;
            self.isWait = false;
            self.ShowAll();
            --self.isShow = true;
            TGGEntry.isRoll = false;
        end
    end
    if self.isShow then
        self.showTime = self.showTime + Time.deltaTime;
        if self.currentShow == 0 then
            if self.showTime >= TGG_DataConfig.lineAllShowTime then
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
            if self.showTime >= TGG_DataConfig.cyclePlayLineTime then
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
function TGG_Line.ShowFree()
    self.showTable = {};
    self.showItemTable = {};
    self.showItemTable1 = {};
    local tempTable = {};
    local tempTable1 = {};
    for i = 1, TGGEntry.RollContent.childCount do
        local childRoll = TGGEntry.RollContent:GetChild(i - 1):GetComponent("ScrollRect").content;
        for j = 1, childRoll.childCount do
            if childRoll:GetChild(j - 1).gameObject.name == "Ball" then
                table.insert(tempTable, childRoll:GetChild(j - 1));
                table.insert(tempTable1, TGGEntry.CSGroup:GetChild(i - 1):GetChild(j - 1));
            end
        end
    end
    table.insert(self.showItemTable, tempTable);
    table.insert(self.showItemTable1, tempTable1);
    table.insert(self.showTable, 9);
    self.ShowAll();
end
function TGG_Line.ShowAll()
    --显示总连线
    for i = 1, #self.showTable do
        local index = self.showTable[i];
        local elem = index;
        for j = 1, #self.showItemTable[i] do
            local child = self.showItemTable[i][j];
            local child1 = self.showItemTable1[i][j];
            local icon = child:Find("Icon");
            if child1.childCount <= 0 then
                local go = self.CreateEffect(child.gameObject.name);
                go.transform:SetParent(child1);
                go.transform.localPosition = Vector3.New(0, 0, 0);
                go.transform.localRotation = Quaternion.identity;
                go.transform.localScale = Vector3.New(1, 1, 1);
                go.gameObject:SetActive(true);
                go.name = child.gameObject.name;
            end
            icon:GetComponent("Image").enabled = false;
        end
    end
    TGGEntry.CSGroup.gameObject:SetActive(true);
end
function TGG_Line.CloseAll()
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
end
function TGG_Line.ShowSingle()
    --显示轮播
    for i = 1, #self.showItemTable[self.currentShow] do
        local icon = self.showItemTable[self.currentShow][i]:Find("Icon");
        icon:GetComponent("Image").enabled = false;
        if icon.childCount > 0 then
            icon:GetChild(0).gameObject:SetActive(true);
        end
    end
end
function TGG_Line.CloseSingle()
    --关闭单个显示
    for i = 1, #self.showItemTable[self.currentShow] do
        local icon = self.showItemTable[self.currentShow][i]:Find("Icon");
        icon:GetComponent("Image").enabled = true;
        if icon.childCount > 0 then
            icon:GetChild(0).gameObject:SetActive(false);
        end
    end
end

function TGG_Line.CollectEffect(obj)
    --回收动画
    if obj == nil then
        return ;
    end
    obj.transform:SetParent(TGGEntry.effectPool);
    obj:SetActive(false);
end
function TGG_Line.CreateEffect(effectname)
    --创建动画，先从对象池中获取
    local go = TGGEntry.effectPool:Find(effectname);
    if go ~= nil then
        return go.gameObject;
    end
    go = TGGEntry.effectList:Find(effectname);
    local _go = newObject(go);
    return _go;
end