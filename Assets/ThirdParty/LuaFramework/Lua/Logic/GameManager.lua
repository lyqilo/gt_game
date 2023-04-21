-------------------------------------------------------------Lua入口--------------------------------------------------------------
local json = require "cjson"
GameManager = {}
local this = GameManager
local self = GameManager
--HallIP = "47.108.163.71"
--HallIP = "192.168.101.3"

HallIP = "47.108.70.205"
HallPort = 28101
GCF = nil
WebAppInfo = nil

gameQuDao = Channel.AppSotre --渠道 1=AppSotre 2=c91 3=Test
gameIsOnline = true -- 游戏是否上线
gameIsNotice = true -- 是否显示游戏公告
gameIsUpdate = false -- 游戏是否需要更新
ScenSeverName = "" -- 记录当前所在的场景(服务器名字)
GameNextScen = nil -- 下一个场景对象
GameNextScenName = "" -- 下一个场景名字
CsWeburl = "" --  AppConst.WebUrl;
UrlHeadImg = "" -- 用户头像地址
Opcodes = "" -- 手机唯一码
HostIP = "192.168.10.159" -- 外网ip
country = "0000" -- 国家
region = "0000" -- 省份
city = "0000" -- 城市
isp = "0000" -- 电信移动联通
area = "0000" -- 地域，西南？
gameip = nil --游戏IP

BundleIdentifier = "com.sltx.game" --包名
apkNameBid = nil -- 包名最后一段
myApkHostNumber = -1
isOnEnable = false --能够登陆
GuiCamera = nil --GUI摄像机
gameIsShare = false -- 是否显示分享

NeedGoPakName = {} --新包的名字
newPakUrl = "" --新包地址

-- 删除游戏提示信息
Destroy_Panel = {} -- 删除游戏提示信息
HttpData = nil
PlatformID = 11
ResigterPlatMultiply = 12357;
ResigterPlatAdd = 79;
LoginPlatMultiply = 14596;
LoginPlatAdd = 61
this.isLogin = false
self.isUserDF = false;
this.IsTest = false --是否是测试坏境
--login.njnzw.cn
this.isLoadGameList = false
this.isEnterGame = false
this.IsStopGame = false
this.isQuitGame = false

self.logintagIp = "login.four.lehao";
self.gametagIp = "game.four.lehao";

SceneNmae = {}
self.ScreenRate = 1;
self.MoneyRate = 1;
function this.SetMoneyRate(rate)
    self.MoneyRate = rate;
end
function this.ReqMoneyRate()
    local function req()
        UnityWebRequestManager.Instance:GetText(AppConst.DNSUrl .. "/HttpConfiger.json", 5, function(code, result)
            if code == 200 then
                local msg = json.decode(MD5Helper.Decrypt(result, "Http"));
                local reqconfig = function(http)
                    local formdata = FormData.New();
                    formdata:AddField("cid", tostring(msg.platformId));
                    UnityWebRequestManager.Instance:Post(msg.HttpUrl .. "info/clientConf", 8, formdata, function(statusCode, configMsg)
                        if statusCode ~= 200 then
                            reqconfig(http);
                        else
                            local rateResult = json.decode(configMsg);
                            if (rateResult.code ~= 0) then
                                logError(rateResult.message);
                                return;
                            end
                            self.SetMoneyRate(rateResult.data.ratio);
                        end
                    end);
                end
                reqconfig(msg);
            else
                coroutine.start(function() 
                    coroutine.wait(0.5);
                    req();
                end)
            end
        end);        
    end
    req();
end
--初始化完成，发送链接服务器信息--
function this.StartGame()
    self.ReqMoneyRate();
    AppConst.Initialize = false;
    this.canLogin = false
    Util.GC();
    Application.targetFrameRate = 60;
    if Util.isPc or Util.isEditor then
        AppConst.HomeKey = false
    end
    -- self.ScreenRate = (1334 / 750) / (Screen.width / Screen.height);
    -- coroutine.start(f)
    -- this.WaitReq()
    if not GameManager.IsTest then
        -- local reporter = GameObject.Find("Reporter")
        -- if reporter ~= nil and not GameManager.IsTest then
        --     reporter:SetActive(false)
        -- end

        local reporter = GameObject.Find("Reporte")
        if reporter ~= nil and not GameManager.IsTest then
            reporter:SetActive(false)
        end
    end
    --LoadAsset("module02/Pool/font", "font");

    Network.OnDestroy()
    table.foreach(
            PanelListModeEven,
            function(k, v)
                PanelListModeEven[k] = GetEventIndex()
            end
    )
    HallScenPanel.IsConnectGame = true;
    HallScenPanel.restConnectCount = 0;
    HallScenPanel.OnReConnnect = false;
    MessgeEventRegister.Hall_Messge_Reg()
    VersionInfo[1] = GameManager.Platform()
    --this.OnInit()
