ChatPanel = { }
local self = ChatPanel;
local isActive = false;
local messageNum = 0;-- 消息的条数  
local MaxChatNum = 30;-- 最多可以显示多少记录 
local SendMessageTime=2;--发送消息的最少间隔时间                 
local ConstChar = "^";--消息分隔符
local pakID="";
local isSetshow = true;
local gameObject=nil;
local contenTab = { }-- 存放消息的表
local saveChatName="chatLog5.txt";
local chatSverIP="127.0.0.1";
local chatSverProt=8076;
local ChatPath=nil;
local connect=false;
local PayerID="";
local chatABname="module02/hall_feedback";

local isAddMessage = 0;
local timeCount=0;
local ScreenWidth=1080;--屏幕宽
local ScreenHeight=1920;--屏幕高

local eumInfo =
{
    -- 其他消息
    other = "0",
    -- 自己的消息
    oneself = "1",
    -- 图片消息
    img = "2"
};

local eumMessage =
{
    -- 登录消息服务器
    sub_cs_login = 0,
    -- 发送消息
    sub_cs_send = 1,
    -- 登录 数据大小为0表示成功，否则直接取字符串看错误原因
    sub_sc_loginYes = 0,
    -- 接收信息——开始  只有机器码
    sub_sc_recvStart = 1,
    -- 接收信息
    sub_sc_recvIng = 2,
    -- 接收信息——结束  只有机器码
    sub_sc_recvStop = 3,
    -- 发送消息 数据大小为0表示成功，否则直接取字符串看错误原因
    sub_sc_sendInfo = 4,
    -- 长时间无操作踢掉
    sub_sc_loginOff = 5
};

function ChatPanel.Open(luaBehaviour,father)
	do return end
    messageNum = 0;
    ChatPath=nil;
    chatSverIP  = HallIP;
    --chatSverIP  = "182.148.123.253"--HallIP;
    self.luaBehaviour = luaBehaviour;
    self.father=father
    local bid = GameManager.GetBid();
    pakID=Opcodes;
    --pakID = string.gsub(Opcodes, bid, "");
    --pakID = string.gsub(pakID,"-","");
    PayerID = SCPlayerInfo._33PlayerID;
    if PayerID == nil then id = 0; end
    if PayerID == "" then id = 0; end
    if PayerID == " " then id = 0; end
    ChatPath=PathHelp.AppHotfixResPath.."Chat/";
    self.path = ChatPath .. PayerID .. saveChatName;
    Util.CreatDireCtory(ChatPath);
    ResManager:LoadAsset(chatABname, "UserFeedback", self.PanelInit);
    --self.PanelInit(HallScenPanel.Pool("UserFeedback2"));
end


