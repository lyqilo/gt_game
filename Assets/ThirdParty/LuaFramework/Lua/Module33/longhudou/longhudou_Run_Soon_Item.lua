longhudou_Run_Soon_Item = {};
local self = longhudou_Run_Soon_Item;


function longhudou_Run_Soon_Item:new()
    local go = {};
    self.guikey = "cn";
    setmetatable(go,{__index = self});
    go.guikey = longhudou_Event.guid();
    return go;
end

function longhudou_Run_Soon_Item:init(args)
    self.item = nil;
    self.anima = nil;-- 动画
    self.icon = nil;-- 把动画加到icon上
    self.lasticon = nil;
    self.selectAnima = nil;--选中外面还有个动画
    self.selectAnima2 = nil;--选中外面还有个动画
    self.isreadplayanima = false;
    self.isdispath = false;
    self.animaType = 1;
    self.iscreateanima = false;
    self.curindex = 0;
end

function longhudou_Run_Soon_Item:setPer(per,createanima,curindex)
   self:init();
   self.item = newobject(per);
   self.icon = self.item.transform:Find("icon");
   self.iscreateanima = createanima;
   self.curindex = curindex;
   self:loadRes(); 
   if self.iscreateanima==true then
      self:addEvent();
   else
     longhudou_Event.addEvent(longhudou_Event.xiongm_load_res_com,longhudou_Event.hander(self,self.loadRes),self.guikey); 
   end
end

function longhudou_Run_Soon_Item:getPosint()
   return self.item.transform.position;
end

function longhudou_Run_Soon_Item:setParent(mparent)
   self.item.transform:SetParent(mparent.transform);
   self.item.transform.localScale = Vector3.New(1,1,1);
   self.item.transform.localPosition = Vector3.New(0,0,0);
end

function longhudou_Run_Soon_Item:addEvent()
   longhudou_Event.addEvent(longhudou_Event.xiongm_colse_line_anima,longhudou_Event.hander(self,self.closeLineHander),self.guikey);
   longhudou_Event.addEvent(longhudou_Event.xiongm_start,longhudou_Event.hander(self,self.startRunHander),self.guikey);
   longhudou_Event.addEvent(longhudou_Event.game_once_over,longhudou_Event.hander(self,self.onceOver),self.guikey); 
   longhudou_Event.addEvent(longhudou_Event.xiongm_load_res_com,longhudou_Event.hander(self,self.loadRes),self.guikey); 
end
function longhudou_Run_Soon_Item:loadRes(args)
  if not IsNil(self.item) and  longhudou_Data.isResCom==2 then
     self.item.transform:Find("iconanima").gameObject:GetComponent("Image").sprite = longhudou_Data.icon_res.transform:Find("anima_toum"):GetComponent('Image').sprite;
     self.item.transform:Find("selectanima").gameObject:GetComponent("Image").sprite = longhudou_Data.icon_res.transform:Find("anima_toum"):GetComponent('Image').sprite;
  end
   if self.iscreateanima==true and self.anima==nil and not IsNil(self.item) and longhudou_Data.isResCom==2 then
      self.anima = self.item.transform:Find("iconanima").gameObject:AddComponent(typeof(ImageAnima));
      self.anima:SetEndEvent(longhudou_Event.hander(self,self.playCom));
      self.anima.fSep = 0.05;

      self.selectAnima = self.item.transform:Find("selectanima").gameObject:AddComponent(typeof(ImageAnima));
      self.selectAnima:SetEndEvent(longhudou_Event.hander(self,self.playCom));
      self.selectAnima.fSep = 0.05;

      self.selectAnima2 = self.item.transform:Find("selectanima2").gameObject:AddComponent(typeof(ImageAnima));
      self.selectAnima2.fSep = 0.05;

      for i=1,24 do
          if self.curindex==2 then
             self.selectAnima:AddSprite(longhudou_Data.icon_res.transform:Find("zhex_anima_"..i):GetComponent('Image').sprite);
             self.selectAnima2:AddSprite(longhudou_Data.icon_res.transform:Find("zhex_anima_"..i):GetComponent('Image').sprite);
          else
             self.selectAnima:AddSprite(longhudou_Data.icon_res.transform:Find("anima_toum"):GetComponent('Image').sprite);
             self.selectAnima2:AddSprite(longhudou_Data.icon_res.transform:Find("anima_toum"):GetComponent('Image').sprite);
          end
          
      end
   end 