end
function GameManager.IsUseDefence()
    return self.isUserDF and not self.IsTest and Util.IsGFInit() and HttpData ~= nil and HttpData.isOnline == "1";
end
function GameManager.OnInit()
    -- 给Opcodes（手机唯一标识码赋值）
    this.GetADID()
    --从文件读账号密码到UserInfo
    LogonScenPanel.initData()
    --连接服务器
    --this.Connect();
    Caching.ClearCache()
    --场景名字
    ChangeScen = nil
    --下一个场景名字
    GameNextScen = nil

    --如果不是Debug模式 调用C#那边的配置Helper 保存Config
    math.randomseed(os.time())
    if not AppConst.DebugMode then
        ConfigHelp.SaveConfig()
    end
    --提示文字，主要消息盒子用
    TishiTextInfo = {}
    --UI摄像机
    GuiCamera = GameObject.FindGameObjectWithTag("GuiCamera")
    --大厅场景（hallScen->非真实场景名字）
    ChangeScen = gameScenName.HALL
    --模块名字（真实场景名字）
    LaunchModule.currentSceneName = "module02"
    GameManager.GetAppInfo()
end
function GameManager.Formatnumberthousands(num)
    local function checknumber(value)
        return tonumber(value) or 0
    end
    local formatted = tostring(checknumber(num))
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then
            break
        end
    end
    return formatted
