longhudou_Run_Soon_Item = {};
local self = longhudou_Run_Soon_Item;

local isCreatIcon=false

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
    self.iconAnim=nil
end

function longhudou_Run_Soon_Item:setPer(per,createanima,curindex)
   self:init();
   self.item = newobject(per);
   self.icon = self.item.transform:Find("icon");
   self.iconanimaF=self.item.transform:Find("iconanima");--动画父节点
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
      --self.selectAnima:Play();
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
   logYellow("-----======cofigdata=====------")
   logTable(cofigdata)
   if cofigdata.animaimg=="anima_toum" then
      self.iconAnim=nil
      return;
   end

   if self.iconanimaF.childCount<1 then
      isCreatIcon=true
   else
      for i=1,self.iconanimaF.childCount do
         if self.iconanimaF:GetChild(i-1).name==cofigdata.animaimg then
            logYellow("动画节点已存在")
            isCreatIcon=false
            self.iconAnim=self.iconanimaF:GetChild(i-1)
            break;
         else
            self.iconanimaF:GetChild(i-1).gameObject:SetActive(false)
         end
         isCreatIcon=true
      end
   end

   if isCreatIcon then
      local go=newObject(longhudou_Data.icon_res.transform:Find(cofigdata.animaimg))
      go.name=cofigdata.animaimg
      go:SetParent(self.iconanimaF)
      go.localPosition=Vector3.New(0,0,0)
      go.localScale=Vector3.New(1,1,1)
      go.gameObject:SetActive(false)
      self.iconAnim=go
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

   if self.iconAnim~=nil then
      if self.iconAnim.name=="icon_Anim_changlong" then
         for i=1,self.item.parent.childCount do
            self.item.parent:GetChild(i-1):Find("icon").gameObject:SetActive(true)
         end
      else
         self.icon.gameObject:SetActive(true);
      end
      self.iconAnim.gameObject:SetActive(false)
   end
end
function longhudou_Run_Soon_Item:playSelctAnima()
   logYellow("播放选择的东西")
end

function longhudou_Run_Soon_Item:closeLineHander(args)
   self:stopPlaySelctAnima();
   self.isSelect = false;
end
--播放动画
function longhudou_Run_Soon_Item:playAnima()
   logYellow("播放动画")
   if self.isreadplayanima==true then
      if self.iconAnim~=nil then

         if self.iconAnim.name=="icon_Anim_changlong" then
            for i=1,self.item.parent.childCount do
               self.item.parent:GetChild(i-1):Find("icon").gameObject:SetActive(false)
            end
            self.iconAnim.gameObject:SetActive(true)
            self.iconAnim:GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0,"start",false);
            --self.iconAnim:GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0,"loop",true);
            
         else
            self.icon.gameObject:SetActive(false);
            self.iconAnim.gameObject:SetActive(true)
            self.iconAnim:GetComponent("SkeletonGraphic").AnimationState:SetAnimation(0,"animation",true);
         end
      end
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


