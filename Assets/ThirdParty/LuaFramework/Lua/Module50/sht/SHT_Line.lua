SHT_Line = {};

local self = SHT_Line;

self.showTable = {};--显示连线索引列表
self.showCount = {};--显示元素个数列表
self.currentShow = 0;--当前显示索引
self.isShow = false;--可以展示
self.showTime = 0;--展示时间
self.showItemTable = {}--展示元素列表

self.StartShowTime = 0;--等待展示连线时间
self.isWait = false;
function SHT_Line.Init()
    self.showTable = {};
    self.showCount = {};
    self.showItemTable = {};
    self.currentShow = 0;
    self.showTime = 0;
    self.StartShowTime = 0;
end
function SHT_Line.Show()
    --SHT_Audio.PlaySound(SHT_Audio.SoundList.LINE);
    SHT_Audio.PlaySound(SHT_Audio.SoundList.win);

    self.showTable = {};
    self.showCount = {};
    self.showItemTable = {};
    self.currentShow = 0;
    self.showTime = 0;
    self.StartShowTime = 0;
    for i = 1, #SHTEntry.ResultData.LineTypeTable do
        if SHTEntry.ResultData.LineTypeTable[i][1] ~= 0 then
            table.insert(self.showTable, i);
            local count = 0;
            for j = 1, #SHTEntry.ResultData.LineTypeTable[i] do
                if SHTEntry.ResultData.LineTypeTable[i][j] ~= 0 then
                    count = count + 1;
                end
            end
            table.insert(self.showCount, count);
        end
    end
    SHTEntry.WinDesc.text = "中" .. #self.showCount .. "线";
    self.isWait = true;
end
function SHT_Line.Close()
    self.CloseAll();
    for i = 1, #self.showItemTable do
        for j = 1, #self.showItemTable[i] do
            self.showItemTable[i][j]:Find("Icon"):GetComponent("Image").enabled = true;
            if self.showItemTable[i][j]:Find("Icon").childCount > 0 then
                self.CollectEffect(self.showItemTable[i][j]:Find("Icon"):GetChild(0).gameObject);
            end
        end
    end
    for i = 1, #SHTEntry.scatterList do
        if SHTEntry.scatterList[i].childCount > 0 then
            SHTEntry.scatterList[i]:GetComponent("Image").enabled = true;
            self.CollectEffect(SHTEntry.scatterList[i]:GetChild(0).gameObject);
        end
    end

    for i = 1, #SHTEntry.FreeList do
        if SHTEntry.FreeList[i].childCount > 0 then
            SHTEntry.FreeList[i]:GetComponent("Image").enabled = true;
            self.CollectEffect(SHTEntry.FreeList[i]:GetChild(0).gameObject);
        end
    end

    self.showTable = {};
    self.showCount = {};
    self.isWait = false;
    self.isShow = false;
    logYellow("回收动画")
end
function SHT_Line.Update()
    if self.isWait then
        self.StartShowTime = self.StartShowTime + Time.deltaTime;
        if self.StartShowTime >= SHT_DataConfig.waitShowLineTime then
            self.StartShowTime = 0;
            self.isWait = false;
            self.ShowAll();
            --self.isShow = true;
        end
    end
    if self.isShow then
        self.showTime = self.showTime + Time.deltaTime;
        if self.currentShow == 0 then
            if self.showTime >= SHT_DataConfig.lineAllShowTime then
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
            if self.showTime >= SHT_DataConfig.cyclePlayLineTime then
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
function SHT_Line.ShowAll()
    --显示总连线
    local spPosList = {};
    local playTable={};
    for i = 1, #self.showTable do
        local showlist = SHT_DataConfig.Line[self.showTable[i]];--这是单条线对应位置
        local tempTable = {};--每组展示的元素集合
        for j = 1, self.showCount[i] do
            local index = showlist[j];
            local elem = SHTEntry.ResultData.ImgTable[index];
            local column = math.ceil(index / 5);
            local raw = math.floor(index % 5);
            if raw == 0 then
                raw = 5;
            end
            local child = SHTEntry.RollContent.transform:GetChild(raw - 1):GetComponent("ScrollRect").content:GetChild(column - 1);
            if SHTEntry.hasNewSP then
                table.insert(spPosList, index);
            end
            local icon = child:Find("Icon");
            child:Find("Icon"):GetComponent("Image").enabled = false;
            if icon.childCount <= 0 then
                local go = self.CreateEffect(SHT_DataConfig.GetEffectName(elem + 1));
                if go ~= nil then
                    go.transform:SetParent(child:Find("Icon"));
                    go.transform.localPosition = Vector3.New(0, 0, 0);
                    go.transform.localRotation = Quaternion.identity;
                    go.transform.localScale = Vector3.New(1.15, 1.15, 1.15);
                    go.gameObject:SetActive(true);
                    go.name = SHT_DataConfig.EffectTable[elem+1];
                else
                    child:Find("Icon"):GetComponent("Image").enabled = true;
                end
            end

            if #playTable < 1 then
                if elem ==3 or elem ==4 or elem ==5 or elem ==6 or elem ==7 or elem ==8 or elem ==9  then
                    table.insert(playTable,1,elem)   
                end
            end
            table.insert(tempTable, child);
        end
        table.insert(self.showItemTable, tempTable);
    end
    for i=1,#playTable do
        if playTable[i] ==3 then
            SHT_Audio.PlaySound(SHT_Audio.SoundList.eWatch);
        elseif playTable[i]==4 then
            SHT_Audio.PlaySound(SHT_Audio.SoundList.eSound);
        elseif playTable[i]==5 then
            SHT_Audio.PlaySound(SHT_Audio.SoundList.eManPowerCar);
        elseif playTable[i]==6 then
            SHT_Audio.PlaySound(SHT_Audio.SoundList.eWoman);
        elseif playTable[i]==7 then
            SHT_Audio.PlaySound(SHT_Audio.SoundList.eMan); 
        elseif playTable[i]==8 then
            SHT_Audio.PlaySound(SHT_Audio.SoundList.eWild); 
        elseif playTable[i]==9 then
            SHT_Audio.PlaySound(SHT_Audio.SoundList.EGold); 
        end
    end
end
function SHT_Line.CloseAll()
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
function SHT_Line.ShowSingle()
    --显示轮播
    for i = 1, #self.showItemTable[self.currentShow] do
        local icon = self.showItemTable[self.currentShow][i]:Find("Icon");
        icon:GetComponent("Image").enabled = false;
        if icon.childCount > 0 then
            icon:GetChild(0).gameObject:SetActive(true);
        end
    end
end
function SHT_Line.CloseSingle()
    --关闭单个显示
    for i = 1, #self.showItemTable[self.currentShow] do
        local icon = self.showItemTable[self.currentShow][i]:Find("Icon");
        icon:GetComponent("Image").enabled = true;
        if icon.childCount > 0 then
            icon:GetChild(0).gameObject:SetActive(false);
        end
    end
end

function SHT_Line.CollectEffect(obj)
    --回收动画
    if obj == nil then
        return ;
    end
    obj.transform:SetParent(SHTEntry.effectPool);
    obj:SetActive(false);
end
function SHT_Line.CreateEffect(effectname)
    --创建动画，先从对象池中获取
    if effectname == nil then
        return nil;
    end
    local go = SHTEntry.effectPool:Find(effectname);
    if go ~= nil then
        return go.gameObject;
    end
    go = SHTEntry.effectList:Find(effectname);
    local _go = newObject(go);
    return _go;
end