YGBH_Line = {};

local self = YGBH_Line;

self.showTable = {};--显示连线索引列表
self.showCount = {};--显示元素个数列表
self.currentShow = 0;--当前显示索引
self.isShow = false;--可以展示
self.showTime = 0;--展示时间
self.showItemTable = {}--展示元素列表

self.StartShowTime = 0;--等待展示连线时间
self.isWait = false;
function YGBH_Line.Init()
    self.showTable = {};
    self.showCount = {};
    self.showItemTable = {};
    self.currentShow = 0;
    self.showTime = 0;
    self.StartShowTime = 0;
end
function YGBH_Line.Show()
    --YGBH_Audio.PlaySound(YGBH_Audio.SoundList.LINE);
    self.showTable = {};
    self.showCount = {};
    self.showItemTable = {};
    self.currentShow = 0;
    self.showTime = 0;
    self.StartShowTime = 0;
    for i = 1, #YGBHEntry.ResultData.LineTypeTable do
        if YGBHEntry.ResultData.LineTypeTable[i][1] ~= 0 then
            table.insert(self.showTable, i);
            local count = 0;
            for j = 1, #YGBHEntry.ResultData.LineTypeTable[i] do
                if YGBHEntry.ResultData.LineTypeTable[i][j] ~= 0 then
                    count = count + 1;
                end
            end
            table.insert(self.showCount, count);
        end
    end
    YGBHEntry.WinDesc.text = #self.showCount .. "line";
    self.isWait = true;
end
function YGBH_Line.Close()
    self.CloseAll();
    for i = 1, #self.showItemTable do
        for j = 1, #self.showItemTable[i] do
            self.showItemTable[i][j]:Find("Icon"):GetComponent("Image").enabled = true;
            if self.showItemTable[i][j]:Find("Icon").childCount > 0 then
                self.CollectEffect(self.showItemTable[i][j]:Find("Icon"):GetChild(0).gameObject);
            end
        end
    end
    for i = 1, #YGBHEntry.scatterList do
        if YGBHEntry.scatterList[i].childCount > 0 then
            YGBHEntry.scatterList[i]:GetComponent("Image").enabled = true;
            self.CollectEffect(YGBHEntry.scatterList[i]:GetChild(0).gameObject);
        end
    end
    self.showTable = {};
    self.showCount = {};
    self.isWait = false;
    self.isShow = false;
