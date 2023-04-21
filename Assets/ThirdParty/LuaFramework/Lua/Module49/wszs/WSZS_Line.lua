WSZS_Line = {};

local self = WSZS_Line;

self.showTable = {};--显示连线索引列表
self.showCount = {};--显示元素个数列表
self.currentShow = 0;--当前显示索引
self.isShow = false;--可以展示
self.showTime = 0;--展示时间
self.showItemTable = {}--展示元素列表

self.showMJTable = {}--展示免费的元素列表
self.showWSTable = {}--展示免费的元素列表
self.StartShowTime = 0;--等待展示连线时间

self.effectTable = {};
self.isWait = false;
function WSZS_Line.Init()
    self.showTable = {};
    self.showCount = {};
    self.showItemTable = {};
    self.effectTable = {};
    self.currentShow = 0;
    self.showTime = 0;
    self.StartShowTime = 0;
end
function WSZS_Line.Show()
    self.showTable = {};
    self.showCount = {};
    self.showItemTable = {};
    self.showMJTable = {};
    self.showWSTable = {};
    WSZS_Free.MJTable = {};
    WSZS_Free.WSTable = {};
    self.effectTable = {};
    self.currentShow = 0;
    self.showTime = 0;
    self.StartShowTime = 0;
    for i = 1, #WSZSEntry.ResultData.LineTypeTable do
        if WSZSEntry.ResultData.LineTypeTable[i] ~= 0 then
            table.insert(self.showTable, i);
        end
    end

    self.isWait = true;
end
function WSZS_Line.CollectFreeMJ()
    self.showMJTable = {};
    self.showWSTable = {};
    WSZS_Free.MJTable = {};
    WSZS_Free.WSTable = {};
    local hasmianju = WSZSEntry.ResultData.mianjuCount[5] > 0;
    log("现在有面具：" .. tostring(hasmianju));
    for i = 1, #WSZS_DataConfig.AnimSort do
        if hasmianju then
            local index = WSZS_DataConfig.AnimSort[i];
            if WSZSEntry.ResultData.ImgTable[index] >= 6 and WSZSEntry.ResultData.ImgTable[index] <= 9 then
                table.insert(self.showMJTable, index);
            elseif WSZSEntry.ResultData.ImgTable[index] == 10 then
                table.insert(self.showWSTable, index);
            end
        end
    end
end
function WSZS_Line.Close()
    self.CloseAll();
    for i = 1, WSZSEntry.RollContent.childCount do
        local child = WSZSEntry.RollContent:GetChild(i - 1):GetComponent("ScrollRect").content;
        for j = 1, child.childCount do
            child:GetChild(j - 1):Find("Icon"):GetComponent("Image").color = Color.white;
        end
    end

    WSZSEntry.CSGroup.gameObject:SetActive(false);
    self.showTable = {};
    self.showCount = {};
    self.isWait = false;
    self.isShow = false;
end
function WSZS_Line.Update()
    if self.isWait then
        self.StartShowTime = self.StartShowTime + Time.deltaTime;
        if self.StartShowTime >= WSZS_DataConfig.waitShowLineTime then
            self.StartShowTime = 0;
            self.isWait = false;
            self.ShowAll();
            --self.isShow = true;
            --WSZSEntry.isRoll = false;
        end
    end
    if self.isShow then
        self.showTime = self.showTime + Time.deltaTime;
        if self.currentShow == 0 then
            if self.showTime >= WSZS_DataConfig.lineAllShowTime then
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
            if self.showTime >= WSZS_DataConfig.cyclePlayLineTime then
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
function WSZS_Line.ShowFree()
    self.showTable = {};
    self.showItemTable = {};
    local tempTable = {};
    local tempTable1 = {};
    for i = 1, WSZSEntry.RollContent.childCount do
        local childRoll = WSZSEntry.RollContent:GetChild(i - 1):GetComponent("ScrollRect").content;
        for j = 1, childRoll.childCount do
            if childRoll:GetChild(j - 1).gameObject.name == "Ball" then
                table.insert(tempTable, childRoll:GetChild(j - 1));
                table.insert(tempTable1, WSZSEntry.CSGroup:GetChild(i - 1):GetChild(j - 1));
            end
        end
    end
    table.insert(self.showItemTable, tempTable);
    table.insert(self.showTable, 9);
    self.ShowAll();
