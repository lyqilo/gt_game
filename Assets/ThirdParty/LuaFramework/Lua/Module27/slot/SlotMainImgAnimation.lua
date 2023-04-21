--SlotMainImgAnimation*.lua
--Date
--slot 主图片动画类 对应luaBehaviour


--endregion
--require "Common/Util"
SlotMainImgAnimation = {};

local self = SlotMainImgAnimation;

local C_ANIM_MAX_COUNT = 20; --动画最大长度

local C_ANIM_JYMT_SPEED = 0.04; --金玉满堂速度
local C_ANIM_OTHER_SPEED = 0.05; --其他动画速度

self.WILD = nil;

self.WILD2 = nil;

--self.animRes = nil;




function SlotMainImgAnimation:New(o)
    local t = o or { };
    setmetatable(t, self);
    self.__index = self
    return t;
end

function SlotMainImgAnimation:Create(obj)
    
--    luaBehaviour = Util.AddComponent("LuaBehaviour", obj.gameObject);
--    luaBehaviour:SetLuaTab(self, "SlotMainImgAnimation");  
    self:Begin(obj);
end

function SlotMainImgAnimation:Begin(obj)

    self.transform = obj.transform;
    local str = string.split(self.transform.name, "_");
    self.transform.name = str[1];
    self.name = self.transform.name;

    --self.comAnim = self.transform:GetComponent("ImageAnima");
    --self.comAnim = obj.gameObject:AddComponent(ImageAnima.GetClassType());
	self.comAnim = Util.AddComponent("ImageAnima", obj.gameObject);
    self.comAnim:SetEndEvent(SlotMainImgAnimation.handler(self,self.CallBackAnimationEnd) );
    self.bPlay = false;

    self.bJYMT = false;

--    if(not self.animRes) then
--        --self.animRes = LoadAsset(SlotResourcesName.dbAnimationStr, 'MainImageAnimationRes'); --动画资源
--		log("anim res ====================================");
--		self.animRes = Game01Panel.Pool("MainImageAnimationRes");
--    end

    --self.comAnim.lSprites:RemoveAt(C_ANIM_MAX_COUNT - 1);
    --self.comAnim.lSprites:Add(self.animRes.transform:Find("0"):GetChild(0):GetComponent('Image').sprite);
    --log("name is " .. self.name);
    
end


function SlotMainImgAnimation:Update()
   
--   if(self.bPlay) then
--        self.transform:Rotate(0, 0, Time.deltaTime * -100);
--   end

end


--function SlotMainImgAnimation:FixedUpdate()
--end
function SlotMainImgAnimation:SetName(sName)
    self.name = sName
    self.transform.name = self.name;
end

function SlotMainImgAnimation:GetComponent(sComName)
    
    return self.transform:GetComponent(sComName);
end

function SlotMainImgAnimation:SetSprite(args)

end


function SlotMainImgAnimation:PlayAnimation(bPlay, bJYMT)
    
    if(not bPlay) then

        self.comAnim:Stop();

        if(self.bPlay) then
            self.transform:GetComponent('Image').sprite = self.comAnim.lSprites[0];
        end

        for i = 0, self.transform.childCount - 1 do
            destroy(self.transform:GetChild(i).gameObject);
        end

        --self.transform.eulerAngles = Vector3.New(0,0,0);

        self.bPlay = false;

        return;
    end

    self.bPlay = true;

    self.bJYMT = bJYMT;
	
    self:SetImageScript(bJYMT);

    if(bJYMT) then
        self.comAnim.fSep = C_ANIM_JYMT_SPEED;
        self.comAnim:Play();
        return;
    end
	
    self.comAnim.fSep = C_ANIM_OTHER_SPEED;
    self.comAnim:PlayAlways();

    --if(SlotDataStruct.enGameImage.E_NORMAL_CORUNCOPIA_IMG == tonumber(self.name) ) or 
--    if( SlotDataStruct.enGameImage.E_SUPER_CORUNCOPIA_IMG == tonumber(self.name) ) then --宝箱

--            local traWild;
--            if(SlotDataStruct.enGameImage.E_NORMAL_CORUNCOPIA_IMG == tonumber(self.name)) then --普通宝箱

--                if(not self.WILD) then
--                    self.WILD = ResManager:LoadAsset(SlotResourcesName.dbResNameStr, 'ObjRes').transform:Find("WILD"); 
--                end
--                traWild = newobject(self.WILD);
--            else

--                if(not self.WILD2) then
--                    self.WILD2 = ResManager:LoadAsset(SlotResourcesName.dbResNameStr, 'ObjRes').transform:Find("WILD2"); 
--                end
--                traWild = newobject(self.WILD2);
--            end

--            traWild.name = "WILD";
--            traWild.transform.parent = self.transform;
--            traWild.transform.localScale = Vector3.New(1, 1, 1);
--            traWild.transform.localPosition = Vector3.New(0, 0, 0);

--            traWild.transform:DOScale(Vector3.New(0.8, 0.8, 0.8), 0.5):SetEase(DG.Tweening.Ease.Linear):SetLoops(-1); 

--    elseif(SlotDataStruct.enGameImage.E_SMALL_HONGBAO_IMG == tonumber(self.name) or 
--                SlotDataStruct.enGameImage.E_NORMAL_HONGBAO_IMG == tonumber(self.name) or 
--                    SlotDataStruct.enGameImage.E_BIG_HONGBAO_IMG == tonumber(self.name)) then  --红包

        --self.bPlay = bPlay;
--   else
        --self.bPlay = bPlay;
--   end

    
end


function SlotMainImgAnimation:SetImageScript(bJYMT)

    local sAnimName = self.name;

    if(bJYMT) then
        sAnimName = "Ask"
    end

    local traAnimRes = Game01Panel.animRes.transform:Find(sAnimName);

    local iAnimChildIdx = 0;

    --self.comAnim.lSprites:Clear();

    self.comAnim:ClearAll();
    for i = 0, traAnimRes.transform.childCount - 1 do   
       --self.comAnim.lSprites:Add(traAnimRes.transform:GetChild(i):GetComponent('Image').sprite);
       self.comAnim:AddSprite(traAnimRes.transform:GetChild(i):GetComponent('Image').sprite);
    end

--    for i = 0, C_ANIM_MAX_COUNT - 1 do

--       self.comAnim.lSprites[i] = traAnimRes.transform:GetChild(iAnimChildIdx):GetComponent('Image').sprite;
--       iAnimChildIdx = iAnimChildIdx + 1;

--       if(iAnimChildIdx >= traAnimRes.childCount ) then
--            iAnimChildIdx = 0;
--       end

--    end

    if(bJYMT) then
        --log("self.name " .. self.name);
        self.comAnim.lSprites[self.comAnim.lSprites.Count - 1] = SlotBase.GetMainImage(self.name).sprite; 
    end

end


function SlotMainImgAnimation:CallBackAnimationEnd()
    --log(self.name .. "-------------------");

    if(not self.bPlay) then return; end
    self.transform:GetComponent('Image').sprite = self.comAnim.lSprites[self.comAnim.lSprites.Count - 1];
    if(not self.bJYMT) then return; end
    self.transform:GetComponent('Image'):SetNativeSize();
end


function SlotMainImgAnimation.handler(obj,func)
    return function(...)
        return func(obj,...);
    end
end

