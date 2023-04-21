
NoticeInfoSystem = { }
local self = NoticeInfoSystem;
local _LuaBeHaviour = nil;
local AllNotice = { };
local IsShowPanel = true;
-- ===========================================公告信息系统======================================
function NoticeInfoSystem.Open(isshow)
    if HallScenPanel.MidCloseBtn ~= nil then HallScenPanel.MidCloseBtn(); HallScenPanel.MidCloseBtn = nil end
    if self.NoticeInfoPanel == nil then
        if #AllNotice == 0 then IsShowPanel = false NoticeInfoSystem.SendNotice(); end
        if #AllNotice > 0 then IsShowPanel = true end
        self.NoticeInfoPanel = "obj";
        self.gameIsNotice = isshow
        --LoadAssetAsync("module02/hall_notice", "NoticePanel", self.OnCreacterChildPanel_Notice);
        self.OnCreacterChildPanel_Notice(HallScenPanel.Pool("NoticePanel"));
    end
end

-- 创建UI的子面板_通告面板
function NoticeInfoSystem.OnCreacterChildPanel_Notice(prefab)
    local go = prefab;
    go.transform:SetParent(HallScenPanel.Compose.transform);
    go.name = "NoticeInfoPanel";
    go.transform.localScale = Vector3.New(1, 1, 1);
    go.transform.localPosition = Vector3.New(900, 0, 0);
    self.NoticeInfoPanel = go;
    self.Bg = go.transform:Find("Bg").gameObject;
    self.Bg.transform.localScale = Vector3.New(1, 1, 1);
    HallScenPanel.LastPanel = self.NoticeInfoPanel
    HallScenPanel.SetXiaoGuo(self.NoticeInfoPanel)
    NoticeInfoSystem.Init(self.NoticeInfoPanel, HallScenPanel.LuaBehaviour);
    HallScenPanel.MidCloseBtn = self.NoticeInfoPanelCloseBtnOnClick
    HallScenPanel.SetBtnInter(true)
end

function NoticeInfoSystem.ShowInfo_Notice(prefab)
    local go = prefab
    go.transform:SetParent(self.NoticeInfoPanel.transform);
    go.name = "Bg";
    go.transform.localScale = Vector3.New(1, 1, 1);
    go.transform.localPosition = Vector3.New(0, 0, 0);
    self.Bg = go;
    NoticeInfoSystem.Init(self.NoticeInfoPanel, HallScenPanel.LuaBehaviour);
    HallScenPanel.SetBtnInter(true);
end

function NoticeInfoSystem.Init(obj, luaBehaviour)
    local t = obj.transform;
    -- 赋值自己
    self.NoticeInfoPanel = obj;
    -- 初始化面板，绑定点击事件
    self.NoticeInfoPanelCloseBtn = t:Find("CloseBtn").gameObject;
    self.NoticeMainBg = t:Find("Bg/NoticeMainBg").gameObject;
    self.NoticeMainInfo = t:Find("Bg/NoticeMainBg/MainInfo").gameObject;
    self.NoticePrebRed = t:Find("Bg/NoticeMainBg/NoticePrebRed").gameObject;
    self.NoticePrebNor = t:Find("Bg/NoticeMainBg/NoticePreb").gameObject;
    -- 绑定点击事件
    luaBehaviour:AddClick(self.NoticeInfoPanelCloseBtn, self.NoticeInfoPanelCloseBtnOnClick);
    HallScenPanel.MidCloseBtn = self.NoticeInfoPanelCloseBtnOnClick
    _LuaBeHaviour = luaBehaviour;
    self.NoticePrebRed:SetActive(false);
    self.NoticePrebNor:SetActive(false);
    if #AllNotice ~= 0 and IsShowPanel then
        IsShowPanel = false;
        error("未等服务器消息");
        self.CreatPrefeb();
    end
end
----隐藏和显示一个transform
function NoticeInfoSystem.ShowPanel(g)
    if (g.transform.localPosition.y > 100) then
        g.transform.localPosition = Vector3.New(0, 0, 0);
        --        --  效果测试代码
        --        local tweener = g.transform:DOScale(Vector3.New(1, 1, 1), 1);
        --        tweener:SetEase(DG.Tweening.Ease.OutBack);
    else
        g.transform.localPosition = Vector3.New(0, 1000, 0);
    end
