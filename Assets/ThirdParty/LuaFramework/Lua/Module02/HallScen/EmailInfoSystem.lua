--[[require "Common/define"
require "Data/gameData"]]

EmailInfoSystem = { }
local self = EmailInfoSystem;
local _LuaBeHaviour = nil;
local AllNotice = { };
local IsShowPanel = true;
-- ===========================================公告信息系统======================================
function EmailInfoSystem.Open(isshow)
    if HallScenPanel.MidCloseBtn ~= nil then HallScenPanel.MidCloseBtn(); HallScenPanel.MidCloseBtn = nil end
    if self.EmailPanel == nil then
        EmailInfoSystem.SendNotice();
        self.EmailPanel = "obj";
        self.gameIsNotice = isshow
        -- LoadAssetAsync("module02/hall_email", "EmailPanel", self.OnCreacterChildPanel_Notice, true, true);
        self.OnCreacterChildPanel_Notice(HallScenPanel.Pool("EmailPanel"));
    end
end

-- 创建UI的子面板_通告面板
function EmailInfoSystem.OnCreacterChildPanel_Notice(prefab)
    -- local go =newobject(prefab);
    local go = prefab;
    go.transform:SetParent(HallScenPanel.Compose.transform);
    go.name = "EmailPanel";
    go.transform.localScale = Vector3.New(1, 1, 1);
    go.transform.localPosition = Vector3.New(900, 0, 0);
    self.EmailPanel = go;
    self.Bg = go.transform:Find("Bg").gameObject;
    self.Bg.transform.localScale = Vector3.New(1, 1, 1);
    HallScenPanel.LastPanel = self.EmailPanel
    HallScenPanel.SetXiaoGuo(self.EmailPanel)
    EmailInfoSystem.Init(self.EmailPanel, HallScenPanel.LuaBehaviour);
    HallScenPanel.MidCloseBtn = self.EmailPanelCloseBtnOnClick
    HallScenPanel.SetBtnInter(true);
end

function EmailInfoSystem.ShowInfo_Notice(prefab)
    local go = prefab
    go.transform:SetParent(self.EmailPanel.transform);
    go.name = "Bg";
    go.transform.localScale = Vector3.New(1, 1, 1);
    go.transform.localPosition = Vector3.New(0, 0, 0);
    self.Bg = go;
    EmailInfoSystem.Init(self.EmailPanel, HallScenPanel.LuaBehaviour);
end

function EmailInfoSystem.Init(obj, luaBehaviour)
    local t = obj.transform;
    -- 赋值自己
    self.EmailPanel = obj;
    -- 初始化面板，绑定点击事件
    self.EmailPanelCloseBtn = t:Find("CloseBtn").gameObject;
    self.NoticeMainBg = t:Find("Bg/NoticeMainBg").gameObject;
    self.NoticeMainInfo = t:Find("Bg/NoticeMainBg/MainInfo").gameObject;
    self.NoticePrebRed = t:Find("Bg/NoticeMainBg/NoticePrebRed").gameObject;
    self.NoticePrebNor = t:Find("Bg/NoticeMainBg/NoticePreb").gameObject;
    self.TishiText = t:Find("Text").gameObject;
    -- 绑定点击事件
    luaBehaviour:AddClick(self.EmailPanelCloseBtn, self.EmailPanelCloseBtnOnClick);
    _LuaBeHaviour = luaBehaviour;
    self.NoticePrebRed:SetActive(false);
    self.NoticePrebNor:SetActive(false);
    --    if #AllNotice ~= 0 and IsShowPanel then
    --        IsShowPanel = false;
    --        self.TishiText.transform:GetComponent("Text").text = "通过邮件领取的金币将会添加至银行存款中"
    --        self.TishiText.transform.localPosition = Vector3.New(0, 355, 0);
    --        error("未等服务器消息");
    --        self.CreatPrefeb();
    --    end
    if #AllNotice == 0 then
        self.TishiText:SetActive(true);
        self.TishiText.transform:GetComponent("Text").text = "当前暂无邮件信息"
        self.TishiText.transform.localPosition = Vector3.New(0, 0, 0);
    end
