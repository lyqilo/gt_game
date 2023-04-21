MCDZZ_Line = {};

local self = MCDZZ_Line;

self.showTable = {};--显示连线索引列表
self.showCount = {};--显示元素个数列表
self.currentShow = 0;--当前显示索引
self.isShow = false;--可以展示
self.showTime = 0;--展示时间
self.showItemTable = {}--展示元素列表

self.StartShowTime = 0;--等待展示连线时间
self.isWait = false;
local zjTable={}

function MCDZZ_Line.Init()
    self.showTable = {};
    self.showCount = {};
    self.showItemTable = {};
    self.currentShow = 0;
    self.showTime = 0;
    self.StartShowTime = 0;
end
function MCDZZ_Line.Show()
    zjTable={}
    MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.LINE);
    self.showTable = {};
    self.showCount = {};
    self.showItemTable = {};
    self.currentShow = 0;
    self.showTime = 0;
    self.StartShowTime = 0;
    for i = 1, #MCDZZEntry.ResultData.LineTypeTable do
        if MCDZZEntry.ResultData.LineTypeTable[i][1] ~= 0 then
            table.insert(self.showTable, i);
            local count = 0;
            for j = 1, #MCDZZEntry.ResultData.LineTypeTable[i] do
                if MCDZZEntry.ResultData.LineTypeTable[i][j] ~= 0 then
                    count = count + 1;
                end
            end
            table.insert(self.showCount, count);
        end
    end
    MCDZZEntry.TipText.text = "中" .. #self.showCount .. "线";
    self.isWait = true;
end
function MCDZZ_Line.Close()
    self.CloseAll();
    for i = 1, #self.showItemTable do
        for j = 1, #self.showItemTable[i] do
            self.showItemTable[i][j]:Find("Icon"):GetComponent("Image").enabled = true;
            if self.showItemTable[i][j]:Find("Icon").childCount > 0 then
                self.CollectEffect(self.showItemTable[i][j]:Find("Icon"):GetChild(0).gameObject);
            end
        end
    end

    for i = 1, #MCDZZEntry.scatterList do
        if MCDZZEntry.scatterList[i].childCount > 0 then
            MCDZZEntry.scatterList[i]:GetComponent("Image").enabled = true;
            self.CollectEffect(MCDZZEntry.scatterList[i]:GetChild(0).gameObject);
        end
    end

    self.showTable = {};
    self.showCount = {};
    self.isWait = false;
    self.isShow = false;
end
function MCDZZ_Line.Update()
    if self.isWait then
        self.StartShowTime = self.StartShowTime + Time.deltaTime;
        if self.StartShowTime >= MCDZZ_DataConfig.waitShowLineTime then
            self.StartShowTime = 0;
            self.isWait = false;
            self.ShowAll();
            --self.isShow = true;
        end
    end
    if self.isShow then
        self.showTime = self.showTime + Time.deltaTime;
        if self.currentShow == 0 then
            if self.showTime >= MCDZZ_DataConfig.lineAllShowTime then
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
            if self.showTime >= MCDZZ_DataConfig.cyclePlayLineTime then
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
function MCDZZ_Line.ShowAll()
    --显示总连线
    local spPosList = {};
    logTable(self.showTable)
    for i = 1, #self.showTable do
        local showlist = MCDZZ_DataConfig.Line[self.showTable[i]];--这是单条线对应位置
        local tempTable = {};--每组展示的元素集合
        local isadd=true
        local isdy11=1
        for j = 1, self.showCount[i] do
            local index = showlist[j];
            local elem = MCDZZEntry.ResultData.ImgTable[index];
            local column = math.ceil(index / 5);
            local raw = math.floor(index % 5);
            if raw == 0 then
                raw = 5;
            end
            local child = MCDZZEntry.RollContent.transform:GetChild(raw - 1):GetComponent("ScrollRect").content:GetChild(column - 1);
            local icon = child:Find("Icon");
            child:Find("Icon"):GetComponent("Image").enabled = false;

            if icon.childCount <= 0 then
                local go = self.CreateEffect(MCDZZ_DataConfig.GetEffectName(elem + 1));
                if go ~= nil then
                    go.transform:SetParent(child:Find("Icon"));
                    go.transform.localPosition = Vector3.New(0, 0, 0);
                    go.transform.localRotation = Quaternion.identity;
                    go.transform.localScale = Vector3.New(1, 1, 1);
                    go.gameObject:SetActive(true);
                    go.name = MCDZZ_DataConfig.EffectTable[elem+1];
                else
                    child:Find("Icon"):GetComponent("Image").enabled = true;
                end
            end
            table.insert(tempTable, child);
        end  
        table.insert(self.showItemTable, tempTable);
    end
    for i=1,#MCDZZEntry.ResultData.ZJTABLE do
        if MCDZZEntry.ResultData.ZJTABLE[i] ==10 then
            MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.gou2);
        elseif MCDZZEntry.ResultData.ZJTABLE[i]==9 then
            MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.gou1);
        elseif MCDZZEntry.ResultData.ZJTABLE[i]==7 then
            MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.gou3);
        elseif MCDZZEntry.ResultData.ZJTABLE[i]==6 then
            MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.mao2);
        elseif MCDZZEntry.ResultData.ZJTABLE[i]==8 then
            MCDZZ_Audio.PlaySound(MCDZZ_Audio.SoundList.mao1); 
        end
    end
end

function MCDZZ_Line:DeleteEqualElement(table)
    local exist = {}
    --把相同的元素覆盖掉
    for k,v in pairs(table) do
        exist[v] = true
    end
    --重新排序表
    local newTable = {}
    for k,v in pairs(exist) do
        table.insert(newTable, v)
    end
    return newTable
end

function MCDZZ_Line.CloseAll()
    --关闭总显示
    for i = 1, #self.showTable do
        for j = 1, #self.showItemTable[i] do
            local icon = self.showItemTable[i][j]:Find("Icon");
            icon:GetComponent("Image").enabled = true;
            if icon.childCount > 0 then
                icon:GetChild(0).gameObject:SetActive(false);
            end
        end
    end

end
function MCDZZ_Line.ShowSingle()
    --显示轮播
    for i = 1, #self.showItemTable[self.currentShow] do
        local icon = self.showItemTable[self.currentShow][i]:Find("Icon");
        icon:GetComponent("Image").enabled = false;
        if icon.childCount > 0 then
            icon:GetChild(0).gameObject:SetActive(true);
        end
    end
end
function MCDZZ_Line.CloseSingle()
    --关闭单个显示
    for i = 1, #self.showItemTable[self.currentShow] do
        local icon = self.showItemTable[self.currentShow][i]:Find("Icon");
        icon:GetComponent("Image").enabled = true;
        if icon.childCount > 0 then
            icon:GetChild(0).gameObject:SetActive(false);
        end
    end
end

function MCDZZ_Line.CollectEffect(obj)
    --回收动画
    if obj == nil then
        return ;
    end
    obj.transform:SetParent(MCDZZEntry.effectPool);
    obj:SetActive(false);
end
function MCDZZ_Line.CreateEffect(effectname)
    --创建动画，先从对象池中获取
    if effectname == nil then
        return nil;
    end
    local go = MCDZZEntry.effectPool:Find(effectname);
    if go ~= nil then
        return go.gameObject;
    end
    go = MCDZZEntry.effectList:Find(effectname);
    local _go = newObject(go);
    return _go;
end