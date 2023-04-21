local isDebug = true
--输出日志-------------------------------------------
function log(str)
    if isDebug then
        Util.Log(str)
    end
end

function logYellow(msg)
    if isDebug then
        Util.Log("<color=yellow>" .. msg .. "</color>")
    end
end

function logCyan(msg)
    --Util.Log("<color=cyan>" .. msg .. "</color>");
    if isDebug then
        Util.Log("<color=red>" .. msg .. "</color>")
    end
end

function logBlue(msg)
    if isDebug then
        Util.Log("<color=blue>" .. msg .. "</color>")
    end
end

function logGreen(msg)
    if isDebug then
        Util.Log("<color=green>" .. msg .. "</color>")
    end
end

--错误日志--
function error(str)
    if isDebug then
        Util.LogError(str)
    end
end

--错误日志--
function logError(str)
    if isDebug then
        Util.LogError(str)
    end
end

--警告日志--
function logWarn(str)
    if isDebug then
        Util.LogWarning(str)
    end
end

-----------------------------------------------------
function handler(obj, func)
    return function(...)
        return func(obj, ...)
    end
end

function ToCharArray(num)
    local str = tostring(num);
    local list1 = {}
    for i = 1, string.len(str) do
        table.insert(list1, #list1 + 1, string.sub(str, i, i));
    end
    return list1;
end
function RETTEXT(num)
    local arr = ToCharArray(num);
    local str = "";
    for i = 1, #arr do
        if arr[i] == "." then
            str = str .. string.format("<sprite=%s>", 10);
        elseif arr[i] == "," then
            str = str .. string.format("<sprite=%s>", 11);
        elseif arr[i] == "+" then
            str = str .. string.format("<sprite=%s>", 12);
        elseif arr[i] == "-" then
            str = str .. string.format("<sprite=%s>", 13);
        elseif arr[i] == "*" then
            str = str .. string.format("<sprite=%s>", 14);
        elseif arr[i] == "/" then
            str = str .. string.format("<sprite=%s>", 15);
        elseif arr[i] == "q" then
            str = str .. string.format("<sprite=%s>", 16);
        elseif arr[i] == "w" then
            str = str .. string.format("<sprite=%s>", 17);
        elseif arr[i] == "y" then
            str = str .. string.format("<sprite=%s>", 18);
        elseif arr[i] == "l" then
            str = str .. string.format("<sprite=%s>", 19);
        else
            str = str .. string.format("<sprite=%s>", arr[i]);
        end
    end
    return str;
end
-- 写文件
function ReadFile(file)
    assert(file, "file open failed")
    local fileTab = {}
    local line = file:read()
    while line do
        table.insert(fileTab, line)
        line = file:read()
    end
    return fileTab
end

-- 写文件
function WriteFile(file, fileTab)
    assert(file, "file open failed")
    for i, line in ipairs(fileTab) do
        -- log("Write=" .. line)
        file:write(line)
        file:write("\n")
    end
end

function toInt64(num)
    -- local low, high = int64.new(num);
    return int64.new(tostring(num))
end

function isInt64(num)
    if int64.equals(x, 123) then
        return true
    else
        return false
    end
end

function CSBufferToInt64(bf)
    local n1 = bf:ReadUInt32()
    local n2 = bf:ReadUInt32()
    if n2 > 0 then
        return n1 + n2 + n2 * 4294967295
    end
    return n1
end

--播放音乐--------------------------------------------
function playBGM(bgmName)
    if SoundManager then
        SoundManager.PlayBGM(bgmName)
    end
end

function playAudio(effectName, pos, parent)
    if SoundManager then
        SoundManager.PlayEffect(effectName, pos, parent)
    end
end
-----------------------------------------------------

--加载对象--------------------------------------------

function LoadAssetObj(abName, assetName)
    return Util.LoadAssetObj(abName, assetName)
end

function LoadAsset(abName, assetname)
    return Util.LoadAsset(abName, assetname)
end

function LoadAssetAsync(abName, name, callBack, crate, show)
    if crate == nil then
        crate = true
    end
    if show == nil then
        show = true
    end
    LoadAssetCacheAsync(abName, name, callBack, crate, show)
end

function LoadAssetCacheAsync(abName, name, callBack, crate, show)
    if crate == nil then
        crate = true
    end
    if show == nil then
        show = true
    end
    local pak = ABPacket.New()
    pak.abName = abName
    pak.bundleName = name
    pak.crate = crate
    pak.show = show
    pak.callFunc = callBack

    resMgr:LoadAssetBundleAsync(pak)
end

function Unload(abName)
    Util.Unload(abName)
end

-----------------------------------------------------

--查找对象--------------------------------------------
function find(str)
    return GameObject.Find(str)
end

function destroy(obj)
    GameObject.Destroy(obj)
end

function newObject(prefab)
    return GameObject.Instantiate(prefab)
end

function newobject(prefab)
    return GameObject.Instantiate(prefab)
end
-----------------------------------------------------

--获取组件-------------------------------------------
function getComponent(go, subnode, typeName)
    return Util.GetComponent(go, subnode, typeName)
end

function addComponent(go, typeName)
    return Util.AddComponent(go, typeName)
end

function getChild(go, subnode)
    return Util.GetChild(go, subnode)
end

--获取transform所有子节点
function getChilds(transform)
    local childs = transform:GetChilds()
    local childtb = {}
    for i = 0, childs.Length - 1 do
        table.insert(childtb, childs[i])
    end
    return childtb
end

function getPeer(go, subnode)
    return Util.GetPeer(go, subnode)
end

-- unity 对象判断为空, 如果你有些对象是在c#删掉了，lua 不知道
-- 判断这种对象为空时可以用下面这个函数。
function IsNil(uobj)
    return uobj == nil or uobj:Equals(nil)
end
-----------------------------------------------------

function getStringNum(strnum)
    local num = tonumber(strnum)
    if num == nil then
        return strnum
    else
        local yi = ""
        local wan = ""
        local len = string.len(num)
        if len >= 9 then
            --超过一亿了
            yi = math.floor(num / 100000000)
            wan = math.floor((num - yi * 100000000) / 1000000)
            return (yi .. "." .. wan .. "亿")
        else
            return num
        end
    end
end

function emptyFunc()
end

function strBySecond(time)
    local ret = ""
    local times = math.floor(time)
    local tian = math.floor(times / (60 * 60 * 24))
    if tian > 0 then
        return tian .. "天"
    end

    times = times % (60 * 60 * 24)
    local hour = math.floor(times / (60 * 60))

    times = times % (60 * 60)
    local min = math.floor(time / 60)

    local sec = times % 60

    return string.format("%02d:%02d:%02d", hour, min, sec)
end

--以小时为单位，得到字符串
function getTimeStringByHour(time)
    local ret = ""
    local tian = 0
    local xiaoshi = 0
    if time / 24 > 1 then
        tian = math.floor(time / 24)
        ret = tian .. "天"
    end

    xiaoshi = time % 24
    if tian == 0 or xiaoshi > 0 then
        ret = ret .. xiaoshi .. "小时"
    end

    return ret
end

function getStringNumByWan(num)
    local len = string.len(num)
    if len >= 5 then
        return num / 10000 .. "万"
    else
        return num
    end
end

function getRichText(str, color)
    if color == nil or str == nil then
        return
    end

    return "<color=#" .. color .. ">" .. str .. "</color>"
end

function getItemNameById(id)
    local ret = ""

    local data = prop[id]
    if data ~= nil then
        ret = data.propName
    end

    return ret
end

-- 获取一个唯一的事件序号
function GetEventIndex(n)
    local m = n or 50000
    local function r()
        return math.random(m, m + 10000)
    end
    local index = r()
    while Event.Exist(tostring(index)) do
        error("检测到事件ID 重复=" .. index)
        index = r()
    end
    return tostring(index)
end

function StringIsNullOrEmpty(args)
    if args == nil then
        return true
    end
    if tostring(args) == "" then
        return true
    end
    if tostring(args) == "null" then
        return true
    end
    if tostring(args) == "nil" then
        return true
    end
    return false
end

function SetC2SInfo(t, _table)
    local Setbuffer = ByteBuffer.New()
    local count = #(t)
    for i = 1, count do
        local size = t[i]
        if (size == DataSize.byte) then
            Setbuffer:WriteByte(_table[i])
        elseif (size == DataSize.UInt16) then
            Setbuffer:WriteUInt16(_table[i])
        elseif (size == DataSize.UInt32) then
            Setbuffer:WriteUInt32(_table[i])
        elseif (size == -1) then
            Setbuffer:WriteString(_table[i])
        elseif true then
            Setbuffer:WriteBytes(size, _table[i])
        end
    end
    return Setbuffer
end

-- 读取byte数据（不用补位）
function GetS2CInfo(t, buffer)
    local v = {}
    local count = #(t)
    for i = 1, count do
        local size = t[i]
        if (size == DataSize.byte) then
            v[i] = buffer:ReadByte()
        elseif (size == DataSize.UInt16) then
            v[i] = buffer:ReadUInt16()
        elseif (size == DataSize.Int32) then
            v[i] = buffer:ReadInt32()
        elseif (size == DataSize.UInt32) then
            v[i] = buffer:ReadUInt32()
        elseif (size == DataSize.UInt64) then
            -- local x = toInt64(buffer:ReadInt64Str());
            -- if x < toInt64(0) then v[i] = x elseif x < toInt64(2000000000) then v[i] = int64.tonum2(tostring(x)) else v[i] =x  end
            local x = buffer:ReadInt64Str()
            v[i] = tonumber(x)
        elseif (size == DataSize.String) then
            v[i] = buffer:ReadString(v[i - 1])
        elseif (size == DataSize.null) then
            v[i] = "null"
        elseif (size == DataSize.ArrayInt16) then
            v[i] = {}
            for i = 1, v[i - 1] do
                table.insert(v[i], #v[i] + 1, buffer:ReadUInt16())
            end
        elseif (size == DataSize.ArrayInt32) then
            v[i] = {}
            for i = 1, v[i - 1] do
                table.insert(v[i], #v[i] + 1, buffer:ReadUInt32())
            end
        elseif (size == DataSize.ArrayString) then
            v[i] = {}
            for i = 1, v[i - 1] do
                table.insert(v[i], #v[i] + 1, buffer:ReadUInt16())
            end
        end
    end
    return v
end


function LoadAssetObjAsync(objName, callBack)
    log("==========download1----");
    local k = objName .. "/" .. objName .. ".unity3d"
    local url = PathHelp.PathPrefix .. PathHelp.AppHotfixResPath .. k
    local version = 3
    log("==========download2----");
    local a = function()
        coroutine.wait(0)
        local kk = resMgr.bundles:ContainsKey(objName)
        if not kk then
            local www = WWW.LoadFromCacheOrDownload(url, version)
            while not (www.isDone) do
                log("==========download----");
                coroutine.wait(1)
            end
            if not StringIsNullOrEmpty(www.error) then
                error("lua func locadSeneAsync:" .. www.error)
                return
            end
            local ab = www.assetBundle
            -- LoadSceneAsyncSceneNameAB[sceneName] = ab;
            resMgr.bundles:Add(objName, ab)
        end
        local pak = LuaFramework.ABPacket.New()
        pak.abName = abName
        pak.bundleName = name
        pak.crate = crate
        pak.show = show
        pak.callFunc = callBack

        resMgr:LoadAssetBundleAsync(pak)
    end

    coroutine.start(a)
end
function LoadSceneAsync(sceneName, callBack, mod)
    if mod == nil then
        mod = 1
    end
    local k = sceneName .. "/" .. sceneName .. ".unity3d"

    local vjosn = nil
    if AppConst.gameValueConfiger ~= nil then
        vjosn = AppConst.gameValueConfiger:GetValue(k)
    end

    if StringIsNullOrEmpty(vjosn.moduleName) then
        vjosn = AppConst.valueConfiger:GetValue(k)
    end
    logYellow("vjosn222======="..vjosn.moduleName);

    local version = "3"
    if (vjosn ~= nil) then
        version = vjosn.version -- log(sceneName .. " version==" .. version);
    else
        --error(sceneName .. " version=nil")
    end

    local url = PathHelp.PathPrefix .. PathHelp.AppHotfixResPath .. k
    version = tonumber(version) or "3"

    local a = function()
        coroutine.wait(0)
        local k = resMgr.bundles:ContainsKey(sceneName)
        if k == false then
            local isload = false;
            resMgr:LoadSceneBundleAsync(sceneName, function(ab)
                resMgr.bundles:Add(sceneName, ab)
                isload = true;
            end);
            while not isload do
                coroutine.wait(0.1);
            end
        end
        logYellow("sceneName=="..sceneName);
        local apt = SceneManager.LoadSceneAsync(sceneName, LoadSceneMode.Additive)
        callBack(apt)
    end

    coroutine.start(a)
end

-- 判断字符串是否只为数字或者汉字
function RegularString(str)
    local isRe = true
    if string.find(str, "%c") then
        isRe = false
    elseif string.find(str, "%s") then
        isRe = false
    elseif string.find(str, "%p") then
        isRe = false
        -- elseif string.find(str,'[%+%-]?%d+') then isRe=false;
    end
    return isRe
end

function SetCanvasScalersMatch(canvasScalers, const)
    if const then
        canvasScalers.matchWidthOrHeight = const
        return
    end
    local width = Screen.width
    local height = Screen.height
    local matchWidth = 0
    local matchheight = 0
    local t = {
        [string.format("%.1f", 16 / 9)] = matchWidth,
        [string.format("%.1f", 18 / 9)] = matchWidth,
        [string.format("%.1f", 4 / 3)] = matchheight,
        [string.format("%.1f", 3 / 2)] = matchheight,
        [string.format("%.1f", 16 / 10)] = matchheight,
        [string.format("%.1f", 16 / 12)] = matchheight,
        [string.format("%.1f", 15 / 10)] = matchheight,
        [string.format("%.1f", 2244 / 1668)] = matchheight,
        [string.format("%.1f", 1920 / 1080)] = matchheight,
        [string.format("%.1f", 1920 / 1080)] = matchheight,
        [string.format("%.1f", 2560 / 1536)] = matchheight,
        [string.format("%.1f", 2960 / 1440)] = matchWidth
    }
    local k = string.format("%.1f", height / width)
    canvasScalers.matchWidthOrHeight = t[k] or matchheight
end

-- 判断字符串是否只为数字或者汉字
function RegularString(str)
    local isRe = true
    if string.find(str, "%c") then
        isRe = false
    elseif string.find(str, "%s") then
        isRe = false
    elseif string.find(str, "%p") then
        isRe = false
        -- elseif string.find(str,'[%+%-]?%d+') then isRe=false;
    end
    return isRe
end

-- 启动测试时间
-- 默认时间为毫秒
GlobalTime = 0
function TestStartTime()
    GlobalTime = 0
    GlobalTime = math.ceil(UnityEngine.Time.time * 1000)
end
-- 结束测试时间
function TestEndTime()
    error("花费时间：" .. (math.ceil(UnityEngine.Time.time * 1000)) - GlobalTime .. "毫秒")
end

-- 模拟C#的list
function RemoveTab(tab, num)
    local t = {}
    local j = 1
    for i = 1, #tab do
        if num ~= i then
            t[j] = tab[i]
            j = j + 1
        end
    end
    return t
end

-- 2点贝塞尔曲线
function BezierPathFor_2(p1, p2, t)
    -- if type(p1) ~="Vector3" then error("函数 BezierPathFor_2 的参数不是 Vector3") end
    -- if type(p2) ~="Vector3" then error("函数 BezierPathFor_2 的参数不是 Vector3") end
    local it = 1 - t
    local x = it * p1.x + t * p2.x
    local y = it * p1.y + t * p2.y
    local z = it * p1.z + t * p2.z
    return Vector3.New(x, y, z)
end

-- 3点贝塞尔曲线
function BezierPathFor_3(p1, p2, p3, t)
    local it = 1 - t
    local x = it * it * p1.x + 2 * it * t * p2.x + t * t * p3.x
    local y = it * it * p1.y + 2 * it * t * p2.y + t * t * p3.y
    local z = it * it * p1.z + 2 * it * t * p2.z + t * t * p3.z
    return Vector3.New(x, y, z)
end

-- 4点贝塞尔曲线
function BezierPathFor_4(p1, p2, p3, p4, t)
    local it = 1 - t
    local x = it * it * it * p1.x + 3 * it * it * t * p2.x + 3 * it * t * t * p3.x + t * t * t * p4.x
    local y = it * it * it * p1.y + 3 * it * it * t * p2.y + 3 * it * t * t * p3.y + t * t * t * p4.y
    local z = it * it * it * p1.z + 3 * it * it * t * p2.z + 3 * it * t * t * p3.z + t * t * t * p4.z
    return Vector3.New(x, y, z)
end

-- 5点贝塞尔曲线
function BezierPathFor_5(p1, p2, p3, p4, p5, t)
    local it = 1 - t
    local x = it * it * it * it * p1.x + 4 * it * it * it * t * p2.x + 6 * it * it * t * t * p3.x + 4 * it * t * t * t * p4.x +
            t * t * t * t * p5.x
    local y = it * it * it * it * p1.y + 4 * it * it * it * t * p2.y + 6 * it * it * t * t * p3.y + 4 * it * t * t * t * p4.y +
            t * t * t * t * p5.y
    local z = it * it * it * it * p1.z + 4 * it * it * it * t * p2.z + 6 * it * it * t * t * p3.z + 4 * it * t * t * t * p4.z +
            t * t * t * t * p5.z
    return Vector3.New(x, y, z)
end

-- 映射屏幕坐标到世界坐标
function ScrrenPointToWorlSpace(sx, sy, viewCamera, z)
    local halfY = math.tan(viewCamera.fieldOfView * math.pi * 0.5 / 180) * z
    local halfX = viewCamera.aspect * halfY
    local x = (sx / Screen.width - 0.5)
    local biasX = x / 0.5
    local y = (sy / Screen.height - 0.5)
    local biasY = y / 0.5
    local normPos = Vector3.New(biasX * halfX, biasY * halfY, z)
    local worldPos = viewCamera.transform:TransformPoint(normPos)
    return worldPos
end

function WorlPointToScreenSpace(wpos, viewCamera)
    local sp = viewCamera:WorldToScreenPoint(wpos)
    return sp
end

-- 获取角度
function getRotation(x, y, splitX)
    x = x - splitX
    local rotz = math.atan(y / x)
    if (x < 0) then
        rotz = rotz - math.pi * 1.5
    else
        rotz = rotz + math.pi * 1.5
        rotz = rotz * 180.0 / 3.1415
    end
    return rotz
end

function getLeng(num)
    local str = tostring(num)
    return #str
end

function floatEqules(f1, f2)
    local dis = f1 - f2
    if dis <= 0.0003 and dis >= -0.003 then
        return true
    end
    return false
end

local PacketName = ""
function GamePacketName(_packetName)
    PacketName = _packetName
end

function GameRequire(name, _packetname)
    if _packetname then
        return reimport(_packetname .. "." .. name)
    else
        if PacketName then
            return reimport(PacketName .. "." .. name)
        else
            return reimport(name)
        end
    end
end

function clone(object)
    local t = {}
    local function copyObj(object)
        if type(object) ~= "table" then
            return object
        elseif t[object] then
            return t[object]
        end

        local newt = {}
        t[object] = newt
        for k, v in pairs(object) do
            newt[copyObj(k)] = copyObj(v)
        end
        return setmetatable(newt, getmetatable(object))
    end
    return copyObj(object)
end

function LuaResetGame()
    removeRequired()
    Util.ResetGame()
end

function ShowWaitPanel(obj, b, t)
    if IsNil(obj) then
        return
    end
    obj.gameObject:SetActive(b)
    if not b then
        return
    end
    if t == nil then
        return
    end
    if t == 0 then
        return
    end
    coroutine.start(
            function()
                coroutine.wait(t)
                ShowWaitPanel(obj, not b, nil)
            end
    )
end
function removeRequired()
    for key, _ in pairs(package.preload) do
        package.preload[key] = nil
    end
    for key, _ in pairs(package.loaded) do
        package.loaded[key] = nil
    end
end

function numberToString(szNum)
    ---阿拉伯数字转中文大写
    local szChMoney = ""
    local iLen = 0
    local iNum = 0
    local iAddZero = 0
    local hzUnit = { "", "十", "百", "千", "万", "十", "百", "千", "亿", "十", "百", "千", "万", "十", "百", "千" }
    local hzNum = { "零", "一", "二", "三", "四", "五", "六", "七", "八", "九" }
    if nil == tonumber(szNum) then
        return tostring(szNum)
    end
    iLen = string.len(szNum)
    if iLen > 10 or iLen == 0 or tonumber(szNum) < 0 then
        return tostring(szNum)
    end
    for i = 1, iLen do
        iNum = string.sub(szNum, i, i)
        if iNum == 0 and i ~= iLen then
            iAddZero = iAddZero + 1
        else
            if iAddZero > 0 then
                szChMoney = szChMoney .. hzNum[1]
            end
            szChMoney = szChMoney .. hzNum[iNum + 1] --//转换为相应的数字
            iAddZero = 0
        end
        if (iAddZero < 4) and (0 == (iLen - i) % 4 or 0 ~= tonumber(iNum)) then
            szChMoney = szChMoney .. hzUnit[iLen - i + 1]
        end
    end
    local function removeZero(num)
        --去掉末尾多余的 零
        num = tostring(num)
        local szLen = string.len(num)
        local zero_num = 0
        for i = szLen, 1, -3 do
            szNum = string.sub(num, i - 2, i)
            if szNum == hzNum[1] then
                zero_num = zero_num + 1
            else
                break
            end
        end
        num = string.sub(num, 1, szLen - zero_num * 3)
        szNum = string.sub(num, 1, 6)
        --- 开头的 "一十" 转成 "十" , 贴近人的读法
        if szNum == hzNum[2] .. hzUnit[2] then
            num = string.sub(num, 4, string.len(num))
        end
        return num
    end
    return removeZero(szChMoney)
end

function Is_InTable(value, tab)
    for k,v in ipairs(tab) do
      if v == value then
          return true
      end
    end
    return false
end
local Nums = {
    1000000000000000000.0,
    1000000000000000.0,
    1000000000000.0,
    1000000000.0,
    1000000.0
}
local NumKeys = {
    "Q","T","B","M","K"
}

function ShortNumber(orginNum,divideRate,useThousand)
    local num = tonumber(orginNum) or 0;
    if (num == nil) then 
        return "0"; 
    end
    if divideRate == nil then
        num = num / GameManager.MoneyRate;
    else
        num = num / divideRate;        
    end
    local tempnum = num;
    local yu = 0;
    for i = 1, #Nums do
        local n = Nums[i];
        if (num >= n) then
            tempnum = num * 1000 / n;
            yu = math.ceil(tempnum * 100) % 100;
            if yu > 0 then
                if(useThousand ~= nil and not useThousand) then
                    return string.format("%.02f",tempnum)..NumKeys[i];
                else
                    local str = string.format("%.02f",tempnum);
                    return FormatThousands(str)..NumKeys[i];
                end
            else
                if(useThousand ~= nil and not useThousand) then
                    return string.format("%.02f",tempnum)..NumKeys[i];
                else
                    local str = string.format("%.02f",tempnum);
                    return FormatThousands(str)..NumKeys[i];
                end
            end
        end
    end
    local result = nil;
    if(useThousand ~= nil and not useThousand) then
        result = string.format("%.02f",tempnum);
    else
        local str = string.format("%.02f",tempnum);
        result = FormatThousands(str);
    end
    return result;
end

function ShowRichText(str)
    --展示tmp字体
    local arr = ConvertCharArray(str);
    local _str = "";
    for i = 1, #arr do
        _str = _str .. string.format("<sprite name=\"%s\" tint=1>", arr[i]);
    end
    return _str;
end
function ConvertCharArray(num)
    --拆解字符串
    local str = tostring(num);
    local list1 = {}
    for i = 1, string.len(str) do
        table.insert(list1, #list1 + 1, string.sub(str, i, i));
    end
    return list1;
end
function FormatThousands(num)
    --对数字做千分位操作
    local function checknumber(value)
        return tonumber(value) or 0
    end
    local formatted = string.format("%.02f",checknumber(num));
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then
            break
        end

    end
    return formatted
end
function CheckNear(goal,goalList,ratio)
    local index = -1;
    if (goalList == nil or #goalList <= 0) then
        return 0;
    end
    local goalRatio = (ratio == nil or ratio <= 0) and 30 or ratio;
    local checkGoal = goal / goalRatio;
    local diffGoal = -1;
    for i = 1, #goalList do
        local diff = goalList[i] - checkGoal;
        if diff < 0 then
            diff = diff * -1;
        end
        if diffGoal <= 0 then
            diffGoal = diff;
            index = i;
        else
            if diffGoal > diff then
                index = i;
                diffGoal = diff;
            end
        end
    end
    return index < 1 and 1 or index;
end