-- 初始化面板
function ChatPanel.PanelInit(go)
    gameObject = go;
    if self.father==nil then 
    self.father = GameObject.FindGameObjectWithTag("GuiCamera").transform;
    end
    go.transform:SetParent(self.father);
    go.name = "ChatPanel";
    go.transform.localScale = Vector3.New(1, 1, 1);
    HallScenPanel.SetXiaoGuo(go)
    go.transform.localPosition = Vector3.New(0, 0, 100);
    ScreenWidth=Screen.width;
    ScreenHeight=Screen.height;
    self.InfoStyle = { };
    table.insert(self.InfoStyle, 0, go.transform:Find("InfoStyle0").gameObject);
    table.insert(self.InfoStyle, 1, go.transform:Find("InfoStyle1").gameObject);
    self.Image = go.transform:Find("Image").gameObject;
    self.Image512 = go.transform:Find("512").gameObject;
    self.Content = go.transform:Find("Scroll View/Viewport/Content").gameObject;
    self.SureBtn = go.transform:Find("SureBtn").gameObject;
    self.MassgeTxt = go.transform:Find("Massge"):GetComponent("InputField");
    self.CloseBtn = go.transform:Find("CloseBtn").gameObject;
    self.ConntChatBtn = go.transform:Find("ConntChatBtn").gameObject;
    self.CloseChatBtn = go.transform:Find("CloseChatBtn").gameObject;
    self.SeedImgBtn = go.transform:Find("SeedImgBtn").gameObject;
    self.ScrollbarObj = go.transform:Find("Scroll View/Scrollbar").gameObject;
    self.Scrollbar = self.ScrollbarObj:GetComponent("Scrollbar");
    self.Panel=go.transform:Find("Panel").gameObject;
    self.btnColse=go.transform:Find("Panel/btnColse").gameObject;
    self.btnRotation=go.transform:Find("Panel/btnRotation").gameObject;
    self.ScaleImge=go.transform:Find("Panel/ScaleImge").gameObject;
    -- 绑定按钮事件
    self.luaBehaviour:AddClick(self.SureBtn, self.Send);
    self.luaBehaviour:AddClick(self.CloseBtn, self.Close);
    self.luaBehaviour:AddClick(self.btnColse, self.btnColseOnclick);
    self.luaBehaviour:AddClick(self.btnRotation, self.btnRotationOnclick);
    self.luaBehaviour:AddScrollbarEvent(self.ScrollbarObj, self.ScrollBarValueChanged);
    self.luaBehaviour:AddClick(self.SeedImgBtn, self.SelectFile);
    
    self.Panel:SetActive(false);    
    local num=Application.version;
    --num=tonumber(num) or 0;
    --if num < 2 then self.SeedImgBtn:SetActive(false); end
    -- 初始化消息显示
    self.initInfo();
    self.InitOver();
end

function ChatPanel.InitOver()
    --关闭设置面板
    HallScenPanel.CloseSetOnClick();
    isActive = true;
    self.Connect();
end

-- 连接聊天服务器
function ChatPanel.Connect()
    if self.connect==true then return end;
    local a = function(state)
        local p = state or "yes";
        error("ChatPanel.Connect state:"..tostring(p))
        if p == "no" then
            self.SocektClose();
            return;
        end
        local buffer = ByteBuffer.New();
        -- 机器码长度
        local macLen = 100;
        buffer:WriteBytes(macLen, pakID);
        buffer:WriteUInt32(PayerID);
        error(SCPlayerInfo._05wNickName);
        buffer:WriteBytes(32,SCPlayerInfo._05wNickName);
        Network.Send(10000, 2, buffer, gameSocketNumber.ChatSocket);
        self.connect=true;
    end
    Network.Connect(chatSverIP, chatSverProt, gameSocketNumber.ChatSocket, a,4000, ChatPanel.Close);
end

-- 初始化消息
function ChatPanel.initInfo()
    contenTab = { };
    local tt = { };
    tt = self.ReadChat();
    if tt == nil then return end
    for i = 1, #tt do
        local s = tt[i];
        local t2 = string.split(s, ConstChar);
        local c = string.gsub(s, t2[1] .. ConstChar, "")
        table.insert(contenTab, s);
        if string.find(tostring(t2[1]), tostring(eumInfo.img)) then
            self.AddImage(t2[1], c) 
        else
            local _s = string.gsub(s, '-n', "\n");
            self.AddInfo(_s);
        end
    end
end