end
-- 设置显示的图片
function longhudou_Run_Soon_Item:setImg(imgname,istwoflush,iconindex,imgindex)
   local item = nil;
   if longhudou_Data.icon_res==nil then
      item = longhudou_Data.numres.transform:Find(imgname);
   else
      item = longhudou_Data.icon_res.transform:Find(imgname);
   end
   if istwoflush==true and self.lasticon ~= iconindex then
      self.selectAnima:Play();
      --self.selectAnima2:Play();
      --self.icon.gameObject:SetActive(false);
   end
   self.lasticon = iconindex;
   local sizedel = item.gameObject:GetComponent("RectTransform").sizeDelta;
   self.icon.gameObject:GetComponent("RectTransform").sizeDelta = Vector2.New(sizedel.x,sizedel.y);
   self.icon.gameObject:GetComponent("Image").sprite = item.gameObject:GetComponent("Image").sprite;
end

--设置动画 animatype 是不是要隐藏icon
function longhudou_Run_Soon_Item:setAnima(cofigdata,isdispath)
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
--    self.selectAnima:ClearAll();
--    self.selectAnima.fDelta = 0;
    self.animaType = cofigdata.animatype;
    if cofigdata.animatype==1 then
        for a=1,cofigdata.loop do
            for i=1,cofigdata.count do
                if i%10<7 then
                   self.anima:AddSprite(longhudou_Data.icon_res.transform:Find(cofigdata.animaimg):GetComponent('Image').sprite);
                else
                   self.anima:AddSprite(longhudou_Data.icon_res.transform:Find("anima_toum"):GetComponent('Image').sprite);
                end
            end
        end 
    elseif cofigdata.animatype==2 then
       for a=1,cofigdata.loop do
            for i=1,cofigdata.count do
                self.anima:AddSprite(longhudou_Data.icon_res.transform:Find(cofigdata.animaimg):GetComponent('Image').sprite);
            end
        end
    elseif cofigdata.animatype==3 then
        for c=1,cofigdata.loop do
            for e=1,cofigdata.count do
                self.anima:AddSprite(longhudou_Data.icon_res.transform:Find(cofigdata.animaimg..e):GetComponent('Image').sprite);
            end
        end 
    end
    self.isreadplayanima = true;
    self.isdispath = isdispath;
end

--设置坐标
function longhudou_Run_Soon_Item:setPoint(pos)
   self.item.transform.localPosition = pos;
end

--停止播放选择的东西
function longhudou_Run_Soon_Item:stopPlaySelctAnima()
   self.anima:StopAndRevert();
   --if self.animaType == 3  then
      self.selectAnima:StopAndRevert();
   --end
end
function longhudou_Run_Soon_Item:playSelctAnima()
   self.anima:Play();
   if self.animaType == 3  then
      --self.selectAnima:Play();
   end  
end

function longhudou_Run_Soon_Item:closeLineHander(args)
   self:stopPlaySelctAnima();
   self.isSelect = false;
end
--播放动画
function longhudou_Run_Soon_Item:playAnima()
   if self.isreadplayanima==true then
      --if self.animaType ==2  then
      --else
         self.icon.gameObject:SetActive(false);
      --end
      self.anima:Play();
      --self.selectAnima:Play();
   end
end

function longhudou_Run_Soon_Item:getIsReadAnima()
   return self.isreadplayanima;
end

function longhudou_Run_Soon_Item:startRunHander(args)
    self:stopPlaySelctAnima();
    self.isreadplayanima = false;
   self.isdispath = false;
end


function longhudou_Run_Soon_Item:onceOver(args)
  self:stopPlaySelctAnima();
end


--播放完成把默认的图片弄上去
function longhudou_Run_Soon_Item:playCom()
   self.icon.gameObject:SetActive(true);   
end


