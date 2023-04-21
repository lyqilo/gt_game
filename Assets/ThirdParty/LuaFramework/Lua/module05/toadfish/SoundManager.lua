local _CSoundManager = class("_CSoundManager");
--对应c#里的InitControl
--GameScenSoundControl

function _CSoundManager:ctor()
    self.transform = nil;
    self.audioClipTab = {};
end

function _CSoundManager:Init()
    local SoundDefine = G_GlobalGame.SoundDefine;
    self._musicObjName = {
        [SoundDefine.BG1         ] = {name = "bgm1",            abName = nil,},
        [SoundDefine.BG2         ] = {name = "bgm2",            abName = nil,},
        [SoundDefine.BG3         ] = {name = "bgm3",            abName = nil,},
        [SoundDefine.BG4         ] = {name = "bgm4",            abName = nil,},
        [SoundDefine.Bingo       ] = {name = "bingo",           abName = nil,},
        [SoundDefine.CantSwitch  ] = {name = "cannonSwitch",    abName = nil,},
        [SoundDefine.Casting     ] = {name = "Net0",            abName = nil,},
        [SoundDefine.Catch       ] = {name = "Hit0",            abName = nil,},
        [SoundDefine.Fire        ] = {name = "GunFire0",     	abName = nil,},
        [SoundDefine.Ion_Casting ] = {name = "Net1",            abName = nil,},
        [SoundDefine.Ion_Catch   ] = {name = "ion_catch",       abName = nil,},
        [SoundDefine.Ion_Fire    ] = {name = "GunFire1",        abName = nil,},
        [SoundDefine.Ion_Get     ] = {name = "ion_get",         abName = nil,},
        [SoundDefine.Lock        ] = {name = "lock",            abName = nil,},
        [SoundDefine.Silver      ] = {name = "FlyCoin0",        abName = nil,},
        [SoundDefine.SuperArm    ] = {name = "superarm",        abName = nil,},
        [SoundDefine.Wave        ] = {name = "wave",            abName = nil,},
        [SoundDefine.ChangeScore ] = {name = "changescore",     abName = nil,},
        [SoundDefine.CatchFish_1 ] = {name = "Fish12",          abName = nil,},
        [SoundDefine.CatchFish_2 ] = {name = "Fish13",          abName = nil,},
        [SoundDefine.CatchFish_3 ] = {name = "Fish14",          abName = nil,},
        [SoundDefine.CatchFish_4 ] = {name = "Fish15",          abName = nil,},
        [SoundDefine.CatchFish_5 ] = {name = "Fish16",          abName = nil,},
        [SoundDefine.CatchFish_6 ] = {name = "Fish17",          abName = nil,},
        [SoundDefine.Bomb ]        = {name = "Bomb",            abName = nil,},
        [SoundDefine.HaiLang     ] = {name = "HaiLang",         abName = nil,},
        [SoundDefine.UpScore     ] = {name = "ChangeValue",     abName = nil,},
    };
end


function _CSoundManager:PlaySound(_id)
    local chip = self.audioClipTab[_id];
    if not chip then
        chip = G_GlobalGame._goFactory:getMusic(self._musicObjName[_id].name,self._musicObjName[_id].abName);
    end
    if chip then
        MusicManager:PlayX(chip); 
    end
end

function _CSoundManager:PlayBgSound(_id)
    _id = _id or LKPY_SoundDefine.BG1;
    local chip = self.audioClipTab[_id];
    if not chip then
        chip = G_GlobalGame._goFactory:getMusic(self._musicObjName[_id].name,self._musicObjName[_id].abName);
        self.audioClipTab[_id] = chip;
    end
    if chip then
        MusicManager:PlayBacksoundX(chip,true); 
    end
end

--停止背景音乐
function _CSoundManager:StopBgSound()
    _id = _id or LKPY_SoundDefine.BG1;
    local chip = self.audioClipTab[_id];
    if not chip then
        chip = G_GlobalGame._goFactory:getMusic(self._musicObjName[_id].name,self._musicObjName[_id].abName);
        self.audioClipTab[_id] = chip;
    end
--    if chip then
--        MusicManager:PlayBacksoundX(chip,true); 
--    end
    MusicManager:PlayBacksoundX(chip,false);
end

return _CSoundManager;