-- LaunchModuleConfiger.Layer =
-- {
--    _00frameModule="frameModule",
--    _01logonModule = "logonModule",
--    _02hallModule = "hallModule",
--    _03gameModule = "gameModule",
--    _04chatModule = "chatModule",
-- }

LaunchModuleConfiger = {}

LaunchModuleConfiger = {
    Module01 = {
        scenName = "module01",
        uiName = "logon",
        serverId = "21",
        clientId = -1,
        configer = function()
            local t
            if t ~= nil then
                return t
            end
            require "Configer/Module01"
            t = Module01Configer
            return t
        end
    },
    Module02 = {
        scenName = "module02",
        uiName = "大厅",
        serverId = "21",
        clientId = -2,
        configer = function()
            require "Module02/Module02"
            return Module02Configer
        end
    },
    Module03 = {
        scenName = "module03",
        uiName = "开心牛牛",
        serverId = "21",
        clientId = 3,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module03"
            return Module03Configer
        end
    },
    Module04 = {
        scenName = "module04",
        uiName = "万炮捕鱼",
        serverId = "21",
        clientId = 4,
        BL = { "1", "10", "100", "10000" },
        configer = function()
            require "Configer/Module04"
            return Module04Configer
        end
    },
    Module05 = {
        scenName = "module05",
        uiName = "金蟾捕鱼",
        serverId = "21",
        clientId = 5,
        BL = {"1:10", "1:1", "10:1", "50:1"},
        configer = function()
            require "Configer/Module05"
            return Module05Configer
        end
    },
    Module06 = {
        scenName = "module06",
        uiName = "万炮捕鱼",
        serverId = "21",
        clientId = 6,
        BL = { "1", "10", "100", "10000" },
        configer = function()
            require "Configer/Module06"
            return Module06Configer
        end
    },
    Module07 = {
        scenName = "module07",
        uiName = "万炮捕鱼",
        serverId = "21",
        clientId = 7,
        BL = {"1:10", "1:1", "1:10", "50:1"},
        configer = function()
            require "Configer/Module07"
            return Module07Configer
        end
    },
    Module08 = {
        scenName = "module08",
        uiName = "飞禽走兽",
        serverId = "21",
        clientId = 8,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module08"
            return Module08Configer
        end
    },
    Module09 = {
        scenName = "module09",
        uiName = "悟空闹海",
        serverId = "21",
        clientId = 9,
        BL = {"1", "10", "100", "1000", "10000"},
        configer = function()
            require "Configer/Module09"
            return Module09Configer
        end
    },
    Module10 = {
        scenName = "module10",
        uiName = "金龙赐福",
        serverId = "21",
        clientId = 10,
        BL = {"1", "10", "100", "1000", "10000"},
        configer = function()
            require "Configer/Module10"
            return Module10Configer
        end
    },
    Module11 = {
        scenName = "module11",
        uiName = "速度激情",
        serverId = "21",
        clientId = 11,
        BL = {"1", "10", "100", "1000", "10000"},
        configer = function()
            require "Configer/Module11"
            return Module11Configer
        end
    },
    Module12 = {
        scenName = "module12",
        uiName = "ATT连环炮",
        serverId = "21",
        clientId = 12,
        BL = {"1", "10", "100", "1000", "10000"},
        configer = function()
            require "Configer/Module12"
            return Module12Configer
        end
    },
    Module13 = {
        scenName = "module13",
        uiName = "功夫熊猫",
        serverId = "21",
        clientId = 13,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module13"
            return Module13Configer
        end
    },
    Module14 = {
        scenName = "module14",
        uiName = "白蛇传",
        serverId = "21",
        clientId = 14,
        BL = {"1:10", "1:1", "1:10", "50:1"},
        configer = function()
            require "Configer/Module14"
            return Module14Configer
        end
    },
    Module15 = {
        scenName = "module15",
        uiName = "新开心牛牛",
        serverId = "21",
        clientId = 15,
        BL = {"1", "10", "100", "1000", "10000"},
        configer = function()
            require "Configer/Module15"
            return Module15Configer
        end
    },
    Module16 = {
        scenName = "module16",
        uiName = "纸牌老虎机",
        serverId = "21",
        clientId = 16,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module16"
            return Module16Configer
        end
    },
    Module17 = {
        scenName = "module17",
        uiName = "楚河汉界",
        serverId = "21",
        clientId = 17,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module17"
            return Module17Configer
        end
    },
    Module18 = {
        scenName = "module18",
        uiName = "水浒传",
        serverId = "21",
        clientId = 18,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module18"
            return Module18Configer
        end
    },
    Module19 = {
        scenName = "module19",
        uiName = "决胜21点",
        serverId = "21",
        clientId = 19,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module19"
            return Module19Configer
        end
    },
    Module20 = {
        scenName = "module20",
        uiName = "百家乐",
        serverId = "21",
        clientId = 20,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module20"
            return Module20Configer
        end
    },
    Module21 = {
        scenName = "module21",
        uiName = "3D捕鱼",
        serverId = "21",
        clientId = 21,
        BL = {"10:1", "1:1", "10:1", "50:1"},
        configer = function()
            require "Configer/Module21"
            return Module21Configer
        end
    },
    Module22 = {
        scenName = "module22",
        uiName = "水果777",
        serverId = "21",
        clientId = 22,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module22"
            return Module22Configer
        end
    },
    Module23 = {
        scenName = "module23",
        uiName = "经典水果机",
        serverId = "21",
        clientId = 23,
        BL = {"1", "10", "100", "1000", "10000"},
        configer = function()
            require "Configer/Module23"
            return Module23Configer
        end
    },
    Module24 = {
        scenName = "module24",
        uiName = "龙珠探宝",
        serverId = "21",
        clientId = 24,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module24"
            return Module24Configer
        end
    },
    Module25 = {
        scenName = "module25",
        uiName = "草莓老虎机",
        serverId = "21",
        clientId = 25,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module25"
            return Module25Configer
        end
    },
    Module26 = {
        scenName = "module26",
        uiName = "抓鬼特工",
        serverId = "21",
        clientId = 26,
        BL = {"1", "10", "100", "1000", "10000"},
        configer = function()
            require "Configer/Module26"
            return Module26Configer
        end
    },
    Module27 = {
        scenName = "module27",
        uiName = "财神到",
        serverId = "21",
        clientId = 27,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module27"
            return Module27Configer
        end
    },
    Module28 = {
        scenName = "module28",
        uiName = "福临门",
        serverId = "21",
        clientId = 28,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module28"
            return Module28Configer
        end
    },
    Module29 = {
        scenName = "module29",
        uiName = "中国象棋",
        serverId = "21",
        clientId = 29,
        BL = {"1", "10", "100", "1000", "10000"},
        configer = function()
            require "Configer/Module29"
            return Module29Configer
        end
    },
    Module30 = {
        scenName = "module30",
        uiName = "森林舞会",
        serverId = "21",
        clientId = 30,
        BL = {"1", "10", "100", "1000", "10000"},
        configer = function()
            require "Configer/Module30"
            return Module30Configer
        end
    },
    Module31 = {
        scenName = "module31",
        uiName = "花开富贵",
        serverId = "21",
        clientId = 31,
        BL = {"1", "10", "100", "1000", "10000"},
        configer = function()
            require "Configer/Module31"
            return Module31Configer
        end
    },
    Module32 = {
        scenName = "module32",
        uiName = "点球大战",
        serverId = "21",
        clientId = 32,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module32"
            return Module32Configer
        end
    },
    Module33 = {
        scenName = "module33",
        uiName = "虎啸龙吟",
        serverId = "21",
        clientId = 33,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module33"
            return Module33Configer
        end
    },
    Module34 = {
        scenName = "module34",
        uiName = "摇钱树",
        serverId = "21",
        clientId = 34,
        BL = {"1", "10", "100", "1000", "10000"},
        configer = function()
            require "Configer/Module34"
            return Module34Configer
        end
    },
    Module35 = {
        scenName = "module35",
        uiName = "欢乐拉霸",
        serverId = "21",
        clientId = 35,
        BL = {"1", "10", "100", "1000", "10000"},
        configer = function()
            require "Configer/Module35"
            return Module35Configer
        end
    },
    Module36 = {
        scenName = "module36",
        uiName = "水果狂欢",
        serverId = "21",
        clientId = 36,
        BL = {"1", "10", "100", "1000", "10000"},
        configer = function()
            require "Configer/Module36"
            return Module36Configer
        end
    },
    Module37 = {
        scenName = "module37",
        uiName = "大海狂欢",
        serverId = "21",
        clientId = 37,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module37"
            return Module37Configer
        end
    },
    Module38 = {
        scenName = "module38",
        uiName = "战国史记",
        serverId = "21",
        clientId = 38,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module38"
            return Module38Configer
        end
    },
    Module39 = {
        scenName = "module39",
        uiName = "淘金者",
        serverId = "21",
        clientId = 39,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module39"
            return Module39Configer
        end
    },
    Module40 = {
        scenName = "module40",
        uiName = "跳高高",
        serverId = "21",
        clientId = 40,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module40"
            return Module40Configer
        end
    },
    Module41 = {
        scenName = "module41",
        uiName = "金瓶梅",
        serverId = "21",
        clientId = 41,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module41"
            return Module41Configer
        end
    },
    Module42 = {
        scenName = "module42",
        uiName = "月光宝盒",
        serverId = "21",
        clientId = 42,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module42"
            return Module42Configer
        end
    },
    Module43 = {
        scenName = "module43",
        uiName = "百人牛牛",
        serverId = "21",
        clientId = 43,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module43"
            return Module43Configer
        end
    },
    Module44 = {
        scenName = "module44",
        uiName = "乐高大电影",
        serverId = "21",
        clientId = 44,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module44"
            return Module44Configer
        end
    },
    Module45 = {
        scenName = "module45",
        uiName = "五龙争霸",
        serverId = "21",
        clientId = 45,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module45"
            return Module45Configer
        end
    },
    Module46 = {
        scenName = "module46",
        uiName = "萌宠大作战",
        serverId = "21",
        clientId = 46,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module46"
            return Module46Configer
        end
    },
    Module47 = {
        scenName = "module47",
        uiName = "幸运水果机",
        serverId = "21",
        clientId = 47,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module47"
            return Module47Configer
        end
    },
    Module48 = {
        scenName = "module48",
        uiName = "福星高照",
        serverId = "21",
        clientId = 48,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module48"
            return Module48Configer
        end
    },
    Module49 = {
        scenName = "module49",
        uiName = "武士斩杀",
        serverId = "21",
        clientId = 49,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module49"
            return Module49Configer
        end
    },
    Module50 = {
        scenName = "module50",
        uiName = "上海滩",
        serverId = "21",
        clientId = 50,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module50"
            return Module50Configer
        end
    },
    Module51 = {
        scenName = "module51",
        uiName = "水果小玛丽",
        serverId = "21",
        clientId = 51,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module51"
            return Module51Configer
        end
    },
    Module52 = {
        scenName = "module52",
        uiName = "十二生肖",
        serverId = "21",
        clientId = 52,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module52"
            return Module52Configer
        end
    },
    Module53 = {
        scenName = "module53",
        uiName = "街机赛马",
        serverId = "21",
        clientId = 53,
        BL = {"1", "10", "100", "10000"},
        configer = function()
            require "Configer/Module53"
            return Module53Configer
        end
    },
    Module54 = {
        scenName = "module54",
        uiName = "埃及大冒险",
        serverId = "21",
        clientId = 54,
        BL = { "1", "10", "100", "10000" },
        configer = function()
            require "Configer/Module54"
            return Module54Configer
        end
    },
    Module55 = {
        scenName = "module55",
        uiName = "通比牛牛",
        serverId = "21",
        clientId = 55,
        BL = { "1", "10", "100", "10000" },
        configer = function()
            require "Configer/Module55"
            return Module55Configer
        end
    },
    Module56 = {
        scenName = "module56",
        uiName = "金鼠迎春",
        serverId = "21",
        clientId = 56,
        BL = { "1", "10", "100", "10000" },
        configer = function()
            require "Configer/Module56"
            return Module56Configer
        end
    },
    Module57 = {
        scenName = "module57",
        uiName = "冰球突破",
        serverId = "21",
        clientId = 57,
        BL = { "1", "10", "100", "10000" },
        configer = function()
            require "Configer/Module57"
            return Module57Configer
        end
    },
    Module58 = {
        scenName = "module58",
        uiName = "金猪送福",
        serverId = "21",
        clientId = 58,
        BL = { "1", "10", "100", "10000" },
        configer = function()
            require "Configer/Module58"
            return Module58Configer
        end
    },
    Module59 = {
        scenName = "module59",
        uiName = "竹子熊猫",
        serverId = "21",
        clientId = 59,
        BL = { "1", "10", "100", "10000" },
        configer = function()
            require "Configer/Module59"
            return Module59Configer
        end
    },
    Module60 = {
        scenName = "module60",
        uiName = "街头劲舞",
        serverId = "21",
        clientId = 60,
        BL = { "1", "10", "100", "10000" },
        configer = function()
            require "Configer/Module60"
            return Module60Configer
        end
    },
    Module61 = {
        scenName = "module61",
        uiName = "偷窥",
        serverId = "21",
        clientId = 61,
        BL = { "1", "10", "100", "10000" },
        configer = function()
            require "Configer/Module61"
            return Module61Configer
        end
    },
    Module64 = {
        scenName = "module64",
        uiName = "龙虎争霸",
        serverId = "21",
        clientId = 64,
        BL = { "1", "10", "100", "10000" },
        configer = function()
            require "Configer/Module64"
            return Module64Configer
        end
    },
    Module255 = {
        scenName = "module255",
        uiName = "敬请期待",
        serverId = "21",
        clientId = 255,
        BL = { "1", "10", "100", "10000" },
        configer = function()
            require "Configer/Module255"
            return Module255Configer
        end
    },
}
