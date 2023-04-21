FruitsSlot_Run_Soon_Item = {};
local self = FruitsSlot_Run_Soon_Item;


function FruitsSlot_Run_Soon_Item:new()
    local go = {};
    self.guikey = "cn";
    setmetatable(go,{__index = self});
     go.guikey = FruitsSlotEvent.guid();
    return go;
end

function FruitsSlot_Run_Soon_Item:init(args)
    self.item = nil;
    self.defalutImg = nil;--默认图片
    self.anima = nil;-- 动画
    self.icon = nil;-- 把动画加到icon上
    self.itemname = "mg";
    self.isreadplayanima = false;
    self.isdispath = false;
    self.select_play_type = FruitsSlot_Config.select_img_play_com_type_line;--是什么类型的播放完成，也便其它监听的时候 处理
    self.showsize = nil;
    self.animasize = nil;
    self:addEvent();
end

function FruitsSlot_Run_Soon_Item:addEvent()
    FruitsSlotEvent.addEvent(FruitsSlotEvent.game_start,FruitsSlotEvent.hander(self,self.gameStartHander),self.guikey);
end

function FruitsSlot_Run_Soon_Item:gameStartHander(args)
   if not IsNil(self.anima) then
         self.anima:Stop();
      end
   self:stopAnima();
   self.select_play_type = FruitsSlot_Config.select_img_play_com_type_line;
   self.isdispath = false;
end

function FruitsSlot_Run_Soon_Item:setPer(per)
   self:init();
   self.item = newobject(per);
   self.icon = self.item.transform:Find("icon");
   --self.icon.transform.localScale = Vector3.New(0.95,0.95,0.95);
   if iscreateanima==true then
--       self.icon.gameObject:AddComponent(ImageAnima.GetClassType());
--       self.anima = self.icon.transform:GetComponent("ImageAnima");
--       self.anima:SetEndEvent(FruitsSlotEvent.hander(self,self.playCom));
--       self.anima.fSep = 0.2;
--       self.anima:Stop();
   end
  -- self.item.gameObject:SetActive(true);
   
end

function FruitsSlot_Run_Soon_Item:getPosint()
   return self.item.transform.position;
end

function FruitsSlot_Run_Soon_Item:setParent(mparent)
   self.item.transform:SetParent(mparent.transform);
   self.item.transform.localScale = Vector3.New(1,1,1);
   self.item.transform.localPosition = Vector3.New(0,0,0);
end
-- 设置显示的图片
function FruitsSlot_Run_Soon_Item:setImg(imgname)
  -- error("00__setImg___"..imgname);
   local item = FruitsSlot_Data.icon_res.transform:Find(imgname);
   self.defalutImg = item.gameObject:GetComponent("Image").sprite;
   local sizedel = item.gameObject:GetComponent("RectTransform").sizeDelta;
   self.showsize = Vector2.New(sizedel.x,sizedel.y);
   self.icon.gameObject:GetComponent("RectTransform").sizeDelta = Vector2.New(sizedel.x,sizedel.y);
   self.icon.gameObject:GetComponent("Image").sprite = self.defalutImg;
end

function FruitsSlot_Run_Soon_Item:CreatAnima()
    --self.anima = self.icon.transform:GetComponent("ImageAnima");
    --error("____111____CreatAnima_______");
    if not IsNil(self.icon.transform:GetComponent("ImageAnima")) then
      -- error("____222____CreatAnima_______");
       destroy(self.icon.transform:GetComponent("ImageAnima"));

    end
    --error("____333____CreatAnima_______");
    self.icon.gameObject:GetComponent("RectTransform").sizeDelta = Vector2.New(self.showsize.x,self.showsize.y);
    self.icon.gameObject:GetComponent("Image").sprite = self.defalutImg;
    self.anima = Util.AddComponent("ImageAnima", self.icon.transform.gameObject); --self.icon.gameObject:AddComponent(typeof(ImageAnima));
	 
    self.anima:SetEndEvent(FruitsSlotEvent.hander(self,self.playCom));
    self.anima.fSep = 0.1;
    self.anima:Stop();
   
end
--设置动画
function FruitsSlot_Run_Soon_Item:setAnima(animgname,cont,isdispath,loop)
     if self.isreadplayanima == true then
        return;
     end
     --error("00__setAnima___"..animgname);
      if not IsNil(self.anima) then
         self.anima:StopAndRevert();
      end
      --self.anima:StopAndRevert();
     -- error("5555__setAnima___");
      --self.anima.fDelta = 0;
     
      self.isreadplayanima = true;
      self:CreatAnima();
       --error("5555__setAnima___"..self.anima.curFrame);
      --self.anima.lSprites:Clear();
      --error("_11__setAnima___"..animgname);
    local sizedel =  FruitsSlot_Data.icon_res.transform:Find(animgname.."_"..1).gameObject:GetComponent("RectTransform").sizeDelta;
    self.animasize = Vector2.New(sizedel.x,sizedel.y);
    local floop = 1;
    if loop~=nil and loop>0 then
       floop = loop;
    end
    for a=1,floop do
         for i=1,cont do
             self.anima:AddSprite(FruitsSlot_Data.icon_res.transform:Find(animgname.."_"..i):GetComponent('Image').sprite);
        end
    end
      -- error("6666__setAnima___"..self.anima.curFrame);
       --error("_22__setAnima___");
      self.isreadplayanima = true;
      self.isdispath = isdispath;
end

function FruitsSlot_Run_Soon_Item:addAnima(animgname,cont)
   for i=1,cont do
        self.anima:AddSprite(FruitsSlot_Data.icon_res.transform:Find(animgname.."_"..i):GetComponent('Image').sprite);
    end
end
--设置坐标
function FruitsSlot_Run_Soon_Item:setPoint(pos)
   self.item.transform.localPosition = pos;
end
--播放动画
function FruitsSlot_Run_Soon_Item:playAnima(playtype)
   if self.isreadplayanima==true then
      if playtype~=nil then
         self.select_play_type = playtype;
      end
      self.icon.gameObject:GetComponent("RectTransform").sizeDelta = Vector2.New(self.animasize.x,self.animasize.y);
      self.anima:Play();
      self.isreadplayanima=false;
   end
end
--播放完成把默认的图片弄上去
function FruitsSlot_Run_Soon_Item:playCom()
   self:stopAnima();
   if self.isdispath == true then
      --error("____FruitsSlot_Run_Soon_Item:playCom_____");
      FruitsSlotEvent.dispathEvent(FruitsSlotEvent.game_img_play_com,self.select_play_type);
   end
   self.select_play_type = FruitsSlot_Config.select_img_play_com_type_line;
   self.isdispath = false;
end

function FruitsSlot_Run_Soon_Item:stopAnima()
   self.icon.gameObject:GetComponent("RectTransform").sizeDelta = Vector2.New(self.showsize.x,self.showsize.y);
   self.icon.gameObject:GetComponent("Image").sprite = self.defalutImg;
   self.isreadplayanima = false;
end


