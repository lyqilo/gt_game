MessageBox = { };
-- 界面包含（游戏、大厅、登录、加载）；加载时，如果有提示需要加载完成后，调整到其他三个界面再对玩家进行提示
local self = MessageBox;
local objTag = "WenXinTishi";
local tishinum = 0;
local ReturnHallNum = 0;
local ReturnLoginNum = 0;
TishiScenes = nil;
local IsReturn = false;
-- 提示消息显示等级(等级越高越先显示)
ShowTIshiLayer = {
    _OnlyShow = 0,
    _ReturnHall = 1,
    _ReturnLogin = 2,
}

TishiTextInfo = { };
-- 系统主动关闭，造成的错误
ReturnNotShowError = { };

local NowShowTishi = { };

-- 创建界面
function MessageBox:Awake()


end

function MessageBox.CreatTishiPanel(TishiText, MessageLayer)
    -- if GameNextScen == gameScenName.LOGON and MessageLayer ~= 0 then return end;
    if #ReturnNotShowError ~= 0 then
        for i = 1, #ReturnNotShowError do
            if ReturnNotShowError[i] == "95003" or ReturnNotShowError[i] == "95002" then
                table.remove(ReturnNotShowError, i)
                return
            end
        end
    end
    if TishiText == nil then
        return ;
    end ;
    if TishiText == "" then
        return
    end ;
    if IsReturn then
        return
    end ;
    if MessageLayer == nil then
        MessageLayer = 0;
        IsReturn = false;
    end
    if #TishiTextInfo > 0 then
        return
    end
    table.insert(TishiTextInfo, TishiText);
    table.insert(TishiTextInfo, MessageLayer);
    self.TishiTextInfo = TishiTextInfo;
    if MessageLayer ~= 0 then
        IsReturn = true;
        for i = 1, #NowShowTishi do
            --   error("NowShowTishi[i]====" .. NowShowTishi[i] .. ",,MessageLayer=====" .. MessageLayer)
            if MessageLayer <= NowShowTishi[i] then
                IsReturn = false;
                return
            end
        end
        table.insert(NowShowTishi, MessageLayer)
    end
    if #Destroy_Panel > 1 then
        return
    end

    -- LoadAssetCacheAsync("module02/tishi_version3", "TishiPanel_Version3", self.ShowTishiMessage);
    self.ShowTishiMessage(HallScenPanel.Pool("TishiPanel_Version3"));
end

function MessageBox.ShowTableInfo()
    if #Destroy_Panel > 1 then
        return
    end
    -- LoadAssetCacheAsync("module02/tishi_version3", "TishiPanel_Version3", self.ShowTishiMessage);
    self.ShowTishiMessage(HallScenPanel.Pool("TishiPanel_Version3"));
end

