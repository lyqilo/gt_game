local CSoundDefine = GameRequire__("SoundDefine");

local _CSound = class("_CSound")

function _CSound:ctor()
    self.isLoop = false;
    self.isPause= false;
    self.isPlaying = false;
    self.playTime = 0;
    self.totalTime =0;
    self:_createGO();
    self.isHardLoop = false;
    self.loopTime = 0;
end

function _CSound:Play(_clip)
    if not _clip then
        return false;
    end
    self.isPlaying = true;
    self.isPause= false;
    self.isLoop = false;
    self.totalTime = _clip.length;
    self.isHardLoop = false;
    self.loopTime = 1;
    self.playTime = 0;
    --self:_createGO();
    self.audioSource.clip = _clip;
    self.audioSource.loop = false;
    --self.gameObject:SetActive(true);
    self.audioSource.mute = false;
    self.audioSource:Play();
end

function _CSound:LoopPlay(_clip,_loopTime,_disTime)
    if not _clip then
        return false;
    end
    self.isPlaying = true;
    self.isPause= false;
    self.isLoop = true;
    self.totalTime = _disTime or _clip.length;
    self.loopTime = _loopTime or -1;
    --self:_createGO();
    if _disTime==nil and (self.loopTime==-1 or self.loopTime>=9999) then
        self.isHardLoop = true;
        self.audioSource.loop = true;
    else
        self.isHardLoop = false;
        self.audioSource.loop = false;
    end
    self.audioSource.clip = _clip;
    self.playTime = 0; 
    --self.gameObject:SetActive(true);
    self.audioSource:Play();
end

function _CSound:HardLoopPlay(_clip,_loopTime)
    if not _clip then
        return false;
    end
    self.isPlaying = true;
    self.isPause= false;
    self.isLoop = true;
    self.totalTime = _clip.length;
    self.isHardLoop = true;
    self.loopTime = _loopTime or -1;
    --self:_createGO();
    self.audioSource.clip = _clip;
    self.audioSource.loop = true;
    self.audioSource.mute = false;
    self.playTime = 0;
    --self.gameObject:SetActive(true);
    self.audioSource:Play();
end

function _CSound:Update(dt)
    if not self.isPlaying then
        return ;
    end
    if self.isPause then
        return ;
    end
    if self.isLoop then
        if self.isHardLoop then
            if self.loopTime==-1 then
               
            else
                self.playTime = self.playTime + dt;
                if self.playTime>=self.totalTime then
                    self.loopTime = self.loopTime -1;
                    if self.loopTime>0 then
                        self.playTime = 0;
                    else
                        self.audioSource:Stop();
                        self:Stop();
                    end
                end
            end
        else
            self.playTime = self.playTime + dt;
            if self.playTime>=self.totalTime then
                self.audioSource:Stop();
                if self.loopTime==-1 then
                    self.audioSource:Play();
                    self.playTime = 0;
                else
                    self.loopTime = self.loopTime -1;
                    if self.loopTime>0 then
                        self.audioSource:Play();
                        self.playTime = 0;
                    else
                        self:Stop();
                    end
                end
            end
        end
    else
        self.playTime = self.playTime + dt;
        if self.playTime>=self.totalTime then
            self.audioSource:Stop();
            self:Stop();
        end
    end
end

function _CSound:Stop()
    self.isPlaying = false;
    self.isPause= false;
    self.isLoop = false;
    --self:_destroy();
    --self.gameObject:SetActive(false);
    self.audioSource.clip = nil;
    self.playTime = 0;
end

function _CSound:_destroy()
    if self.gameObject then
        destroy(self.gameObject);
        self.gameObject = nil;
    end
end

function _CSound:_createGO()
    self.gameObject = GAMEOBJECT_NEW();
    self.audioSource= self.gameObject:AddComponent(AudioSourceClassType);
end

function _CSound:Destroy()
    self:_destroy();
end

function _CSound:Pause()
    if not self.isPlaying then
        return ;
    end
    if self.isPause then
        return ;
    end
    self.isPause= true;
    self.audioSource:Pause();
end

function _CSound:Resume()
    if not self.isPlaying then
        return ;
    end
    if not self.isPause then
        return ;
    end
    self.isPause= false;
    self.audioSource:Play();   
end

function _CSound:Mute(mute)
    self.audioSource.mute = mute;
end

function _CSound:IsEnd()
    return not self.isPlaying;
end

local _CSoundManager = class("_CSoundManager");
--对应c#里的InitControl
--GameScenSoundControl

