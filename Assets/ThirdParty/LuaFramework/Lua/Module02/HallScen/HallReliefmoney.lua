
HallReliefmoney = { };
local self=HallReliefmoney;

function HallReliefmoney.init(t)
    self.reliefmoney = t.transform:Find("Compose/reliefmoney");
    self.reliefmoneyTimerTxt = self.reliefmoney:Find("timertxt");
    self.reliefmoneyTimerBg  = self.reliefmoney:Find("Image").gameObject;
    self.reliefmoney:GetComponent('Button').interactable = false;
    self.reliefmoneyTimerTxt:GetComponent("Text").text = " ";
    self.reliefmoneyTimerBg:SetActive(false);
    self.reliefmoney.gameObject:SetActive(false);
    self.reqRelieFmoney();
    t.LuaBehaviour:AddClick(self.reliefmoney.gameObject,self.clickRelieFmoney);
end

function HallReliefmoney.goldChang()
    self.setRelieFmoneyBtn();
    if self.reliefmoneyostimer == nil then
        self.reliefmoneyostimer = tonumber(os.time());
    end
    if SCPlayerInfo._20dwAlmsGetLeftTime == 4294967295 then
        self.reliefmoneyTimerTxt:GetComponent("Text").text = "已领完";
        self.reliefmoneyTimerBg:SetActive(true);
    end
end

function HallReliefmoney.reliefmoneyfun()
    if SCPlayerInfo._20dwAlmsGetLeftTime ~= nil and self.reliefmoneyostimer ~= nil and SCPlayerInfo._20dwAlmsGetLeftTime > 0 then
         
        local variable = tonumber(os.time());
        if (variable - self.reliefmoneyostimer) >= 1 then
            SCPlayerInfo._20dwAlmsGetLeftTime = math.max(0, SCPlayerInfo._20dwAlmsGetLeftTime -(variable - self.reliefmoneyostimer));
            self.reliefmoneyostimer = variable;
            if SCPlayerInfo._20dwAlmsGetLeftTime == 0 then
                self.setRelieFmoneyBtn();
            end
            if self.reliefmoneyTimerTxt ~= nil then
                self.reliefmoneyTimerTxt:GetComponent("Text").text = self.countTimer(SCPlayerInfo._20dwAlmsGetLeftTime);
                self.reliefmoneyTimerBg:SetActive(true);
            end
        end
    end
end
-- 请求救济金的数据
function HallReliefmoney.reqRelieFmoney()
    if self.reliefmoneyTable == nil then
     --   error("请求救济金的数据");
        local buffer = ByteBuffer.New()
        Network.Send(MH.MDM_3D_TASK, MH.SUB_3D_CS_ALMS, buffer, gameSocketNumber.HallSocket);
    else
        self.goldChang();
    end
end
-- 点击救济金按钮
function HallReliefmoney.clickRelieFmoney(args)
  --  error("点击救济金按钮");
    local variable = ByteBuffer.New();
    Network.Send(MH.MDM_3D_TASK, MH.SUB_3D_CS_ALMS_USER_GET, variable, gameSocketNumber.HallSocket);
end
-- 开始收取救济金table
function HallReliefmoney.startRelieFmoneyTable()
    self.reliefmoneyTable = { };
end
-- 正在收取救济金table
function HallReliefmoney.getIngRelieFmoneyTable(agr)
    -- DWORD dwAlms_Id;ID
    -- DWORD dwLessGold;少于金币
    -- DWORD dwGetGold;领取金币
    -- DWORD dwNeedTime;下一时间
    local variable = { };
    variable["variable"] = agr:ReadUInt32();
    variable["dwLessGold"] = agr:ReadUInt32();
    variable["dwGetGold"] = agr:ReadUInt32();
    variable["dwNeedTime"] = agr:ReadUInt32();
    
    table.insert(self.reliefmoneyTable, variable);
end
-- 结束收取救济金table
function HallReliefmoney.EndRelieFmoneyTable()
 --   error("结束收取救济金table____");
    self.goldChang();
