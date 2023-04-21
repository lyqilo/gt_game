DownTishiInfo = { }
local self = DownTishiInfo;
local DownType = nil;
self.sendServerMyDownGame = false;
local DownSize = 0;
local AllDownSize = 0;
local FilesSize={};
local TabremoveUrl = { }
local TablocalUrl = { }
local reqEveryDownSize = {};--要下载文件的每个大小
local callbackfunnum = 0;-- 回调次数
local waitdowninfo = { };
local filesMd5 = { };-- 文件的MD5

function DownTishiInfo.Init(obj, LuaBehaviour)
    local t = obj.transform;
    self.DownPanel = obj;
    self.Bg = t:Find("Bg").gameObject;
    self.BgImage = t:Find("Image").gameObject;
    self.DownHead = t:Find("Bg/Text").gameObject;
    self.Slider = t:Find("Bg/Slider").gameObject;
    self.YesBtn = t:Find("Bg/YesBtn").gameObject;
    self.NoBtn = t:Find("Bg/NoBtn").gameObject;
    self.TishiText = t:Find("Bg/TishiText").gameObject;
    if DownType == "捕鱼3D" then
        self.TishiText.transform:GetComponent("Text").text = "3D捕鱼需要下载资源，是否需要下载？";
    else
        self.TishiText.transform:GetComponent("Text").text = DownType .. "需要下载资源，是否需要下载？";
    end
    self.DownPanel:SetActive(true);
    LuaBehaviour:AddClick(self.YesBtn, self.SureBtnOnClick);
    LuaBehaviour:AddClick(self.NoBtn, self.NoBtnOnClick);
    self.Slider:SetActive(false);
end



local DownLoseNum = 0;
local tagobj = nil;
local callcomfun = nil;
local IsDestroyPanel = false;
function DownTishiInfo.SureBtnOnClick()
    IsDestroyPanel = false;
    DownLoseNum = 0;
    DownSize = 0;
    local sendFileName = "";
    local DownType = waitdowninfo[1][1];
    if string.find(DownType, gameServerName.SFZ) then
        sendFileName = UpdateFileType.SHZ
    elseif string.find(DownType, gameServerName.DDZ) then
        sendFileName = UpdateFileType.DDZ
    elseif string.find(DownType, gameServerName.POINTS21) then
        sendFileName = UpdateFileType.POINT21
    elseif string.find(DownType, gameServerName.LKPY) then
        sendFileName = UpdateFileType.LKPY
    elseif string.find(DownType, gameServerName.Baccara) then
        sendFileName = UpdateFileType.Baccara
    elseif string.find(DownType, gameServerName.Fish3D) then
        sendFileName = UpdateFileType.Fish3D
    elseif string.find(DownType, gameServerName.Game01) then
        sendFileName = UpdateFileType.Slot
    elseif string.find(DownType, gameServerName.Game02) then
        sendFileName = UpdateFileType.serialindiana
    elseif DownType == gameServerName.Game03 then
        sendFileName = UpdateFileType.niuniu
    elseif string.find(DownType, gameServerName.Game04) then
        sendFileName = UpdateFileType.benzbwm
    elseif string.find(DownType, gameServerName.Game05) then
        sendFileName = UpdateFileType.jsbuyu
    elseif string.find(DownType, gameServerName.Game06) then
        sendFileName = UpdateFileType.zhajinhua
    elseif string.find(DownType, gameServerName.Game07) then
        sendFileName = UpdateFileType.LKPY
    elseif string.find(DownType, gameServerName.Game08) then
        sendFileName = UpdateFileType.feiqinzoushou
    elseif string.find(DownType, gameServerName.Game09) then
        sendFileName = UpdateFileType.Game09
    elseif string.find(DownType, gameServerName.Game10) then
        sendFileName = UpdateFileType.Game10
    elseif string.find(DownType, gameServerName.Game11) then
        sendFileName = UpdateFileType.Game11
    elseif string.find(DownType, gameServerName.Game12) then
        sendFileName = UpdateFileType.Game12
    elseif string.find(DownType, gameServerName.Game13) then
        sendFileName = UpdateFileType.Game13
    elseif string.find(DownType, gameServerName.Game14) then
        sendFileName = UpdateFileType.Game14
    elseif DownType == gameServerName.Game15 then
        sendFileName = UpdateFileType.Game15
    elseif string.find(DownType, gameServerName.Game16) then
        sendFileName = UpdateFileType.Game16
    elseif string.find(DownType, gameServerName.Game17) then
        sendFileName = UpdateFileType.Game17
    elseif string.find(DownType, gameServerName.Game18) then
        sendFileName = UpdateFileType.Game18
    elseif string.find(DownType, gameServerName.Game19) then
        sendFileName = UpdateFileType.Game19
    elseif string.find(DownType, gameServerName.Game20) then
        sendFileName = UpdateFileType.Game20
    else
        sendFileName = nil;
    end
    -- 新方式下载
    local data = UpdateFile.GetFileType(sendFileName)
    self.SumDownSize(data);
    -- 老方式下载
    --  errorfile=0;
    -- UpdateFile.DownFiles(sendFileName,self.DownFileInfoTwo)
