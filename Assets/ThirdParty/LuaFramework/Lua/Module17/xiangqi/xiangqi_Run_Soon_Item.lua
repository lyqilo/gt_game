xiangqi_Run_Soon_Item = {};
local self = xiangqi_Run_Soon_Item;


function xiangqi_Run_Soon_Item:new()
    local go = {};
    self.guikey = "cn";
    setmetatable(go,{__index = self});
    go.guikey = xiangqi_Event.guid();
    return go;
end

function xiangqi_Run_Soon_Item:init(args)
    self.item = nil;
    self.anima = nil;-- 动画
    self.icon = nil;-- 把动画加到icon上
    self.selectAnima = nil;--选中外面还有个动画
    self.isreadplayanima = false;
    self.isdispath = false;
    self.curcoloranima = nil;
    self.animaType = 1;
    self.iscreateanima = false;
end

function xiangqi_Run_Soon_Item:setPer(per,createanima)
   self:init();
   self.item = newobject(per);
   self.icon = self.item.transform:Find("icon");
   self.iscreateanima = createanima;
   self:loadRes(); 
   if self.iscreateanima==true then
      self:addEvent();
   else
     xiangqi_Event.addEvent(xiangqi_Event.xiongm_load_res_com,xiangqi_Event.hander(self,self.loadRes),self.guikey); 
   end
end

function xiangqi_Run_Soon_Item:getPosint()
   return self.item.transform.position;
end

function xiangqi_Run_Soon_Item:setParent(mparent)
   self.item.transform:SetParent(mparent.transform);
   self.item.transform.localScale = Vector3.New(1,1,1);
   self.item.transform.localPosition = Vector3.New(0,0,0);
end

function xiangqi_Run_Soon_Item:addEvent()
   xiangqi_Event.addEvent(xiangqi_Event.xiongm_colse_line_anima,xiangqi_Event.hander(self,self.closeLineHander),self.guikey);
   xiangqi_Event.addEvent(xiangqi_Event.xiongm_start,xiangqi_Event.hander(self,self.startRunHander),self.guikey);
   xiangqi_Event.addEvent(xiangqi_Event.game_once_over,xiangqi_Event.hander(self,self.onceOver),self.guikey); 
   xiangqi_Event.addEvent(xiangqi_Event.xiongm_load_res_com,xiangqi_Event.hander(self,self.loadRes),self.guikey); 
end
function xiangqi_Run_Soon_Item:loadRes(args)
  if not IsNil(self.item) and  xiangqi_Data.isResCom==2 then
     self.item.transform:Find("iconanima").gameObject:GetComponent("Image").sprite = xiangqi_Data.icon_res.transform:Find("anima_toum"):GetComponent('Image').sprite;
     self.item.transform:Find("selectanima").gameObject:GetComponent("Image").sprite = xiangqi_Data.icon_res.transform:Find("anima_toum"):GetComponent('Image').sprite;
     
  end
   if self.iscreateanima==true and self.anima==nil and not IsNil(self.item) and xiangqi_Data.isResCom==2 then
      self.anima = self.item.transform:Find("iconanima").gameObject:AddComponent(typeof(ImageAnima));
      self.anima:SetEndEvent(xiangqi_Event.hander(self,self.playCom));
      self.anima.fSep = 0.07;

      self.selectAnima = self.item.transform:Find("selectanima").gameObject:AddComponent(typeof(ImageAnima));
      self.selectAnima.fSep = 0.07; 
      
     self.item.transform:Find("canima_1").gameObject:SetActive(false);
     self.item.transform:Find("canima_2").gameObject:SetActive(false);
     self.item.transform:Find("canima_3").gameObject:SetActive(false);
   end 
end
-- 设置显示的图片
function xiangqi_Run_Soon_Item:setImg(imgname)
   local item = nil;
   if xiangqi_Data.icon_res==nil then
      item = xiangqi_Data.numres.transform:Find(imgname);
   else
      item = xiangqi_Data.icon_res.transform:Find(imgname);
   end
   local sizedel = item.gameObject:GetComponent("RectTransform").sizeDelta;
   self.icon.gameObject:GetComponent("RectTransform").sizeDelta = Vector2.New(sizedel.x,sizedel.y);
   self.icon.gameObject:GetComponent("Image").sprite = item.gameObject:GetComponent("Image").sprite;