end
function GameManager.Connect()
    --创建一个list,往里面放一个域名：993game0.new123game.com:8903
    local Listips = list:new()
    Listips:push("192.168.1.7:29101")

    --远程地址
    local removeUrl = AppConst.WebUrl

    -- 内部函数,连接大厅服务器
    local function ContenServer()
        logError("开始连接服务器")
        coroutine.wait(0.2)
        local useport = "8901"
        local useip = "127.0.0.2"
        local contenState = false
        local a = function(state)
            if contenState then
                return
            end
            contenState = true
            local p = state or "Yes"
            if p == "No" then
                logError("连接服务器" .. HallIP .. ":" .. useport .. "失败")
                if Listips.length == 0 then
                    logError("没有正确获取到服务器ip,客户端重新启动!")
                    -- CsGameManager:ResetGame()
                    return
                end
                coroutine.start(ContenServer)
                return
            end
            if StringIsNullOrEmpty(AppConst.WebUrl) then
                logError("lua层设置AppConst.WebUrl")
                AppConst.WebUrl = "http://" .. useip .. ":28082/" .. AppConst.CdnDirectoryName .. "/" .. self.GetPlatformName() .. "/"
            end
            -- local buffer = ByteBuffer.New();
            -- buffer:WriteUInt16(0);
            -- Network.Send(1, 1, buffer, gameSocketNumber.LogonSoket);
            CsWeburl = AppConst.WebUrl
            -- 跳转到登陆界面
            coroutine.start(self.GetAppInfo)
            --coroutine.start(NetLog.StartLogPut);
            --this.Test()
        end
        if Listips.length > 0 then
            local str = Listips:pop()
            local t = string.split(str, ":")
            useip = t[1] or useip
            useport = t[2] or useport
        else
            logError("没有ip可以使用!")
        end
        gameip = useip
        HallIP = useip
        -- AppConst.Ip = useip;
        log(string.format("地址总数:%d,当前使用%s:%s", Listips.length + 1, useip, useport))
        Network.Connect(gameip, useport, 0, a, 7000)
    end

    -- 一个内部函数,读取本地进入游戏的ip
    local function ReadMR()
        logError("use  ReadMR  link")
        local hostip = PlayerPrefs.GetString("PlayerIP") or ""
        local hostport = PlayerPrefs.GetString("PlayerPort") or ""
        if not StringIsNullOrEmpty(hostip) then
            Listips:push(hostip .. ":" .. hostport)
        end
        -- local pt = self.GetPlatformName();
        coroutine.start(ContenServer)
    end

    -- 一个内部函数,通过cdn取游戏的入口ip
    local function ParseConfiger()
        removeUrl = string.gsub(removeUrl, "/iOS", "")
        removeUrl = string.gsub(removeUrl, "/Android", "")
        removeUrl = string.gsub(removeUrl, "/PC", "")
        removeUrl = string.gsub(removeUrl, "/ios", "")
        removeUrl = string.gsub(removeUrl, "/android", "")
        removeUrl = string.gsub(removeUrl, "/pc", "")
        local configerWebUrl = removeUrl .. "GameEnterConfiger.json?v=" .. os.date("%Y%m%d%H%M%S")
        local GetConfigerWebUrl = WWW.New(configerWebUrl)
        log("configerWebUrl: " .. configerWebUrl)
        coroutine.wait(0.2)
        if AppConst.WebUrl == nil then
            ReadMR()
            logError("ParseConfiger AppConst.WebUrl == nil")
            return
        end

        local time = 0
        while not GetConfigerWebUrl.isDone do
            coroutine.wait(0.3)
            time = time + 0.3
            if time > 5 then
                GetConfigerWebUrl:Dispose()
                logError("get GameEnterConfiger.json time out!!!")
                ReadMR()
                return
            end
        end

        -- 以防有的用户访问出错。可以多尝试一次
        if not StringIsNullOrEmpty(GetConfigerWebUrl.error) then
            if this.ParseConfigerCount < 2 then
                GetConfigerWebUrl:Dispose()
                coroutine.wait(0.3)
                this.ParseConfigerCount = this.ParseConfigerCount + 1
                coroutine.start(ParseConfiger)
                return
            end
            logError(GetConfigerWebUrl.error)
            ReadMR()
            return
        end

        local txt = GetConfigerWebUrl.text
        if not string.find(txt, "port") then
            txt = Util.DecryptDES(string.gsub(txt, "md5#", ""), "89219417")
        end
        -- log("GameEnterConfiger path:" .. txt)
        GCF = json.decode(txt) or nil
        if GCF == nil then
            logError("ParseConfiger GCF == nil")
            ReadMR()
            return
        end

        -- 黑名单用户不要他登陆游戏,主要通过机器码
        local blacklistUser = GCF["blacklist"] or {}
        local isBlackUser = false
        local code = this.GetOpcodes()
        for i = 1, #blacklistUser do
            if string.lower(code) == string.lower(blacklistUser[i]) then
                isBlackUser = true
            end
        end
        if isBlackUser then
            logError("黑名单用户不能登陆游戏！")
            return
        end

        -- 计算自己使用那边线路(总体规划了10条线路)
        local myNum = LuaStringToNumber(Opcodes)
        myNum = string.sub(myNum, string.len(myNum), -1)
        myNum = tonumber(myNum)
        if myNum == nil then
            myNum = 10
        end
        if myNum == 0 then
            myNum = 10
        end
        if myNum < 0 then
            myNum = 10
        end

        -- 如果有 就获取10条线路
        local port = (GCF["port"] or "8901")
        local ips = GCF["webips"]

        if #ips < myNum then
            myNum = myNum % 3
            if myNum == 0 then
                myNum = 3
            end
        end
        if #ips < myNum then
            myNum = myNum % 2
            if myNum == 0 then
                myNum = 2
            end
        end
        if #ips < myNum then
            myNum = 1
        end

        myApkHostNumber = myNum
        log("myNum:" .. tostring(myNum))

        if #ips >= myNum then
            local webip = ips[myNum]
            logError("webip1==" .. webip)
            if not StringIsNullOrEmpty(webip) then
                Listips:push(webip .. ":" .. port)
            end
        end

        local hostip = PlayerPrefs.GetString("PlayerIP") or ""
        local hostport = PlayerPrefs.GetString("PlayerPort") or ""
        logError("hostip==" .. hostip)

        if not StringIsNullOrEmpty(hostip) then
            Listips:push(hostip .. ":" .. hostport)
        end

        GetConfigerWebUrl:Dispose()
        coroutine.start(ContenServer)
    end

    -- 一个内部函数,获取客户端的ip地址。
    local function Parseip()
        coroutine.wait(0)
        local js = ""
        local ParseipCount = 0
        -- 淘宝获取ip接口
        local t1 = function(t1, t2)
            if ParseipCount > 2 then
                return
            end
            log("use 111 ip.taobao.com get ip")
            local www = WWW.New("http://ip.taobao.com/service/getIpInfo.php?ip=myip")
            local time = 0
            while not www.isDone do
                coroutine.wait(0.3)
                time = time + 0.3
                if time > 5 then
                    error("get ip time out!!!")
                    www:Dispose()
                    ParseipCount = ParseipCount + 1
                    t2(t1, t2)
                    return
                end
            end
            ParseipCount = ParseipCount + 1
            if not StringIsNullOrEmpty(www.error) then
                www:Dispose()
                t2(t1, t2)
                return
            end
            log("Parseip ok :" .. www.text)
            js = json.decode(www.text) or nil
            local ok = nil
            ok = json["code"]
            if ok == 0 then
                region = json["data"]["region"] or PlayerPrefs.GetString("region") or nil
                country = json["data"]["country"] or PlayerPrefs.GetString("country") or nil
                HostIP = json["data"]["ip"] or PlayerPrefs.GetString("HostIP") or nil
                city = json["data"]["city"] or "0000"
                isp = json["data"]["isp"] or "0000"
                area = json["data"]["area"] or "0000"
                if country ~= nil and country ~= "中国" then
                    region = "国外"
                end
                if region == "" then
                    region = nil
                end
                if region == nil then
                    region = "ip"
                end
                if country == "美国" then
                    gameIsOnline = false
                end
            end
            if region ~= nil then
                PlayerPrefs.SetString("region", region)
            end
            if region ~= nil then
                PlayerPrefs.SetString("country", country)
            end
            if region ~= nil then
                PlayerPrefs.SetString("HostIP", HostIP)
            end
            www:Dispose()
        end
        -- 搜狐获取ip接口
        local t2 = function(t1, t2)
            if ParseipCount > 2 then
                return
            end
            --  error("use pv.sohu.com/cityjson get ip");
            local www = WWW.New("http://pv.sohu.com/cityjson?ie=utf-8")
            local time = 0
            while not www.isDone do
                coroutine.wait(0.3)
                time = time + 0.3
                if time > 5 then
                    error("get ip time out!!!")
                    www:Dispose()
                    ParseipCount = ParseipCount + 1
                    t1(t1, t2)
                    return
                end
            end
            ParseipCount = ParseipCount + 1
            if not StringIsNullOrEmpty(www.error) then
                www:Dispose()
                t1(t1, t2)
                return
            end
            local txt = tostring(www.text)
            txt = string.gsub(txt, " ", "")
            txt = string.gsub(txt, "varreturnCitySN=", "")
            txt = string.gsub(txt, ";", "")
            js = json.decode(txt) or nil
            if json then
                HostIP = json["cip"] or "0000"
                country = json["cname"] or "0000"
                isp = HostIP
                region = ""
                area = ""
                city = ""
            end
            if region ~= nil then
                PlayerPrefs.SetString("region", region)
            end
            if region ~= nil then
                PlayerPrefs.SetString("country", country)
            end
            if region ~= nil then
                PlayerPrefs.SetString("HostIP", HostIP)
            end
            www:Dispose()
        end

        if not Util.isAndroidPlatform then
            coroutine.start(t1, t1, t2)
        else
            coroutine.start(t2, t1, t2)
        end
        this.ParseConfigerCount = 0
        coroutine.start(ParseConfiger)
    end

    -- 一个内部函数,检测底层是否获得了正确的cdn地址(就是确定AppConst.WebUrl="http://qp0.huishugou.com/Res/Android/")
    local function CheckWebUrl()
        if not StringIsNullOrEmpty(AppConst.WebUrl) then
            coroutine.start(Parseip)
            return
        end
        logError("底层没有正确获取cdn地址,启动从新获取")
        local cdn = {}
        -- 读取本地csconfiger
        local path = PathHelp.AppHotfixResPath .. AppConst.CSConfigerName
        if (Util.Exists(path)) then
            local fs = assert(io.open(path, "r"))
            local ss = fs:read("*all")
            if not string.find(ss, "port") then
                ss = Util.DecryptDES(ss, "89219417")
            end
            local csconfiger = ss
            fs:close()
            csconfiger = json.decode(csconfiger)
            table.insert(cdn, csconfiger["DNS"][1])
        end
        table.insert(cdn, "http://qp0.huishugou.com")

        for i = 1, #cdn do
            local constWebUrl = cdn[i] .. "/Res/"
            local www = WWW.New(constWebUrl .. "GameEnterConfiger.json?v=" .. os.date("%Y%m%d%H%M%S"))
            error("constWebUrl:" .. constWebUrl)
            while not www.isDone do
                coroutine.wait(0.3)
            end
            if StringIsNullOrEmpty(www.error) then
                AppConst.WebUrl = constWebUrl .. self.GetPlatformName() .. "/"
                removeUrl = AppConst.WebUrl
                coroutine.start(Parseip)
            end
            www:Dispose()
            if not StringIsNullOrEmpty(AppConst.WebUrl) then
                return
            end
        end
        coroutine.start(Parseip)
    end

    coroutine.start(CheckWebUrl)
