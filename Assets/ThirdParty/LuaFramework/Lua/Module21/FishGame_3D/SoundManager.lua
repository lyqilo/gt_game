--local _CSoundManager = class("_CSoundManager");
local _CSoundManager = class();
--对应c#里的InitControl
--GameScenSoundControl

function _CSoundManager:ctor()
    self.transform = nil;
    self.audioClipTab = {};
end

function _CSoundManager:Init()
    local SoundDefine = G_GlobalGame.SoundDefine;
    self._musicObjName = {
        [SoundDefine.BG1         ] = {name = "bmg01",		abName = nil,},
        [SoundDefine.BG2         ] = {name = "bmg02",		abName = nil,},
        [SoundDefine.BG3         ] = {name = "bmg03",		abName = nil,},
        [SoundDefine.BG4         ] = {name = "bmg04",		abName = nil,},
        [SoundDefine.Bingo       ] = {name = "bingo",		abName = nil,},
        [SoundDefine.CantSwitch  ] = {name = "cannonSwitch",abName = nil,},
        [SoundDefine.Casting     ] = {name = "casting",		abName = nil,},
        [SoundDefine.Catch       ] = {name = "catch",		abName = nil,},
        [SoundDefine.Fire        ] = {name = "fire",		abName = nil,},
        [SoundDefine.Ion_Casting ] = {name = "casting",		abName = nil,},
        [SoundDefine.Ion_Catch   ] = {name = "ion_catch",	abName = nil,},
        [SoundDefine.Ion_Fire    ] = {name = "GunFire1",	abName = nil,},
        [SoundDefine.Ion_Get     ] = {name = "ChangeType",	abName = nil,},
        [SoundDefine.Lock        ] = {name = "lock",		abName = nil,},
        [SoundDefine.Silver      ] = {name = "silver",		abName = nil,},
        [SoundDefine.SuperArm    ] = {name = "jingbao",	    abName = nil,},
        [SoundDefine.Wave        ] = {name = "wave",		abName = nil,},
        [SoundDefine.ChangeScore ] = {name = "changescore",	abName = nil,},
        [SoundDefine.CatchFish_1 ] = {name = "01",		    abName = nil,},
        [SoundDefine.CatchFish_2 ] = {name = "02",		    abName = nil,},
        [SoundDefine.CatchFish_3 ] = {name = "03",		    abName = nil,},
        [SoundDefine.CatchFish_4 ] = {name = "04",		    abName = nil,},
        [SoundDefine.CatchFish_5 ] = {name = "05",		    abName = nil,},
        [SoundDefine.CatchFish_6 ] = {name = "06",		    abName = nil,},
        [SoundDefine.CatchFish_7 ] = {name = "07",		    abName = nil,},
        [SoundDefine.CatchFish_8 ] = {name = "08",		    abName = nil,},
        [SoundDefine.CatchFish_9 ] = {name = "09",		    abName = nil,},
        [SoundDefine.CatchFish_10] = {name = "10",		    abName = nil,},
        [SoundDefine.CatchFish_11] = {name = "11",		    abName = nil,},
        [SoundDefine.CatchFish_12] = {name = "12",		    abName = nil,},
        [SoundDefine.CatchFish_13] = {name = "13",		    abName = nil,},
        [SoundDefine.CatchFish_14] = {name = "14",		    abName = nil,},
        [SoundDefine.Bomb        ] = {name = "bomb",        abName = nil,},
        [SoundDefine.QuanPingBomb] = {name = "bomb",        abName = nil,},
        [SoundDefine.PauseBomb   ] = {name = "pauseBomb",	abName = nil,},
        [SoundDefine.HaiLang     ] = {name = "changescreen",abName = nil,},
        [SoundDefine.UpScore     ] = {name = "cannonSwitch",abName = nil,},
        [SoundDefine.ChangeScene ] = {name = "changescreen",abName = nil,},
        [SoundDefine.BigFishGold ] = {name = "dayuglod",  	abName = nil,},
        [SoundDefine.Coinsfly    ] = {name = "coinsfly",  	abName = nil,},
    };
end


function _CSoundManager:PlaySound(_id)
    local chip = self.audioClipTab[_id];
    if not chip then
        local musicObjName = self._musicObjName[_id];
        if musicObjName  and musicObjName.name then
            chip = G_GlobalGame_goFactory:getMusic(self._musicObjName[_id].name,self._musicObjName[_id].abName);
            self.audioClipTab[_id] = chip;
        end
    end
    if chip then
        MusicManager:PlayX(chip); 
    end
end

function _CSoundManager:PlayBgSound(_id)
    _id = _id or LKPY_SoundDefine.BG1;
    local chip = self.audioClipTab[_id];
    if not chip then
        local musicObjName = self._musicObjName[_id];
        if musicObjName  and musicObjName.name and musicObjName.abName then
            chip = G_GlobalGame_goFactory:getMusic(self._musicObjName[_id].name,self._musicObjName[_id].abName);
            self.audioClipTab[_id] = chip;
        end
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
        chip = G_GlobalGame_goFactory:getMusic(self._musicObjName[_id].name,self._musicObjName[_id].abName);
        self.audioClipTab[_id] = chip;
    end
--    if chip then
--        MusicManager:PlayBacksoundX(chip,true); 
--    end
    MusicManager:PlayBacksoundX(chip,false);
end

return _CSoundManager;