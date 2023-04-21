--[[require "Common/define"
require "Common/protocal"
require "Common/functions"
require "Core/InfoType"
Event = require "System/events"]]

UpdateFile = { };
local self = UpdateFile;

local UpdateNumber = 1;-- 当前正在下载文件的序号
local UpdateTotalNumber = 0; -- 要下载文件的总数
local UpdateFileS = { }; -- 要下载文件的类型
local SaveFileS = { }; -- 要下载文件的保存到本地的名字
local UpdateCallMethod = nil;-- 下载中会调用的Lua方法， 回掉的方法(进度，错误信息，下载资源的总个数，当前下载的个数)

-- 判断游戏文件是否需要下载？
function UpdateFile.isDown(scenName)
	    local isDown = false;
    if AppConst.DebugMode then return isDown end
    local Files = self.PassScenNameGetDownFiles(scenName);
    local BaseValueConfigerJson = AppConst.gameValueConfiger:GetModule(scenName)

	--error("--------------------------------------------------------------"..#Files )
    for i = 1, #Files do
        -- local ph = PathHelp.AppHotfixResPath .. Files[i];//新版本对文件夹和文件名字要使用加密方式
        local ph = PathHelp.AppHotfixResPath .. self.GetMD5Name(Files[i]);
        if Util.Exists(ph) == false then
            -- error("本地不存在文件");
            local paths = string.split(ph, "/");
            local phName = string.gsub(ph, paths[#paths], "")
            Util.CreatDireCtory(phName);
            isDown = true;
        end
		--error(ph)
        if AppConst.UpdateMode then
            if Util.Exists(ph) then
				--error("过来了"..BaseValueConfigerJson.Length)
                -- error("本地存在文件");
                for j = 0, BaseValueConfigerJson.Length - 1 do
                    local bjson = BaseValueConfigerJson[j];
                    -- error("判断MD5是否相同");
					
					 --error("远程路径="..bjson.dirPath.." 本地路径="..Files[i]);
                    if string.lower(Files[i]) == string.lower(bjson.dirPath) then
                        local localmd5 = MD5Helper.MD5File(ph);
						  -- error("本地MD5="..localmd5);
						   --error("远程MD5="..bjson.md5);
                        if localmd5 ~= bjson.md5 then
                            -- error("不相同，需要下载");
                            isDown = true;
                            if AppConst.DebugMode then isDown = false end
                        end
                    end
                end
            end
        end
    end
    return isDown;
end
-- 进行多个游戏文件下载
-- FileType 下载的文件是那个场景用的比如（大厅,斗地主,劈鱼,21点）
-- luaMethoe下载过程中要回掉的方法。
-- localarr 保存到本地的名字
function UpdateFile.DownFiles(downarr, localarr, luaMethoe)
    if luaMethoe == nil then error "进行下载需要提供回掉方法!!!" end
    UpdateCallMethod = luaMethoe;
    UpdateFileS = downarr;
    SaveFileS = localarr;
    UpdateNumber = 1;
    UpdateTotalNumber = #downarr;
    self.DownIng(UpdateNumber);
end

-- 进行单个文件下载
function UpdateFile.DownFile(FileName, luaMethod, DownType)
    self.Down(FileName, luaMethod, DownType);
end

-- 通过场景名字找出要下载的所有的文件
function UpdateFile.PassScenNameGetDownFiles(scenName)
    local downFiles = { };
    local t = GameManager.PassScenNameToConfiger(scenName);
    if t.configer() == nil then return downFiles; end
    if t.configer().downFiles == nil then return downFiles; end
    return t.configer().downFiles;
end

function UpdateFile.DownIng(Index)
    if UpdateNumber > UpdateTotalNumber then
        self.DownOver();
    else
        local name = UpdateFileS[Index];
        local savename = SaveFileS[Index];
        if name == nil then return end;
        if savename == nil then return end;
        self.Down(name, savename, self.Progress, 0);
    end
end

function UpdateFile.Down(FileName, SaveName, luaMethod, DownType)
    -- 判断下载的是否存在，存在就不用下载
    if Util.Exists(PathHelp.AppHotfixResPath .. FileName) then
        if UpdateNumber < UpdateTotalNumber then UpdateNumber = UpdateNumber + 1; else self.DownOver() end
        self.DownIng(UpdateNumber);
    else
        local webUrl = FileName;
        local localUrl = SaveName;
        NetManager:OnDownAsset(webUrl, localUrl, self.Progress, 0);
    end
end

function UpdateFile.downHead(wwwurl, filename, callBckFunc, tarobj)
    Util.CreatDireCtory(PathHelp.AppHotfixResPath .. "head");
    local localpath = PathHelp.AppHotfixResPath .. "head/" .. filename .. ".png";
    if callBckFunc == nil then
        callBckFunc = self.headok;
    end
    --local bl = Util.Exists(localpath);
    --if bl then
     --   local pp = "file:///";
       -- if Util.isApplePlatform then pp = "file://"; end
      --  localpath = pp .. localpath
       -- NetManager:GetLoadHeaderFile(localpath, tarobj);
       -- local f = function()
         --   --error("加载本地缓存头像:"..localpath);
         --   local www = WWW.New(localpath);
          --  coroutine.wait(0.1);
           -- if not www.isDone then coroutine.wait(0.2); end
          --  NetManager:GetAndSetTexture(www, tarobj);
          --  if callBckFunc then callBckFunc(true,tarobj) end;
          --  return
       -- end
       -- coroutine.start(f);
       -- return
    --end
    --
    --error("下载头像:"..wwwurl);
    NetManager:getLocalImag(wwwurl, localpath, callBckFunc, tarobj);
    local data = string.split(tostring(filename), ".")
    if #data < 2 then return end
    if tonumber(data[2]) == nil then return end
    if tonumber(data[2]) == 0 then return end
    local str = data[1] .. "." .. tostring(tonumber(data[2]) -1) .. ".png"
    local delpath = PathHelp.AppHotfixResPath .. "head/" .. str .. ".png";
    local bl = Util.Exists(delpath);
    if bl then
        Util.DeletePath(delpath)
         error("删除存在头像图片");
    end
end

function UpdateFile.headok(isscu, sp)

end

-- progress下载进度
-- _error错误信息
function UpdateFile.Progress(progress, _error)
    if _error == nil then _error = " " end
    if UpdateCallMethod ~= nil then UpdateCallMethod(progress, _error, UpdateTotalNumber, UpdateNumber); end
    if progress == UpdateFileOver then
        -- 移除已经下载完成
        if UpdateNumber == UpdateTotalNumber then
            error("下载完成！");
            self.DownOver();
        else
            -- 继续下载
            UpdateNumber = UpdateNumber + 1;
            self.DownIng(UpdateNumber);
        end
    elseif progress == 100 then
        if UpdateNumber > UpdateTotalNumber then self.DownOver() end
    end
end

-- 下载完成
function UpdateFile.DownOver()
    if UpdateCallMethod ~= nil then UpdateCallMethod(UpdateFileOver, " ", UpdateTotalNumber, UpdateNumber) end
    self.Close();
end

-- 关闭下载
function UpdateFile.Close()
    UpdateCallMethod = nil;
    NetManager:ExitDown();
    UpdateTotalNumber = 0; UpdateNumber = 1;
    UpdateFileS = { };
end


-- 检测是否需要更新
function UpdateFile.ChickUpdate(gName)
    self.UpPath = string.gsub(CsWeburl, GameManager.GetPlatformName(), "");
    self.UpPath = self.UpPath .. "/" .. AppConst.WebFileName .. GameManager.GetPlatformName();
    local _Uptath = self.UpPath .. gName .. ".txt" .. "?v=" .. os.date("%Y%m%d%H%M%S");
    error(_Uptath);
    local Uw = UnityEngine.WWW.New(_Uptath);
    local bl = true;
    while bl do
        if Uw.isDone then bl = false end
    end
    if Uw.error ~= nil then error("未检测到更新文件！") return false end
    local tx = Uw.text or nil;
    if tx == nil then return false end;
    self.UpArry = string.split(tx, '\n');
    for i = 1, #self.UpArry do
        error(self.UpArry[i]);
    end
    Uw:Dispose();
    if self.UpArry == nil then return false end
    if #self.UpArry == 0 then return false end
    local dataPath = PathHelp.AppHotfixResPath;
    self.tbRemoveUrl = { };
    self.tbLocalUrl = { };
    for i = 1, #self.UpArry do
        local _UA = string.split(self.UpArry[i], "|")
        local k = _UA[1];
        local v = _UA[2];
        local localfile = dataPath .. k;
        -- error("本地地址======" .. localfile)
        local fe = io.open(localfile);
        -- if fe==nil then io.open(localfile,'w'); fe:close(); end
        local fileUrl = self.UpPath .. k .. "?v=" .. os.date("%Y%m%d%H%M%S");
        local canUpdate = false;
        if fe == nil then
            table.insert(self.tbRemoveUrl, fileUrl);
            table.insert(self.tbLocalUrl, localfile);
        else
            local remoteMd5 = string.lower(v);
            local localMd5 = string.lower(Util.md5file(localfile));
            if remoteMd5 ~= localMd5 then
                table.insert(self.tbRemoveUrl, fileUrl);
                table.insert(self.tbLocalUrl, localfile);
                os.remove(localfile);
            end
        end
    end
    if #self.tbRemoveUrl > 0 then return true else return false end
end

local SavePlayerPrefs = { };
function UpdateFile.NewUpdate()
    if StringIsNullOrEmpty(CsWeburl) then return end;
    local Path = string.gsub(CsWeburl, GameManager.GetPlatformName(), "");
    local fileName = "files.txt";
    local md5 = "md5#";
    local pt = "pc";
    -- 服务器放置文件的md5
    local TnewUpdate = { }
    local tupdate = { };

    if Util.isApplePlatform then pt = "/iphone/" end
    if Util.isAndroidPlatform then pt = "/android/" end
    Path = Path .. pt .. fileName .. "?v=" .. os.date("%Y%m%d%H%M%S");
    Path = string.gsub(Path, "///", "/")
    local Uw = WWW.New(Path);

    local function as()
        coroutine.wait(0);
        if not Uw.isDone then coroutine.start(as); return; end
        SavePlayerPrefs = { };
        if Uw.error ~= nil then
            return
        end
        local txt = Uw.text;
        -- error("====1111111111111" );
        if not string.find(txt, md5) then error("can't find file md5!"); return end
        local t = string.sub(txt, 1,(string.find(txt, md5) -1));
        --   error("====222222222222" );
        -- 需要更新得游戏md5#前面一节
        local t1 = string.split(t, '\n')
        local t2 = string.gsub(txt, t, "");
        t2 = string.gsub(t2, md5, "");
        TnewUpdate = string.split(t2, '\n');
        -- 需要更新得文件Md5值

        --  error("====3333333333333333" );
        -- 把文件和文件的MD5存到table
        for i = 1, #TnewUpdate do
            if string.len(TnewUpdate[i]) > 1 then
                local x1 = string.split(TnewUpdate[i], '|')
                -- x1[1]:lua/SHZ/MainPanel  x1[2]:为md5值
                tupdate[string.lower(x1[1])] = x1[2];
            end
        end
        --  error("====4444444444444444444" );
        -- 找出客户端游戏名字
        local function tt(str)
            local s = "";
            table.foreach(
            gameServerName,
            function(k, v)
                -- error("k======"..k.."==============="..v);
                if string.lower(str) == string.lower(k) then s = v end
            end
            );
            return s;
        end
        -- 找出要更新的游戏名字
        local un = { };
        for i = 1, #t1 do
            local l =(string.split(t1[i], '='));
            local lp = PlayerPrefs.GetString(l[1]) or "no";
            --  lp=1;
            --  error("lp============="..lp);
            --  error("l[2]============="..l[2]);
            if lp ~= l[2] then
                local ss = tt(l[1]);
                if ss ~= "" then table.insert(un, ss); end
                -- 需要下载完成后存储
                -- PlayerPrefs.SetString(l[1], l[2]);
                table.insert(SavePlayerPrefs, ss);
                table.insert(SavePlayerPrefs, l[1]);
                table.insert(SavePlayerPrefs, l[2]);
                --  error("ss========"..ss)
                --  error("l[1]========"..l[1])
                --  error("l[2]========"..l[2])
            else
                --  error("l[1]========"..l[1])
                --  error("l[2]========"..l[2])

            end
        end
        -- 找出要更新的游戏文件
        local function upup(localT2, webT)
            local s = { };
            local localT = { }
            for i = 1, #localT2 do
                local str = UpdateFile.GetMD5Name(localT2[i]);
                table.insert(localT, str)
            end

            for i = 1, #localT do
                local localfiles = PathHelp.AppHotfixResPath .. localT[i]
                --  error("localfiles====================================="..localfiles);
                if Util.Exists(localfiles) then
                    --   error("=============本地存在===================");
                    local localMd5 = string.format(Util.md5file(localfiles));
                    if webT[string.lower(localT[i])] ~= nil then
                        local webMd5 = string.format(webT[string.lower(localT[i])])
                        --           error("webMd5====================="..webMd5);
                        --         error("localMd5====================="..localMd5);
                        if string.len(webMd5) > string.len(localMd5) then
                            if string.find(webMd5, localMd5) == nil then
                                table.insert(s, localT[i])
                                --    error("======================================");
                            end
                        else
                            if string.find(localMd5, webMd5) == nil then
                                table.insert(s, localT[i])
                                --    error("===============string.find(localMd5, webMd5) == nil=======================");
                            end
                        end
                    end
                end
            end
            return s;
        end
        local updateGamge = { };
        -- 把每个要更新的游戏放到updateGamge中
        --  error("un=============================" .. #un);
        for i = 1, #un do
            local uns = un[i];
            updateGamge[uns] = upup(self.PassGameNameGetDownFiles(uns), tupdate)
        end
        if SetShowGame.NeedUpdate == nil or SetShowGame.NeedUpdate then
            table.foreach(
            updateGamge,
            function(k, v)
                for i = 1, #v do
                    if SetShowGame.NeedUpdate == nil or SetShowGame.NeedUpdate then
                        Util.DeletePath(PathHelp.AppHotfixResPath .. v[i])
                    end
                    --  error("PathHelp.AppHotfixResPath .. v[i]============" .. PathHelp.AppHotfixResPath .. v[i]);
                end
            end
            );
        end
        return updateGamge;
    end
    coroutine.start(as);
end

function UpdateFile.GetMD5Name(strName)
    local isEnc = AppConst.FileNameEncryption;
    if not(isEnc) then return strName end
    local finds = string.sub(strName, string.len(strName) -3, string.len(strName));
    if finds ~= ".lua" then return strName; end
    local s = string.gsub(strName, ".lua", "");
    local tb = string.split(s, "/");
    local newName = "";
    for i = 1, #tb do
        newName = newName .. Util.md52(tb[i]) .. "/";
    end
    newName = string.sub(newName, 0, string.len(newName) -1);
    newName = newName .. AppConst.LuaFileSuffix;
    return newName;
end

function UpdateFile.SaveFile(gamesname)
    for i = 1, #SavePlayerPrefs, 3 do
        if SavePlayerPrefs[i] == gamesname then
            PlayerPrefs.SetString(SavePlayerPrefs[i + 1], SavePlayerPrefs[i + 2]);
        end
    end
end

-- 通过游戏名字找出要下载的文件
function UpdateFile.PassGameNameGetDownFiles(gameName)
    local dofiles = { };
    local t = GameManager.PassScenNameToConfiger(gameName);
    if t.configer() == nil then return dofiles; end
    if t.configer().downFiles == nil then return dofiles; end
    return t.configer().downFiles;
end


-- 封装要下载整个module 的cs接口  t{"","",""....}
-- modName 模块的名字 比如 大厅是 "module02"
-- progressCallBack进度的回掉,回掉第一个参数是已经下载了多少字节，第二个参数是总大小字节
function UpdateFile.UnityWebRequestAsync(modName, progressCallBack)
    local t = GameManager.PassScenNameToConfiger(modName)
    local Files = t.configer().downFiles
    local NeedFiles = { };
    log("down module name: " .. modName);
    -- 创建一个下载队列
    local UWPacketQueue = UnityWebDownPacketQueue.New();
    -- 获取模块配置的下载文件
    local BaseValueConfigerJson = AppConst.gameValueConfiger:GetModule(modName)
    -- 循环取出要下载的文件 封装到下载队列

    for j = 1, #Files do
        for i = 0, BaseValueConfigerJson.Length - 1 do
            local bjson = BaseValueConfigerJson[i];
            --  error("Files[j]==" .. Files[j] .. " ====  bjson.dirPath=" .. bjson.dirPath);
            if string.lower(Files[j]) == string.lower(bjson.dirPath) then
                local localUlr = PathHelp.AppHotfixResPath .. bjson.dirPath;
                local isDown = true;
                if Util.Exists(localUlr) then
                    local localmd5 = MD5Helper.MD5File(localUlr);
                    if string.match(localmd5, bjson.md5) ~= nil then
                        isDown = false;
                    else
                        -- 清理本地缓存（注意：是缓存）
                        --error("清理本地缓存:"..bjson.dirPath.." , oldMd5:"..localmd5);
                        --Caching.ClearCachedVersion(bjson.dirPath, UnityEngine.Hash128.Parse(localmd5));
                        -- Caching.ClearOtherCachedVersions(bjson.dirPath,UnityEngine.Hash128.Parse(bjson.hash));
                    end
                end
                if isDown then
                    local fileWebUrl = AppConst.WebUrl .. "games/" .. bjson.dirPath .. "?m=" .. bjson.md5;
                      error("需要下载的资源地址:" .. fileWebUrl);
                    local UWPacket = UnityWebPacket.New();
					
                    UWPacket.urlPath = fileWebUrl;
                    UWPacket.localPath = localUlr;
                    UWPacket.size = bjson.size;
                    UWPacket.func = progressCallBack;
                    UWPacketQueue:Add(UWPacket);
                end
            end
        end
    end
    -- 创建一个空物体
    local obj = GameObject.New();
    obj.name = "UnityWebRequestAsync";
    -- 挂载执行下载队列的脚本
    local UWRAsync = obj:AddComponent(typeof(UnityWebRequestAsync));
    -- 传参开始执行
    UWRAsync:DownloadAsync(UWPacketQueue);
    return obj;
end