end
-- 点击救济金收到服务器的结果
function HallReliefmoney.reqReliefRes()
    SCPlayerInfo._19dwShouldGet_Alms_Id = SCPlayerInfo._19dwShouldGet_Alms_Id + 1;
    -- error("_________"..SCPlayerInfo._19dwShouldGet_Alms_Id);
    if SCPlayerInfo._19dwShouldGet_Alms_Id <= #self.reliefmoneyTable then
        SCPlayerInfo._20dwAlmsGetLeftTime = self.reliefmoneyTable[SCPlayerInfo._19dwShouldGet_Alms_Id]["dwNeedTime"];
        self.reliefmoneyostimer = tonumber(os.time());
      
        GetLeftTimeDate= os.time()+SCPlayerInfo._20dwAlmsGetLeftTime;

        local showstr;
        local showtime = self.reliefmoneyTable[SCPlayerInfo._19dwShouldGet_Alms_Id]["dwNeedTime"];
       --  error("shij__________"..showtime);

        showstr = "已成功领取救济金" .. self.reliefmoneyTable[SCPlayerInfo._19dwShouldGet_Alms_Id - 1]["dwGetGold"] .. "金币（第" ..(SCPlayerInfo._19dwShouldGet_Alms_Id - 1) .. "次）\n今日还可领取" ..(#self.reliefmoneyTable -(SCPlayerInfo._19dwShouldGet_Alms_Id - 1)) .. "次，距离下次领取还剩" .. self.countTimer(showtime);

        MessageBox.CreatGeneralTipsPanel(showstr);
    else
        MessageBox.CreatGeneralTipsPanel("已成功领取救济金" .. self.reliefmoneyTable[#self.reliefmoneyTable]["dwGetGold"] .. "金币,今日已领完");
        SCPlayerInfo._20dwAlmsGetLeftTime=4294967295;
        self.reliefmoneyTimerTxt:GetComponent("Text").text = "已领完";
        self.reliefmoneyTimerBg:SetActive(true);
    end
    self.setRelieFmoneyBtn();
end
function HallReliefmoney.reqRelieResFail()
    self.setRelieFmoneyBtn();
end
-- 设置救济金按钮的显示可点击等
function HallReliefmoney.setRelieFmoneyBtn()
    local btn=self.reliefmoney:GetComponent('Button');
    if self.reliefmoneyTable == nil then
        return;
    end
    if SCPlayerInfo._19dwShouldGet_Alms_Id > #self.reliefmoneyTable then
        btn.interactable = false;
        return;
    end
    if SCPlayerInfo._20dwAlmsGetLeftTime == 0 and(self.reliefmoneyTable[SCPlayerInfo._19dwShouldGet_Alms_Id]["dwLessGold"] >= gameData.GetProp(enum_Prop_Id.E_PROP_GOLD)+(gameData.GetProp(enum_Prop_Id.E_PROP_STRONG))) then
        if btn.interactable == false then
            btn.interactable = true;
            coroutine.start( function()
                coroutine.wait(0.5);
                if self.ishall() == false then
                    return;
                end;
                self.clickRelieFmoney(nil);
            end );
        end
    else
        btn.interactable = false;
    end
end
-- 显示倒计时
function HallReliefmoney.countTimer(args)
    local retxt = "";
    local oldargs = args;
    local variable = math.floor(args / 3600);
    if variable > 9 then
        retxt = variable .. ":";
    else
        retxt = "0" .. variable .. ":";
    end
    args = args - variable * 3600;
    variable = math.floor(args / 60);
    if variable > 9 then
        retxt = retxt .. variable .. ":";
    else
        retxt = retxt .. "0" .. variable .. ":";
    end
    args = args - variable * 60;
    variable = args;
    if variable > 9 then
        retxt = retxt .. variable;
    else
        retxt = retxt .. "0" .. variable;
    end
    if oldargs == 0 then    return " ";  end
    if SCPlayerInfo._20dwAlmsGetLeftTime == 4294967295 then  return " ";   end
    return retxt;
end


function HallReliefmoney.Update()
    if self.ishall() == false then return; end;
   
    if SCPlayerInfo._20dwAlmsGetLeftTime ~= nil and SCPlayerInfo._20dwAlmsGetLeftTime ~= 4294967295 then
        
        self.reliefmoneyfun();
    end
end


function HallReliefmoney.ishall()
    if ScenSeverName ~= gameServerName.HALL then
       return false;
    end
    return true;
end