-- 选择图片
local SaveIMGname = "";
function ChatPanel.SelectFile()
    SaveIMGname = os.date("%Y%m%d%H%M%S") .. "chatImg2017.png";
    if Util.isAndroidPlatform then
        NetManager:GetPhoto(self.LocalPhoneCallBack);
        return
    end

    if Util.isApplePlatform then
        NetManager:GetPhonePicture(self.LocalPhoneCallBack, ScreenWidth, ScreenHeight);
        return
    end

    -- 非手机平台
    local pcPath = nil;
    local a = function(sourcePath)
        -- local sourcePath = Util.SelectFile(nil);
        if sourcePath == "" then return end
        if sourcePath == nil then return end
        local k = eumInfo.img .. eumInfo.oneself;
        local savePath = ChatPath .. SaveIMGname;
        pcPath = sourcePath;
    end

    Util.SelectFile(a);
    local timeCount = 0;
    coroutine.start(
    function()
        local ok = true;
        while (ok) do
            coroutine.wait(1);
            timeCount = timeCount + 1;
            if timeCount > 15 then ok = false; end
            if pcPath ~= nil then
                ok=false;
                error("pcPath: ".. pcPath);
                local cfun=function(ok,sp) if ok==false then error(tostring(sp)); sp=nil end self.LocalPhoneCallBack(sp) end
                NetManager:getLocalImag("http://" .. pcPath, pcPath, cfun , nil);
            end
        end
    end
    );
end



-- 处理手机相册传回来的图片
function ChatPanel.LocalPhoneCallBack(sprite)
    if sprite==nil then error("没有图片显示:") return end
    local savePath = ChatPath .. SaveIMGname;
    local bl = Util.SaveFile(sprite, savePath);
    local url = "http://" .. chatSverIP .. ":8075/ChatPicPage.aspx?CustomerServiceOrPlayer=1&MachineNo=" .. pakID .. "&ID=" .. PayerID;
    
    -- 传到服务器
    --        local a = function(a)
    --        error(tostring(a));
    --         --删除缓存
    --        --Util.DeletePath(savePath)
    --        -- 上传成功就显示出来
    --        if isOk == false then
    --            -- 提示传输失败
    --            self.SendMassgeHint("发送图片出错,稍后再试");
    --        end
    --        if isOk then error("send img yes!!");  end
    --    end
    --    NetManager:UpLoadFileAsync(url, savePath, a);

    if AppConst.CodeVersion > 200 then
        local function f(a, c) if tostring(a)=="1" then error("上传图片成功"); end end
        self.UpImg(url, savePath, f);
    else
        NetManager:UpLoadHeaderFile(url, savePath);
    end

end



function ChatPanel.UpImg(urlPath,localPath,progressCallBack)
    -- 创建一个队列
    local UWPacketQueue = UnityWebDownPacketQueue.New();
    local UWPacket = UnityWebPacket.New();
    UWPacket.urlPath = urlPath;
    UWPacket.localPath = localPath;
    UWPacket.size =0;
    UWPacket.func = progressCallBack;
    UWPacketQueue:Add(UWPacket);
    -- 创建一个空物体
    local obj = GameObject.New();
    obj.name = "UnityWebUpRequestAsync";
    -- 挂载执行下载队列的脚本
    local UWRAsync = obj:AddComponent(typeof(SuperLuaFramework.UnityWebUpRequestAsync));
    -- 传参开始执行
    UWRAsync:UploadAsync(UWPacketQueue);
    return obj;
end

-- 发送消息
function ChatPanel.Send()
    local str = self.MassgeTxt.text;
    if str == "" then error("消息为空"); return end;
    -- 发送给服务器
    if Util.TickCount-timeCount <SendMessageTime then self.SendMassgeHint("发送消息太频繁啦,稍等一下再试试"); return end
    local buffer = ByteBuffer.New();
    buffer:WriteByte(0);
    buffer:WriteBytes(1024,str);
    Network.Send(10000, 1, buffer, gameSocketNumber.ChatSocket);
    self.MassgeTxt.text = "";
    timeCount=Util.TickCount;
end


--提示发送消息
function ChatPanel.SendMassgeHint(str)
        local go = newobject(self.ConntChatBtn).transform;
        go:SetParent(self.Content.transform);
        go.transform.localPosition = Vector3.New(20, 0, 0);
        go.localScale = Vector3.New(1, 1, 1);
        go.transform:Find("Text"):GetComponent("Text").text=str;
        isAddMessage = isAddMessage+1;
end