end
-- 关闭公告面板
function NoticeInfoSystem.NoticeInfoPanelCloseBtnOnClick()
    self.ShowPanel(self.NoticeInfoPanel);
    -- 恢复被禁用的状态
    self.NoticeMainInfo = nil;
    destroy(self.NoticeInfoPanel);
    self.NoticeInfoPanel = nil;
    IsShowPanel = false;
    if gameIsOnline == false then
        -- 一键隐藏
        self.gameIsNotice = gameIsOnline;
    end
end
-- 点击公告
function NoticeInfoSystem.NoticeBtnOnClick(obj)
    local function selectlook()
        local buffer = ByteBuffer.New();
        Network.Send(MH.MDM_3D_ASSIST, MH.SUB_3D_CS_LOOK_ACTIVITY_CORE,buffer, gameSocketNumber.HallSocket);
    end
    selectlook();
    SCPlayerInfo._30LookNotice = 1;
    HallScenPanel.PlayeBtnMusic();
    local num = tonumber(obj.name)
    local AllLen =(87 * #AllNotice) + 380
    if AllLen < 829 then AllLen = 829 end;
    if obj.transform:Find("NoticeDetail").gameObject.activeSelf then
        for i = 0, #AllNotice - 1 do

            self.NoticeMainInfo.transform:GetChild(i).localPosition = Vector3.New(0,((AllLen / 2 -(i + 1) * 87)), 0);
            self.NoticeMainInfo.transform:GetChild(i):Find("NoticeDetail").gameObject:SetActive(false);
            self.NoticeMainInfo.transform:GetChild(i):Find("Look"):GetComponent("Button").interactable = true
        end
        return
    end
    for i = 0, num - 1 do

        self.NoticeMainInfo.transform:GetChild(i).localPosition = Vector3.New(0,((AllLen / 2 -(i + 1) * 87)), 0);
        self.NoticeMainInfo.transform:GetChild(i):Find("NoticeDetail").gameObject:SetActive(false);
        self.NoticeMainInfo.transform:GetChild(i):Find("Look"):GetComponent("Button").interactable = true
    end
    for i = num, #AllNotice - 1 do
        self.NoticeMainInfo.transform:GetChild(i).localPosition = Vector3.New(0,((AllLen / 2 -(i + 1) * 87)) -301, 0);
        self.NoticeMainInfo.transform:GetChild(i):Find("NoticeDetail").gameObject:SetActive(false);
        self.NoticeMainInfo.transform:GetChild(i):Find("Look"):GetComponent("Button").interactable = true
    end
    obj.transform:Find("Look"):GetComponent("Button").interactable = false
    obj.transform:Find("NoticeDetail").gameObject:SetActive(true);
end
-- 发送请求，获取公告信息s
function NoticeInfoSystem.SendNotice()
    local buffer = ByteBuffer.New();
    Network.Send(MH.MDM_3D_ASSIST, MH.SUB_3D_CS_ACTIVITY_CORE, buffer, gameSocketNumber.HallSocket);
end

-- 服务器发送消息开头
function NoticeInfoSystem.SCStartNotice()
    AllNotice = { };
end

-- 服务器发送来的数据
function NoticeInfoSystem.SCNotice(wSubID, buffer, wSize)
    if wSize ~= 0 then
        local v = GetS2CInfo(SC_ActivityCore, buffer);
        local count = 0;
        for i = 1, table.getn(AllNotice) do
            if AllNotice[i][1] == v[1] then count = count + 1; end
        end
        if count == 0 then table.insert(AllNotice, v) end
    end
end
-- 服务器消息发送完成
function NoticeInfoSystem.SCEndNotice()
    self.CreatPrefeb();
end
-- 创建Notice对象

function NoticeInfoSystem.CreatPrefeb()
    if IsNil(self.NoticeMainInfo) then
        local a = function()
            coroutine.wait(1)
            if not IsNil(self.NoticeMainInfo) then self.CreatPrefeb() end
            error("界面还未创建NoticeInfoSystem.CreatPrefeb");
        end
        coroutine.start(a);
        return;
    end
    IsShowPanel = false;
    self.NoticeMainInfo.transform.localPosition = Vector3.New(0, 0, 0);
    self.NoticeMainInfo:GetComponent('RectTransform').sizeDelta = Vector2.New(750, 829)
    if #(AllNotice) ~= 0 then
        local titel;
        local go;
        local AllNum = #(AllNotice);
        local AllLen =(87 * #AllNotice) + 380
        if AllLen < 829 then AllLen = 829 end;
        for i = 1, AllNum do
            if self.NoticeInfoPanel == nil then
                return;
            end
            local timerstr = nil;
            local isshownew = false;
            local titlestr = String.Empte;
            titel = string.split(AllNotice[i][3], ":");
            if #titel > 1 and titel[1] == "title" then
                titel = string.split(AllNotice[i][3], "_");
                for ti = 1, #titel do
                    local sont = string.split(titel[ti], ":");
                    if sont[1] == "title" then
                        local ssont = string.split(sont[2], "$");
                        titlestr = ssont[1];
                        for si = 2, #ssont do
                            if string.find(ssont[si], "c#") then
                                if tostring(string.split(ssont[si], "#")[2]) == "1" then
                                    go = newobject(self.NoticePrebRed);
                                else
                                    go = newobject(self.NoticePrebNor);
                                end
                            elseif ssont[si] == "n" then
                                isshownew = true;
                            end
                        end
                    elseif sont[1] == "time" then
                        if tostring(sont[2]) == "null" then
                            timerstr = " ";
                        else
                            timerstr = sont[2];
                        end
                    end
                end
            else
                titlestr = AllNotice[i][3];
                go = newobject(self.NoticePrebNor);
            end

            if self.NoticeInfoPanel ~= nil then
                go.transform:SetParent(self.NoticeMainInfo.transform);
                go.gameObject:SetActive(true);
                go.transform:Find("newtup").gameObject:SetActive(isshownew);
                go.transform:Find("NoticeDetail").gameObject:SetActive(false);
            else
                return;
            end
            go.transform.localScale = Vector3.one;
            go.transform.localPosition = Vector3.New(0,(AllLen / 2 - i * 87), 0);
            go.name = i;
            self.SetNoticePrefeb(go, i, timerstr, titlestr);

        end
    end
    local rectTransform = self.NoticeMainInfo:GetComponent('RectTransform');
    if ((87 * #AllNotice) + 301 > 829) then
        rectTransform.sizeDelta = Vector2.New(750,(87 * #AllNotice) + 301);
        self.NoticeMainInfo.transform.localPosition = Vector3.New(0,(829 -((87 * #AllNotice) + 301)) / 2, 0);
        error("(829-((87 * #AllNotice)+301))/2==================" ..(829 -((87 * #AllNotice) + 301)) / 2);
    end
end
-- 给公告赋值，按钮绑定事件
function NoticeInfoSystem.SetNoticePrefeb(go, i, timerstr, title)
    go.transform:Find("NoticeHead/Text"):GetComponent('Text').text = title;
    local infoobj = go.transform:Find("NoticeDetail/NoticeMainBg/Bg/NoticeDetailMainInfo/NoticeInfo").gameObject;
    go.transform:Find("NoticeDetail").gameObject:SetActive(false);
    local settext = infoobj:GetComponent('Text')
    settext.text = AllNotice[i][5];
    local h = settext.preferredHeight;
    if h < 300 then h = 290; end
    infoobj:GetComponent("RectTransform").sizeDelta = Vector2.New(720, h + 10)
    infoobj.transform.localPosition = Vector3.New(0,(300 -(h + 10)) / 2)
    _LuaBeHaviour:AddClick(go, self.NoticeBtnOnClick);
    -- local lookname = "Look" .. i;
    -- _LuaBeHaviour:AddClick(go.transform:Find("Look").gameObject, self.NoticeBtnOnClick);
    --    if timerstr ~= nil then
    --      --  go.transform:Find("NoticeTime"):GetComponent('Text').text = timerstr;
    --    else
    --        if AllNotice[i][14] - AllNotice[i][6] >= 3 then
    --           -- go.transform:Find("NoticeTime"):GetComponent('Text').text = "活动时间：长期有效";
    --        else
    --          --  go.transform:Find("NoticeTime"):GetComponent('Text').text = AllNotice[i][6] .. "年" .. AllNotice[i][7] .. "月" .. AllNotice[i][9] .. "日 至 " .. AllNotice[i][14] .. "年" .. AllNotice[i][15] .. "月" .. AllNotice[i][17] .. "日";
    --        end
    --    end
end