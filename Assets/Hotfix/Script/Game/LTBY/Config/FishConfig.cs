using System.Collections.Generic;
using UnityEngine;

namespace Hotfix.LTBY
{
    /// <summary>
    /// 鱼配置
    /// </summary>
    public class FishDataConfig
    {
        public int fishOrginType;
        public int fishType;
        public string ResName;
        public string fishName;
        public string fishScore;
        public bool specialFish;
        public string nameSuffix;
        public string des;
        public float previewCameraSize;
        public Vector2 previewOffset;
        public Vector3 previewRotation;
        public int previewPlayAnim;
        public bool previewForbidTouch;
        public bool isDialFish;
        public string broadcast;
        public string broadcastBg;
        public string broadcastBgBundle;
        public float fixedZ;
        public Color hitColor;
        public Color hitColor2D;
        public bool hitChange;
        public bool swinScale;
        public bool isLightFish;
        public float effectScale;
        public bool isCoinOutburstFish;
        public int explosionPointLevel;
        public bool isWhaleFish;
        public string fishHitSound;
        public string fishDeadSound;
        public string fishAppearSound;
        public bool isGlobefish;
        public List<Vector3> roadEulerAngle;
        public string fishDieSound;
        public bool is2D;
        public bool isAwardFish;
        public List<int> killList;
    }

    public class FishConfig
    {
        public const int fishCount = 36;