end

function GameManager.ConnectCallBack(wMaiID, wSubID, buffer, wSize)
    logError("接收到网关服务器消息时间")
    log("接收到网关服务器消息时间=" .. Util.TickCount, 10)
    Event.RemoveListener(tostring(MH.InitializationLogon .. gameSocketNumber.LogonSoket))
    local dwIp = buffer:ReadString(buffer:ReadUInt16())
    local wListenPort = buffer:ReadUInt16()
    HallServerinfo[1] = ServerList.HallServer
    HallServerinfo[2] = HallIP
    -- 不要使用服务器传来的IP，只用端口
    HallServerinfo[3] = wListenPort

    if isSimulator then
        Event.AddListener(tostring(MH.SUB_3D_SC_LOGIN_SUCCESS), LogonScenPanel.LogonBtnCallBack)
        LogonScenPanel.SendLoginMasseg()
    end
end

function GameManager.Platform()
    if Util.isApplePlatform then
        --logError("isApplePlatform")
        return Platform.IOS
    elseif Util.isAndroidPlatform then
        --logError("isAndroidPlatform")
        return Platform.ANDROID
    else
        --logError("PC")
        return Platform.PC
    end
end

function GameManager.GetBid()
    if apkNameBid ~= nil then
        return apkNameBid
    end
    -- 获取机器唯一码，要加上包名的最后组,比如com.sjyt.ylc3d ,加ylc3d
    BundleIdentifier = UnityEngine.Application.identifier
    if StringIsNullOrEmpty(BundleIdentifier) then
        BundleIdentifier = "ttl.993game.hhijue"
        error("没有获取到APP包名,使用了默认值!")
    end
    local ids = string.split(BundleIdentifier, ".")
    apkNameBid = ids[3]
    return apkNameBid
