local _CAnimaTool = class("_CAnimaTool");

function _CAnimaTool:ctor()
    self._spriteCreator = nil;
end

--设置sprite 创建器
function _CAnimaTool:SetCreator(_spriteCreator)
    self._spriteCreator = _spriteCreator;
end

--为某个游戏体添加动画组件
--如果没有image组件，会添加，如果没有imageAnima，会添加
function _CAnimaTool:AddAnima(go,animaType)
    if not self._spriteCreator then
        return ;
    end
    local animateData = G_GlobalGame.GameConfig.AnimaStyleInfo[animaType];
    if not animateData then
        return ;
    end
    if not go then
        return ;
    end
    local image = go:GetComponent(typeof(UnityEngine.UI.Image));
    if not image then
        image = go:AddComponent(typeof(UnityEngine.UI.Image));
    end
    local imageAnima = go:GetComponent(typeof(ImageAnima));
    if not imageAnima then
        imageAnima = go:AddComponent(typeof(ImageAnima));
    end
    imageAnima.fSep = animateData.interval;
    local frameIndex = animateData.frameBeginIndex;
    local str;
    local sprite;
    local abFileName=animateData.abfileName;
    local frameMin = 0;
    if animateData.frameMin then
        frameMin = animateData.frameMin;
    end
    local isRaycastTarget = animateData.isRaycastTarget or false;
    image.raycastTarget = isRaycastTarget;

    local function loadSprite(imageAnima,frameIndex)
        local str =string.format(animateData.format, frameIndex);
        sprite = self._spriteCreator(abFileName,str);
        if xpcall(function()
            imageAnima:AddSprite(sprite);
        end,function (msg)
            error("animateType:" .. animaType);
        end) then
        end
        return sprite;
    end

    local frameCount = animateData.customFrames and #animateData.customFrames or 0;
    if frameCount>0 then
        --自定义帧率
        for i=1,frameCount do
            frameIndex = animateData.customFrames[i];
            if frameIndex==-1 then
                imageAnima:AddSprite(nil);
            else
                loadSprite(imageAnima,frameIndex);
            end

            if i==1 then
                image.sprite = sprite;
                if animateData.isCorrentSize then
                    if animateData.size then
                        local rect = image.transform:GetComponent("RectTransform");
                        rect.sizeDelta = Vector2.New(animateData.size.x,animateData.size.y);
                    else
                        image:SetNativeSize();
                    end
                end
            end
        end
    else
        frameCount = animateData.realFrameMax and animateData.realFrameMax or 9999;
        for i=1,animateData.frameCount do
            if frameIndex< frameMin then
                frameIndex = frameMin;
            end
            if animateData.frameMax then
                --最大的索引
                if frameIndex>animateData.frameMax then
                    frameIndex = frameMin;
                end
            end
            if frameIndex>=frameCount then
                imageAnima:AddSprite(nil);
            else
                loadSprite(imageAnima,frameIndex);
            end
            frameIndex = frameIndex + animateData.frameInterval;

            if i==1 then
                image.sprite = sprite;
                if animateData.isCorrentSize then
                    if animateData.size then
                        local rect = image.transform:GetComponent("RectTransform");
                        rect.sizeDelta = Vector2.New(animateData.size.x,animateData.size.y);
                    else
                        image:SetNativeSize();
                    end
                end
            end
        end
    end
    if animateData.defaultSprite then
        imageAnima.defaultSprite = self._spriteCreator(abFileName,animateData.defaultSprite);
        image.sprite = imageAnima.defaultSprite;
    elseif animateData.isNullDefault then
        image.sprite = nil;
    end
    return imageAnima;
end



return _CAnimaTool;