end
function WSZS_Line.ShowAll()
    --显示总连线
    for i = 1, #self.showTable do
        local index = self.showTable[i];
        local elem = index;
        local cloumn = math.floor((elem - 1) / 5);
        local raw = math.floor((elem - 1) % 5);
        local parent = WSZSEntry.RollContent:GetChild(raw):GetComponent("ScrollRect").content;
        local child = parent:GetChild(cloumn);
        local icon = child:Find("Icon");
        if icon:Find("Effect") == nil then
            local go = self.CreateEffect(child.gameObject.name);
            go.transform:SetParent(icon);
            go.transform.localPosition = Vector3.New(0, 0, 0);
            go.transform.localRotation = Quaternion.identity;
            go.transform.localScale = Vector3.New(1, 1, 1);
            go.gameObject:SetActive(true);
            go.name = "Effect";
        end
        table.insert(self.effectTable, icon);
        icon:GetComponent("Image").enabled = false;
    end
    for i = 1, WSZSEntry.RollContent.childCount do
        local child = WSZSEntry.RollContent:GetChild(i - 1):GetComponent("ScrollRect").content;
        for j = 1, child.childCount do
            local icon = child:GetChild(j - 1):Find("Icon");
            icon:GetComponent("Image").color = Color.gray;
        end
    end
    --WSZSEntry.CSGroup.gameObject:SetActive(true);
end
function WSZS_Line.FreeShowAll()
    for i = 1, #self.showMJTable do
        local index = self.showMJTable[i];
        local elem = index;
        local cloumn = math.floor((elem - 1) / 5);
        local raw = math.floor((elem - 1) % 5);
        local parent = WSZSEntry.RollContent:GetChild(raw):GetComponent("ScrollRect").content;
        local child = parent:GetChild(cloumn);
        local icon = child:Find("Icon");
        if icon:Find("Effect") == nil then
            local go = self.CreateEffect(child.gameObject.name);
            go.transform:SetParent(icon);
            go.transform.localPosition = Vector3.New(0, 0, 0);
            go.transform.localRotation = Quaternion.identity;
            go.transform.localScale = Vector3.New(1, 1, 1);
            go.gameObject:SetActive(true);
            go.transform:GetComponent("Animator").enabled = false;
            go.name = "Effect";
            table.insert(self.effectTable, icon);
        else
            icon:Find("Effect"):GetComponent("Animator").enabled = false;
        end
        table.insert(WSZS_Free.MJTable, icon);
        icon:GetComponent("Image").enabled = false;
    end
    for i = 1, #self.showWSTable do
        local index = self.showWSTable[i];
        local elem = index;
        local cloumn = math.floor((elem - 1) / 5);
        local raw = math.floor((elem - 1) % 5);
        local parent = WSZSEntry.RollContent:GetChild(raw):GetComponent("ScrollRect").content;
        local child = parent:GetChild(cloumn);
        local icon = child:Find("Icon");
        if icon:Find("Effect") == nil then
            local go = self.CreateEffect(child.gameObject.name);
            go.transform:SetParent(icon);
            go.transform.localPosition = Vector3.New(0, 0, 0);
            go.transform.localRotation = Quaternion.identity;
            go.transform.localScale = Vector3.New(1, 1, 1);
            go.gameObject:SetActive(true);
            go.transform:GetComponent("Animator").enabled = false;
            go.name = "Effect";
            table.insert(self.effectTable, icon);
        else
            icon:Find("Effect"):GetComponent("Animator").enabled = false;
        end
        table.insert(WSZS_Free.WSTable, icon);
        icon:GetComponent("Image").enabled = false;
    end    
end
function WSZS_Line.CloseAll()
    --关闭总显示
    for i = 1, #self.effectTable do
        self.effectTable[i]:GetComponent("Image").enabled = true;
        if self.effectTable[i]:Find("Effect") ~= nil then
            self.CollectEffect(self.effectTable[i]:Find("Effect").gameObject);
        end
    end
end
function WSZS_Line.ShowSingle()
    --显示轮播
    for i = 1, #self.showItemTable[self.currentShow] do
        local icon = self.showItemTable[self.currentShow][i]:Find("Icon");
        icon:GetComponent("Image").enabled = false;
        if icon.childCount > 0 then
            icon:GetChild(0).gameObject:SetActive(true);
        end
    end
end
function WSZS_Line.CloseSingle()
    --关闭单个显示
    for i = 1, #self.showItemTable[self.currentShow] do
        local icon = self.showItemTable[self.currentShow][i]:Find("Icon");
        icon:GetComponent("Image").enabled = true;
        if icon.childCount > 0 then
            icon:GetChild(0).gameObject:SetActive(false);
        end
    end
end

function WSZS_Line.CollectEffect(obj)
    --回收动画
    if obj == nil then
        return ;
    end
    obj.transform:SetParent(WSZSEntry.effectPool);
    obj:SetActive(false);
end
function WSZS_Line.CreateEffect(effectname)
    --创建动画，先从对象池中获取
    local go = WSZSEntry.effectPool:Find(effectname);
    if go ~= nil then
        return go.gameObject;
    end
    go = WSZSEntry.effectList:Find(effectname);
    local _go = newObject(go);
    return _go;
end