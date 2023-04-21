SHZImgAnimation={};

function SHZImgAnimation:New()
    local t = o or { };
    setmetatable(t, self);
    self.__index = self
    return t;
end


function SHZImgAnimation:Creat(obj)
    self.obj=obj;
    self.transform = obj.transform;
   -- self.wangbo="wangbo"..obj.name;
    self.comAnim = self.transform:GetComponent("ImageAnima");
    self.comAnim:SetEndEvent(handler(self, self.CallBackAnimationEnd));

   -- self.ImgIdx=0;
   self.comAnim.fSep = 0.08;
    self.stopSprite=nil;
end

function SHZImgAnimation:Update()
end

-- 播放动画
function SHZImgAnimation:PlayAnimation()
if self.comAnim.lSprites.Count==0 then return end
self.obj:SetActive(true);
    self.comAnim:Play();
end

--设置要播放的动画图
function SHZImgAnimation:SetImgScript(imganim,stopimg)
   -- error("设置要播放的动画图=====、id");
  --  self.ImgIdx=idx;
    self.stopSprite=stopimg;
    self.comAnim:Stop();
    self.comAnim:ClearAll();
   -- self.setImgObj = SHZGameMangerTable[1].MainSelf.ShowResultImg.transform:GetChild(idx);
   self.setImgObj = imganim;
    self.comAnim= self.transform:GetComponent("ImageAnima");
    for i = 1, self.setImgObj.childCount do
        self.comAnim:AddSprite(self.setImgObj.transform:GetChild(i-1):GetComponent('Image').sprite)
      --  error("添加sprite======================="..i);
      -- error("-----------------------------------"..setImgObj.transform:GetChild(i-1):GetComponent('Image').name)
    end 
        self.comAnim:Play(); 
end

--动画播放完调用的事件
function SHZImgAnimation:CallBackAnimationEnd()
    --   self.obj:SetActive(false);
    local num = tonumber(self.obj.name)
    --   self.transform:GetComponent("Image").sprite = SHZGameMangerTable[1].MainSelf.ResultImg.transform:GetChild(num):GetComponent('Image').sprite
    self.transform:GetComponent("Image").sprite = self.stopSprite;
end

--停止播放动画
function SHZImgAnimation:StopAnimator()
self.comAnim:Stop();
end

