XMZZ_Line = {};

local self = XMZZ_Line;

self.showTable = {};--显示连线索引列表
self.showCount = {};--线个数
self.showItemTable = {};
self.wildTable = {};

function XMZZ_Line.Init()
    self.showTable = {};
    self.showCount = {};
    self.showItemTable = {};
    self.wildTable = {};
end
function XMZZ_Line.Show()
    self.showTable = {};
    self.showCount = {};
    self.showItemTable = {};
    for i = 1, #XMZZEntry.ResultData.LineTypeTable do
        local count = 0;
        for j = 1, #XMZZEntry.ResultData.LineTypeTable[i] do
            if XMZZEntry.ResultData.LineTypeTable[i][j] ~= 0 then
                count = count + 1;
            end
        end
        if count > 0 then
            table.insert(self.showTable, i);
            table.insert(self.showCount, count);
        end
    end
    self.ShowEffect();
end

function XMZZ_Line.ShowEffect()
    --显示总连线
    XMZZEntry.LineGroup.gameObject:SetActive(true);
    for i = 1, XMZZEntry.RollContent.childCount do
        XMZZEntry.RollContent:GetChild(i - 1):GetComponent("CanvasGroup").alpha = 0;
        XMZZEntry.CSGroup:GetChild(i - 1):GetComponent("CanvasGroup").alpha = 1;
    end
    for i = 1, #self.showTable do
        XMZZEntry.LineGroup:GetChild(self.showTable[i] - 1).gameObject:SetActive(true);
        local showlist = XMZZ_DataConfig.Line[self.showTable[i]];--这是单条线对应位置
        local tempTable = {};--每组展示的元素集合
        for j = 1, self.showCount[i] do
            local index = showlist[j];
            local elem = XMZZEntry.ResultData.ImgTable[index];
            local column = math.ceil(index / 5);
            local raw = math.floor(index % 5);
            if raw == 0 then
                raw = 5;
            end
            local child = XMZZEntry.RollContent.transform:GetChild(raw - 1):GetComponent("ScrollRect").content:GetChild(column - 1);
            local cschild = XMZZEntry.CSGroup:GetChild(raw - 1):GetChild(column - 1);
            cschild.name = child.name;
            local icon = child:Find("Icon");
            if icon.childCount <= 0 then
                local isCreate = false;
                local pos = Vector3.New(0, 0, 0);
                local iconIndex = elem;
                isCreate = true;
                if elem == 9 then
                    local haswild = false;
                    for k = 1, #self.wildTable do
                        if self.wildTable[k] == raw then
                            haswild = true;
                            break ;
                        end
                    end
                    if not haswild then
                        table.insert(self.wildTable, raw);
                    end
                    if child.name == "Item10_3" then
                        iconIndex = 12;
                    elseif child.name == "Item10_2" then
                        iconIndex = 11;
                    elseif child.name == "Item10_1" then
                        iconIndex = 10;
                    else
                        iconIndex = 9;
                    end
                else
                    isCreate = true;
                end
                if isCreate then
                    local go = self.CreateEffect(XMZZ_DataConfig.EffectTable[iconIndex + 1]);
                    go.transform:SetParent(cschild:Find("Icon"));
                    go.transform.localPosition = pos;
                    go.transform.localRotation = Quaternion.identity;
                    go.transform.localScale = Vector3.New(1, 1, 1);
                    go.gameObject:SetActive(true);
                    go.name = XMZZ_DataConfig.EffectTable[iconIndex + 1];
                end
            end
            cschild:Find("Icon"):GetComponent("Image").enabled = false;
            table.insert(tempTable, cschild);
        end
        table.insert(self.showItemTable, tempTable);
    end
    if XMZZEntry.isFreeGame then
        if XMZZEntry.freeType == 1 then
            for i = 1, XMZZEntry.CSGroup.childCount do
                if i ~= XMZZEntry.CurrentMoveLongIndex then
                    local child = XMZZEntry.CSGroup:GetChild(i - 1);
                    for j = 1, child.childCount do
                        child:GetChild(j - 1):Find("Icon"):GetComponent("Image").color = Color.gray;
                    end
                end
            end
        else
            for i = 1, XMZZEntry.CSGroup.childCount do
                if i < XMZZEntry.CurrentMoveLongIndex then
                    local child = XMZZEntry.CSGroup:GetChild(i - 1);
                    for j = 1, child.childCount do
                        child:GetChild(j - 1):Find("Icon"):GetComponent("Image").color = Color.gray;
                    end
                end
            end
        end
    end
    for i = 1, XMZZEntry.CSGroup.childCount do
        local child = XMZZEntry.CSGroup:GetChild(i - 1);
        for j = 1, child.childCount do
            if string.find(child:GetChild(j - 1).gameObject.name, "Item10_") ~= nil then
                child:GetChild(j - 1):Find("Icon"):GetComponent("Image").color = Color.white;
            else
                child:GetChild(j - 1):Find("Icon"):GetComponent("Image").color = Color.gray;
            end
        end
    end
end
function XMZZ_Line.Close()
    self.CloseAll();

    for i = 1, XMZZEntry.CSGroup.childCount do
        local child = XMZZEntry.CSGroup:GetChild(i - 1);
        for j = 1, child.childCount do
            child:GetChild(j - 1):Find("Icon"):GetComponent("Image").color = Color.white;
            child:GetChild(j - 1):Find("Icon"):GetComponent("Image").enabled = true;
        end
    end

    for i = 1, #self.showItemTable do
        for j = 1, #self.showItemTable[i] do
            if self.showItemTable[i][j]:Find("Icon").childCount > 0 then
                self.CollectEffect(self.showItemTable[i][j]:Find("Icon"):GetChild(0).gameObject);
            end
        end
    end
    for i = 1, XMZZEntry.RollContent.childCount do
        XMZZEntry.RollContent:GetChild(i - 1):GetComponent("CanvasGroup").alpha = 1;
        XMZZEntry.CSGroup:GetChild(i - 1):GetComponent("CanvasGroup").alpha = 0;
        if XMZZEntry.isFreeGame then
            if XMZZEntry.freeType == 1 then
                if i == XMZZEntry.CurrentMoveLongIndex then
                    XMZZEntry.RollContent:GetChild(i - 1):GetComponent("CanvasGroup").alpha = 0;
                    XMZZEntry.CSGroup:GetChild(i - 1):GetComponent("CanvasGroup").alpha = 1;
                end
            elseif XMZZEntry.freeType == 2 then
                if 5 - i < XMZZEntry.freeWildCount then
                    XMZZEntry.RollContent:GetChild(i - 1):GetComponent("CanvasGroup").alpha = 0;
                    XMZZEntry.CSGroup:GetChild(i - 1):GetComponent("CanvasGroup").alpha = 1;
                end
            end
        end
    end

    self.showTable = {};
    self.showCount = {};
end
function XMZZ_Line.CloseAll()
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
    for i = 1, XMZZEntry.LineGroup.childCount do
        XMZZEntry.LineGroup:GetChild(i - 1).gameObject:SetActive(false);
    end
end
function XMZZ_Line.CollectEffect(obj)
    --回收动画
    if obj == nil then
        return ;
    end
    obj.transform:SetParent(XMZZEntry.effectPool);
    obj:SetActive(false);
end
function XMZZ_Line.CreateEffect(effectname)
    --创建动画，先从对象池中获取
    local go = XMZZEntry.effectPool:Find(effectname);
    if go ~= nil then
        return go.gameObject;
    end
    go = XMZZEntry.effectList:Find(effectname);
    local _go = newObject(go);
    return _go;
end