--下注里面的按钮 筹码 确定 取消

BirdsAndBeast_PushBtn = {};
local self =BirdsAndBeast_PushBtn;

self.per = nil;
self.luabe = nil;
self.messkey = "0";
self.choumindex = 1;
self.timernumcont = nil;
self.timerslider = nil;
self.timersliderred = nil;
self.timerroll = nil;
self.continuebtn = nil;

function BirdsAndBeast_PushBtn.setPer(per,luabe)
   self.per = per;
   self.luabe = luabe;
   self.timernumcont = self.per.transform:Find("timercont/numcont").gameObject;
   self.timerslider = self.per.transform:Find("timercont/slider").gameObject;
   self.timersliderred = self.per.transform:Find("timercont/sliderred").gameObject;   
   self.continuebtn = self.per.transform:Find("continue_btn");
   self.timerroll = BirdsAndBeast_numRolling:New();
   self.timerroll:setfun(self,self.showrollcom,self.showroll);
   table.insert(BirdsAndBeast_GameData.numrollingcont,#BirdsAndBeast_GameData.numrollingcont+1,self.timerroll);
   self.messkey = BirdsAndBeastEvent.guid(); 
   self.AddEvent();
   self.continuebtn.gameObject:GetComponent("Button").interactable = false;
end

function BirdsAndBeast_PushBtn.AddEvent()
   if self.per~=nil and self.luabe~=nil then
      self.luabe:AddClick(self.per.transform:Find("changchoum/choum_btn").gameObject,self.choumHander);
      self.luabe:AddClick(self.per.transform:Find("cancelbtn").gameObject,self.cancelHander);
      self.luabe:AddClick(self.per.transform:Find("continue_btn").gameObject,self.continueHander);

   end
   BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.choumchang,self.choumChang,self.messkey);
   BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.startchip,self.startchipChang,self.messkey);
   BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.stopchip,self.stopchipChang,self.messkey);
   BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.gametimerchang,self.gametimerchang,self.messkey);
   BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.exitgame,self.exitgame,self.messkey);
   BirdsAndBeastEvent.addEvent(BirdsAndBeastEvent.continuechipiter,self.continuebtninteractable,self.messkey);
end

function BirdsAndBeast_PushBtn.continuebtninteractable(args)
    if self.per~=nil then
        local cont = BirdsAndBeast_Socket.myNumPushMoeny(BirdsAndBeast_GameData.pushmoneylast_data);
        if cont==0 or toInt64(cont)>toInt64(BirdsAndBeast_GameData.myinfoData._7wGold) then
           self.continuebtn.gameObject:GetComponent("Button").interactable = false;
           return;
        end
       self.continuebtn.gameObject:GetComponent("Button").interactable = args.data;
    end
end

function BirdsAndBeast_PushBtn.exitgame(args)
   self.destroying();
end
function BirdsAndBeast_PushBtn.destroying()
    self.per = nil;
    self.luabe = nil;
    self.messkey = "0";
    self.choumindex = 1;
    self.timernumcont = nil;
    self.timerslider = nil;
    self.timersliderred = nil;    
    self.timerroll = nil;
    self.continuebtn = nil;
end

function BirdsAndBeast_PushBtn.RemoveEvent()

end

function BirdsAndBeast_PushBtn.choumChang(args)
   self.shownum();
end

function BirdsAndBeast_PushBtn.gametimerchang(args)
  if BirdsAndBeast_GameData.gameState == BirdsAndBeast_CMD.D_GAME_STATE_CHIP then
      self.startchipChang(args);
   end
end

function BirdsAndBeast_PushBtn.startchipChang(args)
    --error("_______BirdsAndBeast_PushBtn.startchipChang_______________"..BirdsAndBeast_GameData.gameTimer);
   self.timerroll:setdata(BirdsAndBeast_GameData.gameTimer,0,BirdsAndBeast_GameData.gameTimer);
   self.per.transform:Find("cancelbtn"):GetComponent("Button").interactable = true;
   -- error("____11___BirdsAndBeast_PushBtn.startchipChang_______________");
end

function BirdsAndBeast_PushBtn.shownum()
     if IsNil(self.per) then
        return;
     end
     BirdsAndBeast_GameData.selectChoumNum = BirdsAndBeast_GameData.choum_data[self.choumindex];
     self.per.transform:Find("changchoum/showchoum/Text").gameObject:GetComponent("Text").text = BirdsAndBeast_GameData.choum_data[self.choumindex];
    --self.CreatShowNum(self.per.transform:Find("changchoum/showchoum"),BirdsAndBeast_GameData.choum_data[self.choumindex],"num",true);
end