end

function GameManager.GetADID()
    --Opcodes = Util.GetCodeMax()
    if Util.isApplePlatform then
        --Opcodes = this.GetBid() .. NetManager:GetIphoneADID();
        Opcodes = Util.getIosCode()
    else
        Opcodes = SystemInfo.deviceUniqueIdentifier
    end
end

function GameManager.GetOpcodes()
    if Util.isApplePlatform then
        return NetManager:GetIphoneADID()
    else
        return SystemInfo.deviceUniqueIdentifier
    end
end

function GameManager.CreateLue()
    local root = GameObject.FindGameObjectWithTag("rootHallModule")
    local hallObj = root.transform:Find("GuiCamera/HallScenPanel").gameObject
    Util.AddComponent("LuaBehaviour", hallObj)
end

function GameManager.GetAppInfo()
    --[[    local Ctime = 0.5;
   coroutine.wait(0.5);

    -----检测有没有线路
    while StringIsNullOrEmpty(AppConst.WebUrl) do
        if Ctime > 3 then error("没有服务器地址,游戏重新开始!"); CsGameManager:ResetGame(); return; end
        coroutine.wait(1);
        Ctime = Ctime + 1;
    end--]]
    ----检测配置是否获取到了游戏资源的配置
    --[[    Ctime = 0;
    while AppConst.gameValueConfiger.Version < 1 do
        if Ctime > 3 then error("get AppConst.gameValueConfiger error"); CsGameManager:ResetGame(); return; end
        coroutine.wait(1);
        Ctime = Ctime + 1;
    end
--]]
    ----检测配置是否获取到了大厅资源的配置
    --[[    Ctime = 0;
    while AppConst.valueConfiger.Version < 1 do
        if Ctime > 3 then error("get AppConst.valueConfiger error"); CsGameManager:ResetGame(); return; end
        coroutine.wait(1);
        Ctime = Ctime + 1;
    end--]]
    ----检测配置是否获取到了游戏设置的配置
    --[[    Ctime = 0;
    while AppConst.appInfoConfiger.Version < 1 do
        if Ctime > 3 then error("get AppConst.appInfoConfiger error"); CsGameManager:ResetGame(); return; end
        coroutine.wait(1);
        Ctime = Ctime + 1;
    end--]]
    --[[    local configer = AppConst.appInfoConfiger;
    local key = self.GetBid() .. Application.version;
    local baseConfiger = configer:GetValue(key);
    if baseConfiger == nil then
        error(key .. " appInfoConfiger not find!")
        if not Util.isApplePlatform then gameIsOnline = true; end
    end

    if baseConfiger ~= nil then
        gameIsOnline = baseConfiger.online;
        -- if region == "国外" then gameIsOnline = false; end
        WebAppInfo = baseConfiger;
    end--]]
    -- 有了配置就可以显示大厅了
    LoadSceneAsync(
            "module02",
            function(apt)
                while not apt.isDone do
                    coroutine.wait(0)
                end
                GameManager.CreateLue()
            end,
            1
    )
