flm_Run_Soon_Item = {};
local self = flm_Run_Soon_Item;


function flm_Run_Soon_Item:new()
    local go = {};
    self.guikey = "cn";
    setmetatable(go,{__index = self});
    go.guikey = flm_Event.guid();
    return go;
end

function flm_Run_Soon_Item:init(args)
    self.item = nil;
    self.anima = nil;-- 动画
    self.icon = nil;-- 把动画加到icon上
    self.selectAnima = nil;--选中外面还有个动画
    self.isreadplayanima = false;
    self.isdispath = false;
    self.animaType = 1;
    self.iscreateanima = false;
end

function flm_Run_Soon_Item:setPer(per,iscreateanima)
   self:init();
   self.item = newobject(per);
   self.icon = self.item.transform:Find("icon");   
   self.item.transform:Find("goldmode").gameObject:SetActive(false);
   self.iscreateanima = iscreateanima;
   if iscreateanima==true then
      self.anima = self.item.transform:Find("iconanima").gameObject:AddComponent(typeof(ImageAnima)); 
      self.anima:SetEndEvent(flm_Event.hander(self,self.playCom));
      self.anima.fSep = 0.07;
      self.selectAnima = self.item.transform:Find("selectanima").gameObject:AddComponent(typeof(ImageAnima));      
      self.selectAnima.fSep = 0.07;
      self:addEvent();
   end  
end

function flm_Run_Soon_Item:getPosint()
   return self.item.transform.position;
end

function flm_Run_Soon_Item:setParent(mparent)
   self.item.transform:SetParent(mparent.transform);
   self.item.transform.localScale = Vector3.New(1,1,1);
   self.item.transform.localPosition = Vector3.New(0,0,0);
end

function flm_Run_Soon_Item:addEvent()
   flm_Event.addEvent(flm_Event.xiongm_colse_line_anima,flm_Event.hander(self,self.closeLineHander),self.guikey);
   flm_Event.addEvent(flm_Event.xiongm_start,flm_Event.hander(self,self.startRunHander),self.guikey);
   flm_Event.addEvent(flm_Event.game_once_over,flm_Event.hander(self,self.onceOver),self.guikey); 
end
-- 设置显示的图片
function flm_Run_Soon_Item:setImg(imgname,goldtype)
   local item = flm_Data.icon_res.transform:Find(imgname);
   local sizedel = item.gameObject:GetComponent("RectTransform").sizeDelta;
   self.icon.gameObject:GetComponent("RectTransform").sizeDelta = Vector2.New(sizedel.x,sizedel.y);
   self.icon.gameObject:GetComponent("Image").sprite = item.gameObject:GetComponent("Image").sprite;
   if self.iscreateanima == false then
      return;
   end
   if goldtype>0 then
      self.item.transform:Find("goldmode/numcont").gameObject:SetActive(false);
      self.item.transform:Find("goldmode/dafu").gameObject:SetActive(false);
      self.item.transform:Find("goldmode/xiaofu").gameObject:SetActive(false);
      self.item.transform:Find("goldmode").gameObject:SetActive(true);
      --1:大福 2小福
      if goldtype == 2 then
         self.item.transform:Find("goldmode/xiaofu").gameObject:SetActive(true);
      elseif goldtype == 1 then
         self.item.transform:Find("goldmode/dafu").gameObject:SetActive(true);
      else
         self.item.transform:Find("goldmode/numcont").gameObject:SetActive(true);
         flm_PushFun.CreatShowNum(self.item.transform:Find("goldmode/numcont"),goldtype,"gold_mode_",false,18,2,125,-50);
      end

   else
      self.item.transform:Find("goldmode").gameObject:SetActive(false);
   end
end

--设置动画 animatype 是不是要隐藏icon
function flm_Run_Soon_Item:setAnima(cofigdata,isdispath)
    -- error("____flm_Run_Soon_Item______setAnima____");
     if self.isreadplayanima == true then
        return;
     end
     if self.anima == nil or self.selectAnima==nil then
        return;
     end 
      --error("__111__flm_Run_Soon_Item______setAnima____");
    self.anima:StopAndRevert();
    self.selectAnima:StopAndRevert();
    self.isreadplayanima = true;
    self.anima:ClearAll();
    self.anima.fDelta = 0;
    self.selectAnima:ClearAll();
    self.selectAnima.fDelta = 0;
     --error("__222__flm_Run_Soon_Item______setAnima____");
    self.item.transform:Find("iconanima").gameObject:GetComponent('Image').color = Color.New(1,1,1,1);
    self.animaType = cofigdata.animatype;
    -- error("__333__flm_Run_Soon_Item______setAnima____");
    if cofigdata.animatype==2 then
       for a=1,cofigdata.loop do
            for i=1,cofigdata.count do
                self.anima:AddSprite(flm_Data.icon_res.transform:Find(cofigdata.animaimg..i):GetComponent('Image').sprite);
            end
        end       
    elseif cofigdata.animatype==4 then
       for c=1,cofigdata.loop do
           for e=1,cofigdata.count do
               self.selectAnima:AddSprite(flm_Data.icon_res.transform:Find(cofigdata.animaimg..e):GetComponent('Image').sprite);
           end
       end  
    elseif cofigdata.animatype>0 then
