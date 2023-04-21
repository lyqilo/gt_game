--require "Common/define"


GiveAndSendMoneyRecordItem = {};
local self = GiveAndSendMoneyRecordItem;

self.item = nil;
self.data = nil;
self.transform = nil;
self.myindex = 0;
self.luabe = nil;
self.bagtype = 0;--0:�ͱ���1:��ȡ
function GiveAndSendMoneyRecordItem:new()
    local obj = {};
    setmetatable(obj, self);
    self.__index = GiveAndSendMoneyRecordItem;
    return obj;
end

function GiveAndSendMoneyRecordItem:setBg(per)
    local go = newobject(per);
    self.transform = go.transform;
    go = nil;
end

function GiveAndSendMoneyRecordItem:setPoint(parentTran, point, btype)
    if self.transform ~= nil then
        self.transform:SetParent(parentTran);
        self.transform.localPosition = point;
        self.transform.localScale = Vector3.New(1, 1, 1);
        self.bagtype = btype;
    end
end

function GiveAndSendMoneyRecordItem:setData(args)
    if (self.bagtype == 0) then
        self.transform:Find("id"):GetComponent("Text").text = tostring(args["rid"]);
        self.transform:Find("name"):GetComponent("Text").text = tostring(args["rNick"]);
    else
        self.transform:Find("id"):GetComponent("Text").text = tostring(args["sid"]);
        self.transform:Find("name"):GetComponent("Text").text = tostring(args["sNick"]);
    end
    self.transform:Find("gold"):GetComponent("Text").text = tostring(args["num"]);
    self.transform:Find("Group/time"):GetComponent("Text").text = os.date("%Y-%m-%d %H:%M", args["time"]);
    self.transform:Find("Group/time"):GetComponent("Text").resizeTextForBestFit = true;
    self.myindex = args["id"];
    if SCPlayerInfo.IsVIP == 1 and self.bagtype == 0 then
        local recallBtn = self.transform:Find("Group/recall").gameObject;
        recallBtn:SetActive(true);
        BankPanel.m_luaBeHaviour:AddClick(recallBtn, function(go)
            log("撤回" .. self.myindex);
            local buffer = ByteBuffer.New();
            buffer:WriteInt(self.myindex);
            Network.Send(MH.MDM_3D_GOLDMINET, MH.SUB_3D_CS_WITHDRAW, buffer, gameSocketNumber.HallSocket);
        end);
    else
        self.transform:Find("Group/recall").gameObject:SetActive(false);
    end
end

function GiveAndSendMoneyRecordItem:doState(args)
    if self.transform == nil then
        return
    end
    --[[     function handler(obj,func)
            return function (...)
                return func(obj,...);
            end
        end--]]
    self.transform:Find("state/no").gameObject:SetActive(false);
    self.transform:Find("state/yes").gameObject:SetActive(false);
    if self.bagtype == 1 then
        self.transform:Find("name/no").gameObject:SetActive(false);
        self.transform:Find("name/yes").gameObject:SetActive(false);
    end
    if args == 0 then
        self.transform:Find("state/no").gameObject:SetActive(true);
        if self.bagtype == 1 then
            self.transform:Find("name/no").gameObject:SetActive(true);
            self.luabe:AddClick(self.transform:Find("state/no").gameObject, handler(self, self.clickhander));
        end
    elseif args == 1 then
        self.transform:Find("state/yes").gameObject:SetActive(true);
        if self.bagtype == 1 then
            self.transform:Find("name/yes").gameObject:SetActive(true);
        end
        --    elseif args==1 then
        --       self.transform:Find("state/yes").gameObject:SetActive(true);
        --       if self.bagtype==1 then
        --           self.transform:Find("name/yes").gameObject:SetActive(true);
        --        end
    end
end
function GiveAndSendMoneyRecordItem:setcolor(args)
    --    self.transform:Find("recordname"):GetComponent("Text").color = Color.New(args.r,args.g,args.b,args.a);
    --    self.transform:Find("recordmoneycount"):GetComponent("Text").color = Color.New(args.r,args.g,args.b,args.a);
    --    self.transform:Find("recordtime"):GetComponent("Text").color = Color.New(args.r,args.g,args.b,args.a);
end

function GiveAndSendMoneyRecordItem:setluabe(args)
    self.luabe = args;
end

function GiveAndSendMoneyRecordItem:clickhander(args)
    if self.myindex ~= 0 then
        local buffer = ByteBuffer.New();
        buffer:WriteLong(self.myindex);
        Network.Send(MH.MDM_3D_GOLDMINET, MH.SUB_3D_CS_PRESENT_GOLD_GET, buffer, gameSocketNumber.HallSocket);
    end
end

function GiveAndSendMoneyRecordItem:clearData()

    if self.transform ~= nil then
        self.transform:Find("id"):GetComponent("Text").text = " ";
        self.transform:Find("name"):GetComponent("Text").text = " ";
        self.transform:Find("gold"):GetComponent("Text").text = " ";
        self.transform:Find("Group/time"):GetComponent("Text").text = " ";
        self.myindex = 0;
        self.setcolor(Color.New(1, 1, 1, 1));
    end
end