        public static readonly List<FishDataConfig> Fish = new List<FishDataConfig>()
        {
            new FishDataConfig()
            {
                fishType = 47,
                fishOrginType = 144,
                ResName = "fish_144",
                fishName = "Thunder Long",
                fishScore = "Random",
                specialFish = true,
                nameSuffix = "<color=#5EFF6DFF>（Special）</color>",
                des = "Profile：\nLegendary dragon, the power of thunder, with amazing power.Capture it<color=#FFCB25FF>will trigger the dragon play pearl, \"thunder \" attack the whole field</color>",
                previewCameraSize = 30,
                previewOffset = {x = 0, y = 5},
                previewRotation = {x = 60, y = 165, z = 0},
                previewPlayAnim = 15,
                previewForbidTouch = true,
                broadcast = "Thunder Long Coming",
                fixedZ = 190,
                hitColor = new Color(233, 89, 89, 255),
                fishAppearSound = "FishSound17",
                fishDieSound = "ElectricDragonDie",
                roadEulerAngle = new List<Vector3>()
                {
                    new Vector3(0, 0, 0),
                    new Vector3(25, 200, 0),
                    new Vector3(0, 180, 0),
                    new Vector3(0, 55, 0)
                },
            },
            new FishDataConfig()
            {
                fishType = 36,
                fishOrginType = 127,
                ResName = "fish_127",
                fishName = "Gold Toad",
                fishScore = "150",
                specialFish = true,
                nameSuffix = "<color=#5EFF6DFF>（Special）</color>",
                des = "Profile：\nThe sea of rich men, from head to toe have gold for jewelry.",
                previewCameraSize = 8.5f,
                hitColor = new Color(190, 122, 122, 255),
                explosionPointLevel = 2,
                fishHitSound = "FishSound14",
            },
            new FishDataConfig()
            {
                fishType = 35,
                fishOrginType = 125,
                ResName = "fish_125",
                fishName = "Hammer Shark",
                fishScore = "120",
                specialFish = true,
                nameSuffix = "<color=#5EFF6DFF>（Special）</color>",
                des = "Profile：\nSelf-proclaimed vegetarian, enjoys tasting seaweed and small fish.",
                previewCameraSize = 10,
                previewOffset = {x = 0, y = 1},
                hitColor = new Color(177, 120, 120, 255),
                hitColor2D = new Color(208, 101, 86, 255),
                explosionPointLevel = 2,
                fishDeadSound = "FishSound12",
                is2D = true,
            },
            new FishDataConfig()
            {
                fishType = 34,
                fishOrginType = 124,
                ResName = "fish_124",
                fishName = "Gold Shark",
                fishScore = "100",
                specialFish = true,
                nameSuffix = "<color=#5EFF6DFF>（Special）</color>",
                des = "Profile：\nIt is a relative of Jaws, but acts in a very high profile and likes to show off his battle achievements and gains.",
                previewCameraSize = 10,
                previewOffset = {x = 0, y = 0.5f},
                hitColor = new Color(194, 114, 114, 255),
                hitColor2D = new Color(238, 117, 96, 255),
                explosionPointLevel = 2,
                fishDeadSound = "FishSound15",
                is2D = true,
            },
            new FishDataConfig()
            {
                fishType = 33,
                fishOrginType = 121,
                ResName = "fish_121",
                fishName = "Gold Bomb Fish",
                fishScore = "55",
                specialFish = true,
                nameSuffix = "<color=#5EFF6DFF>（Special）</color>",
                des = "Profile：\nThe size is larger than the average bomb fish, and the mantra is that life is short.",
                previewCameraSize = 7,
                hitColor = new Color(194, 120, 120, 255),
                hitColor2D = new Color(246, 150, 98, 255),
                effectScale = 0.6f,
                is2D = true,
            },
            new FishDataConfig()
            {
                fishType = 32,
                fishOrginType = 131,
                ResName = "fish_131",
                fishName = "Treasure Oak",
                fishScore = "Random",
                specialFish = true,
                nameSuffix = "<color=#5EFF6DFF>（Special）</color>",
                des = "Profile：\nAfter being captured, there is a high probability of triggering the “gold explosion”.",
                previewCameraSize = 6,
                hitColor = new Color(199, 112, 112, 255),
                hitColor2D = new Color(249, 139, 123, 255),
                isCoinOutburstFish = true,
                fishHitSound = "FishSound3",
                is2D = false,
            },
            new FishDataConfig()
            {
                fishType = 31,
                fishOrginType = 136,
                ResName = "fish_136",
                fishName = "Golden Dragon",
                fishScore = "Up to 500x",
                specialFish = true,
                nameSuffix = "<color=#5EFF6DFF>（Special）</color>",
                des = "Profile：\nThe legendary beast, symbolizing good luck. Up to<color=#FFCB25FF>500 x reward after capture</color>",
                previewCameraSize = 30,
                previewOffset = {x = 0, y = 5},
                previewRotation = {x = 60, y = 165, z = 0},
                previewPlayAnim = 15,
                previewForbidTouch = true,
                broadcast = "Golden Dragon Coming",
                fixedZ = 190,
                hitColor = new Color(197, 166, 84, 255),
                fishAppearSound = "FishSound16",
                roadEulerAngle = new List<Vector3>()
                {
                    new Vector3(0, 0, 0),
                    new Vector3(0, 236, 0),
                    new Vector3(0, 180, 0),
                    new Vector3(0, 55, 0)
                },
            },
            new FishDataConfig()
            {
                fishType = 30,
                fishOrginType = 145,
                ResName = "fish_145",
                fishName = "Treasure bowl",
                fishScore = "Random",
                specialFish = true,
                nameSuffix = "<color=#5EFF6DFF>（Special）</color>",
                des = "Profile：\nLegendary treasures,<color=#FFCB25FF>the more level, the more accumulated treasures!</color>",
                previewCameraSize = 5,
                previewOffset = {x = 0, y = -0.9f},
                previewForbidTouch = true,
                broadcast = "Treasure bowl",
                broadcastBg = "JBP_BG",
                broadcastBgBundle = "res_effect2",
                previewRotation = {x = -90, y = 0, z = 0},
                fishAppearSound = "FishAppearSound145",
                fishHitSound = "FishSound3",
                hitColor = new Color(242, 116, 198, 255),
                fixedZ = -4,
            },
            new FishDataConfig()
            {
                fishOrginType = 141,
                fishType = 48,
                ResName = "fish_141",
                fishName = "Strange Crab",
                fishScore = "Special Bonus",
                specialFish = true,
                nameSuffix = "<color=#5EFF6DFF>（Special）</color>",
                des = "Profile：\nThe capture of a strange crab will trigger a 20-second free game.",
                previewCameraSize = 7,
                broadcast = "Strange Crab",
                fixedZ = 196,
                hitColor = new Color(111, 11, 11, 255),
                hitColor2D = new Color(246, 138, 110, 255),
                fishHitSound = "FishSound11",
                is2D = false,
            },/*
            new FishDataConfig()
            {
                fishType = 133,
                fishName = "Rocket Crab",
                fishScore = "Special Bonus",
                specialFish = true,
                nameSuffix = "<color=#5EFF6DFF>（Special）</color>",
                des = "Profile：\nAfter being caught, the "rockets" are launched throughout the fishing grounds.",
                previewCameraSize = 6,
                broadcast = "Rocket Crab",
                fixedZ = 196,
                hitColor = new Color(111, 11, 11, 255),
                hitColor2D = new Color(255, 142, 116, 255),
                fishHitSound = "FishSound11",
                is2D = false,
            },
            new FishDataConfig()
            {
                fishType = 134,
                fishName = "EM Crab",
                fishScore = "Special Bonus",
                specialFish = true,
                nameSuffix = "<color=#5EFF6DFF>（Special）</color>",
                des = "Profile：\nWhen captured, it will surrender its secret weapon, the " EMP ".",
                previewCameraSize = 6,
                broadcast = "EM Crab",
                fixedZ = 196,
                hitColor = new Color(94, 19, 19, 255),
                hitColor2D = new Color(249, 135, 116, 255),
                fishHitSound = "FishSound11",
                is2D = false,
            },*/
            new FishDataConfig()
            {
                fishType = 29,
                fishOrginType = 142,
                ResName = "fish_142",
                fishName = "Jackpot Oak",
                fishScore = "Random",
                specialFish = true,
                nameSuffix = "<color=#5EFF6DFF>（Special）</color>",
                des = "Profile：\nThe capture will trigger 3 “Spins”.<color=#FFCB25FF>Maximum 2000 x reward</color>",
                previewCameraSize = 10,
                broadcast = "Jackpot Oak",
                hitColor = new Color(199, 112, 112, 1),
                previewRotation = {x = -70, y = 90, z = 0},
                isDialFish = true,
                fishHitSound = "FishSound3",
            },
            // new FishDataConfig()
            // {
            //     fishType = 31,
            //     fishOrginType = 143,
            //     ResName = "fish_143_3",
            //     fishName = "All in One (Flying Fish)",
            //     fishScore = "Random",
            //     specialFish = true,
            //     nameSuffix = "<color=#5EFF6DFF>（Special）</color>",
            //     des = "Profile：\nCatch any of the fish marked with " all in one", the others will be caught.",
            //     hitColor = new Color(225,0,0,255),
            //     hitColor2D = new Color(246,94,90,255),
            //     previewCameraSize = 8.5f,
            //     previewRotation = { x = -90,y = 0,z = 0},
            // },
            // new FishDataConfig()
            // {
            //     fishType = 30,
            //     fishOrginType = 143,
            //     ResName = "fish_143_2",
            //     fishName = "All in One (Turtle)",
            //     fishScore = "Random",
            //     specialFish = true,
            //     nameSuffix = "<color=#5EFF6DFF>（Special）</color>",
            //     des = "Profile：\nCatch any of the fish marked with " all in one", the others will be caught.",
            //     hitColor = new Color(199,13,13,255),
            //     hitColor2D = new Color(255,124,98,255),
            //     previewCameraSize = 8.5f,
            //     previewRotation = { x = -90,y = 0,z = 0},
            // },
            // new FishDataConfig()
            // {
            //     fishType = 29,
            //     fishOrginType = 143,
            //     ResName = "fish_143_1",
            //     fishName = "All in One (Frog)",
            //     fishScore = "Random",
            //     specialFish = true,
            //     nameSuffix = "<color=#5EFF6DFF>（Special）</color>",
            //     des = "Profile：\nCatch any of the fish marked with " all in one", the others will be caught.",
            //     hitColor = new Color(107,28,28,255),
            //     hitColor2D = new Color(255,96,49,255),
            //     previewCameraSize = 8.5f,
            //     previewRotation = { x = -90,y = 0,z = 0},
            // },
            new FishDataConfig()
            {
                fishType = 143,
                fishOrginType = 143,
                ResName = "fish_143",
                fishName = "All in One",
                fishScore = "Random",
                specialFish = true,
                nameSuffix = "<color=#5EFF6DFF>（Special）</color>",
                des = "Profile：\nCatch any of the fish marked with “all in one”, the others will be caught.",
                hitColor = new Color(107, 128, 128, 255),
                hitColor2D = new Color(255, 96, 49, 255),
                previewCameraSize = 8.5f,
                previewRotation = {x = -90, y = 0, z = 0},
            },
            new FishDataConfig()
            {
                fishType = 28,
                fishOrginType = 132,
                ResName = "fish_132",
                fishName = "Flash eel",
                fishScore = "Random",
                specialFish = true,
                nameSuffix = "<color=#5EFF6DFF>（Special）</color>",
                des = "Profile：\nChance to trigger the lightning chain.",
                previewCameraSize = 7,
                broadcast = "Flash eel",
                hitColor = new Color(124, 118, 118, 255),
                hitColor2D = new Color(233, 102, 68, 255),
                isLightFish = true,
                is2D = true,
                killList = new List<int>() {1, 2, 3, 4, 5, 6, 7}
            },
            new FishDataConfig()
            {
                fishType = 27,
                fishOrginType = 139,
                ResName = "fish_139",
                fishName = "Flash Butterfly",
                fishScore = "Random",
                specialFish = true,
                nameSuffix = "<color=#5EFF6DFF>（Special）</color>",
                des = "Profile：\nThe butterfly fish in the vicinity will suffer after being caught.",
                previewCameraSize = 4.5f,
                hitColor = new Color(124, 118, 118, 255),
                hitColor2D = new Color(255, 152, 105, 255),
                isLightFish = true,
                is2D = true,
                killList = new List<int>() {2}
            },
            new FishDataConfig()
            {
                fishType = 26,
                fishOrginType = 140,
                ResName = "fish_140",
                fishName = "Flash Dragonfly",
                fishScore = "Random",
                specialFish = true,
                nameSuffix = "<color=#5EFF6DFF>（Special）</color>",
                des = "Profile：\nThe Dragonfly fish in the vicinity will suffer after being caught.",
                previewCameraSize = 4.5f,
                hitColor = new Color(124, 118, 118, 255),
                hitColor2D = new Color(249, 116, 81, 255),
                isLightFish = true,
                is2D = true,
                killList = new List<int>() {1}
            },
            new FishDataConfig()
            {
                fishType = 25,
                fishOrginType = 109,
                ResName = "fish_109",
                fishName = "Angry Blowfish",
                fishScore = "10-100",
                specialFish = true,
                nameSuffix = "<color=#5EFF6DFF>（Special）</color>",
                des = "Profile：\nAfter being captured, the size will become bigger and the score will become higher.",
                previewCameraSize = 6,
                hitColor = new Color(118, 124, 124, 255),
                swinScale = true,
                effectScale = 0.4f,
                fishHitSound = "FishSound4",
                fishDeadSound = "FishSound5",
                isGlobefish = true,
                is2D = false,
            },
            new FishDataConfig()
            {
                fishType = 24,
                fishOrginType = 128,
                ResName = "fish_128",
                fishName = "Deep Whale",
                fishScore = "300",
                specialFish = false,
                nameSuffix = "<color=#5EFF6DFF>（Normal）</color>",
                des = "Profile：\nDeep sea overlord, huge size.",
                previewCameraSize = 25,
                previewOffset = {x = 0, y = 0},
                broadcast = "Deep Whale",
                fixedZ = 130,
                hitColor = new Color(188, 157, 157, 255),
                hitChange = true,
                explosionPointLevel = 3,
                isWhaleFish = true,
            },
            new FishDataConfig()
            {
                fishType = 23,
                fishOrginType = 129,
                ResName = "fish_129",
                fishName = "Mermaid",
                fishScore = "100-150",
                specialFish = false,
                nameSuffix = "<color=#5EFF6DFF>（Normal）</color>",
                des = "Profile：\nElf mermaid in the fairy tale world.",
                previewCameraSize = 10,
                previewOffset = {x = 0, y = 0},
                hitColor = new Color(201, 135, 135, 255),
                explosionPointLevel = 2,
                hitChange = true,
                fishDeadSound = "FishSound2",
                fishHitSound = "FishSound7",
                is2D = false,
            },
            new FishDataConfig()
            {
                fishType = 22,
                fishOrginType = 126,
                ResName = "fish_126",
                fishName = "Killer whales",
                fishScore = "90",
                specialFish = false,
                nameSuffix = "<color=#5EFF6DFF>（Normal）</color>",
                des = "Profile：\nIt always makes you think it is an island when you are sunbathing.",
                previewCameraSize = 10,
                previewOffset = {x = 0, y = 0},
                hitColor = new Color(182, 120, 120, 255),
                hitColor2D = new Color(255, 186, 163, 255),
                explosionPointLevel = 2,
                fishHitSound = "FishSound8",
                fishDeadSound = "FishSound6",
                is2D = true,
            },
            new FishDataConfig()
            {
                fishType = 21,
                fishOrginType = 123,
                ResName = "fish_123",
                fishName = "Jaws",
                fishScore = "80",
                specialFish = false,
                nameSuffix = "<color=#5EFF6DFF>（Normal）</color>",
                des = "Profile：\nThere are countless legends about him.",
                previewCameraSize = 8,
                hitColor = new Color(255, 120, 120, 255),
                hitColor2D = new Color(242, 142, 128, 255),
                explosionPointLevel = 2,
                fishHitSound = "FishSound9",
                fishDeadSound = "FishSound10",
                is2D = true,
            },
            new FishDataConfig()
            {
                fishType = 20,
                fishOrginType = 113,
                ResName = "fish_113",
                fishName = "Lobster",
                fishScore = "68",
                specialFish = false,
                nameSuffix = "<color=#5EFF6DFF>（Normal）</color>",
                des = "Profile：\nIt is very adaptable and its greatest pleasure is to have adventures.",
                previewCameraSize = 8,
                hitColor = new Color(198, 120, 120, 255),
                hitColor2D = new Color(244, 153, 70, 255),
                effectScale = 1,
                is2D = false,
            },
            new FishDataConfig()
            {
                fishType = 19,
                fishOrginType = 122,
                ResName = "fish_122",
                fishName = "Stingray",
                fishScore = "60",
                specialFish = false,
                nameSuffix = "<color=#5EFF6DFF>（Normal）</color>",
                des = "Profile：\nThe shape looks very intimidating, but in fact the guts are very small.",
                previewCameraSize = 6,
                hitColor = new Color(150, 120, 120, 255),
                effectScale = 1,
                hitChange = true,
                is2D = false,
            },
            new FishDataConfig()
            {
                fishType = 18,
                fishOrginType = 119,
                ResName = "fish_119",
                fishName = "Lanternfish",
                fishScore = "58",
                specialFish = false,
                nameSuffix = "<color=#5EFF6DFF>（Normal）</color>",
                des = "Profile：\nLikes to scare people in the dark.",
                previewCameraSize = 6,
                hitColor = new Color(107, 120, 120, 255),
                hitColor2D = new Color(236, 109, 63, 255),
                effectScale = 0.6f,
                fishHitSound = "FishSound1",
                is2D = true,
            },
            new FishDataConfig()
            {
                fishType = 17,
                fishOrginType = 120,
                ResName = "fish_120",
                fishName = "Bomb fish",
                fishScore = "50",
                specialFish = false,
                nameSuffix = "<color=#5EFF6DFF>（Normal）</color>",
                des = "Profile：\nThere was a small fire in the head at the beginning of the birth.",
                previewCameraSize = 4,
                hitColor = new Color(204, 120, 120, 255),
                hitColor2D = new Color(255, 171, 126, 255),
                effectScale = 0.6f,
                is2D = true,
            },
            new FishDataConfig()
            {
                fishType = 16,
                fishOrginType = 117,
                ResName = "fish_117",
                fishName = "Swordfish",
                fishScore = "40",
                specialFish = false,
                nameSuffix = "<color=#5EFF6DFF>（Normal）</color>",
                des = "Profile：\nNo one can stop him once he picks up speed.",
                previewCameraSize = 6,
                previewOffset = {x = 0, y = 0},
                hitColor = new Color(255, 120, 120, 255),
                hitColor2D = new Color(238, 132, 89, 255),
                effectScale = 1,
                is2D = true,
            },
            new FishDataConfig()
            {
                fishType = 15,
                fishOrginType = 114,
                ResName = "fish_114",
                fishName = "Earth Catfish",
                fishScore = "35",
                specialFish = false,
                nameSuffix = "<color=#5EFF6DFF>（Normal）</color>",
                des = "Profile：\nThe age is not big, but the generation is not small.",
                previewCameraSize = 5,
                previewOffset = {x = 0, y = 0},
                hitColor = new Color(242, 120, 120, 255),
                hitColor2D = new Color(238, 91, 37, 255),
                effectScale = 0.8f,
                is2D = true,
            },
            new FishDataConfig()
            {
                fishType = 14,
                fishOrginType = 115,
                ResName = "fish_115",
                fishName = "Chilly Fish",
                fishScore = "30",
                specialFish = false,
                nameSuffix = "<color=#5EFF6DFF>（Normal）</color>",
                des = "Profile：\nIce cold appearance of a guy who is difficult to approach.",
                previewCameraSize = 5.5f,
                previewOffset = {x = 0, y = 0},
                hitColor = new Color(210, 120, 120, 255),
                hitColor2D = new Color(253, 163, 123, 255),
                effectScale = 0.8f,
                is2D = true,
            },
            new FishDataConfig()
            {
                fishType = 13,
                fishOrginType = 110,
                ResName = "fish_110",
                fishName = "Peacock Fish",
                fishScore = "20",
                specialFish = false,
                nameSuffix = "<color=#5EFF6DFF>（Normal）</color>",
                des = "Profile：\nPeacock fish don't seem to be interested in anything.",
                previewCameraSize = 4.5f,
                hitColor = new Color(186, 120, 120, 255),
                hitColor2D = new Color(244, 111, 63, 255),
                effectScale = 0.6f,
                is2D = true,
            },
            new FishDataConfig()
            {
                fishType = 12,
                fishOrginType = 118,
                ResName = "fish_118",
                fishName = "Fly Fish",
                fishScore = "18",
                specialFish = false,
                nameSuffix = "<color=#5EFF6DFF>（Normal）</color>",
                des = "Profile：\nThe dream is to become an elegant water ballet dancer.",
                previewCameraSize = 5.5f,
                previewOffset = {x = 0, y = 0},
                hitColor = new Color(225, 120, 120, 255),
                hitColor2D = new Color(246, 94, 90, 255),
                effectScale = 1,
                is2D = true,
            },
            new FishDataConfig()
            {
                fishType = 11,
                fishOrginType = 116,
                ResName = "fish_116",
                fishName = "Hellfire Fish",
                fishScore = "15",
                specialFish = false,
                nameSuffix = "<color=#5EFF6DFF>（Normal）</color>",
                des = "Profile：\nGrumpy and windy.",
                previewCameraSize = 6,
                previewOffset = {x = 0, y = 0},
                hitColor = new Color(171, 120, 120, 255),
                hitColor2D = new Color(248, 148, 104, 255),
                effectScale = 0.9f,
                is2D = true,
            },
            new FishDataConfig()
            {
                fishType = 10,
                fishOrginType = 112,
                ResName = "fish_112",
                fishName = "Turtle",
                fishScore = "12",
                specialFish = false,
                nameSuffix = "<color=#5EFF6DFF>（Normal）</color>",
                des = "Profile：\nLiving fossils in the ocean.",
                previewCameraSize = 4,
                previewOffset = {x = 0, y = 0},
                hitColor = new Color(199, 120, 120, 255),
                hitColor2D = new Color(255, 124, 98, 255),
                effectScale = 0.6f,
                is2D = false,
            },
            new FishDataConfig()
            {
                fishType = 9,
                fishOrginType = 111,
                ResName = "fish_111",
                fishName = "Frog",
                fishScore = "10",
                specialFish = false,
                nameSuffix = "<color=#5EFF6DFF>（Normal）</color>",
                des = "Profile：\nAs long as he knows the things that everyone will also be the first to know.",
                previewCameraSize = 8,
                hitColor = new Color(107, 120, 120, 255),
                hitColor2D = new Color(255, 96, 49, 255),
                is2D = true,
            },
            new FishDataConfig()
            {
                fishType = 8,
                fishOrginType = 107,
                ResName = "fish_107",
                fishName = "Colorful Fish",
                fishScore = "9",
                specialFish = false,
                nameSuffix = "<color=#5EFF6DFF>（Normal）</color>",
                des = "Profile：\nOverly intelligent, just not at all temperamental.",
                previewCameraSize = 4,
                hitColor = new Color(173, 120, 120, 255),
                hitColor2D = new Color(253, 106, 73, 255),
                is2D = true,
            },
            new FishDataConfig()
            {
                fishType = 7,
                fishOrginType = 106,
                ResName = "fish_106",
                fishName = "Lionfish",
                fishScore = "8",
                specialFish = false,
                nameSuffix = "<color=#5EFF6DFF>（Normal）</color>",
                des = "Profile：\nProud and arrogant, always thinking that they are the overlords of the sea floor.",
                previewCameraSize = 4,
                hitColor = new Color(118, 120, 120, 255),
                hitColor2D = new Color(251, 126, 44, 255),
                is2D = true,
            },
            new FishDataConfig()
            {
                fishType = 6,
                fishOrginType = 105,
                ResName = "fish_105",
                fishName = "Goldfish",
                fishScore = "7",
                specialFish = false,
                nameSuffix = "<color=#5EFF6DFF>（Normal）</color>",
                des = "Profile：\nThe natural growth has a pair of large eyes.",
                previewCameraSize = 3,
                hitColor = new Color(182, 120, 120, 255),
                hitColor2D = new Color(251, 115, 115, 255),
                effectScale = 0.4f,
                is2D = true,
            },
            new FishDataConfig()
            {
                fishType = 5,
                fishOrginType = 108,
                ResName = "fish_108",
                fishName = "Clown Fish",
                fishScore = "6",
                specialFish = false,
                nameSuffix = "<color=#5EFF6DFF>（Normal）</color>",
                des = "Profile：\nLovely appearance, always loved by everyone.",
                previewCameraSize = 3,
                hitColor = new Color(234, 120, 120, 255),
                hitColor2D = new Color(255, 109, 109, 255),
                effectScale = 0.4f,
                is2D = true,
            },
            new FishDataConfig()
            {
                fishType = 4,
                fishOrginType = 104,
                ResName = "fish_104",
                fishName = "Tropical Fish",
                fishScore = "5",
                specialFish = false,
                nameSuffix = "<color=#5EFF6DFF>（Normal）</color>",
                des = "Profile：\nEnjoys sunbathing",
                previewCameraSize = 3,
                hitColor = new Color(251, 120, 120, 255),
                hitColor2D = new Color(255, 103, 103, 255),
                is2D = true,
            },
            new FishDataConfig()
            {
                fishType = 3,
                fishOrginType = 103,
                ResName = "fish_103",
                fishName = "Halibut",
                fishScore = "4",
                specialFish = false,
                nameSuffix = "<color=#5EFF6DFF>（Normal）</color>",
                des = "Profile：\nAlways gaze at the sea with sunshine.",
                previewCameraSize = 3.5f,
                hitColor = new Color(204, 120, 120, 255),
                hitColor2D = new Color(255, 58, 58, 255),
                effectScale = 0.4f,
                is2D = true,
            },
            new FishDataConfig()
            {
                fishType = 2,
                fishOrginType = 101,
                ResName = "fish_101",
                fishName = "Butterfly Fish",
                fishScore = "3",
                specialFish = false,
                nameSuffix = "<color=#5EFF6DFF>（Normal）</color>",
                des = "Profile：\nIt is often said to be the little princess ",
                previewCameraSize = 4,
                hitColor = new Color(238, 107, 107, 255),
                hitColor2D = new Color(238, 107, 107, 255),
                effectScale = 0.4f,
                is2D = true,
            },
            new FishDataConfig()
            {
                fishType = 1,
                fishOrginType = 102,
                ResName = "fish_102",
                fishName = "Dragonfly fish",
                fishScore = "2",
                specialFish = false,
                nameSuffix = "<color=#5EFF6DFF>（Normal）</color>",
                des = "Profile：\nLike to hide in the grass and play hide-and-seek.",
                previewCameraSize = 4,
                hitColor = new Color(199, 120, 120, 255),
                hitColor2D = new Color(199, 56, 56, 255),
                effectScale = 0.3f,
                is2D = true,
            },
        };