function _CSoundManager:ctor()
    self.transform = nil;
    self.audioClipTab = {};
    self.lastBgId = nil;
    self.soundItems = {};
    self.allItems =  {};
    self.allEffectItems = {};
    self.soundBG    = nil; --背景音乐单独处理 背景是支持堆栈方式播放
    self.soundCacheItems = {};
    self.soundLoopCacheItems = {};
    self.soundBGCacheItems = {};
    self.lastPlayEffect = nil;
    self.lastPlayBG     = nil;
    self.isMuteBG       = false;
    self.handler = 10000;
    self.bgSounds = {};
end

function _CSoundManager:Init()

end

function _CSoundManager:_getSoundItem()
    if #self.soundCacheItems>0 then
        local item = self.soundCacheItems[#self.soundCacheItems];
        table.remove(self.soundCacheItems);
        self.handler = self.handler + 1;
        item.handler = self.handler;
        self.soundItems[self.handler] = item;
        return item;
    end
    local item = _CSound.New();
    self.handler = self.handler + 1;
    item.handler = self.handler;
    self.soundItems[self.handler] = item;
    self.allItems[#self.allItems+1] = item;
    self.allEffectItems[#self.allEffectItems+1] = item;
    return item;
end

--function _CSoundManager:_getLoopSoundItem()
--    if #self.soundCacheItems>0 then
--        local item = self.soundLoopCacheItems[#self.soundLoopCacheItems];
--        table.remove(self.soundLoopCacheItems);
--        self.handler = self.handler + 1;
--        item.handler = self.handler;
--        self.soundItems[self.handler] = item;
--        return item;
--    end
--    local item = _CSound.New();
--    self.handler = self.handler + 1;
--    item.handler = self.handler;
--    self.soundItems[self.handler] = item;
--    self.allItems[#self.allItems+1] = item;
--    self.allEffectItems[#self.allItems+1] = item;
--    return item;
--end

function _CSoundManager:_cacheItems(item)
    self.soundCacheItems[#self.soundCacheItems+1] = item;
end

function _CSoundManager:Update(_dt)
    local isPlayBG = MusicManager.isPlayMV;
    local isPlayEffect = isPlayBG; --MusicManager.isPlaySV;
    if isPlayBG~=self.lastPlayBG then
        if isPlayBG then
            if self.isMuteBG then
                self:_muteBg(true);
            else
                self:_muteBg(not isPlayBG);    
            end
        else
            self:_muteBg(not isPlayBG);
        end
        self.lastPlayBG = isPlayBG;
    end
    if isPlayEffect~=self.lastPlayEffect then
        local count = #self.allEffectItems;
        for i=1,count do
            self.allEffectItems[i]:Mute(not isPlayEffect);
        end
        self.lastPlayEffect = isPlayEffect;
    end
    local deleteVecs ={};
    for k,v in pairs(self.soundItems) do
        v:Update(_dt);
        if v:IsEnd() then
            deleteVecs[#deleteVecs+1] = v.handler;
        end
    end
    local handler;
    for i=1,#deleteVecs do
        handler = deleteVecs[i];
        self:_cacheItems(self.soundItems[handler]);
        self.soundItems[handler] = nil;
    end
end

function _CSoundManager:PlaySound(_id,_loopTime,_loopInterval)
     local chip = self.audioClipTab[_id];
    if not chip then
        local data = CSoundDefine.GetSoundData(_id);
        chip = G_GlobalGame._goFactory:getMusic(data.name,data.abName);
    end
    if chip then
        --MusicManager:PlayX(chip); 
        local item = self:_getSoundItem();
        if _loopTime~=nil then
            item:LoopPlay(chip,_loopTime,_loopInterval);
        else
            item:Play(chip);
        end
        if self.lastPlayEffect then
            --item:NoMute();
        else
            item:Mute(true);
        end
        return item.handler;
    end
end

function _CSoundManager:PlaySoundByHard(_id,_loopTime)
    local chip = self.audioClipTab[_id];
    if not chip then
        local data = CSoundDefine.GetSoundData(_id);
        chip = G_GlobalGame._goFactory:getMusic(data.name,data.abName);
    end
    if chip then
        --MusicManager:PlayX(chip); 
        local item = self:_getSoundItem();
        item:HardLoopPlay(chip,_loopTime);
        if self.lastPlayEffect then
            --item:NoMute();
        else
            item:Mute(true);
        end
        return item.handler;
    end
end

function _CSoundManager:StopSound(handler)
    local item = self.soundItems[handler];
    if item~=nil then
        item:Stop();
    end
end

function _CSoundManager:PlayBgSound(_id)
    _id = _id or self.lastBgId;
    local chip = self.audioClipTab[_id];
    self.lastBgId = _id;
    if not chip then
        local data = CSoundDefine.GetSoundData(_id);
        chip = G_GlobalGame._goFactory:getMusic(data.name,data.abName);
        self.audioClipTab[_id] = chip;
    end
    if chip then
        --MusicManager:PlayBacksoundX(chip,true); 
        self:_getBgSound():HardLoopPlay(chip,-1);
        self:_replayBG();
    end
end

function _CSoundManager:_getBgSoundItem()
    if #self.soundBGCacheItems>0 then
        local item = self.soundBGCacheItems[#self.soundBGCacheItems];
        table.remove(self.soundBGCacheItems);
        return item;
    end
    local item = _CSound.New();
    self.allItems[#self.allItems+1] = item;
    return item;
end

function _CSoundManager:_getBgSound()
    if self.soundBG then
        return self.soundBG;
    end
    self.soundBG = self:_getBgSoundItem();
    return self.soundBG;
end

function _CSoundManager:_muteBg(mute)
    if self.soundBG then
        self.soundBG:Mute(mute);
    end
end

function _CSoundManager:_pauseBg(mute)
    if self.soundBG then
        self.soundBG:Pause();
    end
end
function _CSoundManager:_resumeBg(mute)
    if self.soundBG then
        self.soundBG:Resume();
    end
end

--停止背景音乐
function _CSoundManager:StopBgSound()
    if self.soundBG then
        self.soundBG:Stop();
        self.soundBGCacheItems[#self.soundBGCacheItems+1] = self.soundBG;
        table.remove(self.bgSounds);
        self.soundBG = self.bgSounds[#self.bgSounds];
        if self.soundBG then
            self:_replayBG();
            self:_resumeBg();
        end
    end 
--    if chip then
--        MusicManager:PlayBacksoundX(chip,true); 
--    end
    --MusicManager:PlayBacksoundX(chip,false);
end

function _CSoundManager:PauseBgSound()
    if self.soundBG then
        self.soundBG:Pause();
    end
end

function _CSoundManager:ResumeBgSound()
    if self.soundBG then
        self.soundBG:Resume();
    end
end

function _CSoundManager:MuteBgSound()
    if self.isMuteBG  then
        return ;
    end
    self.isMuteBG = true;
    if self.lastPlayBG==nil then

    elseif not self.lastPlayBG then
        return ;
    end
    self:_muteBg(true);
end

function _CSoundManager:NoMuteBgSound()
    if not self.isMuteBG then
        return ;
    end
    self.isMuteBG = false;
    if self.lastPlayBG then
        self:_muteBg(false);
    end
end

function _CSoundManager:Destroy()
    local count = #self.allItems;
    for i=1,count do
        GameObject.Destroy(self.allItems[i].gameObject);
    end
    self.allItems = {};
    self.soundItems = {};
    self.soundCacheItems = {};
    self.soundBGCacheItems = {};
    self.bgSounds = {};
    self.soundBG = nil;
end

function _CSoundManager:PushBgSound(_id)
    self:_pauseBg();
    self.soundBG = nil;
    self:PlayBgSound(_id);
    self.bgSounds[#self.bgSounds+1] = self.soundBG;
end

function _CSoundManager:PopBgSound()
    self:StopBgSound();
end

function _CSoundManager:_replayBG()
    if self.lastPlayBG then
        if self.isMuteBG then
            self:_muteBg(true);
        else
            self:_muteBg(false);    
        end
    else
        self:_muteBg(true);
    end
end

function _CSoundManager:SwitchTopBg()
    if #self.bgSounds<=1 then
        return false;
    end
    self:_pauseBg();
    self.bgSounds[#self.bgSounds] = self.bgSounds[#self.bgSounds-1];
    self.bgSounds[#self.bgSounds-1] = self.soundBG;
    self.soundBG = self.bgSounds[#self.bgSounds];
    self:_replayBG();
    self:_resumeBg();
    return true;
end

function _CSoundManager:ClearBgStack()
    local count = #self.bgSounds;
    for i=1,count do
        self.soundBGCacheItems[#self.soundBGCacheItems +1] = self.bgSounds[i];
        self.bgSounds[i]:Stop();
    end
    self.bgSounds = {};
    self.soundBG = nil;
end

return _CSoundManager;