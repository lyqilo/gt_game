using System.Collections.Generic;
using UnityEngine;

namespace Hotfix
{
    /// <summary>
    /// 游戏配置
    /// </summary>
    public class GameConfig
    {
        /*
         * 3-开心牛牛
         * 6-万炮捕鱼
         * 13-功夫熊猫
         * 16-纸牌老虎机
         * 17-楚河汉界
         * 18-水浒传
         * 19-21点
         * 20-百家乐
         * 22-水果777
         * 24-龙珠探宝（服务器待查证）
         * 25-草莓老虎机
         * 27-财神到
         * 28-福临门
         * 32-点球大战
         * 33-虎啸龙吟
         * 38-三国史记
         * 39-淘金者
         * 40-跳高高
         * 41-金瓶梅
         * 42-月光宝盒
         * 43-百人牛牛
         * 44-乐高大电影
         * 45-五龙争霸
         * 46-萌宠大作战
         * 47-幸运水果机
         * 48-福星高照
         * 49-武士斩杀
         * 50-上海滩
         * 51-水果小玛利（服务器待查证）
         * 52-十二生肖
         * 53-赛马
         * 54-埃及大冒险
         * 55-通比牛牛
         * 56-金属迎春
         * 57-冰球突破
         * 58-金猪送福
         * 59-竹子熊猫
         * 60-街舞
         * 61-偷窥
         * 62-亲朋捕鱼
         * 63-麻将胡了
         */
        private static List<GameData> GameDatas = new List<GameData>()
        {
            new GameData()
            {
                scenName = "module03", uiName = "开心牛牛", serverId = "21", clientId = 3,
                configer = GameModuleConfiger.GetModule("module03"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                rootName = "",
                Orientation = ScreenOrientation.Landscape,
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module05", uiName = "金蟾捕鱼", serverId = "21", clientId = 5,
                configer = GameModuleConfiger.GetModule("module05"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module06", uiName = "Deep Sea Fishing", serverId = "21", clientId = 6,
                configer = GameModuleConfiger.GetModule("module06"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { go.AddILComponent<WPBY.WPBYEntry>(); }
            },
            new GameData()
            {
                scenName = "module07", uiName = "李逵劈鱼", serverId = "21", clientId = 7,
                configer = GameModuleConfiger.GetModule("module07"),
                Orientation = ScreenOrientation.Landscape,
                BL = new List<string>(){"1", "10", "100", "10000"},
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module08", uiName = "飞禽走兽", serverId = "21", clientId = 9,
                configer = GameModuleConfiger.GetModule("module08"),
                Orientation = ScreenOrientation.Landscape,
                BL = new List<string>(){"1", "10", "100", "10000"},
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module13", uiName = "功夫熊猫", serverId = "21", clientId = 13,
                configer = GameModuleConfiger.GetModule("module13"),
                Orientation = ScreenOrientation.Landscape,
                BL = new List<string>(){"1", "10", "100", "10000"},
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module14", uiName = "白蛇传", serverId = "21", clientId = 14,
                configer = GameModuleConfiger.GetModule("module14"),
                Orientation = ScreenOrientation.Landscape,
                BL = new List<string>(){"1", "10", "100", "10000"},
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module16", uiName = "纸牌老虎机", serverId = "21", clientId = 16,
                configer = GameModuleConfiger.GetModule("module16"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module17", uiName = "楚河汉界", serverId = "21", clientId = 17,
                configer = GameModuleConfiger.GetModule("module17"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module18", uiName = "水浒传", serverId = "21", clientId = 18,
                configer = GameModuleConfiger.GetModule("module18"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module19", uiName = "Blackjack", serverId = "21", clientId = 19,
                configer = GameModuleConfiger.GetModule("module19"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module20", uiName = "Baccarat", serverId = "21", clientId = 20,
                configer = GameModuleConfiger.GetModule("module20"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module51", uiName = "Fruit Mary", serverId = "21", clientId = 21, otherClientId = 51,
                configer = GameModuleConfiger.GetModule("module51"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module22", uiName = "Fruit slot 777", serverId = "21", clientId = 22,
                configer = GameModuleConfiger.GetModule("module22"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                rootName = "SG777Entry",
                entry = go => { go.AddILComponent<SG777.SG777Entry>(); }
            },
            new GameData()
            {
                scenName = "module24", uiName = "Dragon Legend", serverId = "21", clientId = 8, otherClientId = 24,
                configer = GameModuleConfiger.GetModule("module24"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module25", uiName = "草莓老虎机", serverId = "21", clientId = 25,
                rootName = "CMLHJEntry",
                configer = GameModuleConfiger.GetModule("module25"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { go.AddILComponent<CMLHJ.CMLHJEntry>();}
            },
            new GameData()
            {
                scenName = "module27", uiName = "Fartune Gods", serverId = "21", clientId = 27,
                configer = GameModuleConfiger.GetModule("module27"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module28", uiName = "Fulinmen", serverId = "21", clientId = 28,
                configer = GameModuleConfiger.GetModule("module28"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => go.AddComponent<Fulinmen.UIEntry>()
            },
            new GameData()
            {
                scenName = "module32", uiName = "Soccer", serverId = "21", clientId = 32,
                configer = GameModuleConfiger.GetModule("module32"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module33", uiName = "DragonAndTiger", serverId = "21", clientId = 33,
                configer = GameModuleConfiger.GetModule("module33"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module38", uiName = "战国史记", serverId = "21", clientId = 38,
                configer = GameModuleConfiger.GetModule("module38"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module39", uiName = "Gold Digger", serverId = "21", clientId = 39,
                configer = GameModuleConfiger.GetModule("module39"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                rootName = "TJZEntry",
                entry = go => { go.AddILComponent<TJZ.TJZEntry>(); }
            },
            new GameData()
            {
                scenName = "module40", uiName = "High Jump", serverId = "21", clientId = 40,
                configer = GameModuleConfiger.GetModule("module40"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { go.AddILComponent<TGG.TGGEntry>(); }
            },
            new GameData()
            {
                scenName = "module41", uiName = "Pretty Bride", serverId = "21", clientId = 41,
                configer = GameModuleConfiger.GetModule("module41"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module42", uiName = "Moonlight Box", serverId = "21", clientId = 42,
                configer = GameModuleConfiger.GetModule("module42"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { go.AddILComponent<YGBH.YGBHEntry>(); }
            },
            new GameData()
            {
                scenName = "module43", uiName = "TBcattle vs100", serverId = "21", clientId = 43,rootName = "Game71Panel",
                configer = GameModuleConfiger.GetModule("module43"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module44", uiName = "Lego Movie", serverId = "21", clientId = 44,
                configer = GameModuleConfiger.GetModule("module44"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module45", uiName = "五龙争霸", serverId = "21", clientId = 45,
                configer = GameModuleConfiger.GetModule("module45"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module46", uiName = "萌宠大作战", serverId = "21", clientId = 46,
                configer = GameModuleConfiger.GetModule("module46"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module47", uiName = "幸运水果机", serverId = "21", clientId = 47,
                configer = GameModuleConfiger.GetModule("module47"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module48", uiName = "福星高照", serverId = "21", clientId = 48,
                configer = GameModuleConfiger.GetModule("module48"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module49", uiName = "Samurai", serverId = "21", clientId = 49,
                configer = GameModuleConfiger.GetModule("module49"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module50", uiName = "上海滩", serverId = "21", clientId = 50,
                configer = GameModuleConfiger.GetModule("module50"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module51", uiName = "Fruit Mary", serverId = "21", clientId = 51, otherClientId = 21,
                configer = GameModuleConfiger.GetModule("module51"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module52", uiName = "十二生肖", serverId = "21", clientId = 52,
                configer = GameModuleConfiger.GetModule("module52"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module53", uiName = "街机赛马", serverId = "21", clientId = 53,
                configer = GameModuleConfiger.GetModule("module53"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module54", uiName = "Egypt Treasure", serverId = "21", clientId = 54,
                configer = GameModuleConfiger.GetModule("module54"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module55", uiName = "TBcattle", serverId = "21", clientId = 55,
                configer = GameModuleConfiger.GetModule("module55"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module56", uiName = "金鼠迎春", serverId = "21", clientId = 56,
                configer = GameModuleConfiger.GetModule("module56"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module57", uiName = "Ice Hockey", serverId = "21", clientId = 57,
                configer = GameModuleConfiger.GetModule("module57"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => go.AddComponent<BQTP.UIEntry>()
            },
            new GameData()
            {
                scenName = "module58", uiName = "Golden piggy", serverId = "21", clientId = 58,
                configer = GameModuleConfiger.GetModule("module58"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module59", uiName = "Fortune Panda", serverId = "21", clientId = 59,
                configer = GameModuleConfiger.GetModule("module59"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => { }
            },
            new GameData()
            {
                scenName = "module60", uiName = "街头劲舞", serverId = "21", clientId = 60,
                configer = GameModuleConfiger.GetModule("module60"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => go.AddILComponent<JTJW.JWEntry>()
            },
            new GameData()
            {
                scenName = "module61", uiName = "Peeking", serverId = "21", clientId = 61,
                configer = GameModuleConfiger.GetModule("module61"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => go.AddILComponent<TouKui.TouKuiEntry>()
            },
            new GameData() //龙腾捕鱼
            {
                scenName = "module62", uiName = "3D Fishing", serverId = "21", clientId = 62,
                configer = GameModuleConfiger.GetModule("module62"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => go.AddILComponent<LTBY.LTBYEntry>()
            },
            
            new GameData()
            {
                scenName = "module63", uiName = "Mahjong ways", serverId = "21", clientId = 63,
                configer = GameModuleConfiger.GetModule("module63"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Portrait,
                entry = go => go.AddILComponent<MJHL.MJHLEntry>()
            },/*
            new GameData()
            {
                scenName = "module64", uiName = "龙虎风云", serverId = "21", clientId = 64,
                configer = GameModuleConfiger.GetModule("module64"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go =>{}
            },*/
            new GameData() //龙腾捕鱼
            {
                scenName = "module62", uiName = "3D Fishing", serverId = "21", clientId = 64,
                configer = GameModuleConfiger.GetModule("module62"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => go.AddILComponent<LTBY.LTBYEntry>()
            },
            new GameData()
            {
                scenName = "module65", uiName = "跳跳糖果", serverId = "21", clientId = 65,
                configer = GameModuleConfiger.GetModule("module65"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => go.AddILComponent<TiaoTiaoTangGuo.TTTGEntry>()
            },
            new GameData() //龙腾捕鱼
            {
                scenName = "module62", uiName = "3D Fishing", serverId = "21", clientId = 66,otherClientId = 62,
                configer = GameModuleConfiger.GetModule("module62"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => go.AddILComponent<LTBY.LTBYEntry>()
            },
            new GameData()
            {
                scenName = "module67", uiName = "神龙戏珠", serverId = "21", clientId = 67,
                configer = GameModuleConfiger.GetModule("module67"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => go.AddILComponent<TiaoTiaoTangGuo.TTTGEntry>()
            },
            new GameData()
            {
                scenName = "module68", uiName = "风情果园", serverId = "21", clientId = 68,
                configer = GameModuleConfiger.GetModule("module68"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => go.AddILComponent<TiaoTiaoTangGuo.TTTGEntry>()
            },
            new GameData()
            {
                scenName = "module69", uiName = "深海捕鱼", serverId = "21", clientId = 69,
                configer = GameModuleConfiger.GetModule("module69"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => go.AddILComponent<TiaoTiaoTangGuo.TTTGEntry>()
            },
            new GameData()
            {
                scenName = "module70", uiName = "玉蒲团", serverId = "21", clientId = 70,
                configer = GameModuleConfiger.GetModule("module70"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => go.AddILComponent<TiaoTiaoTangGuo.TTTGEntry>()
            },
            new GameData()
            {
                scenName = "module71", uiName = "愤怒的小鸟", serverId = "21", clientId = 71,
                configer = GameModuleConfiger.GetModule("module71"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => go.AddILComponent<TiaoTiaoTangGuo.TTTGEntry>()
            },
            new GameData()
            {
                scenName = "module72", uiName = "僵尸先生", serverId = "21", clientId = 72,
                configer = GameModuleConfiger.GetModule("module72"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => go.AddILComponent<TiaoTiaoTangGuo.TTTGEntry>()
            },
            new GameData()
            {
                scenName = "module73", uiName = "心动女主播", serverId = "21", clientId = 73,
                configer = GameModuleConfiger.GetModule("module73"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => go.AddILComponent<TiaoTiaoTangGuo.TTTGEntry>()
            },
            new GameData()
            {
                scenName = "module74", uiName = "炸金花", serverId = "21", clientId = 74,
                configer = GameModuleConfiger.GetModule("module74"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => go.AddILComponent<TiaoTiaoTangGuo.TTTGEntry>()
            },
            new GameData()
            {
                scenName = "module255", uiName = "敬请期待", serverId = "21", clientId = 255,
                configer = GameModuleConfiger.GetModule("module255"),
                BL = new List<string>(){"1", "10", "100", "10000"},
                Orientation = ScreenOrientation.Landscape,
                entry = go => go.AddILComponent<TiaoTiaoTangGuo.TTTGEntry>()
            },
        };

        /// <summary>
        /// 通过游戏id获取配置
        /// </summary>
        /// <param name="gameId">游戏id</param>
        /// <returns></returns>
        public static GameData GetGameData(int gameId)
        {
            GameData gameData = GameDatas.FindItem(data => data.clientId == gameId);
            if (gameData == null) gameData = GameDatas.FindItem(data => data.otherClientId == gameId);
            return gameData;
        }

        /// <summary>
        /// 根据游戏场景名获取
        /// </summary>
        /// <param name="sceneName">游戏场景名</param>
        /// <returns></returns>
        public static GameData GetGameData(string sceneName)
        {
            GameData gameData = GameDatas.FindItem(data => data.scenName == sceneName);
            return gameData;
        }
    }

    public class GameData
    {
        public int clientId;
        public int otherClientId;
        public ModuleConfiger configer;
        public CAction<GameObject> entry;
        public string rootName;
        public string scenName;
        public string serverId;
        public string uiName;
        public ScreenOrientation Orientation;
        public List<string> BL;
    }

    public class GameModuleConfiger
    {
        /// <summary>
        /// 获取配置
        /// </summary>
        /// <param name="moduleName">模块名</param>
        /// <returns></returns>
        public static ModuleConfiger GetModule(string moduleName)
        {
            ModuleConfiger configer;
            return gameDic.TryGetValue(moduleName, out configer) ? configer : null;
        }

        public static Dictionary<string, ModuleConfiger> gameDic = new Dictionary<string, ModuleConfiger>()
        {
            {
                "module03", new ModuleConfiger()
                {
                    luaPath = "Module03.NiuNiu.Module03Panel",
                    luaRootName = "Module03Panel",
                    driveType = ScriptType.Lua,
                    gameName = "抢庄牛牛",
                    uiName = "抢庄牛牛",
                    downFiles = new List<string>()
                    {
                        "module03",
                    },
                }
            },

            {
                "module05", new ModuleConfiger()
                {
                    luaPath = "Module05.ToadFish.MainPanel",
                    luaRootName = "MainPanel",
                    driveType = ScriptType.Lua,
                    gameName = "金蟾捕鱼",
                    uiName = "金蟾捕鱼",
                    downFiles = new List<string>()
                    {
                        "module05/game_toadfish_music.unity3d",
                        "module05/module05.unity3d",
                        "module05/game_toadfish_music.unity3d.manifest",
                    },
                }
            },

            {
                "module06", new ModuleConfiger()
                {
                    luaPath = "Module06.OneWPBY.OneWPBYEntry",
                    luaRootName = "OneWPBYEntry",
                    driveType = ScriptType.Lua,
                    gameName = "Deep Sea Fishing",
                    uiName = "Deep Sea Fishing",
                    downFiles = new List<string>()
                    {
                        "module06",
                    },
                }
            },

            {
                "module07", new ModuleConfiger()
                {
                    luaPath = "Module07.FishGame_LKPY.MainPanel",
                    luaRootName = "MainPanel",
                    driveType = ScriptType.Lua,
                    gameName = "李逵劈鱼",
                    uiName = "李逵劈鱼",
                    downFiles = new List<string>()
                    {
                        "module07/game_lkpy2_music.unity3d",
                        "module07/game_lkpy2_music.unity3d.manifest",
                        "module07/module07.unity3d",
                    },
                }
            },

            {
                "module08", new ModuleConfiger()
                {
                    luaPath = "Module08.jinandyinsha.jinandyinsha_initProt",
                    luaRootName = "jinandyinsha_initProt",
                    driveType = ScriptType.Lua,
                    gameName = "飞禽走兽",
                    uiName = "飞禽走兽",
                    downFiles = new List<string>()
                    {
                        "module08/game_birdsandbeast_gez.unity3d",
                        "module08/game_birdsandbeast_huoz.unity3d",
                        "module08/game_birdsandbeast_jingsha.unity3d",
                        "module08/game_birdsandbeast_kongq.unity3d",
                        "module08/game_birdsandbeast_laoy.unity3d",
                        "module08/game_birdsandbeast_shiz.unity3d",
                        "module08/game_birdsandbeast_tuz.unity3d",
                        "module08/game_birdsandbeast_xiongm.unity3d",
                        "module08/game_birdsandbeast_yaz.unity3d",
                        "module08/game_birdsandbeast_yingsha.unity3d",
                        "module08/game_birdsandbeast_gez.unity3d.manifest",
                        "module08/game_birdsandbeast_huoz.unity3d.manifest",
                        "module08/game_birdsandbeast_jingsha.unity3d.manifest",
                        "module08/game_birdsandbeast_kongq.unity3d.manifest",
                        "module08/game_birdsandbeast_laoy.unity3d.manifest",
                        "module08/game_birdsandbeast_shiz.unity3d.manifest",
                        "module08/game_birdsandbeast_tuz.unity3d.manifest",
                        "module08/game_birdsandbeast_xiongm.unity3d.manifest",
                        "module08/game_birdsandbeast_yaz.unity3d.manifest",
                        "module08/game_birdsandbeast_yingsha.unity3d.manifest",
                        "module08/module08.unity3d",
                    },
                }
            },

            {
                "module13", new ModuleConfiger()
                {
                    luaPath = "Module13.gfxm.Module13Entry",
                    luaRootName = "Module13Entry",
                    driveType = ScriptType.Lua,
                    gameName = "功夫熊猫",
                    uiName = "功夫熊猫",
                    downFiles = new List<string>()
                    {
                        "module13",
                    },
                }
            },

            {
                "module14", new ModuleConfiger()
                {
                    luaPath = "Module14.WhiteSnakeFish.MainPanel",
                    luaRootName = "MainPanel",
                    driveType = ScriptType.Lua,
                    gameName = "白蛇传",
                    uiName = "白蛇传",
                    downFiles = new List<string>()
                    {
                        "module14/game_white_snake_music.unity3d",
                        "module14/module14.unity3d",
                        "module14/game_white_snake_music.unity3d.manifest",
                    },
                }
            },

            {
                "module16", new ModuleConfiger()
                {
                    luaPath = "Module16.ZhiPai.Module16Entry",
                    luaRootName = "Module16Entry",
                    driveType = ScriptType.Lua,
                    gameName = "纸牌老虎机",
                    uiName = "纸牌老虎机",
                    downFiles = new List<string>()
                    {
                        "module16",
                    },
                }
            },

            {
                "module17", new ModuleConfiger()
                {
                    luaPath = "Module17.xiangqi.xiangqi_InitProt",
                    luaRootName = "xiangqi_InitProt",
                    driveType = ScriptType.Lua,
                    gameName = "楚河汉界",
                    uiName = "楚河汉界",
                    downFiles = new List<string>()
                    {
                        "module17",
                    },
                }
            },

            {
                "module18", new ModuleConfiger()
                {
                    luaPath = "Module18.SHZ.shzpanel",
                    luaRootName = "SHZPanel",
                    driveType = ScriptType.Lua,
                    gameName = "水浒传",
                    uiName = "水浒传",
                    downFiles = new List<string>()
                    {
                        "module18",
                    },
                }
            },

            {
                "module19", new ModuleConfiger()
                {
                    luaPath = "Module19.Point21_2D.Point21ScenCtrlPanel",
                    luaRootName = "Point21ScenCtrlPanel",
                    driveType = ScriptType.Lua,
                    gameName = "Blackjack",
                    uiName = "Blackjack",
                    downFiles = new List<string>()
                    {
                        "module19",
                    },
                }
            },

            {
                "module20", new ModuleConfiger()
                {
                    luaPath = "Module20.Game_Baccara.MainPanel",
                    luaRootName = "MainPanel",
                    driveType = ScriptType.Lua,
                    gameName = "Baccarat",
                    uiName = "Baccarat",
                    downFiles = new List<string>()
                    {
                        "module20",
                    },
                }
            },

            {
                "module21", new ModuleConfiger()
                {
                    luaPath = "Module21.FishGame_3D.MainPanel",
                    luaRootName = "MainPanel",
                    driveType = ScriptType.Lua,
                    gameName = "3D捕鱼",
                    uiName = "3D捕鱼",
                    downFiles = new List<string>()
                    {
                        "module21",
                    },
                }
            },

            {
                "module22", new ModuleConfiger()
                {
                    luaPath = "Module22.fruitsslot.Game22Panel",
                    luaRootName = "SG777Entry",
                    driveType = ScriptType.ILRuntime,
                    gameName = "Fruit slot 777",
                    uiName = "Fruit slot 777",
                    downFiles = new List<string>()
                    {
                        "module22",
                    },
                }
            },

            {
                "module24", new ModuleConfiger()
                {
                    luaPath = "Module24.SerialIndiana.MainPanel",
                    luaRootName = "MainPanel",
                    driveType = ScriptType.Lua,
                    gameName = "Dragon Legend",
                    uiName = "Dragon Legend",
                    downFiles = new List<string>()
                    {
                        "module24",
                    },
                }
            },

            {
                "module25", new ModuleConfiger()
                {
                    luaPath = "Module25.Strawberry.Strawberry_Scen",
                    luaRootName = "Strawberry_Scen",
                    driveType = ScriptType.ILRuntime,
                    gameName = "草莓老虎机",
                    uiName = "草莓老虎机",
                    downFiles = new List<string>()
                    {
                        "module25",
                    },
                }
            },

            {
                "module27", new ModuleConfiger()
                {
                    luaPath = "Module27.CaiShenDao.Module27Entry",
                    luaRootName = "Module27Entry",
                    driveType = ScriptType.Lua,
                    gameName = "Fartune Gods",
                    uiName = "Fartune Gods",
                    downFiles = new List<string>()
                    {
                        "module27",
                    },
                }
            },

            {
                "module28", new ModuleConfiger()
                {
                    luaPath = "Module28.fulinmen.FLMEntry",
                    luaRootName = "FLMEntry",
                    driveType = ScriptType.ILRuntime,
                    gameName = "Fulinmen",
                    uiName = "Fulinmen",
                    downFiles = new List<string>()
                    {
                        "module28",
                    },
                }
            },

            {
                "module32", new ModuleConfiger()
                {
                    luaPath = "Module32.Football.MainPanel",
                    luaRootName = "MainPanel",
                    driveType = ScriptType.Lua,
                    gameName = "Soccer",
                    uiName = "Soccer",
                    downFiles = new List<string>()
                    {
                        "module32",
                    },
                }
            },

            {
                "module33", new ModuleConfiger()
                {
                    luaPath = "Module33.longhudou.longhudou_InitProt",
                    luaRootName = "longhudou_InitProt",
                    driveType = ScriptType.Lua,
                    gameName = "DragonAndTiger",
                    uiName = "DragonAndTiger",
                    downFiles = new List<string>()
                    {
                        "module33",
                    },
                }
            },

            {
                "module38", new ModuleConfiger()
                {
                    luaPath = "Module38.Game.MainPanel",
                    luaRootName = "MainPanel",
                    driveType = ScriptType.Lua,
                    gameName = "战国史记",
                    uiName = "战国史记",
                    downFiles = new List<string>()
                    {
                        "module38",
                    },
                }
            },

            {
                "module39", new ModuleConfiger()
                {
                    luaPath = "Module39.tjz.tjz_InitProt",
                    luaRootName = "tjz_InitProt",
                    driveType = ScriptType.ILRuntime,
                    gameName = "Gold Digger",
                    uiName = "Gold Digger",
                    downFiles = new List<string>()
                    {
                        "module39",
                    },
                }
            },

            {
                "module40", new ModuleConfiger()
                {
                    luaPath = "Module40.tgg.TGGEntry",
                    luaRootName = "TGGEntry",
                    driveType = ScriptType.ILRuntime,
                    gameName = "High Jump",
                    uiName = "High Jump",
                    downFiles = new List<string>()
                    {
                        "module40",
                    },
                }
            },

            {
                "module41", new ModuleConfiger()
                {
                    luaPath = "Module41.jpm.JPMEntry",
                    luaRootName = "JPMEntry",
                    driveType = ScriptType.Lua,
                    gameName = "Pretty Bride",
                    uiName = "Pretty Bride",
                    downFiles = new List<string>()
                    {
                        "module41",
                    },
                }
            },

            {
                "module42", new ModuleConfiger()
                {
                    luaPath = "Module42.ygbh.YGBHEntry",
                    luaRootName = "YGBHEntry",
                    driveType = ScriptType.ILRuntime,
                    gameName = "Moonlight Box",
                    uiName = "Moonlight Box",
                    downFiles = new List<string>()
                    {
                        "module42",
                    },
                }
            },

            {
                "module43", new ModuleConfiger()
                {
                    luaPath = "Module43.Code.Game71Panel",
                    luaRootName = "Game71Panel",
                    driveType = ScriptType.Lua,
                    gameName = "TBcattle vs100",
                    uiName = "TBcattle vs100",
                    downFiles = new List<string>()
                    {
                        "module43",
                    },
                }
            },

            {
                "module44", new ModuleConfiger()
                {
                    luaPath = "Module44.LGDDY.LGDDYEntry",
                    luaRootName = "LGDDYEntry",
                    driveType = ScriptType.Lua,
                    gameName = "Lego Movie",
                    uiName = "Lego Movie",
                    downFiles = new List<string>()
                    {
                        "module44",
                    },
                }
            },

            {
                "module45", new ModuleConfiger()
                {
                    luaPath = "Module45.wlzb.WLZBEntry",
                    luaRootName = "WLZBEntry",
                    driveType = ScriptType.Lua,
                    gameName = "五龙争霸",
                    uiName = "五龙争霸",
                    downFiles = new List<string>()
                    {
                        "module45",
                    },
                }
            },

            {
                "module46", new ModuleConfiger()
                {
                    luaPath = "Module46.MCDZZ.MCDZZEntry",
                    luaRootName = "MCDZZEntry",
                    driveType = ScriptType.Lua,
                    gameName = "萌宠大作战",
                    uiName = "萌宠大作战",
                    downFiles = new List<string>()
                    {
                        "module46",
                    },
                }
            },

            {
                "module47", new ModuleConfiger()
                {
                    luaPath = "Module47.XYSGJ.XYSGJEntry",
                    luaRootName = "XYSGJEntry",
                    driveType = ScriptType.Lua,
                    gameName = "幸运水果机",
                    uiName = "幸运水果机",
                    downFiles = new List<string>()
                    {
                        "module47",
                    },
                }
            },

            {
                "module48", new ModuleConfiger()
                {
                    luaPath = "Module48.fxgz.FXGZEntry",
                    luaRootName = "FXGZEntry",
                    driveType = ScriptType.Lua,
                    gameName = "福星高照",
                    uiName = "福星高照",
                    downFiles = new List<string>()
                    {
                        "module48",
                    },
                }
            },

            {
                "module49", new ModuleConfiger()
                {
                    luaPath = "Module49.wszs.WSZSEntry",
                    luaRootName = "WSZSEntry",
                    driveType = ScriptType.Lua,
                    gameName = "Samurai",
                    uiName = "Samurai",
                    downFiles = new List<string>()
                    {
                        "module49",
                    },
                }
            },

            {
                "module50", new ModuleConfiger()
                {
                    luaPath = "Module50.sht.SHTEntry",
                    luaRootName = "SHTEntry",
                    driveType = ScriptType.Lua,
                    gameName = "上海滩",
                    uiName = "上海滩",
                    downFiles = new List<string>()
                    {
                        "module50",
                    },
                }
            },

            {
                "module51", new ModuleConfiger()
                {
                    luaPath = "Module51.SGXML.SGXMLEntry",
                    luaRootName = "SGXMLEntry",
                    driveType = ScriptType.Lua,
                    gameName = "Fruit Mary",
                    uiName = "Fruit Mary",
                    downFiles = new List<string>()
                    {
                        "module51",
                    },
                }
            },

            {
                "module52", new ModuleConfiger()
                {
                    luaPath = "Module52.SESX.SESXEntry",
                    luaRootName = "SESXEntry",
                    driveType = ScriptType.Lua,
                    gameName = "十二生肖",
                    uiName = "十二生肖",
                    downFiles = new List<string>()
                    {
                        "module52",
                    },
                }
            },

            {
                "module53", new ModuleConfiger()
                {
                    luaPath = "Module53.JJPM.JJPMEntry",
                    luaRootName = "JJPMEntry",
                    driveType = ScriptType.Lua,
                    gameName = "赛马",
                    uiName = "赛马",
                    downFiles = new List<string>()
                    {
                        "module53",
                    },
                }
            },

            {
                "module54", new ModuleConfiger()
                {
                    luaPath = "Module54.ajdmx.AJDMXEntry",
                    luaRootName = "AJDMXEntry",
                    driveType = ScriptType.Lua,
                    gameName = "Egypt Treasure",
                    uiName = "Egypt Treasure",
                    downFiles = new List<string>()
                    {
                        "module54",
                    },
                }
            },

            {
                "module55", new ModuleConfiger()
                {
                    luaPath = "Module55.niuniu.Module55Panel",
                    luaRootName = "Module55Panel",
                    driveType = ScriptType.Lua,
                    gameName = "TBcattle",
                    uiName = "TBcattle",
                    downFiles = new List<string>()
                    {
                        "module55",
                    },
                }
            },

            {
                "module56", new ModuleConfiger()
                {
                    luaPath = "Module56.JSYC.JSYCEntry",
                    luaRootName = "JSYCEntry",
                    driveType = ScriptType.Lua,
                    gameName = "金鼠迎春",
                    uiName = "金鼠迎春",
                    downFiles = new List<string>()
                    {
                        "module56",
                    },
                }
            },

            {
                "module57", new ModuleConfiger()
                {
                    luaPath = "Module57.BQTP.BQTPEntry",
                    luaRootName = "BQTPEntry",
                    driveType = ScriptType.ILRuntime,
                    gameName = "Ice Hockey",
                    uiName = "Ice Hockey",
                    downFiles = new List<string>()
                    {
                        "module57",
                    },
                }
            },

            {
                "module58", new ModuleConfiger()
                {
                    luaPath = "Module58.JZSF.JZSFEntry",
                    luaRootName = "JZSFEntry",
                    driveType = ScriptType.Lua,
                    gameName = "Golden piggy",
                    uiName = "Golden piggy",
                    downFiles = new List<string>()
                    {
                        "module58",
                    },
                }
            },

            {
                "module59", new ModuleConfiger()
                {
                    luaPath = "Module59.XMZZ.XMZZEntry",
                    luaRootName = "XMZZEntry",
                    driveType = ScriptType.Lua,
                    gameName = "Fortune Panda",
                    uiName = "Fortune Panda",
                    downFiles = new List<string>()
                    {
                        "module59",
                    },
                }
            },

            {
                "module60", new ModuleConfiger()
                {
                    luaPath = "Module60.JTJW.JWEntry",
                    luaRootName = "JWEntry",
                    driveType = ScriptType.ILRuntime,
                    gameName = "街头劲舞",
                    uiName = "街头劲舞",
                    downFiles = new List<string>()
                    {
                        "module60",
                    },
                }
            },
            {
                "module61", new ModuleConfiger()
                {
                    luaPath = "Module61.TouKui.TouKuiEntry",
                    luaRootName = "TouKuiEntry",
                    driveType = ScriptType.ILRuntime,
                    gameName = "Peeking",
                    uiName = "Peeking",
                    downFiles = new List<string>()
                    {
                        "module61",
                    },
                }
            },
            {
                "module62", new ModuleConfiger() //龙腾捕鱼
                {
                    luaPath = "Module62",
                    luaRootName = "LTBYEntry",
                    driveType = ScriptType.ILRuntime,
                    gameName = "3D Fishing",
                    uiName = "3D Fishing",
                    downFiles = new List<string>()
                    {
                        "module62",
                        "prefab",
                    },
                }
            },
            
            {
                "module63", new ModuleConfiger() //龙腾捕鱼
                {
                    luaPath = "Module63",
                    luaRootName = "MJHLEntry",
                    driveType = ScriptType.ILRuntime,
                    gameName = "Mahjong ways",
                    uiName = "Mahjong ways",
                    downFiles = new List<string>()
                    {
                        "module63",
                    },
                }
            },
            {
                "module64", new ModuleConfiger()
                {
                    luaPath = "Module64.longhudou.longhudou_InitProt",
                    luaRootName = "longhudou_InitProt",
                    driveType = ScriptType.Lua,
                    gameName = "龙虎风云",
                    uiName = "龙虎风云",
                    downFiles = new List<string>()
                    {
                        "module64",
                    },
                }
            },
            {
                "module65", new ModuleConfiger() //龙腾捕鱼
                {
                    luaPath = "Module65",
                    luaRootName = "LTBYEntry",
                    driveType = ScriptType.ILRuntime,
                    gameName = "跳跳糖果",
                    uiName = "跳跳糖果",
                    downFiles = new List<string>()
                    {
                        "module62",
                        "prefab",
                    },
                }
            },
            {
                "module66", new ModuleConfiger() //龙腾捕鱼
                {
                    luaPath = "Module66",
                    luaRootName = "MainPanel",
                    driveType = ScriptType.Lua,
                    gameName = "夺宝奇兵",
                    uiName = "夺宝奇兵",
                    downFiles = new List<string>()
                    {
                        "module66",
                    },
                }
            },
            {
                "module67", new ModuleConfiger() //龙腾捕鱼
                {
                    luaPath = "Module67",
                    luaRootName = "LTBYEntry",
                    driveType = ScriptType.ILRuntime,
                    gameName = "神龙戏珠",
                    uiName = "神龙戏珠",
                    downFiles = new List<string>()
                    {
                        "module62",
                        "prefab",
                    },
                }
            },
            {
                "module68", new ModuleConfiger() //龙腾捕鱼
                {
                    luaPath = "Module68",
                    luaRootName = "LTBYEntry",
                    driveType = ScriptType.ILRuntime,
                    gameName = "风情果园",
                    uiName = "风情果园",
                    downFiles = new List<string>()
                    {
                        "module62",
                        "prefab",
                    },
                }
            },
            {
                "module69", new ModuleConfiger() //龙腾捕鱼
                {
                    luaPath = "Module69",
                    luaRootName = "LTBYEntry",
                    driveType = ScriptType.ILRuntime,
                    gameName = "深海捕鱼",
                    uiName = "深海捕鱼",
                    downFiles = new List<string>()
                    {
                        "module62",
                        "prefab",
                    },
                }
            },
            {
                "module70", new ModuleConfiger() //龙腾捕鱼
                {
                    luaPath = "Module70",
                    luaRootName = "LTBYEntry",
                    driveType = ScriptType.ILRuntime,
                    gameName = "玉蒲团",
                    uiName = "玉蒲团",
                    downFiles = new List<string>()
                    {
                        "module62",
                        "prefab",
                    },
                }
            },
            {
                "module71", new ModuleConfiger() //龙腾捕鱼
                {
                    luaPath = "Module71",
                    luaRootName = "LTBYEntry",
                    driveType = ScriptType.ILRuntime,
                    gameName = "愤怒的小鸟",
                    uiName = "愤怒的小鸟",
                    downFiles = new List<string>()
                    {
                        "module62",
                        "prefab",
                    },
                }
            },
            {
                "module72", new ModuleConfiger() //龙腾捕鱼
                {
                    luaPath = "Module72",
                    luaRootName = "LTBYEntry",
                    driveType = ScriptType.ILRuntime,
                    gameName = "僵尸先生",
                    uiName = "僵尸先生",
                    downFiles = new List<string>()
                    {
                        "module62",
                        "prefab",
                    },
                }
            },
            {
                "module73", new ModuleConfiger() //龙腾捕鱼
                {
                    luaPath = "Module73",
                    luaRootName = "LTBYEntry",
                    driveType = ScriptType.ILRuntime,
                    gameName = "心动女主播",
                    uiName = "心动女主播",
                    downFiles = new List<string>()
                    {
                        "module62",
                        "prefab",
                    },
                }
            },
            {
                "module74", new ModuleConfiger() //龙腾捕鱼
                {
                    luaPath = "Module74",
                    luaRootName = "LTBYEntry",
                    driveType = ScriptType.ILRuntime,
                    gameName = "炸金花",
                    uiName = "炸金花",
                    downFiles = new List<string>()
                    {
                        "module62",
                        "prefab",
                    },
                }
            },
            {
                "module255", new ModuleConfiger()
                {
                    luaPath = "Module255",
                    driveType = ScriptType.ILRuntime,
                    gameName = "敬请期待",
                    uiName = "敬请期待",
                    downFiles = new List<string>()
                    {
                        "module255",
                    },
                }
            },
        };

        public static ModuleConfiger GetGameConfiger(string name)
        {
            ModuleConfiger configer = null;
            gameDic.TryGetValue(name, out configer);
            return configer;
        }
    }

    public class ModuleConfiger
    {
        public string luaPath;
        public string luaRootName;
        public ScriptType driveType;
        public string gameName;
        public string uiName;
        public List<string> downFiles;
    }

    public enum ScriptType
    {
        None,
        Lua,
        ILRuntime
    }
}