        //检测是否是不是Special鱼
        public static bool CheckIsNormalFish(int fishType)
        {
            FishDataConfig fish = Fish.FindItem(p => p.fishOrginType == fishType);
            if (fish == null) return false;
            return !fish.specialFish;
        }

        //检测是否是龙
        public static bool CheckIsDragon(int fishType)
        {
            FishDataConfig fish = Fish.FindItem(p => p.fishOrginType == fishType);
            if (fish == null) return false;
            return fish.fishOrginType == 136 || fish.fishOrginType == 144;
        }

        public static bool CheckIsElectricDragon(int fishType)
        {
            FishDataConfig fish = Fish.FindItem(p => p.fishOrginType == fishType);
            if (fish == null) return false;
            return fish.fishOrginType == 144;
        }

        //检测是否一网打击鱼
        public static bool CheckIsAcedFish(int fishType)
        {
            FishDataConfig fish = Fish.FindItem(p => p.fishOrginType == fishType);
            if (fish == null) return false;
            return fish.fishOrginType == 143;
        }

        //检测是否使用转盘
        public static bool CheckUseWheel(int score)
        {
            if (score >= 15 && score < 80) return true;
            return false;
        }

        //检测是否是聚宝盆
        public static bool CheckIsTreasureBowl(int fishType)
        {
            FishDataConfig fish = Fish.FindItem(p => p.fishOrginType == fishType);
            if (fish == null) return false;
            return fish.fishOrginType == 145;
        }