end
----隐藏和显示一个transform
function EmailInfoSystem.ShowPanel(g)
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
function EmailInfoSystem.EmailPanelCloseBtnOnClick()
    HallScenPanel.PlayeBtnMusic()

    self.ShowPanel(self.EmailPanel);
    -- 恢复被禁用的状态
    self.NoticeMainInfo = nil;
    destroy(self.EmailPanel);
    self.EmailPanel = nil;
    IsShowPanel = false;
    if gameIsOnline == false then
        -- 一键隐藏
        self.gameIsNotice = gameIsOnline;
    end
end
-- 点击公告
function EmailInfoSystem.NoticeBtnOnClick(obj)
    local function selectlook()
        local buffer = ByteBuffer.New();
        Network.Send(MH.MDM_3D_ASSIST, MH.SUB_3D_CS_LOOK_ACTIVITY_CORE, buffer, gameSocketNumber.HallSocket);
    end
    selectlook();
    SCPlayerInfo._31LookEmail = 1;
    HallScenPanel.PlayeBtnMusic();
    local num = tonumber(obj.name)
    if num == nil then num = tonumber(obj.transform.parent.gameObject.name); obj = obj.transform.parent.gameObject; end
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

    local function seedlook()
        local buffer = ByteBuffer.New();
        self.nowbtnnum = num;
        buffer:WriteLong(AllNotice[num][1]);
        error("发送领取");
        Network.Send(MH.MDM_3D_ASSIST, MH.SUB_3D_CS_ACTIVITY_MAIL_GET, buffer, gameSocketNumber.HallSocket);
        error("发送领取");
    end
    if AllNotice[num][6] == 0 and AllNotice[num][23] == 0 then
        seedlook();
    end
end
-- 发送请求，获取公告信息s
function EmailInfoSystem.SendNotice()
    error("-- 发送请求，获取公告信息s");
    local buffer = ByteBuffer.New();
    buffer:WriteUInt32(0);
    buffer:WriteUInt32(10);
    Network.Send(MH.MDM_3D_ASSIST, MH.SUB_3D_CS_ACTIVITY_MAIL, buffer, gameSocketNumber.HallSocket);
end

-- 服务器发送消息开头
function EmailInfoSystem.SCStartNotice()
   -- error("服务器发送消息开头");
    AllNotice = { };
end

-- 服务器发送来的数据
function EmailInfoSystem.SCNotice(wSubID, buffer, wSize)
   -- error("EmailInfoSystem.SCNotice(wSubID, buffer, wSize)");
    local v = GetS2CInfo(SC_ActivityMail, buffer);
    table.insert(AllNotice, v)

