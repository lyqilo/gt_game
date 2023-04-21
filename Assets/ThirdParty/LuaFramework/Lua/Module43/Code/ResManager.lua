--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local ResManager = {}
local self = ResManager
self.EffectData = {}
self.CurEffectData = {}
self.CurSpriteData = {}
self.AudioClipData = {}
self.PrefabData = {}

function ResManager.InitEffect(effectData)
    for k, v in pairs(effectData)do
        self.EffectData[v.name] = v
    end
end

function ResManager.InitPrefab(PrefabData)
 for k, v in pairs(PrefabData)do
        if(self.PrefabData[v.name] == nil)then 
            self.PrefabData[v.name] = v
        else
            logError("init prefab error, same key")
        end
    end
end

function ResManager.InitSprite(SpriteData)
    for k, v in pairs(SpriteData)do
        if(self.CurSpriteData[v.name] == nil)then 
            self.CurSpriteData[v.name] = v
        else
            logError("init Sprite error, same key")
        end
    end
end

function ResManager.InitAudioClip(AudioData)
    for k, v in pairs(AudioData)do
        self.AudioClipData[v.name] = v
    end
end

function ResManager.GetSpriteByName(name)
    if(self.CurSpriteData[name] ~= nil)then
        return self.CurSpriteData[name]
    else
        logError("获取图片失败: "..name)
        return nil
    end
end

function ResManager.GetPrefabByName(name)
    if(self.PrefabData[name] ~= nil)then
        return self.PrefabData[name]
    else
        logError("获取预制失败: "..name)
        return nil
    end
end

function ResManager.GetAudioCliByName(name)
    if(self.AudioClipData[name] ~= nil)then
        return self.AudioClipData[name]
    else
        logError("获取音效失败: "..name)
        return nil
    end
end

function ResManager.AddEffect(pare, name, pos, Istemp)
    local effect = self.CreateEffect(name)
    if(effect ~= nil)then
        local i = 0
        while(self.CheckExistEffect(name))do
            name = name..tostring(i)
            i = i + 1
        end
        effect.transform:SetParent(pare, false)
        effect.transform.localScale = Vector3.New(1,1, 1)
        effect.transform.localPosition = pos
        self.CurEffectData[name] = {}
        self.CurEffectData[name].obj = effect
        self.CurEffectData[name].IsTemp = Istemp
    end
end

function ResManager.GetEffect(name)
     for k, v in pairs(self.CurEffectData)do
        if(k == name)then
            return v.obj
        end
    end
    logError("Get effect fail, not find EffectName: "..name)
end

function ResManager.ClearTempEffect()
    for k, v in pairs(self.CurEffectData)do
        if(v~= nil and v.IsTemp)then
            destroy(v.obj)
            self.CurEffectData[k] = nil
        end
    end
end

function ResManager.ClearAllEffect()
    for k, v in pairs(self.CurEffectData)do
        if(v ~= nil)then
            UnityEngine.GameObject.Destroy(v.obj)
        end
    end
    self.CurEffectData = {}
end

function ResManager.CreateEffect(name)
    for k, v in pairs(self.EffectData)do
        if(k == name)then
            return newobject(v)
        end
    end
    logError("not Find effect: "..name)
end

function ResManager.CheckExistEffect(name)
    for k, v in pairs(self.CurEffectData)do
        if(k == name and v ~= nil)then
            return true
        end
    end
    return false
end

function ResManager.Dispose()
    self.EffectData = {}
    self.CurEffectData = {}
    self.CurSpriteData = {}
    self.AudioClipData = {}
    self.PrefabData = {}
end

return ResManager


--endregion