        public static int GetFishScore(int fishType)
        {
            FishDataConfig fish = Fish.FindItem(p => p.fishOrginType == fishType);
            if (fish == null) return -1;
            int.TryParse(fish.fishScore, out var score);
            return score;
        }

        //检测是否使用spine动画的奖励
        public static int CheckUseSpine(int score)
        {
            if (score >= 80 && score < 110) return 1;

            else if (score >= 110 && score < 120) return 2;

            else if (score >= 120 && score < 150) return 3;

            else if (score >= 150) return 4;

            return 0;
        }

        public const int AcedFishType = 143;

        public const string AwardFishText = "Bonus Fish";

        //public static TreasureBow TreasureBowlConfig = new TreasureBow() 
        //{
        //    Scale = new Dictionary<int, float>()
        //    {
        //        [0] = 2,
        //        [1] = 2,
        //        [2] = 2.8f,
        //        [3] = 3.3f,
        //    }
        //};

        public class TreasureBow
        {
            public Dictionary<int, float> Scale;
            public Dictionary<int, bool> ShowRotate;
            public Dictionary<int, int> captureEffectType;
            public Dictionary<int, int> StageNum;
        }

        public static TreasureBow TreasureBowlConfig = new TreasureBow()
        {
            Scale = new Dictionary<int, float>()
            {
                {0, 2.1f},
                {1, 2.1f},
                {2, 2.4f},
                {3, 2.7f},
                {4, 3f},
                {5, 3.3f},
            },
            ShowRotate = new Dictionary<int, bool>()
            {
                {0, false},
                {1, false},
                {2, false},
                {3, true},
                {4, false},
                {5, true},
            },
            captureEffectType = new Dictionary<int, int>()
            {
                {0, 1},
                {1, 1},
                {2, 1},
                {3, 2},
                {4, 2},
                {5, 3},
            },
            StageNum = new Dictionary<int, int>()
            {
                {1, 0},
                {2, 3},
                {3, 5},
            }
        };