function BirdsAndBeast_PushBtn.showroll(tar,args)
    self.contSlider(args);
    if 0<args and args<4 then
       jinandyinsha_PushFun.CreatShowNum(self.timernumcont,args,"time_red_",false,24,2,55,-130);
       self.timersliderred.gameObject:SetActive(true);
       self.timerslider.gameObject:SetActive(false);
       BirdsAndBeast_Socket.playaudio("tis",false,false,false);
    else
       jinandyinsha_PushFun.CreatShowNum(self.timernumcont,args,"time_",false,24,2,55,-130);
       self.timersliderred.gameObject:SetActive(false);
       self.timerslider.gameObject:SetActive(true);
    end
    
end

function BirdsAndBeast_PushBtn.showrollcom(tar,args)
  jinandyinsha_PushFun.CreatShowNum(self.timernumcont,0,"time_red_",false,24,2,55,-130);
  BirdsAndBeast_Socket.playaudio("tis",false,false,false);
  BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.openmypushpanel,false);
end

function BirdsAndBeast_PushBtn.stopchipChang(args)
    self.timerroll.isrun = false;
    self.contSlider(0);
    jinandyinsha_PushFun.CreatShowNum(self.timernumcont,0,"time_",false,24,2,55,-130);
    BirdsAndBeastEvent.dispathEvent(BirdsAndBeastEvent.openmypushpanel,false);
end

function BirdsAndBeast_PushBtn.contSlider(args)
  self.timerslider.transform.gameObject:GetComponent("Image").fillAmount = args/BirdsAndBeast_GameData.defalutTimer;
  self.timersliderred.transform.gameObject:GetComponent("Image").fillAmount = args/BirdsAndBeast_GameData.defalutTimer;  
end


function BirdsAndBeast_PushBtn.choumHander(args)
   --error("____________choumHander____________");
   self.choumindex = self.choumindex+1;
   if self.choumindex>#BirdsAndBeast_GameData.choum_data then
      self.choumindex = 1;
   end
   self.shownum();
end

--取消小注
function BirdsAndBeast_PushBtn.cancelHander(args)
  error("____________cancelHander____________");
  self.per.transform:Find("cancelbtn"):GetComponent("Button").interactable = false;
  BirdsAndBeast_Socket.clearChipNormal();
end
--续压
function BirdsAndBeast_PushBtn.continueHander(args)
  -- error("____________continueHander____________");
   BirdsAndBeast_Socket.continueChipNormal();
end

function BirdsAndBeast_PushBtn.update()

end

-- 创建数字Img显示对象
function BirdsAndBeast_PushBtn.CreatShowNum(father, numstr,numpathstr,isagin)    
   -- numstr = unitPublic.showNumberText2(tonumber(numstr)); 
    --error("___CreatShowNum___"..numstr); 
     if IsNil(father) then
        return;
     end
    local splen =  father.transform.childCount;
    local numlen = string.len(numstr);
    local alen =  math.max(0,splen-numlen);
    if splen > numlen then
        for j =alen , 1,-1 do
            --destroy(father.transform:GetChild(j).gameObject);
            father.transform:GetChild(j-1).gameObject:SetActive(false);
        end
    end
    local klx = 0;
    local kw = 0;
    for i = 1, string.len(numstr) do
        local prefebnum = string.sub(numstr, i, i);
        prefebnum = self.repaceNum(prefebnum);
        if kw ~= 0 then
            klx = kw;
        end
        if prefebnum == 10 then
            --klx = klx - 8;
            kw = kw + 14;
        else
            kw = kw + 24;
        end
        if splen < i then
            local go2 = newobject(BirdsAndBeast_GameData.iconres.transform:Find(numpathstr.."_"..prefebnum).gameObject);
            go2.transform:SetParent(father.transform);
            go2.transform.localScale = Vector3.One();
            go2.transform.localPosition = Vector3.New(klx, 0, 0);
            go2.name = prefebnum;
        else
            -- if tonumber(prefebnum) ~= tonumber(father.transform:GetChild(i - 1).gameObject.name) then
            local itemobj = father.transform:GetChild(alen + i-1).gameObject;
            itemobj:SetActive(true);
            itemobj.name = prefebnum;
            --itemobj.transform.localPosition = Vector3.New(klx, 0, 0);
            itemobj:GetComponent('Image').sprite = BirdsAndBeast_GameData.iconres.transform:Find(numpathstr.."_"..prefebnum).gameObject:GetComponent('Image').sprite;
            itemobj:GetComponent('Image'):SetNativeSize();
            -- end
        end
    end
    if isagin==true then
       father.transform.localPosition = Vector3.New(-140 + (55-kw)/2,father.transform.localPosition.y,0);
    end
     
end

function BirdsAndBeast_PushBtn.repaceNum(args)
    if args == "." then
        return 10;
    elseif args == "w" then
        return 11;
    elseif args == "y" then
        return 12;
    end
    return args;
end