--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local AlphaFade = {}
self = AlphaFade
self.AllNeedFadeTime = nil
self.FadeObj = nil
self.IsFade = nil
self.targetVal = nil
self.deltaVal = nil
self.CurVal = nil
self.FadeCompelateEvent = nil


function AlphaFade:StartFade(Fadeobj, targetVal, time, event)
    local CanvasGrounp = Fadeobj:GetComponent("CanvasGroup")
    if(CanvasGrounp == nil)then
        logError("Fade CanvasGrounp not found")
        return
    end
    local v = CanvasGrounp.alpha
    if(v == targetVal)then
        logError("Fade val is same")
        return
    end
    self.FadeCompelateEvent = event
    self.FadeObj = Fadeobj
    self.targetVal = targetVal
    self.AllNeedFadeTime = time
    self.IsFade = true
    self.deltaVal = (targetVal - v) / time
    self.CurVal = v;
end

function AlphaFade:SetAlphaVal(obj, AlphaVal)
    --logError("obj.name: "..obj.name)
    local CanvasGrounp = obj:GetComponent("CanvasGroup")
    if(CanvasGrounp == nil)then
        logError("Fade CanvasGrounp not found")
        return
    end
    CanvasGrounp.alpha = AlphaVal
end

function AlphaFade:Update()
    if( self.IsFade)then
        self.CurVal = self.CurVal + self.deltaVal * UnityEngine.Time.deltaTime
        if(self.deltaVal > 0)then
            if( self.CurVal >= self.targetVal )then
                 self.CurVal = self.targetVal
                if(self.FadeCompelateEvent ~= nil)then
                    self.FadeCompelateEvent()
                    self.FadeCompelateEvent = nil  
                    return
                end
                self:SetAlphaVal(self.FadeObj,  self.targetVal)
                self.IsFade = false
            end
        else
            if( self.CurVal <= self.targetVal )then
                 self.CurVal = self.targetVal
                if(self.FadeCompelateEvent ~= nil)then
                    self.FadeCompelateEvent()
                    self.FadeCompelateEvent = nil
                    return
                end
                 self:SetAlphaVal(self.FadeObj,  self.targetVal)
                    self.IsFade = false
            end
        end
        self:SetAlphaVal(self.FadeObj, self.CurVal)
    end
end

return AlphaFade
--endregion