function ChatPanel.ScrollBarValueChanged(value)
    if isAddMessage == 0 then return end
    self.Scrollbar.value = 0;
    isAddMessage = isAddMessage-1;
    if isAddMessage<0 then isAddMessage=0; end
end


-- 添加一条消息到显示面板
function ChatPanel.AddInfo(str)
    if StringIsNullOrEmpty(str) then error("消息为空"); return end;
    log("消息:" .. str);
    if not string.find(str, ConstChar) then return end
    local tt = string.split(str, ConstChar);
    local info = string.gsub(str, tt[1] .. ConstChar, "");
    local k = tt[1];
    if k ~= eumInfo.oneself and k ~= eumInfo.other then return end
    local go = newobject(self.InfoStyle[tonumber(k)]).transform;
    go:SetParent(self.Content.transform);
    go.transform.localPosition = Vector3.New(20, 0, 0);
    local txtObj = go:Find("Image/Image/Text").gameObject;
    local text = txtObj:GetComponent("Text");
    txtObj.transform.localPosition = Vector3.New(20, 0, 0);
    text.text = info;
    local onBtn = go:Find("Image/Image").gameObject;
    onBtn:AddComponent(typeof(UnityEngine.UI.Button));
    self.luaBehaviour:AddClick(onBtn,
    function()
        if Util.isAndroidPlatform or Util.isApplePlatform then
            Util.CopyTextToClipboard(info)
        else
            local t = UnityEngine.TextEditor.New();
            t.text = string.split(info, "\n")[2];
            t:OnFocus();
            t:Copy();
        end
    end
    );
    go.localScale = Vector3.New(1, 1, 1);
    messageNum = messageNum + 1;
    isAddMessage = isAddMessage + 1;
end