end

function GameManager.PassGameNameToConfiger(gameName)
    for key, value in pairs(LaunchModuleConfiger) do
        -- error("key================" .. key)
        if value.configer ~= nil then
            -- error("value.configer.gameName================" .. value.configer.gameName)
            if string.find(gameName, value.uiName) then
                return value
            end
        end
    end
end

function GameManager.PassScenNameToConfiger(scenName)
    -- error("GameManager.scenName==="..scenName);
    for key, value in pairs(LaunchModuleConfiger) do
        if string.find(scenName, value.scenName) then
            return value
        end
    end
end

function GameManager.PassClientIndexToConfiger(index)
    -- error("GameManager.index==="..index);
    for key, value in pairs(LaunchModuleConfiger) do
        -- logErrorTable(value);
        if tonumber(index) == tonumber(value.clientId) then
            return value
        end
    end
end

map_panel = {}
function GameManager.PanelRister(p)
    if not (IsNil(p)) and self.PanelIsExist(p.name) == nil then
        table.insert(map_panel, p)
    end
end

function GameManager.PanelInitSucceed(p)
    --LaunchModule.currentHallScene.gameObject:SetActive(false)
    if #map_panel == 1 then
        return
    end
    local NoUnload = "HallScenPanel"
    local removeIdx = -1
    for i = 1, #map_panel do
        if not (IsNil(map_panel[i])) then
            if map_panel[i].name ~= NoUnload then
                if p.name ~= map_panel[i].name then
                    -- map_panel[i].gameObject:SetActive(false);
                    destroy(map_panel[i])
                    removeIdx = i
                end
            else
                if p.name ~= NoUnload then
                    map_panel[i].gameObject:SetActive(false)
                end
            end
        end
    end
    if removeIdx > 0 then
        table.remove(map_panel, removeIdx)
    end
end

-- 设置当前面板不被删除
map_panelNoUnload = {}
function GameManager.PanelSetUnLoad(p)
    local noP = p or nil
    if noP ~= nil then
        if IsNil(p) then
            return
        end
        table.insert(map_panelNoUnload, p)
    end
end

