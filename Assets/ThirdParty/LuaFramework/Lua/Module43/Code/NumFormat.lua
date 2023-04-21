--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local NumFormat = {}
local self = NumFormat

function NumFormat.format1(num, dot_weishu)
 if(num == nil)then
    logError("ni da ye")
    return ""
 end
    local s = ""
    if(num >= 100000000)then
        num = num / 100000000
        s = "y"
    elseif(num >= 10000)then
        num = num / 10000
        s = "w"
    elseif(num <= -100000000)then
        num = num / 100000000
        s = "y"
    elseif(num <= -10000)then
        num = num / 10000
        s = "w"
    end
    local fmt = '%.' .. dot_weishu .. 'f'
    local m = string.format(fmt, num)
    local len = string.len(m)

    if(string.sub(m,len,len) == "0")then
        m = string.sub(m,1, len - 1)
        local len = string.len(m)
        if(string.sub(m,len,len) == "0")then
            m = string.sub(m,1, len - 2)
        end
    end

    if(s ~= "")then
        m = m..s
    end
    return m
end

function NumFormat.format2(num, dot_weishu)
 if(num == nil)then
    logError("ni da ye")
    return ""
 end
    local s = ""
    if(num >= 100000000)then
        num = num / 100000000
        s = "亿"
    elseif(num >= 10000)then
        num = num / 10000
        s = "万"
    elseif(num <= -100000000)then
        num = num / 100000000
        s = "亿"
    elseif(num <= -10000)then
        num = num / 10000
        s = "万"
    end
    local fmt = '%.' .. dot_weishu .. 'f'
    local m = string.format(fmt, num)
    local len = string.len(m)

    if(string.sub(m,len,len) == "0")then
        m = string.sub(m,1, len - 1)
        local len = string.len(m)
        if(string.sub(m,len,len) == "0")then
            m = string.sub(m,1, len - 2)
        end
    end

    if(s ~= "")then
        m = m..s
    end
    return m
end

function NumFormat.ToCharArray(num)
    local str = tostring(num);
    local list1 = {}
    for i = 1, string.len(str) do
        table.insert(list1, #list1 + 1, string.sub(str, i, i));
    end
    return list1;
end

 function NumFormat.ChnageText(num)
    local arr = self.ToCharArray(num);
    local str = "";
    for i = 1, #arr do
        if arr[i] == "." then
            str = str .. string.format("<sprite=%s>", 10);
        elseif arr[i] == "," then
            str = str .. string.format("<sprite=%s>", 11);
        elseif arr[i] == "-" or arr[i] == "+" then
            str = str .. string.format("<sprite=%s>", 12);
        elseif arr[i] == "q" then
            str = str .. string.format("<sprite=%s>", 13);
        elseif arr[i] == "w" then
            str = str .. string.format("<sprite=%s>", 14);
        elseif arr[i] == "y" then
            str = str .. string.format("<sprite=%s>", 15);
        -- elseif arr[i] == "=" then
        --     str = str .. string.format("<sprite=%s>", 16);
        -- elseif arr[i] == "q" then
        --     str = str .. string.format("<sprite=%s>", 17);
        -- elseif arr[i] == "w" then
        --     str = str .. string.format("<sprite=%s>", 18);
        -- elseif arr[i] == "y" then
        --     str = str .. string.format("<sprite=%s>", 19);
        -- elseif arr[i] == "win" then
        --     str = str .. string.format("<sprite=%s>", 20);
        else
            str = str .. string.format("<sprite=%s>", arr[i]);
        end
    end
    return str;
 end

function NumFormat.ReturnGoldToText(num)
    local num1=""
    local numstr = "";
    local endstr = "";
    local neednum = tonumber(num);
    if neednum < 10000 then
        numstr = tostring(neednum)
    elseif neednum < 100000000 then
        numstr = tostring(neednum / 10000);
        endstr = "w";
    else
        numstr = tostring(neednum / 100000000);
        endstr = "y";
    end

    if #numstr > 4 then
        numstr = string.sub(numstr, 1, 7);
    end
    for i = 1, #(numstr) do
        if ("." == string.sub(numstr, i, i)) then
            numstr = string.sub(numstr, 1, i + 2);
        end
    end

    local returnstr =num1..numstr .. endstr;
    return returnstr;
 end

return NumFormat

--endregion