-- 添加一个图片
-- k  谁的图片
-- url 图片地址
function ChatPanel.AddImage(k, name)
    error("显示发送成功的图片:" .. k .. "   " .. name);
    k = string.gsub(k, tostring(eumInfo.img), "");
    local pp = "file:///";
    if Util.isApplePlatform then pp = "file://"; end
    local url = pp .. ChatPath .. name;
    local bl = Util.Exists(ChatPath .. name);
    if bl == false then return end
    if k ~= eumInfo.oneself and k ~= eumInfo.other then return end
    local go = newobject(self.InfoStyle[tonumber(k)]).transform;
    go:SetParent(self.Content.transform);
    go.localScale = Vector3.New(1, 1, 1);
    go.transform.localPosition = Vector3.New(0, 0, 0);
    local txtObj = go:Find("Image/Image/Text").gameObject;
    destroy(txtObj);
    local imageobjParent = go:Find("Image/Image")
    local imageobj;
    local bl = true;
    local tt = string.split(url, "/");
    local tt2 = string.split(tt[#tt], "_");
    if #tt2 < 2 then return end
    local w, h;
    w = tonumber(tt2[1]);
    h = tonumber(tt2[2]);
    if w > 512 then bl = false; end
    if h > 512 then bl = false; end
    if bl then
        imageobj = newobject(self.Image.gameObject).transform;
        imageobj:SetParent(imageobjParent);
        imageobj.localScale = Vector3.New(1, 1, 1);
        imageobj.localPosition = Vector3.New(0, 0, 0);
        imageobj.name = url;
    else
        imageobj = newobject(self.Image512.gameObject).transform;
        imageobj:SetParent(imageobjParent);
        imageobj.localScale = Vector3.New(1, 1, 1);
        imageobj.localPosition = Vector3.New(0, 0, 0);
        imageobj = imageobj:Find("Image");
        imageobj.name = url;

        local L = 0;
        if w > h then
            local s = 512 / w;
            w = 512;
            h = h * s;
            imageobj:GetComponent("RectTransform").sizeDelta = Vector2.New(w, h);
        end
        if w < h then
            local s = 512 / h;
            h = 512;
            w = w * s;
            imageobj:GetComponent("RectTransform").sizeDelta = Vector2.New(w, h);
        end
    end
    -- 显示到object
    local f = function()
        local www = WWW.New(url);
        coroutine.wait(0.1);
        if not www.isDone then coroutine.wait(0.2); end
        NetManager:GetAndSetTexture(www, imageobj.gameObject);
    end
    coroutine.start(f);
    isAddMessage = isAddMessage + 1;
    self.luaBehaviour:AddClick(imageobj.gameObject, self.ImgeScaleOnclick);

end


function ChatPanel.ImgeScaleOnclick(go)
    local url=go.name;
    error(url);
    local tt = string.split(url,"/");
    local tt2 = string.split(tt[#tt],"_");
    local w,h;
    w=tt2[1];
    h=tt2[2];
    self.Panel:SetActive(true);
    self.ScaleImge:GetComponent("RectTransform").sizeDelta=Vector2.New(w,h);
    self.ScaleImge.transform.localPosition = Vector3.New(20, 0, 0);
    local f = function()
        local www = WWW.New(url);
        coroutine.wait(0.1);
        if not www.isDone then coroutine.wait(0.2); end
        NetManager:GetAndSetTexture(www, self.ScaleImge.gameObject);
        return
    end
    coroutine.start(f);
end

function ChatPanel.btnColseOnclick()
    --error("关闭");
    self.Panel:SetActive(false);
end

function ChatPanel.btnRotationOnclick()
    --error("旋转");
    local ePos=self.ScaleImge.transform.rotation.eulerAngles;
    self.ScaleImge.transform.rotation=Quaternion.Euler(0,0,ePos.z-90);
end


function ChatPanel.Update()
    if not isActive then return end
    -- 回车发送消息
    if Input.GetKeyDown(KeyCode.Return) then self.Send() end
    if Input.GetKeyDown(KeyCode.KeypadEnter) then self.Send() end
end


function ChatPanel.ContenServerError()
    self.SendMassgeHint("<color=#FF5252FF>客服休息去啦,稍等一下</color>");
end


function ChatPanel.ContenServerYes()
    -- 提示连接成功
    self.SendMassgeHint("连接成功,点击消息即可轻松复制");
end


-- 接受到服务器信息
function ChatPanel.RecvInfo(wMaiID, wSubID, buffer, wSize)
    -- 接受消息完成   
    --error("wMaiID="..wMaiID.." wSubID="..wSubID.." wSize"..wSize);
    if wSubID == 0 then 
        if wSize == 0 then self.ContenServerYes(); end
        if wSize > 0 then  self.ContenServerError(); end
    end
    if wSubID == eumMessage.sub_sc_recvStop then isAddMessage = isAddMessage+1 end
    --0登录成功
    if wSubID ~=2 then return end
    -- 机器码大小
    local ismac = buffer:ReadUInt16();
    -- 机器码
    local strMac = buffer:ReadString(ismac);
    --发送这的ID
    local userID=buffer:ReadUInt32();
    -- 是谁发的消息
    local _eumInfo = buffer:ReadByte();
    -- 发消息的时间
    local time = ReadDateTiem(buffer);
    -- 消息类型（是图片还是文字）
    local infoType = buffer:ReadByte();
    -- 消息大小
    local contenLen = buffer:ReadUInt16();
    -- 消息内容（如果是图片就是图片的名字）
    local conten = buffer:ReadString(contenLen);       
    --error("infoType="..infoType.." conten="..conten);
    if tostring(infoType) == "1" then
        -- 图片消息 
        local wwwurl="http://"..chatSverIP..":8075/ChatPic/"..pakID.."/"..PayerID.."/"..conten;   
        conten=PayerID..conten;    
        local localimgUrl = ChatPath ..conten;
        --error("远程地址="..wwwurl);
        --error("本地地址="..localimgUrl);
        Util.DeletePath(localimgUrl);
        local fa=function(bl,img)
            if not bl then error("获取图片失败:"..tostring(img)) return; end
            local name=img.texture.width.."_"..img.texture.height.."_"..conten;
            local localPath=ChatPath..name;
            --保存从新命名
            local bl = Util.SaveFile(img, localPath);
            -- 删除缓存
            Util.DeletePath(localimgUrl)
            return self.GetWebImg(eumInfo.img.._eumInfo,name)
        end
        NetManager:getLocalImag(wwwurl, localimgUrl, fa, nil);
    else
        -- 文字消息
        local kv = "<size=23>客服:" .. time .. "</size>\n";
        if tostring(_eumInfo) == tostring(eumInfo.other) then conten = kv .. conten; end
        local str = _eumInfo .. ConstChar .. conten;
        self.AddInfo(str);
        local addStr= string.gsub(str,'\n',"-n");
        table.insert(contenTab, addStr);
    end
end

function ChatPanel.GetWebImg(k, name)
    local str = k .. ConstChar .. name;
    self.AddImage(k, name);
    table.insert(contenTab, str);
end


function ChatPanel.Close()
    error("chat panel close!")
    if isActive ==false then return end
    self.SaveChat();
    Network.Close(gameSocketNumber.ChatSocket);
    --显示大厅
    HallScenPanel.BackHallOnClick();
    isActive = false;
    destroy(gameObject);
    self.connect=false;
    ResManager:Unload(chatABname);
end


-- 保存消息
function ChatPanel.SaveChat()
    -- 保留MaxChatNum条记录
    if isActive ==false then return end
    local t = { };
    if MaxChatNum > #contenTab then
        for i = 1, #contenTab do
            -- 不要保存明文，这里使用十六进制
            local t2 = string.split(contenTab[i], ConstChar);
            local c = Util.ToHex(t2[2]);
            c = t2[1] .. ConstChar .. c;
            table.insert(t, contenTab[i]);
        end
    else
        local n = #contenTab - MaxChatNum;
        for i = n, #contenTab do
            -- 不要保存明文，这里使用十六进制
            local t2 = string.split(contenTab[i], ConstChar);
            local c =t2[2]-- Util.ToHex(t2[2]);
            c = t2[1] .. ConstChar .. c;
            table.insert(t, contenTab[i]);
        end
    end
    local file = io.open(self.path, "w")
    WriteFile(file, t);
    file:close();
end


--读取保存的消息
function ChatPanel.ReadChat()
    local f = io.open(self.path)
    if f == nil then return end
    return ReadFile(f);
end

function ChatPanel.SocektClose()
    error("聊天socket 断开");
     if isActive ==false then return end
    self.connect=false;
    local go = newobject(self.CloseChatBtn).transform;
    go:SetParent(self.Content.transform);
    go.transform.localPosition = Vector3.New(20, 0, 0);
    go.localScale = Vector3.New(1, 1, 1);

    
    local go = newobject(self.ConntChatBtn).transform;
    go:SetParent(self.Content.transform);
    go.transform.localPosition = Vector3.New(20, 0, 0);
    go.localScale = Vector3.New(1, 1, 1);
    self.luaBehaviour:AddClick(go.gameObject, self.Connect);
    isAddMessage = isAddMessage+1;
    Network.Close(gameSocketNumber.ChatSocket);
end


function ReadDateTiem(buffer)
    local time = "";
    -- 年
    time = buffer:ReadUInt16();
    -- 月
    time = time .. "-" .. buffer:ReadUInt16();
    -- 工作日
    buffer:ReadUInt16();
    -- 日
    time = time .. "-" .. buffer:ReadUInt16();
    -- 小时
    time = time .. " " .. buffer:ReadUInt16();
    -- 分钟
    time = time .. ":" .. buffer:ReadUInt16();
    -- 秒
    time = time .. ":" .. buffer:ReadUInt16();
    -- 毫秒
    buffer:ReadUInt16();
    return time;
end