-- 获取当前面板是否可以删除
function GameManager.PanelGetUnLoad(name)
    local bl = false
    for i = 1, #map_panelNoUnload do
        if name == map_panelNoUnload[i].name then
            bl = true
        end
    end
    return bl
end

function GameManager.PanelIsExist(name)
    local o = nil
    for i = 1, #map_panel do
        if not (IsNil(map_panel[i])) then
            if map_panel[i].name == name then
                o = map_panel[i]
            end
        end
    end
    return o
end

function GameManager.PanelInitFail(args)
end

function GameManager.DestroyPanel(obj)
    destroy(obj)
end

-- 游戏场景初始化完毕
function GameManager.GameScenIntEnd(obj)
    log(111111)
    GameSetsPanel.New().Create(obj)
end

-- 面板切换
function GameManager.ChangeScen(ScenName, isrc)
    local rc = isrc or false
    -- UpdateFile.Close();
    if ScenName == gameScenName.HALL then
        HallScenPanel.New().Open(rc)
        GameNextScenName = gameScenName.HALL
    end
    if ScenName == gameScenName.LOGON then
        LogonScenPanel.New().Create()
        GameNextScenName = gameScenName.LOGON
    end
end

-- 设置声音大小
function GameManager.SetSoundValue(soundVolume, musicVolume)
    MusicManager:SetValue(soundVolume, musicVolume)
end

-- 设置静音
function GameManager.SetIsPlayMute(sv, mv)
    MusicManager:SetPlaySM(sv, mv)
    --[[    logError("GameManager.SetIsPlayMute....sv=" .. tostring(sv) .. "  , mv=" .. tostring(mv));
        local musuic = find("GameManager"):GetComponent("AudioSource");
        musuic.mute =(not musuic.mute);
        MusicManager.isPlaySV = sv;
        MusicManager.isPlayMV = mv;--]]
end

local OnBackGameTiem = 0
local OnStopGameTiem = 0

function GameManager.OnBackGame()

    if LaunchModule.currentSceneName == "module06" then
        Event.Brocast(MH.Game_LEAVE);
    end

    --if Util.isEditor or Util.isPc then
    --    return
    --end
    -- if not (Util.isApplePlatform) and not (Util.isAndroidPlatform) then
    --     return
    -- end
    if OnStopGameTiem < 1 then
        return
    end
    OnBackGameTiem = os.time()
    local stopNum = OnBackGameTiem - OnStopGameTiem

    log("Focus返回游戏:" .. stopNum);
    if stopNum > 60 then
        log("后台运行时间过长,重启游戏");
        Util.ResetGame()
    else
        logYellow("ScenSeverName==" .. ScenSeverName)
        --if ScenSeverName == gameServerName.LOGON or ScenSeverName == gameServerName.HALL then
        --    return
        --end
        if HallScenPanel.connectSuccess then
            if not Network.State(gameSocketNumber.HallSocket) then
                Network.Close(gameSocketNumber.HallSocket);
                Network.Close(gameSocketNumber.GameSocket);
                if GameManager.IsUseDefence() then
                    local msg = Util.GetIPAndPort(GameManager.logintagIp, HttpData.login_port);
                    local arr = string.split(msg, ":");
                    HallIP = arr[1];
                    HallPort = arr[2];
                end
                ScenSeverName = gameServerName.HALL;
                LogonScenPanel.ConnectHallServer(function()
                    if SCPlayerInfo._04wAccount ~= nil then
                        local headimgurl = "";
                        local nickname = "";
                        local machineCode = Opcodes;
                        if PlayerPrefs.HasKey("LoginType") then
                            local type = PlayerPrefs.GetString("LoginType");
                            if type == "3" then
                                SCPlayerInfo._04wAccount = ''
                                SCPlayerInfo._6wPassword = ''
                                if LogonScenPanel.wxdata ~= nil then
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
                            [10] = LogonScenPanel.selfIP,
                            [11] = headimgurl,
                            [12] = nickname,
                        }
                        logErrorTable(Data)
                        local buffer = SetC2SInfo(CS_LogonInfo, Data)
                        --发送20-3 到服务器
                        Network.Send(MH.MDM_3D_LOGIN, MH.SUB_3D_CS_LOGIN, buffer, gameSocketNumber.HallSocket)
                    end
                    if LaunchModule.currentSceneName ~= "module02" and HallScenPanel.connectGameSuccess and not Network.State(gameSocketNumber.GameSocket) then
                        ScenSeverName = gameServerName.Game03;
                        if GameManager.IsUseDefence() then
                            local msg = Util.GetIPAndPort(GameManager.gametagIp, HallScenPanel.currentPort);
                            local arr = string.split(msg, ":");
                            HallScenPanel.gameip = arr[1];
                            HallScenPanel.gameport = arr[2];
                        end
                        log("重连游戏")
                        HallScenPanel.ConnectGameServer();
                    end
                end);
            end
        end
    end
