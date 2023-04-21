longhudou_PushFun = {};
local self = longhudou_PushFun;

-- 创建数字Img显示对象
function longhudou_PushFun.CreatShowNum(father, getnumstr,numpathstr,isdanw,w,isagin,aginw,aginx) 
    local numstr = tostring(getnumstr);
     if isdanw==true then
        numstr = self.showNumberText2(getnumstr);
     end   
    if IsNil(father) then
       return;
    end
    local splen =  father.transform.childCount;
    local numlen = string.len(numstr);
    --local alen =  math.max(0,splen-numlen);
    if splen > numlen then
        for j =numlen , splen-1 do
            --destroy(father.transform:GetChild(j).gameObject);
            father.transform:GetChild(j).gameObject:SetActive(false);
        end
    end
    local klx = 0;
    local lastklx = 0;
    local kw = 0;
    local item = nil;
    local itemsize = nil;
    for i = 1, string.len(numstr) do
        local prefebnum = string.sub(numstr, i, i);
        prefebnum = self.repaceNum(prefebnum);
        item = longhudou_Data.numres.transform:Find(numpathstr..prefebnum);
        itemsize = item.transform:GetComponent("RectTransform").sizeDelta;
        if kw ~= 0 then
            klx = klx+lastklx+itemsize.x/2;
        end
        lastklx = itemsize.x/2;
        kw = kw + itemsize.x;
        if splen < i then
            local go2 = newobject(item.gameObject);
            go2.transform:SetParent(father.transform);
            go2.transform.localScale = Vector3.New(1,1,1);
            go2.transform.localPosition = Vector3.New(klx, 0, 0);
            go2.name = prefebnum;
        else
            -- if tonumber(prefebnum) ~= tonumber(father.transform:GetChild(i - 1).gameObject.name) then
            local itemobj = father.transform:GetChild(i-1).gameObject;
            itemobj:SetActive(true);
            itemobj.name = prefebnum;
            itemobj:GetComponent('Image').sprite = item.gameObject:GetComponent('Image').sprite;
            itemobj.transform:GetComponent("RectTransform").sizeDelta = Vector2.New(itemsize.x,itemsize.y);
            itemobj.transform.localPosition = Vector3.New(klx, 0, 0);
            -- end
        end
    end
     local sy = father.transform.localPosition.y;
    if isagin == 1 then
        father.transform.localPosition = Vector3.New(aginx,sy,0);
    elseif isagin == 2 then
        father.transform.localPosition = Vector3.New(aginx+(aginw-kw)/2,sy,0);
    elseif isagin == 3 then
        father.transform.localPosition = Vector3.New(aginx-kw,sy,0);
    end
    return kw,aginx;
end

function longhudou_PushFun.repaceNum(args)
    if args == "." then
        return 10;
    elseif args == "w" then
        return 11;
    elseif args == "y" then
        return 12;
    end
    return args;
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