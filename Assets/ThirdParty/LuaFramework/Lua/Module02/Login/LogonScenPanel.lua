LogonScenPanel = {}
local self = LogonScenPanel
local this = LogonScenPanel
local transform
local gameObject
local luaBehaviour
local tab = {}
local IsAccountOnHand = false
local userID = ''
local json = require 'cjson'
local mrpw = 'yf7b&mm*'
local simulatorKey = 'Bluestacks_iToolsAVMiToolsAVM_HDGraphics_Intel_GeForceGT_NVIDIAGeF'
isSimulator = false
isAndroidSimulator = false
self.restConnectCount = 0
self.wait = nil;
self.isReconnect = false;

self.wxdata = "{\"language\":\"zh_CN\", \"userTags\":\"\", \"sex\":1.0, \"unionid\":\"olvas5rSsxyhtSR0ndXMta6VQS8M\", \"nickname\":\"Ben\", \"privilege\":[], \"city\":\"u6210u90FD\", \"province\":\"u56DBu5DDD\", \"headimgurl\":\"http://thirdwx.qlogo.cn/mmopen/vi_32/VicF1RSbaq4DHBdnPguII8ia3n2dTbBazRaGU9R1M2pvllSBK9PT0Z7Nf8zlEWIiacJLXqa3DiaibgCRUEYq5icH4tMQ/132\", \"country\":\"u4E2Du56FD\", \"openid\":\"oOW_11PHRtwW6875VxB0seP0PG9c\"}";
-- 构造方法
function LogonScenPanel:New()
    local t = o or {}
    setmetatable(t, { __index = LogonScenPanel })
    return t
end

function LogonScenPanel.Create()
    if ScenSeverName == gameServerName.LOGON then
        return
    end
    local go = HallScenPanel.Pool('LogonScenPanel')
    go.transform:SetParent(HallScenPanel.modulePanel.transform.parent)
    go.name = 'LogonScenPanel'
    go.transform.localScale = Vector3.one
    go.transform.localPosition = Vector3.New(0, 0, 1152)
    go.transform.localScale = Vector3.New(GameManager.ScreenRate, GameManager.ScreenRate, GameManager.ScreenRate);

    gameObject = go
    local cs = go:AddComponent(typeof(LuaBehaviour))
    --local cs = addComponent(go.transform,"LuaBehaviour")
    FramePopoutCompent._luaBeHaviour = cs
    MessageBox._luaBeHaviour = cs
    self.regTimer = 0
    self.findPasswordTimer = 0
    self.RegisterTimer = nil
    self.FindPasswordTimer = nil
    local IMGResolution = go.transform:GetComponent("IMGResolution");
    if IMGResolution == nil then
        Util.AddComponent("IMGResolution", go);
    end
    -- DownTishiInfo.clearAllDown();
end

-- 帐号对象
local accountObj
-- 密码对象
local pwdObj
local IsDestroyPanel = false

this.loginUrl = {

}
self.ReqIPList = { };

self.reqIpIndex = 0;
this.currentLoginUrl = ""
this.reqIndex = 0
this.reReqCount = 0;
self.GWData = nil;
--请求自身IP
function LogonScenPanel.ReqIP()
    local f = function()
        self.reqIpIndex = self.reqIpIndex + 1;
        if self.reqIpIndex > #self.ReqIPList then
            self.reqIpIndex = 1;
        end
        ShowWaitPanel(LogonScenPanel.wait, true);
        UnityWebRequestManager.Instance:GetText(self.ReqIPList[self.reqIpIndex], 5, function(code, result)
            if code == 200 then
                if self.selfIP == nil then
                    if string.find(result, "=") ~= nil then
                        local arr = string.split(result, "=");
                        local m = string.sub(arr[2], 1, string.len(arr[2]) - 1);
                        local jsondata = json.decode(m);
                        if jsondata.cip ~= nil then
                            self.selfIP = jsondata.cip;
                        elseif jsondata.ip ~= nil then
                            self.selfIP = jsondata.ip;
                        end
                    else
                        self.selfIP = string.trim(result);
                    end
                    if HttpData ~= nil then
                        ShowWaitPanel(LogonScenPanel.wait, false);
                    end
                    log(self.selfIP);
                else
                    if HttpData ~= nil then
                        ShowWaitPanel(LogonScenPanel.wait, false);
                    end
                end
            else
                self.ReqIP();
            end
        end);
    end
    f();