end

--设置动画 animatype 是不是要隐藏icon
function xiangqi_Run_Soon_Item:setAnima(cofigdata,isdispath)
     if self.isreadplayanima == true then
        return;
     end
     if self.anima == nil or self.selectAnima==nil then
        return;
     end 
    self.anima:StopAndRevert();
    self.selectAnima:StopAndRevert();
    self.isreadplayanima = true;
    self.anima:ClearAll();
    self.anima.fDelta = 0;
    self.selectAnima:ClearAll();
    self.selectAnima.fDelta = 0;
    self.animaType = cofigdata.animatype;
    if cofigdata.animatype==1 then
        for a=1,cofigdata.loop do
            for i=1,cofigdata.count do
                if i%10<7 then
                   self.anima:AddSprite(xiangqi_Data.icon_res.transform:Find(cofigdata.animaimg):GetComponent('Image').sprite);
                else
                   self.anima:AddSprite(xiangqi_Data.icon_res.transform:Find("anima_toum"):GetComponent('Image').sprite);
                end
            end
        end 
    elseif cofigdata.animatype>0 then
       for a=1,cofigdata.loop do
            for i=1,cofigdata.count do
                self.anima:AddSprite(xiangqi_Data.icon_res.transform:Find("anima_toum"):GetComponent('Image').sprite);
            end
        end
        self.curcoloranima = self.item.transform:Find("canima_"..cofigdata.icolor).gameObject;
        if cofigdata.animatype==3 then
            for c=1,cofigdata.loop do
                for e=1,cofigdata.count do
                   self.selectAnima:AddSprite(xiangqi_Data.icon_res.transform:Find(cofigdata.animaimg..e):GetComponent('Image').sprite);
                end
            end 
         end 
    end
    self.isreadplayanima = true;
    self.isdispath = isdispath;
end

--设置坐标
function xiangqi_Run_Soon_Item:setPoint(pos)
   self.item.transform.localPosition = pos;
end

--停止播放选择的东西
function xiangqi_Run_Soon_Item:stopPlaySelctAnima()
   self.anima:StopAndRevert();
   if self.animaType == 3  then
      self.selectAnima:StopAndRevert();
   end
   if self.curcoloranima~=nil then
      self.curcoloranima:SetActive(false);
   end
   if self.curcoloranima~=nil then
      self.curcoloranima:SetActive(false);
   end
end
function xiangqi_Run_Soon_Item:playSelctAnima()
   self.anima:Play();
   if self.animaType == 3  then
      self.selectAnima:Play();
   end 
   if self.curcoloranima~=nil then
      self.curcoloranima:SetActive(true);
   end
end

function xiangqi_Run_Soon_Item:closeLineHander(args)
   self:stopPlaySelctAnima();
   self.isSelect = false;
end
--播放动画
function xiangqi_Run_Soon_Item:playAnima()
   if self.isreadplayanima==true then
      if self.animaType ==2  then
      else
        -- self.icon.gameObject:SetActive(false);
      end
      self.anima:Play();
      self.selectAnima:Play();
      if self.curcoloranima~=nil then
          self.curcoloranima:SetActive(true);
       end
   end
end

function xiangqi_Run_Soon_Item:getIsReadAnima()
   return self.isreadplayanima;
end

function xiangqi_Run_Soon_Item:startRunHander(args)
    self:stopPlaySelctAnima();
    self.isreadplayanima = false;
   self.isdispath = false;
end


function xiangqi_Run_Soon_Item:onceOver(args)
  self:stopPlaySelctAnima();
end


--播放完成把默认的图片弄上去
function xiangqi_Run_Soon_Item:playCom()
   --self.icon.gameObject:SetActive(true);   
end


