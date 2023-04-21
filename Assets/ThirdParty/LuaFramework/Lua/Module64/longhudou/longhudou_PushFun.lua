longhudou_PushFun = {};
local self = longhudou_PushFun;

-- 创建数字Img显示对象
function longhudou_PushFun.CreatShowNum(father, getnumstr,numpathstr,isdanw,w,isagin,aginw,aginx) 
    father.transform:GetComponent("TextMeshProUGUI").text=RETTEXT(getnumstr)
end

--显示金钱 只是万和亿 用 w y
function longhudou_PushFun.showNumberText2(numInt)

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

    return tostring(numStr);

end