end

--
function GameManager.OnStopGame()
    if Util.isEditor then
        return
    end
    if not (Util.isApplePlatform) and not (Util.isAndroidPlatform) then
        return
    end
    HallScenPanel.ClinetState = false
    ConfigHelp.SaveConfig()
    OnStopGameTiem = os.time()
    if Event.Exist(EventIndex.OnStopGame .. gameSocketNumber.GameSocket) then
        Event.Brocast(EventIndex.OnStopGame .. gameSocketNumber.GameSocket)
    end
end

function GameManager.OnApplicationFocus(isFocus)
    -- if Util.isEditor then
    --     return
    -- end
    error("OnApplicationFocus: " .. tostring(isFocus))
    --self.IsStopGame = not isFocus
    --logYellow("IsStopGame==" .. tostring(self.IsStopGame))
    --if LaunchModule.currentSceneName == "module55" then
    --    Event.Brocast(MH.Game_LEAVE);
    --end
    --if isFocus then
    --    GameManager.OnBackGame()
    --    return
    --end
    --GameManager.OnStopGame()
end

--- 退出当前程序
function GameManager.Quit()
    ConfigHelp.SaveConfig()
    Util.Quit()
end

function GameManager.andBit(left, right)
    --与
    return (left == 1 and right == 1) and 1 or 0
end

function GameManager.orBit(left, right)
    --或
    return (left == 1 or right == 1) and 1 or 0
end

function GameManager.xorBit(left, right)
    --异或
    return (left + right) == 1 and 1 or 0
end

function GameManager.base(left, right, op)
    --对每一位进行op运算，然后将值返回
    if left < right then
        left, right = right, left
    end
    local res = 0
    local shift = 1
    while left ~= 0 do
        local ra = left % 2 --取得每一位(最右边)
        local rb = right % 2
        res = shift * op(ra, rb) + res
        shift = shift * 2
        left = math.modf(left / 2) --右移
        right = math.modf(right / 2)
    end
    return res
end

function GameManager.andOp(left, right)
    return GameManager.base(left, right, GameManager.andBit)
end

function GameManager.xorOp(left, right)
    return GameManager.base(left, right, GameManager.xorBit)
end

function GameManager.orOp(left, right)
    return GameManager.base(left, right, GameManager.orBit)
end

function GameManager.notOp(left)
    return left > 0 and -(left + 1) or -left - 1
end

function GameManager.lShiftOp(left, num)
    --left左移num位
    return left * (2 ^ num)
end

function GameManager.rShiftOp(left, num)
    --right右移num位
    return math.floor(left / (2 ^ num))
end
--Ip转int
function GameManager.IpToInt(str)
    local num = 0
    if str and type(str) == "string" then
        local o1, o2, o3, o4 = str:match("(%d+)%.(%d+)%.(%d+)%.(%d+)")
        num = 2 ^ 24 * o1 + 2 ^ 16 * o2 + 2 ^ 8 * o3 + o4
    end
    return num
end
--int转IP
function GameManager.IntToIp(n)
    if n then
        n = tonumber(n)
        local n1 = math.floor(n / (2 ^ 24))
        local n2 = math.floor((n - n1 * (2 ^ 24)) / (2 ^ 16))
        local n3 = math.floor((n - n1 * (2 ^ 24) - n2 * (2 ^ 16)) / (2 ^ 8))
        local n4 = math.floor((n - n1 * (2 ^ 24) - n2 * (2 ^ 16) - n3 * (2 ^ 8)))
        return n1 .. "." .. n2 .. "." .. n3 .. "." .. n4
    end
    return "0.0.0.0"
end