end

function DownTishiInfo.SumDownSize(data)
    self.tagtext = tagobj.transform:Find("Text"):GetComponent("Text")
    self.AllFileSize(data);
end

function DownTishiInfo.NoBtnOnClick()

    if callcomfun ~= nil and #waitdowninfo > 0 then
        callcomfun(waitdowninfo[1][4]);
    end
    --   destroy(self.DownPanel);
end
local waitloadnum = 0;
function DownTishiInfo.AllFileSize(urltable)
    self.DownFileMD5();
    -- 文件夹是否加密
    for i = 1, #urltable do
        urltable[i] = UpdateFile.GetMD5Name(urltable[i]);
    end
    -- 拷贝一份di
    local data = { };
    local everyfilesize = {};
    for i = 1, #urltable do
        local path;
        table.insert(data, urltable[i]);
    end
    AllDownSize = 0;
    local suffix = "?v=";
    -- 把下载的文件MD5值跟上
    for i = 1, #data do
        for j = 1, #filesMd5 do
            local fd = string.lower(filesMd5[j]);
            local ff = string.lower(data[i])
            if string.find(fd, ff) then
                local td = string.split(filesMd5[j], '|');
                everyfilesize[i] = tonumber(td[3]);
                data[i] = data[i] .. suffix .. string.sub(td[2], 1, -2);
                AllDownSize = AllDownSize + tonumber(td[3]);
            end
        end
    end

    -- 检测下载地址有没有跟上MD5，不然下载的可能是缓存
    for i = 1, #data do
        if string.find(data[i], suffix) then else data[i] = data[i] .. suffix .. os.date("%Y%m%d%H%M%S"); everyfilesize[i] = 0; end
    end

    table.insert(FilesSize, AllDownSize);
    TabremoveUrl = { }
    reqEveryDownSize = { }
    TablocalUrl = { }
    DownSize = 0;
    AllDownSize = 0;
    SaveFilesKV = { };
    if #urltable ~= #data then error("DownTishiInfo error 159") return end
    for i = 1, #urltable do
        if not Util.Exists(PathHelp.AppHotfixResPath .. urltable[i]) then
            -- 删除最后一个文件，可能最后一个文件下载出错也保存到了本地
