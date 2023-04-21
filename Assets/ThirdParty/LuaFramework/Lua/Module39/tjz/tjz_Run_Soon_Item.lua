tjz_Run_Soon_Item = {};
local self = tjz_Run_Soon_Item;


function tjz_Run_Soon_Item:new()
    local go = {};
    self.guikey = "cn";
    setmetatable(go,{__index = self});
    go.guikey = tjz_Event.guid();
    return go;
end

function tjz_Run_Soon_Item:init(args)
    self.item = nil;
    self.anima = nil;-- 动画
    self.icon = nil;-- 把动画加到icon上
    self.selectAnima = nil;--选中外面还有个动画
    self.isreadplayanima = false;
    self.isdispath = false;
    self.animaType = 1;
    self.replaceIcon = nil;
end

function tjz_Run_Soon_Item:setPer(per,iscreateanima)
   self:init();
   self.item = newobject(per);
   self.icon = self.item.transform:Find("icon");   
   if iscreateanima==true then
      self.anima = self.item.transform:Find("iconanima").gameObject:AddComponent(typeof(ImageAnima));      
      self.anima.fSep = 0.05;
      self.anima:SetEndEvent(tjz_Event.hander(self,self.playCom));

      self.selectAnima = self.item.transform:Find("selectanima").gameObject:AddComponent(typeof(ImageAnima));
      --self.selectAnima:SetEndEvent(tjz_Event.hander(self,self.playCom));
      self.selectAnima.fSep = 0.05;
      self:addEvent();
   end  
end

function tjz_Run_Soon_Item:getPosint()
   return self.item.transform.position;
end

function tjz_Run_Soon_Item:setParent(mparent)
   self.item.transform:SetParent(mparent.transform);
   self.item.transform.localScale = Vector3.New(1,1,1);
   self.item.transform.localPosition = Vector3.New(0,0,0);
end

function tjz_Run_Soon_Item:addEvent()
   tjz_Event.addEvent(tjz_Event.xiongm_colse_line_anima,tjz_Event.hander(self,self.closeLineHander),self.guikey);
   tjz_Event.addEvent(tjz_Event.xiongm_start,tjz_Event.hander(self,self.startRunHander),self.guikey);
   tjz_Event.addEvent(tjz_Event.game_once_over,tjz_Event.hander(self,self.onceOver),self.guikey); 
end
-- 设置显示的图片
function tjz_Run_Soon_Item:setImg(imgname)
   local item = tjz_Data.icon_res.transform:Find(imgname);
   local sizedel = item.gameObject:GetComponent("RectTransform").sizeDelta;
   self.icon.gameObject:GetComponent("RectTransform").sizeDelta = Vector2.New(sizedel.x,sizedel.y);
   self.icon.gameObject:GetComponent("Image").sprite = item.gameObject:GetComponent("Image").sprite;
end

--设置动画 animatype 是不是要隐藏icon
function tjz_Run_Soon_Item:setAnima(cofigdata,isdispath)
     if self.isreadplayanima == true then
        return;
     end
     if self.anima == nil or self.selectAnima==nil then
        return;
     end 
    self.replaceIcon = nil;
    self.anima:StopAndRevert();
    self.selectAnima:StopAndRevert();
    self.isreadplayanima = true;
    self.anima:ClearAll();
    self.anima.fDelta = 0;
    self.selectAnima:ClearAll();
    self.selectAnima.fDelta = 0;
    self.item.transform:Find("iconanima").gameObject:GetComponent('Image').color = Color.New(1,1,1,1);
    self.animaType = cofigdata.animatype;
    if cofigdata.icon == tjz_Config.kwomen or cofigdata.icon == tjz_Config.kman or cofigdata.icon == tjz_Config.scatter then
       self.replaceIcon = cofigdata.animaimg..cofigdata.count;
    end
    if cofigdata.animatype==2 then
       for a=1,cofigdata.loop do
            for i=1,cofigdata.count do
                self.anima:AddSprite(tjz_Data.icon_res.transform:Find(cofigdata.animaimg..i):GetComponent('Image').sprite);
            end
        end       
    elseif cofigdata.animatype==4 then
       for c=1,cofigdata.loop do
           for e=1,cofigdata.count do
               self.selectAnima:AddSprite(tjz_Data.icon_res.transform:Find(cofigdata.animaimg..e):GetComponent('Image').sprite);
           end
       end  
    elseif cofigdata.animatype>0 then
       for a=1,3 do -- 强制加边框
            for i=1,7 do
                self.selectAnima:AddSprite(tjz_Data.icon_res.transform:Find("icon_select_"..i):GetComponent('Image').sprite);
            end
        end
        if cofigdata.animatype==3 then
            for c=1,cofigdata.loop do
                for e=1,cofigdata.count do
                   self.anima:AddSprite(tjz_Data.icon_res.transform:Find(cofigdata.animaimg..e):GetComponent('Image').sprite);
                end
            end 
         end 
    end
    self.isreadplayanima = true;
    self.isdispath = isdispath;
end

--设置坐标
function tjz_Run_Soon_Item:setPoint(pos)
   self.item.transform.localPosition = pos;
end

--停止播放选择的东西
function tjz_Run_Soon_Item:stopPlaySelctAnima()
   self.anima:StopAndRevert();
   self.selectAnima:StopAndRevert();
end
function tjz_Run_Soon_Item:playSelctAnima()
   self.icon.gameObject:SetActive(false);
   self.anima:Play();
   self.selectAnima:Play();
end

function tjz_Run_Soon_Item:loopPlaySelctAnima(args)
    self.anima:PlayAlways();
   self.selectAnima:PlayAlways();
end

function tjz_Run_Soon_Item:closeLineHander(args)
   self:stopPlaySelctAnima();
   self.isSelect = false;
end
--播放动画
function tjz_Run_Soon_Item:playAnima()
   if self.isreadplayanima==true then
      self.icon.gameObject:SetActive(false);
      self.anima:Play();
      self.selectAnima:Play();
      if  self.replaceIcon~=nil then
         self:setImg(self.replaceIcon);
      end
   end
end

function tjz_Run_Soon_Item:getIsReadAnima()
   return self.isreadplayanima;
end

function tjz_Run_Soon_Item:startRunHander(args)
    self:stopPlaySelctAnima();
    self.isreadplayanima = false;
   self.isdispath = false;
end


function tjz_Run_Soon_Item:onceOver(args)
  self:stopPlaySelctAnima();
end


--播放完成把默认的图片弄上去
function tjz_Run_Soon_Item:playCom()
   self.icon.gameObject:SetActive(true);   
end