-- 显示提示(包含隐藏界面）
local _luaBeHaviour = nil;
function MessageBox.ShowTishiMessage(prefeb)
    local oldtishi = TishiTextInfo;
    if #Destroy_Panel > 1 then
        return
    end
    prefeb.transform.localRotation = Quaternion.Euler(0, 0, 0);
    local newobj = prefeb;
    table.insert(Destroy_Panel, #Destroy_Panel + 1, newobj)
    self.tishipartent = newobj;
    local newa = newobj:AddComponent(typeof(CsJoinLua));
    newa:LoadLua('Module02.Global.MessageBox', "MessageBox");
    _luaBeHaviour = newobj.transform:GetComponent("CsJoinLua")
    local go = newobj.transform:GetChild(0).gameObject;
    --   error("oldtishi==============="..#oldtishi);
    TishiTextInfo = oldtishi;
    if #TishiTextInfo == 0 then
        destroy(newobj);
        table.remove(Destroy_Panel, #Destroy_Panel)
        return
    end ;
    local str1 = TishiTextInfo[1]
    local str2 = TishiTextInfo[2];
    go.name = "tishi";
    _luaBeHaviour:AddClick(go.transform:Find('Bg/SureBtn').gameObject, self.CloseMessageBox);
    _luaBeHaviour:AddClick(go.transform:Find('Bg/SureBtn_One').gameObject, self.CloseMessageBox);
    _luaBeHaviour:AddClick(go.transform:Find('Bg/IguoreBtn').gameObject, self.CloseMessageBox);
    _luaBeHaviour:AddClick(go.transform:Find('Bg/FreeGoldBtn').gameObject, self.SkipFreeGoldPanel);
    _luaBeHaviour:AddClick(go.transform:Find('Bg/RechagreBtn').gameObject, self.SkipRechargePanel);
    go.transform:Find('Bg/IguoreBtn').gameObject:SetActive(false);
    go.transform:Find('Bg/FreeGoldBtn').gameObject:SetActive(false);
    go.transform:Find('Bg/RechagreBtn').gameObject:SetActive(false);
    go.transform:Find('Bg/Time').gameObject:SetActive(false);
    go.transform:Find('Bg/SureBtn').gameObject:SetActive(false);
    -- go.transform:SetParent(LaunchModule.modulePanel.transform);
    go.transform.localScale = Vector3.one;
    go.transform.localPosition = Vector3.New(0, 0, 100);
    local Scount = table.getn(AllSCGameRoom);
    local infoList = nil;
    for k = 1, Scount do
        if AllSCGameRoom[k]._9Name == ScenSeverName then
            infoList = AllSCGameRoom[k];
        end
    end
    -- 在大厅
    if infoList == nil then
        go.transform:Find('TishiPanel_Version3').localRotation = Quaternion.Euler(0, 0, 0);
    else
        go.transform:Find('TishiPanel_Version3').localRotation = Quaternion.Euler(0, 0, -90);
    end
    local t = go.transform:Find('Bg/Text').gameObject;
    t:GetComponent('Text').text = str1;
    local textwidth = t:GetComponent('Text').preferredWidth;
    local contwidth = t:GetComponent("RectTransform").sizeDelta.x
    local tx = 0
    if textwidth > contwidth then
        local count = math.ceil(textwidth / contwidth)
        local lastw = textwidth / count;
        if lastw + 30 < contwidth then
            lastw = lastw + 30
        end
        t:GetComponent("RectTransform").sizeDelta = Vector2.New(contwidth, t:GetComponent('Text').preferredHeight + 10);
        tx = 10;
    else
        t:GetComponent("RectTransform").sizeDelta = Vector2.New(t:GetComponent('Text').preferredWidth, t:GetComponent('Text').preferredHeight + 10);
    end
    t.transform.localPosition = Vector3.New(tx, -40, 0);
    tishinum = tishinum + 1;
    go.name = tishinum .. "Layer" .. str2;
    if self.tishipartent.transform.childCount == 1 then
    else
        go:SetActive(false);
    end
end

function MessageBox.SkipFreeGoldPanel(obj)
    if DancePanelSystem.DancePanel ~= nil then
        DancePanelSystem.ClosePanel();
    elseif GameRoomList.GameRoomList ~= nil then
        GameRoomList.ClosePanelBtnOnClick();
    elseif CornucopiaSystem.CornucopiaPanel ~= nil then
        CornucopiaSystem.CornucopiaCloseBtnOnClick();
    end
    HallScenPanel.FreeGoldBtnOnClick();
    self.CloseMessageBox(obj);
end

function MessageBox.SkipRechargePanel(obj)
    if DancePanelSystem.DancePanel ~= nil then
        DancePanelSystem.ClosePanel();
    elseif GameRoomList.GameRoomList ~= nil then
        GameRoomList.ClosePanelBtnOnClick();
    elseif CornucopiaSystem.CornucopiaPanel ~= nil then
        CornucopiaSystem.CornucopiaCloseBtnOnClick();
    end
    HallScenPanel.PlayeBtnMusic();
    self.CloseMessageBox(obj);

end




-- 关闭提示(判断是否包含其他界面，以及是否跳转)
function MessageBox.CloseMessageBox(obj)
    table.remove(NowShowTishi, 1)
    IsReturn = false;
    --    if #TishiTextInfo > 1 then destroy(obj.transform.parent.parent.gameObject); self.ShowTableInfo(); end;
    local prefebname = obj.transform.parent.parent.gameObject.name;
    if string.find(prefebname, "Layer0") ~= nil then
        destroy(obj.transform.parent.parent.parent.gameObject)
        table.remove(Destroy_Panel, #Destroy_Panel)
    elseif string.find(prefebname, "Layer1") ~= nil then
        destroy(obj.transform.parent.parent.parent.gameObject)
        table.remove(Destroy_Panel, #Destroy_Panel)
    elseif string.find(prefebname, "Layer2") ~= nil then
        destroy(obj.transform.parent.parent.parent.gameObject)
        table.remove(Destroy_Panel, #Destroy_Panel)
    else
        destroy(obj.transform.parent.parent.parent.gameObject)
        table.remove(Destroy_Panel, #Destroy_Panel)

    end

end


-- 返回大厅监听事件
function MessageBox.ShowReturnHallInfo()
    local SendGameQuit = false;
    for i = 1, #Destroy_Panel do
        destroy(Destroy_Panel[i])

    end
    Destroy_Panel = { };
    TishiTextInfo = { };
    if TishiScenes == gameServerName.HALL then
        error("在大厅不做跳转")
        return
    end ;
    ReturnHallNum = 0;
    ReturnLoginNum = 0;
    TishiScenes = nil;
    if SendGameQuit then
        if not (Network.State(gameSocketNumber.HallSocket)) then
            -- 已断，重新帮用户登录
            isOnEnable = true;
            GameNextScen = nil;
            ChangeScen = nil
            GameManager.OnInitOK()
            return ;
        end
        NetManager:GameQuit();
    else
        -- table.insert(ReturnNotShowError, "95002");
        ReturnNotShowError = { };
        GameSetsBtnInfo.LuaGameQuit()
    end
end


-- 查找提示里面包含的等级个数
function MessageBox.SelectLayerNum(str)
    local prefebname = nil;
    for i = 0, self.tishipartent.transform.childCount - 1 do
        if string.find(self.tishipartent.transform:GetChild(i).gameObject.name, str) then
            prefebname = self.tishipartent.transform:GetChild(i).gameObject.name;
            return prefebname;
        end
    end

end

-- 提示界面是否需要显示在最前面
function MessageBox.ShowPanleLayer()

end

function MessageBox.SelectInfo(messageNum)
    local num = 0;
    for i = 1, #ReturnHall do
        if messageNum == ReturnHall[i] then
            num = 1;
            return num
        end
    end
    for i = 1, #ReturnLogin do
        if messageNum == ReturnLogin[i] then
            num = 2
            return num
        end
    end
    return num;
end

-- 通用提示界面（可绑定方法）

GeneralTipsSystem_ShowInfo = {
    _01_Title = nil;
    _02_Content = nil;
    _03_ButtonNum = nil;
    _04_YesCallFunction = nil;
    _05_NoCallFunction = nil;
    _06_YesName = nil;
    _07_NoName = nil;
}
local showcontent = nil;
local datatable = nil;
-- 传入纯数字，则表示需要多少秒关闭游戏
local timeClose = nil;
local timestart = 5
-- 判断是否创建obj
local Creatobj = false;
function MessageBox.CreatGeneralTipsPanel(data, CallBack)
    local datatype = type(data);
    if datatype == "table" then
        datatable = data;
        showcontent = nil;
        local pop = FramePopoutCompent.Pop.New()
        pop._02conten = datatable._02_Content;
        if datatable._04_YesCallFunction ~= nil then
            pop._05yesBtnCallFunc = datatable._04_YesCallFunction;
            pop._06noBtnCallFunc = datatable._04_YesCallFunction;
        end
        if datatable._05_NoCallFunction ~= nil then
            pop._06noBtnCallFunc = datatable._05_NoCallFunction;
        end
        if datatable._03_ButtonNum == 2 then
            if datatable._05_NoCallFunction == nil then
                pop._06noBtnCallFunc = function()
                    destroy(pop._100modePanel.gameObject);
                end
            end
        end
        if datatable._03_ButtonNum == 1 then
            pop._05yesBtnCallFunc = nil;
        end
        pop.isBig = true;
        FramePopoutCompent.Add(pop);
    elseif datatype == "string" then
        datatable = nil;
        showcontent = data;
        FramePopoutCompent.Show(showcontent, CallBack)
    else
        Creatobj = false;
        return ;
    end
end
-- 显示提示(包含隐藏界面）

function MessageBox.ShowGeneralTipsMessage(newobj)
    newobj.transform.localRotation = Quaternion.Euler(0, 0, 0);
    local GeneralTipsMessage_luaBeHaviour = nil;
    newobj.tag = objTag;
    table.insert(Destroy_Panel, #Destroy_Panel + 1, newobj)
    local CS = newobj:GetComponent(typeof(CsJoinLua)) or newobj:AddComponent(typeof(CsJoinLua));
    CS:LoadLua('Module02.Global.MessageBox', "MessageBox");
    GeneralTipsMessage_luaBeHaviour = CS;
    local go = newobj
    go.name = "tishi";
    -- go.transform:SetParent(LaunchModule.modulePanel.transform.parent);
    go.transform.localScale = Vector3.one;
    go.transform.localPosition = Vector3.New(0, 0, 1152);
    local Scount = table.getn(AllSCGameRoom);
    local infoList = nil;
    for k = 1, Scount do
        if AllSCGameRoom[k]._9Name == ScenSeverName then
            infoList = AllSCGameRoom[k];
        end
    end
    -- 在大厅
    if infoList == nil then
        go.transform:Find('TishiPanel_Version3').localRotation = Quaternion.Euler(0, 0, 0);
    else
        go.transform:Find('TishiPanel_Version3').localRotation = Quaternion.Euler(0, 0, -90);
    end
    go.transform:Find('TishiPanel_Version3/Bg/FreeGoldBtn').gameObject:SetActive(false);
    go.transform:Find('TishiPanel_Version3/Bg/RechagreBtn').gameObject:SetActive(false);
    go.transform:Find('TishiPanel_Version3/Bg/SureBtn_One').gameObject:SetActive(false);
    local main = go.transform:Find('TishiPanel_Version3/Bg').gameObject;
    main.transform:Find('SureBtn').localPosition = Vector3.New(-190, -140, 0);
    main.transform:Find('IguoreBtn').localPosition = Vector3.New(190, -140, 0);
    main.transform:Find('IguoreBtn/Text'):GetComponent('Text').text = "取      消";
    local a = function()
        main.transform:Find('SureBtn').localPosition = Vector3.New(0, -140, 0);
        main.transform:Find('IguoreBtn').gameObject:SetActive(false)
        main.transform:Find('SureBtn').gameObject:SetActive(false);
        main.transform:Find('SureBtn_One').gameObject:SetActive(true);
    end;
    Creatobj = false;
    -- 默认确定方法
    local yes = function(obj)
        if IsNil(obj) then
            error("obj  is  nil")
        end
        obj.transform:GetComponent('Button').interactable = false;
        HallScenPanel.PlayeBtnMusic();
        Creatobj = false;
        if datatable ~= nil and datatable._04_YesCallFunction ~= nil then
            datatable._04_YesCallFunction();
        end
        if timeClose ~= nil then
            Util.Quit()
            return
        end ;
        timeClose = -10;
        table.remove(Destroy_Panel, #Destroy_Panel)
        destroy(obj.transform.parent.parent.parent.gameObject)
        for i = 1, #Destroy_Panel do
            if Destroy_Panel[i] ~= nil then
                destroy(Destroy_Panel[i])
            end
        end
        Destroy_Panel = { };
    end
    -- 默认取消方法
    local no = function(obj)
        HallScenPanel.PlayeBtnMusic();
        Creatobj = false;
        if datatable ~= nil and datatable._05_NoCallFunction ~= nil then
            datatable._05_NoCallFunction();
        end
        timeClose = -10;
        table.remove(Destroy_Panel, #Destroy_Panel)
        destroy(obj.transform.parent.parent.parent.gameObject)
        for i = 1, #Destroy_Panel do
            if Destroy_Panel[i] ~= nil then
                destroy(Destroy_Panel[i])
            end
        end
        Destroy_Panel = { };
    end
    -- 传入表
    local b = function()
        if datatable == nil then
            return
        end ;
        --   go.transform:Find('HeadInfo'):GetComponent('Text').text = datatable._01_Title;
        showcontent = datatable._02_Content;
        if tonumber(datatable._02_Content) ~= nil and ExceptionCodeInfo[datatable._02_Content] ~= nil then
            showcontent = ExceptionCodeInfo[datatable._02_Content]
        end
        main.transform:Find('Text'):GetComponent('Text').text = showcontent;
        if datatable._03_ButtonNum == 1 then
            a();
        end
    end
    -- 传入纯文字
    local c = function()
        if tonumber(showcontent) ~= nil then
            showcontent = ExceptionCodeInfo[showcontent]
        end
        if showcontent == nil then
            return
        end
        main.transform:Find('Text').gameObject:GetComponent('Text').text = showcontent;
    end
    main.transform:Find('Time').gameObject:SetActive(false);

    if datatable ~= nil and datatable._03_ButtonNum == 2.1 then
        GeneralTipsMessage_luaBeHaviour:AddClick(main.transform:Find('SureBtn').gameObject, yes);
        GeneralTipsMessage_luaBeHaviour:AddClick(main.transform:Find('SureBtn_One').gameObject, no);
        GeneralTipsMessage_luaBeHaviour:AddClick(main.transform:Find('IguoreBtn').gameObject, no);
        main.transform:Find('SureBtn_One').gameObject:SetActive(true);
        main.transform:Find('IguoreBtn').gameObject:SetActive(false);
        main.transform:Find('SureBtn').localPosition = Vector3.New(0, -140, 0);
    else

        GeneralTipsMessage_luaBeHaviour:AddClick(main.transform:Find('SureBtn').gameObject, yes);
        GeneralTipsMessage_luaBeHaviour:AddClick(main.transform:Find('SureBtn_One').gameObject, yes);
        GeneralTipsMessage_luaBeHaviour:AddClick(main.transform:Find('IguoreBtn').gameObject, no);
    end
    if datatable ~= nil and datatable._06_YesName ~= nil then
        main.transform:Find('SureBtn/Text'):GetComponent('Text').text = datatable._06_YesName;
    end
    -- 倒计时
    local d = function()
        for i = 1, timestart do
            coroutine.wait(1);
            timeClose = timeClose - 1;
            main.transform:Find('Time').gameObject:GetComponent('Text').text = timeClose .. "s后自动退出";
            if timeClose <= -10 then
                main.transform:Find('Time').gameObject:GetComponent('Text').text = " ";
                return
            end
        end
        if timeClose <= -10 then
            main.transform:Find('Time').gameObject:GetComponent('Text').text = " ";
            return
        end
        if timeClose == 0 then
            Util.Quit()
            return ;
        end ;
    end
    if timeClose ~= nil and timeClose > 0 then
        main.transform:Find('Time').gameObject:SetActive(true);
        coroutine.start(d);
    end ;

    if showcontent == nil then
        b();
    elseif showcontent ~= nil then
        a();
        c();
    end
    local t = main.transform:Find('Text').gameObject;
    local textwidth = t:GetComponent('Text').preferredWidth;
    local contwidth = t:GetComponent("RectTransform").sizeDelta.x
    local tx = 0;
    if textwidth > contwidth then
        local count = math.ceil(textwidth / contwidth)
        local lastw = textwidth / count;
        if lastw + 30 < contwidth then
            lastw = lastw + 30
        end
        t:GetComponent("RectTransform").sizeDelta = Vector2.New(contwidth, t:GetComponent('Text').preferredHeight + 10);
        tx = 10
    else
        t:GetComponent("RectTransform").sizeDelta = Vector2.New(t:GetComponent('Text').preferredWidth, t:GetComponent('Text').preferredHeight + 10);
    end
    t.transform.localPosition = Vector3.New(tx, 20, 0);
    if datatable ~= nil then
        if datatable._03_ButtonNum == 1 then
            t.transform.localPosition = Vector3.New(0, -40, 0);
        end
    else
        t.transform.localPosition = Vector3.New(tx, -40, 0);
    end
end


-- 判断是否存在提示面板
function MessageBox.Exist()
    local obj = GameObject.FindGameObjectWithTag(objTag);
    local bl = IsNil(obj);
    if bl then
        bl = false
    else
        bl = true
    end
    return bl;
end
