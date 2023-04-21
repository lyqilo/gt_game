local _CSoundDefine = class("SoundDefine");
local iDCreator = ID_Creator(0);

local _Enum_SoundValue = {
    BG           = iDCreator(), --0 背景
    Dianqiu      = iDCreator(), --1 点球
    NormalBalance= iDCreator(), --2
    BigBalance   = iDCreator(), --3
    BallBalance  = iDCreator(), --4
    Lose         = iDCreator(), --5
    FreeBG       = iDCreator(), --6
    Shot         = iDCreator(), --7
    CupBalance   = iDCreator(), --8
    Bet          = iDCreator(), --9
    Start        = iDCreator(), --10
    FreeBalance  = iDCreator(), --11
    EnterBallGame= iDCreator(), --12
    FlashFree    = iDCreator(), --13
    FlashCup     = iDCreator(), --14
    GetGold      = iDCreator(), --15
    PlayCup      = iDCreator(), --16 --播放大力神杯
    FreeBalance  = iDCreator(), --17 --免费结算
    Scroll       = iDCreator(), --18 --转动
    QuickScroll  = iDCreator(), --19 --快速转动
};
local ES = _Enum_SoundValue;

local soundObjName = {
    [ES.BG                      ] = {name = "normalBG",             abName = nil,},
    [ES.Dianqiu                 ] = {name = "dianqiu",              abName = nil,},
    [ES.NormalBalance           ] = {name = "nbalance",             abName = nil,},
    [ES.BigBalance              ] = {name = "bbalance",             abName = nil,},
    [ES.BallBalance             ] = {name = "ballbalance",          abName = nil,},
    [ES.FreeBalance             ] = {name = "freebalance",          abName = nil,},
    [ES.Lose                    ] = {name = "losebalance",          abName = nil,},
    [ES.FreeBG                  ] = {name = "freeBG",               abName = nil,},
    [ES.Shot                    ] = {name = "shot",                 abName = nil,},
    [ES.CupBalance              ] = {name = "cupreward",            abName = nil,},
    [ES.Bet                     ] = {name = "bet",                  abName = nil,},
    [ES.Start                   ] = {name = "start",                abName = nil,},
    [ES.FlashFree               ] = {name = "flashfree",            abName = nil,},
    [ES.FlashCup                ] = {name = "flashcup",             abName = nil,},
    [ES.GetGold                 ] = {name = "getgold",              abName = nil,},
    [ES.PlayCup                 ] = {name = "playcup",              abName = nil,},
    [ES.Scroll                  ] = {name = "scroll",               abName = nil,},
    [ES.QuickScroll             ] = {name = "quickscroll",          abName = nil,},
    [ES.EnterBallGame           ] = {name = "dianqiu",              abName = nil,},
};


function _CSoundDefine.GetSoundData(index)
    index = index or _Enum_SoundValue.BG;
    return soundObjName[index];
end

function _CSoundDefine.GetSoundDataByString(name)
    return _CSoundDefine.GetSoundData(_Enum_SoundValue[name] or _Enum_SoundValue.BG); 
end

function _CSoundDefine.EnumSound()
    return _Enum_SoundValue;
end

return _CSoundDefine;