        public static string GetFishImageBundle(int fishId)
        {
            if (fishId == 144) return "res_electroDragon";
            else if (fishId == 145) return "res_TreasureBowl";
            else if (fishId == 136) return "res_TreasureBowl";
            else return "res_fishmodel";
        }


        public static Dictionary<int, Vector3> TreasureBowlRotation = new Dictionary<int, Vector3>()
        {
            //面向右侧
            {1, new Vector3() {x = 21.024f, y = 152.668f, z = -15.053f}},
            //面向左侧
            {2, new Vector3() {x = 20.6f, y = 206.8f, z = 13.1f}},
        };

        public static List<Dictionary<string, int>> LoadFishList = new List<Dictionary<string, int>>()
        {
            new Dictionary<string, int>() {{"fishType", 2}, {"num", 10}, {"maxNum", 20}},
            new Dictionary<string, int>() {{"fishType", 1}, {"num", 10}, {"maxNum", 30}},
            new Dictionary<string, int>() {{"fishType", 3}, {"num", 5}, {"maxNum", 15}},
            new Dictionary<string, int>() {{"fishType", 4}, {"num", 5}, {"maxNum", 15}},
            new Dictionary<string, int>() {{"fishType", 6}, {"num", 1}, {"maxNum", 5}},
            new Dictionary<string, int>() {{"fishType", 7}, {"num", 5}, {"maxNum", 15}},
            new Dictionary<string, int>() {{"fishType", 8}, {"num", 5}, {"maxNum", 15}},
            new Dictionary<string, int>() {{"fishType", 5}, {"num", 5}, {"maxNum", 15}},
            new Dictionary<string, int>() {{"fishType", 26}, {"num", 1}, {"maxNum", 5}},
            new Dictionary<string, int>() {{"fishType", 13}, {"num", 1}, {"maxNum", 5}},

            new Dictionary<string, int>() {{"fishType", 9}, {"num", 5}, {"maxNum", 10}},
            new Dictionary<string, int>() {{"fishType", 10}, {"num", 5}, {"maxNum", 10}},
            new Dictionary<string, int>() {{"fishType", 21}, {"num", 1}, {"maxNum", 5}},
            new Dictionary<string, int>() {{"fishType", 15}, {"num", 1}, {"maxNum", 5}},
            new Dictionary<string, int>() {{"fishType", 14}, {"num", 1}, {"maxNum", 5}},
            new Dictionary<string, int>() {{"fishType", 11}, {"num", 1}, {"maxNum", 5}},
            new Dictionary<string, int>() {{"fishType", 16}, {"num", 5}, {"maxNum", 10}},
            new Dictionary<string, int>() {{"fishType", 12}, {"num", 5}, {"maxNum", 15}},
            new Dictionary<string, int>() {{"fishType", 19}, {"num", 1}, {"maxNum", 5}},
            new Dictionary<string, int>() {{"fishType", 18}, {"num", 1}, {"maxNum", 5}},

            new Dictionary<string, int>() {{"fishType", 38}, {"num", 1}, {"maxNum", 5}},
            new Dictionary<string, int>() {{"fishType", 20}, {"num", 1}, {"maxNum", 5}},
            new Dictionary<string, int>() {{"fishType", 22}, {"num", 0}, {"maxNum", 2}},
            new Dictionary<string, int>() {{"fishType", 40}, {"num", 0}, {"maxNum", 2}},
            new Dictionary<string, int>() {{"fishType", 41}, {"num", 0}, {"maxNum", 2}},
            new Dictionary<string, int>() {{"fishType", 23}, {"num", 0}, {"maxNum", 2}},
            new Dictionary<string, int>() {{"fishType", 42}, {"num", 0}, {"maxNum", 2}},
            new Dictionary<string, int>() {{"fishType", 25}, {"num", 0}, {"maxNum", 1}},
            new Dictionary<string, int>() {{"fishType", 24}, {"num", 0}, {"maxNum", 3}},

            new Dictionary<string, int>() {{"fishType", 39}, {"num", 0}, {"maxNum", 2}},
            new Dictionary<string, int>() {{"fishType", 29}, {"num", 0}, {"maxNum", 1}},
            new Dictionary<string, int>() {{"fishType", 33}, {"num", 0}, {"maxNum", 1}},
            new Dictionary<string, int>() {{"fishType", 32}, {"num", 0}, {"maxNum", 1}},
            new Dictionary<string, int>() {{"fishType", 37}, {"num", 0}, {"maxNum", 1}},
            new Dictionary<string, int>() {{"fishType", 28}, {"num", 0}, {"maxNum", 1}},
            new Dictionary<string, int>() {{"fishType", 27}, {"num", 0}, {"maxNum", 1}},
            new Dictionary<string, int>() {{"fishType", 34}, {"num", 0}, {"maxNum", 1}},
            new Dictionary<string, int>() {{"fishType", 31}, {"num", 0}, {"maxNum", 1}},
            new Dictionary<string, int>() {{"fishType", 36}, {"num", 0}, {"maxNum", 1}},
            new Dictionary<string, int>() {{"fishType", 35}, {"num", 0}, {"maxNum", 1}},
        };
    }
}