end
-- 服务器消息发送完成
function EmailInfoSystem.SCEndNotice()
    log("服务器消息发送完成" .. #AllNotice);
    if #AllNotice == 0 then
        self.TishiText:SetActive(true); return
    end;
    self.TishiText.transform:GetComponent("Text").text = "通过邮件领取的金币将会添加至银行存款中"
    self.TishiText.transform.localPosition = Vector3.New(0, 353, 0);
    self.CreatPrefeb();
end
-- 创建Notice对象


function EmailInfoSystem.CreatPrefeb()
    if IsNil(self.NoticeMainInfo) then
        local a = function()
            coroutine.wait(1) self.CreatPrefeb()
            error("EmailInfoSystem.CreatPrefeb界面还未创建");
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
            if self.EmailPanel == nil then
                return;
            end
            if i <= self.NoticeMainInfo.transform.childCount then
                go = self.NoticeMainInfo.transform:GetChild(i - 1).gameObject;
            else
                go = newobject(self.NoticePrebNor);
                go.transform:SetParent(self.NoticeMainInfo.transform);
                _LuaBeHaviour:AddClick(go, self.NoticeBtnOnClick);
                _LuaBeHaviour:AddClick(go.transform:Find("NoticeDetail/NoticeMainBg/Bg/NoticeDetailMainInfo/GetBtn").gameObject, self.GetBtnOnClick)
                _LuaBeHaviour:AddClick(go.transform:Find("WaitLook").gameObject, self.NoticeBtnOnClick)
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
            end

            if self.EmailPanel ~= nil then
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
function EmailInfoSystem.SetNoticePrefeb(go, i, timerstr, title)
    go.transform:Find("NoticeHead/Text"):GetComponent('Text').text = title;
    local infoobj = go.transform:Find("NoticeDetail/NoticeMainBg/Bg/NoticeDetailMainInfo/NoticeInfo").gameObject;
    local infoobj_father = go.transform:Find("NoticeDetail/NoticeMainBg/Bg/NoticeDetailMainInfo").gameObject;
    go.transform:Find("NoticeDetail").gameObject:SetActive(false);

    if AllNotice[i][6] == 0 then
        infoobj:GetComponent('Text').text = AllNotice[i][5];
    else
        infoobj:GetComponent('Text').text = AllNotice[i][5] .. "\n领取金币数量：" .. AllNotice[i][6];
    end
    local h = infoobj:GetComponent('Text').preferredHeight;
    if h < 240 then h = 230; end
    infoobj:GetComponent("RectTransform").sizeDelta = Vector2.New(720, h + 10)
    infoobj.transform.localPosition = Vector3.New(0, 30, 0)
    infoobj_father:GetComponent("RectTransform").sizeDelta = Vector2.New(720, h + 70)
    infoobj_father.transform.localPosition = Vector3.New(0,(300 -(h + 70)) / 2, 0)
    go.name = i;
    local getbtn = infoobj_father.transform:GetChild(1).gameObject
    getbtn.name = "GetBtn_" .. i;
    getbtn.transform.localPosition = Vector3.New(0, 30 -(h + 70) / 2, 0);
    if AllNotice[i][6] == 0 then
        getbtn:SetActive(false);
    else
        getbtn:SetActive(true);
    end
    if AllNotice[i][23] == 0 then
        getbtn:GetComponent("Button").interactable = true
        go.transform:Find("WaitLook").gameObject:SetActive(true);
    else
        getbtn:GetComponent("Button").interactable = false
        go.transform:Find("WaitLook").gameObject:SetActive(false);
    end
end
self.nowbtnnum = 0;
function EmailInfoSystem.GetBtnOnClick(obj)
    obj.transform:GetComponent("Button").interactable = false
    local data = string.split(obj.name, "_")
    local num = tonumber(data[2])
    local buffer = ByteBuffer.New();
    self.nowbtnnum = num;
    buffer:WriteLong(AllNotice[num][1]);
    error("发送领取");
    Network.Send(MH.MDM_3D_ASSIST, MH.SUB_3D_CS_ACTIVITY_MAIL_GET, buffer, gameSocketNumber.HallSocket);
    error("发送领取");
end

-- 服务器返回是否领取成功
function EmailInfoSystem.SCGetBtnOnClick(buffer, wSize)
    error("服务器返回是否领取成功");
    if SCPlayerInfo._31LookEmail == 0 then
        local function selectlook()
            local buffer = ByteBuffer.New();
            Network.Send(MH.MDM_3D_ASSIST, MH.SUB_3D_CS_LOOK_ACTIVITY_CORE, buffer, gameSocketNumber.HallSocket);
        end
        selectlook();
        SCPlayerInfo._31LookEmail = 1;
    end
    AllNotice[self.nowbtnnum][23] = 1;
    local go = self.NoticeMainInfo.transform:GetChild(self.nowbtnnum - 1).gameObject;
    go.transform:Find("WaitLook").gameObject:SetActive(false);
    if AllNotice[self.nowbtnnum][6] ~= 0 then
        if wSize == 0 then
            MessageBox.CreatGeneralTipsPanel("领取成功,已存入银行"); return
        else
            MessageBox.CreatGeneralTipsPanel(buffer:ReadString(wSize))
        end
    end
    HallScenPanel.EmialSetTishi:SetActive(false);
    HallScenPanel.EmialSetTishi_New:SetActive(false);
end