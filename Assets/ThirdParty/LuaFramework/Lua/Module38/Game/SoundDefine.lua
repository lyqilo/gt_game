local _CSoundDefine = class("SoundDefine");
local iDCreator = ID_Creator(0);

local _Enum_SoundValue = {
    BG = iDCreator(),
    QKDS         = iDCreator(),
    SRPZ         = iDCreator(),
    SXPM         = iDCreator(),
    TXWS         = iDCreator(),
    Btn          = iDCreator(),
    FreeBG       = iDCreator(),
    FlashIcon    = iDCreator(),
    FlashSepIcon = iDCreator(),
    FightBlock   = iDCreator(),
    BeginWar     = iDCreator(),
    DaiZi        = iDCreator(),
    FreeBalance  = iDCreator(),
    GetGold      = iDCreator(),
    AddFree      = iDCreator(),  --增加免费
    AddMultiple  = iDCreator(),  --增加倍率
    Scroll       = iDCreator(),  --转动
    QuickScroll  = iDCreator(),  --快速转动
    SepEffect    = iDCreator(),  --特殊音效
    ScrollStop   = iDCreator(),  --转动停止
};
local ES = _Enum_SoundValue;

local soundObjName = {
    [ES.BG                      ] = {name = "beijingputong",        abName = nil,},
    [ES.QKDS                    ] = {name = "qikaidesheng",         abName = nil,},
    [ES.SRPZ                    ] = {name = "shirupozhu",           abName = nil,},
    [ES.SXPM                    ] = {name = "suoxiangpimi",         abName = nil,},
    [ES.TXWS                    ] = {name = "tianxiawushuang",      abName = nil,},
    [ES.Btn                     ] = {name = "anniu",                abName = nil,},
    [ES.FreeBG                  ] = {name = "mianfeibeijing",       abName = nil,},
    [ES.FlashIcon               ] = {name = "tubiaoliangputong",    abName = nil,},
    [ES.FlashSepIcon            ] = {name = "jiangjun",             abName = nil,},
    [ES.AddFree                 ] = {name = "mianfeicishu",         abName = nil,},
    [ES.AddMultiple             ] = {name = "junshishengji",        abName = nil,},
    [ES.FightBlock              ] = {name = "zhanlinghuoqiu",       abName = nil,},
    [ES.BeginWar                ] = {name = "zhengzhankaishi",      abName = nil,},
    [ES.GetGold                 ] = {name = "jinbitiaodong",        abName = nil,},
    [ES.Scroll                  ] = {name = "scroll",               abName = nil,},
    [ES.QuickScroll             ] = {name = "quickscroll",          abName = nil,},
    [ES.SepEffect               ] = {name = "shajinbi",             abName = nil,},
    [ES.DaiZi                   ] = {name = "zhengzhandaizi",       abName = nil,},  
    [ES.ScrollStop              ] = {name = "zhuandongtingzhi",     abName = nil,},
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