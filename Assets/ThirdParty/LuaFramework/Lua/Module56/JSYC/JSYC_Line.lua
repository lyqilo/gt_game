JSYC_Line = {};

local self = JSYC_Line;

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
function JSYC_Line.Init()
    self.showTable = {};
    self.showCount = {};
    self.showItemTable = {};
    self.showItemTable1 = {};
    self.currentShow = 0;
    self.showTime = 0;
    self.StartShowTime = 0;
end
function JSYC_Line.Show()
    --JSYC_Audio.PlaySound(JSYC_Audio.SoundList.LINE);
    self.showTable = {};
    self.showCount = {};
    self.showItemTable = {};
    self.showItemTable1 = {};
    self.currentShow = 0;
    self.showTime = 0;
    self.StartShowTime = 0;
    for i = 1, #JSYCEntry.ResultData.LineTypeTable do
        if JSYCEntry.ResultData.LineTypeTable[i].cbCount ~= 0 then
            local tempTable = {};
            local tempTable1 = {};
            for j = 1, JSYCEntry.ResultData.LineTypeTable[i].cbCount do
                local rollChild = JSYCEntry.RollContent:GetChild(j - 1):GetComponent("ScrollRect").content;
                for k = 1, rollChild.childCount do
                    if rollChild:GetChild(k - 1).gameObject.name == JSYC_DataConfig.IconTable[JSYCEntry.ResultData.LineTypeTable[i].cbIcon + 1] or rollChild:GetChild(k - 1).gameObject.name == "Jump" then
                        table.insert(tempTable, rollChild:GetChild(k - 1));
                        table.insert(tempTable1, JSYCEntry.CSGroup:GetChild(j - 1):GetChild(0):GetChild(0):GetChild(k - 1));  
                    end
                end
            end
            table.insert(self.showItemTable, tempTable);
            table.insert(self.showItemTable1, tempTable1);
            table.insert(self.showTable, JSYCEntry.ResultData.LineTypeTable[i].cbIcon);
        end
    end
    self.isWait = true;
end
function JSYC_Line.Close()
    self.CloseAll();
    for i = 1, #self.showItemTable1 do
        for j = 1, #self.showItemTable1[i] do
            if self.showItemTable1[i][j].childCount > 0 then
                self.CollectEffect(self.showItemTable1[i][j]:GetChild(0).gameObject);
            end
        end
    end

    JSYCEntry.CSGroup.gameObject:SetActive(false);
    self.showTable = {};
    self.showCount = {};
    self.isWait = false;
    self.isShow = false;
end
function JSYC_Line.Update()
    if self.isWait then
        self.StartShowTime = self.StartShowTime + Time.deltaTime;
        if self.StartShowTime >= JSYC_DataConfig.waitShowLineTime then
            self.StartShowTime = 0;
            self.isWait = false;
            self.ShowAll();
            --self.isShow = true;
            JSYCEntry.isRoll = false;
        end
    end
    if self.isShow then
        self.showTime = self.showTime + Time.deltaTime;
        if self.currentShow == 0 then
            if self.showTime >= JSYC_DataConfig.lineAllShowTime then
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
            if self.showTime >= JSYC_DataConfig.cyclePlayLineTime then
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
function JSYC_Line.ShowFree()
    self.showTable = {};
    self.showItemTable = {};
    self.showItemTable1 = {};
    local tempTable = {};
    local tempTable1 = {};
    for i = 1, JSYCEntry.RollContent.childCount do
        local childRoll = JSYCEntry.RollContent:GetChild(i - 1):GetComponent("ScrollRect").content;
        for j = 1, childRoll.childCount do
            if childRoll:GetChild(j - 1).gameObject.name == "Ball" then
                table.insert(tempTable, childRoll:GetChild(j - 1));
                table.insert(tempTable1, JSYCEntry.CSGroup:GetChild(i - 1):GetChild(0):GetChild(0):GetChild(j - 1));
            end
        end
    end
    table.insert(self.showItemTable, tempTable);
    table.insert(self.showItemTable1, tempTable1);
    table.insert(self.showTable, 9);
    self.ShowAll();
end
function JSYC_Line.ShowAll()
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
                go.transform:Find("Kuang/Image"):GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0, "Sprite", false);
                go.name = child.gameObject.name;
            end
            icon:GetComponent("Image").enabled = false;
        end
    end
    JSYCEntry.CSGroup.gameObject:SetActive(true);
end
function JSYC_Line.CloseAll()
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
function JSYC_Line.ShowSingle()
    --显示轮播
    for i = 1, #self.showItemTable[self.currentShow] do
        local icon = self.showItemTable[self.currentShow][i]:Find("Icon");
        icon:GetComponent("Image").enabled = false;
        if icon.childCount > 0 then
            icon:GetChild(0).gameObject:SetActive(true);
        end
    end
end
function JSYC_Line.CloseSingle()
    --关闭单个显示
    for i = 1, #self.showItemTable[self.currentShow] do
        local icon = self.showItemTable[self.currentShow][i]:Find("Icon");
        icon:GetComponent("Image").enabled = true;
        if icon.childCount > 0 then
            icon:GetChild(0).gameObject:SetActive(false);
        end
    end
end

function JSYC_Line.CollectEffect(obj)
    --回收动画
    if obj == nil then
        return ;
    end
    obj.transform:SetParent(JSYCEntry.effectPool);
    obj:SetActive(false);
end
function JSYC_Line.CreateEffect(effectname)
    --创建动画，先从对象池中获取
    local go = JSYCEntry.effectPool:Find(effectname);
    if go ~= nil then
        return go.gameObject;
    end
    go = JSYCEntry.effectList:Find(effectname);
    local _go = newObject(go);
    return _go;
end