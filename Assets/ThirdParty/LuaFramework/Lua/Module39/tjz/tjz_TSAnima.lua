tjz_TSAnima = {};
local self = tjz_TSAnima;

function tjz_TSAnima.init()
   self.isShowLineAnima = false;
   self.showLineTimer = 2;
   self.showLineCurTimer = 0;
   self.curShowLineIndex = 0;
   self.linePer = nil;

   self.winIcon = nil;
   self.winBg = nil;
   self.wincont = nil;

   self.gudicont = nil;
   self.guidiItem = nil;

   self.animaFromTar = nil;

   self.guikey = "cn";

   self.GoldInfo = {};
   self.GoldInfoPos = {};
   self.GoldInfoWH = {};
   self.StartGold = false;
   self.dTime = 0;
   self.wingoldcont = nil;

   self.allfreegoldcont = nil;
   self.freeAllGoldroll = nil;

   self.goldanima = nil;

   self.wintype = nil;
   self.curWinTypeNumCont = nil;
   self.wintypeRoll = nil;
   self.caijin = nil;
   self.caijinNumCont = nil;
   self.caijinRoll = nil;
   self.iconLeveUp = nil;
   self.freedeng = nil;

end

function tjz_TSAnima.setPer(args)
   self.init();
   self.guikey = tjz_Event.guid();
   self.linePer = args.transform:Find("linecont");
   self.gudicont = args.transform:Find("runcontmask/runcont/gudicont");
   self.guidiItem = args.transform:Find("item");
   self.winIcon = args.transform:Find("winanimacont/icon");
   self.wincont = args.transform:Find("winanimacont");
   self.wingoldcont = args.transform:Find("bottomcont/wingoldcont");
   self.freedeng = args.transform:Find("bgcont/freebg/deng");

   --self.goldanima = args.transform:Find("bottomcont/zhipai_jinbi"):GetComponent("ParticleSystem");
   local golditem = args.transform:Find("gloditem");
   golditem.gameObject:SetActive(false);

   self.allfreegoldcont = args.transform:Find("bottomcont/allfreegoldcont");
   self.allfreegoldcont.gameObject:SetActive(false);

   self.wintype = args.transform:Find("bottomcont/wintype");
   self.caijin = args.transform:Find("bottomcont/caijwin");
   self.caijinNumCont = args.transform:Find("bottomcont/caijwin/bg/numcont");
   self.iconLeveUp = args.transform:Find("bottomcont/shengji");

   self.wintype.gameObject:SetActive(false);
   self.caijin.gameObject:SetActive(false);
   self.iconLeveUp.gameObject:SetActive(false);

   self.iconLeveUp:Find("zhezhao"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
   self.allfreegoldcont:Find("zhezhao"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
   self.caijin:Find("zhezhao"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);

   self.wintype:Find("item_1/zhezhao"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
   self.wintype:Find("item_2/zhezhao"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);
   self.wintype:Find("item_3/zhezhao"):GetComponent("RectTransform").sizeDelta = Vector2.New((Screen.width / Screen.height) * 750 + 20, 750 + 20);



   self.allfreegoldcont.transform:Find("jinbi/jinbi_dajiang"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Alpha Blended")
   self.allfreegoldcont.transform:Find("jinbi/jinbi_xiaojiang"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Alpha Blended")
   self.wintype.transform:Find("item_1/jinbi/jinbi_dajiang"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Alpha Blended")
   self.wintype.transform:Find("item_1/jinbi/jinbi_xiaojiang"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Alpha Blended")
   self.wintype.transform:Find("item_2/jinbi/jinbi_dajiang"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Alpha Blended")
   self.wintype.transform:Find("item_2/jinbi/jinbi_xiaojiang"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Alpha Blended")  
   self.wintype.transform:Find("item_3/jinbi/jinbi_dajiang"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Alpha Blended")
   self.wintype.transform:Find("item_3/jinbi/jinbi_xiaojiang"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Alpha Blended")
   self.caijin.transform:Find("jinbi/jinbi_dajiang"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Alpha Blended")
   self.caijin.transform:Find("jinbi/jinbi_xiaojiang"):GetComponent("Renderer").material.shader=UnityEngine.Shader.Find("Mobile/Particles/Alpha Blended")



   self.freeAllGoldroll = tjz_NumRolling:New();
   self.freeAllGoldroll:setfun(self,self.freeAllGoldRollCom,self.freeAllGoldRollIng);
   table.insert(tjz_Data.numrollingcont,#tjz_Data.numrollingcont+1,self.freeAllGoldroll);

   self.wintypeRoll = tjz_NumRolling:New();
   self.wintypeRoll:setfun(self,self.wintypeRollCom,self.wintypeRollIng);
   table.insert(tjz_Data.numrollingcont,#tjz_Data.numrollingcont+1,self.wintypeRoll);

   self.caijinRoll = tjz_NumRolling:New();
   self.caijinRoll:setfun(self,self.caijinRollCom,self.caijinRollIng);
   table.insert(tjz_Data.numrollingcont,#tjz_Data.numrollingcont+1,self.caijinRoll);

   self.addEvent();
end

function tjz_TSAnima.wintypeRollCom(obj,args)
    tjz_PushFun.CreatShowNum(self.curWinTypeNumCont,args,"freeall_gold_",false,65,2,540,-260);
    coroutine.start(function()
        coroutine.wait(2);
        if tjz_Socket.isongame==false then
            return;
        end
        self.destroySaveSound();
        tjz_Event.dispathEvent(tjz_Event.xiongm_close_stop_btn);
        tjz_Event.dispathEvent(tjz_Event.xiongm_com_win_type);
        self.wintype.gameObject:SetActive(false);
    end)
end

function tjz_TSAnima.wintypeRollIng(obj,args)
    tjz_PushFun.CreatShowNum(self.curWinTypeNumCont,args,"freeall_gold_",false,65,2,540,-260);
end

function tjz_TSAnima.caijinRollCom(obj,args)
    tjz_PushFun.CreatShowNum(self.caijinNumCont,args,"freeall_gold_",false,65,2,637,-330);
    coroutine.start(function()
        coroutine.wait(2);
        if tjz_Socket.isongame==false then
            return;
        end
        self.destroySaveSound();
        tjz_Event.dispathEvent(tjz_Event.xiongm_close_stop_btn);
        tjz_Event.dispathEvent(tjz_Event.xiongm_com_win_caijin);
        self.caijin.gameObject:SetActive(false);
    end)
end

function tjz_TSAnima.caijinRollIng(obj,args)
    tjz_PushFun.CreatShowNum(self.caijinNumCont,args,"freeall_gold_",false,65,2,637,-330);
end

function tjz_TSAnima.showWinCaijin(args)
    if tjz_Data.i64AccuGold>0 then
       local t1 = math.abs(tjz_Data.i64AccuGold/(tjz_Data.curSelectChoum*tjz_Data.baseRunMoneyTimer) - 0.5);
       local t2 = math.min(20,t1);
       tjz_Event.dispathEvent(tjz_Event.xiongm_show_stop_btn);
       self.caijinRoll:setdata(0,tjz_Data.i64AccuGold,t2);
       tjz_Socket.playaudio("maxwin",false,false,true);
       self.caijin.gameObject:SetActive(true);
    else
       tjz_Event.dispathEvent(tjz_Event.xiongm_com_win_caijin);
    end
end

function tjz_TSAnima.showWinType(args)
    if tjz_Data.maxWinType>0 then
       local t1 = math.abs(tjz_Data.winTypeScore/(tjz_Data.curSelectChoum*tjz_Data.baseRunMoneyTimer) - 0.5);
       local t2 = math.max(0.1,t1);
       local t3 = math.min(20,t2);
       self.wintype.transform:Find("item_1").gameObject:SetActive(false);
       self.wintype.transform:Find("item_2").gameObject:SetActive(false);
       self.wintype.transform:Find("item_3").gameObject:SetActive(false);
       self.wintype.transform:Find("item_"..tjz_Data.maxWinType).gameObject:SetActive(true);
       self.curWinTypeNumCont =  self.wintype.transform:Find("item_"..tjz_Data.maxWinType.."/numcont").gameObject;
       tjz_Event.dispathEvent(tjz_Event.xiongm_show_stop_btn);
       self.wintypeRoll:setdata(0,tjz_Data.winTypeScore,t3);
       tjz_Socket.playaudio("maxwin",false,false,true);
       self.wintype.gameObject:SetActive(true);
    else
       tjz_Event.dispathEvent(tjz_Event.xiongm_com_win_type);
    end
    tjz_Data.winTypeScore = 0;
end

local isShowUpLevelPanel=0;
function tjz_TSAnima.showIconUp(args)
    --error("_______0_____tjz_TSAnima.showIconUp____");
    for i=1,10 do
        if i>tjz_Data.byUpProcess then
            self.freedeng.transform:Find("img"..i).gameObject:SetActive(false);
        else
            self.freedeng.transform:Find("img"..i).gameObject:SetActive(true);
        end
    end
    if tjz_Data.byUpProcess>=3 then
       self.freedeng.transform:Find("img11").gameObject:SetActive(true);
    end
    if tjz_Data.byUpProcess>=6 then
       self.freedeng.transform:Find("img12").gameObject:SetActive(true);
    end
    if tjz_Data.byUpProcess>=10 then
       self.freedeng.transform:Find("img13").gameObject:SetActive(true);
    end
    --error("_______1_____tjz_TSAnima.showIconUp____");
    if tjz_Data.byCurUpProcess ~= tjz_Data.byUpProcess then
    --if isShowUpLevelPanel ~= tjz_Data.byUpProcess then
      isShowUpLevelPanel=tjz_Data.byUpProcess
      local img1 = nil;
      local img2 = nil;
      if tjz_Data.byUpProcess==3 then
         img1 = tjz_Config.resimg_config[tjz_Config.kmine].normalimg;
         img2 = tjz_Config.resimg_config[tjz_Config.kminewild].normalimg;
      elseif tjz_Data.byUpProcess==6 then
         img1 = tjz_Config.resimg_config[tjz_Config.aqm].normalimg;
         img2 = tjz_Config.resimg_config[tjz_Config.aqmwild].normalimg;
      elseif tjz_Data.byUpProcess==10 then
         img1 = tjz_Config.resimg_config[tjz_Config.kcar].normalimg;
         img2 = tjz_Config.resimg_config[tjz_Config.kcarwild].normalimg;
      end

      if img1~=nil and img2~=nil then
         self.iconLeveUp.transform:Find("iconcont1").gameObject:GetComponent("Image").sprite = tjz_Data.icon_res.transform:Find(img1).gameObject:GetComponent("Image").sprite;
         self.iconLeveUp.transform:Find("iconcont2").gameObject:GetComponent("Image").sprite = tjz_Data.icon_res.transform:Find(img2).gameObject:GetComponent("Image").sprite;
         self.iconLeveUp.gameObject:SetActive(true);
         tjz_Socket.playaudio("shengj",false,false,false);
         coroutine.start(function()
            coroutine.wait(3);
            if tjz_Socket.isongame==false then
               return;
            end
            tjz_Event.dispathEvent(tjz_Event.xiongm_com_icon_up);
            self.iconLeveUp.gameObject:SetActive(false);
         end)
      else
         self.iconLeveUp.gameObject:SetActive(false);
         tjz_Event.dispathEvent(tjz_Event.xiongm_com_icon_up);
      end
    else
      tjz_Event.dispathEvent(tjz_Event.xiongm_com_icon_up);
   end
end


function tjz_TSAnima.freeAllGoldRollIng(obj,args)
    tjz_PushFun.CreatShowNum(self.allfreegoldcont.transform:Find("numcont"),args,"freeall_gold_",false,65,2,400,-210);
end

function tjz_TSAnima.freeAllGoldRollCom(obj,args)
    tjz_PushFun.CreatShowNum(self.allfreegoldcont.transform:Find("numcont"),args,"freeall_gold_",false,65,2,400,-210);
    tjz_Data.freeAllGold = 0;
--    tjz_Data.isshowmygold = true;
--    tjz_Event.dispathEvent(tjz_Event.xiongm_gold_chang,true);
    tjz_Event.dispathEvent(tjz_Event.xiongm_close_stop_btn); 
    coroutine.start(function()
       coroutine.wait(2);
       if tjz_Socket.isongame==false then
            return;
        end
       self.destroySaveSound();
       self.allfreegoldcont.gameObject:SetActive(false);
       tjz_Event.dispathEvent(tjz_Event.xiongm_gold_roll_com,tjz_Config.forfree); 
    end);
end

function tjz_TSAnima.showFreeAllGold(args) 
   coroutine.start(function()
       coroutine.wait(1);
       if tjz_Socket.isongame==false then
            return;
        end
       self.allfreegoldcont.gameObject:SetActive(true);
       local t1 = math.abs(tjz_Data.freeAllGold/(tjz_Data.curSelectChoum*tjz_Data.baseRunMoneyTimer));
       local t2 = math.min(20,t1);
       tjz_Socket.playaudio("maxwin",false,false,true);
       self.freeAllGoldroll:setdata(0,tjz_Data.freeAllGold,t2);
       tjz_Event.dispathEvent(tjz_Event.xiongm_show_stop_btn); 
    end);   
end
function tjz_TSAnima.destroySaveSound()
    if not IsNil(tjz_Data.saveSound) then
       destroy(tjz_Data.saveSound);
       tjz_Data.saveSound = nil;
    end
end

function tjz_TSAnima.addEvent()
   tjz_Event.addEvent(tjz_Event.xiongm_show_line_anima,self.showLineAnima,self.guikey);
   tjz_Event.addEvent(tjz_Event.xiongm_colse_line_anima,self.closeLineAnima,self.guikey);
   tjz_Event.addEvent(tjz_Event.xiongm_show_gudi,self.showGudi,self.guikey);
   tjz_Event.addEvent(tjz_Event.xiongm_move_gudi,self.moveGudi,self.guikey);
   tjz_Event.addEvent(tjz_Event.xiongm_show_free_all_gold,self.showFreeAllGold,self.guikey);
   tjz_Event.addEvent(tjz_Event.xiongm_close_gudi,self.closeGudiHander,self.guikey);

   tjz_Event.addEvent(tjz_Event.xiongm_show_stop_btn_click,self.stopBtnCLick,self.guikey);
   tjz_Event.addEvent(tjz_Event.xiongm_choum_chang,self.choumChangHander,self.guikey);
   tjz_Event.addEvent(tjz_Event.xiongm_show_win_caijin,self.showWinCaijin,self.guikey);
   tjz_Event.addEvent(tjz_Event.xiongm_show_win_type,self.showWinType,self.guikey);
   tjz_Event.addEvent(tjz_Event.xiongm_show_icon_up,self.showIconUp,self.guikey);

end

function tjz_TSAnima.stopBtnCLick(args)
   if self.freeAllGoldroll.isrun ==true then
      self.freeAllGoldroll.onceStop = true;
   end
   if self.caijinRoll.isrun ==true then
      self.caijinRoll.onceStop = true;
   end
   if self.wintypeRoll.isrun ==true then
      self.wintypeRoll.onceStop = true;
   end
   
end

function tjz_TSAnima.showWinGoldHander(args)
   local len = #self.GoldInfo;
   for i=1,len do
      self.GoldInfo[i].transform.localPosition = Vector3.New(math.random(0,500), math.random(-150,50), 0);
      self.GoldInfoPos[i] = self.GoldInfo[i].transform.localPosition;
   end
   self.dTime = 0;
   self.StartGold = true;
end

function tjz_TSAnima.closeGudiHander(args)
    self.gudicont.gameObject:SetActive(false);
end


function tjz_TSAnima.PaowuLine()
    self.dTime = self.dTime + 0.05;
    for i = 1, #self.GoldInfo, 1 do
        local movew = 0.5 * self.GoldInfoWH[i].x *((self.dTime - i * 0.03) * 2)+self.GoldInfoPos[i].x;
        local moveh = 0.5 * self.GoldInfoWH[i].y *(4 -(math.pow(((self.dTime - i * 0.03) * 4 - 2), 2)))+self.GoldInfoPos[i].y;
        --  local movew = 0.5 * GoldInfo[i + 2] *((dTime) * 4);
        --   local moveh = 0.5 * GoldInfo[i + 1] *(4 -(math.pow(((dTime) * 4 - 2), 2)));
--        if i % 2 == 0 then
            self.GoldInfo[i].transform.localPosition = Vector3.New(movew, moveh, 0);
--        else
           -- self.GoldInfo[i].transform.localPosition = Vector3.New(- movew, moveh, 0);
        --end
        if self.dTime >3 then 
           self.GoldInfo[i].gameObject:SetActive(false);
        else
           self.GoldInfo[i].gameObject:SetActive(true)
        end
    end
    if self.dTime > 3 then self.StartGold = false; return end
end

function tjz_TSAnima.moveGudi(args)
   self.gudicont.gameObject:SetActive(true);
   local len = self.gudicont.transform.childCount;
   local item = nil;
   local pos = nil;
   for i=1,len do
       item = self.gudicont.transform:GetChild(i-1).gameObject;
       if item.gameObject.activeSelf==true then
          pos = item.transform.localPosition;
          item.transform:DOLocalMove(Vector3.New(pos.x-202,pos.y,pos.z),1);
       end
   end
end

function tjz_TSAnima.showGudi(args)
   self.gudicont.gameObject:SetActive(false);
   local len = self.gudicont.transform.childCount;
   local item = nil;
   
   for i=1,len do
       item = self.gudicont.transform:GetChild(i-1).gameObject;
       item.gameObject:SetActive(false);
   end

   local gindex = 0;
   local resimgconfig = nil;
   local pos = nil;
   len = #tjz_Data.selectImg;
   for a=1,len do
       if tjz_Config.haveWild(tjz_Data.selectImg[a]) then
           item = self.getGudiItem(gindex);
           resimgconfig = tjz_Config.resimg_config[tjz_Data.selectImg[a]];
           local sourceitem = tjz_Data.icon_res.transform:Find(resimgconfig.normalimg);
           local sizedel = sourceitem.gameObject:GetComponent("RectTransform").sizeDelta;
           item.transform:Find("icon").gameObject.gameObject:GetComponent("RectTransform").sizeDelta = Vector2.New(sizedel.x,sizedel.y);
           item.transform:Find("icon").gameObject:GetComponent('Image').sprite = sourceitem:GetComponent('Image').sprite;
          pos = tjz_Data.allshowitem[a]:getPosint();
          item.transform.position = Vector3.New(pos.x,pos.y,pos.z);
          gindex = gindex+1;
       end
   end

end

function tjz_TSAnima.getGudiItem(index)
   local item = nil;
   if index<self.gudicont.transform.childCount then
      item = self.gudicont.transform:GetChild(index);
    else
       item = newobject(self.guidiItem).transform;
       item:SetParent(self.gudicont.transform);
       item.localScale = Vector3.one;
   end
   item.gameObject:SetActive(true);
   return item;
end

function tjz_TSAnima.noShowLine()
  local len = self.linePer.transform.childCount;
  local item = nil;
  for i=1,len do
      item = self.linePer.transform:GetChild(i-1);
      item.gameObject:SetActive(false);
  end
  len = #tjz_Data.allshowitem;
  for a=1,len do
      item = tjz_Data.allshowitem[a];
      item:stopPlaySelctAnima();
  end  
end

function tjz_TSAnima.showLineAnima(args)
   if #tjz_Data.openline<=0 then
      return;
   end
   self.isShowLineAnima = true;
   self.showLineCurTimer = self.showLineTimer;
   self.curShowLineIndex = 0;
end

function tjz_TSAnima.closeLineAnima(args)
   self.isShowLineAnima = false;
   self.showLineCurTimer = 0;
   self.curShowLineIndex = 0;
end

function tjz_TSAnima.playShowLineAnima(args)
   self.noShowLine();
   self.curShowLineIndex = self.curShowLineIndex+1;
   if self.curShowLineIndex>#tjz_Data.openline then
      self.curShowLineIndex = 1;
   end  
   local item = nil;   
   for a=2,5 do
       item = self.linePer.transform:Find("line_"..tjz_Data.openline[self.curShowLineIndex].line.."_"..a);
       if not IsNil(item) then
          item.gameObject:SetActive(true);
       end
   end
  local selectdata = tjz_Data.openline[self.curShowLineIndex].data;
  local configdata = tjz_Config.line_config[tjz_Data.openline[self.curShowLineIndex].line];
  local len = #selectdata;
  for c=1,len do
      item = tjz_Data.allshowitem[configdata[c]+1];
      if selectdata[c] == 1 then
         item:playAnima();
      end
  end
  
end
function tjz_TSAnima.choumChangHander(arg)
   self.closeLineAnima();
    self.noShowLine();
end


function tjz_TSAnima.Update()
   if self.isShowLineAnima==true then
      self.showLineCurTimer = self.showLineCurTimer+Time.deltaTime;
      if self.showLineCurTimer>=self.showLineTimer then
         self.showLineCurTimer = 0;
         self.playShowLineAnima();
      end
   end
   if self.StartGold==true then
      self.PaowuLine();
   end
end