--       for a=1,3 do -- 强制加边框
--            for i=1,7 do
--                self.selectAnima:AddSprite(flm_Data.icon_res.transform:Find("icon_select_"..i):GetComponent('Image').sprite);
--            end
--        end
        if cofigdata.animatype==3 then
            for c=1,cofigdata.loop do
                for e=1,cofigdata.count do
                   self.anima:AddSprite(flm_Data.icon_res.transform:Find(cofigdata.animaimg..e):GetComponent('Image').sprite);
                end
            end 
         end 
    end
    -- error("__555__flm_Run_Soon_Item______setAnima____");
    self.isreadplayanima = true;
    self.isdispath = isdispath;
end

--设置坐标
function flm_Run_Soon_Item:setPoint(pos)
   self.item.transform.localPosition = pos;
end

--停止播放选择的东西
function flm_Run_Soon_Item:stopPlaySelctAnima()
   self.anima:StopAndRevert();
   self.selectAnima:StopAndRevert();
end
function flm_Run_Soon_Item:playSelctAnima()
   self.anima:Play();
   self.selectAnima:Play();
end

function flm_Run_Soon_Item:loopPlaySelctAnima(args)
    self.anima:PlayAlways();
   self.selectAnima:PlayAlways();
end

function flm_Run_Soon_Item:closeLineHander(args)
   self:stopPlaySelctAnima();
   self.isSelect = false;
end
--播放动画
function flm_Run_Soon_Item:playAnima()
   if self.isreadplayanima==true then
      --if self.animaType ==4  then
         self.icon.gameObject:SetActive(false);
     -- end
      self.anima:Play();
      self.selectAnima:Play();
   end
end

function flm_Run_Soon_Item:getIsReadAnima()
   return self.isreadplayanima;
end

function flm_Run_Soon_Item:startRunHander(args)
    self:stopPlaySelctAnima();
    self.isreadplayanima = false;
   self.isdispath = false;
end

function flm_Run_Soon_Item:setJiuGong(cofigdata) 
    self.anima:StopAndRevert();
    self.selectAnima:StopAndRevert();
    self.anima:ClearAll();
    self.anima.fDelta = 0;
    self.selectAnima:ClearAll();
    self.selectAnima.fDelta = 0;
    if cofigdata.animatype==2 then
       for a=1,cofigdata.loop do
            for i=1,cofigdata.count do
                self.anima:AddSprite(flm_Data.icon_res.transform:Find("jiugong_anima_"..i):GetComponent('Image').sprite);
            end
        end       
    elseif cofigdata.animatype==4 then
       for c=1,cofigdata.loop do
           for e=1,cofigdata.count do
               self.selectAnima:AddSprite(flm_Data.icon_res.transform:Find(cofigdata.animaimg..e):GetComponent('Image').sprite);
           end
       end  
    end
    self:loopPlaySelctAnima();

--    local item = self.item.transform:Find("iconanima");

--    local sourceitem = flm_Data.icon_res.transform:Find("jiugong_anima");
--    local sizedel = sourceitem.gameObject:GetComponent("RectTransform").sizeDelta;
--    item.gameObject:GetComponent("RectTransform").sizeDelta = Vector2.New(sizedel.x,sizedel.y);


--    item:GetComponent('Image').sprite = sourceitem:GetComponent('Image').sprite;
--    item.gameObject:GetComponent('Image').color = Color.New(1,1,1,1);
--    local tween = item.gameObject:GetComponent('Image'):DOColor(Color.New(1,1,1,0),3);

end


function flm_Run_Soon_Item:onceOver(args)
  self:stopPlaySelctAnima();
end


--播放完成把默认的图片弄上去
function flm_Run_Soon_Item:playCom()
   self.icon.gameObject:SetActive(true);   
end