end
function YGBH_Line.Update()
    if self.isWait then
        self.StartShowTime = self.StartShowTime + Time.deltaTime;
        if self.StartShowTime >= YGBH_DataConfig.waitShowLineTime then
            self.StartShowTime = 0;
            self.isWait = false;
            self.ShowAll();
            --self.isShow = true;
        end
    end
    if self.isShow then
        self.showTime = self.showTime + Time.deltaTime;
        if self.currentShow == 0 then
            if self.showTime >= YGBH_DataConfig.lineAllShowTime then
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
            if self.showTime >= YGBH_DataConfig.cyclePlayLineTime then
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
function YGBH_Line.ShowAll()
    --显示总连线
    local spPosList = {};
    for i = 1, #self.showTable do
        local showlist = YGBH_DataConfig.Line[self.showTable[i]];--这是单条线对应位置
        local tempTable = {};--每组展示的元素集合
        for j = 1, self.showCount[i] do
            local index = showlist[j];
            local elem = YGBHEntry.ResultData.ImgTable[index];
            local column = math.ceil(index / 5);
            local raw = math.floor(index % 5);
            if raw == 0 then
                raw = 5;
            end
            local child = YGBHEntry.RollContent.transform:GetChild(raw - 1):GetComponent("ScrollRect").content:GetChild(column - 1);
            if YGBHEntry.hasNewSP then
                table.insert(spPosList, index);
            end
            local icon = child:Find("Icon");
            child:Find("Icon"):GetComponent("Image").enabled = false;
            if icon.childCount <= 0 then
                local go = self.CreateEffect(YGBH_DataConfig.GetEffectName(elem + 1));
                if go ~= nil then
                    go.transform:SetParent(child:Find("Icon"));
                    go.transform.localPosition = Vector3.New(0, 0, 0);
                    go.transform.localRotation = Quaternion.identity;
                    go.transform.localScale = Vector3.New(1.15, 1.15, 1.15);
                    go.gameObject:SetActive(true);
                    go.name = YGBH_DataConfig.EffectTable[elem+1];
                else
                    child:Find("Icon"):GetComponent("Image").enabled = true;
                end
            end
            table.insert(tempTable, child);
        end
        table.insert(self.showItemTable, tempTable);
    end
    if YGBHEntry.hasNewSP then
        for i = 1, #spPosList do
            local child = nil;
            if i >= YGBHEntry.dlLightGroup.childCount then
                child = newobject(YGBHEntry.dlLightGroup:GetChild(0).gameObject).gameObject;
                child.transform:SetParent(YGBHEntry.dlLightGroup);
            else
                child = YGBHEntry.dlLightGroup:GetChild(i - 1).gameObject;
            end
            child.transform.localScale = Vector3.New(1, 1, 1);
            local pos = YGBH_DataConfig.rollPoss[spPosList[i]];
            child.transform.localPosition = Vector3.New(pos[1], pos[2], pos[3]);
            child:SetActive(true);
            child.transform:DOLocalMove(Vector3.New(0, -106, 0), 0.3):OnComplete(function()
                child.transform:DOScale(Vector3.New(3, 3, 3), 0.5):OnComplete(function()
                    if i == 1 then
                        YGBHEntry.smallSPRealCount = 0;
                        for j = 1, #YGBHEntry.SceneData.smallGameTrack - 2 do
                            if YGBHEntry.SceneData.smallGameTrack[j] > 0 then
                                YGBHEntry.smallSPRealCount = YGBHEntry.smallSPRealCount + 1;
                            end
                        end
                        for j = 1, YGBHEntry.smallSPCount do
                            YGBHEntry.dlBtn.transform:GetChild(j - 1).gameObject:SetActive(true);
                        end
                        YGBHEntry.zpProgress.text = YGBHEntry.smallSPRealCount .. "/6";
                        for j = 1, #YGBHEntry.SceneData.smallGameTrack do
                            if YGBHEntry.SceneData.smallGameTrack[j] > 0 then
                                YGBHEntry.maskGroup:GetChild(j - 1):GetComponent("Image").enabled = false;
                                YGBHEntry.smallGoldGroup:GetChild(j - 1):GetComponent("TextMeshProUGUI").text = tostring(YGBHEntry.SceneData.smallGameTrack[j]);
                            else
                                YGBHEntry.maskGroup:GetChild(j - 1):GetComponent("Image").enabled = true;
                                YGBHEntry.smallGoldGroup:GetChild(j - 1):GetComponent("TextMeshProUGUI").text = "";
                            end
                        end
                        if YGBHEntry.smallSPCount >= 8 then
                            --碎片集满了，开启小游戏
                            YGBHEntry.FullSP = true;
                        end
                    end
                    child:SetActive(false);
                end);
            end);
        end
        YGBHEntry.hasNewSP = false;
    end
end
function YGBH_Line.CloseAll()
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
function YGBH_Line.ShowSingle()
    --显示轮播
    for i = 1, #self.showItemTable[self.currentShow] do
        local icon = self.showItemTable[self.currentShow][i]:Find("Icon");
        icon:GetComponent("Image").enabled = false;
        if icon.childCount > 0 then
            icon:GetChild(0).gameObject:SetActive(true);
        end
    end
end
function YGBH_Line.CloseSingle()
    --关闭单个显示
    for i = 1, #self.showItemTable[self.currentShow] do
        local icon = self.showItemTable[self.currentShow][i]:Find("Icon");
        icon:GetComponent("Image").enabled = true;
        if icon.childCount > 0 then
            icon:GetChild(0).gameObject:SetActive(false);
        end
    end
end

function YGBH_Line.CollectEffect(obj)
    --回收动画
    if obj == nil then
        return ;
    end
    obj.transform:SetParent(YGBHEntry.effectPool);
    obj:SetActive(false);
end
function YGBH_Line.CreateEffect(effectname)
    --创建动画，先从对象池中获取
    if effectname == nil then
        return nil;
    end
    local go = YGBHEntry.effectPool:Find(effectname);
    if go ~= nil then
        return go.gameObject;
    end
    go = YGBHEntry.effectList:Find(effectname);
    local _go = newObject(go);
    return _go;
end