--            if i > 1 and #TabremoveUrl == 0 then
--                Util.DeletePath(PathHelp.AppHotfixResPath .. urltable[i - 1])
--                table.insert(TablocalUrl, PathHelp.AppHotfixResPath .. urltable[i - 1]);
--                table.insert(TabremoveUrl, CsWeburl .. data[i - 1])
--            end;
            table.insert(TablocalUrl, PathHelp.AppHotfixResPath .. urltable[i])
            table.insert(TabremoveUrl, CsWeburl .. data[i]);
            table.insert(reqEveryDownSize, everyfilesize[i]);
            AllDownSize = AllDownSize + everyfilesize[i];
            error(CsWeburl .. data[i]);
        end
        -- 记录files中用的KV,方便打包的时候下载内置游戏
        if Util.isEditor then
            table.insert(SaveFilesKV, urltable[i] .. "|" .. string.split(data[i], '=')[2]);
        end
    end
    -- (方案三)
    waitloadnum = 0;
    callbackfunnum = 1;
    error("_________down______"..#TabremoveUrl.."_______"..#reqEveryDownSize);
    --LuaDownFielsDownFiel(TabremoveUrl[1], TablocalUrl[1], self.DownFileInfo)
    UpdateFile.DownFiles(TabremoveUrl,TablocalUrl, self.DownFileInfoTwo);

    -- 获取大小
    -- if (self.LD == nil) then self.LD = LuaDown.New(); end
    -- self.LD:GetFielsSzieAsync(TabremoveUrl, self.SetSizefun);

    -- 把要下载的文件写入Files记录,方便打包的时候下载内置游戏
    if not Util.isEditor then return end
    local path = PathHelp.AppHotfixResPath .. AppConst.filesName;
    local f = io.open(path)
    for line in f:lines() do
        table.insert(SaveFilesKV, line);
    end
    f:close();
    local fe = io.open(path, "w");
    if fe == nil then fe = io.open(path, "w"); end
    WriteFile(fe, SaveFilesKV);
end

function DownTishiInfo.WaitLoading()
    if FilesSize[1] == 0 then
        callbackfunnum = 1;
        --  coroutine.wait(0.1);
        waitloadnum = waitloadnum + 0.01;
        tagobj.transform.gameObject:GetComponent("Image").fillAmount = string.format("%.2f",(waitloadnum));
        self.tagtext.text = math.ceil(waitloadnum * 100) .. "%"
        --  coroutine.start(self.WaitLoading);
    end
end

--function DownTishiInfo.SetSizefun(num)
--    AllDownSize = tonumber(num);
--    if AllDownSize <= 0 then self.NoBtnOnClick(); return end;
--    -- LuaDownFielsDownFiel(TabremoveUrl[1], TablocalUrl[1], self.DownFileInfo)
--end
local onefilesize = 1;
local errorfile = 0;
-- a代表当前下载大小，单个总下载大小
function DownTishiInfo.DownFileInfo(c1, b1)
    local a = tonumber(c1);
    local b = tonumber(b1);
    --  error("c1====" .. c1 .. ",b1======" .. b1);
    if a > 0 then onefilesize = a; end;
    if a == -100 then
        callbackfunnum = callbackfunnum + 1;
        DownSize = DownSize + onefilesize;
        onefilesize = 1;
        if #TabremoveUrl == 0 then return end
        if callbackfunnum > #TabremoveUrl then
            table.remove(FilesSize,1);--下载完成了一个游戏，将这个游戏的大小从队列中移除
            self.tagtext.text = "100%"
            tagobj.transform.gameObject:GetComponent("Image").fillAmount = 1;
            self.Destroy()
            return
        else
            coroutine.start(self.ReDownFile);
        end;
    end
    if a < 0 and a ~= -100 then
        errorfile = errorfile + 1;
        error("=========下载错误个数====" .. errorfile);
        Util.DeletePath(TablocalUrl[callbackfunnum])
        if callcomfun ~= nil then
            callcomfun(waitdowninfo[1][4]);
        end
        TabremoveUrl = { }
        TablocalUrl = { }
        table.remove(waitdowninfo, 1);
        errorfile = 0;
        if #waitdowninfo > 0 then
            coroutine.start(self.RunningDown);
        end;
        return
    end;
    if tagobj ~= nil and a > 0 and FilesSize[1] == 0 then
        local value =((callbackfunnum +(a / b) / 2) / #TabremoveUrl)
        tagobj.transform.gameObject:GetComponent("Image").fillAmount = string.format("%.2f", value);
        self.tagtext.text = math.ceil(value * 100) .. "%"
        return;
    end;
    if tagobj ~= nil and a > 0 then
        tagobj.transform.gameObject:GetComponent("Image").fillAmount = string.format("%.2f",((DownSize + a) / FilesSize[1]));
        self.tagtext.text = math.ceil(((DownSize + a) / FilesSize[1]) * 100) .. "%"
    end
end
local callback = 0;
local downLoseNum = 0;
function DownTishiInfo.DownFileInfoTwo(progress, _error, UpdateTotalNuamber, UpdateNumber)   
    if string.len(_error) > 3 then
        downLoseNum = downLoseNum + 1;
        UpdateFile.Close();
        tagobj.transform.gameObject:GetComponent("Image").fillAmount = 1;
        downLoseNum = 0;
        self.Destroy();
    else
       local num = progress;
       if num == UpdateFileOver then num = UpdateFileOver - 1 end
       local jishu=100/AllDownSize;       
       local allnum=0;
       if UpdateNumber > #reqEveryDownSize then
           UpdateFile.Close();
           tagobj.transform.gameObject:GetComponent("Image").fillAmount = 1;
           downLoseNum = 0;
           self.Destroy();
           return;
       end
       if progress == UpdateFileOver then
          DownSize = DownSize+reqEveryDownSize[UpdateNumber];
          allnum= math.ceil(jishu*DownSize);
       else
          allnum= math.ceil(jishu*(DownSize+progress/100*reqEveryDownSize[UpdateNumber]));
       end
       if allnum>100 then allnum=100 end;
       tagobj.transform.gameObject:GetComponent("Image").fillAmount =allnum/100;
        self.tagtext.text = allnum .. "%"
        if UpdateNumber == UpdateTotalNuamber then
            if progress == UpdateFileOver then
                UpdateFile.Close();
                if downLoseNum == 0 then
                   self.Destroy()
                else
                    tagobj.transform.gameObject:GetComponent("Image").fillAmount = 1;
                    downLoseNum = 0;
                    self.Destroy()
                end
            end
        end
    end
end

--清除所以的下载
function DownTishiInfo.clearAllDown(args)
  waitdowninfo = {};
  UpdateFile.Close();
end

function DownTishiInfo.ReDownFile()
    --   error("发送下载次数======" .. callbackfunnum);
    coroutine.wait(0.2);
    if #TabremoveUrl < callbackfunnum then return end
    LuaDownFielsDownFiel(TabremoveUrl[callbackfunnum], TablocalUrl[callbackfunnum], self.DownFileInfo)
end

function DownTishiInfo.Destroy()
    if #DownGameResource == 0 and self.sendServerMyDownGame == false then
        -- SCPlayerInfo._18bDownDancerResource = 1;
        self.sendServerMyDownGame = true;
        local buffer = ByteBuffer.New();
        buffer:WriteInt(1);
        Network.Send(MH.MDM_3D_TASK, MH.SUB_3D_CS_DOWN_RESOURCE_GAME_FINISH, buffer, gameSocketNumber.HallSocket);
    end
    if callcomfun ~= nil then
        callcomfun(waitdowninfo[1][4]);
        error("=========DownTishiInfo.Destroy()====");
    end
    table.remove(waitdowninfo, 1);
    if #waitdowninfo > 0 then
        coroutine.start(self.RunningDown);
    end;
end

function DownTishiInfo.CreatDownPanel(strtype, obj, comfun, num)
    for i = 1, #waitdowninfo do
        if waitdowninfo[i][1] == strtype then

            return
        end;
    end
    local data = { [1] = strtype, [2] = comfun, [3] = obj, [4] = num; }
    table.insert(waitdowninfo, data);
    if #waitdowninfo == 1 then
        coroutine.start(self.RunningDown);
    end;
end

-- 判断是否断网（断网就清空下载表）
function DownTishiInfo.RemoveAllDownInfo()
    waitdowninfo = { };
end

function DownTishiInfo.RunningDown()
    coroutine.wait(0.5);
    DownType = waitdowninfo[1][1];
    callcomfun = waitdowninfo[1][2];
    tagobj = waitdowninfo[1][3];
    tagobj.transform.parent:Find("wait").gameObject:SetActive(false);
    self.SureBtnOnClick();
end

function DownTishiInfo.ShowPrefeb(prefeb)

    if ScenSeverName == gameServerName.HALL then
        _luaBeHaviour = HallScenPanel.LuaBehaviour;
        self.tishipartent = HallScenPanel.Compose;
    else
        _luaBeHaviour = GameSetsBtnInfo._LuaBehaviour;
        self.tishipartent = GameObject.FindGameObjectWithTag('GuiCamera');
    end
    local go = newobject(prefeb);
    go.transform:SetParent(self.tishipartent.transform);

    go.transform.localScale = Vector3.one;
    self.DownPanel = go;
    self.DownPanel:SetActive(false);
    go.transform.localPosition = Vector3.New(0, 0, 0);
    self.Init(go, _luaBeHaviour);
end
-- 提示游戏更新创建Prefeb
function DownTishiInfo.CreatUpdatePanel(strtype, obj, comfun)
    DownType = strtype;
    callcomfun = comfun;
    tagobj = obj;
    self.YesBtnUpdateOnClick();
end

-- 创建游戏更新提示
function DownTishiInfo.ShowUpdatePrefeb(prefeb)
    local _luaBeHaviour = nil;
    if ScenSeverName == gameServerName.HALL then
        _luaBeHaviour = HallScenPanel.LuaBehaviour;
        self.tishipartent = HallScenPanel.Compose;
    else
        _luaBeHaviour = GameSetsBtnInfo._LuaBehaviour;
        self.tishipartent = GameObject.FindGameObjectWithTag('GuiCamera');
    end
    if _luaBeHaviour == nil then return end
    local go = newobject(prefeb);
    go.transform:SetParent(self.tishipartent.transform);

    go.transform.localScale = Vector3.one;
    self.DownPanel = go;
    self.DownPanel:SetActive(false);
    go.transform.localPosition = Vector3.New(0, 0, 0);
    self.UpdateInit(go, _luaBeHaviour);
end

-- 提示用游戏有更新
function DownTishiInfo.UpdateInit(obj, LuaBehaviour)
    local t = obj.transform;
    self.DownPanel = obj;
    self.Bg = t:Find("Bg").gameObject;
    self.BgImage = t:Find("Image").gameObject;
    self.DownHead = t:Find("Bg/Text").gameObject;
    self.Slider = t:Find("Bg/Slider").gameObject;
    self.YesBtn = t:Find("Bg/YesBtn").gameObject;
    self.NoBtn = t:Find("Bg/NoBtn").gameObject;
    self.TishiText = t:Find("Bg/TishiText").gameObject;
    if DownType == "捕鱼3D" then
        self.TishiText.transform:GetComponent("Text").text = "3D捕鱼有资源更新，是否需要更新？";
    else
        self.TishiText.transform:GetComponent("Text").text = DownType .. "有资源更新，是否需要更新？";
    end
    self.DownPanel:SetActive(true);
    LuaBehaviour:AddClick(self.YesBtn, self.YesBtnUpdateOnClick);
    LuaBehaviour:AddClick(self.NoBtn, self.NoBtnUpdateOnClick);
    self.Slider:SetActive(false);
end

-- 更新游戏确定按钮
function DownTishiInfo.YesBtnUpdateOnClick()
    IsDestroyPanel = false;
    DownLoseNum = 0;
    DownSize = 0;
    callbackfunnum = 1;
    TabremoveUrl = UpdateFile.tbRemoveUrl;
    TablocalUrl = UpdateFile.tbLocalUrl;
    AllDownSize = 0;
    AllDownSize = AllDownSize + tonumber(LuaDownFielsGetFielsSzie(TabremoveUrl));
    if AllDownSize < 0 then return self.NoBtnOnClick(); end;
    LuaDownFielsDownFiel(TabremoveUrl[1], TablocalUrl[1], self.DownFileInfo)
end

function DownTishiInfo.NoBtnUpdateOnClick()
    destroy(self.DownPanel);
end

function DownTishiInfo.DownFileMD5()
    if #filesMd5 > 0 then return end
    local newFilesMd5 = CsWeburl .. "FilesCode.txt?v=" .. os.date("%Y%m%d%H%M%S");
    local GetNewFilesMd5 = UnityEngine.WWW.New(newFilesMd5);
    while not GetNewFilesMd5.isDone do end
    if GetNewFilesMd5.error ~= nil then error(GetNewFilesMd5.error); return end
    local txt = GetNewFilesMd5.text;
    if not string.find(txt, "md5#") then error("获取md5 files 失败"); return end
    txt = string.gsub(txt, "md5#", "");
    filesMd5 = string.split(txt, "\n");
end

