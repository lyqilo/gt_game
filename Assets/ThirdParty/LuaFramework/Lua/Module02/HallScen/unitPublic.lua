

unitPublic = {}
self = unitPublic;

--显示金钱
function unitPublic.showNumberText(numInt)
    numInt=toInt64(numInt)
    local numStr = "";
    local tempNumInt =toInt64(0)
    local targNum=10000;
    if(numInt / targNum >= toInt64(1) ) then -- 大于一万 使用“万”字图片
        tempNumInt = numInt / targNum;
        numStr = tostring(tempNumInt) .. "w";
        if(numInt / 100000000 >=toInt64(1) ) then -- 大于一亿 使用“亿”字图片
            --error("int is : 100000000");
            tempNumInt = numInt / 100000000;
            numStr = tostring(tempNumInt) .. "y";
        end
        local front = string.sub(numStr, 1, (#numStr) - 1 ); --数字部分
        local endStr = string.sub(numStr, #numStr, #numStr ); --"万" “亿” 部分

        if(#front > 4) then --若数字部分长度大于4 则取前4位
            front = string.sub(front, 1, 4);
        end

        if( "." == string.sub(front, 4, 4) ) then --若第4位是符号 '.' 则省去
            front = string.sub(front, 1, (#front) - 1);
        end

        if(endStr == "w") then
            endStr = "万";
        elseif(endStr == "y") then
            endStr = "亿";
        end

        numStr = front .. endStr; --将数字部分与 "万" "亿" 连接

    else
        tempNumInt = numInt;
        numStr = tostring(tempNumInt) .. "";
    end
    return tostring(numStr);

end

--显示金钱 只是万和亿 用 w y
function unitPublic.showNumberText2(numInt)

   --error("self.FirstGold.text___"..numInt);
    local numStr = "";
    local tempNumInt = 0;

    --numTra.gameObject:SetActive(true);

    if(numInt / 10000 >= 1 ) then -- 大于一万 使用“万”字图片
        --error("int is : 10000");
        tempNumInt = numInt / 10000;
        numStr = tempNumInt .. "w";

        if(numInt / 100000000 >=1 ) then -- 大于一亿 使用“亿”字图片
            --error("int is : 100000000");
            tempNumInt = numInt / 100000000;
            numStr = tempNumInt .. "y";
        end

        local front = string.sub(numStr, 1, (#numStr) - 1 ); --数字部分
        local endStr = string.sub(numStr, #numStr, #numStr ); --"万" “亿” 部分

        if(#front > 4) then --若数字部分长度大于4 则取前4位
            front = string.sub(front, 1, 4);
        end

        if( "." == string.sub(front, 4, 4) ) then --若第4位是符号 '.' 则省去
            front = string.sub(front, 1, (#front) - 1);
        end

        if(endStr == "w") then
            endStr = "w";
        elseif(endStr == "y") then
            endStr = "y";
        end

        numStr = front .. endStr; --将数字部分与 "万" "亿" 连接

    else
        tempNumInt = numInt;
        numStr = tempNumInt .. "";
    end

    return numStr;

end