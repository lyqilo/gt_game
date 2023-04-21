BirdsAndBeast_RunItme = {}
local  self = BirdsAndBeast_RunItme;

self.data = nil;
self.per = nil;
self.isselect = false;
self.bganima = nil;
self.selectanima = nil;
function BirdsAndBeast_RunItme:new()
    local obj = {};
    setmetatable(obj,{__index=self});
    return obj;
end

function BirdsAndBeast_RunItme:setData(args)
    self:init();
    self.data = args;
end

function BirdsAndBeast_RunItme:init()
   self.data = nil;
   self.per = nil;
   self.isselect = false;
   self.bganima = nil;
   self.selectanima = nil;
end

function BirdsAndBeast_RunItme:setPer(args)  
   self.per = args;
   local anbg = self.per.transform:Find("anima");
   anbg.gameObject:AddComponent(typeof(ImageAnima));
   self.bganima = anbg.transform:GetComponent("ImageAnima");
   for i=1,3 do
--      self.bganima:AddSprite(BirdsAndBeast_GameData.iconres.transform:Find("run_bg_"..1).gameObject:GetComponent('Image').sprite);
--      self.bganima:AddSprite(BirdsAndBeast_GameData.iconres.transform:Find("run_bg_"..2).gameObject:GetComponent('Image').sprite);
--      self.bganima:AddSprite(BirdsAndBeast_GameData.iconres.transform:Find("run_bg_"..3).gameObject:GetComponent('Image').sprite);
   end
   self.bganima.fSep = 0.2;
   --self.bganima:Stop();

   local goselecet = self.per.transform:Find("selectimg");
   goselecet.gameObject:AddComponent(typeof(ImageAnima));
   self.selectanima = goselecet.transform:GetComponent("ImageAnima");
   local selectname = "run_select_";
   if self.data.rtype== BirdsAndBeastConfig.bab_jinsha or self.data.rtype== BirdsAndBeastConfig.bab_yins then
      selectname = "run_maxselect_";
   end
   for i=1,5 do
      self.selectanima:AddSprite(BirdsAndBeast_GameData.iconres.transform:Find(selectname..1).gameObject:GetComponent('Image').sprite);
      self.selectanima:AddSprite(BirdsAndBeast_GameData.iconres.transform:Find(selectname..2).gameObject:GetComponent('Image').sprite);
   end
   self.selectanima.fSep = 0.2;
   --self.selectanima:Stop();
   self.per.transform:Find("selectimg").gameObject:SetActive(false);
end

function BirdsAndBeast_RunItme:setRunImgVisible(args)
   if self.isselect and args==false then
      return;
   end
    self.per.transform:Find("selectimg").gameObject:SetActive(args);
end
function BirdsAndBeast_RunItme:setIsSelect(args)
   self.isselect = args;
end

function BirdsAndBeast_RunItme:setPlayAnima()
   self.bganima:Play();
   self.selectanima:Play();
end