end
function LogonScenPanel.WaitReq()
    local f = function()
        --77777777777
        log(os.time());
        local account = "";
        if Util.Exists(AppConst.AccountFilePath) then
            local _file = io.open(AppConst.AccountFilePath)
            if _file then
                tab = ReadFile(_file)
                logTable(tab)
                if #tab / 2 >= 1 then
                    userID = Util.DecryptDES(tab[#tab - 1], gameDECkey)
                    if string.find(userID, 'Guest') == nil then
                        SCPlayerInfo._04wAccount = userID
                        SCPlayerInfo._6wPassword = Util.DecryptDES(tab[#tab], gameDECkey)
                        log('获取初始账号' .. SCPlayerInfo._04wAccount .. '密码：' .. SCPlayerInfo._6wPassword)
                    end
                end
                _file:close()
            end
        else
            if PlayerPrefs.HasKey("ID") then
                SCPlayerInfo._04wAccount = Util.DecryptDES(PlayerPrefs.GetString("ID"), gameDECkey);
            end
            if PlayerPrefs.HasKey("Password") then
                SCPlayerInfo._6wPassword = Util.DecryptDES(PlayerPrefs.GetString("Password"), gameDECkey)
                log('获取初始账号' .. SCPlayerInfo._04wAccount .. '密码：' .. SCPlayerInfo._6wPassword)
            end
        end
        if SCPlayerInfo._04wAccount ~= nil then
            account = SCPlayerInfo._04wAccount;
        end

        -- if self.wait ~= nil then
        --     self.wait:Find("Text"):GetComponent("Text").text = string.format("连接中...%s", self.reReqCount + 1);
        -- end
        ShowWaitPanel(self.wait, true, nil);
        local formdata = FormData.New();
        formdata:AddField("clientkey", "107");
        formdata:AddField("account", account);
        formdata:AddField("clientID", 0);
        formdata:AddField("sendIp", "192.168.1.1");
        formdata:AddField("machine", "37342d44342d33352d44362d30442d39");
        formdata:AddField("param", PlatformID);
        formdata:AddField("md5", "a9e4553ae02ff86d37578525aae3f163");
        local arr = string.split(self.currentLoginUrl, ":");
        self.currentLoginUrl = Util.GetIPAndPort(arr[1], arr[2]);
        if self.currentLoginUrl == nil then
            self.currentLoginUrl = self.loginUrl[self.reqIndex];
        end
        UnityWebRequestManager.Instance:GetText("http://" .. this.currentLoginUrl .. "/LoginIpHandler.ashx", 8, formdata, function(statusCode, msg)
            if statusCode ~= 200 then
                logError(msg);
                coroutine.start(function()
                    coroutine.wait(3);
                    self.reqIndex = self.reqIndex + 1
                    if self.reqIndex > #self.loginUrl and self.reReqCount >= 10 then
                        self.reqIndex = 1
                        self.reReqCount = 0;
                        self.currentLoginUrl = ""
                        Util.ResetGame();
                    else
                        if self.reqIndex > #self.loginUrl then
                            self.reqIndex = 1;
                            self.reReqCount = self.reReqCount + 1;
                        end
                        self.currentLoginUrl = self.loginUrl[self.reqIndex]
                        self.WaitReq()
                    end
                end);
                return
            else
                local json_text = msg;
                log(json_text)
                HttpData = json.decode(json_text);
                if not GameManager.IsTest then
                    if Util.isPc  then
                        HttpData.login_ip = self.GWData.PCLoginIP;
                    end
                end
                GameManager.logintagIp = HttpData.login_ip;
                if not GameManager.IsTest then
                    if GameManager.IsUseDefence() then
                        --HttpData.login_port="14535";
                        HttpData.login_port = tonumber(HttpData.login_port);
                        local msg = Util.GetIPAndPort(GameManager.logintagIp, HttpData.login_port);
                        log(msg);
                        local arr = string.split(msg, ":");
                        HallIP = arr[1];
                        HallPort = arr[2];
                    else
                        HallIP = HttpData.login_ip
                        HallPort = HttpData.login_port;
                    end
                    GameManager.canLogin = true
                else
                    --HallPort = HttpData.login_port;
                    GameManager.logintagIp = HallIP;
                    GameManager.canLogin = true
                end
                HallScenPanel.LoginList = {};
                table.insert(HallScenPanel.LoginList, HttpData.login_ip);
                for i = 1, #self.GWData.REQLoginList do
                    table.insert(HallScenPanel.LoginList, self.GWData.REQLoginList[i]);
                end
                HallScenPanel.GameIPList = {};
                for i = 1, #self.GWData.REQGameList do
                    table.insert(HallScenPanel.GameIPList, self.GWData.REQGameList[i]);
                end
                if self.selfIP ~= nil then
                    ShowWaitPanel(this.wait, false, nil);
                end
                -- if tonumber(HttpData.isUseThridPlay) > tonumber(Application.version) then
                --     self.PopWindow();
                -- end
                coroutine.start(function()
                    while self.selfIP == nil do
                        coroutine.wait(0.1);
                    end
                    if PlayerPrefs.HasKey("LoginType") then
                        local type = PlayerPrefs.GetString("LoginType");
                        log("登录类型:" .. type)
                        if PlayerPrefs.HasKey("AutoLogin") and PlayerPrefs.GetString("AutoLogin") == "1" then
                            log("自动登录" .. PlayerPrefs.GetString("AutoLogin"))
                            if type == "1" then
                                PlayerPrefs.SetString("LoginType", "1");
                                self.ConnectHallServer(function()
                                    self.SendLoginMasseg();
                                end)
                            elseif type == "2" then
                                SCPlayerInfo._04wAccount = "";
                                SCPlayerInfo._6wPassword = "";
                                PlayerPrefs.SetString("LoginType", "2");
                                self.ConnectHallServer(function()
                                    self.SendLoginMasseg();
                                end)
                            elseif type == "3" then
                                if not Util.isEditor and not Util.isPc then
                                    Util.LoginWithWX(22, function(code, result)
                                        if code == 200 then
                                            --成功
                                            self.wxdata = result;
                                            log(self.wxdata);
                                            PlayerPrefs.SetString("LoginType", "3");
                                            self.ConnectHallServer(function()
                                                self.SendLoginMasseg();
                                            end)
                                        else
                                            --失败,取消
                                            MessageBox.CreatGeneralTipsPanel(result);
                                        end
                                    end);
                                else
                                    SCPlayerInfo._04wAccount = "";
                                    SCPlayerInfo._6wPassword = "";
                                    PlayerPrefs.SetString("LoginType", "3");
                                    self.ConnectHallServer(function()
                                        self.SendLoginMasseg();
                                    end)
                                end
                            end
                        end
                    end
                end);
            end
        end);
    end
    if self.reqIndex <= 0 or self.reqIndex > #self.loginUrl then
        self.reqIndex = 1
    end
    self.currentLoginUrl = self.loginUrl[self.reqIndex]
    f();
end
function LogonScenPanel.PopWindow()
    local pop = FramePopoutCompent.Pop.New();
    pop.isBig = true;
    pop._02conten = "当前版本低于最新版本，请下载最新版本，获得更好的游戏体验！";
    local clickback = function()
        local url = nil;
        url = self.GWData.GWUrl;
        if Util.SystmeMode() == 64 then
            if Util.isPc or Util.isEditor then
                url = self.GWData.PCUrl;
            end
        else
            if Util.isPc or Util.isEditor then
                url = self.GWData.PC32Url;
            end
        end
        self.PopWindow();
        Application.OpenURL(url);
    end
    pop._05yesBtnCallFunc = clickback;
    pop._06noBtnCallFunc = function()
        Util.Quit();
    end;
    FramePopoutCompent.Add(pop);
end
function LogonScenPanel.GetHttpURL(callBack)
    local formdata = FormData.New();
    formdata:AddField("time", os.time());
    local url = string.gsub(AppConst.WebUrl, "/android", "");
    url = string.gsub(url, "/iOS", "");
    url = string.gsub(url, "/ios", "");
    url = string.gsub(url, "/win", "");
    UnityWebRequestManager.Instance:GetText(url .. "HttpConfiger.json", 4, formdata, function(statusCode, msg)
        if statusCode == 200 then
            local result = Util.DecryptDES(msg, MD5Helper.DESKey);
            log(result)
            self.GWData = json.decode(result);
            self.loginUrl = self.GWData.Urls;
            self.ReqIPList = self.GWData.IPUrls;
            GiveRedBag.rate = self.GWData.MoneyRate;
            GiveRedBag.transferConfig = self.GWData.TransferConfig;
            
            SetShowGame.games_lb=self.GWData.games_lb
            -- SetShowGame.games_qp=self.GWData.games_qp
            -- SetShowGame.games_by=self.GWData.games_by
            -- SetShowGame.games_dr=self.GWData.games_dr
            -- SetShowGame.games_yyl=self.GWData.games_yyl
            -- SetShowGame.games_cm=self.GWData.games_cm
            -- SetShowGame.games_yh=self.GWData.games_yh

            if self.GWData.REQGameList == nil then
                self.GWData.REQGameList = {};
            end
            if callBack ~= nil then
                callBack();
                callBack = nil;
            end
        else
            self.GetHttpURL(callBack);
        end
    end);
end
function LogonScenPanel:Begin(obj)
    logError('LogonScenPanel:Begin')
    GameManager.isLoadGameList = false;
    HallScenPanel.connectSuccess = false;
    GameManager.isLogin = false;
    HallScenPanel.isLogin = false;
    self.modulePanle = obj
    self.luaBehaviour = obj:GetComponent(typeof(LuaBehaviour))
    IsDestroyPanel = false
    gameObject = obj
    transform = obj.transform
    self.transform = transform
    accountObj = transform:Find('LoginBg/ID/InputField'):GetComponent('InputField')
    pwdObj = transform:Find('LoginBg/Password/InputField'):GetComponent('InputField')
    local IMGbg = transform:Find('bg').gameObject
    IMGbg:AddComponent(typeof(LuaFramework.IMGResolution))
    self:initData()
    self:InitPanel()
    local v = self.VersionLable.transform.localPosition
    self.VersionLable.transform.localPosition = Vector3.New(v.x, v.y, v.z)
    local vnum = AppConst.valueConfiger.Version + AppConst.gameValueConfiger.Version
    --self.VersionLable:GetComponent('Text').text = "版本号:" .. Application.version .. '.' .. vnum
    self.VersionLable_Logon:GetComponent('Text').text = "V." .. Application.version .. '.' .. vnum
    --self.Version:GetComponent('Text').text = "版本号:" .. Application.version .. '.' .. vnum

    AllSetGameInfo._1audio = MusicManager:GetMusicVolume()
    AllSetGameInfo._2soundEffect = MusicManager:GetSoundVolume()
    AllSetGameInfo._5IsPlayAudio = MusicManager:GetIsPlayMV()
    AllSetGameInfo._6IsPlayEffect = MusicManager:GetIsPlaySV()
    if ChangeScen == nil then
        GameManager.SetSoundValue(AllSetGameInfo._2soundEffect, AllSetGameInfo._1audio)
    end
    LogonScenPanel.this = self
    local function func()
        Event.Brocast(tostring(EventIndex.OnClick), self)
    end
    delegate_LogonFunc = func

    if this.currentLoginUrl == "" then
        self.reqIndex = 1
        this.currentLoginUrl = this.loginUrl[self.reqIndex]
    end
    ShowWaitPanel(this.wait, true, nil);
    self.GetHttpURL(function()
        this.WaitReq();
        self.ReqIP();
    end)
end

function LogonScenPanel.initData()

    local bl = true
    if Util.Exists(AppConst.AccountFilePath) then
        local _file = io.open(AppConst.AccountFilePath)
        if _file then
            tab = ReadFile(_file)
            logTable(tab)
            if #tab / 2 >= 1 then
                userID = Util.DecryptDES(tab[#tab - 1], gameDECkey)
                if string.find(userID, 'Guest') == nil then
                    SCPlayerInfo._04wAccount = userID
                    SCPlayerInfo._6wPassword = Util.DecryptDES(tab[#tab], gameDECkey)
                    log('获取初始账号' .. SCPlayerInfo._04wAccount .. '密码：' .. SCPlayerInfo._6wPassword)
                end
            end
            _file:close()
        end
    else
        if PlayerPrefs.HasKey("ID") then
            SCPlayerInfo._04wAccount = Util.DecryptDES(PlayerPrefs.GetString("ID"), gameDECkey);
        end
        if PlayerPrefs.HasKey("Password") then
            SCPlayerInfo._6wPassword = Util.DecryptDES(PlayerPrefs.GetString("Password"), gameDECkey)
            log('获取初始账号' .. SCPlayerInfo._04wAccount .. '密码：' .. SCPlayerInfo._6wPassword)
        end
    end

    isSimulator = false
    if Util.isPc then
        return isSimulator
    end
    if Util.isApplePlatform then
        return isSimulator
    end

    -- 机器码检测
    self.ChangeAndoidID()
    local oldKey = self.ReadKey()
    if oldKey ~= nil then
        oldKey = Util.DecryptDES(readOldStr, gameDECkey)
    end
    if oldKey ~= nil and oldKey ~= Opcodes then
        Opcodes = oldKey
        self.GetUserInfoWeb()
    end
    bl = self.Simulator()
    -- isSimulator = bl--开放模拟器注册
    io.close()
    return bl
end

function LogonScenPanel:OnEnable()
    if isOnEnable then
        isOnEnable = false
        --   ChangeScen = nil;
        transform:Find('LoginBg').transform.localPosition = Vector3.New(1500, 1500, 0)
        transform:Find('LoginBg').gameObject:SetActive(false)
        transform:Find('StartBtn').transform.localPosition = Vector3.New(1500, 1500, 0)
        transform:Find('StartBtn').gameObject:SetActive(false)
        transform:Find('bg').transform.localPosition = Vector3.New(0, 0, 0)
        transform:Find('bg').gameObject:SetActive(true)
        self.LogonBtnOnClick()
    end
end

-- 初始化面板--
function LogonScenPanel:InitPanel()
    -- 记录当前场景名字
    ScenSeverName = gameServerName.LOGON
    self:FindComponet()
    self:AddOnClickEvent()
    -- 删除场景初始化面板
    local desObj = GameObject.Find('BeginPanel')
    if desObj ~= nil then
        destroy(desObj.gameObject)
    end

    if string.find(SCPlayerInfo._04wAccount, 'Guest') then
        return
    end
    if StringIsNullOrEmpty(SCPlayerInfo._04wAccount) then
        return
    end

    if not IsNil(accountObj) then
        accountObj.text = SCPlayerInfo._04wAccount
    end
    if not IsNil(pwdObj) then
        pwdObj.text = accountObj.text .. 'md5', gameDECkey
    end
end

function LogonScenPanel:Update()
end

-- 寻找当前场景必要的gamgobjet
function LogonScenPanel:FindComponet()
    -- 登录窗口对象
    self.loginGroupBtn = transform:Find("LoginGroup/LoginBtn").gameObject;
    self.guestGroupBtn = transform:Find("LoginGroup/GuestBtn").gameObject;

    self.WXBtn = transform:Find('LoginGroup/WXBtn').gameObject

    this.LoginObj = transform:Find('LoginBg').gameObject
    self.LoginObj:SetActive(false);
    self.closeLoginPanelBtn = transform:Find("LoginBg/CloseLoginBtn").gameObject;
    -- 注册窗口对象
    this.RegisterObj = transform:Find('RegisterBg').gameObject
    this.RegisterObj:SetActive(false)
    -- 找回密码窗口
    this.FindPwdObj = transform:Find('FindPwdBg').gameObject
    this.FindPwdObj:SetActive(false)
    -- 找回密码修改
    self.UpdateFindPwdBtn = transform:Find('FindPwdBg/UpdateBtn').gameObject
    -- 找回密码取消
    self.QuitFindPwdBtn = transform:Find('FindPwdBg/BackBtn').gameObject
    self.UpdatePwdGetCodeBtn = transform:Find('FindPwdBg/GetCodeBtn').gameObject
    self.UpdatePwdGetCodeBtn.transform:Find('Text'):GetComponent('Text').text = ' '

    self.IDInput = transform:Find('RegisterBg/ID/InputField').gameObject
    self.PasswordInput = transform:Find('RegisterBg/Password/InputField').gameObject
    self.RePasswordInput = transform:Find('RegisterBg/Password2/InputField').gameObject
    self.MobileNumInput = transform:Find('RegisterBg/MobileNum/InputField').gameObject
    self.CodeInput = transform:Find('RegisterBg/Code/InputField').gameObject
    self.GetCodeBtn = transform:Find('RegisterBg/GetCodeBtn').gameObject
    self.GetCodeBtn.transform:Find('Text'):GetComponent('Text').text = ' '
    self.SendRegistBtn = transform:Find('RegisterBg/RegistBtn').gameObject
    --self.Version = transform:Find('version')

    --
    -- self.RegistXB = transform:Find('RegisterBg/XB').gameObject
    -- self.RegistXB_NanBtn = self.RegistXB.transform:Find("nanText/Button")
    -- self.RegistXB_NanBtnS = self.RegistXB.transform:Find("nanText/Button/Button")
    -- self.RegistXB_NanBtnS.gameObject:SetActive(true)

    -- self.RegistXB_NvBtn = self.RegistXB.transform:Find("nvText/Button")
    -- self.RegistXB_NvBtnS = self.RegistXB.transform:Find("nvText/Button/Button")
    -- self.RegistXB_NvBtnS.gameObject:SetActive(false)

    -- local Nan = function()
    --     self.RegistXB_NanBtnS.gameObject:SetActive(true)
    --     self.RegistXB_NvBtnS.gameObject:SetActive(false)
    -- end

    -- local Nv = function()
    --     self.RegistXB_NanBtnS.gameObject:SetActive(false)
    --     self.RegistXB_NvBtnS.gameObject:SetActive(true)
    -- end

    -- self.luaBehaviour:AddClick(self.RegistXB_NanBtn.gameObject, Nan);
    -- self.luaBehaviour:AddClick(self.RegistXB_NvBtn.gameObject, Nv);
    --
    -- 取消注册
    self.QuitRegisterBtn = transform:Find('RegisterBg/QuitBtn').gameObject
    -- 登录按钮
    self.LoginBtn = transform:Find('LoginBg/LoginBtn').gameObject
    self.GuestBtn = transform:Find('LoginBg/GuestBtn').gameObject
    -- 注册按钮
    self.RegisterBtn = transform:Find('LoginBg/RegistBtn').gameObject
    error(tostring(Util.isWindowsEditor))
    -- 找回密码
    self.FindPwdBtn = transform:Find('LoginBg/FindPwdBtn').gameObject
    -- self.GuestBtn:SetActive(false);
    -- 提示控件
    self.NoticeObj = transform:Find('Notice').gameObject
    -- 显示帐号信息面板
    self.AllAccountInfo = transform:Find('LoginBg/AllAccountInfo').gameObject
    -- 空白区域关闭信息面板
   -- self.AllCountBg = transform:Find('LoginBg/AllCountBg').gameObject
    -- 加载提示文字
    self.LoadingContent = transform:Find('bg/Image/LoadingContent').gameObject
    -- 切换帐号按钮
    self.ChangeAccountBtn = transform:Find('LoginBg/ChangeAccountBtn').gameObject
    -- 版本号lable
    self.VersionLable = transform:Find('bg/Image/version').gameObject
    self.VersionLable_Logon = transform:Find('version').gameObject
    -- 开始游戏
    self.StartGameBtn = transform:Find('StartBtn').gameObject
    self.AllAccountInfo:SetActive(false)
   -- self.AllCountBg:SetActive(false)
    this.CodeLogin = transform:Find('CodeLogin').gameObject
    this.CodeLogin.transform.localPosition = Vector3.New(1500, 1500, 0)
    this.CodeLogin:SetActive(false)
    self.CodeValue = this.CodeLogin.transform:Find('InputField').gameObject
    self.CodeLoginYesBtn = this.CodeLogin.transform:Find('YesBtn').gameObject
    self.CodeLoginNoBtn = this.CodeLogin.transform:Find('NoBtn').gameObject
    self.kefuBtn = transform:Find('kefuBtn').gameObject
    self.ClearBtn = transform:Find('ClearBtn').gameObject
    local isshowGuestBtn = false
    for i = 1, #tab, 2 do
        local FindGuest = Util.DecryptDES(tab[i], gameDECkey)
        if string.find(FindGuest, 'Guest') then
            isshowGuestBtn = true
        end
    end
    self.NoticeObj.transform:GetComponent('RectTransform').sizeDelta = Vector2.New(240, 40)
    self.NoticeObj.transform.localPosition = Vector3.New(550, -368, 0)
    self.NoticeObj:GetComponent('Text').text = '<size=23><color=#ffffffff>客服QQ:' .. GameQQ .. '</color></size>'

    --if Util.isPc then
        self.guestGroupBtn:SetActive(true);
        self.WXBtn:SetActive(false);
    --else
    --    self.guestGroupBtn:SetActive(true);
    --    self.WXBtn:SetActive(true);
    --end
    self.wait = transform:Find("wait");
end
-- 添加按钮事件
function LogonScenPanel:AddOnClickEvent()
    local luaBehaviour = self.luaBehaviour
    luaBehaviour:AddClick(self.loginGroupBtn, self.ShowLoginPanel);
    luaBehaviour:AddClick(self.guestGroupBtn, self.GuestBtnOnClick);
    luaBehaviour:AddClick(self.closeLoginPanelBtn, self.CloseLoginPanel);
    luaBehaviour:AddClick(self.StartGameBtn, self.LogonBtnOnClick)
    luaBehaviour:AddClick(self.LoginBtn, self.LogonBtnOnClick)
    luaBehaviour:AddClick(self.GuestBtn, self.GuestBtnOnClick)

    luaBehaviour:AddClick(self.WXBtn, self.WXBtnOnClick)

    luaBehaviour:AddClick(self.RegisterBtn, self.RegisterBtnOnClick)
    luaBehaviour:AddClick(self.QuitRegisterBtn, self.QuitRegisterBtnOnClick)
    -- SendRoginOnClick
    luaBehaviour:AddClick(self.SendRegistBtn, self.SendRoginOnClick)
    luaBehaviour:AddClick(self.GetCodeBtn, self.GetCodeOnClick)
    luaBehaviour:AddClick(self.UpdatePwdGetCodeBtn, self.UpdatePwdCodeBtn)

    luaBehaviour:AddClick(self.ChangeAccountBtn, self.AccountOnHandleBtn)
   -- luaBehaviour:AddClick(self.AllCountBg, self.AccountCloseBtnOnClick)

    luaBehaviour:AddClick(self.CodeLoginYesBtn, self.CodeLoginYesBtnOnClick)
    luaBehaviour:AddClick(self.CodeLoginNoBtn, self.CodeLoginNoBtnOnClick)
    --
    luaBehaviour:AddClick(self.FindPwdBtn, self.FindPwdBtnOnClick)
    luaBehaviour:AddClick(self.QuitFindPwdBtn, self.BackFindPwdBtnOnClick)
    luaBehaviour:AddClick(self.UpdateFindPwdBtn, self.UpdateFindPwdBtnOnClick)
    -- 用户反馈
    luaBehaviour:AddClick(self.kefuBtn, self.ChatBtnOnClick)
    -- 清理缓存
    luaBehaviour:AddClick(self.ClearBtn, self.ClearBtnOnClick)
    -- 找回密码取消
    for i = 0, self.AllAccountInfo.transform.childCount - 1 do
        luaBehaviour:AddClick(self.AllAccountInfo.transform:GetChild(i).gameObject, self.ChangeAccountBtnOnClick)
    end
    -- 登录大厅成功的回调
    Event.RemoveListener(tostring(MH.SUB_3D_SC_LOGIN_SUCCESS))
    Event.AddListener(tostring(MH.SUB_3D_SC_LOGIN_SUCCESS), self.LogonBtnCallBack)
end
function LogonScenPanel.ShowLoginPanel(go)
    HallScenPanel.PlayeBtnMusic();
    self.loginGroupBtn:SetActive(false);
    self.guestGroupBtn:SetActive(false);
    self.WXBtn:SetActive(false);
    self.LoginObj:SetActive(true);
end
function LogonScenPanel.CloseLoginPanel(go)
    HallScenPanel.PlayeBtnMusic();
    self.loginGroupBtn:SetActive(true);
    --if Util.isPc then
        self.guestGroupBtn:SetActive(true);
        self.WXBtn:SetActive(false);
    --else
    --    self.guestGroupBtn:SetActive(true);
    --    self.WXBtn:SetActive(true);
    --end
    self.LoginObj:SetActive(false);
end
function LogonScenPanel.ChatBtnOnClick()
    HallScenPanel.PlayeBtnMusic();
    MessageBox.CreatGeneralTipsPanel('功能尚未开启')
    --[[	luaBehaviour = transform:GetComponent('LuaBehaviour');
        if luaBehaviour == nil then luaBehaviour = transform.parent:GetComponent('LuaBehaviour'); end
        HallScenPanel.PlayeBtnMusic();
        ChatPanel.Open(luaBehaviour, this.transform);--]]
end
-- 需要验证登录
function LogonScenPanel.ShowCodeLogin()
    -- transform:Find("CodeLogin").localPosition = Vector3.New(0, 0, 0);
    -- transform:Find("CodeLogin").gameObject:SetActive(true);
    -- 创建验证
    -- ResManager:LoadAsset("module02/hall_code", "CodeLogin", self.CreatCode);
    self.CreatCode(HallScenPanel.Pool('CodeLogin'))
end

function LogonScenPanel.CreatCode(obj)
    local go = obj
    local father = HallScenPanel.modulePanel.parent;
    go.transform:SetParent(father)
    go.name = 'CodeLogin'
    go.transform.localScale = Vector3.one
    go.transform.localPosition = Vector3.New(0, 0, 1152)
    local txt = go.transform:Find('InputField').gameObject
    local CodeLoginYesBtn = go.transform:Find('YesBtn').gameObject
    local CodeLoginNoBtn = go.transform:Find('NoBtn').gameObject
    local function no()
        logError('取消验证登录（回到登录界面）')
        if Network.State(gameSocketNumber.HallSocket) then
            Network.Close(gameSocketNumber.HallSocket)
        end
        LogonScenPanel.this.LoginBtn:GetComponent('Button').interactable = true
        LogonScenPanel.this.LoginBtn:GetComponent('Image').color = Color.New(1, 1, 1, 1)
        destroy(go)
        ShowWaitPanel(self.wait, false, nil);
    end
    local function yes()
        local data = go.transform:Find('InputField'):GetComponent('InputField').text
        local buffer = ByteBuffer.New()
        buffer:WriteBytes(32, SCPlayerInfo._04wAccount)
        buffer:WriteUInt32(data)
        Network.Send(MH.MDM_3D_LOGIN, MH.SUB_3D_CS_LOGIN_ACCREDIT_CODE, buffer, gameSocketNumber.HallSocket)
        destroy(go)
    end
    local luaB = nil
    if ScenSeverName == gameServerName.LOGON then
        luaB = LogonScenPanel.luaBehaviour
    end
    if ScenSeverName == gameServerName.HALL then
        luaB = HallScenPanel.LuaBehaviour
    end
    luaB:AddClick(CodeLoginYesBtn, yes)
    luaB:AddClick(CodeLoginNoBtn, no)
end

-- 验证登录
function LogonScenPanel.CodeLoginYesBtnOnClick()
    HallScenPanel.PlayeBtnMusic();
    logError('发送登录验证消息')
    transform:Find('CodeLogin').localPosition = Vector3.New(1500, 1500, 0)
    transform:Find('CodeLogin').gameObject:SetActive(false)
end

-- 取消验证登录（回到登录界面）
function LogonScenPanel.CodeLoginNoBtnOnClick()
    self.LogonlogError()
end

-- 登录按钮的点击事件
function LogonScenPanel.LogonBtnOnClick(...)
    HallScenPanel.PlayeBtnMusic();
    if LogonScenPanel.this.LoginBtn:GetComponent('Button').interactable == false then
        return
    end
    LogonScenPanel.this.LoginBtn:GetComponent('Image').color = Color.New(0.4, 0.4, 0.4, 0.4)
    LogonScenPanel.this.LoginBtn:GetComponent('Button').interactable = false
    LogonScenPanel.this.GuestBtn:GetComponent('Button').interactable = false
    LogonScenPanel.this.WXBtn:GetComponent('Button').interactable = false

    TishiScenes = gameServerName.LOGON
    TishiTextInfo = {}
    HallScenPanel.PlayeBtnMusic()

    -- 检测游戏版本
    local isOk = true
    if gameIsUpdate then
        self.PointOut('版本过低，无法进入游戏')
        return
    end
    if ChangeScen == nil then
        logError('区分是不是应该进行自动登录')
        isOk = self.AutoLogin()
    else
        -- 点击登录按钮
        isOk = self.ClickLogin()
    end
    destroy(modulePanle)
end

-- 自动登录
function LogonScenPanel.AutoLogin()
    logError('自动登录')
    self.WriteKey(Opcodes)
    Event.RemoveListener(tostring(EventIndex.OnClick))
    --    if accountObj.text == nil or string.find(accountObj.text, "Guest") then
    --        SCPlayerInfo._04wAccount = "";
    --        SCPlayerInfo._6wPassword = "";
    --    else
    --        SCPlayerInfo._04wAccount = accountObj.text;
    --        if pwdObj.text ~=(accountObj.text .. "md5") then
    --            SCPlayerInfo._6wPassword = MD5Helper.MD5String(pwdObj.text);
    --        else
    --            SCPlayerInfo._04wAccount = Util.DecryptDES(tab[#tab - 1], gameDECkey)
    --            SCPlayerInfo._6wPassword = Util.DecryptDES(tab[#tab], gameDECkey)
    --        end
    --        if #tab > 1 and accountObj.text ~= Util.DecryptDES(tab[#tab - 1], gameDECkey) then
    --            logError("发送游客帐号登录");
    --            SCPlayerInfo._04wAccount = "";
    --            SCPlayerInfo._6wPassword = "";
    --        end
    --    end
    -- 防止刷号
    local function f()
        self.SendLoginMasseg()
    end
    -- self.GetBlackList(f);
    -- return  true;
    f()
end

-- 微信登录
function LogonScenPanel.WXBtnOnClick(...)
    HallScenPanel.PlayeBtnMusic();

    if true then
        MessageBox.CreatGeneralTipsPanel("未安装微信！")
        return
    end

    function f0()
        LogonScenPanel.this.LoginBtn:GetComponent('Button').interactable = false
        LogonScenPanel.this.GuestBtn:GetComponent('Button').interactable = false
        LogonScenPanel.this.WXBtn:GetComponent('Button').interactable = false
        -- 防止刷号
        self.WriteKey(Opcodes)
        Event.RemoveListener(tostring(MH.SUB_3D_SC_LOGIN_SUCCESS))
        Event.AddListener(tostring(MH.SUB_3D_SC_LOGIN_SUCCESS), self.LogonBtnCallBack)
        SCPlayerInfo._04wAccount = ''
        SCPlayerInfo._6wPassword = ''
        --成功
        PlayerPrefs.SetString("LoginType", "3");
        log(self.wxdata);
        self.SendLoginMasseg();
    end
    if not Util.isPc and not Util.isEditor then
        Util.LoginWithWX(22, function(code, result)
            self.wxdata = result;
            if code == 200 then
                LogonScenPanel.ConnectHallServer(f0)
            else
                --失败,取消
                MessageBox.CreatGeneralTipsPanel(result);
            end
        end);
    else
        LogonScenPanel.ConnectHallServer(f0)
    end
end


-- 游客登录
function LogonScenPanel.GuestBtnOnClick(...)
    HallScenPanel.PlayeBtnMusic();
    function f0()
        LogonScenPanel.this.LoginBtn:GetComponent('Button').interactable = false
        LogonScenPanel.this.GuestBtn:GetComponent('Button').interactable = false
        LogonScenPanel.this.WXBtn:GetComponent('Button').interactable = false

        -- 防止刷号
        self.WriteKey(Opcodes)
        Event.RemoveListener(tostring(MH.SUB_3D_SC_LOGIN_SUCCESS))
        Event.AddListener(tostring(MH.SUB_3D_SC_LOGIN_SUCCESS), self.LogonBtnCallBack)
        --PlayerPrefs.SetString("LoginType", "2");
        SCPlayerInfo._04wAccount = ''
        SCPlayerInfo._6wPassword = ''
        PlayerPrefs.SetString("LoginType", "2");
        LogonScenPanel.SendLoginMasseg()
        -- if PlayerPrefs.HasKey("PhoneLogin") then
        --     if Util.Exists(AppConst.AccountFilePath) then
        --         local _file = io.open(AppConst.AccountFilePath)
        --         if _file then
        --             tab = ReadFile(_file)
        --             logTable(tab)
        --             if #tab / 2 >= 1 then
        --                 userID = Util.DecryptDES(tab[#tab - 1], gameDECkey)
        --                 if string.find(userID, 'Guest') == nil then
        --                     SCPlayerInfo._04wAccount = userID
        --                     SCPlayerInfo._6wPassword = Util.DecryptDES(tab[#tab], gameDECkey)
        --                     log('获取初始账号' .. SCPlayerInfo._04wAccount .. '密码：' .. SCPlayerInfo._6wPassword)
        --                 end
        --             end
        --             _file:close()
        --         end
        --     else
        --         if PlayerPrefs.HasKey("ID") then
        --             SCPlayerInfo._04wAccount = Util.DecryptDES(PlayerPrefs.GetString("ID"), gameDECkey);
        --         end
        --         if PlayerPrefs.HasKey("Password") then
        --             SCPlayerInfo._6wPassword = Util.DecryptDES(PlayerPrefs.GetString("Password"), gameDECkey)
        --             log('获取初始账号' .. SCPlayerInfo._04wAccount .. '密码：' .. SCPlayerInfo._6wPassword)
        --         end
        --     end
        --     io.close();
        -- else
        --     SCPlayerInfo._04wAccount = ''
        --     SCPlayerInfo._6wPassword = ''
        -- end

    end
    LogonScenPanel.ConnectHallServer(f0)
end

-- 点击登录
function LogonScenPanel.ClickLogin()
    HallScenPanel.PlayeBtnMusic();
    logError(
            '******************************************登录进入******************************************************************'
    )
    LogonScenPanel.this.LoginBtn:GetComponent('Button').interactable = false
    LogonScenPanel.this.GuestBtn:GetComponent('Button').interactable = false
    LogonScenPanel.this.WXBtn:GetComponent('Button').interactable = false

    Event.RemoveListener(tostring(MH.SUB_3D_SC_LOGIN_SUCCESS))
    Event.AddListener(tostring(MH.SUB_3D_SC_LOGIN_SUCCESS), self.LogonBtnCallBack)
    if (string.len(accountObj.text) < 2) then
        LogonScenPanel.this.PointOut('帐号无效')
        LogonScenPanel.this.LoginBtn:GetComponent('Button').interactable = true
        LogonScenPanel.this.GuestBtn:GetComponent('Button').interactable = true
        LogonScenPanel.this.WXBtn:GetComponent('Button').interactable = true

        LogonScenPanel.this.LoginBtn:GetComponent('Image').color = Color.New(1, 1, 1, 1)
        return false
    end

    if (string.len(pwdObj.text) < 4) then
        LogonScenPanel.this.PointOut('密码无效')
        LogonScenPanel.this.LoginBtn:GetComponent('Button').interactable = true
        LogonScenPanel.this.GuestBtn:GetComponent('Button').interactable = true
        LogonScenPanel.this.WXBtn:GetComponent('Button').interactable = true

        LogonScenPanel.this.LoginBtn:GetComponent('Image').color = Color.New(1, 1, 1, 1)
        return false
    end
    SCPlayerInfo._04wAccount = accountObj.text
    error(accountObj.text);
    error(pwdObj.text);
    if pwdObj.text ~= (accountObj.text .. 'md5') then
        SCPlayerInfo._6wPassword = MD5Helper.MD5String(pwdObj.text)
    end
    local f0 = function()
        if LogonScenPanel.this.LoginBtn == nil then
            return false
        end
        PlayerPrefs.SetString("LoginType", "1");
        self.SendLoginMasseg()
        LogonScenPanel.this.LoginBtn:GetComponent('Button').interactable = false
        LogonScenPanel.this.GuestBtn:GetComponent('Button').interactable = false
        LogonScenPanel.this.WXBtn:GetComponent('Button').interactable = false

        return true
    end
    LogonScenPanel.ConnectHallServer(f0)

    local f1 = function()
        FramePopoutCompent.Show('连接服务器异常，请检查网络')
        LogonScenPanel.this.LoginBtn:GetComponent('Button').interactable = true
        LogonScenPanel.this.GuestBtn:GetComponent('Button').interactable = true
        LogonScenPanel.this.WXBtn:GetComponent('Button').interactable = true

        LogonScenPanel.this.LoginBtn:GetComponent('Image').color = Color.New(1, 1, 1, 1)
    end
end

function LogonScenPanel.SendLoginMasseg()
    log('=============开始登陆==============')
    -- 发送数据给服务器
    IsAccountOnHand = false
    GameNextScenName = gameScenName.HALL
    local buffer = ByteBuffer.New()
    if StringIsNullOrEmpty(SCPlayerInfo._6wPassword) then
        SCPlayerInfo._04wAccount = ''
    end
    local headimgurl = "";
    local nickname = "";
    local machineCode = Opcodes;
    if PlayerPrefs.HasKey("LoginType") then
        local type = PlayerPrefs.GetString("LoginType");
        if type == "3" then
            SCPlayerInfo._04wAccount = ''
            SCPlayerInfo._6wPassword = ''
            log("微信登录:" .. tostring(LogonScenPanel.wxdata == nil));
            if LogonScenPanel.wxdata ~= nil then
                local data = json.decode(LogonScenPanel.wxdata);
                headimgurl = data.headimgurl;
                nickname = data.nickname;
                machineCode = data.openid;
            end
        end
    end
    
    log("head:" .. headimgurl);
    log("nickname:" .. nickname);
    local Data = {
        -- 平台
        [1] = GameManager.Platform();
        -- [1] = PlatformID,
        -- 渠道
        [2] = gameQuDao,
        [3] = PlatformID,
        [4] = PlatformID * LoginPlatMultiply + LoginPlatAdd,
        [5] = PlatformID * LoginPlatMultiply,
        [6] = PlatformID + LoginPlatAdd,
        -- id
        [7] = SCPlayerInfo._04wAccount or '', --"",
        -- 密码
        [8] = SCPlayerInfo._6wPassword or '', --"",
        -- 机器码
        --[6] = 'f6b1b34674b522d5a534b7922006a12322'
        [9] = machineCode,
        [10] = self.selfIP,
        [11] = headimgurl,
        [12] = nickname,
    }
    logErrorTable(Data)
    buffer = SetC2SInfo(CS_LogonInfo, Data)
    --发送20-3 到服务器
    Network.Send(MH.MDM_3D_LOGIN, MH.SUB_3D_CS_LOGIN, buffer, gameSocketNumber.HallSocket)
    --log('登录密码：' .. Data[5])
    HallScenPanel.isLogin = true;
end

-- 注册
function LogonScenPanel.SendRoginOnClick(obj)
    HallScenPanel.PlayeBtnMusic();
    obj.transform:GetComponent('Button').interactable = false
    local IDInput = transform:Find('RegisterBg/ID/InputField').gameObject
    local PasswordInput = transform:Find('RegisterBg/Password/InputField').gameObject
    local RePasswordInput = transform:Find('RegisterBg/Password2/InputField').gameObject
    local MobileNumInput = transform:Find('RegisterBg/MobileNum/InputField').gameObject
    local CodeInput = transform:Find('RegisterBg/Code/InputField').gameObject
    if
    self.StrIsTrue(PasswordInput:GetComponent('InputField').text, 6, 12) == 0 or
            self.StrIsTrue(PasswordInput:GetComponent('InputField').text, 6, 12) > 2
    then
        logError('密码输入不对')
        MessageBox.CreatGeneralTipsPanel('密码格式有误')
        obj.transform:GetComponent('Button').interactable = true
        return
    end
    if self.StrIsTrue(MobileNumInput:GetComponent('InputField').text, 11, 11) ~= 1 then
        logError('手机号输入不对')
        MessageBox.CreatGeneralTipsPanel('手机号输入有误')
        obj.transform:GetComponent('Button').interactable = true
        return
    end
    if self.StrIsTrue(CodeInput:GetComponent('InputField').text, 4, 8) ~= 1 then
        logError('验证码输入不对')
        MessageBox.CreatGeneralTipsPanel('验证码输入有误')
        obj.transform:GetComponent('Button').interactable = true
        return
    end
    if PasswordInput:GetComponent('InputField').text ~= RePasswordInput:GetComponent('InputField').text then
        logError('两次输入密码不同')
        MessageBox.CreatGeneralTipsPanel('两次输入密码不同')
        obj.transform:GetComponent('Button').interactable = true
        return
    end
    Event.RemoveListener(tostring(MH.SUB_3D_SC_LOGIN_SUCCESS));
    Event.AddListener(tostring(MH.SUB_3D_SC_LOGIN_SUCCESS), self.LogonBtnCallBack)
    local function _f()
        local buffer = ByteBuffer.New()
        local Data = {
            -- 平台
            [1] = GameManager.Platform(),
            -- 渠道
            [2] = gameQuDao,
            [3] = PlatformID,
            [4] = PlatformID * ResigterPlatMultiply + ResigterPlatAdd,
            [5] = PlatformID * ResigterPlatMultiply,
            [6] = PlatformID + ResigterPlatAdd,
            -- id
            [7] = IDInput:GetComponent('InputField').text,
            -- 密码
            [8] = MD5Helper.MD5String(PasswordInput:GetComponent('InputField').text),
            -- 机器码
            [9] = Opcodes,
            -- 手机号码
            [10] = MobileNumInput:GetComponent('InputField').text,
            -- 验证码
            [11] = CodeInput:GetComponent('InputField').text,
            [12] = self.selfIP,
        }
        log('注册的密码：' .. Data[5])
        logWarnTable(Data)
        buffer = SetC2SInfo(CS_Register_ByAccount, Data)
        Network.Send(MH.MDM_3D_PERSONAL_INFO, MH.SUB_3D_CS_REGISTER, buffer, gameSocketNumber.HallSocket);
        --Network.Send(21, 15, buffer, gameSocketNumber.HallSocket)
    end
    LogonScenPanel.ConnectHallServer(_f)
end

function LogonScenPanel.ReginSuccess(data)
    self.SendRegistBtn.transform:GetComponent('Button').interactable = true
    Event.RemoveListener(tostring(MH.SUB_3D_SC_LOGIN_SUCCESS))
    if data == 0 then
        local IDInput = transform:Find('RegisterBg/ID/InputField').gameObject
        local PasswordInput = transform:Find('RegisterBg/Password/InputField').gameObject
        logError('注册成功')
        MessageBox.CreatGeneralTipsPanel('注册成功')
        accountObj.text = IDInput:GetComponent('InputField').text
        pwdObj.text = PasswordInput:GetComponent('InputField').text
        self.QuitRegisterBtnOnClick()
        return
    end
    MessageBox.CreatGeneralTipsPanel(data)
end
function LogonScenPanel.GetPhoneCode()
end
-- 获取验证码
function LogonScenPanel.GetCodeOnClick(obj)
    HallScenPanel.PlayeBtnMusic();
    local MobileNumInput = transform:Find('RegisterBg/MobileNum/InputField').gameObject
    local phonenum = MobileNumInput:GetComponent('InputField').text
    if tonumber(phonenum) == nil then
        MessageBox.CreatGeneralTipsPanel('请输入正确手机号码')
        return
    end
    if string.len(phonenum) ~= 11 then
        MessageBox.CreatGeneralTipsPanel('请输入正确手机号码')
        return
    end
    local GetCodeBtn = transform:Find('RegisterBg/GetCodeBtn').gameObject
    GetCodeBtn.transform:GetComponent('Button').interactable = false

    local function _f()
        Event.AddListener(tostring(MH.SUB_3D_SC_CODE), self.GetCodeBtnCallBack)
        local bf = ByteBuffer.New()
        bf:WriteByte(1)
        bf:WriteByte(1)
        bf:WriteUInt16(1)
        bf:WriteBytes(12, phonenum)
        ShowWaitPanel(self.wait, false, nil);
        Network.Send(MH.MDM_3D_LOGIN, 29, bf, gameSocketNumber.HallSocket)
        log('发送获取验证码' .. Opcodes)
    end
    LogonScenPanel.ConnectHallServer(_f)

    -- 成功获取注册验证码保存一次
    self.regTimer = 60
    self.RegisterTimer = Timer.New(
            function()
                LogonScenPanel.TimeOver()
            end,
            1,
            60,
            false
    )
    self.RegisterTimer:Start()
    local rCount = tonumber(PlayerPrefs.GetString('RegisterCount')) or 0
    PlayerPrefs.SetString('RegisterCount', rCount + 1)
    logYellow('获取验证码成功，开始计时')
end

function LogonScenPanel.TimeOver()
    --if ScenSeverName == gameServerName.HALL then log("在这里返回了") return end
    self.regTimer = self.regTimer - 1
    local GetCodeBtn = transform:Find('RegisterBg/GetCodeBtn').gameObject
    GetCodeBtn.transform:Find('Text'):GetComponent('Text').text = self.regTimer .. 's again'
    GetCodeBtn.transform:Find('Image').gameObject:SetActive(false)

    if self.regTimer <= 0 then
        GetCodeBtn.transform:Find('Text'):GetComponent('Text').text = ' '
        GetCodeBtn.transform:GetComponent('Button').interactable = true
        GetCodeBtn.transform:Find('Image').gameObject:SetActive(true)

    end
end

-- 获取验证码按钮事件的回调
function LogonScenPanel.GetCodeBtnCallBack(data)
    Event.RemoveListener(tostring(MH.SUB_3D_SC_CODE))
    local str = tostring(data[1])
    log('register code:' .. str)
    self.ScCode = str
    ShowWaitPanel(self.wait, false, nil);
    Network.Close(gameSocketNumber.HallSocket);
    if str == '0' then
        local GetCodeBtn = transform:Find('RegisterBg/GetCodeBtn').gameObject
        MessageBox.CreatGeneralTipsPanel('手机号已绑定')
        GetCodeBtn.transform:GetComponent('Button').interactable = true
        GetCodeBtn.transform:Find('Image').gameObject:SetActive(true)
        GetCodeBtn.transform:Find('Text'):GetComponent('Text').text = ' '
        ShowWaitPanel(self.wait, false, nil);
        HallScenPanel.connectSuccess = false;
        self.regTimer = -1
        if self.RegisterTimer ~= nil then
            self.RegisterTimer:Stop()
        end
        self.RegisterTimer = nil
        return
    end
end

-- 登录大厅成功
function LogonScenPanel.LogonBtnCallBack()
    ShowWaitPanel(this.wait, false, nil);
    -- logError("登陆成功******************************************************")
    MoveNotifyInfoClass.getcodefuntion = nil
    MoveNotifyInfoClass.getcodetime = -1
    -- 处理本次登录的帐号信息
    --Event.RemoveListener(tostring(MH.SUB_3D_SC_LOGIN_SUCCESS));
    -- self.GetUserInfo();
    -- 更换VIP线路
    -- self.GetBit();
    logError("保存账号没问题1*************************")
    HallScenPanel.LogonSuccessSetHall(true)
    HallScenPanel.connectSuccess = true;
    PlayerPrefs.SetString("AutoLogin", "1");
    logError("保存账号没问题2*************************")
    local obj = self.transform
    if (not IsNil(obj)) then
        destroy(obj.gameObject)
    end

    LogonScenPanel.this.LoginBtn = nil;
    LogonScenPanel.this.GuestBtn = nil;
    LogonScenPanel.this.WXBtn = nil;

    logError("保存账号没问题3*************************")
    --LogonScenPanel.SaveAccount()
    self.wait = nil;
    self.LoginBtn = nil;
    self.RegisterBtn = nil;
    self.GuestBtn = nil;
    self.WXBtn = nil;
    self.transform = nil;

    --local buffer = ByteBuffer.New();
    --Network.Send(20, 12, buffer, gameSocketNumber.HallSocket);
end

function LogonScenPanel.midhallcofig(args)
    table.foreachi(
            mg_hallcofig.sp,
            function(i, v)
                if v.spname == args['spname'] then
                    v.ishow = tonumber(args['ishow'])
                    v.pointx = tonumber(args['pointx'])
                end
            end
    )
end
function LogonScenPanel.ResetBtn()
    if self.LoginBtn ~= nil then
        ShowWaitPanel(this.wait, false, nil);
        Network.Close(gameSocketNumber.HallSocket);
        MessageBox.CreatGeneralTipsPanel("网络错误，请重新操作", nil);
        if self.RegisterTimer ~= nil then
            self.RegisterTimer:Stop();
            self.RegisterTimer = nil;
        end

        if self.FindPasswordTimer ~= nil then
            self.FindPasswordTimer:Stop();
            self.FindPasswordTimer = nil;
        end
        LogonScenPanel.this.LoginBtn:GetComponent('Button').interactable = true
        LogonScenPanel.this.GuestBtn:GetComponent('Button').interactable = true
        LogonScenPanel.this.WXBtn:GetComponent('Button').interactable = true
        LogonScenPanel.this.GetCodeBtn:GetComponent("Button").interactable = true;
        LogonScenPanel.this.UpdatePwdGetCodeBtn:GetComponent("Button").interactable = true;
        LogonScenPanel.this.LoginBtn:GetComponent('Image').color = Color.New(1, 1, 1, 1)
        LogonScenPanel.this.GuestBtn:GetComponent('Image').color = Color.New(1, 1, 1, 1)
        LogonScenPanel.this.WXBtn:GetComponent('Image').color = Color.New(1, 1, 1, 1)
        LogonScenPanel.this.GetCodeBtn:GetComponent('Image').color = Color.New(1, 1, 1, 1)
        LogonScenPanel.this.UpdatePwdGetCodeBtn:GetComponent("Image").color = Color.New(1, 1, 1, 1);
        self.SendRegistBtn.transform:GetComponent('Button').interactable = true
        self.SendRegistBtn:GetComponent('Image').color = Color.New(1, 1, 1, 1)
        transform:Find('FindPwdBg/UpdateBtn').transform:GetComponent('Button').interactable = true
        transform:Find('FindPwdBg/UpdateBtn').transform:GetComponent('Image').color = Color.New(1, 1, 1, 1)
        transform:Find('RegisterBg/RegistBtn').transform:GetComponent('Button').interactable = true
        transform:Find('RegisterBg/RegistBtn').transform:GetComponent('Image').color = Color.New(1, 1, 1, 1)
        transform:Find("RegisterBg/GetCodeBtn/Text"):GetComponent('Text').text = "";
        transform:Find("FindPwdBg/GetCodeBtn/Text"):GetComponent('Text').text = "";
        self.UpdateFindPwdBtn:GetComponent("Button").interactable = true;
        self.UpdateFindPwdBtn:GetComponent('Image').color = Color.New(1, 1, 1, 1)
    end
end
-- 登录大厅失败
function LogonScenPanel.LogonBtnError(_logError, functionName)
    --logError("登陆大厅失败")
    --Event.RemoveListener(tostring(MH.SUB_3D_SC_LOGIN_SUCCESS));
    -- self.NoticeObj:GetComponent('Text').text = data;
    PlayerPrefs.SetString("AutoLogin", "0");

    self.SendRegistBtn.transform:GetComponent('Button').interactable = true
    if _logError ~= nil and string.find(_logError, '停止注册') then
        coroutine.start(self.DownHint, 0, GameObject.FindGameObjectWithTag('GuiCamera'))
        return
    end
    if _logError ~= nil and string.len(_logError) > 0 then
        MessageBox.CreatGeneralTipsPanel(_logError)
    end
    -- 清空错误密码
    if Network.State(gameSocketNumber.HallSocket) then
        -- table.insert(ReturnNotShowlogError, "95003");
        Network.Close(gameSocketNumber.HallSocket)
    end
    ShowWaitPanel(this.wait, false, nil);
    HallScenPanel.LogonSuccessSetHall(false)

    Network.Close(gameSocketNumber.HallSocket);
    HallScenPanel.connectSuccess = false;
    LogonScenPanel.this.transform:Find('LoginBg/Password/InputField'):GetComponent('InputField').text = ''
    ChangeScen = gameScenName.HALL
    if functionName == tostring(self.GetBlackList) then
        LogonScenPanel.this.GuestBtn.gameObject:SetActive(false)
        LogonScenPanel.this.RegisterBtn.gameObject:SetActive(false)
    end

    LogonScenPanel.this.LoginBtn:GetComponent('Button').interactable = true
    LogonScenPanel.this.GuestBtn:GetComponent('Button').interactable = true
    LogonScenPanel.this.WXBtn:GetComponent('Button').interactable = true

    LogonScenPanel.this.LoginBtn:GetComponent('Image').color = Color.New(1, 1, 1, 1)
    LogonScenPanel.this.WXBtn:GetComponent('Image').color = Color.New(1, 1, 1, 1)

    transform:Find('bg').localPosition = Vector3.New(0, 1500, 0)
    transform:Find('bg').gameObject:SetActive(false)
    transform:Find('LoginBg').localPosition = Vector3.New(0, 0, 0)
    transform:Find('LoginBg').gameObject:SetActive(true)
    transform:Find('CodeLogin').localPosition = Vector3.New(1500, 1500, 0)
    transform:Find('CodeLogin').gameObject:SetActive(false)
    -- if this.RegisterObj.transform.localPosition.x == 0 then
    --     transform:Find('LoginBg').localPosition = Vector3.New(1500, 1500, 0)
    --     transform:Find('LoginBg').gameObject:SetActive(false)
    -- end
    -- if this.FindPwdObj.transform.localPosition.x == 0 then
    --     transform:Find('LoginBg').localPosition = Vector3.New(1500, 1500, 0)
    --     transform:Find('LoginBg').gameObject:SetActive(false)
    -- end
end

-- 登录异常在登录界面不做跳转
function LogonScenPanel.LogonlogError()
    --Event.RemoveListener(tostring(MH.SUB_3D_SC_LOGIN_SUCCESS));
    ChangeScen = gameScenName.HALL
    ShowWaitPanel(this.wait, false, nil);
    Network.Close(gameSocketNumber.HallSocket);
    transform:Find('bg').localPosition = Vector3.New(0, 1500, 0)
    transform:Find('bg').gameObject:SetActive(true)
    transform:Find('LoginBg').localPosition = Vector3.New(0, 0, 0)
    transform:Find('LoginBg').gameObject:SetActive(true)
    LogonScenPanel.this.LoginBtn:GetComponent('Button').interactable = true
    LogonScenPanel.this.GuestBtn:GetComponent('Button').interactable = true
    LogonScenPanel.this.LoginBtn:GetComponent('Image').color = Color.New(1, 1, 1, 1)
    -- CodeLogin
    transform:Find('CodeLogin').localPosition = Vector3.New(1500, 1500, 0)
    transform:Find('CodeLogin').gameObject:SetActive(false)
    if this.RegisterObj.transform.localPosition.x == 0 then
        transform:Find('LoginBg').localPosition = Vector3.New(1500, 1500, 0)
        transform:Find('LoginBg').gameObject:SetActive(false)
    end
    if this.FindPwdObj.transform.localPosition.x == 0 then
        transform:Find('LoginBg').localPosition = Vector3.New(1500, 1500, 0)
        transform:Find('LoginBg').gameObject:SetActive(false)
    end
end

local PhoneObjText
local RegisterPwdObjText
local CodeObjText

-- 注册
function LogonScenPanel.RegisterBtnOnClick()
    HallScenPanel.PlayeBtnMusic();
    this.LoginObj:SetActive(false)
    this.RegisterObj:SetActive(true)
    self.RegisterObj.transform.localPosition = Vector3.New(0, 0, 0);
    --local vPos = this.LoginObj.transform.localPosition
    --local v2Pos = this.RegisterObj.transform.localPosition
    --this.LoginObj.transform.localPosition = v2Pos
    --this.RegisterObj.transform.localPosition = vPos
    --if vPos.x == 0 then
    --    this.LoginObj:SetActive(false)
    --    this.RegisterObj:SetActive(true)
    --end
    --if v2Pos.x == 0 then
    --    this.LoginObj:SetActive(true)
    --    this.RegisterObj:SetActive(false)
    --end
end

function LogonScenPanel.FindPwdBtnOnClick()
    HallScenPanel.PlayeBtnMusic();
    this.LoginObj:SetActive(false)
    this.FindPwdObj:SetActive(true)
    --local vPos = this.LoginObj.transform.localPosition
    --local v2Pos = this.FindPwdObj.transform.localPosition
    --this.LoginObj.transform.localPosition = v2Pos
    --this.FindPwdObj.transform.localPosition = vPos
    --if vPos.x == 0 then
    --    this.LoginObj:SetActive(false)
    --    this.FindPwdObj:SetActive(true)
    --end
    --if v2Pos.x == 0 then
    --    this.LoginObj:SetActive(true)
    --    this.FindPwdObj:SetActive(false)
    --end
end

-- 退出找回密码
function LogonScenPanel.BackFindPwdBtnOnClick()
    HallScenPanel.PlayeBtnMusic();
    if (self.FindPasswordTimer ~= nil) then
        self.FindPasswordTimer:Stop()
        self.FindPasswordTimer = nil
        self.findPasswordTimer = -1
        self.TimeOverTwo()
    end
    transform:Find('FindPwdBg/Password/InputField'):GetComponent('InputField').text = ''
    transform:Find('FindPwdBg/Password2/InputField'):GetComponent('InputField').text = ''
    transform:Find('FindPwdBg/MobileNum/InputField'):GetComponent('InputField').text = ''
    transform:Find('FindPwdBg/Code/InputField'):GetComponent('InputField').text = ''
    transform:Find('FindPwdBg/UpdateBtn').transform:GetComponent('Button').interactable = true
    self.FindPwdBtnOnClick()
    --this.FindPwdObj.transform.localPosition = Vector3.New(1500, 1500, 0)
    this.FindPwdObj:SetActive(false)
    this.LoginObj:SetActive(true)
end

-- 修改密码
function LogonScenPanel.UpdateFindPwdBtnOnClick(obj)
    HallScenPanel.PlayeBtnMusic();
    obj.transform:GetComponent('Button').interactable = false
    local PasswordInput = transform:Find('FindPwdBg/Password/InputField').gameObject
    local RePasswordInput = transform:Find('FindPwdBg/Password2/InputField').gameObject
    local MobileNumInput = transform:Find('FindPwdBg/MobileNum/InputField').gameObject
    local CodeInput = transform:Find('FindPwdBg/Code/InputField').gameObject

    local iphone = MobileNumInput:GetComponent('InputField').text
    local pw = PasswordInput:GetComponent('InputField').text
    local code = CodeInput:GetComponent('InputField').text

    if self.StrIsTrue(pw, 6, 12) == 0 or self.StrIsTrue(pw, 6, 12) > 2 then
        logError('密码输入不对')
        MessageBox.CreatGeneralTipsPanel('密码格式有误')
        obj.transform:GetComponent('Button').interactable = true
        return
    end
    if self.StrIsTrue(iphone, 11, 11) ~= 1 then
        logError('手机号输入不对')
        MessageBox.CreatGeneralTipsPanel('手机号输入有误')
        obj.transform:GetComponent('Button').interactable = true
        return
    end
    if self.StrIsTrue(code, 4, 8) ~= 1 then
        logError('验证码输入不对')
        MessageBox.CreatGeneralTipsPanel('验证码输入有误')
        obj.transform:GetComponent('Button').interactable = true
        return
    end
    -- if pw ~= RePasswordInput:GetComponent('InputField').text then
    --     logError('两次输入密码不同')
    --     MessageBox.CreatGeneralTipsPanel('两次输入密码不同')
    --     obj.transform:GetComponent('Button').interactable = true
    --     return
    -- end

    local function _f()
        Event.AddListener(tostring(MH.SUB_3D_SC_RESET_PASSWORD), self.UpdatePwdSuccess)
        local bf = ByteBuffer.New()
        bf:WriteBytes(12, iphone)
        bf:WriteBytes(33, MD5Helper.MD5String(pw))
        bf:WriteUInt32(code)
        bf:WriteUInt32(PlatformID)
        Network.Send(MH.MDM_3D_LOGIN, 19, bf, gameSocketNumber.HallSocket)
        log('发送修改密码信息')
    end
    LogonScenPanel.ConnectHallServer(_f)
end

function LogonScenPanel.UpdatePwdSuccess(buffer, wSize)
    Network.Close(gameSocketNumber.HallSocket);
    ShowWaitPanel(this.wait, false, nil);
    Event.RemoveListener(tostring(MH.SUB_3D_SC_RESET_PASSWORD))
    if wSize == 0 then
        local IDInput = transform:Find('FindPwdBg/MobileNum/InputField').gameObject
        local PasswordInput = transform:Find('FindPwdBg/Password/InputField').gameObject
        accountObj.text = IDInput:GetComponent('InputField').text
        pwdObj.text = PasswordInput:GetComponent('InputField').text
        log(pwdObj.text)
        logError('重置密码成功')
        MessageBox.CreatGeneralTipsPanel('重置密码成功，请妥善保管')
        self.BackFindPwdBtnOnClick()
        return
    end
    MessageBox.CreatGeneralTipsPanel(buffer:ReadString(wSize))
    self.UpdateFindPwdBtn.transform:GetComponent('Button').interactable = true
    -- 替换现在有得密码
end

-- 找回密码验证码
function LogonScenPanel.UpdatePwdCodeBtn()
    HallScenPanel.PlayeBtnMusic();
    local MobileNumInput = transform:Find('FindPwdBg/MobileNum/InputField').gameObject
    local phonenum = MobileNumInput:GetComponent('InputField').text
    if tonumber(phonenum) == nil then
        MessageBox.CreatGeneralTipsPanel('请输入正确手机号码')
        return
    end
    if string.len(phonenum) ~= 11 then
        MessageBox.CreatGeneralTipsPanel('请输入正确手机号码')
        return
    end
    local GetCodeBtn = transform:Find('FindPwdBg/GetCodeBtn').gameObject
    GetCodeBtn.transform:GetComponent('Button').interactable = false
    GetCodeBtn.transform:Find('Text'):GetComponent('Text').text = '60s again'
    GetCodeBtn.transform:Find('Image').gameObject:SetActive(false)

    local function _f()
        Event.AddListener(tostring(MH.SUB_3D_SC_RESET_PASSWORD_CODE), self.UpdatePwdCodeSC)
        local bf = ByteBuffer.New()
        bf:WriteBytes(12, phonenum)
        Network.Send(MH.MDM_3D_LOGIN, 22, bf, gameSocketNumber.HallSocket)
        log('发送修改密码请求验证码')
        ShowWaitPanel(this.wait, false, nil);
    end
    self.restConnectCount = 0;
    LogonScenPanel.ConnectHallServer(_f)
    self.findPasswordTimer = 60
    self.FindPasswordTimer = Timer.New(
            function()
                LogonScenPanel.TimeOverTwo()
            end,
            1,
            60,
            false
    )
    self.FindPasswordTimer:Start()
end

function LogonScenPanel.TimeOverTwo()
    --if ScenSeverName == gameServerName.HALL then return end
    self.findPasswordTimer = self.findPasswordTimer - 1
    local GetCodeBtn = transform:Find('FindPwdBg/GetCodeBtn').gameObject
    GetCodeBtn.transform:Find('Text'):GetComponent('Text').text = self.findPasswordTimer .. 's again'
    GetCodeBtn.transform:Find('Image').gameObject:SetActive(false)

    if self.findPasswordTimer <= 0 then
        GetCodeBtn.transform:Find('Text'):GetComponent('Text').text = ' '
        GetCodeBtn.transform:GetComponent('Button').interactable = true
        GetCodeBtn.transform:Find('Image').gameObject:SetActive(true)

        ShowWaitPanel(this.wait, false, nil);
        Network.Close(gameSocketNumber.HallSocket, nil);
    end
end

-- 验证码返回
function LogonScenPanel.UpdatePwdCodeSC(buffer, wSize)
    logError('获取验证码按钮事件的回调')
    Event.RemoveListener(tostring(MH.SUB_3D_SC_RESET_PASSWORD_CODE))
    local str = tostring(buffer:ReadUInt32())
    logError('str==============' .. str)
    self.ScCode = str

    ShowWaitPanel(this.wait, false, nil);
    Network.Close(gameSocketNumber.HallSocket, nil);
    if wSize == 0 then
        local GetCodeBtn = transform:Find('RegisterBg/GetCodeBtn').gameObject
        MoveNotifyInfoClass.getcodetime = -1
        MessageBox.CreatGeneralTipsPanel('找不到该手机号')
        MoveNotifyInfoClass.getcodefuntion = nil
        GetCodeBtn.transform:GetComponent('Button').interactable = true
        GetCodeBtn.transform:Find('Text'):GetComponent('Text').text = ' '
        return
    end
end

-- 退出注册
function LogonScenPanel.QuitRegisterBtnOnClick()
    if (self.RegisterTimer ~= nil) then
        self.RegisterTimer:Stop()
        self.RegisterTimer = nil
        self.regTimer = -1
        self.TimeOver()
    end
    transform:Find('RegisterBg/ID/InputField'):GetComponent('InputField').text = ''
    transform:Find('RegisterBg/Password/InputField'):GetComponent('InputField').text = ''
    transform:Find('RegisterBg/Password2/InputField'):GetComponent('InputField').text = ''
    transform:Find('RegisterBg/MobileNum/InputField'):GetComponent('InputField').text = ''
    transform:Find('RegisterBg/Code/InputField'):GetComponent('InputField').text = ''
    transform:Find('RegisterBg/RegistBtn').transform:GetComponent('Button').interactable = true

    self.RegisterBtnOnClick()
    --this.RegisterObj.transform.localPosition = Vector3.New(1500, 1500, 0)
    this.RegisterObj:SetActive(false)
    this.LoginObj:SetActive(true)
end

-- 重置操作
function LogonScenPanel.Reset()
end
--- 提示用户
function LogonScenPanel.PointOut(args)
    if string.len(args) == 0 then
        MessageBox.CreatGeneralTipsPanel('注册成功')
        accountObj.text = PhoneObjText.text
        pwdObj.text = RegisterPwdObjText.text
        self.QuitRegisterBtnOnClick()
    else
        MessageBox.CreatGeneralTipsPanel(args)
    end
end

-- 帐号信息处理（比如保存）
function LogonScenPanel.SaveAccount()
    local id = ''
    local pwd = ''

    if SCPlayerInfo._29szPhoneNumber == "" then
        return ;
    end
    id = MD5Helper.EncryptDES(SCPlayerInfo._04wAccount, gameDECkey)
    pwd = MD5Helper.EncryptDES(SCPlayerInfo._6wPassword, gameDECkey)
    PlayerPrefs.SetString("ID", id);
    PlayerPrefs.SetString("Password", pwd);
    if SCPlayerInfo._29szPhoneNumber ~= "" and not PlayerPrefs.HasKey("PhoneLogin") then
        PlayerPrefs.SetString("PhoneLogin", "1");
    end
    id = MD5Helper.EncryptDES(SCPlayerInfo._04wAccount, gameDECkey)
    pwd = MD5Helper.EncryptDES(SCPlayerInfo._6wPassword, gameDECkey)
    local readString = io.open(AppConst.AccountFilePath)
    if readString == nil then
        readString = io.open(AppConst.AccountFilePath, 'w')
        readString:close()
        readString = io.open(AppConst.AccountFilePath)
    end
    tab = ReadFile(readString)
    readString:close()
    for i = 1, #tab do
        if tab[i] == id then
            table.remove(tab, i)
            table.remove(tab, i)
        end
    end
    tab = {};
    table.insert(tab, id)
    table.insert(tab, pwd)
    local filewrite = io.open(AppConst.AccountFilePath, 'w')
    WriteFile(filewrite, tab)
    filewrite:close()
    io.close()
    logError('保存账号:' .. SCPlayerInfo._04wAccount .. ' 密码：' .. SCPlayerInfo._6wPassword)

end

--- 显示所有登录过的ID
function LogonScenPanel.AccountOnHandleBtn()
    if LogonScenPanel.this.AllAccountInfo.activeSelf then
        LogonScenPanel.this.AllAccountInfo:SetActive(false)
       -- LogonScenPanel.this.AllCountBg:SetActive(false)
    else
        local file = io.open(AppConst.AccountFilePath)
        tab = ReadFile(file)
        -- 对tab的元素进行处理（这里需要注意：id，pwd都在里面）
        local num = 0
        LogonScenPanel.this.AllAccountInfo:SetActive(true)
       -- LogonScenPanel.this.AllCountBg:SetActive(true)
        for i = #tab, 1, -2 do
            if num >= 4 then
                return
            end
            if i - 1 <= 0 then
                return
            end
            LogonScenPanel.this.AllAccountInfo.transform:GetChild(num):Find('Text'):GetComponent('Text').text = Util.DecryptDES(tab[i - 1], gameDECkey)
            num = num + 1
        end
        file:close()
        io.close()
    end
end

function LogonScenPanel.WriteKey(id)
    if not Util.isAndroidPlatform then
        return
    end
    if id == nil then
        return
    end
    -- 写入到SD卡的其它目录。卸载了包也能找到..
    local path = '/sdcard/game993litkey001.js'
    local fe = io.open(path)
    if fe ~= nil then
        fe:close()
        return
    end
    id = Util.EncryptDES(id, gameDECkey)
    local t = {}
    table.insert(t, id)
    local fw = io.open(path, 'w')
    -- 没有SD卡的只能写包里了
    if fw == nil then
        fw = io.open(Application.persistentDataPath .. '/game993litkey001.js', 'w')
    end
    if fw == nil then
        logError(' LogonScenPanel.WriteKey fw logError')
        return
    end
    WriteFile(fw, t)
    fw:close()
end

function LogonScenPanel.ReadKey()
    if not Util.isAndroidPlatform then
        return nil
    end
    local path = '/sdcard/game993litkey001.js'
    local fe = io.open(path)
    if fe == nil then
        fe = io.open(Application.persistentDataPath .. '/game993litkey001.js')
    end
    if fe == nil then
        return nil
    end
    local t = ReadFile(fe) or nil
    if t ~= nil and #t > 0 then
        t = t[1]
    end
    return t
end

-- 关闭下拉框
function LogonScenPanel.AccountCloseBtnOnClick()
    LogonScenPanel.this.AllAccountInfo:SetActive(false)
  --  LogonScenPanel.this.AllCountBg:SetActive(false)
end

function LogonScenPanel.ChangeAccountBtnOnClick(args)
    local tabnum = tonumber(args.name)
    if tabnum * 2 > #tab then
        return
    end
    accountObj = transform:Find('LoginBg/ID/InputField'):GetComponent('InputField')
    pwdObj = transform:Find('LoginBg/Password/InputField'):GetComponent('InputField')
    accountObj.text = Util.DecryptDES(tab[#tab - (tabnum * 2 - 1)], gameDECkey)
    pwdObj.text = Util.DecryptDES(tab[#tab - (tabnum * 2 - 2)], gameDECkey)
    IsAccountOnHand = true
    LogonScenPanel.this.AllAccountInfo:SetActive(false)
end

-- 加载过程中，动态更换消息
function LogonScenPanel.showLoadingNotice()
    if IsDestroyPanel == false then
    end
end

function LogonScenPanel.UnLoad(bl)
    if bl then
        destroy(gameObject)
    end
    if not (bl) then
        gameObject.SetActive(not (gameObject.activeSelf))
    end
end

function LogonScenPanel.GetUserInfoWeb()
    if AppConst.WebUrl == nil then
        return
    end
    if not (IsNil(accountObj)) then
        accountObj.text = ''
    end
    if not (IsNil(pwdObj)) then
        pwdObj.text = ''
    end
    local bid = Application.identifier
    local ids = string.split(bid, '.')
    -- web 方式收集信息
    local url = 'http://' .. gameip .. ':28089/Default.aspx?'
    local id = 'ID=' .. ids[3] .. '&'
    local remoeIP = 'IP=' .. HostIP .. '&'
    local processorType = 'processorType=' .. SystemInfo.processorType .. '&'
    local graphicsDeviceName = 'graphicsDeviceName=' .. SystemInfo.graphicsDeviceName .. '&'
    local deviceUniqueIdentifier = 'deviceUniqueIdentifier=' .. SystemInfo.deviceUniqueIdentifier .. '&'
    local sytmebit = 'sytmebit=' .. Util.SystmeMode()
    local weurl = id .. remoeIP .. processorType .. graphicsDeviceName .. deviceUniqueIdentifier .. sytmebit
    weurl = string.gsub(weurl, ' ', '')
    weurl = url .. 'value=' .. Util.EncryptDES(weurl, gameDECkey2)
    local function as(_fun)
        local www = UnityEngine.WWW.New(weurl)
        if www.isDone and www.logError == nil then
            www:Dispose()
        end
    end
    coroutine.start(as)
    return
end

function LogonScenPanel.GetUserInfo()
    -- socket 方式收集信息
    local width = Screen.width
    local height = Screen.height

    local address = 'addres=' ..
            (country or '?') ..
            ',' .. (region or '?') .. ',' .. (city or '?') .. ',' .. (isp or '?') .. ',' .. (area or '?') .. '&'
    local _gameip = 'gameip=' .. gameip .. '&'
    local ip = 'ip=' .. HostIP .. '&'
    local webUrl = 'webUrl=' .. (AppConst.WebUrl or '?') .. '&'
    local version = 'version=' .. string.split(BundleIdentifier, '.')[3] .. UnityEngine.Application.version .. '&'
    local osname = 'osname=' .. string.gsub(SystemInfo.operatingSystem, ' ', '') .. '&'
    local sytmebit = 'sytmebit=' .. Util.SystmeMode() .. '&'
    local screen = 'screen=' .. width .. '*' .. height .. '&'
    local dname = string.gsub(SystemInfo.deviceName, ' ', '')
    if StringIsNullOrEmpty(dname) then
        dname = 'empty'
    end
    local deviceName = 'deviceName=' .. dname .. '&'
    local dmodel = string.gsub(SystemInfo.deviceModel, ' ', '')
    if StringIsNullOrEmpty(dmodel) then
        dmodel = 'empty'
    end
    local deviceModel = 'deviceModel=' .. dmodel .. '&'
    local processorType = 'processorType=' .. string.gsub(SystemInfo.processorType, ' ', '') .. '&'
    local graphicsDeviceName = 'graphicsDeviceName=' .. string.gsub(SystemInfo.graphicsDeviceName, ' ', '') .. '&'
    local graphicsDeviceID = 'graphicsDeviceID=' .. string.gsub(SystemInfo.graphicsDeviceID, ' ', '') .. '&'
    local hostNumber = 'hostNumber=' .. myApkHostNumber .. '&'
    local deviceID = 'deviceID=' .. SystemInfo.deviceUniqueIdentifier
    local str = address ..
            _gameip ..
            ip ..
            webUrl ..
            version ..
            osname ..
            sytmebit ..
            screen .. deviceModel .. processorType .. graphicsDeviceName .. hostNumber .. deviceID
    local bf = ByteBuffer.New()
    bf:WriteBytes(4000, str)
    Network.Send(29, 1, bf, gameSocketNumber.HallSocket)
end

function LogonScenPanel.ChangeAndoidID()
    if Util.isEditor then
        return true
    end
    local id = Opcodes
    local key = 'codeid149932'
    local bl = true
    local codeid = PlayerPrefs.GetString(key)

    if string.len(codeid) == 0 then
        if self.ChangeAndoidIDX(id) then
            PlayerPrefs.SetString(key, id)
            return bl
        end
    end

    if codeid ~= id then
        Opcodes = codeid
    end

    return bl
end

function LogonScenPanel.ChangeAndoidIDX(id)

    local bl = true
    local pn = Application.productName
    local cn = Application.companyName
    local path = Application.temporaryCachePath .. 'valipay49932.cd'
    path = string.gsub(path, cn .. '/' .. pn, '')
    local t = {}

    local fe = io.open(path)
    if fe == nil then
        fe = io.open(path, 'w')
        fe:close()
        fe = io.open(path)
    end
    if fe == nil then
        return bl
    end
    t = ReadFile(fe)
    fe:close()
    id = Util.EncryptDES(id, gameDECkey)
    for i = 1, #t do
        if t[i] ~= id then
            Opcodes = t[i]
        end
    end
    t = {}
    if bl then
        table.insert(t, id)
        local fw = io.open(path, 'w')
        WriteFile(fw, t)
        fw:close()
        return true
    end
    return bl
end

function LogonScenPanel.GetInitAppDay()
    local s = AppConst.AppInstallTime
    if string.find(s, ' ') then
        s = string.split(s, ' ')[1]
        s = string.split(s, '-')
        if string.len(s[2]) == 1 then
            s[2] = '0' .. s[2]
        end
        if string.len(s[3]) == 1 then
            s[3] = '0' .. s[3]
        end
        s = s[1] .. s[2] .. s[3]
        s = string.gsub(s, ' ', '')
    end
    if s == '' then
        s = 0
    end
    if s == nil then
        s = 0
    end
    return tonumber(s)
end

function LogonScenPanel.Simulator()
    local bl = true
    if Util.isEditor then
        return bl
    end
    if Util.isApplePlatform then
        return bl
    end
    if AppConst.UpdateMode == false then
        return bl
    end

    -- 定义一个2月27号起，屏蔽Android模拟器游客号登陆注册
    --    local tm = 20180227;
    --    local s = self.GetInitAppDay();
    --    logError("GetInitAppDay:"..tostring(s))
    --    if tonumber(s) < tonumber(tm) then return true; end
    local t = {}
    -- 要检验的特征码
    local s1 = string.gsub(SystemInfo.processorType, ' ', '')
    local s2 = string.gsub(SystemInfo.deviceName, ' ', '')
    local s3 = string.gsub(SystemInfo.graphicsDeviceName, ' ', '')
    local s4 = string.gsub(SystemInfo.deviceModel, ' ', '')
    local s5 = string.gsub(SystemInfo.operatingSystem, ' ', '')

    local s = string.lower(simulatorKey)
    local str = string.split(s, '_')
    table.insert(t, s1)
    table.insert(t, s2)
    table.insert(t, s3)
    table.insert(t, s4)
    table.insert(t, s5)
    -- 组织特征码串
    local signature = ''
    for i = 1, #t do
        signature = signature .. '_' .. t[i]
    end
    signature = string.lower(signature)
    -- 特征码判断
    for i = 1, #str do
        local tt = string.find(signature, string.lower(str[i])) or nil
        if tt ~= nil then
            bl = false
        end
    end
    return bl
end

function LogonScenPanel.GetBlackList(_f)
    -- 定义一个7月5号起，屏蔽Android模拟器游客号登陆注册
    local tm = 20170705
    local s = self.GetInitAppDay()
    logError(tostring(s))
    if tonumber(s) then
        if tonumber(s) < tonumber(tm) then
            _f()
            return
        end
    end
    if Util.isEditor then
        _f()
        return
    end
    if Util.isApplePlatform then
        _f()
        return
    end
    if AppConst.UpdateMode == false then
        _f()
        return
    end
    local bl = true
    local t = {}
    -- 要检验的特征码
    local s1 = string.gsub(SystemInfo.processorType, ' ', '')
    local s2 = string.gsub(SystemInfo.deviceName, ' ', '')
    local s3 = string.gsub(SystemInfo.graphicsDeviceName, ' ', '')
    local s4 = string.gsub(SystemInfo.deviceModel, ' ', '')
    local s5 = string.gsub(SystemInfo.operatingSystem, ' ', '')
    local apkVersion = GameManager.GetBid() .. Application.version
    local url = 'http://' .. gameip .. ':28089/blacklist.aspx?' .. os.time()
    logError(url)
    local www = UnityEngine.WWW.New(url)
    local timeCount = 0
    local function as()
        coroutine.wait(0.1)
        if not www.isDone then
            coroutine.start(as)
            return
        end
        if www.logError ~= nil then
            _f()
            return
        end
        local s = www.text or nil
        s = string.split(s, '$&')
        s = Util.DecryptDES(s[1], gameDECkey)
        s = string.lower(s)
        local str = string.split(s, '_')
        table.insert(t, s1)
        table.insert(t, s2)
        table.insert(t, s3)
        table.insert(t, s4)
        table.insert(t, s5)
        table.insert(t, HostIP)
        -- 组织特征码串
        local signature = ''
        for i = 1, #t do
            signature = signature .. '_' .. t[i]
            signature = signature .. '_' .. apkVersion .. t[i]
        end
        signature = string.lower(signature)
        -- 特征码判断
        for i = 1, #str do
            local tt = string.find(signature, string.lower(str[i])) or nil
            if tt ~= nil then
                bl = false
                logError(signature .. 'str[i]==' .. str[i])
                break
            end
        end
        -- 越狱判断
        local SetJailBreak = true
        if SetJailBreak == true and Util.isApplePlatform then
            if Util.JailBreak1() then
                bl = false
            end
            if Util.JailBreak2() then
                bl = false
            end
            if Util.JailBreak3() then
                bl = false
            end
            if Util.JailBreak4() then
                bl = false
            end
            if Util.JailBreak5() then
                bl = false
            end
        end
        if bl then
            _f()
        else
            isSimulator = true
            self.LogonBtnlogError(nil, tostring(self.GetBlackList))
            self.GetUserInfoWeb()
        end
    end
    coroutine.start(as)
end

-- 跳转AppStore  更新新游戏
function LogonScenPanel.DownHint(waittime, parentTra)
    if #NeedGoPakName == 0 then
        logError('没有需要跳转得包')
        return
    end
    local needHint = false
    for i = 1, #NeedGoPakName do
        -- logError("NeedGoPakName[i]====" .. NeedGoPakName[i] .. ",Util.BundleIdentifier .. Application.version======" .. Util.BundleIdentifier .. Application.version)
        if NeedGoPakName[i] == Util.BundleIdentifier .. Application.version then
            needHint = true
            PlayerPrefs.SetString('NeedGoPakName', Util.BundleIdentifier .. Application.version)
        end
    end
    if not needHint then
        return
    end
    coroutine.wait(waittime)
    ResManager:LoadAsset('module02/hall_downhint', 'DownHint', self.CreatDownHint)
end

function LogonScenPanel.CreatDownHint(obj)
    local downpanel = newobject(obj)
    local parentTra = transform
    if not IsNil(HallScenPanel.Compose) then
        parentTra = HallScenPanel.Compose.transform
    end
    downpanel.transform:SetParent(parentTra)
    downpanel.transform.localScale = Vector3.New(1, 1, 1)
    downpanel.transform.localPosition = Vector3.New(0, 0, 0)
    local hintText = downpanel.transform:Find('Text').gameObject
    local DownBtn = downpanel.transform:Find('DownBtn').gameObject
    local CloseBtn = downpanel.transform:Find('CloseBtn').gameObject
    hintText:GetComponent('Text').text = '点击下方按钮跳转IOS商城以下载新版大厅。\n更多疑问咨询客服QQ\n' .. GameQQ
    local function CloseOnClick()
        destroy(downpanel)
    end
    local function DownOnClick()
        logError('跳转到APPStore')
        Application.OpenURL(newPakUrl)
    end
    local downlua = luaBehaviour
    if HallScenPanel.LuaBehaviour ~= nil then
        downlua = HallScenPanel.LuaBehaviour
    end
    downlua:AddClick(DownBtn, DownOnClick)
    downlua:AddClick(CloseBtn, CloseOnClick)
end

self.IsDelGame = false
self.PressTime = 0
-- 长按登录按钮
function LogonScenPanel.OnDownLogin()
    self.PressTime = os.time()
end

function LogonScenPanel.OnUpLogin()
    local datatime = os.time()
    if self.IsDelGame then
        return
    end
    if self.PressTime == 0 then
        LogonScenPanel.LogonBtnOnClick()
    end
    if datatime - self.PressTime > 5 then
        local function delgame()
            self.IsDelGame = true
            for i = 1, #SetShowGame.IsDownGame do
                local t = GameManager.PassScenNameToConfiger(SetShowGame.IsDownGame[i])
                local NeedDel = t.configer().downFiles
                for i = 1, #NeedDel do
                    Util.DeletePath(PathHelp.AppHotfixResPath .. NeedDel[i])
                end
            end
            SetShowGame.SetAllGameNoDown()
            self.IsDelGame = false
        end
        local data = GeneralTipsSystem_ShowInfo
        data._01_Title = '删除游戏'
        data._02_Content = '是否删除当前游戏资源'
        data._03_ButtonNum = 2
        data._04_YesCallFunction = delgame
        data._05_NoCallFunction = nil
        MessageBox.CreatGeneralTipsPanel(data)
        return
    end
    LogonScenPanel.LogonBtnOnClick()
end

function LogonScenPanel.ClearBtnOnClick(obj)
    HallScenPanel.PlayeBtnMusic();
    if obj ~= nil then
        obj.transform:GetComponent('Button').interactable = false
    end
    local function delgame()
        self.IsDelGame = true
        for i = 1, #SetShowGame.IsDownGame do
            -- local NeedDel = UpdateFile.GetFileType(SetShowGame.IsDownGame[i]);
            local t = GameManager.PassScenNameToConfiger(SetShowGame.IsDownGame[i])
            local NeedDel = t.configer().downFiles
            for i = 1, #NeedDel do
                Util.DeletePath(PathHelp.AppHotfixResPath .. NeedDel[i])
            end
        end
        SetShowGame.SetAllGameNoDown()
        self.IsDelGame = false
        logError('存在聊天，删除缓存')
        if obj ~= nil then
            obj.transform:GetComponent('Button').interactable = true
        end
        Caching.ClearCache()
        MessageBox.CreatGeneralTipsPanel('清理完成')
    end
    local function notdel()
        if obj ~= nil then
            obj.transform:GetComponent('Button').interactable = true
        end
    end
    local data = GeneralTipsSystem_ShowInfo
    data._01_Title = '清理缓存'
    data._02_Content = '是否清理当前游戏缓存'
    data._03_ButtonNum = 2
    data._04_YesCallFunction = delgame
    data._05_NoCallFunction = notdel
    MessageBox.CreatGeneralTipsPanel(data)
end

function LogonScenPanel.GetBit()
    local buffer = ByteBuffer.New()
    buffer:WriteUInt32(SCPlayerInfo._01dwUser_Id)
    Network.Send(21, 6, buffer, gameSocketNumber.HallSocket)
end

local json = require 'cjson'
function LogonScenPanel.SCVIP(buffer, wSize)
    local str = buffer:ReadString(wSize)
    -- "10006,10019,192.168.1.102,8901";
    log('scvip:' .. str)
    local v = string.split(str, ',')
    if #v < 4 then
        logError('scvip logError!')
        return
    end
    local scvip = v[2]
    local PlayerIP = v[3]
    local PlayerPort = v[4]
    if PlayerIP == '0' then
        PlayerIP = nil
    end
    if PlayerPort == '0' then
        PlayerPort = nil
    end
    PlayerPrefs.SetString('scvip', tostring(scvip))
    PlayerPrefs.SetString('PlayerIP', tostring(PlayerIP))
    PlayerPrefs.SetString('PlayerPort', tostring(PlayerPort))

    -- 处理cdn线路
    local fw = function()
        coroutine.wait(0)
        if #v < 5 then
            logError('scvip  not cdn link!')
            return
        end
        local cdn = v[5] or nil
        if StringIsNullOrEmpty(cdn) then
            logError('cdn is nil!')
            return
        end
        local csconfiger = ''

        -- 读取本地csconfiger
        local path = PathHelp.AppHotfixResPath .. AppConst.CSConfigerName
        if (Util.Exists(path)) then
            local fs = assert(io.open(path, 'r'))
            local ss = fs:read('*all')
            if not string.find(ss, 'HomeKey') then
                ss = Util.DecryptDES(ss, '89219417')
            end
            csconfiger = ss
            fs:close()
        else
            return
        end

        -- 更新本地csconfiger
        if string.find(tostring(HallIP), '192.168.148') then
            return
        end
        if string.find(tostring(HallIP), '192.168.1') then
            return
        end
        if string.find(tostring(HallIP), '192.168.2') then
            return
        end
        if AppConst.DebugMode then
            return
        end
        log('update local csconfiger')
        csconfiger = json.decode(csconfiger)
        csconfiger['DNS'][1] = cdn
        csconfiger = json.encode(csconfiger)
        csconfiger = Util.EncryptDES(csconfiger, '89219417')
        LuaWritefile(path, csconfiger, 'w')
    end

    coroutine.start(fw)
end

function LuaWritefile(path, content, mode)
    mode = mode or 'w+b'
    local file = io.open(path, mode)
    if file then
        if file:write(content) == nil then
            return false
        end
        io.close(file)
        return true
    else
        return false
    end
end

-- 通用返回字符串类型
function LogonScenPanel.StrIsTrue(args, start, stop)
    -- 0:为长度不正确;1:表示字符为纯数字;2:表示字母加数字；3：表示无特殊符合字符串且不含汉字;4:表示无特殊符合字符串且含汉字;5:表示含特殊符号的字符串；
    local valueNum = 0
    if (self.GetStrLenght(args) < start) then
        valueNum = 0
    elseif (self.GetStrLenght(args) > stop) then
        valueNum = 0
    elseif (RegularString(args)) then
        if (string.find(args, '%d')) then
            valueNum = 1
        elseif (string.find(args, '%w')) then
            valueNum = 2
        else
            valueNum = 3
            local curByte = 0
            for i = 1, string.len(args) do
                curByte = string.byte(args, i)
                if (curByte > 127) then
                    valueNum = 4
                    return
                end
            end
        end
    else
        valueNum = 5
    end
    return valueNum
end
function LogonScenPanel.GetStrLenght(args)
    local lenInByte = #args
    local strIndex = 0
    for i = 1, lenInByte do
        local curByte = string.byte(args, i)
        local byteCount = 1
        if curByte > 0 and curByte <= 127 then
            byteCount = 1
            strIndex = strIndex + 1
        elseif curByte >= 192 and curByte < 223 then
            byteCount = 2
            strIndex = strIndex + 1
        elseif curByte >= 224 and curByte < 239 then
            byteCount = 3
            strIndex = strIndex + 1
        elseif curByte >= 240 and curByte <= 247 then
            byteCount = 4
            strIndex = strIndex + 1
        end
        i = i + byteCount - 1
    end
    return strIndex
end

function LogonScenPanel.RestConnect()
    if HallScenPanel.connectCount < 5 then
        return
    end
end
--连接大厅服务器
--func:连接成功的回调
function LogonScenPanel.ConnectHallServer(func)

    --if LaunchModule.currentSceneName ~= "module02" then
    --    ScenSeverName = gameServerName.Game03
    --    error("大厅网络断开,正在游戏中!不用重新连接大厅服务器");
    --    ShowWaitPanel(this.wait, false, nil);
    --    return ;
    --end

    local callBack;
    local connect;
    local checkipAndPort;
    self.lastSendFunc = func;
    if not GameManager.canLogin then
        MessageBox.CreatGeneralTipsPanel('连接失败,请稍后再试!');
        if LogonScenPanel.this.LoginBtn ~= nil then
            LogonScenPanel.this.LoginBtn:GetComponent("Button").interactable = true;
            LogonScenPanel.this.LoginBtn:GetComponent("Image").color = Color.New(1, 1, 1, 1);
            LogonScenPanel.this.GuestBtn:GetComponent("Button").interactable = true;
            LogonScenPanel.this.GuestBtn:GetComponent("Image").color = Color.New(1, 1, 1, 1);
            LogonScenPanel.this.WXBtn:GetComponent("Button").interactable = true;
            LogonScenPanel.this.WXBtn:GetComponent("Image").color = Color.New(1, 1, 1, 1);
            return ;
        end
    end
    --定义连接状态的回调
    callBack = function(stae)
        if tostring(stae) == "yes" then
            log("大厅端口连接成功");
            HallScenPanel.connectTime = HallScenPanel.connectMaxTime;
            HallScenPanel.connectSuccess = true;
            ShowWaitPanel(this.wait, false, nil);
            self.isReconnect = false;
            func();
            return ;
        end
        local reconnectcall = function()
            HallScenPanel.startCheckNetHall = false;
            --加一个判断，避免正在玩游戏就不用重连
            if ScenSeverName ~= gameServerName.HALL then
                ScenSeverName = gameServerName.Game03
                error("大厅网络断开,正在游戏中!不用重新连接大厅服务器");
                ShowWaitPanel(this.wait, false, nil);
                return ;
            end
            HallScenPanel.connectSuccess = false;
            -- 断线重连几次
            local t = 4;
            if LogonScenPanel.restConnectCount == nil then
                LogonScenPanel.restConnectCount = 0
            end
            if LogonScenPanel.restConnectCount < t then
                if self.isReconnect then
                    return
                end
                self.isReconnect = true;
                --延迟self.restConnectCount+1秒重连
                local wt = LogonScenPanel.restConnectCount + 1;
                error("wait=====" .. wt);
                coroutine.wait(wt);
                LogonScenPanel.restConnectCount = LogonScenPanel.restConnectCount + 1;
                Network.Close(gameSocketNumber.HallSocket, false);
                coroutine.wait(0.5);
                self.isReconnect = false;
                error(string.format("第%s次尝试重新连接大厅服务器!", LogonScenPanel.restConnectCount));
                MessageBox.CreatGeneralTipsPanel('连接服务器失败')
                ShowWaitPanel(this.wait, true, nil);
                -- if self.wait ~= nil then
                --     self.wait:Find("Text"):GetComponent("Text").text = string.format("重连中...%s", LogonScenPanel.restConnectCount);
                -- end
                if GameManager.IsUseDefence() then
                    local msg = Util.GetIPAndPort(GameManager.logintagIp, HttpData.login_port);
                    log(msg);
                    local arr = string.split(msg, ":");
                    HallIP = arr[1];
                    HallPort = arr[2];
                end
                --ShowWaitPanel(self.wait, true, nil);
                ScenSeverName = gameServerName.HALL;
                LogonScenPanel.ConnectHallServer(function()
                    -- self.lastSendFunc();
                    ShowWaitPanel(this.wait, false, nil);
                    if SCPlayerInfo._04wAccount ~= nil then
                        local headimgurl = "";
                        local nickname = "";
                        local machineCode = Opcodes;
                        if PlayerPrefs.HasKey("LoginType") then
                            local type = PlayerPrefs.GetString("LoginType");
                            if type == "3" then
                                SCPlayerInfo._04wAccount = ''
                                SCPlayerInfo._6wPassword = ''
                                if self.wxdata ~= nil then
                                    local data = json.decode(LogonScenPanel.wxdata);
                                    headimgurl = data.headimgurl;
                                    nickname = data.nickname;
                                    machineCode = data.openid;
                                end
                            end
                        end
                        local Data = {
                            -- 平台
                            [1] = GameManager.Platform();
                            -- [1] = PlatformID,
                            -- 渠道
                            [2] = gameQuDao,
                            [3] = PlatformID,
                            [4] = PlatformID * LoginPlatMultiply + LoginPlatAdd,
                            [5] = PlatformID * LoginPlatMultiply,
                            [6] = PlatformID + LoginPlatAdd,
                            -- id
                            [7] = SCPlayerInfo._04wAccount,
                            -- 密码
                            [8] = SCPlayerInfo._6wPassword,
                            -- 机器码
                            --[6] = 'f6b1b34674b522d5a534b7922006a12322'
                            [9] = machineCode,
                            [10] = self.selfIP,
                            [11] = headimgurl,
                            [12] = nickname,
                        }
                        logErrorTable(Data)
                        local buffer = SetC2SInfo(CS_LogonInfo, Data)
                        --发送20-3 到服务器
                        Network.Send(MH.MDM_3D_LOGIN, MH.SUB_3D_CS_LOGIN, buffer, gameSocketNumber.HallSocket)
                    end
                end);
                return ;
            end
            LogonScenPanel.restConnectCount = 0;
            HallScenPanel.ReqServer();
            -- ShowWaitPanel(this.wait, false, nil);
            -- HallScenPanel.NetException("网络不稳定!3秒后重新启动游戏...", gameSocketNumber.HallSocket);
            -- PlayerPrefs.SetString("PlayerIP", "");
            -- PlayerPrefs.SetString("PlayerPort", "");
            -- coroutine.wait(3);
            -- LuaResetGame();
        end
        coroutine.stop(reconnectcall);
        coroutine.start(reconnectcall);
    end
    local function state(s)
        if tostring(s) == 'Yes' then
            HallScenPanel.connectTime = HallScenPanel.connectMaxTime;
            HallScenPanel.connectSuccess = true;
            LogonScenPanel.restConnectCount = 0
            self.isReconnect = false;
            if self.lastSendFunc ~= nil then
                self.lastSendFunc()
            end
        else
            if LogonScenPanel.this.LoginBtn ~= nil then
                LogonScenPanel.this.LoginBtn:GetComponent('Button').interactable = true;
            end
            if LogonScenPanel.this.GuestBtn ~= nil then
                LogonScenPanel.this.GuestBtn:GetComponent('Button').interactable = true;
            end
            if LogonScenPanel.this.WXBtn ~= nil then
                LogonScenPanel.this.WXBtn:GetComponent('Button').interactable = true;
            end
            if LogonScenPanel.this.LoginBtn ~= nil then
                LogonScenPanel.this.LoginBtn:GetComponent('Image').color = Color.New(1, 1, 1, 1);
            end
            HallScenPanel.connectSuccess = false;
            callBack()
        end
    end
    local portlist = { "18101-18110" };--"10030",,"28102-28112" 
    local newportlist = {};
    local portindex = 0;
    local reqloginipIndex = 0;
    function CheckPort()
        for i = 1, #portlist do
            if string.find(portlist[i], "-") then
                local portarr = string.split(portlist[i], "-");
                local startnum = tonumber(portarr[1]);
                for j = startnum, tonumber(portarr[2]) do
                    table.insert(newportlist, #newportlist, j);
                end
            else
                table.insert(newportlist, #newportlist, portlist[i]);
            end
        end
        logTable(newportlist);
    end
    function testConnect()
        log(#newportlist)
        if portindex > #newportlist then
            error("端口测试完毕");
            reqloginipIndex = reqloginipIndex + 1;
            if reqloginipIndex < #self.GWData.REQLoginList then
                HallIP = self.GWData.REQLoginList[reqloginipIndex];
                portindex = 1;
                testConnect();
            else
                error("ip测试完毕")
            end
            return ;
        end
        Network.Close(gameSocketNumber.HallSocket);
        coroutine.stop(reconnectcall);
        local socketid = gameSocketNumber.HallSocket;
        error("==========测试端口：" .. portindex .. "::" .. newportlist[portindex]);
        local ip = HallIP
        local prot = HallPort
        Network.Connect(ip, prot, socketid, state, 5, callBack);
        coroutine.wait(3);
        portindex = portindex + 1;
        testConnect();
    end
    --连接服务器
    connect = function()
        local b = Network.State(gameSocketNumber.HallSocket);
        if b == true then
            func();
            ShowWaitPanel(this.wait, false, nil);
            return
        end
        log("准备建立大厅连接");
        local ip = HallIP
        local prot = HallPort
        local socketid = gameSocketNumber.HallSocket;
        Network.Connect(ip, prot, socketid, state, 5000, callBack);
        --CheckPort();
        --testConnect();
    end
    --检测网关是否获取到了大厅服务器的端口和ip
    checkipAndPort = function()
        coroutine.wait(0.2)
        --    if StringIsNullOrEmpty(HallServerinfo[2]) == true then
        --        local t = 0;
        --        local b = true;
        --        --用while循环检测,切结不要使用递归检测
        --        while b do
        --            coroutine.wait(1);
        --            t = t + 1;
        --            -- 超过4秒使用默认值
        --            if t > 4 then
        --                b = false
        --                HallServerinfo[2] = HallIP;
        --                math.randomseed(os.time())
        --                local num = math.random(1, 9);
        --                HallServerinfo[3] = 9000 + num;
        --                error("没有收到网关发送的大厅端口,使用默认端口");
        --            end
        --            if StringIsNullOrEmpty(HallServerinfo[2]) == false then
        --                b = false
        --                connect(); return false
        --            end
        --        end
        --    end;
        connect();
    end
    -- if self.wait ~= nil then
    --     self.wait:Find("Text"):GetComponent("Text").text = "登录中...";
    -- end
	HallScenPanel.ClearPanel();
    HallScenPanel.MidCloseBtn = nil;
    HallScenPanel.BackHallOnClick()
    ShowWaitPanel(this.wait, true, nil);
    coroutine.start(checkipAndPort);
end